// Promotion-code evaluation for card trials (TASK-0077 plan §6.9).
//
// A setup-mode Checkout Session collects no payment, so Stripe applies no
// discount and enforces no promotion restrictions. This evaluates them the
// way payment-mode Checkout would, against the Dahlia PromotionCode/Coupon
// shape (stripe-node v22): `customer` at the top level, the coupon under
// `promotion.coupon`. The result is locked into the order (DECISION-0126
// item 3). Usage limits combine Stripe's counts with our own trial uses;
// overshoot from redemptions outside this system is accepted (item 21).

export type PriceFacts = {
  unitAmount: number;
  currency: string;
  productId: string;
  recurring: boolean;
};

export type CouponFacts = {
  id: string;
  valid: boolean;
  percentOff: number | null;
  amountOff: number | null;
  currency: string | null;
  currencyOptions: Record<string, { amount_off: number }> | null;
  appliesToProducts: string[] | null;
  redeemBy: number | null;
  maxRedemptions: number | null;
  timesRedeemed: number;
};

export type PromotionFacts = {
  id: string;
  code: string;
  active: boolean;
  expiresAt: number | null;
  maxRedemptions: number | null;
  timesRedeemed: number;
  customer: string | null;
  firstTimeTransaction: boolean;
  minimumAmount: number | null;
  minimumAmountCurrency: string | null;
  minimumAmountCurrencyOptions: Record<string, { minimum_amount: number }> | null;
  coupon: CouponFacts;
};

// Our own reserved + redeemed trial uses, by code and by coupon.
export type LocalUses = { promotionCode: number; coupon: number };

export type PromoContext = {
  nowSeconds: number;
  // The buyer's Stripe customer when known (a signed-in direct buyer).
  customerId: string | null;
  // Whether this buyer has paid Cramapple before, for first-time-only codes.
  hasPriorPayment: boolean;
};

export type PromoError =
  | "promo_code_invalid"
  | "promo_code_expired"
  | "promo_code_exhausted"
  | "promo_code_not_applicable"
  | "promo_code_minimum_not_met"
  | "promo_code_first_time_only"
  | "promo_code_unsupported";

export type PromoResult =
  | { ok: true; promotionCodeId: string; couponId: string; code: string; discountAmount: number }
  | { ok: false; error: PromoError };

// Stripe's minimum card charge in USD.
export const MIN_CHARGE_CENTS = 50;

export function evaluatePromotion(
  price: PriceFacts,
  promo: PromotionFacts,
  uses: LocalUses,
  ctx: PromoContext,
): PromoResult {
  const coupon = promo.coupon;
  const currency = price.currency.toLowerCase();

  if (price.recurring || currency !== "usd") {
    return { ok: false, error: "promo_code_unsupported" };
  }
  if (!promo.active || !coupon.valid) {
    return { ok: false, error: "promo_code_invalid" };
  }
  if (
    (promo.expiresAt !== null && promo.expiresAt <= ctx.nowSeconds) ||
    (coupon.redeemBy !== null && coupon.redeemBy <= ctx.nowSeconds)
  ) {
    return { ok: false, error: "promo_code_expired" };
  }
  if (
    (promo.maxRedemptions !== null &&
      promo.timesRedeemed + uses.promotionCode >= promo.maxRedemptions) ||
    (coupon.maxRedemptions !== null &&
      coupon.timesRedeemed + uses.coupon >= coupon.maxRedemptions)
  ) {
    return { ok: false, error: "promo_code_exhausted" };
  }
  if (promo.customer !== null && promo.customer !== ctx.customerId) {
    return { ok: false, error: "promo_code_invalid" };
  }
  if (promo.firstTimeTransaction && ctx.hasPriorPayment) {
    return { ok: false, error: "promo_code_first_time_only" };
  }
  if (
    coupon.appliesToProducts !== null &&
    !coupon.appliesToProducts.includes(price.productId)
  ) {
    return { ok: false, error: "promo_code_not_applicable" };
  }

  const minimum = minimumAmount(promo, currency);
  if (minimum === undefined) return { ok: false, error: "promo_code_unsupported" };
  if (minimum !== null && price.unitAmount < minimum) {
    return { ok: false, error: "promo_code_minimum_not_met" };
  }

  const discount = discountAmount(price.unitAmount, coupon, currency);
  if (discount === null) return { ok: false, error: "promo_code_unsupported" };

  return {
    ok: true,
    promotionCodeId: promo.id,
    couponId: coupon.id,
    code: promo.code,
    discountAmount: discount,
  };
}

// null = no minimum; undefined = a minimum we cannot evaluate in this
// currency (fail explicitly rather than guess).
function minimumAmount(promo: PromotionFacts, currency: string) {
  if (promo.minimumAmount === null) return null;
  if ((promo.minimumAmountCurrency ?? "").toLowerCase() === currency) {
    return promo.minimumAmount;
  }
  return promo.minimumAmountCurrencyOptions?.[currency]?.minimum_amount;
}

// Integer cents, clamped to the price. Percent discounts round half up.
export function discountAmount(
  unitAmount: number,
  coupon: CouponFacts,
  currency: string,
): number | null {
  if (coupon.percentOff !== null) {
    if (coupon.percentOff <= 0 || coupon.percentOff > 100) return null;
    return Math.min(unitAmount, Math.floor(unitAmount * coupon.percentOff / 100 + 0.5));
  }
  if (coupon.amountOff !== null) {
    const amount = (coupon.currency ?? "").toLowerCase() === currency
      ? coupon.amountOff
      : coupon.currencyOptions?.[currency]?.amount_off;
    if (amount === undefined || amount <= 0) return null;
    return Math.min(unitAmount, amount);
  }
  return null;
}

// What the buyer pays and how: a $0 total skips the trial (DECISION-0126
// item 7); a total below Stripe's minimum cannot be charged later.
export function chargeOutcome(listAmount: number, discountAmount: number) {
  const charge = listAmount - discountAmount;
  if (charge === 0) return { kind: "zero" as const, charge };
  if (charge < MIN_CHARGE_CENTS) return { kind: "below_minimum" as const, charge };
  return { kind: "chargeable" as const, charge };
}

// Map a Stripe PromotionCode (expanded `promotion.coupon`) to PromotionFacts.
// Returns null when the object is not a coupon promotion we understand.
// deno-lint-ignore no-explicit-any
export function promotionFactsFromStripe(p: any): PromotionFacts | null {
  const coupon = p?.promotion?.type === "coupon" ? p.promotion.coupon : null;
  if (!coupon || typeof coupon !== "object") return null;
  const restrictions = p.restrictions ?? {};
  return {
    id: p.id,
    code: p.code,
    active: Boolean(p.active),
    expiresAt: p.expires_at ?? null,
    maxRedemptions: p.max_redemptions ?? null,
    timesRedeemed: p.times_redeemed ?? 0,
    customer: typeof p.customer === "string" ? p.customer : p.customer?.id ?? null,
    firstTimeTransaction: Boolean(restrictions.first_time_transaction),
    minimumAmount: restrictions.minimum_amount ?? null,
    minimumAmountCurrency: restrictions.minimum_amount_currency ?? null,
    minimumAmountCurrencyOptions: restrictions.currency_options ?? null,
    coupon: {
      id: coupon.id,
      valid: Boolean(coupon.valid),
      percentOff: coupon.percent_off ?? null,
      amountOff: coupon.amount_off ?? null,
      currency: coupon.currency ?? null,
      currencyOptions: coupon.currency_options ?? null,
      appliesToProducts: coupon.applies_to?.products ?? null,
      redeemBy: coupon.redeem_by ?? null,
      maxRedemptions: coupon.max_redemptions ?? null,
      timesRedeemed: coupon.times_redeemed ?? 0,
    },
  };
}

// Pick the promotion code a buyer may use: one not restricted to another
// customer. Never blindly the first match.
export function choosePromotion<T extends { customer: string | null }>(
  candidates: T[],
  customerId: string | null,
): T | null {
  return candidates.find((c) => c.customer !== null && c.customer === customerId) ??
    candidates.find((c) => c.customer === null) ??
    null;
}
