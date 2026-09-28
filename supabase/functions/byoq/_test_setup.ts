// Imported FIRST by index_test.ts so the fail-fast env reads in
// _shared/supabase.ts and _shared/cors.ts succeed. Tests inject an in-memory
// store and never touch a real client.
Deno.env.set("SUPABASE_URL", "http://localhost:54321");
Deno.env.set("SUPABASE_ANON_KEY", "test-anon-key");
Deno.env.set("SUPABASE_SERVICE_ROLE_KEY", "test-service-role-key");
Deno.env.set("ALLOWED_ORIGINS", "https://cramapple.com");
