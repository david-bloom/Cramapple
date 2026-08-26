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
};

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
  };
}
