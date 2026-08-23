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

// Canonical criterion-status vocabulary. Exported as a runtime array (not
// just a type) so other modules that need a validation Set -- e.g.
// manual-grading.ts's human-entered-grade path -- can build it from this
// single source instead of re-listing the values and silently drifting if
// this list ever changes.
export const CRITERION_STATUS_VALUES = [
  "earned",
  "partially_earned",
  "not_yet_earned",
  "unable_to_determine",
  "not_applicable",
] as const;

export type FeedbackCriterionResult = {
  criterion_key: string;
  status: typeof CRITERION_STATUS_VALUES[number];
  points_awarded: number;
  evidence_quote: string | null;
  decision_explanation: string | null;
  minimum_fix: string | null;
};

// Hard integrity failures. Any one of these forces the whole grading to
// `uncertain` -- they mean the model returned something self-contradictory or
// unsupported, and the result should not be presented as reliable.
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

// Soft reconciliations. Recorded for observability but deliberately NOT
// escalated to `uncertain`: the result is still trustworthy, we just picked
// one of the model's two overlapping claims (status vs points_awarded) over
// the other. Keeping these out of `integrity_issues` is what stops routine
// partial credit from marking every multi-point grading unreliable.
export type SanitizationNormalization = {
  code: "status_points_reconciled";
  criterion_key: string | null;
  from: FeedbackCriterionResult["status"];
  to: FeedbackCriterionResult["status"];
};

export function asString(value: unknown) {
  return typeof value === "string" ? value : null;
}

export function normalizeCriterionStatus(
  status: unknown,
): FeedbackCriterionResult["status"] {
  return status === "earned" ||
      status === "partially_earned" ||
      status === "not_yet_earned" ||
      status === "unable_to_determine" ||
      status === "not_applicable"
    ? status
    : "unable_to_determine";
}

// True for the two statuses that award credit and therefore must be evidenced.
export function awardsCredit(status: FeedbackCriterionResult["status"]) {
  return status === "earned" || status === "partially_earned";
}

// --- partial credit -----------------------------------------------------
//
// 601 of 2,969 Production criteria (20%) are worth more than one point -- 382
// at 2 points, 219 at 3 -- and 124 of those are already on published items.
// Partial credit is intended product behaviour (owner decision, 2026-07-28),
// including error carry forward: a student who uses correct method on a value
// carried forward from an earlier wrong step keeps the method credit.
//
// The model states its verdict twice, as a status and as a number, and the two
// can disagree. `points_awarded` is the more specific claim and is already
// clamped to [0, points_possible], so deriving the status from it can never
// award more than the status alone would have. That makes points the safe
// arbiter.
//
// What this replaced: any `earned` criterion whose award was not exactly
// points_possible became unable_to_determine with ZERO points, and the
// resulting integrity issue marked the entire grading uncertain. On a 3-point
// criterion, a student earning 2 points received 0 and an "uncertain" verdict.
// The one case still treated as a hard failure is a credit status paired with
// a zero award, which has no charitable reading.
export function reconcileCreditStatus(
  points: number,
  pointsPossible: number,
): FeedbackCriterionResult["status"] {
  if (points >= pointsPossible) return "earned";
  if (points > 0) return "partially_earned";
  return "not_yet_earned";
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

// Per-criterion flag scoping (replan O2, 2026-08-13). Forces ONLY the named
// criteria to unable_to_determine/0 -- unlike buildFallbackCriteria, this
// takes already-sanitized model results (not source rows) and leaves every
// other criterion's real, model-graded verdict untouched. Used when a
// deterministic check flags an item but the caller knows (via
// statistics-verifier.ts's NUMERIC_ELEMENT_CRITERIA) which specific
// criteria the flagged numeric evidence belongs to, so criteria unrelated
// to that evidence don't get zeroed along with it.
export function overrideCriteriaAsUnresolved(
  criteria: FeedbackCriterionResult[],
  criterionKeys: string[],
  reason: string,
): FeedbackCriterionResult[] {
  const keys = new Set(criterionKeys);
  return criteria.map((criterion) =>
    keys.has(criterion.criterion_key)
      ? {
        ...criterion,
        status: "unable_to_determine" as const,
        points_awarded: 0,
        decision_explanation: reason,
      }
      : criterion
  );
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
    // partially_earned belongs here: there are still points on the table, so
    // it is a legitimate repair target.
    .filter((criterion) =>
      criterion.status !== "earned" && criterion.status !== "not_applicable"
    )
    .map((criterion, index) => {
      const source = sources.get(criterion.criterion_key);
      // Rank by the points still available, not the criterion's face value --
      // a 3-point criterion already worth 2 has less left to win than an
      // untouched 2-point one. Identical to the previous behaviour for any
      // criterion awarded zero, which is every gap under all-or-nothing
      // scoring, so single-point items are unaffected.
      const remaining = positiveOr(source?.points_possible, 1) -
        criterion.points_awarded;
      const score = positiveOr(source?.repair_priority, 1) *
        positiveOr(source?.prerequisite_leverage, 1) *
        positiveOr(remaining, 1) /
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

// Course Mode F4 live grading (2026-08-23). Builds a GRADED payload from the
// generic deterministic verifier's per-criterion pass/fail verdicts, so a
// generated instance graded against its persisted content_item_checks produces
// the same finalPayload shape the LLM/shadow paths do (points, per-criterion
// status, highest_value_gap) -- letting the common finalize path in
// evaluate-attempt write grading_results/attempts unchanged. Determinism (INV-4):
// no evidence-grounding step is needed because credit derives from a recomputed
// numeric check, not a model quote; an ABSTAIN never reaches here (the caller
// holds those for shadow review, INV-3), so every criterion is a real pass/fail.
export function buildDeterministicGradedPayload(input: {
  criteria: FeedbackCriterionRow[];
  verdictByKey: Map<string, "pass" | "fail">;
  summary: string;
  deterministicCheck?: Record<string, unknown> | null;
}) {
  const criteria: FeedbackCriterionResult[] = input.criteria.map((source) => {
    const pass = input.verdictByKey.get(source.criterion_key) === "pass";
    return {
      criterion_key: source.criterion_key,
      status: (pass ? "earned" : "not_yet_earned") as
        FeedbackCriterionResult["status"],
      points_awarded: pass ? source.points_possible : 0,
      evidence_quote: null,
      decision_explanation: pass
        ? "The response matches the item's persisted deterministic checks."
        : "The response does not match the item's persisted deterministic checks.",
      minimum_fix: pass ? null : source.minimum_fix,
    };
  });
  const points_available = input.criteria.reduce(
    (sum, criterion) => sum + Number(criterion.points_possible || 0),
    0,
  );
  const points_earned = criteria.reduce(
    (sum, criterion) => sum + Number(criterion.points_awarded || 0),
    0,
  );
  const firstGap = criteria.find((criterion) => criterion.status !== "earned");
  const highest_value_gap = firstGap
    ? {
      criterion_key: firstGap.criterion_key,
      minimum_fix: firstGap.minimum_fix ??
        "Recompute the value and enter the correct result.",
      repair_prompt: "Recompute the value and enter it again.",
    }
    : null;
  return {
    status: "graded" as const,
    points_earned,
    points_available,
    criteria,
    highest_value_gap,
    predicted_improvement: null,
    confidence: "high" as const,
    uncertainty_reason: null,
    student_facing_summary: input.summary,
    action_hint: null as string | null,
    repair_hint: highest_value_gap?.repair_prompt ?? null,
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

// --- evidence grounding -------------------------------------------------
//
// The grounding check exists to stop the grader awarding credit for text the
// student never wrote, and it does catch that. But it was a raw
// `response.includes(quote)`, which is far stricter than the thing it is
// trying to detect: a model that quotes a span crossing a line break almost
// always collapses the newline to a space, and one that quotes a long span
// often elides the middle with "...". Neither is a fabricated quote.
//
// Measured over 2,973 real grader outputs (Phase C beta-2 corpus):
//
//   exact substring        10.19% flagged   <- shipped behaviour
//   + unicode/whitespace    3.70% flagged
//   + elision-aware         2.66% flagged
//
// ~64% of the original flags were false alarms. That matters because a flag is
// not advisory: it forces the criterion to unable_to_determine AND zeroes its
// points, so brittle matching was silently converting correct gradings into
// withheld credit -- the same under-credit direction beta-1 was fixing at the
// rubric level.
//
// Deliberately NOT relaxed any further: no lowercasing (measured to recover
// zero additional cases, so it would only weaken the check), no fuzzy or
// edit-distance matching, and elided fragments must appear in order and be
// long enough to be meaningful. The 2.66% that still fail are genuine
// paraphrases and invented quotes, which is exactly what should be caught.
const EVIDENCE_ELISION = /\s*\[?\s*(?:\.\.\.|…)\s*\]?\s*/;
const MIN_ELIDED_FRAGMENT = 12;

function normalizeForGrounding(value: string) {
  let out = value.normalize("NFKC");
  for (
    const [from, to] of [
      ["‘", "'"],
      ["’", "'"],
      ["“", '"'],
      ["”", '"'],
      ["–", "-"],
      ["—", "-"],
      ["…", "..."],
    ] as const
  ) {
    out = out.split(from).join(to);
  }
  // LaTeX renders the same math two ways depending on which side wrote it --
  // \sqrt{20.04} vs sqrt{20.04}, $-1.40$ vs -1.40. Stripping backslash
  // commands and bare math/currency $ delimiters is applied symmetrically to
  // both the response and the quote, so it can only remove a mismatch that
  // was purely notational, never create a false match out of unrelated text
  // (both sides still have to line up on everything else).
  out = out.replace(/\\([a-zA-Z]+)/g, "$1").replace(/\$/g, "");
  return out.replace(/\s+/g, " ").trim();
}

// A model sometimes wraps its own quote in quotation marks it invented for
// the citation itself ("the quoted span"), not text the student wrote. That
// wrapping is punctuation the check should see through -- classified
// 2026-08-14 from real evidence_not_found captures (P0, TASK-0016 addendum):
// 2 of 8 unresolved false alarms in the classified corpus were exactly this.
function stripWrappingQuote(value: string) {
  const trimmed = value.trim();
  for (const quote of ['"', "'"]) {
    if (
      trimmed.length > 2 && trimmed.startsWith(quote) && trimmed.endsWith(quote)
    ) {
      return trimmed.slice(1, -1).trim();
    }
  }
  return trimmed;
}

/**
 * True when `quote` is genuinely present in `response`, tolerating the
 * formatting a model applies when quoting but not tolerating paraphrase.
 * Exported so the behaviour is directly testable.
 */
export function evidenceIsGrounded(quote: string, response: string) {
  if (!quote) return false;
  if (response.includes(quote)) return true;

  const haystack = normalizeForGrounding(response);
  let needle = normalizeForGrounding(quote);
  if (!needle) return false;
  if (haystack.includes(needle)) return true;

  const unwrapped = stripWrappingQuote(needle);
  if (unwrapped !== needle) {
    needle = unwrapped;
    if (!needle) return false;
    if (haystack.includes(needle)) return true;
  }

  // FIX 2026-08-14 (QA-caught regression, codex): a quote may elide its
  // middle ("first part ... last part") or simply truncate at one end
  // ("first part ..."). Those are NOT the same shape and must not share a
  // code path. A prior version of this function treated "fewer than 2
  // fragments survived the length filter" as always-safe-to-relax, on the
  // theory that anything a single fragment would match was already caught
  // by the whole-string check above. That reasoning only holds when nothing
  // was actually elided away -- it silently dropped short-but-real trailing
  // content instead (e.g. quote = "X ... not", where "not" reverses the
  // claim): `evidenceIsGrounded("X ... not", "X.")` returned true even
  // though "not" appears nowhere in the response, because "not" (3 chars)
  // never got checked at all. Splitting genuine boundary truncation
  // (nothing on the far side) from genuine mid-quote elision (real content
  // on both sides) fixes this: a truncation's one real side is checked
  // directly; an elision's fragments go through the original >=2-substantial
  // rule, so a short-but-real fragment can no longer be silently exempted.
  const rawParts = needle.split(EVIDENCE_ELISION).map((part) => part.trim());
  const nonEmptyParts = rawParts.filter((part) => part.length > 0);
  if (!nonEmptyParts.length) return false;

  if (nonEmptyParts.length === 1) {
    // Pure truncation: the split found an elision marker, but everything on
    // the other side of it was genuinely empty -- nothing was elided away
    // for this single remaining piece to be excused from matching in full.
    const only = nonEmptyParts[0];
    if (only.length < MIN_ELIDED_FRAGMENT) return false;
    return findFragment(haystack, only, 0) >= 0;
  }

  // 2+ non-empty parts: genuine mid-quote elision. Only fragments meeting
  // MIN_ELIDED_FRAGMENT count toward the requirement (guards the classic
  // "a ... b ... c" abuse, where no single piece is specific enough to be a
  // real citation) -- but unlike the truncation case above, a short
  // fragment here is simply excluded from the count, same as before this
  // fix; it is never separately required *or* silently trusted, so this
  // multi-fragment path keeps its original, already-audited behaviour.
  const fragments = nonEmptyParts.filter((part) =>
    part.length >= MIN_ELIDED_FRAGMENT
  );
  if (fragments.length < 2) return false;

  let cursor = 0;
  for (const fragment of fragments) {
    const at = findFragment(haystack, fragment, cursor);
    if (at < 0) return false;
    cursor = at;
  }
  return true;
}

// Finds `fragment` in `haystack` at or after `cursor`, tolerating the model
// closing a fragment with connecting punctuation the source doesn't have at
// that exact point -- a period where the source has none, or its own
// semicolon/colon in place of the source's period, as it stitches an elided
// or truncated quote back together. That trailing mark is punctuation the
// model chose, not content it invented. Returns the position just past the
// match (for cursor advancement), or -1 if not found either way.
function findFragment(haystack: string, fragment: string, cursor: number) {
  const at = haystack.indexOf(fragment, cursor);
  if (at >= 0) return at + fragment.length;
  if (/[.!?;:]$/.test(fragment)) {
    const withoutPunctuation = fragment.slice(0, -1);
    const retryAt = haystack.indexOf(withoutPunctuation, cursor);
    if (retryAt >= 0) return retryAt + withoutPunctuation.length;
  }
  return -1;
}

// A grading goes `uncertain` for two unrelated reasons, and the shipped message
// described only one of them. Every uncertain result was worded as an integrity
// failure, so a grading that went uncertain purely because the grader abstained
// emitted the literal string "Grading output failed 0 integrity check(s)" --
// observed live on 2026-07-28. That reads to a tutor as a broken grader rather
// than as the grader correctly declining to guess.
export function buildUncertaintyReason(
  issueCount: number,
  abstentionCount: number,
) {
  const parts: string[] = [];
  if (issueCount > 0) {
    parts.push(
      `Grading output failed ${issueCount} integrity check${
        issueCount === 1 ? "" : "s"
      }.`,
    );
  }
  if (abstentionCount > 0) {
    parts.push(
      `The grader could not reach a decision on ${abstentionCount} criter${
        abstentionCount === 1 ? "ion" : "ia"
      }.`,
    );
  }
  // Both counts zero means the caller asked for a reason without an uncertain
  // result. Say so rather than returning an empty string that renders as blank.
  return parts.join(" ") || "Grading was marked uncertain without a recorded cause.";
}

export function sanitizeModelResult(
  parsed: Record<string, unknown>,
  sourceCriteria: FeedbackCriterionRow[],
  context?: { responseText?: string | null; responseParts?: unknown },
) {
  const issues: SanitizationIssue[] = [];
  const normalizations: SanitizationNormalization[] = [];
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

    if (awardsCredit(status) && !evidence) {
      status = "unable_to_determine";
      points = 0;
      issues.push({ code: "earned_without_evidence", criterion_key: source.criterion_key });
    } else if (evidence && enforceGrounding && !evidenceIsGrounded(evidence, response)) {
      // The rejected quote is not persisted here (2026-08-14: an earlier
      // version logged it via a hook for false-alarm classification, but
      // app.grading_results.raw_model_response already retains the full
      // pre-sanitization model output -- including this quote -- with the
      // grading row's existing access controls, so a second copy in Edge
      // Function logs was redundant exposure of student response text with
      // no offsetting diagnostic value. Classification work reads
      // raw_model_response directly instead.)
      status = "unable_to_determine";
      points = 0;
      evidence = null;
      issues.push({ code: "evidence_not_found", criterion_key: source.criterion_key });
    } else if (awardsCredit(status) && points === 0) {
      // Claims credit, awards nothing. Unlike a partial award there is no
      // reading of this that is internally consistent, so it stays a hard
      // integrity failure -- this is the residue of the old blanket check.
      status = "unable_to_determine";
      issues.push({ code: "earned_points_mismatch", criterion_key: source.criterion_key });
    } else if (awardsCredit(status)) {
      const reconciled = reconcileCreditStatus(points, source.points_possible);
      if (reconciled !== status) {
        normalizations.push({
          code: "status_points_reconciled",
          criterion_key: source.criterion_key,
          from: status,
          to: reconciled,
        });
        status = reconciled;
      }
    } else {
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
  const abstentionCount = criteria.filter((criterion) =>
    criterion.status === "unable_to_determine"
  ).length;
  const uncertain = issues.length > 0 || abstentionCount > 0;

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
      ? buildUncertaintyReason(issues.length, abstentionCount)
      : asString(parsed.uncertainty_reason),
    student_facing_summary: asString(parsed.student_facing_summary) ??
      "Your response was scored successfully.",
    action_hint: parsed.action_hint === "show_scaffold" ||
        parsed.action_hint === "review_context"
      ? parsed.action_hint
      : null,
    repair_hint: highestValueGap?.repair_prompt ?? null,
    // v3: partial credit. `earned` no longer implies full points, and status
    // is reconciled against points_awarded instead of zeroing on mismatch.
    sanitization_version: "grading-sanitizer-v3",
    integrity_issues: issues,
    normalizations,
  };
}
