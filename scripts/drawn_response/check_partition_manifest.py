#!/usr/bin/env python3
"""Validate and aggregate-check drawn-response partition manifests.

Checks structural schema validity (partition_manifest.schema.json) plus the
cross-response governance requirements in
docs/research/TASK-0011_PHASE_1_EXECUTION_SPEC.md section 8.1: per-item
partition counts, per-archetype minimums, coverage-tag percentages, and the
access-lock invariant for locked_holdout/challenge responses.

Takes one manifest file per item (one item per manifest, per the schema) and
reports aggregate findings across all manifests passed in.
"""

from __future__ import annotations

import argparse
import json
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

sys.path.insert(0, str(Path(__file__).resolve().parent))
from validate_records import ValidationError, load_schema, validate_record  # noqa: E402

PARTITION_TARGETS_PER_ITEM = {
    "development": 15,
    "calibration": 10,
    "locked_holdout": 20,
    "challenge": 5,
}
ARCHETYPE_MIN_RESPONSES = 40
TAG_MINIMUM_FRACTION = {
    "partial_credit": 0.15,
    "contradictory_or_inconsistent": 0.10,
    "ambiguous_or_adversarial": 0.10,
}
LOCKED_PARTITIONS = {"locked_holdout", "challenge"}


def load_manifests(paths: list[Path]) -> list[dict[str, Any]]:
    manifests = []
    for path in paths:
        manifests.append(json.loads(path.read_text(encoding="utf-8")))
    return manifests


def check_structural(manifests: list[dict[str, Any]]) -> list[str]:
    schema = load_schema("partition_manifest")
    errors = []
    for manifest in manifests:
        try:
            validate_record(manifest, schema)
        except ValidationError as exc:
            errors.append(f"{manifest.get('item_id', '?')}: {exc}")
    return errors


def check_per_item_counts(manifests: list[dict[str, Any]]) -> list[str]:
    findings = []
    for manifest in manifests:
        item_id = manifest["item_id"]
        counts = Counter(r["partition"] for r in manifest["responses"])
        for partition, target in PARTITION_TARGETS_PER_ITEM.items():
            actual = counts.get(partition, 0)
            if actual < target:
                findings.append(
                    f"{item_id}: {partition} has {actual} responses, target is {target} (section 8.1)"
                )
    return findings


def check_access_lock_invariant(manifests: list[dict[str, Any]]) -> list[str]:
    findings = []
    for manifest in manifests:
        item_id = manifest["item_id"]
        for response in manifest["responses"]:
            if response["partition"] in LOCKED_PARTITIONS and not response["access_locked"]:
                findings.append(
                    f"{item_id}/{response['response_id']}: partition={response['partition']} but access_locked=false (section 6.2 step 10; section 8.1)"
                )
            if "item_author" in response["authorized_roles"] and response["partition"] in LOCKED_PARTITIONS:
                findings.append(
                    f"{item_id}/{response['response_id']}: item_author listed as authorized for {response['partition']} (section 6.1: item authors may not access locked holdout cases)"
                )
    return findings


def check_archetype_minimums(manifests: list[dict[str, Any]]) -> list[str]:
    findings = []
    by_archetype: dict[str, int] = defaultdict(int)
    for manifest in manifests:
        by_archetype[manifest["archetype"]] += len(manifest["responses"])
    for archetype, count in by_archetype.items():
        if count < ARCHETYPE_MIN_RESPONSES:
            findings.append(
                f"archetype {archetype}: {count} eligible responses across loaded manifests, minimum is {ARCHETYPE_MIN_RESPONSES} (section 8.1)"
            )
    return findings


def check_tag_coverage(manifests: list[dict[str, Any]]) -> list[str]:
    findings = []
    all_responses = [r for manifest in manifests for r in manifest["responses"]]
    total = len(all_responses)
    if total == 0:
        return findings
    for tag, min_fraction in TAG_MINIMUM_FRACTION.items():
        tagged = sum(1 for r in all_responses if tag in r["characteristic_tags"])
        fraction = tagged / total
        if fraction < min_fraction:
            findings.append(
                f"tag {tag}: {tagged}/{total} ({fraction:.1%}) across loaded manifests, minimum is {min_fraction:.0%} (section 8.1)"
            )
    return findings


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "manifest_paths",
        nargs="+",
        type=Path,
        help="One partition manifest JSON file per item. Pass all items being checked together for accurate archetype/coverage aggregates -- partial corpora will under-report against the section 8.1 minimums by design.",
    )
    args = parser.parse_args()

    manifests = load_manifests(args.manifest_paths)

    structural_errors = check_structural(manifests)
    if structural_errors:
        print("STRUCTURAL SCHEMA ERRORS:")
        for error in structural_errors:
            print(f"  - {error}")
        print()
        print("Aggregate checks skipped until structural errors are fixed.")
        return 1

    findings = (
        check_per_item_counts(manifests)
        + check_access_lock_invariant(manifests)
        + check_archetype_minimums(manifests)
        + check_tag_coverage(manifests)
    )

    if findings:
        print(f"FAIL: {len(findings)} governance finding(s) against section 8.1:")
        for finding in findings:
            print(f"  - {finding}")
        return 1

    print(f"OK: {len(manifests)} manifest(s), {sum(len(m['responses']) for m in manifests)} response(s) total, all section 8.1 checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
