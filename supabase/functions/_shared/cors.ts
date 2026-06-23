// CORS policy. Per DECISION-0027 there is no wildcard fallback: every
// environment (production, beta, preview, local dev) must set
// ALLOWED_ORIGINS to a comma-separated list of permitted origins. The
// matched request origin is echoed back per request with Vary: Origin so
// caches don't leak across origins. Requests whose Origin is not in the
// list receive no Access-Control-Allow-Origin header (browser blocks);
// non-browser callers don't need CORS headers and continue to work.
//
// Local-dev example:
//   ALLOWED_ORIGINS=http://localhost:5173,http://localhost:3000,https://cramapple-beta.lovable.app

function requireEnv(name: string) {
  const value = Deno.env.get(name);
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

const ALLOWED_ORIGINS = (() => {
  const parsed = requireEnv("ALLOWED_ORIGINS")
    .split(",")
    .map((entry) => entry.trim())
    .filter((entry) => entry.length > 0);
  if (parsed.length === 0) {
    throw new Error(
      "ALLOWED_ORIGINS is set but parsed to an empty list. " +
        "Provide at least one origin (no wildcard fallback).",
    );
  }
  return parsed;
})();

const STATIC_HEADERS = {
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-request-id, x-idempotency-key",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

export function withCors(headers: HeadersInit = {}, req?: Request) {
  const merged = new Headers(headers);
  for (const [key, value] of Object.entries(STATIC_HEADERS)) {
    merged.set(key, value);
  }

  const requestOrigin = req?.headers.get("Origin") ?? null;
  if (requestOrigin && ALLOWED_ORIGINS.includes(requestOrigin)) {
    merged.set("Access-Control-Allow-Origin", requestOrigin);
  }
  merged.set("Vary", "Origin");
  return merged;
}
