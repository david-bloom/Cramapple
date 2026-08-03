-- Dispose of Qamar Ul Zaman's outstanding review assignments (2026-07-31).
--
-- Owner instruction (David Bloom): Qamar is off the reviewer roster. His 8
-- pending AP Precalculus MCQ assignments are the unfinished tail of
-- `qamar-precalculus-25-abdul-comparison-2026-07-29`.
--
-- Coverage is preserved. Every one of the 8 versions already carries two
-- SUBMITTED independent reads (Abdul Hanan and Muhammad Saood), and all 8 are
-- already `reviewed_approved`. Skipping Qamar's pending rows removes no review
-- evidence and leaves no item under-read.
--
-- His 16 submitted decisions are NOT touched — they remain on record.
-- No qualification is revoked: packets are push-assigned, so omitting him from
-- future packets is sufficient to remove him from the queue.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-dispose-qamar-pending-20260731')
);

-- Guard: only pending rows, only where two other readers have already submitted.
create temporary table targets on commit drop as
select a.content_review_assignment_id
from app.content_review_assignments a
where a.reviewer_id = 'ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
  and a.status = 'pending'
  and (
    select count(*) from app.content_review_assignments peer
    where peer.content_item_version_id = a.content_item_version_id
      and peer.reviewer_id <> a.reviewer_id
      and peer.review_stage = 'tutor_question'
      and peer.status = 'submitted'
  ) >= 2;

do $$
declare n int; total int;
begin
  select count(*) into n from targets;
  select count(*) into total from app.content_review_assignments
   where reviewer_id='ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid and status='pending';
  if n <> 8 or total <> 8 then
    raise exception
      'expected 8 guarded targets covering all 8 pending rows, found % of %', n, total;
  end if;
end $$;

update app.content_review_assignments a
set status = 'skipped'
from targets t
where a.content_review_assignment_id = t.content_review_assignment_id;

-- Verify: Qamar holds no pending or in-progress work, decisions intact.
select
  (select count(*) from app.content_review_assignments
    where reviewer_id='ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
      and status in ('pending','in_progress')) as still_open,
  (select count(*) from app.content_review_assignments
    where reviewer_id='ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
      and status='skipped') as skipped,
  (select count(*) from app.content_review_decisions
    where reviewer_id='ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid) as decisions_preserved;

commit;
