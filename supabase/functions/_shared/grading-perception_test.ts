import { assessTranscriptionReadiness, canReuseConfirmedTranscription } from "./grading-perception.ts";

Deno.test("handwriting cannot be graded while any transcription ambiguity remains", () => {
  const result = assessTranscriptionReadiness({ captureQuality: "pass", lines: [{ line_id: "1", text: "x = 7", confidence: 0.8, ambiguous_spans: ["7"], learner_confirmed: true }] });
  if (result.gradable || result.status !== "needs_confirmation") throw new Error("ambiguous text must fail closed");
});

Deno.test("confirmed transcription reuse is invalidated by any perception input change", () => {
  const previous = { imageHash: "a", preprocessingVersion: "p1", transcriptionVersion: "t1", confirmed: true };
  if (!canReuseConfirmedTranscription(previous, { imageHash: "a", preprocessingVersion: "p1", transcriptionVersion: "t1" })) throw new Error("identical confirmed input should be reusable");
  if (canReuseConfirmedTranscription(previous, { imageHash: "b", preprocessingVersion: "p1", transcriptionVersion: "t1" })) throw new Error("changed image must invalidate transcription reuse");
});
