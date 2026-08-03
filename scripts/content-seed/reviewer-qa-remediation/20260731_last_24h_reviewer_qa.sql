-- Reviewer QA window:
-- 2026-07-30 03:31:05+00 through the execution time.
--
-- This repair:
--   1. restores three Biology versions stranded while a paired review is pending;
--   2. excludes three AP Statistics items that are outside the AP course scope
--      or do not assess a defined statistical concept; and
--   3. creates corrected, independently QA-approved successor versions for four
--      AP Chemistry items with scientific or rubric defects.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-reviewer-qa-20260731-last-24h')
);

-- Restore only current Biology versions with one submitted and one still-active
-- member of the same blind pair.
with targets as (
  select civ.id
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id
  where lower(ci.content_key) in (
    'apbio-frq-s-017',
    'apbio-frq-s-026',
    'apbio-frq-s-064'
  )
    and ci.status='assigned'
    and civ.status='retired'
    and civ.review_status='tutor_review_pending'
    and not exists (
      select 1
      from app.content_item_versions newer
      where newer.content_item_id=ci.id
        and newer.version_num>civ.version_num
    )
    and exists (
      select 1
      from app.content_review_assignments pending
      where pending.content_item_version_id=civ.id
        and pending.assignment_purpose='subject_review'
        and pending.review_stage='tutor_question'
        and pending.status in ('pending','in_progress')
    )
    and exists (
      select 1
      from app.content_review_assignments submitted
      where submitted.content_item_version_id=civ.id
        and submitted.assignment_purpose='subject_review'
        and submitted.review_stage='tutor_question'
        and submitted.status='submitted'
    )
)
update app.content_item_versions civ
set status='assigned',
    updated_at=now()
from targets t
where civ.id=t.id;

create temporary table qa_excluded (
  content_key text primary key,
  version_id uuid not null,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

do $$
declare
  v_key text;
  v_item app.content_items%rowtype;
  v_version app.content_item_versions%rowtype;
  v_source app.content_review_decisions%rowtype;
begin
  foreach v_key in array array[
    'STATS-MOD9-VH001',
    'STATS-MOD9-VH002',
    'APSTATS-HDG-2026-GRAPH-006'
  ] loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(v_key)
    for update;

    select * into strict v_version
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc, created_at desc
    limit 1
    for update;

    if v_version.status='retired'
       and v_version.review_status='excluded' then
      continue;
    end if;

    select d.* into strict v_source
    from app.content_review_decisions d
    join app.content_review_assignments a
      on a.content_review_assignment_id=d.content_review_assignment_id
    where d.content_item_version_id=v_version.id
      and d.reviewer_id='0a5909f7-f50b-486a-a31f-4fc3cc47e039'
      and d.tutor_decision='approve'
      and d.submitted_at>=timestamptz '2026-07-30 03:31:05+00'
      and a.assignment_purpose='subject_review'
    order by d.submitted_at desc
    limit 1;

    insert into qa_excluded values (
      v_key,v_version.id,v_source.content_review_decision_id,gen_random_uuid()
    );
  end loop;
end
$$;

insert into app.content_review_assignments (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,review_kind,status,assignment_purpose,created_by
)
select assignment_id,version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question','frq','pending','owner_remediation_approval',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_excluded;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,tutor_decision,decision_payload,
  decision_hash,created_by
)
select
  e.assignment_id,e.version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  e.source_decision_id,'tutor_question',3,
  coalesce(source.difficulty_label,'Medium'),true,
  array['Other']::text[],
  case lower(e.content_key)
    when 'stats-mod9-vh001' then
      'Independent QA exclusion: nonparametric tests such as Mann-Whitney are outside the AP Statistics Course and Exam Description.'
    when 'stats-mod9-vh002' then
      'Independent QA exclusion: bootstrap confidence intervals are outside the AP Statistics Course and Exam Description.'
    else
      'Independent QA exclusion: the item asks students to copy a supplied curve and read a table-given point without defining or assessing a statistical concept.'
  end,
  source.topic_selections,'disapprove',
  jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',3,
    'tutor_decision','disapprove',
    'approval_basis','independent_reviewer_decision_qa',
    'source_review_decision_id',e.source_decision_id,
    'qa_window_start','2026-07-30T03:31:05Z',
    'qa_date','2026-07-31'
  ),
  encode(extensions.digest(jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',3,
    'tutor_decision','disapprove',
    'approval_basis','independent_reviewer_decision_qa',
    'source_review_decision_id',e.source_decision_id,
    'qa_window_start','2026-07-30T03:31:05Z',
    'qa_date','2026-07-31'
  )::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_excluded e
join app.content_review_decisions source
  on source.content_review_decision_id=e.source_decision_id;

update app.content_review_assignments a
set status='skipped'
from qa_excluded e
where a.content_item_version_id=e.version_id
  and a.assignment_purpose='subject_review'
  and a.status in ('pending','in_progress');

update app.content_item_versions civ
set status='retired',
    review_status='excluded',
    approved_at=null,
    approved_by=null,
    updated_at=now()
from qa_excluded e
where civ.id=e.version_id;

update app.content_items ci
set status='retired',
    updated_at=now()
from qa_excluded e
join app.content_item_versions civ on civ.id=e.version_id
where ci.id=civ.content_item_id;

create temporary table qa_corrected (
  content_key text primary key,
  item_type text not null,
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
  v_prompt jsonb;
begin
  foreach v_key in array array[
    'apchem-frq-l-013',
    'apchem-frq-l-014',
    'apchem-mcq-026',
    'apchem-mcq-029'
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
       '2026-07-31 last-24h reviewer decision QA' then
      continue;
    end if;

    select d.* into strict v_source
    from app.content_review_decisions d
    join app.content_review_assignments a
      on a.content_review_assignment_id=d.content_review_assignment_id
    where d.content_item_version_id=v_old.id
      and d.submitted_at>=timestamptz '2026-07-30 03:31:05+00'
      and a.assignment_purpose='subject_review'
    order by d.submitted_at desc
    limit 1;

    v_new_id:=gen_random_uuid();
    v_prompt:=coalesce(v_old.prompt_json,'{}'::jsonb) ||
      jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-07-31 last-24h reviewer decision QA',
        'qa_source_decision_id',v_source.content_review_decision_id
      );

    update app.content_review_assignments
    set status='skipped'
    where content_item_version_id=v_old.id
      and assignment_purpose='subject_review'
      and status in ('pending','in_progress');

    update app.content_item_versions
    set status='retired',
        updated_at=now()
    where id=v_old.id;

    update app.content_items
    set status='draft',
        updated_at=now()
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

    insert into app.mcq_choices (
      content_item_version_id,choice_key,choice_text,is_correct,rationale
    )
    select v_new_id,choice_key,choice_text,is_correct,rationale
    from app.mcq_choices
    where content_item_version_id=v_old.id;

    if lower(v_key)='apchem-frq-l-013' then
      update app.content_item_versions
      set stem=replace(
        stem,
        '(a) Describe a first separation step the student should perform, and explain, at the particulate level, why this step successfully separates one component from the other two.',
        '(a) Describe the first stage of the separation, including the steps needed to recover uncontaminated, dry CaCO3(s), and explain at the particulate level why the separation works.'
      )
      where id=v_new_id;

      update app.frq_criteria
      set points_possible=1,
          learner_facing_text=
            'Explains at the particulate level that solid CaCO3 is retained by the filter while dissolved Na+ and Cl- ions and water pass into the filtrate.',
          evidence_requirements=
            'States that the undissolved CaCO3 particles remain on the filter while the aqueous ions and water pass through.',
          minimum_fix=
            'Distinguish the retained insoluble CaCO3(s) from the dissolved ions that pass through the filter.'
      where content_item_version_id=v_new_id
        and criterion_key='a2';

      insert into app.frq_criteria (
        content_item_version_id,criterion_key,learner_facing_text,
        points_possible,evidence_requirements,minimum_fix,accepted_variants
      ) values (
        v_new_id,'a3',
        'Rinses the filter residue with a small amount of deionized water to remove adhering NaCl(aq), then dries the CaCO3(s).',
        1,
        'Includes both washing the retained solid to remove soluble NaCl and drying it to recover uncontaminated solid CaCO3.',
        'Add a deionized-water wash of the residue followed by drying.',
        '["Equivalent washing and drying procedure earns credit."]'::jsonb
      );

    elsif lower(v_key)='apchem-frq-l-014' then
      update app.content_item_versions
      set stem=replace(
            replace(
              replace(
                replace(
                  replace(stem,'60C','60 °C'),
                  '20C','20 °C'
                ),
                '80C','80 °C'
              ),
              'If the solution were cooled very slowly and carefully, it is possible to reach 20 °C with all 80. g of KNO3 still dissolved.',
              'If the solution is cooled to 20 °C while kept undisturbed and free of seed crystals, it may be possible for all 80. g of KNO3 to remain dissolved.'
            ),
            'why lowering the temperature causes solid KNO3 to crystallize out of an otherwise stable solution',
            'why lowering the temperature shifts the dissolution equilibrium toward crystallization'
          ),
          stimulus=replace(
            replace(
              replace(stimulus,'20 |','20 |'),
              'Temperature (C)','Temperature (°C)'
            ),
            '80C','80 °C'
          )
      where id=v_new_id;

      update app.frq_criteria
      set learner_facing_text=
            'Explains that dissolving KNO3 is endothermic, so lowering the temperature shifts the dissolution equilibrium toward solid KNO3 and crystallization continues until the lower equilibrium solubility is reached.',
          evidence_requirements=
            'Connects the endothermic dissolution of KNO3 to a temperature-dependent equilibrium shift toward crystallization on cooling.',
          minimum_fix=
            'State that KNO3 dissolution is endothermic and cooling favors the reverse, crystallization direction.'
      where content_item_version_id=v_new_id
        and criterion_key='c1';

      update app.frq_criteria
      set learner_facing_text=
            'Identifies the solution as supersaturated and metastable because it contains more dissolved KNO3 than the equilibrium solubility at 20 °C; nucleation caused by a seed crystal, scratching, or agitation can trigger crystallization.',
          evidence_requirements=
            'Identifies a supersaturated, metastable solution and explains that nucleation or disturbance can trigger precipitation of the excess solute.',
          minimum_fix=
            'Name the solution supersaturated and connect its instability to nucleation-triggered crystallization.'
      where content_item_version_id=v_new_id
        and criterion_key='d1';

    elsif lower(v_key)='apchem-mcq-026' then
      update app.mcq_choices
      set rationale=
        'Correct. The conventional Lewis structure of ClF3 has three Cl-F bonds and two lone pairs on chlorine, placing five electron domains and ten electrons around the central period-3 atom. The trigonal-bipyramidal electron-domain arrangement gives a T-shaped molecule.'
      where content_item_version_id=v_new_id
        and choice_key='B';

    elsif lower(v_key)='apchem-mcq-029' then
      update app.content_item_versions
      set stem=
        E'Which substance is expected to have the highest normal boiling point?\n\nA. CH4\nB. CH3Cl\nC. CH3OH\nD. C2H6'
      where id=v_new_id;

      update app.mcq_choices
      set choice_text=case choice_key
            when 'A' then 'CH4'
            when 'B' then 'CH3Cl'
            when 'C' then 'CH3OH'
            when 'D' then 'C2H6'
          end,
          is_correct=(choice_key='C'),
          rationale=case choice_key
            when 'A' then
              'Incorrect. CH4 is a small nonpolar molecule whose molecules attract one another only through relatively weak London dispersion forces.'
            when 'B' then
              'Incorrect. CH3Cl is polar and has dipole-dipole attractions, but it cannot form hydrogen bonds with itself because its hydrogen atoms are bonded to carbon.'
            when 'C' then
              'Correct. CH3OH molecules form hydrogen bonds through the O-H group. For these particular substances, that strong intermolecular attraction produces the highest normal boiling point.'
            when 'D' then
              'Incorrect. C2H6 is nonpolar. Although it is more polarizable than CH4, its molecules experience only London dispersion forces and its boiling point is below that of CH3OH.'
          end
      where content_item_version_id=v_new_id;
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
      ),'')||E'\n'||
      coalesce((
        select string_agg(
          m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||
          coalesce(m.rationale,''),
          E'\n' order by m.choice_key
        )
        from app.mcq_choices m
        where m.content_item_version_id=civ.id
      ),'')
    )
    where civ.id=v_new_id;

    insert into qa_corrected values (
      v_key,v_item.item_type,v_old.id,v_new_id,
      v_source.content_review_decision_id,gen_random_uuid()
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
  'tutor_question',item_type,'pending','owner_remediation_approval',
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
    'qa_window_start','2026-07-30T03:31:05Z',
    'qa_date','2026-07-31'
  ),
  encode(extensions.digest(jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','independent_reviewer_decision_qa',
    'source_review_decision_id',c.source_decision_id,
    'qa_window_start','2026-07-30T03:31:05Z',
    'qa_date','2026-07-31'
  )::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from qa_corrected c
join app.content_review_decisions source
  on source.content_review_decision_id=c.source_decision_id;

do $$
declare
  v_biology integer;
  v_excluded integer;
  v_corrected integer;
begin
  select count(*) into v_biology
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id=ci.id
  where lower(ci.content_key) in (
    'apbio-frq-s-017','apbio-frq-s-026','apbio-frq-s-064'
  )
    and ci.status='assigned'
    and civ.status='assigned'
    and civ.review_status='tutor_review_pending'
    and exists (
      select 1 from app.content_review_assignments a
      where a.content_item_version_id=civ.id
        and a.status in ('pending','in_progress')
    );

  select count(*) into v_excluded
  from qa_excluded e
  join app.content_item_versions civ on civ.id=e.version_id
  join app.content_items ci on ci.id=civ.content_item_id
  where civ.status='retired'
    and civ.review_status='excluded'
    and ci.status='retired';

  select count(*) into v_corrected
  from qa_corrected c
  join app.content_item_versions civ on civ.id=c.new_version_id
  join app.content_items ci on ci.id=civ.content_item_id
  where civ.status='reviewed_approved'
    and civ.review_status='question_review_approved'
    and ci.status='reviewed_approved';

  if v_biology<>3 or v_excluded<>3 or v_corrected<>4 then
    raise exception
      'reviewer QA verification failed: biology %/3, excluded %/3, corrected %/4',
      v_biology,v_excluded,v_corrected;
  end if;
end
$$;

commit;
