import { assertEquals } from "https://deno.land/std@0.224.0/assert/mod.ts";
import { questionParts } from "./grounding.ts";

Deno.test("authored parts preserve order and exact prompts while discarding answer fields", () => {
  assertEquals(
    questionParts([
      {
        key: "a",
        prompt: "Explain your setup.",
        answer: "private",
        criteria: ["private"],
      },
      { key: "b", prompt: "Calculate the value." },
    ]),
    [{ key: "a", prompt: "Explain your setup." }, {
      key: "b",
      prompt: "Calculate the value.",
    }],
  );
});
Deno.test("partial or duplicate authored prompts fail closed instead of silently disappearing", () => {
  assertEquals(
    questionParts([{ key: "a", prompt: "Explain." }, { key: "b" }]),
    null,
  );
  assertEquals(
    questionParts([{ key: "a", prompt: "Explain." }, {
      key: "a",
      prompt: "Calculate.",
    }]),
    null,
  );
  assertEquals(questionParts("not an array"), null);
  assertEquals(questionParts(undefined), []);
});
