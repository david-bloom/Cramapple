begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-sv-h-3.2-b-v2','apbio-mcq-b2-sv-h-3.2-b-v3','apbio-mcq-b2-h-3.3-a','apbio-mcq-b2-sv-h-3.3-a-v1','apbio-mcq-b2-sv-h-3.3-a-v2','apbio-mcq-b2-sv-h-3.3-a-v3','apbio-mcq-b2-h-3.3-b','apbio-mcq-b2-sv-h-3.3-b-v1','apbio-mcq-b2-sv-h-3.3-b-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apbio-mcq-b2-sv-h-3.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.2-b-v2', 'mcq', 'identify and fix a design flaw in an enzyme environment experiment (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student tests the effect of pH on an enzyme. Tubes at pH 4, 7 and 10 are prepared. The pH 4 tube is kept on ice until the assay, the pH 7 tube is at room temperature, and the pH 10 tube is warmed to 37°C, because that is what was convenient. Initial rates are 3, 15 and 6. Which change would best allow a valid conclusion about pH?', null, md5('apbio-mcq-b2-sv-h-3.2-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Use a larger number of different pH values and keep the original temperatures.', false, 'More pH values do not fix the confounding because each would still carry a different temperature.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Bring all tubes to the same temperature before adding the enzyme so that pH is the only variable that differs.', true, 'Correct: temperature differs between tubes, so rate differences cannot be assigned to pH until all tubes share one temperature.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Use a fresh enzyme sample at each pH and keep the original temperatures.', false, 'Fresh enzyme at each pH does not change that the tubes differ in temperature, and the confounding remains.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Run only the pH 7 tube at 37°C because that is closest to body temperature.', false, 'Testing only one tube at 37°C does not give a comparison across pH and does not remove the differing temperatures from the other tubes.' from version_ins;
-- apbio-mcq-b2-sv-h-3.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.2-b-v3', 'mcq', 'identify and fix a design flaw in an enzyme environment experiment (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student measures the rate of an enzyme at 30°C and at 35°C using one tube at each temperature. The rates are 12.0 and 12.8 units. She concludes that the enzyme is more active at 35°C. Which change would best strengthen the conclusion?', null, md5('apbio-mcq-b2-sv-h-3.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Run several replicate tubes at each temperature and compare the means and the spread of the replicates.', true, 'Correct: a difference of 0.8 units from single tubes could be within normal variation, and replicates allow the difference to be judged against the spread.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Increase the temperature difference to 3°C by repeating the 35°C tube at 38°C.', false, 'Changing the 35°C condition to 38°C does not address whether the original difference was real, and it changes the variable under test.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Use only the 35°C tube, since it had the higher rate.', false, 'Dropping the 30°C tube removes the comparison that the claim depends on.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Switch to a higher substrate concentration in the 35°C tube only.', false, 'Raising substrate only in one tube adds a second variable and makes the comparison invalid.' from version_ins;
-- apbio-mcq-b2-h-3.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-3.3-a', 'mcq', 'net free-energy change of coupled reactions; catalysis vs coupling', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cell converts compound X to compound Y in a reaction with a free-energy change of +20 kJ/mol. The hydrolysis of ATP to ADP and phosphate has a free-energy change of −30 kJ/mol. An enzyme couples the two by transferring the terminal phosphate of ATP to X. Which prediction is best?', null, md5('apbio-mcq-b2-h-3.3-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The coupled reaction has a free-energy change of −50 kJ/mol, because the two magnitudes add.', false, 'The values must be added with their signs, and adding magnitudes treats an energy cost as a gain.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The coupled reaction has a free-energy change of −10 kJ/mol, so it can proceed spontaneously.', true, 'Correct: the free-energy changes of coupled reactions add algebraically, +20 + (−30) = −10 kJ/mol, which is negative, so the overall process is spontaneous.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The coupled reaction keeps a free-energy change of +20 kJ/mol, so it still does not proceed.', false, 'Coupling changes the overall free-energy change because the ATP hydrolysis is part of the coupled reaction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The coupled reaction has a free-energy change of +50 kJ/mol, because the ATP hydrolysis adds a cost.', false, 'ATP hydrolysis is exergonic and contributes a negative value, so it lowers the total and does not raise it.' from version_ins;
-- apbio-mcq-b2-sv-h-3.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.3-a-v1', 'mcq', 'net free-energy change of coupled reactions; catalysis vs coupling (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A reaction has a free-energy change of +35 kJ/mol and is coupled by an enzyme to the hydrolysis of one ATP (−30 kJ/mol) under the same conditions. Which prediction is best?', null, md5('apbio-mcq-b2-sv-h-3.3-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The coupled reaction proceeds, because any exergonic reaction drives any endergonic reaction.', false, 'The coupled process proceeds only if the sum of the free-energy changes is negative, which is not the case here.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The coupled reaction has an overall change of −30 kJ/mol, because the more negative step determines the result.', false, 'The sum is +35 − 30, and the larger value does not simply dominate by being more negative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The coupled reaction is spontaneous because the enzyme lowers the activation energy.', false, 'An enzyme lowers activation energy but does not change the free-energy change, so it cannot make a positive net value spontaneous.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The coupled reaction has an overall change of +5 kJ/mol and would not proceed, but coupling to two ATP (−60 kJ/mol) would give −25 kJ/mol.', true, 'Correct: +35 − 30 = +5 kJ/mol, which is positive; adding a second ATP hydrolysis gives +35 − 60 = −25 kJ/mol, which is negative.' from version_ins;
-- apbio-mcq-b2-sv-h-3.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.3-a-v2', 'mcq', 'net free-energy change of coupled reactions; catalysis vs coupling (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a cell, the formation of ATP from ADP and phosphate has a free-energy change of +30 kJ/mol. An enzyme couples this to the breakdown of phosphoenolpyruvate, which releases −62 kJ/mol. Which statement is best?', null, md5('apbio-mcq-b2-sv-h-3.3-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The coupled reaction has a free-energy change of +92 kJ/mol, so ATP cannot form.', false, 'The +92 value comes from subtracting the sign of an exergonic reaction, whereas it contributes a negative term.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The coupled reaction has a free-energy change of −32 kJ/mol, so ATP formation can proceed.', true, 'Correct: −62 + 30 = −32 kJ/mol, which is negative, so ATP synthesis driven by this reaction can proceed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The coupled reaction has a free-energy change of −62 kJ/mol, because the breakdown of phosphoenolpyruvate is unaffected by the coupling.', false, 'The two free-energy changes add to give a single value, and the reaction with positive value contributes to it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The coupled reaction has a free-energy change of −30 kJ/mol, because ATP formation always releases energy.', false, 'ATP formation from ADP and phosphate requires an energy input and has a positive free-energy change.' from version_ins;
-- apbio-mcq-b2-sv-h-3.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.3-a-v3', 'mcq', 'net free-energy change of coupled reactions; catalysis vs coupling (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An enzyme is added to a solution of X, which converts to Y in a reaction with a free-energy change of +20 kJ/mol. No ATP is present. Which prediction about the reaction after a long time is best?', null, md5('apbio-mcq-b2-sv-h-3.3-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The enzyme makes the reaction spontaneous because it lowers the activation energy, so most X becomes Y.', false, 'Lowering activation energy changes speed only, and the free-energy change that sets the equilibrium is unchanged.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The enzyme speeds the approach to equilibrium and shifts the equilibrium toward Y, so at equilibrium most of the material is Y.', false, 'An enzyme does not shift the equilibrium, because it speeds the forward and reverse reactions equally and leaves the free-energy difference between X and Y unchanged.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The enzyme supplies energy from its own bonds, so the reaction proceeds until all X is gone.', false, 'Enzymes are not consumed and do not donate energy from their own bonds to drive reactions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The enzyme speeds the approach to equilibrium, but at equilibrium most of the material is still X because the enzyme does not change the free-energy change.', true, 'Correct: a catalyst changes the rate and not the free-energy change or the equilibrium position, so the reaction with ΔG = +20 kJ/mol still favors X.' from version_ins;
-- apbio-mcq-b2-h-3.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-3.3-b', 'mcq', 'ATP cycling: use and regeneration, with perturbations', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In skeletal muscle, the concentration of ATP is about 5.0 mM at rest and about 4.8 mM during intense contraction, even though the rate of ATP hydrolysis is about 20 times higher during contraction. Which explanation best accounts for the nearly constant ATP concentration?', null, md5('apbio-mcq-b2-h-3.3-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ADP and phosphate produced by hydrolysis are rapidly converted back to ATP using energy from fuel oxidation, so synthesis keeps pace with use.', true, 'Correct: a constant concentration at a higher rate of hydrolysis means regeneration also speeds up; the cell resynthesizes ATP from ADP and phosphate using energy from catabolism.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Muscle cells store a very large pool of ATP, and hydrolysis during contraction takes ATP from it without any replacement.', false, 'The muscle holds only a small ATP pool, which would be used up within seconds of intense work, so a replacement is essential.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ATP hydrolysis releases energy that creates new ATP molecules directly, so the pool is replaced by hydrolysis itself.', false, 'Hydrolysis releases energy but does not make ATP, and ATP synthesis requires energy from the breakdown of fuels.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Contraction uses energy directly from glucose and not from ATP, so ATP hydrolysis hardly affects the pool.', false, 'The stem states hydrolysis is 20 times higher in contraction, and energy from glucose is first transferred to ATP.' from version_ins;
-- apbio-mcq-b2-sv-h-3.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.3-b-v1', 'mcq', 'ATP cycling: use and regeneration, with perturbations (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cultured cells are grown on a medium that forces them to make ATP only by ATP synthase in mitochondria. A researcher adds oligomycin, which blocks ATP synthase, and then monitors the cells. Compared with untreated cells, which change is most likely over the next few minutes?', null, md5('apbio-mcq-b2-sv-h-3.3-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The ratio of ATP to ADP rises, because ATP hydrolysis stops when ATP synthase is blocked.', false, 'The enzymes that use ATP are not blocked, so hydrolysis continues and the ATP concentration falls.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The ratio of ATP to ADP stays the same, because cells hold ATP in lipid droplets for later use.', false, 'Cells do not keep a large ATP reserve in lipid droplets, and the small ATP pool turns over quickly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The ratio of ATP to ADP falls, but active transport speeds up because more ADP is available to power it.', false, 'ADP does not power transport, which needs energy released by hydrolysis of ATP, so transport slows as ATP falls.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The ratio of ATP to ADP falls because ATP use continues, and energy-requiring processes such as active transport slow down.', true, 'Correct: with no way to regenerate ATP, continued hydrolysis lowers the ATP to ADP ratio, and processes that use ATP slow as the supply falls.' from version_ins;
-- apbio-mcq-b2-sv-h-3.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.3-b-v2', 'mcq', 'ATP cycling: use and regeneration, with perturbations (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A resting adult has about 50 g of ATP in the body at any moment but hydrolyzes about 50 kg of ATP per day. Which statement best reconciles these numbers?', null, md5('apbio-mcq-b2-sv-h-3.3-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The body makes 50 kg of new ATP each day from nothing, using energy absorbed from the environment.', false, 'ATP is built from ADP and phosphate with energy from fuel oxidation, and not from nothing or the environment.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only 50 g of ATP is hydrolyzed each day, and the 50 kg estimate counts the same energy several times.', false, 'The question gives the rate of hydrolysis as 50 kg per day, and recycling lets the same molecules be hydrolyzed repeatedly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Each ATP molecule is recycled about 1,000 times a day, because ADP and phosphate are converted back to ATP using energy from food molecules.', true, 'Correct: 50 kg divided by 50 g is 1,000, so each molecule is used and regenerated about 1,000 times per day; regeneration uses energy released from catabolism.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The body stores 50 kg of ATP in the liver, and only 50 g is in use at one time.', false, 'ATP is not stored in large amounts in any organ because it is unstable, so the explanation is recycling, not storage.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-sv-h-3.2-b-v2','apbio-mcq-b2-sv-h-3.2-b-v3','apbio-mcq-b2-h-3.3-a','apbio-mcq-b2-sv-h-3.3-a-v1','apbio-mcq-b2-sv-h-3.3-a-v2','apbio-mcq-b2-sv-h-3.3-a-v3','apbio-mcq-b2-h-3.3-b','apbio-mcq-b2-sv-h-3.3-b-v1','apbio-mcq-b2-sv-h-3.3-b-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b2-sv-h-3.2-b-v2','apbio-mcq-b2-sv-h-3.2-b-v3','apbio-mcq-b2-h-3.3-a','apbio-mcq-b2-sv-h-3.3-a-v1','apbio-mcq-b2-sv-h-3.3-a-v2','apbio-mcq-b2-sv-h-3.3-a-v3','apbio-mcq-b2-h-3.3-b','apbio-mcq-b2-sv-h-3.3-b-v1','apbio-mcq-b2-sv-h-3.3-b-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
