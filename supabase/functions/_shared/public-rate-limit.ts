// Rate limiting for unauthenticated endpoints (security review 2026-10-15).
//
// Counted per caller IP (stored only as an HMAC) with a global ceiling per
// endpoint. Fails OPEN: if the limiter itself errors, the request proceeds,
// because blocking a parent who is trying to pay is worse than briefly losing
// the throttle. The failure is logged.
//
// Limits are deliberately generous. A school or family shares one IP, so the
// per-IP numbers must tolerate a classroom of students; they exist to stop
// scripts, not people.
import { clientIp, hmacSha256Hex } from "./byoq.ts";

export type PublicEndpointLimit = {
  endpoint: string;
  perIpPerHour: number;
  globalPerHour: number;
};

export const PUBLIC_ENDPOINT_LIMITS = {
  // A student asks a parent to pay: a handful per hour even on a shared IP.
  createParentPaymentLink: {
    endpoint: "create-parent-payment-link",
    perIpPerHour: 30,
    globalPerHour: 600,
  },
  // One call per parent opening a short link.
  resolveParentLink: {
    endpoint: "resolve-parent-link",
    perIpPerHour: 120,
    globalPerHour: 3000,
  },
  // Polled for a short time after each Stripe redirect.
  getCheckoutStatus: {
    endpoint: "get-checkout-status",
    perIpPerHour: 240,
    globalPerHour: 6000,
  },
} as const satisfies Record<string, PublicEndpointLimit>;

export const RATE_LIMIT_WINDOW_SECONDS = 3600;

export type RateLimitRpc = (
  fn: string,
  args: Record<string, unknown>,
) => PromiseLike<{ data: unknown; error: unknown }>;

export type RateLimitResult =
  | { allowed: true }
  | { allowed: false; retryAfterSeconds: number };

export async function checkPublicRateLimit(
  req: Request,
  limit: PublicEndpointLimit,
  deps: { rpc: RateLimitRpc; hmacKey: string },
): Promise<RateLimitResult> {
  try {
    const ip = clientIp(req) ?? "no-ip";
    const keyHmac = await hmacSha256Hex(deps.hmacKey, `public-rl:${ip}`);
    const { data, error } = await deps.rpc("record_public_endpoint_hit", {
      p_endpoint: limit.endpoint,
      p_key_hmac: keyHmac,
      p_per_key_limit: limit.perIpPerHour,
      p_global_limit: limit.globalPerHour,
      p_window_seconds: RATE_LIMIT_WINDOW_SECONDS,
    });
    if (error || !data || typeof data !== "object") {
      console.error(`${limit.endpoint} rate_limit_check_failed`, error);
      return { allowed: true };
    }
    const result = data as { allowed?: unknown; retry_after_seconds?: unknown };
    if (result.allowed === false) {
      const retry = Number(result.retry_after_seconds);
      return {
        allowed: false,
        retryAfterSeconds: Number.isFinite(retry) && retry > 0 ? Math.ceil(retry) : 60,
      };
    }
    return { allowed: true };
  } catch (error) {
    console.error(`${limit.endpoint} rate_limit_check_failed`, error);
    return { allowed: true };
  }
}

/** Production wiring: service-role client plus the env-provided HMAC key. */
export function rateLimitDeps(
  // deno-lint-ignore no-explicit-any
  service: { schema: (name: string) => any },
) {
  const hmacKey = Deno.env.get("PUBLIC_RATE_LIMIT_HMAC_KEY") ??
    Deno.env.get("BYOQ_IP_HMAC_KEY") ??
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ??
    Deno.env.get("SERVICE_ROLE_KEY") ?? "";
  const app = service.schema("app");
  const rpc: RateLimitRpc = (fn, args) => app.rpc(fn, args);
  return { rpc, hmacKey };
}

export function rateLimitedBody(retryAfterSeconds: number) {
  return {
    body: { error: "rate_limited", retry_after_seconds: retryAfterSeconds },
    init: {
      status: 429,
      headers: { "Retry-After": String(retryAfterSeconds) },
    },
  };
}
