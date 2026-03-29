#!/usr/bin/env python3
import argparse
import json
import math
import signal
import sys
import time
import uuid
from collections import deque
from urllib.parse import urlparse

import paho.mqtt.client as mqtt


REQUIRED_RAW_FIELDS = [
    "msg_id",
    "source_id",
    "ts_host_ms",
    "ts_reader_ms",
    "reader_id",
    "antenna_id",
    "epc",
    "rssi",
    "phase_raw",
    "phase_deg",
    "channel_index",
    "tag_seen_count",
    "tx_power_index",
]


class FeatureService:
    def __init__(self, args):
        self.args = args
        self.running = True
        self.last_stats_at = time.time()
        self.last_emit_at_ms = 0

        self.events_in = 0
        self.events_valid = 0
        self.events_invalid = 0
        self.events_ignored_antenna = 0
        self.features_out = 0
        self.publish_errors = 0

        self.state = {}

        self.client = mqtt.Client(client_id=args.mqtt_client_id)
        if args.mqtt_username:
            self.client.username_pw_set(args.mqtt_username, args.mqtt_password)
        self.client.reconnect_delay_set(min_delay=1, max_delay=10)
        self.client.on_connect = self.on_connect
        self.client.on_disconnect = self.on_disconnect
        self.client.on_message = self.on_message

    def connect_and_loop(self):
        host, port = parse_mqtt_broker_url(self.args.mqtt_broker_url)
        self.client.connect(host, port, keepalive=30)
        self.client.loop_start()

        while self.running:
            now_ms = int(time.time() * 1000)
            if now_ms - self.last_emit_at_ms >= self.args.emit_every_ms:
                self.emit_features(now_ms)
                self.last_emit_at_ms = now_ms

            now = time.time()
            if now - self.last_stats_at >= 5.0:
                print(
                    "stats events_in={} valid={} invalid={} ignored_antenna={} features_out={} publish_errors={} active_keys={}".format(
                        self.events_in,
                        self.events_valid,
                        self.events_invalid,
                        self.events_ignored_antenna,
                        self.features_out,
                        self.publish_errors,
                        len(self.state),
                    )
                )
                self.last_stats_at = now
            time.sleep(0.05)

        self.client.loop_stop()
        try:
            self.client.disconnect()
        except Exception:
            pass

    def stop(self, *_):
        self.running = False

    def on_connect(self, client, userdata, flags, rc):
        if rc != 0:
            print("MQTT connect failed rc={}".format(rc), file=sys.stderr)
            return
        client.subscribe(self.args.input_topic, qos=1)
        print(
            "Connected MQTT {} and subscribed {}".format(
                self.args.mqtt_broker_url, self.args.input_topic
            )
        )

    def on_disconnect(self, client, userdata, rc):
        if rc != 0 and self.running:
            print("MQTT disconnected unexpectedly rc={}".format(rc), file=sys.stderr)

    def on_message(self, client, userdata, msg):
        self.events_in += 1
        try:
            payload = json.loads(msg.payload.decode("utf-8"))
            ensure_payload(payload)

            antenna_id = as_int(payload["antenna_id"], "antenna_id")
            if antenna_id not in (1, 2, 3):
                self.events_ignored_antenna += 1
                return

            reader_id = as_str(payload["reader_id"])
            epc = as_str(payload["epc"])
            ts_host_ms = as_int(payload["ts_host_ms"], "ts_host_ms")
            rssi = as_float(payload["rssi"], "rssi")
            phase_deg = as_float(payload["phase_deg"], "phase_deg")

            if not is_finite(rssi) or not is_finite(phase_deg):
                raise ValueError("rssi/phase_deg must be finite numbers")

            key = (reader_id, epc)
            if key not in self.state:
                self.state[key] = {
                    1: deque(),
                    2: deque(),
                    3: deque(),
                    "last_seen_ms": ts_host_ms,
                }

            self.state[key][antenna_id].append((ts_host_ms, rssi, phase_deg))
            self.state[key]["last_seen_ms"] = ts_host_ms
            self.prune_key(key, ts_host_ms)
            self.events_valid += 1
        except ValueError as ex:
            self.events_invalid += 1
            print("Payload validation failed: {}".format(ex), file=sys.stderr)
        except Exception as ex:
            self.events_invalid += 1
            print("Message handling failed: {}".format(ex), file=sys.stderr)

    def prune_key(self, key, now_ms):
        cutoff = now_ms - self.args.window_ms
        for antenna_id in (1, 2, 3):
            q = self.state[key][antenna_id]
            while q and q[0][0] < cutoff:
                q.popleft()

    def emit_features(self, now_ms):
        to_delete = []
        for key, record in self.state.items():
            reader_id, epc = key
            self.prune_key(key, now_ms)
            ant1 = list(record[1])
            ant2 = list(record[2])
            ant3 = list(record[3])

            if not ant1 and not ant2 and not ant3:
                last_seen_ms = int(record.get("last_seen_ms", 0))
                if now_ms - last_seen_ms > self.args.idle_ttl_ms:
                    to_delete.append(key)
                continue

            feature = build_feature_payload(
                now_ms=now_ms,
                window_ms=self.args.window_ms,
                reader_id=reader_id,
                epc=epc,
                ant1=ant1,
                ant2=ant2,
                ant3=ant3,
            )

            topic = (
                self.args.output_root
                + "/"
                + sanitize_topic_token(reader_id)
                + "/epc/"
                + sanitize_topic_token(epc)
                + "/features-rolling"
            )
            self.publish(topic, feature)

        for key in to_delete:
            self.state.pop(key, None)

    def publish(self, topic, payload):
        try:
            body = json.dumps(payload, separators=(",", ":"))
            result = self.client.publish(topic, body, qos=1, retain=False)
            if result.rc != mqtt.MQTT_ERR_SUCCESS:
                raise RuntimeError("publish rc={}".format(result.rc))
            self.features_out += 1
        except Exception as ex:
            self.publish_errors += 1
            print("Feature publish failed topic={} err={}".format(topic, ex), file=sys.stderr)


def build_feature_payload(now_ms, window_ms, reader_id, epc, ant1, ant2, ant3):
    rssi1 = [x[1] for x in ant1]
    rssi2 = [x[1] for x in ant2]
    rssi3 = [x[1] for x in ant3]
    phase1 = [x[2] for x in ant1]
    phase2 = [x[2] for x in ant2]
    phase3 = [x[2] for x in ant3]

    count_ant1 = len(ant1)
    count_ant2 = len(ant2)
    count_ant3 = len(ant3)
    both = count_ant1 > 0 and count_ant2 > 0

    rssi_mean_ant1 = mean_or_none(rssi1)
    rssi_mean_ant2 = mean_or_none(rssi2)
    rssi_mean_ant3 = mean_or_none(rssi3)
    phase_mean_ant1 = mean_or_none(phase1)
    phase_mean_ant2 = mean_or_none(phase2)
    phase_mean_ant3 = mean_or_none(phase3)

    return {
        "feature_version": 1,
        "ts_emit_ms": now_ms,
        "window_ms": window_ms,
        "reader_id": reader_id,
        "epc": epc,
        "count_ant1": count_ant1,
        "count_ant2": count_ant2,
        "count_ant3": count_ant3,
        "both_antennas_present": both,
        "rssi_mean_ant1": rounded_or_none(rssi_mean_ant1),
        "rssi_mean_ant2": rounded_or_none(rssi_mean_ant2),
        "rssi_mean_ant3": rounded_or_none(rssi_mean_ant3),
        "rssi_std_ant1": rounded_or_none(stddev_or_none(rssi1)),
        "rssi_std_ant2": rounded_or_none(stddev_or_none(rssi2)),
        "rssi_std_ant3": rounded_or_none(stddev_or_none(rssi3)),
        "rssi_delta_ant1_minus_ant2": rounded_or_none(
            delta_or_none(rssi_mean_ant1, rssi_mean_ant2)
        ),
        "phase_mean_ant1": rounded_or_none(phase_mean_ant1),
        "phase_mean_ant2": rounded_or_none(phase_mean_ant2),
        "phase_mean_ant3": rounded_or_none(phase_mean_ant3),
        "phase_std_ant1": rounded_or_none(stddev_or_none(phase1)),
        "phase_std_ant2": rounded_or_none(stddev_or_none(phase2)),
        "phase_std_ant3": rounded_or_none(stddev_or_none(phase3)),
        "phase_delta_ant1_minus_ant2": rounded_or_none(
            delta_or_none(phase_mean_ant1, phase_mean_ant2)
        ),
        "age_ms_ant1": age_ms_or_none(ant1, now_ms),
        "age_ms_ant2": age_ms_or_none(ant2, now_ms),
        "age_ms_ant3": age_ms_or_none(ant3, now_ms),
    }


def mean_or_none(values):
    if not values:
        return None
    return sum(values) / float(len(values))


def stddev_or_none(values):
    if not values:
        return None
    mu = mean_or_none(values)
    var = sum((x - mu) * (x - mu) for x in values) / float(len(values))
    return math.sqrt(var)


def delta_or_none(a, b):
    if a is None or b is None:
        return None
    return a - b


def age_ms_or_none(samples, now_ms):
    if not samples:
        return None
    return int(now_ms - samples[-1][0])


def rounded_or_none(value):
    if value is None:
        return None
    return round(float(value), 3)


def ensure_payload(payload):
    for key in REQUIRED_RAW_FIELDS:
        if key not in payload:
            raise ValueError("missing field '{}'".format(key))


def as_int(value, field_name):
    try:
        return int(value)
    except Exception:
        raise ValueError("field '{}' must be int-compatible".format(field_name))


def as_float(value, field_name):
    try:
        return float(value)
    except Exception:
        raise ValueError("field '{}' must be float-compatible".format(field_name))


def as_str(value):
    if value is None:
        return ""
    return str(value)


def is_finite(value):
    return not (math.isnan(value) or math.isinf(value))


def sanitize_topic_token(token):
    if token is None or token == "":
        return "unknown"
    return str(token).replace("+", "_").replace("#", "_").replace("/", "_")


def parse_mqtt_broker_url(url):
    parsed = urlparse(url)
    if parsed.scheme not in ("tcp", "mqtt"):
        raise ValueError("mqtt broker url must start with tcp:// or mqtt://")
    if not parsed.hostname:
        raise ValueError("mqtt broker url missing host")
    port = parsed.port if parsed.port else 1883
    return parsed.hostname, port


def parse_args():
    parser = argparse.ArgumentParser(description="Rolling RFID feature publisher")
    parser.add_argument("--mqtt-broker-url", default="tcp://127.0.0.1:1883")
    parser.add_argument("--mqtt-client-id", default="rfid-feature-rolling-{}".format(uuid.uuid4()))
    parser.add_argument("--mqtt-username", default="")
    parser.add_argument("--mqtt-password", default="")

    parser.add_argument("--input-topic", default="rfid/+/antenna/+/raw-read")
    parser.add_argument("--output-root", default="rfid")

    parser.add_argument("--window-ms", type=int, default=1000)
    parser.add_argument("--emit-every-ms", type=int, default=250)
    parser.add_argument("--idle-ttl-ms", type=int, default=5000)

    return parser.parse_args()


def main():
    args = parse_args()
    if args.window_ms <= 0:
        raise ValueError("--window-ms must be > 0")
    if args.emit_every_ms <= 0:
        raise ValueError("--emit-every-ms must be > 0")
    if args.idle_ttl_ms <= 0:
        raise ValueError("--idle-ttl-ms must be > 0")

    service = FeatureService(args)
    signal.signal(signal.SIGINT, service.stop)
    signal.signal(signal.SIGTERM, service.stop)
    service.connect_and_loop()


if __name__ == "__main__":
    main()
