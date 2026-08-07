-- Publish apchem-mcq-038 v2 after explicit owner approval to add admin QA.
--
-- Owner instruction, 2026-08-05:
-- "Add owner/admin QA approval for apchem-mcq-038 v2 and publish it to Production."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-publish-apchem-mcq-038-owner-qa-20260805'));

create temporary table target on commit drop as
select ci.id content_item_id, ci.content_key, ci.item_type,
       civ.id content_item_version_id, gen_random_uuid() assignment_id
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key='apchem-mcq-038'
  and ci.status='reviewed_approved'
  and civ.status='reviewed_approved'
  and civ.version_num=2
  and not exists (
    select 1
    from app.content_item_versions other
    where other.content_item_id=ci.id
      and other.id<>civ.id
      and other.status='published'
  );

do $$
declare
  v_count integer;
  v_bad integer;
begin
  select count(*) into v_count from target;
  if v_count<>1 then
    raise exception 'expected exactly apchem-mcq-038 v2 target, found %', v_count;
  end if;

  select count(*) into v_bad
  from target t
  where (select count(*) from app.mcq_choices m where m.content_item_version_id=t.content_item_version_id)<>4
     or (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=t.content_item_version_id)<>4
     or (select count(*) from app.mcq_choices m where m.content_item_version_id=t.content_item_version_id and m.is_correct)<>1
     or exists (
       select 1
       from app.mcq_choices m
       where m.content_item_version_id=t.content_item_version_id
         and nullif(trim(coalesce(m.rationale,'')),'') is null
     );

  if v_bad<>0 then
    raise exception 'apchem-mcq-038 failed MCQ structural gate';
  end if;
end $$;

insert into app.content_review_assignments (
  content_review_assignment_id,
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  status,
  assignment_purpose,
  created_by
)
select
  assignment_id,
  content_item_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  'tutor_question',
  item_type,
  'pending',
  'owner_remediation_approval',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from target
where not exists (
  select 1
  from app.content_review_decisions d
  join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
  where d.content_item_version_id=target.content_item_version_id
    and d.tutor_decision='approve'
);

insert into app.content_review_decisions (
  content_review_assignment_id,
  content_item_version_id,
  reviewer_id,
  review_stage,
  tutor_score,
  difficulty_label,
  diagnostic_flag,
  concern_codes,
  note,
  tutor_decision,
  decision_payload,
  decision_hash,
  created_by
)
select
  assignment_id,
  content_item_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  'tutor_question',
  1,
  'Medium',
  false,
  array[]::text[],
  'Owner/admin QA approval added for apchem-mcq-038 v2 publication; MCQ structural gate passed.',
  'approve',
  jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','owner_qa_missing_admin_publish',
    'qa_date','2026-08-05',
    'content_key','apchem-mcq-038'
  ),
  encode(extensions.digest(jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','owner_qa_missing_admin_publish',
    'qa_date','2026-08-05',
    'content_key','apchem-mcq-038'
  )::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from target
where not exists (
  select 1
  from app.content_review_decisions d
  join app.profiles p on p.user_id=d.reviewer_id and p.role='admin'
  where d.content_item_version_id=target.content_item_version_id
    and d.tutor_decision='approve'
);

update app.content_item_versions civ
set status='published',
    review_status='question_review_approved',
    approved_by=coalesce(civ.approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
    approved_at=coalesce(civ.approved_at,now()),
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from target t
where civ.id=t.content_item_version_id;

update app.content_items ci
set status='published',
    updated_at=now()
from target t
where ci.id=t.content_item_id;

do $$
declare
  v_published integer;
  v_dupes integer;
begin
  select count(*) into v_published
  from target t
  join app.content_items ci on ci.id=t.content_item_id
  join app.content_item_versions civ on civ.id=t.content_item_version_id
  where ci.status='published' and civ.status='published';

  if v_published<>1 then
    raise exception 'apchem-mcq-038 publish verification failed: %', v_published;
  end if;

  select count(*) into v_dupes
  from (
    select content_item_id
    from app.content_item_versions
    where status='published'
    group by content_item_id
    having count(*)>1
  ) d;

  if v_dupes<>0 then
    raise exception 'duplicate published item versions detected: %', v_dupes;
  end if;
end $$;

select content_key, content_item_version_id, 'published' as status
from target;

commit;
