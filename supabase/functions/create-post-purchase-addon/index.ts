import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import {
  addonCustomerOptions,
  isPayerNotLearner,
  purchaserTypeFromMetadata,
} from "../_shared/addon-checkout.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";

const ADDON_AMOUNT_CENTS = 3000;

function requireEnv(name: string) {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`Missing required environment variable: ${name}`);
  return value;
}

const APP_BASE_URL = requireEnv("APP_BASE_URL").replace(/\/$/, "");

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
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
  const sourceSessionId = asString(input.source_checkout_session_id);
  const subjectKey = asString(input.subject_key);
  if (!sourceSessionId || !subjectKey) {
    return respond({ error: "invalid_request" }, { status: 400 });
  }

  const service = createServiceClient();
  const { data: source, error: sourceError } = await service.schema("app")
    .from("stripe_checkout_sessions")
    .select(
      "id,user_id,mode,payment_status,subject_keys,metadata:payload->metadata",
    )
    .eq("id", sourceSessionId)
    .maybeSingle();
  if (sourceError) {
    return respond({ error: "status_lookup_failed" }, { status: 500 });
  }
  if (
    !source || source.payment_status !== "paid" || source.mode !== "single" ||
    !source.user_id ||
    isPayerNotLearner(
      purchaserTypeFromMetadata(source.metadata as Record<string, unknown>),
    )
  ) {
    return respond({ error: "addon_not_eligible" }, { status: 409 });
  }

  const existingKeys = Array.isArray(source.subject_keys)
    ? source.subject_keys.filter((v): v is string => typeof v === "string")
    : [];
  if (existingKeys.includes(subjectKey)) {
    return respond({ error: "already_entitled" }, { status: 409 });
  }

  const { data: subject, error: subjectError } = await service.schema("app")
    .from("subjects")
    .select("id,subject_key,display_name,status")
    .eq("subject_key", subjectKey)
    .eq("status", "active")
    .maybeSingle();
  if (subjectError) {
    return respond({ error: "subject_lookup_failed" }, { status: 500 });
  }
  if (!subject) {
    return respond({ error: "unknown_subject_key" }, { status: 400 });
  }

  const { data: already } = await service.schema("app")
    .from("subject_entitlements")
    .select("id")
    .eq("user_id", source.user_id)
    .eq("subject_id", subject.id)
    .eq("status", "active")
    .maybeSingle();
  if (already) return respond({ error: "already_entitled" }, { status: 409 });

  const { data: customer, error: customerError } = await service.schema("app")
    .from("stripe_customers")
    .select("stripe_customer_id")
    .eq("user_id", source.user_id)
    .maybeSingle();
  if (customerError) {
    return respond({ error: "customer_lookup_failed" }, { status: 500 });
  }
  const savedCustomerId = customer?.stripe_customer_id ?? null;

  try {
    const session = await stripe.checkout.sessions.create(
      {
        mode: "payment",
        ui_mode: "elements",
        ...addonCustomerOptions(savedCustomerId),
        client_reference_id: source.user_id,
        line_items: [{
          price_data: {
            currency: "usd",
            unit_amount: ADDON_AMOUNT_CENTS,
            product_data: {
              name: `Cramapple — ${subject.display_name ?? subjectKey}`,
            },
          },
          quantity: 1,
        }],
        return_url:
          `${APP_BASE_URL}/checkout/return?session_id={CHECKOUT_SESSION_ID}&role=student`,
        payment_intent_data: { setup_future_usage: "off_session" },
        metadata: {
          mode: "single",
          subject_ids: subjectKey,
          purchase_type: "post_purchase_addon",
          purchaser_type: "post_purchase_addon",
          source_checkout_session_id: sourceSessionId,
        },
      } as Parameters<typeof stripe.checkout.sessions.create>[0],
    );

    if (!session.client_secret) {
      return respond({ error: "checkout_session_failed" }, { status: 502 });
    }

    return respond({
      status: "ok",
      session_id: session.id,
      client_secret: session.client_secret,
      amount_total: ADDON_AMOUNT_CENTS,
      payment_method_reuse: savedCustomerId
        ? "available"
        : "card_entry_required",
    });
  } catch (error) {
    console.error("create-post-purchase-addon stripe_error", error);
    return respond({ error: "checkout_session_failed" }, { status: 502 });
  }
});
