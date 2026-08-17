import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

export const GROWTH_EVENT_NAMES = [
  "landing_view",
  "demo_started",
  "signup_started",
  "trial_started",
  "first_response_graded",
  "repair_completed",
  "returned_day_2",
  "returned_day_7",
  "checkout_started",
  "purchase_completed",
  "purchase_refunded",
  "referral_shared",
  "referred_trial_started",
  "referred_purchase",
] as const;

export type GrowthEventName = typeof GROWTH_EVENT_NAMES[number];

// Explicitly excludes answers, grades, weakness labels, school data, names,
// and email addresses. Acquisition systems receive only coarse funnel data.
const ALLOWED_PROPERTY_KEYS = new Set([
  "subject_key",
  "offer",
  "access_tier",
  "utm_source",
  "utm_medium",
  "utm_campaign",
  "utm_content",
  "utm_term",
  "landing_path",
  "referrer_host",
  "creative_id",
  "currency",
  "value_bucket",
  "is_referred",
]);

export function sanitizeGrowthProperties(
  input: Record<string, unknown> | null | undefined,
) {
  const output: Record<string, string | number | boolean> = {};
  for (const [key, value] of Object.entries(input ?? {})) {
    if (!ALLOWED_PROPERTY_KEYS.has(key)) continue;
    if (
      typeof value === "string" || typeof value === "number" ||
      typeof value === "boolean"
    ) {
      output[key] = typeof value === "string" ? value.slice(0, 200) : value;
    }
  }
  return output;
}

type RecordGrowthEventInput = {
  eventName: GrowthEventName;
  userId: string | null;
  freeScoreCheckId?: string | null;
  source: "web" | "free_score_check" | "stripe" | "referral" | "system";
  dedupeKey: string;
  properties?: Record<string, unknown>;
};

export async function recordGrowthEvent(
  service: SupabaseClient,
  input: RecordGrowthEventInput,
) {
  const properties = sanitizeGrowthProperties(input.properties);
  const { data: inserted, error } = await service.schema("app")
    .from("growth_event_outbox")
    .upsert({
      event_name: input.eventName,
      user_id: input.userId,
      free_score_check_id: input.freeScoreCheckId ?? null,
      source: input.source,
      dedupe_key: input.dedupeKey,
      properties,
    }, { onConflict: "dedupe_key", ignoreDuplicates: true })
    .select("id, delivered_at, delivery_attempts")
    .maybeSingle();

  if (error) throw error;
  const { data: existing, error: lookupError } = inserted
    ? { data: inserted, error: null }
    : await service.schema("app").from("growth_event_outbox")
      .select("id, delivered_at, delivery_attempts")
      .eq("dedupe_key", input.dedupeKey)
      .maybeSingle();
  if (lookupError) throw lookupError;
  if (!existing || existing.delivered_at) return;

  const projectKey = Deno.env.get("POSTHOG_PROJECT_API_KEY");
  const host = (Deno.env.get("POSTHOG_HOST") ?? "https://us.i.posthog.com")
    .replace(/\/$/, "");
  if (!projectKey) return;

  try {
    const response = await fetch(`${host}/capture/`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        api_key: projectKey,
        event: input.eventName,
        properties: {
          ...properties,
          distinct_id: input.userId ?? `anonymous:${input.dedupeKey}`,
          $process_person_profile: false,
        },
        timestamp: new Date().toISOString(),
      }),
    });
    if (!response.ok) throw new Error(`posthog_http_${response.status}`);

    await service.schema("app").from("growth_event_outbox").update({
      delivered_at: new Date().toISOString(),
      delivery_attempts: Number(existing.delivery_attempts ?? 0) + 1,
      last_error: null,
    }).eq("id", existing.id);
  } catch (error) {
    await service.schema("app").from("growth_event_outbox").update({
      delivery_attempts: Number(existing.delivery_attempts ?? 0) + 1,
      last_error: error instanceof Error ? error.message.slice(0, 500) : "delivery_failed",
    }).eq("id", existing.id);
  }
}
