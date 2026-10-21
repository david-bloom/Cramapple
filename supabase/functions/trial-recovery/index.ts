// The payer's recovery page after a failed day-7 charge (TASK-0077 plan
// §6.6; DECISION-0126 items 5, 15). "view" changes nothing; "pay" returns the
// order's own PaymentIntent client secret for on-session confirmation.
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";
import {
  checkPublicRateLimit,
  PUBLIC_ENDPOINT_LIMITS,
  rateLimitDeps,
  rateLimitedBody,
} from "../_shared/public-rate-limit.ts";
import { orderView, recoveryClientSecret, resolveCapability } from "../_shared/trial-actions.ts";

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) => jsonResponse(body, init, req);
  if (req.method === "OPTIONS") return respond({ ok: true });
  if (req.method !== "POST") return respond({ error: "method_not_allowed" }, { status: 405 });

  const service = createServiceClient();
  const limit = await checkPublicRateLimit(req, PUBLIC_ENDPOINT_LIMITS.trialLink, rateLimitDeps(service));
  if (!limit.allowed) {
    const limited = rateLimitedBody(limit.retryAfterSeconds);
    return respond(limited.body, limited.init);
  }
  const body = await readJsonBody(req) as Record<string, unknown> | null;
  const orderId = await resolveCapability(service, body?.token, "payer_recovery", new Date());
  if (!orderId) return respond({ error: "link_invalid_or_expired" }, { status: 404 });

  const { data: order, error } = await service.schema("app").from("trial_orders")
    .select("*").eq("id", orderId).single();
  if (error) return respond({ error: "lookup_failed" }, { status: 500 });

  if (body?.action !== "pay") return respond({ status: "ok", order: orderView(order) });
  try {
    const result = await recoveryClientSecret({ service, stripe }, order);
    if ("error" in result) return respond({ error: result.error, order: orderView(order) }, { status: 409 });
    return respond({ status: "ok", client_secret: result.client_secret, order: orderView(order) });
  } catch (e) {
    console.error("trial-recovery failed", e);
    return respond({ error: "recovery_failed" }, { status: 502 });
  }
});
