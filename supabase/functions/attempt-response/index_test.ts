// Request-handling tests for the new submit-time entitlement gate
// (2026-09-20). This file previously had zero coverage of its own
// request-handling logic (only pure `_shared` helpers were tested) -- the
// `handleAttemptResponse`/`AttemptResponseDeps` export exists specifically so
// this gate, which sits on the one path every real student submission goes
// through, can be pinned before deploy rather than trusted on inspection
// alone. Mirrors the fake-service pattern in
// ../capture-pairing/index_test.ts, scaled down to only what submit_response
// actually touches (no `.from()` chain, no storage, no idempotency-result
// lookup -- submit_response is explicitly exempted from that lookup in
// index.ts).
//
// GRADING_ENTITLEMENTS_ENABLED is a module-level const, fixed at import time
// (same as evaluate-attempt's own flag) -- this file sets it to "true" in
// _test_setup.ts to match real Production configuration and tests that
// state's three real branches (entitled/unentitled/admin). The `disabled`
// branch is the same one-line boolean short-circuit evaluate-attempt's
// already-deployed, already-proven gate uses; it is not re-tested here.

import "./_test_setup.ts";
import { assertEquals } from "jsr:@std/assert@1";
import { handleAttemptResponse } from "./index.ts";

type RpcCall = { name: string; params: Record<string, unknown> };

function fakeAuth(user: { id: string }, role: "student" | "admin" = "student") {
  const result = { user, profile: { user_id: user.id, role } };
  // deno-lint-ignore no-explicit-any
  return (_req: Request) => Promise.resolve(result as any);
}

function makeService(opts: { entitled: boolean; submitOk?: boolean }) {
  const calls: RpcCall[] = [];
  const rpc = (name: string, params: Record<string, unknown>) => {
    calls.push({ name, params });
    let result: { data: unknown; error: { message: string } | null };
    if (name === "authorize_grading_access") {
      result = opts.entitled
        ? { data: "entitled", error: null }
        : {
          data: null,
          error: { message: "grading_access:entitlement_required" },
        };
    } else if (name === "submit_response") {
      result = (opts.submitOk ?? true)
        ? { data: { attempt: { status: "submitted" } }, error: null }
        : { data: null, error: { message: "submit_response:unexpected" } };
    } else {
      throw new Error(`unexpected rpc in test fake: ${name}`);
    }
    return {
      single: () => Promise.resolve(result),
      // deno-lint-ignore no-explicit-any
      then: (resolve: (v: any) => void) => resolve(result),
    };
  };
  // deno-lint-ignore no-explicit-any
  const service = { schema: () => ({ rpc }) } as any;
  return { service, calls };
}

function submitRequest(overrides: Record<string, unknown> = {}) {
  return new Request("http://localhost/attempt-response", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      authorization: "Bearer test-token",
    },
    body: JSON.stringify({
      operation: "submit_response",
      idempotency_key: crypto.randomUUID(),
      attempt_id: crypto.randomUUID(),
      response_version_id: crypto.randomUUID(),
      ...overrides,
    }),
  });
}

Deno.test("submit-entitlement-gate: unentitled student is refused before submit_response is ever called", async () => {
  const { service, calls } = makeService({ entitled: false });
  const res = await handleAttemptResponse(submitRequest(), {
    service,
    requireProfile: fakeAuth({ id: crypto.randomUUID() }, "student"),
  });
  assertEquals(res.status, 403);
  const body = await res.json();
  assertEquals(body.error, "entitlement_required");
  assertEquals(calls.map((c) => c.name), ["authorize_grading_access"]);
});

Deno.test("submit-entitlement-gate: entitled student submits normally", async () => {
  const { service, calls } = makeService({ entitled: true });
  const res = await handleAttemptResponse(submitRequest(), {
    service,
    requireProfile: fakeAuth({ id: crypto.randomUUID() }, "student"),
  });
  assertEquals(res.status, 200);
  const body = await res.json();
  assertEquals(body.status, "ok");
  assertEquals(
    calls.map((c) => c.name),
    ["authorize_grading_access", "submit_response"],
  );
});

Deno.test("submit-entitlement-gate: admin bypasses the check entirely, even with zero entitlement rows", async () => {
  const { service, calls } = makeService({ entitled: false });
  const res = await handleAttemptResponse(submitRequest(), {
    service,
    requireProfile: fakeAuth({ id: crypto.randomUUID() }, "admin"),
  });
  assertEquals(res.status, 200);
  // The whole point of the admin exemption: authorize_grading_access must
  // never even be called, not just "called and allowed".
  assertEquals(calls.map((c) => c.name), ["submit_response"]);
});

Deno.test("submit-entitlement-gate: attempt_not_found from authorize_grading_access maps to 404, not 403", async () => {
  const calls: RpcCall[] = [];
  const rpc = (name: string, params: Record<string, unknown>) => {
    calls.push({ name, params });
    const result = { data: null, error: { message: "grading_access:attempt_not_found" } };
    return {
      single: () => Promise.resolve(result),
      // deno-lint-ignore no-explicit-any
      then: (resolve: (v: any) => void) => resolve(result),
    };
  };
  // deno-lint-ignore no-explicit-any
  const service = { schema: () => ({ rpc }) } as any;
  const res = await handleAttemptResponse(submitRequest(), {
    service,
    requireProfile: fakeAuth({ id: crypto.randomUUID() }, "student"),
  });
  assertEquals(res.status, 404);
  const body = await res.json();
  assertEquals(body.error, "attempt_not_found");
});
