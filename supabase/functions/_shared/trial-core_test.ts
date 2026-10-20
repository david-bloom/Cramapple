import { assertEquals, assertNotEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  classifyConfirmError,
  easternDate,
  hashCapabilityToken,
  looksLikeCapabilityToken,
  mandateText,
  newCapabilityToken,
  parentMandateText,
  quoteVersion,
  trialChargeFloor,
} from "./trial-core.ts";

Deno.test("dates render in Eastern time, across a DST change", () => {
  // 2026-11-01 03:30 UTC is still Oct 31 in New York (EDT, UTC-4).
  assertEquals(easternDate(new Date("2026-11-01T03:30:00Z")), "Saturday, October 31, 2026");
  // 2026-11-02 04:30 UTC is Nov 1 in New York after the change (EST, UTC-5).
  assertEquals(easternDate(new Date("2026-11-02T04:30:00Z")), "Sunday, November 1, 2026");
});

Deno.test("the charge floor is seven days out and the mandate states it", () => {
  const now = new Date("2026-10-18T16:00:00Z");
  assertEquals(trialChargeFloor(now).toISOString(), "2026-10-25T16:00:00.000Z");
  assertEquals(
    mandateText(1999, trialChargeFloor(now)),
    "$0 today. On Sunday, October 25, 2026 (Eastern) we'll charge $19.99 to this card unless you cancel. Cancel any time in Account. Canceling ends trial access right away.",
  );
});

Deno.test("the parent's mandate says cancelling ends access right away and fits Stripe's limit", () => {
  const text = parentMandateText(3999, "Sam", "AP Biology");
  assertEquals(
    text,
    "Free for 7 days. When the trial ends we'll charge $39.99 to this card for Sam's AP Biology unless you cancel. You can cancel from the link in your confirmation email. Canceling ends trial access right away.",
  );
  assertEquals(text.length <= 1200, true);
});

Deno.test("quote version changes with the price and ignores subject order", async () => {
  const base = {
    offer: "bundle_2",
    subjectKeys: ["biology", "statistics"],
    priceId: "price_b2",
    listAmount: 6999,
    discountAmount: 0,
    chargeAmount: 6999,
    promotionCodeId: null,
    termsVersion: "terms-1",
  };
  const a = await quoteVersion(base);
  assertEquals(await quoteVersion({ ...base, subjectKeys: ["statistics", "biology"] }), a);
  assertNotEquals(await quoteVersion({ ...base, discountAmount: 100, chargeAmount: 6899 }), a);
  assertNotEquals(await quoteVersion({ ...base, termsVersion: "terms-2" }), a);
});

Deno.test("capability tokens are random, 43 url-safe chars, stored only as a hash", async () => {
  const one = await newCapabilityToken();
  const two = await newCapabilityToken();
  assertEquals(looksLikeCapabilityToken(one.token), true);
  assertNotEquals(one.token, two.token);
  assertEquals(await hashCapabilityToken(one.token), one.hash);
  assertEquals(/^[0-9a-f]{64}$/.test(one.hash), true);
  assertEquals(looksLikeCapabilityToken("short"), false);
});

Deno.test("confirm errors: authentication, retryable and hard declines, transport", () => {
  assertEquals(
    classifyConfirmError({ type: "StripeCardError", code: "authentication_required" }).outcome,
    "requires_action",
  );
  assertEquals(
    classifyConfirmError({ type: "StripeCardError", code: "card_declined", decline_code: "insufficient_funds" }).outcome,
    "declined_retryable",
  );
  assertEquals(
    classifyConfirmError({ type: "StripeCardError", code: "card_declined", decline_code: "stolen_card" }).outcome,
    "declined_hard",
  );
  assertEquals(classifyConfirmError({ type: "StripeCardError", code: "expired_card" }).outcome, "declined_hard");
  assertEquals(classifyConfirmError({ type: "StripeConnectionError" }).outcome, "transport_error");
  assertEquals(classifyConfirmError({ type: "StripeAPIError", statusCode: 500 }).outcome, "transport_error");
  assertEquals(
    classifyConfirmError({
      type: "StripeInvalidRequestError",
      code: "payment_intent_unexpected_state",
      raw: { payment_intent: { status: "canceled" } },
    }).outcome,
    "canceled_observed",
  );
  assertEquals(
    classifyConfirmError({ type: "StripeInvalidRequestError", code: "payment_intent_unexpected_state",
      raw: { payment_intent: { status: "succeeded" } } }).outcome,
    "transport_error",
  );
});
