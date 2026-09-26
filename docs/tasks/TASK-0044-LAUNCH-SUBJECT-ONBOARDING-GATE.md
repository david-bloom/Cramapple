# TASK-0044 — Launch: October 2 Flat-Path Gate (AP Biology + AP Statistics)

**Task ID:** TASK-0044
**Title:** Subject Onboarding Gate — October 2, 2026 Flat-Path Gate for Day-1 Subjects Only
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Not Started
**Priority:** High — Day-1 subjects gate the October 2 launch directly
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — assign per R1 (`<agent>/task-0044-<slug>`) when an agent starts execution
**PR:** None yet

## Codex QA note (2026-09-26, pre-execution review)

Codex reviewed this task record before any work started and returned **Fail — revision required**.
Findings folded into this revision: date corrected to October 2, 2026; **narrowed to a flat-path gate
for AP Biology and AP Statistics only** — the complete six-criteria/unit-gated gate across all 10
subjects is moved to **TASK-0046**, a separate post-launch task; reconciled with
`docs/product/LAUNCH_RUNBOOK_2026_10_02.md` (this task's Biology/Statistics flat-path checks map to
runbook §3–4, which TASK-0043 also covers from the student-experience side — this task covers the
content-servability side of the same two subjects). This is still a pre-execution draft — no
implementation agent has been assigned.

## Product Goal

For October 2, confirm AP Biology and AP Statistics are actually servable on their flat/practice
paths — the specific, narrow claim the launch depends on — verified against live serving RPCs, not
inferred from the content review tool's published-item count.

## Technical Scope

Primary sources: `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` §3–4 and
`docs/product/LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` — read both, including all CORRECTION
blocks, before starting.

**Day-1 launch subjects are AP Biology and AP Statistics** (`DECISION-0069`), both launching on their
flat/practice paths, unit-gating deferred for both (`DECISION-0063` for Biology, extended to Statistics
by `DECISION-0072`) — this is decided, not open. **This task checks only the criteria that matter for
the flat/practice path**, not the full six-criteria unit-gated bar:

1. Reviewed/approved (`content_items.status='published'`).
2. Rubric exists (`frq_criteria` / `mcq_choices`).
4. Canonical answer (`canonical_answer_1` or unambiguous MCQ choice).
6. Exam pack version (exactly one `published`, non-retired version per subject).

Criteria 3 (serving label) and 5 (difficulty) are **not required for the flat/practice path** and are
explicitly post-launch per the runbook — tracked under TASK-0042/TASK-0046, not this task. Both Day-1
subjects already pass criterion 6 (AP Statistics' pilot-pack hazard was resolved 2026-09-25 — do not
re-litigate it).

## Out of Scope

- The other 8 AP subjects — explicitly post-launch per the runbook; tracked under **TASK-0046**.
- Criteria 3/5 (labels/difficulty) for any subject — tracked under **TASK-0042**, post-launch.
- The full six-criteria unit-gated servability program — tracked under **TASK-0046**, post-launch.
- Deciding which subjects are in the day-one launch set (David's call, already recorded as
  `DECISION-0069`).

## Routes / Components / Systems Affected

- Live serving RPCs for the flat/practice path (confirm the exact RPC name live — the source plan notes
  `select_practice_frqs` hard-caps at 50 rows; don't misread that as a shortfall).
- `app.content_items`, `app.frq_criteria`, `app.mcq_choices`, `app.exam_pack_versions` — read-only for
  this task.
- `docs/product/SUBJECT_SERVABILITY_CRITERIA.md` — update only Biology's and Statistics' rows, criteria
  1/2/4/6 only.

## Data / Security / Integration Impact

Read-only verification against Production serving RPCs. No Production writes in this task's scope.

## Acceptance Criteria

Mirrors `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` §3–4 and
`LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`, narrowed to Biology and Statistics, flat-path
criteria only.

- [ ] AP Biology: criterion 6 confirmed live (exactly one `published`, non-retired
      `exam_pack_versions` row).
- [ ] AP Biology: criteria 1, 2, 4 verified live for the version actually being served on the
      flat/practice path.
- [ ] AP Biology: the flat/practice serving RPC called directly against Production; item count recorded
      with a diagnosed reason for any zero-or-low result.
- [ ] AP Statistics: criterion 6 confirmed live (pilot pack retired 2026-09-25 — re-verify singularity
      still holds, don't just cite the prior finding).
- [ ] AP Statistics: criteria 1, 2, 4 verified live for the version actually being served.
- [ ] AP Statistics: the flat/practice serving RPC called directly against Production for both MCQ and
      FRQ; item count recorded with a diagnosed reason for any zero-or-low result; confirm the exam-pack
      version served has the content the UI actually requests.
- [ ] Both subjects' rows in `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table updated with the
      current, cited result for criteria 1/2/4/6 only — dated, linked to evidence.
- [ ] Status reported back to `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` and
      `LAUNCH_RUNBOOK_2026_10_02.md` as Pass / Blocked (name the blocking criterion) / Not started, for
      each of the two subjects.

## QA Plan

- Manual QA: call the real flat-path serving RPCs against Production for both subjects; do not model
  expected output from reading SQL.
- Automated tests: none beyond existing serving RPC coverage.
- Regression areas: `select_practice_frqs`'s 50-row cap misdiagnosis; stale "Applied so far" table rows.
- Failure cases: reporting a subject Pass based on a stale count instead of a fresh live check; serving
  the retired unit-gated or pilot-pack path instead of the intended flat-path version.
- Security/data/integration checks: none beyond confirming read-only RPC calls hit Production correctly.
- **QA independence:** QA on this task must run in a fresh, independent context, separate from the
  agent that ran the checks.

## Approval State

**Approval Required:** Yes
**Approval Type:** Standing Approval for read-only verification of the existing, already-approved
six-criteria checklist, narrowed to two subjects and four criteria.
**Decision:** Pending — Codex reviewed this task record 2026-09-26 (Fail, revision required); this
revision folds in that feedback, including narrowing scope to a flat-path gate for the two Day-1
subjects and moving the full program to TASK-0046. Still awaiting Codex's re-review before being
finalized; execution has not started.

## Implementation Notes

**Implementation Summary:** _(To be filled by the implementation agent.)_

**Test Results:** _(To be filled by the implementation agent — live RPC call results for both
subjects.)_

**Risks / Issues:** _(To be filled by the implementation agent.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail) — must come from a fresh, independent QA context.

**QA Result:** _(To be filled by the QA agent.)_

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD

Only the Main Conductor may set this task's status to `Done`, after integrating the QA Agent's
recommended verdict and verifying evidence.
