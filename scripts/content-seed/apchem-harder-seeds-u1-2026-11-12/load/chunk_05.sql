begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-h-1.5-b','apchem-mcq-b6-sv-h-1.5-b-v1','apchem-mcq-b6-sv-h-1.5-b-v2','apchem-mcq-b6-sv-h-1.5-b-v3','apchem-mcq-b6-h-1.6-a','apchem-mcq-b6-sv-h-1.6-a-v1','apchem-mcq-b6-sv-h-1.6-a-v2','apchem-mcq-b6-sv-h-1.6-a-v3','apchem-mcq-b6-h-1.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apchem-mcq-b6-h-1.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.5-b', 'mcq', 'use successive ionization energies and Coulomb''s law to explain how electron-electron shielding within the same shell ch', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The energy needed to remove one electron from a species in the gas phase is listed in kJ/mol: H, 1312; He, 2372; He⁺, 5250. Each removal is of a 1s electron. Which statement best accounts for all three values?', null, md5('apchem-mcq-b6-h-1.5-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 1s electron in He is attracted by a +2 nucleus but is partly shielded by the other 1s electron, so it is held less strongly than the unshielded 1s electron in He⁺.', true, 'Correct: H, He and He⁺ all lose a 1s electron; He⁺ has no second electron to repel and feels the full +2, so 5250 > 2372, while He feels less than +2 but more than +1, so 1312 < 2372.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The 1s electron in He is at a higher energy level than in H, so less energy is needed to remove it.', false, 'Both electrons are in the n = 1 shell; the larger value for He than for H shows the nuclear charge matters, so level is not the reason.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The nuclear charge of He⁺ is larger than that of He because the ion has lost an electron.', false, 'The nuclear charge is +2 in both He and He⁺; only the number of electrons differs, and the electron-electron repulsion is what changes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The second 1s electron in He shields the first completely, so the energy to remove it would be the same as for H.', false, 'Complete shielding would make He the same as H, but the value for He is much larger than for H; the shielding is only partial.' from version_ins;
-- apchem-mcq-b6-sv-h-1.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.5-b-v1', 'mcq', 'use successive ionization energies and Coulomb''s law to explain how electron-electron shielding within the same shell ch (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The energy needed to remove a 1s electron from lithium species in the gas phase is: Li⁺ → Li²⁺, 7298 kJ/mol; Li²⁺ → Li³⁺, 11815 kJ/mol. Why does the second removal require so much more energy than the first, although both are 1s electrons in the same nucleus?', null, md5('apchem-mcq-b6-sv-h-1.5-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'In Li⁺ the two 1s electrons shield each other, so each feels less than +3; in Li²⁺ the lone 1s electron feels the full +3 charge.', true, 'Correct: Both are 1s electrons with the same +3 nucleus; electron-electron repulsion in Li⁺ partially offsets the attraction, so IE₂ < IE₃.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The remaining electron in Li²⁺ is in a lower energy level than the electron removed from Li⁺.', false, 'Both electrons occupy the n = 1 level; the energy gap is not due to a change in level.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The nucleus of Li²⁺ has a greater charge than the nucleus of Li⁺ because it has lost an electron.', false, 'Removing an electron does not change the number of protons; both species have a +3 nucleus.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two 1s electrons in Li⁺ are paired and spin-pairing makes the first electron harder to remove.', false, 'Pairing does not make the first electron harder to remove: the first removal needs less energy (7298), so the second 1s electron, feeling less repulsion, needs more.' from version_ins;
-- apchem-mcq-b6-sv-h-1.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.5-b-v2', 'mcq', 'use successive ionization energies and Coulomb''s law to explain how electron-electron shielding within the same shell ch (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The energy needed to remove a 1s electron from beryllium species in the gas phase is: Be²⁺ → Be³⁺, 14849 kJ/mol; Be³⁺ → Be⁴⁺, 21007 kJ/mol. Why does the second removal require much more energy than the first, although both are 1s electrons in the same nucleus?', null, md5('apchem-mcq-b6-sv-h-1.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 1s electron in Be³⁺ is closer to the nucleus because the nuclear charge of the ion has increased.', false, 'The nuclear charge is +4 in both species; the difference in attraction arises from loss of electron repulsion, not a change in protons.' from version_ins
union all select gen_random_uuid(), id, 'B', 'In Be²⁺ the two 1s electrons partly shield each other, but in Be³⁺ the one remaining 1s electron feels the full +4 nuclear charge.', true, 'Correct: Both removals are from n = 1 with Z = 4; shielding by the second 1s electron reduces the effective charge in Be²⁺, so 14849 < 21007.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The electron removed from Be²⁺ is in a 2s orbital, which needs less energy than a 1s electron.', false, 'Be²⁺ has the configuration 1s², so both removals are from the 1s orbital; the 2s electrons were removed earlier.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Be³⁺ has a smaller radius than Be²⁺, and a smaller radius always doubles the energy required.', false, 'A smaller radius is a consequence of the greater effective charge, not an independent cause, and no rule gives a doubling; the ratio here is 21007/14849 = 1.4.' from version_ins;
-- apchem-mcq-b6-sv-h-1.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.5-b-v3', 'mcq', 'use successive ionization energies and Coulomb''s law to explain how electron-electron shielding within the same shell ch (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The energy needed to remove a 1s electron from boron species in the gas phase is: B³⁺ → B⁴⁺, 25026 kJ/mol; B⁴⁺ → B⁵⁺, 32827 kJ/mol. Why does the second removal require more energy than the first, although both are 1s electrons in the same nucleus?', null, md5('apchem-mcq-b6-sv-h-1.5-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'B⁴⁺ has a larger nuclear charge than B³⁺ because removing an electron exposes more of the nucleus.', false, 'The nucleus has +5 in both ions; exposing the nucleus is not a change in protons, and the effect is due to reduced electron-electron repulsion.' from version_ins
union all select gen_random_uuid(), id, 'B', 'In B³⁺ the two 1s electrons partly shield each other, but in B⁴⁺ the one remaining 1s electron feels the full +5 nuclear charge.', true, 'Correct: Both removals are from n = 1 with Z = 5; losing the other 1s electron removes repulsion, so the effective charge rises and 25026 < 32827.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The first electron is removed from the 2p subshell and the second from the 1s subshell.', false, 'B³⁺ has only the 1s² electrons left; both ionizations in this question are from the 1s orbital.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The electron removed from B⁴⁺ is in a lower shell because the ion is smaller.', false, 'Both electrons are in n = 1; the smaller size of B⁴⁺ is a consequence of the reduced shielding and increased effective charge, not a different shell.' from version_ins;
-- apchem-mcq-b6-h-1.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.6-a', 'mcq', 'predict how peak positions in a photoelectron spectrum change between isoelectronic species, separating the number of el', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The photoelectron spectrum of neutral argon has five peaks with relative areas 2 : 2 : 6 : 2 : 6. A different species X gives a spectrum with five peaks in the same 2 : 2 : 6 : 2 : 6 ratio, but every peak of X is at a higher binding energy than the corresponding peak of argon. Which species could X be?', null, md5('apchem-mcq-b6-h-1.6-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cl⁻, because it has the same 18 electrons as argon, and the extra electron charge increases the binding.', false, 'Cl⁻ has the same electron count but a nuclear charge of only +17, so its electrons are bound less tightly than argon''s and every peak is at lower energy.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ca, because its electron configuration begins with the same filled subshells as argon.', false, 'Neutral Ca has twenty electrons and would show a sixth peak (4s², area 2), so it does not give five peaks in the 2 : 2 : 6 : 2 : 6 ratio.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ar⁺, because removing an electron from argon makes the remaining electrons more tightly bound.', false, 'Ar⁺ has only 17 electrons so the 3p peak would have an area of 5 rather than 6, which does not match the given ratio.' from version_ins
union all select gen_random_uuid(), id, 'D', 'K⁺, because it has the same 18 electrons as argon but a nuclear charge of +19 instead of +18, so every electron is held more tightly.', true, 'Correct: The 2 : 2 : 6 : 2 : 6 ratio means 18 electrons in 1s, 2s, 2p, 3s, 3p; higher binding energies require a nuclear charge above +18, which fits K⁺ (+19).' from version_ins;
-- apchem-mcq-b6-sv-h-1.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.6-a-v1', 'mcq', 'predict how peak positions in a photoelectron spectrum change between isoelectronic species, separating the number of el (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The photoelectron spectrum of neutral neon has three peaks with relative areas 2 : 2 : 6. A different species X gives a spectrum with three peaks in the same 2 : 2 : 6 ratio, but every peak of X is at a higher binding energy than the corresponding peak of neon. Which species could X be?', null, md5('apchem-mcq-b6-sv-h-1.6-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'F⁻, because it has the same 10 electrons as neon and an additional electron adds to the attraction.', false, 'F⁻ has the same 10 electrons but a nuclear charge of only +9, so its electrons are bound more weakly and all peaks lie at lower energy than neon''s.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mg, because it has the same filled subshells as neon plus extra electrons held by a larger nuclear charge.', false, 'Neutral Mg has twelve electrons and a fourth peak (3s², area 2), so it would not give just three peaks.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Na⁺, because it has the same 10 electrons as neon but a nuclear charge of +11 instead of +10, so every electron is held more tightly.', true, 'Correct: Ratios 2 : 2 : 6 mean 10 electrons; peaks at higher energy require a nuclear charge above +10, which fits Na⁺ (+11).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ne⁺, because removing an electron makes the remaining electrons more tightly bound.', false, 'Ne⁺ has 9 electrons, so the 2p peak has an area of 5 instead of 6, which does not match the 2 : 2 : 6 ratio.' from version_ins;
-- apchem-mcq-b6-sv-h-1.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.6-a-v2', 'mcq', 'predict how peak positions in a photoelectron spectrum change between isoelectronic species, separating the number of el (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The photoelectron spectrum of neutral helium has one peak with relative area 2. A different species X gives a spectrum with a single peak of relative area 2, but at a higher binding energy than that of helium. Which species could X be?', null, md5('apchem-mcq-b6-sv-h-1.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H⁻, because it has the same two electrons as helium and a charge that adds to the binding.', false, 'H⁻ has two electrons but a nuclear charge of only +1, so its electrons are held more weakly than helium''s and the peak is at lower energy.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Li, because lithium has a larger nuclear charge than helium.', false, 'Neutral Li has three electrons, so its spectrum has two peaks, with areas 2 and 1, and not a single peak of area 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Li⁺, because it has the same two electrons as helium but a nuclear charge of +3 instead of +2, so the electrons are held more tightly.', true, 'Correct: A single peak of area 2 means two 1s electrons; a higher binding energy requires a nuclear charge above +2, which fits Li⁺ (+3).' from version_ins
union all select gen_random_uuid(), id, 'D', 'He⁺, because removing an electron makes the remaining electron more tightly bound.', false, 'He⁺ has only one electron, so its single peak would have an area of 1 and not 2.' from version_ins;
-- apchem-mcq-b6-sv-h-1.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.6-a-v3', 'mcq', 'predict how peak positions in a photoelectron spectrum change between isoelectronic species, separating the number of el (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The photoelectron spectrum of neutral argon has five peaks with relative areas 2 : 2 : 6 : 2 : 6. A different species X gives a spectrum with five peaks in the same 2 : 2 : 6 : 2 : 6 ratio, but every peak of X is at a lower binding energy than the corresponding peak of argon. Which species could X be?', null, md5('apchem-mcq-b6-sv-h-1.6-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'S²⁻, because it has the same 18 electrons as argon but a nuclear charge of +16, so every electron is held less tightly.', true, 'Correct: Ratios 2 : 2 : 6 : 2 : 6 mean 18 electrons; lower binding energies need a nuclear charge below +18, which fits S²⁻ (+16).' from version_ins
union all select gen_random_uuid(), id, 'B', 'K⁺, because ions of metals have the same electron count as argon and a more favorable arrangement.', false, 'K⁺ has the same 18 electrons but a nuclear charge of +19, so its peaks are at higher binding energy, not lower.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cl, because a chlorine atom is next to argon in the periodic table and has similar peaks.', false, 'Neutral Cl has 17 electrons, so its 3p peak has an area of 5, not 6, which does not match the ratio.' from version_ins
union all select gen_random_uuid(), id, 'D', 'K, because neutral potassium has the same inner shells as argon but a lower first ionization energy.', false, 'Neutral K has 19 electrons and a sixth peak (4s¹, area 1), so it does not give five peaks in this ratio.' from version_ins;
-- apchem-mcq-b6-h-1.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.6-b', 'mcq', 'identify an element whose photoelectron spectrum reveals an anomalous (non-aufbau) valence configuration, rejecting the ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The photoelectron spectrum of a neutral atom of an element shows seven peaks. From highest to lowest binding energy, the relative peak areas are 2, 2, 6, 2, 6, 5 and 1. Which element is it?', null, md5('apchem-mcq-b6-h-1.6-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mn, because manganese has a half-filled 3d subshell.', false, 'Mn is 3d⁵4s², whose last two peaks would have areas 5 and 2, not 5 and 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'V, because vanadium has a 3d subshell and a 4s subshell that are both partly filled.', false, 'V is 3d³4s², whose last two peaks would have areas 3 and 2, not 5 and 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fe, because iron has six 3d electrons and a half-filled 3d subshell is not required.', false, 'Fe is 3d⁶4s², whose last two peaks would have areas 6 and 2, not 5 and 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cr, because the last two peaks, 3d⁵ and 4s¹, correspond to the configuration [Ar]3d⁵4s¹.', true, 'Correct: Total electrons = 2 + 2 + 6 + 2 + 6 + 5 + 1 = 24, atomic number 24, chromium; the unusual 5 : 1 split is the half-filled configuration [Ar]3d⁵4s¹.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-h-1.5-b','apchem-mcq-b6-sv-h-1.5-b-v1','apchem-mcq-b6-sv-h-1.5-b-v2','apchem-mcq-b6-sv-h-1.5-b-v3','apchem-mcq-b6-h-1.6-a','apchem-mcq-b6-sv-h-1.6-a-v1','apchem-mcq-b6-sv-h-1.6-a-v2','apchem-mcq-b6-sv-h-1.6-a-v3','apchem-mcq-b6-h-1.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b6-h-1.5-b','apchem-mcq-b6-sv-h-1.5-b-v1','apchem-mcq-b6-sv-h-1.5-b-v2','apchem-mcq-b6-sv-h-1.5-b-v3','apchem-mcq-b6-h-1.6-a','apchem-mcq-b6-sv-h-1.6-a-v1','apchem-mcq-b6-sv-h-1.6-a-v2','apchem-mcq-b6-sv-h-1.6-a-v3','apchem-mcq-b6-h-1.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
