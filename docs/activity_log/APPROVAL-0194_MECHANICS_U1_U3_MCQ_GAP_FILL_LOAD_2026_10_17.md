# APPROVAL-0194 — Load 108 generated MCQs for AP Physics C: Mechanics units 1-3 into Production (2026-10-17)

**STATUS: PROPOSED, NOT EXECUTED. Awaiting the owner's explicit go.** One chunk (12 items) has been rehearsed against Production and rolled back; nothing is written.

## What
108 new practice MCQs across 15 Mechanics topics in units 1-3: 27 seeds + 81 variants (3 per seed), keys `apphycm-mcq-043` .. `apphycm-mcq-069` and `apphycm-mcq-sv-043-v1` .. `apphycm-mcq-sv-069-v3`. Existing Mechanics MCQs: 42 seeds, 46 variants (highest key `apphycm-mcq-042`). All 108 keys checked free in Production on 2026-10-17.

| Unit | Topics covered (seeds) |
|---|---|
| 1 | 1.1 (2), 1.3 (1), 1.4 (2), 1.5 (2) |
| 2 | 2.1 (2), 2.2 (1), 2.3 (2), 2.4 (2), 2.5 (2), 2.6 (2), 2.7 (1), 2.8 (2), 2.9 (2) |
| 3 | 3.1 (2), 3.4 (2) |

Difficulty: 88 Medium, 12 Easy, 8 Hard (provisional_model).

**Coverage today (published Mechanics MCQs by primary topic, read from Production 2026-10-17):** 1.1, 1.4, 1.5, 2.1, 2.3, 2.4, 2.6, 2.7, 2.8 and 3.1 have none, so this load is their first fill (each gets 4-8 items). 1.3, 2.2 and 3.4 have 1 each (they go to 5, 5 and 9). 2.5 and 2.9 have 4 each (to 12 and 12). Other unit 1-3 topics are not touched (1.2 has 14, 3.2 has 12, 3.3 has 16, 3.5 has 8).

## Evidence
Generate-and-select, standard profile (`seed_pipeline.mjs`, protocol v0.6 section 0): authors GPT-6.1 / Claude Opus 5.5, four non-author checker families, author-family veto, solve and audit stages, similarity gate, no hand edits. Variants inherit the seed's labels (DECISION-0096). Metered cost $19.28 at list prices (1,634 calls, 52 wall minutes, escalation rounds included). The run is private and gitignored (`tmp/gen/batch_phycm`, plan `tmp/gen/plan_phycm_publish.json`).

**Duplicate check (done, clean):** stems compared to all 457 published physics MCQs (Mechanics, Physics 1/2, Physics C-E&M) and across the batch, using the pipeline's word and 3-gram overlap. Highest seed overlap 0.11 (limit 0.12); highest variant overlap 0.11 (limit 0.35); highest cross-family overlap inside the batch 0.09. Every flagged pair was read: none is a real duplicate. Two notes: 2.6 seed A is the gravitational analog of the Physics C-E&M item `apphycem-mcq-np1-006` (uniform sphere, field at R/2), and the 2.9B drag family (where does it end up, does it stop) sits beside the existing `apphycm-mcq-sv-025` family (speed after a given time); different skills. Stems only, variants truncated at 240 characters; choices were not compared.

## Things to know before saying go
- **8 items load topic-only, with no skill label:** the 2.4 slot A family (`apphycm-mcq-055`, `-sv-055-v1..v3`) and the 2.7 slot A family (`apphycm-mcq-061` and its variants). The four checker families split on the skill (2.4A tally 2.C 2 / 3.B 2), so the skill label did not validate. The publish tool loads them with the topic cell and validated serving label only, which is how the selector serves. Skill-level practice will not draw them until a skill is set. Choose: load as is (recommended), or hold these 8 and load 100.
- **Three slots were not filled:** 1.3 slot B, 2.2 slot A and 2.7 slot B failed to produce an accepted seed (escalated). 1.3, 2.2 and 2.7 therefore get only one new family (4 items) each; 2.7 goes from none to 4.
- **Table-in-stem items** (2.1 slot B family) store their data as pipe rows in the stem; the Question screen renders those as a grid since app PR #35 was published.
- **Parts:** MCQs only; no FRQ parts, so the duplicate-parts issue (app PR #36) does not apply.
- No app, function, schema or policy change.

## Method and steps
1. `publish_mcq_batch.py plan-from-seed-batch` (done): `tmp/gen/plan_phycm_publish.json`, 108 items.
2. Inputs read from Production: live pack `ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9`, taxonomy source `d77d7801-441d-49bb-a2cf-a02f6bff407d`, owner profile present, no key collisions.
3. Run the tool's own `txn_sql` through the Supabase tool (no access token in this session), in 9 chunks of 12 items (each chunk is one seed-family triple), each chunk rehearsed (rolled back, expects `REHEARSAL OK`) and then committed; then a read-back across all 108.
4. The transaction records the owner review assignment and approve decision and sets the owner as `approved_by` for generated MCQs per DECISION-0102 (no human review). That is why Production execution needs this record and the owner's explicit go.

**Rehearsal done:** chunk 5 (`apphycm-mcq-055` .. `-057` families: includes the skill-less family) on Production, `REHEARSAL OK: published=12 skill_cells=8`, rolled back, nothing leaked.

## Rollback
Retire the 108 new versions (`status='retired'`) or delete the new content items by key; no existing item is touched.

## Not included
Physics 1 topic 1.3 (generated, unloaded, not approved); the three unfilled Mechanics slots; B4 (`apphycm-frq-044`).
