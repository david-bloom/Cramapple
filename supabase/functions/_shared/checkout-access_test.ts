import {
  checkoutAccess,
  isFullyRefunded,
  isSettledPaymentStatus,
} from "./checkout-access.ts";

function assertEquals(actual: unknown, expected: unknown) {
  if (actual !== expected) {
    throw new Error(`Expected ${expected}, received ${actual}`);
  }
}

Deno.test("all expected entitlements active reads as entitled", () => {
  assertEquals(checkoutAccess(["active"], 1), "entitled");
  assertEquals(checkoutAccess(["active", "active"], 2), "entitled");
});

Deno.test("refund-revoked entitlements read as terminal refunded", () => {
  assertEquals(checkoutAccess(["revoked"], 1), "refunded");
  assertEquals(checkoutAccess(["revoked", "revoked"], 2), "refunded");
});

Deno.test("no entitlements yet, or a partial grant, is still pending", () => {
  assertEquals(checkoutAccess([], 1), "pending");
  assertEquals(checkoutAccess(["active"], 2), "pending");
});

Deno.test("an active grant alongside a revoked one is not refunded", () => {
  assertEquals(checkoutAccess(["active", "revoked"], 2), "pending");
});

Deno.test("paid and $0 (no_payment_required) sessions are settled", () => {
  assertEquals(isSettledPaymentStatus("paid"), true);
  assertEquals(isSettledPaymentStatus("no_payment_required"), true);
  assertEquals(isSettledPaymentStatus("unpaid"), false);
  assertEquals(isSettledPaymentStatus(null), false);
});

Deno.test("a fully refunded charge ends access", () => {
  assertEquals(isFullyRefunded({ refunded: true, amount: 3999, amount_refunded: 3999 }), true);
  assertEquals(isFullyRefunded({ refunded: true }), true);
});

Deno.test("a partial refund does not end access", () => {
  assertEquals(isFullyRefunded({ refunded: false, amount: 3999, amount_refunded: 2000 }), false);
  assertEquals(isFullyRefunded({ refunded: false }), false);
});

Deno.test("the refunded flag wins when present, even if amounts disagree", () => {
  assertEquals(isFullyRefunded({ refunded: false, amount: 100, amount_refunded: 100 }), false);
  assertEquals(isFullyRefunded({ refunded: true, amount: 100, amount_refunded: 1 }), true);
});

Deno.test("without the flag, compare amounts", () => {
  assertEquals(isFullyRefunded({ amount: 3999, amount_refunded: 3999 }), true);
  assertEquals(isFullyRefunded({ amount: 3999, amount_refunded: 4000 }), true);
  assertEquals(isFullyRefunded({ amount: 3999, amount_refunded: 1 }), false);
  assertEquals(isFullyRefunded({ amount: 3999, amount_refunded: 0 }), false);
});

Deno.test("unusable data keeps the previous behaviour: treat as a full refund", () => {
  assertEquals(isFullyRefunded({}), true);
  assertEquals(isFullyRefunded({ amount: 0, amount_refunded: 0 }), true);
  assertEquals(isFullyRefunded({ amount: null, amount_refunded: null }), true);
});
