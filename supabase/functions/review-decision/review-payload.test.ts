import {
  assertEquals,
} from "jsr:@std/assert@1.0.14";
import {
  hasExactChoiceKeys,
  normalizeAnswerApprovals,
  requiresTutorNote,
  resolveTutorScore,
} from "./review-payload.ts";

Deno.test("normalizes four explicit MCQ choice decisions", () => {
  assertEquals(normalizeAnswerApprovals([
    { choice_key: "a", approved: true },
    { choice_key: "B", approved: false },
    { choice_key: "C", approved: true },
    { choice_key: "D", approved: true },
  ]), [
    { choice_key: "A", approved: true },
    { choice_key: "B", approved: false },
    { choice_key: "C", approved: true },
    { choice_key: "D", approved: true },
  ]);
});

Deno.test("requires a note for non-approval or any rejected MCQ choice", () => {
  assertEquals(requiresTutorNote(1, [
    { choice_key: "A", approved: true },
    { choice_key: "B", approved: true },
  ]), false);
  assertEquals(requiresTutorNote(1, [
    { choice_key: "A", approved: true },
    { choice_key: "B", approved: false },
  ]), true);
  assertEquals(requiresTutorNote(2, null), true);
  assertEquals(requiresTutorNote(3, null), true);
});

Deno.test("requires one decision for every normalized visible choice", () => {
  const approvals = normalizeAnswerApprovals([
    { choice_key: "A", approved: true },
    { choice_key: "B", approved: false },
    { choice_key: "C", approved: true },
    { choice_key: "D", approved: true },
  ])!;
  assertEquals(hasExactChoiceKeys(approvals, ["A", "B", "C", "D"]), true);
  assertEquals(hasExactChoiceKeys(approvals, ["A", "B", "C"]), false);
  assertEquals(hasExactChoiceKeys(approvals, ["A", "B", "C", "D", "D"]), true);
  assertEquals(hasExactChoiceKeys(approvals, ["A"]), false);
});

Deno.test("rejects missing, implicit, and duplicate MCQ choice decisions", () => {
  assertEquals(normalizeAnswerApprovals(undefined), null);
  assertEquals(normalizeAnswerApprovals([
    { choice_key: "A", approved: true },
  ]), null);
  assertEquals(normalizeAnswerApprovals([
    { choice_key: "A", approved: true },
    { choice_key: "A", approved: false },
  ]), null);
  assertEquals(normalizeAnswerApprovals([
    { choice_key: "A", approved: true },
    { choice_key: "B" },
  ]), null);
});

Deno.test("maps tutor decision aliases to canonical scores", () => {
  assertEquals(resolveTutorScore(undefined, "approve"), 1);
  assertEquals(resolveTutorScore(undefined, "approve_with_edits"), 2);
  assertEquals(resolveTutorScore(undefined, "disapprove"), 3);
  assertEquals(resolveTutorScore(2, "approve"), 2);
  assertEquals(resolveTutorScore(undefined, "unknown"), null);
});
