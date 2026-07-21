import { assertEquals, assertThrows } from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  assertPreflight,
  type ContentItemPackage,
  preflightItem,
} from "./content-preflight.ts";

const goodFrq: ContentItemPackage = {
  content_key: "APX-FRQ-001",
  item_type: "frq",
  canonical_answer_1: "Reference answer.",
  explanation: "Teaching explanation.",
  criteria: [
    {
      criterion_key: "a1",
      learner_facing_text: "Computes the mean as 7.2.",
      points_possible: 1,
      evidence_requirements: "Earns when the response reports 7.2.",
      minimum_fix: "To earn this point, report the mean 7.2.",
      accepted_variants: ["7.2", "seven point two"],
    },
  ],
};

const goodMcq: ContentItemPackage = {
  content_key: "APX-MCQ-001",
  item_type: "mcq",
  explanation: "Teaching explanation.",
  choices: [
    { choice_key: "A", choice_text: "Right", is_correct: true, rationale: "Correct because ..." },
    { choice_key: "B", choice_text: "Wrong 1", is_correct: false, rationale: "Misreads the units." },
    { choice_key: "C", choice_text: "Wrong 2", is_correct: false, rationale: "Omits the second step." },
    { choice_key: "D", choice_text: "Wrong 3", is_correct: false, rationale: "Applies the wrong formula." },
  ],
};

Deno.test("complete FRQ passes with no findings", () => {
  const r = preflightItem(goodFrq);
  assertEquals(r.ok, true);
  assertEquals(r.blocking, 0);
  assertEquals(r.warnings, 0);
});

Deno.test("complete MCQ passes with no findings", () => {
  const r = preflightItem(goodMcq);
  assertEquals(r.ok, true);
  assertEquals(r.blocking, 0);
});

Deno.test("empty evidence_requirements and minimum_fix are BLOCKING (the shipped-Stats defect)", () => {
  const bad: ContentItemPackage = {
    ...goodFrq,
    criteria: [{ ...goodFrq.criteria![0], evidence_requirements: "", minimum_fix: "   " }],
  };
  const r = preflightItem(bad);
  assertEquals(r.ok, false);
  assertEquals(r.blocking, 2);
  const codes = r.findings.map((f) => f.code).sort();
  assertEquals(codes, ["FRQ_EVIDENCE_REQ_EMPTY", "FRQ_MINIMUM_FIX_EMPTY"]);
});

Deno.test("FRQ points_possible must be an integer >= 1", () => {
  for (const points_possible of [1.5, 0, -1, Number.NaN, Number.POSITIVE_INFINITY]) {
    const bad: ContentItemPackage = {
      ...goodFrq,
      criteria: [{ ...goodFrq.criteria![0], points_possible }],
    };
    const r = preflightItem(bad);
    assertEquals(r.ok, false);
    assertEquals(r.findings.some((f) => f.code === "FRQ_POINTS_INVALID"), true);
  }
});

Deno.test("empty accepted_variants is a WARNING, not blocking", () => {
  const warn: ContentItemPackage = {
    ...goodFrq,
    criteria: [{ ...goodFrq.criteria![0], accepted_variants: [] }],
  };
  const r = preflightItem(warn);
  assertEquals(r.ok, true); // warnings do not block by default
  assertEquals(r.warnings, 1);
  assertEquals(r.findings[0].code, "FRQ_ACCEPTED_VARIANTS_EMPTY");
});

Deno.test("strict mode fails on warnings", () => {
  const warn: ContentItemPackage = {
    ...goodFrq,
    criteria: [{ ...goodFrq.criteria![0], accepted_variants: [] }],
  };
  assertEquals(preflightItem(warn, { strict: true }).ok, false);
});

Deno.test("MCQ with zero or multiple correct choices is BLOCKING", () => {
  const none: ContentItemPackage = {
    ...goodMcq,
    choices: goodMcq.choices!.map((c) => ({ ...c, is_correct: false })),
  };
  assertEquals(preflightItem(none).findings.some((f) => f.code === "MCQ_KEY_NOT_UNIQUE"), true);
  const many: ContentItemPackage = {
    ...goodMcq,
    choices: goodMcq.choices!.map((c) => ({ ...c, is_correct: true })),
  };
  assertEquals(preflightItem(many).findings.some((f) => f.code === "MCQ_KEY_NOT_UNIQUE"), true);
});

Deno.test("MCQ missing a distractor rationale is BLOCKING", () => {
  const bad: ContentItemPackage = {
    ...goodMcq,
    choices: [{ ...goodMcq.choices![1], rationale: "" }, ...goodMcq.choices!.slice(0, 1), ...goodMcq.choices!.slice(2)],
  };
  assertEquals(preflightItem(bad).findings.some((f) => f.code === "MCQ_RATIONALE_EMPTY"), true);
});

Deno.test("MCQ distractors with identical rationale are BLOCKING (duplicate)", () => {
  const bad: ContentItemPackage = {
    ...goodMcq,
    choices: [
      goodMcq.choices![0],
      { ...goodMcq.choices![1], rationale: "Confuses the input with the slope." },
      { ...goodMcq.choices![2], rationale: "Confuses the input with the slope." },
      goodMcq.choices![3],
    ],
  };
  const r = preflightItem(bad);
  assertEquals(r.ok, false);
  const finding = r.findings.find((f) => f.code === "MCQ_DUPLICATE_RATIONALE");
  assertEquals(finding !== undefined, true);
  assertEquals(finding!.location, "choice:B,C");
});

Deno.test("MCQ distractors with templated 'This option conflicts with' rationale are BLOCKING (the five-subject-batch defect)", () => {
  const bad: ContentItemPackage = {
    ...goodMcq,
    choices: [
      { choice_key: "A", choice_text: "0.500 mol", is_correct: true, rationale: "mass divided by molar mass gives 0.500 mol" },
      { choice_key: "B", choice_text: "0.250 mol", is_correct: false, rationale: "This option conflicts with mass divided by molar mass gives 0.500 mol." },
      { choice_key: "C", choice_text: "2.00 mol", is_correct: false, rationale: "This option conflicts with mass divided by molar mass gives 0.500 mol." },
      { choice_key: "D", choice_text: "162 mol", is_correct: false, rationale: "This option conflicts with mass divided by molar mass gives 0.500 mol." },
    ],
  };
  const r = preflightItem(bad);
  assertEquals(r.ok, false);
  const finding = r.findings.find((f) => f.code === "MCQ_DUPLICATE_RATIONALE");
  assertEquals(finding !== undefined, true);
  assertEquals(finding!.location, "choice:B,C,D");
});

Deno.test("MCQ distractors with distinct rationale, incl. one echoing the correct answer's fact, are not flagged as duplicates", () => {
  // The correct choice's rationale legitimately shares its underlying fact with
  // what a distractor is measured against; only distractor-vs-distractor
  // duplication should be flagged.
  const ok: ContentItemPackage = {
    ...goodMcq,
    choices: [
      { choice_key: "A", choice_text: "6", is_correct: true, rationale: "Factoring gives x+3 for x≠3, whose limit is 6." },
      { choice_key: "B", choice_text: "0", is_correct: false, rationale: "Substitution into the uncanceled numerator alone does not evaluate the quotient." },
      { choice_key: "C", choice_text: "3", is_correct: false, rationale: "This uses only the approach value, not the simplified function." },
      { choice_key: "D", choice_text: "DNE", is_correct: false, rationale: "The removable hole does not prevent the two-sided limit from existing." },
    ],
  };
  const r = preflightItem(ok);
  assertEquals(r.findings.some((f) => f.code === "MCQ_DUPLICATE_RATIONALE"), false);
});

Deno.test("FRQ criteria array containing a null entry is BLOCKING, not a thrown TypeError", () => {
  const bad: ContentItemPackage = {
    ...goodFrq,
    criteria: [null as unknown as ContentItemPackage["criteria"] extends
      (infer U)[] | null | undefined ? U : never],
  };
  const r = preflightItem(bad);
  assertEquals(r.ok, false);
  assertEquals(r.findings.some((f) => f.code === "FRQ_CRITERION_MALFORMED"), true);
});

Deno.test("MCQ choices array containing a null entry is BLOCKING, not a thrown TypeError", () => {
  const bad: ContentItemPackage = {
    ...goodMcq,
    choices: [
      null as unknown as ContentItemPackage["choices"] extends
        (infer U)[] | null | undefined ? U : never,
      ...goodMcq.choices!,
    ],
  };
  const r = preflightItem(bad);
  assertEquals(r.ok, false);
  assertEquals(r.findings.some((f) => f.code === "MCQ_CHOICE_MALFORMED"), true);
});

Deno.test("assertPreflight throws on blocking, lists the item", () => {
  const bad: ContentItemPackage = {
    ...goodFrq,
    criteria: [{ ...goodFrq.criteria![0], evidence_requirements: "" }],
  };
  assertThrows(() => assertPreflight([bad]), Error, "APX-FRQ-001");
});

Deno.test("MCQ correct choice far longer than distractor average is a length-parity WARNING, not blocking", () => {
  const outlier: ContentItemPackage = {
    ...goodMcq,
    choices: [
      {
        choice_key: "A",
        choice_text:
          "There is an association between the two variables in this sample, but causation cannot be concluded because units were not randomly assigned to condition.",
        is_correct: true,
        rationale: "Correct because ...",
      },
      { choice_key: "B", choice_text: "It causes the effect.", is_correct: false, rationale: "Overclaims causation from an observational study." },
      { choice_key: "C", choice_text: "No conclusion is possible.", is_correct: false, rationale: "Overstates what lack of randomization implies." },
      { choice_key: "D", choice_text: "The sample size fixes it.", is_correct: false, rationale: "Sample size does not substitute for random assignment." },
    ],
  };
  const r = preflightItem(outlier);
  assertEquals(r.ok, true); // warning only, does not fail non-strict preflight
  const finding = r.findings.find((f) => f.code === "MCQ_CORRECT_ANSWER_LENGTH_OUTLIER");
  assertEquals(finding !== undefined, true);
  assertEquals(finding!.severity, "warning");
  assertEquals(finding!.location, "choice:A");
});

Deno.test("MCQ with roughly equal-length choices is not flagged for length parity", () => {
  const r = preflightItem(goodMcq);
  assertEquals(r.findings.some((f) => f.code === "MCQ_CORRECT_ANSWER_LENGTH_OUTLIER"), false);
});

Deno.test("MCQ with a shorter correct answer is not flagged for length parity", () => {
  const shorterCorrect: ContentItemPackage = {
    ...goodMcq,
    choices: [
      { choice_key: "A", choice_text: "0.3", is_correct: true, rationale: "Correct because each trial is independent." },
      { choice_key: "B", choice_text: "Less than 0.3, because it is due to balance out soon.", is_correct: false, rationale: "Misapplies the gambler's fallacy." },
      { choice_key: "C", choice_text: "Greater than 0.3, given the recent streak.", is_correct: false, rationale: "Misapplies the hot-hand fallacy." },
      { choice_key: "D", choice_text: "0.3 raised to the fourth power.", is_correct: false, rationale: "Confuses this event with a run of five in a row." },
    ],
  };
  const r = preflightItem(shorterCorrect);
  assertEquals(r.findings.some((f) => f.code === "MCQ_CORRECT_ANSWER_LENGTH_OUTLIER"), false);
});
