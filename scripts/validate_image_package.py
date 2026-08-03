#!/usr/bin/env python3
"""Validate a Cramapple image-package manifest with no third-party dependencies."""

from __future__ import annotations

import argparse
import hashlib
import json
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


def safe_relative(package_dir: Path, value: str, field: str) -> Path:
    candidate = Path(value)
    if candidate.is_absolute() or ".." in candidate.parts:
        raise ValueError(f"{field} must be a package-relative path")
    resolved = (package_dir / candidate).resolve()
    if package_dir.resolve() not in resolved.parents and resolved != package_dir.resolve():
        raise ValueError(f"{field} escapes the package directory")
    return resolved


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

    if manifest.get("release_eligible") is True and not all_approved:
        errors.append("manifest: release_eligible=true but one or more gates are not approved")
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
