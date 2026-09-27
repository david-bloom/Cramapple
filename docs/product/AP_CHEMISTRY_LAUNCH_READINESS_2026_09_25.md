# AP Chemistry Launch Readiness — 2026-09-25

Measured against the six criteria in `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`. Single exam_pack_version
(`c9ca46b2-b529-4ed3-9741-dddea455ab9b`), 123 published items (53 FRQ, 70 MCQ).

## Criterion 1 — Reviewed/approved

All 123 items are `content_items.status='published'` with a published current version. Clean.

## Criterion 2 — Rubric exists

53/53 FRQ have `frq_criteria` rows. 70/70 MCQ have exactly one `is_correct` choice. Clean.

## Criterion 3 — Serving label

**Open.** Of 123 current serving-label rows: 45 validated, 32 held, 31 stale, 24 legacy_unvalidated, 2
provisional_model. 78 non-validated items need the same two-model relabel pass Biology's FF-3 and Calc
AB's Part 3 used. Not started this session — proposed as a Codex work order below.

## Criterion 4 — Canonical answer

**Closed 2026-09-25.** 53/53 FRQ now have `canonical_answer_1` (was 52/53 at the start of this
session). The single remaining item, `apchem-frq-l-012` (van der Waals equation, gas-behavior
correction), was authored directly, independently re-derived (ideal pressure 24.6 atm, van der Waals
pressure 22.1 atm — both recomputed from the given a/b constants and cross-checked against the
rubric's stated values, which matched), and written with 5 criterion-exclusive spans covering all 5
`frq_criteria` rows (a1–a5). Verified: `canonical_answer_1` was `NULL` beforehand (pure addition), and
span concatenation equals `canonical_answer_1` exactly, re-checked against Production after write.

`canonical_answer_spans` coverage for this one item is new; the other 52 Chemistry FRQ's span coverage
was not measured this session and should not be assumed — track separately per the criteria doc's
warning.

## Criterion 5 — Difficulty value

**Open.** 0 of 123 items have any `app.content_item_difficulty` row. Not started this session —
proposed as a Codex work order below, reusing DECISION-0065's method.

## Criterion 6 — Exam pack version

Clean. Exactly one `ap_chemistry` exam_pack_version is `status='published'` and `retired_at IS NULL`.

## What's still open

Criteria 3 (serving labels, 78 items) and 5 (difficulty, 123 items), same shape of gap as Calc AB,
Precalculus, and Calculus BC. Proposed Codex work order:
`prompts/CODEX_WORK_ORDER_AP_CHEMISTRY_LABELS_AND_DIFFICULTY_2026_09_25.md`.
