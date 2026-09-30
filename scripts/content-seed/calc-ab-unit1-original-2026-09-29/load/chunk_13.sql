begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-frq-u1v-003-v1','apcalcab-frq-u1v-003-v2','apcalcab-frq-u1v-003-v3','apcalcab-frq-u1v-004-v1','apcalcab-frq-u1v-004-v2','apcalcab-frq-u1v-004-v3'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- FRQ variant 003-v1 of 003 | hard | Long-Run Drug Concentration and Growth-Rate Comparison
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-003-v1', 'frq', 'Long-Run Drug Concentration and Growth-Rate Comparison', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(t->infinity) C(t). Include units and interpret the meaning of your answer in context.

(b) Let q(x) = (5x - 2)/sqrt(4x^2 + 7). Find all horizontal asymptotes of the graph of q. Show the work that leads to each.

(c) Evaluate lim(x->infinity) (7^x + x^6)/(4^x + x^10). Justify your answer using the relative growth rates of the functions involved.', 'The concentration of a medication in a patient''s bloodstream, in milligrams per liter, t hours after an injection is modeled by C(t) = (72t + 30)/(4t + 9) for t >= 0.', md5('apcalcab-frq-u1v-003-v1'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Finds lim(t->infinity) C(t) = 18 using the leading terms or dividing by t.', 1, 'Response evaluates the limit as 18, for example by dividing by t or comparing leading coefficients 72 and 4.', 'Show the method (dividing by t or comparing leading terms) along with the value 18.', '["18"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-02', 'Interprets the limit with units: the concentration approaches 18 milligrams per liter in the long run.', 1, 'Response states that as time increases without bound, the concentration of the medication approaches (levels off near) 18 milligrams per liter.', 'Include the units (milligrams per liter) and say what quantity approaches 18 as time grows.', '["18 mg/L","18 milligrams per liter"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Finds both horizontal asymptotes y = 5/2 and y = -5/2, using sqrt(4x^2) = 2|x|.', 1, 'Response gives y = 5/2 (as x approaches infinity) and y = -5/2 (as x approaches negative infinity), showing that the radical behaves like 2|x|.', 'Give both asymptotes and show that the denominator behaves like 2|x|, so its sign relative to x flips for negative x.', '["y = 5/2 and y = -5/2"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds the limit is infinity and justifies with 7^x growing faster than 4^x and any power of x.', 1, 'Response gives infinity and justifies that 7^x outgrows 4^x and powers of x (for example by dividing by 7^x to obtain a numerator approaching 1 and a denominator approaching 0 from above).', 'State infinity and compare growth rates of 7^x, 4^x, x^6 and x^10.', '["infinity","positive infinity"]'::jsonb from version_ins
;
-- FRQ variant 003-v2 of 003 | hard | Terminal Speed and Growth Rates With Matching Exponentials
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-003-v2', 'frq', 'Terminal Speed and Growth Rates With Matching Exponentials', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(t->infinity) v(t). Include units and interpret the meaning of your answer in context.

(b) Let q(x) = (6 - 3x)/sqrt(x^2 + 5). Find all horizontal asymptotes of the graph of q. Show the work that leads to each.

(c) Evaluate lim(x->infinity) (3(2^x) + x^8)/(5(2^x) + x^3). Justify your answer using the relative growth rates of the functions involved.', 'The speed of a rocket sled, in meters per second, t seconds after release is modeled by v(t) = (90t^2 + 40)/(3t^2 + 2t + 1) for t >= 0.', md5('apcalcab-frq-u1v-003-v2'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Finds lim(t->infinity) v(t) = 30 using the leading terms or dividing by t^2.', 1, 'Response evaluates the limit as 30, for example by dividing by t^2 or comparing leading coefficients 90 and 3.', 'Show the method (dividing by t^2 or comparing leading terms) along with the value 30.', '["30"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-02', 'Interprets the limit with units: the speed approaches 30 meters per second in the long run.', 1, 'Response states that as time increases without bound, the speed of the sled approaches (levels off near) 30 meters per second.', 'Include the units (meters per second) and say what quantity approaches 30 as time grows.', '["30 m/s","30 meters per second"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Finds both horizontal asymptotes y = -3 and y = 3, using sqrt(x^2) = |x|.', 1, 'Response gives y = -3 (as x approaches infinity) and y = 3 (as x approaches negative infinity), showing that the radical behaves like |x|, so the quotient behaves like (-3x)/|x|.', 'Give both asymptotes and show that the denominator behaves like |x|, so the sign of the ratio flips for negative x.', '["y = -3 and y = 3"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds the limit is 3/5 and justifies that 2^x dominates x^8 and x^3 in numerator and denominator.', 1, 'Response gives 3/5 and justifies that 2^x grows faster than any power of x, so x^8 and x^3 become negligible next to the 2^x terms (for example by dividing by 2^x to obtain (3 + x^8/2^x)/(5 + x^3/2^x) with both power-over-exponential terms approaching 0).', 'State 3/5 and explain that the exponential 2^x outgrows both x^8 and x^3, leaving the ratio of coefficients 3 and 5.', '["3/5","0.6"]'::jsonb from version_ins
;
-- FRQ variant 003-v3 of 003 | hard | Average Cost in the Long Run and a Radical Numerator
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-003-v3', 'frq', 'Average Cost in the Long Run and a Radical Numerator', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(n->infinity) A(n). Include units and interpret the meaning of your answer in context.

(b) Let q(x) = sqrt(4x^2 + 1)/(x + 3). Find all horizontal asymptotes of the graph of q. Show the work that leads to each.

(c) Evaluate lim(x->infinity) (x^12 + 2^x)/(3^x + 8x^2). Justify your answer using the relative growth rates of the functions involved.', 'A workshop''s average cost per unit, in dollars, when n units are produced is modeled by A(n) = (250n + 4000)/(n + 50) for n >= 1.', md5('apcalcab-frq-u1v-003-v3'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Finds lim(n->infinity) A(n) = 250 using the leading terms or dividing by n.', 1, 'Response evaluates the limit as 250, for example by dividing by n or comparing leading coefficients 250 and 1.', 'Show the method (dividing by n or comparing leading terms) along with the value 250.', '["250"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-02', 'Interprets the limit with units: the average cost approaches 250 dollars per unit as production grows.', 1, 'Response states that as the number of units produced increases without bound, the average cost per unit approaches (levels off near) 250 dollars per unit.', 'Include the units (dollars per unit) and say what quantity approaches 250 as production grows.', '["$250 per unit","250 dollars per unit"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Finds both horizontal asymptotes y = 2 and y = -2, using sqrt(4x^2) = 2|x|.', 1, 'Response gives y = 2 (as x approaches infinity) and y = -2 (as x approaches negative infinity), showing that the radical in the numerator behaves like 2|x|, so the quotient behaves like 2|x|/x.', 'Give both asymptotes and show that the numerator behaves like 2|x|, so the sign of the ratio flips for negative x.', '["y = 2 and y = -2"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds the limit is 0 and justifies with 3^x growing faster than 2^x and any power of x.', 1, 'Response gives 0 and justifies that 3^x outgrows 2^x and powers of x, and x^12 is negligible next to 2^x, so the denominator grows faster than the numerator (for example by dividing by 3^x to obtain a numerator approaching 0 and a denominator approaching 1).', 'State 0 and compare growth rates of 3^x, 2^x, x^12 and x^2.', '["0","zero"]'::jsonb from version_ins
;
-- FRQ variant 004-v1 of 004 | medium | Continuity of a Shipping Fee at a Weight Threshold
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-004-v1', 'frq', 'Continuity of a Shipping Fee at a Weight Threshold', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(x->2+) f(x). Show the work that leads to your answer.

(b) Find the values of k and m for which f is continuous at x = 2. Justify your answer using the definition of continuity.

(c) Suppose k = 3 and m = 4. Is f continuous at x = 2? If not, classify the discontinuity and justify your answer.', 'A shipping fee f, in dollars, for a package of weight x kilograms is modeled by

f(x) = kx - 1 for x < 2
f(2) = m
f(x) = (x^2 + x - 6)/(x - 2) for x > 2

where k and m are constants.', md5('apcalcab-frq-u1v-004-v1'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Factors and cancels to find lim(x->2+) f(x) = 5.', 1, 'Response factors x^2 + x - 6 = (x + 3)(x - 2), cancels x - 2, and evaluates x + 3 at x = 2 to get 5.', 'Show the factoring and cancellation, not just the value 5.', '["5"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Sets the left-hand limit equal to the right-hand limit and finds k = 3.', 1, 'Response sets k(2) - 1 = 5 (the left-hand limit equals the right-hand limit) and finds k = 3.', 'Set the one-sided limits equal and solve for k.', '["k = 3"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Sets m equal to the limit and finds m = 5, citing the three conditions of continuity.', 1, 'Response states that f(2) must equal the limit as x approaches 2, so m = 5, referencing that f(2) is defined, the limit exists, and the two are equal.', 'State that f(2) must equal the limit and give m = 5.', '["m = 5"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds that the limit exists (5 from both sides) but f(2) = 4, concludes f is not continuous, and classifies the discontinuity as removable.', 1, 'Response gives lim(x->2-) f(x) = 3(2) - 1 = 5 and lim(x->2+) f(x) = 5, so the limit is 5, notes that f(2) = 4 does not equal 5, concludes f is not continuous, and names the discontinuity removable.', 'Give both one-sided limits (each 5), compare with f(2) = 4, conclude f is not continuous, and name the discontinuity type.', '["removable"]'::jsonb from version_ins
;
-- FRQ variant 004-v2 of 004 | medium | Continuity of a Sensor Reading With a Radical Piece
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-004-v2', 'frq', 'Continuity of a Sensor Reading With a Radical Piece', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(x->4+) f(x). Show the work that leads to your answer.

(b) Find the values of k and m for which f is continuous at x = 4. Justify your answer using the definition of continuity.

(c) Suppose k = 1/2 and m = 0. Is f continuous at x = 4? If not, classify the discontinuity and justify your answer.', 'A sensor''s calibrated reading f, in volts, at input level x is modeled by

f(x) = kx^2 - 4 for x < 4
f(4) = m
f(x) = (x - 4)/(sqrt(x) - 2) for x > 4

where k and m are constants.', md5('apcalcab-frq-u1v-004-v2'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Multiplies by the conjugate sqrt(x) + 2 (or equivalent) and cancels to find lim(x->4+) f(x) = 4.', 1, 'Response multiplies numerator and denominator by sqrt(x) + 2, obtains (x - 4)(sqrt(x) + 2)/(x - 4), cancels x - 4, and evaluates sqrt(x) + 2 at x = 4 to get 4. Recognizing x - 4 = (sqrt(x) - 2)(sqrt(x) + 2) and cancelling is equivalent.', 'Show the conjugate (or difference-of-squares) step and the cancellation, not just the value 4.', '["4"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Sets the left-hand limit equal to the right-hand limit and finds k = 1/2.', 1, 'Response sets k(4)^2 - 4 = 4, that is 16k - 4 = 4 (the left-hand limit equals the right-hand limit), and finds k = 1/2.', 'Set the one-sided limits equal and solve for k.', '["k = 1/2","k = 0.5"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Sets m equal to the limit and finds m = 4, citing the three conditions of continuity.', 1, 'Response states that f(4) must equal the limit as x approaches 4, so m = 4, referencing that f(4) is defined, the limit exists, and the two are equal.', 'State that f(4) must equal the limit and give m = 4.', '["m = 4"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds that the limit exists (4 from both sides) but f(4) = 0, concludes f is not continuous, and classifies the discontinuity as removable.', 1, 'Response gives lim(x->4-) f(x) = (1/2)(16) - 4 = 4 and lim(x->4+) f(x) = 4, so the limit is 4, notes that f(4) = 0 does not equal 4, concludes f is not continuous, and names the discontinuity removable.', 'Give both one-sided limits (each 4), compare with f(4) = 0, conclude f is not continuous, and name the discontinuity type.', '["removable"]'::jsonb from version_ins
;
-- FRQ variant 004-v3 of 004 | medium | Continuity of a Temperature Adjustment Across a Boundary
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1v-004-v3', 'frq', 'Continuity of a Temperature Adjustment Across a Boundary', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(x->-3-) f(x). Show the work that leads to your answer.

(b) Find the values of k and m for which f is continuous at x = -3. Justify your answer using the definition of continuity.

(c) Suppose k = 1 and m = -7. Is f continuous at x = -3? If not, classify the discontinuity and justify your answer.', 'The temperature adjustment f, in degrees, at position x along a heated rod is modeled by

f(x) = (2x^2 + 5x - 3)/(x + 3) for x < -3
f(-3) = m
f(x) = kx + 5 for x > -3

where k and m are constants.', md5('apcalcab-frq-u1v-004-v3'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Factors and cancels to find lim(x->-3-) f(x) = -7.', 1, 'Response factors 2x^2 + 5x - 3 = (2x - 1)(x + 3), cancels x + 3, and evaluates 2x - 1 at x = -3 to get -7.', 'Show the factoring and cancellation, not just the value -7.', '["-7"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Sets the right-hand limit equal to the left-hand limit and finds k = 4.', 1, 'Response sets k(-3) + 5 = -7 (the right-hand limit equals the left-hand limit) and finds k = 4.', 'Set the one-sided limits equal and solve for k.', '["k = 4"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Sets m equal to the limit and finds m = -7, citing the three conditions of continuity.', 1, 'Response states that f(-3) must equal the limit as x approaches -3, so m = -7, referencing that f(-3) is defined, the limit exists, and the two are equal.', 'State that f(-3) must equal the limit and give m = -7.', '["m = -7"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds the one-sided limits -7 and 2, concludes f is not continuous, and classifies it as a jump discontinuity.', 1, 'Response gives lim(x->-3-) f(x) = -7 and lim(x->-3+) f(x) = 1(-3) + 5 = 2, concludes that the limit does not exist so f is not continuous (even though f(-3) = -7), and names the discontinuity a jump discontinuity.', 'Give both one-sided limits (-7 and 2), conclude f is not continuous, and name the discontinuity type.', '["jump"]'::jsonb from version_ins
;

commit;
