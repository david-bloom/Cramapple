-- Tail reconciliation for a decision submitted while the sweep was running.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-reviewer-qa-20260729-apphy1-frq-015')
);

do $$
declare
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_source app.content_review_decisions%rowtype;
  v_new_id uuid := gen_random_uuid();
  v_assignment_id uuid := gen_random_uuid();
  v_payload jsonb;
begin
  select * into strict v_item
  from app.content_items
  where lower(content_key)='apphy1-frq-015'
  for update;

  select * into strict v_old
  from app.content_item_versions
  where content_item_id=v_item.id
  order by version_num desc,created_at desc
  limit 1
  for update;

  if v_old.prompt_json->>'qa_remediation'=
     '2026-07-29 live sweep tail reconciliation' then
    return;
  end if;

  select * into strict v_source
  from app.content_review_decisions
  where content_review_decision_id='c7df2d2c-e13f-4ee9-b651-467067ee7b66';

  update app.content_item_versions set status='retired' where id=v_old.id;
  update app.content_items set status='draft' where id=v_item.id;

  insert into app.content_item_versions (
    id,content_item_id,version_num,stem,stimulus,prompt_json,
    explanation,help_text,content_hash,status,created_by,
    canonical_answer_1,canonical_answer_2,review_status,
    rubric_type,evaluator_strategy,stimulus_image_path
  ) values (
    v_new_id,v_item.id,v_old.version_num+1,
    'Answer all parts of the following question.'||E'\n\n'||
    '(a) Predict how the angular frequency and maximum speed each change when the oscillation amplitude is doubled, and justify the prediction quantitatively.'||E'\n\n'||
    '(b) Determine the factor by which the system''s total mechanical energy changes when the amplitude is doubled. Justify your answer from the spring-energy expression and calculate the energy before and after the change.',
    v_old.stimulus,
    coalesce(v_old.prompt_json,'{}'::jsonb)||jsonb_build_object(
      'content_version',v_old.version_num+1,
      'qa_remediation','2026-07-29 live sweep tail reconciliation',
      'qa_source_decision_id',v_source.content_review_decision_id
    ),
    v_old.explanation,v_old.help_text,md5(v_old.stem),'draft',
    'f5a26c6b-3566-4d58-9e97-979fbb947564',
    'The angular frequency remains 20.0 rad/s. Maximum speed doubles from 1.60 m/s to 3.20 m/s. Since E=(1/2)kA^2, total energy quadruples from 0.320 J to 1.28 J.',
    v_old.canonical_answer_2,null,v_old.rubric_type,
    v_old.evaluator_strategy,v_old.stimulus_image_path
  );

  insert into app.frq_criteria (
    content_item_version_id,criterion_key,learner_facing_text,
    points_possible,evidence_requirements,minimum_fix,accepted_variants
  )
  select v_new_id,criterion_key,learner_facing_text,points_possible,
         evidence_requirements,minimum_fix,accepted_variants
  from app.frq_criteria
  where content_item_version_id=v_old.id;

  update app.frq_criteria
  set learner_facing_text=
        'Uses E=(1/2)kA^2 to show that doubling amplitude quadruples total mechanical energy from 0.320 J to 1.28 J.',
      evidence_requirements=
        'Energy is proportional to A^2; factor of four; correct initial and final energies.',
      minimum_fix=
        'Show the A^2 dependence, factor of four, and energies 0.320 J and 1.28 J.'
  where content_item_version_id=v_new_id and criterion_key='part-b';

  update app.content_item_versions civ
  set content_hash=md5(
    coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
    coalesce(civ.canonical_answer_1,'')||E'\n'||
    coalesce((
      select string_agg(
        f.criterion_key||':'||f.points_possible::text||':'||
        f.learner_facing_text||':'||
        coalesce(f.evidence_requirements,'')||':'||
        coalesce(f.minimum_fix,''),
        E'\n' order by f.criterion_key
      )
      from app.frq_criteria f
      where f.content_item_version_id=civ.id
    ),'')
  )
  where civ.id=v_new_id;

  insert into app.content_review_assignments (
    content_review_assignment_id,content_item_version_id,reviewer_id,
    review_stage,review_kind,status,assignment_purpose,created_by
  ) values (
    v_assignment_id,v_new_id,
    'f5a26c6b-3566-4d58-9e97-979fbb947564',
    'tutor_question','frq','pending','owner_remediation_approval',
    'f5a26c6b-3566-4d58-9e97-979fbb947564'
  );

  v_payload := jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','independent_reviewer_decision_qa',
    'source_review_decision_id',v_source.content_review_decision_id,
    'qa_window_start','2026-07-28T22:18:23.390454Z',
    'qa_date','2026-07-29',
    'reconciliation','live_sweep_tail'
  );

  insert into app.content_review_decisions (
    content_review_assignment_id,content_item_version_id,reviewer_id,
    supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
    concern_codes,note,topic_selections,tutor_decision,decision_payload,
    decision_hash,created_by
  ) values (
    v_assignment_id,v_new_id,
    'f5a26c6b-3566-4d58-9e97-979fbb947564',
    v_source.content_review_decision_id,'tutor_question',1,
    coalesce(v_source.difficulty_label,'Medium'),false,array[]::text[],
    'Live-tail reviewer-decision QA correction verified; immutable source review preserved.',
    v_source.topic_selections,'approve',v_payload,
    encode(extensions.digest(v_payload::text,'sha256'),'hex'),
    'f5a26c6b-3566-4d58-9e97-979fbb947564'
  );

  if not exists (
    select 1
    from app.content_item_versions civ
    join app.content_items ci on ci.id=civ.content_item_id
    where civ.id=v_new_id
      and civ.status='reviewed_approved'
      and civ.review_status='question_review_approved'
      and ci.status='reviewed_approved'
  ) then
    raise exception 'apphy1-frq-015 tail reconciliation failed';
  end if;
end
$$;

commit;
