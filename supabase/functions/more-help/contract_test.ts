import {
  assertEquals,
  assertThrows,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  helpContext,
  HelpError,
  object,
  parseInput,
  validateHelp,
} from "./contract.ts";
import { type Dependencies, moreHelp } from "./handler.ts";
import { generateHelp, HELP_GATEWAY_MODEL, HELP_GATEWAY_URL } from "./model.ts";
import { rpcFailure } from "./diagnostics.ts";
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
    Promise.resolve({ state: "reserved", generation: 1 }),
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
Deno.test("Anthropic Gateway uses the exact demo endpoint/model, no thinking, bounded strict output; incomplete rejected", async () => {
  let body: Record<string, unknown> = {};
  const fake = (async (_url: unknown, init: RequestInit) => {
    assertEquals(_url, HELP_GATEWAY_URL);
    body = JSON.parse(String(init.body));
    return new Response(
      JSON.stringify({
        choices: [{
          finish_reason: "stop",
          message: { content: JSON.stringify(output) },
        }],
      }),
    );
  }) as typeof fetch;
  const result = await generateHelp(
    helpContext(raw, input),
    "server-key",
    HELP_GATEWAY_MODEL,
    fake,
  );
  assertEquals(body.store, false);
  assertEquals(body.max_tokens, 2500);
  assertEquals(body.model, HELP_GATEWAY_MODEL);
  assertEquals(body.reasoning, { effort: "none" });
  assertEquals(object(body.response_format).type, "json_schema");
  assertEquals(result.sources[0].id, "s1");
  const incomplete = (async () =>
    new Response(
      JSON.stringify({
        choices: [{ finish_reason: "length", message: { content: "{}" } }],
      }),
    )) as typeof fetch;
  let failed = false;
  try {
    await generateHelp(
      helpContext(raw, input),
      "server-key",
      HELP_GATEWAY_MODEL,
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

Deno.test("explicit pre-submit answer/key claims are refused while given values and setup remain usable", () => {
  for (
    const leak of [
      "The answer is B.",
      "Select B.",
      "The final value is 42.",
      "Answer: 4.",
    ]
  ) {
    assertThrows(
      () =>
        validateHelp(
          { ...output, next_step: leak },
          [source],
          raw.item.stem,
          true,
        ),
      HelpError,
    );
  }
  assertEquals(
    validateHelp(
      { ...output, next_step: "Use the given 4 seconds to set up the rate." },
      [source],
      raw.item.stem,
      true,
    ).nextStep,
    "Use the given 4 seconds to set up the rate.",
  );
  assertEquals(
    validateHelp(
      { ...output, next_step: "The answer is B." },
      [source],
      raw.item.stem,
      false,
    ).nextStep,
    "The answer is B.",
  );
});
Deno.test("uncertain recorded results get an honest pending-review error rather than before-phase help", () => {
  const error = assertThrows(
    () =>
      helpContext(
        { ...raw, grading: { ...raw.grading, status: "uncertain" } },
        { ...input, phase: "after" },
      ),
    HelpError,
  );
  assertEquals(error.code, "help_grade_pending");
});
Deno.test("hook/item metadata is allowlisted before it reaches the provider or client", () => {
  const context = helpContext({
    ...raw,
    reference: {
      formula: [{
        ...source,
        memoryHooks: [{
          id: "h",
          kind: "mnemonic",
          hookText: "Remember units",
          sourceNote: "internal provenance",
          visualAssetRef: "internal asset",
          expandsTo: [{ cue: "x", means: "value", sourceNote: "internal" }],
        }],
      }],
    },
  }, input);
  const copy = JSON.stringify(context.sources);
  assertEquals(copy.includes("internal"), false);
  assertEquals(
    object(context.sources[0].memoryHooks[0]).hookText,
    "Remember units",
  );
});
Deno.test("server highlights never overlap inline/block/delimited math", () => {
  const stem = "Use $x+1$ and \\(t^2\\) then divide.";
  assertEquals(
    validateHelp(
      { ...output, highlights: ["Use", "x+1", "and \\(t", "t^2", "divide"] },
      [source],
      stem,
    ).highlights,
    ["Use", "divide"],
  );
});
Deno.test("reservation errors distinguish conflicts, exhaustion, authorization and service failures", async () => {
  for (
    const [code, status] of [
      ["request_in_progress", 409],
      ["request_conflict", 409],
      ["retry_exhausted", 429],
      ["question_not_owned", 403],
      ["reservation_failed", 503],
    ] as const
  ) {
    const response = await moreHelp(
      request(),
      deps(() => Promise.resolve({ error: code, retryAfterSeconds: 60 })),
    );
    assertEquals(response.status, status);
    assertEquals((await response.json()).retryAfterSeconds, 60);
  }
});
Deno.test("a missing gateway configuration fails before consuming a reservation or calling a model", async () => {
  let calls = 0;
  const response = await moreHelp(request(), {
    ...deps(() => {
      calls++;
      return Promise.resolve({ state: "reserved", generation: 1 });
    }),
    preflight: () => {
      throw new HelpError("help_not_configured", 503);
    },
  });
  assertEquals(response.status, 503);
  assertEquals(calls, 0);
});
Deno.test("generation fence is forwarded to delivery and failure acknowledgements", async () => {
  let generation = 0;
  await moreHelp(request(), {
    ...deps(() => Promise.resolve({ state: "reserved", generation: 2 })),
    commit: (_u, _i, g) => {
      generation = g;
      return Promise.resolve({ state: "delivered" });
    },
  });
  assertEquals(generation, 2);
  await moreHelp(request(), {
    ...deps(() => Promise.resolve({ state: "reserved", generation: 3 })),
    generate: () => Promise.reject(new HelpError("help_refused", 422)),
    fail: (_u, _i, g) => {
      generation = g;
      return Promise.resolve();
    },
  });
  assertEquals(generation, 3);
});
Deno.test("gateway refusal is terminal and never returns partial/generated text", async () => {
  const fake = (async () =>
    new Response(
      JSON.stringify({
        choices: [{
          finish_reason: "stop",
          message: {
            refusal: "provider body",
            content: JSON.stringify(output),
          },
        }],
      }),
    )) as typeof fetch;
  let code = "";
  try {
    await generateHelp(
      helpContext(raw, input),
      "server-key",
      HELP_GATEWAY_MODEL,
      fake,
    );
  } catch (e) {
    code = e instanceof HelpError ? e.code : "unknown";
  }
  assertEquals(code, "help_refused");
});
Deno.test("RPC diagnostics expose only the operation and a SQLSTATE", () => {
  const logs: unknown[] = [];
  const warn = console.warn;
  console.warn = (...args) => {
    logs.push(args);
  };
  try {
    rpcFailure("commit_question_help", "42501");
    rpcFailure("fail_question_help", "private message and token");
  } finally {
    console.warn = warn;
  }
  assertEquals(JSON.stringify(logs).includes("private"), false);
  assertEquals(JSON.stringify(logs).includes("42501"), true);
});
