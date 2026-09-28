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

**TASK-0046, 2026-09-28** ran a full six-criteria live pass for the 8 non-Day-1 subjects (Chemistry,
Calc AB, Calc BC, Precalculus, Physics 1, Physics 2, Physics C: E&M, Physics C: Mechanics). Result for
all 8: **Pass on criteria 1/2/4/5/6, Partial on criterion 3.** See the dated section near the end of
this doc for full per-subject numbers and RPC evidence; the historical rows immediately below are left
as-is (per this doc's own "correct visibly, don't silently overwrite" rule).

| Subject | Status | Doc |
| --- | --- | --- |
| AP Biology | Done, 2026-09-24. **Flat-path criteria 1/2/4/6 re-verified live 2026-09-26 (TASK-0044) — Pass**, see note below the table. | `docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md`, `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` |
| AP Statistics | Criterion 4 (canonicals) closed directly by Claude 2026-09-25, all 35 missing items authored and independently re-verified, 69/69 current-published-version FRQ on the primary (only-functioning) exam pack. Criterion 6's dual-published-version hazard (a second, MCQ-only pack with 0 FRQ served) is untouched by this work and remains a separate P0. **Flat-path criteria 1/2/4/6 re-verified live 2026-09-26 (TASK-0044): FRQ Pass; MCQ content-ready but no backend selector serves it on the flat path (Statistics has no combined selector — see note below the table); live-app verification is TASK-0043's job.** | `supabase/migrations/20260925050000_apstats_canonical_answers_35_items.sql`, `prompts/CODEX_WORK_ORDER_AP_STATISTICS_LAUNCH_READINESS_2026_09_24.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |
| AP Calculus AB | Criterion 4 (canonicals) closed and independently re-verified by Claude 2026-09-25, all 33 items, 62/62 FRQ; also fixed a live grading bug (duplicated frq_criteria on 4 items). Codex QA prompt written. Criteria 3 (labels) and 5 (difficulty) still open. | `docs/product/AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_25.md`, `prompts/CODEX_QA_PROMPT_AP_CALCULUS_AB_2026_09_25.md`, `supabase/migrations/20260925000000_apcalcab_dedupe_frq_criteria.sql`, `supabase/migrations/20260925010000_apcalcab_canonical_answers_33_items.sql` |
| AP Chemistry | Criterion 4 (canonicals) closed by Claude 2026-09-25, last 1 of 53 FRQ. **Correction 2026-09-25 (QA pass):** 53 counts item-level `published` status only; 2 of those 53 FRQ have a `retired` latest version (pre-existing canonicals, untouched by this week's work) — the strict current-published-version count is 51/51. Codex work order written for criteria 3 (labels, 78/123 non-validated) and 5 (difficulty, 0/123), also stated at the item-level count. | `docs/product/AP_CHEMISTRY_LAUNCH_READINESS_2026_09_25.md`, `prompts/CODEX_WORK_ORDER_AP_CHEMISTRY_LABELS_AND_DIFFICULTY_2026_09_25.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |
| AP Precalculus | Criterion 4 (canonicals) closed 2026-09-25 (Tier 1): Codex proposed 32 items, Claude independently re-derived and applied all 32 (confirmed correct/complete, cosmetic-only P2 phrasing note). Criteria 3 (labels, 30/120 validated) and 5 (difficulty, 0/120) still open. | `docs/product/AP_PRECALCULUS_LAUNCH_READINESS_2026_09_25.md`, `supabase/migrations/20260925150000_apprecalc_canonical_answers_32_items.sql` |
| AP Calculus BC | Criterion 4 (canonicals) closed 2026-09-25 (Tier 1): Codex proposed 29 items; Claude's independent QA found 19 of 29 (`u13-*`) had their actual answer values missing (source-field defect, not a math error) and 1 (`u13-016`) had a stem gap; fixed both and applied all 29. Criteria 3 (labels, 4/129 validated) and 5 (difficulty, 0/129) still open. | `docs/product/AP_CALCULUS_BC_LAUNCH_READINESS_2026_09_25.md`, `supabase/migrations/20260925160000_apcalcbc_np1_canonical_answers_10_items.sql`, `supabase/migrations/20260925170000_apcalcbc_u13_canonical_answers_19_items_evidence_source.sql` |
| AP Physics 1 | Criterion 4 (canonicals) closed directly by Claude 2026-09-25, all 39 missing items authored, 54/54 current-published-version FRQ. Independent post-apply re-verification caught and fixed a genuine defect: items apphy1-frq-033/035 had swapped version_ids in the source data (each item's own span concatenation was internally consistent, masking it from the migration's own check; a follow-up criteria-coverage diff against `frq_criteria` surfaced it) — corrected via a same-migration span/version_id swap, re-verified clean. Criteria 3 (labels, 115/124 non-validated) and 5 (difficulty, 0/124) still open. | `supabase/migrations/20260925060000_apphysics1_canonical_answers_39_items.sql`, `prompts/CODEX_WORK_ORDER_AP_PHYSICS_1_LAUNCH_READINESS_2026_09_25.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |
| AP Physics 2 | Criterion 4 (canonicals) closed directly by Claude 2026-09-25, all 19 items, 37/37 FRQ (item-level), independently re-verified. **Correction 2026-09-25 (QA pass):** 9 of those 37 have a `retired` latest version (pre-existing canonicals, untouched by this week's work) — strict current-published-version count is 28/28. Criteria 3 (labels, 69/79 non-validated) and 5 (difficulty, 0/79) still open — Codex work order covers those too, now stale on criterion 4 but still current on 3/5. | `supabase/migrations/20260925020000_apphysics2_canonical_answers_19_items.sql`, `prompts/CODEX_WORK_ORDER_AP_PHYSICS_2_LAUNCH_READINESS_2026_09_25.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |
| AP Physics C: Mechanics | Criterion 4 (canonicals) closed directly by Claude 2026-09-25, all 29 items, 42/42 FRQ (item-level), independently re-verified. **Correction 2026-09-25 (QA pass):** 6 of those 42 have a `retired` latest version (pre-existing canonicals, untouched) — strict current-published-version count is 36/36. Criterion 5 (difficulty, 0/84) still open. Criterion 3 (labels) still covered by the pre-existing, not-yet-run FF-3/DECISION-0066 relabel order. | `supabase/migrations/20260925030000_apphysicscm_canonical_answers_29_items.sql`, `prompts/CODEX_WORK_ORDER_PHYSICS_C_MECH_AND_CALC_BC_RELABEL_2026_09_24.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |
| AP Physics C: E&M | Criterion 4 (canonicals) closed directly by Claude 2026-09-25, all 39 items, 55/55 FRQ (item-level), independently re-verified. **Correction 2026-09-25 (QA pass):** 6 of those 55 have a `retired` latest version (pre-existing canonicals, untouched) — strict current-published-version count is 49/49. Criteria 3 (labels, 97/103 non-validated) and 5 (difficulty, 0/103) still open. A separate, pre-existing gap remains in canonical_answer_spans for the other 16 (already-canonicaled) FRQ, out of scope here. | `supabase/migrations/20260925040000_apphysicscem_canonical_answers_39_items.sql`, `prompts/CODEX_WORK_ORDER_AP_PHYSICS_C_EM_LAUNCH_READINESS_2026_09_25.md`, `docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md` |

### Criteria 3/5 reconciliation — 2026-09-27

The criteria 3/5 statements embedded in the historical rows above are superseded by this fresh
Production census. “Validated” below requires the current published version and current taxonomy
hash; difficulty uses that same current-version population.

| Subject | Current-fresh validated labels | Difficulty |
| --- | ---: | ---: |
| AP Biology | 23 | 118/118 |
| AP Statistics | 67 | 170/170 |
| AP Calculus AB | 36 | 122/122 |
| AP Chemistry | 65 | 119/119 |
| AP Precalculus | 53 | 117/117 |
| AP Calculus BC | 45 | 127/127 |
| AP Physics 1 | 85 | 117/117 |
| AP Physics 2 | 50 | 68/68 |
| AP Physics C: Mechanics | 50 | 77/77 |
| AP Physics C: E&M | 75 | 97/97 |

Evidence: `CONTENT_PIPELINE_CODEX_HANDOFF_2026_09_27.md`, the guarded migrations listed there, and
`20260927184534_task0042_promote_blind_third_review_confirmations`. The table uses current-version
and current-hash freshness, not raw status totals.

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

**TASK-0044, 2026-09-26 — October 2 flat-path gate, live verification (criteria 1/2/4/6 only, AP Biology
and AP Statistics).** Called the actual serving RPCs directly against Production
(`pcntajvbdfqhbeewmdry`), not modeled from SQL.

- **AP Biology** — criterion 6: confirmed exactly one `published`, non-retired `exam_pack_versions` row
  (`2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`). Criteria 1/2/4: of 72 published `targeted_drill` FRQ, 71 are
  servable (the 1 excluded, `APBIO-HDG-2026-GRAPH-010`, is the hand-drawn item `select_practice_frqs`/
  `select_biology_practice_items` structurally exclude — its missing canonical is expected, not a gap);
  all 71 servable FRQ have a canonical answer and a rubric. All 43 published MCQ have a correct
  `mcq_choices` row. Live RPC calls confirm both are actually reachable: `select_practice_frqs(...,
  'targeted_drill', 50)` returned 50 rows (pool capped by limit); `select_biology_practice_items(...)`
  returned a real FRQ+MCQ mix (12 FRQ / 8 MCQ at limit 20). **Pass** on this task's scope.
- **AP Statistics** — criterion 6: re-verified live, still exactly one `published`, non-retired version
  (`548f06be-ccf4-426d-b82b-b424137a4438`); the pilot pack (`7c5a2975-...`) remains `retired_at` set.
  Criteria 1/2/4 for FRQ: of 69 published `targeted_drill` FRQ, 49 are non-hand-drawn and servable, all
  49 with canonical answer and rubric; live `select_practice_frqs(...)` call returned 49 rows, matching
  exactly. Criteria 1/2/4 for MCQ at the **content** level: all 101 published MCQ have a correct
  `mcq_choices` row — content is ready. **But there is no backend selector that can serve them on the
  flat/practice path**: `select_practice_frqs` hard-filters `item_type = 'frq'`, and
  `select_biology_practice_items` (the only combined FRQ+MCQ selector that exists) is Biology-only by
  design (`ep.exam_code = 'ap_biology'` in its own WHERE clause) — confirmed by reading
  `student-session-items/index.ts`, which only routes to it when `sessionExamCode === 'ap_biology'`; for
  every other subject in ordinary (non-unit-gated) mode it always calls `select_practice_frqs`
  regardless of the requested item type, so an MCQ request for AP Statistics returns zero through this
  RPC path, structurally, not intermittently. This is very likely the same effect the 2026-09-24 activity
  log entry described as "`student-session-items` does not reliably honor its `item_type` filter" and
  the Lovable-side "client-side fallback... to query published items directly" — this session's
  evidence suggests that workaround isn't a stopgap for a flaky bug but the *only* path Statistics MCQ
  practice has ever had, since no backend RPC was ever built for it. **This repo's side is content-Pass,
  backend-RPC-Blocked; whether the Lovable-side workaround actually serves AP Statistics MCQs correctly
  in the live app is outside this repo's verification surface and is TASK-0043's runbook item 4 to
  confirm directly against the live student experience — do not assume it works because the content and
  FRQ path do.**

**TASK-0046, 2026-09-28 — full six-criteria live verification, 8 non-Day-1 subjects (Chemistry, Calc
AB, Calc BC, Precalculus, Physics 1, Physics 2, Physics C: E&M, Physics C: Mechanics).** Called
`public.select_unit_gated_practice_items` and `public.select_practice_frqs` directly against
Production (`pcntajvbdfqhbeewmdry`), plus direct SQL against `app.content_items` /
`app.content_item_versions` / `app.frq_criteria` / `app.mcq_choices` / `app.content_item_difficulty` /
`app.content_taxonomy_labels` replicating each RPC's own WHERE-clause logic without a `LIMIT`, to get
true counts unaffected by `select_practice_frqs`'s/`select_unit_gated_practice_items`'s 50-row cap (the
exact misdiagnosis this doc already warns about). TASK-0042 (content pipeline) is confirmed `Status:
Done`, closed 2026-09-27 — its criteria 3/5 work has run for every subject, including these 8; the
partial label coverage below is that pipeline's decided closeout state (114 evidence-backed non-
promotions: 66 disagreements, 48 rubric/scope holds — not unfinished review), not a block on this task.

**Result for all 8 subjects: criteria 1 (published), 2 (rubric), 4 (canonical), 5 (difficulty), and 6
(exam pack version) all Pass at 100%. Criterion 3 (validated serving label) is Partial everywhere** —
expected, since TASK-0042's two-model-agreement pipeline only promotes labels it can independently
confirm; the live unit-gated RPC is fully reachable and returns real, non-zero content today on exactly
the validated-label subset. No subject showed a zero-or-low result; every low criterion-3 fraction below
is explained by TASK-0042's already-closed pipeline state, not a live-serving defect.

| Subject | Exam pack version (criterion 6, singular, confirmed) | C1/2/4/5 (published/rubric/canonical/difficulty) | C3 — validated serving label | Live `select_unit_gated_practice_items` at final unit (capped-at-50 flagged) | Live `select_practice_frqs('targeted_drill')` (capped-at-50 flagged) |
| --- | --- | --- | --- | --- | --- |
| AP Chemistry | `c9ca46b2-b529-4ed3-9741-dddea455ab9b` | FRQ 51/51/51/51; MCQ 68/68/–/68 | FRQ 13/51; MCQ 52/68 | unit 9: FRQ 13, MCQ 50 (**capped, true 52**) | 50 (**capped, true 51**) |
| AP Calculus AB | `826c8cf1-bc1b-4f2a-bd33-61a758e1487d` | FRQ 62/62/62/62; MCQ 60/60/–/60 | FRQ 14/62; MCQ 22/60 | unit 8: FRQ 14, MCQ 22 (uncapped) | 44 (uncapped; `full_exam_frq` 18) |
| AP Calculus BC | `3778d753-273a-403d-8f02-55dc64ec6a27` | FRQ 64/64/64/64; MCQ 63/63/–/63 | FRQ 18/64; MCQ 27/63 | unit 10: FRQ 18, MCQ 27 (uncapped) | 43 (uncapped; `full_exam_frq` 21) |
| AP Precalculus | `5522b532-5e50-41f2-99a2-10144bd4e8db` | FRQ 64/64/64/64; MCQ 53/53/–/53 | FRQ 26/64; MCQ 27/53 | unit 4: FRQ 26, MCQ 27 (uncapped) | 44 (uncapped; `full_exam_frq` 20) |
| AP Physics 1 | `29c719dc-701b-470f-9e49-fab981722d3f` | FRQ 54/54/54/54; MCQ 63/63/–/63 | FRQ 33/54; MCQ 52/63 | unit 8: FRQ 33 (uncapped), MCQ 50 (**capped, true 52**) | 50 (**capped, true 51**; `full_exam_frq` 3) |
| AP Physics 2 | `f584ab0d-114a-4520-9649-42e3e9a2fd22` | FRQ 28/28/28/28; MCQ 40/40/–/40 | FRQ 12/28; MCQ 38/40 | unit 15: FRQ 12, MCQ 38 (uncapped) | 25 (uncapped; `full_exam_frq` 3) |
| AP Physics C: E&M | `841a88cc-773c-44e5-97fa-6504f8667689` | FRQ 49/49/49/49; MCQ 48/48/–/48 | FRQ 31/49; MCQ 44/48 | unit 13: FRQ 31, MCQ 44 (uncapped) | 45 (uncapped; `full_exam_frq` 4) |
| AP Physics C: Mechanics | `ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9` | FRQ 36/36/36/36; MCQ 41/41/–/41 | FRQ 17/36; MCQ 33/41 | unit 7: FRQ 17, MCQ 33 (uncapped) | 33 (uncapped; `full_exam_frq` 3) |

Method: criterion 6 checked first (`app.exam_pack_versions` joined to `app.exam_packs`, filtered
`status='published' and retired_at is null` — exactly one row per subject, confirmed for all 10
subjects product-wide in the same query). Criteria 1/2/4/5 measured against each item's
current-published version only (`distinct on (content_item_id) order by version_num desc`, filtered to
`status='published'`), matching every published item to `frq_criteria`/`mcq_choices`,
`canonical_answer_1`, and `app.content_item_difficulty` — no gaps found on any of the four criteria
across any of the 8 subjects. Criterion 3 read `app.content_taxonomy_labels` filtered to
`label_scope='serving', label_status='validated', superseded_by is null`, matched to the current
version by `label.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)` — the same
freshness check `select_unit_gated_practice_items` itself applies. The unit-gated RPC was called live at
each subject's highest allowed unit (from `app.home_release_manifest.allowed_unit_numbers`, so the
result is the full pool, not one unit's slice); the flat-path RPC was called live with
`_practice_format='targeted_drill'`. Every "capped" cell above was cross-checked against the direct,
un-limited SQL count to confirm the true total rather than reporting the RPC's 50-row ceiling as the
real number.

**Overall status per subject: Pass** on this task's own bar (live-verified, non-zero, explained) — not
a full six-of-six Pass, since criterion 3 is Partial everywhere by design of TASK-0042's already-closed
pipeline. Turning on unit-gated practice for any of these 8 subjects would serve real content today on
the validated-label subset; expanding that subset further is TASK-0042's scope (closed, evidence-backed
partial), not TASK-0046's. Reported to `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` accordingly.

**TASK-0046, 2026-09-28 — Biology and Statistics, criteria 3/5 only (criteria 1/2/4/6 already covered
by TASK-0044).** Called the same live RPCs and direct-SQL true-count method as above against Production
for both Day-1 subjects.

- **Criterion 6 (re-confirmed live):** AP Biology — exactly one `published`, non-retired
  `exam_pack_versions` row (`2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`). AP Statistics — exactly one
  `published`, non-retired row (`548f06be-ccf4-426d-b82b-b424137a4438`); the pilot pack
  (`7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada`) remains `retired_at` set, consistent with TASK-0044's finding.
- **Criteria 1/2/4 (re-confirmed live):** AP Biology — 75 published FRQ, 71 with canonical+rubric; the 4
  without canonical are all `hand_drawn` items (`APBIO-HDG-2026-GRAPH-002/003/008/010`), structurally
  excluded from every serving RPC by design, not a gap — matches TASK-0044's "71 servable" figure
  exactly. 43/43 MCQ have a correct choice. AP Statistics — 69/69 FRQ and 101/101 MCQ, unchanged from
  TASK-0044.
- **Criterion 5 (difficulty):** AP Biology 75/75 FRQ, 43/43 MCQ. AP Statistics 69/69 FRQ, 101/101 MCQ.
  Both 100%.
- **Criterion 3 (validated serving label):** AP Biology — FRQ 9/75 (9/71 of the non-hand-drawn servable
  pool), MCQ 14/43. AP Statistics — FRQ 51/69, MCQ 16/101.
- **Live RPC evidence, AP Biology** (final allowed unit 8): `select_practice_frqs('targeted_drill')`
  returned 50 (**capped, true 71** via direct SQL). `select_biology_practice_items('targeted_drill')` —
  the dedicated combined FRQ+MCQ selector — returned 50 (**capped**; true eligible pool 114 = 71 FRQ +
  43 MCQ, both non-hand-drawn). `select_unit_gated_practice_items` at unit 8: FRQ 9, MCQ 14 (both
  uncapped, exactly matching the validated-label counts).
- **Live RPC evidence, AP Statistics** (final allowed unit 5): `select_practice_frqs('targeted_drill')`
  returned 49 (uncapped, matching TASK-0044's figure exactly). `select_unit_gated_practice_items` at
  unit 5: FRQ **32** (diagnosed: of the 51 validated-label FRQ, 19 are `hand_drawn` and structurally
  excluded from this RPC — 51 minus 19 equals 32, confirmed live, not a defect), MCQ 16 (uncapped,
  matches the validated-label count exactly, none hand-drawn). **Re-confirmed unchanged from
  TASK-0044: calling `select_biology_practice_items` with Statistics' own exam-pack-version ID returns
  0 rows live** — the function hard-filters `ep.exam_code = 'ap_biology'` in its own SQL, so this
  remains structurally, not intermittently, the reason no backend RPC serves AP Statistics MCQ practice
  on the flat path. Whether the Lovable-side client fallback actually serves it in the live app remains
  TASK-0043's runbook item to confirm, outside this repo's verification surface.

**Overall: both subjects Pass criteria 1/2/4/5/6; criterion 3 Partial** (expected, same TASK-0042
closeout state as the 8-subject slice above). No zero-or-low result went undiagnosed. This closes the
Biology/Statistics half of TASK-0046's required slicing — all 10 subjects now have a live-verified
six-criteria record in this doc dated 2026-09-28 or later.
