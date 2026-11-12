begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-h-2.5-b','apbio-mcq-b5-sv-h-2.5-b-v1','apbio-mcq-b5-sv-h-2.5-b-v2','apbio-mcq-b5-sv-h-2.5-b-v3','apbio-mcq-b5-h-2.6-a','apbio-mcq-b5-sv-h-2.6-a-v1','apbio-mcq-b5-sv-h-2.6-a-v2','apbio-mcq-b5-sv-h-2.6-a-v3','apbio-mcq-b5-h-2.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apbio-mcq-b5-h-2.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.5-b', 'mcq', 'explain dynamic equilibrium: at equal concentrations, solute still crosses in both directions at equal rates with no net', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cell is bathed in a solution with the same concentration of a permeable, nonmetabolized solute S as the cytoplasm, 5 mM inside and 5 mM outside, and the concentrations stay constant. A researcher adds a small amount of radioactive S* to the outside. Within 10 minutes, radioactivity is detected inside the cell, but the total concentration of S inside remains 5 mM. Which explanation is best supported?', null, md5('apbio-mcq-b5-h-2.5-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Solute movement stopped when the concentrations became equal, so the radioactivity must have entered by endocytosis.', false, 'Molecular movement does not stop at equilibrium, and endocytosis is not needed to explain label crossing a permeable membrane.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The cell used ATP to pump S* in against its concentration gradient.', false, 'Pumping S* in against its gradient would steadily raise the total concentration of S above 5 mM, but the total stayed at 5 mM.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The membrane became leaky when the radioactive solute was added.', false, 'A leaky membrane would allow the total concentration to change, but the cell concentrations remained unchanged.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At equilibrium, S still crosses the membrane in both directions at equal rates, so labeled molecules enter while unlabeled molecules leave and there is no net change.', true, 'Correct: Radioactivity appears inside while total S stays at 5 mM, which means molecules continue to cross both ways at equal rates; equilibrium is dynamic, with no net movement.' from version_ins;
-- apbio-mcq-b5-sv-h-2.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.5-b-v1', 'mcq', 'explain dynamic equilibrium: at equal concentrations, solute still crosses in both directions at equal rates with no net (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A divided chamber has equal volumes of a nonmetabolized solute on the two sides, separated by a membrane permeable to it. The left side starts at 10 mM and the right at 2 mM. Assume the rate at which solute crosses the membrane in each direction (in mM per minute) equals the concentration on the side from which it starts (k = 1). What are the one-way rates and the net rate when the system has reached equilibrium?', null, md5('apbio-mcq-b5-sv-h-2.5-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both one-way rates are 0, because the solute stops moving at equilibrium.', false, 'Molecules continue to cross in both directions at equilibrium, so the one-way rates are not zero.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The rate left to right is 10 and the rate right to left is 2, giving a net rate of 8.', false, 'These are the starting rates before equilibrium and give a net movement of 8, which would not exist once the sides are equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The rate left to right is 6 and the rate right to left is 0, giving a net rate of 6.', false, 'The rate right to left depends on the concentration on the right, which is 6 at equilibrium, so it is not zero.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both one-way rates are 6, and the net rate is 0.', true, 'Correct: With equal volumes, equilibrium is at (10 + 2)/2 = 6 mM on each side. Each one-way rate equals 6, so the net rate is 6 minus 6 = 0. Initially the net rate was 10 minus 2 = 8.' from version_ins;
-- apbio-mcq-b5-sv-h-2.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.5-b-v2', 'mcq', 'explain dynamic equilibrium: at equal concentrations, solute still crosses in both directions at equal rates with no net (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cells are placed in an isotonic solution, so the cell volume stays constant. Tritiated (radioactive) water is added to the outside, and within a minute radioactive water is detected inside the cells, while the cell volume remains unchanged. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cell volume should have increased, so the data are in error.', false, 'Radioactive water entering does not mean net uptake, because unlabeled water leaves at the same rate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Water crosses the membrane in both directions at equal rates in an isotonic solution, so there is no net change in volume.', true, 'Correct: Constant volume means no net water movement, yet labeled water enters, so water molecules cross in both directions at equal rates at osmotic equilibrium.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cells are in a hypotonic solution, because water is entering.', false, 'A hypotonic solution would cause a net uptake and swelling, which is not seen here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'An aquaporin pump uses ATP to bring water in against its gradient.', false, 'Water moves by osmosis through the membrane and aquaporins as a passive process, and there is no energy-driven water pump.' from version_ins;
-- apbio-mcq-b5-sv-h-2.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.5-b-v3', 'mcq', 'explain dynamic equilibrium: at equal concentrations, solute still crosses in both directions at equal rates with no net (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cell and its surroundings are at equilibrium for a nonmetabolized permeable solute, with equal concentrations inside and out. The temperature of the system is then raised by 10°C, which increases the speed of molecular motion. Which prediction is most reasonable?', null, md5('apbio-mcq-b5-sv-h-2.5-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Net movement of solute out of the cell begins, because faster molecules leave more easily.', false, 'The solute molecules inside and outside speed up equally, so they leave and enter at equal rates and there is no net outflow.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Net movement of solute into the cell begins, because the molecules outside have more energy.', false, 'Both sides are warmed equally, so molecules on neither side gain an advantage and no net inflow results.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The concentrations stay equal, but the number of molecules crossing in each direction per minute increases equally.', true, 'Correct: Higher temperature increases the rate of movement in both directions equally, so equilibrium concentrations are unchanged and no net movement occurs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Transport stops, because the membrane becomes less fluid at higher temperatures.', false, 'Warming makes membranes more fluid, not less, and it increases rather than stops the exchange.' from version_ins;
-- apbio-mcq-b5-h-2.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.6-a', 'mcq', 'interpret rate versus concentration data to identify carrier-mediated transport and predict the effect of changing carri', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Uptake rate (micromoles per minute) of solute Z is measured at external concentrations of 1, 2, 4, 8, 16, and 32 mM. Cell type 1: 2, 4, 8, 16, 32, 64. Cell type 2: 10, 18, 29, 38, 42, 44. An inhibitor of ATP synthesis does not change the values for either cell type. Cell type 2 is engineered to have twice as many functional carrier proteins. Which outcome is expected?', null, md5('apbio-mcq-b5-h-2.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The maximum rate will stay at about 44, because the concentration gradient limits the rate.', false, 'The plateau is set by the number of carriers working at full capacity, not by the gradient, so adding carriers raises it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The rate will be higher at every concentration, and the maximum rate will approach about 88.', true, 'Correct: Cell type 1 is linear (simple diffusion); cell type 2 saturates near 44 because its carriers are fully occupied. Doubling the number of carriers doubles the capacity, so the maximum rate approaches about 88. Facilitated diffusion remains passive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cell will accumulate Z to a concentration above the outside concentration.', false, 'Facilitated diffusion is passive and can only move the solute toward equal concentrations, never above the outside level.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The extra carriers will have no effect, because transport does not require ATP.', false, 'The lack of ATP dependence means the process is passive, but the rate still depends on how many carriers are present.' from version_ins;
-- apbio-mcq-b5-sv-h-2.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.6-a-v1', 'mcq', 'interpret rate versus concentration data to identify carrier-mediated transport and predict the effect of changing carri (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Uptake rate (micromoles per minute) of glucose by cultured cells is measured at external glucose concentrations of 10, 20, 40, 80, and 160 mM, with the results 12, 21, 28, 30, and 30. Uptake is not changed by an ATP inhibitor. A researcher raises the outside concentration from 80 mM to 160 mM in cells that are already at the maximum rate. What happens to the uptake rate?', null, md5('apbio-mcq-b5-sv-h-2.6-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It stays almost the same, because essentially all carriers are already working at full capacity.', true, 'Correct: At the plateau (30 units) all carriers are occupied, so a higher concentration cannot increase the rate; the data show 30 at both 80 and 160 mM.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It doubles, because the gradient doubles.', false, 'A rate that doubles with the gradient is characteristic of simple diffusion, but these data show a plateau.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It decreases, because high concentrations denature the carriers.', false, 'The table shows the rate remains 30 at 160 mM, so there is no decrease.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is converted to active transport, because the cell is now at its limit.', false, 'A limit on carrier capacity does not convert a passive carrier into an energy-driven pump, which would need ATP.' from version_ins;
-- apbio-mcq-b5-sv-h-2.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.6-a-v2', 'mcq', 'interpret rate versus concentration data to identify carrier-mediated transport and predict the effect of changing carri (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cells take up glucose through a carrier. At an external glucose concentration of 2 mM, uptake is 20 units without an analog and 7 units with a structurally similar analog present. At 50 mM glucose, uptake is 48 units without the analog and 44 units with it. Which explanation is best supported?', null, md5('apbio-mcq-b5-sv-h-2.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The analog dissolves the membrane lipids, which reduces uptake at all concentrations equally.', false, 'Damage to the lipids would reduce uptake at all glucose concentrations, including 50 mM, but uptake there is nearly normal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The analog blocks ATP production, so uptake falls at low glucose concentrations.', false, 'Transport by a carrier is passive and does not depend on ATP, and a loss of ATP would not be overcome by more glucose.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The analog competes with glucose for the same binding site on the carrier, and a high glucose concentration overcomes the competition.', true, 'Correct: Uptake is strongly reduced at low glucose (7 versus 20) but nearly restored at high glucose (44 versus 48), which is the pattern of competition for the same carrier site.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The analog permanently destroys carriers, so uptake at 50 mM should also fall greatly.', false, 'Permanent destruction would also lower uptake at 50 mM, but it fell by only 4 units out of 48.' from version_ins;
-- apbio-mcq-b5-sv-h-2.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.6-a-v3', 'mcq', 'interpret rate versus concentration data to identify carrier-mediated transport and predict the effect of changing carri (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Uptake rates (micromoles per minute) of a solute are measured in three cell types at external concentrations of 2, 4, 8, 16, and 32 mM. Cell type P: 5, 10, 20, 40, 80. Cell type Q: 8, 14, 20, 22, 22. Cell type R: 4, 7, 10, 11, 11. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.6-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cell type P has the most carrier proteins, because it takes up the most solute at 32 mM.', false, 'The linear rise of P is characteristic of diffusion through the bilayer and does not indicate carriers, which would produce a maximum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cell types Q and R transport the solute by simple diffusion, because their rates level off.', false, 'Simple diffusion does not plateau, so a plateau indicates a limited number of carriers.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All three cell types transport the solute by active transport, because uptake increases with concentration.', false, 'Nothing in the data shows ATP dependence or accumulation, and a plateau is consistent with passive carrier-mediated transport.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cell types Q and R use carriers, and R has about half as many functional carriers as Q, because its maximum rate is half as large.', true, 'Correct: P rises linearly (simple diffusion). Q and R saturate at 22 and 11, so both use carriers, and R''s maximum is half of Q''s, consistent with half as many carriers.' from version_ins;
-- apbio-mcq-b5-h-2.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.6-b', 'mcq', 'explain that a transport protein for passive transport changes how fast equilibrium is reached but not the equilibrium c', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cells are placed in medium containing 5 mM of a nonmetabolized sugar, and internal concentration (mM) is measured. Cell type W, which has a sugar carrier: 0 minutes, 0; 2 minutes, 3.5; 5 minutes, 4.8; 10 minutes, 5.0; 30 minutes, 5.0. Cell type X, which lacks the carrier: 0 minutes, 0; 2 minutes, 0.1; 5 minutes, 0.2; 10 minutes, 0.4; 30 minutes, 1.2; 120 minutes, 3.0; 360 minutes, 5.0. Which conclusion is best supported?', null, md5('apbio-mcq-b5-h-2.6-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The carrier increases the rate at which the sugar reaches equilibrium but does not change the final concentration, which is 5.0 mM in both cell types.', true, 'Correct: Both cell types end at 5.0 mM, which equals the outside concentration, but W gets there in about 10 minutes and X takes about 360 minutes, so the carrier speeds equilibration without changing where it ends.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The carrier in cell type W concentrates the sugar inside the cell above the outside concentration.', false, 'The internal concentration of W stops at 5.0 mM, equal to the outside concentration, so there is no concentration above it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cell type X uses active transport, because its internal concentration reaches 5.0 mM only after a long time.', false, 'Active transport would cause accumulation above the outside concentration, but X stops at 5.0 mM and is slow because the sugar crosses the bilayer poorly.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The carrier requires ATP, which cell type X lacks, so uptake is slow in cell type X.', false, 'Facilitated diffusion does not require ATP, and X still takes up sugar slowly without it.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-h-2.5-b','apbio-mcq-b5-sv-h-2.5-b-v1','apbio-mcq-b5-sv-h-2.5-b-v2','apbio-mcq-b5-sv-h-2.5-b-v3','apbio-mcq-b5-h-2.6-a','apbio-mcq-b5-sv-h-2.6-a-v1','apbio-mcq-b5-sv-h-2.6-a-v2','apbio-mcq-b5-sv-h-2.6-a-v3','apbio-mcq-b5-h-2.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-h-2.5-b','apbio-mcq-b5-sv-h-2.5-b-v1','apbio-mcq-b5-sv-h-2.5-b-v2','apbio-mcq-b5-sv-h-2.5-b-v3','apbio-mcq-b5-h-2.6-a','apbio-mcq-b5-sv-h-2.6-a-v1','apbio-mcq-b5-sv-h-2.6-a-v2','apbio-mcq-b5-sv-h-2.6-a-v3','apbio-mcq-b5-h-2.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
