begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.6-b-v1','apchem-mcq-b4-sv-h-4.6-b-v2','apchem-mcq-b4-sv-h-4.6-b-v3','apchem-mcq-b4-h-4.7-a','apchem-mcq-b4-sv-h-4.7-a-v1','apchem-mcq-b4-sv-h-4.7-a-v2','apchem-mcq-b4-sv-h-4.7-a-v3','apchem-mcq-b4-h-4.7-b','apchem-mcq-b4-sv-h-4.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apchem-mcq-b4-sv-h-4.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.6-b-v1', 'mcq', 'predict how a procedural error changes a calculated concentration (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student titrates 25.00 mL of HCl with 0.100 M NaOH. The tip of the buret contains an air bubble before the titration, and the bubble is expelled during the titration. The initial buret reading is taken with the bubble present. How will the calculated HCl concentration compare with the true value?', null, md5('apchem-mcq-b4-sv-h-4.6-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It will be too low, because the bubble reduces the volume of NaOH delivered.', false, 'The recorded volume is larger than the real volume delivered, so the calculation overestimates the base.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It will be too high, because the volume difference read from the buret includes the volume the bubble occupied, which is more than the liquid delivered.', true, 'Correct: the buret reading falls by the volume of liquid delivered plus the volume of liquid that replaces the bubble, so the recorded volume of NaOH is larger than the volume that reacted; the calculation overestimates the moles of base, so the HCl concentration comes out too high.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It will be correct, because the bubble contains no NaOH and does not change the reaction.', false, 'The bubble does not change the reaction, but it changes the volume that is recorded.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It will be too low, because the bubble makes the endpoint appear earlier.', false, 'A bubble does not change when the indicator turns color; it only changes the volume reading.' from version_ins;
-- apchem-mcq-b4-sv-h-4.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.6-b-v2', 'mcq', 'predict how a procedural error changes a calculated concentration (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student pipets 25.00 mL of HCl into a flask that was rinsed with distilled water and is still wet. The student then titrates with standardized 0.100 M NaOH, using phenolphthalein. How will the calculated HCl concentration compare with the true value?', null, md5('apchem-mcq-b4-sv-h-4.6-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It will be too low, because the added water dilutes the acid.', false, 'Dilution lowers the concentration in the flask, but the moles of acid do not change, and the calculation uses the pipetted volume and moles.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It will be too high, because more NaOH is needed to neutralize the water.', false, 'Water is neutral and needs no base, so the volume of NaOH is set by the moles of HCl.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It will be too low, because the water makes the indicator change color early.', false, 'Water does not change the pH at which phenolphthalein changes color.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It will be correct, because the water changes the concentration but not the moles of HCl, and the moles are what the NaOH neutralizes.', true, 'Correct: the moles of HCl in the flask are fixed by the pipet, so the volume of NaOH needed does not change.' from version_ins;
-- apchem-mcq-b4-sv-h-4.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.6-b-v3', 'mcq', 'predict how a procedural error changes a calculated concentration (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student rinses the pipet with distilled water and does not rinse it with the HCl sample before pipetting 25.00 mL of the HCl for titration with 0.100 M NaOH. How will the calculated HCl concentration compare with the true value?', null, md5('apchem-mcq-b4-sv-h-4.6-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It will be too high, because the water adds volume that needs to be neutralized.', false, 'Water is neutral and has nothing to neutralize; the effect of the dilution is fewer moles of acid in the pipetted volume.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It will be correct, because the pipet still delivers 25.00 mL.', false, 'The volume is correct, but its concentration is lower than that of the original sample, so the moles are lower.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It will be too low, because the sample in the pipet is diluted by the water, so it delivers fewer moles of HCl and requires less NaOH.', true, 'Correct: water left in the pipet dilutes the sample, so the 25.00 mL contains fewer moles than expected. Less NaOH is needed, but the calculation still divides by 25.00 mL, so the calculated concentration is too low.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It will be too high, because the extra water increases the pH at the equivalence point.', false, 'The added water does not change the equivalence point pH of a strong acid-strong base titration, and it does not make the calculation higher.' from version_ins;
-- apchem-mcq-b4-h-4.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.7-a', 'mcq', 'classify a reaction from an observation and decide whether electrons are transferred', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A zinc strip is placed in blue CuSO4(aq). Over time, the strip becomes coated with a reddish-brown solid and the blue color fades. Which classification best describes the reaction?', null, md5('apchem-mcq-b4-h-4.7-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Synthesis, because zinc and copper combine into one product.', false, 'No single product forms; Zn²⁺ stays in solution and copper metal forms separately.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Double replacement, because the ions swap partners to form an insoluble solid.', false, 'The solid is copper metal, which is an element and not an ionic precipitate, and electrons are transferred.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Single replacement and redox, because Zn loses electrons and Cu²⁺ gains them to form Cu(s).', true, 'Correct: Zn + Cu²⁺ → Zn²⁺ + Cu. Zn goes 0 → +2 and Cu goes +2 → 0, so the reaction is redox, and the metal replaces a metal ion in solution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Decomposition, because the blue CuSO4 breaks down into simpler substances.', false, 'The reaction has two reactants, and the sulfate ion does not change; the copper is replaced by zinc.' from version_ins;
-- apchem-mcq-b4-sv-h-4.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.7-a-v1', 'mcq', 'classify a reaction from an observation and decide whether electrons are transferred (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Colorless Na2CO3(aq) is mixed with colorless CaCl2(aq). A cloudy white solid forms, with no gas, no flame and no color change, and no element changes its oxidation number. Which classification best describes the reaction?', null, md5('apchem-mcq-b4-sv-h-4.7-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Double replacement (precipitation), which is not a redox reaction.', true, 'Correct: Ca²⁺ + CO3²⁻ → CaCO3(s); oxidation numbers are unchanged, so it is not redox.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Single replacement, because Ca replaces Na in the compound.', false, 'Both cations and anions exchange partners, and no free element is involved, so it is double replacement.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Combustion, because a new substance forms and energy is released.', false, 'Combustion needs oxygen as a reactant, and none is involved here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Single replacement and redox, because a solid forms.', false, 'A solid forming does not indicate electron transfer, and no oxidation numbers change.' from version_ins;
-- apchem-mcq-b4-sv-h-4.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.7-a-v2', 'mcq', 'classify a reaction from an observation and decide whether electrons are transferred (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A white solid is heated and releases a gas that relights a glowing splint. The solid left behind is KCl. The reaction is 2 KClO3 → 2 KCl + 3 O2. Which classification is best?', null, md5('apchem-mcq-b4-sv-h-4.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Synthesis, because a gas is formed.', false, 'Synthesis combines several reactants into one product, and here one reactant forms two products.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Decomposition, but not redox, because only one reactant is involved.', false, 'The number of reactants does not decide whether a reaction is redox; the oxidation numbers of Cl and O change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Decomposition and redox, because Cl goes from +5 to -1 and O goes from -2 to 0.', true, 'Correct: Cl is +5 in KClO3 and -1 in KCl; O is -2 in KClO3 and 0 in O2; one reactant gives several products.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Single replacement, because chlorine is replaced by oxygen.', false, 'There is only one reactant, so nothing replaces anything else.' from version_ins;
-- apchem-mcq-b4-sv-h-4.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.7-a-v3', 'mcq', 'classify a reaction from an observation and decide whether electrons are transferred (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Magnesium ribbon is added to dilute HCl(aq). Bubbles of H2 gas form and the ribbon disappears. Which classification best describes the reaction Mg + 2 HCl → MgCl2 + H2?', null, md5('apchem-mcq-b4-sv-h-4.7-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Acid-base neutralization, because HCl is an acid.', false, 'A neutralization is a proton transfer to a base such as OH⁻, but Mg is a metal that transfers electrons.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Single replacement and redox, because Mg is oxidized and H⁺ is reduced.', true, 'Correct: Mg goes 0 → +2 (oxidized); H goes +1 → 0 (reduced); a free element replaces another element in a compound.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Double replacement, because Mg²⁺ and H⁺ swap anions.', false, 'A free element (Mg) reacts, so a double replacement does not apply.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Decomposition, because HCl breaks down into H2.', false, 'There are two reactants, and the Cl stays as Cl⁻ in MgCl2.' from version_ins;
-- apchem-mcq-b4-h-4.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.7-b', 'mcq', 'combine reaction-type patterns with oxidation numbers to see that type does not decide redox', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which reaction is a synthesis (combination) reaction that is NOT an oxidation-reduction reaction?', null, md5('apchem-mcq-b4-h-4.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 Mg + O2 → 2 MgO', false, 'It is a synthesis, but Mg goes from 0 to +2 and O goes from 0 to -2, so it is redox.' from version_ins
union all select gen_random_uuid(), id, 'B', '2 H2O2 → 2 H2O + O2', false, 'It is a decomposition and redox because O in H2O2 (-1) changes to -2 and 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'CaO + CO2 → CaCO3', true, 'Correct: in CaO + CO2 → CaCO3, Ca stays +2, C stays +4 and O stays -2; two reactants form one product.' from version_ins
union all select gen_random_uuid(), id, 'D', 'CaCO3 → CaO + CO2', false, 'It is a decomposition, not a synthesis, although no oxidation numbers change.' from version_ins;
-- apchem-mcq-b4-sv-h-4.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.7-b-v1', 'mcq', 'combine reaction-type patterns with oxidation numbers to see that type does not decide redox (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which reaction is a decomposition reaction that is also an oxidation-reduction reaction?', null, md5('apchem-mcq-b4-sv-h-4.7-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'CaCO3 → CaO + CO2', false, 'It is a decomposition, but Ca, C and O keep the same oxidation numbers.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mg(OH)2 → MgO + H2O', false, 'It is a decomposition, but no oxidation number changes.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 KClO3 → 2 KCl + 3 O2', true, 'Correct: only in KClO3 → KCl + O2 do oxidation numbers change (Cl +5 → -1, O -2 → 0).' from version_ins
union all select gen_random_uuid(), id, 'D', 'NH4Cl → NH3 + HCl', false, 'It is a decomposition, but N stays -3, H stays +1 and Cl stays -1.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.6-b-v1','apchem-mcq-b4-sv-h-4.6-b-v2','apchem-mcq-b4-sv-h-4.6-b-v3','apchem-mcq-b4-h-4.7-a','apchem-mcq-b4-sv-h-4.7-a-v1','apchem-mcq-b4-sv-h-4.7-a-v2','apchem-mcq-b4-sv-h-4.7-a-v3','apchem-mcq-b4-h-4.7-b','apchem-mcq-b4-sv-h-4.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b4-sv-h-4.6-b-v1','apchem-mcq-b4-sv-h-4.6-b-v2','apchem-mcq-b4-sv-h-4.6-b-v3','apchem-mcq-b4-h-4.7-a','apchem-mcq-b4-sv-h-4.7-a-v1','apchem-mcq-b4-sv-h-4.7-a-v2','apchem-mcq-b4-sv-h-4.7-a-v3','apchem-mcq-b4-h-4.7-b','apchem-mcq-b4-sv-h-4.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
