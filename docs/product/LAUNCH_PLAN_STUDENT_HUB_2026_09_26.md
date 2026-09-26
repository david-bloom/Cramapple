# Launch Plan — Student Hub — 2026-09-26

**Status:** Draft | **Owner:** David Bloom | **Tier:** Standard
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`

## Product Goal

The logged-in, student-facing app matches its own design spec closely enough that a real student can
complete a full session (enter, attempt, get feedback, see progress) without hitting an undesigned or
unimplemented gap. This plan is an **implementation audit against an existing spec**, not a redesign —
do not propose UX changes to sections that are already decided; flag implementation gaps instead.

## Authoritative source

`docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md` — the 14-section UX spec covering purpose,
experience principles, information architecture, entry flows, session-mode presentation, the stable
learning-session frame (cold attempt → feedback → repair/retry → completion/lock), feedback treatment,
coaching copy, uncertainty/escalation/disagreement handling, progress/home, accessibility requirements,
scope, research plan, and decisions still required (§14). Read §14 first — some of this spec is not
yet finalized even on paper.

## Related implementation docs to cross-check, not duplicate

- `docs/product/PROGRESS_DASHBOARD_V1_PLAN_2026_08_21.md`, `PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md`
  — implementation plan for spec §10 (Progress and Home).
- `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` — implementation detail for the learning-
  session frame (§6) and feedback treatment (§7).
- `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md`,
  `BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md` — edge-case input handling.
- Course Mode layer (`docs/teaching/COURSE_MODE_*`) is a major in-portal feature with its own pilot
  history — `COURSE_MODE_PILOT_LAUNCH_PLAN_2026_08_26.md` and
  `COURSE_MODE_PILOT_LIVE_HANDOFF_2026_08_27.md` are the most recent status. **Use this pilot's gating
  pattern (phased rollout, named owner per phase, explicit exit gate per phase, a held gate requiring
  David's explicit go before real students) as the template for how this plan should be executed**,
  rather than inventing a new gating structure.

## Acceptance Criteria

Audit implementation status against each spec section and record a status (Implemented / Partial /
Not implemented / Deferred-by-decision) with evidence (live app check, not a design doc read):

- [ ] §3 Information architecture — primary student areas exist and are navigable.
- [ ] §4 Entry flows — first-session and returning-session flows both work as specced.
- [ ] §5 Session mode presentation — whichever variant (A or B) was decided is implemented; if neither
      is finalized, that's a Decision Required, not an implementation gap — check §14 first.
- [ ] §6 Stable learning-session frame — cold attempt, feedback, repair/retry, and completion/lock all
      function against a real question, tested live, for at least one subject that has passed
      `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`.
- [ ] §7 Feedback treatment — the decided variant is implemented and matches the evaluation criteria in
      the spec.
- [ ] §8 Coaching copy — matches the Copy Rules in the spec; check the paste-event prompt specifically,
      since it interacts with academic-integrity handling shared with BYOQ.
- [ ] §9 Uncertainty/escalation/disagreement — grading uncertainty, content uncertainty, disputed
      grade, and temporary failure all have a real, tested path (not just a spec description).
- [ ] §10 Progress and home — implemented per `PROGRESS_DASHBOARD_V1_PLAN_2026_08_21.md`.
- [ ] §11 Accessibility requirements — verified against the spec's stated bar, not just visually
      inspected.
- [ ] §14 Decisions Required — every item in this list is either resolved (cite the decision) or
      explicitly still open and named as a launch blocker in this plan.
- [ ] Course Mode's own pilot-launch plan and QA report are checked for anything it found that
      generalizes to the rest of the student hub (e.g., a bug class, a gating lesson) rather than
      re-discovering it.

## Out of Scope

Redesigning any already-decided section of the interaction design spec — raise a proposal to David
instead of implementing an unrequested UX change.

## Method Note

Test against a real logged-in session in a non-production environment wherever possible. A design spec
describing a flow is not evidence the flow is built — this is the same lesson the six-criteria doc
learned the hard way on content servability, and it applies equally here.
