-- Move half of Ahmed Ali's pending Physics tutor_question backlog to
-- Muhammad Saood so Ahmed can reach the gold-set queue sooner, 2026-08-09.
--
-- Ahmed had 213 pending physics assignments (58 C:Mech, 56 C:E&M, 54
-- Physics 2, 45 Physics 1). Attempting to move a proportional half (106)
-- hit "duplicate key value violates unique constraint" on 76 of them:
-- Saood already has a row (submitted or withdrawn) for the same
-- content_item_version_id + review_stage -- he's already the blind partner
-- on most of Ahmed's queue and has 522 physics decisions submitted, zero
-- pending. Only 30 items (10 each in Physics 2, C:E&M, C:Mechanics; none in
-- Physics 1) had no existing Saood row at all -- those are the only ones
-- genuinely movable without a conflict, so those 30 are what moved.
--
-- Net effect on Ahmed's remaining 183 pending: 153 already have Saood's
-- submitted decision (Ahmed is the second/last reviewer, all 153 of
-- Saood's decisions there are approve or approve_with_edits, none
-- disapprove) and 30 have only a withdrawn other-reviewer row (Ahmed is
-- effectively sole/first reviewer on those).

begin;

create temporary table to_move on commit drop as
with ahmed_pending as (
  select cra.content_review_assignment_id, cra.content_item_version_id, cra.review_stage, cra.review_kind, cra.assignment_purpose, cra.created_by,
    s.display_name as subject,
    row_number() over (partition by s.display_name order by cra.created_at) as rn,
    count(*) over (partition by s.display_name) as subject_total
  from app.content_review_assignments cra
  join app.content_item_versions v on v.id=cra.content_item_version_id
  join app.content_items ci on ci.id=v.content_item_id
  join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
  join app.exam_packs ep on ep.id=epv.exam_pack_id
  join app.subjects s on s.id=ep.subject_id
  where cra.reviewer_id=(select user_id from app.profiles where full_name='Ahmed Ali')
    and cra.status='pending'
)
select * from ahmed_pending where rn <= (subject_total / 2);

delete from to_move tm
where exists (
  select 1 from app.content_review_assignments existing
  where existing.content_item_version_id = tm.content_item_version_id
    and existing.review_stage = tm.review_stage
    and existing.reviewer_id = (select user_id from app.profiles where full_name='Muhammad Saood')
);

with withdrawn as (
  update app.content_review_assignments cra
  set status='withdrawn'
  from to_move tm
  where cra.content_review_assignment_id = tm.content_review_assignment_id
  returning cra.content_review_assignment_id, tm.content_item_version_id, tm.review_stage, tm.review_kind, tm.assignment_purpose, tm.created_by
)
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select gen_random_uuid(), w.content_item_version_id, (select user_id from app.profiles where full_name='Muhammad Saood'), w.review_stage, w.review_kind, 'pending', w.assignment_purpose, w.created_by
from withdrawn w;

commit;
