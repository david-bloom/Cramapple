# TASK-0029 — Home → Session Entry Migration (remove `/session/setup` from the quick-start path)

**Task ID:** TASK-0029
**Title:** Home → Session Entry Migration (quick-start opens straight into `/session`)
**Owner:** Claude, with David
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Ready for Review (build landed; preview QA + republish pending)
**Priority:** High (pilot-blocking polish — flagged in the 2026-08-26 pilot session log and the Fable QA prompt as a known issue)
**Created Date:** 2026-08-26
**Approved Date:** 2026-08-26 (scope go given by David in-session; see Approval State)
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

- 2026-08-26 20:55 UTC — brief sent to the Lovable project (`d334fed9`,
  message `main:user#00000000001022#usr:GAGBSMCZ`) after David's explicit
  scope go.
- 2026-08-26 20:57 UTC — **build landed** (`exam-buddy-wireframe` commit
  `a6f0c6e` "Fixed home quick-start routing"; 328 tests green). Per the
  agent's report + verified in the repo:
  - `TopicHome.tsx` `startPractice()` / `startDiagnostic()` now navigate
    straight to `/session` with the same `practiceSearch()` payload.
  - The param translation `/session/setup` did for quick-start moved into
    `contractFromSearch()` on `session.index.tsx`'s own load path (no
    visible screen). `starter`→`quick`, minutes verbatim, unit→
    `selectedUnit`, topic→`selectedTopicIds`.
  - **Defect fixed in passing:** the old interstitial *dropped* the door's
    `topic` param (it only auto-skipped for `mode=starter` and otherwise
    re-asked everything with generic defaults — Focused/30 min); the new
    path honors the topic. The dead `isFirstSession` sessions-lookup (no
    runner code reads it) was not carried over.
  - `/session/setup` kept — remaining consumers: `resume`, `attempt.$id`,
    `plan`, `onboard`, `dashboard`, `byoq`, the `/learn` deep-link route,
    and `/session`'s "Change topic" action.
- 2026-08-26 20:59 UTC — follow-up build (David, directly in Lovable):
  a bare `/session` visit (e.g. `/session?intent=review`) no longer bounces
  to setup — it builds a default recommendation-scoped quick contract.

## Studying-intent analysis (David's question, 2026-08-26)

Q: on `/home` in Learn or Points mode, do we know enough about studying
intent to skip `/session/setup`? **Yes.** The wizard collects length
(mode+minutes), entry path, and scope (unit/topics/format). At door-click
time all are already determined: subject (active subject), unit (the
student's server-persisted confirmed position, adjustable on `/home`),
topic (the exact row/brief clicked — `practiceParams` carries the canonical
code), minutes+mode (encoded by the door), entry path (the click itself:
topic row = self-guided, Start card = recommendation). Learn vs Points
changes framing/ranking only, not required inputs. The interstitial added
no information — it ignored the incoming params and dropped the topic. The
one thing it offered (changing length/scope in-flow, format practice) is
per §3.1 an inline `/session` affordance (separate session-shell build);
format practice remains reachable via the surfaces still linking setup.

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
- This task spec + the Lovable brief were drafted under Standing Approval
  (Lane 1). **Scope go: David, 2026-08-26 (explicit, in-session — "Send it
  now")**; the brief was sent to Lovable the same evening. The Lane-2 SLA
  fallback is superseded by the explicit approval.
- Republish to cramapple.com: Hard-Gate (production), David only.

## QA Result

(pending)

## Done Decision

(pending)
