-- Move half of Ahmed Ali's pending Physics tutor_question backlog to Ghazanfar Ali,
-- 2026-08-11, owner-directed ("Assign half of the In Review physics questions to
-- Ghazanfar Ali").
--
-- Ahmed had 102 pending physics subject_review assignments (34 Physics 1, 19 Physics 2,
-- 23 C:E&M, 26 C:Mechanics) -- the entire physics "In Review" pending queue; no other
-- reviewer held any pending physics subject_review assignment at sweep time. Ghazanfar
-- Ali is actively qualified for all four physics subjects (validator_qualifications).
--
-- Moved the OLDEST assigned_at items per subject first, split as close to an exact
-- 51/51 (half of 102) as the four subject counts allow: Physics 1 17/34, Physics 2
-- 10/19, C:E&M 11/23, C:Mechanics 13/26.
--
-- Same "Ghazanfar withdrawal orphan" situation as the 2026-08-08 log entry (he
-- previously withdrew from a large batch, leaving 'withdrawn' assignment rows under his
-- reviewer_id for many of these same versions): 51 of the 102 candidates already carried
-- a withdrawn Ghazanfar row, which blocks simply repointing Ahmed's row to him (unique
-- constraint on content_item_version_id+reviewer_id+review_stage). For those 9 selected
-- items with a prior withdrawn row (see per-subject counts in the verification below),
-- the existing row is revived to 'pending' instead, and Ahmed's row is marked 'skipped'
-- (the same convention used throughout the remediation scripts for superseded
-- assignments) rather than deleted, preserving the audit trail. The remaining 42
-- selected items had no prior Ghazanfar row and were reassigned directly.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-ghazanfar-physics-reassign-20260811'));

create temporary table move_targets on commit drop as
with candidates as (
  select cra.content_review_assignment_id as ahmed_assignment_id,
         cra.content_item_version_id,
         sub.display_name as subject, cra.assigned_at,
         g.content_review_assignment_id as ghazanfar_existing_assignment_id,
         g.status as ghazanfar_existing_status
  from app.content_review_assignments cra
  join app.content_item_versions civ on civ.id=cra.content_item_version_id
  join app.content_items ci on ci.id=civ.content_item_id
  join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
  join app.exam_packs ep on ep.id=epv.exam_pack_id
  join app.subjects sub on sub.id=ep.subject_id
  left join app.content_review_assignments g
    on g.content_item_version_id=cra.content_item_version_id
    and g.review_stage='tutor_question'
    and g.reviewer_id='8328a005-eea2-4f0a-a540-8fe739f88be8'
  where cra.assignment_purpose='subject_review'
    and cra.status='pending'
    and cra.reviewer_id='2b29b40a-6c00-49f8-9bfa-7e3d9e81f9ae'
    and sub.display_name ilike '%physics%'
),
ranked as (
  select *, row_number() over (partition by subject order by assigned_at asc) as rn
  from candidates
)
select ahmed_assignment_id, content_item_version_id, subject, assigned_at,
       ghazanfar_existing_assignment_id, ghazanfar_existing_status
from ranked
where rn <= case subject
  when 'AP Physics 1' then 17
  when 'AP Physics 2' then 10
  when 'AP Physics C: Electricity and Magnetism' then 11
  when 'AP Physics C: Mechanics' then 13
end;

do $$ declare n int; begin
  select count(*) into n from move_targets;
  if n<>51 then raise exception 'expected 51 move targets, got %', n; end if;
end $$;

-- Path 1: no prior Ghazanfar row -- reassign Ahmed's row directly.
update app.content_review_assignments cra
set reviewer_id='8328a005-eea2-4f0a-a540-8fe739f88be8'
from move_targets mt
where cra.content_review_assignment_id=mt.ahmed_assignment_id
  and mt.ghazanfar_existing_assignment_id is null;

-- Path 2: prior withdrawn Ghazanfar row exists -- revive it, skip Ahmed's row.
update app.content_review_assignments cra
set status='pending', assigned_at=now()
from move_targets mt
where cra.content_review_assignment_id=mt.ghazanfar_existing_assignment_id
  and mt.ghazanfar_existing_assignment_id is not null;

update app.content_review_assignments cra
set status='skipped'
from move_targets mt
where cra.content_review_assignment_id=mt.ahmed_assignment_id
  and mt.ghazanfar_existing_assignment_id is not null;

do $$ declare n int; begin
  select count(*) into n
  from app.content_review_assignments cra
  where cra.assignment_purpose='subject_review'
    and cra.status='pending'
    and cra.reviewer_id='8328a005-eea2-4f0a-a540-8fe739f88be8'
    and cra.content_item_version_id in (select content_item_version_id from move_targets);
  if n<>51 then raise exception 'expected 51 pending Ghazanfar physics assignments after move, got %', n; end if;
end $$;

commit;
