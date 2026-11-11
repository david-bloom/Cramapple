begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-sv-h-3.1-c-v1','apbio-mcq-b2-sv-h-3.1-c-v2','apbio-mcq-b2-sv-h-3.1-c-v3','apbio-mcq-b2-h-3.2-a','apbio-mcq-b2-sv-h-3.2-a-v1','apbio-mcq-b2-sv-h-3.2-a-v2','apbio-mcq-b2-sv-h-3.2-a-v3','apbio-mcq-b2-h-3.2-b','apbio-mcq-b2-sv-h-3.2-b-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apbio-mcq-b2-sv-h-3.1-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.1-c-v1', 'mcq', 'predict allosteric feedback inhibition in a pathway (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the same pathway (E1 makes B from A, E2 makes C from B, E3 makes D from C, and D inhibits E1 allosterically), a cell is growing with a moderate level of D that partly inhibits E1. A drug then completely and irreversibly blocks E2. Which change is most likely over the next few minutes?', null, md5('apbio-mcq-b2-sv-h-3.1-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A accumulates and B falls, because the drug blocks E1.', false, 'The drug acts on E2, and E1 becomes more active as D falls, so A would be consumed and not accumulate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C accumulates, because C is made by E2 even when E2 is blocked.', false, 'C is produced only by E2, so with E2 blocked its supply stops and it does not accumulate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All intermediates fall, because blocking one enzyme shuts down every reaction in the pathway at once.', false, 'The product of the unblocked first enzyme, B, builds up, so not every intermediate falls.' from version_ins
union all select gen_random_uuid(), id, 'D', 'D falls, so inhibition of E1 is relieved and B accumulates because E2 can no longer remove it.', true, 'Correct: blocking E2 stops the production of C and D, so the inhibitor D falls and E1 speeds up, while B is made faster and not removed.' from version_ins;
-- apbio-mcq-b2-sv-h-3.1-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.1-c-v2', 'mcq', 'predict allosteric feedback inhibition in a pathway (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A mutant bacterium has an E1 whose active site is unchanged but which can no longer bind the end product D at its regulatory site. Compared with the normal strain growing under the same conditions, which prediction is best?', null, md5('apbio-mcq-b2-sv-h-3.1-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mutant makes less D, because the mutation weakened the active site of E1.', false, 'The stem states the active site is unchanged, and the lost feature is the regulatory binding site.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mutant makes the same amount of D, because regulatory sites never affect enzyme activity.', false, 'Binding at a regulatory site normally lowers the enzyme''s activity, so losing it changes the amount of D made.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mutant stops making D, because without regulation the pathway cannot run.', false, 'The pathway still runs because the active site works, and the loss of feedback lets it run unchecked.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The mutant accumulates much more D, because E1 stays active even when D is abundant.', true, 'Correct: with the regulatory site unable to bind D, feedback is lost, so E1 continues to work at a high rate and D builds up.' from version_ins;
-- apbio-mcq-b2-sv-h-3.1-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.1-c-v3', 'mcq', 'predict allosteric feedback inhibition in a pathway (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An enzyme that catalyzes the first step of a pathway has an activity of 100 units in the absence of the end product P and 20 units when P is present. After the sample is dialyzed to remove P, the activity returns to 95 units. Which conclusion is best supported?', null, md5('apbio-mcq-b2-sv-h-3.1-c-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P permanently denatures the enzyme, which is why activity falls.', false, 'Permanent denaturation would prevent the activity from returning when P is removed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P is used up as a substrate by the enzyme, which is why activity falls.', false, 'If P were consumed as a substrate, activity would rise and not fall when P is present.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P covalently modifies the enzyme and the dialysis removes the modification.', false, 'Dialysis removes small free molecules and cannot reverse covalent changes, so the recovery points to reversible binding.' from version_ins
union all select gen_random_uuid(), id, 'D', 'P binds the enzyme reversibly and alters its activity without permanently damaging the enzyme.', true, 'Correct: activity recovered to 95 percent once P was removed, which means that P binds reversibly and does not destroy the enzyme.' from version_ins;
-- apbio-mcq-b2-h-3.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-3.2-a', 'mcq', 'interpret rate vs temperature/pH data for enzymes with different optima', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher measures the initial rate of a similar reaction catalyzed by an enzyme from a human cell and an enzyme from a hot-spring bacterium. Substrate concentration and pH are identical in all tests.
Temperature (°C) | Human enzyme rate | Hot-spring enzyme rate
20 | 6 | 1
37 | 20 | 3
60 | 2 | 12
80 | 0 | 20
95 | 0 | 4
Which statement is best supported by the data?', null, md5('apbio-mcq-b2-h-3.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Each rate rises with temperature up to the enzyme''s optimum and then falls as heat disrupts the active site, and the hot-spring enzyme''s optimum is much higher than the human enzyme''s.', true, 'Correct: the human enzyme peaks near 37°C and the hot-spring enzyme near 80°C; below the optimum low rates reflect low kinetic energy, above it they reflect loss of active-site shape.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The hot-spring enzyme is denatured at 20°C and 37°C, which is why its rates there are low.', false, 'Cool temperatures slow molecular motion and collisions but do not denature a protein, so the low rate at 20°C does not indicate denaturation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The human enzyme''s rate falls above 37°C because the substrate is used up at higher temperatures.', false, 'The stem holds the substrate concentration the same, and the decline at high temperature comes from loss of the active-site shape.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The hot-spring enzyme has a higher rate at every temperature tested because it comes from an extremophile.', false, 'The human enzyme has higher rates at 20°C and 37°C (6 and 20 versus 1 and 3), so the claim of a higher rate at every temperature is false.' from version_ins;
-- apbio-mcq-b2-sv-h-3.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.2-a-v1', 'mcq', 'interpret rate vs temperature/pH data for enzymes with different optima (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The activities of pepsin (found in the stomach) and trypsin (found in the small intestine) are measured at several pH values with temperature and substrate constant.
pH | Pepsin rate | Trypsin rate
2 | 10 | 0
5 | 2 | 3
8 | 0 | 10
11 | 0 | 1
Which explanation best accounts for these results?', null, md5('apbio-mcq-b2-sv-h-3.2-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Pepsin cannot function at pH 8 because there are no hydrogen ions available to act as its substrate.', false, 'Hydrogen ions are not the substrate of these enzymes, and pepsin loses activity at high pH because of altered structure.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The two enzymes have the same optimum, and the differences between them are measurement error.', false, 'The peaks are far apart (pH 2 versus pH 8) and the pattern is clear, so the difference reflects different structures and not error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Trypsin is inactive at pH 2 because the acid hydrolyzes its peptide bonds and permanently cuts the polypeptide.', false, 'A brief exposure to pH 2 changes side-chain charge and shape, but it does not break peptide bonds, so the explanation by hydrolysis is incorrect.' from version_ins
union all select gen_random_uuid(), id, 'D', 'pH changes the ionization of amino acid side chains, which alters the interactions that maintain the active site, so each enzyme works best near the pH of its own environment.', true, 'Correct: pepsin peaks at pH 2 and trypsin at pH 8, matching the stomach and intestine; pH affects R-group charge and therefore the shape and binding of the active site.' from version_ins;
-- apbio-mcq-b2-sv-h-3.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.2-a-v2', 'mcq', 'interpret rate vs temperature/pH data for enzymes with different optima (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The initial rate of an enzyme at pH 7 and several temperatures is measured:
Temperature (°C) | Rate (relative units)
10 | 4
20 | 8
30 | 15
40 | 3
Which prediction for 25°C and 50°C is best supported?', null, md5('apbio-mcq-b2-sv-h-3.2-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At 25°C the rate is between 3 and 8, and at 50°C it is above 15.', false, 'The rate at 25°C must fall between the values at 20°C and 30°C, and it cannot be below 8, while the high rate at 50°C ignores the collapse seen at 40°C.' from version_ins
union all select gen_random_uuid(), id, 'B', 'At 25°C the rate is above 15, and at 50°C it is between 8 and 15.', false, 'The rate at 25°C cannot exceed the 30°C value of 15 when the trend is rising, and 50°C would not recover to a mid-level rate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At 25°C the rate is between 8 and 15, and at 50°C it is below 3 because even more of the enzyme is denatured.', true, 'Correct: the rate rises from 20°C to 30°C, so 25°C lies between 8 and 15; the rate already collapses at 40°C from heat damage, so more damage at 50°C gives an even lower rate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At 25°C the rate is between 8 and 15, and at 50°C it stays near 15 because kinetic energy keeps rising.', false, 'Increasing kinetic energy does not help once the active site is distorted, as the fall at 40°C shows.' from version_ins;
-- apbio-mcq-b2-sv-h-3.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.2-a-v3', 'mcq', 'interpret rate vs temperature/pH data for enzymes with different optima (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An enzyme is assayed at two temperatures and two substrate concentrations. Enzyme amount and pH are identical.
Temperature | 1 mM substrate | 50 mM substrate
25°C | 10 | 40
55°C | 1 | 3
A student proposes to rescue the activity at 55°C by adding more substrate. Which evaluation is best?', null, md5('apbio-mcq-b2-sv-h-3.2-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It will not help much: at 55°C the maximum rate is lowered because much of the enzyme has lost its active-site shape, and more substrate cannot restore the lost enzyme.', true, 'Correct: even at 50 mM substrate the rate at 55°C is only 3 compared with 40 at 25°C, so the limit is the amount of functional enzyme and not the substrate supply.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It will fully restore activity, because substrate concentration alone limits every enzyme.', false, 'Raising substrate helps only if substrate is limiting, and the rate at 55°C stays low even at 50 mM, which shows the enzyme is the limit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It will help because higher substrate concentrations make the active site refold.', false, 'Substrate does not cause a denatured protein to refold, and the data show no recovery.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It will not help, because substrate cannot bind a heated enzyme at all.', false, 'The rate rises from 1 to 3 with more substrate, so some functional enzyme still binds substrate, and the issue is that most of it is lost.' from version_ins;
-- apbio-mcq-b2-h-3.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-3.2-b', 'mcq', 'identify and fix a design flaw in an enzyme environment experiment', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student measures catalase activity in potato at 5, 20, 35 and 60°C by placing a potato disc in hydrogen peroxide and counting oxygen bubbles for one minute. Because she ran short, she used 3 percent hydrogen peroxide at 5°C and 20°C but 5 percent at 35°C and 60°C. All other conditions were identical. Which change would most improve the validity of her conclusion about temperature?', null, md5('apbio-mcq-b2-h-3.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Use a different potato at each temperature so that differences between potatoes average out.', false, 'Using a different potato at each temperature adds a second variable and cannot be averaged out with one trial per temperature.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Use the same hydrogen peroxide concentration in every tube so that temperature is the only variable that differs.', true, 'Correct: the substrate concentration differs between tubes, so a rate difference between 20°C and 35°C could come from the concentration change and not from temperature.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Increase the peroxide concentration further as temperature rises to compensate for the faster collisions.', false, 'Adjusting concentration with temperature creates an even larger confounded difference between tubes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Use a different buffer in each tube so that pH rises with the temperature.', false, 'Changing the pH across the tubes adds another variable and makes the effect of temperature harder to isolate.' from version_ins;
-- apbio-mcq-b2-sv-h-3.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-3.2-b-v1', 'mcq', 'identify and fix a design flaw in an enzyme environment experiment (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student measures the product formed after 30 minutes by an enzyme at five temperatures, starting with 100 micromoles of substrate in every tube.
Temperature | Product at 30 min (micromoles)
5°C | 20
20°C | 100
35°C | 100
50°C | 100
70°C | 40
She concludes that the enzyme works equally well from 20 to 50°C. Which change would best improve the experiment?', null, md5('apbio-mcq-b2-sv-h-3.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Run all tubes for 60 minutes so the lower temperatures can catch up.', false, 'A longer run makes the end-point problem worse, because even more tubes would be at the same completed endpoint.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Remove the 70°C tube because it does not fit the trend.', false, 'Removing data that does not fit is poor practice, and the 70°C tube carries real information about heat damage.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Measure product at several early time points and compare initial rates, before the substrate is used up.', true, 'Correct: the three tubes all converted every micromole of substrate, so the end point hides rate differences; initial rates would reveal which temperature is fastest.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Double the starting substrate in every tube so that the reaction lasts longer in each tube.', false, 'The problem is that a single late measurement hides the rates, and doubling the substrate still leaves one end-point reading that does not reveal which temperature is fastest.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-sv-h-3.1-c-v1','apbio-mcq-b2-sv-h-3.1-c-v2','apbio-mcq-b2-sv-h-3.1-c-v3','apbio-mcq-b2-h-3.2-a','apbio-mcq-b2-sv-h-3.2-a-v1','apbio-mcq-b2-sv-h-3.2-a-v2','apbio-mcq-b2-sv-h-3.2-a-v3','apbio-mcq-b2-h-3.2-b','apbio-mcq-b2-sv-h-3.2-b-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b2-sv-h-3.1-c-v1','apbio-mcq-b2-sv-h-3.1-c-v2','apbio-mcq-b2-sv-h-3.1-c-v3','apbio-mcq-b2-h-3.2-a','apbio-mcq-b2-sv-h-3.2-a-v1','apbio-mcq-b2-sv-h-3.2-a-v2','apbio-mcq-b2-sv-h-3.2-a-v3','apbio-mcq-b2-h-3.2-b','apbio-mcq-b2-sv-h-3.2-b-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
