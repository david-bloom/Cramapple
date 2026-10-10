// Drawn-response transcript -- hand-drawn responses on every FRQ
// (docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md §5,
// DECISION-0110).
//
// Reads a photograph of a student's handwritten/drawn FRQ answer with a
// vision model and proposes a per-part TRANSCRIPT of the student's own work.
// The student confirms or completes every part before anything is graded;
// the grader only ever sees the confirmed text. Nothing here judges
// correctness.
//
// GOVERNING RULES
// ---------------
// * The student's marks ARE the content. This is the inverse of
//   `byoq-extraction.ts`, where handwriting is set aside as `captured_work`:
//   here the printed question is set aside and the handwriting is the
//   transcript.
// * Visible text only. Never complete an equation, never finish a sentence,
//   never guess an unreadable value. Unreadable spans become `[unreadable]`;
//   drawn elements that cannot be put into words become `[see photo: …]`.
//   Both are listed so the review screen can prompt the student to fill
//   them in (DECISION-0110 condition).
// * No answer-bearing output. The schema has no correctness, score, verdict,
//   or expected-answer field, and the prompt never receives the rubric or the
//   canonical answer.
// * A printed answer key on the page is a WARNING for the grader, never a
//   reason to drop the student's work (plan §"What not to carry over").
// * Modelled on `byoq-extraction.ts`'s call shape: OpenAI Responses API,
//   `store: false`, strict closed JSON schema, bounded output, clamped
//   timeout, and a required cost reservation. Never throws: every failure is
//   an explicit outcome so a broken reader can never lose a photo.
//
// Pure logic (schema, prompt, normalisation, flattening) is exported
// separately from the network call so it is unit tested without a model.

/** Bump when the prompt or schema changes: it is part of the transcript key. */
export const TRANSCRIPT_PROMPT_VERSION = "2026-10-09.1";
export const TRANSCRIPT_ENDPOINT = "https://api.openai.com/v1/responses";
export const TRANSCRIPT_MIN_TIMEOUT_MS = 5_000;
export const TRANSCRIPT_MAX_TIMEOUT_MS = 60_000;
export const TRANSCRIPT_DEFAULT_TIMEOUT_MS = 45_000;
export const TRANSCRIPT_MAX_OUTPUT_TOKENS = 4_000;
export const TRANSCRIPT_MAX_PAGES = 3;
export const TRANSCRIPT_PART_MAX_CHARS = 6_000;
export const TRANSCRIPT_UNASSIGNED_MAX_CHARS = 4_000;
export const UNREADABLE_MARKER = "[unreadable]";
export const SEE_PHOTO_PREFIX = "[see photo";

export type TranscriptMediaType = "image/jpeg" | "image/png" | "image/webp";

/** One answer part of the item, as the student sees it. */
export interface TranscriptPartSpec {
  part_key: string;
  /** The authored sub-question for this part, or null for a single-response item. */
  prompt_text: string | null;
}

export interface TranscriptInput {
  /** Photo pages in page order (metadata-stripped where available). */
  pages: { bytes: Uint8Array; mediaType: TranscriptMediaType }[];
  /** The item's answer parts. Always at least one. */
  parts: TranscriptPartSpec[];
  /** The printed question, so the model can tell question from answer. */
  stem: string;
  subjectName: string | null;
  modelId: string;
  apiKey: string | null;
  timeoutMs: number;
  reserveCost: () => Promise<boolean>;
  fetchImpl?: typeof fetch;
  endpoint?: string;
}

export interface TranscriptPart {
  part_key: string;
  /** The student's work for this part, plain Unicode, markers inline. */
  text: string;
  /** What could not be read in this part (empty when everything was legible). */
  unreadable_regions: string[];
  /** Drawn elements described, not transcribed (graphs, diagrams, arrows). */
  visual_elements: string[];
}

export interface TranscriptProposal {
  parts: TranscriptPart[];
  /** Handwritten work that could not be assigned to any part. */
  unassigned_text: string;
  page_blank: boolean;
  printed_answer_key_present: boolean;
  possible_personal_information: boolean;
}

export type TranscriptWarning =
  | "page_blank"
  | "unreadable"
  | "visual_elements"
  | "unassigned_text"
  | "printed_answer_key_present"
  | "possible_personal_information"
  | "empty_parts";

export type TranscriptFailure =
  | "timeout"
  | "network_error"
  | "http_error"
  | "malformed_response"
  | "invalid_output";

export type TranscriptOutcome =
  | {
    kind: "proposed";
    proposal: TranscriptProposal;
    warnings: TranscriptWarning[];
    modelId: string;
    latencyMs: number;
    usage: { input_tokens: number | null; output_tokens: number | null };
  }
  | { kind: "unavailable"; failure: "not_configured" | "cost_cap_reached" | "disabled" | "no_pages" | "no_parts" }
  | { kind: "failed"; failure: TranscriptFailure; detail: string; modelId: string; latencyMs: number };

/* -------------------------------------------------------------------------- */
/* Schema and prompt                                                           */
/* -------------------------------------------------------------------------- */

/**
 * Closed schema. `part_key` is an enum built per call from the item's parts,
 * so the model can never invent a part. There is no field for a verdict, a
 * score, an expected answer, or a correction.
 */
export function buildTranscriptSchema(parts: TranscriptPartSpec[]) {
  const keys = [...new Set(parts.map((p) => p.part_key))];
  return {
    type: "object",
    additionalProperties: false,
    properties: {
      parts: {
        type: "array",
        items: {
          type: "object",
          additionalProperties: false,
          properties: {
            part_key: { type: "string", enum: keys },
            text: { type: "string" },
            unreadable_regions: { type: "array", items: { type: "string" } },
            visual_elements: { type: "array", items: { type: "string" } },
          },
          required: ["part_key", "text", "unreadable_regions", "visual_elements"],
        },
      },
      unassigned_text: { type: "string" },
      page_blank: { type: "boolean" },
      printed_answer_key_present: { type: "boolean" },
      possible_personal_information: { type: "boolean" },
    },
    required: [
      "parts",
      "unassigned_text",
      "page_blank",
      "printed_answer_key_present",
      "possible_personal_information",
    ],
  } as const;
}

export function buildTranscriptSystemPrompt() {
  return [
    "You transcribe a student's HANDWRITTEN or HAND-DRAWN answer to a free-response question for a study app. The student will check and edit everything you return before it is scored, so be exact and never invent.",
    "THE STUDENT'S WORK IS THE CONTENT. Transcribe what the student wrote or drew. Do NOT transcribe the printed question, printed instructions, or printed data; you are given the question text separately so you can tell them apart.",
    "VISIBLE TEXT ONLY. Every word, number, and symbol you return must be legible in the photo. Never complete an equation, finish a sentence, correct a mistake, or supply a value from memory. If the page is blank, dark, out of focus, or shows no handwriting at all, set `page_blank` to true and return every part with an empty `text`.",
    "PARTS. Assign the work to the question's parts using the student's own labels like (a), (b), (c) or a, b, c, or by order when unlabeled. Return one entry per part key you were given, in that order, even when a part has no work (empty `text`). Handwriting that clearly belongs to no part goes in `unassigned_text`.",
    "UNREADABLE. Where a word, number, or symbol cannot be read, write exactly '[unreadable]' at that point in `text` and describe what is affected in `unreadable_regions` (e.g. 'the exponent in the second line'). Never guess at unreadable content.",
    "DRAWINGS. Where the student drew something that cannot be written as text (a graph, a sketch, a diagram, an arrow, shading), write a short bracketed marker at that point in `text` beginning with '[see photo:' and ending with ']', e.g. '[see photo: scatterplot with 8 points and a line of best fit]', and list it in `visual_elements`. Do transcribe any numbers, axis labels, scale values, titles, or legends written on the drawing, as text, since those are the student's work too.",
    "NOTATION. Write mathematics and science in plain Unicode text, never LaTeX or code: superscripts and subscripts (x², H₂O, 10⁻³), Greek letters (π, σ, μ, Δ, θ), √, ≤, ≥, ≠, ≈, ×, ÷, →, ∫, ∑, °, and fractions as a/b with parentheses where order matters, e.g. (x+1)/(x−2). Keep units. Keep the student's line breaks as newlines.",
    "CROSSED OUT. Omit work the student clearly crossed out or erased; keep work that is merely untidy.",
    "ANSWER KEY. If the page shows a PRINTED answer key or printed worked solution, set `printed_answer_key_present` to true. Still transcribe the student's own handwriting; never transcribe the printed key.",
    "PERSONAL INFORMATION. `possible_personal_information` is true if a student's name, a school name, a teacher's name, contact details, or a face is visible.",
    "Return only the JSON object that matches the schema.",
  ].join("\n");
}

export function buildTranscriptUserText(input: Pick<TranscriptInput, "subjectName" | "stem" | "parts" | "pages">) {
  const lines: string[] = [];
  lines.push(input.subjectName ? `Subject: ${input.subjectName}.` : "Subject: not specified.");
  lines.push("The printed question (for context only, do not transcribe it):");
  lines.push(input.stem.trim().slice(0, 4_000));
  lines.push("");
  lines.push("Answer parts to assign the student's work to:");
  for (const p of input.parts) {
    lines.push(`- part_key "${p.part_key}"${p.prompt_text ? `: ${p.prompt_text.trim().slice(0, 600)}` : ""}`);
  }
  lines.push("");
  lines.push(
    input.pages.length === 1
      ? "Transcribe the student's handwritten work in this photo."
      : `Transcribe the student's handwritten work across these ${input.pages.length} photos, in order.`,
  );
  return lines.join("\n");
}

/* -------------------------------------------------------------------------- */
/* Normalisation and warnings                                                  */
/* -------------------------------------------------------------------------- */

function cleanText(v: unknown): string {
  return typeof v === "string"
    ? v.replace(/\r\n?/g, "\n").replace(/[ \t]+\n/g, "\n").replace(/\n{3,}/g, "\n\n").trim()
    : "";
}

function stringList(v: unknown, max = 12): string[] {
  if (!Array.isArray(v)) return [];
  return v.map(cleanText).filter(Boolean).slice(0, max);
}

/**
 * Turns the parsed model output into a proposal with exactly one entry per
 * item part, in item order. Rejects (returns null) on a missing or mistyped
 * required field so a model regression is a visible failure, not a stream of
 * empty transcripts. Unknown part keys are folded into `unassigned_text`.
 */
export function normalizeTranscript(raw: unknown, parts: TranscriptPartSpec[]): TranscriptProposal | null {
  if (!raw || typeof raw !== "object") return null;
  const r = raw as Record<string, unknown>;
  for (const k of ["page_blank", "printed_answer_key_present", "possible_personal_information"] as const) {
    if (typeof r[k] !== "boolean") return null;
  }
  if (!Array.isArray(r.parts) || typeof r.unassigned_text !== "string") return null;

  const allowed = new Set(parts.map((p) => p.part_key));
  const byKey = new Map<string, TranscriptPart>();
  const strays: string[] = [];
  for (const entry of r.parts) {
    if (!entry || typeof entry !== "object") return null;
    const e = entry as Record<string, unknown>;
    if (typeof e.part_key !== "string" || typeof e.text !== "string") return null;
    const text = cleanText(e.text).slice(0, TRANSCRIPT_PART_MAX_CHARS);
    if (!allowed.has(e.part_key)) {
      if (text) strays.push(text);
      continue;
    }
    const prior = byKey.get(e.part_key);
    const next: TranscriptPart = {
      part_key: e.part_key,
      // A duplicated key keeps both pieces of work rather than dropping one.
      text: prior && prior.text && text ? `${prior.text}\n${text}` : (prior?.text || text),
      unreadable_regions: [...(prior?.unreadable_regions ?? []), ...stringList(e.unreadable_regions)].slice(0, 12),
      visual_elements: [...(prior?.visual_elements ?? []), ...stringList(e.visual_elements)].slice(0, 12),
    };
    byKey.set(e.part_key, next);
  }
  const ordered: TranscriptPart[] = parts.map((p) =>
    byKey.get(p.part_key) ?? { part_key: p.part_key, text: "", unreadable_regions: [], visual_elements: [] }
  );
  const unassigned = [cleanText(r.unassigned_text), ...strays].filter(Boolean).join("\n").slice(0, TRANSCRIPT_UNASSIGNED_MAX_CHARS);
  return {
    parts: ordered,
    unassigned_text: unassigned,
    page_blank: r.page_blank as boolean,
    printed_answer_key_present: r.printed_answer_key_present as boolean,
    possible_personal_information: r.possible_personal_information as boolean,
  };
}

export function transcriptWarnings(p: TranscriptProposal): TranscriptWarning[] {
  const w: TranscriptWarning[] = [];
  if (p.page_blank) w.push("page_blank");
  if (p.parts.some((x) => x.unreadable_regions.length > 0 || x.text.includes(UNREADABLE_MARKER))) w.push("unreadable");
  if (p.parts.some((x) => x.visual_elements.length > 0 || x.text.includes(SEE_PHOTO_PREFIX))) w.push("visual_elements");
  if (p.unassigned_text) w.push("unassigned_text");
  if (p.printed_answer_key_present) w.push("printed_answer_key_present");
  if (p.possible_personal_information) w.push("possible_personal_information");
  if (p.parts.some((x) => !x.text.trim())) w.push("empty_parts");
  return w;
}

/**
 * The response text the grader reads: the same `(a) …` convention the Practice
 * FRQ screen uses for typed multi-part answers (`toFlatResponseText`), so a
 * photographed answer and a typed answer reach `evaluate-attempt` in one
 * shape. Unassigned work is appended under its own label so nothing the
 * student wrote is silently dropped.
 */
export function flattenTranscript(
  parts: ReadonlyArray<{ part_key: string; text: string }>,
  unassignedText = "",
): string {
  const body = parts.length === 1
    ? parts[0]!.text.trim()
    : parts.map((p) => `(${p.part_key}) ${p.text.trim()}`).join("\n\n");
  const extra = unassignedText.trim();
  return extra ? `${body}\n\n(additional work) ${extra}`.trim() : body;
}

/* -------------------------------------------------------------------------- */
/* Model call                                                                  */
/* -------------------------------------------------------------------------- */

export function clampTranscriptTimeout(raw: number | undefined) {
  if (!Number.isFinite(raw) || (raw ?? 0) <= 0) return TRANSCRIPT_DEFAULT_TIMEOUT_MS;
  return Math.min(TRANSCRIPT_MAX_TIMEOUT_MS, Math.max(TRANSCRIPT_MIN_TIMEOUT_MS, Math.round(raw as number)));
}

function toBase64(bytes: Uint8Array) {
  let binary = "";
  const chunk = 0x8000;
  for (let i = 0; i < bytes.length; i += chunk) binary += String.fromCharCode(...bytes.subarray(i, i + chunk));
  return btoa(binary);
}

/** Pulls the JSON text out of a Responses API body (`output_text` or the first text piece). */
export function extractOutputText(raw: unknown): string | null {
  if (!raw || typeof raw !== "object") return null;
  const rec = raw as Record<string, unknown>;
  if (typeof rec.output_text === "string" && rec.output_text.length) return rec.output_text;
  if (!Array.isArray(rec.output)) return null;
  for (const item of rec.output) {
    if (!item || typeof item !== "object") continue;
    const content = (item as Record<string, unknown>).content;
    if (!Array.isArray(content)) continue;
    for (const piece of content) {
      if (!piece || typeof piece !== "object") continue;
      const pr = piece as Record<string, unknown>;
      if (pr.type === "refusal") return null;
      if (typeof pr.text === "string" && pr.text.length) return pr.text;
    }
  }
  return null;
}

function usageOf(raw: unknown): { input_tokens: number | null; output_tokens: number | null } {
  const u = (raw as Record<string, unknown> | null)?.usage as Record<string, unknown> | undefined;
  const n = (v: unknown) => (typeof v === "number" && Number.isFinite(v) ? v : null);
  return { input_tokens: n(u?.input_tokens), output_tokens: n(u?.output_tokens) };
}

/**
 * Runs the transcript read. Never throws. `reserveCost` must perform the
 * caller's budget reservation and return false when spending is not allowed;
 * the model is never called without a successful reservation.
 */
export async function runDrawnResponseTranscript(input: TranscriptInput): Promise<TranscriptOutcome> {
  if (!input.apiKey) return { kind: "unavailable", failure: "not_configured" };
  if (!input.pages.length) return { kind: "unavailable", failure: "no_pages" };
  if (!input.parts.length) return { kind: "unavailable", failure: "no_parts" };
  if (!(await input.reserveCost().catch(() => false))) return { kind: "unavailable", failure: "cost_cap_reached" };

  const pages = input.pages.slice(0, TRANSCRIPT_MAX_PAGES);
  const doFetch = input.fetchImpl ?? fetch;
  const timeoutMs = clampTranscriptTimeout(input.timeoutMs);
  const startedAt = Date.now();

  let response: Response;
  try {
    response = await doFetch(input.endpoint ?? TRANSCRIPT_ENDPOINT, {
      method: "POST",
      headers: { Authorization: `Bearer ${input.apiKey}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        model: input.modelId,
        input: [
          { role: "system", content: [{ type: "input_text", text: buildTranscriptSystemPrompt() }] },
          {
            role: "user",
            content: [
              { type: "input_text", text: buildTranscriptUserText({ ...input, pages }) },
              ...pages.map((p) => ({
                type: "input_image",
                image_url: `data:${p.mediaType};base64,${toBase64(p.bytes)}`,
                detail: "high",
              })),
            ],
          },
        ],
        // No retention of the student's image at the vendor (engineering default).
        store: false,
        max_output_tokens: TRANSCRIPT_MAX_OUTPUT_TOKENS,
        text: {
          format: { type: "json_schema", name: "drawn_response_transcript", strict: true, schema: buildTranscriptSchema(input.parts) },
        },
      }),
      signal: AbortSignal.timeout(timeoutMs),
    });
  } catch (error) {
    const isTimeout = error instanceof DOMException && (error.name === "TimeoutError" || error.name === "AbortError");
    return {
      kind: "failed",
      failure: isTimeout ? "timeout" : "network_error",
      detail: error instanceof Error ? error.message.slice(0, 300) : "transcript_fetch_failed",
      modelId: input.modelId,
      latencyMs: Date.now() - startedAt,
    };
  }

  const latencyMs = Date.now() - startedAt;
  if (!response.ok) {
    // Status only: a vendor error body is logged by the caller, never stored or shown.
    await response.text().catch(() => "");
    return { kind: "failed", failure: "http_error", detail: `transcript_http_${response.status}`, modelId: input.modelId, latencyMs };
  }
  const raw = await response.json().catch(() => null);
  const text = extractOutputText(raw);
  if (!text) return { kind: "failed", failure: "malformed_response", detail: "transcript_no_output_text", modelId: input.modelId, latencyMs };
  let parsed: unknown;
  try {
    parsed = JSON.parse(text);
  } catch {
    return { kind: "failed", failure: "malformed_response", detail: "transcript_unparseable_json", modelId: input.modelId, latencyMs };
  }
  const proposal = normalizeTranscript(parsed, input.parts);
  if (!proposal) return { kind: "failed", failure: "invalid_output", detail: "transcript_schema_mismatch", modelId: input.modelId, latencyMs };
  return { kind: "proposed", proposal, warnings: transcriptWarnings(proposal), modelId: input.modelId, latencyMs, usage: usageOf(raw) };
}

/* -------------------------------------------------------------------------- */
/* Stored record                                                               */
/* -------------------------------------------------------------------------- */

/** What is persisted in `app.response_versions.response_parts._transcript`. */
export interface TranscriptRecord {
  status: "proposed" | "failed" | "unavailable";
  key: string;
  model: string | null;
  prompt_version: string;
  page_digests: string[];
  proposed: TranscriptProposal | null;
  warnings: TranscriptWarning[];
  failure: string | null;
  latency_ms: number | null;
  created_at: string;
}

export async function transcriptKey(pageDigests: string[], modelId: string) {
  const data = new TextEncoder().encode([...pageDigests].sort().join("|") + "|" + modelId + "|" + TRANSCRIPT_PROMPT_VERSION);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return [...new Uint8Array(hash)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

export function buildTranscriptRecord(params: {
  outcome: TranscriptOutcome;
  key: string;
  pageDigests: string[];
  modelId: string;
  at: string;
}): TranscriptRecord {
  const { outcome } = params;
  const base = {
    key: params.key,
    model: params.modelId,
    prompt_version: TRANSCRIPT_PROMPT_VERSION,
    page_digests: params.pageDigests,
    created_at: params.at,
  };
  if (outcome.kind === "proposed") {
    return { ...base, status: "proposed", proposed: outcome.proposal, warnings: outcome.warnings, failure: null, latency_ms: outcome.latencyMs };
  }
  if (outcome.kind === "unavailable") {
    return { ...base, status: "unavailable", proposed: null, warnings: [], failure: outcome.failure, latency_ms: null };
  }
  return { ...base, status: "failed", proposed: null, warnings: [], failure: `${outcome.failure}:${outcome.detail}`, latency_ms: outcome.latencyMs };
}
