// Request-handling tests for start-trial -- the entrypoint a brand-new,
// never-seen-before student actually calls to get the free-trial
// entitlement that `authorize_grading_access` requires at submit time (see
// attempt-response/index_test.ts's "submit-entitlement-gate" tests and
// evaluate-attempt's own gate). This file previously had zero coverage of
// its own request-handling logic -- only the pure `_shared/trial-contract.ts`
// helpers were tested -- so the cold-start path for a stranger signing up
// (unauthenticated -> missing consent -> RPC failure -> first-ever grant ->
// already-started replay) was never pinned before deploy.
//
// This is unit coverage of the function's own contract with an injected
// fake service/auth, mirroring attempt-response/index_test.ts's pattern. It
// is NOT a substitute for `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` item
// 2's live-Production brand-new-student smoke test (real signup -> real
// entitlement -> real submit-to-grade round trip) -- that still has to be
// run against the live app before October 2, per this repo's own stop
// conditions.

import "./_test_setup.ts";
import { assertEquals } from "jsr:@std/assert@1";
import { handleStartTrial } from "./index.ts";

type RpcCall = { name: string; params: Record<string, unknown> };
type FromCall = { table: string; row: Record<string, unknown> };

function fakeAuth(
  user: { id: string; email?: string },
  role: "student" | "admin" = "student",
) {
  const result = { user, profile: { user_id: user.id, role } };
  // deno-lint-ignore no-explicit-any
  return (_req: Request) => Promise.resolve(result as any);
}

function unauthenticated() {
  return (_req: Request) => Promise.resolve(null);
}

function makeService(
  opts: {
    rpcData?: Record<string, unknown> | null;
    rpcError?: { message: string } | null;
  },
) {
  const rpcCalls: RpcCall[] = [];
  const fromCalls: FromCall[] = [];

  const rpc = (name: string, params: Record<string, unknown>) => {
    rpcCalls.push({ name, params });
    if (name !== "start_trial") {
      throw new Error(`unexpected rpc in test fake: ${name}`);
    }
    const result = {
      data: opts.rpcData ?? null,
      error: opts.rpcError ?? null,
    };
    return Promise.resolve(result);
  };

  const from = (table: string) => {
    if (table !== "growth_event_outbox") {
      throw new Error(`unexpected from() in test fake: ${table}`);
    }
    return {
      upsert: (row: Record<string, unknown>) => {
        fromCalls.push({ table, row });
        return {
          select: () => ({
            maybeSingle: () =>
              Promise.resolve({
                data: { id: "outbox-1", delivered_at: null, delivery_attempts: 0 },
                error: null,
              }),
          }),
        };
      },
    };
  };

  // deno-lint-ignore no-explicit-any
  const service = { schema: () => ({ rpc, from }) } as any;
  return { service, rpcCalls, fromCalls };
}

function startTrialRequest(overrides: Record<string, unknown> = {}) {
  return new Request("http://localhost/start-trial", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      authorization: "Bearer test-token",
    },
    body: JSON.stringify({
      privacy_notice_version: "2026-09-01",
      ...overrides,
    }),
  });
}

Deno.test("start-trial: rejects non-POST before touching auth or the service", async () => {
  const { service, rpcCalls } = makeService({});
  const res = await handleStartTrial(
    new Request("http://localhost/start-trial", { method: "GET" }),
    { service, requireProfile: unauthenticated() },
  );
  assertEquals(res.status, 405);
  assertEquals(rpcCalls, []);
});

Deno.test("start-trial: rejects invalid JSON body", async () => {
  const { service, rpcCalls } = makeService({});
  const req = new Request("http://localhost/start-trial", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: "{not json",
  });
  const res = await handleStartTrial(req, {
    service,
    requireProfile: unauthenticated(),
  });
  assertEquals(res.status, 400);
  const body = await res.json();
  assertEquals(body.error, "invalid_json");
  assertEquals(rpcCalls, []);
});

Deno.test("start-trial: cold-start stranger with no session is refused, not granted a trial", async () => {
  const { service, rpcCalls } = makeService({});
  const res = await handleStartTrial(startTrialRequest(), {
    service,
    requireProfile: unauthenticated(),
  });
  assertEquals(res.status, 401);
  const body = await res.json();
  assertEquals(body.error, "unauthorized");
  assertEquals(rpcCalls, []);
});

Deno.test("start-trial: a non-student/non-admin role (e.g. reviewer) is forbidden", async () => {
  const { service, rpcCalls } = makeService({});
  const authenticate = (_req: Request) =>
    Promise.resolve({
      user: { id: crypto.randomUUID() },
      profile: { user_id: "x", role: "reviewer" },
      // deno-lint-ignore no-explicit-any
    } as any);
  const res = await handleStartTrial(startTrialRequest(), {
    service,
    requireProfile: authenticate,
  });
  assertEquals(res.status, 403);
  const body = await res.json();
  assertEquals(body.error, "forbidden");
  assertEquals(rpcCalls, []);
});

Deno.test("start-trial: missing privacy_notice_version is rejected before any RPC call", async () => {
  const { service, rpcCalls } = makeService({});
  const res = await handleStartTrial(
    startTrialRequest({ privacy_notice_version: undefined }),
    { service, requireProfile: fakeAuth({ id: crypto.randomUUID() }) },
  );
  assertEquals(res.status, 400);
  const body = await res.json();
  assertEquals(body.error, "missing_privacy_notice_version");
  assertEquals(rpcCalls, []);
});

Deno.test("start-trial: an RPC failure surfaces as trial_start_failed, not a raw 500 leak", async () => {
  const { service } = makeService({
    rpcError: { message: "start_trial:unexpected" },
  });
  const res = await handleStartTrial(startTrialRequest(), {
    service,
    requireProfile: fakeAuth({ id: crypto.randomUUID() }),
  });
  assertEquals(res.status, 500);
  const body = await res.json();
  assertEquals(body.error, "trial_start_failed");
});

Deno.test("start-trial: a brand-new student's first call grants the trial and records trial_started exactly once", async () => {
  const userId = crypto.randomUUID();
  const { service, rpcCalls, fromCalls } = makeService({
    rpcData: {
      already_started: false,
      starts_at: "2026-09-28T00:00:00Z",
      ends_at: "2026-10-05T00:00:00Z",
      subjects: ["ap_biology", "ap_statistics"],
    },
  });
  const res = await handleStartTrial(startTrialRequest(), {
    service,
    requireProfile: fakeAuth({ id: userId }),
  });
  assertEquals(res.status, 200);
  const body = await res.json();
  assertEquals(body.status, "ok");
  assertEquals(body.result, {
    already_started: false,
    starts_at: "2026-09-28T00:00:00Z",
    ends_at: "2026-10-05T00:00:00Z",
    subjects: ["ap_biology", "ap_statistics"],
  });
  assertEquals(rpcCalls.map((c) => c.name), ["start_trial"]);
  assertEquals(rpcCalls[0].params.p_user_id, userId);
  // Exactly one growth-event write, deduped on this user, for the real
  // grant -- not the RPC call's echo.
  assertEquals(fromCalls.length, 1);
  assertEquals(fromCalls[0].row.dedupe_key, `trial_started:${userId}`);
});

Deno.test("start-trial: replaying an already-started trial does not re-record the growth event", async () => {
  const userId = crypto.randomUUID();
  const { service, fromCalls } = makeService({
    rpcData: {
      already_started: true,
      starts_at: "2026-09-20T00:00:00Z",
      ends_at: "2026-09-27T00:00:00Z",
      subjects: ["ap_biology", "ap_statistics"],
    },
  });
  const res = await handleStartTrial(startTrialRequest(), {
    service,
    requireProfile: fakeAuth({ id: userId }),
  });
  assertEquals(res.status, 200);
  const body = await res.json();
  assertEquals(body.result.already_started, true);
  // The whole point of the already_started branch: no duplicate
  // trial_started event for a student replaying the call (e.g. a retried
  // request, or revisiting the signup screen).
  assertEquals(fromCalls, []);
});

Deno.test("start-trial: admin role is allowed the same cold-start path as a student", async () => {
  const userId = crypto.randomUUID();
  const { service, rpcCalls } = makeService({
    rpcData: {
      already_started: false,
      starts_at: "2026-09-28T00:00:00Z",
      ends_at: "2026-10-05T00:00:00Z",
      subjects: ["ap_biology", "ap_statistics"],
    },
  });
  const res = await handleStartTrial(startTrialRequest(), {
    service,
    requireProfile: fakeAuth({ id: userId }, "admin"),
  });
  assertEquals(res.status, 200);
  assertEquals(rpcCalls.map((c) => c.name), ["start_trial"]);
});
