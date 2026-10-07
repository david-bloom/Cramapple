import { createServiceClient } from "../_shared/supabase.ts";
import { deliverPaymentEmails } from "../_shared/payment-email.ts";
import { stripe } from "../_shared/stripe.ts";
import {
  deliverParentLifecycleEmails,
  type ParentSession,
} from "../_shared/parent-email-lifecycle.ts";

Deno.serve(async (req) => {
  const secret = Deno.env.get("TRANSACTIONAL_EMAIL_WORKER_SECRET");
  if (!secret || req.headers.get("Authorization") !== `Bearer ${secret}`) {
    return new Response("Unauthorized", { status: 401 });
  }
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }
  try {
    const service = createServiceClient();
    const payment = await deliverPaymentEmails(service);
    const lifecycle = await deliverParentLifecycleEmails(service, {
      retrieveSession: async (id) =>
        await stripe.checkout.sessions.retrieve(id) as unknown as ParentSession,
    });
    return Response.json({ payment, lifecycle });
  } catch {
    return Response.json({ error: "email_worker_failed" }, { status: 503 });
  }
});
