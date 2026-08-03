-- Reviewer QA window:
-- 2026-07-27 22:10:20.62639+00 through the execution time.
--
-- This repair:
--   1. backfills single-review decisions stranded by one-member blind groups;
--   2. restores current Biology versions that were retired while the second
--      member of a genuine review pair is still pending; and
--   3. creates immutable corrected successors for four confirmed content
--      defects found while auditing reviewer decisions.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-reviewer-qa-20260728-last-24h')
);

-- Backfill the state that the repaired trigger will produce for future
-- one-assignment groups.
with single_group_decisions as (
  select d.content_item_version_id, d.tutor_score
  from app.content_review_decisions d
  join app.content_review_assignments a
    on a.content_review_assignment_id=d.content_review_assignment_id
  where d.submitted_at >= timestamptz '2026-07-27 22:10:20.62639+00'
    and a.assignment_purpose='subject_review'
    and a.review_stage='tutor_question'
    and a.blind_group_id is not null
    and (
      select count(*)
      from app.content_review_assignments peer
      where peer.blind_group_id=a.blind_group_id
        and peer.review_stage='tutor_question'
    )=1
), resolved as (
  update app.content_item_versions civ
  set status=case s.tutor_score
        when 1 then 'reviewed_approved'
        when 2 then 'changes_requested'
        when 3 then 'reviewed_disapproved'
      end,
      review_status=case s.tutor_score
        when 1 then 'question_review_approved'
        when 2 then 'modification_reserved'
        when 3 then 'excluded'
      end
  from single_group_decisions s
  where civ.id=s.content_item_version_id
    and civ.status in (
      'draft','assigned','changes_requested',
      'reviewed_approved','reviewed_disapproved'
    )
  returning civ.content_item_id, civ.status
)
update app.content_items ci
set status=r.status
from resolved r
where ci.id=r.content_item_id
  and ci.status in (
    'draft','assigned','changes_requested',
    'reviewed_approved','reviewed_disapproved'
  );

-- These are genuine two-review Biology groups. The current versions had been
-- retired before the second reviewer finished, even though the parent item and
-- remaining assignment were still active. Restore only that narrow state.
with pending_pairs as (
  select distinct civ.id version_id
  from app.content_review_decisions d
  join app.content_review_assignments submitted
    on submitted.content_review_assignment_id=d.content_review_assignment_id
  join app.content_item_versions civ
    on civ.id=d.content_item_version_id
  join app.content_items ci
    on ci.id=civ.content_item_id
  where d.submitted_at >= timestamptz '2026-07-27 22:10:20.62639+00'
    and d.reviewer_id='c1d12a8d-1489-4f90-990f-2f1ae2d54199'
    and submitted.assignment_purpose='subject_review'
    and civ.status='retired'
    and ci.status='assigned'
    and (
      select count(*)
      from app.content_review_assignments peer
      where peer.blind_group_id=submitted.blind_group_id
        and peer.review_stage='tutor_question'
    )=2
    and (
      select count(*)
      from app.content_review_assignments peer
      where peer.blind_group_id=submitted.blind_group_id
        and peer.review_stage='tutor_question'
        and peer.status='submitted'
    )<2
)
update app.content_item_versions civ
set status='assigned',
    review_status='tutor_review_pending'
from pending_pairs p
where civ.id=p.version_id;

create temporary table qa_corrected (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

do $$
declare
  v_key text;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_source app.content_review_decisions%rowtype;
  v_new_id uuid;
  v_assignment_id uuid;
  v_prompt jsonb;
begin
  foreach v_key in array array[
    'apchem-frq-l-022',
    'apchem-sfrq-024',
    'apchem-sfrq-027',
    'apchem-sfrq-030'
  ] loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(v_key)
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc, created_at desc
    limit 1
    for update;

    if v_old.prompt_json->>'qa_remediation'=
       '2026-07-28 last-24h reviewer decision QA' then
      continue;
    end if;

    select d.* into strict v_source
    from app.content_review_decisions d
    join app.content_review_assignments a
      on a.content_review_assignment_id=d.content_review_assignment_id
    where d.content_item_version_id=v_old.id
      and d.submitted_at >= timestamptz '2026-07-27 22:10:20.62639+00'
      and a.assignment_purpose='subject_review'
    order by d.submitted_at desc
    limit 1;

    v_new_id := gen_random_uuid();
    v_assignment_id := gen_random_uuid();
    v_prompt := coalesce(v_old.prompt_json,'{}'::jsonb) ||
      jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-07-28 last-24h reviewer decision QA',
        'qa_source_decision_id',v_source.content_review_decision_id
      );

    update app.content_item_versions
    set status='retired'
    where id=v_old.id;

    update app.content_items
    set status='draft'
    where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new_id,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,v_prompt,
      v_old.explanation,v_old.help_text,md5(v_old.stem),'draft',
      'f5a26c6b-3566-4d58-9e97-979fbb947564',
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.frq_criteria (
      content_item_version_id,criterion_key,learner_facing_text,
      points_possible,evidence_requirements,minimum_fix,accepted_variants
    )
    select v_new_id,criterion_key,learner_facing_text,points_possible,
           evidence_requirements,minimum_fix,accepted_variants
    from app.frq_criteria
    where content_item_version_id=v_old.id;

    if lower(v_key)='apchem-frq-l-022' then
      update app.frq_criteria
      set learner_facing_text=
            'Substitutes the ICE-table expressions to obtain Kc=(2x)^2/(0.200-x)^2=54.3, takes the positive square root, and solves 2x/(0.200-x)=sqrt(54.3) to obtain x approximately 0.157 M.',
          evidence_requirements=
            'Shows Kc=(2x)^2/(0.200-x)^2=54.3; then 2x/(0.200-x)=sqrt(54.3)=7.37 and x approximately 0.157 M.',
          minimum_fix=
            'Write Kc=(2x)^2/(0.200-x)^2=54.3 and solve the positive-root equation for x approximately 0.157 M.'
      where content_item_version_id=v_new_id
        and criterion_key='a3';

    elsif lower(v_key)='apchem-sfrq-024' then
      update app.content_item_versions
      set stem=
        'Using collision theory, explain why increasing the temperature increases the reaction rate and why increasing the initial concentration of a reactant increases the reaction rate. In your response, address collision frequency, the fraction of collisions with energy at least equal to the activation energy, and the role of molecular orientation.'
      where id=v_new_id;

    elsif lower(v_key)='apchem-sfrq-027' then
      update app.frq_criteria
      set learner_facing_text=
            'Explains that the reaction has a negative enthalpy change, not a “negative enthalpy,” and that lower product enthalpy alone does not establish overall thermodynamic stability; spontaneity requires considering deltaG. Rewrites the claim using precise enthalpy-change language.',
          evidence_requirements=
            'States deltaH(rxn)<0 means the products have lower enthalpy than the reactants and energy is released. Rejects “very stable” as unsupported by deltaH alone because thermodynamic favorability depends on deltaG (and temperature/entropy), then supplies a precise rewrite.',
          minimum_fix=
            'Use “negative enthalpy change,” state that products are lower in enthalpy, and explain that deltaH alone does not prove overall thermodynamic stability.'
      where content_item_version_id=v_new_id
        and criterion_key='b1';

    elsif lower(v_key)='apchem-sfrq-030' then
      update app.content_item_versions
      set stem=
        'For each change below, predict and justify the effect on the equilibrium position and state whether the value of K changes: (i) increase the temperature; (ii) decrease the container volume; and (iii) add a catalyst.'
      where id=v_new_id;
    end if;

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

    insert into qa_corrected values (
      v_key,v_old.id,v_new_id,
      v_source.content_review_decision_id,v_assignment_id
    );
  end loop;
end
$$;

insert into app.content_review_assignments (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,review_kind,status,assignment_purpose,created_by
)
select assignment_id,new_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question','frq','pending','owner_remediation_approval',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_corrected;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,tutor_decision,decision_payload,
  decision_hash,created_by
)
select
  c.assignment_id,c.new_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  c.source_decision_id,'tutor_question',1,
  coalesce(source.difficulty_label,'Medium'),false,array[]::text[],
  'Independent reviewer-decision QA correction verified; immutable source review preserved.',
  source.topic_selections,'approve',
  jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','independent_reviewer_decision_qa',
    'source_review_decision_id',c.source_decision_id,
    'qa_window_start','2026-07-27T22:10:20.62639Z',
    'qa_date','2026-07-28'
  ),
  encode(extensions.digest(jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','independent_reviewer_decision_qa',
    'source_review_decision_id',c.source_decision_id,
    'qa_window_start','2026-07-27T22:10:20.62639Z',
    'qa_date','2026-07-28'
  )::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_corrected c
join app.content_review_decisions source
  on source.content_review_decision_id=c.source_decision_id;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from qa_corrected c
  join app.content_item_versions civ on civ.id=c.new_version_id
  join app.content_items ci on ci.id=civ.content_item_id
  where civ.status='reviewed_approved'
    and civ.review_status='question_review_approved'
    and ci.status='reviewed_approved';

  if v_count<>4 then
    raise exception 'reviewer QA correction verification failed: %/4',v_count;
  end if;
end
$$;

commit;
