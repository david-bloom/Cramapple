-- Grant Muhammad Saood AP Chemistry grading rights and assign every current,
-- non-retired AP Chemistry content version that he has not reviewed.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-saood-ap-chemistry-all-unreviewed-20260730')
);

-- Mirror Muhammad Zeeshan's active AP Chemistry qualification scope.
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
  'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
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
      '806b0a0e-8431-4aa5-ad71-b803a1792145'::uuid
  and source.status = 'active'
  and 'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid =
      any(source.exam_ids)
  and source.effective_at <= now()
  and (source.expires_at is null or source.expires_at > now())
  and not exists (
    select 1
    from app.validator_qualifications existing
    where existing.reviewer_id =
          'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
      and existing.status = 'active'
      and 'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid =
          any(existing.exam_ids)
      and existing.effective_at <= now()
      and (existing.expires_at is null or existing.expires_at > now())
  );

create temporary table packet_versions (
  content_item_version_id uuid primary key,
  content_key text unique not null,
  item_type text not null
) on commit drop;

with ranked as (
  select
    civ.id,
    civ.content_key,
    civ.item_type,
    civ.status,
    row_number() over (
      partition by civ.content_item_id
      order by civ.version_num desc
    ) as version_rank
  from public.content_item_versions civ
  where civ.exam_pack_id =
        'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid
)
insert into packet_versions (
  content_item_version_id,
  content_key,
  item_type
)
select
  ranked.id,
  ranked.content_key,
  ranked.item_type
from ranked
where ranked.version_rank = 1
  and ranked.status <> 'retired'
  and not exists (
    select 1
    from app.content_review_decisions d
    where d.content_item_version_id = ranked.id
      and d.reviewer_id =
          'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
  );

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
    count(*) filter (where item_type = 'mcq'),
    count(*) filter (where item_type = 'frq')
  into v_total, v_mcq, v_frq
  from packet_versions;

  if (v_total, v_mcq, v_frq) <> (136, 70, 66) then
    raise exception
      'AP Chemistry unreviewed corpus changed: total %, MCQ %, FRQ %',
      v_total, v_mcq, v_frq;
  end if;

  select count(*)
  into v_existing
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id =
       'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
   and a.review_stage = 'tutor_question';

  if v_existing <> 0 then
    raise exception
      'Saood already has % assignments from the intended corpus',
      v_existing;
  end if;

  select exists (
    select 1
    from app.validator_qualifications q
    where q.reviewer_id =
          'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
      and q.status = 'active'
      and 'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid =
          any(q.exam_ids)
      and q.effective_at <= now()
      and (q.expires_at is null or q.expires_at > now())
  )
  into v_qualified;

  if not v_qualified then
    raise exception
      'Muhammad Saood does not have active AP Chemistry rights';
  end if;
end
$$;

insert into app.content_review_assignments (
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  status,
  assignment_purpose,
  created_by
)
select
  pv.content_item_version_id,
  'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
  'tutor_question',
  pv.item_type,
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
  'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid,
  'saood-ap-chemistry-all-unreviewed-2026-07-30',
  'Muhammad Saood AP Chemistry complete unreviewed corpus',
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
  a.content_review_assignment_id,
  label.id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
join app.content_review_assignments a
  on a.content_item_version_id = pv.content_item_version_id
 and a.reviewer_id =
     'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
 and a.review_stage = 'tutor_question'
join app.content_labels label
  on label.exam_pack_id =
     'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid
 and label.label_key =
     'saood-ap-chemistry-all-unreviewed-2026-07-30';

do $$
declare
  v_assignments integer;
  v_pending integer;
  v_mcq integer;
  v_frq integer;
  v_labeled integer;
begin
  select
    count(*),
    count(*) filter (where a.status = 'pending'),
    count(*) filter (where a.review_kind = 'mcq'),
    count(*) filter (where a.review_kind = 'frq')
  into v_assignments, v_pending, v_mcq, v_frq
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id =
       'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
   and a.review_stage = 'tutor_question'
   and a.assignment_purpose = 'subject_review';

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id =
       'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid
   and a.review_stage = 'tutor_question'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id = a.content_review_assignment_id
  join app.content_labels label
    on label.id = al.content_label_id
   and label.label_key =
       'saood-ap-chemistry-all-unreviewed-2026-07-30';

  if (v_assignments, v_pending, v_mcq, v_frq, v_labeled) <>
     (136, 136, 70, 66, 136) then
    raise exception
      'Saood Chemistry assignment verification failed: assignments %, pending %, MCQ %, FRQ %, labeled %',
      v_assignments, v_pending, v_mcq, v_frq, v_labeled;
  end if;
end
$$;

commit;
