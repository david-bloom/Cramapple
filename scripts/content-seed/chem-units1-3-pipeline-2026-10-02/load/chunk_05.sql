begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-027-v1','apchem-mcq-sv-027-v2','apchem-mcq-sv-027-v3','apchem-mcq-sv-028-v1','apchem-mcq-sv-028-v2','apchem-mcq-sv-028-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-027-v1 (seed apchem-mcq-027)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-027-v1', 'mcq', 'Central oxygen in ozone', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In one resonance contributor of ozone, O₃, the central oxygen atom forms one O=O double bond and one O–O single bond and carries one lone pair. What is the formal charge on the central oxygen atom?', null, md5('apchem-mcq-sv-027-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+3', false, 'This is 6 − 3: leaving the lone-pair electrons out of the count (only the 3 bond electrons are subtracted) gives +3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', false, '−1 is the formal charge of the singly bonded terminal oxygen (6 − 6 − 1 = −1), not the central oxygen. This answer comes from assigning the terminal atom''s value to the central atom.' from version_ins
union all select gen_random_uuid(), id, 'C', '+1', true, 'Correct. Central O: 6 valence electrons; 2 nonbonding electrons (one lone pair); 6 bonding electrons (double + single bond), of which half = 3 count. Formal charge = 6 − 2 − 3 = +1.' from version_ins
union all select gen_random_uuid(), id, 'D', '−2', false, 'This is 6 − 2 − 6: subtracting all 6 bonding electrons instead of half of them gives −2.' from version_ins
;
-- apchem-mcq-sv-027-v2 (seed apchem-mcq-027)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-027-v2', 'mcq', 'Nitrogen in nitrate', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the Lewis structure of the nitrate ion, NO₃⁻, nitrogen forms one N=O double bond and two N–O single bonds and has no lone pairs. What is the formal charge on nitrogen?', null, md5('apchem-mcq-sv-027-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3', false, 'This is 5 − 0 − 8: subtracting all 8 bonding electrons instead of half gives −3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', false, '−1 is the overall charge of the ion, not the formal charge on nitrogen; the formal charges on the atoms (+1 on N, −1 on each of the two single-bonded O atoms, 0 on the double-bonded O) sum to the ion''s −1.' from version_ins
union all select gen_random_uuid(), id, 'C', '+5', false, 'This is 5 − 0: counting only the valence electrons and ignoring the bonds gives +5.' from version_ins
union all select gen_random_uuid(), id, 'D', '+1', true, 'Correct. Nitrogen has 5 valence electrons, 0 nonbonding electrons, and 8 bonding electrons (double + two single bonds), of which half = 4 count. Formal charge = 5 − 0 − 4 = +1.' from version_ins
;
-- apchem-mcq-sv-027-v3 (seed apchem-mcq-027)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-027-v3', 'mcq', 'Carbon in carbon monoxide', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the Lewis structure of carbon monoxide, CO, the atoms are joined by a triple bond and each atom has one lone pair. What is the formal charge on the carbon atom?', null, md5('apchem-mcq-sv-027-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4', false, 'This is 4 − 2 − 6: subtracting all 6 bonding electrons instead of half gives −4.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This assumes that because CO is neutral each atom must have formal charge zero. The formal charges are −1 and +1 and sum to zero.' from version_ins
union all select gen_random_uuid(), id, 'C', '+1', false, '+1 is the formal charge of oxygen (6 − 2 − 3 = +1), not carbon. This comes from computing the other atom''s value.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1', true, 'Correct. Carbon has 4 valence electrons, 2 nonbonding electrons (one lone pair), and 6 bonding electrons (triple bond), of which half = 3 count. Formal charge = 4 − 2 − 3 = −1 (oxygen is +1, so the molecule is neutral).' from version_ins
;
-- apchem-mcq-sv-028-v1 (seed apchem-mcq-028)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-028-v1', 'mcq', 'Shape of XeF₄', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the molecular shape of XeF₄?', null, md5('apchem-mcq-sv-028-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Square pyramidal', false, 'Square pyramidal needs five bonds and one lone pair (as in IF₅). XeF₄ has four bonds and two lone pairs, so the lone pairs sit opposite each other and the shape is square planar.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Tetrahedral', false, 'Tetrahedral requires four bonds and no lone pairs. XeF₄ has two lone pairs on opposite sides of xenon, so the four F atoms lie in a flat square, not a tetrahedron.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Square planar', true, 'Correct. Xenon has 8 valence electrons; four Xe–F bonds use 4, leaving 4 (two lone pairs). The six electron pairs place the two lone pairs opposite each other, leaving the four F atoms in a square plane.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Seesaw', false, 'Seesaw is the shape with four bonds and one lone pair, as in SF₄. XeF₄ has two lone pairs on xenon, which sit opposite each other and give a square planar shape.' from version_ins
;
-- apchem-mcq-sv-028-v2 (seed apchem-mcq-028)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-028-v2', 'mcq', 'Shape of BrF₃', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the molecular shape of BrF₃?', null, md5('apchem-mcq-sv-028-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Trigonal planar', false, 'Trigonal planar would need three bonds and no lone pairs. BrF₃ also has two lone pairs on bromine, which push the F atoms into a T with angles near 90°, not 120°.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Seesaw', false, 'Seesaw requires four bonds and one lone pair (as in SF₄). BrF₃ has three bonds and two lone pairs, so the shape is T-shaped.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Trigonal pyramidal', false, 'This counts only one lone pair on bromine, as in NF₃. Bromine has two lone pairs, so the molecule is T-shaped.' from version_ins
union all select gen_random_uuid(), id, 'D', 'T-shaped', true, 'Correct. Bromine has 7 valence electrons; three Br–F bonds use 3, leaving 4 (two lone pairs). The five electron pairs place both lone pairs in equatorial positions, leaving three F atoms in a T-shape.' from version_ins
;
-- apchem-mcq-sv-028-v3 (seed apchem-mcq-028)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-028-v3', 'mcq', 'Identify molecule from shape', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A molecule has a central atom with six electron domains and a square pyramidal molecular shape. Which formula could represent the molecule?', null, md5('apchem-mcq-sv-028-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'SF₆', false, 'SF₆ has six bonds and no lone pairs, so its molecular shape is octahedral, not square pyramidal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'XeF₄', false, 'XeF₄ has six domains (4 bonds + 2 lone pairs) but a square planar shape, since the two lone pairs sit opposite each other.' from version_ins
union all select gen_random_uuid(), id, 'C', 'PCl₅', false, 'PCl₅ has five domains (five bonds, no lone pairs) and is trigonal bipyramidal. It has five bonded atoms, but the question requires six domains.' from version_ins
union all select gen_random_uuid(), id, 'D', 'IF₅', true, 'Correct. Iodine has 7 valence electrons; five I–F bonds use 5, leaving 2 (one lone pair). Six domains give an octahedral arrangement and the single lone pair leaves a square pyramid.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-027-v1','apchem-mcq-sv-027-v2','apchem-mcq-sv-027-v3','apchem-mcq-sv-028-v1','apchem-mcq-sv-028-v2','apchem-mcq-sv-028-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
