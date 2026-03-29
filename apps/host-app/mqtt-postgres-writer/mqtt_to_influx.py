#!/usr/bin/env python3
import argparse
import json
import signal
import sys
import time
import uuid
from urllib.parse import urlparse

import paho.mqtt.client as mqtt
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS


REQUIRED_FIELDS = [
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


class Collector:
    def __init__(self, args):
        self.args = args
        self.running = True
        self.received = 0
        self.written = 0
        self.parse_errors = 0
        self.write_errors = 0
        self.last_stats_at = time.time()

        self.influx_client = InfluxDBClient(
            url=args.influx_url,
            token=args.influx_token,
            org=args.influx_org,
            timeout=10000,
        )
        self.write_api = self.influx_client.write_api(write_options=SYNCHRONOUS)

        self.mqtt_client = mqtt.Client(client_id=args.mqtt_client_id)
        if args.mqtt_username:
            self.mqtt_client.username_pw_set(args.mqtt_username, args.mqtt_password)
        self.mqtt_client.on_connect = self.on_connect
        self.mqtt_client.on_message = self.on_message
        self.mqtt_client.on_disconnect = self.on_disconnect

    def connect_and_loop(self):
        host, port = parse_mqtt_broker_url(self.args.mqtt_broker_url)
        self.mqtt_client.connect(host, port, keepalive=30)
        self.mqtt_client.loop_start()

        while self.running:
            now = time.time()
            if now - self.last_stats_at >= 5.0:
                print(
                    "stats received={} written={} parse_errors={} write_errors={}".format(
                        self.received, self.written, self.parse_errors, self.write_errors
                    )
                )
                self.last_stats_at = now
            time.sleep(0.2)

        self.mqtt_client.loop_stop()
        try:
            self.mqtt_client.disconnect()
        except Exception:
            pass
        self.influx_client.close()

    def stop(self, *_):
        self.running = False

    def on_connect(self, client, userdata, flags, rc):
        if rc != 0:
            print("MQTT connect failed rc={}".format(rc), file=sys.stderr)
            return
        client.subscribe(self.args.mqtt_topic, qos=1)
        print("Connected MQTT {} and subscribed {}".format(self.args.mqtt_broker_url, self.args.mqtt_topic))

    def on_disconnect(self, client, userdata, rc):
        if rc != 0 and self.running:
            print("MQTT disconnected unexpectedly rc={}".format(rc), file=sys.stderr)

    def on_message(self, client, userdata, msg):
        self.received += 1
        try:
            payload = json.loads(msg.payload.decode("utf-8"))
            ensure_payload(payload)
            point = payload_to_point(payload)
            self.write_api.write(
                bucket=self.args.influx_bucket,
                org=self.args.influx_org,
                record=point,
            )
            self.written += 1
        except ValueError as ex:
            self.parse_errors += 1
            print("Payload validation failed: {}".format(ex), file=sys.stderr)
        except Exception as ex:
            self.write_errors += 1
            print("Influx write failed: {}".format(ex), file=sys.stderr)


def ensure_payload(payload):
    for key in REQUIRED_FIELDS:
        if key not in payload:
            raise ValueError("missing field '{}'".format(key))


def payload_to_point(payload):
    ts_host_ms = as_int(payload["ts_host_ms"], "ts_host_ms")
    point = Point("rfid_raw_reads")
    point.tag("reader_id", as_str(payload["reader_id"]))
    point.tag("antenna_id", str(as_int(payload["antenna_id"], "antenna_id")))
    point.tag("epc", as_str(payload["epc"]))
    point.field("msg_id", as_str(payload["msg_id"]))
    point.field("source_id", as_str(payload["source_id"]))
    point.field("ts_reader_ms", as_int(payload["ts_reader_ms"], "ts_reader_ms"))
    point.field("rssi", as_int(payload["rssi"], "rssi"))
    point.field("phase_raw", as_int(payload["phase_raw"], "phase_raw"))
    point.field("phase_deg", as_float(payload["phase_deg"], "phase_deg"))
    point.field("channel_index", as_int(payload["channel_index"], "channel_index"))
    point.field("tag_seen_count", as_int(payload["tag_seen_count"], "tag_seen_count"))
    point.field("tx_power_index", as_int(payload["tx_power_index"], "tx_power_index"))
    point.time(ts_host_ms, WritePrecision.MS)
    return point


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


def parse_mqtt_broker_url(url):
    parsed = urlparse(url)
    if parsed.scheme not in ("tcp", "mqtt"):
        raise ValueError("mqtt broker url must start with tcp:// or mqtt://")
    if not parsed.hostname:
        raise ValueError("mqtt broker url missing host")
    port = parsed.port if parsed.port else 1883
    return parsed.hostname, port


def parse_args():
    parser = argparse.ArgumentParser(description="MQTT to InfluxDB collector for RFID raw reads")
    parser.add_argument("--mqtt-broker-url", default="tcp://127.0.0.1:1883")
    parser.add_argument("--mqtt-topic", default="rfid/+/antenna/+/raw-read")
    parser.add_argument("--mqtt-client-id", default="rfid-raw-influx-{}".format(uuid.uuid4()))
    parser.add_argument("--mqtt-username", default="")
    parser.add_argument("--mqtt-password", default="")

    parser.add_argument("--influx-url", required=True)
    parser.add_argument("--influx-token", required=True)
    parser.add_argument("--influx-org", required=True)
    parser.add_argument("--influx-bucket", required=True)
    return parser.parse_args()


def main():
    args = parse_args()
    collector = Collector(args)
    signal.signal(signal.SIGINT, collector.stop)
    signal.signal(signal.SIGTERM, collector.stop)
    collector.connect_and_loop()


if __name__ == "__main__":
    main()
