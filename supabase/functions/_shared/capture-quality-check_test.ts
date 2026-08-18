// Pins down the pure rollup/messaging logic behind Layer A of "explain why
// ungradable" (see the plan referenced in ACTIVITY_LOG.md and
// docs/research/DRAWN_RESPONSE_ANNOTATION_HANDBOOK.md section 3, which this
// mirrors). The network call in runCaptureQualityCheck is intentionally not
// exercised here -- these tests cover the deterministic decision logic a
// wrong vision-model call could otherwise mask.

import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  buildRetakeMessage,
  CAPTURE_QUALITY_LABELS,
  CAPTURE_QUALITY_MESSAGES,
  type CaptureQualityLabels,
  computeCaptureDisposition,
  mapDispositionToQualityState,
} from "./capture-quality-check.ts";

function allPass(): CaptureQualityLabels {
  return Object.fromEntries(
    CAPTURE_QUALITY_LABELS.map((label) => [label, "PASS" as const]),
  ) as CaptureQualityLabels;
}

Deno.test("computeCaptureDisposition: all PASS + identifier NONE is ACCEPT", () => {
  const { disposition, failingLabels } = computeCaptureDisposition(
    allPass(),
    "NONE",
  );
  assertEquals(disposition, "ACCEPT");
  assertEquals(failingLabels, []);
});

Deno.test("computeCaptureDisposition: one FAIL, rest PASS, identifier NONE is RETAKE", () => {
  const labels = { ...allPass(), FOCUS_LEGIBILITY: "FAIL" as const };
  const { disposition, failingLabels } = computeCaptureDisposition(
    labels,
    "NONE",
  );
  assertEquals(disposition, "RETAKE");
  assertEquals(failingLabels, ["FOCUS_LEGIBILITY"]);
});

Deno.test("computeCaptureDisposition: any UNCERTAIN label forces HUMAN_REVIEW even with a FAIL present", () => {
  const labels = {
    ...allPass(),
    FOCUS_LEGIBILITY: "FAIL" as const,
    GLARE_OCCLUSION: "UNCERTAIN" as const,
  };
  const { disposition } = computeCaptureDisposition(labels, "NONE");
  assertEquals(disposition, "HUMAN_REVIEW");
});

Deno.test("computeCaptureDisposition: PRESENT identifier forces HUMAN_REVIEW even when every label passes", () => {
  const { disposition } = computeCaptureDisposition(allPass(), "PRESENT");
  assertEquals(disposition, "HUMAN_REVIEW");
});

Deno.test("computeCaptureDisposition: UNCERTAIN identifier forces HUMAN_REVIEW", () => {
  const { disposition } = computeCaptureDisposition(allPass(), "UNCERTAIN");
  assertEquals(disposition, "HUMAN_REVIEW");
});

Deno.test("mapDispositionToQualityState covers all three dispositions", () => {
  assertEquals(mapDispositionToQualityState("ACCEPT"), "acceptable");
  assertEquals(mapDispositionToQualityState("RETAKE"), "retake_required");
  assertEquals(mapDispositionToQualityState("HUMAN_REVIEW"), "indeterminate");
});

Deno.test("every capture-quality label has a safe, curated retake message", () => {
  for (const label of CAPTURE_QUALITY_LABELS) {
    const message = CAPTURE_QUALITY_MESSAGES[label];
    assertEquals(typeof message, "string");
    if (message.length === 0) {
      throw new Error(`missing retake message for ${label}`);
    }
    // Guards against a future edit accidentally pulling content-judgment
    // language into a message that must only ever describe the photo.
    const lower = message.toLowerCase();
    for (const forbidden of ["correct", "wrong", "answer", "should be"]) {
      if (lower.includes(forbidden)) {
        throw new Error(
          `retake message for ${label} contains answer-adjacent word "${forbidden}": ${message}`,
        );
      }
    }
  }
});

Deno.test("buildRetakeMessage caps at two labels", () => {
  const message = buildRetakeMessage([
    "FOCUS_LEGIBILITY",
    "GLARE_OCCLUSION",
    "ORIENTATION_USABLE",
  ]);
  assertEquals(
    message,
    `${CAPTURE_QUALITY_MESSAGES.FOCUS_LEGIBILITY} ${CAPTURE_QUALITY_MESSAGES.GLARE_OCCLUSION}`,
  );
});

Deno.test("buildRetakeMessage on empty input is empty", () => {
  assertEquals(buildRetakeMessage([]), "");
});
