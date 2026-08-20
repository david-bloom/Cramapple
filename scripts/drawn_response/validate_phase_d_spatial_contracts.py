#!/usr/bin/env python3
"""Validate TASK-0016 Phase D Stage D1 spatial contracts and their citation graph.

Schemas live in
docs/research/grading_phase_d_spatial_2026_07_27/schemas/*.v1.schema.json.
This module implements the same small stdlib-only JSON Schema subset as
scripts/drawn_response/validate_records.py (type, enum, const, required,
properties, additionalProperties, items, anyOf, $ref/$defs, minLength,
minItems, format=date-time) -- duplicated rather than imported so this
module has no path dependency on validate_records.py's SCHEMA_DIR, and
extended with "const" support (used by every v1 schema's contract_version
field) which the original engine does not implement.

Beyond per-record schema validity, this module enforces the Stage D1
non-negotiable architecture as executable citation-integrity rules:

- a criterion_decision_result's cited_observation_ids must all resolve to
  real visual_observation_result records for the same response_id/item_id
  (a criterion decision that cites a missing observation fails closed);
- a confidence_and_abstention_result's criterion_decision_id /
  cited_criterion_decision_ids must resolve to real criterion_decision_result
  records;
- a feedback_result's cited_criterion_decision_ids and
  cited_confidence_and_abstention_result_id must resolve;
- a confidence_and_abstention_result with decision=RELEASE_AUTOMATED must
  carry a measured measured_false_accept_rate_at_decision (self-reported
  model confidence alone can never satisfy a release gate); and
- a feedback_result's release_status must agree with its cited
  confidence_and_abstention_result's decision (RELEASED_TO_LEARNER only
  when that decision is RELEASE_AUTOMATED).

Run directly to validate the fixtures directory end-to-end:

    python3 scripts/drawn_response/validate_phase_d_spatial_contracts.py

Run the regression suite (schema tests + adversarial fail-closed tests):

    python3 -m unittest scripts.drawn_response.test_phase_d_spatial_contracts -v
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any

SCHEMA_DIR = (
    Path(__file__).resolve().parent.parent.parent
    / "docs"
    / "research"
    / "grading_phase_d_spatial_2026_07_27"
    / "schemas"
)
FIXTURE_DIR = SCHEMA_DIR / "fixtures"

DATE_TIME_RE = re.compile(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})$")

RECORD_TYPES = [
    "pairing_submission_provenance_event",
    "capture_image_record",
    "capture_quality_result",
    "visual_observation_result",
    "criterion_decision_result",
    "confidence_and_abstention_result",
    "feedback_result",
    "experiment_telemetry",
    "partition_manifest",
]


class ValidationError(Exception):
    def __init__(self, path: str, message: str) -> None:
        super().__init__(f"{path}: {message}")
        self.path = path
        self.message = message


def _type_ok(value: Any, type_name: str) -> bool:
    if type_name == "null":
        return value is None
    if type_name == "string":
        return isinstance(value, str)
    if type_name == "number":
        return isinstance(value, (int, float)) and not isinstance(value, bool)
    if type_name == "object":
        return isinstance(value, dict)
    if type_name == "array":
        return isinstance(value, list)
    if type_name == "boolean":
        return isinstance(value, bool)
    raise ValueError(f"Unsupported type in schema: {type_name}")


def _resolve(schema: dict[str, Any], root: dict[str, Any]) -> dict[str, Any]:
    if "$ref" in schema:
        ref = schema["$ref"]
        if not ref.startswith("#/$defs/"):
            raise ValueError(f"Unsupported $ref: {ref}")
        return root["$defs"][ref.removeprefix("#/$defs/")]
    return schema


def _check(value: Any, schema: dict[str, Any], root: dict[str, Any], path: str) -> None:
    schema = _resolve(schema, root)

    if "anyOf" in schema:
        errors: list[str] = []
        for sub in schema["anyOf"]:
            try:
                _check(value, sub, root, path)
                return
            except ValidationError as exc:
                errors.append(exc.message)
        raise ValidationError(path, f"matched none of anyOf: {errors}")

    if "const" in schema and value != schema["const"]:
        raise ValidationError(path, f"expected const {schema['const']!r}, got {value!r}")

    if "type" in schema:
        types = schema["type"] if isinstance(schema["type"], list) else [schema["type"]]
        if not any(_type_ok(value, t) for t in types):
            raise ValidationError(path, f"expected type in {types}, got {type(value).__name__}: {value!r}")

    if "enum" in schema and value not in schema["enum"]:
        raise ValidationError(path, f"expected one of {schema['enum']}, got {value!r}")

    if schema.get("format") == "date-time" and isinstance(value, str):
        if not DATE_TIME_RE.match(value):
            raise ValidationError(path, f"expected ISO-8601 date-time, got {value!r}")

    if "minLength" in schema and isinstance(value, str) and len(value) < schema["minLength"]:
        raise ValidationError(path, f"expected minLength {schema['minLength']}, got length {len(value)}")

    if "minItems" in schema and isinstance(value, list) and len(value) < schema["minItems"]:
        raise ValidationError(path, f"expected minItems {schema['minItems']}, got {len(value)}")

    if isinstance(value, dict) and ("properties" in schema or "required" in schema):
        required = schema.get("required", [])
        for key in required:
            if key not in value:
                raise ValidationError(path, f"missing required field {key!r}")
        properties = schema.get("properties", {})
        if schema.get("additionalProperties") is False:
            extra = set(value.keys()) - set(properties.keys())
            if extra:
                raise ValidationError(path, f"unexpected fields not in schema: {sorted(extra)}")
        for key, sub_value in value.items():
            if key in properties:
                _check(sub_value, properties[key], root, f"{path}.{key}")

    if isinstance(value, list) and "items" in schema:
        for index, item in enumerate(value):
            _check(item, schema["items"], root, f"{path}[{index}]")


def validate_record(record: dict[str, Any], schema: dict[str, Any]) -> None:
    _check(record, schema, schema, "$")


def load_schema(name: str) -> dict[str, Any]:
    path = SCHEMA_DIR / f"{name}.v1.schema.json"
    return json.loads(path.read_text(encoding="utf-8"))


def read_jsonl(path: Path) -> list[dict[str, Any]]:
    if not path.exists():
        return []
    return [
        json.loads(line)
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]


class CitationIntegrityError(Exception):
    """Raised when a record cites another record ID that does not resolve.

    Deliberately a distinct exception from ValidationError: schema errors
    describe a single record's own shape, citation-integrity errors describe
    a broken cross-record reference. Both must fail closed, but keeping them
    distinct makes it possible to tell "malformed record" apart from
    "record cites a nonexistent record" in test assertions and CLI output.
    """


def check_citation_integrity(
    observations: list[dict[str, Any]],
    criterion_decisions: list[dict[str, Any]],
    confidence_results: list[dict[str, Any]],
    feedback_results: list[dict[str, Any]],
) -> list[str]:
    """Return a list of citation-integrity error strings (empty if none)."""
    errors: list[str] = []

    observation_ids = {rec["observation_id"] for rec in observations}
    criterion_decision_ids = {rec["criterion_decision_id"] for rec in criterion_decisions}
    confidence_result_ids = {
        rec["confidence_and_abstention_result_id"] for rec in confidence_results
    }
    confidence_by_id = {
        rec["confidence_and_abstention_result_id"]: rec for rec in confidence_results
    }

    for cd in criterion_decisions:
        missing = [
            obs_id for obs_id in cd["cited_observation_ids"] if obs_id not in observation_ids
        ]
        if missing:
            errors.append(
                f"criterion_decision_result {cd['criterion_decision_id']!r} cites missing "
                f"observation_id(s): {missing}"
            )
        if cd["status"] == "not_applicable" and cd["cited_observation_ids"]:
            errors.append(
                f"criterion_decision_result {cd['criterion_decision_id']!r} status is "
                "not_applicable but cites observations (should cite none)"
            )
        if cd["status"] != "not_applicable" and not cd["cited_observation_ids"]:
            errors.append(
                f"criterion_decision_result {cd['criterion_decision_id']!r} status is "
                f"{cd['status']!r} but cites zero observations"
            )

    for car in confidence_results:
        if car["scope"] == "CRITERION":
            if car["criterion_decision_id"] not in criterion_decision_ids:
                errors.append(
                    f"confidence_and_abstention_result {car['confidence_and_abstention_result_id']!r} "
                    f"(scope=CRITERION) cites missing criterion_decision_id "
                    f"{car['criterion_decision_id']!r}"
                )
        missing_cited = [
            cid
            for cid in car["cited_criterion_decision_ids"]
            if cid not in criterion_decision_ids
        ]
        if missing_cited:
            errors.append(
                f"confidence_and_abstention_result {car['confidence_and_abstention_result_id']!r} "
                f"cites missing criterion_decision_id(s): {missing_cited}"
            )
        if car["decision"] == "RELEASE_AUTOMATED" and (
            car.get("measured_false_accept_rate_at_decision") is None
            or not car.get("calibration_policy_id")
        ):
            errors.append(
                f"confidence_and_abstention_result {car['confidence_and_abstention_result_id']!r} "
                "sets decision=RELEASE_AUTOMATED without measured calibration evidence "
                "(measured_false_accept_rate_at_decision/calibration_policy_id) -- "
                "self-reported confidence alone can never satisfy the release gate"
            )

    for fb in feedback_results:
        missing_cd = [
            cid
            for cid in fb["cited_criterion_decision_ids"]
            if cid not in criterion_decision_ids
        ]
        if missing_cd:
            errors.append(
                f"feedback_result {fb['feedback_result_id']!r} cites missing "
                f"criterion_decision_id(s): {missing_cd}"
            )
        for entry in fb["per_criterion_feedback"]:
            if entry["criterion_decision_id"] not in fb["cited_criterion_decision_ids"]:
                errors.append(
                    f"feedback_result {fb['feedback_result_id']!r} per_criterion_feedback "
                    f"references {entry['criterion_decision_id']!r}, which is not in "
                    "cited_criterion_decision_ids"
                )
        cited_car_id = fb["cited_confidence_and_abstention_result_id"]
        if cited_car_id is not None and cited_car_id not in confidence_result_ids:
            errors.append(
                f"feedback_result {fb['feedback_result_id']!r} cites missing "
                f"confidence_and_abstention_result_id {cited_car_id!r}"
            )
        elif cited_car_id is not None:
            cited_decision = confidence_by_id[cited_car_id]["decision"]
            release_status = fb["release_status"]
            if release_status == "RELEASED_TO_LEARNER" and cited_decision != "RELEASE_AUTOMATED":
                errors.append(
                    f"feedback_result {fb['feedback_result_id']!r} has release_status "
                    f"RELEASED_TO_LEARNER but cites a confidence_and_abstention_result whose "
                    f"decision is {cited_decision!r}, not RELEASE_AUTOMATED"
                )
            if release_status != "RELEASED_TO_LEARNER" and cited_decision == "RELEASE_AUTOMATED":
                errors.append(
                    f"feedback_result {fb['feedback_result_id']!r} has release_status "
                    f"{release_status!r} but cites a confidence_and_abstention_result whose "
                    "decision is RELEASE_AUTOMATED"
                )

    return errors


def validate_fixture_file(record_type: str, filename: str) -> list[str]:
    """Validate one JSONL fixture file against its record type's schema.

    Returns a list of error strings (empty if the file is fully valid).
    """
    schema = load_schema(record_type)
    errors: list[str] = []
    for line_number, record in enumerate(read_jsonl(FIXTURE_DIR / filename), start=1):
        try:
            validate_record(record, schema)
        except ValidationError as exc:
            errors.append(f"{filename} line {line_number}: {exc}")
    return errors


def main() -> int:
    total_errors = 0

    print("== Schema validation (valid fixtures must pass) ==")
    for record_type in RECORD_TYPES:
        filename = f"{record_type}.valid.jsonl"
        if not (FIXTURE_DIR / filename).exists():
            continue
        errors = validate_fixture_file(record_type, filename)
        status = "OK" if not errors else "FAIL"
        print(f"  {status}: {filename}")
        for error in errors:
            print(f"    {error}")
        total_errors += len(errors)

    print("\n== Citation-integrity check (valid fixture chain) ==")
    observations = read_jsonl(FIXTURE_DIR / "visual_observation_result.valid.jsonl")
    criterion_decisions = read_jsonl(FIXTURE_DIR / "criterion_decision_result.valid.jsonl")
    confidence_results = read_jsonl(FIXTURE_DIR / "confidence_and_abstention_result.valid.jsonl")
    feedback_results = read_jsonl(FIXTURE_DIR / "feedback_result.valid.jsonl")
    integrity_errors = check_citation_integrity(
        observations, criterion_decisions, confidence_results, feedback_results
    )
    if integrity_errors:
        print("  FAIL")
        for error in integrity_errors:
            print(f"    {error}")
    else:
        print("  OK: valid fixture chain has no citation-integrity errors")
    total_errors += len(integrity_errors)

    print("\n== Adversarial fixtures (each MUST fail closed) ==")
    adversarial_cases = [
        ("criterion decision cites missing observation",
         "criterion_decision_result.adversarial_missing_observation.jsonl", "criterion_decision_result"),
        ("confidence/abstention cites missing criterion decision",
         "confidence_and_abstention_result.adversarial_missing_criterion.jsonl", "confidence_and_abstention_result"),
        ("release decision without measured calibration evidence",
         "confidence_and_abstention_result.adversarial_unfalsifiable_release.jsonl", "confidence_and_abstention_result"),
        ("feedback cites missing criterion decision",
         "feedback_result.adversarial_missing_criterion.jsonl", "feedback_result"),
        ("feedback cites missing confidence/abstention result",
         "feedback_result.adversarial_missing_abstention.jsonl", "feedback_result"),
        ("feedback release_status contradicts cited abstention decision",
         "feedback_result.adversarial_release_status_mismatch.jsonl", "feedback_result"),
    ]
    for description, filename, record_type in adversarial_cases:
        records = read_jsonl(FIXTURE_DIR / filename)
        schema_errors = validate_fixture_file(record_type, filename)
        combined_observations = observations
        combined_cds = criterion_decisions + (records if record_type == "criterion_decision_result" else [])
        combined_cars = confidence_results + (records if record_type == "confidence_and_abstention_result" else [])
        combined_fbs = feedback_results + (records if record_type == "feedback_result" else [])
        integrity_errors = check_citation_integrity(
            combined_observations, combined_cds, combined_cars, combined_fbs
        )
        failed_closed = bool(schema_errors) or bool(integrity_errors)
        status = "OK (failed closed as expected)" if failed_closed else "FAIL (did not reject bad input!)"
        print(f"  {status}: {description} ({filename})")
        for error in schema_errors + integrity_errors:
            print(f"    {error}")
        if not failed_closed:
            total_errors += 1

    print(f"\nTotal blocking errors: {total_errors}")
    return 1 if total_errors else 0


if __name__ == "__main__":
    sys.exit(main())
