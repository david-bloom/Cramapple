# TASK-0045 — Post-Launch: Student Hub Full Specification Audit

**Task ID:** TASK-0045
**Title:** Student Hub — Full Implementation Audit Against Rebuild Plan §12 (post-launch)
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Not Started
**Priority:** Medium — post-launch; not required for the October 2, 2026 launch decision
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — assign per R1 (`<agent>/task-0045-<slug>`) when an agent starts execution
**PR:** None yet

## Origin

Split out of TASK-0043 per Codex's 2026-09-26 pre-execution review: TASK-0043 is narrowed to the
October 2 launch-critical new-student smoke test (signup, entitlement, submit-to-grade for the two
Day-1 subjects); this task carries the broader spec-audit scope TASK-0043 originally held, which is not
required to make the October 2 go/no-go decision.

## Product Goal

The logged-in, student-facing app matches its governing spec closely enough that a real student can
complete a full session (enter, attempt, get feedback, see progress) without hitting an undesigned or
unimplemented gap, across all sections of the governing spec — not just the new-student smoke path
covered by TASK-0043. **This is an implementation audit, not a redesign** — flag implementation gaps,
don't propose UX changes to already-decided sections.

## Technical Scope

Primary sources, in order: `docs/product/APP_REBUILD_MIGRATION_PLAN.md` §12 (phased rebuild, own exit
criterion, §11's 25 open decisions) as the primary execution frame; `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md`
(older 14-section UX spec) as secondary/cross-check — flag conflicts between the two explicitly rather
than silently picking one.

**Environment and subject boundary:** use non-production first for failure-path or destructive checks.
Verify deployed behavior against the Production app with clearly labeled QA accounts and a recorded
cleanup plan; do not infer Production behavior solely from non-production. For the cross-subject
session-frame check, test Biology and Statistics plus **one** additional post-launch subject after that
subject's TASK-0046 slice has passed and it is intentionally available in the tested environment. If no
additional subject has reached that gate, record this criterion as blocked on TASK-0046 rather than
testing an unavailable subject or silently expanding launch scope.

Confirmed facts already established (do not re-derive; see TASK-0043 and
`LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` for full evidence):

- Launch frontend is `ap-prep-canvas.lovable.app` (`DECISION-0073`).
- Practice/grading is verified real production infrastructure (`use-grade-practice.ts` calls real
  edge functions), not a demo.
- Use `COURSE_MODE_PILOT_LAUNCH_PLAN_2026_08_26.md`'s gating pattern (phased rollout, named owner per
  phase, explicit exit gate, held gate requiring David's go) as the template for how this task should be
  executed.

## Out of Scope

The October 2 new-student signup/entitlement/submit-to-grade smoke test — that's TASK-0043, already
launch-critical and out of this task's scope to avoid duplication. Redesigning any already-decided
section of the interaction design spec.

## Routes / Components / Systems Affected

- Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212` — outside this repo's edit surface.
- `session-event`, `attempt-response`, `evaluate-attempt` edge functions (this repo).

## Data / Security / Integration Impact

Any fix arising from this audit that touches production grading/entitlement logic is a Production
change requiring explicit approval before deploy, same as TASK-0043.

## Acceptance Criteria

Audit each spec section against the live app (status: Implemented / Partial / Not implemented /
Deferred-by-decision, with live-app evidence, not a design-doc read):

- [ ] §3 Information architecture — primary student areas exist and are navigable.
- [ ] §4 Entry flows — first-session and returning-session flows both work as specced.
- [ ] §5 Session mode presentation — decided variant implemented, or flagged as a Decision Required.
- [ ] §6 Stable learning-session frame — cold attempt, feedback, repair/retry, completion/lock all
      function against a real question for Biology, Statistics, and one post-launch subject whose
      TASK-0046 slice has passed. If none has passed, record this criterion as blocked on TASK-0046.
- [ ] §7 Feedback treatment — decided variant matches the spec's evaluation criteria.
- [ ] §8 Coaching copy — matches Copy Rules; check the paste-event prompt specifically (shared with
      BYOQ academic-integrity handling).
- [ ] §9 Uncertainty/escalation/disagreement — grading uncertainty, content uncertainty, disputed
      grade, temporary failure all have a real, tested path.
- [ ] §10 Progress and home — implemented per `PROGRESS_DASHBOARD_V1_PLAN_2026_08_21.md`.
- [ ] §11 Accessibility requirements — verified against the spec's stated bar.
- [ ] §14 Decisions Required — every item resolved (cite the decision) or explicitly named as a
      follow-up item.
- [ ] Course Mode's pilot-launch plan/QA report checked for anything that generalizes (bug class,
      gating lesson) rather than re-discovering it.

## QA Plan

- Manual QA: run failure-path and destructive checks in non-production first; then verify the deployed
  Production behavior with clearly labeled QA accounts. Cover Biology, Statistics, and one additional
  subject only after its TASK-0046 slice has passed; otherwise report that portion blocked.
- Automated tests: none specific beyond what already exists for the grading edge functions.
- Regression areas: progress/home, accessibility, coaching copy.
- Failure cases: any spec section silently reported "not implemented" against a superseded design.
- Security/data/integration checks: verify against `APP_REBUILD_MIGRATION_PLAN.md` §11's open decisions
  before treating any UX question as settled.
- **QA independence:** QA on this task must run in a fresh, independent context, separate from the
  implementer.

## Approval State

**Approval Required:** Yes
**Approval Type:** Standard (audit); Hard Gate only where a resulting fix touches production
grading/entitlement logic.
**Decision:** Pending — this task record was created 2026-09-26 as a split from TASK-0043 per Codex's
review; not yet reviewed on its own. Execution has not started and is not required before the October 2
launch decision.

## Implementation Notes

**Implementation Summary:** _(To be filled by the implementation agent.)_

**Test Results:** _(To be filled by the implementation agent.)_

**Risks / Issues:** _(To be filled by the implementation agent, including any criterion blocked on
TASK-0046 and the disposition/cleanup status of every QA account.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail) — must come from a fresh, independent QA context.

**QA Result:** _(To be filled by the QA agent.)_

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD

Only the Main Conductor may set this task's status to `Done`, after integrating the QA Agent's
recommended verdict and verifying evidence.
