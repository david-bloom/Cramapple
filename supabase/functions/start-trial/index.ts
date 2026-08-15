import { requireProfile } from "../_shared/auth.ts";
import { asString, sanitizeTouch } from "../_shared/trial-contract.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { createServiceClient } from "../_shared/supabase.ts";

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

  const auth = await requireProfile(req);
  if (!auth) return respond({ error: "unauthorized" }, { status: 401 });
  if (auth.profile.role !== "student" && auth.profile.role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const privacyNoticeVersion = asString(input.privacy_notice_version);
  if (!privacyNoticeVersion) {
    return respond({ error: "missing_privacy_notice_version" }, {
      status: 400,
    });
  }

  const service = createServiceClient();
  const userId = auth.user.id;

  try {
    const { data, error } = await service.schema("app").rpc("start_trial", {
      p_user_id: userId,
      p_first_touch: sanitizeTouch(input.first_touch),
      p_last_touch: sanitizeTouch(input.last_touch),
      p_marketing_email_opt_in: input.marketing_email_opt_in === true,
      p_privacy_notice_version: privacyNoticeVersion,
    });
    if (error || !data) {
      console.error("start-trial", error);
      return respond({ error: "trial_start_failed" }, { status: 500 });
    }

    const result = data as Record<string, unknown>;
    const alreadyStarted = result.already_started === true;

    if (!alreadyStarted) {
      await recordGrowthEvent(service, {
        eventName: "trial_started",
        userId,
        source: "web",
        dedupeKey: `trial_started:${userId}`,
        properties: {
          offer: "trial_v1",
          access_tier: "trial",
          ...sanitizeTouch(input.last_touch),
        },
      });
    }

    return respond({
      status: "ok",
      result: {
        already_started: alreadyStarted,
        starts_at: result.starts_at,
        ends_at: result.ends_at,
        subjects: result.subjects,
      },
    });
  } catch (error) {
    console.error("start-trial", error);
    return respond({ error: "trial_start_failed" }, { status: 500 });
  }
});
