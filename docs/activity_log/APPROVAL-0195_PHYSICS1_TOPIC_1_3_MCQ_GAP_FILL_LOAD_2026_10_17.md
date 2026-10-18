# APPROVAL-0195 — Load 4 generated MCQs for AP Physics 1 topic 1.3 into Production (2026-10-17)

**STATUS: EXECUTED 2026-10-17 (4 items published in Production).** **Approver:** David Bloom (chat, 2026-10-17: "then load physics 1.3"). Scope as executed: **slot A only (4 items); slot B (4 items) is held** pending the owner's decision (see below).

## What
Four new practice MCQs for Physics 1 unit 1, topic 1.3 (Representing Motion): one seed and three variants on displacement as the signed area under a velocity-time graph (a straight line through three tabulated points). Keys `apphy1-mcq-056`, `apphy1-mcq-sv-056-v1..v3`; skill 2.B (validated 4 of 4), difficulty Medium (provisional_model). Each stem carries its data as a pipe table that the Question screen renders as a grid (app PR #35). I checked every keyed answer by hand: seed +6 m, variants +5 m, +16 m, -15 m; the tabulated points lie on one straight line in all four. Topic 1.3 goes from 4 to 8 published MCQs.

## Evidence
Generate-and-select, standard profile (`seed_pipeline.mjs`, protocol v0.6 section 0): authors GPT-6.1 / Claude Opus 5.5, four non-author checker families, author veto, similarity gate, no hand edits; variants inherit the seed's labels (DECISION-0096). Batch and plan are private and gitignored (`tmp/gen/batch_phy13`, `tmp/gen/plan_phy13_publish.json`). Keys free in Production on 2026-10-17 (highest existing `apphy1-mcq-055`).

## Slot B (`apphy1-mcq-057` family, 4 items): loaded later under APPROVAL-0196
Owner said "Load slot B as is" on 2026-10-17; see APPROVAL-0196. Original hold note:
Slot B asks how speed and acceleration compare on a velocity-time graph that rises but flattens; it repeats the concept of the existing 1.3 family (`apphy1-mcq-053`), and its skill label is only provisional (3.B, 2 of 4 votes). It would add near-duplicates for students. Owner to decide: load as is, regenerate with the existing family in the bank, or drop.

## Method
Publish tool's `txn_sql` rendered locally (live pack `29c719dc-701b-470f-9e49-fab981722d3f`, taxonomy source `27111dec-ee07-48f1-86cf-1a5833dd2962`, owner profile present), run through the Supabase tool (no access token in this session): rehearsal with rollback first (`REHEARSAL OK: published=4 skill_cells=4`), then the real run. The transaction records the owner approve decision (DECISION-0102) and sets the owner as `approved_by` for generated MCQs, with all assertions before commit.

## Read-back
4 items published and approved; 4 choices and 1 correct each; 4 serving labels validated against the live taxonomy hash; topic and skill cells validated; 4 difficulty rows; the student selector returns all 4; topic 1.3 now has 8 published MCQs.

## Rollback
Retire the 4 new versions (`status='retired'`) or delete the new items by key; no existing item is touched.

## Not done
The tool's `verify` command (needs the access token) and a live student-view check.
