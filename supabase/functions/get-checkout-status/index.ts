import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";
import {
  isPayerNotLearner,
  purchaserTypeFromMetadata,
} from "../_shared/addon-checkout.ts";
import {
  checkoutAccess,
  isSettledPaymentStatus,
} from "../_shared/checkout-access.ts";

function requireEnv(name: string) {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`Missing required environment variable: ${name}`);
  return value;
}

const APP_BASE_URL = requireEnv("APP_BASE_URL").replace(/\/$/, "");

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
      "id,user_id,mode,status,payment_status,subject_keys,amount_total,amount_discount,metadata:payload->metadata",
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

  const failed = stored.status === "async_payment_failed" ||
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
  const metadata = (stored.metadata ?? {}) as Record<string, unknown>;
  const purchaserType = purchaserTypeFromMetadata(metadata);
  const payerNotLearner = isPayerNotLearner(purchaserType);
  let entitled = false;
  let refunded = false;

  const settled = isSettledPaymentStatus(stored.payment_status);
  if (stored.user_id && settled) {
    const { data: entitlements, error: entitlementError } = await service
      .schema("app")
      .from("subject_entitlements")
      .select("status")
      .eq("user_id", stored.user_id)
      .eq("stripe_checkout_session_id", sessionId)
      .eq("access_tier", "paid");

    if (entitlementError) {
      console.error(
        "get-checkout-status entitlement_lookup_failed",
        entitlementError,
      );
      return respond({ error: "status_lookup_failed" }, { status: 500 });
    }

    const expectedCount = stored.mode === "unlimited"
      ? 1
      : Math.max(subjectKeys.length, 1);
    const access = checkoutAccess(
      (entitlements ?? []).map((row) => String(row.status)),
      expectedCount,
    );
    entitled = access === "entitled";
    refunded = access === "refunded";
  }

  let offer = null;
  if (
    entitled && stored.payment_status === "paid" && stored.mode === "single" &&
    stored.user_id && !payerNotLearner
  ) {
    const { count: activeSubjectCount } = await service.schema("app")
      .from("subjects")
      .select("id", { count: "exact", head: true })
      .eq("status", "active");

    if ((activeSubjectCount ?? 0) > subjectKeys.length) {
      offer = {
        id: "bundle_2_upgrade",
        title: "Add another AP subject",
        description: "Complete your 2-subject bundle for $30.00 total extra.",
        price_label: "$30.00",
        url: `${APP_BASE_URL}/checkout/add-on?session_id=${
          encodeURIComponent(sessionId)
        }`,
      };
    }
  }

  return respond({
    status: "ok",
    // A $0 (coupon) order reports "paid" once entitled: the screens only need
    // to know access is confirmed, not how much was charged.
    payment_status: settled
      ? (entitled ? "paid" : refunded ? "refunded" : "processing")
      : stored.payment_status ?? "processing",
    entitled,
    subject_keys: subjectKeys,
    purchaser_type: purchaserType,
    // The parent confirmation names the student by first name only; the
    // student's email is never returned (DECISION-0090).
    student_first_name: payerNotLearner
      ? (asString(metadata.student_name)?.split(/\s+/)[0] ?? null)
      : null,
    offer,
  });
});
