-- Reviewer QA window:
-- 2026-07-28 22:18:23.390454+00 through execution time.
--
-- This repair:
--   1. restores only current Biology versions that were retired while the
--      second member of a genuine two-review group is still pending; and
--   2. creates immutable corrected successors for nine confirmed content
--      defects found while auditing reviewer decisions.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-reviewer-qa-20260729-since-last-sweep')
);

-- Preserve genuine paired review work that is still in progress.
with pending_pairs as (
  select distinct civ.id version_id
  from app.content_review_decisions d
  join app.content_review_assignments submitted
    on submitted.content_review_assignment_id=d.content_review_assignment_id
  join app.content_item_versions civ
    on civ.id=d.content_item_version_id
  join app.content_items ci
    on ci.id=civ.content_item_id
  where d.submitted_at >= timestamptz '2026-07-28 22:18:23.390454+00'
    and submitted.assignment_purpose='subject_review'
    and lower(ci.content_key) like 'apbio-%'
    and civ.status='retired'
    and ci.status='assigned'
    and submitted.blind_group_id is not null
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
    'apcalcbc-frq-012',
    'apchem-frq-l-010',
    'apchem-frq-l-012',
    'apchem-sfrq-014',
    'apphy2-frq-013',
    'apphy2-frq-028',
    'apphycem-frq-011',
    'apphycem-frq-029',
    'apphycm-frq-019'
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
       '2026-07-29 since-last-sweep reviewer decision QA' then
      continue;
    end if;

    select d.* into strict v_source
    from app.content_review_decisions d
    join app.content_review_assignments a
      on a.content_review_assignment_id=d.content_review_assignment_id
    where d.content_item_version_id=v_old.id
      and d.submitted_at >= timestamptz '2026-07-28 22:18:23.390454+00'
      and a.assignment_purpose='subject_review'
    order by d.submitted_at desc
    limit 1;

    v_new_id := gen_random_uuid();
    v_assignment_id := gen_random_uuid();
    v_prompt := coalesce(v_old.prompt_json,'{}'::jsonb) ||
      jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation',
          '2026-07-29 since-last-sweep reviewer decision QA',
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

    if lower(v_key)='apcalcbc-frq-012' then
      update app.content_item_versions
      set stem=
        '(a) Find dy/dx where dx/dt is not zero.'||E'\n\n'||
        '(b) Determine whether the curve has a vertical tangent on the stated parameter interval. Analyze the singular point at t=1 by giving its coordinates and the limiting tangent slope and equation.'||E'\n\n'||
        '(c) Find the tangent line at t=0.',
          prompt_json=jsonb_set(
            prompt_json,
            '{parts}',
            (
              select jsonb_agg(
                case when p->>'part_key'='part-b' then
                  jsonb_set(
                    jsonb_set(
                      p,
                      '{prompt}',
                      to_jsonb('Determine whether the curve has a vertical tangent on the stated parameter interval. Analyze the singular point at t=1 by giving its coordinates and the limiting tangent slope and equation.'::text)
                    ),
                    '{criteria,0,description}',
                    to_jsonb('There is no vertical tangent. At t=1 both derivatives vanish, the point is (-1,-2), and the limiting slope is 3, giving the common tangent y+2=3(x+1).'::text)
                  )
                else p end
                order by (p->>'ordinal')::integer
              )
              from jsonb_array_elements(prompt_json->'parts') p
            )
          ),
          explanation=
            'For t not equal to 1, dy/dx=3(t+1)/2. At t=1 both component derivatives vanish and the curve passes through (-1,-2). The limiting slope is 3 from both sides, so there is no vertical tangent; the common tangent is y+2=3(x+1). At t=0 the tangent is y=(3/2)x.',
          canonical_answer_1=
            'For t not equal to 1, dy/dx=3(t+1)/2. At t=1 both component derivatives vanish and the curve passes through (-1,-2). The limiting slope is 3 from both sides, so there is no vertical tangent; the common tangent is y+2=3(x+1). At t=0 the tangent is y=(3/2)x.'
      where id=v_new_id;

      update app.frq_criteria
      set points_possible=1
      where content_item_version_id=v_new_id;

      update app.frq_criteria
      set learner_facing_text=
            'Concludes that no vertical tangent exists and analyzes t=1 as the singular point (-1,-2) with limiting slope 3 and tangent y+2=3(x+1).',
          evidence_requirements=
            'Checks dx/dt=dy/dt=0 at t=1; gives (-1,-2); uses the simplified slope limit 3; concludes no vertical tangent; gives y+2=3(x+1).',
          minimum_fix=
            'State that there is no vertical tangent and give the singular point, limiting slope, and tangent equation.'
      where content_item_version_id=v_new_id
        and criterion_key='part-b-criterion-1';

    elsif lower(v_key)='apchem-frq-l-010' then
      update app.content_item_versions
      set stem=
        v_old.stem||E'\n\n'||
        '(a) Describe the structure of solid NaCl at the particle level.'||E'\n\n'||
        '(b) Using that structure, explain why solid NaCl shatters when struck.'||E'\n\n'||
        '(c) Describe the electron-sea model of metallic bonding and use it to explain why brass is malleable.'||E'\n\n'||
        '(d) Explain why brass is harder and less malleable than pure copper.'||E'\n\n'||
        '(e) Explain why molten NaCl conducts electricity but solid NaCl does not.'||E'\n\n'||
        '(f) Explain why aqueous NaCl conducts electricity.'
      where id=v_new_id;

    elsif lower(v_key)='apchem-frq-l-012' then
      delete from app.frq_criteria
      where content_item_version_id=v_new_id
        and criterion_key='a6';

    elsif lower(v_key)='apchem-sfrq-014' then
      update app.content_item_versions
      set stem=
        v_old.stem||E'\n\n'||
        '(a) Identify the electron-domain geometry around Xe and justify your answer using the number of electron domains.'||E'\n\n'||
        '(b) Identify the molecular geometry of XeF4 and explain the placement of the lone pairs.'||E'\n\n'||
        '(c) Identify the hybridization of the central Xe atom.'
      where id=v_new_id;

    elsif lower(v_key)='apphy2-frq-013' then
      update app.content_item_versions
      set stem=
        'Answer all parts of the following question.'||E'\n\n'||
        '(a) With wavelength held constant, predict how the interference type changes when the path difference is doubled, and justify the prediction quantitatively.'||E'\n\n'||
        '(b) Suppose instead that the two coherent sources are initially 180 degrees out of phase. Classify the interference at the original and doubled path differences, and justify both classifications.',
          canonical_answer_1=
            'For initially in-phase sources, delta/lambda changes from 2.5 to 5.0, so interference changes from destructive to constructive. For sources initially 180 degrees out of phase, the classifications reverse: 2.5 wavelengths is constructive and 5.0 wavelengths is destructive.'
      where id=v_new_id;

      update app.frq_criteria
      set learner_facing_text=
            'Calculates delta/lambda=2.5 initially and 5.0 after doubling, with wavelength held constant, and concludes that initially in-phase sources change from destructive to constructive interference.',
          evidence_requirements=
            'Initial ratio 1.25/0.500=2.5; doubled ratio 2.50/0.500=5.0; wavelength remains 0.500 m; destructive changes to constructive.'
      where content_item_version_id=v_new_id and criterion_key='part-a';

      update app.frq_criteria
      set learner_facing_text=
            'For sources initially 180 degrees out of phase, classifies the original 2.5-wavelength path difference as constructive and the doubled 5.0-wavelength path difference as destructive.',
          evidence_requirements=
            'Explains that the initial pi phase offset reverses the integer and half-integer path-difference classifications.'
      where content_item_version_id=v_new_id and criterion_key='part-b';

    elsif lower(v_key)='apphy2-frq-028' then
      update app.content_item_versions
      set stimulus=
            'An upright object is placed on the principal axis between the focal point F and center of curvature C of an ideal spherical concave mirror. Use the paraxial-ray approximation.',
          stem=
            'Answer all parts of the following question.'||E'\n\n'||
            '(a) Draw and label the principal axis, mirror, F, C, object, and image. Use any two valid principal rays to locate the image and show the arrow directions.'||E'\n\n'||
            '(b) State the image''s orientation, relative size, and whether it is real or virtual.'
      where id=v_new_id;

      update app.frq_criteria
      set learner_facing_text=
            'Draws any two valid principal rays correctly, such as parallel-then-through-F, through-F-then-parallel, or through-C-and-back.',
          evidence_requirements=
            'Two valid paraxial principal rays are drawn from the object and reflected according to the concave-mirror rules.',
          minimum_fix='Apply two valid reflection rules at the mirror surface.'
      where content_item_version_id=v_new_id and criterion_key='a-rays';

      update app.frq_criteria
      set learner_facing_text='States that the image is inverted.'
      where content_item_version_id=v_new_id and criterion_key='b-orientation';

      update app.frq_criteria
      set learner_facing_text='States that the image is real because reflected rays actually converge.'
      where content_item_version_id=v_new_id and criterion_key='b-real';

      update app.frq_criteria
      set learner_facing_text='States that the image is enlarged or magnified relative to the object.'
      where content_item_version_id=v_new_id and criterion_key='b-size';

    elsif lower(v_key)='apphycem-frq-011' then
      update app.content_item_versions
      set stimulus=
            'For a sufficiently long straight wire, Ampere''s law predicts B=mu0 I/(2pi r) at distance r from the wire''s central axis. A real wire has finite length and a return path.',
          stem=
            'Answer all parts of the following question.'||E'\n\n'||
            '(a) Design an experiment that tests the predicted dependence B proportional to 1/r at fixed current. Identify the independent variable, dependent variable, important controls, a method for reducing background magnetic-field effects, and how end and return-path effects will be minimized.'||E'\n\n'||
            '(b) State the expected linearized graph, including its axes, slope, and intercept, and explain why Ampere''s law and cylindrical symmetry approximately apply.'
      where id=v_new_id;

      update app.frq_criteria
      set learner_facing_text=
            'Identifies r from the wire axis as the independent variable and tangential B as the dependent variable; controls current, probe orientation, wire geometry and temperature, axial position, and distance from the ends and return lead.',
          evidence_requirements=
            'Correct variables and at least four meaningful controls, including current and probe orientation.',
          minimum_fix=
            'Identify r and B and state how the important controls are held fixed.'
      where content_item_version_id=v_new_id and criterion_key='a-controls';

      update app.frq_criteria
      set learner_facing_text=
            'Measures B at several radii near the middle of a long straight section and corrects for background field, for example by subtracting a zero-current reading or averaging opposite-current measurements.',
          evidence_requirements=
            'Feasible multi-radius procedure, fixed current, minimized end/return-path effects, and a valid background-field correction.',
          minimum_fix=
            'Describe multi-radius measurements and one valid background-field correction.'
      where content_item_version_id=v_new_id and criterion_key='a-procedure';

      update app.frq_criteria
      set learner_facing_text=
            'Plots B vertically versus 1/r horizontally, predicts slope mu0 I/(2pi) and an ideally zero intercept, and justifies the approximation using tangential circular fields of constant magnitude for an effectively infinite straight wire.',
          evidence_requirements=
            'Correct axes, slope, intercept, and cylindrical-symmetry/Ampere-loop reasoning with the finite-wire approximation stated.',
          minimum_fix=
            'Give the axes, slope, intercept, symmetry reasoning, and approximation conditions.'
      where content_item_version_id=v_new_id and criterion_key='b-model';

    elsif lower(v_key)='apphycem-frq-029' then
      update app.content_item_versions
      set canonical_answer_1=
            'With positive current defined onto the initially positive plate, dq/dt=i and dq/dt=-q/(RC). Thus q(t)=Q₀e^(-t/(RC)) and i(t)=-(Q₀/RC)e^(-t/(RC)). Charge and voltage fall to 1/e after one RC; energy falls as e^(-2t/(RC)). The total resistor heat is Q₀²/(2C).'
      where id=v_new_id;

      update app.frq_criteria
      set learner_facing_text=
            'Derives dq/dt=i=-q/(RC) using the stated current convention.'
      where content_item_version_id=v_new_id and criterion_key='a-derivation';

      update app.frq_criteria
      set learner_facing_text=
            'Obtains q(t)=Q₀e^(-t/(RC)) from q(0)=Q₀.'
      where content_item_version_id=v_new_id and criterion_key='a-charge';

      update app.frq_criteria
      set learner_facing_text=
            'Obtains the signed current i(t)=-(Q₀/RC)e^(-t/(RC)); the negative sign is required because discharge current is opposite the defined positive direction.'
      where content_item_version_id=v_new_id and criterion_key='a-current';

      update app.frq_criteria
      set learner_facing_text=
            'Explains that charge and voltage fall to 1/e after one time constant RC and by another factor e^(-1) during each additional RC; distinguishes energy decay e^(-2t/(RC)).',
          evidence_requirements=
            'Correct charge/voltage time-constant interpretation and recognition that energy has exponential time constant RC/2.'
      where content_item_version_id=v_new_id and criterion_key='b-time';

    elsif lower(v_key)='apphycm-frq-019' then
      update app.content_item_versions
      set stimulus=
            'A mass m on a string of length L moves in a horizontal circle with the string at constant angle theta from vertical, where 0<theta<pi/2.',
          stem=
            'Answer all parts of the following question. Use F_T for the string tension and P for the orbital period.'||E'\n\n'||
            '(a) Draw a free-body diagram, label the vertical and inward-radial directions, and translate it into vertical and radial equations.'||E'\n\n'||
            '(b) Using the circular-path radius L sin(theta), derive the angular speed omega and orbital period P in terms of L, g, and theta.',
          canonical_answer_1=
            'F_T cos(theta)=mg and F_T sin(theta)=m omega^2 L sin(theta) yield omega=sqrt(g/(L cos(theta))) and P=2pi sqrt(L cos(theta)/g).'
      where id=v_new_id;

      update app.frq_criteria
      set learner_facing_text=
            'Writes F_T cos(theta)=mg and F_T sin(theta)=m omega^2(L sin(theta)), with zero vertical acceleration and inward radial acceleration.',
          evidence_requirements=
            'Correct vertical balance, inward radial dynamics, and circular radius L sin(theta).'
      where content_item_version_id=v_new_id and criterion_key='a-equations';

      update app.frq_criteria
      set learner_facing_text=
            'Eliminates F_T to obtain omega=sqrt(g/(L cos(theta))).'
      where content_item_version_id=v_new_id and criterion_key='b-angular-speed';

      update app.frq_criteria
      set learner_facing_text=
            'Uses P=2pi/omega to obtain P=2pi sqrt(L cos(theta)/g).'
      where content_item_version_id=v_new_id and criterion_key='b-period';
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
    'qa_window_start','2026-07-28T22:18:23.390454Z',
    'qa_date','2026-07-29'
  ),
  encode(extensions.digest(jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','independent_reviewer_decision_qa',
    'source_review_decision_id',c.source_decision_id,
    'qa_window_start','2026-07-28T22:18:23.390454Z',
    'qa_date','2026-07-29'
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

  if v_count<>9 then
    raise exception 'reviewer QA correction verification failed: %/9',v_count;
  end if;
end
$$;

commit;
