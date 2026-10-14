import {
  assertEquals,
  assertThrows,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  helpContext,
  HelpError,
  parseInput,
  validateHelp,
} from "./contract.ts";
import { type Dependencies, moreHelp } from "./handler.ts";
import { generateHelp } from "./model.ts";
const input = {
  requestId: "10000000-0000-4000-8000-000000000001",
  sessionId: "10000000-0000-4000-8000-000000000002",
  questionId: "10000000-0000-4000-8000-000000000003",
  ordinal: 1,
  focus: "",
  work: "A",
  phase: "before" as const,
};
const source = {
  id: "s1",
  kind: "formula",
  title: "Average rate",
  body: "\\frac{f(b)-f(a)}{b-a}",
  items: [],
  caution: null,
  memoryHooks: [],
  ownerTopicCode: "2.1",
  topicCodes: ["2.1"],
};
const raw = {
  session: { learningSessionId: input.sessionId },
  counter: { index: 1 },
  item: {
    contentItemVersionId: input.questionId,
    stem: "Find the average rate of change.",
    itemType: "mcq",
  },
  topic: { subjectKey: "ap-calculus-ab" },
  reference: { formula: [source] },
  grading: {
    status: "graded",
    pointsEarned: 0,
    pointsAvailable: 1,
    criterionResults: [],
  },
  mcqFeedback: { correct: "B" },
  priorAttempts: [{ identity: "private" }],
};
const output = {
  headline: "Compare two changes",
  explanation: "Compare the change in volume with the change in time.",
  next_step: "Evaluate the two endpoint values.",
  source_ids: ["s1"],
  highlights: ["average rate of change", "invented phrase"],
  follow_ups: ["Why divide by time?"],
};
Deno.test("before-submit payload has no authored answer, grading, prior history or client grading override", () => {
  const context = helpContext(
    { ...raw, userId: "private" },
    parseInput({ ...input, correctAnswer: "A", grade: 99 }),
  );
  assertEquals(context.after, false);
  assertEquals(context.grounding.recordedGrade, null);
  assertEquals(context.grounding.answerFeedback, null);
  assertEquals(JSON.stringify(context.grounding).includes("private"), false);
});
Deno.test("post-grade uses recorded grade only; client after cannot manufacture a grade", () => {
  assertEquals(
    helpContext(raw, { ...input, phase: "after" }).grounding.recordedGrade
      ?.points,
    0,
  );
  assertEquals(
    helpContext({ ...raw, grading: null }, { ...input, phase: "after" }).after,
    false,
  );
  const revision = helpContext({ ...raw, attempt: { status: "draft" } }, {
    ...input,
    phase: "after",
  });
  assertEquals(revision.after, false);
  assertEquals(revision.grounding.recordedGrade, null);
  assertEquals(revision.grounding.answerFeedback, null);
});
Deno.test("unknown subject, foreign version, missing facts and unavailable visual refuse help", () => {
  for (
    const value of [
      { ...raw, topic: { subjectKey: "biology" } },
      { ...raw, item: { ...raw.item, contentItemVersionId: "foreign" } },
      { ...raw, reference: {} },
      { ...raw, item: { ...raw.item, hasStimulusImage: true } },
    ]
  ) assertThrows(() => helpContext(value, input), HelpError);
});
Deno.test("bounded request rejects oversized work/focus and invalid IDs", () => {
  for (
    const value of [
      { ...input, work: "x".repeat(4001) },
      { ...input, focus: "x".repeat(161) },
      { ...input, ordinal: 0 },
      { ...input, sessionId: "not-uuid" },
    ]
  ) assertThrows(() => parseInput(value), HelpError);
});
Deno.test("unknown/duplicate sources and oversized generated prose rejected; highlights must be verbatim", () => {
  assertEquals(validateHelp(output, [source], raw.item.stem).highlights, [
    "average rate of change",
  ]);
  for (
    const value of [{ ...output, source_ids: ["unknown"] }, {
      ...output,
      source_ids: ["s1", "s1"],
    }, { ...output, explanation: "x".repeat(1401) }]
  ) assertThrows(() => validateHelp(value, [source], raw.item.stem), HelpError);
});
const request = () =>
  new Request("https://example.test", {
    method: "POST",
    body: JSON.stringify(input),
  });
function deps(
  reserve: Dependencies["reserve"] = () =>
    Promise.resolve({ state: "reserved" }),
): Dependencies {
  return {
    authenticate: () => Promise.resolve({ id: "student" }),
    originAllowed: () => true,
    json: (v, status) => new Response(JSON.stringify(v), { status }),
    load: () => Promise.resolve(raw),
    reserve,
    commit: () => Promise.resolve({ state: "delivered" }),
    fail: () => Promise.resolve(),
    generate: () => Promise.resolve(output),
  };
}
Deno.test("auth and reservation failures never invoke generation", async () => {
  let calls = 0;
  for (
    const config of [
      {
        ...deps(),
        authenticate: () => Promise.resolve(null),
      },
      deps(() => Promise.resolve({ error: "rate_limited" })),
      deps(() => Promise.resolve({ error: "entitlement_required" })),
    ]
  ) {
    const response = await moreHelp(request(), {
      ...config,
      generate: () => {
        calls++;
        return Promise.resolve(output);
      },
    });
    assertEquals(response.ok, false);
  }
  assertEquals(calls, 0);
});
Deno.test("failed provider records no assistance; errors disclose no work", async () => {
  let commits = 0;
  let failures = 0;
  const response = await moreHelp(request(), {
    ...deps(),
    commit: () => {
      commits++;
      return Promise.resolve({ state: "delivered" });
    },
    fail: () => {
      failures++;
      return Promise.resolve();
    },
    generate: () => Promise.reject(new Error("private token and work")),
  });
  assertEquals(commits, 0);
  assertEquals(failures, 1);
  assertEquals(await response.json(), {
    error: "help_unavailable",
    assistanceRecorded: false,
  });
});
Deno.test("model request uses store=false, strict source enum and bounded timeout/output; incomplete rejected", async () => {
  let body: Record<string, unknown> = {};
  const fake = (async (_url: unknown, init: RequestInit) => {
    body = JSON.parse(String(init.body));
    return new Response(
      JSON.stringify({
        status: "completed",
        output_text: JSON.stringify(output),
      }),
    );
  }) as typeof fetch;
  const result = await generateHelp(
    helpContext(raw, input),
    "server-key",
    "configured-model",
    fake,
  );
  assertEquals(body.store, false);
  assertEquals(body.max_output_tokens, 2500);
  assertEquals(result.sources[0].id, "s1");
  const incomplete =
    (async () =>
      new Response(JSON.stringify({ status: "incomplete" }))) as typeof fetch;
  let failed = false;
  try {
    await generateHelp(
      helpContext(raw, input),
      "server-key",
      "configured-model",
      incomplete,
    );
  } catch (e) {
    failed = e instanceof HelpError;
  }
  assertEquals(failed, true);
});

Deno.test("generated content is withheld if durable delivery acknowledgement fails", async () => {
  let failed = false;
  const response = await moreHelp(request(), {
    ...deps(),
    commit: () => Promise.resolve({ error: "delivery_expired" }),
    fail: () => {
      failed = true;
      return Promise.resolve();
    },
  });
  assertEquals(response.status, 503);
  assertEquals(failed, true);
  assertEquals(await response.json(), {
    error: "assistance_commit_failed",
    assistanceRecorded: false,
  });
});
