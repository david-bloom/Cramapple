// Handler tests for sample-try (PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md §3).
// The rules live in SQL (app.sample_try_*); these pin the edge contract: the
// flag, rate limiting, input validation, token hashing (the SQL only ever
// sees sha256 hex), the once-only plaintext token, and the typed error map.

import "./_test_setup.ts";
import { assert, assertEquals, assertMatch } from "jsr:@std/assert@1";
import { handleSampleTry, mapSqlError, sha256Hex } from "./index.ts";

type Call = { fn: string; args: Record<string, unknown> };

function fakeRpc(
  responder: (fn: string, args: Record<string, unknown>) => { data?: unknown; error?: { message: string; details?: string } },
) {
  const calls: Call[] = [];
  const rpc = (fn: string, args: Record<string, unknown>) => {
    calls.push({ fn, args });
    const r = responder(fn, args);
    return Promise.resolve({ data: r.data ?? null, error: r.error ?? null });
  };
  return { rpc, calls };
}

const allow = () => Promise.resolve({ allowed: true as const });

function post(body: unknown, headers: Record<string, string> = {}) {
  return new Request("http://localhost/functions/v1/sample-try", {
    method: "POST",
    headers: { "content-type": "application/json", ...headers },
    body: JSON.stringify(body),
  });
}

Deno.test("flag off: every operation is 503 sample_disabled before any rpc", async () => {
  const { rpc, calls } = fakeRpc(() => ({ data: [] }));
  const res = await handleSampleTry(post({ operation: "list_units", subject_key: "biology" }), {
    enabled: false,
    rpc,
    rateLimit: allow,
  });
  assertEquals(res.status, 503);
  assertEquals((await res.json()).error, "sample_disabled");
  assertEquals(calls.length, 0);
});

Deno.test("rate limited start returns 429 with Retry-After and calls no rpc", async () => {
  const { rpc, calls } = fakeRpc(() => ({ data: {} }));
  const res = await handleSampleTry(post({ operation: "start", subject_key: "biology", unit_number: 1 }), {
    enabled: true,
    rpc,
    rateLimit: () => Promise.resolve({ allowed: false, retryAfterSeconds: 42 }),
  });
  assertEquals(res.status, 429);
  assertEquals(res.headers.get("Retry-After"), "42");
  assertEquals(calls.length, 0);
});

Deno.test("list_units passes the subject key through and is not rate limited", async () => {
  const units = [{ unit_number: 1, eligible: true, mcq_available: 20, frq_available: 3 }];
  const { rpc, calls } = fakeRpc((fn) => fn === "sample_unit_availability" ? { data: units } : { data: null });
  const res = await handleSampleTry(post({ operation: "list_units", subject_key: "ap-statistics" }), {
    enabled: true,
    rpc,
    rateLimit: () => Promise.resolve({ allowed: false, retryAfterSeconds: 9 }),
  });
  assertEquals(res.status, 200);
  const json = await res.json();
  assertEquals(json.result.units, units);
  assertEquals(calls[0].args.p_subject_key, "ap-statistics");
});

Deno.test("start hashes tokens: SQL sees sha256 hex, the browser gets the plaintext once", async () => {
  const existing = "existing-token-existing-token-existing-token-0001";
  const issued = "new-token-new-token-new-token-new-token-0002";
  const { rpc, calls } = fakeRpc((fn) =>
    fn === "sample_try_start"
      ? { data: { outcome: "created", issued_new_token: true, try: { try_id: "t1", question: { choices: [] } } } }
      : { data: null }
  );
  const res = await handleSampleTry(
    post({
      operation: "start",
      subject_key: "biology",
      unit_number: 2,
      try_token: existing,
      ad_attribution: { ad_tracking_allowed: false, first_touch: { utm_source: "reddit", reddit_click_id: "x" } },
    }, { "cf-connecting-ip": "203.0.113.9" }),
    { enabled: true, rpc, rateLimit: allow, hmacKey: "k", newToken: () => issued },
  );
  assertEquals(res.status, 200);
  const json = await res.json();
  assertEquals(json.result.outcome, "created");
  assertEquals(json.result.try_token, issued);
  const args = calls[0].args;
  assertEquals(args.p_existing_token_hash, await sha256Hex(existing));
  assertEquals(args.p_new_token_hash, await sha256Hex(issued));
  assertMatch(String(args.p_ip_hmac), /^[0-9a-f]{64}$/);
  assertEquals(args.p_unit_number, 2);
  // Attribution is the checkout's allow-list: click ids drop when tracking is refused.
  const attribution = args.p_attribution as Record<string, unknown>;
  assertEquals(attribution.ad_tracking_allowed, false);
  assertEquals((attribution.first_touch as Record<string, unknown>).utm_source, "reddit");
  assertEquals((attribution.first_touch as Record<string, unknown>).reddit_click_id, undefined);
  // Never the plaintext anywhere in the rpc call.
  assert(!JSON.stringify(args).includes(issued));
  assert(!JSON.stringify(args).includes(existing));
});

Deno.test("start resumed: no new token is issued", async () => {
  const { rpc } = fakeRpc(() => ({ data: { outcome: "resumed", issued_new_token: false, try: { try_id: "t1" } } }));
  const res = await handleSampleTry(
    post({ operation: "start", subject_key: "biology", unit_number: 1, try_token: "a".repeat(40) }),
    { enabled: true, rpc, rateLimit: allow, newToken: () => "b".repeat(40) },
  );
  const json = await res.json();
  assertEquals(json.result.outcome, "resumed");
  assertEquals(json.result.try_token, null);
});

Deno.test("start on an answered token is 409 register_required with the try summary", async () => {
  const { rpc } = fakeRpc(() => ({
    data: { outcome: "register_required", issued_new_token: false, try: { try_id: "t1", status: "answered" } },
  }));
  const res = await handleSampleTry(
    post({ operation: "start", subject_key: "biology", unit_number: 1, try_token: "a".repeat(40) }),
    { enabled: true, rpc, rateLimit: allow },
  );
  assertEquals(res.status, 409);
  const json = await res.json();
  assertEquals(json.error, "register_required");
  assertEquals(json.try.status, "answered");
});

Deno.test("start maps SQL unit_unavailable to 409 with the availability list", async () => {
  const units = [{ unit_number: 1, eligible: true }, { unit_number: 7, eligible: false }];
  const { rpc } = fakeRpc(() => ({ error: { message: "sample_try:unit_unavailable", details: JSON.stringify(units) } }));
  const res = await handleSampleTry(post({ operation: "start", subject_key: "biology", unit_number: 7 }), {
    enabled: true,
    rpc,
    rateLimit: allow,
  });
  assertEquals(res.status, 409);
  const json = await res.json();
  assertEquals(json.error, "sample_unit_unavailable");
  assertEquals(json.units, units);
});

Deno.test("answer requires a well-formed token and choice key", async () => {
  const { rpc, calls } = fakeRpc(() => ({ data: {} }));
  const deps = { enabled: true, rpc, rateLimit: allow };
  let res = await handleSampleTry(post({ operation: "answer", choice_key: "B" }), deps);
  assertEquals(res.status, 400);
  res = await handleSampleTry(post({ operation: "answer", try_token: "short", choice_key: "B" }), deps);
  assertEquals(res.status, 400);
  res = await handleSampleTry(post({ operation: "answer", try_token: "a".repeat(40), choice_key: "B; drop" }), deps);
  assertEquals(res.status, 400);
  assertEquals(calls.length, 0);
});

Deno.test("answer passes the token hash and returns register_to_save", async () => {
  const token = "c".repeat(48);
  const { rpc, calls } = fakeRpc(() => ({
    data: { outcome: "answered", try: { try_id: "t1", feedback: { earned: 1, possible: 1, choices: [] } } },
  }));
  const res = await handleSampleTry(post({ operation: "answer", try_token: token, choice_key: "B" }), {
    enabled: true,
    rpc,
    rateLimit: allow,
  });
  assertEquals(res.status, 200);
  const json = await res.json();
  assertEquals(json.result.register_to_save, true);
  assertEquals(json.result.try.feedback.earned, 1);
  assertEquals(calls[0].fn, "sample_try_answer");
  assertEquals(calls[0].args.p_token_hash, await sha256Hex(token));
  assertEquals(calls[0].args.p_choice_key, "B");
});

Deno.test("answer on an already answered try is 409 with the stored feedback", async () => {
  const stored = { try_id: "t1", status: "answered", feedback: { picked_choice_key: "A" } };
  const { rpc } = fakeRpc(() => ({ error: { message: "sample_try:already_answered", details: JSON.stringify(stored) } }));
  const res = await handleSampleTry(post({ operation: "answer", try_token: "c".repeat(48), choice_key: "B" }), {
    enabled: true,
    rpc,
    rateLimit: allow,
  });
  assertEquals(res.status, 409);
  const json = await res.json();
  assertEquals(json.error, "already_answered");
  assertEquals(json.try.feedback.picked_choice_key, "A");
});

Deno.test("status returns the SQL view", async () => {
  const { rpc } = fakeRpc(() => ({ data: { status: "served", try_id: "t1" } }));
  const res = await handleSampleTry(post({ operation: "status", try_token: "d".repeat(40) }), {
    enabled: true,
    rpc,
    rateLimit: allow,
  });
  assertEquals(res.status, 200);
  assertEquals((await res.json()).result.try.status, "served");
});

Deno.test("mapSqlError: every SQL code has a typed HTTP shape; unknown is 500", () => {
  assertEquals(mapSqlError({ message: "sample_try:disabled" }).status, 503);
  assertEquals(mapSqlError({ message: "sample_try:expired" }).status, 410);
  assertEquals(mapSqlError({ message: "sample_try:switch_limit_reached" }).status, 409);
  assertEquals(mapSqlError({ message: "sample_try:invalid_choice" }).status, 400);
  assertEquals(mapSqlError({ message: "sample_try:not_found" }).status, 404);
  assertEquals(mapSqlError({ message: "boom" }).status, 500);
  assertEquals(mapSqlError({ message: "boom" }).body.error, "sample_try_failed");
});

Deno.test("invalid operation and non-POST are refused", async () => {
  const { rpc } = fakeRpc(() => ({ data: {} }));
  const deps = { enabled: true, rpc, rateLimit: allow };
  assertEquals((await handleSampleTry(post({ operation: "purge" }), deps)).status, 400);
  assertEquals(
    (await handleSampleTry(new Request("http://localhost/functions/v1/sample-try", { method: "GET" }), deps)).status,
    405,
  );
});
