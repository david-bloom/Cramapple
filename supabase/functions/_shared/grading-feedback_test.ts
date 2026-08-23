// Tests for evidence grounding.
//
// Origin: the one Production FRQ grading that actually executed (2026-07-17)
// came back "failed 3 integrity check(s)". Measured against 2,973 real grader
// outputs, the raw `response.includes(quote)` rule flagged 10.19% of graded
// criteria, and ~64% of those were false alarms caused by nothing worse than a
// collapsed newline. A flag is not advisory -- it forces the criterion to
// unable_to_determine and zeroes its points -- so the brittle match was
// silently withholding earned credit.
//
// The check still has to REFUSE paraphrase and invention. Both directions are
// asserted below; loosening it until the second group passes would defeat the
// purpose of having it.

import {
  buildDeterministicGradedPayload,
  evidenceIsGrounded,
  type FeedbackCriterionRow,
  overrideCriteriaAsUnresolved,
} from "./grading-feedback.ts";

const RESPONSE = [
  "(a) The four corners are the ones given: (V0, P0), (V0, 3P0), (2V0, 3P0).",
  "Over one full cycle the gas comes back to the exact same P and V,",
  "so it's the same state it began in and Delta U = 0.",
  "",
  "(b) f'(x) = 1 - 9x^-2 = 1 - 9/x^2",
  "Set f'(x) = 0: 1 = 9/x^2, so x^2 = 9, so x = 3 or x = -3.",
  "Only x = 3 is in the domain, so that's the one I use.",
].join("\n");

function ok(name: string, quote: string) {
  Deno.test(`grounded: ${name}`, () => {
    if (!evidenceIsGrounded(quote, RESPONSE)) {
      throw new Error(`expected grounded, was flagged: ${quote}`);
    }
  });
}

function rejected(name: string, quote: string) {
  Deno.test(`flagged: ${name}`, () => {
    if (evidenceIsGrounded(quote, RESPONSE)) {
      throw new Error(`expected flagged, was accepted: ${quote}`);
    }
  });
}

// --- must be accepted: real spans the model merely reformatted ------------
ok("exact substring", "Only x = 3 is in the domain");
ok(
  "span crossing a newline (the dominant false alarm)",
  "Over one full cycle the gas comes back to the exact same P and V, so it's the same state it began in",
);
ok("curly apostrophe for straight", "so it’s the same state it began in");
ok(
  "elided middle with ...",
  "f'(x) = 1 - 9x^-2 = 1 - 9/x^2 ... Only x = 3 is in the domain",
);
ok(
  "elided middle with bracketed [...]",
  "The four corners are the ones given [...] Delta U = 0.",
);
ok("unicode ellipsis character", "Set f'(x) = 0: 1 = 9/x^2 … Only x = 3 is in the domain");
ok("leading and trailing whitespace", "   Delta U = 0.   ");

// --- must still be flagged: the behaviour the check exists for ------------
rejected("outright invention", "The student correctly applied the Central Limit Theorem.");
rejected(
  "paraphrase of a real idea, not a quote",
  "the gas returns to its initial state so the change in internal energy is zero",
);
rejected("plausible but absent numbers", "x^2 = 16, so x = 4 or x = -4.");
rejected("empty quote", "");
rejected(
  "elision used to stitch fragments in the WRONG order",
  "Only x = 3 is in the domain ... The four corners are the ones given",
);

Deno.test("elision cannot be abused with trivially short fragments", () => {
  // "a ... b ... c" must not match merely because single characters occur.
  if (evidenceIsGrounded("a ... b ... c", RESPONSE)) {
    throw new Error("short fragments should not satisfy the elision path");
  }
});

// --- overrideCriteriaAsUnresolved (replan O2, 2026-08-13) ------------------
//
// This is the per-criterion flag-scoping helper: given the model's real,
// already-sanitized verdicts, force ONLY the named criteria to
// unable_to_determine/0 -- the blast-radius bug this replaces zeroed every
// criterion on an item regardless of which ones the deterministic flag's
// numeric evidence actually belonged to.

const THREE_CRITERIA = [
  {
    criterion_key: "a-1",
    status: "earned" as const,
    points_awarded: 1,
    evidence_quote: "E(X) = -1.40",
    decision_explanation: "Correctly computed the expected value.",
    minimum_fix: null,
  },
  {
    criterion_key: "a-2",
    status: "not_yet_earned" as const,
    points_awarded: 0,
    evidence_quote: null,
    decision_explanation: "Standard deviation is missing.",
    minimum_fix: "Compute the standard deviation from the payoff table.",
  },
  {
    criterion_key: "b-1",
    status: "earned" as const,
    points_awarded: 2,
    evidence_quote: "the distribution is symmetric",
    decision_explanation: "Correctly identified the distribution shape.",
    minimum_fix: null,
  },
];

Deno.test("overrideCriteriaAsUnresolved forces only the named criteria, leaving others untouched", () => {
  const result = overrideCriteriaAsUnresolved(
    THREE_CRITERIA,
    ["a-1", "a-2"],
    "Deterministic check flagged the keyed evidence.",
  );

  const a1 = result.find((c) => c.criterion_key === "a-1")!;
  if (a1.status !== "unable_to_determine" || a1.points_awarded !== 0) {
    throw new Error("a-1 (in the scoped list, was earned) must be forced to unable_to_determine/0");
  }
  if (a1.decision_explanation !== "Deterministic check flagged the keyed evidence.") {
    throw new Error("forced criteria must carry the deterministic check's reason, not the model's original explanation");
  }

  const a2 = result.find((c) => c.criterion_key === "a-2")!;
  if (a2.status !== "unable_to_determine" || a2.points_awarded !== 0) {
    throw new Error("a-2 (in the scoped list, was already not_yet_earned) must also be forced");
  }

  const b1 = result.find((c) => c.criterion_key === "b-1")!;
  if (b1.status !== "earned" || b1.points_awarded !== 2) {
    throw new Error("b-1 (NOT in the scoped list) must keep its real, model-graded verdict and points -- this is the whole point of scoping over the old item-wide zeroing");
  }
  if (b1.decision_explanation !== "Correctly identified the distribution shape.") {
    throw new Error("untouched criteria must keep their original decision_explanation");
  }
});

Deno.test("overrideCriteriaAsUnresolved with an empty key list is a no-op", () => {
  const result = overrideCriteriaAsUnresolved(THREE_CRITERIA, [], "unused");
  for (let i = 0; i < THREE_CRITERIA.length; i++) {
    if (JSON.stringify(result[i]) !== JSON.stringify(THREE_CRITERIA[i])) {
      throw new Error(`criterion ${THREE_CRITERIA[i].criterion_key} should be unchanged with an empty scope`);
    }
  }
});

Deno.test("overrideCriteriaAsUnresolved ignores keys that don't match any criterion", () => {
  const result = overrideCriteriaAsUnresolved(
    THREE_CRITERIA,
    ["nonexistent-key"],
    "unused",
  );
  for (let i = 0; i < THREE_CRITERIA.length; i++) {
    if (JSON.stringify(result[i]) !== JSON.stringify(THREE_CRITERIA[i])) {
      throw new Error("an unmatched scope key must not alter any real criterion");
    }
  }
});

Deno.test("fragments must not overlap when matched in order", () => {
  // Both fragments exist, but only as the SAME occurrence — the second must be
  // found strictly after the first, not re-matched on the same text.
  const text = "alpha beta gamma";
  if (evidenceIsGrounded("alpha beta gamma ... alpha beta gamma", text)) {
    throw new Error("the same span was reused to satisfy two fragments");
  }
});

// --- buildDeterministicGradedPayload (Course Mode F4 live grading, PR #101) ---

function mkCriterion(
  key: string,
  points: number,
  minimumFix: string | null = "fix it",
): FeedbackCriterionRow {
  return {
    criterion_key: key,
    learner_facing_text: key,
    points_possible: points,
    evidence_requirements: null,
    minimum_fix: minimumFix,
    accepted_variants: [],
  };
}

function assert(cond: boolean, msg: string) {
  if (!cond) throw new Error(msg);
}

Deno.test("buildDeterministicGradedPayload: multi-point aggregation + gap selection", () => {
  const payload = buildDeterministicGradedPayload({
    criteria: [mkCriterion("a", 2), mkCriterion("b", 3, "recompute b")],
    verdictByKey: new Map([["a", "pass"], ["b", "fail"]]),
    summary: "Not quite.",
  });
  assert(payload.status === "graded", "status graded");
  assert(payload.points_available === 5, "available = 2 + 3");
  assert(payload.points_earned === 2, "earned = passing 2-pt criterion only");
  assert(payload.confidence === "high", "deterministic grade is high-confidence");
  assert(payload.criteria[0].status === "earned", "a earned");
  assert(payload.criteria[1].status === "not_yet_earned", "b not earned");
  assert(
    payload.highest_value_gap?.criterion_key === "b",
    "the failing criterion is the gap",
  );
  assert(
    payload.highest_value_gap?.minimum_fix === "recompute b",
    "gap carries the source minimum_fix",
  );
});

Deno.test("buildDeterministicGradedPayload: all pass -> full marks, no gap, no repair hint", () => {
  const payload = buildDeterministicGradedPayload({
    criteria: [mkCriterion("a", 1), mkCriterion("b", 1)],
    verdictByKey: new Map([["a", "pass"], ["b", "pass"]]),
    summary: "Correct.",
  });
  assert(payload.points_earned === 2 && payload.points_available === 2, "full marks");
  assert(payload.highest_value_gap === null, "no gap when all earned");
  assert(payload.repair_hint === null, "no repair hint when all earned");
});

Deno.test("buildDeterministicGradedPayload: an empty/absent verdict map fails every criterion (never silent-passes)", () => {
  const payload = buildDeterministicGradedPayload({
    criteria: [mkCriterion("a", 1), mkCriterion("b", 2)],
    verdictByKey: new Map(),
    summary: "held",
  });
  assert(payload.points_earned === 0, "no verdict -> no credit");
  assert(
    payload.criteria.every((c) => c.status === "not_yet_earned"),
    "a missing verdict is a not-yet-earned, never earned by default",
  );
});

Deno.test("buildDeterministicGradedPayload: a verdict key not among the criteria is ignored", () => {
  const payload = buildDeterministicGradedPayload({
    criteria: [mkCriterion("a", 1)],
    verdictByKey: new Map([["a", "pass"], ["ghost", "pass"]]),
    summary: "Correct.",
  });
  assert(payload.criteria.length === 1, "only declared criteria drive the output");
  assert(payload.points_available === 1, "the phantom key adds no points");
  assert(payload.points_earned === 1, "the declared criterion still scores");
});
