-- Assign Shazia Fazal the same 25 AP Precalculus content versions assigned to
-- Abdul Hanan and Qamar Ul Zaman. Shazia joins the existing blind groups as
-- the third independent reader for direct three-way comparison.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-shazia-precalculus-25-three-reader-20260730')
);

create temporary table packet_versions (
  content_item_id uuid primary key,
  content_item_version_id uuid unique not null,
  content_key text unique not null,
  item_type text not null,
  comparison_group_id uuid unique not null
) on commit drop;

insert into packet_versions (
  content_item_id,
  content_item_version_id,
  content_key,
  item_type,
  comparison_group_id
)
select
  ci.id,
  civ.id,
  ci.content_key,
  ci.item_type,
  qamar.blind_group_id
from app.content_review_assignments qamar
join app.content_review_assignment_labels al
  on al.content_review_assignment_id=qamar.content_review_assignment_id
join app.content_labels l
  on l.id=al.content_label_id
 and l.label_key='qamar-precalculus-25-abdul-comparison-2026-07-29'
join app.content_item_versions civ
  on civ.id=qamar.content_item_version_id
join app.content_items ci
  on ci.id=civ.content_item_id
where qamar.reviewer_id='ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
  and qamar.review_stage='tutor_question'
  and qamar.blind_group_id is not null;

do $$
declare
  v_total integer;
  v_mcq integer;
  v_frq integer;
  v_two_reader_groups integer;
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
      'Qamar source packet changed: total %, MCQ %, FRQ %',
      v_total,v_mcq,v_frq;
  end if;

  select count(*)
  into v_two_reader_groups
  from packet_versions pv
  where (
    select count(*)
    from app.content_review_assignments peer
    where peer.blind_group_id=pv.comparison_group_id
      and peer.content_item_version_id=pv.content_item_version_id
      and peer.review_stage='tutor_question'
      and peer.reviewer_id in (
        '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid,
        'ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
      )
  )=2;

  if v_two_reader_groups<>25 then
    raise exception
      'Only % of 25 versions have the expected Abdul-Qamar blind pair',
      v_two_reader_groups;
  end if;

  select count(*)
  into v_existing
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id='1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
   and a.review_stage='tutor_question';

  if v_existing<>0 then
    raise exception
      'Shazia already has % assignments from the intended packet',
      v_existing;
  end if;

  select exists (
    select 1
    from app.validator_qualifications vq
    where vq.reviewer_id=
            '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
      and vq.status='active'
      and '72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid=
          any(vq.exam_ids)
      and vq.effective_at<=now()
      and vq.expires_at>now()
  )
  into v_qualified;

  if not v_qualified then
    raise exception
      'Shazia Fazal does not have an active AP Precalculus qualification';
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
  assignment_purpose,
  created_by
)
select
  pv.content_item_version_id,
  '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid,
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
  'shazia-precalculus-25-three-reader-comparison-2026-07-30',
  'Shazia Fazal Precalculus 25-question three-reader comparison',
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
 and a.reviewer_id='1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
 and a.review_stage='tutor_question'
join app.content_labels l
  on l.exam_pack_id='72afc44a-7a56-4d45-ae3c-621c926ed6ab'::uuid
 and l.label_key=
     'shazia-precalculus-25-three-reader-comparison-2026-07-30';

do $$
declare
  v_assignments integer;
  v_pending integer;
  v_mcq integer;
  v_frq integer;
  v_labeled integer;
  v_exact_overlap integer;
  v_three_reader_groups integer;
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
   and a.reviewer_id='1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
   and a.review_stage='tutor_question'
   and a.assignment_purpose='subject_review';

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id=pv.content_item_version_id
   and a.reviewer_id='1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
   and a.review_stage='tutor_question'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id=a.content_review_assignment_id
  join app.content_labels l
    on l.id=al.content_label_id
   and l.label_key=
       'shazia-precalculus-25-three-reader-comparison-2026-07-30';

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
  )
  and exists (
    select 1
    from app.content_review_assignments qamar
    where qamar.content_item_version_id=pv.content_item_version_id
      and qamar.reviewer_id=
          'ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid
      and qamar.review_stage='tutor_question'
  );

  select count(*)
  into v_three_reader_groups
  from packet_versions pv
  where (
    select count(*)
    from app.content_review_assignments peer
    where peer.blind_group_id=pv.comparison_group_id
      and peer.content_item_version_id=pv.content_item_version_id
      and peer.review_stage='tutor_question'
      and peer.reviewer_id in (
        '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid,
        'ce00862f-a410-433f-80c0-58b6c9e55e73'::uuid,
        '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
      )
  )=3;

  if (v_assignments,v_pending,v_mcq,v_frq,v_labeled,v_exact_overlap,
      v_three_reader_groups)<>(25,25,20,5,25,25,25) then
    raise exception
      'Shazia packet verification failed: assignments %, pending %, MCQ %, FRQ %, labeled %, overlap %, three-reader groups %',
      v_assignments,v_pending,v_mcq,v_frq,v_labeled,v_exact_overlap,
      v_three_reader_groups;
  end if;
end
$$;

commit;
