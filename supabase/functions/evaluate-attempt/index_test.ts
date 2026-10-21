import "./_test_setup.ts";
import { assertEquals } from "jsr:@std/assert@1";
import { composeMcqFeedback, handleEvaluateAttempt } from "./index.ts";

type Route = "mcq" | "shadow" | "llm";
type Outcome =
  | "error"
  | "missing"
  | "stored"
  | "transport"
  | "committed_transport";
type Deps = NonNullable<Parameters<typeof handleEvaluateAttempt>[1]>;
function gradeFixture(
  route: Route,
  outcomes: Outcome[],
  checkpointFails = false,
) {
  const id = (n: number) =>
    `30000000-0000-4000-8000-${String(n).padStart(12, "0")}`;
  const writes: string[] = [];
  let grade: Record<string, unknown> | null = null;
  let clock = Date.now();
  let modelCalls = 0;
  let storedWrites = 0;
  const attemptOutcomes: Outcome[] = [];
  const tick = () => new Date(++clock).toISOString();
  const rows: Record<string, unknown> = {
    prompt_versions: { status: "published" },
    attempts: {
      id: id(2),
      user_id: id(1),
      exam_pack_version_id: id(5),
      content_item_version_id: id(4),
      attempt_mode: route === "mcq" ? "mcq" : "frq",
      status: "submitted",
    },
    response_versions: {
      id: id(3),
      attempt_id: id(2),
      response_text: "A",
      response_parts: { selected_choice_key: "A" },
      is_submitted: true,
    },
    content_item_versions: {
      id: id(4),
      content_item_id: id(6),
      status: "published",
      stem: "Question",
      rubric_type: route === "mcq"
        ? "mcq"
        : route === "llm"
        ? "discrete_text"
        : "spatial",
    },
    content_items: {
      id: id(6),
      status: "published",
      title: "Item",
      item_type: route === "mcq" ? "mcq" : "frq",
      content_key: "fixture",
    },
    exam_pack_versions: { id: id(5), exam_pack_id: id(7), status: "published" },
    exam_packs: { id: id(7), exam_name: "AP Biology", exam_code: "ap-biology" },
    mcq_choices: [{
      choice_key: "A",
      choice_text: "Correct",
      is_correct: true,
    }],
    frq_criteria: route === "llm"
      ? [{
        criterion_key: "c1",
        learner_facing_text: "Identify A",
        points_possible: 1,
      }]
      : [],
  };
  const service = {
    schema: () => ({
      rpc: () => Promise.resolve({ data: { id: id(8) }, error: null }),
      from: (table: string) => {
        let action = "read";
        let payload: Record<string, unknown> = {};
        const eqs: Record<string, unknown> = {};
        const neqs: Record<string, unknown> = {};
        const result = (single: boolean) => {
          if (action !== "read") {
            writes.push(
              `${table}:${action}:${payload.status ?? "other"}`,
            );
          }
          if (table === "grading_results") {
            if (action === "insert") {
              if (grade) return { data: null, error: { code: "23505" } };
              grade = { ...payload, created_at: tick(), updated_at: tick() };
            } else if (action === "update") {
              if (
                !grade || Object.entries(eqs).some(([k, v]) => grade![k] !== v)
              ) return { data: null, error: null };
              const checkpoint = payload.status === "failed";
              if (checkpoint && checkpointFails) {
                return {
                  data: null,
                  error: { code: "XX000" },
                };
              }
              if (
                !checkpoint && payload.status !== "processing" &&
                Object.hasOwn(payload, "criterion_results")
              ) {
                const outcome = outcomes.shift() ?? "stored";
                if (outcome === "error") {
                  return {
                    data: null,
                    error: { code: "XX000", message: "private detail" },
                  };
                }
                if (outcome === "missing") return { data: null, error: null };
                if (outcome === "transport") {
                  throw new Error(
                    "private network detail",
                  );
                }
                Object.assign(grade, payload, { updated_at: tick() });
                storedWrites++;
                if (outcome === "committed_transport") {
                  throw new Error(
                    "lost acknowledgement",
                  );
                }
              } else Object.assign(grade, payload, { updated_at: tick() });
            }
            const matched = grade &&
              Object.entries(neqs).every(([k, v]) => grade![k] !== v);
            return {
              data: matched ? structuredClone(grade) : null,
              error: null,
              count: 1,
            };
          }
          const row = rows[table] as Record<string, unknown> | undefined;
          if (table === "attempts" && action === "update") {
            if (!row || Object.entries(eqs).some(([k, v]) => row[k] !== v)) return { data: null, error: null };
            const outcome = attemptOutcomes.shift() ?? "stored";
            if (outcome === "transport") throw new Error("private transport detail");
            if (outcome === "error") return { data: null, error: { code: "XX000" } };
            if (outcome === "missing") return { data: null, error: null };
            Object.assign(row, payload);
          }
          return {
            data: single
              ? row ?? null
              : Array.isArray(row)
              ? row
              : row
              ? [row]
              : [],
            error: null,
            count: 1,
          };
        };
        const chain = {
          select: () => chain,
          eq: (k: string, v: unknown) => {
            eqs[k] = v;
            return chain;
          },
          neq: (k: string, v: unknown) => {
            neqs[k] = v;
            return chain;
          },
          in: () => chain,
          order: () => chain,
          limit: () => chain,
          insert: (p: Record<string, unknown>) => {
            action = "insert";
            payload = p;
            return chain;
          },
          update: (p: Record<string, unknown>) => {
            action = "update";
            payload = p;
            return chain;
          },
          maybeSingle: () => Promise.resolve(result(true)),
          then: (resolve: (v: unknown) => unknown) =>
            Promise.resolve(result(false)).then(resolve),
        };
        return chain;
      },
    }),
  };
  const post = (overrides: Record<string, unknown> = {}, userId = id(1)) =>
    handleEvaluateAttempt(
      new Request("http://localhost/evaluate-attempt", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          operation: "grade_initial_attempt",
          idempotency_key: "grade-store-key",
          attempt_id: id(2),
          response_version_id: id(3),
          ...overrides,
        }),
      }),
      {
        service: service as unknown as NonNullable<Deps["service"]>,
        requireProfile: (() =>
          Promise.resolve({
            user: { id: userId },
            profile: { role: "student" },
          })) as unknown as NonNullable<Deps["requireProfile"]>,
      },
    );
  async function withProvider<T>(fn: () => Promise<T>) {
    const originalFetch = globalThis.fetch;
    try {
      if (route === "llm") {
        globalThis.fetch = (input) => {
          assertEquals(input, "https://api.openai.com/v1/responses");
          modelCalls++;
          return Promise.resolve(Response.json({
            output_text: JSON.stringify({
              status: "graded",
              points_earned: 1,
              points_available: 1,
              confidence: "high",
              criteria: [{
                criterion_key: "c1",
                status: "earned",
                points_awarded: 1,
                evidence_quote: "A",
                decision_explanation: "Correct",
                minimum_fix: null,
              }],
              student_facing_summary: "Correct",
              highest_value_gap: null,
              predicted_improvement: null,
              uncertainty_reason: null,
            }),
            usage: { input_tokens: 1, output_tokens: 1 },
          }));
        };
      }
      return await fn();
    } finally {
      globalThis.fetch = originalFetch;
    }
  }
  return {
    post,
    withProvider,
    writes,
    attempt: () => rows.attempts as Record<string, unknown>,
    failAttemptWrite: (outcome: Outcome) => attemptOutcomes.push(outcome),
    row: () => grade!,
    modelCalls: () => modelCalls,
    storedWrites: () => storedWrites,
  };
}

for (const route of ["mcq", "shadow", "llm"] as const) {
  for (const outcome of ["error", "missing", "transport"] as const) {
    Deno.test(`${route} ${outcome}: no unsaved score; same key retries the write without grading again`, async () => {
      const f = gradeFixture(route, [outcome, "stored"]);
      await f.withProvider(async () => {
        const first = await f.post();
        assertEquals(first.status, 500);
        assertEquals(await first.json(), {
          error: "grade_store_failed",
          retryable: true,
        });
        assertEquals(f.row().status, "failed");
        assertEquals(
          f.writes.some((w) => w.startsWith("attempts:update:")),
          false,
        );
        const retry = await f.post();
        assertEquals(retry.status, 200);
        const body = await retry.json();
        assertEquals(body.status, route === "shadow" ? "uncertain" : "graded");
        assertEquals(f.attempt().status, body.status);
        assertEquals(f.attempt().score_points, body.result.points_earned);
        assertEquals(f.attempt().score_possible, body.result.points_available);
        assertEquals(f.attempt().result_summary, body.result.feedback_preview);
        assertEquals(Object.hasOwn(body.result, "raw_model_response"), false);
        assertEquals(Object.hasOwn(body.result, "shadow_result"), false);
        assertEquals((await f.post()).status, 200);
        assertEquals(f.modelCalls(), route === "llm" ? 1 : 0);
        assertEquals(f.storedWrites(), 1);
      });
    });
  }
  Deno.test(`${route} acknowledged store retains normal success`, async () => {
    const f = gradeFixture(route, ["stored"]);
    await f.withProvider(async () => {
      const res = await f.post();
      assertEquals(res.status, route === "shadow" ? 202 : 200);
      assertEquals(
        (await res.json()).status,
        route === "shadow" ? "uncertain" : "graded",
      );
    });
  });
  Deno.test(`${route} concurrent recovery commits once and returns the stored result to both callers`, async () => {
    const f = gradeFixture(route, ["error", "stored"]);
    await f.withProvider(async () => {
      assertEquals((await f.post()).status, 500);
      const results = await Promise.all([f.post(), f.post()]);
      assertEquals(results.map((r) => r.status), [200, 200]);
      assertEquals(await results[0].json(), await results[1].json());
      assertEquals(f.storedWrites(), 1);
      assertEquals(f.modelCalls(), route === "llm" ? 1 : 0);
    });
  });
  Deno.test(`${route} lost successful-store acknowledgement never downgrades the committed grade`, async () => {
    const f = gradeFixture(route, ["committed_transport"]);
    await f.withProvider(async () => {
      const first = await f.post();
      assertEquals(first.status, 500);
      assertEquals(await first.json(), {
        error: "grade_store_failed",
        retryable: false,
        reconciliation_required: true,
      });
      assertEquals(f.row().status, route === "shadow" ? "uncertain" : "graded");
      assertEquals((await f.post()).status, 200);
      assertEquals(f.storedWrites(), 1);
      assertEquals(f.modelCalls(), route === "llm" ? 1 : 0);
    });
  });
}
for (const outcome of ["error", "transport", "missing"] as const) {
  Deno.test(`recovered attempt truth ${outcome} is surfaced and retried without regrading`, async () => {
    const f = gradeFixture("llm", ["error", "stored"]);
    await f.withProvider(async () => {
      assertEquals((await f.post()).status, 500);
      f.failAttemptWrite(outcome);
      const retry = await f.post();
      assertEquals(retry.status, 503);
      assertEquals(await retry.json(), { error: "attempt_grade_store_failed", retryable: true });
      assertEquals(f.row().status, "graded");
      assertEquals(f.attempt().status, "submitted");
      assertEquals((await f.post()).status, 200);
      assertEquals(f.attempt().status, "graded");
      assertEquals(f.modelCalls(), 1);
      assertEquals(f.storedWrites(), 1);
    });
  });
}
Deno.test("recovery does not overwrite a finalized attempt truth row", async () => {
  const f = gradeFixture("mcq", ["error", "stored"]);
  assertEquals((await f.post()).status, 500);
  f.attempt().status = "graded";
  f.attempt().score_points = 99;
  assertEquals((await f.post()).status, 200);
  assertEquals(f.attempt().score_points, 99);
});
Deno.test("failed checkpoint cannot leave processing replays at 202 indefinitely", async () => {
  const f = gradeFixture("llm", ["error"], true);
  await f.withProvider(async () => {
    const first = await f.post();
    assertEquals(first.status, 500);
    assertEquals(await first.json(), {
      error: "grade_store_failed",
      retryable: false,
      reconciliation_required: true,
    });
    assertEquals((await f.post()).status, 202);
    f.row().updated_at = "2000-01-01T00:00:00Z";
    const stale = await f.post();
    assertEquals(stale.status, 503);
    assertEquals(await stale.json(), {
      error: "grading_reconciliation_required",
      reconciliation_required: true,
    });
    assertEquals(f.modelCalls(), 1);
  });
});
Deno.test("repeated failed recovery stays retryable; a changed body conflicts and corrupt checkpoints fail closed", async () => {
  const f = gradeFixture("mcq", ["error", "error", "stored"]);
  await f.withProvider(async () => {
    assertEquals((await f.post()).status, 500);
    assertEquals(
      (await f.post({}, "30000000-0000-4000-8000-999999999999")).status,
      403,
    );
    const changed = await f.post({ assistance_condition: "supported" });
    assertEquals(changed.status, 409);
    assertEquals((await changed.json()).error, "idempotency_conflict");
    const second = await f.post();
    assertEquals(second.status, 500);
    assertEquals(await second.json(), {
      error: "grade_store_failed",
      retryable: true,
    });
    const checkpoint = f.row().raw_model_response as {
      payload: Record<string, unknown>;
    };
    checkpoint.payload.request_id = "other-key";
    assertEquals((await f.post()).status, 503);
    delete checkpoint.payload.request_id;
    assertEquals((await f.post()).status, 200);
  });
});

Deno.test("evaluate-attempt rejects an unsubmitted response before loading answer-key tables", async () => {
  const tablesQueried: string[] = [];
  const ids = {
    user: "10000000-0000-4000-8000-000000000001",
    attempt: "10000000-0000-4000-8000-000000000002",
    response: "10000000-0000-4000-8000-000000000003",
    content: "10000000-0000-4000-8000-000000000004",
    pack: "10000000-0000-4000-8000-000000000005",
  };
  const rows: Record<string, unknown> = {
    prompt_versions: { id: crypto.randomUUID(), status: "published" },
    attempts: {
      id: ids.attempt,
      user_id: ids.user,
      exam_pack_version_id: ids.pack,
      content_item_version_id: ids.content,
      attempt_mode: "mcq",
      status: "draft",
    },
    response_versions: {
      id: ids.response,
      attempt_id: ids.attempt,
      response_parts: { selected_choice_key: "A" },
      is_submitted: false,
    },
  };
  const service = {
    schema: () => ({
      from: (table: string) => {
        tablesQueried.push(table);
        const chain = {
          select: () => chain,
          eq: () => chain,
          maybeSingle: () =>
            Promise.resolve({ data: rows[table] ?? null, error: null }),
        };
        return chain;
      },
    }),
  };
  const req = new Request("http://localhost/evaluate-attempt", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({
      operation: "grade_initial_attempt",
      idempotency_key: crypto.randomUUID(),
      attempt_id: ids.attempt,
      response_version_id: ids.response,
    }),
  });
  const res = await handleEvaluateAttempt(req, {
    // deno-lint-ignore no-explicit-any
    service: service as any,
    requireProfile: (() =>
      Promise.resolve({
        user: { id: ids.user },
        profile: { user_id: ids.user, role: "student" },
      })) as unknown as NonNullable<Deps["requireProfile"]>,
  });

  assertEquals(res.status, 409);
  assertEquals((await res.json()).error, "response_not_submitted");
  assertEquals(tablesQueried, [
    "prompt_versions",
    "attempts",
    "response_versions",
  ]);
});

async function runOpenHandExclusionCase(exclusionRowCount: number) {
  const tablesQueried: string[] = [];
  const ids = {
    user: "11000000-0000-4000-8000-000000000001",
    attempt: "11000000-0000-4000-8000-000000000002",
    response: "11000000-0000-4000-8000-000000000003",
    content: "11000000-0000-4000-8000-000000000004",
    pack: "11000000-0000-4000-8000-000000000005",
    item: "11000000-0000-4000-8000-000000000006",
  };
  const rows: Record<string, unknown> = {
    prompt_versions: { id: crypto.randomUUID(), status: "published" },
    attempts: {
      id: ids.attempt,
      user_id: ids.user,
      exam_pack_version_id: ids.pack,
      content_item_version_id: ids.content,
      attempt_mode: "mcq",
      status: "submitted",
    },
    response_versions: {
      id: ids.response,
      attempt_id: ids.attempt,
      response_parts: { selected_choice_key: "A" },
      is_submitted: true,
    },
    // DECISION-0086: the version is resolved to its item, and the exclusion is
    // keyed on the item, so republishing cannot restore scorability.
    content_item_versions: {
      content_item_id: ids.item,
    },
  };
  // One row per viewed version of the item (the table's key is
  // user_id + content_item_version_id).
  const exclusionRows = Array.from(
    { length: exclusionRowCount },
    () => ({ content_item_id: ids.item }),
  );
  const service = {
    schema: () => ({
      from: (table: string) => {
        tablesQueried.push(table);
        const chain = {
          select: () => chain,
          eq: () => chain,
          // Like PostgREST: limit(1) returns at most one row.
          limit: (n: number) =>
            Promise.resolve({ data: exclusionRows.slice(0, n), error: null }),
          maybeSingle: () =>
            Promise.resolve({ data: rows[table] ?? null, error: null }),
        };
        return chain;
      },
    }),
  };
  const req = new Request("http://localhost/evaluate-attempt", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({
      operation: "grade_initial_attempt",
      idempotency_key: crypto.randomUUID(),
      attempt_id: ids.attempt,
      response_version_id: ids.response,
    }),
  });
  const res = await handleEvaluateAttempt(req, {
    // deno-lint-ignore no-explicit-any
    service: service as any,
    requireProfile: (() =>
      Promise.resolve({
        user: { id: ids.user },
        profile: { user_id: ids.user, role: "student" },
      })) as unknown as NonNullable<Deps["requireProfile"]>,
  });
  return { res, tablesQueried };
}

Deno.test("evaluate-attempt rejects an Open Hand item before loading answer-key tables", async () => {
  const { res, tablesQueried } = await runOpenHandExclusionCase(1);

  assertEquals(res.status, 409);
  assertEquals((await res.json()).error, "open_hand_item_not_scorable");
  assertEquals(tablesQueried, [
    "prompt_versions",
    "attempts",
    "response_versions",
    "content_item_versions",
    "open_hand_scoring_exclusions",
  ]);
});

// TASK-0051 QA F2: two viewed versions of one item used to make .maybeSingle()
// fail, which returned a permanent 500 instead of 409.
Deno.test("evaluate-attempt rejects an Open Hand item with exclusions for two versions", async () => {
  const { res, tablesQueried } = await runOpenHandExclusionCase(2);

  assertEquals(res.status, 409);
  assertEquals((await res.json()).error, "open_hand_item_not_scorable");
  assertEquals(tablesQueried.at(-1), "open_hand_scoring_exclusions");
});

/* -------------------------------------------------------------------------- */
/* FF-11: qa_no_persist must not refuse an item that already has a canonical  */
/* -------------------------------------------------------------------------- */

Deno.test("qa_no_persist proceeds past a present canonical_answer_1 instead of refusing it", async () => {
  const versionId = "20000000-0000-4000-8000-000000000001";
  const itemId = "20000000-0000-4000-8000-000000000002";
  const packVersionId = "20000000-0000-4000-8000-000000000003";

  const singleByTable: Record<string, unknown> = {
    content_item_versions: {
      id: versionId,
      content_item_id: itemId,
      version_num: 1,
      stem: "stem",
      stimulus: null,
      prompt_json: null,
      rubric_type: "criterion_llm",
      evaluator_strategy: "llm_text",
      status: "published",
      // The item already has a canonical -- pre-fix this refused the
      // request outright with canonical_answer_already_present. It must
      // now proceed to the next gate instead.
      canonical_answer_1: "an already-written canonical",
      canonical_answer_2: null,
      created_at: "2026-01-01T00:00:00Z",
    },
    content_items: {
      id: itemId,
      exam_pack_version_id: packVersionId,
      content_key: "APBIO-FRQ-TEST-001",
      item_type: "frq",
      // Deliberately not "published" so the request trips the *next* real
      // gate (content_not_published_frq) rather than reaching a live model
      // call -- proof the canonical guard did not fire, without needing to
      // stub the grader.
      status: "draft",
    },
  };
  const listByTable: Record<string, unknown[]> = {
    frq_criteria: [{
      criterion_key: "a",
      learner_facing_text: "Explain the thing.",
      points_possible: 1,
      evidence_requirements: "",
      minimum_fix: "",
      accepted_variants: [],
    }],
  };
  // deno-lint-ignore no-explicit-any
  function tableBuilder(table: string): any {
    const b: Record<string, unknown> = {};
    const chain = () => b;
    b.select = chain;
    b.eq = chain;
    b.order = chain;
    b.limit = chain;
    b.maybeSingle = () =>
      Promise.resolve({ data: singleByTable[table] ?? null, error: null });
    b.then = (res: (v: unknown) => unknown, rej?: (e: unknown) => unknown) =>
      Promise.resolve({ data: listByTable[table] ?? [], error: null }).then(
        res,
        rej,
      );
    return b;
  }
  const service = {
    schema: () => ({
      from: (table: string) => tableBuilder(table),
      rpc: (name: string) =>
        name === "verify_qa_grader_token"
          ? Promise.resolve({ data: true, error: null })
          : Promise.resolve({ data: null, error: null }),
    }),
  };

  const req = new Request("http://localhost/evaluate-attempt", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "x-qa-grader-token": "test-token",
    },
    body: JSON.stringify({
      qa_no_persist: true,
      content_item_version_id: versionId,
      answer_text: "a candidate answer",
    }),
  });
  const res = await handleEvaluateAttempt(req, {
    // deno-lint-ignore no-explicit-any
    service: service as any,
  });

  assertEquals(res.status, 409);
  const json = await res.json();
  assertEquals(json.error, "content_not_published_frq");
});

// --- MCQ wrong-answer feedback -------------------------------------------
// These pin the pedagogy, not the prose. What must hold is that a wrong answer
// is told WHERE it went wrong (the chosen distractor's authored rationale) and
// WHAT the question is for (the skill and unit), and is then left holding a
// question rather than a correction — that the shape VARIES so a session of
// twenty questions does not read like one template twenty times, and that each
// ingredient degrades on its own when the data is missing, without ever naming
// the correct choice.
//
// Seeds are chosen to pin one variant each; variantIndex is a pure hash, so
// these stay stable across deploys.
const STATS_SKILL =
  "Calculate summary statistics, relative positions, predicted responses";
const SEED_TELL_FIRST = "seed-3";
const SEED_UNIT_ASK = "seed-0";
const SEED_POINTER_FIRST = "seed-1";
const SEED_UNIT_SKILL = "seed-2";

Deno.test("MCQ feedback tells, points and then asks", () => {
  const { summary, actionableFix, redirect } = composeMcqFeedback({
    earned: false,
    rationale: "Reported a standard deviation instead of the mean",
    skillLabels: [STATS_SKILL],
    unitNumber: 2,
    variantSeed: SEED_TELL_FIRST,
  });
  assertEquals(
    summary,
    "Not quite. This question is testing how to calculate summary statistics, " +
      "relative positions, predicted responses. Look again at the choice you " +
      "picked: Reported a standard deviation instead of the mean. What would " +
      "you need to work out to answer the question as asked?",
  );
  // The diagnosis, not a restatement of "pick the right answer".
  assertEquals(
    actionableFix,
    "Reported a standard deviation instead of the mean",
  );
  assertEquals(redirect.endsWith("?"), true);
});

Deno.test("MCQ feedback can orient by unit and ask in the keeping-in-mind voice", () => {
  const { summary } = composeMcqFeedback({
    earned: false,
    rationale: "Reported the median instead of the mean",
    skillLabels: [STATS_SKILL],
    unitNumber: 2,
    variantSeed: SEED_UNIT_ASK,
  });
  assertEquals(
    summary,
    "Not quite. This is Unit 2 material. Look again at the choice you picked: " +
      "Reported the median instead of the mean. Keeping how to calculate " +
      "summary statistics, relative positions, predicted responses in mind, " +
      "how would you answer it now?",
  );
});

Deno.test("MCQ feedback varies its shape across items in a session", () => {
  const shapes = new Set(
    [SEED_TELL_FIRST, SEED_UNIT_ASK, SEED_POINTER_FIRST, SEED_UNIT_SKILL].map((
      variantSeed,
    ) =>
      composeMcqFeedback({
        earned: false,
        rationale: "Swapped quartile and median positions",
        skillLabels: [STATS_SKILL],
        unitNumber: 1,
        variantSeed,
      }).summary
    ),
  );
  // Four distinct shapes, so the feedback does not read as one template.
  assertEquals(shapes.size, 4);
});

Deno.test("MCQ feedback is stable for a given item and chosen distractor", () => {
  const once = composeMcqFeedback({
    earned: false,
    rationale: "Drew a whisker to an outlier",
    skillLabels: [STATS_SKILL],
    unitNumber: 1,
    variantSeed: "item-a:D",
  });
  const twice = composeMcqFeedback({
    earned: false,
    rationale: "Drew a whisker to an outlier",
    skillLabels: [STATS_SKILL],
    unitNumber: 1,
    variantSeed: "item-a:D",
  });
  // Re-reading the same result must not reword it.
  assertEquals(once.summary, twice.summary);
});

Deno.test("MCQ feedback keeps a rationale that is already a full sentence intact", () => {
  const { summary } = composeMcqFeedback({
    earned: false,
    rationale: "The pump works to maintain — not equalize — these gradients.",
    skillLabels: [],
    unitNumber: null,
    variantSeed: SEED_TELL_FIRST,
  });
  // No doubled full stop, and no skill sentence when the item is unlabelled.
  assertEquals(summary.includes("gradients.."), false);
  assertEquals(summary.includes("This question is testing"), false);
  assertEquals(summary.includes("The pump works to maintain"), true);
});

Deno.test("MCQ feedback drops the unit cue when the item spans no single unit", () => {
  const { summary } = composeMcqFeedback({
    earned: false,
    rationale: "Used the wrong statistic for a comparison",
    skillLabels: [STATS_SKILL],
    unitNumber: null,
    variantSeed: SEED_UNIT_ASK,
  });
  assertEquals(summary.includes("This is Unit"), false);
  assertEquals(summary.endsWith("?"), true);
});

Deno.test("MCQ feedback degrades to a question when the distractor has no rationale", () => {
  const { summary } = composeMcqFeedback({
    earned: false,
    rationale: null,
    skillLabels: [STATS_SKILL],
    unitNumber: 2,
    variantSeed: SEED_TELL_FIRST,
  });
  assertEquals(summary.includes("Look again at the choice you picked"), false);
  assertEquals(summary.includes("how to calculate summary statistics"), true);
  assertEquals(summary.endsWith("?"), true);
});

Deno.test("MCQ feedback falls back to a colon form for a noun-initial skill label", () => {
  // No CED label registered today is noun-initial, but a later subject's grid
  // could be. The bend to "how to ..." must not produce "testing Models and
  // representations".
  const { summary } = composeMcqFeedback({
    earned: false,
    rationale: null,
    skillLabels: ["Models and representations"],
    unitNumber: null,
    variantSeed: SEED_TELL_FIRST,
  });
  assertEquals(
    summary.includes(
      "The skill this question is testing: Models and representations.",
    ),
    true,
  );
  assertEquals(summary.includes("how to Models"), false);
});

Deno.test("no variant emits the retired placeholder or names the answer", () => {
  for (const labels of [[], [STATS_SKILL], ["Models and representations"]]) {
    for (const rationale of [null, "Reported the median instead of the mean"]) {
      for (const unitNumber of [null, 2]) {
        for (let seed = 0; seed < 24; seed++) {
          const { summary, actionableFix, redirect } = composeMcqFeedback({
            earned: false,
            rationale,
            skillLabels: labels,
            unitNumber,
            variantSeed: `seed-${seed}`,
          });
          for (const text of [summary, actionableFix, redirect]) {
            assertEquals(text.includes("published correct answer"), false);
          }
          assertEquals(summary.startsWith("Not quite."), true);
          // Every shape, on every degradation path, still ends on a question.
          assertEquals(summary.endsWith("?"), true);
          // No empty fragment ever collapses into a double space.
          assertEquals(summary.includes("  "), false);
        }
      }
    }
  }
});

Deno.test("MCQ feedback stays a bare acknowledgement when the answer is right", () => {
  const { summary } = composeMcqFeedback({
    earned: true,
    rationale: "Reported a standard deviation instead of the mean",
    skillLabels: [STATS_SKILL],
    unitNumber: 2,
    variantSeed: SEED_UNIT_ASK,
  });
  assertEquals(summary, "Correct.");
});
