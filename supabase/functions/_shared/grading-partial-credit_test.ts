// Tests for partial credit and for the uncertainty message.
//
// Origin: `sanitizeModelResult` converted any `earned` criterion whose award
// was not exactly points_possible into unable_to_determine with ZERO points,
// and the resulting integrity issue marked the whole grading uncertain. A
// student earning 2 of 3 points received 0 points and an "uncertain" verdict.
// 601 of 2,969 Production criteria are multi-point (382 at 2, 219 at 3) and
// 124 of those are on published items. Partial credit is intended behaviour
// (owner decision, 2026-07-28), so the old rule was systematic under-credit
// across a fifth of the bank.
//
// The zeroing guard was not simply deleted. A credit status paired with a zero
// award is still a hard integrity failure — that combination has no internally
// consistent reading — and the "must be evidenced" rule now covers
// partially_earned too. Both directions are asserted below.

import {
  buildUncertaintyReason,
  pickHighestGap,
  sanitizeModelResult,
} from "./grading-feedback.ts";

const RESPONSE =
  "The mean increases because the added value is above the old mean, and the standard deviation grows since the spread widens.";

function criterion(key: string, points: number) {
  return {
    criterion_key: key,
    learner_facing_text: `criterion ${key}`,
    points_possible: points,
    evidence_requirements: null,
    minimum_fix: `fix ${key}`,
    accepted_variants: null,
  };
}

function modelCriterion(
  key: string,
  status: string,
  points: number,
  // Case-exact substring of RESPONSE: grounding deliberately does not
  // lowercase, so "The mean increases" would not match "the mean increases".
  evidence: string | null = "the added value is above the old mean",
) {
  return {
    criterion_key: key,
    status,
    points_awarded: points,
    evidence_quote: evidence,
    decision_explanation: "because",
    minimum_fix: null,
  };
}

function grade(
  sources: ReturnType<typeof criterion>[],
  criteria: ReturnType<typeof modelCriterion>[],
) {
  return sanitizeModelResult(
    {
      criteria,
      student_facing_summary: "summary",
      confidence: "high",
      uncertainty_reason: null,
    },
    sources,
    { responseText: RESPONSE, responseParts: null },
  );
}

function assertEquals(actual: unknown, expected: unknown, what: string) {
  if (actual !== expected) {
    throw new Error(`${what}: expected ${expected}, got ${actual}`);
  }
}

// --- the regression itself ----------------------------------------------

Deno.test("a 2-of-3 award survives as partial credit instead of being zeroed", () => {
  const result = grade(
    [criterion("C1", 3)],
    [modelCriterion("C1", "earned", 2)],
  );

  assertEquals(result.criteria[0].status, "partially_earned", "status");
  assertEquals(result.criteria[0].points_awarded, 2, "points");
  assertEquals(result.points_earned, 2, "points_earned");
  // The whole grading must stay `graded`. Under the old rule this single
  // partial award produced an integrity issue and dragged the item to
  // `uncertain`, which is what made the defect systemic rather than cosmetic.
  assertEquals(result.status, "graded", "grading status");
  assertEquals(result.integrity_issues.length, 0, "integrity issues");
  // Reconciling `earned` down to `partially_earned` is recorded, but softly.
  assertEquals(result.normalizations.length, 1, "normalizations");
  assertEquals(result.normalizations[0].to, "partially_earned", "reconciled to");
});

Deno.test("the model may state partially_earned directly, with no reconciliation", () => {
  const result = grade(
    [criterion("C1", 3)],
    [modelCriterion("C1", "partially_earned", 2)],
  );

  assertEquals(result.criteria[0].status, "partially_earned", "status");
  assertEquals(result.criteria[0].points_awarded, 2, "points");
  assertEquals(result.status, "graded", "grading status");
  assertEquals(result.normalizations.length, 0, "normalizations");
});

Deno.test("full points on a multi-point criterion is still plain earned", () => {
  const result = grade(
    [criterion("C1", 3)],
    [modelCriterion("C1", "earned", 3)],
  );

  assertEquals(result.criteria[0].status, "earned", "status");
  assertEquals(result.criteria[0].points_awarded, 3, "points");
  assertEquals(result.status, "graded", "grading status");
});

Deno.test("partially_earned claiming full points is promoted to earned", () => {
  const result = grade(
    [criterion("C1", 2)],
    [modelCriterion("C1", "partially_earned", 2)],
  );

  assertEquals(result.criteria[0].status, "earned", "status");
  assertEquals(result.status, "graded", "grading status");
  assertEquals(result.normalizations.length, 1, "normalizations");
});

Deno.test("an over-award is clamped to points_possible, not accepted", () => {
  const result = grade(
    [criterion("C1", 3)],
    [modelCriterion("C1", "partially_earned", 9)],
  );

  assertEquals(result.criteria[0].points_awarded, 3, "points");
  assertEquals(result.criteria[0].status, "earned", "status");
});

Deno.test("single-point criteria are unaffected by the partial-credit change", () => {
  const result = grade(
    [criterion("C1", 1), criterion("C2", 1)],
    [
      modelCriterion("C1", "earned", 1),
      modelCriterion("C2", "not_yet_earned", 0, null),
    ],
  );

  assertEquals(result.criteria[0].status, "earned", "earned status");
  assertEquals(result.criteria[1].status, "not_yet_earned", "unearned status");
  assertEquals(result.points_earned, 1, "points_earned");
  assertEquals(result.status, "graded", "grading status");
  assertEquals(result.normalizations.length, 0, "normalizations");
});

// --- guards that must NOT have been relaxed ------------------------------

Deno.test("a credit status awarding zero points is still a hard integrity failure", () => {
  // No charitable reading: the model claims the student earned the criterion
  // and simultaneously awards nothing. This is the case the old blanket
  // mismatch check existed for, and it keeps its old behaviour.
  const result = grade(
    [criterion("C1", 3)],
    [modelCriterion("C1", "earned", 0)],
  );

  assertEquals(result.criteria[0].status, "unable_to_determine", "status");
  assertEquals(result.criteria[0].points_awarded, 0, "points");
  assertEquals(result.status, "uncertain", "grading status");
  assertEquals(result.integrity_issues.length, 1, "integrity issues");
  assertEquals(
    result.integrity_issues[0].code,
    "earned_points_mismatch",
    "issue code",
  );
});

Deno.test("partial credit still has to be evidenced", () => {
  // The evidence requirement previously keyed off `earned` alone. If it had
  // not been widened, partially_earned would have been an unevidenced-credit
  // hole straight through the grounding check.
  const result = grade(
    [criterion("C1", 3)],
    [modelCriterion("C1", "partially_earned", 2, null)],
  );

  assertEquals(result.criteria[0].status, "unable_to_determine", "status");
  assertEquals(result.criteria[0].points_awarded, 0, "points");
  assertEquals(
    result.integrity_issues[0].code,
    "earned_without_evidence",
    "issue code",
  );
});

Deno.test("partial credit with ungrounded evidence is refused", () => {
  const result = grade(
    [criterion("C1", 3)],
    [modelCriterion("C1", "partially_earned", 2, "a quote the student never wrote")],
  );

  assertEquals(result.criteria[0].status, "unable_to_determine", "status");
  assertEquals(
    result.integrity_issues[0].code,
    "evidence_not_found",
    "issue code",
  );
});

// --- repair targeting ----------------------------------------------------

Deno.test("the repair target is ranked by points remaining, not face value", () => {
  // C1 is worth 3 but already has 2, leaving 1. C2 is worth 2 with none
  // earned, leaving 2. C2 is the better repair even though C1 is the
  // higher-value criterion — under the old face-value scoring C1 won.
  const sources = [criterion("C1", 3), criterion("C2", 2)];
  const gap = pickHighestGap(
    [
      {
        criterion_key: "C1",
        status: "partially_earned",
        points_awarded: 2,
        evidence_quote: null,
        decision_explanation: null,
        minimum_fix: null,
      },
      {
        criterion_key: "C2",
        status: "not_yet_earned",
        points_awarded: 0,
        evidence_quote: null,
        decision_explanation: null,
        minimum_fix: null,
      },
    ],
    sources,
  );

  assertEquals(gap?.criterion_key, "C2", "repair target");
});

// --- the uncertainty message ---------------------------------------------
//
// Origin: every uncertain grading was worded as an integrity failure, so one
// that went uncertain purely because the grader abstained emitted the literal
// string "Grading output failed 0 integrity check(s)" — observed live on
// 2026-07-28. That reads to a tutor as a broken grader rather than as the
// grader correctly declining to guess.

Deno.test("abstention alone is not described as an integrity failure", () => {
  const reason = buildUncertaintyReason(0, 1);
  if (reason.includes("integrity")) {
    throw new Error(`abstention worded as integrity failure: ${reason}`);
  }
  if (!reason.includes("could not reach a decision")) {
    throw new Error(`abstention not described: ${reason}`);
  }
});

Deno.test("the '0 integrity check(s)' string can no longer be produced", () => {
  for (let abstentions = 1; abstentions <= 4; abstentions++) {
    const reason = buildUncertaintyReason(0, abstentions);
    if (reason.includes("0 integrity")) {
      throw new Error(`still emits a zero count: ${reason}`);
    }
  }
});

Deno.test("a real integrity failure is still reported as one", () => {
  const reason = buildUncertaintyReason(2, 0);
  if (!reason.includes("failed 2 integrity checks")) {
    throw new Error(`integrity failure not described: ${reason}`);
  }
});

Deno.test("both causes are reported when both are present", () => {
  const reason = buildUncertaintyReason(1, 2);
  if (!reason.includes("1 integrity check.")) {
    throw new Error(`singular integrity wording wrong: ${reason}`);
  }
  if (!reason.includes("2 criteria")) {
    throw new Error(`plural abstention wording wrong: ${reason}`);
  }
});

Deno.test("an abstaining grading reports abstention, end to end", () => {
  const result = grade(
    [criterion("C1", 1)],
    [modelCriterion("C1", "unable_to_determine", 0, null)],
  );

  assertEquals(result.status, "uncertain", "grading status");
  assertEquals(result.integrity_issues.length, 0, "integrity issues");
  if (result.uncertainty_reason?.includes("integrity")) {
    throw new Error(
      `abstention reported as integrity failure: ${result.uncertainty_reason}`,
    );
  }
});
