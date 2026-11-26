import { asRecord } from "../_shared/student-memory.ts";
import {
  GRADE_STORE_FAILURE,
  PENDING_GRADE_WRITE,
  PROCESSING_RECONCILIATION_MS,
  sanitizeGradingResultForClient,
  type Service,
  writeGradeResult,
} from "./grade-store.ts";
import { type Respond } from "./request.ts";

// Idempotent replay and grade-store recovery (TASK-0079 S4: moved verbatim from
// the closure inside handleEvaluateAttempt). The returned function answers a
// request whose grading_results row already exists.
export function createStoredResultResponder(ctx: {
  service: Service;
  respond: Respond;
  requestHash: string;
  operation: string;
  idempotencyKey: string;
  // deno-lint-ignore no-explicit-any
  attempt: Record<string, any>;
  derivedAssistanceState: string | null;
}) {
  const {
    service,
    respond,
    requestHash,
    operation,
    idempotencyKey,
    attempt,
    derivedAssistanceState,
  } = ctx;
  // Replays may recover a private pending write, but NEVER call the grader.
  const respondFromStoredResult = async (
    row: Record<string, unknown>,
    recover = true,
  ): Promise<Response> => {
    if (row.request_hash !== requestHash) {
      return respond({ error: "idempotency_conflict" }, { status: 409 });
    }
    if (
      row.status === "failed" && row.uncertainty_reason === GRADE_STORE_FAILURE
    ) {
      if (!recover) {
        return respond({ error: "grade_store_retry_conflict", retryable: true }, {
          status: 409,
        });
      }
      const checkpoint = asRecord(row.raw_model_response);
      const payload = asRecord(checkpoint.payload);
      const forbidden = [
        "id",
        "request_id",
        "request_hash",
        "attempt_id",
        "response_version_id",
        "operation",
        "created_at",
        "updated_at",
      ];
      if (
        checkpoint.kind !== PENDING_GRADE_WRITE ||
        checkpoint.request_hash !== requestHash ||
        checkpoint.operation !== operation ||
        !["graded", "uncertain"].includes(String(payload.status)) ||
        forbidden.some((key) => Object.hasOwn(payload, key)) ||
        typeof row.updated_at !== "string" ||
        !Number.isFinite(Date.parse(row.updated_at))
      ) {
        return respond({
          error: "grading_reconciliation_required",
          reconciliation_required: true,
        }, { status: 503 });
      }
      // The version fence admits one writer; losers read its committed result.
      const { data: recovered, error } = await writeGradeResult(
        service,
        idempotencyKey,
        requestHash,
        payload,
        row.updated_at,
      );
      if (error) {
        console.error("evaluate-attempt:grade_store_retry_failed", {
          request_id: idempotencyKey,
          code: error.code,
        });
        return respond({ error: GRADE_STORE_FAILURE, retryable: true }, {
          status: 500,
        });
      }
      if (recovered) return await respondFromStoredResult(recovered, false);
      const { data: latest, error: readError } = await service.schema("app").from(
        "grading_results",
      )
        .select("*").eq("request_id", idempotencyKey).maybeSingle();
      if (readError || !latest) {
        return respond({
          error: "grading_reconciliation_required",
          reconciliation_required: true,
        }, { status: 503 });
      }
      return await respondFromStoredResult(latest, false);
    }
    if (row.status === "processing") {
      const updatedAt = Date.parse(
        String(row.updated_at ?? row.created_at ?? ""),
      );
      if (
        !Number.isFinite(updatedAt) ||
        Date.now() - updatedAt >= PROCESSING_RECONCILIATION_MS
      ) {
        return respond({
          error: "grading_reconciliation_required",
          reconciliation_required: true,
        }, { status: 503 });
      }
    }
    // A grade recovered after a failed store must also reach the attempt truth
    // row used by progress. Retrying this projection never re-runs grading and
    // cannot overwrite an attempt another request has already finalized.
    if (["graded", "uncertain"].includes(String(row.status)) && attempt.status === "submitted") {
      try {
        const { data: updated, error } = await service.schema("app").from("attempts")
          .update({
            status: row.status,
            graded_at: row.updated_at ?? new Date().toISOString(),
            score_points: row.points_earned,
            score_possible: row.points_available,
            confidence_level: row.confidence,
            result_state: row.status,
            result_summary: row.feedback_preview,
            assistance_state: derivedAssistanceState,
          }).eq("id", attempt.id).eq("status", "submitted").select("id").maybeSingle();
        if (error) throw error;
        if (!updated) {
          const { data: latestAttempt, error: readError } = await service.schema("app").from("attempts")
            .select("status").eq("id", attempt.id).maybeSingle();
          if (readError || !["graded", "uncertain"].includes(String(latestAttempt?.status))) {
            throw readError ?? { code: "attempt_not_finalized" };
          }
        }
      } catch (error) {
        console.error("attempts_grading_truth_recovery_failed", {
          attempt_id: attempt.id,
          code: typeof error === "object" && error !== null && "code" in error ? error.code : "transport_error",
        });
        return respond({ error: "attempt_grade_store_failed", retryable: true }, { status: 503 });
      }
    }
    return respond({
      status: row.status,
      function: "evaluate-attempt",
      operation,
      result: sanitizeGradingResultForClient(row),
    }, { status: row.status === "processing" ? 202 : 200 });
  };
  return respondFromStoredResult;
}
