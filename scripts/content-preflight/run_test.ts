import { assertEquals } from "jsr:@std/assert@1.0.14";
import { adapt } from "./run.ts";
import { preflightItem } from "../../supabase/functions/_shared/content-preflight.ts";

Deno.test("subject-harness FRQ parts adapt to the authoritative contract", () => {
  const pkg = adapt({
    content_key: "nested-frq",
    item_type: "frq",
    canonical_answers: ["42"],
    review_notes: { expected_reasoning: "Use the supplied relationship." },
    parts: [{
      criteria: [{
        criterion_key: "answer",
        points: 1,
        description: "Reports 42.",
        required_evidence: ["42", "substitution"],
        minimum_fix: "To earn this point, show the substitution and report 42.",
        accepted_variants: ["Equivalent notation."],
      }],
    }],
  });

  assertEquals(pkg.criteria?.[0], {
    criterion_key: "answer",
    learner_facing_text: "Reports 42.",
    points_possible: 1,
    evidence_requirements: "42; substitution",
    minimum_fix: "To earn this point, show the substitution and report 42.",
    accepted_variants: ["Equivalent notation."],
  });
  assertEquals(preflightItem(pkg, { strict: true }).ok, true);
});

Deno.test("subject-harness FRQ without minimum_fix fails closed", () => {
  const pkg = adapt({
    content_key: "incomplete-frq",
    item_type: "frq",
    canonical_answers: ["42"],
    review_notes: { expected_reasoning: "Use the supplied relationship." },
    parts: [{
      criteria: [{
        criterion_key: "answer",
        points: 1,
        description: "Reports 42.",
        required_evidence: ["42"],
        accepted_variants: ["Equivalent notation."],
      }],
    }],
  });

  assertEquals(
    preflightItem(pkg).findings.some((finding) =>
      finding.code === "FRQ_MINIMUM_FIX_EMPTY" && finding.severity === "blocking"
    ),
    true,
  );
});
