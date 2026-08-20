// TASK-0016 Phase D, Stage D2: capture-quality check.
//
// This file replaces the 6-test suite that shipped and was reverted with
// commit 52efaef/d0b6fef on 2026-08-18. It keeps that suite's coverage of
// the pure disposition rollup and adds the cases the reverted version had
// no way to express, because the reverted version could not tell an
// image-quality failure from a broken checker:
//
//   * DECISION-0051's failure split (image_quality vs technical vs
//     unavailable) is observable in the returned outcome
//   * a refused spend reservation degrades instead of spending
//   * timeout / HTTP error / network error / unparseable output are each
//     reported as technical failures, not as "photo needs a retake"
//   * the student-facing string is GENERIC by default
//   * the emitted record conforms to capture_quality_result.v1

import {
  assert,
  assertEquals,
  assertNotEquals,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  buildCaptureQualitySystemPrompt,
  buildRetakeGuidance,
  CAPTURE_QUALITY_LABELS,
  CAPTURE_QUALITY_MAX_TIMEOUT_MS,
  CAPTURE_QUALITY_MESSAGES,
  CAPTURE_QUALITY_MIN_TIMEOUT_MS,
  type CaptureQualityLabels,
  clampCaptureQualityTimeout,
  computeCaptureDisposition,
  extractParsedResult,
  GENERIC_RETAKE_GUIDANCE,
  mapDispositionToProvenanceQualityStatus,
  mapDispositionToQualityState,
  runCaptureQualityCheck,
  toCaptureQualityResultV1,
} from "./capture-quality-check.ts";

function allPass(): CaptureQualityLabels {
  return Object.fromEntries(
    CAPTURE_QUALITY_LABELS.map((label) => [label, "PASS" as const]),
  ) as CaptureQualityLabels;
}

const BYTES = new Uint8Array([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3, 4]);

function modelResponse(payload: unknown) {
  return new Response(JSON.stringify({ output_text: JSON.stringify(payload) }), {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });
}

/* -------------------------------------------------------------------------- */
/* Pure disposition rollup (carried over from the reverted suite)             */
/* -------------------------------------------------------------------------- */

Deno.test("all PASS + identifier NONE is ACCEPT", () => {
  const { disposition, failingLabels } = computeCaptureDisposition(
    allPass(),
    "NONE",
  );
  assertEquals(disposition, "ACCEPT");
  assertEquals(failingLabels, []);
});

Deno.test("one FAIL, rest PASS, identifier NONE is RETAKE", () => {
  const labels = { ...allPass(), FOCUS_LEGIBILITY: "FAIL" as const };
  const { disposition, failingLabels } = computeCaptureDisposition(
    labels,
    "NONE",
  );
  assertEquals(disposition, "RETAKE");
  assertEquals(failingLabels, ["FOCUS_LEGIBILITY"]);
});

Deno.test("any UNCERTAIN forces HUMAN_REVIEW even with a FAIL present", () => {
  // RETAKE framing claims we know what is wrong. We do not, if anything is
  // UNCERTAIN -- so this must not degrade into a confident retake prompt.
  const labels = {
    ...allPass(),
    FOCUS_LEGIBILITY: "FAIL" as const,
    GLARE_OCCLUSION: "UNCERTAIN" as const,
  };
  assertEquals(
    computeCaptureDisposition(labels, "NONE").disposition,
    "HUMAN_REVIEW",
  );
});

Deno.test("a possible incidental identifier forces HUMAN_REVIEW, never a retake", () => {
  // Telling a student "retake this, we saw your name" would relocate the
  // privacy problem rather than contain it.
  for (const verdict of ["PRESENT", "UNCERTAIN"] as const) {
    assertEquals(
      computeCaptureDisposition(allPass(), verdict).disposition,
      "HUMAN_REVIEW",
    );
  }
});

Deno.test("every FAIL is reported, not just the first", () => {
  const labels = {
    ...allPass(),
    PAGE_COMPLETE: "FAIL" as const,
    GLARE_OCCLUSION: "FAIL" as const,
  };
  const { failingLabels } = computeCaptureDisposition(labels, "NONE");
  assertEquals(failingLabels.length, 2);
});

Deno.test("disposition maps onto both downstream vocabularies", () => {
  // response_attachments.capture_quality_state check constraint.
  assertEquals(mapDispositionToQualityState("ACCEPT"), "acceptable");
  assertEquals(mapDispositionToQualityState("RETAKE"), "retake_required");
  assertEquals(mapDispositionToQualityState("HUMAN_REVIEW"), "indeterminate");
  // pairing_submission_provenance_event.v1 quality_status enum.
  assertEquals(mapDispositionToProvenanceQualityStatus("ACCEPT"), "ACCEPTABLE");
  assertEquals(
    mapDispositionToProvenanceQualityStatus("RETAKE"),
    "RETAKE_REQUIRED",
  );
  assertEquals(
    mapDispositionToProvenanceQualityStatus("HUMAN_REVIEW"),
    "CANNOT_DETERMINE",
  );
});

/* -------------------------------------------------------------------------- */
/* DECISION-0051: generic guidance is the baseline                            */
/* -------------------------------------------------------------------------- */

Deno.test("retake guidance is generic by default, even when defects are known", () => {
  const guidance = buildRetakeGuidance({
    failingLabels: ["GLARE_OCCLUSION", "FOCUS_LEGIBILITY"],
  });
  assertEquals(guidance, GENERIC_RETAKE_GUIDANCE);
});

Deno.test("specific guidance is opt-in and capped at two defects", () => {
  const guidance = buildRetakeGuidance({
    specific: true,
    failingLabels: ["FOCUS_LEGIBILITY", "GLARE_OCCLUSION", "ORIENTATION_USABLE"],
  });
  assertEquals(
    guidance,
    `${CAPTURE_QUALITY_MESSAGES.FOCUS_LEGIBILITY} ${CAPTURE_QUALITY_MESSAGES.GLARE_OCCLUSION}`,
  );
});

Deno.test("specific guidance falls back to generic when no defect is known", () => {
  assertEquals(
    buildRetakeGuidance({ specific: true, failingLabels: [] }),
    GENERIC_RETAKE_GUIDANCE,
  );
  assertEquals(buildRetakeGuidance(), GENERIC_RETAKE_GUIDANCE);
});

Deno.test("no capture-quality message ever describes the drawn content", () => {
  // Guards against a future edit pulling answer-adjacent language into a
  // string that must only ever describe the photograph.
  const strings = [
    ...Object.values(CAPTURE_QUALITY_MESSAGES),
    GENERIC_RETAKE_GUIDANCE,
  ];
  for (const message of strings) {
    assert(message.length > 0);
    const lower = message.toLowerCase();
    for (const forbidden of ["correct", "wrong", "answer", "should be"]) {
      if (lower.includes(forbidden)) {
        throw new Error(
          `message contains answer-adjacent word "${forbidden}": ${message}`,
        );
      }
    }
  }
});

Deno.test("the system prompt forbids content grading explicitly", () => {
  const prompt = buildCaptureQualitySystemPrompt();
  assert(prompt.includes("Do NOT judge the correctness"));
  // Every contract label must be described, or the model has no definition
  // for a field the schema forces it to fill.
  for (const label of CAPTURE_QUALITY_LABELS) {
    assert(prompt.includes(label), `prompt does not define ${label}`);
  }
});

/* -------------------------------------------------------------------------- */
/* Spend metering -- the defect the reverted Layer A version had              */
/* -------------------------------------------------------------------------- */

Deno.test("no API key configured means the check is unavailable, not a failure", () => {
  return runCaptureQualityCheck({
    bytes: BYTES,
    mediaType: "image/jpeg",
    apiKey: null,
    modelId: "test-model",
    timeoutMs: 5_000,
    reserveCost: () => Promise.resolve(true),
    fetchImpl: () => {
      throw new Error("must not call the model without a key");
    },
  }).then((outcome) => {
    assertEquals(outcome.kind, "unavailable");
    if (outcome.kind !== "unavailable") throw new Error("unreachable");
    assertEquals(outcome.failure, "not_configured");
  });
});

Deno.test("a refused spend reservation must not call the model at all", async () => {
  let called = false;
  const outcome = await runCaptureQualityCheck({
    bytes: BYTES,
    mediaType: "image/jpeg",
    apiKey: "sk-test",
    modelId: "test-model",
    timeoutMs: 5_000,
    reserveCost: () => Promise.resolve(false),
    fetchImpl: () => {
      called = true;
      return Promise.resolve(modelResponse({}));
    },
  });
  assertEquals(called, false);
  assertEquals(outcome.kind, "unavailable");
  if (outcome.kind !== "unavailable") throw new Error("unreachable");
  assertEquals(outcome.failure, "cost_cap_reached");
});

Deno.test("a reservation that throws is treated as refused, not as permission", async () => {
  let called = false;
  const outcome = await runCaptureQualityCheck({
    bytes: BYTES,
    mediaType: "image/jpeg",
    apiKey: "sk-test",
    modelId: "test-model",
    timeoutMs: 5_000,
    reserveCost: () => Promise.reject(new Error("rpc down")),
    fetchImpl: () => {
      called = true;
      return Promise.resolve(modelResponse({}));
    },
  });
  assertEquals(called, false);
  assertEquals(outcome.kind, "unavailable");
});

/* -------------------------------------------------------------------------- */
/* DECISION-0051: technical failure is distinguishable from a bad photo       */
/* -------------------------------------------------------------------------- */

Deno.test("an HTTP error is a technical failure, not a retake", async () => {
  const outcome = await runCaptureQualityCheck({
    bytes: BYTES,
    mediaType: "image/jpeg",
    apiKey: "sk-test",
    modelId: "test-model",
    timeoutMs: 5_000,
    reserveCost: () => Promise.resolve(true),
    fetchImpl: () => Promise.resolve(new Response("nope", { status: 503 })),
  });
  assertEquals(outcome.kind, "technical_failure");
  if (outcome.kind !== "technical_failure") throw new Error("unreachable");
  assertEquals(outcome.failure, "http_error");
  assertEquals(outcome.detail, "capture_quality_http_503");
});

Deno.test("a network error is a technical failure", async () => {
  const outcome = await runCaptureQualityCheck({
    bytes: BYTES,
    mediaType: "image/jpeg",
    apiKey: "sk-test",
    modelId: "test-model",
    timeoutMs: 5_000,
    reserveCost: () => Promise.resolve(true),
    fetchImpl: () => Promise.reject(new TypeError("connection reset")),
  });
  assertEquals(outcome.kind, "technical_failure");
  if (outcome.kind !== "technical_failure") throw new Error("unreachable");
  assertEquals(outcome.failure, "network_error");
});

Deno.test("a timeout is reported as a timeout, distinctly from a network error", async () => {
  const outcome = await runCaptureQualityCheck({
    bytes: BYTES,
    mediaType: "image/jpeg",
    apiKey: "sk-test",
    modelId: "test-model",
    timeoutMs: 5_000,
    reserveCost: () => Promise.resolve(true),
    fetchImpl: () =>
      Promise.reject(new DOMException("timed out", "TimeoutError")),
  });
  assertEquals(outcome.kind, "technical_failure");
  if (outcome.kind !== "technical_failure") throw new Error("unreachable");
  assertEquals(outcome.failure, "timeout");
});

Deno.test("an unparseable model response is a technical failure, not HUMAN_REVIEW", async () => {
  // This is the specific regression the reverted version could not express:
  // it collapsed a broken response into the same 'indeterminate' result as
  // a genuinely ambiguous photo, making the two indistinguishable.
  const outcome = await runCaptureQualityCheck({
    bytes: BYTES,
    mediaType: "image/jpeg",
    apiKey: "sk-test",
    modelId: "test-model",
    timeoutMs: 5_000,
    reserveCost: () => Promise.resolve(true),
    fetchImpl: () =>
      Promise.resolve(
        new Response(JSON.stringify({ output_text: "not json" }), {
          status: 200,
        }),
      ),
  });
  assertEquals(outcome.kind, "technical_failure");
  if (outcome.kind !== "technical_failure") throw new Error("unreachable");
  assertEquals(outcome.failure, "malformed_response");
});

Deno.test("a response missing one label is rejected, not silently defaulted", async () => {
  const partial = Object.fromEntries(
    CAPTURE_QUALITY_LABELS.slice(1).map((label) => [label, "PASS"]),
  );
  const outcome = await runCaptureQualityCheck({
    bytes: BYTES,
    mediaType: "image/jpeg",
    apiKey: "sk-test",
    modelId: "test-model",
    timeoutMs: 5_000,
    reserveCost: () => Promise.resolve(true),
    fetchImpl: () =>
      Promise.resolve(
        modelResponse({ labels: partial, incidental_identifier: "NONE" }),
      ),
  });
  assertEquals(outcome.kind, "technical_failure");
});

Deno.test("a healthy model response produces an assessed outcome", async () => {
  const outcome = await runCaptureQualityCheck({
    bytes: BYTES,
    mediaType: "image/jpeg",
    apiKey: "sk-test",
    modelId: "test-model",
    timeoutMs: 5_000,
    reserveCost: () => Promise.resolve(true),
    fetchImpl: () =>
      Promise.resolve(
        modelResponse({
          labels: { ...allPass(), GLARE_OCCLUSION: "FAIL" },
          incidental_identifier: "NONE",
        }),
      ),
  });
  assertEquals(outcome.kind, "assessed");
  if (outcome.kind !== "assessed") throw new Error("unreachable");
  assertEquals(outcome.disposition, "RETAKE");
  assertEquals(outcome.captureQualityState, "retake_required");
  assertEquals(outcome.failingLabels, ["GLARE_OCCLUSION"]);
  assertEquals(outcome.modelId, "test-model");
});

Deno.test("the request never asks the vendor to retain the image", async () => {
  let capturedBody: Record<string, unknown> | null = null;
  await runCaptureQualityCheck({
    bytes: BYTES,
    mediaType: "image/jpeg",
    apiKey: "sk-test",
    modelId: "test-model",
    timeoutMs: 5_000,
    reserveCost: () => Promise.resolve(true),
    fetchImpl: (_url, init) => {
      capturedBody = JSON.parse(String(init?.body));
      return Promise.resolve(
        modelResponse({ labels: allPass(), incidental_identifier: "NONE" }),
      );
    },
  });
  assert(capturedBody !== null);
  assertEquals((capturedBody as Record<string, unknown>).store, false);
});

/* -------------------------------------------------------------------------- */
/* Timeout clamping                                                           */
/* -------------------------------------------------------------------------- */

Deno.test("timeout is clamped so an upload path cannot hang on this check", () => {
  assertEquals(clampCaptureQualityTimeout(1), CAPTURE_QUALITY_MIN_TIMEOUT_MS);
  assertEquals(
    clampCaptureQualityTimeout(600_000),
    CAPTURE_QUALITY_MAX_TIMEOUT_MS,
  );
  assertEquals(clampCaptureQualityTimeout(8_000), 8_000);
  // Unset / garbage env values fall back to the ceiling rather than 0,
  // which would abort every call instantly.
  assertEquals(
    clampCaptureQualityTimeout(undefined),
    CAPTURE_QUALITY_MAX_TIMEOUT_MS,
  );
  assertEquals(clampCaptureQualityTimeout(0), CAPTURE_QUALITY_MAX_TIMEOUT_MS);
  assertEquals(clampCaptureQualityTimeout(-5), CAPTURE_QUALITY_MAX_TIMEOUT_MS);
  assertEquals(clampCaptureQualityTimeout(NaN), CAPTURE_QUALITY_MAX_TIMEOUT_MS);
});

/* -------------------------------------------------------------------------- */
/* Response parsing                                                           */
/* -------------------------------------------------------------------------- */

Deno.test("parser reads both the flat and nested Responses-API output shapes", () => {
  const payload = { labels: allPass(), incidental_identifier: "NONE" };
  const flat = extractParsedResult({ output_text: JSON.stringify(payload) });
  assertNotEquals(flat, null);
  const nested = extractParsedResult({
    output: [{ content: [{ text: JSON.stringify(payload) }] }],
  });
  assertNotEquals(nested, null);
  assertEquals(nested?.incidentalIdentifier, "NONE");
});

Deno.test("parser rejects an out-of-enum identifier rather than coercing it", () => {
  const parsed = extractParsedResult({
    output_text: JSON.stringify({
      labels: allPass(),
      incidental_identifier: "MAYBE",
    }),
  });
  assertEquals(parsed, null);
});

Deno.test("parser rejects an out-of-enum label verdict", () => {
  const parsed = extractParsedResult({
    output_text: JSON.stringify({
      labels: { ...allPass(), FOCUS_LEGIBILITY: "PROBABLY" },
      incidental_identifier: "NONE",
    }),
  });
  assertEquals(parsed, null);
});

Deno.test("parser rejects empty and non-object inputs", () => {
  for (const bad of [null, undefined, 42, "text", {}, { output: [] }]) {
    assertEquals(extractParsedResult(bad), null);
  }
});

/* -------------------------------------------------------------------------- */
/* capture_quality_result.v1 conformance                                      */
/* -------------------------------------------------------------------------- */

Deno.test("an assessed outcome serializes to a capture_quality_result.v1 record", () => {
  const record = toCaptureQualityResultV1({
    kind: "assessed",
    disposition: "ACCEPT",
    captureQualityState: "acceptable",
    failingLabels: [],
    labels: allPass(),
    incidentalIdentifier: "NONE",
    modelId: "test-model",
    latencyMs: 120,
  }, {
    sourceImageId: "image-1",
    itemId: "item-1",
    responseId: "response-1",
    captureReviewerId: "model:test-model",
    timestamp: new Date("2026-08-19T12:00:00.000Z"),
  });
  assert(record !== null);
  for (
    const key of [
      "contract_version",
      ...CAPTURE_QUALITY_LABELS,
      "INCIDENTAL_IDENTIFIER",
      "CAPTURE_DISPOSITION",
      "source_image_id",
      "item_id",
      "response_id",
      "capture_reviewer_id",
      "timestamp",
    ]
  ) {
    assert(key in record!, `missing required contract field ${key}`);
  }
  assertEquals(record!.contract_version, "v1");
  assertEquals(record!.CAPTURE_DISPOSITION, "ACCEPT");
  assertEquals(record!.timestamp, "2026-08-19T12:00:00.000Z");
});

Deno.test("a non-assessed outcome emits NO contract record (no fabricated evidence)", () => {
  const identity = {
    sourceImageId: "image-1",
    itemId: "item-1",
    responseId: "response-1",
    captureReviewerId: "model:test-model",
    timestamp: new Date(),
  };
  assertEquals(
    toCaptureQualityResultV1(
      { kind: "unavailable", failure: "not_configured" },
      identity,
    ),
    null,
  );
  assertEquals(
    toCaptureQualityResultV1({
      kind: "technical_failure",
      failure: "timeout",
      detail: "x",
      modelId: "m",
      latencyMs: 1,
    }, identity),
    null,
  );
});
