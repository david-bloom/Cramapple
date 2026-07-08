#!/usr/bin/env python3
"""Run AP Statistics grading experiments at scale.

This runner materializes a grading experiment from the AP Statistics bootstrap
corpus, grades the synthetic responses with multiple model arms, and writes a
JSONL result stream plus a Markdown summary report.

The corpus itself lives in:
  docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json

The draft grading contract lives in:
  prompts/GRADER_BOOTSTRAP_DRAFT_ROLE_PROMPT.md
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import statistics
import time
import urllib.error
import urllib.request
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CORPUS = ROOT / "docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json"
DEFAULT_PROMPT = ROOT / "prompts/GRADER_BOOTSTRAP_DRAFT_ROLE_PROMPT.md"
DEFAULT_OUTPUT = Path("/private/tmp/cramapple-apstats-grading/ap_statistics_grading_experiment_results.jsonl")
DEFAULT_REPORT = ROOT / "docs/research/ap_statistics_grading_experiment_report_2026_07_07.md"
DEFAULT_RUN_KEY = "ap_statistics_grading_experiment_2026_07_07"
DEFAULT_RUN_ID = "ap_statistics_frq_v1_2026_07_07"

MODEL_PRICING = {
    "gpt-4o-mini": {"input_per_1m": 0.15, "cached_input_per_1m": 0.075, "output_per_1m": 0.6},
    "gpt-5.5": {"input_per_1m": 5.0, "cached_input_per_1m": 0.5, "output_per_1m": 30.0},
}

OUTPUT_SCHEMA_VERSION = "ap-stats-grading-experiment-v1"

GRADING_OUTPUT_SCHEMA = {
    "type": "object",
    "additionalProperties": False,
    "properties": {
        "role": {"type": "string", "enum": ["draft"]},
        "task_id": {"type": "string"},
        "content_key": {"type": "string"},
        "criterion_scores": {
            "type": "array",
            "items": {
                "type": "object",
                "additionalProperties": False,
                "properties": {
                    "criterion_key": {"type": "string"},
                    "score": {"type": "integer", "enum": [0, 1]},
                    "confidence": {
                        "type": "string",
                        "enum": ["high", "medium", "low"],
                    },
                    "rationale": {"type": "string"},
                    "evidence": {"type": "string"},
                },
                "required": [
                    "criterion_key",
                    "score",
                    "confidence",
                    "rationale",
                    "evidence",
                ],
            },
        },
        "total_score": {"type": "integer"},
        "confidence_summary": {
            "type": "string",
            "enum": ["high", "medium", "low"],
        },
        "failure_modes": {
            "type": "array",
            "items": {"type": "string"},
        },
        "notes": {"type": "string"},
    },
    "required": [
        "role",
        "task_id",
        "content_key",
        "criterion_scores",
        "total_score",
        "confidence_summary",
        "failure_modes",
        "notes",
    ],
}


@dataclass(frozen=True)
class Arm:
    arm_key: str
    model_id: str
    reasoning_effort: str
    description: str


ARMS = [
    Arm("apstats_fast", "gpt-4o-mini", "", "Fast low-cost baseline"),
    Arm("apstats_balanced", "gpt-5.5", "low", "Balanced boundary-sensitive run"),
    Arm("apstats_strict", "gpt-5.5", "medium", "Careful higher-reasoning run"),
]


def fail(message: str) -> None:
    raise SystemExit(f"error: {message}")


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def load_prompt(path: Path) -> str:
    return path.read_text(encoding="utf-8").strip()


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


def select_items(corpus: dict[str, Any], phase: str) -> list[dict[str, Any]]:
    items = list(corpus.get("items") or [])
    if phase == "boundary":
        return [item for item in items if item.get("form") == "long"]
    if phase == "full":
        return items
    fail(f"unknown phase: {phase}")


def determine_route_bucket(case: dict[str, Any]) -> str:
    response_type = str(case.get("response_type") or "")
    frq_subtype = str(case.get("frq_subtype") or "")
    form = str(case.get("form") or "")
    difficulty = str(case.get("difficulty") or "")

    if frq_subtype == "investigative_task" or response_type == "borderline":
        return "strict"
    if form == "short":
        if difficulty in {"easy", "medium"}:
            return "fast"
        return "balanced"
    return "strict" if difficulty in {"hard", "very_hard"} else "balanced"


def rubric_total(rubric: Any) -> int:
    if not isinstance(rubric, list):
        return 0
    total = 0
    for criterion in rubric:
        if isinstance(criterion, dict):
            try:
                total += int(criterion.get("points_possible") or 0)
            except (TypeError, ValueError):
                continue
    return total


def build_cases(corpus: dict[str, Any], phase: str) -> list[dict[str, Any]]:
    cases: list[dict[str, Any]] = []
    sequence = 0
    for item in select_items(corpus, phase):
        synthetic_responses = item.get("synthetic_responses") or []
        frq_subtype = item.get("codex", {}).get("frq_subtype", "")
        for response_index, response in enumerate(synthetic_responses, start=1):
            sequence += 1
            case_key = f"{item['content_key']}#{response_index:02d}"
            cases.append(
                {
                    "case_key": case_key,
                    "sequence_index": sequence,
                    "content_key": item["content_key"],
                    "response_index": response_index,
                    "response_type": response.get("type", ""),
                    "expected_score_type": response.get("type", ""),
                    "form": item.get("form", ""),
                    "difficulty": item.get("difficulty", ""),
                    "hdr": bool(item.get("hdr")),
                    "frq_subtype": frq_subtype,
                    "module": item.get("module", 0),
                    "question_text": item.get("question_text", ""),
                    "rubric": item.get("rubric") or [],
                    "codex": item.get("codex") or {},
                    "student_response": response.get("student_response", ""),
                    "route_bucket": determine_route_bucket(
                        {
                            "response_type": response.get("type", ""),
                            "frq_subtype": frq_subtype,
                            "form": item.get("form", ""),
                            "difficulty": item.get("difficulty", ""),
                        }
                    ),
                    "metadata": {
                        "phase": phase,
                        "rubric_total_points": rubric_total(item.get("rubric") or []),
                        "boundary_case": item.get("form") == "long",
                    },
                }
            )
    return cases


def prompt_hash(system_prompt: str, user_input: str) -> str:
    return hashlib.sha256((system_prompt + "\n\n" + user_input).encode("utf-8")).hexdigest()


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


def estimate_cost(model_id: str, usage: dict[str, int]) -> float:
    pricing = MODEL_PRICING.get(model_id, MODEL_PRICING["gpt-4o-mini"])
    cached = usage["cached_tokens"]
    uncached = max(usage["input_tokens"] - cached, 0)
    return (
        uncached * pricing["input_per_1m"]
        + cached * pricing["cached_input_per_1m"]
        + usage["output_tokens"] * pricing["output_per_1m"]
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


def arm_map() -> dict[str, Arm]:
    return {arm.arm_key: arm for arm in ARMS}


def build_user_input(case: dict[str, Any], corpus: dict[str, Any]) -> str:
    payload = {
        "task_id": corpus.get("metadata", {}).get("task_id", "TASK-0013-FRQ-BOOTSTRAP-CORPUS"),
        "dataset_version": corpus.get("metadata", {}).get("dataset_version", DEFAULT_RUN_ID),
        "content_key": case["content_key"],
        "subject": corpus.get("metadata", {}).get("subject", "ap-statistics"),
        "frq_form": case["form"],
        "difficulty": case["difficulty"],
        "frq_subtype": case["frq_subtype"],
        "question_text": case["question_text"],
        "rubric": case["rubric"],
        "student_response": {
            "text": case["student_response"],
            "model_generated": True,
            "response_type": case["response_type"],
        },
        "holdout": False,
        "case_metadata": {
            "case_key": case["case_key"],
            "response_index": case["response_index"],
            "expected_score_type": case["expected_score_type"],
            "hdr": case["hdr"],
            "route_bucket": case["route_bucket"],
        },
    }
    return json.dumps(payload, ensure_ascii=True, separators=(",", ":"))


def parse_output(raw_output: str) -> tuple[dict[str, Any], bool]:
    try:
        parsed = json.loads(raw_output)
    except json.JSONDecodeError:
        return {}, False
    schema_valid = (
        isinstance(parsed, dict)
        and parsed.get("role") == "draft"
        and isinstance(parsed.get("criterion_scores"), list)
        and isinstance(parsed.get("failure_modes"), list)
        and isinstance(parsed.get("task_id"), str)
        and isinstance(parsed.get("content_key"), str)
        and isinstance(parsed.get("total_score"), (int, float))
    )
    return parsed if isinstance(parsed, dict) else {}, schema_valid


def run_case(
    api_key: str,
    handle: Any,
    *,
    system_prompt: str,
    corpus: dict[str, Any],
    case: dict[str, Any],
    arm: Arm,
) -> dict[str, Any]:
    user_input = build_user_input(case, corpus)
    body = {
        "model": arm.model_id,
        "instructions": system_prompt,
        "input": user_input,
        "max_output_tokens": 320 if arm.arm_key == "apstats_fast" else 640,
        "store": False,
        "text": {
            "format": {
                "type": "json_schema",
                "name": "ap_stats_grading_experiment_draft",
                "strict": True,
                "schema": GRADING_OUTPUT_SCHEMA,
            }
        },
    }
    if arm.reasoning_effort:
        body["reasoning"] = {"effort": arm.reasoning_effort}
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
    raw_output = extract_output_text(api_response)
    parsed, schema_valid = parse_output(raw_output)
    usage = usage_counts(api_response)
    cost = estimate_cost(arm.model_id, usage)
    record = {
        "run_key": DEFAULT_RUN_KEY,
        "phase": case["metadata"]["phase"],
        "case_key": case["case_key"],
        "sequence_index": case["sequence_index"],
        "content_key": case["content_key"],
        "response_index": case["response_index"],
        "response_type": case["response_type"],
        "form": case["form"],
        "difficulty": case["difficulty"],
        "hdr": case["hdr"],
        "frq_subtype": case["frq_subtype"],
        "module": case["module"],
        "arm_key": arm.arm_key,
        "model_id": arm.model_id,
        "reasoning_effort": arm.reasoning_effort,
        "route_bucket": case["route_bucket"],
        "prompt_version": f"{OUTPUT_SCHEMA_VERSION}:{arm.arm_key}",
        "prompt_hash": prompt_hash(system_prompt, user_input),
        "output_schema_version": OUTPUT_SCHEMA_VERSION,
        "schema_valid": schema_valid,
        "timeout_or_retry": timeout_or_retry,
        "raw_output": parsed if parsed else raw_output,
        "criterion_scores": parsed.get("criterion_scores", []),
        "total_score": parsed.get("total_score"),
        "confidence_summary": parsed.get("confidence_summary", ""),
        "failure_modes": parsed.get("failure_modes", []),
        "notes": parsed.get("notes", error_message),
        "input_tokens": usage["input_tokens"],
        "output_tokens": usage["output_tokens"],
        "reasoning_tokens": usage["reasoning_tokens"],
        "cached_tokens": usage["cached_tokens"],
        "provider_latency_ms": provider_latency_ms,
        "total_latency_ms": total_latency_ms,
        "estimated_cost_usd": cost,
        "student_response": case["student_response"],
        "rubric_total_points": case["metadata"]["rubric_total_points"],
        "boundary_case": case["metadata"]["boundary_case"],
    }
    handle.write(json.dumps(record, ensure_ascii=True) + "\n")
    handle.flush()
    print(
        f"{arm.arm_key} {case['case_key']} [{case['route_bucket']}]: schema={schema_valid} "
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


def vector_key(scores: Any) -> str:
    return json.dumps(scores, sort_keys=True, ensure_ascii=True)


def summarize(records: list[dict[str, Any]], arms: list[str]) -> dict[str, Any]:
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for record in records:
        grouped[str(record["arm_key"])].append(record)

    summary: dict[str, Any] = {}
    for arm in arms:
        arm_records = grouped.get(arm, [])
        latencies = [float(row["total_latency_ms"] or 0) for row in arm_records]
        costs = [float(row["estimated_cost_usd"] or 0) for row in arm_records]
        schema_valid = sum(1 for row in arm_records if row["schema_valid"])
        boundary_rows = [row for row in arm_records if row.get("boundary_case")]
        boundary_valid = sum(1 for row in boundary_rows if row["schema_valid"])
        confidence_counts = Counter(str(row.get("confidence_summary") or "unknown") for row in arm_records)
        score_values = [float(row["total_score"]) for row in arm_records if isinstance(row.get("total_score"), (int, float))]
        score_max_values = [float(row["rubric_total_points"]) for row in arm_records if isinstance(row.get("rubric_total_points"), (int, float))]
        summary[arm] = {
            "count": len(arm_records),
            "schema_valid_rate": schema_valid / len(arm_records) if arm_records else None,
            "boundary_case_count": len(boundary_rows),
            "boundary_schema_valid_rate": boundary_valid / len(boundary_rows) if boundary_rows else None,
            "p50_latency_ms": statistics.median(latencies) if latencies else None,
            "p95_latency_ms": percentile(latencies, 0.95),
            "avg_cost_usd": statistics.mean(costs) if costs else None,
            "avg_score": statistics.mean(score_values) if score_values else None,
            "avg_max_score": statistics.mean(score_max_values) if score_max_values else None,
            "confidence_counts": dict(sorted(confidence_counts.items())),
            "route_counts": dict(sorted(Counter(str(row.get("route_bucket") or "unknown") for row in arm_records).items())),
        }

    baseline = arms[0] if arms else ""
    if baseline and baseline in grouped:
        baseline_vectors = {
            row["case_key"]: vector_key(row.get("criterion_scores"))
            for row in grouped[baseline]
        }
        for arm in arms[1:]:
            matches = 0
            shared = 0
            for row in grouped.get(arm, []):
                baseline_vector = baseline_vectors.get(row["case_key"])
                if baseline_vector is None:
                    continue
                shared += 1
                if baseline_vector == vector_key(row.get("criterion_scores")):
                    matches += 1
            summary[arm]["baseline_exact_vector_agreement"] = matches / shared if shared else None
            summary[arm]["shared_cases_with_baseline"] = shared
            summary[arm]["baseline"] = baseline

    return summary


def write_report(path: Path, corpus: dict[str, Any], summary: dict[str, Any], arms: list[str], phase: str, total_cases: int, total_records: int) -> None:
    lines = [
        "# AP Statistics Grading Experiment Report",
        "",
        f"**Run key:** `{DEFAULT_RUN_KEY}`",
        f"**Phase:** `{phase}`",
        f"**Corpus version:** `{corpus.get('metadata', {}).get('dataset_version', DEFAULT_RUN_ID)}`",
        f"**Cases:** {total_cases}",
        f"**Model calls:** {total_records}",
        "",
        "## Corpus Slice",
        "",
        "- `boundary` = long investigative-task items only.",
        "- `full` = all 100 FRQs and 220 synthetic responses.",
        "",
        "## Arm Summary",
        "",
        "| Arm | Calls | Schema Valid | Boundary Valid | p50 Latency ms | p95 Latency ms | Avg Cost USD | Avg Score | Avg Max Score |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for arm in arms:
        data = summary.get(arm, {})
        lines.append(
            f"| {arm} | {data.get('count', 0)} | {fmt(data.get('schema_valid_rate'))} | "
            f"{fmt(data.get('boundary_schema_valid_rate'))} | {fmt(data.get('p50_latency_ms'))} | "
            f"{fmt(data.get('p95_latency_ms'))} | {fmt(data.get('avg_cost_usd'))} | "
            f"{fmt(data.get('avg_score'))} | {fmt(data.get('avg_max_score'))} |"
        )

    lines.extend([
        "",
        "## Comparison",
        "",
        "| Arm | Baseline Agreement | Shared Cases | Confidence Mix |",
        "| --- | ---: | ---: | --- |",
    ])
    baseline = arms[0] if arms else ""
    for arm in arms:
        data = summary.get(arm, {})
        if arm == baseline:
            agreement = "n/a"
            shared = data.get("count", 0)
        else:
            agreement = fmt(data.get("baseline_exact_vector_agreement"))
            shared = data.get("shared_cases_with_baseline", 0)
        lines.append(
            f"| {arm} | {agreement} | {shared} | {json.dumps(data.get('confidence_counts', {}), ensure_ascii=True)} |"
        )

    lines.extend([
        "",
        "## Interpretation",
        "",
        "- The boundary phase is the first calibration gate and should be reviewed before the full-corpus scale run.",
        "- Treat `codex.frq_subtype = investigative_task` as the canonical AP Statistics long-form filter.",
        "- Route short FRQs to the fast path, and route investigative tasks or borderline responses to the strict path.",
        "- Use the baseline arm to detect criterion-vector drift before promoting any prompt or model change.",
        "",
        "## Notes",
        "",
        "- This report compares model arms only; it does not require a human gold set.",
        "- Exact agreement here is between model arms on the same synthetic response, not against external correctness labels.",
        "- Route counts are captured in the JSONL records for later analysis.",
    ])
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def fmt(value: Any) -> str:
    if value is None:
        return "n/a"
    if isinstance(value, float):
        return f"{value:.4f}".rstrip("0").rstrip(".")
    return str(value)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--corpus", type=Path, default=DEFAULT_CORPUS)
    parser.add_argument("--prompt", type=Path, default=DEFAULT_PROMPT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--run-key", default=DEFAULT_RUN_KEY)
    parser.add_argument("--phase", choices=("boundary", "full"), default="boundary")
    parser.add_argument("--arms", default=",".join(arm.arm_key for arm in ARMS))
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    load_dotenv(ROOT / ".env.local")
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key and not args.dry_run:
        fail("OPENAI_API_KEY is not set")

    selected_arms = [arm.strip() for arm in args.arms.split(",") if arm.strip()]
    known_arms = arm_map()
    unknown = sorted(set(selected_arms) - set(known_arms))
    if unknown:
        fail(f"unknown arm(s): {', '.join(unknown)}")

    corpus = load_json(args.corpus)
    system_prompt = load_prompt(args.prompt)
    cases = build_cases(corpus, args.phase)

    if args.dry_run:
        print(f"Run key: {args.run_key}")
        print(f"Phase: {args.phase}")
        print(f"Cases: {len(cases)}")
        print(f"Arms: {', '.join(selected_arms)}")
        print(f"Planned calls: {len(cases) * len(selected_arms)}")
        return 0

    args.output.parent.mkdir(parents=True, exist_ok=True)
    records: list[dict[str, Any]] = []
    with args.output.open("w", encoding="utf-8") as handle:
        for case in cases:
            for arm_key in selected_arms:
                record = run_case(
                    api_key or "",
                    handle,
                    system_prompt=system_prompt,
                    corpus=corpus,
                    case=case,
                    arm=known_arms[arm_key],
                )
                records.append(record)

    summary = summarize(records, selected_arms)
    write_report(args.report, corpus, summary, selected_arms, args.phase, len(cases), len(records))
    print(f"Wrote JSONL results: {args.output}")
    print(f"Wrote report: {args.report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
