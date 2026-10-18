// Cancel and recovery actions on a card-trial order (TASK-0077 plan §6.6,
// §6.7; DECISION-0126 items 4, 10, 15, 19).

import { easternDate, formatUsd, hashCapabilityToken, looksLikeCapabilityToken } from "./trial-core.ts";
import { subjectList } from "./trial-notices.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

export type CancelOutcome = "no_charge" | "pending" | "refunded";

export const CANCEL_MESSAGES: Record<CancelOutcome, string> = {
  no_charge: "Cancelled. You won't be charged.",
  pending:
    "Cancelled. A charge was already being processed; if it goes through we'll refund it in full automatically.",
  refunded: "Cancelled and refunded.",
};

// Statuses a payer can still pay from (recovery page).
export const RECOVERABLE = new Set(["payment_failed", "requires_action", "recovery_only", "delayed_notice"]);
export const MAX_RECOVERY_ATTEMPTS = 5;

export async function resolveCapability(
  service: Any,
  token: unknown,
  purpose: "parent_cancel" | "payer_recovery",
  now: Date,
): Promise<string | null> {
  if (!looksLikeCapabilityToken(token)) return null;
  const { data, error } = await service.schema("app").from("trial_capabilities")
    .select("order_id, expires_at, voided_at, purpose")
    .eq("token_hash", await hashCapabilityToken(token))
    .maybeSingle();
  if (error) throw error;
  if (!data || data.purpose !== purpose || data.voided_at || new Date(data.expires_at) <= now) return null;
  return data.order_id;
}

// A sanitized view for the cancel and recovery pages and Account.
export function orderView(o: Any) {
  return {
    order_id: o.id,
    status: o.status,
    subjects: subjectList(o.subject_keys ?? []),
    subject_keys: o.subject_keys ?? [],
    amount: formatUsd(o.charge_amount),
    charge_amount: o.charge_amount,
    trial_ends_at: o.trial_ends_at,
    trial_ends_eastern: o.trial_ends_at ? easternDate(new Date(o.trial_ends_at)) : null,
    grace_ends_eastern: o.grace_ends_at ? easternDate(new Date(o.grace_ends_at)) : null,
    recovery_deadline_eastern: o.recovery_expires_at ? easternDate(new Date(o.recovery_expires_at)) : null,
    paid_by_parent: o.purchase_type === "parent_share",
    can_cancel: ["pending_setup", "trialing", "charging", "payment_failed", "requires_action", "recovery_only", "delayed_notice"]
      .includes(o.status),
    can_pay: RECOVERABLE.has(o.status),
    cancel_outcome: o.cancel_outcome ?? null,
  };
}

// Always stops future collection and ends this order's trial access now;
// then settles the PaymentIntent and reports the outcome only once known.
export async function cancelTrialOrder(
  deps: { service: Any; stripe: Any },
  orderId: string,
  actor: "student" | "parent" | "deletion" | "operator",
): Promise<{ result: string; outcome: CancelOutcome | null; message: string | null }> {
  const { data: res, error } = await deps.service.schema("app").rpc("trial_cancel", {
    p_order_id: orderId,
    p_actor: actor,
  });
  if (error) throw error;
  if (res.result === "already_canceled") {
    const outcome = (res.cancel_outcome ?? null) as CancelOutcome | null;
    return { result: res.result, outcome, message: outcome ? CANCEL_MESSAGES[outcome] : null };
  }
  if (res.result !== "canceled") return { result: res.result, outcome: null, message: null };

  let outcome: CancelOutcome = "no_charge";
  if (res.payment_intent_id) {
    const pi = await deps.stripe.paymentIntents.retrieve(res.payment_intent_id);
    if (["requires_payment_method", "requires_confirmation", "requires_action"].includes(pi.status)) {
      try {
        await deps.stripe.paymentIntents.cancel(pi.id);
      } catch {
        // It moved under us (a charge in flight): report pending; the webhook
        // refunds a success automatically.
        outcome = "pending";
      }
    } else if (pi.status === "processing") {
      outcome = "pending";
    } else if (pi.status === "succeeded") {
      await deps.stripe.refunds.create(
        { payment_intent: pi.id, reason: "requested_by_customer", metadata: { trial_order_id: orderId } },
        { idempotencyKey: `trial-cancel-refund:${orderId}` },
      );
      outcome = "refunded";
    }
  }
  const { error: outcomeError } = await deps.service.schema("app").rpc("trial_set_cancel_outcome", {
    p_order_id: orderId,
    p_outcome: outcome,
  });
  if (outcomeError) throw outcomeError;
  return { result: "canceled", outcome, message: CANCEL_MESSAGES[outcome] };
}

// The payer confirms the order's own PaymentIntent on-session (authenticate
// the saved card or enter a new one). No new charge object is ever created.
export async function recoveryClientSecret(
  deps: { service: Any; stripe: Any },
  order: Any,
): Promise<{ client_secret: string } | { error: string }> {
  if (!RECOVERABLE.has(order.status)) return { error: "not_recoverable" };
  if (order.recovery_attempts >= MAX_RECOVERY_ATTEMPTS) return { error: "too_many_attempts" };
  const { error } = await deps.service.schema("app").from("trial_orders")
    .update({ recovery_attempts: order.recovery_attempts + 1, updated_at: new Date().toISOString() })
    .eq("id", order.id).eq("recovery_attempts", order.recovery_attempts);
  if (error) throw error;
  const pi = await deps.stripe.paymentIntents.retrieve(order.payment_intent_id);
  if (pi.status === "succeeded" || pi.status === "processing") return { error: "already_paid" };
  if (pi.status === "canceled") return { error: "not_recoverable" };
  return { client_secret: pi.client_secret };
}
