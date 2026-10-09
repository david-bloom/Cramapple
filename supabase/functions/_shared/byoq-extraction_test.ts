import { assert, assertEquals } from "jsr:@std/assert@1";
import {
  buildExtractionSchema,
  buildExtractionUserText,
  buildExtractionRecord,
  extractionKey,
  extractOutputText,
  normalizeProposal,
  proposalPatch,
  runByoqExtraction,
  TOPIC_UNSURE,
  warningsFor,
} from "./byoq-extraction.ts";

const TOPICS = [{ code: "2.5", title: "Correlation" }, { code: "2.6", title: "Linear Regression Models" }];

function okRaw(overrides: Record<string, unknown> = {}) {
  return {
    is_question: true,
    item_type: "mcq",
    stem: "Which value of r indicates the strongest linear relationship?",
    choices: ["A. r = 0.2", "(B) r = −0.9", "C) r = 0.5", "D. r = −0.1"],
    topic_code: "2.5",
    alternatives: ["2.6", "2.5", "9.9"],
    captured_work: "Option B is circled.",
    answer_key_present: false,
    possible_personal_information: false,
    unreadable_regions: [],
    visual_only_regions: [],
    looks_like_subject: true,
    ...overrides,
  };
}

Deno.test("schema is closed, requires every field, and enumerates only the supplied topics plus unsure", () => {
  const s = buildExtractionSchema(TOPICS);
  assertEquals(s.additionalProperties, false);
  assertEquals([...s.required].sort(), Object.keys(s.properties).sort());
  assertEquals(s.properties.topic_code.enum, ["2.5", "2.6", TOPIC_UNSURE]);
  for (const forbidden of ["answer", "correct", "is_correct", "rationale", "key", "score"]) {
    assert(!(forbidden in s.properties), `schema must not carry ${forbidden}`);
  }
  const empty = buildExtractionSchema([]);
  assertEquals(empty.properties.topic_code.enum, [TOPIC_UNSURE]);
});

Deno.test("user text names subject, unit, and the topic list; says so when there is none", () => {
  const t = buildExtractionUserText({ subjectName: "AP Statistics", unitLabel: "Unit 2: Two-Variable Data", topics: TOPICS, pages: [{ bytes: new Uint8Array(), mediaType: "image/png" }] });
  assert(t.includes("AP Statistics") && t.includes("Unit 2") && t.includes("2.5 — Correlation"));
  const none = buildExtractionUserText({ subjectName: null, unitLabel: null, topics: [], pages: [] });
  assert(none.includes("No topic list"));
});

Deno.test("normalizeProposal strips choice labels, keeps order, drops unknown topics, caps alternatives", () => {
  const p = normalizeProposal(okRaw(), TOPICS)!;
  assertEquals(p.choices, ["r = 0.2", "r = −0.9", "r = 0.5", "r = −0.1"]);
  assertEquals(p.topic_code, "2.5");
  assertEquals(p.alternatives, ["2.6"]); // 2.5 is the chosen topic, 9.9 is not listed
  assertEquals(p.captured_work, "Option B is circled.");
});

Deno.test("normalizeProposal strips a printed question number from the stem but not a number that is content", () => {
  assertEquals(normalizeProposal(okRaw({ stem: "7. Which value of r is largest?" }), TOPICS)!.stem, "Which value of r is largest?");
  assertEquals(normalizeProposal(okRaw({ stem: "(12) Find the limit." }), TOPICS)!.stem, "Find the limit.");
  assertEquals(normalizeProposal(okRaw({ stem: "Q3. Explain." }), TOPICS)!.stem, "Explain.");
  assertEquals(normalizeProposal(okRaw({ stem: "2.5 is the value of r. What does it mean?" }), TOPICS)!.stem, "2.5 is the value of r. What does it mean?");
  assertEquals(normalizeProposal(okRaw({ stem: "3x + 1 = 7. Solve for x." }), TOPICS)!.stem, "3x + 1 = 7. Solve for x.");
});

Deno.test("normalizeProposal rejects missing or mistyped fields instead of defaulting", () => {
  assertEquals(normalizeProposal(null, TOPICS), null);
  assertEquals(normalizeProposal({ ...okRaw(), is_question: "yes" }, TOPICS), null);
  assertEquals(normalizeProposal({ ...okRaw(), item_type: "essay" }, TOPICS), null);
  const { stem: _s, ...noStem } = okRaw();
  assertEquals(normalizeProposal(noStem, TOPICS), null);
});

Deno.test("a printed answer key drops captured_work entirely and raises the warning", () => {
  const p = normalizeProposal(okRaw({ answer_key_present: true, captured_work: "Answer key: B" }), TOPICS)!;
  assertEquals(p.captured_work, null);
  assert(warningsFor(p, true).includes("answer_key_present"));
});

Deno.test("warnings cover every advisory condition", () => {
  const p = normalizeProposal(okRaw({
    is_question: true,
    item_type: "unsure",
    topic_code: "unsure",
    unreadable_regions: ["choice D"],
    visual_only_regions: ["scatterplot"],
    possible_personal_information: true,
    looks_like_subject: false,
    choices: ["1", "2", "3", "4", "5", "6", "7"],
  }), TOPICS)!;
  assertEquals(
    warningsFor(p, true).sort(),
    ["no_topic", "possible_personal_information", "subject_mismatch", "too_many_choices", "type_unsure", "unreadable", "visual_only"],
  );
  assertEquals(warningsFor(normalizeProposal(okRaw({ is_question: false, stem: "" }), TOPICS)!, true), ["not_a_question"]);
  // No topic list supplied: an unsure topic is not a warning.
  assertEquals(warningsFor(normalizeProposal(okRaw({ topic_code: "unsure" }), [])!, false), []);
});

Deno.test("proposalPatch fills only null fields and never overwrites a student's edit", () => {
  const p = normalizeProposal(okRaw(), TOPICS)!;
  const fresh = proposalPatch({ item_type: null, stem: null, choices: [], taxonomy_topic_id: null }, p);
  assertEquals(fresh.filled, ["item_type", "stem", "choices", "topic"]);
  assertEquals(fresh.choices!.map((c) => c.choice_key), ["A", "B", "C", "D"]);
  assertEquals(fresh.topic_code, "2.5");

  const edited = proposalPatch({ item_type: "frq", stem: "My own words", choices: [], taxonomy_topic_id: "t" }, p);
  assertEquals(edited.filled, []);
  assertEquals(edited.stem, undefined);
  assertEquals(edited.choices, undefined); // frq keeps no choices

  const partial = proposalPatch({ item_type: "mcq", stem: "", choices: [{ choice_key: "A", choice_text: "x" }], taxonomy_topic_id: null }, p);
  assertEquals(partial.filled, ["stem", "topic"]);

  const notQuestion = proposalPatch({ item_type: null, stem: null, choices: [], taxonomy_topic_id: null }, { ...p, is_question: false });
  assertEquals(notQuestion.filled, []);
});

Deno.test("proposalPatch refreshes a field that still equals the previous proposal, but never a student edit", () => {
  const p1 = normalizeProposal(okRaw(), TOPICS)!;
  const prev = { item_type: p1.item_type, stem: p1.stem, choices: p1.choices, topic_code: p1.topic_code };
  const p2 = normalizeProposal(okRaw({ stem: "A better read of the same question", choices: ["r = 0.3", "r = −0.9", "r = 0.5", "r = −0.1"], topic_code: "2.6" }), TOPICS)!;
  // Untouched since the first run: everything refreshes.
  const untouched = { item_type: "mcq" as const, stem: p1.stem, choices: p1.choices.map((t, i) => ({ choice_key: String.fromCharCode(65 + i), choice_text: t })), taxonomy_topic_id: "t1", topic_code: "2.5" };
  const a = proposalPatch(untouched, p2, prev);
  assertEquals(a.filled, ["stem", "choices", "topic"]);
  assertEquals(a.stem, "A better read of the same question");
  // Student edited the stem and the topic: those are kept; choices still refresh.
  const edited = { ...untouched, stem: "MY EDIT", topic_code: "2.6", taxonomy_topic_id: "t2" };
  const b = proposalPatch(edited, p2, prev);
  assertEquals(b.filled, ["choices"]);
  assertEquals(b.stem, undefined);
  // Without a previous proposal, non-empty fields are never touched (first-run rule).
  const c = proposalPatch(untouched, p2, null);
  assertEquals(c.filled, []);
  // Identical re-read: nothing to fill.
  assertEquals(proposalPatch(untouched, p1, prev).filled, []);
});

Deno.test("subject_mismatch is not raised when no subject was named", () => {
  const p = normalizeProposal(okRaw({ looks_like_subject: false }), TOPICS)!;
  assert(warningsFor(p, true, true).includes("subject_mismatch"));
  assert(!warningsFor(p, true, false).includes("subject_mismatch"));
});

Deno.test("extractOutputText reads output_text or the first text piece and refuses a refusal", () => {
  assertEquals(extractOutputText({ output_text: "{}" }), "{}");
  assertEquals(extractOutputText({ output: [{ content: [{ type: "output_text", text: "{\"a\":1}" }] }] }), "{\"a\":1}");
  assertEquals(extractOutputText({ output: [{ content: [{ type: "refusal", refusal: "no" }] }] }), null);
  assertEquals(extractOutputText(null), null);
});

Deno.test("extractionKey is order-independent over page digests and changes with the model", async () => {
  const a = await extractionKey(["d1", "d2"], "m");
  const b = await extractionKey(["d2", "d1"], "m");
  const c = await extractionKey(["d1", "d2"], "m2");
  assertEquals(a, b);
  assert(a !== c);
});

function page() {
  return { bytes: new Uint8Array([1, 2, 3]), mediaType: "image/png" as const };
}

Deno.test("runByoqExtraction: no key, no pages, or refused reservation never calls the model", async () => {
  let calls = 0;
  const fetchImpl = (async () => { calls++; return new Response("{}"); }) as unknown as typeof fetch;
  const base = { pages: [page()], subjectName: "AP Statistics", unitLabel: null, topics: TOPICS, modelId: "m", timeoutMs: 10_000, fetchImpl };
  assertEquals((await runByoqExtraction({ ...base, apiKey: null, reserveCost: async () => true })).kind, "unavailable");
  assertEquals((await runByoqExtraction({ ...base, apiKey: "k", pages: [], reserveCost: async () => true })).kind, "unavailable");
  const capped = await runByoqExtraction({ ...base, apiKey: "k", reserveCost: async () => false });
  assertEquals(capped, { kind: "unavailable", failure: "cost_cap_reached" });
  assertEquals(calls, 0);
});

Deno.test("runByoqExtraction: a schema-conforming reply becomes a proposal; the request carries store:false, strict schema, and every page", async () => {
  let sent: Record<string, unknown> | null = null;
  const fetchImpl = (async (_url: string, init: RequestInit) => {
    sent = JSON.parse(init.body as string);
    return new Response(JSON.stringify({ output_text: JSON.stringify(okRaw()), usage: { input_tokens: 900, output_tokens: 120 } }), { status: 200 });
  }) as unknown as typeof fetch;
  const out = await runByoqExtraction({
    pages: [page(), page()], subjectName: "AP Statistics", unitLabel: "Unit 2", topics: TOPICS,
    apiKey: "k", modelId: "m", timeoutMs: 10_000, reserveCost: async () => true, fetchImpl,
  });
  assertEquals(out.kind, "proposed");
  if (out.kind !== "proposed") return;
  assertEquals(out.proposal.topic_code, "2.5");
  assertEquals(out.usage, { input_tokens: 900, output_tokens: 120 });
  const body = sent! as Record<string, unknown>;
  assertEquals(body.store, false);
  const fmt = (body.text as Record<string, Record<string, unknown>>).format;
  assertEquals(fmt.strict, true);
  const user = (body.input as Record<string, unknown>[])[1] as { content: { type: string }[] };
  assertEquals(user.content.filter((c) => c.type === "input_image").length, 2);
});

Deno.test("runByoqExtraction: http error, malformed body, and schema mismatch are explicit failures", async () => {
  const mk = (res: () => Response) => (async () => res()) as unknown as typeof fetch;
  const base = { pages: [page()], subjectName: null, unitLabel: null, topics: [], apiKey: "k", modelId: "m", timeoutMs: 10_000, reserveCost: async () => true };
  const http = await runByoqExtraction({ ...base, fetchImpl: mk(() => new Response("nope", { status: 500 })) });
  assertEquals(http.kind, "failed");
  if (http.kind === "failed") assertEquals(http.failure, "http_error");
  const bad = await runByoqExtraction({ ...base, fetchImpl: mk(() => new Response(JSON.stringify({ output_text: "not json" }))) });
  if (bad.kind === "failed") assertEquals(bad.failure, "malformed_response");
  const mismatch = await runByoqExtraction({ ...base, fetchImpl: mk(() => new Response(JSON.stringify({ output_text: JSON.stringify({ stem: "x" }) }))) });
  if (mismatch.kind === "failed") assertEquals(mismatch.failure, "invalid_output");
  const timeout = await runByoqExtraction({ ...base, fetchImpl: (async () => { throw new DOMException("t", "TimeoutError"); }) as unknown as typeof fetch });
  if (timeout.kind === "failed") assertEquals(timeout.failure, "timeout");
});

Deno.test("buildExtractionRecord stores the proposal summary and never captured_work", () => {
  const p = normalizeProposal(okRaw(), TOPICS)!;
  const rec = buildExtractionRecord({
    outcome: { kind: "proposed", proposal: p, warnings: [], modelId: "m", latencyMs: 1200, usage: { input_tokens: null, output_tokens: null } },
    key: "k", pageDigests: ["d"], modelId: "m", filled: ["stem"], at: "2026-10-09T00:00:00Z",
  });
  assertEquals(rec.status, "proposed");
  assertEquals(rec.proposed?.stem, p.stem);
  assert(!JSON.stringify(rec).includes("circled"));
  const failed = buildExtractionRecord({
    outcome: { kind: "failed", failure: "timeout", detail: "slow", modelId: "m", latencyMs: 45000 },
    key: "k", pageDigests: ["d"], modelId: "m", filled: [], at: "2026-10-09T00:00:00Z",
  });
  assertEquals(failed.status, "failed");
  assertEquals(failed.failure, "timeout:slow");
});
