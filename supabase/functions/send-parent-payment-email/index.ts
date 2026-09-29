import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";

const LOOPS_API_BASE = "https://app.loops.so/api/v1";
const MAX_SENDS_PER_SESSION_PER_HOUR = 5;

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asEmail(value: unknown) {
  const email = asString(value)?.toLowerCase() ?? null;
  return email && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) ? email : null;
}

async function sha256(value: string) {
  const bytes = new TextEncoder().encode(value);
  const digest = await crypto.subtle.digest("SHA-256", bytes);
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0")).join("");
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
  const sessionId = asString(input.session_id);
  const parentEmail = asEmail(input.parent_email);
  if (!sessionId || !parentEmail) {
    return respond({ error: "invalid_request" }, { status: 400 });
  }

  let session;
  try {
    session = await stripe.checkout.sessions.retrieve(sessionId);
  } catch {
    return respond({ error: "session_not_found" }, { status: 404 });
  }

  const metadata = session.metadata ?? {};
  const purchaseType = metadata.purchase_type ?? metadata.purchaser_type;
  if (purchaseType !== "parent_share" || !session.url || session.status !== "open") {
    return respond({ error: "invalid_parent_payment_session" }, { status: 409 });
  }

  const service = createServiceClient();
  const since = new Date(Date.now() - 60 * 60 * 1000).toISOString();
  const { count, error: countError } = await service.schema("app")
    .from("parent_payment_email_requests")
    .select("id", { count: "exact", head: true })
    .eq("checkout_session_id", sessionId)
    .gte("created_at", since);
  if (countError) {
    console.error("send-parent-payment-email rate_limit_lookup_failed", countError);
    return respond({ error: "email_send_failed" }, { status: 500 });
  }
  if ((count ?? 0) >= MAX_SENDS_PER_SESSION_PER_HOUR) {
    return respond({ error: "rate_limited" }, { status: 429 });
  }

  const apiKey = Deno.env.get("LOOPS_SECRET_KEY");
  if (!apiKey) {
    return respond({ error: "email_provider_unavailable" }, { status: 503 });
  }

  const studentName = metadata.student_name ?? "your student";
  const subjectCount = (metadata.subject_ids ?? "").split(",").filter(Boolean).length;

  let sendStatus = "failed";
  try {
    const response = await fetch(`${LOOPS_API_BASE}/events/send`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        email: parentEmail,
        eventName: "parent_payment_link_requested",
        eventProperties: {
          checkoutUrl: session.url,
          studentName,
          subjectCount,
        },
      }),
    });

    if (!response.ok) {
      console.error("send-parent-payment-email loops_failed", response.status);
      return respond({ error: "email_send_failed" }, { status: 502 });
    }
    sendStatus = "sent";
    return respond({ status: "ok" });
  } finally {
    const emailHash = await sha256(parentEmail);
    const { error } = await service.schema("app")
      .from("parent_payment_email_requests")
      .insert({
        checkout_session_id: sessionId,
        parent_email_hash: emailHash,
        status: sendStatus,
      });
    if (error) console.error("send-parent-payment-email audit_failed", error);
  }
});
