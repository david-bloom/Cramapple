async function loadCors() {
  Deno.env.set(
    "ALLOWED_ORIGINS",
    "https://cramapple.vercel.app,http://localhost:5173",
  );
  return await import("./cors.ts");
}

Deno.test("withCors echoes only configured origins", async () => {
  const { withCors } = await loadCors();

  const allowedReq = new Request("https://example.test", {
    headers: { Origin: "https://cramapple.vercel.app" },
  });
  const blockedReq = new Request("https://example.test", {
    headers: { Origin: "https://evil.example" },
  });

  const allowed = withCors({}, allowedReq);
  const blocked = withCors({}, blockedReq);

  if (
    allowed.get("Access-Control-Allow-Origin") !==
      "https://cramapple.vercel.app"
  ) {
    throw new Error("expected configured origin to be echoed");
  }
  if (blocked.has("Access-Control-Allow-Origin")) {
    throw new Error("expected unconfigured origin to receive no CORS origin");
  }
});

Deno.test("withCors does not use wildcard CORS and allows GET preflight", async () => {
  const { withCors } = await loadCors();
  const req = new Request("https://example.test", {
    headers: { Origin: "http://localhost:5173" },
  });

  const headers = withCors({}, req);
  if (headers.get("Access-Control-Allow-Origin") === "*") {
    throw new Error("wildcard CORS is not allowed");
  }
  const methods = headers.get("Access-Control-Allow-Methods") ?? "";
  if (!methods.split(",").map((method) => method.trim()).includes("GET")) {
    throw new Error("expected GET to be listed for review-queue");
  }
});
