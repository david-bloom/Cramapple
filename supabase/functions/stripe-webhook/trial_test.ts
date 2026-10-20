import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  handleDispute,
  handleTrialChargeRefunded,
  handleTrialPaymentIntent,
  handleTrialSetupSession,
  type TrialWebhookDeps,
} from "./trial.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

function order(over: Any = {}) {
  return {
    id: "order-1",
    purchase_type: "student_direct",
    status: "pending_setup",
    student_email_norm: "kid@example.com",
    student_name: null,
    checkout_session_id: "cs_1",
    stripe_customer_id: "cus_1",
    payment_method_id: null,
    payment_intent_id: null,
    charge_amount: 1999,
    currency: "usd",
    offer: "single",
    subject_keys: ["biology"],
    user_id: "user-1",
    ...over,
  };
}

function harness(opts: { order?: Any; activate?: string; convert?: string; existingPi?: Any; learner?: Any; pm?: Any } = {}) {
  const calls: Any[] = [];
  const rows = opts.order === null ? [] : [opts.order ?? order()];
  const service = {
    schema: () => ({
      from: (table: string) => {
        const filters: Array<[string, unknown]> = [];
        let patch: Any = null;
        const b: Any = {
          select: () => b,
          eq: (c: string, v: unknown) => { filters.push([c, v]); return b; },
          is: () => b,
          update: (p: Any) => { patch = p; return b; },
          upsert: (row: Any) => { calls.push(["upsert", table, row]); return Promise.resolve({ error: null }); },
          maybeSingle: () =>
            Promise.resolve({ data: rows.find((r) => filters.every(([c, v]) => r[c] === v)) ?? null, error: null }),
          then: (resolve: Any) => {
            if (patch) calls.push(["update", table, patch]);
            return resolve({ error: null });
          },
        };
        return b;
      },
      rpc: (fn: string, args: Any) => {
        calls.push(["rpc", fn, args]);
        const data = fn === "trial_activate" ? (opts.activate ?? "activated")
          : fn === "trial_convert" ? (opts.convert ?? "converted")
          : "ok";
        return Promise.resolve({ data, error: null });
      },
    }),
  };
  const stripe = {
    setupIntents: {
      retrieve: (_id: string) =>
        Promise.resolve({
          id: "seti_1",
          status: "succeeded",
          usage: "off_session",
          customer: "cus_1",
          payment_method: opts.pm ?? { id: "pm_1", customer: "cus_1" },
        }),
    },
    paymentIntents: {
      list: () => Promise.resolve({ data: opts.existingPi ? [opts.existingPi] : [] }),
      create: (p: Any, o: Any) => { calls.push(["pi.create", p, o]); return Promise.resolve({ id: "pi_new" }); },
      cancel: (id: string) => { calls.push(["pi.cancel", id]); return Promise.resolve({}); },
    },
    paymentMethods: { detach: (id: string) => { calls.push(["pm.detach", id]); return Promise.resolve({}); } },
    refunds: { create: (p: Any, o: Any) => { calls.push(["refund", p, o]); return Promise.resolve({ id: "re_1" }); } },
  };
  const deps: TrialWebhookDeps = {
    stripe,
    service,
    resolveLearner: () => Promise.resolve(opts.learner ?? { userId: "user-1" }),
    recordGrowthEvent: (e) => { calls.push(["event", e.eventName]); return Promise.resolve(); },
    log: (m) => calls.push(["log", m]),
    termsVersion: "terms-1",
  };
  return { deps, calls, stripe };
}

const directSession = {
  id: "cs_1",
  mode: "setup",
  customer: "cus_1",
  setup_intent: "seti_1",
  metadata: { kind: "trial_setup", trial_order_id: "order-1" },
};
const EVENT_CREATED = 1_792_000_000;

Deno.test("direct activation: one unconfirmed PI, activated at the event time, own card mapped", async () => {
  const h = harness();
  await handleTrialSetupSession(h.deps, directSession, "completed", EVENT_CREATED);
  const create = h.calls.find((c) => c[0] === "pi.create");
  assertEquals([create[1].amount, create[1].payment_method, create[1].metadata.kind, create[2].idempotencyKey],
    [1999, "pm_1", "trial_conversion", "trial-pi:order-1"]);
  assertEquals("confirm" in create[1], false);
  assertEquals(create[1].allowed_payment_method_types, ["card"]);
  const activate = h.calls.find((c) => c[0] === "rpc" && c[1] === "trial_activate")[2];
  assertEquals([activate.p_payment_intent_id, activate.p_started_at, activate.p_payer_email],
    ["pi_new", new Date(EVENT_CREATED * 1000).toISOString(), "kid@example.com"]);
  assertEquals(h.calls.some((c) => c[0] === "upsert" && c[1] === "stripe_customers"), true);
  assertEquals(h.calls.some((c) => c[0] === "event" && c[1] === "trial_card_started"), true);
});

Deno.test("an address auth rejects refuses activation durably: no PI, no grant, parent card removed", async () => {
  const h = harness({ order: order({ purchase_type: "parent_share" }), learner: { refused: "student_email_invalid" } });
  await handleTrialSetupSession(h.deps, { ...directSession, consent: { terms_of_service: "accepted" }, customer_details: { email: "parent@example.com" } }, "completed", EVENT_CREATED);
  assertEquals(h.calls.find((c) => c[0] === "update")?.[2].status, "activation_refused");
  assertEquals(h.calls.find((c) => c[0] === "update")?.[2].reconcile_reason, "student_email_invalid");
  assertEquals(h.calls.some((c) => c[0] === "pi.create" || (c[0] === "rpc" && c[1] === "trial_activate")), false);
  assertEquals(h.calls.some((c) => c[0] === "pm.detach"), true);
  // The card id is stored with the refusal, so a failed detach is retried by clean-up.
  assertEquals(h.calls.find((c) => c[0] === "update")?.[2].payment_method_id, "pm_1");
});

Deno.test("a bank-funded Link method is refused: the mandate says this card", async () => {
  for (const pm of [
    { id: "pm_1", customer: "cus_1", type: "card", card: { brand: "link", last4: "0000" } },
    { id: "pm_1", customer: "cus_1", type: "us_bank_account" },
  ]) {
    const h = harness({ pm });
    await handleTrialSetupSession(h.deps, directSession, "completed", EVENT_CREATED);
    assertEquals(h.calls.find((c) => c[0] === "update")?.[2].reconcile_reason, "payment_method_not_card");
    assertEquals(h.calls.some((c) => c[0] === "pi.create"), false);
  }
});

Deno.test("a replay reuses the existing PI instead of creating another", async () => {
  const h = harness({ existingPi: { id: "pi_old", status: "requires_confirmation", metadata: { trial_order_id: "order-1" } } });
  await handleTrialSetupSession(h.deps, directSession, "completed", EVENT_CREATED);
  assertEquals(h.calls.some((c) => c[0] === "pi.create"), false);
  assertEquals(h.calls.find((c) => c[1] === "trial_activate")[2].p_payment_intent_id, "pi_old");
});

Deno.test("a superseded session never activates", async () => {
  const h = harness({ order: order({ checkout_session_id: "cs_newer" }) });
  await handleTrialSetupSession(h.deps, directSession, "completed", EVENT_CREATED);
  assertEquals(h.calls.some((c) => c[0] === "rpc" || c[0] === "pi.create"), false);
});

Deno.test("a setup on the wrong customer is refused, never repaired", async () => {
  const h = harness({ order: order({ stripe_customer_id: "cus_other" }) });
  await handleTrialSetupSession(h.deps, directSession, "completed", EVENT_CREATED);
  assertEquals(h.calls.some((c) => c[0] === "rpc"), false);
  assertEquals(h.calls.find((c) => c[0] === "update")[2].status, "activation_refused");
});

Deno.test("parent: Terms must be accepted on Stripe's page; refusal detaches the parent card", async () => {
  const h = harness({ order: order({ purchase_type: "parent_share", stripe_customer_id: null }) });
  await handleTrialSetupSession(h.deps, { ...directSession, consent: null, customer_details: { email: "p@x.com" } },
    "completed", EVENT_CREATED);
  assertEquals(h.calls.some((c) => c[0] === "rpc"), false);
  assertEquals(h.calls.some((c) => c[0] === "pm.detach" && c[1] === "pm_1"), true);
});

Deno.test("parent: activation uses the payer's email and never maps the parent card to the student", async () => {
  const h = harness({ order: order({ purchase_type: "parent_share", stripe_customer_id: null }) });
  await handleTrialSetupSession(h.deps, {
    ...directSession,
    consent: { terms_of_service: "accepted" },
    customer_details: { email: "Parent@Example.com" },
  }, "completed", EVENT_CREATED);
  const activate = h.calls.find((c) => c[1] === "trial_activate")[2];
  assertEquals([activate.p_payer_email, activate.p_payer_accept_source], ["Parent@Example.com", "stripe_consent_collection"]);
  assertEquals(h.calls.some((c) => c[0] === "upsert" && c[1] === "stripe_customers"), false);
});

Deno.test("an activation the database refuses cancels the PI and detaches a parent card", async () => {
  const h = harness({ order: order({ purchase_type: "parent_share", stripe_customer_id: null }), activate: "email_consumed" });
  await handleTrialSetupSession(h.deps, {
    ...directSession,
    consent: { terms_of_service: "accepted" },
    customer_details: { email: "p@x.com" },
  }, "completed", EVENT_CREATED);
  assertEquals(h.calls.some((c) => c[0] === "pi.cancel" && c[1] === "pi_new"), true);
  assertEquals(h.calls.some((c) => c[0] === "pm.detach"), true);
  assertEquals(h.calls.some((c) => c[0] === "event"), false);
});

Deno.test("an expired setup session releases the pending order", async () => {
  const h = harness();
  await handleTrialSetupSession(h.deps, directSession, "expired", EVENT_CREATED);
  assertEquals(h.calls.find((c) => c[0] === "update")[2].status, "setup_expired");
});

Deno.test("a charge that lands after a cancel is refunded automatically, never granted", async () => {
  const h = harness({ convert: "refund_required" });
  await handleTrialPaymentIntent(h.deps, "payment_intent.succeeded", {
    id: "pi_1", amount_received: 1999, currency: "usd", metadata: { kind: "trial_conversion", trial_order_id: "order-1" },
  });
  const refund = h.calls.find((c) => c[0] === "refund");
  assertEquals([refund[1].payment_intent, refund[2].idempotencyKey], ["pi_1", "trial-cancel-refund:order-1"]);
  assertEquals(h.calls.find((c) => c[1] === "trial_set_cancel_outcome")[2].p_outcome, "refunded");
});

Deno.test("a success that arrives after a full refund grants nothing and refunds nothing", async () => {
  const h = harness({ convert: "already_refunded" });
  await handleTrialPaymentIntent(h.deps, "payment_intent.succeeded", {
    id: "pi_1", amount_received: 1999, currency: "usd", metadata: { kind: "trial_conversion", trial_order_id: "order-1" },
  });
  assertEquals(h.calls.some((c) => c[0] === "refund"), false);
  assertEquals(h.calls.some((c) => c[0] === "event" && c[1] === "trial_converted"), false);
});

Deno.test("conversion records the trial_converted event", async () => {
  const h = harness();
  await handleTrialPaymentIntent(h.deps, "payment_intent.succeeded", {
    id: "pi_1", amount_received: 1999, currency: "usd", metadata: { kind: "trial_conversion", trial_order_id: "order-1" },
  });
  assertEquals(h.calls.some((c) => c[0] === "event" && c[1] === "trial_converted"), true);
});

Deno.test("refunds and disputes act only on the charge's own trial order", async () => {
  const h = harness({ order: order({ payment_intent_id: "pi_9", status: "converted" }) });
  assertEquals(await handleTrialChargeRefunded(h.deps, { payment_intent: "pi_other" }, true), false);
  assertEquals(await handleTrialChargeRefunded(h.deps, { payment_intent: "pi_9" }, true), true);
  assertEquals(h.calls.find((c) => c[1] === "trial_mark_refunded")[2].p_full, true);
  await handleDispute(h.deps, { id: "dp_1", payment_intent: "pi_9" });
  assertEquals(h.calls.some((c) => c[1] === "trial_mark_disputed"), true);
});

Deno.test("a card saved on an order that already lapsed is recorded for clean-up and a parent's is removed", async () => {
  const h = harness({ order: order({ purchase_type: "parent_share", status: "setup_expired", stripe_customer_id: null }) });
  await handleTrialSetupSession(h.deps, { ...directSession, customer: "cus_p" }, "completed", EVENT_CREATED);
  const update = h.calls.find((c) => c[0] === "update")[2];
  assertEquals([update.payment_method_id, update.setup_intent_id, update.stripe_cleanup_done_at], ["pm_1", "seti_1", null]);
  assertEquals(h.calls.some((c) => c[0] === "pm.detach" && c[1] === "pm_1"), true);
  assertEquals(h.calls.some((c) => c[0] === "rpc"), false);
  assertEquals(h.calls.some((c) => c[0] === "pi.create"), false);
});

Deno.test("a direct student's late card is recorded but never detached", async () => {
  const h = harness({ order: order({ status: "setup_expired" }) });
  await handleTrialSetupSession(h.deps, directSession, "completed", EVENT_CREATED);
  assertEquals(h.calls.find((c) => c[0] === "update")[2].payment_method_id, "pm_1");
  assertEquals(h.calls.some((c) => c[0] === "pm.detach"), false);
});
