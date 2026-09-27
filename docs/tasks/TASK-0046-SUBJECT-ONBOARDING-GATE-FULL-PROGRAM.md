# TASK-0046 — Post-Launch: Full Six-Criteria Subject Onboarding Gate (All Subjects)

**Task ID:** TASK-0046
**Title:** Subject Onboarding Gate — Complete Six-Criteria/Unit-Gated Program, All 10 Subjects
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Not Started
**Priority:** Medium — post-launch; not required for the October 2, 2026 launch decision
**Created Date:** 2026-09-26
**Approved Date:** Pending
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
**Decision:** Pending — this task record was created 2026-09-26 as a split from TASK-0044 per Codex's
review; not yet reviewed on its own. Execution has not started and is not required before the October 2
launch decision.

## Implementation Notes

**Implementation Summary:** _(Per-slice — to be filled by each slice's implementation agent.)_

**Test Results:** _(Per-slice — live RPC call results.)_

**Risks / Issues:** _(Per-slice.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail) — per slice, from a fresh, independent QA context.

**QA Result:** _(Per-slice — to be filled by the QA agent.)_

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD

This umbrella task is Done only once every subject slice it spawned is Done or explicitly descoped.
Only the Main Conductor may set a slice's status to `Done`.
