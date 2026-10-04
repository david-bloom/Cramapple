// Pure helpers for the parent payment short link (TASK-0060).
//
// A short code (cramapple.com/p/<code>) names a Stripe Checkout Session that is
// already payable by anyone who holds its Stripe URL. These helpers hold no
// Supabase client and make no network calls so the decisions are unit testable.

/** 31 characters: lowercase letters without i, l, o and digits 2-9. */
export const SHORT_CODE_ALPHABET = "abcdefghjkmnpqrstuvwxyz23456789";
export const SHORT_CODE_LENGTH = 8;
const SHORT_CODE_PATTERN = /^[a-hjkmnp-z2-9]{8}$/;

/** Unbiased code from CSPRNG bytes: reject bytes that would skew the modulo. */
export function generateShortCode(
  randomBytes: (n: number) => Uint8Array = (n) =>
    crypto.getRandomValues(new Uint8Array(n)),
): string {
  const size = SHORT_CODE_ALPHABET.length;
  const limit = 256 - (256 % size);
  let out = "";
  while (out.length < SHORT_CODE_LENGTH) {
    for (const byte of randomBytes(SHORT_CODE_LENGTH * 2)) {
      if (byte >= limit) continue;
      out += SHORT_CODE_ALPHABET[byte % size];
      if (out.length === SHORT_CODE_LENGTH) break;
    }
  }
  return out;
}

export function normalizeShortCode(value: unknown): string | null {
  if (typeof value !== "string") return null;
  const code = value.trim().toLowerCase();
  return SHORT_CODE_PATTERN.test(code) ? code : null;
}

export function shortLinkUrl(baseUrl: string, code: string): string {
  return `${baseUrl.replace(/\/$/, "")}/p/${code}`;
}

export type ParentLinkState =
  | { state: "open"; url: string }
  | { state: "paid" }
  | { state: "expired" };

type SessionLike = {
  status?: string | null;
  payment_status?: string | null;
  url?: string | null;
  metadata?: Record<string, string> | null;
};

/**
 * What a parent should see when they open a short link. Only parent-share
 * sessions resolve; anything else is treated as expired so a code can never be
 * used to reach a student session.
 */
export function classifyParentSession(session: SessionLike): ParentLinkState {
  const metadata = session.metadata ?? {};
  const purchaseType = metadata.purchase_type ?? metadata.purchaser_type;
  if (purchaseType !== "parent_share") return { state: "expired" };
  if (session.payment_status === "paid" || session.status === "complete") {
    return { state: "paid" };
  }
  if (session.status === "open" && session.url) {
    return { state: "open", url: session.url };
  }
  return { state: "expired" };
}
