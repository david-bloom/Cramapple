export type PurchaseType = "student_direct" | "parent_share" | "parent_gift";

export const PURCHASE_TYPES = new Set<PurchaseType>([
  "student_direct",
  "parent_share",
  "parent_gift",
]);

export function checkoutPurchaserType(metadata: Record<string, string>) {
  const value = metadata.purchaser_type ?? metadata.purchase_type;
  return PURCHASE_TYPES.has(value as PurchaseType)
    ? value as PurchaseType
    : null;
}

export function checkoutNeedsStudentResolution(
  metadata: Record<string, string>,
) {
  return checkoutPurchaserType(metadata) !== null;
}

export type CheckoutAccessState =
  | "processing"
  | "confirmed"
  | "failed"
  | "expired";

export function checkoutAccessState(input: {
  checkoutStatus: string | null;
  paymentStatus: string | null;
  expectedEntitlements: number;
  activeEntitlements: number;
}): CheckoutAccessState {
  if (input.checkoutStatus === "expired") return "expired";
  if (input.checkoutStatus === "async_payment_failed") return "failed";
  if (
    input.paymentStatus === "paid" &&
    input.expectedEntitlements > 0 &&
    input.activeEntitlements >= input.expectedEntitlements
  ) {
    return "confirmed";
  }
  return "processing";
}
