# TASK-0031 — Wire the Home Skills Rail to the Learn-First Door (E3)

**Task ID:** TASK-0031
**Title:** Home skills rail → real pilot skills → `/session?intent=learn&skill=<slug>`
**Owner:** Claude, with David
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** In Progress (brief sent to Lovable; build pending review)
**Priority:** High (unblocks the learn experience's UI path; companion to TASK-0029/0030)
**Created Date:** 2026-08-26
**Approved Date:** 2026-08-26 (David: "go ahead and send the rail-wiring brief to Lovable")
**Branch:** `claude/home-to-session-migration-e65jmk` (docs); build lands in the Lovable project (`exam-buddy-wireframe`)
**PR:** #138
**Source:** David's 2026-08-26 question "we created a new design for the learn
experience — where is it and why is it not deployed?" — investigation found the
session side of the learn-first design (spec §5, canvas §3.6) built and in the
deployed bundle, but unreachable: the Home "Skills" rail is a placeholder stub
(`PLACEHOLDER_SKILLS`, no-op click, fake evidence dots).

## Product Goal

Open the E3 door: clicking a skill on the Learn home starts the learn-first
entry (`/session?intent=learn&skill=<slug>` — coached orientation + worked
example, then the student's own cold attempt). Replace placeholder rail data
with the real ten pilot skills and remove the fabricated evidence states the
rail currently apologizes for.

## Technical Scope

- Frontend only. Build brief message `umsg_01m0zzjvemfmstah9g2y15d325`
  (sent 2026-08-26).
- `TopicHome.tsx` rail: rows from `STATS_UNIT1_SKILLS` (name + descriptor);
  click navigates to `/session` with `{ intent: "learn", skill: slug }`.
- Honesty: fake `new/building/strong` dots, legend, and "Preview only" caption
  removed; rail ships stateless until real evidence wiring exists.
- Rail rendered only for AP Statistics (`ap-statistics`), labeled Unit 1;
  hidden for other subjects.

## Out of Scope

- Real per-skill evidence states on the rail (needs `student_cell_state`
  rollup — future build).
- Any session-side change (`session.index`, SessionFrame, confirm-transfer,
  use-session) — already built.
- Release of the E3 authored content (orientations + open-hand worked
  examples — DRAFT pending David's D8/SME review; the opener falls back
  gracefully where no explainer is released).
- Republish to cramapple.com (Hard-Gate, David).

## Acceptance Criteria

1. On the AP Statistics Learn home, the rail lists the ten pilot skills
   (plain language, no codes); hover/focus shows each descriptor.
2. Clicking a row lands on `/session?intent=learn&skill=<slug>`; resolved
   skills open the learn-first flow, unresolved slugs degrade to plain review.
3. No fabricated evidence states, legend, or "Preview only" caption remain.
4. Non-Statistics subjects show no skills rail.

## QA Plan

- Lovable report (a)–(e) reviewed against the brief; diff verified in the repo.
- Preview walkthrough: click at least one MCQ skill and one numeric skill
  (1.7/1.9) from the rail.
- Fresh-context QA before Done.

## Implementation Summary

- 2026-08-26 ~21:3x UTC — brief sent (`umsg_01m0zzjvemfmstah9g2y15d325`);
  build pending.

## Risks / Issues

- Until the E3 authored content is released, a rail click serves the learn
  door with whatever explainer the topic guides already carry (or none —
  graceful cold fallback). The full designed experience needs David's content
  sign-off; this task only opens the UI path.

## Approval State

Scope approved by David 2026-08-26 (explicit go in-session). Content release
and republish remain David-held.

## QA Result / Done Decision

(pending)
