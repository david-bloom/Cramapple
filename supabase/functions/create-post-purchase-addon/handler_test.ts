import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";

Deno.test("add-on handler rejects anonymous and wrong-owner callers before Stripe access", async () => {
  const values = {
    SUPABASE_URL: "https://example.com",
    SUPABASE_ANON_KEY: "test-anon",
    SUPABASE_SERVICE_ROLE_KEY: "test-service",
    STRIPE_SECRET_KEY: "sk_test_fixture",
    APP_BASE_URL: "https://example.com",
    ALLOWED_ORIGINS: "https://example.com",
  };
  const old = Object.fromEntries(
    Object.keys(values).map((key) => [key, Deno.env.get(key)]),
  );
  const originalFetch = globalThis.fetch;
  let requests: string[] = [];
  try {
    for (const [key, value] of Object.entries(values)) Deno.env.set(key, value);
    const { handlePostPurchaseAddon } = await import("./handler.ts");
    globalThis.fetch = ((input: RequestInfo | URL) => {
      const url = String(input instanceof Request ? input.url : input);
      requests.push(url);
      if (url.includes("/auth/v1/user")) {
        return Promise.resolve(Response.json({
          id: "wrong-learner",
          aud: "authenticated",
          email: "s@example.com",
        }));
      }
      if (url.includes("/rest/v1/stripe_checkout_sessions")) {
        return Promise.resolve(Response.json({
          id: "cs_test",
          user_id: "actual-learner",
          mode: "single",
          payment_status: "paid",
          subject_keys: ["biology"],
          metadata: { purchase_type: "student_direct" },
        }));
      }
      throw new Error("unexpected_external_request");
    }) as typeof fetch;
    const request = (token?: string) =>
      new Request("https://example.com/addon", {
        method: "POST",
        headers: token ? { Authorization: `Bearer ${token}` } : {},
        body: JSON.stringify({
          source_checkout_session_id: "cs_test",
          subject_key: "statistics",
        }),
      });
    assertEquals((await handlePostPurchaseAddon(request())).status, 401);
    assertEquals(requests.length, 0);
    assertEquals(
      (await handlePostPurchaseAddon(request("test-jwt"))).status,
      403,
    );
    assertEquals(requests.length, 2);
    assertEquals(requests.some((url) => url.includes("stripe.com")), false);
    assertEquals(
      requests.some((url) => url.includes("stripe_customers")),
      false,
    );

    requests = [];
    globalThis.fetch = (() => {
      requests.push("auth");
      return Promise.resolve(
        Response.json({ message: "invalid token" }, { status: 401 }),
      );
    }) as typeof fetch;
    assertEquals(
      (await handlePostPurchaseAddon(request("invalid-jwt"))).status,
      401,
    );
    assertEquals(requests, ["auth"]);
  } finally {
    globalThis.fetch = originalFetch;
    for (const [key, value] of Object.entries(old)) {
      if (value === undefined) Deno.env.delete(key);
      else Deno.env.set(key, value);
    }
  }
});
