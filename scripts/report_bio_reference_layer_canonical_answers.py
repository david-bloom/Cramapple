#!/usr/bin/env python3
"""Aggregate the FRQ02-C2 canonical-answer comparison test."""

from __future__ import annotations

import argparse
import json
import statistics
from collections import Counter
from pathlib import Path
from typing import Any


DEFAULT_INPUT = Path("/private/tmp/cramapple-bio-ref-spike/frq02_canonical_answers_results.jsonl")
DEFAULT_OUTPUT = Path("docs/research/bio_reference_layer_canonical_answers_test_report.md")
ARMS = [
    "c2_original",
    "c2_v2",
    "c2_v2_canonical_2",
    "c2_v2_canonical_4",
]
BASELINE = "c2_original"
V2_BASELINE = "c2_v2"


def load_rows(path: Path) -> list[dict[str, Any]]:
    return [
        json.loads(line)
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]


def pct(value: float) -> str:
    return f"{value * 100:.1f}%"


def money(value: float) -> str:
    return f"${value:.5f}"


def signed_pct_delta(value: float, baseline: float) -> str:
    if baseline == 0:
        return "n/a"
    return f"{(value / baseline - 1) * 100:+.1f}%"


def signed_pp_delta(value: float, baseline: float) -> str:
    return f"{(value - baseline) * 100:+.1f} pp"


def median(values: list[float]) -> float:
    return statistics.median(values) if values else 0.0


def p95(values: list[float]) -> float:
    if not values:
        return 0.0
    ordered = sorted(values)
    return ordered[min(int(len(ordered) * 0.95), len(ordered) - 1)]


def summarize(rows: list[dict[str, Any]]) -> dict[str, Any]:
    calls = len(rows)
    quality_misses = sum(len(row.get("quality_flags", [])) for row in rows)
    strict_misses = sum(
        1
        for row in rows
        if row.get("quality_flags")
        or not row.get("schema_valid")
        or row.get("timeout_or_retry")
    )
    flags = Counter(flag for row in rows for flag in row.get("quality_flags", []))
    return {
        "calls": calls,
        "strict_correct": calls - strict_misses,
        "strict_misses": strict_misses,
        "strict_rate": (calls - strict_misses) / calls if calls else 0.0,
        "quality_correct": calls - quality_misses,
        "quality_misses": quality_misses,
        "quality_rate": (calls - quality_misses) / calls if calls else 0.0,
        "schema_valid": sum(1 for row in rows if row.get("schema_valid")),
        "timeouts": sum(1 for row in rows if row.get("timeout_or_retry")),
        "under": flags["under_credit:FRQ02-C2"],
        "over": flags["over_credit:FRQ02-C2"],
        "avg_cost": statistics.mean(
            row.get("estimated_initial_grade_cost_usd", 0.0) for row in rows
        )
        if rows
        else 0.0,
        "p50_latency_s": median(
            [row.get("total_latency_ms", 0.0) / 1000 for row in rows]
        ),
        "p95_latency_s": p95(
            [row.get("total_latency_ms", 0.0) / 1000 for row in rows]
        ),
        "avg_input": statistics.mean(row.get("input_tokens", 0) for row in rows)
        if rows
        else 0.0,
        "avg_output": statistics.mean(row.get("output_tokens", 0) for row in rows)
        if rows
        else 0.0,
        "avg_reasoning": statistics.mean(
            row.get("reasoning_tokens", 0) for row in rows
        )
        if rows
        else 0.0,
        "avg_canonical_answers": statistics.mean(
            row.get("canonical_answer_count", 0) for row in rows
        )
        if rows
        else 0.0,
    }


def paired_changes(
    rows_by_arm: dict[str, list[dict[str, Any]]], baseline_arm: str, arm: str
) -> dict[str, list[str]]:
    baseline = {row["response_id"]: row for row in rows_by_arm[baseline_arm]}
    variant = {row["response_id"]: row for row in rows_by_arm[arm]}
    fixed: list[str] = []
    introduced: list[str] = []
    changed: list[str] = []
    for response_id, baseline_row in sorted(baseline.items()):
        if response_id not in variant:
            continue
        baseline_bad = (
            bool(baseline_row.get("quality_flags"))
            or not baseline_row.get("schema_valid")
            or baseline_row.get("timeout_or_retry")
        )
        variant_bad = (
            bool(variant[response_id].get("quality_flags"))
            or not variant[response_id].get("schema_valid")
            or variant[response_id].get("timeout_or_retry")
        )
        if baseline_bad and not variant_bad:
            fixed.append(response_id)
        if not baseline_bad and variant_bad:
            introduced.append(response_id)
        if baseline_row.get("model_status") != variant[response_id].get("model_status"):
            changed.append(response_id)
    return {"fixed": fixed, "introduced": introduced, "changed": changed}


def label_table(rows_by_arm: dict[str, list[dict[str, Any]]]) -> list[str]:
    lines = [
        "| Human label | Arm | Strict agreement | Under-credit | Over-credit |",
        "| --- | --- | ---: | ---: | ---: |",
    ]
    for label in ["earned", "not_earned"]:
        for arm in ARMS:
            rows = [row for row in rows_by_arm.get(arm, []) if row["human_status"] == label]
            summary = summarize(rows)
            lines.append(
                f"| {label} | {arm} | {summary['strict_correct']}/{summary['calls']} ({pct(summary['strict_rate'])}) | "
                f"{summary['under']} | {summary['over']} |"
            )
    return lines


def comparison_table(
    summaries: dict[str, dict[str, Any]], baseline_arm: str, arms: list[str]
) -> list[str]:
    baseline = summaries[baseline_arm]
    lines = [
        f"| Arm | Strict agreement delta vs `{baseline_arm}` | Cost delta | p50 latency delta | Input token delta | Output token delta | Reasoning token delta |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for arm in arms:
        summary = summaries[arm]
        lines.append(
            f"| {arm} | {signed_pp_delta(summary['strict_rate'], baseline['strict_rate'])} | "
            f"{signed_pct_delta(summary['avg_cost'], baseline['avg_cost'])} | "
            f"{signed_pct_delta(summary['p50_latency_s'], baseline['p50_latency_s'])} | "
            f"{signed_pct_delta(summary['avg_input'], baseline['avg_input'])} | "
            f"{signed_pct_delta(summary['avg_output'], baseline['avg_output'])} | "
            f"{signed_pct_delta(summary['avg_reasoning'], baseline['avg_reasoning'])} |"
        )
    return lines


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    rows = load_rows(args.input)
    rows_by_arm = {
        arm: sorted(
            [row for row in rows if row["experiment_arm"] == arm],
            key=lambda row: row["response_id"],
        )
        for arm in ARMS
    }
    summaries = {arm: summarize(arm_rows) for arm, arm_rows in rows_by_arm.items()}
    available_arms = [arm for arm in ARMS if summaries[arm]["calls"]]
    if BASELINE not in available_arms:
        raise SystemExit(f"missing baseline arm: {BASELINE}")

    best_arm = max(available_arms, key=lambda arm: summaries[arm]["strict_rate"])
    best_delta = summaries[best_arm]["strict_rate"] - summaries[BASELINE]["strict_rate"]

    lines = [
        "# Bio Reference Layer Canonical Answer Test Report",
        "",
        "**Status:** Generated report",
        f"**Raw Results:** `{args.input}`",
        "**Question:** `SPIKE-FRQ-02` Bottleneck Drift and Genetic Diversity",
        "**Criterion:** `FRQ02-C2` original vs `FRQ02-C2.v2`",
        "**Label basis:** Existing Learning Quality-approved FRQ02-C2 labels. If `FRQ02-C2.v2` changes the scoring boundary rather than clarifying it, labels must be re-adjudicated before promotion decisions.",
        "",
        "## Executive Summary",
        "",
        f"The best strict arm was `{best_arm}`, with {best_delta * 100:+.1f} percentage points versus `c2_original`.",
        "",
        "This report separates two questions: first, whether the revised criterion wording changes grading behavior; second, whether adding two or four canonical answers improves enough to justify extra prompt tokens.",
        "",
        "## Overall Results",
        "",
        "| Arm | Strict agreement | Quality-only agreement | Strict misses | Quality flags | Under-credit | Over-credit | Schema valid | Timeouts | Avg cost | p50 latency | p95 latency | Avg input | Avg output | Avg reasoning | Avg canonical answers |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for arm in available_arms:
        summary = summaries[arm]
        lines.append(
            f"| {arm} | {summary['strict_correct']}/{summary['calls']} ({pct(summary['strict_rate'])}) | "
            f"{summary['quality_correct']}/{summary['calls']} ({pct(summary['quality_rate'])}) | "
            f"{summary['strict_misses']} | {summary['quality_misses']} | {summary['under']} | {summary['over']} | "
            f"{summary['schema_valid']}/{summary['calls']} | {summary['timeouts']} | {money(summary['avg_cost'])} | "
            f"{summary['p50_latency_s']:.2f}s | {summary['p95_latency_s']:.2f}s | "
            f"{summary['avg_input']:.1f} | {summary['avg_output']:.1f} | {summary['avg_reasoning']:.1f} | "
            f"{summary['avg_canonical_answers']:.1f} |"
        )

    lines.extend(
        [
            "",
            "## Original to v2",
            "",
            *comparison_table(summaries, BASELINE, [arm for arm in available_arms if arm != BASELINE]),
        ]
    )
    if V2_BASELINE in available_arms:
        lines.extend(
            [
                "",
                "## v2 to Canonical Answers",
                "",
                *comparison_table(
                    summaries,
                    V2_BASELINE,
                    [
                        arm
                        for arm in ["c2_v2_canonical_2", "c2_v2_canonical_4"]
                        if arm in available_arms
                    ],
                ),
            ]
        )

    lines.extend(["", "## By Human Label", "", *label_table(rows_by_arm)])

    lines.extend(["", "## Paired Changes", ""])
    for baseline_arm, title, arms in [
        (BASELINE, "Against original C2", [arm for arm in available_arms if arm != BASELINE]),
        (
            V2_BASELINE,
            "Against C2.v2",
            [
                arm
                for arm in ["c2_v2_canonical_2", "c2_v2_canonical_4"]
                if arm in available_arms
            ],
        ),
    ]:
        if baseline_arm not in available_arms:
            continue
        lines.extend([f"### {title}", ""])
        for arm in arms:
            changes = paired_changes(rows_by_arm, baseline_arm, arm)
            lines.extend(
                [
                    f"#### {arm}",
                    "",
                    f"- Baseline errors fixed: {len(changes['fixed'])}",
                    f"- New errors introduced: {len(changes['introduced'])}",
                    f"- Model-status changes: {len(changes['changed'])}",
                    f"- Fixed response IDs: {', '.join(changes['fixed']) if changes['fixed'] else 'None'}",
                    f"- Introduced response IDs: {', '.join(changes['introduced']) if changes['introduced'] else 'None'}",
                    "",
                ]
            )

    lines.extend(
        [
            "## Decision Rules",
            "",
            "- `FRQ02-C2.v2` is useful if it improves strict agreement versus `c2_original` without increasing cost or latency materially.",
            "- Canonical answers are useful if they improve strict agreement versus `c2_v2` enough to justify their input-token increase.",
            "- Four canonical answers should beat two canonical answers on strict quality, not merely produce longer prompts.",
            "- Any v2 arm that changes intended labels needs Learning Quality re-adjudication before promotion.",
            "",
        ]
    )

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
