begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-034-v1','apchem-mcq-sv-034-v2','apchem-mcq-sv-034-v3','apchem-mcq-sv-035-v1','apchem-mcq-sv-035-v2','apchem-mcq-sv-035-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-034-v1 (seed apchem-mcq-034)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-034-v1', 'mcq', 'Conditions for ideal carbon dioxide', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student wants carbon dioxide gas to behave as nearly like an ideal gas as possible. Which set of conditions is best, and why?', null, md5('apchem-mcq-sv-034-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '250 K and 50 atm, because the molecules collide more often, which makes the gas obey kinetic molecular theory more closely.', false, 'Incorrect: this is the combination that gives the largest deviation from ideality. The slow molecules attract one another and, at high pressure, are crowded so that their volume is not negligible; collision frequency is not the criterion for ideal behavior.' from version_ins
union all select gen_random_uuid(), id, 'B', '250 K and 0.50 atm, because low pressure alone is enough to make any gas behave ideally at any temperature.', false, 'Incorrect: low pressure keeps molecular volume negligible, but at 250 K the slower molecules are affected by intermolecular attractions, so the gas deviates more than it would at 450 K.' from version_ins
union all select gen_random_uuid(), id, 'C', '450 K and 0.50 atm, because the molecules are fast and far apart, so attractions and molecular volume are negligible.', true, 'Correct: at high temperature the molecules move so fast that attractive forces have little effect on their motion, and at low pressure the molecules are far apart so their own volume is negligible compared with the container volume. These are the two conditions under which the ideal-gas assumptions hold best.' from version_ins
union all select gen_random_uuid(), id, 'D', '450 K and 50 atm, because high temperature alone is enough to make any gas behave ideally at any pressure.', false, 'Incorrect: high temperature minimizes the effect of attractions, but at 50 atm the molecules are forced close together, so their own volume is a significant fraction of the container volume and the gas deviates.' from version_ins
;
-- apchem-mcq-sv-034-v2 (seed apchem-mcq-034)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-034-v2', 'mcq', 'Ammonia versus methane deviation', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At 1 atm and 298 K, the measured pressure of an ammonia (NH3, 17 g/mol) sample is lower than the ideal gas law predicts by a larger percentage than for the same amount of methane (CH4, 16 g/mol) in the same container. Which statement best explains this difference?', null, md5('apchem-mcq-sv-034-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'NH3 is slightly more massive than CH4, so its molecules move much more slowly and exert noticeably less pressure on the walls.', false, 'Incorrect: 17 g/mol and 16 g/mol are almost identical, so the average speeds are nearly the same. The ideal gas law already accounts for the equal temperature, so mass cannot explain the extra deviation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'NH3 molecules are much larger than CH4 molecules, so their own volume takes up more of the container and lowers the pressure.', false, 'Incorrect: NH3 and CH4 are similar in size and mass, and at 1 atm the molecular volume is negligible. Excluded volume would push the pressure above the ideal value, not below it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The stronger attractions between NH3 molecules pull them together, so they strike the walls less forcefully and the pressure is lower.', true, 'Correct: NH3 molecules attract each other much more strongly than CH4 molecules because NH3 is polar and hydrogen bonds, whereas CH4 has only weak dispersion forces. Intermolecular attractions reduce the force and frequency of collisions with the walls, so the measured pressure falls below the ideal-gas prediction, and more so for NH3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The attractions between NH3 molecules pull them toward the walls of the container, which increases the pressure above the ideal value.', false, 'Incorrect: attractions pull each molecule inward toward its neighbors, reducing the force of wall collisions. That lowers the measured pressure, as observed; it does not raise it.' from version_ins
;
-- apchem-mcq-sv-034-v3 (seed apchem-mcq-034)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-034-v3', 'mcq', 'Cooling nitrogen toward condensation', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid flask contains nitrogen gas that behaves nearly ideally at 300 K. When the flask is cooled to 80 K, near the boiling point of N2, the measured pressure is lower than the ideal gas law predicts. Which statement best explains why?', null, md5('apchem-mcq-sv-034-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At 80 K the molecules stop moving entirely, so the pressure falls to nearly zero regardless of what the ideal gas law predicts.', false, 'Incorrect: molecular motion does not stop at 80 K because average kinetic energy remains proportional to the Kelvin temperature, so collisions and pressure continue. The ideal gas law already predicts the large drop from cooling; the question concerns the extra, smaller drop.' from version_ins
union all select gen_random_uuid(), id, 'B', 'At 80 K the slower N2 molecules attract one another noticeably, so they strike the walls less forcefully than ideal particles would.', true, 'Correct: the ideal gas law accounts for the drop in pressure caused by the lower temperature, but it assumes no intermolecular attractions. Near the condensation point the molecules move slowly enough for their attractive (London dispersion) forces to affect their motion, which reduces wall collisions and makes the measured pressure lower than the ideal value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At 80 K the N2 molecules become polar and develop permanent dipoles, so strong dipole-dipole forces act between them.', false, 'Incorrect: N2 is a nonpolar molecule at any temperature; cooling does not give it a permanent dipole. The attractions that become significant near condensation are London dispersion forces.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At 80 K the volume of the N2 molecules is no longer negligible, so the available volume is smaller and the pressure drops below ideal.', false, 'Incorrect: molecular volume becomes important at high pressure, and the volume of the molecules is unchanged by cooling in this rigid flask. A reduction in available volume would raise the pressure above the ideal value, not lower it.' from version_ins
;
-- apchem-mcq-sv-035-v1 (seed apchem-mcq-035)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-035-v1', 'mcq', 'Warm soda goes flat', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two identical bottles of soda are opened at the same time and left open to the air. One sits in a refrigerator at 4 °C and the other sits on a table at 22 °C. After an hour, the warmer soda has lost noticeably more of its dissolved CO₂(g) and tastes flatter. Which statement best explains this observation?', null, md5('apchem-mcq-sv-035-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Warmer water has stronger hydrogen bonding between its molecules, which squeezes the CO₂ molecules out of the solution as the water structure tightens.', false, 'Incorrect. Raising the temperature gives molecules more kinetic energy, so attractions such as hydrogen bonds are overcome more easily; it does not make them stronger. A tightening water structure is not the cause of the lost CO₂.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Warmer CO₂ molecules have greater average kinetic energy, so more of them overcome their weak attractions to water molecules and escape from the solution into the gas phase.', true, 'Correct. Dissolving a gas in water is generally exothermic, and the attractions holding CO₂ in solution are weak. At the higher temperature a larger fraction of CO₂ molecules has enough kinetic energy to break free of those attractions, so the amount of CO₂ that stays dissolved decreases.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Heat breaks CO₂ molecules apart into carbon and oxygen atoms, so fewer CO₂ molecules remain dissolved in the warm soda.', false, 'Incorrect. A temperature change of a few tens of degrees does not break the covalent bonds in CO₂; the molecules leave the solution intact as CO₂(g), which is why the soda goes flat.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The warm soda loses CO₂ only because more water evaporates, which carries CO₂ away; the solubility of CO₂ itself does not depend on temperature.', false, 'Incorrect. Evaporation of water over an hour is small and does not account for the flat taste. The solubility of a gas in water itself decreases as temperature increases, which is the main effect.' from version_ins
;
-- apchem-mcq-sv-035-v2 (seed apchem-mcq-035)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-035-v2', 'mcq', 'River oxygen downstream', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Environmental scientists find 11.9 mg/L of dissolved O₂ in a river at 8 °C upstream of a power plant and only 7.8 mg/L at 28 °C downstream, where heated cooling water has warmed the river. The air above both sites has the same pressure and the same O₂ content. Which statement best explains the lower dissolved oxygen downstream?', null, md5('apchem-mcq-sv-035-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Heating makes each O₂ molecule expand, so each one takes up more space and fewer of them fit between the water molecules downstream.', false, 'Incorrect. Heating raises the average kinetic energy of molecules but does not enlarge the molecules themselves. The decrease in solubility comes from more molecules escaping the weak attractions to water.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Dissolving a gas absorbs energy, so heating should favor dissolving more O₂; the downstream drop must be caused entirely by organisms using up the oxygen.', false, 'Incorrect. Dissolving a gas in water is generally exothermic, not endothermic, so heating shifts toward less dissolved gas. Assuming gases behave like most solids, whose solubility rises with temperature, wrongly dismisses the temperature effect.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At the higher temperature, dissolved O₂ molecules have greater average kinetic energy, so more of them break free of their weak attractions to water and enter the air above the river.', true, 'Correct. Gas solubility generally decreases with increasing temperature because dissolving a gas is generally exothermic and the attractions between O₂ and water molecules are weak. With the same air pressure and O₂ content at both sites, the warmer water holds less dissolved O₂.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Water vapor from the warmer river displaces O₂ from the air above it, so less O₂ is available to dissolve in the downstream water.', false, 'Incorrect. The stem states that the air has the same pressure and O₂ content at both sites, so the supply of O₂ in contact with the water is unchanged. The difference arises from the temperature dependence of solubility.' from version_ins
;
-- apchem-mcq-sv-035-v3 (seed apchem-mcq-035)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-035-v3', 'mcq', 'Polar versus tropical CO₂', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Surface ocean water near the poles (about 2 °C) contains more dissolved CO₂(g) than surface water near the equator (about 28 °C), even though the air above both regions has the same pressure and the same composition. Which statement best explains this difference?', null, md5('apchem-mcq-sv-035-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At low temperature, CO₂ molecules become more polar, so they are attracted more strongly to the polar water molecules around them.', false, 'Incorrect. The polarity of CO₂ comes from its molecular geometry (linear, symmetric, nonpolar) and does not change with temperature.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Colder water forms stronger ion-dipole attractions with CO₂ molecules, and these attractions hold the CO₂ in solution.', false, 'Incorrect. Ion-dipole forces require an ion; CO₂ is a nonpolar molecule with no permanent dipole and carries no charge, so it does not form ion-dipole attractions with water.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Colder water is denser, and the extra weight of the water above pushes more CO₂ gas down into the solution.', false, 'Incorrect. The density of surface water does not compress CO₂ into solution; the gas pressure above the water is the same at both sites. The difference comes from kinetic energy and the escape of CO₂ molecules.' from version_ins
union all select gen_random_uuid(), id, 'D', 'In the colder water, CO₂ molecules have lower average kinetic energy, so fewer of them overcome their weak attractions to water and escape, and more CO₂ stays dissolved.', true, 'Correct. Gas solubility increases as temperature decreases. At 2 °C fewer dissolved CO₂ molecules have enough kinetic energy to break free of their weak attractions to water and enter the gas phase, so a greater amount remains in solution than at 28 °C.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-034-v1','apchem-mcq-sv-034-v2','apchem-mcq-sv-034-v3','apchem-mcq-sv-035-v1','apchem-mcq-sv-035-v2','apchem-mcq-sv-035-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
