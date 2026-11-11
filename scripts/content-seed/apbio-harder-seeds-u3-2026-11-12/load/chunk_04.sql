begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-sv-h-3.3-b-v3','apbio-mcq-b2-h-3.4-a','apbio-mcq-b2-sv-h-3.4-a-v1','apbio-mcq-b2-sv-h-3.4-a-v2','apbio-mcq-b2-sv-h-3.4-a-v3','apbio-mcq-b2-h-3.4-b','apbio-mcq-b2-sv-h-3.4-b-v1','apbio-mcq-b2-sv-h-3.4-b-v2','apbio-mcq-b2-sv-h-3.4-b-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apbio-mcq-b2-sv-h-3.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.3-b-v3', 'mcq', 'ATP cycling: use and regeneration, with perturbations (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Vesicles containing a calcium pump are placed in a solution with calcium. With ATP, calcium accumulates inside the vesicles. With AMP-PNP, an analog that binds the pump like ATP but cannot be hydrolyzed, no calcium accumulates. Which conclusion is best supported?', null, md5('apbio-mcq-b2-sv-h-3.3-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Binding of a nucleotide to the pump supplies the energy for transport.', false, 'The analog binds the pump yet produces no transport, so binding by itself is not the energy source.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Transport needs the energy released when the terminal phosphate bond of ATP is hydrolyzed, and not only the binding of a nucleotide.', true, 'Correct: the analog binds but is not hydrolyzed and gives no transport, so the energy for transport comes from the hydrolysis step.' from version_ins
union all select gen_random_uuid(), id, 'C', 'AMP-PNP denatures the pump before transport can occur.', false, 'The stem says the analog binds the pump like ATP, and nothing suggests denaturation, so the lack of hydrolysis is the key difference.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ATP acts as an enzyme that lowers the activation energy for calcium movement.', false, 'ATP is a substrate and energy carrier, and the pump is the enzyme, so ATP does not act as an enzyme here.' from version_ins;
-- apbio-mcq-b2-h-3.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-3.4-a', 'mcq', 'interpret DCPIP/leaf-disc/stroma experiments separating light-dependent steps', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Isolated chloroplast suspensions are mixed with DCPIP, a blue dye that becomes colorless when it accepts electrons. Absorbance (higher means bluer, more unreduced DCPIP) is measured at the start (0.80 in every tube) and after 10 minutes.
Tube | Treatment | Absorbance at 10 min
1 | Intact chloroplasts, light | 0.25
2 | Intact chloroplasts, dark | 0.78
3 | Boiled chloroplasts, light | 0.79
4 | Intact chloroplasts, light, plus DCMU (blocks electron flow from photosystem II) | 0.77
Which conclusion is best supported?', null, md5('apbio-mcq-b2-h-3.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'DCPIP is reduced by electrons from light-driven electron transport in intact thylakoids, which needs light, intact membranes and working photosystem II.', true, 'Correct: only tube 1 loses blue color; without light, with denatured chloroplasts, or with electron flow blocked, absorbance stays near 0.80.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The fall in absorbance in tube 1 shows that the Calvin cycle fixes CO₂ in the light.', false, 'No CO₂ was supplied or measured, and DCPIP reduction reports electron flow in the light reactions and not carbon fixation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'DCPIP is reduced slightly in tubes 2 to 4 and more in tube 1, so light is helpful but not required.', false, 'The changes in tubes 2 to 4 (0.02, 0.01, 0.03) are very small and consistent with no reduction, so light is required.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Tube 3 shows that light alone is enough to reduce DCPIP, even in the absence of functional chloroplasts.', false, 'Tube 3 contains light but its absorbance barely changes, which shows light alone does not reduce DCPIP.' from version_ins;
-- apbio-mcq-b2-sv-h-3.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.4-a-v1', 'mcq', 'interpret DCPIP/leaf-disc/stroma experiments separating light-dependent steps (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The same DCPIP assay is run with intact chloroplasts in the dark and under equal intensities of red, green or blue light. Absorbance (initial 0.80) after 10 minutes is: dark 0.78, red 0.30, blue 0.28, green 0.70. Which interpretation is best?', null, md5('apbio-mcq-b2-sv-h-3.4-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Green light is absorbed most strongly by chlorophyll, because it produces the largest drop in absorbance.', false, 'Green gives the smallest drop in absorbance of the three colors, so it is the least effective, and the largest drop is with red and blue.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Green light drives no electron flow at all, because chlorophyll cannot absorb any green light.', false, 'The absorbance in green falls by 0.10 versus 0.02 in the dark, which shows some electron flow, so absorption is weak and not absent.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Red and blue light drive much more electron transport than green, because chlorophylls absorb red and blue strongly and green weakly; the small drop in green shows some absorption.', true, 'Correct: the drop is 0.50 (red), 0.52 (blue) and 0.10 (green) compared with 0.02 in the dark, so green is used but poorly.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The three colors drive equal electron flow, and the differences are due to the dye.', false, 'The three drops differ by a factor of about five, which is too large to attribute to the dye.' from version_ins;
-- apbio-mcq-b2-sv-h-3.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.4-a-v2', 'mcq', 'interpret DCPIP/leaf-disc/stroma experiments separating light-dependent steps (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Leaf discs from which air has been removed sink in solution. A student places discs in three conditions and records the time for the first disc to float, which happens when oxygen accumulates in the disc.
Condition | Result
Bright light, bicarbonate solution | floats at 8 minutes
Bright light, plain water | no discs float by 30 minutes
Darkness, bicarbonate solution | no discs float by 30 minutes
Which conclusion is best supported?', null, md5('apbio-mcq-b2-sv-h-3.4-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Bicarbonate supplies the energy that drives the light reactions.', false, 'Bicarbonate supplies carbon dioxide for the Calvin cycle, and light, not bicarbonate, supplies the energy.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Floating depends on oxygen accumulating from photosynthesis, which in these discs needs both light and bicarbonate as a CO₂ source.', true, 'Correct: floating happens only with both light and bicarbonate, so the oxygen buildup depends on photosynthesis with a CO₂ supply.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Discs in darkness make oxygen by respiration, but too slowly to make them float.', false, 'Respiration consumes oxygen and does not produce it, so the dark disc cannot gain oxygen by respiration.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Oxygen release depends only on light, because oxygen comes from splitting water, so bicarbonate only changes how buoyant the discs are.', false, 'The discs in plain water had the same light but did not float, so oxygen accumulation does depend on a CO₂ supply, because the Calvin cycle regenerates the NADP⁺ and ADP the light reactions need.' from version_ins;
-- apbio-mcq-b2-sv-h-3.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.4-a-v3', 'mcq', 'interpret DCPIP/leaf-disc/stroma experiments separating light-dependent steps (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Isolated chloroplast stroma (with the Calvin cycle enzymes but no thylakoids) is incubated in the dark with ¹⁴CO₂. The amount of radioactive carbon incorporated into sugar after 10 minutes is:
Additions | ¹⁴C in sugar
None | 1
ATP only | 2
NADPH only | 2
ATP and NADPH | 60
Which conclusion is best supported?', null, md5('apbio-mcq-b2-sv-h-3.4-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The carbon-fixing reactions do not need light directly, but they need both ATP and NADPH, which the light reactions normally supply.', true, 'Correct: only the combination of ATP and NADPH restores sugar synthesis in the dark, so both are required, and light acts indirectly through the light reactions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The carbon-fixing reactions need light directly, because sugar forms only when the stroma is illuminated.', false, 'The experiment was done entirely in the dark, and sugar formed when ATP and NADPH were added.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ATP alone is enough to drive sugar synthesis, since both additions raise the label slightly.', false, 'ATP alone raised the label from 1 to 2, which is negligible compared with the 60 seen with both.' from version_ins
union all select gen_random_uuid(), id, 'D', 'NADPH alone is enough to drive sugar synthesis because it is the reducing agent.', false, 'NADPH alone gave the same negligible increase, so it cannot drive synthesis without ATP.' from version_ins;
-- apbio-mcq-b2-h-3.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-3.4-b', 'mcq', 'predict shifts in Calvin cycle intermediates and light-reaction carriers under perturbation', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A culture of green algae is photosynthesizing steadily in bright light with a constant supply of CO₂. The light is switched off, and over the next 30 seconds the cells are sampled and the concentrations of the Calvin cycle intermediates 3-phosphoglycerate (3-PGA) and ribulose bisphosphate (RuBP) are measured. Which change is most likely, assuming CO₂ fixation by rubisco continues briefly?', null, md5('apbio-mcq-b2-h-3.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both fall, because the Calvin cycle needs light directly to absorb energy.', false, 'The Calvin cycle uses chemical energy carried by ATP and NADPH, not light directly, and the 3-PGA level would rise and not fall.' from version_ins
union all select gen_random_uuid(), id, 'B', '3-PGA rises and RuBP falls, because ATP and NADPH are no longer being made to reduce 3-PGA and regenerate RuBP.', true, 'Correct: rubisco keeps making 3-PGA, but without ATP and NADPH from the light reactions the reduction of 3-PGA and the regeneration of RuBP stop, so 3-PGA accumulates and RuBP is depleted.' from version_ins
union all select gen_random_uuid(), id, 'C', '3-PGA falls and RuBP rises, because carbon is no longer being fixed.', false, 'This is the pattern after removal of CO₂ in the light, and the stem says the CO₂ supply is constant.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither changes, because the Calvin cycle is independent of light.', false, 'The Calvin cycle is light independent only in that it does not absorb light, but it relies on the products of the light reactions, so its intermediates change.' from version_ins;
-- apbio-mcq-b2-sv-h-3.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.4-b-v1', 'mcq', 'predict shifts in Calvin cycle intermediates and light-reaction carriers under perturbation (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The same algae photosynthesize steadily in bright light. The CO₂ supply is suddenly removed while the light stays on. Over the next 30 seconds, which change is most likely?', null, md5('apbio-mcq-b2-sv-h-3.4-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'RuBP rises and 3-PGA falls, because 3-PGA is no longer made by fixing CO₂ but continues to be converted and RuBP continues to be regenerated.', true, 'Correct: without CO₂ rubisco cannot combine it with RuBP, so 3-PGA production stops and RuBP is no longer consumed, while the light supplies ATP and NADPH to keep processing the existing pool.' from version_ins
union all select gen_random_uuid(), id, 'B', '3-PGA rises and RuBP falls, because the light reactions stop without CO₂.', false, 'This pattern results from turning off the light, whereas the light here stays on and supplies ATP and NADPH.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both fall, because the Calvin cycle needs CO₂ for every step.', false, 'RuBP is regenerated using ATP and NADPH and is not consumed without CO₂, so it accumulates.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither changes, because the Calvin cycle uses stored carbohydrate and not CO₂.', false, 'The Calvin cycle fixes CO₂ from the environment in every turn, and without a supply the intermediates change.' from version_ins;
-- apbio-mcq-b2-sv-h-3.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.4-b-v2', 'mcq', 'predict shifts in Calvin cycle intermediates and light-reaction carriers under perturbation (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In bright light, a drug irreversibly inhibits rubisco in a suspension of chloroplasts, and nothing else is affected. Over the next minute, which change is most likely in the stroma?', null, md5('apbio-mcq-b2-sv-h-3.4-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ATP and NADPH fall, because the Calvin cycle supplies them to the light reactions.', false, 'The light reactions make ATP and NADPH, and the Calvin cycle uses them, so the levels rise when the cycle stops.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The light reactions speed up, because they no longer need to share energy with the Calvin cycle.', false, 'The light reactions need ADP and NADP⁺, which the Calvin cycle regenerates, so they cannot speed up when the cycle stalls.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ATP and NADPH accumulate while ADP and NADP⁺ fall, so the light reactions slow down.', true, 'Correct: with the Calvin cycle stalled, ATP and NADPH are not consumed, so ADP and NADP⁺ run short and the electron transport chain slows.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Oxygen production continues at the same rate, because the light reactions do not depend on the Calvin cycle.', false, 'The light reactions depend on the supply of NADP⁺ and ADP, so oxygen production eventually falls.' from version_ins;
-- apbio-mcq-b2-sv-h-3.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.4-b-v3', 'mcq', 'predict shifts in Calvin cycle intermediates and light-reaction carriers under perturbation (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A compound that makes the thylakoid membrane permeable to H⁺, so the proton gradient cannot build up, is added to illuminated chloroplasts. The compound does not directly block electron transport or the Calvin cycle enzymes. In the short term, which result is most likely?', null, md5('apbio-mcq-b2-sv-h-3.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Oxygen release continues, but ATP synthesis and sugar formation fall because ATP synthase has no proton gradient to use.', true, 'Correct: electron flow can continue and split water, but without a gradient ATP synthase cannot make ATP, and the Calvin cycle slows for lack of ATP.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Oxygen production stops, because oxygen evolution requires ATP.', false, 'Oxygen comes from the splitting of water at photosystem II and does not require ATP, so it continues.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sugar synthesis speeds up, because protons now reach the stroma more quickly.', false, 'Sugar synthesis needs ATP, and a dissipated gradient lowers ATP, so synthesis slows.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ATP synthesis increases, because H⁺ crossing the membrane more quickly drives ATP synthase faster.', false, 'ATP synthase is driven by the gradient, and the compound destroys the gradient so ATP synthesis falls.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-sv-h-3.3-b-v3','apbio-mcq-b2-h-3.4-a','apbio-mcq-b2-sv-h-3.4-a-v1','apbio-mcq-b2-sv-h-3.4-a-v2','apbio-mcq-b2-sv-h-3.4-a-v3','apbio-mcq-b2-h-3.4-b','apbio-mcq-b2-sv-h-3.4-b-v1','apbio-mcq-b2-sv-h-3.4-b-v2','apbio-mcq-b2-sv-h-3.4-b-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b2-sv-h-3.3-b-v3','apbio-mcq-b2-h-3.4-a','apbio-mcq-b2-sv-h-3.4-a-v1','apbio-mcq-b2-sv-h-3.4-a-v2','apbio-mcq-b2-sv-h-3.4-a-v3','apbio-mcq-b2-h-3.4-b','apbio-mcq-b2-sv-h-3.4-b-v1','apbio-mcq-b2-sv-h-3.4-b-v2','apbio-mcq-b2-sv-h-3.4-b-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
