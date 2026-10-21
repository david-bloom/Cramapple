// Cancel a card trial (TASK-0077 plan §6.7; DECISION-0126 items 4, 10, 19).
// A signed-in student cancels their own trial, including one a parent
// started; a parent uses the single-purpose link from their email.
// "view" never changes anything, so an email scanner opening the link is safe.
import { requireProfile } from "../_shared/auth.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";
import {
  checkPublicRateLimit,
  PUBLIC_ENDPOINT_LIMITS,
  rateLimitDeps,
  rateLimitedBody,
} from "../_shared/public-rate-limit.ts";
import { cancelTrialOrder, orderView, resolveCapability } from "../_shared/trial-actions.ts";

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) => jsonResponse(body, init, req);
  if (req.method === "OPTIONS") return respond({ ok: true });
  if (req.method !== "POST") return respond({ error: "method_not_allowed" }, { status: 405 });

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }
  const input = body as Record<string, unknown>;
  const action = input.action === "cancel" ? "cancel" : "view";
  const service = createServiceClient();

  let orderId: string | null = null;
  let actor: "student" | "parent" = "student";
  if (typeof input.token === "string") {
    const limit = await checkPublicRateLimit(req, PUBLIC_ENDPOINT_LIMITS.trialLink, rateLimitDeps(service));
    if (!limit.allowed) {
      const limited = rateLimitedBody(limit.retryAfterSeconds);
      return respond(limited.body, limited.init);
    }
    orderId = await resolveCapability(service, input.token, "parent_cancel", new Date());
    actor = "parent";
    if (!orderId) return respond({ error: "link_invalid_or_expired" }, { status: 404 });
  } else {
    const profile = await requireProfile(req);
    if (!profile) return respond({ error: "unauthorized" }, { status: 401 });
    if (typeof input.order_id !== "string") return respond({ error: "invalid_order_id" }, { status: 400 });
    const { data: owned } = await service.schema("app").from("trial_orders")
      .select("id").eq("id", input.order_id).eq("user_id", profile.user.id).maybeSingle();
    if (!owned) return respond({ error: "not_found" }, { status: 404 });
    orderId = owned.id;
  }

  const { data: order, error } = await service.schema("app").from("trial_orders")
    .select("*").eq("id", orderId).single();
  if (error) return respond({ error: "lookup_failed" }, { status: 500 });

  if (action === "view") return respond({ status: "ok", order: orderView(order) });

  try {
    const result = await cancelTrialOrder({ service, stripe }, order.id, actor);
    if (result.result === "not_cancelable") {
      return respond({ error: "not_cancelable", order: orderView(order) }, { status: 409 });
    }
    if (result.result === "canceled") {
      await recordGrowthEvent(service, {
        eventName: "trial_canceled",
        userId: order.user_id,
        source: "web",
        dedupeKey: `trial_canceled:${order.id}`,
        properties: { offer: order.offer, access_tier: "trial" },
      });
    }
    return respond({ status: "ok", outcome: result.outcome, message: result.message });
  } catch (e) {
    console.error("cancel-trial failed", e);
    return respond({ error: "cancel_failed" }, { status: 502 });
  }
});
