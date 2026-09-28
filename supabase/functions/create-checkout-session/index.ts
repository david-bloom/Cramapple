import { requireProfile } from "../_shared/auth.ts";
import {
  PURCHASE_TYPES,
  type PurchaseType,
} from "../_shared/checkout-contract.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";
import {
  loadPriceCatalog,
  type PriceCatalog,
} from "../_shared/stripe-catalog.ts";

type Mode = "single" | "bundle_2" | "bundle_3" | "unlimited";
const MODES = new Set<Mode>(["single", "bundle_2", "bundle_3", "unlimited"]);
const REQUIRED_SUBJECT_COUNT: Record<
  "single" | "bundle_2" | "bundle_3",
  number
> = {
  single: 1,
  bundle_2: 2,
  bundle_3: 3,
};

function requireEnv(name: string) {
  const value = Deno.env.get(name);
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

// Fail fast at module load, matching the pattern in _shared/supabase.ts and
// _shared/cors.ts. Used to build the Checkout Session success/cancel URLs.
const APP_BASE_URL = requireEnv("APP_BASE_URL").replace(/\/$/, "");

// Also fail fast on a missing/malformed catalog rather than booting and
// only discovering it on the first request.
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

function integrationIdentifier() {
  const randomBytes = crypto.getRandomValues(new Uint8Array(8));
  const suffix = Array.from(
    randomBytes,
    (value) => String.fromCharCode(97 + (value % 26)),
  ).join("");
  return `cramapple_checkout_${suffix}`;
}

export async function handleCreateCheckoutSession(
  req: Request,
  forcedPurchaseType?: PurchaseType,
) {
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

  const rawPurchaseType = forcedPurchaseType ?? asString(input.purchase_type);
  if (
    rawPurchaseType &&
    !PURCHASE_TYPES.has(rawPurchaseType as PurchaseType)
  ) {
    return respond({ error: "invalid_purchase_type" }, { status: 400 });
  }
  const purchaseType = rawPurchaseType as PurchaseType | null;

  let userId: string | null = null;
  let payerEmail: string | undefined;
  let studentEmail: string | null = null;
  let studentName: string | null = null;

  if (purchaseType === "parent_gift") {
    studentEmail = asEmail(input.student_email);
    studentName = asString(input.student_name);
    if (!studentEmail || !studentName) {
      return respond(
        {
          error: "missing_student_details",
          required: ["student_name", "student_email"],
        },
        { status: 400 },
      );
    }
  } else if (
    purchaseType === "student_direct" || purchaseType === "parent_share"
  ) {
    const auth = await requireProfile(req);
    if (
      auth && auth.profile.role !== "student" && auth.profile.role !== "admin"
    ) {
      return respond({ error: "forbidden" }, { status: 403 });
    }

    const requestedStudentEmail = asEmail(input.student_email);
    const authenticatedEmail = asEmail(auth?.user.email);
    if (
      purchaseType === "student_direct" && authenticatedEmail &&
      requestedStudentEmail && authenticatedEmail !== requestedStudentEmail
    ) {
      return respond({ error: "student_email_mismatch" }, { status: 403 });
    }

    studentEmail = authenticatedEmail ?? requestedStudentEmail;
    if (!studentEmail) {
      return respond(
        { error: "missing_student_details", required: ["student_email"] },
        { status: 400 },
      );
    }
    userId = auth?.user.id ?? null;
    payerEmail = purchaseType === "student_direct" ? studentEmail : undefined;
    studentName = auth?.profile.full_name ?? asString(input.student_name);
  } else {
    const auth = await requireProfile(req);
    if (!auth) return respond({ error: "unauthorized" }, { status: 401 });
    if (auth.profile.role !== "student" && auth.profile.role !== "admin") {
      return respond({ error: "forbidden" }, { status: 403 });
    }
    userId = auth.user.id;
    payerEmail = auth.user.email ?? undefined;
  }

  const catalog = PRICE_CATALOG;

  let priceId: string;
  let subjectKeys: string[] = [];

  if (mode === "unlimited") {
    priceId = catalog.unlimited;
  } else {
    const keys = asSubjectKeys(input.subject_keys);
    const requiredCount = REQUIRED_SUBJECT_COUNT[mode];
    if (
      !keys || keys.length !== requiredCount ||
      new Set(keys).size !== keys.length
    ) {
      return respond({ error: "invalid_subject_keys" }, { status: 400 });
    }
    const unknownKeys = keys.filter((key) => !catalog.subjects[key]);
    if (unknownKeys.length > 0) {
      return respond(
        { error: "unknown_subject_keys", subject_keys: unknownKeys },
        { status: 400 },
      );
    }
    subjectKeys = keys;
    priceId = mode === "single"
      ? catalog.subjects[keys[0]]
      : mode === "bundle_2"
      ? catalog.bundle_2
      : catalog.bundle_3;
  }

  try {
    const promoCode = asString(input.promo_code);
    let promotionCodeId: string | null = null;
    if (promoCode) {
      const promotionCodes = await stripe.promotionCodes.list({
        code: promoCode,
        active: true,
        limit: 1,
      });
      promotionCodeId = promotionCodes.data[0]?.id ?? null;
      if (!promotionCodeId) {
        return respond({ error: "invalid_promo_code" }, { status: 400 });
      }
    }

    const metadata = {
      mode,
      subject_ids: subjectKeys.join(","),
      ...(userId ? { user_id: userId } : {}),
      ...(purchaseType
        ? {
          purchaser_type: purchaseType,
          purchase_type: purchaseType,
          student_email: studentEmail as string,
          ...(studentName ? { student_name: studentName } : {}),
          is_upsell_eligible: String(mode === "single"),
        }
        : {}),
    };

    const commonParams = {
      mode: "payment" as const,
      integration_identifier: integrationIdentifier(),
      line_items: [{ price: priceId, quantity: 1 }],
      ...(userId ? { client_reference_id: userId } : {}),
      ...(promotionCodeId
        ? { discounts: [{ promotion_code: promotionCodeId }] }
        : { allow_promotion_codes: true }),
      metadata,
    };

    const session = purchaseType === "student_direct"
      ? await stripe.checkout.sessions.create({
        ...commonParams,
        ui_mode: "custom",
        customer_creation: "always",
        customer_email: payerEmail,
        payment_intent_data: { setup_future_usage: "off_session" },
        return_url:
          `${APP_BASE_URL}/checkout/return?session_id={CHECKOUT_SESSION_ID}`,
      })
      : await stripe.checkout.sessions.create({
        ...commonParams,
        ui_mode: "hosted",
        customer_email: payerEmail,
        success_url: purchaseType === "parent_share"
          ? `${APP_BASE_URL}/checkout/success?session_id={CHECKOUT_SESSION_ID}&role=parent`
          : `${APP_BASE_URL}/checkout/success?session_id={CHECKOUT_SESSION_ID}`,
        cancel_url: purchaseType === "parent_share"
          ? `${APP_BASE_URL}/checkout/parent-cancelled`
          : `${APP_BASE_URL}/checkout/cancel`,
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
        purchaser_type: purchaseType ?? "authenticated_legacy",
      },
    });

    return respond({
      status: "ok",
      session_id: session.id,
      ...(purchaseType === "student_direct"
        ? { client_secret: session.client_secret }
        : { url: session.url }),
    });
  } catch (error) {
    console.error("create-checkout-session stripe_error", error);
    return respond({ error: "checkout_session_failed" }, { status: 502 });
  }
}

if (import.meta.main) {
  Deno.serve((req) => handleCreateCheckoutSession(req));
}
