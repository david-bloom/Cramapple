// Imported FIRST by index_test.ts so these are set before index.ts ->
// _shared/supabase.ts's requireEnv() calls evaluate at module load. The
// handler tests inject a fake service client and never touch the real one,
// so these values only need to exist, not be valid. Same pattern as
// ../start-trial/_test_setup.ts.
Deno.env.set("SUPABASE_URL", "http://localhost:54321");
Deno.env.set("SUPABASE_ANON_KEY", "test-anon-key");
Deno.env.set("SUPABASE_SERVICE_ROLE_KEY", "test-service-role-key");
Deno.env.set("ALLOWED_ORIGINS", "https://cramapple.com");
