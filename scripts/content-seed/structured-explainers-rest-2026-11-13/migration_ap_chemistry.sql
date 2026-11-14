-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.
begin;
update app.topic_explainers set
  core_idea = $q$Thermochemistry answers a system-surroundings question: does energy enter the system or leave it?$q$,
  what_students_need_to_understand = $q$- Define the system first.
- If the reacting system releases energy, the surroundings may warm up and the process is exothermic with negative Delta H.
- If the system absorbs energy, the surroundings may cool and the process is endothermic with positive Delta H.
- Solution formation can go either way depending on attractions before and after mixing.$q$,
  how_this_becomes_points = $q$1. Name system and surroundings.
2. Track the energy direction.
3. Assign the sign to the process rather than to a vague temperature observation.$q$,
  point_attaining_answer = $q$Endothermic.

The dissolving process is the system, and it absorbs energy from the surroundings, making the beaker feel colder.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=6 and topic_code='6.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a72f4cb2a42fa2def988b46ad7de06a6';
update app.topic_explainers set
  core_idea = $q$An energy diagram uses vertical position to show whether a process ends at higher or lower energy than it began.$q$,
  what_students_need_to_understand = $q$- Read the diagram before naming the process.
- Products above reactants indicate energy absorbed and positive Delta H.
- Products below reactants indicate energy released and negative Delta H.
- If a barrier is shown, activation energy is separate from overall energy change.$q$,
  how_this_becomes_points = $q$1. Label the states.
2. Read the sign of Delta H.
3. Distinguish the height to a peak from the reactant-to-product difference.$q$,
  point_attaining_answer = $q$Positive.

Products are higher in energy than reactants, so the system absorbed energy overall and the process is endothermic.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=6 and topic_code='6.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e40fef5e80de0598eab38b1d15c8ad96';
update app.topic_explainers set
  core_idea = $q$Heat transfer is energy transfer caused by a temperature difference, and it continues until average particle kinetic energies match.$q$,
  what_students_need_to_understand = $q$- Use particle reasoning: warmer samples have higher average kinetic energy.
- Collisions transfer energy to cooler samples.
- Thermal equilibrium means equal temperature, not equal total thermal energy, because total energy also depends on amount and composition of matter.$q$,
  how_this_becomes_points = $q$1. Identify the transfer direction.
2. Explain the collisions.
3. Describe equilibrium as equal temperature or equal average kinetic energy.$q$,
  point_attaining_answer = $q$No.

Equal temperature means equal average particle kinetic energy, but total thermal energy also depends on amount of substance and heat capacity.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=6 and topic_code='6.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='75c6e6cfcd73c60ab373a57bfff5d7bf';
update app.topic_explainers set
  core_idea = $q$Calorimetry uses temperature change of surroundings to infer heat transferred, while energy conservation connects that heat to the reacting system.$q$,
  what_students_need_to_understand = $q$- Choose mass and sign carefully.
- For solution calorimetry, the mass is often the total solution mass, not just solute.
- q=mc Delta T gives heat gained or lost by the measured surroundings; the reacting system has the opposite sign.
- The 2025 evidence also flags significant figures as a major scoring issue.$q$,
  how_this_becomes_points = $q$1. Substitute the correct m, c, and Delta T.
2. Keep signs consistent.
3. Use q_system = -q_surroundings when appropriate.
4. Report with correct significant figures.$q$,
  point_attaining_answer = $q$Use the mass of the solution being warmed, approximately 100.1 g if the solid remains in solution.

q=mc Delta T describes the thermal change of the solution surroundings, not just the original solid mass.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=6 and topic_code='6.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='980c6e999f64fc3ca04fd3f9778063ae';
update app.topic_explainers set
  core_idea = $q$During a pure-substance phase change, energy changes particle separation while temperature remains constant.$q$,
  what_students_need_to_understand = $q$- Separate sloped heating-curve regions from plateaus.
- Melting and vaporization absorb energy; freezing and condensation release energy.
- Opposite phase changes have enthalpy values equal in magnitude and opposite in sign.$q$,
  how_this_becomes_points = $q$1. Select phase-change enthalpy instead of q=mc Delta T during a plateau.
2. Assign the correct sign.
3. Recognize constant temperature during the phase change.$q$,
  point_attaining_answer = $q$Energy is still being added, but it is used to separate particles into the gas phase rather than increase average kinetic energy, so temperature remains constant during the phase change.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=6 and topic_code='6.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5ee16383697fcce3556c9b2abd5e575e';
update app.topic_explainers set
  core_idea = $q$At constant pressure, reaction enthalpy tracks heat absorbed or released by the reacting system.$q$,
  what_students_need_to_understand = $q$- Assign the sign from the system perspective.
- If a reaction warms the solution, the surroundings gained heat and the reaction released heat, so Delta H for the reaction is negative.
- If the solution cools, the reaction absorbed heat and Delta H is positive.$q$,
  how_this_becomes_points = $q$1. Link the observation to heat flow.
2. Convert heat to per-mole reaction enthalpy when required.
3. Keep system and surroundings signs opposite.$q$,
  point_attaining_answer = $q$Negative.

The solution surroundings gained heat, so the reacting system released heat. At constant pressure, the reaction enthalpy is exothermic and negative.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=6 and topic_code='6.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d7ac4b698b579847f7a10086e9808af8';
update app.topic_explainers set
  core_idea = $q$Bond enthalpy estimates use energy in for bonds broken and energy out for bonds formed.$q$,
  what_students_need_to_understand = $q$- Keep the signs straight.
- Breaking reactant bonds requires energy, so those terms are positive.
- Forming product bonds releases energy, so those terms reduce Delta H.
- Coefficients determine how many of each bond type are counted.$q$,
  how_this_becomes_points = $q$1. Count bonds with coefficients.
2. Sum broken-bond energies.
3. Sum formed-bond energies.
4. Calculate Delta H approximately as broken minus formed.$q$,
  point_attaining_answer = $q$Breaking bonds requires energy.

Forming strong product bonds releases a large amount of energy; if that release exceeds the energy required to break reactant bonds, the reaction is exothermic.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=6 and topic_code='6.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='54e061ce55adda129148a376f06fd051';
update app.topic_explainers set
  core_idea = $q$Standard formation enthalpies calculate reaction enthalpy by summing products and subtracting summed reactants.$q$,
  what_students_need_to_understand = $q$- Use coefficients and the correct direction.
- Each species formation value is multiplied by its balanced coefficient.
- The product sum minus reactant sum gives Delta H for the reaction as written.$q$,
  how_this_becomes_points = $q$1. Set up Sigma products - Sigma reactants.
2. Multiply by coefficients.
3. Avoid sign reversal.$q$,
  point_attaining_answer = $q$Formation enthalpies are usually given per mole of substance formed.

The balanced equation tells how many moles of each substance participate, so each table value must be multiplied by its coefficient.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=6 and topic_code='6.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='40a38b4f9973316ab02790a333a25688';
update app.topic_explainers set
  core_idea = $q$Hess law requires the equations to add to the target reaction, with every reversal or scaling reflected in Delta H.$q$,
  what_students_need_to_understand = $q$- Manipulate equations before manipulating only numbers.
- Reversing an equation changes the sign of Delta H.
- Multiplying an equation multiplies Delta H.
- When the adjusted equations sum to the target, their adjusted Delta H values sum to the target Delta H.$q$,
  how_this_becomes_points = $q$1. Match the target equation through cancellation.
2. Adjust Delta H with every equation change.
3. Avoid number-only addition.$q$,
  point_attaining_answer = $q$The Delta H values only add after the corresponding equations have been reversed or multiplied so that they sum to the target reaction.

Otherwise the numbers describe the wrong net process.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=6 and topic_code='6.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f77e5cdc64d4c5aa258a6020ca32f3d5';
update app.topic_explainers set
  core_idea = $q$Dynamic equilibrium means equal opposing rates, not inactivity.$q$,
  what_students_need_to_understand = $q$- Know examples: evaporation-condensation, dissolution-precipitation, acid-base proton transfer, and redox electron transfer.
- The AP move is to describe ongoing particle-level change despite no visible change.$q$,
  how_this_becomes_points = $q$1. Identify the reversible pair.
2. State equal rates at equilibrium.
3. Avoid completion language.$q$,
  point_attaining_answer = $q$No.

Evaporation and condensation continue, but their rates are equal, so the vapor amount remains constant.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4ca66e545e3a7c399edc7e0a83db663c';
update app.topic_explainers set
  core_idea = $q$A reversible reaction shifts according to unequal forward and reverse rates.$q$,
  what_students_need_to_understand = $q$- Equilibrium is approached when the faster direction consumes its favored side until opposing rates balance.
- More reactant or product alone does not prove the direction without rate or Q/K information.$q$,
  how_this_becomes_points = $q$1. Name the net direction.
2. Name the ending condition: equal rates at dynamic equilibrium.$q$,
  point_attaining_answer = $q$There is net forward change.

Product amount increases until the forward and reverse rates become equal.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='9ce17ede2064a33e371783c34e0c9bf9';
update app.topic_explainers set
  core_idea = $q$Q moves toward K as a system approaches equilibrium.$q$,
  what_students_need_to_understand = $q$- Build Kc, Kp, or Ksp expressions from balanced coefficients.
- Include only species whose concentrations or partial pressures change.
- The AP boundary excludes Kc-Kp conversion.$q$,
  how_this_becomes_points = $q$1. Set up the expression correctly.
2. Use exponents correctly.
3. State the Q/K direction correctly.$q$,
  point_attaining_answer = $q$No.

The solid is excluded; Ksp = [Ag+][Cl-]. Only dissolved ions appear in the expression.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c7e1dd4449bec9b12a20339674d7794a';
update app.topic_explainers set
  core_idea = $q$Calculating K is expression-first arithmetic.$q$,
  what_students_need_to_understand = $q$- Distinguish initial, change, and equilibrium amounts.
- Values measured at equilibrium go directly into K.
- Values before equilibrium require an equilibrium setup first.$q$,
  how_this_becomes_points = $q$1. Write the expression accurately.
2. Substitute correctly.
3. Give a unitless or contextual interpretation rather than random number plugging.$q$,
  point_attaining_answer = $q$No.

K describes equilibrium composition, so only equilibrium concentrations or pressures belong in the K expression.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ff68075796ac9182bc27f8937d619b61';
update app.topic_explainers set
  core_idea = $q$K magnitude describes equilibrium composition, not reaction speed.$q$,
  what_students_need_to_understand = $q$- Read K as a ratio of product terms to reactant terms.
- Very large K means the product side dominates at equilibrium.
- Very small K means little product is present.$q$,
  how_this_becomes_points = $q$1. Use product/reactant favoring language.
2. Avoid kinetics claims.$q$,
  point_attaining_answer = $q$Products are favored because K is much greater than 1.

This says nothing by itself about how fast equilibrium is reached.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='2067bd6c7709cd3bba2d273767a5bbee';
update app.topic_explainers set
  core_idea = $q$K follows reaction algebra, but not by simple addition.$q$,
  what_students_need_to_understand = $q$- Reversing changes products and reactants, so K becomes reciprocal.
- Multiplying coefficients changes exponents, so K is raised to that factor.
- Adding equations multiplies their K values.$q$,
  how_this_becomes_points = $q$Match the K operation to the reaction operation.$q$,
  point_attaining_answer = $q$K becomes 1/K because products and reactants switch places in the equilibrium expression.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='43532078f98c81606145733613946a8e';
update app.topic_explainers set
  core_idea = $q$Equilibrium concentration problems combine direction, stoichiometry, and K.$q$,
  what_students_need_to_understand = $q$- Decide whether the reaction moves forward or reverse.
- Express concentration changes in coefficient ratios.
- The final values must satisfy K.$q$,
  how_this_becomes_points = $q$Points come from a consistent setup more than from isolated arithmetic.$q$,
  point_attaining_answer = $q$Forward.

Product terms must increase relative to reactant terms so Q rises toward K.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f05a78109b68734c034fe22591400b69';
update app.topic_explainers set
  core_idea = $q$Equilibrium diagrams are particle-count evidence for K and composition.$q$,
  what_students_need_to_understand = $q$- Translate K magnitude into relative particle abundance without implying that particles stop reacting.
- Diagrams may show more products, more reactants, or comparable amounts depending on K.$q$,
  how_this_becomes_points = $q$Match particle ratios to the written equilibrium and K value.$q$,
  point_attaining_answer = $q$K is likely greater than 1 because products are more abundant than reactants at equilibrium.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='cc634735cdcffb906a4d934db9ad7165';
update app.topic_explainers set
  core_idea = $q$A stressed equilibrium shifts to reduce the effect of the stress.$q$,
  what_students_need_to_understand = $q$- Analyze the specific disturbance: adding species, removing species, changing volume, diluting, or changing temperature.
- Only temperature changes K.
- Concentration and pressure stresses change Q first.$q$,
  how_this_becomes_points = $q$Points come from a causal explanation, not a memorized left/right statement.$q$,
  point_attaining_answer = $q$Toward products, replacing some of what was removed and moving back toward equilibrium.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='077f45e10a03309009a25421f3e24fde';
update app.topic_explainers set
  core_idea = $q$Le Chatelier shifts can be described as Q returning to K.$q$,
  what_students_need_to_understand = $q$- Connect a concentration stress to the reaction quotient.
- Adding reactant usually lowers or raises Q depending on expression placement, causing a shift that restores Q=K.
- Temperature changes the equilibrium constant because heat is part of the thermochemical balance.$q$,
  how_this_becomes_points = $q$1. Use Q/K language.
2. Classify the stress correctly.$q$,
  point_attaining_answer = $q$No.

At constant temperature K is unchanged. The added reactant changes Q, and the system shifts until Q again equals K.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='745548a0ee1ba064138cbfc077d29050';
update app.topic_explainers set
  core_idea = $q$Solubility equilibrium is a reversible dissolution-precipitation balance.$q$,
  what_students_need_to_understand = $q$- Connect a saturated solution to Ksp.
- The solid is present but excluded from the expression.
- Dissolved ion concentrations appear with powers from coefficients.$q$,
  how_this_becomes_points = $q$1. Set up the expression.
2. Convert coefficients to exponents carefully.$q$,
  point_attaining_answer = $q$Two.

The coefficient 2 becomes the exponent, so Ksp = [Ca2+][F-]^2.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c2e14aad63f8c2995f07f50c587e7029';
update app.topic_explainers set
  core_idea = $q$The common-ion effect changes solubility by changing Q relative to Ksp.$q$,
  what_students_need_to_understand = $q$- Reason both directions.
- Adding a common ion increases Q and favors precipitation.
- Removing a common ion can allow more solid to dissolve.
- Acid consuming a basic ion is a common reverse case.$q$,
  how_this_becomes_points = $q$Points come from the mechanism, not just the phrase common ion.$q$,
  point_attaining_answer = $q$Solubility increases.

Removing OH- lowers Q, so more solid dissolves to restore Ksp.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=7 and topic_code='7.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='cffb531287c700b3d2a594d2c6297e9f';
update app.topic_explainers set
  core_idea = $q$Acid-base calculations start with hydronium, hydroxide, and water autoionization.$q$,
  what_students_need_to_understand = $q$- H+ and H3O+ are accepted conventions, with hydronium preferred.
- Kw changes with temperature.
- pH+pOH=14 and neutral pH=7 are 25 C relationships.$q$,
  how_this_becomes_points = $q$1. Choose the right logarithmic relationship.
2. Check the temperature condition.$q$,
  point_attaining_answer = $q$pH is 11.00 because pH + pOH = 14.00 at 25 C.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ede47a1062ff8238d8356f57d1ba7c17';
update app.topic_explainers set
  core_idea = $q$Strong species make pH calculations stoichiometric before logarithmic.$q$,
  what_students_need_to_understand = $q$- Know the strong acid and base lists.
- Account for Group II hydroxides producing two OH- per formula unit.
- The final answer must match the requested quantity.$q$,
  how_this_becomes_points = $q$1. Use full dissociation.
2. Use the log.
3. Do the final pH/pOH conversion.$q$,
  point_attaining_answer = $q$pH is 12.00.

NaOH gives [OH-]=0.010 M, so pOH=2.00 and pH=14.00-2.00.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='32680377ea9ace8733c94410802038d7';
update app.topic_explainers set
  core_idea = $q$Weak acid/base calculations are equilibrium problems.$q$,
  what_students_need_to_understand = $q$- Distinguish initial concentration from equilibrium ion concentration.
- Percent ionization compares ionized amount to initial amount.
- Conjugate acid-base strengths are linked by Kw.$q$,
  how_this_becomes_points = $q$1. Set up Ka/Kb correctly.
2. Avoid strong-species assumptions.$q$,
  point_attaining_answer = $q$No.

A weak acid partially ionizes, so [H3O+] must be found from the acid equilibrium.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='59019f22ac7640d52cae0d47f77d2242';
update app.topic_explainers set
  core_idea = $q$Neutralization and buffer problems are before-and-after problems.$q$,
  what_students_need_to_understand = $q$- Separate reaction completion from equilibrium pH.
- Strong with strong uses excess H+ or OH-.
- Weak with strong can form a buffer, leave excess strong reagent, or leave conjugate species at equivalence.$q$,
  how_this_becomes_points = $q$Points come from post-reaction species identification.$q$,
  point_attaining_answer = $q$A buffer forms because appreciable weak acid and conjugate base are both present.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7aee7c863f0e3d4a9cec2341a7c6d513';
update app.topic_explainers set
  core_idea = $q$Titration curves are stoichiometry plus equilibrium landmarks.$q$,
  what_students_need_to_understand = $q$- Read the graph carefully.
- Equivalence volume gives moles analyte from moles titrant.
- Half-equivalence gives pH=pKa for weak systems.
- Equivalence pH depends on the conjugate species for weak titrations.$q$,
  how_this_becomes_points = $q$Points come from using the right graph point for the right purpose.$q$,
  point_attaining_answer = $q$At 10.0 mL, the half-equivalence point, where [HA]=[A-] and pH=pKa.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='cb494dcad34f9b08cff0b7ebfd52c69e';
update app.topic_explainers set
  core_idea = $q$Acid strength follows from how stable the conjugate base is after proton loss.$q$,
  what_students_need_to_understand = $q$- Use structural language: electronegativity, inductive effects, resonance, and weak conjugate bases for strong acids.
- Common weak bases include ammonia-like nitrogen bases and carboxylates.$q$,
  how_this_becomes_points = $q$Points come from a causal structure-to-strength explanation.$q$,
  point_attaining_answer = $q$Resonance can stabilize the conjugate base by spreading negative charge, making proton loss more favorable and the acid stronger.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='31fda1584ec83f35459bfdee5fea08f3';
update app.topic_explainers set
  core_idea = $q$pH versus pKa is a protonation-state comparison.$q$,
  what_students_need_to_understand = $q$- Interpret pKa as the pH where acid and base forms are equal.
- Below pKa, the protonated acid form dominates.
- Above pKa, the deprotonated base form dominates.$q$,
  how_this_becomes_points = $q$1. Predict the form correctly.
2. Choose the indicator.$q$,
  point_attaining_answer = $q$The base form dominates because conditions are less proton-rich than the acid pKa point.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4cef7dda1c8aa70a5069680a800b202d';
update app.topic_explainers set
  core_idea = $q$A buffer is a chemical pair with two defensive reactions.$q$,
  what_students_need_to_understand = $q$- The acid member neutralizes added base.
- The base member neutralizes added acid.
- Large amounts relative to the added stress keep the ratio and pH from changing much.$q$,
  how_this_becomes_points = $q$1. Identify the components.
2. Describe the response mechanism.$q$,
  point_attaining_answer = $q$A- reacts with added H+ to form HA, reducing the pH change.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='039245ce3b1c1d81e0007570d3ce169e';
update app.topic_explainers set
  core_idea = $q$Buffer pH is pKa adjusted by the log of base form over acid form.$q$,
  what_students_need_to_understand = $q$- Set up the ratio direction correctly.
- If pH is above pKa, base form exceeds acid form.
- If pH is below pKa, acid form exceeds base form.$q$,
  how_this_becomes_points = $q$1. Substitute correctly.
2. Isolate the ratio.$q$,
  point_attaining_answer = $q$10.

The equation gives log([A-]/[HA])=1.00, so the ratio is 10^1.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ad538c8be72309f2bf6b9c05f24386c6';
update app.topic_explainers set
  core_idea = $q$Capacity depends on how much conjugate acid/base is available, not just their ratio.$q$,
  what_students_need_to_understand = $q$- Increasing both buffer components by the same factor keeps pH the same but increases capacity.
- More acid form gives greater capacity for added base.
- More base form gives greater capacity for added acid.$q$,
  how_this_becomes_points = $q$Points come from distinguishing pH from capacity.$q$,
  point_attaining_answer = $q$The more concentrated buffer has greater capacity because it has more conjugate acid and base available to neutralize added acid or base.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f1f7402ee35eb8a80ad961fd0e1d29b7';
update app.topic_explainers set
  core_idea = $q$pH can shift solubility equilibria by consuming or producing ions.$q$,
  what_students_need_to_understand = $q$- Reason from the dissolution equation.
- Acid can increase solubility of salts containing basic anions or hydroxide by consuming the anion, lowering Q, and allowing more solid to dissolve.$q$,
  how_this_becomes_points = $q$Points come from the shift mechanism, not a memorized acidic/basic salt rule.$q$,
  point_attaining_answer = $q$1. H+ reacts with OH-, lowering [OH-].
2. That lowers Q for the dissolution equilibrium.
3. More solid dissolves to restore Ksp.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=8 and topic_code='8.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='cca45e2901b5848939df3b49872d7285';
update app.topic_explainers set
  core_idea = $q$Entropy is dispersal of matter and energy at the particle level.$q$,
  what_students_need_to_understand = $q$- Know examples: solid to liquid to gas, gas expansion, more gas product moles.
- Higher temperature gives broader kinetic-energy distributions.$q$,
  how_this_becomes_points = $q$Points come from a specific particle or energy-dispersal explanation.$q$,
  point_attaining_answer = $q$More gas particles can occupy more positions and energy arrangements, increasing the number of microstates and system entropy.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8c351a29cc9700407641ba1986b01a9c';
update app.topic_explainers set
  core_idea = $q$Delta S reaction is a coefficient-weighted products-minus-reactants calculation.$q$,
  what_students_need_to_understand = $q$- Treat S values as per mole of species in the balanced equation.
- Check the sign against particle-level expectations.$q$,
  how_this_becomes_points = $q$1. Set up the calculation.
2. Interpret the sign.$q$,
  point_attaining_answer = $q$Correct.

The reaction entropy sum counts the amount of each species in the balanced reaction, so coefficients multiply the tabulated S values.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e8e75387c19f742956b778c8f866234b';
update app.topic_explainers set
  core_idea = $q$Thermodynamic favorability depends on the sign of Delta G.$q$,
  what_students_need_to_understand = $q$- Use the CED-preferred term thermodynamically favored.
- Negative Delta H and positive Delta S favor all temperatures.
- Positive Delta H and negative Delta S favor none.
- Mixed signs require T comparison.$q$,
  how_this_becomes_points = $q$Points come from sign-specific reasoning.$q$,
  point_attaining_answer = $q$No.

It may be favored only at high enough temperature because T Delta S must outweigh positive Delta H.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='9e1a949cea9fcddf410187d23c65d63a';
update app.topic_explainers set
  core_idea = $q$Thermodynamics says where a process tends; kinetics says how fast it gets there.$q$,
  what_students_need_to_understand = $q$- High activation energy can prevent an energetically favored process from occurring measurably.
- Lack of visible change does not prove equilibrium.$q$,
  how_this_becomes_points = $q$Points come from separating Delta G from rate.$q$,
  point_attaining_answer = $q$It may be kinetically slow because a high activation energy prevents a measurable rate.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b8b1d133f896d6828ead574f1d677604';
update app.topic_explainers set
  core_idea = $q$Delta G standard predicts product or reactant favoring at equilibrium.$q$,
  what_students_need_to_understand = $q$- Negative Delta G standard connects to K>1.
- Positive Delta G standard connects to K<1.
- When Delta G standard is about zero, neither side is strongly favored.$q$,
  how_this_becomes_points = $q$Points come from sign-to-K reasoning.$q$,
  point_attaining_answer = $q$K is greater than 1, meaning products are favored at equilibrium under standard conditions.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e37362b103089f8f7070924f5483c91a';
update app.topic_explainers set
  core_idea = $q$Dissolution Delta G is a balance of several particle-level energy and dispersal changes.$q$,
  what_students_need_to_understand = $q$- Reason qualitatively about solid attractions, solvent structure, and interactions between dissolved species and solvent.
- The total can be hard to predict without data.$q$,
  how_this_becomes_points = $q$Points come from balanced factor reasoning.$q$,
  point_attaining_answer = $q$The entropy gain may be outweighed by unfavorable enthalpy terms such as breaking strong ionic attractions or reorganizing solvent, so total Delta G can be positive.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0e52fe3c2ae9f6f1a64191e02e75d2cb';
update app.topic_explainers set
  core_idea = $q$Coupling makes the net process favorable, not the unfavorable step by itself.$q$,
  what_students_need_to_understand = $q$- Track shared intermediates or external energy.
- A favorable reaction can drive an unfavorable one when the combined Delta G is negative.$q$,
  how_this_becomes_points = $q$Points come from net Delta G reasoning.$q$,
  point_attaining_answer = $q$Yes.

The net Delta G is -15 kJ/mol, so the coupled overall process is thermodynamically favored.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='eac2157103570893f09e82a6bbe567b2';
update app.topic_explainers set
  core_idea = $q$Anode and cathode are process labels: oxidation at anode, reduction at cathode.$q$,
  what_students_need_to_understand = $q$- Describe electrodes, solutions, salt bridge, and meter roles.
- The AP boundary excludes assessing positive/negative electrode labeling, so process evidence matters most.$q$,
  how_this_becomes_points = $q$1. Assign half-reaction roles.
2. Describe cell-component function.$q$,
  point_attaining_answer = $q$At the anode.

Anode means oxidation in both galvanic and electrolytic cells.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c47ec8fc148f2890df0347b374b306f4';
update app.topic_explainers set
  core_idea = $q$E cell and Delta G have opposite signs for a given electron count.$q$,
  what_students_need_to_understand = $q$- Use standard reduction potentials flexibly.
- The best cathode/anode pairing depends on the pair being compared, not earlier roles in a question.$q$,
  how_this_becomes_points = $q$1. Choose the correct half-cells.
2. Interpret the sign.$q$,
  point_attaining_answer = $q$Negative, because Delta G standard = -nFE standard.

Positive cell potential means thermodynamically favored.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='27be74524cb5da68c0110dd2863a6732';
update app.topic_explainers set
  core_idea = $q$Cell potential is a driving force that changes as Q changes.$q$,
  what_students_need_to_understand = $q$- A cell far from equilibrium has larger driving force.
- A cell at equilibrium has zero potential.
- Nonstandard concentration changes alter Q and therefore E.$q$,
  how_this_becomes_points = $q$Points come from qualitative Nernst reasoning with a conceptual explanation.$q$,
  point_attaining_answer = $q$It decreases toward zero because the driving force is used up as Q approaches K.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='740b22086c463d180e1b7c105b717081';
update app.topic_explainers set
  core_idea = $q$Electrolysis calculations are redox stoichiometry using charge as the measured amount.$q$,
  what_students_need_to_understand = $q$Move through units in order:

1. Amperes to coulombs.
2. Coulombs to moles electrons.
3. Electrons to moles ion reduced or oxidized.
4. Then to mass if needed.$q$,
  how_this_becomes_points = $q$1. Convert units.
2. Use electron stoichiometry.$q$,
  point_attaining_answer = $q$Two moles of electrons are needed because Cu2+ must gain 2 electrons to become Cu(s).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Chemistry units 6-9): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_chemistry' and unit_number=9 and topic_code='9.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3a2dbc1205d102051666bbad452f569b';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_chemistry' and topic_code in ('6.1','6.2','6.3','6.4','6.5','6.6','6.7','6.8','6.9','7.1','7.2','7.3','7.4','7.5','7.6','7.7','7.8','7.9','7.10','7.11','7.12','8.1','8.2','8.3','8.4','8.5','8.6','8.7','8.8','8.9','8.10','8.11','9.1','9.2','9.3','9.4','9.5','9.6','9.7','9.8','9.9','9.10','9.11') and source_note like '%Structured 2026-11-13 (recommendation #3%')<>43 then raise exception 'expected 43 rows updated'; end if; end $$;
commit;
