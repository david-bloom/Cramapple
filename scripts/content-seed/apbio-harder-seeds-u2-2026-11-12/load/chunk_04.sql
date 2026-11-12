begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.4-a-v3','apbio-mcq-b5-h-2.4-b','apbio-mcq-b5-sv-h-2.4-b-v1','apbio-mcq-b5-sv-h-2.4-b-v2','apbio-mcq-b5-sv-h-2.4-b-v3','apbio-mcq-b5-h-2.5-a','apbio-mcq-b5-sv-h-2.5-a-v1','apbio-mcq-b5-sv-h-2.5-a-v2','apbio-mcq-b5-sv-h-2.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apbio-mcq-b5-sv-h-2.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.4-a-v3', 'mcq', 'predict relative permeability of a pure phospholipid bilayer from molecular size, charge, and polarity using a data tabl (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pharmaceutical team compares three candidate drugs for their ability to diffuse across the plasma membrane without help from transport proteins. Drug X has a mass of 500 daltons and is uncharged and nonpolar. Drug Y has a mass of 180 daltons and is uncharged but polar. Drug Z has a mass of 150 daltons and carries a charge of +1. Which prediction is most reasonable?', null, md5('apbio-mcq-b5-sv-h-2.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Drug Z will cross most easily, because it is the smallest of the three.', false, 'A charge strongly reduces permeability regardless of small size, so Z would cross least easily.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Drug Y will cross most easily, because it is smaller than drug X and has no charge.', false, 'Polar molecules cross more slowly than nonpolar ones, so the smaller size of Y does not make up for its polarity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All three will cross at the same rate, because the plasma membrane is equally permeable to all small molecules.', false, 'The plasma membrane is selectively permeable and discriminates strongly by polarity and charge.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Drug X will cross most easily, because its nonpolar character allows it to dissolve in the hydrophobic core even though it is the largest.', true, 'Correct: Nonpolar molecules dissolve in the lipid core and cross faster than polar or charged molecules of lower mass; the charged drug Z should be slowest, with polar drug Y in between.' from version_ins;
-- apbio-mcq-b5-h-2.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.4-b', 'mcq', 'use control preparations to attribute selective transport of a polar substance to a membrane protein rather than to the ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers prepare liposomes (spheres of phospholipid bilayer). One set contains only phospholipids. A second set also contains purified protein T. Radioactive D-glucose or its mirror-image isomer L-glucose is added outside, and uptake after 10 minutes is measured in arbitrary units. Phospholipid-only liposomes: D-glucose 2, L-glucose 2. Liposomes with protein T: D-glucose 85, L-glucose 3. Which conclusion is best supported?', null, md5('apbio-mcq-b5-h-2.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Protein T allows D-glucose across the membrane and is selective for the shape of the molecule, while the phospholipid bilayer alone is almost impermeable to glucose.', true, 'Correct: Without protein T, both isomers enter slowly (2 units); with protein T, D-glucose uptake is 85 but L-glucose stays at 3, so T is specific for D-glucose and the bilayer alone is a poor route for glucose.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Protein T makes the bilayer leaky to all sugars, because glucose uptake increases.', false, 'L-glucose uptake does not increase, so the bilayer is not made leaky to sugars in general.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Glucose crosses the phospholipid bilayer easily by simple diffusion, and protein T is not needed.', false, 'Uptake into phospholipid-only liposomes is only 2 units, so glucose does not cross the bilayer easily.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Protein T is a channel that allows any molecule of the same mass as glucose to pass.', false, 'L-glucose has the same mass as D-glucose but is not transported, so selection is based on shape and not on mass.' from version_ins;
-- apbio-mcq-b5-sv-h-2.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.4-b-v1', 'mcq', 'use control preparations to attribute selective transport of a polar substance to a membrane protein rather than to the  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Liposomes are made with or without protein K. Radioactive K⁺ or Na⁺ is added outside, and uptake after 5 minutes is measured in arbitrary units. Phospholipid-only liposomes: K⁺ 1, Na⁺ 1. Liposomes with protein K: K⁺ 90, Na⁺ 4. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.4-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Protein K forms a pore that lets any small charged particle through.', false, 'Na⁺ is also a small charged particle, but its uptake is barely changed, so the pore is selective.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ions cross the phospholipid bilayer slowly and protein K slows the crossing of Na⁺.', false, 'Na⁺ uptake rises slightly from 1 to 4 rather than falling, so the protein does not slow it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Protein K is needed to move both ions, but it transports K⁺ much faster simply because K⁺ is positively charged.', false, 'Both ions carry the same charge, so charge alone cannot explain the large difference between them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Protein K provides a pathway that is selective for K⁺, because the protein greatly increases K⁺ uptake but not Na⁺ uptake.', true, 'Correct: With protein K, K⁺ uptake rises from 1 to 90 while Na⁺ uptake changes only from 1 to 4, so the pathway is selective rather than a general hole.' from version_ins;
-- apbio-mcq-b5-sv-h-2.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.4-b-v2', 'mcq', 'use control preparations to attribute selective transport of a polar substance to a membrane protein rather than to the  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Liposomes are loaded with three types of protein preparations and then exposed to radioactive D-glucose for 10 minutes. Uptake in arbitrary units: phospholipid only, 2; with native protein T, 85; with protein T that has been heated until it is denatured, 3. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.4-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Heat made the bilayer more permeable, which accounts for the result.', false, 'Heat damage to the bilayer would increase uptake rather than reduce it to the baseline, and the denatured sample shows only 3 units.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Protein T works by dissolving in the phospholipids, so its three-dimensional shape does not matter.', false, 'If shape did not matter, the denatured protein would still increase uptake, but it does not.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Any protein placed in a liposome will increase uptake of glucose.', false, 'The denatured protein is also a protein but has no effect, so the presence of protein alone is not enough.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Transport depends on the folded three-dimensional shape of protein T, because denaturing it removes its effect.', true, 'Correct: Native T raises uptake from 2 to 85, but denatured T gives 3, which is close to the protein-free value, so the folded structure is needed for transport.' from version_ins;
-- apbio-mcq-b5-sv-h-2.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.4-b-v3', 'mcq', 'use control preparations to attribute selective transport of a polar substance to a membrane protein rather than to the  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher adds increasing amounts of purified protein T to liposomes and measures radioactive D-glucose uptake in 10 minutes. With 0 micrograms of protein, uptake is 2 units; with 1 microgram, 40 units; with 2 micrograms, 78 units; with 4 micrograms, 155 units. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Uptake increases approximately in proportion to the amount of protein T, which supports transport being carried out by protein T in the membrane.', true, 'Correct: Uptake roughly doubles each time the amount of protein doubles (40, 78, 155), so the glucose crossing is mediated by the protein rather than the bilayer.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Glucose crosses the phospholipid bilayer itself, and protein T only slightly increases the rate.', false, 'The protein-free value is only 2 units compared with 155 units at the highest dose, so the bilayer contributes almost nothing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Protein T has used up all of its binding sites by 1 microgram, because uptake is greatest at that amount.', false, 'Uptake keeps increasing with more protein, so 1 microgram is not the point of maximum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Protein T lowers the permeability of the bilayer to glucose, because uptake without the protein is below 5 units.', false, 'Uptake rises, not falls, when protein is added, so the protein increases permeability to glucose.' from version_ins;
-- apbio-mcq-b5-h-2.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.5-a', 'mcq', 'classify a transport process as passive or active from time-course data on solute concentration and the effect of an ene', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Yeast cells are placed in a medium containing 1 mM of a nonmetabolizable amino acid analog, and the external concentration is kept constant. Internal concentration (mM) is measured: 0 minutes, 0; 10 minutes, 0.9; 20 minutes, 3.2; 40 minutes, 6.0; 60 minutes, 6.0. At 60 minutes an inhibitor of ATP production is added, and by 90 minutes the internal concentration has fallen to 1.0 mM. Which conclusion is best supported?', null, md5('apbio-mcq-b5-h-2.5-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The analog is moved by active transport, because the cell accumulates it above the outside concentration and the accumulation depends on ATP.', true, 'Correct: Passive transport can only equalize the concentrations (1 mM), but the cell holds 6.0 mM against 1 mM outside; when ATP production is blocked the gradient collapses to 1.0 mM, so the transport needs energy.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The analog crosses by simple diffusion, because the internal concentration rises over time.', false, 'Simple diffusion would stop at equal concentrations of 1 mM and could not build a 6-fold gradient.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The analog crosses by facilitated diffusion, which stops when the carrier proteins are saturated at 6.0 mM.', false, 'Facilitated diffusion is passive and cannot raise the internal concentration above the external one, so a plateau at 6.0 mM is not explained by saturation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The analog enters by endocytosis, because the internal concentration plateaus when the vesicles are full.', false, 'A plateau in a concentration above the outside level reflects an energy-driven pump, and nothing in the data indicates vesicles.' from version_ins;
-- apbio-mcq-b5-sv-h-2.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.5-a-v1', 'mcq', 'classify a transport process as passive or active from time-course data on solute concentration and the effect of an ene (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Root cells in soil water containing 0.2 mM nitrate accumulate nitrate to an internal concentration of 2.0 mM. When the roots are placed in an environment with no oxygen, so that ATP production falls sharply, nitrate uptake stops and the internal concentration gradually declines. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Nitrate enters by simple diffusion through the phospholipid bilayer, which fails without oxygen.', false, 'Simple diffusion cannot concentrate a substance above its external level and does not depend on oxygen or ATP.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Nitrate enters by active transport against its concentration gradient, which depends on cellular energy.', true, 'Correct: Internal nitrate (2.0 mM) is ten times the external concentration (0.2 mM), and uptake needs ATP, so nitrate is moved against its gradient by active transport.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Nitrate enters by facilitated diffusion, so a carrier protein is needed only until the concentrations are equal at 0.2 mM.', false, 'Facilitated diffusion is passive, so it could not produce an internal concentration ten times higher than the outside.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The roots take up nitrate by exocytosis, which needs ATP only for forming vesicles.', false, 'Exocytosis moves material out of the cell, so it cannot be the mechanism of nitrate uptake.' from version_ins;
-- apbio-mcq-b5-sv-h-2.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.5-a-v2', 'mcq', 'classify a transport process as passive or active from time-course data on solute concentration and the effect of an ene (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A mammalian cell is placed in medium containing 5 mM of a nonmetabolizable sugar. Internal sugar concentration rises and levels off at 5 mM. When the outside concentration is raised stepwise, the rate of uptake increases less and less and approaches a maximum. An inhibitor of ATP synthesis has no effect on either result. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.5-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Active transport, because the process involves a protein that limits the maximum rate.', false, 'Active transport would lower or raise the internal level beyond the outside concentration and would be blocked by the ATP inhibitor, which did not happen.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Simple diffusion through the bilayer, because the internal concentration reaches the outside concentration.', false, 'Simple diffusion would increase in proportion to the outside concentration without reaching a maximum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Facilitated diffusion by carrier proteins, because uptake is saturable, stops at equal concentrations, and does not need ATP.', true, 'Correct: A maximum rate shows a limited number of carriers; leveling off at 5 mM (equal to outside) and no effect of the ATP inhibitor show the process is passive, which is facilitated diffusion.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Receptor-mediated endocytosis, because the uptake approaches a maximum.', false, 'Endocytosis requires energy and is not expected to continue unaffected by an ATP inhibitor.' from version_ins;
-- apbio-mcq-b5-sv-h-2.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.5-a-v3', 'mcq', 'classify a transport process as passive or active from time-course data on solute concentration and the effect of an ene (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher measures uptake of a small, uncharged, nonpolar solute by cells over a range of outside concentrations from 1 to 100 mM. Uptake rate increases in direct proportion to the outside concentration across the whole range, and neither an ATP inhibitor nor a molecule that binds to carrier proteins changes the rate. Which statement is best supported?', null, md5('apbio-mcq-b5-sv-h-2.5-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The solute is carried by a protein channel, because the rate does not depend on ATP.', false, 'A protein channel or carrier would saturate at high concentration, and a carrier-binding molecule would reduce the rate, but neither occurred.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The solute is transported actively, because the cell takes it up faster at high concentrations.', false, 'Active transport would be blocked by the ATP inhibitor and would not be limited by the gradient in this way.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The solute crosses by simple diffusion through the lipid bilayer, because the rate is proportional to the gradient and is unaffected by energy or carrier inhibitors.', true, 'Correct: A rate that rises linearly without saturating and does not respond to ATP or carrier inhibitors is the signature of simple diffusion of a small nonpolar solute.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The solute enters by phagocytosis, because the rate increases with concentration.', false, 'Phagocytosis takes up large particles using energy and would not depend linearly on dissolved concentration.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.4-a-v3','apbio-mcq-b5-h-2.4-b','apbio-mcq-b5-sv-h-2.4-b-v1','apbio-mcq-b5-sv-h-2.4-b-v2','apbio-mcq-b5-sv-h-2.4-b-v3','apbio-mcq-b5-h-2.5-a','apbio-mcq-b5-sv-h-2.5-a-v1','apbio-mcq-b5-sv-h-2.5-a-v2','apbio-mcq-b5-sv-h-2.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-sv-h-2.4-a-v3','apbio-mcq-b5-h-2.4-b','apbio-mcq-b5-sv-h-2.4-b-v1','apbio-mcq-b5-sv-h-2.4-b-v2','apbio-mcq-b5-sv-h-2.4-b-v3','apbio-mcq-b5-h-2.5-a','apbio-mcq-b5-sv-h-2.5-a-v1','apbio-mcq-b5-sv-h-2.5-a-v2','apbio-mcq-b5-sv-h-2.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
