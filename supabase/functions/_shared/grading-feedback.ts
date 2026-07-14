export type FeedbackCriterionRow = {
  criterion_key: string;
  learner_facing_text: string;
  points_possible: number;
  evidence_requirements: string | null;
  minimum_fix: string | null;
  accepted_variants: unknown;
  repair_priority?: number;
  prerequisite_leverage?: number;
  estimated_repair_effort?: number;
};

export type FeedbackCriterionResult = {
  criterion_key: string;
  status:
    | "earned"
    | "not_yet_earned"
    | "unable_to_determine"
    | "not_applicable";
  points_awarded: number;
  evidence_quote: string | null;
  decision_explanation: string | null;
  minimum_fix: string | null;
};

export type SanitizationIssue = {
  code:
    | "criteria_missing"
    | "criterion_missing"
    | "criterion_unknown"
    | "criterion_duplicate"
    | "invalid_status"
    | "invalid_points"
    | "earned_without_evidence"
    | "evidence_not_found"
    | "earned_points_mismatch";
  criterion_key: string | null;
};

export function asString(value: unknown) {
  return typeof value === "string" ? value : null;
}

export function normalizeCriterionStatus(
  status: unknown,
): FeedbackCriterionResult["status"] {
  return status === "earned" ||
      status === "not_yet_earned" ||
      status === "unable_to_determine" ||
      status === "not_applicable"
    ? status
    : "unable_to_determine";
}

export function buildFallbackCriteria(
  criteria: FeedbackCriterionRow[],
  reason: string,
) {
  return criteria.map((criterion) => ({
    criterion_key: criterion.criterion_key,
    status: "unable_to_determine" as const,
    points_awarded: 0,
    evidence_quote: null,
    decision_explanation: reason,
    minimum_fix: criterion.minimum_fix,
  }));
}

function positiveOr(value: number | undefined, fallback: number) {
  return Number.isFinite(value) && Number(value) > 0 ? Number(value) : fallback;
}

export function pickHighestGap(
  criteria: FeedbackCriterionResult[],
  sourceCriteria: FeedbackCriterionRow[],
) {
  const sources = new Map(sourceCriteria.map((criterion) => [
    criterion.criterion_key,
    criterion,
  ]));
  const gaps = criteria
    .filter((criterion) =>
      criterion.status !== "earned" && criterion.status !== "not_applicable"
    )
    .map((criterion, index) => {
      const source = sources.get(criterion.criterion_key);
      const score = positiveOr(source?.repair_priority, 1) *
        positiveOr(source?.prerequisite_leverage, 1) *
        positiveOr(source?.points_possible, 1) /
        positiveOr(source?.estimated_repair_effort, 1);
      return { criterion, source, score, index };
    })
    .sort((left, right) => right.score - left.score || left.index - right.index);
  const gap = gaps[0];

  if (!gap) return null;
  const minimumFix = gap.source?.minimum_fix ?? gap.criterion.minimum_fix ??
    "Provide the missing evidence.";
  return {
    criterion_key: gap.criterion.criterion_key,
    minimum_fix: minimumFix,
    repair_prompt: minimumFix,
  };
}

export function buildShadowReviewPayload(input: {
  criteria: FeedbackCriterionRow[];
  pointsAvailable: number;
  reason: string;
  summary: string;
  actionHint: string | null;
  repairHint: string | null;
  verificationProfileSummary?: Record<string, unknown> | null;
  deterministicCheck?: Record<string, unknown> | null;
}) {
  const profileSummary = input.verificationProfileSummary
    ? ` Verification profile: ${JSON.stringify(input.verificationProfileSummary)}.`
    : "";
  const deterministicSummary = input.deterministicCheck
    ? ` Deterministic check: ${JSON.stringify(input.deterministicCheck)}.`
    : "";
  return {
    status: "uncertain" as const,
    points_earned: 0,
    points_available: input.pointsAvailable,
    criteria: buildFallbackCriteria(input.criteria, input.reason),
    highest_value_gap: null,
    predicted_improvement: null,
    confidence: "low" as const,
    uncertainty_reason: `${input.reason}${profileSummary}${deterministicSummary}`,
    student_facing_summary: input.summary,
    action_hint: input.actionHint,
    repair_hint: input.repairHint,
    deterministic_check: input.deterministicCheck ?? null,
  };
}

function searchableResponse(input?: {
  responseText?: string | null;
  responseParts?: unknown;
}) {
  const parts = input?.responseParts == null
    ? ""
    : JSON.stringify(input.responseParts);
  return `${input?.responseText ?? ""}\n${parts}`;
}

export function sanitizeModelResult(
  parsed: Record<string, unknown>,
  sourceCriteria: FeedbackCriterionRow[],
  context?: { responseText?: string | null; responseParts?: unknown },
) {
  const issues: SanitizationIssue[] = [];
  const allowedKeys = new Set(sourceCriteria.map((item) => item.criterion_key));
  const rawByKey = new Map<string, Record<string, unknown>>();
  const rawCriteria = Array.isArray(parsed.criteria) ? parsed.criteria : [];
  if (!Array.isArray(parsed.criteria)) {
    issues.push({ code: "criteria_missing", criterion_key: null });
  }

  for (const item of rawCriteria) {
    const raw = item && typeof item === "object" && !Array.isArray(item)
      ? item as Record<string, unknown>
      : {};
    const key = asString(raw.criterion_key);
    if (!key || !allowedKeys.has(key)) {
      issues.push({ code: "criterion_unknown", criterion_key: key });
      continue;
    }
    if (rawByKey.has(key)) {
      rawByKey.delete(key);
      issues.push({ code: "criterion_duplicate", criterion_key: key });
      continue;
    }
    rawByKey.set(key, raw);
  }

  const response = searchableResponse(context);
  const enforceGrounding = context !== undefined;
  const criteria = sourceCriteria.map((source) => {
    const raw = rawByKey.get(source.criterion_key);
    if (!raw) {
      issues.push({ code: "criterion_missing", criterion_key: source.criterion_key });
      return buildFallbackCriteria(
        [source],
        "The grader did not return one unambiguous result for this criterion.",
      )[0];
    }

    let status = normalizeCriterionStatus(raw.status);
    if (status === "unable_to_determine" && raw.status !== status) {
      issues.push({ code: "invalid_status", criterion_key: source.criterion_key });
    }
    const numericPoints = Number(raw.points_awarded);
    if (!Number.isFinite(numericPoints)) {
      issues.push({ code: "invalid_points", criterion_key: source.criterion_key });
    }
    let points = Math.max(
      0,
      Math.min(source.points_possible, Number.isFinite(numericPoints) ? numericPoints : 0),
    );
    let evidence = asString(raw.evidence_quote)?.trim() || null;

    if (status === "earned" && !evidence) {
      status = "unable_to_determine";
      points = 0;
      issues.push({ code: "earned_without_evidence", criterion_key: source.criterion_key });
    } else if (evidence && enforceGrounding && !response.includes(evidence)) {
      status = "unable_to_determine";
      points = 0;
      evidence = null;
      issues.push({ code: "evidence_not_found", criterion_key: source.criterion_key });
    } else if (status === "earned" && points !== source.points_possible) {
      status = "unable_to_determine";
      points = 0;
      issues.push({ code: "earned_points_mismatch", criterion_key: source.criterion_key });
    } else if (status !== "earned") {
      points = 0;
    }

    return {
      criterion_key: source.criterion_key,
      status,
      points_awarded: points,
      evidence_quote: evidence,
      decision_explanation: asString(raw.decision_explanation),
      minimum_fix: asString(raw.minimum_fix) ?? source.minimum_fix,
    };
  });

  const pointsEarned = criteria.reduce(
    (sum, criterion) => sum + criterion.points_awarded,
    0,
  );
  const pointsAvailable = sourceCriteria.reduce(
    (sum, criterion) => sum + criterion.points_possible,
    0,
  );
  const highestValueGap = pickHighestGap(criteria, sourceCriteria);
  const rawPrediction = parsed.predicted_improvement;
  const predictedImprovement = rawPrediction && typeof rawPrediction === "object" &&
      !Array.isArray(rawPrediction)
    ? {
      label: (["better", "much_better"].includes(
          asString((rawPrediction as Record<string, unknown>).label) ?? "",
        )
        ? asString((rawPrediction as Record<string, unknown>).label)
        : "none") as "better" | "much_better" | "none",
      predicted_point_gain: Math.max(0, Math.min(
        pointsAvailable - pointsEarned,
        Number.isFinite(Number(
            (rawPrediction as Record<string, unknown>).predicted_point_gain,
          ))
          ? Number((rawPrediction as Record<string, unknown>).predicted_point_gain)
          : 0,
      )),
    }
    : null;
  const uncertain = issues.length > 0 ||
    criteria.some((criterion) => criterion.status === "unable_to_determine");

  return {
    status: uncertain ? "uncertain" as const : "graded" as const,
    points_earned: pointsEarned,
    points_available: pointsAvailable,
    criteria,
    highest_value_gap: highestValueGap,
    predicted_improvement: predictedImprovement,
    confidence: uncertain
      ? "low" as const
      : asString(parsed.confidence) === "high" ||
          asString(parsed.confidence) === "medium" ||
          asString(parsed.confidence) === "low"
      ? asString(parsed.confidence) as "high" | "medium" | "low"
      : "medium" as const,
    uncertainty_reason: uncertain
      ? `Grading output failed ${issues.length} integrity check(s).`
      : asString(parsed.uncertainty_reason),
    student_facing_summary: asString(parsed.student_facing_summary) ??
      "Your response was scored successfully.",
    action_hint: parsed.action_hint === "show_scaffold" ||
        parsed.action_hint === "review_context"
      ? parsed.action_hint
      : null,
    repair_hint: highestValueGap?.repair_prompt ?? null,
    sanitization_version: "grading-sanitizer-v2",
    integrity_issues: issues,
  };
}
