begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-sv-h-4.3-a-v2','apbio-mcq-b4-sv-h-4.3-a-v3','apbio-mcq-b4-h-4.3-b','apbio-mcq-b4-sv-h-4.3-b-v1','apbio-mcq-b4-sv-h-4.3-b-v2','apbio-mcq-b4-sv-h-4.3-b-v3','apbio-mcq-b4-h-4.4-a','apbio-mcq-b4-sv-h-4.4-a-v1','apbio-mcq-b4-sv-h-4.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apbio-mcq-b4-sv-h-4.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.3-a-v2', 'mcq', 'predict effect of a constitutively active component and of blocking different steps (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a pathway, ligand L activates receptor R. R activates kinase K1, and K1''s only target is kinase K2. K2 phosphorylates transcription factor TF, which turns on gene G. A cell line has no functional K2 enzyme (the K2 protein is made but has no catalytic activity). Cells are treated with L. Which result is predicted?', null, md5('apbio-mcq-b4-sv-h-4.3-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R is not activated, because the cell detects the missing K2 and blocks the receptor.', false, 'The receptor is activated by the ligand upstream of K2, and the stem gives no mechanism that blocks it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'K1 is not activated either, because the pathway shuts off all steps when one step fails.', false, 'K1 acts upstream of K2 and is activated normally, since a defect at one step does not stop the earlier steps.' from version_ins
union all select gen_random_uuid(), id, 'C', 'R and K1 are activated as usual, but TF is not phosphorylated and gene G stays off.', true, 'Correct: ligand binding activates R, which activates K1 (both upstream of the defect), but K2 cannot pass the signal to TF, and K1''s only target is K2, so gene G remains off.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Gene G turns on at the normal level, because K1 can phosphorylate TF directly.', false, 'The stem states that K1 acts only on K2, so no other route to TF exists.' from version_ins;
-- apbio-mcq-b4-sv-h-4.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.3-a-v3', 'mcq', 'predict effect of a constitutively active component and of blocking different steps (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A receptor tyrosine kinase is normally activated when ligand binding makes two receptor molecules pair and phosphorylate each other, which then switches on a downstream kinase pathway. A cell line has a mutation that makes receptor molecules pair with each other even when no ligand is bound. Which result is predicted?', null, md5('apbio-mcq-b4-sv-h-4.3-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The pathway is on without ligand, an inhibitor that blocks ligand binding has no effect, and an inhibitor of the receptor''s kinase domain turns it off.', true, 'Correct: the mutation bypasses the ligand step, so receptor phosphorylation and the downstream pathway run without ligand; only blocking the kinase activity of the receptor, or a downstream step, can stop it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The downstream pathway stays off until ligand is added, because the receptors need ligand for any activity.', false, 'The mutation makes receptors pair without ligand, so the receptors have activity without it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The pathway is on only briefly, because unpaired receptors quickly return to the ligand-bound form.', false, 'The stem gives no mechanism for turning off the paired receptors, and pairing is held by the mutation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The pathway is on, and an inhibitor that blocks ligand binding turns it off.', false, 'The receptors are already paired and active, so blocking the binding of ligand cannot reverse that.' from version_ins;
-- apbio-mcq-b4-h-4.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.3-b', 'mcq', 'work out the order of proteins in a pathway from rescue experiments', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three proteins, X, Y and Z, act in a single linear pathway between a receptor and a gene response. Researchers made cell lines that each lack one protein, then tested whether adding a constitutively active form of another protein (CA) turns on the response when no ligand is present.
Cell line | Response to ligand | CA-X, no ligand | CA-Y, no ligand | CA-Z, no ligand
Lacks X | none | not tested | response | no response
Lacks Y | none | no response | not tested | no response
Lacks Z | none | response | response | not tested
Which order of action, from the receptor to the response, fits the data?', null, md5('apbio-mcq-b4-h-4.3-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'X, then Y, then Z.', false, 'If X came first, CA-Z and CA-Y would rescue the line lacking X, and CA-Z did not rescue it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Z, then Y, then X.', false, 'If Y came before X, CA-X would rescue the line lacking Y, and it did not.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Y, then X, then Z.', false, 'If Y came first, CA-X would rescue a line lacking Y, and the table shows it did not.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Z, then X, then Y.', true, 'Correct: an active protein can rescue only a line that lacks something upstream of it. Lines lacking Z are rescued by both CA-X and CA-Y, so Z is first. A line lacking X is rescued by CA-Y but not CA-Z, so Y is after X. The line lacking Y is rescued by neither, so Y is last.' from version_ins;
-- apbio-mcq-b4-sv-h-4.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.3-b-v1', 'mcq', 'work out the order of proteins in a pathway from rescue experiments (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pathway in a cell has three kinases, KA, KB and KC. After the ligand is added, the researchers add a drug that blocks one kinase at a time and measure which kinases become phosphorylated (active).
Drug target | KA phosphorylated | KB phosphorylated | KC phosphorylated
KA blocked | no | no | no
KB blocked | yes | no | no
KC blocked | yes | yes | no
Which order of action fits the data?', null, md5('apbio-mcq-b4-sv-h-4.3-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'KC, then KB, then KA.', false, 'If KC acted first, blocking KC would stop KB and KA, but KA and KB were phosphorylated with KC blocked.' from version_ins
union all select gen_random_uuid(), id, 'B', 'KB, then KA, then KC.', false, 'If KB acted before KA, blocking KB would stop KA, and KA was still phosphorylated.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The three kinases act in parallel, each one switched on directly by the receptor.', false, 'In a parallel pathway, blocking one kinase would leave the others active, and blocking KA stopped all three.' from version_ins
union all select gen_random_uuid(), id, 'D', 'KA, then KB, then KC.', true, 'Correct: blocking a kinase prevents activation of the kinases downstream of it but not those upstream; blocking KA stops all three, blocking KB stops KB and KC, and blocking KC stops only KC.' from version_ins;
-- apbio-mcq-b4-sv-h-4.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.3-b-v2', 'mcq', 'work out the order of proteins in a pathway from rescue experiments (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four proteins, F, G, H and J, act in a linear pathway from a receptor to a gene response. Each cell line lacks one protein. In each line, no ligand is given and a constitutively active form of one of the other proteins is added.
Cell line | Active forms that turn on the response
Lacks F | H, J, G
Lacks G | none
Lacks H | J, G
Lacks J | G
Which order of action, from the receptor to the response, fits the data?', null, md5('apbio-mcq-b4-sv-h-4.3-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'J, then H, then F, then G.', false, 'If J came first, active J would not rescue the line lacking H, but it did.' from version_ins
union all select gen_random_uuid(), id, 'B', 'G, then J, then H, then F.', false, 'If G came first, active G would not rescue lines lacking J and H and F, but it rescued all three.' from version_ins
union all select gen_random_uuid(), id, 'C', 'F, then H, then J, then G.', true, 'Correct: the line lacking G is not rescued, so G is last. The line lacking F is rescued by all three others, so F is first. The line lacking H is rescued by J and G but not F, so H comes after F and before J. The line lacking J is rescued only by G, so J comes after H and before G.' from version_ins
union all select gen_random_uuid(), id, 'D', 'F, then J, then H, then G.', false, 'If J came before H, active J would not rescue the line lacking H, and the table shows it did.' from version_ins;
-- apbio-mcq-b4-sv-h-4.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.3-b-v3', 'mcq', 'work out the order of proteins in a pathway from rescue experiments (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'After a hormone is added to cells, three proteins, T, S and U, become phosphorylated: T at 10 seconds, S at 30 seconds, and U at 60 seconds. When an inhibitor of T is added before the hormone, neither S nor U is phosphorylated. When an inhibitor of U is added before the hormone, T and S are still phosphorylated. Which order of action fits the data?', null, md5('apbio-mcq-b4-sv-h-4.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'U, then S, then T.', false, 'If U acted first, blocking U would prevent T and S from being phosphorylated, and they were.' from version_ins
union all select gen_random_uuid(), id, 'B', 'S, then T, then U.', false, 'If S acted before T, blocking T would not stop S, and it did.' from version_ins
union all select gen_random_uuid(), id, 'C', 'T, then S, then U.', true, 'Correct: blocking T prevents S and U, so T is first; blocking U leaves T and S active, so U is not upstream of them; the timing agrees with T, S, U.' from version_ins
union all select gen_random_uuid(), id, 'D', 'T and U act separately, and S acts after both.', false, 'Blocking T stopped both S and U, so U depends on T and does not act separately.' from version_ins;
-- apbio-mcq-b4-h-4.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.4-a', 'mcq', 'predict hormone levels when a negative feedback loop is interrupted at one step', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In healthy people, the pituitary hormone ACTH stimulates the adrenal cortex to release cortisol, and cortisol acts on the hypothalamus and pituitary to reduce ACTH release. A patient takes a drug that blocks an enzyme the adrenal cortex needs to make cortisol. The adrenal cortex and pituitary otherwise work normally. Which pattern of blood hormone levels is expected after two weeks?', null, md5('apbio-mcq-b4-h-4.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cortisol low and ACTH high, because less cortisol means less inhibition of ACTH release.', true, 'Correct: the drug lowers cortisol; with less negative feedback on the pituitary, ACTH release rises and stays high because the adrenal cortex cannot make cortisol to turn it off.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cortisol low and ACTH low, because low cortisol reduces the stimulus for ACTH release.', false, 'This treats the loop as positive feedback, but cortisol inhibits ACTH release, so a drop in cortisol raises ACTH.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cortisol low and ACTH normal, because cortisol does not regulate ACTH release.', false, 'The stem states that cortisol acts on the hypothalamus and pituitary to reduce ACTH, so ACTH release is regulated by cortisol.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cortisol normal and ACTH normal, because negative feedback always returns hormone levels to normal whatever the drug.', false, 'Feedback can correct a variable only if the components work, and the drug blocks cortisol synthesis so the loop cannot restore cortisol.' from version_ins;
-- apbio-mcq-b4-sv-h-4.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.4-a-v1', 'mcq', 'predict hormone levels when a negative feedback loop is interrupted at one step (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A patient takes a high dose of prednisone, a drug that acts like cortisol, for several months. Normally, ACTH from the pituitary stimulates the adrenal cortex to make cortisol, and cortisol reduces ACTH release. Which change in the patient''s own ACTH release and adrenal cortex is expected?', null, md5('apbio-mcq-b4-sv-h-4.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ACTH release rises and the adrenal cortex enlarges, because the body needs to make more cortisol.', false, 'The drug acts like cortisol, so it adds inhibition and ACTH falls and does not rise.' from version_ins
union all select gen_random_uuid(), id, 'B', 'ACTH release is unchanged and the adrenal cortex is unchanged, because a drug cannot affect the loop.', false, 'Prednisone acts as cortisol would and engages the same feedback on the pituitary, so ACTH release changes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ACTH release falls and the adrenal cortex enlarges, because less ACTH makes the adrenal cortex grow.', false, 'The adrenal cortex depends on ACTH for stimulation, so less ACTH leads to shrinkage and not growth.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ACTH release falls and the adrenal cortex shrinks, because the drug acts like cortisol and the adrenal cortex gets less stimulation.', true, 'Correct: prednisone supplies the negative feedback signal, so ACTH release falls; with little ACTH stimulation the adrenal cortex makes less cortisol and shrinks.' from version_ins;
-- apbio-mcq-b4-sv-h-4.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.4-a-v2', 'mcq', 'predict hormone levels when a negative feedback loop is interrupted at one step (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Parathyroid cells release PTH when blood Ca²⁺ is low. PTH raises blood Ca²⁺. A calcium-sensing receptor on parathyroid cells detects high blood Ca²⁺ and reduces PTH release. A patient has a mutation that makes the receptor insensitive to Ca²⁺. Which pattern is expected?', null, md5('apbio-mcq-b4-sv-h-4.4-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'PTH low and blood Ca²⁺ low, because the cells cannot sense calcium.', false, 'Without the sensor, the signal that reduces PTH is lost, so PTH release continues and does not fall.' from version_ins
union all select gen_random_uuid(), id, 'B', 'PTH high and blood Ca²⁺ high, because the cells do not detect high Ca²⁺ and keep releasing PTH.', true, 'Correct: with the sensor unable to detect high Ca²⁺, the inhibition of PTH release is lost, so PTH stays high and keeps raising blood Ca²⁺.' from version_ins
union all select gen_random_uuid(), id, 'C', 'PTH normal and blood Ca²⁺ normal, because other organs make up for the missing sensor.', false, 'The stem describes no compensating mechanism, and the lost feedback leaves PTH unchecked.' from version_ins
union all select gen_random_uuid(), id, 'D', 'PTH high and blood Ca²⁺ low, because the cells release PTH but it cannot act.', false, 'PTH acts normally in this patient and raises blood Ca²⁺, so the calcium level rises and does not stay low.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-sv-h-4.3-a-v2','apbio-mcq-b4-sv-h-4.3-a-v3','apbio-mcq-b4-h-4.3-b','apbio-mcq-b4-sv-h-4.3-b-v1','apbio-mcq-b4-sv-h-4.3-b-v2','apbio-mcq-b4-sv-h-4.3-b-v3','apbio-mcq-b4-h-4.4-a','apbio-mcq-b4-sv-h-4.4-a-v1','apbio-mcq-b4-sv-h-4.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b4-sv-h-4.3-a-v2','apbio-mcq-b4-sv-h-4.3-a-v3','apbio-mcq-b4-h-4.3-b','apbio-mcq-b4-sv-h-4.3-b-v1','apbio-mcq-b4-sv-h-4.3-b-v2','apbio-mcq-b4-sv-h-4.3-b-v3','apbio-mcq-b4-h-4.4-a','apbio-mcq-b4-sv-h-4.4-a-v1','apbio-mcq-b4-sv-h-4.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
