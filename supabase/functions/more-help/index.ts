import { requireAuthedUser } from "../_shared/auth.ts";
import { createAnonClient, createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse } from "../_shared/http.ts";
import { HelpError, object } from "./contract.ts";
import { moreHelp } from "./handler.ts";
import { generateHelp, HELP_GATEWAY_MODEL } from "./model.ts";
import { checkNoAnswerLeak } from "./verify.ts";
import { rpcFailure } from "./diagnostics.ts";
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
        {
          status,
          headers: {
            "Cache-Control": "no-store",
            ...(typeof (body as { retryAfterSeconds?: number })
                ?.retryAfterSeconds === "number"
              ? {
                "Retry-After": String(
                  (body as { retryAfterSeconds: number }).retryAfterSeconds,
                ),
              }
              : {}),
          },
        },
        req,
      ),
    load: async (input, req) => {
      const { data, error } = await createAnonClient(req).rpc(
        "get_question_experience",
        { p_learning_session_id: input.sessionId, p_ordinal: input.ordinal },
      );
      if (error) {
        rpcFailure("get_question_experience", error.code);
        throw new HelpError("question_not_owned", 403);
      }
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
      if (error) {
        rpcFailure("reserve_question_help_delivery", error.code);
        throw new HelpError("reservation_failed", 503);
      }
      return data;
    },
    commit: async (userId, input, generation) => {
      const { data, error } = await service.rpc("commit_question_help", {
        p_user_id: userId,
        p_request_id: input.requestId,
        p_generation: generation,
      });
      if (error) {
        rpcFailure("commit_question_help", error.code);
        throw new HelpError("assistance_commit_failed", 503);
      }
      return data;
    },
    fail: async (userId, input, generation) => {
      const { error } = await service.rpc("fail_question_help", {
        p_user_id: userId,
        p_request_id: input.requestId,
        p_generation: generation,
      });
      if (error) {
        rpcFailure("fail_question_help", error.code);
        throw new HelpError("assistance_release_failed", 503);
      }
    },
    preflight: () => {
      if (!Deno.env.get("AI_GATEWAY_API_KEY")) {
        throw new HelpError("help_not_configured", 503);
      }
    },
    verify: async (context, help, input) => {
      const { data, error } = await service.schema("app").from("mcq_choices")
        .select("choice_key,choice_text,is_correct")
        .eq("content_item_version_id", input.questionId);
      if (error || !Array.isArray(data)) {
        rpcFailure("mcq_choices_key", error?.code);
        throw new HelpError("help_unavailable", 503);
      }
      await checkNoAnswerLeak(
        {
          stem: context.grounding.question.stem,
          choices: data.map((c) => ({
            key: String(c.choice_key),
            text: String(c.choice_text),
            correct: c.is_correct === true,
          })),
        },
        object(help),
        Deno.env.get("AI_GATEWAY_API_KEY"),
      );
    },
    generate: (context, revision) =>
      generateHelp(
        context,
        Deno.env.get("AI_GATEWAY_API_KEY"),
        HELP_GATEWAY_MODEL,
        fetch,
        revision,
      ),
  })
);
