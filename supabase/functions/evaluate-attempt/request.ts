import { stringOrNull as asString, looseUuid as asUuid } from "../_shared/input.ts";
import {
  type AllowedOperation,
  type GradingExemplar,
} from "../_shared/grading-contract.ts";
import { EVALUATE_ATTEMPT_PROMPT_VERSION } from "./config.ts";

// Request-body parsing for evaluate-attempt (TASK-0079 S4: moved verbatim from
// handleEvaluateAttempt). Returns the parsed fields, or the 400 response the
// handler sends.

export type Respond = (body: unknown, init?: ResponseInit) => Response;

export const allowedOperations = new Set<AllowedOperation>([
  "grade_initial_attempt",
  "select_repair",
  "grade_revision",
  "grade_transfer_attempt",
]);

export function getBodyField(body: Record<string, unknown>, ...keys: string[]) {
  for (const key of keys) {
    const value = body[key];
    if (value !== undefined && value !== null) {
      return value;
    }
  }
  return undefined;
}

export function parseEvaluateRequest(
  body: Record<string, unknown>,
  respond: Respond,
) {
  const operation = asString(getBodyField(body, "operation"));
  if (!operation || !allowedOperations.has(operation as AllowedOperation)) {
    return respond({ error: "invalid_operation" }, { status: 400 });
  }

  const idempotencyKey = asString(
    getBodyField(
      body,
      "idempotency_key",
      "idempotencyKey",
      "request_id",
      "requestId",
    ),
  );
  const attemptId = asUuid(getBodyField(body, "attempt_id", "attemptId"));
  const responseVersionId = asUuid(
    getBodyField(body, "response_version_id", "responseVersionId"),
  );
  const artifactVersionId = asUuid(
    getBodyField(body, "artifact_version_id", "artifactVersionId"),
  );
  const requestedContentItemVersionId = asUuid(
    getBodyField(body, "content_item_version_id", "contentItemVersionId"),
  );
  const requestedRubricVersionId = asUuid(
    getBodyField(body, "rubric_version_id", "rubricVersionId"),
  );
  // Prompt rollout is server-controlled. The version comes from
  // EVALUATE_ATTEMPT_PROMPT_VERSION only — any prompt_version supplied in
  // the request body is ignored. This closes the loophole where a client
  // could otherwise select any published prompt row at request time and
  // bypass the env-controlled rollout gate documented in
  // 202606210005_seed_initial_prompt_versions.sql.
  const promptVersion = EVALUATE_ATTEMPT_PROMPT_VERSION;
  const assistanceCondition = asString(
    getBodyField(body, "assistance_condition", "assistanceCondition"),
  ) ?? "independent";
  // Per-request opt-in for the exemplar-grading pilot
  // (docs/research/exemplar_grading_pilot_2026_08/). Deliberately per-request,
  // not env-based like GRADING_ARM: the pilot's capture script needs to flip
  // between "off" and "with_exemplar" call-to-call without a redeploy.
  // Defaults to "off" and any unrecognized value collapses to "off", so
  // existing callers (which never send this field) are byte-for-byte
  // unaffected. Exemplar payloads are supplied directly by the pilot's
  // capture script (sourced from that pilot's own materialized fixtures, not
  // a DB fetch here) to avoid adding a DB round-trip to a latency-sensitive
  // grading path for what is currently pilot-only usage.
  const exemplarModeRaw = asString(
    getBodyField(body, "exemplar_mode", "exemplarMode"),
  );
  const exemplarMode = exemplarModeRaw === "with_exemplar"
    ? "with_exemplar"
    : "off";
  const requestExemplars = exemplarMode === "with_exemplar"
    ? (Array.isArray(getBodyField(body, "exemplars"))
      ? getBodyField(body, "exemplars") as GradingExemplar[]
      : undefined)
    : undefined;

  if (!idempotencyKey || !attemptId || !responseVersionId) {
    return respond(
      {
        error: "missing_required_fields",
        required: [
          "idempotency_key",
          "attempt_id",
          "response_version_id",
        ],
      },
      { status: 400 },
    );
  }
  return {
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
  };
}
