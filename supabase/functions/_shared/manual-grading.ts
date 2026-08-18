// Pure validation/scoring logic for a human-entered grade
// (record_manual_grade operation, hand-drawn-answer pilot).
//
// TASK-0020 Program C found the canonical grader is text-only and no
// automated method is qualified for hand-drawn images -- a human-entered
// grade is the only legitimate way to produce a real graded response today.
// This module mirrors the production grading contract's per-criterion shape
// (supabase/functions/_shared/grading-contract.ts `gradingSchema`) so a
// human grade and a model grade write app.grading_results rows in the same
// shape, and existing student-facing reads keep working unmodified. It does
// NOT reuse grading-feedback.ts's `sanitizeModelResult`: that function's
// evidence-grounding check requires the quoted text to appear in
// `response_text`, which doesn't apply when the response is an image with
// no (or minimal) typed text. The status vocabulary itself IS reused (via
// CRITERION_STATUS_VALUES) so a human grade and a model grade can never
// silently diverge on what a valid status is.

import { CRITERION_STATUS_VALUES } from "./grading-feedback.ts";

export type CriterionStatus = typeof CRITERION_STATUS_VALUES[number];

const CRITERION_STATUSES = new Set<CriterionStatus>(CRITERION_STATUS_VALUES);

export interface CriterionCatalogEntry {
  criterion_key: string;
  points_possible: number;
}

export interface SubmittedCriterion {
  criterion_key: string;
  status: CriterionStatus;
  points_awarded: number;
  evidence_quote: string | null;
  decision_explanation: string | null;
  minimum_fix: string | null;
}

export type ManualGradeResult =
  | {
    ok: true;
    criteria: SubmittedCriterion[];
    points_earned: number;
    points_available: number;
  }
  | { ok: false; reason: string };

function statusPointsConsistent(
  status: CriterionStatus,
  pointsAwarded: number,
  pointsPossible: number,
) {
  switch (status) {
    case "earned":
      return pointsAwarded === pointsPossible;
    case "partially_earned":
      return pointsAwarded > 0 && pointsAwarded < pointsPossible;
    case "not_yet_earned":
    case "unable_to_determine":
    case "not_applicable":
      return pointsAwarded === 0;
  }
}

// Fails closed: every catalog criterion must appear exactly once, no
// unknown keys, no duplicates, and status/points must agree with each
// other and with the catalog's points_possible for that key.
export function scoreManualGrade(
  submitted: SubmittedCriterion[],
  catalog: CriterionCatalogEntry[],
): ManualGradeResult {
  if (catalog.length === 0) {
    return { ok: false, reason: "manual_grade_no_criteria_catalog" };
  }

  const catalogByKey = new Map(catalog.map((c) => [c.criterion_key, c]));
  const seen = new Set<string>();

  for (const entry of submitted) {
    if (!catalogByKey.has(entry.criterion_key)) {
      return { ok: false, reason: "manual_grade_unknown_criterion_key" };
    }
    if (seen.has(entry.criterion_key)) {
      return { ok: false, reason: "manual_grade_duplicate_criterion_key" };
    }
    seen.add(entry.criterion_key);

    if (!CRITERION_STATUSES.has(entry.status)) {
      return { ok: false, reason: "manual_grade_invalid_status" };
    }
    if (
      !Number.isInteger(entry.points_awarded) || entry.points_awarded < 0
    ) {
      return { ok: false, reason: "manual_grade_invalid_points_awarded" };
    }

    const pointsPossible = catalogByKey.get(entry.criterion_key)!
      .points_possible;
    if (entry.points_awarded > pointsPossible) {
      return { ok: false, reason: "manual_grade_points_exceed_possible" };
    }
    if (
      !statusPointsConsistent(
        entry.status,
        entry.points_awarded,
        pointsPossible,
      )
    ) {
      return { ok: false, reason: "manual_grade_status_points_mismatch" };
    }
  }

  if (seen.size !== catalog.length) {
    return { ok: false, reason: "manual_grade_missing_criteria" };
  }

  const points_earned = submitted.reduce((sum, c) => sum + c.points_awarded, 0);
  const points_available = catalog.reduce(
    (sum, c) => sum + c.points_possible,
    0,
  );

  return { ok: true, criteria: submitted, points_earned, points_available };
}
