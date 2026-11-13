begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-sv-h-2.4-a-v3','apchem-mcq-b5-h-2.4-b','apchem-mcq-b5-sv-h-2.4-b-v1','apchem-mcq-b5-sv-h-2.4-b-v2','apchem-mcq-b5-sv-h-2.4-b-v3','apchem-mcq-b5-h-2.5-a','apchem-mcq-b5-sv-h-2.5-a-v1','apchem-mcq-b5-sv-h-2.5-a-v2','apchem-mcq-b5-sv-h-2.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apchem-mcq-b5-sv-h-2.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.4-a-v3', 'mcq', 'use atomic radii to identify the type of alloy and explain the change in hardness at the particle level (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure metal D (atomic radius 125 pm) is melted with an equal number of atoms of metal E (atomic radius 131 pm). The alloy is harder than pure D and conducts electricity. Which particle-level explanation best accounts for these observations?', null, md5('apchem-mcq-b5-sv-h-2.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Atoms of E occupy the spaces between atoms of D, because E atoms are larger and fill gaps better.', false, 'Interstitial atoms must be much smaller than the host atoms, and E at 131 pm is slightly larger than D, so it cannot fit into the gaps.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Atoms of E transfer electrons to atoms of D, so the alloy is a hard ionic solid that conducts only when molten.', false, 'Two metals do not transfer electrons to form an ionic solid, and the alloy conducts as a solid.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Atoms of E and D form network covalent bonds, which are directional and prevent conduction.', false, 'The alloy conducts electricity, which a network covalent solid with localized electrons would not do.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Atoms of E substitute for atoms of D in the lattice, and the difference in size disrupts the regular layers so they slide less easily, while delocalized electrons are retained.', true, 'Correct: radii of 125 and 131 pm are within about 5 percent, so E replaces D atoms in the lattice (substitutional alloy); the metallic bonding and conductivity are retained.' from version_ins;
-- apchem-mcq-b5-h-2.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.4-b', 'mcq', 'explain trends in metallic melting temperature using the number of delocalized electrons per atom and the size of the me', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Melting temperatures: sodium, Na, 98°C; potassium, K, 63°C; magnesium, Mg, 650°C. Which statement is consistent with all three values?', null, md5('apchem-mcq-b5-h-2.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Melting temperature rises with atomic mass, because heavier atoms need more energy to move.', false, 'K is heavier than Na and Mg is lighter than K, yet K melts lower than Na and Mg melts far higher than K, so mass does not predict the trend.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Melting temperature depends on both the number of delocalized electrons each atom contributes and the size of the metal cores; Mg has two electrons per atom and K has the largest cores, so Mg melts highest and K lowest.', true, 'Correct: K (63°C) is heavier and larger than Na (98°C) and melts lower, so larger cores weaken the attraction; Mg (650°C) contributes two delocalized electrons and has a smaller core, so it has the stronger metallic bonding.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Melting temperature rises as the metal cores get larger, because larger cores hold more electrons in the sea.', false, 'K has larger cores than Na and melts lower, so larger cores do not give higher melting temperatures.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Magnesium melts highest because it forms ionic bonds with itself by giving up two electrons, whereas sodium and potassium form metallic bonds.', false, 'Magnesium metal is held together by metallic bonding, as are sodium and potassium, and a metal does not form ionic bonds with its own atoms.' from version_ins;
-- apchem-mcq-b5-sv-h-2.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.4-b-v1', 'mcq', 'explain trends in metallic melting temperature using the number of delocalized electrons per atom and the size of the me (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Melting temperatures: lithium, Li, 181°C; rubidium, Rb, 39°C; barium, Ba, 727°C. Which statement is consistent with all three values?', null, md5('apchem-mcq-b5-sv-h-2.4-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Rb melts lowest because its heavier atoms vibrate more slowly, so it needs less energy to melt.', false, 'Slower vibration of heavier atoms is not a factor that sets the strength of metallic bonding, and the trend follows core size and electron count.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ba melts highest because it is a metal with more protons, and the number of protons alone sets the melting temperature.', false, 'Rb has more protons than Li but melts lower, so proton count alone cannot determine melting temperature.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Attraction between cores and delocalized electrons is strengthened by more electrons per atom and by smaller cores, so Ba (two electrons) melts highest and Rb (large cores) melts lowest.', true, 'Correct: Li (181) > Rb (39) shows that larger cores lower the melting temperature within a group; Ba (727) shows that two electrons per atom raise it greatly.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Li melts higher than Rb because Li atoms are held together by ionic bonds and Rb atoms are not.', false, 'Lithium and rubidium are both metals held by metallic bonding, and neither forms ionic bonds with its own atoms.' from version_ins;
-- apchem-mcq-b5-sv-h-2.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.4-b-v2', 'mcq', 'explain trends in metallic melting temperature using the number of delocalized electrons per atom and the size of the me (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Melting temperatures: sodium, Na, 98°C; cesium, Cs, 29°C; calcium, Ca, 842°C. Which statement is consistent with all three values?', null, md5('apchem-mcq-b5-sv-h-2.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cs melts lowest because Cs atoms have more electrons, and more electrons in an atom always weaken metallic bonding.', false, 'The number of core electrons in an atom is not the cause, and the effect is due to larger cores having a weaker attraction for the delocalized electrons.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ca contributes two delocalized electrons per atom, which raises its melting temperature, while the large cores of Cs spread the attraction over a larger volume, giving the lowest melting temperature.', true, 'Correct: Cs is a larger atom than Na with the same one delocalized electron, so it melts lower; Ca gives two electrons per atom and melts much higher.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ca melts highest because heavier atoms have stronger bonds, and Ca is heavier than Na and Cs.', false, 'Cs is heavier than Ca and melts far lower, so atomic mass does not explain the melting temperatures.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Na melts higher than Cs because Na atoms have more delocalized electrons than Cs atoms.', false, 'Na and Cs each contribute one delocalized electron per atom, so the difference between them is due to core size and not electron count.' from version_ins;
-- apchem-mcq-b5-sv-h-2.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.4-b-v3', 'mcq', 'explain trends in metallic melting temperature using the number of delocalized electrons per atom and the size of the me (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Melting temperatures: potassium, K, 63°C; rubidium, Rb, 39°C; strontium, Sr, 777°C. Which statement is consistent with all three values?', null, md5('apchem-mcq-b5-sv-h-2.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sr melts highest because it contributes two delocalized electrons per atom, and Rb melts lower than K because its larger cores attract the electron sea less strongly.', true, 'Correct: Rb has larger cores than K, with the same one electron per atom, so it melts lower; Sr gives two electrons per atom and melts far higher.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sr melts highest because its atoms have larger radii than K and Rb, and larger cores bind more strongly.', false, 'Larger cores weaken the attraction, as Rb melting lower than K shows, so a large radius cannot be the reason Sr melts highest.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Rb melts lowest because its atoms are heavier, and heavier atoms form weaker covalent bonds.', false, 'Metals are not held together by covalent bonds between atoms, and mass does not set metallic bond strength.' from version_ins
union all select gen_random_uuid(), id, 'D', 'K and Rb melt at low temperatures because they form molecular solids with weak forces between molecules.', false, 'Potassium and rubidium are metals held by metallic bonding and do not exist as molecules, so they have no intermolecular forces.' from version_ins;
-- apchem-mcq-b5-h-2.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.5-a', 'mcq', 'build a Lewis diagram from the valence electron count and count all nonbonding pairs, including the extra pairs on an ex', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The ICl₄⁻ ion has iodine as the central atom bonded to four chlorine atoms. How many lone pairs (nonbonding electron pairs, counting those on all atoms) appear in its best Lewis diagram?', null, md5('apchem-mcq-b5-h-2.5-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12 lone pairs', false, 'It counts only the 12 lone pairs on the chlorine atoms and omits the 2 lone pairs left on iodine.' from version_ins
union all select gen_random_uuid(), id, 'B', '16 lone pairs', false, 'It would need 40 electrons, because it places four lone pairs on iodine, but the ion has only 36 valence electrons.' from version_ins
union all select gen_random_uuid(), id, 'C', '28 lone pairs', false, 'It counts nonbonding electrons, 28, and not pairs, which is the number of electrons and not the number of pairs.' from version_ins
union all select gen_random_uuid(), id, 'D', '14 lone pairs', true, 'Correct: valence electrons = 7 + 4(7) + 1 = 36. Four I–Cl single bonds use 8 electrons; the chlorine atoms take 3 lone pairs each, 24 electrons; the remaining 4 electrons give 2 lone pairs on iodine. Total lone pairs = 12 + 2 = 14.' from version_ins;
-- apchem-mcq-b5-sv-h-2.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.5-a-v1', 'mcq', 'build a Lewis diagram from the valence electron count and count all nonbonding pairs, including the extra pairs on an ex (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'BrF₃ has bromine as the central atom bonded to three fluorine atoms. How many lone pairs (nonbonding electron pairs, counting those on all atoms) appear in its best Lewis diagram?', null, md5('apchem-mcq-b5-sv-h-2.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9 lone pairs', false, 'It counts only the lone pairs on fluorine and forgets the 2 lone pairs on bromine.' from version_ins
union all select gen_random_uuid(), id, 'B', '11 lone pairs', true, 'Correct: valence electrons = 7 + 3(7) = 28. Three Br–F bonds use 6 electrons; fluorine atoms take 18 electrons as 9 lone pairs; the remaining 4 electrons give 2 lone pairs on bromine. Total = 9 + 2 = 11.' from version_ins
union all select gen_random_uuid(), id, 'C', '22 lone pairs', false, 'It counts nonbonding electrons, 22, rather than pairs.' from version_ins
union all select gen_random_uuid(), id, 'D', '12 lone pairs', false, 'It places 3 lone pairs on bromine, which would require 30 valence electrons and so does not match the 28 available.' from version_ins;
-- apchem-mcq-b5-sv-h-2.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.5-a-v2', 'mcq', 'build a Lewis diagram from the valence electron count and count all nonbonding pairs, including the extra pairs on an ex (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'SF₄ has sulfur as the central atom bonded to four fluorine atoms. How many lone pairs (nonbonding electron pairs, counting those on all atoms) appear in its best Lewis diagram?', null, md5('apchem-mcq-b5-sv-h-2.5-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13 lone pairs', true, 'Correct: valence electrons = 6 + 4(7) = 34. Four S–F bonds use 8 electrons; fluorine atoms take 24 electrons as 12 lone pairs; the remaining 2 electrons give 1 lone pair on sulfur. Total = 12 + 1 = 13.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 lone pairs', false, 'It counts the lone pairs on fluorine only and omits the one lone pair on sulfur.' from version_ins
union all select gen_random_uuid(), id, 'C', '26 lone pairs', false, 'It counts the 26 nonbonding electrons and not the 13 pairs.' from version_ins
union all select gen_random_uuid(), id, 'D', '14 lone pairs', false, 'It puts 2 lone pairs on sulfur, which would need 36 valence electrons, but SF₄ has only 34.' from version_ins;
-- apchem-mcq-b5-sv-h-2.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.5-a-v3', 'mcq', 'build a Lewis diagram from the valence electron count and count all nonbonding pairs, including the extra pairs on an ex (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The triiodide ion, I₃⁻, has one iodine atom in the center bonded to two terminal iodine atoms. How many lone pairs (nonbonding electron pairs, counting those on all atoms) appear in its best Lewis diagram?', null, md5('apchem-mcq-b5-sv-h-2.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6 lone pairs', false, 'It counts only the lone pairs on the terminal iodine atoms and omits the 3 on the central atom.' from version_ins
union all select gen_random_uuid(), id, 'B', '9 lone pairs', true, 'Correct: valence electrons = 3(7) + 1 = 22. Two I–I bonds use 4 electrons; each terminal iodine takes 3 lone pairs, 12 electrons; the remaining 6 electrons give 3 lone pairs on the central iodine. Total = 6 + 3 = 9.' from version_ins
union all select gen_random_uuid(), id, 'C', '18 lone pairs', false, 'It counts nonbonding electrons, 18, not pairs.' from version_ins
union all select gen_random_uuid(), id, 'D', '8 lone pairs', false, 'It gives the central atom only an octet, with 2 lone pairs, and so leaves 2 electrons unplaced.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-sv-h-2.4-a-v3','apchem-mcq-b5-h-2.4-b','apchem-mcq-b5-sv-h-2.4-b-v1','apchem-mcq-b5-sv-h-2.4-b-v2','apchem-mcq-b5-sv-h-2.4-b-v3','apchem-mcq-b5-h-2.5-a','apchem-mcq-b5-sv-h-2.5-a-v1','apchem-mcq-b5-sv-h-2.5-a-v2','apchem-mcq-b5-sv-h-2.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b5-sv-h-2.4-a-v3','apchem-mcq-b5-h-2.4-b','apchem-mcq-b5-sv-h-2.4-b-v1','apchem-mcq-b5-sv-h-2.4-b-v2','apchem-mcq-b5-sv-h-2.4-b-v3','apchem-mcq-b5-h-2.5-a','apchem-mcq-b5-sv-h-2.5-a-v1','apchem-mcq-b5-sv-h-2.5-a-v2','apchem-mcq-b5-sv-h-2.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
