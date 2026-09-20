// Imported FIRST by index_test.ts so these are set before index.ts ->
// _shared/supabase.ts / _shared/cors.ts evaluate their fail-fast requireEnv()
// calls at module load. The handler tests inject a fake service client and
// never touch the real one, so these values only need to exist, not be
// valid. Same pattern as ../capture-pairing/_test_setup.ts.
Deno.env.set("SUPABASE_URL", "http://localhost:54321");
Deno.env.set("SUPABASE_ANON_KEY", "test-anon-key");
Deno.env.set("SUPABASE_SERVICE_ROLE_KEY", "test-service-role-key");
Deno.env.set("ALLOWED_ORIGINS", "https://cramapple.com");
// The new submit-time entitlement gate reads this at module load and it
// cannot be toggled per-test-case (it's a module-level const, same as
// evaluate-attempt's own flag) -- set to "true" to match real Production
// configuration, since that's the state worth pinning with tests. See
// index_test.ts's file header for which branch this leaves untested and why.
Deno.env.set("GRADING_ENTITLEMENTS_ENABLED", "true");
