#!/usr/bin/env python3
"""Aggregate the FRQ02 flywheel volume test."""

from __future__ import annotations

import argparse
import json
import statistics
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


DEFAULT_INPUT = Path("/private/tmp/cramapple-bio-ref-spike/frq02_flywheel_results_2026-06-17.jsonl")
DEFAULT_OUTPUT = Path("docs/research/bio_reference_layer_flywheel_volume_test_report.md")
CRITERIA = ["FRQ02-C1", "FRQ02-C2", "FRQ02-C3", "FRQ02-C4"]
ARMS = ["bm_control", "bm_flywheel"]


def load_rows(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def pct(value: float) -> str:
    return f"{value * 100:.1f}%"


def money(value: float) -> str:
    return f"${value:.5f}"


def median(values: list[float]) -> float:
    return statistics.median(values) if values else 0.0


def p95(values: list[float]) -> float:
    if not values:
        return 0.0
    ordered = sorted(values)
    return ordered[min(int(len(ordered) * 0.95), len(ordered) - 1)]


def agreement(row: dict[str, Any]) -> int:
    return len(CRITERIA) - len(row.get("quality_flags", []))


def flag_counts(rows: list[dict[str, Any]]) -> Counter[str]:
    counts: Counter[str] = Counter()
    for row in rows:
        counts.update(row.get("quality_flags", []))
    return counts


def criterion_flag_counts(rows: list[dict[str, Any]], flag_prefix: str) -> Counter[str]:
    counts: Counter[str] = Counter()
    for row in rows:
        for flag in row.get("quality_flags", []):
            kind, criterion_id = flag.split(":", 1)
            if kind == flag_prefix:
                counts[criterion_id] += 1
    return counts


def summarize_arm(rows: list[dict[str, Any]]) -> dict[str, Any]:
    total_criteria = len(rows) * len(CRITERIA)
    misses = sum(len(row.get("quality_flags", [])) for row in rows)
    return {
        "calls": len(rows),
        "agreement": total_criteria - misses,
        "total_criteria": total_criteria,
        "agreement_rate": (total_criteria - misses) / total_criteria if total_criteria else 0.0,
        "misses": misses,
        "schema_valid": sum(1 for row in rows if row.get("schema_valid")),
        "timeouts": sum(1 for row in rows if row.get("timeout_or_retry")),
        "avg_cost": statistics.mean(row.get("estimated_initial_grade_cost_usd", 0.0) for row in rows),
        "p50_latency_s": median([row.get("total_latency_ms", 0.0) / 1000 for row in rows]),
        "p95_latency_s": p95([row.get("total_latency_ms", 0.0) / 1000 for row in rows]),
        "avg_input": statistics.mean(row.get("input_tokens", 0) for row in rows),
        "avg_output": statistics.mean(row.get("output_tokens", 0) for row in rows),
        "avg_reasoning": statistics.mean(row.get("reasoning_tokens", 0) for row in rows),
        "avg_precedent_tokens": statistics.mean(row.get("retrieved_precedent_tokens", 0) for row in rows),
        "avg_precedent_count": statistics.mean(row.get("retrieved_precedent_count", 0) for row in rows),
    }


def bucket_for(library_size: int) -> str:
    if library_size <= 9:
        return "0-9"
    if library_size <= 24:
        return "10-24"
    if library_size <= 49:
        return "25-49"
    return "50-99"


def bucket_table(rows_by_arm: dict[str, list[dict[str, Any]]]) -> list[str]:
    lines = [
        "| Precedent library size | BM-Control agreement | BM-Flywheel agreement | Delta | Control misses | Flywheel misses |",
        "| --- | ---: | ---: | ---: | ---: | ---: |",
    ]
    for bucket in ["0-9", "10-24", "25-49", "50-99"]:
        bucket_rows = {
            arm: [row for row in rows if bucket_for(row.get("precedent_library_size", 0)) == bucket]
            for arm, rows in rows_by_arm.items()
        }
        rates = {}
        misses = {}
        for arm, rows in bucket_rows.items():
            total = len(rows) * len(CRITERIA)
            miss = sum(len(row.get("quality_flags", [])) for row in rows)
            rates[arm] = (total - miss) / total if total else 0.0
            misses[arm] = miss
        lines.append(
            f"| {bucket} | {pct(rates['bm_control'])} | {pct(rates['bm_flywheel'])} | "
            f"{(rates['bm_flywheel'] - rates['bm_control']) * 100:+.1f} pp | "
            f"{misses['bm_control']} | {misses['bm_flywheel']} |"
        )
    return lines


def moving_windows(rows_by_arm: dict[str, list[dict[str, Any]]], size: int = 10) -> list[str]:
    lines = [
        "| Answer window | BM-Control agreement | BM-Flywheel agreement | Delta |",
        "| --- | ---: | ---: | ---: |",
    ]
    for start in range(1, 101, size):
        end = min(start + size - 1, 100)
        rates = {}
        for arm, rows in rows_by_arm.items():
            window_rows = [row for row in rows if start <= row.get("sequence_index", 0) <= end]
            total = len(window_rows) * len(CRITERIA)
            miss = sum(len(row.get("quality_flags", [])) for row in window_rows)
            rates[arm] = (total - miss) / total if total else 0.0
        lines.append(
            f"| {start}-{end} | {pct(rates['bm_control'])} | {pct(rates['bm_flywheel'])} | "
            f"{(rates['bm_flywheel'] - rates['bm_control']) * 100:+.1f} pp |"
        )
    return lines


def paired_changes(rows_by_arm: dict[str, list[dict[str, Any]]]) -> dict[str, Any]:
    by_id = {
        arm: {row["response_id"]: row for row in rows}
        for arm, rows in rows_by_arm.items()
    }
    fixed: list[str] = []
    introduced: list[str] = []
    worsened: list[str] = []
    improved: list[str] = []
    same: list[str] = []
    for response_id, control in sorted(by_id["bm_control"].items()):
        flywheel = by_id["bm_flywheel"][response_id]
        control_flags = set(control.get("quality_flags", []))
        flywheel_flags = set(flywheel.get("quality_flags", []))
        fixed.extend(f"{response_id}:{flag}" for flag in sorted(control_flags - flywheel_flags))
        introduced.extend(f"{response_id}:{flag}" for flag in sorted(flywheel_flags - control_flags))
        if len(flywheel_flags) > len(control_flags):
            worsened.append(response_id)
        elif len(flywheel_flags) < len(control_flags):
            improved.append(response_id)
        else:
            same.append(response_id)
    return {
        "fixed": fixed,
        "introduced": introduced,
        "improved_responses": improved,
        "worsened_responses": worsened,
        "same_responses": same,
    }


def criterion_table(rows_by_arm: dict[str, list[dict[str, Any]]]) -> list[str]:
    lines = [
        "| Criterion | Control under | Flywheel under | Control over | Flywheel over |",
        "| --- | ---: | ---: | ---: | ---: |",
    ]
    under = {arm: criterion_flag_counts(rows, "under_credit") for arm, rows in rows_by_arm.items()}
    over = {arm: criterion_flag_counts(rows, "over_credit") for arm, rows in rows_by_arm.items()}
    for criterion_id in CRITERIA:
        lines.append(
            f"| {criterion_id} | {under['bm_control'][criterion_id]} | "
            f"{under['bm_flywheel'][criterion_id]} | {over['bm_control'][criterion_id]} | "
            f"{over['bm_flywheel'][criterion_id]} |"
        )
    return lines


def success_table(rows_by_arm: dict[str, list[dict[str, Any]]]) -> list[str]:
    final_rows = {
        arm: [row for row in rows if row.get("sequence_index", 0) >= 51]
        for arm, rows in rows_by_arm.items()
    }
    final_summaries = {arm: summarize_arm(rows) for arm, rows in final_rows.items()}
    final_delta = final_summaries["bm_flywheel"]["agreement_rate"] - final_summaries["bm_control"]["agreement_rate"]
    c2_under = {
        arm: criterion_flag_counts(rows, "under_credit")["FRQ02-C2"]
        for arm, rows in final_rows.items()
    }
    full_summaries = {arm: summarize_arm(rows) for arm, rows in rows_by_arm.items()}
    latency_increase = (
        full_summaries["bm_flywheel"]["p50_latency_s"] / full_summaries["bm_control"]["p50_latency_s"] - 1
        if full_summaries["bm_control"]["p50_latency_s"]
        else 0.0
    )
    cost_increase = (
        full_summaries["bm_flywheel"]["avg_cost"] / full_summaries["bm_control"]["avg_cost"] - 1
        if full_summaries["bm_control"]["avg_cost"]
        else 0.0
    )
    schema_ok = all(summary["schema_valid"] == summary["calls"] for summary in full_summaries.values())
    c2_reduction_ok = c2_under["bm_flywheel"] <= c2_under["bm_control"] / 2 if c2_under["bm_control"] else c2_under["bm_flywheel"] == 0
    no_new_pattern = sum(len(row.get("quality_flags", [])) for row in rows_by_arm["bm_flywheel"]) <= sum(
        len(row.get("quality_flags", [])) for row in rows_by_arm["bm_control"]
    )
    rows = [
        "| Threshold | Result | Pass? |",
        "| --- | --- | ---: |",
        f"| Final-50 agreement delta >= +5 pp | {final_delta * 100:+.1f} pp | {'Yes' if final_delta >= 0.05 else 'No'} |",
        f"| Final-50 FRQ02-C2 under-credit at least 50% lower | control {c2_under['bm_control']}, flywheel {c2_under['bm_flywheel']} | {'Yes' if c2_reduction_ok else 'No'} |",
        f"| No worse new overall flag pattern | control {full_summaries['bm_control']['misses']} misses, flywheel {full_summaries['bm_flywheel']['misses']} | {'Yes' if no_new_pattern else 'No'} |",
        f"| Schema validity 100% | control {full_summaries['bm_control']['schema_valid']}/100, flywheel {full_summaries['bm_flywheel']['schema_valid']}/100 | {'Yes' if schema_ok else 'No'} |",
        f"| p50 latency increase <30% | {latency_increase * 100:+.1f}% | {'Yes' if latency_increase < 0.30 else 'No'} |",
        f"| average cost increase <50% | {cost_increase * 100:+.1f}% | {'Yes' if cost_increase < 0.50 else 'No'} |",
    ]
    return rows


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    rows = load_rows(args.input)
    rows_by_arm = {arm: sorted([row for row in rows if row["experiment_arm"] == arm], key=lambda row: row["sequence_index"]) for arm in ARMS}
    summaries = {arm: summarize_arm(arm_rows) for arm, arm_rows in rows_by_arm.items()}
    changes = paired_changes(rows_by_arm)
    final_rows = {arm: [row for row in rows if row.get("sequence_index", 0) >= 51] for arm, rows in rows_by_arm.items()}
    final_summaries = {arm: summarize_arm(arm_rows) for arm, arm_rows in final_rows.items()}

    lines = [
        "# Bio Reference Layer Flywheel Volume Test Report",
        "",
        "**Status:** Completed first 100-answer online flywheel run",
        "**Run Date:** 2026-06-17",
        "**Raw Results:** `/private/tmp/cramapple-bio-ref-spike/frq02_flywheel_results_2026-06-17.jsonl`",
        "**Question:** `SPIKE-FRQ-02` Bottleneck Drift and Genetic Diversity",
        "**Model:** `gpt-5.5`, medium reasoning, compact output, `store:false`",
        "**Shuffle Seed:** `20260617`",
        "",
        "## Executive Summary",
        "",
        "The 100-answer run completed successfully, but the online criterion-precedent flywheel did not improve grading quality. BM-Control produced 100 valid JSON responses; BM-Flywheel produced 99 valid JSON responses and one malformed response, which was conservatively scored as missed earned criteria. BM-Flywheel trailed BM-Control on total criterion agreement and did not show the expected final-50 improvement as the precedent library grew.",
        "",
        "BM-Flywheel did not meet the protocol success threshold. It added input tokens, cost, and latency without a reliable quality gain. The most important interpretation is that this run validates the harness and rejects this specific retrieval/prompt design, not the broader idea of a scored-answer intelligence layer.",
        "",
        "## Overall Results",
        "",
        "| Arm | Agreement | Misses | Schema valid | Avg cost | p50 latency | p95 latency | Avg input | Avg output | Avg reasoning | Avg precedent tokens |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for arm in ARMS:
        summary = summaries[arm]
        lines.append(
            f"| {arm} | {summary['agreement']}/{summary['total_criteria']} ({pct(summary['agreement_rate'])}) | "
            f"{summary['misses']} | {summary['schema_valid']}/{summary['calls']} | {money(summary['avg_cost'])} | "
            f"{summary['p50_latency_s']:.2f}s | {summary['p95_latency_s']:.2f}s | "
            f"{summary['avg_input']:.1f} | {summary['avg_output']:.1f} | {summary['avg_reasoning']:.1f} | "
            f"{summary['avg_precedent_tokens']:.1f} |"
        )
    lines.extend(
        [
            "",
            "## Protocol Thresholds",
            "",
            *success_table(rows_by_arm),
            "",
            "## Learning Curve",
            "",
            *bucket_table(rows_by_arm),
            "",
            "## Moving Windows",
            "",
            *moving_windows(rows_by_arm),
            "",
            "## Final 50 Answers",
            "",
            "| Arm | Agreement | Misses | Avg cost | p50 latency | Avg reasoning |",
            "| --- | ---: | ---: | ---: | ---: | ---: |",
        ]
    )
    for arm in ARMS:
        summary = final_summaries[arm]
        lines.append(
            f"| {arm} | {summary['agreement']}/{summary['total_criteria']} ({pct(summary['agreement_rate'])}) | "
            f"{summary['misses']} | {money(summary['avg_cost'])} | {summary['p50_latency_s']:.2f}s | "
            f"{summary['avg_reasoning']:.1f} |"
        )
    lines.extend(
        [
            "",
            "## Error Pattern",
            "",
            *criterion_table(rows_by_arm),
            "",
            "## Paired Changes",
            "",
            f"- Flags fixed by flywheel: {len(changes['fixed'])}",
            f"- New flags introduced by flywheel: {len(changes['introduced'])}",
            f"- Responses improved: {len(changes['improved_responses'])}",
            f"- Responses worsened: {len(changes['worsened_responses'])}",
            f"- Responses unchanged by flag count: {len(changes['same_responses'])}",
            "",
            "Fixed flags:",
            "",
            ", ".join(changes["fixed"]) if changes["fixed"] else "None.",
            "",
            "Introduced flags:",
            "",
            ", ".join(changes["introduced"]) if changes["introduced"] else "None.",
            "",
            "## Interpretation",
            "",
            "This run supports three narrow conclusions:",
            "",
            "1. The flywheel harness is working: it processed 100 answers, used only prior approved labels as precedents, resumed safely, and produced complete measurements.",
            "2. The current criterion-precedent retrieval design is not enough. It neither improved final-50 agreement nor reduced `FRQ02-C2` under-credit in the online setting.",
            "3. The generated corpus is too easy and full-credit-heavy for a strong learning-curve decision. It is useful for validating mechanics, but the low miss rate leaves little headroom for a volume flywheel to demonstrate compounding improvement.",
            "",
            "The next test should either use a deliberately harder/borderline corpus for `FRQ02-C2`, or add an oracle-retrieval diagnostic to separate retrieval failure from prompt-use failure.",
            "",
            "Note: the single malformed flywheel response was `S008` at sequence 29. Its empty parsed status object was treated as under-credit on the earned criteria, which is the same conservative scoring rule used elsewhere in the reference-layer spike.",
            "",
        ]
    )

    args.output.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
