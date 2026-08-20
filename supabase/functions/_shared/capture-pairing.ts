// Pairing-capability logic for the Engine 4 QR capture MVP
// (TASK-0016 Phase D, Stage D2; DECISION-0051).
//
// WHY THIS EXISTS
// ---------------
// DECISION-0051 confirmed QR handoff as Engine 4's sole capture path and
// directed that System A's frontend be rewired onto System B's working
// `attach_capture` / `app.response_attachments` backend rather than
// recreating the (now non-existent) `capture_sessions` table and
// `capture-research` bucket. The one real engineering gap that decision
// names is this: the phone leg is unauthenticated (it only ever holds a
// pairing link), but every existing write path -- `attempt-response`'s
// `attach_capture` and `storage-sign-url`'s `sign_upload` -- requires an
// authenticated Supabase caller and validates ownership against
// `auth.uid()`.
//
// This module is the trust boundary for the bridge. It holds only pure
// functions (no Supabase client, no Deno.serve, no fetch) so the security-
// relevant decisions -- is this capability still usable, does it authorize
// exactly this attempt/slot, has it already been redeemed, is this caller
// being rate limited -- are unit testable without booting a function or
// touching a database.
//
// SECURITY MODEL (Phase D prompt, "Stage D2 -- Security requirements")
// -------------------------------------------------------------------
// * The capability is 32 bytes of CSPRNG output, base64url-encoded. It
//   carries NO payload: no user id, no email, no attempt id, nothing
//   decodable. Every binding fact is resolved server-side from the row the
//   capability's hash indexes. There is therefore no readable learner PII in
//   the capability, and no way for a holder to name a different record.
// * Only the SHA-256 of the capability is persisted (`handle_sha256`),
//   mirroring `pairing_submission_provenance_event.v1`'s `pairing.
//   handle_sha256` field. A database read cannot recover a live capability.
// * Purpose binding is checked, not assumed: the row pins user, learning
//   session, attempt, response version, content item version, submission
//   slot, and `upload_purpose = 'DRAWN_RESPONSE'`.
// * Single use: redemption is a compare-and-set on `state`, so a replayed
//   submit loses the race and is rejected rather than binding twice.
// * Short lived: `PAIRING_TTL_SECONDS`, evaluated server-side against the
//   stored `expires_at` (never against a client-supplied clock).
//
// The event vocabulary and state names below deliberately mirror the Stage
// D1 frozen contract `schemas/pairing_submission_provenance_event.v1.schema.json`
// so the audit stream this produces is contract-shaped rather than a
// parallel invention.

/** Opaque capability prefix. Purely cosmetic -- aids log triage, carries no data. */
export const PAIRING_HANDLE_PREFIX = "cap_";

/**
 * 15 minutes. Long enough to walk to a desk, unlock a phone, scan, frame a
 * sheet of paper and retake once; short enough that a QR code photographed
 * off someone's screen is stale before it is useful. Retakes extend nothing
 * -- they reuse the same capability inside the same window (see
 * `PAIRING_MAX_REDEMPTION_ATTEMPTS`).
 */
export const PAIRING_TTL_SECONDS = 15 * 60;

/**
 * Upload/quality attempts permitted against ONE capability. Deliberately
 * more than one: a student whose first photo is blurry must be able to
 * retake without the primary device having to mint a new QR code (that
 * would be a materially worse UX and would also mean the frontend needs a
 * re-pair flow on the commonest failure). Deliberately bounded: without a
 * cap, one capability is an unlimited upload channel.
 */
export const PAIRING_MAX_REDEMPTION_ATTEMPTS = 5;

/** Rate limit on MINTING, per authenticated user, per rolling window. */
export const PAIRING_MINT_WINDOW_SECONDS = 10 * 60;
export const PAIRING_MINT_MAX_PER_WINDOW = 12;

export const PAIRING_UPLOAD_PURPOSE = "DRAWN_RESPONSE" as const;

/**
 * Lifecycle states. `issued` -> `paired` -> `uploaded` -> `consumed` is the
 * happy path; `expired` / `cancelled` / `rejected` are terminal failures.
 * A terminal state can never transition again -- that is what makes replay,
 * late-arriving retries, and post-cancellation uploads all fail closed.
 */
export const PAIRING_STATES = [
  "issued",
  "paired",
  "uploaded",
  "consumed",
  "expired",
  "cancelled",
  "rejected",
] as const;
export type PairingState = typeof PAIRING_STATES[number];

export const PAIRING_TERMINAL_STATES: readonly PairingState[] = [
  "consumed",
  "expired",
  "cancelled",
  "rejected",
];

export function isTerminalPairingState(state: PairingState) {
  return PAIRING_TERMINAL_STATES.includes(state);
}

/** Mirrors `pairing_submission_provenance_event.v1`'s `event_type` enum. */
export const PAIRING_EVENT_TYPES = [
  "SESSION_CREATED",
  "PAIRING_ACCEPTED",
  "PAIRING_REJECTED",
  "RECOVERY_ISSUED",
  "CAPTURE_RECORDED",
  "QUALITY_RECORDED",
  "RETAKE_REQUESTED",
  "CAPTURE_REMOVED",
  "REVIEW_OPENED",
  "SUBMISSION_ACCEPTED",
  "SUBMISSION_REJECTED",
  "SESSION_CANCELLED",
  "SESSION_EXPIRED",
] as const;
export type PairingEventType = typeof PAIRING_EVENT_TYPES[number];

export const PAIRING_ACTORS = [
  "SYSTEM",
  "LEARNER",
  "PRIMARY_DEVICE",
  "CAPTURE_DEVICE",
  "STAFF",
] as const;
export type PairingActor = typeof PAIRING_ACTORS[number];

export const PAIRING_ACCESS_PATHS = ["QR", "FALLBACK_DIRECT"] as const;
export type PairingAccessPath = typeof PAIRING_ACCESS_PATHS[number];

export function isPairingAccessPath(
  value: unknown,
): value is PairingAccessPath {
  return value === "QR" || value === "FALLBACK_DIRECT";
}

/* -------------------------------------------------------------------------- */
/* Capability generation / hashing                                            */
/* -------------------------------------------------------------------------- */

function base64UrlEncode(bytes: Uint8Array) {
  let binary = "";
  for (let i = 0; i < bytes.length; i++) binary += String.fromCharCode(bytes[i]);
  return btoa(binary)
    .replaceAll("+", "-")
    .replaceAll("/", "_")
    .replaceAll("=", "");
}

/**
 * 32 bytes from the platform CSPRNG. Not a JWT, not a signed token, not
 * derived from any record identifier -- an unguessable index into a
 * server-side row and nothing more. This is the "capability contains no
 * readable learner PII" requirement satisfied by construction rather than
 * by redaction.
 */
export function generatePairingHandle(
  randomBytes: (buffer: Uint8Array) => void = (buffer) =>
    crypto.getRandomValues(buffer),
) {
  const bytes = new Uint8Array(32);
  randomBytes(bytes);
  return `${PAIRING_HANDLE_PREFIX}${base64UrlEncode(bytes)}`;
}

export async function hashPairingHandle(handle: string) {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(handle),
  );
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

/**
 * Shape check only -- says nothing about whether a capability exists or is
 * live. Exists so an obviously malformed value is rejected before it is
 * hashed and used as a database lookup key, and so the phone leg gets a
 * clean 400 rather than an indistinguishable "not found".
 */
export function isWellFormedPairingHandle(value: unknown): value is string {
  return typeof value === "string" &&
    value.startsWith(PAIRING_HANDLE_PREFIX) &&
    /^[A-Za-z0-9_-]{43}$/.test(value.slice(PAIRING_HANDLE_PREFIX.length));
}

/* -------------------------------------------------------------------------- */
/* Usability evaluation                                                        */
/* -------------------------------------------------------------------------- */

export type PairingUsability =
  | { ok: true }
  | {
    ok: false;
    /** Stable error code returned to the client. Never leaks record detail. */
    code:
      | "pairing_expired"
      | "pairing_already_used"
      | "pairing_cancelled"
      | "pairing_rejected"
      | "pairing_attempts_exhausted";
    /** Contract `reason` enum value for the provenance event, if applicable. */
    reason: string | null;
  };

/**
 * The single place "may this capability still act?" is decided. Order
 * matters and is deliberate: expiry is checked BEFORE state, so a
 * capability that expired while sitting in `paired` reports expiry (the
 * honest, actionable answer) rather than a confusing state error.
 */
export function evaluatePairingUsability(params: {
  state: PairingState;
  expiresAt: Date;
  redemptionAttempts: number;
  now?: Date;
  maxRedemptionAttempts?: number;
}): PairingUsability {
  const now = params.now ?? new Date();
  const maxAttempts = params.maxRedemptionAttempts ??
    PAIRING_MAX_REDEMPTION_ATTEMPTS;

  if (params.state === "consumed") {
    return {
      ok: false,
      code: "pairing_already_used",
      reason: "USED_PAIRING_HANDLE",
    };
  }
  if (params.state === "cancelled") {
    return { ok: false, code: "pairing_cancelled", reason: "USER_CANCELLED" };
  }
  if (params.state === "rejected") {
    return { ok: false, code: "pairing_rejected", reason: "SESSION_REVOKED" };
  }
  if (params.state === "expired" || params.expiresAt.getTime() <= now.getTime()) {
    return {
      ok: false,
      code: "pairing_expired",
      reason: "EXPIRED_PAIRING_HANDLE",
    };
  }
  // STRICTLY GREATER THAN, not >=, so it agrees with the authoritative budget
  // gate in `claim_capture_pairing_upload`. That SQL gate refuses the (max+1)th
  // CLAIM (`redemption_attempts >= max` before incrementing), so a legitimately
  // issued upload leaves `redemption_attempts` at most `max` (e.g. 5). Using
  // `>=` here refused the *submit* of that max-th photo after its upload URL had
  // already been issued and the bytes uploaded — an off-by-one that stranded a
  // photo the student was allowed to take (`max=5` behaved like 4). A submit
  // only ever runs after a successful claim, so `redemption_attempts` can never
  // exceed `max`; this guard is now a backstop, and the claim owns the budget.
  if (params.redemptionAttempts > maxAttempts) {
    return {
      ok: false,
      code: "pairing_attempts_exhausted",
      reason: "QUALITY_NOT_ACCEPTABLE",
    };
  }
  return { ok: true };
}

/* -------------------------------------------------------------------------- */
/* Purpose binding                                                             */
/* -------------------------------------------------------------------------- */

export interface PairingBinding {
  user_id: string;
  learning_session_id: string | null;
  attempt_id: string;
  response_version_id: string;
  content_item_version_id: string;
  submission_slot_id: string;
  upload_purpose: typeof PAIRING_UPLOAD_PURPOSE;
}

export type PurposeBindingCheck =
  | { ok: true }
  | { ok: false; code: "pairing_binding_mismatch" | "pairing_wrong_purpose" };

/**
 * Defence in depth against wrong-slot / wrong-attempt use.
 *
 * The phone leg never *needs* to send attempt or slot -- everything is
 * resolved from the capability, which is what makes cross-record access
 * structurally impossible. But a client MAY echo back what it believes it
 * is capturing for (the frontend does, so a stale tab that reloaded against
 * a recycled capability fails loudly instead of silently attaching to a
 * different question). When it does, the echo must match exactly.
 *
 * Note the asymmetry: an ABSENT declared field is fine (the capability is
 * authoritative), a PRESENT-but-different one is fatal. Silently ignoring a
 * mismatched declaration would turn this check into decoration.
 */
export function checkPurposeBinding(params: {
  binding: PairingBinding;
  declared?: {
    attempt_id?: string | null;
    response_version_id?: string | null;
    content_item_version_id?: string | null;
    submission_slot_id?: string | null;
  } | null;
}): PurposeBindingCheck {
  if (params.binding.upload_purpose !== PAIRING_UPLOAD_PURPOSE) {
    return { ok: false, code: "pairing_wrong_purpose" };
  }
  const declared = params.declared ?? {};
  const pairs: Array<[string | null | undefined, string]> = [
    [declared.attempt_id, params.binding.attempt_id],
    [declared.response_version_id, params.binding.response_version_id],
    [declared.content_item_version_id, params.binding.content_item_version_id],
    [declared.submission_slot_id, params.binding.submission_slot_id],
  ];
  for (const [claimed, actual] of pairs) {
    if (claimed !== undefined && claimed !== null && claimed !== actual) {
      return { ok: false, code: "pairing_binding_mismatch" };
    }
  }
  return { ok: true };
}

/* -------------------------------------------------------------------------- */
/* Rate limiting                                                               */
/* -------------------------------------------------------------------------- */

export type RateLimitDecision =
  | { allowed: true; remaining: number }
  | { allowed: false; retryAfterSeconds: number };

/**
 * Fixed-window limiter on capability minting, keyed by the AUTHENTICATED
 * user (the phone leg cannot mint, so there is nothing anonymous to limit
 * here). Deliberately generous relative to real use -- a student who
 * re-pairs after several retakes should never hit this -- because its job
 * is to bound a scripted loop, not to police normal fumbling.
 */
export function evaluateMintRateLimit(params: {
  recentMintCount: number;
  windowSeconds?: number;
  maxPerWindow?: number;
}): RateLimitDecision {
  const windowSeconds = params.windowSeconds ?? PAIRING_MINT_WINDOW_SECONDS;
  const maxPerWindow = params.maxPerWindow ?? PAIRING_MINT_MAX_PER_WINDOW;
  if (params.recentMintCount >= maxPerWindow) {
    return { allowed: false, retryAfterSeconds: windowSeconds };
  }
  return { allowed: true, remaining: maxPerWindow - params.recentMintCount };
}

/* -------------------------------------------------------------------------- */
/* Storage paths                                                               */
/* -------------------------------------------------------------------------- */

export type CaptureExtension = "jpg" | "png" | "webp";

export function extensionForMediaType(
  mediaType: "image/png" | "image/jpeg" | "image/webp",
): CaptureExtension {
  switch (mediaType) {
    case "image/png":
      return "png";
    case "image/webp":
      return "webp";
    case "image/jpeg":
      return "jpg";
  }
}

/**
 * Both path builders put the OWNING user's id in the first segment, which
 * is exactly what `ownsLearnerPath` (shared with `storage-sign-url`'s
 * `sign_upload`) checks. That is not incidental: it means an object written
 * through this bridge lands in the same owner-scoped namespace, under the
 * same `learner-uploads` RLS policies, as one written through the
 * authenticated same-device path. The bridge does not get its own
 * privileged storage area.
 *
 * `attempt` is the redemption attempt number, so a retake never overwrites
 * the bytes of the photo it replaced -- Stage D2's "preserve raw uploads;
 * derived images never overwrite them" requirement, enforced at the path
 * level in addition to the immutable-row/storage-policy layers.
 */
export function buildOriginalCapturePath(params: {
  userId: string;
  pairingId: string;
  attempt: number;
  extension: CaptureExtension;
}) {
  return `${params.userId}/captures/${params.pairingId}/original-${params.attempt}.${params.extension}`;
}

export function buildDerivedCapturePath(params: {
  userId: string;
  pairingId: string;
  attempt: number;
  extension: CaptureExtension;
}) {
  return `${params.userId}/captures/${params.pairingId}/derived-stripped-${params.attempt}.${params.extension}`;
}

/* -------------------------------------------------------------------------- */
/* Failure classification (DECISION-0051 item 3)                               */
/* -------------------------------------------------------------------------- */

/**
 * DECISION-0051 splits capture failures by CAUSE, and requires the two
 * halves be distinguishable by the client:
 *
 *   image_quality -> the photo is the problem. Show graceful, GENERIC
 *                    retake guidance. Never a bug report; the student did
 *                    nothing wrong and nothing is broken.
 *   technical     -> we are the problem (API error, timeout, infra,
 *                    malformed model response, upload failure). Must be
 *                    logged as an engineering event, and must NOT be framed
 *                    to the student as their fault.
 *
 * `blocked` is the third, pre-existing class: a legitimate refusal that is
 * neither (expired capability, replay, invalid bytes). It is called out
 * explicitly so the frontend does not have to guess, and so a refusal is
 * never mislabelled as a bug and never mislabelled as a bad photo.
 */
export type CaptureFailureClass = "image_quality" | "technical" | "blocked";

/**
 * The generic retake copy DECISION-0051 makes the baseline. Deliberately
 * says nothing about which defect was detected: the decision states that
 * naming the exact defect is a UX refinement, not a requirement, and a
 * generic prompt cannot be wrong in the way a confidently-specific one can.
 * It also cannot leak anything about the drawn content.
 */
export const GENERIC_RETAKE_GUIDANCE =
  "We could not read this photo clearly enough to grade it. " +
  "Lay the page flat in even light, fit the whole page in the frame, " +
  "hold steady and let the camera focus, then take another photo.";

/**
 * Shown when the capture-quality check itself failed. Says nothing about
 * the photo (we do not know anything about it) and does not blame the
 * student. The paired `incident_id` is what engineering triages.
 */
export const TECHNICAL_FAILURE_GUIDANCE =
  "Something went wrong on our side while checking this photo. " +
  "Your photo was saved. You can try again, and we have logged this for our team.";

/* -------------------------------------------------------------------------- */
/* Provenance events                                                           */
/* -------------------------------------------------------------------------- */

export interface PairingProvenanceEvent {
  contract_version: "v1";
  event_id: string;
  capture_session_id: string;
  sequence: number;
  event_type: PairingEventType;
  occurred_at: string;
  actor: PairingActor;
  binding: {
    learner_subject_ref: string;
    learning_session_id: string;
    content_item_version_id: string;
    item_id: string;
    response_id: string;
    submission_slot_id: string;
    capture_expires_at: string;
    upload_purpose: typeof PAIRING_UPLOAD_PURPOSE;
  };
  pairing: {
    generation: number;
    handle_sha256: string;
    expires_at: string;
    access_path: PairingAccessPath | null;
  } | null;
  image_id: string | null;
  replaces_image_id: string | null;
  quality_status: "ACCEPTABLE" | "RETAKE_REQUIRED" | "CANNOT_DETERMINE" | null;
  explicit_confirmation: boolean | null;
  reason: string | null;
}

/**
 * Builds a record conforming to the Stage D1 frozen contract
 * `pairing_submission_provenance_event.v1.schema.json`. Written rather than
 * invented so the audit trail this bridge produces is the same shape Stage
 * D1 froze -- see SPATIAL_CONTRACT.md section 2.1.
 *
 * `learner_subject_ref` is the internal `auth.uid()` UUID, which the
 * contract explicitly permits ("opaque internal subject reference; never an
 * email, name, or raw external identifier") -- it is not, and must never
 * become, a display name or address.
 */
export function buildPairingProvenanceEvent(params: {
  eventId: string;
  pairingId: string;
  sequence: number;
  eventType: PairingEventType;
  occurredAt: Date;
  actor: PairingActor;
  binding: PairingBinding;
  itemId: string;
  expiresAt: Date;
  generation: number;
  handleSha256: string;
  accessPath?: PairingAccessPath | null;
  includePairing?: boolean;
  imageId?: string | null;
  replacesImageId?: string | null;
  qualityStatus?: PairingProvenanceEvent["quality_status"];
  explicitConfirmation?: boolean | null;
  reason?: string | null;
}): PairingProvenanceEvent {
  return {
    contract_version: "v1",
    event_id: params.eventId,
    capture_session_id: params.pairingId,
    sequence: params.sequence,
    event_type: params.eventType,
    occurred_at: params.occurredAt.toISOString(),
    actor: params.actor,
    binding: {
      learner_subject_ref: params.binding.user_id,
      // The contract requires a non-empty learning_session_id. An attempt
      // created outside a learning session (admin/pilot paths) has none, so
      // fall back to the attempt id rather than emitting an empty string
      // that would fail contract validation.
      learning_session_id: params.binding.learning_session_id ??
        params.binding.attempt_id,
      content_item_version_id: params.binding.content_item_version_id,
      item_id: params.itemId,
      response_id: params.binding.response_version_id,
      submission_slot_id: params.binding.submission_slot_id,
      capture_expires_at: params.expiresAt.toISOString(),
      upload_purpose: PAIRING_UPLOAD_PURPOSE,
    },
    pairing: params.includePairing === false ? null : {
      generation: params.generation,
      handle_sha256: params.handleSha256,
      expires_at: params.expiresAt.toISOString(),
      access_path: params.accessPath ?? null,
    },
    image_id: params.imageId ?? null,
    replaces_image_id: params.replacesImageId ?? null,
    quality_status: params.qualityStatus ?? null,
    explicit_confirmation: params.explicitConfirmation ?? null,
    reason: params.reason ?? null,
  };
}
