import {
  HELP_SYSTEM,
  type helpContext,
  HelpError,
  helpSchema,
  object,
  validateHelp,
} from "./contract.ts";

import { outputFailure } from "./diagnostics.ts";

// Exact saved demo model, revalidated against Gateway /v1/models on October 13.
export const HELP_GATEWAY_MODEL = "anthropic/claude-haiku-5.5";
export const HELP_GATEWAY_URL =
  "https://ai-gateway.vercel.sh/v1/chat/completions";

export async function generateHelp(
  context: ReturnType<typeof helpContext>,
  apiKey: string | undefined,
  model = HELP_GATEWAY_MODEL,
  doFetch: typeof fetch = fetch,
) {
  if (!apiKey) throw new HelpError("help_not_configured", 503);
  if (model !== HELP_GATEWAY_MODEL) {
    throw new HelpError("help_not_configured", 503);
  }
  let response: Response;
  try {
    response = await doFetch(HELP_GATEWAY_URL, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model,
        store: false,
        max_tokens: 2500,
        reasoning: { effort: "none" },
        messages: [{ role: "system", content: HELP_SYSTEM }, {
          role: "user",
          content: JSON.stringify(context.grounding),
        }],
        response_format: {
          type: "json_schema",
          json_schema: {
            name: "cramapple_more_help",
            strict: true,
            schema: helpSchema(context.sources.map((s) => s.id)),
          },
        },
      }),
      signal: AbortSignal.timeout(35000),
    });
  } catch {
    throw new HelpError("help_connection_failed", 503);
  }
  if (!response.ok) {
    // Do not log the upstream body, prompt, work, identity or credentials.
    console.warn("[more-help] gateway request failed", {
      status: response.status,
    });
    throw new HelpError(
      [401, 402, 403].includes(response.status)
        ? "help_provider_unavailable"
        : "help_unavailable",
      503,
    );
  }
  let raw: Record<string, unknown>;
  try {
    raw = object(await response.json());
  } catch {
    outputFailure("response_json");
    throw new HelpError("invalid_model_output", 502);
  }
  const choice = object(Array.isArray(raw.choices) ? raw.choices[0] : null);
  const message = object(choice.message);
  if (message.refusal || choice.finish_reason === "content_filter") {
    throw new HelpError("help_refused", 422);
  }
  if (choice.finish_reason !== "stop") {
    throw new HelpError("help_incomplete", 502);
  }
  let decoded: unknown;
  try {
    decoded = JSON.parse(
      typeof message.content === "string" ? message.content : "",
    );
  } catch {
    outputFailure("content_json");
    throw new HelpError("invalid_model_output", 502);
  }
  try {
    return validateHelp(
      decoded,
      context.sources,
      context.grounding.question.stem,
      !context.after,
      context.questionText,
    );
  } catch (error) {
    outputFailure(
      error instanceof HelpError ? error.diagnosticReason : undefined,
    );
    throw error;
  }
}
