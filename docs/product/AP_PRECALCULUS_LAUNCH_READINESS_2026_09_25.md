# AP Precalculus Launch Readiness (Tier 1 Criterion-4 Proposal, 2026-09-25)

This pass executes Tier 1 only from `docs/product/SUBJECT_READINESS_COMPLETION_PLAN_2026_09_25.md`:
close the canonical-answer gap for AP Precalculus as a proposal artifact. No Production writes were
made in this Codex pass.

## Production preflight

Read-only Production checks against project `pcntajvbdfqhbeewmdry` confirmed the measured facts in
`prompts/CODEX_WORK_ORDER_AP_PRECALCULUS_LAUNCH_READINESS_2026_09_25.md`:

- exactly one published, non-retired AP Precalculus pack:
  `5522b532-5e50-41f2-99a2-10144bd4e8db`;
- 120 published items: 65 FRQ and 55 MCQ;
- 65/65 FRQ have `frq_criteria`;
- 55/55 MCQ have exactly one `mcq_choices.is_correct = true`;
- 33/65 FRQ have `canonical_answer_1`; 32/65 are missing it;
- 0/65 FRQ have `canonical_answer_spans`.

## Criterion 1 — reviewed/approved

Current state: satisfied for the measured pack. The preflight query scoped to
`content_items.status='published'` and current latest `content_item_versions`.

Tier 1 proposal: no change.

## Criterion 2 — rubric exists

Current state: satisfied for the measured pack. All 65 FRQ have one or more `frq_criteria` rows, and
all 55 MCQ have exactly one correct choice.

Tier 1 proposal: no rubric or MCQ-choice changes.

## Criterion 3 — serving label

Current state: still open. The work order's prior measurement remains the current state for this pass:
30 validated serving labels and 90 non-validated labels.

Tier 1 proposal: no label changes. Criterion 3 remains outside Tier 1.

## Criterion 4 — canonical answer

Current state before proposal: 32 published FRQ current versions have blank `canonical_answer_1`.
The missing set is:

- `apprecalc-frq-006`, `apprecalc-frq-007`, `apprecalc-frq-029`;
- `apprecalc-frq-np2-001` through `apprecalc-frq-np2-010`;
- `apprecalc-frq-u12-002` through `apprecalc-frq-u12-020`.

Content investigation: these are genuine, complete FRQ items, not placeholder/test rows. Stems and
stimuli are student-facing and assess normal Precalculus skills: rational/log/exponential modeling,
symbolic manipulation, trigonometric modeling, polynomial/rational behavior, and applied function
analysis.

Proposal artifact:

- `supabase/migrations/20260925150000_apprecalc_canonical_answers_32_items.sql`

The migration is proposal-only until cross-QA. It assembles `canonical_answer_1` from each target
item's own ordered `frq_criteria.learner_facing_text`, inserts criterion-exclusive
`canonical_answer_spans`, and includes transaction checks for:

- 32 target versions;
- all target rows blank before update;
- zero pre-existing target spans;
- span concatenation exactly equals the written `canonical_answer_1`;
- span criterion-key coverage exactly equals each item's `frq_criteria`;
- span count equals `2 * criteria_count - 1` per item.

Read-only assembly validation before writing this doc found the proposed migration would insert 192
criterion spans plus 160 separator spans, 352 total spans.

## Criterion 5 — difficulty value

Current state: still open. The work order's prior measurement remains current for this pass: 0/120
items have `content_item_difficulty` rows.

Tier 1 proposal: no difficulty changes. Criterion 5 remains outside Tier 1.

## Criterion 6 — exam pack version

Current state: satisfied. Exactly one AP Precalculus exam pack version is published and non-retired:
`5522b532-5e50-41f2-99a2-10144bd4e8db`.

Tier 1 proposal: no pack-routing changes.

## Stop point

Tier 1 Precalculus is ready for independent QA and then explicit apply approval. This pass did not
promote labels, compute difficulty, alter pack routing, or apply the migration to Production.
