import { requireProfile } from "../_shared/auth.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";
import { loadPriceCatalog, type PriceCatalog } from "../_shared/stripe-catalog.ts";

type Mode = "single" | "bundle_2" | "bundle_3" | "unlimited";
const MODES = new Set<Mode>(["single", "bundle_2", "bundle_3", "unlimited"]);
const REQUIRED_SUBJECT_COUNT: Record<"single" | "bundle_2" | "bundle_3", number> = {
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

  // Parent-gift checkout: a parent buying for a student who doesn't have an
  // account yet. supabase-js always attaches an Authorization header (the
  // anon key when there's no session), so presence/absence of that header
  // can't signal "not logged in" - the caller declares gift mode explicitly
  // instead. This doesn't widen what an unauthenticated caller can already
  // do with the public anon key; it only changes who ends up holding the
  // entitlement once Stripe confirms payment.
  const isGiftCheckout = asString(input.purchase_type) === "parent_gift";

  let userId: string | null = null;
  let payerEmail: string | undefined;
  let studentEmail: string | null = null;
  let studentName: string | null = null;

  if (isGiftCheckout) {
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
    const session = await stripe.checkout.sessions.create({
      mode: "payment",
      line_items: [{ price: priceId, quantity: 1 }],
      ...(userId ? { client_reference_id: userId } : {}),
      customer_email: payerEmail,
      allow_promotion_codes: true,
      success_url:
        `${APP_BASE_URL}/checkout/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${APP_BASE_URL}/checkout/cancel`,
      metadata: {
        mode,
        subject_ids: subjectKeys.join(","),
        ...(userId ? { user_id: userId } : {}),
        ...(isGiftCheckout
          ? {
            purchase_type: "parent_gift",
            student_email: studentEmail as string,
            student_name: studentName as string,
          }
          : {}),
      },
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

    return respond({ status: "ok", url: session.url, session_id: session.id });
  } catch (error) {
    console.error("create-checkout-session stripe_error", error);
    return respond({ error: "checkout_session_failed" }, { status: 502 });
  }
});
