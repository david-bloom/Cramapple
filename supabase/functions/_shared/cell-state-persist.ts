// Course Mode F2/F3 — live cell-state write hook.
//
// The production entry point the F2/F3 PR deliberately staged out (see
// COURSE_MODE_STATUS_AND_HANDOFF.md §3/§7): the pure tier engine in
// cell-state.ts computes WHAT to write, this module actually WRITES it after a
// real graded attempt. It turns "graded + cell-tagged" into "mastery updated".
//
// Routing (plan F2, CM-FACT-20): keyed on ATTEMPT/ITEM identity, never session
// presence. An item updates a cell iff it carries an app.content_item_cells tag;
// legacy/authored items with no tag are a silent no-op (the common case), so a
// sessionless/manual grade still updates its cell and a non-course-mode grade is
// untouched. Best-effort: any failure here is logged and the write SKIPPED (never
// performed from fabricated inputs) so a mastery-write problem can never fail the
// grade itself (mirrors grading-memory.ts's posture).
//
// Determinism (INV-4): the tier transition is entirely cell-state.ts. This module
// only (a) derives the deterministic event + signal from the grade + provenance
// and (b) persists. Invariants honored by the engine: supported success is
// provisional (INV-5), a miss reopens without zeroing (INV-6), an uncertain grade
// writes no evidence (CM-D07 content_uncertain).
//
// Concurrency + idempotency (Fable QA PR #101): each cell write is
//   - idempotent per (cell, attempt): a re-grade of the SAME attempt is skipped
//     via last_attempt_id, so one attempt is at most one evidence event (F2);
//   - optimistically concurrent: read + guarded update/insert with one retry, so
//     two graded attempts racing the same cell don't lose an update (F8);
//   - guarded on every read: a transient DB error SKIPS the write rather than
//     proceeding from a fabricated "first attempt ever" prior (F1).

import { createServiceClient } from "./supabase.ts";
import {
  applyAttempt,
  type CellEvent,
  type CellState,
  classifySameSession,
  initialCellState,
} from "./cell-state.ts";
import {
  attemptIdempotency,
  deriveCellEvent,
  deriveChangedSurface,
  paramsHash,
  readProvenance,
  rowToCellState,
} from "./cell-state-signals.ts";

type ServiceClient = ReturnType<typeof createServiceClient>;

// ---------------------------------------------------------------------------
// Write hook. (Pure signal derivation lives in cell-state-signals.ts so it can
// be unit-tested without the Supabase client, which cannot be resolved offline.)
// ---------------------------------------------------------------------------

export type PersistCellStateInput = {
  service: ServiceClient;
  userId: string;
  contentItemVersionId: string;
  attemptId: string;
  subjectId: string; // the attempt's subject (from exam_packs.subject_id, by UUID)
  sessionId: string | null;
  assistanceState: string | null;
  finalStatus: string; // "graded" | "uncertain" | "failed"
  pointsEarned: number;
  pointsAvailable: number;
  submittedAt?: string | null; // attempt.submitted_at — the real event time (F12)
  now?: Date;
};

export type PersistCellStateResult = {
  updated: Array<{
    topic_code: string;
    skill_code: string;
    tier: CellState["tier"];
    event: CellEvent;
    weight: number;
  }>;
} | null;

// Canonicalize a subject key across the hyphen/underscore namespace split
// (subjects.subject_key uses hyphens, taxonomy_source_versions.subject_key uses
// underscores — §6). Map ONLY separators (hyphen/underscore/whitespace) to a
// single underscore rather than stripping all punctuation, so `ap-statistics`
// and `ap_statistics` match while genuinely distinct keys that differ only in
// digit-adjacency (`ap-stats-2` vs `apstats2`) do NOT collide (re-QA finding 9).
function normalizeSubjectKey(key: string): string {
  return key.trim().toLowerCase().replace(/[-_\s]+/g, "_");
}

export async function persistCellState(
  input: PersistCellStateInput,
): Promise<PersistCellStateResult> {
  // The mastery event's time is the attempt's own submitted_at, not the grading
  // wall-clock (F12) — a delayed/manual/re-grade must not fake recency forward
  // (skews the same-session window + decay). Fall back to now for a missing or
  // unparseable timestamp.
  const parsedSubmitted = input.submittedAt
    ? new Date(input.submittedAt)
    : null;
  const now = parsedSubmitted && !Number.isNaN(parsedSubmitted.getTime())
    ? parsedSubmitted
    : (input.now ?? new Date());
  try {
    // 1. Item -> cell(s). A read ERROR must skip (not masquerade as "no tag");
    //    only a genuine empty result means "not course-mode content".
    const { data: cellRows, error: cellErr } = await input.service.schema("app")
      .from("content_item_cells")
      .select("taxonomy_source_version, topic_code, skill_code")
      .eq("content_item_version_id", input.contentItemVersionId);
    if (cellErr) {
      console.error("cell_state_persist_cells_read_failed", {
        content_item_version_id: input.contentItemVersionId,
        error: cellErr.message,
      });
      return null;
    }
    if (!Array.isArray(cellRows) || cellRows.length === 0) return null;

    // 2. Provenance -> (templateId, paramsHash) for the changed-surface signal.
    //    A read error skips (F1): a null provenance would inflate weight to 1.0.
    const { data: versionRow, error: versionErr } = await input.service
      .schema("app")
      .from("content_item_versions")
      .select("item_package_payload")
      .eq("id", input.contentItemVersionId)
      .maybeSingle();
    if (versionErr) {
      console.error("cell_state_persist_version_read_failed", {
        content_item_version_id: input.contentItemVersionId,
        error: versionErr.message,
      });
      return null;
    }
    const provenance = readProvenance(versionRow?.item_package_payload);
    const rawParamsHash = await paramsHash(provenance.params, provenance.seed);
    // F3: an item with no generator provenance (authored items; a generator that
    // forgot the field) must NOT count every attempt as a changed surface (which
    // would award weight 1.0 to a byte-identical repeat and over-promote a cell).
    // Fall back to the version's own id as its (template, params) identity, so a
    // repeat of the SAME item version is "not changed" (0.35) while a different
    // item version is "changed".
    const versionIdentity = `civ:${input.contentItemVersionId}`;
    const currentTemplateId = provenance.templateId ?? versionIdentity;
    const currentParamsHash = rawParamsHash ?? versionIdentity;

    // 3. Subject-consistency reference (F7): the canonical subject key for the
    //    attempt's subject. Cells are cross-checked against this before writing,
    //    so a cell from a different subject than the attempt can never land with
    //    a mismatched subject_id.
    const { data: subjectRow, error: subjectErr } = await input.service
      .schema("app")
      .from("subjects")
      .select("subject_key")
      .eq("id", input.subjectId)
      .maybeSingle();
    if (subjectErr || !subjectRow?.subject_key) {
      console.error("cell_state_persist_subject_read_failed", {
        subject_id: input.subjectId,
        error: subjectErr?.message ?? "subject not found",
      });
      return null;
    }
    const attemptSubjectKey = normalizeSubjectKey(
      String(subjectRow.subject_key),
    );
    const taxonomySubjectKeyCache = new Map<string, string | null>();
    const taxonomyReadFailed = new Set<string>();

    const event = deriveCellEvent({
      finalStatus: input.finalStatus,
      pointsEarned: input.pointsEarned,
      pointsAvailable: input.pointsAvailable,
    });
    const assisted = (input.assistanceState ?? "independent") !== "independent";

    const updated: NonNullable<PersistCellStateResult>["updated"] = [];

    // Pilot items are single-cell, but the tag table permits several; each cell
    // accumulates its OWN evidence (INV-2: never pool across cells).
    for (const cell of cellRows) {
      const taxonomyVersion = cell.taxonomy_source_version as string;
      const topicCode = cell.topic_code as string;
      const skillCode = cell.skill_code as string;

      // F7: the cell's taxonomy subject must match the attempt's subject, or the
      // row would land with a wrong subject_id (the composite FK to taxonomy_cells
      // does not include subject_id, so it would not catch it). Skip + log a
      // mismatch rather than write a cross-subject row.
      if (!taxonomySubjectKeyCache.has(taxonomyVersion)) {
        const { data: tsvRow, error: tsvErr } = await input.service.schema(
          "app",
        )
          .from("taxonomy_source_versions")
          .select("subject_key")
          .eq("taxonomy_source_version", taxonomyVersion)
          .maybeSingle();
        if (tsvErr) {
          // A read error is a SKIP (F1 posture), not a cross-subject mismatch —
          // logged here once, and not re-logged as a phantom mismatch below (F6).
          console.error("cell_state_persist_taxonomy_subject_read_failed", {
            taxonomy_source_version: taxonomyVersion,
            error: tsvErr.message,
          });
          taxonomyReadFailed.add(taxonomyVersion);
          taxonomySubjectKeyCache.set(taxonomyVersion, null);
        } else {
          taxonomySubjectKeyCache.set(
            taxonomyVersion,
            tsvRow?.subject_key ? String(tsvRow.subject_key) : null,
          );
        }
      }
      // A failed taxonomy read already logged its own reason — skip quietly.
      if (taxonomyReadFailed.has(taxonomyVersion)) continue;
      const cellSubjectKey = taxonomySubjectKeyCache.get(taxonomyVersion) ??
        null;
      if (
        cellSubjectKey === null ||
        normalizeSubjectKey(cellSubjectKey) !== attemptSubjectKey
      ) {
        console.error("cell_state_persist_subject_mismatch", {
          content_item_version_id: input.contentItemVersionId,
          attempt_subject_id: input.subjectId,
          cell_taxonomy_source_version: taxonomyVersion,
          topic_code: topicCode,
          skill_code: skillCode,
        });
        continue;
      }

      const applied = await applyToCell({
        service: input.service,
        userId: input.userId,
        subjectId: input.subjectId,
        attemptId: input.attemptId,
        sessionId: input.sessionId,
        taxonomyVersion,
        topicCode,
        skillCode,
        event,
        assisted,
        currentTemplateId,
        currentParamsHash,
        now,
      });
      if (applied) updated.push(applied);
    }

    return { updated };
  } catch (error) {
    console.error("cell_state_persist_failed", error);
    return null;
  }
}

type AppliedCell = {
  topic_code: string;
  skill_code: string;
  tier: CellState["tier"];
  event: CellEvent;
  weight: number;
};

// One cell's read-modify-write, with per-attempt idempotency (F2), an F1 skip on
// any read error, F6 surface-reference preservation on uncertain grades, and an
// optimistic-concurrency guard with a single retry (F8).
async function applyToCell(args: {
  service: ServiceClient;
  userId: string;
  subjectId: string;
  attemptId: string;
  sessionId: string | null;
  taxonomyVersion: string;
  topicCode: string;
  skillCode: string;
  event: CellEvent;
  assisted: boolean;
  currentTemplateId: string;
  currentParamsHash: string;
  now: Date;
}): Promise<AppliedCell | null> {
  const {
    service,
    userId,
    subjectId,
    attemptId,
    sessionId,
    taxonomyVersion,
    topicCode,
    skillCode,
    event,
    assisted,
    currentTemplateId,
    currentParamsHash,
    now,
  } = args;

  for (let attemptTry = 0; attemptTry < 2; attemptTry++) {
    const { data: existing, error: readErr } = await service.schema("app")
      .from("student_cell_state")
      .select(
        "tier, fragile, weighted_evidence, last_independent_success_at, last_attempt_at, last_exposure_at, next_due_at, due_reason, last_session_id, last_template_id, last_params_hash, last_attempt_id, updated_at",
      )
      .eq("user_id", userId)
      .eq("taxonomy_source_version", taxonomyVersion)
      .eq("topic_code", topicCode)
      .eq("skill_code", skillCode)
      .maybeSingle();
    // F1: a read error must NOT be treated as "first attempt" (which would
    // overwrite a real row from initialCellState). Skip the write.
    if (readErr) {
      console.error("cell_state_persist_state_read_failed", {
        topic_code: topicCode,
        skill_code: skillCode,
        error: readErr.message,
      });
      return null;
    }

    // F2 + re-QA finding 2: skip a re-grade of the same attempt; stamp
    // last_attempt_id only on an evidence-bearing (graded) write.
    const idem = attemptIdempotency({
      priorAttemptId: (existing?.last_attempt_id as string | null) ?? null,
      attemptId,
      event,
    });
    if (idem.skip) return null;

    const prior = existing ? rowToCellState(existing) : initialCellState();

    const changedSurface = deriveChangedSurface(
      {
        templateId: (existing?.last_template_id as string | null) ?? null,
        paramsHash: (existing?.last_params_hash as string | null) ?? null,
      },
      { templateId: currentTemplateId, paramsHash: currentParamsHash },
    );
    const sameSession = classifySameSession(
      sessionId,
      (existing?.last_session_id as string | null) ?? null,
      now,
      existing?.last_attempt_at
        ? new Date(existing.last_attempt_at as string)
        : null,
    );

    const { state, weight, version } = applyAttempt(
      prior,
      event,
      {
        assisted,
        uncertain: event === "content_uncertain",
        changedSurface,
        sameSession,
      },
      now,
    );

    const uncertain = event === "content_uncertain";

    // F6: an untrusted (content_uncertain) attempt records recency but must NOT
    // shift the changed-surface reference — otherwise a later trusted re-serve of
    // the SAME item is judged "changed" (weight 1.0) against the uncertain item.
    const surfaceTemplateId = uncertain
      ? ((existing?.last_template_id as string | null) ?? null)
      : currentTemplateId;
    const surfaceParamsHash = uncertain
      ? ((existing?.last_params_hash as string | null) ?? null)
      : currentParamsHash;

    const rowPayload = {
      user_id: userId,
      subject_id: subjectId,
      taxonomy_source_version: taxonomyVersion,
      topic_code: topicCode,
      skill_code: skillCode,
      tier: state.tier,
      fragile: state.fragile,
      weighted_evidence: state.weighted_evidence,
      last_independent_success_at: state.last_independent_success_at,
      last_attempt_at: state.last_attempt_at,
      last_exposure_at: state.last_exposure_at,
      next_due_at: state.next_due_at,
      due_reason: state.due_reason,
      last_event: event,
      last_weight: weight,
      rule_engine_version: version,
      last_session_id: sessionId,
      last_template_id: surfaceTemplateId,
      last_params_hash: surfaceParamsHash,
      last_attempt_id: idem.stampAttemptId,
    };

    if (existing) {
      // F8: optimistic update guarded by the row's updated_at. If another write
      // moved updated_at between our read and here, 0 rows match -> re-read and
      // recompute once (never blind-clobber a concurrent evidence write).
      const { data: updatedRows, error: updErr } = await service.schema("app")
        .from("student_cell_state")
        .update(rowPayload)
        .eq("user_id", userId)
        .eq("taxonomy_source_version", taxonomyVersion)
        .eq("topic_code", topicCode)
        .eq("skill_code", skillCode)
        .eq("updated_at", existing.updated_at as string)
        .select("student_cell_state_id");
      if (updErr) {
        console.error("cell_state_persist_update_failed", {
          topic_code: topicCode,
          skill_code: skillCode,
          error: updErr.message,
        });
        return null;
      }
      if (Array.isArray(updatedRows) && updatedRows.length > 0) {
        return {
          topic_code: topicCode,
          skill_code: skillCode,
          tier: state.tier,
          event,
          weight,
        };
      }
      // Lost the optimistic race -> loop and re-read.
      continue;
    }

    const { error: insErr } = await service.schema("app")
      .from("student_cell_state")
      .insert(rowPayload);
    if (!insErr) {
      return {
        topic_code: topicCode,
        skill_code: skillCode,
        tier: state.tier,
        event,
        weight,
      };
    }
    // A concurrent insert won the unique key -> re-read and take the update path.
    if ((insErr as { code?: string }).code === "23505") continue;
    console.error("cell_state_persist_insert_failed", {
      topic_code: topicCode,
      skill_code: skillCode,
      error: insErr.message,
    });
    return null;
  }

  console.error("cell_state_persist_write_contended", {
    topic_code: topicCode,
    skill_code: skillCode,
  });
  return null;
}
