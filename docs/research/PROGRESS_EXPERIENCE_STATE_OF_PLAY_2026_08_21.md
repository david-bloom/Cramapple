# /progress Experience — State of Play Before Rebuild

**Date:** 2026-08-21
**Related:** `UX-007` (Progress, Review Queue, and Recommendations),
`docs/product/PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md`,
`prompts/LOVABLE_UX007_PROGRESS_REVIEW_RECOMMENDATIONS.md`
**Purpose:** Establish the verified baseline for a new student `/progress`
experience before any design or build work is scoped.
**Status:** Findings only. No design approved, no implementation authorized.

## Evidence classes used

- **Live verified** — observed directly against the production Supabase project
  `pcntajvbdfqhbeewmdry` on 2026-08-21.
- **Dev verified** — observed against `wmgjsdkphcyhngaffbqf` on 2026-08-21.
- **Repository only** — read from source in
  `/Users/davidbloom/Documents/exam-buddy-wireframe` (Lovable frontend) at
  `320ea3f`; not exercised at runtime in this pass.

---

## 1. What `/progress` renders today

**Repository only.** `src/routes/_ux.progress.tsx` (146 lines) is entirely
fixture-driven. Every number and label on the page comes from
`getReturningCase()` in `src/lib/returning-context.ts`, selected by a `?case=`
search param. It reads no student data of any kind — no Supabase call, no
server function, no auth-scoped query.

The page has three sections: content coverage by unit, point-capture skill
trend, and a review-rhythm list. The two-axis framing (coverage and
point capture never combined into one score) is a real product decision worth
carrying forward. The data behind it is not real.

`src/lib/progress-queries.ts` exists and does query Supabase, but is aimed at
the wrong tables (see §3.3). It is not imported by `_ux.progress.tsx`.

## 2. What UX-007 already specifies

**Repository only.** `UX-007` is *In Progress* with 11 of 13 acceptance
criteria checked. Design documentation and the Lovable brief are approved;
**implementation is explicitly pending** and the task states "No prototype is
authorized by this task." The two open criteria are the Learning Quality /
accessibility / privacy / security / marketing review, and Product Owner
approval of the final UX.

`PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md` (376 lines) defines the evidence
vocabulary the page must use — supported success, independent success now,
review due, mixed evidence, withheld — plus recommendation provenance,
learner overrides, and dispute handling. That vocabulary is the strongest
existing asset and should constrain the rebuild rather than be re-derived.

## 3. What the data can actually support

### 3.1 The home snapshot contract is sound; its data loader is not

**Repository only.** `src/lib/home-snapshot.ts` (335 lines) is a well-formed,
tested evidence contract: qualifying-attempt rules, separated recommend
(>=3 attempts / >=2 items) and trend (>=5 attempts / >=2 sessions) thresholds,
per-unit point capture with a minimum-sample floor, repair improvement
reported separately from cold capture, and exam-date resolution. A new
`/progress` should extend this module, not invent a parallel one.

`src/lib/home.functions.ts` — the server function that feeds it — does not
supply the fields the contract needs. It hardcodes `unitId: null`,
`pointsEarned: null`, `pointsAvailable: null`, `attemptCondition:
"independent"`, `isRetry: false`, `lastAttempt: null`, and `stats: []`.
Consequently `computeUnitPointCapture` can never return a value, every unit
renders as `available`/`start_here`, and no trend can ever be claimed.

### 3.2 Two column/table mismatches in that loader

**Live verified.** Both are silent failures — neither query's error is
checked, so each degrades to an empty result rather than surfacing.

| Loader query | Production reality |
| --- | --- |
| `attempts.select("... mcq_item_id, frq_package_id ...")` | Neither column exists on `public.attempts`. |
| `.from("student_course_position")` | Table does not exist; the real table is `student_course_positions` (plural). |

The practical effect is that in production the attempt list resolves empty,
`summarizeEvidence` sees zero qualifying attempts, and **every student is
classified `experienceStage: "new"` regardless of actual history**. Course
position is likewise always `unknown`. This is a pre-existing `/home` defect
surfaced while scoping `/progress`; it is not caused by this work.

### 3.3 Graded evidence exists — on a different table than the code reads

**Live verified**, production:

| Table | Rows | Note |
| --- | --- | --- |
| `attempts` | 44 | `graded_at` null on all 44; `score_points` null on all 44 |
| `grading_results` | 41 | 32 `graded`, 9 `uncertain`; points populated on all 41 |
| `attempt_criterion_results` | 0 | criterion-level table never written |
| `progress_snapshots` | 0 | never written |
| `student_lock_queue` | 0 | no retrieval scheduling data at all |
| `learning_sessions` | 26 | live session table (`user_id`) |
| `sessions` | 0 | legacy table (`student_id`); `progress-queries.ts` targets this one |

**Dev verified**: same shape — 8 attempts, 0 graded, 20 `grading_results`,
0 `attempt_criterion_results`, 0 `student_lock_queue`, 0 `progress_snapshots`.

So per-item points, `points_available`, confidence, `highest_value_gap`, and
`repair_hint` are all recoverable **from `grading_results`**. Criterion-level
detail, review scheduling, and stored snapshots are not recoverable at all
today, because nothing writes those tables.

### 3.4 Unit attribution is sparse, and absent for the flagship subject

**Live verified.** `content_items` and `content_item_versions` carry no unit
or topic column. The only unit link is `content_item_labels` with
`label_type = 'unit'` (30 labels, 574 label rows):

| Subject | Items | Items with a unit label |
| --- | --- | --- |
| ap-statistics | 296 | 200 |
| biology | 257 | **0** |
| ap-physics-1 | 148 | 0 |
| ap-chemistry | 136 | 0 |
| ap-calculus-bc | 128 | 37 |
| ap-precalculus | 126 | 36 |
| ap-calculus-ab | 124 | 35 |
| ap-physics-c-em | 120 | 0 |
| ap-physics-c-mechanics | 100 | 0 |
| ap-physics-2 | 100 | 0 |

A unit-by-unit "content coverage" section — the first section of today's
`/progress` — is therefore honestly renderable only for AP Statistics, and
partially for the three math subjects. For Biology, Chemistry, and all four
Physics subjects it would show nothing, or worse, invent structure.

### 3.5 There are no real students to serve yet

**Live verified.** `attempts` spans 2 distinct `user_id` values, consistent
with the standing finding that production has zero real students and all
attempts trace to pilot or owner accounts. `/progress` correctness therefore
has to be established by construction and QA, not by production traffic.

---

## 4. Implications for the rebuild

1. The blocking constraint is not design — UX-007 already supplies the
   vocabulary and section list. It is that the evidence pipeline
   (`attempts` grading write-back, criterion results, unit labels, review
   scheduling) does not populate.
2. `grading_results` is the only table that can carry a real `/progress`
   today. Any first slice should read it directly rather than wait on
   `attempts` write-back.
3. Per-unit coverage cannot ship for all subjects at once without either
   backfilling unit labels or degrading honestly per subject.
4. A review queue / "due for retrieval" section cannot ship at all until
   something writes `student_lock_queue`.
5. Fixing the two `/home` loader mismatches in §3.2 is a prerequisite, not
   optional cleanup — `/progress` and `/home` must not disagree about whether
   a student has evidence.

## 5. Not established by this pass

- Whether the `/progress` route is reachable in production and under what
  auth (no runtime check was performed).
- Whether `HomeV2` is flag-enabled in production.
- Which component writes `grading_results` and why it never writes back to
  `attempts` — the write path was not traced.
- Whether unit labels for the unlabeled subjects can be derived from
  `content_key` patterns.
