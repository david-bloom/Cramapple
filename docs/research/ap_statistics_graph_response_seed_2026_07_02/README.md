# AP Statistics Graph-Response Seed Set — 2026-07-02

**Related Task:** `TASK-0013` Phase 4 (content authoring), relates to `TASK-0011` (hand-drawn graph grading).
**Status:** Staged for tutor review only. Not reviewed, not validated, not published, not visible to students.
**Authored by:** Codex (script + all 12 items), built in a separate worktree
(`/Users/davidbloom/.codex/worktrees/da74/Cramapple`). QA'd and migrated by
Claude, 2026-07-02.

## What this is

12 original AP Statistics graph-response FRQs for hand-drawn grading
research (TASK-0011-style): 6 archetypes, 2 items each — boxplot
construction/interpretation, segmented bar graph construction, mosaic plot
interpretation, dotplot distribution-shape reasoning, scatterplot/regression
reasoning, and graph annotation (marking a value on a curve). Each item has a
`canonical_answer`, 4 `criterion_definitions`, a `display_table` (the data
the student is given), an `expected_graph_spec`, and a reference answer-key
image (`reference_images/`, generator-produced, for reviewer calibration
only — not student-facing).

`ap_statistics_graph_response_seed_2026_07_02.jsonl`,
`ap_statistics_graph_response_seed_2026_07_02.csv`, and `reference_images/`
are copied here verbatim from Codex's worktree, unmodified from what Codex
produced. `scripts/generate_ap_statistics_graph_response_seed.py` (repo
root) is the deterministic generator, also copied verbatim.

## QA performed (Claude, 2026-07-02)

Read the full 840-line generator script and independently recomputed every
numeric/statistical claim in all 12 items (five-number-summary monotonicity
and IQR/range comparisons for both boxplot items, relative-frequency
conversions for both segmented-bar items, proportional widths/heights and
max-count identification for both mosaic-plot items, dot counts and shape
description for both dotplot items, trend direction/endpoints for both
scatterplot items, and table-lookup accuracy for both curve-annotation
items). Also checked the image-rendering functions against the same
hardcoded data (all consistent — the script is fully deterministic, no
randomness, and every `*_image()` function draws from literals matching its
paired item exactly).

**One real error found:** `APSTATS-HDG-2026-GRAPH-010`'s `canonical_answer`
and `OUTLIER_NOTE` criterion asserted that 82 cm should **not** be called a
definite outlier ("high but not clearly isolated enough"). Independently
recomputed the standard 1.5×IQR rule on that item's own dataset (68, 70, 71,
72, 72, 73, 74, 74, 75, 76, 78, 82): Q1 = 71.5, Q3 = 75.5, IQR = 4.0, upper
fence = 81.5. **82 > 81.5**, so by the exact rule AP Statistics teaches, 82
cm *is* a (mild) outlier. This is the same class of error as the two found
in the prior AP Statistics FRQ batch (`ap_statistics_phase4_mcq_smoke_batch_2026_07_01/README.md`)
— a plausible-sounding statistical claim that doesn't survive recomputing
the actual rule against the item's own numbers.

Fixed in the staged Supabase row only (see below), not in the source JSONL
file kept here for provenance. The corrected text: *"...The distribution is
roughly unimodal with a slight right tail. By the 1.5xIQR rule (Q1=71.5,
Q3=75.5, IQR=4, upper fence=81.5), 82 cm exceeds the fence and is a mild
outlier."*

All other 11 items checked out exactly against independent recomputation —
no other errors found.

## What actually happened in Supabase (Production, `pcntajvbdfqhbeewmdry`)

Staged only — **not published**, per explicit instruction that tutors will
review and approve this content before it becomes live:

1. Inserted one `app.content_ingest_batches` row (subject_id = AP Statistics
   `30660307-eebd-4caf-a521-ca425ffa3017`, exam_pack_version_id =
   `548f06be-ccf4-426d-b82b-b424137a4438`, `upload_format: 'json'` — the
   batches table's check constraint only allows `csv`/`json`, so JSON Lines
   was recorded as `json`).
2. Inserted 12 `app.content_ingest_rows`, `review_stage = 'canonical_answer'`
   (matching the source data's own `review_stage` field), `question_type =
   'frq'`, `frq_form = 'short'`. Each row's `row_payload` carries the full
   original item plus two additions the source data didn't include:
   - `points_possible: 1` on each of the 4 `criterion_definitions` (the
     source data had no scoring weight field; assumed 1 point/criterion,
     matching the convention used for the prior AP Statistics FRQ batch —
     **not independently confirmed with Orly/David, flagging as an
     assumption**).
   - `hand_drawn: true` (the source data signals this via
     `expected_image_filename`/`expected_graph_spec` rather than an explicit
     boolean; added for consistency with the prior batch's schema).
   - Row 10 additionally carries a `qa_fix_note` documenting the outlier
     correction.
3. **No `content_review_assignments` were created** — no specific reviewer
   account was named, and the only accounts that exist are test accounts
   already flagged for deletion (`project_database_schema_status` memory).
   Assigning these 12 rows to a real tutor is a follow-up step once
   AP-Statistics-credentialed reviewer accounts exist.
4. **Reference images were not uploaded to Supabase Storage.** The 12 PNGs
   plus `contact_sheet.png` exist only in this repo's `reference_images/`
   directory (and in the Codex worktree). If a reviewer needs them for
   calibration, they'll need to be pulled from here directly — no storage
   bucket wiring was done as part of this migration.

**Verified after staging:** all 12 `row_key`s present, in order, matching
their source archetypes exactly, with no duplication or cross-item content
mixing (an earlier attempt at this insert corrupted row 8 during manual SQL
construction — caught before commit by reading the query back and
re-verifying row-by-row; the corrupted attempt was never sent to Production
and nothing landed from it).

## Open items / not done

- **No tutor/reader review has happened.** This is the explicit next step —
  content stays in `content_ingest_rows` until a tutor reviews and approves
  it, per instruction.
- **Points-per-criterion (1 each, 4 total per item) is an assumption**, not
  confirmed with curriculum ownership. The source data had no scoring-weight
  field at all.
- **`modules` field uses descriptive tags** (`["AP Statistics", "data
  analysis", "graphical displays"]`), not the numeric unit references
  (`["1"]`..`["9"]`) the `app.content_labels` taxonomy and the prior
  MCQ/FRQ batch use. No attempt was made to map each archetype to a specific
  AP Statistics unit (e.g., boxplots → Unit 1, scatterplots → Unit 2,
  mosaic plots → Unit 8) — that's a curriculum call, not something to guess
  at during a QA/migration pass. Flagging for whoever reviews this to
  resolve.
- **Rights/originality review has not happened.** Same "no shortcut for
  being a pilot" gate as all other AP Statistics content this session.
- **Normal-curve shading was intentionally excluded** from this v0.1 seed
  (Codex's own README note, carried forward here) — not confirmed as a
  student-drawn graph-response task in the 2023–2025 public AP Central
  materials reviewed during authoring.
- **Font rendering is macOS-specific.** The generator script's `font()`
  function only tries macOS system font paths and silently falls back to
  PIL's low-quality default bitmap font elsewhere. Not a correctness bug —
  the reference images here were generated on macOS and look fine — but
  worth knowing if this script is ever re-run in a non-macOS environment
  (e.g., a Linux CI job); the images would look markedly worse without
  erroring.
