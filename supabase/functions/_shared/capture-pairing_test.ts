// TASK-0016 Phase D, Stage D2 regression guard for the QR capture bridge.
//
// The phone leg of QR capture has no Supabase JWT: a capability is the ONLY
// thing standing between an anonymous HTTP request and a write into a
// student's storage namespace and response record. Every test below pins a
// specific line from Stage D2's security requirements, so a future edit that
// weakens one fails here rather than in production:
//
//   * capability carries no readable PII and cannot name another record
//   * bound to user/session, item version, attempt, and submission slot
//   * expiry, single use, replay prevention, rate limiting
//   * raw uploads preserved; derived images never overwrite them
//   * the provenance/audit record conforms to the Stage D1 frozen contract

import {
  assert,
  assertEquals,
  assertNotEquals,
  assertStringIncludes,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  buildDerivedCapturePath,
  buildOriginalCapturePath,
  buildPairingProvenanceEvent,
  checkPurposeBinding,
  evaluateMintRateLimit,
  evaluatePairingUsability,
  extensionForMediaType,
  GENERIC_RETAKE_GUIDANCE,
  generatePairingHandle,
  hashPairingHandle,
  isPairingAccessPath,
  isTerminalPairingState,
  isWellFormedPairingHandle,
  PAIRING_HANDLE_PREFIX,
  PAIRING_MAX_REDEMPTION_ATTEMPTS,
  PAIRING_MINT_MAX_PER_WINDOW,
  type PairingBinding,
  PAIRING_TTL_SECONDS,
} from "./capture-pairing.ts";

const BINDING: PairingBinding = {
  user_id: "11111111-1111-4111-8111-111111111111",
  learning_session_id: "22222222-2222-4222-8222-222222222222",
  attempt_id: "33333333-3333-4333-8333-333333333333",
  response_version_id: "44444444-4444-4444-8444-444444444444",
  content_item_version_id: "55555555-5555-4555-8555-555555555555",
  submission_slot_id: "slot-1",
  upload_purpose: "DRAWN_RESPONSE",
};

/* -------------------------------------------------------------------------- */
/* Capability shape: no readable PII, unguessable, hash-only at rest          */
/* -------------------------------------------------------------------------- */

Deno.test("capability is opaque: 32 bytes of entropy, no embedded record data", () => {
  const handle = generatePairingHandle();
  assert(handle.startsWith(PAIRING_HANDLE_PREFIX));
  // 32 bytes -> 43 base64url characters, no padding.
  assertEquals(handle.length, PAIRING_HANDLE_PREFIX.length + 43);
  assert(isWellFormedPairingHandle(handle));
  // Nothing from the binding may appear in the capability. This is the
  // "capability contains no readable learner PII" requirement as a test:
  // the only way to satisfy it is for the handle to be pure randomness.
  for (const value of Object.values(BINDING)) {
    if (typeof value !== "string") continue;
    assertEquals(handle.includes(value), false);
    // Also check the undashed form, in case a future encoding strips them.
    assertEquals(handle.includes(value.replaceAll("-", "")), false);
  }
});

Deno.test("two capabilities minted back to back never collide", () => {
  const seen = new Set<string>();
  for (let i = 0; i < 200; i++) seen.add(generatePairingHandle());
  assertEquals(seen.size, 200);
});

Deno.test("capability generation uses the injected CSPRNG for all 32 bytes", () => {
  // Guards against a future edit that shrinks the buffer or fills only part
  // of it (a silent entropy loss that no output-shape check would catch).
  let filled = 0;
  const handle = generatePairingHandle((buffer) => {
    filled = buffer.length;
    buffer.fill(0);
  });
  assertEquals(filled, 32);
  // All-zero input still produces a well-formed handle, so the shape check
  // cannot be what accidentally passes for entropy.
  assert(isWellFormedPairingHandle(handle));
});

Deno.test("only the hash is stable/storable, and it is not the capability", async () => {
  const handle = generatePairingHandle();
  const hash = await hashPairingHandle(handle);
  assertEquals(hash.length, 64);
  assert(/^[0-9a-f]{64}$/.test(hash));
  assertNotEquals(hash, handle);
  // Deterministic, so a lookup by hash works...
  assertEquals(await hashPairingHandle(handle), hash);
  // ...and distinct per capability, so one hash cannot unlock another.
  assertNotEquals(await hashPairingHandle(generatePairingHandle()), hash);
});

Deno.test("malformed capabilities are rejected before they are ever hashed", () => {
  const cases: unknown[] = [
    null,
    undefined,
    42,
    "",
    "cap_",
    "cap_short",
    // Right length, missing prefix.
    "A".repeat(43),
    // Right prefix, wrong length.
    `${PAIRING_HANDLE_PREFIX}${"A".repeat(42)}`,
    `${PAIRING_HANDLE_PREFIX}${"A".repeat(44)}`,
    // Right prefix and length, illegal base64url characters.
    `${PAIRING_HANDLE_PREFIX}${"A".repeat(42)}+`,
    `${PAIRING_HANDLE_PREFIX}${"A".repeat(42)}/`,
    `${PAIRING_HANDLE_PREFIX}${"A".repeat(42)}=`,
  ];
  for (const value of cases) {
    assertEquals(
      isWellFormedPairingHandle(value),
      false,
      `expected rejection for ${JSON.stringify(value)}`,
    );
  }
});

/* -------------------------------------------------------------------------- */
/* Expiry, single use, replay, attempt budget                                 */
/* -------------------------------------------------------------------------- */

const NOW = new Date("2026-08-19T12:00:00.000Z");
const LIVE = new Date(NOW.getTime() + 60_000);
const LAPSED = new Date(NOW.getTime() - 1_000);

Deno.test("a live, unused capability is usable", () => {
  const result = evaluatePairingUsability({
    state: "issued",
    expiresAt: LIVE,
    redemptionAttempts: 0,
    now: NOW,
  });
  assertEquals(result.ok, true);
});

Deno.test("expiry: a lapsed capability is refused even while state looks live", () => {
  for (const state of ["issued", "paired", "uploaded"] as const) {
    const result = evaluatePairingUsability({
      state,
      expiresAt: LAPSED,
      redemptionAttempts: 0,
      now: NOW,
    });
    assertEquals(result.ok, false);
    if (result.ok) throw new Error("unreachable");
    assertEquals(result.code, "pairing_expired");
    assertEquals(result.reason, "EXPIRED_PAIRING_HANDLE");
  }
});

Deno.test("expiry boundary is inclusive: exactly at expires_at is already expired", () => {
  const result = evaluatePairingUsability({
    state: "issued",
    expiresAt: NOW,
    redemptionAttempts: 0,
    now: NOW,
  });
  assertEquals(result.ok, false);
});

Deno.test("replay: a consumed capability reports already-used, not expired", () => {
  const result = evaluatePairingUsability({
    state: "consumed",
    expiresAt: LIVE,
    redemptionAttempts: 1,
    now: NOW,
  });
  assertEquals(result.ok, false);
  if (result.ok) throw new Error("unreachable");
  assertEquals(result.code, "pairing_already_used");
  assertEquals(result.reason, "USED_PAIRING_HANDLE");
});

Deno.test("a consumed capability stays refused even after it also expires", () => {
  // Ordering matters: single-use must win over expiry so a replay is never
  // misreported as a timing problem the student could retry around.
  const result = evaluatePairingUsability({
    state: "consumed",
    expiresAt: LAPSED,
    redemptionAttempts: 1,
    now: NOW,
  });
  assertEquals(result.ok, false);
  if (result.ok) throw new Error("unreachable");
  assertEquals(result.code, "pairing_already_used");
});

Deno.test("cancellation and revocation are distinguishable terminal refusals", () => {
  const cancelled = evaluatePairingUsability({
    state: "cancelled",
    expiresAt: LIVE,
    redemptionAttempts: 0,
    now: NOW,
  });
  assertEquals(cancelled.ok, false);
  if (cancelled.ok) throw new Error("unreachable");
  assertEquals(cancelled.code, "pairing_cancelled");

  const rejected = evaluatePairingUsability({
    state: "rejected",
    expiresAt: LIVE,
    redemptionAttempts: 0,
    now: NOW,
  });
  assertEquals(rejected.ok, false);
  if (rejected.ok) throw new Error("unreachable");
  assertEquals(rejected.code, "pairing_rejected");
});

Deno.test("attempt budget agrees with the claim gate: the max-th photo is still submittable (N1)", () => {
  // `claim_capture_pairing_upload` refuses the (max+1)th CLAIM (it checks
  // `redemption_attempts >= max` BEFORE incrementing), so a legitimately issued
  // upload leaves `redemption_attempts` at most `max`. The submit-side usability
  // check must therefore ALLOW `redemption_attempts` up to and INCLUDING `max` —
  // the max-th photo was already allowed to be taken and uploaded — and refuse
  // only a value that could never have been issued (> max). Refusing at
  // `== max` was the off-by-one (N1) that let the 5th photo upload and then
  // 409'd its submit, orphaning the bytes.
  for (let attempts = 0; attempts <= PAIRING_MAX_REDEMPTION_ATTEMPTS; attempts++) {
    const result = evaluatePairingUsability({
      state: "paired",
      expiresAt: LIVE,
      redemptionAttempts: attempts,
      now: NOW,
    });
    assertEquals(
      result.ok,
      true,
      `attempt ${attempts} (<= max) should be submittable`,
    );
  }
  const exhausted = evaluatePairingUsability({
    state: "paired",
    expiresAt: LIVE,
    redemptionAttempts: PAIRING_MAX_REDEMPTION_ATTEMPTS + 1,
    now: NOW,
  });
  assertEquals(exhausted.ok, false);
  if (exhausted.ok) throw new Error("unreachable");
  assertEquals(exhausted.code, "pairing_attempts_exhausted");
});

Deno.test("every terminal state is classified as terminal", () => {
  for (const state of ["consumed", "expired", "cancelled", "rejected"] as const) {
    assertEquals(isTerminalPairingState(state), true);
  }
  for (const state of ["issued", "paired", "uploaded"] as const) {
    assertEquals(isTerminalPairingState(state), false);
  }
});

Deno.test("TTL is short-lived by construction", () => {
  // A capability that lived for hours would defeat the point of a QR code
  // that is briefly on screen. Pin the order of magnitude, not the value.
  assert(PAIRING_TTL_SECONDS <= 30 * 60, "TTL must stay <= 30 minutes");
  assert(PAIRING_TTL_SECONDS >= 60, "TTL must be long enough to be usable");
});

/* -------------------------------------------------------------------------- */
/* Purpose binding: wrong attempt / wrong slot / wrong purpose                */
/* -------------------------------------------------------------------------- */

Deno.test("purpose binding: an absent declaration is fine (capability is authoritative)", () => {
  assertEquals(checkPurposeBinding({ binding: BINDING }).ok, true);
  assertEquals(checkPurposeBinding({ binding: BINDING, declared: {} }).ok, true);
  assertEquals(
    checkPurposeBinding({ binding: BINDING, declared: null }).ok,
    true,
  );
});

Deno.test("purpose binding: a matching declaration passes", () => {
  const result = checkPurposeBinding({
    binding: BINDING,
    declared: {
      attempt_id: BINDING.attempt_id,
      response_version_id: BINDING.response_version_id,
      content_item_version_id: BINDING.content_item_version_id,
      submission_slot_id: BINDING.submission_slot_id,
    },
  });
  assertEquals(result.ok, true);
});

Deno.test("purpose binding: wrong attempt is refused", () => {
  const result = checkPurposeBinding({
    binding: BINDING,
    declared: { attempt_id: "99999999-9999-4999-8999-999999999999" },
  });
  assertEquals(result.ok, false);
  if (result.ok) throw new Error("unreachable");
  assertEquals(result.code, "pairing_binding_mismatch");
});

Deno.test("purpose binding: wrong submission slot is refused", () => {
  const result = checkPurposeBinding({
    binding: BINDING,
    declared: { submission_slot_id: "slot-2" },
  });
  assertEquals(result.ok, false);
  if (result.ok) throw new Error("unreachable");
  assertEquals(result.code, "pairing_binding_mismatch");
});

Deno.test("purpose binding: wrong response version or item version is refused", () => {
  for (
    const declared of [
      { response_version_id: "99999999-9999-4999-8999-999999999999" },
      { content_item_version_id: "99999999-9999-4999-8999-999999999999" },
    ]
  ) {
    const result = checkPurposeBinding({ binding: BINDING, declared });
    assertEquals(result.ok, false, JSON.stringify(declared));
  }
});

Deno.test("purpose binding: a non-drawn-response purpose can never be used here", () => {
  const result = checkPurposeBinding({
    binding: {
      ...BINDING,
      upload_purpose: "SOMETHING_ELSE" as unknown as "DRAWN_RESPONSE",
    },
  });
  assertEquals(result.ok, false);
  if (result.ok) throw new Error("unreachable");
  assertEquals(result.code, "pairing_wrong_purpose");
});

/* -------------------------------------------------------------------------- */
/* Rate limiting                                                              */
/* -------------------------------------------------------------------------- */

Deno.test("mint rate limit allows normal use and blocks a scripted loop", () => {
  const first = evaluateMintRateLimit({ recentMintCount: 0 });
  assertEquals(first.allowed, true);
  if (!first.allowed) throw new Error("unreachable");
  assertEquals(first.remaining, PAIRING_MINT_MAX_PER_WINDOW);

  const last = evaluateMintRateLimit({
    recentMintCount: PAIRING_MINT_MAX_PER_WINDOW - 1,
  });
  assertEquals(last.allowed, true);

  const blocked = evaluateMintRateLimit({
    recentMintCount: PAIRING_MINT_MAX_PER_WINDOW,
  });
  assertEquals(blocked.allowed, false);
  if (blocked.allowed) throw new Error("unreachable");
  assert(blocked.retryAfterSeconds > 0);
});

Deno.test("mint rate limit stays blocked past the threshold, not just at it", () => {
  const blocked = evaluateMintRateLimit({
    recentMintCount: PAIRING_MINT_MAX_PER_WINDOW + 500,
  });
  assertEquals(blocked.allowed, false);
});

/* -------------------------------------------------------------------------- */
/* Storage paths: owner-scoped, retake-safe, derived never overwrites raw     */
/* -------------------------------------------------------------------------- */

Deno.test("capture paths are owner-scoped so they satisfy ownsLearnerPath", () => {
  const original = buildOriginalCapturePath({
    userId: BINDING.user_id,
    pairingId: "abc",
    attempt: 1,
    extension: "jpg",
  });
  assertEquals(original.split("/")[0], BINDING.user_id);
  assertEquals(original.includes(".."), false);
  assertEquals(original.startsWith("/"), false);
  assertEquals(original.includes("//"), false);
});

Deno.test("a retake never overwrites the previous original's bytes", () => {
  const first = buildOriginalCapturePath({
    userId: BINDING.user_id,
    pairingId: "abc",
    attempt: 1,
    extension: "jpg",
  });
  const second = buildOriginalCapturePath({
    userId: BINDING.user_id,
    pairingId: "abc",
    attempt: 2,
    extension: "jpg",
  });
  assertNotEquals(first, second);
});

Deno.test("the derived, stripped copy never collides with the original", () => {
  const args = {
    userId: BINDING.user_id,
    pairingId: "abc",
    attempt: 1,
    extension: "jpg" as const,
  };
  const original = buildOriginalCapturePath(args);
  const derived = buildDerivedCapturePath(args);
  assertNotEquals(original, derived);
  assertStringIncludes(derived, "derived-stripped-");
  assertEquals(derived.split("/")[0], BINDING.user_id);
});

Deno.test("two capabilities for the same user cannot collide on a path", () => {
  const a = buildOriginalCapturePath({
    userId: BINDING.user_id,
    pairingId: "pairing-a",
    attempt: 1,
    extension: "jpg",
  });
  const b = buildOriginalCapturePath({
    userId: BINDING.user_id,
    pairingId: "pairing-b",
    attempt: 1,
    extension: "jpg",
  });
  assertNotEquals(a, b);
});

Deno.test("extension mapping covers every accepted media type", () => {
  assertEquals(extensionForMediaType("image/jpeg"), "jpg");
  assertEquals(extensionForMediaType("image/png"), "png");
  assertEquals(extensionForMediaType("image/webp"), "webp");
});

Deno.test("access path accepts only the two contract values", () => {
  assertEquals(isPairingAccessPath("QR"), true);
  assertEquals(isPairingAccessPath("FALLBACK_DIRECT"), true);
  for (const bad of ["qr", "", null, undefined, 1, "OTHER"]) {
    assertEquals(isPairingAccessPath(bad), false);
  }
});

/* -------------------------------------------------------------------------- */
/* Generic retake copy (DECISION-0051)                                        */
/* -------------------------------------------------------------------------- */

Deno.test("generic retake guidance names no defect and no content", () => {
  const lower = GENERIC_RETAKE_GUIDANCE.toLowerCase();
  // DECISION-0051 makes generic guidance the baseline, so this string must
  // not claim to know which defect occurred...
  for (const specific of ["glare", "blur", "cut off", "angle", "resolution"]) {
    assertEquals(
      lower.includes(specific),
      false,
      `generic guidance must not name "${specific}"`,
    );
  }
  // ...and must never say anything about the student's answer.
  for (const answerish of ["correct", "wrong", "answer", "should be", "axis"]) {
    assertEquals(
      lower.includes(answerish),
      false,
      `generic guidance must not include "${answerish}"`,
    );
  }
  // It still has to be actionable, or it is not guidance.
  assertStringIncludes(lower, "photo");
});

/* -------------------------------------------------------------------------- */
/* Provenance events conform to the Stage D1 frozen contract                  */
/* -------------------------------------------------------------------------- */

function sampleEvent(overrides: Record<string, unknown> = {}) {
  return buildPairingProvenanceEvent({
    eventId: "66666666-6666-4666-8666-666666666666",
    pairingId: "77777777-7777-4777-8777-777777777777",
    sequence: 1,
    eventType: "SESSION_CREATED",
    occurredAt: NOW,
    actor: "PRIMARY_DEVICE",
    binding: BINDING,
    itemId: BINDING.content_item_version_id,
    expiresAt: LIVE,
    generation: 1,
    handleSha256: "a".repeat(64),
    accessPath: "QR",
    ...overrides,
  });
}

Deno.test("provenance event carries every field pairing_submission_provenance_event.v1 requires", () => {
  const event = sampleEvent();
  for (
    const key of [
      "contract_version",
      "event_id",
      "capture_session_id",
      "sequence",
      "event_type",
      "occurred_at",
      "actor",
      "binding",
      "pairing",
      "image_id",
      "replaces_image_id",
      "quality_status",
      "explicit_confirmation",
      "reason",
    ]
  ) {
    assert(key in event, `missing required contract field ${key}`);
  }
  assertEquals(event.contract_version, "v1");
  for (
    const key of [
      "learner_subject_ref",
      "learning_session_id",
      "content_item_version_id",
      "item_id",
      "response_id",
      "submission_slot_id",
      "capture_expires_at",
      "upload_purpose",
    ]
  ) {
    assert(key in event.binding, `missing required binding field ${key}`);
  }
  assertEquals(event.binding.upload_purpose, "DRAWN_RESPONSE");
});

Deno.test("provenance event stores only the capability HASH, never the capability", () => {
  const handle = generatePairingHandle();
  const event = sampleEvent({ handleSha256: "b".repeat(64) });
  const serialized = JSON.stringify(event);
  assertEquals(serialized.includes(handle), false);
  assert(event.pairing !== null);
  assertEquals(event.pairing.handle_sha256.length, 64);
});

Deno.test("provenance binding uses the opaque subject ref, never a name or email", () => {
  const event = sampleEvent();
  // The contract's own wording: "never an email, name, or raw external
  // identifier". The internal uuid is what satisfies that.
  assertEquals(event.binding.learner_subject_ref, BINDING.user_id);
  assertEquals(JSON.stringify(event).includes("@"), false);
});

Deno.test("provenance event falls back to the attempt id when there is no learning session", () => {
  // The contract requires a non-empty learning_session_id; an admin/pilot
  // attempt has none, and emitting "" would fail contract validation.
  const event = buildPairingProvenanceEvent({
    eventId: "66666666-6666-4666-8666-666666666666",
    pairingId: "77777777-7777-4777-8777-777777777777",
    sequence: 2,
    eventType: "PAIRING_ACCEPTED",
    occurredAt: NOW,
    actor: "CAPTURE_DEVICE",
    binding: { ...BINDING, learning_session_id: null },
    itemId: BINDING.content_item_version_id,
    expiresAt: LIVE,
    generation: 1,
    handleSha256: "c".repeat(64),
  });
  assertEquals(event.binding.learning_session_id, BINDING.attempt_id);
  assert(event.binding.learning_session_id.length > 0);
});

Deno.test("timestamps are ISO-8601, as the contract's date-time format requires", () => {
  const event = sampleEvent();
  assertEquals(event.occurred_at, NOW.toISOString());
  assertEquals(event.binding.capture_expires_at, LIVE.toISOString());
});

Deno.test("a submission-accepted event records explicit confirmation and lineage", () => {
  const event = sampleEvent({
    eventType: "SUBMISSION_ACCEPTED",
    actor: "LEARNER",
    imageId: "88888888-8888-4888-8888-888888888888",
    replacesImageId: "99999999-9999-4999-8999-999999999999",
    explicitConfirmation: true,
    qualityStatus: "ACCEPTABLE",
  });
  assertEquals(event.event_type, "SUBMISSION_ACCEPTED");
  assertEquals(event.explicit_confirmation, true);
  assertEquals(event.replaces_image_id, "99999999-9999-4999-8999-999999999999");
  assertEquals(event.quality_status, "ACCEPTABLE");
});
