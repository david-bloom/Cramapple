#!/usr/bin/env python3
"""Run the FRQ02-C2 oracle boundary-memory diagnostic test."""

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
DEFAULT_OUTPUT = Path("/private/tmp/cramapple-bio-ref-spike/frq02_oracle_boundary_results_2026-06-17.jsonl")

MODEL_ID = "gpt-5.5"
OUTPUT_SCHEMA_VERSION = "bio-ref-oracle-boundary-v1"
PRICING = {"input_per_1m": 5.00, "cached_input_per_1m": 0.50, "output_per_1m": 30.00}

QUESTION_ID = "SPIKE-FRQ-02"
CRITERION_ID = "FRQ02-C2"
CRITERION_TEXT = "Explains that the construction event is random/non-selective with respect to flower-color fitness."
PROMPT = """A population of wild wildflowers exhibits a single gene locus with two alleles (`F` and `f`) controlling flower color. A construction project randomly destroys 90% of the wildflower population. The remaining individual plants are left to randomly interbreed.

A. Identify the specific evolutionary mechanism responsible for the sudden alteration of allele frequencies in this small population.

B. Explain how the genetic diversity of this isolated population will compare to the original ancestral population over subsequent generations, assuming no mutation or gene flow occurs."""

BOUNDARY_TABLE = """FRQ02-C2 boundary table:

Earned:
- says the construction destruction/survival was random, by chance, a random sample, or unrelated to flower-color fitness;
- says alleles were lost by chance in the bottleneck;
- says the event was not natural selection or not based on plant fitness.

Not earned:
- only says the population got smaller or allele frequencies changed;
- only identifies bottleneck/genetic drift without explaining random or non-selective survival;
- says construction selected the stronger/fitter/better-adapted flowers;
- says natural selection caused the allele-frequency change;
- says random mating caused the change rather than random survival/destruction."""


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
    """Select a deterministic C2-heavy set with earned and not-earned cases."""

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
    earned = sorted(earned, key=hard_score)[: limit // 2]
    not_earned = sorted(not_earned, key=hard_score)[: limit // 2]
    return sorted(earned + not_earned, key=lambda row: row["response_id"])


def tokens(text: str) -> set[str]:
    stop = {
        "the", "and", "that", "this", "with", "will", "because", "from", "they",
        "their", "there", "some", "alleles", "allele", "population", "plants",
        "genetic", "diversity", "construction", "wildflowers",
    }
    return {token for token in re.findall(r"[a-zA-Z]{3,}", text.lower()) if token not in stop}


def overlap_score(current: dict[str, Any], precedent: dict[str, Any]) -> int:
    current_text = current["answer_text"] + " " + " ".join(current.get("boundary_tags", []))
    precedent_text = precedent["answer_text"] + " " + " ".join(precedent.get("boundary_tags", []))
    return len(tokens(current_text) & tokens(precedent_text))


def compact(text: str, max_chars: int = 280) -> str:
    one_line = " ".join(text.split())
    return one_line if len(one_line) <= max_chars else one_line[: max_chars - 3].rstrip() + "..."


def oracle_precedents(current: dict[str, Any], rows: list[dict[str, Any]]) -> tuple[str, list[str]]:
    """Oracle retrieval: balanced C2 precedents, including label-matched neighbors."""
    current_label = current["criterion_labels"][CRITERION_ID]
    other_label = "not_earned" if current_label == "earned" else "earned"
    blocks: list[str] = []
    ids: list[str] = []
    for label, count in [(current_label, 3), (other_label, 3)]:
        candidates = [
            row for row in rows
            if row["response_id"] != current["response_id"]
            and row["criterion_labels"][CRITERION_ID] == label
        ]
        candidates.sort(key=lambda row: (-overlap_score(current, row), row["response_id"]))
        for row in candidates[:count]:
            ids.append(row["response_id"])
            blocks.append(
                "\n".join(
                    [
                        f"Precedent ID: {row['response_id']}:{CRITERION_ID}",
                        f"Criterion label: {label}",
                        f"Response excerpt: {compact(row['answer_text'])}",
                        f"Reviewer note: {compact(row['reviewer_note'], 220)}",
                        f"Boundary tags: {', '.join(row.get('boundary_tags', [])[:8])}",
                    ]
                )
            )
    return "\n\n".join(blocks), ids


def build_instructions(arm: str) -> str:
    extra = ""
    if arm == "oracle_precedents":
        extra = "Use the scored precedents to calibrate the C2 scoring boundary. They are an oracle diagnostic upper bound; do not copy a label unless the current response makes the same scoring move."
    elif arm in {"boundary_table", "boundary_table_low"}:
        extra = "Use the boundary table to calibrate C2. Do not add criteria. Do not require exact wording."
    return f"""
You are Cramapple's AP Biology FRQ grader for an internal boundary-memory diagnostic.
Grade only criterion {CRITERION_ID}.
Criterion: {CRITERION_TEXT}
{extra}

Return only valid JSON:
{{
  "criterion_status": "earned|not_earned|unable_to_determine",
  "confidence": "high|medium|low",
  "rationale": "short grading rationale",
  "minimal_fix": "short repair move"
}}
""".strip()


def build_input(row: dict[str, Any], arm: str, precedents: str) -> str:
    context = ""
    if arm == "oracle_precedents":
        context = f"\nOracle scored C2 precedents:\n{precedents}\n"
    elif arm in {"boundary_table", "boundary_table_low"}:
        context = f"\n{BOUNDARY_TABLE}\n"
    return f"""
Question ID: {QUESTION_ID}

Prompt:
{PROMPT}

Criterion to grade:
{CRITERION_ID}: {CRITERION_TEXT}
{context}
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


def run_one(api_key: str, handle: Any, row: dict[str, Any], arm: str, all_rows: list[dict[str, Any]]) -> None:
    precedents = ""
    precedent_ids: list[str] = []
    if arm == "oracle_precedents":
        precedents, precedent_ids = oracle_precedents(row, all_rows)
    instructions = build_instructions(arm)
    user_input = build_input(row, arm, precedents)
    reasoning_effort = "low" if arm == "boundary_table_low" else "medium"
    body = {
        "model": MODEL_ID,
        "reasoning": {"effort": reasoning_effort},
        "instructions": instructions,
        "input": user_input,
        "max_output_tokens": 800,
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
            schema_valid = parsed.get("criterion_status") in {"earned", "not_earned", "unable_to_determine"}
        except json.JSONDecodeError:
            parsed = {}
    model_status = parsed.get("criterion_status") if schema_valid else "unable_to_determine"
    human_status = row["criterion_labels"][CRITERION_ID]
    flag = quality_flag(model_status, human_status)
    usage = usage_counts(api_response)
    record = {
        "experiment_arm": arm,
        "model_id": MODEL_ID,
        "reasoning_effort": reasoning_effort,
        "prompt_version": f"{OUTPUT_SCHEMA_VERSION}:{arm}",
        "prompt_hash": prompt_hash(instructions, user_input),
        "output_schema_version": OUTPUT_SCHEMA_VERSION,
        "question_id": QUESTION_ID,
        "criterion_id": CRITERION_ID,
        "response_id": row["response_id"],
        "answer_text": row["answer_text"],
        "human_status": human_status,
        "model_status": model_status,
        "ground_truth_points": 1 if human_status == "earned" else 0,
        "schema_valid": schema_valid,
        "timeout_or_retry": timeout_or_retry,
        "quality_flags": [flag] if flag else [],
        "retrieved_precedent_ids": precedent_ids,
        "retrieved_precedent_count": len(precedent_ids),
        "input_tokens": usage["input_tokens"],
        "output_tokens": usage["output_tokens"],
        "reasoning_tokens": usage["reasoning_tokens"],
        "cached_tokens": usage["cached_tokens"],
        "total_latency_ms": total_latency_ms,
        "provider_latency_ms": provider_latency_ms,
        "estimated_initial_grade_cost_usd": estimate_cost(usage),
        "confidence": parsed.get("confidence", "low"),
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

    all_rows = load_rows(args.labels)
    test_rows = select_hard_set(all_rows, args.limit)
    arms = ["bm_control", "oracle_precedents", "boundary_table", "boundary_table_low"]
    if args.dry_run:
        print(f"Dry run OK. Answers: {len(test_rows)}. Planned calls: {len(test_rows) * len(arms)}.")
        earned = sum(1 for row in test_rows if row["criterion_labels"][CRITERION_ID] == "earned")
        print(f"C2 labels: earned={earned}, not_earned={len(test_rows) - earned}")
        print("Response IDs:", ", ".join(row["response_id"] for row in test_rows))
        return 0

    args.output.parent.mkdir(parents=True, exist_ok=True)
    done = existing_keys(args.output)
    with args.output.open("a", encoding="utf-8") as handle:
        for row in test_rows:
            for arm in arms:
                if (arm, row["response_id"]) in done:
                    continue
                run_one(api_key or "", handle, row, arm, all_rows)
    print(f"Wrote oracle boundary JSONL: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
