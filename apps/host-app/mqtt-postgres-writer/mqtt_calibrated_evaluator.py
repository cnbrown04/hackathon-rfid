#!/usr/bin/env python3
import argparse
import csv
import json
import math
import signal
import sys
import time
import uuid
from urllib.parse import urlparse

import paho.mqtt.client as mqtt


class Evaluator:
    def __init__(self, args):
        self.args = args
        self.running = True
        self.start_ts = None
        self.last_stats_at = time.time()

        self.calibration = load_calibration_csv(args.calibration_csv_path, args.epc_prefix)
        self.test_truth = {
            epc: v for epc, v in self.calibration.items() if v.get("is_test", False)
        }
        if not self.test_truth:
            raise ValueError("No test=true rows found in calibration CSV")

        self.total_in = 0
        self.total_used = 0
        self.total_ignored = 0
        self.invalid = 0

        self.rows = []
        self.last_line_by_epc = {}
        self.switch_count_by_epc = {}

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
        self.start_ts = time.time()

        while self.running:
            now = time.time()
            if now - self.last_stats_at >= 5.0:
                print(
                    "eval stats in={} used={} ignored={} invalid={} test_epcs={}".format(
                        self.total_in,
                        self.total_used,
                        self.total_ignored,
                        self.invalid,
                        len(self.test_truth),
                    )
                )
                self.last_stats_at = now

            if now - self.start_ts >= self.args.duration_sec:
                self.running = False
            time.sleep(0.2)

        self.client.loop_stop()
        try:
            self.client.disconnect()
        except Exception:
            pass

        metrics = self.compute_metrics()
        write_outputs(metrics, self.rows, self.args.output_json, self.args.output_csv)
        print("Evaluation complete. Wrote {} and {}".format(self.args.output_json, self.args.output_csv))

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
        self.total_in += 1
        try:
            p = json.loads(msg.payload.decode("utf-8"))
            epc = as_str(p.get("epc")).upper()
            truth = self.test_truth.get(epc)
            if truth is None:
                self.total_ignored += 1
                return

            line_est = as_str(p.get("line_est")).lower()
            dist_est = as_float_or_none(p.get("distance_est_ft"))
            conf = as_float_or_none(p.get("confidence"))
            g = p.get("global_est", {})
            gx = as_float_or_none(g.get("x_ft"))
            gy = as_float_or_none(g.get("y_ft"))

            truth_line = truth["line"]
            truth_dist = truth["distance_ft"]
            truth_x, truth_y = truth_to_global(
                line=truth_line,
                distance_ft=truth_dist,
                antenna_spacing_ft=self.args.antenna_spacing_ft,
                y_line_x_ft=self.args.y_line_x_ft,
            )

            line_match = line_est == truth_line
            if dist_est is None:
                dist_err = self.args.mismatch_penalty_ft
            elif line_match:
                dist_err = abs(dist_est - truth_dist)
            else:
                dist_err = self.args.mismatch_penalty_ft

            if gx is None or gy is None:
                global_err = self.args.mismatch_penalty_ft
            else:
                global_err = math.sqrt((gx - truth_x) ** 2 + (gy - truth_y) ** 2)

            prev_line = self.last_line_by_epc.get(epc)
            if prev_line is not None and prev_line != line_est and line_est not in ("", "unknown"):
                self.switch_count_by_epc[epc] = self.switch_count_by_epc.get(epc, 0) + 1
            if line_est not in ("",):
                self.last_line_by_epc[epc] = line_est

            self.rows.append(
                {
                    "epc": epc,
                    "truth_line": truth_line,
                    "truth_distance_ft": truth_dist,
                    "line_est": line_est,
                    "distance_est_ft": dist_est,
                    "line_match": line_match,
                    "distance_error_ft": dist_err,
                    "global_error_ft": global_err,
                    "confidence": conf,
                }
            )
            self.total_used += 1
        except Exception:
            self.invalid += 1

    def compute_metrics(self):
        if not self.rows:
            return {
                "rows_used": 0,
                "line_accuracy": 0.0,
                "distance_mae_ft": self.args.mismatch_penalty_ft,
                "distance_p90_error_ft": self.args.mismatch_penalty_ft,
                "global_rmse_ft": self.args.mismatch_penalty_ft,
                "switch_rate_per_min": 0.0,
                "score": 1e9,
            }

        n = float(len(self.rows))
        line_acc = sum(1.0 for r in self.rows if r["line_match"]) / n
        dist_errors = sorted([r["distance_error_ft"] for r in self.rows])
        dist_mae = sum(dist_errors) / n
        p90_idx = int(math.ceil(0.9 * len(dist_errors))) - 1
        p90_idx = max(0, min(len(dist_errors) - 1, p90_idx))
        dist_p90 = dist_errors[p90_idx]

        g_errors = [r["global_error_ft"] for r in self.rows]
        g_rmse = math.sqrt(sum(x * x for x in g_errors) / n)

        elapsed_min = max((time.time() - self.start_ts) / 60.0, 1e-6)
        total_switch = sum(self.switch_count_by_epc.values())
        switch_rate = total_switch / elapsed_min

        score = 0.70 * dist_mae + 0.20 * dist_p90 + 0.10 * (1.0 - line_acc)

        return {
            "rows_used": int(n),
            "line_accuracy": round(line_acc, 6),
            "distance_mae_ft": round(dist_mae, 6),
            "distance_p90_error_ft": round(dist_p90, 6),
            "global_rmse_ft": round(g_rmse, 6),
            "switch_rate_per_min": round(switch_rate, 6),
            "score": round(score, 6),
        }


def load_calibration_csv(path, epc_prefix):
    mapping = {}
    with open(path, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            suffix = as_str(row.get("epc")).strip().upper()
            line = as_str(row.get("line")).strip().lower()
            distance = as_float_or_none(row.get("distance"))
            is_test = parse_bool(row.get("test"), default=False)
            if suffix == "" or line not in ("x", "y") or distance is None:
                continue
            full_epc = (epc_prefix + suffix).upper()
            mapping[full_epc] = {"line": line, "distance_ft": distance, "is_test": is_test}
    return mapping


def truth_to_global(line, distance_ft, antenna_spacing_ft, y_line_x_ft):
    midpoint_y = antenna_spacing_ft / 2.0
    if line == "x":
        return distance_ft, midpoint_y
    return y_line_x_ft, distance_ft


def write_outputs(metrics, rows, output_json, output_csv):
    payload = {
        "generated_at_ms": int(time.time() * 1000),
        "metrics": metrics,
    }
    with open(output_json, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2)
        f.write("\n")

    fields = [
        "epc",
        "truth_line",
        "truth_distance_ft",
        "line_est",
        "distance_est_ft",
        "line_match",
        "distance_error_ft",
        "global_error_ft",
        "confidence",
    ]
    with open(output_csv, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def parse_mqtt_broker_url(url):
    parsed = urlparse(url)
    if parsed.scheme not in ("tcp", "mqtt"):
        raise ValueError("mqtt broker url must start with tcp:// or mqtt://")
    if not parsed.hostname:
        raise ValueError("mqtt broker url missing host")
    port = parsed.port if parsed.port else 1883
    return parsed.hostname, port


def parse_bool(value, default=False):
    if value is None:
        return default
    text = str(value).strip().lower()
    if text in ("1", "true", "t", "yes", "y", "on"):
        return True
    if text in ("0", "false", "f", "no", "n", "off"):
        return False
    return default


def as_str(value):
    if value is None:
        return ""
    return str(value)


def as_float_or_none(value):
    if value is None:
        return None
    try:
        return float(value)
    except Exception:
        return None


def parse_args():
    parser = argparse.ArgumentParser(description="Evaluate calibrated estimates on test-tag holdout set")
    parser.add_argument("--mqtt-broker-url", default="tcp://127.0.0.1:1883")
    parser.add_argument("--mqtt-client-id", default="rfid-calibrated-evaluator-{}".format(uuid.uuid4()))
    parser.add_argument("--mqtt-username", default="")
    parser.add_argument("--mqtt-password", default="")
    parser.add_argument("--topic", default="rfid/+/epc/+/localization-calibrated")

    parser.add_argument("--calibration-csv-path", required=True)
    parser.add_argument("--epc-prefix", default="E280699500005001FAD")
    parser.add_argument("--duration-sec", type=int, default=60)

    parser.add_argument("--antenna-spacing-ft", type=float, default=10.0)
    parser.add_argument("--y-line-x-ft", type=float, default=0.0)
    parser.add_argument("--mismatch-penalty-ft", type=float, default=5.0)

    parser.add_argument("--output-json", required=True)
    parser.add_argument("--output-csv", required=True)
    return parser.parse_args()


def main():
    args = parse_args()
    if args.duration_sec <= 0:
        raise ValueError("--duration-sec must be > 0")
    if args.antenna_spacing_ft <= 0:
        raise ValueError("--antenna-spacing-ft must be > 0")
    if args.mismatch_penalty_ft <= 0:
        raise ValueError("--mismatch-penalty-ft must be > 0")

    app = Evaluator(args)
    signal.signal(signal.SIGINT, app.stop)
    signal.signal(signal.SIGTERM, app.stop)
    app.run()


if __name__ == "__main__":
    main()
