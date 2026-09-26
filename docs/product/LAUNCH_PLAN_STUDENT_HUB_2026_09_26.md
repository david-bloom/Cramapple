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

**RESOLVED and CONFIRMED, 2026-09-26 (`DECISION-0072`): the launch frontend is the "Remix of Cramapple
App" Lovable project** (id `d334fed9-5a97-4e76-906e-7c0ad7082212`), published at
`https://ap-prep-canvas.lovable.app/`. Confirmed via the live HTML's embedded `og:image`, which points
to this exact project's screenshot, and independently via the HTML's TanStack Start/Router markers
matching this project's stored tech-stack description. This session's first guess ("New Cramapple App")
was wrong — corrected.

**No visual/brand rebuild is needed.** The live HTML imports `docs/new_design/`'s token CSS verbatim
(the page's own inline stylesheet comments cite that exact GitHub path) and renders the full
orange/Bungee/Passion One/Source Sans 3 system correctly. The earlier "old blue/red wordmark" finding
was real but pointed at a stale Lovable `get_project` screenshot cache, not the live page — the live
page was already correct. Lesson: don't trust `get_project` screenshots as current-state evidence for
this project; use the live URL/HTML instead.

**New, launch-blocking finding from the live HTML:** the page still shows a $39.99 purchase CTA and a
full Stripe-style pricing/buy section. This is stale against `DECISION-0070` (Friday launches free, no
Stripe). David is handling this directly (a "Free this week!" banner), not delegated to an agent — see
`LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md`.

## VERIFIED, 2026-09-26: practice/grading is real production infrastructure, not a demo

David asked whether this app's practice/grading is genuinely wired to a real grading backend or is a
demo — the answer is **it's real**, verified by reading the project's source directly (see
`DECISION-0072`'s verification addendum for full detail):

- `src/lib/use-grade-practice.ts` (used by the real session/practice components,
  `SessionFrame.tsx`/`GradeResultView.tsx`) calls `supabase.functions.invoke()` against the actual
  production edge functions this repo documents elsewhere — `session-event`, `attempt-response`,
  `evaluate-attempt` (the same infrastructure as TASK-0016's grading rollout). Not mocked, not a
  separate path.
- Only the home-page hero's `FrqDemo.tsx` (explicitly under `src/components/marketing/`) is a scripted,
  hardcoded animation — expected and fine for a marketing teaser, not a defect.
- This independently confirms the entitlement-gating bug flagged earlier (unentitled students hitting a
  generic "Couldn't score that — try again." error) lives in exactly this real grading path — the error
  string matches `use-grade-practice.ts`'s `runEvaluate` function verbatim.

**This closes out the "is student hub / practice-grading genuinely separate and how far along is it"
question this plan originally left open.** It's not a build item — it exists and is production-wired.
The remaining real risk for Friday is the entitlement-gating bug, not the absence of real grading.

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

- [x] Frontend confirmed: "Remix of Cramapple App" Lovable project (`d334fed9-5a97-4e76-906e-7c0ad7082212`),
      published at `ap-prep-canvas.lovable.app` — verified via live HTML, see `DECISION-0072`.
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
