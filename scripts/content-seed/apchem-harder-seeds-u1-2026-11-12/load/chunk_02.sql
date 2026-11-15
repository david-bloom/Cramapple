begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.2-a-v1','apchem-mcq-b6-sv-h-1.2-a-v2','apchem-mcq-b6-sv-h-1.2-a-v3','apchem-mcq-b6-h-1.2-b','apchem-mcq-b6-sv-h-1.2-b-v1','apchem-mcq-b6-sv-h-1.2-b-v2','apchem-mcq-b6-sv-h-1.2-b-v3','apchem-mcq-b6-h-1.3-a','apchem-mcq-b6-sv-h-1.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apchem-mcq-b6-sv-h-1.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.2-a-v1', 'mcq', 'interpret the molecular-ion peaks of a diatomic element, where each element''s isotope abundances must be recovered from  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The mass spectrum of a sample of bromine, Br₂, shows peaks from singly charged Br₂⁺ ions at m/z 158, 160 and 162 with relative heights 1 : 2 : 1. The only isotopes are ⁷⁹Br and ⁸¹Br. Treat isotope masses as equal to their mass numbers. What is the average atomic mass of bromine in this sample?', null, md5('apchem-mcq-b6-sv-h-1.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '160.0, because it is the position of the tallest peak in the spectrum.', false, 'The tallest peak at 160 is the mass of a Br₂ molecule; the atomic mass is half, so 80.0.' from version_ins
union all select gen_random_uuid(), id, 'B', '79.0, because ⁷⁹Br is the lighter isotope and gives the first peak.', false, 'The first peak at 158 is ⁷⁹Br₂, but equal numbers of ⁸¹Br atoms are present, so the average is not the lighter isotope mass.' from version_ins
union all select gen_random_uuid(), id, 'C', '80.0, because the 1 : 2 : 1 pattern shows the two isotopes are equally abundant.', true, 'Correct: p² = 1/4 gives p = 0.50 for each isotope (2pq = 1/2 matches the middle peak); average = 79(0.50) + 81(0.50) = 80.0.' from version_ins
union all select gen_random_uuid(), id, 'D', '81.0, because the heaviest peak at m/z 162 corresponds to the heaviest isotope, which sets the atomic mass.', false, 'The heaviest peak shows that ⁸¹Br exists, but it is only one of the two equally abundant isotopes, so the average is not 81.' from version_ins;
-- apchem-mcq-b6-sv-h-1.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.2-a-v2', 'mcq', 'interpret the molecular-ion peaks of a diatomic element, where each element''s isotope abundances must be recovered from  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of chlorine gas enriched in the heavier isotope gives a mass spectrum with peaks from Cl₂⁺ ions at m/z 70, 72 and 74 with relative heights 1 : 4 : 4. The only isotopes are ³⁵Cl and ³⁷Cl. Treat isotope masses as equal to their mass numbers. What is the average atomic mass of chlorine in this sample?', null, md5('apchem-mcq-b6-sv-h-1.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '72.7, because it is the average mass of the Cl₂ molecules.', false, 'The weighted average of the peak positions is 72.7, but this is the mass of a Cl₂ molecule; the atomic mass is half of it.' from version_ins
union all select gen_random_uuid(), id, 'B', '36.0, because the two tallest peaks are equal, so the isotopes are equally abundant.', false, 'The tallest two peaks have equal height, but the peak at 72 counts one atom of each isotope while 74 counts two ³⁷Cl, so ³⁷Cl is more abundant than ³⁵Cl.' from version_ins
union all select gen_random_uuid(), id, 'C', '35.0, because the lightest peak at m/z 70 is the base for the average.', false, 'The 70 peak is only ³⁵Cl₂, the smallest peak here; the isotope with mass 37 is the most abundant, so the average is above 36.' from version_ins
union all select gen_random_uuid(), id, 'D', '36.3, because ³⁷Cl accounts for two thirds of the atoms.', true, 'Correct: q² = 4/9 for ³⁷Cl₂ gives ³⁷Cl = 2/3 of the atoms (2pq = 4/9 checks); average = 35(1/3) + 37(2/3) = 36.3.' from version_ins;
-- apchem-mcq-b6-sv-h-1.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.2-a-v3', 'mcq', 'interpret the molecular-ion peaks of a diatomic element, where each element''s isotope abundances must be recovered from  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of bromine gas that is depleted in ⁸¹Br gives a mass spectrum with peaks from Br₂⁺ ions at m/z 158, 160 and 162 with relative heights 16 : 8 : 1. The only isotopes are ⁷⁹Br and ⁸¹Br. Treat isotope masses as equal to their mass numbers. What is the average atomic mass of bromine in this sample?', null, md5('apchem-mcq-b6-sv-h-1.2-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '158.8, because it is the weighted average mass of a Br₂ molecule.', false, 'The weighted average of the peaks is 158.8, but this is for a Br₂ molecule; the atomic mass is half, 79.4.' from version_ins
union all select gen_random_uuid(), id, 'B', '79.4, because ⁷⁹Br makes up 80% of the atoms and ⁸¹Br makes up 20%.', true, 'Correct: p² = 16/25 so the fraction of ⁷⁹Br is 0.80 (2pq = 8/25 checks); average = 79(0.80) + 81(0.20) = 79.4.' from version_ins
union all select gen_random_uuid(), id, 'C', '80.0, because the mean of the isotope masses 79 and 81 is the atomic mass.', false, 'The unweighted mean of 79 and 81 ignores that ⁷⁹Br is four times as abundant as ⁸¹Br in this sample.' from version_ins
union all select gen_random_uuid(), id, 'D', '79.0, because the tallest peak at m/z 158 shows that ⁷⁹Br is the only significant isotope.', false, 'The tallest peak shows ⁷⁹Br dominates, but the 20% ⁸¹Br raises the average above 79.' from version_ins;
-- apchem-mcq-b6-h-1.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.2-b', 'mcq', 'use both the m/z values and the isotope pattern (peak spacing and relative heights) in a mass spectrum to decide how man', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure compound that contains only carbon, hydrogen and one type of halogen gives a mass spectrum with molecular-ion peaks at m/z 112 (relative height 100) and m/z 114 (relative height 32), and no other peaks in that region. Use the isotope masses ¹²C = 12, ¹H = 1, ³⁵Cl = 35, ³⁷Cl = 37, ⁷⁹Br = 79 and ⁸¹Br = 81, and ignore ¹³C and ²H. Natural chlorine is about 75% ³⁵Cl and 25% ³⁷Cl; natural bromine is about 51% ⁷⁹Br and 49% ⁸¹Br. Which formula is consistent with the spectrum?', null, md5('apchem-mcq-b6-h-1.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C₈H₁₆, because a hydrocarbon with 8 carbons and 16 hydrogens also has a mass of 112.', false, 'C₈H₁₆ has mass 112 but contains no halogen, so it would give a single peak with no peak at 114 of height 32.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C₆H₅Cl, because its mass is 112 and the 3 : 1 pair separated by two mass units is the signature of one chlorine atom.', true, 'Correct: C₆H₅³⁵Cl = 72 + 5 + 35 = 112 and C₆H₅³⁷Cl = 114; the 100 : 32 ratio is about 75 : 25 for ³⁵Cl : ³⁷Cl, so one Cl atom.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C₃H₆Cl₂, because it also has a mass of 112 and contains chlorine.', false, 'C₃H₆Cl₂ has mass 112 but two Cl atoms would give peaks at 112, 114 and 116 in a 9 : 6 : 1 ratio, so the 114 peak would be about 2/3 of the base peak, not 32%.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C₆H₅Br, because any halogen produces a peak two mass units above the molecular ion.', false, 'C₆H₅Br would have its molecular ions at m/z 156 and 158 in a 1 : 1 ratio, not at 112 and 114 in a 3 : 1 ratio.' from version_ins;
-- apchem-mcq-b6-sv-h-1.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.2-b-v1', 'mcq', 'use both the m/z values and the isotope pattern (peak spacing and relative heights) in a mass spectrum to decide how man (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure compound that contains only carbon, hydrogen and one type of halogen gives a mass spectrum with molecular-ion peaks at m/z 94 and m/z 96 of nearly equal height (100 and 98), and no other peaks in that region. Use the isotope masses ¹²C = 12, ¹H = 1, ³⁵Cl = 35, ³⁷Cl = 37, ⁷⁹Br = 79 and ⁸¹Br = 81, and ignore ¹³C and ²H. Natural chlorine is about 75% ³⁵Cl and 25% ³⁷Cl; natural bromine is about 51% ⁷⁹Br and 49% ⁸¹Br. Which formula is consistent with the spectrum?', null, md5('apchem-mcq-b6-sv-h-1.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C₇H₁₀, because a hydrocarbon of this formula also has a mass of 94.', false, 'C₇H₁₀ has mass 94 but contains no halogen, so it would give one peak at 94 and no peak at 96 of comparable height.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CH₃Cl, because chlorine also gives a pair of peaks separated by two mass units.', false, 'CH₃Cl would give peaks at m/z 50 and 52 in a 3 : 1 ratio; neither the masses nor the ratio match the spectrum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'CH₃Br, because its mass is 94 and a 1 : 1 pair two mass units apart is the signature of one bromine atom.', true, 'Correct: CH₃⁷⁹Br = 12 + 3 + 79 = 94 and CH₃⁸¹Br = 96; two equal peaks two units apart indicate one Br atom, since ⁷⁹Br and ⁸¹Br are almost equally abundant.' from version_ins
union all select gen_random_uuid(), id, 'D', 'CH₂Br₂, because two peaks of equal height imply two bromine atoms.', false, 'CH₂Br₂ would give three peaks at 172, 174 and 176 in a 1 : 2 : 1 ratio; one atom of bromine gives two equal peaks.' from version_ins;
-- apchem-mcq-b6-sv-h-1.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.2-b-v2', 'mcq', 'use both the m/z values and the isotope pattern (peak spacing and relative heights) in a mass spectrum to decide how man (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure compound that contains only carbon, hydrogen and chlorine gives a mass spectrum with molecular-ion peaks at m/z 118, 120, 122 and 124 with relative heights 100, 96, 31 and 3. Use the isotope masses ¹²C = 12, ¹H = 1, ³⁵Cl = 35, ³⁷Cl = 37, ⁷⁹Br = 79 and ⁸¹Br = 81, and ignore ¹³C and ²H. Natural chlorine is about 75% ³⁵Cl and 25% ³⁷Cl; natural bromine is about 51% ⁷⁹Br and 49% ⁸¹Br. Which formula is consistent with the spectrum?', null, md5('apchem-mcq-b6-sv-h-1.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C₉H₁₀, because a hydrocarbon of this formula has a mass of 118.', false, 'C₉H₁₀ has mass 118 but contains no chlorine, so it would show one peak and not four peaks spaced two mass units apart.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CH₂Cl₂, because the pattern of several peaks shows that chlorine is present.', false, 'CH₂Cl₂ would have molecular ions at 84, 86 and 88 in a 9 : 6 : 1 ratio, so it gives three peaks at lower mass.' from version_ins
union all select gen_random_uuid(), id, 'C', 'CHBr₃, because four peaks are produced by a compound with three halogen atoms.', false, 'CHBr₃ also has three halogen atoms but its peaks would be near m/z 250 to 256, and the ratio would be about 1 : 3 : 3 : 1, not 100 : 96 : 31 : 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'CHCl₃, because its mass is 118 and four peaks in a ratio near 27 : 27 : 9 : 1 indicate three chlorine atoms.', true, 'Correct: CH³⁵Cl₃ = 12 + 1 + 105 = 118; the binomial pattern (0.75 + 0.25)³ = 0.42 : 0.42 : 0.14 : 0.016 matches 100 : 96 : 31 : 3 for three Cl atoms.' from version_ins;
-- apchem-mcq-b6-sv-h-1.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.2-b-v3', 'mcq', 'use both the m/z values and the isotope pattern (peak spacing and relative heights) in a mass spectrum to decide how man (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure compound that contains only carbon, hydrogen and bromine gives a mass spectrum with molecular-ion peaks at m/z 172 (relative height 50), 174 (100) and 176 (49). Use the isotope masses ¹²C = 12, ¹H = 1, ³⁵Cl = 35, ³⁷Cl = 37, ⁷⁹Br = 79 and ⁸¹Br = 81, and ignore ¹³C and ²H. Natural chlorine is about 75% ³⁵Cl and 25% ³⁷Cl; natural bromine is about 51% ⁷⁹Br and 49% ⁸¹Br. Which formula is consistent with the spectrum?', null, md5('apchem-mcq-b6-sv-h-1.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'CH₂Br₂, because its mass is 172 and the 1 : 2 : 1 pattern of three peaks indicates two bromine atoms.', true, 'Correct: CH₂⁷⁹Br₂ = 12 + 2 + 158 = 172, with ⁷⁹Br⁸¹Br at 174 and ⁸¹Br₂ at 176; (0.5 + 0.5)² gives 1 : 2 : 1 for two Br atoms.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C₁₃H₁₆, because a hydrocarbon of this formula also has a mass of 172.', false, 'C₁₃H₁₆ has mass 172 but contains no bromine, so it would show a single molecular-ion peak instead of three peaks.' from version_ins
union all select gen_random_uuid(), id, 'C', 'CH₂Cl₂, because three peaks with a ratio near 1 : 2 : 1 are produced by two chlorine atoms.', false, 'CH₂Cl₂ is two halogen atoms, but chlorine gives a 9 : 6 : 1 ratio and the peaks would be at 84, 86 and 88.' from version_ins
union all select gen_random_uuid(), id, 'D', 'CHBr₃, because the three peaks show that the molecule contains three bromine atoms.', false, 'CHBr₃ would give four peaks near m/z 250 in a ratio of about 1 : 3 : 3 : 1; the number of peaks is one more than the number of Br atoms, so three peaks mean two Br atoms.' from version_ins;
-- apchem-mcq-b6-h-1.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.3-a', 'mcq', 'find a molecular formula from combustion-analysis masses, obtaining oxygen by difference and then scaling the empirical ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.000 g sample of a compound that contains only carbon, hydrogen and oxygen is burned completely in excess oxygen, producing 1.466 g of CO₂ and 0.600 g of H₂O. The molar mass of the compound is 90.1 g/mol. Relative atomic masses (g/mol): C 12.01, H 1.008, O 16.00. Molar masses of CO₂ = 44.01 g/mol and H₂O = 18.02 g/mol. What is the molecular formula of the compound?', null, md5('apchem-mcq-b6-h-1.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C₃H₆O₃, because the empirical formula is CH₂O (30.03 g/mol) and 90.1 divided by 30.03 is 3.', true, 'Correct: n(C) = 1.466/44.01 = 0.03331; n(H) = 2 × 0.600/18.02 = 0.06659; m(O) = 1.000 − 0.4001 − 0.0671 = 0.533 g = 0.03331 mol; ratio 1 : 2 : 1 gives CH₂O; 90.1/30.03 = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CH₂O, because that is the simplest whole-number ratio of C, H and O.', false, 'CH₂O is the empirical formula, which has a molar mass of 30.03 g/mol; the molar mass of 90.1 g/mol shows the molecule contains three empirical units.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C₃H₃O₃, because each H₂O in the products contains one hydrogen atom that came from the sample.', false, 'Each H₂O contains two hydrogen atoms from the sample, so n(H) = 2 × 0.0333 = 0.0666 mol, which gives twice as many H as C₃H₃O₃ shows.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C₆H₁₂, because the ratio of carbon to hydrogen in the products is 1 : 2 and oxygen is not measured directly.', false, 'Oxygen is found by difference: 1.000 − 0.400 − 0.067 = 0.533 g, which is 0.0333 mol; leaving it out gives a formula with mass 84 and omits the oxygen, which is over half the sample''s mass.' from version_ins;
-- apchem-mcq-b6-sv-h-1.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.3-a-v1', 'mcq', 'find a molecular formula from combustion-analysis masses, obtaining oxygen by difference and then scaling the empirical  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.800 g sample of a compound that contains only carbon, hydrogen and oxygen is burned completely in excess oxygen, producing 1.598 g of CO₂ and 0.654 g of H₂O. The molar mass of the compound is 88.1 g/mol. Relative atomic masses (g/mol): C 12.01, H 1.008, O 16.00. Molar masses of CO₂ = 44.01 g/mol and H₂O = 18.02 g/mol. What is the molecular formula of the compound?', null, md5('apchem-mcq-b6-sv-h-1.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C₂H₄O, because the simplest ratio of the elements found in the products is 2 : 4 : 1.', false, 'C₂H₄O is the empirical formula with a molar mass of 44.05 g/mol, half of the 88.1 g/mol given, so the molecular formula is double it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C₄H₄O₂, because each water molecule is assumed to contain one hydrogen atom from the compound.', false, 'Each H₂O contains two H atoms from the sample, so n(H) = 0.0726 mol, twice n(C); C₄H₄O₂ has only half the hydrogen found.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C₄H₈O₂, because the empirical formula is C₂H₄O (44.05 g/mol) and 88.1 divided by 44.05 is 2.', true, 'Correct: n(C) = 1.598/44.01 = 0.03631; n(H) = 2 × 0.654/18.02 = 0.07259; m(O) = 0.800 − 0.4361 − 0.0732 = 0.2907 g = 0.01817 mol; ratio 2 : 4 : 1; 88.1/44.05 = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C₆H₁₂, because the C : H ratio from the products is 1 : 2 and the molar mass is then used to scale it.', false, 'This ignores oxygen, which is 0.2905 g or 0.0182 mol found by difference; C₆H₁₂ has no oxygen and its mass of 84.16 g/mol also disagrees with 88.1.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.2-a-v1','apchem-mcq-b6-sv-h-1.2-a-v2','apchem-mcq-b6-sv-h-1.2-a-v3','apchem-mcq-b6-h-1.2-b','apchem-mcq-b6-sv-h-1.2-b-v1','apchem-mcq-b6-sv-h-1.2-b-v2','apchem-mcq-b6-sv-h-1.2-b-v3','apchem-mcq-b6-h-1.3-a','apchem-mcq-b6-sv-h-1.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b6-sv-h-1.2-a-v1','apchem-mcq-b6-sv-h-1.2-a-v2','apchem-mcq-b6-sv-h-1.2-a-v3','apchem-mcq-b6-h-1.2-b','apchem-mcq-b6-sv-h-1.2-b-v1','apchem-mcq-b6-sv-h-1.2-b-v2','apchem-mcq-b6-sv-h-1.2-b-v3','apchem-mcq-b6-h-1.3-a','apchem-mcq-b6-sv-h-1.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
