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
import { outputFailure, rpcFailure } from "./diagnostics.ts";
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

const conceptualStem =
  "(a) A student proposes an average velocity formula on an interval from t = 2 to t = 2. Explain why this does not work. (b) Estimate velocity using nearby intervals.";
const limitSource = {
  ...source,
  id: "limit",
  kind: "vocabulary",
  title: "Instantaneous rate via limits",
  body: "Use limits of average rates over intervals containing an instant.",
};
const answerSource = {
  ...source,
  id: "answer-fact",
  kind: "convention",
  title: "Average rate is undefined at a single point",
  body: "It is undefined when the change in time is zero.",
};
function conceptualRaw() {
  return {
    ...raw,
    item: { ...raw.item, itemType: "frq", stem: conceptualStem },
    reference: { vocabulary: [limitSource], convention: [answerSource] },
  };
}
Deno.test("conceptual rate subpart hides its answer-bearing fact from model and returned sources, while graded review retains it", () => {
  const before = helpContext(conceptualRaw(), input);
  assertEquals(before.sources.map((s) => s.id), ["limit"]);
  assertEquals(before.grounding.facts.map((s) => s.id), ["limit"]);
  assertEquals(typeof before.grounding.coachingBoundary, "string");
  assertEquals(
    helpContext(conceptualRaw(), { ...input, phase: "after" }).sources.length,
    2,
  );
  assertThrows(
    () =>
      helpContext({
        ...conceptualRaw(),
        reference: { convention: [answerSource] },
      }, input),
    HelpError,
  );
});
Deno.test("observed conceptual subpart conclusions are withheld; setup questions and post-grade explanations remain usable", () => {
  for (
    const leak of [
      "The formula is undefined.",
      "The denominator b − a is 0.",
      "This requires division by zero.",
      "There is no elapsed time.",
    ]
  ) {
    const e = assertThrows(
      () =>
        validateHelp(
          { ...output, explanation: leak },
          [source],
          conceptualStem,
          true,
        ),
      HelpError,
    );
    assertEquals(e.code, "answer_disclosure");
    assertEquals(e.diagnosticReason, "conceptual_subpart");
    assertEquals(
      validateHelp(
        { ...output, explanation: leak },
        [source],
        conceptualStem,
        false,
      ).explanation,
      leak,
    );
  }
  const setup =
    "Identify what each change in the ratio measures, then inspect the proposed interval yourself.";
  assertEquals(
    validateHelp(
      {
        ...output,
        explanation: setup,
        next_step: "Use the given t = 2 to label the interval endpoints.",
      },
      [source],
      conceptualStem,
      true,
    ).explanation,
    setup,
  );
});
Deno.test("invalid text lengths have content-free diagnoses and are never committed or disclosed", async () => {
  const logs: unknown[] = [];
  const warn = console.warn;
  console.warn = (...args) => logs.push(args);
  let commits = 0, releases = 0;
  try {
    const fake = (async () =>
      new Response(
        JSON.stringify({
          choices: [{
            finish_reason: "stop",
            message: {
              content: JSON.stringify({
                ...output,
                headline: "SECRET ".repeat(20),
              }),
            },
          }],
        }),
      )) as typeof fetch;
    const response = await moreHelp(request(), {
      ...deps(),
      generate: (ctx) =>
        generateHelp(ctx, "SECRET TOKEN", HELP_GATEWAY_MODEL, fake),
      commit: async () => {
        commits++;
        return { state: "delivered" };
      },
      fail: async () => {
        releases++;
      },
    });
    assertEquals(response.status, 502);
    assertEquals(await response.json(), {
      error: "invalid_model_output",
      assistanceRecorded: false,
    });
    assertEquals(commits, 0);
    assertEquals(releases, 1);
    assertEquals(JSON.stringify(logs).includes("headline_length"), true);
    assertEquals(JSON.stringify(logs).includes("SECRET"), false);
    outputFailure("private provider output");
    assertEquals(JSON.stringify(logs).includes("private"), false);
  } finally {
    console.warn = warn;
  }
});
Deno.test("missing/malformed follow-ups and length limits fail closed with specific safe diagnoses", () => {
  for (
    const [follow_ups, reason] of [
      [null, "follow_ups_type"],
      [["x".repeat(101)], "follow_up_length"],
      [[1], "follow_up_type_or_empty"],
      [["a", "b", "c", "d"], "follow_ups_count"],
    ] as const
  ) {
    const e = assertThrows(
      () => validateHelp({ ...output, follow_ups }, [source], raw.item.stem),
      HelpError,
    );
    assertEquals(e.diagnosticReason, reason);
  }
});

Deno.test("rate protection scans caution, item and hook copy before model/client disclosure", () => {
  const variants = [
    { caution: "The rate is undefined." },
    { items: [{ label: "Reason", meaning: "The rate is undefined." }] },
    { items: [{ label: "Undefined rate", meaning: "Check the interval." }] },
    {
      memoryHooks: [{
        id: "h",
        hookText: "The rate is undefined.",
        expandsTo: [],
      }],
    },
    {
      memoryHooks: [{
        id: "h",
        hookText: "Check the interval",
        caution: "The rate is undefined.",
        expandsTo: [],
      }],
    },
    {
      memoryHooks: [{
        id: "h",
        hookText: "Check the interval",
        whenToUse: "The rate is undefined.",
        expandsTo: [],
      }],
    },
    {
      memoryHooks: [{
        id: "h",
        hookText: "Check the interval",
        expandsTo: [{ cue: "Undefined rate", means: "Check the interval" }],
      }],
    },
    {
      memoryHooks: [{
        id: "h",
        hookText: "Check the interval",
        expandsTo: [{ cue: "Rate", means: "The rate is undefined." }],
      }],
    },
  ];
  for (const fields of variants) {
    const tainted = { ...limitSource, id: "tainted", ...fields };
    const r = {
      ...conceptualRaw(),
      reference: { vocabulary: [limitSource, tainted] },
    };
    const before = helpContext(r, input);
    assertEquals(before.sources.map((s) => s.id), ["limit"]);
    assertEquals(
      JSON.stringify(before.grounding.facts).includes("undefined"),
      false,
    );
    assertEquals(
      helpContext(r, { ...input, phase: "after" }).sources.length,
      2,
    );
  }
});
Deno.test("plain choice verdicts, eliminations and explicit numeric conclusions are rejected without banning given values", () => {
  for (
    const copy of [
      "Choice B is right.",
      "Eliminate A and C; B remains.",
      "So f'(2) equals 12, matching (B).",
      "The result you want is 12.",
      "Therefore the limit is 3.",
    ]
  ) {
    for (
      const field of [
        "headline",
        "explanation",
        "next_step",
        "follow_ups",
      ] as const
    ) {
      const e = assertThrows(
        () =>
          validateHelp(
            { ...output, [field]: field === "follow_ups" ? [copy] : copy },
            [source],
            raw.item.stem,
            true,
          ),
        HelpError,
      );
      assertEquals(e.code, "answer_disclosure");
    }
    assertEquals(
      validateHelp(
        { ...output, explanation: copy },
        [source],
        raw.item.stem,
        false,
      ).explanation,
      copy,
    );
  }
  for (
    const setup of [
      "Use the given 12 grams to set up a conversion.",
      "Compare A and C using the quantities in the stem.",
      "The prompt gives a derivative of 12; identify its units.",
    ]
  ) {
    assertEquals(
      validateHelp(
        { ...output, explanation: setup },
        [source],
        raw.item.stem,
        true,
      ).explanation,
      setup,
    );
  }
});
Deno.test("sibling rate phrasings and answer synonyms receive the same before-phase source boundary", () => {
  for (
    const stem of [
      "Explain why the average rate of change cannot be found on [3,3].",
      "Explain why the average velocity is not defined on [2,2].",
      "Justify why the average velocity cannot be computed on this interval.",
    ]
  ) {
    for (
      const conclusion of [
        "The rate is not defined.",
        "The rate does not exist.",
        "The rate cannot be computed.",
        "The rate is meaningless.",
      ]
    ) {
      const r = {
        ...conceptualRaw(),
        item: { ...conceptualRaw().item, stem },
        reference: {
          vocabulary: [limitSource, {
            ...limitSource,
            id: "answer",
            caution: conclusion,
          }],
        },
      };
      assertEquals(helpContext(r, input).sources.map((s) => s.id), ["limit"]);
      assertEquals(
        typeof helpContext(r, input).grounding.coachingBoundary,
        "string",
      );
      assertEquals(
        assertThrows(() =>
          validateHelp(
            { ...output, explanation: conclusion },
            [source],
            stem,
            true,
          ), HelpError).code,
        "answer_disclosure",
      );
    }
  }
});
Deno.test("an exact already-delivered request acknowledges durable assistance without another provider call", async () => {
  let calls = 0;
  const response = await moreHelp(request(), {
    ...deps(async () => ({ error: "request_already_used" })),
    generate: async () => {
      calls++;
      return output;
    },
  });
  assertEquals(response.status, 409);
  assertEquals(await response.json(), {
    error: "request_already_used",
    assistanceRecorded: true,
  });
  assertEquals(calls, 0);
});
