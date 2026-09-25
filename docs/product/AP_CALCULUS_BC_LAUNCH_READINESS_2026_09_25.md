# AP Calculus BC Launch Readiness (Tier 1 Criterion-4, 2026-09-25)

This pass executes Tier 1 only from `docs/product/SUBJECT_READINESS_COMPLETION_PLAN_2026_09_25.md`:
close the canonical-answer gap for AP Calculus BC. No Production writes were made in Codex's original
pass -- migrations were proposal artifacts pending cross-QA.

**Update after cross-QA and apply (Claude, same day):** Claude independently re-derived all 29 items
(two parallel review agents) before applying. The 10 `apcalcbc-frq-np1-*` items were confirmed clean and
applied exactly as Codex proposed. The 19 `apcalcbc-frq-u13-*` items had a genuine completeness defect:
that batch's `frq_criteria.learner_facing_text` is generic rubric-label text with no computed values
(e.g. "Correctly evaluates the limit."), while the actual numbers live only in `evidence_requirements`,
which Codex's `string_agg(learner_facing_text, ...)` method never included -- so the proposed canonical
text for those 19 items would have stated what a correct response *does* without ever stating what it
*is*. Reapplied those 19 sourcing from `evidence_requirements` instead (see
`supabase/migrations/20260925170000_apcalcbc_u13_canonical_answers_19_items_evidence_source.sql`), after
independently verifying every one of the 19 items' math from scratch. Also fixed
`apcalcbc-frq-u13-016`'s stimulus, which never stated the point (1,2) that its own `evidence_requirements`
assumes (verified (1,2) satisfies the given curve). All 29 items are now applied to Production and
independently re-verified: 0 blank, 0 span-concatenation mismatches, 0 criterion-coverage mismatches.
Criterion 4 is now closed for AP Calculus BC.

## Production preflight

Read-only Production checks against project `pcntajvbdfqhbeewmdry` confirmed the measured facts in
`prompts/CODEX_WORK_ORDER_AP_CALCULUS_BC_LAUNCH_READINESS_2026_09_25.md`:

- exactly one published, non-retired AP Calculus BC pack:
  `3778d753-273a-403d-8f02-55dc64ec6a27`;
- 129 published items: 65 FRQ and 64 MCQ;
- 65/65 FRQ have `frq_criteria`;
- 64/64 MCQ have exactly one `mcq_choices.is_correct = true`;
- 36/65 FRQ have `canonical_answer_1`; 29/65 are missing it;
- 0/65 FRQ have `canonical_answer_spans`.

## Criterion 1 — reviewed/approved

Current state: satisfied for the measured pack. The preflight query scoped to
`content_items.status='published'` and current latest `content_item_versions`.

Tier 1 proposal: no change.

## Criterion 2 — rubric exists

Current state: satisfied for the measured pack. All 65 FRQ have one or more `frq_criteria` rows, and
all 64 MCQ have exactly one correct choice.

Tier 1 proposal: no rubric or MCQ-choice changes.

## Criterion 3 — serving label

Current state: still open. The work order's prior measurement remains the current state for this pass:
4 validated serving labels and 125 non-validated labels.

Tier 1 proposal: no label changes. Criterion 3 remains outside Tier 1.

## Criterion 4 — canonical answer

Current state before proposal: 29 published FRQ current versions have blank `canonical_answer_1`.
The missing set is:

- `apcalcbc-frq-np1-001` through `apcalcbc-frq-np1-010`;
- `apcalcbc-frq-u13-001` through `apcalcbc-frq-u13-016`;
- `apcalcbc-frq-u13-018`, `apcalcbc-frq-u13-019`, `apcalcbc-frq-u13-020`.

Content investigation: these are genuine, complete FRQ items, not placeholder/test rows. Stems and
stimuli are student-facing and assess normal Calculus BC/AB-aligned skills: limits and continuity,
derivatives and derivative rules, implicit differentiation, related rates, IVT, inverse/trig/log/exp
derivatives, and early BC bank coverage.

Proposal artifact:

- `supabase/migrations/20260925160000_apcalcbc_canonical_answers_29_items.sql`

The migration is proposal-only until cross-QA. It assembles `canonical_answer_1` from each target
item's own ordered `frq_criteria.learner_facing_text`, inserts criterion-exclusive
`canonical_answer_spans`, and includes transaction checks for:

- 29 target versions;
- all target rows blank before update;
- zero pre-existing target spans;
- span concatenation exactly equals the written `canonical_answer_1`;
- span criterion-key coverage exactly equals each item's `frq_criteria`;
- span count equals `2 * criteria_count - 1` per item.

Read-only assembly validation before writing this doc found the proposed migration would insert 207
criterion spans plus 178 separator spans, 385 total spans.

## Criterion 5 — difficulty value

Current state: still open. The work order's prior measurement remains current for this pass: 0/129
items have `content_item_difficulty` rows.

Tier 1 proposal: no difficulty changes. Criterion 5 remains outside Tier 1.

## Criterion 6 — exam pack version

Current state: satisfied. Exactly one AP Calculus BC exam pack version is published and non-retired:
`3778d753-273a-403d-8f02-55dc64ec6a27`.

Tier 1 proposal: no pack-routing changes.

## Stop point

Tier 1 Calculus BC is ready for independent QA and then explicit apply approval. This pass did not
promote labels, compute difficulty, alter pack routing, or apply the migration to Production.
