#!/usr/bin/env python3
"""Regression tests for deterministic single-image release candidates."""

from __future__ import annotations

import json
import shutil
import tempfile
import unittest
from pathlib import Path
from typing import Any

import prepare_image_release_candidate
import validate_image_package


REPO_ROOT = Path(__file__).resolve().parent.parent
PACKAGE_SOURCE = (
    REPO_ROOT / "docs/research/ap_biology_stimulus_images_2026_07_12"
)
SOURCE_NAME = "manifest.json"
CONFIG_NAME = "release_candidates/APBIO-FRQ-S-009-v3-release-config.json"
OUTPUT_NAME = "APBIO-FRQ-S-009-v3-release-manifest.json"


class ImageReleaseCandidateTests(unittest.TestCase):
    def package_copy(self, temp_root: Path) -> Path:
        destination = temp_root / "package"
        shutil.copytree(PACKAGE_SOURCE, destination)
        return destination

    def load_config(self, package: Path) -> dict[str, Any]:
        return json.loads((package / CONFIG_NAME).read_text(encoding="utf-8"))

    def write_config(self, package: Path, config: dict[str, Any]) -> Path:
        path = package / CONFIG_NAME
        path.write_text(json.dumps(config, indent=2) + "\n", encoding="utf-8")
        return path

    def build(self, package: Path) -> Path:
        source = package / SOURCE_NAME
        config = package / CONFIG_NAME
        output = package / OUTPUT_NAME
        manifest = prepare_image_release_candidate.build_manifest(
            source, config, output
        )
        prepare_image_release_candidate.write_validated(manifest, output)
        return output

    def test_proposed_candidate_is_valid_and_single_asset(self) -> None:
        with tempfile.TemporaryDirectory(prefix="cramapple-image-release-test-") as temp:
            package = self.package_copy(Path(temp))
            output = self.build(package)
            manifest = json.loads(output.read_text(encoding="utf-8"))
            self.assertEqual(validate_image_package.validate(output, False), [])
            self.assertEqual(len(manifest["assets"]), 1)
            self.assertEqual(
                manifest["assets"][0]["asset_id"],
                "apbio-frq-s-009-stimulus-v3-candidate",
            )

    def test_generation_is_byte_deterministic(self) -> None:
        with tempfile.TemporaryDirectory(prefix="cramapple-image-release-test-") as temp:
            package = self.package_copy(Path(temp))
            output = self.build(package)
            first = output.read_bytes()
            self.build(package)
            self.assertEqual(first, output.read_bytes())

    def test_expected_source_drift_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory(prefix="cramapple-image-release-test-") as temp:
            package = self.package_copy(Path(temp))
            config = self.load_config(package)
            config["expected_source"]["asset_sha256"] = "0" * 64
            config_path = self.write_config(package, config)
            with self.assertRaisesRegex(
                prepare_image_release_candidate.ReleaseCandidateError,
                "expected_source.asset_sha256",
            ):
                prepare_image_release_candidate.build_manifest(
                    package / SOURCE_NAME, config_path, package / OUTPUT_NAME
                )

    def test_rejected_v2_asset_cannot_be_extracted(self) -> None:
        with tempfile.TemporaryDirectory(prefix="cramapple-image-release-test-") as temp:
            package = self.package_copy(Path(temp))
            config = self.load_config(package)
            config["asset_id"] = "apbio-frq-s-009-stimulus-v2-candidate"
            config["expected_source"]["asset_sha256"] = (
                "d32435dc2eb8415dfe4c837df1952ef5d57e289310a43e8820ee2a51e4af4020"
            )
            config_path = self.write_config(package, config)
            with self.assertRaisesRegex(
                prepare_image_release_candidate.ReleaseCandidateError,
                "rejected review gate",
            ):
                prepare_image_release_candidate.build_manifest(
                    package / SOURCE_NAME, config_path, package / OUTPUT_NAME
                )

    def test_unsafe_storage_target_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory(prefix="cramapple-image-release-test-") as temp:
            package = self.package_copy(Path(temp))
            config = self.load_config(package)
            config["target"]["object_path"] = "../escape.png"
            config["target"]["stimulus_image_path"] = "../escape.png"
            config_path = self.write_config(package, config)
            manifest = prepare_image_release_candidate.build_manifest(
                package / SOURCE_NAME, config_path, package / OUTPUT_NAME
            )
            with self.assertRaisesRegex(
                prepare_image_release_candidate.ReleaseCandidateError,
                "safe object name",
            ):
                prepare_image_release_candidate.write_validated(
                    manifest, package / OUTPUT_NAME
                )

    def test_pending_human_and_production_gates_block_release(self) -> None:
        with tempfile.TemporaryDirectory(prefix="cramapple-image-release-test-") as temp:
            package = self.package_copy(Path(temp))
            output = self.build(package)
            manifest = json.loads(output.read_text(encoding="utf-8"))
            manifest["status"] = "approved"
            manifest["release_eligible"] = True
            release_path = package / "forced-release.json"
            release_path.write_text(
                json.dumps(manifest, indent=2) + "\n", encoding="utf-8"
            )
            errors = validate_image_package.validate(release_path, True)
            self.assertTrue(
                any("review" in error or "gates" in error for error in errors), errors
            )
            self.assertTrue(
                any("Production preconditions" in error for error in errors), errors
            )

    def test_post_generation_config_drift_is_detected(self) -> None:
        with tempfile.TemporaryDirectory(prefix="cramapple-image-release-test-") as temp:
            package = self.package_copy(Path(temp))
            output = self.build(package)
            config = self.load_config(package)
            config["target"]["bucket_id"] = "different-bucket"
            self.write_config(package, config)
            errors = validate_image_package.validate(output, False)
            self.assertTrue(
                any("target differs from release config" in error for error in errors),
                errors,
            )

    def test_closed_operational_gate_requires_evidence(self) -> None:
        with tempfile.TemporaryDirectory(prefix="cramapple-image-release-test-") as temp:
            package = self.package_copy(Path(temp))
            output = self.build(package)
            config = self.load_config(package)
            config["operational_gates"]["database_binding"]["evidence"] = None
            self.write_config(package, config)
            manifest = json.loads(output.read_text(encoding="utf-8"))
            manifest["release_candidate"]["operational_gates"]["database_binding"][
                "evidence"
            ] = None
            output.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
            errors = validate_image_package.validate(output, False)
            self.assertTrue(
                any(
                    "operational gate database_binding requires evidence" in error
                    for error in errors
                ),
                errors,
            )

    def test_approved_review_gate_requires_attribution(self) -> None:
        with tempfile.TemporaryDirectory(prefix="cramapple-image-release-test-") as temp:
            package = self.package_copy(Path(temp))
            output = self.build(package)
            manifest = json.loads(output.read_text(encoding="utf-8"))
            packet_path = package / manifest["assets"][0]["review_packet"]
            packet = json.loads(packet_path.read_text(encoding="utf-8"))
            packet["review_gates"]["scientific"] = {
                "status": "approved",
                "reviewer": None,
                "reviewed_at": None,
                "notes": "Approval without attribution must fail closed.",
            }
            packet_path.write_text(json.dumps(packet, indent=2) + "\n", encoding="utf-8")
            errors = validate_image_package.validate(output, False)
            self.assertTrue(
                any(
                    "approved scientific gate requires reviewer and reviewed_at" in error
                    for error in errors
                ),
                errors,
            )


if __name__ == "__main__":
    unittest.main()
