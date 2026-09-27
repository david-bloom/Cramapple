begin;

-- Add AP Chemistry Unit 6 topic-guide pairs.
--
-- Production coverage before this migration, verified 2026-08-26:
-- app.taxonomy_topics has 9 AP Chemistry Unit 6 topics and 0 published point
-- briefs/explainers for the unit.
--
-- Grounding: docs/product/AP_CHEMISTRY_CED_FACT_PACK.md Unit 6
-- (Thermochemistry). The fact pack confirms endothermic/exothermic processes,
-- energy diagrams, heat transfer and thermal equilibrium, q=mc Delta T,
-- calorimetry sign conventions, phase-change energy, reaction enthalpy at
-- constant pressure, bond enthalpy estimates, enthalpy of formation, Hess law,
-- and the 2025 FRQ Q3 misconception trail for significant figures, total
-- solution mass, exothermic sign, limiting-reactant heat release, and checking
-- Hess-law equation sums before adding Delta H values.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_chemistry', 6, '6.1', 'Endothermic and Exothermic Processes', 'very-important', 'very-important',
   'Endothermic processes absorb energy from surroundings; exothermic processes release energy to surroundings.',
   'This sign and system-surroundings language underlies calorimetry, solution formation, enthalpy, and energy diagrams.',
   'You earn points by identifying the system, tracking energy flow, connecting temperature change to surroundings, and assigning the correct sign for the process.',
   'Name the system first; then decide whether energy enters or leaves that system.',
   'Calling a process exothermic just because the system temperature is higher without identifying system and surroundings.',
   '/learn/ap-chemistry/unit-6/endothermic-and-exothermic-processes'),
  ('ap_chemistry', 6, '6.2', 'Energy Diagrams', 'very-important', 'somewhat-important',
   'Energy diagrams show whether products or final states are higher or lower in energy than reactants or initial states.',
   'Diagrams make thermochemical sign visible. A higher final state means energy absorbed; a lower final state means energy released.',
   'You earn points by labeling reactants and products, reading Delta H sign from vertical position, and distinguishing overall energy change from activation energy when relevant.',
   'Compare product energy to reactant energy before deciding endothermic or exothermic.',
   'Reading only the arrow direction and ignoring whether products are above or below reactants.',
   '/learn/ap-chemistry/unit-6/energy-diagrams'),
  ('ap_chemistry', 6, '6.3', 'Heat Transfer and Thermal Equilibrium', 'very-important', 'somewhat-important',
   'Heat transfer is energy transfer from warmer particles to cooler particles through collisions until thermal equilibrium is reached.',
   'Thermal equilibrium means equal temperature and equal average particle kinetic energy, not equal total energy.',
   'You earn points by describing particle collision energy transfer, identifying warmer-to-cooler direction, and explaining equilibrium as equal average kinetic energy.',
   'Track average kinetic energy through collisions, then state when temperatures become equal.',
   'Saying thermal equilibrium means both objects contain the same total thermal energy.',
   '/learn/ap-chemistry/unit-6/heat-transfer-and-thermal-equilibrium'),
  ('ap_chemistry', 6, '6.4', 'Heat Capacity and Calorimetry', 'very-important', 'very-important',
   'Calorimetry uses q = mc Delta T to connect heat transfer with mass, specific heat, and temperature change.',
   'This is the main quantitative thermochemistry tool. AP evidence flags total solution mass, sign, and significant figures as recurring scoring hazards.',
   'You earn points by using the correct mass, specific heat, and Delta T; applying energy conservation; assigning system sign from observed temperature change; and reporting appropriate significant figures.',
   'Use total solution mass when appropriate, calculate q for the surroundings, then flip sign for the reacting system if needed.',
   'Using only solute mass in q=mc Delta T or dropping the negative sign for an exothermic reaction.',
   '/learn/ap-chemistry/unit-6/heat-capacity-and-calorimetry'),
  ('ap_chemistry', 6, '6.5', 'Energy of Phase Changes', 'very-important', 'somewhat-important',
   'Phase changes absorb or release energy while temperature stays constant for a pure substance during the change.',
   'Heating curves and phase-change enthalpies separate temperature change from potential-energy change in particle attractions.',
   'You earn points by identifying whether energy is absorbed or released, using phase-change enthalpy with the correct sign, and not changing temperature during the plateau.',
   'Decide whether the process moves to a more separated or less separated phase; then assign energy input or release.',
   'Using q=mc Delta T during a phase-change plateau where temperature is constant.',
   '/learn/ap-chemistry/unit-6/energy-of-phase-changes'),
  ('ap_chemistry', 6, '6.6', 'Introduction to Enthalpy of Reaction', 'very-important', 'very-important',
   'Reaction enthalpy is the heat absorbed or released by a reaction at constant pressure, with negative Delta H for exothermic reactions and positive Delta H for endothermic reactions.',
   'AP Chemistry treats most reaction heat at constant pressure as enthalpy change, without assessing technical internal-energy distinctions.',
   'You earn points by connecting temperature change to reaction sign, scaling heat by moles reacted when needed, and distinguishing reaction-system energy from solution or surroundings energy.',
   'Use the observed temperature change to decide heat flow, then report Delta H for the reaction with the system sign.',
   'Reporting positive Delta H for a reaction that warms the solution without accounting for heat released by the reacting system.',
   '/learn/ap-chemistry/unit-6/introduction-to-enthalpy-of-reaction'),
  ('ap_chemistry', 6, '6.7', 'Bond Enthalpies', 'very-important', 'very-important',
   'Bond enthalpy estimates compare energy required to break reactant bonds with energy released when product bonds form.',
   'This gives a particle-level estimate of reaction enthalpy. Breaking bonds costs energy; forming bonds releases energy.',
   'You earn points by counting all broken and formed bonds, summing average bond energies, and using broken minus formed to estimate Delta H.',
   'List bonds broken and bonds formed separately before substituting numbers.',
   'Treating bond formation as energy absorbed or forgetting coefficient-based bond counts.',
   '/learn/ap-chemistry/unit-6/bond-enthalpies'),
  ('ap_chemistry', 6, '6.8', 'Enthalpy of Formation', 'very-important', 'very-important',
   'Standard enthalpy of formation values combine as Delta H reaction = sum products minus sum reactants.',
   'Formation data allow reaction enthalpy calculation without drawing every bond or measuring a calorimeter directly.',
   'You earn points by multiplying each formation enthalpy by its coefficient, summing products and reactants separately, and subtracting reactants from products.',
   'Write products minus reactants and include coefficients before calculating.',
   'Reversing the subtraction or forgetting to multiply formation values by balanced coefficients.',
   '/learn/ap-chemistry/unit-6/enthalpy-of-formation'),
  ('ap_chemistry', 6, '6.9', 'Hess''s Law', 'very-important', 'very-important',
   'Hess law uses reaction addition: reversing, scaling, and summing equations changes Delta H in matching ways.',
   'Hess law works because the target reaction must be assembled from given equations before the enthalpy values are combined.',
   'You earn points by reversing equations when needed, multiplying equations and Delta H together, canceling species to match the target, and only then summing enthalpies.',
   'Make the equations sum to the target first; then add the adjusted Delta H values.',
   'Adding the listed Delta H values without checking whether the adjusted equations actually produce the target reaction.',
   '/learn/ap-chemistry/unit-6/hesss-law')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 6 Thermochemistry; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 6: endothermic/exothermic processes, energy diagrams, heat transfer and thermal equilibrium, q=mc Delta T, calorimetry sign conventions, phase-change energy, reaction enthalpy at constant pressure, bond enthalpy estimates, enthalpy of formation, Hess law, and 2025 FRQ Q3 misconception evidence for significant figures, total solution mass, exothermic sign, limiting-reactant heat release, and checking Hess-law equation sums before adding Delta H values; batch 2026-08-26-ap-chemistry-unit6-topic-guides; author=reviewer same session, no independent human review yet',
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
  ('ap_chemistry', 6, '6.1', 'Endothermic and Exothermic Processes',
   'Thermochemistry answers a system-surroundings question: does energy enter the system or leave it?',
   'Students need to define the system. If the reacting system releases energy, the surroundings may warm up and the process is exothermic with negative Delta H. If the system absorbs energy, the surroundings may cool and the process is endothermic with positive Delta H. Solution formation can go either way depending on attractions before and after mixing.',
   'Points come from naming system and surroundings, tracking energy direction, and assigning the sign to the process rather than to a vague temperature observation.',
   'Name the system first; then decide whether energy enters or leaves that system.',
   'A dissolution makes the beaker feel cold. Is the dissolving process endothermic or exothermic?',
   'Exothermic, because the beaker loses warmth and cold is released.',
   'Endothermic. The dissolving process is the system, and it absorbs energy from the surroundings, making the beaker feel colder.',
   'Calling a process exothermic just because the system temperature is higher without identifying system and surroundings.',
   'Back in practice, write system -> surroundings or surroundings -> system before assigning the sign.'),
  ('ap_chemistry', 6, '6.2', 'Energy Diagrams',
   'An energy diagram uses vertical position to show whether a process ends at higher or lower energy than it began.',
   'Students need to read the diagram before naming the process. Products above reactants indicate energy absorbed and positive Delta H. Products below reactants indicate energy released and negative Delta H. If a barrier is shown, activation energy is separate from overall energy change.',
   'Points come from labeling states, reading the sign of Delta H, and distinguishing the height to a peak from the reactant-to-product difference.',
   'Compare product energy to reactant energy before deciding endothermic or exothermic.',
   'On a diagram, products are above reactants. What sign should Delta H have?',
   'Negative, because the reaction went forward on the diagram.',
   'Positive. Products are higher in energy than reactants, so the system absorbed energy overall and the process is endothermic.',
   'Reading only the arrow direction and ignoring whether products are above or below reactants.',
   'In practice, mark high and low energy levels before writing the thermochemical sign.'),
  ('ap_chemistry', 6, '6.3', 'Heat Transfer and Thermal Equilibrium',
   'Heat transfer is energy transfer caused by a temperature difference, and it continues until average particle kinetic energies match.',
   'Students need particle reasoning. Warmer samples have higher average kinetic energy. Collisions transfer energy to cooler samples. Thermal equilibrium means equal temperature, not equal total thermal energy, because total energy also depends on amount and composition of matter.',
   'Points come from identifying transfer direction, explaining collisions, and describing equilibrium as equal temperature or equal average kinetic energy.',
   'Track average kinetic energy through collisions, then state when temperatures become equal.',
   'A large cool sample and a small warm sample reach the same final temperature. Do they necessarily contain equal thermal energy?',
   'Yes, because equal temperature means equal energy.',
   'No. Equal temperature means equal average particle kinetic energy, but total thermal energy also depends on amount of substance and heat capacity.',
   'Saying thermal equilibrium means both objects contain the same total thermal energy.',
   'Back in practice, reserve temperature for average kinetic energy and total thermal energy for the whole sample.'),
  ('ap_chemistry', 6, '6.4', 'Heat Capacity and Calorimetry',
   'Calorimetry uses temperature change of surroundings to infer heat transferred, while energy conservation connects that heat to the reacting system.',
   'Students need to choose mass and sign carefully. For solution calorimetry, the mass is often the total solution mass, not just solute. q=mc Delta T gives heat gained or lost by the measured surroundings. The reacting system has the opposite sign. The 2025 evidence also flags significant figures as a major scoring issue.',
   'Points come from substituting the correct m, c, and Delta T, keeping signs consistent, using q_system = -q_surroundings when appropriate, and reporting with correct significant figures.',
   'Use total solution mass when appropriate, calculate q for the surroundings, then flip sign for the reacting system if needed.',
   'A reaction warms 100.0 g of water after 0.10 g of solid dissolves. Which mass is usually used for q=mc Delta T of the solution?',
   'Use 0.10 g because that is the reacting solid.',
   'Use the mass of the solution being warmed, approximately 100.1 g if the solid remains in solution. q=mc Delta T describes the thermal change of the solution surroundings, not just the original solid mass.',
   'Using only solute mass in q=mc Delta T or dropping the negative sign for an exothermic reaction.',
   'In practice, label q_surroundings and q_system on separate lines before assigning the reaction enthalpy sign.'),
  ('ap_chemistry', 6, '6.5', 'Energy of Phase Changes',
   'During a pure-substance phase change, energy changes particle separation while temperature remains constant.',
   'Students need to separate sloped heating-curve regions from plateaus. Melting and vaporization absorb energy. Freezing and condensation release energy. Opposite phase changes have enthalpy values equal in magnitude and opposite in sign.',
   'Points come from selecting phase-change enthalpy instead of q=mc Delta T during a plateau, assigning the correct sign, and recognizing constant temperature during the phase change.',
   'Decide whether the process moves to a more separated or less separated phase; then assign energy input or release.',
   'Why does temperature stay constant while boiling occurs at constant pressure?',
   'Because no energy is being added during boiling.',
   'Energy is still being added, but it is used to separate particles into the gas phase rather than increase average kinetic energy, so temperature remains constant during the phase change.',
   'Using q=mc Delta T during a phase-change plateau where temperature is constant.',
   'Back in practice, use q=mc Delta T on sloped regions and phase-change enthalpy on plateaus.'),
  ('ap_chemistry', 6, '6.6', 'Introduction to Enthalpy of Reaction',
   'At constant pressure, reaction enthalpy tracks heat absorbed or released by the reacting system.',
   'Students need to assign the sign from the system perspective. If a reaction warms the solution, the surroundings gained heat and the reaction released heat, so Delta H for the reaction is negative. If the solution cools, the reaction absorbed heat and Delta H is positive.',
   'Points come from linking observation to heat flow, converting heat to per-mole reaction enthalpy when required, and keeping system and surroundings signs opposite.',
   'Use the observed temperature change to decide heat flow, then report Delta H for the reaction with the system sign.',
   'A reaction causes the solution temperature to increase. What sign should the reaction Delta H have?',
   'Positive, because the temperature increased.',
   'Negative. The solution surroundings gained heat, so the reacting system released heat. At constant pressure, the reaction enthalpy is exothermic and negative.',
   'Reporting positive Delta H for a reaction that warms the solution without accounting for heat released by the reacting system.',
   'In practice, write solution gained heat means reaction lost heat before assigning Delta H.'),
  ('ap_chemistry', 6, '6.7', 'Bond Enthalpies',
   'Bond enthalpy estimates use energy in for bonds broken and energy out for bonds formed.',
   'Students need to keep the signs straight. Breaking reactant bonds requires energy, so those terms are positive. Forming product bonds releases energy, so those terms reduce Delta H. Coefficients determine how many of each bond type are counted.',
   'Points come from counting bonds with coefficients, summing broken-bond energies, summing formed-bond energies, and calculating Delta H approximately as broken minus formed.',
   'List bonds broken and bonds formed separately before substituting numbers.',
   'Why can forming stronger product bonds make a reaction exothermic?',
   'Because breaking strong bonds releases extra energy.',
   'Breaking bonds requires energy. Forming strong product bonds releases a large amount of energy; if that release exceeds the energy required to break reactant bonds, the reaction is exothermic.',
   'Treating bond formation as energy absorbed or forgetting coefficient-based bond counts.',
   'Back in practice, make two columns: broken costs energy, formed releases energy.'),
  ('ap_chemistry', 6, '6.8', 'Enthalpy of Formation',
   'Standard formation enthalpies calculate reaction enthalpy by summing products and subtracting summed reactants.',
   'Students need to use coefficients and the correct direction. Each species formation value is multiplied by its balanced coefficient. The product sum minus reactant sum gives Delta H for the reaction as written.',
   'Points come from setting up Sigma products - Sigma reactants, multiplying by coefficients, and avoiding sign reversal.',
   'Write products minus reactants and include coefficients before calculating.',
   'For a reaction, why must formation enthalpies be multiplied by balanced coefficients?',
   'They should not be multiplied because the table value already belongs to the reaction.',
   'Formation enthalpies are usually given per mole of substance formed. The balanced equation tells how many moles of each substance participate, so each table value must be multiplied by its coefficient.',
   'Reversing the subtraction or forgetting to multiply formation values by balanced coefficients.',
   'In practice, write two brackets: products sum and reactants sum, then subtract the second from the first.'),
  ('ap_chemistry', 6, '6.9', 'Hess''s Law',
   'Hess law requires the equations to add to the target reaction, with every reversal or scaling reflected in Delta H.',
   'Students need to manipulate equations before manipulating only numbers. Reversing an equation changes the sign of Delta H. Multiplying an equation multiplies Delta H. When the adjusted equations sum to the target, their adjusted Delta H values sum to the target Delta H.',
   'Points come from matching the target equation through cancellation, adjusting Delta H with every equation change, and avoiding number-only addition.',
   'Make the equations sum to the target first; then add the adjusted Delta H values.',
   'Why is it unsafe to add the listed Delta H values before checking the equations?',
   'Because the calculator order might change the answer.',
   'The Delta H values only add after the corresponding equations have been reversed or multiplied so that they sum to the target reaction. Otherwise the numbers describe the wrong net process.',
   'Adding the listed Delta H values without checking whether the adjusted equations actually produce the target reaction.',
   'Back in practice, cancel species on the equations first and add Delta H values only after the target reaction appears.')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 6 Thermochemistry; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 6: endothermic/exothermic processes, energy diagrams, heat transfer and thermal equilibrium, q=mc Delta T, calorimetry sign conventions, phase-change energy, reaction enthalpy at constant pressure, bond enthalpy estimates, enthalpy of formation, Hess law, and 2025 FRQ Q3 misconception evidence for significant figures, total solution mass, exothermic sign, limiting-reactant heat release, and checking Hess-law equation sums before adding Delta H values; batch 2026-08-26-ap-chemistry-unit6-topic-guides; author=reviewer same session, no independent human review yet',
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
  where subject_key = 'ap_chemistry'
    and unit_number = 6
    and topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6', '6.7', '6.8', '6.9')
    and status = 'published';

  if v_briefs <> 9 then
    raise exception 'expected 9 published AP Chemistry Unit 6 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_chemistry'
    and unit_number = 6
    and topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6', '6.7', '6.8', '6.9')
    and status = 'published';

  if v_explainers <> 9 then
    raise exception 'expected 9 published AP Chemistry Unit 6 explainers, got %', v_explainers;
  end if;

  select count(*) into v_pairing_orphans
  from (
    select b.subject_key, b.topic_code
    from app.topic_point_briefs b
    left join app.topic_explainers e
      on e.subject_key = b.subject_key
     and e.topic_code = b.topic_code
     and e.status = 'published'
    where b.subject_key = 'ap_chemistry'
      and b.unit_number = 6
      and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6', '6.7', '6.8', '6.9')
      and b.status = 'published'
      and e.topic_code is null
    union all
    select e.subject_key, e.topic_code
    from app.topic_explainers e
    left join app.topic_point_briefs b
      on b.subject_key = e.subject_key
     and b.topic_code = e.topic_code
     and b.status = 'published'
    where e.subject_key = 'ap_chemistry'
      and e.unit_number = 6
      and e.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6', '6.7', '6.8', '6.9')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 6 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_chemistry'
    and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6', '6.7', '6.8', '6.9')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 6 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_chemistry'
    and b.unit_number = 6
    and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6', '6.7', '6.8', '6.9')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-chemistry/unit-6/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 6 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_chemistry'
    and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6', '6.7', '6.8', '6.9')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 6 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_chemistry'
      and unit_number = 6
      and topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6', '6.7', '6.8', '6.9')
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
      e.subject_key = 'ap_chemistry'
      and e.unit_number = 6
      and e.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6', '6.7', '6.8', '6.9')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 6 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
