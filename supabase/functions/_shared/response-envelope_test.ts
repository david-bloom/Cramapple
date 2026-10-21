import { assertEquals } from "jsr:@std/assert@1";
import { gradingOutputText, responseOutputText, responseUsage } from "./response-envelope.ts";
Deno.test("response envelope retains direct-text precedence and searches content items", () => {
  const output = [{ type: "reasoning" }, { content: [{ type: "output_text", text: "nested" }] }];
  assertEquals(responseOutputText({ output_text: "direct", output }), "direct");
  assertEquals(responseOutputText({ output }), "nested");
  for (const raw of [null, {}, { output: [null, 1, { content: [null, {}] }] }]) assertEquals(responseOutputText(raw), null);
});
Deno.test("feature refusal policies stay explicitly different", () => {
  const raw = { output: [{ content: [{ type: "refusal", refusal: "fixture refusal" }, { type: "output_text", text: "later" }] }] };
  assertEquals(responseOutputText(raw), null);
  assertEquals(gradingOutputText(raw), "later");
});
Deno.test("usage preserves finite numbers and nulls absent or nonnumeric values", () => {
  assertEquals(responseUsage({ usage: { input_tokens: 12, output_tokens: 0 } }), { input_tokens: 12, output_tokens: 0 });
  assertEquals(responseUsage({ usage: { input_tokens: Infinity, output_tokens: "2" } }), { input_tokens: null, output_tokens: null });
  assertEquals(responseUsage(null), { input_tokens: null, output_tokens: null });
});
