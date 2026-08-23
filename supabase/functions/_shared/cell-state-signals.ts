// Course Mode F3 — pure signal derivation for the live cell-state write hook.
//
// Deliberately DEPENDENCY-FREE (imports only types from cell-state.ts): the DB
// write in cell-state-persist.ts pulls in the Supabase client, which cannot be
// resolved offline, so the deterministic decision logic lives here where it is
// exhaustively unit-testable (INV-4) -- the same split that keeps cell-state.ts
// itself pure and testable. These functions turn a graded attempt + a generated
// item's provenance into the (event, changed-surface, params-identity) inputs
// the classifier/rule-engine consume.

import type { CellEvent, CellState } from "./cell-state.ts";

/** Map a grading outcome to the deterministic mastery event (CM-D07).
 *  A non-graded final status (uncertain/failed) or a zero-point item carries no
 *  trustworthy signal -> content_uncertain (records the attempt, no evidence).
 *  A graded item is correct iff it earned full marks, else a direct miss. */
export function deriveCellEvent(input: {
  finalStatus: string;
  pointsEarned: number;
  pointsAvailable: number;
}): CellEvent {
  if (input.finalStatus !== "graded") return "content_uncertain";
  // A non-finite score (NaN/Infinity from a malformed payload) is not a
  // trustworthy signal — never let it fall through to a false "incorrect"/miss.
  if (
    !Number.isFinite(input.pointsEarned) ||
    !Number.isFinite(input.pointsAvailable)
  ) {
    return "content_uncertain";
  }
  if (!(input.pointsAvailable > 0)) return "content_uncertain";
  return input.pointsEarned >= input.pointsAvailable ? "correct" : "incorrect";
}

/** Per-(cell, attempt) idempotency + stamp decision (re-QA findings 2 & round-1
 *  F2). Two rules, deliberately pure so they're exhaustively testable:
 *   - SKIP when this exact attempt already produced the row's current state (a
 *     re-grade of the same attempt) — at-most-once, first *evidence-bearing*
 *     grade wins.
 *   - STAMP `last_attempt_id` only on an evidence-bearing (graded correct/
 *     incorrect) write. A `content_uncertain` write carries no evidence, so it
 *     preserves the prior stamp — otherwise an uncertain hold (or a "failed"
 *     grade) would consume the idempotency budget and permanently skip a later
 *     successful re-grade of the same attempt. */
export function attemptIdempotency(input: {
  priorAttemptId: string | null;
  attemptId: string;
  event: CellEvent;
}): { skip: boolean; stampAttemptId: string | null } {
  if (input.priorAttemptId === input.attemptId) {
    return { skip: true, stampAttemptId: input.priorAttemptId };
  }
  const stampAttemptId = input.event === "content_uncertain"
    ? input.priorAttemptId
    : input.attemptId;
  return { skip: false, stampAttemptId };
}

/** "changed surface" = NOT the same (template, params) as the cell's last
 *  attempt (CM-D07 / F3 pin: "same template + DIFFERENT params"; same params =
 *  not changed). Only a POSITIVE match on both ids counts as unchanged, so a
 *  first attempt (no prior) or missing provenance is treated as varied/novel
 *  rather than penalized to the 0.35 same-item weight. */
export function deriveChangedSurface(
  prior: { templateId: string | null; paramsHash: string | null },
  current: { templateId: string | null; paramsHash: string | null },
): boolean {
  const sameItem = current.templateId != null &&
    current.paramsHash != null &&
    prior.templateId === current.templateId &&
    prior.paramsHash === current.paramsHash;
  return !sameItem;
}

/** Stable stringification with sorted object keys so a params hash is identity,
 *  not insertion-order dependent. */
export function canonicalJson(value: unknown): string {
  if (value === null || typeof value !== "object") return JSON.stringify(value);
  if (Array.isArray(value)) {
    return `[${value.map((v) => canonicalJson(v)).join(",")}]`;
  }
  const entries = Object.keys(value as Record<string, unknown>)
    .sort()
    .map((k) =>
      `${JSON.stringify(k)}:${
        canonicalJson((value as Record<string, unknown>)[k])
      }`
    );
  return `{${entries.join(",")}}`;
}

async function sha256Hex(value: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

/** A short, stable identity for the generated instance's params. Returns null
 *  when there is nothing to hash (so deriveChangedSurface treats it as novel). */
export async function paramsHash(
  params: unknown,
  seed: unknown,
): Promise<string | null> {
  if (params !== undefined && params !== null) {
    return await sha256Hex(canonicalJson(params));
  }
  if (seed !== undefined && seed !== null) {
    // Generators emit an int seed today, but guard against a non-primitive seed
    // collapsing to "seed:[object Object]" (collision-prone): hash it canonically.
    const seedKey = typeof seed === "object"
      ? canonicalJson(seed)
      : String(seed);
    return `seed:${seedKey}`;
  }
  return null;
}

/** Read the (template_id, params, seed) provenance a generated item package
 *  carries at item_package_payload.provenance (see the Stats generator). Absent
 *  for authored items -> null ids -> every attempt counts as a changed surface. */
export function readProvenance(
  itemPackagePayload: unknown,
): { templateId: string | null; params: unknown; seed: unknown } {
  const payload = itemPackagePayload &&
      typeof itemPackagePayload === "object" &&
      !Array.isArray(itemPackagePayload)
    ? itemPackagePayload as Record<string, unknown>
    : {};
  const prov = payload.provenance &&
      typeof payload.provenance === "object" &&
      !Array.isArray(payload.provenance)
    ? payload.provenance as Record<string, unknown>
    : {};
  const templateId = typeof prov.template_id === "string"
    ? prov.template_id
    : null;
  return { templateId, params: prov.params ?? null, seed: prov.seed ?? null };
}

/** A stored student_cell_state row -> the engine's CellState shape. */
export function rowToCellState(row: Record<string, unknown>): CellState {
  return {
    tier: (row.tier as CellState["tier"]) ?? "unseen",
    fragile: Boolean(row.fragile),
    weighted_evidence: Number(row.weighted_evidence ?? 0),
    last_independent_success_at:
      (row.last_independent_success_at as string | null) ?? null,
    last_attempt_at: (row.last_attempt_at as string | null) ?? null,
    last_exposure_at: (row.last_exposure_at as string | null) ?? null,
    next_due_at: (row.next_due_at as string | null) ?? null,
    due_reason: (row.due_reason as CellState["due_reason"]) ?? null,
  };
}
