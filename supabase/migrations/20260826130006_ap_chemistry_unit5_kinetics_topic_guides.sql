begin;

-- Add AP Chemistry Unit 5 topic-guide pairs.
--
-- Production coverage before this migration, verified 2026-08-26:
-- app.taxonomy_topics has 11 AP Chemistry Unit 5 topics and 0 published point
-- briefs/explainers for the unit.
--
-- Grounding: docs/product/AP_CHEMISTRY_CED_FACT_PACK.md Unit 5 (Kinetics).
-- The fact pack confirms reaction-rate definitions, rate laws and initial-rate
-- comparisons, integrated rate laws and first-order half-life, elementary
-- reactions, collision model and Maxwell-Boltzmann reasoning, reaction energy
-- profiles and qualitative Arrhenius interpretation, mechanisms,
-- rate-determining steps, pre-equilibrium approximation, multistep energy
-- profiles, catalysis, and the 2025 FRQ Q7 misconception trail requiring
-- catalyst evidence from individual mechanism steps.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_chemistry', 5, '5.1', 'Reaction Rates', 'very-important', 'very-important',
   'Reaction rate measures how fast reactants are converted to products, usually through concentration change per unit time.',
   'Rates connect particle collisions to measurable concentration changes. Stoichiometric coefficients determine how reactant disappearance and product appearance rates compare.',
   'You earn points by reading slope or concentration change over time, using balanced-equation ratios to compare rates, and explaining how concentration, temperature, surface area, or catalysts affect rate.',
   'Identify which species is changing; then use the balanced coefficients to relate its rate to the reaction rate or another species rate.',
   'Comparing concentration slopes without adjusting for the balanced-equation coefficients.',
   '/learn/ap-chemistry/unit-5/reaction-rates'),
  ('ap_chemistry', 5, '5.2', 'Introduction to Rate Law', 'very-important', 'very-important',
   'A rate law relates reaction rate to reactant concentrations raised to experimentally determined orders.',
   'Rate laws show which concentration changes matter for rate. Orders are determined from data, not copied from the balanced overall equation unless the step is elementary.',
   'You earn points by comparing initial-rate trials, finding individual orders, adding orders for overall order, and giving rate-constant units that match the overall order.',
   'Compare trials where only one reactant concentration changes; then connect the rate factor to the concentration factor.',
   'Using balanced-equation coefficients as reaction orders for a non-elementary overall reaction.',
   '/learn/ap-chemistry/unit-5/introduction-to-rate-law'),
  ('ap_chemistry', 5, '5.3', 'Concentration Changes over Time', 'very-important', 'very-important',
   'Integrated rate laws connect concentration to time, with linear graph tests distinguishing zero-, first-, and second-order reactions.',
   'This topic turns kinetics data into order and rate constant. First-order reactions also have a constant half-life, including radioactive decay examples.',
   'You earn points by choosing the graph that is linear, using the matching integrated rate law, reading k from slope sign and magnitude, and applying t_1/2 = 0.693/k only for first order.',
   'Test which plot is linear: [A] vs t, ln[A] vs t, or 1/[A] vs t; then use the matching equation.',
   'Using first-order half-life or ln[A] linearity for every reaction order.',
   '/learn/ap-chemistry/unit-5/concentration-changes-over-time'),
  ('ap_chemistry', 5, '5.4', 'Elementary Reactions', 'somewhat-important', 'somewhat-important',
   'An elementary reaction is a single molecular event, so its rate law follows directly from the particles colliding in that step.',
   'Elementary-step rate laws are the exception to the usual rule that orders come from experiment. They also explain why simultaneous collisions among three or more particles are rare.',
   'You earn points by identifying molecularity, writing the elementary-step rate law from reactants in that step, and not applying that shortcut to an overall non-elementary equation.',
   'Ask whether the equation is one elementary step; only then use its reactant coefficients as rate-law powers.',
   'Writing a rate law from the overall balanced equation when the problem describes a multistep mechanism.',
   '/learn/ap-chemistry/unit-5/elementary-reactions'),
  ('ap_chemistry', 5, '5.5', 'Collision Model', 'very-important', 'very-important',
   'The collision model says reactions require particles to collide with enough energy and proper orientation.',
   'This model explains temperature, concentration, surface area, and catalysts in particle terms. Maxwell-Boltzmann distributions show how temperature changes the fraction of collisions above activation energy.',
   'You earn points by linking rate changes to collision frequency, collision orientation, and the fraction of particles with energy at or above activation energy.',
   'Explain the rate change through successful collisions, not just more collisions.',
   'Saying higher temperature increases rate only because particles collide more often, without mentioning the larger fraction above activation energy.',
   '/learn/ap-chemistry/unit-5/collision-model'),
  ('ap_chemistry', 5, '5.6', 'Reaction Energy Profile', 'very-important', 'very-important',
   'A reaction energy profile shows reactants, transition state, products, activation energy, and overall energy change along a reaction coordinate.',
   'Energy profiles connect kinetic barriers to thermodynamic direction. AP Chemistry expects qualitative Arrhenius reasoning, but not Arrhenius-equation calculations.',
   'You earn points by identifying forward and reverse activation energies, determining endothermic or exothermic character, and explaining rate-temperature effects qualitatively.',
   'Mark reactants, products, and the peak first; then measure activation energy from the reactants to the transition state.',
   'Confusing activation energy with overall enthalpy change between reactants and products.',
   '/learn/ap-chemistry/unit-5/reaction-energy-profile'),
  ('ap_chemistry', 5, '5.7', 'Introduction to Reaction Mechanisms', 'very-important', 'very-important',
   'A reaction mechanism is a sequence of elementary steps that sum to the overall reaction, often containing intermediates and catalysts.',
   'Mechanisms explain how a reaction happens rather than only what the net equation is. Intermediates are produced in one step and consumed later, so they do not appear in the overall equation.',
   'You earn points by summing elementary steps, canceling species correctly, distinguishing intermediates from catalysts, and checking that the mechanism matches the overall reaction.',
   'Add the elementary steps and cancel species that appear on both sides; then classify canceled species by when they are produced or consumed.',
   'Calling every canceled species a spectator ion instead of deciding whether it is an intermediate or catalyst in the mechanism.',
   '/learn/ap-chemistry/unit-5/introduction-to-reaction-mechanisms'),
  ('ap_chemistry', 5, '5.8', 'Reaction Mechanism and Rate Law', 'very-important', 'very-important',
   'For many mechanisms, the slow elementary step determines the overall rate law, especially when the first step is rate-limiting.',
   'This topic connects mechanism steps to observed rate laws. The rate law comes from the molecularity of the rate-determining elementary step, with extra work needed if that step includes an intermediate.',
   'You earn points by identifying the slow step, writing its elementary rate law, and replacing intermediates only when the mechanism information requires it.',
   'Find the slow step first; then write the rate law from that elementary step rather than from the overall equation.',
   'Using the overall reaction coefficients instead of the slow elementary step to write the rate law.',
   '/learn/ap-chemistry/unit-5/reaction-mechanism-and-rate-law'),
  ('ap_chemistry', 5, '5.9', 'Pre-Equilibrium Approximation', 'somewhat-important', 'somewhat-important',
   'Pre-equilibrium reasoning is used when an early fast reversible step establishes an equilibrium before a later rate-limiting step.',
   'This lets students eliminate intermediates from a rate law when the slow step contains a species that is not in the overall reaction.',
   'You earn points by writing the slow-step rate law, using the fast pre-equilibrium relationship to express the intermediate in terms of reactants, and substituting cleanly.',
   'Write the slow-step rate law first; then use the earlier equilibrium expression only to replace the intermediate.',
   'Leaving an intermediate in the final rate law even though it is not a reactant in the overall reaction.',
   '/learn/ap-chemistry/unit-5/pre-equilibrium-approximation'),
  ('ap_chemistry', 5, '5.10', 'Multistep Reaction Energy Profile', 'somewhat-important', 'somewhat-important',
   'A multistep energy profile shows separate activation barriers and intermediates for each elementary step in a mechanism.',
   'The highest barrier often corresponds to the slowest step, and valleys between peaks represent intermediates formed and consumed during the mechanism.',
   'You earn points by matching peaks to transition states, valleys to intermediates, comparing activation energies, and connecting the largest barrier to the rate-determining step.',
   'Count the peaks and valleys; then label each step barrier before deciding which step is slowest.',
   'Calling the final product valley an intermediate or using total energy change as the slow-step barrier.',
   '/learn/ap-chemistry/unit-5/multistep-reaction-energy-profile'),
  ('ap_chemistry', 5, '5.11', 'Catalysis', 'very-important', 'very-important',
   'A catalyst increases reaction rate by providing an alternate pathway, often lowering activation energy, and is regenerated by the end of the mechanism.',
   'AP questions require evidence from mechanism steps: a catalyst is consumed in an early step and regenerated later, while an intermediate is produced first and consumed later.',
   'You earn points by citing the specific steps showing catalyst consumption and regeneration, distinguishing catalysts from intermediates, and connecting the alternate pathway to rate increase.',
   'Use the individual mechanism steps, not only the overall equation, to prove which species is the catalyst.',
   'Saying a species is a catalyst only because it lowers activation energy, without citing its consumption and regeneration in the mechanism.',
   '/learn/ap-chemistry/unit-5/catalysis')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 5 Kinetics; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 5: reaction rates, stoichiometric rate comparisons, initial-rate rate-law determination, integrated rate laws and first-order half-life, elementary reactions, collision model and Maxwell-Boltzmann reasoning, reaction energy profiles, qualitative Arrhenius interpretation without calculations, reaction mechanisms, rate-determining steps, pre-equilibrium approximation, multistep energy profiles, catalysis, and 2025 FRQ Q7 misconception evidence requiring catalyst identification from individual mechanism steps; batch 2026-08-26-ap-chemistry-unit5-topic-guides; author=reviewer same session, no independent human review yet',
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
  ('ap_chemistry', 5, '5.1', 'Reaction Rates',
   'Reaction rate is how quickly concentrations change as reactants become products, and the balanced equation controls how species rates compare.',
   'Students need to connect measured slopes to stoichiometry. If coefficients differ, one species may disappear twice as fast as another appears. Rate can also change when concentration, temperature, surface area, catalyst, or environment changes the number of successful collisions.',
   'Points come from reading concentration-time data, using coefficient ratios to compare species rates, and explaining factor changes through particle behavior.',
   'Identify which species is changing; then use the balanced coefficients to relate its rate to the reaction rate or another species rate.',
   'For 2A -> B, [A] decreases at 0.20 M/s. At what rate does [B] increase?',
   'B increases at 0.20 M/s because the reaction happens at one rate.',
   'B increases at 0.10 M/s. The balanced equation says 2 mol A are consumed for every 1 mol B formed, so the disappearance rate of A is twice the appearance rate of B.',
   'Comparing concentration slopes without adjusting for the balanced-equation coefficients.',
   'Back in practice, divide each species concentration-change rate by its coefficient before comparing reaction rates.'),
  ('ap_chemistry', 5, '5.2', 'Introduction to Rate Law',
   'A rate law is an experimental relationship between rate and reactant concentrations, with orders found from data.',
   'Students need to use initial-rate comparisons. If one concentration doubles while others stay constant and the rate doubles, the order in that reactant is one. If the rate quadruples, the order is two. Overall order is the sum of individual orders, and rate constant units depend on that overall order.',
   'Points come from isolating one variable between trials, solving for reactant orders, writing the rate law, and determining k with correct units when asked.',
   'Compare trials where only one reactant concentration changes; then connect the rate factor to the concentration factor.',
   'When [A] doubles and [B] is constant, the rate quadruples. What is the order in A?',
   'First order, because A doubled and the rate changed.',
   'Second order. Doubling [A] causes the rate to increase by a factor of four, so rate is proportional to [A]^2 for that reactant.',
   'Using balanced-equation coefficients as reaction orders for a non-elementary overall reaction.',
   'In practice, write rate factor = concentration factor^order before guessing an order.'),
  ('ap_chemistry', 5, '5.3', 'Concentration Changes over Time',
   'Integrated rate laws identify reaction order by which concentration transformation produces a straight line over time.',
   'Students need to match graph, equation, and slope. Zero order gives linear [A] vs t with slope -k. First order gives linear ln[A] vs t with slope -k and constant half-life. Second order gives linear 1/[A] vs t with slope +k.',
   'Points come from choosing the linear plot, extracting k from the correct slope, using the matching integrated rate law, and applying first-order half-life only when appropriate.',
   'Test which plot is linear: [A] vs t, ln[A] vs t, or 1/[A] vs t; then use the matching equation.',
   'A plot of ln[A] versus time is linear with negative slope. What order is the reaction?',
   'Second order because concentration is changing with time.',
   'It is first order. A linear ln[A] versus time plot matches ln[A]_t - ln[A]_0 = -kt, and the slope is -k.',
   'Using first-order half-life or ln[A] linearity for every reaction order.',
   'Back in practice, make a three-row table: linear [A], linear ln[A], linear 1/[A]. Then choose the row that matches the data.'),
  ('ap_chemistry', 5, '5.4', 'Elementary Reactions',
   'An elementary reaction is one molecular event, so its reactants directly determine the rate law for that step.',
   'Students need to recognize the boundary of the shortcut. For an elementary step A + B -> products, the step rate law is rate = k[A][B]. For an overall reaction made of multiple steps, the overall coefficients do not automatically give orders. Collisions involving three or more particles at once are rare.',
   'Points come from identifying molecularity, writing the rate law for a named elementary step, and avoiding the elementary shortcut for overall equations.',
   'Ask whether the equation is one elementary step; only then use its reactant coefficients as rate-law powers.',
   'For the elementary step NO2 + CO -> NO + CO2, what reactant concentrations appear in the step rate law?',
   'Only CO2 appears because it is a product of the step.',
   'The reactants NO2 and CO appear: rate = k[NO2][CO]. For an elementary step, the rate law follows the colliding reactant particles in that single step.',
   'Writing a rate law from the overall balanced equation when the problem describes a multistep mechanism.',
   'In practice, circle the word elementary before using coefficients as powers.'),
  ('ap_chemistry', 5, '5.5', 'Collision Model',
   'A successful collision requires both enough energy to overcome activation energy and a productive particle orientation.',
   'Students need to explain rate changes through successful collisions. Raising temperature increases particle energy and the fraction above activation energy. Increasing concentration or surface area can increase collision frequency. Orientation matters because not every collision forms products.',
   'Points come from naming the factor changed, connecting it to collision frequency, energy distribution, or orientation, and explaining why successful collision count changes.',
   'Explain the rate change through successful collisions, not just more collisions.',
   'Why does increasing temperature usually increase reaction rate more than a simple collision-frequency explanation suggests?',
   'Because particles collide more often, and that is the only effect of temperature.',
   'Higher temperature shifts the energy distribution so a larger fraction of particles have energy at or above activation energy. Collision frequency may also rise, but the key AP explanation is more energetically successful collisions.',
   'Saying higher temperature increases rate only because particles collide more often, without mentioning the larger fraction above activation energy.',
   'Back in practice, include the phrase fraction above activation energy when explaining temperature effects.'),
  ('ap_chemistry', 5, '5.6', 'Reaction Energy Profile',
   'A reaction energy profile shows the energy barrier between reactants and the transition state, plus the energy difference between reactants and products.',
   'Students need to separate kinetics from thermodynamics. Activation energy affects rate. Overall energy change indicates endothermic or exothermic character. The Arrhenius equation supports qualitative temperature and activation-energy reasoning, but AP Chemistry does not assess Arrhenius calculations.',
   'Points come from labeling reactants, products, transition state, forward and reverse activation energy, and overall energy change correctly.',
   'Mark reactants, products, and the peak first; then measure activation energy from the reactants to the transition state.',
   'On an energy diagram, products are lower than reactants. What does that say about the reaction energy change?',
   'The activation energy is negative because products are lower.',
   'The overall energy change is negative, so the reaction is exothermic. Activation energy is measured from reactants up to the transition-state peak and remains a barrier.',
   'Confusing activation energy with overall enthalpy change between reactants and products.',
   'In practice, draw two vertical arrows: one to the peak for activation energy and one from reactants to products for overall energy change.'),
  ('ap_chemistry', 5, '5.7', 'Introduction to Reaction Mechanisms',
   'A mechanism is a set of elementary steps that add to the overall reaction, with intermediates and catalysts canceling from the net equation for different reasons.',
   'Students need to inspect individual steps. An intermediate is produced in one step and consumed in a later step. A catalyst is consumed first and regenerated later. The summed mechanism must match the overall balanced equation.',
   'Points come from adding steps, canceling correctly, classifying species from the order in which they appear, and checking the overall reaction.',
   'Add the elementary steps and cancel species that appear on both sides; then classify canceled species by when they are produced or consumed.',
   'A species is produced in step 1 and consumed in step 2, and it is absent from the overall equation. What is it?',
   'It is a catalyst because it cancels out of the overall equation.',
   'It is an intermediate. Intermediates are made during the mechanism and used up later. A catalyst would be consumed in an earlier step and regenerated later.',
   'Calling every canceled species a spectator ion instead of deciding whether it is an intermediate or catalyst in the mechanism.',
   'Back in practice, classify canceled species by order: consumed then produced means catalyst; produced then consumed means intermediate.'),
  ('ap_chemistry', 5, '5.8', 'Reaction Mechanism and Rate Law',
   'The rate-determining elementary step controls the rate law when it is the slow step that limits the mechanism.',
   'Students need to write the slow-step rate law from the reactants in that elementary step. If the slow step contains only species from the overall reaction, the rate law is direct. If it contains an intermediate, another mechanism relationship is needed before the final rate law is acceptable.',
   'Points come from identifying the slow step, using molecularity for that step, and avoiding overall-equation coefficients as rate-law powers.',
   'Find the slow step first; then write the rate law from that elementary step rather than from the overall equation.',
   'A mechanism labels step 1 as slow: A + B -> C. What is the rate law from that step?',
   'Use the overall reaction coefficients instead of the slow step.',
   'Because the slow step is elementary, its reactants determine the rate law: rate = k[A][B]. The overall equation is not the source of the powers.',
   'Using the overall reaction coefficients instead of the slow elementary step to write the rate law.',
   'In practice, write slow above the step, then copy only its reactants into the rate law.'),
  ('ap_chemistry', 5, '5.9', 'Pre-Equilibrium Approximation',
   'Pre-equilibrium lets a fast reversible step relate an intermediate concentration to reactant concentrations before the slow step occurs.',
   'Students need to see why substitution is needed. The slow-step rate law may contain an intermediate. Since intermediates should not usually appear in the experimentally observed rate law, the earlier fast equilibrium expression is used to rewrite that intermediate.',
   'Points come from writing the slow-step rate law, writing the pre-equilibrium expression, solving for the intermediate, and substituting without changing the mechanism logic.',
   'Write the slow-step rate law first; then use the earlier equilibrium expression only to replace the intermediate.',
   'The slow-step rate law includes intermediate I. Why is another relationship needed?',
   'No relationship is needed because intermediates can always appear in final rate laws.',
   'A final rate law should be expressed in terms of reactants that can be controlled or measured. The fast pre-equilibrium step can express [I] in terms of earlier reactants, allowing substitution into the slow-step rate law.',
   'Leaving an intermediate in the final rate law even though it is not a reactant in the overall reaction.',
   'Back in practice, box any intermediate in the slow-step law and look backward for the fast equilibrium that creates it.'),
  ('ap_chemistry', 5, '5.10', 'Multistep Reaction Energy Profile',
   'A multistep energy profile represents a mechanism as multiple barriers and wells: peaks are transition states and wells between peaks are intermediates.',
   'Students need to connect graph features to mechanism steps. Each peak corresponds to an elementary-step transition state. Each valley between reactants and products corresponds to an intermediate. The largest activation barrier usually marks the slowest step.',
   'Points come from counting steps, identifying intermediates, comparing activation energies, and connecting the rate-determining step to the highest barrier rather than total energy change.',
   'Count the peaks and valleys; then label each step barrier before deciding which step is slowest.',
   'A reaction coordinate diagram has two peaks with a valley between them. What does the middle valley represent?',
   'It is the final product because it is lower than the first peak.',
   'The middle valley represents an intermediate: a species formed after the first elementary step and consumed before the final products are reached.',
   'Calling the final product valley an intermediate or using total energy change as the slow-step barrier.',
   'In practice, label start, middle valleys, and end before deciding which peak is the largest barrier.'),
  ('ap_chemistry', 5, '5.11', 'Catalysis',
   'A catalyst changes the reaction pathway and is regenerated overall, so mechanism-step evidence is required to identify it.',
   'Students need to prove catalyst status from the mechanism, not just from a definition. A catalyst is consumed in one step and regenerated in a later step, leaving no net consumption in the overall equation. An intermediate is produced first and consumed later. Catalysts can lower activation energy or improve effective collision pathways.',
   'Points come from citing the exact steps where the catalyst is consumed and regenerated, distinguishing it from intermediates, and connecting the alternate pathway to increased rate.',
   'Use the individual mechanism steps, not only the overall equation, to prove which species is the catalyst.',
   'A mechanism consumes X in step 1 and produces X in step 2. How should you justify that X is a catalyst?',
   'X is a catalyst because catalysts lower activation energy and X is not in the overall reaction.',
   'X is a catalyst because the mechanism shows it being consumed in step 1 and regenerated in step 2, so it is not consumed overall. The step evidence is the required justification.',
   'Saying a species is a catalyst only because it lowers activation energy, without citing its consumption and regeneration in the mechanism.',
   'Back in practice, identify catalyst or intermediate only after checking the order of appearance in individual steps.')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 5 Kinetics; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 5: reaction rates, stoichiometric rate comparisons, initial-rate rate-law determination, integrated rate laws and first-order half-life, elementary reactions, collision model and Maxwell-Boltzmann reasoning, reaction energy profiles, qualitative Arrhenius interpretation without calculations, reaction mechanisms, rate-determining steps, pre-equilibrium approximation, multistep energy profiles, catalysis, and 2025 FRQ Q7 misconception evidence requiring catalyst identification from individual mechanism steps; batch 2026-08-26-ap-chemistry-unit5-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 5
    and topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9', '5.10', '5.11')
    and status = 'published';

  if v_briefs <> 11 then
    raise exception 'expected 11 published AP Chemistry Unit 5 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_chemistry'
    and unit_number = 5
    and topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9', '5.10', '5.11')
    and status = 'published';

  if v_explainers <> 11 then
    raise exception 'expected 11 published AP Chemistry Unit 5 explainers, got %', v_explainers;
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
      and b.unit_number = 5
      and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9', '5.10', '5.11')
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
      and e.unit_number = 5
      and e.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9', '5.10', '5.11')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 5 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_chemistry'
    and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9', '5.10', '5.11')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 5 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_chemistry'
    and b.unit_number = 5
    and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9', '5.10', '5.11')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-chemistry/unit-5/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 5 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_chemistry'
    and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9', '5.10', '5.11')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 5 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_chemistry'
      and unit_number = 5
      and topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9', '5.10', '5.11')
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
      and e.unit_number = 5
      and e.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9', '5.10', '5.11')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 5 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
