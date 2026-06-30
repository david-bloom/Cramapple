#!/usr/bin/env python3
"""Deterministic AP Statistics calculation-check verifier.

Protocol:
- Read one JSON object per line from stdin.
- Each request must include:
  - ``answer_text``: free-text student work.
  - ``expected_answer_spec``: the synthetic criterion spec.
- Write one JSON verdict per line to stdout.

Assumed input contract for the synthetic Phase 3 checker:

.. code-block:: json

   {
     "response_id": "optional",
     "answer_text": "t = 2.31",
     "expected_answer_spec": {
       "calculation_type": "t_statistic",
       "target": 2.3,
       "tolerance": 0.05,
       "comparison": "exact"
     }
   }

For ``confidence_interval``, ``target`` must be an object with ``lower`` and
``upper`` numbers. ``tolerance`` is interpreted as an absolute epsilon for each
numeric comparison. If Phase 2 lands with a different schema, a thin adapter can
map the real stored fields into this shape without changing the checker.
"""

from __future__ import annotations

import json
import re
import sys
from dataclasses import dataclass
from typing import Any, Optional, Tuple


NUMBER_RE = r"[+-]?(?:\d*\.\d+|\d+(?:,\d{3})*|\d+)(?:e[+-]?\d+)?"
VALUE_RE = re.compile(rf"(?P<op><=|>=|<|>|=|≤|≥|≈|~)?\s*(?P<num>{NUMBER_RE})", re.I)
SINGLE_LABELS = {
    "z_statistic": [
        re.compile(r"\bz(?:[- ]?(?:score|stat(?:istic)?))?\b", re.I),
    ],
    "t_statistic": [
        re.compile(r"\bt(?:[- ]?(?:score|stat(?:istic)?))?\b", re.I),
    ],
    "p_value": [
        re.compile(r"\bp(?:[- ]?value)?\b", re.I),
    ],
}
CI_LABEL = re.compile(r"\b(?:confidence interval|ci)\b", re.I)


@dataclass(frozen=True)
class Claim:
    kind: str
    value: Optional[float] = None
    lower: Optional[float] = None
    upper: Optional[float] = None
    comparator: str = "exact"
    span_start: int = 0
    span_end: int = 0
    snippet: str = ""
    source: str = ""


def parse_number(raw: str) -> float:
    return float(raw.replace(",", ""))


def normalise_comparator(raw: Optional[str]) -> str:
    if not raw:
        return "exact"
    raw = raw.strip()
    if raw in {"<", "≤"}:
        return "lte"
    if raw in {">", "≥"}:
        return "gte"
    if raw == "=":
        return "exact"
    return "exact"


def tolerance_from(spec: dict[str, Any]) -> float:
    try:
        return abs(float(spec.get("tolerance", 0.0)))
    except (TypeError, ValueError):
        return 0.0


def _first_number_after(text: str, start: int, window: int = 80) -> Optional[Tuple[float, str, int, int]]:
    segment = text[start : min(len(text), start + window)]
    match = VALUE_RE.search(segment)
    if not match:
        return None
    return (
        parse_number(match.group("num")),
        normalise_comparator(match.group("op")),
        start + match.start("num"),
        start + match.end("num"),
    )


def _all_number_spans(text: str) -> list[tuple[int, int]]:
    return [(m.start(), m.end()) for m in re.finditer(NUMBER_RE, text)]


def _closest_distance(point: int, spans: list[Tuple[int, int]]) -> Optional[int]:
    if not spans:
        return None
    return min(
        min(abs(point - start), abs(point - end))
        for start, end in spans
    )


def extract_single_value_claims(answer_text: str, kind: str) -> list[Claim]:
    claims: list[Claim] = []
    seen: set[tuple[str, float, int, int, str]] = set()
    label_patterns = SINGLE_LABELS[kind]

    for label_pattern in label_patterns:
        for label_match in label_pattern.finditer(answer_text):
            extracted = _first_number_after(answer_text, label_match.end())
            if not extracted:
                continue
            value, comparator, value_start, value_end = extracted
            key = (kind, value, value_start, value_end, comparator)
            if key in seen:
                continue
            seen.add(key)
            claims.append(
                Claim(
                    kind=kind,
                    value=value,
                    comparator=comparator,
                    span_start=label_match.start(),
                    span_end=value_end,
                    snippet=answer_text[label_match.start():value_end].strip(),
                    source="label",
                )
            )

    if claims:
        return claims

    number_spans = _all_number_spans(answer_text)
    if len(number_spans) != 1:
        return claims

    start, end = number_spans[0]
    return [
        Claim(
            kind=kind,
            value=parse_number(answer_text[start:end]),
            comparator="exact",
            span_start=start,
            span_end=end,
            snippet=answer_text[start:end].strip(),
            source="fallback_single_number",
        )
    ]


def _pair_candidates(answer_text: str) -> list[Claim]:
    patterns = [
        re.compile(rf"\bbetween\s+(?P<lower>{NUMBER_RE})\s+and\s+(?P<upper>{NUMBER_RE})\b", re.I),
        re.compile(rf"\bfrom\s+(?P<lower>{NUMBER_RE})\s+to\s+(?P<upper>{NUMBER_RE})\b", re.I),
        re.compile(rf"\b(?P<lower>{NUMBER_RE})\s+to\s+(?P<upper>{NUMBER_RE})\b", re.I),
        re.compile(rf"\b(?P<lower>{NUMBER_RE})\s*[-–]\s*(?P<upper>{NUMBER_RE})\b", re.I),
        re.compile(rf"[\(\[]\s*(?P<lower>{NUMBER_RE})\s*,\s*(?P<upper>{NUMBER_RE})\s*[\)\]]", re.I),
    ]
    candidates: list[Claim] = []
    seen: set[tuple[float, float, int, int]] = set()
    for pattern in patterns:
        for match in pattern.finditer(answer_text):
            lower = parse_number(match.group("lower"))
            upper = parse_number(match.group("upper"))
            key = (lower, upper, match.start(), match.end())
            if key in seen:
                continue
            seen.add(key)
            candidates.append(
                Claim(
                    kind="confidence_interval",
                    lower=lower,
                    upper=upper,
                    span_start=match.start(),
                    span_end=match.end(),
                    snippet=answer_text[match.start():match.end()].strip(),
                    source="pair_pattern",
                )
            )
    return candidates


def extract_confidence_interval_claims(answer_text: str) -> list[Claim]:
    label_spans = [(m.start(), m.end()) for m in CI_LABEL.finditer(answer_text)]
    pair_candidates = _pair_candidates(answer_text)
    if not pair_candidates:
        return []

    if not label_spans:
        return pair_candidates if len(pair_candidates) == 1 else []

    scored: list[tuple[int, Claim]] = []
    for candidate in pair_candidates:
        distance = _closest_distance(candidate.span_start, label_spans)
        if distance is None:
            continue
        scored.append((distance, candidate))

    if not scored:
        return []

    scored.sort(key=lambda item: (item[0], item[1].span_start, item[1].span_end))
    best_distance = scored[0][0]
    best = [candidate for distance, candidate in scored if distance == best_distance]
    return best if len(best) == 1 else []


def compare_single_value(candidate: Claim, expected: float, tolerance: float) -> bool:
    if candidate.value is None:
        return False
    if candidate.comparator == "lte":
        return expected <= candidate.value + tolerance
    if candidate.comparator == "gte":
        return expected >= candidate.value - tolerance
    return abs(candidate.value - expected) <= tolerance


def compare_interval(candidate: Claim, expected: dict[str, Any], tolerance: float) -> bool:
    try:
        expected_lower = float(expected["lower"])
        expected_upper = float(expected["upper"])
    except (KeyError, TypeError, ValueError):
        return False
    if candidate.lower is None or candidate.upper is None:
        return False
    if candidate.lower > candidate.upper:
        return False
    return (
        abs(candidate.lower - expected_lower) <= tolerance
        and abs(candidate.upper - expected_upper) <= tolerance
    )


def evaluate(answer_text: str, expected_spec: dict[str, Any]) -> dict[str, Any]:
    calc_type = str(expected_spec.get("calculation_type") or "").strip()
    tolerance = tolerance_from(expected_spec)

    if calc_type == "confidence_interval":
        claims = extract_confidence_interval_claims(answer_text)
        if not claims:
            return {
                "verdict": "indeterminate",
                "reason": "No unambiguous confidence-interval claim could be extracted.",
                "detected_claims": [],
            }
        if len(claims) > 1:
            return {
                "verdict": "indeterminate",
                "reason": "Multiple confidence-interval claims were found and the answer is ambiguous.",
                "detected_claims": [claim.__dict__ for claim in claims],
            }
        claim = claims[0]
        matches = compare_interval(claim, expected_spec.get("target", {}), tolerance)
        return {
            "verdict": "matches" if matches else "does_not_match",
            "reason": (
                "Extracted confidence interval is within tolerance."
                if matches
                else "Extracted confidence interval is outside tolerance."
            ),
            "detected_claims": [claim.__dict__],
            "matched_claim": claim.__dict__,
        }

    if calc_type not in SINGLE_LABELS:
        return {
            "verdict": "indeterminate",
            "reason": f"Unsupported calculation type: {calc_type!r}.",
            "detected_claims": [],
        }

    claims = extract_single_value_claims(answer_text, calc_type)
    if not claims:
        return {
            "verdict": "indeterminate",
            "reason": f"No unambiguous {calc_type} claim could be extracted.",
            "detected_claims": [],
        }
    if len(claims) > 1:
        return {
            "verdict": "indeterminate",
            "reason": f"Multiple {calc_type} claims were found and the answer is ambiguous.",
            "detected_claims": [claim.__dict__ for claim in claims],
        }

    claim = claims[0]
    try:
        expected_value = float(expected_spec["target"])
    except (KeyError, TypeError, ValueError):
        return {
            "verdict": "indeterminate",
            "reason": "Expected spec missing a numeric target.",
            "detected_claims": [claim.__dict__],
        }

    matches = compare_single_value(claim, expected_value, tolerance)
    return {
        "verdict": "matches" if matches else "does_not_match",
        "reason": (
            f"Extracted {calc_type} claim is within tolerance."
            if matches
            else f"Extracted {calc_type} claim is outside tolerance."
        ),
        "detected_claims": [claim.__dict__],
        "matched_claim": claim.__dict__,
    }


def check_request(request: dict[str, Any]) -> dict[str, Any]:
    response_id = request.get("response_id", "")
    answer_text = str(request.get("answer_text") or "")
    expected_spec = request.get("expected_answer_spec") or {}
    result = evaluate(answer_text, expected_spec if isinstance(expected_spec, dict) else {})
    result["response_id"] = response_id
    result["calculation_type"] = expected_spec.get("calculation_type", "") if isinstance(expected_spec, dict) else ""
    result["expected_answer_spec"] = expected_spec if isinstance(expected_spec, dict) else {}
    return result


def main() -> int:
    for raw_line in sys.stdin:
        line = raw_line.strip()
        if not line:
            continue
        request = json.loads(line)
        sys.stdout.write(json.dumps(check_request(request)) + "\n")
        sys.stdout.flush()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
