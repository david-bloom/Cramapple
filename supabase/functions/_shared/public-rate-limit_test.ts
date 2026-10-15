import {
  checkPublicRateLimit,
  PUBLIC_ENDPOINT_LIMITS,
  type RateLimitRpc,
} from "./public-rate-limit.ts";

function assertEquals(actual: unknown, expected: unknown) {
  if (JSON.stringify(actual) !== JSON.stringify(expected)) {
    throw new Error(
      `Expected ${JSON.stringify(expected)}, received ${JSON.stringify(actual)}`,
    );
  }
}

const limit = PUBLIC_ENDPOINT_LIMITS.resolveParentLink;
const req = (ip?: string) =>
  new Request("https://x.test", {
    method: "POST",
    headers: ip ? { "x-forwarded-for": ip } : {},
  });

Deno.test("allowed responses pass through and send limits to the database", async () => {
  let seen: Record<string, unknown> = {};
  const rpc: RateLimitRpc = (_fn, args) => {
    seen = args;
    return Promise.resolve({ data: { allowed: true }, error: null });
  };
  const result = await checkPublicRateLimit(req("203.0.113.9"), limit, {
    rpc,
    hmacKey: "k",
  });
  assertEquals(result, { allowed: true });
  assertEquals(seen.p_endpoint, "resolve-parent-link");
  assertEquals(seen.p_per_key_limit, limit.perIpPerHour);
  assertEquals(seen.p_global_limit, limit.globalPerHour);
});

Deno.test("the raw IP is never sent to the database", async () => {
  let seen = "";
  const rpc: RateLimitRpc = (_fn, args) => {
    seen = JSON.stringify(args);
    return Promise.resolve({ data: { allowed: true }, error: null });
  };
  await checkPublicRateLimit(req("203.0.113.9"), limit, { rpc, hmacKey: "k" });
  assertEquals(seen.includes("203.0.113.9"), false);
});

Deno.test("a denial returns the database's retry-after", async () => {
  const rpc: RateLimitRpc = () =>
    Promise.resolve({
      data: { allowed: false, scope: "key", retry_after_seconds: 421 },
      error: null,
    });
  const result = await checkPublicRateLimit(req("198.51.100.1"), limit, {
    rpc,
    hmacKey: "k",
  });
  assertEquals(result, { allowed: false, retryAfterSeconds: 421 });
});

Deno.test("a malformed retry-after falls back to 60 seconds", async () => {
  const rpc: RateLimitRpc = () =>
    Promise.resolve({ data: { allowed: false }, error: null });
  const result = await checkPublicRateLimit(req("198.51.100.1"), limit, {
    rpc,
    hmacKey: "k",
  });
  assertEquals(result, { allowed: false, retryAfterSeconds: 60 });
});

Deno.test("limiter errors fail open so payments are never blocked", async () => {
  const errorRpc: RateLimitRpc = () =>
    Promise.resolve({ data: null, error: { message: "db down" } });
  const throwRpc: RateLimitRpc = () => {
    throw new Error("boom");
  };
  assertEquals(
    await checkPublicRateLimit(req("198.51.100.1"), limit, {
      rpc: errorRpc,
      hmacKey: "k",
    }),
    { allowed: true },
  );
  assertEquals(
    await checkPublicRateLimit(req("198.51.100.1"), limit, {
      rpc: throwRpc,
      hmacKey: "k",
    }),
    { allowed: true },
  );
});

Deno.test("a request with no IP still gets a (shared) bucket", async () => {
  let called = false;
  const rpc: RateLimitRpc = () => {
    called = true;
    return Promise.resolve({ data: { allowed: true }, error: null });
  };
  await checkPublicRateLimit(req(), limit, { rpc, hmacKey: "k" });
  assertEquals(called, true);
});
