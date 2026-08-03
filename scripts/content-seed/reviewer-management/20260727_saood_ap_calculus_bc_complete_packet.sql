-- Assign every current AP Calculus BC question to Muhammad Saood in one
-- labeled tutor-question review packet.
--
-- This is assignment-only: it does not change question content, versions,
-- publication state, or another reviewer's assignments and decisions.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-saood-ap-calculus-bc-complete-packet-20260727')
);

create temporary table packet_versions (
  content_item_version_id uuid primary key,
  item_type text not null
) on commit drop;

insert into packet_versions (content_item_version_id, item_type)
select content_item_version_id, item_type
from (
  select distinct on (ci.id)
    civ.id as content_item_version_id,
    ci.item_type,
    ci.status as item_status,
    civ.status as version_status
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  where ci.content_key like 'apcalcbc-%'
  order by ci.id, civ.version_num desc
) latest
where item_status <> 'retired'
  and version_status <> 'retired';

do $$
declare
  v_total integer;
  v_mcq integer;
  v_frq integer;
begin
  select
    count(*),
    count(*) filter (where item_type = 'mcq'),
    count(*) filter (where item_type = 'frq')
  into v_total, v_mcq, v_frq
  from packet_versions;

  if (v_total, v_mcq, v_frq) <> (36, 20, 16) then
    raise exception
      'AP Calculus BC inventory changed: expected 36 total (20 MCQ, 16 FRQ), found % total (% MCQ, % FRQ)',
      v_total, v_mcq, v_frq;
  end if;
end
$$;

insert into app.content_review_assignments (
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  status,
  created_by
)
select
  pv.content_item_version_id,
  'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
  'tutor_question',
  pv.item_type,
  'pending',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
on conflict (
  content_item_version_id,
  reviewer_id,
  review_stage
) where content_item_version_id is not null
do nothing;

insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status,
  created_by
)
values (
  'acb1826c-358c-439a-a6b6-0d004ea7e2ae'::uuid,
  'saood-ap-calculus-bc-complete-2026-07-27',
  'AP Calculus BC complete review',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
)
on conflict (exam_pack_id, label_key) do update
set label_name = excluded.label_name,
    label_type = excluded.label_type,
    status = excluded.status;

insert into app.content_review_assignment_labels (
  content_review_assignment_id,
  content_label_id,
  created_by
)
select
  a.content_review_assignment_id,
  l.id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
join app.content_review_assignments a
  on a.content_item_version_id = pv.content_item_version_id
 and a.reviewer_id = 'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
 and a.review_stage = 'tutor_question'
join app.content_labels l
  on l.exam_pack_id = 'acb1826c-358c-439a-a6b6-0d004ea7e2ae'::uuid
 and l.label_key = 'saood-ap-calculus-bc-complete-2026-07-27'
on conflict do nothing;

do $$
declare
  v_assignments integer;
  v_labeled integer;
begin
  select count(*)
  into v_assignments
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = 'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
   and a.review_stage = 'tutor_question';

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = 'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
   and a.review_stage = 'tutor_question'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id = a.content_review_assignment_id
  join app.content_labels l
    on l.id = al.content_label_id
   and l.label_key = 'saood-ap-calculus-bc-complete-2026-07-27';

  if v_assignments <> 36 or v_labeled <> 36 then
    raise exception
      'Packet reconciliation failed: expected 36 assignments and labels, found % assignments and % labels',
      v_assignments, v_labeled;
  end if;
end
$$;

commit;
