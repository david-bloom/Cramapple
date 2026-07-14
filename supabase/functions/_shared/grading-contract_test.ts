import {
  buildGradingPrompt,
  buildGradingRequestBody,
  buildSystemPrompt,
  gradingSchema,
  normalizeGoldLabel,
  normalizeModelResult,
  NORMALIZATION_POLICY_VERSION,
  scoreCriterionPair,
} from "./grading-contract.ts";

async function sha256Hex(value: string) {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

// Pins exactly what production sends, so an edit to any of these functions
// that changes their output is a visible, deliberate diff to this hash --
// not a silent drift only discoverable by comparing harness results against
// production behavior after the fact. Update the expected hash in the same
// commit as any intentional prompt/schema change.
Deno.test("grading contract snapshot: schema + system prompt + user prompt + request body are pinned", async () => {
  const schemaHash = await sha256Hex(JSON.stringify(gradingSchema));
  const systemPrompt = buildSystemPrompt("AP Statistics");
  const systemPromptHash = await sha256Hex(systemPrompt);

  const userPrompt = buildGradingPrompt({
    operation: "grade_initial_attempt",
    promptVersion: "test-v1",
    examName: "AP Statistics",
    itemTitle: "Sample Item",
    itemType: "frq",
    stem: "Calculate the mean.",
    stimulus: null,
    responseText: "The mean is 20.",
    responseParts: {},
    criteria: [
      {
        criterion_key: "mean_calculation",
        learner_facing_text: "Correctly calculates the mean",
        points_possible: 1,
        evidence_requirements: null,
        minimum_fix: null,
        accepted_variants: [],
      },
    ],
  });
  const userPromptHash = await sha256Hex(userPrompt);

  const requestBody = buildGradingRequestBody({
    modelId: "test-model",
    maxOutputTokens: 4000,
    systemPrompt,
    userPrompt,
    userIdHash: "0".repeat(64),
  });
  const requestBodyHash = await sha256Hex(JSON.stringify(requestBody));

  // These hashes are the "contract" -- if any of them change, that's a
  // signal that production and any already-run harness results have
  // diverged, and downstream comparisons need to be re-run, not silently
  // trusted. The literal values below are not meaningful on their own;
  // they exist so an unexpected diff is caught by CI.
  const expected = {
    schemaHash: "8646d9d799c548e5d668ff14922cab64c301f3d18daecd1cd3c48635ff9e94c3",
    systemPromptHash: "102b838af690407c0239c9e7cd8e4868ee6157920604ffd85a2b0228a43d254a",
    userPromptHash: "47a329d3079880d16ed126db5c6604c586e0ea412948bf4a7b20b02cd34955c4",
    requestBodyHash: "068422d7f9d4939fb4c54b0b6402a5a34c6677053f4b23fdebbe0c2adf5bb3b1",
  };
  for (const [name, actual] of Object.entries({ schemaHash, systemPromptHash, userPromptHash, requestBodyHash })) {
    if (actual !== expected[name as keyof typeof expected]) {
      throw new Error(`${name} drifted; update the pin only for an intentional contract change`);
    }
  }

  // Structural pins on the actual production transport shape (harness
  // scope section 3: production_exact means these exact fields).
  if ((requestBody as Record<string, unknown>).model !== "test-model") {
    throw new Error("request body did not carry the model field");
  }
  const reasoning =
    (requestBody as Record<string, unknown>).reasoning as
      | Record<string, unknown>
      | undefined;
  if (reasoning?.effort !== "high") {
    throw new Error(
      "request body reasoning.effort default drifted from production's 'high'",
    );
  }
  const textFormat =
    ((requestBody as Record<string, unknown>).text as Record<string, unknown>)
      .format as Record<string, unknown>;
  if (textFormat.type !== "json_schema" || textFormat.strict !== true) {
    throw new Error("request body structured-output format drifted");
  }
});

Deno.test("normalizeGoldLabel maps all four gold labels, partially_earned collapses to not_full_credit", () => {
  if (normalizeGoldLabel("earned") !== "full_credit") {
    throw new Error("earned should map to full_credit");
  }
  if (normalizeGoldLabel("not_earned") !== "not_full_credit") {
    throw new Error("not_earned should map to not_full_credit");
  }
  if (normalizeGoldLabel("partially_earned") !== "not_full_credit") {
    throw new Error(
      "partially_earned should collapse to not_full_credit under the v1 binary scale",
    );
  }
  if (normalizeGoldLabel("unable_to_determine") !== "abstained") {
    throw new Error("unable_to_determine should map to abstained");
  }
});

Deno.test("normalizeModelResult treats earned-with-partial-points as not_full_credit", () => {
  if (normalizeModelResult("earned", 1, 1) !== "full_credit") {
    throw new Error("full points earned should be full_credit");
  }
  if (normalizeModelResult("earned", 1, 3) !== "not_full_credit") {
    throw new Error(
      "earned status with partial points should not be treated as full credit",
    );
  }
  if (normalizeModelResult("not_yet_earned", 0, 1) !== "not_full_credit") {
    throw new Error("not_yet_earned should map to not_full_credit");
  }
  if (normalizeModelResult("unable_to_determine", 0, 1) !== "abstained") {
    throw new Error("unable_to_determine should map to abstained");
  }
  if (normalizeModelResult("not_applicable", 0, 1) !== "not_applicable") {
    throw new Error("not_applicable should map to its own value");
  }
});

Deno.test("scoreCriterionPair: abstention does not improve apparent overall accuracy", () => {
  // Regression test for the exact gap Codex Sol's review caught: a model
  // abstaining on a determinable, difficult case must count as incorrect
  // in overall accuracy, not be excluded from the denominator.
  const abstainOnDeterminableGold = scoreCriterionPair(
    "not_earned",
    "unable_to_determine",
    0,
    1,
  );
  if (abstainOnDeterminableGold.inOverallDenominator !== true) {
    throw new Error(
      "a prediction-side abstention on determinable gold must stay in the overall denominator",
    );
  }
  if (abstainOnDeterminableGold.overallCorrect !== false) {
    throw new Error(
      "a prediction-side abstention on determinable gold must count as incorrect in overall accuracy",
    );
  }
  if (abstainOnDeterminableGold.inSelectiveDenominator !== false) {
    throw new Error(
      "an abstention must be excluded from selective accuracy's denominator",
    );
  }

  const notApplicableOnDeterminableGold = scoreCriterionPair(
    "earned",
    "not_applicable",
    0,
    1,
  );
  if (notApplicableOnDeterminableGold.overallCorrect !== false) {
    throw new Error(
      "a not_applicable prediction on a selected (therefore applicable) criterion must count as incorrect in overall accuracy",
    );
  }
});

Deno.test("scoreCriterionPair: gold abstention is scored separately, not folded into ordinary accuracy", () => {
  const correctAbstention = scoreCriterionPair(
    "unable_to_determine",
    "unable_to_determine",
    0,
    1,
  );
  if (correctAbstention.inOverallDenominator !== false) {
    throw new Error(
      "gold abstention cases must be excluded from the overall accuracy denominator",
    );
  }
  if (correctAbstention.goldAbstained !== true) {
    throw new Error("goldAbstained flag should be set");
  }
  if (correctAbstention.correctAbstention !== true) {
    throw new Error(
      "model also abstaining on genuinely indeterminate gold should be a correct abstention",
    );
  }

  const overconfidentOnIndeterminate = scoreCriterionPair(
    "unable_to_determine",
    "earned",
    1,
    1,
  );
  if (overconfidentOnIndeterminate.correctAbstention !== false) {
    throw new Error(
      "a confident credit decision on genuinely indeterminate gold should not count as a correct abstention",
    );
  }
});

Deno.test("scoreCriterionPair: ordinary credit-decision agreement/disagreement", () => {
  const agree = scoreCriterionPair("earned", "earned", 1, 1);
  if (agree.overallCorrect !== true || agree.selectiveCorrect !== true) {
    throw new Error("matching credit decisions should score correct");
  }

  const disagree = scoreCriterionPair("earned", "not_yet_earned", 0, 1);
  if (disagree.overallCorrect !== false || disagree.selectiveCorrect !== false) {
    throw new Error("mismatched credit decisions should score incorrect");
  }
});

Deno.test("normalization policy version is recorded", () => {
  if (!NORMALIZATION_POLICY_VERSION) {
    throw new Error("NORMALIZATION_POLICY_VERSION must be set and non-empty");
  }
});
