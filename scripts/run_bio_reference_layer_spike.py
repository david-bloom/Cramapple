#!/usr/bin/env python3
"""Run the Bio Reference Layer API spike.

This runner sends the approved synthetic FRQs/responses to the OpenAI
Responses API and writes per-call JSONL outside the repository. Temporary
reference context is loaded from /private/tmp so PDF-derived card text is not
committed.
"""

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
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_PACKET = ROOT / "docs/research/bio_reference_layer_spike_input_packet.md"
DEFAULT_CONTEXTS = Path("/private/tmp/cramapple-bio-ref-spike/reference_contexts.json")
DEFAULT_RESULTS = Path("/private/tmp/cramapple-bio-ref-spike/results.jsonl")

MODEL_ID = "gpt-5.5"
PRICING = {
    "input_per_1m": 5.00,
    "cached_input_per_1m": 0.50,
    "output_per_1m": 30.00,
}

OUTPUT_SCHEMA_VERSION = "bio-ref-spike-v1"


@dataclass(frozen=True)
class Criterion:
    criterion_id: str
    text: str


@dataclass(frozen=True)
class Response:
    response_id: str
    text: str
    labels: dict[str, str]
    reviewer_note: str = ""


@dataclass(frozen=True)
class Frq:
    question_id: str
    title: str
    prompt: str
    criteria: list[Criterion]
    responses: list[Response]
    dprime_required: bool


@dataclass(frozen=True)
class Arm:
    arm_id: str
    reasoning_effort: str
    output_style: str
    reference_kind: str


ARMS = [
    Arm("arm_a_high_current_no_cards", "high", "current", "none"),
    Arm("arm_b_high_compact_no_cards", "high", "compact", "none"),
    Arm("arm_bm_medium_compact_no_cards", "medium", "compact", "none"),
    Arm("arm_c_medium_verbose_context", "medium", "compact", "verbose"),
    Arm("arm_d_medium_compact_cards", "medium", "compact", "cards"),
    Arm("arm_dprime_medium_cards_no_mechanism", "medium", "compact", "cards_no_mechanism"),
]


def fail(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def load_dotenv(path: Path) -> None:
    if not path.exists():
        return
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = value


def section_between(text: str, start: str, end_pattern: str) -> str:
    start_index = text.find(start)
    if start_index == -1:
        return ""
    start_index += len(start)
    match = re.search(end_pattern, text[start_index:], flags=re.MULTILINE)
    end_index = start_index + match.start() if match else len(text)
    return text[start_index:end_index].strip()


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


def parse_packet(path: Path) -> list[Frq]:
    text = path.read_text(encoding="utf-8")
    matches = list(re.finditer(r"^## \d+\. (SPIKE-FRQ-\d+) - (.+)$", text, re.MULTILINE))
    frqs: list[Frq] = []
    for index, match in enumerate(matches):
        question_id = match.group(1)
        title = match.group(2).strip()
        end = matches[index + 1].start() if index + 1 < len(matches) else text.find("\n## 7.", match.end())
        if end == -1:
            end = len(text)
        block = text[match.start():end]

        prompt = section_between(block, "### Prompt", r"^### Draft Rubric Criteria")
        rubric_block = section_between(block, "### Draft Rubric Criteria", r"^### Response Set")
        criteria: list[Criterion] = []
        for row in parse_table_rows(rubric_block):
            if row and row[0].startswith("FRQ"):
                criteria.append(Criterion(row[0], row[1]))

        label_block = section_between(block, "### Confirmed Label Matrix", r"^##|\Z")
        labels: dict[str, dict[str, str]] = {}
        reviewer_notes: dict[str, str] = {}
        for row in parse_table_rows(label_block):
            if row and row[0].startswith("FRQ"):
                labels[row[0]] = {
                    criterion.criterion_id: row[i + 1]
                    for i, criterion in enumerate(criteria)
                    if i + 1 < len(row)
                }
                note_index = len(criteria) + 1
                reviewer_notes[row[0]] = row[note_index] if note_index < len(row) else ""

        responses: list[Response] = []
        for response_match in re.finditer(
            r"^#### (FRQ\d+-R\d+)\n\n```text\n(.*?)\n```",
            block,
            flags=re.MULTILINE | re.DOTALL,
        ):
            response_id = response_match.group(1)
            responses.append(
                Response(
                    response_id=response_id,
                    text=response_match.group(2).strip(),
                    labels=labels.get(response_id, {}),
                    reviewer_note=reviewer_notes.get(response_id, ""),
                )
            )

        dprime_required = "**D-prime required:** Yes" in block
        frqs.append(Frq(question_id, title, prompt, criteria, responses, dprime_required))
    return frqs


def load_contexts(path: Path) -> dict[str, Any]:
    if not path.exists():
        fail(f"reference contexts not found: {path}")
    return json.loads(path.read_text(encoding="utf-8"))


def reference_text(frq: Frq, arm: Arm, contexts: dict[str, Any]) -> tuple[str, int]:
    if arm.reference_kind == "none":
        return "No reference context retrieved.", 0
    entry = contexts.get(frq.question_id)
    if not entry:
        fail(f"missing reference context for {frq.question_id}")
    if arm.reference_kind == "verbose":
        text = str(entry.get("arm_c_verbose_context", "")).strip()
    elif arm.reference_kind == "cards":
        text = "\n".join(f"- {card}" for card in entry.get("arm_d_cards", []))
    elif arm.reference_kind == "cards_no_mechanism":
        text = "\n".join(
            f"- {card}" for card in entry.get("arm_dprime_cards_no_mechanism", [])
        )
    else:
        text = ""
    return text or "No reference context retrieved.", len(text.split())


def prompt_version(arm: Arm) -> str:
    return f"{OUTPUT_SCHEMA_VERSION}:{arm.arm_id}"


def exemplar_block(frq: Frq, held_out: Response) -> tuple[str, list[str], dict[str, dict[str, int]], int]:
    exemplars = [response for response in frq.responses if response.response_id != held_out.response_id]
    blocks: list[str] = []
    label_mix: dict[str, dict[str, int]] = {
        criterion.criterion_id: {"earned": 0, "not_earned": 0, "unable_to_determine": 0}
        for criterion in frq.criteria
    }
    exemplar_ids: list[str] = []
    for response in sorted(exemplars, key=lambda item: item.response_id):
        exemplar_ids.append(response.response_id)
        label_lines: list[str] = []
        for criterion in frq.criteria:
            label = response.labels.get(criterion.criterion_id, "unable_to_determine")
            if label not in label_mix[criterion.criterion_id]:
                label_mix[criterion.criterion_id][label] = 0
            label_mix[criterion.criterion_id][label] += 1
            short_id = criterion.criterion_id.split("-")[-1]
            label_lines.append(f"- {short_id} ({criterion.criterion_id}): {label}")
        blocks.append(
            "\n".join(
                [
                    f"Example response ID: {response.response_id}",
                    "Example response:",
                    response.text,
                    "",
                    "Criterion labels for the example:",
                    *label_lines,
                    "",
                    f"Reviewer rationale: {response.reviewer_note}",
                ]
            )
        )
    text = "\n\n---\n\n".join(blocks)
    return text, exemplar_ids, label_mix, len(text.split())


def build_instructions(arm: Arm) -> str:
    if arm.output_style == "current":
        style = (
            "Use the current fuller feedback style. Include a concise reviewer "
            "rationale and student-facing feedback, but still return JSON only."
        )
    else:
        style = (
            "Use the compact style. Keep the highest_value_gap and repair move "
            "short, specific, and non-answer-leaking."
        )
    return f"""
You are Cramapple's AP Biology FRQ grader for an internal spike.
Grade only against the provided rubric criteria.
Reference context, when present, may clarify biology or common misconceptions,
but it must not add scoring criteria or broaden the rubric.
If no reference cards are retrieved, grade against the rubric without invented
context.
Mark each criterion exactly as "earned", "not_earned", or
"unable_to_determine".
{style}

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


def build_exemplar_instructions() -> str:
    return f"""
You are Cramapple's AP Biology FRQ grader for an internal scored-exemplar
follow-up test.
Grade only against the provided rubric criteria.
The scored examples are calibration precedents for this same FRQ. Use them to
interpret scoring boundaries and accepted/insufficient wording for each
criterion.
Do not copy labels blindly. If the held-out response differs materially from
the examples, grade the held-out response on its own merits.
Do not add criteria, broaden criteria, or use biology knowledge beyond what is
needed to apply the rubric.
Mark each criterion exactly as "earned", "not_earned", or
"unable_to_determine".
Use the compact style. Keep the highest_value_gap and repair move short,
specific, and non-answer-leaking.

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


def build_input(frq: Frq, response: Response, arm: Arm, reference: str) -> str:
    rubric = "\n".join(
        f"- {criterion.criterion_id}: {criterion.text}" for criterion in frq.criteria
    )
    return f"""
Question ID: {frq.question_id}
Question title: {frq.title}

Prompt:
{frq.prompt}

Rubric criteria:
{rubric}

Reference context for this arm:
{reference}

Student response ID: {response.response_id}
Student response:
{response.text}
""".strip()


def build_exemplar_input(frq: Frq, response: Response, exemplars: str) -> str:
    rubric = "\n".join(
        f"- {criterion.criterion_id}: {criterion.text}" for criterion in frq.criteria
    )
    return f"""
Scored exemplars for calibration:
{exemplars}

Question ID: {frq.question_id}
Question title: {frq.title}

Prompt:
{frq.prompt}

Rubric criteria:
{rubric}

Held-out student response ID: {response.response_id}
Held-out student response:
{response.text}
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
    return "\n".join(chunk for chunk in chunks if chunk).strip()


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
    uncached_input = max(usage["input_tokens"] - cached, 0)
    return (
        uncached_input * PRICING["input_per_1m"]
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
    elapsed_ms = (time.perf_counter() - started) * 1000
    return json.loads(raw), elapsed_ms


def selected_work(frqs: list[Frq], mode: str) -> list[tuple[Frq, list[Response]]]:
    if mode == "smoke":
        return [(frqs[0], frqs[0].responses[:3])]
    if mode == "gate":
        return [(frq, frq.responses[:5]) for frq in frqs]
    if mode == "exemplar":
        return [(frq, frq.responses[:5]) for frq in frqs]
    fail(f"unknown mode: {mode}")


def run_call(
    api_key: str,
    handle: Any,
    *,
    experiment_arm: str,
    reasoning_effort: str,
    prompt_ver: str,
    instructions: str,
    user_input: str,
    frq: Frq,
    response: Response,
    reference_tokens: int,
    extra_record: dict[str, Any] | None = None,
) -> None:
    p_hash = prompt_hash(instructions, user_input)
    body = {
        "model": MODEL_ID,
        "reasoning": {"effort": reasoning_effort},
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
    except Exception as exc:  # noqa: BLE001 - recorded for spike diagnostics
        timeout_or_retry = True
        error_message = str(exc)
    total_latency_ms = (time.perf_counter() - started) * 1000

    parsed: dict[str, Any] = {}
    schema_valid = False
    if api_response:
        output_text = extract_output_text(api_response)
        try:
            parsed = json.loads(output_text)
            schema_valid = isinstance(parsed.get("criterion_statuses"), dict)
        except json.JSONDecodeError:
            parsed = {}
            schema_valid = False

    usage = usage_counts(api_response)
    cost = estimate_cost(usage)
    criterion_statuses = parsed.get("criterion_statuses") or {}
    if not isinstance(criterion_statuses, dict):
        criterion_statuses = {}

    record = {
        "experiment_arm": experiment_arm,
        "model_id": MODEL_ID,
        "reasoning_effort": reasoning_effort,
        "prompt_version": prompt_ver,
        "prompt_hash": p_hash,
        "output_schema_version": OUTPUT_SCHEMA_VERSION,
        "prompt_caching_status": "available_if_cached_tokens_reported",
        "cached_tokens": usage["cached_tokens"],
        "question_id": frq.question_id,
        "response_id": response.response_id,
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
        "points_earned": parsed.get("points_earned", 0),
        "criterion_statuses": criterion_statuses,
        "highest_value_gap": parsed.get("highest_value_gap", ""),
        "minimum_fix_length": parsed.get("minimum_fix_length", ""),
        "confidence": parsed.get("confidence", "low"),
        "uncertainty_reason": parsed.get("uncertainty_reason", error_message),
        "quality_flags": quality_flags(criterion_statuses, response.labels),
    }
    if extra_record:
        record.update(extra_record)
    handle.write(json.dumps(record, ensure_ascii=True) + "\n")
    handle.flush()
    print(
        f"{experiment_arm} {frq.question_id} {response.response_id}: "
        f"schema={schema_valid} cost=${cost:.5f} latency={total_latency_ms:.0f}ms"
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--packet", type=Path, default=DEFAULT_PACKET)
    parser.add_argument("--contexts", type=Path, default=DEFAULT_CONTEXTS)
    parser.add_argument("--output", type=Path, default=DEFAULT_RESULTS)
    parser.add_argument("--mode", choices=["smoke", "gate", "exemplar"], default="smoke")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    load_dotenv(ROOT / ".env.local")
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key and not args.dry_run:
        fail("OPENAI_API_KEY is not set")

    frqs = parse_packet(args.packet)
    if not frqs:
        fail(f"no FRQs parsed from {args.packet}")
    contexts = {} if args.mode == "exemplar" else load_contexts(args.contexts)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    planned_calls = 0
    if args.dry_run:
        for frq, responses in selected_work(frqs, args.mode):
            for response in responses:
                if args.mode == "exemplar":
                    planned_calls += 1
                    continue
                for arm in ARMS:
                    if arm.reference_kind == "cards_no_mechanism" and not frq.dprime_required:
                        continue
                    planned_calls += 1
        print(f"Dry run OK. Planned calls: {planned_calls}")
        return 0

    with args.output.open("a", encoding="utf-8") as handle:
        for frq, responses in selected_work(frqs, args.mode):
            for response in responses:
                if args.mode == "exemplar":
                    exemplars, exemplar_ids, label_mix, exemplar_tokens = exemplar_block(frq, response)
                    instructions = build_exemplar_instructions()
                    user_input = build_exemplar_input(frq, response, exemplars)
                    run_call(
                        api_key or "",
                        handle,
                        experiment_arm="arm_bme_medium_compact_exemplars",
                        reasoning_effort="medium",
                        prompt_ver=f"{OUTPUT_SCHEMA_VERSION}:arm_bme_medium_compact_exemplars",
                        instructions=instructions,
                        user_input=user_input,
                        frq=frq,
                        response=response,
                        reference_tokens=exemplar_tokens,
                        extra_record={
                            "exemplar_ids": exemplar_ids,
                            "exemplar_token_count": exemplar_tokens,
                            "exemplar_label_mix": label_mix,
                            "near_duplicate_excluded": False,
                            "reviewer_notes_included": True,
                        },
                    )
                    continue
                for arm in ARMS:
                    if arm.reference_kind == "cards_no_mechanism" and not frq.dprime_required:
                        continue
                    reference, reference_tokens = reference_text(frq, arm, contexts)
                    instructions = build_instructions(arm)
                    user_input = build_input(frq, response, arm, reference)
                    run_call(
                        api_key or "",
                        handle,
                        experiment_arm=arm.arm_id,
                        reasoning_effort=arm.reasoning_effort,
                        prompt_ver=prompt_version(arm),
                        instructions=instructions,
                        user_input=user_input,
                        frq=frq,
                        response=response,
                        reference_tokens=reference_tokens,
                    )
    print(f"Wrote JSONL results: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
