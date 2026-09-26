# TASK-0044 — Launch: Subject Onboarding Gate

**Task ID:** TASK-0044
**Title:** Subject Onboarding Gate — Run the Six-Criteria Servability Checklist Per Subject
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Not Started
**Priority:** High — Day-1 subjects (AP Biology, AP Statistics) gate Friday's launch directly
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — assign per R1 (`<agent>/task-0044-<slug>`) when an agent starts execution
**PR:** None yet

## Product Goal

A subject is only advertised as available to students once it has passed all six criteria in
`docs/product/SUBJECT_SERVABILITY_CRITERIA.md`, verified against live serving RPCs, not inferred from
the content review tool's published-item count. Run once per subject.

## Technical Scope

Primary source: `docs/product/LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` — read in full,
including both CORRECTION blocks, before starting.

**Day-1 launch subjects are AP Biology and AP Statistics** (`DECISION-0069`). Both already pass
criterion 6 (exam pack singularity); AP Statistics' criterion-6 hazard was resolved 2026-09-25 (pilot
pack retired) — do not re-litigate it. Both subjects launch on the flat/practice path, unit-gating
deferred (`DECISION-0063` for Biology, extended to Statistics by `DECISION-0072`) — this is decided, not
open.

The six criteria (from `SUBJECT_SERVABILITY_CRITERIA.md`, do not re-derive):

1. Reviewed/approved (`content_items.status='published'`).
2. Rubric exists (`frq_criteria` / `mcq_choices`).
3. Serving label (`label_status` adequate for the serving path in use).
4. Canonical answer (`canonical_answer_1` or unambiguous MCQ choice).
5. Difficulty value (`app.content_item_difficulty` row, band + basis populated).
6. Exam pack version (exactly one `published`, non-retired version per subject).

**This task owns criteria 1/2/4/6 updates to `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far"
table; TASK-0042 owns criteria 3/5. Check the other task's latest edit before overwriting a row.**
Criteria 3/5 for most non-Day-1 subjects are blocked on TASK-0042's pipeline run, not on this task.

## Out of Scope

Deciding which subjects are in the day-one launch set (David's call, already recorded as
`DECISION-0069`) and building the content pipeline itself (TASK-0042).

## Routes / Components / Systems Affected

- Live serving RPCs (`select_unit_gated_practice_items`, `select_practice_frqs` — note the latter
  hard-caps at 50 rows, don't misread that as a shortfall).
- `app.content_items`, `app.frq_criteria`, `app.mcq_choices`, `app.exam_pack_versions`.
- `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`.

## Data / Security / Integration Impact

None beyond calling live read RPCs and updating a shared markdown table (coordinate with TASK-0042 per
the shared-table note above).

## Acceptance Criteria

(Full detail and rationale in `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` — this list mirrors
it; that doc governs if they drift. Repeat this block per subject assigned.)

- [ ] Criterion 6 checked first, live: exactly one `published`, non-retired `exam_pack_versions` row.
- [ ] Criteria 1, 2, 4 verified live for the version actually being served.
- [ ] Criteria 3 and 5 verified live; if not met, confirm whether TASK-0042's pipeline has run for this
      subject — if not, this subject is blocked on that task, not on this one.
- [ ] The actual serving RPC(s) called directly against Production; item count recorded with a
      diagnosed reason for any zero-or-low result.
- [ ] Any model-call-based verification (grader-gate reachability, label agreement) run 3+ times before
      being trusted.
- [ ] Subject's row in `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table updated with the
      current, cited result — dated, linked to the migration/report that produced it. Correct a wrong
      earlier count visibly, don't silently overwrite it.
- [ ] Subject status reported back to `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` as Pass / Blocked
      (name the blocking criterion) / Not started.

## QA Plan

- Manual QA: call the real serving RPCs against Production per subject; do not model expected output
  from reading SQL.
- Automated tests: none beyond existing serving RPC coverage.
- Regression areas: `select_practice_frqs`'s 50-row cap misdiagnosis; stale "Applied so far" table rows.
- Failure cases: reporting a subject Pass based on a stale count instead of a fresh live check.
- Security/data/integration checks: none beyond confirming read-only RPC calls hit Production correctly.

## Approval State

**Approval Required:** Yes
**Approval Type:** Standing Approval for running the existing six-criteria checklist per subject
(already-approved mechanism).
**Decision:** Pending — this task record itself is a draft awaiting Codex's review before being
finalized; execution has not started.

## Implementation Notes

_(To be filled by the implementation agent.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail)

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD
