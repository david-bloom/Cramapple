# TASK-0033 — Course Mode Sessions Serve the Wrong Path (pilot MCQs never load)

**Task ID:** TASK-0033
**Title:** Route pilot sessions through the direct published-MCQ path; learn-first serves the clicked cell
**Owner:** Claude, with David
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** In Progress (follow-up: quick-start topic-scope dead-end; second build pending)

**Follow-up (2026-08-26, post-republish):** David's retest confirmed both
entries work and confirm-transfer fired — but the quick-start URL
`?mode=quick&unit=1&topic="1.1"` dead-ends: Home encodes the student's
*position* topic (1.1), which has **no pilot cell** (pilot starts at 1.2), so
exact-topic scoping honestly serves nothing on the primary door. Fix brief
sent (`umsg_01m102fp28ejfvgs69tr6e6nz4`): topic scope → unit-scope fallback →
honest empty only when the unit has nothing, with the params line showing the
**effective** scope (no false topic claim); learn-first exact-cell scoping
unchanged. (Checked: the `%22` quoting in the URL is TanStack's normal JSON
search encoding, parsed back to `1.1` in-app — not a bug.)
**Priority:** Critical (live prod failure — both session entries broken after republish)
**Created Date:** 2026-08-26
**Branch:** `claude/home-to-session-migration-e65jmk` (docs); build in the Lovable project
**PR:** #138
**Source:** David live-testing post-republish: "Learn-first entry is not rendering" /
"cold attempt is not rendering". Root-caused with prod evidence during the
(interrupted) QA run.

## Root cause (verified live, 2026-08-26 ~22:0x UTC)

1. Quick-start/learn-first contracts carry no `selectedFormat`, so the runner
   takes the server path: `callStudentSessionItems({learning_session_id, limit:8})`.
   Deployed `student-session-items` v17 defaults that shape to **FRQ-only**
   (`select_practice_frqs`); MCQ serving needs an explicit `mode:"unit_gated"`
   the client never sends.
2. `mode:"unit_gated"` couldn't serve the pilot anyway:
   `select_unit_gated_practice_items` requires **validated serving taxonomy
   labels** — the 203 pilot MCQs have **0** (by design; PILOT_PLAN §6's RESOLVED
   serving path is the client's direct published-MCQ RLS read, "no validated
   serving label needed"). Verified: the RPC returns 0 items for pack
   `7c5a2975` (any item_type), and the pilot items' `practice_format` is NULL.
3. David's 22:01 session was created on the **general pack `548f06be`** —
   his `profiles.active_exam_pack_version_id` had reverted from the Phase-4
   setting — so `select_practice_frqs` served **8 general-pack FRQs**
   (the 200/4KB responses in the gateway logs). Net: the pilot experience
   never loaded; `pilot_sessions_ever = 0` on prod.
4. Not the blocker but checked: Stats Unit-1 has **13 published
   `topic_explainers`** — the learn-first opener has content once serving works.

## Actions taken

- **Prod data restore (2026-08-26):** `profiles.active_exam_pack_version_id`
  → `7c5a2975` for David's user (restores the recorded Phase-4 state; one
  field, reversible). **Risk:** whatever reverted it (likely a Home
  subject-selection write against the manifest default) can revert it again —
  the two-packs divergence (pilot-log next-step #3) is the standing cause and
  remains David's decision.
- **Fix brief sent to Lovable** (`umsg_01m101xs15ezs98cr2wx5c8vj6`):
  (1) direct published-MCQ path (TASK-0032's content_key + scoping + cap) for
  every Stats-pilot session unless the contract explicitly selects an FRQ
  format; server path unchanged for FRQ practice and non-pilot subjects;
  (2) learn-first threads the clicked skill's **cell** (topicCode+skillCode)
  and scopes served items to that exact cell (1.9 hosts two cells).

## Out of Scope

- Backend changes (labels for pilot items, v17 defaults, pack merge) — the
  pack divergence / manifest decision is David's (pilot-log next-step #3).
- Republish (David-held).

## Acceptance Criteria

1. On prod (post-build + republish, profile on `7c5a2975`): quick-start
   serves pilot MCQs; learn-first serves the clicked skill's cell with the
   worked-example opener; both render.
2. FRQ format practice and non-pilot subjects unchanged.
3. Tests for path selection + cell scoping green.

## Implementation Summary

- 2026-08-26 22:12 UTC — **build landed** (`exam-buddy-wireframe` `29d6d5a`
  "Fixed course mode serving path"). Diff-verified:
  - New `src/lib/course-mode/serving-path.ts`: `resolveServingPath()` —
    pilot subject (`ap-statistics`, prod's exact `subject_key`, verified) +
    anything other than explicit `short_frq`/`long_frq` → the direct
    published-MCQ path; non-pilot subjects keep the old behavior (server
    path unless explicit `mcq`).
  - `use-session.ts` decides via `resolveServingPath(activeSubject.…subjectKey,
    selectedFormat)`; the published-MCQ branch reuses TASK-0032's
    content_key + scoping + cap.
  - New `scopeMcqItemsToCell()` — learn-first serves the clicked skill's
    EXACT cell (topicCode AND skillCode; 1.9's two cells disambiguated);
    empty cell → empty list, never a fallback.
  - `serving-path.test.ts` (89 lines, 8 cases) covers all path-selection
    branches + cell scoping + the empty-cell honesty rule.

## Approval State

Emergency fix on a live failure David reported in-session; frontend-only.
Prod profile restore recorded above. Republish remains David's.
