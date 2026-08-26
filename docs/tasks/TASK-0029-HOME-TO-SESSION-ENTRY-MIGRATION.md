# TASK-0029 — Home → Session Entry Migration (remove `/session/setup` from the quick-start path)

**Task ID:** TASK-0029
**Title:** Home → Session Entry Migration (quick-start opens straight into `/session`)
**Owner:** Claude, with David
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** In Progress
**Priority:** High (pilot-blocking polish — flagged in the 2026-08-26 pilot session log and the Fable QA prompt as a known issue)
**Created Date:** 2026-08-26
**Approved Date:** — (underlying UX decision approved 2026-08-25; see Approval State)
**Branch:** `claude/home-to-session-migration-e65jmk` (this repo — docs/brief); build lands in the Lovable project (`exam-buddy-wireframe`)
**PR:** (recorded on open)
**Source:** `COURSE_MODE_PILOT_SESSION_LOG_2026_08_26.md` Next steps #2; `COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md` §3.1 (DECISION, David 2026-08-25); `COURSE_MODE_PILOT_QA_PROMPT_FABLE.md` Known issues ("Routing").

## Product Goal

A `/home` door opens **straight into the running session**. Today the Home
quick-start routes through an interstitial
`/session/setup?…&mode=quick&unit=1&topic="1.1"` before reaching `/session` —
observed live on cramapple.com during the 2026-08-26 pilot cutover (HAR +
user report). David decided on 2026-08-25 (spec §3.1) that Course Mode has
**no pre-session setup page**: session size, scope, and mode are chosen on
`/home`, and their changeable defaults surface inline on `/session`, not on a
separate config screen. This task executes the routing half of that decision
for the quick-start door.

## Technical Scope

- Frontend only, in the Lovable project (`exam-buddy-wireframe`, project
  `d334fed9-5a97-4e76-906e-7c0ad7082212`). Build brief:
  `prompts/LOVABLE_HOME_TO_SESSION_ROUTING_2026_08_26.md`.
- Re-point the `/home` quick-start door so it navigates **directly** to
  `/session` (the live Course Mode session: `session.index.tsx` →
  `SessionFrame` → `useSession`), carrying the door's scope parameters
  (unit/topic/mode) through so session assembly behavior is unchanged.
- Leave `/session/setup` in place for any *other* entry point that genuinely
  uses it; report what still links to it. If quick-start was its only
  consumer, flag that for a follow-up removal — do not delete it unflagged.

## Out of Scope

- The inline "3 questions · Unit 1" adjustable-defaults line on `/session`
  (spec §3.1) — part of the session-shell build already with Lovable, not
  this routing fix.
- The confirm-transfer `useSession` state machine
  (`COURSE_MODE_CONFIRM_TRANSFER_FRONTEND_BRIEF.md`) — independent build.
- The first-run onboarding `/setup` wizard — untouched.
- Any backend, schema, or edge-function change. None is needed.
- **Republish of the Lovable deployment to cramapple.com** — production,
  Hard-Gate, David-held (the 2026-08-26 log records the republish mechanics).

## Routes / Components / Systems Affected

- `/home` quick-start door (navigation handler only).
- `/session` (receives the door's params directly; no behavior change).
- `/session/setup` (no longer in the quick-start path; possibly orphaned —
  report, don't delete).

## Data / Security / Integration Impact

None. Navigation-only. No new data reads/writes; the no-answer-key and
serving invariants are untouched.

## Acceptance Criteria

1. Clicking the Home quick-start door lands directly on `/session` with the
   session running — `/session/setup` does not appear in the navigation
   history for that path.
2. The session assembled after the fix is scoped identically to before
   (same unit/topic/mode the door encoded in its query params).
3. Any other entry point that used `/session/setup` still works, and the
   build report lists every remaining consumer (or states there are none).
4. No regression on `/session` itself (ordinary item flow unchanged).

## QA Plan

- Lovable build report reviewed against the brief's "Report" section.
- Preview-link walkthrough: quick-start from `/home` → straight to
  `/session`; browser back returns to `/home` (no interstitial).
- The routing item in `COURSE_MODE_PILOT_QA_PROMPT_FABLE.md` (Known issues)
  flips from "known issue" to "verify fixed" in the next QA run.
- Fresh-context QA per `AGENT_OPERATING_MODEL.md` before `Ready for Review`
  → `Done`.

## Implementation Summary

(to be completed)

## Test Results

(to be completed)

## Risks / Issues

- The quick-start params (`mode=quick&unit=…&topic=…`) must be consumed by
  `/session` directly; if `session.index.tsx` currently relies on
  `/session/setup` to translate them, that translation moves into the
  `/session` route, not back onto a setup screen.
- cramapple.com only reflects the fix after David republishes the Lovable
  deployment (production Hard-Gate).

## Approval State

- The underlying UX decision is **already approved**: spec §3.1 "No
  pre-session setup page (DECISION, David 2026-08-25)"; the scoped fix is
  listed as next step #2 in `COURSE_MODE_PILOT_SESSION_LOG_2026_08_26.md`.
- This task spec + the Lovable brief are drafted under Standing Approval
  (Lane 1). **Sending the brief to Lovable (implementation) awaits David's
  go on this task's scope** (Standard tier — Lane 2 silence-is-consent SLA,
  24h from this spec's push, applies unless David objects).
- Republish to cramapple.com: Hard-Gate (production), David only.

## QA Result

(pending)

## Done Decision

(pending)
