import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";
import {
  isSafeStoragePath,
  ownsLearnerPath,
} from "../_shared/storage-paths.ts";
import {
  type AttachmentKind,
  planAttachmentInsert,
  validateCaptureObject,
} from "../_shared/capture-attachment.ts";
import { runCaptureQualityCheck } from "../_shared/capture-quality-check.ts";
import {
  type CriterionStatus,
  scoreManualGrade,
  type SubmittedCriterion,
} from "../_shared/manual-grading.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { persistGradingMemory } from "../_shared/grading-memory.ts";

type Operation =
  | "create_attempt"
  | "save_response"
  | "submit_response"
  | "attach_capture"
  | "record_manual_grade";

const ALLOWED_OPERATIONS = new Set<Operation>([
  "create_attempt",
  "save_response",
  "submit_response",
  "attach_capture",
  "record_manual_grade",
]);
const ATTACHMENT_KINDS = new Set<AttachmentKind>(["original", "derived"]);

// Capture-quality checking (Layer A of "explain why ungradable", see
// docs/research/DRAWN_RESPONSE_ANNOTATION_HANDBOOK.md section 3) is best-
// effort, not a hard dependency of attach_capture: if the key isn't
// configured, the attachment still binds with the default 'pending' state,
// exactly as it does today. This must never be the reason an upload fails.
const CAPTURE_QUALITY_API_KEY = Deno.env.get("OPENAI_API_KEY") ?? null;
const CAPTURE_QUALITY_MODEL = Deno.env.get("CAPTURE_QUALITY_MODEL") ??
  "gpt-4o-mini";
const CAPTURE_QUALITY_TIMEOUT_MS =
  Number(Deno.env.get("CAPTURE_QUALITY_TIMEOUT_MS")) || 15_000;

// Row shapes returned by the RPCs in 20260818011720_response_attachments_fixes.sql
// (`.rpc()` isn't typed against a generated Database schema here, so these
// annotate what the SQL functions actually return).
type ResponseAttachmentRow = {
  id: string;
  response_version_id: string;
  attempt_id: string;
  content_item_version_id: string;
  kind: AttachmentKind;
  replaces_attachment_id: string | null;
  is_current: boolean;
  storage_bucket: string;
  storage_path: string;
  media_type: string;
  byte_size: number;
  pixel_width: number | null;
  pixel_height: number | null;
  capture_quality_state: string;
  created_at: string;
};

type GradingResultRow = {
  id: string;
  attempt_id: string;
  response_version_id: string;
  points_earned: number;
  points_available: number;
  criterion_results: unknown;
  created_at: string;
};
const ATTEMPT_MODES = new Set(["mcq", "frq", "quantitative"]);
const ASSISTANCE_STATES = new Set([
  "independent",
  "coached",
  "exam_practice",
]);

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

// Shapes an untrusted body array into SubmittedCriterion[] without crashing
// on missing/wrong-typed fields; scoreManualGrade does the real validation
// (unknown/duplicate/missing keys, status/points consistency). Returns null
// if the input isn't even a well-formed array of criterion-shaped objects.
function asSubmittedCriteria(value: unknown): SubmittedCriterion[] | null {
  if (!Array.isArray(value)) return null;
  const parsed: SubmittedCriterion[] = [];
  for (const entry of value) {
    const record = asRecord(entry);
    const criterionKey = asString(record.criterion_key);
    const status = asString(record.status);
    const pointsAwarded = record.points_awarded;
    if (
      !criterionKey || !status || typeof pointsAwarded !== "number"
    ) {
      return null;
    }
    parsed.push({
      criterion_key: criterionKey,
      status: status as CriterionStatus,
      points_awarded: pointsAwarded,
      evidence_quote: asString(record.evidence_quote),
      decision_explanation: asString(record.decision_explanation),
      minimum_fix: asString(record.minimum_fix),
    });
  }
  return parsed;
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
    metadata: { request_hash: requestHash, result },
    event_sha256: await sha256Hex(
      JSON.stringify({ operation, requestHash, result }),
    ),
    created_at: new Date().toISOString(),
  });
  if (error) throw error;
}

// A lightweight, best-effort fingerprint of a storage.objects row's current
// version (updated_at + eTag/size), used only to detect whether the object
// at storagePath changed between two points in time -- not a general
// storage read. Returns null if the object can't be found/listed, which the
// caller treats as "changed" (fail closed).
async function storageObjectFingerprint(
  service: ReturnType<typeof createServiceClient>,
  storagePath: string,
): Promise<string | null> {
  const slashIndex = storagePath.lastIndexOf("/");
  const folder = slashIndex >= 0 ? storagePath.slice(0, slashIndex) : "";
  const fileName = slashIndex >= 0
    ? storagePath.slice(slashIndex + 1)
    : storagePath;
  const { data, error } = await service.storage
    .from("learner-uploads")
    .list(folder, { search: fileName, limit: 100 });
  if (error || !data) return null;
  const entry = data.find((item) => item.name === fileName);
  if (!entry) return null;
  return `${entry.updated_at ?? ""}:${
    entry.metadata?.eTag ?? entry.metadata?.size ?? ""
  }`;
}

function mapAttachCaptureError(message: string | undefined) {
  const match = typeof message === "string"
    ? message.match(/attach_capture:([a-z_]+)/)
    : null;
  if (!match) {
    return { status: 500, body: { error: "attach_capture_failed" } };
  }
  const [, code] = match;
  switch (code) {
    case "no_current_original_to_replace":
    case "stale_retake_target":
    case "original_already_current":
    case "derived_cannot_replace":
      return { status: 409, body: { error: `attach_capture_${code}` } };
    default:
      return { status: 500, body: { error: "attach_capture_failed" } };
  }
}

function mapRecordManualGradeError(message: string | undefined) {
  const match = typeof message === "string"
    ? message.match(/record_manual_grade:([a-z_]+)/)
    : null;
  if (match && match[1] === "attempt_not_gradable") {
    return { status: 409, body: { error: "attempt_not_gradable" } };
  }
  return { status: 500, body: { error: "manual_grade_failed" } };
}

function mapSubmitError(message: string | undefined) {
  const match = typeof message === "string"
    ? message.match(/submit_response:([a-z_]+)(?::(.+))?/)
    : null;
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
    case "response_already_submitted":
      return { status: 409, body: { error: code } };
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
          return respond(
            { error: "idempotency_conflict" },
            { status: 409 },
          );
        }
        return respond({
          status: "ok",
          function: "attempt-response",
          operation,
          result: existing.result,
        });
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
        return respond(
          { error: "invalid_assistance_state" },
          { status: 400 },
        );
      }

      const [
        { data: session, error: sessionError },
        { data: contentVersion, error: contentVersionError },
      ] = await Promise.all([
        service.schema("app")
          .from("learning_sessions")
          .select(
            "id, user_id, exam_pack_version_id, practice_format, status",
          )
          .eq("id", learningSessionId)
          .maybeSingle(),
        service.schema("app")
          .from("content_item_versions")
          .select(
            "id, content_item_id, status, content_items!inner(exam_pack_version_id, item_type, practice_format, status)",
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
        return respond(
          { error: "content_not_available" },
          { status: 409 },
        );
      }
      if (contentItem.item_type !== attemptMode) {
        return respond(
          { error: "attempt_mode_mismatch" },
          { status: 409 },
        );
      }
      if (session.exam_pack_version_id !== contentItem.exam_pack_version_id) {
        return respond(
          { error: "session_content_mismatch" },
          { status: 409 },
        );
      }

      // Serving correctness is enforced again at attempt creation. A client
      // cannot fetch a targeted drill and submit it in a full-exam session,
      // or vice versa. Unclassified non-FRQ content remains compatible.
      if (
        contentItem.practice_format &&
        (
          !session.practice_format ||
          session.practice_format !== contentItem.practice_format
        )
      ) {
        return respond(
          {
            error: "practice_format_mismatch",
            session_practice_format: session.practice_format ?? null,
            content_practice_format: contentItem.practice_format,
          },
          { status: 409 },
        );
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
        return respond(
          { error: "attempt_create_failed" },
          { status: 500 },
        );
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
      return respond({
        status: "ok",
        function: "attempt-response",
        operation,
        result,
      });
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
      return respond({
        status: "ok",
        function: "attempt-response",
        operation,
        result,
      });
    }

    if (operation === "attach_capture") {
      const captureAttemptId = asUuid(b.attempt_id ?? b.attemptId);
      const captureResponseVersionId = asUuid(
        b.response_version_id ?? b.responseVersionId,
      );
      const storagePath = asString(b.storage_path ?? b.storagePath);
      const kind = (asString(b.kind) as AttachmentKind | null) ?? "original";
      const replacesAttachmentId = asUuid(
        b.replaces_attachment_id ?? b.replacesAttachmentId,
      );
      const declaredMediaType = asString(
        b.media_type ?? b.mediaType,
      );
      const declaredSha256 = asString(b.sha256_digest ?? b.sha256Digest);

      if (!captureAttemptId || !captureResponseVersionId || !storagePath) {
        return respond(
          {
            error: "missing_required_fields",
            required: [
              "attempt_id",
              "response_version_id",
              "storage_path",
            ],
          },
          { status: 400 },
        );
      }
      if (!ATTACHMENT_KINDS.has(kind)) {
        return respond({ error: "invalid_kind" }, { status: 400 });
      }
      if (
        !isSafeStoragePath(storagePath) ||
        !ownsLearnerPath(user.id, storagePath)
      ) {
        return respond({ error: "invalid_storage_path" }, { status: 400 });
      }

      const { data: attempt, error: attemptError } = await service
        .schema("app")
        .from("attempts")
        .select("id, user_id, status, content_item_version_id")
        .eq("id", captureAttemptId)
        .maybeSingle();
      if (attemptError || !attempt) {
        return respond({ error: "attempt_not_found" }, { status: 404 });
      }
      // No admin-on-behalf-of-student bypass here: the storage-path
      // ownership check above already requires storagePath to be prefixed
      // with the CALLING user's id (matching storage-sign-url's
      // sign_upload, which has no admin exception either), so an admin
      // could never legitimately reach this point with a student's real
      // path anyway. A bypass here without one there would be dead,
      // misleading code -- see TASK-0025 QA review 2026-08-17.
      if (attempt.user_id !== user.id) {
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

      const { data: responseVersion, error: responseVersionError } =
        await service
          .schema("app")
          .from("response_versions")
          .select("id, attempt_id, is_submitted")
          .eq("id", captureResponseVersionId)
          .maybeSingle();
      if (responseVersionError || !responseVersion) {
        return respond({ error: "response_not_found" }, { status: 404 });
      }
      if (responseVersion.attempt_id !== captureAttemptId) {
        return respond(
          { error: "response_attempt_mismatch" },
          { status: 409 },
        );
      }
      if (responseVersion.is_submitted) {
        return respond(
          { error: "response_already_submitted" },
          { status: 409 },
        );
      }

      const { data: downloaded, error: downloadError } = await service
        .storage
        .from("learner-uploads")
        .download(storagePath);
      if (downloadError || !downloaded) {
        return respond({ error: "capture_object_not_found" }, {
          status: 404,
        });
      }

      const bytes = new Uint8Array(await downloaded.arrayBuffer());
      const validation = await validateCaptureObject({
        bytes,
        declaredMediaType,
        declaredSha256,
      });
      if (!validation.ok) {
        return respond({ error: validation.reason }, { status: 422 });
      }

      // Run before the DB write below (not after) so a slow/failed vision
      // call never risks leaving a bound attachment half-updated -- the
      // result is folded into the same insert-adjacent flow, and on any
      // failure runCaptureQualityCheck itself resolves to a safe
      // HUMAN_REVIEW/indeterminate result rather than throwing.
      const captureQuality = CAPTURE_QUALITY_API_KEY && kind === "original"
        ? await runCaptureQualityCheck({
          bytes,
          mediaType: validation.mediaType,
          apiKey: CAPTURE_QUALITY_API_KEY,
          modelId: CAPTURE_QUALITY_MODEL,
          timeoutMs: CAPTURE_QUALITY_TIMEOUT_MS,
        })
        : null;

      // Snapshot the object's storage-side identity right after we finished
      // reading it, so we can detect (immediately before binding) whether
      // the owner swapped or deleted the object out from under the bytes we
      // just validated. TASK-0025 QA review 2026-08-17: the object isn't
      // RLS-protected from owner mutation until the response_attachments
      // row referencing it exists, so without this check a retake/overwrite
      // landing in this window would silently bind a digest/media-type that
      // no longer matches what's actually in storage -- and the immutable
      // row created below can never be corrected afterward.
      const objectFingerprintAtRead = await storageObjectFingerprint(
        service,
        storagePath,
      );

      // Fast, cheap early rejection for an obviously-invalid retake request
      // (matches planAttachmentInsert's unit-tested rules) before touching
      // the database for the real write. Not relied on for correctness --
      // bind_response_attachment (called below) re-derives and enforces the
      // same rules atomically, under a row lock, so this can race safely.
      const { data: priorCurrent, error: priorCurrentError } = await service
        .schema("app")
        .from("response_attachments")
        .select("id")
        .eq("response_version_id", captureResponseVersionId)
        .eq("kind", "original")
        .eq("is_current", true)
        .maybeSingle();
      if (priorCurrentError) {
        return respond({ error: "attach_capture_failed" }, { status: 500 });
      }
      try {
        planAttachmentInsert({
          kind,
          priorCurrentOriginalId: priorCurrent?.id ?? null,
          replacesAttachmentId,
        });
      } catch (planError) {
        const message = planError instanceof Error
          ? planError.message
          : "attach_capture:invalid_retake";
        const reason = message.split(":").pop() ?? "invalid_retake";
        return respond({ error: `attach_capture_${reason}` }, {
          status: 409,
        });
      }

      const objectFingerprintBeforeBind = await storageObjectFingerprint(
        service,
        storagePath,
      );
      if (
        objectFingerprintAtRead === null ||
        objectFingerprintBeforeBind !== objectFingerprintAtRead
      ) {
        return respond({ error: "capture_object_changed" }, { status: 409 });
      }

      // Atomic: supersedes the prior current original (if any) and inserts
      // the new row in one transaction under a row lock, closing both the
      // insert-before-supersede ordering bug and the concurrent-retake race
      // that separate insert/update calls had. See
      // 20260818011720_response_attachments_fixes.sql.
      const { data: boundAttachment, error: bindError } = await service
        .schema("app")
        .rpc("bind_response_attachment", {
          p_response_version_id: captureResponseVersionId,
          p_attempt_id: captureAttemptId,
          p_content_item_version_id: attempt.content_item_version_id,
          p_kind: kind,
          p_replaces_attachment_id: replacesAttachmentId,
          p_storage_path: storagePath,
          p_media_type: validation.mediaType,
          p_byte_size: validation.byteSize,
          p_pixel_width: validation.width,
          p_pixel_height: validation.height,
          p_sha256_digest: validation.sha256,
          p_captured_by: user.id,
        })
        .single<ResponseAttachmentRow>();
      if (bindError || !boundAttachment) {
        const mapped = mapAttachCaptureError(bindError?.message);
        return respond(mapped.body, { status: mapped.status });
      }

      // capture_quality_state defaults to 'pending' at insert (bind_response_
      // attachment takes no such param) and is one of the three columns the
      // immutability trigger allows to change afterward -- this is a normal
      // in-place update, not a rewrite of an immutable row.
      let resolvedCaptureQualityState = boundAttachment.capture_quality_state;
      if (captureQuality) {
        const { error: qualityUpdateError } = await service
          .schema("app")
          .from("response_attachments")
          .update({ capture_quality_state: captureQuality.captureQualityState })
          .eq("id", boundAttachment.id);
        if (!qualityUpdateError) {
          resolvedCaptureQualityState = captureQuality.captureQualityState;
        }
      }

      const attachment = {
        id: boundAttachment.id,
        response_version_id: boundAttachment.response_version_id,
        attempt_id: boundAttachment.attempt_id,
        content_item_version_id: boundAttachment.content_item_version_id,
        kind: boundAttachment.kind,
        replaces_attachment_id: boundAttachment.replaces_attachment_id,
        is_current: boundAttachment.is_current,
        storage_bucket: boundAttachment.storage_bucket,
        storage_path: boundAttachment.storage_path,
        media_type: boundAttachment.media_type,
        byte_size: boundAttachment.byte_size,
        pixel_width: boundAttachment.pixel_width,
        pixel_height: boundAttachment.pixel_height,
        capture_quality_state: resolvedCaptureQualityState,
        created_at: boundAttachment.created_at,
        // Present only when a RETAKE was detected -- never populated for
        // ACCEPT/HUMAN_REVIEW, and never describes the drawn content, only
        // the photo itself.
        capture_retake_reason: captureQuality?.retakeMessage ?? null,
      };

      const result = { response_attachment: attachment };
      await recordIdempotentResult(
        service,
        idempotencyKey,
        requestHash,
        operation,
        user.id,
        "response_attachment",
        attachment.id as string,
        result,
      );
      return respond({
        status: "ok",
        function: "attempt-response",
        operation,
        result,
      });
    }

    if (operation === "record_manual_grade") {
      // TASK-0020 Program C: no automated method is qualified to grade a
      // hand-drawn image. This operation lets an admin record a real human
      // grade in the same row shape evaluate-attempt would have written, so
      // student-facing reads (public.grading_results) keep working
      // unmodified. It is not a reviewer queue -- see
      // docs/tasks/TASK-0025-HAND-DRAWN-CAPTURE-ATTACHMENT-SCHEMA.md.
      if (profile.role !== "admin") {
        return respond({ error: "forbidden" }, { status: 403 });
      }

      const gradeAttemptId = asUuid(b.attempt_id ?? b.attemptId);
      const gradeResponseVersionId = asUuid(
        b.response_version_id ?? b.responseVersionId,
      );
      const submittedCriteria = asSubmittedCriteria(b.criteria);

      if (!gradeAttemptId || !gradeResponseVersionId || !submittedCriteria) {
        return respond(
          {
            error: "missing_required_fields",
            required: ["attempt_id", "response_version_id", "criteria"],
          },
          { status: 400 },
        );
      }

      const { data: attempt, error: attemptError } = await service
        .schema("app")
        .from("attempts")
        .select(
          "id, user_id, status, content_item_version_id, learning_session_id, exam_pack_version_id, attempt_mode, assistance_state",
        )
        .eq("id", gradeAttemptId)
        .maybeSingle();
      if (attemptError || !attempt) {
        return respond({ error: "attempt_not_found" }, { status: 404 });
      }
      if (attempt.status !== "submitted") {
        return respond(
          { error: "attempt_not_gradable", attempt_status: attempt.status },
          { status: 409 },
        );
      }

      const { data: responseVersion, error: responseVersionError } =
        await service
          .schema("app")
          .from("response_versions")
          .select("id, attempt_id, is_submitted")
          .eq("id", gradeResponseVersionId)
          .maybeSingle();
      if (responseVersionError || !responseVersion) {
        return respond({ error: "response_not_found" }, { status: 404 });
      }
      if (responseVersion.attempt_id !== gradeAttemptId) {
        return respond(
          { error: "response_attempt_mismatch" },
          { status: 409 },
        );
      }
      if (!responseVersion.is_submitted) {
        return respond(
          { error: "response_not_submitted" },
          { status: 409 },
        );
      }

      const { data: catalogRows, error: catalogError } = await service
        .schema("app")
        .from("frq_criteria")
        .select("criterion_key, points_possible")
        .eq("content_item_version_id", attempt.content_item_version_id);
      if (catalogError) {
        return respond({ error: "manual_grade_failed" }, { status: 500 });
      }

      const scored = scoreManualGrade(submittedCriteria, catalogRows ?? []);
      if (!scored.ok) {
        return respond({ error: scored.reason }, { status: 422 });
      }

      const feedbackPreview =
        `Graded by human review: ${scored.points_earned}/${scored.points_available} points.`;

      // Computed BEFORE the write below, mirroring evaluate-attempt's own
      // ordering ("fired before this update commits, so the 'prior graded
      // results' count below can't see this request's own row") -- this
      // grade doesn't exist yet at this point, so it can't see its own row.
      // Attributed to the STUDENT who owns the attempt (attempt.user_id),
      // not the admin caller, since this operation is always
      // admin-initiated by design.
      const { data: priorGradedAttempts } = await service.schema("app")
        .from("attempts")
        .select("id")
        .eq("user_id", attempt.user_id);
      const priorGradedAttemptIds = (priorGradedAttempts ?? []).map((row) =>
        row.id
      );
      let isFirstGradedResponse = true;
      if (priorGradedAttemptIds.length > 0) {
        const { count } = await service.schema("app")
          .from("grading_results")
          .select("id", { count: "exact", head: true })
          .in("attempt_id", priorGradedAttemptIds)
          .in("status", ["graded", "uncertain"]);
        isFirstGradedResponse = (count ?? 0) === 0;
      }

      // Atomic: claims the attempt (status: submitted -> graded, conditioned
      // on it still being 'submitted') and inserts the grading_results row
      // in one transaction, so this can't race evaluate-attempt (the
      // automated grading path) for the same attempt -- see
      // 20260818011720_response_attachments_fixes.sql.
      const { data: gradingResult, error: gradeError } = await service
        .schema("app")
        .rpc("record_manual_grade", {
          p_attempt_id: gradeAttemptId,
          p_response_version_id: gradeResponseVersionId,
          p_request_id: idempotencyKey,
          p_request_hash: requestHash,
          p_criterion_results: scored.criteria,
          p_points_earned: scored.points_earned,
          p_points_available: scored.points_available,
          p_feedback_preview: feedbackPreview,
        })
        .single<GradingResultRow>();
      if (gradeError || !gradingResult) {
        const mapped = mapRecordManualGradeError(gradeError?.message);
        return respond(mapped.body, { status: mapped.status });
      }

      // Mirror evaluate-attempt's post-grade side effects (growth event +
      // mastery/memory-state update) so an attempt graded through this
      // human-review pilot isn't silently invisible to analytics and item
      // delivery the way it was before this fix -- TASK-0025 QA review
      // 2026-08-17.
      if (isFirstGradedResponse) {
        await recordGrowthEvent(service, {
          eventName: "first_response_graded",
          userId: attempt.user_id as string,
          source: "web",
          dedupeKey: `first_response_graded:${attempt.user_id}`,
        });
      }

      await persistGradingMemory({
        service,
        sessionId: attempt.learning_session_id as string | null,
        attemptId: gradeAttemptId,
        attemptMode: attempt.attempt_mode as string,
        assistanceState: attempt.assistance_state as string,
        finalStatus: "graded",
        pointsEarned: scored.points_earned,
        pointsAvailable: scored.points_available,
        confidence: "high",
        highestValueGap: null,
        criteria: scored.criteria.map((c) => ({
          criterion_key: c.criterion_key,
          status: c.status,
          points_awarded: c.points_awarded,
        })),
        summary: feedbackPreview,
        examPackVersionId: attempt.exam_pack_version_id as string,
        feedbackPreview,
      });

      const result = { grading_result: gradingResult };
      await recordIdempotentResult(
        service,
        idempotencyKey,
        requestHash,
        operation,
        user.id,
        "grading_result",
        gradingResult.id as string,
        result,
      );
      return respond({
        status: "ok",
        function: "attempt-response",
        operation,
        result,
      });
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

    const { data, error } = await service.schema("app").rpc(
      "submit_response",
      {
        p_attempt_id: attemptId,
        p_response_version_id: responseVersionId,
        p_actor_id: user.id,
        p_actor_role: profile.role,
        p_idempotency_key: idempotencyKey,
        p_request_hash: requestHash,
      },
    );
    if (error) {
      const mapped = mapSubmitError(error.message);
      return respond(mapped.body, { status: mapped.status });
    }
    return respond({
      status: "ok",
      function: "attempt-response",
      operation,
      result: data,
    });
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
