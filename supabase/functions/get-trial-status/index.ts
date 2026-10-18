// The signed-in learner's card trials, sanitized (TASK-0077 plan §6.15). The
// app cannot read app.trial_orders directly.
import { requireProfile } from "../_shared/auth.ts";
import { jsonResponse } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { orderView } from "../_shared/trial-actions.ts";

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) => jsonResponse(body, init, req);
  if (req.method === "OPTIONS") return respond({ ok: true });
  if (req.method !== "POST" && req.method !== "GET") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }
  const profile = await requireProfile(req);
  if (!profile) return respond({ error: "unauthorized" }, { status: 401 });

  const { data, error } = await createServiceClient().schema("app").from("trial_orders")
    .select("*")
    .eq("user_id", profile.user.id)
    .not("status", "in", "(pending_setup,setup_expired,activation_refused)")
    .order("created_at", { ascending: false })
    .limit(10);
  if (error) return respond({ error: "lookup_failed" }, { status: 500 });
  return respond({ status: "ok", trials: (data ?? []).map(orderView) });
});
