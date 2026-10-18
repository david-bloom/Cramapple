// Quote and start a seven-day card trial (TASK-0077 plan §6.3, §6.10).
//
// The server decides the billing mode; the client never chooses "trial".
// The quote locks the price (DECISION-0126 item 3); starting requires the
// same quote_version the buyer saw and the student's Terms acknowledgment
// (items 8, 11, 17).

import {
  chargeOutcome,
  choosePromotion,
  evaluatePromotion,
  type PriceFacts,
  type PromoError,
  promotionFactsFromStripe,
  type PromotionFacts,
} from "./trial-promo.ts";
import {
  easternDate,
  MANDATE_TEXT_VERSION,
  mandateText,
  normalizeEmail,
  parentMandateText,
  quoteVersion,
  trialChargeFloor,
} from "./trial-core.ts";

export type BillingMode = "trial" | "pay_now" | "pay_now_zero";
export type TrialPurchaseType = "student_direct" | "parent_share";

// deno-lint-ignore no-explicit-any
type Any = any;

export type TrialDeps = {
  stripe: Any;
  service: Any;
  now: () => Date;
  admissionEnabled: boolean;
  termsVersion: string;
};

export type QuoteInput = {
  purchaseType: TrialPurchaseType;
  offer: "single" | "bundle_2" | "bundle_3";
  subjectKeys: string[];
  priceId: string;
  promoCode: string | null;
  studentEmail: string;
  // A signed-in direct buyer's Stripe customer, when they have one.
  customerId: string | null;
};

export type TrialQuote = {
  billing_mode: BillingMode;
  pay_now_reason: "admission_off" | "trial_used" | "zero_total" | null;
  currency: "usd";
  list_amount: number;
  discount_amount: number;
  charge_amount: number;
  promotion_code_id: string | null;
  coupon_id: string | null;
  promo_code: string | null;
  quote_version: string;
  terms_version: string;
  mandate_text_version: string;
  charge_date_floor: string;
  charge_date_floor_eastern: string;
  mandate_text: string;
};

export class TrialError extends Error {
  constructor(public code: string, public status = 400) {
    super(code);
  }
}

export async function loadPriceFacts(stripe: Any, priceId: string): Promise<PriceFacts> {
  const price = await stripe.prices.retrieve(priceId);
  if (typeof price.unit_amount !== "number") throw new TrialError("price_unsupported", 500);
  return {
    unitAmount: price.unit_amount,
    currency: String(price.currency),
    productId: typeof price.product === "string" ? price.product : price.product?.id,
    recurring: price.type === "recurring" || Boolean(price.recurring),
  };
}

async function lookupPromotion(
  stripe: Any,
  code: string,
  customerId: string | null,
): Promise<PromotionFacts | null> {
  const list = await stripe.promotionCodes.list({
    code: code.trim().toUpperCase(),
    active: true,
    limit: 10,
    expand: ["data.promotion.coupon"],
  });
  const facts = (list.data ?? []).map(promotionFactsFromStripe).filter(
    (f: PromotionFacts | null): f is PromotionFacts => f !== null,
  );
  return choosePromotion(facts, customerId);
}

async function localPromoUses(service: Any, promotionCodeId: string, couponId: string) {
  const count = async (column: string, value: string) => {
    const { count, error } = await service.schema("app").from("trial_orders")
      .select("id", { count: "exact", head: true })
      .eq(column, value)
      .in("promo_use_state", ["reserved", "redeemed"]);
    if (error) throw error;
    return count ?? 0;
  };
  return {
    promotionCode: await count("promotion_code_id", promotionCodeId),
    coupon: await count("coupon_id", couponId),
  };
}

export async function trialAlreadyUsed(service: Any, email: string) {
  const { data, error } = await service.schema("app").rpc("trial_email_consumed", {
    p_email: normalizeEmail(email),
  });
  if (error) throw error;
  return data === true;
}

async function hasPriorPayment(service: Any, email: string) {
  const { count, error } = await service.schema("app").from("stripe_checkout_sessions")
    .select("id", { count: "exact", head: true })
    .eq("payment_status", "paid")
    .eq("payload->customer_details->>email", normalizeEmail(email));
  if (error) throw error;
  return (count ?? 0) > 0;
}

export async function buildTrialQuote(deps: TrialDeps, input: QuoteInput): Promise<TrialQuote> {
  const price = await loadPriceFacts(deps.stripe, input.priceId);
  let discount = 0;
  let promo: { promotionCodeId: string; couponId: string; code: string } | null = null;

  if (input.promoCode && input.promoCode.trim()) {
    const facts = await lookupPromotion(deps.stripe, input.promoCode, input.customerId);
    if (!facts) throw new TrialError("promo_code_invalid");
    const result = evaluatePromotion(
      price,
      facts,
      await localPromoUses(deps.service, facts.id, facts.coupon.id),
      {
        nowSeconds: Math.floor(deps.now().getTime() / 1000),
        customerId: input.customerId,
        hasPriorPayment: facts.firstTimeTransaction
          ? await hasPriorPayment(deps.service, input.studentEmail)
          : false,
      },
    );
    if (!result.ok) throw new TrialError(result.error satisfies PromoError);
    discount = result.discountAmount;
    promo = { promotionCodeId: result.promotionCodeId, couponId: result.couponId, code: result.code };
  }

  const outcome = chargeOutcome(price.unitAmount, discount);
  if (outcome.kind === "below_minimum") throw new TrialError("charge_below_minimum");

  let billingMode: BillingMode = "trial";
  let reason: TrialQuote["pay_now_reason"] = null;
  if (outcome.kind === "zero") {
    billingMode = "pay_now_zero";
    reason = "zero_total";
  } else if (!deps.admissionEnabled) {
    billingMode = "pay_now";
    reason = "admission_off";
  } else if (await trialAlreadyUsed(deps.service, input.studentEmail)) {
    billingMode = "pay_now";
    reason = "trial_used";
  }

  const floor = trialChargeFloor(deps.now());
  return {
    billing_mode: billingMode,
    pay_now_reason: reason,
    currency: "usd",
    list_amount: price.unitAmount,
    discount_amount: discount,
    charge_amount: outcome.charge,
    promotion_code_id: promo?.promotionCodeId ?? null,
    coupon_id: promo?.couponId ?? null,
    promo_code: promo?.code ?? null,
    quote_version: await quoteVersion({
      offer: input.offer,
      subjectKeys: input.subjectKeys,
      priceId: input.priceId,
      listAmount: price.unitAmount,
      discountAmount: discount,
      chargeAmount: outcome.charge,
      promotionCodeId: promo?.promotionCodeId ?? null,
      termsVersion: deps.termsVersion,
    }),
    terms_version: deps.termsVersion,
    mandate_text_version: MANDATE_TEXT_VERSION,
    charge_date_floor: floor.toISOString(),
    charge_date_floor_eastern: easternDate(floor),
    mandate_text: mandateText(outcome.charge, floor),
  };
}

export type StartInput = QuoteInput & {
  quoteVersion: string;
  studentAck: { version: string; source: string };
  studentName: string | null;
  consentIp: string | null;
  consentUserAgent: string | null;
  // Where Stripe returns the buyer (direct) or success/cancel (parent).
  urls: { returnUrl?: string; successUrl?: string; cancelUrl?: string };
};

export type StartResult = {
  order_id: string;
  session_id: string;
  client_secret: string | null;
  url: string | null;
  quote: TrialQuote;
};

// Catalog keys are app.subjects.subject_key values (as the paid path uses).
export async function resolveSubjectIds(service: Any, keys: string[]) {
  const { data, error } = await service.schema("app").from("subjects")
    .select("id, subject_key").in("subject_key", keys);
  if (error) throw error;
  const byKey = new Map((data ?? []).map((r: Any) => [r.subject_key, r.id]));
  const missing = keys.filter((k) => !byKey.has(k));
  if (missing.length) throw new TrialError("unknown_subject_keys");
  return keys.map((k) => byKey.get(k) as string);
}

// Create (or refresh) the pending order and its setup-mode Checkout Session.
export async function startTrialSetup(deps: TrialDeps, input: StartInput): Promise<StartResult> {
  const quote = await buildTrialQuote(deps, input);
  if (quote.billing_mode !== "trial") {
    throw new TrialError("billing_mode_changed", 409);
  }
  if (input.quoteVersion !== quote.quote_version) {
    throw new TrialError("quote_changed", 409);
  }
  if (input.studentAck.version !== deps.termsVersion) {
    throw new TrialError("terms_version_mismatch", 409);
  }

  const subjectIds = await resolveSubjectIds(deps.service, input.subjectKeys);
  const emailNorm = normalizeEmail(input.studentEmail);
  const nowIso = deps.now().toISOString();
  const row = {
    purchase_type: input.purchaseType,
    student_email: input.studentEmail,
    student_email_norm: emailNorm,
    student_name: input.studentName,
    offer: input.offer,
    subject_ids: subjectIds,
    subject_keys: input.subjectKeys,
    price_id: input.priceId,
    list_amount: quote.list_amount,
    discount_amount: quote.discount_amount,
    charge_amount: quote.charge_amount,
    quote_version: quote.quote_version,
    // Matches the Checkout Session's default 24-hour lifetime.
    quote_expires_at: new Date(deps.now().getTime() + 24 * 60 * 60 * 1000).toISOString(),
    promotion_code_id: quote.promotion_code_id,
    coupon_id: quote.coupon_id,
    promo_code: quote.promo_code,
    promo_use_state: quote.promotion_code_id ? "reserved" : null,
    payer_is_learner: input.purchaseType === "student_direct",
    student_ack_version: input.studentAck.version,
    student_ack_at: nowIso,
    student_ack_source: input.studentAck.source,
    mandate_text_version: MANDATE_TEXT_VERSION,
    consent_ip: input.consentIp,
    consent_user_agent: input.consentUserAgent?.slice(0, 500) ?? null,
    updated_at: nowIso,
  };

  // Reuse this email's pending order rather than creating another
  // (one pending order per email; plan §6.3 step 6).
  const app = deps.service.schema("app");
  const { data: existing, error: existingError } = await app.from("trial_orders")
    .select("id, checkout_session_id")
    .eq("student_email_norm", emailNorm)
    .eq("status", "pending_setup")
    .maybeSingle();
  if (existingError) throw existingError;

  let orderId: string;
  if (existing) {
    orderId = existing.id;
    if (existing.checkout_session_id) {
      await deps.stripe.checkout.sessions.expire(existing.checkout_session_id).catch(() => {
        // Already completed or expired; the webhook handles either.
      });
    }
    const { error } = await app.from("trial_orders")
      .update({ ...row, checkout_session_id: null, stripe_customer_id: null })
      .eq("id", orderId).eq("status", "pending_setup");
    if (error) throw error;
  } else {
    const { data, error } = await app.from("trial_orders").insert(row).select("id").single();
    if (error) {
      if (error.code === "23505") throw new TrialError("trial_pending_elsewhere", 409);
      throw error;
    }
    orderId = data.id;
  }

  const metadata = {
    kind: "trial_setup",
    trial_order_id: orderId,
    quote_version: quote.quote_version,
    purchase_type: input.purchaseType,
    mode: input.offer,
    subject_ids: input.subjectKeys.join(","),
    student_email: emailNorm,
    ...(input.studentName ? { student_name: input.studentName } : {}),
  };

  let session: Any;
  let customerId: string | null = null;
  if (input.purchaseType === "student_direct") {
    customerId = input.customerId ?? (await deps.stripe.customers.create(
      { email: emailNorm, metadata: { trial_order_id: orderId } },
      { idempotencyKey: `trial-cust:${orderId}:${quote.quote_version}` },
    )).id;
    session = await deps.stripe.checkout.sessions.create({
      mode: "setup",
      ui_mode: "elements",
      currency: "usd",
      customer: customerId,
      allowed_payment_method_types: ["card"],
      return_url: input.urls.returnUrl,
      setup_intent_data: {
        description: `Cramapple 7-day free trial (${input.subjectKeys.join(", ")})`,
        metadata: { trial_order_id: orderId },
      },
      metadata,
    }, { idempotencyKey: `trial-setup:${orderId}:${quote.quote_version}` });
  } else {
    session = await deps.stripe.checkout.sessions.create({
      mode: "setup",
      ui_mode: "hosted_page",
      currency: "usd",
      customer_creation: "always",
      allowed_payment_method_types: ["card"],
      success_url: input.urls.successUrl,
      cancel_url: input.urls.cancelUrl,
      consent_collection: { terms_of_service: "required" },
      custom_text: {
        submit: {
          message: parentMandateText(
            quote.charge_amount,
            input.studentName?.split(/\s+/)[0] ?? null,
            input.subjectKeys.join(", "),
          ),
        },
      },
      setup_intent_data: {
        description: `Cramapple 7-day free trial (${input.subjectKeys.join(", ")})`,
        metadata: { trial_order_id: orderId },
      },
      metadata,
    }, { idempotencyKey: `trial-setup:${orderId}:${quote.quote_version}` });
  }

  const { error: linkError } = await app.from("trial_orders")
    .update({ checkout_session_id: session.id, stripe_customer_id: customerId, updated_at: nowIso })
    .eq("id", orderId).eq("status", "pending_setup");
  if (linkError) throw linkError;

  return {
    order_id: orderId,
    session_id: session.id,
    client_secret: session.client_secret ?? null,
    url: session.url ?? null,
    quote,
  };
}
