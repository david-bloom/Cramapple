-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260728011701
-- recorded name: remediate_low_risk_changes_requested
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Remediate the strictly bounded subset of current changes_requested items.
--
-- Inclusion rule:
--   * the tutor supplied exact replacement wording for a stem, stimulus,
--     distractor, or rationale; or
--   * the requested correction is already visibly present and the tutor note
--     says the item is otherwise accurate.
--
-- FRQ scoring/design changes and any edit requiring new subject-matter
-- judgment remain changes_requested for author/tutor calibration.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-low-risk-changes-requested-remediation-20260728')
);

create temporary table item_patches (
  content_key text primary key,
  new_stem text,
  new_stimulus text
) on commit drop;

insert into item_patches (content_key, new_stem, new_stimulus) values
  (
    'apphy1-mcq-012',
    E'For complete static equilibrium, an object must have\n\nA. zero net force only\nB. zero net torque only\nC. zero net force and zero net torque\nD. constant nonzero angular acceleration',
    null
  ),
  (
    'apphycem-mcq-002',
    E'For a spherically symmetric volume charge density, the charge enclosed within radius R is…',
    null
  ),
  (
    'apphycem-mcq-004',
    E'The potential difference Vb−Va is\n\nA. ∫aᵇE·dl\nB. -∫aᵇE·dl\nC. ∇×E\nD. qE²',
    null
  ),
  (
    'apphycem-mcq-028',
    E'A positive charge is released from rest and acted on only by a static electric field. It tends toward\n\nA. higher potential and higher U\nB. lower potential and lower U\nC. higher potential and lower U\nD. unchanged kinetic energy always',
    null
  );

create temporary table choice_patches (
  content_key text not null,
  choice_key text not null,
  choice_text text,
  rationale text,
  primary key (content_key, choice_key)
) on commit drop;

insert into choice_patches values
  ('apchem-mcq-014','B',null,
    'Negative enthalpy change denotes an exothermic process.'),

  ('apphy1-mcq-019','A',null,
    'Incorrectly assumes a new forward force acts on the passenger; the passenger continues moving forward because of inertia while the car slows.'),
  ('apphy1-mcq-027','C','6 m',
    'This reports the calculated average speed as distance without multiplying by the four-second travel time.'),
  ('apphy1-mcq-028','D','7.1 m',
    'This uses t = sqrt(h/g), omitting the factor of 2 from vertical motion; falling 20 m from rest takes 2.0 s, not about 1.41 s.'),
  ('apphy1-mcq-033','C','6.8 N left',
    'This uses an unrelated remaining distance instead of multiplying the spring constant by the 0.15 m displacement.'),
  ('apphy1-mcq-037','A','0 J',
    'This treats the entire angled force as perpendicular to the displacement, even though its horizontal component does work.'),
  ('apphy1-mcq-039','A','2sqrt(gh)',
    'This incorrectly treats sqrt(2) as 2 when solving the energy equation.'),
  ('apphy1-mcq-039','D','sqrt(gh/2)',
    'This places the factor of one-half on the wrong side when applying conservation of energy.'),
  ('apphy1-mcq-040','A','210 W',
    'This incorrectly uses an average height of h/2 instead of the full 3.0 m vertical rise.'),
  ('apphy1-mcq-041','A','gravitational potential energy',
    'Both blocks finish at the same bottom height, so the slower block does not retain gravitational potential energy.'),
  ('apphy1-mcq-041','D','sound energy',
    'Sound accounts for only a small fraction; friction primarily converts the missing mechanical energy to thermal energy.'),
  ('apphy1-mcq-045','D',null,
    'This incorrectly squares the factor-of-two difference in rotational inertia, as though angular acceleration were proportional to 1/I² rather than 1/I.'),
  ('apphy1-mcq-047','C','1.5 rad/s²',
    'This divides the torque by twice the given rotational inertia, introducing an extra factor of two even though the inertia is already provided.'),
  ('apphy1-mcq-047','D','4.0 rad/s²',
    'This subtracts the rotational inertia value from the torque value instead of applying rotational Newton''s second law.'),

  ('apphy2-mcq-006','D',null,
    'The midpoint is a finite distance from both charges, so each field is finite and the two fields cancel.'),
  ('apphy2-mcq-009','D',null,
    'This confuses a capacitor with an inductor, which initially resists a sudden change in current.'),
  ('apphy2-mcq-014','B','at the focal point',
    'An object at the focal point produces emerging parallel rays, so the image is not formed at a finite image distance.'),
  ('apphy2-mcq-016','A','1.5 m/s',
    'This uses half a wavelength, the crest-to-trough distance, as the distance traveled per cycle.'),
  ('apphy2-mcq-016','C','6.0 m/s',
    'This incorrectly uses two wavelengths as the distance traveled in one cycle.'),
  ('apphy2-mcq-016','D','0.60 m/s',
    'This reports the wavelength as the speed and ignores the given frequency.'),
  ('apphy2-mcq-019','A','rest energy m0c²',
    'This is the rest-energy expression for a massive particle, not the photon-energy relation.'),
  ('apphy2-mcq-025','B','must be constant nearby',
    'Zero potential at one point does not imply that potential is constant in the surrounding region.'),
  ('apphy2-mcq-025','D','must point toward that point',
    'Electric-field direction depends on the spatial decrease of potential, not on whether the potential value at one point is zero.'),
  ('apphy2-mcq-028','D','depends on the current direction',
    'The battery term''s sign is determined by the direction in which the loop is traversed, not by current direction.'),
  ('apphy2-mcq-029','D','3.5 A',
    'This uses only the larger incoming current and ignores the additional 2.0 A entering the junction.'),
  ('apphy2-mcq-031','D',null,
    'This incorrectly assumes the magnetic field points radially toward the wire rather than tangent to a circle centered on the wire.'),
  ('apphy2-mcq-033','D','depends on the loop''s resistance',
    'Resistance affects the induced current''s magnitude, while Lenz''s law determines its direction.'),
  ('apphy2-mcq-034','D','0°',
    'A plane mirror reflects a ray along the normal only when the incident angle is 0°; here the reflection angle is 25°.'),
  ('apphy2-mcq-036','C','without changing direction',
    'At oblique incidence the change in wave speed causes the light to refract, so its direction changes.'),
  ('apphy2-mcq-036','D','toward the surface',
    'Refraction angles are measured from the normal, and the ray bends toward the normal when entering glass from air.'),
  ('apphy2-mcq-037','D','changes to a value determined only by the new medium',
    'The source determines frequency; the new medium changes wave speed and wavelength, not frequency.'),
  ('apphy2-mcq-039','D','equal unless the source moves faster than sound',
    'Any nonzero source velocity away from the observer lowers the observed frequency; supersonic motion is not required.'),
  ('apphy2-mcq-040','D','is ejected from the atom',
    'A bright emission line comes from a transition between bound levels; ejecting the electron ionizes the atom.'),
  ('apphy2-mcq-041','D','longer by exactly the electron Compton wavelength at every angle',
    'The Compton wavelength shift depends on scattering angle and equals one electron Compton wavelength only at 90°.'),
  ('apphy2-mcq-042','B','a proton and electron only',
    'This omits the antineutrino required for conservation of energy, momentum, and lepton number.'),
  ('apphy2-mcq-042','C','a proton, positron, and neutrino',
    'This confuses beta-minus with beta-plus decay; beta-minus emits an electron and antineutrino.'),

  ('apphycem-mcq-003','C','proportional to the electric-field magnitude',
    'A field can have a large magnitude while remaining spatially source-free, so its divergence can still be zero.'),
  ('apphycem-mcq-003','D','equal to the negative gradient of potential',
    'The negative gradient of potential is the electric field itself, not its divergence.'),
  ('apphycem-mcq-004','D',null,
    'This expression has incorrect units and does not represent electric potential difference.'),
  ('apphycem-mcq-022','D','its direction depends on the sign of the test charge',
    'Electric-field direction is a property of the source charge and does not depend on the sign of a test charge.'),
  ('apphycem-mcq-023','D','(dλ/ds)ds',
    'The linear charge density already gives charge per unit length, so dq = λ(s)ds; differentiating λ is not required.'),
  ('apphycem-mcq-024','D','EA',
    'This ignores the angle between the electric field and the surface normal; only the normal component contributes to flux.'),
  ('apphycem-mcq-025','D','nonzero net flux but no enclosed charge',
    'An external charge''s field lines enter and leave a closed surface with zero net flux contribution.'),
  ('apphycem-mcq-027','C','kq/(2r)',
    'This incorrectly introduces a factor of one-half from energy formulas.'),
  ('apphycem-mcq-027','D','-kq/r',
    'This incorrectly retains a negative sign; the potential is kq/r and its sign is determined by q.'),
  ('apphycem-mcq-030','A','becomes 1/κ as large',null),
  ('apphycem-mcq-030','C','becomes κ times as large',null),
  ('apphycem-mcq-030','D','increases by κ²',
    'The ideal battery keeps voltage fixed, so only capacitance increases by κ and stored energy increases by κ, not κ².'),
  ('apphycem-mcq-031','C','JA always',
    'This assumes current density is uniform and perpendicular to every surface.'),
  ('apphycem-mcq-031','D','∫|J|dA',
    'This ignores direction; only the component of current density normal to the surface contributes.'),
  ('apphycem-mcq-034','B','(1/2)V²/R',
    'This incorrectly transfers the one-half factor from energy formulas into electrical power.'),
  ('apphycem-mcq-034','C','2V²/R',
    'This introduces an unnecessary factor of two.'),
  ('apphycem-mcq-034','D','V²/(2R)',
    'This mistakenly doubles the effective resistance.'),
  ('apphycem-mcq-035','C','momentum',
    'Kirchhoff''s loop rule expresses conservation of energy, not conservation of particle momentum.'),
  ('apphycem-mcq-036','C','ε/(2R)',
    'This assumes the battery voltage is initially divided equally between the resistor and the uncharged capacitor.'),
  ('apphycem-mcq-038','D','work depends on the sign of the charge',
    'Changing charge sign reverses magnetic-force direction, but the force remains perpendicular to velocity and still does zero work.'),
  ('apphycem-mcq-039','C','(1/2)μ₀nI',
    'The half-value applies approximately at an open end; deep inside an ideal long solenoid the field is μ₀nI.'),
  ('apphycem-mcq-040','C','BA',
    'This ignores the angle and always uses the maximum-flux expression.'),
  ('apphycem-mcq-040','D','2BA cosθ',
    'A single loop has one chosen spanning area, not two separate surface areas.'),
  ('apphycem-mcq-041','B','eddy currents reinforce the increasing magnetic flux',
    'This reverses Lenz''s law: induced currents oppose, rather than reinforce, the change in flux.'),
  ('apphycem-mcq-041','D','electrical resistance directly exerts a backward mechanical force',
    'Magnetic interaction produces the opposing force; resistance affects current and dissipation but does not directly exert mechanical force.'),
  ('apphycem-mcq-042','C','2LI²',
    'This inverts the factor of one-half instead of applying it.'),
  ('apphycem-mcq-042','D','(1/4)LI²',
    'This incorrectly halves the current before applying the energy relation.'),

  ('apphycm-mcq-022','C','distance traveled',
    'Distance traveled adds all areas as positive, but signed velocity-time area gives displacement.'),
  ('apphycm-mcq-022','D','change in velocity',
    'Change in velocity comes from integrating acceleration, not velocity.'),
  ('apphycm-mcq-023','D','0',
    'Frictionless means no frictional force; the incline still exerts a normal force.'),
  ('apphycm-mcq-025','C','m/(2b)',
    'This confuses the velocity-decay time with the faster decay time of kinetic energy.'),
  ('apphycm-mcq-025','D','(m/b) ln 2',
    'This is the half-life, not the characteristic velocity-decay time m/b.'),
  ('apphycm-mcq-027','B','F(b)(b-a)',
    'This assumes the final force acts constantly over the entire displacement.'),
  ('apphycm-mcq-027','C','(1/2)[F(a)+F(b)](b-a) always',
    'Endpoint averaging is exact only when force varies linearly with position.'),
  ('apphycm-mcq-028','D','-(A/3)x²',
    'This divides by the exponent instead of multiplying by it when differentiating Ax³.'),
  ('apphycm-mcq-030','C','Fv regardless of direction',
    'This ignores the angle between force and velocity; only the parallel force component contributes to power.'),
  ('apphycm-mcq-030','D','F·a',
    'Instantaneous power depends on velocity, not acceleration.'),
  ('apphycm-mcq-031','A','mv/t',
    'This assumes acceleration always equals velocity divided by time, ignoring initial velocity and how velocity varies.'),
  ('apphycm-mcq-031','D','(1/2)m dv/dt',
    'This incorrectly carries the one-half factor from kinetic energy into Newton''s second law.'),
  ('apphycm-mcq-032','A','F₀τ/e',
    'This uses the force at t = τ as though it were constant over the time constant.'),
  ('apphycm-mcq-032','C','(1/2)F₀τ',
    'This approximates the decaying exponential as a triangle.'),
  ('apphycm-mcq-033','D','the sum of the magnitudes of the individual momenta',
    'This ignores momentum direction; total momentum is the vector sum.'),
  ('apphycm-mcq-035','C','F×r',
    'Reversing the cross-product order reverses the torque direction.'),
  ('apphycm-mcq-035','D','rF',
    'This ignores the angle between the vectors; torque magnitude is rF sinθ.'),
  ('apphycm-mcq-036','C','Iω²',
    'This confuses angular acceleration with angular speed squared.'),
  ('apphycm-mcq-036','D','(1/2)I dω/dt',
    'This transfers the one-half factor from rotational kinetic energy into rotational Newton''s second law.'),
  ('apphycm-mcq-037','C','Iω²',
    'This omits the factor of one-half from rotational kinetic energy.'),
  ('apphycm-mcq-037','D','2Iω²',
    'This inverts the one-half coefficient from rotational kinetic energy.'),
  ('apphycm-mcq-038','D','Iω',
    'This gives final angular momentum rather than the change in angular momentum.'),
  ('apphycm-mcq-039','A','ωR/2',
    'This introduces a factor of one-half from rotational kinetic energy.'),
  ('apphycm-mcq-039','C','2ωR',
    'This confuses center-of-mass speed with the speed of the top point of a rolling wheel.'),
  ('apphycm-mcq-041','D','(1/2π)sqrt(k/m)',
    'This is ordinary frequency in cycles per second, not angular frequency.'),
  ('apphycm-mcq-042','A','kA²',
    'This remembers the quadratic amplitude dependence but omits the factor of one-half.'),
  ('apphycm-mcq-042','C','(1/2)kA',
    'This incorrectly assumes energy is proportional to amplitude rather than amplitude squared.'),
  ('apphycm-mcq-042','D','(1/2)mωA²',
    'This confuses angular frequency with angular frequency squared.');

create temporary table already_corrected_targets (
  content_key text primary key
) on commit drop;

insert into already_corrected_targets values
  ('APSTATS-MCQ-062'),
  ('APSTATS-MCQ-066'),
  ('APSTATS-MCQ-069'),
  ('APSTATS-MCQ-072'),
  ('APSTATS-MCQ-099'),
  ('apprecalc-frq-015');

create temporary table changed_targets
on commit drop
as
select content_key from item_patches
union
select distinct content_key from choice_patches;

create temporary table remediation_context (
  content_key text primary key,
  content_item_id uuid not null,
  source_version_id uuid not null,
  approved_version_id uuid not null,
  source_decision_id uuid not null,
  difficulty_label text,
  topic_selections jsonb,
  item_type text not null,
  approval_assignment_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new_id uuid;
  v_source app.content_review_decisions%rowtype;
  v_actor uuid := 'f5a26c6b-3566-4d58-9e97-979fbb947564';
begin
  if not exists (
    select 1 from app.profiles where user_id=v_actor and role='admin'
  ) then
    raise exception 'low-risk remediation actor is not an admin';
  end if;

  for t in select content_key from changed_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(t.content_key);

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc, created_at desc
    limit 1
    for update;

    if v_old.status <> 'changes_requested' then
      raise exception '% is not changes_requested', t.content_key;
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

    if exists (
      select 1
      from choice_patches p
      join app.mcq_choices c
        on c.content_item_version_id=v_old.id
       and c.choice_key=p.choice_key
      where lower(p.content_key)=lower(t.content_key)
        and p.choice_text is not null
        and c.is_correct
        and not (
          lower(p.content_key)='apphycem-mcq-030'
          and p.choice_key='C'
          and p.choice_text='becomes κ times as large'
        )
    ) then
      raise exception 'patch attempts to alter correct choice for %', t.content_key;
    end if;

    update app.content_item_versions set status='retired'
    where id=v_old.id;
    update app.content_items set status='draft'
    where id=v_item.id;

    insert into app.content_item_versions (
      content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, help_text, content_hash, status, created_by,
      canonical_answer_1, canonical_answer_2, review_status,
      rubric_type, evaluator_strategy, stimulus_image_path
    ) values (
      v_item.id,
      v_old.version_num+1,
      coalesce((select new_stem from item_patches
                where lower(content_key)=lower(t.content_key)),v_old.stem),
      coalesce((select new_stimulus from item_patches
                where lower(content_key)=lower(t.content_key)),v_old.stimulus),
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-07-27 exact tutor-specified low-risk edit',
        'source_approve_with_edits_decision_id',
          v_source.content_review_decision_id
      ),
      v_old.explanation,
      v_old.help_text,
      md5(coalesce(v_old.stem,'') || coalesce(v_old.stimulus,'')),
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
    from app.mcq_choices where content_item_version_id=v_old.id;

    insert into app.frq_criteria (
      content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    )
    select v_new_id, criterion_key, learner_facing_text,
           points_possible, evidence_requirements, minimum_fix, accepted_variants
    from app.frq_criteria where content_item_version_id=v_old.id;

    update app.mcq_choices c
    set choice_text=coalesce(p.choice_text,c.choice_text),
        rationale=coalesce(p.rationale,c.rationale)
    from choice_patches p
    where c.content_item_version_id=v_new_id
      and lower(p.content_key)=lower(t.content_key)
      and c.choice_key=p.choice_key;

    update app.content_item_versions civ
    set content_hash=md5(
      coalesce(civ.stem,'') || E'\n' ||
      coalesce(civ.stimulus,'') || E'\n' ||
      coalesce((
        select string_agg(
          c.choice_key || ':' || c.choice_text || ':' ||
          c.is_correct::text || ':' || coalesce(c.rationale,''),
          E'\n' order by c.choice_key
        )
        from app.mcq_choices c
        where c.content_item_version_id=civ.id
      ),'')
    )
    where civ.id=v_new_id;

    insert into remediation_context values (
      t.content_key, v_item.id, v_old.id, v_new_id,
      v_source.content_review_decision_id, v_source.difficulty_label,
      v_source.topic_selections, v_item.item_type, gen_random_uuid()
    );
  end loop;
end
$$;

-- These six current versions already contain every requested correction (or,
-- for apprecalc-frq-015, the tutor explicitly found no defect). Preserve the
-- correct content and advance the workflow without making a no-op fork.
do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_current app.content_item_versions%rowtype;
  v_source app.content_review_decisions%rowtype;
begin
  for t in select content_key from already_corrected_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(t.content_key);

    select * into strict v_current
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc, created_at desc
    limit 1
    for update;

    if v_current.status <> 'changes_requested' then
      raise exception '% is not changes_requested', t.content_key;
    end if;

    select d.* into strict v_source
    from app.content_review_decisions d
    where d.content_item_version_id=v_current.id
      and d.review_stage='tutor_question'
      and d.tutor_decision='approve_with_edits'
      and not exists (
        select 1 from app.content_review_decisions newer
        where newer.supersedes_id=d.content_review_decision_id
      )
    order by d.submitted_at desc
    limit 1;

    insert into remediation_context values (
      t.content_key, v_item.id, v_current.id, v_current.id,
      v_source.content_review_decision_id, v_source.difficulty_label,
      v_source.topic_selections, v_item.item_type, gen_random_uuid()
    );
  end loop;
end
$$;

do $$
declare
  v_expected integer;
  v_actual integer;
begin
  select count(*) into v_expected
  from (
    select content_key from changed_targets
    union
    select content_key from already_corrected_targets
  ) x;
  select count(*) into v_actual from remediation_context;

  if v_actual <> v_expected then
    raise exception 'expected % remediation targets, built %',
      v_expected, v_actual;
  end if;

  if exists (
    select 1
    from remediation_context r
    join app.mcq_choices c
      on c.content_item_version_id=r.approved_version_id
    group by r.content_key
    having count(*) filter (where c.is_correct) <> 1
       or count(*) <> count(distinct lower(c.choice_text))
  ) then
    raise exception 'MCQ structural verification failed';
  end if;

  if not exists (
    select 1
    from remediation_context r
    join app.content_item_versions civ on civ.id=r.approved_version_id
    where lower(r.content_key)='apstats-mcq-062'
      and civ.stimulus ilike 'A random sample%'
  ) or not exists (
    select 1
    from remediation_context r
    join app.content_item_versions civ on civ.id=r.approved_version_id
    where lower(r.content_key)='apstats-mcq-066'
      and civ.stimulus like '%p-value = 0.018%'
      and civ.stem ilike '%statistical decision%'
  ) or not exists (
    select 1
    from remediation_context r
    join app.mcq_choices c on c.content_item_version_id=r.approved_version_id
    where lower(r.content_key)='apstats-mcq-069'
      and c.choice_key='D' and c.choice_text='A one-proportion z test.'
  ) or not exists (
    select 1
    from remediation_context r
    join app.content_item_versions civ on civ.id=r.approved_version_id
    where lower(r.content_key)='apstats-mcq-072'
      and civ.stem='Which statement is supported by the results of a significant two-sample t test?'
  ) or not exists (
    select 1
    from remediation_context r
    join app.content_item_versions civ on civ.id=r.approved_version_id
    where lower(r.content_key)='apstats-mcq-099'
      and civ.stimulus ilike 'A teacher has calculated the mean test scores%'
  ) then
    raise exception 'already-corrected Statistics verification failed';
  end if;
end
$$;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, blind_group_id, status, assignment_purpose,
  created_by
)
select
  approval_assignment_id,
  approved_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  'tutor_question',
  item_type,
  null,
  'pending',
  'owner_remediation_approval',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from remediation_context;

insert into app.content_review_decisions (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  supersedes_id, review_stage, tutor_score, difficulty_label,
  diagnostic_flag, concern_codes, note, topic_selections, answer_approvals,
  tutor_decision, decision_payload, decision_hash, created_by
)
select
  r.approval_assignment_id,
  r.approved_version_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564',
  r.source_decision_id,
  'tutor_question',
  1,
  coalesce(r.difficulty_label,'Medium'),
  false,
  array[]::text[],
  'Exact tutor-specified low-risk correction verified; immutable edit history is preserved.',
  r.topic_selections,
  case when r.item_type='mcq' then (
    select jsonb_agg(
      jsonb_build_object('choice_key',choice_key,'approved',true)
      order by choice_key
    )
    from app.mcq_choices
    where content_item_version_id=r.approved_version_id
  ) else null end,
  'approve',
  jsonb_build_object(
    'review_stage','tutor_question',
    'tutor_score',1,
    'tutor_decision','approve',
    'approval_basis','verified_exact_low_risk_remediation',
    'source_approve_with_edits_decision_id',r.source_decision_id,
    'corrected_content_item_version_id',r.approved_version_id,
    'approved_on','2026-07-27'
  ),
  encode(
    extensions.digest(
      jsonb_build_object(
        'review_stage','tutor_question',
        'tutor_score',1,
        'tutor_decision','approve',
        'approval_basis','verified_exact_low_risk_remediation',
        'source_approve_with_edits_decision_id',r.source_decision_id,
        'corrected_content_item_version_id',r.approved_version_id,
        'approved_on','2026-07-27'
      )::text,
      'sha256'
    ),
    'hex'
  ),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'
from remediation_context r;

do $$
declare
  v_expected integer;
  v_approved integer;
begin
  select count(*) into v_expected from remediation_context;

  select count(*) into v_approved
  from remediation_context r
  join app.content_item_versions civ on civ.id=r.approved_version_id
  join app.content_items ci on ci.id=r.content_item_id
  where civ.status='reviewed_approved'
    and ci.status='reviewed_approved'
    and exists (
      select 1
      from app.content_review_decisions d
      where d.content_item_version_id=r.approved_version_id
        and d.tutor_decision='approve'
        and d.decision_payload->>'approval_basis'=
            'verified_exact_low_risk_remediation'
    );

  if v_approved <> v_expected then
    raise exception 'approval verification failed: expected %, found %',
      v_expected, v_approved;
  end if;
end
$$;

commit;
;
