# Subject Servability Criteria

**Status:** Active. First applied to AP Biology 2026-09-24
(`docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md`), then to AP Statistics and AP Calculus AB
the same week. Use this doc as the fixed checklist for any future subject readiness pass, instead of
re-deriving the criteria each time.

## Why this exists

`content_items.status = 'published'` — the "Published" column in the reviewer tool
(`https://cramapple.com/reviewer/content`) — means a human reviewed and approved the item's content.
It is a real, meaningful gate, and it is **not** the same gate as "a student can actually be served
this item." Those are separate systems that were never wired to check against each other, and the
failure mode when they diverge is silent: a serving selector just returns fewer rows, or zero, with
no error. Biology's launch-readiness work this week found this gap by accident, by calling the real
serving RPCs instead of trusting the reviewer tool's count. This doc exists so the next subject finds
it on purpose.

## The six criteria

An item is genuinely ready for a real student only when all six hold. None of the first five imply
the others, and none of them imply the sixth.

| # | Criterion | What it actually is | Where to check it |
| --- | --- | --- | --- |
| 1 | **Reviewed/approved** | `content_items.status = 'published'` (and, for the specific version served, `content_item_versions.status = 'published'`) | `app.content_items`, `app.content_item_versions` |
| 2 | **Rubric exists** | Every FRQ has at least one `frq_criteria` row with real `points_possible`, `learner_facing_text`, `evidence_requirements`. MCQ equivalent: every published MCQ has `mcq_choices` rows with exactly one `is_correct = true`. | `app.frq_criteria`, `app.mcq_choices` |
| 3 | **Serving label** | A current (non-superseded), `label_scope='serving'` row in `content_taxonomy_labels` exists for the item, and its `label_status` is good enough for whichever serving path is in use (`select_practice_frqs`/`select_biology_practice_items` don't require a label at all; `select_unit_gated_practice_items` requires `label_status='validated'` specifically). | `app.content_taxonomy_labels` |
| 4 | **Canonical answer** | `canonical_answer_1` is non-empty (FRQ) or the correct choice is unambiguous (MCQ, via `mcq_choices.is_correct` — MCQs don't need a canonical text). Distinct from `canonical_answer_spans` (Open Hand's exact-answer segmentation, a separate, later-arriving fact — do not conflate "has a canonical" with "has spans"). | `app.content_item_versions.canonical_answer_1`, `app.canonical_answer_spans` |
| 5 | **Difficulty value** | A row in `app.content_item_difficulty` for the item's current version. Nullable `attainment_ratio` is acceptable (judgment-basis items, or task-verb items with an unresolved verb) as long as `difficulty` (the Easy/Medium/Hard band) and `basis` are populated — see `docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md`'s D3/DECISION-0061 for why a null ratio with an honest `basis` is acceptable and a fabricated ratio is not. | `app.content_item_difficulty` |
| 6 | **Exam pack version** | The item's `exam_pack_version_id` is the one version students are actually routed to for that subject. **Check this is singular before checking anything else** — verify exactly one `exam_pack_versions` row for the subject has `status='published'` and `retired_at IS NULL`; more than one is a routing hazard even if every other criterion is met (this is what Statistics' dual-published-version finding was, 2026-09-24: 51 real sessions served against a version passing every other check except this one). | `app.exam_pack_versions`, `app.profiles.active_exam_pack_version_id`, `public.set_active_exam_pack_version` |

## How to measure, not assume

- **Call the real serving RPCs** (`public.select_practice_frqs`, `app.select_unit_gated_practice_items`,
  or the subject's dedicated selector if it has one) directly against Production. Do not model what
  they should return from reading their SQL — Biology's own readiness doc got this wrong once on
  2026-09-24 and had to correct it same-day.
- **Criterion 6 gates everything else.** If two exam pack versions are simultaneously published for a
  subject, criteria 1-5 have to be measured per-version, not for the subject as a whole — an item
  meeting all of 1-5 under a version nobody is routed to is not servable to anyone.
- **A single run of anything is not evidence.** Where a criterion involves a model call (grader-gate
  reachability, two-model label agreement), run it 3 times minimum before treating the result as
  reliable — see `docs/research/biology_m5_grader_baseline_2026_09_24.md` (M5-B-002) for why: the same
  text and rubric produced different grader verdicts across runs on the same deployment.
- **An empty result needs a reason, not just a count.** If a selector returns zero items, find out
  which of the six criteria is actually failing before reporting "zero servable" — the fix is
  different depending on whether it's criterion 3 (no label), 6 (wrong exam pack version), or
  something else entirely.

## Applied so far

| Subject | Status | Doc |
| --- | --- | --- |
| AP Biology | Done, 2026-09-24 | `docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md`, `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` |
| AP Statistics | In progress — Codex QA'd by Claude 2026-09-25 (morning) | `prompts/CODEX_WORK_ORDER_AP_STATISTICS_LAUNCH_READINESS_2026_09_24.md` |
| AP Calculus AB | Criterion 4 (canonicals) closed and independently re-verified by Claude 2026-09-25, all 33 items, 62/62 FRQ; also fixed a live grading bug (duplicated frq_criteria on 4 items). Codex QA prompt written. Criteria 3 (labels) and 5 (difficulty) still open. | `docs/product/AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_25.md`, `prompts/CODEX_QA_PROMPT_AP_CALCULUS_AB_2026_09_25.md`, `supabase/migrations/20260925000000_apcalcab_dedupe_frq_criteria.sql`, `supabase/migrations/20260925010000_apcalcab_canonical_answers_33_items.sql` |
| AP Chemistry | Criterion 4 (canonicals) closed by Claude 2026-09-25, last 1 of 53 FRQ. Codex work order written for criteria 3 (labels, 78/123 non-validated) and 5 (difficulty, 0/123). | `docs/product/AP_CHEMISTRY_LAUNCH_READINESS_2026_09_25.md`, `prompts/CODEX_WORK_ORDER_AP_CHEMISTRY_LABELS_AND_DIFFICULTY_2026_09_25.md` |
| AP Precalculus | Measured 2026-09-25, work order written, not yet run | `prompts/CODEX_WORK_ORDER_AP_PRECALCULUS_LAUNCH_READINESS_2026_09_25.md` |
| AP Calculus BC | Measured 2026-09-25, work order written, not yet run | `prompts/CODEX_WORK_ORDER_AP_CALCULUS_BC_LAUNCH_READINESS_2026_09_25.md` |
| Everyone else (Physics 1/2/C-Mech/C-E&M) | Not started | — |
