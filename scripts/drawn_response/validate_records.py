#!/usr/bin/env python3
"""Validate drawn-response label JSONL files against the Phase-1 schemas.

Implements the small subset of JSON Schema (draft 2020-12) used by
scripts/drawn_response/schemas/*.schema.json: type, enum, required,
properties, additionalProperties, items, anyOf, $ref/$defs, minLength,
minItems, and format=date-time. This is not a general-purpose JSON Schema
validator -- it covers exactly the constructs the three record schemas use,
with no third-party dependency, matching this repo's existing scripts
(stdlib only; see scripts/run_bio_reference_layer_oracle_boundary.py).
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

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


def load_schema(name: str) -> dict[str, Any]:
    candidates = [name, f"{name}.schema.json", f"{name}_record.schema.json"]
    for candidate in candidates:
        path = SCHEMA_DIR / candidate
        if path.exists():
            return json.loads(path.read_text(encoding="utf-8"))
    available = sorted(p.name for p in SCHEMA_DIR.glob("*.schema.json"))
    raise SystemExit(f"No schema matching {name!r}. Available: {available}")


def validate_file(jsonl_path: Path, schema: dict[str, Any]) -> int:
    error_count = 0
    lines = [line for line in jsonl_path.read_text(encoding="utf-8").splitlines() if line.strip()]
    valid_records: list[tuple[int, dict[str, Any]]] = []
    is_capture_image = schema.get("title") == "Drawn-Response Capture Image Record"
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
        except ValidationError as exc:
            record_id = (
                record.get("observation_id")
                or record.get("criterion_id")
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
            if (source["response_id"], source["item_id"]) != (
                record["response_id"], record["item_id"]
            ):
                print(
                    f"line {line_number} (id={record['image_id']}): "
                    "derivative response_id/item_id differs from its original"
                )
                error_count += 1
    return error_count


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "schema",
        help=(
            "Schema name: capture_image, capture_quality, observation, "
            "criterion_decision, method_run_log, or partition_manifest."
        ),
    )
    parser.add_argument("jsonl_path", type=Path, help="Path to a JSONL file of records to validate.")
    args = parser.parse_args()

    schema = load_schema(args.schema)
    if not args.jsonl_path.exists():
        raise SystemExit(f"No such file: {args.jsonl_path}")

    error_count = validate_file(args.jsonl_path, schema)
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
