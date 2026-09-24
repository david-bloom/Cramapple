import "../attempt-response/_test_setup.ts";

Deno.env.set("OPENAI_API_KEY", "test-openai-key");
Deno.env.set("OPENAI_MODEL", "test-model");
Deno.env.set("OPENAI_MAX_OUTPUT_TOKENS", "100");
Deno.env.set("OPENAI_INPUT_PRICE_PER_1M", "1");
Deno.env.set("OPENAI_OUTPUT_PRICE_PER_1M", "1");
Deno.env.set("OPENAI_DAILY_CAP_USD", "1");
Deno.env.set("EVALUATE_ATTEMPT_PROMPT_VERSION", "test-v1");
