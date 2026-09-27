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
| AP Statistics | Criterion 4 (canonicals) closed directly by Claude 2026-09-25, all 35 missing items authored and independently re-verified, 69/69 current-published-version FRQ on the primary (only-functioning) exam pack. Criterion 6's dual-published-version hazard (a second, MCQ-only pack with 0 FRQ served) is untouched by this work and remains a separate P0. | `supabase/migrations/20260925050000_apstats_canonical_answers_35_items.sql`, `prompts/CODEX_WORK_ORDER_AP_STATISTICS_LAUNCH_READINESS_2026_09_24.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |
| AP Calculus AB | Criterion 4 (canonicals) closed and independently re-verified by Claude 2026-09-25, all 33 items, 62/62 FRQ; also fixed a live grading bug (duplicated frq_criteria on 4 items). Codex QA prompt written. Criteria 3 (labels) and 5 (difficulty) still open. | `docs/product/AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_25.md`, `prompts/CODEX_QA_PROMPT_AP_CALCULUS_AB_2026_09_25.md`, `supabase/migrations/20260925000000_apcalcab_dedupe_frq_criteria.sql`, `supabase/migrations/20260925010000_apcalcab_canonical_answers_33_items.sql` |
| AP Chemistry | Criterion 4 (canonicals) closed by Claude 2026-09-25, last 1 of 53 FRQ. **Correction 2026-09-25 (QA pass):** 53 counts item-level `published` status only; 2 of those 53 FRQ have a `retired` latest version (pre-existing canonicals, untouched by this week's work) — the strict current-published-version count is 51/51. Codex work order written for criteria 3 (labels, 78/123 non-validated) and 5 (difficulty, 0/123), also stated at the item-level count. | `docs/product/AP_CHEMISTRY_LAUNCH_READINESS_2026_09_25.md`, `prompts/CODEX_WORK_ORDER_AP_CHEMISTRY_LABELS_AND_DIFFICULTY_2026_09_25.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |
| AP Precalculus | Criterion 4 (canonicals) closed 2026-09-25 (Tier 1): Codex proposed 32 items, Claude independently re-derived and applied all 32 (confirmed correct/complete, cosmetic-only P2 phrasing note). Criteria 3 (labels, 30/120 validated) and 5 (difficulty, 0/120) still open. | `docs/product/AP_PRECALCULUS_LAUNCH_READINESS_2026_09_25.md`, `supabase/migrations/20260925150000_apprecalc_canonical_answers_32_items.sql` |
| AP Calculus BC | Criterion 4 (canonicals) closed 2026-09-25 (Tier 1): Codex proposed 29 items; Claude's independent QA found 19 of 29 (`u13-*`) had their actual answer values missing (source-field defect, not a math error) and 1 (`u13-016`) had a stem gap; fixed both and applied all 29. Criteria 3 (labels, 4/129 validated) and 5 (difficulty, 0/129) still open. | `docs/product/AP_CALCULUS_BC_LAUNCH_READINESS_2026_09_25.md`, `supabase/migrations/20260925160000_apcalcbc_np1_canonical_answers_10_items.sql`, `supabase/migrations/20260925170000_apcalcbc_u13_canonical_answers_19_items_evidence_source.sql` |
| AP Physics 1 | Criterion 4 (canonicals) closed directly by Claude 2026-09-25, all 39 missing items authored, 54/54 current-published-version FRQ. Independent post-apply re-verification caught and fixed a genuine defect: items apphy1-frq-033/035 had swapped version_ids in the source data (each item's own span concatenation was internally consistent, masking it from the migration's own check; a follow-up criteria-coverage diff against `frq_criteria` surfaced it) — corrected via a same-migration span/version_id swap, re-verified clean. Criteria 3 (labels, 115/124 non-validated) and 5 (difficulty, 0/124) still open. | `supabase/migrations/20260925060000_apphysics1_canonical_answers_39_items.sql`, `prompts/CODEX_WORK_ORDER_AP_PHYSICS_1_LAUNCH_READINESS_2026_09_25.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |
| AP Physics 2 | Criterion 4 (canonicals) closed directly by Claude 2026-09-25, all 19 items, 37/37 FRQ (item-level), independently re-verified. **Correction 2026-09-25 (QA pass):** 9 of those 37 have a `retired` latest version (pre-existing canonicals, untouched by this week's work) — strict current-published-version count is 28/28. Criteria 3 (labels, 69/79 non-validated) and 5 (difficulty, 0/79) still open — Codex work order covers those too, now stale on criterion 4 but still current on 3/5. | `supabase/migrations/20260925020000_apphysics2_canonical_answers_19_items.sql`, `prompts/CODEX_WORK_ORDER_AP_PHYSICS_2_LAUNCH_READINESS_2026_09_25.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |
| AP Physics C: Mechanics | Criterion 4 (canonicals) closed directly by Claude 2026-09-25, all 29 items, 42/42 FRQ (item-level), independently re-verified. **Correction 2026-09-25 (QA pass):** 6 of those 42 have a `retired` latest version (pre-existing canonicals, untouched) — strict current-published-version count is 36/36. Criterion 5 (difficulty, 0/84) still open. Criterion 3 (labels) still covered by the pre-existing, not-yet-run FF-3/DECISION-0066 relabel order. | `supabase/migrations/20260925030000_apphysicscm_canonical_answers_29_items.sql`, `prompts/CODEX_WORK_ORDER_PHYSICS_C_MECH_AND_CALC_BC_RELABEL_2026_09_24.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |
| AP Physics C: E&M | Criterion 4 (canonicals) closed directly by Claude 2026-09-25, all 39 items, 55/55 FRQ (item-level), independently re-verified. **Correction 2026-09-25 (QA pass):** 6 of those 55 have a `retired` latest version (pre-existing canonicals, untouched) — strict current-published-version count is 49/49. Criteria 3 (labels, 97/103 non-validated) and 5 (difficulty, 0/103) still open. A separate, pre-existing gap remains in canonical_answer_spans for the other 16 (already-canonicaled) FRQ, out of scope here. | `supabase/migrations/20260925040000_apphysicscem_canonical_answers_39_items.sql`, `prompts/CODEX_WORK_ORDER_AP_PHYSICS_C_EM_LAUNCH_READINESS_2026_09_25.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |

**Codex QA sweep and remediation, 2026-09-25 (all seven canonical-content subjects above).** Codex independently
re-verified all 372 FRQ with a canonical answer across the seven subjects
(`docs/content/CODEX_QA_REPORT_CANONICAL_ANSWERS_CALC_AB_THROUGH_PHYSICS_1_2026_09_25.md`, PR #188) and found 34
P0 correctness/completeness defects — mostly pre-existing legacy canonicals omitting a subpart, diagram, or
derivation their own rubric requires, plus 2 numerical/source-data errors in AP Statistics and 2 defects within
this week's own new writes. All 34 have been fixed directly in Production and independently re-derived from each
item's own stem/frq_criteria (not just patched to match the finding text), across
`supabase/migrations/20260925070000` through `20260925130000`. Two of the 34 required fixing the *rubric* itself,
not just the canonical: `apcalcab-frq-005` (wrong stimulus constant) and `apphy1-frq-026` (a rubric criterion
asserting "Track A always arrives first," verified false with a worked counter-example). A companion QA task
(`docs/content/CODEX_QA_TASK_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`, PR #189) separately
re-verified the six-criteria measurements, live selector behavior, and work-order accuracy for these subjects
plus Precalculus and Calc BC — see that report for criteria 3/5/6 status, which this remediation pass did not
touch.
