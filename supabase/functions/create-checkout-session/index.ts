import { trimmedNonEmptyString as asString, emailAddress as asEmail } from "../_shared/input.ts";
import { requireProfile } from "../_shared/auth.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";
import { loadPriceCatalog, type PriceCatalog } from "../_shared/stripe-catalog.ts";
import {
  checkPublicRateLimit,
  PUBLIC_ENDPOINT_LIMITS,
  rateLimitDeps,
  rateLimitedBody,
} from "../_shared/public-rate-limit.ts";
import {
  buildTrialQuote,
  startTrialSetup,
  type TrialDeps,
  TrialError,
} from "../_shared/trial-checkout.ts";

type Mode = "single" | "bundle_2" | "bundle_3" | "unlimited";
type PurchaseType = "student_direct" | "parent_gift" | "legacy_authenticated";

const MODES = new Set<Mode>(["single", "bundle_2", "bundle_3", "unlimited"]);
const REQUIRED_SUBJECT_COUNT: Record<"single" | "bundle_2" | "bundle_3", number> = {
  single: 1,
  bundle_2: 2,
  bundle_3: 3,
};

function requireEnv(name: string) {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`Missing required environment variable: ${name}`);
  return value;
}

const APP_BASE_URL = requireEnv("APP_BASE_URL").replace(/\/$/, "");
const PRICE_CATALOG: PriceCatalog = loadPriceCatalog();

// TASK-0077: new card trials start only while this is "true". Off, checkout
// is pay-now as before (rollback: plan §8).
function trialDeps(service: ReturnType<typeof createServiceClient>): TrialDeps {
  return {
    stripe,
    service,
    now: () => new Date(),
    admissionEnabled: Deno.env.get("TRIAL_ADMISSION_ENABLED") === "true",
    termsVersion: Deno.env.get("TRIAL_TERMS_VERSION") ?? "",
  };
}

function clientIp(req: Request) {
  return req.headers.get("cf-connecting-ip")?.trim() ||
    req.headers.get("x-forwarded-for")?.split(",")[0]?.trim() || null;
}





function asSubjectKeys(value: unknown) {
  if (!Array.isArray(value)) return null;
  const keys = value.filter(
    (entry): entry is string =>
      typeof entry === "string" && entry.trim().length > 0,
  ).map((entry) => entry.trim());
  return keys.length === value.length ? keys : null;
}

function resolveOffer(mode: Mode, input: Record<string, unknown>) {
  const catalog = PRICE_CATALOG;
  if (mode === "unlimited") {
    return { priceId: catalog.unlimited, subjectKeys: [] as string[] };
  }

  const keys = asSubjectKeys(input.subject_keys);
  const requiredCount = REQUIRED_SUBJECT_COUNT[mode];
  if (
    !keys || keys.length !== requiredCount ||
    new Set(keys).size !== keys.length
  ) {
    throw new Error("invalid_subject_keys");
  }

  const unknownKeys = keys.filter((key) => !catalog.subjects[key]);
  if (unknownKeys.length > 0) {
    const error = new Error("unknown_subject_keys") as Error & {
      subjectKeys?: string[];
    };
    error.subjectKeys = unknownKeys;
    throw error;
  }

  return {
    subjectKeys: keys,
    priceId: mode === "single"
      ? catalog.subjects[keys[0]]
      : mode === "bundle_2"
      ? catalog.bundle_2
      : catalog.bundle_3,
  };
}

async function promotionDiscount(code: string | null) {
  if (!code) return null;
  const normalized = code.trim().toUpperCase();
  if (!normalized) return null;

  const list = await stripe.promotionCodes.list({
    code: normalized,
    active: true,
    limit: 1,
  });
  const promotion = list.data[0];
  if (!promotion) throw new Error("promo_code_invalid");
  return promotion.id;
}

async function optionalProfile(req: Request) {
  try {
    return await requireProfile(req);
  } catch {
    return null;
  }
}

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") return respond({ ok: true });
  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
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

  const requestedType = asString(input.purchase_type);
  const purchaseType: PurchaseType = requestedType === "student_direct"
    ? "student_direct"
    : requestedType === "parent_gift"
    ? "parent_gift"
    : "legacy_authenticated";

  let offer: ReturnType<typeof resolveOffer>;
  try {
    offer = resolveOffer(mode, input);
  } catch (error) {
    const e = error as Error & { subjectKeys?: string[] };
    return respond(
      e.message === "unknown_subject_keys"
        ? { error: e.message, subject_keys: e.subjectKeys ?? [] }
        : { error: e.message },
      { status: 400 },
    );
  }

  const profile = await optionalProfile(req);
  let userId: string | null = profile?.user.id ?? null;
  let studentEmail: string | null = null;
  let studentName: string | null = null;

  if (purchaseType === "student_direct") {
    if (mode === "unlimited") {
      return respond({ error: "invalid_mode" }, { status: 400 });
    }
    studentEmail = asEmail(input.student_email);
    if (!studentEmail) {
      return respond({ error: "invalid_student_email" }, { status: 400 });
    }
    if (
      profile &&
      profile.profile.role !== "student" &&
      profile.profile.role !== "admin"
    ) {
      return respond({ error: "forbidden" }, { status: 403 });
    }
    const accountEmail = profile?.user.email?.toLowerCase() ?? null;
    if (accountEmail && accountEmail !== studentEmail) {
      return respond({ error: "email_mismatch" }, { status: 409 });
    }

    // Card trial (TASK-0077). The server decides the billing mode; a legacy
    // pay-now request from a buyer who should be on a trial is refused, so
    // nobody is charged today after the trial policy applies to them.
    const action = asString(input.action);
    const service = createServiceClient();
    const deps = trialDeps(service);
    const trialMode = mode as "single" | "bundle_2" | "bundle_3";
    let customerId: string | null = null;
    if (userId) {
      const { data: mapping } = await service.schema("app").from("stripe_customers")
        .select("stripe_customer_id").eq("user_id", userId).maybeSingle();
      customerId = mapping?.stripe_customer_id ?? null;
    }
    const quoteInput = {
      purchaseType: "student_direct" as const,
      offer: trialMode,
      subjectKeys: offer.subjectKeys,
      priceId: offer.priceId,
      promoCode: asString(input.promo_code),
      studentEmail,
      customerId,
    };
    try {
      if (action === "trial_quote" || action === "trial_start") {
        const limit = await checkPublicRateLimit(
          req,
          PUBLIC_ENDPOINT_LIMITS.trialCheckout,
          rateLimitDeps(service),
        );
        if (!limit.allowed) {
          const limited = rateLimitedBody(limit.retryAfterSeconds);
          return respond(limited.body, limited.init);
        }
      }
      if (action === "trial_quote") {
        return respond({ status: "ok", quote: await buildTrialQuote(deps, quoteInput) });
      }
      if (action === "trial_start") {
        const ack = input.student_ack as { version?: unknown } | undefined;
        if (input.terms_accepted !== true || typeof ack?.version !== "string") {
          return respond({ error: "terms_acknowledgment_required" }, { status: 400 });
        }
        const started = await startTrialSetup(deps, {
          ...quoteInput,
          quoteVersion: asString(input.quote_version) ?? "",
          studentAck: { version: ack.version, source: "checkout" },
          studentName: null,
          consentIp: clientIp(req),
          consentUserAgent: req.headers.get("user-agent"),
          urls: {
            returnUrl:
              `${APP_BASE_URL}/checkout/return?session_id={CHECKOUT_SESSION_ID}&role=student&trial=1`,
          },
        });
        await recordGrowthEvent(service, {
          eventName: "checkout_started",
          userId,
          source: "stripe",
          dedupeKey: `checkout_started:${started.session_id}`,
          properties: { offer: mode, access_tier: "trial" },
        });
        return respond({
          status: "ok",
          billing_mode: "trial",
          order_id: started.order_id,
          session_id: started.session_id,
          client_secret: started.client_secret,
          quote: started.quote,
        });
      }
      if (deps.admissionEnabled) {
        const quote = await buildTrialQuote(deps, quoteInput);
        if (quote.billing_mode === "trial") {
          return respond({ error: "trial_required", quote }, { status: 409 });
        }
      }
    } catch (error) {
      if (error instanceof TrialError) {
        return respond({ error: error.code }, { status: error.status });
      }
      console.error("create-checkout-session trial_error", error);
      return respond({ error: "checkout_session_failed" }, { status: 502 });
    }
  } else if (purchaseType === "parent_gift") {
    studentEmail = asEmail(input.student_email);
    studentName = asString(input.student_name);
    userId = null;
    if (!studentEmail || !studentName) {
      return respond(
        {
          error: "missing_student_details",
          required: ["student_name", "student_email"],
        },
        { status: 400 },
      );
    }
  } else {
    if (!profile) return respond({ error: "unauthorized" }, { status: 401 });
    if (profile.profile.role !== "student" && profile.profile.role !== "admin") {
      return respond({ error: "forbidden" }, { status: 403 });
    }
    studentEmail = profile.user.email?.toLowerCase() ?? null;
  }

  let promotionCodeId: string | null = null;
  try {
    promotionCodeId = await promotionDiscount(asString(input.promo_code));
  } catch (error) {
    return respond(
      { error: error instanceof Error ? error.message : "promo_code_invalid" },
      { status: 400 },
    );
  }

  try {
    const common = {
      mode: "payment" as const,
      line_items: [{ price: offer.priceId, quantity: 1 }],
      ...(userId ? { client_reference_id: userId } : {}),
      ...(studentEmail ? { customer_email: studentEmail } : {}),
      metadata: {
        mode,
        subject_ids: offer.subjectKeys.join(","),
        ...(userId ? { user_id: userId } : {}),
        ...(studentEmail ? { student_email: studentEmail } : {}),
        ...(studentName ? { student_name: studentName } : {}),
        ...(purchaseType !== "legacy_authenticated"
          ? {
            purchase_type: purchaseType,
            purchaser_type: purchaseType,
          }
          : {}),
        ...(purchaseType === "student_direct"
          ? { is_upsell_eligible: String(mode === "single") }
          : {}),
      },
      ...(promotionCodeId
        ? { discounts: [{ promotion_code: promotionCodeId }] }
        : { allow_promotion_codes: true }),
    };

    const session = purchaseType === "student_direct"
      ? await stripe.checkout.sessions.create({
        ...common,
        // Current Stripe terminology for a fully custom Elements checkout.
        ui_mode: "elements",
        return_url:
          `${APP_BASE_URL}/checkout/return?session_id={CHECKOUT_SESSION_ID}&role=student`,
        customer_creation: "always",
        payment_intent_data: { setup_future_usage: "off_session" },
      } as Parameters<typeof stripe.checkout.sessions.create>[0])
      : await stripe.checkout.sessions.create({
        ...common,
        success_url:
          `${APP_BASE_URL}/checkout/success?session_id={CHECKOUT_SESSION_ID}`,
        cancel_url: `${APP_BASE_URL}/checkout/cancel`,
      });

    const service = createServiceClient();
    await recordGrowthEvent(service, {
      eventName: "checkout_started",
      userId,
      source: "stripe",
      dedupeKey: `checkout_started:${session.id}`,
      properties: {
        offer: mode,
        access_tier: "paid",
      },
    });

    if (purchaseType === "student_direct") {
      if (!session.client_secret) {
        console.error("create-checkout-session missing_client_secret", session.id);
        return respond({ error: "checkout_session_failed" }, { status: 502 });
      }
      return respond({
        status: "ok",
        session_id: session.id,
        client_secret: session.client_secret,
      });
    }

    return respond({ status: "ok", url: session.url, session_id: session.id });
  } catch (error) {
    console.error("create-checkout-session stripe_error", error);
    const stripeError = error as {
      type?: string;
      code?: string;
      param?: string;
      message?: string;
    };
    try {
      const service = createServiceClient();
      await service.schema("app").from("stripe_checkout_session_attempts")
        .insert({
          user_id: userId,
          mode,
          subject_keys: offer.subjectKeys,
          status: "failed",
          stripe_error_type: stripeError.type ?? null,
          stripe_error_code: stripeError.code ?? null,
          stripe_error_param: stripeError.param ?? null,
          error_message: stripeError.message?.slice(0, 500) ?? null,
        });
    } catch {
      // Attempt logging must never mask the checkout failure itself.
    }
    return respond({ error: "checkout_session_failed" }, { status: 502 });
  }
});
