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
      result = opts.entitled ? { data: "entitled", error: null } : {
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
    const result = {
      data: null,
      error: { message: "grading_access:attempt_not_found" },
    };
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

// TASK-0038 Phase 4: both new read operations exist ONLY because
// app.attempts/response_attachments RLS is owner-only with no admin bypass,
// so a non-admin must be refused before either ever reaches the service
// client (these forbidden checks run before any `.from()` call, so the
// existing rpc-only fake service is sufficient -- it would throw on an
// unexpected `.from()` call, which is exactly the point).
function opRequest(operation: string, overrides: Record<string, unknown> = {}) {
  return new Request("http://localhost/attempt-response", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      authorization: "Bearer test-token",
    },
    body: JSON.stringify({
      operation,
      idempotency_key: crypto.randomUUID(),
      attempt_id: crypto.randomUUID(),
      ...overrides,
    }),
  });
}

// The idempotency lookup (audit_events) runs before operation dispatch for
// every non-submit_response operation, so the fake has to tolerate that one
// table -- the assertion that matters is that a forbidden caller's request
// never reaches any OTHER table (attempts, response_attachments, ...).
function makeForbiddenPathService() {
  const tablesQueried: string[] = [];
  const stub = {
    select: () => stub,
    eq: () => stub,
    order: () => stub,
    in: () => stub,
    maybeSingle: () => Promise.resolve({ data: null, error: null }),
    single: () => Promise.resolve({ data: null, error: null }),
    then: (resolve: (v: unknown) => void) => resolve({ data: [], error: null }),
  };
  const service = {
    schema: () => ({
      rpc: () => {
        throw new Error("must not be called for a forbidden caller");
      },
      from: (table: string) => {
        tablesQueried.push(table);
        return stub;
      },
    }),
    // deno-lint-ignore no-explicit-any
  } as any;
  return { service, tablesQueried };
}

Deno.test("list_manual_grading_queue: a student caller is refused, never queries attempt data", async () => {
  const { service, tablesQueried } = makeForbiddenPathService();
  const res = await handleAttemptResponse(
    opRequest("list_manual_grading_queue"),
    {
      service,
      requireProfile: fakeAuth({ id: crypto.randomUUID() }, "student"),
    },
  );
  assertEquals(res.status, 403);
  const body = await res.json();
  assertEquals(body.error, "forbidden");
  assertEquals(tablesQueried, ["audit_events"]);
});

Deno.test("get_manual_grading_context: a student caller is refused, never queries attempt data", async () => {
  const { service, tablesQueried } = makeForbiddenPathService();
  const res = await handleAttemptResponse(
    opRequest("get_manual_grading_context"),
    {
      service,
      requireProfile: fakeAuth({ id: crypto.randomUUID() }, "student"),
    },
  );
  assertEquals(res.status, 403);
  const body = await res.json();
  assertEquals(body.error, "forbidden");
  assertEquals(tablesQueried, ["audit_events"]);
});

function createAttemptFixture(
  attemptInsertError: { message: string } | null = null,
) {
  const ids = {
    user: crypto.randomUUID(),
    session: crypto.randomUUID(),
    pack: crypto.randomUUID(),
    version: crypto.randomUUID(),
    item: crypto.randomUUID(),
    attempt: crypto.randomUUID(),
  };
  const tablesQueried: string[] = [];
  const makeChain = (table: string) => {
    let insertValue: Record<string, unknown> | null = null;
    const chain = {
      select: () => chain,
      eq: () => chain,
      insert: (value: Record<string, unknown>) => {
        insertValue = value;
        return chain;
      },
      maybeSingle: () => {
        if (table === "audit_events") {
          return Promise.resolve({ data: null, error: null });
        }
        if (table === "learning_sessions") {
          return Promise.resolve({
            data: {
              id: ids.session,
              user_id: ids.user,
              exam_pack_version_id: ids.pack,
              practice_format: "targeted_drill",
              status: "active",
            },
            error: null,
          });
        }
        if (table === "content_item_versions") {
          return Promise.resolve({
            data: {
              id: ids.version,
              content_item_id: ids.item,
              status: "published",
              content_items: {
                exam_pack_version_id: ids.pack,
                item_type: "mcq",
                practice_format: null,
                status: "published",
              },
            },
            error: null,
          });
        }
        if (table === "attempts" && insertValue) {
          return Promise.resolve(
            attemptInsertError
              ? { data: null, error: attemptInsertError }
              : { data: { id: ids.attempt, ...insertValue }, error: null },
          );
        }
        throw new Error(`unexpected maybeSingle table: ${table}`);
      },
      then: (resolve: (value: unknown) => void) =>
        resolve({ data: null, error: null }),
    };
    return chain;
  };
  const service = {
    schema: () => ({
      from: (table: string) => {
        tablesQueried.push(table);
        return makeChain(table);
      },
    }),
    // deno-lint-ignore no-explicit-any
  } as any;
  const req = new Request("http://localhost/attempt-response", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({
      operation: "create_attempt",
      idempotency_key: crypto.randomUUID(),
      learning_session_id: ids.session,
      content_item_version_id: ids.version,
      attempt_mode: "mcq",
    }),
  });
  return { ids, service, req, tablesQueried };
}

Deno.test("create_attempt accepts a served NULL-format MCQ in a targeted-drill session", async () => {
  const { ids, service, req, tablesQueried } = createAttemptFixture();
  const res = await handleAttemptResponse(req, {
    service,
    requireProfile: fakeAuth({ id: ids.user }, "student"),
  });
  const body = await res.json();
  assertEquals(res.status, 200);
  assertEquals(body.status, "ok");
  assertEquals(body.result.attempt.attempt_mode, "mcq");
  assertEquals(tablesQueried, [
    "audit_events",
    "learning_sessions",
    "content_item_versions",
    "attempts",
    "audit_events",
  ]);
});

Deno.test("create_attempt maps the teaching-item trigger refusal to 409 open_hand_item_not_scorable", async () => {
  const { ids, service, req } = createAttemptFixture({
    message: "open_hand_item_not_scorable",
  });
  const res = await handleAttemptResponse(req, {
    service,
    requireProfile: fakeAuth({ id: ids.user }, "student"),
  });
  assertEquals(res.status, 409);
  assertEquals(await res.json(), { error: "open_hand_item_not_scorable" });
});

Deno.test("create_attempt still returns 500 for any other insert failure", async () => {
  const { ids, service, req } = createAttemptFixture({ message: "boom" });
  const res = await handleAttemptResponse(req, {
    service,
    requireProfile: fakeAuth({ id: ids.user }, "student"),
  });
  assertEquals(res.status, 500);
  assertEquals(await res.json(), { error: "attempt_create_failed" });
});

// ---------------------------------------------------------------------------
// propose_transcript: paywall-sample photo cap (spec §7, Codex QA finding 2,
// 2026-11-09). The fixture is an admin caller (bypasses the subject dark-launch
// check) with a draft attempt, an unsubmitted response version and one
// original attachment; the only thing under test is how the handler treats the
// `sample_take_photo_run` rpc result BEFORE any model call or shared cap.
// ---------------------------------------------------------------------------
function proposeTranscriptFixture(
  sampleRun: { data: unknown; error: { message: string } | null },
) {
  const ids = {
    user: crypto.randomUUID(),
    attempt: crypto.randomUUID(),
    version: crypto.randomUUID(),
    response: crypto.randomUUID(),
    pack: crypto.randomUUID(),
  };
  const rpcCalls: string[] = [];
  const tablesQueried: string[] = [];
  const rows: Record<string, unknown> = {
    attempts: {
      id: ids.attempt,
      user_id: ids.user,
      status: "draft",
      content_item_version_id: ids.version,
      exam_pack_version_id: ids.pack,
    },
    response_versions: {
      id: ids.response,
      attempt_id: ids.attempt,
      is_submitted: false,
      response_text: null,
      response_parts: {},
    },
    content_item_versions: { id: ids.version, stem: "Explain.", prompt_json: { parts: [{ key: "a" }] } },
  };
  const attachment = {
    id: crypto.randomUUID(),
    kind: "original",
    storage_bucket: "frq-photos",
    storage_path: "x/y.jpg",
    media_type: "image/jpeg",
    sha256_digest: "0".repeat(64),
    redacted_at: null,
    created_at: new Date().toISOString(),
  };
  const makeChain = (table: string) => {
    tablesQueried.push(table);
    const chain = {
      select: () => chain,
      eq: () => chain,
      like: () => chain,
      insert: () => chain,
      order: () => Promise.resolve({ data: table === "response_attachments" ? [attachment] : [], error: null }),
      maybeSingle: () => Promise.resolve({ data: rows[table] ?? null, error: null }),
    };
    return chain;
  };
  const rpc = (name: string) => {
    rpcCalls.push(name);
    const result = name === "sample_take_photo_run" ? sampleRun : { data: null, error: null };
    return { single: () => Promise.resolve(result), then: (resolve: (v: unknown) => void) => resolve(result) };
  };
  // deno-lint-ignore no-explicit-any
  const service = { schema: () => ({ from: makeChain, rpc }) } as any;
  const req = new Request("http://localhost/attempt-response", {
    method: "POST",
    headers: { "content-type": "application/json", authorization: "Bearer test-token" },
    body: JSON.stringify({
      operation: "propose_transcript",
      idempotency_key: crypto.randomUUID(),
      attempt_id: ids.attempt,
      response_version_id: ids.response,
    }),
  });
  return { ids, service, req, rpcCalls, tablesQueried };
}

Deno.test("propose_transcript: a sample:* refusal from sample_take_photo_run is a typed 403", async () => {
  const { ids, service, req, tablesQueried } = proposeTranscriptFixture({
    data: null,
    error: { message: "sample:extraction_limit_reached" },
  });
  const res = await handleAttemptResponse(req, { service, requireProfile: fakeAuth({ id: ids.user }, "admin") });
  assertEquals(res.status, 403);
  assertEquals(await res.json(), { error: "sample:extraction_limit_reached", access: "sample" });
  // Nothing past the gate ran: no ledger/cap query, no model call.
  assertEquals(tablesQueried.includes("model_usage_ledger"), false);
});

Deno.test("propose_transcript: an unexpected sample_take_photo_run failure fails CLOSED with 503, never continues to extraction", async () => {
  const { ids, service, req, tablesQueried } = proposeTranscriptFixture({
    data: null,
    error: { message: "connection reset" },
  });
  const res = await handleAttemptResponse(req, { service, requireProfile: fakeAuth({ id: ids.user }, "admin") });
  assertEquals(res.status, 503);
  assertEquals(await res.json(), { error: "sample_photo_check_failed" });
  assertEquals(tablesQueried.includes("model_usage_ledger"), false);
});

Deno.test("propose_transcript: 'not_sample' from sample_take_photo_run lets the request continue to the shared caps", async () => {
  const { ids, service, req, tablesQueried } = proposeTranscriptFixture({ data: "not_sample", error: null });
  const res = await handleAttemptResponse(req, { service, requireProfile: fakeAuth({ id: ids.user }, "admin") });
  // Past the sample gate: the shared daily-run cap query ran. The fixture has
  // no model deps, so the request ends somewhere after that; the gate is what
  // is pinned here, not the model path.
  assertEquals(tablesQueried.includes("model_usage_ledger"), true);
  assertEquals(res.status === 403 || res.status === 503, false);
});
