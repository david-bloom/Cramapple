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
// untouched. Best-effort: any failure here is logged and swallowed so a
// mastery-write problem can never fail the grade itself (mirrors
// grading-memory.ts's posture).
//
// Determinism (INV-4): the tier transition is entirely cell-state.ts. This module
// only (a) derives the deterministic event + signal from the grade + provenance
// and (b) persists. Invariants honored by the engine: supported success is
// provisional (INV-5), a miss reopens without zeroing (INV-6), an uncertain grade
// writes no evidence (CM-D07 content_uncertain).

import { createServiceClient } from "./supabase.ts";
import {
  applyAttempt,
  type CellEvent,
  type CellState,
  classifySameSession,
  initialCellState,
} from "./cell-state.ts";
import {
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
  examPackId: string; // resolves subject_id by UUID (never raw subject_key)
  sessionId: string | null;
  assistanceState: string | null;
  finalStatus: string; // "graded" | "uncertain" | "failed"
  pointsEarned: number;
  pointsAvailable: number;
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

export async function persistCellState(
  input: PersistCellStateInput,
): Promise<PersistCellStateResult> {
  const now = input.now ?? new Date();
  try {
    // 1. Item -> cell(s). No tag => not course-mode content => nothing to do.
    const { data: cellRows } = await input.service.schema("app")
      .from("content_item_cells")
      .select("taxonomy_source_version, topic_code, skill_code")
      .eq("content_item_version_id", input.contentItemVersionId);

    if (!Array.isArray(cellRows) || cellRows.length === 0) return null;

    // 2. subject_id by UUID from the attempt's exam pack (the hyphen/underscore
    //    subject_key namespace trap makes a text join unsafe -- CM-FACT-20 / §6).
    const { data: examPack } = await input.service.schema("app")
      .from("exam_packs")
      .select("subject_id")
      .eq("id", input.examPackId)
      .maybeSingle();
    const subjectId = examPack?.subject_id as string | undefined;
    if (!subjectId) {
      console.error("cell_state_persist_no_subject", {
        content_item_version_id: input.contentItemVersionId,
      });
      return null;
    }

    // 3. Provenance -> (templateId, paramsHash) for the changed-surface signal.
    const { data: versionRow } = await input.service.schema("app")
      .from("content_item_versions")
      .select("item_package_payload")
      .eq("id", input.contentItemVersionId)
      .maybeSingle();
    const provenance = readProvenance(versionRow?.item_package_payload);
    const currentParamsHash = await paramsHash(
      provenance.params,
      provenance.seed,
    );
    const currentTemplateId = provenance.templateId;

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

      const { data: existing } = await input.service.schema("app")
        .from("student_cell_state")
        .select(
          "tier, fragile, weighted_evidence, last_independent_success_at, last_attempt_at, last_exposure_at, next_due_at, due_reason, last_session_id, last_template_id, last_params_hash",
        )
        .eq("user_id", input.userId)
        .eq("taxonomy_source_version", taxonomyVersion)
        .eq("topic_code", topicCode)
        .eq("skill_code", skillCode)
        .maybeSingle();

      const prior = existing ? rowToCellState(existing) : initialCellState();

      const changedSurface = deriveChangedSurface(
        {
          templateId: (existing?.last_template_id as string | null) ?? null,
          paramsHash: (existing?.last_params_hash as string | null) ?? null,
        },
        { templateId: currentTemplateId, paramsHash: currentParamsHash },
      );
      const sameSession = classifySameSession(
        input.sessionId,
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

      const { error: upsertError } = await input.service.schema("app")
        .from("student_cell_state")
        .upsert({
          user_id: input.userId,
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
          // Classifier inputs the NEXT attempt reads to judge changed-surface /
          // same-session, carried on the row (F2 migration comment / finding 5).
          last_session_id: input.sessionId,
          last_template_id: currentTemplateId,
          last_params_hash: currentParamsHash,
        }, {
          onConflict: "user_id,taxonomy_source_version,topic_code,skill_code",
        });

      if (upsertError) {
        console.error("cell_state_persist_upsert_failed", {
          content_item_version_id: input.contentItemVersionId,
          topic_code: topicCode,
          skill_code: skillCode,
          error: upsertError.message,
        });
        continue;
      }

      updated.push({
        topic_code: topicCode,
        skill_code: skillCode,
        tier: state.tier,
        event,
        weight,
      });
    }

    return { updated };
  } catch (error) {
    console.error("cell_state_persist_failed", error);
    return null;
  }
}
