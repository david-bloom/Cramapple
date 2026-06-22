import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

type SessionOperation =
  | "session_start"
  | "session_save"
  | "session_end"
  | "session_resume"
  | "attach_anonymous_session";

const allowedOperations = new Set<SessionOperation>([
  "session_start",
  "session_save",
  "session_end",
  "session_resume",
  "attach_anonymous_session",
]);

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asUuid(value: unknown) {
  return typeof value === "string" && /^[0-9a-fA-F-]{36}$/.test(value)
    ? value
    : null;
}

function asInteger(value: unknown) {
  const parsed = Number(value);
  return Number.isInteger(parsed) ? parsed : null;
}

async function sha256Hex(value: string) {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(value));
  return Array.from(new Uint8Array(digest)).map((byte) => byte.toString(16).padStart(2, "0")).join("");
}

function safeSessionShape(session: Record<string, unknown>) {
  return {
    id: session.id,
    user_id: session.user_id,
    exam_pack_version_id: session.exam_pack_version_id,
    entry_path: session.entry_path,
    session_mode: session.session_mode,
    available_minutes: session.available_minutes,
    status: session.status,
    started_at: session.started_at,
    ended_at: session.ended_at,
    created_at: session.created_at,
    updated_at: session.updated_at,
  };
}

async function loadProfile(req: Request) {
  return await requireProfile(req);
}

async function loadIdempotentResult(
  service: ReturnType<typeof createServiceClient>,
  requestId: string,
  requestHash: string,
  operation: SessionOperation,
) {
  const { data, error } = await service.schema("app")
    .from("audit_events")
    .select("request_id, reason_code, metadata")
    .eq("request_id", requestId)
    .maybeSingle();

  if (error) {
    throw error;
  }

  if (!data || data.reason_code !== operation) {
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

async function recordSessionEvent(
  service: ReturnType<typeof createServiceClient>,
  requestId: string,
  requestHash: string,
  profileId: string,
  operation: SessionOperation,
  result: Record<string, unknown>,
  sessionId: string | null,
  detail: Record<string, unknown> = {},
) {
  await service.schema("app").from("audit_events").insert({
    audit_event_id: crypto.randomUUID(),
    occurred_at: new Date().toISOString(),
    actor_type: "human",
    actor_id: profileId,
    action: `session_event.${operation}`,
    object_type: "learning_session",
    object_id: sessionId ?? crypto.randomUUID(),
    request_id: requestId,
    reason_code: operation,
    metadata: {
      request_hash: requestHash,
      result,
      ...detail,
    },
    event_sha256: await sha256Hex(JSON.stringify({ operation, requestHash, result, detail })),
    created_at: new Date().toISOString(),
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return jsonResponse({ ok: true }, { status: 200 });
  }

  if (req.method !== "POST") {
    return jsonResponse({ error: "method_not_allowed" }, { status: 405 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return jsonResponse({ error: "invalid_json" }, { status: 400 });
  }

  const operation = asString((body as Record<string, unknown>).operation) as SessionOperation | null;
  if (!operation || !allowedOperations.has(operation)) {
    return jsonResponse({ error: "invalid_operation" }, { status: 400 });
  }

  const idempotencyKey = asString(
    (body as Record<string, unknown>).idempotency_key ??
      (body as Record<string, unknown>).idempotencyKey ??
      (body as Record<string, unknown>).request_id ??
      (body as Record<string, unknown>).requestId,
  );
  if (!idempotencyKey) {
    return jsonResponse({ error: "missing_idempotency_key" }, { status: 400 });
  }

  const profileResult = await loadProfile(req);
  if (!profileResult) {
    return jsonResponse({ error: "unauthorized" }, { status: 401 });
  }

  const service = createServiceClient();
  const requestHash = await sha256Hex(JSON.stringify(body));
  const profileId = profileResult.user.id;

  const deduped = await loadIdempotentResult(service, idempotencyKey, requestHash, operation);
  if (deduped) {
    if ("conflict" in deduped) {
      return jsonResponse({ error: "idempotency_conflict" }, { status: 409 });
    }

    return jsonResponse(
      {
        status: "ok",
        function: "session-event",
        operation,
        result: deduped.result,
      },
      { status: 200 },
    );
  }

  try {
    if (operation === "attach_anonymous_session") {
      return jsonResponse(
        {
          status: "unsupported",
          function: "session-event",
          operation,
          message:
            "Anonymous-session attachment is not available in the current production schema. Use authenticated session start/resume instead.",
        },
        { status: 501 },
      );
    }

    if (operation === "session_start") {
      const examPackVersionId = asUuid((body as Record<string, unknown>).exam_pack_version_id);
      const entryPath = asString((body as Record<string, unknown>).entry_path);
      const sessionMode = asString((body as Record<string, unknown>).session_mode);
      const availableMinutes = asInteger((body as Record<string, unknown>).available_minutes);

      if (!examPackVersionId || !entryPath || !sessionMode || availableMinutes === null) {
        return jsonResponse(
          {
            error: "missing_required_fields",
            required: [
              "exam_pack_version_id",
              "entry_path",
              "session_mode",
              "available_minutes",
            ],
          },
          { status: 400 },
        );
      }

      const { data: inserted, error } = await service.schema("app")
        .from("learning_sessions")
        .insert({
          user_id: profileId,
          exam_pack_version_id: examPackVersionId,
          entry_path: entryPath,
          session_mode: sessionMode,
          available_minutes: availableMinutes,
          status: "active",
        })
        .select("id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, status, started_at, ended_at, created_at, updated_at")
        .maybeSingle();

      if (error || !inserted) {
        throw new Error("session_start_failed");
      }

      const result = safeSessionShape(inserted as Record<string, unknown>);
      await recordSessionEvent(service, idempotencyKey, requestHash, profileId, operation, result, inserted.id as string, {
        entry_path: entryPath,
        session_mode: sessionMode,
      });

      return jsonResponse(
        {
          status: "ok",
          function: "session-event",
          operation,
          result,
        },
        { status: 200 },
      );
    }

    const sessionId = asUuid(
      (body as Record<string, unknown>).session_id ??
        (body as Record<string, unknown>).sessionId ??
        (body as Record<string, unknown>).study_session_id ??
        (body as Record<string, unknown>).studySessionId,
    );
    if (!sessionId) {
      return jsonResponse({ error: "missing_session_id" }, { status: 400 });
    }

    const { data: session, error: sessionError } = await service.schema("app")
      .from("learning_sessions")
      .select("id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, status, started_at, ended_at, created_at, updated_at")
      .eq("id", sessionId)
      .maybeSingle();

    if (sessionError || !session) {
      return jsonResponse({ error: "not_found" }, { status: 404 });
    }

    if (session.user_id !== profileId) {
      return jsonResponse({ error: "forbidden" }, { status: 403 });
    }

    if (operation === "session_resume") {
      const result = safeSessionShape(session as Record<string, unknown>);
      await recordSessionEvent(service, idempotencyKey, requestHash, profileId, operation, result, sessionId, {
        resumed: true,
      });

      return jsonResponse(
        {
          status: "ok",
          function: "session-event",
          operation,
          result,
        },
        { status: 200 },
      );
    }

    if (operation === "session_save") {
      const { data: touched, error: saveError } = await service.schema("app")
        .from("learning_sessions")
        .update({ status: session.status })
        .eq("id", sessionId)
        .select("id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, status, started_at, ended_at, created_at, updated_at")
        .maybeSingle();

      if (saveError || !touched) {
        throw new Error("session_save_failed");
      }

      const result = safeSessionShape(touched as Record<string, unknown>);
      await recordSessionEvent(service, idempotencyKey, requestHash, profileId, operation, result, sessionId, {
        saved: true,
      });

      return jsonResponse(
        {
          status: "ok",
          function: "session-event",
          operation,
          result,
        },
        { status: 200 },
      );
    }

    const endStatus = asString((body as Record<string, unknown>).status) === "archived"
      ? "archived"
      : "completed";

    const { data: ended, error: endError } = await service.schema("app")
      .from("learning_sessions")
      .update({
        status: endStatus,
        ended_at: new Date().toISOString(),
      })
      .eq("id", sessionId)
      .select("id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, status, started_at, ended_at, created_at, updated_at")
      .maybeSingle();

    if (endError || !ended) {
      throw new Error("session_end_failed");
    }

    const result = safeSessionShape(ended as Record<string, unknown>);
    await recordSessionEvent(service, idempotencyKey, requestHash, profileId, operation, result, sessionId, {
      final_status: endStatus,
    });

    return jsonResponse(
      {
        status: "ok",
        function: "session-event",
        operation,
        result,
      },
      { status: 200 },
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : "session_event_failed";
    const clientErrors = new Set([
      "invalid_json",
      "invalid_operation",
      "missing_idempotency_key",
      "missing_required_fields",
      "missing_session_id",
      "session_start_failed",
      "session_save_failed",
      "session_end_failed",
      "unsupported_operation",
    ]);

    return jsonResponse(
      {
        status: "failed",
        function: "session-event",
        operation,
        error: clientErrors.has(message) ? message : "session_event_failed",
      },
      { status: clientErrors.has(message) ? 400 : 500 },
    );
  }
});
