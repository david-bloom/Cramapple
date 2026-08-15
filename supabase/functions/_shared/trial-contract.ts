const TOUCH_KEYS = new Set([
  "utm_source",
  "utm_medium",
  "utm_campaign",
  "utm_content",
  "utm_term",
  "landing_path",
  "referrer_host",
  "reddit_click_id",
]);

export function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

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
