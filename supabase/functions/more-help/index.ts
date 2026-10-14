import { requireAuthedUser } from "../_shared/auth.ts";
import { createAnonClient, createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse } from "../_shared/http.ts";
import { HelpError } from "./contract.ts";
import { moreHelp } from "./handler.ts";
import { generateHelp } from "./model.ts";
const service = createServiceClient();
const origins = (Deno.env.get("ALLOWED_ORIGINS") || "").split(",").map((s) =>
  s.trim()
).filter(Boolean);
Deno.serve((req) =>
  moreHelp(req, {
    authenticate: requireAuthedUser,
    originAllowed: (req) =>
      !req.headers.has("Origin") ||
      origins.includes(req.headers.get("Origin")!),
    json: (body, status, req) =>
      jsonResponse(
        body,
        { status, headers: { "Cache-Control": "no-store" } },
        req,
      ),
    load: async (input, req) => {
      const { data, error } = await createAnonClient(req).rpc(
        "get_question_experience",
        { p_learning_session_id: input.sessionId, p_ordinal: input.ordinal },
      );
      if (error) throw new HelpError("question_not_owned", 403);
      return data;
    },
    reserve: async (userId, input, fingerprint) => {
      const { data, error } = await service.rpc(
        "reserve_question_help_delivery",
        {
          p_user_id: userId,
          p_request_id: input.requestId,
          p_session_id: input.sessionId,
          p_version_id: input.questionId,
          p_input_hash: fingerprint,
        },
      );
      if (error) throw new HelpError("reservation_failed", 503);
      return data;
    },
    commit: async (userId, input) => {
      const { data, error } = await service.rpc("commit_question_help", {
        p_user_id: userId,
        p_request_id: input.requestId,
      });
      if (error) throw new HelpError("assistance_commit_failed", 503);
      return data;
    },
    fail: async (userId, input) => {
      await service.rpc("fail_question_help", {
        p_user_id: userId,
        p_request_id: input.requestId,
      });
    },
    generate: (context) =>
      generateHelp(
        context,
        Deno.env.get("OPENAI_API_KEY"),
        Deno.env.get("OPENAI_MODEL"),
      ),
  })
);
