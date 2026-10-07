import {
  addonCustomerOptions,
  isPayerNotLearner,
  ownsAddonSource,
  purchaserTypeFromMetadata,
} from "./addon-checkout.ts";

Deno.test("add-on source requires a verified matching learner", () => {
  assertEquals(ownsAddonSource("student", "student"), true);
  assertEquals(ownsAddonSource("another-student", "student"), false);
  assertEquals(ownsAddonSource(null, "student"), false);
  assertEquals(ownsAddonSource("student", null), false);
  assertEquals(ownsAddonSource(null, null), false);
  assertEquals(ownsAddonSource("", ""), false);
});

function assertEquals(actual: unknown, expected: unknown) {
  if (JSON.stringify(actual) !== JSON.stringify(expected)) {
    throw new Error(
      `Expected ${JSON.stringify(expected)}, received ${
        JSON.stringify(actual)
      }`,
    );
  }
}

Deno.test("add-on reuses an existing Stripe Customer", () => {
  assertEquals(addonCustomerOptions("cus_123"), { customer: "cus_123" });
});

Deno.test("add-on falls back to collecting a payment method", () => {
  assertEquals(addonCustomerOptions(null), { customer_creation: "always" });
});

Deno.test("parent-paid purchases are payer-not-learner", () => {
  assertEquals(isPayerNotLearner("parent_share"), true);
  assertEquals(isPayerNotLearner("parent_gift"), true);
  assertEquals(isPayerNotLearner("student_direct"), false);
  assertEquals(isPayerNotLearner("post_purchase_addon"), false);
  assertEquals(isPayerNotLearner(null), false);
});

Deno.test("purchaser type prefers purchase_type, falls back to purchaser_type", () => {
  assertEquals(
    purchaserTypeFromMetadata({ purchase_type: "parent_gift" }),
    "parent_gift",
  );
  assertEquals(
    purchaserTypeFromMetadata({ purchaser_type: "parent_share" }),
    "parent_share",
  );
  assertEquals(purchaserTypeFromMetadata({}), null);
  assertEquals(purchaserTypeFromMetadata(null), null);
});
