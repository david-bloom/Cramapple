begin;

-- Add AP Physics 2 Unit 12 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 4 AP Physics 2 Unit 12 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_2_CED_FACT_PACK.md Unit 12 (Magnetism
-- and Electromagnetism). The fact pack confirms magnetic fields from dipoles
-- rather than monopoles, field-line and dipole-alignment behavior, magnetic
-- forces on moving charges with FB=qvB sin(theta) and the 0/90/180 degree
-- quantitative boundary, fields and forces for current-carrying wires,
-- vector addition of magnetic fields, magnetic flux, Faraday's law, Lenz's
-- law, and motional emf E=Blv.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_2', 12, '12.1', 'Magnetic Fields',
    'very-important', 'very-important',
    'A magnetic field is a vector field produced by magnetic dipoles or moving charge, not isolated magnetic monopoles. Field lines form loops and a compass aligns with the local field.',
    'Magnetic-field reasoning sets direction before equations appear. Dipole structure, field-line maps, and material response explain how magnets and magnetic materials interact.',
    'You earn points by identifying north/south dipoles, drawing field direction, using field-line density qualitatively for strength, and describing alignment or attraction/repulsion correctly.',
    'Sketch the dipole first: outside a bar magnet the field points away from north and toward south, with closed loops through the magnet.',
    'Breaking a magnet into separate north and south monopoles instead of two smaller dipoles.',
    '/learn/ap-physics-2/unit-12/magnetic-fields'
  ),
  (
    'ap_physics_2', 12, '12.2', 'Magnetism and Moving Charges',
    'very-important', 'very-important',
    'A moving charged object can create a magnetic field and can feel magnetic force in an external field. The force magnitude is FB = qvB sin(theta).',
    'This topic is where vector direction matters most. Magnetic force is perpendicular to velocity and magnetic field, so the right-hand rule determines paths and signs.',
    'You earn points by using the right-hand rule, including charge sign, applying the angle boundary for quantitative force, and separating electric and magnetic forces when both fields are present.',
    'Point fingers with velocity, curl toward B, then use the thumb for positive-charge force and reverse direction for a negative charge.',
    'Using qvB without checking whether velocity is parallel, perpendicular, or antiparallel to the magnetic field.',
    '/learn/ap-physics-2/unit-12/magnetism-and-moving-charges'
  ),
  (
    'ap_physics_2', 12, '12.3', 'Magnetism and Current-Carrying Wires',
    'very-important', 'very-important',
    'A current-carrying wire creates a magnetic field around it and can experience force in an external magnetic field. For a long straight wire, B = mu0 I/(2 pi r).',
    'Wire questions connect current direction, circular magnetic-field geometry, and force on a current segment. Multiple wire fields combine as vectors, not scalar strengths.',
    'You earn points by applying the wire right-hand rule, recognizing tangent circular fields around straight wires, using B proportional to I/r, and adding fields by direction.',
    'For a straight wire, point your thumb with conventional current; curled fingers show the magnetic-field direction around the wire.',
    'Drawing the magnetic field from a straight current-carrying wire radially outward instead of tangent to circles around the wire.',
    '/learn/ap-physics-2/unit-12/magnetism-and-current-carrying-wires'
  ),
  (
    'ap_physics_2', 12, '12.4', 'Electromagnetic Induction and Faraday''s Law',
    'very-important', 'very-important',
    'Magnetic flux measures the perpendicular magnetic-field component through an area, PhiB = BA cos(theta). A changing flux induces emf according to Faraday''s law.',
    'Induction questions reward tracking what changes: field strength, area, angle, or motion. Lenz''s law then gives the induced direction by opposing the flux change.',
    'You earn points by defining the area vector, deciding whether flux is increasing or decreasing, applying Faraday''s law, and using Lenz''s law for induced current direction.',
    'Write the original flux direction, state whether its magnitude is increasing or decreasing, then choose the induced field that opposes that change.',
    'Choosing induced current direction from the external field direction alone instead of from the change in magnetic flux.',
    '/learn/ap-physics-2/unit-12/electromagnetic-induction-and-faradays-law'
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
    'ap_physics_2', 12, '12.1', 'Magnetic Fields',
    'Magnetic fields are vector fields tied to dipoles. A magnet always has north and south polarity together, field lines form closed loops, and a small magnetic dipole such as a compass tends to align with the local external field.',
    'Students need to avoid treating magnetism like isolated electric charge. There is no single magnetic north pole by itself in this model. Cutting a bar magnet creates smaller dipoles. Materials respond differently because their microscopic dipoles can align strongly, weakly, or opposite an applied field.',
    'Points come from drawing field direction consistently, identifying dipoles, using field-line spacing qualitatively for strength, and explaining material response or compass alignment from the external magnetic field.',
    'Sketch the dipole first: outside a bar magnet the field points away from north and toward south, with closed loops through the magnet.',
    'A bar magnet is cut into two equal pieces. What magnetic poles does each piece have?',
    'One piece becomes a north pole and the other piece becomes a south pole.',
    'Each piece becomes a smaller dipole with both a north and a south pole. Magnetic monopoles are not produced by cutting the magnet. The field pattern changes size, but each piece still has closed-loop field lines and two poles.',
    'Breaking a magnet into separate north and south monopoles instead of two smaller dipoles.',
    'Back in practice, draw magnetic field lines as loops and keep north/south together. That one sketch prevents most monopole-style mistakes.'
  ),
  (
    'ap_physics_2', 12, '12.2', 'Magnetism and Moving Charges',
    'Magnetic force on a moving charge is perpendicular to both velocity and magnetic field. Its magnitude is qvB sin(theta), so it is zero when velocity is parallel or antiparallel to B and maximum when velocity is perpendicular to B.',
    'Students need to separate magnitude from direction. The equation gives size, but the right-hand rule gives direction for a positive charge; a negative charge reverses that direction. When electric and magnetic fields are both present, their forces are independent and must be combined as vectors.',
    'Points come from checking the angle, applying the quantitative boundary for 0, 90, or 180 degrees, using the right-hand rule correctly, and reversing the force direction for negative charge when needed.',
    'Point fingers with velocity, curl toward B, then use the thumb for positive-charge force and reverse direction for a negative charge.',
    'A positive charge moves to the right through a magnetic field directed into the page. What is the magnetic-force direction?',
    'The force is into the page because the magnetic field points into the page.',
    'For a positive charge, point the fingers to the right for velocity and curl them into the page for B. The thumb points upward, so the magnetic force is upward. The force is perpendicular to both v and B, not in the same direction as B.',
    'Using qvB without checking whether velocity is parallel, perpendicular, or antiparallel to the magnetic field.',
    'In practice, do the direction step before the arithmetic. If v is parallel or antiparallel to B, the sine factor makes the magnetic force zero.'
  ),
  (
    'ap_physics_2', 12, '12.3', 'Magnetism and Current-Carrying Wires',
    'A straight current-carrying wire creates circular magnetic-field lines centered on the wire. The field is tangent to those circles, grows with current, and decreases with distance as B = mu0 I/(2 pi r). A wire in an external field can also experience magnetic force.',
    'Students need to track two related but different ideas: the magnetic field made by the current and the force on a current in an outside field. Direction comes from right-hand rules in both cases, and fields from multiple wires add as vectors at the point being considered.',
    'Points are earned by drawing the circular field geometry, using perpendicular distance from the wire, applying B proportional to I/r, and adding contributions with signs or directions instead of adding magnitudes blindly.',
    'For a straight wire, point your thumb with conventional current; curled fingers show the magnetic-field direction around the wire.',
    'Two long straight wires carry equal currents upward. At a point midway between them, how should the magnetic fields from the two wires be combined?',
    'Add the two field magnitudes because both wires have the same current.',
    'The fields must be combined as vectors. Use the right-hand rule for each upward current. At the midpoint, one wire creates a field into the page and the other creates a field out of the page, with equal magnitudes if the distances are equal. The fields cancel at that point, so the net field is zero.',
    'Drawing the magnetic field from a straight current-carrying wire radially outward instead of tangent to circles around the wire.',
    'Back in practice, mark the field direction from each wire before adding. Equal magnitudes can cancel if their directions oppose.'
  ),
  (
    'ap_physics_2', 12, '12.4', 'Electromagnetic Induction and Faraday''s Law',
    'Induced emf comes from changing magnetic flux, not from magnetic field alone. Flux depends on B, area, and angle through PhiB = BA cos(theta), and Lenz''s law sets the induced direction by opposing the change in flux.',
    'Students need to ask what is changing. Flux can change because the field changes, the loop area changes, the loop rotates, or a conducting rod moves through a field. The induced current creates its own magnetic field that opposes the increase or decrease in the original flux.',
    'Points come from defining the area vector, computing or comparing flux, applying Faraday''s law for emf magnitude, and using Lenz''s law rather than guessing current direction from the external field alone.',
    'Write the original flux direction, state whether its magnitude is increasing or decreasing, then choose the induced field that opposes that change.',
    'A loop lies flat on a table in an upward magnetic field. The upward field through the loop is increasing. What direction should the induced magnetic field through the loop point?',
    'The induced field points upward because the external field points upward.',
    'The induced field points downward. The upward flux is increasing, so Lenz''s law says the induced current must create a field that opposes that increase. The induced direction is chosen from the change in flux, not simply copied from the external field direction.',
    'Choosing induced current direction from the external field direction alone instead of from the change in magnetic flux.',
    'In practice, write increase or decrease next to the flux arrow. Lenz direction follows from opposing that change.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 2 Unit 12 Magnetism and Electromagnetism; grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 12: magnetic dipoles and field maps, no monopoles, material magnetism, magnetic force qvB sin(theta) and 0/90/180 degree quantitative boundary, magnetic fields and forces for current-carrying wires, vector addition, magnetic flux BA cos(theta), Faraday law, Lenz law, and motional emf E=Blv; batch 2026-08-25-ap-physics-2-unit12-topic-guides; author=reviewer same session, no independent human review yet',
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
    'ap_physics_2', 12, '12.1', 'Magnetic Fields',
    'Magnetic fields are vector fields tied to dipoles. A magnet always has north and south polarity together, field lines form closed loops, and a small magnetic dipole such as a compass tends to align with the local external field.',
    'Students need to avoid treating magnetism like isolated electric charge. There is no single magnetic north pole by itself in this model. Cutting a bar magnet creates smaller dipoles. Materials respond differently because their microscopic dipoles can align strongly, weakly, or opposite an applied field.',
    'Points come from drawing field direction consistently, identifying dipoles, using field-line spacing qualitatively for strength, and explaining material response or compass alignment from the external magnetic field.',
    'Sketch the dipole first: outside a bar magnet the field points away from north and toward south, with closed loops through the magnet.',
    'A bar magnet is cut into two equal pieces. What magnetic poles does each piece have?',
    'One piece becomes a north pole and the other piece becomes a south pole.',
    'Each piece becomes a smaller dipole with both a north and a south pole. Magnetic monopoles are not produced by cutting the magnet. The field pattern changes size, but each piece still has closed-loop field lines and two poles.',
    'Breaking a magnet into separate north and south monopoles instead of two smaller dipoles.',
    'Back in practice, draw magnetic field lines as loops and keep north/south together. That one sketch prevents most monopole-style mistakes.'
  ),
  (
    'ap_physics_2', 12, '12.2', 'Magnetism and Moving Charges',
    'Magnetic force on a moving charge is perpendicular to both velocity and magnetic field. Its magnitude is qvB sin(theta), so it is zero when velocity is parallel or antiparallel to B and maximum when velocity is perpendicular to B.',
    'Students need to separate magnitude from direction. The equation gives size, but the right-hand rule gives direction for a positive charge; a negative charge reverses that direction. When electric and magnetic fields are both present, their forces are independent and must be combined as vectors.',
    'Points come from checking the angle, applying the quantitative boundary for 0, 90, or 180 degrees, using the right-hand rule correctly, and reversing the force direction for negative charge when needed.',
    'Point fingers with velocity, curl toward B, then use the thumb for positive-charge force and reverse direction for a negative charge.',
    'A positive charge moves to the right through a magnetic field directed into the page. What is the magnetic-force direction?',
    'The force is into the page because the magnetic field points into the page.',
    'For a positive charge, point the fingers to the right for velocity and curl them into the page for B. The thumb points upward, so the magnetic force is upward. The force is perpendicular to both v and B, not in the same direction as B.',
    'Using qvB without checking whether velocity is parallel, perpendicular, or antiparallel to the magnetic field.',
    'In practice, do the direction step before the arithmetic. If v is parallel or antiparallel to B, the sine factor makes the magnetic force zero.'
  ),
  (
    'ap_physics_2', 12, '12.3', 'Magnetism and Current-Carrying Wires',
    'A straight current-carrying wire creates circular magnetic-field lines centered on the wire. The field is tangent to those circles, grows with current, and decreases with distance as B = mu0 I/(2 pi r). A wire in an external field can also experience magnetic force.',
    'Students need to track two related but different ideas: the magnetic field made by the current and the force on a current in an outside field. Direction comes from right-hand rules in both cases, and fields from multiple wires add as vectors at the point being considered.',
    'Points are earned by drawing the circular field geometry, using perpendicular distance from the wire, applying B proportional to I/r, and adding contributions with signs or directions instead of adding magnitudes blindly.',
    'For a straight wire, point your thumb with conventional current; curled fingers show the magnetic-field direction around the wire.',
    'Two long straight wires carry equal currents upward. At a point midway between them, how should the magnetic fields from the two wires be combined?',
    'Add the two field magnitudes because both wires have the same current.',
    'The fields must be combined as vectors. Use the right-hand rule for each upward current. At the midpoint, one wire creates a field into the page and the other creates a field out of the page, with equal magnitudes if the distances are equal. The fields cancel at that point, so the net field is zero.',
    'Drawing the magnetic field from a straight current-carrying wire radially outward instead of tangent to circles around the wire.',
    'Back in practice, mark the field direction from each wire before adding. Equal magnitudes can cancel if their directions oppose.'
  ),
  (
    'ap_physics_2', 12, '12.4', 'Electromagnetic Induction and Faraday''s Law',
    'Induced emf comes from changing magnetic flux, not from magnetic field alone. Flux depends on B, area, and angle through PhiB = BA cos(theta), and Lenz''s law sets the induced direction by opposing the change in flux.',
    'Students need to ask what is changing. Flux can change because the field changes, the loop area changes, the loop rotates, or a conducting rod moves through a field. The induced current creates its own magnetic field that opposes the increase or decrease in the original flux.',
    'Points come from defining the area vector, computing or comparing flux, applying Faraday''s law for emf magnitude, and using Lenz''s law rather than guessing current direction from the external field alone.',
    'Write the original flux direction, state whether its magnitude is increasing or decreasing, then choose the induced field that opposes that change.',
    'A loop lies flat on a table in an upward magnetic field. The upward field through the loop is increasing. What direction should the induced magnetic field through the loop point?',
    'The induced field points upward because the external field points upward.',
    'The induced field points downward. The upward flux is increasing, so Lenz''s law says the induced current must create a field that opposes that increase. The induced direction is chosen from the change in flux, not simply copied from the external field direction.',
    'Choosing induced current direction from the external field direction alone instead of from the change in magnetic flux.',
    'In practice, write increase or decrease next to the flux arrow. Lenz direction follows from opposing that change.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 2 Unit 12 Magnetism and Electromagnetism; grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 12: magnetic dipoles and field maps, no monopoles, material magnetism, magnetic force qvB sin(theta) and 0/90/180 degree quantitative boundary, magnetic fields and forces for current-carrying wires, vector addition, magnetic flux BA cos(theta), Faraday law, Lenz law, and motional emf E=Blv; batch 2026-08-25-ap-physics-2-unit12-topic-guides; author=reviewer same session, no independent human review yet',
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
  where subject_key = 'ap_physics_2'
    and unit_number = 12
    and topic_code in ('12.1', '12.2', '12.3', '12.4')
    and status = 'published';

  if v_briefs <> 4 then
    raise exception 'expected 4 published AP Physics 2 Unit 12 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_2'
    and unit_number = 12
    and topic_code in ('12.1', '12.2', '12.3', '12.4')
    and status = 'published';

  if v_explainers <> 4 then
    raise exception 'expected 4 published AP Physics 2 Unit 12 explainers, got %', v_explainers;
  end if;

  select count(*) into v_pairing_orphans
  from (
    select b.subject_key, b.topic_code
    from app.topic_point_briefs b
    left join app.topic_explainers e
      on e.subject_key = b.subject_key
     and e.topic_code = b.topic_code
     and e.status = 'published'
    where b.subject_key = 'ap_physics_2'
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
    where e.subject_key = 'ap_physics_2'
      and e.unit_number = 12
      and e.topic_code in ('12.1', '12.2', '12.3', '12.4')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 12 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_2'
    and b.topic_code in ('12.1', '12.2', '12.3', '12.4')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 12 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_2'
    and b.unit_number = 12
    and b.topic_code in ('12.1', '12.2', '12.3', '12.4')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-2/unit-12/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 12 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_2'
    and b.topic_code in ('12.1', '12.2', '12.3', '12.4')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 12 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select
      topic_explainer_id,
      mini_example_question,
      weak_answer,
      point_attaining_answer,
      practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_physics_2'
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
      e.subject_key = 'ap_physics_2'
      and e.unit_number = 12
      and e.topic_code in ('12.1', '12.2', '12.3', '12.4')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 12 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
