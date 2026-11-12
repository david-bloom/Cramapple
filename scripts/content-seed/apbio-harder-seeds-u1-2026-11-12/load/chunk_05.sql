begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-h-1.5-b','apbio-mcq-b6-sv-h-1.5-b-v1','apbio-mcq-b6-sv-h-1.5-b-v2','apbio-mcq-b6-sv-h-1.5-b-v3','apbio-mcq-b6-h-1.6-a','apbio-mcq-b6-sv-h-1.6-a-v1','apbio-mcq-b6-sv-h-1.6-a-v2','apbio-mcq-b6-sv-h-1.6-a-v3','apbio-mcq-b6-h-1.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apbio-mcq-b6-h-1.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.5-b', 'mcq', 'quantify why organisms store energy as fat rather than carbohydrate.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bear must obtain 36,000 kcal from stored energy during hibernation. Fat provides about 9 kcal per gram and carbohydrate provides about 4 kcal per gram. If the bear stored the same energy as carbohydrate rather than fat, how much more stored mass would it need, and what feature of the molecules explains the difference?', null, md5('apbio-mcq-b6-h-1.5-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 4 times as much mass, because carbohydrate is a polymer and fat is not.', false, '4 is the energy per gram of carbohydrate, not the ratio of masses, which is 9 to 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 0.44 times as much mass, because carbohydrate has more oxygen to release energy.', false, 'This is the inverse of the ratio and mistakes extra oxygen for extra energy, since oxygen content lowers energy per gram.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The same mass, because both are made of carbon, hydrogen, and oxygen.', false, 'Both contain C, H, and O, but the proportions differ, and fats contain far more C-H bonds per gram.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 2.25 times as much mass, because fat has more carbon-hydrogen bonds per gram and is less oxidized.', true, 'Correct: Fat needs 36,000 / 9 = 4,000 g and carbohydrate needs 36,000 / 4 = 9,000 g, a ratio of 2.25; fats are rich in C-H bonds that store more energy per gram.' from version_ins;
-- apbio-mcq-b6-sv-h-1.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.5-b-v1', 'mcq', 'quantify why organisms store energy as fat rather than carbohydrate. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A migrating bird stores 200 g of fat for its flight. Fat provides about 9 kcal per gram, and carbohydrate provides about 4 kcal per gram. What mass of carbohydrate would hold the same energy?', null, md5('apbio-mcq-b6-sv-h-1.5-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '200 g', false, 'Carbohydrate has less energy per gram, so an equal mass would hold less energy.' from version_ins
union all select gen_random_uuid(), id, 'B', '800 g', false, 'This multiplies by 4, and the correct approach converts to kcal and then divides by 4 kcal/g.' from version_ins
union all select gen_random_uuid(), id, 'C', '450 g', true, 'Correct: 200 g x 9 kcal/g = 1,800 kcal; 1,800 / 4 = 450 g of carbohydrate.' from version_ins
union all select gen_random_uuid(), id, 'D', '89 g', false, 'This uses 200 x 4 / 9, which is the inverse of the ratio and gives too small a mass.' from version_ins;
-- apbio-mcq-b6-sv-h-1.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.5-b-v2', 'mcq', 'quantify why organisms store energy as fat rather than carbohydrate. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Sunflower plants store energy in seeds as oil, while many large-seeded grasses store energy as starch. A biologist notes that seeds dispersed by wind or by small animals are often rich in oil. Which statement best explains the advantage of storing oil in small seeds?', null, md5('apbio-mcq-b6-sv-h-1.5-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Oil is more soluble in water and therefore reaches the embryo more rapidly.', false, 'Oil is nonpolar and not soluble in water, so this explanation reverses the property.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Oil is lighter than water and therefore floats the seed to new places.', false, 'Floating in water is not the advantage being described for dispersal on land by wind or animals.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Oil has a high number of C-H bonds per gram, so a small light seed can hold more energy for the embryo.', true, 'Correct: Fats pack about twice the energy per gram of starch, so a seed can carry enough energy for germination while remaining small and light.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Oil contains nitrogen, which provides additional energy for germination.', false, 'Triglycerides contain only carbon, hydrogen, and oxygen and have no nitrogen.' from version_ins;
-- apbio-mcq-b6-sv-h-1.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.5-b-v3', 'mcq', 'quantify why organisms store energy as fat rather than carbohydrate. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Glycogen is stored with about 2 g of water per gram of glycogen, while fat is stored with almost no water. Using 4 kcal per gram for dry glycogen and 9 kcal per gram for fat, about how many times more energy per gram of stored tissue does fat provide than hydrated glycogen?', null, md5('apbio-mcq-b6-sv-h-1.5-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 2.25 times, as with dry glycogen.', false, 'This is the dry-mass comparison and ignores the water mass stored with the glycogen.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 3 times, because the water adds mass.', false, '9 divided by 3 is not the comparison, because the energy in the hydrated tissue is 4 kcal in 3 g, not 4 kcal per 1 g.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 0.15 times, because water stores energy.', false, 'Water does not store usable energy and only adds mass, so this makes the ratio smaller than one.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 6.75 times, because hydrated glycogen provides only about 1.33 kcal per gram.', true, 'Correct: One gram of glycogen with 2 g of water is 3 g containing 4 kcal, or 1.33 kcal per gram; 9 / 1.33 is about 6.75.' from version_ins;
-- apbio-mcq-b6-h-1.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.6-a', 'mcq', 'predict thermal stability of double-stranded DNA from the number of hydrogen bonds.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three double-stranded DNA fragments, each 20 base pairs long, are heated slowly until the strands separate (melting temperature). Fragment P has 4 G-C pairs and has a melting temperature of 48°C. Fragment Q has 10 G-C pairs and melts at 60°C. Fragment R has 16 G-C pairs and melts at 70°C. A G-C pair has three hydrogen bonds and an A-T pair has two. A new 20-base-pair fragment has 13 G-C pairs. Which melting temperature is most likely?', null, md5('apbio-mcq-b6-h-1.6-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Below 48°C, because the new fragment has more G-C pairs than P.', false, 'More G-C pairs means more hydrogen bonds and greater stability, so the melting temperature should rise, not fall.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 60°C, because all 20-base-pair fragments melt at the same temperature.', false, 'The fragments are the same length but melt at different temperatures, which shows that base composition matters.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Between 60°C and 70°C, because it has 53 hydrogen bonds, between Q (50) and R (56).', true, 'Correct: Hydrogen bonds are 13 x 3 + 7 x 2 = 53, between Q at 50 and R at 56, so the melting temperature should lie between 60°C and 70°C.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Above 70°C, because any fragment with more than 10 G-C pairs melts above R.', false, 'The new fragment has fewer G-C pairs than R and so fewer hydrogen bonds, so it should melt below R.' from version_ins;
-- apbio-mcq-b6-sv-h-1.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.6-a-v1', 'mcq', 'predict thermal stability of double-stranded DNA from the number of hydrogen bonds. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two 20-nucleotide primers are designed to bind a target DNA strand. Primer 1 has 8 G-C pairs when bound, and primer 2 has 14 G-C pairs when bound. The remaining pairs are A-T. Which statement best predicts which duplex requires a higher temperature to separate and why?', null, md5('apbio-mcq-b6-sv-h-1.6-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Primer 1''s duplex, because A-T pairs have more hydrogen bonds than G-C pairs.', false, 'G-C pairs have three hydrogen bonds and A-T pairs have two, so this reverses the numbers.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both duplexes separate at the same temperature, because both are 20 base pairs long.', false, 'Equal length does not mean equal stability when the base composition differs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Primer 1''s duplex, because it has more A-T pairs and A-T pairs are covalent bonds.', false, 'Base pairs are held together by hydrogen bonds, not covalent bonds, and A-T pairs are weaker.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Primer 2''s duplex, because it has 14 G-C pairs, giving 54 hydrogen bonds compared with 48 for primer 1.', true, 'Correct: Primer 1 has 8 x 3 + 12 x 2 = 48 hydrogen bonds and primer 2 has 14 x 3 + 6 x 2 = 54, so primer 2 duplex needs more energy to separate.' from version_ins;
-- apbio-mcq-b6-sv-h-1.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.6-a-v2', 'mcq', 'predict thermal stability of double-stranded DNA from the number of hydrogen bonds. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Genomic DNA from two bacterial species is double-stranded. In species X, 31% of bases are adenine. In species Y, 17% of bases are adenine. Both genomes are heated slowly. Which statement is best supported?', null, md5('apbio-mcq-b6-sv-h-1.6-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Species X has the higher melting temperature, because it has more adenine.', false, 'Adenine pairs with thymine through two hydrogen bonds, so more adenine means a lower melting temperature.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both melt at the same temperature, because both genomes are double-stranded DNA.', false, 'Both are double-stranded DNA, but they differ in base composition and therefore in the hydrogen bonds per base pair.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Species X has the higher melting temperature, because it has 38% G plus C.', false, 'Species X has 38% G plus C, which is less than species Y at 66%, so its melting temperature is lower.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Species Y has the higher melting temperature, because its genome is about 66% G plus C and G-C pairs have three hydrogen bonds.', true, 'Correct: In double-stranded DNA, A = T, so species Y has 17% T and G plus C is 100 - 34 = 66%, while species X has 100 - 62 = 38%; more G-C pairs means more hydrogen bonds.' from version_ins;
-- apbio-mcq-b6-sv-h-1.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.6-a-v3', 'mcq', 'predict thermal stability of double-stranded DNA from the number of hydrogen bonds. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two DNA duplexes each have 50% G-C content. Duplex 1 is 20 base pairs long and duplex 2 is 60 base pairs long. Which statement best predicts which melts at the higher temperature?', null, md5('apbio-mcq-b6-sv-h-1.6-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'They melt at the same temperature, because they have the same percentage of G-C pairs.', false, 'Equal percentage does not mean equal total number of hydrogen bonds, and the longer duplex holds three times as many.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Duplex 2 melts higher, because it has 150 hydrogen bonds compared with 50 in duplex 1.', true, 'Correct: Duplex 1 has 10 x 3 + 10 x 2 = 50 hydrogen bonds and duplex 2 has 30 x 3 + 30 x 2 = 150, so duplex 2 needs more energy to separate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Duplex 1 melts higher, because shorter molecules are more stable.', false, 'Shorter duplexes have fewer hydrogen bonds and separate more easily.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Duplex 2 melts lower, because longer molecules have more A-T pairs.', false, 'Both have the same 50% proportion of A-T pairs, and the longer duplex has more bonds overall.' from version_ins;
-- apbio-mcq-b6-h-1.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.6-b', 'mcq', 'infer whether a nucleic acid is DNA or RNA, and whether it is double-stranded, from base composition.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Nucleic acid is extracted from two sources and the base composition is measured. Source 1: adenine 23%, thymine 23%, guanine 27%, cytosine 27%. Source 2: adenine 32%, uracil 24%, guanine 25%, cytosine 19%. Which conclusion is best supported?', null, md5('apbio-mcq-b6-h-1.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both sources are double-stranded DNA, because both have bases that sum to 100%.', false, 'Source 2 contains uracil, which occurs in RNA, and its base percentages do not follow the pairing rule.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Source 1 is single-stranded RNA, and source 2 is double-stranded DNA.', false, 'Thymine in source 1 indicates DNA, and source 2 has uracil, so this reverses the assignment.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Source 1 is likely double-stranded DNA because A equals T and G equals C, and source 2 is RNA that is probably not fully paired because its percentages do not match in pairs.', true, 'Correct: Equal A and T and equal G and C match base pairing in double-stranded DNA, whereas uracil identifies RNA and unequal percentages suggest a single strand.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Source 1 is RNA because it contains thymine, and source 2 is DNA because it contains uracil.', false, 'Thymine is found in DNA and uracil in RNA, so this pairs each base with the wrong nucleic acid.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-h-1.5-b','apbio-mcq-b6-sv-h-1.5-b-v1','apbio-mcq-b6-sv-h-1.5-b-v2','apbio-mcq-b6-sv-h-1.5-b-v3','apbio-mcq-b6-h-1.6-a','apbio-mcq-b6-sv-h-1.6-a-v1','apbio-mcq-b6-sv-h-1.6-a-v2','apbio-mcq-b6-sv-h-1.6-a-v3','apbio-mcq-b6-h-1.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b6-h-1.5-b','apbio-mcq-b6-sv-h-1.5-b-v1','apbio-mcq-b6-sv-h-1.5-b-v2','apbio-mcq-b6-sv-h-1.5-b-v3','apbio-mcq-b6-h-1.6-a','apbio-mcq-b6-sv-h-1.6-a-v1','apbio-mcq-b6-sv-h-1.6-a-v2','apbio-mcq-b6-sv-h-1.6-a-v3','apbio-mcq-b6-h-1.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
