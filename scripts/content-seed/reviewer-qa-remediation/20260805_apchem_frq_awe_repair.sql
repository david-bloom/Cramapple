-- AP Chemistry FRQ AWE blocker repairs, 2026-08-05.
-- User explicitly approved this exact bulk Production workflow after risk notice.
-- Repairs the 24 remaining AP Chemistry FRQs with item-specific edits, adds owner/admin
-- QA approvals to repaired successor versions, and publishes only versions that
-- pass FRQ structural QA gates in Production project pcntajvbdfqhbeewmdry.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-frq-awe-repair-20260805'));

create temporary table repair_targets (
  content_key text primary key,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

insert into repair_targets values
('apchem-frq-l-003','2daa7469-8164-40fe-8785-3709c2905c76'::uuid,gen_random_uuid()),
('apchem-frq-l-004','376ccf97-0d85-4b8d-b27e-2dc6bdb4b84f'::uuid,gen_random_uuid()),
('apchem-frq-l-005','a93fba3c-b245-42ec-8b81-c487a258e0d8'::uuid,gen_random_uuid()),
('apchem-frq-l-010','c7d0b236-116f-4fb9-a9e5-83b02b905e4a'::uuid,gen_random_uuid()),
('apchem-frq-l-011','2ebb3115-6e1e-4893-be91-5aa483ab0f81'::uuid,gen_random_uuid()),
('apchem-frq-l-016','05a46666-b14f-4256-b01e-111578addad0'::uuid,gen_random_uuid()),
('apchem-frq-l-017','8cf7f418-433c-489f-ac4d-67c7b0322801'::uuid,gen_random_uuid()),
('apchem-frq-l-021','9a411301-dcf0-47c6-85fd-f3427376e72c'::uuid,gen_random_uuid()),
('apchem-frq-l-023','5c034216-aaee-49ee-8d63-e1851ef9e077'::uuid,gen_random_uuid()),
('apchem-frq-l-025','95c2c744-6b85-4dc7-8690-446aa7b7924e'::uuid,gen_random_uuid()),
('apchem-frq-l-026','385390ae-e01c-4593-9c77-ee1b9796d2be'::uuid,gen_random_uuid()),
('apchem-frq-l-028','ede9b866-6fd6-4dbd-a98d-fc49a0ccddfa'::uuid,gen_random_uuid()),
('apchem-sfrq-002','3cf2653a-f5f9-4170-a5bb-b16dddbace89'::uuid,gen_random_uuid()),
('apchem-sfrq-004','a7752ca3-bf91-4443-9020-810322c2e013'::uuid,gen_random_uuid()),
('apchem-sfrq-007','a42af79b-ee99-46fe-8c67-62c626271cd6'::uuid,gen_random_uuid()),
('apchem-sfrq-009','e6c1fb73-53a3-4a55-818b-4b8fab8cd79d'::uuid,gen_random_uuid()),
('apchem-sfrq-016','c4cdd5c7-c5e8-4742-aa02-be5824b41774'::uuid,gen_random_uuid()),
('apchem-sfrq-019','93333373-83fd-484f-b23c-d2cb393d27d8'::uuid,gen_random_uuid()),
('apchem-sfrq-021','60967354-4c9f-41a5-99b2-36287eee7e72'::uuid,gen_random_uuid()),
('apchem-sfrq-023','012b4d4c-84fb-4a74-9bea-e0631886acd4'::uuid,gen_random_uuid()),
('apchem-sfrq-030','eec85f23-5ef9-481f-b1d0-002dff2730b9'::uuid,gen_random_uuid()),
('apchem-sfrq-032','9e7d4a68-c6b3-47e5-93b9-c245fe25eeca'::uuid,gen_random_uuid()),
('apchem-sfrq-034','4cef2674-9b09-4236-86dd-d1cd83221fc0'::uuid,gen_random_uuid()),
('apchem-sfrq-038','6f52a84f-0c1b-445a-ad3e-7174462cf9c3'::uuid,gen_random_uuid());

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where content_key=t.content_key and item_type='frq'
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
      and status='reviewed_approved'
      and not exists (
        select 1 from app.content_item_versions newer
        where newer.content_item_id=app.content_item_versions.content_item_id
          and newer.version_num>app.content_item_versions.version_num
      )
    order by version_num desc, created_at desc
    limit 1
    for update;

    v_new := gen_random_uuid();

    update app.content_review_assignments
    set status='skipped'
    where content_item_version_id=v_old.id
      and assignment_purpose='subject_review'
      and status in ('pending','in_progress');

    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-05 AP Chemistry FRQ AWE repair',
        'qa_source_decision_id',t.source_decision_id
      ),
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.frq_criteria (
      content_item_version_id,criterion_key,points_possible,learner_facing_text,
      evidence_requirements,accepted_variants,minimum_fix
    )
    select v_new,criterion_key,points_possible,learner_facing_text,
           evidence_requirements,accepted_variants,minimum_fix
    from app.frq_criteria
    where content_item_version_id=v_old.id;

    insert into repaired values (t.content_key,v_old.id,v_new,t.source_decision_id,t.assignment_id);
  end loop;
end $$;

-- Stem/canonical edits from item-specific reviewer notes.
update app.content_item_versions civ set stem=replace(replace(stem,'Calculate moles using PV=nRT and explain a likely high-pressure deviation.','Calculate moles using PV=nRT and explain a likely high-pressure deviation, distinguishing attraction-dominated cases from repulsion/finite-volume-dominated cases.'),'identifying the compressibility factor PV/nRT as the measured variable while holding temperature constant.','explaining how Z = PV/(nRT) would be calculated from measured pressure and volume at several pressures while temperature and the independently determined amount of gas remain constant.'), canonical_answer_1='n=PV/RT=(0.950 atm)(1.80 L)/[(0.08206 L atm mol^-1 K^-1)(298 K)]=0.0699 mol. At sufficiently high pressure, finite molecular volume and repulsive effects can dominate, giving Z>1 and causing n_ideal=PV/RT to overestimate the true amount. In attraction-dominated cases where Z<1, n_ideal underestimates the true amount.' from repaired r where r.content_key='apchem-frq-l-003' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'identifying the dried precipitate mass as the measured variable and the filtration and drying time as the variable held constant.','identifying the dried precipitate mass as the measured variable, drying to constant mass, and controlled washing/filtering conditions.'), canonical_answer_1='0.00300 mol AgCl; Ag+(aq) + Cl-(aq) -> AgCl(s). Verify gravimetrically by filtering, washing, drying to constant mass, cooling, weighing AgCl, and dividing by molar mass. Incomplete drying gives a high calculated yield; precipitate loss gives a low calculated yield.' from repaired r where r.content_key='apchem-frq-l-004' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'net forward progress','net reaction rate') || E'\n\nAssume temperature and other experimental conditions remain constant and initial rates are measured before product accumulation is significant.' from repaired r where r.content_key='apchem-frq-l-005' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'layers of metal cations slide','planes of positive metal ion cores move while remaining attracted to delocalized electrons') from repaired r where r.content_key='apchem-frq-l-010' and civ.id=r.new_version_id;
update app.frq_criteria fc set criterion_key=case criterion_key when 'd1' then 'a1' when 'd2' then 'b1' when 'd3' then 'c1' when 'd4' then 'd1' when 'd5' then 'e1' when 'd6' then 'f1' else criterion_key end from repaired r where r.content_key='apchem-frq-l-010' and fc.content_item_version_id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'greater force','greater momentum transfer per collision') || E'\n\nAssume the gas behaves ideally.' from repaired r where r.content_key='apchem-frq-l-011' and civ.id=r.new_version_id;
update app.frq_criteria fc set criterion_key=case criterion_key when 'a1' then 'part-a' when 'a2' then 'part-b' when 'a3' then 'part-c' when 'a4' then 'part-d' when 'a5' then 'part-e' else criterion_key end from repaired r where r.content_key='apchem-frq-l-011' and fc.content_item_version_id=r.new_version_id;
update app.content_item_versions civ set stem=stem || E'\n\nUse molar masses from the periodic table and include units and appropriate significant figures.' from repaired r where r.content_key='apchem-frq-l-016' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'color-change (pKa) range','indicator transition range') || E'\n\nFor indicator selection, estimate the equivalence-point pH and compare the indicator transition range with the steep region of the titration curve. Use 25 C, Ka = 1.8 x 10^-5, OH-, and C2H3O2- notation.' from repaired r where r.content_key='apchem-frq-l-017' and civ.id=r.new_version_id;
update app.frq_criteria fc set criterion_key=case criterion_key when 'a1' then 'part-a' when 'a2' then 'part-b' when 'a3' then 'part-c' when 'a4' then 'part-d' when 'a5' then 'part-e' when 'a6' then 'part-f' when 'a7' then 'part-g' when 'a8' then 'part-h' else criterion_key end from repaired r where r.content_key='apchem-frq-l-017' and fc.content_item_version_id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'but claims this means the reaction itself becomes exothermic in the forward direction shown in the target equation.','and claims that this single reversed value proves the overall target reaction is exothermic. Evaluate both the sign reversal for reaction 3 and whether that term alone determines the sign of the target reaction.') from repaired r where r.content_key='apchem-frq-l-021' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=stem || E'\n\nWhen interpreting Kc, distinguish a product-favored equilibrium from the actual composition of this particular mixture, and state whether Kc changes after a concentration disturbance at constant temperature.' from repaired r where r.content_key='apchem-frq-l-023' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'pH at 30.0 mL is 12.10','pH at 30.0 mL is 11.96') || E'\n\nAssume 25 C and Kw = 1.0 x 10^-14.' from repaired r where r.content_key='apchem-frq-l-025' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=stem || E'\n\nAssume 25 C when using Kw = 1.0 x 10^-14. For equal acid/base capacity comparisons, hold total buffer concentration constant.' from repaired r where r.content_key='apchem-frq-l-026' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=stem || E'\n\nUse the Nernst equation, not Le Chatelier reasoning alone, to justify cell-potential changes caused by concentration changes.' from repaired r where r.content_key='apchem-frq-l-028' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'(b) Explain how the same calculation would change after adding a small amount of acid.','(b) Explain how the concentration ratio and pH change after adding a specified small amount of strong acid, assuming the buffer capacity is not exceeded.') from repaired r where r.content_key='apchem-sfrq-002' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(replace(stem,'molar absorptivity ε','calibration slope epsilon*b'),'original undiluted concentration','concentration calculated in Part (a)') || E'\n\nThe cuvette path length is 1.00 cm, so the numerical slope equals epsilon for this cell.' from repaired r where r.content_key='apchem-sfrq-004' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(replace(replace(stem,'ΔG','Delta G standard'),'ΔH','Delta H standard'),'ΔS','Delta S standard') || E'\n\nUse consistent units by converting kJ to J before calculating the crossover temperature; at the crossover Delta G standard = 0.' from repaired r where r.content_key='apchem-sfrq-007' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=stem || E'\n\nNeglect water autoionization. Reserve percent ionization for the requested approximation check rather than the initial pH calculation.' from repaired r where r.content_key='apchem-sfrq-009' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'three organic compounds with similar molar masses','three organic compounds with related carbon skeletons; acetone and 1-propanol have especially similar molar masses') || E'\n\nStandardize boiling temperatures in degrees C.' from repaired r where r.content_key='apchem-sfrq-016' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'Identify the solute and solvent.','Identify the solute and solvent, and justify your choices.') from repaired r where r.content_key='apchem-sfrq-019' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'spectator ions present in the mixture','spectator ions in the reaction') from repaired r where r.content_key='apchem-sfrq-021' and civ.id=r.new_version_id;
update app.frq_criteria fc set criterion_key=case criterion_key when 'a1' then 'part-a' when 'a2' then 'part-b' when 'a3' then 'part-c' else criterion_key end from repaired r where r.content_key='apchem-sfrq-021' and fc.content_item_version_id=r.new_version_id;
update app.content_item_versions civ set stem=stem || E'\n\nIn the redox balancing, show the oxidation and reduction half-reactions separately, then multiply, cancel electrons, and verify atoms and charge.' from repaired r where r.content_key='apchem-sfrq-023' and civ.id=r.new_version_id;
update app.content_item_versions civ set stimulus=replace(stimulus,'rigid container','closed container fitted with a movable piston'), stem=replace(stem,'decreasing the volume','decreasing the volume at constant temperature') || E'\n\nUse added thermal energy language for the temperature change in this exothermic equilibrium.' from repaired r where r.content_key='apchem-sfrq-030' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=stem || E'\n\nAssume 25 C and additive solution volumes. If sketching the curve, label axes and the 40.0 mL equivalence point.' from repaired r where r.content_key='apchem-sfrq-032' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=replace(stem,'justify your answer without doing a full calculation.','justify your answer qualitatively without doing a full calculation.') || E'\n\nUse pKa, A-, and [A-]/[HA] notation.' from repaired r where r.content_key='apchem-sfrq-034' and civ.id=r.new_version_id;
update app.content_item_versions civ set stem=stem || E'\n\nFor molten calcium chloride, the cathode half-reaction may be written Ca2+ + 2e- -> Ca(l). Include units and appropriate significant figures.' from repaired r where r.content_key='apchem-sfrq-038' and civ.id=r.new_version_id;

create temporary table criterion_repairs (
  content_key text not null,
  criterion_key text not null,
  learner_facing_text text not null,
  evidence_requirements text not null,
  minimum_fix text not null
) on commit drop;

insert into criterion_repairs values
('apchem-frq-l-003','c1','Calculates, rather than directly measures, Z = PV/(nRT) from measured pressure and volume at several pressures while temperature and amount of gas are held constant.','Requires P and V measurements across pressures, constant T and n, and explicit calculation of Z = PV/(nRT).','Replace any claim that Z is directly measured with calculated from measured P and V, with T and independently known n controlled.'),
('apchem-frq-l-003','c2','States that the true amount of gas must be determined independently, for example from mass and molar mass, before Z can be calculated.','Recognizes that using PV = nRT to obtain n would make the nonideality test circular.','Identify an independent way to determine n, such as mass divided by molar mass.'),
('apchem-frq-l-004','part-c','Describes collecting AgCl by filtration, washing to remove soluble ions, drying to constant mass, cooling in a desiccator, weighing, and converting mass to moles using molar mass.','Credit filtration/collection, washing, drying to constant mass and cooling before weighing, and conversion of measured AgCl mass to moles.','Use drying to constant mass and controlled washing/filtering conditions rather than fixed filtration time alone.'),
('apchem-frq-l-004','part-d','Predicts the direction of a systematic error; incomplete drying gives a high mass and high calculated yield, while precipitate loss gives a low calculated yield.','Accepts incomplete drying as high, or transfer/filtration loss as low, when the direction is correctly tied to measured AgCl mass.','Tie the named systematic error to whether measured AgCl mass, and therefore moles, are too high or too low.'),
('apchem-frq-l-005','c1','States that the trial design must keep temperature and all non-varied conditions constant while measuring initial rates.','Requires constant temperature/conditions and initial-rate data taken before product accumulation significantly affects the rate.','Specify constant temperature and initial-rate measurement conditions.'),
('apchem-frq-l-005','d1','Explains that initial-rate data establish an empirical rate law but do not by themselves establish a molecular mechanism.','Distinguishes empirical rate-law evidence from proof of an elementary-step mechanism.','Replace mechanism claims with the conclusion that the data support the empirical rate law only.'),
('apchem-frq-l-010','d1','Explains that brass is harder than pure copper because substitutional Zn atoms disturb the Cu lattice and impede dislocation motion, with local bonding/size effects contributing.','Requires lattice disruption and inhibited dislocation movement, not only a vague different-atom-size claim.','Mention substitutional Zn atoms impeding dislocation movement in the copper lattice.'),
('apchem-frq-l-010','e1','Explains that planes of positive metal ion cores can move while remaining attracted to delocalized electrons.','Uses metal ion cores and delocalized electrons to explain ductility/malleability.','Replace layers of metal cations slide with planes of positive ion cores moving while electron attraction persists.'),
('apchem-frq-l-011','part-d','Explains that heating increases average kinetic energy and molecular speed, causing more frequent wall collisions and greater momentum transfer per collision, increasing pressure.','Requires kinetic-energy/speed, collision frequency, momentum transfer, and pressure connection; avoid greater force as the sole explanation.','Use momentum transfer and collision frequency language rather than only saying collisions have greater force.'),
('apchem-frq-l-011','part-e','States that the gas is assumed to behave ideally for use of PV = nRT.','Explicitly names ideal-gas behavior as an assumption.','Add the ideal-gas assumption.'),
('apchem-frq-l-016','a1','Calculates moles of Al and Fe2O3 separately using molar masses and units.','Award independent credit for each correct mole calculation with units and appropriate significant figures.','Show both mole calculations separately, with molar masses or periodic-table values.'),
('apchem-frq-l-016','a2','Identifies the limiting reagent using any valid comparison, including required/available mole ratios or possible product amounts.','Accepts equivalent limiting-reagent methods, not only one ratio format.','Support the limiting-reagent conclusion with a valid stoichiometric comparison.'),
('apchem-frq-l-016','a4','Identifies Al as the excess reagent before calculating the mass of Al remaining.','Requires naming the excess reagent and then calculating remaining amount/mass.','State that Al is in excess before computing its remaining mass.'),
('apchem-frq-l-017','part-e','Estimates the equivalence-point pH, about 8.8 at 25 C, and selects an indicator whose transition range lies in the steep pH rise near equivalence.','Requires more than pH > 7; supports phenolphthalein with the equivalence-region pH/transition range.','Estimate the equivalence-point pH and connect phenolphthalein to the steep titration-curve region.'),
('apchem-frq-l-017','part-h','Explains that buffer capacity is strongest near half-equivalence because comparable acid and conjugate base amounts are present; near equivalence little weak acid remains, so pH rises sharply.','Requires comparable HA/A- near half-equivalence and loss of buffer capacity near equivalence.','Tie the small pH change to comparable buffer components and the sharp rise to weak acid depletion.'),
('apchem-frq-l-021','c1','Evaluates both errors: reversing reaction 3 changes deltaH from -1103.9 kJ/mol to +1103.9 kJ/mol, making the reversed reaction endothermic, and that term alone does not determine the target reaction sign.','Requires the sign reversal, the endothermic interpretation of the reversed reaction, and the fact that the overall sign comes from the full Hess sum.','State that the reversed reaction is endothermic and that the total Hess sum determines the target sign.'),
('apchem-frq-l-023','a3','Interprets Kc as indicating a product-favored equilibrium and uses the given equilibrium concentrations to show this mixture contains more SO3 than reactants.','Avoids claiming Kc > 1 always guarantees every starting mixture is mostly product; uses the actual concentrations for this mixture.','Say product-favored equilibrium, then support the particular mixture conclusion from the stated concentrations.'),
('apchem-frq-l-023','a5','Separately predicts the shift, explains the comparison of Q and K, and states that Kc is unchanged by a concentration disturbance at constant temperature.','Requires shift direction, Q/K reasoning, and unchanged Kc as distinct pieces of evidence.','Include all three: shift, explanation, and Kc unchanged.'),
('apchem-frq-l-025','g1','Selects phenolphthalein because its transition range lies within the steep pH rise near the weak-acid/strong-base equivalence point.','Do not require the transition range to exactly bracket the equivalence-point pH; it must fall in the steep equivalence region.','Use transition range lies within the steep rise rather than exact bracketing.'),
('apchem-frq-l-026','c1','Accepts NH3 + H+ -> NH4+ or NH3 + H3O+ -> NH4+ + H2O and describes NH4+ as a weak acid without requiring barely dissociates.','Credits either acid-neutralization form and scientifically correct weak-acid language.','Allow hydronium-form notation and avoid requiring the phrase barely dissociates.'),
('apchem-frq-l-026','e1','States that the buffer can neutralize added strong acid up to but not including 0.30 mol while retaining both buffer components; at exactly 0.30 mol all NH3 is consumed.','Requires the boundary distinction between before 0.30 mol and exactly 0.30 mol HCl.','Clarify that buffering is lost at exactly 0.30 mol strong acid added.'),
('apchem-frq-l-026','g1','Explains that equal concentrations at the same total buffer concentration give equal stoichiometric capacities for added acid and base.','Requires equal concentration and same total buffer concentration for equal acid/base capacity.','Add the same-total-buffer-concentration condition.'),
('apchem-frq-l-028','e2','Uses the Nernst equation to justify how changing ion concentration changes cell potential; Le Chatelier direction alone is not sufficient for the voltage claim.','Requires a quantitative or semi-quantitative Nernst-equation connection to voltage.','Use the Nernst equation as the voltage justification.'),
('apchem-sfrq-002','part-a','Calculates the initial pH from Henderson-Hasselbalch using log base 10 and the concentration ratio as an activity-ratio approximation.','Requires pH calculation, base-10 log, and concentration-ratio approximation.','Separate the initial pH calculation from later acid-addition reasoning.'),
('apchem-sfrq-002','part-b','For a specified small acid addition, explains that A- neutralizes added H+ to form HA, decreasing [A-]/[HA] and lowering pH while buffer capacity remains.','Assesses a distinct acid-response idea rather than repeating the original pH derivation.','Use neutralization and concentration-ratio change after acid addition.'),
('apchem-sfrq-004','part-a','Uses the calibration slope epsilon*b; because b = 1.00 cm, the numerical slope equals epsilon for this cell.','Distinguishes calibration slope epsilon*b from molar absorptivity epsilon.','State that slope equals epsilon*b and only equals epsilon numerically because b = 1.00 cm.'),
('apchem-sfrq-004','part-d','Interprets the concentration calculated in Part (a), not an undefined original undiluted stock concentration.','Uses the Part (a) concentration consistently with the defined measurement.','Replace original undiluted concentration with concentration calculated in Part (a).'),
('apchem-sfrq-007','part-a','Converts Delta H from kJ to J before using T = Delta H / Delta S.','Requires unit conversion to consistent J units.','Show kJ-to-J conversion before calculating the crossover temperature.'),
('apchem-sfrq-007','part-c','States that at exactly the crossover temperature, Delta G = 0, so neither direction is thermodynamically favored under the stated standard conditions.','Requires thermodynamic crossover language at exactly 292 K.','Clarify that Delta G = 0 at the crossover, not favorable in either direction.'),
('apchem-sfrq-009','part-a','Calculates [H+] and pH without prematurely stating percent ionization when that is assessed separately.','Keeps pH calculation distinct from the percent-ionization check.','Remove the percent-ionization conclusion from the Part (a) criterion.'),
('apchem-sfrq-009','part-b','Uses Ka = x^2/(C-x), the small-x approximation, and states the assumption that x is less than 5% of C; water autoionization is neglected.','Requires equilibrium setup, 5% assumption, and neglect of water autoionization.','State the 5% condition and water-autoionization assumption.'),
('apchem-sfrq-009','part-d','Solves the quadratic at C = 1.0 x 10^-4 M, selects the chemically meaningful positive root, calculates percent ionization, and explains why the approximation fails.','Separates quadratic setup/root selection/numerical result/percent ionization/failure explanation even within the criterion text.','Include the positive root and percent ionization when rejecting the approximation.'),
('apchem-sfrq-016','a3','Predicts 1-chloropropane has a higher boiling point than propane because replacing H with Cl creates a molecular dipole and increases molar mass/polarizability, strengthening London dispersion as well as dipole-dipole forces.','Requires both dipole-dipole and stronger dispersion/polarizability effects.','Do not attribute the boiling-point increase only to dipole-dipole attractions.'),
('apchem-sfrq-019','c1','Identifies NaCl as the solute and water as the solvent, with justification if the prompt asks for it.','Matches the prompt requirement; justification is creditable when requested but not required if the prompt only asks identify.','Align rubric and prompt on whether justification is required.'),
('apchem-sfrq-021','part-a','Writes a balanced molecular equation with correct formulas and phase labels.','Requires both balancing and phase labels.','Include correct phase labels in the balanced molecular equation.'),
('apchem-sfrq-021','part-b','Writes the complete ionic equation by dissociating soluble ionic compounds, canceling spectator ions appropriately, and preserving correct charges and states.','Credits dissociation, spectator cancellation, and charges/states as separate expected features.','Split the net-ionic work into dissociation, cancellation, and charges/states.'),
('apchem-sfrq-021','part-c','Identifies spectator ions in the reaction as ions unchanged from reactants to products in the complete ionic equation.','Uses spectator ions in the reaction, not merely ions present in the mixture.','Phrase spectator status relative to unchanged ions across the reaction.'),
('apchem-sfrq-023','a2','Writes separately balanced oxidation and reduction half-reactions with atoms and charges balanced.','Requires both half-reactions and atom/charge balance.','Separate oxidation and reduction half-reaction credit.'),
('apchem-sfrq-023','a3','Combines half-reactions by multiplying the iron half-reaction by five, canceling electrons, and verifying the net charge balance.','Requires electron cancellation and total charge check.','Show the multiplier, electron cancellation, and charge balance.'),
('apchem-sfrq-023','a4','Identifies MnO4- as the oxidizing agent because it accepts electrons and is reduced.','Requires a brief electron-transfer justification.','Justify oxidizing agent by electron gain/reduction.'),
('apchem-sfrq-030','a2','For a closed container with a movable piston at constant temperature, decreasing volume shifts equilibrium right because the product side has fewer gas moles, but K is unchanged.','Requires constant temperature and distinguishes equilibrium shift from K change.','Specify constant temperature for the compression case.'),
('apchem-sfrq-030','a1','Explains the temperature effect by treating the exothermic reaction as responding to added thermal energy; increasing temperature shifts left and decreases K.','Uses thermal-energy reasoning without treating heat as an ordinary chemical species.','Describe added thermal energy for the exothermic equilibrium.'),
('apchem-sfrq-032','c1','Describes or sketches a strong-acid/strong-base titration curve with low initial pH, gradual rise, a steep nearly vertical rise centered at 40.0 mL, and basic pH after equivalence; axes and equivalence point are labeled if sketched.','Requires labeled axes/equivalence point for sketches and expected curve features.','Add curve features and labels, including the 40.0 mL equivalence point.'),
('apchem-sfrq-034','b1','Determines qualitatively that HA predominates when pH < pKa, without requiring a full logarithmic ratio calculation.','Accepts the qualitative Henderson-Hasselbalch relationship for the prompt as worded.','Do not require calculating [A-]/[HA] when the prompt says without full calculation.'),
('apchem-sfrq-034','b2','If a ratio is provided, correctly relates pH - pKa to log([A-]/[HA]); otherwise a qualitative pH < pKa justification is sufficient.','Keeps the exact ratio optional unless the prompt requests it.','Make the numerical ratio optional for this prompt.'),
('apchem-sfrq-038','c1','Converts moles of electrons to moles of calcium using the 2:1 electron-to-calcium ratio, then converts moles of calcium to mass with units and appropriate significant figures.','Requires both mole conversion and mass conversion, with units/significant figures.','Separate calcium mole conversion from mass conversion in the expected evidence.');

update app.frq_criteria fc
set learner_facing_text=cr.learner_facing_text,
    evidence_requirements=cr.evidence_requirements,
    minimum_fix=cr.minimum_fix
from repaired r
join criterion_repairs cr on cr.content_key=r.content_key
where fc.content_item_version_id=r.new_version_id
  and fc.criterion_key=cr.criterion_key;

update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||coalesce(civ.canonical_answer_1,'')||E'\n'||
  coalesce((select string_agg(f.criterion_key||':'||f.points_possible::text||':'||coalesce(f.learner_facing_text,'')||':'||coalesce(f.evidence_requirements,'')||':'||coalesce(f.minimum_fix,''), E'\n' order by f.criterion_key)
            from app.frq_criteria f where f.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select assignment_id,new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','frq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,tutor_decision,decision_payload,
  decision_hash,created_by
)
select r.assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       r.source_decision_id,'tutor_question',1,
       coalesce(src.difficulty_label,'Medium'),false,array[]::text[],
       'AP Chemistry FRQ approve-with-edits repair applied and owner QA verified.',
       src.topic_selections,'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_frq_awe_repair','source_review_decision_id',r.source_decision_id,'qa_date','2026-08-05'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_frq_awe_repair','source_review_decision_id',r.source_decision_id,'qa_date','2026-08-05')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_decisions src on src.content_review_decision_id=r.source_decision_id;

create temporary table qa_blocked as
select r.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when (select count(*) from app.frq_criteria f where f.content_item_version_id=civ.id)=0 then 'criteria count'
    when exists (select 1 from app.frq_criteria f where f.content_item_version_id=civ.id and (f.points_possible<=0 or nullif(trim(f.learner_facing_text),'') is null or nullif(trim(coalesce(f.evidence_requirements,'')),'') is null or nullif(trim(coalesce(f.minimum_fix,'')),'') is null)) then 'criteria completeness'
    when coalesce((select sum(f.points_possible) from app.frq_criteria f where f.content_item_version_id=civ.id),0)<=0 then 'points total'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table publish_set on commit drop as
select r.content_key, r.new_version_id
from repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    updated_at=now()
from publish_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from publish_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published',
    review_status='question_review_approved',
    approved_by=coalesce(civ.approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
    approved_at=coalesce(civ.approved_at,now()),
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from publish_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from publish_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n int;
begin
  select count(*) into n from repaired;
  if n<>24 then raise exception 'expected 24 repaired FRQs, got %', n; end if;

  select count(*) into n from publish_set;
  if n<>24 then raise exception 'expected 24 published FRQs, got %', n; end if;

  select count(*) into n
  from (
    select ci.content_key
    from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id=ci.id
    where civ.status='published'
    group by ci.content_key
    having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after FRQ repair: %', n; end if;
end $$;

select 'repaired_frq' metric, count(*)::text value from repaired
union all select 'published_frq', count(*)::text from publish_set
union all select 'qa_blocked', count(*)::text from qa_blocked
union all select 'blocked_keys', coalesce(string_agg(content_key||':'||reason, ', ' order by content_key),'') from qa_blocked
union all select 'published_keys', string_agg(content_key, ', ' order by content_key) from publish_set;

commit;
