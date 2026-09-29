// Request-handling tests for open-hand-item, focused on the fail-closed
// gate: an exam pack version must be BOTH status='published' AND
// retired_at IS NULL (SUBJECT_SERVABILITY_CRITERIA.md criterion 6 --
// status alone is not sufficient, a version can be soft-retired while
// still flagged published), and its subject must be status='active'.
// Neither check existed when this file was first added (repo PR #214) --
// this is coverage for the QA-review fix, mirroring
// ../start-trial/index_test.ts's injected-fake-service pattern.

import "./_test_setup.ts";
import { assertEquals } from "jsr:@std/assert@1";
import { handleOpenHandItem } from "./index.ts";

const SUBJECT_ID = "11111111-1111-1111-1111-111111111111";
const EPV_ID = "22222222-2222-2222-2222-222222222222";
const USER_ID = "33333333-3333-3333-3333-333333333333";

function fakeAuth(role: "student" | "admin" = "student") {
  const result = {
    user: { id: USER_ID, email: "student@example.com" },
    profile: { user_id: USER_ID, role },
  };
  // deno-lint-ignore no-explicit-any
  return (_req: Request) => Promise.resolve(result as any);
}

type ExamPackVersionRow = {
  id: string;
  status: string;
  retired_at: string | null;
  exam_pack: {
    id: string;
    subject_id: string;
    subject: { id: string; subject_key: string; status: string };
  };
};

// A minimal chainable query-builder fake: every filter/order/limit method
// returns `this`; the object is itself thenable (so `await builder` works
// for the array-returning calls) and `.maybeSingle()` resolves the same
// configured payload for the single-row lookup.
function fakeQuery(data: unknown, error: { message: string } | null = null) {
  const result = { data, error };
  const builder: Record<string, unknown> = {
    select: () => builder,
    eq: () => builder,
    in: () => builder,
    order: () => builder,
    limit: () => builder,
    maybeSingle: () => Promise.resolve(result),
    then: (
      resolve: (value: typeof result) => void,
      reject?: (reason: unknown) => void,
    ) => Promise.resolve(result).then(resolve, reject),
  };
  return builder;
}

function makeService(epvRow: ExamPackVersionRow | null) {
  const tables: Record<string, unknown> = {
    exam_pack_versions: fakeQuery(epvRow),
    subject_entitlements: fakeQuery([
      {
        id: "ent-1",
        subject_id: SUBJECT_ID,
        all_subjects: false,
        status: "active",
        starts_at: null,
        ends_at: null,
      },
    ]),
    content_item_versions: fakeQuery([]),
    content_item_cells: fakeQuery([]),
    mcq_choices: fakeQuery([]),
    frq_criteria: fakeQuery([]),
    canonical_answer_spans: fakeQuery([]),
    topic_explainers: fakeQuery([]),
    topic_point_briefs: fakeQuery([]),
  };
  const from = (table: string) => {
    const query = tables[table];
    if (!query) throw new Error(`unexpected from() in test fake: ${table}`);
    return query;
  };
  // deno-lint-ignore no-explicit-any
  return { schema: () => ({ from }) } as any;
}

function openHandRequest(body: Record<string, unknown>) {
  return new Request("http://localhost/open-hand-item", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(body),
  });
}

function baseEpvRow(
  overrides: Partial<ExamPackVersionRow> = {},
): ExamPackVersionRow {
  return {
    id: EPV_ID,
    status: "published",
    retired_at: null,
    exam_pack: {
      id: "pack-1",
      subject_id: SUBJECT_ID,
      subject: { id: SUBJECT_ID, subject_key: "biology", status: "active" },
    },
    ...overrides,
  };
}

Deno.test("rejects a version that is status=published but soft-retired (retired_at set)", async () => {
  const epvRow = baseEpvRow({ retired_at: "2026-09-01T00:00:00Z" });
  const res = await handleOpenHandItem(
    openHandRequest({ exam_pack_version_id: EPV_ID, item_type: "mcq" }),
    { requireProfile: fakeAuth(), service: makeService(epvRow) },
  );
  assertEquals(res.status, 409);
  const body = await res.json();
  assertEquals(body.error, "exam_pack_version_not_published");
});

Deno.test("rejects a published, non-retired version whose subject is not active", async () => {
  const epvRow = baseEpvRow({
    exam_pack: {
      id: "pack-1",
      subject_id: SUBJECT_ID,
      subject: { id: SUBJECT_ID, subject_key: "biology", status: "retired" },
    },
  });
  const res = await handleOpenHandItem(
    openHandRequest({ exam_pack_version_id: EPV_ID, item_type: "mcq" }),
    { requireProfile: fakeAuth(), service: makeService(epvRow) },
  );
  assertEquals(res.status, 409);
  const body = await res.json();
  assertEquals(body.error, "subject_not_active");
});

Deno.test("serves a published, non-retired version for an active subject", async () => {
  const epvRow = baseEpvRow();
  const res = await handleOpenHandItem(
    openHandRequest({ exam_pack_version_id: EPV_ID, item_type: "mcq" }),
    { requireProfile: fakeAuth(), service: makeService(epvRow) },
  );
  assertEquals(res.status, 200);
  const body = await res.json();
  assertEquals(body.subject_key, "biology");
  assertEquals(body.items, []);
});
