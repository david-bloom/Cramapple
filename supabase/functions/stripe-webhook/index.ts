import { jsonResponse } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { stripe, verifyStripeWebhookEvent } from "../_shared/stripe.ts";
import { isPayerNotLearner } from "../_shared/addon-checkout.ts";
import { enqueuePaymentEmail } from "../_shared/payment-email.ts";
import {
  buildPayerReceiptEmail,
  buildPayerRefundEmail,
  enqueuePayerEmail,
  payerEmailsEnabled,
} from "../_shared/payer-email.ts";
import {
  isFullyRefunded,
  isSettledPaymentStatus,
} from "../_shared/checkout-access.ts";
import {
  webhookDeliveryDisposition,
  type WebhookLedgerStatus,
} from "../_shared/stripe-webhook-ledger.ts";

function requireEnv(name: string) {
  const value = Deno.env.get(name);
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

// Used only as the redirectTo for parent-gift student invites (see
// resolveGiftStudentUserId below).
const APP_BASE_URL = requireEnv("APP_BASE_URL").replace(/\/$/, "");

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
  customer?: string | { id?: string } | null;
  payment_intent?:
    | string
    | { id?: string; payment_method?: string | { id?: string } | null }
    | null;
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
  amount?: number | null;
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
        "payment_intent.payment_method",
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

// Same account-per-email lookup used by reviewer-invite: page through
// auth.users rather than relying on a students table, since the invited
// student may not have any app.profiles row yet.
async function findAuthUserByEmail(service: Service, email: string) {
  const target = email.toLowerCase();
  const perPage = 1000;

  // Bounded at 50 pages (50k users) as a runaway-loop backstop, not a
  // real ceiling - the loop already exits early via the length check below
  // once a page comes back short.
  for (let page = 1; page <= 50; page += 1) {
    const { data, error } = await service.auth.admin.listUsers({
      page,
      perPage,
    });
    if (error) throw new Error(`auth_user_lookup_failed:${error.message}`);

    const user = data.users.find((entry) =>
      (entry.email ?? "").toLowerCase() === target
    );
    if (user) return user;
    if (data.users.length < perPage) break;
  }

  return null;
}

// Anonymous student-direct and parent-share/gift checkouts have no verified
// client_reference_id. Resolve (or create, via a branded Supabase invite)
// the learner's account from server-carried Stripe metadata so entitlement
// ownership never follows the payer.
async function resolveCheckoutStudentUserId(
  service: Service,
  metadata: Record<string, string>,
) {
  const studentEmail = metadata.student_email;
  if (!studentEmail) {
    throw new Error("checkout_session_missing_student_email");
  }

  const existing = await findAuthUserByEmail(service, studentEmail);
  if (existing) return existing.id;

  const { data, error } = await service.auth.admin.inviteUserByEmail(
    studentEmail,
    {
      data: { full_name: metadata.student_name ?? studentEmail.split("@")[0] },
      redirectTo: `${APP_BASE_URL}/welcome`,
    },
  );
  if (error) {
    throw new Error(`student_invite_failed:${error.message}`);
  }
  if (data.user) return data.user.id;

  // The invite call can succeed without echoing the user back in rare
  // races - fall back to a fresh lookup rather than failing the webhook.
  const invited = await findAuthUserByEmail(service, studentEmail);
  if (!invited) throw new Error("student_invite_user_not_found");
  return invited.id;
}

async function persistStripeCustomer(
  service: Service,
  session: CheckoutSessionObject,
  userId: string,
) {
  const stripeCustomerId = objectId(session.customer);
  if (!stripeCustomerId) return;

  const paymentIntent = session.payment_intent;
  const paymentMethodId = paymentIntent && typeof paymentIntent === "object"
    ? objectId(paymentIntent.payment_method)
    : null;

  const { error } = await service.schema("app").from("stripe_customers").upsert(
    {
      user_id: userId,
      stripe_customer_id: stripeCustomerId,
      default_payment_method_id: paymentMethodId,
      source_checkout_session_id: session.id,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "user_id" },
  );
  if (error) throw error;
}

async function handleCheckoutSessionCompleted(
  service: Service,
  session: CheckoutSessionObject,
  eventId: string,
  eventType: CheckoutStatus,
) {
  const metadata = session.metadata ?? {};
  const purchaseType = metadata.purchase_type ?? metadata.purchaser_type ?? "";
  const resolvesStudentByEmail = purchaseType === "parent_gift" ||
    purchaseType === "parent_share" ||
    purchaseType === "student_direct";
  const userId = session.client_reference_id ??
    (resolvesStudentByEmail
      ? await resolveCheckoutStudentUserId(service, metadata)
      : null);
  if (!userId) {
    throw new Error("checkout_session_missing_client_reference_id");
  }

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
    const source = metadata.purchase_type === "post_purchase_addon"
      ? "stripe_checkout_addon"
      : mode === "single"
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

  if (!isPayerNotLearner(purchaseType)) {
    await persistStripeCustomer(service, session, userId);
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

  return userId;
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
    if (
      session.payment_status && !isSettledPaymentStatus(session.payment_status)
    ) {
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
    const userId = await handleCheckoutSessionCompleted(
      service,
      session,
      eventId,
      status,
    );
    // recordCheckoutSession above ran before the gift student's account was
    // resolved (client_reference_id is null for parent-gift checkouts), so
    // the row it wrote still has user_id null for that case - backfill it
    // now that the real recipient is known.
    if (userId !== session.client_reference_id) {
      const { error } = await service.schema("app").from(
        "stripe_checkout_sessions",
      )
        .update({ user_id: userId, updated_at: new Date().toISOString() })
        .eq("id", session.id);
      if (error) throw error;
    }
    // Fulfilled access must be visible before independent notification work.
    // A queue failure can retry this webhook without hiding the paid order.
    const intentId = objectId(session.payment_intent);
    if (session.payment_status === "paid" && intentId) {
      const intent = await stripe.paymentIntents.retrieve(intentId);
      const chargeId = objectId(intent.latest_charge);
      if (!chargeId) throw new Error("checkout_fulfillment_missing_charge");
      const currentCharge = await stripe.charges.retrieve(chargeId);
      if (isFullyRefunded(currentCharge)) {
        // A refund event can be processed before this checkout event. Reconcile
        // current Stripe state after granting so replay cannot restore access.
        await handleChargeRefunded(service, {
          id: currentCharge.id,
          payment_intent: intentId,
          refunded: currentCharge.refunded,
          amount: currentCharge.amount,
          amount_refunded: currentCharge.amount_refunded,
          currency: currentCharge.currency,
        }, eventId);
        return;
      }
    }
    const metadata = session.metadata ?? {};
    await enqueueCheckoutPayerReceipt(service, session);
    await enqueuePaymentEmail(service, userId, {
      sessionId: session.id,
      purchaseType: metadata.purchase_type ?? metadata.purchaser_type ?? "",
      subjects: metadata.mode === "unlimited"
        ? "All AP subjects"
        : metadata.subject_ids ?? "",
      amountTotal: session.amount_total ?? 0,
      currency: session.currency ?? "usd",
    });
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

function purchasedSubjects(session: CheckoutSessionObject) {
  return session.metadata?.mode === "unlimited"
    ? "All AP subjects"
    : session.metadata?.subject_ids ?? "";
}

async function enqueueCheckoutPayerReceipt(
  service: Service,
  session: CheckoutSessionObject,
) {
  if (!payerEmailsEnabled() || session.payment_status !== "paid") return;
  const intentId = objectId(session.payment_intent);
  if (!intentId) throw new Error("payer_receipt_missing_payment_intent");
  const intent = await stripe.paymentIntents.retrieve(intentId);
  const chargeId = objectId(intent.latest_charge);
  if (!chargeId) throw new Error("payer_receipt_missing_charge");
  const charge = await stripe.charges.retrieve(chargeId);
  if (objectId(charge.payment_intent) !== intentId) {
    throw new Error("payer_receipt_charge_mismatch");
  }
  await enqueuePayerEmail(
    service,
    buildPayerReceiptEmail(charge, purchasedSubjects(session)),
  );
}

async function enqueueSuccessfulPayerRefund(
  service: Service,
  refundId: string,
) {
  if (!payerEmailsEnabled()) return;
  // Retrieve current state: a created event can be pending, and webhook
  // deliveries can be out of order. Only individual succeeded refunds qualify.
  const refund = await stripe.refunds.retrieve(refundId);
  if (refund.status !== "succeeded") return;
  const chargeId = objectId(refund.charge);
  if (!chargeId) throw new Error("payer_refund_missing_charge");
  const charge = await stripe.charges.retrieve(chargeId);
  const intentId = objectId(charge.payment_intent);
  if (!intentId) return;
  const sessions = await stripe.checkout.sessions.list({
    payment_intent: intentId,
    limit: 1,
  });
  const session = sessions.data[0];
  if (!session) return;
  // Scope notifications to our recorded purchases, never unrelated payments
  // in the Stripe account. A refund racing fulfillment must be retried.
  const { data: purchase, error } = await service.schema("app")
    .from("stripe_checkout_sessions").select("id").eq("id", session.id)
    .maybeSingle();
  if (error || !purchase) throw new Error("payer_refund_purchase_not_recorded");
  await enqueuePayerEmail(
    service,
    buildPayerRefundEmail(
      charge,
      refund,
      purchasedSubjects(session as unknown as CheckoutSessionObject),
    ),
  );
}

// A Charge doesn't carry the checkout session id directly -- Stripe's own
// session index (by payment_intent) is more reliable than trying to derive
// it from our stored checkout-session payload's shape, so look it up live.
async function handleChargeRefunded(
  service: Service,
  charge: ChargeObject,
  eventId: string,
) {
  // A partial refund (goodwill, price adjustment) must not end access. The
  // final refund that completes the charge arrives as its own event with
  // `refunded: true`, and that one revokes.
  if (!isFullyRefunded(charge)) {
    console.warn(
      "stripe-webhook charge_partially_refunded_access_kept",
      charge.id,
      charge.amount_refunded ?? null,
      charge.amount ?? null,
    );
    return;
  }

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

  // Insert-first preserves idempotency. A redelivery may claim a prior failed
  // attempt (or one abandoned for at least five minutes), but processed events
  // and active concurrent attempts never run twice.
  const attemptStartedAt = new Date().toISOString();
  const { error: ledgerError } = await service.schema("app")
    .from("stripe_webhook_events")
    .insert({
      id: event.id,
      event_type: event.type,
      payload: JSON.parse(rawBody),
      status: "processing",
      attempt_count: 1,
      last_attempt_at: attemptStartedAt,
    });
  if (ledgerError) {
    if (ledgerError.code === "23505") {
      const { data: claimed, error: claimError } = await service.schema("app")
        .rpc("claim_stripe_webhook_event", { p_event_id: event.id });
      if (claimError) {
        console.error("stripe-webhook ledger_claim_failed", claimError);
        return respond({ error: "ledger_claim_failed" }, { status: 500 });
      }
      if (!claimed) {
        const { data: existing, error: existingError } = await service.schema(
          "app",
        ).from("stripe_webhook_events")
          .select("status,processed_at")
          .eq("id", event.id)
          .maybeSingle();
        if (existingError || !existing) {
          console.error(
            "stripe-webhook ledger_status_failed",
            existingError,
          );
          return respond({ error: "ledger_status_failed" }, { status: 500 });
        }
        const disposition = webhookDeliveryDisposition({
          status: existing.status as WebhookLedgerStatus | null,
          processedAt: existing.processed_at,
        });
        if (disposition === "retryable") {
          return respond({ error: "ledger_claim_race" }, { status: 500 });
        }
        return respond({
          status: "ok",
          duplicate: disposition === "already_processed",
          processing: disposition === "in_progress",
        });
      }
    } else {
      console.error("stripe-webhook ledger_insert_failed", ledgerError);
      return respond({ error: "ledger_write_failed" }, { status: 500 });
    }
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
    } else if (
      event.type === "refund.created" || event.type === "refund.updated"
    ) {
      await enqueueSuccessfulPayerRefund(service, event.data.object.id);
    } else {
      throw new Error(`unsupported_stripe_event_type:${event.type}`);
    }

    const { error: processedLedgerError } = await service.schema("app").from(
      "stripe_webhook_events",
    )
      .update({
        status: "processed",
        processed_at: new Date().toISOString(),
        processing_error: null,
      })
      .eq("id", event.id);
    if (processedLedgerError) {
      throw new Error(
        `webhook_ledger_mark_processed_failed:${processedLedgerError.message}`,
      );
    }

    return respond({ status: "ok" });
  } catch (error) {
    const message = error instanceof Error
      ? error.message
      : "stripe_webhook_processing_failed";
    console.error("stripe-webhook processing_failed", error);
    await service.schema("app").from("stripe_webhook_events")
      .update({
        status: "failed",
        processing_error: message.slice(0, 500),
      })
      .eq("id", event.id);
    return respond({ error: "processing_failed" }, { status: 500 });
  }
});
