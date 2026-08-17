import { jsonResponse } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { stripe, verifyStripeWebhookEvent } from "../_shared/stripe.ts";

// This function is the sole authority for granting and revoking
// Stripe-purchased entitlements, and for the purchase_completed/
// purchase_refunded/referred_purchase growth events - never the
// client-side checkout redirect. See
// docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md.

type CheckoutSessionObject = {
  id: string;
  client_reference_id: string | null;
  amount_subtotal?: number | null;
  amount_total?: number | null;
  currency: string | null;
  payment_status?: string | null;
  metadata: Record<string, string> | null;
  discounts?:
    | Array<{
      coupon?: string | { id?: string; name?: string | null } | null;
      promotion_code?:
        | string
        | { id?: string; code?: string | null; coupon?: unknown }
        | null;
    }>
    | null;
  total_details?: {
    amount_discount?: number | null;
    breakdown?: {
      discounts?:
        | Array<{
          amount?: number | null;
          discount?: {
            id?: string;
            coupon?: string | { id?: string; name?: string | null } | null;
            promotion_code?:
              | string
              | { id?: string; code?: string | null; coupon?: unknown }
              | null;
          } | null;
        }>
        | null;
    } | null;
  } | null;
};

type ChargeObject = {
  id: string;
  payment_intent: string | null;
  amount_refunded?: number | null;
  currency?: string | null;
  refunded?: boolean;
};

type Service = ReturnType<typeof createServiceClient>;
type CheckoutStatus =
  | "completed"
  | "async_payment_succeeded"
  | "async_payment_failed"
  | "expired";

function parseSubjectKeys(raw: string | undefined) {
  if (!raw) return [];
  return raw.split(",").map((entry) => entry.trim()).filter(Boolean);
}

function objectId(value: unknown) {
  if (typeof value === "string" && value) return value;
  if (value && typeof value === "object" && "id" in value) {
    const id = (value as { id?: unknown }).id;
    return typeof id === "string" && id ? id : null;
  }
  return null;
}

function promotionCode(value: unknown) {
  if (value && typeof value === "object" && "code" in value) {
    const code = (value as { code?: unknown }).code;
    return typeof code === "string" && code ? code : null;
  }
  return null;
}

function unique(values: Array<string | null>) {
  return [
    ...new Set(values.filter((value): value is string => Boolean(value))),
  ];
}

function discountDetails(session: CheckoutSessionObject) {
  const directDiscounts = session.discounts ?? [];
  const breakdownDiscounts =
    session.total_details?.breakdown?.discounts?.map((entry) => ({
      amount: entry.amount ?? null,
      coupon: entry.discount?.coupon ?? null,
      promotion_code: entry.discount?.promotion_code ?? null,
      discount_id: entry.discount?.id ?? null,
    })) ?? [];

  return [...directDiscounts, ...breakdownDiscounts].map((entry) => {
    const coupon = "coupon" in entry ? entry.coupon : null;
    const promotion = "promotion_code" in entry ? entry.promotion_code : null;
    return {
      amount: "amount" in entry ? entry.amount ?? null : null,
      discount_id: "discount_id" in entry ? entry.discount_id ?? null : null,
      coupon_id: objectId(coupon),
      coupon_name: coupon && typeof coupon === "object" && "name" in coupon
        ? (coupon as { name?: string | null }).name ?? null
        : null,
      promotion_code_id: objectId(promotion),
      promotion_code: promotionCode(promotion),
    };
  }).filter((entry) =>
    entry.coupon_id || entry.promotion_code_id || entry.amount
  );
}

async function retrieveCheckoutSession(session: CheckoutSessionObject) {
  try {
    return await stripe.checkout.sessions.retrieve(session.id, {
      expand: [
        "discounts.coupon",
        "discounts.promotion_code",
        "total_details.breakdown",
      ],
    }) as unknown as CheckoutSessionObject;
  } catch (error) {
    console.error("stripe-webhook checkout_session_retrieve_failed", error);
    return session;
  }
}

async function recordCheckoutSession(
  service: Service,
  session: CheckoutSessionObject,
  status: CheckoutStatus,
) {
  const metadata = session.metadata ?? {};
  const details = discountDetails(session);
  const userId = session.client_reference_id;

  const { error } = await service.schema("app").from("stripe_checkout_sessions")
    .upsert({
      id: session.id,
      user_id: userId,
      mode: metadata.mode ?? null,
      status,
      payment_status: session.payment_status ?? null,
      currency: session.currency ?? null,
      amount_subtotal: session.amount_subtotal ?? null,
      amount_total: session.amount_total ?? null,
      amount_discount: session.total_details?.amount_discount ?? 0,
      subject_keys: parseSubjectKeys(metadata.subject_ids),
      coupon_ids: unique(details.map((entry) => entry.coupon_id)),
      promotion_code_ids: unique(
        details.map((entry) => entry.promotion_code_id),
      ),
      promotion_codes: unique(details.map((entry) => entry.promotion_code)),
      discount_details: details,
      payload: session,
      updated_at: new Date().toISOString(),
    });
  if (error) throw error;
  return details;
}

async function grantEntitlement(service: Service, params: {
  userId: string;
  subjectId: string;
  source: string;
  allSubjects: boolean;
  checkoutSessionId: string;
  eventId: string;
}) {
  const { error } = await service.schema("app").from("subject_entitlements")
    .upsert(
      {
        user_id: params.userId,
        subject_id: params.subjectId,
        access_tier: "paid",
        status: "active",
        source: params.source,
        all_subjects: params.allSubjects,
        stripe_checkout_session_id: params.checkoutSessionId,
        stripe_event_id: params.eventId,
        starts_at: new Date().toISOString(),
        ends_at: null,
      },
      { onConflict: "user_id,subject_id,access_tier,source" },
    );
  if (error) throw error;
}

async function handleCheckoutSessionCompleted(
  service: Service,
  session: CheckoutSessionObject,
  eventId: string,
  eventType: CheckoutStatus,
) {
  const userId = session.client_reference_id;
  if (!userId) {
    throw new Error("checkout_session_missing_client_reference_id");
  }

  const metadata = session.metadata ?? {};
  const mode = metadata.mode ?? "single";
  const checkoutSessionId = session.id;

  if (mode === "unlimited") {
    const { data: subjects, error: subjectsError } = await service.schema(
      "app",
    ).from("subjects").select("id").eq("status", "active");
    if (subjectsError) throw subjectsError;
    for (const subject of subjects ?? []) {
      await grantEntitlement(service, {
        userId,
        subjectId: subject.id as string,
        source: "stripe_checkout_unlimited",
        allSubjects: true,
        checkoutSessionId,
        eventId,
      });
    }
  } else {
    const subjectKeys = parseSubjectKeys(metadata.subject_ids);
    if (subjectKeys.length === 0) {
      throw new Error("checkout_session_missing_subject_ids");
    }

    const { data: subjectRows, error: subjectsError } = await service.schema(
      "app",
    ).from("subjects").select("id, subject_key").in(
      "subject_key",
      subjectKeys,
    );
    if (subjectsError) throw subjectsError;

    const bySubjectKey = new Map(
      (subjectRows ?? []).map((
        row,
      ) => [row.subject_key as string, row.id as string]),
    );
    const missing = subjectKeys.filter((key) => !bySubjectKey.has(key));
    if (missing.length > 0) {
      throw new Error(
        `checkout_session_unknown_subject_keys:${missing.join(",")}`,
      );
    }

    const hadDiscount = Boolean(session.total_details?.amount_discount);
    const source = mode === "single"
      ? (hadDiscount
        ? "stripe_checkout_single_coupon"
        : "stripe_checkout_single")
      : "stripe_checkout_bundle";

    for (const subjectKey of subjectKeys) {
      await grantEntitlement(service, {
        userId,
        subjectId: bySubjectKey.get(subjectKey) as string,
        source,
        allSubjects: false,
        checkoutSessionId,
        eventId,
      });
    }
  }

  await recordGrowthEvent(service, {
    eventName: "purchase_completed",
    userId,
    source: "stripe",
    dedupeKey: `purchase_completed:${checkoutSessionId}`,
    properties: {
      offer: mode,
      access_tier: "paid",
      currency: session.currency ?? "usd",
      checkout_session_id: checkoutSessionId,
      stripe_event_id: eventId,
      stripe_event_type: eventType,
      amount_discount: session.total_details?.amount_discount ?? 0,
    },
  });
}

async function handleCheckoutSessionEvent(
  service: Service,
  rawSession: CheckoutSessionObject,
  eventId: string,
  status: CheckoutStatus,
) {
  const session = await retrieveCheckoutSession(rawSession);
  const discounts = await recordCheckoutSession(service, session, status);

  if (status === "completed" || status === "async_payment_succeeded") {
    if (session.payment_status && session.payment_status !== "paid") {
      await recordGrowthEvent(service, {
        eventName: "checkout_payment_pending",
        userId: session.client_reference_id ?? null,
        source: "stripe",
        dedupeKey: `checkout_payment_pending:${session.id}`,
        properties: {
          checkout_session_id: session.id,
          payment_status: session.payment_status,
          stripe_event_id: eventId,
          stripe_event_type: status,
        },
      });
      return;
    }
    await handleCheckoutSessionCompleted(service, session, eventId, status);
    return;
  }

  await recordGrowthEvent(service, {
    eventName: status === "expired"
      ? "checkout_expired"
      : "checkout_async_payment_failed",
    userId: session.client_reference_id ?? null,
    source: "stripe",
    dedupeKey: `${status}:${session.id}`,
    properties: {
      checkout_session_id: session.id,
      payment_status: session.payment_status ?? null,
      stripe_event_id: eventId,
      stripe_event_type: status,
      amount_discount: session.total_details?.amount_discount ?? 0,
      coupon_ids: unique(discounts.map((entry) => entry.coupon_id)),
      promotion_code_ids: unique(
        discounts.map((entry) => entry.promotion_code_id),
      ),
      promotion_codes: unique(discounts.map((entry) => entry.promotion_code)),
    },
  });
}

// A Charge doesn't carry the checkout session id directly -- Stripe's own
// session index (by payment_intent) is more reliable than trying to derive
// it from our stored checkout-session payload's shape, so look it up live.
async function handleChargeRefunded(
  service: Service,
  charge: ChargeObject,
  eventId: string,
) {
  const paymentIntentId = charge.payment_intent;
  if (!paymentIntentId) {
    console.warn(
      "stripe-webhook charge_refunded_missing_payment_intent",
      charge.id,
    );
    return;
  }

  const sessions = await stripe.checkout.sessions.list({
    payment_intent: paymentIntentId,
    limit: 1,
  });
  const checkoutSessionId = sessions.data[0]?.id;
  if (!checkoutSessionId) {
    console.warn(
      "stripe-webhook charge_refunded_no_matching_checkout_session",
      charge.id,
      paymentIntentId,
    );
    return;
  }

  const { data: revoked, error } = await service.schema("app")
    .from("subject_entitlements")
    .update({ status: "revoked" })
    .eq("stripe_checkout_session_id", checkoutSessionId)
    .eq("access_tier", "paid")
    .eq("status", "active")
    .select("id, user_id, subject_id");
  if (error) throw error;

  if (!revoked || revoked.length === 0) {
    console.warn(
      "stripe-webhook charge_refunded_no_active_entitlements",
      checkoutSessionId,
    );
    return;
  }

  const userId = revoked[0].user_id as string | null;
  await recordGrowthEvent(service, {
    eventName: "purchase_refunded",
    userId,
    source: "stripe",
    dedupeKey: `purchase_refunded:${checkoutSessionId}`,
    properties: {
      checkout_session_id: checkoutSessionId,
      stripe_event_id: eventId,
      currency: charge.currency ?? "usd",
    },
  });
}

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") return respond({ ok: true });
  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  // Signature verification needs the exact raw bytes Stripe signed, so the
  // body must be read as text before any JSON parsing.
  const rawBody = await req.text();
  const signature = req.headers.get("stripe-signature");

  let event;
  try {
    event = await verifyStripeWebhookEvent(rawBody, signature);
  } catch (error) {
    console.error("stripe-webhook signature_verification_failed", error);
    return respond({ error: "invalid_signature" }, { status: 400 });
  }

  const service = createServiceClient();

  // Idempotency ledger: insert-first on the Stripe event id. A primary-key
  // conflict means this event was already received (redelivery or a
  // concurrent delivery) - acknowledge without reprocessing.
  const { error: ledgerError } = await service.schema("app")
    .from("stripe_webhook_events")
    .insert({
      id: event.id,
      event_type: event.type,
      payload: JSON.parse(rawBody),
    });
  if (ledgerError) {
    if (ledgerError.code === "23505") {
      return respond({ status: "ok", duplicate: true });
    }
    console.error("stripe-webhook ledger_insert_failed", ledgerError);
    return respond({ error: "ledger_write_failed" }, { status: 500 });
  }

  try {
    if (event.type === "checkout.session.completed") {
      await handleCheckoutSessionEvent(
        service,
        event.data.object as unknown as CheckoutSessionObject,
        event.id,
        "completed",
      );
    } else if (event.type === "checkout.session.async_payment_succeeded") {
      await handleCheckoutSessionEvent(
        service,
        event.data.object as unknown as CheckoutSessionObject,
        event.id,
        "async_payment_succeeded",
      );
    } else if (event.type === "checkout.session.async_payment_failed") {
      await handleCheckoutSessionEvent(
        service,
        event.data.object as unknown as CheckoutSessionObject,
        event.id,
        "async_payment_failed",
      );
    } else if (event.type === "checkout.session.expired") {
      await handleCheckoutSessionEvent(
        service,
        event.data.object as unknown as CheckoutSessionObject,
        event.id,
        "expired",
      );
    } else if (event.type === "charge.refunded") {
      await handleChargeRefunded(
        service,
        event.data.object as unknown as ChargeObject,
        event.id,
      );
    } else {
      throw new Error(`unsupported_stripe_event_type:${event.type}`);
    }

    await service.schema("app").from("stripe_webhook_events")
      .update({ processed_at: new Date().toISOString() })
      .eq("id", event.id);

    return respond({ status: "ok" });
  } catch (error) {
    const message = error instanceof Error
      ? error.message
      : "stripe_webhook_processing_failed";
    console.error("stripe-webhook processing_failed", error);
    await service.schema("app").from("stripe_webhook_events")
      .update({ processing_error: message.slice(0, 500) })
      .eq("id", event.id);
    return respond({ error: "processing_failed" }, { status: 500 });
  }
});
