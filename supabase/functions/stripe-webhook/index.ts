import { jsonResponse } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { verifyStripeWebhookEvent } from "../_shared/stripe.ts";

// This function is the sole authority for granting Stripe-purchased
// entitlements and for the purchase_completed/referred_purchase growth
// events — never the client-side checkout redirect. See
// docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md.

type CheckoutSessionObject = {
  id: string;
  client_reference_id: string | null;
  currency: string | null;
  metadata: Record<string, string> | null;
  total_details?: { amount_discount?: number | null } | null;
};

type Service = ReturnType<typeof createServiceClient>;

function parseSubjectKeys(raw: string | undefined) {
  if (!raw) return [];
  return raw.split(",").map((entry) => entry.trim()).filter(Boolean);
}

async function grantEntitlement(service: Service, params: {
  userId: string;
  subjectId: string;
  source: string;
  allSubjects: boolean;
  checkoutSessionId: string;
  eventId: string;
}) {
  const { error } = await service.schema("app").from("subject_entitlements")
    .upsert(
      {
        user_id: params.userId,
        subject_id: params.subjectId,
        access_tier: "paid",
        status: "active",
        source: params.source,
        all_subjects: params.allSubjects,
        stripe_checkout_session_id: params.checkoutSessionId,
        stripe_event_id: params.eventId,
        starts_at: new Date().toISOString(),
        ends_at: null,
      },
      { onConflict: "user_id,subject_id,access_tier,source" },
    );
  if (error) throw error;
}

async function handleCheckoutSessionCompleted(
  service: Service,
  session: CheckoutSessionObject,
  eventId: string,
) {
  const userId = session.client_reference_id;
  if (!userId) {
    throw new Error("checkout_session_missing_client_reference_id");
  }

  const metadata = session.metadata ?? {};
  const mode = metadata.mode ?? "single";
  const checkoutSessionId = session.id;

  if (mode === "unlimited") {
    const { data: subjects, error: subjectsError } = await service.schema(
      "app",
    ).from("subjects").select("id").eq("status", "active");
    if (subjectsError) throw subjectsError;
    for (const subject of subjects ?? []) {
      await grantEntitlement(service, {
        userId,
        subjectId: subject.id as string,
        source: "stripe_checkout_unlimited",
        allSubjects: true,
        checkoutSessionId,
        eventId,
      });
    }
  } else {
    const subjectKeys = parseSubjectKeys(metadata.subject_ids);
    if (subjectKeys.length === 0) {
      throw new Error("checkout_session_missing_subject_ids");
    }

    const { data: subjectRows, error: subjectsError } = await service.schema(
      "app",
    ).from("subjects").select("id, subject_key").in(
      "subject_key",
      subjectKeys,
    );
    if (subjectsError) throw subjectsError;

    const bySubjectKey = new Map(
      (subjectRows ?? []).map((row) => [row.subject_key as string, row.id as string]),
    );
    const missing = subjectKeys.filter((key) => !bySubjectKey.has(key));
    if (missing.length > 0) {
      throw new Error(`checkout_session_unknown_subject_keys:${missing.join(",")}`);
    }

    const hadDiscount = Boolean(session.total_details?.amount_discount);
    const source = mode === "single"
      ? (hadDiscount ? "stripe_checkout_single_coupon" : "stripe_checkout_single")
      : "stripe_checkout_bundle";

    for (const subjectKey of subjectKeys) {
      await grantEntitlement(service, {
        userId,
        subjectId: bySubjectKey.get(subjectKey) as string,
        source,
        allSubjects: false,
        checkoutSessionId,
        eventId,
      });
    }
  }

  await recordGrowthEvent(service, {
    eventName: "purchase_completed",
    userId,
    source: "stripe",
    dedupeKey: `purchase_completed:${eventId}`,
    properties: {
      offer: mode,
      access_tier: "paid",
      currency: session.currency ?? "usd",
    },
  });
}

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") return respond({ ok: true });
  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  // Signature verification needs the exact raw bytes Stripe signed, so the
  // body must be read as text before any JSON parsing.
  const rawBody = await req.text();
  const signature = req.headers.get("stripe-signature");

  let event;
  try {
    event = await verifyStripeWebhookEvent(rawBody, signature);
  } catch (error) {
    console.error("stripe-webhook signature_verification_failed", error);
    return respond({ error: "invalid_signature" }, { status: 400 });
  }

  const service = createServiceClient();

  // Idempotency ledger: insert-first on the Stripe event id. A primary-key
  // conflict means this event was already received (redelivery or a
  // concurrent delivery) — acknowledge without reprocessing.
  const { error: ledgerError } = await service.schema("app")
    .from("stripe_webhook_events")
    .insert({
      id: event.id,
      event_type: event.type,
      payload: JSON.parse(rawBody),
    });
  if (ledgerError) {
    if (ledgerError.code === "23505") {
      return respond({ status: "ok", duplicate: true });
    }
    console.error("stripe-webhook ledger_insert_failed", ledgerError);
    return respond({ error: "ledger_write_failed" }, { status: 500 });
  }

  try {
    if (event.type === "checkout.session.completed") {
      await handleCheckoutSessionCompleted(
        service,
        event.data.object as unknown as CheckoutSessionObject,
        event.id,
      );
    } else {
      // Refund/dispute handling is a separate, deferred piece of work (see
      // TASK-0023). Every other event type is acknowledged so Stripe does
      // not retry, with no entitlement action taken.
      console.log(`stripe-webhook unhandled_event_type:${event.type}`);
    }

    await service.schema("app").from("stripe_webhook_events")
      .update({ processed_at: new Date().toISOString() })
      .eq("id", event.id);

    return respond({ status: "ok" });
  } catch (error) {
    const message = error instanceof Error
      ? error.message
      : "stripe_webhook_processing_failed";
    console.error("stripe-webhook processing_failed", error);
    await service.schema("app").from("stripe_webhook_events")
      .update({ processing_error: message.slice(0, 500) })
      .eq("id", event.id);
    return respond({ error: "processing_failed" }, { status: 500 });
  }
});
