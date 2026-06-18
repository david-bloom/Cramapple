#!/usr/bin/env python3
"""Run the FRQ02 scored-answer flywheel volume test.

The runner grades approved synthetic answers in a fixed shuffled order. For
answer N, the flywheel arm may retrieve only approved precedents from answers
1..N-1 in that order. Ground-truth labels are used only for evaluation and for
precedents after the response has been processed.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import random
import re
import sys
import time
import urllib.error
import urllib.request
from collections import Counter
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
LABELS_PATH = ROOT / "docs/research/frq02_generated_answer_labels_codex_provisional.jsonl"
DEFAULT_OUTPUT = Path("/private/tmp/cramapple-bio-ref-spike/frq02_flywheel_results_2026-06-17.jsonl")

MODEL_ID = "gpt-5.5"
OUTPUT_SCHEMA_VERSION = "bio-ref-flywheel-v1"
PRICING = {"input_per_1m": 5.00, "cached_input_per_1m": 0.50, "output_per_1m": 30.00}

QUESTION_ID = "SPIKE-FRQ-02"
QUESTION_TITLE = "Bottleneck Drift and Genetic Diversity"
PROMPT = """A population of wild wildflowers exhibits a single gene locus with two alleles (`F` and `f`) controlling flower color. A construction project randomly destroys 90% of the wildflower population. The remaining individual plants are left to randomly interbreed.

A. Identify the specific evolutionary mechanism responsible for the sudden alteration of allele frequencies in this small population.

B. Explain how the genetic diversity of this isolated population will compare to the original ancestral population over subsequent generations, assuming no mutation or gene flow occurs."""

CRITERIA = [
    ("FRQ02-C1", "Identifies genetic drift as the mechanism. Bottleneck effect is acceptable and more specific."),
    ("FRQ02-C2", "Explains that the construction event is random/non-selective with respect to flower-color fitness."),
    ("FRQ02-C3", "Predicts reduced genetic diversity compared with the original population."),
    ("FRQ02-C4", "Explains that small isolated populations experience random allele-frequency change, allele loss/fixation, or reduced heterozygosity when no mutation or gene flow restores variation."),
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


def load_rows(path: Path) -> list[dict[str, Any]]:
    rows = [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]
    for row in rows:
        if row.get("label_status") != "learning_quality_approved" or row.get("use_as_ground_truth") is not True:
            fail(f"row {row.get('response_id')} is not approved ground truth")
    return rows


def ordered_rows(rows: list[dict[str, Any]], seed: int) -> list[dict[str, Any]]:
    shuffled = sorted(rows, key=lambda row: row["response_id"])
    rng = random.Random(seed)
    rng.shuffle(shuffled)
    return shuffled


def tokens(text: str) -> set[str]:
    stop = {
        "the", "and", "that", "this", "with", "will", "because", "from",
        "they", "their", "there", "some", "alleles", "allele", "population",
        "plants", "genetic", "diversity",
    }
    return {
        token
        for token in re.findall(r"[a-zA-Z]{3,}", text.lower())
        if token not in stop
    }


def overlap_score(current_text: str, precedent: dict[str, Any]) -> int:
    current = tokens(current_text)
    precedent_text = precedent["answer_text"] + " " + " ".join(precedent.get("boundary_tags", []))
    return len(current & tokens(precedent_text))


def compact_excerpt(text: str, max_chars: int = 260) -> str:
    one_line = " ".join(text.split())
    if len(one_line) <= max_chars:
        return one_line
    return one_line[: max_chars - 3].rstrip() + "..."


def retrieve_precedents(current: dict[str, Any], prior: list[dict[str, Any]], max_tokens: int = 500) -> tuple[str, list[str], int]:
    if not prior:
        return "No scored precedents are available yet.", [], 0

    selected: list[tuple[str, dict[str, Any]]] = []
    for criterion_id, _ in CRITERIA:
        for label in ("earned", "not_earned"):
            candidates = [
                row for row in prior if row["criterion_labels"].get(criterion_id) == label
            ]
            candidates.sort(
                key=lambda row: (overlap_score(current["answer_text"], row), row["response_id"]),
                reverse=True,
            )
            selected.extend((criterion_id, row) for row in candidates[:2])

    seen: set[str] = set()
    blocks: list[str] = []
    used_ids: list[str] = []
    word_count = 0
    for criterion_id, row in selected:
        precedent_id = f"{row['response_id']}:{criterion_id}"
        if precedent_id in seen:
            continue
        seen.add(precedent_id)
        block = "\n".join(
            [
                f"Precedent ID: {precedent_id}",
                f"Criterion: {criterion_id}",
                f"Label: {row['criterion_labels'][criterion_id]}",
                f"Response excerpt: {compact_excerpt(row['answer_text'])}",
                f"Reviewer note: {row['reviewer_note']}",
                f"Tags: {', '.join(row.get('boundary_tags', [])[:6])}",
            ]
        )
        block_words = len(block.split())
        if word_count + block_words > max_tokens and blocks:
            continue
        blocks.append(block)
        used_ids.append(precedent_id)
        word_count += block_words
        if word_count >= max_tokens:
            break

    return "\n\n".join(blocks) if blocks else "No scored precedents selected.", used_ids, word_count


def build_instructions(arm: str) -> str:
    memory_instruction = ""
    if arm == "bm_flywheel":
        memory_instruction = """
Use the scored precedents only to calibrate scoring boundaries for the listed
rubric criteria. Do not copy labels blindly. If the current response differs
materially, grade it on its own merits. Do not add criteria or broaden criteria.
"""
    return f"""
You are Cramapple's AP Biology FRQ grader for an internal flywheel test.
Grade only against the provided rubric criteria.
Mark each criterion exactly as "earned", "not_earned", or "unable_to_determine".
{memory_instruction}
Use compact output. Keep the highest_value_gap and repair move short, specific,
and non-answer-leaking.

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


def build_input(row: dict[str, Any], arm: str, precedents: str) -> str:
    rubric = "\n".join(f"- {cid}: {text}" for cid, text in CRITERIA)
    precedent_block = ""
    if arm == "bm_flywheel":
        precedent_block = f"\nScored criterion precedents available before this answer:\n{precedents}\n"
    return f"""
Question ID: {QUESTION_ID}
Question title: {QUESTION_TITLE}

Prompt:
{PROMPT}

Rubric criteria:
{rubric}
{precedent_block}
Student response ID: {row['response_id']}
Student response:
{row['answer_text']}
""".strip()


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


def quality_flags(model_statuses: dict[str, str], labels: dict[str, str]) -> list[str]:
    flags: list[str] = []
    for criterion_id, human_status in labels.items():
        model_status = model_statuses.get(criterion_id)
        if human_status == "earned" and model_status != "earned":
            flags.append(f"under_credit:{criterion_id}")
        if human_status != "earned" and model_status == "earned":
            flags.append(f"over_credit:{criterion_id}")
    return flags


def call_openai(api_key: str, body: dict[str, Any]) -> tuple[dict[str, Any], float]:
    request = urllib.request.Request(
        "https://api.openai.com/v1/responses",
        data=json.dumps(body).encode("utf-8"),
        headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
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


def existing_keys(path: Path) -> set[tuple[str, str]]:
    if not path.exists():
        return set()
    keys: set[tuple[str, str]] = set()
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        row = json.loads(line)
        keys.add((row["experiment_arm"], row["response_id"]))
    return keys


def run_one(api_key: str, handle: Any, row: dict[str, Any], arm: str, sequence_index: int, prior: list[dict[str, Any]], seed: int) -> None:
    precedents = "No scored precedents are available for the control arm."
    precedent_ids: list[str] = []
    precedent_tokens = 0
    if arm == "bm_flywheel":
        precedents, precedent_ids, precedent_tokens = retrieve_precedents(row, prior)

    instructions = build_instructions(arm)
    user_input = build_input(row, arm, precedents)
    body = {
        "model": MODEL_ID,
        "reasoning": {"effort": "medium"},
        "instructions": instructions,
        "input": user_input,
        "max_output_tokens": 1800,
        "store": False,
    }
    timeout_or_retry = False
    error_message = ""
    api_response: dict[str, Any] = {}
    provider_latency_ms = 0.0
    started = time.perf_counter()
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
    statuses = parsed.get("criterion_statuses") or {}
    if not isinstance(statuses, dict):
        statuses = {}
    usage = usage_counts(api_response)
    cost = estimate_cost(usage)
    record = {
        "experiment_arm": arm,
        "model_id": MODEL_ID,
        "reasoning_effort": "medium",
        "prompt_version": f"{OUTPUT_SCHEMA_VERSION}:{arm}",
        "prompt_hash": prompt_hash(instructions, user_input),
        "output_schema_version": OUTPUT_SCHEMA_VERSION,
        "prompt_caching_status": "available_if_cached_tokens_reported",
        "cached_tokens": usage["cached_tokens"],
        "question_id": QUESTION_ID,
        "response_id": row["response_id"],
        "sequence_index": sequence_index,
        "shuffle_seed": seed,
        "precedent_library_size": len(prior),
        "retrieved_precedent_ids": precedent_ids,
        "retrieved_precedent_count": len(precedent_ids),
        "retrieved_precedent_tokens": precedent_tokens,
        "input_tokens": usage["input_tokens"],
        "output_tokens": usage["output_tokens"],
        "reasoning_tokens": usage["reasoning_tokens"],
        "reference_tokens": precedent_tokens,
        "app_latency_ms": total_latency_ms,
        "provider_latency_ms": provider_latency_ms,
        "total_latency_ms": total_latency_ms,
        "estimated_initial_grade_cost_usd": cost,
        "estimated_full_attempt_cost_usd": cost,
        "schema_valid": schema_valid,
        "timeout_or_retry": timeout_or_retry,
        "points_earned": parsed.get("points_earned", 0),
        "criterion_statuses": statuses,
        "highest_value_gap": parsed.get("highest_value_gap", ""),
        "minimum_fix_length": parsed.get("minimum_fix_length", ""),
        "confidence": parsed.get("confidence", "low"),
        "uncertainty_reason": parsed.get("uncertainty_reason", error_message),
        "quality_flags": quality_flags(statuses, row["criterion_labels"]),
        "ground_truth_labels": row["criterion_labels"],
        "ground_truth_points": row["points_labeled"],
    }
    handle.write(json.dumps(record, ensure_ascii=True) + "\n")
    handle.flush()
    print(
        f"{arm} #{sequence_index:03d} {row['response_id']}: "
        f"schema={schema_valid} flags={len(record['quality_flags'])} "
        f"cost=${cost:.5f} latency={total_latency_ms:.0f}ms"
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--labels", type=Path, default=LABELS_PATH)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--seed", type=int, default=20260617)
    parser.add_argument("--limit", type=int, default=None)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    load_dotenv(ROOT / ".env.local")
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key and not args.dry_run:
        fail("OPENAI_API_KEY is not set")

    rows = ordered_rows(load_rows(args.labels), args.seed)
    if args.limit is not None:
        rows_to_run = rows[: args.limit]
    else:
        rows_to_run = rows

    planned = len(rows_to_run) * 2
    if args.dry_run:
        print(f"Dry run OK. Answers: {len(rows_to_run)}. Planned calls: {planned}. Seed: {args.seed}.")
        print("First response IDs:", ", ".join(row["response_id"] for row in rows_to_run[:10]))
        return 0

    args.output.parent.mkdir(parents=True, exist_ok=True)
    done = existing_keys(args.output)
    with args.output.open("a", encoding="utf-8") as handle:
        prior: list[dict[str, Any]] = []
        for sequence_index, row in enumerate(rows, start=1):
            if args.limit is not None and sequence_index > args.limit:
                break
            for arm in ("bm_control", "bm_flywheel"):
                if (arm, row["response_id"]) in done:
                    continue
                run_one(api_key or "", handle, row, arm, sequence_index, prior, args.seed)
            prior.append(row)

    print(f"Wrote flywheel JSONL: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
