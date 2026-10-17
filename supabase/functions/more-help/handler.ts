import {
  helpContext,
  HelpError,
  type HelpInput,
  object,
  parseInput,
  type Row,
} from "./contract.ts";
import { revisionNote } from "./verify.ts";
export const MAX_REVISIONS = 2;
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
  commit: (
    userId: string,
    input: HelpInput,
    generation: number,
  ) => Promise<Row>;
  fail: (userId: string, input: HelpInput, generation: number) => Promise<void>;
  generate: (
    context: ReturnType<typeof helpContext>,
    revision?: string,
  ) => Promise<unknown>;
  // Optional runtime answer-leak check for pre-submit multiple-choice help.
  verify?: (
    context: ReturnType<typeof helpContext>,
    help: unknown,
    input: HelpInput,
  ) => Promise<void>;
  preflight?: () => void;
};
export async function moreHelp(req: Request, deps: Dependencies) {
  let assistanceRecorded = false;
  let reservation:
    | { userId: string; input: HelpInput; generation: number }
    | null = null;
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
    deps.preflight?.();
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
      // An exact owned/fingerprinted request that is already delivered still
      // carries its durable assistance, even when the response was lost.
      if (code === "request_already_used") assistanceRecorded = true;
      throw new HelpError(
        code,
        ["rate_limited", "attempt_rate_limited", "retry_exhausted"].includes(
            code,
          )
          ? 429
          : ["request_already_used", "request_in_progress", "request_conflict"]
              .includes(code)
          ? 409
          : [
              "question_not_owned",
              "subject_not_supported",
              "entitlement_required",
            ].includes(code)
          ? 403
          : code === "invalid_request"
          ? 400
          : 503,
        typeof receipt.retryAfterSeconds === "number"
          ? Math.max(1, Math.min(86400, receipt.retryAfterSeconds))
          : undefined,
      );
    }
    const generation = Number(receipt.generation);
    if (!Number.isInteger(generation) || generation < 1 || generation > 3) {
      throw new HelpError("reservation_failed", 503);
    }
    reservation = { userId: user.id, input, generation };
    let result = await deps.generate(context);
    if (
      deps.verify && !context.after &&
      context.grounding.question.type === "mcq"
    ) {
      // The check does more than gate: when it flags a draft, its reason is sent back
      // to the author model for a rewrite (at most MAX_REVISIONS times), and help is
      // refused only if the rewrites still give the answer away.
      for (let revisions = 0;; revisions++) {
        try {
          await deps.verify(context, result, input);
          break;
        } catch (error) {
          const reason = (error as { reason?: unknown })?.reason;
          if (
            !(error instanceof HelpError) || error.code !== "answer_disclosure" ||
            typeof reason !== "string" || revisions >= MAX_REVISIONS
          ) throw error;
          result = await deps.generate(context, revisionNote(reason));
        }
      }
    }
    const committed = object(await deps.commit(user.id, input, generation));
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
        await deps.fail(
          reservation.userId,
          reservation.input,
          reservation.generation,
        );
      } catch { /* lease expiry keeps retry safe */ }
    }
    const e = error instanceof HelpError
      ? error
      : new HelpError("help_unavailable", 503);
    // Never print the student's work, token, source context or provider body.
    return deps.json(
      {
        error: e.code,
        assistanceRecorded,
        ...(e.retryAfterSeconds
          ? { retryAfterSeconds: e.retryAfterSeconds }
          : {}),
      },
      e.status,
      req,
    );
  }
}
