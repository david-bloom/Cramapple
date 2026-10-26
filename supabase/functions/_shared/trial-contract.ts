import { trimmedNonEmptyString as asString } from "./input.ts";
export { trimmedNonEmptyString as asString } from "./input.ts";
const TOUCH_KEYS = new Set([
  "utm_source",
  "utm_medium",
  "utm_campaign",
  "utm_content",
  "utm_term",
  "landing_path",
  "referrer_host",
  "reddit_click_id",
  // Other ad platforms' click ids and the ad/creative id, so a trial can be
  // traced to the exact ad (ad-attribution design, 2026-10-26).
  "gclid",
  "gbraid",
  "wbraid",
  "ttclid",
  "fbclid",
  "creative_id",
]);



export function sanitizeTouch(value: unknown) {
  if (!value || typeof value !== "object" || Array.isArray(value)) return {};
  const result: Record<string, string> = {};
  for (const [key, raw] of Object.entries(value as Record<string, unknown>)) {
    if (TOUCH_KEYS.has(key) && typeof raw === "string" && raw.trim()) {
      result[key] = raw.trim().slice(0, 300);
    }
  }
  return result;
}

const ANON_ID_PATTERN = /^[A-Za-z0-9_-]{8,100}$/;

// Ad-platform click ids are identifiers Reddit/Google/TikTok/Meta can match
// to a person; they are kept only when the visitor allowed ad tracking.
const AD_PLATFORM_KEYS = ["reddit_click_id", "gclid", "gbraid", "wbraid", "ttclid", "fbclid"];

export type AdAttribution = {
  ad_tracking_allowed: boolean;
  anon_id?: string;
  first_touch?: Record<string, string>;
  last_touch?: Record<string, string>;
};

// What `trial_start` and pay-now checkout store. Strict allow-list: only the
// touch fields above plus the PostHog anonymous id (a random token, not an
// email or user id). First-party source fields (UTMs, referrer, landing path,
// creative id) are kept for every visitor (DECISION by David, 2026-10-26),
// because nothing about them goes to an ad platform. A visitor who opted out
// of ad tracking keeps none of the ad-platform click ids and no anon id.
// Returns null when the client sent nothing usable. The old flat
// `reddit_click_id` is read as last touch.
export function sanitizeAdAttribution(value: unknown): AdAttribution | null {
  if (!value || typeof value !== "object" || Array.isArray(value)) return null;
  const input = value as Record<string, unknown>;
  const allowed = input.ad_tracking_allowed === true;
  const result: AdAttribution = { ad_tracking_allowed: allowed };
  if (allowed && typeof input.anon_id === "string" && ANON_ID_PATTERN.test(input.anon_id)) {
    result.anon_id = input.anon_id;
  }
  const first = sanitizeTouch(input.first_touch);
  const last = sanitizeTouch(input.last_touch);
  if (typeof input.reddit_click_id === "string" && !last.reddit_click_id) {
    Object.assign(last, sanitizeTouch({ reddit_click_id: input.reddit_click_id }));
  }
  if (!allowed) {
    for (const touch of [first, last]) for (const k of AD_PLATFORM_KEYS) delete touch[k];
  }
  if (Object.keys(first).length > 0) result.first_touch = first;
  if (Object.keys(last).length > 0) result.last_touch = last;
  return result;
}

const SOURCE_KEYS = ["utm_source", "utm_medium", "utm_campaign", "utm_content", "utm_term", "creative_id"] as const;

// Source fields for growth events: last touch, else first touch.
export function attributionEventProperties(a: AdAttribution | null | undefined) {
  const out: Record<string, string> = {};
  for (const key of SOURCE_KEYS) {
    const v = a?.last_touch?.[key] ?? a?.first_touch?.[key];
    if (typeof v === "string" && v) out[key] = v;
  }
  return out;
}

// Pay-now checkout carries the same source in Stripe session metadata, so the
// webhook can stamp purchase_completed without a new table.
export function attributionMetadata(a: AdAttribution | null | undefined): Record<string, string> {
  const out: Record<string, string> = {};
  for (const [k, v] of Object.entries(attributionEventProperties(a))) out[`attr_${k}`] = v;
  return out;
}

export function attributionFromMetadata(metadata: Record<string, string> | null | undefined) {
  const out: Record<string, string> = {};
  for (const key of SOURCE_KEYS) {
    const v = metadata?.[`attr_${key}`];
    if (typeof v === "string" && v) out[key] = v;
  }
  return out;
}
