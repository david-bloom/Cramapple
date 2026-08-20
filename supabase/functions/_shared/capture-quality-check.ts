// Capture-quality check for hand-drawn photo uploads
// (TASK-0016 Phase D, Stage D2 item 8; DECISION-0051 item 3).
//
// PROVENANCE -- this is a deliberate, changed reintroduction
// ---------------------------------------------------------
// A near-identical module shipped as commit 52efaef on 2026-08-18 ("Add
// capture-quality check for hand-drawn photo uploads (idea 1, Layer A)")
// and was reverted three minutes later by d0b6fef. The revert reason is not
// recorded anywhere in this repo -- ACTIVITY_LOG.md's own entry for it says
// "reason not recorded here" and lists "decide and record why Layer A was
// reverted" as the next required action. So this reintroduction does not
// claim to know why it was pulled. What it does instead is fix the defects
// that are visible in the reverted code on review, so that if one of them
// was the reason, it is no longer present:
//
//   1. The reverted version ran an UNCAPPED model call on a student-
//      triggered path. `evaluate-attempt` -- the only other model caller in
//      this codebase -- gates every call behind a daily USD cap
//      (OPENAI_DAILY_CAP_USD, reserved via RPC). Layer A had no equivalent,
//      so capture uploads were an unmetered spend channel. This version
//      takes an explicit `costCapReservation` callback: the caller must
//      supply the same kind of reservation, and a refused reservation
//      degrades to "not checked" rather than spending.
//   2. The reverted version returned SPECIFIC defect callouts ("Glare or a
//      shadow is covering part of the page"). DECISION-0051 (logged the day
//      after the revert) made GENERIC retake guidance the baseline and
//      demoted defect-naming to an optional UX refinement. Specific labels
//      are still computed and audited here, but the student-facing string is
//      generic by default.
//   3. The reverted version collapsed every failure -- network error, HTTP
//      error, timeout, unparseable response, missing label -- into the same
//      HUMAN_REVIEW/`indeterminate` result as a genuinely ambiguous photo.
//      That makes the two causes DECISION-0051 requires be distinguishable
//      indistinguishable. This version returns a discriminated union: an
//      assessment, or an explicit technical failure the caller routes to
//      bug logging.
//   4. The reverted version blocked on the vision call for up to 15s inside
//      the upload path with no timeout floor/ceiling validation. The
//      timeout is now clamped.
//
// SCOPE DISCIPLINE (unchanged from the reverted version, and correct there)
// -----------------------------------------------------------------------
// This is NOT the content grader. It judges only whether the PHOTOGRAPH is
// legible enough to be graded -- focus, framing, glare, angle, resolution,
// orientation -- and never whether the student's graph is right. Stage D1's
// frozen `capture_quality_result.v1` contract states the same rule
// ("Missing axis labels on a clear photograph are a scoring observation,
// not a capture failure"), and the labels/disposition rollup below mirror
// that contract exactly rather than inventing a second taxonomy.
//
// Pure decision logic is exported separately from the network call so the
// parts that decide anything are unit tested without a model in the loop.

/** Exactly the seven label fields of `capture_quality_result.v1`. */
export const CAPTURE_QUALITY_LABELS = [
  "PAGE_COMPLETE",
  "GRAPH_REGION_COMPLETE",
  "FOCUS_LEGIBILITY",
  "GLARE_OCCLUSION",
  "PERSPECTIVE_READABILITY",
  "RESOLUTION_READABILITY",
  "ORIENTATION_USABLE",
] as const;

export type CaptureQualityLabel = typeof CAPTURE_QUALITY_LABELS[number];
export type LabelVerdict = "PASS" | "FAIL" | "UNCERTAIN";
export type IncidentalIdentifierVerdict = "NONE" | "PRESENT" | "UNCERTAIN";
export type CaptureQualityLabels = Record<CaptureQualityLabel, LabelVerdict>;

/** `capture_quality_result.v1`'s CAPTURE_DISPOSITION enum. */
export type CaptureDisposition = "ACCEPT" | "RETAKE" | "HUMAN_REVIEW";

/** The `check` constraint on `app.response_attachments.capture_quality_state`. */
export type CaptureAttachmentQualityState =
  | "pending"
  | "acceptable"
  | "retake_required"
  | "indeterminate";

export function mapDispositionToQualityState(
  disposition: CaptureDisposition,
): CaptureAttachmentQualityState {
  switch (disposition) {
    case "ACCEPT":
      return "acceptable";
    case "RETAKE":
      return "retake_required";
    case "HUMAN_REVIEW":
      return "indeterminate";
  }
}

/** `pairing_submission_provenance_event.v1`'s `quality_status` vocabulary. */
export function mapDispositionToProvenanceQualityStatus(
  disposition: CaptureDisposition,
): "ACCEPTABLE" | "RETAKE_REQUIRED" | "CANNOT_DETERMINE" {
  switch (disposition) {
    case "ACCEPT":
      return "ACCEPTABLE";
    case "RETAKE":
      return "RETAKE_REQUIRED";
    case "HUMAN_REVIEW":
      return "CANNOT_DETERMINE";
  }
}

/**
 * Pure rollup, mirroring `capture_quality_result.v1`'s decision rule:
 *   ACCEPT       -- every label PASS and identifier NONE.
 *   RETAKE       -- at least one FAIL, no UNCERTAIN, identifier NONE.
 *   HUMAN_REVIEW -- any UNCERTAIN label, or identifier PRESENT/UNCERTAIN.
 *
 * A mixed FAIL+UNCERTAIN result is HUMAN_REVIEW, not RETAKE: the contract's
 * own note is that RETAKE is only appropriate "when recapture can plausibly
 * fix the defect", and we cannot claim that while something is unreadable
 * for an unknown reason.
 *
 * A possible incidental identifier (a name, a face, a school marking)
 * forces HUMAN_REVIEW and is never turned into a retake prompt -- telling a
 * student "retake this, we saw your name" would itself be the privacy
 * problem.
 */
export function computeCaptureDisposition(
  labels: CaptureQualityLabels,
  incidentalIdentifier: IncidentalIdentifierVerdict,
): { disposition: CaptureDisposition; failingLabels: CaptureQualityLabel[] } {
  const failingLabels = CAPTURE_QUALITY_LABELS.filter(
    (label) => labels[label] === "FAIL",
  );
  const hasUncertain = CAPTURE_QUALITY_LABELS.some(
    (label) => labels[label] === "UNCERTAIN",
  );

  if (incidentalIdentifier !== "NONE") {
    return { disposition: "HUMAN_REVIEW", failingLabels };
  }
  if (hasUncertain) {
    return { disposition: "HUMAN_REVIEW", failingLabels };
  }
  if (failingLabels.length > 0) {
    return { disposition: "RETAKE", failingLabels };
  }
  return { disposition: "ACCEPT", failingLabels };
}

/**
 * Optional, non-default specific copy. Retained from the reverted Layer A
 * because the taxonomy is sound and DECISION-0051 explicitly allows defect
 * naming as a later UX refinement -- but nothing in this module returns
 * these to a student unless a caller opts in via
 * `buildRetakeGuidance({ specific: true })`. Every string describes only
 * the photograph.
 */
export const CAPTURE_QUALITY_MESSAGES: Record<CaptureQualityLabel, string> = {
  PAGE_COMPLETE:
    "Part of your response page is outside the frame — retake the photo with the whole page visible.",
  GRAPH_REGION_COMPLETE:
    "Part of your graph is cut off in the photo — retake it with the entire graph in frame.",
  FOCUS_LEGIBILITY:
    "The photo is too blurry to read clearly — hold the camera steady and make sure it's in focus before capturing.",
  GLARE_OCCLUSION:
    "Glare or a shadow is covering part of the page — retake it in more even lighting, away from direct glare.",
  PERSPECTIVE_READABILITY:
    "The photo was taken at too sharp an angle to read reliably — retake it from directly above the page.",
  RESOLUTION_READABILITY:
    "The photo's resolution is too low to read the marks clearly — move closer or use a higher-resolution capture.",
  ORIENTATION_USABLE:
    "The photo's orientation makes it hard to read — retake it right-side up.",
};

/**
 * Deliberately imported from the pairing module rather than redefined, so
 * there is exactly one generic retake string in the codebase and the phone
 * leg, the primary device, and the audit trail cannot drift apart.
 */
import { GENERIC_RETAKE_GUIDANCE } from "./capture-pairing.ts";
export { GENERIC_RETAKE_GUIDANCE };

/**
 * DECISION-0051's baseline: generic guidance. `specific: true` opts into
 * naming at most two detected defects, capped so a student gets a focused
 * prompt rather than a list. Not used by default anywhere.
 */
export function buildRetakeGuidance(params?: {
  failingLabels?: CaptureQualityLabel[];
  specific?: boolean;
}): string {
  if (!params?.specific) return GENERIC_RETAKE_GUIDANCE;
  const labels = params.failingLabels ?? [];
  if (labels.length === 0) return GENERIC_RETAKE_GUIDANCE;
  return labels.slice(0, 2).map((label) => CAPTURE_QUALITY_MESSAGES[label])
    .join(" ");
}

/* -------------------------------------------------------------------------- */
/* Result shape                                                                */
/* -------------------------------------------------------------------------- */

export type CaptureQualityTechnicalFailure =
  | "not_configured"
  | "cost_cap_reached"
  | "timeout"
  | "network_error"
  | "http_error"
  | "malformed_response";

/**
 * The discriminated union that makes DECISION-0051's split implementable.
 *
 * `assessed`   -- we have a real verdict about the photo. A RETAKE here is
 *                 an image-quality failure: generic retake copy, no bug.
 * `unavailable`-- the check did not run for a benign, known reason (no key
 *                 configured, spend cap reached). NOT a bug and NOT a
 *                 retake: the attachment binds with `pending` and nothing
 *                 is claimed about the photo.
 * `technical_failure` -- the check ran and broke. This is the case that
 *                 must reach engineering, and must never be shown to the
 *                 student as a problem with their photo.
 */
export type CaptureQualityOutcome =
  | {
    kind: "assessed";
    disposition: CaptureDisposition;
    captureQualityState: CaptureAttachmentQualityState;
    failingLabels: CaptureQualityLabel[];
    labels: CaptureQualityLabels;
    incidentalIdentifier: IncidentalIdentifierVerdict;
    modelId: string;
    latencyMs: number;
  }
  | {
    kind: "unavailable";
    failure: Extract<
      CaptureQualityTechnicalFailure,
      "not_configured" | "cost_cap_reached"
    >;
  }
  | {
    kind: "technical_failure";
    failure: Exclude<
      CaptureQualityTechnicalFailure,
      "not_configured" | "cost_cap_reached"
    >;
    detail: string;
    modelId: string;
    latencyMs: number;
  };

/**
 * Builds a `capture_quality_result.v1`-conforming record from an assessed
 * outcome. Returns null for non-assessed outcomes: emitting a contract
 * record for a check that never produced label verdicts would be
 * fabricating evidence, and `capture_quality_result.v1` has no
 * representation for "not assessed" (by design -- its labels are required).
 */
export function toCaptureQualityResultV1(
  outcome: CaptureQualityOutcome,
  identity: {
    sourceImageId: string;
    itemId: string;
    responseId: string;
    captureReviewerId: string;
    timestamp: Date;
  },
): Record<string, unknown> | null {
  if (outcome.kind !== "assessed") return null;
  return {
    contract_version: "v1",
    ...outcome.labels,
    INCIDENTAL_IDENTIFIER: outcome.incidentalIdentifier,
    CAPTURE_DISPOSITION: outcome.disposition,
    source_image_id: identity.sourceImageId,
    item_id: identity.itemId,
    response_id: identity.responseId,
    capture_reviewer_id: identity.captureReviewerId,
    timestamp: identity.timestamp.toISOString(),
  };
}

/* -------------------------------------------------------------------------- */
/* Model call                                                                  */
/* -------------------------------------------------------------------------- */

const CAPTURE_QUALITY_SCHEMA = {
  type: "object",
  additionalProperties: false,
  properties: {
    labels: {
      type: "object",
      additionalProperties: false,
      properties: Object.fromEntries(
        CAPTURE_QUALITY_LABELS.map((label) => [
          label,
          { type: "string", enum: ["PASS", "FAIL", "UNCERTAIN"] },
        ]),
      ),
      required: [...CAPTURE_QUALITY_LABELS],
    },
    incidental_identifier: {
      type: "string",
      enum: ["NONE", "PRESENT", "UNCERTAIN"],
    },
  },
  required: ["labels", "incidental_identifier"],
} as const;

export function buildCaptureQualitySystemPrompt() {
  return [
    "You are Cramapple's capture-quality checker for a student-submitted photo of a hand-drawn graph.",
    "You are judging ONLY the photograph itself -- focus, framing, glare, angle, resolution, orientation.",
    "Do NOT judge the correctness of anything the student drew. A clear photo of an incomplete or wrong graph is still PASS on every capture-quality label.",
    "PAGE_COMPLETE: PASS if the full response page is visible in frame.",
    "GRAPH_REGION_COMPLETE: PASS if the entire graph region is in frame, not cut off.",
    "FOCUS_LEGIBILITY: PASS if marks and text are sharp enough to read.",
    "GLARE_OCCLUSION: PASS if no glare or shadow obscures evidence.",
    "PERSPECTIVE_READABILITY: PASS if geometry is readable despite any skew.",
    "RESOLUTION_READABILITY: PASS if resolution is sufficient to read required marks.",
    "ORIENTATION_USABLE: PASS if the image orientation can be corrected to readable.",
    "Use UNCERTAIN only when you genuinely cannot tell, not as a default.",
    "incidental_identifier: PRESENT if a visible name, face, school marking, or unrelated surroundings are visible; UNCERTAIN if something might be one but isn't clearly readable; NONE otherwise.",
    "Return only the JSON object that matches the schema.",
  ].join(" ");
}

/** 3s floor / 20s ceiling. An upload path must not hang on this check. */
export const CAPTURE_QUALITY_MIN_TIMEOUT_MS = 3_000;
export const CAPTURE_QUALITY_MAX_TIMEOUT_MS = 20_000;

export function clampCaptureQualityTimeout(raw: number | undefined) {
  if (!Number.isFinite(raw) || (raw ?? 0) <= 0) {
    return CAPTURE_QUALITY_MAX_TIMEOUT_MS;
  }
  return Math.min(
    CAPTURE_QUALITY_MAX_TIMEOUT_MS,
    Math.max(CAPTURE_QUALITY_MIN_TIMEOUT_MS, Math.round(raw as number)),
  );
}

function toBase64(bytes: Uint8Array) {
  let binary = "";
  const chunkSize = 0x8000;
  for (let i = 0; i < bytes.length; i += chunkSize) {
    binary += String.fromCharCode(...bytes.subarray(i, i + chunkSize));
  }
  return btoa(binary);
}

/**
 * Runs the vision check. Never throws: every failure path resolves to an
 * explicit `technical_failure` (or `unavailable`) outcome, because a broken
 * quality checker must never be the reason a student's upload fails.
 *
 * `reserveCost` is required, not optional. It exists so this call cannot be
 * the unmetered spend channel the reverted Layer A version was; pass a
 * function that performs whatever reservation the caller's budget mechanism
 * uses (see `evaluate-attempt`'s daily-cap RPC) and returns false when the
 * cap is reached.
 */
export async function runCaptureQualityCheck(input: {
  bytes: Uint8Array;
  mediaType: "image/png" | "image/jpeg" | "image/webp";
  apiKey: string | null;
  modelId: string;
  timeoutMs: number;
  reserveCost: () => Promise<boolean>;
  fetchImpl?: typeof fetch;
}): Promise<CaptureQualityOutcome> {
  if (!input.apiKey) return { kind: "unavailable", failure: "not_configured" };

  const reserved = await input.reserveCost().catch(() => false);
  if (!reserved) return { kind: "unavailable", failure: "cost_cap_reached" };

  const doFetch = input.fetchImpl ?? fetch;
  const timeoutMs = clampCaptureQualityTimeout(input.timeoutMs);
  const dataUrl = `data:${input.mediaType};base64,${toBase64(input.bytes)}`;
  const startedAt = Date.now();

  let response: Response;
  try {
    response = await doFetch("https://api.openai.com/v1/responses", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${input.apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: input.modelId,
        input: [
          {
            role: "system",
            content: [{
              type: "input_text",
              text: buildCaptureQualitySystemPrompt(),
            }],
          },
          {
            role: "user",
            content: [
              { type: "input_text", text: "Assess this captured photo." },
              { type: "input_image", image_url: dataUrl },
            ],
          },
        ],
        // No retention of student image bytes at the vendor.
        store: false,
        max_output_tokens: 512,
        text: {
          format: {
            type: "json_schema",
            name: "capture_quality_result",
            strict: true,
            schema: CAPTURE_QUALITY_SCHEMA,
          },
        },
      }),
      signal: AbortSignal.timeout(timeoutMs),
    });
  } catch (error) {
    const isTimeout = error instanceof DOMException &&
      (error.name === "TimeoutError" || error.name === "AbortError");
    return {
      kind: "technical_failure",
      failure: isTimeout ? "timeout" : "network_error",
      detail: error instanceof Error
        ? error.message.slice(0, 300)
        : "capture_quality_fetch_failed",
      modelId: input.modelId,
      latencyMs: Date.now() - startedAt,
    };
  }

  if (!response.ok) {
    return {
      kind: "technical_failure",
      failure: "http_error",
      detail: `capture_quality_http_${response.status}`,
      modelId: input.modelId,
      latencyMs: Date.now() - startedAt,
    };
  }

  const raw = await response.json().catch(() => null);
  const parsed = extractParsedResult(raw);
  if (!parsed) {
    return {
      kind: "technical_failure",
      failure: "malformed_response",
      detail: "capture_quality_unparseable_output",
      modelId: input.modelId,
      latencyMs: Date.now() - startedAt,
    };
  }

  const { disposition, failingLabels } = computeCaptureDisposition(
    parsed.labels,
    parsed.incidentalIdentifier,
  );
  return {
    kind: "assessed",
    disposition,
    captureQualityState: mapDispositionToQualityState(disposition),
    failingLabels,
    labels: parsed.labels,
    incidentalIdentifier: parsed.incidentalIdentifier,
    modelId: input.modelId,
    latencyMs: Date.now() - startedAt,
  };
}

/**
 * Extracts and validates the structured payload. A response missing even
 * one required label is rejected outright rather than defaulted -- silently
 * substituting UNCERTAIN for an absent verdict would turn a model/API
 * regression into a permanent stream of "needs human review" photos with no
 * signal that anything was wrong.
 */
export function extractParsedResult(raw: unknown): {
  labels: CaptureQualityLabels;
  incidentalIdentifier: IncidentalIdentifierVerdict;
} | null {
  if (!raw || typeof raw !== "object") return null;
  const record = raw as Record<string, unknown>;
  let text = typeof record.output_text === "string" ? record.output_text : null;
  if (!text && Array.isArray(record.output)) {
    for (const item of record.output) {
      if (!item || typeof item !== "object") continue;
      const content = (item as Record<string, unknown>).content;
      if (!Array.isArray(content)) continue;
      for (const piece of content) {
        if (!piece || typeof piece !== "object") continue;
        const pieceText = (piece as Record<string, unknown>).text;
        if (typeof pieceText === "string" && pieceText.length > 0) {
          text = pieceText;
          break;
        }
      }
      if (text) break;
    }
  }
  if (!text) return null;

  try {
    const parsed = JSON.parse(text) as Record<string, unknown>;
    const rawLabels = parsed.labels as Record<string, unknown> | undefined;
    if (!rawLabels || typeof rawLabels !== "object") return null;

    const labels = {} as CaptureQualityLabels;
    for (const label of CAPTURE_QUALITY_LABELS) {
      const value = rawLabels[label];
      if (value !== "PASS" && value !== "FAIL" && value !== "UNCERTAIN") {
        return null;
      }
      labels[label] = value;
    }

    const identifier = parsed.incidental_identifier;
    if (
      identifier !== "NONE" && identifier !== "PRESENT" &&
      identifier !== "UNCERTAIN"
    ) {
      return null;
    }

    return { labels, incidentalIdentifier: identifier };
  } catch {
    return null;
  }
}
