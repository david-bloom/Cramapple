export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-request-id, x-idempotency-key",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

export function withCors(headers: HeadersInit = {}) {
  const merged = new Headers(headers);
  for (const [key, value] of Object.entries(corsHeaders)) {
    merged.set(key, value);
  }
  return merged;
}
