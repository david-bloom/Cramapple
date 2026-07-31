-- Create immutable draft successors for the 21-question cross-subject
-- remediation pilot and reconcile 12 superseded Chemistry FRQ review labels.
--
-- No successor is approved or published here. Two no-change/adjudication
-- controls are forked as draft without altering their question content:
-- APSTAT-MOD8-M004 and apchem-mcq-050.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-cross-subject-pilot-repair-20260728')
);

create temporary table pilot_targets (
  content_key text primary key,
  source_version_num integer not null,
  repair_class text not null
) on commit drop;

insert into pilot_targets values
  ('apphy1-frq-013',2,'rubric_point_restructuring'),
  ('apphy1-frq-034',1,'rubric_point_restructuring'),
  ('apphy2-frq-018',1,'rubric_point_restructuring'),
  ('apphy2-frq-024',1,'rubric_point_restructuring'),
  ('apphy2-frq-028',1,'rubric_point_restructuring'),
  ('apphycem-frq-024',1,'rubric_point_restructuring'),
  ('apphycm-frq-019',1,'rubric_point_restructuring'),
  ('apphycm-frq-028',1,'rubric_point_restructuring'),
  ('apphy2-frq-013',1,'assumption_or_convention'),
  ('apphy2-frq-016',1,'assumption_or_convention'),
  ('apphycem-frq-002',1,'assumption_or_convention'),
  ('apphycem-frq-029',1,'assumption_or_convention'),
  ('apphycm-frq-021',1,'assumption_or_convention'),
  ('apphycm-mcq-004',1,'assumption_or_convention'),
  ('APBIO-HDG-2026-GRAPH-006',1,'substantive_rewrite'),
  ('APBIO-MCQ-069',1,'substantive_rewrite'),
  ('apchem-mcq-050',1,'second_review_no_content_change'),
  ('apphy1-frq-009',1,'substantive_rewrite'),
  ('apphy2-frq-009',1,'substantive_rewrite'),
  ('apphycem-frq-011',1,'substantive_rewrite'),
  ('APSTAT-MOD8-M004',1,'second_review_no_content_change');

create temporary table pilot_context (
  content_key text primary key,
  content_item_id uuid not null,
  source_version_id uuid not null,
  successor_version_id uuid not null,
  source_version_num integer not null,
  successor_version_num integer not null,
  repair_class text not null
) on commit drop;

do $$
declare
  t pilot_targets%rowtype;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new_id uuid;
  v_actor uuid := 'f5a26c6b-3566-4d58-9e97-979fbb947564';
begin
  if not exists (
    select 1 from app.profiles where user_id=v_actor and role='admin'
  ) then
    raise exception 'pilot repair actor is not an admin';
  end if;

  for t in select * from pilot_targets order by lower(content_key) loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(t.content_key);

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc, created_at desc
    limit 1
    for update;

    if v_old.version_num <> t.source_version_num then
      raise exception '% source drift: expected v%, found v%',
        t.content_key, t.source_version_num, v_old.version_num;
    end if;

    if v_old.status <> 'changes_requested' then
      raise exception '% expected changes_requested, found %',
        t.content_key, v_old.status;
    end if;

    if not exists (
      select 1
      from app.content_review_decisions d
      where d.content_item_version_id=v_old.id
        and d.review_stage='tutor_question'
        and d.tutor_decision='approve_with_edits'
        and not exists (
          select 1 from app.content_review_decisions newer
          where newer.supersedes_id=d.content_review_decision_id
        )
    ) then
      raise exception '% has no active approve_with_edits finding',
        t.content_key;
    end if;

    update app.content_item_versions
       set status='retired'
     where id=v_old.id;

    update app.content_items
       set status='draft'
     where id=v_item.id;

    insert into app.content_item_versions (
      content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, help_text, content_hash, status, created_by,
      canonical_answer_1, canonical_answer_2, review_status,
      rubric_type, evaluator_strategy, stimulus_image_path
    ) values (
      v_item.id,
      v_old.version_num+1,
      v_old.stem,
      v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-07-27 cross-subject governed repair pilot',
        'repair_class',t.repair_class,
        'source_version_id',v_old.id
      ),
      v_old.explanation,
      v_old.help_text,
      v_old.content_hash,
      'draft',
      v_actor,
      v_old.canonical_answer_1,
      v_old.canonical_answer_2,
      null,
      v_old.rubric_type,
      v_old.evaluator_strategy,
      v_old.stimulus_image_path
    ) returning id into v_new_id;

    insert into app.mcq_choices (
      content_item_version_id, choice_key, choice_text, is_correct, rationale
    )
    select v_new_id, choice_key, choice_text, is_correct, rationale
    from app.mcq_choices
    where content_item_version_id=v_old.id;

    insert into app.frq_criteria (
      content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    )
    select v_new_id, criterion_key, learner_facing_text,
           points_possible, evidence_requirements, minimum_fix,
           accepted_variants
    from app.frq_criteria
    where content_item_version_id=v_old.id;

    insert into pilot_context values (
      t.content_key, v_item.id, v_old.id, v_new_id,
      v_old.version_num, v_old.version_num+1, t.repair_class
    );
  end loop;
end
$$;

-- -------------------------------------------------------------------------
-- Rubric-point restructuring
-- -------------------------------------------------------------------------

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('a-original',
   'Calculate the original cable tension.',
   1,
   'Uses torque equilibrium to obtain T=50.0 N for the 100 N beam.',
   'Set TL=W(L/2) and solve for the original tension.',
   '["50 N","50.0 N"]'::jsonb),
  ('a-prediction',
   'Predict how the cable tension changes when the beam weight doubles.',
   1,
   'States before or with the calculation that the cable tension doubles.',
   'State that unchanged geometry makes tension directly proportional to beam weight.',
   '["The tension increases by a factor of 2."]'::jsonb),
  ('a-doubled',
   'Calculate the cable tension after the beam weight doubles.',
   1,
   'Uses the 200 N weight to obtain T=100 N.',
   'Apply TL=W(L/2) using the doubled weight.',
   '["100 N","100.0 N"]'::jsonb),
  ('b-torque',
   'Explain the proportionality using torque equilibrium about the hinge.',
   1,
   'Identifies the cable lever arm L and beam-weight lever arm L/2, giving T=W/2.',
   'Write and interpret the two torques about the hinge.',
   '[]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apphy1-frq-013';

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy1-frq-013'
)
and criterion_key in ('part-a','part-b');

update app.frq_criteria
set learner_facing_text=
      'Identify a plotted relationship that would support constant fractional energy loss.',
    evidence_requirements=
      'Requires a graph such as ln(E_n) versus cycle number with an approximately straight-line trend. A constant ratio alone belongs to part (a) and does not satisfy this plotting requirement.',
    minimum_fix=
      'Name both plotted variables and the expected linear trend.'
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy1-frq-034'
)
and criterion_key='b-test';

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy2-frq-018'
)
and criterion_key='b-quality';

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('b-assumption',
   'Identify an important calorimetry assumption.',
   1,
   'Assumes negligible heat exchange with the cup and surroundings, or accounts for the cup heat capacity explicitly.',
   'State a consequential energy-balance assumption.',
   '["The cup absorbs negligible heat.","Heat exchange with the surroundings is negligible."]'::jsonb),
  ('b-uncertainty',
   'Describe one method for reducing measurement uncertainty.',
   1,
   'Repeated trials and averaging reduce random uncertainty; a lid and rapid transfer reduce unwanted heat exchange.',
   'Name a method and connect it to the uncertainty or heat-loss mechanism it reduces.',
   '["Repeat and average trials.","Use a lid.","Transfer the hot metal rapidly."]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apphy2-frq-018';

update app.frq_criteria
set learner_facing_text=
      'Identify two distinct controlled variables.',
    evidence_requirements=
      'Requires two valid controls. Examples include keeping wire material fixed and maintaining constant temperature by using a low measurement current.',
    minimum_fix=
      'Name two distinct controls, not two descriptions of the same control.'
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy2-frq-024'
)
and criterion_key='b-controls';

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy2-frq-028'
)
and criterion_key='b-properties';

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('b-real',
   'Classify the image as real or virtual.',
   1,
   'States that the image is real because the reflected rays actually converge.',
   'Use actual reflected-ray convergence to classify the image.',
   '[]'::jsonb),
  ('b-orientation',
   'State the image orientation.',
   1,
   'States that the image is inverted.',
   'Compare the image orientation with the object in the ray diagram.',
   '[]'::jsonb),
  ('b-size',
   'Compare the image size with the object.',
   1,
   'States that the image is enlarged.',
   'Use the ray diagram to compare image and object heights.',
   '["magnified"]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apphy2-frq-028';

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycem-frq-024'
)
and criterion_key='b-fields';

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('b-field',
   'Compare the surface electric fields.',
   1,
   'Uses E=kQ_i/R_i² to show that the radius-R sphere has twice the surface field of the radius-2R sphere.',
   'Calculate or compare both surface fields.',
   '[]'::jsonb),
  ('b-density',
   'Compare the surface charge densities.',
   1,
   'Uses sigma=Q_i/(4pi R_i²) to show that the radius-R sphere has twice the surface charge density.',
   'Calculate or compare both charge densities.',
   '[]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apphycem-frq-024';

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycm-frq-019'
)
and criterion_key='b-result';

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('b-angular-speed',
   'Derive the angular speed.',
   1,
   'Eliminates tension to obtain omega=sqrt(g/(L cos(theta))).',
   'Combine the vertical and radial equations and solve for angular speed.',
   '[]'::jsonb),
  ('b-period',
   'Derive the period.',
   1,
   'Uses period=2pi/omega to obtain 2pi sqrt(L cos(theta)/g).',
   'Convert the angular-speed result using period=2pi/omega.',
   '[]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apphycm-frq-019';

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycm-frq-028'
)
and criterion_key='b-result';

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('b-acceleration',
   'Derive the translational acceleration of the masses.',
   1,
   'Obtains a=(m1-m2)g/(m1+m2+I/R²).',
   'Eliminate both tensions using the two mass equations and pulley torque equation.',
   '[]'::jsonb),
  ('b-angular-acceleration',
   'Determine the pulley angular acceleration.',
   1,
   'Uses the no-slip condition to obtain alpha=a/R.',
   'Apply the no-slip relation after finding the translational acceleration.',
   '[]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apphycm-frq-028';

-- -------------------------------------------------------------------------
-- Assumption and convention repairs
-- -------------------------------------------------------------------------

update app.content_item_versions
set stimulus=
      'Two coherent sources that are initially in phase have wavelength 0.500 m and path difference 1.25 m at a detector.',
    stem=E'Answer all parts of the following question.\n\n(a) Predict how the interference type changes when the path difference is doubled, and justify the prediction quantitatively.\n\n(b) Explain why the initial path difference contains 2.5 wavelengths and the doubled path difference contains 5.0 wavelengths, and why the initially in-phase condition is required to classify the interference.',
    canonical_answer_1=
      'Initially, delta/lambda=1.25/0.500=2.5, so initially in-phase sources interfere destructively. Doubling the path difference to 2.50 m gives delta/lambda=5.0, so the interference becomes constructive.'
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy2-frq-013'
);

update app.frq_criteria
set learner_facing_text=case criterion_key
      when 'part-a' then
        'Show that doubling the path difference changes delta/lambda from 2.5 to 5.0 and predict a shift from destructive to constructive interference.'
      when 'part-b' then
        'Explain how an initially in-phase source condition and integer versus half-integer path differences determine the interference type.'
    end,
    evidence_requirements=case criterion_key
      when 'part-a' then
        'Initial ratio 1.25/0.500=2.5; doubled ratio 2.50/0.500=5.0; destructive changes to constructive.'
      when 'part-b' then
        'Coherence keeps phase difference fixed, while the explicitly stated initially in-phase condition makes half-integer path difference destructive and integer path difference constructive.'
    end,
    minimum_fix=case criterion_key
      when 'part-a' then
        'Calculate both ratios and state both interference types.'
      when 'part-b' then
        'Distinguish coherence from the initially in-phase condition.'
    end
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy2-frq-013'
);

update app.content_item_versions
set stem=replace(
      stem,
      'doubling the separation while keeping the charges at the midpoint',
      'doubling the separation and evaluating the field and potential at the new midpoint'
    ),
    canonical_answer_1=
      'Initially each charge is 0.200 m from the midpoint, so V=2kq/r=1.80x10^5 V and the net field is zero. After the separation doubles, each charge is 0.400 m from the new midpoint, so V=8.99x10^4 V while the net field remains zero.'
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy2-frq-016'
);

update app.frq_criteria
set learner_facing_text=replace(
      learner_facing_text,
      'doubling the separation while keeping the charges at the midpoint',
      'doubling the separation and evaluating the field and potential at the new midpoint'
    ),
    evidence_requirements=case criterion_key
      when 'part-a' then
        'Initial net potential is approximately 1.80x10^5 V; new net potential is approximately 8.99x10^4 V; the net field remains zero at both midpoints by symmetry.'
      else evidence_requirements
    end,
    minimum_fix=case criterion_key
      when 'part-a' then
        'Show both midpoint distances, both potentials, and the field cancellation.'
      else minimum_fix
    end
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy2-frq-016'
);

update app.content_item_versions
set stimulus=
      'On the x-axis the electric potential is V(x)=V0 e^(-x/L) for x>=0, where V0>0 and L>0 is a positive length scale.',
    canonical_answer_1=
      'Ex=-dV/dx=(V0/L)e^(-x/L), directed in +x. Because V depends only on x, Ey=Ez=0.'
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycem-frq-002'
);

update app.frq_criteria
set learner_facing_text=
      'Explain why the potential produces only an x-component of electric field.',
    evidence_requirements=
      'Uses E=-grad(V) and states that partial derivatives with respect to y and z are zero, so Ey=Ez=0.',
    minimum_fix=
      'State that V depends only on x and therefore the other field components vanish.'
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycem-frq-002'
)
and criterion_key='part-b';

update app.content_item_versions
set stem=E'Answer all parts of the following question.\n\nDefine positive current as flowing onto the capacitor plate that initially has charge +Q0.\n\n(a) Derive the governing differential equation, the charge q(t), and the signed current i(t).\n\n(b) Explain the meaning of the time constant and compare the energy dissipated in R with the initial capacitor energy.',
    canonical_answer_1=
      'With positive current defined onto the initially positive plate, q/C+R(dq/dt)=0, q=Q0 e^(-t/RC), and i=dq/dt=-(Q0/RC)e^(-t/RC). At t=RC, q=Q0/e. The total resistor heat is Q0^2/(2C).'
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycem-frq-029'
);

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycem-frq-029'
)
and criterion_key='a-solution';

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('a-derivation',
   'Derive the discharge differential equation.',
   1,
   'Uses q/C+R(dq/dt)=0 with the stated current convention.',
   'Apply the loop rule and i=dq/dt using the defined positive direction.',
   '[]'::jsonb),
  ('a-charge',
   'Determine charge as a function of time.',
   1,
   'Obtains q(t)=Q0 e^(-t/(RC)) from q(0)=Q0.',
   'Solve the first-order equation with the initial charge.',
   '[]'::jsonb),
  ('a-current',
   'Determine the signed current as a function of time.',
   1,
   'Obtains i(t)=-(Q0/RC)e^(-t/(RC)), consistent with positive current defined onto the initially positive plate.',
   'Differentiate q(t) and retain the sign required by the stated convention.',
   '[]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apphycem-frq-029';

update app.content_item_versions
set stimulus=
      'Two masses m1 and m2 are connected by a light spring and slide on a frictionless line. A constant external force F is applied only to mass m1.'
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycm-frq-021'
);

update app.content_item_versions
set stem=E'For m dv/dt=-bv with v(0)=v0, speed varies as\n\nA. v0+bt/m\nB. v0e^{-bt/m}\nC. v0bt/m\nD. v0/bt'
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycm-mcq-004'
);

update app.mcq_choices
set rationale=case choice_key
      when 'A' then
        'This predicts linear growth with time rather than the exponential decay required by dv/dt=-(b/m)v.'
      when 'D' then
        'This inverse-time expression does not satisfy the stated linear-drag differential equation or the initial condition.'
      else rationale
    end
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycm-mcq-004'
)
and choice_key in ('A','D');

-- -------------------------------------------------------------------------
-- Substantive rewrites and adjudication controls
-- -------------------------------------------------------------------------

update app.content_item_versions
set stimulus=E'Researchers sample fish from three zones of a lake and classify each fish by primary diet type. Construct a 100% segmented bar chart with one equal-width bar per zone. Each bar''s segment heights must show the within-zone proportions for the three diet types. Label the zones, diet types, and proportional scale. Then identify the zone with the largest number of piscivores.\n\n| Zone | Total sampled | Piscivore | Planktivore | Herbivore/Detritivore |\n| --- | --- | --- | --- | --- |\n| Surface | 50 | 10 | 30 | 10 |\n| Mid-water | 90 | 45 | 30 | 15 |\n| Bottom | 60 | 15 | 10 | 35 |',
    canonical_answer_1=
      'A correct 100% segmented bar chart uses equal-width bars and within-zone proportions: Surface 0.20/0.60/0.20; Mid-water 0.50/0.333/0.167; Bottom 0.25/0.167/0.583. Mid-water has the largest piscivore count (45).',
    prompt_json=prompt_json || jsonb_build_object(
      'stimulus',
      E'Researchers sample fish from three zones of a lake and classify each fish by primary diet type. Construct a 100% segmented bar chart with one equal-width bar per zone. Each bar''s segment heights must show the within-zone proportions for the three diet types. Label the zones, diet types, and proportional scale. Then identify the zone with the largest number of piscivores.\n\n| Zone | Total sampled | Piscivore | Planktivore | Herbivore/Detritivore |\n| --- | --- | --- | --- | --- |\n| Surface | 50 | 10 | 30 | 10 |\n| Mid-water | 90 | 45 | 30 | 15 |\n| Bottom | 60 | 15 | 10 | 35 |',
      'stimulus_table',
      jsonb_build_array(
        jsonb_build_object('Zone','Surface','Total sampled',50,'Piscivore',10,'Planktivore',30,'Herbivore/Detritivore',10),
        jsonb_build_object('Zone','Mid-water','Total sampled',90,'Piscivore',45,'Planktivore',30,'Herbivore/Detritivore',15),
        jsonb_build_object('Zone','Bottom','Total sampled',60,'Piscivore',15,'Planktivore',10,'Herbivore/Detritivore',35)
      ),
      'archetype','segmented_bar_chart_interpretation',
      'expected_graph_spec',jsonb_build_object(
        'x_axis','depth zone',
        'y_axis','within-zone diet-type proportion',
        'representation','100_percent_segmented_bar_chart'
      )
    )
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apbio-hdg-2026-graph-006'
);

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('PROPORTIONAL_SCALE',
   'Uses a consistent proportional scale from 0 to 1 or 0% to 100%.',
   1,
   'All three equal-width bars use the same proportional vertical scale.',
   'Add and consistently use a proportional vertical scale.',
   '[]'::jsonb),
  ('BAR_HEIGHTS_BY_CONDITIONAL_PROPORTION',
   'Uses correct within-zone proportions for every segment.',
   1,
   'Surface: 0.20/0.60/0.20; Mid-water: 0.50/0.333/0.167; Bottom: 0.25/0.167/0.583, allowing normal rounding.',
   'Divide each diet count by its zone total.',
   '[]'::jsonb),
  ('BAR_SEGMENT_LABELS',
   'Makes every zone and diet-type category identifiable.',
   1,
   'Labels bars by zone and identifies the three diet categories with direct labels or a clear legend.',
   'Label all bars and segment categories.',
   '[]'::jsonb),
  ('COUNT_REASONING',
   'Identifies Mid-water as the zone with the largest piscivore count.',
   1,
   'Uses the supplied counts to identify 45 Mid-water piscivores as the largest count.',
   'Compare piscivore counts, not only within-zone proportions.',
   '[]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apbio-hdg-2026-graph-006';

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apbio-hdg-2026-graph-006'
)
and criterion_key in (
  'AREA_OR_COUNT_REASONING',
  'HEIGHTS_BY_CONDITIONAL_PROPORTION',
  'SEGMENT_LABELS',
  'WIDTHS_BY_TOTAL'
);

update app.content_item_versions
set stem=
      'How does alternative splicing allow proteome complexity to exceed the number of genes in a genome?',
    stimulus=E'A single gene contains three groups of alternative exons. One exon is selected from each group when the pre-mRNA is spliced. The groups contain 2, 3, and 2 possible exons, respectively.',
    canonical_answer_1='B'
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apbio-mcq-069'
);

update app.mcq_choices
set choice_text=case choice_key
      when 'A' then
        'Each gene can produce only one protein, so proteome complexity cannot exceed gene count.'
      when 'B' then
        'Different exon combinations can produce 2 x 3 x 2 = 12 protein isoforms from the single gene.'
      when 'C' then
        'The cell must copy the gene to 12 chromosome locations before producing the proteins.'
      when 'D' then
        'All alternative exons are included together, producing the same protein in every cell.'
    end,
    rationale=case choice_key
      when 'A' then
        'Alternative splicing allows a single gene to produce multiple mRNA and protein isoforms.'
      when 'B' then
        'Selecting one exon independently from each group gives 2 x 3 x 2 = 12 combinations, illustrating how one gene can produce multiple proteins.'
      when 'C' then
        'The isoforms come from alternative processing of one gene, not from duplicating the gene across chromosomes.'
      when 'D' then
        'Alternative splicing selects among exons; including every alternative exon would not create the stated combinations.'
    end
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apbio-mcq-069'
);

update app.content_item_versions
set canonical_answer_1=
      'Use a motion sensor or video analysis to measure velocity or position at multiple elapsed times. Plot v versus t and compare with v=at, or plot displacement versus t^2 and compare with delta x=(1/2)at^2. Keep the track, cart, release condition, and surface conditions fixed. Constant acceleration with negligible friction and air resistance justifies the model.'
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy1-frq-009'
);

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('a-procedure',
   'Describe a feasible instrument and measurement procedure.',
   1,
   'Uses a motion sensor, video analysis, or photogates to measure position or velocity at multiple elapsed times.',
   'Name an instrument and collect measurements at more than one time.',
   '[]'::jsonb),
  ('a-variables',
   'Identify variables and a meaningful control.',
   1,
   'Elapsed time is independent; velocity or displacement is dependent; track angle, surface, cart, or release condition is controlled.',
   'Identify the independent and dependent variables and one model-relevant control.',
   '[]'::jsonb),
  ('a-comparison',
   'Compare the measurements with a constant-acceleration prediction.',
   1,
   'Tests linear v versus t with slope a, or linear displacement versus t² with slope a/2.',
   'State the plotted or calculated comparison that would support the model.',
   '[]'::jsonb),
  ('b-assumptions',
   'Explain why the kinematics model applies.',
   1,
   'Connects constant acceleration and negligible friction/air resistance to the use of the standard kinematics equations.',
   'State why acceleration remains approximately constant.',
   '[]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apphy1-frq-009';

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy1-frq-009'
)
and criterion_key in ('part-a','part-b');

update app.content_item_versions
set stem=E'Answer all parts of the following question.\n\n(a) Design an experiment that tests electric-field superposition along the line joining the charges. Measure the electric field from charge 1 alone, charge 2 alone, and both charges together at the same positions. Identify the independent variable, dependent variable, and one control.\n\n(b) Explain how Coulomb''s law determines each individual field contribution and how the superposition principle determines the combined field.',
    canonical_answer_1=
      'Move a vector electric-field probe through selected positions along the line. At each position, record E1 with only charge 1 present, E2 with only charge 2 present, and Eboth with both present. Compare Eboth with the vector sum E1+E2. Position is independent; measured electric-field vector is dependent; charge magnitudes, separation, probe orientation, and environment are controlled.'
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy2-frq-009'
);

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('a-procedure',
   'Measure individual and combined electric fields at matching positions.',
   1,
   'Records E1, E2, and Eboth with a vector field probe at the same selected positions.',
   'Measure each charge separately and both together at matching positions.',
   '[]'::jsonb),
  ('a-variables',
   'Identify variables and a valid control.',
   1,
   'Position is independent, measured electric-field vector is dependent, and charge magnitude, separation, probe orientation, or environment is controlled.',
   'Name the independent and dependent variables and one relevant control.',
   '[]'::jsonb),
  ('a-comparison',
   'State the comparison that tests superposition.',
   1,
   'Compares measured Eboth with the vector sum E1+E2, including direction.',
   'Use vector rather than scalar addition.',
   '[]'::jsonb),
  ('b-theory',
   'Distinguish Coulomb contributions from superposition.',
   1,
   'Coulomb''s law predicts each charge''s field; linear superposition combines the two vector contributions.',
   'State the role of both principles.',
   '[]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apphy2-frq-009';

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphy2-frq-009'
)
and criterion_key in ('part-a','part-b');

update app.content_item_versions
set stem=E'Answer all parts of the following question.\n\n(a) Design an experiment that tests the predicted dependence B proportional to 1/r for a long straight current-carrying wire at fixed current. Identify the independent variable, dependent variable, and important controls.\n\n(b) State the expected linearized graph and explain why Ampere''s law and cylindrical symmetry apply.',
    canonical_answer_1=
      'Hold current I fixed and use a calibrated magnetic-field probe to measure the tangential field at several radii r, far from wire ends. Plot B versus 1/r; a straight line through the origin with slope mu0 I/(2pi) supports B=mu0 I/(2pi r). Keep current, wire geometry, probe orientation, and axial position controlled.'
where id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycem-frq-011'
);

insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix, accepted_variants
)
select successor_version_id, x.*
from pilot_context,
lateral (values
  ('a-procedure',
   'Describe a feasible B-versus-r measurement procedure.',
   1,
   'Uses a magnetic-field probe at several measured radii while holding current fixed and measuring away from wire ends.',
   'Measure field at multiple radii with a fixed current.',
   '[]'::jsonb),
  ('a-controls',
   'Identify the variables and important controls.',
   1,
   'Radius is independent, tangential field is dependent, and current, wire geometry, probe orientation, and axial position are controlled.',
   'Identify the variables and at least two controls.',
   '[]'::jsonb),
  ('b-model',
   'State the linearized graph and justify the model.',
   1,
   'Plots B versus 1/r and expects slope mu0 I/(2pi); explains that a sufficiently long wire and measurements away from ends support cylindrical symmetry and Ampere''s-law evaluation.',
   'Give the axes, slope meaning, and symmetry/end-effect conditions.',
   '[]'::jsonb)
) as x(criterion_key,learner_facing_text,points_possible,
       evidence_requirements,minimum_fix,accepted_variants)
where lower(content_key)='apphycem-frq-011';

delete from app.frq_criteria
where content_item_version_id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apphycem-frq-011'
)
and criterion_key in ('part-a','part-b');

-- Keep the Chemistry and Statistics controls content-identical. Their
-- successor versions are draft and have no assignment because Production has
-- no second actively-qualified reviewer for either exam.

-- Reconcile prompt total points with the canonical criterion rows for every
-- repaired FRQ successor.
update app.content_item_versions civ
set prompt_json=coalesce(civ.prompt_json,'{}'::jsonb) ||
    jsonb_build_object(
      'total_points',
      (
        select coalesce(sum(points_possible),0)
        from app.frq_criteria r
        where r.content_item_version_id=civ.id
      )
    )
from pilot_context p
join app.content_items ci on ci.id=p.content_item_id
where civ.id=p.successor_version_id
  and ci.item_type='frq'
  and p.repair_class <> 'second_review_no_content_change';

-- Synchronize the AP Biology drawn-response prompt metadata to the canonical
-- criteria after the representation rewrite.
update app.content_item_versions civ
set prompt_json=jsonb_set(
      jsonb_set(
        civ.prompt_json,
        '{parts,0,points_possible}',
        '4'::jsonb,
        true
      ),
      '{criteria}',
      (
        select jsonb_agg(
          jsonb_build_object(
            'criterion_key',r.criterion_key,
            'points_possible',r.points_possible,
            'learner_facing_text',r.learner_facing_text
          )
          order by r.criterion_key
        )
        from app.frq_criteria r
        where r.content_item_version_id=civ.id
      ),
      true
    )
where civ.id=(
  select successor_version_id from pilot_context
  where lower(content_key)='apbio-hdg-2026-graph-006'
);

-- Recompute hashes from the final successor packages.
update app.content_item_versions civ
set content_hash=md5(
  coalesce(civ.stem,'') || E'\n' ||
  coalesce(civ.stimulus,'') || E'\n' ||
  coalesce(civ.canonical_answer_1,'') || E'\n' ||
  coalesce((
    select string_agg(
      c.choice_key || ':' || c.choice_text || ':' ||
      c.is_correct::text || ':' || coalesce(c.rationale,''),
      E'\n' order by c.choice_key
    )
    from app.mcq_choices c
    where c.content_item_version_id=civ.id
  ),'') || E'\n' ||
  coalesce((
    select string_agg(
      r.criterion_key || ':' || r.points_possible::text || ':' ||
      r.learner_facing_text || ':' ||
      coalesce(r.evidence_requirements,'') || ':' ||
      coalesce(r.minimum_fix,''),
      E'\n' order by r.criterion_key
    )
    from app.frq_criteria r
    where r.content_item_version_id=civ.id
  ),'')
)
from pilot_context p
where civ.id=p.successor_version_id;

-- -------------------------------------------------------------------------
-- Historical Chemistry FRQ label reconciliation
-- -------------------------------------------------------------------------

create temporary table chemistry_history_repair
on commit drop
as
select
  civ.id as content_item_version_id,
  ci.content_key,
  d.tutor_decision
from app.content_items ci
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.exam_packs ep on ep.id=epv.exam_pack_id
join app.content_item_versions civ on civ.content_item_id=ci.id
join app.content_review_decisions d
  on d.content_item_version_id=civ.id
where ep.exam_name='AP Chemistry'
  and ci.item_type='frq'
  and civ.status='reviewed_approved'
  and civ.review_status='tutor_review_pending'
  and d.review_stage='tutor_question'
  and d.tutor_decision in ('approve','approve_with_edits')
  and not exists (
    select 1 from app.content_review_decisions newer
    where newer.supersedes_id=d.content_review_decision_id
  )
  and exists (
    select 1 from app.content_item_versions successor
    where successor.content_item_id=ci.id
      and (
        successor.version_num>civ.version_num
        or (
          successor.version_num=civ.version_num
          and successor.created_at>civ.created_at
        )
      )
  );

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from chemistry_history_repair;
  if v_count <> 12 then
    raise exception
      'Chemistry label repair aborted: expected 12 historical versions, found %',
      v_count;
  end if;
end
$$;

update app.content_item_versions civ
set status='retired',
    review_status=case h.tutor_decision
      when 'approve' then 'question_review_approved'
      when 'approve_with_edits' then 'modification_reserved'
    end
from chemistry_history_repair h
where civ.id=h.content_item_version_id;

-- -------------------------------------------------------------------------
-- Verification
-- -------------------------------------------------------------------------

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from pilot_context p
  join app.content_item_versions civ on civ.id=p.successor_version_id
  join app.content_items ci on ci.id=p.content_item_id
  where civ.status='draft'
    and civ.review_status is null
    and ci.status='draft'
    and civ.version_num=p.successor_version_num;

  if v_count <> 21 then
    raise exception 'pilot verification failed: expected 21 draft successors, found %',
      v_count;
  end if;

  select count(*) into v_count
  from pilot_context p
  join app.content_item_versions old on old.id=p.source_version_id
  where old.status='retired';

  if v_count <> 21 then
    raise exception 'pilot verification failed: expected 21 retired sources, found %',
      v_count;
  end if;

  if exists (
    select 1
    from pilot_context p
    join app.content_items ci on ci.id=p.content_item_id
    join app.content_item_versions civ on civ.id=p.successor_version_id
    where ci.item_type='mcq'
      and (
        (select count(*) from app.mcq_choices c
         where c.content_item_version_id=civ.id and c.is_correct) <> 1
        or
        (select count(*) from app.mcq_choices c
         where c.content_item_version_id=civ.id) <>
        (select count(distinct lower(c.choice_text))
         from app.mcq_choices c
         where c.content_item_version_id=civ.id)
      )
  ) then
    raise exception 'pilot MCQ structural verification failed';
  end if;

  if exists (
    select 1
    from pilot_context p
    join app.content_items ci on ci.id=p.content_item_id
    join app.content_item_versions civ on civ.id=p.successor_version_id
    where ci.item_type='frq'
      and p.repair_class <> 'second_review_no_content_change'
      and (civ.prompt_json->>'total_points')::integer <>
          (
            select coalesce(sum(r.points_possible),0)
            from app.frq_criteria r
            where r.content_item_version_id=civ.id
          )
  ) then
    raise exception 'pilot FRQ point-total verification failed';
  end if;

  select count(*) into v_count
  from chemistry_history_repair h
  join app.content_item_versions civ on civ.id=h.content_item_version_id
  where civ.status='retired'
    and civ.review_status=case h.tutor_decision
      when 'approve' then 'question_review_approved'
      when 'approve_with_edits' then 'modification_reserved'
    end;

  if v_count <> 12 then
    raise exception
      'Chemistry label verification failed: expected 12 repaired versions, found %',
      v_count;
  end if;

  if exists (
    select 1
    from pilot_context p
    join app.content_review_decisions d
      on d.content_item_version_id=p.successor_version_id
  ) then
    raise exception 'pilot successors must not contain review decisions';
  end if;
end
$$;

commit;
