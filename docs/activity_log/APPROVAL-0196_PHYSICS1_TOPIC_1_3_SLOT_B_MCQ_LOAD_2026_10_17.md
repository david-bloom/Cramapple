# APPROVAL-0196 — Load 4 generated MCQs for AP Physics 1 topic 1.3, slot B, into Production (2026-10-17)

**STATUS: EXECUTED 2026-10-17 (4 items published in Production).** **Approver:** David Bloom (chat, 2026-10-17: "Load slot B as is"). This releases the slot B family held in APPROVAL-0195.

## What
Four practice MCQs for Physics 1 unit 1, topic 1.3 (Representing Motion): one seed and three variants on how acceleration behaves when a velocity-time graph curves (sign from the slope's direction, magnitude from its steepness). Keys `apphy1-mcq-057`, `apphy1-mcq-sv-057-v1..v3`; difficulty Medium (provisional_model). Skill label 3.B is only provisional (2 of 4 votes, tally 3.B 2, 3.C 1, 2.C 1), so the skill cell is stored as `provisional_model`, not validated; the topic cell and serving label are validated. Loaded as is, with the known overlap: the concept repeats the existing 1.3 family (`apphy1-mcq-053`).

## Evidence and method
Same as APPROVAL-0195: generate-and-select, standard profile, no hand edits; publish tool's `txn_sql`, rendered locally for pack `29c719dc-701b-470f-9e49-fab981722d3f`, taxonomy `27111dec-ee07-48f1-86cf-1a5833dd2962`, run through the Supabase tool. Rehearsal first (`REHEARSAL OK: published=4 skill_cells=4`), then the real run with every assertion before commit. Text hashes match the local plan.

## Read-back
4 items, all `published`. Topic 1.3 now has 12 published MCQs (was 4 before APPROVAL-0195).

## Rollback
Retire the 4 new versions (`status='retired'`); no existing item is touched.

## Not done
Tool `verify` (needs the access token) and a live student-view check.
