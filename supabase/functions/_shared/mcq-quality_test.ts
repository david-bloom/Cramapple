import { assertEquals } from "https://deno.land/std@0.208.0/assert/mod.ts";
import { checkAnswerLengthParity } from "./mcq-quality.ts";

Deno.test("flags a correct answer well past the length-parity threshold", () => {
  const finding = checkAnswerLengthParity([
    { choice_text: "A".repeat(20), is_correct: false },
    { choice_text: "B".repeat(20), is_correct: false },
    { choice_text: "C".repeat(20), is_correct: false },
    { choice_text: "D".repeat(40), is_correct: true },
  ]);
  assertEquals(finding?.code, "MCQ_CORRECT_ANSWER_LENGTH_OUTLIER");
  assertEquals(finding?.ratio, 2);
});

Deno.test("does not flag roughly equal-length choices", () => {
  const finding = checkAnswerLengthParity([
    { choice_text: "A".repeat(20), is_correct: false },
    { choice_text: "B".repeat(22), is_correct: false },
    { choice_text: "C".repeat(19), is_correct: false },
    { choice_text: "D".repeat(21), is_correct: true },
  ]);
  assertEquals(finding, null);
});

Deno.test("does not flag a shorter correct answer", () => {
  const finding = checkAnswerLengthParity([
    { choice_text: "A".repeat(40), is_correct: false },
    { choice_text: "B".repeat(40), is_correct: false },
    { choice_text: "C".repeat(40), is_correct: false },
    { choice_text: "D".repeat(20), is_correct: true },
  ]);
  assertEquals(finding, null);
});

Deno.test("is a no-op for malformed input (no correct answer, no distractors)", () => {
  assertEquals(
    checkAnswerLengthParity([
      { choice_text: "A", is_correct: false },
      { choice_text: "B", is_correct: false },
    ]),
    null,
  );
  assertEquals(
    checkAnswerLengthParity([
      { choice_text: "A", is_correct: true },
      { choice_text: "B", is_correct: true },
    ]),
    null,
  );
});
