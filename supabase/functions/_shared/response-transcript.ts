// Pure decision logic for the transcript-confirmation step of a photographed
// FRQ answer (DECISION-0110). `attempt-response` calls these; they are unit
// tested without a database.
//
// The response_parts convention for a photographed answer
// (plan §6, docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md):
//
//   {
//     "<part_key>": "<confirmed text>",            -- one per item part
//     "_source": "photo_transcript",
//     "_transcript": { ...TranscriptRecord },      -- the model's proposal, kept
//     "_student_added": { "<part_key>": [spans] }, -- typed at review, not read
//     "_confirmed_at": "<iso timestamp>",
//     "_confirmed_digest": "<sha256 of the original photo the student confirmed>",
//     "_confirmed_content_digest": "<app.response_content_digest of the confirmed text + parts>"
//   }
//
// The confirmation is written by app.confirm_response_transcript and checked
// by app.response_versions_guard_submission INSIDE the submit transaction
// (TASK-0069 QA P1-a/P1-b): the photo digest must equal the current original
// and the content digest must equal the current text and parts, so neither a
// retake nor a direct edit after confirming can reach the grader.
//
// Keys beginning with "_" are reserved: app.response_versions_guard_reserved_parts
// refuses them from any non-service-role writer, so a student cannot PATCH a
// confirmation into existence through PostgREST. The confirmed digest ties the
// confirmation to ONE photo: a retake supersedes the original, the digest no
// longer matches, and the gate closes again until the student re-confirms.
//
// Before confirmation the row holds `{ capture: "pending" }` (the draft the
// capture capability was bound to) plus `_transcript` once a proposal exists.

import { flattenTranscript, type TranscriptRecord } from "./drawn-response-extraction.ts";

export const CONFIRM_PART_MAX_CHARS = 8_000;
export const STUDENT_ADDED_MAX_SPANS = 20;
export const STUDENT_ADDED_SPAN_MAX_CHARS = 2_000;

export interface ItemPart {
  part_key: string;
  prompt_text: string | null;
}

/**
 * The item's answer parts, read from `prompt_json.parts` the same way the
 * student screen does (part_key plus the authored prompt, either spelling).
 * Falls back to one part keyed `response`, matching `PracticeFrqScreen`'s
 * single-response item. Never copies any other prompt_json field.
 */
export function deriveItemParts(promptJson: unknown): ItemPart[] {
  const raw = promptJson && typeof promptJson === "object"
    ? (promptJson as Record<string, unknown>).parts
    : null;
  if (Array.isArray(raw)) {
    const parts: ItemPart[] = [];
    const seen = new Set<string>();
    for (const entry of raw) {
      if (!entry || typeof entry !== "object") continue;
      const e = entry as Record<string, unknown>;
      const key = typeof e.part_key === "string" ? e.part_key.trim() : "";
      if (!key || seen.has(key)) continue;
      seen.add(key);
      const prompt = typeof e.prompt === "string"
        ? e.prompt
        : typeof e.prompt_text === "string"
        ? e.prompt_text
        : null;
      parts.push({ part_key: key, prompt_text: prompt && prompt.trim() ? prompt.trim() : null });
    }
    if (parts.length) return parts;
  }
  return [{ part_key: "response", prompt_text: null }];
}

export function readResponseParts(value: unknown): Record<string, unknown> {
  if (value && typeof value === "object" && !Array.isArray(value)) return value as Record<string, unknown>;
  if (typeof value === "string") {
    try {
      const parsed = JSON.parse(value);
      if (parsed && typeof parsed === "object" && !Array.isArray(parsed)) return parsed as Record<string, unknown>;
    } catch {
      /* not JSON */
    }
  }
  return {};
}

export function readTranscriptRecord(responseParts: Record<string, unknown>): TranscriptRecord | null {
  const t = responseParts._transcript;
  if (!t || typeof t !== "object") return null;
  const rec = t as Record<string, unknown>;
  if (typeof rec.status !== "string" || typeof rec.key !== "string") return null;
  return rec as unknown as TranscriptRecord;
}

/** True once the student has confirmed a transcript on this response version. */
export function isTranscriptConfirmed(responseParts: Record<string, unknown>): boolean {
  return typeof responseParts._confirmed_at === "string" && responseParts._confirmed_at.length > 0;
}

/**
 * True when a confirmation exists but was given for a different photo than
 * the one currently bound (the student retook the page after confirming).
 */
export function confirmationIsStale(
  responseParts: Record<string, unknown>,
  currentDigest: string | null,
): boolean {
  if (!isTranscriptConfirmed(responseParts)) return false;
  const confirmed = responseParts._confirmed_digest;
  return typeof confirmed !== "string" || confirmed.length === 0 || confirmed !== currentDigest;
}

/** Reserved keys a re-propose for a NEW photo clears, so a stale confirmation cannot survive a retake. */
export const CONFIRMATION_KEYS = ["_confirmed_at", "_confirmed_digest", "_confirmed_content_digest", "_source", "_student_added"] as const;

export type ConfirmValidation =
  | {
    ok: true;
    parts: Record<string, string>;
    studentAdded: Record<string, string[]>;
    responseText: string;
  }
  | { ok: false; reason: "unknown_part" | "part_too_long" | "transcript_empty" | "student_added_invalid" };

/**
 * Validates the student's confirmed parts against the item's parts and
 * produces the response text the grader will read. Every item part is
 * present in the output (missing parts become ""), unknown keys are refused,
 * and at least one part must carry text (a photo with nothing readable and
 * nothing added has nothing to grade).
 */
export function validateConfirmedParts(params: {
  itemParts: ItemPart[];
  submitted: unknown;
  studentAdded: unknown;
}): ConfirmValidation {
  const allowed = new Set(params.itemParts.map((p) => p.part_key));
  const submitted = params.submitted && typeof params.submitted === "object" && !Array.isArray(params.submitted)
    ? params.submitted as Record<string, unknown>
    : {};
  const parts: Record<string, string> = {};
  for (const p of params.itemParts) parts[p.part_key] = "";
  for (const [key, value] of Object.entries(submitted)) {
    if (!allowed.has(key)) return { ok: false, reason: "unknown_part" };
    const text = typeof value === "string" ? value.replace(/\r\n?/g, "\n").trim() : "";
    if (text.length > CONFIRM_PART_MAX_CHARS) return { ok: false, reason: "part_too_long" };
    parts[key] = text;
  }
  if (!Object.values(parts).some((t) => t.length > 0)) return { ok: false, reason: "transcript_empty" };

  const studentAdded: Record<string, string[]> = {};
  if (params.studentAdded !== undefined && params.studentAdded !== null) {
    if (typeof params.studentAdded !== "object" || Array.isArray(params.studentAdded)) {
      return { ok: false, reason: "student_added_invalid" };
    }
    for (const [key, value] of Object.entries(params.studentAdded as Record<string, unknown>)) {
      if (!allowed.has(key)) return { ok: false, reason: "unknown_part" };
      if (!Array.isArray(value)) return { ok: false, reason: "student_added_invalid" };
      const spans = value
        .filter((s): s is string => typeof s === "string")
        .map((s) => s.trim())
        .filter(Boolean)
        .slice(0, STUDENT_ADDED_MAX_SPANS)
        .map((s) => s.slice(0, STUDENT_ADDED_SPAN_MAX_CHARS));
      if (spans.length) studentAdded[key] = spans;
    }
  }

  const ordered = params.itemParts.map((p) => ({ part_key: p.part_key, text: parts[p.part_key] ?? "" }));
  return { ok: true, parts, studentAdded, responseText: flattenTranscript(ordered) };
}

/**
 * Spans the student typed at review that the model did not propose: any
 * confirmed text not found verbatim in the proposed part. A coarse, honest
 * signal for the transcript-fidelity metric, computed server-side so the
 * client cannot omit it.
 */
export function inferStudentAdded(params: {
  proposed: Record<string, string>;
  confirmed: Record<string, string>;
}): Record<string, string[]> {
  const out: Record<string, string[]> = {};
  for (const [key, text] of Object.entries(params.confirmed)) {
    const proposed = params.proposed[key] ?? "";
    if (!text.trim()) continue;
    if (!proposed.trim()) {
      out[key] = [text.slice(0, STUDENT_ADDED_SPAN_MAX_CHARS)];
      continue;
    }
    const added = text
      .split(/\n+/)
      .map((line) => line.trim())
      .filter((line) => line && !proposed.includes(line))
      .slice(0, STUDENT_ADDED_MAX_SPANS)
      .map((line) => line.slice(0, STUDENT_ADDED_SPAN_MAX_CHARS));
    if (added.length) out[key] = added;
  }
  return out;
}

/** The owner-facing view of a stored transcript record. */
export function transcriptView(rec: TranscriptRecord | null) {
  if (!rec) return null;
  return {
    status: rec.status,
    prompt_version: rec.prompt_version,
    model: rec.model,
    warnings: rec.warnings,
    failure: rec.failure,
    latency_ms: rec.latency_ms,
    proposed: rec.proposed,
    created_at: rec.created_at,
  };
}
