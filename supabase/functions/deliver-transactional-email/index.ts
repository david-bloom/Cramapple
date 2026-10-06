import { createServiceClient } from "../_shared/supabase.ts";
import { deliverPaymentEmails } from "../_shared/payment-email.ts";

Deno.serve(async (req) => {
  const secret = Deno.env.get("TRANSACTIONAL_EMAIL_WORKER_SECRET");
  if (!secret || req.headers.get("Authorization") !== `Bearer ${secret}`) {
    return new Response("Unauthorized", { status: 401 });
  }
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }
  try {
    return Response.json(await deliverPaymentEmails(createServiceClient()));
  } catch {
    return Response.json({ error: "email_worker_failed" }, { status: 503 });
  }
});
