#!/usr/bin/env python3
import argparse
import json
import signal
import sys
import time
import uuid
from urllib.parse import urlparse

import paho.mqtt.client as mqtt


class LocalizationMonitor:
    def __init__(self, args):
        self.args = args
        self.running = True
        self.received = 0
        self.invalid = 0
        self.last_stats_at = time.time()

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
            now = time.time()
            if now - self.last_stats_at >= 5.0:
                print("localization monitor stats received={} invalid={}".format(self.received, self.invalid))
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
        client.subscribe(self.args.topic, qos=1)
        print("Connected MQTT {} and subscribed {}".format(self.args.mqtt_broker_url, self.args.topic))

    def on_disconnect(self, client, userdata, rc):
        if rc != 0 and self.running:
            print("MQTT disconnected unexpectedly rc={}".format(rc), file=sys.stderr)

    def on_message(self, client, userdata, msg):
        self.received += 1
        try:
            p = json.loads(msg.payload.decode("utf-8"))
            print(
                "estimate reader={} epc={} zone={} cand={} score={} conf={} both={} c1={} c2={} rssi_d={} rssi_d_corr={} phase_d={}".format(
                    as_str(p.get("reader_id")),
                    as_str(p.get("epc")),
                    as_str(p.get("zone_label")),
                    as_str(p.get("zone_candidate")),
                    fmt_num(p.get("zone_score")),
                    fmt_num(p.get("confidence")),
                    bool(p.get("both_antennas_present", False)),
                    p.get("count_ant1"),
                    p.get("count_ant2"),
                    fmt_num(p.get("rssi_delta_ant1_minus_ant2")),
                    fmt_num(p.get("rssi_delta_corrected_ant1_minus_ant2")),
                    fmt_num(p.get("phase_delta_ant1_minus_ant2")),
                )
            )
        except Exception:
            self.invalid += 1


def as_str(value):
    if value is None:
        return ""
    return str(value)


def fmt_num(value):
    if value is None:
        return "null"
    try:
        return "{:.3f}".format(float(value))
    except Exception:
        return str(value)


def parse_mqtt_broker_url(url):
    parsed = urlparse(url)
    if parsed.scheme not in ("tcp", "mqtt"):
        raise ValueError("mqtt broker url must start with tcp:// or mqtt://")
    if not parsed.hostname:
        raise ValueError("mqtt broker url missing host")
    port = parsed.port if parsed.port else 1883
    return parsed.hostname, port


def parse_args():
    parser = argparse.ArgumentParser(description="Monitor localization-stub estimates from MQTT")
    parser.add_argument("--mqtt-broker-url", default="tcp://127.0.0.1:1883")
    parser.add_argument("--mqtt-client-id", default="rfid-localization-monitor-{}".format(uuid.uuid4()))
    parser.add_argument("--mqtt-username", default="")
    parser.add_argument("--mqtt-password", default="")
    parser.add_argument("--topic", default="rfid/+/epc/+/localization-stub")
    return parser.parse_args()


def main():
    args = parse_args()
    app = LocalizationMonitor(args)
    signal.signal(signal.SIGINT, app.stop)
    signal.signal(signal.SIGTERM, app.stop)
    app.run()


if __name__ == "__main__":
    main()
