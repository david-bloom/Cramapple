import { resolveCheckoutOffer, promotionDiscount } from "../_shared/checkout-offer.ts";
import { clientIp } from "../_shared/request-metadata.ts";
import { attributionMetadata, sanitizeAdAttribution } from "../_shared/trial-contract.ts";
import { requireEnv } from "../_shared/env.ts";
import { trimmedNonEmptyString as asString, emailAddress as asEmail } from "../_shared/input.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import {
  checkPublicRateLimit,
  PUBLIC_ENDPOINT_LIMITS,
  rateLimitDeps,
  rateLimitedBody,
} from "../_shared/public-rate-limit.ts";
import { stripe } from "../_shared/stripe.ts";
import {
  loadPriceCatalog,
  type PriceCatalog,
} from "../_shared/stripe-catalog.ts";
import { generateShortCode, shortLinkUrl } from "../_shared/parent-short-link.ts";
import {
  buildTrialQuote,
  readRedditClickId,
  startTrialSetup,
  TrialError,
} from "../_shared/trial-checkout.ts";

type Mode = "single" | "bundle_2" | "bundle_3";
const MODES = new Set<Mode>(["single", "bundle_2", "bundle_3"]);
const APP_BASE_URL = requireEnv("APP_BASE_URL").replace(/\/$/, "");
const PRICE_CATALOG: PriceCatalog = loadPriceCatalog();





Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") return respond({ ok: true });
  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const limiterService = createServiceClient();
  const rateLimit = await checkPublicRateLimit(
    req,
    PUBLIC_ENDPOINT_LIMITS.createParentPaymentLink,
    rateLimitDeps(limiterService),
  );
  if (!rateLimit.allowed) {
    const limited = rateLimitedBody(rateLimit.retryAfterSeconds);
    return respond(limited.body, limited.init);
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }
  const input = body as Record<string, unknown>;

  const mode = asString(input.mode) as Mode | null;
  if (!mode || !MODES.has(mode)) {
    return respond({ error: "invalid_mode" }, { status: 400 });
  }

  const studentEmail = asEmail(input.student_email);
  const studentName = asString(input.student_name);
  if (!studentEmail) {
    return respond({ error: "invalid_student_email" }, { status: 400 });
  }

  let offer: ReturnType<typeof resolveCheckoutOffer>;
  try {
    offer = resolveCheckoutOffer(PRICE_CATALOG, mode, input.subject_keys);
  } catch (error) {
    const e = error as Error & { subjectKeys?: string[] };
    return respond(
      e.message === "unknown_subject_keys"
        ? { error: e.message, subject_keys: e.subjectKeys ?? [] }
        : { error: e.message },
      { status: 400 },
    );
  }
  const { subjectKeys: keys, priceId } = offer;

  // Card trial (TASK-0077, DECISION-0126 items 2, 13, 17, 22). The student
  // sees the locked quote, applies any code and acknowledges the Terms before
  // the link exists; the code is fixed into the link.
  const trialService = createServiceClient();
  const trialDeps = {
    stripe,
    service: trialService,
    now: () => new Date(),
    admissionEnabled: Deno.env.get("TRIAL_ADMISSION_ENABLED") === "true",
    termsVersion: Deno.env.get("TRIAL_TERMS_VERSION") ?? "",
  };
  const quoteInput = {
    purchaseType: "parent_share" as const,
    offer: mode,
    subjectKeys: keys,
    priceId,
    promoCode: asString(input.promo_code),
    studentEmail,
    customerId: null,
  };
  const action = asString(input.action);
  try {
    if (action === "trial_quote") {
      return respond({ status: "ok", quote: await buildTrialQuote(trialDeps, quoteInput) });
    }
    if (action === "trial_start") {
      const ack = input.student_ack as { version?: unknown } | undefined;
      if (input.terms_accepted !== true || typeof ack?.version !== "string") {
        return respond({ error: "terms_acknowledgment_required" }, { status: 400 });
      }
      const started = await startTrialSetup(trialDeps, {
        ...quoteInput,
        quoteVersion: asString(input.quote_version) ?? "",
        studentAck: { version: ack.version, source: "parent_share_drawer" },
        studentName,
        consentIp: clientIp(req),
        consentUserAgent: req.headers.get("user-agent"),
        adAttribution: sanitizeAdAttribution(input.ad_attribution),
        redditClickId: readRedditClickId(input.ad_attribution),
        urls: {
          successUrl:
            `${APP_BASE_URL}/checkout/success?session_id={CHECKOUT_SESSION_ID}&role=parent&trial=1`,
          cancelUrl: `${APP_BASE_URL}/checkout?ask=parent`,
        },
      });
      await recordGrowthEvent(trialService, {
        eventName: "checkout_started",
        userId: null,
        source: "stripe",
        dedupeKey: `checkout_started:${started.session_id}`,
        properties: { offer: mode, access_tier: "trial" },
      });
      let trialShortUrl: string | null = null;
      for (let attempt = 0; attempt < 5 && !trialShortUrl; attempt++) {
        const code = generateShortCode();
        const { error: insertError } = await trialService.schema("app")
          .from("parent_payment_links")
          .insert({ code, checkout_session_id: started.session_id });
        if (!insertError) trialShortUrl = shortLinkUrl(APP_BASE_URL, code);
        else if (insertError.code !== "23505") break;
      }
      return respond({
        status: "ok",
        billing_mode: "trial",
        order_id: started.order_id,
        session_id: started.session_id,
        url: started.url,
        short_url: trialShortUrl,
        quote: started.quote,
      });
    }
    if (trialDeps.admissionEnabled) {
      const quote = await buildTrialQuote(trialDeps, quoteInput);
      if (quote.billing_mode === "trial") {
        return respond({ error: "trial_required", quote }, { status: 409 });
      }
    }
  } catch (error) {
    if (error instanceof TrialError) {
      return respond({ error: error.code }, { status: error.status });
    }
    console.error("create-parent-payment-link trial_error", error);
    return respond({ error: "checkout_session_failed" }, { status: 502 });
  }

  let promotionCodeId: string | null = null;
  try {
    promotionCodeId = await promotionDiscount(stripe, asString(input.promo_code));
  } catch {
    return respond({ error: "promo_code_invalid" }, { status: 400 });
  }

  try {
    const session = await stripe.checkout.sessions.create({
      mode: "payment",
      // No setup_future_usage: the parent's card is never saved for reuse
      // (DECISION-0090). The Customer still carries the parent's receipt.
      customer_creation: "always",
      line_items: [{ price: priceId, quantity: 1 }],
      ...(promotionCodeId
        ? { discounts: [{ promotion_code: promotionCodeId }] }
        : { allow_promotion_codes: true }),
      success_url:
        `${APP_BASE_URL}/checkout/success?session_id={CHECKOUT_SESSION_ID}&role=parent`,
      cancel_url: `${APP_BASE_URL}/checkout?ask=parent`,
      metadata: {
        mode,
        subject_ids: keys.join(","),
        purchase_type: "parent_share",
        purchaser_type: "parent_share",
        student_email: studentEmail,
        ...(studentName ? { student_name: studentName } : {}),
        ...attributionMetadata(sanitizeAdAttribution(input.ad_attribution)),
      },
    });

    if (!session.url) {
      return respond({ error: "checkout_session_failed" }, { status: 502 });
    }

    const service = createServiceClient();
    await recordGrowthEvent(service, {
      eventName: "checkout_started",
      userId: null,
      source: "stripe",
      dedupeKey: `checkout_started:${session.id}`,
      properties: {
        offer: mode,
        access_tier: "paid",
      },
    });

    // Short link (TASK-0060): cramapple.com/p/<code> resolves to this session's
    // live Stripe URL. If storing the code fails the long URL still works, so a
    // failure here must never block the parent from paying.
    let shortUrl: string | null = null;
    for (let attempt = 0; attempt < 5 && !shortUrl; attempt++) {
      const code = generateShortCode();
      const { error: insertError } = await service.schema("app")
        .from("parent_payment_links")
        .insert({ code, checkout_session_id: session.id });
      if (!insertError) {
        shortUrl = shortLinkUrl(APP_BASE_URL, code);
      } else if (insertError.code !== "23505") {
        console.error("create-parent-payment-link short_link_failed", insertError);
        break;
      }
    }

    return respond({
      status: "ok",
      session_id: session.id,
      url: session.url,
      short_url: shortUrl,
      // What the parent will actually pay, discounts included (minor units).
      amount_total: session.amount_total ?? null,
      currency: session.currency ?? null,
    });
  } catch (error) {
    console.error("create-parent-payment-link stripe_error", error);
    return respond({ error: "checkout_session_failed" }, { status: 502 });
  }
});
