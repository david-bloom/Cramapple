import {
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
