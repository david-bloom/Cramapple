import {
  assertEquals,
  assertThrows,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  helpContext,
  HelpError,
  object,
  parseInput,
  statedConclusionKinds,
  SUBJECTS,
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
Deno.test("all ten registry subjects support exact-question before/graded help without a unit-number gate", () => {
  const cases: Array<[string, number]> = [
    ["biology", 1],
    ["ap-calculus-ab", 8],
    ["ap-calculus-bc", 10],
    ["ap-chemistry", 9],
    ["ap-precalculus", 3],
    ["ap-statistics", 3],
    ["ap-physics-1", 3],
    ["ap-physics-2", 11],
    ["ap-physics-c-mechanics", 3],
    ["ap-physics-c-em", 10],
  ];
  assertEquals(new Set(SUBJECTS), new Set(cases.map(([subject]) => subject)));
  for (const [subjectKey, unitNumber] of cases) {
    const question = {
      ...raw,
      topic: { subjectKey, unitNumber, topicCode: `${unitNumber}.1` },
    };
    const before = helpContext(question, input);
    assertEquals(before.grounding.topic.subject, subjectKey);
    assertEquals(before.grounding.recordedGrade, null);
    assertEquals(before.grounding.answerFeedback, null);
    const graded = helpContext(question, { ...input, phase: "after" });
    assertEquals(graded.after, true);
    assertEquals(graded.grounding.recordedGrade?.points, 0);
    const revision = helpContext(
      { ...question, attempt: { status: "draft" } },
      { ...input, phase: "after" },
    );
    assertEquals(revision.grounding.recordedGrade, null);
    assertEquals(revision.grounding.answerFeedback, null);
    assertThrows(
      () =>
        helpContext({
          ...question,
          item: { ...raw.item, contentItemVersionId: "foreign" },
        }, input),
      HelpError,
    );
    assertThrows(
      () => helpContext({ ...question, reference: {} }, input),
      HelpError,
    );
  }
  // Guide/taxonomy aliases and a client-invented subject are never trusted as
  // registry identities; the owned authoritative RPC is the only source.
  for (
    const subjectKey of [
      "ap-biology",
      "ap_biology",
      "ap_physics_2",
      "economics",
    ]
  ) {
    assertThrows(
      () => helpContext({ ...raw, topic: { subjectKey } }, input),
      HelpError,
    );
  }
});
Deno.test("continuity statement selection rejects observed pre-submit verdicts in every generated field", () => {
  const stem = "Consider the following statements. I. lim(t->4) r(t) exists. II. r is continuous at 4. III. r has a removable discontinuity. Which statements are true?";
  const question = { ...raw, item: { ...raw.item, stem } };
  assertEquals(typeof helpContext(question, input).grounding.coachingBoundary, "string");
  for (const verdict of [
    "Removable discontinuity: limit exists but differs from r(4)",
    "The limit exists.",
    "The limit does not exist.",
    "The function is not continuous at t = 4.",
    "It has a removable discontinuity.",
    "Statements I and III are true.",
    "Removable discontinuity",
    "r is not continuous at t = 4.",
    "A removable discontinuity at t = 4.",
    "Both I and III are true.",
    "Here, the limit exists.",
  ]) {
    for (const field of ["headline", "explanation", "next_step", "follow_ups"]) {
      const response = { ...output, [field]: field === "follow_ups" ? [verdict] : verdict };
      assertThrows(() => validateHelp(response, [source], stem, true), HelpError);
      validateHelp(response, [source], stem, false);
    }
  }
  for (const safe of [
    "Check the limit and recorded value separately.",
    "Check whether the limit exists, then compare it with the recorded value.",
    "What makes a discontinuity removable rather than a jump?",
    "A removable discontinuity can be removed by redefining the function value.",
  ]) {
    validateHelp({ ...output, explanation: safe }, [source], stem, true);
  }
});
Deno.test("multipart context preserves complete authored instructions and applies subpart disclosure protection", () => {
  const question = {
    ...raw,
    item: {
      ...raw.item,
      stem: "A tank contains water.",
      questionParts: [{
        key: "a",
        prompt:
          "Explain why average rate cannot be computed over this interval.",
      }, { key: "b", prompt: "Find a derivative." }],
      questionPartsComplete: true,
    },
  };
  const context = helpContext(question, input);
  assertEquals(context.grounding.question.parts, question.item.questionParts);
  assertEquals(typeof context.grounding.coachingBoundary, "string");
  assertThrows(
    () =>
      validateHelp(
        { ...output, explanation: "The denominator is zero." },
        context.sources,
        question.item.stem,
        true,
        context.questionText,
      ),
    HelpError,
  );
  assertThrows(
    () =>
      helpContext({
        ...question,
        item: { ...question.item, questionPartsComplete: false },
      }, input),
    HelpError,
  );
  assertThrows(
    () =>
      helpContext({
        ...question,
        item: {
          ...question.item,
          questionParts: [{ key: "a", prompt: "x".repeat(16001) }],
        },
      }, input),
    HelpError,
  );
});
Deno.test("only the RPC complete reviewed visual transcript enables an image question", () => {
  const questionVisual = {
    alt: "A coordinate graph.",
    description: "Two lines with open endpoints.",
    completeReviewedDescription: true,
    storagePath: "private",
    secret: "private",
  };
  const context = helpContext({
    ...raw,
    item: { ...raw.item, hasStimulusImage: true, questionVisual },
  }, input);
  assertEquals(
    context.grounding.question.visual?.description,
    questionVisual.description,
  );
  assertEquals(JSON.stringify(context.grounding).includes("private"), false);
  for (
    const invalid of [
      { alt: "A graph" },
      { ...questionVisual, completeReviewedDescription: false },
      { ...questionVisual, description: "" },
      { ...questionVisual, description: "x".repeat(10001) },
    ]
  ) {
    assertThrows(
      () =>
        helpContext({
          ...raw,
          item: {
            ...raw.item,
            hasStimulusImage: true,
            questionVisual: invalid,
          },
        }, input),
      HelpError,
    );
  }
  assertEquals(parseInput({ ...input, questionVisual }).work, input.work);
});
Deno.test("figures are linked to retained and cited facts, nullable optional fields are omitted", () => {
  const figure = {
    figureId: "fig-1",
    family: "xy_graph",
    alt: "An example graph",
    params: {},
    valuesNote: null,
    xTickFmt: null,
    yTickFmt: null,
    usedBy: [{ kind: "reference_entry", id: "s1", role: "illustration" }, {
      kind: "reference_entry",
      id: "private",
      role: "illustration",
    }],
    private: "private",
  };
  const context = helpContext({
    ...raw,
    figures: [figure, {
      ...figure,
      figureId: "foreign",
      usedBy: [{ kind: "reference_entry", id: "not-retained" }],
    }],
  }, input);
  const help = validateHelp(output, context.sources, raw.item.stem);
  assertEquals(help.figures.length, 1);
  assertEquals("valuesNote" in help.figures[0], false);
  assertEquals(JSON.stringify(help.figures).includes("private"), false);
  const trapQuestion = {
    ...raw,
    item: {
      ...raw.item,
      stem: "Explain why average rate cannot be computed over this interval.",
    },
    reference: { formula: [source, { ...source, id: "safe" }] },
    figures: [{ ...figure, caption: "The denominator is zero." }],
  };
  const before = helpContext(trapQuestion, input);
  assertEquals(before.sources.map((s) => s.id), ["safe"]);
  assertEquals(
    validateHelp(
      { ...output, source_ids: ["safe"] },
      before.sources,
      trapQuestion.item.stem,
    ).figures.length,
    0,
  );
});
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
      { ...raw, topic: { subjectKey: "ap-economics" } },
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
Deno.test("observed zero-width headline and rate siblings cannot answer the conceptual subpart", () => {
  for (const leak of [
    "Average rate over a zero-width interval: what the formula needs",
    "A zero-length interval.",
    "The interval has no duration.",
    "The interval has zero width.",
    "A 0-duration interval.",
  ]) {
    for (const field of ["headline", "explanation", "next_step", "follow_ups"]) {
      const response = { ...output, [field]: field === "follow_ups" ? [leak] : leak };
      assertThrows(() => validateHelp(response, [source], conceptualStem, true), HelpError);
      validateHelp(response, [source], conceptualStem, false);
    }
  }
  validateHelp({ ...output, explanation: "Inspect the interval width and decide whether the denominator is usable." }, [source], conceptualStem, true);
  const context = helpContext({ ...conceptualRaw(), reference: { vocabulary: [limitSource], convention: [{ ...answerSource, body: "Average rate over a zero-width interval." }] } }, input);
  assertEquals(context.sources.map((s) => s.id), ["limit"]);
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
      "(B) is correct.",
      "B is the best choice.",
      "Go with B.",
      "Option B works here.",
      "The answer lies in choice B.",
      "Only D fits.",
      "Is B correct?",
      "cHoIcE b is right.",
      "ELIMINATE option c.",
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
      "Try matching each term to the power rule.",
      "Start by matching data in the table to the corresponding units.",
      "Try matching exponents on both sides.",
      "Eliminate a common factor first, then differentiate.",
      "Rule out a sign error by checking the units.",
      "Since the table gives it, so the value is 3 at x=2; use that as your starting point.",
      "Matching Data means comparing the given observations.",
      "ELIMINATE a common factor before applying the rule.",
      "Check whether AB is correct by applying the formula.",
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
        "The interval has width zero so it gives 0/0.",
        "The rate is indeterminate.",
        "The calculation gives no rate.",
        "A zero denominator prevents computing this rate.",
        "A 0 denominator prevents computing this rate.",
        "There is zero change in time.",
        "There is 0 change in time.",
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

Deno.test("FRQ identify/define subparts: boundary is set and generated copy may not name the procedure before submission", () => {
  const stem = "(a) Identify the appropriate testing procedure, and define the parameter of interest in context. (b) State the null and alternative hypotheses.";
  const frq = { ...raw, item: { ...raw.item, stem, itemType: "frq" } };
  assertEquals(typeof helpContext(frq, input).grounding.coachingBoundary, "string");
  // Same wording on an MCQ, and after grading, keeps the default behavior.
  assertEquals(String(helpContext({ ...frq, item: { ...frq.item, itemType: "mcq" } }, input).grounding.coachingBoundary).includes("multiple-choice"), true);
  for (const leak of [
    "This is a one-sample z-test for a proportion.",
    "This is a one-proportion setting, so use a z procedure.",
    "The relevant procedure is a one-sample z-test.",
    "Use a two-sample t-interval for the difference.",
    "A chi-square test of independence fits here.",
    "This calls for a matched-pairs design.",
  ]) {
    for (const field of ["headline", "explanation", "next_step", "follow_ups"]) {
      const response = { ...output, [field]: field === "follow_ups" ? [leak] : leak };
      assertThrows(() => validateHelp(response, [source], stem, true, stem, "frq"), HelpError);
      validateHelp(response, [source], stem, false, stem, "frq");
      validateHelp(response, [source], stem, true, stem, "mcq");
    }
  }
  for (const safe of [
    "Read how the sample was chosen and what single quantity the department tracks, then compare with the published definitions of each procedure.",
    "Which words in the stem name the group the claim is about?",
    "Write one sentence saying what p stands for, naming the population.",
  ]) {
    validateHelp({ ...output, explanation: safe }, [source], stem, true, stem, "frq");
  }
});

Deno.test("law check ignores third-law partner asks and laws the question itself names", () => {
  const stem = "(b) A student says these form a Newton's third law pair. Explain whether the student is correct, and identify the actual third-law partner of the gravitational force.";
  assertEquals(statedConclusionKinds(stem).includes("law"), false);
  const named = "(c) Identify the law that governs the system. Newton's second law is not required.";
  assertEquals(statedConclusionKinds(named).includes("law"), true);
  validateHelp({ ...output, explanation: "Newton's second law is mentioned in the stem; start from the forces on one skater." }, [source], named, true, named, "frq");
  assertThrows(() => validateHelp({ ...output, explanation: "Use conservation of momentum." }, [source], named, true, named, "frq"), HelpError);
});

Deno.test("MCQ before submission gets the no-conclusion coaching boundary; after grading and FRQs do not", () => {
  const mcq = { ...raw, item: { ...raw.item, itemType: "mcq" } };
  assertEquals(String(helpContext(mcq, input).grounding.coachingBoundary).includes("multiple-choice"), true);
  const frq = { ...raw, item: { ...raw.item, stem: "(a) Calculate the value.", itemType: "frq" } };
  assertEquals(helpContext(frq, input).grounding.coachingBoundary, null);
});
