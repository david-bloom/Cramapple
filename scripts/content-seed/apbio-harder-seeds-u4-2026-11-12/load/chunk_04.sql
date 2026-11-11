begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-sv-h-4.4-a-v3','apbio-mcq-b4-h-4.4-b','apbio-mcq-b4-sv-h-4.4-b-v1','apbio-mcq-b4-sv-h-4.4-b-v2','apbio-mcq-b4-sv-h-4.4-b-v3','apbio-mcq-b4-h-4.5-a','apbio-mcq-b4-sv-h-4.5-a-v1','apbio-mcq-b4-sv-h-4.5-a-v2','apbio-mcq-b4-sv-h-4.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apbio-mcq-b4-sv-h-4.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.4-a-v3', 'mcq', 'predict hormone levels when a negative feedback loop is interrupted at one step (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a bacterium, enzyme 1 begins a pathway that makes end product Z. Z normally binds an allosteric site on enzyme 1 and inhibits it. A mutant enzyme 1 has a normal active site but can no longer bind Z. Compared with the normal bacterium, which result is expected?', null, md5('apbio-mcq-b4-sv-h-4.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Z levels are lower in the mutant, because the mutant enzyme has lost activity.', false, 'The active site is normal, so the enzyme is not less active, and only the inhibition by Z is gone.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Z levels are the same, because the cell breaks down any extra Z.', false, 'The stem gives no mechanism that removes extra Z, and without feedback the pathway keeps running.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Z levels are lower in the mutant, because the loss of feedback inhibition acts as positive feedback.', false, 'Losing negative feedback does not turn it into positive feedback, and the result is overproduction and not underproduction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Z levels are higher in the mutant, because enzyme 1 stays active when Z accumulates.', true, 'Correct: the active site works but the allosteric inhibition is lost, so enzyme 1 keeps making product however much Z is present, and Z accumulates.' from version_ins;
-- apbio-mcq-b4-h-4.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.4-b', 'mcq', 'evaluate a student''s claim about negative versus positive feedback', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'During labor, the baby''s head presses on the cervix, stretch receptors signal the hypothalamus, and the posterior pituitary releases oxytocin. Oxytocin makes the uterine muscle contract more strongly, which presses the head harder on the cervix. After delivery the cervix is no longer stretched and oxytocin release falls. A student claims: "This is negative feedback, because the process stops by itself at the end." Which evaluation is best?', null, md5('apbio-mcq-b4-h-4.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is wrong: the contractions increase the stimulus that raises oxytocin, which is positive feedback, and the loop ends only because delivery removes the stimulus.', true, 'Correct: the output (stronger contraction) increases the input (cervical stretch), so the loop amplifies the change; negative feedback would reduce it. The loop ends because an outside event, delivery, removes the stimulus.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is correct, because any process that ends on its own is negative feedback.', false, 'Ending does not define negative feedback, since the type depends on whether the output opposes or amplifies the change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is wrong, because hormones can take part only in positive feedback loops.', false, 'Many hormone loops, such as ACTH and cortisol, are negative feedback, so hormones are not limited to positive loops.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is correct, because negative feedback means the response is helpful to the organism.', false, 'Whether feedback is helpful does not define its type, and positive feedback can be helpful, as here.' from version_ins;
-- apbio-mcq-b4-sv-h-4.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.4-b-v1', 'mcq', 'evaluate a student''s claim about negative versus positive feedback (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a neuron, depolarization opens voltage-gated Na⁺ channels, Na⁺ entry depolarizes the membrane further, and that opens more Na⁺ channels. Within about a millisecond, the channels inactivate and K⁺ channels open, which returns the membrane toward its resting value. A student claims: "Cells must keep conditions steady, so a positive feedback loop cannot occur inside a cell." Which evaluation is best?', null, md5('apbio-mcq-b4-sv-h-4.4-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, because positive feedback always damages cells.', false, 'Positive feedback is a normal part of the nerve impulse and is not damaging here.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is wrong: the opening of Na⁺ channels is positive feedback that rapidly amplifies the depolarization, and it is brief and is ended by channel inactivation.', true, 'Correct: depolarization opening more channels that cause more depolarization is amplification (positive feedback); other processes, inactivation and K⁺ channels, end it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is correct, because the Na⁺ channel step must be negative feedback, since the membrane returns to rest.', false, 'The return to rest is caused by other events, channel inactivation and K⁺ channels, while the Na⁺ channel step itself amplifies.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is wrong, because Na⁺ channel opening is negative feedback that keeps the membrane near its set point.', false, 'Negative feedback reduces a change, and Na⁺ channel opening increases the depolarization.' from version_ins;
-- apbio-mcq-b4-sv-h-4.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.4-b-v2', 'mcq', 'evaluate a student''s claim about negative versus positive feedback (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ripening apple releases ethylene gas. Ethylene triggers cells in the apple, and in nearby apples, to make more ethylene, so the ethylene concentration rises rapidly. A student claims: "A feedback loop must keep a variable steady, so this cannot be a feedback loop at all." Which evaluation is best?', null, md5('apbio-mcq-b4-sv-h-4.4-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, because ethylene production keeps changing and so there is no feedback.', false, 'Feedback means the output influences its own production, and ethylene production is controlled by ethylene, so feedback is present.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is correct, because only negative feedback loops count as feedback.', false, 'Positive feedback loops are feedback too, and they amplify a change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is wrong, because this is negative feedback with a set point at a very high ethylene level.', false, 'No set point is being defended, and the ethylene level keeps rising instead of returning to a value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is wrong: this is a positive feedback loop, in which the output increases the stimulus and drives the variable further from its starting value.', true, 'Correct: ethylene stimulates more ethylene, so the output amplifies the change; keeping a variable near a set point describes negative feedback only.' from version_ins;
-- apbio-mcq-b4-sv-h-4.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.4-b-v3', 'mcq', 'evaluate a student''s claim about negative versus positive feedback (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'When body temperature rises above 37°C, the sweat rate increases. As the sweat evaporates, body temperature falls back toward 37°C and the sweat rate decreases. A student claims: "This is positive feedback, because sweat rate went up when the temperature went up." Which evaluation is best?', null, md5('apbio-mcq-b4-sv-h-4.4-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, because the response and the stimulus changed in the same direction.', false, 'The direction in which the stimulus and the response change does not decide the type, and the effect of the response on the stimulus does.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is correct, because sweating is an amplified response.', false, 'A large response is not what defines positive feedback, since the response here reduces the temperature rise.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is wrong: sweating opposes the rise in temperature and returns it toward the set point, which is negative feedback.', true, 'Correct: the type of feedback depends on the effect of the response on the original change; here the response counteracts the change, which is negative feedback.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is wrong, because feedback loops involve hormones and sweating is controlled by nerves.', false, 'Feedback loops are not limited to hormones, and nervous and other control systems use feedback too.' from version_ins;
-- apbio-mcq-b4-h-4.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.5-a', 'mcq', 'estimate time in a phase from counts of cells in a sample', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher examines 200 cells from a growing root tip under the microscope. The cell cycle in this tissue lasts 24 hours. Counts: interphase 160, prophase 16, metaphase 8, anaphase 6, telophase 10. About how long does a cell spend in metaphase?', null, md5('apbio-mcq-b4-h-4.5-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 0.04 hours, because 8 of 200 cells are in metaphase.', false, '0.04 is the fraction of cells and it has to be multiplied by the 24-hour cycle to give hours.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 1.9 hours, because 8 of every 100 cells are in metaphase.', false, '8 of 200 cells is 4 of every 100 cells and not 8 of every 100.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 4.8 hours, because 8 of the 40 dividing cells are in metaphase.', false, 'The share of the 40 dividing cells (20%) gives the fraction of mitosis, and the denominator must be all 200 cells and the cycle length.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 1.0 hour, because 8/200 of the cells are in metaphase and the cycle is 24 hours long.', true, 'Correct: the fraction of cells in a phase is the fraction of the cycle spent in it: 8/200 = 0.04, and 0.04 × 24 h = 0.96 h, about 1 hour.' from version_ins;
-- apbio-mcq-b4-sv-h-4.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.5-a-v1', 'mcq', 'estimate time in a phase from counts of cells in a sample (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An onion root tip sample of 300 cells is counted. The cell cycle lasts 20 hours. Counts: interphase 240, prophase 30, metaphase 12, anaphase 6, telophase 12. About how long does a cell spend in mitosis (prophase through telophase)?', null, md5('apbio-mcq-b4-sv-h-4.5-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 0.2 hours, because 60 of 300 cells are in mitosis.', false, '60/300 = 0.2 is a fraction and must be multiplied by the 20-hour cycle to give hours.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 5 hours, because 60 cells in mitosis divided by 240 cells in interphase is 25% of 20 hours.', false, 'The denominator must be all 300 cells, and using only the 240 interphase cells gives the wrong fraction.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 4 hours, because 60 of the 300 cells are in mitosis, which is 20% of the 20-hour cycle.', true, 'Correct: mitotic cells are 30 + 12 + 6 + 12 = 60 of 300, which is 20%, and 0.20 × 20 h = 4 h.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 16 hours, because most of the cells are in the stage with no visible chromosomes.', false, '16 hours is the time in interphase, and the question asks about mitosis.' from version_ins;
-- apbio-mcq-b4-sv-h-4.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.5-a-v2', 'mcq', 'estimate time in a phase from counts of cells in a sample (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a culture of dividing cells, 5% of the cells are in metaphase at any moment, and metaphase lasts 30 minutes. What is the length of the whole cell cycle?', null, md5('apbio-mcq-b4-sv-h-4.5-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.5 hours, because 0.5 hours is multiplied by 5.', false, 'Multiplying 0.5 by 5 does not match the proportion; the phase time is the fraction times the cycle, so the cycle is the phase time divided by the fraction.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.025 hours, because 0.5 hours is multiplied by 0.05.', false, 'Multiplying by the fraction goes the wrong way, because it gives a time shorter than metaphase itself.' from version_ins
union all select gen_random_uuid(), id, 'C', '9.5 hours, because the 0.5 hours of metaphase is subtracted from the 10-hour cycle.', false, '9.5 hours is the cycle without metaphase and does not equal the full cycle time.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 hours, because 0.5 hours is 5% of the cycle length.', true, 'Correct: if metaphase is 5% of the cycle and lasts 0.5 h, the cycle is 0.5 / 0.05 = 10 h.' from version_ins;
-- apbio-mcq-b4-sv-h-4.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.5-a-v3', 'mcq', 'estimate time in a phase from counts of cells in a sample (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher counts 200 cells from a culture before and after 6 hours of treatment with a drug.
Phase | Before drug | After 6 hours of drug
Interphase | 190 | 70
Prophase | 4 | 8
Metaphase | 3 | 118
Anaphase | 1 | 1
Telophase | 2 | 3
Which interpretation is best supported?', null, md5('apbio-mcq-b4-sv-h-4.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The drug speeds up mitosis, because far more cells are in mitosis after treatment.', false, 'If mitosis were faster, fewer cells would be caught in mitosis at a moment, and metaphase would not hold most of them.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The drug blocks the move from metaphase to anaphase, so cells that enter mitosis pile up in metaphase.', true, 'Correct: metaphase cells rise from 3 to 118 while anaphase and telophase stay near 1 to 3, so cells reach metaphase and cannot go on.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The drug stops cells from entering mitosis, because the number of interphase cells fell.', false, 'Interphase cells fell because cells entered mitosis and stayed in it, so entry is not blocked.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The drug blocks cytokinesis, because cells accumulate at the end of mitosis.', false, 'Telophase cells did not accumulate (3 cells), so the block comes before telophase.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-sv-h-4.4-a-v3','apbio-mcq-b4-h-4.4-b','apbio-mcq-b4-sv-h-4.4-b-v1','apbio-mcq-b4-sv-h-4.4-b-v2','apbio-mcq-b4-sv-h-4.4-b-v3','apbio-mcq-b4-h-4.5-a','apbio-mcq-b4-sv-h-4.5-a-v1','apbio-mcq-b4-sv-h-4.5-a-v2','apbio-mcq-b4-sv-h-4.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b4-sv-h-4.4-a-v3','apbio-mcq-b4-h-4.4-b','apbio-mcq-b4-sv-h-4.4-b-v1','apbio-mcq-b4-sv-h-4.4-b-v2','apbio-mcq-b4-sv-h-4.4-b-v3','apbio-mcq-b4-h-4.5-a','apbio-mcq-b4-sv-h-4.5-a-v1','apbio-mcq-b4-sv-h-4.5-a-v2','apbio-mcq-b4-sv-h-4.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
