#!/usr/bin/env python3
"""Aggregate validator for the Bio Reference Layer spike.

This script intentionally does not call a model provider. It validates JSONL
records produced by a separate, approved runner and writes an aggregate
Markdown report with no PDF-derived content.
"""

from __future__ import annotations

import argparse
import json
from collections import defaultdict
from pathlib import Path
from statistics import mean, median
from typing import Optional


REQUIRED_FIELDS = [
    "experiment_arm",
    "model_id",
    "reasoning_effort",
    "prompt_version",
    "prompt_hash",
    "output_schema_version",
    "prompt_caching_status",
    "cached_tokens",
    "question_id",
    "response_id",
    "input_tokens",
    "output_tokens",
    "reasoning_tokens",
    "reference_tokens",
    "app_latency_ms",
    "provider_latency_ms",
    "total_latency_ms",
    "estimated_initial_grade_cost_usd",
    "estimated_full_attempt_cost_usd",
    "schema_valid",
    "timeout_or_retry",
    "points_earned",
    "criterion_statuses",
    "highest_value_gap",
    "minimum_fix_length",
    "confidence",
    "uncertainty_reason",
    "quality_flags",
]


def percentile(values: list[float], p: float) -> float | None:
    if not values:
        return None
    ordered = sorted(values)
    if len(ordered) == 1:
        return ordered[0]
    rank = (len(ordered) - 1) * p
    lower = int(rank)
    upper = min(lower + 1, len(ordered) - 1)
    weight = rank - lower
    return ordered[lower] * (1 - weight) + ordered[upper] * weight


def load_records(path: Path) -> tuple[list[dict], list[str]]:
    records: list[dict] = []
    errors: list[str] = []
    with path.open("r", encoding="utf-8") as handle:
        for line_number, line in enumerate(handle, start=1):
            stripped = line.strip()
            if not stripped:
                continue
            try:
                record = json.loads(stripped)
            except json.JSONDecodeError as exc:
                errors.append(f"line {line_number}: invalid JSON: {exc}")
                continue
            missing = [field for field in REQUIRED_FIELDS if field not in record]
            if missing:
                errors.append(
                    f"line {line_number}: missing fields: {', '.join(missing)}"
                )
            records.append(record)
    return records, errors


def numeric(record: dict, field: str) -> float:
    value = record.get(field, 0)
    if value is None:
        return 0.0
    return float(value)


def aggregate(records: list[dict]) -> dict[str, dict]:
    grouped: dict[str, list[dict]] = defaultdict(list)
    for record in records:
        grouped[str(record["experiment_arm"])].append(record)

    summary: dict[str, dict] = {}
    for arm, arm_records in sorted(grouped.items()):
        latencies = [numeric(record, "total_latency_ms") for record in arm_records]
        costs = [
            numeric(record, "estimated_initial_grade_cost_usd")
            for record in arm_records
        ]
        full_costs = [
            numeric(record, "estimated_full_attempt_cost_usd")
            for record in arm_records
        ]
        input_tokens = [numeric(record, "input_tokens") for record in arm_records]
        output_tokens = [numeric(record, "output_tokens") for record in arm_records]
        reasoning_tokens = [
            numeric(record, "reasoning_tokens") for record in arm_records
        ]
        reference_tokens = [
            numeric(record, "reference_tokens") for record in arm_records
        ]
        cached_tokens = [numeric(record, "cached_tokens") for record in arm_records]
        schema_valid = sum(1 for record in arm_records if record["schema_valid"])
        retries = sum(1 for record in arm_records if record["timeout_or_retry"])

        quality_counts: dict[str, int] = defaultdict(int)
        quality_flag_total = 0
        strict_success = 0
        for record in arm_records:
            flags = record.get("quality_flags") or []
            if isinstance(flags, str):
                flags = [flags]
            quality_flag_total += len(flags)
            if record["schema_valid"] and not record["timeout_or_retry"] and not flags:
                strict_success += 1
            for flag in flags:
                quality_counts[str(flag)] += 1

        summary[arm] = {
            "count": len(arm_records),
            "p50_latency_ms": median(latencies) if latencies else None,
            "p95_latency_ms": percentile(latencies, 0.95),
            "avg_initial_cost_usd": mean(costs) if costs else None,
            "avg_full_attempt_cost_usd": mean(full_costs) if full_costs else None,
            "avg_input_tokens": mean(input_tokens) if input_tokens else None,
            "avg_output_tokens": mean(output_tokens) if output_tokens else None,
            "avg_reasoning_tokens": mean(reasoning_tokens)
            if reasoning_tokens
            else None,
            "avg_reference_tokens": mean(reference_tokens)
            if reference_tokens
            else None,
            "avg_cached_tokens": mean(cached_tokens) if cached_tokens else None,
            "schema_valid_rate": schema_valid / len(arm_records)
            if arm_records
            else None,
            "strict_success_rate": strict_success / len(arm_records)
            if arm_records
            else None,
            "retry_count": retries,
            "quality_flag_total": quality_flag_total,
            "quality_flags_per_call": quality_flag_total / len(arm_records)
            if arm_records
            else None,
            "quality_counts": dict(sorted(quality_counts.items())),
        }
    return summary


def pct_delta(value: Optional[float], baseline: Optional[float]) -> Optional[float]:
    if value is None or baseline in (None, 0):
        return None
    return value / baseline - 1


def pp_delta(value: Optional[float], baseline: Optional[float]) -> Optional[float]:
    if value is None or baseline is None:
        return None
    return value - baseline


def dominates(candidate: dict, other: dict) -> bool:
    lower_is_better = [
        "p50_latency_ms",
        "avg_initial_cost_usd",
        "quality_flags_per_call",
    ]
    higher_is_better = ["schema_valid_rate", "strict_success_rate"]
    no_worse = all(
        candidate[field] is not None
        and other[field] is not None
        and candidate[field] <= other[field]
        for field in lower_is_better
    ) and all(
        candidate[field] is not None
        and other[field] is not None
        and candidate[field] >= other[field]
        for field in higher_is_better
    )
    strictly_better = any(
        candidate[field] is not None
        and other[field] is not None
        and candidate[field] < other[field]
        for field in lower_is_better
    ) or any(
        candidate[field] is not None
        and other[field] is not None
        and candidate[field] > other[field]
        for field in higher_is_better
    )
    return no_worse and strictly_better


def pareto_frontier(summary: dict[str, dict]) -> list[str]:
    frontier: list[str] = []
    for arm, data in summary.items():
        if not any(
            other_arm != arm and dominates(other_data, data)
            for other_arm, other_data in summary.items()
        ):
            frontier.append(arm)
    return frontier


def fmt(value: object) -> str:
    if value is None:
        return "n/a"
    if isinstance(value, float):
        return f"{value:.4f}"
    return str(value)


def fmt_delta(value: Optional[float], suffix: str = "%") -> str:
    if value is None:
        return "n/a"
    if suffix == "pp":
        return f"{value * 100:+.1f} pp"
    return f"{value * 100:+.1f}%"


def write_report(
    path: Path, summary: dict[str, dict], errors: list[str], baseline_arm: Optional[str]
) -> None:
    lines: list[str] = [
        "# Bio Reference Layer Spike Aggregate Report",
        "",
        "**Status:** Generated aggregate report",
        "",
        "## Validation",
        "",
    ]
    if errors:
        lines.append("Validation errors:")
        lines.append("")
        for error in errors:
            lines.append(f"- {error}")
    else:
        lines.append("No validation errors detected.")

    lines.extend(
        [
            "",
            "## Aggregate By Arm",
            "",
            "| Arm | Calls | p50 latency ms | p95 latency ms | Avg initial cost | Avg full-attempt cost | Avg input tokens | Avg output tokens | Avg reasoning tokens | Avg reference tokens | Avg cached tokens | Schema valid rate | Strict success rate | Quality flags/call | Retries |",
            "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
        ]
    )
    for arm, data in summary.items():
        lines.append(
            "| "
            + " | ".join(
                [
                    arm,
                    fmt(data["count"]),
                    fmt(data["p50_latency_ms"]),
                    fmt(data["p95_latency_ms"]),
                    fmt(data["avg_initial_cost_usd"]),
                    fmt(data["avg_full_attempt_cost_usd"]),
                    fmt(data["avg_input_tokens"]),
                    fmt(data["avg_output_tokens"]),
                    fmt(data["avg_reasoning_tokens"]),
                    fmt(data["avg_reference_tokens"]),
                    fmt(data["avg_cached_tokens"]),
                    fmt(data["schema_valid_rate"]),
                    fmt(data["strict_success_rate"]),
                    fmt(data["quality_flags_per_call"]),
                    fmt(data["retry_count"]),
                ]
            )
            + " |"
        )

    selected_baseline = baseline_arm
    if selected_baseline is None and summary:
        selected_baseline = next(iter(summary))
    if selected_baseline in summary:
        baseline = summary[selected_baseline]
        lines.extend(
            [
                "",
                f"## Comparison vs `{selected_baseline}`",
                "",
                "| Arm | p50 latency delta | Avg cost delta | Input token delta | Output token delta | Reasoning token delta | Reference token delta | Strict success delta | Quality flags/call delta |",
                "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
            ]
        )
        for arm, data in summary.items():
            lines.append(
                "| "
                + " | ".join(
                    [
                        arm,
                        fmt_delta(
                            pct_delta(
                                data["p50_latency_ms"], baseline["p50_latency_ms"]
                            )
                        ),
                        fmt_delta(
                            pct_delta(
                                data["avg_initial_cost_usd"],
                                baseline["avg_initial_cost_usd"],
                            )
                        ),
                        fmt_delta(
                            pct_delta(
                                data["avg_input_tokens"],
                                baseline["avg_input_tokens"],
                            )
                        ),
                        fmt_delta(
                            pct_delta(
                                data["avg_output_tokens"],
                                baseline["avg_output_tokens"],
                            )
                        ),
                        fmt_delta(
                            pct_delta(
                                data["avg_reasoning_tokens"],
                                baseline["avg_reasoning_tokens"],
                            )
                        ),
                        fmt_delta(
                            pct_delta(
                                data["avg_reference_tokens"],
                                baseline["avg_reference_tokens"],
                            )
                        ),
                        fmt_delta(
                            pp_delta(
                                data["strict_success_rate"],
                                baseline["strict_success_rate"],
                            ),
                            "pp",
                        ),
                        fmt_delta(
                            pct_delta(
                                data["quality_flags_per_call"],
                                baseline["quality_flags_per_call"],
                            )
                        ),
                    ]
                )
                + " |"
            )
    elif baseline_arm:
        lines.extend(
            [
                "",
                "## Comparison",
                "",
                f"Baseline arm `{baseline_arm}` was not present in the input.",
            ]
        )

    frontier = pareto_frontier(summary)
    lines.extend(
        [
            "",
            "## Tradeoff Analysis",
            "",
            f"- Pareto frontier arms: {', '.join(frontier) if frontier else 'n/a'}.",
        ]
    )
    dominated = [
        arm
        for arm, data in summary.items()
        if any(
            other_arm != arm and dominates(other_data, data)
            for other_arm, other_data in summary.items()
        )
    ]
    if dominated:
        lines.append(f"- Dominated arms: {', '.join(dominated)}.")
    else:
        lines.append("- No arm strictly dominates another on p50 latency, cost, quality flags, schema validity, and strict success.")

    if summary:
        fastest = min(
            summary,
            key=lambda arm: summary[arm]["p50_latency_ms"]
            if summary[arm]["p50_latency_ms"] is not None
            else float("inf"),
        )
        cheapest = min(
            summary,
            key=lambda arm: summary[arm]["avg_initial_cost_usd"]
            if summary[arm]["avg_initial_cost_usd"] is not None
            else float("inf"),
        )
        cleanest = min(
            summary,
            key=lambda arm: summary[arm]["quality_flags_per_call"]
            if summary[arm]["quality_flags_per_call"] is not None
            else float("inf"),
        )
        lines.extend(
            [
                f"- Fastest p50 latency arm: `{fastest}` ({fmt(summary[fastest]['p50_latency_ms'])} ms).",
                f"- Lowest initial-cost arm: `{cheapest}` ({fmt(summary[cheapest]['avg_initial_cost_usd'])}).",
                f"- Fewest quality flags per call: `{cleanest}` ({fmt(summary[cleanest]['quality_flags_per_call'])}).",
            ]
        )

    if selected_baseline in summary:
        baseline = summary[selected_baseline]
        reference_heavy = [
            arm
            for arm, data in summary.items()
            if arm != selected_baseline
            and (data["avg_reference_tokens"] or 0) > (baseline["avg_reference_tokens"] or 0)
            and (data["quality_flags_per_call"] or 0)
            >= (baseline["quality_flags_per_call"] or 0)
        ]
        if reference_heavy:
            lines.append(
                "- Reference-token warning: "
                + ", ".join(f"`{arm}`" for arm in reference_heavy)
                + " used more reference context without lowering quality flags per call."
            )

    lines.extend(["", "## Quality Flags", ""])
    for arm, data in summary.items():
        lines.append(f"### {arm}")
        lines.append("")
        quality_counts = data["quality_counts"]
        if not quality_counts:
            lines.append("- No quality flags recorded.")
        else:
            for flag, count in quality_counts.items():
                lines.append(f"- {flag}: {count}")
        lines.append("")

    path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument(
        "--baseline-arm",
        help="Experiment arm to use for delta tables. Defaults to the first sorted arm.",
    )
    args = parser.parse_args()

    records, errors = load_records(args.input)
    summary = aggregate(records)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    write_report(args.output, summary, errors, args.baseline_arm)

    if errors:
        print(f"Wrote report with {len(errors)} validation error(s): {args.output}")
        return 1
    print(f"Wrote aggregate report: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
