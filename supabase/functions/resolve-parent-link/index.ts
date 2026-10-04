// Resolves a parent payment short code (cramapple.com/p/<code>) to the live
// Stripe Checkout URL, or reports that the link is paid or expired (TASK-0060).
// Public: the parent has no account. The code only names a Checkout Session
// that anyone holding its Stripe URL can already pay.
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";
import {
  classifyParentSession,
  normalizeShortCode,
} from "../_shared/parent-short-link.ts";

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

  const code = normalizeShortCode((body as Record<string, unknown>).code);
  // A malformed code and an unknown code look identical to the caller.
  if (!code) return respond({ status: "not_found" }, { status: 404 });

  const service = createServiceClient();
  const { data: row, error } = await service.schema("app")
    .from("parent_payment_links")
    .select("checkout_session_id")
    .eq("code", code)
    .maybeSingle();
  if (error) {
    console.error("resolve-parent-link lookup_failed", error);
    return respond({ error: "lookup_failed" }, { status: 500 });
  }
  if (!row) return respond({ status: "not_found" }, { status: 404 });

  try {
    const session = await stripe.checkout.sessions.retrieve(
      row.checkout_session_id,
    );
    const result = classifyParentSession({
      status: session.status,
      payment_status: session.payment_status,
      url: session.url,
      metadata: session.metadata,
    });
    return respond(
      result.state === "open"
        ? { status: "open", url: result.url }
        : { status: result.state },
    );
  } catch (stripeError) {
    console.error("resolve-parent-link stripe_error", stripeError);
    return respond({ status: "expired" });
  }
});
