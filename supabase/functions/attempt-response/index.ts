import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

type Operation = "create_attempt" | "save_response" | "submit_response";

const ALLOWED_OPERATIONS = new Set<Operation>([
  "create_attempt",
  "save_response",
  "submit_response",
]);

const ATTEMPT_MODES = new Set(["mcq", "frq", "quantitative"]);
const ASSISTANCE_STATES = new Set(["independent", "coached", "exam_practice"]);

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

function asRecord(value: unknown) {
  return value && typeof value === "object" && !Array.isArray(value)
    ? value as Record<string, unknown>
    : {};
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
  operation: Operation,
) {
  const { data, error } = await service.schema("app")
    .from("audit_events")
    .select("metadata")
    .eq("request_id", requestId)
    .eq("reason_code", operation)
    .maybeSingle();

  if (error) throw error;
  if (!data) return null;

  const metadata = asRecord(data.metadata);
  if (metadata.request_hash !== requestHash) {
    return { conflict: true as const };
  }
  return { result: metadata.result ?? null };
}

async function recordIdempotentResult(
  service: ReturnType<typeof createServiceClient>,
  requestId: string,
  requestHash: string,
  operation: Operation,
  actorId: string,
  objectType: string,
  objectId: string,
  result: Record<string, unknown>,
) {
  const { error } = await service.schema("app").from("audit_events").insert({
    audit_event_id: crypto.randomUUID(),
    occurred_at: new Date().toISOString(),
    actor_type: "human",
    actor_id: actorId,
    action: `attempt_response.${operation}`,
    object_type: objectType,
    object_id: objectId,
    request_id: requestId,
    reason_code: operation,
    metadata: {
      request_hash: requestHash,
      result,
    },
    event_sha256: await sha256Hex(
      JSON.stringify({ operation, requestHash, result }),
    ),
    created_at: new Date().toISOString(),
  });
  if (error) throw error;
}

function mapSubmitError(message: string | undefined) {
  const match = typeof message === "string"
    ? message.match(/submit_response:([a-z_]+)(?::(.+))?/)
    : null;
  if (!match) return { status: 500, body: { error: "submit_response_failed" } };

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
    case "response_already_submitted":
      return { status: 409, body: { error: code } };
    case "attempt_not_submittable":
      return {
        status: 409,
        body: detail
          ? { error: "attempt_not_submittable", attempt_status: detail.trim() }
          : { error: "attempt_not_submittable" },
      };
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

  const b = body as Record<string, unknown>;
  const operation = asString(b.operation) as Operation | null;
  if (!operation || !ALLOWED_OPERATIONS.has(operation)) {
    return respond({ error: "invalid_operation" }, { status: 400 });
  }

  const idempotencyKey = asString(
    b.idempotency_key ?? b.idempotencyKey ?? b.request_id ?? b.requestId,
  );
  if (!idempotencyKey) {
    return respond({ error: "missing_idempotency_key" }, { status: 400 });
  }

  const profileResult = await requireProfile(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }

  const { user, profile } = profileResult;
  if (profile.role !== "student" && profile.role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const service = createServiceClient();
  const requestHash = await sha256Hex(JSON.stringify({ operation, ...b }));

  try {
    if (operation !== "submit_response") {
      const existing = await loadIdempotentResult(
        service,
        idempotencyKey,
        requestHash,
        operation,
      );
      if (existing) {
        if ("conflict" in existing) {
          return respond({ error: "idempotency_conflict" }, { status: 409 });
        }
        return respond(
          {
            status: "ok",
            function: "attempt-response",
            operation,
            result: existing.result,
          },
          { status: 200 },
        );
      }
    }

    if (operation === "create_attempt") {
      const learningSessionId = asUuid(
        b.learning_session_id ?? b.learningSessionId ?? b.session_id ??
          b.sessionId,
      );
      const contentItemVersionId = asUuid(
        b.content_item_version_id ?? b.contentItemVersionId,
      );
      const attemptMode = asString(b.attempt_mode ?? b.attemptMode);
      const assistanceState = asString(
        b.assistance_state ?? b.assistanceState,
      ) ?? "independent";

      if (!learningSessionId || !contentItemVersionId || !attemptMode) {
        return respond(
          {
            error: "missing_required_fields",
            required: [
              "learning_session_id",
              "content_item_version_id",
              "attempt_mode",
            ],
          },
          { status: 400 },
        );
      }
      if (!ATTEMPT_MODES.has(attemptMode)) {
        return respond({ error: "invalid_attempt_mode" }, { status: 400 });
      }
      if (!ASSISTANCE_STATES.has(assistanceState)) {
        return respond({ error: "invalid_assistance_state" }, { status: 400 });
      }

      const [
        { data: session, error: sessionError },
        { data: contentVersion, error: contentVersionError },
      ] = await Promise.all([
        service.schema("app")
          .from("learning_sessions")
          .select("id, user_id, exam_pack_version_id, status")
          .eq("id", learningSessionId)
          .maybeSingle(),
        service.schema("app")
          .from("content_item_versions")
          .select(
            "id, content_item_id, status, content_items!inner(exam_pack_version_id, item_type, status)",
          )
          .eq("id", contentItemVersionId)
          .maybeSingle(),
      ]);

      if (sessionError || !session) {
        return respond({ error: "session_not_found" }, { status: 404 });
      }
      if (session.user_id !== user.id && profile.role !== "admin") {
        return respond({ error: "forbidden" }, { status: 403 });
      }
      if (session.status !== "active") {
        return respond({ error: "session_not_active" }, { status: 409 });
      }

      if (contentVersionError || !contentVersion) {
        return respond({ error: "content_not_found" }, { status: 404 });
      }
      const contentItem = Array.isArray(contentVersion.content_items)
        ? contentVersion.content_items[0]
        : contentVersion.content_items;
      if (
        contentVersion.status !== "published" ||
        !contentItem ||
        contentItem.status !== "published"
      ) {
        return respond({ error: "content_not_available" }, { status: 409 });
      }
      if (contentItem.item_type !== attemptMode) {
        return respond({ error: "attempt_mode_mismatch" }, { status: 409 });
      }
      if (session.exam_pack_version_id !== contentItem.exam_pack_version_id) {
        return respond({ error: "session_content_mismatch" }, { status: 409 });
      }

      const { data: attempt, error: attemptError } = await service
        .schema("app")
        .from("attempts")
        .insert({
          user_id: user.id,
          learning_session_id: learningSessionId,
          exam_pack_version_id: contentItem.exam_pack_version_id,
          content_item_version_id: contentItemVersionId,
          attempt_mode: attemptMode,
          status: "draft",
          assistance_state: assistanceState,
        })
        .select(
          "id, user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode, status, assistance_state, started_at, created_at",
        )
        .maybeSingle();

      if (attemptError || !attempt) {
        return respond({ error: "attempt_create_failed" }, { status: 500 });
      }

      const result = { attempt };
      await recordIdempotentResult(
        service,
        idempotencyKey,
        requestHash,
        operation,
        user.id,
        "attempt",
        attempt.id as string,
        result,
      );

      return respond(
        { status: "ok", function: "attempt-response", operation, result },
        { status: 200 },
      );
    }

    if (operation === "save_response") {
      const attemptId = asUuid(b.attempt_id ?? b.attemptId);
      const parentResponseVersionId = asUuid(
        b.parent_response_version_id ?? b.parentResponseVersionId,
      );
      const responseText = asString(b.response_text ?? b.responseText);
      const responseParts = asRecord(b.response_parts ?? b.responseParts);

      if (!attemptId) {
        return respond(
          { error: "missing_required_fields", required: ["attempt_id"] },
          { status: 400 },
        );
      }
      if (!responseText && Object.keys(responseParts).length === 0) {
        return respond(
          {
            error: "missing_required_fields",
            required: ["response_text or response_parts"],
          },
          { status: 400 },
        );
      }

      const { data: attempt, error: attemptError } = await service
        .schema("app")
        .from("attempts")
        .select("id, user_id, status")
        .eq("id", attemptId)
        .maybeSingle();

      if (attemptError || !attempt) {
        return respond({ error: "attempt_not_found" }, { status: 404 });
      }
      if (attempt.user_id !== user.id && profile.role !== "admin") {
        return respond({ error: "forbidden" }, { status: 403 });
      }
      if (!["draft", "failed"].includes(attempt.status as string)) {
        return respond(
          {
            error: "attempt_not_editable",
            attempt_status: attempt.status,
          },
          { status: 409 },
        );
      }

      let responseVersion: Record<string, unknown> | null = null;
      let lastErrorCode: string | undefined;
      for (let attemptNumber = 0; attemptNumber < 3; attemptNumber++) {
        const { data: latest } = await service.schema("app")
          .from("response_versions")
          .select("version_number")
          .eq("attempt_id", attemptId)
          .order("version_number", { ascending: false })
          .limit(1)
          .maybeSingle();
        const nextVersion = Number(latest?.version_number ?? 0) + 1;

        const { data, error } = await service.schema("app")
          .from("response_versions")
          .insert({
            attempt_id: attemptId,
            parent_response_version_id: parentResponseVersionId,
            response_text: responseText,
            response_parts: responseParts,
            version_number: nextVersion,
            is_submitted: false,
            created_by: user.id,
          })
          .select(
            "id, attempt_id, parent_response_version_id, response_text, response_parts, version_number, is_submitted, submitted_at, created_at",
          )
          .maybeSingle();

        if (!error && data) {
          responseVersion = data as Record<string, unknown>;
          break;
        }
        lastErrorCode = error?.code;
        if (error?.code !== "23505") break;
      }

      if (!responseVersion) {
        return respond(
          {
            error: lastErrorCode === "23505"
              ? "response_version_conflict"
              : "response_save_failed",
          },
          { status: 500 },
        );
      }

      const result = { response_version: responseVersion };
      await recordIdempotentResult(
        service,
        idempotencyKey,
        requestHash,
        operation,
        user.id,
        "response_version",
        responseVersion.id as string,
        result,
      );

      return respond(
        { status: "ok", function: "attempt-response", operation, result },
        { status: 200 },
      );
    }

    const attemptId = asUuid(b.attempt_id ?? b.attemptId);
    const responseVersionId = asUuid(
      b.response_version_id ?? b.responseVersionId,
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

    const { data, error } = await service.schema("app").rpc("submit_response", {
      p_attempt_id: attemptId,
      p_response_version_id: responseVersionId,
      p_actor_id: user.id,
      p_actor_role: profile.role,
      p_idempotency_key: idempotencyKey,
      p_request_hash: requestHash,
    });

    if (error) {
      const mapped = mapSubmitError(error.message);
      return respond(mapped.body, { status: mapped.status });
    }

    return respond(
      {
        status: "ok",
        function: "attempt-response",
        operation,
        result: data,
      },
      { status: 200 },
    );
  } catch (error) {
    console.error("attempt_response_failed", error);
    return respond(
      {
        status: "failed",
        function: "attempt-response",
        operation,
        error: "attempt_response_failed",
      },
      { status: 500 },
    );
  }
});
