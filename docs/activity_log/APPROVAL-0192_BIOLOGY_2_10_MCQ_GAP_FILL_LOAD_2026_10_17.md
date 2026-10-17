# APPROVAL-0192 — Load 8 generated MCQs for Biology topic 2.10 into Production (2026-10-17)

**STATUS: EXECUTED 2026-10-17 (8 items published in Production).** **Approver:** David Bloom (chat, 2026-10-17: "Load the biology items. Skip the physics. Write an approval"). Scope: Biology topic 2.10 only. The Physics 1 topic 1.3 items were generated but are NOT approved for load (see below).

## What
Eight new practice MCQs for AP Biology unit 2, topic 2.10 (Origins of Cell Compartmentalization): 2 seeds + 3 variants each.
`APBIO-MCQ-140`, `APBIO-MCQ-SV-140-v1..v3` (skill 1.B, validated 3 of 4 votes) and `APBIO-MCQ-141`, `APBIO-MCQ-SV-141-v1..v3` (skill 2.C, validated 3 of 4). Difficulty Medium, provisional_model. Topic 2.10 goes from 1 practice MCQ (`APBIO-MCQ-022`) to 9. Keys checked free against Production on 2026-10-17 (highest existing: `APBIO-MCQ-139`).

## Evidence
Generate-and-select, standard profile (`seed_pipeline.mjs`, protocol v0.6 section 0): authors GPT-6.1 then Claude Opus 5.5, four non-author checker families, author-family veto, similarity gate, no hand edits. Accepted: 8 of 8, all in round 1. Estimated cost $1.37 (list prices). Text similarity to the existing 2.10 question about 0.00. Variants inherit the seed's labels (DECISION-0096). Batch and plan are private and gitignored: `tmp/gen/batch_bio210`, `tmp/gen/plan_bio210_publish.json`.

## Method and steps
1. `publish_mcq_batch.py plan-from-seed-batch` (done): `plan_bio210_publish.json`, 8 items.
2. `preflight` (read-only), then `rehearse --env prod` (full transaction, rolled back, expects REHEARSAL OK).
3. `publish --env prod --approval APPROVAL-0192 --confirm-production`, then `verify`.
The tool inserts the owner review assignment and approve decision and sets the owner as `approved_by` for generated MCQs, per DECISION-0102 (no human review). That is why Production execution needs this record and the owner's explicit go.

## Not included
- Physics 1 topic 1.3 (generated 8, NOT loaded, not approved): slot A (displacement by signed area, 4 items) is distinct and validated; slot B (4 items) repeats the existing 1.3 family (`apphy1-mcq-053`) and its skill label did not validate. Owner: skip Physics.
- No app, function, schema or policy change.

## Rollback
Retire the 8 new versions (`status='retired'`) or delete the new content items by key; the existing 2.10 question is untouched.

## Executed
- Method: the publish tool's own `txn_sql` (publish_mcq_batch.py) rendered locally for the single 8-item chunk, with the inputs read from Production (live pack `2d88ba5e…`, taxonomy source `c676d1fc…`, owner profile present), and run through the Supabase tool (no access token in this session). Same transaction the tool runs: drafts, text-hash check against the plan, owner approve decision (DECISION-0102), structural QA, serving label, topic and skill cells, difficulty, published, post-checks.
- Rollback rehearsal on Production first: `REHEARSAL OK: published=8 skill_cells=8`, then 0 rows leaked.
- Real run: committed with no error. Read-back: all 8 items `published`/`published`, approved, 4 choices with exactly 1 correct, topic cell 2.10 validated plus skill cell validated (140 family 1.B, 141 family 2.C), serving label validated, difficulty Medium (provisional_model). Published practice MCQs on topic 2.10: 9 (was 1).
- Not done: the tool's `verify` command (needs the access token) and a live student-view check of the new items.
- Physics 1 topic 1.3 items remain generated, unloaded and unapproved.
