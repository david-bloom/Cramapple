async function loadAuth() {
  Deno.env.set("SUPABASE_URL", "https://example.supabase.co");
  Deno.env.set("SUPABASE_ANON_KEY", "anon-key");
  Deno.env.set("SUPABASE_SERVICE_ROLE_KEY", "service-role-key");
  return await import("./auth.ts");
}

Deno.test("getBearerToken extracts a bearer token", async () => {
  const { getBearerToken } = await loadAuth();
  const req = new Request("https://example.test", {
    headers: {
      Authorization: "Bearer user.jwt.token",
    },
  });

  if (getBearerToken(req) !== "user.jwt.token") {
    throw new Error("expected bearer token");
  }
});

Deno.test("getBearerToken returns null when authorization is missing or not bearer", async () => {
  const { getBearerToken } = await loadAuth();
  const missing = new Request("https://example.test");
  const basic = new Request("https://example.test", {
    headers: {
      Authorization: "Basic abc123",
    },
  });

  if (getBearerToken(missing) !== null) {
    throw new Error("expected null for missing auth header");
  }
  if (getBearerToken(basic) !== null) {
    throw new Error("expected null for non-bearer auth header");
  }
});
