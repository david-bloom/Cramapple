// TASK-0079 S0: golden characterization tests for evaluate-attempt.
//
// Every scenario drives handleEvaluateAttempt through a recording mock of the
// Supabase client and of the OpenAI fetch, then compares the full trace (every
// table/RPC call with its filters and payload, every provider request, the
// response status and body) against golden_fixtures.json. The trace is the
// behaviour contract for the refactor: a slice that changes any of it fails.
//
// Regenerate (only when a behaviour change is intended and reviewed):
//   UPDATE_GOLDEN=1 deno test -A supabase/functions/evaluate-attempt/golden_test.ts
import "./_test_setup.ts";
import { assertEquals } from "jsr:@std/assert@1";
import { handleEvaluateAttempt } from "./index.ts";
import golden from "./golden_fixtures.json" with { type: "json" };

type Deps = NonNullable<Parameters<typeof handleEvaluateAttempt>[1]>;
type Row = Record<string, unknown>;
type Call = {
  schema: string;
  target: string;
  action: string;
  payload?: unknown;
  filters: Array<[string, string, unknown]>;
  modifiers: string[];
};
type Reply = { data: unknown; error: unknown; count?: number };
type Responder = (call: Call) => Reply | undefined;

const id = (n: number) =>
  `40000000-0000-4000-8000-${String(n).padStart(12, "0")}`;
const USER = id(1);
const ATTEMPT = id(2);
const RESPONSE = id(3);
const VERSION = id(4);
const PACK_VERSION = id(5);
const ITEM = id(6);
const PACK = id(7);

function recordingService(respond: Responder) {
  const calls: Call[] = [];
  const reply = (call: Call): Reply =>
    respond(call) ?? { data: null, error: null };
  const service = {
    schema: (schema: string) => ({
      rpc: (name: string, args: unknown) => {
        const call: Call = {
          schema,
          target: `rpc:${name}`,
          action: "rpc",
          payload: args,
          filters: [],
          modifiers: [],
        };
        calls.push(call);
        return Promise.resolve(reply(call));
      },
      from: (table: string) => {
        const call: Call = {
          schema,
          target: table,
          action: "select",
          filters: [],
          modifiers: [],
        };
        let recorded = false;
        const finish = (single: boolean) => {
          if (!recorded) {
            calls.push(call);
            recorded = true;
          }
          if (single) call.modifiers.push("maybeSingle");
          return reply(call);
        };
        const filter = (op: string) => (column: string, value: unknown) => {
          call.filters.push([op, column, value]);
          return chain;
        };
        const write = (action: string) => (payload: unknown, opts?: unknown) => {
          call.action = action;
          call.payload = payload;
          if (opts) call.modifiers.push(`${action}:${JSON.stringify(opts)}`);
          return chain;
        };
        const chain: Record<string, unknown> = {
          select: (columns?: string, opts?: unknown) => {
            call.modifiers.push(
              `select:${columns ?? "*"}${opts ? JSON.stringify(opts) : ""}`,
            );
            return chain;
          },
          eq: filter("eq"),
          neq: filter("neq"),
          in: filter("in"),
          gt: filter("gt"),
          gte: filter("gte"),
          lt: filter("lt"),
          lte: filter("lte"),
          is: filter("is"),
          not: (column: string, op: string, value: unknown) => {
            call.filters.push([`not.${op}`, column, value]);
            return chain;
          },
          filter: (column: string, op: string, value: unknown) => {
            call.filters.push([`filter.${op}`, column, value]);
            return chain;
          },
          order: (column: string, opts?: unknown) => {
            call.modifiers.push(`order:${column}:${JSON.stringify(opts ?? {})}`);
            return chain;
          },
          limit: (n: number) => {
            call.modifiers.push(`limit:${n}`);
            return chain;
          },
          insert: write("insert"),
          update: write("update"),
          upsert: write("upsert"),
          delete: () => {
            call.action = "delete";
            return chain;
          },
          maybeSingle: () => Promise.resolve(finish(true)),
          single: () => Promise.resolve(finish(true)),
          then: (resolve: (v: unknown) => unknown, reject?: (e: unknown) => unknown) =>
            Promise.resolve(finish(false)).then(resolve, reject),
        };
        return chain;
      },
    }),
  };
  return { service, calls };
}

const ISO = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z$/;
const VOLATILE_KEYS = new Set(["stage_timings", "latency_ms", "elapsedMs"]);

function normalize(value: unknown): unknown {
  if (typeof value === "string") return ISO.test(value) ? "<iso>" : value;
  if (Array.isArray(value)) return value.map(normalize);
  if (value && typeof value === "object") {
    return Object.fromEntries(
      Object.entries(value as Row).map(([key, item]) => [
        key,
        VOLATILE_KEYS.has(key) && item !== null ? "<volatile>" : normalize(item),
      ]),
    );
  }
  return value;
}

async function sha256(text: string) {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(text),
  );
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

type Scenario = {
  name: string;
  body?: Row;
  headers?: Record<string, string>;
  role?: string;
  tables: Record<string, unknown>;
  rpc?: Record<string, Reply>;
  model?: (requestBody: Row) => Row;
};

const llmGrade = (keys: string[], earned = true) => () => ({
  output_text: JSON.stringify({
    status: "graded",
    points_earned: earned ? keys.length : 0,
    points_available: keys.length,
    confidence: "high",
    criteria: keys.map((key) => ({
      criterion_key: key,
      status: earned ? "earned" : "not_yet_earned",
      points_awarded: earned ? 1 : 0,
      evidence_quote: earned ? "The cell divides" : null,
      decision_explanation: earned ? "States the idea." : "Missing the idea.",
      minimum_fix: earned ? null : "State the idea.",
    })),
    student_facing_summary: "Model summary",
    highest_value_gap: null,
    predicted_improvement: null,
    uncertainty_reason: null,
  }),
  usage: {
    input_tokens: 120,
    output_tokens: 40,
    input_tokens_details: { cached_tokens: 0 },
  },
});

function baseTables(opts: {
  itemType: "mcq" | "frq";
  rubricType?: string | null;
  evaluatorStrategy?: string | null;
  contentKey?: string;
  responseText?: string;
  responseParts?: unknown;
  criteria?: Row[];
}): Record<string, unknown> {
  return {
    prompt_versions: { id: id(20), status: "published" },
    attempts: {
      id: ATTEMPT,
      user_id: USER,
      learning_session_id: null,
      exam_pack_version_id: PACK_VERSION,
      content_item_version_id: VERSION,
      artifact_version_id: null,
      attempt_mode: opts.itemType,
      status: "submitted",
      assistance_state: "independent",
      pre_submit_hint_count: 0,
      started_at: "2026-11-01T10:00:00.000Z",
      submitted_at: "2026-11-01T10:05:00.000Z",
    },
    response_versions: {
      id: RESPONSE,
      attempt_id: ATTEMPT,
      response_text: opts.responseText ?? "The cell divides",
      response_parts: opts.responseParts ?? {},
      version_number: 1,
      is_submitted: true,
    },
    content_item_versions: {
      id: VERSION,
      content_item_id: ITEM,
      version_num: 1,
      stem: "Explain the process.",
      stimulus: null,
      prompt_json: {},
      rubric_type: opts.rubricType === undefined
        ? (opts.itemType === "mcq" ? "mcq" : "discrete_text")
        : opts.rubricType,
      evaluator_strategy: opts.evaluatorStrategy ?? null,
      status: "published",
    },
    open_hand_scoring_exclusions: [],
    content_items: {
      id: ITEM,
      exam_pack_version_id: PACK_VERSION,
      content_key: opts.contentKey ?? "GOLDEN-ITEM",
      item_type: opts.itemType,
      title: "Golden item",
      status: "published",
      response_policy: null,
    },
    exam_pack_versions: {
      id: PACK_VERSION,
      exam_pack_id: PACK,
      status: "published",
    },
    exam_packs: {
      id: PACK,
      exam_code: "ap_biology",
      exam_name: "AP Biology",
      subject_id: id(8),
    },
    frq_criteria: opts.criteria ??
      (opts.itemType === "frq"
        ? [{
          criterion_key: "c1",
          learner_facing_text: "States the idea",
          points_possible: 1,
          evidence_requirements: null,
          minimum_fix: "State the idea.",
          accepted_variants: [],
        }]
        : []),
    mcq_choices: [
      {
        choice_key: "A",
        choice_text: "Mitosis",
        is_correct: true,
        rationale: "Right.",
      },
      {
        choice_key: "B",
        choice_text: "Meiosis",
        is_correct: false,
        rationale: "Confused the division that halves chromosome number",
      },
    ],
    // Tagged so the Course Mode mastery write runs and its inputs reach the trace.
    content_item_cells: [{
      skill_code: "2.A",
      topic_code: "4.1",
      taxonomy_source_version: "ced-2025",
    }],
    subjects: { subject_key: "ap_biology" },
    taxonomy_source_versions: { subject_key: "ap_biology" },
    student_cell_state: null,
    content_item_checks: [],
    taxonomy_skills: [],
    taxonomy_topics: [],
    grading_results: null,
    model_usage_ledger: null,
    attempt_criterion_results: null,
  };
}

const scenarios: Scenario[] = [
  {
    name: "mcq correct",
    body: {},
    tables: {
      ...baseTables({
        itemType: "mcq",
        responseText: "A",
        responseParts: { selected_choice_key: "A" },
      }),
    },
  },
  {
    name: "mcq wrong with skill and unit",
    tables: {
      ...baseTables({
        itemType: "mcq",
        responseText: "B",
        responseParts: { selected_choice_key: "B" },
      }),
      taxonomy_skills: [{
        skill_code: "2.A",
        label: "Explain biological concepts.",
      }],
      taxonomy_topics: [{ unit_number: 4 }],
    },
  },
  {
    name: "llm arm b graded",
    tables: baseTables({ itemType: "frq" }),
    model: llmGrade(["c1"]),
  },
  {
    name: "llm arm b provider failure",
    tables: baseTables({ itemType: "frq" }),
    model: () => ({ broken: true }),
  },
  {
    name: "llm budget capped",
    tables: baseTables({ itemType: "frq" }),
    rpc: { reserve_model_usage: { data: null, error: { message: "cap" } } },
    model: llmGrade(["c1"]),
  },
  {
    name: "llm statistics scoped override",
    tables: baseTables({
      itemType: "frq",
      contentKey: "APSTATS-SFRQ-001",
      responseText: "No numbers here",
      criteria: ["a1", "b1", "c1"].map((key) => ({
        criterion_key: key,
        learner_facing_text: `Criterion ${key}`,
        points_possible: 1,
        evidence_requirements: null,
        minimum_fix: `Fix ${key}.`,
        accepted_variants: [],
      })),
    }),
    model: llmGrade(["a1", "b1", "c1"]),
  },
  {
    name: "llm statistics unscoped fallback",
    tables: baseTables({
      itemType: "frq",
      contentKey: "APSTATS-SFRQ-011",
      responseText: "No numbers here",
    }),
    model: llmGrade(["c1"]),
  },
  {
    name: "symbolic ecf without a verifier item",
    tables: baseTables({ itemType: "frq", rubricType: "structured_formula" }),
  },
  {
    name: "symbolic ecf with parts",
    tables: baseTables({
      itemType: "frq",
      rubricType: "structured_formula",
      contentKey: "APSTAT-MOD6-H001",
      responseText: "SE 1.94, t -2.06",
      responseParts: {
        SE_diff: {
          student_answer: 1.94079,
          stated_formula: "sqrt(s1**2/n1 + s2**2/n2)",
          shown_subs: { s1: 8, n1: 30, s2: 7, n2: 30 },
        },
        t_stat: {
          student_answer: -2.06104,
          stated_formula: "(m1 - m2)/SEd",
          shown_subs: { m1: 72, m2: 76 },
        },
      },
    }),
  },
  {
    name: "data driven graded",
    tables: {
      ...baseTables({
        itemType: "frq",
        rubricType: null,
        evaluatorStrategy: "data_driven_deterministic",
        responseText: "0.62",
        criteria: [],
      }),
      content_item_checks: [{
        criterion_key: "value",
        checks: [{ kind: "numeric", value: 0.62, tol: 0.01 }],
      }],
    },
  },
  {
    name: "data driven abstain on uncovered criterion",
    tables: {
      ...baseTables({
        itemType: "frq",
        rubricType: null,
        evaluatorStrategy: "data_driven_deterministic",
        responseText: "0.62",
      }),
      content_item_checks: [{
        criterion_key: "value",
        checks: [{ kind: "numeric", value: 0.62, tol: 0.01 }],
      }],
    },
  },
  {
    name: "shadow review",
    tables: baseTables({ itemType: "frq", rubricType: "spatial" }),
  },
  {
    name: "replay of a stored grade",
    tables: {
      ...baseTables({ itemType: "frq" }),
      grading_results: "replay",
    },
  },
  {
    name: "qa no persist arm b",
    body: {
      qa_no_persist: true,
      content_item_version_id: VERSION,
      answer_text: "The cell divides",
    },
    headers: { "x-qa-grader-token": "token" },
    tables: baseTables({ itemType: "frq" }),
    rpc: { verify_qa_grader_token: { data: true, error: null } },
    model: llmGrade(["c1"]),
  },
];

async function runScenario(scenario: Scenario) {
  let storedGrade: Row | null = null;
  const respond: Responder = (call) => {
    if (call.action === "rpc") {
      const name = call.target.slice(4);
      if (scenario.rpc && name in scenario.rpc) return scenario.rpc[name];
      if (name === "reserve_model_usage") {
        return { data: { id: id(30) }, error: null };
      }
      return { data: null, error: null };
    }
    if (call.target === "grading_results") {
      if (scenario.tables.grading_results === "replay" && !storedGrade) {
        // A completed grade already stored under this request id. The hash is
        // taken from the first lookup's request so the replay is a true match.
        return undefined;
      }
      if (call.action === "insert") {
        storedGrade = {
          ...(call.payload as Row),
          id: id(40),
          created_at: "2026-11-01T10:06:00.000Z",
          updated_at: "2026-11-01T10:06:00.000Z",
        };
        return { data: structuredClone(storedGrade), error: null };
      }
      if (call.action === "update") {
        if (storedGrade) Object.assign(storedGrade, call.payload as Row);
        return { data: storedGrade ? structuredClone(storedGrade) : null, error: null };
      }
      if (call.modifiers.some((m) => m.startsWith("select:id{"))) {
        return { data: null, error: null, count: 0 };
      }
      const byRequest = call.filters.some(([, column]) => column === "request_id");
      return { data: byRequest ? null : null, error: null };
    }
    const row = scenario.tables[call.target];
    if (call.action !== "select") {
      return { data: Array.isArray(row) ? row : row ?? null, error: null };
    }
    const single = call.modifiers.includes("maybeSingle");
    if (single) {
      return { data: Array.isArray(row) ? row[0] ?? null : row ?? null, error: null };
    }
    return {
      data: Array.isArray(row) ? row : row ? [row] : [],
      error: null,
      count: Array.isArray(row) ? row.length : row ? 1 : 0,
    };
  };

  // The replay scenario pre-stores a graded row whose hash comes from a first,
  // identical request; run that first request with a recording mock it ignores.
  if (scenario.tables.grading_results === "replay") {
    const seed = recordingService((call) => {
      if (call.target === "grading_results" && call.action === "insert") {
        storedGrade = {
          ...(call.payload as Row),
          id: id(40),
          status: "graded",
          points_earned: 1,
          points_available: 1,
          confidence: "high",
          feedback_preview: "Stored summary",
          shadow_result: { private: true },
          raw_model_response: { private: true },
          created_at: "2026-11-01T10:06:00.000Z",
          updated_at: "2026-11-01T10:06:00.000Z",
        };
        return { data: null, error: { code: "seed_stop" } };
      }
      if (call.target === "grading_results") return { data: null, error: null };
      return respond(call);
    });
    await invoke(scenario, seed.service);
  }

  const recorder = recordingService((call) => {
    if (
      scenario.tables.grading_results === "replay" &&
      call.target === "grading_results" && call.action === "select"
    ) {
      return { data: structuredClone(storedGrade), error: null };
    }
    return respond(call);
  });
  const fetches: Array<{ url: string; body_sha256: string; body_bytes: number }> = [];
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async (input, init) => {
    const text = String(init?.body ?? "");
    fetches.push({
      url: String(input),
      body_sha256: await sha256(text),
      body_bytes: text.length,
    });
    const reply = scenario.model?.(JSON.parse(text)) ?? { error: "no model" };
    return Response.json(reply);
  };
  try {
    const response = await invoke(scenario, recorder.service);
    return normalize({
      status: response.status,
      body: await response.json(),
      calls: recorder.calls,
      fetches,
    });
  } finally {
    globalThis.fetch = originalFetch;
  }
}

function invoke(scenario: Scenario, service: unknown) {
  return handleEvaluateAttempt(
    new Request("http://localhost/evaluate-attempt", {
      method: "POST",
      headers: { "content-type": "application/json", ...scenario.headers },
      body: JSON.stringify(
        scenario.body?.qa_no_persist ? scenario.body : {
          operation: "grade_initial_attempt",
          idempotency_key: `golden:${scenario.name}`,
          attempt_id: ATTEMPT,
          response_version_id: RESPONSE,
          ...scenario.body,
        },
      ),
    }),
    {
      service: service as NonNullable<Deps["service"]>,
      requireProfile: (() =>
        Promise.resolve({
          user: { id: USER },
          profile: { role: scenario.role ?? "student" },
        })) as unknown as NonNullable<Deps["requireProfile"]>,
    },
  );
}

const fixtures = golden as Record<string, unknown>;
const updating = (() => {
  try {
    return Deno.env.get("UPDATE_GOLDEN") === "1";
  } catch {
    return false;
  }
})();
const regenerated: Record<string, unknown> = {};

for (const scenario of scenarios) {
  Deno.test(`golden: ${scenario.name}`, async () => {
    const trace = await runScenario(scenario);
    if (updating) {
      regenerated[scenario.name] = trace;
      return;
    }
    assertEquals(trace, fixtures[scenario.name]);
  });
}

if (updating) {
  Deno.test("golden: write fixtures", async () => {
    await Deno.writeTextFile(
      new URL("./golden_fixtures.json", import.meta.url),
      JSON.stringify(regenerated, null, 2) + "\n",
    );
  });
}
