#!/usr/bin/env python3
import argparse
import json
import signal
import sys
import time
import uuid
from urllib.parse import urlparse

import paho.mqtt.client as mqtt


REQUIRED_FEATURE_FIELDS = [
    "feature_version",
    "ts_emit_ms",
    "reader_id",
    "epc",
    "count_ant1",
    "count_ant2",
    "both_antennas_present",
]


class LocalizationStub:
    def __init__(self, args):
        self.args = args
        self.running = True
        self.last_stats_at = time.time()

        self.features_in = 0
        self.features_invalid = 0
        self.estimates_out = 0
        self.publish_errors = 0

        self.state = {}

        self.client = mqtt.Client(client_id=args.mqtt_client_id)
        if args.mqtt_username:
            self.client.username_pw_set(args.mqtt_username, args.mqtt_password)
        self.client.reconnect_delay_set(min_delay=1, max_delay=10)
        self.client.on_connect = self.on_connect
        self.client.on_disconnect = self.on_disconnect
        self.client.on_message = self.on_message

    def run(self):
        host, port = parse_mqtt_broker_url(self.args.mqtt_broker_url)
        self.client.connect(host, port, keepalive=30)
        self.client.loop_start()

        while self.running:
            self.cleanup_state(int(time.time() * 1000))
            now = time.time()
            if now - self.last_stats_at >= 5.0:
                print(
                    "stub stats features_in={} invalid={} estimates_out={} publish_errors={} active_keys={}".format(
                        self.features_in,
                        self.features_invalid,
                        self.estimates_out,
                        self.publish_errors,
                        len(self.state),
                    )
                )
                self.last_stats_at = now
            time.sleep(0.2)

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
        self.features_in += 1
        try:
            feature = json.loads(msg.payload.decode("utf-8"))
            ensure_feature_payload(feature)

            estimate = self.estimate(feature)
            topic = (
                self.args.output_root
                + "/"
                + sanitize_topic_token(estimate["reader_id"])
                + "/epc/"
                + sanitize_topic_token(estimate["epc"])
                + "/localization-stub"
            )
            self.publish(topic, estimate)
        except ValueError as ex:
            self.features_invalid += 1
            print("Feature validation failed: {}".format(ex), file=sys.stderr)
        except Exception as ex:
            self.features_invalid += 1
            print("Localization stub failed: {}".format(ex), file=sys.stderr)

    def estimate(self, feature):
        reader_id = as_str(feature.get("reader_id"))
        epc = as_str(feature.get("epc"))
        ts_emit_ms = as_int(feature.get("ts_emit_ms"), "ts_emit_ms")
        count_ant1 = as_int(feature.get("count_ant1"), "count_ant1")
        count_ant2 = as_int(feature.get("count_ant2"), "count_ant2")
        both = bool(feature.get("both_antennas_present", False))

        rssi_delta = as_float_or_none(feature.get("rssi_delta_ant1_minus_ant2"))
        phase_delta = as_float_or_none(feature.get("phase_delta_ant1_minus_ant2"))
        age_ant1 = as_int_or_none(feature.get("age_ms_ant1"))
        age_ant2 = as_int_or_none(feature.get("age_ms_ant2"))

        raw_score = 0.0
        corrected_rssi_delta = rssi_delta
        if rssi_delta is not None:
            corrected_rssi_delta = rssi_delta - self.args.rssi_delta_bias_db
            clipped = clamp(corrected_rssi_delta, -self.args.max_abs_rssi_delta_db, self.args.max_abs_rssi_delta_db)
            raw_score = clipped / float(self.args.max_abs_rssi_delta_db)
        elif count_ant1 > 0 or count_ant2 > 0:
            total = float(max(count_ant1 + count_ant2, 1))
            raw_score = (count_ant1 - count_ant2) / total

        key = (reader_id, epc)
        prior = self.state.get(key)
        if prior is None:
            smooth_score = raw_score
        else:
            smooth_score = prior["score"] * (1.0 - self.args.smoothing_alpha) + raw_score * self.args.smoothing_alpha

        prior_zone = prior.get("zone_label") if prior else None
        candidate_zone = classify_zone_hysteresis(
            score=smooth_score,
            both_antennas_present=both,
            zone_threshold=self.args.zone_threshold,
            zone_hysteresis=self.args.zone_hysteresis,
            current_zone=prior_zone,
        )
        zone_label, pending_zone, pending_count = apply_debounce(
            prior_zone=prior_zone,
            prior_pending_zone=prior.get("pending_zone") if prior else None,
            prior_pending_count=prior.get("pending_count") if prior else 0,
            candidate_zone=candidate_zone,
            debounce_count=self.args.zone_debounce_count,
        )

        self.state[key] = {
            "score": smooth_score,
            "zone_label": zone_label,
            "pending_zone": pending_zone,
            "pending_count": pending_count,
            "last_seen_ms": ts_emit_ms,
        }

        confidence = compute_confidence(
            both=both,
            abs_rssi_delta=abs(corrected_rssi_delta) if corrected_rssi_delta is not None else None,
            count_ant1=count_ant1,
            count_ant2=count_ant2,
            age_ant1=age_ant1,
            age_ant2=age_ant2,
            max_abs_rssi_delta_db=self.args.max_abs_rssi_delta_db,
            min_total_reads=self.args.min_total_reads,
            stale_age_ms=self.args.stale_age_ms,
        )

        return {
            "stub_version": 1,
            "estimator": "rssi_delta_stub",
            "ts_emit_ms": ts_emit_ms,
            "reader_id": reader_id,
            "epc": epc,
            "zone_label": zone_label,
            "zone_score": round(smooth_score, 3),
            "confidence": round(confidence, 3),
            "zone_candidate": candidate_zone,
            "both_antennas_present": both,
            "count_ant1": count_ant1,
            "count_ant2": count_ant2,
            "rssi_delta_ant1_minus_ant2": round_or_none(rssi_delta),
            "rssi_delta_corrected_ant1_minus_ant2": round_or_none(corrected_rssi_delta),
            "phase_delta_ant1_minus_ant2": round_or_none(phase_delta),
            "age_ms_ant1": age_ant1,
            "age_ms_ant2": age_ant2,
            "rssi_delta_bias_db": round(self.args.rssi_delta_bias_db, 3),
            "zone_threshold": round(self.args.zone_threshold, 3),
            "zone_hysteresis": round(self.args.zone_hysteresis, 3),
            "zone_debounce_count": self.args.zone_debounce_count,
        }

    def publish(self, topic, payload):
        try:
            body = json.dumps(payload, separators=(",", ":"))
            result = self.client.publish(topic, body, qos=1, retain=False)
            if result.rc != mqtt.MQTT_ERR_SUCCESS:
                raise RuntimeError("publish rc={}".format(result.rc))
            self.estimates_out += 1
        except Exception as ex:
            self.publish_errors += 1
            print("Localization publish failed topic={} err={}".format(topic, ex), file=sys.stderr)

    def cleanup_state(self, now_ms):
        stale_keys = []
        for key, value in self.state.items():
            if now_ms - int(value.get("last_seen_ms", 0)) > self.args.idle_ttl_ms:
                stale_keys.append(key)
        for key in stale_keys:
            self.state.pop(key, None)


def ensure_feature_payload(feature):
    for key in REQUIRED_FEATURE_FIELDS:
        if key not in feature:
            raise ValueError("missing field '{}'".format(key))


def classify_zone_hysteresis(score, both_antennas_present, zone_threshold, zone_hysteresis, current_zone):
    enter = zone_threshold
    exit_threshold = max(0.0, zone_threshold - zone_hysteresis)

    if not both_antennas_present:
        if current_zone == "ANTENNA_1_BIASED":
            if score < -enter:
                return "ANTENNA_2_BIASED"
            if score <= exit_threshold:
                return "UNKNOWN"
            return "ANTENNA_1_BIASED"

        if current_zone == "ANTENNA_2_BIASED":
            if score > enter:
                return "ANTENNA_1_BIASED"
            if score >= -exit_threshold:
                return "UNKNOWN"
            return "ANTENNA_2_BIASED"

        if score > enter:
            return "ANTENNA_1_BIASED"
        if score < -enter:
            return "ANTENNA_2_BIASED"
        return "UNKNOWN"

    if current_zone == "ANTENNA_1_SIDE":
        if score < -enter:
            return "ANTENNA_2_SIDE"
        if score <= exit_threshold:
            return "BETWEEN"
        return "ANTENNA_1_SIDE"

    if current_zone == "ANTENNA_2_SIDE":
        if score > enter:
            return "ANTENNA_1_SIDE"
        if score >= -exit_threshold:
            return "BETWEEN"
        return "ANTENNA_2_SIDE"

    if score > enter:
        return "ANTENNA_1_SIDE"
    if score < -enter:
        return "ANTENNA_2_SIDE"
    return "BETWEEN"


def apply_debounce(prior_zone, prior_pending_zone, prior_pending_count, candidate_zone, debounce_count):
    if prior_zone is None:
        return candidate_zone, None, 0

    if candidate_zone == prior_zone:
        return prior_zone, None, 0

    if debounce_count <= 1:
        return candidate_zone, None, 0

    pending_zone = prior_pending_zone
    pending_count = prior_pending_count

    if pending_zone == candidate_zone:
        pending_count += 1
    else:
        pending_zone = candidate_zone
        pending_count = 1

    if pending_count >= debounce_count:
        return candidate_zone, None, 0

    return prior_zone, pending_zone, pending_count


def compute_confidence(
    both,
    abs_rssi_delta,
    count_ant1,
    count_ant2,
    age_ant1,
    age_ant2,
    max_abs_rssi_delta_db,
    min_total_reads,
    stale_age_ms,
):
    presence = 1.0 if both else 0.45
    if abs_rssi_delta is None:
        signal_strength = 0.35
    else:
        signal_strength = clamp(abs_rssi_delta / float(max_abs_rssi_delta_db), 0.0, 1.0)

    sample_quality = clamp((count_ant1 + count_ant2) / float(max(min_total_reads, 1)), 0.0, 1.0)

    max_age = 0
    if age_ant1 is not None:
        max_age = max(max_age, age_ant1)
    if age_ant2 is not None:
        max_age = max(max_age, age_ant2)
    freshness = 1.0 - clamp(max_age / float(max(stale_age_ms, 1)), 0.0, 1.0)

    confidence = 0.35 * presence + 0.35 * signal_strength + 0.20 * sample_quality + 0.10 * freshness
    return clamp(confidence, 0.0, 1.0)


def as_int(value, field_name):
    try:
        return int(value)
    except Exception:
        raise ValueError("field '{}' must be int-compatible".format(field_name))


def as_int_or_none(value):
    if value is None:
        return None
    try:
        return int(value)
    except Exception:
        return None


def as_float_or_none(value):
    if value is None:
        return None
    try:
        return float(value)
    except Exception:
        return None


def as_str(value):
    if value is None:
        return ""
    return str(value)


def clamp(value, minimum, maximum):
    return max(minimum, min(maximum, value))


def round_or_none(value):
    if value is None:
        return None
    return round(float(value), 3)


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
    parser = argparse.ArgumentParser(description="Localization stub from rolling RFID features")
    parser.add_argument("--mqtt-broker-url", default="tcp://127.0.0.1:1883")
    parser.add_argument("--mqtt-client-id", default="rfid-localization-stub-{}".format(uuid.uuid4()))
    parser.add_argument("--mqtt-username", default="")
    parser.add_argument("--mqtt-password", default="")

    parser.add_argument("--input-topic", default="rfid/+/epc/+/features-rolling")
    parser.add_argument("--output-root", default="rfid")

    parser.add_argument("--zone-threshold", type=float, default=0.20)
    parser.add_argument("--zone-hysteresis", type=float, default=0.05)
    parser.add_argument("--zone-debounce-count", type=int, default=3)
    parser.add_argument("--rssi-delta-bias-db", type=float, default=0.0)
    parser.add_argument("--max-abs-rssi-delta-db", type=float, default=12.0)
    parser.add_argument("--min-total-reads", type=int, default=12)
    parser.add_argument("--stale-age-ms", type=int, default=1500)
    parser.add_argument("--smoothing-alpha", type=float, default=0.35)
    parser.add_argument("--idle-ttl-ms", type=int, default=5000)

    return parser.parse_args()


def main():
    args = parse_args()
    if args.zone_threshold < 0.0 or args.zone_threshold > 1.0:
        raise ValueError("--zone-threshold must be between 0 and 1")
    if args.zone_hysteresis < 0.0 or args.zone_hysteresis > args.zone_threshold:
        raise ValueError("--zone-hysteresis must be between 0 and zone-threshold")
    if args.zone_debounce_count <= 0:
        raise ValueError("--zone-debounce-count must be > 0")
    if args.max_abs_rssi_delta_db <= 0.0:
        raise ValueError("--max-abs-rssi-delta-db must be > 0")
    if args.min_total_reads <= 0:
        raise ValueError("--min-total-reads must be > 0")
    if args.stale_age_ms <= 0:
        raise ValueError("--stale-age-ms must be > 0")
    if args.idle_ttl_ms <= 0:
        raise ValueError("--idle-ttl-ms must be > 0")
    if args.smoothing_alpha <= 0.0 or args.smoothing_alpha > 1.0:
        raise ValueError("--smoothing-alpha must be in (0,1]")

    app = LocalizationStub(args)
    signal.signal(signal.SIGINT, app.stop)
    signal.signal(signal.SIGTERM, app.stop)
    app.run()


if __name__ == "__main__":
    main()
