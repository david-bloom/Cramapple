# Codex Architecture Brief — Loading Hand-Drawn-Response (HDR) FRQs into Supabase

**Not cleared to execute a migration.** This is a design brief, not an
execution prompt — there is no DECISION/APPROVAL record authorizing a
migration yet (contrast with `CODEX_AP_STATISTICS_PHASE2_SCHEMA_INSTANTIATION.md`,
which had `DECISION-0032`/`APPROVAL-0025` before any SQL got written).
Codex's job here is to **architect a plan** — propose the schema/ingestion
approach, get it reviewed, then execute as a separate, explicitly-approved
step.

## Why this note exists

David asked "where are the HDR FRQs [in Supabase]?" expecting them to
already be loaded. They aren't — for either subject, in any form. This note
documents exactly what's actually in Supabase today (verified by direct
query, 2026-07-07, not assumed from repo files) and what needs to be
designed before any of it can be loaded.

## Current state, verified against Supabase directly (project `pcntajvbdfqhbeewmdry`, Production)

**AP Biology:**
- 142 FRQ `content_items` exist (42 `long`, 100 `short`, all `status='draft'`,
  content_keys `APBIO-FRQ-L-001..042` / `APBIO-FRQ-S-001..100`) plus 100 MCQs.
  None carry any `hand_drawn` key anywhere in `prompt_json` — checked directly,
  not just absent by convention.
- `app.content_ingest_batches` has **zero rows for Biology, ever** — not
  empty-after-processing, no batch record exists at all.
- No `content_items` row anywhere (any subject) has a stem matching
  `%construct a graph%` or a content_key matching `%HDG%`/`%hand%`.
- Conclusion: the local `docs/research/hand_drawn_graph_corpus_2026_06_30/`
  corpus (150 draw-ready item slots: 50 categorical-comparison, 50
  continuous-series, 50 continuous-relationship-estimate) has **never been
  ingested in any form** — not the item definitions, not the reference
  images. Its own README already says no Storage bucket wiring was done;
  this note confirms via direct query that nothing else happened either.
- For grading experiments, the Biology focus should be the 142 existing FRQs
  in Supabase plus any new Biology questions we author going forward, rather
  than the separate research corpus as a standalone target.

**AP Statistics:**
- The original 12-item graph-response seed
  (`docs/research/ap_statistics_graph_response_seed_2026_07_02/`) **is**
  staged — one `content_ingest_batches` row (2026-07-02), 12
  `content_ingest_rows`, `review_stage = 'canonical_answer'`. It has **not**
  been promoted to `content_items`, and its 12 reference images were never
  uploaded to Supabase Storage (per that batch's own README).
- As of today (2026-07-07), all 12 of those items now have **real
  photographed hand-drawn responses** (David drew and photographed them) and
  Claude-proposed (unapproved) criterion labels — see
  `docs/research/ap_statistics_hdr_grading_experiment_2026_07_06/`
  (`images/`, `proposed_gold_labels.jsonl`). None of this — photos or
  labels — exists in Supabase in any form.
- 28 additional new HDR FRQ definitions were authored today
  (`docs/research/apstats_packet_bundle_2026_07_07/hdr_frq_pool.json`,
  items `GRAPH-013`–`GRAPH-040`), each with a printable trace page but no
  real response yet. Not in Supabase at all — not even staged.
- No `content_ingest_rows` row for any subject has a first-class
  `hand_drawn` column — the one existing use (the 12-item Stats seed) put
  `hand_drawn: true` inside the free-form `row_payload` JSON as an ad hoc
  addition, explicitly flagged in that batch's README as "not independently
  confirmed with Orly/David, flagging as an assumption."

**Net: zero HDR FRQ definitions, zero response images, and zero response
labels exist in Supabase for either subject**, beyond the one already-staged
12-item Stats `content_ingest_rows` batch (definitions only, no
images/labels).

## What "load those FRQs into Supabase" actually requires deciding

This is not one job, it's at least three, and they don't all belong in the
same table:

1. **FRQ definitions** (stem, data table, capture instruction, criteria,
   canonical answer) — this fits the existing `content_ingest_batches` /
   `content_ingest_rows` → `content_items` pattern already used for every
   other subject's text FRQs and MCQs. The open question is whether
   `hand_drawn` (and the archetype-specific fields: `display_table`,
   `capture_instruction`, `expected_graph_spec`) should become first-class
   columns now that this is expanding from one experimental batch to
   potentially 190 items (150 Bio + 40 Stats) across two subjects, instead
   of staying inside ad hoc `row_payload` JSON.
2. **Response images** (the actual photographed hand-drawn pages) — no
   Storage bucket has ever been wired for this, for either subject, ever.
   The cleanest path is to treat these as content assets in the existing
   private `content-assets` bucket and record a sidecar metadata row in
   Supabase so the image path is queryable without making the repo the system
   of record. The 12 AP Stats items already have real photos in the repo
   (`v1` and `v2` per item, see that experiment's README); they are the first
   realistic test case for a bucket-backed convention.
3. **Response labels** (the criterion-level gold labels for a photographed
   response) — these do not require a new table. `content_review_assignments`
   and `content_review_decisions` already support staged review through the
   intake bridge, so provisional/calibration labels can live in the existing
   review workflow instead of being split into a separate research-only model.
   If we ever need a purely local gold-label ledger, that should be an
   explicit exception rather than the default.

## Candidate scope, once the above is designed

- **AP Statistics**: up to 40 HDR FRQ definitions (12 with real graded
  responses + 28 shells) could move from local files into
  `content_ingest_rows`, following the exact batch pattern already used for
  the original 12 — this is the smallest, most mechanical piece since the
  schema precedent already exists for this subject.
- **AP Biology**: up to 150 HDR FRQ definitions from
  `hand_drawn_graph_corpus_2026_06_30` — larger scope, and this subject has
  never had any HDR content staged before, so there's no existing
  `row_payload` convention to follow; whatever schema Codex proposes for
  Statistics should be designed to also fit Biology's 3 archetypes
  (categorical/series/estimate), which don't fully overlap with
  Statistics's 6 (boxplot/segmented-bar/mosaic/dotplot/scatterplot/
  curve-annotation).

## Known landmine to avoid propagating

`APSTATS-HDG-2026-GRAPH-010`'s `OUTLIER_NOTE` criterion and
`canonical_answer`, as currently written in
`ap_statistics_graph_response_seed_2026_07_02.jsonl`, are wrong — this was
found and documented (with the corrected wording and the 1.5×IQR
recomputation behind it) in
`docs/research/ap_statistics_hdr_grading_experiment_2026_07_06/README.md`
and `frq_packets.md`. If this item gets (re-)loaded, use the corrected
wording from that file, not the original source JSONL.

## Governance constraint

None of this content — Bio's 150 items, Stats's original 12, Stats's new
28, or the 12 proposed gold-label sets — has been reviewed by Learning
Quality. Whatever gets loaded must land at `status = 'draft'` /
`review_stage` consistent with existing convention (matching how the
original 12-item Stats batch and all Biology content already sit), and
loading into Supabase must not be represented as, or conflated with,
approval.

## Required output

A proposed design (schema changes if any, ingestion batch plan, Storage
bucket plan if applicable) for David to review — not a migration PR. Once
the design is approved, that approval + scope should be recorded the same
way `DECISION-0032`/`APPROVAL-0025` gated the Phase 2 schema work, before
any Codex execution prompt gets written for the actual load.

## Proposed implementation direction

- Stage HDR FRQ definitions through the existing `content_ingest_batches` /
  `content_ingest_rows` workflow.
- Store photographed responses in the private `content-assets` bucket using
  the production path convention for content media.
- Record each HDR photo in a small Supabase sidecar table so the object path,
  ingest row, and later promoted content version can be joined reliably.
- Keep provisional grading labels in the existing review workflow instead of
  adding a separate label table.
