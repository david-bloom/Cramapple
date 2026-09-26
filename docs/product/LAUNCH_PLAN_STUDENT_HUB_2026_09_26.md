# Launch Plan — Student Hub — 2026-09-26

**Status:** Draft | **Owner:** David Bloom | **Tier:** Standard
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`

## CORRECTION, 2026-09-26 (same day, after a second AI review)

**This plan originally treated `STUDENT_PORTAL_INTERACTION_DESIGN.md` as the sole authoritative spec.
It is not current: `docs/product/APP_REBUILD_MIGRATION_PLAN.md` (2026-09-22, David-approved) is a
newer, phased rebuild plan for this exact surface, with its own decision register (§11, 25 items) and
its own exit criterion.** The two documents partially overlap and are not reconciled with each other.
Do not audit against the older spec alone — you will report "not implemented" against a design that
may itself be superseded.

**RESOLVED, 2026-09-26 (`DECISION-0072`): the launch frontend is the Lovable app published at
`https://ap-prep-canvas.lovable.app/`** — not either of the two candidates this plan originally framed
(the live `exam-buddy-wireframe` app or the `web/` Vite rebuild). It is a third, separate Lovable
project. This session tentatively identified it as the **"New Cramapple App"** Lovable project
(id `56cae479-f7c9-4988-b536-56538c38ee4e`) by content match, but could not confirm the exact
custom-domain mapping (network egress to that URL was blocked, and Lovable's API doesn't expose a
domain-to-project lookup). **Confirm the exact project before auditing** — see `DECISION-0072` for the
verification gap. **The branding-mismatch note this plan originally carried here (old blue/red
wordmark vs. the new orange/Bungee system) is unverified and possibly stale** — David flagged that the
Lovable `get_project` screenshot this session read is a cached image, not necessarily the current live
page, and is providing the live HTML directly. Do not treat the brand-mismatch as confirmed; check the
live HTML once available before scoping a visual rebuild into this plan.

## Product Goal

The logged-in, student-facing app matches its governing spec closely enough that a real student can
complete a full session (enter, attempt, get feedback, see progress) without hitting an undesigned or
unimplemented gap. This plan is an **implementation audit**, not a redesign — do not propose UX changes
to sections that are already decided; flag implementation gaps instead.

## Authoritative sources (corrected)

- **Primary:** `docs/product/APP_REBUILD_MIGRATION_PLAN.md` §12 — the phased rebuild plan for the
  student-facing app, with its own exit criterion ("a student can sign in, be taught from a vetted
  item, attempt a real multi-part FRQ and a real MCQ, be graded..."). Treat this plan's phases as the
  primary execution structure for this audit. §11 holds 25 open decisions — read before assuming any
  UX question here is settled.
- **Secondary/cross-check:** `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md` — the older 14-section
  UX spec (purpose, experience principles, information architecture, entry flows, session-mode
  presentation, the learning-session frame, feedback treatment, coaching copy,
  uncertainty/escalation/disagreement, progress/home, accessibility, scope, research plan, and §14's
  own decisions-required list). Use this to cross-check the rebuild plan for gaps, not as the primary
  source of truth where the two conflict — flag conflicts to David rather than picking one silently.

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

- [ ] **Confirm the exact Lovable project published at `ap-prep-canvas.lovable.app`** before auditing
      anything else — this session's identification ("New Cramapple App," `56cae479-...`) is tentative,
      not verified. Use Lovable's own dashboard/domain settings or ask David directly; do not proceed
      on the tentative ID alone for anything beyond a first-pass audit.
- [ ] Rebuild plan §12's phase structure and its exit criterion are used as the primary execution
      frame; `STUDENT_PORTAL_INTERACTION_DESIGN.md` sections below are cross-checked against it, with
      any conflict between the two named explicitly rather than silently resolved.

Audit implementation status against each spec section and record a status (Implemented / Partial /
Not implemented / Deferred-by-decision) with evidence (live app check, not a design doc read):

- [ ] §3 Information architecture — primary student areas exist and are navigable.
- [ ] §4 Entry flows — first-session and returning-session flows both work as specced.
- [ ] §5 Session mode presentation — whichever variant (A or B) was decided is implemented; if neither
      is finalized, that's a Decision Required, not an implementation gap — check §14 first.
- [ ] §6 Stable learning-session frame — cold attempt, feedback, repair/retry, and completion/lock all
      function against a real question, tested live, for **both Day-1 subjects (AP Biology and AP
      Statistics) on their flat/practice paths** per `DECISION-0063`/`DECISION-0071` — do not test
      against the unit-gated path for either subject; both defer it, and Statistics' unit-gated path
      currently serves the most items of any subject but is explicitly not the launch path.
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
