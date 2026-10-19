// Card-trial webhook handlers (TASK-0077 plan §6.4, §6.5, §6.7, §6.8).
// Dependencies are injected so the handlers can be tested without Stripe or
// Supabase.

import { TRIAL_DAYS } from "../_shared/trial-core.ts";
import type { GrowthEventName } from "../_shared/growth-events.ts";
import type { LearnerResult } from "../_shared/trial-learner.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

export type TrialWebhookDeps = {
  stripe: Any;
  service: Any;
  // Find or invite the learner by the order's student email (as the paid
  // path does for student_direct and parent_share).
  resolveLearner: (email: string, name: string | null) => Promise<LearnerResult>;
  recordGrowthEvent: (event: {
    eventName: GrowthEventName;
    userId: string | null;
    dedupeKey: string;
    properties: Record<string, unknown>;
  }) => Promise<void>;
  log: (message: string, detail: Record<string, unknown>) => void;
  // The Terms version the parent accepted on Stripe's page.
  termsVersion: string;
};

type TrialOrder = {
  id: string;
  purchase_type: "student_direct" | "parent_share";
  status: string;
  student_email_norm: string;
  student_name: string | null;
  checkout_session_id: string | null;
  stripe_customer_id: string | null;
  payment_method_id: string | null;
  payment_intent_id: string | null;
  charge_amount: number;
  currency: string;
  offer: string;
  subject_keys: string[];
};

function id(value: unknown): string | null {
  if (typeof value === "string" && value) return value;
  if (value && typeof value === "object" && "id" in value) {
    const v = (value as { id?: unknown }).id;
    return typeof v === "string" && v ? v : null;
  }
  return null;
}

async function loadOrder(service: Any, column: string, value: string): Promise<TrialOrder | null> {
  const { data, error } = await service.schema("app").from("trial_orders")
    .select("*").eq(column, value).maybeSingle();
  if (error) throw error;
  return data;
}

async function refuse(deps: TrialWebhookDeps, order: TrialOrder, reason: string, pmId: string | null) {
  // Before activation nothing was granted. Release the order and, for a
  // parent, remove the saved card (DECISION-0126 item 2). The card's id is
  // stored with the refusal, so if the detach below fails the charge
  // worker's clean-up (which covers activation_refused and only marks
  // itself done after a successful detach) retries it.
  const { error } = await deps.service.schema("app").from("trial_orders")
    .update({
      status: "activation_refused",
      reconcile_reason: reason,
      promo_use_state: null,
      ...(pmId ? { payment_method_id: pmId } : {}),
      updated_at: new Date().toISOString(),
    })
    .eq("id", order.id).eq("status", "pending_setup");
  if (error) throw error;
  if (pmId && order.purchase_type === "parent_share") {
    await deps.stripe.paymentMethods.detach(pmId).catch(() => {
      // Left for the clean-up worker.
    });
  }
  deps.log("trial_activation_refused", { order_id: order.id, reason });
}

// checkout.session.completed / .expired for a setup session that claims a
// trial (routeCheckoutSession → "trial_setup").
export async function handleTrialSetupSession(
  deps: TrialWebhookDeps,
  session: Any,
  status: "completed" | "async_payment_succeeded" | "async_payment_failed" | "expired",
  eventCreated: number,
) {
  const orderId = session.metadata?.trial_order_id;
  const order = orderId ? await loadOrder(deps.service, "id", orderId) : null;
  if (!order) {
    deps.log("trial_setup_unknown_order", { checkout_session_id: session.id, order_id: orderId ?? null });
    return;
  }
  if (order.checkout_session_id !== session.id) {
    // A superseded session (the buyer refreshed the quote). Never activate
    // from it; an operator reconciles a card saved on it.
    deps.log("trial_setup_superseded_session", { checkout_session_id: session.id, order_id: order.id });
    return;
  }

  if (status === "expired" || status === "async_payment_failed") {
    if (order.status === "pending_setup") {
      const { error } = await deps.service.schema("app").from("trial_orders")
        .update({ status: "setup_expired", promo_use_state: null, updated_at: new Date().toISOString() })
        .eq("id", order.id).eq("status", "pending_setup");
      if (error) throw error;
    }
    return;
  }
  if (order.status !== "pending_setup") {
    deps.log("trial_setup_replay", { order_id: order.id, status: order.status });
    return;
  }

  const setupIntent = await deps.stripe.setupIntents.retrieve(id(session.setup_intent), {
    expand: ["payment_method"],
  });
  const customerId = id(session.customer);
  const paymentMethod = setupIntent.payment_method;
  const pmId = id(paymentMethod);
  const expectedCustomer = order.purchase_type === "student_direct" ? order.stripe_customer_id : customerId;

  if (setupIntent.status !== "succeeded") return refuse(deps, order, "setup_not_succeeded", pmId);
  if (setupIntent.usage !== "off_session") return refuse(deps, order, "setup_usage_not_off_session", pmId);
  if (!customerId || customerId !== expectedCustomer || id(setupIntent.customer) !== customerId) {
    return refuse(deps, order, "setup_customer_mismatch", pmId);
  }
  if (!pmId || id(paymentMethod?.customer) !== customerId) {
    // Never attach to repair a mismatch (plan §6.4 step 1).
    return refuse(deps, order, "payment_method_not_attached", pmId);
  }
  // The mandate says "this card". Link is hidden on trial sessions; a
  // bank-funded Link method that still arrives (brand "link") is not a card.
  if ((paymentMethod?.type && paymentMethod.type !== "card") || paymentMethod?.card?.brand === "link") {
    return refuse(deps, order, "payment_method_not_card", pmId);
  }

  let payerEmail = order.student_email_norm;
  let payerAccept: { version: string; source: string } | null = null;
  if (order.purchase_type === "parent_share") {
    if (session.consent?.terms_of_service !== "accepted") {
      return refuse(deps, order, "parent_terms_not_accepted", pmId);
    }
    const email = session.customer_details?.email;
    if (!email) return refuse(deps, order, "parent_email_missing", pmId);
    payerEmail = String(email);
    payerAccept = {
      version: deps.termsVersion,
      source: "stripe_consent_collection",
    };
  }

  // No email is sent here (trial-learner.ts): activation never waits on mail.
  const learner = await deps.resolveLearner(order.student_email_norm, order.student_name);
  if ("refused" in learner) return refuse(deps, order, learner.refused, pmId);
  const userId = learner.userId;

  // Create the order's single PaymentIntent first, unconfirmed; its id is
  // recorded in the same transaction as the grant (plan §6.4 steps 4-5).
  // A replay finds it by listing the customer's intents (list, not search:
  // search can lag).
  const existing = await deps.stripe.paymentIntents.list({ customer: customerId, limit: 100 });
  let intent = (existing.data ?? []).find((pi: Any) =>
    pi.metadata?.trial_order_id === order.id && pi.status !== "canceled"
  );
  if (!intent) {
    intent = await deps.stripe.paymentIntents.create({
      amount: order.charge_amount,
      currency: order.currency,
      allowed_payment_method_types: ["card"],
      customer: customerId,
      payment_method: pmId,
      description: `Cramapple ${order.subject_keys.join(", ")} (after 7-day free trial)`,
      metadata: { kind: "trial_conversion", trial_order_id: order.id },
    }, { idempotencyKey: `trial-pi:${order.id}` });
  }

  // The event's creation time: a Checkout Session has no completion
  // timestamp, and this one does not change across replays.
  const startedAt = new Date(eventCreated * 1000).toISOString();
  const { data: result, error } = await deps.service.schema("app").rpc("trial_activate", {
    p_order_id: order.id,
    p_user_id: userId,
    p_payment_intent_id: intent.id,
    p_setup_intent_id: setupIntent.id,
    p_payment_method_id: pmId,
    p_payer_email: payerEmail,
    p_started_at: startedAt,
    p_payer_accept_version: payerAccept?.version ?? null,
    p_payer_accept_source: payerAccept?.source ?? null,
  });
  if (error) throw error;

  if (result === "activated" || result === "already_active") {
    if (order.purchase_type === "student_direct") {
      // Only the learner's own card is ever stored against them.
      const { error: mapError } = await deps.service.schema("app").from("stripe_customers").upsert({
        user_id: userId,
        stripe_customer_id: customerId,
        default_payment_method_id: pmId,
        source_checkout_session_id: session.id,
        updated_at: new Date().toISOString(),
      }, { onConflict: "user_id" });
      if (mapError) throw mapError;
    }
    await deps.recordGrowthEvent({
      eventName: "trial_card_started",
      userId,
      dedupeKey: `trial_card_started:${order.id}`,
      properties: { offer: order.offer, access_tier: "trial", trial_days: TRIAL_DAYS },
    });
    return;
  }

  // email_consumed or bad_state: nothing was granted; undo the intent.
  await deps.stripe.paymentIntents.cancel(intent.id).catch(() => {});
  if (order.purchase_type === "parent_share") {
    await deps.stripe.paymentMethods.detach(pmId).catch(() => {});
  }
  deps.log("trial_activation_not_applied", { order_id: order.id, result });
}

// payment_intent.* with metadata.kind = "trial_conversion".
export async function handleTrialPaymentIntent(
  deps: TrialWebhookDeps,
  eventType: string,
  intent: Any,
) {
  const orderId = intent.metadata?.trial_order_id;
  if (!orderId) return;
  if (eventType !== "payment_intent.succeeded") {
    // The worker classifies failures from the confirm response itself; the
    // recovery page shows on-session failures to the payer.
    deps.log("trial_payment_intent_event", { order_id: orderId, type: eventType, status: intent.status });
    return;
  }
  const { data: result, error } = await deps.service.schema("app").rpc("trial_convert", {
    p_order_id: orderId,
    p_payment_intent_id: intent.id,
    p_amount_received: intent.amount_received ?? 0,
    p_currency: intent.currency ?? "usd",
  });
  if (error) throw error;

  if (result === "converted") {
    const order = await loadOrder(deps.service, "id", orderId);
    await deps.recordGrowthEvent({
      eventName: "trial_converted",
      userId: (order as Any)?.user_id ?? null,
      dedupeKey: `trial_converted:${orderId}`,
      properties: { offer: order?.offer ?? null, amount: intent.amount_received ?? null },
    });
    return;
  }
  if (result === "refund_required") {
    // A charge that lands after a cancel is refunded in full automatically
    // (DECISION-0126 item 19). Never a grant.
    await deps.stripe.refunds.create(
      { payment_intent: intent.id, reason: "requested_by_customer", metadata: { trial_order_id: orderId } },
      { idempotencyKey: `trial-cancel-refund:${orderId}` },
    );
    const { error: outcomeError } = await deps.service.schema("app").rpc("trial_set_cancel_outcome", {
      p_order_id: orderId,
      p_outcome: "refunded",
    });
    if (outcomeError) throw outcomeError;
    return;
  }
  if (result === "already_refunded") {
    // The full refund's event arrived first; it is terminal. No grant, no
    // second refund.
    deps.log("trial_success_after_refund", { order_id: orderId, payment_intent_id: intent.id });
    return;
  }
  if (result === "mismatch" || result === "not_found") {
    deps.log("trial_conversion_needs_review", { order_id: orderId, payment_intent_id: intent.id, result });
  }
}

// charge.refunded: returns true when the charge belongs to a trial order.
export async function handleTrialChargeRefunded(
  deps: TrialWebhookDeps,
  charge: Any,
  fullyRefunded: boolean,
) {
  const intentId = id(charge.payment_intent);
  if (!intentId) return false;
  const order = await loadOrder(deps.service, "payment_intent_id", intentId);
  if (!order) return false;
  const { error } = await deps.service.schema("app").rpc("trial_mark_refunded", {
    p_order_id: order.id,
    p_full: fullyRefunded,
  });
  if (error) throw error;
  return true;
}

// charge.dispute.created: revoke a trial order's access; never re-grant
// automatically (plan §6.8).
export async function handleDispute(deps: TrialWebhookDeps, dispute: Any) {
  const intentId = id(dispute.payment_intent);
  const order = intentId ? await loadOrder(deps.service, "payment_intent_id", intentId) : null;
  if (order) {
    const { error } = await deps.service.schema("app").rpc("trial_mark_disputed", { p_order_id: order.id });
    if (error) throw error;
  }
  deps.log("dispute_created", {
    dispute_id: dispute.id,
    payment_intent_id: intentId,
    trial_order_id: order?.id ?? null,
    reason: dispute.reason ?? null,
  });
}
