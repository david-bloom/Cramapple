import { createServiceClient } from "../_shared/supabase.ts";
import { OPENAI_REQUEST_TIMEOUT_MS } from "./config.ts";

// grading_results / attempt_criterion_results persistence helpers (TASK-0079
// S1: moved verbatim from index.ts).

export type Service = ReturnType<typeof createServiceClient>;

export type OutputCriterion = {
  criterion_key: string;
  status:
    | "earned"
    | "partially_earned"
    | "not_yet_earned"
    | "unable_to_determine"
    | "not_applicable";
  points_awarded: number;
  evidence_quote: string | null;
  decision_explanation: string | null;
  minimum_fix: string | null;
};

// re-QA finding 1: the idempotent-replay paths return the whole grading_results
// row. `shadow_result` now carries the data-driven verifier's per-check verdicts,
// whose reason strings embed the expected value/tolerance (the answer key), and
// `raw_model_response` carries the raw grader output — neither is ever
// student-facing (the curated public.grading_results view excludes them). Strip
// them from any replayed row so a re-POST of the same request can't leak them.
export function sanitizeGradingResultForClient(
  row: Record<string, unknown>,
): Record<string, unknown> {
  const { shadow_result: _shadow, raw_model_response: _raw, ...safe } = row;
  return safe;
}

// Best-effort write of the passive telemetry fields (stage timings,
// cached_tokens, normalized-response hash). The columns come from the
// 20260811TBD_grading_telemetry migration, which may not be applied yet --
// a failed write (e.g. 42703 undefined column) is logged and swallowed so
// telemetry can NEVER fail a grading. Kept separate from the main
// grading_results update for the same reason: the main update's payload
// must keep working against the pre-migration schema.
export async function persistGradingTelemetry(
  service: ReturnType<typeof createServiceClient>,
  requestId: string,
  telemetry: {
    normalized_response_sha256: string | null;
    cached_tokens: number | null;
    stage_timings: Record<string, number>;
  },
) {
  try {
    const { error } = await service.schema("app")
      .from("grading_results")
      .update(telemetry)
      .eq("request_id", requestId);
    if (error) {
      console.warn(
        "grading_telemetry_write_skipped",
        error.message ?? String(error),
      );
    }
  } catch (error) {
    console.warn("grading_telemetry_write_skipped", error);
  }
}

// app.attempt_criterion_results has had no writer since it was created
// (20260731160000_schema_baseline.sql) -- evaluate-attempt has only ever
// persisted per-criterion detail as jsonb inside grading_results.criterion_results.
// 20260731160400_criterion_partially_earned_status.sql widened the table's
// status CHECK specifically so a 'partially_earned' criterion would not fail
// to insert "the first time that table is wired up" -- this is that wiring.
// Best-effort and swallowed on failure, same rationale as
// persistGradingTelemetry above: a row-level detail table must never be able
// to fail a grade. Upserts on (attempt_id, criterion_key) -- the table's own
// unique index -- so a re-grade of the same attempt replaces its prior rows
// instead of violating the constraint.
export async function persistAttemptCriterionResults(
  service: ReturnType<typeof createServiceClient>,
  attemptId: string,
  criteria: OutputCriterion[],
  evaluatorVersion: string,
) {
  if (!Array.isArray(criteria) || criteria.length === 0) return;
  try {
    const rows = criteria.map((criterion) => ({
      attempt_id: attemptId,
      criterion_key: criterion.criterion_key,
      status: criterion.status,
      points_awarded: Math.trunc(Number(criterion.points_awarded || 0)),
      evidence_quote: criterion.evidence_quote ?? null,
      decision_explanation: criterion.decision_explanation ?? null,
      minimum_fix: criterion.minimum_fix ?? null,
      evaluator_version: evaluatorVersion,
    }));
    const { error } = await service.schema("app")
      .from("attempt_criterion_results")
      .upsert(rows, { onConflict: "attempt_id,criterion_key" });
    if (error) {
      console.warn(
        "attempt_criterion_results_write_skipped",
        error.message ?? String(error),
      );
    }
  } catch (error) {
    console.warn("attempt_criterion_results_write_skipped", error);
  }
}

export const GRADE_STORE_FAILURE = "grade_store_failed";
export const PENDING_GRADE_WRITE = "pending_grade_write_v1";
// A timeout is containment, never permission to re-run a model call.
export const PROCESSING_RECONCILIATION_MS = Math.max(
  10 * 60_000,
  2 * OPENAI_REQUEST_TIMEOUT_MS + 60_000,
);

export async function writeGradeResult(
  service: Service,
  requestId: string,
  requestHash: string,
  payload: Record<string, unknown>,
  priorVersion?: string,
) {
  try {
    let query = service.schema("app").from("grading_results").update(payload)
      .eq("request_id", requestId).eq("request_hash", requestHash);
    if (priorVersion) {
      query = query.eq("updated_at", priorVersion)
        .eq("status", "failed").eq("uncertainty_reason", GRADE_STORE_FAILURE);
    }
    return await query.select("*").maybeSingle();
  } catch {
    return { data: null, error: { code: "transport_error" } };
  }
}

export async function checkpointGradeWrite(
  service: Service,
  requestId: string,
  requestHash: string,
  operation: string,
  payload: Record<string, unknown>,
) {
  try {
    // Only a still-processing row can become retryable. Never downgrade a grade
    // whose write committed but whose acknowledgement was lost.
    const { data, error } = await service.schema("app").from("grading_results")
      .update({
        status: "failed",
        uncertainty_reason: GRADE_STORE_FAILURE,
        raw_model_response: {
          kind: PENDING_GRADE_WRITE,
          request_hash: requestHash,
          operation,
          payload,
        },
      }).eq("request_id", requestId).eq("request_hash", requestHash)
      .eq("status", "processing").select("request_id").maybeSingle();
    if (error) {
      console.error("evaluate-attempt:grade_checkpoint_failed", {
        request_id: requestId,
        code: error.code,
      });
    }
    return !error && !!data;
  } catch {
    console.error("evaluate-attempt:grade_checkpoint_failed", {
      request_id: requestId,
      code: "transport_error",
    });
    return false;
  }
}
