# QA Report — Readiness Audit: Work Orders & Live Selectors (2026-09-25)

**Scope:** Read-only audit of nine AP subjects against `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`, plus review of the named Codex work orders and live selector behavior.

**Production:** `pcntajvbdfqhbeewmdry`

**Base:** `main` at `b02130daa56ae035e598f985f89ab1a5583c997c`

**No Production writes were made.** No work order was executed or edited by this audit.

## Executive summary

The broad readiness model is still valid: rubric/answer-key structure is clean across all nine subjects, difficulty rows remain absent, and Statistics remains the only subject with more than one published, non-retired exam-pack version.

The audit found four classes of follow-up:

1. **P0 — AP Statistics still has a live dual-pack routing hazard.** The old/general pack serves content; the newer pilot pack remains published/selectable but returns zero from every measured serving selector.
2. **P1 — several work orders are stale on criterion 4 after the morning canonical-answer writes.** They must skip/rebaseline their canonical-authoring sections before execution to avoid duplicate work.
3. **P1 — the older Physics C: Mechanics relabel baseline is materially stale.** Its published-corpus scope is substantially larger than current Production state and should be remeasured before a relabel run.
4. **P2 — several count/status baselines have drifted or contain internal inconsistencies.** These do not invalidate the underlying work but should be refreshed before execution/reporting.

A separate branch-state issue exists: the AP Statistics and AP Physics 1 readiness-measurement branches already contain durable measurement results, but neither has a PR to `main`. Treat those measurements as executed-but-unintegrated, not “not yet executed.”

## Severity scale

| Severity | Meaning |
| --- | --- |
| P0 | Live serving/routing risk or correctness issue that can directly affect students |
| P1 | Work order is not safe to run as written, or would materially duplicate/mis-scope work |
| P2 | Documentation/count drift that should be corrected but does not invalidate the main workflow |

## A. Fresh six-criterion census

The table below uses the published `content_items` corpus and each item's latest version for the item-level baseline. Real selector behavior is reported separately in section B because selector semantics are not identical to a simple latest-version count.

| Subject / pack | Published items | FRQ / MCQ | FRQ latest canonicals | Validated serving labels | Nonvalidated / no validated | Difficulty rows | Latest version published / not published | Pack singular? |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| AP Calculus AB | 124 | 62 / 62 | 62 / 62 | 9 | 115 | 0 | 122 / 2 | Yes |
| AP Calculus BC | 129 | 65 / 64 | 36 / 65 | 4 | 125 | 0 | 127 / 2 | Yes |
| AP Chemistry | 123 | 53 / 70 | 53 / 53 | 45 | 78 | 0 | 119 / 4 | Yes |
| AP Physics 1 | 124 | 61 / 63 | 61 / 61 | 9 | 115 | 0 | 117 / 7 | Yes |
| AP Physics 2 | 79 | 37 / 42 | 37 / 37 | 10 | 69 | 0 | 68 / 11 | Yes |
| AP Physics C: Mechanics | 84 | 42 / 42 | 42 / 42 | 4 | 80 | 0 | 77 / 7 | Yes |
| AP Physics C: E&M | 103 | 55 / 48 | 55 / 55 | 6 | 97 | 0 | 97 / 6 | Yes |
| AP Precalculus | 120 | 65 / 55 | 33 / 65 | 30 | 90 | 0 | 117 / 3 | Yes |
| AP Statistics — old/general | 193 | 84 / 109 | 83 / 84 latest | 64 | 129 | 0 | 170 / 23 | **No — subject has two published packs** |
| AP Statistics — pilot | 203 | 0 / 203 | n/a | 0 | 203 | 0 | 203 / 0 | **No — subject has two published packs** |

### Criterion 2 structural check

Across every published item in the nine-subject scope:

- every published FRQ's latest version has at least one `frq_criteria` row;
- every published MCQ's latest version has exactly one `is_correct=true` choice.

No criterion-2 structural gap was found in this audit.

### Label-status details relevant to work-order baselines

Current item-level label state:

- **Calc AB:** 9 validated, 6 provisional_model, 16 held, 17 stale, 43 legacy_unvalidated, 33 with no current serving label.
- **Calc BC:** 4 validated, 17 provisional_model, 15 held, 4 stale, 39 legacy_unvalidated, 50 with no current serving label.
- **Chemistry:** 45 validated, 2 provisional_model, 32 held, 31 stale, 13 legacy_unvalidated, 0 with no current serving label.
- **Physics 1:** 9 validated, 8 held, 2 stale, 71 legacy_unvalidated, 34 with no current serving label.
- **Physics 2:** 10 validated, 4 held, 2 stale, 63 legacy_unvalidated.
- **Physics C: Mechanics:** 4 validated, 4 held, 2 stale, 74 legacy_unvalidated.
- **Physics C: E&M:** 6 validated, 1 held, 1 stale, 78 legacy_unvalidated, 17 with no current serving label.
- **Precalculus:** 30 validated, 33 provisional_model, 10 held, 4 stale, 23 legacy_unvalidated, 20 with no current serving label.
- **Statistics old/general:** 64 validated, 6 held, 3 stale, 105 legacy_unvalidated, 15 with no current serving label.
- **Statistics pilot:** no current serving labels on all 203 items.

## B. Real selector validation

The real selector functions were called against Production. `select_practice_frqs` hard-caps an individual call at 50 rows; where the standing census reports 51 eligible items, the call itself correctly returns 50.

| Subject / pack | targeted_drill call | full_exam_frq call | unit-gated call at top released unit |
| --- | ---: | ---: | ---: |
| AP Calculus AB | 44 | 18 | 7 |
| AP Calculus BC | 43 | 21 | 4 |
| AP Chemistry | **50** (standing census eligible pool: 51) | 0 | 42 |
| AP Physics 1 | **50** (standing census eligible pool: 51) | 3 | 7 |
| AP Physics 2 | 25 | 3 | 2 |
| AP Physics C: Mechanics | 33 | 3 | 0 |
| AP Physics C: E&M | 45 | 4 | 1 |
| AP Precalculus | 44 | 20 | 27 |
| AP Statistics — old/general | 49 | 0 | 27 |
| AP Statistics — pilot | **0** | **0** | **0** |

### P0 — Statistics pilot remains a dead selectable pack

Platform-wide singularity scan found only one exam code with more than one `status='published'`, `retired_at is null` version: **AP Statistics**.

The newer Statistics pilot pack `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` remains published and non-retired, has 203 published MCQs, has zero serving labels, and returns zero from all three measured serving paths. The older/general pack `548f06be-ccf4-426d-b82b-b424137a4438` continues to serve 49 targeted-drill FRQs and 27 unit-gated items.

This confirms the existing highest-priority Statistics finding. The audit did not retire or otherwise alter either pack.

### Small but real Statistics drift

The prior Statistics readiness report recorded 28 unit-gated items and 65 validated serving labels. Current Production reports 27 unit-gated items and 64 validated labels in the standing census. This should be refreshed in any report used for a current launch decision.

## C. Work-order runnability

| Work order | Current verdict | Required change before run |
| --- | --- | --- |
| AP Calculus BC launch readiness | **Runnable after normal remeasure** | Baseline remains materially accurate: 29 missing canonicals, 4 validated / 125 nonvalidated, 0 difficulty. Check the pre-existing relabel work first as instructed. |
| AP Precalculus launch readiness | **Runnable after normal remeasure** | Baseline remains materially accurate: 32 missing canonicals, 30 validated / 90 nonvalidated, 0 difficulty. |
| AP Chemistry labels & difficulty | **Runnable after baseline correction** | Overall scope (78 nonvalidated, 0 difficulty) is correct, but the written label-status breakdown is internally inconsistent/outdated: current legacy_unvalidated is 13, not 24. |
| AP Physics 1 launch readiness | **Partially stale — do not rerun canonical authoring** | Criterion 4 is now closed for the published corpus. Skip/rewrite canonical Parts 1–2; labels/difficulty remain open. |
| AP Physics 2 launch readiness | **Partially stale — do not rerun canonical authoring** | Criterion 4 is now closed. Remaining 69 nonvalidated labels and difficulty work are still open. |
| AP Physics C: Mechanics canonicals & difficulty | **Partially stale — do not rerun canonical authoring** | Criterion 4 is now closed. Difficulty remains open; labels are handled by the separate relabel order. |
| AP Physics C: E&M launch readiness | **Partially stale — do not rerun canonical authoring** | Criterion 4 is now closed. Remaining label/difficulty work is still open. |
| AP Statistics launch-readiness measurement | **Already executed on a durable branch; not integrated** | Do not start over. Continue/integrate `codex/apstats-launch-readiness-2026-09-24`; refresh the small count drift above. There is currently no PR. |
| Physics-C-Mech / Calc-BC relabel order | **Rebaseline before run** | Physics C: Mechanics scope is materially stale. Current published corpus has 80 nonvalidated items (74 legacy, 4 held, 2 stale), not the older ~116-item scope. Calc BC also has 50 no-label items that must be distinguished from relabeling existing rows. |

### Branch-state finding

Two readiness-measurement branches already contain durable results but have no PR:

- `codex/apstats-launch-readiness-2026-09-24` — commit `a250f4b...`, “Measure AP Statistics launch readiness”
- `codex/physics1-launch-readiness-2026-09-24` — commit `6b6ea403...`, “Measure AP Physics 1 launch readiness”

This is not evidence that the later gap-closing work orders were executed, but it does mean the measurement work itself should be treated as existing durable branch state rather than re-derived from scratch.

## D. Additional audit observations

### Selector cap is easy to misread

`public.select_practice_frqs` caps `_limit` at 50. Therefore a call with 999 returns 50 for Chemistry and Physics 1 even though the standing census finds 51 eligible targeted-drill items. Reports should distinguish “rows returned by one selector call” from “eligible pool size.”

### Schema naming

The live unit-gated selector is `public.select_unit_gated_practice_items`. Some project prose refers to `app.select_unit_gated_practice_items`; audit queries used the actual Production function.

### Calc AB label drift after content changes

The Calc AB readiness doc's earlier label distribution no longer matches Production. Current state is 9 validated / 6 provisional / 16 held / 17 stale / 43 legacy / 33 no-label. The most likely operational interpretation is that content/version changes invalidated some formerly fresher labels; this audit records the state but does not infer cause without a row-level history review.

## E. Recommended next actions

1. **Resolve the AP Statistics dual-published-pack P0 under the existing approval gate.** This audit does not choose or apply the resolution.
2. **Before running any Physics canonical work order, remove/skip the now-completed criterion-4 authoring scope.**
3. **Rebaseline the Physics C: Mechanics relabel order from current Production before execution.**
4. **Correct Chemistry's label-status breakdown while preserving its still-correct 78-item nonvalidated scope.**
5. **Integrate or explicitly supersede the durable Statistics and Physics 1 measurement branches rather than re-deriving their work.**
6. Keep live selector counts and item-level servability counts distinct in future readiness docs.

## QA verdict

**Readiness audit: FAIL / remediation required before the affected work orders are run unchanged.**

The failure is driven by the live Statistics routing hazard and by stale/mis-scoped execution instructions, not by a failure of the six-criterion framework itself. Calc BC and Precalculus remain safe to continue after their required first-step remeasure; the Physics and Chemistry orders need the targeted baseline refreshes described above.
