begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-h-3.5-a','apbio-mcq-b2-sv-h-3.5-a-v1','apbio-mcq-b2-sv-h-3.5-a-v2','apbio-mcq-b2-sv-h-3.5-a-v3'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apbio-mcq-b2-h-3.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-3.5-a', 'mcq', 'effect of anaerobic conditions, cyanide, lactate and compartmentation on respiration', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Yeast cells in a flask with a constant glucose supply are switched from aerobic to anaerobic conditions. Measurements for the same number of cells are:
Condition | Glucose used (µmol/min) | ATP produced (µmol/min)
Aerobic | 5 | 150
Anaerobic | 45 | 90
Which explanation best accounts for the data?', null, md5('apbio-mcq-b2-h-3.5-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Without oxygen, glycolysis stops and the Krebs cycle runs faster to supply the ATP.', false, 'The Krebs cycle also depends on NAD⁺ that the electron transport chain regenerates, so it cannot speed up without oxygen.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fermentation yields more ATP per glucose than aerobic respiration, so the cells can use their glucose more freely.', false, 'The data show about 2 ATP per glucose anaerobically versus 30 aerobically, so the yield per glucose is lower.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Without oxygen the electron transport chain cannot regenerate NAD⁺, but fermentation does; glycolysis continues at about 2 ATP per glucose, so far more glucose must be used for ATP.', true, 'Correct: ATP per glucose is 30 aerobically (150/5) and 2 anaerobically (90/45), consistent with fermentation regenerating NAD⁺ so glycolysis can continue at a low yield.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Without oxygen more glucose enters the mitochondria, where it is oxidized with a higher yield.', false, 'Glycolysis occurs in the cytosol, and mitochondria cannot run the electron transport chain without oxygen, so more glucose in the mitochondria would not raise the yield.' from version_ins;
-- apbio-mcq-b2-sv-h-3.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.5-a-v1', 'mcq', 'effect of anaerobic conditions, cyanide, lactate and compartmentation on respiration (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Intact aerobic human cells are given glucose and oxygen. Cyanide, which blocks the last electron carrier of the electron transport chain, is added. Assume the cells cannot make up for the block by fermentation, and Krebs cycle activity is measured as CO₂ release within a few minutes. Which prediction is best?', null, md5('apbio-mcq-b2-sv-h-3.5-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'CO₂ release rises, because pyruvate accumulates and enters the Krebs cycle faster.', false, 'The Krebs cycle slows when NAD⁺ is depleted, so pyruvate cannot be processed faster.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CO₂ release is unchanged, because CO₂ is made by decarboxylation reactions that do not depend on oxygen.', false, 'The decarboxylation steps depend on NAD⁺ being regenerated, which requires electron transport and ultimately oxygen.' from version_ins
union all select gen_random_uuid(), id, 'C', 'CO₂ release rises, because the cells increase their oxygen consumption to compensate.', false, 'Cyanide blocks the use of oxygen, so oxygen consumption falls and cannot compensate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'CO₂ release falls, because NADH is no longer oxidized to NAD⁺, so NAD⁺-dependent steps of pyruvate oxidation and the Krebs cycle slow.', true, 'Correct: blocking electron flow leaves NADH unoxidized, depleting NAD⁺ needed by the dehydrogenases of pyruvate oxidation and the Krebs cycle, so CO₂ release falls.' from version_ins;
-- apbio-mcq-b2-sv-h-3.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.5-a-v2', 'mcq', 'effect of anaerobic conditions, cyanide, lactate and compartmentation on respiration (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'During a sprint, a muscle cell''s oxygen supply does not keep pace with its ATP demand. Lactate accumulates in the muscle. Which statement best explains the role of lactate formation?', null, md5('apbio-mcq-b2-sv-h-3.5-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Lactate formation produces most of the muscle''s ATP during the sprint.', false, 'Fermentation makes only about 2 ATP per glucose, so it adds a small amount of ATP compared with aerobic respiration.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Lactate formation generates the oxygen that the cell is missing.', false, 'Lactate formation does not make oxygen, and nothing in the pathway can create oxygen.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Lactate formation lets the electron transport chain run faster by supplying more NADH.', false, 'The pathway consumes NADH, and the electron transport chain is limited by oxygen supply, so it cannot run faster.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Converting pyruvate to lactate oxidizes NADH to NAD⁺, which lets glycolysis continue making a small amount of ATP without oxygen.', true, 'Correct: glycolysis needs NAD⁺, and the reduction of pyruvate to lactate regenerates it, so glycolysis can continue to make 2 ATP per glucose.' from version_ins;
-- apbio-mcq-b2-sv-h-3.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.5-a-v3', 'mcq', 'effect of anaerobic conditions, cyanide, lactate and compartmentation on respiration (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher isolates intact mitochondria and supplies them with oxygen, ADP and phosphate. When glucose is added, no ATP is made. When pyruvate is added instead, ATP is made. Which explanation is best?', null, md5('apbio-mcq-b2-sv-h-3.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Glucose cannot be oxidized in the presence of oxygen, but pyruvate can.', false, 'Glucose is oxidized in cells in the presence of oxygen, and the problem is where the enzymes needed are located.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Glycolysis, which converts glucose to pyruvate, occurs in the cytosol, whereas pyruvate enters the mitochondrion where its oxidation and the later stages of respiration occur.', true, 'Correct: the enzymes of glycolysis are in the cytosol and are absent from isolated mitochondria, so glucose cannot be processed, while pyruvate enters the matrix and feeds the later stages.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mitochondria use pyruvate and not glucose because glucose is too large to be oxidized at all.', false, 'Glucose can be fully oxidized by cells, and the issue is that the first stage of its breakdown occurs outside the mitochondrion.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The mitochondrial ATP synthase works only with pyruvate as a substrate.', false, 'ATP synthase is driven by a proton gradient and does not require pyruvate itself.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-h-3.5-a','apbio-mcq-b2-sv-h-3.5-a-v1','apbio-mcq-b2-sv-h-3.5-a-v2','apbio-mcq-b2-sv-h-3.5-a-v3']) and status='draft')<>4 then raise exception 'chunk 5: expected 4 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b2-h-3.5-a','apbio-mcq-b2-sv-h-3.5-a-v1','apbio-mcq-b2-sv-h-3.5-a-v2','apbio-mcq-b2-sv-h-3.5-a-v3']))<>16 then raise exception 'chunk 5: expected 16 choices'; end if;
end $$;
commit;
