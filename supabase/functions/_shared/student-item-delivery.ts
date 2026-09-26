// TASK-0021 — student prompt-visual delivery rules.
// Task: docs/tasks/TASK-0021-BIOLOGY-PROMPT-VISUAL-STUDENT-DELIVERY.md
//
// The visibility and fail-closed decisions used by the student-session-items
// function live here as pure functions so they can be tested without a
// database, a storage backend, or a live session. The function itself is left
// with I/O and ordering only.

export const STIMULUS_IMAGE_BUCKET = "content-assets";

// Deliberately shorter than review-queue's 3600s: a reviewer works a queue,
// a student renders one item at a time and the client re-fetches on expiry.
export const SIGNED_URL_TTL_SECONDS = 900;

export const MAX_ITEMS = 20;

// Roles allowed to render assets that have not yet cleared Learning Quality
// review -- the "QA-visible" half of the gate. `student` is deliberately
// absent and must stay absent.
export const STAFF_QA_ROLES: ReadonlySet<string> = new Set([
  "admin",
  "content_author",
  "tutor",
  "reader",
  "validator",
]);

export function isStaffQaRole(role: string): boolean {
  return STAFF_QA_ROLES.has(role);
}

export type SelectedRow = {
  content_item_version_id: string;
  content_item_id: string;
  content_key: string;
  title: string | null;
  stem: string;
  stimulus: string | null;
  stimulus_image_path: string | null;
  frq_form: string | null;
  practice_format: string | null;
  // Present when rows come from select_unit_gated_practice_items (mcq /
  // quantitative / frq); absent (treated as "frq") for the older
  // select_practice_frqs path, which only ever selects FRQs.
  item_type?: string;
  // Computed by the caller from prompt_json->>'hand_drawn' before this row
  // reaches buildRenderItem -- never read from a raw DB column here, so the
  // rest of prompt_json (which can carry answer-bearing fields like
  // expected_graph_spec) never has to flow through this type. TASK-0038
  // Phase 3.
  hand_drawn?: boolean;
};

export type McqChoice = {
  choice_key: string;
  choice_text: string;
};

export type AssetMetadata = {
  content_item_version_id: string;
  storage_bucket: string;
  storage_path: string;
  alt_text: string;
  long_description: string | null;
  approved_at: string | null;
};

export type LearnerFacingCriterion = {
  content_item_version_id: string;
  criterion_key: string;
  learner_facing_text: string | null;
  points_possible: number | null;
};

// Enum strings only. Never echo a storage path or a raw database error --
// that would turn the omission list into a probe for private paths.
export type OmissionReason =
  | "asset_metadata_missing"
  | "asset_not_approved_for_students"
  | "asset_sign_failed"
  | "choices_missing"
  | "required_visual_absent"
  | "required_visual_not_approved";

// Reviewer judgment from app.content_visual_requirements. Only 'yes' rows
// affect serving.
export type VisualRequirement = {
  content_item_version_id: string;
  image_needed: "yes" | "no_constructs" | "no_not_needed";
  image_approval:
    | "approved"
    | "approved_with_edits"
    | "disapproved"
    | "missing"
    | null;
};

// An image the reviewer approved, with or without edits, is servable. Anything
// else -- disapproved, or explicitly marked missing -- is not.
const SERVABLE_IMAGE_APPROVALS = new Set(["approved", "approved_with_edits"]);

export type Omission = { content_key: string; reason: OmissionReason };

export type RenderMedia = {
  kind: "image";
  url: string;
  alt: string;
  long_description: string | null;
  required: true;
  expires_at: string;
  qa_unapproved: boolean;
};

export type RenderItem = {
  content_item_version_id: string;
  content_item_id: string;
  content_key: string;
  title: string | null;
  stem: string;
  stimulus: string | null;
  item_type: string;
  frq_form: string | null;
  practice_format: string | null;
  parts: Array<{
    part_key: string;
    prompt_text: string;
    points_possible: number | null;
  }>;
  // Only for item_type mcq/quantitative. Deliberately choice_key/choice_text
  // only -- is_correct and rationale are answer-bearing and must never reach
  // a student, same rule toLearnerFacingParts already applies to criteria.
  choices: McqChoice[] | null;
  media: RenderMedia[];
  // "hand_drawn" means the expected answer is a photographed hand-drawn
  // response (TASK-0038), submitted via the capture pipeline
  // (attach_capture) instead of typed text. Only ever "hand_drawn" for rows
  // select_hand_drawn_pilot_items returns -- see SelectedRow.hand_drawn.
  response_mode: "typed" | "hand_drawn";
  // TASK-0047 Decision 17 follow-on -- generic, subject-agnostic resolved
  // topic/cell identity. Additive: absent (null) for any item neither
  // resolution path below can identify (no cell tag AND no non-empty
  // taxonomy label) -- never fabricated. See buildResolvedCell.
  cell: RenderCell | null;
};

// A resolved topic/cell identity for a served item. Two distinct
// granularities feed this, chosen per item by buildResolvedCell:
//   1. Fine-grained -- app.content_item_cells (topic_code + skill_code).
//      Today this is exclusively AP Statistics (the hand-authored pilot map
//      stats-unit1-skills.ts is built on the same table), but the shape here
//      carries no subject assumption -- any subject with cell tags resolves
//      the same way.
//   2. Coarse -- app.content_taxonomy_labels.assessed_topics (topic-only, no
//      skill sub-division). skill_code is always null on this path -- it is
//      NOT a stand-in for a missing skill, it is a genuinely coarser
//      granularity that must not be confused with the fine-grained one.
// topic_title is populated from app.taxonomy_topics (topic_code +
// taxonomy_source_version -> topic_title) uniformly for both paths -- that
// table carries plain-language names for every subject already, so no new
// content authoring is needed here.
export type RenderCell = {
  topic_code: string;
  skill_code: string | null;
  topic_title: string | null;
  // From app.taxonomy_topics.unit_number -- lets a caller key a per-unit
  // lookup (e.g. the topic-guides RPC) without needing the coarse label's
  // own primary_unit, which is frequently null (verified directly against
  // Production 2026-09-26 for AP Biology).
  unit_number: number | null;
};

// TASK-0047 Workstream E — item-package dual-read adapter.
//
// Two content shapes exist for the same catalogue:
//   1. The legacy per-row schema (app.mcq_choices / app.frq_criteria), read
//      exclusively above. Every currently-published item -- including all 203
//      whose content_item_versions.item_package_payload is populated -- has
//      complete legacy rows (verified directly against Production 2026-09-26:
//      0 published items have a null stem or a missing choice set alongside a
//      populated item_package_payload). So today this fallback is never
//      exercised; it exists so a future item authored ONLY in the newer
//      package shape -- no legacy rows backfilled -- still serves, per
//      David's decision: no mass migration, no forced format choice on new
//      content (APP_REBUILD_MIGRATION_PLAN.md §5.5, decision 23).
//
//   2. The item-package JSON shape, which is not one format but two distinct
//      ones observed in the wild:
//        a. `content/item-packages/*.json` on disk (schema_version "1.0.0"):
//           top-level `mcq_choices: [{choice_key, choice_text, is_correct,
//           rationale}]`, `parts: [{part_key, prompt, criteria: [...]}]`.
//           Never ingested into item_package_payload for any published item
//           checked (e.g. apcalcab-mcq-021 is published with full legacy rows
//           and item_package_payload NULL) -- these files are an authoring
//           artifact that gets flattened into the legacy schema at publish
//           time, not something serving reads today.
//        b. `content_item_versions.item_package_payload` in Production
//           (schema_version "course-mode-generated-0.1", all 203 populated
//           rows are AP Statistics MCQ from the Course Mode generator):
//           `mcq_form.options: [{text, correct, misconception}]`, top-level
//           `prompt`/`stem`, `parts: [{prompt, criteria}]`.
//      Both are read here so either can back-fill missing legacy data for the
//      same item_type: 'mcq' case that is actually populated today.
//
// FRQ criteria fallback is deliberately NOT implemented. Neither package
// shape carries a field equivalent to frq_criteria.learner_facing_text (a
// reviewer-authored, pre-filtered "safe to show a student" string) --
// `criteria[].description`/`required_evidence` are answer-bearing, the same
// class of field toLearnerFacingParts already excludes for the legacy shape.
// Deciding what, if anything, in the package criteria shape is safe to derive
// as learner-facing is a content-safety judgment call beyond this workstream's
// scope (no published item needs it yet -- 0 gaps found), not an engineering
// stopgap; flagged for a follow-up decision if/when an FRQ-only-package item
// is ever published without legacy criteria rows.
export type ItemPackagePayload = {
  schema_version?: string;
  stem?: unknown;
  prompt?: unknown;
  mcq_choices?: unknown;
  mcq_form?: { options?: unknown };
  parts?: unknown;
  stimuli?: unknown;
};

function firstNonEmptyString(...candidates: unknown[]): string | null {
  for (const c of candidates) {
    if (typeof c === "string" && c.trim().length > 0) return c;
  }
  return null;
}

/**
 * Derives student-facing stem text from either package shape, falling back
 * through top-level `stem`/`prompt` to the first part's `prompt`. Never reads
 * `canonical_answers` or any criteria field -- those are answer-bearing.
 */
export function derivePackageStem(
  payload: ItemPackagePayload | null | undefined,
): string | null {
  if (!payload || typeof payload !== "object") return null;
  const direct = firstNonEmptyString(payload.stem, payload.prompt);
  if (direct) return direct;
  const parts = Array.isArray(payload.parts) ? payload.parts : [];
  const firstPart = parts[0] as Record<string, unknown> | undefined;
  return firstNonEmptyString(firstPart?.prompt);
}

/**
 * Derives the first text stimulus's body, if any. Mirrors the legacy
 * `stimulus` column -- optional context shown above the stem.
 */
export function derivePackageStimulus(
  payload: ItemPackagePayload | null | undefined,
): string | null {
  if (!payload || typeof payload !== "object") return null;
  const stimuli = Array.isArray(payload.stimuli) ? payload.stimuli : [];
  for (const s of stimuli) {
    const stim = s as Record<string, unknown>;
    const text = (stim?.payload as Record<string, unknown> | undefined)?.text;
    if (typeof text === "string" && text.trim().length > 0) return text;
  }
  return null;
}

/**
 * Derives choice_key/choice_text pairs from either package shape. Deliberately
 * whitelist-only, same rule as the legacy mcq_choices select above: is_correct
 * / correct / rationale / misconception never leave this function.
 */
export function derivePackageChoices(
  payload: ItemPackagePayload | null | undefined,
): McqChoice[] | null {
  if (!payload || typeof payload !== "object") return null;

  if (Array.isArray(payload.mcq_choices) && payload.mcq_choices.length) {
    const choices: McqChoice[] = [];
    for (const c of payload.mcq_choices) {
      const choice = c as Record<string, unknown>;
      const key = choice?.choice_key;
      const text = choice?.choice_text;
      if (typeof key === "string" && typeof text === "string") {
        choices.push({ choice_key: key, choice_text: text });
      }
    }
    return choices.length ? choices : null;
  }

  const options = payload.mcq_form?.options;
  if (Array.isArray(options) && options.length) {
    const letters = ["A", "B", "C", "D", "E", "F"];
    const choices: McqChoice[] = [];
    options.forEach((o, i) => {
      const opt = o as Record<string, unknown>;
      const text = opt?.text;
      if (typeof text === "string" && letters[i]) {
        choices.push({ choice_key: letters[i], choice_text: text });
      }
    });
    return choices.length ? choices : null;
  }

  return null;
}

/**
 * Applies the dual-read fallback: for a row whose legacy stem/choices came
 * back empty, backfills from item_package_payload when one exists for that
 * version. Rows and choice lists that already have legacy data pass through
 * completely unchanged -- this is additive-only, so no existing content path
 * (100% of Production today) is affected.
 */
export function applyItemPackageFallback(
  rows: readonly SelectedRow[],
  choicesByVersion: ReadonlyMap<string, McqChoice[]>,
  payloadByVersion: ReadonlyMap<string, ItemPackagePayload>,
): { rows: SelectedRow[]; choicesByVersion: Map<string, McqChoice[]> } {
  const nextChoicesByVersion = new Map(choicesByVersion);

  const nextRows = rows.map((row) => {
    const payload = payloadByVersion.get(row.content_item_version_id);
    if (!payload) return row;

    const hasStem = typeof row.stem === "string" && row.stem.trim().length > 0;
    const patchedStem = hasStem ? row.stem : derivePackageStem(payload);
    const patchedStimulus = row.stimulus ?? derivePackageStimulus(payload);

    if (
      row.item_type === "mcq" &&
      !(nextChoicesByVersion.get(row.content_item_version_id)?.length)
    ) {
      const derived = derivePackageChoices(payload);
      if (derived) {
        nextChoicesByVersion.set(row.content_item_version_id, derived);
      }
    }

    if (patchedStem === row.stem && patchedStimulus === row.stimulus) {
      return row;
    }
    return { ...row, stem: patchedStem ?? row.stem, stimulus: patchedStimulus };
  });

  return { rows: nextRows, choicesByVersion: nextChoicesByVersion };
}

// ---------------------------------------------------------------------------
// TASK-0047 Decision 17 follow-on -- resolved topic/cell identity.
//
// ConfirmTransferBeat's trigger and the Course Mode pilot map are hardcoded to
// AP Statistics because topic identity for any other subject only lives in
// the database, never in the content_key (unlike Statistics' structured
// `apstat-u1-<topic>-<skillletter>` keys). This resolves a generic identifier
// per served item so a non-Statistics subject can eventually be gated the
// same way, without inventing any new schema.
// ---------------------------------------------------------------------------

export type CellRow = {
  content_item_version_id: string;
  taxonomy_source_version: string;
  topic_code: string;
  skill_code: string;
};

// Keyed by content_item_id, NOT content_item_version_id -- this table
// pre-dates the fine-grained cell/version model and labels the item, not a
// specific version. assessed_topics is empty for the large majority of
// AP Biology today (a known, separate content-labeling gap); the caller
// passes only rows with a non-empty array here.
export type TaxonomyLabelRow = {
  content_item_id: string;
  taxonomy_source_version: string;
  assessed_topics: string[] | null;
};

export type TaxonomyTopicTitleRow = {
  taxonomy_source_version: string;
  topic_code: string;
  topic_title: string | null;
  unit_number: number | null;
};

type TaxonomyTopicMeta = { topic_title: string | null; unit_number: number | null };

function taxonomyTitleKey(taxonomySourceVersion: string, topicCode: string) {
  return `${taxonomySourceVersion}::${topicCode}`;
}

export function indexTaxonomyTitles(
  rows: readonly TaxonomyTopicTitleRow[],
): Map<string, TaxonomyTopicMeta> {
  const byKey = new Map<string, TaxonomyTopicMeta>();
  for (const r of rows) {
    byKey.set(
      taxonomyTitleKey(r.taxonomy_source_version, r.topic_code),
      { topic_title: r.topic_title, unit_number: r.unit_number },
    );
  }
  return byKey;
}

/**
 * Resolves a RenderCell per content_item_version_id, preferring the
 * fine-grained content_item_cells tag (topic_code + skill_code) and falling
 * back to the coarser content_taxonomy_labels topic (topic_code only,
 * skill_code null) when no cell tag exists. An item with neither -- no cell
 * tag AND no non-empty assessed_topics -- resolves to no entry at all; the
 * caller must treat a missing map entry as "no cell", never fabricate one.
 *
 * multi_topic_arrays are not expected (verified directly against Production
 * 2026-09-26: 0 of 605 AP Biology content_taxonomy_labels rows carry more
 * than one assessed_topics entry), but if one ever does, only the first
 * topic is used -- a defined, deterministic tie-break, not an assumption of
 * uniqueness.
 */
export function buildResolvedCells(
  rows: readonly SelectedRow[],
  cellRows: readonly CellRow[],
  labelRows: readonly TaxonomyLabelRow[],
  titleByKey: ReadonlyMap<string, TaxonomyTopicMeta>,
): Map<string, RenderCell> {
  const result = new Map<string, RenderCell>();

  const cellByVersion = new Map<string, CellRow>();
  for (const c of cellRows) {
    if (!cellByVersion.has(c.content_item_version_id)) {
      cellByVersion.set(c.content_item_version_id, c);
    }
  }

  const labelByItem = new Map<string, TaxonomyLabelRow>();
  for (const l of labelRows) {
    if (!labelByItem.has(l.content_item_id)) {
      labelByItem.set(l.content_item_id, l);
    }
  }

  for (const row of rows) {
    const cell = cellByVersion.get(row.content_item_version_id);
    if (cell) {
      const meta = titleByKey.get(
        taxonomyTitleKey(cell.taxonomy_source_version, cell.topic_code),
      );
      result.set(row.content_item_version_id, {
        topic_code: cell.topic_code,
        skill_code: cell.skill_code,
        topic_title: meta?.topic_title ?? null,
        unit_number: meta?.unit_number ?? null,
      });
      continue;
    }

    const label = labelByItem.get(row.content_item_id);
    const topicCode = label?.assessed_topics?.[0];
    if (label && typeof topicCode === "string" && topicCode.trim().length > 0) {
      const meta = titleByKey.get(
        taxonomyTitleKey(label.taxonomy_source_version, topicCode),
      );
      result.set(row.content_item_version_id, {
        topic_code: topicCode,
        skill_code: null,
        topic_title: meta?.topic_title ?? null,
        unit_number: meta?.unit_number ?? null,
      });
    }
    // Else: neither resolution path applies -- absent, not fabricated.
  }

  return result;
}

export function assetKey(
  versionId: string,
  bucket: string,
  path: string,
): string {
  return `${versionId} ${bucket} ${path}`;
}

export function indexAssets(
  assets: readonly AssetMetadata[],
): Map<string, AssetMetadata> {
  const byKey = new Map<string, AssetMetadata>();
  for (const asset of assets) {
    byKey.set(
      assetKey(
        asset.content_item_version_id,
        asset.storage_bucket,
        asset.storage_path,
      ),
      asset,
    );
  }
  return byKey;
}

/**
 * Decides, before anything is signed, which items may be delivered.
 *
 * An item with no `stimulus_image_path` has no required visual and is
 * deliverable on its own. An item that has one is deliverable only when
 * approved accessibility metadata exists -- and, for a student caller, only
 * when that metadata has actually been approved.
 */
export function partitionDeliverable(
  rows: readonly SelectedRow[],
  assetsByKey: ReadonlyMap<string, AssetMetadata>,
  qaMode: boolean,
  visualByVersion: ReadonlyMap<string, VisualRequirement> = new Map(),
): {
  deliverable: Array<{ row: SelectedRow; asset: AssetMetadata | null }>;
  omitted: Omission[];
} {
  const deliverable: Array<{ row: SelectedRow; asset: AssetMetadata | null }> =
    [];
  const omitted: Omission[] = [];

  for (const row of rows) {
    const path = row.stimulus_image_path;

    // Reviewer judgment first. content_asset_metadata can only gate items that
    // HAVE an image; it cannot see an item that NEEDS one and has none, which
    // is indistinguishable from a legitimately text-only item (APBIO-FRQ-L-028
    // is exactly that). This check is the only thing that catches it.
    //
    // Absence of a requirement row means "not yet reviewed", and is permissive
    // by design: failing closed on unknown would withhold the entire catalogue,
    // since no item is classified until a reviewer gets to it. The gate tightens
    // as review coverage grows.
    const requirement = visualByVersion.get(row.content_item_version_id);
    if (requirement?.image_needed === "yes") {
      if (
        !requirement.image_approval ||
        !SERVABLE_IMAGE_APPROVALS.has(requirement.image_approval)
      ) {
        omitted.push({
          content_key: row.content_key,
          reason: !path || requirement.image_approval === "missing"
            ? "required_visual_absent"
            : "required_visual_not_approved",
        });
        continue;
      }
      if (!path) {
        // Reviewer approved an image that is not attached to this version.
        omitted.push({
          content_key: row.content_key,
          reason: "required_visual_absent",
        });
        continue;
      }
    }

    if (!path) {
      deliverable.push({ row, asset: null });
      continue;
    }

    const asset =
      assetsByKey.get(
        assetKey(row.content_item_version_id, STIMULUS_IMAGE_BUCKET, path),
      ) ?? null;

    if (!asset) {
      omitted.push({
        content_key: row.content_key,
        reason: "asset_metadata_missing",
      });
      continue;
    }
    if (!asset.approved_at && !qaMode) {
      omitted.push({
        content_key: row.content_key,
        reason: "asset_not_approved_for_students",
      });
      continue;
    }
    deliverable.push({ row, asset });
  }

  return { deliverable, omitted };
}

/**
 * Maps grading criteria to student-facing parts.
 *
 * Only criterion_key, learner_facing_text, and points_possible are carried.
 * The same rows also hold evidence_requirements, minimum_fix, and
 * accepted_variants, which are answer-bearing; a criterion with no
 * learner-facing text is a grading-only row and is dropped rather than
 * surfacing as an empty part.
 */
export function toLearnerFacingParts(
  criteria: readonly LearnerFacingCriterion[],
): RenderItem["parts"] {
  return criteria
    .filter((c) =>
      typeof c.learner_facing_text === "string" &&
      c.learner_facing_text.trim().length > 0
    )
    .map((c) => ({
      part_key: c.criterion_key,
      prompt_text: (c.learner_facing_text as string),
      points_possible: c.points_possible,
    }));
}

/**
 * Builds the student-facing render payload.
 *
 * Returns null when the item required a visual that could not be signed --
 * the selection-time half of the fail-closed rule. An unanswerable item is
 * withheld rather than shipped.
 *
 * This is a strict whitelist by construction. prompt_json is never forwarded:
 * on AP Biology items it carries a `criteria` key, and grading-only fields
 * such as expected_graph_spec must not reach a student.
 */
export function buildRenderItem(
  row: SelectedRow,
  asset: AssetMetadata | null,
  signedUrl: string | null,
  expiresAt: string,
  criteria: readonly LearnerFacingCriterion[],
  choices: readonly McqChoice[] | null = null,
  cell: RenderCell | null = null,
): RenderItem | null {
  let media: RenderMedia[] = [];

  if (asset) {
    if (!signedUrl) return null;
    media = [{
      kind: "image",
      url: signedUrl,
      alt: asset.alt_text,
      long_description: asset.long_description,
      required: true,
      expires_at: expiresAt,
      // Lets a QA client distinguish "rendered for review" from "cleared to
      // ship". Never true for a student caller, because an unapproved asset
      // never reaches one.
      qa_unapproved: !asset.approved_at,
    }];
  }

  return {
    content_item_version_id: row.content_item_version_id,
    content_item_id: row.content_item_id,
    content_key: row.content_key,
    title: row.title,
    stem: row.stem,
    stimulus: row.stimulus,
    item_type: row.item_type ?? "frq",
    frq_form: row.frq_form,
    practice_format: row.practice_format,
    parts: toLearnerFacingParts(criteria),
    choices: choices && choices.length ? [...choices] : null,
    media,
    response_mode: row.hand_drawn === true ? "hand_drawn" : "typed",
    cell,
  };
}
