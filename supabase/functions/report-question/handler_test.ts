import {
  type Receipt,
  type ReportDeps,
  reportEmailComment,
  reportQuestion,
  reportSourceUrl,
} from "./handler.ts";
const uid = "11111111-1111-4111-8111-111111111111";
const input = {
  requestId: uid,
  sessionId: uid,
  questionId: uid,
  mode: "practice",
  comment: "",
};
function setup(
  receipt: Receipt = {
    state: "reserved",
    id: uid,
    subject: "AP Calculus AB",
    question: "Tank volume?",
    questionId: uid,
    mode: "practice",
    comment: "",
  },
) {
  const calls: string[] = [];
  const deps: ReportDeps = {
    authenticate: async () => ({ id: uid }),
    originAllowed: () => true,
    json: (b, s) => new Response(JSON.stringify(b), { status: s }),
    reserve: async (user, body) => {
      calls.push("reserve");
      if (user !== uid || body.questionId !== uid) {
        throw new Error("bad context");
      }
      return receipt;
    },
    send: async () => {
      calls.push("send");
    },
    finish: async (_, sent) => {
      calls.push(sent ? "sent" : "failed");
    },
  };
  const request = (body: unknown = input) =>
    new Request("https://example.test/report-question", {
      method: "POST",
      body: JSON.stringify(body),
    });
  return { deps, calls, request };
}
function equal(actual: unknown, expected: unknown) {
  if (JSON.stringify(actual) !== JSON.stringify(expected)) {
    throw new Error(
      `Expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`,
    );
  }
}
Deno.test("empty comment sends, confirms delivery, and returns no question or student data", async () => {
  const t = setup();
  const res = await reportQuestion(t.request(), t.deps);
  equal(res.status, 200);
  equal(await res.json(), { ok: true, reportId: uid });
  equal(t.calls, ["reserve", "send", "sent"]);
});
Deno.test("missing or anonymous authentication never reserves or sends", async () => {
  for (const user of [null, { id: uid, is_anonymous: true }]) {
    const t = setup();
    t.deps.authenticate = async () => user;
    equal((await reportQuestion(t.request(), t.deps)).status, 401);
    equal(t.calls, []);
  }
});
Deno.test("bad origin and oversize/malformed inputs never reserve or send", async () => {
  const t = setup();
  t.deps.originAllowed = () => false;
  equal((await reportQuestion(t.request(), t.deps)).status, 403);
  equal(t.calls, []);
  for (
    const body of [
      null,
      { ...input, questionId: "wrong" },
      { ...input, mode: "other" },
      { ...input, comment: "x".repeat(2001) },
      { ...input, comment: 12 },
    ]
  ) {
    const t = setup();
    equal((await reportQuestion(t.request(body), t.deps)).status, 400);
    equal(t.calls, []);
  }
});
Deno.test("ownership denial and rate limit never send", async () => {
  for (
    const [error, status] of [
      ["question_not_owned", 403],
      ["rate_limited", 429],
      ["delivery_in_progress", 409],
      ["request_conflict", 409],
      ["retry_exhausted", 409],
    ] as const
  ) {
    const t = setup({ error });
    equal((await reportQuestion(t.request(), t.deps)).status, status);
    equal(t.calls, ["reserve"]);
  }
});
Deno.test("already-delivered retries do not send again", async () => {
  const t = setup({ state: "sent", id: uid });
  equal((await reportQuestion(t.request(), t.deps)).status, 200);
  equal(t.calls, ["reserve"]);
});
Deno.test("provider failure is visibly unsuccessful and retains a retry receipt", async () => {
  const t = setup();
  t.deps.send = async () => {
    t.calls.push("send");
    throw new Error("provider private detail");
  };
  const res = await reportQuestion(t.request(), t.deps);
  equal(res.status, 503);
  equal(await res.json(), { error: "email_not_confirmed" });
  equal(t.calls, ["reserve", "send", "failed"]);
});
Deno.test("receipt-write failure after sending is not reported as success", async () => {
  const t = setup();
  t.deps.finish = async () => {
    throw new Error("DB unavailable");
  };
  equal((await reportQuestion(t.request(), t.deps)).status, 503);
  equal(t.calls, ["reserve", "send"]);
});
Deno.test("worked examples accept a null session and reject a practice session", async () => {
  const t = setup();
  const good = { ...input, mode: "worked", sessionId: null };
  equal((await reportQuestion(t.request(good), t.deps)).status, 200);
  const other = setup();
  equal(
    (await reportQuestion(
      other.request({ ...good, sessionId: uid }),
      other.deps,
    )).status,
    400,
  );
  equal(other.calls, []);
});

Deno.test("source page is passed to email without changing the stored note", async () => {
  const t = setup();
  const sourceUrl =
    "https://app.cramapple.com/question?mode=practice&type=mcq&topic=%222.1%22";
  t.deps.reserve = async (_, body) => {
    equal(body.comment, "");
    return { state: "reserved", id: uid, comment: "" };
  };
  t.deps.send = async (receipt, source) => {
    equal(source, sourceUrl);
    equal(
      reportEmailComment(receipt, source),
      `No comment added.\n\nSubmitted from: ${sourceUrl}`,
    );
  };
  equal(
    (await reportQuestion(t.request({ ...input, sourceUrl }), t.deps)).status,
    200,
  );
});

Deno.test("source URLs retain route context but omit tokens and fragments", () => {
  equal(
    reportSourceUrl(
      "https://app.cramapple.com/question?topic=2.1&token=secret#access_token=secret",
    ),
    "https://app.cramapple.com/question?topic=2.1",
  );
  equal(
    reportEmailComment(
      { comment: "This step is confusing." },
      "https://app.cramapple.com/question",
    ),
    "This step is confusing.\n\nSubmitted from: https://app.cramapple.com/question",
  );
});

Deno.test("untrusted or malformed source URLs never reserve or send", async () => {
  for (
    const sourceUrl of [
      "https://evil.example/question",
      "javascript:alert(1)",
      "https://app.cramapple.com/login",
      "https://user:secret@app.cramapple.com/question",
      7,
      "x".repeat(2049),
    ]
  ) {
    const t = setup();
    equal(
      (await reportQuestion(t.request({ ...input, sourceUrl }), t.deps)).status,
      400,
    );
    equal(t.calls, []);
  }
});
