export type ReportInput = {
  requestId: string;
  sessionId: string | null;
  questionId: string;
  mode: string;
  comment: string;
};
export type Receipt = {
  state?: string;
  id?: string;
  error?: string;
  subject?: string;
  question?: string;
  questionId?: string;
  mode?: string;
  comment?: string;
};
export type ReportDeps = {
  authenticate: (
    req: Request,
  ) => Promise<{ id: string; is_anonymous?: boolean } | null>;
  reserve: (userId: string, input: ReportInput) => Promise<Receipt>;
  send: (receipt: Receipt, sourceUrl?: string) => Promise<void>;
  finish: (id: string, sent: boolean) => Promise<void>;
  json: (body: unknown, status: number, req: Request) => Response;
  originAllowed: (req: Request) => boolean;
};
const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const modes = new Set(["worked", "learn", "practice", "review"]);
const sourceHosts = new Set([
  "app.cramapple.com",
  "ap-prep-blueprint.lovable.app",
  "id-preview--56cae479-f7c9-4988-b536-56538c38ee4e.lovable.app",
]);

export function reportSourceUrl(value: unknown): string | undefined {
  if (value === undefined) return undefined; // Existing published clients remain compatible.
  if (typeof value !== "string" || value.length > 2048) {
    throw new Error("invalid_source_url");
  }
  const url = new URL(value);
  if (
    url.protocol !== "https:" || !sourceHosts.has(url.hostname) || url.port ||
    url.username || url.password || url.pathname !== "/question"
  ) throw new Error("invalid_source_url");
  const fields = new Set([
    "mode",
    "type",
    "session",
    "ordinal",
    "topic",
    "unit",
    "subject",
    "from",
    "worked",
  ]);
  url.hash = "";
  for (const key of [...url.searchParams.keys()]) {
    if (!fields.has(key)) url.searchParams.delete(key);
  }
  return url.href;
}

export function reportEmailComment(
  receipt: Receipt,
  sourceUrl?: string,
): string {
  return [
    receipt.comment || "No comment added.",
    sourceUrl ? `Submitted from: ${sourceUrl}` : "",
  ]
    .filter(Boolean).join("\n\n");
}
export async function reportQuestion(
  req: Request,
  deps: ReportDeps,
): Promise<Response> {
  const respond = (body: unknown, status: number) =>
    deps.json(body, status, req);
  if (!deps.originAllowed(req)) {
    return respond({ error: "origin_not_allowed" }, 403);
  }
  if (req.method === "OPTIONS") return respond({}, 200);
  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, 405);
  }
  const user = await deps.authenticate(req);
  if (!user || user.is_anonymous) {
    return respond({ error: "unauthorized" }, 401);
  }
  let body;
  try {
    const raw = await req.text();
    if (raw.length > 12000) return respond({ error: "invalid_report" }, 400);
    body = JSON.parse(raw);
  } catch {
    return respond({ error: "invalid_report" }, 400);
  }
  if (
    !body || typeof body !== "object" ||
    ![body.requestId, body.questionId].every((v) =>
      typeof v === "string" && uuid.test(v)
    ) ||
    !modes.has(body.mode) ||
    !(body.mode === "worked"
      ? body.sessionId === null
      : typeof body.sessionId === "string" && uuid.test(body.sessionId)) ||
    (body.comment !== undefined && typeof body.comment !== "string") ||
    (body.comment ?? "").length > 2000
  ) {
    return respond({ error: "invalid_report" }, 400);
  }
  const input: ReportInput = {
    requestId: body.requestId,
    sessionId: body.sessionId,
    questionId: body.questionId,
    mode: body.mode,
    comment: (body.comment ?? "").trim(),
  };
  let sourceUrl: string | undefined;
  try {
    sourceUrl = reportSourceUrl(body.sourceUrl);
  } catch {
    return respond({ error: "invalid_report" }, 400);
  }
  try {
    const receipt = await deps.reserve(user.id, input);
    if (receipt.error) {
      const status = receipt.error === "question_not_owned"
        ? 403
        : receipt.error === "rate_limited"
        ? 429
        : 409;
      return respond({ error: receipt.error }, status);
    }
    if (receipt.state === "sent") {
      return respond({ ok: true, reportId: receipt.id }, 200);
    }
    if (receipt.state !== "reserved" || !receipt.id) {
      throw new Error("invalid_receipt");
    }
    try {
      await deps.send(receipt, sourceUrl);
    } catch {
      await deps.finish(receipt.id, false);
      return respond({ error: "email_not_confirmed" }, 503);
    }
    await deps.finish(receipt.id, true);
    return respond({ ok: true, reportId: receipt.id }, 200);
  } catch {
    // No notes, identities, credentials, question keys or provider bodies in logs.
    return respond({ error: "report_unavailable" }, 503);
  }
}
