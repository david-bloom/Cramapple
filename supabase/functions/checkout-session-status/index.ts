import { checkoutAccessState } from "../_shared/checkout-contract.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";

function asSessionId(value: unknown) {
  return typeof value === "string" &&
      /^cs_(test_|live_)?[A-Za-z0-9]+$/.test(value)
    ? value
    : null;
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

  const sessionId = asSessionId(
    (body as Record<string, unknown>).session_id,
  );
  if (!sessionId) {
    return respond({ error: "invalid_session_id" }, { status: 400 });
  }

  try {
    const session = await stripe.checkout.sessions.retrieve(sessionId);
    const service = createServiceClient();
    const { data: recorded, error: recordedError } = await service.schema(
      "app",
    ).from("stripe_checkout_sessions").select(
      "user_id, status, payment_status, mode, subject_keys",
    ).eq("id", sessionId).maybeSingle();
    if (recordedError) throw recordedError;

    const subjectKeys = Array.isArray(recorded?.subject_keys)
      ? recorded.subject_keys.filter((value): value is string =>
        typeof value === "string"
      )
      : [];
    let activeEntitlements = 0;
    if (recorded?.user_id) {
      const { count, error: entitlementError } = await service.schema("app")
        .from("subject_entitlements")
        .select("id", { count: "exact", head: true })
        .eq("user_id", recorded.user_id)
        .eq("stripe_checkout_session_id", sessionId)
        .eq("access_tier", "paid")
        .eq("status", "active");
      if (entitlementError) throw entitlementError;
      activeEntitlements = count ?? 0;
    }

    const paymentStatus = recorded?.payment_status ?? session.payment_status ??
      null;
    const checkoutStatus = recorded?.status ?? session.status ?? null;
    const status = checkoutAccessState({
      checkoutStatus,
      paymentStatus,
      expectedEntitlements: subjectKeys.length,
      activeEntitlements,
    });

    return respond({
      status,
      session_id: sessionId,
      payment_status: paymentStatus,
      mode: recorded?.mode ?? session.metadata?.mode ?? null,
      subject_keys: subjectKeys.length > 0
        ? subjectKeys
        : (session.metadata?.subject_ids ?? "").split(",").filter(Boolean),
    });
  } catch (error) {
    const stripeStatus = error && typeof error === "object" &&
        "statusCode" in error
      ? Number((error as { statusCode?: unknown }).statusCode)
      : null;
    if (stripeStatus === 404) {
      return respond({ error: "checkout_session_not_found" }, { status: 404 });
    }
    console.error("checkout-session-status failed", error);
    return respond({ error: "checkout_status_failed" }, { status: 502 });
  }
});
