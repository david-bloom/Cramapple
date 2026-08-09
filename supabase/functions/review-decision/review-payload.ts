export type AnswerApproval = {
  choice_key: string;
  approved: boolean;
};

function nonEmptyString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

export function normalizeAnswerApprovals(value: unknown): AnswerApproval[] | null {
  if (!Array.isArray(value) || value.length < 2) return null;

  const approvals: AnswerApproval[] = [];
  const seen = new Set<string>();
  for (const entry of value) {
    if (!entry || typeof entry !== "object" || Array.isArray(entry)) return null;
    const record = entry as Record<string, unknown>;
    const choiceKey = nonEmptyString(record.choice_key)?.toUpperCase() ?? null;
    if (!choiceKey || typeof record.approved !== "boolean" || seen.has(choiceKey)) {
      return null;
    }
    seen.add(choiceKey);
    approvals.push({ choice_key: choiceKey, approved: record.approved });
  }
  return approvals;
}

export function resolveTutorScore(
  numericValue: unknown,
  decisionValue: unknown,
): number | null {
  const numericScore = Number(numericValue);
  if (Number.isInteger(numericScore)) return numericScore;

  const decision = nonEmptyString(decisionValue);
  if (decision === "approve") return 1;
  if (decision === "approve_with_edits") return 2;
  if (decision === "disapprove") return 3;
  return null;
}

// The text label stored alongside tutor_score. Prefers a client-sent label
// (validated against the known set) so an explicit override is never
// silently discarded; otherwise derives it from the numeric score so the
// label is never null when a score is present. resolveTutorScore already
// derives the score FROM a label when only a label is sent, so the two
// stay consistent by construction.
export function resolveTutorDecisionLabel(
  tutorScore: number | null,
  decisionValue: unknown,
): string | null {
  const decision = nonEmptyString(decisionValue);
  if (
    decision === "approve" || decision === "approve_with_edits" ||
    decision === "disapprove"
  ) {
    return decision;
  }
  if (tutorScore === 1) return "approve";
  if (tutorScore === 2) return "approve_with_edits";
  if (tutorScore === 3) return "disapprove";
  return null;
}

export function hasExactChoiceKeys(
  approvals: AnswerApproval[],
  expectedKeys: string[],
): boolean {
  const expected = new Set(expectedKeys.map((key) => key.trim().toUpperCase()));
  const submitted = new Set(approvals.map((entry) => entry.choice_key));
  return expected.size >= 2 && submitted.size === expected.size &&
    [...expected].every((key) => submitted.has(key));
}

export function requiresTutorNote(
  tutorScore: number,
  approvals: AnswerApproval[] | null,
): boolean {
  return tutorScore !== 1 || Boolean(approvals?.some((entry) => !entry.approved));
}
