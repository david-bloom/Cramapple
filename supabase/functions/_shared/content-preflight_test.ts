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
    { choice_key: "B", choice_text: "Wrong 1", is_correct: false, rationale: "Wrong because ..." },
    { choice_key: "C", choice_text: "Wrong 2", is_correct: false, rationale: "Wrong because ..." },
    { choice_key: "D", choice_text: "Wrong 3", is_correct: false, rationale: "Wrong because ..." },
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

Deno.test("assertPreflight throws on blocking, lists the item", () => {
  const bad: ContentItemPackage = {
    ...goodFrq,
    criteria: [{ ...goodFrq.criteria![0], evidence_requirements: "" }],
  };
  assertThrows(() => assertPreflight([bad]), Error, "APX-FRQ-001");
});
