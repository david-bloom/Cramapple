begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-mcq-u1v-023-v1','apcalcab-mcq-u1v-023-v2','apcalcab-mcq-u1v-023-v3','apcalcab-mcq-u1v-024-v1','apcalcab-mcq-u1v-024-v2','apcalcab-mcq-u1v-024-v3','apcalcab-mcq-u1v-025-v1','apcalcab-mcq-u1v-025-v2','apcalcab-mcq-u1v-025-v3','apcalcab-mcq-u1v-026-v1','apcalcab-mcq-u1v-026-v2'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- MCQ variant 023-v1 of 023 | medium | Asymptotes of a Circuit Response
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-023-v1', 'mcq', 'Asymptotes of a Circuit Response', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The response of a circuit is modeled by f(x) = (x^2 + 2x - 3)/(x^3 - 4x^2 - 7x + 10), where x is the input frequency setting. The denominator factors as (x - 1)(x + 2)(x - 5). Which of the following gives all vertical asymptotes of the graph of f?', md5('apcalcab-mcq-u1v-023-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = -2 and x = 5', true, 'The numerator factors as (x + 3)(x - 1). The factor x - 1 cancels, leaving a hole at x = 1. In the simplified form (x + 3)/((x + 2)(x - 5)), the denominator is 0 at x = -2 and x = 5 while the numerator is 1 and 8 there, so both are vertical asymptotes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = -2, x = 1 and x = 5', false, 'These are all the zeros of the denominator, but at x = 1 the factor x - 1 cancels with the numerator, leaving a hole rather than an asymptote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 1 only', false, 'At x = 1 the common factor cancels, leaving a hole. The asymptotes are at the zeros of the denominator that remain after simplifying, x = -2 and x = 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = -3, x = -2 and x = 5', false, 'x = -3 is a zero of the numerator, so f(-3) = 0. It is not a zero of the denominator, so there is no asymptote there.' from version_ins
;
-- MCQ variant 023-v2 of 023 | medium | Asymptotes of an Average-Cost Model With Fractional Zeros
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-023-v2', 'mcq', 'Asymptotes of an Average-Cost Model With Fractional Zeros', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A firm models its average cost per unit by f(x) = (2x^2 + 5x - 3)/(2x^2 - 3x + 1), where x is a production level. Which of the following gives all vertical asymptotes of the graph of f?', md5('apcalcab-mcq-u1v-023-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 1 only', true, 'Factoring gives f(x) = (2x - 1)(x + 3)/((2x - 1)(x - 1)). The factor 2x - 1 cancels, leaving a hole at x = 1/2. In the simplified form (x + 3)/(x - 1), the denominator is 0 at x = 1 while the numerator is 4, so there is a vertical asymptote at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = -3 and x = 1', false, 'x = -3 is a zero of the numerator, so f(-3) = 0. It is not a zero of the denominator, so the graph has no asymptote there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 1/2 only', false, 'At x = 1/2 the common factor cancels, leaving a hole. The remaining denominator factor x - 1 gives the asymptote at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 1/2 and x = 1', false, 'Both are zeros of the denominator, but the factor 2x - 1 cancels with the numerator, so x = 1/2 is a hole rather than an asymptote.' from version_ins
;
-- MCQ variant 023-v3 of 023 | medium | A Squared Factor Keeps an Asymptote
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-023-v3', 'mcq', 'A Squared Factor Keeps an Asymptote', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The flow rate through a valve is modeled by f(x) = (x^2 - 4)/(x^3 - 4x^2 + 4x), where x is the valve opening. Note that x^3 - 4x^2 + 4x = x(x - 2)^2. Which of the following gives all vertical asymptotes of the graph of f?', md5('apcalcab-mcq-u1v-023-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 0 only', false, 'This assumes the factor x - 2 cancels completely. The denominator has (x - 2)^2, so one factor x - 2 remains after cancelling and f is unbounded near 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 0, x = 2 and x = -2', false, 'x = -2 is a zero of the numerator, so f(-2) = 0. It is not a zero of the denominator, so there is no asymptote there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 0 and x = 2', true, 'Factoring gives f(x) = (x - 2)(x + 2)/(x(x - 2)^2). One factor x - 2 cancels, leaving (x + 2)/(x(x - 2)). This is still zero in the denominator at x = 0 and x = 2, and the numerator is 2 and 4 there, so both are vertical asymptotes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 2 only', false, 'This overlooks the factor x in the denominator. It does not cancel with anything in the numerator, so f is also unbounded near x = 0.' from version_ins
;
-- MCQ variant 024-v1 of 024 | medium | Negative Numerator Over a Squared Denominator
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-024-v1', 'mcq', 'Negative Numerator Over a Squared Denominator', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A detector''s signal strength near a resonance point is modeled by S(x) = (2 - x)/(x - 3)^2, where x is the drive setting. What is lim(x->3+) (2 - x)/(x - 3)^2?', md5('apcalcab-mcq-u1v-024-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist because the one-sided limits are different.', false, 'The squared denominator is positive on both sides of 3, so the quotient tends to negative infinity from the left as well as from the right. The one-sided limits agree.' from version_ins
union all select gen_random_uuid(), id, 'B', '-infinity', true, 'The numerator approaches -1, which is negative. The denominator (x - 3)^2 is positive for every x != 3 and approaches 0, so the quotient is negative and its magnitude grows without bound.' from version_ins
union all select gen_random_uuid(), id, 'C', 'infinity', false, 'This ignores the sign of the numerator. Because (x - 3)^2 > 0, the sign of the quotient is the sign of 2 - x, which is negative near x = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'The numerator approaches -1, a nonzero number. When the numerator approaches a nonzero number, a denominator approaching 0 makes the quotient large in magnitude, not small.' from version_ins
;
-- MCQ variant 024-v2 of 024 | medium | Fourth-Power Denominator on the Left
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-024-v2', 'mcq', 'Fourth-Power Denominator on the Left', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The rate of a reaction is modeled by R(t) = (t^2 + 3)/(t + 1)^4, where t is a temperature offset. What is lim(t->-1-) (t^2 + 3)/(t + 1)^4?', md5('apcalcab-mcq-u1v-024-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-infinity', false, 'It is tempting to say t + 1 is negative when t < -1. But it is raised to the fourth power, so the denominator is positive on both sides of -1.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This evaluates only the numerator at t = -1. The denominator approaches 0, so the quotient does not settle on the numerator''s value.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'The numerator approaches 4, a nonzero number. When the numerator approaches a nonzero number, a denominator approaching 0 makes the quotient large in magnitude, not small.' from version_ins
union all select gen_random_uuid(), id, 'D', 'infinity', true, 'The numerator approaches 4, which is positive. The denominator (t + 1)^4 is positive for every t != -1 (an even power of a negative number is positive) and approaches 0, so the quotient is positive and unbounded.' from version_ins
;
-- MCQ variant 024-v3 of 024 | medium | Hidden Perfect Square in a Denominator
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-024-v3', 'mcq', 'Hidden Perfect Square in a Denominator', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A firm''s marginal profit is modeled by P(x) = (x - 4)/(x^2 - 2x + 1), where x is the quantity sold in thousands. What is lim(x->1-) (x - 4)/(x^2 - 2x + 1)?', md5('apcalcab-mcq-u1v-024-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The numerator approaches -3, a nonzero number. When the numerator approaches a nonzero number, a denominator approaching 0 makes the quotient large in magnitude, not small.' from version_ins
union all select gen_random_uuid(), id, 'B', '-3', false, 'This evaluates only the numerator at x = 1. The denominator approaches 0, so the quotient does not settle on the numerator''s value.' from version_ins
union all select gen_random_uuid(), id, 'C', '-infinity', true, 'The denominator is a perfect square: x^2 - 2x + 1 = (x - 1)^2, which is positive for x != 1 and approaches 0. The numerator approaches -3, which is negative, so the quotient is negative and unbounded.' from version_ins
union all select gen_random_uuid(), id, 'D', 'infinity', false, 'This recognizes that the denominator is positive but ignores that the numerator is negative near x = 1, so the quotient is negative.' from version_ins
;
-- MCQ variant 025-v1 of 025 | hard | Two Asymptotes of a Sine Denominator
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-025-v1', 'mcq', 'Two Asymptotes of a Sine Denominator', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A signal amplitude is modeled by f(x) = 3/(2 sin x - 1) on the interval 0 <= x <= pi, where x is the phase in radians. Which of the following gives all values of x in this interval at which the graph of f has a vertical asymptote?', md5('apcalcab-mcq-u1v-025-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'pi/3 and 2pi/3', false, 'These are the angles where sin x = sqrt(3)/2 (and cos x = 1/2 at pi/3). The equation to solve is sin x = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'pi/6 only', false, 'This finds the reference angle but stops there. Sine is also 1/2 at pi - pi/6 = 5pi/6, which lies in the interval, so there is a second asymptote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'pi/6 and 5pi/6', true, 'A vertical asymptote occurs where the denominator is 0 and the numerator is not. Setting 2 sin x - 1 = 0 gives sin x = 1/2. In [0, pi] this has two solutions, x = pi/6 and x = 5pi/6, and the numerator is 3 at both.' from version_ins
union all select gen_random_uuid(), id, 'D', 'pi/6 and 7pi/6', false, 'sin(7pi/6) = -1/2, not 1/2, and 7pi/6 is outside 0 <= x <= pi. The second solution of sin x = 1/2 in the interval is pi - pi/6 = 5pi/6.' from version_ins
;
-- MCQ variant 025-v2 of 025 | hard | Asymptote Where Cosine Is Negative
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-025-v2', 'mcq', 'Asymptote Where Cosine Is Negative', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The brightness of a light through a filter is modeled by f(x) = (x + 1)/(1 + 2cos x) on the interval 0 <= x <= pi, where x is the filter angle in radians. On this interval, the graph of f has a vertical asymptote at x =', md5('apcalcab-mcq-u1v-025-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'pi/3', false, 'cos(pi/3) = +1/2, but the equation is cos x = -1/2. This drops the negative sign when solving 1 + 2cos x = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '5pi/6', false, 'sin(5pi/6) equals 1/2, but the denominator involves cosine. At 5pi/6, cos x = -sqrt(3)/2, so 1 + 2cos x is not 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '2pi/3', true, 'A vertical asymptote occurs where the denominator is 0 and the numerator is not. Setting 1 + 2cos x = 0 gives cos x = -1/2, and the only solution in [0, pi] is x = 2pi/3. The numerator x + 1 is not 0 there.' from version_ins
union all select gen_random_uuid(), id, 'D', '4pi/3', false, 'cos(4pi/3) = -1/2, but 4pi/3 is larger than pi and lies outside the interval 0 <= x <= pi.' from version_ins
;
-- MCQ variant 025-v3 of 025 | hard | Tangent Denominator With an Undefined Point
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-025-v3', 'mcq', 'Tangent Denominator With an Undefined Point', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ramp-angle model gives f(x) = 1/(tan x - 1) for values of x in 0 <= x <= pi (x not equal to pi/2, where tan x is undefined). Which of the following gives all values of x in this interval at which the graph of f has a vertical asymptote?', md5('apcalcab-mcq-u1v-025-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'pi/4 and 5pi/4', false, 'tan(5pi/4) = 1 as well, but 5pi/4 is greater than pi and lies outside the interval 0 <= x <= pi.' from version_ins
union all select gen_random_uuid(), id, 'B', 'pi/4 only', true, 'The denominator tan x - 1 is 0 when tan x = 1, which in [0, pi] happens only at x = pi/4, and the numerator is 1 there, so f is unbounded near pi/4. At x = pi/2, tan x becomes unbounded, so 1/(tan x - 1) approaches 0 from both sides. There is no asymptote at pi/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'pi/4 and pi/2', false, 'This treats pi/2 as an asymptote because tan x has one there. But tan x is huge near pi/2, so 1/(tan x - 1) is close to 0 there, not unbounded.' from version_ins
union all select gen_random_uuid(), id, 'D', 'pi/2 only', false, 'The undefined point of tan x does not produce an asymptote of f: as tan x grows without bound, 1/(tan x - 1) approaches 0. The asymptote comes from tan x = 1.' from version_ins
;
-- MCQ variant 026-v1 of 026 | easy | Limit at Infinity of a Radical Over a Linear Term
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-026-v1', 'mcq', 'Limit at Infinity of a Radical Over a Linear Term', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The ratio of a sensor''s output to its input is modeled by G(x) = sqrt(9x^2 + 4x)/(2x - 1) for large input x > 0. What is lim(x->infinity) sqrt(9x^2 + 4x)/(2x - 1)?', md5('apcalcab-mcq-u1v-026-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/2', true, 'For large x, sqrt(9x^2 + 4x) behaves like sqrt(9x^2) = 3x. The numerator and denominator then both grow linearly, and dividing each by x gives (sqrt(9 + 4/x))/(2 - 1/x), which approaches 3/2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'infinity', false, 'This treats the numerator as if it grew like x^2, ignoring the square root. The radical grows only linearly, at the same rate as 2x - 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '2/3', false, 'This inverts the ratio of leading behaviors. The numerator behaves like 3x and the denominator like 2x, so the ratio is 3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '9/2', false, 'This treats sqrt(9x^2 + 4x) as behaving like 9x, forgetting to take the square root of the coefficient 9. The radical behaves like 3x.' from version_ins
;
-- MCQ variant 026-v2 of 026 | easy | Limit at Infinity of a Ratio of Exponentials
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-026-v2', 'mcq', 'Limit at Infinity of a Ratio of Exponentials', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two bacterial cultures are compared. Their sizes are A(t) = 7e^(3t) + 2 and B(t) = 4e^(3t) - e^t, where t is the time in hours. What is lim(t->infinity) A(t)/B(t)?', md5('apcalcab-mcq-u1v-026-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'A limit of 0 would require the denominator to grow faster than the numerator. Both are dominated by e^(3t), so they grow at the same rate.' from version_ins
union all select gen_random_uuid(), id, 'B', '7/4', true, 'For large t, e^(3t) dominates both the constant 2 and the term e^t. Dividing the numerator and denominator by e^(3t) gives (7 + 2e^(-3t))/(4 - e^(-2t)), which approaches 7/4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'infinity', false, 'A limit of infinity would require the numerator to grow faster than the denominator. Both are dominated by a multiple of e^(3t).' from version_ins
union all select gen_random_uuid(), id, 'D', '4/7', false, 'This inverts the ratio of the coefficients of e^(3t). The numerator''s coefficient is 7 and the denominator''s is 4.' from version_ins
;

commit;
