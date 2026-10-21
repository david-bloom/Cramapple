import { trimmedNonEmptyString as asString, looseUuid as asUuid, coercedInteger as asInteger } from "../_shared/input.ts";
import { sha256Text as sha256Hex } from "../_shared/encoding.ts";
import { claimReplay, completeReplay, ReplayError } from "../_shared/operation-replay.ts";
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

const allowedPracticeFormats = new Set([
  "targeted_drill",
  "full_exam_frq",
  "mcq",
  "quantitative",
  "short_frq",
  "long_frq",
]);









function safeSessionShape(session: Record<string, unknown>) {
  return {
    id: session.id,
    user_id: session.user_id,
    exam_pack_version_id: session.exam_pack_version_id,
    entry_path: session.entry_path,
    session_mode: session.session_mode,
    available_minutes: session.available_minutes,
    practice_format: session.practice_format,
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

async function recordSessionEvent(
  service: ReturnType<typeof createServiceClient>,
  claimToken: string,
  requestId: string,
  requestHash: string,
  profileId: string,
  operation: SessionOperation,
  result: Record<string, unknown>,
  sessionId: string | null,
  detail: Record<string, unknown> = {},
) {
  await completeReplay(service, claimToken, {
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
    event_sha256: await sha256Hex(
      JSON.stringify({ operation, requestHash, result, detail }),
    ),
    created_at: new Date().toISOString(),
  });
}

export type SessionEventDeps = {
  requireProfile?: typeof requireProfile;
  service?: ReturnType<typeof createServiceClient>;
};

export async function handleSessionEvent(req: Request, deps: SessionEventDeps = {}): Promise<Response> {
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

  const operation = asString((body as Record<string, unknown>).operation) as
    | SessionOperation
    | null;
  if (!operation || !allowedOperations.has(operation)) {
    return respond({ error: "invalid_operation" }, { status: 400 });
  }

  const idempotencyKey = asString(
    (body as Record<string, unknown>).idempotency_key ??
      (body as Record<string, unknown>).idempotencyKey ??
      (body as Record<string, unknown>).request_id ??
      (body as Record<string, unknown>).requestId,
  );
  if (!idempotencyKey) {
    return respond({ error: "missing_idempotency_key" }, { status: 400 });
  }

  const profileResult = await (deps.requireProfile ?? loadProfile)(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }

  const service = deps.service ?? createServiceClient();
  const requestHash = await sha256Hex(JSON.stringify(body));
  const profileId = profileResult.user.id;

  let claimToken = "";
  const begin = async (): Promise<Response | null> => {
    const claim = await claimReplay(service, { actorId: profileId, requestId: idempotencyKey, requestHash, operation });
    if (claim.kind === "replay") return respond({ status: "ok", function: "session-event", operation, result: claim.result });
    claimToken = claim.claimToken;
    return null;
  };

  try {
    if (operation === "attach_anonymous_session") {
      return respond(
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
      const examPackVersionId = asUuid(
        (body as Record<string, unknown>).exam_pack_version_id,
      );
      const entryPath = asString((body as Record<string, unknown>).entry_path);
      const sessionMode = asString(
        (body as Record<string, unknown>).session_mode,
      );
      const availableMinutes = asInteger(
        (body as Record<string, unknown>).available_minutes,
      );
      const practiceFormat = asString(
        (body as Record<string, unknown>).practice_format,
      );

      if (
        !examPackVersionId || !entryPath || !sessionMode ||
        availableMinutes === null
      ) {
        return respond(
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
      if (practiceFormat && !allowedPracticeFormats.has(practiceFormat)) {
        return respond({ error: "invalid_practice_format" }, { status: 400 });
      }

      const cached = await begin();
      if (cached) return cached;

      // Broad Home starts are authoritative in Postgres: identity, active
      // subject, Home eligibility, duplicate prevention, and idempotency are
      // resolved inside one advisory-locked transaction.
      if (
        entryPath === "recommend" &&
        (!practiceFormat || practiceFormat === "mcq")
      ) {
        const { data: rows, error: startError } = await service.rpc(
          "start_home_learning_session_for_user",
          {
            _user_id: profileId,
            _minutes: availableMinutes,
            _idempotency_key: idempotencyKey,
          },
        );
        const row = Array.isArray(rows) ? rows[0] : rows;
        if (
          startError ||
          !row ||
          typeof row !== "object" ||
          typeof (row as Record<string, unknown>).learning_session_id !== "string"
        ) {
          throw new Error("session_start_failed");
        }

        const sessionId = (row as Record<string, unknown>)
          .learning_session_id as string;
        const { data: started, error: readError } = await service.schema("app")
          .from("learning_sessions")
          .select(
            "id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, practice_format, status, started_at, ended_at, created_at, updated_at",
          )
          .eq("id", sessionId)
          .maybeSingle();
        if (readError || !started) {
          throw new Error("session_start_failed");
        }

        const result = safeSessionShape(started as Record<string, unknown>);
        await recordSessionEvent(
          service,
          claimToken,
          idempotencyKey,
          requestHash,
          profileId,
          operation,
          result,
          sessionId,
          { authoritative_home_start: true },
        );
        return respond(
          {
            status: "ok",
            function: "session-event",
            operation,
            result,
          },
          { status: 200 },
        );
      }

      const { data: profile, error: profileError } = await service.schema("app")
        .from("profiles")
        .select("active_exam_pack_version_id")
        .eq("user_id", profileId)
        .maybeSingle();
      if (
        profileError ||
        !profile ||
        profile.active_exam_pack_version_id !== examPackVersionId
      ) {
        return respond({ error: "active_subject_mismatch" }, { status: 409 });
      }

      const { data: inserted, error } = await service.schema("app")
        .from("learning_sessions")
        .insert({
          user_id: profileId,
          exam_pack_version_id: examPackVersionId,
          entry_path: entryPath,
          session_mode: sessionMode,
          available_minutes: availableMinutes,
          practice_format: practiceFormat,
          status: "active",
        })
        .select(
          "id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, practice_format, status, started_at, ended_at, created_at, updated_at",
        )
        .maybeSingle();

      if (error || !inserted) {
        throw new Error("session_start_failed");
      }

      const result = safeSessionShape(inserted as Record<string, unknown>);
      await recordSessionEvent(
        service,
        claimToken,
        idempotencyKey,
        requestHash,
        profileId,
        operation,
        result,
        inserted.id as string,
        {
          entry_path: entryPath,
          session_mode: sessionMode,
          practice_format: practiceFormat,
        },
      );

      return respond(
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
      return respond({ error: "missing_session_id" }, { status: 400 });
    }

    const { data: session, error: sessionError } = await service.schema("app")
      .from("learning_sessions")
      .select(
        "id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, practice_format, status, started_at, ended_at, created_at, updated_at",
      )
      .eq("id", sessionId)
      .maybeSingle();

    if (sessionError || !session) {
      return respond({ error: "not_found" }, { status: 404 });
    }

    if (session.user_id !== profileId) {
      return respond({ error: "forbidden" }, { status: 403 });
    }

    const cached = await begin();
    if (cached) return cached;

    if (operation === "session_resume") {
      const result = safeSessionShape(session as Record<string, unknown>);
      await recordSessionEvent(
        service,
        claimToken,
        idempotencyKey,
        requestHash,
        profileId,
        operation,
        result,
        sessionId,
        {
          resumed: true,
        },
      );

      return respond(
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
        .select(
          "id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, practice_format, status, started_at, ended_at, created_at, updated_at",
        )
        .maybeSingle();

      if (saveError || !touched) {
        throw new Error("session_save_failed");
      }

      const result = safeSessionShape(touched as Record<string, unknown>);
      await recordSessionEvent(
        service,
        claimToken,
        idempotencyKey,
        requestHash,
        profileId,
        operation,
        result,
        sessionId,
        {
          saved: true,
        },
      );

      return respond(
        {
          status: "ok",
          function: "session-event",
          operation,
          result,
        },
        { status: 200 },
      );
    }

    const endStatus =
      asString((body as Record<string, unknown>).status) === "archived"
        ? "archived"
        : "completed";

    const { data: ended, error: endError } = await service.schema("app")
      .from("learning_sessions")
      .update({
        status: endStatus,
        ended_at: new Date().toISOString(),
      })
      .eq("id", sessionId)
      .select(
        "id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, practice_format, status, started_at, ended_at, created_at, updated_at",
      )
      .maybeSingle();

    if (endError || !ended) {
      throw new Error("session_end_failed");
    }

    const result = safeSessionShape(ended as Record<string, unknown>);
    await recordSessionEvent(
      service,
      claimToken,
      idempotencyKey,
      requestHash,
      profileId,
      operation,
      result,
      sessionId,
      {
        final_status: endStatus,
      },
    );

    return respond(
      {
        status: "ok",
        function: "session-event",
        operation,
        result,
      },
      { status: 200 },
    );
  } catch (error) {
    if (error instanceof ReplayError) return respond({ error: error.code }, { status: error.status });
    const message = error instanceof Error
      ? error.message
      : "session_event_failed";
    const clientErrors = new Set([
      "invalid_json",
      "invalid_operation",
      "invalid_practice_format",
      "missing_idempotency_key",
      "missing_required_fields",
      "missing_session_id",
      "session_start_failed",
      "session_save_failed",
      "session_end_failed",
      "unsupported_operation",
    ]);

    return respond(
      {
        status: "failed",
        function: "session-event",
        operation,
        error: clientErrors.has(message) ? message : "session_event_failed",
      },
      { status: clientErrors.has(message) ? 400 : 500 },
    );
  }
}

if (import.meta.main) Deno.serve((req) => handleSessionEvent(req));
