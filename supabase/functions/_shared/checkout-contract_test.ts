import {
  checkoutAccessState,
  checkoutNeedsStudentResolution,
  checkoutPurchaserType,
} from "./checkout-contract.ts";

function assertEquals(actual: unknown, expected: unknown) {
  if (actual !== expected) {
    throw new Error(`Expected ${String(expected)}, received ${String(actual)}`);
  }
}

Deno.test("checkout purchaser type prefers normalized metadata", () => {
  assertEquals(
    checkoutPurchaserType({
      purchaser_type: "parent_share",
      purchase_type: "parent_gift",
    }),
    "parent_share",
  );
});

Deno.test("checkout purchaser type supports legacy parent-gift metadata", () => {
  assertEquals(
    checkoutPurchaserType({ purchase_type: "parent_gift" }),
    "parent_gift",
  );
});

Deno.test("all purchase-funnel types resolve the student recipient", () => {
  for (
    const purchaserType of [
      "student_direct",
      "parent_share",
      "parent_gift",
    ]
  ) {
    assertEquals(
      checkoutNeedsStudentResolution({ purchaser_type: purchaserType }),
      true,
    );
  }
  assertEquals(checkoutNeedsStudentResolution({}), false);
  assertEquals(
    checkoutNeedsStudentResolution({ purchaser_type: "unknown" }),
    false,
  );
});

Deno.test("checkout access is confirmed only after every entitlement exists", () => {
  assertEquals(
    checkoutAccessState({
      checkoutStatus: "completed",
      paymentStatus: "paid",
      expectedEntitlements: 2,
      activeEntitlements: 1,
    }),
    "processing",
  );
  assertEquals(
    checkoutAccessState({
      checkoutStatus: "completed",
      paymentStatus: "paid",
      expectedEntitlements: 2,
      activeEntitlements: 2,
    }),
    "confirmed",
  );
});

Deno.test("checkout access preserves terminal failure states", () => {
  assertEquals(
    checkoutAccessState({
      checkoutStatus: "expired",
      paymentStatus: "unpaid",
      expectedEntitlements: 1,
      activeEntitlements: 0,
    }),
    "expired",
  );
  assertEquals(
    checkoutAccessState({
      checkoutStatus: "async_payment_failed",
      paymentStatus: "unpaid",
      expectedEntitlements: 1,
      activeEntitlements: 0,
    }),
    "failed",
  );
});
