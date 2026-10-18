import { createServiceClient } from "../_shared/supabase.ts";
import { deliverPaymentEmails } from "../_shared/payment-email.ts";
import { stripe } from "../_shared/stripe.ts";
import {
  deliverParentLifecycleEmails,
  type ParentSession,
} from "../_shared/parent-email-lifecycle.ts";
import { deliverTrialNotices } from "../_shared/trial-notices.ts";
import { sendLoopsTransactional } from "../_shared/loops-transactional.ts";
import { emailFooter } from "../_shared/email-template-data.ts";

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
    // TASK-0077 card-trial notices. Delivery problems are retried per job and
    // never block a charge (DECISION-0126 item 30).
    const trial = Deno.env.get("TRIAL_NOTICES_ENABLED") === "true"
      ? await deliverTrialNotices({
        service,
        send: (input, key) => sendLoopsTransactional(input, key),
        templateId: (name) => Deno.env.get(name)?.trim() || null,
        retrieveCardLast4: async (id) => {
          const pm = await stripe.paymentMethods.retrieve(id);
          return pm.card?.last4 ?? null;
        },
        lookupUserEmail: async (userId) => {
          const { data } = await service.auth.admin.getUserById(userId);
          return data.user?.email ?? null;
        },
        appBaseUrl: (Deno.env.get("APP_BASE_URL") ?? "").replace(/\/$/, ""),
        marketingBaseUrl: (Deno.env.get("MARKETING_BASE_URL") ?? "https://cramapple.com")
          .replace(/\/$/, ""),
        mailingAddress: emailFooter().mailingAddress,
        now: () => new Date(),
      })
      : null;
    return Response.json({ payment, lifecycle, trial });
  } catch {
    return Response.json({ error: "email_worker_failed" }, { status: 503 });
  }
});
