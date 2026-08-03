-- Assign Qamar Ul Zaman a 25-question AP Precalculus comparison packet.
--
-- The packet clones the exact content versions assigned to Abdul Hanan under
-- abdul-hanan-precalculus-25-comparison-2026-07-29. Abdul and Qamar share one
-- blind_group_id per version so their independent decisions can be reconciled
-- and compared directly.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-qamar-precalculus-25-abdul-comparison-20260729')
);

create temporary table packet_versions (
  content_item_id uuid primary key,
  content_item_version_id uuid unique not null,
  content_key text unique not null,
  item_type text not null,
  abdul_assignment_id uuid unique not null,
  comparison_group_id uuid unique not null
) on commit drop;

insert into packet_versions (
  content_item_id,
  content_item_version_id,
  content_key,
  item_type,
  abdul_assignment_id,
  comparison_group_id
)
select
  ci.id,
  civ.id,
  ci.content_key,
  ci.item_type,
  a.content_review_assignment_id,
  coalesce(a.blind_group_id,gen_random_uuid())
from app.content_review_assignments a
join app.content_review_assignment_labels al
  on al.content_review_assignment_id=a.content_review_assignment_id
join app.content_labels l
  on l.id=al.content_label_id
 and l.label_key='abdul-hanan-precalculus-25-comparison-2026-07-29'
join app.content_item_versions civ
  on civ.id=a.content_item_version_id
join app.content_items ci
  on ci.id=civ.content_item_id
where a.reviewer_id='002e94ca-c634-4086-bea8-37390c0d3edf'::uuid
  and a.review_stage='tutor_question';

do $$
declare
  v_total integer;
  v_mcq integer;
  v_frq integer;
  v_existing integer;
  v_qualified boolean;
begin
  select
    count(*),
    count(*) filter(where item_type='mcq'),
    count(*) filter(where item_type='frq')
  into v_total,v_mcq,v_frq
  from packet_versions;

  if (v_total,v_mcq,v_frq)<>(25,20,5) then
    raise exception
      'Abdul source packet changed: total %, MCQ %, FRQ %',
      v_total,v_mcq,v_frq;
  end if;

  select count(*)
  into v_existing
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id='ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
   and a.review_stage='tutor_question';

  if v_existing<>0 then
    raise exception
      'Qamar already has % assignments from the intended packet',
      v_existing;
  end if;

  select exists (
    select 1
    from app.validator_qualifications vq
    where vq.reviewer_id=
            'ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
      and vq.status='active'
      and '72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid=
          any(vq.exam_ids)
      and vq.effective_at<=now()
      and vq.expires_at>now()
  )
  into v_qualified;

  if not v_qualified then
    raise exception
      'Qamar Ul Zaman does not have an active AP Precalculus qualification';
  end if;
end
$$;

-- Convert Abdul's original single-review assignments into genuine paired
-- blind groups without changing any submitted decision.
update app.content_review_assignments a
set blind_group_id=pv.comparison_group_id
from packet_versions pv
where a.content_review_assignment_id=pv.abdul_assignment_id
  and a.blind_group_id is distinct from pv.comparison_group_id;

insert into app.content_review_assignments (
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  blind_group_id,
  status,
  assignment_purpose,
  created_by
)
select
  pv.content_item_version_id,
  'ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid,
  'tutor_question',
  pv.item_type,
  pv.comparison_group_id,
  'pending',
  'subject_review',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv;

insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status,
  created_by
)
values (
  '72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid,
  'qamar-precalculus-25-abdul-comparison-2026-07-29',
  'Qamar Ul Zaman Precalculus 25-question comparison',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
)
on conflict (exam_pack_id,label_key) do update
set label_name=excluded.label_name,
    label_type=excluded.label_type,
    status=excluded.status;

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
  on a.content_item_version_id=pv.content_item_version_id
 and a.reviewer_id='ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
 and a.review_stage='tutor_question'
join app.content_labels l
  on l.exam_pack_id='72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid
 and l.label_key='qamar-precalculus-25-abdul-comparison-2026-07-29';

do $$
declare
  v_assignments integer;
  v_pending integer;
  v_mcq integer;
  v_frq integer;
  v_labeled integer;
  v_exact_overlap integer;
  v_shared_groups integer;
begin
  select
    count(*),
    count(*) filter(where a.status='pending'),
    count(*) filter(where a.review_kind='mcq'),
    count(*) filter(where a.review_kind='frq')
  into v_assignments,v_pending,v_mcq,v_frq
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id='ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
   and a.review_stage='tutor_question'
   and a.assignment_purpose='subject_review';

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id='ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
   and a.review_stage='tutor_question'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id=a.content_review_assignment_id
  join app.content_labels l
    on l.id=al.content_label_id
   and l.label_key=
       'qamar-precalculus-25-abdul-comparison-2026-07-29';

  select count(*)
  into v_exact_overlap
  from packet_versions pv
  where exists (
    select 1
    from app.content_review_assignments abdul
    where abdul.content_item_version_id=pv.content_item_version_id
      and abdul.reviewer_id=
          '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid
      and abdul.review_stage='tutor_question'
  );

  select count(*)
  into v_shared_groups
  from packet_versions pv
  join app.content_review_assignments abdul
    on abdul.content_review_assignment_id=pv.abdul_assignment_id
   and abdul.blind_group_id=pv.comparison_group_id
  join app.content_review_assignments qamar
    on qamar.content_item_version_id=pv.content_item_version_id
   and qamar.reviewer_id=
       'ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
   and qamar.blind_group_id=pv.comparison_group_id;

  if (v_assignments,v_pending,v_mcq,v_frq,v_labeled,v_exact_overlap,
      v_shared_groups)<>(25,25,20,5,25,25,25) then
    raise exception
      'Qamar packet verification failed: assignments %, pending %, MCQ %, FRQ %, labeled %, overlap %, shared groups %',
      v_assignments,v_pending,v_mcq,v_frq,v_labeled,v_exact_overlap,
      v_shared_groups;
  end if;
end
$$;

commit;
