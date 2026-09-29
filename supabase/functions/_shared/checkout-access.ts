// How a paid Checkout Session's entitlements read to the student/parent
// status screen. A refund revokes the session's entitlements (stripe-webhook
// handleChargeRefunded) without touching the session row, so a revoked-only
// set must read as terminal "refunded" - otherwise the waiting screen polls
// "processing" forever.
export type CheckoutAccess = "entitled" | "refunded" | "pending";

export function checkoutAccess(
  entitlementStatuses: string[],
  expectedCount: number,
): CheckoutAccess {
  const active = entitlementStatuses.filter((s) => s === "active").length;
  if (active >= Math.max(expectedCount, 1)) return "entitled";
  if (active === 0 && entitlementStatuses.includes("revoked")) {
    return "refunded";
  }
  return "pending";
}
