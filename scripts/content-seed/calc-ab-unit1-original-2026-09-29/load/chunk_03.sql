begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-mcq-u1n-025','apcalcab-mcq-u1n-026','apcalcab-mcq-u1n-027','apcalcab-mcq-u1n-028','apcalcab-mcq-u1n-029','apcalcab-frq-u1n-001','apcalcab-frq-u1n-002','apcalcab-frq-u1n-003','apcalcab-frq-u1n-004'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- MCQ 025 | topic 1.14 | hard | A Vertical Asymptote of a Trigonometric Function
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-025', 'mcq', 'A Vertical Asymptote of a Trigonometric Function', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 <= x <= pi, the graph of f(x) = 1/(2cos x - 1) has a vertical asymptote at x =', md5('apcalcab-mcq-u1n-025'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'pi/3', true, 'A vertical asymptote occurs where the denominator is 0 and the numerator is not. Setting 2cos x - 1 = 0 gives cos x = 1/2, and the only solution in [0, pi] is x = pi/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'At x = 0, 2cos 0 - 1 = 1, so f(0) = 1 and there is no asymptote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'pi/6', false, 'sin(pi/6) equals 1/2, but the denominator involves cosine. The equation is cos x = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'pi/2', false, 'cos(pi/2) = 0, which makes 2cos x - 1 equal -1. The function is defined there, so there is no asymptote.' from version_ins
;
-- MCQ 026 | topic 1.15 | easy | Limit at Infinity of a Rational Function
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-026', 'mcq', 'Limit at Infinity of a Rational Function', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x->infinity) (5x^3 - 2x)/(2x^3 + 7x^2)?', md5('apcalcab-mcq-u1n-026'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/2', true, 'The numerator and denominator both have degree 3. Dividing each term by x^3 leaves (5 - 2/x^2)/(2 + 7/x), which approaches 5/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'A limit of 0 would require the denominator''s degree to exceed the numerator''s. Here the degrees are equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'infinity', false, 'A limit of infinity would require the numerator''s degree to exceed the denominator''s. Here the degrees are equal.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/5', false, 'This inverts the ratio of leading coefficients. The numerator''s leading coefficient is 5 and the denominator''s is 2.' from version_ins
;
-- MCQ 027 | topic 1.15 | hard | Two Horizontal Asymptotes From a Radical
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-027', 'mcq', 'Two Horizontal Asymptotes From a Radical', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 3x/sqrt(4x^2 + 1). Which of the following gives all horizontal asymptotes of the graph of f?', md5('apcalcab-mcq-u1n-027'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 0 only', false, 'The numerator grows like x and sqrt(4x^2 + 1) grows like 2|x|. They grow at the same rate, so the limit is not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 3/2 only', false, 'This considers only x approaching positive infinity. As x approaches negative infinity, the radical is positive while x is negative, giving the limit -3/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 3/2 and y = -3/2', true, 'For large positive x, sqrt(4x^2 + 1) behaves like 2x, so f approaches 3/2. For large negative x, sqrt(4x^2 + 1) behaves like 2|x| = -2x, so f approaches -3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 3 and y = -3', false, 'This treats sqrt(4x^2 + 1) as behaving like |x|. It behaves like 2|x|, because sqrt(4x^2) = 2|x|.' from version_ins
;
-- MCQ 028 | topic 1.15 | medium | Interpreting a Limit at Infinity in Context
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-028', 'mcq', 'Interpreting a Limit at Infinity in Context', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature of a cup of tea is modeled by T(t) = 20 + 60e^(-t/4) degrees Celsius, where t >= 0 is the time in minutes. What is lim(t->infinity) T(t), and what does it mean in this context?', md5('apcalcab-mcq-u1n-028'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'infinity; the tea''s temperature grows without bound.', false, 'The exponent -t/4 is negative, so e^(-t/4) decays toward 0. The temperature does not grow.' from version_ins
union all select gen_random_uuid(), id, 'B', '0; the tea eventually cools to 0 degrees Celsius.', false, 'The exponential term approaches 0, but the constant 20 remains, so T(t) approaches 20.' from version_ins
union all select gen_random_uuid(), id, 'C', '20; the tea''s temperature levels off near 20 degrees Celsius.', true, 'As t increases, e^(-t/4) approaches 0, so T(t) approaches 20 + 60(0) = 20. The model predicts the temperature settles near 20 degrees.' from version_ins
union all select gen_random_uuid(), id, 'D', '80; the tea''s temperature levels off near 80 degrees Celsius.', false, 'The value 80 is T(0), the starting temperature. The question is about what happens as t grows large, not at t = 0.' from version_ins
;
-- MCQ 029 | topic 1.15 | hard | Comparing Growth Rates at Infinity
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-029', 'mcq', 'Comparing Growth Rates at Infinity', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x->infinity) (x^5 + 3^x)/(2 * 4^x)?', md5('apcalcab-mcq-u1n-029'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'infinity', false, 'This assumes the numerator outgrows the denominator. But 4^x grows faster than 3^x and faster than any power of x.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This inverts the coefficient comparison, and it also ignores the difference in growth rates.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2', false, 'This compares only the coefficients 1 and 2, ignoring that the denominator''s 4^x outgrows both terms in the numerator.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', true, 'Exponential 4^x grows faster than both the exponential 3^x and the polynomial x^5. Dividing the numerator and denominator by 4^x gives (x^5/4^x + (3/4)^x)/2, and both terms in the numerator approach 0.' from version_ins
;
-- FRQ 001 | topic 1.13 | medium | A Hole and an Asymptote in One Rational Function
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1n-001', 'frq', 'A Hole and an Asymptote in One Rational Function', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(x->3) g(x). Show the algebra that leads to your answer.

(b) The graph of g has a removable discontinuity at x = 3. Justify this, and state the value that would have to be assigned to g(3) to make the function continuous at x = 3.

(c) Find lim(x->-3-) g(x) and lim(x->-3+) g(x). Give a reason for the sign of each.', 'Let g be the function defined by g(x) = (2x^2 - x - 15)/(x^2 - 9) for x != 3 and x != -3.', md5('apcalcab-frq-u1n-001'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Factors and cancels x - 3, then evaluates to obtain the limit 11/6.', 1, 'Response factors the numerator as (2x + 5)(x - 3) and the denominator as (x - 3)(x + 3), cancels x - 3, and evaluates (2x + 5)/(x + 3) at x = 3 to get 11/6.', 'Show the factoring and cancellation step before evaluating. A correct value with no algebra does not earn the point.', '["11/6"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Justifies a removable discontinuity: the limit at x = 3 exists but g(3) is not defined.', 1, 'Response states that the limit exists as a finite number while g(3) is undefined (or does not equal the limit), so the discontinuity is removable.', 'State that the limit exists and that g(3) is undefined. Saying only ''the factors cancel'' is not sufficient.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'States that g(3) would have to equal 11/6 for continuity.', 1, 'Response states that assigning g(3) = 11/6 (the limit found in part (a)) makes g continuous at x = 3.', 'Give the value 11/6 and connect it to the limit.', '["11/6"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds the one-sided limits at x = -3 as infinity from the left and -infinity from the right, with sign reasoning.', 1, 'Response gives lim(x->-3-) g(x) = infinity and lim(x->-3+) g(x) = -infinity, using the simplified form (2x + 5)/(x + 3): the numerator is -1 near x = -3 and x + 3 is negative on the left and positive on the right.', 'Give both one-sided limits and explain the sign of x + 3 on each side. Both must be correct.', '["+infinity","positive infinity","negative infinity"]'::jsonb from version_ins
;
-- FRQ 002 | topic 1.14 | medium | Vertical and Horizontal Asymptotes of a Rational Function
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1n-002', 'frq', 'Vertical and Horizontal Asymptotes of a Rational Function', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find all vertical asymptotes of the graph of f. Justify your answer.

(b) Find lim(x->5+) f(x). Give a reason for the sign of your answer.

(c) Find lim(x->-1-) f(x). Give a reason for the sign of your answer.

(d) Write an equation for the horizontal asymptote of the graph of f, or explain why there is none.', 'Let f be the function defined by f(x) = 3x/(x^2 - 4x - 5).', md5('apcalcab-frq-u1n-002'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Identifies x = 5 and x = -1 and justifies each with a zero denominator and a nonzero numerator.', 1, 'Response factors the denominator as (x - 5)(x + 1) and identifies x = 5 and x = -1, noting that the numerator 3x is nonzero (15 and -3) at each.', 'Name both asymptotes and state that the numerator is nonzero at each. Listing the zeros of the denominator alone is not enough.', '[]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Finds lim(x->5+) f(x) = infinity, with sign reasoning.', 1, 'Response gives infinity and explains that near 5 from the right the numerator is positive (about 15), x - 5 is small and positive, and x + 1 is positive.', 'Give infinity and justify the sign of each factor.', '["+infinity","positive infinity"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds lim(x->-1-) f(x) = -infinity, with sign reasoning.', 1, 'Response gives -infinity and explains that near -1 from the left the numerator is negative (about -3), and both x + 1 and x - 5 are negative, so the denominator is small and positive.', 'Give -infinity and justify the sign of the numerator and denominator.', '["negative infinity"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-d-criterion-01', 'States the horizontal asymptote y = 0 with a valid reason based on degrees or a limit at infinity.', 1, 'Response gives y = 0 and justifies it with the degree of the denominator exceeding the degree of the numerator, or by evaluating lim(x->infinity) f(x) = 0.', 'State y = 0 and give a reason based on degrees or the limit at infinity.', '["y = 0"]'::jsonb from version_ins
;
-- FRQ 003 | topic 1.15 | hard | Long-Run Behavior in Context and Growth-Rate Comparison
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1n-003', 'frq', 'Long-Run Behavior in Context and Growth-Rate Comparison', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(t->infinity) A(t). Include units and interpret the meaning of your answer in context.

(b) Let q(x) = (4x + 1)/sqrt(9x^2 + 2). Find all horizontal asymptotes of the graph of q. Show the work that leads to each.

(c) Evaluate lim(x->infinity) (2x^4 + 5^x)/(3^x + x^7). Justify your answer using the relative growth rates of the functions involved.', 'The amount of salt, in grams, dissolved in a tank at time t minutes is modeled by A(t) = (80t + 100)/(2t + 5) for t >= 0.', md5('apcalcab-frq-u1n-003'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Finds lim(t->infinity) A(t) = 40 using the leading terms or dividing by t.', 1, 'Response evaluates the limit as 40, for example by dividing by t or comparing leading coefficients 80 and 2.', 'Show the method (dividing by t or comparing leading terms) along with the value 40.', '["40"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-a-criterion-02', 'Interprets the limit with units: the amount of salt approaches 40 grams in the long run.', 1, 'Response states that as time increases without bound, the amount of salt in the tank approaches (levels off near) 40 grams.', 'Include the units (grams) and say what quantity approaches 40 as time grows.', '["40 grams"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Finds both horizontal asymptotes y = 4/3 and y = -4/3, using sqrt(9x^2) = 3|x|.', 1, 'Response gives y = 4/3 (as x approaches infinity) and y = -4/3 (as x approaches negative infinity), showing that the radical behaves like 3|x|.', 'Give both asymptotes and show that the denominator behaves like 3|x|, so its sign flips for negative x.', '["y = 4/3 and y = -4/3"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds the limit is infinity and justifies with 5^x growing faster than 3^x and any polynomial.', 1, 'Response gives infinity and justifies that 5^x outgrows 3^x and powers of x (for example by dividing by 5^x to obtain a numerator approaching 1 and a denominator approaching 0 from above).', 'State infinity and compare growth rates of 5^x, 3^x, x^4 and x^7.', '["infinity","positive infinity"]'::jsonb from version_ins
;
-- FRQ 004 | topic 1.12 | medium | Continuity of a Piecewise Function With Two Parameters
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apcalcab-frq-u1n-004', 'frq', 'Continuity of a Piecewise Function With Two Parameters', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1, 'Answer all parts of the following question.

(a) Find lim(x->1+) f(x). Show the work that leads to your answer.

(b) Find the values of k and m for which f is continuous at x = 1. Justify your answer using the definition of continuity.

(c) Suppose k = 3 and m = 4. Is f continuous at x = 1? If not, classify the discontinuity and justify your answer.', 'Let f be the function defined by

f(x) = kx + 2 for x < 1
f(1) = m
f(x) = (x^2 + 2x - 3)/(x - 1) for x > 1

where k and m are constants.', md5('apcalcab-frq-u1n-004'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Factors and cancels to find lim(x->1+) f(x) = 4.', 1, 'Response factors x^2 + 2x - 3 = (x + 3)(x - 1), cancels x - 1, and evaluates x + 3 at x = 1 to get 4.', 'Show the factoring and cancellation, not just the value 4.', '["4"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-01', 'Sets the left-hand limit equal to the right-hand limit and finds k = 2.', 1, 'Response sets k(1) + 2 = 4 (the left-hand limit equals the right-hand limit) and finds k = 2.', 'Set the one-sided limits equal and solve for k.', '["k = 2"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-b-criterion-02', 'Sets m equal to the limit and finds m = 4, citing the three conditions of continuity.', 1, 'Response states that f(1) must equal the limit as x approaches 1, so m = 4, referencing that f(1) is defined, the limit exists, and the two are equal.', 'State that f(1) must equal the limit and give m = 4.', '["m = 4"]'::jsonb from version_ins
union all select gen_random_uuid(), id, 'part-c-criterion-01', 'Finds the one-sided limits 5 and 4, concludes f is not continuous, and classifies it as a jump discontinuity.', 1, 'Response gives lim(x->1-) f(x) = 3(1) + 2 = 5 and lim(x->1+) f(x) = 4, concludes that the limit does not exist so f is not continuous, and names the discontinuity a jump discontinuity.', 'Give both one-sided limits (5 and 4), conclude f is not continuous, and name the discontinuity type.', '["jump"]'::jsonb from version_ins
;

commit;
