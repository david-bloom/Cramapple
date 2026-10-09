// BYOQ (bring-your-own-question) pure logic -- TASK-0039.
//
// Everything security- or policy-relevant that can be decided without a
// database lives here, so it is unit-testable directly: owner-key and
// capability generation, input validation, the answer-leak heuristic
// (BYOQ_WORKSHEET_PARSING_DESIGN.md §6, applied to typed/photo intake per
// §6.4), masking, limits, and storage-path construction.
//
// DECISION-0057 is the governing rule: a BYOQ item never carries or reveals
// a canonical answer and is never scored. Nothing in this module produces a
// verdict, a correct choice, or a score -- there is no input from which one
// could be computed.

export const BYOQ_OWNER_KEY_PREFIX = "byoq_";
export const BYOQ_CAPTURE_HANDLE_PREFIX = "bqcap_";

export const BYOQ_LIMITS = {
  stemMaxChars: 6000,
  titleMaxChars: 140,
  sourceNoteMaxChars: 200,
  choiceMaxChars: 1000,
  choicesMin: 2,
  choicesMax: 6,
  responseTextMaxChars: 20000,
  /** Anonymous owners minted per creating IP per rolling hour (a school NAT is one IP). */
  ownersPerIpPerHour: 120,
  /** Circuit breaker: anonymous owners minted across all callers per rolling hour. */
  anonymousOwnersPerHourGlobal: 5000,
  /** Items created per owner per rolling 24h. */
  itemsPerOwnerPerDay: 30,
  /** Total live (non-deleted) items per owner. */
  itemsPerOwnerTotal: 200,
  /** Saved response versions per item (all attempts). */
  responsesPerItem: 200,
  /** Capture capabilities minted per owner per rolling window. */
  pairingMintWindowSeconds: 10 * 60,
  pairingMintMaxPerWindow: 12,
  /** Live (unfinished) capture capabilities per owner at once. */
  liveCapturesPerOwner: 6,
  /** Upload URLs issued against one capability (pages + retakes). */
  pairingMaxRedemptions: 12,
  /** Current pages per (item, role, response, part). */
  maxCurrentPages: 10,
  /** Anonymous (never-recognized) owners are purged after this much inactivity. */
  anonymousRetentionDays: 30,
  /** TASK-0068: model extraction runs per owner per UTC day (finish_capture + extract_question). */
  extractionRunsPerOwnerPerDay: 40,
} as const;

/** 20 minutes: enough to find a phone, scan, and shoot a few pages. */
export const BYOQ_PAIRING_TTL_SECONDS = 20 * 60;

export const ACCEPTED_MEDIA_TYPES = ["image/jpeg", "image/png", "image/webp"] as const;
export type ByoqMediaType = typeof ACCEPTED_MEDIA_TYPES[number];

/* -------------------------------------------------------------------------- */
/* Secrets: owner keys and capture capabilities                               */
/* -------------------------------------------------------------------------- */

function base64Url(bytes: Uint8Array) {
  let binary = "";
  for (let i = 0; i < bytes.length; i++) binary += String.fromCharCode(bytes[i]);
  return btoa(binary).replaceAll("+", "-").replaceAll("/", "_").replaceAll("=", "");
}

function randomToken(prefix: string) {
  const bytes = new Uint8Array(32);
  crypto.getRandomValues(bytes);
  return `${prefix}${base64Url(bytes)}`;
}

export function generateOwnerKey() {
  return randomToken(BYOQ_OWNER_KEY_PREFIX);
}

export function generateCaptureHandle() {
  return randomToken(BYOQ_CAPTURE_HANDLE_PREFIX);
}

function isWellFormed(prefix: string, value: unknown): value is string {
  return typeof value === "string" &&
    value.startsWith(prefix) &&
    /^[A-Za-z0-9_-]{43}$/.test(value.slice(prefix.length));
}

export function isWellFormedOwnerKey(value: unknown): value is string {
  return isWellFormed(BYOQ_OWNER_KEY_PREFIX, value);
}

export function isWellFormedCaptureHandle(value: unknown): value is string {
  return isWellFormed(BYOQ_CAPTURE_HANDLE_PREFIX, value);
}

export async function sha256Hex(value: string) {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(value));
  return Array.from(new Uint8Array(digest)).map((b) => b.toString(16).padStart(2, "0")).join("");
}

export async function hmacSha256Hex(key: string, value: string) {
  const cryptoKey = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(key),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = await crypto.subtle.sign("HMAC", cryptoKey, new TextEncoder().encode(value));
  return Array.from(new Uint8Array(sig)).map((b) => b.toString(16).padStart(2, "0")).join("");
}

/**
 * The caller's IP as seen by the platform edge. Verified on Development
 * (2026-09-28): Cloudflare sets `CF-Connecting-IP` and rejects requests that
 * try to forge it, and a client-supplied `X-Forwarded-For` is replaced, not
 * appended to (the rightmost hop is a rotating load balancer). So prefer
 * CF-Connecting-IP and fall back to the first X-Forwarded-For hop.
 */
export function clientIp(req: Request): string | null {
  const cf = req.headers.get("cf-connecting-ip")?.trim();
  if (cf) return cf;
  const first = req.headers.get("x-forwarded-for")?.split(",")[0]?.trim();
  return first || null;
}

/** Constant-time string comparison for bearer-style secrets. */
export function timingSafeEqual(a: string, b: string) {
  const ea = new TextEncoder().encode(a);
  const eb = new TextEncoder().encode(b);
  let diff = ea.length ^ eb.length;
  for (let i = 0; i < Math.max(ea.length, eb.length); i++) diff |= (ea[i] ?? 0) ^ (eb[i] ?? 0);
  return diff === 0;
}

/** Capture slot names: the whole answer, or a rubric part like `part_a`. */
export function isValidPartKey(value: unknown): value is string {
  return typeof value === "string" && /^(whole|part_[a-z0-9]{1,8})$/.test(value);
}

/* -------------------------------------------------------------------------- */
/* Lookup codes                                                                */
/* -------------------------------------------------------------------------- */

// No 0/O/1/I/L: human-typeable, unambiguous when read aloud or off a screen.
const CODE_ALPHABET = "23456789ABCDEFGHJKMNPQRSTUVWXYZ";

export function generateItemCode() {
  const bytes = new Uint8Array(6);
  crypto.getRandomValues(bytes);
  let out = "BQ-";
  for (const b of bytes) out += CODE_ALPHABET[b % CODE_ALPHABET.length];
  return out;
}

/* -------------------------------------------------------------------------- */
/* Answer-leak heuristic (BYOQ_WORKSHEET_PARSING_DESIGN.md §6)                */
/* -------------------------------------------------------------------------- */

export type LeakRule = "answer_label" | "correct_marker" | "trailing_answer_line";

export interface LeakFlag {
  field: "stem" | "choice" | "title" | "source_note";
  /** Choice index for field = "choice"; null for the stem. */
  index: number | null;
  start: number;
  end: number;
  rule: LeakRule;
}

// A labeled answer: "Answer: B", "Ans = 42", "Answer key: C", "Correct
// answer: 3". Flags from the label to the end of that line. Deliberately
// NOT bare "Key:" (AP Statistics stemplot keys, graph legends) or
// "Solution:" (chemistry solutions) -- both are common in real questions and
// a false positive blocks the student outright.
const ANSWER_LABEL = /\b(?:answer\s*key|correct\s+(?:answer|choice|option)|answers?|ans)\b\s*[:=]/gi;

// An in-line marker that a particular choice is the right one.
const CORRECT_MARKER = /\((?:correct|right|answer|ans)\)|\[(?:correct|right|answer|ans)\]|[✓✔✅☑]|<-+\s*(?:correct|answer)/gi;

// A stem whose final non-empty line is nothing but a choice letter, e.g. a
// worksheet line "B" or "(C)." printed under the question.
const TRAILING_ANSWER_LINE = /(?:^|\n)[ \t]*\(?([A-Fa-f])[).:]?[ \t]*\s*$/;

function lineEnd(text: string, from: number) {
  const nl = text.indexOf("\n", from);
  return nl === -1 ? text.length : nl;
}

function scanText(text: string, field: LeakFlag["field"], index: number | null): LeakFlag[] {
  const flags: LeakFlag[] = [];
  for (const m of text.matchAll(ANSWER_LABEL)) {
    const start = m.index ?? 0;
    const end = lineEnd(text, start);
    // "Answer: ________" is a blank to fill in, not a leaked answer.
    if (!/[A-Za-z0-9]/.test(text.slice(start + m[0].length, end))) continue;
    // "Justify your answer: use the graph" is an instruction, not an answer.
    if (/\b(?:your|the|an|their|each|every)\s+$/i.test(text.slice(Math.max(0, start - 8), start))) continue;
    flags.push({ field, index, start, end, rule: "answer_label" });
  }
  for (const m of text.matchAll(CORRECT_MARKER)) {
    const start = m.index ?? 0;
    flags.push({ field, index, start, end: start + m[0].length, rule: "correct_marker" });
  }
  if (field === "stem") {
    const trailing = TRAILING_ANSWER_LINE.exec(text);
    // Require real question text above it: a stem that is only "B" is not a
    // leak, it is an incomplete draft (and fails `ready` for other reasons).
    if (trailing && trailing.index > 0 && text.slice(0, trailing.index).trim().length > 0) {
      const start = trailing.index + (text[trailing.index] === "\n" ? 1 : 0);
      flags.push({ field, index, start, end: text.length, rule: "trailing_answer_line" });
    }
  }
  return mergeFlags(flags);
}

function mergeFlags(flags: LeakFlag[]): LeakFlag[] {
  const sorted = [...flags].sort((a, b) => a.start - b.start || b.end - a.end);
  const out: LeakFlag[] = [];
  for (const f of sorted) {
    const last = out[out.length - 1];
    if (last && f.start <= last.end) {
      last.end = Math.max(last.end, f.end);
    } else {
      out.push({ ...f });
    }
  }
  return out;
}

export function detectAnswerLeaks(
  stem: string | null,
  choices: ChoiceInput[],
  extra: { title?: string | null; source_note?: string | null } = {},
): LeakFlag[] {
  const flags: LeakFlag[] = [];
  if (stem) flags.push(...scanText(stem, "stem", null));
  choices.forEach((c, i) => flags.push(...scanText(c.choice_text, "choice", i)));
  // Any free-text field shown back to the student is an answer channel
  // (DECISION-0057), not only the stem and choices.
  if (extra.title) flags.push(...scanText(extra.title, "title", null));
  if (extra.source_note) flags.push(...scanText(extra.source_note, "source_note", null));
  return flags;
}

export const MASK_CHAR = "▒";

function maskSpans(text: string, spans: LeakFlag[]) {
  let out = "";
  let cursor = 0;
  for (const s of spans) {
    out += text.slice(cursor, s.start) + MASK_CHAR.repeat(Math.max(3, Math.min(12, s.end - s.start)));
    cursor = s.end;
  }
  return out + text.slice(cursor);
}

function removeSpans(text: string, spans: LeakFlag[]) {
  let out = "";
  let cursor = 0;
  for (const s of spans) {
    out += text.slice(cursor, s.start);
    cursor = s.end;
  }
  return (out + text.slice(cursor)).replace(/[ \t]+\n/g, "\n").replace(/\n{3,}/g, "\n\n").trim();
}

/** Masked-by-default view (§6.1 item 2): flagged spans never reach the screen unmasked. */
export function maskedView(
  stem: string | null,
  choices: ChoiceInput[],
  flags: LeakFlag[],
  extra: { title?: string | null; source_note?: string | null } = {},
) {
  const maskField = (v: string | null | undefined, field: LeakFlag["field"]) =>
    v === null || v === undefined ? v ?? null : maskSpans(v, flags.filter((f) => f.field === field));
  return {
    title: maskField(extra.title, "title"),
    source_note: maskField(extra.source_note, "source_note"),
    stem: stem === null ? null : maskSpans(stem, flags.filter((f) => f.field === "stem")),
    choices: choices.map((c, i) => ({
      choice_key: c.choice_key,
      choice_text: maskSpans(c.choice_text, flags.filter((f) => f.field === "choice" && f.index === i)),
    })),
  };
}

/** Removes flagged spans so the student never has to reveal them to fix them (§6.3). */
export function removeFlaggedText(
  stem: string | null,
  choices: ChoiceInput[],
  flags: LeakFlag[],
  extra: { title?: string | null; source_note?: string | null } = {},
) {
  const clean = (v: string | null | undefined, field: LeakFlag["field"]) =>
    v === null || v === undefined ? null : removeSpans(v, flags.filter((f) => f.field === field)) || null;
  return {
    title: clean(extra.title, "title"),
    source_note: clean(extra.source_note, "source_note"),
    stem: stem === null ? null : removeSpans(stem, flags.filter((f) => f.field === "stem")) || null,
    choices: choices.map((c, i) => ({
      choice_key: c.choice_key,
      choice_text: removeSpans(c.choice_text, flags.filter((f) => f.field === "choice" && f.index === i)),
    })),
  };
}

/* -------------------------------------------------------------------------- */
/* Input validation                                                            */
/* -------------------------------------------------------------------------- */

export interface ChoiceInput {
  choice_key: string;
  choice_text: string;
}

export type ItemType = "mcq" | "frq";

export interface ItemFields {
  item_type?: ItemType | null;
  title?: string | null;
  stem?: string | null;
  choices?: ChoiceInput[];
  subject_key?: string | null;
  unit_number?: number | null;
  topic_code?: string | null;
  difficulty?: "easy" | "medium" | "hard" | null;
  source_kind?: "typed" | "photo_single";
  source_note?: string | null;
}

export type Validation<T> = { ok: true; value: T } | { ok: false; error: string };

function optText(v: unknown, max: number, field: string): Validation<string | null | undefined> {
  if (v === undefined) return { ok: true, value: undefined };
  if (v === null) return { ok: true, value: null };
  if (typeof v !== "string") return { ok: false, error: `invalid_${field}` };
  const t = v.replace(/\r\n?/g, "\n").trim();
  if (t.length > max) return { ok: false, error: `${field}_too_long` };
  return { ok: true, value: t.length ? t : null };
}

/**
 * Validates a partial item payload. Accepts only whitelisted fields, so no
 * caller can set status, owner, leak_flags, or anything answer-shaped: an
 * `is_correct` (or any other extra key) on a choice is rejected outright
 * rather than silently dropped, so a buggy client fails loudly.
 */
export function validateItemFields(raw: Record<string, unknown>): Validation<ItemFields> {
  const out: ItemFields = {};

  if (raw.item_type !== undefined) {
    if (raw.item_type !== null && raw.item_type !== "mcq" && raw.item_type !== "frq") {
      return { ok: false, error: "invalid_item_type" };
    }
    out.item_type = raw.item_type as ItemType | null;
  }

  const title = optText(raw.title, BYOQ_LIMITS.titleMaxChars, "title");
  if (!title.ok) return title;
  if (title.value !== undefined) out.title = title.value;

  const stem = optText(raw.stem, BYOQ_LIMITS.stemMaxChars, "stem");
  if (!stem.ok) return stem;
  if (stem.value !== undefined) out.stem = stem.value;

  const note = optText(raw.source_note, BYOQ_LIMITS.sourceNoteMaxChars, "source_note");
  if (!note.ok) return note;
  if (note.value !== undefined) out.source_note = note.value;

  if (raw.choices !== undefined) {
    if (!Array.isArray(raw.choices)) return { ok: false, error: "invalid_choices" };
    if (raw.choices.length > BYOQ_LIMITS.choicesMax) return { ok: false, error: "too_many_choices" };
    const choices: ChoiceInput[] = [];
    for (let i = 0; i < raw.choices.length; i++) {
      const c = raw.choices[i];
      const text = typeof c === "string"
        ? c
        : c && typeof c === "object" && !Array.isArray(c)
        ? (() => {
          const keys = Object.keys(c as object).filter((k) => k !== "choice_key");
          if (keys.length !== 1 || keys[0] !== "choice_text") return null;
          return (c as Record<string, unknown>).choice_text;
        })()
        : null;
      if (typeof text !== "string") return { ok: false, error: "invalid_choice_shape" };
      const t = text.replace(/\r\n?/g, "\n").trim();
      if (!t) return { ok: false, error: "empty_choice" };
      if (t.length > BYOQ_LIMITS.choiceMaxChars) return { ok: false, error: "choice_too_long" };
      // Keys are server-assigned by position; a client key is never trusted.
      choices.push({ choice_key: String.fromCharCode(65 + i), choice_text: t });
    }
    out.choices = choices;
  }

  if (raw.subject_key !== undefined) {
    if (raw.subject_key !== null && (typeof raw.subject_key !== "string" || !/^[a-z0-9_-]{2,64}$/.test(raw.subject_key))) {
      return { ok: false, error: "invalid_subject_key" };
    }
    out.subject_key = raw.subject_key === null ? null : (raw.subject_key as string).replaceAll("-", "_");
  }
  if (raw.unit_number !== undefined) {
    if (raw.unit_number !== null && (!Number.isInteger(raw.unit_number) || (raw.unit_number as number) < 1 || (raw.unit_number as number) > 20)) {
      return { ok: false, error: "invalid_unit_number" };
    }
    out.unit_number = raw.unit_number as number | null;
  }
  if (raw.topic_code !== undefined) {
    if (raw.topic_code !== null && (typeof raw.topic_code !== "string" || !/^[0-9]{1,2}\.[0-9]{1,2}$/.test(raw.topic_code))) {
      return { ok: false, error: "invalid_topic_code" };
    }
    out.topic_code = raw.topic_code as string | null;
  }
  if (raw.difficulty !== undefined) {
    if (raw.difficulty !== null && !["easy", "medium", "hard"].includes(raw.difficulty as string)) {
      return { ok: false, error: "invalid_difficulty" };
    }
    out.difficulty = raw.difficulty as ItemFields["difficulty"];
  }
  if (raw.source_kind !== undefined) {
    if (raw.source_kind !== "typed" && raw.source_kind !== "photo_single") {
      return { ok: false, error: "invalid_source_kind" };
    }
    out.source_kind = raw.source_kind;
  }
  return { ok: true, value: out };
}

/** Why an item cannot be marked ready yet, or null when it can. */
export function readinessProblem(item: {
  item_type: ItemType | null;
  stem: string | null;
  choices: ChoiceInput[];
  leak_flags: LeakFlag[];
}): string | null {
  if (!item.item_type) return "item_type_required";
  if (!item.stem || !item.stem.trim()) return "stem_required";
  if (item.leak_flags.length > 0) return "answer_text_detected";
  if (item.item_type === "mcq") {
    if (item.choices.length < BYOQ_LIMITS.choicesMin) return "mcq_needs_choices";
  } else if (item.choices.length > 0) {
    return "frq_has_choices";
  }
  return null;
}

export function validateResponseInput(raw: Record<string, unknown>, itemType: ItemType, choiceCount: number):
  Validation<{ selected_choice_key: string | null; response_text: string | null; is_final: boolean }> {
  let selected: string | null = null;
  if (raw.selected_choice_key !== undefined && raw.selected_choice_key !== null) {
    if (itemType !== "mcq") return { ok: false, error: "frq_has_no_choices" };
    if (typeof raw.selected_choice_key !== "string" || !/^[A-F]$/.test(raw.selected_choice_key)) {
      return { ok: false, error: "invalid_choice_key" };
    }
    if (raw.selected_choice_key.charCodeAt(0) - 65 >= choiceCount) {
      return { ok: false, error: "unknown_choice_key" };
    }
    selected = raw.selected_choice_key;
  }
  const text = optText(raw.response_text, BYOQ_LIMITS.responseTextMaxChars, "response_text");
  if (!text.ok) return text;
  return { ok: true, value: { selected_choice_key: selected, response_text: text.value ?? null, is_final: raw.is_final === true } };
}

/* -------------------------------------------------------------------------- */
/* Storage paths                                                               */
/* -------------------------------------------------------------------------- */

export function extensionFor(mediaType: ByoqMediaType) {
  return mediaType === "image/png" ? "png" : mediaType === "image/webp" ? "webp" : "jpg";
}

/**
 * A recognized owner's objects go under `<user_id>/byoq/...` so the existing
 * learner-uploads owner policies (keyed on the first path segment) let that
 * student manage their own objects. An anonymous owner has no auth.uid(), so
 * its objects live under `byoq-anon/<owner_id>/...`, reachable only through
 * this function's signed URLs.
 */
export function ownerStoragePrefix(owner: { id: string; user_id: string | null }) {
  return owner.user_id ? `${owner.user_id}/byoq/${owner.id}` : `byoq-anon/${owner.id}`;
}

export function uploadPath(params: {
  storagePrefix: string;
  itemId: string;
  pairingId: string;
  attempt: number;
  mediaType: ByoqMediaType;
}) {
  return `${incomingObjectPrefix(params.storagePrefix, params.itemId, params.pairingId)}${params.attempt}.${extensionFor(params.mediaType)}`;
}

export function finalPath(params: {
  owner: { id: string; user_id: string | null };
  itemId: string;
  role: "question" | "response";
  fileId: string;
  mediaType: ByoqMediaType;
}) {
  return `${ownerStoragePrefix(params.owner)}/${params.itemId}/${params.role}/${params.fileId}.${extensionFor(params.mediaType)}`;
}

/** Every prefix an owner's objects may live under (it changes when an anonymous owner is recognized). */
export function allOwnerStoragePrefixes(owner: { id: string; user_id: string | null }) {
  const anon = `byoq-anon/${owner.id}`;
  return owner.user_id ? [anon, ownerStoragePrefix(owner)] : [anon];
}

export function incomingFolder(storagePrefix: string, itemId: string) {
  return `${storagePrefix}/${itemId}/incoming`;
}

export function incomingObjectPrefix(storagePrefix: string, itemId: string, pairingId: string) {
  return `${incomingFolder(storagePrefix, itemId)}/${pairingId}-`;
}

export function isSafeByoqPath(path: string) {
  return path.length > 0 && path.length < 400 &&
    !path.startsWith("/") && !path.includes("..") && !path.includes("\\") &&
    !path.includes("//") && !path.includes("\0");
}

/* -------------------------------------------------------------------------- */
/* Copy                                                                        */
/* -------------------------------------------------------------------------- */

export const NOT_SCORED_MESSAGE =
  "This is your question, so CramApple can't score it — there's no answer key for a question we didn't write. Use the reference and scoring guidance to check your own work.";
