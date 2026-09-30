begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-frq-u1n-005','apcalcab-mcq-u1v-001-v1','apcalcab-mcq-u1v-001-v2','apcalcab-mcq-u1v-001-v3','apcalcab-mcq-u1v-002-v1','apcalcab-mcq-u1v-002-v2','apcalcab-mcq-u1v-002-v3','apcalcab-mcq-u1v-003-v1','apcalcab-mcq-u1v-003-v2','apcalcab-mcq-u1v-003-v3'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- FRQ 005 | topic 1.9 | medium | Table Estimate and Algebraic Confirmation of a Limit
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1n-005', 'frq', 'Table Estimate and Algebraic Confirmation of a Limit', 'draft', 'short', 'targeted_drill', 'translation_between_representations'
  from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Use the table to estimate lim(x->5) h(x). Explain how the table supports your estimate.

(b) Use algebra to find the exact value of lim(x->5) h(x). Show your work.

(c) The function h is extended by defining h(5) = 0.2. Is the extended function continuous at x = 5? If not, classify the discontinuity and justify your answer.', 'Let h be the function defined by h(x) = (sqrt(x + 4) - 3)/(x - 5) for x != 5. Selected values of h(x) are given in the table.

x = 4.9: h(x) = 0.16713
x = 4.99: h(x) = 0.16671
x = 4.999: h(x) = 0.16667
x = 5.001: h(x) = 0.16666
x = 5.01: h(x) = 0.16662
x = 5.1: h(x) = 0.16621', md5('apcalcab-frq-u1n-005'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Estimates the limit near 0.1667 and supports it with values from both sides of 5.', 1, 'Response gives an estimate of about 0.167 (or 1/6) and notes that the values from both the left and the right of x = 5 approach that number.', 'Cite values from both sides of 5, not just one side, when supporting the estimate.', '["0.167","0.1667","1/6"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Multiplies by the conjugate sqrt(x + 4) + 3 and simplifies.', 1, 'Response multiplies numerator and denominator by sqrt(x + 4) + 3 and simplifies the numerator to (x + 4) - 9 = x - 5, then cancels x - 5.', 'Show the multiplication by the conjugate and the cancellation of x - 5.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Evaluates to the exact limit 1/6.', 1, 'Response evaluates 1/(sqrt(x + 4) + 3) at x = 5 to obtain 1/(3 + 3) = 1/6.', 'State the exact value 1/6.', '["1/6"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Concludes the extended function is not continuous because 0.2 does not equal 1/6, and calls the discontinuity removable.', 1, 'Response states that the limit 1/6 exists but does not equal h(5) = 0.2 (which is 1/5), so h is not continuous at x = 5, and that the discontinuity is removable.', 'Compare the limit 1/6 with the value 0.2, state that they differ, and name the discontinuity removable.', '["removable"]'::jsonb from version_ins
;

-- MCQ variant 001-v1 of 001 | easy | Cyclist Speed From Average Speeds
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-001-v1', 'mcq', 'Cyclist Speed From Average Speeds', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cyclist''s position is s(t) meters at time t seconds. The average velocity of the cyclist over the interval [5, 5 + h] is 12 - 3h + h^2 meters per second. What is the cyclist''s instantaneous velocity at t = 5?', md5('apcalcab-mcq-u1v-001-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12 - 3h + h^2 meters per second', false, 'This is the average velocity over an interval of length h, so it still depends on h. The instantaneous velocity is the limit of that expression as h approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 meters per second', false, 'Letting h approach 0 shrinks the interval but does not make the velocity 0. The expression 12 - 3h + h^2 approaches 12.' from version_ins
union all select gen_random_uuid(), id, 'C', '12 meters per second', true, 'The instantaneous velocity is the limit of the average velocity as h approaches 0. As h approaches 0, 12 - 3h + h^2 approaches 12.' from version_ins
union all select gen_random_uuid(), id, 'D', '5 meters per second', false, 'This uses the time t = 5 as if it were the velocity. The velocity comes from the limit of the average velocity, not from the time value.' from version_ins
;
-- MCQ variant 001-v2 of 001 | easy | Draining Tank Rate From a Volume Change
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-001-v2', 'mcq', 'Draining Tank Rate From a Volume Change', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water drains from a tank. Let V(t) be the volume in liters at time t minutes. Over the interval [4, 4 + h], the volume changes by V(4 + h) - V(4) = -5h - 2h^2 liters. What is the instantaneous rate of change of the volume at t = 4?', md5('apcalcab-mcq-u1v-001-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 liters per minute', false, 'This lets h approach 0 in the numerator only, where -5h - 2h^2 goes to 0, but the denominator h also goes to 0. The quotient must be simplified first; it approaches -5.' from version_ins
union all select gen_random_uuid(), id, 'B', '-5 - 2h liters per minute', false, 'This is the average rate over an interval of length h, so it still depends on h. The instantaneous rate is the limit of this expression as h approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '4 liters per minute', false, 'This uses the time t = 4 as if it were the rate. The rate is found from the limit of the average rate, not read from the time value.' from version_ins
union all select gen_random_uuid(), id, 'D', '-5 liters per minute', true, 'The average rate over [4, 4 + h] is (-5h - 2h^2)/h = -5 - 2h for h != 0. As h approaches 0 this approaches -5, which is the instantaneous rate.' from version_ins
;
-- MCQ variant 001-v3 of 001 | easy | Revenue Growth From a Fractional Average Rate
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-001-v3', 'mcq', 'Revenue Growth From a Fractional Average Rate', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A shop''s cumulative revenue is R(t) thousand dollars after t weeks. The average rate of change of R over the interval [10, 10 + h] is 18/(6 + h) thousand dollars per week. What is the instantaneous rate of change of R at t = 10?', md5('apcalcab-mcq-u1v-001-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3 thousand dollars per week', true, 'The instantaneous rate is the limit of the average rate as h approaches 0. As h approaches 0, 18/(6 + h) approaches 18/6 = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '18/7 thousand dollars per week', false, 'This substitutes h = 1 instead of letting h approach 0. The limit lets h shrink to 0, giving 18/6 = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '18/(6 + h) thousand dollars per week', false, 'This is the average rate over an interval of length h, so it depends on h. The instantaneous rate is the limit of that expression as h approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 thousand dollars per week', false, 'Shrinking the interval does not make the rate 0. The expression 18/(6 + h) approaches 18/6 = 3.' from version_ins
;
-- MCQ variant 002-v1 of 002 | medium | Cooling Rate From Shrinking Intervals
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-002-v1', 'mcq', 'Cooling Rate From Shrinking Intervals', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature of a cooling liquid is T(t) degrees Celsius at time t minutes. The table gives the average rate of change of T over [2, 2 + h], in degrees per minute.

h = 0.1: -4.2
h = 0.01: -4.02
h = 0.001: -4.002

Which of the following is the best estimate of the instantaneous rate of change of T at t = 2?', md5('apcalcab-mcq-u1v-002-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-4.2', false, 'This is the average rate over the widest interval in the table. It is the least accurate of the three values, not the value the averages approach.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'Shrinking the interval toward length 0 does not make the rate 0. The averages in the table are getting closer to -4.' from version_ins
union all select gen_random_uuid(), id, 'C', '-4', true, 'As the interval shrinks, the average rates -4.2, -4.02, -4.002 move toward -4. The instantaneous rate is the value these averages approach.' from version_ins
union all select gen_random_uuid(), id, 'D', '-4.002', false, 'This is the average rate over the smallest interval listed. It is close but is still an average over an interval of length 0.001, not the value being approached.' from version_ins
;
-- MCQ variant 002-v2 of 002 | medium | Plant Growth Rate From Two-Sided Intervals
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-002-v2', 'mcq', 'Plant Growth Rate From Two-Sided Intervals', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The height of a plant is H(t) centimeters at day t. The table gives the average rate of change of H, in cm per day, between day 3 and day 3 + h, where h can be negative.

h = -0.1: 9.7
h = -0.01: 9.97
h = 0.01: 10.03
h = 0.1: 10.3

Which of the following is the best estimate of the instantaneous rate of change of H at day 3?', md5('apcalcab-mcq-u1v-002-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The instantaneous rate does not exist because the table has no entry for h = 0.', false, 'A table only samples the averages; it need not include h = 0, and the rate is defined as the limit of the averages. Both sides approach 10, so the rate exists.' from version_ins
union all select gen_random_uuid(), id, 'B', '10.03', false, 'This is the average rate over the closest interval on the right only. It is still an average over an interval of length 0.01, not the value both sides approach.' from version_ins
union all select gen_random_uuid(), id, 'C', '10.3', false, 'This is the average rate over the widest interval on the right. It is the least accurate entry on that side, not the value being approached.' from version_ins
union all select gen_random_uuid(), id, 'D', '10', true, 'From both sides, the average rates move toward 10 as |h| shrinks (9.7, 9.97 from below and 10.3, 10.03 from above). The instantaneous rate is the value they approach.' from version_ins
;
-- MCQ variant 002-v3 of 002 | medium | Reaction Rate Approached From Below
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-002-v3', 'mcq', 'Reaction Rate Approached From Below', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The amount of a product is P(t) moles at time t seconds. The table gives the average rate of change of P over [1, 1 + h], in moles per second.

h = 0.1: 0.48
h = 0.01: 0.498
h = 0.001: 0.4998

Which of the following is the best estimate of the instantaneous rate of change of P at t = 1?', md5('apcalcab-mcq-u1v-002-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/2', true, 'As the interval shrinks, the average rates 0.48, 0.498, 0.4998 increase toward 0.5 = 1/2. The instantaneous rate is the value these averages approach.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'Shrinking the interval toward length 0 does not make the rate 0. The averages in the table are getting closer to 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.48', false, 'This is the average rate over the widest interval. It is the least accurate value in the table, not the value the averages approach.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.4998', false, 'This is the average rate over the smallest interval listed. It is close to the target but is still an average over an interval of length 0.001.' from version_ins
;
-- MCQ variant 003-v1 of 003 | easy | Sensor Reading Near a Time
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-003-v1', 'mcq', 'Sensor Reading Near a Time', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor reports a reading R(t) in degrees at time t hours, and lim(t->12) R(t) = 30. Which of the following must be true?', md5('apcalcab-mcq-u1v-003-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R(12) = 30', false, 'A limit describes what R does near t = 12, not at t = 12. The reading R(12) may be a different number, or may not exist.' from version_ins
union all select gen_random_uuid(), id, 'B', 'R(t) < 30 for every t less than 12', false, 'A limit does not force the outputs to stay on one side of the limit value or to approach it monotonically. The readings could be above 30 on either side of 12.' from version_ins
union all select gen_random_uuid(), id, 'C', 'R(t) = 30 for some t other than 12 that is near 12', false, 'The outputs only need to get close to 30, not to reach it. A function can approach 30 without ever equaling 30 for t != 12.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The readings R(t) get arbitrarily close to 30 as t gets arbitrarily close to 12 from either side of 12.', true, 'This is the meaning of a two-sided limit: the outputs approach 30 as the inputs approach 12 from the left and from the right.' from version_ins
;
-- MCQ variant 003-v2 of 003 | easy | Limit and Value Disagree
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-003-v2', 'mcq', 'Limit and Value Disagree', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a function p, lim(x->1) p(x) = -3 and p(1) = 2. Which of the following must be true?', md5('apcalcab-mcq-u1v-003-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist because p(1) is not equal to the limit.', false, 'The limit exists and equals -3. It does not have to equal p(1); a mismatch only means p is not continuous at 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'As x approaches 1, p(x) gets arbitrarily close to 2.', false, 'This uses the value p(1) as if it were the limit. The limit depends only on the outputs near x = 1, which approach -3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'As x gets arbitrarily close to 1 from either side, p(x) gets arbitrarily close to -3, even though p(1) is different.', true, 'The limit describes the behavior of p near x = 1, so the outputs approach -3. The value p(1) = 2 is a separate fact and does not change the limit.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit equals -1/2, the average of -3 and 2.', false, 'A limit is not an average of nearby values and the function value. It is the single number the outputs approach, and here it is given as -3.' from version_ins
;
-- MCQ variant 003-v3 of 003 | easy | Cost at an Undefined Production Level
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-003-v3', 'mcq', 'Cost at an Undefined Production Level', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cost function C(q) satisfies lim(q->3) C(q) = 12, and C(3) is not defined. Which of the following must be true?', md5('apcalcab-mcq-u1v-003-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C(q) = 12 for every q near 3 other than q = 3.', false, 'Approaching 12 does not mean being equal to 12. C(q) could be 12.1 at one point and 11.98 at another and still have limit 12.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit cannot be 12, because C(3) is not defined.', false, 'A limit can exist at a point where the function is undefined. Only the behavior of C near q = 3 matters.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Any value later assigned to C(3) must be 12.', false, 'The limit says nothing about what value may be assigned at q = 3. C(3) can be defined as any number without changing the limit; only a value chosen to make C continuous at q = 3 would have to be 12.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C(q) gets arbitrarily close to 12 as q gets arbitrarily close to 3 from either side, even though C(3) does not exist.', true, 'A limit depends only on the values of C near q = 3, not at q = 3. The outputs approach 12 from both sides, so the limit statement is consistent with C(3) being undefined.' from version_ins
;

commit;
