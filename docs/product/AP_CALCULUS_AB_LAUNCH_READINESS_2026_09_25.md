# AP Calculus AB Launch Readiness — 2026-09-25

Measured against the six criteria in `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`. This subject was
worked directly by Claude (not delegated to Codex, per explicit instruction), unlike Statistics.
Single exam_pack_version (`826c8cf1-bc1b-4f2a-bd33-61a758e1487d`), 124 published items (62 FRQ, 62 MCQ).

## Criterion 1 — Reviewed/approved

All 124 items are `content_items.status='published'` with a published current version. Clean, no work
needed.

## Criterion 2 — Rubric exists

62/62 FRQ have `frq_criteria` rows. 62/62 MCQ have exactly one `is_correct` choice. Clean today, but a
live grading-correctness defect was found and fixed en route: 4 items
(`apcalcab-frq-np2-008`, `apcalcab-frq-u13-002`, `apcalcab-frq-u13-006`, `apcalcab-frq-u13-018`) had
every `frq_criteria` row duplicated exactly (created twice, two days apart, presumably a re-run seed
script), doubling their live point totals for anyone attempting them. Fixed in
`supabase/migrations/20260925000000_apcalcab_dedupe_frq_criteria.sql`, verified independently after
apply with a query scoped to every published Calc AB FRQ (not just the 4), confirming zero remaining
duplication anywhere in the subject.

## Criterion 3 — Serving label

**Open.** Of 91 current serving-label rows across the 124 items: 9 validated, 14 provisional_model, 16
held, 9 stale, 43 legacy_unvalidated. 82 non-validated items need the same two-model relabel pass
Biology's FF-3 and the Physics-C-Mech/Calc-BC order used. Not started this session — proposed as the
next Codex work order (see below).

## Criterion 4 — Canonical answer

**Closed 2026-09-25.** All 33 FRQ that had a blank `canonical_answer_1`
(`apcalcab-frq-024/025/026`, `apcalcab-frq-np2-001..010`, `apcalcab-frq-u13-001..020`) now have one,
authored directly by Claude with criterion-exclusive `canonical_answer_spans` for every item —
62/62 FRQ now have a canonical answer.

Every value was independently re-derived from the stem and rubric (not copied from the rubric's
`learner_facing_text`) before being written. Spot-checked derivations included u13-011's four
one-sided infinite-limit signs, u13-017's arcsin/arctan derivative simplification, and u13-019's
implicit second derivative — all matched the rubric's stated values, confirming the rubric text itself
was correct. Verified independently after write, three ways:
1. Span concatenation equals `canonical_answer_1` exactly, for all 33 items (query re-run against
   Production after apply, not just the in-transaction check).
2. Every `frq_criteria` criterion for each item is covered by exactly one exclusive span — no
   criterion missing, none duplicated, none extra (33/33 items fully covered).
3. `canonical_answer_1` was `NULL` for all 33 before this work — a pure addition, nothing overwritten.

Applied to Production in 6 batches (`supabase/migrations/20260925010000_apcalcab_canonical_answers_33_items.sql`
plus 5 follow-on batches applied via a background agent from the same pre-generated, pre-verified SQL)
after an earlier full-batch attempt failed cleanly on a `NOT NULL` constraint (`proposal_run`) and
rolled back with no partial writes.

`canonical_answer_spans` coverage is now 62/62 FRQ (up from 0/62) — this is a separate, later-arriving
fact from `canonical_answer_1` and was tracked distinctly throughout, per the criteria doc's warning
not to conflate the two.

## Criterion 5 — Difficulty value

**Open.** 0 of 124 items have any `app.content_item_difficulty` row. Not started this session —
proposed as the next Codex work order (see below), reusing DECISION-0065's attainment-ratio method.

## Criterion 6 — Exam pack version

Clean. Exactly one `ap_calculus_ab` exam_pack_version is `status='published'` and `retired_at IS NULL`
— no routing hazard.

## What's still open

Criteria 3 (serving labels, 82 items) and 5 (difficulty, 124 items) remain. Both require methods this
session did not run directly: criterion 3 needs the two-model agreement pipeline, and criterion 5
needs the CRR verb-verification + subject-mean normalization pipeline from DECISION-0065. Rather than
rush either with a single model pass and no cross-check, both are scoped into a follow-on Codex work
order once this doc's criterion-4 work is QA'd (see `prompts/CODEX_QA_PROMPT_AP_CALCULUS_AB_2026_09_25.md`).
