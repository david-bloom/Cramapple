import "../attempt-response/_test_setup.ts";
import { assertEquals } from "jsr:@std/assert@1";
import { handleAdminContent } from "./index.ts";
type Deps = NonNullable<Parameters<typeof handleAdminContent>[1]>;

type Query = { table: string; action: string; columns: string };
const id = "40000000-0000-4000-8000-000000000001";
const dbError = { code: "XX000", message: "private database detail" };

async function run(
  fail: (q: Query) => boolean,
  operation = "create_draft",
  itemType = "mcq",
) {
  let hit = false;
  const writes: string[] = [];
  const service = {
    schema: () => ({
      rpc: (name: string) =>
        Promise.resolve({
          data: name === "reserve_artifact_version_sequence" ? 1 : "draft",
          error: fail({ table: name, action: "rpc", columns: "" })
            ? (hit = true, dbError)
            : null,
        }),
      from: (table: string) => {
        const q: Query = { table, action: "read", columns: "" };
        const result = (single: boolean) => {
          if (q.action !== "read") writes.push(`${table}:${q.action}`);
          if (fail(q)) {
            hit = true;
            return { data: null, error: dbError };
          }
          const row = table === "audit_events" && q.action === "read" ? null : {
            id,
            artifact_version_id: id,
            version_num: 1,
            exam_pack_id: id,
            label_key: "label",
          };
          return { data: single ? row : row ? [row] : [], error: null };
        };
        const chain = {
          select: (columns: string) => {
            q.columns = columns;
            return chain;
          },
          eq: () => chain,
          order: () => chain,
          limit: () => chain,
          insert: () => {
            q.action = "insert";
            return chain;
          },
          update: () => {
            q.action = "update";
            return chain;
          },
          upsert: () => {
            q.action = "upsert";
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
  const res = await handleAdminContent(
    new Request("http://localhost/admin-content", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({
        operation,
        idempotency_key: "admin-key",
        artifact_version_id: id,
        artifact: { payload: { text: "Question" } },
        compatibility: {
          exam_pack_version_id: id,
          content_key: "fixture",
          title: "Question",
          item_type: itemType,
          mcq_choices: [{
            choice_key: "A",
            choice_text: "Answer",
            is_correct: true,
          }],
          frq_criteria: [{
            criterion_key: "c1",
            learner_facing_text: "Criterion",
            points_possible: 1,
          }],
          content_labels: ["label"],
        },
      }),
    }),
    {
      service: service as unknown as NonNullable<Deps["service"]>,
      requireProfile: (() =>
        Promise.resolve({
          user: { id },
          profile: { role: "admin" },
        })) as unknown as NonNullable<Deps["requireProfile"]>,
    },
  );
  return { res, hit, writes };
}

const cases = [
  [
    "compatibility_item_update",
    "content_items",
    "update",
    "create_draft",
    "mcq",
  ],
  [
    "compatibility_choices_insert",
    "mcq_choices",
    "insert",
    "create_draft",
    "mcq",
  ],
  [
    "compatibility_criteria_insert",
    "frq_criteria",
    "insert",
    "create_draft",
    "frq",
  ],
  [
    "compatibility_labels_upsert",
    "content_item_labels",
    "upsert",
    "create_draft",
    "mcq",
  ],
  [
    "artifact_labels_upsert",
    "artifact_label_assignments",
    "upsert",
    "create_draft",
    "mcq",
  ],
  ["legacy_item_state_update", "content_items", "update", "retire", "mcq"],
  [
    "legacy_version_state_update",
    "content_item_versions",
    "update",
    "retire",
    "mcq",
  ],
  ["audit_event_insert", "audit_events", "insert", "create_draft", "mcq"],
  ["label_exam_pack_read", "exam_pack_versions", "read", "create_draft", "mcq"],
  ["content_labels_read", "content_labels", "read", "create_draft", "mcq"],
  ["legacy_item_read", "content_items", "read", "retire", "mcq"],
  ["legacy_version_read", "content_item_versions", "read", "retire", "mcq"],
  ["artifact_state_read", "project_artifact_state", "rpc", "retire", "mcq"],
];
for (const [step, table, action, operation, itemType] of cases) {
  Deno.test(`admin-content refuses success on ${step} failure`, async () => {
    const { res, hit, writes } = await run(
      (q) => q.table === table && q.action === action,
      operation,
      itemType,
    );
    assertEquals(hit, true);
    assertEquals(res.status, 500);
    assertEquals(await res.json(), {
      status: "failed",
      function: "admin-content",
      operation,
      error: "admin_content_failed",
      failed_step: step,
      reconciliation_required: true,
    });
    if (step !== "audit_event_insert") {
      assertEquals(writes.includes("audit_events:insert"), false);
    }
  });
}
for (const operation of ["create_draft", "retire"]) {
  Deno.test(`admin-content ${operation} acknowledges successful required operations`, async () => {
    const { res, writes } = await run(() => false, operation);
    assertEquals(res.status, 200);
    assertEquals((await res.json()).status, "ok");
    assertEquals(writes.includes("audit_events:insert"), true);
  });
}
