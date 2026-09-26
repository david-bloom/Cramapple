# TASK-0043 — Launch: Student Hub

**Task ID:** TASK-0043
**Title:** Student Hub — Implementation Audit Against Rebuild Plan §12
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Not Started
**Priority:** High — the entitlement-gating bug is the one confirmed open risk for Friday
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — assign per R1 (`<agent>/task-0043-<slug>`) when an agent starts execution
**PR:** None yet

## Product Goal

The logged-in, student-facing app matches its governing spec closely enough that a real student can
complete a full session (enter, attempt, get feedback, see progress) without hitting an undesigned or
unimplemented gap. **This is an implementation audit, not a redesign** — flag implementation gaps,
don't propose UX changes to already-decided sections.

## Technical Scope

Primary source: `docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` — read in full, including the
CORRECTION block, before starting.

Confirmed facts already established (do not re-derive):

- Launch frontend is the "Remix of Cramapple App" Lovable project (`d334fed9-5a97-4e76-906e-7c0ad7082212`,
  `https://ap-prep-canvas.lovable.app/`) — `DECISION-0073`.
- No visual/brand rebuild needed — the live HTML already renders the full `docs/new_design/` system
  correctly.
- **Practice/grading is verified real production infrastructure, not a demo** — `use-grade-practice.ts`
  calls the actual `session-event`/`attempt-response`/`evaluate-attempt` edge functions. Only the
  home-page hero's `FrqDemo.tsx` is a scripted demo (expected, marketing-only).
- This confirms the entitlement-gating bug (unentitled students hitting a generic "Couldn't score
  that" error) lives in this real grading path — **not yet fixed**, the one real open risk for Friday.
- Primary execution frame: `docs/product/APP_REBUILD_MIGRATION_PLAN.md` §12 (phased rebuild, own exit
  criterion, §11's 25 open decisions). Secondary/cross-check: `STUDENT_PORTAL_INTERACTION_DESIGN.md` —
  flag conflicts between the two rather than silently picking one.
- Use `COURSE_MODE_PILOT_LAUNCH_PLAN_2026_08_26.md`'s gating pattern (phased rollout, named owner per
  phase, explicit exit gate, held gate requiring David's go) as the template for how this task should be
  executed.

## Out of Scope

Redesigning any already-decided section of the interaction design spec — raise a proposal to David
instead of implementing an unrequested UX change.

## Routes / Components / Systems Affected

- Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212` — outside this repo's edit surface.
- `src/lib/use-grade-practice.ts`, `SessionFrame.tsx`, `GradeResultView.tsx` (in the Lovable project).
- `session-event`, `attempt-response`, `evaluate-attempt` edge functions (this repo).

## Data / Security / Integration Impact

The entitlement-gating gap is a student-facing defect on the entitlement/access boundary — an
unentitled student currently hits a generic error rather than a clear paywall message. Fixing it
touches the real grading path; test against a real logged-in session in a non-production environment.

## Acceptance Criteria

(Full detail and rationale in `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` — this list mirrors it; that doc
governs if they drift.)

- [x] Frontend confirmed: `ap-prep-canvas.lovable.app` (`DECISION-0073`).
- [ ] Rebuild plan §12's phase structure and exit criterion used as the primary execution frame;
      conflicts with `STUDENT_PORTAL_INTERACTION_DESIGN.md` named explicitly, not silently resolved.

Audit each spec section against the live app (status: Implemented / Partial / Not implemented /
Deferred-by-decision, with live-app evidence, not a design-doc read):

- [ ] §3 Information architecture — primary student areas exist and are navigable.
- [ ] §4 Entry flows — first-session and returning-session flows both work as specced.
- [ ] §5 Session mode presentation — decided variant implemented, or flagged as a Decision Required.
- [ ] §6 Stable learning-session frame — cold attempt, feedback, repair/retry, completion/lock all
      function against a real question, tested live, for **both Day-1 subjects (AP Biology, AP
      Statistics) on their flat/practice paths** per `DECISION-0063`/`DECISION-0072` — not the
      unit-gated path for either.
- [ ] §7 Feedback treatment — decided variant matches the spec's evaluation criteria.
- [ ] §8 Coaching copy — matches Copy Rules; check the paste-event prompt specifically (shared with
      BYOQ academic-integrity handling).
- [ ] §9 Uncertainty/escalation/disagreement — grading uncertainty, content uncertainty, disputed
      grade, temporary failure all have a real, tested path.
- [ ] §10 Progress and home — implemented per `PROGRESS_DASHBOARD_V1_PLAN_2026_08_21.md`.
- [ ] §11 Accessibility requirements — verified against the spec's stated bar.
- [ ] §14 Decisions Required — every item resolved (cite the decision) or explicitly named as a launch
      blocker.
- [ ] Course Mode's pilot-launch plan/QA report checked for anything that generalizes (bug class,
      gating lesson) rather than re-discovering it.
- [ ] **Entitlement-gating bug**: confirmed current live status, and either fixed or explicitly escalated
      as launch-blocking (cross-reference TASK-0041, which also tracks this bug on the payment side).

## QA Plan

- Manual QA: real logged-in session in a non-production environment, both Day-1 subjects, flat/practice
  path only.
- Automated tests: none specific beyond what already exists for the grading edge functions.
- Regression areas: entitlement gating, repair/retry flow, progress/home.
- Failure cases: unentitled student reaching scoring; any spec section silently reported "not
  implemented" against a superseded design.
- Security/data/integration checks: verify against `APP_REBUILD_MIGRATION_PLAN.md` §11's open decisions
  before treating any UX question as settled.

## Approval State

**Approval Required:** Yes
**Approval Type:** Standard (audit + bug fix); Hard Gate only where a fix touches production
grading/entitlement logic per existing gates.
**Decision:** Pending — this task record itself is a draft awaiting Codex's review before being
finalized; execution has not started.

## Implementation Notes

_(To be filled by the implementation agent.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail)

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD
