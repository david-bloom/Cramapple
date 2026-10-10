import { assertEquals } from "jsr:@std/assert@1";
import {
  CONFIRM_PART_MAX_CHARS,
  CONFIRMATION_KEYS,
  confirmationIsStale,
  deriveItemParts,
  inferStudentAdded,
  isTranscriptConfirmed,
  readResponseParts,
  readTranscriptRecord,
  transcriptView,
  validateConfirmedParts,
} from "./response-transcript.ts";

Deno.test("deriveItemParts reads part_key with either prompt spelling and never copies other fields", () => {
  const parts = deriveItemParts({
    parts: [
      { part_key: "a", prompt: "Draw it.", expected_answer: "SECRET" },
      { part_key: "b", prompt_text: "Explain.", criteria: ["x"] },
      { part_key: "a", prompt: "dup" },
      { nope: true },
    ],
    expected_graph_spec: { secret: true },
  });
  assertEquals(parts, [
    { part_key: "a", prompt_text: "Draw it." },
    { part_key: "b", prompt_text: "Explain." },
  ]);
  assertEquals(JSON.stringify(parts).includes("SECRET"), false);
});

Deno.test("deriveItemParts falls back to a single `response` part", () => {
  assertEquals(deriveItemParts(null), [{ part_key: "response", prompt_text: null }]);
  assertEquals(deriveItemParts({ parts: [] }), [{ part_key: "response", prompt_text: null }]);
  assertEquals(deriveItemParts("junk"), [{ part_key: "response", prompt_text: null }]);
});

Deno.test("readResponseParts tolerates objects, JSON strings, and junk", () => {
  assertEquals(readResponseParts({ a: 1 }), { a: 1 });
  assertEquals(readResponseParts('{"a":1}'), { a: 1 });
  assertEquals(readResponseParts("[1]"), {});
  assertEquals(readResponseParts(null), {});
});

Deno.test("a confirmation is stale when the bound photo changed", () => {
  const d = "a".repeat(64);
  assertEquals(confirmationIsStale({ _confirmed_at: "T", _confirmed_digest: d }, d), false);
  assertEquals(confirmationIsStale({ _confirmed_at: "T", _confirmed_digest: d }, "b".repeat(64)), true);
  assertEquals(confirmationIsStale({ _confirmed_at: "T" }, d), true);
  assertEquals(confirmationIsStale({}, d), false);
  assertEquals(isTranscriptConfirmed({ _confirmed_at: "" }), false);
  assertEquals(CONFIRMATION_KEYS.includes("_confirmed_content_digest"), true);
});

const ITEM = [{ part_key: "a", prompt_text: null }, { part_key: "b", prompt_text: null }];

Deno.test("validateConfirmedParts fills every item part, refuses unknown keys, and flattens", () => {
  const ok = validateConfirmedParts({ itemParts: ITEM, submitted: { b: "  B answer\r\n" }, studentAdded: { b: ["B answer", "", 42] } });
  assertEquals(ok.ok, true);
  if (!ok.ok) return;
  assertEquals(ok.parts, { a: "", b: "B answer" });
  assertEquals(ok.studentAdded, { b: ["B answer"] });
  assertEquals(ok.responseText, "(a) \n\n(b) B answer");
  assertEquals(validateConfirmedParts({ itemParts: ITEM, submitted: { c: "x" }, studentAdded: null }), { ok: false, reason: "unknown_part" });
  assertEquals(validateConfirmedParts({ itemParts: ITEM, submitted: { a: "x".repeat(CONFIRM_PART_MAX_CHARS + 1) }, studentAdded: null }), { ok: false, reason: "part_too_long" });
  assertEquals(validateConfirmedParts({ itemParts: ITEM, submitted: { a: "  " }, studentAdded: null }), { ok: false, reason: "transcript_empty" });
  assertEquals(validateConfirmedParts({ itemParts: ITEM, submitted: { a: "x" }, studentAdded: ["bad"] }), { ok: false, reason: "student_added_invalid" });
  assertEquals(validateConfirmedParts({ itemParts: ITEM, submitted: { a: "x" }, studentAdded: { a: "bad" } }), { ok: false, reason: "student_added_invalid" });
});

Deno.test("readTranscriptRecord reads only a well-formed record", () => {
  assertEquals(readTranscriptRecord({ _transcript: { status: "proposed", key: "k" } })?.key, "k");
  assertEquals(readTranscriptRecord({ _transcript: { nope: 1 } }), null);
});

Deno.test("inferStudentAdded names lines the model never proposed", () => {
  assertEquals(
    inferStudentAdded({ proposed: { a: "slope = 2\nintercept = 1", b: "" }, confirmed: { a: "slope = 2\nintercept = 1\nr = 0.9", b: "typed whole answer" } }),
    { a: ["r = 0.9"], b: ["typed whole answer"] },
  );
  assertEquals(inferStudentAdded({ proposed: { a: "same" }, confirmed: { a: "same" } }), {});
});

Deno.test("transcriptView exposes the proposal and status, never a judgement", () => {
  const view = transcriptView({
    status: "proposed", key: "k", model: "m", prompt_version: "v", page_digests: ["d"],
    proposed: { parts: [{ part_key: "a", text: "t", unreadable_regions: [], visual_elements: [] }], unassigned_text: "", page_blank: false, printed_answer_key_present: false, possible_personal_information: false },
    warnings: [], failure: null, latency_ms: 1, created_at: "T",
  });
  assertEquals(Object.keys(view ?? {}).sort(), ["created_at", "failure", "latency_ms", "model", "prompt_version", "proposed", "status", "warnings"]);
  assertEquals(transcriptView(null), null);
});
