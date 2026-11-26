import { stringOrNull as asString, looseUuid as asUuid } from "../_shared/input.ts";
import { sha256Text as sha256Hex } from "../_shared/encoding.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";
import { resolveGradingRoute } from "../_shared/grading-router.ts";
import { resolveFormulaRepairHint } from "../_shared/formula-notation.ts";
import {
  getVerificationProfile,
  summarizeVerificationProfile,
} from "../_shared/verification-profiles.ts";
import {
  buildStatisticsDeterministicFallback,
  checkStatisticsDeterministicEvidence,
  getStatisticsScopedCriteria,
} from "../_shared/statistics-verifier.ts";
import {
  buildDeterministicGradedPayload,
  buildFallbackCriteria,
  buildShadowReviewPayload,
  pickHighestGap,
} from "../_shared/grading-feedback.ts";
import {
  type AllowedOperation,
  applyDeterministicFlagScope,
  type FeedbackCriterionRow,
  sanitizeModelResult,
} from "../_shared/grading-contract.ts";
import { loadLearningRuntimeContext } from "../_shared/learning-context.ts";
import { asRecord } from "../_shared/student-memory.ts";
import {
  buildEvaluateAttemptResponse,
  buildEvaluateAttemptResult,
} from "../_shared/evaluate-attempt-response.ts";
import {
  buildRepairPlan,
  lockGradeDecision,
} from "../_shared/grading-repair.ts";
import {
  createStageTimer,
  normalizeResponseText,
} from "../_shared/grading-telemetry.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { buildGraderSystemPrompt, runModelGrading } from "./model-grading.ts";
import {
  gradeDataDriven,
  gradeShadowReview,
  gradeSymbolicEcf,
} from "./deterministic-routes.ts";
import { loadMcqFeedbackContext } from "./mcq-context.ts";
import { getBodyField, parseEvaluateRequest } from "./request.ts";
import { loadAttemptContext, loadItemContext } from "./load-context.ts";
import { createStoredResultResponder } from "./replay.ts";
import { finalizeGrade } from "./finalize.ts";
import {
  EVALUATE_ATTEMPT_PROMPT_VERSION,
  gradingArm,
  MATH_VERIFIER_VERSION,
  OPENAI_DAILY_CAP_USD,
  OPENAI_INPUT_PRICE_PER_1M,
  OPENAI_MAX_OUTPUT_TOKENS,
  OPENAI_MODEL,
  OPENAI_OUTPUT_PRICE_PER_1M,
} from "./config.ts";
import { composeMcqFeedback, summarizeSelectedChoice } from "./mcq-feedback.ts";
import { type OutputCriterion, type Service } from "./grade-store.ts";

// Kept exported from the entry point for existing callers and tests.
export { composeMcqFeedback };



export type { AllowedOperation };




function estimateTokens(text: string) {
  return Math.max(32, Math.ceil(text.length / 4));
}

function money(value: number) {
  return Math.round(value * 10000) / 10000;
}

function parseJsonSafe(value: string | null | undefined) {
  if (!value) return null;
  try {
    return JSON.parse(value);
  } catch {
    return null;
  }
}


async function readBodyAsRecord(req: Request) {
  const body = await readJsonBody(req);
  return body && typeof body === "object" && !Array.isArray(body)
    ? body as Record<string, unknown>
    : null;
}

export interface EvaluateAttemptDeps {
  service?: Service;
  requireProfile?: typeof requireProfile;
}

const QA_NO_PERSIST_PATH_VERSION = "evaluate-attempt-qa-no-persist-2026-09-22";

// FF-11 (2026-09-24): this used to refuse any item that already carried a
// canonical_answer_1 (409 canonical_answer_already_present). That made
// DECISION-0052's rule -- "the production grader awards it 100% against its
// own rubric" -- permanently unverifiable for the 65 (of 68) Biology FRQ
// whose canonical predates the grader gate: once written, they could never
// be measured again. The guard added no security of its own (this path is
// already gated by the vault-held qa_grader_rpc_secret_v1 token, checked via
// verify_qa_grader_token below) and canonical_answer_1/2 are read only for
// that removed presence check -- never fed into the prompt or the response --
// so widening it cannot let an unverified canonical influence a score. See
// docs/product/AP_BIOLOGY_FAST_FOLLOW.md FF-11 and
// docs/research/biology_m1_regrade_and_blocker_2026_09_24/README.md.
//
/**
 * Privileged canonical-answer QA path.
 *
 * This deliberately reuses evaluate-attempt's live prompt builders, model
 * request shape, grading arm, retry behavior, and sanitizer, but it does not
 * create an attempt/response/grading-result row or run any post-grade side
 * effects. Access is limited to a database-held capability token checked by a
 * service-role-only RPC. The public gateway JWT remains enabled for the whole
 * function; the database wrapper supplies the project's anon JWT only to pass
 * that outer gateway, then supplies the private capability separately.
 */
async function handleQaNoPersist(
  req: Request,
  body: Record<string, unknown>,
  deps: EvaluateAttemptDeps = {},
) {
  const respond = (responseBody: unknown, init: ResponseInit = {}) =>
    jsonResponse(responseBody, init, req);
  const service = deps.service ?? createServiceClient();

  const qaToken = req.headers.get("x-qa-grader-token")?.trim() ?? "";
  if (!qaToken) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const { data: tokenAccepted, error: tokenError } = await service
    .schema("app")
    .rpc("verify_qa_grader_token", { p_token: qaToken });
  if (tokenError || tokenAccepted !== true) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const contentItemVersionId = asUuid(
    getBodyField(body, "content_item_version_id", "contentItemVersionId"),
  );
  const answerText = asString(
    getBodyField(body, "answer_text", "answerText"),
  )?.trim() ?? "";

  if (!contentItemVersionId || !answerText) {
    return respond(
      {
        error: "missing_required_fields",
        required: ["content_item_version_id", "answer_text"],
      },
      { status: 400 },
    );
  }
  if (answerText.length > 50_000) {
    return respond({ error: "answer_too_large" }, { status: 413 });
  }

  const { data: contentVersion, error: contentError } = await service
    .schema("app")
    .from("content_item_versions")
    .select(
      "id, content_item_id, version_num, stem, stimulus, prompt_json, rubric_type, evaluator_strategy, status, canonical_answer_1, canonical_answer_2, created_at",
    )
    .eq("id", contentItemVersionId)
    .maybeSingle();
  if (contentError || !contentVersion) {
    return respond({ error: "content_not_found" }, { status: 404 });
  }

  const [
    { data: latestVersion, error: latestVersionError },
    { data: contentItem, error: contentItemError },
    { data: criteriaRows, error: criteriaError },
  ] = await Promise.all([
    service.schema("app")
      .from("content_item_versions")
      .select("id, version_num, created_at")
      .eq("content_item_id", contentVersion.content_item_id)
      .order("version_num", { ascending: false })
      .order("created_at", { ascending: false })
      .order("id", { ascending: false })
      .limit(1)
      .maybeSingle(),
    service.schema("app")
      .from("content_items")
      .select(
        "id, exam_pack_version_id, content_key, item_type, title, status",
      )
      .eq("id", contentVersion.content_item_id)
      .maybeSingle(),
    service.schema("app")
      .from("frq_criteria")
      .select(
        "criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants",
      )
      .eq("content_item_version_id", contentVersion.id)
      .order("criterion_key", { ascending: true }),
  ]);

  if (latestVersionError || !latestVersion) {
    return respond({ error: "latest_version_lookup_failed" }, { status: 500 });
  }
  if (latestVersion.id !== contentVersion.id) {
    return respond(
      {
        error: "content_version_not_latest",
        requested_content_item_version_id: contentVersion.id,
        latest_content_item_version_id: latestVersion.id,
      },
      { status: 409 },
    );
  }
  if (contentItemError || !contentItem) {
    return respond({ error: "content_item_not_found" }, { status: 404 });
  }
  if (
    criteriaError || !Array.isArray(criteriaRows) || criteriaRows.length === 0
  ) {
    return respond({ error: "criteria_not_found" }, { status: 409 });
  }
  if (
    contentItem.item_type !== "frq" ||
    contentItem.status !== "published" ||
    contentVersion.status !== "published"
  ) {
    return respond({ error: "content_not_published_frq" }, { status: 409 });
  }

  const { data: examPackVersion, error: examPackVersionError } = await service
    .schema("app")
    .from("exam_pack_versions")
    .select("id, exam_pack_id, status")
    .eq("id", contentItem.exam_pack_version_id)
    .maybeSingle();
  if (examPackVersionError || !examPackVersion) {
    return respond({ error: "exam_pack_version_not_found" }, { status: 404 });
  }
  if (examPackVersion.status !== "published") {
    return respond({ error: "exam_pack_version_not_published" }, {
      status: 409,
    });
  }

  const { data: examPack, error: examPackError } = await service.schema("app")
    .from("exam_packs")
    .select("id, exam_code, exam_name")
    .eq("id", examPackVersion.exam_pack_id)
    .maybeSingle();
  if (examPackError || !examPack) {
    return respond({ error: "exam_pack_not_found" }, { status: 404 });
  }
  if (examPack.exam_code !== "ap_biology") {
    return respond({ error: "qa_path_ap_biology_only" }, { status: 409 });
  }

  const promptVersion = EVALUATE_ATTEMPT_PROMPT_VERSION;
  const { data: promptVersionRow, error: promptVersionError } = await service
    .schema("app")
    .from("prompt_versions")
    .select("id, status")
    .eq("operation", "grade_initial_attempt")
    .eq("version", promptVersion)
    .maybeSingle();
  if (
    promptVersionError || !promptVersionRow ||
    promptVersionRow.status !== "published"
  ) {
    return respond({ error: "invalid_prompt_version" }, { status: 409 });
  }

  const routing = resolveGradingRoute({
    rubricType: contentVersion.rubric_type,
    evaluatorStrategy: contentVersion.evaluator_strategy,
    itemType: contentItem.item_type,
    promptJson: contentVersion.prompt_json,
  });
  if (routing.target !== "llm_text") {
    return respond(
      {
        error: "qa_path_requires_llm_text",
        resolved_target: routing.target,
      },
      { status: 409 },
    );
  }

  const criteria = criteriaRows as FeedbackCriterionRow[];
  const promptBase = {
    operation: "grade_initial_attempt" as AllowedOperation,
    promptVersion,
    examName: examPack.exam_name as string,
    itemTitle: contentItem.title as string,
    itemType: contentItem.item_type as string,
    stem: contentVersion.stem as string,
    stimulus: contentVersion.stimulus as string | null,
    responseText: answerText,
    responseParts: {},
    criteria,
  };

  const answerSha256 = await sha256Hex(answerText);
  const idempotencyKey =
    `qa:${contentVersion.id}:${promptVersion}:${answerSha256}`;
  const userIdHash = await sha256Hex(`canonical-qa:${contentVersion.id}`);
  const gradingArmForRequest = gradingArm();
  const systemPrompt = buildGraderSystemPrompt(
    gradingArmForRequest,
    examPack.exam_name as string,
  );

  try {
    const graded = await runModelGrading({
      arm: gradingArmForRequest,
      modelId: OPENAI_MODEL,
      systemPrompt,
      promptBase,
      sanitizeContext: { responseText: answerText, responseParts: {} },
      userIdHash,
      idempotencyKey,
    });
    const finalPayload = graded.finalPayload;
    const rawGraderResponse = graded.response.raw;
    const inputTokens = graded.inputTokens ?? 0;
    const outputTokens = graded.outputTokens ?? 0;
    const cachedTokens = graded.cachedTokens;
    const latencyMs = graded.response.elapsedMs;

    const possibleByKey = new Map(
      criteria.map((criterion) => [
        criterion.criterion_key,
        Number(criterion.points_possible || 0),
      ]),
    );
    const criterionResults = finalPayload.criteria.map((criterion) => ({
      ...criterion,
      points_possible: possibleByKey.get(criterion.criterion_key) ?? 0,
    }));

    return respond({
      status: finalPayload.status,
      function: "evaluate-attempt",
      mode: "qa_no_persist",
      content_key: contentItem.content_key,
      content_item_version_id: contentVersion.id,
      result: {
        ...finalPayload,
        criteria: criterionResults,
        carry_forward_used: false,
        carry_forward_reason:
          "QA no-persist mode has no prior-attempt context.",
      },
      grader: {
        qa_path_version: QA_NO_PERSIST_PATH_VERSION,
        deployment_id: Deno.env.get("DENO_DEPLOYMENT_ID") ?? null,
        execution_id: Deno.env.get("SB_EXECUTION_ID") ?? null,
        model_id: OPENAI_MODEL,
        prompt_version: promptVersion,
        grading_arm: gradingArmForRequest,
        latency_ms: latencyMs,
        input_tokens: inputTokens,
        output_tokens: outputTokens,
        cached_tokens: cachedTokens,
      },
      raw_grader_response: rawGraderResponse,
      persistence: {
        wrote_attempts: false,
        wrote_response_versions: false,
        wrote_grading_results: false,
        wrote_model_usage_ledger: false,
        wrote_student_memory: false,
        wrote_student_cell_state: false,
        wrote_content: false,
      },
    });
  } catch (error) {
    return respond(
      {
        error: "qa_grading_failed",
        detail: error instanceof Error ? error.message : "unknown_error",
        qa_path_version: QA_NO_PERSIST_PATH_VERSION,
      },
      { status: 500 },
    );
  }
}

export async function handleEvaluateAttempt(
  req: Request,
  deps: EvaluateAttemptDeps = {},
): Promise<Response> {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") {
    return respond({ ok: true }, { status: 200 });
  }

  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const body = await readBodyAsRecord(req);
  if (!body) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }

  if (body.qa_no_persist === true) {
    return await handleQaNoPersist(req, body, deps);
  }

  const parsed = parseEvaluateRequest(body, respond);
  if (parsed instanceof Response) return parsed;
  const {
    operation,
    idempotencyKey,
    attemptId,
    responseVersionId,
    artifactVersionId,
    requestedContentItemVersionId,
    requestedRubricVersionId,
    promptVersion,
    assistanceCondition,
    requestExemplars,
  } = parsed;

  // Passive stage timings (replan 2.2): wall-clock per stage, written
  // best-effort at the end. Attacks the measured ~691 ms p50 non-model
  // floor with data; never affects the grading itself.
  const stageTimer = createStageTimer();

  const authenticate = deps.requireProfile ?? requireProfile;
  const profileResult = await authenticate(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }
  stageTimer.mark("auth");

  const { user, profile } = profileResult;
  if (profile.role !== "student" && profile.role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const service = deps.service ?? createServiceClient();

  const attemptContext = await loadAttemptContext({
    service,
    respond,
    user,
    profile,
    operation,
    promptVersion,
    attemptId,
    responseVersionId,
    artifactVersionId,
    requestedContentItemVersionId,
    requestedRubricVersionId,
  });
  if (attemptContext instanceof Response) return attemptContext;
  const {
    attempt,
    responseVersion,
    derivedAssistanceState,
    effectiveContentItemVersionId,
    effectiveRubricVersionId,
    contentVersion,
  } = attemptContext;

  const requestHashPayload = {
    operation,
    idempotencyKey,
    attemptId,
    responseVersionId,
    artifactVersionId,
    contentItemVersionId: effectiveContentItemVersionId,
    rubricVersionId: effectiveRubricVersionId,
    assistanceCondition,
    promptVersion,
  };
  const requestHash = await sha256Hex(JSON.stringify(requestHashPayload));

  // Replays may recover a private pending write, but NEVER call the grader.
  const respondFromStoredResult = createStoredResultResponder({
    service,
    respond,
    requestHash,
    operation,
    idempotencyKey,
    attempt,
    derivedAssistanceState,
  });
  const { data: existingResult, error: existingReadError } = await service.schema(
    "app",
  )
    .from("grading_results").select("*").eq("request_id", idempotencyKey)
    .maybeSingle();
  if (existingReadError) {
    return respond({ error: "grading_result_read_failed" }, { status: 503 });
  }
  if (existingResult) return await respondFromStoredResult(existingResult);
  const itemContext = await loadItemContext({
    service,
    respond,
    user,
    profile,
    operation,
    idempotencyKey,
    attempt,
    contentVersion,
  });
  if (itemContext instanceof Response) return itemContext;
  const {
    contentItem,
    criteriaRows,
    mcqChoices,
    examPack,
  } = itemContext;
  stageTimer.mark("db");

  const responseParts = parseJsonSafe(
    typeof responseVersion.response_parts === "string"
      ? responseVersion.response_parts
      : JSON.stringify(responseVersion.response_parts),
  ) ?? {};
  const responseText = typeof responseVersion.response_text === "string"
    ? responseVersion.response_text
    : null;
  const statisticsCheck = checkStatisticsDeterministicEvidence({
    contentKey: contentItem.content_key as string | null,
    responseText,
  });
  // O2 (2026-08-13): when a flag has a known per-criterion mapping, scope
  // the deterministic hold to just those criteria instead of the whole
  // item -- see getStatisticsScopedCriteria for which items qualify. Null
  // means "no mapping known," so the caller must fall back to the
  // item-wide behavior below (statisticsDeterministicFallback), unchanged
  // from before this change.
  const statisticsScopedCriteriaKeys = statisticsCheck?.status === "flag"
    ? getStatisticsScopedCriteria(contentItem.content_key as string | null)
    : null;
  stageTimer.mark("deterministic");
  // Replay-rate telemetry (passive): hash of the normalized response text.
  const normalizedResponseSha256 = await sha256Hex(
    normalizeResponseText(responseText),
  );

  const promptBase = {
    operation: operation as AllowedOperation,
    promptVersion,
    examName: examPack.exam_name as string,
    itemTitle: contentItem.title as string,
    itemType: contentItem.item_type as string,
    stem: contentVersion.stem as string,
    stimulus: contentVersion.stimulus as string | null,
    responseText,
    responseParts,
    criteria: Array.isArray(criteriaRows)
      ? criteriaRows as FeedbackCriterionRow[]
      : [],
    exemplars: requestExemplars,
  };

  const gradingRuntimeContext = attempt.learning_session_id
    ? await loadLearningRuntimeContext(
      service,
      attempt.learning_session_id as string,
    )
    : null;
  stageTimer.mark("db");
  const gradingRuntimeSubject = asRecord(
    asRecord(gradingRuntimeContext?.subject_defaults).subject,
  );
  const verificationProfile = getVerificationProfile(
    asString(gradingRuntimeSubject.subject_key),
  );
  const verificationProfileSummary = summarizeVerificationProfile(
    verificationProfile,
  );

  const routing = resolveGradingRoute({
    rubricType: (contentVersion as Record<string, unknown>).rubric_type,
    evaluatorStrategy:
      (contentVersion as Record<string, unknown>).evaluator_strategy,
    itemType: contentItem.item_type as string | null,
    promptJson: contentVersion.prompt_json,
  });

  const defaultPointsAvailable = promptBase.criteria.reduce(
    (sum, criterion) => sum + Number(criterion.points_possible || 0),
    0,
  ) || (contentItem.item_type === "mcq" ? 1 : 0);
  // Scoped flags skip the item-wide fallback entirely -- they proceed to
  // the normal model call below, and the flagged criteria are overridden
  // afterward (search statisticsScopedCriteriaKeys further down). Only an
  // unscoped flag (no known criterion mapping) still short-circuits here.
  const statisticsDeterministicFallback =
    routing.target === "llm_text" && !statisticsScopedCriteriaKeys
      ? buildStatisticsDeterministicFallback({
        contentKey: contentItem.content_key as string | null,
        responseText,
        criteria: promptBase.criteria,
        pointsAvailable: defaultPointsAvailable,
      })
      : null;
  stageTimer.mark("deterministic");

  const routedModelId = routing.target === "mcq_rule"
    ? "rule-based-mcq"
    : routing.target === "llm_text"
    ? statisticsDeterministicFallback
      ? "deterministic-statistics-prefilter"
      : OPENAI_MODEL
    : routing.target === "symbolic_ecf"
    ? "symbolic-ecf-verifier"
    : routing.target === "data_driven"
    ? "data-driven-deterministic-verifier"
    : "shadow-review-placeholder";

  const estimatedInputTokens = estimateTokens(
    [
      JSON.stringify(promptBase),
      JSON.stringify(contentVersion.prompt_json ?? {}),
    ].join("\n"),
  );
  const reservedCost = money(
    (estimatedInputTokens / 1_000_000) * OPENAI_INPUT_PRICE_PER_1M +
      (OPENAI_MAX_OUTPUT_TOKENS / 1_000_000) * OPENAI_OUTPUT_PRICE_PER_1M,
  );
  const modelId = OPENAI_MODEL;

  const requestRecord = {
    request_id: idempotencyKey,
    request_hash: requestHash,
    attempt_id: attempt.id,
    response_version_id: responseVersion.id,
    operation,
    status: "processing",
    points_available: defaultPointsAvailable,
    confidence: "medium",
    model_id: routedModelId,
    prompt_version: promptVersion,
    rubric_version_id: effectiveRubricVersionId,
    estimated_cost_usd: statisticsDeterministicFallback ? 0 : reservedCost,
    deterministic_verifier_version: MATH_VERIFIER_VERSION,
    boundary_contract_version: verificationProfile?.profile_version ?? null,
  };

  const { data: insertedResult, error: insertError } = await service.schema(
    "app",
  )
    .from("grading_results")
    .insert(requestRecord)
    .select("*")
    .maybeSingle();

  if (insertError || !insertedResult) {
    const { data: conflictResult } = await service.schema("app")
      .from("grading_results")
      .select("*")
      .eq("request_id", idempotencyKey)
      .maybeSingle();

    if (conflictResult) return await respondFromStoredResult(conflictResult);

    return respond({ error: "could_not_create_grading_record" }, {
      status: 409,
    });
  }

  let usageRow: Record<string, unknown> | null = null;
  const isMcq = routing.target === "mcq_rule";

  if (routing.target === "llm_text" && !statisticsDeterministicFallback) {
    try {
      usageRow = await service.schema("app").rpc("reserve_model_usage", {
        p_request_id: idempotencyKey,
        p_request_hash: requestHash,
        p_model_id: modelId,
        p_reserved_cost_usd: reservedCost,
        p_cap_usd: OPENAI_DAILY_CAP_USD,
      }).then((result) => result.data as Record<string, unknown> | null);

      if (!usageRow) {
        throw new Error("budget_reservation_failed");
      }
    } catch (error) {
      await service.schema("app")
        .from("grading_results")
        .update({
          status: "failed",
          confidence: "low",
          uncertainty_reason: error instanceof Error
            ? error.message
            : "budget_reservation_failed",
        })
        .eq("request_id", idempotencyKey);

      return respond(
        {
          status: "budget_capped",
          function: "evaluate-attempt",
          operation,
          message:
            "Cramapple has reached today's research limit. Your work is saved. Please come back after the daily limit resets.",
        },
        { status: 429 },
      );
    }
  }

  if (isMcq) {
    const selectedChoice =
      summarizeSelectedChoice(responseParts as Record<string, unknown>) ??
        responseText?.trim() ??
        null;
    const correctChoice = Array.isArray(mcqChoices)
      ? mcqChoices.find((choice) => choice.is_correct)
      : null;
    const earned = selectedChoice &&
        correctChoice &&
        (selectedChoice === correctChoice.choice_key ||
          selectedChoice === correctChoice.choice_text)
      ? 1
      : 0;

    const normalizedSelection = selectedChoice?.trim().toUpperCase() ?? null;
    const chosenChoice = Array.isArray(mcqChoices)
      ? mcqChoices.find((choice) =>
        (typeof choice.choice_key === "string" &&
          choice.choice_key.trim().toUpperCase() === normalizedSelection) ||
        (typeof choice.choice_text === "string" && selectedChoice !== null &&
          choice.choice_text.trim() === selectedChoice.trim())
      ) ?? null
      : null;

    const { skillLabels, unitNumber } = await loadMcqFeedbackContext({
      service,
      contentVersion,
      earned,
    });

    const { summary, actionableFix, redirect } = composeMcqFeedback({
      earned: earned === 1,
      rationale: chosenChoice && !chosenChoice.is_correct
        ? chosenChoice.rationale
        : null,
      skillLabels,
      unitNumber,
      // Stable per item and per chosen distractor: the same result re-read
      // reads the same way, while two items in one session almost certainly
      // take different shapes.
      variantSeed: `${contentVersion.id}:${chosenChoice?.choice_key ?? ""}`,
    });

    const criteria: OutputCriterion[] = [
      {
        criterion_key: "mcq_correct_choice",
        status: earned ? "earned" : "not_yet_earned",
        points_awarded: earned,
        evidence_quote: selectedChoice,
        decision_explanation: earned
          ? "The selected choice matches the published correct answer."
          : "The submitted choice does not match the published correct answer.",
        minimum_fix: earned ? null : actionableFix,
      },
    ];

    const finalResult = {
      status: "graded",
      points_earned: earned,
      points_available: 1,
      criteria,
      highest_value_gap: earned ? null : {
        criterion_key: "mcq_correct_choice",
        minimum_fix: actionableFix,
        repair_prompt: redirect,
      },
      predicted_improvement: null,
      confidence: "high",
      uncertainty_reason: null,
      student_facing_summary: summary,
    };

    const gradePayload = {
      status: "graded",
      points_earned: finalResult.points_earned,
      points_available: finalResult.points_available,
      criterion_results: finalResult.criteria,
      highest_value_gap: finalResult.highest_value_gap,
      predicted_label: null,
      predicted_point_gain: null,
      actual_point_gain: null,
      prediction_outcome: null,
      confidence: finalResult.confidence,
      uncertainty_reason: null,
      model_id: "rule-based-mcq",
      prompt_version: promptVersion,
      rubric_version_id: effectiveRubricVersionId,
      deterministic_verifier_version: MATH_VERIFIER_VERSION,
      boundary_contract_version: verificationProfile?.profile_version ?? null,
      feedback_preview: finalResult.student_facing_summary,
      input_tokens: 0,
      output_tokens: 0,
      estimated_cost_usd: 0,
      latency_ms: 0,
      raw_model_response: null,
    };
    const finalized = await finalizeGrade({
      service,
      respond,
      idempotencyKey,
      requestHash,
      operation,
      storeRoute: routing.target,
      gradePayload,
      normalizedResponseSha256,
      cachedTokens: null,
      stageTimer,
      attempt,
      derivedAssistanceState,
      contentVersionId: contentVersion.id as string,
      subjectId: examPack.subject_id as string,
      criteria: finalResult.criteria,
      evaluatorVersion: "rule-based-mcq",
      finalStatus: "graded",
      pointsEarned: finalResult.points_earned,
      pointsAvailable: finalResult.points_available,
      confidence: finalResult.confidence,
      summary: finalResult.student_facing_summary,
      truthRoute: "deterministic",
      attemptTruthFirst: true,
      memory: {
        sessionId: attempt.learning_session_id as string | null,
        attemptId: attempt.id,
        attemptMode: attempt.attempt_mode as string,
        assistanceState: derivedAssistanceState as string,
        finalStatus: "graded",
        pointsEarned: finalResult.points_earned,
        pointsAvailable: finalResult.points_available,
        confidence: finalResult.confidence,
        highestValueGap: finalResult.highest_value_gap,
        criteria,
        summary: finalResult.student_facing_summary,
        feedbackPreview: finalResult.student_facing_summary,
        actionHint: null,
        repairHint: finalResult.highest_value_gap?.repair_prompt ?? null,
        deterministicCheck: statisticsCheck,
        examPackVersionId: attempt.exam_pack_version_id as string,
      },
    });
    if (finalized instanceof Response) return finalized;
    const { runtimeContext } = finalized;

    return respond(
      {
        status: "graded",
        function: "evaluate-attempt",
        operation,
        result: finalResult,
        runtime_context: runtimeContext,
      },
      { status: 200 },
    );
  }

  let modelResponse: {
    raw: Record<string, unknown>;
    parsed: Record<string, unknown>;
    elapsedMs: number;
  } | null = null;
  let finalStatus: "graded" | "uncertain" | "failed" = "failed";
  let finalPayload:
    | ReturnType<typeof sanitizeModelResult>
    | ReturnType<typeof buildShadowReviewPayload>
    | ReturnType<typeof buildDeterministicGradedPayload>
    | NonNullable<ReturnType<typeof buildStatisticsDeterministicFallback>>
    | null = null;
  let inputTokens = estimatedInputTokens;
  let outputTokens = 0;
  let actualCost = 0;
  // Passive telemetry only -- null means "provider reported nothing".
  let cachedTokensTelemetry: number | null = null;
  // Engine 3 shadow capture (TASK-0016 addendum, 2026-08-14): the
  // symbolic_ecf path's real ECF verdict was previously discarded --
  // finalStatus stays "uncertain" either way (shadow, non-authoritative),
  // but the actual computed result is now retained here instead of only
  // surviving as a substring inside uncertainty_reason's JSON.stringify.
  let shadowResult: Record<string, unknown> | null = null;
  // Stamped into grading_results.deterministic_verifier_version. Defaults to the
  // math/ECF verifier; the data_driven branch overrides it so a generated grade
  // is attributed to the verifier that actually produced it (Fable QA #4).
  let deterministicVerifierVersion = MATH_VERIFIER_VERSION;

  // Deterministic and held routes never call the model: no tokens, no cost.
  const routeContext = {
    contentItem,
    contentVersion,
    responseText,
    responseParts,
    promptBase,
    routing,
    statisticsCheck,
    defaultPointsAvailable,
    verificationProfile,
    verificationProfileSummary,
  };
  if (routing.target === "symbolic_ecf") {
    ({ finalPayload, finalStatus, shadowResult } = gradeSymbolicEcf(routeContext));
    modelResponse = null;
    inputTokens = 0;
    outputTokens = 0;
    actualCost = 0;
  } else if (routing.target === "data_driven") {
    ({ finalPayload, finalStatus, shadowResult, deterministicVerifierVersion } =
      await gradeDataDriven(service, routeContext));
    modelResponse = null;
    inputTokens = 0;
    outputTokens = 0;
    actualCost = 0;
  } else if (routing.target === "shadow_review") {
    ({ finalPayload, finalStatus } = gradeShadowReview(routeContext));
    modelResponse = null;
    inputTokens = 0;
    outputTokens = 0;
    actualCost = 0;
  } else {
    if (statisticsDeterministicFallback) {
      finalPayload = statisticsDeterministicFallback;
      finalStatus = "uncertain";
      modelResponse = null;
      inputTokens = 0;
      outputTokens = 0;
      actualCost = 0;
    } else {
      const gradingArmForRequest = gradingArm();
      const systemPrompt = buildGraderSystemPrompt(
        gradingArmForRequest,
        examPack.exam_name as string,
      );

      try {
        await service.schema("app").from("grading_results").update({
          status: "processing",
          model_id: routedModelId,
          estimated_cost_usd: reservedCost,
          prompt_version: promptVersion,
          rubric_version_id: effectiveRubricVersionId,
          deterministic_verifier_version: MATH_VERIFIER_VERSION,
          boundary_contract_version: verificationProfile?.profile_version ??
            null,
        }).eq("request_id", idempotencyKey);

        if (usageRow) {
          await service.schema("app").from("model_usage_ledger").update({
            status: "running",
          }).eq("request_id", idempotencyKey);
        }

        const graded = await runModelGrading({
          arm: gradingArmForRequest,
          modelId,
          systemPrompt,
          promptBase,
          sanitizeContext: { responseText, responseParts },
          userIdHash: await sha256Hex(user.id),
          idempotencyKey,
          // Record what is known before sanitization, which can throw: arm B
          // keeps the raw response and latency for the stored row, arm A keeps
          // its cached-token telemetry (see ModelReturnedEvent).
          onModelReturned: (event) => {
            stageTimer.mark("model");
            if (event.arm === "a") cachedTokensTelemetry = event.cachedTokens;
            else modelResponse = event.response;
          },
        });
        finalPayload = graded.finalPayload;
        modelResponse = graded.response;
        inputTokens = graded.inputTokens ?? inputTokens;
        outputTokens = graded.outputTokens ?? outputTokens;
        cachedTokensTelemetry = graded.cachedTokens;
        stageTimer.mark("sanitize");

        // O2 (2026-08-13): the model graded the whole item normally above --
        // now force just the deterministic-flagged criteria back to
        // unable_to_determine, leaving every other criterion's real,
        // model-graded verdict (and points) intact.
        if (statisticsScopedCriteriaKeys && finalPayload && statisticsCheck) {
          finalPayload = {
            ...finalPayload,
            ...applyDeterministicFlagScope(
              finalPayload,
              promptBase.criteria,
              statisticsScopedCriteriaKeys,
              statisticsCheck.reason,
            ),
          };
        }

        finalStatus = finalPayload.status === "graded" ? "graded" : "uncertain";

        const pricingInputTokens = inputTokens;
        const pricingOutputTokens = outputTokens;
        actualCost = money(
          (pricingInputTokens / 1_000_000) * OPENAI_INPUT_PRICE_PER_1M +
            (pricingOutputTokens / 1_000_000) * OPENAI_OUTPUT_PRICE_PER_1M,
        );
      } catch (error) {
        const errorMessage = error instanceof Error
          ? error.message
          : "grading_failed";
        finalStatus = "uncertain";
        finalPayload = {
          status: finalStatus,
          points_earned: 0,
          points_available: defaultPointsAvailable,
          criteria: buildFallbackCriteria(
            promptBase.criteria,
            "Cramapple can offer a few useful observations, but it is not confident enough to present this result as reliable.",
          ),
          highest_value_gap: null,
          predicted_improvement: null,
          confidence: "low",
          uncertainty_reason: errorMessage,
          student_facing_summary:
            "Your answer is saved, but feedback is taking longer than expected.",
          action_hint: null,
          repair_hint: null,
          sanitization_version: "grading-sanitizer-v3",
          integrity_issues: [{
            code: "criteria_missing" as const,
            criterion_key: null,
          }],
          // The model never returned, so nothing was reconciled.
          normalizations: [],
        };
      } finally {
        if (usageRow) {
          await service.schema("app").rpc("complete_model_usage", {
            p_request_id: idempotencyKey,
            p_request_hash: requestHash,
            p_status: finalStatus === "graded" ? "completed" : "failed",
            p_actual_cost_usd: actualCost,
            p_input_tokens: inputTokens,
            p_output_tokens: outputTokens,
          });
        }
      }
    }
  }

  if (!finalPayload) {
    return respond({ error: "grading_failed" }, { status: 500 });
  }

  const { data: previousResult } = await service.schema("app")
    .from("grading_results")
    .select("points_earned, status")
    .eq("attempt_id", attempt.id)
    .neq("request_id", idempotencyKey)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  const actualPointGain = previousResult &&
      "points_earned" in previousResult &&
      previousResult.points_earned !== null &&
      finalPayload.points_earned !== null &&
      finalPayload.points_earned !== undefined
    ? Number(finalPayload.points_earned) - Number(previousResult.points_earned)
    : null;

  const predictedPointGain =
    finalPayload.predicted_improvement?.predicted_point_gain ?? null;
  const predictionOutcome =
    predictedPointGain !== null && actualPointGain !== null
      ? predictedPointGain === actualPointGain
        ? "matched"
        : predictedPointGain < actualPointGain
        ? "under_predicted"
        : "over_predicted"
      : null;

  const highestValueGap = finalPayload.highest_value_gap ?? pickHighestGap(
    finalPayload.criteria,
    promptBase.criteria,
  );
  const feedbackPreview = finalPayload.student_facing_summary;
  const actionHint = finalPayload.action_hint ??
    (statisticsCheck?.status === "flag" ? "show_scaffold" : null);
  const repairHint = resolveFormulaRepairHint(
    finalPayload.repair_hint ?? statisticsCheck?.repair_hint,
    highestValueGap,
  );
  const repairPlan = buildRepairPlan({
    lockedGrade: lockGradeDecision({
      gradeFingerprint:
        `${idempotencyKey}:${promptVersion}:${effectiveRubricVersionId}`,
      pointsEarned: finalPayload.points_earned,
      pointsAvailable: finalPayload.points_available,
      criteria: finalPayload.criteria,
    }),
    sourceCriteria: promptBase.criteria,
    deterministicCheck: statisticsCheck,
  });

  const updatePayload = {
    status: finalStatus,
    points_earned: finalPayload.points_earned,
    points_available: finalPayload.points_available,
    criterion_results: finalPayload.criteria,
    highest_value_gap: highestValueGap,
    predicted_label: finalPayload.predicted_improvement?.label ?? null,
    predicted_point_gain: predictedPointGain,
    actual_point_gain: actualPointGain,
    prediction_outcome: predictionOutcome,
    confidence: finalPayload.confidence,
    uncertainty_reason: finalPayload.uncertainty_reason,
    model_id: routedModelId,
    prompt_version: promptVersion,
    rubric_version_id: effectiveRubricVersionId,
    deterministic_verifier_version: deterministicVerifierVersion,
    boundary_contract_version: verificationProfile?.profile_version ?? null,
    feedback_preview: feedbackPreview,
    action_hint: actionHint,
    repair_hint: repairHint,
    input_tokens: inputTokens,
    output_tokens: outputTokens,
    estimated_cost_usd: routing.target === "llm_text"
      ? (statisticsDeterministicFallback ? 0 : actualCost || reservedCost)
      : 0,
    latency_ms: modelResponse?.elapsedMs ?? 0,
    raw_model_response: modelResponse?.raw ?? null,
    shadow_result: shadowResult,
  };

  // Fired before this update commits, so the "prior graded results" count
  // below can't see this request's own row (still status='processing').
  if (
    profile.role === "student" &&
    (finalStatus === "graded" || finalStatus === "uncertain")
  ) {
    const { data: priorAttempts } = await service.schema("app")
      .from("attempts")
      .select("id")
      .eq("user_id", user.id);
    const priorAttemptIds = (priorAttempts ?? []).map((row) => row.id);
    let isFirstGradedResponse = true;
    if (priorAttemptIds.length > 0) {
      const { count } = await service.schema("app")
        .from("grading_results")
        .select("id", { count: "exact", head: true })
        .in("attempt_id", priorAttemptIds)
        .in("status", ["graded", "uncertain"]);
      isFirstGradedResponse = (count ?? 0) === 0;
    }
    if (isFirstGradedResponse) {
      await recordGrowthEvent(service, {
        eventName: "first_response_graded",
        userId: user.id,
        source: "web",
        dedupeKey: `first_response_graded:${user.id}`,
      });
    }
  }

  const finalized = await finalizeGrade({
    service,
    respond,
    idempotencyKey,
    requestHash,
    operation,
    storeRoute: routing.target,
    gradePayload: updatePayload,
    normalizedResponseSha256,
    cachedTokens: cachedTokensTelemetry,
    stageTimer,
    attempt,
    derivedAssistanceState,
    contentVersionId: contentVersion.id as string,
    subjectId: examPack.subject_id as string,
    criteria: finalPayload.criteria,
    evaluatorVersion: routedModelId,
    finalStatus,
    pointsEarned: finalPayload.points_earned,
    pointsAvailable: finalPayload.points_available,
    confidence: finalPayload.confidence,
    summary: finalPayload.student_facing_summary,
    truthRoute: "model_graded",
    attemptTruthFirst: false,
    memory: {
      sessionId: attempt.learning_session_id as string | null,
      attemptId: attempt.id,
      attemptMode: attempt.attempt_mode as string,
      assistanceState: derivedAssistanceState as string,
      finalStatus,
      pointsEarned: finalPayload.points_earned,
      pointsAvailable: finalPayload.points_available,
      confidence: finalPayload.confidence,
      highestValueGap,
      criteria: finalPayload.criteria,
      summary: finalPayload.student_facing_summary,
      repairHint,
      feedbackPreview,
      examPackVersionId: attempt.exam_pack_version_id as string,
      gradingRoute: routing,
      verificationProfile,
      verificationProfileSummary,
      actionHint,
      deterministicCheck: statisticsCheck,
    },
  });
  if (finalized instanceof Response) return finalized;
  const { runtimeContext } = finalized;

  return respond(
    buildEvaluateAttemptResponse({
      status: finalStatus,
      operation: operation as AllowedOperation,
      result: buildEvaluateAttemptResult({
        finalPayload,
        actualPointGain,
        predictionOutcome,
        routedModelId,
        promptVersion,
        rubricVersionId: effectiveRubricVersionId,
        gradingRoute: routing,
        verificationProfile,
        verificationProfileSummary,
        feedbackPreview,
        actionHint,
        repairHint,
        repairPlan,
        deterministicCheck: statisticsCheck,
        attemptId: attempt.id,
        responseVersionId: responseVersion.id,
        requestId: idempotencyKey,
        latencyMs: modelResponse?.elapsedMs ?? 0,
      }),
      runtimeContext,
    }),
    { status: finalStatus === "graded" ? 200 : 202 },
  );
}

if (import.meta.main) {
  Deno.serve((req) => handleEvaluateAttempt(req));
}
