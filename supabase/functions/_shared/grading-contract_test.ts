// Regression tests for the production structured-output contract.
//
// Origin: 4 of the 5 FRQ gradings ever attempted in Production (2026-07-17)
// were rejected by OpenAI before reaching the model:
//   "Invalid schema for response_format 'grading_result': In context=(),
//    'required' is required to be supplied and to be an array including every
//    key in properties. Missing 'action_hint'."
// `action_hint` and `repair_hint` were declared in `properties` but omitted
// from `required`, which `strict: true` forbids. The API reports only the
// first offender, so a fix driven by the error text alone would have shipped
// a second identical outage.
//
// These tests assert the invariant structurally and recursively, so the same
// class cannot return via a nested object either.

import {
  applyDeterministicFlagScope,
  buildCriterionRequestBody,
  buildGradingRequestBody,
  criterionGradingSchema,
  type FeedbackCriterionResult,
  type FeedbackCriterionRow,
  gradingSchema,
  supportsReasoningEffort,
} from "./grading-contract.ts";

type Node = Record<string, unknown>;

/** Every object node with `properties` must list all of them in `required`. */
function checkNode(node: Node, path: string, failures: string[]) {
  const props = node.properties as Node | undefined;
  if (props && typeof props === "object") {
    const declared = Object.keys(props);
    const required = Array.isArray(node.required) ? node.required as string[] : [];
    const missing = declared.filter((k) => !required.includes(k));
    if (missing.length > 0) {
      failures.push(`${path}: declared but not required -> ${missing.join(", ")}`);
    }
    const extra = required.filter((k) => !declared.includes(k));
    if (extra.length > 0) {
      failures.push(`${path}: required but not declared -> ${extra.join(", ")}`);
    }
    for (const [k, v] of Object.entries(props)) {
      if (v && typeof v === "object") checkNode(v as Node, `${path}.${k}`, failures);
    }
  }
  const items = node.items as Node | undefined;
  if (items && typeof items === "object") checkNode(items, `${path}[]`, failures);
  for (const key of ["anyOf", "oneOf", "allOf"]) {
    const branch = node[key];
    if (Array.isArray(branch)) {
      branch.forEach((b, i) => {
        if (b && typeof b === "object") checkNode(b as Node, `${path}.${key}[${i}]`, failures);
      });
    }
  }
}

Deno.test("gradingSchema satisfies OpenAI strict mode at every level", () => {
  const failures: string[] = [];
  checkNode(gradingSchema as unknown as Node, "root", failures);
  if (failures.length > 0) {
    throw new Error(
      "strict-mode violations (OpenAI rejects the request before the model sees it):\n  " +
        failures.join("\n  "),
    );
  }
});

// Arm A introduces a SECOND structured-output schema, and it is subject to the
// identical strict-mode rule. A new schema is exactly how the 2026-07-17
// outage class comes back, so it is checked by the same recursive invariant
// rather than by inspection.
Deno.test("criterionGradingSchema satisfies OpenAI strict mode at every level", () => {
  const failures: string[] = [];
  checkNode(criterionGradingSchema as unknown as Node, "root", failures);
  if (failures.length > 0) {
    throw new Error(
      "strict-mode violations in the Arm A per-criterion schema:\n  " +
        failures.join("\n  "),
    );
  }
});

Deno.test("the Arm A request body requests strict mode too", () => {
  const body = buildCriterionRequestBody({
    modelId: "gpt-4.1-mini",
    maxOutputTokens: 1200,
    systemPrompt: "s",
    userPrompt: "u",
    userIdHash: "hash",
  }) as Record<string, unknown>;

  const format = (body.text as Record<string, unknown>).format as Record<
    string,
    unknown
  >;
  if (format.strict !== true) {
    throw new Error("Arm A request does not request strict mode");
  }
  if (format.name !== "criterion_grading_result") {
    throw new Error(`unexpected schema name: ${format.name}`);
  }
  // The reasoning gate must apply to this path as well: gpt-4.1-mini hard-400s
  // on reasoning.effort, and Arm A would otherwise reintroduce that failure on
  // every one of its N calls.
  if ("reasoning" in body) {
    throw new Error("Arm A sent a reasoning block to a non-reasoning model");
  }
});

Deno.test("both arms carry the partial-credit status", () => {
  const itemStatuses = (gradingSchema.properties.criteria.items.properties
    .status.enum) as readonly string[];
  const criterionStatuses = (criterionGradingSchema.properties.status
    .enum) as readonly string[];

  for (const [name, statuses] of [
    ["gradingSchema", itemStatuses],
    ["criterionGradingSchema", criterionStatuses],
  ] as const) {
    if (!statuses.includes("partially_earned")) {
      throw new Error(`${name} cannot express partial credit`);
    }
  }
  // The two arms must agree, or an item's verdict vocabulary would depend on
  // which architecture happened to grade it.
  if (itemStatuses.join(",") !== criterionStatuses.join(",")) {
    throw new Error(
      `arms disagree on statuses:\n  item:      ${itemStatuses.join(", ")}\n  criterion: ${
        criterionStatuses.join(", ")
      }`,
    );
  }
});

Deno.test("the two properties that caused the 2026-07-17 outage are required", () => {
  const required = gradingSchema.required as readonly string[];
  for (const key of ["action_hint", "repair_hint"]) {
    if (!required.includes(key)) {
      throw new Error(
        `'${key}' is declared in properties but missing from required — this is the exact ` +
          `defect that rejected 4 of 5 Production FRQ gradings.`,
      );
    }
  }
});

Deno.test("optional fields stay expressible as null rather than being omitted", () => {
  // Requiring a key is only safe if the model can still decline to supply a
  // value. Both of these must therefore admit null.
  const props = gradingSchema.properties as Record<string, { type?: unknown }>;
  for (const key of ["action_hint", "repair_hint", "uncertainty_reason"]) {
    const type = props[key]?.type;
    const admitsNull = Array.isArray(type) && (type as string[]).includes("null");
    if (!admitsNull) {
      throw new Error(`'${key}' is required but cannot be null — the model has no way to omit it.`);
    }
  }
});

Deno.test("the request body actually requests strict mode", () => {
  // If strict were ever turned off, the tests above would still pass while no
  // longer describing what production sends.
  const body = buildGradingRequestBody({
    modelId: "gpt-4.1-mini",
    maxOutputTokens: 1200,
    systemPrompt: "s",
    userPrompt: "u",
    userIdHash: "hash",
  }) as unknown as { text: { format: { strict: boolean; name: string; schema: unknown } } };

  if (body.text.format.strict !== true) {
    throw new Error("expected strict: true — the required/properties invariant only binds under strict mode");
  }
  if (body.text.format.name !== "grading_result") {
    throw new Error(`unexpected schema name: ${body.text.format.name}`);
  }
  if (body.text.format.schema !== gradingSchema) {
    throw new Error("request body no longer sends the schema these tests validate");
  }
});

// --- second Production defect, found the same way ------------------------
// Sending `reasoning.effort` to a non-reasoning model is a hard 400. Production
// never passes reasoningEffort, so it took the "high" default and sent the
// block to gpt-4.1-mini on every request.

Deno.test("reasoning block is omitted for non-reasoning models", () => {
  for (const model of ["gpt-4.1-mini", "gpt-4.1", "gpt-4o-mini", "openai/gpt-4.1-mini"]) {
    const body = buildGradingRequestBody({
      modelId: model, maxOutputTokens: 900,
      systemPrompt: "s", userPrompt: "u", userIdHash: "h",
    }) as Record<string, unknown>;
    if ("reasoning" in body) {
      throw new Error(`'reasoning' sent to ${model} — OpenAI rejects this with a 400`);
    }
  }
});

Deno.test("reasoning block is still sent for reasoning models", () => {
  for (const model of ["o3-mini", "o4-mini", "gpt-5.5", "openai/gpt-5.5"]) {
    const body = buildGradingRequestBody({
      modelId: model, maxOutputTokens: 900,
      systemPrompt: "s", userPrompt: "u", userIdHash: "h", reasoningEffort: "low",
    }) as { reasoning?: { effort?: string } };
    if (body.reasoning?.effort !== "low") {
      throw new Error(`expected reasoning.effort=low for ${model}, got ${JSON.stringify(body.reasoning)}`);
    }
  }
});

// --- applyDeterministicFlagScope (replan O2, 2026-08-13) -------------------
//
// The end-to-end composition used when a deterministic check flags a
// SUBSET of an item's criteria (per NUMERIC_ELEMENT_CRITERIA in
// statistics-verifier.ts): the model graded the whole item normally, and
// this forces just the flagged criteria back to unable_to_determine while
// recomputing everything downstream (points, status, highest_value_gap,
// summary) from the real, model-graded criteria that weren't touched.

const SOURCE_CRITERIA: FeedbackCriterionRow[] = [
  {
    criterion_key: "a-1",
    learner_facing_text: "States E(X) = -1.40.",
    points_possible: 1,
    evidence_requirements: null,
    minimum_fix: "State the expected value from the payoff table.",
    accepted_variants: [],
  },
  {
    criterion_key: "a-2",
    learner_facing_text: "States SD ~ 4.477.",
    points_possible: 1,
    evidence_requirements: null,
    minimum_fix: "Compute the standard deviation from the payoff table.",
    accepted_variants: [],
  },
  {
    criterion_key: "b-1",
    learner_facing_text: "Correctly identifies the distribution shape.",
    points_possible: 2,
    evidence_requirements: null,
    minimum_fix: "Describe whether the distribution is symmetric or skewed.",
    accepted_variants: [],
  },
];

function gradedCriteria(
  overrides: Partial<Record<string, Partial<FeedbackCriterionResult>>> = {},
): FeedbackCriterionResult[] {
  const base: FeedbackCriterionResult[] = [
    {
      criterion_key: "a-1",
      status: "earned",
      points_awarded: 1,
      evidence_quote: "E(X) = -1.40",
      decision_explanation: "Correct expected value.",
      minimum_fix: null,
    },
    {
      criterion_key: "a-2",
      status: "earned",
      points_awarded: 1,
      evidence_quote: "SD = 4.477",
      decision_explanation: "Correct standard deviation.",
      minimum_fix: null,
    },
    {
      criterion_key: "b-1",
      status: "earned",
      points_awarded: 2,
      evidence_quote: "the distribution is roughly symmetric",
      decision_explanation: "Correctly described the distribution shape.",
      minimum_fix: null,
    },
  ];
  return base.map((c) => ({ ...c, ...(overrides[c.criterion_key] ?? {}) }));
}

Deno.test("applyDeterministicFlagScope recovers points on the unaffected criterion", () => {
  const result = applyDeterministicFlagScope(
    { criteria: gradedCriteria(), points_available: 4, status: "graded" },
    SOURCE_CRITERIA,
    ["a-1", "a-2"],
    "Deterministic check flagged the keyed evidence.",
  );

  // b-1 was correctly earned by the model and is NOT in the flagged list --
  // this is the entire point of scoping over the old item-wide zeroing.
  if (result.points_earned !== 2) {
    throw new Error(`expected 2 points recovered from b-1 alone, got ${result.points_earned}`);
  }
  const b1 = result.criteria.find((c) => c.criterion_key === "b-1")!;
  if (b1.status !== "earned" || b1.points_awarded !== 2) {
    throw new Error("b-1 must keep its real model-graded verdict");
  }
});

Deno.test("applyDeterministicFlagScope forces the flagged criteria to unable_to_determine/0", () => {
  const result = applyDeterministicFlagScope(
    { criteria: gradedCriteria(), points_available: 4, status: "graded" },
    SOURCE_CRITERIA,
    ["a-1", "a-2"],
    "Deterministic check flagged the keyed evidence.",
  );
  for (const key of ["a-1", "a-2"]) {
    const c = result.criteria.find((x) => x.criterion_key === key)!;
    if (c.status !== "unable_to_determine" || c.points_awarded !== 0) {
      throw new Error(`${key} must be forced to unable_to_determine/0, got ${c.status}/${c.points_awarded}`);
    }
  }
});

Deno.test("applyDeterministicFlagScope marks the item uncertain even though every OTHER criterion resolved cleanly", () => {
  const result = applyDeterministicFlagScope(
    { criteria: gradedCriteria(), points_available: 4, status: "graded" },
    SOURCE_CRITERIA,
    ["a-1", "a-2"],
    "unused",
  );
  if (result.status !== "uncertain") {
    throw new Error(`expected "uncertain" (matches sanitizeModelResult's own any-abstention rule), got ${result.status}`);
  }
});

Deno.test("applyDeterministicFlagScope stays uncertain if the pre-override status already was", () => {
  const result = applyDeterministicFlagScope(
    {
      criteria: gradedCriteria({
        "b-1": { status: "unable_to_determine", points_awarded: 0 },
      }),
      points_available: 4,
      status: "uncertain",
    },
    SOURCE_CRITERIA,
    ["a-1", "a-2"],
    "unused",
  );
  if (result.status !== "uncertain") {
    throw new Error("a payload that was already uncertain must stay uncertain");
  }
});

Deno.test("applyDeterministicFlagScope recomputes highest_value_gap from the post-override criteria", () => {
  const result = applyDeterministicFlagScope(
    { criteria: gradedCriteria(), points_available: 4, status: "graded" },
    SOURCE_CRITERIA,
    ["a-1", "a-2"],
    "Deterministic check flagged the keyed evidence.",
  );
  if (!result.highest_value_gap || result.highest_value_gap.criterion_key === "b-1") {
    throw new Error("highest_value_gap must point at one of the newly-forced criteria (b-1 is resolved and earned, not a gap)");
  }
});

Deno.test("applyDeterministicFlagScope's summary reflects the forced hold, not the model's original 'fully scored' claim", () => {
  const result = applyDeterministicFlagScope(
    { criteria: gradedCriteria(), points_available: 4, status: "graded" },
    SOURCE_CRITERIA,
    ["a-1", "a-2"],
    "unused",
  );
  if (!/could not be decided/.test(result.student_facing_summary)) {
    throw new Error(`summary must mention the held criteria, got: ${result.student_facing_summary}`);
  }
  if (!/earned 2 of 4/.test(result.student_facing_summary)) {
    throw new Error(`summary must state the recomputed points (2 of 4), got: ${result.student_facing_summary}`);
  }
});

Deno.test("supportsReasoningEffort classifies the models we actually use", () => {
  const cases: Array<[string, boolean]> = [
    ["gpt-4.1-mini", false],   // Production's OPENAI_MODEL today
    ["gpt-4o", false],
    ["o3-mini", true],
    ["gpt-5.5", true],         // used by the SP-1 pilot scripts
    ["openai/gpt-5.5", true],  // gateway-prefixed form
  ];
  for (const [model, want] of cases) {
    if (supportsReasoningEffort(model) !== want) {
      throw new Error(`supportsReasoningEffort(${model}) = ${!want}, expected ${want}`);
    }
  }
});
