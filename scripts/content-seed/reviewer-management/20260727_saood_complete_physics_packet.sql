-- Assign every latest active question across all four AP Physics exams to
-- Muhammad Saood.
--
-- Existing assignments and submitted decisions are preserved. Any skipped
-- assignment is reopened as pending. A matching workflow label is created
-- within each exam pack and applied to Saood's complete Physics queue.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-saood-complete-physics-packet-20260727')
);

create temporary table packet_versions (
  content_item_version_id uuid primary key,
  exam_pack_id uuid not null,
  exam_code text not null,
  item_type text not null
) on commit drop;

with physics_exams as (
  select id, exam_code
  from app.exam_packs
  where exam_code in (
    'ap_physics_1',
    'ap_physics_2',
    'ap_physics_c_mechanics',
    'ap_physics_c_em'
  )
),
latest as (
  select distinct on (ci.id)
    civ.id as content_item_version_id,
    pe.id as exam_pack_id,
    pe.exam_code,
    ci.item_type,
    ci.status as item_status,
    civ.status as version_status
  from physics_exams pe
  join app.exam_pack_versions epv
    on epv.exam_pack_id = pe.id
  join app.content_items ci
    on ci.exam_pack_version_id = epv.id
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  order by ci.id, civ.version_num desc
)
insert into packet_versions (
  content_item_version_id,
  exam_pack_id,
  exam_code,
  item_type
)
select
  content_item_version_id,
  exam_pack_id,
  exam_code,
  item_type
from latest
where item_status <> 'retired'
  and version_status <> 'retired';

do $$
declare
  v_total integer;
  v_mcq integer;
  v_frq integer;
  v_exams integer;
  v_qualified integer;
begin
  select
    count(*),
    count(*) filter (where item_type = 'mcq'),
    count(*) filter (where item_type = 'frq'),
    count(distinct exam_pack_id)
  into v_total, v_mcq, v_frq, v_exams
  from packet_versions;

  if (v_total, v_mcq, v_frq, v_exams) <> (328, 176, 152, 4) then
    raise exception
      'Physics inventory changed: expected 328 total (176 MCQ, 152 FRQ, 4 exams), found % total (% MCQ, % FRQ, % exams)',
      v_total, v_mcq, v_frq, v_exams;
  end if;

  select count(distinct pv.exam_pack_id)
  into v_qualified
  from packet_versions pv
  where exists (
    select 1
    from app.validator_qualifications vq
    where vq.reviewer_id =
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
      and vq.status = 'active'
      and pv.exam_pack_id = any(vq.exam_ids)
      and vq.effective_at <= now()
      and vq.expires_at > now()
  );

  if v_qualified <> 4 then
    raise exception
      'Saood must have active qualifications for all 4 Physics exams; found % qualified exams',
      v_qualified;
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

update app.content_review_assignments a
set status = 'pending'
from packet_versions pv
where a.content_item_version_id = pv.content_item_version_id
  and a.reviewer_id = 'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
  and a.review_stage = 'tutor_question'
  and a.status = 'skipped';

insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status,
  created_by
)
select distinct
  pv.exam_pack_id,
  'saood-complete-physics-review-2026-07-27',
  'Saood complete Physics review',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
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
  on l.exam_pack_id = pv.exam_pack_id
 and l.label_key = 'saood-complete-physics-review-2026-07-27'
on conflict do nothing;

do $$
declare
  v_assignments integer;
  v_labeled integer;
  v_skipped integer;
  v_kind_mismatches integer;
begin
  select
    count(*),
    count(*) filter (where a.status = 'skipped'),
    count(*) filter (where a.review_kind <> pv.item_type)
  into v_assignments, v_skipped, v_kind_mismatches
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
   and l.exam_pack_id = pv.exam_pack_id
   and l.label_key = 'saood-complete-physics-review-2026-07-27';

  if v_assignments <> 328
     or v_labeled <> 328
     or v_skipped <> 0
     or v_kind_mismatches <> 0 then
    raise exception
      'Physics packet reconciliation failed: assignments %, labeled %, skipped %, kind mismatches %',
      v_assignments, v_labeled, v_skipped, v_kind_mismatches;
  end if;
end
$$;

commit;
