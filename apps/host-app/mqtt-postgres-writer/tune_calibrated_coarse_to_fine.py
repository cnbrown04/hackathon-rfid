#!/usr/bin/env python3
import argparse
import csv
import itertools
import json
import os
import signal
import subprocess
import sys
import tempfile
import time


def parse_list_floats(value):
    return [float(x.strip()) for x in value.split(",") if x.strip()]


def parse_list_ints(value):
    return [int(x.strip()) for x in value.split(",") if x.strip()]


def wait_stop(proc, timeout_sec=10):
    if proc.poll() is not None:
        return
    proc.terminate()
    try:
        proc.wait(timeout=timeout_sec)
    except subprocess.TimeoutExpired:
        proc.kill()
        proc.wait(timeout=5)


def start_process(cmd, env, log_path):
    log_file = open(log_path, "w", encoding="utf-8")
    proc = subprocess.Popen(cmd, env=env, stdout=log_file, stderr=subprocess.STDOUT)
    return proc, log_file


def write_power_config(template_path, output_path, tx_power):
    with open(template_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    out = []
    seen_1 = False
    seen_2 = False
    for line in lines:
        if line.startswith("antenna.txPowerIndex.1="):
            out.append("antenna.txPowerIndex.1={}\n".format(tx_power))
            seen_1 = True
            continue
        if line.startswith("antenna.txPowerIndex.2="):
            out.append("antenna.txPowerIndex.2={}\n".format(tx_power))
            seen_2 = True
            continue
        out.append(line)

    if not seen_1:
        out.append("antenna.txPowerIndex.1={}\n".format(tx_power))
    if not seen_2:
        out.append("antenna.txPowerIndex.2={}\n".format(tx_power))

    with open(output_path, "w", encoding="utf-8") as f:
        f.writelines(out)


def run_collect_fingerprint(args, env_base, logs_dir, cfg_idx):
    env = env_base.copy()
    env.update(
        {
            "MODE": "collect-fingerprint",
            "CALIBRATION_CSV_PATH": args.calibration_csv_path,
            "EPC_PREFIX": args.epc_prefix,
            "FINGERPRINT_JSON_PATH": args.fingerprint_json_path,
            "COLLECT_MIN_SAMPLES": str(args.collect_min_samples),
            "MAX_ABS_RSSI_DELTA_DB": str(args.max_abs_rssi_delta_db),
        }
    )
    log_path = os.path.join(logs_dir, "collect_{}.log".format(cfg_idx))
    proc, log_file = start_process([args.run_calibrated_script], env, log_path)
    time.sleep(args.collect_duration_sec)
    wait_stop(proc)
    log_file.close()


def run_estimate_eval_once(args, env_base, logs_dir, tag, cfg):
    env_est = env_base.copy()
    env_est.update(
        {
            "MODE": "estimate",
            "CALIBRATION_CSV_PATH": args.calibration_csv_path,
            "EPC_PREFIX": args.epc_prefix,
            "FINGERPRINT_JSON_PATH": args.fingerprint_json_path,
            "USE_PHASE": "true" if cfg["use_phase"] else "false",
            "W_RSSI": str(cfg["w_rssi"]),
            "W_PHASE": str(cfg["w_phase"]),
            "W_SCORE": str(cfg["w_score"]),
            "MAX_ABS_RSSI_DELTA_DB": str(args.max_abs_rssi_delta_db),
            "MIN_SAMPLES": str(cfg["min_samples"]),
            "SWITCH_HYSTERESIS": str(cfg["switch_hysteresis"]),
            "ESTIMATE_DEBOUNCE_COUNT": str(cfg["estimate_debounce_count"]),
            "ESTIMATE_SMOOTHING_ALPHA": str(cfg["estimate_smoothing_alpha"]),
            "IDLE_TTL_MS": str(args.idle_ttl_ms),
            "ANTENNA_SPACING_FT": str(args.antenna_spacing_ft),
            "Y_LINE_X_FT": str(args.y_line_x_ft),
        }
    )
    est_log = os.path.join(logs_dir, "estimate_{}.log".format(tag))
    est_proc, est_log_file = start_process([args.run_calibrated_script], env_est, est_log)

    out_json = os.path.join(logs_dir, "eval_{}.json".format(tag))
    out_csv = os.path.join(logs_dir, "eval_{}.csv".format(tag))

    eval_cmd = [
        args.python_bin,
        args.evaluator_script,
        "--mqtt-broker-url",
        args.mqtt_broker_url,
        "--topic",
        args.calibrated_topic,
        "--calibration-csv-path",
        args.calibration_csv_path,
        "--epc-prefix",
        args.epc_prefix,
        "--duration-sec",
        str(args.eval_duration_sec),
        "--antenna-spacing-ft",
        str(args.antenna_spacing_ft),
        "--y-line-x-ft",
        str(args.y_line_x_ft),
        "--mismatch-penalty-ft",
        str(args.mismatch_penalty_ft),
        "--output-json",
        out_json,
        "--output-csv",
        out_csv,
    ]
    eval_log = os.path.join(logs_dir, "evaluator_{}.log".format(tag))
    eval_proc, eval_log_file = start_process(eval_cmd, env_base.copy(), eval_log)
    eval_proc.wait()
    eval_log_file.close()

    wait_stop(est_proc)
    est_log_file.close()

    with open(out_json, "r", encoding="utf-8") as f:
        metrics = json.load(f).get("metrics", {})
    return metrics


def ensure_has_test_rows(metrics, stage_tag):
    rows_used = int(metrics.get("rows_used", 0))
    if rows_used > 0:
        return
    raise RuntimeError(
        "No held-out test tag rows were observed during {}. "
        "Make sure tags with test=true in calibration.csv are physically present/readable during eval windows.".format(
            stage_tag
        )
    )


def write_results_csv(path, rows):
    fields = [
        "stage",
        "tx_power",
        "use_phase",
        "w_rssi",
        "w_phase",
        "w_score",
        "min_samples",
        "switch_hysteresis",
        "estimate_debounce_count",
        "estimate_smoothing_alpha",
        "rows_used",
        "line_accuracy",
        "distance_mae_ft",
        "distance_p90_error_ft",
        "global_rmse_ft",
        "switch_rate_per_min",
        "score",
    ]
    with open(path, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def write_best_env(path, best):
    lines = [
        "TX_POWER_INDEX={}".format(best["tx_power"]),
        "USE_PHASE={}".format("true" if best["use_phase"] else "false"),
        "W_RSSI={}".format(best["w_rssi"]),
        "W_PHASE={}".format(best["w_phase"]),
        "W_SCORE={}".format(best["w_score"]),
        "MIN_SAMPLES={}".format(best["min_samples"]),
        "SWITCH_HYSTERESIS={}".format(best["switch_hysteresis"]),
        "ESTIMATE_DEBOUNCE_COUNT={}".format(best["estimate_debounce_count"]),
        "ESTIMATE_SMOOTHING_ALPHA={}".format(best["estimate_smoothing_alpha"]),
    ]
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")


def add_metrics(row, metrics):
    row = row.copy()
    row.update(metrics)
    return row


def make_fine_candidates(best):
    def around_float(base, delta, min_value=None):
        vals = [base - delta, base, base + delta]
        out = []
        for v in vals:
            if min_value is not None and v < min_value:
                continue
            rv = round(v, 3)
            if rv not in out:
                out.append(rv)
        return out

    def around_int(base, delta, min_value=1):
        vals = [base - delta, base, base + delta]
        out = []
        for v in vals:
            iv = int(v)
            if iv < min_value:
                continue
            if iv not in out:
                out.append(iv)
        return out

    return {
        "tx_power": around_int(best["tx_power"], 20, 1),
        "w_rssi": around_float(best["w_rssi"], 0.2, 0.0),
        "w_score": around_float(best["w_score"], 0.2, 0.0),
        "min_samples": around_int(best["min_samples"], 2, 1),
        "switch_hysteresis": around_float(best["switch_hysteresis"], 0.02, 0.0),
        "estimate_debounce_count": around_int(best["estimate_debounce_count"], 1, 1),
        "estimate_smoothing_alpha": [
            x
            for x in around_float(best["estimate_smoothing_alpha"], 0.1, 0.05)
            if x <= 1.0
        ],
    }


def parse_args():
    parser = argparse.ArgumentParser(description="Coarse-to-fine deterministic tuning for calibrated localizer")
    parser.add_argument("--mqtt-broker-url", default="tcp://127.0.0.1:1883")
    parser.add_argument("--raw-publisher-script", required=True)
    parser.add_argument("--raw-publisher-template", required=True)
    parser.add_argument("--run-feature-script", required=True)
    parser.add_argument("--run-calibrated-script", required=True)
    parser.add_argument("--evaluator-script", required=True)
    parser.add_argument("--python-bin", default="python3")

    parser.add_argument("--calibration-csv-path", required=True)
    parser.add_argument("--epc-prefix", default="E280699500005001FAD")
    parser.add_argument("--fingerprint-json-path", required=True)

    parser.add_argument("--feature-topic", default="rfid/+/antenna/+/raw-read")
    parser.add_argument("--output-root", default="rfid")
    parser.add_argument("--calibrated-topic", default="rfid/+/epc/+/localization-calibrated")

    parser.add_argument("--collect-duration-sec", type=int, default=45)
    parser.add_argument("--eval-duration-sec", type=int, default=45)
    parser.add_argument("--collect-min-samples", type=int, default=20)

    parser.add_argument("--max-abs-rssi-delta-db", type=float, default=12.0)
    parser.add_argument("--idle-ttl-ms", type=int, default=5000)
    parser.add_argument("--antenna-spacing-ft", type=float, default=10.0)
    parser.add_argument("--y-line-x-ft", type=float, default=0.0)
    parser.add_argument("--mismatch-penalty-ft", type=float, default=5.0)

    parser.add_argument("--coarse-tx-powers", default="80,60,40")
    parser.add_argument("--coarse-w-rssi", default="0.8,1.0,1.2")
    parser.add_argument("--coarse-w-score", default="0.5,0.8,1.0")
    parser.add_argument("--coarse-min-samples", default="8,10,14")
    parser.add_argument("--coarse-switch-hysteresis", default="0.05,0.08,0.12")
    parser.add_argument("--coarse-debounce", default="2,3")
    parser.add_argument("--coarse-smoothing", default="0.25,0.35,0.5")

    parser.add_argument("--results-csv", required=True)
    parser.add_argument("--best-env", required=True)
    parser.add_argument("--logs-dir", required=True)
    return parser.parse_args()


def main():
    args = parse_args()
    os.makedirs(args.logs_dir, exist_ok=True)

    coarse_tx = parse_list_ints(args.coarse_tx_powers)
    coarse_w_rssi = parse_list_floats(args.coarse_w_rssi)
    coarse_w_score = parse_list_floats(args.coarse_w_score)
    coarse_min_samples = parse_list_ints(args.coarse_min_samples)
    coarse_hyst = parse_list_floats(args.coarse_switch_hysteresis)
    coarse_debounce = parse_list_ints(args.coarse_debounce)
    coarse_smoothing = parse_list_floats(args.coarse_smoothing)

    env_base = os.environ.copy()
    env_base["MQTT_BROKER_URL"] = args.mqtt_broker_url
    env_base["OUTPUT_ROOT"] = args.output_root

    feature_env = env_base.copy()
    feature_env["INPUT_TOPIC"] = args.feature_topic
    feature_env["WINDOW_MS"] = "1000"
    feature_env["EMIT_EVERY_MS"] = "250"
    feature_env["IDLE_TTL_MS"] = str(args.idle_ttl_ms)

    feature_proc, feature_log = start_process(
        [args.run_feature_script],
        feature_env,
        os.path.join(args.logs_dir, "feature_service.log"),
    )

    all_results = []
    raw_proc = None
    raw_log = None

    try:
        for tx_power in coarse_tx:
            print("\n=== COARSE STAGE power={} ===".format(tx_power))
            with tempfile.NamedTemporaryFile(prefix="raw-power-", suffix=".properties", delete=False) as tf:
                cfg_path = tf.name
            write_power_config(args.raw_publisher_template, cfg_path, tx_power)

            raw_proc, raw_log = start_process(
                [args.raw_publisher_script, cfg_path],
                env_base.copy(),
                os.path.join(args.logs_dir, "raw_publisher_{}.log".format(tx_power)),
            )
            time.sleep(5)

            run_collect_fingerprint(args, env_base, args.logs_dir, "coarse_power_{}".format(tx_power))

            coarse_grid = itertools.product(
                coarse_w_rssi,
                coarse_w_score,
                coarse_min_samples,
                coarse_hyst,
                coarse_debounce,
                coarse_smoothing,
            )
            idx = 0
            for w_rssi, w_score, min_samples, hyst, debounce, smoothing in coarse_grid:
                idx += 1
                cfg = {
                    "stage": "coarse",
                    "tx_power": tx_power,
                    "use_phase": False,
                    "w_rssi": w_rssi,
                    "w_phase": 0.0,
                    "w_score": w_score,
                    "min_samples": min_samples,
                    "switch_hysteresis": hyst,
                    "estimate_debounce_count": debounce,
                    "estimate_smoothing_alpha": smoothing,
                }
                tag = "coarse_p{}_{}".format(tx_power, idx)
                metrics = run_estimate_eval_once(args, env_base, args.logs_dir, tag, cfg)
                ensure_has_test_rows(metrics, tag)
                result = add_metrics(cfg, metrics)
                all_results.append(result)
                print(
                    "coarse tx={} cfg#{} score={} mae={} line_acc={}".format(
                        tx_power,
                        idx,
                        result.get("score"),
                        result.get("distance_mae_ft"),
                        result.get("line_accuracy"),
                    )
                )

            wait_stop(raw_proc)
            raw_log.close()
            raw_proc = None
            raw_log = None

        if not all_results:
            raise RuntimeError("No coarse results generated")

        all_results.sort(key=lambda r: r.get("score", 1e9))
        best_coarse = all_results[0]
        fine = make_fine_candidates(best_coarse)

        print("\n=== FINE STAGE around best coarse score={} ===".format(best_coarse.get("score")))

        fine_tx_list = fine["tx_power"]
        for tx_power in fine_tx_list:
            with tempfile.NamedTemporaryFile(prefix="raw-power-fine-", suffix=".properties", delete=False) as tf:
                cfg_path = tf.name
            write_power_config(args.raw_publisher_template, cfg_path, tx_power)
            raw_proc, raw_log = start_process(
                [args.raw_publisher_script, cfg_path],
                env_base.copy(),
                os.path.join(args.logs_dir, "raw_publisher_fine_{}.log".format(tx_power)),
            )
            time.sleep(5)

            run_collect_fingerprint(args, env_base, args.logs_dir, "fine_power_{}".format(tx_power))

            fine_grid = itertools.product(
                fine["w_rssi"],
                fine["w_score"],
                fine["min_samples"],
                fine["switch_hysteresis"],
                fine["estimate_debounce_count"],
                fine["estimate_smoothing_alpha"],
            )
            idx = 0
            for w_rssi, w_score, min_samples, hyst, debounce, smoothing in fine_grid:
                idx += 1
                cfg = {
                    "stage": "fine",
                    "tx_power": tx_power,
                    "use_phase": False,
                    "w_rssi": w_rssi,
                    "w_phase": 0.0,
                    "w_score": w_score,
                    "min_samples": min_samples,
                    "switch_hysteresis": hyst,
                    "estimate_debounce_count": debounce,
                    "estimate_smoothing_alpha": smoothing,
                }
                tag = "fine_p{}_{}".format(tx_power, idx)
                metrics = run_estimate_eval_once(args, env_base, args.logs_dir, tag, cfg)
                ensure_has_test_rows(metrics, tag)
                result = add_metrics(cfg, metrics)
                all_results.append(result)
                print(
                    "fine tx={} cfg#{} score={} mae={} line_acc={}".format(
                        tx_power,
                        idx,
                        result.get("score"),
                        result.get("distance_mae_ft"),
                        result.get("line_accuracy"),
                    )
                )

            wait_stop(raw_proc)
            raw_log.close()
            raw_proc = None
            raw_log = None

        all_results.sort(key=lambda r: r.get("score", 1e9))
        best = all_results[0]
        write_results_csv(args.results_csv, all_results)
        write_best_env(args.best_env, best)
        print("\nBest config score={} saved to {}".format(best.get("score"), args.best_env))

    finally:
        if raw_proc is not None:
            wait_stop(raw_proc)
        if raw_log is not None:
            raw_log.close()
        wait_stop(feature_proc)
        feature_log.close()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(130)
