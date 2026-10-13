import { requireAuthedUser } from "../_shared/auth.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse } from "../_shared/http.ts";
import { sendLoopsTransactional } from "../_shared/loops-transactional.ts";
import { type Receipt, reportEmailComment, reportQuestion } from "./handler.ts";

// Non-secret owner destination/template, kept server-side and overridable for QA.
const recipient = Deno.env.get("QUESTION_REPORT_EMAIL")?.trim() ||
  "dbloom01@gmail.com";
const template =
  Deno.env.get("LOOPS_QUESTION_REPORT_TRANSACTIONAL_ID")?.trim() ||
  "cmv60vlfy0gwl0j0rtl3wqscb";
const service = createServiceClient();
const origins = (Deno.env.get("ALLOWED_ORIGINS") ?? "").split(",").map((v) =>
  v.trim()
).filter(Boolean);
Deno.serve((req) =>
  reportQuestion(req, {
    authenticate: requireAuthedUser,
    originAllowed: (req) =>
      !req.headers.has("Origin") ||
      origins.includes(req.headers.get("Origin")!),
    json: (body, status, request) =>
      jsonResponse(
        body,
        { status, headers: { "Cache-Control": "no-store" } },
        request,
      ),
    reserve: async (userId, input) => {
      const { data, error } = await service.rpc(
        "reserve_question_issue_report",
        {
          p_user_id: userId,
          p_request_id: input.requestId,
          p_session_id: input.sessionId,
          p_version_id: input.questionId,
          p_mode: input.mode,
          p_note: input.comment,
        },
      );
      if (error) throw new Error("reservation_failed");
      return data as Receipt;
    },
    send: (receipt, sourceUrl) =>
      sendLoopsTransactional({
        transactionalId: template,
        email: recipient,
        dataVariables: {
          subject: receipt.subject!,
          questionId: receipt.questionId!,
          question: receipt.question!,
          mode: receipt.mode!,
          comment: reportEmailComment(receipt, sourceUrl),
          reportId: receipt.id!,
        },
      }, `question-report-${receipt.id}`),
    finish: async (id, sent) => {
      const { error } = await service.schema("app").from(
        "question_issue_reports",
      ).update({
        notification_state: sent ? "sent" : "failed",
        lease_until: null,
        ...(sent ? { notified_at: new Date().toISOString() } : {}),
      }).eq("id", id);
      if (error) throw new Error("receipt_update_failed");
    },
  })
);
