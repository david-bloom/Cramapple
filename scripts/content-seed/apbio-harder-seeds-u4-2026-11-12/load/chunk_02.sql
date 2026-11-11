begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-sv-h-4.2-a-v1','apbio-mcq-b4-sv-h-4.2-a-v2','apbio-mcq-b4-sv-h-4.2-a-v3','apbio-mcq-b4-h-4.2-b','apbio-mcq-b4-sv-h-4.2-b-v1','apbio-mcq-b4-sv-h-4.2-b-v2','apbio-mcq-b4-sv-h-4.2-b-v3','apbio-mcq-b4-h-4.3-a','apbio-mcq-b4-sv-h-4.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apbio-mcq-b4-sv-h-4.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.2-a-v1', 'mcq', 'use an experiment to decide receptor location and whether the response needs gene expression (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Hormone S is a small nonpolar molecule. After S is added to cultured cells, the amount of a certain enzyme rises only after 3 hours. The transcription inhibitor actinomycin D prevents the rise. When S is attached to large beads that cannot cross the plasma membrane, there is no response. Which conclusion is best supported?', null, md5('apbio-mcq-b4-sv-h-4.2-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'S binds a membrane receptor and activates a kinase cascade that acts within seconds.', false, 'A membrane receptor cascade would respond within seconds to the beads, and the response here is delayed and needs transcription.' from version_ins
union all select gen_random_uuid(), id, 'B', 'S crosses the membrane and binds an intracellular receptor, and the complex changes gene expression, which explains the delay.', true, 'Correct: beads that cannot enter give no response, so S must get inside; actinomycin D blocks the response, so it needs transcription; new mRNA and protein take hours.' from version_ins
union all select gen_random_uuid(), id, 'C', 'S acts at the cell surface, because the beads show that S can reach the cell from outside.', false, 'The beads that stay outside the cell give no response, so a surface receptor is not enough for S.' from version_ins
union all select gen_random_uuid(), id, 'D', 'S must first be broken down in the cell to an active form, and transcription is not involved in the delay.', false, 'Actinomycin D blocks the response, so transcription is involved, and the stem gives no evidence of a conversion step.' from version_ins;
-- apbio-mcq-b4-sv-h-4.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.2-a-v2', 'mcq', 'use an experiment to decide receptor location and whether the response needs gene expression (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Neurotransmitter N is applied to a muscle fiber and depolarizes the membrane within 5 milliseconds. Replacing the Na⁺ outside the cell with a large ion that cannot pass through channels abolishes the depolarization. Kinase inhibitors and protein-synthesis inhibitors do not change the response. Which conclusion is best supported?', null, md5('apbio-mcq-b4-sv-h-4.2-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'N crosses the membrane and binds an intracellular receptor that changes gene expression.', false, 'Gene expression takes much longer than 5 ms and protein-synthesis inhibitors had no effect.' from version_ins
union all select gen_random_uuid(), id, 'B', 'N binds a receptor that is itself an ion channel, so binding opens the channel and ions enter, with no second messenger or new gene expression needed.', true, 'Correct: a 5 ms response that needs extracellular Na⁺ but not kinases or new proteins fits a ligand-gated ion channel opened directly by N.' from version_ins
union all select gen_random_uuid(), id, 'C', 'N binds a receptor tyrosine kinase that phosphorylates transcription factors within milliseconds.', false, 'Kinase inhibitors did not change the response, so a kinase-based pathway is not needed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'N causes IP₃ to release stored Ca²⁺ from the ER, and the Ca²⁺ then depolarizes the membrane.', false, 'Stored Ca²⁺ release would not depend on the Na⁺ outside the cell, and replacing the Na⁺ abolished the response.' from version_ins;
-- apbio-mcq-b4-sv-h-4.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.2-a-v3', 'mcq', 'use an experiment to decide receptor location and whether the response needs gene expression (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a cell line, ligand L normally raises cAMP and turns on gene G. When drug Z is present, L no longer raises cAMP or turns on gene G, and binding of labeled L drops by 95%. In drug-treated cells, a membrane-permeable cAMP analog turns on gene G strongly. Which stage of signaling does Z most likely block?', null, md5('apbio-mcq-b4-sv-h-4.2-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Transduction, because Z prevents the cell from making cAMP after L binds.', false, 'Z reduces the binding of L, so reception fails first, and the cell can still respond to cAMP, so making cAMP is not shown to be the blocked step.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The response, because Z stops gene G from being turned on even when cAMP is high.', false, 'Gene G turns on strongly when cAMP analog is added, so the response step is intact.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Reception, because Z stops L from binding its receptor, while transduction and the response are intact.', true, 'Correct: Z cuts labeled L binding by 95% (reception), and cAMP analog restores gene G expression (transduction after cAMP and the response work).' from version_ins
union all select gen_random_uuid(), id, 'D', 'All three stages, because Z prevented L from turning on gene G.', false, 'The cAMP analog restores the response, so the later stages work and only reception is shown to be blocked.' from version_ins;
-- apbio-mcq-b4-h-4.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.2-b', 'mcq', 'calculate how amplification through a cascade scales output when one step changes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a cell, each hormone-bound receptor activates 20 G proteins. Each active G protein activates one adenylyl cyclase, and each activated adenylyl cyclase makes 50 cAMP molecules before it is inactivated. A mutation lowers the number of G proteins activated per hormone-bound receptor from 20 to 5; all other steps are unchanged. If 300 receptors bind hormone, which statement describes the cAMP produced?', null, md5('apbio-mcq-b4-h-4.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '75,000 cAMP molecules, one fourth of the normal amount, because a smaller yield at the first step is carried through the later multiplying steps.', true, 'Correct: normal output is 300 × 20 × 50 = 300,000 cAMP; with the mutation it is 300 × 5 × 50 = 75,000, which is one fourth.' from version_ins
union all select gen_random_uuid(), id, 'B', '150,000 cAMP molecules, half of the normal amount, because the mutation removes half of the G proteins.', false, 'Going from 20 to 5 G proteins is a fourfold decrease and not a twofold decrease, so the output falls to one fourth.' from version_ins
union all select gen_random_uuid(), id, 'C', '1,500 cAMP molecules, because only the 5 G proteins per receptor make cAMP.', false, '300 × 5 = 1,500 counts activated G proteins and leaves out the 50 cAMP made by each adenylyl cyclase.' from version_ins
union all select gen_random_uuid(), id, 'D', '300,000 cAMP molecules, unchanged, because the later steps of the cascade make up for the loss.', false, 'The later steps only multiply what they receive and cannot restore a lower number of activated G proteins.' from version_ins;
-- apbio-mcq-b4-sv-h-4.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.2-b-v1', 'mcq', 'calculate how amplification through a cascade scales output when one step changes (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a kinase cascade, each active kinase K1 activates 10 molecules of K2, each active K2 activates 10 molecules of K3, and each active K3 phosphorylates 10 molecules of a transcription factor. A drug changes K2 so that each active K2 activates only 5 K3 molecules. If 40 K1 molecules are active, which statement describes the number of phosphorylated transcription factor molecules?', null, md5('apbio-mcq-b4-sv-h-4.2-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40,000, unchanged, because the later step adds 10 for each K3 and so corrects the loss.', false, 'Each step only multiplies the number it receives, so fewer K3 means fewer phosphorylated factors.' from version_ins
union all select gen_random_uuid(), id, 'B', '10,000, one fourth of normal, because the change at the second step affects two steps.', false, 'Only one step changed and it was halved from 10 to 5, so the output halves and does not fall to a quarter.' from version_ins
union all select gen_random_uuid(), id, 'C', '200, because only the 5 K3 per K2 matter for the final amount.', false, '40 × 5 = 200 ignores the multiplication by the other steps of the cascade.' from version_ins
union all select gen_random_uuid(), id, 'D', '20,000, half of the normal 40,000, because halving the output of one step halves the final output.', true, 'Correct: normal is 40 × 10 × 10 × 10 = 40,000; with the drug it is 40 × 10 × 5 × 10 = 20,000, which is half.' from version_ins;
-- apbio-mcq-b4-sv-h-4.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.2-b-v2', 'mcq', 'calculate how amplification through a cascade scales output when one step changes (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two hypothetical pathways are compared. In pathway X, each of 100 ligand-bound receptors directly activates one transcription factor. In pathway Y, each of 100 ligand-bound receptors activates 5 kinase molecules, and each kinase activates 5 transcription factors. Which statement is correct?', null, md5('apbio-mcq-b4-sv-h-4.2-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Pathway Y activates 500 transcription factors, because each receptor activates 5 molecules.', false, '100 × 5 = 500 counts only the first step and leaves out the 5 transcription factors activated by each kinase.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Pathway Y activates 1,000 transcription factors, because the 5 and 5 are added at each receptor.', false, 'The amplification at the steps is multiplied (5 × 5 = 25 per receptor), not added (5 + 5 = 10).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Pathway Y activates 2,500 transcription factors, which is 25 times as many as pathway X, because each step multiplies the signal.', true, 'Correct: pathway X gives 100; pathway Y gives 100 × 5 × 5 = 2,500, which is 25 times as large.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Pathway X and Y activate the same number, because the number of receptors sets the number of active transcription factors.', false, 'The number of receptors is the same, but extra steps with several targets per enzyme give a larger output in Y.' from version_ins;
-- apbio-mcq-b4-sv-h-4.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.2-b-v3', 'mcq', 'calculate how amplification through a cascade scales output when one step changes (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher measures how much of a cell''s maximum response is produced when different fractions of its receptors are occupied by ligand.
Receptors occupied | Response (percent of maximum)
5% | 40%
20% | 85%
100% | 100%
Which interpretation is best supported by the data?', null, md5('apbio-mcq-b4-sv-h-4.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The response is directly proportional to the fraction of receptors occupied, so 5% occupancy gives 5% of the maximum.', false, 'The data show 5% occupancy giving 40% of the maximum, which is not proportional.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Occupancy above 20% harms the cell, so the response levels off.', false, 'The response levels off because the downstream machinery nears its maximum, and the data give no sign of damage to the cell.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Occupying a small fraction of the receptors gives a large share of the maximum response, as expected when downstream steps amplify the signal.', true, 'Correct: 5% occupancy yields 40% of the maximum, a much larger fraction than the occupancy, which is the signature of amplification after reception.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The ligand must enter the cell to produce a response, so the limit on the response is how fast the ligand is transported.', false, 'The experiment concerns receptor occupancy and the stem gives no evidence that the ligand enters the cell or that transport limits the response.' from version_ins;
-- apbio-mcq-b4-h-4.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.3-a', 'mcq', 'predict effect of a constitutively active component and of blocking different steps', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a signaling pathway, growth factor binding activates receptor R, which activates Ras, then Raf, then MEK, then ERK. Active ERK turns on genes for cell proliferation. A cell line has a mutation that keeps Raf active even without input from Ras. The cells are grown with no growth factor. Which result is predicted?', null, md5('apbio-mcq-b4-h-4.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The proliferation genes are on, and a MEK inhibitor turns them off, but an antibody that blocks receptor R does not.', true, 'Correct: Raf is downstream of the receptor and Ras, so its constant activity keeps MEK and ERK active without ligand; blocking the receptor acts upstream of the mutation and has no effect, but blocking MEK downstream of it cuts the signal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The proliferation genes stay off until growth factor is added, because Raf cannot act without Ras.', false, 'The mutation makes Raf active without Ras, so the downstream steps proceed without growth factor.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The proliferation genes are on, and an antibody that blocks receptor R turns them off.', false, 'The receptor acts upstream of Raf, and blocking it cannot switch off a Raf that is active without any input.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The proliferation genes are on, and a MEK inhibitor does not turn them off, because active Raf can bypass MEK.', false, 'In this pathway Raf activates ERK only through MEK, so blocking MEK stops the signal.' from version_ins;
-- apbio-mcq-b4-sv-h-4.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.3-a-v1', 'mcq', 'predict effect of a constitutively active component and of blocking different steps (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In intestinal cells, a hormone binds a receptor that activates Gs, which activates adenylyl cyclase to make cAMP. cAMP activates PKA, and PKA triggers chloride secretion. Cholera toxin modifies Gs so that it cannot break down its bound GTP and stays active. Cells are treated with the toxin and no hormone. Which result is predicted?', null, md5('apbio-mcq-b4-sv-h-4.3-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'cAMP stays high, and a receptor antagonist lowers it, because the receptor must keep activating Gs.', false, 'The receptor acts upstream of Gs, and Gs is already locked in its active state, so blocking the receptor does not lower cAMP.' from version_ins
union all select gen_random_uuid(), id, 'B', 'cAMP stays low until the hormone is added, because Gs cannot work without the receptor.', false, 'Toxin-modified Gs stays active even with no hormone, so cAMP does not wait for the hormone.' from version_ins
union all select gen_random_uuid(), id, 'C', 'cAMP stays high, but a PKA inhibitor has no effect on secretion, because cAMP acts independently of PKA.', false, 'In this pathway cAMP signals through PKA, so a PKA inhibitor blocks the response to high cAMP.' from version_ins
union all select gen_random_uuid(), id, 'D', 'cAMP stays high and chloride secretion continues, a receptor antagonist does not reduce it, and a PKA inhibitor does.', true, 'Correct: a Gs that cannot turn itself off keeps adenylyl cyclase active without receptor input; PKA lies downstream of cAMP, so only a PKA inhibitor can stop the secretion.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-sv-h-4.2-a-v1','apbio-mcq-b4-sv-h-4.2-a-v2','apbio-mcq-b4-sv-h-4.2-a-v3','apbio-mcq-b4-h-4.2-b','apbio-mcq-b4-sv-h-4.2-b-v1','apbio-mcq-b4-sv-h-4.2-b-v2','apbio-mcq-b4-sv-h-4.2-b-v3','apbio-mcq-b4-h-4.3-a','apbio-mcq-b4-sv-h-4.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b4-sv-h-4.2-a-v1','apbio-mcq-b4-sv-h-4.2-a-v2','apbio-mcq-b4-sv-h-4.2-a-v3','apbio-mcq-b4-h-4.2-b','apbio-mcq-b4-sv-h-4.2-b-v1','apbio-mcq-b4-sv-h-4.2-b-v2','apbio-mcq-b4-sv-h-4.2-b-v3','apbio-mcq-b4-h-4.3-a','apbio-mcq-b4-sv-h-4.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
