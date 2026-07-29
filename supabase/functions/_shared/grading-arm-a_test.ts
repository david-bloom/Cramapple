// Tests for Arm A: one model call per criterion, run in parallel.
//
// Origin: Production grades an item in ONE call covering every criterion,
// measured 2026-07-28 at 0.58 s + 3.89 s x n_criteria — ~16 s on a 4-criterion
// Biology FRQ. Phase C closed that shape as a dead end for latency
// (ARM_B_ROOT_CAUSE_ANALYSIS.md): the slope is the cost of generating each
// criterion's feedback serially, and the only way to flatten it is to cut
// per-criterion output to ~20 words, which would delete the feedback fields
// that are the product promise. Arm A's latency is max-of-N instead of the
// serial sum, so it is flat in criterion count.
//
// What is asserted here is the merge boundary, because that is where Arm A can
// go wrong silently: a verdict landing on the wrong criterion, a failed call
// being read as a real result, or a derived value being written into a column
// that is supposed to hold a model prediction.

import {
  composeStudentFacingSummary,
  mergeCriterionResults,
} from "./grading-contract.ts";

function source(key: string, points: number) {
  return {
    criterion_key: key,
    learner_facing_text: `criterion ${key}`,
    points_possible: points,
    evidence_requirements: null,
    minimum_fix: `fix ${key}`,
    accepted_variants: null,
  };
}

function assertEquals(actual: unknown, expected: unknown, what: string) {
  if (actual !== expected) {
    throw new Error(`${what}: expected ${expected}, got ${actual}`);
  }
}

Deno.test("a verdict cannot land on the wrong criterion", () => {
  // The model echoed the wrong key. Position is authoritative — one call was
  // issued per source criterion, in order — and the sanitizer matches by key,
  // so an unforced echo would silently move this verdict onto C1.
  const merged = mergeCriterionResults(
    [
      { criterion_key: "C1", status: "earned", points_awarded: 1 },
      { criterion_key: "C1", status: "not_yet_earned", points_awarded: 0 },
    ],
    [source("C1", 1), source("C2", 1)],
  );

  assertEquals(merged.criteria[0].criterion_key, "C1", "first key");
  assertEquals(merged.criteria[1].criterion_key, "C2", "second key");
  assertEquals(merged.criteria[1].status, "not_yet_earned", "second status");
});

Deno.test("a failed criterion call becomes an abstention, not a silent zero", () => {
  // null is the failure slot. It must not read as "the student earned nothing"
  // — that would present a transport failure to the student as a lost point.
  const merged = mergeCriterionResults(
    [{ criterion_key: "C1", status: "earned", points_awarded: 1 }, null],
    [source("C1", 1), source("C2", 2)],
  );

  assertEquals(merged.criteria[1].status, "unable_to_determine", "status");
  assertEquals(merged.criteria[1].points_awarded, 0, "points");
  assertEquals(merged.criteria[1].evidence_quote, null, "evidence");
  // Falls back to the rubric-authored fix so the student still gets guidance.
  assertEquals(merged.criteria[1].minimum_fix, "fix C2", "minimum_fix");
});

Deno.test("item confidence is the weakest criterion, not an average", () => {
  const merged = mergeCriterionResults(
    [
      { criterion_key: "C1", status: "earned", confidence: "high" },
      { criterion_key: "C2", status: "earned", confidence: "high" },
      { criterion_key: "C3", status: "not_yet_earned", confidence: "low" },
    ],
    [source("C1", 1), source("C2", 1), source("C3", 1)],
  );

  assertEquals(merged.confidence, "low", "confidence");
});

Deno.test("confidence degrades to medium when no call reported one", () => {
  const merged = mergeCriterionResults(
    [{ criterion_key: "C1", status: "earned" }],
    [source("C1", 1)],
  );

  assertEquals(merged.confidence, "medium", "confidence");
});

Deno.test("Arm A records no predicted_improvement rather than a derived one", () => {
  // grading_results scores predicted_label/predicted_point_gain against the
  // actual gain to measure how well the MODEL forecasts. Arm A makes no
  // forecast; synthesising one from the criteria would quietly corrupt that
  // measurement with a computed value dressed as a prediction.
  const merged = mergeCriterionResults(
    [{ criterion_key: "C1", status: "not_yet_earned", points_awarded: 0 }],
    [source("C1", 1)],
  );

  assertEquals(merged.predicted_improvement, null, "predicted_improvement");
});

// --- the composed summary ------------------------------------------------

Deno.test("the summary states the score and the next step", () => {
  const summary = composeStudentFacingSummary(
    [
      {
        criterion_key: "C1",
        status: "earned",
        points_awarded: 1,
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
    1,
    3,
    "name the control group",
  );

  if (!summary.includes("1 of 3 points")) {
    throw new Error(`score missing: ${summary}`);
  }
  if (!summary.includes("name the control group")) {
    throw new Error(`next step missing: ${summary}`);
  }
});

Deno.test("a full-credit summary does not invent a next step", () => {
  const summary = composeStudentFacingSummary(
    [
      {
        criterion_key: "C1",
        status: "earned",
        points_awarded: 2,
        evidence_quote: null,
        decision_explanation: null,
        minimum_fix: null,
      },
    ],
    2,
    2,
    "some leftover fix text",
  );

  if (summary.includes("some leftover fix text")) {
    throw new Error(`suggested a fix on a perfect score: ${summary}`);
  }
  if (!summary.includes("2 of 2 points")) {
    throw new Error(`score missing: ${summary}`);
  }
});

Deno.test("the summary discloses that abstained criteria are held for review", () => {
  const summary = composeStudentFacingSummary(
    [
      {
        criterion_key: "C1",
        status: "unable_to_determine",
        points_awarded: 0,
        evidence_quote: null,
        decision_explanation: null,
        minimum_fix: null,
      },
    ],
    0,
    1,
    null,
  );

  if (!summary.includes("held for review")) {
    throw new Error(`abstention not disclosed to the student: ${summary}`);
  }
});

Deno.test("summary wording is singular or plural as appropriate", () => {
  const one = composeStudentFacingSummary([], 1, 1, null);
  if (!one.includes("1 of 1 point.")) {
    throw new Error(`singular wording wrong: ${one}`);
  }
  const many = composeStudentFacingSummary([], 0, 4, null);
  if (!many.includes("0 of 4 points.")) {
    throw new Error(`plural wording wrong: ${many}`);
  }
});
