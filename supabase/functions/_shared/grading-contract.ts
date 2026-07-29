// Shared grading contract. Production (evaluate-attempt) and the grading
// model assessment harness (scripts/grading-model-assessment/) both import
// from this module so the harness tests what production actually sends and
// scores, rather than a parallel reimplementation that can silently drift.
// No side effects at import time (no Deno.serve, no env reads) -- this is
// what makes it safe for a non-server script to import directly.
//
// See docs/architecture/GRADING_MODEL_ASSESSMENT_HARNESS_SCOPE_2026_07_11.md
// section 2 for the design rationale.

import {
  type FeedbackCriterionRow,
  type FeedbackCriterionResult,
  sanitizeModelResult,
} from "./grading-feedback.ts";

export type { FeedbackCriterionResult, FeedbackCriterionRow };
export { sanitizeModelResult };

export type AllowedOperation =
  | "grade_initial_attempt"
  | "select_repair"
  | "grade_revision"
  | "grade_transfer_attempt";

// The production structured-output schema. Unchanged from evaluate-attempt's
// former local `gradingSchema` -- moved here verbatim, not reauthored, so
// there is exactly one place this can drift from what production requests.
export const gradingSchema = {
  type: "object",
  additionalProperties: false,
  properties: {
    status: {
      type: "string",
      enum: ["graded", "uncertain", "failed"],
    },
    points_earned: { type: "integer" },
    points_available: { type: "integer" },
    criteria: {
      type: "array",
      items: {
        type: "object",
        additionalProperties: false,
        properties: {
          criterion_key: { type: "string" },
          status: {
            type: "string",
            enum: [
              "earned",
              "not_yet_earned",
              "unable_to_determine",
              "not_applicable",
            ],
          },
          points_awarded: { type: "integer" },
          evidence_quote: { type: ["string", "null"] },
          decision_explanation: { type: ["string", "null"] },
          minimum_fix: { type: ["string", "null"] },
        },
        required: [
          "criterion_key",
          "status",
          "points_awarded",
          "evidence_quote",
          "decision_explanation",
          "minimum_fix",
        ],
      },
    },
    highest_value_gap: {
      anyOf: [
        { type: "null" },
        {
          type: "object",
          additionalProperties: false,
          properties: {
            criterion_key: { type: "string" },
            minimum_fix: { type: "string" },
            repair_prompt: { type: "string" },
          },
          required: ["criterion_key", "minimum_fix", "repair_prompt"],
        },
      ],
    },
    predicted_improvement: {
      anyOf: [
        { type: "null" },
        {
          type: "object",
          additionalProperties: false,
          properties: {
            label: {
              type: "string",
              enum: ["better", "much_better", "none"],
            },
            predicted_point_gain: { type: "integer" },
          },
          required: ["label", "predicted_point_gain"],
        },
      ],
    },
    confidence: {
      type: "string",
      enum: ["high", "medium", "low"],
    },
    uncertainty_reason: { type: ["string", "null"] },
    student_facing_summary: { type: "string" },
    action_hint: {
      type: ["string", "null"],
      enum: ["show_scaffold", "review_context", null],
    },
    repair_hint: { type: ["string", "null"] },
  },
  // OpenAI structured outputs run with `strict: true` (see
  // buildGradingRequestBody), which requires EVERY key in `properties` to also
  // appear here -- optionality is expressed by making the type nullable, not by
  // omitting the key. `action_hint` and `repair_hint` were absent, so the API
  // rejected the request before it reached the model: 4 of the 5 FRQ gradings
  // ever attempted in Production died with
  //   "Invalid schema for response_format 'grading_result' ... Missing 'action_hint'"
  // The error names only the first offender, so both had to be added.
  // Enforced by a test in grading-contract_test.ts -- adding a property without
  // adding it here reintroduces the outage.
  required: [
    "status",
    "points_earned",
    "points_available",
    "criteria",
    "highest_value_gap",
    "predicted_improvement",
    "confidence",
    "uncertainty_reason",
    "student_facing_summary",
    "action_hint",
    "repair_hint",
  ],
} as const;

// The production system prompt. Moved verbatim from the inline array
// evaluate-attempt used to build in its Deno.serve handler.
export function buildSystemPrompt(examName: string) {
  return [
    `You are Cramapple's production criterion-based grader for ${examName}.`,
    "Use only the provided released content, rubric, and student response.",
    "Score each criterion independently.",
    "Do not invent evidence.",
    "When the response is ambiguous or unsupported, mark the criterion unable_to_determine.",
    "Return only the JSON object that matches the schema.",
  ].join(" ");
}

// The production user-prompt builder. Moved verbatim (logic unchanged) from
// evaluate-attempt's former local `buildGradingPrompt`.
export function buildGradingPrompt(input: {
  operation: AllowedOperation;
  promptVersion: string;
  examName: string;
  itemTitle: string;
  itemType: string;
  stem: string;
  stimulus: string | null;
  responseText: string | null;
  responseParts: unknown;
  criteria: FeedbackCriterionRow[];
}) {
  const rubricLines = input.criteria.map((criterion) => {
    const pieces = [
      `- ${criterion.criterion_key}: ${criterion.learner_facing_text}`,
      `  points_possible: ${criterion.points_possible}`,
    ];

    if (criterion.evidence_requirements) {
      pieces.push(
        `  evidence_requirements: ${criterion.evidence_requirements}`,
      );
    }

    if (criterion.minimum_fix) {
      pieces.push(`  minimum_fix: ${criterion.minimum_fix}`);
    }

    return pieces.join("\n");
  }).join("\n");

  return [
    `You are Cramapple's production grader for ${input.examName}.`,
    `Use only the released content and rubric provided below.`,
    `Do not invent facts, claims, or criteria that are not present in the rubric.`,
    `If evidence is insufficient, mark the relevant criteria unable_to_determine and explain why.`,
    `The operation is ${input.operation}.`,
    `Prompt version: ${input.promptVersion}.`,
    `Item title: ${input.itemTitle}.`,
    `Item type: ${input.itemType}.`,
    `Stem: ${input.stem}`,
    input.stimulus ? `Stimulus: ${input.stimulus}` : "Stimulus: none",
    `Rubric:`,
    rubricLines,
    `Student response text:`,
    input.responseText ?? "",
    `Student response parts JSON:`,
    JSON.stringify(input.responseParts ?? {}, null, 2),
    `Return JSON matching the schema exactly.`,
    `For select_repair, make highest_value_gap the single highest-value missing criterion and keep repair_prompt narrow and actionable.`,
  ].join("\n\n");
}

// The production request-body builder (production_exact transport --
// OpenAI's /v1/responses shape, including the OpenAI-specific
// `reasoning.effort` field). See harness scope section 3: this is the
// literal production transport, not a normalized gateway adapter. A
// gateway-normalized adapter, if built, is a separate function -- it must
// not silently reuse this one, since doing so would misrepresent which
// transport_mode a result was actually measured under.
// OpenAI accepts the `reasoning` block only on reasoning models (o-series and
// gpt-5+). Sending it to a non-reasoning model is a hard 400:
//   "Unsupported parameter: 'reasoning.effort' is not supported with this model."
// evaluate-attempt never passes reasoningEffort, so it took the `?? "high"`
// default and sent the block unconditionally -- which rejected every FRQ
// grading request under Production's OPENAI_MODEL (gpt-4.1-mini), on top of
// the separate `required`/`properties` defect above. Both had to be fixed for
// a single grading to succeed.
export function supportsReasoningEffort(modelId: string) {
  const m = modelId.toLowerCase().replace(/^openai\//, "");
  return /^(o\d|gpt-5)/.test(m);
}

export function buildGradingRequestBody(input: {
  modelId: string;
  maxOutputTokens: number;
  systemPrompt: string;
  userPrompt: string;
  userIdHash: string;
  reasoningEffort?: "low" | "medium" | "high";
}) {
  const reasoning = supportsReasoningEffort(input.modelId)
    ? { reasoning: { effort: input.reasoningEffort ?? "high" } }
    : {};

  return {
    model: input.modelId,
    input: [
      {
        role: "system",
        content: [{ type: "input_text", text: input.systemPrompt }],
      },
      {
        role: "user",
        content: [{ type: "input_text", text: input.userPrompt }],
      },
    ],
    store: false,
    ...reasoning,
    max_output_tokens: input.maxOutputTokens,
    text: {
      format: {
        type: "json_schema",
        name: "grading_result",
        strict: true,
        schema: gradingSchema,
      },
    },
    user: input.userIdHash.slice(0, 64),
  };
}

// Extracts the structured-output text from an OpenAI /v1/responses payload.
// Moved verbatim from evaluate-attempt's former local `extractOutputText`.
export function extractOutputText(raw: Record<string, unknown>) {
  const direct = raw.output_text;
  if (typeof direct === "string" && direct.length > 0) {
    return direct;
  }

  const output = raw.output;
  if (Array.isArray(output)) {
    for (const item of output) {
      if (!item || typeof item !== "object") continue;
      const content = (item as Record<string, unknown>).content;
      if (!Array.isArray(content)) continue;
      for (const piece of content) {
        if (!piece || typeof piece !== "object") continue;
        const text = (piece as Record<string, unknown>).text;
        if (typeof text === "string" && text.length > 0) {
          return text;
        }
      }
    }
  }

  return null;
}

// Usage extraction, including cached/reasoning token breakdowns when the
// provider reports them separately (OpenAI's Responses API nests these
// under input_tokens_details/output_tokens_details). Returns null for any
// field the response doesn't carry rather than assuming zero -- an absent
// field is a different fact than a zero value and callers (cost
// reconciliation, provenance recording) need to be able to tell them apart.
export function extractUsage(raw: Record<string, unknown>) {
  const usage = raw.usage as Record<string, unknown> | undefined;
  const asNumber = (value: unknown) =>
    Number.isFinite(Number(value)) ? Number(value) : null;

  const inputDetails = usage?.input_tokens_details as
    | Record<string, unknown>
    | undefined;
  const outputDetails = usage?.output_tokens_details as
    | Record<string, unknown>
    | undefined;

  return {
    inputTokens: asNumber(usage?.input_tokens),
    outputTokens: asNumber(usage?.output_tokens),
    cachedTokens: asNumber(inputDetails?.cached_tokens),
    reasoningTokens: asNumber(outputDetails?.reasoning_tokens),
    raw: usage ?? null,
  };
}

// HTTP status classification shared between production's retry logic and
// the harness's reliability metrics (retry rate, timeout rate). A status
// in this set is worth retrying once; anything else is a fail-fast
// validation problem that will keep failing on retry.
export function isTransientHttpStatus(status: number) {
  return status === 408 || status === 425 || status === 429 || status >= 500;
}

// --- Label normalization (harness scope section 1) ---
//
// Two separate pure functions, not one mixed interface -- gold labels and
// model predictions have different shapes and should not share a
// signature. v1 policy: binary full_credit/not_full_credit scale.
// Fractional credit is explicitly out of scope for this harness (it would
// require a production schema change, which is a separate product
// migration, not harness work -- see harness scope section 1).

export const NORMALIZATION_POLICY_VERSION = "2026-07-11-v1";

export type ComparableLabel =
  | "full_credit"
  | "not_full_credit"
  | "abstained"
  | "not_applicable";

export type GoldLabel =
  | "earned"
  | "not_earned"
  | "partially_earned"
  | "unable_to_determine";

export function normalizeGoldLabel(gold: GoldLabel): ComparableLabel {
  switch (gold) {
    case "earned":
      return "full_credit";
    case "not_earned":
      // partially_earned collapses here too under the binary v1 scale --
      // a 1-point criterion has no partial state to preserve. This is a
      // real loss of information, not a hidden one: see harness scope
      // section 1.
      return "not_full_credit";
    case "partially_earned":
      return "not_full_credit";
    case "unable_to_determine":
      return "abstained";
  }
}

export function normalizeModelResult(
  status: FeedbackCriterionResult["status"],
  pointsAwarded: number,
  pointsPossible: number,
): ComparableLabel {
  switch (status) {
    case "earned":
      return pointsAwarded >= pointsPossible
        ? "full_credit"
        : "not_full_credit";
    case "not_yet_earned":
      return "not_full_credit";
    case "unable_to_determine":
      return "abstained";
    case "not_applicable":
      return "not_applicable";
  }
}

// Denominator/scoring rule for a single normalized (gold, prediction) pair.
// See harness scope section 1: overall accuracy must not exclude
// abstention/not_applicable/malformed predictions, or a model could game
// its apparent accuracy by abstaining on hard cases. This function is the
// single source of truth for that rule -- callers should not reimplement
// it inline.
export type CriterionScoreOutcome = {
  // Whether this pair counts in the "overall accuracy" denominator at all
  // (false only when gold itself is abstained -- those are scored
  // separately, not folded into ordinary accuracy).
  inOverallDenominator: boolean;
  // Overall accuracy treats abstained/not_applicable predictions as
  // incorrect, never excluded.
  overallCorrect: boolean | null;
  // Selective accuracy's denominator is only credit-decision predictions.
  inSelectiveDenominator: boolean;
  selectiveCorrect: boolean | null;
  // True when gold was itself abstained -- scored as a separate
  // "correct abstention" question, outside both accuracy numbers above.
  goldAbstained: boolean;
  correctAbstention: boolean | null;
};

export function scoreCriterionPair(
  gold: GoldLabel,
  modelStatus: FeedbackCriterionResult["status"],
  pointsAwarded: number,
  pointsPossible: number,
): CriterionScoreOutcome {
  const normalizedGold = normalizeGoldLabel(gold);
  const normalizedPrediction = normalizeModelResult(
    modelStatus,
    pointsAwarded,
    pointsPossible,
  );

  if (normalizedGold === "abstained") {
    return {
      inOverallDenominator: false,
      overallCorrect: null,
      inSelectiveDenominator: false,
      selectiveCorrect: null,
      goldAbstained: true,
      correctAbstention: normalizedPrediction === "abstained",
    };
  }

  // Gold is determinable (full_credit or not_full_credit) from here on.
  const predictionIsCreditDecision = normalizedPrediction === "full_credit" ||
    normalizedPrediction === "not_full_credit";

  return {
    inOverallDenominator: true,
    // Abstained/not_applicable predictions count as incorrect here, not
    // excluded -- this is the fix for the abstention-gaming gap.
    overallCorrect: predictionIsCreditDecision
      ? normalizedPrediction === normalizedGold
      : false,
    inSelectiveDenominator: predictionIsCreditDecision,
    selectiveCorrect: predictionIsCreditDecision
      ? normalizedPrediction === normalizedGold
      : null,
    goldAbstained: false,
    correctAbstention: null,
  };
}
