// TASK-0021 — student prompt-visual delivery rules.
// Task: docs/tasks/TASK-0021-BIOLOGY-PROMPT-VISUAL-STUDENT-DELIVERY.md
//
// These cover the Acceptance Criteria that say fail-closed and the
// student-visibility gate must be proven by test, not by code review.

import {
  assert,
  assertEquals,
  assertFalse,
} from "https://deno.land/std@0.224.0/assert/mod.ts";
import {
  type AssetMetadata,
  buildRenderItem,
  indexAssets,
  isStaffQaRole,
  type LearnerFacingCriterion,
  partitionDeliverable,
  type SelectedRow,
  SIGNED_URL_TTL_SECONDS,
  STAFF_QA_ROLES,
  toLearnerFacingParts,
} from "./student-item-delivery.ts";

const VERSION_A = "11111111-1111-4111-8111-111111111111";
const VERSION_B = "22222222-2222-4222-8222-222222222222";

function row(overrides: Partial<SelectedRow> = {}): SelectedRow {
  return {
    content_item_version_id: VERSION_A,
    content_item_id: "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa",
    content_key: "APBIO-FRQ-L-003",
    title: "Photosynthesis rates",
    stem: "Analyze the data.",
    stimulus: "Table 1 shows...",
    stimulus_image_path: "Biology/FRQ/APBIO-FRQ-L-003.png",
    frq_form: "long",
    practice_format: "targeted_drill",
    ...overrides,
  };
}

function asset(overrides: Partial<AssetMetadata> = {}): AssetMetadata {
  return {
    content_item_version_id: VERSION_A,
    storage_bucket: "content-assets",
    storage_path: "Biology/FRQ/APBIO-FRQ-L-003.png",
    alt_text: "Line graph of photosynthesis rate versus light intensity.",
    long_description: "Rate rises linearly then plateaus near 600 umol.",
    approved_at: "2026-08-05T00:00:00Z",
    ...overrides,
  };
}

// ── Student-visibility gate ───────────────────────────────────────────────

Deno.test("student is not served an item whose visual has no approval record", () => {
  const { deliverable, omitted } = partitionDeliverable(
    [row()],
    indexAssets([asset({ approved_at: null })]),
    false,
  );

  assertEquals(deliverable.length, 0);
  assertEquals(omitted, [{
    content_key: "APBIO-FRQ-L-003",
    reason: "asset_not_approved_for_students",
  }]);
});

Deno.test("staff QA may render the same unapproved item", () => {
  const { deliverable, omitted } = partitionDeliverable(
    [row()],
    indexAssets([asset({ approved_at: null })]),
    true,
  );

  assertEquals(omitted.length, 0);
  assertEquals(deliverable.length, 1);
  assertEquals(deliverable[0].asset?.approved_at, null);
});

Deno.test("student IS served the item once approval is recorded", () => {
  const { deliverable, omitted } = partitionDeliverable(
    [row()],
    indexAssets([asset()]),
    false,
  );

  assertEquals(omitted.length, 0);
  assertEquals(deliverable.length, 1);
});

Deno.test("`student` is not a QA role, and the staff roles are exactly the expected set", () => {
  assertFalse(isStaffQaRole("student"));
  assertFalse(isStaffQaRole(""));
  assertFalse(isStaffQaRole("Student"));
  assertEquals(
    [...STAFF_QA_ROLES].sort(),
    ["admin", "content_author", "reader", "tutor", "validator"],
  );
});

// ── Fail-closed at selection time ─────────────────────────────────────────

Deno.test("item with a required visual but no metadata row is withheld from everyone", () => {
  for (const qaMode of [false, true]) {
    const { deliverable, omitted } = partitionDeliverable(
      [row()],
      indexAssets([]),
      qaMode,
    );
    assertEquals(deliverable.length, 0, `qaMode=${qaMode}`);
    assertEquals(omitted[0].reason, "asset_metadata_missing");
  }
});

Deno.test("item with no required visual is deliverable on its own", () => {
  const { deliverable, omitted } = partitionDeliverable(
    [row({ stimulus_image_path: null })],
    indexAssets([]),
    false,
  );

  assertEquals(omitted.length, 0);
  assertEquals(deliverable.length, 1);
  assertEquals(deliverable[0].asset, null);
});

Deno.test("unsignable required visual yields no item rather than a broken one", () => {
  const item = buildRenderItem(row(), asset(), null, "2026-08-05T00:15:00Z", []);
  assertEquals(item, null);
});

Deno.test("metadata for a different item version does not satisfy this item's visual", () => {
  // Guards against keying on path alone: same path, wrong version.
  const { deliverable, omitted } = partitionDeliverable(
    [row()],
    indexAssets([asset({ content_item_version_id: VERSION_B })]),
    false,
  );

  assertEquals(deliverable.length, 0);
  assertEquals(omitted[0].reason, "asset_metadata_missing");
});

Deno.test("metadata in a different bucket does not satisfy this item's visual", () => {
  const { deliverable, omitted } = partitionDeliverable(
    [row()],
    indexAssets([asset({ storage_bucket: "validation-artifacts" })]),
    false,
  );

  assertEquals(deliverable.length, 0);
  assertEquals(omitted[0].reason, "asset_metadata_missing");
});

Deno.test("a mixed batch withholds only the ineligible items", () => {
  const ok = row({ content_key: "APBIO-FRQ-L-009", stimulus_image_path: null });
  const gated = row({ content_key: "APBIO-FRQ-L-003" });

  const { deliverable, omitted } = partitionDeliverable(
    [ok, gated],
    indexAssets([asset({ approved_at: null })]),
    false,
  );

  assertEquals(deliverable.map((d) => d.row.content_key), ["APBIO-FRQ-L-009"]);
  assertEquals(omitted.map((o) => o.content_key), ["APBIO-FRQ-L-003"]);
});

// ── Answer-leakage / payload whitelist ────────────────────────────────────

Deno.test("grading-only criteria never surface as student-facing parts", () => {
  const criteria: LearnerFacingCriterion[] = [
    {
      content_item_version_id: VERSION_A,
      criterion_key: "a",
      learner_facing_text: "Describe the trend.",
      points_possible: 2,
    },
    // A grading-only row: no learner-facing text. Must be dropped, not
    // rendered as an empty part.
    {
      content_item_version_id: VERSION_A,
      criterion_key: "b",
      learner_facing_text: null,
      points_possible: 2,
    },
    {
      content_item_version_id: VERSION_A,
      criterion_key: "c",
      learner_facing_text: "   ",
      points_possible: 1,
    },
  ];

  assertEquals(toLearnerFacingParts(criteria), [
    { part_key: "a", prompt_text: "Describe the trend.", points_possible: 2 },
  ]);
});

Deno.test("render payload carries no grading or answer-bearing field", () => {
  const item = buildRenderItem(
    row(),
    asset(),
    "https://example.test/signed",
    "2026-08-05T00:15:00Z",
    [{
      content_item_version_id: VERSION_A,
      criterion_key: "a",
      learner_facing_text: "Describe the trend.",
      points_possible: 2,
    }],
  );
  assert(item);

  // Serialize the way the function actually returns it, so a nested leak is
  // caught rather than only a top-level one.
  const serialized = JSON.stringify(item);
  for (
    const forbidden of [
      "prompt_json",
      "criteria",
      "evidence_requirements",
      "minimum_fix",
      "accepted_variants",
      "canonical_answer",
      "explanation",
      "expected_graph_spec",
      "rubric",
    ]
  ) {
    assertFalse(
      serialized.includes(forbidden),
      `render payload must not contain ${forbidden}`,
    );
  }

  assertEquals(Object.keys(item).sort(), [
    "content_item_id",
    "content_item_version_id",
    "content_key",
    "frq_form",
    "media",
    "parts",
    "practice_format",
    "stem",
    "stimulus",
    "title",
  ]);
});

// ── Accessibility metadata reaches the client ─────────────────────────────

Deno.test("approved alt and long description are attached to the rendered visual", () => {
  const item = buildRenderItem(
    row(),
    asset(),
    "https://example.test/signed",
    "2026-08-05T00:15:00Z",
    [],
  );
  assert(item);
  assertEquals(item.media.length, 1);
  assertEquals(
    item.media[0].alt,
    "Line graph of photosynthesis rate versus light intensity.",
  );
  assertEquals(
    item.media[0].long_description,
    "Rate rises linearly then plateaus near 600 umol.",
  );
  assertEquals(item.media[0].required, true);
  assertEquals(item.media[0].qa_unapproved, false);
  assertEquals(item.media[0].expires_at, "2026-08-05T00:15:00Z");
});

Deno.test("a QA-rendered unapproved asset is flagged as such", () => {
  const item = buildRenderItem(
    row(),
    asset({ approved_at: null }),
    "https://example.test/signed",
    "2026-08-05T00:15:00Z",
    [],
  );
  assert(item);
  assertEquals(item.media[0].qa_unapproved, true);
});

Deno.test("signed URL TTL stays short enough to bound a leaked URL", () => {
  assert(SIGNED_URL_TTL_SECONDS > 0);
  // review-queue uses 3600s for reviewers working a queue. A student renders
  // one item at a time and the client re-fetches, so this must stay well below
  // that; if someone raises it, they should have to change this test.
  assert(
    SIGNED_URL_TTL_SECONDS <= 900,
    `expected <= 900s, got ${SIGNED_URL_TTL_SECONDS}`,
  );
});

// ── Reviewer-captured visual requirement (serving gate) ───────────────────
// Closes the gap content_asset_metadata cannot see: an item that NEEDS a
// visual and has none looks identical to a text-only item.

import type { VisualRequirement } from "./student-item-delivery.ts";

function requirement(
  overrides: Partial<VisualRequirement> = {},
): Map<string, VisualRequirement> {
  return new Map([[
    VERSION_A,
    {
      content_item_version_id: VERSION_A,
      image_needed: "yes",
      image_approval: "approved",
      ...overrides,
    } as VisualRequirement,
  ]]);
}

Deno.test("item needing a visual but having none is withheld (the L-028 case)", () => {
  const { deliverable, omitted } = partitionDeliverable(
    [row({ stimulus_image_path: null })],
    indexAssets([]),
    false,
    requirement({ image_approval: "missing" }),
  );

  assertEquals(deliverable.length, 0);
  assertEquals(omitted[0].reason, "required_visual_absent");
});

Deno.test("a disapproved required visual is withheld even though the file exists", () => {
  const { deliverable, omitted } = partitionDeliverable(
    [row()],
    indexAssets([asset()]),
    false,
    requirement({ image_approval: "disapproved" }),
  );

  assertEquals(deliverable.length, 0);
  assertEquals(omitted[0].reason, "required_visual_not_approved");
});

Deno.test("approved and approved_with_edits both serve", () => {
  for (const approval of ["approved", "approved_with_edits"] as const) {
    const { deliverable, omitted } = partitionDeliverable(
      [row()],
      indexAssets([asset()]),
      false,
      requirement({ image_approval: approval }),
    );
    assertEquals(omitted.length, 0, approval);
    assertEquals(deliverable.length, 1, approval);
  }
});

Deno.test("construction items are never treated as needing a prompt visual", () => {
  // The 39 HDG / "translate into a labeled diagram" items. They have no image
  // and must still serve — the visual is the student's answer.
  for (const needed of ["no_constructs", "no_not_needed"] as const) {
    const { deliverable, omitted } = partitionDeliverable(
      [row({ stimulus_image_path: null })],
      indexAssets([]),
      false,
      requirement({ image_needed: needed, image_approval: null }),
    );
    assertEquals(omitted.length, 0, needed);
    assertEquals(deliverable.length, 1, needed);
  }
});

Deno.test("an unreviewed item is permissive, not blacked out", () => {
  // No requirement row = not yet classified. Failing closed here would withhold
  // the entire catalogue, since nothing is classified until a reviewer gets to
  // it. Documented tradeoff — the gate tightens as review coverage grows.
  const { deliverable, omitted } = partitionDeliverable(
    [row({ stimulus_image_path: null })],
    indexAssets([]),
    false,
    new Map(),
  );
  assertEquals(omitted.length, 0);
  assertEquals(deliverable.length, 1);
});

Deno.test("the requirement gate applies to staff QA too", () => {
  // QA mode relaxes the accessibility-approval gate, not the "this question is
  // unanswerable without a visual" gate.
  const { deliverable, omitted } = partitionDeliverable(
    [row({ stimulus_image_path: null })],
    indexAssets([]),
    true,
    requirement({ image_approval: "missing" }),
  );
  assertEquals(deliverable.length, 0);
  assertEquals(omitted[0].reason, "required_visual_absent");
});
