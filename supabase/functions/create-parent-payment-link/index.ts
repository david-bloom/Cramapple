import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";
import {
  loadPriceCatalog,
  type PriceCatalog,
} from "../_shared/stripe-catalog.ts";
import { generateShortCode, shortLinkUrl } from "../_shared/parent-short-link.ts";

type Mode = "single" | "bundle_2" | "bundle_3";
const MODES = new Set<Mode>(["single", "bundle_2", "bundle_3"]);
const REQUIRED_SUBJECT_COUNT: Record<Mode, number> = {
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

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asEmail(value: unknown) {
  const email = asString(value);
  if (!email) return null;
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) ? email.toLowerCase() : null;
}

function asSubjectKeys(value: unknown) {
  if (!Array.isArray(value)) return null;
  const keys = value.filter(
    (entry): entry is string =>
      typeof entry === "string" && entry.trim().length > 0,
  ).map((entry) => entry.trim());
  return keys.length === value.length ? keys : null;
}

async function promotionDiscount(code: string | null) {
  if (!code) return null;
  const list = await stripe.promotionCodes.list({
    code: code.trim().toUpperCase(),
    active: true,
    limit: 1,
  });
  const promotion = list.data[0];
  if (!promotion) throw new Error("promo_code_invalid");
  return promotion.id;
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

  const studentEmail = asEmail(input.student_email);
  const studentName = asString(input.student_name);
  if (!studentEmail) {
    return respond({ error: "invalid_student_email" }, { status: 400 });
  }

  const keys = asSubjectKeys(input.subject_keys);
  if (
    !keys ||
    keys.length !== REQUIRED_SUBJECT_COUNT[mode] ||
    new Set(keys).size !== keys.length
  ) {
    return respond({ error: "invalid_subject_keys" }, { status: 400 });
  }

  const unknownKeys = keys.filter((key) => !PRICE_CATALOG.subjects[key]);
  if (unknownKeys.length > 0) {
    return respond(
      { error: "unknown_subject_keys", subject_keys: unknownKeys },
      { status: 400 },
    );
  }

  const priceId = mode === "single"
    ? PRICE_CATALOG.subjects[keys[0]]
    : mode === "bundle_2"
    ? PRICE_CATALOG.bundle_2
    : PRICE_CATALOG.bundle_3;

  let promotionCodeId: string | null = null;
  try {
    promotionCodeId = await promotionDiscount(asString(input.promo_code));
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
