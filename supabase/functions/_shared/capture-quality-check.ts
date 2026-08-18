// Layer A of "explain why a hand-drawn image couldn't be graded": a fast,
// cheap vision check that answers "is this photo good enough to grade at
// all," run at upload time (attach_capture) independent of content grading.
//
// This is deliberately NOT the content grader. It never judges whether the
// student's answer is correct -- only whether the photo itself is legible
// enough to be judged. That keeps it decoupled from the accuracy problems
// documented in docs/activity_log/ACTIVITY_LOG.md (2026-08-18): hand-drawn
// CONTENT grading is not launch-approved, but capture-quality assessment is
// a much narrower, better-calibrated task that doesn't require trusting that
// finding either way.
//
// Labels and the ACCEPT/RETAKE/HUMAN_REVIEW rollup rule mirror
// docs/research/DRAWN_RESPONSE_ANNOTATION_HANDBOOK.md section 3 exactly, so
// this reuses a taxonomy that has already been thought through rather than
// inventing a new one.

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

export type CaptureDisposition = "ACCEPT" | "RETAKE" | "HUMAN_REVIEW";

export type CaptureAttachmentQualityState =
  | "acceptable"
  | "retake_required"
  | "indeterminate";

// Student-safe, retake-actionable sentences. Deliberately say nothing about
// the drawn content itself -- only about the photograph -- so this can never
// be an answer-revealing message.
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

// Deliberately no message for INCIDENTAL_IDENTIFIER. It never drives a
// RETAKE prompt (see computeCaptureDisposition) — routing a possible personal
// identifier to human review, silently, is the safe default.

export type CaptureQualityLabels = Record<CaptureQualityLabel, LabelVerdict>;

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

// Pure rollup, mirroring the handbook's CAPTURE_DISPOSITION decision rule
// (section 3) exactly:
//   ACCEPT: every label PASS (and identifier NONE).
//   RETAKE: at least one FAIL, none UNCERTAIN, identifier not PRESENT/UNCERTAIN.
//   HUMAN_REVIEW: any UNCERTAIN label, or identifier PRESENT/UNCERTAIN.
// A single mixed FAIL+UNCERTAIN result is HUMAN_REVIEW, not RETAKE -- the
// handbook treats any uncertainty as disqualifying a confident retake
// prompt, since retake framing implies "we know what's wrong."
export function computeCaptureDisposition(
  labels: CaptureQualityLabels,
  incidentalIdentifier: IncidentalIdentifierVerdict,
): { disposition: CaptureDisposition; failingLabels: CaptureQualityLabel[] } {
  const failingLabels = CAPTURE_QUALITY_LABELS.filter((label) =>
    labels[label] === "FAIL"
  );
  const hasUncertain = CAPTURE_QUALITY_LABELS.some((label) =>
    labels[label] === "UNCERTAIN"
  );

  if (incidentalIdentifier === "PRESENT" || incidentalIdentifier === "UNCERTAIN") {
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

// Composes the retake message from whichever labels failed, capped at 2 so
// the student gets a focused prompt rather than a wall of issues.
export function buildRetakeMessage(failingLabels: CaptureQualityLabel[]): string {
  const shown = failingLabels.slice(0, 2).map((label) => CAPTURE_QUALITY_MESSAGES[label]);
  return shown.join(" ");
}

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

function buildSystemPrompt() {
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

export type CaptureQualityCheckResult = {
  disposition: CaptureDisposition;
  captureQualityState: CaptureAttachmentQualityState;
  failingLabels: CaptureQualityLabel[];
  retakeMessage: string | null;
  labels: CaptureQualityLabels;
  incidentalIdentifier: IncidentalIdentifierVerdict;
};

function toBase64(bytes: Uint8Array) {
  let binary = "";
  const chunkSize = 0x8000;
  for (let i = 0; i < bytes.length; i += chunkSize) {
    binary += String.fromCharCode(...bytes.subarray(i, i + chunkSize));
  }
  return btoa(binary);
}

// Runs the vision check and folds the result through the pure rollup above.
// Any failure to reach a confident verdict (network error, malformed
// response, missing label) resolves to HUMAN_REVIEW rather than guessing --
// this check must never be the reason a legible photo gets silently stuck,
// nor the reason an unreadable one gets silently accepted.
export async function runCaptureQualityCheck(input: {
  bytes: Uint8Array;
  mediaType: "image/png" | "image/jpeg" | "image/webp";
  apiKey: string;
  modelId: string;
  timeoutMs: number;
}): Promise<CaptureQualityCheckResult> {
  const dataUrl = `data:${input.mediaType};base64,${toBase64(input.bytes)}`;

  try {
    const response = await fetch("https://api.openai.com/v1/responses", {
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
            content: [{ type: "input_text", text: buildSystemPrompt() }],
          },
          {
            role: "user",
            content: [
              { type: "input_text", text: "Assess this captured photo." },
              { type: "input_image", image_url: dataUrl },
            ],
          },
        ],
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
      signal: AbortSignal.timeout(input.timeoutMs),
    });

    if (!response.ok) {
      return humanReviewFallback();
    }

    const raw = await response.json().catch(() => null);
    const parsed = extractParsedResult(raw);
    if (!parsed) {
      return humanReviewFallback();
    }

    const { disposition, failingLabels } = computeCaptureDisposition(
      parsed.labels,
      parsed.incidentalIdentifier,
    );
    return {
      disposition,
      captureQualityState: mapDispositionToQualityState(disposition),
      failingLabels,
      retakeMessage: disposition === "RETAKE" ? buildRetakeMessage(failingLabels) : null,
      labels: parsed.labels,
      incidentalIdentifier: parsed.incidentalIdentifier,
    };
  } catch {
    return humanReviewFallback();
  }
}

function humanReviewFallback(): CaptureQualityCheckResult {
  const labels = Object.fromEntries(
    CAPTURE_QUALITY_LABELS.map((label) => [label, "UNCERTAIN" as LabelVerdict]),
  ) as CaptureQualityLabels;
  return {
    disposition: "HUMAN_REVIEW",
    captureQualityState: "indeterminate",
    failingLabels: [],
    retakeMessage: null,
    labels,
    incidentalIdentifier: "UNCERTAIN",
  };
}

function extractParsedResult(raw: unknown): {
  labels: CaptureQualityLabels;
  incidentalIdentifier: IncidentalIdentifierVerdict;
} | null {
  if (!raw || typeof raw !== "object") return null;
  const record = raw as Record<string, unknown>;
  const direct = typeof record.output_text === "string" ? record.output_text : null;
  let text = direct;
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
    const incidentalIdentifier: IncidentalIdentifierVerdict =
      identifier === "NONE" || identifier === "PRESENT" || identifier === "UNCERTAIN"
        ? identifier
        : "UNCERTAIN";

    return { labels, incidentalIdentifier };
  } catch {
    return null;
  }
}
