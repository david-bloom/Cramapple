import { persistCellState } from "../_shared/cell-state-persist.ts";
import { persistGradingMemory } from "../_shared/grading-memory.ts";
import { createStageTimer } from "../_shared/grading-telemetry.ts";
import {
  checkpointGradeWrite,
  GRADE_STORE_FAILURE,
  type OutputCriterion,
  persistAttemptCriterionResults,
  persistGradingTelemetry,
  type Service,
  writeGradeResult,
} from "./grade-store.ts";
import { type Respond } from "./request.ts";

// The post-grade sequence shared by the MCQ path and every other route
// (TASK-0079 S5). Both used to carry their own copy. The order is fixed:
//   1. store the grade (on failure: checkpoint for a same-key retry, respond 500)
//   2. telemetry and per-criterion rows (best-effort)
//   3. attempt truth row (error logged, never fails the grade)
//      -- the MCQ path has always written 3 before 2 (attemptTruthFirst); the
//      writes are independent, so the order is kept rather than normalised.
//   4. grading memory
//   5. Course Mode cell mastery (best-effort)
// Returns the runtime context for the response, or the store-failure Response.

export async function finalizeGrade(input: {
  service: Service;
  respond: Respond;
  idempotencyKey: string;
  requestHash: string;
  operation: string;
  // Label for the grade-store failure log (the routing target).
  storeRoute: string;
  gradePayload: Record<string, unknown>;
  normalizedResponseSha256: string | null;
  cachedTokens: number | null;
  stageTimer: ReturnType<typeof createStageTimer>;
  // deno-lint-ignore no-explicit-any
  attempt: Record<string, any>;
  derivedAssistanceState: string | null;
  contentVersionId: string;
  subjectId: string;
  criteria: OutputCriterion[];
  evaluatorVersion: string;
  finalStatus: "graded" | "uncertain" | "failed";
  pointsEarned: number;
  pointsAvailable: number;
  confidence: unknown;
  summary: unknown;
  // Label for the attempt-truth failure log.
  truthRoute: "deterministic" | "model_graded";
  attemptTruthFirst: boolean;
  memory: Omit<Parameters<typeof persistGradingMemory>[0], "service">;
}): Promise<Response | { runtimeContext: Awaited<ReturnType<typeof persistGradingMemory>> }> {
  const {
    service,
    respond,
    idempotencyKey,
    requestHash,
    operation,
    attempt,
    derivedAssistanceState,
    finalStatus,
  } = input;

  const { data: storedGrade, error: gradeStoreError } = await writeGradeResult(
    service,
    idempotencyKey,
    requestHash,
    input.gradePayload,
  );
  if (gradeStoreError || !storedGrade) {
    console.error("evaluate-attempt:grade_store_failed", {
      request_id: idempotencyKey,
      route: input.storeRoute,
      code: gradeStoreError?.code ?? "missing_row",
    });
    const retryable = await checkpointGradeWrite(
      service,
      idempotencyKey,
      requestHash,
      operation,
      input.gradePayload,
    );
    return respond({
      error: GRADE_STORE_FAILURE,
      retryable,
      ...(!retryable ? { reconciliation_required: true } : {}),
    }, { status: 500 });
  }

  const writeTelemetry = async () => {
    // Passive telemetry, best-effort: separate write so the main update above
    // keeps working against the pre-migration schema (see
    // 20260811TBD_grading_telemetry.sql).
    await Promise.all([
      persistGradingTelemetry(service, idempotencyKey, {
        normalized_response_sha256: input.normalizedResponseSha256,
        cached_tokens: input.cachedTokens,
        stage_timings: input.stageTimer.finish(),
      }),
      persistAttemptCriterionResults(
        service,
        attempt.id as string,
        input.criteria,
        input.evaluatorVersion,
      ),
    ]);
  };

  const writeAttemptTruth = async () => {
    // STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md Phase 0 item 6 finding:
    // this write was previously fire-and-forget (no error captured), and a live
    // audit found attempts.status/graded_at/confidence_level/score_points/
    // result_summary are 0% populated in Production despite grading_results
    // (updated just above) being genuinely correct -- i.e. this exact update has
    // apparently never once succeeded on real traffic. The leading suspect is
    // app.attempts' attempts_prevent_client_grading_truth_update trigger, which
    // only permits these columns to change when the request resolves to
    // service_role -- capturing and logging the error here (rather than
    // continuing to swallow it) is the only way to confirm the actual cause the
    // next time a real attempt is graded, without guessing at a fix blind.
    //
    // TASK-0079 bug 5: fenced on status = 'submitted', the same fence the
    // replay-recovery path and record_manual_grade use. app.submit_response
    // only moves an attempt to 'submitted' from draft/failed, so a finalized
    // attempt is never legitimately re-scored here; without the fence a late
    // or duplicate grade (a new idempotency key) overwrote an earlier grade or
    // a human reviewer's. This request's own grade is still stored in
    // grading_results and returned; only the attempt row is left alone.
    const { data: updatedAttempt, error: attemptUpdateError } = await service
      .schema("app")
      .from("attempts")
      .update({
        status: finalStatus === "graded" ? "graded" : "uncertain",
        graded_at: new Date().toISOString(),
        score_points: input.pointsEarned,
        score_possible: input.pointsAvailable,
        confidence_level: input.confidence,
        result_state: finalStatus,
        result_summary: input.summary,
        assistance_state: derivedAssistanceState,
      })
      .eq("id", attempt.id)
      .eq("status", "submitted")
      .select("id")
      .maybeSingle();
    if (attemptUpdateError) {
      console.error("attempts_grading_truth_update_failed", {
        attempt_id: attempt.id,
        route: input.truthRoute,
        error: attemptUpdateError.message,
        code: (attemptUpdateError as { code?: string }).code,
      });
    } else if (!updatedAttempt) {
      console.warn("attempts_grading_truth_update_skipped_finalized", {
        attempt_id: attempt.id,
        route: input.truthRoute,
      });
    }
  };

  if (input.attemptTruthFirst) {
    await writeAttemptTruth();
    await writeTelemetry();
  } else {
    await writeTelemetry();
    await writeAttemptTruth();
  }

  const runtimeContext = await persistGradingMemory({
    service,
    ...input.memory,
  });

  // Course Mode F2/F3: update cell mastery for a cell-tagged item. No-op for
  // untagged items; routed on item identity, never session presence.
  // Best-effort -- never fails the grade. content_uncertain (uncertain/shadow)
  // records the attempt without writing false proficiency (CM-D07 / INV-3).
  await persistCellState({
    service,
    userId: attempt.user_id as string,
    contentItemVersionId: input.contentVersionId,
    attemptId: attempt.id as string,
    subjectId: input.subjectId,
    sessionId: attempt.learning_session_id as string | null,
    assistanceState: derivedAssistanceState,
    attemptMode: attempt.attempt_mode as string,
    preSubmitHintCount: attempt.pre_submit_hint_count as number | null,
    finalStatus,
    pointsEarned: input.pointsEarned,
    pointsAvailable: input.pointsAvailable,
    submittedAt: attempt.submitted_at as string | null,
  });

  return { runtimeContext };
}
