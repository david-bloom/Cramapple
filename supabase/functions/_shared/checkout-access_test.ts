import { checkoutAccess, isSettledPaymentStatus } from "./checkout-access.ts";

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
