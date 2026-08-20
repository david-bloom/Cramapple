#!/usr/bin/env python3
"""Regression tests for the TASK-0016 Phase D Stage D1 spatial contracts.

Covers three things, matching the Stage D1 spec's "Add schema tests,
citation-integrity tests, and adversarial fixtures" requirement:

1. Schema tests: every *.valid.jsonl fixture validates cleanly against its
   record type's v1 schema, and a hand-corrupted record (wrong enum value,
   missing required field, wrong contract_version) is rejected.
2. Citation-integrity tests: the valid fixture chain (visual_observation
   -> criterion_decision -> confidence_and_abstention -> feedback) has zero
   citation-integrity errors end to end.
3. Adversarial fail-closed tests: each adversarial_*.jsonl fixture -- a
   criterion decision citing a missing observation, an abstention result
   citing a missing criterion decision, a release decision with no measured
   calibration evidence, and feedback citing missing/contradictory records
   -- is proven to fail (never silently accepted).
"""

from __future__ import annotations

import copy
import unittest
from pathlib import Path

import validate_phase_d_spatial_contracts as contracts

FIXTURE_DIR = contracts.FIXTURE_DIR


class SchemaValidationTests(unittest.TestCase):
    """Each valid fixture must pass; a corrupted copy of it must fail."""

    def test_all_valid_fixtures_pass_schema_validation(self) -> None:
        for record_type in contracts.RECORD_TYPES:
            filename = f"{record_type}.valid.jsonl"
            if not (FIXTURE_DIR / filename).exists():
                continue
            with self.subTest(record_type=record_type):
                errors = contracts.validate_fixture_file(record_type, filename)
                self.assertEqual(errors, [], f"{filename} should validate cleanly: {errors}")

    def test_wrong_contract_version_is_rejected(self) -> None:
        schema = contracts.load_schema("criterion_decision_result")
        records = contracts.read_jsonl(FIXTURE_DIR / "criterion_decision_result.valid.jsonl")
        bad = copy.deepcopy(records[0])
        bad["contract_version"] = "v0-does-not-exist"
        with self.assertRaises(contracts.ValidationError):
            contracts.validate_record(bad, schema)

    def test_missing_required_field_is_rejected(self) -> None:
        schema = contracts.load_schema("criterion_decision_result")
        records = contracts.read_jsonl(FIXTURE_DIR / "criterion_decision_result.valid.jsonl")
        bad = copy.deepcopy(records[0])
        del bad["rubric_contract"]
        with self.assertRaises(contracts.ValidationError):
            contracts.validate_record(bad, schema)

    def test_invalid_enum_value_is_rejected(self) -> None:
        schema = contracts.load_schema("criterion_decision_result")
        records = contracts.read_jsonl(FIXTURE_DIR / "criterion_decision_result.valid.jsonl")
        bad = copy.deepcopy(records[0])
        bad["status"] = "MET"  # pre-v1 vocabulary; v1 requires earned/not_earned/...
        with self.assertRaises(contracts.ValidationError):
            contracts.validate_record(bad, schema)

    def test_self_reported_confidence_alone_cannot_be_a_release_control(self) -> None:
        """confidence is a valid low/medium/high enum on criterion_decision_result,
        but nothing about that field can be read as a release gate -- only
        confidence_and_abstention_result.decision can. This is a schema-shape
        assertion: the two fields live on entirely separate record types."""
        cd_schema = contracts.load_schema("criterion_decision_result")
        self.assertIn("confidence", cd_schema["properties"])
        self.assertNotIn("decision", cd_schema["properties"])
        car_schema = contracts.load_schema("confidence_and_abstention_result")
        self.assertIn("decision", car_schema["properties"])


class CitationIntegrityTests(unittest.TestCase):
    def setUp(self) -> None:
        self.observations = contracts.read_jsonl(
            FIXTURE_DIR / "visual_observation_result.valid.jsonl"
        )
        self.criterion_decisions = contracts.read_jsonl(
            FIXTURE_DIR / "criterion_decision_result.valid.jsonl"
        )
        self.confidence_results = contracts.read_jsonl(
            FIXTURE_DIR / "confidence_and_abstention_result.valid.jsonl"
        )
        self.feedback_results = contracts.read_jsonl(FIXTURE_DIR / "feedback_result.valid.jsonl")

    def test_valid_chain_has_no_citation_errors(self) -> None:
        errors = contracts.check_citation_integrity(
            self.observations,
            self.criterion_decisions,
            self.confidence_results,
            self.feedback_results,
        )
        self.assertEqual(errors, [])

    def _load_adversarial(self, filename: str) -> list[dict]:
        return contracts.read_jsonl(FIXTURE_DIR / filename)

    def test_criterion_decision_citing_missing_observation_fails_closed(self) -> None:
        bad_decisions = self._load_adversarial(
            "criterion_decision_result.adversarial_missing_observation.jsonl"
        )
        errors = contracts.check_citation_integrity(
            self.observations,
            self.criterion_decisions + bad_decisions,
            self.confidence_results,
            self.feedback_results,
        )
        self.assertTrue(errors, "a decision citing a missing observation must fail closed")
        self.assertTrue(any("missing observation_id" in e for e in errors))

    def test_abstention_citing_missing_criterion_decision_fails_closed(self) -> None:
        bad_cars = self._load_adversarial(
            "confidence_and_abstention_result.adversarial_missing_criterion.jsonl"
        )
        errors = contracts.check_citation_integrity(
            self.observations,
            self.criterion_decisions,
            self.confidence_results + bad_cars,
            self.feedback_results,
        )
        self.assertTrue(errors)
        self.assertTrue(any("missing criterion_decision_id" in e for e in errors))

    def test_release_decision_without_measured_calibration_fails_closed(self) -> None:
        bad_cars = self._load_adversarial(
            "confidence_and_abstention_result.adversarial_unfalsifiable_release.jsonl"
        )
        errors = contracts.check_citation_integrity(
            self.observations,
            self.criterion_decisions,
            self.confidence_results + bad_cars,
            self.feedback_results,
        )
        self.assertTrue(errors, "RELEASE_AUTOMATED with no measured evidence must fail closed")
        self.assertTrue(any("without measured calibration evidence" in e for e in errors))

    def test_feedback_citing_missing_criterion_decision_fails_closed(self) -> None:
        bad_feedback = self._load_adversarial(
            "feedback_result.adversarial_missing_criterion.jsonl"
        )
        errors = contracts.check_citation_integrity(
            self.observations,
            self.criterion_decisions,
            self.confidence_results,
            self.feedback_results + bad_feedback,
        )
        self.assertTrue(errors)

    def test_feedback_citing_missing_abstention_result_fails_closed(self) -> None:
        bad_feedback = self._load_adversarial(
            "feedback_result.adversarial_missing_abstention.jsonl"
        )
        errors = contracts.check_citation_integrity(
            self.observations,
            self.criterion_decisions,
            self.confidence_results,
            self.feedback_results + bad_feedback,
        )
        self.assertTrue(errors)

    def test_feedback_release_status_contradicting_abstention_fails_closed(self) -> None:
        bad_feedback = self._load_adversarial(
            "feedback_result.adversarial_release_status_mismatch.jsonl"
        )
        errors = contracts.check_citation_integrity(
            self.observations,
            self.criterion_decisions,
            self.confidence_results,
            self.feedback_results + bad_feedback,
        )
        self.assertTrue(
            errors, "RELEASED_TO_LEARNER citing a non-RELEASE_AUTOMATED abstention must fail"
        )


class EndToEndCLITests(unittest.TestCase):
    def test_main_returns_zero_on_the_committed_fixture_set(self) -> None:
        self.assertEqual(contracts.main(), 0)


if __name__ == "__main__":
    unittest.main()
