-- Assign the 20 new AP Physics 1 np2 items (Units 4-8, hand-authored +
-- independently §9-verified, 10/10 FRQs clean, 10/10 MCQs clean) to Ahmed
-- Ali as a controlled batch. Owner's intent: compare Ahmed's review
-- behavior (edit rate, decision pattern) on genuinely novel content
-- against his established ~92% edit-rate historical pattern on the
-- existing physics backlog.
begin;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(), v.id, '2b29b40a-6c00-49f8-9bfa-7e3d9e81f9ae'::uuid,
       'tutor_question', ci.item_type, 'pending', 'subject_review',
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from app.content_items ci
join app.content_item_versions v on v.content_item_id = ci.id
where ci.content_key like 'apphy1-frq-np2-%' or ci.content_key like 'apphy1-mcq-np2-%';

update app.content_items
set status = 'assigned', updated_at = now()
where content_key like 'apphy1-frq-np2-%' or content_key like 'apphy1-mcq-np2-%';

select count(*) as assigned_count
from app.content_review_assignments cra
join app.content_item_versions v on v.id = cra.content_item_version_id
join app.content_items ci on ci.id = v.content_item_id
where cra.reviewer_id = '2b29b40a-6c00-49f8-9bfa-7e3d9e81f9ae'::uuid
  and (ci.content_key like 'apphy1-frq-np2-%' or ci.content_key like 'apphy1-mcq-np2-%');

commit;
