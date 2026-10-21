import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  chargeOutcome,
  type PromoContext,
  choosePromotion,
  evaluatePromotion,
  type PriceFacts,
  promotionFactsFromStripe,
  type PromotionFacts,
} from "./trial-promo.ts";

const NOW = 1_792_000_000;
const price: PriceFacts = {
  unitAmount: 3999,
  currency: "usd",
  productId: "prod_bio",
  recurring: false,
};
const ctx: PromoContext = { nowSeconds: NOW, customerId: null, hasPriorPayment: false };
const none = { promotionCode: 0, coupon: 0 };

function promo(over: Partial<PromotionFacts> = {}, coupon: Partial<PromotionFacts["coupon"]> = {}): PromotionFacts {
  return {
    id: "promo_1",
    code: "HALF",
    active: true,
    expiresAt: null,
    maxRedemptions: null,
    timesRedeemed: 0,
    customer: null,
    firstTimeTransaction: false,
    minimumAmount: null,
    minimumAmountCurrency: null,
    minimumAmountCurrencyOptions: null,
    ...over,
    coupon: {
      id: "coupon_1",
      valid: true,
      percentOff: 50,
      amountOff: null,
      currency: null,
      currencyOptions: null,
      appliesToProducts: null,
      redeemBy: null,
      maxRedemptions: null,
      timesRedeemed: 0,
      ...coupon,
    },
  };
}

function discount(p: PromotionFacts, uses = none, c = ctx) {
  const r = evaluatePromotion(price, p, uses, c);
  return r.ok ? r.discountAmount : r.error;
}

Deno.test("percent discounts round half up to whole cents", () => {
  assertEquals(discount(promo()), 2000); // 3999 * 0.5 = 1999.5
  assertEquals(discount(promo({}, { percentOff: 25 })), 1000); // 999.75
  assertEquals(discount(promo({}, { percentOff: 100 })), 3999);
});

Deno.test("amount-off discounts use the matching currency and never exceed the price", () => {
  assertEquals(discount(promo({}, { percentOff: null, amountOff: 3899, currency: "usd" })), 3899);
  assertEquals(discount(promo({}, { percentOff: null, amountOff: 9999, currency: "usd" })), 3999);
  assertEquals(
    discount(promo({}, {
      percentOff: null,
      amountOff: 500,
      currency: "eur",
      currencyOptions: { usd: { amount_off: 700 } },
    })),
    700,
  );
  assertEquals(
    discount(promo({}, { percentOff: null, amountOff: 500, currency: "eur" })),
    "promo_code_unsupported",
  );
});

Deno.test("inactive, invalid and expired codes are refused", () => {
  assertEquals(discount(promo({ active: false })), "promo_code_invalid");
  assertEquals(discount(promo({}, { valid: false })), "promo_code_invalid");
  assertEquals(discount(promo({ expiresAt: NOW })), "promo_code_expired");
  assertEquals(discount(promo({}, { redeemBy: NOW - 1 })), "promo_code_expired");
  assertEquals(discount(promo({ expiresAt: NOW + 60 })), 2000);
});

Deno.test("code and coupon limits count Stripe redemptions plus our trial uses", () => {
  assertEquals(discount(promo({ maxRedemptions: 10, timesRedeemed: 9 })), 2000);
  assertEquals(
    discount(promo({ maxRedemptions: 10, timesRedeemed: 9 }), { promotionCode: 1, coupon: 1 }),
    "promo_code_exhausted",
  );
  assertEquals(
    discount(promo({}, { maxRedemptions: 5, timesRedeemed: 3 }), { promotionCode: 0, coupon: 2 }),
    "promo_code_exhausted",
  );
});

Deno.test("customer, first-time and product restrictions", () => {
  assertEquals(discount(promo({ customer: "cus_other" })), "promo_code_invalid");
  assertEquals(
    discount(promo({ customer: "cus_me" }), none, { ...ctx, customerId: "cus_me" }),
    2000,
  );
  assertEquals(
    discount(promo({ firstTimeTransaction: true }), none, { ...ctx, hasPriorPayment: true }),
    "promo_code_first_time_only",
  );
  assertEquals(discount(promo({ firstTimeTransaction: true })), 2000);
  assertEquals(
    discount(promo({}, { appliesToProducts: ["prod_stats"] })),
    "promo_code_not_applicable",
  );
  assertEquals(discount(promo({}, { appliesToProducts: ["prod_bio"] })), 2000);
});

Deno.test("minimum amount in the price currency or its currency options", () => {
  assertEquals(
    discount(promo({ minimumAmount: 5000, minimumAmountCurrency: "usd" })),
    "promo_code_minimum_not_met",
  );
  assertEquals(discount(promo({ minimumAmount: 3999, minimumAmountCurrency: "usd" })), 2000);
  assertEquals(
    discount(promo({
      minimumAmount: 100,
      minimumAmountCurrency: "eur",
      minimumAmountCurrencyOptions: { usd: { minimum_amount: 4500 } },
    })),
    "promo_code_minimum_not_met",
  );
  assertEquals(
    discount(promo({ minimumAmount: 100, minimumAmountCurrency: "eur" })),
    "promo_code_unsupported",
  );
});

Deno.test("recurring or non-USD prices are unsupported", () => {
  assertEquals(
    evaluatePromotion({ ...price, recurring: true }, promo(), none, ctx),
    { ok: false, error: "promo_code_unsupported" },
  );
  assertEquals(
    evaluatePromotion({ ...price, currency: "eur" }, promo(), none, ctx),
    { ok: false, error: "promo_code_unsupported" },
  );
});

Deno.test("charge outcome: $0 skips the trial, under 50 cents cannot be charged", () => {
  assertEquals(chargeOutcome(3999, 3999).kind, "zero");
  assertEquals(chargeOutcome(3999, 3950).kind, "below_minimum");
  assertEquals(chargeOutcome(3999, 3949).kind, "chargeable");
  assertEquals(chargeOutcome(3999, 2000), { kind: "chargeable", charge: 1999 });
});

Deno.test("Dahlia PromotionCode shape maps the coupon from promotion.coupon", () => {
  const facts = promotionFactsFromStripe({
    id: "promo_x",
    code: "PILOT",
    active: true,
    customer: null,
    expires_at: null,
    max_redemptions: 10,
    times_redeemed: 2,
    restrictions: { first_time_transaction: false, minimum_amount: null },
    promotion: {
      type: "coupon",
      coupon: { id: "co_x", valid: true, percent_off: null, amount_off: 3899, currency: "usd", times_redeemed: 2 },
    },
  });
  assertEquals(facts?.coupon.amountOff, 3899);
  assertEquals(facts?.maxRedemptions, 10);
  assertEquals(promotionFactsFromStripe({ id: "p", promotion: { type: "coupon", coupon: "co_unexpanded" } }), null);
});

Deno.test("a customer-restricted code is chosen only for that customer", () => {
  const open = { id: "open", customer: null };
  const mine = { id: "mine", customer: "cus_me" };
  assertEquals(choosePromotion([mine, open], "cus_me")?.id, "mine");
  assertEquals(choosePromotion([mine, open], null)?.id, "open");
  assertEquals(choosePromotion([mine], null), null);
});
