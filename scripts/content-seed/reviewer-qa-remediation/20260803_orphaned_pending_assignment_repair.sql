-- Repair: assignments reset to 'pending' on top of an existing immutable decision.
--
-- SYMPTOM. Reviewers cannot submit. `review-decision` returns `assignment_locked`
-- (surfaced in the reviewer UI as "assignment_assignment_locked" — the client
-- prefixes the code, which is a separate cosmetic defect). Abdul Hanan reported
-- being blocked on every question 2026-08-03.
--
-- ROOT CAUSE. The four 2026-08-03 early-year packet scripts each end their
-- assignment upsert with:
--
--     on conflict (content_item_version_id, reviewer_id, review_stage)
--     do update set status = 'pending';
--
-- with no guard on the existing status. Any item the reviewer had already
-- reviewed was flipped back to 'pending' while its decision row — immutable by
-- design — stayed. `app.enforce_review_submission_lock` then refuses the resubmit
-- because a decision already exists for that assignment, which is correct
-- behaviour reacting to corrupted state.
--
-- The re-open those scripts attempted is not achievable in this schema: the same
-- (content_item_version_id, reviewer_id, review_stage) triple cannot carry a
-- second decision, so an already-reviewed item must be SKIPPED by a packet, not
-- reset. Restoring 'submitted' therefore legitimately shrinks the affected
-- packets — those items were already reviewed by that reviewer.
--
-- This is a recurrence of the class corrected in place on 2026-08-02 (9 rows,
-- Adil/Jill). That fix repaired data without fixing the upsert that produces it;
-- the guard added to the four scripts alongside this repair is the actual fix.
--
-- SAFETY. Restores an invariant the database already enforces: a decision exists
-- if and only if its assignment is closed. It creates no decisions, deletes
-- nothing, and touches only rows that are provably inconsistent.

begin;

-- Pre-state, for the record.
select p.full_name, count(*) as orphaned
from app.content_review_assignments a
join app.content_review_decisions d
  on d.content_review_assignment_id = a.content_review_assignment_id
join app.profiles p on p.user_id = a.reviewer_id
where a.status = 'pending'
group by 1 order by 2 desc;

update app.content_review_assignments a
set status = 'submitted'
where a.status = 'pending'
  and exists (
    select 1 from app.content_review_decisions d
    where d.content_review_assignment_id = a.content_review_assignment_id
  );

-- Must return zero rows.
select count(*) as remaining_orphans
from app.content_review_assignments a
join app.content_review_decisions d
  on d.content_review_assignment_id = a.content_review_assignment_id
where a.status = 'pending';

commit;
