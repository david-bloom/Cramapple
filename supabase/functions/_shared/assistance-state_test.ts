import { deriveAssistanceState } from "./assistance-state.ts";

function assert(cond: boolean, msg: string) {
  if (!cond) throw new Error(msg);
}

Deno.test("deriveAssistanceState forces coached when a pre-submission hint was logged", () => {
  assert(
    deriveAssistanceState("independent", 1) === "coached",
    "one pre-submission hint should force coached even if the client claimed independent",
  );
  assert(
    deriveAssistanceState("independent", 3) === "coached",
    "multiple pre-submission hints should still just be coached",
  );
});

Deno.test("deriveAssistanceState never overrides exam_practice with independent", () => {
  assert(
    deriveAssistanceState("exam_practice", 0) === "exam_practice",
    "zero logged hints must not downgrade a declared exam_practice attempt",
  );
});

Deno.test("deriveAssistanceState passes the client value through when no hint was logged", () => {
  assert(
    deriveAssistanceState("independent", 0) === "independent",
    "no pre-submission hint leaves the client's independent claim as-is",
  );
  assert(
    deriveAssistanceState(null, 0) === null,
    "a null client value with no hints stays null rather than being invented",
  );
});

Deno.test("deriveAssistanceState treats a missing count the same as zero", () => {
  assert(
    deriveAssistanceState("independent", null) === "independent",
    "null pre_submit_hint_count (e.g. a pre-migration row) must not be treated as coached",
  );
});
