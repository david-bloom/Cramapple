-- Reassign Ghazanfar Ali's tutor_question backlog away from him, 2026-08-17.
-- Owner direction: "Give it all to Saood. I assign Ghazanfar. Too unreliable."
--
-- Ghazanfar had 48 pending tutor_question assignments. Investigation before
-- acting (a corrected earlier query -- see doc note below -- had wrongly
-- reported Saood untouched by any of these):
--
-- - 45 of the 48 already have a SUBMITTED decision from Muhammad Saood.
--   Of those 45, checking the actual current/latest content_item_version
--   for each item shows every single one was ALREADY resolved independently
--   of this Ghazanfar/Saood pairing:
--     - 36 point to a version that's no longer the item's latest (9 to a
--       'changes_requested' version replaced by a newer one already in
--       flight through a separate remediation, 1 already 'retired' in favor
--       of a newer approved version already published)
--     - 9 point to the item's actual live version, which is already
--       'published' with review_status='question_review_approved' -- fully
--       resolved and correctly published through a different review pairing
--   In every one of these 45 cases, Ghazanfar's assignment was stale/
--   orphaned: the item's real fate was already settled elsewhere, and the
--   pending assignment was never advancing anything. No content_item_versions
--   or content_items state needs to change here -- withdrawing the dead
--   assignment IS accepting Saood's already-effective outcome; there's
--   nothing left to approve.
-- - The remaining 3 (all MCQ: apphy1-mcq-np2-005/006/007) are genuinely
--   still in flight (content_items.status='assigned') and Saood has never
--   touched them. These get a fresh pending assignment for Saood as sole
--   reviewer.
--
-- All 48 of Ghazanfar's pending assignments are withdrawn either way.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-reviewer-reassignment-20260817'));

create temporary table ghaz_targets as
select cra.content_review_assignment_id, cra.content_item_version_id, cra.review_stage,
       cra.review_kind, cra.blind_group_id, cra.assignment_purpose
from app.content_review_assignments cra
join app.profiles p on p.user_id = cra.reviewer_id
where cra.status = 'pending'
  and p.full_name = 'Ghazanfar Ali'
  and cra.review_stage = 'tutor_question';

do $$
declare n integer;
begin
  select count(*) into n from ghaz_targets;
  if n <> 48 then
    raise exception 'expected 48 pending Ghazanfar tutor_question assignments, found %', n;
  end if;
end $$;

-- Withdraw all 48 (audit trail preserved, not deleted).
update app.content_review_assignments cra
set status = 'withdrawn'
from ghaz_targets t
where cra.content_review_assignment_id = t.content_review_assignment_id;

-- Fresh Saood assignment only for the 3 items he's never reviewed.
insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, blind_group_id, status, assignment_purpose, created_by
)
select
  gen_random_uuid(),
  t.content_item_version_id,
  (select user_id from app.profiles where full_name = 'Muhammad Saood'),
  t.review_stage,
  t.review_kind,
  t.blind_group_id,
  'pending',
  t.assignment_purpose,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from ghaz_targets t
where t.content_item_version_id in (
  '1acd1779-aa9c-437b-84a3-7c7492799ca6',
  '596f85aa-b0f3-43ac-a0c2-24bc6f014d0d',
  'a165f5ae-90f5-473b-8506-928233cdf5d4'
);

do $$
declare n integer;
begin
  select count(*) into n from app.content_review_assignments cra
    join app.profiles p on p.user_id = cra.reviewer_id
    where cra.status = 'pending' and p.full_name = 'Ghazanfar Ali' and cra.review_stage = 'tutor_question';
  if n <> 0 then raise exception 'Ghazanfar still has % pending tutor_question assignments', n; end if;

  select count(*) into n from app.content_review_assignments cra
    join app.profiles p on p.user_id = cra.reviewer_id
    where cra.status = 'pending' and p.full_name = 'Muhammad Saood' and cra.review_stage = 'tutor_question';
  if n <> 3 then raise exception 'expected 3 fresh pending Saood tutor_question assignments, got %', n; end if;

  -- No published item should have an unresolved review flag as a result of this change.
  select count(*) into n from app.content_item_versions where status='published' and review_status in ('excluded','modification_reserved');
  if n <> 0 then raise exception 'P0-B net check non-zero after reassignment: %', n; end if;
end $$;

select p.full_name as reviewer, cra.review_kind, count(*) as pending_count
from app.content_review_assignments cra
join app.profiles p on p.user_id = cra.reviewer_id
where cra.status = 'pending' and cra.review_stage = 'tutor_question'
  and p.full_name in ('Ghazanfar Ali', 'Muhammad Saood')
group by 1, 2
order by 1, 2;

commit;
