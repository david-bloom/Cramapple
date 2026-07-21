import { requireProfile } from "../_shared/auth.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { createServiceClient } from "../_shared/supabase.ts";

type Operation = "start" | "status" | "record_grading_result" | "report";
const OPERATIONS = new Set<Operation>([
  "start",
  "status",
  "record_grading_result",
  "report",
]);

const TOUCH_KEYS = new Set([
  "utm_source",
  "utm_medium",
  "utm_campaign",
  "utm_content",
  "utm_term",
  "landing_path",
  "referrer_host",
  "reddit_click_id",
]);

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asUuid(value: unknown) {
  return typeof value === "string" &&
      /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
        .test(value)
    ? value
    : null;
}

function sanitizeTouch(value: unknown) {
  if (!value || typeof value !== "object" || Array.isArray(value)) return {};
  const result: Record<string, string> = {};
  for (const [key, raw] of Object.entries(value as Record<string, unknown>)) {
    if (TOUCH_KEYS.has(key) && typeof raw === "string" && raw.trim()) {
      result[key] = raw.trim().slice(0, 300);
    }
  }
  return result;
}

function rpcErrorCode(message: string | undefined) {
  return message?.match(/(?:free_score_check|grading_access):([a-z_]+)/)?.[1] ??
    "free_score_check_failed";
}

async function loadCheck(service: ReturnType<typeof createServiceClient>, userId: string) {
  const { data, error } = await service.schema("app")
    .from("free_score_checks")
    .select(
      "id, user_id, subject_id, exam_pack_version_id, content_item_version_id, rubric_version_id, learning_session_id, attempt_id, repair_attempt_id, initial_response_version_id, repair_response_version_id, initial_grading_result_id, repair_grading_result_id, state, started_at, initial_graded_at, repair_graded_at, completed_at, report_version",
    )
    .eq("user_id", userId)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (error) throw error;
  return data;
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
  const operation = asString(input.operation) as Operation | null;
  if (!operation || !OPERATIONS.has(operation)) {
    return respond({ error: "invalid_operation" }, { status: 400 });
  }

  const auth = await requireProfile(req);
  if (!auth) return respond({ error: "unauthorized" }, { status: 401 });
  if (auth.profile.role !== "student" && auth.profile.role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const service = createServiceClient();
  const userId = auth.user.id;

  try {
    if (operation === "start") {
      const privacyNoticeVersion = asString(input.privacy_notice_version);
      if (!privacyNoticeVersion) {
        return respond(
          { error: "missing_privacy_notice_version" },
          { status: 400 },
        );
      }

      const { data, error } = await service.schema("app").rpc(
        "start_free_score_check",
        {
          p_user_id: userId,
          p_first_touch: sanitizeTouch(input.first_touch),
          p_last_touch: sanitizeTouch(input.last_touch),
          p_marketing_email_opt_in: input.marketing_email_opt_in === true,
          p_privacy_notice_version: privacyNoticeVersion,
        },
      );
      if (error || !data) {
        const code = rpcErrorCode(error?.message);
        const status = code === "not_available" || code === "not_configured"
          ? 503
          : 409;
        return respond({ error: code }, { status });
      }

      const result = data as Record<string, unknown>;
      const checkId = String(result.free_score_check_id);
      await recordGrowthEvent(service, {
        eventName: "trial_started",
        userId,
        freeScoreCheckId: checkId,
        source: "free_score_check",
        dedupeKey: `trial_started:${checkId}`,
        properties: {
          subject_key: "biology",
          offer: "free_score_check_v1",
          access_tier: "free_score_check",
          ...sanitizeTouch(input.last_touch),
        },
      });

      return respond({ status: "ok", operation, result });
    }

    if (operation === "status") {
      const check = await loadCheck(service, userId);
      return respond({
        status: "ok",
        operation,
        result: check ?? { state: "available" },
      });
    }

    if (operation === "record_grading_result") {
      const gradingResultId = asUuid(input.grading_result_id);
      if (!gradingResultId) {
        return respond({ error: "missing_grading_result_id" }, { status: 400 });
      }

      const { data, error } = await service.schema("app").rpc(
        "record_free_score_grade",
        { p_user_id: userId, p_grading_result_id: gradingResultId },
      );
      if (error || !data) {
        return respond({ error: rpcErrorCode(error?.message) }, { status: 409 });
      }

      const result = data as Record<string, unknown>;
      const checkId = String(result.free_score_check_id);
      const completed = result.state === "completed";
      await recordGrowthEvent(service, {
        eventName: completed ? "repair_completed" : "first_response_graded",
        userId,
        freeScoreCheckId: checkId,
        source: "free_score_check",
        dedupeKey: `${completed ? "repair_completed" : "first_response_graded"}:${checkId}`,
        properties: {
          subject_key: "biology",
          offer: "free_score_check_v1",
          access_tier: "free_score_check",
        },
      });

      return respond({ status: "ok", operation, result });
    }

    const check = await loadCheck(service, userId);
    if (!check || !check.initial_grading_result_id) {
      return respond({ error: "report_not_ready" }, { status: 409 });
    }

    const resultIds = [
      check.initial_grading_result_id,
      check.repair_grading_result_id,
    ].filter(Boolean) as string[];
    const [{ data: gradingRows, error: gradingError }, { data: contentVersion }] =
      await Promise.all([
        service.schema("app").from("grading_results").select(
          "id, operation, status, points_earned, points_available, criterion_results, highest_value_gap, confidence, uncertainty_reason, feedback_preview, action_hint, repair_hint, created_at",
        ).in("id", resultIds),
        service.schema("app").from("content_item_versions")
          .select("id, content_item_id")
          .eq("id", check.content_item_version_id)
          .maybeSingle(),
      ]);
    if (gradingError || !gradingRows) throw gradingError ?? new Error("report_load_failed");

    let title: string | null = null;
    if (contentVersion?.content_item_id) {
      const { data: item } = await service.schema("app").from("content_items")
        .select("title")
        .eq("id", contentVersion.content_item_id)
        .maybeSingle();
      title = item?.title ?? null;
    }

    const initial = gradingRows.find((row) => row.id === check.initial_grading_result_id) ?? null;
    const repair = gradingRows.find((row) => row.id === check.repair_grading_result_id) ?? null;
    return respond({
      status: "ok",
      operation,
      result: {
        report_version: check.report_version,
        free_score_check_id: check.id,
        subject_key: "biology",
        title,
        state: check.state,
        started_at: check.started_at,
        completed_at: check.completed_at,
        initial,
        repair,
        export: {
          format: "print_to_pdf",
          suggested_filename: "cramapple-ap-biology-score-check.pdf",
        },
      },
    });
  } catch (error) {
    console.error("free-score-check", error);
    return respond({ error: "free_score_check_failed" }, { status: 500 });
  }
});
