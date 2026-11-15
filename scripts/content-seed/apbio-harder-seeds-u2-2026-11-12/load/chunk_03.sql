begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.3-a-v2','apbio-mcq-b5-sv-h-2.3-a-v3','apbio-mcq-b5-h-2.3-b','apbio-mcq-b5-sv-h-2.3-b-v1','apbio-mcq-b5-sv-h-2.3-b-v2','apbio-mcq-b5-sv-h-2.3-b-v3','apbio-mcq-b5-h-2.4-a','apbio-mcq-b5-sv-h-2.4-a-v1','apbio-mcq-b5-sv-h-2.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apbio-mcq-b5-sv-h-2.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.3-a-v2', 'mcq', 'interpret a cell-fusion or fluorescence experiment as evidence about lateral movement of membrane components. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fluorescent tag is attached to a phospholipid in the outer layer of a membrane. Researchers find that tagged phospholipids spread laterally across the outer layer within a few seconds but take several hours to appear in the inner layer. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.3-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Phospholipids move quickly sideways within a layer but only rarely change layers, so the two layers can keep different compositions.', true, 'Correct: Rapid spreading within the outer layer shows lateral mobility; hours to reach the inner layer shows that flipping between layers is rare, so the layers can remain different.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Phospholipids in a bilayer are fixed in place, which is why the tag takes hours to spread.', false, 'The tag spread across the outer layer in seconds, so the phospholipids are not fixed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Phospholipids move rapidly in both directions, so each layer quickly acquires the same composition.', false, 'Movement between layers takes hours, so it is not rapid in that direction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Phospholipids cannot move laterally unless transport proteins carry them.', false, 'Lateral movement was seen within seconds without any transport protein being mentioned, so the lipids move freely sideways.' from version_ins;
-- apbio-mcq-b5-sv-h-2.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.3-a-v3', 'mcq', 'interpret a cell-fusion or fluorescence experiment as evidence about lateral movement of membrane components. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a repeat of a cell-fusion experiment, researchers add sodium azide, which stops ATP production, to the fused cells before the experiment. Labeled mouse and human membrane proteins still mix evenly across the surface after 40 minutes at 37°C. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Protein movement in the membrane requires ATP, which the cells had already stored.', false, 'Stored ATP would be depleted by cellular activity when production is blocked, and lateral movement is driven by the membrane fluidity rather than energy use.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Lateral movement of membrane proteins is a passive process that does not require cellular energy.', true, 'Correct: Mixing still occurs without ATP production, so movement of proteins in the bilayer does not require cellular energy; it results from the fluidity of the membrane.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mixing is caused by the fusion event itself, not by movement of proteins.', false, 'Mixing takes 40 minutes after fusion and depends on temperature, so it is a result of ongoing protein movement.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The cells produce new proteins using energy from the dye, which replaces the lost ATP.', false, 'The dye is an antibody label and has no ability to supply energy or drive protein synthesis.' from version_ins;
-- apbio-mcq-b5-h-2.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.3-b', 'mcq', 'determine which side of a membrane a protein domain faces from enzyme or antibody accessibility data.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A protease that cannot cross the plasma membrane is added to two preparations of red blood cells: intact cells and cells that have been made leaky so the enzyme can reach the cytoplasm. Protein P is digested in both preparations. Protein Q is digested only in the leaky preparation. Both proteins are integral membrane proteins. Which conclusion is best supported?', null, md5('apbio-mcq-b5-h-2.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Protein Q is not part of the membrane, because the protease cannot reach it in intact cells.', false, 'The problem states that Q is an integral membrane protein, and its digestion in leaky cells shows it is exposed on the inner surface.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Protein P has an exposed region on the outer surface of the cell, and the exposed region of protein Q faces the cytoplasm.', true, 'Correct: In intact cells the enzyme can reach only the outer surface, so digestion of P in intact cells places a domain of P outside; Q is digested only when the enzyme enters the cytoplasm, so its accessible region faces the cytoplasm.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Protein P is a peripheral protein, because the protease can digest it from outside the cell.', false, 'Digestion from outside shows an exposed outer domain, but both proteins are integral, so this does not make P peripheral.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Protein Q is deeper in the hydrophobic core than protein P, so it is protected from the protease on both sides.', false, 'Q is digested when the enzyme reaches the cytoplasm, which shows an accessible inner domain rather than complete protection.' from version_ins;
-- apbio-mcq-b5-sv-h-2.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.3-b-v1', 'mcq', 'determine which side of a membrane a protein domain faces from enzyme or antibody accessibility data. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An enzyme that removes sugar groups cannot cross the plasma membrane. When it is added to intact cultured cells, the cells lose their ability to be recognized and bound by a particular immune cell, and sugars can be detected in the surrounding fluid. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.3-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sugar groups involved in recognition are on the surface facing the cytoplasm.', false, 'An enzyme that cannot cross the membrane cannot reach sugars on the cytoplasmic surface.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The sugar groups are the main component of the membrane that forms its hydrophobic core.', false, 'The hydrophobic core is formed by the fatty acid tails of phospholipids, not by sugars.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sugar groups involved in recognition are on glycoproteins or glycolipids exposed on the outer surface of the plasma membrane.', true, 'Correct: An enzyme that cannot enter the cell changed recognition by an outside cell, so the sugars it removed are on the outer surface and take part in cell recognition.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The enzyme enters the cells and removes sugars from the nucleus, which blocks recognition.', false, 'The problem states that the enzyme cannot cross the membrane, so it cannot reach the nucleus.' from version_ins;
-- apbio-mcq-b5-sv-h-2.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.3-b-v2', 'mcq', 'determine which side of a membrane a protein domain faces from enzyme or antibody accessibility data. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two antibodies are made against different ends of membrane protein R. Antibody 1 binds the amino end of R and antibody 2 binds the carboxyl end. Neither antibody can cross the membrane. In intact cells, only antibody 1 binds. After the cells are treated to make their membranes permeable, both antibodies bind. Which model of protein R is best supported?', null, md5('apbio-mcq-b5-sv-h-2.3-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Protein R lies entirely on the outer surface of the membrane.', false, 'If both ends were outside, antibody 2 would also bind intact cells.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Protein R lies entirely on the cytoplasmic surface of the membrane.', false, 'If both ends were inside, antibody 1 would not bind intact cells.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Protein R spans the membrane with the carboxyl end on the outside and the amino end inside.', false, 'This reverses the orientation, which would make only antibody 2 bind intact cells.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Protein R spans the membrane with the amino end on the outside and the carboxyl end in the cytoplasm.', true, 'Correct: Antibody 1 reaches its site in intact cells, so the amino end is outside; antibody 2 binds only after permeabilization, so the carboxyl end is in the cytoplasm; each end being on opposite sides means R spans the bilayer.' from version_ins;
-- apbio-mcq-b5-sv-h-2.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.3-b-v3', 'mcq', 'determine which side of a membrane a protein domain faces from enzyme or antibody accessibility data. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A protease that cannot cross the membrane is added to intact red blood cells, and the size of protein V is measured. The undigested protein is 100 kilodaltons (kDa). After treatment of intact cells, the protein is 70 kDa. After treatment of leaky cells, where the enzyme reaches both sides, the protein is 40 kDa. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.3-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Protein V is entirely outside the cell, because it is digested in intact cells.', false, 'The protein loses only part of its mass in intact cells, and extra mass is lost only when the inside is exposed, so part of it is inside.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Protein V spans the membrane, with about 30 kDa exposed outside, about 30 kDa exposed inside, and about 40 kDa protected within or beneath the bilayer.', true, 'Correct: Intact cells lose 30 kDa, so 30 kDa is exposed outside. Leaky cells lose another 30 kDa (70 to 40), so 30 kDa is exposed inside. The 40 kDa remainder is protected, consistent with a transmembrane protein.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Protein V is entirely inside the cell, because it is digested to a smaller piece in leaky cells.', false, 'It is shortened in intact cells, which shows that part of it is on the outside.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Protein V is a peripheral protein attached to the outer surface only, because 70 kDa remains after treatment.', false, 'Additional digestion in leaky cells shows a domain inside the cell, and a protein attached only to the outer surface would not show this.' from version_ins;
-- apbio-mcq-b5-h-2.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.4-a', 'mcq', 'predict relative permeability of a pure phospholipid bilayer from molecular size, charge, and polarity using a data tabl', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher measures how quickly four substances cross an artificial membrane made only of phospholipids, with no proteins. Relative permeability is reported in arbitrary units. Oxygen (32 daltons, uncharged, nonpolar): 1,000,000. Urea (60 daltons, uncharged, polar): 1,000. Glucose (180 daltons, uncharged, polar): 1. Sodium ion (23 daltons, charged): 0.0001. Which conclusion is best supported by the data?', null, md5('apbio-mcq-b5-h-2.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both size and chemical character matter: small nonpolar molecules cross fastest, larger polar molecules cross slowly, and a charged ion crosses slowest even though it is smaller than urea.', true, 'Correct: Oxygen crosses a million times faster than urea, and sodium ion (23 daltons) is far slower than urea (60 daltons), so mass alone fails; the order follows nonpolar, then polar, then charged, with larger polar molecules slower than small polar ones.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Permeability decreases as molecular mass increases, so mass alone determines how fast a substance crosses.', false, 'Sodium ion has a smaller mass than urea and oxygen has a similar mass to the ion yet the ion is slower by a factor of about 10 billion, so mass alone does not explain the order.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Polar molecules cross faster than nonpolar molecules because they dissolve readily in the aqueous solutions on both sides of the membrane.', false, 'The hydrophobic core of the bilayer repels polar substances and admits nonpolar ones, so polar molecules cross more slowly.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The membrane is equally permeable to all four substances, and the differences result from measurement error.', false, 'The values differ by a factor of ten billion, which is far too large to be measurement error.' from version_ins;
-- apbio-mcq-b5-sv-h-2.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.4-a-v1', 'mcq', 'predict relative permeability of a pure phospholipid bilayer from molecular size, charge, and polarity using a data tabl (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four substances are tested on an artificial phospholipid bilayer that contains no proteins. Carbon dioxide (44 daltons, uncharged, nonpolar) has a relative permeability of 100,000. Glycerol (92 daltons, uncharged, polar) has 100. Chloride ion (35 daltons, charged) has 0.00001. Potassium ion (39 daltons, charged) has 0.00001. Which statement is best supported by the data?', null, md5('apbio-mcq-b5-sv-h-2.4-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The charge of an ion strongly restricts its movement through the bilayer, because the two small ions cross far more slowly than the larger, uncharged glycerol.', true, 'Correct: Chloride (35 daltons) and potassium (39 daltons) are smaller than glycerol (92 daltons) yet cross 10 million times more slowly, so charge, not size, limits the ions; carbon dioxide is nonpolar and fastest.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Glycerol crosses more slowly than the ions because it has the largest mass of the four substances.', false, 'Glycerol is the largest of the four but crosses far faster than either ion, so mass does not explain the order.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two ions cross as fast as they do because they are the smallest particles that can pass between phospholipid molecules.', false, 'The ions are the slowest, not the fastest, so they do not pass easily between the phospholipid molecules.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Carbon dioxide crosses fastest because it is the only substance that is attracted to the phospholipid heads.', false, 'Carbon dioxide crosses fastest because it is nonpolar and dissolves in the hydrophobic core, not because of attraction to the polar heads.' from version_ins;
-- apbio-mcq-b5-sv-h-2.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.4-a-v2', 'mcq', 'predict relative permeability of a pure phospholipid bilayer from molecular size, charge, and polarity using a data tabl (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In tests on a protein-free phospholipid bilayer, testosterone (288 daltons, uncharged, nonpolar steroid) crosses with a relative permeability of 5,000. Glucose (180 daltons, uncharged, polar) has a permeability of 1. A student claims that the larger molecule should cross more slowly. Which response is best supported by the data?', null, md5('apbio-mcq-b5-sv-h-2.4-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, but the data are wrong because the larger molecule cannot cross faster.', false, 'The data show the larger nonpolar molecule is the faster one, so the data contradict the claim rather than being wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is incorrect because polarity matters as much as size; the nonpolar steroid dissolves in the hydrophobic core of the bilayer, while glucose is excluded by it.', true, 'Correct: A 288-dalton nonpolar molecule crosses 5,000 times faster than a 180-dalton polar one, so size alone cannot predict permeability; nonpolar molecules enter the hydrophobic core.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect because testosterone is attracted to the cell''s transport proteins, which are absent from the bilayer.', false, 'No transport proteins are present in this bilayer, so the fast crossing cannot depend on them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is correct, since a molecule with a larger mass has more kinetic energy and enters the bilayer more easily.', false, 'Kinetic energy of a molecule does not explain bilayer crossing, and the data show the larger molecule is faster, not slower.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.3-a-v2','apbio-mcq-b5-sv-h-2.3-a-v3','apbio-mcq-b5-h-2.3-b','apbio-mcq-b5-sv-h-2.3-b-v1','apbio-mcq-b5-sv-h-2.3-b-v2','apbio-mcq-b5-sv-h-2.3-b-v3','apbio-mcq-b5-h-2.4-a','apbio-mcq-b5-sv-h-2.4-a-v1','apbio-mcq-b5-sv-h-2.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-sv-h-2.3-a-v2','apbio-mcq-b5-sv-h-2.3-a-v3','apbio-mcq-b5-h-2.3-b','apbio-mcq-b5-sv-h-2.3-b-v1','apbio-mcq-b5-sv-h-2.3-b-v2','apbio-mcq-b5-sv-h-2.3-b-v3','apbio-mcq-b5-h-2.4-a','apbio-mcq-b5-sv-h-2.4-a-v1','apbio-mcq-b5-sv-h-2.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
