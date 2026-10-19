// Shared pieces of the seven-day card trial (TASK-0077, DECISION-0126).

export const TRIAL_DAYS = 7;
// v2 (2026-10-18): both mandate texts say cancelling ends trial access right away.
export const MANDATE_TEXT_VERSION = "trial-mandate-v2";
export const TRIAL_SOURCE = "stripe_trial_v1";

// ---------------------------------------------------------------------------
// Dates: always US Eastern, written out (DECISION-0126 item 29).
// ---------------------------------------------------------------------------
const EASTERN = new Intl.DateTimeFormat("en-US", {
  timeZone: "America/New_York",
  weekday: "long",
  year: "numeric",
  month: "long",
  day: "numeric",
});

export function easternDate(date: Date) {
  return EASTERN.format(date);
}

// The charge date shown before setup is a floor: the clock starts when setup
// finishes, so the real date is the same day or later (plan §6.3 step 7).
export function trialChargeFloor(now: Date) {
  return new Date(now.getTime() + TRIAL_DAYS * 24 * 60 * 60 * 1000);
}

export function formatUsd(cents: number) {
  return `$${(cents / 100).toFixed(2)}`;
}

// The wording beside the confirm button. The checkbox for the Terms is
// separate and required.
export function mandateText(chargeCents: number, chargeDate: Date) {
  return `$0 today. On ${easternDate(chargeDate)} (Eastern) we'll charge ` +
    `${formatUsd(chargeCents)} to this card unless you cancel. ` +
    `Cancel any time in Account. Cancelling ends trial access right away.`;
}

// The parent's hosted page (custom_text.submit, max 1,200 characters).
export function parentMandateText(
  chargeCents: number,
  studentFirstName: string | null,
  subjects: string,
) {
  const who = studentFirstName ? `${studentFirstName}'s ` : "";
  return `Free for 7 days. When the trial ends we'll charge ${formatUsd(chargeCents)} ` +
    `to this card for ${who}${subjects} unless you cancel. You can cancel from ` +
    `the link in your confirmation email. Cancelling ends trial access right away.`;
}

// ---------------------------------------------------------------------------
// Quote version: binds what the buyer saw to what is created.
// ---------------------------------------------------------------------------
export type QuoteParts = {
  offer: string;
  subjectKeys: string[];
  priceId: string;
  listAmount: number;
  discountAmount: number;
  chargeAmount: number;
  promotionCodeId: string | null;
  termsVersion: string;
};

export async function quoteVersion(parts: QuoteParts) {
  const canonical = JSON.stringify([
    parts.offer,
    [...parts.subjectKeys].sort(),
    parts.priceId,
    parts.listAmount,
    parts.discountAmount,
    parts.chargeAmount,
    parts.promotionCodeId,
    parts.termsVersion,
    MANDATE_TEXT_VERSION,
  ]);
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(canonical));
  return "q_" + hex(new Uint8Array(digest)).slice(0, 24);
}

export function normalizeEmail(email: string) {
  return email.trim().toLowerCase();
}

// ---------------------------------------------------------------------------
// Capability links (cancel, recovery): a random token in the email, only its
// hash stored (plan §6.1).
// ---------------------------------------------------------------------------
export async function newCapabilityToken() {
  const bytes = crypto.getRandomValues(new Uint8Array(32));
  const token = base64Url(bytes);
  return { token, hash: await hashCapabilityToken(token) };
}

export async function hashCapabilityToken(token: string) {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(token));
  return hex(new Uint8Array(digest));
}

export function looksLikeCapabilityToken(value: unknown): value is string {
  return typeof value === "string" && /^[A-Za-z0-9_-]{43}$/.test(value);
}

// ---------------------------------------------------------------------------
// Classifying a failed off-session confirm (plan §6.5, §6.6). A transport
// error is never a decline and never triggers a new attempt.
// ---------------------------------------------------------------------------
export type AttemptOutcome =
  | "declined_retryable"
  | "declined_hard"
  | "requires_action"
  | "transport_error"
  | "canceled_observed";

const RETRYABLE_DECLINES = new Set([
  "insufficient_funds",
  "processing_error",
  "try_again_later",
  "issuer_not_available",
  "reenter_transaction",
  "generic_decline",
  "do_not_honor",
]);

type StripeLikeError = {
  type?: string;
  code?: string;
  decline_code?: string;
  statusCode?: number;
  raw?: { code?: string; decline_code?: string; payment_intent?: { status?: string } };
  payment_intent?: { status?: string };
};

export function classifyConfirmError(error: unknown): {
  outcome: AttemptOutcome;
  code: string | null;
  declineCode: string | null;
} {
  const e = (error ?? {}) as StripeLikeError;
  const code = e.code ?? e.raw?.code ?? null;
  const declineCode = e.decline_code ?? e.raw?.decline_code ?? null;
  const intentStatus = e.payment_intent?.status ?? e.raw?.payment_intent?.status;

  if (code === "authentication_required" || declineCode === "authentication_required") {
    return { outcome: "requires_action", code, declineCode };
  }
  if (e.type === "StripeCardError" || code === "card_declined" || code === "expired_card" ||
      code === "incorrect_cvc" || code === "incorrect_number") {
    const retryable = code === "card_declined" && declineCode !== null &&
      RETRYABLE_DECLINES.has(declineCode);
    return { outcome: retryable ? "declined_retryable" : "declined_hard", code, declineCode };
  }
  if (code === "payment_intent_unexpected_state" && intentStatus === "canceled") {
    return { outcome: "canceled_observed", code, declineCode };
  }
  // Connection problems, rate limits, 5xx, unexpected states: we do not know
  // whether the card was charged, so reconcile instead of retrying.
  return { outcome: "transport_error", code, declineCode };
}

function hex(bytes: Uint8Array) {
  return Array.from(bytes).map((b) => b.toString(16).padStart(2, "0")).join("");
}

function base64Url(bytes: Uint8Array) {
  let s = "";
  for (const b of bytes) s += String.fromCharCode(b);
  return btoa(s).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}
