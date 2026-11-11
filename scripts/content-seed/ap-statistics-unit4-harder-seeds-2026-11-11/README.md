# AP Statistics Unit 4: harder seeds and variants (2026-11-11)

**Status: PREPARED, NOT EXECUTED.** Nothing here has been run against Dev or Production. Execution needs the Product Owner's go-ahead.

Rewrites the R1 seeds in Unit 4, removes duplicates and defective items, and adds seeds for the topics with no MCQs. Same method and pipeline as the Unit 2 (APPROVAL-0214) and Unit 3 (APPROVAL-0215) packages.

## Contents
- 48 new MCQs: 12 seeds (`APSTATS-MCQ-H-4.x-A|B`) and 36 variants (`APSTATS-MCQ-SV-H-4.x-A|B-v1..3`).
- Topics: 4.1 (A, B), 4.2 (A, B), 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9, 4.10.
- 18 superseded published items to retire (`superseded_keys.json`): exact duplicates 009-CAL, 013-CAL, 014-CAL; R1 seeds 055, 056, 057, 059, 070, 096, 069, 093, 091, 099; near-twins 062 (of 013) and 069 (of 014); misfiled proportion item 058; wrong-procedure item 065 (z* for a mean); unclear item 068; thin item 072.
- Kept on purpose: 009, 013, 014, 064, 079.
- Unit 4 has no seed variants today, so no variants are retired.

## Files
- `source_draft.md`: authoring draft (stems, choices, arithmetic checks, distractor rationales).
- `build_items.py`: parses the draft into `items.json`; rebalances the correct letter (12 each of A to D, RNG seed 20261112); rationale assertions.
- `gen_package.py`: emits `load/chunk_01..06.sql`, `load_manifest.json`, `verify_hashes.sql`, `publish_rehearsal.sql`, `publish.sql`, `retire_old_rehearsal.sql`, `retire_old.sql`, `superseded_keys.json`.

Regenerate: `python3 build_items.py && python3 gen_package.py` (deterministic).

## Execution order (Production, from `~/supabase`, which links Production)
1. `load/chunk_01.sql` .. `chunk_06.sql` (draft rows; each chunk refuses to run twice).
2. `verify_hashes.sql` (expect 48 rows ok = true).
3. Blind-solve all 48 with two non-Claude models; fix any disagreement in `source_draft.md`, rebuild, reload before publishing.
4. `publish_rehearsal.sql` (expect `REHEARSAL OK`), then `publish.sql`.
5. `retire_old_rehearsal.sql`, then `retire_old.sql` (refuses unless all 48 new items are published).
6. `verify_hashes.sql` again; spot check a served session.
7. Record the approval (check the next free APPROVAL number against main and open PRs first).

## Conventions
- Label: serving, `required_units [4]`, `primary_unit 4`, `max_required_unit 4` (matches 13 of the 23 existing Unit 4 labels). Topic-only cell, `skill_code` null.
- Skipped by Product Owner decision, as for Units 2 and 3: two-checker rationale audit, topic/skill vote, CED scope check.

## Preflight (read-only, Production, 2026-11-11)
All 18 keys to retire are published; none of the 48 new keys exist; Unit 4 has 23 published MCQs and 17 FRQs.

## Found, not fixed here: wrong serving labels on kept or retired Unit 4 items
Of the 23 published Unit 4 MCQs, 10 have a serving label that is not unit 4: 009 and 009-CAL, 057, 059 are `{2}`; 058 is `{3}`; 013-CAL, 055, 069, 079, 096 are `{}`. Of these, only 009 and 079 are kept; the rest are retired by this package. Correcting the labels on 009 and 079 is a separate approval (a live label change).
