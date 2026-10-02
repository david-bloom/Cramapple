import { requireProfile } from "../_shared/auth.ts";
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

function asSubjectKeys(value: unknown) {
  if (!Array.isArray(value)) return null;
  const keys = value.filter(
    (entry): entry is string =>
      typeof entry === "string" && entry.trim().length > 0,
  ).map((entry) => entry.trim());
  return keys.length === value.length ? keys : null;
}

function stripeErrorDetails(error: unknown) {
  if (!error || typeof error !== "object") {
    return {
      stripe_error_type: null,
      stripe_error_code: null,
      stripe_error_param: null,
      error_message: "checkout_session_failed",
    };
  }
  const value = error as {
    type?: unknown;
    code?: unknown;
    param?: unknown;
    message?: unknown;
  };
  return {
    stripe_error_type: typeof value.type === "string" ? value.type : null,
    stripe_error_code: typeof value.code === "string" ? value.code : null,
    stripe_error_param: typeof value.param === "string" ? value.param : null,
    error_message: typeof value.message === "string"
      ? value.message.slice(0, 500)
      : "checkout_session_failed",
  };
}

async function recordCheckoutAttempt(params: {
  userId: string | null;
  mode: Mode;
  subjectKeys: string[];
  status: "started" | "failed";
  error?: unknown;
}) {
  const service = createServiceClient();
  const details = params.error ? stripeErrorDetails(params.error) : {
    stripe_error_type: null,
    stripe_error_code: null,
    stripe_error_param: null,
    error_message: null,
  };
  const { error } = await service.schema("app")
    .from("stripe_checkout_session_attempts")
    .insert({
      user_id: params.userId,
      mode: params.mode,
      subject_keys: params.subjectKeys,
      status: params.status,
      ...details,
    });
  if (error) {
    console.error("create-checkout-session attempt_insert_failed", error);
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

  const auth = await requireProfile(req);
  if (!auth) return respond({ error: "unauthorized" }, { status: 401 });
  if (auth.profile.role !== "student" && auth.profile.role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
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

  const userId = auth.user.id;

  try {
    await recordCheckoutAttempt({
      userId,
      mode,
      subjectKeys,
      status: "started",
    });

    const session = await stripe.checkout.sessions.create({
      mode: "payment",
      line_items: [{ price: priceId, quantity: 1 }],
      client_reference_id: userId,
      customer_email: auth.user.email ?? undefined,
      allow_promotion_codes: true,
      success_url:
        `${APP_BASE_URL}/checkout/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${APP_BASE_URL}/checkout/cancel`,
      metadata: {
        mode,
        subject_ids: subjectKeys.join(","),
        user_id: userId,
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
    await recordCheckoutAttempt({
      userId,
      mode,
      subjectKeys,
      status: "failed",
      error,
    });
    const details = stripeErrorDetails(error);
    return respond(
      {
        error: "checkout_session_failed",
        stripe_error_type: details.stripe_error_type,
        stripe_error_code: details.stripe_error_code,
        stripe_error_param: details.stripe_error_param,
      },
      { status: 502 },
    );
  }
});
