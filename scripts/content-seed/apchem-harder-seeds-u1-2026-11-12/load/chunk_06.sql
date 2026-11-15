begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.6-b-v1','apchem-mcq-b6-sv-h-1.6-b-v2','apchem-mcq-b6-sv-h-1.6-b-v3','apchem-mcq-b6-h-1.7-a','apchem-mcq-b6-sv-h-1.7-a-v1','apchem-mcq-b6-sv-h-1.7-a-v2','apchem-mcq-b6-sv-h-1.7-a-v3','apchem-mcq-b6-h-1.7-b','apchem-mcq-b6-sv-h-1.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apchem-mcq-b6-sv-h-1.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.6-b-v1', 'mcq', 'identify an element whose photoelectron spectrum reveals an anomalous (non-aufbau) valence configuration, rejecting the  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The photoelectron spectrum of a neutral atom of an element shows seven peaks. From highest to lowest binding energy, the relative peak areas are 2, 2, 6, 2, 6, 10 and 1. Which element is it?', null, md5('apchem-mcq-b6-sv-h-1.6-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Zn, because zinc has a filled 3d subshell.', false, 'Zn is 3d¹⁰4s², whose last two peaks would have areas 10 and 2, not 10 and 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ni, because nickel is next to copper and has a 3d subshell close to full.', false, 'Ni is 3d⁸4s², whose last two peaks would have areas 8 and 2, not 10 and 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cu, because the last two peaks, 3d¹⁰ and 4s¹, correspond to the configuration [Ar]3d¹⁰4s¹.', true, 'Correct: Total electrons = 2 + 2 + 6 + 2 + 6 + 10 + 1 = 29, atomic number 29, copper; the aufbau prediction of 3d⁹4s² would give areas of 9 and 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ga, because gallium has a filled 3d subshell and a single electron in a higher subshell.', false, 'Ga is 3d¹⁰4s²4p¹, which would show eight peaks, with a 4p peak of area 1 after a 4s peak of area 2.' from version_ins;
-- apchem-mcq-b6-sv-h-1.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.6-b-v2', 'mcq', 'identify an element whose photoelectron spectrum reveals an anomalous (non-aufbau) valence configuration, rejecting the  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The photoelectron spectrum of a neutral atom of an element shows nine peaks. From highest to lowest binding energy, the relative peak areas are 2, 2, 6, 2, 6, 10, 2, 6 and 10. Which element is it?', null, md5('apchem-mcq-b6-sv-h-1.6-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cd, because cadmium has a completely filled 4d subshell.', false, 'Cd is 4d¹⁰5s² and would show a tenth peak of area 2 for the 5s electrons.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ag, because silver has a filled 4d subshell.', false, 'Ag is 4d¹⁰5s¹ and would show a tenth peak of area 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Pd, because the highest subshell filled is 4d¹⁰ and there is no 5s peak.', true, 'Correct: Total electrons = 2 + 2 + 6 + 2 + 6 + 10 + 2 + 6 + 10 = 46, atomic number 46, palladium; it is the 4d¹⁰5s⁰ exception.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ru, because the aufbau prediction for the element has eight 4d electrons.', false, 'Ru is 4d⁷5s¹ and would show a 4d peak of area 7 and a 5s peak of area 1, giving ten peaks.' from version_ins;
-- apchem-mcq-b6-sv-h-1.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.6-b-v3', 'mcq', 'identify an element whose photoelectron spectrum reveals an anomalous (non-aufbau) valence configuration, rejecting the  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The photoelectron spectrum of a neutral atom of an element shows ten peaks. From highest to lowest binding energy, the relative peak areas are 2, 2, 6, 2, 6, 10, 2, 6, 5 and 1. Which element is it?', null, md5('apchem-mcq-b6-sv-h-1.6-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Tc, because technetium also has five 4d electrons.', false, 'Tc is 4d⁵5s², whose last two peaks would have areas 5 and 2, not 5 and 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Nb, because niobium has a 5s peak of area 1.', false, 'Nb is 4d⁴5s¹, whose last two peaks would have areas 4 and 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ru, because ruthenium has a 5s peak of area 1 and a half-filled 4d subshell.', false, 'Ru is 4d⁷5s¹, whose 4d peak has an area of 7, not 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mo, because the last two peaks, 4d⁵ and 5s¹, correspond to the configuration [Kr]4d⁵5s¹.', true, 'Correct: Total electrons = 2 + 2 + 6 + 2 + 6 + 10 + 2 + 6 + 5 + 1 = 42, atomic number 42, molybdenum; the 5 : 1 split is the half-filled exception [Kr]4d⁵5s¹.' from version_ins;
-- apchem-mcq-b6-h-1.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.7-a', 'mcq', 'identify the number of valence electrons from the position of the largest jump in successive ionization energies and so ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The first five successive ionization energies of an element X are 578, 1817, 2745, 11577 and 14842 kJ/mol. Element X forms a compound XClₙ with chlorine in which X uses all of its valence electrons. Which formula and justification are consistent with these data?', null, md5('apchem-mcq-b6-h-1.7-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'XCl₄, because the fourth ionization energy is the first very large value, so four electrons must be used.', false, 'The large value of IE₄ shows that the fourth electron comes from an inner shell; the valence electrons are the three removed before the jump.' from version_ins
union all select gen_random_uuid(), id, 'B', 'XCl, because the first ionization energy is the lowest and only one electron is removed easily.', false, 'IE₂ and IE₃ are only 3 to 5 times IE₁, far less than the jump at IE₄, so three electrons are valence, not one.' from version_ins
union all select gen_random_uuid(), id, 'C', 'XCl₅, because five ionization energies are listed and each corresponds to a bond.', false, 'The number of values given is arbitrary; the jump at IE₄ locates the end of the valence shell.' from version_ins
union all select gen_random_uuid(), id, 'D', 'XCl₃, because the large jump occurs between the third and fourth ionization energies, so there are three valence electrons.', true, 'Correct: Ratios of successive IE: 3.1, 1.5, 4.2, 1.3; the 4.2 jump (IE₄/IE₃) marks the inner core, so X has three valence electrons.' from version_ins;
-- apchem-mcq-b6-sv-h-1.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.7-a-v1', 'mcq', 'identify the number of valence electrons from the position of the largest jump in successive ionization energies and so  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The first five successive ionization energies of an element X are 496, 4562, 6910, 9543 and 13354 kJ/mol. Element X forms a compound XClₙ with chlorine in which X uses all of its valence electrons. Which formula and justification are consistent with these data?', null, md5('apchem-mcq-b6-sv-h-1.7-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'XCl₂, because the second ionization energy is the first value that is very large, so two electrons are used.', false, 'The large IE₂ shows that the second electron is removed from an inner shell; the valence electron count is the number removed before the jump, one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'XCl, because the very large jump occurs between the first and second ionization energies, so there is one valence electron.', true, 'Correct: Ratios of successive IE: 9.2, 1.5, 1.4, 1.4; the first ratio is the only large jump, so X has one valence electron.' from version_ins
union all select gen_random_uuid(), id, 'C', 'XCl₃, because the first three ionization energies are all below 7000 kJ/mol.', false, 'A cutoff in absolute value is not the criterion; the relative jump of IE₂ over IE₁ (about 9 times) is the evidence of a core.' from version_ins
union all select gen_random_uuid(), id, 'D', 'XCl₅, because five ionization energies are listed and each corresponds to a bond.', false, 'The number of values listed is arbitrary; only the jump at IE₂ locates the end of the valence shell.' from version_ins;
-- apchem-mcq-b6-sv-h-1.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.7-a-v2', 'mcq', 'identify the number of valence electrons from the position of the largest jump in successive ionization energies and so  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The first five successive ionization energies of an element X are 590, 1145, 4912, 6491 and 8153 kJ/mol. Element X forms a compound XClₙ with chlorine in which X uses all of its valence electrons. Which formula and justification are consistent with these data?', null, md5('apchem-mcq-b6-sv-h-1.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'XCl₃, because the third ionization energy is the first very large value, so three electrons must be used.', false, 'The large IE₃ shows the third electron comes from an inner shell; the valence electrons are the two removed before the jump.' from version_ins
union all select gen_random_uuid(), id, 'B', 'XCl, because the first ionization energy is the smallest, so only one electron is lost.', false, 'IE₂ is only about twice IE₁; the large jump is between IE₂ and IE₃, which means two valence electrons.' from version_ins
union all select gen_random_uuid(), id, 'C', 'XCl₂, because the large jump occurs between the second and third ionization energies, so there are two valence electrons.', true, 'Correct: Ratios of successive IE: 1.9, 4.3, 1.3, 1.3; the 4.3 jump (IE₃/IE₂) marks the core, so X has two valence electrons.' from version_ins
union all select gen_random_uuid(), id, 'D', 'XCl₅, because five ionization energies are listed and each corresponds to a bond.', false, 'The number of values given is arbitrary; only the jump at IE₃ locates the end of the valence shell.' from version_ins;
-- apchem-mcq-b6-sv-h-1.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.7-a-v3', 'mcq', 'identify the number of valence electrons from the position of the largest jump in successive ionization energies and so  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The first five successive ionization energies of an element X are 786, 1577, 3232, 4356 and 16091 kJ/mol. Element X forms a compound XClₙ with chlorine in which X uses all of its valence electrons. Which formula and justification are consistent with these data?', null, md5('apchem-mcq-b6-sv-h-1.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'XCl₄, because the large jump occurs between the fourth and fifth ionization energies, so there are four valence electrons.', true, 'Correct: Ratios of successive IE: 2.0, 2.0, 1.3, 3.7; the 3.7 jump (IE₅/IE₄) marks the core, so X has four valence electrons.' from version_ins
union all select gen_random_uuid(), id, 'B', 'XCl₅, because the fifth ionization energy is the first very large value, so five electrons must be used.', false, 'The large IE₅ shows that the fifth electron comes from an inner shell; the valence electrons are the four removed before the jump.' from version_ins
union all select gen_random_uuid(), id, 'C', 'XCl₂, because the first two ionization energies are the smallest and most easily removed.', false, 'IE₃ and IE₄ are only 2.0 and 1.3 times the preceding value; the jump at IE₅ (3.7 times IE₄) shows four valence electrons.' from version_ins
union all select gen_random_uuid(), id, 'D', 'XCl, because the first ionization energy is the lowest and only one electron is lost.', false, 'IE₂ is only about twice IE₁; the jump at IE₅ shows there are four valence electrons.' from version_ins;
-- apchem-mcq-b6-h-1.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.7-b', 'mcq', 'order the radii of isoelectronic ions by using nuclear charge with a fixed electron count, resisting the trends for neut', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the ions O²⁻, F⁻, Na⁺ and Mg²⁺, which all have 10 electrons. Which list gives them in order of decreasing radius, with the correct reason?', null, md5('apchem-mcq-b6-h-1.7-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'O²⁻ > F⁻ > Na⁺ > Mg²⁺, because each has the same number of electrons, so the ion with the fewest protons holds them least tightly.', true, 'Correct: All have 1s²2s²2p⁶; the nuclear charges are +8, +9, +11 and +12, so attraction increases and radius decreases from O²⁻ to Mg²⁺.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Na⁺ > Mg²⁺ > O²⁻ > F⁻, because atomic radius decreases from left to right across a period and sodium is at the left.', false, 'This applies the trend for neutral atoms, but these ions all have 10 electrons in n = 2, so nuclear charge alone decides: the cations are smaller than the anions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mg²⁺ > Na⁺ > F⁻ > O²⁻, because the ion with the most protons has the most positive charge to hold the electrons far away.', false, 'More protons pull the 10 electrons in more strongly, so Mg²⁺ with +12 is the smallest, not the largest.' from version_ins
union all select gen_random_uuid(), id, 'D', 'O²⁻ > Mg²⁺ > F⁻ > Na⁺, because larger charge magnitude means a larger ion whether positive or negative.', false, 'Radius is not set by charge magnitude; Mg²⁺ with 12 protons holds the 10 electrons more tightly than F⁻ with 9, so Mg²⁺ is smaller than F⁻.' from version_ins;
-- apchem-mcq-b6-sv-h-1.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.7-b-v1', 'mcq', 'order the radii of isoelectronic ions by using nuclear charge with a fixed electron count, resisting the trends for neut (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the ions S²⁻, Cl⁻, K⁺ and Ca²⁺, which all have 18 electrons. Which list gives them in order of decreasing radius, with the correct reason?', null, md5('apchem-mcq-b6-sv-h-1.7-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'K⁺ > Ca²⁺ > S²⁻ > Cl⁻, because the atoms in period 4 are larger than the atoms in period 3.', false, 'K and Ca atoms are larger than S and Cl atoms, but the ions have identical electron configurations, so the number of protons decides the radius.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ca²⁺ > K⁺ > Cl⁻ > S²⁻, because more protons make the electron cloud larger.', false, 'More protons attract the same 18 electrons more strongly, so Ca²⁺ is the smallest of the four.' from version_ins
union all select gen_random_uuid(), id, 'C', 'S²⁻ > Cl⁻ > K⁺ > Ca²⁺, because each has the same number of electrons, so the ion with the fewest protons holds them least tightly.', true, 'Correct: All have 1s²2s²2p⁶3s²3p⁶; the nuclear charges are +16, +17, +19 and +20, so radius decreases from S²⁻ to Ca²⁺.' from version_ins
union all select gen_random_uuid(), id, 'D', 'S²⁻ > Ca²⁺ > Cl⁻ > K⁺, because radius increases with the magnitude of the charge.', false, 'Charge magnitude does not set the radius; Ca²⁺ has 20 protons holding 18 electrons, so it is smaller than Cl⁻ with 17 protons.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.6-b-v1','apchem-mcq-b6-sv-h-1.6-b-v2','apchem-mcq-b6-sv-h-1.6-b-v3','apchem-mcq-b6-h-1.7-a','apchem-mcq-b6-sv-h-1.7-a-v1','apchem-mcq-b6-sv-h-1.7-a-v2','apchem-mcq-b6-sv-h-1.7-a-v3','apchem-mcq-b6-h-1.7-b','apchem-mcq-b6-sv-h-1.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b6-sv-h-1.6-b-v1','apchem-mcq-b6-sv-h-1.6-b-v2','apchem-mcq-b6-sv-h-1.6-b-v3','apchem-mcq-b6-h-1.7-a','apchem-mcq-b6-sv-h-1.7-a-v1','apchem-mcq-b6-sv-h-1.7-a-v2','apchem-mcq-b6-sv-h-1.7-a-v3','apchem-mcq-b6-h-1.7-b','apchem-mcq-b6-sv-h-1.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
