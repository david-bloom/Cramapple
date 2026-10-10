import { assertEquals, assertStringIncludes } from "jsr:@std/assert@1";
import {
  buildTranscriptRecord,
  buildTranscriptSchema,
  buildTranscriptSystemPrompt,
  buildTranscriptUserText,
  clampTranscriptTimeout,
  extractOutputText,
  flattenTranscript,
  normalizeTranscript,
  runDrawnResponseTranscript,
  TRANSCRIPT_DEFAULT_TIMEOUT_MS,
  TRANSCRIPT_MAX_TIMEOUT_MS,
  TRANSCRIPT_PART_MAX_CHARS,
  transcriptKey,
  transcriptWarnings,
  type TranscriptPartSpec,
} from "./drawn-response-extraction.ts";

const PARTS: TranscriptPartSpec[] = [
  { part_key: "a", prompt_text: "Construct the boxplots." },
  { part_key: "b", prompt_text: "Compare the centers." },
];

function walk(schema: unknown, visit: (key: string, node: Record<string, unknown>) => void) {
  if (!schema || typeof schema !== "object") return;
  const node = schema as Record<string, unknown>;
  const props = node.properties as Record<string, unknown> | undefined;
  if (props) {
    for (const [k, v] of Object.entries(props)) {
      visit(k, node);
      walk(v, visit);
    }
  }
  if (node.items) walk(node.items, visit);
}

Deno.test("schema is closed, every property required, and carries no answer-bearing field", () => {
  const schema = buildTranscriptSchema(PARTS) as unknown as Record<string, unknown>;
  const forbidden = /answer|correct|score|point|verdict|grade|rubric|expected|key_text/i;
  walk(schema, (key, node) => {
    assertEquals(node.additionalProperties, false, "every object is closed");
    const required = node.required as string[];
    assertEquals(required.includes(key), true, `${key} is required`);
    // `printed_answer_key_present` is a boolean warning flag, the one allowed match.
    if (key !== "printed_answer_key_present") {
      assertEquals(forbidden.test(key), false, `no answer-bearing field: ${key}`);
    }
  });
  const items = ((schema.properties as Record<string, unknown>).parts as Record<string, unknown>).items as Record<string, unknown>;
  const keyEnum = ((items.properties as Record<string, unknown>).part_key as Record<string, unknown>).enum;
  assertEquals(keyEnum, ["a", "b"], "part keys are an enum built from the item");
});

Deno.test("prompt makes the student's work the content and never asks for a judgement", () => {
  const system = buildTranscriptSystemPrompt();
  assertStringIncludes(system, "THE STUDENT'S WORK IS THE CONTENT");
  assertStringIncludes(system, "[unreadable]");
  assertStringIncludes(system, "[see photo:");
  assertEquals(/decide whether|mark (it )?correct|award points|rubric|expected answer|how many points/i.test(system), false);
  const user = buildTranscriptUserText({ subjectName: "AP Statistics", stem: "Here is the question.", parts: PARTS, pages: [{ bytes: new Uint8Array(1), mediaType: "image/png" }] });
  assertStringIncludes(user, 'part_key "a": Construct the boxplots.');
  assertStringIncludes(user, "do not transcribe it");
});

Deno.test("normalizeTranscript returns one entry per item part, in order, folding strays into unassigned", () => {
  const p = normalizeTranscript({
    parts: [
      { part_key: "b", text: "The 37°C median is higher.", unreadable_regions: [], visual_elements: [] },
      { part_key: "zzz", text: "stray line", unreadable_regions: [], visual_elements: [] },
    ],
    unassigned_text: "x = 5",
    page_blank: false,
    printed_answer_key_present: false,
    possible_personal_information: false,
  }, PARTS);
  assertEquals(p?.parts.map((x) => x.part_key), ["a", "b"]);
  assertEquals(p?.parts[0].text, "");
  assertEquals(p?.parts[1].text, "The 37°C median is higher.");
  assertEquals(p?.unassigned_text, "x = 5\nstray line");
});

Deno.test("normalizeTranscript rejects a mistyped payload instead of defaulting", () => {
  assertEquals(normalizeTranscript({ parts: "nope", unassigned_text: "", page_blank: false, printed_answer_key_present: false, possible_personal_information: false }, PARTS), null);
  assertEquals(normalizeTranscript({ parts: [], unassigned_text: "", page_blank: "false", printed_answer_key_present: false, possible_personal_information: false }, PARTS), null);
  assertEquals(normalizeTranscript({ parts: [{ part_key: "a" }], unassigned_text: "", page_blank: false, printed_answer_key_present: false, possible_personal_information: false }, PARTS), null);
});

Deno.test("normalizeTranscript clamps part text and merges a duplicated key", () => {
  const long = "x".repeat(TRANSCRIPT_PART_MAX_CHARS + 50);
  const p = normalizeTranscript({
    parts: [
      { part_key: "a", text: long, unreadable_regions: ["r1"], visual_elements: [] },
      { part_key: "a", text: "more", unreadable_regions: [], visual_elements: ["v1"] },
    ],
    unassigned_text: "",
    page_blank: false,
    printed_answer_key_present: false,
    possible_personal_information: false,
  }, PARTS)!;
  assertEquals(p.parts[0].text.length, TRANSCRIPT_PART_MAX_CHARS + 5); // clamped + "\nmore"
  assertEquals(p.parts[0].unreadable_regions, ["r1"]);
  assertEquals(p.parts[0].visual_elements, ["v1"]);
});

Deno.test("warnings name every prompt the review screen must show", () => {
  const p = normalizeTranscript({
    parts: [
      { part_key: "a", text: "slope [unreadable] [see photo: scatterplot]", unreadable_regions: ["the slope value"], visual_elements: ["scatterplot"] },
      { part_key: "b", text: "", unreadable_regions: [], visual_elements: [] },
    ],
    unassigned_text: "note",
    page_blank: false,
    printed_answer_key_present: true,
    possible_personal_information: true,
  }, PARTS)!;
  assertEquals(transcriptWarnings(p), [
    "unreadable",
    "visual_elements",
    "unassigned_text",
    "printed_answer_key_present",
    "possible_personal_information",
    "empty_parts",
  ]);
  const blank = normalizeTranscript({ parts: [], unassigned_text: "", page_blank: true, printed_answer_key_present: false, possible_personal_information: false }, PARTS)!;
  assertEquals(transcriptWarnings(blank).includes("page_blank"), true);
});

Deno.test("flattenTranscript matches the typed multi-part convention and keeps unassigned work", () => {
  assertEquals(flattenTranscript([{ part_key: "response", text: " only answer " }]), "only answer");
  assertEquals(
    flattenTranscript([{ part_key: "a", text: "A text" }, { part_key: "b", text: "B text" }], "extra"),
    "(a) A text\n\n(b) B text\n\n(additional work) extra",
  );
});

Deno.test("timeout is clamped and the key changes with model or digest", async () => {
  assertEquals(clampTranscriptTimeout(undefined), TRANSCRIPT_DEFAULT_TIMEOUT_MS);
  assertEquals(clampTranscriptTimeout(10), 5_000);
  assertEquals(clampTranscriptTimeout(999_999), TRANSCRIPT_MAX_TIMEOUT_MS);
  const k1 = await transcriptKey(["d1"], "m");
  const k2 = await transcriptKey(["d2"], "m");
  const k3 = await transcriptKey(["d1"], "m2");
  assertEquals(k1 === k2, false);
  assertEquals(k1 === k3, false);
  assertEquals(await transcriptKey(["d2", "d1"], "m"), await transcriptKey(["d1", "d2"], "m"), "digest order does not matter");
});

Deno.test("extractOutputText reads output_text, nested text, and refuses a refusal", () => {
  assertEquals(extractOutputText({ output_text: "{}" }), "{}");
  assertEquals(extractOutputText({ output: [{ content: [{ type: "output_text", text: "abc" }] }] }), "abc");
  assertEquals(extractOutputText({ output: [{ content: [{ type: "refusal", refusal: "no" }] }] }), null);
});

const BASE = { parts: PARTS, stem: "Q", subjectName: null, modelId: "test-model", apiKey: "k", timeoutMs: 10_000 };
const page = { bytes: new Uint8Array([1, 2, 3]), mediaType: "image/png" as const };

Deno.test("runDrawnResponseTranscript never calls the model without a reservation, key, pages, or parts", async () => {
  let fetched = 0;
  const fetchImpl = (() => { fetched++; return Promise.resolve(new Response("{}")); }) as typeof fetch;
  assertEquals((await runDrawnResponseTranscript({ ...BASE, pages: [page], reserveCost: () => Promise.resolve(false), fetchImpl })).kind, "unavailable");
  assertEquals((await runDrawnResponseTranscript({ ...BASE, apiKey: null, pages: [page], reserveCost: () => Promise.resolve(true), fetchImpl })).kind, "unavailable");
  assertEquals((await runDrawnResponseTranscript({ ...BASE, pages: [], reserveCost: () => Promise.resolve(true), fetchImpl })).kind, "unavailable");
  assertEquals((await runDrawnResponseTranscript({ ...BASE, parts: [], pages: [page], reserveCost: () => Promise.resolve(true), fetchImpl })).kind, "unavailable");
  assertEquals(fetched, 0);
});

Deno.test("runDrawnResponseTranscript sends store:false, a strict schema, and parses a proposal", async () => {
  let sent: Record<string, unknown> | null = null;
  const fetchImpl = ((_url: string, init: RequestInit) => {
    sent = JSON.parse(init.body as string);
    const body = {
      output_text: JSON.stringify({
        parts: [
          { part_key: "a", text: "[see photo: two boxplots]", unreadable_regions: [], visual_elements: ["two boxplots"] },
          { part_key: "b", text: "37°C has the higher center.", unreadable_regions: [], visual_elements: [] },
        ],
        unassigned_text: "",
        page_blank: false,
        printed_answer_key_present: false,
        possible_personal_information: false,
      }),
      usage: { input_tokens: 1200, output_tokens: 80 },
    };
    return Promise.resolve(new Response(JSON.stringify(body), { status: 200, headers: { "content-type": "application/json" } }));
  }) as unknown as typeof fetch;
  const outcome = await runDrawnResponseTranscript({ ...BASE, pages: [page], reserveCost: () => Promise.resolve(true), fetchImpl });
  assertEquals(outcome.kind, "proposed");
  if (outcome.kind !== "proposed") return;
  assertEquals(outcome.proposal.parts[1].text, "37°C has the higher center.");
  assertEquals(outcome.warnings, ["visual_elements"]);
  assertEquals(outcome.usage, { input_tokens: 1200, output_tokens: 80 });
  const req = sent as unknown as Record<string, unknown>;
  assertEquals(req.store, false);
  const fmt = (req.text as Record<string, unknown>).format as Record<string, unknown>;
  assertEquals(fmt.strict, true);
  assertEquals(fmt.name, "drawn_response_transcript");
});

Deno.test("runDrawnResponseTranscript maps http, malformed, and schema failures without throwing", async () => {
  const mk = (status: number, body: string) => (() => Promise.resolve(new Response(body, { status }))) as unknown as typeof fetch;
  const ok = () => Promise.resolve(true);
  const http = await runDrawnResponseTranscript({ ...BASE, pages: [page], reserveCost: ok, fetchImpl: mk(500, "boom") });
  assertEquals(http.kind === "failed" && http.failure, "http_error");
  assertEquals(http.kind === "failed" && http.detail, "transcript_http_500");
  const malformed = await runDrawnResponseTranscript({ ...BASE, pages: [page], reserveCost: ok, fetchImpl: mk(200, JSON.stringify({ output_text: "not json" })) });
  assertEquals(malformed.kind === "failed" && malformed.failure, "malformed_response");
  const mismatch = await runDrawnResponseTranscript({ ...BASE, pages: [page], reserveCost: ok, fetchImpl: mk(200, JSON.stringify({ output_text: JSON.stringify({ parts: 1 }) })) });
  assertEquals(mismatch.kind === "failed" && mismatch.failure, "invalid_output");
  const thrown = await runDrawnResponseTranscript({ ...BASE, pages: [page], reserveCost: ok, fetchImpl: (() => Promise.reject(new Error("offline"))) as unknown as typeof fetch });
  assertEquals(thrown.kind === "failed" && thrown.failure, "network_error");
});

Deno.test("buildTranscriptRecord keeps the proposal and encodes failures", () => {
  const at = "2026-10-09T00:00:00.000Z";
  const failed = buildTranscriptRecord({ outcome: { kind: "failed", failure: "timeout", detail: "slow", modelId: "m", latencyMs: 5 }, key: "k", pageDigests: ["d"], modelId: "m", at });
  assertEquals(failed.status, "failed");
  assertEquals(failed.failure, "timeout:slow");
  const unavailable = buildTranscriptRecord({ outcome: { kind: "unavailable", failure: "cost_cap_reached" }, key: "k", pageDigests: ["d"], modelId: "m", at });
  assertEquals(unavailable.status, "unavailable");
  assertEquals(unavailable.failure, "cost_cap_reached");
});
