-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260728024450
-- recorded name: correct_packet_2_textual_qa_misses
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Correct three packet-2 phrase-selector misses discovered by post-publish QA.
-- Published versions remain immutable: each correction is a new successor.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-packet-2-textual-qa-corrections-20260728')
);

create temporary table corrected (
  content_key text primary key,
  content_item_id uuid not null,
  old_version_id uuid not null,
  new_version_id uuid not null,
  prior_approval_id uuid not null,
  assignment_id uuid not null
) on commit drop;

do $$
declare
  k text;
  item app.content_items%rowtype;
  old_v app.content_item_versions%rowtype;
  new_id uuid;
  approval_id uuid;
begin
  foreach k in array array[
    'apphy2-frq-026','apphy2-frq-027','apphy2-frq-033'
  ] loop
    select * into strict item
    from app.content_items
    where lower(content_key)=lower(k);

    select * into strict old_v
    from app.content_item_versions
    where content_item_id=item.id
    order by version_num desc,created_at desc
    limit 1
    for update;

    if old_v.version_num<>2 or old_v.status<>'published' then
      raise exception '% expected published v2, found v% %',
        k,old_v.version_num,old_v.status;
    end if;

    select content_review_decision_id into strict approval_id
    from app.content_review_decisions
    where content_item_version_id=old_v.id
      and decision_payload->>'approval_basis'=
          'single_qualified_review_plus_ai_qa'
    order by submitted_at desc
    limit 1;

    update app.content_item_versions set status='retired' where id=old_v.id;
    update app.content_items set status='draft' where id=item.id;

    insert into app.content_item_versions (
      content_item_id,version_num,stem,stimulus,prompt_json,explanation,
      help_text,content_hash,status,created_by,canonical_answer_1,
      canonical_answer_2,review_status,rubric_type,evaluator_strategy,
      stimulus_image_path
    ) values (
      item.id,3,old_v.stem,old_v.stimulus,
      coalesce(old_v.prompt_json,'{}'::jsonb)||jsonb_build_object(
        'content_version',3,
        'qa_correction','2026-07-27 packet-2 post-publish textual QA',
        'source_version_id',old_v.id
      ),
      old_v.explanation,old_v.help_text,old_v.content_hash,'draft',
      'f5a26c6b-3566-4d58-9e97-979fbb947564',
      old_v.canonical_answer_1,old_v.canonical_answer_2,null,
      old_v.rubric_type,old_v.evaluator_strategy,old_v.stimulus_image_path
    ) returning id into new_id;

    insert into app.frq_criteria (
      content_item_version_id,criterion_key,learner_facing_text,
      points_possible,evidence_requirements,minimum_fix,accepted_variants
    )
    select new_id,criterion_key,learner_facing_text,points_possible,
           evidence_requirements,minimum_fix,accepted_variants
    from app.frq_criteria
    where content_item_version_id=old_v.id;

    insert into corrected values (
      k,item.id,old_v.id,new_id,approval_id,gen_random_uuid()
    );
  end loop;
end
$$;

update app.content_item_versions
set stem=E'Answer all parts of the following question.\n\n(a) Determine the magnetic-field magnitude produced by the first wire at the location of the second wire, and determine the force magnitude on the segment.\n\n(b) State the force direction and how it changes if one current reverses.'
where id=(select new_version_id from corrected
          where content_key='apphy2-frq-026');

update app.content_item_versions
set stem=E'Answer all parts of the following question.\n\n(a) Design a procedure to test how peak induced emf depends on magnet speed.\n\n(b) Identify variables, controls, and a graph.\n\n(c) Predict the voltage trace when the magnet enters and leaves the coil and explain why the entering and leaving pulses have opposite signs.'
where id=(select new_version_id from corrected
          where content_key='apphy2-frq-027');

update app.content_item_versions
set canonical_answer_1=
      'After 18 h, 1.0×10¹² remain and 7/8 have decayed. Energy=(7.0×10¹²)(0.80×10⁶ eV)(1.602×10⁻¹⁹ J/eV)=0.897 J, reported as approximately 0.90 J to two significant figures.'
where id=(select new_version_id from corrected
          where content_key='apphy2-frq-033');

update app.frq_criteria
set learner_facing_text=
      'Calculate the released energy and report it with appropriate significant figures.',
    evidence_requirements=
      'Uses 7.0×10¹² decays to obtain 0.897 J, then reports approximately 0.90 J to match the two significant figures of 0.80 MeV.',
    minimum_fix=
      'Allow 0.897 J as work but report the final result as 0.90 J.'
where content_item_version_id=(
  select new_version_id from corrected where content_key='apphy2-frq-033'
)
and criterion_key='b-energy';

update app.content_item_versions civ
set content_hash=md5(
  coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce(civ.canonical_answer_1,'')||E'\n'||
  coalesce((select string_agg(
    r.criterion_key||':'||r.points_possible::text||':'||
    r.learner_facing_text||':'||coalesce(r.evidence_requirements,'')||':'||
    coalesce(r.minimum_fix,''),E'\n' order by r.criterion_key)
    from app.frq_criteria r
    where r.content_item_version_id=civ.id),'')
)
from corrected c
where civ.id=c.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,review_kind,status,assignment_purpose,created_by
)
select assignment_id,new_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question','frq','pending','owner_remediation_approval',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from corrected;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,tutor_decision,decision_payload,
  decision_hash,created_by
)
select
  c.assignment_id,c.new_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  c.prior_approval_id,'tutor_question',1,
  coalesce(prior.difficulty_label,'Medium'),false,array[]::text[],
  'Post-publish textual QA correction passed; immutable successor approved under the single-review plus AI-QA policy.',
  prior.topic_selections,'approve',
  jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','single_qualified_review_plus_ai_qa',
    'packet','cross_subject_repair_packet_2',
    'qa_correction','post_publish_textual_assertion',
    'source_human_review_decision_id',
      prior.decision_payload->'source_human_review_decision_id',
    'second_human_review_status','follow_up_pending',
    'policy_confirmed_on','2026-07-27'
  ),
  encode(extensions.digest(jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','single_qualified_review_plus_ai_qa',
    'packet','cross_subject_repair_packet_2',
    'qa_correction','post_publish_textual_assertion',
    'second_human_review_status','follow_up_pending',
    'policy_confirmed_on','2026-07-27'
  )::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from corrected c
join app.content_review_decisions prior
  on prior.content_review_decision_id=c.prior_approval_id;

update app.content_item_versions civ
set status='published',
    approved_at=coalesce(approved_at,now()),
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564',
    published_at=now(),
    review_status='question_review_approved'
from corrected c
where civ.id=c.new_version_id
  and civ.status='reviewed_approved';

update app.content_items ci
set status='published'
from corrected c
where ci.id=c.content_item_id
  and exists (
    select 1 from app.content_item_versions civ
    where civ.id=c.new_version_id and civ.status='published'
  );

do $$
declare
  n integer;
begin
  select count(*) into n
  from corrected c
  join app.content_item_versions old_v on old_v.id=c.old_version_id
  join app.content_item_versions new_v on new_v.id=c.new_version_id
  join app.content_items ci on ci.id=c.content_item_id
  where old_v.status='retired'
    and new_v.status='published'
    and new_v.review_status='question_review_approved'
    and ci.status='published';
  if n<>3 then
    raise exception 'expected three corrected published successors, found %',n;
  end if;

  if not exists (
    select 1 from corrected c
    join app.content_item_versions v on v.id=c.new_version_id
    where c.content_key='apphy2-frq-026'
      and v.stem ilike '%magnetic-field magnitude%'
  ) or not exists (
    select 1 from corrected c
    join app.content_item_versions v on v.id=c.new_version_id
    where c.content_key='apphy2-frq-027'
      and v.stem ilike '%opposite signs%'
  ) or not exists (
    select 1 from corrected c
    join app.frq_criteria f on f.content_item_version_id=c.new_version_id
    where c.content_key='apphy2-frq-033'
      and f.criterion_key='b-energy'
      and f.evidence_requirements ilike '%0.90 J%'
  ) then
    raise exception 'textual QA correction assertion failed';
  end if;
end
$$;

commit;
;
