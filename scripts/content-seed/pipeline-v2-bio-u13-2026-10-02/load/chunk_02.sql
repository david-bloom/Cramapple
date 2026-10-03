begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['APBIO-MCQ-SV-016-v2','APBIO-MCQ-SV-016-v3','APBIO-MCQ-SV-018-v1','APBIO-MCQ-SV-018-v2','APBIO-MCQ-SV-018-v3','APBIO-MCQ-SV-020-v1','APBIO-MCQ-SV-020-v2','APBIO-MCQ-SV-020-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APBIO-MCQ-SV-016-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-016-v2', 'mcq', 'Protoplasts burst in water', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Plant biologists treat leaf cells with enzymes that digest the cellulose cell wall, producing protoplasts. Intact leaf cells placed in distilled water become firm but stay intact, whereas protoplasts placed in distilled water swell and many burst. Which best explains the difference in outcome?', null, md5('APBIO-MCQ-SV-016-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Protoplasts lose their plasma membranes during digestion, so distilled water flows freely through them until they rupture.', false, 'The enzymes digest the cellulose wall, not the plasma membrane, which still bounds the protoplast.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Intact cells stay whole because their cytoplasm is isotonic to distilled water, whereas the protoplasts become hypotonic to it.', false, 'Distilled water is hypotonic to both intact cells and protoplasts; the wall, not an isotonic cytoplasm, prevents bursting.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Without a wall, protoplasts have nothing to resist water entering by osmosis, so no turgor pressure limits swelling and the membrane ruptures.', true, 'The wall provides counter-pressure that limits swelling in intact cells; removing it lets water entry continue until the membrane lyses.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The enzyme treatment makes the cytoplasm of protoplasts hypertonic to the intact cells, so water moves out until they burst.', false, 'Water moving out would shrink the cells; bursting results from net water entry in a hypotonic solution.' from version_ins;
-- APBIO-MCQ-SV-016-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-016-v3', 'mcq', 'Wilting of plants in salty soil', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gardener waters houseplants with a very salty solution. Within hours the leaves droop, and under a microscope the plasma membranes of the leaf cells have pulled away from the cell walls. Plants watered with fresh water stay upright and firm. Which best explains why the plants watered with salty solution droop?', null, md5('APBIO-MCQ-SV-016-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Salt entered the cells and made the cell walls swell, which pushed the plasma membranes away from the cell walls.', false, 'The membrane pulls away because the cytoplasm shrinks as water leaves; salt does not swell the cell wall.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The cell walls dissolved in the salty solution, so the cells could no longer hold any water and the leaves drooped.', false, 'Cell walls do not dissolve in salt solution; the cells droop because of osmotic loss of water.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Water moved out of the cells by osmosis into the salty surroundings, so the cells lost turgor pressure and the tissue wilted.', true, 'The salty solution is hypertonic to the cells, water leaves, turgor pressure falls, and the membrane pulls from the wall.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Water moved into the cells until the walls cracked, so the cells became flaccid and the leaves drooped.', false, 'Water entry would raise turgor and firmness; drooping accompanies water loss.' from version_ins;
-- APBIO-MCQ-SV-018-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-018-v1', 'mcq', 'Transferrin receptor deficiency', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Developing red blood cells take up iron by receptor-mediated endocytosis. Iron-carrying transferrin in the blood binds to transferrin receptors in the plasma membrane, the membrane folds inward, and a vesicle carries the transferrin into the cell. A patient has a mutation that removes functional transferrin receptors from the cell surface. Which prediction is best supported by the described process?', null, md5('APBIO-MCQ-SV-018-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cells will make extra receptors inside vesicles, which will move iron into the cytoplasm without any need for binding.', false, 'Nothing in the description allows iron to enter without receptor-mediated uptake; vesicles form after binding at the surface.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The cells will take in transferrin normally through the lipid bilayer, because diffusion of large proteins does not need membrane proteins.', false, 'Transferrin is a large protein that cannot diffuse across the bilayer; its uptake depends on receptor binding.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Iron-loaded transferrin will remain in the blood while developing red blood cells receive too little iron, because transferrin cannot bind and be taken in.', true, 'Without receptors the transferrin cannot be recognized or engulfed, so it stays in circulation and the cells lack iron.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Transferrin will be engulfed and then trapped in vesicles because the vesicles cannot move to the interior of the cell.', false, 'Without receptors transferrin is not engulfed, so no vesicles containing it form.' from version_ins;
-- APBIO-MCQ-SV-018-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-018-v2', 'mcq', 'Blocked vesicle fusion in beta cells', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pancreatic beta cells store insulin in secretory vesicles. When blood glucose rises, the vesicles move to the plasma membrane, fuse with it, and release insulin outside the cell by exocytosis. A toxin prevents secretory vesicles from fusing with the plasma membrane but does not affect insulin synthesis. Which prediction is best supported by the described process?', null, md5('APBIO-MCQ-SV-018-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Insulin will be taken up into the cells by endocytosis, which lowers the amount of insulin in the vesicles.', false, 'Endocytosis moves material into the cell; the toxin affects exocytosis, and import would not reduce stored insulin.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Insulin will build up inside undelivered vesicles, and blood glucose will stay high because little insulin is released from the cells.', true, 'Fusion is required to release insulin, so insulin accumulates in vesicles and glucose remains elevated.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Insulin will diffuse through the phospholipid bilayer instead, so blood glucose will fall at the normal rate.', false, 'Insulin is a protein too large and polar to diffuse across the bilayer, so release depends on exocytosis.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Beta cells will stop making insulin completely, because the toxin blocks translation on ribosomes of the rough ER.', false, 'The toxin affects vesicle fusion, and insulin synthesis is described as unaffected.' from version_ins;
-- APBIO-MCQ-SV-018-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-018-v3', 'mcq', 'Drug that blocks vesicle formation', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Liver cells remove LDL from the blood by receptor-mediated endocytosis. LDL binds to receptors in the plasma membrane, the membrane folds inward, and a vesicle pinches off to carry LDL into the cell. A drug allows LDL to bind to the receptors normally but prevents the membrane from folding inward and pinching off. Which prediction is best supported by the described process?', null, md5('APBIO-MCQ-SV-018-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'LDL will pass through the membrane by diffusion because it is blocked from entering the cell by endocytosis.', false, 'LDL particles are large and cannot cross the bilayer by diffusion, so blocked endocytosis leaves them outside.' from version_ins
union all select gen_random_uuid(), id, 'B', 'LDL will not bind to receptors, because the drug stops the folding that makes the receptors able to bind LDL.', false, 'The drug is described as letting binding occur normally; binding happens before the membrane folds.' from version_ins
union all select gen_random_uuid(), id, 'C', 'LDL will remain bound to receptors at the cell surface and not enter the cells, so blood LDL will rise.', true, 'Binding is intact but the inward folding is blocked, so LDL is not internalized and is not cleared from the blood.' from version_ins
union all select gen_random_uuid(), id, 'D', 'LDL will be taken into vesicles faster than normal, because binding without pinching off concentrates it near the receptors.', false, 'Without pinching off, vesicles cannot form, so uptake cannot speed up.' from version_ins;
-- APBIO-MCQ-SV-020-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-020-v1', 'mcq', 'Assign osmolarities to cell outcomes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Animal cells without a cell wall, whose cytoplasm has an osmolarity of about 280 mOsm/L, were placed in three unlabeled solutions for 10 minutes. In Solution P, the cells kept their normal shape. In Solution Q, the cells shrank and their surfaces became wrinkled. In Solution R, the cells swelled and about half burst. Which set of osmolarities is most consistent with the outcomes for P, Q, and R respectively?', null, md5('APBIO-MCQ-SV-020-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P = 600 mOsm/L; Q = 280 mOsm/L; R = 50 mOsm/L', false, 'At 600 mOsm/L the cells would shrink, not stay normal, and at 280 mOsm/L, which is isotonic, they would not shrink.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P = 50 mOsm/L; Q = 280 mOsm/L; R = 600 mOsm/L', false, 'At 50 mOsm/L the cells would swell and lyse, not remain normal, and 600 mOsm/L would shrink them rather than burst them.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P = 280 mOsm/L; Q = 600 mOsm/L; R = 50 mOsm/L', true, 'P is isotonic so no net water movement; Q is hypertonic so water leaves and the cells shrink; R is hypotonic so water enters and cells swell and lyse.' from version_ins
union all select gen_random_uuid(), id, 'D', 'P = 280 mOsm/L; Q = 50 mOsm/L; R = 600 mOsm/L', false, 'Q and R are reversed: a 50 mOsm/L solution is hypotonic and would cause swelling, while 600 mOsm/L would cause shrinking.' from version_ins;
-- APBIO-MCQ-SV-020-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-020-v2', 'mcq', 'Predicting outcomes from osmolarity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cultured animal cells with no cell wall have a cytoplasmic osmolarity of 300 mOsm/L. The cells are placed in three solutions that contain only solutes unable to cross the plasma membrane: Solution A at 150 mOsm/L, Solution B at 300 mOsm/L, and Solution C at 450 mOsm/L. Which set of outcomes is most likely for the cells in A, B, and C respectively?', null, md5('APBIO-MCQ-SV-020-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A: cells swell and may lyse; B: no net change in volume; C: cells lose water and shrink', true, 'A is hypotonic so water enters, B is isotonic so there is no net water movement, and C is hypertonic so water leaves.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A: cells lose water and shrink; B: no net change in volume; C: cells swell and may lyse', false, 'The outcomes for A and C are swapped: 150 mOsm/L is hypotonic and causes swelling, while 450 mOsm/L is hypertonic and causes shrinking.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A: no net change in volume; B: cells swell and may lyse; C: cells lose water and shrink', false, 'B matches the cytoplasm, so it is isotonic and would cause no net change; A is hypotonic and would not leave the cells unchanged.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A: cells swell and may lyse; B: cells lose water and shrink; C: no net change in volume', false, 'B is isotonic and C is hypertonic, so the cells would not shrink in B or stay unchanged in C.' from version_ins;
-- APBIO-MCQ-SV-020-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-020-v3', 'mcq', 'Order solutions by osmolarity from volume data', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Identical wall-less animal cells were placed in four solutions of non-penetrating solutes for 10 minutes, and the change in cell volume was recorded: Solution 1, +25%; Solution 2, -18%; Solution 3, 0%; Solution 4, -30%. Which ordering of the solutions from lowest to highest osmolarity is most consistent with the data?', null, md5('APBIO-MCQ-SV-020-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Solution 4, Solution 2, Solution 3, Solution 1', false, 'This is the reverse order; the solution that caused the greatest swelling has the lowest osmolarity, not the highest.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Solution 1, Solution 2, Solution 3, Solution 4', false, 'This follows the order of the numbers in the list rather than the data; Solution 2 shrank cells, so it exceeds Solution 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Solution 3, Solution 2, Solution 1, Solution 4', false, 'This ranks by size of volume change, ignoring that swelling and shrinking occur on opposite sides of isotonic.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Solution 1, Solution 3, Solution 2, Solution 4', true, 'The more cells swell, the lower the solution''s osmolarity; 0% change marks the isotonic point, and larger shrinkage means higher osmolarity.' from version_ins;
commit;
