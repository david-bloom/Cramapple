-- AP Chemistry MCQ-014 publish repair and Zeeshan parallel assignments, 2026-08-05.
-- User explicitly approved: create apchem-mcq-014 v3 with Saood's small edit,
-- add owner/admin QA, publish it if MCQ gates pass, and add Zeeshan parallel
-- assignments for the six Saood-assigned AP Chemistry changes-requested items
-- where Zeeshan is not already active.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-mcq014-publish-zeeshan-20260805'));

create temporary table mcq014_repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null,
  source_decision_id uuid,
  assignment_id uuid not null
) on commit drop;

do $$
declare
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid := gen_random_uuid();
  v_source_decision uuid;
  v_assignment uuid := gen_random_uuid();
begin
  select * into strict v_item
  from app.content_items
  where content_key='apchem-mcq-014'
  for update;

  select * into strict v_old
  from app.content_item_versions
  where content_item_id=v_item.id
    and not exists (
      select 1 from app.content_item_versions newer
      where newer.content_item_id=app.content_item_versions.content_item_id
        and newer.version_num>app.content_item_versions.version_num
    )
  order by version_num desc, created_at desc
  limit 1
  for update;

  if v_old.version_num <> 2 then
    raise exception 'expected apchem-mcq-014 current version 2, got %', v_old.version_num;
  end if;

  if position('Negative enthalpy change denotes an exothermic process.' in (
    select coalesce(m.rationale,'')
    from app.mcq_choices m
    where m.content_item_version_id=v_old.id and m.choice_key='B'
  )) = 0 then
    raise exception 'apchem-mcq-014 v2 does not contain the Zeeshan AWE repair';
  end if;

  select d.content_review_decision_id into v_source_decision
  from app.content_review_decisions d
  join app.content_review_assignments cra
    on cra.content_review_assignment_id=d.content_review_assignment_id
  join app.profiles p on p.user_id=d.reviewer_id
  where d.content_item_version_id=v_old.id
    and p.full_name='Muhammad Saood'
    and d.tutor_decision='approve_with_edits'
    and cra.assignment_purpose='subject_review'
  order by d.submitted_at desc
  limit 1;

  update app.content_review_assignments
  set status='skipped'
  where content_item_version_id=v_old.id
    and assignment_purpose='subject_review'
    and status in ('pending','in_progress');

  update app.content_item_versions
  set status='retired', updated_at=now()
  where id=v_old.id;

  update app.content_items
  set status='draft', updated_at=now()
  where id=v_item.id;

  insert into app.content_item_versions (
    id,content_item_id,version_num,stem,stimulus,prompt_json,
    explanation,help_text,content_hash,status,created_by,
    canonical_answer_1,canonical_answer_2,review_status,
    rubric_type,evaluator_strategy,stimulus_image_path
  ) values (
    v_new,v_item.id,v_old.version_num+1,
    replace(v_old.stem,'If ΔH is negative for a process, the system','If ΔH is negative for a process at constant pressure, the system'),
    v_old.stimulus,
    coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
      'content_version',v_old.version_num+1,
      'qa_remediation','2026-08-05 AP Chemistry MCQ-014 Saood AWE repair',
      'qa_source_decision_id',v_source_decision
    ),
    v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),
    'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    v_old.canonical_answer_1,v_old.canonical_answer_2,null,
    v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
  );

  insert into app.mcq_choices (
    content_item_version_id,choice_key,choice_text,is_correct,rationale
  )
  select v_new,choice_key,
         case when choice_key='C' then 'must have greater entropy' else choice_text end,
         is_correct,
         case
           when choice_key='B' then 'Correct. At constant pressure, a negative enthalpy change means the process releases heat to the surroundings.'
           when choice_key='C' then 'Incorrect. A negative enthalpy change describes heat flow at constant pressure; it does not require an increase in entropy.'
           else rationale
         end
  from app.mcq_choices
  where content_item_version_id=v_old.id;

  insert into mcq014_repaired values (
    'apchem-mcq-014', v_old.id, v_new, v_source_decision, v_assignment
  );
end $$;

update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from mcq014_repaired r
where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select assignment_id,new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from mcq014_repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,tutor_decision,decision_payload,
  decision_hash,created_by
)
select r.assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       r.source_decision_id,'tutor_question',1,
       coalesce(src.difficulty_label,'Medium'),false,array[]::text[],
       'AP Chemistry MCQ-014 Saood approve-with-edits precision repair applied and owner QA verified.',
       src.topic_selections,'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_mcq014_saood_awe_repair','source_review_decision_id',r.source_decision_id,'qa_date','2026-08-05'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_mcq014_saood_awe_repair','source_review_decision_id',r.source_decision_id,'qa_date','2026-08-05')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from mcq014_repaired r
left join app.content_review_decisions src on src.content_review_decision_id=r.source_decision_id;

create temporary table mcq014_blocked as
select r.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
    when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
    when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from mcq014_repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from mcq014_blocked where reason is null;

update app.content_item_versions civ
set status='published',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from mcq014_repaired r
where civ.id=r.new_version_id
  and not exists (select 1 from mcq014_blocked b where b.content_key=r.content_key);

update app.content_items ci
set status='published', updated_at=now()
from mcq014_repaired r
join app.content_item_versions civ on civ.id=r.new_version_id
where ci.id=civ.content_item_id
  and civ.status='published';

insert into app.content_labels (
  exam_pack_id,label_key,label_name,label_type,status,created_by
)
values (
  'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid,
  'zeeshan-saood-apchem-parallel-followup-2026-08-05',
  'Zeeshan parallel AP Chemistry follow-up for Saood-assigned changes-requested items',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
)
on conflict (exam_pack_id, label_key) do update
set label_name=excluded.label_name,
    label_type=excluded.label_type,
    status=excluded.status;

create temporary table zeeshan_targets as
with latest as (
  select distinct on (ci.content_key)
         ci.content_key, ci.item_type, ci.status item_status,
         civ.id version_id, civ.version_num, civ.status version_status
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id
  join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
  join app.exam_packs ep on ep.id=epv.exam_pack_id
  join app.subjects s on s.id=ep.subject_id
  where s.display_name='AP Chemistry'
  order by ci.content_key, civ.version_num desc, civ.created_at desc
), saood_assigned as (
  select distinct l.*
  from latest l
  join app.content_review_assignments cra on cra.content_item_version_id=l.version_id
  join app.profiles p on p.user_id=cra.reviewer_id
  where p.full_name='Muhammad Saood'
    and cra.assignment_purpose='subject_review'
    and cra.status in ('pending','in_progress','submitted')
    and l.item_status='changes_requested'
)
select
  coalesce(existing.content_review_assignment_id, gen_random_uuid()) assignment_id,
  case when existing.content_review_assignment_id is null then 'inserted' else 'reactivated' end assignment_action,
  s.*
from saood_assigned s
left join app.content_review_assignments existing
  on existing.content_item_version_id=s.version_id
 and existing.reviewer_id='806b0a0e-8431-4aa5-ad71-b803a1792145'::uuid
 and existing.assignment_purpose='subject_review'
 and existing.review_stage='tutor_question'
left join app.content_review_decisions existing_decision
  on existing_decision.content_review_assignment_id=existing.content_review_assignment_id
 and existing_decision.review_stage='tutor_question'
where s.content_key <> 'apchem-mcq-014'
  and (
    existing.content_review_assignment_id is null
    or (
      existing.status in ('withdrawn','skipped')
      and existing_decision.content_review_decision_id is null
    )
  );

insert into app.content_review_assignments (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,review_kind,status,assignment_purpose,created_by
)
select assignment_id, version_id, '806b0a0e-8431-4aa5-ad71-b803a1792145'::uuid,
       'tutor_question', item_type, 'pending', 'subject_review', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from zeeshan_targets
where assignment_action='inserted';

update app.content_review_assignments cra
set status='pending',
    assigned_at=now(),
    created_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from zeeshan_targets z
where z.assignment_action='reactivated'
  and cra.content_review_assignment_id=z.assignment_id;

insert into app.content_review_assignment_labels (
  content_review_assignment_id,content_label_id,created_by
)
select z.assignment_id, l.id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from zeeshan_targets z
join app.content_labels l
  on l.exam_pack_id='bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid
 and l.label_key='zeeshan-saood-apchem-parallel-followup-2026-08-05'
on conflict do nothing;

do $$
declare
  n int;
begin
  select count(*) into n
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id
  where ci.content_key='apchem-mcq-014'
    and ci.status='published'
    and civ.status='published'
    and civ.prompt_json->>'qa_remediation'='2026-08-05 AP Chemistry MCQ-014 Saood AWE repair';
  if n<>1 then raise exception 'apchem-mcq-014 publish verification failed: %', n; end if;

  select count(*) into n from mcq014_blocked;
  if n<>0 then raise exception 'apchem-mcq-014 blocked: %', n; end if;
end $$;

select 'mcq014_published' metric, count(*)::text value
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key='apchem-mcq-014'
  and ci.status='published'
  and civ.status='published'
  and civ.prompt_json->>'qa_remediation'='2026-08-05 AP Chemistry MCQ-014 Saood AWE repair'
union all
select 'mcq014_blocked', count(*)::text from mcq014_blocked
union all
select 'zeeshan_assignments_added', count(*)::text from zeeshan_targets
union all
select 'zeeshan_assignments_inserted', count(*)::text from zeeshan_targets where assignment_action='inserted'
union all
select 'zeeshan_assignments_reactivated', count(*)::text from zeeshan_targets where assignment_action='reactivated'
union all
select 'zeeshan_assignment_keys', coalesce(string_agg(content_key, ', ' order by content_key),'') from zeeshan_targets;

commit;
