-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260728024242
-- recorded name: publish_ai_qa_pilot_and_run_second_packet
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Product Owner policy: one qualified human review plus documented AI QA is
-- sufficient for testing and Production. A second human review remains a
-- follow-up rather than a blocking release gate.
--
-- This migration:
--   1. records AI-QA approval and publishes the repaired first 21-item packet;
--   2. creates, repairs, AI-QA validates, approves, and publishes a second
--      cross-subject packet of 20 items.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-ai-qa-release-and-second-packet-20260728')
);

create temporary table release_context (
  content_key text primary key,
  content_item_id uuid not null,
  release_version_id uuid not null,
  source_decision_id uuid not null,
  item_type text not null,
  difficulty_label text,
  topic_selections jsonb,
  packet text not null,
  approval_assignment_id uuid not null
) on commit drop;

-- First packet: latest draft successors created by the governed repair pilot.
insert into release_context
select
  ci.content_key,
  ci.id,
  civ.id,
  d.content_review_decision_id,
  ci.item_type,
  d.difficulty_label,
  d.topic_selections,
  'cross_subject_repair_packet_1',
  gen_random_uuid()
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
join app.content_item_versions source
  on source.id=(civ.prompt_json->>'source_version_id')::uuid
join lateral (
  select d.*
  from app.content_review_decisions d
  where d.content_item_version_id=source.id
    and d.review_stage='tutor_question'
    and d.tutor_decision='approve_with_edits'
    and not exists (
      select 1 from app.content_review_decisions newer
      where newer.supersedes_id=d.content_review_decision_id
    )
  order by d.submitted_at desc
  limit 1
) d on true
where civ.prompt_json->>'qa_remediation'=
      '2026-07-27 cross-subject governed repair pilot'
  and civ.status in ('draft','assigned')
  and not exists (
    select 1
    from app.content_item_versions newer
    where newer.content_item_id=ci.id
      and (
        newer.version_num>civ.version_num
        or (
          newer.version_num=civ.version_num
          and newer.created_at>civ.created_at
        )
      )
  );

do $$
declare
  v_count integer;
begin
  select count(*) into v_count
  from release_context
  where packet='cross_subject_repair_packet_1';
  if v_count <> 21 then
    raise exception 'expected 21 first-packet drafts, found %', v_count;
  end if;
end
$$;

create temporary table second_targets (
  content_key text primary key,
  source_version_num integer not null,
  repair_class text not null
) on commit drop;

insert into second_targets values
  ('apphy1-frq-002',1,'rubric_point_restructuring'),
  ('apphy1-frq-003',1,'rubric_point_restructuring'),
  ('apphy1-frq-004',1,'rubric_point_restructuring'),
  ('apphy2-frq-017',1,'rubric_point_restructuring'),
  ('apphy2-frq-033',1,'rubric_point_restructuring'),
  ('apphycem-frq-019',1,'rubric_point_restructuring'),
  ('apphycm-frq-023',1,'rubric_point_restructuring'),
  ('apphy1-frq-028',1,'assumption_or_convention'),
  ('apphy2-frq-026',1,'assumption_or_convention'),
  ('apphy2-frq-027',1,'assumption_or_convention'),
  ('apphycem-frq-003',1,'assumption_or_convention'),
  ('apphycem-frq-007',1,'assumption_or_convention'),
  ('apphycm-frq-002',1,'assumption_or_convention'),
  ('apphycm-frq-006',1,'assumption_or_convention'),
  ('APBIO-MCQ-074',1,'substantive_rewrite'),
  ('apchem-sfrq-005',2,'substantive_rewrite'),
  ('apphy1-frq-014',1,'substantive_rewrite'),
  ('apphy2-frq-030',1,'substantive_rewrite'),
  ('apphycem-frq-030',1,'substantive_rewrite'),
  ('apphycm-frq-014',1,'substantive_rewrite');

create temporary table second_context (
  content_key text primary key,
  content_item_id uuid not null,
  source_version_id uuid not null,
  successor_version_id uuid not null,
  source_decision_id uuid not null,
  item_type text not null,
  difficulty_label text,
  topic_selections jsonb,
  repair_class text not null
) on commit drop;

do $$
declare
  t second_targets%rowtype;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_source app.content_review_decisions%rowtype;
  v_new_id uuid;
  v_actor uuid := 'f5a26c6b-3566-4d58-9e97-979fbb947564';
begin
  for t in select * from second_targets order by lower(content_key) loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(t.content_key);

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc,created_at desc
    limit 1
    for update;

    if v_old.version_num<>t.source_version_num
       or v_old.status<>'changes_requested' then
      raise exception '% source drift: expected v% changes_requested, found v% %',
        t.content_key,t.source_version_num,v_old.version_num,v_old.status;
    end if;

    select d.* into strict v_source
    from app.content_review_decisions d
    where d.content_item_version_id=v_old.id
      and d.review_stage='tutor_question'
      and d.tutor_decision='approve_with_edits'
      and not exists (
        select 1 from app.content_review_decisions newer
        where newer.supersedes_id=d.content_review_decision_id
      )
    order by d.submitted_at desc
    limit 1;

    update app.content_item_versions set status='retired' where id=v_old.id;
    update app.content_items set status='draft' where id=v_item.id;

    insert into app.content_item_versions (
      content_item_id,version_num,stem,stimulus,prompt_json,explanation,
      help_text,content_hash,status,created_by,canonical_answer_1,
      canonical_answer_2,review_status,rubric_type,evaluator_strategy,
      stimulus_image_path
    ) values (
      v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb)||jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-07-27 cross-subject governed repair packet 2',
        'repair_class',t.repair_class,
        'source_version_id',v_old.id
      ),
      v_old.explanation,v_old.help_text,v_old.content_hash,'draft',v_actor,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    ) returning id into v_new_id;

    insert into app.mcq_choices (
      content_item_version_id,choice_key,choice_text,is_correct,rationale
    )
    select v_new_id,choice_key,choice_text,is_correct,rationale
    from app.mcq_choices where content_item_version_id=v_old.id;

    insert into app.frq_criteria (
      content_item_version_id,criterion_key,learner_facing_text,
      points_possible,evidence_requirements,minimum_fix,accepted_variants
    )
    select v_new_id,criterion_key,learner_facing_text,points_possible,
           evidence_requirements,minimum_fix,accepted_variants
    from app.frq_criteria where content_item_version_id=v_old.id;

    insert into second_context values (
      t.content_key,v_item.id,v_old.id,v_new_id,
      v_source.content_review_decision_id,v_item.item_type,
      v_source.difficulty_label,v_source.topic_selections,t.repair_class
    );
  end loop;
end
$$;

-- Rubric restructures.
update app.frq_criteria
set learner_facing_text=
      'Subtract the opposing friction force, identify the net-force direction, and use Newton''s second law to calculate acceleration.',
    evidence_requirements=
      'F_net=15.0-6.00=9.00 N in the pull direction; a=F_net/m=3.00 m/s².',
    minimum_fix=
      'Show the signed force subtraction and divide the resulting net force by mass.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy1-frq-002'
)
and criterion_key='part-a';

update app.frq_criteria
set evidence_requirements=
      'Newton''s second law applies; no other horizontal forces act; kinetic friction remains 6.00 N while the block slides.',
    minimum_fix=
      'State both the force-law principle and the constant-friction/no-other-horizontal-force assumptions.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy1-frq-002'
)
and criterion_key='part-b';

update app.frq_criteria
set learner_facing_text=
      'Equate initial kinetic energy with spring potential energy and solve for maximum compression.',
    evidence_requirements=
      '(1/2)mv²=(1/2)kx², so x=v sqrt(m/k)=0.200 m.',
    minimum_fix=
      'Show the energy equality before giving the numerical compression.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy1-frq-003'
)
and criterion_key='part-a';

update app.content_item_versions
set canonical_answer_1=
      'Momentum conservation gives v_f=(2.00x3.00)/(3.00)=2.00 m/s. K_i=9.00 J and K_f=6.00 J, so delta K=-3.00 J. Negligible external horizontal impulse conserves momentum; sticking makes the collision perfectly inelastic and converts kinetic energy to deformation, sound, and internal energy.'
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy1-frq-004'
);

update app.frq_criteria
set learner_facing_text=
      'Derive the common velocity and calculate the numerical kinetic-energy change.',
    evidence_requirements=
      'v_f=2.00 m/s; K_i=9.00 J; K_f=6.00 J; delta K=-3.00 J.',
    minimum_fix=
      'Show both momentum and kinetic-energy calculations.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy1-frq-004'
)
and criterion_key='part-a';

update app.frq_criteria
set evidence_requirements=
      'Net external horizontal impulse is negligible, so momentum is conserved. Sticking establishes a perfectly inelastic collision and some kinetic energy becomes deformation, sound, and internal energy.',
    minimum_fix=
      'Connect momentum conservation to external impulse and energy loss to the inelastic collision.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy1-frq-004'
)
and criterion_key='part-b';

insert into app.frq_criteria (
  content_item_version_id,criterion_key,learner_facing_text,
  points_possible,evidence_requirements,minimum_fix,accepted_variants
)
select successor_version_id,'a-justification',
  'Justify the rms-speed comparison using its temperature dependence.',1,
  'For the same gas, v_rms is proportional to sqrt(T); sqrt(4)=2.',
  'State the square-root relationship and apply it to the factor of four.',
  '[]'::jsonb
from second_context where lower(content_key)='apphy2-frq-017';

update app.frq_criteria
set learner_facing_text=
      'Report the released energy with appropriate significant figures.',
    evidence_requirements=
      'The unrounded value 0.897 J is acceptable as work; the reported result is approximately 0.90 J to match the two significant figures of 0.80 MeV.',
    minimum_fix=
      'Round the final energy to 0.90 J while allowing 0.897 J as an intermediate.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy2-frq-033'
)
and criterion_key in (
  select criterion_key from app.frq_criteria
  where content_item_version_id=(
    select successor_version_id from second_context
    where lower(content_key)='apphy2-frq-033'
  )
  and (
    learner_facing_text ilike '%energy%'
    or evidence_requirements ilike '%0.897%'
  )
);

insert into app.frq_criteria (
  content_item_version_id,criterion_key,learner_facing_text,
  points_possible,evidence_requirements,minimum_fix,accepted_variants
)
select successor_version_id,'a-gauss-comparison',
  'Compare each calculated net flux with enclosed charge divided by epsilon0.',1,
  'For each surface, compares the converged signed flux sum with Q_enclosed/epsilon0 while holding enclosed charge fixed when changing size or shape.',
  'State the quantitative Gauss-law comparison, not only the flux calculation.',
  '[]'::jsonb
from second_context where lower(content_key)='apphycem-frq-019';

insert into app.frq_criteria (
  content_item_version_id,criterion_key,learner_facing_text,
  points_possible,evidence_requirements,minimum_fix,accepted_variants
)
select successor_version_id,'b-explanation',
  'Explain the acceleration and resistance contributions to power.',1,
  'Identifies 2ma²t³ as the rate of increase of kinetic energy and fat² as power delivered against resistance.',
  'Interpret both terms in the derived power expression.',
  '[]'::jsonb
from second_context where lower(content_key)='apphycm-frq-023';

-- Assumption and convention repairs.
update app.content_item_versions
set stimulus=
      'An ideal spring exerts the signed restoring force F=-kx about equilibrium.'
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy1-frq-028'
);

update app.content_item_versions
set stem=replace(
      stem,
      'determine the magnetic field',
      'determine the magnetic-field magnitude'
    )
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy2-frq-026'
);

update app.content_item_versions
set stem=replace(
      stem,
      'explain the voltage signs',
      'explain why the entering and leaving voltage pulses have opposite signs'
    )
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy2-frq-027'
);

update app.content_item_versions
set stem=replace(
      stem,
      'derive the stated observable',
      'derive the energy stored in the capacitor'
    )
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycem-frq-003'
);

update app.content_item_versions
set stem=replace(
      stem,
      'applied to this charge distribution',
      'for an interior Gaussian surface of radius r<R applied to this charge distribution'
    )
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycem-frq-007'
);

update app.frq_criteria
set learner_facing_text=
      'Draw and label the charged sphere and an interior Gaussian sphere of radius r<R.',
    evidence_requirements=
      'Shows the physical sphere of radius R, Gaussian sphere of radius r<R, radial field direction, and enclosed-charge integral.',
    minimum_fix=
      'Label R, r, the Gaussian surface, and the radial electric field.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycem-frq-007'
)
and criterion_key='part-a';

update app.content_item_versions
set stimulus=
      'A mass m starts at x(0)=0 with speed v0 and moves through a medium with drag force F=-bv.'
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycm-frq-002'
);

update app.frq_criteria
set evidence_requirements=
      'Solves m dv/dt=-bv with v(0)=v0 and integrates using x(0)=0 to obtain v(t)=v0e^(-bt/m) and x(t)=(mv0/b)(1-e^(-bt/m)).',
    minimum_fix=
      'Use both stated initial conditions.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycm-frq-002'
)
and criterion_key='part-a';

update app.content_item_versions
set stimulus=
      'A thin rod of length L and mass M has linear density lambda(x)=2Mx/L² measured from the end x=0. Determine moment of inertia about an axis through x=0 perpendicular to the rod.'
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycm-frq-006'
);

update app.frq_criteria
set learner_facing_text=
      'Draw a mass-element diagram for the rod and the perpendicular axis through x=0.',
    evidence_requirements=
      'Shows the rod from 0 to L, the axis at x=0, an element dx at position x, dm=lambda(x)dx, and increasing density with x.',
    minimum_fix=
      'Label the axis, x, dx, and dm=lambda(x)dx.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycm-frq-006'
)
and criterion_key='part-a';

-- Substantive rewrites.
update app.content_item_versions
set stem=
      'Why can changing the guide RNA redirect CRISPR-Cas9 to a different DNA sequence without changing the Cas9 protein?',
    stimulus=
      'CRISPR-Cas9 uses a Cas9 protein that cuts DNA and a guide RNA with a sequence that can base-pair with a complementary DNA target.',
    canonical_answer_1='B'
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apbio-mcq-074'
);

update app.mcq_choices
set choice_text=case choice_key
      when 'A' then
        'The guide RNA changes the amino acid sequence of Cas9.'
      when 'B' then
        'The guide RNA base-pairs with complementary DNA and brings Cas9 to that target.'
      when 'C' then
        'The guide RNA is copied into DNA and permanently inserted beside the target.'
      when 'D' then
        'The guide RNA causes Cas9 to cut every DNA sequence in the cell.'
    end,
    rationale=case choice_key
      when 'A' then
        'The guide RNA directs Cas9 but does not change the protein''s amino acid sequence.'
      when 'B' then
        'Complementary base pairing between guide RNA and target DNA supplies sequence specificity while Cas9 performs the cut.'
      when 'C' then
        'Guide RNA functions directly as RNA and is not inserted into the target DNA.'
      when 'D' then
        'Cas9 is directed to DNA that matches the guide RNA rather than cutting every sequence.'
    end
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apbio-mcq-074'
);

update app.content_item_versions
set canonical_answer_1=
      'Approach the endpoint dropwise with mixing; overshoot makes the calculated analyte amount too large. At equivalence, use the balanced chemical equation to convert moles of titrant to moles of analyte by the stoichiometric ratio. Recording to 0.01 mL reduces relative uncertainty. Percent difference is about 0.27%, indicating good precision.'
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apchem-sfrq-005'
);

update app.frq_criteria
set learner_facing_text=
      'Use the balanced-equation stoichiometric ratio to relate titrant moles to analyte moles at equivalence.',
    evidence_requirements=
      'Moles of titrant are stoichiometrically equivalent to moles of analyte according to the coefficients in the balanced reaction; equality is only for a 1:1 reaction.',
    minimum_fix=
      'State that the balanced equation, not a universal one-to-one rule, determines the mole conversion.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apchem-sfrq-005'
)
and criterion_key='part-b';

update app.content_item_versions
set stem=E'Answer all parts of the following question.\n\n(a) Predict how the cylinder''s speed at the bottom changes when the drop height doubles, and justify the prediction quantitatively.\n\n(b) Starting from conservation of mechanical energy, derive the bottom speed using I=(1/2)MR² and the rolling condition v=omega R. State the dissipative assumptions required for the derivation.'
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy1-frq-014'
);

update app.frq_criteria
set learner_facing_text=
      'Derive the speed from translational and rotational kinetic energy.',
    evidence_requirements=
      'Uses Mgh=(1/2)Mv²+(1/2)Iomega², I=(1/2)MR², and v=omega R to obtain v=sqrt(4gh/3). States that static friction does no net work for ideal rolling on a fixed surface and that rolling resistance and other dissipative effects are negligible.',
    minimum_fix=
      'Show the energy derivation and state the required no-dissipation assumptions.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy1-frq-014'
)
and criterion_key='part-b';

update app.content_item_versions
set stimulus=
      'In an idealized one-dimensional model, a 680 Hz siren moves at 25 m/s directly along a line through a stationary observer in still air where sound speed is 340 m/s. Compare the limiting frequencies immediately before and immediately after the source passes the observer.',
    stem=E'Answer all parts of the following question.\n\n(a) Calculate the observed frequency immediately before the source reaches the observer.\n\n(b) Calculate the observed frequency immediately after it passes.\n\n(c) Explain why the idealized one-dimensional model gives a discontinuous limiting change, while a real path with nonzero closest distance would produce a continuous frequency change.'
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy2-frq-030'
);

update app.frq_criteria
set criterion_key='b-frequency',
    learner_facing_text='Calculate the receding frequency immediately after passage.',
    evidence_requirements='Uses f''=fv/(v+v_s) to obtain approximately 633 Hz.',
    minimum_fix='Use the receding-source denominator and evaluate it.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphy2-frq-030'
)
and criterion_key='b-after';

insert into app.frq_criteria (
  content_item_version_id,criterion_key,learner_facing_text,
  points_possible,evidence_requirements,minimum_fix,accepted_variants
)
select successor_version_id,'c-geometry',
  'Explain the idealized discontinuity and realistic continuous change.',1,
  'In the one-dimensional limit the radial velocity switches from +25 m/s toward to 25 m/s away at passage. For a nonzero closest distance, radial velocity passes continuously through zero.',
  'Contrast the radial-velocity behavior in the two geometries.',
  '[]'::jsonb
from second_context where lower(content_key)='apphy2-frq-030';

update app.content_item_versions
set stem=E'Answer all parts of the following question.\n\n(a) Derive the selected speed for undeflected ions.\n\n(b) Derive the circular radius in the second region and an expression for mass-to-charge ratio.\n\n(c) Explain how E/B1 selects speed rather than ion species, and explain how increasing B2 changes all trajectory radii and the absolute spatial separation between ions with different m/q.'
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycem-frq-030'
);

update app.frq_criteria
set learner_facing_text=
      'Explain that the crossed fields select speed, not ion species.',
    evidence_requirements=
      'E/B1 sets the transmitted speed independent of mass and charge magnitude; different species can pass if they have that speed.',
    minimum_fix=
      'Do not claim E or B1 directly selects a species.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycem-frq-030'
)
and criterion_key='c-selector';

update app.frq_criteria
set evidence_requirements=
      'At fixed selected speed, increasing B2 reduces every radius as 1/B2 and therefore reduces absolute spatial separation for the same geometry.',
    minimum_fix=
      'State both the radius and separation effects.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycem-frq-030'
)
and criterion_key='c-analyzer';

update app.content_item_versions
set stimulus=
      'In an idealized comparison, a family of physical pendulums has the same mass M and the same moment of inertia I about the pivot, but different pivot-to-center distances d.',
    stem=E'Answer all parts of the following question.\n\n(a) Predict how the small-angle period changes when d doubles while M and I remain fixed.\n\n(b) Starting from the small-angle torque equation, derive T=2pi sqrt(I/(Mgd)) and identify why holding I fixed makes this an idealized comparison rather than moving the pivot on one unchanged rigid body.'
where id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycm-frq-014'
);

update app.frq_criteria
set learner_facing_text=
      'Derive the period and explain the idealized fixed-I comparison.',
    evidence_requirements=
      'Linearizes I theta''''=-Mgd sin(theta) to obtain T=2pi sqrt(I/(Mgd)); explains that moving a pivot on one rigid body would normally change I.',
    minimum_fix=
      'Show the small-angle derivation and identify the fixed-I idealization.'
where content_item_version_id=(
  select successor_version_id from second_context
  where lower(content_key)='apphycm-frq-014'
)
and criterion_key='part-b';

-- Normalize totals/hashes and add second packet to release context.
update app.content_item_versions civ
set prompt_json=coalesce(civ.prompt_json,'{}'::jsonb)||
    jsonb_build_object(
      'total_points',
      (select coalesce(sum(points_possible),0)
       from app.frq_criteria r
       where r.content_item_version_id=civ.id)
    )
from second_context s
where civ.id=s.successor_version_id
  and s.item_type='frq';

update app.content_item_versions civ
set content_hash=md5(
  coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce(civ.canonical_answer_1,'')||E'\n'||
  coalesce((select string_agg(
    c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||
    coalesce(c.rationale,''),E'\n' order by c.choice_key)
    from app.mcq_choices c where c.content_item_version_id=civ.id),'')||E'\n'||
  coalesce((select string_agg(
    r.criterion_key||':'||r.points_possible::text||':'||
    r.learner_facing_text||':'||coalesce(r.evidence_requirements,'')||':'||
    coalesce(r.minimum_fix,''),E'\n' order by r.criterion_key)
    from app.frq_criteria r where r.content_item_version_id=civ.id),'')
)
from second_context s
where civ.id=s.successor_version_id;

insert into release_context
select
  s.content_key,s.content_item_id,s.successor_version_id,
  s.source_decision_id,s.item_type,s.difficulty_label,s.topic_selections,
  'cross_subject_repair_packet_2',gen_random_uuid()
from second_context s;

-- AI-QA approval records under the Product Owner's single-review release rule.
insert into app.content_review_assignments (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,review_kind,blind_group_id,status,assignment_purpose,created_by
)
select
  approval_assignment_id,release_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question',item_type,null,'pending','owner_remediation_approval',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from release_context;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,answer_approvals,tutor_decision,
  decision_payload,decision_hash,created_by
)
select
  r.approval_assignment_id,r.release_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  r.source_decision_id,'tutor_question',1,
  coalesce(r.difficulty_label,'Medium'),false,array[]::text[],
  'Qualified single-review finding addressed and AI QA passed under Product Owner testing/Production policy; second human review remains follow-up.',
  r.topic_selections,
  case when r.item_type='mcq' then (
    select jsonb_agg(
      jsonb_build_object('choice_key',choice_key,'approved',true)
      order by choice_key
    )
    from app.mcq_choices
    where content_item_version_id=r.release_version_id
  ) else null end,
  'approve',
  jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','single_qualified_review_plus_ai_qa',
    'packet',r.packet,
    'source_human_review_decision_id',r.source_decision_id,
    'second_human_review_status','follow_up_pending',
    'policy_confirmed_on','2026-07-27'
  ),
  encode(extensions.digest(jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','single_qualified_review_plus_ai_qa',
    'packet',r.packet,
    'source_human_review_decision_id',r.source_decision_id,
    'second_human_review_status','follow_up_pending',
    'policy_confirmed_on','2026-07-27'
  )::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from release_context r;

-- Publish only after the approval trigger has moved each successor to
-- reviewed_approved.
update app.content_item_versions civ
set status='published',
    approved_at=coalesce(approved_at,now()),
    approved_by=coalesce(
      approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'
    ),
    published_at=now(),
    review_status='question_review_approved'
from release_context r
where civ.id=r.release_version_id
  and civ.status='reviewed_approved';

update app.content_items ci
set status='published'
from release_context r
where ci.id=r.content_item_id
  and exists (
    select 1 from app.content_item_versions civ
    where civ.id=r.release_version_id and civ.status='published'
  );

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from release_context;
  if v_count<>41 then
    raise exception 'expected 41 released questions, found %',v_count;
  end if;

  select count(*) into v_count
  from release_context r
  join app.content_item_versions civ on civ.id=r.release_version_id
  join app.content_items ci on ci.id=r.content_item_id
  where civ.status='published'
    and civ.review_status='question_review_approved'
    and civ.published_at is not null
    and ci.status='published'
    and exists (
      select 1 from app.content_review_decisions d
      where d.content_item_version_id=r.release_version_id
        and d.decision_payload->>'approval_basis'=
            'single_qualified_review_plus_ai_qa'
    );

  if v_count<>41 then
    raise exception 'release verification failed: expected 41, found %',v_count;
  end if;

  if exists (
    select 1
    from second_context s
    join app.content_items ci on ci.id=s.content_item_id
    join app.content_item_versions civ on civ.id=s.successor_version_id
    where ci.item_type='mcq'
      and (
        (select count(*) from app.mcq_choices c
         where c.content_item_version_id=civ.id)<>4
        or
        (select count(*) from app.mcq_choices c
         where c.content_item_version_id=civ.id and c.is_correct)<>1
        or
        (select count(*) from app.mcq_choices c
         where c.content_item_version_id=civ.id)<>
        (select count(distinct lower(choice_text)) from app.mcq_choices c
         where c.content_item_version_id=civ.id)
      )
  ) then
    raise exception 'second-packet MCQ validation failed';
  end if;

  if exists (
    select 1
    from second_context s
    join app.content_items ci on ci.id=s.content_item_id
    join app.content_item_versions civ on civ.id=s.successor_version_id
    where ci.item_type='frq'
      and (civ.prompt_json->>'total_points')::integer<>
          (select coalesce(sum(points_possible),0)
           from app.frq_criteria f
           where f.content_item_version_id=civ.id)
  ) then
    raise exception 'second-packet FRQ point validation failed';
  end if;
end
$$;

commit;
;
