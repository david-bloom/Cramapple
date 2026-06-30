#!/usr/bin/env python3
"""Review AP Biology short-FRQ canonical answer pairs against their criteria.

This script tests whether each short-FRQ canonical-answer pair is tightly
matched to its two rubric criteria. It is meant to surface pair-level quality
issues such as swapped answers, duplicated answers, or answers that are too
generic to improve grader quality.

Input:
  A JSON array or JSONL file containing rows with at least:
    - content_key
    - stem
    - canonical_answer_1
    - canonical_answer_2
    - criteria (array of two objects with criterion_key and learner_facing_text)

Output:
  - JSONL raw results for each FRQ item.
  - A Markdown report summarizing pair quality across the set.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import statistics
import sys
import time
import urllib.error
import urllib.request
from collections import Counter
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_INPUT = Path("/private/tmp/apbio_short_frq_canonical_pairs.json")
DEFAULT_OUTPUT_JSONL = Path("/private/tmp/apbio_short_frq_canonical_pair_review.jsonl")
DEFAULT_REPORT = ROOT / "docs/research/apbio_short_frq_canonical_pair_review_report.md"

MODEL_ID = "gpt-5.5"
REASONING_EFFORT = "medium"
OUTPUT_SCHEMA_VERSION = "apbio-short-frq-canonical-pair-review-v1"
PRICING = {"input_per_1m": 5.00, "cached_input_per_1m": 0.50, "output_per_1m": 30.00}


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


def load_records(path: Path) -> list[dict[str, Any]]:
    text = path.read_text(encoding="utf-8").strip()
    if not text:
        return []
    if text.startswith("["):
        data = json.loads(text)
        if not isinstance(data, list):
            fail(f"expected JSON array in {path}")
        return [row for row in data if isinstance(row, dict)]
    rows: list[dict[str, Any]] = []
    for line in text.splitlines():
        if not line.strip():
            continue
        row = json.loads(line)
        if isinstance(row, dict):
            rows.append(row)
    return rows


def criterion_fields(record: dict[str, Any]) -> list[dict[str, Any]]:
    criteria = record.get("criteria")
    if not isinstance(criteria, list):
        return []
    normalized: list[dict[str, Any]] = []
    for item in criteria:
        if not isinstance(item, dict):
            continue
        normalized.append(
            {
                "criterion_key": str(item.get("criterion_key") or ""),
                "learner_facing_text": str(item.get("learner_facing_text") or ""),
                "minimum_fix": str(item.get("minimum_fix") or ""),
                "points_possible": item.get("points_possible"),
                "evidence_requirements": str(item.get("evidence_requirements") or ""),
            }
        )
    return normalized


STOP_WORDS = {
    "the",
    "and",
    "that",
    "this",
    "with",
    "from",
    "into",
    "when",
    "where",
    "what",
    "which",
    "they",
    "their",
    "there",
    "these",
    "those",
    "have",
    "has",
    "had",
    "are",
    "was",
    "were",
    "been",
    "will",
    "would",
    "could",
    "should",
    "because",
    "while",
    "into",
    "through",
    "than",
    "then",
    "over",
    "only",
    "one",
    "two",
    "both",
    "each",
    "per",
    "for",
    "a",
    "an",
    "of",
    "to",
    "in",
    "on",
    "at",
    "as",
    "by",
    "is",
    "it",
    "or",
    "be",
    "can",
    "may",
    "not",
    "do",
    "does",
    "did",
    "any",
    "all",
    "most",
    "some",
}


def tokenize(text: str) -> set[str]:
    import re

    return {
        token
        for token in re.findall(r"[a-zA-Z][a-zA-Z0-9+/-]{2,}", text.lower())
        if token not in STOP_WORDS
    }


def overlap_score(text_a: str, text_b: str) -> int:
    return len(tokenize(text_a) & tokenize(text_b))


def short_quote(text: str, max_words: int = 14) -> str:
    words = " ".join(text.split()).split()
    return " ".join(words[:max_words])


def heuristic_review(record: dict[str, Any]) -> dict[str, Any]:
    criteria = criterion_fields(record)
    criterion_a = criteria[0]
    criterion_b = criteria[1]
    answer_1 = str(record.get("canonical_answer_1") or "")
    answer_2 = str(record.get("canonical_answer_2") or "")

    criterion_a_text = " ".join(
        [
            criterion_a["learner_facing_text"],
            criterion_a["minimum_fix"],
            criterion_a["evidence_requirements"],
        ]
    )
    criterion_b_text = " ".join(
        [
            criterion_b["learner_facing_text"],
            criterion_b["minimum_fix"],
            criterion_b["evidence_requirements"],
        ]
    )

    a1_score_a = overlap_score(answer_1, criterion_a_text)
    a1_score_b = overlap_score(answer_1, criterion_b_text)
    a2_score_a = overlap_score(answer_2, criterion_a_text)
    a2_score_b = overlap_score(answer_2, criterion_b_text)

    best_a1 = "criterion_a"
    best_a1_score = a1_score_a
    if a1_score_b > a1_score_a:
        best_a1 = "criterion_b"
        best_a1_score = a1_score_b
    elif a1_score_b == a1_score_a and a1_score_a > 0:
        best_a1 = "both"

    best_a2 = "criterion_a"
    best_a2_score = a2_score_a
    if a2_score_b > a2_score_a:
        best_a2 = "criterion_b"
        best_a2_score = a2_score_b
    elif a2_score_b == a2_score_a and a2_score_a > 0:
        best_a2 = "both"

    if best_a1 == "criterion_a" and best_a2 == "criterion_b":
        pair_status = "matched"
    elif best_a1 == "criterion_b" and best_a2 == "criterion_a":
        pair_status = "swapped"
    elif best_a1 == best_a2 and best_a1 in {"criterion_a", "criterion_b", "both"}:
        pair_status = "duplicated"
    elif max(a1_score_a, a1_score_b, a2_score_a, a2_score_b) >= 5 and (
        best_a1 in {"criterion_a", "criterion_b", "both"}
        or best_a2 in {"criterion_a", "criterion_b", "both"}
    ):
        pair_status = "partially_matched"
    else:
        pair_status = "mismatched"

    if pair_status == "matched" and min(best_a1_score, best_a2_score) >= 5:
        pair_usefulness = "high"
    elif pair_status in {"matched", "swapped", "partially_matched"}:
        pair_usefulness = "moderate"
    else:
        pair_usefulness = "low"

    quality_flags: list[str] = []
    if pair_status == "swapped":
        quality_flags.append("criterion_swapped")
    if pair_status == "duplicated":
        quality_flags.append("duplicated_criteria")
    if pair_status in {"partially_matched", "mismatched"}:
        quality_flags.append("criterion_drift")

    if "random" in answer_1.lower() and "random" not in criterion_a_text.lower():
        quality_flags.append("generic_random_language")
    if "random" in answer_2.lower() and "random" not in criterion_b_text.lower():
        quality_flags.append("generic_random_language")
    if "because" not in answer_1.lower() and len(answer_1.split()) < 12:
        quality_flags.append("thin_explanation")
    if "because" not in answer_2.lower() and len(answer_2.split()) < 12:
        quality_flags.append("thin_explanation")

    criterion_a_alignment = "strong" if a1_score_a >= a1_score_b else "partial"
    if pair_status == "swapped":
        criterion_a_alignment = "strong" if a2_score_a > 0 else "mismatch"
    criterion_b_alignment = "strong" if a2_score_b >= a2_score_a else "partial"
    if pair_status == "swapped":
        criterion_b_alignment = "strong" if a1_score_b > 0 else "mismatch"

    if pair_status in {"mismatched", "duplicated"} and max(
        a1_score_a, a1_score_b, a2_score_a, a2_score_b
    ) < 4:
        criterion_a_alignment = "mismatch"
        criterion_b_alignment = "mismatch"

    pair_minimum_fix = (
        "Swap the answers, if needed, so each criterion has a distinct, criterion-specific canonical answer."
        if pair_status == "swapped"
        else "Tighten the canonical pair so one answer cleanly matches each criterion without overlap."
    )
    criterion_a_minimum_fix = criterion_a["minimum_fix"]
    criterion_b_minimum_fix = criterion_b["minimum_fix"]

    return {
        "pair_status": pair_status,
        "answer_1_best_fit": best_a1,
        "answer_2_best_fit": best_a2,
        "criterion_a_alignment": criterion_a_alignment,
        "criterion_b_alignment": criterion_b_alignment,
        "pair_usefulness": pair_usefulness,
        "quality_flags": sorted(set(quality_flags)),
        "answer_1_quote": short_quote(answer_1),
        "answer_2_quote": short_quote(answer_2),
        "pair_minimum_fix": pair_minimum_fix,
        "criterion_a_minimum_fix": criterion_a_minimum_fix,
        "criterion_b_minimum_fix": criterion_b_minimum_fix,
        "rationale": (
            "Heuristic review based on token overlap with the two criterion texts, minimum fixes, and evidence requirements."
        ),
        "confidence": "medium",
    }


def build_input(record: dict[str, Any]) -> str:
    criteria = criterion_fields(record)
    if len(criteria) < 2:
        fail(f"{record.get('content_key')} does not include two criteria")
    criterion_a = criteria[0]
    criterion_b = criteria[1]
    return "\n".join(
        [
            f"Question ID: {record.get('content_key')}",
            "",
            f"Stem: {record.get('stem', '')}",
            "",
            "Criterion A:",
            f"- key: {criterion_a['criterion_key']}",
            f"- text: {criterion_a['learner_facing_text']}",
            f"- minimum_fix: {criterion_a['minimum_fix']}",
            "",
            "Criterion B:",
            f"- key: {criterion_b['criterion_key']}",
            f"- text: {criterion_b['learner_facing_text']}",
            f"- minimum_fix: {criterion_b['minimum_fix']}",
            "",
            "Canonical answer 1:",
            str(record.get("canonical_answer_1") or ""),
            "",
            "Canonical answer 2:",
            str(record.get("canonical_answer_2") or ""),
        ]
    ).strip()


def build_instructions() -> str:
    return """
You are Cramapple's AP Biology FRQ canonical-pair reviewer.
Review the two canonical answers for the two criteria of a short FRQ.

Your job is not to grade a student response. Your job is to judge whether the
pair is tightly matched to the rubric and whether the pair would help a grader
without causing criterion drift.

Important rules:
1. The answer order may be swapped; do not assume canonical_answer_1 belongs to
   Criterion A.
2. A strong pair is criterion-specific, non-duplicative, and does not answer
   the other criterion by accident.
3. Flag swapped, duplicated, overbroad, generic, or mechanism-missing pairs.
4. If one answer is clearly better for the other criterion, say so.
5. Keep minimum fixes short and targeted.

Return only valid JSON matching the schema.
""".strip()


def response_schema() -> dict[str, Any]:
    return {
        "type": "object",
        "additionalProperties": False,
        "properties": {
            "pair_status": {
                "type": "string",
                "enum": [
                    "matched",
                    "swapped",
                    "duplicated",
                    "partially_matched",
                    "mismatched",
                ],
            },
            "answer_1_best_fit": {
                "type": "string",
                "enum": ["criterion_a", "criterion_b", "both", "neither"],
            },
            "answer_2_best_fit": {
                "type": "string",
                "enum": ["criterion_a", "criterion_b", "both", "neither"],
            },
            "criterion_a_alignment": {
                "type": "string",
                "enum": ["strong", "partial", "mismatch"],
            },
            "criterion_b_alignment": {
                "type": "string",
                "enum": ["strong", "partial", "mismatch"],
            },
            "pair_usefulness": {
                "type": "string",
                "enum": ["high", "moderate", "low"],
            },
            "quality_flags": {
                "type": "array",
                "items": {"type": "string"},
            },
            "answer_1_quote": {"type": "string"},
            "answer_2_quote": {"type": "string"},
            "pair_minimum_fix": {"type": "string"},
            "criterion_a_minimum_fix": {"type": "string"},
            "criterion_b_minimum_fix": {"type": "string"},
            "rationale": {"type": "string"},
            "confidence": {
                "type": "string",
                "enum": ["high", "medium", "low"],
            },
        },
        "required": [
            "pair_status",
            "answer_1_best_fit",
            "answer_2_best_fit",
            "criterion_a_alignment",
            "criterion_b_alignment",
            "pair_usefulness",
            "quality_flags",
            "answer_1_quote",
            "answer_2_quote",
            "pair_minimum_fix",
            "criterion_a_minimum_fix",
            "criterion_b_minimum_fix",
            "rationale",
            "confidence",
        ],
    }


def call_openai(api_key: str, system_prompt: str, user_prompt: str, user_id: str) -> tuple[dict[str, Any], float]:
    body = {
        "model": MODEL_ID,
        "input": [
            {
                "role": "system",
                "content": [{"type": "input_text", "text": system_prompt}],
            },
            {
                "role": "user",
                "content": [{"type": "input_text", "text": user_prompt}],
            },
        ],
        "store": False,
        "reasoning": {"effort": REASONING_EFFORT},
        "max_output_tokens": 1200,
        "text": {
            "format": {
                "type": "json_schema",
                "name": "apbio_short_frq_canonical_pair_review",
                "strict": True,
                "schema": response_schema(),
            }
        },
        "user": user_id[:64],
    }
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


def prompt_hash(system_prompt: str, user_prompt: str) -> str:
    return hashlib.sha256((system_prompt + "\n\n" + user_prompt).encode("utf-8")).hexdigest()


def load_existing(path: Path) -> set[str]:
    if not path.exists():
        return set()
    keys: set[str] = set()
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        row = json.loads(line)
        if isinstance(row, dict) and isinstance(row.get("content_key"), str):
            keys.add(row["content_key"])
    return keys


def summarize(rows: list[dict[str, Any]]) -> dict[str, Any]:
    pair_counts = Counter(row.get("pair_status", "missing") for row in rows)
    usefulness_counts = Counter(row.get("pair_usefulness", "missing") for row in rows)
    flags = Counter(flag for row in rows for flag in row.get("quality_flags", []))
    latencies = [float(row.get("total_latency_ms") or 0.0) for row in rows]
    costs = [float(row.get("estimated_cost_usd") or 0.0) for row in rows]
    input_tokens = [int(row.get("input_tokens") or 0) for row in rows]
    output_tokens = [int(row.get("output_tokens") or 0) for row in rows]
    reasoning_tokens = [int(row.get("reasoning_tokens") or 0) for row in rows]
    return {
        "count": len(rows),
        "pair_counts": dict(sorted(pair_counts.items())),
        "usefulness_counts": dict(sorted(usefulness_counts.items())),
        "flags": dict(sorted(flags.items())),
        "avg_cost": statistics.mean(costs) if costs else 0.0,
        "p50_latency_ms": statistics.median(latencies) if latencies else 0.0,
        "p95_latency_ms": percentile(latencies, 0.95),
        "avg_input_tokens": statistics.mean(input_tokens) if input_tokens else 0.0,
        "avg_output_tokens": statistics.mean(output_tokens) if output_tokens else 0.0,
        "avg_reasoning_tokens": statistics.mean(reasoning_tokens) if reasoning_tokens else 0.0,
    }


def percentile(values: list[float], p: float) -> float:
    if not values:
        return 0.0
    ordered = sorted(values)
    if len(ordered) == 1:
        return ordered[0]
    rank = (len(ordered) - 1) * p
    lower = int(rank)
    upper = min(lower + 1, len(ordered) - 1)
    weight = rank - lower
    return ordered[lower] * (1 - weight) + ordered[upper] * weight


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output-jsonl", type=Path, default=DEFAULT_OUTPUT_JSONL)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--limit", type=int, default=20)
    parser.add_argument("--mode", choices=["heuristic", "model"], default="heuristic")
    args = parser.parse_args()

    load_dotenv(ROOT / ".env")
    api_key = os.environ.get("OPENAI_API_KEY") if args.mode == "model" else None
    if args.mode == "model" and not api_key:
        fail("OPENAI_API_KEY is required for --mode model")

    records = load_records(args.input)
    if not records:
        fail(f"no records found in {args.input}")

    system_prompt = build_instructions() if args.mode == "model" else ""
    existing = load_existing(args.output_jsonl)
    results: list[dict[str, Any]] = []

    for record in sorted(records, key=lambda row: str(row.get("content_key") or ""))[: args.limit]:
        content_key = str(record.get("content_key") or "")
        if not content_key:
            continue
        if content_key in existing:
            continue

        if args.mode == "model":
            user_prompt = build_input(record)
            raw_response, latency_ms = call_openai(api_key, system_prompt, user_prompt, content_key)  # type: ignore[arg-type]
            output_text = extract_output_text(raw_response)
            if not output_text:
                fail(f"{content_key}: model returned no output text")
            parsed = json.loads(output_text)
            usage = usage_counts(raw_response)
        else:
            start = time.perf_counter()
            parsed = heuristic_review(record)
            usage = {
                "input_tokens": 0,
                "output_tokens": 0,
                "reasoning_tokens": 0,
                "cached_tokens": 0,
            }
            latency_ms = (time.perf_counter() - start) * 1000

        criteria = criterion_fields(record)
        result = {
            "content_key": content_key,
            "title": record.get("title"),
            "version_num": record.get("version_num"),
            "question_id": content_key,
            "canonical_answer_1": record.get("canonical_answer_1"),
            "canonical_answer_2": record.get("canonical_answer_2"),
            "criterion_a_key": criteria[0]["criterion_key"] if len(criteria) > 0 else "",
            "criterion_b_key": criteria[1]["criterion_key"] if len(criteria) > 1 else "",
            "criterion_a_text": criteria[0]["learner_facing_text"] if len(criteria) > 0 else "",
            "criterion_b_text": criteria[1]["learner_facing_text"] if len(criteria) > 1 else "",
            "experiment_arm": "canonical_pair_review",
            "model_id": MODEL_ID,
            "reasoning_effort": REASONING_EFFORT,
            "output_schema_version": OUTPUT_SCHEMA_VERSION,
            "prompt_hash": prompt_hash(system_prompt, build_input(record)) if args.mode == "model" else hashlib.sha256((content_key + "\nheuristic").encode("utf-8")).hexdigest(),
            "schema_valid": True,
            "timeout_or_retry": False,
            "input_tokens": usage["input_tokens"],
            "output_tokens": usage["output_tokens"],
            "reasoning_tokens": usage["reasoning_tokens"],
            "cached_tokens": usage["cached_tokens"],
            "estimated_cost_usd": estimate_cost(usage),
            "total_latency_ms": latency_ms,
            "pair_status": parsed["pair_status"],
            "answer_1_best_fit": parsed["answer_1_best_fit"],
            "answer_2_best_fit": parsed["answer_2_best_fit"],
            "criterion_a_alignment": parsed["criterion_a_alignment"],
            "criterion_b_alignment": parsed["criterion_b_alignment"],
            "pair_usefulness": parsed["pair_usefulness"],
            "quality_flags": parsed["quality_flags"],
            "answer_1_quote": parsed["answer_1_quote"],
            "answer_2_quote": parsed["answer_2_quote"],
            "pair_minimum_fix": parsed["pair_minimum_fix"],
            "criterion_a_minimum_fix": parsed["criterion_a_minimum_fix"],
            "criterion_b_minimum_fix": parsed["criterion_b_minimum_fix"],
            "rationale": parsed["rationale"],
            "confidence": parsed["confidence"],
        }
        results.append(result)
        with args.output_jsonl.open("a", encoding="utf-8") as handle:
            handle.write(json.dumps(result, ensure_ascii=False) + "\n")

    if not results:
        fail("no new results were written")

    summary = summarize(results)
    lines = [
        "# AP Biology Short-FRQ Canonical Pair Review",
        "",
        "**Status:** Generated canonical-pair quality review",
        f"**Raw Results:** `{args.output_jsonl}`",
        f"**Input:** `{args.input}`",
        f"**Model:** `{MODEL_ID}` with `{REASONING_EFFORT}` reasoning",
        "",
        "## Executive Summary",
        "",
        f"Reviewed {summary['count']} canonical pairs.",
        "",
        "## Aggregate Results",
        "",
        "| Metric | Value |",
        "| --- | ---: |",
        f"| Pair status counts | `{json.dumps(summary['pair_counts'], sort_keys=True)}` |",
        f"| Pair usefulness counts | `{json.dumps(summary['usefulness_counts'], sort_keys=True)}` |",
        f"| Quality flag counts | `{json.dumps(summary['flags'], sort_keys=True)}` |",
        f"| Avg input tokens | {summary['avg_input_tokens']:.1f} |",
        f"| Avg output tokens | {summary['avg_output_tokens']:.1f} |",
        f"| Avg reasoning tokens | {summary['avg_reasoning_tokens']:.1f} |",
        f"| Avg cost | ${summary['avg_cost']:.5f} |",
        f"| p50 latency | {summary['p50_latency_ms']:.1f} ms |",
        f"| p95 latency | {summary['p95_latency_ms']:.1f} ms |",
        "",
        "## Items Needing Attention",
        "",
    ]

    flagged = [row for row in results if row.get("pair_status") != "matched" or row.get("quality_flags")]
    if flagged:
        for row in sorted(flagged, key=lambda item: item["content_key"]):
            lines.extend(
                [
                    f"### {row['content_key']}",
                    "",
                    f"- pair_status: `{row['pair_status']}`",
                    f"- pair_usefulness: `{row['pair_usefulness']}`",
                    f"- quality_flags: `{', '.join(row['quality_flags']) if row['quality_flags'] else 'none'}`",
                    f"- answer_1_best_fit: `{row['answer_1_best_fit']}`",
                    f"- answer_2_best_fit: `{row['answer_2_best_fit']}`",
                    f"- rationale: {row['rationale']}",
                    f"- pair_minimum_fix: {row['pair_minimum_fix']}",
                    "",
                ]
            )
    else:
        lines.append("All reviewed canonical pairs were matched cleanly and rated highly useful.")

    args.report.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {args.output_jsonl}")
    print(f"Wrote {args.report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
