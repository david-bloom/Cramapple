import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

// submit-response flips a response_version from draft to submitted, so the
// next evaluate-attempt call can grade it. evaluate-attempt requires
// response_versions.is_submitted = true, but the RLS policy on
// response_versions explicitly forbids authenticated users from updating
// is_submitted (the WITH CHECK clause demands is_submitted = false on the
// new row). The transition must be server-mediated.
//
// All write-side work is delegated to app.submit_response (defined in
// migration 202606210007). The RPC runs as SECURITY DEFINER under
// service_role, locks the attempt and response_version rows with
// SELECT ... FOR UPDATE, validates state inside the lock, and performs the
// two updates plus the audit insert in one transaction. That eliminates
// the partial-failure window the prior two-statement implementation had
// and the concurrent-submit race where two callers could both pass the
// pre-check.
//
// This function is now a thin authn / input-validation wrapper that
// extracts the caller identity from the JWT, validates UUIDs and the
// idempotency key, then calls the RPC. Error codes raised by the RPC use
// the prefix 'submit_response:<code>[:<detail>]' and are mapped to HTTP
// statuses below.

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

type RpcErrorMapping = {
  status: number;
  body: Record<string, unknown>;
};

function mapRpcError(rpcMessage: string | undefined): RpcErrorMapping {
  if (typeof rpcMessage !== "string") {
    return { status: 500, body: { error: "submit_response_failed" } };
  }

  // Extract the 'submit_response:<code>[:<detail>]' payload regardless of
  // any framing Postgres / postgrest-js wraps around it.
  const match = rpcMessage.match(/submit_response:([a-z_]+)(?::(.+))?/);
  if (!match) {
    return { status: 500, body: { error: "submit_response_failed" } };
  }

  const [, code, detail] = match;
  switch (code) {
    case "idempotency_conflict":
      return { status: 409, body: { error: "idempotency_conflict" } };
    case "attempt_not_found":
    case "response_not_found":
      return { status: 404, body: { error: "not_found" } };
    case "forbidden":
      return { status: 403, body: { error: "forbidden" } };
    case "response_attempt_mismatch":
      return { status: 409, body: { error: "response_attempt_mismatch" } };
    case "attempt_not_submittable":
      return {
        status: 409,
        body: detail
          ? {
            error: "attempt_not_submittable",
            attempt_status: detail.trim(),
          }
          : { error: "attempt_not_submittable" },
      };
    case "response_already_submitted":
      return { status: 409, body: { error: "response_already_submitted" } };
    default:
      return { status: 500, body: { error: "submit_response_failed" } };
  }
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

  const requestHash = await sha256Hex(
    JSON.stringify({ operation, attemptId, responseVersionId, idempotencyKey }),
  );

  const service = createServiceClient();
  const { data, error } = await service.schema("app").rpc("submit_response", {
    p_attempt_id: attemptId,
    p_response_version_id: responseVersionId,
    p_actor_id: user.id,
    p_actor_role: role,
    p_idempotency_key: idempotencyKey,
    p_request_hash: requestHash,
  });

  if (error) {
    const mapped = mapRpcError(error.message);
    return respond(mapped.body, { status: mapped.status });
  }

  return respond(
    {
      status: "ok",
      function: "submit-response",
      operation,
      result: data,
    },
    { status: 200 },
  );
});
