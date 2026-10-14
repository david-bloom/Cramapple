import {
  HELP_SYSTEM,
  type helpContext,
  HelpError,
  helpSchema,
  object,
  validateHelp,
} from "./contract.ts";
export async function generateHelp(
  context: ReturnType<typeof helpContext>,
  apiKey: string | undefined,
  model: string | undefined,
  doFetch: typeof fetch = fetch,
) {
  if (!apiKey || !model) throw new HelpError("help_not_configured", 503);
  let response: Response;
  try {
    response = await doFetch("https://api.openai.com/v1/responses", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model,
        store: false,
        max_output_tokens: 2500,
        input: [{
          role: "system",
          content: [{ type: "input_text", text: HELP_SYSTEM }],
        }, {
          role: "user",
          content: [{
            type: "input_text",
            text: JSON.stringify(context.grounding),
          }],
        }],
        text: {
          format: {
            type: "json_schema",
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
    let errorCode = "unknown";
    try {
      errorCode = String(
        object(object(await response.json()).error).code ?? "unknown",
      );
    } catch { /* no provider body logged */ }
    console.warn("[more-help] provider request failed", {
      status: response.status,
      code: errorCode,
    });
    throw new HelpError(
      response.status === 402 ? "help_connection_failed" : "help_unavailable",
      503,
    );
  }
  const raw = object(await response.json());
  if (raw.status && raw.status !== "completed") {
    throw new HelpError("help_incomplete", 502);
  }
  let output = typeof raw.output_text === "string" ? raw.output_text : "";
  if (!output && Array.isArray(raw.output)) {
    for (const item of raw.output) {
      const r = object(item);
      if (r.type === "message" && Array.isArray(r.content)) {
        for (const part of r.content) {
          const p = object(part);
          if (p.type === "output_text" && typeof p.text === "string") {
            output += p.text;
          }
        }
      }
    }
  }
  let decoded: unknown;
  try {
    decoded = JSON.parse(output);
  } catch {
    throw new HelpError("invalid_model_output", 502);
  }
  return validateHelp(
    decoded,
    context.sources,
    context.grounding.question.stem,
  );
}
