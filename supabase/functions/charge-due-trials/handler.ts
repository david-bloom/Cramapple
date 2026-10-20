// Day-7 trial charges (TASK-0077 plan §6.5, §6.6, §6.12).
//
// One PaymentIntent per order, for life: it was created unconfirmed at
// activation; this worker confirms it off-session for the first attempt, the
// one retry and any delayed charge. A transport error is never a decline and
// never triggers a new attempt; the order goes to reconciling.

import { type AttemptOutcome, classifyConfirmError } from "../_shared/trial-core.ts";
import { resumeUnsettledCancellations } from "../_shared/trial-actions.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

export type ChargeDeps = {
  stripe: Any;
  service: Any;
  chargesEnabled: boolean;
  log: (message: string, detail: Record<string, unknown>) => void;
};

type ClaimedOrder = {
  id: string;
  purchase_type: string;
  payment_intent_id: string;
  payment_method_id: string;
  charge_amount: number;
  charge_phase: "first" | "retry" | "delayed" | "reconcile";
  attempt_count: number;
  lease_token: string;
};

type Outcome = AttemptOutcome | "succeeded_observed" | "processing";

async function record(deps: ChargeDeps, order: ClaimedOrder, outcome: Outcome, code: string | null = null, decline: string | null = null) {
  const { data, error } = await deps.service.schema("app").rpc("trial_record_attempt", {
    p_order_id: order.id,
    p_lease_token: order.lease_token,
    p_outcome: outcome,
    p_error_code: code,
    p_decline_code: decline,
  });
  if (error) throw error;
  return data as string;
}

function fromIntentStatus(status: string): Outcome | null {
  if (status === "succeeded") return "succeeded_observed";
  if (status === "processing") return "processing";
  if (status === "canceled") return "canceled_observed";
  if (status === "requires_action") return "requires_action";
  return null;
}

export async function chargeOrder(deps: ChargeDeps, order: ClaimedOrder): Promise<string> {
  const intent = await deps.stripe.paymentIntents.retrieve(order.payment_intent_id);
  // Its real state decides first: never charge again what already moved.
  const observed = fromIntentStatus(intent.status);
  if (observed) return record(deps, order, observed);
  if (intent.amount !== order.charge_amount) {
    return record(deps, order, "transport_error", "payment_intent_amount_mismatch");
  }

  if (order.charge_phase === "reconcile" && intent.status === "requires_payment_method" && intent.last_payment_error) {
    // A previous attempt was declined but its result was never written.
    const c = classifyConfirmError(intent.last_payment_error);
    return record(deps, order, c.outcome, c.code, c.declineCode);
  }

  try {
    const confirmed = await deps.stripe.paymentIntents.confirm(
      intent.id,
      { payment_method: order.payment_method_id, off_session: true },
      // Same business attempt → same key; a reconcile reuses the key of the
      // attempt that was in flight.
      { idempotencyKey: `trial-confirm:${order.id}:${order.attempt_count}` },
    );
    const after = fromIntentStatus(confirmed.status);
    if (after) return record(deps, order, after);
    if (confirmed.status === "requires_payment_method") {
      const c = classifyConfirmError(confirmed.last_payment_error ?? {});
      return record(deps, order, c.outcome === "transport_error" ? "declined_hard" : c.outcome, c.code, c.declineCode);
    }
    return record(deps, order, "transport_error", `unexpected_status:${confirmed.status}`);
  } catch (error) {
    const c = classifyConfirmError(error);
    return record(deps, order, c.outcome, c.code, c.declineCode);
  }
}

// Stripe clean-up for finished orders: cancel an unused PaymentIntent and
// remove a parent's card (DECISION-0126 item 2). Direct cards are kept; they
// may back the student's other purchases.
export async function cleanUpFinishedOrders(deps: ChargeDeps, limit = 20) {
  const app = deps.service.schema("app");
  const { data: orders, error } = await app.from("trial_orders")
    .select("id, purchase_type, status, payment_intent_id, payment_method_id")
    .in("status", ["recovery_expired", "activation_refused", "setup_expired", "canceled", "converted", "refunded", "disputed"])
    .is("stripe_cleanup_done_at", null)
    .limit(limit);
  if (error) throw error;
  let cleaned = 0;
  for (const o of orders ?? []) {
    try {
      if (o.payment_intent_id && o.status !== "converted" && o.status !== "refunded" && o.status !== "disputed") {
        const pi = await deps.stripe.paymentIntents.retrieve(o.payment_intent_id);
        if (["requires_payment_method", "requires_confirmation", "requires_action"].includes(pi.status)) {
          await deps.stripe.paymentIntents.cancel(o.payment_intent_id);
        } else if (pi.status === "processing") {
          continue; // try again next run
        }
      }
      if (o.purchase_type === "parent_share" && o.payment_method_id) {
        await deps.stripe.paymentMethods.detach(o.payment_method_id).catch((e: Any) => {
          if (e?.code !== "resource_missing" && !/not attached/i.test(String(e?.message))) throw e;
        });
      }
      const { error: doneError } = await app.from("trial_orders")
        .update({ stripe_cleanup_done_at: new Date().toISOString() }).eq("id", o.id);
      if (doneError) throw doneError;
      cleaned++;
    } catch (e) {
      deps.log("trial_cleanup_failed", { order_id: o.id, error: e instanceof Error ? e.message : String(e) });
    }
  }
  return cleaned;
}

export async function runChargeWorker(deps: ChargeDeps) {
  const app = deps.service.schema("app");
  // The sweep always runs: with charges switched off, overdue orders still get
  // the 48-hour notice and keep access (plan §6.12).
  const { data: sweep, error: sweepError } = await app.rpc("trial_sweep");
  if (sweepError) throw sweepError;
  // Before clean-up, which would otherwise cancel the intent of a
  // cancellation whose outcome was never recorded.
  const resettled = await resumeUnsettledCancellations(deps, new Date());
  const cleaned = await cleanUpFinishedOrders(deps);

  const results: Record<string, number> = {};
  if (deps.chargesEnabled) {
    const { data: claimed, error } = await app.rpc("trial_claim_due", { p_limit: 10 });
    if (error) throw error;
    for (const order of (claimed ?? []) as ClaimedOrder[]) {
      try {
        const status = await chargeOrder(deps, order);
        results[status] = (results[status] ?? 0) + 1;
      } catch (e) {
        // The lease expires and the next run reconciles from the intent.
        deps.log("trial_charge_failed", { order_id: order.id, error: e instanceof Error ? e.message : String(e) });
        results.error = (results.error ?? 0) + 1;
      }
    }
  }

  const summary = { sweep, resettled, cleaned, charges_enabled: deps.chargesEnabled, results };
  await app.from("trial_worker_heartbeat").upsert(
    { worker: "charge", last_run_at: new Date().toISOString(), last_summary: summary },
    { onConflict: "worker" },
  );
  return summary;
}
