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
