begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.7-b-v2','apbio-mcq-b5-sv-h-2.7-b-v3','apbio-mcq-b5-h-2.8-a','apbio-mcq-b5-sv-h-2.8-a-v1','apbio-mcq-b5-sv-h-2.8-a-v2','apbio-mcq-b5-sv-h-2.8-a-v3','apbio-mcq-b5-h-2.8-b','apbio-mcq-b5-sv-h-2.8-b-v1','apbio-mcq-b5-sv-h-2.8-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apbio-mcq-b5-sv-h-2.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.7-b-v2', 'mcq', 'infer the tonicity relationship and the osmoregulatory work an organism must do from data on its response in different s (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cylinders cut from a single potato are weighed, placed in sucrose solutions of different molarity for two hours, and weighed again. Mass change: 0.0 M, +14%; 0.2 M, +6%; 0.4 M, -2%; 0.6 M, -9%. Assuming that the change is linear between the measured points, which sucrose concentration is closest to the point at which the potato tissue has the same solute concentration as the solution?', null, md5('apbio-mcq-b5-sv-h-2.7-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.20 M', false, 'At 0.20 M the tissue is still gaining 6% of its mass, so water is still entering and the tissue is hypertonic to this solution.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.35 M', true, 'Correct: The mass change crosses zero between 0.2 M (+6%) and 0.4 M (-2%). Linear interpolation gives 0.2 + 0.2 × (6/8) = 0.35 M.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.40 M', false, 'At 0.40 M the tissue has already lost 2%, so this concentration is past the equilibrium point.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.60 M', false, 'At 0.60 M the tissue loses 9%, which is the largest water loss in the data.' from version_ins;
-- apbio-mcq-b5-sv-h-2.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.7-b-v3', 'mcq', 'infer the tonicity relationship and the osmoregulatory work an organism must do from data on its response in different s (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The internal osmolarity (mOsm) of two marine crab species is measured at four outside osmolarities. Outside 300, 600, 900, 1200. Species M, inside: 300, 600, 900, 1200. Species N, inside: 700, 700, 700, 700. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.7-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Species M must use more energy than species N, because its internal concentration changes.', false, 'Maintaining a constant internal osmolarity against a changing environment requires work, and species M does not do this.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Species N is isotonic to its surroundings at all four concentrations.', false, 'Species N is isotonic only when the outside is near 700, and at the four measured values it is not.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Species M regulates its internal osmolarity, because its internal values stay equal to the outside.', false, 'An internal concentration that simply follows the outside shows conforming, which is the opposite of regulating.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Species N regulates its internal osmolarity, so water tends to enter at 300 and leave at 1200, whereas species M matches its surroundings and has no net water movement.', true, 'Correct: Species M is always isotonic to the outside (no net water movement, little regulation). Species N holds 700 regardless of the outside value, so it is hypertonic to the outside at 300 and 600 and hypotonic at 900 and 1200, so it must do osmoregulatory work.' from version_ins;
-- apbio-mcq-b5-h-2.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.8-a', 'mcq', 'explain how a gradient built by an ATP-driven pump powers coupled transport of a second solute.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Intestinal cells absorb glucose from the gut using a membrane protein that moves one glucose molecule and one Na⁺ ion together into the cell. This protein does not hydrolyze ATP. On the opposite side of the cell, a Na⁺/K⁺ pump uses ATP to keep intracellular Na⁺ low. The pump is blocked with ouabain. After 20 minutes, intracellular Na⁺ has risen and glucose uptake from the gut has fallen sharply, although the glucose-Na⁺ protein is still present. Which explanation is best supported?', null, md5('apbio-mcq-b5-h-2.8-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The glucose protein uses the energy stored in the Na⁺ gradient, which the pump maintains; blocking the pump lets the gradient run down, so glucose is no longer pulled in against its gradient.', true, 'Correct: Uptake falls because the Na⁺ gradient (the energy source for the coupled protein) collapses when the pump is inhibited; ATP is used indirectly by the pump, not by the glucose protein.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The glucose protein hydrolyzes ATP directly, and ouabain depletes the cell''s ATP.', false, 'The problem states that the glucose-Na⁺ protein does not hydrolyze ATP, and the pump, not the glucose protein, is the ATP user.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Glucose enters by simple diffusion, which slows because the cell loses K⁺.', false, 'Glucose cannot be taken in against its gradient by simple diffusion, and the change in uptake is explained by the loss of the Na⁺ gradient.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ouabain denatures the glucose-Na⁺ protein, which prevents any binding of glucose.', false, 'The protein is still present and the effect follows from the rise in intracellular Na⁺, which is consistent with a loss of the driving gradient rather than denaturation.' from version_ins;
-- apbio-mcq-b5-sv-h-2.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.8-a-v1', 'mcq', 'explain how a gradient built by an ATP-driven pump powers coupled transport of a second solute. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Companion cells in a plant leaf load sucrose from the surrounding apoplast using a sucrose-H⁺ cotransporter that moves each sucrose molecule into the cell together with one H⁺ ion. A separate proton pump that uses ATP moves H⁺ out of the cell. When a chemical that inhibits the proton pump is added, the H⁺ concentration outside the cell falls toward that inside, and sucrose uptake into the cells falls greatly. Which explanation is best supported?', null, md5('apbio-mcq-b5-sv-h-2.8-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sucrose uptake depends on ATP binding to the cotransporter, which the chemical prevents.', false, 'The cotransporter is described as moving sucrose with H⁺ and does not use ATP, which is used by the separate pump.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sucrose passes through the bilayer by simple diffusion, which slows when the pH changes.', false, 'Sucrose is a large polar molecule and does not cross the bilayer by simple diffusion at a useful rate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cotransporter is a channel that opens only when the proton pump is working.', false, 'The cotransporter couples movement of two solutes and is not a gated channel opened by the pump.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The cotransporter uses the H⁺ gradient made by the pump to move sucrose into the cell, so loss of the gradient lowers sucrose uptake.', true, 'Correct: The pump (using ATP) builds a proton gradient; the cotransporter couples inward H⁺ movement down the gradient to inward movement of sucrose against its gradient. The pump inhibitor removes the gradient.' from version_ins;
-- apbio-mcq-b5-sv-h-2.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.8-a-v2', 'mcq', 'explain how a gradient built by an ATP-driven pump powers coupled transport of a second solute. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Bacteria accumulate lactose to an internal concentration 100 times the outside concentration using a membrane protein that carries one lactose and one H⁺ into the cell. A chemical that makes the membrane leaky to H⁺, so that the H⁺ gradient collapses, is added. ATP levels stay normal, but the internal lactose concentration falls toward the outside concentration. Which explanation is best supported?', null, md5('apbio-mcq-b5-sv-h-2.8-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The leaky membrane lets ATP escape, which stops accumulation.', false, 'ATP levels are reported to be normal, so ATP is not escaping.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The lactose protein depends on the H⁺ gradient for its energy, so lactose accumulation stops when the gradient is lost, even though ATP is still available.', true, 'Correct: Normal ATP with loss of accumulation shows that the energy comes from the H⁺ gradient used by the coupled protein, not from ATP directly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Lactose accumulation is by facilitated diffusion, which cannot cause the internal concentration to exceed the outside one, so the gradient is not involved.', false, 'Lactose accumulates 100-fold above the outside level, which facilitated diffusion cannot do, so the observed accumulation requires an energy source.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The chemical converts the lactose protein into a pump that uses ATP to move lactose outward.', false, 'Nothing in the data indicates a change in the protein, and the observed fall toward the outside concentration is explained by the loss of the gradient.' from version_ins;
-- apbio-mcq-b5-sv-h-2.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.8-a-v3', 'mcq', 'explain how a gradient built by an ATP-driven pump powers coupled transport of a second solute. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Heart muscle cells remove Ca²⁺ using an exchanger that moves 1 Ca²⁺ out of the cell as 3 Na⁺ move in, driven by the low intracellular Na⁺ concentration that the Na⁺/K⁺ pump maintains. The drug ouabain, which blocks the Na⁺/K⁺ pump, is added. Which change in intracellular Ca²⁺ is predicted, and why?', null, md5('apbio-mcq-b5-sv-h-2.8-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ca²⁺ falls, because the pump is blocked and the exchanger works faster.', false, 'A blocked pump does not speed up the exchanger; it weakens the Na⁺ gradient that powers it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ca²⁺ is unchanged, because the exchanger does not use ATP.', false, 'The exchanger does not use ATP directly but depends on a gradient the pump (an ATP user) maintains, so blocking the pump does change its function.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ca²⁺ falls, because more Na⁺ in the cell attracts Ca²⁺ out of the cell.', false, 'More Na⁺ inside reduces the inward driving force for Na⁺, which slows the removal of Ca²⁺.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ca²⁺ rises, because intracellular Na⁺ rises, which reduces the gradient that drives Ca²⁺ out through the exchanger.', true, 'Correct: Blocking the pump raises intracellular Na⁺, so less Na⁺ flows in down its gradient; the exchanger then removes less Ca²⁺ and the intracellular Ca²⁺ concentration rises.' from version_ins;
-- apbio-mcq-b5-h-2.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.8-b', 'mcq', 'predict the effects on membrane area, vesicle supply, and secretion when endocytosis or exocytosis is blocked.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a nerve terminal, synaptic vesicles fuse with the plasma membrane to release neurotransmitter, and the membrane is later retrieved by endocytosis to make new vesicles. In a mutant in which endocytosis is blocked but exocytosis works, the terminal is stimulated repeatedly for several minutes. Which set of changes is predicted?', null, md5('apbio-mcq-b5-h-2.8-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The plasma membrane area increases, the number of vesicles decreases, and neurotransmitter release declines.', true, 'Correct: Each fusion adds vesicle membrane to the plasma membrane. Without endocytosis, that membrane cannot be retrieved, so the surface area grows, the vesicle supply is depleted, and release falls.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The plasma membrane area stays the same and the number of vesicles increases.', false, 'Exocytosis adds vesicle membrane to the surface, and without endocytosis it is not removed, so the area does not stay the same.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The plasma membrane area decreases and the number of vesicles stays the same.', false, 'Fusion adds membrane to the surface; only endocytosis would remove it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The plasma membrane area increases and the number of vesicles increases, so neurotransmitter release rises.', false, 'Vesicles are used up by exocytosis and are not replenished without endocytosis, so release declines rather than rises.' from version_ins;
-- apbio-mcq-b5-sv-h-2.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.8-b-v1', 'mcq', 'predict the effects on membrane area, vesicle supply, and secretion when endocytosis or exocytosis is blocked. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A toxin blocks fusion of secretory vesicles with the plasma membrane in a growing hormone-secreting cell, but it does not block formation of vesicles at the Golgi complex. Which outcome is predicted after several hours?', null, md5('apbio-mcq-b5-sv-h-2.8-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cell secretes more hormone, because vesicles are not being used up.', false, 'Secretion requires fusion of vesicles with the membrane, so blocking fusion lowers secretion.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The plasma membrane area increases, because vesicles continue to deliver membrane.', false, 'The vesicle membrane merges into the plasma membrane only by fusion, so without fusion the area cannot increase.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Vesicles filled with hormone accumulate in the cytoplasm, the plasma membrane stops expanding, and secretion falls.', true, 'Correct: With fusion blocked, vesicles cannot deliver contents or membrane to the surface, so they accumulate inside, the membrane area stops growing, and the hormone is not released.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The Golgi complex enlarges and the cell takes up more hormone by endocytosis.', false, 'Nothing in the data shows an increase of hormone uptake, and the main consequence is accumulation of vesicles.' from version_ins;
-- apbio-mcq-b5-sv-h-2.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.8-b-v2', 'mcq', 'predict the effects on membrane area, vesicle supply, and secretion when endocytosis or exocytosis is blocked. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Liver cells take up LDL cholesterol by receptor-mediated endocytosis. In a patient, a mutation in the cytoplasmic part of the LDL receptor prevents receptors from clustering into the membrane regions that pinch off into vesicles. Which set of results is predicted?', null, md5('apbio-mcq-b5-sv-h-2.8-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'High LDL uptake by liver cells and low LDL in the blood.', false, 'This is the opposite of the predicted result, since reduced uptake leaves more LDL in the blood.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Normal LDL uptake, because LDL is nonpolar and crosses the bilayer by simple diffusion.', false, 'LDL is a large particle and does not cross the membrane by diffusion; it needs endocytosis.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Low LDL uptake, but LDL in the blood stays normal because the liver makes less cholesterol.', false, 'If the cells cannot remove LDL from the blood, the blood concentration rises, so a normal blood level is not expected.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Low LDL uptake by liver cells and high LDL in the blood, because bulk uptake by receptor-mediated endocytosis fails.', true, 'Correct: LDL enters cells by receptor-mediated endocytosis; if vesicle formation fails, cells take up less LDL, and LDL accumulates in the blood.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.7-b-v2','apbio-mcq-b5-sv-h-2.7-b-v3','apbio-mcq-b5-h-2.8-a','apbio-mcq-b5-sv-h-2.8-a-v1','apbio-mcq-b5-sv-h-2.8-a-v2','apbio-mcq-b5-sv-h-2.8-a-v3','apbio-mcq-b5-h-2.8-b','apbio-mcq-b5-sv-h-2.8-b-v1','apbio-mcq-b5-sv-h-2.8-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-sv-h-2.7-b-v2','apbio-mcq-b5-sv-h-2.7-b-v3','apbio-mcq-b5-h-2.8-a','apbio-mcq-b5-sv-h-2.8-a-v1','apbio-mcq-b5-sv-h-2.8-a-v2','apbio-mcq-b5-sv-h-2.8-a-v3','apbio-mcq-b5-h-2.8-b','apbio-mcq-b5-sv-h-2.8-b-v1','apbio-mcq-b5-sv-h-2.8-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
