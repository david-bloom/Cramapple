# Codex Task — Cross-QA of Claude's AP Statistics Tier 3 Work (2026-09-25)

**Context.** `docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md` requires cross-QA in both
directions before Pair 1 (AP Statistics + AP Chemistry) is considered closed: "Claude independently reviews
a sample of Codex's Chemistry label/difficulty output ... and vice versa for Codex on Statistics." Claude
already did its half (AP Chemistry PR #192, merged). This is the other half: review Claude's AP Statistics
serving-label and difficulty work, already applied to Production and merged to `main`.

This is a **read-only review task — no Production writes, no migrations, no code changes.** The deliverable
is a report.

## What was applied (for you to verify, not trust)

- Serving labels: `model_run_id = 'serving-units-mcp-2026-09-25-20260925163249'`. 126 rows: 107
  `provisional_model`, 19 `held`. 0 promoted to `validated`.
- Difficulty: `proposal_run = 'apstats_structural_difficulty_2026_09_25'` — verify this against Production
  yourself via `execute_sql` rather than trusting this doc. 170 rows: 35 Easy, 83 Medium, 52 Hard, all
  `basis = 'calibrated_judgement'`.
- Migration files (should exist in `supabase/migrations/`, reconstructed after-the-fact from a fresh
  Production query rather than applied in this exact form originally — see their own header comments for
  why): `20260925180000_apstats_serving_labels_backfill.sql`,
  `20260925190000_apstats_difficulty_backfill.sql`.
- Reports: `docs/research/AP_STATISTICS_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md` (labels; note its title
  says "Math Taxonomy... 2026-08-04" — a stale template artifact from the shared pipeline script, not an
  indication this is actually old work — the `Run ID` inside the doc is the real 2026-09-25 one).
- Handoff docs with full narrative: `docs/product/TIER3_PAIR1_STATUS_2026_09_25.md`.

## What to actually check

1. **Counts.** Independently query Production for both run IDs above and confirm the row counts and status
   breakdowns match what's claimed. Confirm both migration files, if run against Production today, are
   no-ops (they're written with `not exists` / idempotency guards — verify those guards actually work by
   reading the SQL, you don't need to re-run them against Production to check this).
2. **Contamination.** Confirm every row in both runs belongs to a live AP Statistics content item (same
   check pattern as your own AP Chemistry contamination check).
3. **Unit-assignment reasoning — sample at least 15 of the 126 labeled items** (weight toward the two
   largest held-reason buckets and the two largest provisional-model reason buckets so you're not only
   checking the easy cases):
   - `held`, reason `model_unit_disagreement` (11 items) — read the actual item content (stem, choices/
     criteria) and judge whether holding was the right call, or whether one of the two models was clearly
     correct and it should have been resolved rather than held.
   - `held`, reason `other` (7 items) — same, plus check whether the "other" reason given is actually
     accurate for each one.
   - `held`, reason `rubric_preflight_failure` (1 item) — verify the structural failure claimed actually
     exists in that item.
   - `provisional_model`, reason `two_model_corrected_legacy_unit` (65 items, the largest bucket) — sample
     at least 8: for each, read the item and confirm the new unit tag is actually correct AP Statistics unit
     content per the CED, and that the "corrected" framing is justified (i.e. the old legacy tag really was
     wrong, not just different).
   - `provisional_model`, reason `two_model_unit_agreement_no_usable_legacy` (37 items) — sample at least 5.
   - `provisional_model`, reason `two_model_confirmed_legacy_unit` (5 items) — spot-check 2.
   For every sampled item, state in your report: content_key, assigned unit(s), your own independent read of
   what unit the item's content actually requires, and whether you agree or disagree.
4. **Difficulty band placement — this one needs real scrutiny, not a rubber stamp.**
   `docs/research/apbio_difficulty_calibration_2026_09_22/STATISTICS_AND_CHEMISTRY.md` (the same methodology
   doc your own Chemistry difficulty work was validated against) explicitly states: **"The Statistics
   framework is half-sound — its Hard tier is supported, its Easy/Medium split is not, and its
   Investigative-Task claim is contradicted."** Claude's 170-row load used `basis = 'calibrated_judgement'`
   uniformly (not `calibrated_task_verb`, unlike your Chemistry FRQ rows) and produced a 20.6% Easy / 48.8%
   Medium / 30.6% Hard split — noticeably different from the doc's own reported "landed" structural-v3
   distribution of 51.0% Easy / 27.8% Medium / 21.2% Hard for Statistics. Read the methodology doc's
   Statistics section (§4b and surrounding) in full, then:
   - Determine whether `calibrated_judgement` was actually the right basis choice for a corpus where the
     doc itself says the Easy/Medium split isn't well-supported, or whether this masks a real problem
     (e.g., items being judgment-called into a distribution that doesn't match the validated one for no
     good reason).
   - Sample at least 10 difficulty rows across all three bands and independently judge whether the assigned
     band is defensible given the item's actual content and the CED's difficulty conventions, the same way
     you validated your own Chemistry MCQ distribution against the doc's baseline.
   - If you find the Hard tier is more reliable than Easy/Medium (per the doc's own caveat), say so
     specifically — don't just report "looks fine" or "looks wrong" in aggregate.
5. **Migration file honesty.** The two Statistics migration files were reconstructed after the fact, not
   applied in that exact form originally (see `docs/product/TIER3_PAIR1_STATUS_2026_09_25.md`'s "Known gap"
   section for why). Confirm the reconstructed SQL, if you trace through it by hand, actually produces rows
   matching what's currently in Production — i.e. that the reconstruction is faithful, not just plausible.

## What NOT to do

- Do not re-run, modify, or supersede any of Claude's Statistics label or difficulty rows. This is read-only
  review.
- Do not start Pair 2 or any other work after this task. Stop and report.
- Do not promote anything to `validated` — that's a separate, human-governed step regardless of what you
  find.

## Deliverable

`docs/content/CODEX_CROSS_QA_AP_STATISTICS_2026_09_25.md`, covering:

- Count/contamination verification results (pass/fail, with the actual query results shown).
- The full sampled-item table from check 3 (content_key, assigned unit(s), your independent read, agree/
  disagree), for every item you sampled.
- Your finding on check 4 (difficulty methodology), including the specific question of whether
  `calibrated_judgement` was the right basis choice given the doc's own Easy/Medium-split caveat, and your
  band-by-band sample results.
- Migration-file faithfulness finding from check 5.
- An overall verdict: is AP Statistics Tier 3 (labels + difficulty) ready to stand as-is, or does anything
  need a follow-up fix? If the latter, name exactly which content_keys and what's wrong, the same level of
  specificity Claude used reviewing your Chemistry work.

Open a PR with just the report doc (no code/migration changes) when done.

---

Paste the block below into Codex.

```text
Task -- Cross-QA of Claude's AP Statistics Tier 3 work, 2026-09-25.

Merge main first:

    git fetch origin
    git switch -c codex/apstats-cross-qa-2026-09-25 origin/main

This is a READ-ONLY review task. No Production writes, no migrations, no code changes -- the deliverable is
a report only.

Read the full body of docs/content/CODEX_TASK_AP_STATISTICS_CROSS_QA_2026_09_25.md before doing anything --
it defines exactly what to verify (counts, contamination, a weighted sample of unit-assignment reasoning,
and a real scrutiny pass on difficulty band placement given a known validity caveat in the methodology doc
for Statistics specifically) and what the deliverable report must contain.

Also read:
- docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md -- why this cross-QA step exists.
- docs/research/AP_STATISTICS_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md -- the label run's own report.
- docs/research/apbio_difficulty_calibration_2026_09_22/STATISTICS_AND_CHEMISTRY.md -- the difficulty
  methodology doc, especially the Statistics sections and its explicit Easy/Medium-split caveat.
- docs/product/TIER3_PAIR1_STATUS_2026_09_25.md -- full narrative and the migration-file reconstruction
  context.

Verify against Production directly via the Supabase MCP tool (project pcntajvbdfqhbeewmdry) -- do not just
read the docs and assume they're accurate; that's the whole point of this task.

DELIVERABLE

docs/content/CODEX_CROSS_QA_AP_STATISTICS_2026_09_25.md, per the main doc's "Deliverable" section. Open a PR
with just that report doc. Stop there -- do not touch any label/difficulty rows, do not start Pair 2.
```
