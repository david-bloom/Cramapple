import "./_test_setup.ts";
import { assertEquals } from "jsr:@std/assert@1";
import { composeMcqFeedback, handleEvaluateAttempt } from "./index.ts";

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
    // deno-lint-ignore no-explicit-any
    requireProfile: (() =>
      Promise.resolve({
        user: { id: ids.user },
        profile: { user_id: ids.user, role: "student" },
      })) as any,
  });

  assertEquals(res.status, 409);
  assertEquals((await res.json()).error, "response_not_submitted");
  assertEquals(tablesQueried, [
    "prompt_versions",
    "attempts",
    "response_versions",
  ]);
});

Deno.test("evaluate-attempt rejects an Open Hand item before loading answer-key tables", async () => {
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
    open_hand_scoring_exclusions: {
      content_item_id: ids.item,
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
    // deno-lint-ignore no-explicit-any
    requireProfile: (() =>
      Promise.resolve({
        user: { id: ids.user },
        profile: { user_id: ids.user, role: "student" },
      })) as any,
  });

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
