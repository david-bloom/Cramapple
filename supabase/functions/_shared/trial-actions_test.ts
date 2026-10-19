import { assertEquals, assertRejects } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { cancelTrialOrder, orderView, recoveryClientSecret, resolveCapability } from "./trial-actions.ts";
import { hashCapabilityToken, newCapabilityToken } from "./trial-core.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

function deps(piStatus: string | null, cancelResult: Any = { result: "canceled", payment_intent_id: "pi_1" }) {
  const calls: Any[] = [];
  const service = {
    schema: () => ({
      rpc: (fn: string, args: Any) => {
        calls.push([fn, args]);
        return Promise.resolve({ data: fn === "trial_cancel" ? cancelResult : null, error: null });
      },
      from: () => {
        const b: Any = { update: (p: Any) => { calls.push(["update", p]); return b; }, eq: () => b, then: (r: Any) => r({ error: null }) };
        return b;
      },
    }),
  };
  const stripe = {
    paymentIntents: {
      retrieve: () => Promise.resolve({ id: "pi_1", status: piStatus, client_secret: "pi_1_secret" }),
      cancel: (id: string) => { calls.push(["pi.cancel", id]); return Promise.resolve({}); },
    },
    refunds: { create: (p: Any, o: Any) => { calls.push(["refund", p, o]); return Promise.resolve({}); } },
  };
  return { d: { service, stripe }, calls };
}

Deno.test("cancel before the charge: the PI is cancelled and the message says no charge", async () => {
  const h = deps("requires_confirmation");
  const r = await cancelTrialOrder(h.d, "order-1", "student");
  assertEquals([r.outcome, r.message], ["no_charge", "Cancelled. You won't be charged."]);
  assertEquals(h.calls.some((c) => c[0] === "pi.cancel"), true);
  assertEquals(h.calls.find((c) => c[0] === "trial_set_cancel_outcome")[1].p_outcome, "no_charge");
});

Deno.test("cancel during a charge in flight never claims no charge", async () => {
  const h = deps("processing");
  const r = await cancelTrialOrder(h.d, "order-1", "parent");
  assertEquals(r.outcome, "pending");
  assertEquals(r.message?.includes("refund it in full automatically"), true);
  assertEquals(h.calls.some((c) => c[0] === "pi.cancel" || c[0] === "refund"), false);
});

Deno.test("a transient PI cancel failure leaves settlement retryable", async () => {
  const h = deps("requires_confirmation");
  h.d.stripe.paymentIntents.cancel = () => Promise.reject(new Error("stripe transport failure"));
  await assertRejects(() => cancelTrialOrder(h.d, "order-1", "parent"), Error, "stripe transport failure");
  assertEquals(h.calls.some((c) => c[0] === "trial_set_cancel_outcome"), false);
  h.d.stripe.paymentIntents.cancel = () => Promise.resolve({});
  assertEquals((await cancelTrialOrder(h.d, "order-1", "parent")).outcome, "no_charge");
});

Deno.test("a cancel that loses a race to an in-flight charge reports pending at once", async () => {
  const h = deps("requires_confirmation");
  let retrieves = 0;
  h.d.stripe.paymentIntents.retrieve = () =>
    Promise.resolve({ id: "pi_1", status: retrieves++ === 0 ? "requires_confirmation" : "processing", client_secret: "pi_1_secret" });
  h.d.stripe.paymentIntents.cancel = () => Promise.reject(new Error("payment_intent_unexpected_state"));
  const r = await cancelTrialOrder(h.d, "order-1", "parent");
  assertEquals(r.outcome, "pending");
  assertEquals(h.calls.find((c) => c[0] === "trial_set_cancel_outcome")[1].p_outcome, "pending");
});

Deno.test("cancel after the charge landed refunds in full, idempotently", async () => {
  const h = deps("succeeded");
  const r = await cancelTrialOrder(h.d, "order-1", "student");
  assertEquals(r.outcome, "refunded");
  assertEquals(h.calls.find((c) => c[0] === "refund")[2].idempotencyKey, "trial-cancel-refund:order-1");
});

Deno.test("cancelling a pending order (no PI yet) is no charge; a converted one is not cancelable", async () => {
  assertEquals((await cancelTrialOrder(deps(null, { result: "canceled", payment_intent_id: null }).d, "o", "student")).outcome, "no_charge");
  assertEquals((await cancelTrialOrder(deps(null, { result: "not_cancelable", status: "converted" }).d, "o", "student")).result, "not_cancelable");
});

Deno.test("a cancel whose Stripe settlement failed is finished by the next call", async () => {
  const outcomes: Any[] = [];
  let state: Any = { result: "canceled", payment_intent_id: "pi_1" };
  let failRetrieve = true;
  const service = {
    schema: () => ({
      rpc: (fn: string, args: Any) => {
        if (fn === "trial_cancel") {
          const r = state;
          state = { result: "already_canceled", payment_intent_id: "pi_1", cancel_outcome: null };
          return Promise.resolve({ data: r, error: null });
        }
        outcomes.push(args.p_outcome);
        state = { ...state, cancel_outcome: args.p_outcome };
        return Promise.resolve({ data: null, error: null });
      },
    }),
  };
  const stripe = {
    paymentIntents: {
      retrieve: () => failRetrieve ? Promise.reject(new Error("stripe down")) : Promise.resolve({ id: "pi_1", status: "requires_confirmation" }),
      cancel: () => Promise.resolve({}),
    },
    refunds: { create: () => Promise.resolve({}) },
  };
  let threw = false;
  try {
    await cancelTrialOrder({ service, stripe }, "order-1", "parent");
  } catch {
    threw = true;
  }
  assertEquals([threw, outcomes.length], [true, 0]);
  failRetrieve = false;
  const r = await cancelTrialOrder({ service, stripe }, "order-1", "parent");
  assertEquals([r.result, r.outcome, outcomes], ["already_canceled", "no_charge", ["no_charge"]]);
  // Once recorded, a further call reports the outcome without touching Stripe.
  failRetrieve = true;
  assertEquals((await cancelTrialOrder({ service, stripe }, "order-1", "parent")).outcome, "no_charge");
});

Deno.test("capability tokens resolve only for their purpose, unexpired and not voided", async () => {
  const { token, hash } = await newCapabilityToken();
  const now = new Date("2026-10-20T00:00:00Z");
  const row = { order_id: "order-1", expires_at: "2026-10-28T00:00:00Z", voided_at: null, purpose: "parent_cancel" };
  const service = (r: Any) => ({
    schema: () => ({
      from: () => {
        const b: Any = {
          select: () => b,
          eq: (_c: string, v: string) => { b.v = v; return b; },
          maybeSingle: () => Promise.resolve({ data: b.v === hash ? r : null, error: null }),
        };
        return b;
      },
    }),
  });
  assertEquals(await resolveCapability(service(row), token, "parent_cancel", now), "order-1");
  assertEquals(await resolveCapability(service(row), token, "payer_recovery", now), null);
  assertEquals(await resolveCapability(service({ ...row, voided_at: "x" }), token, "parent_cancel", now), null);
  assertEquals(await resolveCapability(service(row), token, "parent_cancel", new Date("2026-10-29T00:00:00Z")), null);
  assertEquals(await resolveCapability(service(row), "not-a-token", "parent_cancel", now), null);
  assertEquals(hash, await hashCapabilityToken(token));
});

Deno.test("recovery returns the same PI's client secret and caps attempts", async () => {
  const order = { id: "order-1", status: "recovery_only", recovery_attempts: 0, payment_intent_id: "pi_1" };
  assertEquals(await recoveryClientSecret(deps("requires_payment_method").d, order), { client_secret: "pi_1_secret" });
  assertEquals(await recoveryClientSecret(deps("requires_payment_method").d, { ...order, recovery_attempts: 5 }), { error: "too_many_attempts" });
  assertEquals(await recoveryClientSecret(deps("succeeded").d, order), { error: "already_paid" });
  assertEquals(await recoveryClientSecret(deps("requires_payment_method").d, { ...order, status: "converted" }), { error: "not_recoverable" });
});

Deno.test("the order view is sanitized and says what the viewer can do", () => {
  const v = orderView({ id: "o", status: "trialing", subject_keys: ["biology"], charge_amount: 1999,
    trial_ends_at: "2026-10-25T16:00:00Z", purchase_type: "parent_share", payer_email: "secret@x.com", payment_method_id: "pm" });
  assertEquals([v.can_cancel, v.can_pay, v.amount, v.trial_ends_eastern, v.paid_by_parent],
    [true, false, "$19.99", "Sunday, October 25, 2026", true]);
  assertEquals("payer_email" in v || "payment_method_id" in v, false);
});
