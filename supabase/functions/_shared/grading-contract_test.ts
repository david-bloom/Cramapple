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
  buildCriterionRequestBody,
  buildGradingRequestBody,
  criterionGradingSchema,
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
