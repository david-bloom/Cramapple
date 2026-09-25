# Tier 3 (Labels + Difficulty) — Paired Execution Plan (2026-09-25)

Per `docs/product/SUBJECT_READINESS_COMPLETION_PLAN_2026_09_25.md`'s Tier 3 and David's direction: attack
the nine non-Biology subjects' criteria 3 (serving labels) and 5 (difficulty) in pairs, one subject to
Codex, one to Claude, then trade for cross-QA before moving to the next pair.

## Pipeline (confirmed working, no CLI dependency)

This is not hand-authoring like criterion 4 was. There's an existing, subject-agnostic two-model-agreement
pipeline (`scripts/taxonomy/extend_math_serving_labels.mjs`) and CRR-calibrated difficulty methodology
(`docs/research/apbio_difficulty_calibration_2026_09_22/`), both already used for Biology and partially for
other subjects. The original label script shells out to `supabase db query --linked`, which is linked to
**Dev**, not Production — David's call was to route through the Supabase MCP tool instead of relinking the
CLI. `scripts/taxonomy/extend_serving_labels_mcp.mjs` (forked today, smoke-tested end-to-end on a live
2-item AP Chemistry slice) does exactly that:

1. Run `scripts/taxonomy/fetch_serving_label_packets.sql` via the Supabase MCP `execute_sql` tool against
   Production (scope it to one subject by adding `and ep.exam_code = '<exam_code>'`), save the single
   `packets` column's text value as a JSON file.
2. `node scripts/taxonomy/extend_serving_labels_mcp.mjs --packets-file=<that file> --subject=<exam_code>`
   — calls `openai/gpt-5.5` and `google/gemini-2.5-flash` per item, agrees or holds, writes
   `/private/tmp/cramapple-math-taxonomy-serving/write_labels.sql` (never applies it) and a dated report
   under `docs/research/`.
3. Read `write_labels.sql`, sanity-check it, then apply it via the Supabase MCP `apply_migration` tool
   against Production yourself. This writes `provisional_model` or `held` labels — **never** `validated`.
   Promotion to `validated` is a separate, smaller step (see below).
4. For difficulty: `docs/research/apbio_difficulty_calibration_2026_09_22/` already has computed CSV
   proposals for some subjects (Chemistry, Statistics). Verify each against current Production content
   (item counts may have drifted since those CSVs were generated), then write a load migration modeled on
   `supabase/migrations/20260924240000_apbio_content_item_difficulty_load.sql`. Subjects without an
   existing CSV need the CRR-extraction/assignment scripts in that same directory run first.

## Pair 1 (today)

| Subject | Assigned to | Why this pair first |
| --- | --- | --- |
| AP Statistics | Claude | Deepest context from today's Tier 2 work; difficulty CSV already exists (`apstats_difficulty_assignments.csv`) |
| AP Chemistry | Codex | Label run precedent already exists; difficulty CSV already exists (`apchem_difficulty_assignments.csv`) |

Both subjects already have partial label runs (Statistics: 47 provisional_model, 16 held, 336
legacy_unvalidated, 15 with no label at all; Chemistry: 29 provisional_model, 37 held, 163
legacy_unvalidated, 34 stale) — today's job is to run the remaining legacy_unvalidated/no-label items
through the pipeline, resolve/re-run held items where a genuine fix is possible, and get the difficulty
values loaded, not to start from zero.

**Cross-QA after both land:** Claude independently reviews a sample of Codex's Chemistry label/difficulty
output (spot-check the model's unit-assignment reasoning against the actual item content and rubric,
confirm difficulty band placement is defensible), and vice versa for Codex on Statistics. This mirrors
today's canonical-answer cross-QA pattern — the author doesn't grade their own work.

## Subsequent pairs (not started yet)

- Pair 2: (AP Calculus AB, AP Precalculus) — both have CRR cut points already computed, no label run yet.
- Pair 3: (AP Physics 1, AP Physics 2) — Physics 1 lacks per-point CRR data per the calibration README's
  gap note; may need a different difficulty approach or explicit "basis: judgment" fallback per
  DECISION-0061.
- Pair 4: (AP Physics C: Mechanics, AP Physics C: E&M) — both have CRR cut points already computed.
- Remaining: AP Calculus BC (CRR cut points already computed) — pairs with whichever of the above finishes
  first, or runs solo if the pairing works out odd.

## Explicitly not in scope here

- Promoting `provisional_model` labels to `validated` at scale is a separate governance step
  (`app.content_taxonomy_validation_decisions`, human/Product-Owner-reviewed per DECISION-0055's process)
  — this plan produces provisional labels ready for that step, it does not do the promotion itself unless
  David says otherwise once he sees the first pair's results.
- `held` items need a case-by-case look (model disagreement, rubric-preflight failure, or a genuine scope
  violation) rather than a blanket re-run — report them, don't force a resolution.
