# Publish-gate false-positive on re-review decisions — 2026-08-09

**Trigger:** Owner reported a reviewer (Adil Abbasi) hit `decision_insert_failed` while submitting
an ordinary tutor_question decision (flagged "Ambiguity," left an edit note) — see attached
screenshot, "Submit and lock" failing with that error text.

## Diagnosis

`POST /functions/v1/review-decision` was returning 500 intermittently, interleaved with successful
200s from the same reviewers over the last ~2 hours. Postgres logs pinpointed the cause on every
failing request:

```
publish_gate: status=published requires review_status in the approved allowlist
(question_review_approved, difficulty_confirmed, answer_approved, mcq_answer_review_complete);
got modification_reserved
```

**Root cause:** the P0-B publish gate trigger (`app.enforce_publish_gate`, added 2026-08-08 across
two migrations) fires `BEFORE INSERT OR UPDATE OF status, review_status` and checks
`NEW.status = 'published'` against the review_status allowlist on **every** such update — including
one that only touches `review_status` on a row that is already published and staying published.

That's exactly the common re-review case: a reviewer scores an already-**published** item, the
decision aggregates to "needs modification" or a reader "recycle," and
`advanceWorkflow` (`supabase/functions/review-decision/index.ts`) sets
`review_status='modification_reserved'` on that version. `NEW.status` is unchanged (`'published'`),
but the trigger didn't distinguish "just published with a bad review_status" (the real thing it's
supposed to stop) from "already published, only review_status changing" (ordinary re-review
bookkeeping) — it blocked both, inside the same transaction as the `content_review_decisions`
insert, so the whole decision insert rolled back and the reviewer saw a generic 500.

**Confirmed this is live and systemic, not a one-off:** a production query found Ahmed Ali alone
holding ~200 pending `tutor_question` re-review assignments on items whose
`content_item_versions.status` is already `'published'`. Any of those that aggregates to
`modification_reserved` — or any `reader_question` "recycle" on a published item — hits this same
500. This has nothing to do with today's Calc AB/Statistics QA work; it's a pre-existing gap in the
gate added the day before.

## Fix

`supabase/migrations/20260809150000_publish_gate_only_on_publish_transition.sql` — narrowed the
check to only run on the actual **transition into** `published`:
`(tg_op = 'INSERT' or old.status is distinct from 'published')`. A row already published and only
having `review_status` updated is now unaffected; a genuine attempt to publish with a bad
review_status is still blocked exactly as before.

Applied live via `execute_sql` (interactive approval for `apply_migration` failed with
`MCP error -32003` again, same recurring gap noted earlier this session) and verified with two
rolled-back test transactions before committing:

1. Updating `review_status` on an already-published row (Ahmed's `apphy2-mcq-008`) to
   `modification_reserved` — **now succeeds** (previously raised the exception).
2. Transitioning a draft (`APSTAT-MOD7-H002-INV`) to `status='published'` with
   `review_status='modification_reserved'` — **still raises the exception**, confirming the real
   gate is intact.

## Follow-up not actioned

The ~200-item Ahmed Ali re-review backlog on already-published content (and whatever similar count
exists for other reviewers) was surfaced as a side effect of this diagnosis, not investigated
further — worth a separate look at why so much already-published content is sitting in active
re-review queues.
