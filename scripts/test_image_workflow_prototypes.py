#!/usr/bin/env python3
"""Contract checks for the local question-image and hand-drawn UX renders."""

from __future__ import annotations

import hashlib
import json
import re
import unittest
from html.parser import HTMLParser
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Tuple


REPO_ROOT = Path(__file__).resolve().parent.parent
AUTHORING_PATH = REPO_ROOT / "prototypes/ux-003/index.html"
CAPTURE_PATH = REPO_ROOT / "prototypes/ux-008/index.html"
SESSION_SCHEMA_PATH = (
    REPO_ROOT / "scripts/drawn_response/schemas/capture_session_event.schema.json"
)
EXPECTED_IMAGE_SHA256 = (
    "85c146a2fcf494656635fa32acc7a4d4a050ec6566e71942adcc2f174d1361ea"
)
EXPECTED_VERSION_ID = "de59d53c-1f80-4b1a-9694-10d9e50dcad0"
VOID_TAGS = {
    "area", "base", "br", "col", "embed", "hr", "img", "input", "link",
    "meta", "param", "source", "track", "wbr",
}


class Node:
    def __init__(
        self,
        tag: str,
        attrs: Iterable[Tuple[str, Optional[str]]],
        parent: Optional["Node"] = None,
    ) -> None:
        self.tag = tag
        self.attrs: Dict[str, str] = {
            key: "" if value is None else value for key, value in attrs
        }
        self.parent = parent
        self.children: List["Node"] = []
        self.text: List[str] = []

    def descendants(self, tag: Optional[str] = None) -> Iterable["Node"]:
        for child in self.children:
            if tag is None or child.tag == tag:
                yield child
            yield from child.descendants(tag)

    def text_content(self) -> str:
        pieces = list(self.text)
        for child in self.children:
            pieces.append(child.text_content())
        return " ".join(" ".join(pieces).split())


class DocumentParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.root = Node("document", [])
        self.stack = [self.root]
        self.ids: Dict[str, List[Node]] = {}

    def handle_starttag(
        self, tag: str, attrs: List[Tuple[str, Optional[str]]]
    ) -> None:
        node = Node(tag, attrs, self.stack[-1])
        self.stack[-1].children.append(node)
        if node.attrs.get("id"):
            self.ids.setdefault(node.attrs["id"], []).append(node)
        if tag not in VOID_TAGS:
            self.stack.append(node)

    def handle_startendtag(
        self, tag: str, attrs: List[Tuple[str, Optional[str]]]
    ) -> None:
        self.handle_starttag(tag, attrs)
        if tag not in VOID_TAGS:
            self.stack.pop()

    def handle_endtag(self, tag: str) -> None:
        for index in range(len(self.stack) - 1, 0, -1):
            if self.stack[index].tag == tag:
                del self.stack[index:]
                return

    def handle_data(self, data: str) -> None:
        self.stack[-1].text.append(data)

    def one(self, node_id: str) -> Node:
        matches = self.ids.get(node_id, [])
        if len(matches) != 1:
            raise AssertionError(f"expected one #{node_id}; found {len(matches)}")
        return matches[0]


def parse(path: Path) -> Tuple[str, DocumentParser]:
    source = path.read_text(encoding="utf-8")
    parser = DocumentParser()
    parser.feed(source)
    parser.close()
    return source, parser


class ImageWorkflowPrototypeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.authoring_source, cls.authoring = parse(AUTHORING_PATH)
        cls.capture_source, cls.capture = parse(CAPTURE_PATH)

    def test_authoring_image_binding_matches_exact_candidate(self) -> None:
        image = self.authoring.one("stimulus-image")
        image_path = (AUTHORING_PATH.parent / image.attrs["src"]).resolve()
        self.assertTrue(image_path.is_file(), image_path)
        self.assertEqual(
            hashlib.sha256(image_path.read_bytes()).hexdigest(),
            EXPECTED_IMAGE_SHA256,
        )
        self.assertEqual(image.attrs.get("width"), "1192")
        self.assertEqual(image.attrs.get("height"), "774")
        self.assertEqual(image.attrs.get("data-content-version-id"), EXPECTED_VERSION_ID)
        self.assertEqual(image.attrs.get("data-sha256"), EXPECTED_IMAGE_SHA256)

    def test_authoring_visual_has_equivalent_text_and_fail_closed_state(self) -> None:
        image = self.authoring.one("stimulus-image")
        self.assertGreater(len(image.attrs.get("alt", "").strip()), 40)
        missing = self.authoring.one("stimulus-missing")
        self.assertEqual(missing.attrs.get("role"), "alert")
        self.assertIn("cannot be submitted", missing.text_content())
        self.assertIn("Image unavailable · submission is blocked", self.authoring_source)
        self.assertIn("function openSubmitModal()", self.authoring_source)
        self.assertIn("Restore or replace the required visual before submission", self.authoring_source)
        self.assertIn("Required visual is missing · candidate submission blocked", self.authoring_source)

    def test_authoring_records_purpose_provenance_rights_and_leakage(self) -> None:
        stimulus = next(
            node
            for node in self.authoring.root.descendants("section")
            if node.attrs.get("data-section") == "stimulus"
        )
        text = stimulus.text_content()
        for phrase in (
            "Question stimulus",
            "Model analysis",
            "deterministic schematic",
            "Rights state",
            "Answer leakage",
            "exact content version",
        ):
            self.assertIn(phrase, text)

    def test_authoring_prototype_does_not_read_or_upload_files(self) -> None:
        file_inputs = [
            node
            for node in self.authoring.root.descendants("input")
            if node.attrs.get("type", "text").lower() == "file"
        ]
        self.assertEqual(file_inputs, [])
        self.assertIn("does not read or upload a file", self.authoring_source)
        for forbidden in ("fetch(", "XMLHttpRequest", "WebSocket", "getUserMedia"):
            self.assertNotIn(forbidden, self.authoring_source)

    def test_capture_render_declares_and_enforces_research_boundary(self) -> None:
        self.assertIn("Research UX · No file is uploaded", self.capture_source)
        file_inputs = [
            node
            for node in self.capture.root.descendants("input")
            if node.attrs.get("type", "text").lower() == "file"
        ]
        self.assertEqual(file_inputs, [])
        for forbidden in (
            "fetch(", "XMLHttpRequest", "WebSocket", "getUserMedia",
            "mediaDevices", "localStorage", "sessionStorage",
        ):
            self.assertNotIn(forbidden, self.capture_source)

    def test_capture_render_contains_required_recovery_states(self) -> None:
        required = {
            "connected", "permission", "camera", "review", "quality-ready",
            "quality-retake", "quality-uncertain", "confirm", "submitted",
            "expired", "alternative",
        }
        screens = {
            node.attrs["data-phone"]
            for node in self.capture.root.descendants("section")
            if "data-phone" in node.attrs
        }
        self.assertTrue(required.issubset(screens), sorted(required - screens))
        scenario = self.capture.one("scenario")
        options = {node.attrs.get("value") for node in scenario.descendants("option")}
        self.assertTrue(required.issubset(options), sorted(required - options))

    def test_capture_submission_is_explicit_and_separate_from_capture(self) -> None:
        confirmation = self.capture.one("submit-confirmation")
        submit = self.capture.one("submit-graph")
        self.assertEqual(confirmation.attrs.get("type"), "checkbox")
        self.assertIn("disabled", submit.attrs)
        self.assertIn("Taking a photo did not submit it", self.capture_source)
        self.assertIn('render("submitted", "SUBMISSION_ACCEPTED")', self.capture_source)

    def test_capture_quality_is_not_correctness_and_fixable_defect_blocks(self) -> None:
        ready = next(
            node
            for node in self.capture.root.descendants("section")
            if node.attrs.get("data-phone") == "quality-ready"
        )
        retake = next(
            node
            for node in self.capture.root.descendants("section")
            if node.attrs.get("data-phone") == "quality-retake"
        )
        self.assertIn("not whether the graph is correct", ready.text_content())
        self.assertIn("cannot be submitted", retake.text_content())
        retake_targets = {
            button.attrs.get("data-go") for button in retake.descendants("button")
        }
        self.assertNotIn("confirm", retake_targets)
        self.assertNotIn("submitted", retake_targets)

    def test_capture_events_use_only_the_append_only_contract(self) -> None:
        schema = json.loads(SESSION_SCHEMA_PATH.read_text(encoding="utf-8"))
        allowed = set(schema["properties"]["event_type"]["enum"])
        rendered = set(re.findall(r'data-event="([A-Z_]+)"', self.capture_source))
        rendered.update(re.findall(r'render\("submitted", "([A-Z_]+)"\)', self.capture_source))
        self.assertTrue(rendered)
        self.assertEqual(rendered - allowed, set())
        for required in (
            "SESSION_CREATED", "PAIRING_ACCEPTED", "CAPTURE_RECORDED",
            "QUALITY_RECORDED", "RETAKE_REQUESTED", "CAPTURE_REMOVED",
            "SUBMISSION_ACCEPTED", "SESSION_CANCELLED",
        ):
            self.assertIn(required, rendered)

    def test_both_prototypes_have_unique_ids_and_native_action_controls(self) -> None:
        for name, parser in (
            ("authoring", self.authoring),
            ("capture", self.capture),
        ):
            duplicates = sorted(node_id for node_id, nodes in parser.ids.items() if len(nodes) > 1)
            self.assertEqual(duplicates, [], f"{name} duplicate ids")
            self.assertGreater(len(list(parser.root.descendants("button"))), 0)
        alternative = next(
            node
            for node in self.capture.root.descendants("section")
            if node.attrs.get("data-phone") == "alternative"
        )
        for phrase in (
            "manual pairing code", "no-crop submission", "keyboard image controls",
            "preserves the assessed construct",
        ):
            self.assertIn(phrase, alternative.text_content())


if __name__ == "__main__":
    unittest.main()
