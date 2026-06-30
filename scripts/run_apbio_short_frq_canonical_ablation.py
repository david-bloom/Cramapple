#!/usr/bin/env python3
"""Run a 0 vs 1 vs 2 canonical-answer ablation on AP Biology short FRQs."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import statistics
import sys
import time
import urllib.error
import urllib.request
from collections import defaultdict
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_PACKET = ROOT / "docs/research/bio_reference_layer_spike_input_packet.md"
DEFAULT_CANONICALS = Path("/private/tmp/apbio_short_frq_canonical_pairs.json")
DEFAULT_OUTPUT = Path("/private/tmp/cramapple-bio-ref-spike/apbio_short_frq_canonical_ablation_results.jsonl")
DEFAULT_REPORT = ROOT / "docs/research/apbio_short_frq_canonical_ablation_report.md"

MODEL_ID = "gpt-5.5"
OUTPUT_SCHEMA_VERSION = "apbio-short-frq-canonical-ablation-v1"
PRICING = {"input_per_1m": 5.00, "cached_input_per_1m": 0.50, "output_per_1m": 30.00}

ARMS = [
    "apbio_short_frq_0_canon",
    "apbio_short_frq_1_canon",
    "apbio_short_frq_2_canon",
]


def fail(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def load_dotenv(path: Path) -> None:
    if not path.exists():
        return
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        if key not in os.environ:
            os.environ[key] = value.strip().strip('"').strip("'")


def parse_table_rows(block: str) -> list[list[str]]:
    rows: list[list[str]] = []
    for line in block.splitlines():
        stripped = line.strip()
        if not stripped.startswith("|") or "---" in stripped:
            continue
        cells = [cell.strip().strip("`") for cell in stripped.strip("|").split("|")]
        if cells:
            rows.append(cells)
    return rows


def section_between(text: str, start: str, end_pattern: str) -> str:
    start_index = text.find(start)
    if start_index == -1:
        return ""
    start_index += len(start)
    match = re.search(end_pattern, text[start_index:], flags=re.MULTILINE)
    end_index = start_index + match.start() if match else len(text)
    return text[start_index:end_index].strip()


def parse_packet(path: Path) -> list[dict[str, Any]]:
    text = path.read_text(encoding="utf-8")
    matches = list(re.finditer(r"^## \d+\.\s+(SPIKE-FRQ-\d+)\s+-\s+(.+)$", text, re.MULTILINE))
    if not matches:
        fail(f"no AP Bio short-FRQ sections found in {path}")
    frqs: list[dict[str, Any]] = []
    for idx, match in enumerate(matches):
        question_id = match.group(1)
        title = match.group(2).strip()
        end = matches[idx + 1].start() if idx + 1 < len(matches) else len(text)
        block = text[match.start():end]
        prompt = section_between(block, "### Prompt", r"^### Draft Rubric Criteria")
        rubric_block = section_between(block, "### Draft Rubric Criteria", r"^### Response Set")
        criteria: list[dict[str, str]] = []
        for row in parse_table_rows(rubric_block):
            if row and row[0].startswith("FRQ"):
                criteria.append({"criterion_id": row[0], "text": row[1]})
        labels_block = section_between(block, "### Confirmed Label Matrix", r"^##|\Z")
        labels: dict[str, dict[str, str]] = {}
        reviewer_notes: dict[str, str] = {}
        for row in parse_table_rows(labels_block):
            if row and row[0].startswith("FRQ"):
                labels[row[0]] = {
                    criterion["criterion_id"]: row[i + 1]
                    for i, criterion in enumerate(criteria)
                    if i + 1 < len(row)
                }
                note_index = len(criteria) + 1
                reviewer_notes[row[0]] = row[note_index] if note_index < len(row) else ""
        responses: list[dict[str, Any]] = []
        for response_match in re.finditer(
            r"^#### (FRQ\d+-R\d+)\n\n```text\n(.*?)\n```",
            block,
            flags=re.MULTILINE | re.DOTALL,
        ):
            response_id = response_match.group(1)
            responses.append(
                {
                    "response_id": response_id,
                    "text": response_match.group(2).strip(),
                    "labels": labels.get(response_id, {}),
                    "reviewer_note": reviewer_notes.get(response_id, ""),
                }
            )
        frqs.append(
            {
                "question_id": question_id,
                "title": title,
                "prompt": prompt,
                "criteria": criteria,
                "responses": responses,
            }
        )
    return frqs


def load_canonicals(path: Path) -> dict[str, dict[str, str]]:
    rows = json.loads(path.read_text(encoding="utf-8"))
    canonicals: dict[str, dict[str, str]] = {}
    for row in rows:
        canonicals[str(row["content_key"])] = {
            "canonical_answer_1": str(row.get("canonical_answer_1") or ""),
            "canonical_answer_2": str(row.get("canonical_answer_2") or ""),
        }
    return canonicals


def canonical_answer_count(arm: str) -> int:
    if arm == "apbio_short_frq_1_canon":
        return 1
    if arm == "apbio_short_frq_2_canon":
        return 2
    return 0


def arm_label(arm: str) -> str:
    if arm == "apbio_short_frq_0_canon":
        return "0 canonical answers"
    if arm == "apbio_short_frq_1_canon":
        return "1 canonical answer"
    if arm == "apbio_short_frq_2_canon":
        return "2 canonical answers"
    return arm


def prompt_version(arm: str) -> str:
    return f"{OUTPUT_SCHEMA_VERSION}:{arm}"


def build_instructions(arm: str) -> str:
    canon_count = canonical_answer_count(arm)
    return f"""
You are Cramapple's AP Biology FRQ grader for an internal canonical-answer ablation.
Grade only against the rubric criteria shown below.
The canonical answers are boundary memory, not extra rubric criteria.
Do not broaden the rubric, invent biology, or copy the canonical answers blindly.
Use the canonical answers only to sharpen the scoring boundary for the held-out response.

Canonical-answer count for this arm: {canon_count}

Return only valid JSON with this shape:
{{
  "points_earned": number,
  "criterion_statuses": {{"CRITERION_ID": "earned|not_earned|unable_to_determine"}},
  "highest_value_gap": "short string",
  "minimum_fix_length": "short string",
  "confidence": "high|medium|low",
  "uncertainty_reason": "short string or empty",
  "student_feedback": "string",
  "reviewer_rationale": "string"
}}
""".strip()


def build_input(
    frq: dict[str, Any],
    response: dict[str, Any],
    canonicals: dict[str, dict[str, str]],
    arm: str,
) -> tuple[str, int]:
    rubric = "\n".join(
        f"- {criterion['criterion_id']}: {criterion['text']}" for criterion in frq["criteria"]
    )
    match = re.search(r"SPIKE-FRQ-(\d+)$", frq["question_id"])
    canonical_key = (
        f"APBIO-FRQ-S-{int(match.group(1)):03d}"
        if match
        else frq["question_id"].replace("SPIKE-", "APBIO-FRQ-S-")
    )
    canonical = canonicals.get(canonical_key, {})
    canon_count = canonical_answer_count(arm)
    canonical_block = "No canonical answers provided for this arm."
    if canon_count == 1:
        canonical_block = "\n".join(
            [
                "Canonical answers provided for this arm:",
                f"- canonical_answer_1: {canonical.get('canonical_answer_1', '')}",
            ]
        )
    elif canon_count == 2:
        canonical_block = "\n".join(
            [
                "Canonical answers provided for this arm:",
                f"- canonical_answer_1: {canonical.get('canonical_answer_1', '')}",
                f"- canonical_answer_2: {canonical.get('canonical_answer_2', '')}",
            ]
        )
    user_input = f"""
Question ID: {frq['question_id']}
Question title: {frq['title']}

Prompt:
{frq['prompt']}

Rubric criteria:
{rubric}

{canonical_block}

Student response ID: {response['response_id']}
Student response:
{response['text']}
""".strip()
    return user_input, len(canonical_block.split())


def prompt_hash(instructions: str, user_input: str) -> str:
    return hashlib.sha256((instructions + "\n\n" + user_input).encode("utf-8")).hexdigest()


def extract_output_text(api_response: dict[str, Any]) -> str:
    if isinstance(api_response.get("output_text"), str):
        return api_response["output_text"]
    chunks: list[str] = []
    for item in api_response.get("output", []) or []:
        for content in item.get("content", []) or []:
            if content.get("type") in {"output_text", "text"}:
                chunks.append(str(content.get("text", "")))
    return "\n".join(chunks).strip()


def usage_counts(api_response: dict[str, Any]) -> dict[str, int]:
    usage = api_response.get("usage") or {}
    input_details = usage.get("input_tokens_details") or {}
    output_details = usage.get("output_tokens_details") or {}
    return {
        "input_tokens": int(usage.get("input_tokens") or 0),
        "output_tokens": int(usage.get("output_tokens") or 0),
        "reasoning_tokens": int(output_details.get("reasoning_tokens") or 0),
        "cached_tokens": int(input_details.get("cached_tokens") or 0),
    }


def estimate_cost(usage: dict[str, int]) -> float:
    cached = usage["cached_tokens"]
    uncached = max(usage["input_tokens"] - cached, 0)
    return (
        uncached * PRICING["input_per_1m"]
        + cached * PRICING["cached_input_per_1m"]
        + usage["output_tokens"] * PRICING["output_per_1m"]
    ) / 1_000_000


def call_openai(api_key: str, body: dict[str, Any]) -> tuple[dict[str, Any], float]:
    request = urllib.request.Request(
        "https://api.openai.com/v1/responses",
        data=json.dumps(body).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    started = time.perf_counter()
    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            raw = response.read().decode("utf-8")
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"OpenAI HTTP {exc.code}: {detail}") from exc
    return json.loads(raw), (time.perf_counter() - started) * 1000


def quality_flags(model_statuses: dict[str, str], labels: dict[str, str]) -> list[str]:
    flags: list[str] = []
    for criterion_id, human_status in labels.items():
        model_status = model_statuses.get(criterion_id)
        if human_status == "earned" and model_status != "earned":
            flags.append(f"under_credit:{criterion_id}")
        if human_status != "earned" and model_status == "earned":
            flags.append(f"over_credit:{criterion_id}")
    return flags


def run_one(
    api_key: str,
    handle: Any,
    *,
    frq: dict[str, Any],
    response: dict[str, Any],
    canonicals: dict[str, dict[str, str]],
    arm: str,
    reasoning_effort: str,
) -> dict[str, Any]:
    instructions = build_instructions(arm)
    user_input, reference_tokens = build_input(frq, response, canonicals, arm)
    body = {
        "model": MODEL_ID,
        "reasoning": {"effort": reasoning_effort},
        "instructions": instructions,
        "input": user_input,
        "max_output_tokens": 1000,
        "store": False,
    }
    timeout_or_retry = False
    error_message = ""
    api_response: dict[str, Any] = {}
    started = time.perf_counter()
    provider_latency_ms = 0.0
    try:
        api_response, provider_latency_ms = call_openai(api_key, body)
    except Exception as exc:  # noqa: BLE001
        timeout_or_retry = True
        error_message = str(exc)
    total_latency_ms = (time.perf_counter() - started) * 1000

    parsed: dict[str, Any] = {}
    schema_valid = False
    if api_response:
        try:
            parsed = json.loads(extract_output_text(api_response))
            schema_valid = isinstance(parsed.get("criterion_statuses"), dict)
        except json.JSONDecodeError:
            parsed = {}
            schema_valid = False

    criterion_statuses = parsed.get("criterion_statuses") or {}
    if not isinstance(criterion_statuses, dict):
        criterion_statuses = {}

    usage = usage_counts(api_response)
    cost = estimate_cost(usage)
    labels = response.get("labels") or {}
    points_earned = parsed.get("points_earned")
    if not isinstance(points_earned, (int, float)):
        points_earned = sum(
            2 for criterion_id, status in criterion_statuses.items() if status == "earned"
        )

    record = {
        "experiment_arm": arm,
        "model_id": MODEL_ID,
        "reasoning_effort": reasoning_effort,
        "prompt_version": prompt_version(arm),
        "prompt_hash": prompt_hash(instructions, user_input),
        "output_schema_version": OUTPUT_SCHEMA_VERSION,
        "prompt_caching_status": "reported" if usage["cached_tokens"] else "not_reported",
        "cached_tokens": usage["cached_tokens"],
        "question_id": frq["question_id"],
        "response_id": response["response_id"],
        "input_tokens": usage["input_tokens"],
        "output_tokens": usage["output_tokens"],
        "reasoning_tokens": usage["reasoning_tokens"],
        "reference_tokens": reference_tokens,
        "app_latency_ms": total_latency_ms,
        "provider_latency_ms": provider_latency_ms,
        "total_latency_ms": total_latency_ms,
        "estimated_initial_grade_cost_usd": cost,
        "estimated_full_attempt_cost_usd": cost,
        "schema_valid": schema_valid,
        "timeout_or_retry": timeout_or_retry,
        "points_earned": points_earned,
        "criterion_statuses": criterion_statuses,
        "highest_value_gap": parsed.get("highest_value_gap", ""),
        "minimum_fix_length": parsed.get("minimum_fix_length", ""),
        "confidence": parsed.get("confidence", "low"),
        "uncertainty_reason": parsed.get("uncertainty_reason", error_message),
        "quality_flags": quality_flags(criterion_statuses, labels),
        "canonical_answer_count": canonical_answer_count(arm),
        "reviewer_note": response.get("reviewer_note", ""),
    }
    handle.write(json.dumps(record, ensure_ascii=True) + "\n")
    handle.flush()
    print(
        f"{arm} {frq['question_id']} {response['response_id']}: "
        f"schema={schema_valid} flags={len(record['quality_flags'])} "
        f"cost=${cost:.5f} latency={total_latency_ms:.0f}ms"
    )
    return record


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


def aggregate(records: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for record in records:
        grouped[str(record["experiment_arm"])].append(record)

    summary: dict[str, dict[str, Any]] = {}
    for arm, arm_records in sorted(grouped.items()):
        latencies = [float(record["total_latency_ms"] or 0) for record in arm_records]
        costs = [float(record["estimated_initial_grade_cost_usd"] or 0) for record in arm_records]
        input_tokens = [float(record["input_tokens"] or 0) for record in arm_records]
        output_tokens = [float(record["output_tokens"] or 0) for record in arm_records]
        reasoning_tokens = [float(record["reasoning_tokens"] or 0) for record in arm_records]
        reference_tokens = [float(record["reference_tokens"] or 0) for record in arm_records]
        cached_tokens = [float(record["cached_tokens"] or 0) for record in arm_records]
        schema_valid = sum(1 for record in arm_records if record["schema_valid"])
        strict_success = sum(
            1
            for record in arm_records
            if record["schema_valid"] and not record["timeout_or_retry"] and not record.get("quality_flags")
        )
        quality_flag_total = sum(len(record.get("quality_flags") or []) for record in arm_records)
        criterion_total = 0
        criterion_correct = 0
        over_credit = 0
        under_credit = 0
        quality_counts: dict[str, int] = defaultdict(int)
        for record in arm_records:
            labels = record.get("reviewer_labels") or {}
            model = record.get("criterion_statuses") or {}
            if not labels:
                continue
            for criterion_id, human_status in labels.items():
                criterion_total += 1
                model_status = model.get(criterion_id)
                if model_status == human_status:
                    criterion_correct += 1
                if human_status == "earned" and model_status != "earned":
                    under_credit += 1
                    quality_counts[f"under_credit:{criterion_id}"] += 1
                if human_status != "earned" and model_status == "earned":
                    over_credit += 1
                    quality_counts[f"over_credit:{criterion_id}"] += 1
        summary[arm] = {
            "count": len(arm_records),
            "p50_latency_ms": statistics.median(latencies) if latencies else None,
            "p95_latency_ms": percentile(latencies, 0.95),
            "avg_initial_cost_usd": statistics.mean(costs) if costs else None,
            "avg_input_tokens": statistics.mean(input_tokens) if input_tokens else None,
            "avg_output_tokens": statistics.mean(output_tokens) if output_tokens else None,
            "avg_reasoning_tokens": statistics.mean(reasoning_tokens) if reasoning_tokens else None,
            "avg_reference_tokens": statistics.mean(reference_tokens) if reference_tokens else None,
            "avg_cached_tokens": statistics.mean(cached_tokens) if cached_tokens else None,
            "schema_valid_rate": schema_valid / len(arm_records) if arm_records else None,
            "strict_success_rate": strict_success / len(arm_records) if arm_records else None,
            "quality_flags_per_call": quality_flag_total / len(arm_records) if arm_records else None,
            "criterion_accuracy": criterion_correct / criterion_total if criterion_total else None,
            "criterion_correct": criterion_correct,
            "criterion_total": criterion_total,
            "over_credit": over_credit,
            "under_credit": under_credit,
            "quality_counts": dict(sorted(quality_counts.items())),
        }
    return summary


def fmt(value: object) -> str:
    if value is None:
        return "n/a"
    if isinstance(value, float):
        return f"{value:.4f}"
    return str(value)


def write_report(path: Path, summary: dict[str, dict[str, Any]], records: list[dict[str, Any]]) -> None:
    baseline = summary.get("apbio_short_frq_0_canon", {})
    lines = [
        "# AP Biology Short-FRQ Canonical Answer Ablation",
        "",
        "**Status:** Generated aggregate report",
        "",
        f"**Raw JSONL:** `{DEFAULT_OUTPUT}`",
        f"**Model:** `{MODEL_ID}`",
        "**Reasoning effort:** medium",
        "",
        "## Summary",
        "",
        "This run compares 0, 1, and 2 canonical-answer variants on the AP Biology short-FRQ held-out set from the spike packet.",
        "Quality is the first decision axis; speed and cost are reported after that.",
        "",
        "| Arm | Calls | Criterion accuracy | Strict success rate | p50 latency ms | p95 latency ms | Avg cost | Avg input tokens | Avg output tokens | Avg reference tokens | Avg cached tokens |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for arm in ARMS:
        data = summary.get(arm, {})
        lines.append(
            f"| {arm_label(arm)} | {fmt(data.get('count'))} | {fmt(data.get('criterion_accuracy'))} | "
            f"{fmt(data.get('strict_success_rate'))} | {fmt(data.get('p50_latency_ms'))} | "
            f"{fmt(data.get('p95_latency_ms'))} | {fmt(data.get('avg_initial_cost_usd'))} | "
            f"{fmt(data.get('avg_input_tokens'))} | {fmt(data.get('avg_output_tokens'))} | "
            f"{fmt(data.get('avg_reference_tokens'))} | {fmt(data.get('avg_cached_tokens'))} |"
        )

    lines.extend(
        [
            "",
            "## Criterion-Level Comparison",
            "",
            "| Arm | Correct / Total | Over-credit | Under-credit | Quality flags / call |",
            "| --- | ---: | ---: | ---: | ---: |",
        ]
    )
    for arm in ARMS:
        data = summary.get(arm, {})
        lines.append(
            f"| {arm_label(arm)} | {fmt(data.get('criterion_correct'))} / {fmt(data.get('criterion_total'))} | "
            f"{fmt(data.get('over_credit'))} | {fmt(data.get('under_credit'))} | {fmt(data.get('quality_flags_per_call'))} |"
        )

    if baseline:
        lines.extend(
            [
                "",
                "## Interpretation",
                "",
                f"- Baseline (`{arm_label('apbio_short_frq_0_canon')}`) criterion accuracy: {fmt(baseline.get('criterion_accuracy'))}.",
            ]
        )
        for arm in ARMS[1:]:
            data = summary.get(arm, {})
            lines.append(
                f"- {arm_label(arm)} vs baseline: criterion accuracy {fmt(data.get('criterion_accuracy'))}, "
                f"strict success {fmt(data.get('strict_success_rate'))}, avg cost {fmt(data.get('avg_initial_cost_usd'))}."
            )
        lines.extend(
            [
                "",
                "## Notes",
                "",
                "- Canonical answers were treated as boundary memory, not extra rubric.",
                "- The next promotion decision should prefer the smallest canonical count that improves criterion accuracy without increasing over-credit.",
            ]
        )

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--packet", type=Path, default=DEFAULT_PACKET)
    parser.add_argument("--canonicals", type=Path, default=DEFAULT_CANONICALS)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--arms", default=",".join(ARMS))
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    arms = [arm.strip() for arm in args.arms.split(",") if arm.strip()]
    unknown = sorted(set(arms) - set(ARMS))
    if unknown:
        fail(f"unknown arm(s): {', '.join(unknown)}")

    load_dotenv(ROOT / ".env.local")
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key and not args.dry_run:
        fail("OPENAI_API_KEY is not set")

    frqs = parse_packet(args.packet)
    canonicals = load_canonicals(args.canonicals)
    if args.dry_run:
        planned = len(frqs) * 5 * len(arms)
        print(f"Dry run OK. Planned calls: {planned}")
        print(f"Arms: {', '.join(arms)}")
        return 0

    args.output.parent.mkdir(parents=True, exist_ok=True)
    records: list[dict[str, Any]] = []
    with args.output.open("w", encoding="utf-8") as handle:
        for frq in frqs:
            for response in frq["responses"]:
                for arm in arms:
                    record = run_one(
                        api_key or "",
                        handle,
                        frq=frq,
                        response=response,
                        canonicals=canonicals,
                        arm=arm,
                        reasoning_effort="medium",
                    )
                    record["reviewer_labels"] = response.get("labels") or {}
                    records.append(record)

    summary = aggregate(records)
    write_report(args.report, summary, records)
    print(f"Wrote JSONL results: {args.output}")
    print(f"Wrote report: {args.report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
