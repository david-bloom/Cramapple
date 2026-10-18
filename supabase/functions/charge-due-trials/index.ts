import { createServiceClient } from "../_shared/supabase.ts";
import { stripe } from "../_shared/stripe.ts";
import { runChargeWorker } from "./handler.ts";

// Called every 5 minutes by pg_cron through pg_net (TASK-0077 plan §6.5).
// Deploy with --no-verify-jwt: the Bearer token is this worker's own secret.
function timingSafeEqual(a: string, b: string) {
  const x = new TextEncoder().encode(a);
  const y = new TextEncoder().encode(b);
  let diff = x.length ^ y.length;
  for (let i = 0; i < Math.max(x.length, y.length); i++) diff |= (x[i] ?? 0) ^ (y[i] ?? 0);
  return diff === 0;
}

Deno.serve(async (req) => {
  const secret = Deno.env.get("TRIAL_CHARGE_WORKER_SECRET");
  const header = req.headers.get("Authorization") ?? "";
  if (!secret || !timingSafeEqual(header, `Bearer ${secret}`)) {
    return new Response("Unauthorized", { status: 401 });
  }
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }
  try {
    const summary = await runChargeWorker({
      stripe,
      service: createServiceClient(),
      // Kill switch: off pauses charges; overdue orders get the 48-hour
      // notice and keep access instead (DECISION-0126 items 16, 20).
      chargesEnabled: Deno.env.get("TRIAL_CHARGES_ENABLED") === "true",
      log: (message, detail) => console.error(`charge-due-trials ${message}`, detail),
    });
    return Response.json(summary);
  } catch (error) {
    console.error("charge-due-trials worker_failed", error);
    return Response.json({ error: "worker_failed" }, { status: 503 });
  }
});
