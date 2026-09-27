begin;

-- Add AP Physics C: Electricity and Magnetism Unit 9 topic-guide pairs.
--
-- Production coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 3 AP Physics C:E&M Unit 9 topics and 0 published
-- point briefs/explainers for the unit.
--
-- Grounding: docs/product/AP_PHYSICS_C_EM_CED_FACT_PACK.md Unit 9
-- (Electric Potential). The fact pack confirms potential energy
-- U = k q1 q2 / r, point-charge and multi-charge potential superposition
-- V = k q / r and V = k sum(q_i / r_i), potential difference
-- deltaV = deltaU / q, field-potential relationships, deltaU = q deltaV,
-- the five approved geometries for calculus-based potential derivations,
-- separate scoring of substitution and integration limits in deltaV
-- derivations, and the vector-field/scalar-potential contrast.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_c_em', 9, '9.1', 'Electric Potential Energy',
    'very-important', 'very-important',
    'Electric potential energy is the energy stored in a charge configuration. For two point charges, U = k q1 q2 / r, with the sign coming from the charge signs and the distance measured between the charges.',
    'This is the energy version of Coulomb interaction. It lets later potential, conductor, capacitor, and circuit questions talk about energy changes without redoing force work from scratch every time.',
    'You earn points by using the signs of both charges, the separation between charges, and superposition when more than one interacting pair contributes to the system energy.',
    'Before calculating U, list the interacting charge pairs and write the sign of q1 q2 for each pair; then add pair energies as scalars, not as force vectors.',
    'Dropping the sign of q1 q2 and reporting every electric potential energy as positive.',
    '/learn/ap-physics-c-em/unit-9/electric-potential-energy'
  ),
  (
    'ap_physics_c_em', 9, '9.2', 'Electric Potential',
    'very-important', 'very-important',
    'Electric potential is electric potential energy per unit charge. For point charges, V = kq/r, and potentials from multiple charges add as scalars even when the electric fields from those charges must be added as vectors.',
    'Potential is the scalar shortcut that connects fields to energy. It is also the common place where students lose points by treating potential like a vector or by using calculus on a geometry the course does not assess.',
    'You earn points by adding potentials with signs but no directions, using deltaV = - integral E dot dr when deriving potential difference from a field, and restricting calculus-based potential derivations to the approved geometries.',
    'First decide whether the prompt asks for field or potential: field needs vector components, but potential needs signed scalar terms added directly.',
    'Canceling electric potential because equal and opposite field components cancel at the point.',
    '/learn/ap-physics-c-em/unit-9/electric-potential'
  ),
  (
    'ap_physics_c_em', 9, '9.3', 'Conservation of Electric Energy',
    'very-important', 'very-important',
    'Conservation of electric energy tracks how electric potential energy changes into kinetic energy or other energy stores. The key relationship is deltaU = q deltaV, combined with total mechanical/electric energy conservation when nonconservative work is absent.',
    'This is where potential becomes motion. A charge moving through a potential difference changes electric potential energy, and that change must be balanced by kinetic-energy or work terms.',
    'You earn points by computing deltaU = q deltaV with the sign of q included, then applying energy conservation consistently instead of assuming every move to lower potential increases kinetic energy for every charge sign.',
    'Write deltaU = q(V_f - V_i) before judging speed changes; the sign of the moving charge decides whether a given potential change raises or lowers electric potential energy.',
    'Saying lower electric potential always means lower electric potential energy, even for a negative charge.',
    '/learn/ap-physics-c-em/unit-9/conservation-of-electric-energy'
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
    'ap_physics_c_em', 9, '9.1', 'Electric Potential Energy',
    'Electric potential energy belongs to an interacting charge configuration, not to one isolated charge by itself. For a two-charge pair, U = k q1 q2 / r, so like charges have positive potential energy relative to infinite separation and opposite charges have negative potential energy relative to infinite separation.',
    'Students need to keep three details visible: the sign of q1 q2 matters, r is the separation between the two charges, and in a multi-charge system the total potential energy is the scalar sum over interacting pairs. Force directions do not get added into U.',
    'Points usually come from showing the pair list and preserving signs. In a three-charge setup, there are three distinct pair energies, not one energy per charge and not a vector sum. A correct final number with missing pair accounting is fragile on FRQ scoring.',
    'Before calculating U, list the interacting charge pairs and write the sign of q1 q2 for each pair; then add pair energies as scalars, not as force vectors.',
    'Two point charges, +q and -q, are separated by distance r. A student says the electric potential energy is positive because energy is stored in the pair. Evaluate the claim.',
    'The student is right because energy cannot be negative; stored energy should be positive.',
    'The claim is incorrect under the standard zero at infinite separation. For a two-charge pair, U = k q1 q2 / r. Here q1 q2 is negative because the charges have opposite signs, so U is negative. The negative sign does not mean energy is impossible; it means external work would be required to separate the attractive pair to infinity, where U is defined as zero.',
    'Dropping the sign of q1 q2 and reporting every electric potential energy as positive.',
    'Back in practice, write the sign of q1 q2 before substituting magnitudes. That one line prevents most potential-energy sign errors.'
  ),
  (
    'ap_physics_c_em', 9, '9.2', 'Electric Potential',
    'Electric potential is a scalar, so direction does not enter the superposition step. A positive charge contributes positive kq/r, a negative charge contributes negative kq/r, and the total potential is the signed scalar sum. This is deliberately different from electric field, where components and directions must be added as vectors.',
    'Students need to separate two questions that often share the same diagram: what is the net electric field, and what is the electric potential? Equal-and-opposite field components can cancel while the scalar potentials from the same charges still add to a nonzero value.',
    'Points are earned by using signed scalar terms for V, by setting up deltaV = - integral E dot dr when the prompt asks for a field-to-potential derivation, and by staying inside the course-approved direct-integration geometries for potential.',
    'First decide whether the prompt asks for field or potential: field needs vector components, but potential needs signed scalar terms added directly.',
    'Two identical positive point charges sit symmetrically to the left and right of point P. At P, their horizontal electric-field components cancel. What is the electric potential at P relative to infinity?',
    'The potential is zero because the fields cancel at P.',
    'The electric field can be zero while the electric potential is positive. Field is a vector, so equal fields from the two positive charges point in opposite directions at P and cancel. Potential is a scalar, so the two contributions add: V_total = kq/r + kq/r = 2kq/r if both charges are distance r from P. Direction cancels for field, but not for potential.',
    'Canceling electric potential because equal and opposite field components cancel at the point.',
    'In practice, write a big "scalar" next to V before adding contributions. If you find yourself drawing arrows for potential, you have slipped back into field reasoning.'
  ),
  (
    'ap_physics_c_em', 9, '9.3', 'Conservation of Electric Energy',
    'A moving charge changes electric potential energy according to deltaU = q deltaV. Energy conservation then says any decrease in electric potential energy must appear as increased kinetic energy or another energy transfer if no external/nonconservative work is doing the accounting.',
    'Students need to include the sign of the moving charge. A positive charge moving to lower potential has negative deltaU and can speed up; a negative charge making the same move has positive deltaU and would not speed up unless some external work supplies the energy.',
    'Points come from writing the energy equation before the conclusion. The safest setup is K_i + U_i = K_f + U_f, or deltaK = -deltaU when only electric potential energy and kinetic energy trade off, with deltaU = q(V_f - V_i).',
    'Write deltaU = q(V_f - V_i) before judging speed changes; the sign of the moving charge decides whether a given potential change raises or lowers electric potential energy.',
    'A positive charge is released from rest and moves from 80 V to 20 V with no nonconservative work. What happens to its kinetic energy? How would the sign change for a negative charge making the same potential change?',
    'Both charges move to lower potential, so both lose potential energy and gain kinetic energy.',
    'For the positive charge, deltaV = 20 V - 80 V = -60 V, so deltaU = q deltaV is negative. With energy conserved, deltaK = -deltaU is positive, so the positive charge gains kinetic energy. For a negative charge, q is negative, so q deltaV is positive for the same deltaV; its electric potential energy would increase, not decrease. It would not gain kinetic energy from that same motion unless another force or external work supplied energy.',
    'Saying lower electric potential always means lower electric potential energy, even for a negative charge.',
    'Back in practice, do not reason from "higher" or "lower" potential alone. Multiply by the charge sign first, then decide how kinetic energy changes.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:E&M Unit 9 Electric Potential; grounded in AP_PHYSICS_C_EM_CED_FACT_PACK.md Unit 9: electric potential energy U=kq1q2/r, scalar potential V=kq/r and signed superposition, deltaV=-integral E dot dr, deltaU=q deltaV, approved potential-integration geometries, and vector-field/scalar-potential contrast; batch 2026-08-25-ap-physics-c-em-unit9-topic-guides; author=reviewer same session, no independent human review yet',
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
    'ap_physics_c_em', 9, '9.1', 'Electric Potential Energy',
    'Electric potential energy belongs to an interacting charge configuration, not to one isolated charge by itself. For a two-charge pair, U = k q1 q2 / r, so like charges have positive potential energy relative to infinite separation and opposite charges have negative potential energy relative to infinite separation.',
    'Students need to keep three details visible: the sign of q1 q2 matters, r is the separation between the two charges, and in a multi-charge system the total potential energy is the scalar sum over interacting pairs. Force directions do not get added into U.',
    'Points usually come from showing the pair list and preserving signs. In a three-charge setup, there are three distinct pair energies, not one energy per charge and not a vector sum. A correct final number with missing pair accounting is fragile on FRQ scoring.',
    'Before calculating U, list the interacting charge pairs and write the sign of q1 q2 for each pair; then add pair energies as scalars, not as force vectors.',
    'Two point charges, +q and -q, are separated by distance r. A student says the electric potential energy is positive because energy is stored in the pair. Evaluate the claim.',
    'The student is right because energy cannot be negative; stored energy should be positive.',
    'The claim is incorrect under the standard zero at infinite separation. For a two-charge pair, U = k q1 q2 / r. Here q1 q2 is negative because the charges have opposite signs, so U is negative. The negative sign does not mean energy is impossible; it means external work would be required to separate the attractive pair to infinity, where U is defined as zero.',
    'Dropping the sign of q1 q2 and reporting every electric potential energy as positive.',
    'Back in practice, write the sign of q1 q2 before substituting magnitudes. That one line prevents most potential-energy sign errors.'
  ),
  (
    'ap_physics_c_em', 9, '9.2', 'Electric Potential',
    'Electric potential is a scalar, so direction does not enter the superposition step. A positive charge contributes positive kq/r, a negative charge contributes negative kq/r, and the total potential is the signed scalar sum. This is deliberately different from electric field, where components and directions must be added as vectors.',
    'Students need to separate two questions that often share the same diagram: what is the net electric field, and what is the electric potential? Equal-and-opposite field components can cancel while the scalar potentials from the same charges still add to a nonzero value.',
    'Points are earned by using signed scalar terms for V, by setting up deltaV = - integral E dot dr when the prompt asks for a field-to-potential derivation, and by staying inside the course-approved direct-integration geometries for potential.',
    'First decide whether the prompt asks for field or potential: field needs vector components, but potential needs signed scalar terms added directly.',
    'Two identical positive point charges sit symmetrically to the left and right of point P. At P, their horizontal electric-field components cancel. What is the electric potential at P relative to infinity?',
    'The potential is zero because the fields cancel at P.',
    'The electric field can be zero while the electric potential is positive. Field is a vector, so equal fields from the two positive charges point in opposite directions at P and cancel. Potential is a scalar, so the two contributions add: V_total = kq/r + kq/r = 2kq/r if both charges are distance r from P. Direction cancels for field, but not for potential.',
    'Canceling electric potential because equal and opposite field components cancel at the point.',
    'In practice, write a big "scalar" next to V before adding contributions. If you find yourself drawing arrows for potential, you have slipped back into field reasoning.'
  ),
  (
    'ap_physics_c_em', 9, '9.3', 'Conservation of Electric Energy',
    'A moving charge changes electric potential energy according to deltaU = q deltaV. Energy conservation then says any decrease in electric potential energy must appear as increased kinetic energy or another energy transfer if no external/nonconservative work is doing the accounting.',
    'Students need to include the sign of the moving charge. A positive charge moving to lower potential has negative deltaU and can speed up; a negative charge making the same move has positive deltaU and would not speed up unless some external work supplies the energy.',
    'Points come from writing the energy equation before the conclusion. The safest setup is K_i + U_i = K_f + U_f, or deltaK = -deltaU when only electric potential energy and kinetic energy trade off, with deltaU = q(V_f - V_i).',
    'Write deltaU = q(V_f - V_i) before judging speed changes; the sign of the moving charge decides whether a given potential change raises or lowers electric potential energy.',
    'A positive charge is released from rest and moves from 80 V to 20 V with no nonconservative work. What happens to its kinetic energy? How would the sign change for a negative charge making the same potential change?',
    'Both charges move to lower potential, so both lose potential energy and gain kinetic energy.',
    'For the positive charge, deltaV = 20 V - 80 V = -60 V, so deltaU = q deltaV is negative. With energy conserved, deltaK = -deltaU is positive, so the positive charge gains kinetic energy. For a negative charge, q is negative, so q deltaV is positive for the same deltaV; its electric potential energy would increase, not decrease. It would not gain kinetic energy from that same motion unless another force or external work supplied energy.',
    'Saying lower electric potential always means lower electric potential energy, even for a negative charge.',
    'Back in practice, do not reason from "higher" or "lower" potential alone. Multiply by the charge sign first, then decide how kinetic energy changes.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:E&M Unit 9 Electric Potential; grounded in AP_PHYSICS_C_EM_CED_FACT_PACK.md Unit 9: electric potential energy U=kq1q2/r, scalar potential V=kq/r and signed superposition, deltaV=-integral E dot dr, deltaU=q deltaV, approved potential-integration geometries, and vector-field/scalar-potential contrast; batch 2026-08-25-ap-physics-c-em-unit9-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 9
    and topic_code in ('9.1', '9.2', '9.3')
    and status = 'published';

  if v_briefs <> 3 then
    raise exception 'expected 3 published AP Physics C:E&M Unit 9 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_c_em'
    and unit_number = 9
    and topic_code in ('9.1', '9.2', '9.3')
    and status = 'published';

  if v_explainers <> 3 then
    raise exception 'expected 3 published AP Physics C:E&M Unit 9 explainers, got %', v_explainers;
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
      and b.unit_number = 9
      and b.topic_code in ('9.1', '9.2', '9.3')
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
      and e.unit_number = 9
      and e.topic_code in ('9.1', '9.2', '9.3')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics C:E&M Unit 9 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_em'
    and b.topic_code in ('9.1', '9.2', '9.3')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:E&M Unit 9 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_c_em'
    and b.unit_number = 9
    and b.topic_code in ('9.1', '9.2', '9.3')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-c-em/unit-9/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:E&M Unit 9 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_em'
    and b.topic_code in ('9.1', '9.2', '9.3')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C:E&M Unit 9 core_idea/what_it_is matches, got %', v_core_matches;
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
      and unit_number = 9
      and topic_code in ('9.1', '9.2', '9.3')
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
      and e.unit_number = 9
      and e.topic_code in ('9.1', '9.2', '9.3')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics C:E&M Unit 9 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
