import {
  buildDeterministicGradedPayload,
  buildShadowReviewPayload,
} from "../_shared/grading-feedback.ts";
import { type FeedbackCriterionRow } from "../_shared/grading-contract.ts";
import { gradeAgainstChecks } from "../_shared/deterministic-verifier.ts";
import {
  buildEcfResult,
  coerceEcfQuestion,
  findStatisticsItem,
} from "../_shared/math-verifier.ts";
import { checkStatisticsDeterministicEvidence } from "../_shared/statistics-verifier.ts";
import {
  detectAmbiguousTypedFormulaText,
  resolveFormulaActionHint,
  resolveFormulaRepairHint,
} from "../_shared/formula-notation.ts";
import {
  formatVerificationProfileSummary,
  getVerificationProfile,
  summarizeVerificationProfile,
} from "../_shared/verification-profiles.ts";
import { DATA_DRIVEN_VERIFIER_VERSION, MATH_VERIFIER_VERSION } from "./config.ts";
import { type Service } from "./grade-store.ts";

// The routes that grade without the LLM (TASK-0079 S3). Bodies moved verbatim
// from handleEvaluateAttempt; each returns what the handler used to assign.
// The handler still zeroes model cost and tokens for every one of them.

type StatisticsCheck = ReturnType<typeof checkStatisticsDeterministicEvidence>;
type VerificationProfile = ReturnType<typeof getVerificationProfile>;

export type RouteContext = {
  contentItem: { content_key?: unknown };
  contentVersion: { id?: unknown };
  responseText: string | null;
  responseParts: unknown;
  promptBase: { criteria: FeedbackCriterionRow[] };
  routing: { reason: string };
  statisticsCheck: StatisticsCheck;
  defaultPointsAvailable: number;
  verificationProfile: VerificationProfile;
  verificationProfileSummary: ReturnType<typeof summarizeVerificationProfile>;
};

// Symbolic formula / ECF boundary. Shadow, non-authoritative: always uncertain,
// with the computed ECF verdict kept in shadow_result.
export function gradeSymbolicEcf(input: RouteContext) {
  const {
    contentItem,
    responseText,
    responseParts,
    promptBase,
    routing,
    statisticsCheck,
    defaultPointsAvailable,
    verificationProfileSummary,
  } = input;
  const statisticsItem = findStatisticsItem(
    contentItem.content_key as string | null,
  );
  const typedFormulaAmbiguity = detectAmbiguousTypedFormulaText(responseText);
  const ecfQuestion = coerceEcfQuestion(
    statisticsItem,
    responseParts,
  );
  const ecfResult = ecfQuestion ? buildEcfResult(ecfQuestion) : null;
  const ecfCriteria = ecfResult?.parts.map((part) => ({
    criterion_key: part.part,
    learner_facing_text: statisticsItem?.ecf_parts.find((item) =>
      item.id === part.part
    )?.note ??
      `ECF part ${part.part}`,
    points_possible: statisticsItem?.ecf_parts.find((item) =>
      item.id === part.part
    )?.points ??
      part.points_possible,
    evidence_requirements: null,
    minimum_fix: statisticsItem?.ecf_parts.find((item) =>
      item.id === part.part
    )?.note ??
      "Show the formula and substitutions for this step.",
    accepted_variants: [],
  })) ?? promptBase.criteria;
  const ecfHighestGap = ecfResult?.parts.find((part) =>
    part.verdict !== "CORRECT"
  ) ?? null;
  const ecfSummary = ecfResult
    ? ecfResult.parts.map((part) =>
      `${part.part}: ${part.verdict} (${part.points_awarded}/${part.points_possible})`
    ).join("; ")
    : "The symbolic verifier could not reconstruct a structured ECF payload from the submitted response.";
  const resolvedActionHint = typedFormulaAmbiguity.ambiguous
    ? "show_scaffold"
    : ecfResult?.parts.some((part) =>
        part.verdict === "NAKED_ANSWER" ||
        part.verdict === "CONCEPTUAL_COLLAPSE"
      )
    ? "show_scaffold"
    : "review_context";
  const resolvedRepairHint = typedFormulaAmbiguity.repair_hint ??
    ecfHighestGap?.feedback ??
    null;
  const deterministicCheck = ecfResult
    ? {
      status: ecfResult.parts.every((part) => part.verdict === "CORRECT")
        ? "pass"
        : "flag",
      version: MATH_VERIFIER_VERSION,
      content_key: contentItem.content_key,
      result: ecfResult,
      reason: ecfSummary,
    }
    : statisticsCheck;
  const shadowSummary = statisticsItem
    ? `${statisticsItem.content_key} symbolic/ECF grading is saved for follow-up. ${ecfSummary}`
    : "This response is saved and routed for reviewer follow-up.";
  const shadowReason = [
    routing.reason,
    statisticsItem
      ? `Symbolic formula and ECF boundary executed for ${statisticsItem.content_key}.`
      : "No symbolic verification profile was available for this item, so the response is routed for follow-up.",
    typedFormulaAmbiguity.ambiguous ? typedFormulaAmbiguity.reason : null,
  ].filter(Boolean).join(" ");

  const shadowResult = {
    engine: "symbolic_ecf",
    verifier_version: MATH_VERIFIER_VERSION,
    content_key: contentItem.content_key,
    ambiguous_notation: typedFormulaAmbiguity.ambiguous
      ? { reason: typedFormulaAmbiguity.reason }
      : null,
    ecf_result: ecfResult,
  };

  const finalPayload = buildShadowReviewPayload({
    criteria: ecfCriteria,
    pointsAvailable: ecfResult?.possible ?? defaultPointsAvailable,
    reason: shadowReason,
    actionHint: resolvedActionHint,
    repairHint: resolveFormulaRepairHint(
      resolvedRepairHint ?? statisticsCheck?.repair_hint,
      ecfHighestGap
        ? {
          minimum_fix: statisticsItem?.ecf_parts.find((item) =>
            item.id === ecfHighestGap.part
          )
            ?.note ?? "Show the missing work.",
          repair_prompt: statisticsItem?.ecf_parts.find((item) =>
            item.id === ecfHighestGap.part
          )
            ?.note ?? "Show the missing work.",
        }
        : null,
    ),
    deterministicCheck,
    summary: `${shadowSummary}${
      typedFormulaAmbiguity.ambiguous
        ? ` ${typedFormulaAmbiguity.reason}`
        : ""
    }`,
    verificationProfileSummary,
  });
  return {
    finalPayload,
    finalStatus: "uncertain" as const,
    shadowResult: shadowResult as Record<string, unknown>,
  };
}

// Course Mode data-driven grading against persisted content_item_checks.
export async function gradeDataDriven(
  service: Service,
  input: RouteContext,
) {
  const {
    contentVersion,
    responseText,
    promptBase,
    routing,
    defaultPointsAvailable,
    verificationProfileSummary,
  } = input;
  let finalPayload:
    | ReturnType<typeof buildShadowReviewPayload>
    | ReturnType<typeof buildDeterministicGradedPayload>;
  let finalStatus: "graded" | "uncertain";
  // Course Mode F4 LIVE grading (2026-08-23). Grade the response against the
  // item's PERSISTED content_item_checks with the generic deterministic
  // verifier (_shared/deterministic-verifier.ts) -- no per-content_key code
  // (CM-FACT-20). Determinism (INV-4). An ABSTAIN (no parseable number, an
  // unhandled check kind, or no checks at all) still HOLDS for shadow review
  // rather than guessing (INV-3), preserving the pre-wiring safe posture for
  // exactly the content class those invariants protect.
  const { data: checkRows, error: checkErr } = await service.schema("app")
    .from("content_item_checks")
    .select("criterion_key, checks")
    .eq("content_item_version_id", contentVersion.id)
    .order("criterion_key", { ascending: true });
  // A read error must NOT masquerade as "no checks" (which would silently
  // convert a gradeable submission into a shadow hold). Log it (Fable QA #14);
  // it still routes to the abstain hold below, which is the safe outcome.
  if (checkErr) {
    console.error("data_driven_checks_read_failed", {
      content_item_version_id: contentVersion.id,
      error: checkErr.message,
    });
  }

  const checkList = Array.isArray(checkRows) ? checkRows : [];
  const checkKeys = new Set(
    checkList.map((row) => row.criterion_key as string),
  );
  const sourceByKey = new Map(
    promptBase.criteria.map((
      criterion,
    ) => [criterion.criterion_key, criterion]),
  );
  // F5: a criterion declared in frq_criteria but with NO persisted check would
  // otherwise vanish from grading (graded on a shrunken denominator = over-grade).
  // Hold the whole item for review instead.
  const uncoveredCriteria = promptBase.criteria.filter(
    (criterion) => !checkKeys.has(criterion.criterion_key),
  );
  // Generated items may carry no frq_criteria rows (the loader persists checks
  // + cells, not frq_criteria) -- derive the graded criteria from the check
  // rows themselves, defaulting a missing source to a 1-point criterion.
  const gradeCriteria: FeedbackCriterionRow[] = checkList.map((row) =>
    sourceByKey.get(row.criterion_key as string) ?? {
      criterion_key: row.criterion_key as string,
      learner_facing_text: row.criterion_key as string,
      points_possible: 1,
      evidence_requirements: null,
      minimum_fix: "Recompute the value and enter the correct result.",
      accepted_variants: [],
    }
  );
  const criterionResults = checkList.map((row) => ({
    criterion_key: row.criterion_key as string,
    result: gradeAgainstChecks(
      Array.isArray(row.checks) ? row.checks : [],
      responseText ?? "",
    ),
  }));
  // Full audit record -> grading_results.shadow_result (server-side only, F4).
  const deterministicCheck = {
    engine: "data_driven_deterministic",
    version: DATA_DRIVEN_VERIFIER_VERSION,
    content_item_version_id: contentVersion.id,
    uncovered_criteria: uncoveredCriteria.map((c) => c.criterion_key),
    results: criterionResults.map((entry) => ({
      criterion_key: entry.criterion_key,
      status: entry.result.status,
      verdicts: entry.result.verdicts,
    })),
  };
  // Student-facing REDACTION (F10): the verdict `reason` strings embed the
  // expected value/tolerance (e.g. "0.5 is not within +/-0.01 of 0.62"), which
  // would leak the answer key through uncertainty_reason / the client payload.
  // Everything reaching the student carries statuses only; the full verdicts
  // stay in shadow_result above.
  // NOTE (re-QA finding 7): this redacted check flows into the finalPayload
  // builders (uncertainty_reason on the hold path; the graded payload's
  // deterministic_check field). The top-level response's `deterministic_check`
  // stays the content-key-specific `statisticsCheck` (null here) — the client
  // reads the per-criterion outcomes from `criterion_results`, which carries
  // them for this route. Intentional: statuses reach the student, values don't.
  const redactedCheck = {
    engine: "data_driven_deterministic",
    version: DATA_DRIVEN_VERIFIER_VERSION,
    results: criterionResults.map((entry) => ({
      criterion_key: entry.criterion_key,
      status: entry.result.status,
    })),
  };
  const shadowResult: Record<string, unknown> = deterministicCheck;
  const deterministicVerifierVersion: string = DATA_DRIVEN_VERIFIER_VERSION;
  // Any abstain, an uncovered criterion, or nothing to grade -> hold; never let
  // it fall through to the LLM grader, and never award/deny credit off an
  // unparseable response or a partially-checked item.
  const anyAbstain = criterionResults.length === 0 ||
    uncoveredCriteria.length > 0 ||
    criterionResults.some((entry) => entry.result.status === "abstain");

  if (anyAbstain) {
    finalPayload = buildShadowReviewPayload({
      criteria: promptBase.criteria,
      pointsAvailable: defaultPointsAvailable,
      reason:
        `${routing.reason} The data-driven verifier abstained (no single parseable number in the response, an unhandled check kind, no persisted checks, or a criterion with no check), so the item is held for shadow review instead of guessing.`,
      actionHint: null,
      repairHint: null,
      deterministicCheck: redactedCheck,
      summary:
        "Your answer is saved. This item needs a reviewer before it can be scored automatically.",
      verificationProfileSummary,
    });
    finalStatus = "uncertain";
  } else {
    const verdictByKey = new Map<string, "pass" | "fail">(
      criterionResults.map((entry) => [
        entry.criterion_key,
        entry.result.status === "correct" ? "pass" : "fail",
      ]),
    );
    const allCorrect = criterionResults.every(
      (entry) => entry.result.status === "correct",
    );
    finalPayload = buildDeterministicGradedPayload({
      criteria: gradeCriteria,
      verdictByKey,
      summary: allCorrect
        ? "Correct."
        : "Not quite. Recompute the value and check it against the expected answer.",
      deterministicCheck: redactedCheck,
    });
    finalStatus = "graded";
  }
  return { finalPayload, finalStatus, shadowResult, deterministicVerifierVersion };
}

// Declared-but-unwired verifier: hold for human/shadow review.
export function gradeShadowReview(input: RouteContext) {
  const {
    responseText,
    promptBase,
    routing,
    statisticsCheck,
    defaultPointsAvailable,
    verificationProfile,
  } = input;
  // Shadow-review hold for the symbolic/formula boundary that is declared but
  // not wired in this phase -- routed here instead of guessing (Fable QA #1).
  const verificationProfileSummary = summarizeVerificationProfile(
    verificationProfile,
  );
  const readableVerificationSummary = formatVerificationProfileSummary(
    verificationProfile,
  );
  const typedFormulaAmbiguity = detectAmbiguousTypedFormulaText(responseText);
  const actionHint = statisticsCheck?.status === "flag"
    ? "show_scaffold"
    : resolveFormulaActionHint(typedFormulaAmbiguity.ambiguous);
  const repairHint = resolveFormulaRepairHint(
    statisticsCheck?.repair_hint ?? typedFormulaAmbiguity.repair_hint,
    null,
  );
  const shadowSummary = verificationProfile
    ? `${verificationProfile.display_name} formula feedback is saved and routed for reviewer follow-up. The symbolic verifier is declared but not wired in this phase, so we are holding the item instead of guessing.${
      typedFormulaAmbiguity.ambiguous
        ? ` ${typedFormulaAmbiguity.reason}`
        : ""
    }`
    : "This response is saved and routed for reviewer follow-up.";
  const shadowReason =
    `${routing.reason} The item is held for human/shadow review until the declared verifier is wired in.${
      typedFormulaAmbiguity.ambiguous
        ? ` ${typedFormulaAmbiguity.reason}`
        : ""
    }${
      statisticsCheck?.status === "flag"
        ? ` Deterministic statistics check: ${statisticsCheck.reason}`
        : ""
    }`;
  const finalPayload = buildShadowReviewPayload({
    criteria: promptBase.criteria,
    pointsAvailable: defaultPointsAvailable,
    reason: shadowReason,
    actionHint,
    repairHint,
    deterministicCheck: statisticsCheck,
    summary: readableVerificationSummary
      ? `${shadowSummary} Expected checks: ${
        verificationProfile?.required_checks.map((check) => check.check).join(
          ", ",
        )
      }.${
        statisticsCheck?.status === "flag"
          ? ` Deterministic check flagged the keyed Statistics evidence.`
          : ""
      }`
      : shadowSummary,
    verificationProfileSummary,
  });
  return { finalPayload, finalStatus: "uncertain" as const };
}
