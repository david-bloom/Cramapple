begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.6-b-v1','apbio-mcq-b5-sv-h-2.6-b-v2','apbio-mcq-b5-sv-h-2.6-b-v3','apbio-mcq-b5-h-2.7-a','apbio-mcq-b5-sv-h-2.7-a-v1','apbio-mcq-b5-sv-h-2.7-a-v2','apbio-mcq-b5-sv-h-2.7-a-v3','apbio-mcq-b5-h-2.7-b','apbio-mcq-b5-sv-h-2.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apbio-mcq-b5-sv-h-2.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.6-b-v1', 'mcq', 'explain that a transport protein for passive transport changes how fast equilibrium is reached but not the equilibrium c (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Frog oocytes are placed in a slightly hypotonic solution. Oocytes that express the water channel aquaporin swell by 20% within 2 minutes and then stop swelling. Control oocytes without aquaporin swell by 20% over 40 minutes and then stop. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.6-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Aquaporin causes oocytes to take in more water, which makes the final volume larger.', false, 'The final volume is the same (20% greater) in both groups, so aquaporin does not change how much water is taken in.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Control oocytes use active transport to take in water, because they take longer to reach the final volume.', false, 'Water movement by osmosis is passive in both groups, and the slower rate in controls reflects lower membrane permeability to water.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Aquaporin speeds up the movement of water across the membrane, but the final volume is determined by the solute concentrations, so it is the same in both groups.', true, 'Correct: Both groups reach the same final volume (20% more), but the oocytes with aquaporin get there 20 times faster, so the channel changes the rate of osmosis and not the equilibrium.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Aquaporin pumps water into the oocytes until the volume reaches 20% above the starting value, then shuts off.', false, 'Aquaporin is a channel for passive movement, not a pump, and it does not use energy to pump water.' from version_ins;
-- apbio-mcq-b5-sv-h-2.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.6-b-v2', 'mcq', 'explain that a transport protein for passive transport changes how fast equilibrium is reached but not the equilibrium c (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cells in 5 mM of a nonmetabolized sugar have come to equilibrium, with 5 mM inside. A competitive inhibitor of the sugar carrier is added, and then the outside concentration is raised to 10 mM. Which outcome is predicted over several hours?', null, md5('apbio-mcq-b5-sv-h-2.6-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The internal concentration stays at 5 mM, because blocked carriers cannot move any sugar.', false, 'A competitive inhibitor reduces transport but does not stop it entirely, and the sugar can also cross slowly through the bilayer, so equilibration still occurs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The internal concentration rises above 10 mM, because the carrier concentrates the sugar.', false, 'The carrier is passive and cannot raise the internal concentration above the outside concentration of 10 mM.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The internal concentration falls toward 0 mM, because the inhibitor causes the cell to export the sugar.', false, 'The outside concentration is higher than the inside, so the net movement is inward, not outward.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The internal concentration rises slowly and eventually reaches 10 mM, because the sugar still crosses slowly and the equilibrium is set by the outside concentration.', true, 'Correct: A competitive inhibitor slows the carrier but does not stop transport entirely or alter the gradient-driven equilibrium, so the internal concentration approaches 10 mM, but more slowly.' from version_ins;
-- apbio-mcq-b5-sv-h-2.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.6-b-v3', 'mcq', 'explain that a transport protein for passive transport changes how fast equilibrium is reached but not the equilibrium c (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Bacteria with a glycerol channel protein and mutant bacteria lacking it are placed in 10 mM glycerol (which they do not metabolize). The initial rate of uptake is 8 mM per minute in normal bacteria and 0.2 mM per minute in the mutant. After 60 minutes both have 10 mM glycerol inside. Which statement is best supported?', null, md5('apbio-mcq-b5-sv-h-2.6-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The channel allows the bacteria to accumulate glycerol at a concentration higher than the outside concentration.', false, 'The final internal concentration is 10 mM, equal to the outside, so the channel does not cause accumulation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The channel increases the initial rate of uptake 40-fold, but does not change the final concentration.', true, 'Correct: The ratio of initial rates is 8 divided by 0.2 = 40, and both end at 10 mM, equal to the outside concentration, so the channel changes the speed but not the equilibrium.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The channel protein increases the initial rate of uptake 4-fold, but does not change the final concentration.', false, 'The initial rate ratio is 40, not 4, so this understates the effect of the channel on rate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The mutant bacteria must be using active transport, because uptake still occurs without the channel.', false, 'Slow uptake in the mutant is consistent with glycerol slowly crossing the bilayer by diffusion, and its final concentration is equal to the outside level, not above it.' from version_ins;
-- apbio-mcq-b5-h-2.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.7-a', 'mcq', 'predict the direction of water movement by combining solute potential and pressure potential into water potential.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water potential is the sum of solute potential and pressure potential, and water moves from higher to lower water potential. A plant cell has a solute potential of -0.70 MPa and a pressure potential of +0.40 MPa. It is placed in an open beaker of solution that has a water potential of -0.50 MPa. Which statement is correct?', null, md5('apbio-mcq-b5-h-2.7-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Water enters the cell, because the cell''s solute potential of -0.70 MPa is lower than the solution''s potential of -0.50 MPa.', false, 'Comparing only the solute potential ignores the pressure potential; the total potential of the cell is higher than the solution''s, so water leaves.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is no net movement, because the positive pressure potential balances the negative solute potential.', false, 'The two potentials do not cancel (the sum is -0.30 MPa, not 0), and the solution has a lower total potential, so water moves.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Water leaves the cell, and the cell''s pressure potential increases as the cell shrinks.', false, 'The direction of water flow is right, but losing water reduces the pressure inside the cell wall, so the pressure potential decreases.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Water leaves the cell, because the cell''s water potential of -0.30 MPa is higher than -0.50 MPa, and the cell''s pressure potential falls as it loses water.', true, 'Correct: Cell water potential = -0.70 + 0.40 = -0.30 MPa. Water flows from higher (-0.30) to lower (-0.50), so water leaves the cell. Losing water reduces turgor, so the pressure potential decreases.' from version_ins;
-- apbio-mcq-b5-sv-h-2.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.7-a-v1', 'mcq', 'predict the direction of water movement by combining solute potential and pressure potential into water potential. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Use the formula solute potential = -iCRT, with i = 1 for sucrose, R = 0.0831 liter bar per mole kelvin, and T in kelvin. A plant cell has a solute potential of -8.0 bar and a pressure potential of +2.0 bar. It is placed in an open beaker of 0.30 M sucrose at 25°C (298 K). The solution''s solute potential is about -7.43 bar. Which statement is correct?', null, md5('apbio-mcq-b5-sv-h-2.7-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Water enters the cell, because the cell''s solute potential of -8.0 bar is lower than the solution''s -7.43 bar.', false, 'Using only the solute potential of the cell ignores its +2.0 bar pressure potential; the total of -6.0 bar is higher than the solution''s value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Water enters the cell, because the solution has a solute potential of +7.43 bar, which is higher than the cell''s -6.0 bar.', false, 'The solute potential of a solution is negative, because solutes lower the water potential, so a positive value is a sign error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is no net movement, because the +2.0 bar pressure potential cancels the solution''s solute potential.', false, 'Pressure potential is a property of the cell and does not cancel the solution''s solute potential, and the two total potentials are different.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Water leaves the cell, because the cell''s water potential of -6.0 bar is higher than the solution''s -7.43 bar.', true, 'Correct: Solution = -(1)(0.30)(0.0831)(298) = -7.43 bar. Cell = -8.0 + 2.0 = -6.0 bar. Water moves from -6.0 (higher) to -7.43 (lower), so it leaves the cell.' from version_ins;
-- apbio-mcq-b5-sv-h-2.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.7-a-v2', 'mcq', 'predict the direction of water movement by combining solute potential and pressure potential into water potential. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A plant tissue has a water potential of -4.0 bar. A researcher wants a sucrose solution in an open beaker at 20°C (293 K) that produces no net water movement. Use solute potential = -iCRT, with i = 1 for sucrose and R = 0.0831 liter bar per mole kelvin. Which concentration is needed?', null, md5('apbio-mcq-b5-sv-h-2.7-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.4 M', false, '2.4 M results from using 20 for the temperature instead of converting to 293 K.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.16 M', true, 'Correct: In an open beaker pressure potential is 0, so the solution must have a solute potential of -4.0 bar: C = 4.0 / (0.0831 × 293) = 4.0 / 24.35 = 0.164 M.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.082 M', false, '0.082 M results from treating sucrose as if it dissociated into two particles, using i = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.014 M', false, '0.014 M results from leaving out the gas constant R in the calculation.' from version_ins;
-- apbio-mcq-b5-sv-h-2.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.7-a-v3', 'mcq', 'predict the direction of water movement by combining solute potential and pressure potential into water potential. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four plant cells have the following solute potential and pressure potential (in MPa): cell 1, -1.4 and +1.2; cell 2, -0.9 and +0.1; cell 3, -1.1 and +0.5; cell 4, -0.4 and 0.0. Each cell is placed in pure water, which has a water potential of 0. Which cell will gain water most rapidly at first?', null, md5('apbio-mcq-b5-sv-h-2.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cell 2, because it has the lowest total water potential (-0.8 MPa), giving the greatest difference from pure water.', true, 'Correct: Total potentials are cell 1, -0.2; cell 2, -0.8; cell 3, -0.6; cell 4, -0.4. Water moves toward lower potential, and the largest difference from 0 is for cell 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cell 1, because it has the most negative solute potential.', false, 'Cell 1 has the most negative solute potential, but its +1.2 MPa pressure potential makes its total only -0.2 MPa, so it has the weakest drive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cell 4, because it has the least positive pressure potential and so offers no resistance.', false, 'Pressure potential alone does not determine water movement; cell 4 has a total of only -0.4 MPa.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cell 3, because it has a moderate solute potential and moderate pressure potential.', false, 'Cell 3 has a total potential of -0.6 MPa, which is lower than cells 1 and 4 but not as low as cell 2.' from version_ins;
-- apbio-mcq-b5-h-2.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.7-b', 'mcq', 'infer the tonicity relationship and the osmoregulatory work an organism must do from data on its response in different s', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The freshwater protist Paramecium has a contractile vacuole that collects excess water and expels it. A researcher counts how many times the contractile vacuole empties per minute in solutions of different total solute concentration (mOsm): 10 mOsm, 15 per minute; 40 mOsm, 9 per minute; 70 mOsm, 4 per minute; 100 mOsm, 0 per minute; 130 mOsm, 0 per minute. Which conclusion is best supported?', null, md5('apbio-mcq-b5-h-2.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The contractile vacuole pumps solutes out, so the rate falls when the solutes outside are abundant.', false, 'The vacuole collects and expels water, and the rate falls because less water enters, not because solutes are pumped out.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The cytoplasm is hypotonic to pond water, because the cell must expel water to maintain its volume.', false, 'If the cytoplasm were hypotonic, water would leave the cell, and there would be no need to expel it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cytoplasm is hypertonic to pond water, so water enters by osmosis; the pumping rate falls as the outside concentration rises, and it stops near 100 mOsm, where the outside concentration approaches that of the cytoplasm.', true, 'Correct: A high rate in dilute solution shows that water enters, so the cytoplasm has a higher solute concentration than the pond water. As the outside concentration rises, less water enters, and at about 100 mOsm there is no net entry, so the cytoplasm is close to 100 mOsm.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The vacuole stops at 100 mOsm because the cells are dead from water loss.', false, 'The data do not show cell death, and the vacuole stops because net water entry stops.' from version_ins;
-- apbio-mcq-b5-sv-h-2.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.7-b-v1', 'mcq', 'infer the tonicity relationship and the osmoregulatory work an organism must do from data on its response in different s (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A freshwater fish is measured in freshwater and then in seawater. In freshwater, it produces about 150 mL of dilute urine per kilogram per day and drinks almost no water. After transfer to seawater, urine output drops to about 10 mL per kilogram per day, the fish drinks about 200 mL per kilogram per day, and its gills actively secrete salt. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.7-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The fish''s body fluids are isotonic to both environments, so the changes are not related to osmosis.', false, 'The large changes in urine output and drinking show that osmotic work differs between the two environments, which would not happen if the fish were isotonic to both.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The fish''s body fluids are hypotonic to freshwater and hypertonic to seawater.', false, 'This reverses the relationship, and in that case water would leave in freshwater and enter in seawater.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The fish''s body fluids are hypertonic to freshwater, so water enters and must be excreted, and hypotonic to seawater, so water is lost and must be replaced.', true, 'Correct: Large volumes of dilute urine in freshwater indicate excess water entering; drinking and salt secretion in seawater indicate water loss and salt gain, so the body fluid concentration is above freshwater and below seawater.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The fish drinks seawater to gain salt, which is needed to offset losses in urine.', false, 'The fish drinks to replace water lost to the hypertonic seawater, and it must then excrete the extra salt through its gills, so salt is in excess.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.6-b-v1','apbio-mcq-b5-sv-h-2.6-b-v2','apbio-mcq-b5-sv-h-2.6-b-v3','apbio-mcq-b5-h-2.7-a','apbio-mcq-b5-sv-h-2.7-a-v1','apbio-mcq-b5-sv-h-2.7-a-v2','apbio-mcq-b5-sv-h-2.7-a-v3','apbio-mcq-b5-h-2.7-b','apbio-mcq-b5-sv-h-2.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-sv-h-2.6-b-v1','apbio-mcq-b5-sv-h-2.6-b-v2','apbio-mcq-b5-sv-h-2.6-b-v3','apbio-mcq-b5-h-2.7-a','apbio-mcq-b5-sv-h-2.7-a-v1','apbio-mcq-b5-sv-h-2.7-a-v2','apbio-mcq-b5-sv-h-2.7-a-v3','apbio-mcq-b5-h-2.7-b','apbio-mcq-b5-sv-h-2.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
