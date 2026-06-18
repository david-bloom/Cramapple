#!/usr/bin/env python3
"""Generate the scored-exemplar follow-up report."""

from __future__ import annotations

import json
from collections import Counter, defaultdict
from pathlib import Path
from statistics import mean, median


ROOT = Path(__file__).resolve().parents[1]
BM_PATH = Path("/private/tmp/cramapple-bio-ref-spike/gate_results_2026-06-17.jsonl")
BME_PATH = Path("/private/tmp/cramapple-bio-ref-spike/exemplar_results_2026-06-17.jsonl")
OUT_PATH = ROOT / "docs/research/bio_reference_layer_exemplar_test_report.md"


def load_jsonl(path: Path) -> list[dict]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def flag_counts(rows: list[dict]) -> Counter:
    counts: Counter = Counter()
    for row in rows:
        for flag in row.get("quality_flags", []):
            counts[flag] += 1
    return counts


def agreement(rows: list[dict]) -> tuple[int, int]:
    total = 0
    misses = 0
    for row in rows:
        statuses = row.get("criterion_statuses") or {}
        total += len(statuses) if statuses else 4
        misses += len(row.get("quality_flags", []))
    return total - misses, total


def avg(rows: list[dict], field: str) -> float:
    return mean(float(row.get(field) or 0) for row in rows)


def p50(rows: list[dict], field: str) -> float:
    return median(float(row.get(field) or 0) for row in rows)


def fmt_money(value: float) -> str:
    return f"${value:.4f}"


def main() -> int:
    gate_rows = load_jsonl(BM_PATH)
    bm_rows = [
        row for row in gate_rows if row["experiment_arm"] == "arm_bm_medium_compact_no_cards"
    ]
    bme_rows = load_jsonl(BME_PATH)

    bm_by_key = {(row["question_id"], row["response_id"]): row for row in bm_rows}
    bme_by_key = {(row["question_id"], row["response_id"]): row for row in bme_rows}

    change_counts: Counter = Counter()
    changed_rows: list[str] = []
    for key, bme in sorted(bme_by_key.items()):
        bm = bm_by_key.get(key)
        if not bm:
            continue
        bm_flags = set(bm.get("quality_flags", []))
        bme_flags = set(bme.get("quality_flags", []))
        fixed = bm_flags - bme_flags
        introduced = bme_flags - bm_flags
        if fixed or introduced:
            changed_rows.append(
                f"| {key[0]} | {key[1]} | {', '.join(sorted(fixed)) or '-'} | {', '.join(sorted(introduced)) or '-'} |"
            )
        for flag in fixed:
            change_counts["fixed BM error"] += 1
        for flag in introduced:
            change_counts["introduced new error"] += 1
        if not fixed and not introduced:
            change_counts["unchanged flag state"] += 1

    bm_agree, bm_total = agreement(bm_rows)
    bme_agree, bme_total = agreement(bme_rows)

    bm_cost = avg(bm_rows, "estimated_initial_grade_cost_usd")
    bme_cost = avg(bme_rows, "estimated_initial_grade_cost_usd")
    bm_latency = p50(bm_rows, "total_latency_ms") / 1000
    bme_latency = p50(bme_rows, "total_latency_ms") / 1000
    bm_reasoning = avg(bm_rows, "reasoning_tokens")
    bme_reasoning = avg(bme_rows, "reasoning_tokens")

    lines = [
        "# Bio Reference Layer Exemplar Follow-up Report",
        "",
        "**Status:** Generated aggregate report",
        "**Run date:** 2026-06-17",
        f"**BM raw JSONL:** `{BM_PATH}`",
        f"**BM-E raw JSONL:** `{BME_PATH}`",
        "",
        "## Summary",
        "",
        "| Arm | Calls | Agreement | Avg cost | p50 latency sec | Avg input tokens | Avg output tokens | Avg reasoning tokens | Schema valid rate |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
        (
            f"| BM medium/compact/no exemplars | {len(bm_rows)} | {bm_agree}/{bm_total} = {bm_agree / bm_total:.1%} | "
            f"{fmt_money(bm_cost)} | {bm_latency:.2f} | {avg(bm_rows, 'input_tokens'):.1f} | "
            f"{avg(bm_rows, 'output_tokens'):.1f} | {bm_reasoning:.1f} | "
            f"{sum(1 for row in bm_rows if row['schema_valid']) / len(bm_rows):.1%} |"
        ),
        (
            f"| BM-E medium/compact/exemplars | {len(bme_rows)} | {bme_agree}/{bme_total} = {bme_agree / bme_total:.1%} | "
            f"{fmt_money(bme_cost)} | {bme_latency:.2f} | {avg(bme_rows, 'input_tokens'):.1f} | "
            f"{avg(bme_rows, 'output_tokens'):.1f} | {bme_reasoning:.1f} | "
            f"{sum(1 for row in bme_rows if row['schema_valid']) / len(bme_rows):.1%} |"
        ),
        "",
        "## Deltas",
        "",
        f"- Agreement delta: {bme_agree - bm_agree:+d} criterion calls.",
        f"- Average cost delta: {((bme_cost - bm_cost) / bm_cost) * 100:+.1f}%.",
        f"- p50 latency delta: {((bme_latency - bm_latency) / bm_latency) * 100:+.1f}%.",
        f"- Average reasoning-token delta: {bme_reasoning - bm_reasoning:+.1f}.",
        f"- Average input-token delta: {avg(bme_rows, 'input_tokens') - avg(bm_rows, 'input_tokens'):+.1f}.",
        "",
        "## Quality Flags",
        "",
        "### BM",
        "",
    ]
    for flag, count in sorted(flag_counts(bm_rows).items()):
        lines.append(f"- {flag}: {count}")
    lines.extend(["", "### BM-E", ""])
    bme_flags = flag_counts(bme_rows)
    if bme_flags:
        for flag, count in sorted(bme_flags.items()):
            lines.append(f"- {flag}: {count}")
    else:
        lines.append("- No quality flags recorded.")

    lines.extend(
        [
            "",
            "## Paired Changes Versus BM",
            "",
            f"- Fixed BM errors: {change_counts['fixed BM error']}",
            f"- Introduced new errors: {change_counts['introduced new error']}",
            f"- Unchanged response-level flag states: {change_counts['unchanged flag state']}",
            "",
            "| Question | Response | Fixed BM flags | Introduced BM-E flags |",
            "| --- | --- | --- | --- |",
        ]
    )
    lines.extend(changed_rows or ["| - | - | - | - |"])

    lines.extend(
        [
            "",
            "## Threshold Assessment",
            "",
            f"- Agreement at least 56/60: {'yes' if bme_agree >= 56 else 'no'}.",
            (
                "- FRQ02-C2 under-credit at most 1: "
                f"{'yes' if bme_flags.get('under_credit:FRQ02-C2', 0) <= 1 else 'no'} "
                f"({bme_flags.get('under_credit:FRQ02-C2', 0)})."
            ),
            (
                "- FRQ01-C2 under-credit equal to 0: "
                f"{'yes' if bme_flags.get('under_credit:FRQ01-C2', 0) == 0 else 'no'} "
                f"({bme_flags.get('under_credit:FRQ01-C2', 0)})."
            ),
            (
                "- FRQ03-C3 under-credit at most 1: "
                f"{'yes' if bme_flags.get('under_credit:FRQ03-C3', 0) <= 1 else 'no'} "
                f"({bme_flags.get('under_credit:FRQ03-C3', 0)})."
            ),
            f"- Schema validity 100%: {'yes' if all(row['schema_valid'] for row in bme_rows) else 'no'}.",
            f"- Input-token cost increase under 2x BM: {'yes' if avg(bme_rows, 'input_tokens') < 2 * avg(bm_rows, 'input_tokens') else 'no'}.",
            f"- p50 latency increase under 30%: {'yes' if bme_latency < 1.3 * bm_latency else 'no'}.",
        ]
    )

    OUT_PATH.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")
    print(f"Wrote exemplar report: {OUT_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
