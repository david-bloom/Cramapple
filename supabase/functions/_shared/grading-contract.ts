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
  overrideCriteriaAsUnresolved,
  pickHighestGap,
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
              // Added 2026-07-28. 20% of Production criteria are multi-point
              // and partial credit is intended, but the model had no way to
              // express it: the enum forced an all-or-nothing status onto a
              // 3-point criterion. It could only signal partial credit through
              // points_awarded, which the sanitizer then treated as a
              // contradiction and zeroed.
              "partially_earned",
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

// --- Arm A: one model call per criterion ---------------------------------
//
// Production issues ONE call grading every criterion of an item. Measured in
// Production 2026-07-28: latency = 0.58 s + 3.89 s x n_criteria, so a
// 4-criterion Biology FRQ takes ~16 s. That is the shape Phase C closed as a
// dead end (ARM_B_ROOT_CAUSE_ANALYSIS.md): the per-criterion slope is the cost
// of generating one criterion's feedback serially, and the only way to flatten
// it is to cut per-criterion output to roughly 20 words total -- which would
// win the latency benchmark by deleting the feedback fields that are the
// product promise.
//
// Arm A grades each criterion in its own call, in parallel, so item latency is
// max-of-N rather than the serial sum and is flat in criterion count. Phase C
// measured it at n=100: per-call p50 1,437 ms with no fat tail (max/p50 = 2.2),
// item p50 1,712 ms against a corpus averaging 4.4 criteria.
//
// Two costs, both real and both accepted under the standing Speed > Quality >
// Cost priority:
//   - Input tokens rise ~3.6x, because the stem and stimulus are re-sent once
//     per criterion. Phase C: $0.0045/FRQ vs $0.0019 on gemini-2.5-flash.
//   - Criterion agreement was 2.8 pp LOWER for Arm A across two slices
//     (90.6% vs 93.4% pooled). NOT statistically significant at that n and it
//     must not be reported as a finding, but the plausible mechanism -- seeing
//     all criteria in one context reduces criterion-boundary confusion -- is
//     worth watching when this goes live.
//
// Note the Phase C numbers were measured on google/gemini-2.5-flash via the
// Vercel AI Gateway. Production runs gpt-4.1-mini, which is materially slower
// (3.89 s/criterion vs 0.637), so expect Arm A item latency near Production's
// own measured 1-criterion figure of ~4.5 s, not Phase C's 1.7 s.

// The per-criterion output schema: exactly the criterion object from
// gradingSchema, plus a per-criterion confidence. Item-level fields are
// deliberately absent -- asking each of N parallel calls for a whole-item
// summary would produce N contradictory summaries, and every other item-level
// field is derived from the criteria anyway (see mergeCriterionResults).
export const criterionGradingSchema = {
  type: "object",
  additionalProperties: false,
  properties: {
    criterion_key: { type: "string" },
    status: {
      type: "string",
      enum: [
        "earned",
        "partially_earned",
        "not_yet_earned",
        "unable_to_determine",
        "not_applicable",
      ],
    },
    points_awarded: { type: "integer" },
    evidence_quote: { type: ["string", "null"] },
    decision_explanation: { type: ["string", "null"] },
    minimum_fix: { type: ["string", "null"] },
    confidence: {
      type: "string",
      enum: ["high", "medium", "low"],
    },
  },
  // Every property must be listed: strict:true rejects the request otherwise,
  // and the API names only the first offender. This is the defect that kept 4
  // of the 5 FRQ gradings ever attempted in Production from reaching the model.
  required: [
    "criterion_key",
    "status",
    "points_awarded",
    "evidence_quote",
    "decision_explanation",
    "minimum_fix",
    "confidence",
  ],
} as const;

export function buildCriterionSystemPrompt(examName: string) {
  return [
    `You are Cramapple's production criterion-based grader for ${examName}.`,
    "You are grading exactly ONE criterion of a free-response question.",
    "Use only the provided released content, rubric, and student response.",
    "Do not invent evidence.",
    // Criterion isolation is the point of this architecture and also its main
    // risk: without the other criteria in context the grader can drift into
    // judging the response as a whole. Phase C's frozen Arm A prompt carried
    // the same instruction.
    "Judge only the criterion given below. Do not withhold its points because of a fault that belongs to a different criterion.",
    "A criterion worth more than one point may be awarded part of its points: use partially_earned with the number of points genuinely evidenced.",
    "Use earned only for the criterion's full points, and not_yet_earned only when nothing creditable is present.",
    "Error carry forward: when this criterion uses a value the student computed incorrectly earlier, judge the method and reasoning shown here and do not withhold points solely because that inherited value is wrong.",
    "When the response is ambiguous or unsupported, mark the criterion unable_to_determine rather than guessing.",
    "evidence_quote must be an exact substring of the student response, or null.",
    "Return only the JSON object that matches the schema.",
  ].join(" ");
}

export function buildCriterionGradingPrompt(input: {
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
  criterion: FeedbackCriterionRow;
  exemplars?: GradingExemplar[];
}) {
  const criterion = input.criterion;

  // Every call gets the FULL rubric, and grades one criterion of it.
  //
  // The first version sent only the target criterion. That is where Arm A's
  // measured quality regression came from: on a 2-point criterion wanting both
  // "steep rise" and "flattens out", a response saying only "it ends up flat at
  // the top" was awarded full marks in 3 of 3 trials, because with nothing else
  // in view a partial description reads as a complete one. Arm B, seeing all
  // four criteria, was correct in 3 of 3.
  //
  // Withholding the sibling criteria was purely a cost saving -- it is the only
  // thing Arm A was buying by not re-sending them. At ~$0.002/FRQ, under the
  // standing Quality > Speed > Cost order, that is not a trade worth making.
  // Restoring the context targets the exact mechanism Phase C proposed for Arm
  // B's +2.8 pp criterion-agreement edge: seeing all criteria at once reduces
  // criterion-boundary confusion.
  //
  // Latency is unaffected -- input tokens are prefill, not serial generation,
  // and generation is what Arm B's 3.89 s/criterion slope was made of.
  const siblings = input.criteria
    .filter((row) => row.criterion_key !== criterion.criterion_key)
    .map((row) =>
      `- ${row.criterion_key} (${row.points_possible} pt): ${row.learner_facing_text}`
    );
  const contract = [
    `  criterion_key: ${criterion.criterion_key}`,
    `  points_possible: ${criterion.points_possible}`,
    `  learner_facing_text: ${criterion.learner_facing_text}`,
  ];
  if (criterion.evidence_requirements) {
    contract.push(`  evidence_requirements: ${criterion.evidence_requirements}`);
  }
  if (criterion.minimum_fix) {
    contract.push(`  minimum_fix (rubric-authored): ${criterion.minimum_fix}`);
  }
  if (criterion.accepted_variants) {
    contract.push(
      `  accepted_variants: ${JSON.stringify(criterion.accepted_variants)}`,
    );
  }
  if (criterion.points_possible > 1) {
    contract.push(
      `  award: any whole number of points from 0 to ${criterion.points_possible}; use partially_earned for anything in between`,
    );
  }

  return [
    `You are Cramapple's production grader for ${input.examName}.`,
    `Use only the released content and criterion contract provided below.`,
    `Do not invent facts, claims, or criteria that are not present in the contract.`,
    `points_awarded must match the status: equal to points_possible for earned, strictly between 0 and points_possible for partially_earned, and 0 otherwise.`,
    `The operation is ${input.operation}.`,
    `Prompt version: ${input.promptVersion}.`,
    `Item title: ${input.itemTitle}.`,
    `Item type: ${input.itemType}.`,
    `Stem: ${input.stem}`,
    input.stimulus ? `Stimulus: ${input.stimulus}` : "Stimulus: none",
    `Criterion contract (grade THIS criterion only):`,
    contract.join("\n"),
    // Siblings are context, never targets. Naming them explicitly is what stops
    // a partial answer to one criterion reading as a complete answer, while the
    // "do not grade" framing keeps the verdict scoped to the one criterion this
    // call is responsible for.
    siblings.length > 0
      ? [
        `The other criteria on this item, for context only — do NOT grade them and do NOT report on them:`,
        siblings.join("\n"),
        `Use them only to judge whether the response's treatment of YOUR criterion is complete, rather than assuming any relevant statement it makes was aimed at your criterion.`,
      ].join("\n")
      : `This item has no other criteria.`,
    renderExemplarSection(input.exemplars),
    `Student response text:`,
    input.responseText ?? "",
    `Student response parts JSON:`,
    JSON.stringify(input.responseParts ?? {}, null, 2),
    `Return JSON matching the schema exactly, with criterion_key set to ${criterion.criterion_key}.`,
  ].filter(Boolean).join("\n\n");
}

export function buildCriterionRequestBody(input: {
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
        name: "criterion_grading_result",
        strict: true,
        schema: criterionGradingSchema,
      },
    },
    user: input.userIdHash.slice(0, 64),
  };
}

// Composes the one student-visible field Arm A cannot get from the model.
//
// Under Arm B the model writes student_facing_summary having seen the whole
// item. Under Arm A no single call sees the whole item, so the summary is
// composed from the verdicts instead. This is a deliberate trade: the text is
// plainer than model prose, but it is derived from the awarded points and so
// cannot contradict them -- which the model-written summary could.
export function composeStudentFacingSummary(
  criteria: FeedbackCriterionResult[],
  pointsEarned: number,
  pointsAvailable: number,
  topGapMinimumFix: string | null,
): string {
  const undecided = criteria.filter((criterion) =>
    criterion.status === "unable_to_determine"
  ).length;

  const scored = pointsAvailable > 0
    ? `You earned ${pointsEarned} of ${pointsAvailable} point${
      pointsAvailable === 1 ? "" : "s"
    }.`
    : "Your response was scored.";

  const parts = [scored];
  if (pointsEarned < pointsAvailable && topGapMinimumFix) {
    parts.push(`The most valuable next step: ${topGapMinimumFix}`);
  }
  if (undecided > 0) {
    parts.push(
      `${undecided} criter${
        undecided === 1 ? "ion" : "ia"
      } could not be decided from what you wrote, so this result is being held for review.`,
    );
  }
  return parts.join(" ");
}

// Per-criterion deterministic flag scoping (replan O2, 2026-08-13). Applied
// AFTER a normal, successful model grading -- takes the model's real,
// sanitized verdicts and forces only the criteria a deterministic check's
// numeric evidence belongs to back to unable_to_determine, recomputing
// everything that depends on the criteria array so the result is internally
// consistent (a stale points_earned or highest_value_gap pointing at a
// criterion that no longer reflects reality would be worse than not scoping
// at all). This replaces zeroing every criterion on the item regardless of
// which ones the flagged evidence actually concerns.
export function applyDeterministicFlagScope(
  payload: {
    criteria: FeedbackCriterionResult[];
    points_available: number;
    status: "graded" | "uncertain";
  },
  sourceCriteria: FeedbackCriterionRow[],
  criterionKeys: string[],
  reason: string,
) {
  const criteria = overrideCriteriaAsUnresolved(
    payload.criteria,
    criterionKeys,
    reason,
  );
  const pointsEarned = criteria.reduce(
    (sum, criterion) => sum + criterion.points_awarded,
    0,
  );
  const highestValueGap = pickHighestGap(criteria, sourceCriteria);
  // Matches sanitizeModelResult's own rule: any unable_to_determine
  // criterion makes the whole item "uncertain," even when every other
  // criterion resolved cleanly -- scoping narrows WHICH criteria are held,
  // not whether an item with a live hold can still claim to be fully graded.
  const status = criteria.some((criterion) =>
      criterion.status === "unable_to_determine"
    )
    ? "uncertain" as const
    : payload.status;

  return {
    criteria,
    points_earned: pointsEarned,
    status,
    highest_value_gap: highestValueGap,
    student_facing_summary: composeStudentFacingSummary(
      criteria,
      pointsEarned,
      payload.points_available,
      highestValueGap?.minimum_fix ?? null,
    ),
  };
}

// Folds N per-criterion model results into the object shape sanitizeModelResult
// already consumes, so the entire sanitize/grounding/partial-credit path is
// shared between arms rather than reimplemented for one of them.
//
// A criterion whose call failed is passed through as unable_to_determine with a
// null evidence_quote, which the sanitizer converts into an integrity issue and
// therefore into an uncertain grading. This is strictly better than Arm B,
// where one failed call loses every criterion on the item.
export function mergeCriterionResults(
  results: Array<Record<string, unknown> | null>,
  sourceCriteria: FeedbackCriterionRow[],
) {
  const criteria = sourceCriteria.map((source, index) => {
    const raw = results[index];
    if (!raw) {
      return {
        criterion_key: source.criterion_key,
        status: "unable_to_determine",
        points_awarded: 0,
        evidence_quote: null,
        decision_explanation:
          "This criterion could not be graded on this attempt.",
        minimum_fix: source.minimum_fix,
      };
    }
    // Force the key: a model echoing the wrong criterion_key would otherwise
    // land this verdict on a different criterion, and the sanitizer matches by
    // key. Position is authoritative here because we issued one call per
    // source criterion, in order.
    return { ...raw, criterion_key: source.criterion_key };
  });

  const confidences = results
    .map((raw) => (raw?.confidence as string | undefined))
    .filter((value): value is string =>
      value === "high" || value === "medium" || value === "low"
    );
  // Weakest link, not an average: an item is only as trustworthy as its least
  // confident criterion.
  const confidence = confidences.length === 0
    ? "medium"
    : confidences.includes("low")
    ? "low"
    : confidences.includes("medium")
    ? "medium"
    : "high";

  return {
    criteria,
    confidence,
    uncertainty_reason: null,
    // Deliberately null rather than derived. predicted_improvement is a model
    // forecast that grading_results scores for calibration
    // (predicted_label/predicted_point_gain/prediction_outcome). Synthesising
    // one from the criteria would put a computed value into a column whose
    // whole purpose is to measure how well the MODEL predicts, quietly
    // corrupting that measurement. Arm A makes no forecast, and records none.
    predicted_improvement: null,
    // Item-level hint has no per-criterion equivalent; the caller already
    // falls back to the deterministic-check hint when this is null.
    action_hint: null,
    // Replaced by the caller once points and the top gap are known.
    student_facing_summary: null,
  };
}

// The production system prompt. Moved verbatim from the inline array
// evaluate-attempt used to build in its Deno.serve handler.
export function buildSystemPrompt(examName: string) {
  return [
    `You are Cramapple's production criterion-based grader for ${examName}.`,
    "Use only the provided released content, rubric, and student response.",
    "Judge each criterion on its own rubric text.",
    "Do not invent evidence.",
    // Partial credit has to be stated here, not just permitted by the schema.
    // Removing the sanitizer's zeroing lets a partial award survive; it does
    // not cause one. Nothing in the prompt previously told the grader it could
    // award fewer points than points_possible, so on a 3-point criterion it
    // had no reason to ever return 1 or 2.
    "A criterion worth more than one point may be awarded part of its points: use partially_earned with the number of points genuinely evidenced.",
    "Use earned only for the criterion's full points, and not_yet_earned only when nothing creditable is present.",
    // Error carry forward, in the only form a grader without a rubric
    // dependency graph can apply: do not double-punish a downstream step.
    // The structural version of ECF -- knowing which part feeds which -- lives
    // in the deterministic verifier, which has explicit dependency keys.
    "Error carry forward: when a criterion uses a value the student computed incorrectly earlier, judge the method and reasoning shown for this criterion and do not withhold its points solely because that inherited value is wrong.",
    "When the response is ambiguous or unsupported, mark the criterion unable_to_determine.",
    "Return only the JSON object that matches the schema.",
  ].join(" ");
}

// The production user-prompt builder. Moved verbatim (logic unchanged) from
// evaluate-attempt's former local `buildGradingPrompt`.
export type GradingExemplar = {
  answer_text: string;
  criteria: Array<
    { criterion_key: string; gold_label: string; evidence_quote?: string | null }
  >;
};

// Renders a small set of verified exemplar answers as a labelled few-shot
// section. Exemplars come from a DIFFERENT item than the one being graded
// (never the item's own answer key) -- see
// docs/research/exemplar_grading_pilot_2026_08/ for the pilot this exists for.
// Returns "" when there are no exemplars, so callers can splice it in
// unconditionally without an extra branch.
function renderExemplarSection(exemplars: GradingExemplar[] | undefined) {
  if (!exemplars?.length) return "";
  const blocks = exemplars.map((exemplar, index) => {
    const criteriaLines = exemplar.criteria.map((criterion) =>
      criterion.evidence_quote
        ? `  - ${criterion.criterion_key}: ${criterion.gold_label} (evidence: "${criterion.evidence_quote}")`
        : `  - ${criterion.criterion_key}: ${criterion.gold_label}`
    ).join("\n");
    return [
      `Exemplar ${index + 1} (a verified answer to a DIFFERENT question on the same topic -- reference only, do not compare the student response to it directly):`,
      `  Answer: ${exemplar.answer_text}`,
      `  Verified per-criterion outcome:`,
      criteriaLines,
    ].join("\n");
  }).join("\n\n");
  return [
    `Worked exemplars (for calibration only -- these grade a different question; judge the actual rubric below on its own terms):`,
    blocks,
  ].join("\n\n");
}

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
  exemplars?: GradingExemplar[];
}) {
  const rubricLines = input.criteria.map((criterion) => {
    const pieces = [
      `- ${criterion.criterion_key}: ${criterion.learner_facing_text}`,
      `  points_possible: ${criterion.points_possible}`,
    ];

    // Spell out the award range per criterion rather than relying on the
    // system prompt alone. Multi-point criteria are the minority (20% of the
    // Production bank), so a global instruction is easy for the model to
    // overlook on the item where it actually applies.
    if (criterion.points_possible > 1) {
      pieces.push(
        `  award: any whole number of points from 0 to ${criterion.points_possible}; use partially_earned for anything in between`,
      );
    }

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
    `points_awarded must match the status: equal to points_possible for earned, strictly between 0 and points_possible for partially_earned, and 0 otherwise.`,
    `The operation is ${input.operation}.`,
    `Prompt version: ${input.promptVersion}.`,
    `Item title: ${input.itemTitle}.`,
    `Item type: ${input.itemType}.`,
    `Stem: ${input.stem}`,
    input.stimulus ? `Stimulus: ${input.stimulus}` : "Stimulus: none",
    `Rubric:`,
    rubricLines,
    renderExemplarSection(input.exemplars),
    `Student response text:`,
    input.responseText ?? "",
    `Student response parts JSON:`,
    JSON.stringify(input.responseParts ?? {}, null, 2),
    `Return JSON matching the schema exactly.`,
    `For select_repair, make highest_value_gap the single highest-value missing criterion and keep repair_prompt narrow and actionable.`,
  ].filter(Boolean).join("\n\n");
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
    case "partially_earned":
      // Collapses to not_full_credit under the binary v1 scale, exactly as
      // the `partially_earned` GOLD label already does above. The harness
      // measures full-credit agreement; scoring partial awards on their own
      // scale is a separate change to this policy version, not a side effect
      // of the production schema gaining the status.
      return "not_full_credit";
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
