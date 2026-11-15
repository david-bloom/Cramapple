// Imported FIRST by index_test.ts so _shared/supabase.ts and _shared/cors.ts
// (both fail-fast on module load) see values. The handler tests inject a fake
// rpc and never touch the real client.
Deno.env.set("SUPABASE_URL", "http://localhost:54321");
Deno.env.set("SUPABASE_ANON_KEY", "test-anon-key");
Deno.env.set("SUPABASE_SERVICE_ROLE_KEY", "test-service-role-key");
Deno.env.set("ALLOWED_ORIGINS", "https://cramapple.com");
Deno.env.set("SAMPLE_ACCESS_ENABLED", "false");
