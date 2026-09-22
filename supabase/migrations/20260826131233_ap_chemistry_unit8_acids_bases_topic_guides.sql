begin;

-- Add AP Chemistry Unit 8 topic-guide pairs.
--
-- Production coverage before this migration, verified 2026-08-26:
-- app.taxonomy_topics has 11 AP Chemistry Unit 8 topics and 0 published point
-- briefs/explainers for the unit.
--
-- Grounding: docs/product/AP_CHEMISTRY_CED_FACT_PACK.md Unit 8 (Acids and Bases).
-- The fact pack confirms pH and pOH, Kw, strong acid/base ionization, weak acid/base equilibria, percent ionization, conjugate Ka/Kb relationships, neutralization and buffers, titration curves, molecular structure and acid strength, pH versus pKa, buffer properties, Henderson-Hasselbalch equation, buffer capacity, pH-sensitive solubility, and 2025 misconception evidence for pOH-to-pH conversion, titration equivalence volume, half-equivalence pKa, and Henderson-Hasselbalch ratio solving.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_chemistry', 8, '8.1', 'Introduction to Acids and Bases', 'very-important', 'very-important',
   'pH, pOH, Kw, and pKw connect hydronium and hydroxide concentrations in water.',
   'This is the quantitative language for all acid-base work, with pH 7 neutral only at 25 C.',
   'You earn points by using pH=-log[H3O+], pOH=-log[OH-], Kw, and pH+pOH=14 at 25 C only.',
   'Identify whether the prompt gives hydronium, hydroxide, pH, or pOH before converting.',
   'Assuming pH 7 is neutral at every temperature.',
   '/learn/ap-chemistry/unit-8/introduction-to-acids-and-bases'),
  ('ap_chemistry', 8, '8.2', 'pH and pOH of Strong Acids and Bases', 'very-important', 'very-important',
   'Strong acids fully ionize and strong bases fully dissociate, so initial concentration determines hydronium or hydroxide concentration.',
   'This topic is deceptively easy; 2025 evidence flags stopping at pOH instead of converting to pH as a real error.',
   'You earn points by identifying strong acid/base, accounting for hydroxide stoichiometry, and converting pOH to pH when needed.',
   'For strong bases, find [OH-] first, then convert pOH to pH if the prompt asks for pH.',
   'Reporting pOH as pH after a strong-base calculation.',
   '/learn/ap-chemistry/unit-8/ph-and-poh-of-strong-acids-and-bases'),
  ('ap_chemistry', 8, '8.3', 'Weak Acid and Base Equilibria', 'very-important', 'very-important',
   'Weak acids and bases partially ionize, so Ka, Kb, pKa, pKb, and percent ionization describe equilibrium extent.',
   'Weak systems require equilibrium thinking rather than full-dissociation shortcuts. Conjugate pairs satisfy Kw=KaKb.',
   'You earn points by writing the correct equilibrium expression, solving for equilibrium concentrations, and connecting stronger acid/base to larger Ka/Kb or smaller pKa/pKb.',
   'Write the acid or base ionization equation first; then build the equilibrium expression from products over reactants.',
   'Treating a weak acid as fully ionized just because an initial concentration is given.',
   '/learn/ap-chemistry/unit-8/weak-acid-and-base-equilibria'),
  ('ap_chemistry', 8, '8.4', 'Acid-Base Reactions and Buffers', 'very-important', 'very-important',
   'Acid-base reactions are proton-transfer stoichiometry followed by pH reasoning from the species left after reaction.',
   'The major species after reaction determines whether pH comes from excess strong acid/base, a buffer, or conjugate hydrolysis.',
   'You earn points by doing mole stoichiometry first, identifying excess or equimolar conditions, and choosing the correct pH method.',
   'React acid and base moles first; then decide what species control pH after the reaction.',
   'Starting with Henderson-Hasselbalch before checking whether both buffer components remain.',
   '/learn/ap-chemistry/unit-8/acid-base-reactions-and-buffers'),
  ('ap_chemistry', 8, '8.5', 'Acid-Base Titrations', 'very-important', 'very-important',
   'A titration curve shows pH changes as titrant volume is added, with equivalence and half-equivalence points carrying key information.',
   '2025 evidence flags wrong equivalence volume and confusing equivalence pH with half-equivalence pKa.',
   'You earn points by using equivalence-point moles, identifying half-equivalence pH=pKa for weak titrations, and using major species to predict equivalence pH.',
   'Read the equivalence volume first; half of that volume gives pKa only for a weak acid/base titration.',
   'Using the total graph volume or equivalence-point pH as pKa.',
   '/learn/ap-chemistry/unit-8/acid-base-titrations'),
  ('ap_chemistry', 8, '8.6', 'Molecular Structure of Acids and Bases', 'very-important', 'very-important',
   'Molecular structure affects acid/base strength through conjugate-base stability and conjugate-acid weakness.',
   'Structure arguments explain why some acids are strong, why carboxylic acids are weak, and why electronegativity, induction, and resonance matter.',
   'You earn points by relating stronger acid to more stable conjugate base and using structural features to justify that stability.',
   'Compare the conjugate bases, not just the acids, when explaining relative acid strength.',
   'Saying more H atoms automatically means a stronger acid.',
   '/learn/ap-chemistry/unit-8/molecular-structure-of-acids-and-bases'),
  ('ap_chemistry', 8, '8.7', 'pH and pKa', 'very-important', 'very-important',
   'Comparing pH with pKa predicts whether the acid or base form of a conjugate pair dominates.',
   'This is the shortcut behind indicators, buffers, and biological acid-base form predictions.',
   'You earn points by using pH<pKa for acid form dominance and pH>pKa for base form dominance, and by choosing indicators near equivalence pH.',
   'Compare pH to pKa before deciding protonated or deprotonated form.',
   'Reversing the dominance rule when pH is above pKa.',
   '/learn/ap-chemistry/unit-8/ph-and-pka'),
  ('ap_chemistry', 8, '8.8', 'Properties of Buffers', 'very-important', 'very-important',
   'Buffers resist pH change because they contain appreciable conjugate acid and conjugate base that consume added base or acid.',
   'This explains buffer action without relying on a formula first. A buffer needs both members of a conjugate pair in significant amounts.',
   'You earn points by identifying both buffer components and explaining how each responds to added acid or base.',
   'Name the conjugate acid and conjugate base, then state which one reacts with the added stress.',
   'Calling any weak acid solution a buffer even when its conjugate base is absent.',
   '/learn/ap-chemistry/unit-8/properties-of-buffers'),
  ('ap_chemistry', 8, '8.9', 'Henderson-Hasselbalch Equation', 'very-important', 'very-important',
   'Henderson-Hasselbalch relates buffer pH to pKa and the conjugate base to acid ratio.',
   'The equation makes buffer ratio reasoning quantitative, but AP does not assess derivation or pH change calculations after acid/base additions.',
   'You earn points by using pH=pKa+log([A-]/[HA]) and solving the ratio with base over acid.',
   'Isolate [A-]/[HA] as 10^(pH-pKa), not with natural logs or a negative exponent.',
   'Solving the ratio as 10^-(pH-pKa) or using ln instead of log base 10.',
   '/learn/ap-chemistry/unit-8/henderson-hasselbalch-equation'),
  ('ap_chemistry', 8, '8.10', 'Buffer Capacity', 'very-important', 'very-important',
   'Buffer capacity is the amount of acid or base a buffer can absorb before pH changes substantially.',
   'Capacity increases with total buffer concentration and depends on which conjugate member is more abundant.',
   'You earn points by separating pH, which depends on ratio, from capacity, which depends on amounts.',
   'Hold the ratio and total concentration ideas separately: ratio sets pH; amount sets capacity.',
   'Saying dilution that preserves ratio leaves buffer capacity unchanged.',
   '/learn/ap-chemistry/unit-8/buffer-capacity'),
  ('ap_chemistry', 8, '8.11', 'pH and Solubility', 'very-important', 'very-important',
   'Salt solubility can depend on pH when an ion reacts as a weak acid, weak base, or hydroxide.',
   'This is qualitative Le Chatelier reasoning applied to solubility; AP excludes solubility-as-a-function-of-pH computations.',
   'You earn points by identifying the ion affected by acid or base and predicting whether dissolution is favored.',
   'Ask whether H+ or OH- removes one dissolved ion; if so, more solid can dissolve.',
   'Trying to compute pH-dependent solubility when qualitative reasoning is requested.',
   '/learn/ap-chemistry/unit-8/ph-and-solubility')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 8 Acids and Bases; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 8: pH and pOH, Kw, strong acid/base ionization, weak acid/base equilibria, percent ionization, conjugate Ka/Kb relationships, neutralization and buffers, titration curves, molecular structure and acid strength, pH versus pKa, buffer properties, Henderson-Hasselbalch equation, buffer capacity, pH-sensitive solubility, and 2025 misconception evidence for pOH-to-pH conversion, titration equivalence volume, half-equivalence pKa, and Henderson-Hasselbalch ratio solving; batch 2026-08-26-ap-chemistry-unit8-topic-guides; author=reviewer same session, no independent human review yet',
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
  ('ap_chemistry', 8, '8.1', 'Introduction to Acids and Bases',
   'Acid-base calculations start with hydronium, hydroxide, and water autoionization.',
   'Students need to know H+ and H3O+ are accepted conventions, with hydronium preferred. Kw changes with temperature, so pH+pOH=14 and neutral pH=7 are 25 C relationships.',
   'Points come from choosing the right logarithmic relationship and temperature condition.',
   'Identify whether the prompt gives hydronium, hydroxide, pH, or pOH before converting.',
   'At 25 C, if pOH is 3.00, what is pH?',
   'pH is 3.00 because pOH and pH are the same scale.',
   'pH is 11.00 because pH + pOH = 14.00 at 25 C.',
   'Assuming pH 7 is neutral at every temperature.',
   'Back in practice, write pH + pOH = 14 only after confirming 25 C.'),
  ('ap_chemistry', 8, '8.2', 'pH and pOH of Strong Acids and Bases',
   'Strong species make pH calculations stoichiometric before logarithmic.',
   'Students need to know strong acid and base lists and account for Group II hydroxides producing two OH- per formula unit. The final answer must match the requested quantity.',
   'Points come from full dissociation, log use, and final pH/pOH conversion.',
   'For strong bases, find [OH-] first, then convert pOH to pH if the prompt asks for pH.',
   'A 0.010 M NaOH solution at 25 C has pOH 2.00. What is pH?',
   'pH is 2.00 because that came from the concentration.',
   'pH is 12.00. NaOH gives [OH-]=0.010 M, so pOH=2.00 and pH=14.00-2.00.',
   'Reporting pOH as pH after a strong-base calculation.',
   'Back in practice, underline whether the prompt asks pH or pOH.'),
  ('ap_chemistry', 8, '8.3', 'Weak Acid and Base Equilibria',
   'Weak acid/base calculations are equilibrium problems.',
   'Students need to distinguish initial concentration from equilibrium ion concentration. Percent ionization compares ionized amount to initial amount, and conjugate acid-base strengths are linked by Kw.',
   'Points come from correct Ka/Kb setup and avoiding strong-species assumptions.',
   'Write the acid or base ionization equation first; then build the equilibrium expression from products over reactants.',
   'If a weak acid has initial concentration 0.10 M, is [H3O+] automatically 0.10 M?',
   'Yes, acids produce the same concentration of H3O+.',
   'No. A weak acid partially ionizes, so [H3O+] must be found from the acid equilibrium.',
   'Treating a weak acid as fully ionized just because an initial concentration is given.',
   'Back in practice, label strong or weak before using any concentration as [H3O+].'),
  ('ap_chemistry', 8, '8.4', 'Acid-Base Reactions and Buffers',
   'Neutralization and buffer problems are before-and-after problems.',
   'Students need to separate reaction completion from equilibrium pH. Strong with strong uses excess H+ or OH-. Weak with strong can form a buffer, leave excess strong reagent, or leave conjugate species at equivalence.',
   'Points come from post-reaction species identification.',
   'React acid and base moles first; then decide what species control pH after the reaction.',
   'A weak acid and strong base are mixed, and weak acid remains with its conjugate base. What type of solution forms?',
   'A neutral solution because acid and base reacted.',
   'A buffer forms because appreciable weak acid and conjugate base are both present.',
   'Starting with Henderson-Hasselbalch before checking whether both buffer components remain.',
   'Back in practice, make a mole table before naming the pH method.'),
  ('ap_chemistry', 8, '8.5', 'Acid-Base Titrations',
   'Titration curves are stoichiometry plus equilibrium landmarks.',
   'Students need to read the graph carefully. Equivalence volume gives moles analyte from moles titrant. Half-equivalence gives pH=pKa for weak systems. Equivalence pH depends on the conjugate species for weak titrations.',
   'Points come from using the right graph point for the right purpose.',
   'Read the equivalence volume first; half of that volume gives pKa only for a weak acid/base titration.',
   'If weak acid equivalence occurs at 20.0 mL titrant, where is pH=pKa read?',
   'At 20.0 mL because that is the equivalence point.',
   'At 10.0 mL, the half-equivalence point, where [HA]=[A-] and pH=pKa.',
   'Using the total graph volume or equivalence-point pH as pKa.',
   'Back in practice, mark equivalence volume and half-equivalence volume separately.'),
  ('ap_chemistry', 8, '8.6', 'Molecular Structure of Acids and Bases',
   'Acid strength follows from how stable the conjugate base is after proton loss.',
   'Students need structural language: electronegativity, inductive effects, resonance, and weak conjugate bases for strong acids. Common weak bases include ammonia-like nitrogen bases and carboxylates.',
   'Points come from a causal structure-to-strength explanation.',
   'Compare the conjugate bases, not just the acids, when explaining relative acid strength.',
   'Why can resonance make an acid stronger?',
   'Because resonance means the acid has more bonds.',
   'Resonance can stabilize the conjugate base by spreading negative charge, making proton loss more favorable and the acid stronger.',
   'Saying more H atoms automatically means a stronger acid.',
   'Back in practice, draw or name the conjugate base before comparing acid strengths.'),
  ('ap_chemistry', 8, '8.7', 'pH and pKa',
   'pH versus pKa is a protonation-state comparison.',
   'Students need to interpret pKa as the pH where acid and base forms are equal. Below pKa, the protonated acid form dominates. Above pKa, the deprotonated base form dominates.',
   'Points come from correct form prediction and indicator choice.',
   'Compare pH to pKa before deciding protonated or deprotonated form.',
   'If pH is greater than pKa, which form dominates?',
   'The acid form, because there is more pH available.',
   'The base form dominates because conditions are less proton-rich than the acid pKa point.',
   'Reversing the dominance rule when pH is above pKa.',
   'Back in practice, write low pH means more protonated.'),
  ('ap_chemistry', 8, '8.8', 'Properties of Buffers',
   'A buffer is a chemical pair with two defensive reactions.',
   'Students need to say the acid member neutralizes added base and the base member neutralizes added acid. Large amounts relative to the added stress keep the ratio and pH from changing much.',
   'Points come from component identification and response mechanism.',
   'Name the conjugate acid and conjugate base, then state which one reacts with the added stress.',
   'Why does a HA/A- buffer resist added acid?',
   'HA reacts with the acid and removes it.',
   'A- reacts with added H+ to form HA, reducing the pH change.',
   'Calling any weak acid solution a buffer even when its conjugate base is absent.',
   'Back in practice, draw two arrows: added acid hits base form, added base hits acid form.'),
  ('ap_chemistry', 8, '8.9', 'Henderson-Hasselbalch Equation',
   'Buffer pH is pKa adjusted by the log of base form over acid form.',
   'Students need to set up the ratio direction correctly. If pH is above pKa, base form exceeds acid form; if below, acid form exceeds base form.',
   'Points come from correct substitution and ratio isolation.',
   'Isolate [A-]/[HA] as 10^(pH-pKa), not with natural logs or a negative exponent.',
   'If pH-pKa = 1.00, what is [A-]/[HA]?',
   '0.10, because the acid is stronger.',
   '10. The equation gives log([A-]/[HA])=1.00, so the ratio is 10^1.',
   'Solving the ratio as 10^-(pH-pKa) or using ln instead of log base 10.',
   'Back in practice, after solving, check whether the ratio direction matches pH versus pKa.'),
  ('ap_chemistry', 8, '8.10', 'Buffer Capacity',
   'Capacity depends on how much conjugate acid/base is available, not just their ratio.',
   'Students need to know that increasing both buffer components by the same factor keeps pH the same but increases capacity. More acid form gives greater capacity for added base; more base form gives greater capacity for added acid.',
   'Points come from distinguishing pH from capacity.',
   'Hold the ratio and total concentration ideas separately: ratio sets pH; amount sets capacity.',
   'Two buffers have the same [A-]/[HA] ratio, but one is ten times more concentrated. Which has greater capacity?',
   'They have the same capacity because their pH is the same.',
   'The more concentrated buffer has greater capacity because it has more conjugate acid and base available to neutralize added acid or base.',
   'Saying dilution that preserves ratio leaves buffer capacity unchanged.',
   'Back in practice, use ratio for pH and total moles for capacity.'),
  ('ap_chemistry', 8, '8.11', 'pH and Solubility',
   'pH can shift solubility equilibria by consuming or producing ions.',
   'Students need to reason from the dissolution equation. Acid can increase solubility of salts containing basic anions or hydroxide by consuming the anion, lowering Q, and allowing more solid to dissolve.',
   'Points come from the shift mechanism, not a memorized acidic/basic salt rule.',
   'Ask whether H+ or OH- removes one dissolved ion; if so, more solid can dissolve.',
   'Why can acid increase the solubility of a metal hydroxide?',
   'Because acid directly breaks the solid apart by force.',
   'H+ reacts with OH-, lowering [OH-]. That lowers Q for the dissolution equilibrium, so more solid dissolves to restore Ksp.',
   'Trying to compute pH-dependent solubility when qualitative reasoning is requested.',
   'Back in practice, identify which ion is removed by pH change before predicting solubility.')
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
  'cramapple-authored; new coverage 2026-08-26 for AP Chemistry Unit 8 Acids and Bases; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 8: pH and pOH, Kw, strong acid/base ionization, weak acid/base equilibria, percent ionization, conjugate Ka/Kb relationships, neutralization and buffers, titration curves, molecular structure and acid strength, pH versus pKa, buffer properties, Henderson-Hasselbalch equation, buffer capacity, pH-sensitive solubility, and 2025 misconception evidence for pOH-to-pH conversion, titration equivalence volume, half-equivalence pKa, and Henderson-Hasselbalch ratio solving; batch 2026-08-26-ap-chemistry-unit8-topic-guides; author=reviewer same session, no independent human review yet',
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
  select count(*) into v_briefs from app.topic_point_briefs where subject_key='ap_chemistry' and unit_number=8 and topic_code in ('8.1', '8.2', '8.3', '8.4', '8.5', '8.6', '8.7', '8.8', '8.9', '8.10', '8.11') and status='published';
  if v_briefs <> 11 then raise exception 'expected 11 published AP Chemistry Unit 8 briefs, got %', v_briefs; end if;
  select count(*) into v_explainers from app.topic_explainers where subject_key='ap_chemistry' and unit_number=8 and topic_code in ('8.1', '8.2', '8.3', '8.4', '8.5', '8.6', '8.7', '8.8', '8.9', '8.10', '8.11') and status='published';
  if v_explainers <> 11 then raise exception 'expected 11 published AP Chemistry Unit 8 explainers, got %', v_explainers; end if;
  select count(*) into v_pairing_orphans from (
    select b.subject_key,b.topic_code from app.topic_point_briefs b left join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code and e.status='published' where b.subject_key='ap_chemistry' and b.unit_number=8 and b.topic_code in ('8.1', '8.2', '8.3', '8.4', '8.5', '8.6', '8.7', '8.8', '8.9', '8.10', '8.11') and b.status='published' and e.topic_code is null
    union all
    select e.subject_key,e.topic_code from app.topic_explainers e left join app.topic_point_briefs b on b.subject_key=e.subject_key and b.topic_code=e.topic_code and b.status='published' where e.subject_key='ap_chemistry' and e.unit_number=8 and e.topic_code in ('8.1', '8.2', '8.3', '8.4', '8.5', '8.6', '8.7', '8.8', '8.9', '8.10', '8.11') and e.status='published' and b.topic_code is null
  ) orphans;
  if v_pairing_orphans <> 0 then raise exception 'expected 0 AP Chemistry Unit 8 pairing orphans, got %', v_pairing_orphans; end if;
  select count(*) into v_unit_mismatches from app.topic_point_briefs b join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code where b.subject_key='ap_chemistry' and b.topic_code in ('8.1', '8.2', '8.3', '8.4', '8.5', '8.6', '8.7', '8.8', '8.9', '8.10', '8.11') and b.status='published' and e.status='published' and b.unit_number<>e.unit_number;
  if v_unit_mismatches <> 0 then raise exception 'expected 0 AP Chemistry Unit 8 unit mismatches, got %', v_unit_mismatches; end if;
  select count(*) into v_route_mismatches from app.topic_point_briefs b where b.subject_key='ap_chemistry' and b.unit_number=8 and b.topic_code in ('8.1', '8.2', '8.3', '8.4', '8.5', '8.6', '8.7', '8.8', '8.9', '8.10', '8.11') and b.status='published' and (b.practice_subject_key<>b.subject_key or b.practice_unit_number<>b.unit_number or b.practice_topic_code<>b.topic_code or b.learn_more_path not like '/learn/ap-chemistry/unit-8/%');
  if v_route_mismatches <> 0 then raise exception 'expected 0 AP Chemistry Unit 8 route mismatches, got %', v_route_mismatches; end if;
  select count(*) into v_core_matches from app.topic_point_briefs b join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code where b.subject_key='ap_chemistry' and b.topic_code in ('8.1', '8.2', '8.3', '8.4', '8.5', '8.6', '8.7', '8.8', '8.9', '8.10', '8.11') and b.status='published' and e.status='published' and e.core_idea=b.what_it_is;
  if v_core_matches <> 0 then raise exception 'expected 0 AP Chemistry Unit 8 core_idea/what_it_is matches, got %', v_core_matches; end if;
  with new_explainers as (select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge from app.topic_explainers where subject_key='ap_chemistry' and unit_number=8 and topic_code in ('8.1', '8.2', '8.3', '8.4', '8.5', '8.6', '8.7', '8.8', '8.9', '8.10', '8.11') and status='published'),
  field_values as (select 'mini_example_question' field_name, mini_example_question value from new_explainers union all select 'weak_answer', weak_answer from new_explainers union all select 'point_attaining_answer', point_attaining_answer from new_explainers union all select 'practice_bridge', practice_bridge from new_explainers)
  select count(*) into v_duplicate_explainer_fields from field_values fv join app.topic_explainers e on (e.mini_example_question=fv.value or e.weak_answer=fv.value or e.point_attaining_answer=fv.value or e.practice_bridge=fv.value) where e.status='published' and not (e.subject_key='ap_chemistry' and e.unit_number=8 and e.topic_code in ('8.1', '8.2', '8.3', '8.4', '8.5', '8.6', '8.7', '8.8', '8.9', '8.10', '8.11'));
  if v_duplicate_explainer_fields <> 0 then raise exception 'expected 0 AP Chemistry Unit 8 duplicate explainer fields, got %', v_duplicate_explainer_fields; end if;
end $$;

commit;
