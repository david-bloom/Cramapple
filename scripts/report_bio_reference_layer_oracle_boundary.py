#!/usr/bin/env python3
"""Aggregate the FRQ02-C2 oracle boundary-memory diagnostic test."""

from __future__ import annotations

import argparse
import json
import statistics
from collections import Counter
from pathlib import Path
from typing import Any


DEFAULT_INPUT = Path("/private/tmp/cramapple-bio-ref-spike/frq02_oracle_boundary_results_2026-06-17.jsonl")
DEFAULT_OUTPUT = Path("docs/research/bio_reference_layer_oracle_boundary_test_report.md")
ARMS = ["bm_control", "oracle_precedents", "boundary_table", "boundary_table_low"]


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


def summarize(rows: list[dict[str, Any]]) -> dict[str, Any]:
    calls = len(rows)
    quality_misses = sum(len(row.get("quality_flags", [])) for row in rows)
    strict_misses = sum(1 for row in rows if row.get("quality_flags") or not row.get("schema_valid"))
    flags = Counter(flag for row in rows for flag in row.get("quality_flags", []))
    return {
        "calls": calls,
        "quality_correct": calls - quality_misses,
        "quality_misses": quality_misses,
        "quality_agreement_rate": (calls - quality_misses) / calls if calls else 0.0,
        "strict_correct": calls - strict_misses,
        "strict_misses": strict_misses,
        "strict_agreement_rate": (calls - strict_misses) / calls if calls else 0.0,
        "schema_valid": sum(1 for row in rows if row.get("schema_valid")),
        "under": flags["under_credit:FRQ02-C2"],
        "over": flags["over_credit:FRQ02-C2"],
        "avg_cost": statistics.mean(row.get("estimated_initial_grade_cost_usd", 0.0) for row in rows) if rows else 0.0,
        "p50_latency_s": median([row.get("total_latency_ms", 0.0) / 1000 for row in rows]),
        "p95_latency_s": p95([row.get("total_latency_ms", 0.0) / 1000 for row in rows]),
        "avg_input": statistics.mean(row.get("input_tokens", 0) for row in rows) if rows else 0.0,
        "avg_output": statistics.mean(row.get("output_tokens", 0) for row in rows) if rows else 0.0,
        "avg_reasoning": statistics.mean(row.get("reasoning_tokens", 0) for row in rows) if rows else 0.0,
        "avg_precedents": statistics.mean(row.get("retrieved_precedent_count", 0) for row in rows) if rows else 0.0,
    }


def paired_changes(rows_by_arm: dict[str, list[dict[str, Any]]], arm: str) -> dict[str, list[str]]:
    control = {row["response_id"]: row for row in rows_by_arm["bm_control"]}
    variant = {row["response_id"]: row for row in rows_by_arm[arm]}
    fixed: list[str] = []
    introduced: list[str] = []
    for response_id, control_row in sorted(control.items()):
        control_bad = bool(control_row.get("quality_flags")) or not control_row.get("schema_valid")
        variant_bad = bool(variant[response_id].get("quality_flags")) or not variant[response_id].get("schema_valid")
        if control_bad and not variant_bad:
            fixed.append(response_id)
        if not control_bad and variant_bad:
            introduced.append(response_id)
    return {"fixed": fixed, "introduced": introduced}


def label_table(rows_by_arm: dict[str, list[dict[str, Any]]]) -> list[str]:
    lines = [
        "| Human label | Arm | Agreement | Under-credit | Over-credit |",
        "| --- | --- | ---: | ---: | ---: |",
    ]
    for label in ["earned", "not_earned"]:
        for arm in ARMS:
            rows = [row for row in rows_by_arm[arm] if row["human_status"] == label]
            summary = summarize(rows)
            lines.append(
                f"| {label} | {arm} | {summary['strict_correct']}/{summary['calls']} ({pct(summary['strict_agreement_rate'])}) | "
                f"{summary['under']} | {summary['over']} |"
            )
    return lines


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    rows = load_rows(args.input)
    rows_by_arm = {arm: sorted([row for row in rows if row["experiment_arm"] == arm], key=lambda row: row["response_id"]) for arm in ARMS}
    summaries = {arm: summarize(arm_rows) for arm, arm_rows in rows_by_arm.items()}
    control_summary = summaries["bm_control"]

    lines = [
        "# Bio Reference Layer Oracle Boundary-Memory Test Report",
        "",
        "**Status:** Completed diagnostic run",
        "**Run Date:** 2026-06-17",
        f"**Raw Results:** `{args.input}`",
        "**Question:** `SPIKE-FRQ-02` Bottleneck Drift and Genetic Diversity",
        "**Criterion:** `FRQ02-C2` random/non-selective construction event",
        "**Model:** `gpt-5.5`; medium reasoning except `boundary_table_low` uses low reasoning; `store:false`",
        "",
        "## Executive Summary",
        "",
    ]
    best_arm = max(ARMS, key=lambda arm: summaries[arm]["strict_agreement_rate"])
    if best_arm == "bm_control":
        lines.append(
            "On a strict production-style metric where malformed or timed-out calls count as misses, the diagnostic did not find a memory intervention that beats the no-memory control. The oracle-precedent arm improved quality-only C2 decisions when it returned valid JSON, but it was slower, less schema-reliable, and did not beat BM-Control operationally."
        )
    else:
        delta = summaries[best_arm]["strict_agreement_rate"] - control_summary["strict_agreement_rate"]
        lines.append(
            f"The best strict arm was `{best_arm}`, improving C2 agreement by {delta * 100:+.1f} percentage points versus BM-Control."
        )
    quality_delta = summaries["oracle_precedents"]["quality_agreement_rate"] - control_summary["quality_agreement_rate"]
    lines.append(
        f"Quality-only diagnostic signal: `oracle_precedents` improved valid-decision C2 agreement by {quality_delta * 100:+.1f} percentage points versus BM-Control before penalizing schema/timeouts."
    )
    lines.extend(
        [
            "",
            "## Overall Results",
            "",
            "| Arm | Strict agreement | Quality-only agreement | Strict misses | Quality flags | Under-credit | Over-credit | Schema valid | Avg cost | p50 latency | p95 latency | Avg input | Avg output | Avg reasoning | Avg precedents |",
            "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
        ]
    )
    for arm in ARMS:
        summary = summaries[arm]
        lines.append(
            f"| {arm} | {summary['strict_correct']}/{summary['calls']} ({pct(summary['strict_agreement_rate'])}) | "
            f"{summary['quality_correct']}/{summary['calls']} ({pct(summary['quality_agreement_rate'])}) | "
            f"{summary['strict_misses']} | {summary['quality_misses']} | {summary['under']} | {summary['over']} | "
            f"{summary['schema_valid']}/{summary['calls']} | {money(summary['avg_cost'])} | "
            f"{summary['p50_latency_s']:.2f}s | {summary['p95_latency_s']:.2f}s | "
            f"{summary['avg_input']:.1f} | {summary['avg_output']:.1f} | {summary['avg_reasoning']:.1f} | "
            f"{summary['avg_precedents']:.1f} |"
        )
    lines.extend(
        [
            "",
            "## By Human Label",
            "",
            *label_table(rows_by_arm),
            "",
            "## Paired Changes vs BM-Control",
            "",
        ]
    )
    for arm in ["oracle_precedents", "boundary_table", "boundary_table_low"]:
        changes = paired_changes(rows_by_arm, arm)
        lines.extend(
            [
                f"### {arm}",
                "",
                f"- Control errors fixed: {len(changes['fixed'])}",
                f"- New errors introduced: {len(changes['introduced'])}",
                f"- Fixed response IDs: {', '.join(changes['fixed']) if changes['fixed'] else 'None'}",
                f"- Introduced response IDs: {', '.join(changes['introduced']) if changes['introduced'] else 'None'}",
                "",
            ]
        )
    lines.extend(
        [
            "## Interpretation Guide",
            "",
            "- If `oracle_precedents` wins, scored examples contain useful signal and the prior flywheel failure was mainly retrieval/prompt design.",
            "- If `boundary_table` wins, compact distilled rubric-boundary memory is better than exemplar retrieval for this criterion.",
            "- If `boundary_table_low` matches or beats BM-Control while cheaper/faster, memory may support a lower-reasoning production path.",
            "- If no arm beats BM-Control, the next lever is likely grader-agent/prompt optimization rather than a reference layer for this criterion.",
            "",
        ]
    )
    args.output.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
