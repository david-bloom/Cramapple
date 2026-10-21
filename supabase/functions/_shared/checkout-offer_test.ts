import { assertEquals, assertRejects, assertThrows } from "jsr:@std/assert@1";
import { promotionDiscount, resolveCheckoutOffer } from "./checkout-offer.ts";

const catalog = {
  subjects: { a: "price_a", b: "price_b", c: "price_c" },
  bundle_2: "price_two",
  bundle_3: "price_three",
  unlimited: "price_all",
};

Deno.test("checkout offers use catalog prices and preserve trimmed subject order", () => {
  assertEquals(resolveCheckoutOffer(catalog, "single", [" a "]), {
    priceId: "price_a",
    subjectKeys: ["a"],
  });
  assertEquals(resolveCheckoutOffer(catalog, "bundle_2", [" b ", "a"]), {
    priceId: "price_two",
    subjectKeys: ["b", "a"],
  });
  assertEquals(resolveCheckoutOffer(catalog, "bundle_3", ["c", "a", "b"]), {
    priceId: "price_three",
    subjectKeys: ["c", "a", "b"],
  });
  assertEquals(resolveCheckoutOffer(catalog, "unlimited", "ignored"), {
    priceId: "price_all",
    subjectKeys: [],
  });
});

Deno.test("checkout offers retain invalid-count, duplicate and unknown-subject errors", () => {
  for (const input of [undefined, null, "a", [], [" "], [1], ["a", "b"]]) {
    assertThrows(
      () => resolveCheckoutOffer(catalog, "single", input),
      Error,
      "invalid_subject_keys",
    );
  }
  for (const input of [["a", " a "], ["a", null], ["a"], ["a", "b", "c"]]) {
    assertThrows(
      () => resolveCheckoutOffer(catalog, "bundle_2", input),
      Error,
      "invalid_subject_keys",
    );
  }
  const error = assertThrows(
    () => resolveCheckoutOffer(catalog, "bundle_2", ["unknown", "a"]),
    Error,
    "unknown_subject_keys",
  ) as Error & { subjectKeys?: string[] };
  assertEquals(error.subjectKeys, ["unknown"]);
});

Deno.test("promotion lookup normalizes once and only requests an active first match", async () => {
  let calls = 0;
  const client = {
    promotionCodes: {
      list: (params: unknown) => {
        calls++;
        assertEquals(params, { code: "SAVE", active: true, limit: 1 });
        return Promise.resolve({
          data: [{ id: "promo_first" }, { id: "promo_second" }],
        });
      },
    },
  };
  assertEquals(await promotionDiscount(client, null), null);
  assertEquals(await promotionDiscount(client, "   "), null);
  assertEquals(calls, 0);
  assertEquals(await promotionDiscount(client, " save "), "promo_first");
  assertEquals(calls, 1);
  await assertRejects(
    () =>
      promotionDiscount({
        promotionCodes: { list: () => Promise.resolve({ data: [] }) },
      }, "SAVE"),
    Error,
    "promo_code_invalid",
  );
  await assertRejects(
    () =>
      promotionDiscount({
        promotionCodes: {
          list: () => Promise.reject(new Error("stripe_unavailable")),
        },
      }, "SAVE"),
    Error,
    "stripe_unavailable",
  );
});
