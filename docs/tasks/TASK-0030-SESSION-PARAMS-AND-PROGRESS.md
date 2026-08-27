# TASK-0030 — Session Parameters + Progress Bar on the Running Session

**Task ID:** TASK-0030
**Title:** Show session parameters + items-primary progress bar on `/session`, editable in-flow
**Owner:** Claude, with David
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Ready for Review (build landed; preview QA + republish pending)
**Priority:** High (pilot session-experience polish; companion to TASK-0029)
**Created Date:** 2026-08-26
**Approved Date:** 2026-08-26 (David's direct instruction, in-session)
**Branch:** `claude/home-to-session-migration-e65jmk` (docs/brief); build lands in the Lovable project (`exam-buddy-wireframe`)
**PR:** #138
**Source:** David, 2026-08-26: "On the /session/mcq or /frq page we should show the
student the parameters of their session and a progress bar. They can edit the session
if they choose." Executes the inline-adjustable-defaults half of
`COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md` §3.1 (the routing half was
TASK-0029).

## Product Goal

The running session (the live `/session`, which renders MCQ and FRQ items — David's
"/session/mcq or /frq") currently shows only the skill name and a text
"Question k of N". The session's parameters (length mode, minutes, unit/topic scope)
are invisible, and the edit affordances (change minutes, change topic, end session)
are buried in a hamburger menu. Surface the parameters as an unobtrusive inline line
(e.g. "Quick · ~10 min · Unit 1 · Comparing distributions"), add an items-primary
progress bar, and make the line the visible entry point for editing the session
in-flow — per §3.1, never a separate config screen.

## Technical Scope

- Frontend only, in the Lovable project. Build brief:
  `prompts/LOVABLE_SESSION_PARAMS_PROGRESS_2026_08_26.md` (sent 2026-08-26,
  message `umsg_01m0zyw97cfc1afkddavmrma6e`).
- Target: `SessionShell.tsx` / `SessionFrame.tsx` / `use-session.ts` — the data
  (SessionContract, questionIndex/Total, pinned `progressLabel()` index,
  `setAvailableMinutes`, `onChangeTopic`) all already exists in state.
- Progress bar is **items-primary** and uses the same pinned index as
  `progressLabel()` so teach/confirm-transfer sub-beats do not advance it.
- Topic scope renders as plain-language names resolved from taxonomy (INV-1 —
  never a bare code).

## Out of Scope

- Any time-based progress, countdown, or "~N min remaining" (banned, §3.1/§3.6).
- Changes to the confirm-transfer machine, queue advancement, grading/serving calls.
- The legacy `_ux.session.mcq` / `_ux.session.frq` routes; the `/setup` wizard.
- Republish to cramapple.com (Hard-Gate, David).

## Routes / Components / Systems Affected

`/session` header chrome (SessionShell Region 1), SessionFrame controls,
SessionHamburgerMenu (its session items promoted/folded into the new affordance).

## Data / Security / Integration Impact

None — display + existing client-side actions only.

## Acceptance Criteria

1. The session header shows mode + "~N min" + Unit/topic in plain language; honest
   fallback for recommendation-scoped sessions.
2. A progress bar reflects counted items completed ÷ N; it does not move during
   teach or confirm-transfer sub-beats and advances exactly once per counted item;
   "Question k of N" text remains; proper `role="progressbar"` a11y.
3. The line offers an edit affordance exposing change-minutes, change-topic, and
   end-session (existing actions); one clear home for these controls; keyboard
   accessible.
4. No timer or time-based display anywhere on the session; mobile reflow keeps the
   answer control on-screen.

## QA Plan

- Review the Lovable build report + diff against the brief's report items (a)–(e).
- Preview walkthrough on a Statistics session: params line content, bar pinning
  through a confirm-transfer beat, inline edits.
- Fresh-context QA per `AGENT_OPERATING_MODEL.md` before Done.

## Implementation Summary

- 2026-08-26 21:16 UTC — brief sent to Lovable (`umsg_01m0zyw97cfc1afkddavmrma6e`).
- 2026-08-26 21:21 UTC — **build landed** (`exam-buddy-wireframe` `8a08db8`
  "Added session params bar"). Verified in the repo:
  - New `SessionParamsBar.tsx` (~300 lines): params line + items-primary
    progress bar + the single inline "Adjust" popover (minutes "this session
    only", change topic, end session — promoted from the hamburger).
  - New pure helpers `src/lib/session/session-params.ts`
    (`lengthLabel`/`scopeLabel`/`displayedIndex`/`completedItems`/
    `progressFraction`) with an 80-line vitest file; the bar uses the SAME
    pinned index as `progressLabel()`, so confirm-transfer/teach sub-beats
    cannot advance it.
  - `SessionShell`/`SessionFrame`/`use-session`/`session.index` wired; topic
    names rendered plain-language, minutes shown as the student's estimate,
    no countdown anywhere.

## Test Results

(pending)

## Risks / Issues

- The progress bar must read the pinned display index, not the raw queue cursor —
  a raw-cursor bar would visibly jump during confirm-transfer (the exact
  double-advance class of bug TASK-0029's sibling brief fixed).

## Approval State

Scope approved by David 2026-08-26 (direct instruction in-session). Republish to
production remains a David-held Hard-Gate.

## QA Result

(pending)

## Done Decision

(pending)
