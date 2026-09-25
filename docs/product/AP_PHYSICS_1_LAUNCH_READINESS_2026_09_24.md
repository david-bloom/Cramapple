# AP Physics 1 Launch Readiness — 2026-09-24

Measured against Production project `pcntajvbdfqhbeewmdry` using the AP Statistics readiness work
order pattern and the fixed checklist in `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`. All
Production checks were read-only. No Production application data was written. One session-local
temporary table was used only to capture `qa_grade_frq` probe errors; it was transient diagnostic
state, not application data.

## The number that matters

**AP Physics 1 is not launch-ready under the six servability criteria.**

It does have a usable practice-FRQ path:

- `public.select_practice_frqs(..., 'targeted_drill', 999)` returns **50** rows.
- The uncapped eligible targeted-drill pool is **51** rows, but the live RPC hard-caps every call at
  50 via `limit greatest(1, least(coalesce(_limit, 20), 50))`.
- `public.select_practice_frqs(..., 'full_exam_frq', 999)` returns **3** rows.
- `public.select_unit_gated_practice_items(...)` returns **0** at Unit 1, **2** at Unit 2, **6** at
  Units 3-4, and **7** from Unit 5 onward.

The binding blockers are not item review or rubric existence. They are:

1. **Canonical-answer coverage:** only 15 of 54 current published FRQ have `canonical_answer_1`.
2. **Canonical segmentation:** 0 of 54 current published FRQ have `app.canonical_answer_spans`.
3. **Difficulty:** 0 of 117 current published item versions have `app.content_item_difficulty`.
4. **Validated serving labels:** only 7 of 117 current published item versions have a validated
   serving label, so the unit-gated path is effectively dark outside a tiny cumulative pool.
5. **FRQ QA grader bridge:** 9/9 `app.qa_grade_frq` probes failed with
   `qa_path_ap_biology_only`, so DECISION-0052 style launch evidence cannot currently be collected
   for Physics 1.

## Criterion 6 first — exam-pack version routing

Physics 1 passes the "singular published version" check.

| exam_code | exam_pack_version_id | school year | official exam date | status | retired_at | published content items |
| --- | --- | --- | --- | --- | --- | ---: |
| `ap_physics_1` | `29c719dc-701b-470f-9e49-fab981722d3f` | 2025-26 | 2027-05-05 | `published` | null | 124 |

There are no `app.learning_sessions` rows for this exam-pack version yet. One profile is currently
pointed at this version via `profiles.active_exam_pack_version_id`.

Important measurement nuance: 124 `content_items` are `published`, but only 117 have a latest/current
published version. Seven FRQ content items have latest versions with `status='retired'`:

- `apphy1-frq-002`
- `apphy1-frq-003`
- `apphy1-frq-004`
- `apphy1-frq-009`
- `apphy1-frq-013`
- `apphy1-frq-028`
- `apphy1-frq-034`

All readiness ratios below use the 117 current published item versions unless explicitly stated.

## Condition-by-condition readiness

| # | Criterion | Status | Evidence |
| --- | --- | --- | --- |
| 1 | Reviewed/approved current versions | **Mostly met, with 7 stale published content items** | 124 content items are `published`; 117 have current published versions: 54 FRQ, 63 MCQ. Seven FRQ content items' latest versions are retired. |
| 2 | Rubric / choices exist | **Met for current published versions** | 54/54 FRQ have complete `frq_criteria`; 63/63 MCQ have exactly 4 choices and exactly one correct choice. |
| 3 | Serving labels | **Not met for unit-gated serving** | 83/117 have a current serving label; only 7/117 have a validated serving label. Status rows: 88 legacy, 7 validated, 3 held, 2 stale. |
| 4 | Canonical answer | **Not met** | 15/54 FRQ have `canonical_answer_1`; 0/54 have `app.canonical_answer_spans`. MCQ correctness is structurally available via `app.mcq_choices.is_correct`. |
| 5 | Difficulty value | **Not met** | 0/117 current published item versions have `app.content_item_difficulty` rows. |
| 6 | Exam-pack version singularity | **Met** | Exactly one AP Physics 1 exam-pack version is published and not retired. |

Additional launch-gate check:

| Check | Status | Evidence |
| --- | --- | --- |
| Real practice serving | **Partially met** | 50 targeted-drill FRQ returned by the live RPC; 3 full-exam FRQ returned. |
| Real unit-gated serving | **Not launch-sufficient** | 0 at Unit 1, 2 at Unit 2, 6 at Units 3-4, 7 from Unit 5 onward. |
| FRQ grader-gate reachability | **Not met** | 3 canonical-bearing FRQ × 3 runs all failed with HTTP 409 `qa_path_ap_biology_only`. |
| MCQ answer-key grant safety | **Met for student-facing reads** | `public.mcq_choices` exposes 404 Physics 1 choice rows and has no answer-key/rationale columns; `authenticated` has SELECT on `app.mcq_choices.choice_key`/`choice_text`, with no SELECT grant surfaced for `is_correct`/`rationale`. |

## Detail by criterion

### 1 — Reviewed/approved

Physics 1 has a single published exam-pack version, with 124 `content_items.status='published'`.
However, only 117 items have a current published version:

- 54 FRQ current published versions.
- 63 MCQ current published versions.
- 7 published FRQ content items whose latest version is retired.

This is the same class of distinction called out in the subject-servability criteria: content-item
approval and version-level servability are separate facts.

### 2 — Rubric / choices

Current published versions pass the structural rubric/choice check:

- 54/54 FRQ have at least one `frq_criteria` row and those rows have positive `points_possible`,
  non-empty learner-facing text, and non-empty evidence requirements.
- 63/63 MCQ have exactly four choices and exactly one `is_correct = true`.

### 3 — Serving labels

For current published item versions:

| serving label status | current rows | distinct items |
| --- | ---: | ---: |
| `legacy_unvalidated` | 88 | 71 |
| `validated` | 7 | 7 |
| `held` | 3 | 3 |
| `stale` | 2 | 2 |

Distinct item coverage:

- 83/117 current published items have any current serving label.
- 34/117 have no current serving label.
- 7/117 have a validated serving label.

The standing census also reports:

- `serving_labels_total = 90`
- `serving_labels_validated = 9`
- `serving_label_hash_mismatch = 41`
- `items_with_no_serving_label = 34`
- `latest_version_not_published = 7`

The validated-row count differs depending on whether it is counted at content-item/current-version
level (7) or at census label-row level (9). The student-facing unit-gated selector result is the
binding outcome: at most 7 items are available after current-unit filtering reaches Unit 5.

### 4 — Canonical answer and spans

For the 54 current published FRQ versions:

- 15 have non-empty `canonical_answer_1`.
- 0 have `app.canonical_answer_spans`.

These are separate facts. Canonical-answer text is not the same as Open Hand credited-response
segmentation.

### 5 — Difficulty

`app.content_item_difficulty` has 0 rows for the 117 current published Physics 1 item versions.
The table shape supports a future load, but no Physics 1 difficulty proposal has been loaded.

### 6 — Exam-pack version

Physics 1 passes the AP Statistics P0 criterion that failed there: there is only one published,
non-retired Physics 1 exam-pack version. No dual-version routing hazard was found.

## Real serving measurements

Direct live RPC calls:

| selector | result |
| --- | ---: |
| `public.select_practice_frqs('29c719dc...', 'targeted_drill', 999)` | 50 |
| `public.select_practice_frqs('29c719dc...', 'full_exam_frq', 999)` | 3 |

The uncapped targeted-drill eligible pool is 51, but the selector caps results at 50 regardless of a
higher `_limit`.

Standing census for `ap_physics_1`:

| field | value |
| --- | ---: |
| `published_items` | 117 |
| `unit_gated_servable` | 7 |
| `practice_targeted_drill` | 51 |
| `practice_full_exam_frq` | 3 |
| `serving_labels_total` | 90 |
| `serving_labels_validated` | 9 |
| `serving_label_hash_mismatch` | 41 |
| `items_with_no_serving_label` | 34 |
| `latest_version_not_published` | 7 |

Unit-gated direct calls by current unit:

| current unit | returned rows |
| ---: | ---: |
| 1 | 0 |
| 2 | 2 |
| 3 | 6 |
| 4 | 6 |
| 5 | 7 |
| 6 | 7 |
| 7 | 7 |

## FRQ grader-gate reachability

I probed three Physics 1 FRQ that have `canonical_answer_1`, three runs each, using the stored
canonical answer text as the submitted answer:

- `apphy1-frq-014`
- `apphy1-frq-015`
- `apphy1-frq-017`

All 9 runs reached the QA bridge but failed the same way:

```text
qa_grade_frq: evaluate-attempt returned HTTP 409: {"error":"qa_path_ap_biology_only"}
```

So Physics 1 cannot currently collect the DECISION-0052 style 3-run grader baseline. This is not a
content-quality failure for those three items; it is a product gate: the QA path remains Biology-only.

## MCQ answer-key/rationale grant check

`public.mcq_choices` contains 404 Physics 1 choice rows for this exam-pack version and exposes
`choice_key`/`choice_text`, but it has no `is_correct` or `rationale` columns. The underlying
`app.mcq_choices` table does contain answer-key/rationale columns; column grants show
`authenticated` SELECT on `choice_key` and `choice_text`, and no SELECT grant surfaced for
`is_correct` or `rationale`.

This matches the table-wide FF-13 safety posture observed for Biology and Statistics.

## What launch actually needs, in order

1. **Choose the launch path.** If Physics 1 launches on the practice-FRQ path, the product can serve
   50 targeted-drill FRQ per call and 3 full-exam FRQ today. If launch requires MCQ or course-mode
   unit gating, the current live selectors are not sufficient.
2. **Open the QA grader bridge beyond Biology.** `qa_grade_frq` currently fails Physics 1 with
   `qa_path_ap_biology_only`, so the required 3-run FRQ baseline cannot be collected.
3. **Canonical-answer coverage.** Write or recover canonicals for the 39 current published FRQ that
   lack `canonical_answer_1`.
4. **Canonical segmentation.** Add `app.canonical_answer_spans` rows for all launch-scope FRQ that
   will use Open Hand/credited-response segmentation.
5. **Difficulty load.** Populate `app.content_item_difficulty` for all 117 current published item
   versions, with honest `basis` and nullable `attainment_ratio` only where justified.
6. **Serving-label cleanup if using unit-gated serving.** Only 7 current published items have a
   validated serving label; 34 have no current serving label and 41 labels are hash-mismatched in
   the standing census.
7. **Version-status cleanup.** Decide whether the 7 published content items whose latest versions
   are retired should be republished, fully retired at the content-item level, or excluded from
   launch accounting.

## Method note

This report follows `SUBJECT_SERVABILITY_CRITERIA.md`: real serving RPCs were called directly, the
exam-pack-version singularity check was done first, and canonical text was counted separately from
canonical spans. Where a model-backed grader gate was tested, it was run three times per item rather
than treated as evidence after a single run.
