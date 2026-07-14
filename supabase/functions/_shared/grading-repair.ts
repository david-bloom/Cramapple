import type {
  FeedbackCriterionResult,
  FeedbackCriterionRow,
} from "./grading-feedback.ts";

export const REPAIR_CONTRACT_VERSION = "grade-repair-v1";

export type RepairClass =
  | "capture_error"
  | "transcription_error"
  | "notation_ambiguity"
  | "arithmetic_slip"
  | "setup_error"
  | "conceptual_error"
  | "missing_evidence"
  | "content_uncertain";

export type LockedGradeDecision = {
  contract_version: typeof REPAIR_CONTRACT_VERSION;
  grade_fingerprint: string;
  points_earned: number;
  points_available: number;
  criteria: ReadonlyArray<Readonly<FeedbackCriterionResult>>;
};

export type RepairPlan = {
  contract_version: typeof REPAIR_CONTRACT_VERSION;
  grade_fingerprint: string;
  criterion_key: string | null;
  repair_class: RepairClass | null;
  repair_prompt: string | null;
  expected_point_gain: number;
  requires_learner_confirmation: boolean;
  source: "deterministic_check" | "rubric" | "perception" | "none";
};

export function lockGradeDecision(input: {
  gradeFingerprint: string;
  pointsEarned: number;
  pointsAvailable: number;
  criteria: FeedbackCriterionResult[];
}): LockedGradeDecision {
  return Object.freeze({
    contract_version: REPAIR_CONTRACT_VERSION,
    grade_fingerprint: input.gradeFingerprint,
    points_earned: input.pointsEarned,
    points_available: input.pointsAvailable,
    criteria: Object.freeze(input.criteria.map((criterion) =>
      Object.freeze({ ...criterion })
    )),
  });
}

export function inferRepairClass(input: {
  deterministicCheck?: Record<string, unknown> | null;
  learnerInputMode?: string | null;
  transcriptionConfirmed?: boolean;
  criterion?: FeedbackCriterionRow | null;
}): RepairClass {
  if (input.learnerInputMode === "handwritten" && !input.transcriptionConfirmed) {
    return "transcription_error";
  }
  const check = input.deterministicCheck;
  const explicitClass = check?.repair_class;
  if (typeof explicitClass === "string" && [
    "capture_error",
    "transcription_error",
    "notation_ambiguity",
    "arithmetic_slip",
    "setup_error",
    "conceptual_error",
    "missing_evidence",
    "content_uncertain",
  ].includes(explicitClass)) return explicitClass as RepairClass;
  if (check?.status === "flag") return "notation_ambiguity";
  const text = `${input.criterion?.learner_facing_text ?? ""} ${
    input.criterion?.evidence_requirements ?? ""
  }`.toLowerCase();
  if (text.includes("explain") || text.includes("justify") || text.includes("evidence")) {
    return "missing_evidence";
  }
  if (text.includes("calculate") || text.includes("compute")) return "arithmetic_slip";
  return "conceptual_error";
}

export function buildRepairPlan(input: {
  lockedGrade: LockedGradeDecision;
  sourceCriteria: FeedbackCriterionRow[];
  deterministicCheck?: Record<string, unknown> | null;
  learnerInputMode?: string | null;
  transcriptionConfirmed?: boolean;
}): RepairPlan {
  if (input.learnerInputMode === "handwritten" && !input.transcriptionConfirmed) {
    return {
      contract_version: REPAIR_CONTRACT_VERSION,
      grade_fingerprint: input.lockedGrade.grade_fingerprint,
      criterion_key: null,
      repair_class: "transcription_error",
      repair_prompt: "Confirm or correct the transcription before grading this response.",
      expected_point_gain: 0,
      requires_learner_confirmation: true,
      source: "perception",
    };
  }

  const sources = new Map(input.sourceCriteria.map((criterion) => [
    criterion.criterion_key,
    criterion,
  ]));
  const candidates = input.lockedGrade.criteria
    .filter((criterion) =>
      criterion.status !== "earned" && criterion.status !== "not_applicable"
    )
    .map((criterion, index) => {
      const source = sources.get(criterion.criterion_key);
      const leverage = Math.max(0.1, source?.prerequisite_leverage ?? 1);
      const priority = Math.max(0.1, source?.repair_priority ?? 1);
      const effort = Math.max(0.1, source?.estimated_repair_effort ?? 1);
      return {
        criterion,
        source,
        index,
        score: (source?.points_possible ?? 0) * leverage * priority / effort,
      };
    })
    .sort((left, right) => right.score - left.score || left.index - right.index);
  const target = candidates[0];
  if (!target) {
    return {
      contract_version: REPAIR_CONTRACT_VERSION,
      grade_fingerprint: input.lockedGrade.grade_fingerprint,
      criterion_key: null,
      repair_class: null,
      repair_prompt: null,
      expected_point_gain: 0,
      requires_learner_confirmation: false,
      source: "none",
    };
  }

  const deterministicHint = input.deterministicCheck?.status === "flag" &&
      typeof input.deterministicCheck.repair_hint === "string"
    ? input.deterministicCheck.repair_hint
    : null;
  return {
    contract_version: REPAIR_CONTRACT_VERSION,
    grade_fingerprint: input.lockedGrade.grade_fingerprint,
    criterion_key: target.criterion.criterion_key,
    repair_class: inferRepairClass({
      deterministicCheck: input.deterministicCheck,
      learnerInputMode: input.learnerInputMode,
      transcriptionConfirmed: input.transcriptionConfirmed,
      criterion: target.source,
    }),
    repair_prompt: deterministicHint ?? target.source?.minimum_fix ??
      target.criterion.minimum_fix ?? "Add the missing rubric evidence.",
    expected_point_gain: target.source?.points_possible ?? 0,
    requires_learner_confirmation: false,
    source: deterministicHint ? "deterministic_check" : "rubric",
  };
}
