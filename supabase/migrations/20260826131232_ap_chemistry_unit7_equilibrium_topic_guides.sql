begin;

-- Add AP Chemistry Unit 7 topic-guide pairs.
--
-- Production coverage before this migration, verified 2026-08-26:
-- app.taxonomy_topics has 12 AP Chemistry Unit 7 topics and 0 published point
-- briefs/explainers for the unit.
--
-- Grounding: docs/product/AP_CHEMISTRY_CED_FACT_PACK.md Unit 7 (Equilibrium).
-- The fact pack confirms reversible processes, dynamic equilibrium, Q and K expressions, solids and pure liquids excluded from equilibrium expressions, K magnitude, algebraic K manipulations, ICE-style concentration prediction, particulate equilibrium representations, Le Chatelier stress reasoning, Q returning to K, Ksp, common-ion effect, and 2025 misconception evidence for Ksp expressions, Q/Ksp comparison direction, and common-ion mechanism reasoning.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_chemistry', 7, '7.1', 'Introduction to Equilibrium', 'very-important', 'very-important',
   'Equilibrium is dynamic: forward and reverse processes continue at equal rates while macroscopic amounts stay constant.',
   'This idea prevents students from treating equilibrium as a stopped reaction. Many visible processes are reversible even when no further observable change occurs.',
   'You earn points by stating both equal rates and constant amounts, and by distinguishing dynamic equilibrium from reaction completion.',
   'Name the forward and reverse processes, then compare their rates rather than saying the reaction stopped.',
   'Saying equilibrium means all reaction has stopped.',
   '/learn/ap-chemistry/unit-7/introduction-to-equilibrium'),
  ('ap_chemistry', 7, '7.2', 'Direction of Reversible Reactions', 'very-important', 'very-important',
   'A reversible system moves in the net direction of the faster process until forward and reverse rates become equal.',
   'Direction reasoning sets up Q versus K and Le Chatelier work. It is a rate comparison, not a guess from which side has more material.',
   'You earn points by comparing forward and reverse rates and identifying when net change ceases.',
   'Ask which rate is larger now; the system shifts in that net direction until rates match.',
   'Choosing shift direction from the larger concentration side only.',
   '/learn/ap-chemistry/unit-7/direction-of-reversible-reactions'),
  ('ap_chemistry', 7, '7.3', 'Reaction Quotient and Equilibrium Constant', 'very-important', 'very-important',
   'Q and K use the same expression form, but Q describes any moment and K describes equilibrium.',
   'This is the central equilibrium decision tool. Solids and pure liquids are excluded because their effective concentrations do not change with amount.',
   'You earn points by writing the expression with correct powers, excluding solids and pure liquids, and comparing Q with K.',
   'Write the expression from gases or aqueous species only; then compare Q to K.',
   'Including a solid in Ksp or putting the coefficient on the wrong species.',
   '/learn/ap-chemistry/unit-7/reaction-quotient-and-equilibrium-constant'),
  ('ap_chemistry', 7, '7.4', 'Calculating the Equilibrium Constant', 'very-important', 'very-important',
   'K can be calculated from measured equilibrium concentrations or partial pressures substituted into the correct expression.',
   'Measured equilibrium data become meaningful only when substituted with the balanced-expression powers.',
   'You earn points by confirming the system is at equilibrium, substituting equilibrium values, and preserving powers from coefficients.',
   'Write the K expression first, then substitute equilibrium values only.',
   'Using initial concentrations as if they were equilibrium concentrations.',
   '/learn/ap-chemistry/unit-7/calculating-the-equilibrium-constant'),
  ('ap_chemistry', 7, '7.5', 'Magnitude of the Equilibrium Constant', 'very-important', 'very-important',
   'A large K means products are favored at equilibrium; a small K means reactants are favored.',
   'K magnitude gives a quick qualitative picture before any calculation. It does not say the reaction is fast.',
   'You earn points by interpreting K relative to 1 and separating extent from rate.',
   'Compare K to 1, then state whether products or reactants dominate at equilibrium.',
   'Saying a large K means the reaction happens quickly.',
   '/learn/ap-chemistry/unit-7/magnitude-of-the-equilibrium-constant'),
  ('ap_chemistry', 7, '7.6', 'Properties of the Equilibrium Constant', 'very-important', 'very-important',
   'Changing the written reaction changes K: reverse inverts K, scaling raises K to a power, and adding reactions multiplies K values.',
   'This mirrors reaction algebra and prevents invalid averaging or adding of equilibrium constants.',
   'You earn points by applying the same equation manipulation to K before combining values.',
   'Manipulate the reaction first; then transform K to match that exact reaction.',
   'Adding K values when reactions are added.',
   '/learn/ap-chemistry/unit-7/properties-of-the-equilibrium-constant'),
  ('ap_chemistry', 7, '7.7', 'Calculating Equilibrium Concentrations', 'very-important', 'very-important',
   'Equilibrium concentrations can be predicted from initial amounts, balanced changes, and K.',
   'This is where Q direction and stoichiometric change tables become useful.',
   'You earn points by comparing Q to K, setting up changes with coefficients, and solving for equilibrium values.',
   'Use Q to decide shift direction, then build the change row from balanced coefficients.',
   'Changing every concentration by the same amount instead of coefficient-scaled amounts.',
   '/learn/ap-chemistry/unit-7/calculating-equilibrium-concentrations'),
  ('ap_chemistry', 7, '7.8', 'Representations of Equilibrium', 'very-important', 'very-important',
   'Particulate diagrams can represent equilibrium by showing stable reactant and product particle ratios consistent with K.',
   'This connects symbolic K to visual particle counts. A diagram at equilibrium should match relative abundance implied by K.',
   'You earn points by counting particles, connecting ratios to K magnitude, and showing ongoing reversible change if asked.',
   'Count reactant and product particles before interpreting which side is favored.',
   'Using a picture with equal amounts to represent every equilibrium.',
   '/learn/ap-chemistry/unit-7/representations-of-equilibrium'),
  ('ap_chemistry', 7, '7.9', 'Introduction to Le Chatelier''s Principle', 'very-important', 'very-important',
   'Le Chatelier reasoning predicts how an equilibrium system responds to a stress by opposing the disturbance.',
   'Students use this to predict changes in concentration, color, pH, pressure, and temperature. Temperature changes are special because they change K.',
   'You earn points by identifying the stress, predicting the shift, and stating the measurable result.',
   'Name the stress first; then state which direction consumes what was added or replaces what was removed.',
   'Treating every stress as changing K, including concentration changes.',
   '/learn/ap-chemistry/unit-7/introduction-to-le-chateliers-principle'),
  ('ap_chemistry', 7, '7.10', 'Reaction Quotient and Le Chatelier''s Principle', 'very-important', 'very-important',
   'A stress takes Q away from K, and the system shifts until Q equals K again; temperature changes K itself.',
   'This unifies Le Chatelier predictions with equilibrium expressions. It also prevents treating all shifts as rule memorization.',
   'You earn points by explaining whether Q or K changed and how the shift restores equality.',
   'After a stress, decide whether Q changed, K changed, or both; then predict how Q moves back toward K.',
   'Saying concentration changes alter K instead of Q.',
   '/learn/ap-chemistry/unit-7/reaction-quotient-and-le-chateliers-principle'),
  ('ap_chemistry', 7, '7.11', 'Introduction to Solubility Equilibria', 'very-important', 'very-important',
   'Ksp describes the equilibrium between a sparingly soluble ionic solid and its dissolved ions.',
   'Solubility calculations and precipitation predictions depend on writing the correct ion-product expression.',
   'You earn points by writing Ksp without the solid, using ion coefficients as powers, and connecting molar solubility to ion concentrations.',
   'Write the dissolution equation first; then build Ksp from dissolved ions only.',
   'Putting the solid in Ksp or forgetting to square an ion concentration from a coefficient of 2.',
   '/learn/ap-chemistry/unit-7/introduction-to-solubility-equilibria'),
  ('ap_chemistry', 7, '7.12', 'Common-Ion Effect', 'very-important', 'very-important',
   'A common ion lowers solubility by shifting a dissolution equilibrium toward the solid.',
   'This is Le Chatelier applied to Ksp, and it works best when students reason from the ion being added or removed.',
   'You earn points by identifying the common ion, predicting the shift, and explaining whether solubility increases or decreases.',
   'Find the ion shared with the salt; then decide whether the equilibrium forms more solid or dissolves more solid.',
   'Memorizing a rule without explaining the ion-level shift.',
   '/learn/ap-chemistry/unit-7/common-ion-effect')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 7 Equilibrium; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 7: reversible processes, dynamic equilibrium, Q and K expressions, solids and pure liquids excluded from equilibrium expressions, K magnitude, algebraic K manipulations, ICE-style concentration prediction, particulate equilibrium representations, Le Chatelier stress reasoning, Q returning to K, Ksp, common-ion effect, and 2025 misconception evidence for Ksp expressions, Q/Ksp comparison direction, and common-ion mechanism reasoning; batch 2026-08-26-ap-chemistry-unit7-topic-guides; author=reviewer same session, no independent human review yet',
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
  ('ap_chemistry', 7, '7.1', 'Introduction to Equilibrium',
   'Dynamic equilibrium means equal opposing rates, not inactivity.',
   'Students need examples such as evaporation-condensation, dissolution-precipitation, acid-base proton transfer, and redox electron transfer. The AP move is to describe ongoing particle-level change despite no visible change.',
   'Points come from identifying the reversible pair, stating equal rates at equilibrium, and avoiding completion language.',
   'Name the forward and reverse processes, then compare their rates rather than saying the reaction stopped.',
   'A covered beaker reaches constant vapor amount. Has evaporation stopped?',
   'Yes, because the amount of vapor is no longer changing.',
   'No. Evaporation and condensation continue, but their rates are equal, so the vapor amount remains constant.',
   'Saying equilibrium means all reaction has stopped.',
   'Back in practice, write forward rate = reverse rate before describing equilibrium.'),
  ('ap_chemistry', 7, '7.2', 'Direction of Reversible Reactions',
   'A reversible reaction shifts according to unequal forward and reverse rates.',
   'Students need to say equilibrium is approached when the faster direction consumes its favored side until opposing rates balance. More reactant or product alone does not prove the direction without rate or Q/K information.',
   'Points come from naming the net direction and ending condition: equal rates at dynamic equilibrium.',
   'Ask which rate is larger now; the system shifts in that net direction until rates match.',
   'If the forward rate is larger than the reverse rate, what happens next?',
   'The reaction must already be at equilibrium because both directions exist.',
   'There is net forward change. Product amount increases until the forward and reverse rates become equal.',
   'Choosing shift direction from the larger concentration side only.',
   'Back in practice, compare rates before comparing amounts.'),
  ('ap_chemistry', 7, '7.3', 'Reaction Quotient and Equilibrium Constant',
   'Q moves toward K as a system approaches equilibrium.',
   'Students need to build Kc, Kp, or Ksp expressions from balanced coefficients and include only species whose concentrations or partial pressures change. The AP boundary excludes Kc-Kp conversion.',
   'Points come from correct expression setup, correct exponent use, and correct Q/K direction.',
   'Write the expression from gases or aqueous species only; then compare Q to K.',
   'For AgCl(s) reversible Ag+(aq)+Cl-(aq), should AgCl(s) appear in Ksp?',
   'Yes, because AgCl is the reactant in the equation.',
   'No. The solid is excluded; Ksp = [Ag+][Cl-]. Only dissolved ions appear in the expression.',
   'Including a solid in Ksp or putting the coefficient on the wrong species.',
   'Back in practice, cross out solids and pure liquids before writing K or Q.'),
  ('ap_chemistry', 7, '7.4', 'Calculating the Equilibrium Constant',
   'Calculating K is expression-first arithmetic.',
   'Students need to distinguish initial, change, and equilibrium amounts. Values measured at equilibrium go directly into K; values before equilibrium require an equilibrium setup first.',
   'Points come from expression accuracy, correct substitution, and unitless or contextual interpretation rather than random number plugging.',
   'Write the K expression first, then substitute equilibrium values only.',
   'Can initial concentrations be substituted directly into K?',
   'Yes, any concentrations from the reaction can be used.',
   'No. K describes equilibrium composition, so only equilibrium concentrations or pressures belong in the K expression.',
   'Using initial concentrations as if they were equilibrium concentrations.',
   'Back in practice, label every value initial or equilibrium before substitution.'),
  ('ap_chemistry', 7, '7.5', 'Magnitude of the Equilibrium Constant',
   'K magnitude describes equilibrium composition, not reaction speed.',
   'Students need to read K as a ratio of product terms to reactant terms. Very large K means the product side dominates at equilibrium; very small K means little product is present.',
   'Points come from product/reactant favoring language and avoiding kinetics claims.',
   'Compare K to 1, then state whether products or reactants dominate at equilibrium.',
   'If K = 1.0 x 10^8, what is favored at equilibrium?',
   'Reactants, because the number is hard to reach.',
   'Products are favored because K is much greater than 1. This says nothing by itself about how fast equilibrium is reached.',
   'Saying a large K means the reaction happens quickly.',
   'Back in practice, translate K size into extent, not rate.'),
  ('ap_chemistry', 7, '7.6', 'Properties of the Equilibrium Constant',
   'K follows reaction algebra, but not by simple addition.',
   'Students need to remember that reversing changes products and reactants, so K becomes reciprocal. Multiplying coefficients changes exponents, so K is raised to that factor. Adding equations multiplies their K values.',
   'Points come from matching the K operation to the reaction operation.',
   'Manipulate the reaction first; then transform K to match that exact reaction.',
   'If a reaction is reversed, what happens to K?',
   'K changes sign like Delta H.',
   'K becomes 1/K because products and reactants switch places in the equilibrium expression.',
   'Adding K values when reactions are added.',
   'Back in practice, write the changed equation before changing K.'),
  ('ap_chemistry', 7, '7.7', 'Calculating Equilibrium Concentrations',
   'Equilibrium concentration problems combine direction, stoichiometry, and K.',
   'Students need to decide whether the reaction moves forward or reverse, then express concentration changes in coefficient ratios. The final values must satisfy K.',
   'Points come from a consistent setup more than from isolated arithmetic.',
   'Use Q to decide shift direction, then build the change row from balanced coefficients.',
   'If Q<K, which direction is favored as equilibrium is approached?',
   'Reverse, because Q is smaller and needs to get bigger by making reactants.',
   'Forward. Product terms must increase relative to reactant terms so Q rises toward K.',
   'Changing every concentration by the same amount instead of coefficient-scaled amounts.',
   'Back in practice, write Q<K means forward before making an ICE table.'),
  ('ap_chemistry', 7, '7.8', 'Representations of Equilibrium',
   'Equilibrium diagrams are particle-count evidence for K and composition.',
   'Students need to translate K magnitude into relative particle abundance without implying that particles stop reacting. Diagrams may show more products, more reactants, or comparable amounts depending on K.',
   'Points come from matching particle ratios to the written equilibrium and K value.',
   'Count reactant and product particles before interpreting which side is favored.',
   'A diagram at equilibrium shows many product particles and few reactant particles. What does that suggest about K?',
   'K must be exactly 1 because equilibrium was reached.',
   'K is likely greater than 1 because products are more abundant than reactants at equilibrium.',
   'Using a picture with equal amounts to represent every equilibrium.',
   'Back in practice, count before concluding. Equilibrium does not mean equal counts.'),
  ('ap_chemistry', 7, '7.9', 'Introduction to Le Chatelier''s Principle',
   'A stressed equilibrium shifts to reduce the effect of the stress.',
   'Students need to analyze the specific disturbance: adding species, removing species, changing volume, diluting, or changing temperature. Only temperature changes K; concentration and pressure stresses change Q first.',
   'Points come from a causal explanation, not a memorized left/right statement.',
   'Name the stress first; then state which direction consumes what was added or replaces what was removed.',
   'If product is removed from an equilibrium mixture, which way does the system shift?',
   'Toward reactants because product is lower.',
   'Toward products, replacing some of what was removed and moving back toward equilibrium.',
   'Treating every stress as changing K, including concentration changes.',
   'Back in practice, write what changed and what shift would counter it.'),
  ('ap_chemistry', 7, '7.10', 'Reaction Quotient and Le Chatelier''s Principle',
   'Le Chatelier shifts can be described as Q returning to K.',
   'Students need to connect a concentration stress to the reaction quotient. Adding reactant usually lowers or raises Q depending on expression placement, causing a shift that restores Q=K. Temperature changes the equilibrium constant because heat is part of the thermochemical balance.',
   'Points come from Q/K language and correct stress classification.',
   'After a stress, decide whether Q changed, K changed, or both; then predict how Q moves back toward K.',
   'If a reactant is added at constant temperature, does K change?',
   'Yes, K changes because the mixture composition changed.',
   'No. At constant temperature K is unchanged. The added reactant changes Q, and the system shifts until Q again equals K.',
   'Saying concentration changes alter K instead of Q.',
   'Back in practice, write constant T means K constant before using Le Chatelier.'),
  ('ap_chemistry', 7, '7.11', 'Introduction to Solubility Equilibria',
   'Solubility equilibrium is a reversible dissolution-precipitation balance.',
   'Students need to connect a saturated solution to Ksp. The solid is present but excluded from the expression; dissolved ion concentrations appear with powers from coefficients.',
   'Points come from expression setup and careful coefficient-to-exponent use.',
   'Write the dissolution equation first; then build Ksp from dissolved ions only.',
   'For CaF2(s) reversible Ca2+ + 2F-, what is the F- exponent in Ksp?',
   'One, because F- is one type of ion.',
   'Two. The coefficient 2 becomes the exponent, so Ksp = [Ca2+][F-]^2.',
   'Putting the solid in Ksp or forgetting to square an ion concentration from a coefficient of 2.',
   'Back in practice, copy coefficients into exponents after excluding the solid.'),
  ('ap_chemistry', 7, '7.12', 'Common-Ion Effect',
   'The common-ion effect changes solubility by changing Q relative to Ksp.',
   'Students need to reason both directions. Adding a common ion increases Q and favors precipitation; removing a common ion can allow more solid to dissolve. Acid consuming a basic ion is a common reverse case.',
   'Points come from the mechanism, not just the phrase common ion.',
   'Find the ion shared with the salt; then decide whether the equilibrium forms more solid or dissolves more solid.',
   'If acid removes OH- from a saturated metal hydroxide solution, what happens to solubility?',
   'It decreases because acid is an added substance.',
   'Solubility increases. Removing OH- lowers Q, so more solid dissolves to restore Ksp.',
   'Memorizing a rule without explaining the ion-level shift.',
   'Back in practice, ask whether the common ion is added or removed before predicting solubility.')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 7 Equilibrium; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 7: reversible processes, dynamic equilibrium, Q and K expressions, solids and pure liquids excluded from equilibrium expressions, K magnitude, algebraic K manipulations, ICE-style concentration prediction, particulate equilibrium representations, Le Chatelier stress reasoning, Q returning to K, Ksp, common-ion effect, and 2025 misconception evidence for Ksp expressions, Q/Ksp comparison direction, and common-ion mechanism reasoning; batch 2026-08-26-ap-chemistry-unit7-topic-guides; author=reviewer same session, no independent human review yet',
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
  select count(*) into v_briefs from app.topic_point_briefs where subject_key='ap_chemistry' and unit_number=7 and topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5', '7.6', '7.7', '7.8', '7.9', '7.10', '7.11', '7.12') and status='published';
  if v_briefs <> 12 then raise exception 'expected 12 published AP Chemistry Unit 7 briefs, got %', v_briefs; end if;
  select count(*) into v_explainers from app.topic_explainers where subject_key='ap_chemistry' and unit_number=7 and topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5', '7.6', '7.7', '7.8', '7.9', '7.10', '7.11', '7.12') and status='published';
  if v_explainers <> 12 then raise exception 'expected 12 published AP Chemistry Unit 7 explainers, got %', v_explainers; end if;
  select count(*) into v_pairing_orphans from (
    select b.subject_key,b.topic_code from app.topic_point_briefs b left join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code and e.status='published' where b.subject_key='ap_chemistry' and b.unit_number=7 and b.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5', '7.6', '7.7', '7.8', '7.9', '7.10', '7.11', '7.12') and b.status='published' and e.topic_code is null
    union all
    select e.subject_key,e.topic_code from app.topic_explainers e left join app.topic_point_briefs b on b.subject_key=e.subject_key and b.topic_code=e.topic_code and b.status='published' where e.subject_key='ap_chemistry' and e.unit_number=7 and e.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5', '7.6', '7.7', '7.8', '7.9', '7.10', '7.11', '7.12') and e.status='published' and b.topic_code is null
  ) orphans;
  if v_pairing_orphans <> 0 then raise exception 'expected 0 AP Chemistry Unit 7 pairing orphans, got %', v_pairing_orphans; end if;
  select count(*) into v_unit_mismatches from app.topic_point_briefs b join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code where b.subject_key='ap_chemistry' and b.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5', '7.6', '7.7', '7.8', '7.9', '7.10', '7.11', '7.12') and b.status='published' and e.status='published' and b.unit_number<>e.unit_number;
  if v_unit_mismatches <> 0 then raise exception 'expected 0 AP Chemistry Unit 7 unit mismatches, got %', v_unit_mismatches; end if;
  select count(*) into v_route_mismatches from app.topic_point_briefs b where b.subject_key='ap_chemistry' and b.unit_number=7 and b.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5', '7.6', '7.7', '7.8', '7.9', '7.10', '7.11', '7.12') and b.status='published' and (b.practice_subject_key<>b.subject_key or b.practice_unit_number<>b.unit_number or b.practice_topic_code<>b.topic_code or b.learn_more_path not like '/learn/ap-chemistry/unit-7/%');
  if v_route_mismatches <> 0 then raise exception 'expected 0 AP Chemistry Unit 7 route mismatches, got %', v_route_mismatches; end if;
  select count(*) into v_core_matches from app.topic_point_briefs b join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code where b.subject_key='ap_chemistry' and b.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5', '7.6', '7.7', '7.8', '7.9', '7.10', '7.11', '7.12') and b.status='published' and e.status='published' and e.core_idea=b.what_it_is;
  if v_core_matches <> 0 then raise exception 'expected 0 AP Chemistry Unit 7 core_idea/what_it_is matches, got %', v_core_matches; end if;
  with new_explainers as (select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge from app.topic_explainers where subject_key='ap_chemistry' and unit_number=7 and topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5', '7.6', '7.7', '7.8', '7.9', '7.10', '7.11', '7.12') and status='published'),
  field_values as (select 'mini_example_question' field_name, mini_example_question value from new_explainers union all select 'weak_answer', weak_answer from new_explainers union all select 'point_attaining_answer', point_attaining_answer from new_explainers union all select 'practice_bridge', practice_bridge from new_explainers)
  select count(*) into v_duplicate_explainer_fields from field_values fv join app.topic_explainers e on (e.mini_example_question=fv.value or e.weak_answer=fv.value or e.point_attaining_answer=fv.value or e.practice_bridge=fv.value) where e.status='published' and not (e.subject_key='ap_chemistry' and e.unit_number=7 and e.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5', '7.6', '7.7', '7.8', '7.9', '7.10', '7.11', '7.12'));
  if v_duplicate_explainer_fields <> 0 then raise exception 'expected 0 AP Chemistry Unit 7 duplicate explainer fields, got %', v_duplicate_explainer_fields; end if;
end $$;

commit;
