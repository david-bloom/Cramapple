// capture-pairing -- the QR capture bridge for Engine 4.
//
// TASK-0016 Phase D, Stage D2 ("Implement and verify the QR capture MVP"),
// executing DECISION-0051: QR handoff is Engine 4's sole capture path, and
// System A's frontend is rewired onto System B's already-deployed
// `attach_capture` / `app.response_attachments` backend rather than
// recreating `capture_sessions` / `capture-research`.
//
// WHY A SEPARATE FUNCTION RATHER THAN A NEW attempt-response OPERATION
// --------------------------------------------------------------------
// `attempt-response` runs ONE `requireProfile(req)` gate above its operation
// switch, so every operation it will ever contain is authenticated by
// construction. Adding an intentionally-unauthenticated operation inside
// that switch would mean moving the auth check below the switch, and from
// then on every future operation added to that file would be
// unauthenticated-by-default unless its author remembered to opt in. That is
// a bad shape for the most security-sensitive function in the codebase, and
// TASK-0025's QA review already found one dead admin-on-behalf-of-student
// branch there caused by exactly this sort of blurred boundary.
//
// So the split is: `attempt-response` stays "authenticated callers only",
// and this function owns the token-authenticated leg. It does NOT
// reimplement any of the work `attach_capture` does -- it imports the same
// `validateCaptureObject` / `planAttachmentInsert` / `isSafeStoragePath` /
// `ownsLearnerPath` helpers and calls the same
// `app.bind_response_attachment` RPC, so byte validation, retake lineage,
// and the storage TOCTOU guard are literally the same code and the same
// atomic write, not a parallel copy.
//
// OPERATION SURFACE
// -----------------
// Authenticated (the student's own primary device, real Supabase JWT):
//   mint_pairing    -- request one submission slot, receive one capability
//   pairing_status  -- poll the slot (the "primary device receives status
//                      updates" requirement)
//   cancel_pairing  -- abandon the slot
// Token-authenticated (the phone, no JWT, capability only):
//   describe_capture      -- what the phone needs to render its page
//   create_capture_upload -- signed, single-path upload URL
//   submit_capture        -- validate, quality-check, bind, consume
//
// The service-role key never leaves this function. The phone receives a
// Supabase Storage signed-upload URL scoped to one exact object path, which
// is a capability for that path and nothing else.

import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";
import { isSafeStoragePath, ownsLearnerPath } from "../_shared/storage-paths.ts";
import {
  planAttachmentInsert,
  validateCaptureObject,
} from "../_shared/capture-attachment.ts";
import {
  buildDerivedCapturePath,
  buildOriginalCapturePath,
  buildPairingProvenanceEvent,
  type CaptureExtension,
  type CaptureFailureClass,
  checkPurposeBinding,
  evaluateMintRateLimit,
  evaluatePairingUsability,
  extensionForMediaType,
  GENERIC_RETAKE_GUIDANCE,
  generatePairingHandle,
  hashPairingHandle,
  isPairingAccessPath,
  isWellFormedPairingHandle,
  type PairingAccessPath,
  type PairingBinding,
  type PairingEventType,
  PAIRING_MAX_REDEMPTION_ATTEMPTS,
  PAIRING_MINT_MAX_PER_WINDOW,
  PAIRING_MINT_WINDOW_SECONDS,
  PAIRING_TTL_SECONDS,
  type PairingState,
  TECHNICAL_FAILURE_GUIDANCE,
} from "../_shared/capture-pairing.ts";
import {
  type CaptureQualityOutcome,
  mapDispositionToProvenanceQualityStatus,
  runCaptureQualityCheck,
  toCaptureQualityResultV1,
} from "../_shared/capture-quality-check.ts";
import {
  stripImageMetadata,
  summarizeMetadataStrip,
} from "../_shared/image-metadata.ts";

const BUCKET = "learner-uploads";

type AuthedOperation = "mint_pairing" | "pairing_status" | "cancel_pairing";
type TokenOperation =
  | "describe_capture"
  | "create_capture_upload"
  | "submit_capture";
type Operation = AuthedOperation | TokenOperation;

const AUTHED_OPERATIONS = new Set<AuthedOperation>([
  "mint_pairing",
  "pairing_status",
  "cancel_pairing",
]);
const TOKEN_OPERATIONS = new Set<TokenOperation>([
  "describe_capture",
  "create_capture_upload",
  "submit_capture",
]);

// Capture-quality checking is best-effort by design: if it is not
// configured, an upload still binds (with capture_quality_state 'pending')
// exactly as it does through attach_capture today. It must never be the
// reason a student's photo is rejected. Unlike the reverted Layer A
// version, the model call is metered through the same daily-cap RPC
// evaluate-attempt uses -- see _shared/capture-quality-check.ts's header.
const CAPTURE_QUALITY_API_KEY = Deno.env.get("OPENAI_API_KEY") ?? null;
const CAPTURE_QUALITY_MODEL = Deno.env.get("CAPTURE_QUALITY_MODEL") ??
  "gpt-4o-mini";
const CAPTURE_QUALITY_TIMEOUT_MS = Number(
  Deno.env.get("CAPTURE_QUALITY_TIMEOUT_MS"),
) || 12_000;
// A single small-model vision call on one photo. Deliberately a fixed
// conservative reservation rather than a token estimate: this path has one
// image and one 512-token ceiling, so there is nothing to estimate.
const CAPTURE_QUALITY_RESERVED_COST_USD = Number(
  Deno.env.get("CAPTURE_QUALITY_RESERVED_COST_USD"),
) || 0.01;
const CAPTURE_QUALITY_DAILY_CAP_USD = Number(
  Deno.env.get("OPENAI_DAILY_CAP_USD"),
) || 0;

type Service = ReturnType<typeof createServiceClient>;

interface PairingRow {
  id: string;
  handle_sha256: string;
  upload_purpose: "DRAWN_RESPONSE";
  user_id: string;
  learning_session_id: string | null;
  attempt_id: string;
  response_version_id: string;
  content_item_version_id: string;
  submission_slot_id: string;
  generation: number;
  state: PairingState;
  access_path: PairingAccessPath | null;
  expires_at: string;
  redemption_attempts: number;
  upload_storage_path: string | null;
  bound_attachment_id: string | null;
  capture_quality_state: string | null;
  failure_class: CaptureFailureClass | null;
  created_at: string;
}

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

function bindingOf(row: PairingRow): PairingBinding {
  return {
    user_id: row.user_id,
    learning_session_id: row.learning_session_id,
    attempt_id: row.attempt_id,
    response_version_id: row.response_version_id,
    content_item_version_id: row.content_item_version_id,
    submission_slot_id: row.submission_slot_id,
    upload_purpose: "DRAWN_RESPONSE",
  };
}

/**
 * ONE place decides what the phone/primary device is allowed to know about
 * a capability. Everything not in this projection -- the user id, the
 * attempt id, the response version id, the storage path, the handle hash --
 * stays server-side. That is what "capability contains no readable learner
 * PII and cannot access other records" looks like on the response side: a
 * capability holder learns the slot they are filling and nothing that
 * identifies the learner or any neighbouring record.
 */
function publicPairingView(row: PairingRow) {
  return {
    state: row.state,
    submission_slot_id: row.submission_slot_id,
    generation: row.generation,
    expires_at: row.expires_at,
    attempts_remaining: Math.max(
      0,
      PAIRING_MAX_REDEMPTION_ATTEMPTS - row.redemption_attempts,
    ),
    capture_quality_state: row.capture_quality_state,
    // DECISION-0051 split, surfaced to the primary device (which never sees
    // the phone's submit response). Lets the desktop tell an image-quality
    // retake ('image_quality') apart from a broken checker ('technical')
    // instead of collapsing both into the single 'indeterminate' quality state.
    failure_class: row.failure_class,
    has_bound_attachment: Boolean(row.bound_attachment_id),
  };
}

/* -------------------------------------------------------------------------- */
/* Audit / telemetry                                                          */
/* -------------------------------------------------------------------------- */

/**
 * BUG LOGGING (DECISION-0051 item 3, technical-failure half).
 *
 * This repo has NO general error-tracking service or table. There is no
 * Sentry, no Rollbar, no `app.error_events`. What exists is:
 *   * `app.audit_events` -- durable, hash-chained, already used by
 *     attempt-response / storage-sign-url / admin-content / session-event;
 *   * `app.growth_event_outbox` -> PostHog (_shared/growth-events.ts) --
 *     an acquisition-funnel pipeline with a closed event-name allowlist and
 *     an explicit "no answers, no grades, no PII" property filter. Pushing
 *     engineering errors through it would both violate that contract and
 *     pollute funnel analytics;
 *   * `_shared/grading-telemetry.ts` -- observational columns specific to
 *     grading_results rows.
 *
 * So this uses `app.audit_events`, the existing durable-audit convention,
 * and returns the audit row's id to the client as `incident_id` so a
 * student-visible "we've logged this" message has a real reference behind
 * it. This is a deliberate reuse of what exists, not a new mechanism -- and
 * it is NOT an alerting system: nothing pages anyone. Standing up real error
 * tracking is called out as an open item in
 * docs/research/grading_phase_d_spatial_2026_07_27/QR_MVP_IMPLEMENTATION.md.
 */
async function logAuditEvent(
  service: Service,
  params: {
    action: string;
    actorId: string | null;
    actorType: "human" | "system";
    objectType: string;
    objectId: string;
    requestId: string;
    reasonCode: string;
    metadata: Record<string, unknown>;
  },
): Promise<string | null> {
  const auditEventId = crypto.randomUUID();
  const now = new Date().toISOString();
  // request_id is UNIQUE per audit row on purpose. app.audit_events has a
  // UNIQUE(request_id, reason_code) partial index; the previous version reused
  // the request's idempotency key across every audit site, so a second event
  // with the same reason_code in one request (e.g. a derive failure AND a
  // capture-quality technical failure) collided on that index and was silently
  // dropped -- while still returning a fabricated incident_id. Worse, that key
  // came from the unauthenticated phone leg, so a caller could pin it to
  // suppress its own subsequent error logs. A server-generated per-event
  // request_id makes both the accidental collision and the deliberate
  // suppression impossible; the HTTP-request correlation id is preserved in
  // metadata.correlation_id for cross-referencing.
  const { error } = await service.schema("app").from("audit_events").insert({
    audit_event_id: auditEventId,
    occurred_at: now,
    actor_type: params.actorType,
    actor_id: params.actorId,
    action: params.action,
    object_type: params.objectType,
    object_id: params.objectId,
    request_id: auditEventId,
    reason_code: params.reasonCode,
    metadata: { ...params.metadata, correlation_id: params.requestId },
    event_sha256: await sha256Hex(
      JSON.stringify({
        action: params.action,
        objectId: params.objectId,
        metadata: params.metadata,
      }),
    ),
    created_at: now,
  });
  // Audit failure must not take down the capture path, but it must not be
  // silent either -- the function log is the last resort. Return null rather
  // than a fabricated id so a caller never hands the student an incident_id
  // that points at no row.
  if (error) {
    console.error("capture_pairing_audit_failed", error.message);
    return null;
  }
  return auditEventId;
}

/**
 * Persists a technical failure_class on the token (N6). The finalise RPCs set
 * failure_class for quality-check outcomes, but a sign-upload failure (502) or a
 * bind failure (500) returns before finalise, so without this the primary
 * device -- which only ever sees `pairing_status` -- could not render the
 * DECISION-0051 technical screen for those two failure sources. Best-effort;
 * never throws.
 */
async function markTokenTechnicalFailure(service: Service, pairingId: string) {
  const { error } = await service.schema("app")
    .from("capture_pairing_tokens")
    .update({ failure_class: "technical" satisfies CaptureFailureClass })
    .eq("id", pairingId);
  if (error) {
    console.error("capture_pairing_mark_failure_failed", error.message);
  }
}

/** Appends one contract-shaped provenance event. Never throws. */
async function appendProvenanceEvent(
  service: Service,
  row: PairingRow,
  params: {
    eventType: PairingEventType;
    actor: Parameters<typeof buildPairingProvenanceEvent>[0]["actor"];
    itemId: string;
    imageId?: string | null;
    replacesImageId?: string | null;
    qualityStatus?: "ACCEPTABLE" | "RETAKE_REQUIRED" | "CANNOT_DETERMINE" | null;
    explicitConfirmation?: boolean | null;
    reason?: string | null;
  },
) {
  try {
    const eventId = crypto.randomUUID();
    const occurredAt = new Date();
    // The `sequence` here is a placeholder: app.append_capture_pairing_event
    // assigns the real one atomically under a lock on the parent token row and
    // patches it into the stored record. The previous version computed the
    // sequence from an UNLOCKED count(*) and then inserted against
    // UNIQUE(pairing_id, sequence), so two concurrent appends for the same
    // pairing computed the same next value and one insert was rejected and
    // silently swallowed -- a dropped event in a stream that is supposed to be
    // complete. Doing the read+insert inside one locked function closes that.
    const event = buildPairingProvenanceEvent({
      eventId,
      pairingId: row.id,
      sequence: 1,
      eventType: params.eventType,
      occurredAt,
      actor: params.actor,
      binding: bindingOf(row),
      itemId: params.itemId,
      expiresAt: new Date(row.expires_at),
      generation: row.generation,
      handleSha256: row.handle_sha256,
      accessPath: row.access_path,
      imageId: params.imageId ?? null,
      replacesImageId: params.replacesImageId ?? null,
      qualityStatus: params.qualityStatus ?? null,
      explicitConfirmation: params.explicitConfirmation ?? null,
      reason: params.reason ?? null,
    });
    const { error } = await service.schema("app")
      .rpc("append_capture_pairing_event", {
        p_pairing_id: row.id,
        p_event_id: eventId,
        p_event_type: params.eventType,
        p_actor: params.actor,
        p_occurred_at: occurredAt.toISOString(),
        p_event: event,
      });
    if (error) {
      console.error("capture_pairing_event_insert_failed", error.message);
    }
  } catch (error) {
    console.error(
      "capture_pairing_event_failed",
      error instanceof Error ? error.message : String(error),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* Capability lookup                                                          */
/* -------------------------------------------------------------------------- */

/**
 * Resolves a capability WITHOUT consuming an attempt. Used by the read-only
 * phone operations and by submit (whose single-use guarantee comes from the
 * `consume_capture_pairing` compare-and-set, not from this read).
 *
 * Every refusal is reported with the same generic vocabulary regardless of
 * cause-of-not-found, so a caller cannot probe for the existence of a
 * capability it does not hold.
 */
async function loadCapability(
  service: Service,
  handle: string,
): Promise<
  | { ok: true; row: PairingRow }
  | { ok: false; status: number; code: string }
> {
  const handleSha256 = await hashPairingHandle(handle);
  const { data, error } = await service.schema("app")
    .from("capture_pairing_tokens")
    .select("*")
    .eq("handle_sha256", handleSha256)
    .maybeSingle();
  if (error) return { ok: false, status: 500, code: "capture_pairing_failed" };
  if (!data) return { ok: false, status: 404, code: "pairing_not_found" };

  const row = data as PairingRow;
  const usability = evaluatePairingUsability({
    state: row.state,
    expiresAt: new Date(row.expires_at),
    redemptionAttempts: row.redemption_attempts,
  });
  if (!usability.ok) {
    return { ok: false, status: 409, code: usability.code };
  }
  return { ok: true, row };
}

/**
 * Re-verifies the LIVE attempt/response-version state, not just the
 * capability. A capability minted 10 minutes ago must not still authorize a
 * write if the attempt has since been submitted or graded -- the capability
 * proves who asked, the attempt proves whether the write is still legal.
 */
async function assertAttemptStillWritable(
  service: Service,
  row: PairingRow,
): Promise<
  | { ok: true; itemId: string }
  | { ok: false; status: number; code: string }
> {
  const [
    { data: attempt, error: attemptError },
    { data: responseVersion, error: responseVersionError },
  ] = await Promise.all([
    service.schema("app").from("attempts")
      .select("id, user_id, status, content_item_version_id")
      .eq("id", row.attempt_id).maybeSingle(),
    service.schema("app").from("response_versions")
      .select("id, attempt_id, is_submitted")
      .eq("id", row.response_version_id).maybeSingle(),
  ]);

  if (attemptError || !attempt) {
    return { ok: false, status: 404, code: "attempt_not_found" };
  }
  // The capability's user must still own the attempt. This cannot normally
  // drift, but checking it means a capability is never the sole authority
  // for whose attempt is being written to.
  if (attempt.user_id !== row.user_id) {
    return { ok: false, status: 403, code: "forbidden" };
  }
  if (attempt.content_item_version_id !== row.content_item_version_id) {
    return { ok: false, status: 409, code: "pairing_binding_mismatch" };
  }
  if (!["draft", "failed"].includes(attempt.status as string)) {
    return { ok: false, status: 409, code: "attempt_not_editable" };
  }
  if (responseVersionError || !responseVersion) {
    return { ok: false, status: 404, code: "response_not_found" };
  }
  if (responseVersion.attempt_id !== row.attempt_id) {
    return { ok: false, status: 409, code: "response_attempt_mismatch" };
  }
  if (responseVersion.is_submitted) {
    return { ok: false, status: 409, code: "response_already_submitted" };
  }
  return { ok: true, itemId: row.content_item_version_id };
}

/** Same storage-fingerprint TOCTOU guard `attach_capture` uses. */
async function storageObjectFingerprint(
  service: Service,
  storagePath: string,
): Promise<string | null> {
  const slashIndex = storagePath.lastIndexOf("/");
  const folder = slashIndex >= 0 ? storagePath.slice(0, slashIndex) : "";
  const fileName = slashIndex >= 0
    ? storagePath.slice(slashIndex + 1)
    : storagePath;
  const { data, error } = await service.storage.from(BUCKET)
    .list(folder, { search: fileName, limit: 100 });
  if (error || !data) return null;
  const entry = data.find((item) => item.name === fileName);
  if (!entry) return null;
  return `${entry.updated_at ?? ""}:${
    entry.metadata?.eTag ?? entry.metadata?.size ?? ""
  }`;
}

function mapBindError(message: string | undefined) {
  const match = typeof message === "string"
    ? message.match(/attach_capture:([a-z_]+)/)
    : null;
  if (!match) return { status: 500, code: "attach_capture_failed" };
  switch (match[1]) {
    case "no_current_original_to_replace":
    case "stale_retake_target":
    case "original_already_current":
    case "derived_cannot_replace":
      return { status: 409, code: `attach_capture_${match[1]}` };
    case "response_not_writable":
      // N7: the DB-level is_submitted/attempt-editable backstop fired (the
      // response was submitted during the edge-function's check-then-bind
      // window). A legitimate refusal, not our bug -> 409/blocked.
      return { status: 409, code: "response_already_submitted" };
    default:
      return { status: 500, code: "attach_capture_failed" };
  }
}

function mapClaimError(message: string | undefined) {
  const match = typeof message === "string"
    ? message.match(/capture_pairing:([a-z_]+)/)
    : null;
  if (!match) return { status: 500, code: "capture_pairing_failed" };
  switch (match[1]) {
    case "not_found":
      return { status: 404, code: "pairing_not_found" };
    case "already_used":
      return { status: 409, code: "pairing_already_used" };
    case "expired":
      return { status: 409, code: "pairing_expired" };
    case "cancelled":
      return { status: 409, code: "pairing_cancelled" };
    case "rejected":
      return { status: 409, code: "pairing_rejected" };
    case "attempts_exhausted":
      return { status: 409, code: "pairing_attempts_exhausted" };
    case "not_consumable":
      return { status: 409, code: "pairing_already_used" };
    default:
      return { status: 500, code: "capture_pairing_failed" };
  }
}

/* -------------------------------------------------------------------------- */
/* Handler                                                                    */
/* -------------------------------------------------------------------------- */

// Seams the handler-level tests inject. All default to the real
// implementations, so production behaviour is unchanged when `deps` is omitted.
export interface CapturePairingDeps {
  service?: Service;
  requireProfile?: typeof requireProfile;
  runQualityCheck?: typeof runCaptureQualityCheck;
}

// Exported so the request-handling logic (auth, operation routing, the
// single-use/quality/consume sequence) can be exercised by index_test.ts with
// a synthetic Request and an injected service client, rather than only through
// its pure helpers. `Deno.serve` wires it up at the bottom of the file.
export async function handleCapturePairing(
  req: Request,
  deps: CapturePairingDeps = {},
): Promise<Response> {
  const authenticate = deps.requireProfile ?? requireProfile;
  const runQuality = deps.runQualityCheck ?? runCaptureQualityCheck;
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") return respond({ ok: true }, { status: 200 });
  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }
  const b = body as Record<string, unknown>;

  const operation = asString(b.operation) as Operation | null;
  const isAuthed = operation !== null &&
    AUTHED_OPERATIONS.has(operation as AuthedOperation);
  const isTokenOp = operation !== null &&
    TOKEN_OPERATIONS.has(operation as TokenOperation);
  if (!operation || (!isAuthed && !isTokenOp)) {
    return respond({ error: "invalid_operation" }, { status: 400 });
  }

  const idempotencyKey = asString(
    b.idempotency_key ?? b.idempotencyKey ?? b.request_id ?? b.requestId,
  ) ?? crypto.randomUUID();

  const service = deps.service ?? createServiceClient();

  try {
    /* ---------------------------------------------------------------- */
    /* Authenticated leg -- the student's own primary device            */
    /* ---------------------------------------------------------------- */
    if (isAuthed) {
      const profileResult = await authenticate(req);
      if (!profileResult) {
        return respond({ error: "unauthorized" }, { status: 401 });
      }
      const { user, profile } = profileResult;
      if (profile.role !== "student" && profile.role !== "admin") {
        return respond({ error: "forbidden" }, { status: 403 });
      }

      if (operation === "mint_pairing") {
        const attemptId = asUuid(b.attempt_id ?? b.attemptId);
        const responseVersionId = asUuid(
          b.response_version_id ?? b.responseVersionId,
        );
        const submissionSlotId = asString(
          b.submission_slot_id ?? b.submissionSlotId,
        ) ?? "slot-1";
        if (!attemptId || !responseVersionId) {
          return respond({
            error: "missing_required_fields",
            required: ["attempt_id", "response_version_id"],
          }, { status: 400 });
        }
        if (submissionSlotId.length > 64) {
          return respond({ error: "invalid_submission_slot" }, { status: 400 });
        }

        const { data: attempt, error: attemptError } = await service
          .schema("app").from("attempts")
          .select(
            "id, user_id, status, content_item_version_id, learning_session_id",
          )
          .eq("id", attemptId).maybeSingle();
        if (attemptError || !attempt) {
          return respond({ error: "attempt_not_found" }, { status: 404 });
        }
        // No admin-on-behalf-of-student bypass, matching attach_capture's
        // own reasoning (TASK-0025 QA 2026-08-17): the storage path this
        // capability will authorize is prefixed with the OWNING user's id,
        // so an admin minting against a student's attempt would produce a
        // capability that writes into that student's namespace. Refuse.
        if (attempt.user_id !== user.id) {
          return respond({ error: "forbidden" }, { status: 403 });
        }
        if (!["draft", "failed"].includes(attempt.status as string)) {
          return respond({
            error: "attempt_not_editable",
            attempt_status: attempt.status,
          }, { status: 409 });
        }

        const { data: responseVersion, error: rvError } = await service
          .schema("app").from("response_versions")
          .select("id, attempt_id, is_submitted")
          .eq("id", responseVersionId).maybeSingle();
        if (rvError || !responseVersion) {
          return respond({ error: "response_not_found" }, { status: 404 });
        }
        if (responseVersion.attempt_id !== attemptId) {
          return respond({ error: "response_attempt_mismatch" }, {
            status: 409,
          });
        }
        if (responseVersion.is_submitted) {
          return respond({ error: "response_already_submitted" }, {
            status: 409,
          });
        }

        // Rate limit (per authenticated user, fixed window).
        const windowStart = new Date(
          Date.now() - PAIRING_MINT_WINDOW_SECONDS * 1000,
        ).toISOString();
        const { count: recentMintCount } = await service.schema("app")
          .from("capture_pairing_tokens")
          .select("id", { count: "exact", head: true })
          .eq("user_id", user.id)
          .gte("created_at", windowStart);
        const rateLimit = evaluateMintRateLimit({
          recentMintCount: recentMintCount ?? 0,
        });
        if (!rateLimit.allowed) {
          await logAuditEvent(service, {
            action: "capture_pairing.mint_rate_limited",
            actorId: user.id,
            actorType: "human",
            objectType: "attempt",
            objectId: attemptId,
            requestId: idempotencyKey,
            reasonCode: "mint_rate_limited",
            metadata: {
              window_seconds: PAIRING_MINT_WINDOW_SECONDS,
              max_per_window: PAIRING_MINT_MAX_PER_WINDOW,
            },
          });
          return respond({
            error: "pairing_rate_limited",
            retry_after_seconds: rateLimit.retryAfterSeconds,
          }, {
            status: 429,
            headers: { "Retry-After": String(rateLimit.retryAfterSeconds) },
          });
        }

        // Close any live capability for this slot first. The partial unique
        // index (one live capability per attempt+slot) would otherwise
        // reject the insert -- and closing it is the correct behaviour
        // anyway: re-minting a QR code must invalidate the old one, or the
        // previous code stays a valid write channel.
        const { data: superseded } = await service.schema("app")
          .from("capture_pairing_tokens")
          .update({ state: "cancelled", closed_at: new Date().toISOString() })
          .eq("attempt_id", attemptId)
          .eq("submission_slot_id", submissionSlotId)
          .in("state", ["issued", "paired", "uploaded"])
          .select("id, generation");
        const nextGeneration = (superseded ?? []).reduce(
          (max, previous) => Math.max(max, Number(previous.generation ?? 1)),
          0,
        ) + 1;

        const handle = generatePairingHandle();
        const handleSha256 = await hashPairingHandle(handle);
        const expiresAt = new Date(Date.now() + PAIRING_TTL_SECONDS * 1000);

        const { data: inserted, error: insertError } = await service
          .schema("app").from("capture_pairing_tokens")
          .insert({
            handle_sha256: handleSha256,
            upload_purpose: "DRAWN_RESPONSE",
            user_id: user.id,
            learning_session_id: attempt.learning_session_id,
            attempt_id: attemptId,
            response_version_id: responseVersionId,
            content_item_version_id: attempt.content_item_version_id,
            submission_slot_id: submissionSlotId,
            generation: nextGeneration,
            state: "issued",
            expires_at: expiresAt.toISOString(),
          })
          .select("*").maybeSingle();
        if (insertError || !inserted) {
          return respond({ error: "pairing_mint_failed" }, { status: 500 });
        }
        const row = inserted as PairingRow;

        await appendProvenanceEvent(service, row, {
          eventType: "SESSION_CREATED",
          actor: "PRIMARY_DEVICE",
          itemId: row.content_item_version_id,
        });
        await logAuditEvent(service, {
          action: "capture_pairing.mint_pairing",
          actorId: user.id,
          actorType: "human",
          objectType: "capture_pairing_token",
          objectId: row.id,
          requestId: idempotencyKey,
          reasonCode: "mint_pairing",
          metadata: {
            // The hash, never the capability.
            handle_sha256: handleSha256,
            attempt_id: attemptId,
            submission_slot_id: submissionSlotId,
            generation: nextGeneration,
            expires_at: expiresAt.toISOString(),
            superseded_count: (superseded ?? []).length,
          },
        });

        return respond({
          status: "ok",
          function: "capture-pairing",
          operation,
          result: {
            pairing_id: row.id,
            // The one and only time the capability is ever returned.
            pairing_handle: handle,
            expires_at: row.expires_at,
            ttl_seconds: PAIRING_TTL_SECONDS,
            pairing: publicPairingView(row),
          },
        });
      }

      // pairing_status / cancel_pairing: both are owner-scoped by
      // `.eq("user_id", user.id)`, so a student cannot poll or cancel
      // another student's capability even with its id.
      const pairingId = asUuid(b.pairing_id ?? b.pairingId);
      if (!pairingId) {
        return respond({
          error: "missing_required_fields",
          required: ["pairing_id"],
        }, { status: 400 });
      }
      const { data: owned, error: ownedError } = await service.schema("app")
        .from("capture_pairing_tokens")
        .select("*")
        .eq("id", pairingId)
        .eq("user_id", user.id)
        .maybeSingle();
      if (ownedError) {
        return respond({ error: "capture_pairing_failed" }, { status: 500 });
      }
      if (!owned) return respond({ error: "pairing_not_found" }, { status: 404 });
      let row = owned as PairingRow;

      if (operation === "pairing_status") {
        // Report expiry truthfully even before the sweep runs, and persist
        // it so the one-live-per-slot index frees up immediately.
        if (
          !["consumed", "expired", "cancelled", "rejected"].includes(row.state) &&
          new Date(row.expires_at).getTime() <= Date.now()
        ) {
          const { data: expired } = await service.schema("app")
            .from("capture_pairing_tokens")
            .update({ state: "expired", closed_at: new Date().toISOString() })
            .eq("id", row.id)
            .in("state", ["issued", "paired", "uploaded"])
            .select("*").maybeSingle();
          if (expired) {
            row = expired as PairingRow;
            await appendProvenanceEvent(service, row, {
              eventType: "SESSION_EXPIRED",
              actor: "SYSTEM",
              itemId: row.content_item_version_id,
              reason: "PAIRING_EXPIRED",
            });
          }
        }
        // Short-lived signed read URL so the primary device can show a
        // thumbnail of the preserved original. Signed here, server-side,
        // for two reasons: the bucket is private and must stay private, and
        // the owning row was just fetched with `.eq("user_id", user.id)` --
        // so producing the URL here IS the ownership check, and no client
        // ever needs read access to app.response_attachments.
        let previewUrl: string | null = null;
        if (row.bound_attachment_id) {
          const { data: attachment } = await service.schema("app")
            .from("response_attachments")
            .select("storage_path")
            .eq("id", row.bound_attachment_id)
            .maybeSingle();
          if (attachment?.storage_path) {
            const { data: signed } = await service.storage.from(BUCKET)
              .createSignedUrl(attachment.storage_path as string, 120);
            previewUrl = signed?.signedUrl ?? null;
          }
        }

        return respond({
          status: "ok",
          function: "capture-pairing",
          operation,
          result: {
            pairing_id: row.id,
            pairing: publicPairingView(row),
            attachment_id: row.bound_attachment_id,
            attachment_preview_url: previewUrl,
            attachment_preview_expires_in: previewUrl ? 120 : null,
          },
        });
      }

      // cancel_pairing
      const { data: cancelled } = await service.schema("app")
        .from("capture_pairing_tokens")
        .update({ state: "cancelled", closed_at: new Date().toISOString() })
        .eq("id", row.id)
        .in("state", ["issued", "paired", "uploaded"])
        .select("*").maybeSingle();
      if (cancelled) {
        row = cancelled as PairingRow;
        await appendProvenanceEvent(service, row, {
          eventType: "SESSION_CANCELLED",
          actor: "LEARNER",
          itemId: row.content_item_version_id,
          reason: "USER_CANCELLED",
        });
      }
      return respond({
        status: "ok",
        function: "capture-pairing",
        operation,
        result: { pairing_id: row.id, pairing: publicPairingView(row) },
      });
    }

    /* ---------------------------------------------------------------- */
    /* Token leg -- the phone, no JWT                                    */
    /* ---------------------------------------------------------------- */
    const handle = b.pairing_handle ?? b.pairingHandle ?? b.handle ?? b.token;
    if (!isWellFormedPairingHandle(handle)) {
      return respond({ error: "invalid_pairing_handle" }, { status: 400 });
    }

    if (operation === "describe_capture") {
      const loaded = await loadCapability(service, handle);
      if (!loaded.ok) {
        return respond({ error: loaded.code }, { status: loaded.status });
      }
      // Reading the capability does not consume an attempt, so a phone that
      // reloads its page mid-capture is not punished for it.
      let describeRow = loaded.row;
      // "Phone connected" detection. Opening the capture page IS the pairing
      // moment, so advance 'issued' -> 'paired' here rather than waiting for the
      // first upload (create_capture_upload). Without this the primary device
      // showed "Waiting for your phone" for the entire time the student framed
      // the shot. Idempotent and attempt-free: only 'issued' advances, and a
      // reload while already 'paired' is a no-op.
      if (describeRow.state === "issued") {
        const { data: paired } = await service.schema("app")
          .from("capture_pairing_tokens")
          .update({
            state: "paired",
            paired_at: new Date().toISOString(),
            access_path: describeRow.access_path ?? "QR",
          })
          .eq("id", describeRow.id)
          .eq("state", "issued")
          .select("*").maybeSingle();
        if (paired) {
          describeRow = paired as PairingRow;
          await appendProvenanceEvent(service, describeRow, {
            eventType: "PAIRING_ACCEPTED",
            actor: "CAPTURE_DEVICE",
            itemId: describeRow.content_item_version_id,
          });
        }
      }
      return respond({
        status: "ok",
        function: "capture-pairing",
        operation,
        result: {
          pairing: publicPairingView(describeRow),
          accepted_media_types: ["image/jpeg", "image/png", "image/webp"],
          guidance: {
            // Static capture coaching, shown before any photo exists.
            steps: [
              "Lay the page flat on a plain surface.",
              "Avoid glare and shadows — even, indirect light works best.",
              "Fit the whole page in the frame, with a small margin.",
              "Hold steady and let the camera focus before you shoot.",
            ],
          },
        },
      });
    }

    if (operation === "create_capture_upload") {
      const declaredMediaType = asString(b.media_type ?? b.mediaType);
      if (
        declaredMediaType !== null &&
        !["image/jpeg", "image/png", "image/webp"].includes(declaredMediaType)
      ) {
        return respond({ error: "unsupported_media_type" }, { status: 415 });
      }
      const accessPathRaw = b.access_path ?? b.accessPath;
      const accessPath = isPairingAccessPath(accessPathRaw)
        ? accessPathRaw
        : "QR";

      // Atomic: validates state/expiry/attempt budget under a row lock and
      // consumes one attempt. This is the authoritative rate-limit and
      // replay check for the phone leg.
      const handleSha256 = await hashPairingHandle(handle);
      const { data: claimed, error: claimError } = await service.schema("app")
        .rpc("claim_capture_pairing_upload", {
          p_handle_sha256: handleSha256,
          p_max_attempts: PAIRING_MAX_REDEMPTION_ATTEMPTS,
          p_access_path: accessPath,
        }).single<PairingRow>();
      if (claimError || !claimed) {
        const mapped = mapClaimError(claimError?.message);
        return respond({ error: mapped.code }, { status: mapped.status });
      }
      const row = claimed;
      // A capability that expired or exhausted its attempts ON this call now
      // commits that terminal state and is RETURNED (not raised), so the
      // bookkeeping survives. Detect it by the returned state.
      if (row.state === "expired") {
        return respond({ error: "pairing_expired" }, { status: 409 });
      }
      if (row.state === "rejected") {
        return respond({ error: "pairing_attempts_exhausted" }, { status: 409 });
      }

      const writable = await assertAttemptStillWritable(service, row);
      if (!writable.ok) {
        return respond({ error: writable.code }, { status: writable.status });
      }

      const extension: CaptureExtension = declaredMediaType
        ? extensionForMediaType(
          declaredMediaType as "image/png" | "image/jpeg" | "image/webp",
        )
        : "jpg";
      const storagePath = buildOriginalCapturePath({
        userId: row.user_id,
        pairingId: row.id,
        attempt: row.redemption_attempts,
        extension,
      });
      // Belt and braces: the path is server-constructed, but run it through
      // the same checks the authenticated path applies to a client-supplied
      // one, so a future change to the builder cannot quietly produce a
      // path that escapes the owner's namespace.
      if (
        !isSafeStoragePath(storagePath) ||
        !ownsLearnerPath(row.user_id, storagePath)
      ) {
        return respond({ error: "invalid_storage_path" }, { status: 500 });
      }

      const { data: signed, error: signError } = await service.storage
        .from(BUCKET).createSignedUploadUrl(storagePath);
      if (signError || !signed?.signedUrl || !signed?.token) {
        const incidentId = await logAuditEvent(service, {
          action: "capture_pairing.upload_sign_failed",
          actorId: row.user_id,
          actorType: "system",
          objectType: "capture_pairing_token",
          objectId: row.id,
          requestId: idempotencyKey,
          reasonCode: "technical_failure",
          metadata: {
            stage: "sign_upload",
            detail: signError?.message?.slice(0, 300) ?? "sign_upload_failed",
          },
        });
        await markTokenTechnicalFailure(service, row.id);
        return respond({
          error: "capture_upload_unavailable",
          failure_class: "technical" satisfies CaptureFailureClass,
          incident_id: incidentId,
          message: TECHNICAL_FAILURE_GUIDANCE,
        }, { status: 502 });
      }

      // No provenance event here. "Phone connected" is PAIRING_ACCEPTED, now
      // emitted by describe_capture when the phone opens the page; the actual
      // capture is recorded at submit (CAPTURE_RECORDED / SUBMISSION_ACCEPTED).
      // Issuing an upload URL is neither, so it gets no event rather than a
      // mislabelled one.

      return respond({
        status: "ok",
        function: "capture-pairing",
        operation,
        result: {
          storage_path: storagePath,
          signed_url: signed.signedUrl,
          upload_token: signed.token,
          pairing: publicPairingView(row),
        },
      });
    }

    /* -------------------------- submit_capture ----------------------- */
    const declaredStoragePath = asString(b.storage_path ?? b.storagePath);
    const declaredMediaType = asString(b.media_type ?? b.mediaType);
    const declaredSha256 = asString(b.sha256_digest ?? b.sha256Digest);
    const explicitConfirmation = b.explicit_confirmation === true ||
      b.explicitConfirmation === true;
    const replacesAttachmentId = asUuid(
      b.replaces_attachment_id ?? b.replacesAttachmentId,
    );

    if (!declaredStoragePath) {
      return respond({
        error: "missing_required_fields",
        required: ["storage_path"],
      }, { status: 400 });
    }
    // Stage D2 requirement 5: the learner "explicitly submits". A submit
    // without that explicit confirmation is refused rather than inferred.
    if (!explicitConfirmation) {
      return respond({ error: "explicit_confirmation_required" }, {
        status: 400,
      });
    }

    const loaded = await loadCapability(service, handle);
    if (!loaded.ok) {
      return respond({ error: loaded.code }, { status: loaded.status });
    }
    const row = loaded.row;

    // Echoed binding fields, if the client sent any, must match exactly.
    const bindingCheck = checkPurposeBinding({
      binding: bindingOf(row),
      declared: {
        attempt_id: asUuid(b.attempt_id ?? b.attemptId),
        response_version_id: asUuid(
          b.response_version_id ?? b.responseVersionId,
        ),
        content_item_version_id: asUuid(
          b.content_item_version_id ?? b.contentItemVersionId,
        ),
        submission_slot_id: asString(b.submission_slot_id ?? b.submissionSlotId),
      },
    });
    if (!bindingCheck.ok) {
      return respond({ error: bindingCheck.code }, { status: 409 });
    }

    // A capability may only submit an object inside its OWN folder. This is
    // the check that makes wrong-slot / cross-capability submission
    // impossible even though the phone supplies the path: the folder name is
    // the capability's own id, which a holder of a different capability
    // cannot produce.
    const expectedPrefix = `${row.user_id}/captures/${row.id}/`;
    if (
      !isSafeStoragePath(declaredStoragePath) ||
      !ownsLearnerPath(row.user_id, declaredStoragePath) ||
      !declaredStoragePath.startsWith(expectedPrefix) ||
      !declaredStoragePath.slice(expectedPrefix.length).startsWith("original-")
    ) {
      return respond({ error: "invalid_storage_path" }, { status: 400 });
    }

    // Idempotent replay of an already-processed upload. This exact object was
    // already validated, bound, quality-checked, and recorded against this
    // capability, so re-binding it or spending another paid quality call on it
    // is pure waste -- and, left unguarded, a loop of re-POSTing the same path
    // is an unbounded paid-call channel. A genuine retake uses a NEW object
    // path (create_capture_upload increments the attempt and rebuilds the
    // path), so it does not match here and is processed fresh. Bounded overall
    // by the redemption budget, which caps the number of distinct valid paths.
    if (
      row.bound_attachment_id &&
      row.upload_storage_path === declaredStoragePath
    ) {
      return respond({
        status: "ok",
        function: "capture-pairing",
        operation,
        result: {
          attachment_id: row.bound_attachment_id,
          derived_attachment_id: null,
          capture_quality_state: row.capture_quality_state,
          failure_class: row.failure_class,
          retake_guidance: row.failure_class === "image_quality"
            ? GENERIC_RETAKE_GUIDANCE
            : null,
          technical_message: row.failure_class === "technical"
            ? TECHNICAL_FAILURE_GUIDANCE
            : null,
          // The original incident (if any) was logged on the first submit;
          // a replay does not mint a new one.
          incident_id: null,
          pairing: publicPairingView(row),
        },
      });
    }

    const writable = await assertAttemptStillWritable(service, row);
    if (!writable.ok) {
      return respond({ error: writable.code }, { status: writable.status });
    }

    const { data: downloaded, error: downloadError } = await service.storage
      .from(BUCKET).download(declaredStoragePath);
    if (downloadError || !downloaded) {
      return respond({ error: "capture_object_not_found" }, { status: 404 });
    }
    const bytes = new Uint8Array(await downloaded.arrayBuffer());

    // Identical validation to attach_capture -- same shared function, so
    // signature/decode/size/dimension rules and the never-trust-the-client
    // digest/media-type rederivation cannot drift between the two paths.
    const validation = await validateCaptureObject({
      bytes,
      declaredMediaType,
      declaredSha256,
    });
    if (!validation.ok) {
      await appendProvenanceEvent(service, row, {
        eventType: "SUBMISSION_REJECTED",
        actor: "SYSTEM",
        itemId: writable.itemId,
        reason: "UNREADABLE",
      });
      // A malformed/oversized/mistyped object is a BLOCKED failure: not a
      // photo-quality judgement (we never got far enough to judge it) and
      // not our bug either.
      return respond({
        error: validation.reason,
        failure_class: "blocked" satisfies CaptureFailureClass,
      }, { status: 422 });
    }

    const fingerprintAtRead = await storageObjectFingerprint(
      service,
      declaredStoragePath,
    );

    // Fast-fail an obviously invalid retake before the DB write. Not relied
    // on for correctness: bind_response_attachment re-derives and enforces
    // the same rules atomically under a row lock.
    const { data: priorCurrent, error: priorCurrentError } = await service
      .schema("app").from("response_attachments")
      .select("id")
      .eq("response_version_id", row.response_version_id)
      .eq("kind", "original").eq("is_current", true).maybeSingle();
    if (priorCurrentError) {
      return respond({ error: "attach_capture_failed" }, { status: 500 });
    }
    // A retake through this bridge supersedes whatever original is current
    // now. The client may name it explicitly; if it does not, we resolve it
    // server-side rather than failing a legitimate retake on a missing
    // field the phone has no way to know.
    //
    // Auto-resolving to "the response version's current original" is
    // unambiguous ONLY because each submission slot maps to its own response
    // version today (one 'slot-1' per response version, and the
    // one-current-original index guarantees at most one current original per
    // response version). If a multi-slot-per-response-version model is ever
    // introduced, "the current original" would span slots and a silent
    // auto-supersede could hide a DIFFERENT slot's page. Fail closed for that
    // future: a non-default slot must name its target explicitly.
    if (
      !replacesAttachmentId && priorCurrent?.id &&
      row.submission_slot_id !== "slot-1"
    ) {
      return respond({
        error: "attach_capture_ambiguous_supersede_target",
        failure_class: "blocked" satisfies CaptureFailureClass,
      }, { status: 409 });
    }
    const supersedes = replacesAttachmentId ?? priorCurrent?.id ?? null;
    try {
      planAttachmentInsert({
        kind: "original",
        priorCurrentOriginalId: priorCurrent?.id ?? null,
        replacesAttachmentId: supersedes,
      });
    } catch (planError) {
      const message = planError instanceof Error
        ? planError.message
        : "attach_capture:invalid_retake";
      return respond({
        error: `attach_capture_${message.split(":").pop()}`,
        failure_class: "blocked" satisfies CaptureFailureClass,
      }, { status: 409 });
    }

    const fingerprintBeforeBind = await storageObjectFingerprint(
      service,
      declaredStoragePath,
    );
    if (
      fingerprintAtRead === null ||
      fingerprintBeforeBind !== fingerprintAtRead
    ) {
      return respond({
        error: "capture_object_changed",
        failure_class: "blocked" satisfies CaptureFailureClass,
      }, { status: 409 });
    }

    const { data: bound, error: bindError } = await service.schema("app")
      .rpc("bind_response_attachment", {
        p_response_version_id: row.response_version_id,
        p_attempt_id: row.attempt_id,
        p_content_item_version_id: row.content_item_version_id,
        p_kind: "original",
        p_replaces_attachment_id: supersedes,
        p_storage_path: declaredStoragePath,
        p_media_type: validation.mediaType,
        p_byte_size: validation.byteSize,
        p_pixel_width: validation.width,
        p_pixel_height: validation.height,
        p_sha256_digest: validation.sha256,
        // Attributed to the OWNING student, resolved from the capability --
        // never to a service identity, so the audit trail says who captured
        // it, not which function wrote it.
        p_captured_by: row.user_id,
      }).single<{ id: string; capture_quality_state: string }>();
    if (bindError || !bound) {
      const mapped = mapBindError(bindError?.message);
      const incidentId = await logAuditEvent(service, {
        action: "capture_pairing.bind_failed",
        actorId: row.user_id,
        actorType: "system",
        objectType: "capture_pairing_token",
        objectId: row.id,
        requestId: idempotencyKey,
        reasonCode: "technical_failure",
        metadata: {
          stage: "bind_response_attachment",
          detail: bindError?.message?.slice(0, 300) ?? "bind_failed",
        },
      });
      // Persist the technical classification on the token for a genuine bug
      // (500), so the desktop can render the technical screen too (N6). A 409 is
      // a legitimate lineage/writability refusal, not a technical failure.
      if (mapped.status !== 409) {
        await markTokenTechnicalFailure(service, row.id);
      }
      return respond({
        error: mapped.code,
        // A 409 here is a legitimate refusal (lineage conflict); a 500 is
        // our bug. Classify accordingly so the frontend routes correctly.
        failure_class: (mapped.status === 409
          ? "blocked"
          : "technical") satisfies CaptureFailureClass,
        incident_id: mapped.status === 409 ? undefined : incidentId,
      }, { status: mapped.status });
    }

    // Capture-quality check runs AFTER the bind, not before. The bind is the
    // point of no return -- and the point after which a repeat submit of the
    // same object short-circuits as a replay above -- so gating the paid model
    // call on a successful bind means a pre-bind failure (a bogus retake
    // target, a changed object, a lineage conflict) can never drive a paid
    // call. The check only annotates the already-preserved attachment; it never
    // blocks preservation.
    const qualityRequestId =
      `capture_quality:${row.id}:${row.redemption_attempts}`;
    const qualityOutcome: CaptureQualityOutcome = await runQuality({
      bytes,
      mediaType: validation.mediaType,
      apiKey: CAPTURE_QUALITY_API_KEY,
      modelId: CAPTURE_QUALITY_MODEL,
      timeoutMs: CAPTURE_QUALITY_TIMEOUT_MS,
      reserveCost: async () => {
        if (CAPTURE_QUALITY_DAILY_CAP_USD <= 0) return false;
        const { data } = await service.schema("app").rpc(
          "reserve_model_usage",
          {
            p_request_id: qualityRequestId,
            p_request_hash: validation.sha256,
            p_model_id: CAPTURE_QUALITY_MODEL,
            p_reserved_cost_usd: CAPTURE_QUALITY_RESERVED_COST_USD,
            p_cap_usd: CAPTURE_QUALITY_DAILY_CAP_USD,
          },
        );
        return Boolean(data);
      },
    });
    // Release the reservation on every path where one was actually taken.
    // `unavailable` means reserveCost returned false (cap unset or reached) --
    // no ledger row exists, nothing to complete. `assessed` and
    // `technical_failure` both mean the model was called under a reservation,
    // which MUST be reconciled or it leaks against the SHARED daily cap and
    // eventually makes evaluate-attempt falsely reject unrelated students.
    // (evaluate-attempt releases the same way, in a finally.) Best-effort: a
    // completion failure must not fail an upload that already bound.
    if (qualityOutcome.kind !== "unavailable") {
      const { error: completeError } = await service.schema("app").rpc(
        "complete_model_usage",
        {
          p_request_id: qualityRequestId,
          p_request_hash: validation.sha256,
          p_status: "completed",
          p_actual_cost_usd: CAPTURE_QUALITY_RESERVED_COST_USD,
          p_input_tokens: null,
          p_output_tokens: null,
        },
      );
      if (completeError) {
        console.error(
          "capture_pairing_reservation_release_failed",
          completeError.message,
        );
      }
    }

    /* ---- Derived, metadata-stripped copy (never overwrites the raw) ---- */
    // The original above is bound first and left byte-for-byte untouched,
    // including its EXIF: Stage D2 requires the immutable original be
    // preserved AND that derived/downstream images be stripped. The strip
    // therefore produces a SEPARATE object at a SEPARATE path bound as a
    // SEPARATE `derived` attachment. A failure here is logged and does not
    // fail the submission -- the gradeable original is already safe.
    let derivedAttachmentId: string | null = null;
    let metadataSummary: Record<string, unknown> | null = null;
    try {
      const strip = stripImageMetadata(bytes, validation.mediaType);
      metadataSummary = summarizeMetadataStrip(strip);
      if (strip.changed) {
        const derivedPath = buildDerivedCapturePath({
          userId: row.user_id,
          pairingId: row.id,
          attempt: row.redemption_attempts,
          extension: extensionForMediaType(validation.mediaType),
        });
        const { error: uploadError } = await service.storage.from(BUCKET)
          .upload(derivedPath, strip.bytes, {
            contentType: validation.mediaType,
            upsert: false,
          });
        if (uploadError) throw new Error(uploadError.message);
        const derivedValidation = await validateCaptureObject({
          bytes: strip.bytes,
          declaredMediaType: validation.mediaType,
        });
        if (!derivedValidation.ok) {
          // The strip produced something we cannot re-validate. Do not bind
          // it -- an unvalidatable derivative is worse than none.
          throw new Error(`derived_${derivedValidation.reason}`);
        }
        const { data: derived, error: derivedError } = await service
          .schema("app").rpc("bind_response_attachment", {
            p_response_version_id: row.response_version_id,
            p_attempt_id: row.attempt_id,
            p_content_item_version_id: row.content_item_version_id,
            p_kind: "derived",
            p_replaces_attachment_id: null,
            p_storage_path: derivedPath,
            p_media_type: derivedValidation.mediaType,
            p_byte_size: derivedValidation.byteSize,
            p_pixel_width: derivedValidation.width,
            p_pixel_height: derivedValidation.height,
            p_sha256_digest: derivedValidation.sha256,
            p_captured_by: row.user_id,
          }).single<{ id: string }>();
        if (derivedError || !derived) {
          throw new Error(derivedError?.message ?? "derived_bind_failed");
        }
        derivedAttachmentId = derived.id;
      }
    } catch (error) {
      await logAuditEvent(service, {
        action: "capture_pairing.derive_failed",
        actorId: row.user_id,
        actorType: "system",
        objectType: "response_attachment",
        objectId: bound.id,
        requestId: idempotencyKey,
        reasonCode: "technical_failure",
        metadata: {
          stage: "strip_metadata",
          detail: error instanceof Error
            ? error.message.slice(0, 300)
            : "derive_failed",
        },
      });
    }

    /* ---- Record the quality verdict on the attachment ---- */
    // captureQualityState (and, below, keepOpen) is derived from the VERDICT,
    // not from whether the best-effort response_attachments annotation write
    // succeeds (N2). The prior version only advanced it `if (!updateError)`, so
    // a failed annotation write silently reverted a retake-eligible capture to
    // consume-on-first-submit -- reinstating the F1 dead end while
    // failure_class still said 'image_quality'. The token's own
    // capture_quality_state is written authoritatively by the finalise RPC
    // below from this value regardless of the annotation write.
    let captureQualityState: string = bound.capture_quality_state; // 'pending'
    if (qualityOutcome.kind === "assessed") {
      captureQualityState = qualityOutcome.captureQualityState;
    } else if (qualityOutcome.kind === "technical_failure") {
      captureQualityState = "indeterminate";
    }
    let failureClass: CaptureFailureClass | null = null;
    let studentMessage: string | null = null;
    let incidentId: string | null = null;

    if (qualityOutcome.kind === "assessed") {
      // capture_quality_state is one of the three columns the immutability
      // trigger permits changing after insert -- this is a normal in-place
      // update, not a rewrite of an immutable row. Best-effort: keepOpen and the
      // finalise write no longer depend on it succeeding.
      await service.schema("app")
        .from("response_attachments")
        .update({ capture_quality_state: qualityOutcome.captureQualityState })
        .eq("id", bound.id);
      if (qualityOutcome.disposition === "RETAKE") {
        // DECISION-0051: image-quality failure -> generic retake guidance.
        // The specific failing labels are audited below but deliberately
        // NOT sent to the student.
        failureClass = "image_quality";
        studentMessage = GENERIC_RETAKE_GUIDANCE;
      }
      // disposition === "HUMAN_REVIEW" -> capture_quality_state 'indeterminate'
      // with failure_class left null: the photo was preserved and MIGHT be
      // fine (an uncertain label, or a possible incidental identifier), so it
      // is neither blamed on the student as a bad photo (image_quality) nor
      // logged as our bug (technical). The primary device shows a blameless
      // "we couldn't check this -- continue or retake" screen, kept distinct
      // from the 'technical' screen precisely because failure_class differs.
      await appendProvenanceEvent(service, row, {
        eventType: "QUALITY_RECORDED",
        actor: "SYSTEM",
        itemId: writable.itemId,
        imageId: bound.id,
        qualityStatus: mapDispositionToProvenanceQualityStatus(
          qualityOutcome.disposition,
        ),
      });
      await logAuditEvent(service, {
        action: "capture_pairing.capture_quality_assessed",
        actorId: row.user_id,
        actorType: "system",
        objectType: "response_attachment",
        objectId: bound.id,
        requestId: idempotencyKey,
        reasonCode: "capture_quality_assessed",
        metadata: {
          // Conforming capture_quality_result.v1 record.
          capture_quality_result: toCaptureQualityResultV1(qualityOutcome, {
            sourceImageId: bound.id,
            itemId: writable.itemId,
            responseId: row.response_version_id,
            captureReviewerId: `model:${qualityOutcome.modelId}`,
            timestamp: new Date(),
          }),
          latency_ms: qualityOutcome.latencyMs,
          metadata_strip: metadataSummary,
        },
      });
    } else if (qualityOutcome.kind === "technical_failure") {
      // DECISION-0051: technical failure -> log a bug, and make it
      // distinguishable from an image-quality failure so the frontend
      // routes it to bug reporting instead of a retake prompt.
      failureClass = "technical";
      studentMessage = TECHNICAL_FAILURE_GUIDANCE;
      incidentId = await logAuditEvent(service, {
        action: "capture_pairing.capture_quality_technical_failure",
        actorId: row.user_id,
        actorType: "system",
        objectType: "response_attachment",
        objectId: bound.id,
        requestId: idempotencyKey,
        reasonCode: "technical_failure",
        metadata: {
          stage: "capture_quality_check",
          failure: qualityOutcome.failure,
          detail: qualityOutcome.detail,
          model_id: qualityOutcome.modelId,
          latency_ms: qualityOutcome.latencyMs,
          metadata_strip: metadataSummary,
        },
      });
      // 'indeterminate' is the honest state: the photo was preserved and
      // nothing is known about its quality. Best-effort annotation (see N2).
      await service.schema("app")
        .from("response_attachments")
        .update({ capture_quality_state: "indeterminate" })
        .eq("id", bound.id);
    } else {
      // qualityOutcome.kind === "unavailable": the check did not run (no key,
      // or the daily cap is unset/exhausted). No verdict means no basis to
      // prompt a retake, so the photo is accepted as-is (keepOpen stays false)
      // -- the same behaviour as attach_capture's best-effort quality slot.
      //
      // N11: this is now LOAD-BEARING for F1 (with no verdict there is no
      // retake flow), and `OPENAI_DAILY_CAP_USD` unset silently disables it, so
      // flag it in the audit log. A key present with no daily cap is a deploy
      // misconfiguration (should be rare and loud); an actual cap-hit is an
      // expected transient. Both are recorded so the checker silently not
      // running is visible rather than invisible.
      await logAuditEvent(service, {
        action: "capture_pairing.capture_quality_unavailable",
        actorId: row.user_id,
        actorType: "system",
        objectType: "response_attachment",
        objectId: bound.id,
        requestId: idempotencyKey,
        reasonCode: "capture_quality_unavailable",
        metadata: {
          stage: "capture_quality_check",
          failure: qualityOutcome.failure,
          misconfigured: CAPTURE_QUALITY_API_KEY !== null &&
            CAPTURE_QUALITY_DAILY_CAP_USD <= 0,
        },
      });
    }

    /* ---- Finalise: consume a clean capture, or keep it open for retake ---- */
    // A retake-eligible outcome (the photo failed the quality check, or could
    // not be judged) must NOT consume the capability. The blurry-photo dead end
    // DECISION-0051 exists to prevent came from consuming unconditionally: once
    // consumed, a retake against the same QR hit "link already used" with no
    // way forward, and PAIRING_MAX_REDEMPTION_ATTEMPTS was unreachable. So a
    // retake-eligible capture is RECORDED (bound attachment + verdict kept,
    // capability left live in 'uploaded'), and only a clean/accepted capture is
    // consumed. In both cases the response version's is_submitted guard
    // (assertAttemptStillWritable) is what ultimately stops a write after the
    // desktop commits the answer, so leaving a capability open is safe.
    const keepOpen = captureQualityState === "retake_required" ||
      captureQualityState === "indeterminate";
    const finaliseRpc = keepOpen
      ? "record_capture_upload"
      : "consume_capture_pairing";
    const { data: finalised, error: finaliseError } = await service
      .schema("app").rpc(finaliseRpc, {
        p_pairing_id: row.id,
        p_attachment_id: bound.id,
        p_capture_quality_state: captureQualityState,
        p_failure_class: failureClass,
        p_storage_path: declaredStoragePath,
      }).single<PairingRow>();
    if (finaliseError || !finalised) {
      // The finalize compare-and-set matched no live row: the capability went
      // terminal between the bind and now -- a desktop "Cancel pairing" (or an
      // expiry) racing this submit. Re-read the token and report the ACCURATE
      // reason (cancelled / expired / attempts-exhausted / already-used) rather
      // than a blanket "already used" or, worse, an unmapped 500 the frontend
      // can't classify. The attachment we just bound is the student's own
      // current original on an as-yet-unsubmitted response version; it is
      // superseded by the next successful capture and gated by is_submitted, so
      // it cannot reach grading on its own -- it is left in place rather than
      // force-unbound (response_attachments are immutable by design).
      const { data: current } = await service.schema("app")
        .from("capture_pairing_tokens")
        .select("state, expires_at, redemption_attempts")
        .eq("id", row.id).maybeSingle();
      const usability = current
        ? evaluatePairingUsability({
          state: current.state as PairingState,
          expiresAt: new Date(current.expires_at as string),
          redemptionAttempts: current.redemption_attempts as number,
        })
        : null;
      const code = usability && !usability.ok
        ? usability.code
        : "pairing_already_used";
      await logAuditEvent(service, {
        action: "capture_pairing.finalize_lost_race",
        actorId: row.user_id,
        actorType: "system",
        objectType: "capture_pairing_token",
        objectId: row.id,
        requestId: idempotencyKey,
        reasonCode: "finalize_lost_race",
        metadata: {
          bound_attachment_id: bound.id,
          resolved_code: code,
          finalise_error: finaliseError?.message ?? "no_row",
        },
      });
      return respond({
        error: code,
        failure_class: "blocked" satisfies CaptureFailureClass,
      }, { status: 409 });
    }

    await appendProvenanceEvent(service, finalised, {
      // A recorded-but-not-consumed capture is CAPTURE_RECORDED, not
      // SUBMISSION_ACCEPTED: the student may still retake it.
      eventType: keepOpen ? "CAPTURE_RECORDED" : "SUBMISSION_ACCEPTED",
      actor: "LEARNER",
      itemId: writable.itemId,
      imageId: bound.id,
      replacesImageId: supersedes,
      explicitConfirmation: true,
      qualityStatus: qualityOutcome.kind === "assessed"
        ? mapDispositionToProvenanceQualityStatus(qualityOutcome.disposition)
        : null,
    });
    await logAuditEvent(service, {
      action: "capture_pairing.submit_capture",
      actorId: row.user_id,
      actorType: "human",
      objectType: "response_attachment",
      objectId: bound.id,
      requestId: idempotencyKey,
      reasonCode: "submit_capture",
      metadata: {
        pairing_id: row.id,
        storage_path: declaredStoragePath,
        sha256_digest: validation.sha256,
        byte_size: validation.byteSize,
        media_type: validation.mediaType,
        derived_attachment_id: derivedAttachmentId,
        metadata_strip: metadataSummary,
        capture_quality_state: captureQualityState,
        quality_outcome_kind: qualityOutcome.kind,
        failure_class: failureClass,
        finalised_state: finalised.state,
      },
    });

    return respond({
      status: "ok",
      function: "capture-pairing",
      operation,
      result: {
        attachment_id: bound.id,
        derived_attachment_id: derivedAttachmentId,
        capture_quality_state: captureQualityState,
        // The DECISION-0051 split, on the wire. `failure_class` is null on
        // a clean accept; "image_quality" means show generic retake copy;
        // "technical" means report a bug and do not blame the student.
        failure_class: failureClass,
        retake_guidance: failureClass === "image_quality" ? studentMessage : null,
        technical_message: failureClass === "technical" ? studentMessage : null,
        incident_id: incidentId,
        pairing: publicPairingView(finalised),
      },
    });
  } catch (error) {
    console.error("capture_pairing_failed", error);
    return respond({
      status: "failed",
      function: "capture-pairing",
      operation,
      error: "capture_pairing_failed",
      failure_class: "technical" satisfies CaptureFailureClass,
    }, { status: 500 });
  }
}

Deno.serve((req) => handleCapturePairing(req));
