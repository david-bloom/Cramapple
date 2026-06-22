import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

// submit-response flips a response_version from draft to submitted, so the
// next evaluate-attempt call can grade it. evaluate-attempt requires
// response_versions.is_submitted = true (see
// supabase/functions/evaluate-attempt/index.ts), but the RLS policy on
// response_versions explicitly forbids authenticated users from updating
// is_submitted (the WITH CHECK clause demands is_submitted = false on the
// new row). The transition must be server-mediated. This function is that
// mediator: it authenticates the caller, verifies ownership and current
// state, then uses service_role to perform the atomic update plus audit
// log entry.

type SubmitOperation = "submit_response";

const ALLOWED_OPERATIONS = new Set<SubmitOperation>(["submit_response"]);

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asUuid(value: unknown) {
  return typeof value === "string" &&
      /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/
        .test(value)
    ? value
    : null;
}

async function sha256Hex(value: string) {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

async function loadIdempotentResult(
  service: ReturnType<typeof createServiceClient>,
  requestId: string,
  requestHash: string,
  operation: SubmitOperation,
) {
  const { data, error } = await service.schema("app")
    .from("audit_events")
    .select("request_id, reason_code, metadata")
    .eq("request_id", requestId)
    .eq("reason_code", operation)
    .maybeSingle();

  if (error) {
    throw error;
  }

  if (!data) {
    return null;
  }

  const metadata = data.metadata && typeof data.metadata === "object"
    ? data.metadata as Record<string, unknown>
    : null;

  if (!metadata || metadata.request_hash !== requestHash) {
    return { conflict: true as const };
  }

  return metadata.result
    ? { result: metadata.result as Record<string, unknown> }
    : { result: null };
}

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") {
    return respond({ ok: true }, { status: 200 });
  }

  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }

  const bodyRecord = body as Record<string, unknown>;
  const operation = asString(bodyRecord.operation) as SubmitOperation | null;
  if (!operation || !ALLOWED_OPERATIONS.has(operation)) {
    return respond({ error: "invalid_operation" }, { status: 400 });
  }

  const attemptId = asUuid(bodyRecord.attempt_id ?? bodyRecord.attemptId);
  const responseVersionId = asUuid(
    bodyRecord.response_version_id ?? bodyRecord.responseVersionId,
  );
  const idempotencyKey = asString(
    bodyRecord.idempotency_key ?? bodyRecord.idempotencyKey ??
      bodyRecord.request_id ?? bodyRecord.requestId,
  );

  if (!attemptId || !responseVersionId) {
    return respond(
      {
        error: "missing_required_fields",
        required: ["attempt_id", "response_version_id"],
      },
      { status: 400 },
    );
  }

  if (!idempotencyKey) {
    return respond({ error: "missing_idempotency_key" }, { status: 400 });
  }

  const profileResult = await requireProfile(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }

  const { user, profile } = profileResult;
  const role = profile.role as string;
  if (role !== "student" && role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const service = createServiceClient();
  const requestHash = await sha256Hex(
    JSON.stringify({ operation, attemptId, responseVersionId, idempotencyKey }),
  );

  // Idempotent replay path: if we already recorded this submission under
  // the same (request_id, reason_code), return the cached result. A
  // different payload hash with the same key is a 409 conflict.
  const dedup = await loadIdempotentResult(
    service,
    idempotencyKey,
    requestHash,
    operation,
  ).catch((error) => {
    console.error("audit_event_lookup_failed", error);
    return { lookupError: true as const };
  });

  if (dedup && "lookupError" in dedup) {
    return respond(
      { error: "submit_audit_lookup_failed" },
      { status: 500 },
    );
  }

  if (dedup) {
    if ("conflict" in dedup) {
      return respond({ error: "idempotency_conflict" }, { status: 409 });
    }
    return respond(
      {
        status: "ok",
        function: "submit-response",
        operation,
        result: dedup.result,
      },
      { status: 200 },
    );
  }

  // Load attempt + response_version atomically to verify ownership and
  // current state before any mutation.
  const [
    { data: attempt, error: attemptError },
    { data: responseVersion, error: responseError },
  ] = await Promise.all([
    service.schema("app")
      .from("attempts")
      .select(
        "id, user_id, status, submitted_at, learning_session_id, content_item_version_id",
      )
      .eq("id", attemptId)
      .maybeSingle(),
    service.schema("app")
      .from("response_versions")
      .select("id, attempt_id, is_submitted, submitted_at, version_number")
      .eq("id", responseVersionId)
      .maybeSingle(),
  ]);

  if (attemptError || responseError) {
    return respond({ error: "submit_lookup_failed" }, { status: 500 });
  }

  if (!attempt || !responseVersion) {
    return respond({ error: "not_found" }, { status: 404 });
  }

  // Admin may submit on behalf of a learner (for ops / support cases),
  // students only their own.
  if (attempt.user_id !== user.id && role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  if (responseVersion.attempt_id !== attempt.id) {
    return respond(
      { error: "response_attempt_mismatch" },
      { status: 409 },
    );
  }

  // attempts that have already been graded cannot accept a new submission.
  // 'draft' is the normal pre-submission state; 'failed' covers retry of a
  // previously-failed submission. Anything else is a no-op or a conflict.
  if (
    attempt.status !== "draft" &&
    attempt.status !== "failed"
  ) {
    return respond(
      { error: "attempt_not_submittable", attempt_status: attempt.status },
      { status: 409 },
    );
  }

  if (responseVersion.is_submitted) {
    return respond(
      { error: "response_already_submitted" },
      { status: 409 },
    );
  }

  const submittedAt = new Date().toISOString();

  // Update response_versions first, then attempts. If the second update
  // fails the response_version is still flagged as submitted, but
  // attempts.status stays at 'draft' — the next submit-response call will
  // surface 'response_already_submitted' and the client can recover. The
  // alternative (transactional via an RPC) is more correct but heavier;
  // the rate of failure on a service_role update is low enough that
  // sequential is acceptable for now.
  const { error: responseUpdateError } = await service.schema("app")
    .from("response_versions")
    .update({
      is_submitted: true,
      submitted_at: submittedAt,
    })
    .eq("id", responseVersionId);

  if (responseUpdateError) {
    return respond(
      { error: "response_submit_failed" },
      { status: 500 },
    );
  }

  const { error: attemptUpdateError } = await service.schema("app")
    .from("attempts")
    .update({
      status: "submitted",
      submitted_at: submittedAt,
    })
    .eq("id", attemptId);

  if (attemptUpdateError) {
    return respond(
      { error: "attempt_submit_failed" },
      { status: 500 },
    );
  }

  const result = {
    attempt_id: attempt.id,
    response_version_id: responseVersion.id,
    status: "submitted",
    submitted_at: submittedAt,
  };

  const { error: auditError } = await service.schema("app")
    .from("audit_events")
    .insert({
      audit_event_id: crypto.randomUUID(),
      occurred_at: submittedAt,
      actor_type: "human",
      actor_id: user.id,
      action: "submit_response.submit_response",
      object_type: "response_version",
      object_id: responseVersion.id,
      request_id: idempotencyKey,
      reason_code: operation,
      metadata: {
        request_hash: requestHash,
        attempt_id: attempt.id,
        actor_role: role,
        result,
      },
      event_sha256: await sha256Hex(
        JSON.stringify({ operation, requestHash, result }),
      ),
      created_at: submittedAt,
    });

  if (auditError) {
    // Audit failure is logged but does not roll back the submission —
    // the response_versions / attempts updates already landed and the
    // student deserves a successful response. The audit gap will surface
    // in the operational dashboard.
    console.error("submit_response_audit_failed", auditError);
  }

  return respond(
    {
      status: "ok",
      function: "submit-response",
      operation,
      result,
    },
    { status: 200 },
  );
});
