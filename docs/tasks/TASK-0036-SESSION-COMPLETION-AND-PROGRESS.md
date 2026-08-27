# TASK-0036 — Session Never Completes (runs past N; progress bar never fills)

**Task ID:** TASK-0036
**Owner:** Claude, with David
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** In Progress (fix brief sent to Lovable)
**Priority:** High (student-facing defect on the live pilot)
**Created:** 2026-08-27
**PR:** #138
**Source:** David live: "able to continue past 8/8 (e.g. Question 14 of 8) and
the progress bar never hit full."

## Root cause (one cause, both symptoms)

`src/lib/course-mode/transfer-machine.ts` `queueReducer` `advance` action clamps
`itemCursor` to `itemsLength - 1` (so the last item re-serves forever) while
`questionIndex` increments **unbounded** → "Question 14 of 8". And
`progressFraction` (`session-params.ts`) = `(displayedIndex - 1) / total` with
`displayedIndex` clamped to `[1, total]`, so it maxes at `(total-1)/total` and
**can never reach 1.0**. Underlying gap: the `/session` container has **no
completion transition** — `endSession` is only the manual button; the spec §4
wrap-up was designed but never built.

## Fix commissioned (brief `umsg_01m10dgpfafqhv8qpkm19pd25c`)

Frontend-only: (1) reducer transitions to a terminal `complete` when advancing
past the last item (no clamp-and-re-serve; `questionIndex` capped at
`itemsLength`); (2) `SessionFrame` renders an honest completion screen (bar at
100%, "N of N", Back to home + optional gated "One more?"); (3) header index
uses the clamped `displayedIndex`, never the raw `questionIndex`; (4)
confirm-transfer pinning unchanged. Tests on the reducer + progress math.

## Out of Scope

- The rich §4 wrap-up (what-moved / what-returns / calibration nudge) — a
  fast-follow; this task's must-fix is stop-looping + honest completion + bar
  fills.
- Any backend change.

## Acceptance Criteria

1. Answering the last counted item ends the session (no re-serving); the header
   never shows an index > total.
2. The progress bar reaches 100% at completion.
3. Confirm-transfer sub-beat pinning unchanged.
4. Reducer + progress tests green.

## Implementation Summary

- 2026-08-27 — brief sent (`umsg_01m10dgpfafqhv8qpkm19pd25c`); build pending.

## Approval State

Frontend defect fix within the session's approved scope. Republish remains
David's.
