import "../attempt-response/_test_setup.ts";
import { assertEquals, assertRejects } from "jsr:@std/assert@1";
import { advanceWorkflow, handleReviewDecision } from "./index.ts";
type Deps = NonNullable<Parameters<typeof handleReviewDecision>[1]>;
import { RequiredDatabaseError } from "../_shared/checked-database.ts";

const id = "50000000-0000-4000-8000-000000000001";
function fixture(
  failTable: string | null,
  failAction = "update",
  aggregate = 2,
) {
  const writes: string[] = [];
  const service = {
    schema: () => ({
      from: (table: string) => {
        let action = "read";
        let payload: Record<string, unknown> = {};
        const result = (single: boolean) => {
          if (action !== "read") writes.push(`${table}:${action}`);
          if (table === failTable && action === failAction) {
            return {
              data: null,
              error: { code: "XX000", message: "private detail" },
            };
          }
          const assignments = [1, 2].map((n) => ({
            content_review_assignment_id: String(n),
            status: "submitted",
          }));
          const decisions = [1, aggregate - 1].map((score, n) => ({
            content_review_assignment_id: String(n + 1),
            tutor_score: score,
          }));
          const row = table === "content_review_assignments"
            ? {
              content_review_assignment_id: id,
              content_item_version_id: id,
              reviewer_id: id,
              review_stage: "reader_question",
              review_kind: "frq",
              status: "pending",
            }
            : table === "content_review_decisions"
            ? { ...payload, content_review_decision_id: id }
            : { id };
          return {
            data: single
              ? row
              : table === "content_review_assignments"
              ? assignments
              : table === "content_review_decisions"
              ? decisions
              : [],
            error: null,
          };
        };
        const chain = {
          select: () => chain,
          eq: () => chain,
          in: () => chain,
          order: () => chain,
          insert: (p: Record<string, unknown>) => {
            action = "insert";
            payload = p;
            return chain;
          },
          update: () => {
            action = "update";
            return chain;
          },
          upsert: () => {
            action = "upsert";
            return chain;
          },
          maybeSingle: () => Promise.resolve(result(true)),
          single: () => Promise.resolve(result(true)),
          then: (resolve: (v: unknown) => unknown) =>
            Promise.resolve(result(false)).then(resolve),
        };
        return chain;
      },
    }),
  };
  return {
    service: service as unknown as NonNullable<Deps["service"]>,
    writes,
  };
}

for (const stage of ["tutor_question", "reader_question"]) {
  for (const kind of ["mcq", "frq"]) {
    for (const score of [1, 2, 3]) {
      Deno.test(`required ${stage}/${kind}/${score} transition propagates database failure`, async () => {
        const { service } = fixture(
          "content_item_versions",
          "update",
          score === 1 ? 2 : score === 2 ? 3 : 4,
        );
        await assertRejects(
          () =>
            advanceWorkflow(service, {
              content_item_version_id: id,
              review_stage: stage,
              review_kind: kind,
              blind_group_id: id,
            }, { tutor_score: score }),
          RequiredDatabaseError,
        );
      });
    }
  }
}
for (
  const table of ["content_review_assignments", "content_review_decisions"]
) {
  Deno.test(`workflow group read ${table} failure cannot masquerade as incomplete decisions`, async () => {
    const { service } = fixture(table, "read");
    await assertRejects(() =>
      advanceWorkflow(service, {
        content_item_version_id: id,
        review_stage: "tutor_question",
        blind_group_id: id,
      }, {}), RequiredDatabaseError);
  });
}
for (const failed of [false, true]) {
  Deno.test(`review decision ${failed ? "surfaces partial commit" : "acknowledges advancement"}`, async () => {
    const { service, writes } = fixture(
      failed ? "content_item_versions" : null,
    );
    const res = await handleReviewDecision(
      new Request("http://localhost/review-decision", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ assignment_id: id, reader_decision: "agree" }),
      }),
      {
        service,
        requireProfile: (() =>
          Promise.resolve({
            user: { id },
            profile: { role: "admin" },
          })) as unknown as NonNullable<Deps["requireProfile"]>,
      },
    );
    assertEquals(res.status, failed ? 500 : 200);
    const body = await res.json();
    if (failed) {
      assertEquals(body, {
        error: "workflow_advance_failed",
        decision_recorded: true,
        reconciliation_required: true,
        assignment_id: id,
      });
    } else assertEquals(body.status, "ok");
    assertEquals(writes.includes("content_review_decisions:insert"), true);
  });
}
