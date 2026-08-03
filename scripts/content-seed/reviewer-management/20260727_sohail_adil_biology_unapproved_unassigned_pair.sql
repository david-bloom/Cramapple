-- Give Sarah Sohail and Adil Abbasi the same AP Biology tutor-question set:
-- every latest active question that is not in an approved lifecycle state,
-- plus any latest active question with no tutor-question assignment.
--
-- Existing assignments and decisions are preserved. Skipped target-reviewer
-- assignments are returned to pending, and both target assignments for each
-- question share one blind_group_id.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-sohail-adil-biology-unapproved-unassigned-20260727')
);

create temporary table packet_versions (
  content_item_version_id uuid primary key,
  item_type text not null,
  blind_group_id uuid not null
) on commit drop;

with latest as (
  select distinct on (ci.id)
    ci.id as content_item_id,
    ci.item_type,
    ci.status as item_status,
    civ.id as content_item_version_id,
    civ.status as version_status,
    civ.review_status
  from app.content_items ci
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  where epv.exam_pack_id = '9dac6d66-5cf4-4a3e-a8cd-4adb7f681023'::uuid
  order by ci.id, civ.version_num desc
),
eligible as (
  select l.*
  from latest l
  where l.item_status <> 'retired'
    and l.version_status <> 'retired'
    and (
      not (
        l.item_status = 'reviewed_approved'
        or l.version_status = 'reviewed_approved'
        or coalesce(l.review_status = 'question_review_approved', false)
      )
      or not exists (
        select 1
        from app.content_review_assignments a
        where a.content_item_version_id = l.content_item_version_id
          and a.review_stage = 'tutor_question'
      )
    )
)
insert into packet_versions (
  content_item_version_id,
  item_type,
  blind_group_id
)
select
  e.content_item_version_id,
  e.item_type,
  coalesce(adil.blind_group_id, sohail.blind_group_id, gen_random_uuid())
from eligible e
left join app.content_review_assignments adil
  on adil.content_item_version_id = e.content_item_version_id
 and adil.reviewer_id = 'af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'::uuid
 and adil.review_stage = 'tutor_question'
left join app.content_review_assignments sohail
  on sohail.content_item_version_id = e.content_item_version_id
 and sohail.reviewer_id = 'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
 and sohail.review_stage = 'tutor_question';

do $$
declare
  v_total integer;
  v_mcq integer;
  v_frq integer;
  v_qualified integer;
begin
  select
    count(*),
    count(*) filter (where item_type = 'mcq'),
    count(*) filter (where item_type = 'frq')
  into v_total, v_mcq, v_frq
  from packet_versions;

  if (v_total, v_mcq, v_frq) <> (112, 75, 37) then
    raise exception
      'Biology packet inventory changed: expected 112 total (75 MCQ, 37 FRQ), found % total (% MCQ, % FRQ)',
      v_total, v_mcq, v_frq;
  end if;

  select count(distinct vq.reviewer_id)
  into v_qualified
  from app.validator_qualifications vq
  where vq.reviewer_id in (
      'af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'::uuid,
      'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
    )
    and vq.status = 'active'
    and '9dac6d66-5cf4-4a3e-a8cd-4adb7f681023'::uuid = any(vq.exam_ids)
    and vq.effective_at <= now()
    and vq.expires_at > now();

  if v_qualified <> 2 then
    raise exception
      'Both target reviewers must have active AP Biology qualifications; found % qualified reviewers',
      v_qualified;
  end if;
end
$$;

insert into app.content_review_assignments (
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  blind_group_id,
  status,
  created_by
)
select
  pv.content_item_version_id,
  reviewers.reviewer_id,
  'tutor_question',
  pv.item_type,
  pv.blind_group_id,
  'pending',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
cross join (
  values
    ('af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'::uuid),
    ('c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid)
) as reviewers(reviewer_id)
on conflict (
  content_item_version_id,
  reviewer_id,
  review_stage
) where content_item_version_id is not null
do nothing;

-- Reconcile existing target-reviewer assignments into the shared pairing.
-- Submitted work remains submitted; only skipped work is reopened.
update app.content_review_assignments a
set blind_group_id = pv.blind_group_id,
    status = case when a.status = 'skipped' then 'pending' else a.status end
from packet_versions pv
where a.content_item_version_id = pv.content_item_version_id
  and a.reviewer_id in (
    'af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'::uuid,
    'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
  )
  and a.review_stage = 'tutor_question';

insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status,
  created_by
)
values (
  '9dac6d66-5cf4-4a3e-a8cd-4adb7f681023'::uuid,
  'sohail-adil-biology-unapproved-unassigned-2026-07-27',
  'Biology unapproved or unassigned paired review',
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
 and a.reviewer_id in (
   'af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'::uuid,
   'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
 )
 and a.review_stage = 'tutor_question'
join app.content_labels l
  on l.exam_pack_id = '9dac6d66-5cf4-4a3e-a8cd-4adb7f681023'::uuid
 and l.label_key =
   'sohail-adil-biology-unapproved-unassigned-2026-07-27'
on conflict do nothing;

do $$
declare
  v_adil integer;
  v_sohail integer;
  v_same_questions integer;
  v_same_blind_groups integer;
  v_labeled integer;
  v_skipped integer;
begin
  select count(*)
  into v_adil
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = 'af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'::uuid
   and a.review_stage = 'tutor_question';

  select count(*)
  into v_sohail
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = 'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
   and a.review_stage = 'tutor_question';

  select count(*)
  into v_same_questions
  from packet_versions pv
  where exists (
    select 1
    from app.content_review_assignments a
    where a.content_item_version_id = pv.content_item_version_id
      and a.reviewer_id = 'af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'::uuid
      and a.review_stage = 'tutor_question'
  )
  and exists (
    select 1
    from app.content_review_assignments a
    where a.content_item_version_id = pv.content_item_version_id
      and a.reviewer_id = 'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
      and a.review_stage = 'tutor_question'
  );

  select count(*)
  into v_same_blind_groups
  from packet_versions pv
  join app.content_review_assignments adil
    on adil.content_item_version_id = pv.content_item_version_id
   and adil.reviewer_id = 'af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'::uuid
   and adil.review_stage = 'tutor_question'
  join app.content_review_assignments sohail
    on sohail.content_item_version_id = pv.content_item_version_id
   and sohail.reviewer_id = 'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
   and sohail.review_stage = 'tutor_question'
  where adil.blind_group_id = sohail.blind_group_id
    and adil.blind_group_id is not null;

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id in (
     'af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'::uuid,
     'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
   )
   and a.review_stage = 'tutor_question'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id = a.content_review_assignment_id
  join app.content_labels l
    on l.id = al.content_label_id
   and l.label_key =
     'sohail-adil-biology-unapproved-unassigned-2026-07-27';

  select count(*)
  into v_skipped
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id in (
     'af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'::uuid,
     'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
   )
   and a.review_stage = 'tutor_question'
  where a.status = 'skipped';

  if v_adil <> 112
     or v_sohail <> 112
     or v_same_questions <> 112
     or v_same_blind_groups <> 112
     or v_labeled <> 224
     or v_skipped <> 0 then
    raise exception
      'Packet reconciliation failed: Adil %, Sohail %, paired %, shared blind %, labeled %, skipped %',
      v_adil, v_sohail, v_same_questions, v_same_blind_groups,
      v_labeled, v_skipped;
  end if;
end
$$;

commit;
