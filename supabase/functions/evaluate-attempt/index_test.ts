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
