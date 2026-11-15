begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-h-3.1-a','apbio-mcq-b2-sv-h-3.1-a-v1','apbio-mcq-b2-sv-h-3.1-a-v2','apbio-mcq-b2-sv-h-3.1-a-v3','apbio-mcq-b2-h-3.1-b','apbio-mcq-b2-sv-h-3.1-b-v1','apbio-mcq-b2-sv-h-3.1-b-v2','apbio-mcq-b2-sv-h-3.1-b-v3','apbio-mcq-b2-h-3.1-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apbio-mcq-b2-h-3.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-3.1-a', 'mcq', 'competitive vs noncompetitive inhibition from rate data', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An enzyme is assayed with and without a reversible inhibitor. Enzyme concentration, temperature and pH are the same in every tube. Initial rates (relative units per minute) are:
Substrate (mM) | No inhibitor | With inhibitor
2 | 33 | 14
4 | 50 | 25
10 | 71 | 45
40 | 91 | 77
200 | 98 | 94
Which conclusion is best supported by the data?', null, md5('apbio-mcq-b2-h-3.1-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The inhibitor is noncompetitive: it binds away from the active site and lowers the maximum rate at every substrate concentration.', false, 'A noncompetitive inhibitor lowers the maximum rate, so the gap would remain large at 200 mM, but here the rates nearly converge (94 versus 98).' from version_ins
union all select gen_random_uuid(), id, 'B', 'The inhibitor is competitive: it competes with the substrate for the active site, so a high substrate concentration nearly overcomes it.', true, 'Correct: the rate gap shrinks from 19 units at 2 mM to 4 units at 200 mM and both curves approach the same maximum, which is the signature of competition for the active site.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The inhibitor permanently denatures a fraction of the enzyme molecules, so fewer enzyme molecules are available at every substrate concentration.', false, 'Loss of active enzyme molecules would lower the maximum rate at saturating substrate too, and the rates would not converge.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The inhibitor binds to the substrate and removes it from solution, so the rates fall by the same amount at every substrate concentration.', false, 'The gap is not constant, since it falls from 19 to 4 units as substrate rises, which a fixed loss of substrate would not produce.' from version_ins;
-- apbio-mcq-b2-sv-h-3.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.1-a-v1', 'mcq', 'competitive vs noncompetitive inhibition from rate data (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A second inhibitor is tested on the same enzyme under identical conditions. Initial rates (relative units per minute) are:
Substrate (mM) | No inhibitor | With inhibitor
2 | 33 | 17
4 | 50 | 25
10 | 71 | 36
40 | 91 | 45
200 | 98 | 49
A student proposes raising the substrate from 40 mM to 200 mM to restore the uninhibited rate. Which statement best evaluates the proposal?', null, md5('apbio-mcq-b2-sv-h-3.1-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It will succeed, because every inhibitor loses its effect once substrate is added in large excess.', false, 'Only a competitive inhibitor is overcome by excess substrate, and this data shows a constant fractional reduction.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It will fail: the rate with inhibitor stays near half of the uninhibited rate at every substrate concentration, which fits an inhibitor that binds outside the active site and lowers the maximum rate.', true, 'Correct: the inhibited rate is about 50 percent of the uninhibited rate at every concentration (17/33, 25/50, 36/71, 45/91, 49/98), so substrate cannot overcome it, as expected for a noncompetitive inhibitor.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It will fail only because the enzyme is denatured at high substrate concentration, which is why the rate stops rising.', false, 'The uninhibited curve also levels off at high substrate because the enzyme is saturated, not denatured.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It will succeed, because the rates at 2 mM and 4 mM show the inhibitor is weaker at higher substrate.', false, 'The ratio of inhibited to uninhibited rate does not rise with substrate, so the inhibitor is not weaker at higher substrate.' from version_ins;
-- apbio-mcq-b2-sv-h-3.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.1-a-v2', 'mcq', 'competitive vs noncompetitive inhibition from rate data (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drug has a shape and charge distribution similar to an enzyme''s substrate and binds reversibly to the active site. In an assay containing 1 mM substrate and the drug, the rate is 30 percent of the uninhibited rate. A researcher raises the substrate concentration to 100 mM while keeping the drug concentration the same. Which prediction and explanation are best?', null, md5('apbio-mcq-b2-sv-h-3.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The rate rises toward the uninhibited rate, because substrate and drug compete for the same active sites and more substrate occupies more of them.', true, 'Correct: a reversible inhibitor that resembles the substrate and binds the active site is competitive, so its effect is reduced when substrate greatly outnumbers it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The rate stays at about 30 percent, because the drug lowers the enzyme''s maximum rate regardless of substrate.', false, 'Lowering the maximum rate regardless of substrate describes noncompetitive inhibition, whereas this drug competes for the active site.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The rate stays at about 30 percent, because the drug changes the shape of the active site by binding elsewhere on the enzyme.', false, 'Binding elsewhere describes an allosteric or noncompetitive inhibitor, but the stem says the drug binds the active site.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The rate rises toward the uninhibited rate, because extra substrate lowers the activation energy of the reaction.', false, 'Substrate concentration does not change the activation energy, since only the enzyme and its structure do that.' from version_ins;
-- apbio-mcq-b2-sv-h-3.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.1-a-v3', 'mcq', 'competitive vs noncompetitive inhibition from rate data (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Inhibitors X and Y each reduce the activity of the same enzyme. Initial rates (relative units per minute) at two substrate concentrations are:
Condition | 10 mM substrate | 100 mM substrate
No inhibitor | 60 | 94
Inhibitor X | 45 | 89
Inhibitor Y | 30 | 47
Which interpretation is best supported?', null, md5('apbio-mcq-b2-sv-h-3.1-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both are competitive, because both lower the rate at 10 mM substrate.', false, 'Every inhibitor lowers the rate at some concentration, so that observation cannot distinguish the types; the 100 mM data can.' from version_ins
union all select gen_random_uuid(), id, 'B', 'X is likely noncompetitive because it lowers the rate at 10 mM, while Y is likely competitive because it lowers the rate more.', false, 'The larger drop at low substrate does not identify a type, and the rate with Y does not recover, which is the noncompetitive pattern.' from version_ins
union all select gen_random_uuid(), id, 'C', 'X is likely competitive because 100 mM substrate nearly restores the rate, while Y is likely noncompetitive because the rate stays about half of normal.', true, 'Correct: with X the rate recovers from 75 percent to 95 percent of normal as substrate rises, while with Y it stays near 50 percent, so X behaves competitively and Y noncompetitively.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both are noncompetitive, because neither reaches the uninhibited rate at 100 mM.', false, 'X comes within about 5 percent of the uninhibited rate at 100 mM, which is consistent with competition and not with a fixed loss of capacity.' from version_ins;
-- apbio-mcq-b2-h-3.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-3.1-b', 'mcq', 'choose the control isolating enzyme activity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student grinds potato tissue and filters the liquid. When she adds 1 mL of the extract to hydrogen peroxide, bubbles form quickly. She claims that an enzyme in the extract causes the bubbling. Which additional treatment would best test whether the bubbling depends on the enzyme''s native, folded structure rather than on some other component of the extract?', null, md5('apbio-mcq-b2-h-3.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Add 1 mL of the same extract that was first heated in boiling water and then cooled, to the same hydrogen peroxide solution.', true, 'Correct: boiled extract contains the same chemical components but has denatured proteins, so if bubbling stops the difference must be due to the folded protein.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Add 1 mL of extract to water in place of hydrogen peroxide.', false, 'This shows whether the extract alone releases gas, but it does not separate enzyme activity from other extract components when peroxide is present.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Add 2 mL of the untreated extract to the same hydrogen peroxide solution.', false, 'Doubling the amount is a dose comparison that changes a variable and cannot show that the activity depends on protein structure.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Add 1 mL of the untreated extract to a hydrogen peroxide solution at a lower concentration.', false, 'Changing the peroxide concentration tests a substrate effect and does not distinguish an enzyme from other components of the extract.' from version_ins;
-- apbio-mcq-b2-sv-h-3.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.1-b-v1', 'mcq', 'choose the control isolating enzyme activity (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student adds pancreatic extract to milk containing an indicator that turns from pink to colorless as fatty acids form. The color fades within minutes, and she claims lipase in the extract is responsible. Which control best shows that the change depends on an active, properly folded enzyme?', null, md5('apbio-mcq-b2-sv-h-3.1-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Use the same amount of extract with the milk adjusted to a different pH.', false, 'Changing the pH introduces a second variable and tests a pH effect, not the dependence on enzyme structure.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Use ice-cold milk with the same amount of untreated extract.', false, 'Lowering the temperature slows an enzyme without destroying it, so a slow color change would not show that the protein structure is responsible.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Use the same amount of extract that was heated to denature its proteins and then cooled to the same temperature.', true, 'Correct: the heated extract keeps every other component but loses folded protein, so persistence of the pink color would show the change depends on active enzyme.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Use the same amount of extract with a larger volume of milk.', false, 'Changing the milk volume changes the substrate amount and says nothing about whether the active enzyme is required.' from version_ins;
-- apbio-mcq-b2-sv-h-3.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.1-b-v2', 'mcq', 'choose the control isolating enzyme activity (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An inhibitor is dissolved in the solvent DMSO. When 20 microliters of the inhibitor solution is added to an assay, the rate of the reaction falls from 50 to 20 units per minute. Which control best shows that the decrease is caused by the inhibitor and not by the solvent?', null, md5('apbio-mcq-b2-sv-h-3.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An assay with the inhibitor solution but with no substrate.', false, 'Without substrate there is no reaction to measure, so this assay cannot show what the solvent does to the rate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'An assay with twice the amount of inhibitor solution.', false, 'Doubling the dose tests whether the effect increases with dose, but it still contains the solvent, so it cannot separate solvent from inhibitor.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An assay with 20 microliters of DMSO that contains no inhibitor.', true, 'Correct: the solvent-only assay matches everything except the inhibitor, so if the rate stays near 50 the inhibitor and not the solvent caused the drop.' from version_ins
union all select gen_random_uuid(), id, 'D', 'An assay with no enzyme but with the inhibitor solution.', false, 'Without the enzyme the reaction rate says nothing about how the solvent affects the enzyme.' from version_ins;
-- apbio-mcq-b2-sv-h-3.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.1-b-v3', 'mcq', 'choose the control isolating enzyme activity (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student uses the iodine test, which turns blue-black with starch, to detect amylase activity in saliva. Before testing saliva she wants to confirm that her assay can detect starch breakdown at all. Which tube is the best positive control?', null, md5('apbio-mcq-b2-sv-h-3.1-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Starch solution with boiled saliva, then iodine.', false, 'Boiled saliva is a negative control because its enzyme is denatured and no starch breakdown is expected.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Starch solution with water instead of saliva, then iodine.', false, 'Starch with water is a negative control that shows what no breakdown looks like.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Water with saliva, with no starch, then iodine.', false, 'There is no starch in this tube, so no breakdown is possible and the tube does not test the assay''s ability to detect it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Starch solution with a commercial amylase solution known to be active, then iodine.', true, 'Correct: a positive control uses a treatment known to produce the effect; active amylase with starch should lose the blue-black color if the assay works.' from version_ins;
-- apbio-mcq-b2-h-3.1-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-3.1-c', 'mcq', 'predict allosteric feedback inhibition in a pathway', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a bacterial biosynthetic pathway, enzyme E1 converts substrate A to B, E2 converts B to C, and E3 converts C to the end product D. D binds reversibly to a site on E1 that is separate from the active site. A researcher adds excess D to a cell extract that contains all three enzymes and plenty of A. Which prediction and explanation are best?', null, md5('apbio-mcq-b2-h-3.1-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The rate of conversion of A to B increases, because D is a product of the pathway and more D pulls the pathway forward.', false, 'Products of the pathway inhibit the early enzyme rather than stimulating it, which is how the cell avoids overproduction.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The rate of conversion of A to B stays the same, because D can act only on E3, the enzyme that makes it.', false, 'The stem says D binds E1, so D acts on the first step and not only on E3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The rate of conversion of A to B falls, because D binds a site other than the active site and changes the shape of E1, which reduces its activity.', true, 'Correct: feedback inhibition by an end product that binds an allosteric site shuts down the first step, which prevents the cell from wasting resources on excess D.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The rate of conversion of A to B falls, because D competes with A for the active site, so raising A would fully restore the rate.', false, 'D binds a site separate from the active site, so it does not compete with A, and added A would not fully restore the rate.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-h-3.1-a','apbio-mcq-b2-sv-h-3.1-a-v1','apbio-mcq-b2-sv-h-3.1-a-v2','apbio-mcq-b2-sv-h-3.1-a-v3','apbio-mcq-b2-h-3.1-b','apbio-mcq-b2-sv-h-3.1-b-v1','apbio-mcq-b2-sv-h-3.1-b-v2','apbio-mcq-b2-sv-h-3.1-b-v3','apbio-mcq-b2-h-3.1-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b2-h-3.1-a','apbio-mcq-b2-sv-h-3.1-a-v1','apbio-mcq-b2-sv-h-3.1-a-v2','apbio-mcq-b2-sv-h-3.1-a-v3','apbio-mcq-b2-h-3.1-b','apbio-mcq-b2-sv-h-3.1-b-v1','apbio-mcq-b2-sv-h-3.1-b-v2','apbio-mcq-b2-sv-h-3.1-b-v3','apbio-mcq-b2-h-3.1-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
