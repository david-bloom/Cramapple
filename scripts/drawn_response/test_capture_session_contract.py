#!/usr/bin/env python3
"""Regression tests for the offline capture-session state contract."""

from __future__ import annotations

import contextlib
import copy
import io
import json
import tempfile
import unittest
from pathlib import Path
from typing import Any

import validate_records


FIXTURE_DIR = Path(__file__).resolve().parent / "fixtures"


def read_jsonl(path: Path) -> list[dict[str, Any]]:
    return [
        json.loads(line)
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]


class CaptureSessionContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.valid_events = read_jsonl(FIXTURE_DIR / "capture_session_events.valid.jsonl")
        cls.valid_images = read_jsonl(FIXTURE_DIR / "capture_session_images.valid.jsonl")
        cls.invalid_events = read_jsonl(FIXTURE_DIR / "capture_session_events.invalid.jsonl")
        cls.schema = validate_records.load_schema("capture_session_event")

    def validate(
        self,
        events: list[dict[str, Any]],
        images: list[dict[str, Any]],
        require_terminal: bool = True,
    ) -> tuple[int, str]:
        with tempfile.TemporaryDirectory(prefix="cramapple-capture-session-test-") as temp:
            root = Path(temp)
            event_path = root / "events.jsonl"
            image_path = root / "images.jsonl"
            event_path.write_text(
                "".join(json.dumps(row, separators=(",", ":")) + "\n" for row in events),
                encoding="utf-8",
            )
            image_path.write_text(
                "".join(json.dumps(row, separators=(",", ":")) + "\n" for row in images),
                encoding="utf-8",
            )
            output = io.StringIO()
            with contextlib.redirect_stdout(output):
                errors = validate_records.validate_file(
                    event_path,
                    self.schema,
                    image_path,
                    require_session_terminal=require_terminal,
                )
            return errors, output.getvalue()

    def test_valid_lifecycle(self) -> None:
        errors, output = self.validate(self.valid_events, self.valid_images)
        self.assertEqual(errors, 0, output)

    def test_submission_without_quality_or_review_is_rejected(self) -> None:
        errors, output = self.validate(self.invalid_events, self.valid_images)
        self.assertGreater(errors, 0)
        self.assertIn("submission requires ACCEPTABLE capture quality", output)

    def test_exact_item_version_drift_is_rejected(self) -> None:
        images = copy.deepcopy(self.valid_images)
        images[0]["content_item_version_id"] = "item-version-drift"
        errors, output = self.validate(self.valid_events, images)
        self.assertGreater(errors, 0)
        self.assertIn("response/item/version binding differs", output)

    def test_raw_pairing_handle_is_rejected(self) -> None:
        events = copy.deepcopy(self.valid_events)
        events[0]["pairing"]["handle_sha256"] = "raw-secret-token"
        errors, output = self.validate(events, self.valid_images)
        self.assertGreater(errors, 0)
        self.assertIn("handle_sha256", output)

    def test_physical_append_order_is_enforced(self) -> None:
        events = copy.deepcopy(self.valid_events)
        events[3], events[4] = events[4], events[3]
        errors, output = self.validate(events, self.valid_images)
        self.assertGreater(errors, 0)
        self.assertIn("not appended in strictly increasing sequence order", output)

    def test_expiry_is_noninclusive(self) -> None:
        events = copy.deepcopy(self.valid_events)
        events[1]["occurred_at"] = events[0]["pairing"]["expires_at"]
        errors, output = self.validate(events, self.valid_images)
        self.assertGreater(errors, 0)
        self.assertIn("expired pairing handle cannot be accepted", output)

    def test_pending_consent_is_rejected_for_workflow_use(self) -> None:
        images = copy.deepcopy(self.valid_images)
        images[0]["consent_status"] = "PENDING"
        errors, output = self.validate(self.valid_events, images)
        self.assertGreater(errors, 0)
        self.assertIn("consent is not eligible", output)

    def test_active_partial_stream_can_be_validated_explicitly(self) -> None:
        errors, output = self.validate(
            self.valid_events[:4], self.valid_images, require_terminal=False
        )
        self.assertEqual(errors, 0, output)

    def test_invalid_calendar_date_is_reported_not_crashed(self) -> None:
        events = copy.deepcopy(self.valid_events)
        events[1]["occurred_at"] = "2026-99-03T10:00:10Z"
        errors, output = self.validate(events, self.valid_images)
        self.assertGreater(errors, 0)
        self.assertIn("invalid calendar date-time", output)

    def test_submission_slot_cannot_bind_two_sessions(self) -> None:
        events = copy.deepcopy(self.valid_events)
        for event in events:
            if event["capture_session_id"] == "capture-session-b":
                event["binding"]["submission_slot_id"] = "slot-001"
        errors, output = self.validate(events, self.valid_images)
        self.assertGreater(errors, 0)
        self.assertIn("submission slot is already bound", output)


if __name__ == "__main__":
    unittest.main()
