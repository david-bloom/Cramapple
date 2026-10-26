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

export type AdAttribution = {
  ad_tracking_allowed: boolean;
  anon_id?: string;
  first_touch?: Record<string, string>;
  last_touch?: Record<string, string>;
};

// What `trial_start` stores on the order. Strict allow-list: only the touch
// fields above plus the PostHog anonymous id (a random token, not an email or
// user id). A visitor who opted out of ad tracking stores only that fact, so
// nothing about their acquisition path is kept. Returns null when the client
// sent nothing usable. The old flat `reddit_click_id` is read as last touch.
export function sanitizeAdAttribution(value: unknown): AdAttribution | null {
  if (!value || typeof value !== "object" || Array.isArray(value)) return null;
  const input = value as Record<string, unknown>;
  if (input.ad_tracking_allowed !== true) return { ad_tracking_allowed: false };
  const result: AdAttribution = { ad_tracking_allowed: true };
  if (typeof input.anon_id === "string" && ANON_ID_PATTERN.test(input.anon_id)) {
    result.anon_id = input.anon_id;
  }
  const first = sanitizeTouch(input.first_touch);
  const last = sanitizeTouch(input.last_touch);
  if (typeof input.reddit_click_id === "string" && !last.reddit_click_id) {
    Object.assign(last, sanitizeTouch({ reddit_click_id: input.reddit_click_id }));
  }
  if (Object.keys(first).length > 0) result.first_touch = first;
  if (Object.keys(last).length > 0) result.last_touch = last;
  return result;
}
