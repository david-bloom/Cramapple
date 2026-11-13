begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.7-b-v2','apchem-mcq-b4-sv-h-4.7-b-v3','apchem-mcq-b4-h-4.8-a','apchem-mcq-b4-sv-h-4.8-a-v1','apchem-mcq-b4-sv-h-4.8-a-v2','apchem-mcq-b4-sv-h-4.8-a-v3','apchem-mcq-b4-h-4.8-b','apchem-mcq-b4-sv-h-4.8-b-v1','apchem-mcq-b4-sv-h-4.8-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apchem-mcq-b4-sv-h-4.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.7-b-v2', 'mcq', 'combine reaction-type patterns with oxidation numbers to see that type does not decide redox (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which reaction is a synthesis reaction that is also an oxidation-reduction reaction?', null, md5('apchem-mcq-b4-sv-h-4.7-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'SO3 + H2O → H2SO4', false, 'It is a synthesis, but S stays +6, O stays -2 and H stays +1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'NH3 + HCl → NH4Cl', false, 'It is a synthesis in which a proton transfers, but no oxidation numbers change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Na2O + H2O → 2 NaOH', false, 'It is a synthesis in which no element changes its oxidation number.' from version_ins
union all select gen_random_uuid(), id, 'D', 'N2 + 3 H2 → 2 NH3', true, 'Correct: in N2 + 3 H2 → 2 NH3, N goes 0 → -3 and H goes 0 → +1; in the others no oxidation numbers change.' from version_ins;
-- apchem-mcq-b4-sv-h-4.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.7-b-v3', 'mcq', 'combine reaction-type patterns with oxidation numbers to see that type does not decide redox (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which reaction is NOT an oxidation-reduction reaction?', null, md5('apchem-mcq-b4-sv-h-4.7-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cl2 + 2 KBr → 2 KCl + Br2', false, 'Cl goes 0 → -1 and Br goes -1 → 0, so it is redox.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fe + CuSO4 → FeSO4 + Cu', false, 'Fe goes 0 → +2 and Cu goes +2 → 0, so it is redox.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mg + 2 HCl → MgCl2 + H2', false, 'Mg goes 0 → +2 and H goes +1 → 0, so it is redox.' from version_ins
union all select gen_random_uuid(), id, 'D', 'BaCl2 + Na2SO4 → BaSO4 + 2 NaCl', true, 'Correct: in the precipitation reaction all ions keep their charges (Ba +2, Cl -1, Na +1, SO4 -2).' from version_ins;
-- apchem-mcq-b4-h-4.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.8-a', 'mcq', 'recognize an amphiprotic species as an acid with a base and a base with an acid', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the reactions of hydrogencarbonate ion, HCO3⁻, with aqueous NaOH and with aqueous HCl. Which statement correctly describes the role of HCO3⁻ in these reactions?', null, md5('apchem-mcq-b4-h-4.8-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is an acid in both reactions, because it contains a hydrogen atom.', false, 'An ion acts as an acid only if it can give a proton to a base, and with H3O⁺ it accepts one instead.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It acts as an acid with OH⁻ (donating H⁺ to form CO3²⁻) and as a base with H3O⁺ (accepting H⁺ to form H2CO3).', true, 'Correct: HCO3⁻ + OH⁻ → CO3²⁻ + H2O (donates H⁺); HCO3⁻ + H3O⁺ → H2CO3 + H2O (accepts H⁺).' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is a base in both reactions, because it carries a negative charge.', false, 'Charge does not decide the role; HCO3⁻ can still donate its H⁺ to a strong base like OH⁻.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It acts as a base with OH⁻ (accepting H⁺) and as an acid with H3O⁺ (donating H⁺).', false, 'OH⁻ has no H⁺ to give to HCO3⁻, so HCO3⁻ cannot accept a proton from it, and H3O⁺ is a proton donor.' from version_ins;
-- apchem-mcq-b4-sv-h-4.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.8-a-v1', 'mcq', 'recognize an amphiprotic species as an acid with a base and a base with an acid (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which pair gives the products formed when HPO4²⁻ reacts with OH⁻ and with H3O⁺, respectively?', null, md5('apchem-mcq-b4-sv-h-4.8-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H2PO4⁻ with OH⁻, and PO4³⁻ with H3O⁺', false, 'It reverses the roles; OH⁻ takes H⁺ from the ion, and H3O⁺ gives H⁺ to it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H2PO4⁻ with both OH⁻ and H3O⁺', false, 'HPO4²⁻ cannot accept a proton from OH⁻, so H2PO4⁻ cannot form with it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'PO4³⁻ with OH⁻, and H3PO4 with H3O⁺', false, 'A single reaction with H3O⁺ transfers one proton, giving H2PO4⁻, and not two protons giving H3PO4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'PO4³⁻ with OH⁻, and H2PO4⁻ with H3O⁺', true, 'Correct: with OH⁻, HPO4²⁻ donates H⁺ → PO4³⁻ + H2O; with H3O⁺, it accepts one H⁺ → H2PO4⁻ + H2O.' from version_ins;
-- apchem-mcq-b4-sv-h-4.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.8-a-v2', 'mcq', 'recognize an amphiprotic species as an acid with a base and a base with an acid (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water reacts with NH3 and, separately, with HF. Which statement correctly describes the role of H2O in these two reactions?', null, md5('apchem-mcq-b4-sv-h-4.8-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is an acid with NH3 (forming NH4⁺ and OH⁻) and a base with HF (forming H3O⁺ and F⁻).', true, 'Correct: NH3 + H2O ⇌ NH4⁺ + OH⁻ (H2O donates H⁺); HF + H2O ⇌ H3O⁺ + F⁻ (H2O accepts H⁺).' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is a base with NH3 and an acid with HF.', false, 'This reverses the roles; NH3 is a base and accepts H⁺ from water, and HF donates H⁺ to water.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is an acid in both reactions, because it contains hydrogen.', false, 'In the reaction with HF, water accepts a proton to form H3O⁺, so it is a base there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is neither, because water is neutral and does not transfer protons.', false, 'A neutral molecule can still donate or accept protons, and water is amphiprotic.' from version_ins;
-- apchem-mcq-b4-sv-h-4.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.8-a-v3', 'mcq', 'recognize an amphiprotic species as an acid with a base and a base with an acid (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the reaction HS⁻ + NH4⁺ → H2S + NH3, which two pairs are the conjugate acid-base pairs?', null, md5('apchem-mcq-b4-sv-h-4.8-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'HS⁻ / NH4⁺ and H2S / NH3', false, 'These pair species from opposite sides of the proton transfer, but a conjugate pair differs by only one H⁺.' from version_ins
union all select gen_random_uuid(), id, 'B', 'HS⁻ / NH3 and H2S / NH4⁺', false, 'HS⁻ and NH3 do not differ by a proton, so they are not a pair.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H2S / HS⁻ and NH4⁺ / NH3', true, 'Correct: NH4⁺ donates H⁺ to HS⁻, so the pairs differ by one H⁺: NH4⁺ / NH3 and H2S / HS⁻.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H2S / S²⁻ and NH4⁺ / NH3', false, 'S²⁻ does not appear in the reaction; the conjugate base of H2S here is HS⁻.' from version_ins;
-- apchem-mcq-b4-h-4.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.8-b', 'mcq', 'separate acid strength from the amount of base needed for neutralization', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two flasks each contain 25.0 mL of 0.100 M acid. Flask 1 holds HCl, a strong acid, and flask 2 holds CH3COOH, a weak acid. Each is titrated with 0.100 M NaOH to its equivalence point. Which statement compares the volumes of NaOH required?', null, md5('apchem-mcq-b4-h-4.8-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both need 25.0 mL, because the flasks contain equal moles of acid, and the un-ionized CH3COOH reacts as the NaOH removes the H⁺ that has formed.', true, 'Correct: each flask contains 0.0250 L × 0.100 M = 2.50 mmol of acid, and each acid reacts 1:1 with NaOH, so each needs 25.0 mL.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Flask 1 needs more NaOH, because HCl produces more H⁺ in solution.', false, 'Strength tells the degree of ionization, not the total number of acidic protons available for neutralization.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Flask 2 needs less NaOH, because only the small fraction of CH3COOH that is ionized can be neutralized.', false, 'As OH⁻ removes H⁺, more CH3COOH ionizes (Le Chatelier), so all of it is eventually neutralized.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Flask 2 needs more NaOH, because a weak acid is harder to neutralize.', false, 'A weak acid has a different pH profile, but neutralization needs the same moles of OH⁻ for the same moles of acid.' from version_ins;
-- apchem-mcq-b4-sv-h-4.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.8-b-v1', 'mcq', 'separate acid strength from the amount of base needed for neutralization (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which sample requires more 0.100 M NaOH to reach its equivalence point: 100.0 mL of 0.100 M HCl or 50.0 mL of 0.300 M CH3COOH?', null, md5('apchem-mcq-b4-sv-h-4.8-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The CH3COOH, because it contains 15.0 mmol of acid and the HCl contains only 10.0 mmol.', true, 'Correct: HCl: 100.0 mL × 0.100 M = 10.0 mmol; CH3COOH: 50.0 mL × 0.300 M = 15.0 mmol; each is monoprotic, so CH3COOH needs 150 mL and HCl needs 100 mL.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The HCl, because it is a strong acid.', false, 'Strong acids are not neutralized with more base; the moles of acid decide.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both need the same volume, because each acid reacts 1:1 with NaOH.', false, 'The 1:1 ratio is true, but the two samples contain different moles of acid.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The HCl, because its volume is larger.', false, 'Volume alone does not decide it, since concentration matters, and the product gives the moles.' from version_ins;
-- apchem-mcq-b4-sv-h-4.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.8-b-v2', 'mcq', 'separate acid strength from the amount of base needed for neutralization (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two 25.0 mL samples, one of 0.100 M HCl and one of 0.100 M H2SO4, are each titrated with 0.100 M NaOH until both acidic protons of each acid are neutralized. Which statement compares the volumes of NaOH required?', null, md5('apchem-mcq-b4-sv-h-4.8-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'They are equal, because the acids have the same concentration and volume.', false, 'Equal concentration does not mean equal moles of H⁺, because H2SO4 is diprotic.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H2SO4 needs twice as much, because each H2SO4 supplies two H⁺ to be neutralized.', true, 'Correct: HCl: 2.50 mmol → 25.0 mL; H2SO4: 2.50 mmol × 2 = 5.00 mmol H⁺ → 50.0 mL.' from version_ins
union all select gen_random_uuid(), id, 'C', 'HCl needs twice as much, because it is the stronger acid.', false, 'Acid strength does not change the amount of base needed for complete neutralization.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H2SO4 needs 1.5 times as much, because its second H⁺ is only partly ionized.', false, 'The second proton of H2SO4 is neutralized by the NaOH as well as the first, so the factor is 2 and not 1.5.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.7-b-v2','apchem-mcq-b4-sv-h-4.7-b-v3','apchem-mcq-b4-h-4.8-a','apchem-mcq-b4-sv-h-4.8-a-v1','apchem-mcq-b4-sv-h-4.8-a-v2','apchem-mcq-b4-sv-h-4.8-a-v3','apchem-mcq-b4-h-4.8-b','apchem-mcq-b4-sv-h-4.8-b-v1','apchem-mcq-b4-sv-h-4.8-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b4-sv-h-4.7-b-v2','apchem-mcq-b4-sv-h-4.7-b-v3','apchem-mcq-b4-h-4.8-a','apchem-mcq-b4-sv-h-4.8-a-v1','apchem-mcq-b4-sv-h-4.8-a-v2','apchem-mcq-b4-sv-h-4.8-a-v3','apchem-mcq-b4-h-4.8-b','apchem-mcq-b4-sv-h-4.8-b-v1','apchem-mcq-b4-sv-h-4.8-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
