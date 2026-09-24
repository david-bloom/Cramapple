import "./_test_setup.ts";
import { assertEquals } from "jsr:@std/assert@1";
import { handleEvaluateAttempt } from "./index.ts";

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
