import { requireProfile } from "../_shared/auth.ts";
import {
  asString,
  asUuid,
  normalizeGradingResult,
  pointsGained,
  rpcErrorCode,
  sanitizeTouch,
} from "../_shared/free-score-check-contract.ts";
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

async function loadCheck(
  service: ReturnType<typeof createServiceClient>,
  userId: string,
  subjectKey?: string | null,
) {
  let query = service.schema("app")
    .from("free_score_checks")
    .select(
      "id, user_id, subject_id, exam_pack_version_id, content_item_version_id, rubric_version_id, learning_session_id, attempt_id, repair_attempt_id, initial_response_version_id, repair_response_version_id, initial_grading_result_id, repair_grading_result_id, state, started_at, initial_graded_at, repair_graded_at, completed_at, report_version",
    )
    .eq("user_id", userId);

  if (subjectKey) {
    const { data: subject, error: subjectError } = await service.schema("app")
      .from("subjects")
      .select("id")
      .eq("subject_key", subjectKey)
      .eq("status", "active")
      .maybeSingle();
    if (subjectError) throw subjectError;
    if (!subject) return null;
    query = query.eq("subject_id", subject.id);
  }

  const { data, error } = await query
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (error) throw error;
  return data;
}

async function loadGradingRows(
  service: ReturnType<typeof createServiceClient>,
  resultIds: string[],
) {
  if (resultIds.length === 0) return [];
  const { data, error } = await service.schema("app").from("grading_results")
    .select(
      "id, operation, status, points_earned, points_available, criterion_results, highest_value_gap, confidence, uncertainty_reason, feedback_preview, action_hint, repair_hint, created_at",
    )
    .in("id", resultIds);
  if (error) throw error;
  return data ?? [];
}

async function hydrateCheck(
  service: ReturnType<typeof createServiceClient>,
  check: Record<string, unknown> | null,
) {
  if (!check) return { state: "available" };

  const initialId = typeof check.initial_grading_result_id === "string"
    ? check.initial_grading_result_id
    : null;
  const repairId = typeof check.repair_grading_result_id === "string"
    ? check.repair_grading_result_id
    : null;
  const rows = await loadGradingRows(
    service,
    [initialId, repairId].filter(Boolean) as string[],
  );
  const initialRow = rows.find((row) => row.id === initialId) ?? null;
  const repairRow = rows.find((row) => row.id === repairId) ?? null;

  return {
    ...check,
    initial_result: normalizeGradingResult(initialRow),
    repair_result: normalizeGradingResult(repairRow),
  };
}

async function loadSubject(
  service: ReturnType<typeof createServiceClient>,
  subjectId: unknown,
) {
  if (typeof subjectId !== "string") return null;
  const { data, error } = await service.schema("app").from("subjects")
    .select("subject_key, display_name")
    .eq("id", subjectId)
    .maybeSingle();
  if (error) throw error;
  return data;
}

function filenameSubjectPart(subjectKey: string | null | undefined) {
  const safe = subjectKey?.toLowerCase().replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
  return safe || "subject";
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
      const subjectKey = asString(input.subject_key);
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
          p_subject_key: subjectKey,
        },
      );
      if (error || !data) {
        const code = rpcErrorCode(error?.message);
        const unavailable = new Set([
          "not_available",
          "not_configured",
          "subject_required",
          "content_not_published",
          "content_not_student_visible",
        ]);
        const status = unavailable.has(code) ? 503 : 409;
        return respond({ error: code }, { status });
      }

      const result = data as Record<string, unknown>;
      const checkId = String(result.free_score_check_id);
      const resultSubjectKey = asString(result.subject_key) ?? subjectKey;
      await recordGrowthEvent(service, {
        eventName: "trial_started",
        userId,
        freeScoreCheckId: checkId,
        source: "free_score_check",
        dedupeKey: `trial_started:${checkId}`,
        properties: {
          subject_key: resultSubjectKey,
          offer: "free_score_check_v1",
          access_tier: "free_score_check",
          ...sanitizeTouch(input.last_touch),
        },
      });

      return respond({ status: "ok", operation, result });
    }

    if (operation === "status") {
      const check = await loadCheck(service, userId, asString(input.subject_key));
      return respond({
        status: "ok",
        operation,
        result: await hydrateCheck(service, check),
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
        return respond({ error: rpcErrorCode(error?.message) }, {
          status: 409,
        });
      }

      const result = data as Record<string, unknown>;
      const checkId = String(result.free_score_check_id);
      const completed = result.state === "completed";
      const check = await loadCheck(service, userId);
      const subject = await loadSubject(service, check?.subject_id);
      await recordGrowthEvent(service, {
        eventName: completed ? "repair_completed" : "first_response_graded",
        userId,
        freeScoreCheckId: checkId,
        source: "free_score_check",
        dedupeKey: `${
          completed ? "repair_completed" : "first_response_graded"
        }:${checkId}`,
        properties: {
          subject_key: subject?.subject_key ?? null,
          offer: "free_score_check_v1",
          access_tier: "free_score_check",
        },
      });

      return respond({ status: "ok", operation, result });
    }

    const check = await loadCheck(service, userId, asString(input.subject_key));
    if (
      !check ||
      check.state !== "completed" ||
      !check.initial_grading_result_id ||
      !check.repair_grading_result_id
    ) {
      return respond({ error: "report_not_ready" }, { status: 409 });
    }

    const resultIds = [
      check.initial_grading_result_id,
      check.repair_grading_result_id,
    ].filter(Boolean) as string[];
    const [
      gradingRows,
      { data: contentVersion },
    ] = await Promise.all([
      loadGradingRows(service, resultIds),
      service.schema("app").from("content_item_versions")
        .select("id, content_item_id")
        .eq("id", check.content_item_version_id)
        .maybeSingle(),
    ]);

    let title: string | null = null;
    if (contentVersion?.content_item_id) {
      const { data: item } = await service.schema("app").from("content_items")
        .select("title")
        .eq("id", contentVersion.content_item_id)
        .maybeSingle();
      title = item?.title ?? null;
    }
    const subject = await loadSubject(service, check.subject_id);
    const subjectName = subject?.display_name ?? "AP subject";
    const subjectKey = subject?.subject_key ?? null;

    const initial = normalizeGradingResult(
      gradingRows.find((row) => row.id === check.initial_grading_result_id) ??
        null,
    );
    const repair = normalizeGradingResult(
      gradingRows.find((row) => row.id === check.repair_grading_result_id) ??
        null,
    );
    if (!initial || !repair) {
      return respond({ error: "report_not_ready" }, { status: 409 });
    }

    return respond({
      status: "ok",
      operation,
      result: {
        report_version: check.report_version,
        free_score_check_id: check.id,
        subject: subjectName,
        subject_key: subjectKey,
        title,
        state: check.state,
        started_at: check.started_at,
        completed_at: check.completed_at,
        initial,
        repair,
        points_gained: pointsGained(initial, repair),
        next_action: repair
          ? `Use the full ${subjectName} practice set to keep repairing point-losing gaps.`
          : null,
        export: {
          format: "print_to_pdf",
          suggested_filename:
            `cramapple-${filenameSubjectPart(subjectKey)}-score-check.pdf`,
        },
      },
    });
  } catch (error) {
    console.error("free-score-check", error);
    return respond({ error: "free_score_check_failed" }, { status: 500 });
  }
});
