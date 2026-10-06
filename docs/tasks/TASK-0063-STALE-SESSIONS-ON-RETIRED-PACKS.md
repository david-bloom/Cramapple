# TASK-0063 — Stale "Active" Sessions on Retired Packs Lock Students Out of Subject Switching

**Status:** Open — not started  
**Tier:** Hard-Gate (Production data writes and a backend behavior change)  
**Owner:** TBD  
**Product Owner:** David Bloom  
**Date opened:** 2026-10-05  
**Related:** `APPROVAL-0121` (one-account cleanup), `DECISION-0097`  
**Area:** Sessions / subject switching / pack retirement

## What happened

On 2026-10-05 David signed in and could not switch subjects, and was pushed back into an old flow.
Verified in Production (read-only, then one approved cleanup):

- His profile still pointed at exam-pack version `7c5a2975…`, which was **retired on 2026-09-25**.
- He had **82** `app.learning_sessions` rows on that pack still marked `active`, created 2026-08-27 to
  2026-09-27.
- `public.set_active_exam_pack_version` raises `active_session_blocks_subject_switch` (errcode
  `55000`) when the current pack has any active session. PostgREST returned this as HTTP 500; eight
  such 500s were logged between 23:33:29 and 23:33:43 UTC, just after his 23:33:21 sign-in.
- A new session was still being created on the retired pack at 23:35:42 UTC, so the app keeps
  starting work on a pack that is no longer servable.

His 82 sessions were archived under `APPROVAL-0121`. Before the cleanup, Production held 86 active
sessions across 4 users, and **all 82 on retired packs were David's**; after it, the count below
returned 0. So no student is stuck today, but nothing prevents the next pack retirement from doing
the same to anyone mid-session. Re-run the count before acting.

## Why it matters

Any student whose pack is retired while they have an unfinished session is locked out of subject
switching with a generic server error, and can be steered back into the retired pack. Pack
retirement is routine in the content pipeline, so this recurs every time content is refreshed.

## Required outcome

1. Retiring an exam-pack version closes (archives) the `active` sessions on it, in the same change.
2. `set_active_exam_pack_version` does not block a switch away from a **retired** pack because of
   sessions on it, and returns a clear, mapped error instead of HTTP 500 when it does block.
3. A student whose active pack is retired is moved to the current version of the same subject (or
   asked to pick), not resumed into the retired one.
4. A one-time cleanup of any remaining active sessions on retired packs, with the row count
   recorded.

## Verification

- [ ] Count before and after: `active` sessions joined to `exam_pack_versions` with
      `retired_at is not null` → 0 after.
- [ ] Retire a pack in Development with an active session on it → session archived, switch works.
- [ ] Switching away from a retired pack succeeds; a blocked switch returns a mapped error, not 500.
- [ ] A student on a retired pack lands on the current version or the subject picker on `/home`.
- [ ] Production change on David's explicit approval.

## Count query

```sql
select count(*) as active_on_retired, count(distinct ls.user_id) as users
from app.learning_sessions ls
join app.exam_pack_versions v on v.id = ls.exam_pack_version_id
where ls.status = 'active' and v.retired_at is not null;
```
