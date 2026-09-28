import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function parseSubjectKeys(value: unknown) {
  if (!Array.isArray(value)) return [];
  return value.filter((entry): entry is string => typeof entry === "string");
}

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") return respond({ ok: true });
  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }

  const sessionId = asString((body as Record<string, unknown>).session_id);
  if (!sessionId || !/^cs_(test_|live_)?[A-Za-z0-9_]+$/.test(sessionId)) {
    return respond({ error: "invalid_session_id" }, { status: 400 });
  }

  const service = createServiceClient();
  const { data: stored, error } = await service.schema("app")
    .from("stripe_checkout_sessions")
    .select(
      "id,user_id,mode,status,payment_status,subject_keys,amount_total,amount_discount",
    )
    .eq("id", sessionId)
    .maybeSingle();

  if (error) {
    console.error("get-checkout-status lookup_failed", error);
    return respond({ error: "status_lookup_failed" }, { status: 500 });
  }

  if (!stored) {
    // The redirect can arrive before the webhook. Read Stripe only to report
    // progress; entitlement remains webhook-authoritative.
    try {
      const session = await stripe.checkout.sessions.retrieve(sessionId);
      const failed = session.status === "expired";
      return respond({
        status: "ok",
        payment_status: failed
          ? "failed"
          : session.payment_status === "paid"
          ? "processing"
          : session.payment_status ?? "processing",
        entitled: false,
        offer: null,
      });
    } catch {
      return respond({ error: "session_not_found" }, { status: 404 });
    }
  }

  const failed =
    stored.status === "async_payment_failed" ||
    stored.status === "expired";

  if (failed) {
    return respond({
      status: "ok",
      payment_status: "failed",
      entitled: false,
      offer: null,
    });
  }

  const subjectKeys = parseSubjectKeys(stored.subject_keys);
  let entitled = false;

  if (stored.user_id && stored.payment_status === "paid") {
    const { data: entitlements, error: entitlementError } = await service
      .schema("app")
      .from("subject_entitlements")
      .select("subject_id")
      .eq("user_id", stored.user_id)
      .eq("stripe_checkout_session_id", sessionId)
      .eq("access_tier", "paid")
      .eq("status", "active");

    if (entitlementError) {
      console.error("get-checkout-status entitlement_lookup_failed", entitlementError);
      return respond({ error: "status_lookup_failed" }, { status: 500 });
    }

    const expectedCount = stored.mode === "unlimited"
      ? 1
      : Math.max(subjectKeys.length, 1);
    entitled = (entitlements?.length ?? 0) >= expectedCount;
  }

  return respond({
    status: "ok",
    payment_status: stored.payment_status === "paid"
      ? (entitled ? "paid" : "processing")
      : stored.payment_status ?? "processing",
    entitled,
    offer: null,
  });
});
