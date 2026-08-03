-- Grant Shazia Fazal AP Statistics grading rights and assign her 25 current
-- question versions already completed by Jill Schmidlkofer. The packet contains
-- 15 FRQs and 10 MCQs and uses shared blind-group IDs for direct comparison.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-shazia-statistics-25-jill-comparison-20260730')
);

-- Match Jill's active AP Statistics qualification scope and policy.
insert into app.validator_qualifications (
  reviewer_id,
  qualification_type,
  exam_ids,
  school_years,
  taxonomy_scope_ids,
  artifact_types,
  environment_scope,
  evidence_record_ids,
  qualification_policy_version_id,
  granted_by,
  granted_at,
  effective_at,
  expires_at,
  status,
  created_by
)
select
  '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid,
  source.qualification_type,
  source.exam_ids,
  source.school_years,
  source.taxonomy_scope_ids,
  source.artifact_types,
  source.environment_scope,
  source.evidence_record_ids,
  source.qualification_policy_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  now(),
  now(),
  source.expires_at,
  'active',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from app.validator_qualifications source
where source.reviewer_id =
      '0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid
  and source.status = 'active'
  and 'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid =
      any(source.exam_ids)
  and source.effective_at <= now()
  and (source.expires_at is null or source.expires_at > now())
  and not exists (
    select 1
    from app.validator_qualifications existing
    where existing.reviewer_id =
          '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
      and existing.status = 'active'
      and 'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid =
          any(existing.exam_ids)
      and existing.effective_at <= now()
      and (existing.expires_at is null or existing.expires_at > now())
  );

create temporary table packet_versions (
  content_item_version_id uuid primary key,
  content_key text unique not null,
  item_type text not null,
  jill_assignment_id uuid unique,
  comparison_group_id uuid unique
) on commit drop;

insert into packet_versions (
  content_item_version_id,
  content_key,
  item_type
)
values
  ('1732c8b1-4b93-4165-ad60-6bc8d45d6d4c', 'APSTATS-HDG-2026-GRAPH-004', 'frq'),
  ('3e259834-7a75-4129-934d-67f33d1e6da7', 'APSTATS-HDG-2026-GRAPH-002', 'frq'),
  ('12bbd5f6-964c-4075-823c-ce8ddf8d4608', 'APSTATS-HDG-2026-GRAPH-035', 'frq'),
  ('34679b73-2cfd-4c26-b02e-42f68f3d98b6', 'APSTATS-HDG-2026-GRAPH-034', 'frq'),
  ('98e1db6e-ebee-48e2-8ef9-dfd00c10cc5e', 'APSTATS-HDG-2026-GRAPH-032', 'frq'),
  ('4305674a-ad35-4192-abb1-d39f54482d4a', 'APSTATS-HDG-2026-GRAPH-011', 'frq'),
  ('81abc733-c0ac-4c49-a392-a2fd6aa92257', 'APSTAT-MOD3-E004', 'frq'),
  ('ce586c48-68d0-42a8-a374-ada9625fcde2', 'APSTAT-MOD5-M002', 'frq'),
  ('c8c830b5-ba43-4e51-917f-1a1263fe76c7', 'APSTAT-MOD6-H002', 'frq'),
  ('126c6bcf-708e-45ef-979c-435b79ff1b82', 'APSTAT-MOD6-H006', 'frq'),
  ('20b20f2c-f9f9-4fb8-a9c4-e36960e6c72f', 'APSTAT-MOD6-M001', 'frq'),
  ('0602626d-da02-4d3b-a440-072f22d3fd47', 'APSTAT-MOD6-M005', 'frq'),
  ('a1ef1ac2-c0cf-46e2-bbd3-e8c30b2ebb54', 'APSTAT-MOD7-H009', 'frq'),
  ('8c64aa82-e435-479d-a219-2087b1bcd471', 'STATS-MOD1-E004', 'frq'),
  ('8762566d-caf0-4305-b470-ee0c583125c7', 'STATS-MOD1-M004', 'frq'),
  ('34dfa75b-703d-4c8b-9d2f-52469c5b23ef', 'APSTATS-MCQ-006-CAL', 'mcq'),
  ('ed8f2081-caa5-41ce-9f66-ba8e67863cfd', 'APSTATS-MCQ-009-CAL', 'mcq'),
  ('4f75de69-2a01-40ef-88d0-ce52da632314', 'APSTATS-MCQ-003', 'mcq'),
  ('a64eaa36-d738-4d14-bbab-b90b1ea35818', 'APSTATS-MCQ-008', 'mcq'),
  ('b3590084-1099-4c9d-aa19-a41cce23e7d3', 'APSTATS-MCQ-015', 'mcq'),
  ('fbde3145-2edc-418a-807b-8ad205dedf84', 'APSTATS-MCQ-019', 'mcq'),
  ('ee90a501-d6ae-4a4e-9d1b-2dba077782df', 'APSTATS-MCQ-022', 'mcq'),
  ('d9e286a3-74b3-4844-ab0a-63ba55fd63be', 'APSTATS-MCQ-026', 'mcq'),
  ('0f677e08-6a5f-4ff8-b464-a90ee5f255ee', 'APSTATS-MCQ-029', 'mcq'),
  ('cc3d551e-f0e0-400c-94b3-dc282aa0440a', 'APSTATS-MCQ-032', 'mcq');

update packet_versions pv
set
  jill_assignment_id = jill.content_review_assignment_id,
  comparison_group_id = coalesce(jill.blind_group_id, gen_random_uuid())
from app.content_review_assignments jill
where jill.content_item_version_id = pv.content_item_version_id
  and jill.reviewer_id =
      '0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid
  and jill.review_stage = 'tutor_question'
  and jill.assignment_purpose = 'subject_review';

do $$
declare
  v_total integer;
  v_frq integer;
  v_mcq integer;
  v_invalid integer;
  v_qualified boolean;
begin
  select
    count(*),
    count(*) filter (where item_type = 'frq'),
    count(*) filter (where item_type = 'mcq')
  into v_total, v_frq, v_mcq
  from packet_versions;

  if (v_total, v_frq, v_mcq) <> (25, 15, 10) then
    raise exception
      'Statistics packet shape changed: total %, FRQ %, MCQ %',
      v_total, v_frq, v_mcq;
  end if;

  select count(*)
  into v_invalid
  from packet_versions pv
  left join app.content_review_assignments jill
    on jill.content_review_assignment_id = pv.jill_assignment_id
  left join public.content_item_versions civ
    on civ.id = pv.content_item_version_id
  where pv.jill_assignment_id is null
     or pv.comparison_group_id is null
     or jill.status <> 'submitted'
     or civ.content_key <> pv.content_key
     or civ.item_type <> pv.item_type
     or civ.exam_pack_id <>
        'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid
     or civ.status = 'retired'
     or civ.version_num <> (
       select max(latest.version_num)
       from app.content_item_versions latest
       where latest.content_item_id = civ.content_item_id
     )
     or not exists (
       select 1
       from app.content_review_decisions d
       where d.content_review_assignment_id = pv.jill_assignment_id
     );

  if v_invalid <> 0 then
    raise exception
      '% packet versions failed Jill/current-version validation',
      v_invalid;
  end if;

  select exists (
    select 1
    from app.validator_qualifications q
    where q.reviewer_id =
          '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
      and q.status = 'active'
      and 'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid =
          any(q.exam_ids)
      and q.effective_at <= now()
      and (q.expires_at is null or q.expires_at > now())
  )
  into v_qualified;

  if not v_qualified then
    raise exception 'Shazia Fazal does not have active AP Statistics rights';
  end if;
end
$$;

-- Preserve an existing comparison group when present; otherwise establish the
-- group on Jill's reference assignment before adding Shazia.
update app.content_review_assignments jill
set blind_group_id = pv.comparison_group_id
from packet_versions pv
where jill.content_review_assignment_id = pv.jill_assignment_id
  and jill.blind_group_id is null;

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
from packet_versions pv
on conflict (content_item_version_id, reviewer_id, review_stage)
  where content_item_version_id is not null
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
  'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid,
  'shazia-statistics-25-jill-comparison-2026-07-30',
  'Shazia Fazal Statistics 25-question Jill comparison',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
)
on conflict (exam_pack_id, label_key) do update
set
  label_name = excluded.label_name,
  label_type = excluded.label_type,
  status = excluded.status;

insert into app.content_review_assignment_labels (
  content_review_assignment_id,
  content_label_id,
  created_by
)
select
  shazia.content_review_assignment_id,
  label.id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
join app.content_review_assignments shazia
  on shazia.content_item_version_id = pv.content_item_version_id
 and shazia.reviewer_id =
     '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
 and shazia.review_stage = 'tutor_question'
join app.content_labels label
  on label.exam_pack_id =
     'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid
 and label.label_key =
     'shazia-statistics-25-jill-comparison-2026-07-30'
on conflict do nothing;

do $$
declare
  v_assignments integer;
  v_pending integer;
  v_frq integer;
  v_mcq integer;
  v_labeled integer;
  v_exact_overlap integer;
  v_shared_groups integer;
begin
  select
    count(*),
    count(*) filter (where shazia.status = 'pending'),
    count(*) filter (where shazia.review_kind = 'frq'),
    count(*) filter (where shazia.review_kind = 'mcq')
  into v_assignments, v_pending, v_frq, v_mcq
  from packet_versions pv
  join app.content_review_assignments shazia
    on shazia.content_item_version_id = pv.content_item_version_id
   and shazia.reviewer_id =
       '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
   and shazia.review_stage = 'tutor_question'
   and shazia.assignment_purpose = 'subject_review';

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments shazia
    on shazia.content_item_version_id = pv.content_item_version_id
   and shazia.reviewer_id =
       '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
   and shazia.review_stage = 'tutor_question'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id =
       shazia.content_review_assignment_id
  join app.content_labels label
    on label.id = al.content_label_id
   and label.label_key =
       'shazia-statistics-25-jill-comparison-2026-07-30';

  select count(*)
  into v_exact_overlap
  from packet_versions pv
  where exists (
    select 1
    from app.content_review_assignments jill
    where jill.content_review_assignment_id = pv.jill_assignment_id
      and jill.status = 'submitted'
  )
  and exists (
    select 1
    from app.content_review_assignments shazia
    where shazia.content_item_version_id = pv.content_item_version_id
      and shazia.reviewer_id =
          '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
      and shazia.review_stage = 'tutor_question'
  );

  select count(*)
  into v_shared_groups
  from packet_versions pv
  where (
    select count(*)
    from app.content_review_assignments peer
    where peer.content_item_version_id = pv.content_item_version_id
      and peer.blind_group_id = pv.comparison_group_id
      and peer.review_stage = 'tutor_question'
      and peer.reviewer_id in (
        '0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid,
        '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
      )
  ) = 2;

  if (
    v_assignments,
    v_pending,
    v_frq,
    v_mcq,
    v_labeled,
    v_exact_overlap,
    v_shared_groups
  ) <> (25, 25, 15, 10, 25, 25, 25) then
    raise exception
      'Shazia Statistics packet verification failed: assignments %, pending %, FRQ %, MCQ %, labeled %, overlap %, shared groups %',
      v_assignments,
      v_pending,
      v_frq,
      v_mcq,
      v_labeled,
      v_exact_overlap,
      v_shared_groups;
  end if;
end
$$;

commit;
