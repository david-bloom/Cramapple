// CORS policy. Production should set ALLOWED_ORIGINS to a comma-separated
// list of permitted frontend origins; the matched origin is echoed back per
// request with Vary: Origin so caches don't leak across origins. If
// ALLOWED_ORIGINS is unset (dev / local) we fall back to wildcard "*" for
// convenience — this fallback must not be relied on in production.
const ALLOWED_ORIGINS = (Deno.env.get("ALLOWED_ORIGINS") ?? "")
  .split(",")
  .map((entry) => entry.trim())
  .filter((entry) => entry.length > 0);

const STATIC_HEADERS = {
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-request-id, x-idempotency-key",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function resolveAllowedOrigin(requestOrigin: string | null): string | null {
  if (ALLOWED_ORIGINS.length === 0) {
    return "*";
  }
  if (requestOrigin && ALLOWED_ORIGINS.includes(requestOrigin)) {
    return requestOrigin;
  }
  return null;
}

export function withCors(headers: HeadersInit = {}, req?: Request) {
  const merged = new Headers(headers);
  for (const [key, value] of Object.entries(STATIC_HEADERS)) {
    merged.set(key, value);
  }

  const requestOrigin = req?.headers.get("Origin") ?? null;
  const allowedOrigin = resolveAllowedOrigin(requestOrigin);
  if (allowedOrigin) {
    merged.set("Access-Control-Allow-Origin", allowedOrigin);
  }
  if (ALLOWED_ORIGINS.length > 0) {
    merged.set("Vary", "Origin");
  }
  return merged;
}

// Kept for backwards compatibility with callers that import it directly.
// New code should prefer withCors(headers, req) so per-request origin
// matching can take effect.
export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  ...STATIC_HEADERS,
};
