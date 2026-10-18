import { isSettledPaymentStatus } from "./checkout-access.ts";

// Stripe's own Checkout Session mode. Not to be confused with
// `metadata.mode`, which this codebase uses for the offer
// (single/bundle_2/bundle_3/unlimited).
export type StripeSessionMode = "payment" | "setup" | "subscription";

export type CheckoutSessionRouteInput = {
  mode?: string | null;
  payment_status?: string | null;
  metadata?: Record<string, string> | null;
};

export type CheckoutSessionRoute =
  // A payment-mode session whose payment has settled: grant access.
  | "fulfil_payment"
  // A payment-mode session that has not settled (or reports no status).
  | "payment_pending"
  // A payment-mode session event that carries no grant (expired,
  // async_payment_failed).
  | "payment_unfulfilled"
  // A setup-mode session that claims to start a card trial (TASK-0077).
  | "trial_setup"
  // Anything this function must never grant from: a setup session with no
  // trial claim, a subscription, or a session whose mode is unknown.
  | "quarantine";

export type CheckoutEventStatus =
  | "completed"
  | "async_payment_succeeded"
  | "async_payment_failed"
  | "expired";

// Fail closed. A completed setup session reports payment_status
// "no_payment_required", the same value a 100%-off coupon order reports, so
// routing must look at Stripe's session mode before the payment status
// (TASK-0077 plan §4). A valid signature alone never makes a session
// grantable.
export function routeCheckoutSession(
  session: CheckoutSessionRouteInput,
  status: CheckoutEventStatus,
): CheckoutSessionRoute {
  if (session.mode === "setup") {
    return session.metadata?.kind === "trial_setup"
      ? "trial_setup"
      : "quarantine";
  }
  if (session.mode !== "payment") return "quarantine";

  if (status === "completed" || status === "async_payment_succeeded") {
    // A missing payment_status used to pass the gate; it no longer grants.
    return isSettledPaymentStatus(session.payment_status)
      ? "fulfil_payment"
      : "payment_pending";
  }
  return "payment_unfulfilled";
}
