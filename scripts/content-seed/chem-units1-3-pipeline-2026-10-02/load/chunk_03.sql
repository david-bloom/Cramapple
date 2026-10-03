begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-024-v1','apchem-mcq-sv-024-v2','apchem-mcq-sv-024-v3','apchem-mcq-sv-003-v1','apchem-mcq-sv-003-v2','apchem-mcq-sv-003-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-024-v1 (seed apchem-mcq-024)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-024-v1', 'mcq', 'Ionization energy: Be and B', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The first ionization energy of beryllium (899 kJ/mol) is greater than that of boron (801 kJ/mol), even though boron has a higher nuclear charge. Which statement correctly explains this trend?', null, md5('apchem-mcq-sv-024-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Beryllium''s outermost electrons are in a filled 2s subshell, while boron''s outermost electron occupies the higher-energy 2p subshell, which is partly shielded by the 2s² electrons and is therefore removed more easily.', true, 'Correct. A 2p electron is higher in energy and less penetrating than a 2s electron and is shielded by the 2s² electrons, so boron''s valence electron is removed more easily despite the extra proton.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Boron''s atomic radius is larger than beryllium''s, so its outermost electron is farther from the nucleus and is removed more easily than beryllium''s electrons.', false, 'Incorrect. Atomic radius decreases from beryllium to boron across the period; the exception is due to the 2p versus 2s subshell, not size.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Boron''s outermost electron is shielded by the 1s electrons, but beryllium''s outermost electrons are not, so beryllium''s electrons feel a larger effective nuclear charge.', false, 'Incorrect. Both atoms have a filled 1s core that shields their valence electrons; the difference is that boron''s valence electron is in 2p, which is also shielded by 2s.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Boron has the greater nuclear charge, so its outermost electron is always held more tightly than the outermost electrons of beryllium, whatever subshell it is in.', false, 'Incorrect. Applies the nuclear-charge trend alone and ignores subshell energy and shielding, which produce the Be-B exception.' from version_ins
;
-- apchem-mcq-sv-024-v2 (seed apchem-mcq-024)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-024-v2', 'mcq', 'Ionization energy: Zn and Ga', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The first ionization energy of zinc (906 kJ/mol) is greater than that of gallium (579 kJ/mol), even though gallium has a higher nuclear charge. Which statement correctly explains this trend?', null, md5('apchem-mcq-sv-024-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Gallium''s outermost electron is in a higher principal shell than zinc''s outermost electrons, so it is much farther from the nucleus and is removed more easily.', false, 'Incorrect. Both zinc''s 4s and gallium''s 4p valence electrons are in the n = 4 shell; the difference is subshell energy and shielding.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Gallium has the greater nuclear charge, so its outermost electron is always held more tightly than the outermost electrons of zinc, whatever subshell it is in.', false, 'Incorrect. Applies the nuclear-charge trend alone and ignores the 4p versus 4s subshell energy and shielding.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Zinc''s 3d subshell is only partly filled, and this partial filling holds its 4s electrons more tightly than gallium''s 4p electron is held.', false, 'Incorrect. Zinc''s 3d subshell is completely filled (3d¹⁰), not partly filled; the lower value for gallium comes from removing a higher-energy 4p electron.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Zinc''s outermost electrons are in a filled 4s subshell, while gallium''s outermost electron occupies the higher-energy 4p subshell, which is shielded by the 4s² electrons and is therefore removed more easily.', true, 'Correct. Gallium''s outermost (4p) electron is higher in energy, less penetrating and shielded by the 4s² electrons, so it is easier to remove than a 4s electron of zinc.' from version_ins
;
-- apchem-mcq-sv-024-v3 (seed apchem-mcq-024)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-024-v3', 'mcq', 'Ionization energy: N and O', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The first ionization energy of nitrogen (1402 kJ/mol) is greater than that of oxygen (1314 kJ/mol), even though oxygen has a higher nuclear charge. Which statement correctly explains this trend?', null, md5('apchem-mcq-sv-024-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Oxygen has the greater nuclear charge, so its outermost electron is always held more tightly than the outermost electrons of nitrogen, whatever the arrangement.', false, 'Incorrect. Applies the nuclear-charge trend alone and ignores electron-electron repulsion within a doubly occupied 2p orbital.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Nitrogen''s three 2p electrons occupy separate orbitals, while oxygen has one 2p orbital holding two electrons, and the repulsion between that pair makes an oxygen electron easier to remove.', true, 'Correct. Both outer electrons are in the same 2p subshell; oxygen''s paired electrons repel each other, which offsets the extra nuclear charge and lowers its ionization energy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Oxygen''s atomic radius is larger than nitrogen''s, so its outermost electron is farther from the nucleus and is removed more easily than nitrogen''s electrons.', false, 'Incorrect. Atomic radius decreases from nitrogen to oxygen across the period, so size cannot explain the lower value for oxygen.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Oxygen''s outermost electron occupies a 3p subshell, which is higher in energy and shielded by the 2p electrons, so it is removed more easily than nitrogen''s.', false, 'Incorrect. Oxygen''s outermost electrons are in the 2p subshell (1s²2s²2p⁴), the same subshell as nitrogen''s; none are in 3p.' from version_ins
;
-- apchem-mcq-sv-003-v1 (seed apchem-mcq-003)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-003-v1', 'mcq', 'Planar carbonyl molecule', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four species are listed below. Which one has a trigonal planar molecular geometry around its central atom?', null, md5('apchem-mcq-sv-003-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'SO₂', false, 'Sulfur has three regions of electron density (two bonded O atoms and one lone pair), so its electron-domain geometry is trigonal planar, but the lone pair is not part of the molecular shape, which is bent.' from version_ins
union all select gen_random_uuid(), id, 'B', 'PH₃', false, 'Phosphorus has three bonding pairs and one lone pair (four regions), so the molecular geometry is trigonal pyramidal, not trigonal planar. The lone pair is what pushes the three P–H bonds out of a plane.' from version_ins
union all select gen_random_uuid(), id, 'C', 'CH₂O', true, 'Correct. Carbon forms two C–H single bonds and one C=O double bond. A double bond counts as one region of electron density, so carbon has three regions and no lone pair, giving trigonal planar geometry.' from version_ins
union all select gen_random_uuid(), id, 'D', 'SiH₄', false, 'Silicon has four bonding regions and no lone pairs, so the geometry is tetrahedral with 109.5° angles, not trigonal planar.' from version_ins
;
-- apchem-mcq-sv-003-v2 (seed apchem-mcq-003)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-003-v2', 'mcq', 'Nitrate ion shape', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the molecular geometry of the nitrate ion, NO₃⁻?', null, md5('apchem-mcq-sv-003-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Bent', false, 'Bent geometry belongs to the nitrite ion, NO₂⁻, which has two bonded O atoms and one lone pair on N. Nitrate has three bonded O atoms and no lone pair on N.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Trigonal planar', true, 'Correct. In the best Lewis structure (three equivalent resonance forms) nitrogen has one N=O double bond and two N–O single bonds, so three regions of electron density and no lone pair. Three regions with no lone pair give trigonal planar geometry.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Tetrahedral', false, 'The double bond is one region, not two. Counting the N=O as two regions gives four regions, which is the source of this wrong answer; correctly there are three regions, so the geometry is trigonal planar.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Trigonal pyramidal', false, 'Nitrogen in nitrate has no lone pair: every electron pair around it is a bonding pair to one of the three oxygens. Trigonal pyramidal needs three bonds plus one lone pair, as in NH₃.' from version_ins
;
-- apchem-mcq-sv-003-v3 (seed apchem-mcq-003)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-003-v3', 'mcq', 'Flat 120 degree ion', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which species has a trigonal planar molecular geometry, with three identical atoms bonded to the central atom in one plane at bond angles of 120°?', null, md5('apchem-mcq-sv-003-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ClF₃', false, 'Chlorine has three bonded F atoms and two lone pairs (five regions). The three F atoms lie in one plane but the shape is T-shaped with angles near 90°, not trigonal planar.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CO₃²⁻', true, 'Correct. Carbonate has three equivalent resonance forms with one C=O and two C–O⁻; carbon has three regions and no lone pair, so the three O atoms lie in a plane at 120°.' from version_ins
union all select gen_random_uuid(), id, 'C', 'SO₃²⁻', false, 'Sulfite has the same formula pattern as carbonate, but sulfur has three bonded O atoms and one lone pair (four regions), so the shape is trigonal pyramidal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'NO₂⁻', false, 'Nitrite has two bonded O atoms and one lone pair on N: trigonal planar electron-domain geometry but a bent molecular shape with only two atoms bonded to the central atom.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-024-v1','apchem-mcq-sv-024-v2','apchem-mcq-sv-024-v3','apchem-mcq-sv-003-v1','apchem-mcq-sv-003-v2','apchem-mcq-sv-003-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
