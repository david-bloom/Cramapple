// Imported FIRST by index_test.ts so these are set before index.ts ->
// _shared/supabase.ts / _shared/cors.ts evaluate their fail-fast requireEnv()
// calls at module load. The handler tests inject a fake service client and
// never touch the real one, so these values only need to exist, not be
// valid. Same pattern as ../attempt-response/_test_setup.ts.
Deno.env.set("SUPABASE_URL", "http://localhost:54321");
Deno.env.set("SUPABASE_ANON_KEY", "test-anon-key");
Deno.env.set("SUPABASE_SERVICE_ROLE_KEY", "test-service-role-key");
Deno.env.set("ALLOWED_ORIGINS", "https://cramapple.com");
// Deliberately left unset: POSTHOG_PROJECT_API_KEY and LOOPS_SECRET_KEY.
// recordGrowthEvent (_shared/growth-events.ts) and sendLoopsEvent
// (_shared/loops-client.ts) both no-op their outbound fetch when their key
// is absent, after doing the one DB write/read this file's fake service
// fakes -- so a real network call is never reachable from this test file.
