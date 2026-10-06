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
  applyItemPackageFallback,
  type AssetMetadata,
  annotateOpenHandExclusions,
  dropTeachingItems,
  buildRenderItem,
  buildResolvedCells,
  derivePackageChoices,
  derivePackageStem,
  derivePackageStimulus,
  indexAssets,
  isStaffQaRole,
  type ItemPackagePayload,
  type LearnerFacingCriterion,
  type McqChoice,
  partitionDeliverable,
  type RenderCell,
  type SelectedRow,
  SIGNED_URL_TTL_SECONDS,
  STAFF_QA_ROLES,
  type TopicResolutionRow,
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
  // caught rather than only a top-level one. parts_source is a provenance
  // label whose value ("criteria") is not itself a leaked field, so it is
  // checked separately below rather than tripping the substring guard.
  assertEquals(item.parts_source, "criteria");
  const { parts_source: _partsSource, ...rest } = item;
  const serialized = JSON.stringify(rest);
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
    "cell",
    "choices",
    "content_item_id",
    "content_item_version_id",
    "content_key",
    "frq_form",
    "item_type",
    "media",
    "open_hand_excluded",
    "parts",
    "parts_source",
    "practice_format",
    "response_mode",
    "stem",
    "stimulus",
    "title",
  ]);
});

Deno.test("response_mode is hand_drawn only when the row says so, never from prompt_json", () => {
  const typed = buildRenderItem(row(), null, null, "2026-08-05T00:15:00Z", []);
  assert(typed);
  assertEquals(typed.response_mode, "typed");

  const handDrawn = buildRenderItem(
    row({ hand_drawn: true }),
    null,
    null,
    "2026-08-05T00:15:00Z",
    [],
  );
  assert(handDrawn);
  assertEquals(handDrawn.response_mode, "hand_drawn");
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

// ── TASK-0047 Workstream E: item-package dual-read adapter ───────────────
// Both package shapes observed in the wild: on-disk content/item-packages/
// (schema_version "1.0.0") and Production's item_package_payload column
// (schema_version "course-mode-generated-0.1", the only shape ever populated
// there -- verified against the 203 real rows 2026-09-26).

const DISK_SHAPE_PACKAGE: ItemPackagePayload = {
  schema_version: "1.0.0",
  mcq_choices: [
    { choice_key: "A", choice_text: "4", is_correct: true, rationale: "..." },
    { choice_key: "B", choice_text: "2", is_correct: false, rationale: "..." },
  ],
  parts: [
    { part_key: "question", prompt: "What is lim(x->2) ...?" },
  ],
};

const DB_SHAPE_PACKAGE: ItemPackagePayload = {
  schema_version: "course-mode-generated-0.1",
  prompt: "Calculate the sample mean.",
  mcq_form: {
    options: [
      { text: "31.00", correct: false, misconception: "reported_median" },
      { text: "34.55", correct: true, misconception: null },
    ],
  },
  parts: [
    { part_key: "part-a", prompt: "Calculate the sample mean." },
  ],
};

Deno.test("derivePackageStem reads the disk shape's first part prompt", () => {
  assertEquals(
    derivePackageStem(DISK_SHAPE_PACKAGE),
    "What is lim(x->2) ...?",
  );
});

Deno.test("derivePackageStem reads the DB shape's top-level prompt", () => {
  assertEquals(
    derivePackageStem(DB_SHAPE_PACKAGE),
    "Calculate the sample mean.",
  );
});

Deno.test("derivePackageStem returns null for a payload with no usable text", () => {
  assertEquals(derivePackageStem({}), null);
  assertEquals(derivePackageStem(null), null);
  assertEquals(derivePackageStem(undefined), null);
});

Deno.test("derivePackageChoices reads the disk shape's mcq_choices, dropping is_correct/rationale", () => {
  const choices = derivePackageChoices(DISK_SHAPE_PACKAGE);
  assertEquals(choices, [
    { choice_key: "A", choice_text: "4" },
    { choice_key: "B", choice_text: "2" },
  ]);
  const serialized = JSON.stringify(choices);
  assertFalse(serialized.includes("is_correct"));
  assertFalse(serialized.includes("rationale"));
  assertFalse(serialized.includes("true"));
});

Deno.test("derivePackageChoices reads the DB shape's mcq_form.options, assigning letter keys", () => {
  const choices = derivePackageChoices(DB_SHAPE_PACKAGE);
  assertEquals(choices, [
    { choice_key: "A", choice_text: "31.00" },
    { choice_key: "B", choice_text: "34.55" },
  ]);
  const serialized = JSON.stringify(choices);
  assertFalse(serialized.includes("correct"));
  assertFalse(serialized.includes("misconception"));
});

Deno.test("derivePackageChoices returns null when neither shape's choice field is present", () => {
  assertEquals(derivePackageChoices({ schema_version: "1.0.0" }), null);
  assertEquals(derivePackageChoices(null), null);
});

Deno.test("derivePackageStimulus reads the first text stimulus", () => {
  const withStimulus: ItemPackagePayload = {
    ...DISK_SHAPE_PACKAGE,
    stimuli: [
      { stimulus_key: "directions", kind: "text", payload: { text: "No calculator." } },
    ],
  };
  assertEquals(derivePackageStimulus(withStimulus), "No calculator.");
  assertEquals(derivePackageStimulus(DISK_SHAPE_PACKAGE), null);
});

Deno.test("applyItemPackageFallback is a no-op when legacy stem and choices are already present", () => {
  const rows: SelectedRow[] = [row({ item_type: "mcq" })];
  const choicesByVersion = new Map<string, McqChoice[]>([
    [VERSION_A, [{ choice_key: "A", choice_text: "already legacy" }]],
  ]);
  const payloadByVersion = new Map([[VERSION_A, DISK_SHAPE_PACKAGE]]);

  const result = applyItemPackageFallback(rows, choicesByVersion, payloadByVersion);

  assertEquals(result.rows, rows);
  assertEquals(
    result.choicesByVersion.get(VERSION_A),
    [{ choice_key: "A", choice_text: "already legacy" }],
  );
});

Deno.test("applyItemPackageFallback backfills stem and choices when legacy data is empty", () => {
  const rows: SelectedRow[] = [
    row({ item_type: "mcq", stem: "", stimulus: null }),
  ];
  const choicesByVersion = new Map<string, McqChoice[]>(); // no legacy choices at all
  const payloadByVersion = new Map([[VERSION_A, DISK_SHAPE_PACKAGE]]);

  const result = applyItemPackageFallback(rows, choicesByVersion, payloadByVersion);

  assertEquals(result.rows[0].stem, "What is lim(x->2) ...?");
  assertEquals(
    result.choicesByVersion.get(VERSION_A),
    [
      { choice_key: "A", choice_text: "4" },
      { choice_key: "B", choice_text: "2" },
    ],
  );
});

Deno.test("applyItemPackageFallback never overwrites a non-empty legacy stem", () => {
  const rows: SelectedRow[] = [row({ item_type: "mcq", stem: "real legacy stem" })];
  const choicesByVersion = new Map<string, McqChoice[]>();
  const payloadByVersion = new Map([[VERSION_A, DISK_SHAPE_PACKAGE]]);

  const result = applyItemPackageFallback(rows, choicesByVersion, payloadByVersion);

  assertEquals(result.rows[0].stem, "real legacy stem");
});

Deno.test("applyItemPackageFallback does nothing for a version with no package payload", () => {
  const rows: SelectedRow[] = [row({ item_type: "mcq", stem: "" })];
  const choicesByVersion = new Map<string, McqChoice[]>();
  const payloadByVersion = new Map<string, ItemPackagePayload>(); // empty -- no package for this version

  const result = applyItemPackageFallback(rows, choicesByVersion, payloadByVersion);

  assertEquals(result.rows[0].stem, "");
  assertEquals(result.choicesByVersion.get(VERSION_A), undefined);
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

// ── TASK-0047 Decision 17 follow-on: resolved topic/cell identity ─────────

Deno.test("buildRenderItem defaults cell to null when the caller passes none", () => {
  const item = buildRenderItem(row(), null, null, "2026-08-05T00:15:00Z", []);
  assert(item);
  assertEquals(item.cell, null);
});

Deno.test("buildRenderItem carries through a resolved cell unchanged", () => {
  const cell: RenderCell = {
    topic_code: "u1-l2",
    skill_code: "A",
    topic_title: "Sampling distributions",
    unit_number: 1,
  };
  const item = buildRenderItem(
    row(),
    null,
    null,
    "2026-08-05T00:15:00Z",
    [],
    null,
    cell,
  );
  assert(item);
  assertEquals(item.cell, cell);
});

Deno.test("buildResolvedCells resolves a skill-bearing row from the view", () => {
  const rows = [row({ content_item_id: "item-a" })];
  const resolutionRows: TopicResolutionRow[] = [{
    content_item_version_id: VERSION_A,
    topic_code: "u1-l2",
    skill_code: "A",
    topic_title: "Sampling distributions",
    unit_number: 1,
  }];

  const resolved = buildResolvedCells(rows, resolutionRows);

  assertEquals(resolved.get(VERSION_A), {
    topic_code: "u1-l2",
    skill_code: "A",
    topic_title: "Sampling distributions",
    unit_number: 1,
  });
});

Deno.test("buildResolvedCells resolves a topic-only row (null skill_code) from the view unchanged", () => {
  const rows = [row({ content_item_id: "item-bio" })];
  const resolutionRows: TopicResolutionRow[] = [{
    content_item_version_id: VERSION_A,
    topic_code: "4.2",
    skill_code: null,
    topic_title: "Introduction to Signal Transduction",
    unit_number: 4,
  }];

  const resolved = buildResolvedCells(rows, resolutionRows);

  assertEquals(resolved.get(VERSION_A), {
    topic_code: "4.2",
    skill_code: null,
    topic_title: "Introduction to Signal Transduction",
    unit_number: 4,
  });
});

Deno.test("buildResolvedCells resolves nothing when the item has no row in the view at all", () => {
  const rows = [row({ content_item_id: "item-nothing" })];

  const resolved = buildResolvedCells(rows, []);

  assertEquals(resolved.has(VERSION_A), false);
});

Deno.test("buildResolvedCells resolves a null title when the view's own title columns are null", () => {
  const rows = [row({ content_item_id: "item-bio" })];
  // The view left-joins taxonomy_topics for the title/unit -- a row can, in
  // principle, come back with a null title if that join ever misses. Must
  // resolve topic_title: null, not throw or omit the whole cell.
  const resolutionRows: TopicResolutionRow[] = [{
    content_item_version_id: VERSION_A,
    topic_code: "4.2",
    skill_code: null,
    topic_title: null,
    unit_number: null,
  }];

  const resolved = buildResolvedCells(rows, resolutionRows);

  assertEquals(resolved.get(VERSION_A), {
    topic_code: "4.2",
    skill_code: null,
    topic_title: null,
    unit_number: null,
  });
});

// ---------------------------------------------------------------------------
// TASK-0051 / DECISION-0086 — Open Hand exclusion annotation.
// ---------------------------------------------------------------------------

function exclusionService(
  rows: Array<{ content_item_id: string }> | null,
  error: unknown = null,
) {
  const calls: Array<Record<string, unknown>> = [];
  const service = {
    schema: () => ({
      from: (table: string) => {
        const state: Record<string, unknown> = { table };
        const chain = {
          select: (cols: string) => {
            state.select = cols;
            return chain;
          },
          eq: (col: string, val: unknown) => {
            state[`eq:${col}`] = val;
            return chain;
          },
          in: (col: string, vals: unknown[]) => {
            state[`in:${col}`] = vals;
            calls.push(state);
            return Promise.resolve({ data: rows, error });
          },
        };
        return chain;
      },
    }),
  };
  return { service, calls };
}

Deno.test("annotateOpenHandExclusions marks only the excluded item, by item id", async () => {
  const a = { ...buildRenderItem(row(), null, null, "2026-08-05T00:15:00Z", [])!, content_item_id: "item-a" };
  const b = { ...a, content_item_id: "item-b" };
  const { service, calls } = exclusionService([{ content_item_id: "item-b" }]);

  // deno-lint-ignore no-explicit-any
  const out = await annotateOpenHandExclusions(service as any, "user-1", [a, b]);

  assertEquals(out[0].open_hand_excluded, false);
  assertEquals(out[1].open_hand_excluded, true);
  // Keyed on the ITEM, never the version: a re-publish must not clear it.
  assertEquals(calls[0]["table"], "open_hand_scoring_exclusions");
  assertEquals(calls[0]["eq:user_id"], "user-1");
  assertEquals(calls[0]["in:content_item_id"], ["item-a", "item-b"]);
});

Deno.test("annotateOpenHandExclusions fails CLOSED when the lookup errors", async () => {
  const a = { ...buildRenderItem(row(), null, null, "2026-08-05T00:15:00Z", [])!, content_item_id: "item-a" };
  const { service } = exclusionService(null, { message: "boom" });

  // deno-lint-ignore no-explicit-any
  const out = await annotateOpenHandExclusions(service as any, "user-1", [a]);

  // Every item is marked not-scorable rather than silently reported scorable.
  // Telling a student "this can't be scored" when it could be is visible and
  // recoverable; the opposite invites an attempt evaluate-attempt will refuse.
  assertEquals(out[0].open_hand_excluded, true);
});

Deno.test("annotateOpenHandExclusions does not query for an empty queue", async () => {
  const { service, calls } = exclusionService([]);
  // deno-lint-ignore no-explicit-any
  const out = await annotateOpenHandExclusions(service as any, "user-1", []);
  assertEquals(out, []);
  assertEquals(calls.length, 0);
});

Deno.test("authored question_parts replace criteria text and are labelled prompt", () => {
  const item = buildRenderItem(
    row({
      question_parts: [
        { part_key: "part-a", prompt: "Approximate T'(4).", points: 2 },
      ],
    }),
    null,
    null,
    "2026-08-05T00:15:00Z",
    [{
      content_item_version_id: VERSION_A,
      criterion_key: "part-a-criterion-01",
      learner_facing_text: "Correct value of -4.5 C/min.",
      points_possible: 1,
    }],
  );
  assert(item);
  assertEquals(item.parts_source, "prompt");
  assertEquals(item.parts, [
    { part_key: "part-a", prompt_text: "Approximate T'(4).", points_possible: 2 },
  ]);
  assertFalse(JSON.stringify(item).includes("-4.5"));
});

// TASK-0064 — teaching items are filtered out of every served list.
function teachingService(
  rows: Array<{ content_item_id: string }> | null,
  error: unknown = null,
) {
  const calls: Array<Record<string, unknown>> = [];
  const service = {
    schema: () => ({
      from: (table: string) => {
        const state: Record<string, unknown> = { table };
        const chain = {
          select: (cols: string) => {
            state.select = cols;
            return chain;
          },
          in: (col: string, vals: unknown[]) => {
            state[`in:${col}`] = vals;
            return chain;
          },
          is: (col: string, val: unknown) => {
            state[`is:${col}`] = val;
            calls.push(state);
            return Promise.resolve({ data: rows, error });
          },
        };
        return chain;
      },
    }),
  };
  return { service, calls };
}

Deno.test("dropTeachingItems removes active teaching items, by item id", async () => {
  const a = { ...buildRenderItem(row(), null, null, "2026-08-05T00:15:00Z", [])!, content_item_id: "item-a" };
  const b = { ...a, content_item_id: "item-b" };
  const { service, calls } = teachingService([{ content_item_id: "item-b" }]);

  // deno-lint-ignore no-explicit-any
  const out = await dropTeachingItems(service as any, [a, b]);

  assertEquals(out.items.map((i) => i.content_item_id), ["item-a"]);
  assertEquals(out.dropped, 1);
  assertEquals(out.failed, false);
  assertEquals(calls[0]["table"], "open_hand_teaching_items");
  assertEquals(calls[0]["in:content_item_id"], ["item-a", "item-b"]);
  assertEquals(calls[0]["is:released_at"], null);
});

Deno.test("dropTeachingItems fails CLOSED when the lookup errors", async () => {
  const a = { ...buildRenderItem(row(), null, null, "2026-08-05T00:15:00Z", [])!, content_item_id: "item-a" };
  const { service } = teachingService(null, { message: "boom" });

  // deno-lint-ignore no-explicit-any
  const out = await dropTeachingItems(service as any, [a]);

  assertEquals(out.items, []);
  assertEquals(out.failed, true);
});

Deno.test("dropTeachingItems does not query for an empty queue", async () => {
  const { service, calls } = teachingService([]);
  // deno-lint-ignore no-explicit-any
  const out = await dropTeachingItems(service as any, []);
  assertEquals(out.items, []);
  assertEquals(calls.length, 0);
});
