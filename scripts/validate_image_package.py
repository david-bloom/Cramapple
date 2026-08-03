#!/usr/bin/env python3
"""Validate a Cramapple image-package manifest with no third-party dependencies."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
import sys
from pathlib import Path


PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
REVIEW_STATES = {"pending", "approved", "rejected", "not_applicable"}
APPROVAL_FIELDS = (
    "scientific",
    "grading",
    "accessibility",
    "visual_layout",
)
OPERATIONAL_GATES = (
    "database_binding",
    "current_object_identity",
    "current_object_backup",
    "storage_policy_review",
    "product_owner_approval",
    "authenticated_reviewer_delivery",
    "authenticated_student_delivery",
    "independent_qa",
    "governance_registration",
    "rollback_readiness",
)


def png_dimensions(path: Path) -> tuple[int, int]:
    with path.open("rb") as handle:
        if handle.read(8) != PNG_SIGNATURE:
            raise ValueError("file is not a PNG")
        length = struct.unpack(">I", handle.read(4))[0]
        chunk_type = handle.read(4)
        if chunk_type != b"IHDR" or length < 8:
            raise ValueError("PNG has no valid IHDR chunk")
        return struct.unpack(">II", handle.read(8))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def is_sha256(value: object) -> bool:
    return isinstance(value, str) and re.fullmatch(r"[0-9a-f]{64}", value) is not None


def is_nonempty_string(value: object) -> bool:
    return isinstance(value, str) and bool(value.strip())


def safe_relative(package_dir: Path, value: str, field: str) -> Path:
    candidate = Path(value)
    if candidate.is_absolute() or ".." in candidate.parts:
        raise ValueError(f"{field} must be a package-relative path")
    resolved = (package_dir / candidate).resolve()
    if package_dir.resolve() not in resolved.parents and resolved != package_dir.resolve():
        raise ValueError(f"{field} escapes the package directory")
    return resolved


def validate_review_packet(package_dir: Path, asset: dict, label: str) -> list[str]:
    errors: list[str] = []
    value = asset.get("review_packet")
    if value is None:
        return errors
    if not isinstance(value, str):
        return [f"{label}: review_packet must be a string"]
    try:
        path = safe_relative(package_dir, value, f"{label}.review_packet")
    except ValueError as exc:
        return [str(exc)]
    if not path.is_file():
        return [f"{label}: missing review packet {value}"]
    try:
        packet = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        return [f"{label}: invalid review packet: {exc}"]
    if not isinstance(packet, dict):
        return [f"{label}: review packet must be an object"]

    bindings = {
        "asset_id": asset.get("asset_id"),
        "asset_sha256": asset.get("sha256"),
        "content_key": asset.get("content_key"),
        "content_version_id": asset.get("content_version_id"),
        "content_version_num": asset.get("content_version_num"),
    }
    for field, expected in bindings.items():
        if packet.get(field) != expected:
            errors.append(
                f"{label}: review packet {field}={packet.get(field)!r}; expected {expected!r}"
            )

    packet_accessibility = packet.get("accessibility")
    asset_accessibility = asset.get("accessibility")
    if not isinstance(packet_accessibility, dict) or not isinstance(asset_accessibility, dict):
        errors.append(f"{label}: review packet and asset accessibility must be objects")
    else:
        for field in (
            "short_alt",
            "long_description",
            "construct_equivalence_status",
            "answer_leakage_status",
        ):
            if not str(packet_accessibility.get(field, "")).strip():
                errors.append(f"{label}: review packet accessibility.{field} is required")
            if packet_accessibility.get(field) != asset_accessibility.get(field):
                errors.append(
                    f"{label}: review packet accessibility.{field} differs from asset"
                )

    gates = packet.get("review_gates")
    if not isinstance(gates, dict):
        errors.append(f"{label}: review packet review_gates must be an object")
    else:
        for field in (*APPROVAL_FIELDS, "rights"):
            gate = gates.get(field)
            if not isinstance(gate, dict) or gate.get("status") not in {
                "pending", "approved", "rejected"
            }:
                errors.append(f"{label}: review packet has invalid {field} gate")
            elif gate["status"] == "approved" and (
                not is_nonempty_string(gate.get("reviewer"))
                or not is_nonempty_string(gate.get("reviewed_at"))
            ):
                errors.append(
                    f"{label}: approved {field} gate requires reviewer and reviewed_at"
                )
        asset_review = asset.get("review", {})
        for field in APPROVAL_FIELDS:
            if (
                isinstance(gates.get(field), dict)
                and gates[field].get("status") != asset_review.get(field)
            ):
                errors.append(f"{label}: review packet {field} gate differs from asset")
        if (
            isinstance(gates.get("rights"), dict)
            and gates["rights"].get("status") != asset.get("rights", {}).get("status")
        ):
            errors.append(f"{label}: review packet rights gate differs from asset")

    matrix = packet.get("render_matrix")
    if not isinstance(matrix, dict) or not matrix:
        errors.append(f"{label}: review packet render_matrix must be a non-empty object")
    elif any(
        state not in {"pending", "technical_pass", "approved", "rejected", "not_applicable"}
        for state in matrix.values()
    ):
        errors.append(f"{label}: review packet render_matrix has an invalid state")

    if packet.get("release_eligible") is True:
        gates_approved = isinstance(gates, dict) and all(
            isinstance(gates.get(field), dict) and gates[field].get("status") == "approved"
            for field in (*APPROVAL_FIELDS, "rights")
        )
        matrix_approved = isinstance(matrix, dict) and bool(matrix) and all(
            state in {"approved", "not_applicable"} for state in matrix.values()
        )
        accessibility_approved = isinstance(packet_accessibility, dict) and all(
            packet_accessibility.get(field) == "approved"
            for field in ("construct_equivalence_status", "answer_leakage_status")
        )
        if not gates_approved or not matrix_approved or not accessibility_approved:
            errors.append(
                f"{label}: review packet release_eligible=true while gates remain open"
            )

    page_value = asset.get("review_page")
    if page_value is not None:
        if not isinstance(page_value, str):
            errors.append(f"{label}: review_page must be a string")
        else:
            try:
                page_path = safe_relative(package_dir, page_value, f"{label}.review_page")
                if not page_path.is_file():
                    errors.append(f"{label}: missing review page {page_value}")
            except ValueError as exc:
                errors.append(str(exc))
    return errors


def validate_release_candidate(
    manifest: dict,
    assets: list,
    package_dir: Path,
) -> tuple[list[str], bool]:
    """Validate a single-asset Production replacement authorization envelope."""
    errors: list[str] = []
    ready = True
    if len(assets) != 1 or not isinstance(assets[0], dict):
        return ["manifest: release_candidate requires exactly one asset"], False
    asset = assets[0]
    envelope = manifest.get("release_candidate")
    if not isinstance(envelope, dict):
        return ["manifest: release_candidate object is required"], False

    for field in (
        "release_candidate_id",
        "source_package_id",
        "release_class",
        "asset_id",
        "asset_sha256",
        "content_version_id",
        "target",
        "current_production_object",
        "proposed_object",
        "operational_gates",
        "rollback",
        "execution_status",
    ):
        if field not in envelope:
            errors.append(f"manifest: release_candidate missing {field}")
            ready = False

    if envelope.get("release_class") not in {"patch", "minor", "major", "emergency"}:
        errors.append("manifest: release_candidate.release_class is invalid")
    if envelope.get("release_candidate_id") != manifest.get("package_id"):
        errors.append("manifest: release_candidate_id must equal package_id")
    bindings = {
        "asset_id": asset.get("asset_id"),
        "asset_sha256": asset.get("sha256"),
        "content_version_id": asset.get("content_version_id"),
    }
    for field, expected in bindings.items():
        if envelope.get(field) != expected:
            errors.append(
                f"manifest: release_candidate.{field}={envelope.get(field)!r}; "
                f"expected {expected!r}"
            )

    reference_objects: dict[str, dict] = {}
    for reference_field in ("source_manifest", "release_config"):
        value = manifest.get(reference_field)
        if not isinstance(value, str):
            errors.append(f"manifest: {reference_field} is required for release_candidate")
            continue
        try:
            reference_path = safe_relative(package_dir, value, f"manifest.{reference_field}")
            if not reference_path.is_file():
                errors.append(f"manifest: missing {reference_field} {value}")
            else:
                reference_value = json.loads(reference_path.read_text(encoding="utf-8"))
                if not isinstance(reference_value, dict):
                    errors.append(f"manifest: {reference_field} must contain an object")
                else:
                    reference_objects[reference_field] = reference_value
        except (ValueError, OSError, json.JSONDecodeError) as exc:
            errors.append(str(exc))

    source_manifest = reference_objects.get("source_manifest")
    if source_manifest is not None:
        if envelope.get("source_package_id") != source_manifest.get("package_id"):
            errors.append("manifest: source_package_id differs from source manifest")
        source_matches = [
            candidate
            for candidate in source_manifest.get("assets", [])
            if isinstance(candidate, dict) and candidate.get("asset_id") == asset.get("asset_id")
        ]
        if len(source_matches) != 1:
            errors.append("manifest: release asset does not resolve uniquely in source manifest")
        elif any(
            source_matches[0].get(field) != asset.get(field)
            for field in ("sha256", "content_version_id", "file", "review_packet")
        ):
            errors.append("manifest: release asset drifted from source manifest")

    release_config = reference_objects.get("release_config")
    if release_config is not None:
        config_bindings = {
            "release_candidate_id": envelope.get("release_candidate_id"),
            "asset_id": asset.get("asset_id"),
            "release_class": envelope.get("release_class"),
            "target": envelope.get("target"),
            "current_production_object": envelope.get("current_production_object"),
            "operational_gates": envelope.get("operational_gates"),
            "rollback": envelope.get("rollback"),
            "execution_status": envelope.get("execution_status"),
        }
        for field, expected in config_bindings.items():
            if release_config.get(field) != expected:
                errors.append(f"manifest: release_candidate.{field} differs from release config")

    target = envelope.get("target")
    if not isinstance(target, dict):
        errors.append("manifest: release_candidate.target must be an object")
        ready = False
    else:
        for field in ("project_ref", "bucket_id", "object_path", "stimulus_image_path"):
            if not str(target.get(field, "")).strip():
                errors.append(f"manifest: release_candidate.target.{field} is required")
        object_path = str(target.get("object_path", ""))
        object_parts = Path(object_path).parts
        if Path(object_path).is_absolute() or ".." in object_parts or "://" in object_path:
            errors.append("manifest: release_candidate.target.object_path must be a safe object name")
        if target.get("stimulus_image_path") != target.get("object_path"):
            errors.append("manifest: target stimulus_image_path must equal Storage object_path")
        if (
            source_manifest is not None
            and source_manifest.get("live_state_project")
            and target.get("project_ref") != source_manifest.get("live_state_project")
        ):
            errors.append("manifest: target project_ref differs from source live-state project")

    current = envelope.get("current_production_object")
    if not isinstance(current, dict):
        errors.append("manifest: current_production_object must be an object")
        ready = False
    else:
        identity_status = current.get("identity_status")
        if identity_status not in {"pending", "verified", "rejected"}:
            errors.append("manifest: current object identity_status is invalid")
        if identity_status != "verified":
            ready = False
        current_sha = current.get("sha256")
        if current_sha is not None and not is_sha256(current_sha):
            errors.append("manifest: current object sha256 must be null or lowercase SHA-256")
        if identity_status == "verified" and not is_sha256(current_sha):
            errors.append("manifest: verified current object requires sha256")
        byte_length = current.get("observed_byte_length")
        if byte_length is not None and (
            not isinstance(byte_length, int) or isinstance(byte_length, bool) or byte_length <= 0
        ):
            errors.append("manifest: current object observed_byte_length must be positive")
        if not is_nonempty_string(current.get("observed_at")):
            errors.append("manifest: current object observed_at is required")
        backup_status = current.get("backup_status")
        if backup_status not in {"pending", "verified", "rejected"}:
            errors.append("manifest: current object backup_status is invalid")
        if backup_status != "verified":
            ready = False
        backup_ref = current.get("backup_artifact_ref")
        if backup_ref is not None and (
            not isinstance(backup_ref, str)
            or not backup_ref
            or "://" in backup_ref
        ):
            errors.append("manifest: backup_artifact_ref must be a private non-URL reference")
        if backup_status == "verified" and not backup_ref:
            errors.append("manifest: verified backup requires backup_artifact_ref")

    proposed = envelope.get("proposed_object")
    if not isinstance(proposed, dict):
        errors.append("manifest: proposed_object must be an object")
    else:
        proposed_bindings = {
            "sha256": asset.get("sha256"),
            "byte_length": (package_dir / asset.get("file", "")).stat().st_size
            if isinstance(asset.get("file"), str) and (package_dir / asset["file"]).is_file()
            else None,
            "pixel_width": asset.get("pixel_width"),
            "pixel_height": asset.get("pixel_height"),
        }
        for field, expected in proposed_bindings.items():
            if proposed.get(field) != expected:
                errors.append(
                    f"manifest: proposed_object.{field}={proposed.get(field)!r}; "
                    f"expected {expected!r}"
                )

    gates = envelope.get("operational_gates")
    if not isinstance(gates, dict):
        errors.append("manifest: operational_gates must be an object")
        ready = False
    else:
        missing = sorted(set(OPERATIONAL_GATES) - set(gates))
        extra = sorted(set(gates) - set(OPERATIONAL_GATES))
        if missing:
            errors.append(f"manifest: operational_gates missing {missing}")
        if extra:
            errors.append(f"manifest: operational_gates has unknown fields {extra}")
        for field in OPERATIONAL_GATES:
            gate = gates.get(field)
            if not isinstance(gate, dict) or gate.get("status") not in {
                "pending", "approved", "rejected", "not_applicable"
            }:
                errors.append(f"manifest: operational gate {field} is invalid")
                ready = False
            elif gate["status"] not in {"approved", "not_applicable"}:
                ready = False
            elif not is_nonempty_string(gate.get("evidence")):
                errors.append(
                    f"manifest: operational gate {field} requires evidence when closed"
                )
                ready = False

    rollback = envelope.get("rollback")
    if not isinstance(rollback, dict) or not str(rollback.get("plan", "")).strip():
        errors.append("manifest: rollback.plan is required")
        ready = False
    elif rollback.get("status") not in {"pending", "approved", "rejected"}:
        errors.append("manifest: rollback.status is invalid")
        ready = False
    elif rollback.get("status") != "approved":
        ready = False

    execution_status = envelope.get("execution_status")
    if execution_status not in {
        "not_started", "authorized", "executed", "rolled_back", "rejected"
    }:
        errors.append("manifest: release_candidate.execution_status is invalid")
        ready = False
    elif execution_status != "authorized":
        ready = False

    packet_value = asset.get("review_packet")
    if not isinstance(packet_value, str):
        errors.append("manifest: release-candidate asset requires review_packet")
        ready = False
    else:
        try:
            packet_path = safe_relative(package_dir, packet_value, "asset.review_packet")
            packet = json.loads(packet_path.read_text(encoding="utf-8"))
            if packet.get("release_eligible") is not True:
                ready = False
        except (ValueError, OSError, json.JSONDecodeError) as exc:
            errors.append(f"manifest: cannot read release review packet: {exc}")
            ready = False
    return errors, ready


def validate(manifest_path: Path, require_release_eligible: bool) -> list[str]:
    errors: list[str] = []
    package_dir = manifest_path.resolve().parent
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        return [f"manifest: {exc}"]

    for field in ("schema_version", "package_id", "status", "release_eligible", "assets"):
        if field not in manifest:
            errors.append(f"manifest: missing {field}")
    if manifest.get("status") not in {"draft", "proposed", "approved", "rejected", "superseded"}:
        errors.append("manifest: status must be draft, proposed, approved, rejected, or superseded")

    assets = manifest.get("assets")
    if not isinstance(assets, list) or not assets:
        errors.append("manifest: assets must be a non-empty array")
        return errors

    if require_release_eligible and manifest.get("release_eligible") is not True:
        errors.append("manifest: package is not release eligible")

    seen_ids: set[str] = set()
    seen_files: set[str] = set()
    all_approved = True
    release_candidate_ready = True

    for index, asset in enumerate(assets):
        label = f"assets[{index}]"
        if not isinstance(asset, dict):
            errors.append(f"{label}: must be an object")
            all_approved = False
            continue
        for field in (
            "asset_id",
            "role",
            "content_key",
            "file",
            "media_type",
            "sha256",
            "pixel_width",
            "pixel_height",
            "visual_purpose",
            "source",
            "rights",
            "accessibility",
            "review",
        ):
            if field not in asset:
                errors.append(f"{label}: missing {field}")

        asset_id = asset.get("asset_id")
        if not isinstance(asset_id, str) or not asset_id:
            errors.append(f"{label}: asset_id must be a non-empty string")
        elif asset_id in seen_ids:
            errors.append(f"{label}: duplicate asset_id {asset_id}")
        else:
            seen_ids.add(asset_id)

        if asset.get("role") == "question_stimulus" and not str(asset.get("content_key", "")).strip():
            errors.append(f"{label}: question_stimulus requires a non-empty content_key")
        if asset.get("role") == "question_stimulus":
            if not str(asset.get("content_version_id", "")).strip():
                errors.append(f"{label}: question_stimulus requires content_version_id")
            version_num = asset.get("content_version_num")
            if not isinstance(version_num, int) or isinstance(version_num, bool) or version_num <= 0:
                errors.append(f"{label}: question_stimulus requires a positive content_version_num")
            if asset.get("content_version_status") not in {
                "draft",
                "assigned",
                "changes_requested",
                "reviewed_approved",
                "reviewed_disapproved",
                "published",
                "retired",
            }:
                errors.append(f"{label}: question_stimulus has invalid content_version_status")

        file_value = asset.get("file")
        if not isinstance(file_value, str):
            errors.append(f"{label}: file must be a string")
            all_approved = False
            continue
        if file_value in seen_files:
            errors.append(f"{label}: duplicate file {file_value}")
        seen_files.add(file_value)

        try:
            image_path = safe_relative(package_dir, file_value, f"{label}.file")
        except ValueError as exc:
            errors.append(str(exc))
            all_approved = False
            continue
        if not image_path.is_file():
            errors.append(f"{label}: missing image {file_value}")
            all_approved = False
            continue
        if asset.get("media_type") != "image/png":
            errors.append(f"{label}: only image/png is supported by this validator")
        try:
            width, height = png_dimensions(image_path)
        except ValueError as exc:
            errors.append(f"{label}: {exc}")
        else:
            if asset.get("pixel_width") != width or asset.get("pixel_height") != height:
                errors.append(
                    f"{label}: dimensions are {width}x{height}, manifest says "
                    f"{asset.get('pixel_width')}x{asset.get('pixel_height')}"
                )
        actual_sha = sha256(image_path)
        if asset.get("sha256") != actual_sha:
            errors.append(f"{label}: sha256 mismatch; actual {actual_sha}")

        source = asset.get("source")
        if not isinstance(source, dict) or not isinstance(source.get("path"), str):
            errors.append(f"{label}: source.path must be present")
        else:
            try:
                source_path = safe_relative(package_dir, source["path"], f"{label}.source.path")
                if not source_path.is_file():
                    errors.append(f"{label}: missing source {source['path']}")
            except ValueError as exc:
                errors.append(str(exc))
            environment_value = source.get("environment_path")
            if environment_value is not None:
                if not isinstance(environment_value, str):
                    errors.append(f"{label}: source.environment_path must be a string")
                else:
                    try:
                        environment_path = safe_relative(
                            package_dir,
                            environment_value,
                            f"{label}.source.environment_path",
                        )
                        if not environment_path.is_file():
                            errors.append(
                                f"{label}: missing source environment {environment_value}"
                            )
                    except ValueError as exc:
                        errors.append(str(exc))

        accessibility = asset.get("accessibility")
        if not isinstance(accessibility, dict) or not str(accessibility.get("short_alt", "")).strip():
            errors.append(f"{label}: accessibility.short_alt is required")

        rights = asset.get("rights")
        if not isinstance(rights, dict) or rights.get("status") not in {"approved", "pending", "rejected"}:
            errors.append(f"{label}: rights.status must be approved, pending, or rejected")

        review = asset.get("review")
        if not isinstance(review, dict):
            errors.append(f"{label}: review must be an object")
            all_approved = False
        else:
            for review_field in APPROVAL_FIELDS:
                state = review.get(review_field)
                if state not in REVIEW_STATES:
                    errors.append(f"{label}: review.{review_field} has invalid state {state!r}")
                if state not in {"approved", "not_applicable"}:
                    all_approved = False
            rights_approved = isinstance(rights, dict) and rights.get("status") == "approved"
            if not rights_approved:
                all_approved = False

        errors.extend(validate_review_packet(package_dir, asset, label))

    package_kind = manifest.get("package_kind")
    if package_kind not in {None, "evidence_recovery", "release_candidate"}:
        errors.append("manifest: package_kind is invalid")
    if package_kind == "release_candidate":
        release_errors, release_candidate_ready = validate_release_candidate(
            manifest, assets, package_dir
        )
        errors.extend(release_errors)

    if manifest.get("release_eligible") is True and not all_approved:
        errors.append("manifest: release_eligible=true but one or more gates are not approved")
    if manifest.get("release_eligible") is True and not release_candidate_ready:
        errors.append("manifest: release_eligible=true but Production preconditions remain open")
    if manifest.get("release_eligible") is True and manifest.get("status") != "approved":
        errors.append("manifest: release_eligible=true requires status=approved")
    if manifest.get("status") == "approved" and manifest.get("release_eligible") is not True:
        errors.append("manifest: approved package must be release eligible")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--require-release-eligible", action="store_true")
    args = parser.parse_args()
    errors = validate(args.manifest, args.require_release_eligible)
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print(f"PASS: {args.manifest} is structurally valid")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
