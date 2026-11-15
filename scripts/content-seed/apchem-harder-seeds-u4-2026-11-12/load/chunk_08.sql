begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.8-b-v3','apchem-mcq-b4-h-4.9-a','apchem-mcq-b4-sv-h-4.9-a-v1','apchem-mcq-b4-sv-h-4.9-a-v2','apchem-mcq-b4-sv-h-4.9-a-v3','apchem-mcq-b4-h-4.9-b','apchem-mcq-b4-sv-h-4.9-b-v1','apchem-mcq-b4-sv-h-4.9-b-v2','apchem-mcq-b4-sv-h-4.9-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apchem-mcq-b4-sv-h-4.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.8-b-v3', 'mcq', 'separate acid strength from the amount of base needed for neutralization (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student titrates 20.0 mL of 0.150 M HBr (a strong acid) and, separately, 20.0 mL of 0.150 M HF (a weak acid, Ka = 6.8 × 10⁻⁴) with 0.100 M KOH. What volume of KOH is needed to reach the equivalence point in each titration?', null, md5('apchem-mcq-b4-sv-h-4.8-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '30.0 mL for each acid', true, 'Correct: each flask has 20.0 mL × 0.150 M = 3.00 mmol of monoprotic acid; V = 3.00 mmol ÷ 0.100 M = 30.0 mL.' from version_ins
union all select gen_random_uuid(), id, 'B', '30.0 mL for HBr and less than 30.0 mL for HF', false, 'HF is only partly ionized, but its un-ionized molecules still react with OH⁻, so none of the acid is left unneutralized.' from version_ins
union all select gen_random_uuid(), id, 'C', '30.0 mL for HBr and more than 30.0 mL for HF', false, 'Weak acid strength does not require extra KOH, since the stoichiometry is 1:1.' from version_ins
union all select gen_random_uuid(), id, 'D', '15.0 mL for each acid', false, 'It halves the volume, as though each acid supplied one half mole of H⁺ per mole.' from version_ins;
-- apchem-mcq-b4-h-4.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.9-a', 'mcq', 'assign oxidation numbers to find what is oxidized, what is reduced, and electrons transferred', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the reaction 2 Al(s) + Fe2O3(s) → Al2O3(s) + 2 Fe(s), which statement is correct?', null, md5('apchem-mcq-b4-h-4.9-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Al is the oxidizing agent because it is oxidized.', false, 'The species that is oxidized is the reducing agent; the oxidizing agent is the species that is reduced.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fe2O3 is the reducing agent because the iron in it is reduced.', false, 'The species that is reduced is the oxidizing agent and takes electrons from Al.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fe2O3 is the oxidizing agent: each Fe goes from +3 to 0, and 6 electrons are transferred per Fe2O3.', true, 'Correct: Al 0 → +3 (oxidized, reducing agent), Fe +3 → 0 (reduced, oxidizing agent), O is -2 on both sides. Two Fe gain 3 e⁻ each, so 6 e⁻ are transferred.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Oxygen is oxidized, since it goes from -2 in Fe2O3 to 0 in Al2O3.', false, 'Oxygen is -2 in both Fe2O3 and Al2O3, so its oxidation number does not change.' from version_ins;
-- apchem-mcq-b4-sv-h-4.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.9-a-v1', 'mcq', 'assign oxidation numbers to find what is oxidized, what is reduced, and electrons transferred (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the reaction MnO4⁻ + 5 Fe²⁺ + 8 H⁺ → Mn²⁺ + 5 Fe³⁺ + 4 H2O, how many electrons does each MnO4⁻ gain, and which species is the reducing agent?', null, md5('apchem-mcq-b4-sv-h-4.9-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5 electrons; Fe²⁺ is the reducing agent', true, 'Correct: Mn goes +7 → +2, a gain of 5 e⁻; each Fe²⁺ loses 1 e⁻ to become Fe³⁺, so Fe²⁺ is the reducing agent.' from version_ins
union all select gen_random_uuid(), id, 'B', '7 electrons; MnO4⁻ is the reducing agent', false, 'The oxidation number of Mn in MnO4⁻ is +7, but its change is 5, and MnO4⁻ is the oxidizing agent.' from version_ins
union all select gen_random_uuid(), id, 'C', '5 electrons; MnO4⁻ is the reducing agent', false, 'The number 5 is correct, but MnO4⁻ is reduced and so is the oxidizing agent.' from version_ins
union all select gen_random_uuid(), id, 'D', '7 electrons; Fe²⁺ is the reducing agent', false, 'Fe²⁺ is the reducing agent, but 7 is the oxidation number of Mn, and not the number of electrons gained.' from version_ins;
-- apchem-mcq-b4-sv-h-4.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.9-a-v2', 'mcq', 'assign oxidation numbers to find what is oxidized, what is reduced, and electrons transferred (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the reaction CuO(s) + H2(g) → Cu(s) + H2O(g), which statement is correct?', null, md5('apchem-mcq-b4-sv-h-4.9-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H2 is reduced and is the oxidizing agent.', false, 'H2 goes from 0 to +1, so it is oxidized and it is the reducing agent.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cu²⁺ in CuO is reduced, and H2 is the reducing agent.', true, 'Correct: Cu +2 → 0 (reduced); H 0 → +1 (oxidized); O is -2 on both sides.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Oxygen is reduced from -2 to 0.', false, 'Oxygen is -2 in both CuO and H2O, and it is unchanged.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cu is oxidized from 0 to +2.', false, 'This reverses the reaction; in this reaction Cu goes from +2 to 0.' from version_ins;
-- apchem-mcq-b4-sv-h-4.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.9-a-v3', 'mcq', 'assign oxidation numbers to find what is oxidized, what is reduced, and electrons transferred (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the reaction Zn(s) + 2 Ag⁺(aq) → Zn²⁺(aq) + 2 Ag(s), how many electrons are transferred as the equation is written, and which species is the oxidizing agent?', null, md5('apchem-mcq-b4-sv-h-4.9-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 electrons; Ag⁺ is the oxidizing agent', true, 'Correct: Zn 0 → +2 loses 2 e⁻; each of 2 Ag⁺ gains 1 e⁻, so 2 e⁻ are transferred in total; Ag⁺ is reduced and so is the oxidizing agent.' from version_ins
union all select gen_random_uuid(), id, 'B', '2 electrons; Zn is the oxidizing agent', false, 'Zn is oxidized, so it is the reducing agent.' from version_ins
union all select gen_random_uuid(), id, 'C', '1 electron; Ag⁺ is the oxidizing agent', false, 'One electron is gained per Ag⁺, but the equation has 2 Ag⁺, so 2 electrons are transferred.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 electrons; Zn is the oxidizing agent', false, 'It adds the electrons lost and gained, but the same 2 electrons are lost by Zn and gained by Ag⁺, so counting them twice is incorrect.' from version_ins;
-- apchem-mcq-b4-h-4.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.9-b', 'mcq', 'recognize disproportionation, where one species is both oxidized and reduced', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the reaction 2 H2O2(aq) → 2 H2O(l) + O2(g), which statement about oxidation numbers is correct?', null, md5('apchem-mcq-b4-h-4.9-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Hydrogen is oxidized from +1 to 0.', false, 'Hydrogen is +1 in both H2O2 and H2O, and no hydrogen gas forms.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Oxygen in H2O2 is -1; it is reduced to -2 in H2O and oxidized to 0 in O2, so H2O2 is both oxidized and reduced.', true, 'Correct: H is +1 throughout; O is -1 in H2O2, -2 in H2O and 0 in O2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Oxygen is -2 in H2O2 and is only oxidized to 0 in O2, so H2O2 is only a reducing agent.', false, 'In H2O2 the oxygen is -1 (the peroxide ion has two O atoms sharing a charge of -2), and it also forms H2O at -2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is not a redox reaction, because only one reactant is present.', false, 'The number of reactants does not decide whether a reaction is redox; oxidation numbers change here.' from version_ins;
-- apchem-mcq-b4-sv-h-4.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.9-b-v1', 'mcq', 'recognize disproportionation, where one species is both oxidized and reduced (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the reaction Cl2(g) + 2 NaOH(aq) → NaCl(aq) + NaOCl(aq) + H2O(l), which statement is correct?', null, md5('apchem-mcq-b4-sv-h-4.9-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Chlorine is only reduced, because it forms the chloride ion.', false, 'Some of the chlorine also ends up as +1 in NaOCl, so it is oxidized as well.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sodium is oxidized, because it appears in both products.', false, 'Na is +1 on both sides, so it does not change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Oxygen is oxidized, because it goes from -2 in OH⁻ to -1 in NaOCl.', false, 'O is -2 in both OH⁻ and OCl⁻, because the chlorine is the element whose oxidation number is changing.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Chlorine is both oxidized and reduced, going from 0 in Cl2 to -1 in NaCl and +1 in NaOCl.', true, 'Correct: Cl 0 → -1 (reduced) and Cl 0 → +1 (oxidized); Na stays +1; O stays -2 and H stays +1.' from version_ins;
-- apchem-mcq-b4-sv-h-4.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.9-b-v2', 'mcq', 'recognize disproportionation, where one species is both oxidized and reduced (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In aqueous solution, copper(I) ions react according to 2 Cu⁺(aq) → Cu(s) + Cu²⁺(aq). Which statement is correct?', null, md5('apchem-mcq-b4-sv-h-4.9-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is not a redox reaction, because Cu appears on both sides of the equation.', false, 'The oxidation numbers of copper differ in the three species, so the reaction is redox.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cu⁺ is only reduced, because copper metal forms.', false, 'Some Cu⁺ ions are oxidized to Cu²⁺ as well.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Two electrons are transferred from each Cu⁺ ion to a neighboring ion.', false, 'Each Cu⁺ gains or loses only one electron, and 2 electrons are never transferred from a single ion.' from version_ins
union all select gen_random_uuid(), id, 'D', 'One Cu⁺ is oxidized to Cu²⁺ and the other is reduced to Cu, so Cu⁺ is both the oxidizing and the reducing agent, with 1 electron transferred.', true, 'Correct: Cu +1 → +2 (loses 1 e⁻) and Cu +1 → 0 (gains 1 e⁻); 1 electron is transferred in total.' from version_ins;
-- apchem-mcq-b4-sv-h-4.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.9-b-v3', 'mcq', 'recognize disproportionation, where one species is both oxidized and reduced (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the reaction 3 NO2(g) + H2O(l) → 2 HNO3(aq) + NO(g), which statement is correct?', null, md5('apchem-mcq-b4-sv-h-4.9-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Nitrogen is only oxidized, because HNO3 has more oxygen than NO2.', false, 'Some nitrogen is also reduced to +2 in NO, and the change in oxygen content is not what defines oxidation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Oxygen is reduced because it is -2 in NO2 and in NO.', false, 'Oxygen is -2 in NO2, HNO3, NO and H2O, so it does not change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Nitrogen is +4 in NO2, is oxidized to +5 in HNO3 and is reduced to +2 in NO, so NO2 is both oxidized and reduced.', true, 'Correct: N +4 → +5 (2 of the 3 N) and +4 → +2 (1 of the 3 N); electrons lost 2 × 1 = 2, gained 1 × 2 = 2. H (+1) and O (-2) do not change.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Hydrogen is oxidized because it forms HNO3.', false, 'Hydrogen is +1 in both H2O and HNO3, so its oxidation number does not change.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.8-b-v3','apchem-mcq-b4-h-4.9-a','apchem-mcq-b4-sv-h-4.9-a-v1','apchem-mcq-b4-sv-h-4.9-a-v2','apchem-mcq-b4-sv-h-4.9-a-v3','apchem-mcq-b4-h-4.9-b','apchem-mcq-b4-sv-h-4.9-b-v1','apchem-mcq-b4-sv-h-4.9-b-v2','apchem-mcq-b4-sv-h-4.9-b-v3']) and status='draft')<>9 then raise exception 'chunk 8: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b4-sv-h-4.8-b-v3','apchem-mcq-b4-h-4.9-a','apchem-mcq-b4-sv-h-4.9-a-v1','apchem-mcq-b4-sv-h-4.9-a-v2','apchem-mcq-b4-sv-h-4.9-a-v3','apchem-mcq-b4-h-4.9-b','apchem-mcq-b4-sv-h-4.9-b-v1','apchem-mcq-b4-sv-h-4.9-b-v2','apchem-mcq-b4-sv-h-4.9-b-v3']))<>36 then raise exception 'chunk 8: expected 36 choices'; end if;
end $$;
commit;
