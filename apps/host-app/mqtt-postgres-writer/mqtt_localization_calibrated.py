#!/usr/bin/env python3
import argparse
import csv
import json
import signal
import sys
import time
import uuid
from statistics import median
from urllib.parse import urlparse

import paho.mqtt.client as mqtt


REQUIRED_FEATURE_FIELDS = [
    "ts_emit_ms",
    "reader_id",
    "epc",
    "count_ant1",
    "count_ant2",
    "both_antennas_present",
    "rssi_delta_ant1_minus_ant2",
    "phase_delta_ant1_minus_ant2",
]


class CalibrationLocalizer:
    def __init__(self, args):
        self.args = args
        self.running = True
        self.last_stats_at = time.time()

        self.msg_in = 0
        self.msg_invalid = 0
        self.msg_ignored = 0
        self.msg_out = 0
        self.publish_errors = 0

        self.calibration_map = load_calibration_csv(args.calibration_csv_path, args.epc_prefix)
        self.train_calibration_epcs = set(
            [epc for epc, meta in self.calibration_map.items() if not meta.get("is_test", False)]
        )
        self.test_calibration_epcs = set(
            [epc for epc, meta in self.calibration_map.items() if meta.get("is_test", False)]
        )

        self.collect_state = {}
        self.estimate_state = {}
        self.fingerprint = None
        if args.mode == "estimate":
            self.fingerprint = load_fingerprint(args.fingerprint_json_path)
            if not self.fingerprint:
                raise ValueError(
                    "No fingerprint points available. Run collect-fingerprint mode first and save fingerprint JSON."
                )

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
                    "calibrated stats mode={} in={} invalid={} ignored={} out={} pub_errors={} active_keys={}".format(
                        self.args.mode,
                        self.msg_in,
                        self.msg_invalid,
                        self.msg_ignored,
                        self.msg_out,
                        self.publish_errors,
                        len(self.estimate_state) if self.args.mode == "estimate" else len(self.collect_state),
                    )
                )
                self.last_stats_at = now
            time.sleep(0.2)

        self.client.loop_stop()
        try:
            self.client.disconnect()
        except Exception:
            pass

        if self.args.mode == "collect-fingerprint":
            self.save_fingerprint()

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
        self.msg_in += 1
        try:
            feature = json.loads(msg.payload.decode("utf-8"))
            ensure_feature_payload(feature)
            if self.args.mode == "collect-fingerprint":
                self.handle_collect(feature)
            else:
                self.handle_estimate(feature)
        except ValueError as ex:
            self.msg_invalid += 1
            print("Feature validation failed: {}".format(ex), file=sys.stderr)
        except Exception as ex:
            self.msg_invalid += 1
            print("Localization calibrated failed: {}".format(ex), file=sys.stderr)

    def handle_collect(self, feature):
        epc = as_str(feature.get("epc"))
        if epc not in self.train_calibration_epcs:
            self.msg_ignored += 1
            return

        ts_emit_ms = as_int(feature.get("ts_emit_ms"), "ts_emit_ms")
        rssi_delta = as_float_or_none(feature.get("rssi_delta_ant1_minus_ant2"))
        phase_delta = as_float_or_none(feature.get("phase_delta_ant1_minus_ant2"))
        zone_score = derive_zone_score(rssi_delta, self.args.max_abs_rssi_delta_db)

        entry = self.collect_state.get(epc)
        if entry is None:
            meta = self.calibration_map[epc]
            entry = {
                "line": meta["line"],
                "distance_ft": meta["distance_ft"],
                "rssi_delta": [],
                "phase_delta": [],
                "zone_score": [],
                "last_seen_ms": ts_emit_ms,
            }
            self.collect_state[epc] = entry

        if rssi_delta is not None:
            entry["rssi_delta"].append(rssi_delta)
        if phase_delta is not None:
            entry["phase_delta"].append(phase_delta)
        if zone_score is not None:
            entry["zone_score"].append(zone_score)
        entry["last_seen_ms"] = ts_emit_ms

    def save_fingerprint(self):
        points = []
        for epc, entry in self.collect_state.items():
            rssi_vals = entry["rssi_delta"]
            zone_vals = entry["zone_score"]
            phase_vals = entry["phase_delta"]

            if len(rssi_vals) < self.args.collect_min_samples or len(zone_vals) < self.args.collect_min_samples:
                continue

            point = {
                "epc": epc,
                "line": entry["line"],
                "distance_ft": entry["distance_ft"],
                "sample_count": min(len(rssi_vals), len(zone_vals)),
                "signature": {
                    "rssi_delta_median": round(median(rssi_vals), 3),
                    "rssi_delta_mad": round(mad(rssi_vals), 3),
                    "phase_delta_median": round(median(phase_vals), 3) if phase_vals else 0.0,
                    "phase_delta_mad": round(mad(phase_vals), 3) if phase_vals else 0.0,
                    "zone_score_median": round(median(zone_vals), 3),
                    "zone_score_mad": round(mad(zone_vals), 3),
                },
            }
            points.append(point)

        payload = {
            "version": 1,
            "created_at_ms": int(time.time() * 1000),
            "epc_prefix": self.args.epc_prefix,
            "distance_unit": "ft",
            "feature_window_ms": self.args.feature_window_ms,
            "notes": "deterministic calibration fingerprint (train tags only)",
            "train_point_count": len(points),
            "csv_train_tag_count": len(self.train_calibration_epcs),
            "csv_test_tag_count": len(self.test_calibration_epcs),
            "points": points,
        }
        with open(self.args.fingerprint_json_path, "w", encoding="utf-8") as f:
            json.dump(payload, f, indent=2)
            f.write("\n")
        print(
            "Saved fingerprint JSON {} with {} points".format(
                self.args.fingerprint_json_path, len(points)
            )
        )

    def handle_estimate(self, feature):
        ts_emit_ms = as_int(feature.get("ts_emit_ms"), "ts_emit_ms")
        reader_id = as_str(feature.get("reader_id"))
        epc = as_str(feature.get("epc"))
        count_ant1 = as_int(feature.get("count_ant1"), "count_ant1")
        count_ant2 = as_int(feature.get("count_ant2"), "count_ant2")
        both = bool(feature.get("both_antennas_present", False))

        samples_used = count_ant1 + count_ant2
        if samples_used < self.args.min_samples:
            self.msg_ignored += 1
            return

        rssi_delta = as_float_or_none(feature.get("rssi_delta_ant1_minus_ant2"))
        phase_delta = as_float_or_none(feature.get("phase_delta_ant1_minus_ant2"))
        zone_score = derive_zone_score(rssi_delta, self.args.max_abs_rssi_delta_db)
        age_ant1 = as_int_or_none(feature.get("age_ms_ant1"))
        age_ant2 = as_int_or_none(feature.get("age_ms_ant2"))

        current = {
            "rssi_delta": rssi_delta,
            "phase_delta": phase_delta,
            "zone_score": zone_score,
        }

        scored = score_points(
            current=current,
            points=self.fingerprint,
            use_phase=self.args.use_phase,
            w_rssi=self.args.w_rssi,
            w_phase=self.args.w_phase,
            w_score=self.args.w_score,
        )
        if not scored:
            self.msg_ignored += 1
            return

        top = scored[0]
        top_line = top["line"]
        top_score = top["score"]

        best_line_scores = best_score_per_line(scored)

        state_key = (reader_id, epc)
        prior = self.estimate_state.get(state_key)
        candidate_line = top_line
        if prior is not None and prior.get("line") in best_line_scores and candidate_line != prior.get("line"):
            prior_score = best_line_scores[prior.get("line")]
            if prior_score <= top_score + self.args.switch_hysteresis:
                candidate_line = prior.get("line")

        candidate_distance = interpolate_distance_for_line(scored, candidate_line)
        line_est, distance_est_ft, pending_line, pending_distance, pending_count = apply_estimate_debounce(
            prior_line=prior.get("line") if prior else None,
            prior_distance=prior.get("distance_ft") if prior else None,
            prior_pending_line=prior.get("pending_line") if prior else None,
            prior_pending_distance=prior.get("pending_distance") if prior else None,
            prior_pending_count=prior.get("pending_count") if prior else 0,
            candidate_line=candidate_line,
            candidate_distance=candidate_distance,
            debounce_count=self.args.estimate_debounce_count,
        )

        if prior is not None and line_est == prior.get("line") and distance_est_ft is not None:
            distance_est_ft = (
                prior.get("distance_ft", distance_est_ft) * (1.0 - self.args.estimate_smoothing_alpha)
                + distance_est_ft * self.args.estimate_smoothing_alpha
            )

        self.estimate_state[state_key] = {
            "line": line_est,
            "distance_ft": distance_est_ft,
            "pending_line": pending_line,
            "pending_distance": pending_distance,
            "pending_count": pending_count,
            "last_seen_ms": ts_emit_ms,
        }

        confidence = compute_confidence(scored, samples_used, both, age_ant1, age_ant2)
        global_est = to_global_estimate(
            line=line_est,
            distance_ft=distance_est_ft,
            antenna_spacing_ft=self.args.antenna_spacing_ft,
            y_line_x_ft=self.args.y_line_x_ft,
        )

        output = {
            "calibrated_version": 1,
            "method": "deterministic_calibration_map",
            "ts_emit_ms": ts_emit_ms,
            "reader_id": reader_id,
            "epc": epc,
            "line_est": line_est,
            "distance_est_ft": round_or_none(distance_est_ft),
            "distance_unit": "ft",
            "global_est": global_est,
            "confidence": round(confidence, 3),
            "current_signature": {
                "rssi_delta": round_or_none(rssi_delta),
                "phase_delta": round_or_none(phase_delta),
                "zone_score": round_or_none(zone_score),
            },
            "top_matches": [
                {
                    "epc": x["epc"],
                    "line": x["line"],
                    "distance_ft": x["distance_ft"],
                    "distance_score": round(x["score"], 4),
                }
                for x in scored[:3]
            ],
            "weights": {
                "w_rssi": self.args.w_rssi,
                "w_phase": self.args.w_phase if self.args.use_phase else 0.0,
                "w_zone_score": self.args.w_score,
            },
            "quality": {
                "samples_used": samples_used,
                "both_antennas_present": both,
                "age_ms_ant1": age_ant1,
                "age_ms_ant2": age_ant2,
            },
            "use_phase": self.args.use_phase,
            "switch_hysteresis": self.args.switch_hysteresis,
            "estimate_debounce_count": self.args.estimate_debounce_count,
            "is_calibration_tag": epc in self.calibration_map,
            "is_test_tag": epc in self.test_calibration_epcs,
        }

        topic = (
            self.args.output_root
            + "/"
            + sanitize_topic_token(reader_id)
            + "/epc/"
            + sanitize_topic_token(epc)
            + "/localization-calibrated"
        )
        self.publish(topic, output)

    def publish(self, topic, payload):
        try:
            body = json.dumps(payload, separators=(",", ":"))
            result = self.client.publish(topic, body, qos=1, retain=False)
            if result.rc != mqtt.MQTT_ERR_SUCCESS:
                raise RuntimeError("publish rc={}".format(result.rc))
            self.msg_out += 1
        except Exception as ex:
            self.publish_errors += 1
            print("Calibrated publish failed topic={} err={}".format(topic, ex), file=sys.stderr)

    def cleanup_state(self, now_ms):
        stale = []
        target = self.estimate_state if self.args.mode == "estimate" else self.collect_state
        for key, value in target.items():
            if now_ms - int(value.get("last_seen_ms", 0)) > self.args.idle_ttl_ms:
                stale.append(key)
        for key in stale:
            target.pop(key, None)


def load_calibration_csv(path, epc_prefix):
    mapping = {}
    with open(path, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            suffix = as_str(row.get("epc")).strip().upper()
            line = as_str(row.get("line")).strip().lower()
            distance_val = as_float_or_none(row.get("distance"))
            is_test = parse_bool(row.get("test"), default=False)
            if suffix == "" or line not in ("x", "y") or distance_val is None:
                continue
            full_epc = (epc_prefix + suffix).upper()
            mapping[full_epc] = {"line": line, "distance_ft": distance_val, "is_test": is_test}
    if not mapping:
        raise ValueError("No calibration rows loaded from {}".format(path))
    return mapping


def load_fingerprint(path):
    with open(path, "r", encoding="utf-8") as f:
        payload = json.load(f)
    points = payload.get("points", [])
    out = []
    for p in points:
        sig = p.get("signature", {})
        out.append(
            {
                "epc": p.get("epc"),
                "line": p.get("line"),
                "distance_ft": float(p.get("distance_ft")),
                "rssi_delta_median": as_float_or_none(sig.get("rssi_delta_median")),
                "phase_delta_median": as_float_or_none(sig.get("phase_delta_median")),
                "zone_score_median": as_float_or_none(sig.get("zone_score_median")),
            }
        )
    return out


def ensure_feature_payload(feature):
    for key in REQUIRED_FEATURE_FIELDS:
        if key not in feature:
            raise ValueError("missing field '{}'".format(key))


def derive_zone_score(rssi_delta, max_abs_rssi_delta_db):
    if rssi_delta is None:
        return None
    return clamp(rssi_delta / float(max_abs_rssi_delta_db), -1.0, 1.0)


def score_points(current, points, use_phase, w_rssi, w_phase, w_score):
    scored = []
    for p in points:
        score = 0.0
        used = 0
        if current["rssi_delta"] is not None and p["rssi_delta_median"] is not None:
            score += w_rssi * abs(current["rssi_delta"] - p["rssi_delta_median"])
            used += 1
        if current["zone_score"] is not None and p["zone_score_median"] is not None:
            score += w_score * abs(current["zone_score"] - p["zone_score_median"])
            used += 1
        if use_phase and current["phase_delta"] is not None and p["phase_delta_median"] is not None:
            score += w_phase * wrapped_phase_diff_deg(current["phase_delta"], p["phase_delta_median"])
            used += 1
        if used == 0:
            continue
        scored.append(
            {
                "epc": p["epc"],
                "line": p["line"],
                "distance_ft": p["distance_ft"],
                "score": score,
            }
        )
    scored.sort(key=lambda x: x["score"])
    return scored


def wrapped_phase_diff_deg(a, b):
    d = (a - b) % 360.0
    if d > 180.0:
        d -= 360.0
    return abs(d)


def best_score_per_line(scored):
    out = {}
    for item in scored:
        line = item["line"]
        s = item["score"]
        if line not in out or s < out[line]:
            out[line] = s
    return out


def interpolate_distance_for_line(scored, line):
    line_points = [x for x in scored if x["line"] == line]
    if not line_points:
        return None
    if len(line_points) == 1:
        return line_points[0]["distance_ft"]
    p1 = line_points[0]
    p2 = line_points[1]
    eps = 1e-6
    w1 = 1.0 / (p1["score"] + eps)
    w2 = 1.0 / (p2["score"] + eps)
    return (p1["distance_ft"] * w1 + p2["distance_ft"] * w2) / (w1 + w2)


def apply_estimate_debounce(
    prior_line,
    prior_distance,
    prior_pending_line,
    prior_pending_distance,
    prior_pending_count,
    candidate_line,
    candidate_distance,
    debounce_count,
):
    if prior_line is None:
        return candidate_line, candidate_distance, None, None, 0

    if candidate_line == prior_line:
        return prior_line, candidate_distance, None, None, 0

    if debounce_count <= 1:
        return candidate_line, candidate_distance, None, None, 0

    pending_line = prior_pending_line
    pending_distance = prior_pending_distance
    pending_count = prior_pending_count

    if pending_line == candidate_line:
        pending_count += 1
        pending_distance = candidate_distance
    else:
        pending_line = candidate_line
        pending_distance = candidate_distance
        pending_count = 1

    if pending_count >= debounce_count:
        return candidate_line, candidate_distance, None, None, 0

    return prior_line, prior_distance, pending_line, pending_distance, pending_count


def to_global_estimate(line, distance_ft, antenna_spacing_ft, y_line_x_ft):
    midpoint_y = antenna_spacing_ft / 2.0
    if line == "x" and distance_ft is not None:
        return {"x_ft": round(distance_ft, 3), "y_ft": round(midpoint_y, 3)}
    if line == "y" and distance_ft is not None:
        return {"x_ft": round(y_line_x_ft, 3), "y_ft": round(distance_ft, 3)}
    return {"x_ft": None, "y_ft": None}


def compute_confidence(scored, samples_used, both, age_ant1, age_ant2):
    best = scored[0]["score"]
    second = scored[1]["score"] if len(scored) > 1 else (best + 1.0)
    margin = max(0.0, second - best)

    margin_component = clamp(margin / (best + 1.0), 0.0, 1.0)
    sample_component = clamp(samples_used / 120.0, 0.0, 1.0)
    presence_component = 1.0 if both else 0.5

    max_age = 0
    if age_ant1 is not None:
        max_age = max(max_age, age_ant1)
    if age_ant2 is not None:
        max_age = max(max_age, age_ant2)
    freshness = 1.0 - clamp(max_age / 2000.0, 0.0, 1.0)

    confidence = 0.35 * margin_component + 0.30 * sample_component + 0.20 * presence_component + 0.15 * freshness
    return clamp(confidence, 0.0, 1.0)


def mad(values):
    if not values:
        return 0.0
    med = median(values)
    dev = [abs(v - med) for v in values]
    return median(dev)


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


def parse_bool(value, default=False):
    if value is None:
        return default
    text = str(value).strip().lower()
    if text in ("1", "true", "t", "yes", "y", "on"):
        return True
    if text in ("0", "false", "f", "no", "n", "off"):
        return False
    return default


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
    parser = argparse.ArgumentParser(description="Deterministic calibration localizer")
    parser.add_argument("--mode", choices=["collect-fingerprint", "estimate"], default="estimate")

    parser.add_argument("--mqtt-broker-url", default="tcp://127.0.0.1:1883")
    parser.add_argument("--mqtt-client-id", default="rfid-localization-calibrated-{}".format(uuid.uuid4()))
    parser.add_argument("--mqtt-username", default="")
    parser.add_argument("--mqtt-password", default="")

    parser.add_argument("--input-topic", default="rfid/+/epc/+/features-rolling")
    parser.add_argument("--output-root", default="rfid")

    parser.add_argument("--calibration-csv-path", required=True)
    parser.add_argument("--epc-prefix", default="E280699500005001FAD")
    parser.add_argument("--fingerprint-json-path", required=True)

    parser.add_argument("--feature-window-ms", type=int, default=1000)
    parser.add_argument("--collect-min-samples", type=int, default=20)

    parser.add_argument("--use-phase", action="store_true")
    parser.add_argument("--w-rssi", type=float, default=1.0)
    parser.add_argument("--w-phase", type=float, default=0.0)
    parser.add_argument("--w-score", type=float, default=0.8)
    parser.add_argument("--max-abs-rssi-delta-db", type=float, default=12.0)

    parser.add_argument("--min-samples", type=int, default=10)
    parser.add_argument("--switch-hysteresis", type=float, default=0.08)
    parser.add_argument("--estimate-debounce-count", type=int, default=3)
    parser.add_argument("--estimate-smoothing-alpha", type=float, default=0.35)
    parser.add_argument("--idle-ttl-ms", type=int, default=5000)

    parser.add_argument("--antenna-spacing-ft", type=float, default=10.0)
    parser.add_argument("--y-line-x-ft", type=float, default=0.0)

    return parser.parse_args()


def main():
    args = parse_args()
    if args.w_rssi < 0 or args.w_phase < 0 or args.w_score < 0:
        raise ValueError("weights must be non-negative")
    if args.max_abs_rssi_delta_db <= 0:
        raise ValueError("--max-abs-rssi-delta-db must be > 0")
    if args.collect_min_samples <= 0:
        raise ValueError("--collect-min-samples must be > 0")
    if args.min_samples <= 0:
        raise ValueError("--min-samples must be > 0")
    if args.estimate_debounce_count <= 0:
        raise ValueError("--estimate-debounce-count must be > 0")
    if args.estimate_smoothing_alpha <= 0 or args.estimate_smoothing_alpha > 1:
        raise ValueError("--estimate-smoothing-alpha must be in (0,1]")
    if args.idle_ttl_ms <= 0:
        raise ValueError("--idle-ttl-ms must be > 0")
    if args.antenna_spacing_ft <= 0:
        raise ValueError("--antenna-spacing-ft must be > 0")

    app = CalibrationLocalizer(args)
    signal.signal(signal.SIGINT, app.stop)
    signal.signal(signal.SIGTERM, app.stop)
    app.run()


if __name__ == "__main__":
    main()
