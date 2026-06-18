#!/usr/bin/env python3
"""Run the FRQ02-C2 gated-prompt optimization test."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
LABELS_PATH = ROOT / "docs/research/frq02_generated_answer_labels_codex_provisional.jsonl"
DEFAULT_OUTPUT = Path("/private/tmp/cramapple-bio-ref-spike/frq02_gated_prompt_results_2026-06-17.jsonl")

MODEL_ID = "gpt-5.5"
OUTPUT_SCHEMA_VERSION = "bio-ref-gated-prompt-v1"
PRICING = {"input_per_1m": 5.00, "cached_input_per_1m": 0.50, "output_per_1m": 30.00}

QUESTION_ID = "SPIKE-FRQ-02"
CRITERION_ID = "FRQ02-C2"
CRITERION_TEXT = "Explains that the construction event is random/non-selective with respect to flower-color fitness."
PROMPT = """A population of wild wildflowers exhibits a single gene locus with two alleles (`F` and `f`) controlling flower color. A construction project randomly destroys 90% of the wildflower population. The remaining individual plants are left to randomly interbreed.

A. Identify the specific evolutionary mechanism responsible for the sudden alteration of allele frequencies in this small population.

B. Explain how the genetic diversity of this isolated population will compare to the original ancestral population over subsequent generations, assuming no mutation or gene flow occurs."""


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


def select_hard_set(rows: list[dict[str, Any]], limit: int = 40) -> list[dict[str, Any]]:
    def hard_score(row: dict[str, Any]) -> tuple[int, str]:
        tags = set(row.get("boundary_tags", []))
        text = row.get("answer_text", "").lower()
        score = 0
        if "identifies_genetic_drift" in tags:
            score += 3
        if "identifies_bottleneck" in tags:
            score += 2
        if "random_nonselective_event_explicit" in tags:
            score += 3
        if "chance_sampling_or_allele_loss" in tags:
            score += 2
        if "random_survivor_sample" in tags:
            score += 2
        if "fitness_based_selection_language" in tags:
            score += 3
        if "selection_mechanism_error" in tags:
            score += 2
        if "random_mating_fallacy" in tags or "random_mating_mechanism_error" in tags:
            score += 2
        if "random" in text or "chance" in text or "nonselective" in text or "not based" in text:
            score += 1
        return (-score, row["response_id"])

    earned = [row for row in rows if row["criterion_labels"][CRITERION_ID] == "earned"]
    not_earned = [row for row in rows if row["criterion_labels"][CRITERION_ID] == "not_earned"]
    return sorted(
        sorted(earned, key=hard_score)[: limit // 2]
        + sorted(not_earned, key=hard_score)[: limit // 2],
        key=lambda row: row["response_id"],
    )


def build_instructions(arm: str) -> str:
    if arm == "bm_gated":
        return f"""
You are Cramapple's AP Biology FRQ grader for an internal prompt optimization test.
Grade only criterion {CRITERION_ID}.

Criterion:
{CRITERION_TEXT}

Decision procedure:
1. Extract the shortest exact student phrase that supports earning C2.
2. The extracted phrase must show that construction, destruction, survival,
   death, or allele loss was random, by chance, non-selective, or unrelated to
   flower-color fitness.
3. Do not infer random/non-selective survival from the words "genetic drift" or
   "bottleneck" alone.
4. Do not award C2 for only saying allele frequencies changed, the population
   got smaller, or diversity decreased.
5. If the response says or implies natural selection, stronger plants, fitter
   plants, better-adapted plants, or fitness-based survival caused the change,
   C2 fails unless the response separately and clearly states that this
   construction event was random/non-selective.

Consistency invariants:
- If evidence_quote is empty, decision_gate must be "fail" and status must be
  "not_earned".
- If decision_gate is "fail", status must be "not_earned".
- If evidence_quote only identifies genetic drift or bottleneck, decision_gate
  must be "fail" for C2.

Return only valid JSON:
{{
  "criterion_id": "{CRITERION_ID}",
  "evidence_quote": "exact quote or empty string",
  "decision_gate": "pass|fail",
  "status": "earned|not_earned|unable_to_determine",
  "rationale": "short grading rationale",
  "minimal_fix": "short repair move"
}}
""".strip()

    return f"""
You are Cramapple's AP Biology FRQ grader for an internal prompt optimization test.
Grade only criterion {CRITERION_ID}.
Criterion: {CRITERION_TEXT}

Return only valid JSON:
{{
  "status": "earned|not_earned|unable_to_determine",
  "confidence": "high|medium|low",
  "rationale": "short grading rationale",
  "minimal_fix": "short repair move"
}}
""".strip()


def build_input(row: dict[str, Any]) -> str:
    return f"""
Question ID: {QUESTION_ID}

Prompt:
{PROMPT}

Criterion to grade:
{CRITERION_ID}: {CRITERION_TEXT}

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
        if line.strip():
            row = json.loads(line)
            keys.add((row["experiment_arm"], row["response_id"]))
    return keys


def quality_flag(model_status: str, human_status: str) -> str:
    if human_status == "earned" and model_status != "earned":
        return f"under_credit:{CRITERION_ID}"
    if human_status != "earned" and model_status == "earned":
        return f"over_credit:{CRITERION_ID}"
    return ""


def run_one(api_key: str, handle: Any, row: dict[str, Any], arm: str) -> None:
    instructions = build_instructions(arm)
    user_input = build_input(row)
    body = {
        "model": MODEL_ID,
        "reasoning": {"effort": "medium"},
        "instructions": instructions,
        "input": user_input,
        "max_output_tokens": 900,
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
            schema_valid = parsed.get("status") in {"earned", "not_earned", "unable_to_determine"}
        except json.JSONDecodeError:
            parsed = {}
    model_status = parsed.get("status") if schema_valid else "unable_to_determine"
    human_status = row["criterion_labels"][CRITERION_ID]
    flag = quality_flag(model_status, human_status)
    usage = usage_counts(api_response)
    record = {
        "experiment_arm": arm,
        "model_id": MODEL_ID,
        "reasoning_effort": "medium",
        "prompt_version": f"{OUTPUT_SCHEMA_VERSION}:{arm}",
        "prompt_hash": prompt_hash(instructions, user_input),
        "output_schema_version": OUTPUT_SCHEMA_VERSION,
        "question_id": QUESTION_ID,
        "criterion_id": CRITERION_ID,
        "response_id": row["response_id"],
        "answer_text": row["answer_text"],
        "human_status": human_status,
        "model_status": model_status,
        "schema_valid": schema_valid,
        "timeout_or_retry": timeout_or_retry,
        "quality_flags": [flag] if flag else [],
        "evidence_quote": parsed.get("evidence_quote", ""),
        "decision_gate": parsed.get("decision_gate", ""),
        "input_tokens": usage["input_tokens"],
        "output_tokens": usage["output_tokens"],
        "reasoning_tokens": usage["reasoning_tokens"],
        "cached_tokens": usage["cached_tokens"],
        "total_latency_ms": total_latency_ms,
        "provider_latency_ms": provider_latency_ms,
        "estimated_initial_grade_cost_usd": estimate_cost(usage),
        "rationale": parsed.get("rationale", error_message),
        "minimal_fix": parsed.get("minimal_fix", ""),
        "boundary_tags": row.get("boundary_tags", []),
        "reviewer_note": row.get("reviewer_note", ""),
    }
    handle.write(json.dumps(record, ensure_ascii=True) + "\n")
    handle.flush()
    print(
        f"{arm} {row['response_id']}: schema={schema_valid} human={human_status} "
        f"model={model_status} flags={len(record['quality_flags'])} "
        f"cost=${record['estimated_initial_grade_cost_usd']:.5f} latency={total_latency_ms:.0f}ms"
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--labels", type=Path, default=LABELS_PATH)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--limit", type=int, default=40)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    load_dotenv(ROOT / ".env.local")
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key and not args.dry_run:
        fail("OPENAI_API_KEY is not set")

    rows = select_hard_set(load_rows(args.labels), args.limit)
    arms = ["bm_control", "bm_gated"]
    if args.dry_run:
        earned = sum(1 for row in rows if row["criterion_labels"][CRITERION_ID] == "earned")
        print(f"Dry run OK. Answers: {len(rows)}. Planned calls: {len(rows) * len(arms)}.")
        print(f"C2 labels: earned={earned}, not_earned={len(rows) - earned}")
        print("Response IDs:", ", ".join(row["response_id"] for row in rows))
        return 0

    args.output.parent.mkdir(parents=True, exist_ok=True)
    done = existing_keys(args.output)
    with args.output.open("a", encoding="utf-8") as handle:
        for row in rows:
            for arm in arms:
                if (arm, row["response_id"]) in done:
                    continue
                run_one(api_key or "", handle, row, arm)
    print(f"Wrote gated prompt JSONL: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
