import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  conversionBody,
  type ConversionRow,
  deliverRedditConversions,
  type RedditConversionDeps,
  REDDIT_CONVERSIONS_URL,
} from "./reddit-conversions.ts";

// deno-lint-ignore no-explicit-any
type Any = any;

const NOW = new Date("2026-10-26T12:00:00Z");
const row = (over: Partial<ConversionRow> = {}): ConversionRow => ({
  id: "row-1",
  order_id: "order-1",
  event_type: "PURCHASE",
  click_id: "rdt-click-123",
  value_cents: 3999,
  currency: "usd",
  event_at: "2026-10-26T11:55:00Z",
  attempt_count: 1,
  lease_id: "L1",
  ...over,
});

function harness(rows: ConversionRow[], respond: () => Promise<Response>, over: Partial<RedditConversionDeps> = {}) {
  const calls: Any[] = [];
  const updates: Any[] = [];
  const service = {
    schema: () => ({
      rpc: (fn: string) => {
        calls.push(["rpc", fn]);
        return Promise.resolve({ data: rows, error: null });
      },
      from: () => {
        const b: Any = {
          update: (p: Any) => { updates.push(p); return b; },
          eq: () => b,
          then: (r: Any) => r({ error: null }),
        };
        return b;
      },
    }),
  };
  const deps: RedditConversionDeps = {
    service,
    fetch: ((url: string, init: RequestInit) => {
      calls.push(["fetch", url, init]);
      return respond();
    }) as typeof fetch,
    accessToken: "token-abc",
    pixelId: "a2_jws6uftcrlca",
    testId: null,
    isProduction: true,
    now: () => NOW,
    log: () => {},
    ...over,
  };
  return { deps, calls, updates };
}

Deno.test("the event carries only the click id, the amount and the order id", () => {
  const body = conversionBody(row(), null);
  assertEquals(body, {
    data: {
      events: [{
        event_at: Date.parse("2026-10-26T11:55:00Z"),
        action_source: "WEBSITE",
        type: { tracking_type: "PURCHASE" },
        click_id: "rdt-click-123",
        metadata: { conversion_id: "order-1", currency: "USD", value: 39.99 },
      }],
    },
  });
  assertEquals(conversionBody(row(), "t_1").data.test_id, "t_1");
});

Deno.test("a delivered conversion is posted once with the access token and marked delivered", async () => {
  const h = harness([row()], () => Promise.resolve(new Response("{}", { status: 200 })));
  const summary = await deliverRedditConversions(h.deps);
  assertEquals([summary.claimed, summary.sent], [1, 1]);
  const [, url, init] = h.calls.find((c: Any) => c[0] === "fetch");
  assertEquals(url, REDDIT_CONVERSIONS_URL("a2_jws6uftcrlca"));
  assertEquals(url, "https://ads-api.reddit.com/api/v3/pixels/a2_jws6uftcrlca/conversion_events");
  assertEquals((init.headers as Record<string, string>).Authorization, "Bearer token-abc");
  const sent = JSON.parse(init.body as string);
  assertEquals("test_id" in sent.data, false);
  assertEquals(h.updates[0].delivered_at, NOW.toISOString());
});

Deno.test("without a token or pixel id nothing is claimed or sent", async () => {
  for (const over of [{ accessToken: null }, { pixelId: null }]) {
    const h = harness([row()], () => Promise.resolve(new Response("{}")), over);
    const summary = await deliverRedditConversions(h.deps);
    assertEquals(summary.skipped, "not_configured");
    assertEquals(h.calls.length, 0);
  }
});

Deno.test("outside Production a test id is required and is always sent", async () => {
  const none = harness([row()], () => Promise.resolve(new Response("{}")), { isProduction: false });
  assertEquals((await deliverRedditConversions(none.deps)).skipped, "test_id_required");
  assertEquals(none.calls.length, 0);

  const withTest = harness([row()], () => Promise.resolve(new Response("{}")), { isProduction: false, testId: "t_dev" });
  await deliverRedditConversions(withTest.deps);
  const [, , init] = withTest.calls.find((c: Any) => c[0] === "fetch");
  assertEquals(JSON.parse(init.body as string).data.test_id, "t_dev");
});

Deno.test("429 and 5xx retry with backoff; other 4xx go to review; timeouts retry", async () => {
  const rate = harness([row()], () => Promise.resolve(new Response("", { status: 429 })));
  await deliverRedditConversions(rate.deps);
  assertEquals([rate.updates[0].last_error, rate.updates[0].needs_review], ["reddit_http_429", false]);
  assertEquals(rate.updates[0].next_attempt_at, new Date(NOW.getTime() + 5 * 60_000).toISOString());

  const bad = harness([row()], () => Promise.resolve(new Response("", { status: 400 })));
  await deliverRedditConversions(bad.deps);
  assertEquals([bad.updates[0].last_error, bad.updates[0].needs_review], ["reddit_http_400", true]);

  const timeout = harness([row({ attempt_count: 3 })], () => Promise.reject(new DOMException("t", "TimeoutError")));
  await deliverRedditConversions(timeout.deps);
  assertEquals([timeout.updates[0].last_error, timeout.updates[0].needs_review], ["TimeoutError", false]);
  assertEquals(timeout.updates[0].next_attempt_at, new Date(NOW.getTime() + 45 * 60_000).toISOString());

  const tired = harness([row({ attempt_count: 8 })], () => Promise.resolve(new Response("", { status: 503 })));
  await deliverRedditConversions(tired.deps);
  assertEquals(tired.updates[0].needs_review, true);
});

Deno.test("an event older than Reddit's seven-day window is held for review, not sent", async () => {
  const h = harness([row({ event_at: "2026-10-18T11:00:00Z" })], () => Promise.resolve(new Response("{}")));
  const summary = await deliverRedditConversions(h.deps);
  assertEquals(summary.held, 1);
  assertEquals(h.calls.some((c: Any) => c[0] === "fetch"), false);
  assertEquals([h.updates[0].needs_review, h.updates[0].last_error], [true, "event_too_old"]);
});
