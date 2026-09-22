begin;

-- Add AP Physics C: Electricity and Magnetism Unit 12 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 4 AP Physics C:E&M Unit 12 topics and 0 published
-- point briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_C_EM_CED_FACT_PACK.md Unit 12 (Magnetic
-- Fields and Electromagnetism). The fact pack confirms Gauss's law for
-- magnetism, magnetic force on moving charges F_B = q(v x B), Biot-Savart law
-- and its limited quantitative geometries, force on current-carrying wires,
-- Ampere's law, long-straight-wire and solenoid derived fields, current-density
-- enclosed-current reasoning, the qualitative-only displacement-current term,
-- and documented 2025/2026 scoring patterns around wire-force versus charge-
-- force law confusion and Ampere's-law substitution errors.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_c_em', 12, '12.1', 'Magnetic Fields',
    'very-important', 'very-important',
    'Magnetic fields are vector fields with no isolated magnetic monopoles. Gauss''s law for magnetism states that net magnetic flux through a closed surface is zero.',
    'This topic sets the field model for the rest of magnetism: field lines form loops, dipoles align with external fields, and magnetic sources cannot be treated like isolated electric charges.',
    'You earn points by representing magnetic-field direction, using closed-loop field-line reasoning, and explaining why a closed surface has zero net magnetic flux.',
    'Start with the field map: magnetic field lines loop, so any flux entering a closed surface must also leave it.',
    'Treating a magnetic north pole like an isolated electric charge source with field lines beginning there and ending nowhere.',
    '/learn/ap-physics-c-em/unit-12/magnetic-fields'
  ),
  (
    'ap_physics_c_em', 12, '12.2', 'Magnetism and Moving Charges',
    'very-important', 'very-important',
    'A moving charge in a magnetic field experiences force F_B = q(v x B). The force is perpendicular to both velocity and magnetic field and reverses for negative charge.',
    'Cross-product direction is the whole game here. It determines curvature, force signs, and how magnetic forces combine with independent electric forces in mixed-field regions.',
    'You earn points by applying the right-hand rule with charge sign, using the vector cross product or qvB sin(theta), and not confusing point-charge force with wire-force formulas.',
    'Use v cross B for a positive charge, then reverse the result if q is negative; only after direction is set should you compute magnitude.',
    'Using the current-carrying-wire force integral for a moving point charge.',
    '/learn/ap-physics-c-em/unit-12/magnetism-and-moving-charges'
  ),
  (
    'ap_physics_c_em', 12, '12.3', 'Magnetic Fields of Current-Carrying Wires and the Biot-Savart Law',
    'very-important', 'very-important',
    'The Biot-Savart law builds magnetic field from current elements: dB is proportional to I dl x rhat over r^2. Quantitative AP use is limited to specified symmetric conductor geometries.',
    'Biot-Savart is the calculus source of magnetic fields from currents. It explains why geometry, distance, and direction of each current element matter before any shortcut field formula appears.',
    'You earn points by defining dl and rhat, using the cross product direction, respecting the allowed geometries, and integrating or citing derived results only when symmetry permits.',
    'Draw the current element and point of interest, mark rhat from the element to the point, then apply dl x rhat before setting up the integral.',
    'Using B = mu0 I/(2 pi r) for every current geometry instead of checking whether the long-straight-wire symmetry applies.',
    '/learn/ap-physics-c-em/unit-12/magnetic-fields-of-current-carrying-wires-and-the-biot-savart-law'
  ),
  (
    'ap_physics_c_em', 12, '12.4', 'Ampere''s Law',
    'very-important', 'very-important',
    'Ampere''s law relates circulation of magnetic field around a closed loop to enclosed current: integral B dot dl = mu0 I_enc. It is powerful when symmetry makes B constant on the loop.',
    'This is the magnetism analogue of symmetry-based field solving. Long wires, long solenoids, slabs, and cylindrical conductors with current density are in scope when the Amperian loop matches the field symmetry.',
    'You earn points by choosing an Amperian loop that matches symmetry, evaluating B dot dl along the loop, and calculating enclosed current correctly, including from current density when needed.',
    'Pick the loop after identifying symmetry; then compute I_enc for the current actually passing through the loop surface before solving for B.',
    'Substituting total current when only part of a distributed current is enclosed by the Amperian loop.',
    '/learn/ap-physics-c-em/unit-12/amperes-law'
  )
),
explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  (
    'ap_physics_c_em', 12, '12.1', 'Magnetic Fields',
    'Magnetic fields do not start and stop on isolated magnetic charges. Field lines form closed loops, and Gauss''s law for magnetism captures that with zero net magnetic flux through any closed surface.',
    'Students need to distinguish magnetic-field sources from electric-field sources. Electric flux can reveal enclosed charge; magnetic flux through a closed surface does not reveal an enclosed monopole because isolated magnetic poles are not part of the model. Dipoles and aligned material domains still create magnetic fields, but the field-line topology is loop-like.',
    'Points come from drawing magnetic field lines consistently, explaining compass or dipole alignment from the local field, and using integral B dot dA = 0 for a closed surface rather than inventing a magnetic charge term.',
    'Start with the field map: magnetic field lines loop, so any flux entering a closed surface must also leave it.',
    'A closed Gaussian surface surrounds the north end of a bar magnet. What is the net magnetic flux through that closed surface?',
    'The net flux is positive because field lines leave the north pole.',
    'The net magnetic flux through the closed surface is zero. Magnetic field lines form closed loops, so any field lines leaving the surface also enter it somewhere else. Gauss''s law for magnetism has no enclosed magnetic-monopole term.',
    'Treating a magnetic north pole like an isolated electric charge source with field lines beginning there and ending nowhere.',
    'Back in practice, compare electric and magnetic Gauss-law reasoning deliberately. Magnetic closed-surface flux is zero even when a magnet passes through the surface.'
  ),
  (
    'ap_physics_c_em', 12, '12.2', 'Magnetism and Moving Charges',
    'Magnetic force on a moving point charge is a cross-product force: F_B = q(v x B). Its direction is perpendicular to the plane of v and B for positive charge and reversed for negative charge.',
    'Students need to separate three similar-looking magnetic relationships. A point charge uses q(v x B). A current-carrying wire uses an integral over I dl x B. A current element making a field uses Biot-Savart. The 2025 scoring notes identify mixing the wire-force law into a point-charge situation as a real error pattern.',
    'Points come from choosing the point-charge law, applying the right-hand rule, reversing for negative q, and combining magnetic and electric forces as vector forces when both fields are present.',
    'Use v cross B for a positive charge, then reverse the result if q is negative; only after direction is set should you compute magnitude.',
    'A positively charged sphere moves upward through a uniform magnetic field to the right. Which magnetic-force law should be used?',
    'Use the wire formula integral I dl cross B because the moving charge is like current.',
    'Use the point-charge law F_B = q(v x B). The object is a moving charged particle or sphere, not a current-carrying wire segment. The force direction comes from upward cross rightward, and the magnitude can be written qvB when velocity is perpendicular to B.',
    'Using the current-carrying-wire force integral for a moving point charge.',
    'In practice, identify the magnetic actor first: point charge, current element making a field, or current-carrying wire feeling a force. The formula follows from that choice.'
  ),
  (
    'ap_physics_c_em', 12, '12.3', 'Magnetic Fields of Current-Carrying Wires and the Biot-Savart Law',
    'Biot-Savart turns each current element into a small contribution to magnetic field. The direction comes from dl x rhat, and the magnitude depends on current, distance squared, and geometry before integration.',
    'Students need to treat Biot-Savart as a geometry setup, not a memorized shortcut. AP Physics C:E&M limits quantitative Biot-Savart work to specific conductor cases such as points on the perpendicular bisector of a straight conductor, points on the central axis of a circular loop, or centers of circular-arc segments.',
    'Points are earned by defining the source element, pointing rhat from source element to field point, using the cross-product direction, and reducing the integral using symmetry only when the geometry supports it. A correct derived field can earn credit even when vector notation is not fully written, but the geometry must be right.',
    'Draw the current element and point of interest, mark rhat from the element to the point, then apply dl x rhat before setting up the integral.',
    'A point is at the center of a circular loop carrying current counterclockwise as viewed from above. What direction is the magnetic field at the center?',
    'The field points radially outward from the loop because the current goes around the circle.',
    'Use the right-hand rule around the loop: curl fingers with the counterclockwise current as viewed from above, and the thumb points upward. The magnetic field at the center is along the loop axis, not radially outward in the plane of the loop.',
    'Using B = mu0 I/(2 pi r) for every current geometry instead of checking whether the long-straight-wire symmetry applies.',
    'Back in practice, label the geometry before writing a field formula. Long straight wire, circular loop, and arc center are different Biot-Savart setups.'
  ),
  (
    'ap_physics_c_em', 12, '12.4', 'Ampere''s Law',
    'Ampere''s law is useful when symmetry makes the line integral simple. The loop choice must match the magnetic-field symmetry, and I_enc means the current piercing the chosen loop surface, not automatically the total current in the physical object.',
    'Students need to combine symmetry and enclosed-current reasoning. Long straight wires and long solenoids lead to familiar derived fields, but conductive slabs or cylindrical conductors with current density require integrating J over the area actually enclosed. The displacement-current term is conceptual here; quantitative use of a changing electric field is outside the expected scope.',
    'Points come from choosing a valid Amperian loop, evaluating integral B dot dl from the field behavior on that loop, and computing I_enc correctly. The fact pack flags real scoring errors from double-counting enclosed current and using the wrong loop circumference.',
    'Pick the loop after identifying symmetry; then compute I_enc for the current actually passing through the loop surface before solving for B.',
    'Inside a long cylindrical conductor with current density that varies with radius, a circular Amperian loop of radius r is drawn inside the conductor. What current belongs in Ampere''s law?',
    'Use the total current in the whole conductor because the wire carries that current.',
    'Use only the current enclosed by the loop: I_enc = integral J dot dA over the circular area of radius r. If J varies with radius, that enclosed current must be integrated over the area inside the loop. The total current is used only for loops outside the full conductor.',
    'Substituting total current when only part of a distributed current is enclosed by the Amperian loop.',
    'In practice, shade the area pierced by the Amperian loop before writing I_enc. That visual check catches most current-density mistakes.'
  )
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance,
  exam_importance, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss, learn_more_path, practice_subject_key,
  practice_unit_number, practice_topic_code, status, source_note, published_at
)
select
  subject_key, unit_number, topic_code, title, class_importance,
  exam_importance, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss, learn_more_path, subject_key,
  unit_number, topic_code, 'published',
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:E&M Unit 12 Magnetic Fields and Electromagnetism; grounded in AP_PHYSICS_C_EM_CED_FACT_PACK.md Unit 12: Gauss law for magnetism, F_B=q(v x B), Biot-Savart law and limited quantitative geometries, force on current-carrying wires, Ampere law, long-wire and solenoid derived fields, enclosed current from current density, qualitative-only displacement-current term, and documented scoring risks around point-charge versus wire-force formulas and Ampere-law substitution errors; batch 2026-08-25-ap-physics-c-em-unit12-topic-guides; author=reviewer same session, no independent human review yet',
  now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
  title = excluded.title,
  class_importance = excluded.class_importance,
  exam_importance = excluded.exam_importance,
  what_it_is = excluded.what_it_is,
  why_it_matters = excluded.why_it_matters,
  how_points_are_earned = excluded.how_points_are_earned,
  answer_move = excluded.answer_move,
  common_point_loss = excluded.common_point_loss,
  learn_more_path = excluded.learn_more_path,
  practice_subject_key = excluded.practice_subject_key,
  practice_unit_number = excluded.practice_unit_number,
  practice_topic_code = excluded.practice_topic_code,
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_point_briefs.published_at, excluded.published_at);

with explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  (
    'ap_physics_c_em', 12, '12.1', 'Magnetic Fields',
    'Magnetic fields do not start and stop on isolated magnetic charges. Field lines form closed loops, and Gauss''s law for magnetism captures that with zero net magnetic flux through any closed surface.',
    'Students need to distinguish magnetic-field sources from electric-field sources. Electric flux can reveal enclosed charge; magnetic flux through a closed surface does not reveal an enclosed monopole because isolated magnetic poles are not part of the model. Dipoles and aligned material domains still create magnetic fields, but the field-line topology is loop-like.',
    'Points come from drawing magnetic field lines consistently, explaining compass or dipole alignment from the local field, and using integral B dot dA = 0 for a closed surface rather than inventing a magnetic charge term.',
    'Start with the field map: magnetic field lines loop, so any flux entering a closed surface must also leave it.',
    'A closed Gaussian surface surrounds the north end of a bar magnet. What is the net magnetic flux through that closed surface?',
    'The net flux is positive because field lines leave the north pole.',
    'The net magnetic flux through the closed surface is zero. Magnetic field lines form closed loops, so any field lines leaving the surface also enter it somewhere else. Gauss''s law for magnetism has no enclosed magnetic-monopole term.',
    'Treating a magnetic north pole like an isolated electric charge source with field lines beginning there and ending nowhere.',
    'Back in practice, compare electric and magnetic Gauss-law reasoning deliberately. Magnetic closed-surface flux is zero even when a magnet passes through the surface.'
  ),
  (
    'ap_physics_c_em', 12, '12.2', 'Magnetism and Moving Charges',
    'Magnetic force on a moving point charge is a cross-product force: F_B = q(v x B). Its direction is perpendicular to the plane of v and B for positive charge and reversed for negative charge.',
    'Students need to separate three similar-looking magnetic relationships. A point charge uses q(v x B). A current-carrying wire uses an integral over I dl x B. A current element making a field uses Biot-Savart. The 2025 scoring notes identify mixing the wire-force law into a point-charge situation as a real error pattern.',
    'Points come from choosing the point-charge law, applying the right-hand rule, reversing for negative q, and combining magnetic and electric forces as vector forces when both fields are present.',
    'Use v cross B for a positive charge, then reverse the result if q is negative; only after direction is set should you compute magnitude.',
    'A positively charged sphere moves upward through a uniform magnetic field to the right. Which magnetic-force law should be used?',
    'Use the wire formula integral I dl cross B because the moving charge is like current.',
    'Use the point-charge law F_B = q(v x B). The object is a moving charged particle or sphere, not a current-carrying wire segment. The force direction comes from upward cross rightward, and the magnitude can be written qvB when velocity is perpendicular to B.',
    'Using the current-carrying-wire force integral for a moving point charge.',
    'In practice, identify the magnetic actor first: point charge, current element making a field, or current-carrying wire feeling a force. The formula follows from that choice.'
  ),
  (
    'ap_physics_c_em', 12, '12.3', 'Magnetic Fields of Current-Carrying Wires and the Biot-Savart Law',
    'Biot-Savart turns each current element into a small contribution to magnetic field. The direction comes from dl x rhat, and the magnitude depends on current, distance squared, and geometry before integration.',
    'Students need to treat Biot-Savart as a geometry setup, not a memorized shortcut. AP Physics C:E&M limits quantitative Biot-Savart work to specific conductor cases such as points on the perpendicular bisector of a straight conductor, points on the central axis of a circular loop, or centers of circular-arc segments.',
    'Points are earned by defining the source element, pointing rhat from source element to field point, using the cross-product direction, and reducing the integral using symmetry only when the geometry supports it. A correct derived field can earn credit even when vector notation is not fully written, but the geometry must be right.',
    'Draw the current element and point of interest, mark rhat from the element to the point, then apply dl x rhat before setting up the integral.',
    'A point is at the center of a circular loop carrying current counterclockwise as viewed from above. What direction is the magnetic field at the center?',
    'The field points radially outward from the loop because the current goes around the circle.',
    'Use the right-hand rule around the loop: curl fingers with the counterclockwise current as viewed from above, and the thumb points upward. The magnetic field at the center is along the loop axis, not radially outward in the plane of the loop.',
    'Using B = mu0 I/(2 pi r) for every current geometry instead of checking whether the long-straight-wire symmetry applies.',
    'Back in practice, label the geometry before writing a field formula. Long straight wire, circular loop, and arc center are different Biot-Savart setups.'
  ),
  (
    'ap_physics_c_em', 12, '12.4', 'Ampere''s Law',
    'Ampere''s law is useful when symmetry makes the line integral simple. The loop choice must match the magnetic-field symmetry, and I_enc means the current piercing the chosen loop surface, not automatically the total current in the physical object.',
    'Students need to combine symmetry and enclosed-current reasoning. Long straight wires and long solenoids lead to familiar derived fields, but conductive slabs or cylindrical conductors with current density require integrating J over the area actually enclosed. The displacement-current term is conceptual here; quantitative use of a changing electric field is outside the expected scope.',
    'Points come from choosing a valid Amperian loop, evaluating integral B dot dl from the field behavior on that loop, and computing I_enc correctly. The fact pack flags real scoring errors from double-counting enclosed current and using the wrong loop circumference.',
    'Pick the loop after identifying symmetry; then compute I_enc for the current actually passing through the loop surface before solving for B.',
    'Inside a long cylindrical conductor with current density that varies with radius, a circular Amperian loop of radius r is drawn inside the conductor. What current belongs in Ampere''s law?',
    'Use the total current in the whole conductor because the wire carries that current.',
    'Use only the current enclosed by the loop: I_enc = integral J dot dA over the circular area of radius r. If J varies with radius, that enclosed current must be integrated over the area inside the loop. The total current is used only for loops outside the full conductor.',
    'Substituting total current when only part of a distributed current is enclosed by the Amperian loop.',
    'In practice, shade the area pierced by the Amperian loop before writing I_enc. That visual check catches most current-density mistakes.'
  )
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, status, source_note, published_at
)
select
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, 'published',
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:E&M Unit 12 Magnetic Fields and Electromagnetism; grounded in AP_PHYSICS_C_EM_CED_FACT_PACK.md Unit 12: Gauss law for magnetism, F_B=q(v x B), Biot-Savart law and limited quantitative geometries, force on current-carrying wires, Ampere law, long-wire and solenoid derived fields, enclosed current from current density, qualitative-only displacement-current term, and documented scoring risks around point-charge versus wire-force formulas and Ampere-law substitution errors; batch 2026-08-25-ap-physics-c-em-unit12-topic-guides; author=reviewer same session, no independent human review yet',
  now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
  title = excluded.title,
  core_idea = excluded.core_idea,
  what_students_need_to_understand = excluded.what_students_need_to_understand,
  how_this_becomes_points = excluded.how_this_becomes_points,
  answer_move = excluded.answer_move,
  mini_example_question = excluded.mini_example_question,
  weak_answer = excluded.weak_answer,
  point_attaining_answer = excluded.point_attaining_answer,
  common_point_loss = excluded.common_point_loss,
  practice_bridge = excluded.practice_bridge,
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_explainers.published_at, excluded.published_at);

do $$
declare
  v_briefs integer;
  v_explainers integer;
  v_pairing_orphans integer;
  v_unit_mismatches integer;
  v_route_mismatches integer;
  v_core_matches integer;
  v_duplicate_explainer_fields integer;
begin
  select count(*) into v_briefs
  from app.topic_point_briefs
  where subject_key = 'ap_physics_c_em'
    and unit_number = 12
    and topic_code in ('12.1', '12.2', '12.3', '12.4')
    and status = 'published';

  if v_briefs <> 4 then
    raise exception 'expected 4 published AP Physics C:E&M Unit 12 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_c_em'
    and unit_number = 12
    and topic_code in ('12.1', '12.2', '12.3', '12.4')
    and status = 'published';

  if v_explainers <> 4 then
    raise exception 'expected 4 published AP Physics C:E&M Unit 12 explainers, got %', v_explainers;
  end if;

  select count(*) into v_pairing_orphans
  from (
    select b.subject_key, b.topic_code
    from app.topic_point_briefs b
    left join app.topic_explainers e
      on e.subject_key = b.subject_key
     and e.topic_code = b.topic_code
     and e.status = 'published'
    where b.subject_key = 'ap_physics_c_em'
      and b.unit_number = 12
      and b.topic_code in ('12.1', '12.2', '12.3', '12.4')
      and b.status = 'published'
      and e.topic_code is null
    union all
    select e.subject_key, e.topic_code
    from app.topic_explainers e
    left join app.topic_point_briefs b
      on b.subject_key = e.subject_key
     and b.topic_code = e.topic_code
     and b.status = 'published'
    where e.subject_key = 'ap_physics_c_em'
      and e.unit_number = 12
      and e.topic_code in ('12.1', '12.2', '12.3', '12.4')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics C:E&M Unit 12 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_em'
    and b.topic_code in ('12.1', '12.2', '12.3', '12.4')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:E&M Unit 12 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_c_em'
    and b.unit_number = 12
    and b.topic_code in ('12.1', '12.2', '12.3', '12.4')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-c-em/unit-12/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:E&M Unit 12 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_em'
    and b.topic_code in ('12.1', '12.2', '12.3', '12.4')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C:E&M Unit 12 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select
      topic_explainer_id,
      mini_example_question,
      weak_answer,
      point_attaining_answer,
      practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_physics_c_em'
      and unit_number = 12
      and topic_code in ('12.1', '12.2', '12.3', '12.4')
      and status = 'published'
  ),
  field_values as (
    select 'mini_example_question' as field_name, mini_example_question as value from new_explainers
    union all
    select 'weak_answer', weak_answer from new_explainers
    union all
    select 'point_attaining_answer', point_attaining_answer from new_explainers
    union all
    select 'practice_bridge', practice_bridge from new_explainers
  )
  select count(*) into v_duplicate_explainer_fields
  from field_values fv
  join app.topic_explainers e
    on (
      e.mini_example_question = fv.value
      or e.weak_answer = fv.value
      or e.point_attaining_answer = fv.value
      or e.practice_bridge = fv.value
    )
  where e.status = 'published'
    and not (
      e.subject_key = 'ap_physics_c_em'
      and e.unit_number = 12
      and e.topic_code in ('12.1', '12.2', '12.3', '12.4')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics C:E&M Unit 12 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
