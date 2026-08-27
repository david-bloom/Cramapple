# Lovable Build Brief — Home quick-start opens straight into `/session`

STATUS: build brief (ready to send) | DATE: 2026-08-26 | TARGET: `exam-buddy-wireframe`
(Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212`) | TASK: `docs/tasks/TASK-0029`.

## How to use this file

Send this entire file to Lovable as one focused maintenance prompt. It is
independent of the confirm-transfer build
(`docs/teaching/COURSE_MODE_CONFIRM_TRANSFER_FRONTEND_BRIEF.md`) and of the
session-shell design work; do not bundle them.

## The problem (observed live, 2026-08-26)

Clicking the **Home quick-start door** routes the student through an
interstitial setup screen before the session:

```
/home  →  /session/setup?…&mode=quick&unit=1&topic="1.1"  →  /session
```

This contradicts a settled product decision (David, 2026-08-25 —
`COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md` §3.1):

> **No pre-session setup page.** There is no `/session/setup` step. Session
> size, unit/topic scope, and Learn/Points mode are chosen on `/home` (the
> doors + selectors already there) … A `/home` door opens **straight into the
> running session**.

## The job

1. **Re-point the `/home` quick-start door to navigate directly to
   `/session`.** Carry the exact scope the door currently encodes
   (`mode=quick`, `unit`, `topic`, and anything else in its query string)
   straight through to `/session` — as query params or router state, matching
   how `session.index.tsx` already reads its inputs. The session that starts
   must be scoped **identically** to what the setup-interstitial path
   produced; this is a routing change, not an assembly change.
2. **If `/session/setup` currently performs any real work for the quick-start
   path** (translating params, creating the learning session, seeding state),
   move that work into the `/session` route's own load path — never onto a
   visible setup screen. Report what, if anything, had to move.
3. **Leave every other entry point alone.** The first-run onboarding `/setup`
   wizard is untouched. `/session/setup` itself stays in place if any other
   surface still links to it. Search the codebase for its remaining
   consumers and report them; if the quick-start door was its **only**
   consumer, say so and flag it for removal in a follow-up — do not delete
   the route in this build.

## Integration target (pinned — do not drift)

- The live Course Mode session is `src/routes/session.index.tsx` (`/session`)
  → `src/components/session/SessionFrame.tsx` → `src/hooks/use-session.ts`.
- Do **not** target the legacy `_ux.session.*` routes.
- Frontend/router only. **No Lovable Cloud** (the backend is Cramapple's own
  external Supabase); no schema, edge-function, or `.env` change.

## Acceptance criteria

- Quick-start click on `/home` lands on `/session` with the session running;
  `/session/setup` never appears in the navigation history on that path.
- Browser Back from the session returns to `/home` (no interstitial to skip
  past).
- The assembled session's scope (unit/topic/mode) is unchanged vs. before.
- Other consumers of `/session/setup` (if any) still work.
- No change to `/session` item flow, grading calls, or any answer-key /
  serving behavior.

## Do not do

- Do not build the inline "3 questions · Unit 1" adjustable-defaults line on
  `/session` here — that belongs to the session-shell build, separately.
- Do not touch the confirm-transfer flow, `useSession` grading logic, or the
  first-run `/setup` wizard.
- Do not delete `/session/setup` in this build (flag-only, per above).
- Do not enable Lovable Cloud or create any backend resources.
- Do not publish/deploy — the owner republishes to cramapple.com himself.

## Completion output

Report: (a) the file(s)/handler(s) changed on `/home`; (b) whether
`/session/setup` did real work for quick-start and where that work moved;
(c) every remaining consumer of `/session/setup`, or "none — flagged for
removal"; (d) confirmation the scope params flow through unchanged; (e) a
preview link.
