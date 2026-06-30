# UX-001 - Initial Product UX Decisions

**Task ID:** UX-001
**Title:** Initial Product UX Decisions
**Owner:** Product Owner with Learning and Marketing owners
**Product Owner:** David Bloom
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-06-13
**Approved Date:** 2026-06-13 for design and prototype work

## Product Goal

Define and test the initial student-portal interaction model so a learner can
begin quickly, understand what to do next, complete Cramapple's learning loop,
recover from uncertainty or disagreement, and leave with a credible next
action.

## Technical Scope

- Define the proposed student-portal information architecture.
- Define first-session onboarding and returning-learner entry.
- Define presentation of Quick, Focused, and Buckle Down session modes.
- Translate the unified learning-state model into stable student-visible
  interaction zones.
- Define proposed Score, Repair, retry, Move On, Park, and Lock interactions.
- Define test variants for bracket-marker and sentence-level feedback.
- Draft peer-tone academic-integrity coaching copy.
- Draft uncertainty, escalation, recheck, and disputed-grade language.
- Define accessibility requirements for the student experience.
- Produce the Lovable student-experience build brief and an owner decision
  packet.

## Out of Scope

- Backend implementation beyond existing auth/session or mock-state fallback.
- Final visual brand system or polished marketing copy.
- Physical database, API, or event-schema design.
- Final recommendation-ranking, grading, or confidence algorithms.
- Parent portal design.
- Final graph-capture workflow from `TASK-0011`.
- Final legal privacy, consent, age-gating, or accessibility conclusions.
- Production use of unapproved content, grading, or score estimates.

## Routes / Components / Systems Affected

- Student onboarding and session entry.
- Student home, resume, and recommended-next-action surfaces.
- Learning-session question, attempt, feedback, intervention, and retry states.
- Session completion, due review, and progress surfaces.
- Student-provided-question entry at a conceptual level.
- Accessibility and responsive interaction behavior.

## Data / Security / Integration Impact

The design must distinguish authoritative server state from client
presentation. It must not expose internal diagnosis labels, hidden rubric
criteria before a cold attempt, protected learner records, or unsupported
mastery and score claims. Upload, behavioral-signal, consent, retention, and
human-review promises remain subject to their separate product, technical, and
legal gates.

## Acceptance Criteria

- [x] UX task scope, approval boundary, and dependencies are recorded.
- [x] Proposed student-portal information architecture is documented.
- [x] Core first-session and returning-session flows are documented.
- [x] Post-account creation setup is collapsed into one composed, recoverable
  setup surface with course-position confirmation, time selection, and a
  first-session plan.
- [x] Student-visible learning-loop states and primary actions are documented.
- [x] Initial test variants for onboarding, session modes, and bracket-marker
  feedback are documented.
- [x] Initial coaching, uncertainty, escalation, and disputed-grade copy is
  documented as proposed.
- [x] Student-experience accessibility requirements are documented.
- [ ] Learning Quality Owner reviews pedagogical fidelity and answer-leakage
  risks.
- [ ] Marketing owner reviews tone, naming, and student-facing copy.
- [ ] Accessibility specialist reviews interaction patterns.
- [x] Initial Lovable student-experience build brief is produced.
- [ ] Student experience is tested with representative learners.
- [ ] Collapsed one-screen setup passes a dedicated accessibility QA pass:
  keyboard navigation, focus order, screen-reader labels, recoverability, and
  mobile overflow.
- [ ] A/B test compares the prior multi-step onboarding against the one-screen
  setup on time-to-first-attempt, comprehension, trust, ability to change
  unit/time, and ability to find alternate routes.
- [ ] Product Owner approves, revises, or rejects the proposed UX decisions.
- [ ] Approved decisions are recorded before backend production hardening.

## QA Plan

- Manual QA: Walk through first use, resume, MCQ, FRQ, successful transfer,
  ordinary repair, escalation, Move On, Park, uncertainty, recheck, and session
  completion.
- Automated tests: `git diff --check` and Markdown link checks when tooling
  exists.
- Regression areas: Cold-mode answer leakage, learner agency, unsupported
  mastery language, grading uncertainty, progress claims, and mobile access.
- Failure cases: No eligible recommendation, interrupted session, grading
  timeout, content uncertainty, missing visual, inaccessible control, disputed
  feedback, and unavailable delayed-review item.
- Security/data/integration checks: Confirm prototypes do not imply client-side
  authority, public learner data, guaranteed human review, or approved upload
  handling.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate for final product decisions and implementation
**Decision:** Design and prototype work approved; final UX and implementation
pending

## Implementation Notes

The initial interaction specification is:

- `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md`
- `prompts/LOVABLE_UX001_STUDENT_EXPERIENCE.md`

This task may create wireframes, prototypes, copy variants, research plans, and
decision packets. It does not authorize production code.

## QA Review

Initial source-consistency review completed on 2026-06-13 against the vision,
architecture, learning system, stuck-state behavior, visual architecture, and
master backlog.

Initial browser verification completed on 2026-06-13:

- Walked through onboarding, session selection, MCQ feedback, FRQ feedback,
  criterion recheck, bracket-marker repair, independent retry, completion, and
  Progress.
- Verified the uncertainty state and its no-negative-progress language.
- Corrected hidden action groups that remained exposed after state changes.
- Verified modal focus entry, Escape behavior, and keyboard focus containment.
- Verified the responsive layout at 390 by 844 pixels with no horizontal
  overflow.
- Representative learner testing and specialist accessibility review remain
  pending.

### Revision Note — 2026-06-29 (Year-Aware Point Maximization)

The approved prototype direction has shifted from the expanded five-step setup
journey to **one composed, recoverable setup surface**: course position
pre-filled from a calendar-keyed pacing prior (learner confirms or adjusts),
available time (defaulted, adjustable), and an inline first-session plan.
Registration status, the immediate-goal screen, and the calibration-versus-direct
fork are removed from onboarding — registration moves to Account, "tell me what
to work on" is the default intent, and the first practice item serves as
continuous calibration.

Source: `docs/proposals/2026-06-29-year-aware-point-maximization.md` (reviewed by
Codex; pending Product Owner + curricular decision). This is a proposed
direction. It is **not** approved: it remains pending Product Owner sign-off, a
dedicated accessibility QA pass on the collapsed surface, and an A/B test against
the prior fuller onboarding. The `STUDENT_PORTAL_INTERACTION_DESIGN.md` §4.1 and
`prompts/LOVABLE_UX001_STUDENT_EXPERIENCE.md` have been reconciled to this
direction; the static prototype is being updated to match.

Post-account creation design revision prepared on 2026-06-13
`SUPERSEDED by 2026-06-29 year-aware onboarding direction`:

- Replaced the single setup screen with a recoverable five-step first-run
  journey.
- Added explicit reasons for collecting exam timing, goal, and time available.
- Preserved optional calibration and direct-start paths.
- Added a transparent first-session plan that changes with learner selections.
- Routed direct-start choices to topic, check-my-work, or bring-a-question
  intake instead of a generic practice item.
- Replaced learner-entered exam dates with the official date supplied by the
  active AP Biology exam specification.
- Verified required registration-status validation for registered, not
  registered yet, and unsure paths.
- Verified recommended calibration begins with a cold calibration item.
- Verified direct topic selection reaches topic intake and then practice.
- Verified check-my-work intake requires both the prompt and learner answer.
- Verified the first-session plan updates duration, activity, calibration,
  numbering, and rationale from learner selections.
- Verified the revised setup at 390 by 844 pixels with no horizontal overflow.

Current direction as of 2026-06-29:

- Replace the five-step first-run journey with one composed, recoverable setup
  surface.
- Do not ask registration status during onboarding.
- Do not require a calibration/direct-start fork.
- Default to a short recommended session based on course-position pacing prior,
  with course position and available time adjustable before start.
- Use real app routes, not `/prototype` routes.

## Done Decision

**Decision:** Pending
**Date:** Pending
