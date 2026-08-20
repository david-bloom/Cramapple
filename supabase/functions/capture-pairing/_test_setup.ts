// Imported FIRST by index_test.ts so these are set before index.ts ->
// _shared/supabase.ts evaluates its fail-fast requireEnv() at module load. The
// handler tests inject a fake service client and never touch the real one, so
// these values only need to exist, not be valid.
Deno.env.set("SUPABASE_URL", "http://localhost:54321");
Deno.env.set("SUPABASE_ANON_KEY", "test-anon-key");
Deno.env.set("SUPABASE_SERVICE_ROLE_KEY", "test-service-role-key");
// index.ts reads these into module-level consts at load time, so they must be
// set here (not inside a test) for the capture-quality metering path to be
// exercised. The model itself is always injected in tests, so the key is never
// used to make a real call; a non-zero cap just makes the reserveCost closure
// take a real reservation the test can assert gets released.
Deno.env.set("OPENAI_API_KEY", "test-openai-key");
Deno.env.set("OPENAI_DAILY_CAP_USD", "1");
// _shared/cors.ts also fails fast on load.
Deno.env.set("ALLOWED_ORIGINS", "https://cramapple.com");
