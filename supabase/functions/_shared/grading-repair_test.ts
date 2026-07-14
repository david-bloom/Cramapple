import { buildRepairPlan, lockGradeDecision } from "./grading-repair.ts";
import type { FeedbackCriterionResult } from "./grading-feedback.ts";

Deno.test("repair is derived from an immutable locked grade and targets prerequisite value", () => {
  const criteria: FeedbackCriterionResult[] = [
    { criterion_key: "setup", status: "not_yet_earned" as const, points_awarded: 0, evidence_quote: null, decision_explanation: null, minimum_fix: "Fix setup." },
    { criterion_key: "answer", status: "not_yet_earned" as const, points_awarded: 0, evidence_quote: null, decision_explanation: null, minimum_fix: "Fix answer." },
  ];
  const locked = lockGradeDecision({
    gradeFingerprint: "grade-1",
    pointsEarned: 0,
    pointsAvailable: 3,
    criteria,
  });
  criteria[0].status = "earned";
  const plan = buildRepairPlan({
    lockedGrade: locked,
    sourceCriteria: [
      { criterion_key: "setup", learner_facing_text: "Set up the calculation", points_possible: 1, evidence_requirements: null, minimum_fix: "Fix setup.", accepted_variants: [], prerequisite_leverage: 3 },
      { criterion_key: "answer", learner_facing_text: "Final answer", points_possible: 2, evidence_requirements: null, minimum_fix: "Fix answer.", accepted_variants: [] },
    ],
  });
  if (locked.criteria[0].status !== "not_yet_earned") throw new Error("lock must isolate the decision from later mutation");
  if (plan.criterion_key !== "setup" || plan.grade_fingerprint !== "grade-1") throw new Error("repair must preserve grade provenance and prioritize leverage");
});

Deno.test("unconfirmed handwriting routes to transcription repair before concept repair", () => {
  const locked = lockGradeDecision({ gradeFingerprint: "hand-1", pointsEarned: 0, pointsAvailable: 1, criteria: [] });
  const plan = buildRepairPlan({ lockedGrade: locked, sourceCriteria: [], learnerInputMode: "handwritten", transcriptionConfirmed: false });
  if (plan.repair_class !== "transcription_error" || !plan.requires_learner_confirmation || plan.expected_point_gain !== 0) {
    throw new Error("perception uncertainty must block conceptual grading and score claims");
  }
});
