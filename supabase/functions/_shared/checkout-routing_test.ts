import { routeCheckoutSession } from "./checkout-routing.ts";

function assertEquals(actual: unknown, expected: unknown) {
  if (actual !== expected) {
    throw new Error(`Expected ${expected}, received ${actual}`);
  }
}

Deno.test("a completed setup session never fulfils a payment", () => {
  // Stripe reports no_payment_required for every completed setup session.
  const setup = { mode: "setup", payment_status: "no_payment_required" };
  assertEquals(routeCheckoutSession(setup, "completed"), "quarantine");
  assertEquals(
    routeCheckoutSession(setup, "async_payment_succeeded"),
    "quarantine",
  );
  assertEquals(
    routeCheckoutSession(
      { ...setup, metadata: { mode: "single", subject_ids: "biology" } },
      "completed",
    ),
    "quarantine",
  );
});

Deno.test("a setup session that claims a card trial routes to the trial path", () => {
  assertEquals(
    routeCheckoutSession(
      {
        mode: "setup",
        payment_status: "no_payment_required",
        metadata: { kind: "trial_setup", trial_order_id: "x" },
      },
      "completed",
    ),
    "trial_setup",
  );
  assertEquals(
    routeCheckoutSession(
      { mode: "setup", metadata: { kind: "trial_setup" } },
      "expired",
    ),
    "trial_setup",
  );
});

Deno.test("paid and $0 payment-mode sessions still fulfil", () => {
  assertEquals(
    routeCheckoutSession({ mode: "payment", payment_status: "paid" }, "completed"),
    "fulfil_payment",
  );
  assertEquals(
    routeCheckoutSession(
      { mode: "payment", payment_status: "no_payment_required" },
      "completed",
    ),
    "fulfil_payment",
  );
  assertEquals(
    routeCheckoutSession(
      { mode: "payment", payment_status: "paid" },
      "async_payment_succeeded",
    ),
    "fulfil_payment",
  );
});

Deno.test("an unsettled or missing payment status is pending, not granted", () => {
  assertEquals(
    routeCheckoutSession({ mode: "payment", payment_status: "unpaid" }, "completed"),
    "payment_pending",
  );
  assertEquals(
    routeCheckoutSession({ mode: "payment", payment_status: null }, "completed"),
    "payment_pending",
  );
  assertEquals(
    routeCheckoutSession({ mode: "payment" }, "completed"),
    "payment_pending",
  );
});

Deno.test("expired and failed payment sessions carry no grant", () => {
  assertEquals(
    routeCheckoutSession({ mode: "payment", payment_status: "unpaid" }, "expired"),
    "payment_unfulfilled",
  );
  assertEquals(
    routeCheckoutSession(
      { mode: "payment", payment_status: "unpaid" },
      "async_payment_failed",
    ),
    "payment_unfulfilled",
  );
});

Deno.test("subscription and unknown modes are quarantined", () => {
  assertEquals(
    routeCheckoutSession({ mode: "subscription", payment_status: "paid" }, "completed"),
    "quarantine",
  );
  assertEquals(
    routeCheckoutSession({ payment_status: "paid" }, "completed"),
    "quarantine",
  );
  assertEquals(
    routeCheckoutSession({ mode: null, payment_status: "paid" }, "completed"),
    "quarantine",
  );
});
