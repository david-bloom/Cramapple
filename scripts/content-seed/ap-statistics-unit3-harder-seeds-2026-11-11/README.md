# AP Statistics Unit 3: harder seeds and variants (2026-11-11)

**Status: PREPARED, NOT EXECUTED.** Nothing here has been run against Dev or Production. Execution needs the Product Owner's go-ahead.

Replaces R1 seeds and fixes duplicates in Unit 3, and adds seeds for thin topics. Same method and pipeline as `ap-statistics-unit2-harder-seeds-2026-11-10` (APPROVAL-0214).

## Contents
- 76 new MCQs: 19 seeds (`APSTATS-MCQ-H-3.x-A|B`) and 57 variants (`APSTATS-MCQ-SV-H-3.x-A|B-v1..3`).
- Topics: 3.1, 3.2, 3.3 (A, B), 3.4 (B), 3.5, 3.6 (A, B), 3.7, 3.8 (A, B, C), 3.9 to 3.15.
- 37 superseded published items to retire (`superseded_keys.json`): families 060, 061, 067, 063, 071, 092, 076 (each seed + v1..v3), 066, 080 (seed + v1 + v3), 011-CAL (byte-identical to 011), OHT-3.3 (near-twin of 058-v3), and the seedless 058 variants v1..v3.
- Kept on purpose: 010-CAL, 011 and its variants, 095, and all OHT items other than OHT-3.3.

## Files
- `source_draft.md`: authoring draft (stems, choices, arithmetic checks, distractor rationales).
- `build_items.py`: parses the draft into `items.json`; rebalances the correct letter (19 each of A to D, RNG seed 20261111); rationale quality assertions.
- `gen_package.py`: emits `load/chunk_01..09.sql`, `load_manifest.json` (md5 of stem + choices), `verify_hashes.sql`, `publish_rehearsal.sql`, `publish.sql`, `retire_old_rehearsal.sql`, `retire_old.sql`, `superseded_keys.json`.

Regenerate: `python3 build_items.py && python3 gen_package.py` (outputs are deterministic).

## Execution order (Production, from `~/supabase`, which links Production)
1. Run `load/chunk_01.sql` .. `chunk_09.sql` (draft rows; each chunk refuses to run twice).
2. `verify_hashes.sql` (expect 76 rows ok = true).
3. Blind-solve all 76 with two non-Claude models (see the Unit 2 session notes); fix any disagreement in `source_draft.md`, rebuild, and reload before publishing.
4. `publish_rehearsal.sql` (expect `REHEARSAL OK`), then `publish.sql`.
5. `retire_old_rehearsal.sql`, then `retire_old.sql` (refuses unless all 76 new items are published).
6. `verify_hashes.sql` again; spot check a served session.
7. Record the approval (check the next free APPROVAL number against main and open PRs first).

## Conventions
- Label: serving, `required_units [3]`, `primary_unit 3`, `max_required_unit 3` (matches existing Unit 3 labels). Topic-only cell, `skill_code` null.
- Skipped by Product Owner decision (as for Unit 2): two-checker rationale audit, topic/skill vote, CED scope check.

## Preflight (read-only, Production, 2026-11-11)
All 37 keys to retire are currently published; none of the 76 new keys exist; Unit 3 had 60 published MCQs (APSTATS-MCQ-080 carries a duplicate primary 3.6 cell, harmless, retired here).
