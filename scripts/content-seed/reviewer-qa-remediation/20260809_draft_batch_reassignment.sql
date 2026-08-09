-- Draft-backlog reassignment, 2026-08-09 (owner-directed).
--
-- Follow-up to 20260809_physics_draft_frq_qa_and_assign.sql: owner
-- re-distributed the full remaining draft backlog across reviewers:
--
-- 1. The 30 physics FRQs (assigned to Muhammad Saood earlier the same day)
--    reassigned to Ahmed Ali instead -- withdrew Saood's pending
--    tutor_question assignments and inserted fresh ones for Ahmed.
-- 2. AP Calculus AB (23 items: 8 FRQ + 15 MCQ) assigned to Abdul Hanan.
-- 3. AP Statistics (48 items: 47 MCQ + 1 FRQ) -- owner initially asked for
--    a 30/18 split (Saood/Shazia), but Muhammad Saood has no active
--    `validator_qualifications` row for AP Statistics
--    (exam_id ff732d79-b274-44c5-8beb-cd27f5f5219e) -- the
--    tg_enforce_content_review_qualification trigger correctly rejected
--    the insert. Only Jill Schmidlkofer and Shazia Fazal currently hold an
--    active Statistics grading qualification. Owner chose: give all 48 to
--    Shazia Fazal instead of a 30/18 split.
--
-- Result: 0 items remain in status='draft' across AP Calculus AB, AP
-- Statistics, and the three Physics subjects that had a draft backlog.
-- All content_items.status moved from 'draft' to 'assigned'.

begin;

-- 1. Reassign the 30 physics FRQs from Saood to Ahmed Ali.
update app.content_review_assignments
set status='withdrawn'
where reviewer_id='cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
  and review_stage='tutor_question' and status='pending'
  and content_item_version_id in (
    select v.id from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id
    where ci.content_key in (
      'apphy2-frq-049','apphy2-frq-050','apphy2-frq-051','apphy2-frq-052','apphy2-frq-053',
      'apphy2-frq-054','apphy2-frq-055','apphy2-frq-056','apphy2-frq-057','apphy2-frq-058',
      'apphycem-frq-049','apphycem-frq-050','apphycem-frq-051','apphycem-frq-052','apphycem-frq-053',
      'apphycem-frq-054','apphycem-frq-055','apphycem-frq-056','apphycem-frq-057','apphycem-frq-058',
      'apphycm-frq-049','apphycm-frq-050','apphycm-frq-051','apphycm-frq-052','apphycm-frq-053',
      'apphycm-frq-054','apphycm-frq-055','apphycm-frq-056','apphycm-frq-057','apphycm-frq-058'
    )
  );

insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select gen_random_uuid(), v.id, '2b29b40a-6c00-49f8-9bfa-7e3d9e81f9ae'::uuid, 'tutor_question', 'frq', 'pending', 'subject_review', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id
where ci.content_key in (
  'apphy2-frq-049','apphy2-frq-050','apphy2-frq-051','apphy2-frq-052','apphy2-frq-053',
  'apphy2-frq-054','apphy2-frq-055','apphy2-frq-056','apphy2-frq-057','apphy2-frq-058',
  'apphycem-frq-049','apphycem-frq-050','apphycem-frq-051','apphycem-frq-052','apphycem-frq-053',
  'apphycem-frq-054','apphycem-frq-055','apphycem-frq-056','apphycem-frq-057','apphycem-frq-058',
  'apphycm-frq-049','apphycm-frq-050','apphycm-frq-051','apphycm-frq-052','apphycm-frq-053',
  'apphycm-frq-054','apphycm-frq-055','apphycm-frq-056','apphycm-frq-057','apphycm-frq-058'
);

-- 2. AP Calculus AB (23 items) -> Abdul Hanan.
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select gen_random_uuid(), v.id, '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid, 'tutor_question', ci.item_type, 'pending', 'subject_review', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from app.content_items ci
join app.content_item_versions v on v.content_item_id = ci.id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.exam_packs ep on ep.id=epv.exam_pack_id
join app.subjects s on s.id=ep.subject_id
where ci.status='draft' and s.display_name='AP Calculus AB';

update app.content_items ci
set status='assigned', updated_at=now()
where ci.status='draft'
  and exists (select 1 from app.exam_pack_versions epv join app.exam_packs ep on ep.id=epv.exam_pack_id join app.subjects s on s.id=ep.subject_id where epv.id=ci.exam_pack_version_id and s.display_name='AP Calculus AB');

commit;

-- 3. AP Statistics (48 items) -> Shazia Fazal (all 48, after the
--    Saood-qualification block above).
begin;

insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select gen_random_uuid(), v.id, '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid, 'tutor_question', ci.item_type, 'pending', 'subject_review', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from app.content_items ci
join app.content_item_versions v on v.content_item_id = ci.id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.exam_packs ep on ep.id=epv.exam_pack_id
join app.subjects s on s.id=ep.subject_id
where ci.status='draft' and s.display_name='AP Statistics';

update app.content_items ci
set status='assigned', updated_at=now()
where ci.status='draft'
  and exists (select 1 from app.exam_pack_versions epv join app.exam_packs ep on ep.id=epv.exam_pack_id join app.subjects s on s.id=ep.subject_id where epv.id=ci.exam_pack_version_id and s.display_name='AP Statistics');

commit;
