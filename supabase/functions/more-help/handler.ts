import {
  helpContext,
  HelpError,
  type HelpInput,
  object,
  parseInput,
  type Row,
} from "./contract.ts";
export type Dependencies = {
  authenticate: (req: Request) => Promise<{ id: string } | null>;
  originAllowed: (req: Request) => boolean;
  json: (body: unknown, status: number, req: Request) => Response;
  load: (input: HelpInput, req: Request) => Promise<unknown>;
  reserve: (
    userId: string,
    input: HelpInput,
    fingerprint: string,
  ) => Promise<Row>;
  commit: (userId: string, input: HelpInput) => Promise<Row>;
  fail: (userId: string, input: HelpInput) => Promise<void>;
  generate: (context: ReturnType<typeof helpContext>) => Promise<unknown>;
};
export async function moreHelp(req: Request, deps: Dependencies) {
  let assistanceRecorded = false;
  let reservation: { userId: string; input: HelpInput } | null = null;
  try {
    if (!deps.originAllowed(req)) {
      return deps.json({ error: "origin_not_allowed" }, 403, req);
    }
    if (req.method === "OPTIONS") return deps.json({}, 200, req);
    if (req.method !== "POST") {
      return deps.json({ error: "method_not_allowed" }, 405, req);
    }
    const user = await deps.authenticate(req);
    if (!user) return deps.json({ error: "not_authenticated" }, 401, req);
    if (Number(req.headers.get("content-length") || 0) > 16000) {
      throw new HelpError("request_too_large", 413);
    }
    const body = await req.text();
    if (body.length > 16000) throw new HelpError("request_too_large", 413);
    let parsed: unknown;
    try {
      parsed = JSON.parse(body);
    } catch {
      throw new HelpError("invalid_request", 400);
    }
    const input = parseInput(parsed);
    const context = helpContext(await deps.load(input, req), input);
    // No model call or helpful reference disclosure until the durable receipt
    // and the server's ownership/entitlement gates succeed.
    const digest = await crypto.subtle.digest(
      "SHA-256",
      new TextEncoder().encode(JSON.stringify(input)),
    );
    const fingerprint = Array.from(new Uint8Array(digest)).map((b) =>
      b.toString(16).padStart(2, "0")
    ).join("");
    const receipt = object(await deps.reserve(user.id, input, fingerprint));
    if (receipt.state !== "reserved") {
      const code = typeof receipt.error === "string"
        ? receipt.error
        : "reservation_failed";
      throw new HelpError(
        code,
        code === "rate_limited"
          ? 429
          : code === "request_already_used"
          ? 409
          : 403,
      );
    }
    reservation = { userId: user.id, input };
    const result = await deps.generate(context);
    const committed = object(await deps.commit(user.id, input));
    if (committed.state !== "delivered") {
      throw new HelpError("assistance_commit_failed", 503);
    }
    assistanceRecorded = true;
    return deps.json(
      {
        ok: true,
        questionId: input.questionId,
        phase: context.after ? "after" : "before",
        help: result,
      },
      200,
      req,
    );
  } catch (error) {
    if (reservation && !assistanceRecorded) {
      try {
        await deps.fail(reservation.userId, reservation.input);
      } catch { /* lease expiry keeps retry safe */ }
    }
    const e = error instanceof HelpError
      ? error
      : new HelpError("help_unavailable", 503);
    // Never print the student's work, token, source context or provider body.
    return deps.json({ error: e.code, assistanceRecorded }, e.status, req);
  }
}
