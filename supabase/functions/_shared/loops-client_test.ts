import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { sendLoopsEvent } from "./loops-client.ts";

Deno.test("sendLoopsEvent no-ops without throwing when LOOPS_SECRET_KEY is unset", async () => {
  Deno.env.delete("LOOPS_SECRET_KEY");
  const originalFetch = globalThis.fetch;
  let called = false;
  globalThis.fetch = (() => {
    called = true;
    throw new Error("fetch should not be called");
  }) as typeof fetch;

  try {
    await sendLoopsEvent({ email: "student@example.com", eventName: "trial_started" });
    assertEquals(called, false);
  } finally {
    globalThis.fetch = originalFetch;
  }
});

Deno.test("sendLoopsEvent posts the event with the configured key", async () => {
  Deno.env.set("LOOPS_SECRET_KEY", "test-key");
  const originalFetch = globalThis.fetch;
  let capturedUrl: string | undefined;
  let capturedInit: RequestInit | undefined;
  globalThis.fetch = ((url: string, init: RequestInit) => {
    capturedUrl = url;
    capturedInit = init;
    return Promise.resolve(new Response("{}", { status: 200 }));
  }) as typeof fetch;

  try {
    await sendLoopsEvent({
      email: "student@example.com",
      eventName: "trial_started",
      eventProperties: { ends_at: "2026-08-23" },
    });

    assertEquals(capturedUrl, "https://app.loops.so/api/v1/events/send");
    const headers = capturedInit?.headers as Record<string, string>;
    assertEquals(headers.Authorization, "Bearer test-key");
    const body = JSON.parse(capturedInit?.body as string);
    assertEquals(body, {
      email: "student@example.com",
      eventName: "trial_started",
      eventProperties: { ends_at: "2026-08-23" },
      contactProperties: {},
    });
  } finally {
    globalThis.fetch = originalFetch;
    Deno.env.delete("LOOPS_SECRET_KEY");
  }
});

Deno.test("sendLoopsEvent does not throw when the Loops API returns an error", async () => {
  Deno.env.set("LOOPS_SECRET_KEY", "test-key");
  const originalFetch = globalThis.fetch;
  globalThis.fetch = (() =>
    Promise.resolve(new Response("nope", { status: 500 }))) as typeof fetch;

  try {
    await sendLoopsEvent({ email: "student@example.com", eventName: "trial_started" });
  } finally {
    globalThis.fetch = originalFetch;
    Deno.env.delete("LOOPS_SECRET_KEY");
  }
});

Deno.test("sendLoopsEvent does not throw when fetch itself rejects", async () => {
  Deno.env.set("LOOPS_SECRET_KEY", "test-key");
  const originalFetch = globalThis.fetch;
  globalThis.fetch = (() => Promise.reject(new Error("network down"))) as typeof fetch;

  try {
    await sendLoopsEvent({ email: "student@example.com", eventName: "trial_started" });
  } finally {
    globalThis.fetch = originalFetch;
    Deno.env.delete("LOOPS_SECRET_KEY");
  }
});
