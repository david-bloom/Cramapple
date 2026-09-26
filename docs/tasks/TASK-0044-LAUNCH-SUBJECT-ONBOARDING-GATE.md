# TASK-0044 — Launch: October 2 Flat-Path Gate (AP Biology + AP Statistics)

**Task ID:** TASK-0044
**Title:** Subject Onboarding Gate — October 2, 2026 Flat-Path Gate for Day-1 Subjects Only
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Implementation Complete in Development — Production Approval Pending
**Priority:** High — Day-1 subjects gate the October 2 launch directly
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** `codex/task-0044-statistics-mcq`
**PR:** None yet — not pushed/opened

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

- [x] AP Biology: criterion 6 confirmed live — exactly one `published`, non-retired
      `exam_pack_versions` row (`2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`).
- [x] AP Biology: criteria 1, 2, 4 verified live for the version actually being served on the
      flat/practice path — 71/71 servable `targeted_drill` FRQ (the 72nd is the hand-drawn item
      correctly excluded from serving) and 43/43 MCQ have a canonical answer/correct choice and a
      rubric.
- [x] AP Biology: the flat/practice serving RPC called directly against Production; `select_practice_frqs`
      returned 50 rows (limit-capped; real pool is 71), `select_biology_practice_items` returned a real
      12 FRQ / 8 MCQ mix at limit 20 — both types confirmed reachable, not modeled.
- [x] AP Statistics: criterion 6 confirmed live — re-verified singularity still holds (pilot pack
      `7c5a2975-...` remains `retired_at` set; `548f06be-...` is the sole published version).
- [x] AP Statistics: criteria 1, 2, 4 verified live — 49/49 servable (non-hand-drawn) `targeted_drill`
      FRQ have a canonical answer and rubric; 101/101 published MCQ have a correct `mcq_choices` row at
      the content level.
- [x] AP Statistics: the flat/practice serving RPC called directly against Production for FRQ —
      `select_practice_frqs` returned 49 rows, matching the content-level count exactly. **MCQ: zero
      through any backend RPC, diagnosed reason recorded — no combined FRQ+MCQ selector exists for
      AP Statistics; `select_biology_practice_items` is Biology-only by design, and
      `student-session-items`'s ordinary-mode branch always calls `select_practice_frqs` (FRQ-only)
      regardless of requested item type for every other subject. This is a backend-RPC gap, not a
      content gap — see `SUBJECT_SERVABILITY_CRITERIA.md`'s new TASK-0044 note for full detail.** The
      exam-pack version served is confirmed correct (criterion 6, above); this doesn't change the MCQ
      finding.
- [x] Both subjects' rows in `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table updated with the
      current, cited result for criteria 1/2/4/6 only — dated, linked to evidence (see the new
      "TASK-0044, 2026-09-26" note below that table).
- [x] Status reported back to `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` and
      `LAUNCH_RUNBOOK_2026_10_02.md` as Pass / Blocked (name the blocking criterion) / Not started, for
      each of the two subjects — see those docs' updated entries.

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
**Decision:** Pending — Codex's revision-required findings folded in, then executed 2026-09-26 by
Claude (read-only, Standing Approval scope, no Production writes). Awaiting fresh independent QA and
Main Conductor closure; not yet Done.

## Implementation Notes

**Implementation Summary:** Executed 2026-09-26 by Claude, read-only, against Production
(`pcntajvbdfqhbeewmdry`). Confirmed criterion 6 live for both subjects (exactly one non-retired
published exam-pack version each). Confirmed criteria 1/2/4 for AP Biology's flat-path pool (FRQ +
MCQ) fully pass, including a live call to both `select_practice_frqs` and
`select_biology_practice_items` proving both item types are actually reachable, not just eligible on
paper. Confirmed criteria 1/2/4 for AP Statistics' FRQ pool pass, with a live `select_practice_frqs`
call matching the computed count exactly. Found and diagnosed a real gap: AP Statistics MCQ content is
fully ready (101/101 with a correct choice) but **no backend RPC can serve it on the flat/practice
path** — traced to `select_biology_practice_items` being intentionally Biology-only
(`ep.exam_code = 'ap_biology'` in its own WHERE clause, by design per its migration's comment) and
`student-session-items`'s ordinary-mode branch having no other combined selector to fall back to for
any other subject. Updated `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table and added a full
evidence note; updated `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` and `LAUNCH_RUNBOOK_2026_10_02.md`
with the subject-level Pass/Blocked status. No Production writes — read-only verification only,
consistent with this task's Standing Approval scope.

**Test Results:**
- AP Biology criterion 6: 1 published, non-retired `exam_pack_versions` row — Pass.
- AP Biology criteria 1/2/4: 71/71 servable FRQ (72 published, 1 correctly excluded as hand-drawn) with
  canonical + rubric; 43/43 MCQ with correct choice — Pass.
- AP Biology live RPC calls: `select_practice_frqs(..., 'targeted_drill', 50)` → 50 rows;
  `select_biology_practice_items(...)` → 12 FRQ / 8 MCQ at limit 20 — Pass, both types reachable.
- AP Statistics criterion 6: 1 published, non-retired version (pilot pack re-confirmed retired) — Pass.
- AP Statistics criteria 1/2/4 (FRQ): 49/49 servable FRQ with canonical + rubric — Pass.
- AP Statistics live RPC call: `select_practice_frqs(...)` → 49 rows, matches exactly — Pass.
- AP Statistics criteria 1/2/4 (MCQ, content level): 101/101 with correct choice — content Pass.
- AP Statistics MCQ serving path: **Blocked** — no backend RPC serves MCQ on the flat path for this
  subject; zero is the structurally correct result of calling `select_practice_frqs` for an MCQ
  request, not a flaky failure.

**Risks / Issues:**
- **AP Statistics flat-path MCQ practice has no backend RPC serving it.** Whatever currently shows
  Statistics MCQs to students in production (if anything does) is a Lovable-side mechanism outside this
  repo's edit/verification surface — most likely the "client-side fallback... to query published items
  directly" noted in the 2026-09-24 activity log entry. **This is a launch-relevant open risk for
  October 2**: TASK-0043's runbook item 4 ("receive both the intended MCQ/FRQ experience") must verify
  this directly against the live app rather than assuming it works because the FRQ path and content are
  both confirmed ready. If the live app cannot actually serve Statistics MCQs to a real student, that is
  a stop condition per the runbook, not a criterion this task can independently fix (fixing it would
  mean building a new backend selector, a Production code change requiring its own approval, not a
  read-only verification task).
- One AP Biology item (`APBIO-HDG-2026-GRAPH-010`) is missing a canonical answer, but this is expected
  and correct — it's the hand-drawn item both serving RPCs structurally exclude, not a live gap.

## Codex MCQ-path remediation (2026-09-26)

**Implementation Summary:** Codex implemented the AP Statistics backend MCQ serving path after David
explicitly requested that TASK-0044 be unblocked. The generic ordinary combined selector now accepts
the actual authoritative Home session format (`mcq`) in addition to `targeted_drill`; MCQ mode returns
MCQs only. The selector fails closed for unpublished or retired packs, hand-drawn items, null seeds,
unsupported formats, and MCQs without a correct choice. `student-session-items` now routes AP
Statistics sessions with either `mcq` or `targeted_drill` to that selector. The response layer still
fetches only `choice_key` and `choice_text`, so `is_correct` and `rationale` never enter the learner
payload.

**Development deployment:** Applied only to Cramapple Development (`wmgjsdkphcyhngaffbqf`):
migration `task0044_stats_combined_selector_mcq_mode` and `student-session-items` version 8. No
Production migration or function deployment was made. Production remains blocked pending David's
explicit deployment approval and fresh independent QA.

**Test Results:**
- Focused handler type-check: Pass.
- Focused handler suite: 17 passed, 0 failed, including Statistics Home `mcq` routing,
  Statistics `targeted_drill` routing, answer-field redaction, missing-choice fail-closed behavior,
  and unaffected fallback paths.
- Development live selector: 20 total = 20 MCQ + 0 FRQ; 0 unanswerable; 0 hand-drawn.
- Development determinism: identical seed returned identical order; different seed rotated order.
- Development permissions: `public`, `anon`, and `authenticated` cannot execute; `service_role` can.
- Development post-change security/performance advisors: no finding names the new selector; existing
  project-wide findings remain and are outside this remediation's scope.

**Risks / Issues:**
- Production still has the original blocked AP Statistics MCQ path until the reviewed migration and
  function version are explicitly approved and deployed there.
- A signed-in end-to-end student smoke test should be part of independent QA before Production
  deployment; the implementation agent did not manufacture or alter a student account to obtain it.

## QA Review

**QA Verdict:** Pending (Pass / Fail) — must come from a fresh, independent QA context.

**QA Result:** _(To be filled by the QA agent.)_

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD

Only the Main Conductor may set this task's status to `Done`, after integrating the QA Agent's
recommended verdict and verifying evidence.
