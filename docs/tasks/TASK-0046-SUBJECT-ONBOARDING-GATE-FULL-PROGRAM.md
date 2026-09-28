# TASK-0046 — Post-Launch: Full Six-Criteria Subject Onboarding Gate (All Subjects)

**Task ID:** TASK-0046
**Title:** Subject Onboarding Gate — Complete Six-Criteria/Unit-Gated Program, All 10 Subjects
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Done — all 9 slices live-verified and independently QA-passed by Codex, approved by David Bloom, 2026-09-28
**Priority:** Medium — post-launch; not required for the October 2, 2026 launch decision
**Created Date:** 2026-09-26
**Approved Date:** 2026-09-28 (`APPROVAL-0057`)
**Branch:** Not yet created — see "Required slicing" below before any branch is assigned
**PR:** None yet

## Origin

Split out of TASK-0044 per Codex's 2026-09-26 pre-execution review: TASK-0044 is narrowed to an
October 2 flat-path gate for AP Biology and AP Statistics only (criteria 1/2/4/6); this task carries the
complete six-criteria/unit-gated program across all 10 subjects, which is post-launch work.

## Product Goal

A subject is only advertised as available for **unit-gated** practice once it has passed all six
criteria in `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`, verified against live serving RPCs. Run
once per subject, for every subject beyond the two Day-1 flat-path subjects TASK-0044 already covers.

## Technical Scope

Primary source: `docs/product/LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` — read in full,
including both CORRECTION blocks, before starting.

The six criteria (from `SUBJECT_SERVABILITY_CRITERIA.md`, do not re-derive):

1. Reviewed/approved (`content_items.status='published'`).
2. Rubric exists (`frq_criteria` / `mcq_choices`).
3. Serving label (`label_status` adequate for the serving path in use) — depends on TASK-0042.
4. Canonical answer (`canonical_answer_1` or unambiguous MCQ choice).
5. Difficulty value (`app.content_item_difficulty` row, band + basis populated) — depends on TASK-0042.
6. Exam pack version (exactly one `published`, non-retired version per subject).

**This task owns criteria 1/2/4/6 updates to `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far"
table; TASK-0042 owns criteria 3/5. Check the other task's latest edit before overwriting a row.**
Criteria 3/5 for every subject are blocked on TASK-0042's per-subject pipeline slices, not on this task.

Current per-subject status (verify fresh before closing any subject — see source plan's table for the
2026-09-25 snapshot): AP Biology and AP Statistics already covered for their flat-path launch by
TASK-0044; this task's scope is (a) the remaining 8 subjects' full six criteria, and (b) Biology's and
Statistics' criteria 3/5 for when unit-gated practice is eventually turned on.

## Required slicing

Like TASK-0042, do not assign this as one program-sized unit. Split per subject before assignment, each
independently reviewable:

- The 8 non-Day-1 subjects (Calc AB, Calc BC, Chemistry, Physics 1, Physics 2, Physics C Mechanics,
  Physics C E&M, Precalculus) each need all six criteria checked.
- Biology and Statistics need only criteria 3/5 checked for this task's purposes (1/2/4/6 already
  covered by TASK-0044) — coordinate timing with TASK-0042's slices for those two subjects.

## Out of Scope

The October 2 launch decision itself (TASK-0044 covers what's actually needed for that). Building the
content pipeline (TASK-0042).

## Routes / Components / Systems Affected

- Live serving RPCs (`select_unit_gated_practice_items`, `select_practice_frqs`).
- `app.content_items`, `app.frq_criteria`, `app.mcq_choices`, `app.exam_pack_versions` — read-only.
- `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`.

## Data / Security / Integration Impact

Read-only verification against live RPCs plus shared-table updates coordinated with TASK-0042. No
independent Production writes in this task's own scope.

## Acceptance Criteria

(Repeat per subject slice.)

- [ ] Criterion 6 checked first, live: exactly one `published`, non-retired `exam_pack_versions` row.
- [ ] Criteria 1, 2, 4 verified live for the version actually being served.
- [ ] Criteria 3 and 5 verified live; if not met, confirm whether TASK-0042's pipeline slice has run for
      this subject — if not, this subject is blocked on that task's slice, not on this one.
- [ ] The actual unit-gated serving RPC(s) called directly against Production; item count recorded with
      a diagnosed reason for any zero-or-low result.
- [ ] Any model-call-based verification run 3+ times before being trusted.
- [ ] Subject's row in `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table updated with the
      current, cited result — dated, linked to evidence.
- [ ] Subject status reported back to `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` as Pass / Blocked
      (name the blocking criterion) / Not started.

## QA Plan

- Manual QA: call the real serving RPCs against Production per subject.
- Automated tests: none beyond existing serving RPC coverage.
- Regression areas: `select_practice_frqs`'s 50-row cap misdiagnosis; stale "Applied so far" table rows.
- Failure cases: reporting a subject Pass based on a stale count instead of a fresh live check.
- Security/data/integration checks: none beyond confirming read-only RPC calls hit Production correctly.
- **QA independence:** QA on each slice must run in a fresh, independent context.

## Approval State

**Approval Required:** Yes
**Approval Type:** Standing Approval for read-only verification of the existing six-criteria checklist,
per subject slice.
**Decision:** Approved under `APPROVAL-0057` on 2026-09-28. Product Owner directed execution after confirming TASK-0042 is Done, in this order: Chemistry → Calculus AB → Calculus BC → Precalculus → Physics 1 → Physics 2 → Physics C E&M → Physics C Mechanics.

## Implementation Notes

**Implementation Summary (2026-09-28, 8-subject slice: Chemistry, Calc AB, Calc BC, Precalculus,
Physics 1, Physics 2, Physics C: E&M, Physics C: Mechanics):** Confirmed TASK-0042 `Status: Done`
before starting, per this task's own note that criteria 3/5 depend on it. Verified criterion 6 first
(exactly one `published`, non-retired `exam_pack_versions` row per subject — confirmed for all 10
subjects product-wide). Verified criteria 1/2/4/5 live against the current-published version for every
published item in all 8 subjects — 100% pass, no gaps found. Verified criterion 3 live
(`content_taxonomy_labels`, `label_status='validated'`, current taxonomy hash) — Partial in all 8
subjects, matching TASK-0042's documented closeout (114 evidence-backed non-promotions). Called
`public.select_unit_gated_practice_items` (at each subject's highest allowed unit) and
`public.select_practice_frqs('targeted_drill')` live against Production (`pcntajvbdfqhbeewmdry`) for
all 8 subjects — every call returned non-zero results; several hit the RPCs' known 50-row cap, so true
counts were independently confirmed via direct, un-limited SQL replicating each RPC's own filter logic
(per this doc's cap-misdiagnosis warning). Full per-subject table in
`SUBJECT_SERVABILITY_CRITERIA.md`'s 2026-09-28 TASK-0046 section.

**Biology/Statistics criteria-3/5 slice (2026-09-28, same session):** Re-confirmed criterion 6 live for
both subjects (unchanged from TASK-0044 — Statistics' pilot pack remains retired). Re-confirmed criteria
1/2/4 live (Biology: 71/71 non-hand-drawn FRQ servable, matching TASK-0044 exactly; Statistics: 69/69
FRQ, 101/101 MCQ, unchanged). Criterion 5 100% both subjects. Criterion 3: Biology FRQ 9/71, MCQ 14/43;
Statistics FRQ 51/69, MCQ 16/101. Called `select_practice_frqs`, `select_biology_practice_items`, and
`select_unit_gated_practice_items` live for both subjects — every result non-zero. Diagnosed one
apparent low result: Statistics' unit-gated FRQ RPC returned 32 against 51 validated labels — traced to
19 of those 51 being `hand_drawn` items, structurally excluded from that RPC by design, not a defect.
Re-confirmed, unchanged: calling the Biology-only combined selector with Statistics' version ID returns
0 rows live (hard-coded `ep.exam_code = 'ap_biology'` filter) — still the structural reason no backend
RPC serves Statistics MCQ on the flat path; live-app behavior remains TASK-0043's item.

**Test Results:** All 8 non-Day-1 subjects plus Biology/Statistics: criteria 1/2/4/5/6 Pass at 100%
(criteria 1/2/4/6 for Biology/Statistics carried forward from TASK-0044, re-confirmed live here);
criterion 3 Partial everywhere (numbers per subject in the cited section); every live RPC call across
all 10 subjects returned non-zero; every capped-at-50 or apparently-low result was reconciled to a
diagnosed, non-defect cause (RPC row cap, or structural hand-drawn/subject-code exclusion).

**Risks / Issues:** None found that block this task's own scope. Criterion 3's partial coverage is
TASK-0042's decided closeout state (66 disagreements + 48 rubric/scope holds, evidence-backed), not a
live-serving defect — turning on unit-gated practice for any of these 10 subjects today would serve real
content on the validated subset. Expanding that subset is TASK-0042 scope, not this task's. Statistics'
no-backend-MCQ-selector gap on the flat path is a pre-existing, already-documented structural finding
(TASK-0044), not new to this task.

## QA Review

**QA Verdict:** Pass — independent QA run by Codex, 2026-09-28, satisfying this task's QA-independence
requirement (fresh, separate context from the implementing agent).

**QA Result (Codex, as relayed by David Bloom, 2026-09-28):** "For every subject, Production currently
has exactly one published/non-retired exam-pack version. Every current-published FRQ has both a
canonical answer and valid rubric; every current MCQ/quantitative item has exactly one correct answer;
and difficulty coverage is complete. TASK-0042's validated-label work is live, and every subject now has
a real nonzero unit-gated serving pool." This independently confirms criteria 1/2/4/5/6 across all 10
subjects and the non-zero unit-gated serving result this task's own implementation notes report — no
discrepancy between the implementer's and QA's live-Production findings.

**Reconciliation note (2026-09-28):** A concurrent Codex session independently ran the same TASK-0046
verification and merged its own per-subject records (`TASK-0046-CHEMISTRY-VERIFY.md` and similar,
`APPROVAL-0057`, PRs #237–247) ahead of this branch. Its per-subject unit-gated pool counts match this
branch's findings exactly (Chemistry 65, Biology 23, Statistics 48 — sum of this branch's FRQ+MCQ
figures in each case), cross-validating both independent live-Production runs. This branch's
`SUBJECT_SERVABILITY_CRITERIA.md` section remains the consolidated, single-table record; the
per-subject `*-VERIFY.md` files are the other session's per-slice evidence trail for the same result.

## Done Decision

**Decision:** Done — approved by David Bloom (Product Owner), 2026-09-28, on Codex's independent QA
Pass.
**Date:** 2026-09-28

This umbrella task is Done only once every subject slice it spawned is Done or explicitly descoped.
Only the Main Conductor may set a slice's status to `Done`. All 9 slices (8 non-Day-1 subjects plus the
Biology/Statistics criteria-3/5 slice) are complete and QA-passed as of this date.
