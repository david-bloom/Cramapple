import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { chargeOrder, type ChargeDeps, cleanUpFinishedOrders, runChargeWorker } from "./handler.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

const claimed = {
  id: "order-1",
  purchase_type: "student_direct",
  payment_intent_id: "pi_1",
  payment_method_id: "pm_1",
  charge_amount: 1999,
  charge_phase: "first" as const,
  attempt_count: 1,
  lease_token: "lease-1",
};

function harness(
  intent: Any,
  confirm: () => Promise<Any>,
  extra: { claimed?: Any[]; finished?: Any[]; current?: Record<string, Any> } = {},
) {
  const calls: Any[] = [];
  const service = {
    schema: () => ({
      rpc: (fn: string, args: Any) => {
        calls.push(["rpc", fn, args]);
        if (fn === "trial_claim_due") return Promise.resolve({ data: extra.claimed ?? [], error: null });
        if (fn === "trial_sweep") return Promise.resolve({ data: { delayed: 0 }, error: null });
        return Promise.resolve({ data: "recorded", error: null });
      },
      from: (table: string) => {
        // An update's filters are matched against the row as it is now (the
        // finished snapshot unless a test changed it underneath the worker).
        const filters: Array<[string, unknown]> = [];
        let patch: Any = null;
        const b: Any = {
          select: () => b, in: () => b, not: () => b, lt: () => b,
          eq: (c: string, v: unknown) => { filters.push([c, v]); return b; },
          is: (c: string, v: unknown) => { filters.push([c, v]); return b; },
          limit: () => Promise.resolve({ data: extra.finished ?? [], error: null }),
          update: (p: Any) => { patch = p; calls.push(["update", table, p]); return b; },
          upsert: (p: Any) => { calls.push(["upsert", table, p]); return Promise.resolve({ error: null }); },
          then: (r: Any) => {
            if (!patch) return r({ error: null });
            const id = filters.find(([c]) => c === "id")?.[1] as string;
            const row = extra.current?.[id] ?? (extra.finished ?? []).find((o: Any) => o.id === id);
            const base = row ? { stripe_cleanup_done_at: null, ...row } : null;
            const hit = base && filters.every(([c, v]) => (base[c] ?? null) === v);
            return r({ data: hit ? [{ id }] : [], error: null });
          },
        };
        return b;
      },
    }),
  };
  const stripe = {
    paymentIntents: {
      retrieve: () => Promise.resolve(intent),
      confirm: (id: string, p: Any, o: Any) => { calls.push(["confirm", id, p, o]); return confirm(); },
      cancel: (id: string) => { calls.push(["cancel", id]); return Promise.resolve({}); },
    },
    paymentMethods: { detach: (id: string) => { calls.push(["detach", id]); return Promise.resolve({}); } },
  };
  const deps: ChargeDeps = { stripe, service, chargesEnabled: true, log: (m) => calls.push(["log", m]) };
  const outcome = () => calls.find((c) => c[0] === "rpc" && c[1] === "trial_record_attempt")?.[2];
  return { deps, calls, outcome };
}

const fresh = { id: "pi_1", status: "requires_confirmation", amount: 1999 };

Deno.test("first attempt confirms the order's own PI off-session with a per-attempt key", async () => {
  const h = harness(fresh, () => Promise.resolve({ status: "succeeded" }));
  await chargeOrder(h.deps, claimed);
  const confirm = h.calls.find((c) => c[0] === "confirm");
  assertEquals([confirm[1], confirm[2].off_session, confirm[2].payment_method, confirm[3].idempotencyKey],
    ["pi_1", true, "pm_1", "trial-confirm:order-1:1"]);
  assertEquals(h.outcome().p_outcome, "succeeded_observed");
});

Deno.test("an intent that already moved is never confirmed again", async () => {
  for (const [status, outcome] of [["succeeded", "succeeded_observed"], ["processing", "processing"], ["canceled", "canceled_observed"]]) {
    const h = harness({ ...fresh, status }, () => Promise.reject(new Error("must not confirm")));
    await chargeOrder(h.deps, claimed);
    assertEquals(h.calls.some((c) => c[0] === "confirm"), false);
    assertEquals(h.outcome().p_outcome, outcome);
  }
});

Deno.test("declines and authentication are classified; transport errors reconcile", async () => {
  const cases: Array<[Any, string]> = [
    [{ type: "StripeCardError", code: "card_declined", decline_code: "insufficient_funds" }, "declined_retryable"],
    [{ type: "StripeCardError", code: "card_declined", decline_code: "lost_card" }, "declined_hard"],
    [{ type: "StripeCardError", code: "authentication_required" }, "requires_action"],
    [{ type: "StripeConnectionError" }, "transport_error"],
  ];
  for (const [err, outcome] of cases) {
    const h = harness(fresh, () => Promise.reject(err));
    await chargeOrder(h.deps, claimed);
    assertEquals(h.outcome().p_outcome, outcome);
  }
});

Deno.test("reconciling a stale lease reads the earlier decline instead of charging", async () => {
  const declined = {
    ...fresh,
    status: "requires_payment_method",
    last_payment_error: { type: "card_error", code: "card_declined", decline_code: "insufficient_funds" },
  };
  const h = harness(declined, () => Promise.reject(new Error("must not confirm")));
  await chargeOrder(h.deps, { ...claimed, charge_phase: "reconcile" });
  assertEquals(h.calls.some((c) => c[0] === "confirm"), false);
  assertEquals(h.outcome().p_outcome, "declined_retryable");
});

Deno.test("a reconcile of a never-confirmed intent reuses the in-flight attempt's key", async () => {
  const h = harness(fresh, () => Promise.resolve({ status: "succeeded" }));
  await chargeOrder(h.deps, { ...claimed, charge_phase: "reconcile", attempt_count: 1 });
  assertEquals(h.calls.find((c) => c[0] === "confirm")[3].idempotencyKey, "trial-confirm:order-1:1");
});

Deno.test("a PI whose amount differs from the locked price is not charged", async () => {
  const h = harness({ ...fresh, amount: 999 }, () => Promise.reject(new Error("must not confirm")));
  await chargeOrder(h.deps, claimed);
  assertEquals([h.outcome().p_outcome, h.outcome().p_error_code], ["transport_error", "payment_intent_amount_mismatch"]);
});

Deno.test("with charges off the sweep still runs and nothing is claimed", async () => {
  const h = harness(fresh, () => Promise.resolve({ status: "succeeded" }), { claimed: [claimed] });
  await runChargeWorker({ ...h.deps, chargesEnabled: false });
  assertEquals(h.calls.some((c) => c[1] === "trial_sweep"), true);
  assertEquals(h.calls.some((c) => c[1] === "trial_claim_due"), false);
  assertEquals(h.calls.some((c) => c[0] === "upsert" && c[1] === "trial_worker_heartbeat"), true);
});

Deno.test("clean-up retries a refused parent order's card and marks done only after the detach", async () => {
  const refused = { id: "o-ref", purchase_type: "parent_share", status: "activation_refused", payment_intent_id: null, payment_method_id: "pm_r" };
  const failing = harness(fresh, () => Promise.resolve({}), { finished: [refused] });
  failing.deps.stripe.paymentMethods.detach = () => Promise.reject(new Error("stripe down"));
  assertEquals(await cleanUpFinishedOrders(failing.deps), 0);
  assertEquals(failing.calls.some((c) => c[0] === "update" && c[2].stripe_cleanup_done_at), false);

  const ok = harness(fresh, () => Promise.resolve({}), { finished: [refused] });
  assertEquals(await cleanUpFinishedOrders(ok.deps), 1);
  assertEquals(ok.calls.filter((c) => c[0] === "detach").map((c) => c[1]), ["pm_r"]);
  assertEquals(ok.calls.some((c) => c[0] === "update" && c[2].stripe_cleanup_done_at), true);
});

Deno.test("clean-up cancels an unused PI and detaches only a parent's card", async () => {
  const h = harness(fresh, () => Promise.resolve({}), {
    finished: [
      { id: "o-parent", purchase_type: "parent_share", status: "canceled", payment_intent_id: "pi_p", payment_method_id: "pm_p" },
      { id: "o-direct", purchase_type: "student_direct", status: "converted", payment_intent_id: "pi_d", payment_method_id: "pm_d" },
    ],
  });
  assertEquals(await cleanUpFinishedOrders(h.deps), 2);
  assertEquals(h.calls.filter((c) => c[0] === "cancel").map((c) => c[1]), ["pi_p"]);
  assertEquals(h.calls.filter((c) => c[0] === "detach").map((c) => c[1]), ["pm_p"]);
});

Deno.test("clean-up never marks done an order a late webhook changed underneath it", async () => {
  // The worker read the swept order with no card; meanwhile the late webhook
  // recorded the parent's card (its own detach failed) and re-armed clean-up.
  const snapshot = { id: "o-late", purchase_type: "parent_share", status: "setup_expired", payment_intent_id: null, payment_method_id: null };
  const h = harness(fresh, () => Promise.resolve({}), {
    finished: [snapshot],
    current: { "o-late": { ...snapshot, payment_method_id: "pm_late" } },
  });
  assertEquals(await cleanUpFinishedOrders(h.deps), 0);
  assertEquals(h.calls.some((c) => c[0] === "log" && c[1] === "trial_cleanup_snapshot_changed"), true);
  // The next run reads the card and detaches it.
  const next = harness(fresh, () => Promise.resolve({}), { finished: [{ ...snapshot, payment_method_id: "pm_late" }] });
  assertEquals(await cleanUpFinishedOrders(next.deps), 1);
  assertEquals(next.calls.filter((c) => c[0] === "detach").map((c) => c[1]), ["pm_late"]);
});
