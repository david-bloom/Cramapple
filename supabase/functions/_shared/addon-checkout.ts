export function addonCustomerOptions(stripeCustomerId: string | null) {
  return stripeCustomerId
    ? { customer: stripeCustomerId }
    : { customer_creation: "always" as const };
}

export function ownsAddonSource(
  authenticatedUserId: string | null | undefined,
  sourceUserId: string | null | undefined,
) {
  return Boolean(
    authenticatedUserId && sourceUserId && authenticatedUserId === sourceUserId,
  );
}

// DECISION-0090: a parent (or gifting adult) pays with their own card, so that
// card must never be saved against the student or reused for a one-tap add-on.
// The add-on offer and saved-payment-method reuse are student_direct only.
export function isPayerNotLearner(purchaserType: string | null | undefined) {
  return purchaserType === "parent_share" || purchaserType === "parent_gift";
}

export function purchaserTypeFromMetadata(
  metadata: Record<string, unknown> | null | undefined,
) {
  const value = metadata?.purchase_type ?? metadata?.purchaser_type;
  return typeof value === "string" ? value : null;
}
