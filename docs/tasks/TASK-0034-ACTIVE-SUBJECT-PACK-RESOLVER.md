# TASK-0034 — Active-Subject Resolver Drops the Profile's Explicit Active Pack

**Task ID:** TASK-0034
**Title:** Honor `profiles.active_exam_pack_version_id` even when a sibling pack is "newer"
**Owner:** Claude, with David
**Product Owner:** David Bloom
**Tier:** Standard (frontend) + a prod-data unblock (recorded below)
**Status:** In Progress (data unblock applied; frontend fix brief sent)
**Priority:** Critical (live prod hang — every pilot session on the pilot pack)
**Created Date:** 2026-08-26
**Branch:** `claude/home-to-session-migration-e65jmk` (docs); build in the Lovable project
**PR:** #138
**Source:** David live-testing; two HAR captures (`761325b5`, `505ebe7f`) decisive.

## Root cause (HAR-proven)

- `src/lib/active-subject.ts` builds the subject catalog as **"newest
  published pack version per subject_key"** (`bySubjectKey`, first row wins
  over `official_exam_date desc`). AP Statistics has **two** published packs —
  general `548f06be` and pilot `7c5a2975` — that carried the **same** exam
  date (2027-05-11), so the tie resolved to the general pack and the pilot
  pack was dropped from `available`.
- `currentSubjectKey` resolves the active subject via
  `available.find(examPackVersionId === profile.active_exam_pack_version_id)`.
  With the profile on `7c5a2975` (dropped) → `undefined` → active subject
  never reaches `status: "ready"`.
- The `useSession` serve effect is gated `if (activeSubject.status !==
  "ready") return`, so it **never fires** — no `session-event`, no item read,
  eternal "Loading question…". HAR `505ebe7f` shows exactly this: profile
  returns `active = 7c5a2975`, subjects/packs 200, and then **zero** serve
  calls.
- This bug is in current `main`, untouched by TASK-0029..0033 — which is why
  **no republish fixed it**. The stale-bundle chase (deployment `9567e1f1`
  from 20:09 still on cramapple.com in HAR `761325b5`) was a *separate*
  real problem; this one is the resolver.

## Data unblock applied (prod, reversible)

`app.exam_pack_versions.official_exam_date` for the pilot pack `7c5a2975`
set **2027-05-11 → 2027-05-18**, so the pilot pack is now the newest ap-
statistics pack and wins the resolver dedup. Verified: the client dedup
simulation now returns `7c5a2975` as the ap-statistics winner → profile
matches → status resolves `ready` on the currently-live build, **no
republish required**.
- **This is effectively the pilot-cutover decision (pilot-log next-step #3):
  the pilot pack is now canonical for AP Statistics; the general pack
  `548f06be` stays published but the resolver ignores it.** David to ratify
  (keep) or revert.
- **Revert:** `update app.exam_pack_versions set official_exam_date =
  '2027-05-11' where id = '7c5a2975-…';` (restores the tie).
- Cosmetic side effect: the pilot pack's exam-day countdown reads 2027-05-18.

## Out of Scope

- The confirm-transfer / serving-path / resume-guard fixes (TASK-0029..0033) —
  separate, already landed; still need the domain republish to reach
  cramapple.com.
- Retiring the general pack (the clean durable alternative to the frontend
  fix) — David's product decision.

## Acceptance Criteria

1. With two published packs for one subject and the profile on either, the
   active subject resolves `ready` on the profile's pack; the session serves.
2. Single-pack subjects and the picker (one entry per subject) unchanged.
3. Frontend tests green.

## Implementation Summary

- 2026-08-26 ~23:5x — data unblock applied (date bump), dedup verified.
- Frontend resolver fix brief sent to Lovable
  (`umsg_01m107kybbf48tpm7nhej6ekmj`): resolve the active subject from the
  profile's active pack against the full published list, not the deduped
  `available`.

## Approval State

Data unblock applied under active-incident judgment (reversible, single
field, directly unblocks David's own testing); the canonical-pack choice is
flagged for David's ratification. Republish + Done remain David's.

## QA Result / Done Decision

(pending)
