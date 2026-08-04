#!/usr/bin/env python3
"""Extract one reviewed image asset into a deterministic proposed release manifest."""

from __future__ import annotations

import argparse
import copy
import json
import os
import sys
import tempfile
from pathlib import Path
from typing import Any, Optional

import validate_image_package


class ReleaseCandidateError(Exception):
    pass


def read_object(path: Path, label: str) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ReleaseCandidateError(f"{label}: {exc}") from exc
    if not isinstance(value, dict):
        raise ReleaseCandidateError(f"{label}: must be a JSON object")
    return value


def safe_package_relative(package_dir: Path, path: Path, label: str) -> str:
    try:
        return path.resolve().relative_to(package_dir.resolve()).as_posix()
    except ValueError as exc:
        raise ReleaseCandidateError(f"{label} must be inside the image package") from exc


def one_asset(source: dict[str, Any], asset_id: str) -> dict[str, Any]:
    matches = [
        asset for asset in source.get("assets", [])
        if isinstance(asset, dict) and asset.get("asset_id") == asset_id
    ]
    if len(matches) != 1:
        raise ReleaseCandidateError(
            f"expected exactly one source asset {asset_id!r}; found {len(matches)}"
        )
    return matches[0]


def build_manifest(
    source_path: Path,
    config_path: Path,
    output_path: Path,
) -> dict[str, Any]:
    package_dir = source_path.resolve().parent
    if output_path.resolve().parent != package_dir:
        raise ReleaseCandidateError(
            "output must be in the source package root so governed relative paths remain stable"
        )

    source_errors = validate_image_package.validate(source_path, False)
    if source_errors:
        raise ReleaseCandidateError(
            "source manifest is invalid: " + "; ".join(source_errors)
        )
    source = read_object(source_path, "source manifest")
    config = read_object(config_path, "release config")
    asset_id = config.get("asset_id")
    if not isinstance(asset_id, str) or not asset_id:
        raise ReleaseCandidateError("release config asset_id is required")
    asset = copy.deepcopy(one_asset(source, asset_id))

    expected = config.get("expected_source")
    if not isinstance(expected, dict):
        raise ReleaseCandidateError("release config expected_source is required")
    bindings = {
        "package_id": source.get("package_id"),
        "asset_sha256": asset.get("sha256"),
        "content_version_id": asset.get("content_version_id"),
    }
    for field, actual in bindings.items():
        if expected.get(field) != actual:
            raise ReleaseCandidateError(
                f"expected_source.{field}={expected.get(field)!r}; actual {actual!r}"
            )

    if asset.get("content_version_status") != "published":
        raise ReleaseCandidateError("release candidate must target a published content version")
    if any(state == "rejected" for state in asset.get("review", {}).values()):
        raise ReleaseCandidateError("source asset has a rejected review gate")
    if asset.get("rights", {}).get("status") == "rejected":
        raise ReleaseCandidateError("source asset has rejected rights state")
    if asset.get("accessibility", {}).get("answer_leakage_status") == "rejected":
        raise ReleaseCandidateError("source asset has rejected answer-leakage state")

    required_config = (
        "schema_version",
        "release_candidate_id",
        "prepared_at",
        "release_class",
        "target",
        "current_production_object",
        "operational_gates",
        "rollback",
        "execution_status",
    )
    missing = [field for field in required_config if field not in config]
    if missing:
        raise ReleaseCandidateError(f"release config missing {missing}")

    image_path = (package_dir / asset["file"]).resolve()
    manifest = {
        "schema_version": "1.1.0",
        "package_kind": "release_candidate",
        "package_id": config["release_candidate_id"],
        "status": "proposed",
        "release_eligible": False,
        "prepared_at": config["prepared_at"],
        "source_manifest": safe_package_relative(
            package_dir, source_path, "source manifest"
        ),
        "release_config": safe_package_relative(
            package_dir, config_path, "release config"
        ),
        "assets": [asset],
        "release_candidate": {
            "release_candidate_id": config["release_candidate_id"],
            "source_package_id": source["package_id"],
            "release_class": config["release_class"],
            "asset_id": asset["asset_id"],
            "asset_sha256": asset["sha256"],
            "content_version_id": asset["content_version_id"],
            "target": config["target"],
            "current_production_object": config["current_production_object"],
            "proposed_object": {
                "sha256": asset["sha256"],
                "byte_length": image_path.stat().st_size,
                "pixel_width": asset["pixel_width"],
                "pixel_height": asset["pixel_height"],
            },
            "operational_gates": config["operational_gates"],
            "rollback": config["rollback"],
            "execution_status": config["execution_status"],
        },
    }
    return manifest


def write_validated(manifest: dict[str, Any], output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    temp_path: Optional[Path] = None
    try:
        with tempfile.NamedTemporaryFile(
            "w",
            encoding="utf-8",
            dir=output_path.parent,
            prefix=f".{output_path.name}.",
            suffix=".tmp",
            delete=False,
        ) as handle:
            temp_path = Path(handle.name)
            json.dump(manifest, handle, indent=2, sort_keys=True)
            handle.write("\n")
        errors = validate_image_package.validate(temp_path, False)
        if errors:
            raise ReleaseCandidateError(
                "generated manifest failed validation: " + "; ".join(errors)
            )
        os.replace(temp_path, output_path)
        temp_path = None
    finally:
        if temp_path is not None and temp_path.exists():
            temp_path.unlink()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source_manifest", type=Path)
    parser.add_argument("release_config", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    try:
        source = args.source_manifest.resolve()
        config = args.release_config.resolve()
        output = args.output.resolve()
        manifest = build_manifest(source, config, output)
        write_validated(manifest, output)
    except (ReleaseCandidateError, OSError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    print(f"PASS: wrote proposed image release candidate to {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
