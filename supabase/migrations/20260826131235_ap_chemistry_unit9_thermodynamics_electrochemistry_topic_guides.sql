begin;

-- Add AP Chemistry Unit 9 topic-guide pairs.
--
-- Production coverage before this migration, verified 2026-08-26:
-- app.taxonomy_topics has 11 AP Chemistry Unit 9 topics and 0 published point
-- briefs/explainers for the unit.
--
-- Grounding: docs/product/AP_CHEMISTRY_CED_FACT_PACK.md Unit 9 (Thermodynamics and Electrochemistry).
-- The fact pack confirms entropy, absolute entropy, Gibbs free energy, thermodynamic favorability, kinetic control, free energy and equilibrium, dissolution free energy, coupled reactions, galvanic and electrolytic cell roles, cell potential and free energy, qualitative nonstandard cell potential, Faraday law, and 2025 misconception evidence for particle-level entropy, Gibbs sign reasoning, temperature shifts, and electrochemical electrode-role transfer.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_chemistry', 9, '9.1', 'Introduction to Entropy', 'very-important', 'very-important',
   'Entropy increases when matter or energy becomes more dispersed among more possible arrangements.',
   'AP scoring requires particle-level reasoning, not vague order/disorder language.',
   'You earn points by naming gas moles, phase dispersal, volume, temperature, or energy distribution changes and linking them to microstates.',
   'Explain what particles or energy are becoming more dispersed.',
   'Saying only more disorder without a particle-level justification.',
   '/learn/ap-chemistry/unit-9/introduction-to-entropy'),
  ('ap_chemistry', 9, '9.2', 'Absolute Entropy and Entropy Change', 'very-important', 'very-important',
   'Standard entropy changes are calculated as products minus reactants using tabulated absolute entropy values.',
   'This parallels formation enthalpy/free-energy setups while tracking dispersal.',
   'You earn points by multiplying each standard entropy by coefficients and subtracting reactant sum from product sum.',
   'Set up products minus reactants with coefficients before calculating.',
   'Forgetting coefficients or reversing the subtraction.',
   '/learn/ap-chemistry/unit-9/absolute-entropy-and-entropy-change'),
  ('ap_chemistry', 9, '9.3', 'Gibbs Free Energy and Thermodynamic Favorability', 'very-important', 'very-important',
   'Delta G combines enthalpy and entropy to decide whether a process is thermodynamically favored.',
   'The key equation is Delta G = Delta H - T Delta S, and each sign must be evaluated for the specific prompt.',
   'You earn points by calculating or reasoning from Delta H, Delta S, and T and using thermodynamically favored when Delta G is negative.',
   'Check which term favors negative Delta G before claiming the process is favored.',
   'Claiming both terms favor the process when only one sign supports negative Delta G.',
   '/learn/ap-chemistry/unit-9/gibbs-free-energy-and-thermodynamic-favorability'),
  ('ap_chemistry', 9, '9.4', 'Thermodynamic and Kinetic Control', 'very-important', 'very-important',
   'A thermodynamically favored process may be too slow to observe if it has a large kinetic barrier.',
   'This prevents students from equating no visible reaction with equilibrium or unfavorability.',
   'You earn points by distinguishing Delta G favorability from activation-energy-controlled rate.',
   'State whether the issue is thermodynamic direction or kinetic rate barrier.',
   'Saying a favored reaction that is slow must be at equilibrium.',
   '/learn/ap-chemistry/unit-9/thermodynamic-and-kinetic-control'),
  ('ap_chemistry', 9, '9.5', 'Free Energy and Equilibrium', 'very-important', 'very-important',
   'Standard free energy and K are linked: negative Delta G standard means products favored and K greater than 1.',
   'This connects thermodynamics to equilibrium composition. Larger absolute Delta G pushes K farther from 1.',
   'You earn points by using Delta G standard = -RT ln K and interpreting sign and magnitude correctly.',
   'Translate Delta G sign into K relative to 1 before doing detailed interpretation.',
   'Saying Delta G near zero means no reaction rather than K near 1.',
   '/learn/ap-chemistry/unit-9/free-energy-and-equilibrium'),
  ('ap_chemistry', 9, '9.6', 'Free Energy of Dissolution', 'very-important', 'very-important',
   'Dissolution favorability depends on competing enthalpy and entropy effects from separating solute, reorganizing solvent, and forming solute-solvent interactions.',
   'This topic explains why solubility predictions are not one-factor guesses. Enthalpy and entropy contributions can cancel.',
   'You earn points by identifying the three contributions and explaining why the total Delta G may be favorable or unfavorable.',
   'Break dissolution into solute separation, solvent reorganization, and solute-solvent attraction before judging favorability.',
   'Assuming every dissolving process is entropy-favored and therefore always favored.',
   '/learn/ap-chemistry/unit-9/free-energy-of-dissolution'),
  ('ap_chemistry', 9, '9.7', 'Coupled Reactions', 'very-important', 'very-important',
   'An unfavorable process can be driven by coupling it to a favorable process or external energy source.',
   'This explains electrolysis, battery charging, photosynthesis, and biochemical ATP coupling.',
   'You earn points by showing the combined process has negative net Delta G or by identifying the external energy input.',
   'Add the Delta G values for coupled steps and decide whether the net process is favored.',
   'Calling the unfavorable step favored just because it occurs when coupled.',
   '/learn/ap-chemistry/unit-9/coupled-reactions'),
  ('ap_chemistry', 9, '9.8', 'Galvanic and Electrolytic Cells', 'very-important', 'very-important',
   'Electrochemical cells separate oxidation and reduction into half-cells connected by electron and ion flow paths.',
   'Galvanic cells use favored redox to produce electrical energy; electrolytic cells use electrical energy to drive unfavored redox. Anode is always oxidation and cathode is always reduction.',
   'You earn points by identifying anode/cathode by process, explaining salt bridge and electron flow roles, and not relying on electrode positive/negative labels.',
   'Assign anode and cathode from oxidation and reduction, not from charge labels.',
   'Assuming cathode always means the same metal role from an earlier part of a question.',
   '/learn/ap-chemistry/unit-9/galvanic-voltaic-and-electrolytic-cells'),
  ('ap_chemistry', 9, '9.9', 'Cell Potential and Free Energy', 'very-important', 'very-important',
   'Cell potential measures redox driving force, with positive E for thermodynamically favored cell reactions and Delta G = -nFE.',
   'Standard reduction potentials calculate standard cell potential from chosen reduction and oxidation half-reactions.',
   'You earn points by choosing cathode/anode from reduction potentials, calculating E cell, and connecting sign to Delta G and favorability.',
   'Choose the reduction with greater reduction potential for the cathode in a galvanic cell; then calculate E cell.',
   'Forgetting that a metal can switch electrode roles when paired with a different half-reaction.',
   '/learn/ap-chemistry/unit-9/cell-potential-and-free-energy'),
  ('ap_chemistry', 9, '9.10', 'Cell Potential under Nonstandard Conditions', 'very-important', 'very-important',
   'Nonstandard cell potential depends on reaction composition and decreases toward zero as the cell approaches equilibrium.',
   'The Nernst equation supports qualitative concentration reasoning; AP expects explanation, not bare plug-and-chug.',
   'You earn points by using Q qualitatively, explaining concentration effects on driving force, and recognizing E=0 at equilibrium.',
   'Relate concentration changes to Q, then explain whether the cell is farther from or closer to equilibrium.',
   'Using Le Chatelier equilibrium-shift language as if the electrochemical cell were already at equilibrium.',
   '/learn/ap-chemistry/unit-9/cell-potential-under-nonstandard-conditions'),
  ('ap_chemistry', 9, '9.11', 'Electrolysis and Faraday''s Law', 'very-important', 'very-important',
   'Faraday law connects current, time, electrons transferred, ion charge, and mass plated or removed at an electrode.',
   'This turns redox stoichiometry into measurable electroplating and electrolysis quantities.',
   'You earn points by using I=q/t, converting charge to moles of electrons, using ion charge for mole ratios, and converting moles to mass.',
   'Convert current and time to charge, charge to electrons, electrons to substance, then substance to mass.',
   'Ignoring ion charge when converting electrons to moles of metal plated.',
   '/learn/ap-chemistry/unit-9/electrolysis-and-faradays-law')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 9 Thermodynamics and Electrochemistry; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 9: entropy, absolute entropy, Gibbs free energy, thermodynamic favorability, kinetic control, free energy and equilibrium, dissolution free energy, coupled reactions, galvanic and electrolytic cell roles, cell potential and free energy, qualitative nonstandard cell potential, Faraday law, and 2025 misconception evidence for particle-level entropy, Gibbs sign reasoning, temperature shifts, and electrochemical electrode-role transfer; batch 2026-08-26-ap-chemistry-unit9-topic-guides; author=reviewer same session, no independent human review yet',
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
  ('ap_chemistry', 9, '9.1', 'Introduction to Entropy',
   'Entropy is dispersal of matter and energy at the particle level.',
   'Students need examples: solid to liquid to gas, gas expansion, more gas product moles, and broader kinetic-energy distributions at higher temperature.',
   'Points come from a specific particle or energy-dispersal explanation.',
   'Explain what particles or energy are becoming more dispersed.',
   'Why does producing more moles of gas often increase entropy?',
   'Because products are more disordered.',
   'More gas particles can occupy more positions and energy arrangements, increasing the number of microstates and system entropy.',
   'Saying only more disorder without a particle-level justification.',
   'Back in practice, replace disorder with a sentence about particles or energy distribution.'),
  ('ap_chemistry', 9, '9.2', 'Absolute Entropy and Entropy Change',
   'Delta S reaction is a coefficient-weighted products-minus-reactants calculation.',
   'Students need to treat S values as per mole of species in the balanced equation. The sign should be checked against particle-level expectations.',
   'Points come from setup and sign interpretation.',
   'Set up products minus reactants with coefficients before calculating.',
   'Why multiply S values by coefficients?',
    'Do not multiply; the table already gives entropy for each substance.' ,
   'Correct. The reaction entropy sum counts the amount of each species in the balanced reaction, so coefficients multiply the tabulated S values.',
   'Forgetting coefficients or reversing the subtraction.',
   'Back in practice, compare the calculated sign to gas-particle changes as a reasonableness check.'),
  ('ap_chemistry', 9, '9.3', 'Gibbs Free Energy and Thermodynamic Favorability',
   'Thermodynamic favorability depends on the sign of Delta G.',
   'Students need to use the CED-preferred term thermodynamically favored. Negative Delta H and positive Delta S favor all temperatures; positive Delta H and negative Delta S favor none; mixed signs require T comparison.',
   'Points come from sign-specific reasoning.',
   'Check which term favors negative Delta G before claiming the process is favored.',
   'If Delta H is positive and Delta S is positive, is the process favored at all temperatures?',
   'Yes, because positive entropy always wins.',
   'No. It may be favored only at high enough temperature because T Delta S must outweigh positive Delta H.',
   'Claiming both terms favor the process when only one sign supports negative Delta G.',
   'Back in practice, evaluate Delta H and -T Delta S as separate contributions.'),
  ('ap_chemistry', 9, '9.4', 'Thermodynamic and Kinetic Control',
   'Thermodynamics says where a process tends; kinetics says how fast it gets there.',
   'Students need to explain that high activation energy can prevent an energetically favored process from occurring measurably. Lack of visible change does not prove equilibrium.',
   'Points come from separating Delta G from rate.',
   'State whether the issue is thermodynamic direction or kinetic rate barrier.',
   'A reaction has negative Delta G but does not occur noticeably. What might explain this?',
   'It must not be thermodynamically favored.',
   'It may be kinetically slow because a high activation energy prevents a measurable rate.',
   'Saying a favored reaction that is slow must be at equilibrium.',
   'Back in practice, ask favorable? and fast? as separate questions.'),
  ('ap_chemistry', 9, '9.5', 'Free Energy and Equilibrium',
   'Delta G standard predicts product or reactant favoring at equilibrium.',
   'Students need to connect negative Delta G standard to K>1 and positive Delta G standard to K<1. When Delta G standard is about zero, neither side is strongly favored.',
   'Points come from sign-to-K reasoning.',
   'Translate Delta G sign into K relative to 1 before doing detailed interpretation.',
   'If Delta G standard is negative, what is true about K?',
   'K is less than 1 because energy is released.',
   'K is greater than 1, meaning products are favored at equilibrium under standard conditions.',
   'Saying Delta G near zero means no reaction rather than K near 1.',
   'Back in practice, memorize the pair: negative Delta G standard, K greater than 1.'),
  ('ap_chemistry', 9, '9.6', 'Free Energy of Dissolution',
   'Dissolution Delta G is a balance of several particle-level energy and dispersal changes.',
   'Students need to reason qualitatively about solid attractions, solvent structure, and interactions between dissolved species and solvent. The total can be hard to predict without data.',
   'Points come from balanced factor reasoning.',
   'Break dissolution into solute separation, solvent reorganization, and solute-solvent attraction before judging favorability.',
   'Why can a salt fail to dissolve even though mixing would disperse ions?',
   'Entropy always makes dissolving happen, so it should dissolve.',
   'The entropy gain may be outweighed by unfavorable enthalpy terms such as breaking strong ionic attractions or reorganizing solvent, so total Delta G can be positive.',
   'Assuming every dissolving process is entropy-favored and therefore always favored.',
   'Back in practice, list enthalpy and entropy factors before predicting dissolution.'),
  ('ap_chemistry', 9, '9.7', 'Coupled Reactions',
   'Coupling makes the net process favorable, not the unfavorable step by itself.',
   'Students need to track shared intermediates or external energy. A favorable reaction can drive an unfavorable one when the combined Delta G is negative.',
   'Points come from net Delta G reasoning.',
   'Add the Delta G values for coupled steps and decide whether the net process is favored.',
   'If one step has Delta G = +20 kJ/mol and a coupled step has Delta G = -35 kJ/mol, is the overall process favored?',
   'No, because one step is positive.',
   'Yes. The net Delta G is -15 kJ/mol, so the coupled overall process is thermodynamically favored.',
   'Calling the unfavorable step favored just because it occurs when coupled.',
   'Back in practice, add Delta G values for the coupled overall process.'),
  ('ap_chemistry', 9, '9.8', 'Galvanic and Electrolytic Cells',
   'Anode and cathode are process labels: oxidation at anode, reduction at cathode.',
   'Students need to describe electrodes, solutions, salt bridge, and meter roles. The AP boundary excludes assessing positive/negative electrode labeling, so process evidence matters most.',
   'Points come from half-reaction role assignment and cell-component function.',
   'Assign anode and cathode from oxidation and reduction, not from charge labels.',
   'In any electrochemical cell, where does oxidation occur?',
   'At the electrode labeled positive.',
   'At the anode. Anode means oxidation in both galvanic and electrolytic cells.',
   'Assuming cathode always means the same metal role from an earlier part of a question.',
   'Back in practice, write anode = oxidation and cathode = reduction before considering anything else.'),
  ('ap_chemistry', 9, '9.9', 'Cell Potential and Free Energy',
   'E cell and Delta G have opposite signs for a given electron count.',
   'Students need to use standard reduction potentials flexibly. The best cathode/anode pairing depends on the pair being compared, not earlier roles in a question.',
   'Points come from correct half-cell choice and sign interpretation.',
   'Choose the reduction with greater reduction potential for the cathode in a galvanic cell; then calculate E cell.',
   'If E standard is positive, what is the sign of Delta G standard?',
   'Positive, because both indicate a strong reaction.',
   'Negative, because Delta G standard = -nFE standard. Positive cell potential means thermodynamically favored.',
   'Forgetting that a metal can switch electrode roles when paired with a different half-reaction.',
   'Back in practice, after finding E, immediately write the Delta G sign.'),
  ('ap_chemistry', 9, '9.10', 'Cell Potential under Nonstandard Conditions',
   'Cell potential is a driving force that changes as Q changes.',
   'Students need to reason that a cell far from equilibrium has larger driving force and a cell at equilibrium has zero potential. Nonstandard concentration changes alter Q and therefore E.',
   'Points come from qualitative Nernst reasoning with a conceptual explanation.',
   'Relate concentration changes to Q, then explain whether the cell is farther from or closer to equilibrium.',
   'What happens to E as a galvanic cell approaches equilibrium?',
   'It increases because more products are present.',
   'It decreases toward zero because the driving force is used up as Q approaches K.',
   'Using Le Chatelier equilibrium-shift language as if the electrochemical cell were already at equilibrium.',
   'Back in practice, write Q approaches K means E approaches 0.'),
  ('ap_chemistry', 9, '9.11', 'Electrolysis and Faraday''s Law',
   'Electrolysis calculations are redox stoichiometry using charge as the measured amount.',
   'Students need to move through units: amperes to coulombs, coulombs to moles electrons, electrons to moles ion reduced or oxidized, and then to mass if needed.',
   'Points come from unit conversion and electron stoichiometry.',
   'Convert current and time to charge, charge to electrons, electrons to substance, then substance to mass.',
   'How many moles of electrons are needed to plate 1 mol of Cu from Cu2+?',
   'One mole, because one mole of copper is made.',
   'Two moles of electrons are needed because Cu2+ must gain 2 electrons to become Cu(s).',
   'Ignoring ion charge when converting electrons to moles of metal plated.',
   'Back in practice, write the reduction half-reaction before any Faraday calculation.')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 9 Thermodynamics and Electrochemistry; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 9: entropy, absolute entropy, Gibbs free energy, thermodynamic favorability, kinetic control, free energy and equilibrium, dissolution free energy, coupled reactions, galvanic and electrolytic cell roles, cell potential and free energy, qualitative nonstandard cell potential, Faraday law, and 2025 misconception evidence for particle-level entropy, Gibbs sign reasoning, temperature shifts, and electrochemical electrode-role transfer; batch 2026-08-26-ap-chemistry-unit9-topic-guides; author=reviewer same session, no independent human review yet',
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
  v_briefs integer; v_explainers integer; v_pairing_orphans integer;
  v_unit_mismatches integer; v_route_mismatches integer; v_core_matches integer;
  v_duplicate_explainer_fields integer;
begin
  select count(*) into v_briefs from app.topic_point_briefs where subject_key='ap_chemistry' and unit_number=9 and topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9', '9.10', '9.11') and status='published';
  if v_briefs <> 11 then raise exception 'expected 11 published AP Chemistry Unit 9 briefs, got %', v_briefs; end if;
  select count(*) into v_explainers from app.topic_explainers where subject_key='ap_chemistry' and unit_number=9 and topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9', '9.10', '9.11') and status='published';
  if v_explainers <> 11 then raise exception 'expected 11 published AP Chemistry Unit 9 explainers, got %', v_explainers; end if;
  select count(*) into v_pairing_orphans from (
    select b.subject_key,b.topic_code from app.topic_point_briefs b left join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code and e.status='published' where b.subject_key='ap_chemistry' and b.unit_number=9 and b.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9', '9.10', '9.11') and b.status='published' and e.topic_code is null
    union all
    select e.subject_key,e.topic_code from app.topic_explainers e left join app.topic_point_briefs b on b.subject_key=e.subject_key and b.topic_code=e.topic_code and b.status='published' where e.subject_key='ap_chemistry' and e.unit_number=9 and e.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9', '9.10', '9.11') and e.status='published' and b.topic_code is null
  ) orphans;
  if v_pairing_orphans <> 0 then raise exception 'expected 0 AP Chemistry Unit 9 pairing orphans, got %', v_pairing_orphans; end if;
  select count(*) into v_unit_mismatches from app.topic_point_briefs b join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code where b.subject_key='ap_chemistry' and b.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9', '9.10', '9.11') and b.status='published' and e.status='published' and b.unit_number<>e.unit_number;
  if v_unit_mismatches <> 0 then raise exception 'expected 0 AP Chemistry Unit 9 unit mismatches, got %', v_unit_mismatches; end if;
  select count(*) into v_route_mismatches from app.topic_point_briefs b where b.subject_key='ap_chemistry' and b.unit_number=9 and b.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9', '9.10', '9.11') and b.status='published' and (b.practice_subject_key<>b.subject_key or b.practice_unit_number<>b.unit_number or b.practice_topic_code<>b.topic_code or b.learn_more_path not like '/learn/ap-chemistry/unit-9/%');
  if v_route_mismatches <> 0 then raise exception 'expected 0 AP Chemistry Unit 9 route mismatches, got %', v_route_mismatches; end if;
  select count(*) into v_core_matches from app.topic_point_briefs b join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code where b.subject_key='ap_chemistry' and b.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9', '9.10', '9.11') and b.status='published' and e.status='published' and e.core_idea=b.what_it_is;
  if v_core_matches <> 0 then raise exception 'expected 0 AP Chemistry Unit 9 core_idea/what_it_is matches, got %', v_core_matches; end if;
  with new_explainers as (select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge from app.topic_explainers where subject_key='ap_chemistry' and unit_number=9 and topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9', '9.10', '9.11') and status='published'),
  field_values as (select 'mini_example_question' field_name, mini_example_question value from new_explainers union all select 'weak_answer', weak_answer from new_explainers union all select 'point_attaining_answer', point_attaining_answer from new_explainers union all select 'practice_bridge', practice_bridge from new_explainers)
  select count(*) into v_duplicate_explainer_fields from field_values fv join app.topic_explainers e on (e.mini_example_question=fv.value or e.weak_answer=fv.value or e.point_attaining_answer=fv.value or e.practice_bridge=fv.value) where e.status='published' and not (e.subject_key='ap_chemistry' and e.unit_number=9 and e.topic_code in ('9.1', '9.2', '9.3', '9.4', '9.5', '9.6', '9.7', '9.8', '9.9', '9.10', '9.11'));
  if v_duplicate_explainer_fields <> 0 then raise exception 'expected 0 AP Chemistry Unit 9 duplicate explainer fields, got %', v_duplicate_explainer_fields; end if;
end $$;

commit;
