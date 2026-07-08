#!/usr/bin/env python3
"""Aggregate results for the hand-drawn graph benchmark.

Expected input: one JSON object per line with at least:

- item_id
- split
- experiment_arm
- criterion_statuses
- gold_criterion_statuses
- schema_valid
- latency_ms
- cost_usd

The script is intentionally tolerant: if some metrics are missing, they are
omitted from the aggregate report rather than failing the whole run.
"""

from __future__ import annotations

import argparse
import json
import statistics
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


DEFAULT_OUTPUT = Path("/tmp/hand_drawn_graph_benchmark_report.md")


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def as_status_map(value: Any) -> dict[str, str]:
    if isinstance(value, dict):
        return {str(k).upper(): str(v) for k, v in value.items()}
    return {}


def summarize_group(rows: list[dict[str, Any]]) -> dict[str, Any]:
    total = len(rows)
    schema_valid = sum(1 for row in rows if row.get("schema_valid") is True)
    exact_matches = 0
    criterion_total = 0
    criterion_correct = 0
    false_accepts = 0
    false_rejects = 0
    abstentions = 0
    criterion_metrics: dict[str, Counter] = defaultdict(Counter)
    latencies = []
    costs = []

    for row in rows:
        pred = as_status_map(row.get("criterion_statuses"))
        gold = as_status_map(row.get("gold_criterion_statuses"))
        if pred and gold and pred == gold:
            exact_matches += 1
        for criterion_id, gold_status in gold.items():
            pred_status = pred.get(criterion_id)
            criterion_total += 1
            if pred_status == gold_status:
                criterion_correct += 1
                criterion_metrics[criterion_id]["tp" if gold_status == "earned" else "tn"] += 1
            else:
                if gold_status == "earned" and pred_status == "not_earned":
                    false_rejects += 1
                    criterion_metrics[criterion_id]["fn"] += 1
                elif gold_status == "not_earned" and pred_status == "earned":
                    false_accepts += 1
                    criterion_metrics[criterion_id]["fp"] += 1
                elif pred_status == "unable_to_determine":
                    abstentions += 1
                    criterion_metrics[criterion_id]["abstain"] += 1
                else:
                    criterion_metrics[criterion_id]["other"] += 1
        if isinstance(row.get("latency_ms"), (int, float)):
            latencies.append(float(row["latency_ms"]))
        if isinstance(row.get("cost_usd"), (int, float)):
            costs.append(float(row["cost_usd"]))

    def ratio(num: int, den: int) -> float | None:
        return num / den if den else None

    def f1_for(counter: Counter) -> float | None:
        tp = counter.get("tp", 0)
        fp = counter.get("fp", 0)
        fn = counter.get("fn", 0)
        precision = tp / (tp + fp) if tp + fp else None
        recall = tp / (tp + fn) if tp + fn else None
        if precision is None or recall is None or precision + recall == 0:
            return None
        return 2 * precision * recall / (precision + recall)

    per_criterion_f1 = {k: f1_for(v) for k, v in sorted(criterion_metrics.items())}
    return {
        "count": total,
        "schema_valid_rate": ratio(schema_valid, total),
        "exact_criterion_vector_agreement": ratio(exact_matches, total),
        "criterion_accuracy": ratio(criterion_correct, criterion_total),
        "criterion_correct": criterion_correct,
        "criterion_total": criterion_total,
        "false_accept_rate": ratio(false_accepts, criterion_total),
        "false_reject_rate": ratio(false_rejects, criterion_total),
        "abstention_rate": ratio(abstentions, criterion_total),
        "latency_p50_ms": statistics.median(latencies) if latencies else None,
        "latency_p95_ms": statistics.quantiles(latencies, n=100)[94] if len(latencies) >= 2 else (latencies[0] if latencies else None),
        "avg_cost_usd": sum(costs) / len(costs) if costs else None,
        "per_criterion_f1": per_criterion_f1,
    }


def fmt(value: Any) -> str:
    if value is None:
        return "n/a"
    if isinstance(value, float):
        return f"{value:.4f}".rstrip("0").rstrip(".")
    return str(value)


def write_report(path: Path, groups: dict[str, dict[str, Any]], total_rows: int) -> None:
    lines = [
        "# Hand-Drawn Graph Benchmark Report",
        "",
        f"Total rows: {total_rows}",
        "",
        "## By Arm",
        "",
        "| Arm | Count | Schema Valid | Exact Match | Criterion Acc | False Accept | False Reject | Abstention | P50 Latency ms | P95 Latency ms | Avg Cost USD |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for arm, data in sorted(groups.items()):
        lines.append(
            f"| {arm} | {fmt(data.get('count'))} | {fmt(data.get('schema_valid_rate'))} | "
            f"{fmt(data.get('exact_criterion_vector_agreement'))} | {fmt(data.get('criterion_accuracy'))} | "
            f"{fmt(data.get('false_accept_rate'))} | {fmt(data.get('false_reject_rate'))} | {fmt(data.get('abstention_rate'))} | "
            f"{fmt(data.get('latency_p50_ms'))} | {fmt(data.get('latency_p95_ms'))} | {fmt(data.get('avg_cost_usd'))} |"
        )
    lines.extend(
        [
            "",
            "## Notes",
            "",
            "- Exact match is strict dictionary equality on the criterion-status map.",
            "- False accept and false reject are computed only where a gold criterion status exists.",
            "- Per-criterion F1 is included in the JSON output only and can be extended into a separate detail table later.",
        ]
    )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    rows = load_jsonl(args.input)
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in rows:
        grouped[str(row.get("experiment_arm") or "unknown")].append(row)

    summaries = {arm: summarize_group(group_rows) for arm, group_rows in grouped.items()}
    write_report(args.output, summaries, len(rows))
    print(f"Wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
