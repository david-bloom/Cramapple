// BYOQ photo extraction -- TASK-0068 (DECISION-0108 / APPROVAL-0139).
//
// Reads a student's photographed question with a vision model and proposes
// the question's type, text, answer choices, and a topic from the student's
// own unit. The student edits every field and confirms; nothing here is
// trusted until it has passed the same validation a typed question passes
// (`validateItemFields`, `detectAnswerLeaks`, taxonomy resolution).
//
// GOVERNING RULES
// ---------------
// * DECISION-0057: no answer key, verdict, or correctness ever. The output
//   schema has no field in which an answer can be returned as data; marks
//   on the page that are not the question go to `captured_work`, which is
//   the student's own record and is never shown as correct. A printed
//   answer key is dropped, not stored (`answer_key_present` is a warning).
// * Subject and unit are context supplied by the app, never inferred from
//   the image (DECISION-0108 item 4). The model may only choose a topic
//   from the list it is given, enforced by the JSON schema's enum.
// * Modelled on `_shared/capture-quality-check.ts`: OpenAI Responses API,
//   `store: false` (an engineering default, not a promise to students --
//   DECISION-0108 item 3), strict JSON schema, bounded output, timeout, and
//   a required cost reservation. Never throws: every failure is an explicit
//   outcome so a broken extractor can never be the reason a photo is lost.
//
// Pure decision logic (schema, prompt, normalisation, applying a proposal
// to an item) is exported separately from the network call so it is unit
// tested without a model in the loop.

import { BYOQ_LIMITS, type ChoiceInput } from "./byoq.ts";

/** Bump when the prompt or schema changes: it is part of the idempotency key. */
export const BYOQ_EXTRACTION_PROMPT_VERSION = "2026-10-09.3";
export const BYOQ_EXTRACTION_ENDPOINT = "https://api.openai.com/v1/responses";
export const BYOQ_EXTRACTION_MIN_TIMEOUT_MS = 5_000;
export const BYOQ_EXTRACTION_MAX_TIMEOUT_MS = 60_000;
export const BYOQ_EXTRACTION_DEFAULT_TIMEOUT_MS = 45_000;
export const BYOQ_EXTRACTION_MAX_OUTPUT_TOKENS = 3_000;
export const BYOQ_EXTRACTION_MAX_PAGES = BYOQ_LIMITS.maxCurrentPages;
export const CAPTURED_WORK_MAX_CHARS = 4_000;
export const TOPIC_UNSURE = "unsure";

export type ExtractionMediaType = "image/jpeg" | "image/png" | "image/webp";

export interface ExtractionTopicOption {
  code: string;
  title: string;
}

export interface ExtractionInput {
  /** Current question pages in page order, metadata-stripped. */
  pages: { bytes: Uint8Array; mediaType: ExtractionMediaType }[];
  /** Display name of the subject the student is working in, or null if unknown. */
  subjectName: string | null;
  /** "Unit 2: Exploring Two-Variable Data", or null. */
  unitLabel: string | null;
  /** Topics the model may choose from (the student's unit, or the whole subject). */
  topics: ExtractionTopicOption[];
  apiKey: string | null;
  modelId: string;
  timeoutMs: number;
  reserveCost: () => Promise<boolean>;
  fetchImpl?: typeof fetch;
  endpoint?: string;
}

/** The model's raw, schema-conforming answer after normalisation. */
export interface ExtractionProposal {
  is_question: boolean;
  item_type: "mcq" | "frq" | "unsure";
  stem: string;
  /** Choice texts in printed order, labels stripped. Keys are assigned by position downstream. */
  choices: string[];
  topic_code: string | null;
  alternatives: string[];
  captured_work: string | null;
  answer_key_present: boolean;
  possible_personal_information: boolean;
  unreadable_regions: string[];
  visual_only_regions: string[];
  looks_like_subject: boolean;
}

export type ExtractionWarning =
  | "not_a_question"
  | "unreadable"
  | "visual_only"
  | "answer_key_present"
  | "possible_personal_information"
  | "subject_mismatch"
  | "no_topic"
  | "type_unsure"
  | "too_many_choices";

export type ExtractionFailure =
  | "timeout"
  | "network_error"
  | "http_error"
  | "malformed_response"
  | "invalid_output";

export type ExtractionOutcome =
  | {
    kind: "proposed";
    proposal: ExtractionProposal;
    warnings: ExtractionWarning[];
    modelId: string;
    latencyMs: number;
    usage: { input_tokens: number | null; output_tokens: number | null };
  }
  | { kind: "unavailable"; failure: "not_configured" | "cost_cap_reached" | "disabled" | "no_pages" }
  | { kind: "failed"; failure: ExtractionFailure; detail: string; modelId: string; latencyMs: number };

/* -------------------------------------------------------------------------- */
/* Schema and prompt                                                           */
/* -------------------------------------------------------------------------- */

/**
 * Closed schema: `additionalProperties: false` everywhere and every property
 * required, as OpenAI strict mode demands. There is deliberately no field for
 * a correct answer, a key, a rationale, or a score. The topic enum is built
 * per call from the student's unit so a free-form label can never come back.
 */
export function buildExtractionSchema(topics: ExtractionTopicOption[]) {
  const codes = [...new Set(topics.map((t) => t.code))];
  const topicEnum = [...codes, TOPIC_UNSURE];
  return {
    type: "object",
    additionalProperties: false,
    properties: {
      is_question: { type: "boolean" },
      item_type: { type: "string", enum: ["mcq", "frq", "unsure"] },
      stem: { type: "string" },
      choices: { type: "array", items: { type: "string" } },
      topic_code: { type: "string", enum: topicEnum },
      alternatives: { type: "array", items: { type: "string", enum: topicEnum } },
      captured_work: { type: "string" },
      answer_key_present: { type: "boolean" },
      possible_personal_information: { type: "boolean" },
      unreadable_regions: { type: "array", items: { type: "string" } },
      visual_only_regions: { type: "array", items: { type: "string" } },
      looks_like_subject: { type: "boolean" },
    },
    required: [
      "is_question",
      "item_type",
      "stem",
      "choices",
      "topic_code",
      "alternatives",
      "captured_work",
      "answer_key_present",
      "possible_personal_information",
      "unreadable_regions",
      "visual_only_regions",
      "looks_like_subject",
    ],
  } as const;
}

export function buildExtractionSystemPrompt() {
  return [
    "You transcribe a photographed homework or test question for a study app. The student will check and edit everything you return, so be exact and never invent.",
    "VISIBLE TEXT ONLY. Every word you return in `stem`, `choices` and `captured_work` must be legible in the photo. Never complete, paraphrase, or supply text from memory. If the photo is blank, dark, out of focus, or shows no readable text at all, set `is_question` to false, leave `stem` empty and `choices` empty, and put 'no readable text' in `unreadable_regions`.",
    "Return only the JSON object that matches the schema.",
    "QUESTION ONLY. `stem` is the question as printed: the prompt, any passage, table, data, or set-up it needs, and sub-part labels like (a), (b). `choices` are the printed answer options in printed order with their letter or number labels removed. Keep sentence breaks as newlines.",
    "NOT THE QUESTION. Anything on the page that is not the question goes in `captured_work`, never in `stem` or `choices`: handwritten work, a circled, ticked, boxed, or underlined option, a written answer, an 'Answer:' line, a teacher's mark or comment. Describe briefly (e.g. 'Option C is circled. Working: 2x = 10, x = 5.'). Use an empty string when there is nothing.",
    "ANSWER KEY. If the page shows a printed answer key or solution to this question (an 'Answer Key' block, a printed correct answer, a worked solution printed below the question), set `answer_key_present` to true and do NOT transcribe the key or solution anywhere, not even in `captured_work`.",
    "NOTATION. Write mathematics and science in plain Unicode text, never LaTeX or code: superscripts and subscripts (x², H₂O, 10⁻³), Greek letters (π, σ, μ, Δ, θ), √, ≤, ≥, ≠, ≈, ×, ÷, →, ∫, ∑, °, and fractions as a/b with parentheses where order matters, e.g. (x+1)/(x−2). Write vectors as bold-free text like 'vector v'. Keep units.",
    "FIGURES. If part of the question is a graph, diagram, picture, or a table too large to transcribe, write a short bracketed marker in its place in the stem, e.g. '[see graph in photo]' or '[see diagram in photo]', and list it in `visual_only_regions`. Small tables may be transcribed as rows of text.",
    "UNREADABLE. If part of the question is cut off, blurred, or hidden by glare, write '[unreadable]' at that point in the stem and list what is affected in `unreadable_regions`. Never guess at unreadable text.",
    "TYPE. `item_type` is 'mcq' when the question offers printed answer options to pick from, 'frq' when it asks for a written, numerical, or drawn response, and 'unsure' only when you genuinely cannot tell.",
    "ONE QUESTION. If the page holds more than one question, transcribe only the most prominent complete one (the one framed or in the centre) and ignore the rest. If there is no question at all (a blank page, notes, a title page), set `is_question` to false and leave `stem` empty.",
    "TOPIC. `topic_code` must be one of the listed topic codes, or 'unsure'. Choose the topic whose title best matches the task the question sets (what the student must find, show, or decide), rather than the broader concept it rests on: a question about where a function is continuous on an interval belongs to the interval topic, not the point topic; a question that asks for a graph of summary statistics belongs to the graphical topic, not the summary-statistics topic. `alternatives` lists up to two other plausible codes from the list, most likely first, or is empty. Never choose a code that is not listed.",
    "SUBJECT. `looks_like_subject` is false when the question clearly belongs to a different subject from the one named (e.g. a history question when the subject is AP Chemistry).",
    "PERSONAL INFORMATION. `possible_personal_information` is true if a student's name, a school name, a teacher's name, contact details, or a face is visible.",
  ].join("\n");
}

export function buildExtractionUserText(input: Pick<ExtractionInput, "subjectName" | "unitLabel" | "topics" | "pages">) {
  const lines: string[] = [];
  lines.push(input.subjectName ? `Subject: ${input.subjectName}.` : "Subject: not specified.");
  if (input.unitLabel) lines.push(`Unit: ${input.unitLabel}.`);
  if (input.topics.length) {
    lines.push("Topic codes you may choose from:");
    for (const t of input.topics) lines.push(`${t.code} — ${t.title}`);
  } else {
    lines.push(`No topic list is available; use '${TOPIC_UNSURE}' for topic_code and an empty alternatives list.`);
  }
  lines.push(input.pages.length === 1 ? "Transcribe the question in this photo." : `Transcribe the question across these ${input.pages.length} photos, in order.`);
  return lines.join("\n");
}

/* -------------------------------------------------------------------------- */
/* Normalisation and warnings                                                  */
/* -------------------------------------------------------------------------- */

const CHOICE_LABEL = /^\s*(?:\(?[A-Ha-h]\)?[.):]|\(?\d{1,2}\)?[.):])\s+/;
// A printed question number at the start of the stem ("7.", "12)", "Q3.", "(4)") is layout, not question.
const QUESTION_NUMBER = /^\s*(?:Q(?:uestion)?\s*)?\(?\d{1,3}\)?[.):]\s+(?=\S)/i;

function cleanText(v: unknown): string {
  return typeof v === "string" ? v.replace(/\r\n?/g, "\n").replace(/[ \t]+\n/g, "\n").replace(/\n{3,}/g, "\n\n").trim() : "";
}

function stringList(v: unknown, max = 12): string[] {
  if (!Array.isArray(v)) return [];
  return v.map(cleanText).filter(Boolean).slice(0, max);
}

/**
 * Turns the parsed model output into a proposal the handler can trust the
 * shape of. Rejects (returns null) when a required field is missing or has
 * the wrong type -- silently defaulting would turn a model regression into a
 * stream of empty proposals with no signal.
 */
export function normalizeProposal(raw: unknown, topics: ExtractionTopicOption[]): ExtractionProposal | null {
  if (!raw || typeof raw !== "object") return null;
  const r = raw as Record<string, unknown>;
  const bools = ["is_question", "answer_key_present", "possible_personal_information", "looks_like_subject"] as const;
  for (const k of bools) if (typeof r[k] !== "boolean") return null;
  if (r.item_type !== "mcq" && r.item_type !== "frq" && r.item_type !== "unsure") return null;
  if (typeof r.stem !== "string" || !Array.isArray(r.choices) || typeof r.topic_code !== "string") return null;

  const allowed = new Set(topics.map((t) => t.code));
  const topic = allowed.has(r.topic_code) ? r.topic_code : null;
  const alternatives = stringList(r.alternatives, 4).filter((c) => allowed.has(c) && c !== topic).slice(0, 2);
  const choices = stringList(r.choices, BYOQ_LIMITS.choicesMax + 2)
    .map((c) => c.replace(CHOICE_LABEL, "").trim())
    .filter(Boolean)
    .map((c) => c.slice(0, BYOQ_LIMITS.choiceMaxChars));
  const work = cleanText(r.captured_work).slice(0, CAPTURED_WORK_MAX_CHARS);

  return {
    is_question: r.is_question as boolean,
    item_type: r.item_type,
    stem: cleanText(r.stem).replace(QUESTION_NUMBER, "").slice(0, BYOQ_LIMITS.stemMaxChars),
    choices,
    topic_code: topic,
    alternatives,
    // A printed answer key is dropped entirely (DECISION-0108 item 7).
    captured_work: r.answer_key_present ? null : work || null,
    answer_key_present: r.answer_key_present as boolean,
    possible_personal_information: r.possible_personal_information as boolean,
    unreadable_regions: stringList(r.unreadable_regions),
    visual_only_regions: stringList(r.visual_only_regions),
    looks_like_subject: r.looks_like_subject as boolean,
  };
}

export function warningsFor(p: ExtractionProposal, hadTopics: boolean, hadSubject = true): ExtractionWarning[] {
  const w: ExtractionWarning[] = [];
  if (!p.is_question || !p.stem) w.push("not_a_question");
  if (p.unreadable_regions.length) w.push("unreadable");
  if (p.visual_only_regions.length) w.push("visual_only");
  if (p.answer_key_present) w.push("answer_key_present");
  if (p.possible_personal_information) w.push("possible_personal_information");
  // No subject was named, so there is nothing to mismatch (Sol SOL-06).
  if (hadSubject && !p.looks_like_subject) w.push("subject_mismatch");
  if (hadTopics && !p.topic_code) w.push("no_topic");
  if (p.item_type === "unsure") w.push("type_unsure");
  if (p.choices.length > BYOQ_LIMITS.choicesMax) w.push("too_many_choices");
  return w;
}

/* -------------------------------------------------------------------------- */
/* Applying a proposal to a draft item                                         */
/* -------------------------------------------------------------------------- */

export interface ProposalTarget {
  item_type: "mcq" | "frq" | null;
  stem: string | null;
  choices: ChoiceInput[];
  taxonomy_topic_id: string | null;
  /** The item's current topic code (resolved by the caller), for comparison with a previous proposal. */
  topic_code?: string | null;
}

/** What the previous run proposed; a field still equal to it was never edited by the student. */
export interface PreviousProposal {
  item_type: ExtractionProposal["item_type"];
  stem: string;
  choices: string[];
  topic_code: string | null;
}

function sameChoices(a: ChoiceInput[], b: string[]) {
  return a.length === b.length && a.every((c, i) => c.choice_text === b[i]);
}

export interface ProposalPatch {
  item_type?: "mcq" | "frq";
  stem?: string;
  choices?: ChoiceInput[];
  /** Topic code to resolve against the live taxonomy (the caller does the lookup). */
  topic_code?: string;
  filled: ("item_type" | "stem" | "choices" | "topic")[];
}

/**
 * Fills only what the student has not already set. A field counts as unset
 * when it is empty, or when it still holds exactly what the previous run
 * proposed (the student never touched it), so a re-run after a retake can
 * refresh an untouched proposal while a student's edit is never overwritten
 * (plan §4.3; Sol SOL-01). Choices are assigned keys by position, exactly as
 * a typed submission is.
 */
export function proposalPatch(item: ProposalTarget, p: ExtractionProposal, previous: PreviousProposal | null = null): ProposalPatch {
  const patch: ProposalPatch = { filled: [] };
  if (!p.is_question) return patch;
  const typeUnset = item.item_type === null || (previous !== null && item.item_type === previous.item_type);
  if (typeUnset && p.item_type !== "unsure" && p.item_type !== item.item_type) {
    patch.item_type = p.item_type;
    patch.filled.push("item_type");
  }
  const effectiveType = patch.item_type ?? item.item_type;
  const stemUnset = !item.stem || !item.stem.trim() || (previous !== null && item.stem === previous.stem);
  if (stemUnset && p.stem && p.stem !== item.stem) {
    patch.stem = p.stem;
    patch.filled.push("stem");
  }
  const choicesUnset = item.choices.length === 0 || (previous !== null && sameChoices(item.choices, previous.choices));
  if (effectiveType === "mcq" && choicesUnset && p.choices.length >= BYOQ_LIMITS.choicesMin && !sameChoices(item.choices, p.choices)) {
    patch.choices = p.choices.slice(0, BYOQ_LIMITS.choicesMax)
      .map((text, i) => ({ choice_key: String.fromCharCode(65 + i), choice_text: text }));
    patch.filled.push("choices");
  }
  const topicUnset = item.taxonomy_topic_id === null ||
    (previous !== null && previous.topic_code !== null && item.topic_code === previous.topic_code);
  if (topicUnset && p.topic_code && p.topic_code !== item.topic_code) {
    patch.topic_code = p.topic_code;
    patch.filled.push("topic");
  }
  return patch;
}

/* -------------------------------------------------------------------------- */
/* Model call                                                                  */
/* -------------------------------------------------------------------------- */

export function clampExtractionTimeout(raw: number | undefined) {
  if (!Number.isFinite(raw) || (raw ?? 0) <= 0) return BYOQ_EXTRACTION_DEFAULT_TIMEOUT_MS;
  return Math.min(BYOQ_EXTRACTION_MAX_TIMEOUT_MS, Math.max(BYOQ_EXTRACTION_MIN_TIMEOUT_MS, Math.round(raw as number)));
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
 * Runs the extraction. Never throws. `reserveCost` must perform the caller's
 * budget reservation and return false when spending is not allowed; the
 * module will not call the model without a successful reservation.
 */
export async function runByoqExtraction(input: ExtractionInput): Promise<ExtractionOutcome> {
  if (!input.apiKey) return { kind: "unavailable", failure: "not_configured" };
  if (!input.pages.length) return { kind: "unavailable", failure: "no_pages" };
  if (!(await input.reserveCost().catch(() => false))) return { kind: "unavailable", failure: "cost_cap_reached" };

  const pages = input.pages.slice(0, BYOQ_EXTRACTION_MAX_PAGES);
  const doFetch = input.fetchImpl ?? fetch;
  const timeoutMs = clampExtractionTimeout(input.timeoutMs);
  const startedAt = Date.now();
  const topics = input.topics;

  let response: Response;
  try {
    response = await doFetch(input.endpoint ?? BYOQ_EXTRACTION_ENDPOINT, {
      method: "POST",
      headers: { Authorization: `Bearer ${input.apiKey}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        model: input.modelId,
        input: [
          { role: "system", content: [{ type: "input_text", text: buildExtractionSystemPrompt() }] },
          {
            role: "user",
            content: [
              { type: "input_text", text: buildExtractionUserText({ ...input, pages }) },
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
        max_output_tokens: BYOQ_EXTRACTION_MAX_OUTPUT_TOKENS,
        text: {
          format: { type: "json_schema", name: "byoq_question_extraction", strict: true, schema: buildExtractionSchema(topics) },
        },
      }),
      signal: AbortSignal.timeout(timeoutMs),
    });
  } catch (error) {
    const isTimeout = error instanceof DOMException && (error.name === "TimeoutError" || error.name === "AbortError");
    return {
      kind: "failed",
      failure: isTimeout ? "timeout" : "network_error",
      detail: error instanceof Error ? error.message.slice(0, 300) : "byoq_extraction_fetch_failed",
      modelId: input.modelId,
      latencyMs: Date.now() - startedAt,
    };
  }

  const latencyMs = Date.now() - startedAt;
  if (!response.ok) {
    // Status only: a vendor error body is logged by the caller, never stored or shown.
    await response.text().catch(() => "");
    return { kind: "failed", failure: "http_error", detail: `byoq_extraction_http_${response.status}`, modelId: input.modelId, latencyMs };
  }
  const raw = await response.json().catch(() => null);
  const text = extractOutputText(raw);
  if (!text) return { kind: "failed", failure: "malformed_response", detail: "byoq_extraction_no_output_text", modelId: input.modelId, latencyMs };
  let parsed: unknown;
  try {
    parsed = JSON.parse(text);
  } catch {
    return { kind: "failed", failure: "malformed_response", detail: "byoq_extraction_unparseable_json", modelId: input.modelId, latencyMs };
  }
  const proposal = normalizeProposal(parsed, topics);
  if (!proposal) return { kind: "failed", failure: "invalid_output", detail: "byoq_extraction_schema_mismatch", modelId: input.modelId, latencyMs };
  return { kind: "proposed", proposal, warnings: warningsFor(proposal, topics.length > 0, input.subjectName !== null), modelId: input.modelId, latencyMs, usage: usageOf(raw) };
}

/* -------------------------------------------------------------------------- */
/* Stored record                                                               */
/* -------------------------------------------------------------------------- */

/** What is persisted in `app.byoq_items.extraction`. */
export interface ExtractionRecord {
  status: "proposed" | "failed" | "unavailable";
  key: string;
  model: string | null;
  prompt_version: string;
  page_digests: string[];
  proposed: {
    item_type: ExtractionProposal["item_type"];
    stem: string;
    choices: string[];
    topic_code: string | null;
    alternatives: string[];
    is_question: boolean;
  } | null;
  warnings: ExtractionWarning[];
  filled: ProposalPatch["filled"];
  failure: string | null;
  latency_ms: number | null;
  created_at: string;
}

export async function extractionKey(pageDigests: string[], modelId: string) {
  const data = new TextEncoder().encode([...pageDigests].sort().join("|") + "|" + modelId + "|" + BYOQ_EXTRACTION_PROMPT_VERSION);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return [...new Uint8Array(hash)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

export function buildExtractionRecord(params: {
  outcome: ExtractionOutcome;
  key: string;
  pageDigests: string[];
  modelId: string;
  filled: ProposalPatch["filled"];
  at: string;
}): ExtractionRecord {
  const { outcome } = params;
  const base = {
    key: params.key,
    model: params.modelId,
    prompt_version: BYOQ_EXTRACTION_PROMPT_VERSION,
    page_digests: params.pageDigests,
    filled: params.filled,
    created_at: params.at,
  };
  if (outcome.kind === "proposed") {
    const p = outcome.proposal;
    return {
      ...base,
      status: "proposed",
      proposed: { item_type: p.item_type, stem: p.stem, choices: p.choices, topic_code: p.topic_code, alternatives: p.alternatives, is_question: p.is_question },
      warnings: outcome.warnings,
      failure: null,
      latency_ms: outcome.latencyMs,
    };
  }
  if (outcome.kind === "unavailable") {
    return { ...base, status: "unavailable", proposed: null, warnings: [], failure: outcome.failure, latency_ms: null };
  }
  return { ...base, status: "failed", proposed: null, warnings: [], failure: `${outcome.failure}:${outcome.detail}`, latency_ms: outcome.latencyMs };
}

/** The owner-facing summary. Never includes `captured_work`. */
export function extractionView(rec: ExtractionRecord | null) {
  if (!rec) return null;
  return {
    status: rec.status,
    prompt_version: rec.prompt_version,
    warnings: rec.warnings,
    filled: rec.filled,
    failure: rec.failure,
    latency_ms: rec.latency_ms,
    proposed_topic_code: rec.proposed?.topic_code ?? null,
    topic_alternatives: rec.proposed?.alternatives ?? [],
    proposed_item_type: rec.proposed?.item_type ?? null,
    created_at: rec.created_at,
  };
}
