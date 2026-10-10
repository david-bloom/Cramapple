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
import {
  type CriterionStatus,
  scoreManualGrade,
  type SubmittedCriterion,
} from "../_shared/manual-grading.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { persistGradingMemory } from "../_shared/grading-memory.ts";
import {
  buildTranscriptRecord,
  runDrawnResponseTranscript,
  transcriptKey,
  type TranscriptMediaType,
} from "../_shared/drawn-response-extraction.ts";
import {
  CONFIRMATION_KEYS,
  confirmationIsStale,
  deriveItemParts,
  inferStudentAdded,
  readResponseParts,
  readTranscriptRecord,
  transcriptView,
  validateConfirmedParts,
} from "../_shared/response-transcript.ts";
import { redactLineage, type RedactionRow } from "../_shared/attachment-redaction.ts";
import { photoEnabledFor } from "../_shared/frq-photo-rollout.ts";

type Operation =
  | "create_attempt"
  | "save_response"
  | "submit_response"
  | "attach_capture"
  | "record_manual_grade"
  | "list_manual_grading_queue"
  | "get_manual_grading_context"
  // Hand-drawn responses on every FRQ (2026-10-09, DECISION-0110/0111).
  | "propose_transcript"
  | "confirm_transcript"
  | "redact_attachment";

const ALLOWED_OPERATIONS = new Set<Operation>([
  "create_attempt",
  "save_response",
  "submit_response",
  "attach_capture",
  "record_manual_grade",
  "list_manual_grading_queue",
  "get_manual_grading_context",
  "propose_transcript",
  "confirm_transcript",
  "redact_attachment",
]);
const ATTACHMENT_KINDS = new Set<AttachmentKind>(["original", "derived"]);

// Hand-drawn responses on every FRQ (docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md).
// Off by default: the transcript ops refuse and the submit gate below is
// inert, so a deploy with the flag unset changes nothing for students.
const FRQ_PHOTO_RESPONSES_ENABLED =
  (Deno.env.get("FRQ_PHOTO_RESPONSES_ENABLED") ?? "false").toLowerCase() === "true";
const FRQ_TRANSCRIPT_API_KEY = Deno.env.get("OPENAI_API_KEY") ?? null;
const FRQ_TRANSCRIPT_MODEL = Deno.env.get("FRQ_TRANSCRIPT_MODEL") ??
  Deno.env.get("OPENAI_MODEL") ?? "gpt-4.1-mini";
const FRQ_TRANSCRIPT_TIMEOUT_MS = Number(Deno.env.get("FRQ_TRANSCRIPT_TIMEOUT_MS")) || 45_000;
// One fixed reservation per model call through the shared ledger; the
// shared daily cap is REQUIRED (fail closed), same as BYOQ extraction.
const FRQ_TRANSCRIPT_RESERVED_COST_USD = Number(Deno.env.get("FRQ_TRANSCRIPT_RESERVED_COST_USD")) || 0.03;
const FRQ_TRANSCRIPT_SHARED_CAP_USD = Number(Deno.env.get("OPENAI_DAILY_CAP_USD")) || 0;
// Plan D5 defaults (proposed, not yet decided): per-student daily reads and a
// feature-level USD breaker, both failing closed to "type your answer".
const FRQ_TRANSCRIPT_DAILY_RUNS = Number(Deno.env.get("FRQ_TRANSCRIPT_DAILY_RUNS")) || 30;
const FRQ_PHOTO_DAILY_CAP_USD = Number(Deno.env.get("FRQ_PHOTO_DAILY_CAP_USD")) || 50;
const LEARNER_UPLOADS_BUCKET = "learner-uploads";
// Server-side rollout (QA P2-a): "none" (default, admins only), "all", or a
// subject list. Same knob student-session-items reads.
const FRQ_PHOTO_SUBJECTS = Deno.env.get("FRQ_PHOTO_SUBJECTS") ?? null;

async function subjectKeyForPackVersion(service: Service, packVersionId: string | null): Promise<string | null> {
  if (!packVersionId) return null;
  const { data } = await service.schema("app")
    .from("exam_pack_versions")
    .select("exam_pack:exam_packs!inner(subject:subjects(subject_key))")
    .eq("id", packVersionId)
    .maybeSingle();
  const pack = Array.isArray(data?.exam_pack) ? data?.exam_pack[0] : data?.exam_pack;
  const subject = Array.isArray(pack?.subject) ? pack?.subject[0] : pack?.subject;
  return typeof subject?.subject_key === "string" ? subject.subject_key : null;
}

// Entitlement gating on SUBMISSION (2026-09-20), closing a gap
// `evaluate-attempt` already closed for grading (TASK-0026, 2026-08-15) but
// this function never did: nothing stopped an unentitled student from
// creating an attempt, drafting, and submitting a real answer that could
// then never be graded -- discovered live when a real student's two
// submitted FRQ attempts sat ungraded for a month with no actionable error
// (see docs/activity_log/ACTIVITY_LOG.md, "TASK-0016 Grading Rollout
// Re-Verified...", 2026-09-20). Gating submit_response on the exact same
// `authorize_grading_access` RPC `evaluate-attempt` already uses moves the
// failure to the point the student can still act on it (retake the QR
// capture, start a trial, check out) instead of after they've already
// committed a real answer that then silently can't be graded.
//
// Deliberately does NOT gate create_attempt/save_response: drafting and
// practicing without committing is harmless, and blocking it would turn a
// grading-access problem into a cannot-even-try-the-question problem for a
// window (new signup, checkout in flight) where the student may become
// entitled seconds later. Only the irreversible step -- submit -- is gated.
// Same env-gated const as evaluate-attempt, independently toggleable, kept
// as a separate flag rather than reusing the same name across functions so
// either path can be reverted independently of the other.
const SUBMIT_ENTITLEMENT_GATE_ENABLED =
  (Deno.env.get("GRADING_ENTITLEMENTS_ENABLED") ?? "false").toLowerCase() ===
    "true";

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
  actorId: string,
) {
  // Scoped to the caller (TASK-0069 review M3): a replayed key belonging to
  // another user must not hand back that user's stored result, which now
  // carries transcript text.
  const { data, error } = await service.schema("app")
    .from("audit_events")
    .select("metadata")
    .eq("request_id", requestId)
    .eq("reason_code", operation)
    .eq("actor_id", actorId)
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
    case "response_not_writable":
      // Round-4 QA S1: app.bind_response_attachment's DB-level writability
      // guard (migration 20260819120100) is shared by BOTH callers of the
      // function, so this code is reachable here too -- not just from
      // capture-pairing. The response version was submitted, or its attempt
      // left an editable status, between this request's own writability check
      // and the bind. That is a legitimate refusal, not a server fault, so it
      // must be a 409 with the same code capture-pairing's mapBindError
      // returns; without this case it fell through to a 500
      // "attach_capture_failed" and would have been reported as our bug.
      return { status: 409, body: { error: "response_already_submitted" } };
    case "response_not_found":
      // Also newly raised by the same guard (the response version disappeared,
      // or its attempt row is gone). A 404 matches how every other
      // response-not-found path in this function answers.
      return { status: 404, body: { error: "response_not_found" } };
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
    case "transcript_confirmation_required":
    case "photo_required":
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

type Service = ReturnType<typeof createServiceClient>;

// Seams the handler-level tests inject, same pattern as
// capture-pairing/index.ts's CapturePairingDeps. Both default to the real
// implementations, so production behaviour (Deno.serve(handleAttemptResponse),
// no deps passed) is byte-for-byte unchanged.
export interface AttemptResponseDeps {
  service?: Service;
  requireProfile?: typeof requireProfile;
  /** Model call for propose_transcript; injectable so tests never hit a vendor. */
  transcribe?: typeof runDrawnResponseTranscript;
}

type CurrentAttachmentRow = {
  id: string;
  kind: AttachmentKind;
  storage_bucket: string;
  storage_path: string;
  media_type: string;
  sha256_digest: string;
  redacted_at: string | null;
};

/**
 * The current original (and, when capture-pairing stored one, the
 * metadata-stripped derived copy) bound to a response version. Null original
 * means no photo is attached.
 */
async function loadCurrentAttachments(
  service: Service,
  responseVersionId: string,
): Promise<{ original: CurrentAttachmentRow | null; derived: CurrentAttachmentRow | null }> {
  const { data, error } = await service.schema("app")
    .from("response_attachments")
    .select("id, kind, storage_bucket, storage_path, media_type, sha256_digest, redacted_at, created_at")
    .eq("response_version_id", responseVersionId)
    .eq("is_current", true)
    .order("created_at", { ascending: false });
  if (error) throw new Error(`load_attachments:${error.message}`);
  const rows = (data ?? []) as Array<CurrentAttachmentRow & { created_at: string }>;
  return {
    original: rows.find((r) => r.kind === "original") ?? null,
    derived: rows.find((r) => r.kind === "derived") ?? null,
  };
}

async function transcriptRunsToday(service: Service, userId: string) {
  const today = new Date().toISOString().slice(0, 10);
  const r = await service.schema("app").from("model_usage_ledger")
    .select("id", { count: "exact", head: true })
    .like("request_id", `frq_transcript:${userId}:%`)
    .eq("usage_date_utc", today);
  if (r.error) throw new Error(`transcript_runs:${r.error.message}`);
  return r.count ?? 0;
}

async function transcriptSpendToday(service: Service) {
  const today = new Date().toISOString().slice(0, 10);
  const r = await service.schema("app").from("model_usage_ledger")
    .select("reserved_cost_usd, actual_cost_usd")
    .like("request_id", "frq_transcript:%")
    .eq("usage_date_utc", today);
  if (r.error) throw new Error(`transcript_spend:${r.error.message}`);
  return ((r.data ?? []) as Array<{ reserved_cost_usd: number | null; actual_cost_usd: number | null }>)
    .reduce((sum, row) => sum + Number(row.actual_cost_usd ?? row.reserved_cost_usd ?? 0), 0);
}

// Extracted from Deno.serve's inline callback (2026-09-20), plus the `deps`
// injection seam above: this file previously had zero test coverage of its
// own request-handling logic (QA-flagged, Round 4/5 of the Stage D2 reviews)
// because `Deno.serve(async (req) => {...})` gave nothing importable to drive
// from a test. Needed specifically to pin the new submit-time entitlement
// gate (below) without deploying blind on a path every real submission goes
// through -- every operation's own logic is unchanged, only made reachable
// with an injected fake service/auth instead of the real ones.
export async function handleAttemptResponse(
  req: Request,
  deps: AttemptResponseDeps = {},
): Promise<Response> {
  const authenticate = deps.requireProfile ?? requireProfile;
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

  const profileResult = await authenticate(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }
  const { user, profile } = profileResult;
  if (profile.role !== "student" && profile.role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const service = deps.service ?? createServiceClient();
  const requestHash = await sha256Hex(JSON.stringify({ operation, ...b }));

  try {
    if (operation !== "submit_response") {
      const existing = await loadIdempotentResult(
        service,
        idempotencyKey,
        requestHash,
        operation,
        user.id,
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
      if (attemptError?.message?.includes("open_hand_item_not_scorable")) {
        // trg_refuse_attempt_on_teaching_item: the item is in the Open Hand
        // teaching pool and must never be scored (TASK-0064).
        return respond(
          { error: "open_hand_item_not_scorable" },
          { status: 409 },
        );
      }
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
        capture_quality_state: boundAttachment.capture_quality_state,
        created_at: boundAttachment.created_at,
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

    // ------------------------------------------------------------------
    // Hand-drawn responses on every FRQ: transcript propose/confirm
    // (DECISION-0110). The student photographs their work (capture-pairing
    // binds it to an UNSUBMITTED response version), the model proposes a
    // per-part transcript, the student confirms or completes it, and only the
    // confirmed text is ever submitted and graded. Both ops are owner-only:
    // the attachment lives in the owner's storage namespace and the
    // transcript is the owner's own answer.
    // ------------------------------------------------------------------
    if (operation === "propose_transcript" || operation === "confirm_transcript") {
      if (!FRQ_PHOTO_RESPONSES_ENABLED) {
        return respond({ error: "feature_disabled" }, { status: 409 });
      }
      const tAttemptId = asUuid(b.attempt_id ?? b.attemptId);
      const tResponseVersionId = asUuid(b.response_version_id ?? b.responseVersionId);
      if (!tAttemptId || !tResponseVersionId) {
        return respond(
          { error: "missing_required_fields", required: ["attempt_id", "response_version_id"] },
          { status: 400 },
        );
      }
      const { data: tAttempt, error: tAttemptError } = await service.schema("app")
        .from("attempts")
        .select("id, user_id, status, content_item_version_id, exam_pack_version_id")
        .eq("id", tAttemptId)
        .maybeSingle();
      if (tAttemptError || !tAttempt) {
        return respond({ error: "attempt_not_found" }, { status: 404 });
      }
      if (tAttempt.user_id !== user.id) {
        return respond({ error: "forbidden" }, { status: 403 });
      }
      // Dark launch is enforced here too, not only in the UI (QA P2-a).
      const tSubjectKey = await subjectKeyForPackVersion(service, tAttempt.exam_pack_version_id as string | null);
      if (!photoEnabledFor({ subjectKey: tSubjectKey, configured: FRQ_PHOTO_SUBJECTS, isAdmin: profile.role === "admin" })) {
        return respond({ error: "feature_disabled" }, { status: 409 });
      }
      if (!["draft", "failed"].includes(tAttempt.status as string)) {
        return respond(
          { error: "attempt_not_editable", attempt_status: tAttempt.status },
          { status: 409 },
        );
      }
      const { data: tVersion, error: tVersionError } = await service.schema("app")
        .from("response_versions")
        .select("id, attempt_id, is_submitted, response_text, response_parts")
        .eq("id", tResponseVersionId)
        .maybeSingle();
      if (tVersionError || !tVersion) {
        return respond({ error: "response_not_found" }, { status: 404 });
      }
      if (tVersion.attempt_id !== tAttemptId) {
        return respond({ error: "response_attempt_mismatch" }, { status: 409 });
      }
      if (tVersion.is_submitted) {
        return respond({ error: "response_already_submitted" }, { status: 409 });
      }
      const attachments = await loadCurrentAttachments(service, tResponseVersionId);
      if (!attachments.original) {
        return respond({ error: "no_attachment" }, { status: 409 });
      }
      if (attachments.original.redacted_at) {
        return respond({ error: "attachment_redacted" }, { status: 409 });
      }
      const { data: tContent, error: tContentError } = await service.schema("app")
        .from("content_item_versions")
        .select("id, stem, prompt_json")
        .eq("id", tAttempt.content_item_version_id)
        .maybeSingle();
      if (tContentError || !tContent) {
        return respond({ error: "content_not_found" }, { status: 404 });
      }
      const itemParts = deriveItemParts(tContent.prompt_json);
      const existingParts = readResponseParts(tVersion.response_parts);

      if (operation === "propose_transcript") {
        const force = b.force === true;
        const digests = [attachments.original.sha256_digest];
        const key = await transcriptKey(digests, FRQ_TRANSCRIPT_MODEL);
        const prior = readTranscriptRecord(existingParts);
        // A confirmation given for a DIFFERENT photo (the student retook the
        // page after confirming) is cleared here and refused by the submit
        // gate, so a stale transcript can never be graded (review H1).
        const staleConfirmation = confirmationIsStale(existingParts, attachments.original.sha256_digest);
        if (prior && prior.key === key && prior.status === "proposed" && !force && !staleConfirmation) {
          const reused = { transcript: transcriptView(prior), parts: itemParts, reused: true };
          return respond({ status: "ok", function: "attempt-response", operation, result: reused });
        }

        // Caps (plan D5 defaults). Both fail closed to an "unavailable"
        // record so the student is told to type instead of being blocked.
        let unavailable: "cost_cap_reached" | null = null;
        try {
          if ((await transcriptRunsToday(service, user.id)) >= FRQ_TRANSCRIPT_DAILY_RUNS) {
            unavailable = "cost_cap_reached";
          } else if ((await transcriptSpendToday(service)) >= FRQ_PHOTO_DAILY_CAP_USD) {
            unavailable = "cost_cap_reached";
          }
        } catch (capError) {
          console.error("frq_transcript_cap_check_failed", capError);
          unavailable = "cost_cap_reached";
        }

        const transcribe = deps.transcribe ?? runDrawnResponseTranscript;
        const now = new Date().toISOString();
        let outcome: Awaited<ReturnType<typeof runDrawnResponseTranscript>>;
        if (unavailable) {
          outcome = { kind: "unavailable", failure: unavailable };
        } else {
          // Prefer the metadata-stripped derived copy when capture-pairing
          // stored one; the original is the immutable record.
          const source = attachments.derived ?? attachments.original;
          const { data: blob, error: downloadError } = await service.storage
            .from(source.storage_bucket || LEARNER_UPLOADS_BUCKET)
            .download(source.storage_path);
          if (downloadError || !blob) {
            const notFound = /not.?found|404/i.test(downloadError?.message ?? "");
            return respond(
              { error: notFound ? "capture_object_not_found" : "capture_download_failed" },
              { status: notFound ? 404 : 502 },
            );
          }
          const bytes = new Uint8Array(await blob.arrayBuffer());
          const mediaType = (["image/jpeg", "image/png", "image/webp"].includes(source.media_type)
            ? source.media_type
            : "image/jpeg") as TranscriptMediaType;
          const ledgerRequestId = `frq_transcript:${user.id}:${tResponseVersionId}:${key.slice(0, 12)}:${Date.now()}`;
          const ledgerRequestHash = await sha256Hex(ledgerRequestId);
          let reserved = false;
          outcome = await transcribe({
            pages: [{ bytes, mediaType }],
            parts: itemParts,
            stem: typeof tContent.stem === "string" ? tContent.stem : "",
            subjectName: null,
            modelId: FRQ_TRANSCRIPT_MODEL,
            apiKey: FRQ_TRANSCRIPT_API_KEY,
            timeoutMs: FRQ_TRANSCRIPT_TIMEOUT_MS,
            reserveCost: async () => {
              if (!(FRQ_TRANSCRIPT_SHARED_CAP_USD > 0)) return false;
              const r = await service.schema("app").rpc("reserve_model_usage", {
                p_request_id: ledgerRequestId,
                p_request_hash: ledgerRequestHash,
                p_model_id: FRQ_TRANSCRIPT_MODEL,
                p_reserved_cost_usd: FRQ_TRANSCRIPT_RESERVED_COST_USD,
                p_cap_usd: FRQ_TRANSCRIPT_SHARED_CAP_USD,
              });
              reserved = !r.error && Boolean(r.data);
              return reserved;
            },
          });
          if (reserved) {
            const r = await service.schema("app").rpc("complete_model_usage", {
              p_request_id: ledgerRequestId,
              p_request_hash: ledgerRequestHash,
              p_status: outcome.kind === "proposed" ? "completed" : "failed",
              p_actual_cost_usd: FRQ_TRANSCRIPT_RESERVED_COST_USD,
              p_input_tokens: outcome.kind === "proposed" ? outcome.usage.input_tokens : null,
              p_output_tokens: outcome.kind === "proposed" ? outcome.usage.output_tokens : null,
            });
            if (r.error) console.error("frq_transcript_release_failed", r.error.message);
          }
          if (outcome.kind === "failed") {
            console.error("frq_transcript_failed", { failure: outcome.failure, detail: outcome.detail });
          }
        }

        const record = buildTranscriptRecord({ outcome, key, pageDigests: digests, modelId: FRQ_TRANSCRIPT_MODEL, at: now });
        // Atomic merge (review H2): a confirm that landed during the model
        // call survives; a stale confirmation for a replaced photo is dropped.
        const { error: storeError } = await service.schema("app").rpc("merge_response_parts", {
          p_response_version_id: tResponseVersionId,
          p_patch: { _transcript: record },
          p_response_text: null,
          p_drop_keys: staleConfirmation ? [...CONFIRMATION_KEYS] : [],
        });
        if (storeError) {
          if (/already_submitted/.test(storeError.message)) {
            return respond({ error: "response_already_submitted" }, { status: 409 });
          }
          return respond({ error: "transcript_store_failed" }, { status: 500 });
        }
        const result = { transcript: transcriptView(record), parts: itemParts, reused: false };
        await recordIdempotentResult(service, idempotencyKey, requestHash, operation, user.id, "response_version", tResponseVersionId, result);
        return respond({ status: "ok", function: "attempt-response", operation, result });
      }

      // confirm_transcript
      const validation = validateConfirmedParts({
        itemParts,
        submitted: b.parts,
        studentAdded: b.student_added ?? b.studentAdded,
      });
      if (!validation.ok) {
        return respond({ error: validation.reason }, { status: 422 });
      }
      const priorRecord = readTranscriptRecord(existingParts);
      const proposedMap: Record<string, string> = {};
      for (const part of priorRecord?.proposed?.parts ?? []) proposedMap[part.part_key] = part.text;
      const inferred = inferStudentAdded({ proposed: proposedMap, confirmed: validation.parts });
      const studentAdded: Record<string, string[]> = { ...inferred };
      for (const [k, spans] of Object.entries(validation.studentAdded)) {
        studentAdded[k] = [...new Set([...(studentAdded[k] ?? []), ...spans])];
      }
      const confirmedAt = new Date().toISOString();
      // One SQL function, under the attempt -> response lock order: checks
      // the current photo still matches, writes the confirmed text, and stores
      // the photo and content digests the submission guard re-checks inside
      // the submit transaction (QA P1-a, P1-b).
      const { data: confirmedRow, error: confirmError } = await service.schema("app")
        .rpc("confirm_response_transcript", {
          p_attempt_id: tAttemptId,
          p_response_version_id: tResponseVersionId,
          p_actor_id: user.id,
          p_parts: validation.parts,
          p_response_text: validation.responseText,
          p_student_added: studentAdded,
          p_photo_digest: attachments.original.sha256_digest,
          p_confirmed_at: confirmedAt,
        })
        .single<{ id: string; attempt_id: string; response_text: string | null; version_number: number; is_submitted: boolean }>();
      if (confirmError || !confirmedRow) {
        const code = confirmError?.message?.match(/confirm_transcript:([a-z_]+)/)?.[1] ?? null;
        switch (code) {
          case "photo_changed":
          case "no_attachment":
          case "response_already_submitted":
          case "attempt_not_editable":
          case "response_attempt_mismatch":
            return respond({ error: code }, { status: 409 });
          case "forbidden":
            return respond({ error: "forbidden" }, { status: 403 });
          case "attempt_not_found":
          case "response_not_found":
            return respond({ error: "not_found" }, { status: 404 });
          case "invalid_parts":
            return respond({ error: "unknown_part" }, { status: 422 });
          default:
            return respond({ error: "transcript_confirm_failed" }, { status: 500 });
        }
      }
      const result = {
        response_version: {
          id: confirmedRow.id,
          attempt_id: confirmedRow.attempt_id,
          response_text: confirmedRow.response_text,
          version_number: confirmedRow.version_number,
          is_submitted: confirmedRow.is_submitted,
          confirmed_at: confirmedAt,
          student_added_parts: Object.keys(studentAdded),
        },
      };
      await recordIdempotentResult(service, idempotencyKey, requestHash, operation, user.id, "response_version", tResponseVersionId, result);
      return respond({ status: "ok", function: "attempt-response", operation, result });
    }

    // Retention by redaction (DECISION-0111): removes the image bytes of one
    // attachment lineage (original + derived) and stamps redacted_at. The
    // row survives for audit. Admin-only and service-role: the only write
    // the immutability trigger permits beyond the quality/current/reviewed
    // columns.
    if (operation === "redact_attachment") {
      if (profile.role !== "admin") {
        return respond({ error: "forbidden" }, { status: 403 });
      }
      const rAttachmentId = asUuid(b.attachment_id ?? b.attachmentId);
      if (!rAttachmentId) {
        return respond({ error: "missing_required_fields", required: ["attachment_id"] }, { status: 400 });
      }
      const { data: target, error: targetError } = await service.schema("app")
        .from("response_attachments")
        .select("id, response_version_id, storage_bucket, storage_path, kind, redacted_at")
        .eq("id", rAttachmentId)
        .maybeSingle();
      if (targetError || !target) {
        return respond({ error: "attachment_not_found" }, { status: 404 });
      }
      const { data: lineage, error: lineageError } = await service.schema("app")
        .from("response_attachments")
        .select("id, storage_bucket, storage_path, kind, redacted_at")
        .eq("response_version_id", target.response_version_id);
      // A lookup failure is a failure, never an empty lineage (QA P2-b).
      if (lineageError || !Array.isArray(lineage) || lineage.length === 0) {
        return respond({ error: "redaction_lookup_failed" }, { status: 500 });
      }
      const outcome = await redactLineage(lineage as RedactionRow[], {
        defaultBucket: LEARNER_UPLOADS_BUCKET,
        remove: async (bucket, paths) => {
          const { data, error } = await service.storage.from(bucket).remove(paths);
          return {
            removed: (data ?? []).map((o) => (o as { name?: string }).name ?? "").filter(Boolean),
            error: error ? error.message : null,
          };
        },
        exists: async (bucket, path) => {
          const slash = path.lastIndexOf("/");
          const dir = slash >= 0 ? path.slice(0, slash) : "";
          const file = slash >= 0 ? path.slice(slash + 1) : path;
          const { data, error } = await service.storage.from(bucket).list(dir, { search: file, limit: 100 });
          if (error) return null;
          return (data ?? []).some((o) => (o as { name?: string }).name === file);
        },
        stamp: async (id) => {
          const { error } = await service.schema("app").rpc("redact_response_attachment", { p_attachment_id: id });
          return !error;
        },
      });
      if (!outcome.ok) {
        // Not recorded as an idempotent result: a retry with the same key resumes.
        return respond(
          { error: outcome.error, redacted: outcome.redacted, ...(outcome.attachments ? { attachments: outcome.attachments } : {}) },
          { status: outcome.status },
        );
      }
      const result = { redacted: outcome.redacted, already_redacted: outcome.alreadyRedacted };
      await recordIdempotentResult(service, idempotencyKey, requestHash, operation, user.id, "response_attachment", rAttachmentId, result);
      return respond({ status: "ok", function: "attempt-response", operation, result });
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

    // TASK-0038 Phase 4. Both read operations exist because
    // app.attempts/response_attachments/grading_results RLS is owner-only
    // (auth.uid() = user_id) with no admin bypass -- an admin reading a REAL
    // student's attempt directly via the authenticated client (the pattern
    // the original single-attempt grading page used) only ever worked
    // because every attempt graded through this pilot so far has been the
    // admin's own test submission. These go through the service role
    // instead, same as record_manual_grade's write path.
    if (operation === "list_manual_grading_queue") {
      if (profile.role !== "admin") {
        return respond({ error: "forbidden" }, { status: 403 });
      }

      const { data: submittedAttempts, error: submittedError } = await service
        .schema("app")
        .from("attempts")
        .select("id, user_id, content_item_version_id, submitted_at")
        .eq("status", "submitted")
        .order("submitted_at", { ascending: true });
      if (submittedError) {
        return respond({ error: "grading_queue_failed" }, { status: 500 });
      }
      const submittedIds = (submittedAttempts ?? []).map((a) =>
        a.id as string
      );
      if (submittedIds.length === 0) {
        return respond({
          status: "ok",
          function: "attempt-response",
          operation,
          result: { items: [] },
        });
      }

      // Only a hand-drawn capture attempt ever has a current original
      // response_attachments row -- this is what scopes the queue to the
      // hand-drawn pilot rather than every submitted-but-unrelated attempt
      // (typed FRQs are graded automatically by evaluate-attempt and never
      // sit in "submitted" waiting on a human).
      const { data: attachments, error: attachmentsError } = await service
        .schema("app")
        .from("response_attachments")
        .select("attempt_id, created_at")
        .in("attempt_id", submittedIds)
        .eq("is_current", true)
        .eq("kind", "original");
      if (attachmentsError) {
        return respond({ error: "grading_queue_failed" }, { status: 500 });
      }
      const capturedAtByAttempt = new Map<string, string>();
      for (const row of attachments ?? []) {
        capturedAtByAttempt.set(row.attempt_id as string, row.created_at as string);
      }
      const pending = (submittedAttempts ?? []).filter((a) =>
        capturedAtByAttempt.has(a.id as string)
      );
      if (pending.length === 0) {
        return respond({
          status: "ok",
          function: "attempt-response",
          operation,
          result: { items: [] },
        });
      }

      const versionIds = [
        ...new Set(pending.map((a) => a.content_item_version_id as string)),
      ];
      const userIds = [...new Set(pending.map((a) => a.user_id as string))];

      const [{ data: versionRows }, { data: profileRows }] = await Promise
        .all([
          service.schema("app").from("content_item_versions")
            .select("id, content_item_id")
            .in("id", versionIds),
          service.schema("app").from("profiles")
            .select("user_id, full_name")
            .in("user_id", userIds),
        ]);
      const itemIdByVersion = new Map(
        (versionRows ?? []).map((
          r,
        ) => [r.id as string, r.content_item_id as string]),
      );
      const itemIds = [...new Set([...itemIdByVersion.values()])];
      const { data: itemRows } = itemIds.length
        ? await service.schema("app").from("content_items")
          .select("id, content_key, title")
          .in("id", itemIds)
        : { data: [] as Array<{ id: string; content_key: string; title: string | null }> };
      const itemByItemId = new Map(
        (itemRows ?? []).map((r) => [r.id as string, r]),
      );
      const nameByUser = new Map(
        (profileRows ?? []).map((
          r,
        ) => [r.user_id as string, r.full_name as string | null]),
      );

      const items = pending.map((a) => {
        const contentItemId = itemIdByVersion.get(
          a.content_item_version_id as string,
        );
        const item = contentItemId ? itemByItemId.get(contentItemId) : null;
        return {
          attempt_id: a.id,
          content_key: item?.content_key ?? null,
          title: item?.title ?? null,
          submitted_at: a.submitted_at,
          captured_at: capturedAtByAttempt.get(a.id as string) ?? null,
          student_display_name: nameByUser.get(a.user_id as string) ?? null,
        };
      });

      return respond({
        status: "ok",
        function: "attempt-response",
        operation,
        result: { items },
      });
    }

    if (operation === "get_manual_grading_context") {
      if (profile.role !== "admin") {
        return respond({ error: "forbidden" }, { status: 403 });
      }

      const contextAttemptId = asUuid(b.attempt_id ?? b.attemptId);
      if (!contextAttemptId) {
        return respond(
          { error: "missing_required_fields", required: ["attempt_id"] },
          { status: 400 },
        );
      }

      const { data: attempt, error: attemptError } = await service
        .schema("app")
        .from("attempts")
        .select("id, status, content_item_version_id")
        .eq("id", contextAttemptId)
        .maybeSingle();
      if (attemptError || !attempt) {
        return respond({ error: "attempt_not_found" }, { status: 404 });
      }

      const { data: responseVersionRow } = await service
        .schema("app")
        .from("response_versions")
        .select("id, response_text, response_parts")
        .eq("attempt_id", contextAttemptId)
        .eq("is_submitted", true)
        .maybeSingle();
      if (!responseVersionRow) {
        return respond({ error: "response_not_found" }, { status: 404 });
      }

      const { data: attachment } = await service
        .schema("app")
        .from("response_attachments")
        .select("id, storage_bucket, storage_path, media_type, redacted_at")
        .eq("response_version_id", responseVersionRow.id)
        .eq("is_current", true)
        .eq("kind", "original")
        .maybeSingle();

      // judgement_kind (2026-10-09): tells the grader which criteria the
      // confirmed transcript can settle and which need the picture.
      const { data: criteriaRows } = await service
        .schema("app")
        .from("frq_criteria")
        .select("criterion_key, learner_facing_text, points_possible, judgement_kind")
        .eq("content_item_version_id", attempt.content_item_version_id)
        .order("criterion_key", { ascending: true });

      const { data: contextContent } = await service.schema("app")
        .from("content_item_versions")
        .select("stem, prompt_json, content_items!inner(content_key, title)")
        .eq("id", attempt.content_item_version_id)
        .maybeSingle();
      const contextItem = contextContent
        ? (Array.isArray(contextContent.content_items) ? contextContent.content_items[0] : contextContent.content_items) as { content_key?: string; title?: string | null } | null
        : null;
      const contextParts = readResponseParts(responseVersionRow.response_parts);
      const itemParts = deriveItemParts(contextContent?.prompt_json ?? null);
      const transcriptParts: Record<string, string> = {};
      for (const part of itemParts) {
        const value = contextParts[part.part_key];
        transcriptParts[part.part_key] = typeof value === "string" ? value : "";
      }

      return respond({
        status: "ok",
        function: "attempt-response",
        operation,
        result: {
          attempt_status: attempt.status,
          response_version_id: responseVersionRow.id,
          content_key: contextItem?.content_key ?? null,
          title: contextItem?.title ?? null,
          stem: typeof contextContent?.stem === "string" ? contextContent.stem : null,
          attachment_id: attachment?.id ?? null,
          storage_bucket: attachment?.storage_bucket ?? null,
          storage_path: attachment?.storage_path ?? null,
          media_type: attachment?.media_type ?? null,
          attachment_redacted_at: attachment?.redacted_at ?? null,
          // The student's response of record: typed text, or the confirmed
          // transcript of their photographed work (DECISION-0110).
          response_text: typeof responseVersionRow.response_text === "string" ? responseVersionRow.response_text : null,
          response_source: typeof contextParts._source === "string" ? contextParts._source : (attachment ? "photo" : "typed"),
          transcript_parts: transcriptParts,
          student_added: contextParts._student_added ?? null,
          transcript_confirmed_at: typeof contextParts._confirmed_at === "string" ? contextParts._confirmed_at : null,
          item_parts: itemParts,
          criteria: (criteriaRows ?? []).filter((c) =>
            c.learner_facing_text != null
          ),
        },
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

    // The photo-confirmation and photo_required rules are enforced by
    // app.response_versions_guard_submission INSIDE the submit transaction
    // (QA P1-a, P1-b, P2-a); errors arrive as submit_response:<code> below.

    // Admin calls are operational and intentionally bypass learner
    // entitlements, same exemption evaluate-attempt grants.
    if (SUBMIT_ENTITLEMENT_GATE_ENABLED && profile.role !== "admin") {
      const { error: accessError } = await service.schema("app").rpc(
        "authorize_grading_access",
        {
          p_user_id: user.id,
          p_attempt_id: attemptId,
          p_operation: operation,
          p_request_id: idempotencyKey,
        },
      );
      if (accessError) {
        const accessCode = accessError.message.match(
          /grading_access:([a-z_]+)/,
        )?.[1] ?? "entitlement_required";
        const status = accessCode === "attempt_not_found" ? 404 : 403;
        return respond({ error: accessCode }, { status });
      }
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
}

if (import.meta.main) {
  Deno.serve((req) => handleAttemptResponse(req));
}
