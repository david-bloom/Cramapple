# AP Statistics Launch Readiness — 2026-09-24

Measured against Production project `pcntajvbdfqhbeewmdry` by calling the live serving RPCs and
read-only census queries. No Production application data was written. One session-local temporary
table was used only to capture `qa_grade_frq` probe errors; it was transient diagnostic state, not
application data.

## The number that matters

**AP Statistics is not launch-ready.**

There are two simultaneously published AP Statistics exam-pack versions:

| exam_pack_version_id | school year | official exam date | published items | real `targeted_drill` FRQ served | real `full_exam_frq` served | real unit-gated served |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| `548f06be-ccf4-426d-b82b-b424137a4438` | 2026 | 2027-05-11 | 193 content items / 170 published item versions | **49** | **0** | **28** |
| `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` | 2026-27 | 2027-05-18 | 203 content items / 203 published item versions | **0** | **0** | **0** |

The old/general pack (`548f06be...`) is the only plausible day-one AP Statistics launch candidate
today. It can serve 49 FRQ through `public.select_practice_frqs(..., 'targeted_drill', ...)`; it
serves no `full_exam_frq`; and the unit-gated path returns 28 items.

The newer pack (`7c5a2975...`) is a course-mode Unit 1 MCQ pilot pack, not a usable general launch
pack: it has 203 MCQ, 0 FRQ, 203/203 `content_item_cells` rows, 0 current serving labels, and 0 rows
from every measured serving RPC. Despite that, it is `status='published'` and `retired_at is null`,
so it remains selectable by the same database gate as the old pack.

## P0 finding — dual published AP Statistics versions route users to dead content

This is the first launch blocker to fix.

Production state:

- `548f06be-ccf4-426d-b82b-b424137a4438` — published, released 2026-07-01, 193 published content
  items, 49 targeted-drill FRQ served.
- `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` — published, released 2026-08-26, 203 published content
  items, 0 targeted-drill FRQ served.

The two packs do not share content keys: 0 shared keys, 203 new-only keys, 193 old-only keys. The
new keys use the course-mode style namespace, for example `apstat-4b-compare-097000`; the old pack
uses the general AP Stats namespace, for example `APSTATS-SFRQ-*`, `APSTATS-MCQ-*`,
`APSTAT-MOD*`, and `apstats-frq-u12-*`.

The newer pack was not a content refresh of the old pack. Local course-mode handoff docs identify
`7c5a2975...` as the pilot pack with 203 Unit-1 MCQ, while `548f06be...` is the general pack. Live
data confirms that diagnosis:

- `7c5a2975...`: 203 MCQ, 0 FRQ.
- `7c5a2975...`: 203/203 items have `content_item_cells` rows.
- `7c5a2975...`: 0 current `label_scope='serving'` rows.
- `app.servable_items_census()` reports `items_with_no_serving_label = 203`.

### Real sessions affected

Production session history shows the issue was not hypothetical:

| pack | sessions | distinct users | range | practice formats |
| --- | ---: | ---: | --- | --- |
| old/general `548f06be...` | 49 | 2 | 2026-07-09 → 2026-09-24 | 17 null, 32 `targeted_drill` |
| new/pilot `7c5a2975...` | 51 | 2 | 2026-08-27 → 2026-09-23 | 51 `targeted_drill` |

For the 51 sessions against the new/pilot pack, `app.session_target_items` has 0 rows and 0 sessions
with assigned items. The affected accounts were:

- David admin profile: 50 sessions, profile still pointed at `7c5a2975...`.
- One QA test student: 1 completed session on 2026-09-23; that test profile is now pointed at
  `548f06be...`.

### Same failure class as Biology FF-15

This is the same empty-queue failure class Biology FF-15 fixed. The code path is subject-wide, not
Biology-scoped: `supabase/functions/student-session-items/index.ts` now returns
`result.reason = "no_matching_content"` when a selector RPC returns no rows, and
`"all_items_omitted"` when candidates are all withheld after media/answerability gates.

The historical AP Stats sessions mostly predate that FF-15 fix landing on 2026-09-24, so earlier
empty queues would have looked like successful empty responses. Going forward, the empty new/pilot
pack should at least report a reason; that does not make it launch-ready.

### Recommended fix

**Retire or otherwise make `7c5a2975...` non-selectable for general AP Statistics immediately, then
use `548f06be...` as the only selectable AP Statistics pack until the pilot pack has an explicit
serving path and launch decision.**

I do not recommend trying to "finish labels" on `7c5a2975...` as the immediate fix. That pack is
MCQ-only course-mode pilot content, not the general AP Statistics launch corpus; labeling it would
not create FRQ practice and would still leave `select_practice_frqs` at 0. If the course-mode pilot
needs to continue, it should be gated by a pilot-specific selector/manifest or profile assignment,
not by keeping it generally selectable as a published AP Statistics pack.

## Condition-by-condition readiness

| # | Condition / launch fact | Status | Evidence |
| --- | --- | --- | --- |
| 0 | Exactly one selectable AP Stats pack routes students to content | **Not met — P0** | Two versions are published; one serves 0 items and has real session history. |
| 1 | Real servable item counts | **Partially met only on old/general pack** | Old/general: 49 targeted-drill FRQ, 0 full-exam FRQ, 28 unit-gated. New/pilot: 0 everywhere. |
| 2 | Canonical answers and segmentation spans | **Not met** | Old/general current published FRQ versions: 34/69 have `canonical_answer_1`; 0/69 have `app.canonical_answer_spans`. |
| 3 | Difficulty values | **Not met** | `app.content_item_difficulty`: 0 rows for both AP Stats packs. |
| 4 | Serving-label coverage/status distribution | **Not met on both packs** | Old/general: 178 current serving labels across 193 content items; status counts 105 legacy, 65 validated, 6 held, 2 stale. New/pilot: 0 serving labels for 203 items. |
| 5 | TASK-0022 multi-point rubric defect | **Not met** | Old/general current published FRQ versions: 13 text FRQ have multi-point criteria; 21 text FRQ still all-1pt; 20 spatial/human-shadow FRQ also all-1pt. |
| 6 | DECISION-0052 grader-gate reachability | **Not met** | 3 AP Stats FRQ × 3 runs reached `evaluate-attempt` but all returned HTTP 409 `qa_path_ap_biology_only`. |
| 7 | MCQ answer-key/rationale grant safety | **Met for student-facing reads** | `authenticated` SELECT grants exist on `choice_key`/`choice_text`; no SELECT grants surfaced for `app.mcq_choices.is_correct` or `app.mcq_choices.rationale`; `public.mcq_choices` has no answer-key/rationale columns. |

## Detail by condition

### 1 — Real serving counts

I called the live selectors; these are not modeled counts.

Practice path:

- `public.select_practice_frqs('548f06be...', 'targeted_drill', 999)` → 49.
- `public.select_practice_frqs('548f06be...', 'full_exam_frq', 999)` → 0.
- `public.select_practice_frqs('7c5a2975...', 'targeted_drill', 999)` → 0.
- `public.select_practice_frqs('7c5a2975...', 'full_exam_frq', 999)` → 0.

Standing census:

- old/general `548f06be...`: `unit_gated_servable = 28`, `practice_targeted_drill = 49`,
  `practice_full_exam_frq = 0`.
- new/pilot `7c5a2975...`: all three are 0.

### 2 — Canonical answer coverage and segmentation

For the old/general pack's current published FRQ versions:

- 69 current published FRQ versions.
- 34 have non-empty `canonical_answer_1`.
- 0 have `app.canonical_answer_spans` rows.

This must not be conflated with the 84 `content_items` marked `published` as FRQ in the old pack.
The standing census reports 23 old-pack items whose latest version is not published; launch
measurement should use current published versions, because those are what grading/serving can act on.

### 3 — Difficulty

`app.content_item_difficulty` has 0 rows for AP Statistics current published item versions in either
pack. The table shape already supports a future AP Stats load (`difficulty`, `basis`,
`attainment_ratio`, `subject_cut_points`, etc.), but no AP Stats difficulty proposal has been loaded.

### 4 — Serving labels

Old/general pack current serving labels:

| label_status | rows |
| --- | ---: |
| `legacy_unvalidated` | 105 |
| `validated` | 65 |
| `held` | 6 |
| `stale` | 2 |

The standing census reports 15 old/general items with no serving label and 6 serving-label hash
mismatches.

New/pilot pack:

- 0 serving labels.
- 203 items with no serving label.

### 5 — TASK-0022 remaining scope

The task doc says the pilot + pass 2 fixed published discrete-text scope, while spatial items and
reviewed-approved backlog remained open. Live Production partly confirms the progress but changes
the launch framing:

- Current published FRQ versions in the old/general pack: 69.
- FRQ versions with criteria: 69.
- Any criterion >1 point: 13.
- All criteria exactly 1 point: 56.
- Spatial/human-shadow FRQ: 20, all still 1-point.
- Non-spatial text FRQ still all-1pt: 21.
- Non-spatial text FRQ with multi-point criteria: 13.

So TASK-0022 is still open for launch reporting. The pass-2 fix did land real multi-point criteria
on 13 text FRQ, but a meaningful all-1pt text remainder still exists, and spatial/human-shadow scope
is still unresolved by design.

### 6 — DECISION-0052 grader-gate reachability

I probed three AP Stats FRQ with `canonical_answer_1`, three runs each, using their stored canonical
answer text as the response:

- `APSTATS-SFRQ-001`
- `APSTATS-SFRQ-002`
- `APSTATS-SFRQ-011`

All 9 runs failed the same way:

```text
qa_grade_frq: evaluate-attempt returned HTTP 409: {"error":"qa_path_ap_biology_only"}
```

That means the QA grader gate is still Biology-only. This is a clearer blocker than a bad grading
score: AP Statistics FRQ with canonicals cannot be measured through the DECISION-0052 QA bridge at
all today.

### 7 — MCQ answer-key/rationale grants

AP Stats MCQ rows are present in the student-facing `public.mcq_choices` projection: 1,296 rows for
the two AP Stats packs. That projection contains `choice_key` and `choice_text`, but not
`is_correct` or `rationale`.

The underlying `app.mcq_choices` table does contain `is_correct` and `rationale`. Column grants show
`authenticated` can SELECT `choice_key` and `choice_text`; no SELECT grant surfaced for
`is_correct` or `rationale`. This matches the Biology FF-13 safety posture and appears table-wide,
not Biology-scoped.

## What launch actually needs, in order

1. **Resolve the dual-published-pack P0.** Retire or otherwise make `7c5a2975...` non-selectable for
   general AP Statistics. Keep `548f06be...` as the only general AP Stats candidate until a deliberate
   pilot/general split is implemented.
2. **Decide the day-one AP Stats serving path.** If it is practice FRQ, the old/general pack can
   serve 49 targeted-drill FRQ and 0 full-exam FRQ. If day one needs MCQ or course-mode unit gating,
   the current measured RPCs are not sufficient.
3. **Open the QA grader bridge to AP Statistics.** `qa_grade_frq` currently returns
   `qa_path_ap_biology_only` for AP Stats, so the DECISION-0052 style multi-run baseline cannot be
   collected.
4. **Canonical-answer and segmentation work.** Old/general pack has only 34/69 current FRQ with
   `canonical_answer_1` and 0/69 with canonical spans.
5. **Difficulty load.** AP Stats has 0 difficulty rows.
6. **Finish or explicitly scope TASK-0022.** At minimum, separate text-FRQ all-1pt remainder from
   spatial/human-shadow items and decide what launch requires.
7. **Serving-label cleanup if using unit-gated path.** Old/general has only 65 validated serving
   labels and 28 unit-gated servable items; new/pilot has none.

## Method note

The critical counts in this report were measured against live Production. The serving numbers came
from the real RPCs and the standing `app.servable_items_census()` function, not from a hand-modeled
predicate. The conclusion is intentionally conservative: AP Statistics has some servable FRQ on the
old/general pack, but the currently published pack state is unsafe for launch because a published,
selectable, MCQ-only pilot pack has already produced real empty sessions.
