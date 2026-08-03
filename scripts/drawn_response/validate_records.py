#!/usr/bin/env python3
"""Validate drawn-response label JSONL files against the Phase-1 schemas.

Implements the small subset of JSON Schema (draft 2020-12) used by
scripts/drawn_response/schemas/*.schema.json: type, enum, required,
properties, additionalProperties, items, anyOf, $ref/$defs, minLength,
minItems, and format=date-time. This is not a general-purpose JSON Schema
validator -- it covers exactly the constructs these repository schemas use,
with no third-party dependency, matching this repo's existing scripts
(stdlib only; see scripts/run_bio_reference_layer_oracle_boundary.py).
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import defaultdict
from datetime import datetime
from pathlib import Path
from typing import Any, Optional

SCHEMA_DIR = Path(__file__).resolve().parent / "schemas"

DATE_TIME_RE = re.compile(
    r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})$"
)


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


def validate_capture_image_semantics(record: dict[str, Any]) -> None:
    """Enforce invariants that are clearer as code than as the subset schema."""
    role = record["image_role"]
    source_image_id = record["source_image_id"]
    transformation = record["transformation"]
    if role == "ORIGINAL":
        if source_image_id is not None:
            raise ValidationError("$.source_image_id", "must be null for ORIGINAL")
        if transformation is not None:
            raise ValidationError("$.transformation", "must be null for ORIGINAL")
    else:
        if not isinstance(source_image_id, str) or not source_image_id:
            raise ValidationError("$.source_image_id", "a derivative must reference its original")
        if source_image_id == record["image_id"]:
            raise ValidationError("$.source_image_id", "an image cannot be its own source")
        if not isinstance(transformation, dict):
            raise ValidationError("$.transformation", "a derivative must record its transformation")

    digest = record["sha256"]
    if not re.fullmatch(r"[0-9a-f]{64}", digest):
        raise ValidationError("$.sha256", "must be exactly 64 lowercase hexadecimal characters")
    for field in ("byte_length", "pixel_width", "pixel_height"):
        value = record[field]
        if not isinstance(value, int) or isinstance(value, bool) or value <= 0:
            raise ValidationError(f"$.{field}", "must be a positive integer")

    file_name = Path(record["file_name"])
    if file_name.is_absolute() or ".." in file_name.parts or "://" in record["file_name"]:
        raise ValidationError("$.file_name", "must be a safe relative object/file name, not a URL")


def parse_date_time(value: str) -> datetime:
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def validate_capture_session_event_semantics(record: dict[str, Any]) -> None:
    """Enforce per-event privacy and field-shape invariants."""
    sequence = record["sequence"]
    if not isinstance(sequence, int) or isinstance(sequence, bool) or sequence <= 0:
        raise ValidationError("$.sequence", "must be a positive integer")

    subject_ref = record["binding"]["learner_subject_ref"]
    if not re.fullmatch(r"[A-Za-z0-9:_-]{1,128}", subject_ref):
        raise ValidationError(
            "$.binding.learner_subject_ref",
            "must be an opaque internal reference containing no whitespace or email syntax",
        )

    date_values = (
        ("$.occurred_at", record["occurred_at"]),
        ("$.binding.capture_expires_at", record["binding"]["capture_expires_at"]),
    )
    for path, value in date_values:
        try:
            parse_date_time(value)
        except ValueError as exc:
            raise ValidationError(path, f"invalid calendar date-time: {value!r}") from exc

    pairing = record["pairing"]
    if pairing is not None:
        generation = pairing["generation"]
        if not isinstance(generation, int) or isinstance(generation, bool) or generation <= 0:
            raise ValidationError("$.pairing.generation", "must be a positive integer")
        if not re.fullmatch(r"[0-9a-f]{64}", pairing["handle_sha256"]):
            raise ValidationError(
                "$.pairing.handle_sha256",
                "must be exactly 64 lowercase hexadecimal characters; raw handles are forbidden",
            )
        try:
            parse_date_time(pairing["expires_at"])
        except ValueError as exc:
            raise ValidationError(
                "$.pairing.expires_at",
                f"invalid calendar date-time: {pairing['expires_at']!r}",
            ) from exc

    event_type = record["event_type"]
    actor = record["actor"]
    image_id = record["image_id"]
    replaces_image_id = record["replaces_image_id"]
    quality = record["quality_status"]
    confirmation = record["explicit_confirmation"]
    reason = record["reason"]

    def require_null(*fields: tuple[str, Any]) -> None:
        for field, value in fields:
            if value is not None:
                raise ValidationError(f"$.{field}", f"must be null for {event_type}")

    common_optional = (
        ("image_id", image_id),
        ("replaces_image_id", replaces_image_id),
        ("quality_status", quality),
        ("explicit_confirmation", confirmation),
        ("reason", reason),
    )
    if event_type == "SESSION_CREATED":
        if actor != "SYSTEM" or pairing is None or pairing["access_path"] is not None:
            raise ValidationError("$", "SESSION_CREATED requires SYSTEM and an unclaimed pairing")
        if pairing["generation"] != 1:
            raise ValidationError("$.pairing.generation", "SESSION_CREATED must issue generation 1")
        if parse_date_time(pairing["expires_at"]) <= parse_date_time(record["occurred_at"]):
            raise ValidationError("$.pairing.expires_at", "must be later than SESSION_CREATED")
        if parse_date_time(record["binding"]["capture_expires_at"]) <= parse_date_time(
            record["occurred_at"]
        ):
            raise ValidationError(
                "$.binding.capture_expires_at", "must be later than SESSION_CREATED"
            )
        require_null(*common_optional)
    elif event_type == "PAIRING_ACCEPTED":
        if actor not in {"CAPTURE_DEVICE", "LEARNER", "PRIMARY_DEVICE"}:
            raise ValidationError("$.actor", "PAIRING_ACCEPTED has an invalid actor")
        if pairing is None or pairing["access_path"] not in {"QR", "FALLBACK_DIRECT"}:
            raise ValidationError("$.pairing", "PAIRING_ACCEPTED requires QR or fallback pairing")
        require_null(*common_optional)
    elif event_type == "PAIRING_REJECTED":
        if actor != "SYSTEM" or pairing is None:
            raise ValidationError("$", "PAIRING_REJECTED requires SYSTEM and pairing evidence")
        if reason not in {
            "USED_PAIRING_HANDLE", "EXPIRED_PAIRING_HANDLE", "SESSION_TERMINAL"
        }:
            raise ValidationError("$.reason", "invalid PAIRING_REJECTED reason")
        require_null(
            ("image_id", image_id),
            ("replaces_image_id", replaces_image_id),
            ("quality_status", quality),
            ("explicit_confirmation", confirmation),
        )
    elif event_type == "RECOVERY_ISSUED":
        if actor not in {"SYSTEM", "LEARNER", "PRIMARY_DEVICE"}:
            raise ValidationError("$.actor", "RECOVERY_ISSUED has an invalid actor")
        if pairing is None or pairing["access_path"] is not None:
            raise ValidationError("$.pairing", "RECOVERY_ISSUED requires a new unclaimed pairing")
        if reason not in {"DEVICE_DISCONNECTED", "PAIRING_LOST"}:
            raise ValidationError("$.reason", "invalid RECOVERY_ISSUED reason")
        if parse_date_time(pairing["expires_at"]) <= parse_date_time(record["occurred_at"]):
            raise ValidationError("$.pairing.expires_at", "must be later than RECOVERY_ISSUED")
        require_null(
            ("image_id", image_id),
            ("replaces_image_id", replaces_image_id),
            ("quality_status", quality),
            ("explicit_confirmation", confirmation),
        )
    elif event_type == "CAPTURE_RECORDED":
        if actor not in {"CAPTURE_DEVICE", "LEARNER"} or not image_id:
            raise ValidationError("$", "CAPTURE_RECORDED requires a capture actor and image_id")
        if pairing is not None:
            raise ValidationError("$.pairing", "must be null for CAPTURE_RECORDED")
        require_null(
            ("quality_status", quality),
            ("explicit_confirmation", confirmation),
            ("reason", reason),
        )
    elif event_type == "QUALITY_RECORDED":
        if actor not in {"SYSTEM", "STAFF"} or not image_id or quality is None:
            raise ValidationError("$", "QUALITY_RECORDED requires reviewer, image, and status")
        require_null(
            ("pairing", pairing),
            ("replaces_image_id", replaces_image_id),
            ("explicit_confirmation", confirmation),
            ("reason", reason),
        )
    elif event_type == "RETAKE_REQUESTED":
        if actor not in {"SYSTEM", "STAFF", "LEARNER"} or not image_id:
            raise ValidationError("$", "RETAKE_REQUESTED requires actor and image_id")
        if reason not in {
            "BLUR", "GLARE", "CUTOFF", "PERSPECTIVE", "UNREADABLE",
            "CANNOT_DETERMINE", "LEARNER_CHOICE",
        }:
            raise ValidationError("$.reason", "invalid RETAKE_REQUESTED reason")
        require_null(
            ("pairing", pairing),
            ("replaces_image_id", replaces_image_id),
            ("quality_status", quality),
            ("explicit_confirmation", confirmation),
        )
    elif event_type == "CAPTURE_REMOVED":
        if actor != "LEARNER" or not image_id or reason != "LEARNER_CHOICE":
            raise ValidationError("$", "CAPTURE_REMOVED requires learner choice and image_id")
        require_null(
            ("pairing", pairing),
            ("replaces_image_id", replaces_image_id),
            ("quality_status", quality),
            ("explicit_confirmation", confirmation),
        )
    elif event_type == "REVIEW_OPENED":
        if actor not in {"LEARNER", "PRIMARY_DEVICE"} or not image_id:
            raise ValidationError("$", "REVIEW_OPENED requires learner context and image_id")
        require_null(
            ("pairing", pairing),
            ("replaces_image_id", replaces_image_id),
            ("quality_status", quality),
            ("explicit_confirmation", confirmation),
            ("reason", reason),
        )
    elif event_type == "SUBMISSION_ACCEPTED":
        if actor not in {"LEARNER", "PRIMARY_DEVICE"} or not image_id:
            raise ValidationError("$", "SUBMISSION_ACCEPTED requires learner context and image_id")
        if confirmation is not True:
            raise ValidationError("$.explicit_confirmation", "must be true for submission")
        require_null(
            ("pairing", pairing),
            ("replaces_image_id", replaces_image_id),
            ("quality_status", quality),
            ("reason", reason),
        )
    elif event_type == "SUBMISSION_REJECTED":
        if actor != "SYSTEM" or confirmation is not True:
            raise ValidationError("$", "SUBMISSION_REJECTED requires SYSTEM and attempted confirmation")
        if reason not in {
            "DUPLICATE_SUBMISSION", "NO_ACTIVE_CAPTURE", "QUALITY_NOT_ACCEPTABLE",
            "REVIEW_REQUIRED", "SESSION_TERMINAL",
        }:
            raise ValidationError("$.reason", "invalid SUBMISSION_REJECTED reason")
        require_null(
            ("pairing", pairing),
            ("replaces_image_id", replaces_image_id),
            ("quality_status", quality),
        )
    elif event_type == "SESSION_CANCELLED":
        if actor not in {"SYSTEM", "STAFF", "LEARNER"}:
            raise ValidationError("$.actor", "SESSION_CANCELLED has an invalid actor")
        if reason not in {"USER_CANCELLED", "STAFF_CANCELLED", "SESSION_REVOKED"}:
            raise ValidationError("$.reason", "invalid SESSION_CANCELLED reason")
        require_null(
            ("pairing", pairing),
            ("image_id", image_id),
            ("replaces_image_id", replaces_image_id),
            ("quality_status", quality),
            ("explicit_confirmation", confirmation),
        )
    elif event_type == "SESSION_EXPIRED":
        if actor != "SYSTEM" or reason != "PAIRING_EXPIRED":
            raise ValidationError("$", "SESSION_EXPIRED requires SYSTEM and PAIRING_EXPIRED")
        require_null(
            ("pairing", pairing),
            ("image_id", image_id),
            ("replaces_image_id", replaces_image_id),
            ("quality_status", quality),
            ("explicit_confirmation", confirmation),
        )


def validate_capture_session_stream(
    valid_records: list[tuple[int, dict[str, Any]]],
    require_terminal: bool = True,
) -> int:
    """Validate append-only session ordering and fail-closed transitions."""
    error_count = 0
    by_session: dict[str, list[tuple[int, dict[str, Any]]]] = defaultdict(list)
    event_ids: dict[str, int] = {}
    handle_owners: dict[str, tuple[str, int]] = {}
    slot_owners: dict[str, str] = {}

    def report(line_number: int, record: dict[str, Any], message: str) -> None:
        nonlocal error_count
        print(f"line {line_number} (id={record['event_id']}): {message}")
        error_count += 1

    if not valid_records:
        print("capture session stream has no valid events")
        return 1

    for line_number, record in valid_records:
        event_id = record["event_id"]
        if event_id in event_ids:
            report(line_number, record, f"duplicate event_id; first seen on line {event_ids[event_id]}")
        else:
            event_ids[event_id] = line_number
        by_session[record["capture_session_id"]].append((line_number, record))
        pairing = record["pairing"]
        if pairing is not None:
            owner = (record["capture_session_id"], pairing["generation"])
            previous = handle_owners.get(pairing["handle_sha256"])
            if previous is not None and previous != owner:
                report(line_number, record, f"pairing handle hash reused by {previous}")
            else:
                handle_owners[pairing["handle_sha256"]] = owner

    for session_id, entries in by_session.items():
        last_appended_sequence = 0
        for line_number, record in entries:
            if record["sequence"] <= last_appended_sequence:
                report(
                    line_number,
                    record,
                    "session events are not appended in strictly increasing sequence order",
                )
            last_appended_sequence = record["sequence"]
        entries.sort(key=lambda entry: entry[1]["sequence"])
        first_line, first = entries[0]
        if first["sequence"] != 1 or first["event_type"] != "SESSION_CREATED":
            report(first_line, first, "session stream must begin with sequence 1 SESSION_CREATED")
            continue
        submission_slot_id = first["binding"]["submission_slot_id"]
        previous_slot_owner = slot_owners.get(submission_slot_id)
        if previous_slot_owner is not None and previous_slot_owner != session_id:
            report(
                first_line,
                first,
                f"submission slot is already bound to session {previous_slot_owner!r}",
            )
        else:
            slot_owners[submission_slot_id] = session_id

        expected_sequence = 1
        binding = first["binding"]
        capture_expires = parse_date_time(binding["capture_expires_at"])
        previous_time: Optional[datetime] = None
        pairings: dict[int, dict[str, Any]] = {}
        current_generation = 0
        paired = False
        current_image: Optional[str] = None
        seen_images: set[str] = set()
        quality: Optional[str] = None
        reviewed = False
        terminal: Optional[str] = None

        for line_number, record in entries:
            event_type = record["event_type"]
            when = parse_date_time(record["occurred_at"])
            if record["sequence"] != expected_sequence:
                report(
                    line_number,
                    record,
                    f"expected contiguous sequence {expected_sequence}, got {record['sequence']}",
                )
                expected_sequence = record["sequence"]
            expected_sequence += 1
            if record["binding"] != binding:
                report(line_number, record, "binding differs from SESSION_CREATED")
            if previous_time is not None and when < previous_time:
                report(line_number, record, "occurred_at moves backward within the session")
            previous_time = when

            pairing = record["pairing"]
            if (
                terminal is None
                and when >= capture_expires
                and event_type != "SESSION_EXPIRED"
            ):
                report(line_number, record, "active event occurs at or after session expiry")
            if terminal is not None:
                allowed_terminal_audit = (
                    event_type == "PAIRING_REJECTED"
                    and record["reason"] == "SESSION_TERMINAL"
                ) or (
                    event_type == "SUBMISSION_REJECTED"
                    and (
                        (terminal == "SUBMITTED" and record["reason"] == "DUPLICATE_SUBMISSION")
                        or (terminal != "SUBMITTED" and record["reason"] == "SESSION_TERMINAL")
                    )
                )
                if not allowed_terminal_audit:
                    report(line_number, record, f"event is not allowed after terminal state {terminal}")
                continue

            if event_type == "SESSION_CREATED":
                if record["sequence"] != 1:
                    report(line_number, record, "SESSION_CREATED may occur only once")
                    continue
                pairings[1] = {
                    "hash": pairing["handle_sha256"],
                    "expires": parse_date_time(pairing["expires_at"]),
                    "accepted": False,
                }
                if pairings[1]["expires"] > capture_expires:
                    report(line_number, record, "pairing expiry exceeds capture-session expiry")
                current_generation = 1
            elif event_type == "PAIRING_ACCEPTED":
                generation = pairing["generation"]
                issued = pairings.get(generation)
                if generation != current_generation or issued is None:
                    report(line_number, record, "pairing does not match the current generation")
                elif pairing["handle_sha256"] != issued["hash"]:
                    report(line_number, record, "pairing hash differs from issued generation")
                elif parse_date_time(pairing["expires_at"]) != issued["expires"]:
                    report(line_number, record, "pairing expiry differs from issued generation")
                elif when >= issued["expires"]:
                    report(line_number, record, "expired pairing handle cannot be accepted")
                elif issued["accepted"]:
                    report(line_number, record, "single-use pairing handle was accepted more than once")
                else:
                    issued["accepted"] = True
                    paired = True
            elif event_type == "PAIRING_REJECTED":
                generation = pairing["generation"]
                issued = pairings.get(generation)
                reason = record["reason"]
                if issued is not None and (
                    pairing["handle_sha256"] != issued["hash"]
                    or parse_date_time(pairing["expires_at"]) != issued["expires"]
                ):
                    report(line_number, record, "rejected pairing evidence differs from issued generation")
                if reason == "USED_PAIRING_HANDLE":
                    if issued is None or not (issued["accepted"] or generation < current_generation):
                        report(line_number, record, "USED_PAIRING_HANDLE is not supported by prior state")
                elif reason == "EXPIRED_PAIRING_HANDLE":
                    if issued is None or when < issued["expires"]:
                        report(line_number, record, "EXPIRED_PAIRING_HANDLE is not expired")
                elif reason == "SESSION_TERMINAL":
                    report(line_number, record, "SESSION_TERMINAL rejection requires terminal state")
            elif event_type == "RECOVERY_ISSUED":
                generation = pairing["generation"]
                if generation != current_generation + 1:
                    report(line_number, record, "recovery generation must increment by one")
                else:
                    pairings[generation] = {
                        "hash": pairing["handle_sha256"],
                        "expires": parse_date_time(pairing["expires_at"]),
                        "accepted": False,
                    }
                    if pairings[generation]["expires"] > capture_expires:
                        report(line_number, record, "recovery pairing outlives capture session")
                    current_generation = generation
                    paired = False
            elif event_type == "CAPTURE_RECORDED":
                image_id = record["image_id"]
                if not paired:
                    report(line_number, record, "capture requires an accepted current pairing")
                if image_id in seen_images:
                    report(line_number, record, "immutable image_id was recorded more than once")
                if current_image is None and record["replaces_image_id"] is not None:
                    report(line_number, record, "first active capture cannot replace an image")
                if current_image is not None and record["replaces_image_id"] != current_image:
                    report(line_number, record, "retake must explicitly replace the current image")
                seen_images.add(image_id)
                current_image = image_id
                quality = None
                reviewed = False
            elif event_type == "QUALITY_RECORDED":
                if record["image_id"] != current_image:
                    report(line_number, record, "quality record does not target current image")
                else:
                    quality = record["quality_status"]
            elif event_type == "RETAKE_REQUESTED":
                if record["image_id"] != current_image:
                    report(line_number, record, "retake does not target current image")
                if record["actor"] in {"SYSTEM", "STAFF"} and quality not in {
                    "RETAKE_REQUIRED", "CANNOT_DETERMINE"
                }:
                    report(line_number, record, "automated/staff retake lacks blocking quality state")
                reviewed = False
            elif event_type == "CAPTURE_REMOVED":
                if record["image_id"] != current_image:
                    report(line_number, record, "remove does not target current image")
                current_image = None
                quality = None
                reviewed = False
            elif event_type == "REVIEW_OPENED":
                if record["image_id"] != current_image:
                    report(line_number, record, "review does not target current image")
                else:
                    reviewed = True
            elif event_type == "SUBMISSION_ACCEPTED":
                if record["image_id"] != current_image or current_image is None:
                    report(line_number, record, "submission does not target an active image")
                elif quality != "ACCEPTABLE":
                    report(line_number, record, "submission requires ACCEPTABLE capture quality")
                elif not reviewed:
                    report(line_number, record, "submission requires learner review")
                else:
                    terminal = "SUBMITTED"
            elif event_type == "SUBMISSION_REJECTED":
                reason = record["reason"]
                supported = (
                    (reason == "NO_ACTIVE_CAPTURE" and current_image is None)
                    or (
                        reason == "QUALITY_NOT_ACCEPTABLE"
                        and current_image is not None
                        and quality != "ACCEPTABLE"
                    )
                    or (
                        reason == "REVIEW_REQUIRED"
                        and current_image is not None
                        and quality == "ACCEPTABLE"
                        and not reviewed
                    )
                )
                if not supported:
                    report(line_number, record, f"{reason} is not supported by current state")
            elif event_type == "SESSION_CANCELLED":
                terminal = "CANCELLED"
            elif event_type == "SESSION_EXPIRED":
                if when < capture_expires:
                    report(line_number, record, "session cannot expire before capture lease")
                else:
                    terminal = "EXPIRED"

        if require_terminal and terminal is None:
            report(entries[-1][0], entries[-1][1], f"session {session_id} has no terminal event")
    return error_count


def validate_capture_session_image_links(
    valid_events: list[tuple[int, dict[str, Any]]],
    image_records: list[dict[str, Any]],
) -> int:
    """Bind every recorded capture to an immutable ORIGINAL image record."""
    error_count = 0
    images = {record["image_id"]: record for record in image_records}
    image_sessions: dict[str, str] = {}
    for line_number, event in valid_events:
        if event["event_type"] != "CAPTURE_RECORDED":
            continue
        image = images.get(event["image_id"])
        if image is None:
            print(
                f"line {line_number} (id={event['event_id']}): "
                f"image_id {event['image_id']!r} is missing from capture-image records"
            )
            error_count += 1
            continue
        if image["image_role"] != "ORIGINAL":
            print(
                f"line {line_number} (id={event['event_id']}): "
                "CAPTURE_RECORDED must reference an ORIGINAL"
            )
            error_count += 1
        previous_session = image_sessions.get(event["image_id"])
        if previous_session is not None and previous_session != event["capture_session_id"]:
            print(
                f"line {line_number} (id={event['event_id']}): "
                f"immutable image_id is already bound to session {previous_session!r}"
            )
            error_count += 1
        else:
            image_sessions[event["image_id"]] = event["capture_session_id"]
        binding = event["binding"]
        if (
            image["response_id"],
            image["item_id"],
            image["content_item_version_id"],
        ) != (
            binding["response_id"],
            binding["item_id"],
            binding["content_item_version_id"],
        ):
            print(
                f"line {line_number} (id={event['event_id']}): "
                "capture-image response/item/version binding differs from session"
            )
            error_count += 1
        if image["provenance_status"] != "VERIFIED":
            print(
                f"line {line_number} (id={event['event_id']}): "
                "capture-image provenance must be VERIFIED before workflow use"
            )
            error_count += 1
        if image["consent_status"] not in {
            "CONSENTED_RESEARCH", "CONSENTED_PRODUCT", "SYNTHETIC"
        }:
            print(
                f"line {line_number} (id={event['event_id']}): "
                "capture-image consent is not eligible for workflow use"
            )
            error_count += 1
        if parse_date_time(image["ingested_at"]) > parse_date_time(event["occurred_at"]):
            print(
                f"line {line_number} (id={event['event_id']}): "
                "CAPTURE_RECORDED precedes the immutable image ingestion record"
            )
            error_count += 1
    return error_count


def load_schema(name: str) -> dict[str, Any]:
    candidates = [name, f"{name}.schema.json", f"{name}_record.schema.json"]
    for candidate in candidates:
        path = SCHEMA_DIR / candidate
        if path.exists():
            return json.loads(path.read_text(encoding="utf-8"))
    available = sorted(p.name for p in SCHEMA_DIR.glob("*.schema.json"))
    raise SystemExit(f"No schema matching {name!r}. Available: {available}")


def validate_file(
    jsonl_path: Path,
    schema: dict[str, Any],
    capture_images_path: Optional[Path] = None,
    require_session_terminal: bool = True,
) -> int:
    error_count = 0
    lines = [line for line in jsonl_path.read_text(encoding="utf-8").splitlines() if line.strip()]
    valid_records: list[tuple[int, dict[str, Any]]] = []
    is_capture_image = schema.get("title") == "Drawn-Response Capture Image Record"
    is_capture_session = schema.get("title") == "Drawn-Response Capture Session Event"
    for line_number, line in enumerate(lines, start=1):
        try:
            record = json.loads(line)
        except json.JSONDecodeError as exc:
            print(f"line {line_number}: invalid JSON: {exc}")
            error_count += 1
            continue
        try:
            validate_record(record, schema)
            if is_capture_image:
                validate_capture_image_semantics(record)
            if is_capture_session:
                validate_capture_session_event_semantics(record)
        except ValidationError as exc:
            record_id = (
                record.get("observation_id")
                or record.get("criterion_id")
                or record.get("event_id")
                or record.get("image_id")
                or record.get("source_image_id")
                or "?"
            )
            print(f"line {line_number} (id={record_id}): {exc}")
            error_count += 1
            continue
        valid_records.append((line_number, record))

    if is_capture_image:
        by_id: dict[str, tuple[int, dict[str, Any]]] = {}
        for line_number, record in valid_records:
            image_id = record["image_id"]
            if image_id in by_id:
                print(f"line {line_number} (id={image_id}): duplicate image_id")
                error_count += 1
            else:
                by_id[image_id] = (line_number, record)
        for line_number, record in valid_records:
            source_id = record["source_image_id"]
            if source_id is None:
                continue
            source_entry = by_id.get(source_id)
            if source_entry is None:
                print(
                    f"line {line_number} (id={record['image_id']}): "
                    f"source_image_id {source_id!r} is missing from this manifest"
                )
                error_count += 1
                continue
            source = source_entry[1]
            if source["image_role"] != "ORIGINAL":
                print(
                    f"line {line_number} (id={record['image_id']}): "
                    "source_image_id must point directly to an ORIGINAL"
                )
                error_count += 1
            if (
                source["response_id"],
                source["item_id"],
                source["content_item_version_id"],
            ) != (
                record["response_id"],
                record["item_id"],
                record["content_item_version_id"],
            ):
                print(
                    f"line {line_number} (id={record['image_id']}): "
                    "derivative response/item/version binding differs from its original"
                )
                error_count += 1
    if is_capture_session:
        error_count += validate_capture_session_stream(
            valid_records, require_terminal=require_session_terminal
        )
        if capture_images_path is not None:
            image_schema = load_schema("capture_image")
            image_errors = validate_file(capture_images_path, image_schema)
            error_count += image_errors
            if image_errors == 0:
                image_records = [
                    json.loads(line)
                    for line in capture_images_path.read_text(encoding="utf-8").splitlines()
                    if line.strip()
                ]
                error_count += validate_capture_session_image_links(
                    valid_records, image_records
                )
    return error_count


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "schema",
        help=(
            "Schema name: capture_image, capture_session_event, capture_quality, observation, "
            "criterion_decision, method_run_log, or partition_manifest."
        ),
    )
    parser.add_argument("jsonl_path", type=Path, help="Path to a JSONL file of records to validate.")
    parser.add_argument(
        "--capture-images",
        type=Path,
        help="Capture-image JSONL required when validating capture_session_event streams.",
    )
    parser.add_argument(
        "--allow-open-sessions",
        action="store_true",
        help="Allow a structurally valid active session stream with no terminal event.",
    )
    args = parser.parse_args()

    schema = load_schema(args.schema)
    if not args.jsonl_path.exists():
        raise SystemExit(f"No such file: {args.jsonl_path}")
    is_capture_session = schema.get("title") == "Drawn-Response Capture Session Event"
    if is_capture_session and args.capture_images is None:
        raise SystemExit("capture_session_event validation requires --capture-images")
    if args.allow_open_sessions and not is_capture_session:
        raise SystemExit("--allow-open-sessions applies only to capture_session_event")
    if args.capture_images is not None and not args.capture_images.exists():
        raise SystemExit(f"No such capture-image file: {args.capture_images}")

    error_count = validate_file(
        args.jsonl_path,
        schema,
        args.capture_images,
        require_session_terminal=not args.allow_open_sessions,
    )
    record_count = len(
        [line for line in args.jsonl_path.read_text(encoding="utf-8").splitlines() if line.strip()]
    )
    if error_count:
        print(f"FAIL: {error_count} invalid record(s) out of {record_count}")
        return 1
    print(f"OK: {record_count} record(s) valid against {args.schema}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
