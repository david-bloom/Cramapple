# QA Task — Tier 1 Precalculus + Calculus BC Canonical Proposals (2026-09-25)

Review the two Tier 1 criterion-4 proposal migrations. Do not apply them to Production.

Files to review:

- `supabase/migrations/20260925150000_apprecalc_canonical_answers_32_items.sql`
- `supabase/migrations/20260925160000_apcalcbc_canonical_answers_29_items.sql`
- `docs/product/AP_PRECALCULUS_LAUNCH_READINESS_2026_09_25.md`
- `docs/product/AP_CALCULUS_BC_LAUNCH_READINESS_2026_09_25.md`

Use the fixed checklist in `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`, but this QA scope is
criterion 4 only. Criteria 3 and 5 are intentionally left open.

## Required QA checks

1. Re-run the live read-only Production inventory for AP Precalculus and AP Calculus BC:
   - exactly one published/non-retired pack per subject;
   - AP Precalculus: 120 published items, 65 FRQ, 55 MCQ, 32 FRQ missing `canonical_answer_1`;
   - AP Calculus BC: 129 published items, 65 FRQ, 64 MCQ, 29 FRQ missing `canonical_answer_1`;
   - all FRQ have `frq_criteria`;
   - all MCQ have exactly one correct choice;
   - both subjects currently have 0 FRQ with `canonical_answer_spans`.
2. Confirm the target key lists in both migrations exactly match the live blank-canonical sets.
3. Independently inspect a representative sample from each target cluster and confirm the items are
   genuine FRQ content, not placeholders:
   - Precalculus: `006/007/029`, `np2-*`, and `u12-*`;
   - Calculus BC: `np1-*` and `u13-*`.
4. Review whether deriving `canonical_answer_1` from ordered `frq_criteria.learner_facing_text` is
   acceptable for these generated banks. If you reject that approach, say so and identify which items
   need richer hand-authored solution prose before Production apply.
5. Without applying writes, reason through the migration checks:
   - target count;
   - preblank state;
   - no pre-existing target spans;
   - exact span reconstruction;
   - exact criterion-key coverage;
   - expected span counts: Precalculus 352 total spans, Calculus BC 385 total spans.
6. Confirm the migrations do not touch labels, difficulty, pack routing, MCQ choices, or non-target FRQ.

## Output

Write a concise QA report with:

- pass/fail for each migration;
- any P0/P1 content correctness concern;
- whether you recommend apply, revise, or abandon;
- if revise, the exact item keys and required correction.
