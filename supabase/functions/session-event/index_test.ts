import "./_test_setup.ts";
import { assertEquals } from "jsr:@std/assert@1";
import { handleSessionEvent } from "./index.ts";

const user = "11111111-1111-4111-8111-111111111111";
const pack = "22222222-2222-4222-8222-222222222222";
const request = (operation = "session_start") =>
  new Request("https://fixture/session-event", {
    method: "POST",
    body: JSON.stringify({
      operation,
      session_id: pack,
      exam_pack_version_id: pack,
      entry_path: "practice",
      session_mode: "learn",
      available_minutes: 10,
      idempotency_key: "fixture-key",
    }),
  });

function fixture(kind: string, completionFails = false, access: boolean | null = true, operation = "session_start") {
  let mutations = 0;
  let claims = 0;
  const result = { id: pack, user_id: user, exam_pack_version_id: pack, status: "active" };
  const service = {
    schema: () => ({
      rpc: (name: string) => {
        if (name === "has_study_pack_access") return Promise.resolve({ data: access, error: null });
        if (name === "claim_operation_replay") {
          const outcome = claims++ > 0 && kind === "claimed" ? "pending" : kind;
          return Promise.resolve({
            data: { kind: outcome, claim_token: pack, result },
            error: null,
          });
        }
        if (name === "complete_operation_replay") {
          return Promise.resolve({
            data: null,
            error: completionFails ? { message: "audit unavailable" } : null,
          });
        }
        throw new Error(`unexpected RPC ${name}`);
      },
      from: (table: string) => {
        const query = {
          select: () => query,
          eq: () => query,
          insert: () => {
            mutations++;
            return query;
          },
          maybeSingle: () =>
            Promise.resolve({
              data: table === "profiles"
                ? { active_exam_pack_version_id: pack }
                : result,
              error: null,
            }),
        };
        return query;
      },
    }),
  };
  const run = () =>
    handleSessionEvent(request(operation), {
      // deno-lint-ignore no-explicit-any
      service: service as any,
      // deno-lint-ignore no-explicit-any
      requireProfile: () =>
        Promise.resolve(
          { user: { id: user }, profile: { role: "student" } } as any,
        ),
    });
  return { run, mutations: () => mutations, claims: () => claims };
}

for (const kind of ["conflict", "pending"]) {
  Deno.test(`session: ${kind} is refused before a session mutation`, async () => {
    const f = fixture(kind);
    assertEquals((await f.run()).status, 409);
    assertEquals(f.mutations(), 0);
  });
}
Deno.test("session: owned legacy replay returns its original result without a mutation", async () => {
  const f = fixture("replay");
  const response = await f.run();
  assertEquals(response.status, 200);
  assertEquals((await response.json()).result.user_id, user);
  assertEquals(f.mutations(), 0);
});
Deno.test("session: lost audit acknowledgement leaves the key pending, never creates a second session", async () => {
  const f = fixture("claimed", true);
  assertEquals((await f.run()).status, 409);
  assertEquals(f.mutations(), 1);
  assertEquals((await f.run()).status, 409);
  assertEquals(f.mutations(), 1);
});
Deno.test("session: simultaneous same-key requests permit only one action", async () => {
  const f = fixture("claimed");
  const statuses = (await Promise.all([f.run(), f.run()])).map((r) => r.status)
    .sort();
  assertEquals(statuses, [200, 409]);
  assertEquals(f.mutations(), 1);
});

for (const operation of ["session_start", "session_resume"]) {
  for (const access of [false, null]) {
    Deno.test(`${operation}: missing/unknown access denies even a cached successful replay`, async () => {
      const f = fixture("replay", false, access, operation);
      const response = await f.run();
      assertEquals(response.status, access === false ? 403 : 503);
      assertEquals(f.claims(), 0);
      assertEquals(f.mutations(), 0);
    });
  }
}
