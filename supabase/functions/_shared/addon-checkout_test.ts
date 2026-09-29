import { addonCustomerOptions } from "./addon-checkout.ts";

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
