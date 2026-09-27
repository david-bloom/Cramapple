// Handler tests for the student-session-items confirm-transfer branch
// (SESSION_ASSEMBLY §7.1). The security-critical logic — session ownership,
// exam-pack scoping of the source item, and the fail-closed rules (no same-cell
// item, or a same-cell candidate withheld by the media gate) — lives in the
// handler, so these drive `handleStudentSessionItems` directly with a synthetic
// Request and an in-memory fake of the service client. Same-cell / numeric-
// exclusion selection lives in the SQL RPC and is covered by
// supabase/tests/confirm_transfer_item_selector.integration.sql.

import "./_test_setup.ts";
import { assert, assertEquals, assertFalse } from "jsr:@std/assert@1";
import { handleStudentSessionItems } from "./index.ts";

/* -------------------------------------------------------------------------- */
/* Fake service client — models exactly the call chains the handler makes.    */
/* -------------------------------------------------------------------------- */

type Row = Record<string, unknown>;
type RpcCall = { schema: "app" | "public"; name: string; params: unknown };
type Spec = {
  session?: Row | null;
  sourceVersion?: Row | null;
  transferRows?: Row[];
  biologyRows?: Row[];
  transferError?: boolean;
  practiceRows?: Row[];
  criteria?: Row[];
  choices?: Row[];
  assets?: Row[];
  visuals?: Row[];
  rpcCalls?: RpcCall[];
  signFail?: boolean;
  // TASK-0047 Workstream E -- item_package_payload rows for the dual-read
  // adapter, keyed the same way content_item_versions actually returns them.
  packages?: Row[];
  // TASK-0047 Decision 17 follow-on -- resolved topic/cell identity rows.
  // Phase 1 (CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md) replaced
  // the two-source read this mock used to model (content_item_cells +
  // content_taxonomy_labels) with a single view,
  // app.content_item_topic_resolution, that already does the merge AND the
  // safety-critical assignment_status filter in SQL. This mock table stands
  // in for that view's OUTPUT -- the filter itself is verified separately,
  // against real data, by supabase/tests/
  // content_item_topic_resolution_status_gate.integration.sql, since a
  // mock can't exercise a SQL-level WHERE clause.
  topicResolution?: Row[];
};

// deno-lint-ignore no-explicit-any
function tableBuilder(single: any, list: any[]): any {
  const b: Record<string, unknown> = {};
  const chain = () => b;
  b.select = chain;
  b.eq = chain;
  b.in = chain;
  b.order = chain;
  b.maybeSingle = () => Promise.resolve({ data: single ?? null, error: null });
  // Awaiting the builder (…select().in().order()) resolves to the list result.
  b.then = (res: (v: unknown) => unknown, rej?: (e: unknown) => unknown) =>
    Promise.resolve({ data: list ?? [], error: null }).then(res, rej);
  return b;
}

function makeService(spec: Spec) {
  const singleByTable: Record<string, Row | null> = {
    learning_sessions: spec.session ?? null,
    content_item_versions: spec.sourceVersion ?? null,
  };
  const listByTable: Record<string, Row[]> = {
    frq_criteria: spec.criteria ?? [],
    mcq_choices: spec.choices ?? [],
    content_asset_metadata: spec.assets ?? [],
    content_visual_requirements: spec.visuals ?? [],
    // Same table as the confirm-transfer source-version lookup (singleByTable
    // above), but deliverRows queries it as a list (.select().in()) for the
    // dual-read adapter -- tableBuilder resolves .maybeSingle() and the
    // awaited list independently, so both call shapes are served correctly.
    content_item_versions: spec.packages ?? [],
    content_item_topic_resolution: spec.topicResolution ?? [],
  };
  const appSchema = {
    from: (t: string) =>
      tableBuilder(singleByTable[t] ?? null, listByTable[t] ?? []),
    rpc: (fn: string, params: unknown) => {
      spec.rpcCalls?.push({ schema: "app", name: fn, params });
      return Promise.resolve({
        data: fn === "select_confirm_transfer_item"
          ? (spec.transferRows ?? [])
          : fn === "select_biology_practice_items"
          ? (spec.biologyRows ?? [])
          : [],
        error: spec.transferError ? { message: "boom" } : null,
      });
    },
  };
  return {
    schema: (_name: string) => appSchema,
    // top-level rpc is the ordinary-path select_practice_frqs
    rpc: (fn: string, params: unknown) => {
      spec.rpcCalls?.push({ schema: "public", name: fn, params });
      return Promise.resolve({
        data: fn === "select_practice_frqs" ? (spec.practiceRows ?? []) : [],
        error: null,
      });
    },
    storage: {
      from: (_bucket: string) => ({
        // deno-lint-ignore no-explicit-any
        createSignedUrls: (paths: string[], _ttl: number): Promise<any> =>
          Promise.resolve(
            spec.signFail
              ? { data: null, error: { message: "sign_failed" } }
              : {
                data: paths.map((p) => ({
                  path: p,
                  signedUrl: `https://storage/${p}`,
                  error: null,
                })),
                error: null,
              },
          ),
      }),
    },
    // deno-lint-ignore no-explicit-any
  } as any;
}

const STUDENT = { user: { id: "u1" }, profile: { role: "student" } };
const SESSION_ID = "11111111-1111-4111-8111-111111111111";
const SOURCE_VERSION_ID = "22222222-2222-4222-8222-222222222222";
const ACTIVE_SESSION = {
  id: SESSION_ID,
  user_id: "u1",
  exam_pack_version_id: "epv1",
  practice_format: "mcq",
  status: "active",
  exam_pack_version: { exam_pack: { exam_code: "ap_statistics" } },
};

function post(body: unknown) {
  return new Request("https://x/functions/v1/student-session-items", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(body),
  });
}

// deno-lint-ignore no-explicit-any
async function call(spec: Spec, body: unknown, profile: any = STUDENT) {
  const res = await handleStudentSessionItems(post(body), {
    service: makeService(spec),
    requireProfile: () => Promise.resolve(profile),
  });
  return {
    status: res.status,
    json: await res.json() as Record<string, unknown>,
  };
}

const DELIVERABLE_TRANSFER = {
  content_item_version_id: "tv1",
  content_item_id: "ti1",
  content_key: "apstat-u1-2-2a-variables-102000",
  title: null,
  stem: "Which best describes the variable?",
  stimulus: null,
  stimulus_image_path: null,
  frq_form: null,
  practice_format: null,
};

/* -------------------------------------------------------------------------- */
/* Confirm-transfer: happy path                                                */
/* -------------------------------------------------------------------------- */

Deno.test("confirm-transfer returns one same-cell item", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      sourceVersion: {
        id: SOURCE_VERSION_ID,
        content_items: { exam_pack_version_id: "epv1" },
      },
      transferRows: [DELIVERABLE_TRANSFER],
      choices: [{
        content_item_version_id: "tv1",
        choice_key: "A",
        choice_text: "A safe transfer choice",
      }],
    },
    {
      learning_session_id: SESSION_ID,
      confirm_transfer: { source_content_item_version_id: SOURCE_VERSION_ID },
    },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  assertEquals(result.mode, "confirm_transfer");
  assertEquals(result.source_content_item_version_id, SOURCE_VERSION_ID);
  assert(result.item, "expected a transfer item");
  assertEquals(
    (result.item as Record<string, unknown>).content_item_version_id,
    "tv1",
  );
  assertEquals(result.reason, null);
});

/* -------------------------------------------------------------------------- */
/* Confirm-transfer: fail-closed when the selector returns nothing            */
/* (no same-cell approved MCQ, a numeric-answer cell, or an untagged source)  */
/* -------------------------------------------------------------------------- */

Deno.test("confirm-transfer fails closed with no parallel item", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      sourceVersion: {
        id: SOURCE_VERSION_ID,
        content_items: { exam_pack_version_id: "epv1" },
      },
      transferRows: [], // selector excluded / found nothing
    },
    {
      learning_session_id: SESSION_ID,
      confirm_transfer: { source_content_item_version_id: SOURCE_VERSION_ID },
    },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  assertEquals(result.item, null);
  assertEquals(result.reason, "no_parallel_item");
});

/* -------------------------------------------------------------------------- */
/* Confirm-transfer: a candidate withheld by the media gate is fail-closed    */
/* (item: null, and reported in `omitted`) — never an unanswerable transfer.  */
/* -------------------------------------------------------------------------- */

Deno.test("confirm-transfer withholds a media-gated candidate", async () => {
  const withImage = {
    ...DELIVERABLE_TRANSFER,
    stimulus_image_path: "u1/img.png",
  };
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      sourceVersion: {
        id: SOURCE_VERSION_ID,
        content_items: { exam_pack_version_id: "epv1" },
      },
      transferRows: [withImage],
      // required visual with no student-approved metadata -> partitionDeliverable omits
      visuals: [{
        content_item_version_id: "tv1",
        image_needed: "yes",
        image_approval: null,
      }],
    },
    {
      learning_session_id: SESSION_ID,
      confirm_transfer: { source_content_item_version_id: SOURCE_VERSION_ID },
    },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  assertEquals(result.item, null);
  assertEquals(result.reason, "no_parallel_item");
  assert(
    (result.omitted as unknown[]).length >= 1,
    "expected the withheld candidate to be reported in omitted",
  );
});

/* -------------------------------------------------------------------------- */
/* Confirm-transfer: source must belong to the session's exam pack            */
/* -------------------------------------------------------------------------- */

Deno.test("confirm-transfer rejects a cross-pack source", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      sourceVersion: {
        id: SOURCE_VERSION_ID,
        content_items: { exam_pack_version_id: "OTHER_PACK" },
      },
      transferRows: [DELIVERABLE_TRANSFER],
    },
    {
      learning_session_id: SESSION_ID,
      confirm_transfer: { source_content_item_version_id: SOURCE_VERSION_ID },
    },
  );
  assertEquals(status, 409);
  assertEquals(json.error, "session_content_mismatch");
});

Deno.test("confirm-transfer 404s an unknown source item", async () => {
  const { status, json } = await call(
    { session: ACTIVE_SESSION, sourceVersion: null },
    {
      learning_session_id: SESSION_ID,
      confirm_transfer: { source_content_item_version_id: SOURCE_VERSION_ID },
    },
  );
  assertEquals(status, 404);
  assertEquals(json.error, "source_item_not_found");
});

Deno.test("confirm-transfer requires a source id", async () => {
  const { status, json } = await call(
    { session: ACTIVE_SESSION },
    { learning_session_id: SESSION_ID, confirm_transfer: {} },
  );
  assertEquals(status, 400);
  assertEquals(json.error, "missing_required_fields");
});

/* -------------------------------------------------------------------------- */
/* Ownership / lifecycle gates apply to the transfer request too              */
/* -------------------------------------------------------------------------- */

Deno.test("confirm-transfer denies a non-owner", async () => {
  const { status, json } = await call(
    { session: { ...ACTIVE_SESSION, user_id: "someone_else" } },
    {
      learning_session_id: SESSION_ID,
      confirm_transfer: { source_content_item_version_id: SOURCE_VERSION_ID },
    },
  );
  assertEquals(status, 403);
  assertEquals(json.error, "forbidden");
});

Deno.test("confirm-transfer refuses an inactive session", async () => {
  const { status, json } = await call(
    { session: { ...ACTIVE_SESSION, status: "completed" } },
    {
      learning_session_id: SESSION_ID,
      confirm_transfer: { source_content_item_version_id: SOURCE_VERSION_ID },
    },
  );
  assertEquals(status, 409);
  assertEquals(json.error, "session_not_active");
});

Deno.test("unauthorized caller is rejected", async () => {
  const { status, json } = await call(
    { session: ACTIVE_SESSION },
    {
      learning_session_id: SESSION_ID,
      confirm_transfer: { source_content_item_version_id: SOURCE_VERSION_ID },
    },
    null,
  );
  assertEquals(status, 401);
  assertEquals(json.error, "unauthorized");
});

/* -------------------------------------------------------------------------- */
/* Ordinary queue path is unchanged by the refactor                            */
/* -------------------------------------------------------------------------- */

Deno.test("ordinary path still serves the practice selection", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      practiceRows: [{
        ...DELIVERABLE_TRANSFER,
        content_item_version_id: "ov1",
      }],
    },
    { learning_session_id: SESSION_ID },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  assertEquals((result.items as unknown[]).length, 1);
  assertEquals(result.practice_format, "mcq");
  assertEquals(result.reason, null);
});

/* -------------------------------------------------------------------------- */
/* TASK-0047 Decision 17 follow-on: resolved topic/cell identity, wired       */
/* end to end through the real handler (not just the pure functions above).  */
/* -------------------------------------------------------------------------- */

Deno.test("a served item's cell resolves a skill-bearing row from content_item_topic_resolution", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      practiceRows: [{
        ...DELIVERABLE_TRANSFER,
        content_item_version_id: "ov1",
        content_item_id: "oi1",
      }],
      topicResolution: [{
        content_item_version_id: "ov1",
        topic_code: "u1-l2",
        skill_code: "A",
        topic_title: "Sampling distributions",
        unit_number: 1,
      }],
    },
    { learning_session_id: SESSION_ID },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  const item = (result.items as Record<string, unknown>[])[0];
  assertEquals(item.cell, {
    topic_code: "u1-l2",
    skill_code: "A",
    topic_title: "Sampling distributions",
    unit_number: 1,
  });
});

Deno.test("a served item's cell resolves a topic-only row (null skill_code) from content_item_topic_resolution", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      practiceRows: [{
        ...DELIVERABLE_TRANSFER,
        content_item_version_id: "ov2",
        content_item_id: "oi2",
      }],
      // The real content_item_topic_resolution VIEW (not this mock) is what
      // filters assignment_status to ('validated', 'authored') -- see
      // 20260927004700_content_item_topic_resolution_view.sql and its
      // dedicated integration test, supabase/tests/
      // content_item_topic_resolution_status_gate.integration.sql, which
      // verifies that filter against real data. This mock table stands in
      // for the view's OUTPUT, so it cannot exercise that SQL-level filter
      // itself -- only that a row the view already decided to expose is
      // then handled correctly end-to-end (topic-only, skill_code null).
      topicResolution: [{
        content_item_version_id: "ov2",
        topic_code: "4.2",
        skill_code: null,
        topic_title: "Introduction to Signal Transduction",
        unit_number: 4,
      }],
    },
    { learning_session_id: SESSION_ID },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  const item = (result.items as Record<string, unknown>[])[0];
  assertEquals(item.cell, {
    topic_code: "4.2",
    skill_code: null,
    topic_title: "Introduction to Signal Transduction",
    unit_number: 4,
  });
});

Deno.test("a served item's cell is null when neither resolution path applies", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      practiceRows: [{
        ...DELIVERABLE_TRANSFER,
        content_item_version_id: "ov3",
        content_item_id: "oi3",
      }],
    },
    { learning_session_id: SESSION_ID },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  const item = (result.items as Record<string, unknown>[])[0];
  assertEquals(item.cell, null);
});

/* -------------------------------------------------------------------------- */
/* TASK-0047 Workstream E: item-package dual-read adapter, wired end to end   */
/* -------------------------------------------------------------------------- */

Deno.test("an item with no legacy stem/choices but a package payload still serves", async () => {
  const versionId = "55555555-5555-4555-8555-555555555555";
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      practiceRows: [{
        ...DELIVERABLE_TRANSFER,
        content_item_version_id: versionId,
        item_type: "mcq",
        stem: "", // legacy stem never populated for this hypothetical item
      }],
      choices: [], // and no legacy mcq_choices rows either
      packages: [{
        id: versionId,
        item_package_payload: {
          schema_version: "1.0.0",
          mcq_choices: [
            { choice_key: "A", choice_text: "4", is_correct: true },
            { choice_key: "B", choice_text: "2", is_correct: false },
          ],
          parts: [{ part_key: "question", prompt: "What is lim(x->2) ...?" }],
        },
      }],
    },
    { learning_session_id: SESSION_ID },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  const items = result.items as Array<Record<string, unknown>>;
  assertEquals(items.length, 1);
  assertEquals(items[0].stem, "What is lim(x->2) ...?");
  assertEquals(items[0].choices, [
    { choice_key: "A", choice_text: "4" },
    { choice_key: "B", choice_text: "2" },
  ]);
  // The package's is_correct must never reach the response.
  assertFalse(JSON.stringify(items).includes("is_correct"));
});

Deno.test("an item with a legacy stem is unaffected by an unrelated package payload", async () => {
  const versionId = "ov1";
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      practiceRows: [{
        ...DELIVERABLE_TRANSFER,
        content_item_version_id: versionId,
      }],
      choices: [{
        content_item_version_id: versionId,
        choice_key: "A",
        choice_text: "the real legacy choice",
      }],
      packages: [{
        id: versionId,
        item_package_payload: {
          schema_version: "1.0.0",
          mcq_choices: [{ choice_key: "Z", choice_text: "should never win" }],
        },
      }],
    },
    { learning_session_id: SESSION_ID },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  const items = result.items as Array<Record<string, unknown>>;
  assertEquals(items[0].stem, DELIVERABLE_TRANSFER.stem);
  assertEquals(items[0].choices, [
    { choice_key: "A", choice_text: "the real legacy choice" },
  ]);
});

/* -------------------------------------------------------------------------- */
/* FF-15: an empty queue must say why                                         */
/* -------------------------------------------------------------------------- */

Deno.test("empty queue reports no_matching_content when the selector returns nothing", async () => {
  const { status, json } = await call(
    { session: ACTIVE_SESSION, practiceRows: [] },
    { learning_session_id: SESSION_ID },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  assertEquals(result.items, []);
  assertEquals(result.reason, "no_matching_content");
});

/* -------------------------------------------------------------------------- */
/* FF-1: Biology targeted-drill routes to the combined selector               */
/* -------------------------------------------------------------------------- */

const BIOLOGY_SESSION = {
  ...ACTIVE_SESSION,
  practice_format: "targeted_drill",
  exam_pack_version: { exam_pack: { exam_code: "ap_biology" } },
};

const BIOLOGY_MCQ = {
  ...DELIVERABLE_TRANSFER,
  content_item_version_id: "33333333-3333-4333-8333-333333333333",
  content_item_id: "44444444-4444-4444-8444-444444444444",
  content_key: "APBIO-MCQ-001",
  item_type: "mcq",
};

Deno.test("Biology targeted-drill routes to the combined selector with the session seed", async () => {
  const rpcCalls: RpcCall[] = [];
  const { status, json } = await call(
    {
      session: BIOLOGY_SESSION,
      biologyRows: [BIOLOGY_MCQ],
      choices: [{
        content_item_version_id: BIOLOGY_MCQ.content_item_version_id,
        choice_key: "A",
        choice_text: "A safe learner-facing choice",
        is_correct: true,
        rationale: "must not be forwarded",
      }],
      rpcCalls,
    },
    { learning_session_id: SESSION_ID, limit: 20 },
  );

  assertEquals(status, 200);
  assertEquals(rpcCalls, [{
    schema: "app",
    name: "select_biology_practice_items",
    params: {
      _exam_pack_version_id: "epv1",
      _practice_format: "targeted_drill",
      _selection_seed: SESSION_ID,
      _limit: 20,
    },
  }]);
  const item = (json.result as Record<string, unknown>).items as Array<
    Record<string, unknown>
  >;
  assertEquals(item.length, 1);
  assertEquals(item[0].item_type, "mcq");
  assertEquals(item[0].choices, [{
    choice_key: "A",
    choice_text: "A safe learner-facing choice",
  }]);
  const serialized = JSON.stringify(json);
  assert(!serialized.includes("is_correct"));
  assert(!serialized.includes("rationale"));
});

Deno.test("non-Biology and non-targeted formats keep the existing selector arguments", async () => {
  for (
    const session of [
      { ...ACTIVE_SESSION, practice_format: "targeted_drill" },
      { ...BIOLOGY_SESSION, practice_format: "full_exam_frq" },
    ]
  ) {
    const rpcCalls: RpcCall[] = [];
    const { status } = await call(
      { session, practiceRows: [], rpcCalls },
      { learning_session_id: SESSION_ID, limit: 7 },
    );
    assertEquals(status, 200);
    assertEquals(rpcCalls, [{
      schema: "public",
      name: "select_practice_frqs",
      params: {
        _exam_pack_version_id: "epv1",
        _practice_format: session.practice_format,
        _limit: 7,
      },
    }]);
  }
});

Deno.test("a Biology MCQ with no choices is omitted fail-closed", async () => {
  const { status, json } = await call(
    { session: BIOLOGY_SESSION, biologyRows: [BIOLOGY_MCQ], choices: [] },
    { learning_session_id: SESSION_ID },
  );

  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  assertEquals(result.items, []);
  assertEquals(result.omitted, [{
    content_key: "APBIO-MCQ-001",
    reason: "choices_missing",
  }]);
  assertEquals(result.reason, "all_items_omitted");
});
