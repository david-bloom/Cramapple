begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-frq-u1v-005-v1','apcalcab-frq-u1v-005-v2','apcalcab-frq-u1v-005-v3'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- FRQ variant 005-v1 of 005 | medium | Table Estimate and Factoring Confirmation of a Sensor Ratio
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-005-v1', 'frq', 'Table Estimate and Factoring Confirmation of a Sensor Ratio', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Use the table to estimate lim(x->2) h(x). Explain how the table supports your estimate.

(b) Use algebra to find the exact value of lim(x->2) h(x). Show your work.

(c) The function h is extended by defining h(2) = 1.5. Is the extended function continuous at x = 2? If not, classify the discontinuity and justify your answer.', 'A technician records the response ratio h of a sensor at setting x and models it by h(x) = (x^3 - 4x)/(x^2 + x - 6) for x != 2 and x != -3. Selected values of h(x) are given in the table.

x = 1.9: h(x) = 1.5122
x = 1.99: h(x) = 1.5912
x = 1.999: h(x) = 1.5991
x = 2.001: h(x) = 1.6009
x = 2.01: h(x) = 1.6088
x = 2.1: h(x) = 1.6882', md5('apcalcab-frq-u1v-005-v1'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Estimates the limit near 1.6 and supports it with values from both sides of 2.', 1, 'Response gives an estimate of about 1.6 and notes that the values from both the left and the right of x = 2 approach that number.', 'Cite values from both sides of 2, not just one side, when supporting the estimate.', '["1.6","8/5"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Factors the numerator as x(x - 2)(x + 2) and the denominator, and cancels the common factor x - 2.', 1, 'Response factors the numerator as x(x - 2)(x + 2) and the denominator as (x - 2)(x + 3), then cancels the common factor x - 2 (x is a factor of the numerator only, not a common factor) to obtain x(x + 2)/(x + 3).', 'Show the complete factoring of x^3 - 4x and the cancellation of x - 2.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Evaluates to the exact limit 8/5.', 1, 'Response evaluates x(x + 2)/(x + 3) at x = 2 to obtain 2(4)/5 = 8/5.', 'State the exact value 8/5.', '["8/5","1.6"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Concludes the extended function is not continuous because 1.5 does not equal 8/5, and calls the discontinuity removable.', 1, 'Response states that the limit 8/5 exists but does not equal h(2) = 1.5 (which is 3/2), so h is not continuous at x = 2, and that the discontinuity is removable.', 'Compare the limit 8/5 with the value 1.5, state that they differ, and name the discontinuity removable.', '["removable"]'::jsonb from version_ins
;
-- FRQ variant 005-v2 of 005 | medium | Table Estimate and Complex-Fraction Confirmation of a Lens Ratio
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-005-v2', 'frq', 'Table Estimate and Complex-Fraction Confirmation of a Lens Ratio', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Use the table to estimate lim(x->4) h(x). Explain how the table supports your estimate.

(b) Use algebra to find the exact value of lim(x->4) h(x). Show your work.

(c) The function h is extended by defining h(4) = -0.05. Is the extended function continuous at x = 4? If not, classify the discontinuity and justify your answer.', 'A lens designer models the ratio h of two focal readings at setting x by h(x) = (1/x - 1/4)/(x - 4) for x != 4 and x != 0. Selected values of h(x) are given in the table.

x = 3.9: h(x) = -0.0641
x = 3.99: h(x) = -0.0627
x = 3.999: h(x) = -0.0625
x = 4.001: h(x) = -0.0625
x = 4.01: h(x) = -0.0623
x = 4.1: h(x) = -0.0610', md5('apcalcab-frq-u1v-005-v2'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Estimates the limit near -0.0625 and supports it with values from both sides of 4.', 1, 'Response gives an estimate of about -0.0625 (or -1/16) and notes that the values from both the left and the right of x = 4 approach that number.', 'Cite values from both sides of 4, not just one side, when supporting the estimate.', '["-0.0625","-0.063","-0.06","-1/16"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Combines 1/x - 1/4 over a common denominator and cancels x - 4.', 1, 'Response rewrites 1/x - 1/4 as (4 - x)/(4x), so h(x) = (4 - x)/(4x(x - 4)) = -(x - 4)/(4x(x - 4)), and cancels x - 4 to obtain -1/(4x).', 'Show the common-denominator step, the factor 4 - x = -(x - 4), and the cancellation.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Evaluates to the exact limit -1/16.', 1, 'Response evaluates -1/(4x) at x = 4 to obtain -1/16.', 'State the exact value -1/16.', '["-1/16","-0.0625"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Concludes the extended function is not continuous because -0.05 does not equal -1/16, and calls the discontinuity removable.', 1, 'Response states that the limit -1/16 exists but does not equal h(4) = -0.05 (which is -1/20), so h is not continuous at x = 4, and that the discontinuity is removable.', 'Compare the limit -1/16 with the value -0.05, state that they differ, and name the discontinuity removable.', '["removable"]'::jsonb from version_ins
;
-- FRQ variant 005-v3 of 005 | medium | Table Estimate and Conjugate Confirmation of a Reaction Rate
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-005-v3', 'frq', 'Table Estimate and Conjugate Confirmation of a Reaction Rate', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Use the table to estimate lim(x->6) h(x). Explain how the table supports your estimate.

(b) Use algebra to find the exact value of lim(x->6) h(x). Show your work.

(c) The function h is extended by defining h(6) = 0.4. Is the extended function continuous at x = 6? If not, classify the discontinuity and justify your answer.', 'A chemist models the rate h of a reaction at concentration x by h(x) = (sqrt(3x - 2) - 4)/(x - 6) for x != 6. Selected values of h(x) are given in the table.

x = 5.9: h(x) = 0.3768
x = 5.99: h(x) = 0.3752
x = 5.999: h(x) = 0.3750
x = 6.001: h(x) = 0.3750
x = 6.01: h(x) = 0.3748
x = 6.1: h(x) = 0.3733', md5('apcalcab-frq-u1v-005-v3'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Estimates the limit near 0.375 and supports it with values from both sides of 6.', 1, 'Response gives an estimate of about 0.375 (or 3/8) and notes that the values from both the left and the right of x = 6 approach that number.', 'Cite values from both sides of 6, not just one side, when supporting the estimate.', '["0.375","0.38","3/8"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Multiplies by the conjugate sqrt(3x - 2) + 4 and simplifies.', 1, 'Response multiplies numerator and denominator by sqrt(3x - 2) + 4 and simplifies the numerator to (3x - 2) - 16 = 3x - 18 = 3(x - 6), then cancels x - 6.', 'Show the multiplication by the conjugate, the factoring 3x - 18 = 3(x - 6), and the cancellation of x - 6.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Evaluates to the exact limit 3/8.', 1, 'Response evaluates 3/(sqrt(3x - 2) + 4) at x = 6 to obtain 3/(4 + 4) = 3/8.', 'State the exact value 3/8.', '["3/8","0.375"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Concludes the extended function is not continuous because 0.4 does not equal 3/8, and calls the discontinuity removable.', 1, 'Response states that the limit 3/8 exists but does not equal h(6) = 0.4 (which is 2/5), so h is not continuous at x = 6, and that the discontinuity is removable.', 'Compare the limit 3/8 with the value 0.4, state that they differ, and name the discontinuity removable.', '["removable"]'::jsonb from version_ins
;

commit;
