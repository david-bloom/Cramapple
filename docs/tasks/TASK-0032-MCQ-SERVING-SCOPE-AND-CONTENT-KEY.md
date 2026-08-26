# TASK-0032 — MCQ Serving Fixes: Scope to the Student's Selection + Real content_key

**Task ID:** TASK-0032
**Title:** Fix MCQ practice ignoring unit/topic scope; stop faking `content_key` with the title
**Owner:** Claude, with David
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** In Progress (fix brief sent to Lovable; build pending review)
**Priority:** High (both defects break the pilot session experience)
**Created Date:** 2026-08-26
**Approved Date:** 2026-08-26 (David relayed Lovable's findings for action)
**Branch:** `claude/home-to-session-migration-e65jmk` (docs); build lands in the Lovable project (`exam-buddy-wireframe`)
**PR:** #138
**Source:** Two findings reported by Lovable, relayed by David 2026-08-26; both
**verified in code** before the fix was commissioned.

## The two defects (verified)

1. **`content_key` faked with the display title.** `use-session.ts` MCQ branch
   sets `content_key: m.title ?? m.contentItemVersionId`; the real column is
   never selected (`PUBLISHED_MCQ_SELECT` omits it). `findPilotSkillByContentKey`
   parses the generator's stable key prefix, which a title never matches — so
   the plain-language skill rail, authored brief/explainer, and the mandatory
   confirm-transfer beat (spec §3.3, David's §7.1(b) decision) never trigger in
   MCQ sessions.
2. **Format-MCQ practice ignores the chosen unit/topic and loads the whole
   catalog.** The `selectedFormat === "mcq"` path loads every published MCQ for
   the exam pack (`buildPublishedMcqQuery`: epv + published + mcq only,
   `published_at` asc) — `selectedUnit`/`selectedTopicIds` never applied, and
   `questionTotal` becomes the catalog size.

## Fix commissioned (brief `umsg_01m101688besaba51c70jvt96f`)

- Select + map the real `content_key` end-to-end; never the title.
- Client-side scoping via `pilotCellFromContentKey` (the only student-readable
  attribution; it never guesses): topic filter, else unit filter; unresolvable
  keys are excluded under a scoped request; empty scope → honest
  content-unavailable message, never a whole-subject fallback.
- Cap loaded MCQs at 8 (the server path's limit) scoped or not.
- Vitest coverage for select/mapping and a pure scoping helper.

## Out of Scope

- Server-side topic-scoped MCQ serving via `student-session-items` (the fuller
  fix — backend, Cramapple repo, separate task if wanted).
- Confirm-transfer machine changes; republish (David-held).

## Acceptance Criteria

1. AP Statistics MCQ items resolve their pilot skill again: rail, brief, and
   confirm-transfer fire.
2. Scoped format-MCQ practice serves only matching items (≤8); no match →
   honest empty message.
3. Build green; new tests pass.

## Implementation Summary

- 2026-08-26 ~21:5x UTC — both findings verified in code; fix brief sent.

## Approval State

David relayed the findings for action (2026-08-26); fix is frontend-only within
the session's approved lane. Republish remains a David-held Hard-Gate.

## QA Result / Done Decision

(pending)
