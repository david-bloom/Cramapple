begin;

-- Add AP Chemistry Unit 4 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-26:
-- app.taxonomy_topics has 9 AP Chemistry Unit 4 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_CHEMISTRY_CED_FACT_PACK.md Unit 4 (Chemical
-- Reactions). The fact pack confirms physical versus chemical changes,
-- molecular/complete ionic/net ionic equations, particulate representations,
-- stoichiometric mole ratios, titration equivalence versus endpoint, reaction
-- type classification, Bronsted-Lowry acid-base reactions in aqueous solution,
-- redox half-reactions, and the 2025 FRQ Q6 misconception trail for mass-based
-- stoichiometric comparison and electron placement in oxidation half-reactions.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_chemistry', 4, '4.1', 'Introduction for Reactions', 'very-important', 'very-important',
   'Chemical reactions rearrange matter into new substances, while physical changes alter properties or form without changing composition.',
   'This is the sorting rule for all later reaction work. Students need to connect observations such as gas, precipitate, heat, light, or color change to evidence of reaction.',
   'You earn points by distinguishing physical from chemical change, naming evidence for reaction, and explaining what particles or substances changed rather than just listing an observation.',
   'State whether composition changes; then use the observation as evidence instead of treating the observation as the definition.',
   'Calling every color, phase, or temperature change chemical without explaining whether new substances formed.',
   '/learn/ap-chemistry/unit-4/introduction-for-reactions'),
  ('ap_chemistry', 4, '4.2', 'Net Ionic Equations', 'very-important', 'very-important',
   'Molecular, complete ionic, and net ionic equations are balanced symbolic forms that represent the same process at different levels of detail.',
   'Net ionic equations reveal the actual reacting species in solution. They also force conservation of both atoms and charge, not just coefficient matching.',
   'You earn points by dissociating strong aqueous electrolytes correctly, canceling spectator ions, preserving phases, and checking that atoms and charge balance.',
   'Write the complete ionic equation first; then cancel only species that are unchanged on both sides with the same phase and charge.',
   'Canceling a species that changes phase, formula, or charge, or balancing atoms while leaving total charge unequal.',
   '/learn/ap-chemistry/unit-4/net-ionic-equations'),
  ('ap_chemistry', 4, '4.3', 'Representations of Reactions', 'very-important', 'somewhat-important',
   'Reaction equations can be translated into particulate diagrams that show how particles combine, separate, or remain spectators.',
   'AP Chemistry often asks students to connect symbolic equations to particle-level pictures. The coefficients must become particle ratios, not decoration.',
   'You earn points by matching coefficients to particle counts, keeping spectator ions visible or absent according to representation type, and showing products consistent with the balanced equation.',
   'Start from the balanced equation; then count particles in the same ratios before drawing or interpreting the particulate model.',
   'Drawing particles that match formulas but not the balanced coefficient ratios.',
   '/learn/ap-chemistry/unit-4/representations-of-reactions'),
  ('ap_chemistry', 4, '4.4', 'Physical and Chemical Changes', 'very-important', 'somewhat-important',
   'Physical changes usually change intermolecular interactions only, while chemical changes usually involve bond breaking and bond forming.',
   'Some processes require nuanced evidence. Phase changes are physical, but dissolving salts can be argued with attention to ionic bonds and ion-dipole interactions.',
   'You earn points by naming the particle-level interaction that changes and explaining whether composition changes or only attractions between particles change.',
   'Identify what bonds or intermolecular forces are changing before labeling the process physical or chemical.',
   'Treating every separation of particles as chemical or every dissolution as automatically physical without particle-level reasoning.',
   '/learn/ap-chemistry/unit-4/physical-and-chemical-changes'),
  ('ap_chemistry', 4, '4.5', 'Stoichiometry', 'very-important', 'very-important',
   'Stoichiometry uses balanced-equation coefficients as mole ratios to calculate reactant or product amounts.',
   'This is the quantitative engine of reactions. It connects conservation of atoms to masses, solution molarity, and gas quantities.',
   'You earn points by converting given information to moles, using the balanced mole ratio, and converting to the requested units, including mass when mass comparison is asked.',
   'Use the balanced equation only after converting to moles; then convert back to the unit the prompt asks for.',
   'Stopping at a mole-ratio comparison when the question asks for a mass comparison.',
   '/learn/ap-chemistry/unit-4/stoichiometry'),
  ('ap_chemistry', 4, '4.6', 'Introduction to Titration', 'very-important', 'very-important',
   'A titration uses a known-concentration titrant that reacts quantitatively with an analyte; equivalence point and endpoint are related but not identical.',
   'Titrations turn reaction stoichiometry into concentration measurement. The equivalence point is chemical completion, while the endpoint is the observed signal.',
   'You earn points by using the balanced reaction to relate titrant and analyte moles, distinguishing endpoint from equivalence point, and solving concentration from volume and molarity data.',
   'Find moles of titrant from M and V, use the balanced mole ratio at equivalence, then divide analyte moles by analyte volume.',
   'Assuming endpoint means exact equivalence without considering the indicator or observable signal.',
   '/learn/ap-chemistry/unit-4/introduction-to-titration'),
  ('ap_chemistry', 4, '4.7', 'Types of Chemical Reactions', 'very-important', 'very-important',
   'Common reaction types include acid-base proton transfer, redox electron transfer, combustion, and precipitation from aqueous ions.',
   'Classifying reaction type tells students what conservation or driving idea to use. AP scope does not require reducing-agent/oxidizing-agent terms or broad solubility-rule memorization beyond the listed soluble ions.',
   'You earn points by identifying proton transfer, oxidation-number change, hydrocarbon combustion products, or insoluble product formation using the allowed solubility facts.',
   'Look for the reaction signature first: H+ transfer, oxidation-number change, CO2/H2O combustion products, or solid-forming ion exchange.',
   'Memorizing broad reaction labels without showing the particle or oxidation-number evidence that supports the label.',
   '/learn/ap-chemistry/unit-4/types-of-chemical-reactions'),
  ('ap_chemistry', 4, '4.8', 'Introduction to Acid-Base Reactions', 'very-important', 'very-important',
   'Bronsted-Lowry acids donate protons and Bronsted-Lowry bases accept protons in aqueous acid-base reactions.',
   'This topic sets up conjugate pairs, relative acid-base strength, and later equilibrium work. Lewis acid-base concepts are outside AP Chemistry assessment for this topic.',
   'You earn points by identifying the proton donor and acceptor, pairing each acid with its conjugate base, and reasoning from ionization when comparing relative strength.',
   'Track the transferred H+; the species that loses H+ is the acid and the species that gains H+ is the base.',
   'Calling a species an acid because it contains H without showing that it donates H+ in the reaction.',
   '/learn/ap-chemistry/unit-4/introduction-to-acid-base-reactions'),
  ('ap_chemistry', 4, '4.9', 'Oxidation-Reduction Reactions', 'very-important', 'very-important',
   'Redox reactions transfer electrons and can be balanced by separating oxidation and reduction half-reactions.',
   'Redox links reaction classification to electron accounting, electrochemistry, and mass stoichiometry. Oxidation-number changes reveal which species loses or gains electrons.',
   'You earn points by assigning oxidation numbers, identifying oxidation and reduction, placing electrons on the correct side of half-reactions, and combining half-reactions to balance charge and atoms.',
   'Write the oxidation-number changes first; then place electrons as products for oxidation and reactants for reduction.',
   'Writing the reduction direction for a species being oxidized, or omitting electrons from the half-reaction.',
   '/learn/ap-chemistry/unit-4/oxidation-reduction-reactions')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 4 Chemical Reactions; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 4: physical versus chemical changes, molecular/complete ionic/net ionic equations, particulate representations, stoichiometric mole ratios, titration equivalence versus endpoint, reaction type classification, Bronsted-Lowry acid-base reactions in aqueous solution, redox half-reactions, and 2025 FRQ Q6 misconception evidence for mass-based stoichiometric comparison and electron placement in oxidation half-reactions; batch 2026-08-26-ap-chemistry-unit4-topic-guides; author=reviewer same session, no independent human review yet',
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
  ('ap_chemistry', 4, '4.1', 'Introduction for Reactions',
   'A reaction claim is really a composition claim: chemical changes form new substances, while physical changes alter state, form, or mixture without changing identity.',
   'Students need to use evidence carefully. Gas, precipitate, heat, light, or color change can support a reaction claim, but the strongest answer connects the observation to particles being rearranged into different substances.',
   'Points come from identifying whether composition changes, naming evidence for a reaction, and describing what happened to the substances rather than just naming the visible cue.',
   'State whether composition changes; then use the observation as evidence instead of treating the observation as the definition.',
   'A clear solution forms a solid after two aqueous solutions are mixed. Why is that evidence for a chemical reaction?',
   'It is a chemical reaction because the mixture changed color and looked different.',
   'The formation of a solid precipitate suggests that ions in solution rearranged to form a new insoluble substance. The observation matters because it points to a composition change, not merely because the mixture looks different.',
   'Calling every color, phase, or temperature change chemical without explaining whether new substances formed.',
   'Back in practice, pair every observed change with the particle or substance change it supports.'),
  ('ap_chemistry', 4, '4.2', 'Net Ionic Equations',
   'Net ionic equations show only the species that actually change during an aqueous process, while still conserving atoms and total charge.',
   'Students need to move through the equation forms deliberately. The molecular equation shows formulas as written. The complete ionic equation splits strong aqueous electrolytes into ions. The net ionic equation removes spectator ions that are identical on both sides.',
   'Points come from correct dissociation, correct phases, canceling true spectators only, and checking both atom balance and charge balance in the final net ionic equation.',
   'Write the complete ionic equation first; then cancel only species that are unchanged on both sides with the same phase and charge.',
   'In a complete ionic equation, Na+(aq) appears unchanged on both sides. What should happen to it in the net ionic equation?',
   'Keep Na+ because every ion in the solution should appear in the final equation.',
   'Cancel Na+ if it has the same charge and aqueous phase on both sides. It is a spectator ion, so the net ionic equation should focus on the species that react or change phase.',
   'Canceling a species that changes phase, formula, or charge, or balancing atoms while leaving total charge unequal.',
   'In practice, put boxes around unchanged aqueous ions before writing the final net ionic equation.'),
  ('ap_chemistry', 4, '4.3', 'Representations of Reactions',
   'A balanced equation and a particulate diagram must tell the same conservation story: the same kinds and numbers of atoms are rearranged into products.',
   'Students need to translate coefficients into counts or ratios of particles. Spectator ions may be shown in a complete particulate representation but omitted from a net ionic representation. The products drawn must match formulas and charges from the balanced equation.',
   'Points come from matching coefficients, conserving atoms and charge, choosing the correct representation type, and showing particles in the proper combined or separated form.',
   'Start from the balanced equation; then count particles in the same ratios before drawing or interpreting the particulate model.',
   'A balanced equation has coefficient 2 before AgNO3 and coefficient 1 before a product. What should a particulate diagram respect?',
   'It can show one AgNO3 particle because coefficients only balance the written equation.',
   'The diagram must preserve the particle ratio represented by the coefficients. If two formula units or sets of ions are needed for every one product unit, the particulate model should show that ratio or a consistent multiple of it.',
   'Drawing particles that match formulas but not the balanced coefficient ratios.',
   'Back in practice, write the coefficient ratio above the particle sketch before deciding how many particles to draw.'),
  ('ap_chemistry', 4, '4.4', 'Physical and Chemical Changes',
   'Physical versus chemical change depends on what changes at the particle level: intermolecular attractions usually shift in physical changes, while chemical bonds usually change in chemical changes.',
   'Students need to avoid one-word rules. Melting separates particles by weakening intermolecular attractions, so composition stays the same. A reaction that forms new covalent or ionic substances changes composition. Dissolving an ionic solid can require a more careful argument because ionic attractions and ion-dipole interactions are involved.',
   'Points come from naming the interaction being broken or formed and tying that interaction to composition change or no composition change.',
   'Identify what bonds or intermolecular forces are changing before labeling the process physical or chemical.',
   'Ice melts to liquid water. Is this best classified as physical or chemical, and why?',
   'Chemical, because bonds are broken when the solid structure falls apart.',
   'It is a physical change. The water molecules remain H2O; the main change is in intermolecular attractions and particle arrangement, not in the composition of the molecules.',
   'Treating every separation of particles as chemical or every dissolution as automatically physical without particle-level reasoning.',
   'In practice, ask whether the formula identity changed before choosing the label.'),
  ('ap_chemistry', 4, '4.5', 'Stoichiometry',
   'Stoichiometry is conservation of atoms turned into calculation: balanced coefficients are mole ratios that connect measured amounts of reactants and products.',
   'Students need the full conversion path. Mass, volume of gas, or solution concentration data must first become moles. The balanced equation changes one substance amount into another. The final answer must return to the requested unit, often mass or concentration.',
   'Points come from converting to moles, using the correct coefficient ratio, identifying limiting information when needed, and converting from moles to the requested unit instead of stopping early.',
   'Use the balanced equation only after converting to moles; then convert back to the unit the prompt asks for.',
   'A reaction produces 3 mol Zn for every 2 mol Al consumed. Can you conclude Zn has the larger mass change just from 3 being greater than 2?',
   'Yes. More moles of Zn means the mass change for Zn must be greater.',
   'No. A mass comparison must include molar mass. The mole ratio says 3 mol Zn per 2 mol Al, but the masses require multiplying each mole amount by its molar mass before comparing.',
   'Stopping at a mole-ratio comparison when the question asks for a mass comparison.',
   'Back in practice, write units over every step; if the prompt asks for grams, the pathway is not finished at moles.'),
  ('ap_chemistry', 4, '4.6', 'Introduction to Titration',
   'A titration uses a measured volume of known titrant to find analyte amount through a specific balanced reaction.',
   'Students need to distinguish chemical completion from the observed signal. At the equivalence point, the analyte has reacted according to the stoichiometric ratio. The endpoint is the indicator or instrument change used to detect that point, and it may only approximate equivalence.',
   'Points come from calculating titrant moles, applying the balanced mole ratio to analyte moles, dividing by analyte volume for concentration, and using endpoint/equivalence language precisely.',
   'Find moles of titrant from M and V, use the balanced mole ratio at equivalence, then divide analyte moles by analyte volume.',
   'A titration indicator changes color just after the analyte is consumed. What is the difference between endpoint and equivalence point?',
   'They are the same because color change defines when all analyte is gone.',
   'The equivalence point is the stoichiometric point where the analyte has been consumed by the titrant. The endpoint is the observed color change used to signal that point, and it is chosen to be close to equivalence.',
   'Assuming endpoint means exact equivalence without considering the indicator or observable signal.',
   'In practice, label equivalence as stoichiometry and endpoint as observation before solving titration questions.'),
  ('ap_chemistry', 4, '4.7', 'Types of Chemical Reactions',
   'Reaction types are recognized by particle-level changes: proton transfer for acid-base, electron transfer for redox, insoluble product formation for precipitation, and CO2/H2O formation for complete hydrocarbon combustion.',
   'Students need to support the classification with evidence. Redox requires oxidation-number change. Acid-base requires proton transfer. Precipitation requires an insoluble or sparingly soluble ionic product, with AP Chemistry limiting solubility-rule memorization to the stated soluble ions.',
   'Points come from identifying the reaction signature, using allowed solubility information, and not relying on labels without evidence from formulas or oxidation numbers.',
   'Look for the reaction signature first: H+ transfer, oxidation-number change, CO2/H2O combustion products, or solid-forming ion exchange.',
   'Two aqueous ionic solutions are mixed and a solid product appears. What reaction type is supported?',
   'It must be redox because a new solid formed from ions.',
   'A solid product from mixing aqueous ions supports a precipitation reaction. To call it redox, you would need evidence of oxidation-number changes; solid formation alone is not electron transfer.',
   'Memorizing broad reaction labels without showing the particle or oxidation-number evidence that supports the label.',
   'Back in practice, underline the formula feature that proves the reaction type before naming it.'),
  ('ap_chemistry', 4, '4.8', 'Introduction to Acid-Base Reactions',
   'Bronsted-Lowry acid-base reactions are proton-transfer reactions: acids donate H+ and bases accept H+.',
   'Students need to track one proton through the equation. After an acid donates H+, it becomes its conjugate base. After a base accepts H+, it becomes its conjugate acid. Water can act as either donor or acceptor in aqueous reactions. Lewis acid-base ideas are outside this AP topic.',
   'Points come from identifying donor and acceptor, pairing conjugates correctly, and explaining relative strength from ionization behavior when asked.',
   'Track the transferred H+; the species that loses H+ is the acid and the species that gains H+ is the base.',
   'In NH3 + H2O reversible NH4+ + OH-, which species is the Bronsted-Lowry base on the reactant side?',
   'H2O is the base because it contains oxygen and becomes OH-.',
   'NH3 is the base because it accepts H+ from water to become NH4+. Water donates H+ and therefore acts as the acid in this direction.',
   'Calling a species an acid because it contains H without showing that it donates H+ in the reaction.',
   'In practice, draw an arrow for the H+ transfer before assigning acid, base, conjugate acid, and conjugate base.'),
  ('ap_chemistry', 4, '4.9', 'Oxidation-Reduction Reactions',
   'Redox reactions are electron-transfer reactions, and half-reactions make the electron accounting explicit.',
   'Students need to connect oxidation numbers to half-reaction direction. Oxidation is loss of electrons, so electrons appear as products in the oxidation half-reaction. Reduction is gain of electrons, so electrons appear as reactants in the reduction half-reaction. Balanced redox equations conserve atoms and charge.',
   'Points come from assigning oxidation states, identifying what is oxidized or reduced, placing electrons on the correct side, and scaling half-reactions so electrons cancel.',
   'Write the oxidation-number changes first; then place electrons as products for oxidation and reactants for reduction.',
   'Al(s) becomes Al3+(aq) in a redox process. Where should electrons appear in the oxidation half-reaction?',
   'Electrons should be reactants because aluminum needs electrons to become positive.',
   'Electrons are products: Al(s) -> Al3+(aq) + 3e-. Aluminum loses electrons, so this is oxidation and electron loss must appear on the product side.',
   'Writing the reduction direction for a species being oxidized, or omitting electrons from the half-reaction.',
   'Back in practice, write OIL RIG in electron-placement form: oxidation has electrons out; reduction has electrons in.')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 4 Chemical Reactions; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 4: physical versus chemical changes, molecular/complete ionic/net ionic equations, particulate representations, stoichiometric mole ratios, titration equivalence versus endpoint, reaction type classification, Bronsted-Lowry acid-base reactions in aqueous solution, redox half-reactions, and 2025 FRQ Q6 misconception evidence for mass-based stoichiometric comparison and electron placement in oxidation half-reactions; batch 2026-08-26-ap-chemistry-unit4-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 4
    and topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9')
    and status = 'published';

  if v_briefs <> 9 then
    raise exception 'expected 9 published AP Chemistry Unit 4 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_chemistry'
    and unit_number = 4
    and topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9')
    and status = 'published';

  if v_explainers <> 9 then
    raise exception 'expected 9 published AP Chemistry Unit 4 explainers, got %', v_explainers;
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
      and b.unit_number = 4
      and b.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9')
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
      and e.unit_number = 4
      and e.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 4 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_chemistry'
    and b.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 4 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_chemistry'
    and b.unit_number = 4
    and b.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-chemistry/unit-4/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 4 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_chemistry'
    and b.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 4 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_chemistry'
      and unit_number = 4
      and topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9')
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
      and e.unit_number = 4
      and e.topic_code in ('4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 4 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
