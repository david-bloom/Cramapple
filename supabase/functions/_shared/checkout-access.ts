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

// A Checkout Session whose total a coupon brings to $0 completes with
// payment_status "no_payment_required", not "paid". Both are settled and must
// grant access; anything else ("unpaid") is still pending.
export function isSettledPaymentStatus(
  paymentStatus: string | null | undefined,
) {
  return paymentStatus === "paid" || paymentStatus === "no_payment_required";
}

// Stripe sends `charge.refunded` for partial refunds too. Only a fully refunded
// charge ends access; a partial refund (a goodwill gesture, or a price
// adjustment) must leave the student's access alone. Stripe sets `refunded`
// true only once the whole charge is refunded, so trust it when present; fall
// back to comparing amounts; and if neither is usable keep the previous
// behaviour (treat it as a full refund) rather than leave access after a refund.
export function isFullyRefunded(
  charge: {
    refunded?: boolean | null;
    amount?: number | null;
    amount_refunded?: number | null;
  },
): boolean {
  if (typeof charge.refunded === "boolean") return charge.refunded;
  const { amount, amount_refunded: refunded } = charge;
  if (
    typeof amount === "number" && amount > 0 && typeof refunded === "number"
  ) {
    return refunded >= amount;
  }
  return true;
}
