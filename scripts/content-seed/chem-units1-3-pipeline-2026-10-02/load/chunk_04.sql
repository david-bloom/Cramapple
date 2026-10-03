begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-025-v1','apchem-mcq-sv-025-v2','apchem-mcq-sv-025-v3','apchem-mcq-sv-026-v1','apchem-mcq-sv-026-v2','apchem-mcq-sv-026-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-025-v1 (seed apchem-mcq-025)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-025-v1', 'mcq', 'Greatest ionic character', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student compares four bonds using Pauling electronegativities (Na = 0.93, H = 2.20, S = 2.58, N = 3.04, Cl = 3.16, O = 3.44). Which bond is predicted to have the greatest ionic character?', null, md5('apchem-mcq-sv-025-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'O–S', false, 'ΔEN for O–S is 3.44 − 2.58 = 0.86, far smaller than 2.23 for Na–Cl. This answer comes from choosing the bond that contains the single most electronegative atom (O, 3.44) instead of comparing differences.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Na–Cl', true, 'Correct. Ionic character increases with the electronegativity difference. ΔEN: Na–Cl = 3.16 − 0.93 = 2.23; O–S = 0.86; N–Cl = 0.12; H–Cl = 0.96. Na–Cl is the largest by a wide margin.' from version_ins
union all select gen_random_uuid(), id, 'C', 'N–Cl', false, 'ΔEN for N–Cl is 3.16 − 3.04 = 0.12, the smallest here. This answer comes from adding the electronegativities (3.04 + 3.16 = 6.20, the largest sum) instead of subtracting.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H–Cl', false, 'ΔEN for H–Cl is 3.16 − 2.20 = 0.96, which is the largest difference among the nonmetal–nonmetal bonds but less than 2.23 for Na–Cl. This answer comes from ignoring the metal and comparing only the nonmetal–nonmetal bonds.' from version_ins
;
-- apchem-mcq-sv-025-v2 (seed apchem-mcq-025)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-025-v2', 'mcq', 'Rank ionic character', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Using Pauling electronegativities (K = 0.82, Si = 1.90, P = 2.19, H = 2.20, S = 2.58, Br = 2.96, Cl = 3.16), which ranking lists the bonds in order of INCREASING ionic character?', null, md5('apchem-mcq-sv-025-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P–H < S–Cl < Si–Cl < K–Br', true, 'Correct. ΔEN values: P–H = 0.01; S–Cl = 0.58; Si–Cl = 1.26; K–Br = 2.14. Ionic character rises with ΔEN, so the increasing order is P–H, S–Cl, Si–Cl, K–Br.' from version_ins
union all select gen_random_uuid(), id, 'B', 'S–Cl < Si–Cl < K–Br < P–H', false, 'This puts P–H last by treating hydrogen as a metal because it sits in Group 1. The ΔEN for P–H is only 0.01, essentially nonpolar, so it belongs first; the other three are ranked correctly by ΔEN.' from version_ins
union all select gen_random_uuid(), id, 'C', 'K–Br < P–H < Si–Cl < S–Cl', false, 'This ranks by the SUM of the electronegativities (K–Br 3.78, P–H 4.39, Si–Cl 5.06, S–Cl 5.74) instead of the difference, which makes the most ionic bond look the least ionic.' from version_ins
union all select gen_random_uuid(), id, 'D', 'K–Br < Si–Cl < S–Cl < P–H', false, 'This is the order of DEcreasing ionic character (ΔEN 2.14, 1.26, 0.58, 0.01). It results from reading ''increasing'' backwards and listing the most ionic bond first.' from version_ins
;
-- apchem-mcq-sv-025-v3 (seed apchem-mcq-025)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-025-v3', 'mcq', 'Bond with most ionic character', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student is asked to predict which bond in a set will behave most like an ionic interaction. Pauling electronegativities: Li = 0.98, Be = 1.57, C = 2.55, Cl = 3.16, I = 2.66, O = 3.44, F = 3.98. Which bond has the greatest ionic character?', null, md5('apchem-mcq-sv-025-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Li–I', false, 'ΔEN for Li–I is 2.66 − 0.98 = 1.68, smaller than 1.87. This answer comes from choosing the bond with the lowest-electronegativity (most metallic) atom, Li, rather than computing and comparing differences.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Be–O', true, 'Correct. ΔEN: Be–O = 3.44 − 1.57 = 1.87; Li–I = 1.68; C–F = 1.43; O–Cl = 0.28. Be–O has the largest difference, so the greatest ionic character.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C–F', false, 'ΔEN for C–F is 3.98 − 2.55 = 1.43, smaller than 1.87. This answer comes from picking the bond that contains the most electronegative atom (F, 3.98) rather than the largest difference.' from version_ins
union all select gen_random_uuid(), id, 'D', 'O–Cl', false, 'ΔEN for O–Cl is 3.44 − 3.16 = 0.28, nearly nonpolar. This answer comes from adding the electronegativities (3.44 + 3.16 = 6.60, the largest sum) instead of subtracting.' from version_ins
;
-- apchem-mcq-sv-026-v1 (seed apchem-mcq-026)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-026-v1', 'mcq', 'Beyond the octet', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In its best Lewis structure, which species has a central atom surrounded by more than eight electrons?', null, md5('apchem-mcq-sv-026-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'HCN', false, 'Carbon has a single bond to H (2 electrons) and a triple bond to N (6 electrons): exactly 8. Counting the triple bond''s electrons more than once would give a false total above 8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'PCl₃', false, 'Phosphorus forms three single bonds and keeps one lone pair, giving exactly 8 electrons. Being in period 3 makes expansion possible, not required.' from version_ins
union all select gen_random_uuid(), id, 'C', 'BF₃', false, 'Boron forms three bonds and has only 6 electrons, an incomplete octet. That is an exception to the octet rule in the opposite direction, not an expanded octet.' from version_ins
union all select gen_random_uuid(), id, 'D', 'XeF₂', true, 'Correct. Xenon (8 valence electrons) forms two Xe–F bonds and keeps three lone pairs: five electron domains and 2(2) + 3(2) = 10 electrons around Xe, an expanded valence shell.' from version_ins
;
-- apchem-mcq-sv-026-v2 (seed apchem-mcq-026)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-026-v2', 'mcq', 'Electrons around iodine', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the best Lewis structure of IF₅, how many electrons surround the central iodine atom?', null, md5('apchem-mcq-sv-026-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10 electrons', false, 'This counts only the five bonding pairs (5 × 2 = 10) and leaves out iodine''s lone pair, which also belongs to the electrons surrounding the central atom.' from version_ins
union all select gen_random_uuid(), id, 'B', '8 electrons', false, 'This applies the octet rule to iodine. Iodine is in period 5, and five bonds plus a lone pair cannot fit in 8 electrons, so the octet is exceeded.' from version_ins
union all select gen_random_uuid(), id, 'C', '6 electrons', false, 'This is the number of electron domains (5 bonds + 1 lone pair = 6), not the number of electrons; each domain holds 2 electrons.' from version_ins
union all select gen_random_uuid(), id, 'D', '12 electrons', true, 'Correct. Iodine has 7 valence electrons; five I–F single bonds use 5 of them, leaving 2 (one lone pair). Around iodine: 5 bonding pairs (10 electrons) + 1 lone pair (2) = 12 electrons, an expanded valence shell.' from version_ins
;
-- apchem-mcq-sv-026-v3 (seed apchem-mcq-026)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-026-v3', 'mcq', 'Ion with expanded shell', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which ion requires its central atom to hold more than eight electrons in its best Lewis structure?', null, md5('apchem-mcq-sv-026-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'NO₃⁻', false, 'Nitrogen has one N=O and two N–O single bonds: 4 + 2 + 2 = 8 electrons in each resonance form. Counting electrons from several resonance forms together would overstate the total.' from version_ins
union all select gen_random_uuid(), id, 'B', 'PH₄⁺', false, 'Phosphorus forms four P–H bonds and has no lone pair: 8 electrons. Being in period 3 does not force expansion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ICl₂⁻', true, 'Correct. Total valence electrons: 7 + 2(7) + 1 = 22. Two I–Cl bonds use 4, leaving three lone pairs on iodine (the rest fill chlorine). Iodine then has 2(2) + 3(2) = 10 electrons.' from version_ins
union all select gen_random_uuid(), id, 'D', 'BF₄⁻', false, 'Boron forms four B–F bonds and has no lone pair: 8 electrons (the extra electron of the −1 charge is already shared in the fourth bond). Treating the −1 charge as an extra lone pair on boron would give a false 10.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-025-v1','apchem-mcq-sv-025-v2','apchem-mcq-sv-025-v3','apchem-mcq-sv-026-v1','apchem-mcq-sv-026-v2','apchem-mcq-sv-026-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
