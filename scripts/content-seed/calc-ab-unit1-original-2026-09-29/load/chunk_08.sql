begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-mcq-u1v-015-v2','apcalcab-mcq-u1v-015-v3','apcalcab-mcq-u1v-016-v1','apcalcab-mcq-u1v-016-v2','apcalcab-mcq-u1v-016-v3','apcalcab-mcq-u1v-017-v1','apcalcab-mcq-u1v-017-v2','apcalcab-mcq-u1v-017-v3','apcalcab-mcq-u1v-018-v1','apcalcab-mcq-u1v-018-v2','apcalcab-mcq-u1v-018-v3','apcalcab-mcq-u1v-019-v1'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- MCQ variant 015-v2 of 015 | medium | Heat Model With a Radical Branch
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-015-v2', 'mcq', 'Heat Model With a Radical Branch', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature T(x), in degrees, at position x along a metal rod is modeled by

T(x) = 3x - a for x < 4
T(x) = a*sqrt(x) + 1 for x >= 4

For what value of a is T continuous at x = 4?', md5('apcalcab-mcq-u1v-015-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13/3', false, 'This moves the +1 across the equal sign without changing its sign, writing 3a = 12 + 1 instead of 3a = 12 - 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '11', false, 'This gives 12 + a = 2a + 1, changing the sign of a in the left-hand piece. The left-hand value at x = 4 is 12 - a.' from version_ins
union all select gen_random_uuid(), id, 'C', '11/3', true, 'Continuity requires the left-hand limit 3(4) - a = 12 - a to equal T(4) = a*sqrt(4) + 1 = 2a + 1. Solving 12 - a = 2a + 1 gives 3a = 11, so a = 11/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '11/5', false, 'This evaluates sqrt(4) as 4, giving 12 - a = 4a + 1. The square root of 4 is 2.' from version_ins
;
-- MCQ variant 015-v3 of 015 | medium | Signal Shaper Continuous at -2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-015-v3', 'mcq', 'Signal Shaper Continuous at -2', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A signal-shaping function is defined by

S(x) = x^3 + ax for x <= -2
S(x) = x^2 - a for x > -2

For what value of a is S continuous at x = -2?', md5('apcalcab-mcq-u1v-015-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12', false, 'This solves -8 - 2a = 4 - a correctly down to -a = 12 but then drops the negative sign, reporting 12 instead of -12.' from version_ins
union all select gen_random_uuid(), id, 'B', '-4', false, 'This evaluates (-2)^2 as -4, giving -8 - 2a = -4 - a. A negative number squared is positive, so (-2)^2 = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'This evaluates (-2)^3 as +8, giving 8 - 2a = 4 - a. A negative number cubed is negative, so (-2)^3 = -8.' from version_ins
union all select gen_random_uuid(), id, 'D', '-12', true, 'S(-2) = (-2)^3 + a(-2) = -8 - 2a, and the right-hand limit is (-2)^2 - a = 4 - a. Continuity requires -8 - 2a = 4 - a, which gives -a = 12, so a = -12.' from version_ins
;
-- MCQ variant 016-v1 of 016 | medium | Continuity Set of a Logarithmic Quotient
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-016-v1', 'mcq', 'Continuity Set of a Logarithmic Quotient', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the function f(x) = ln(6 - 2x)/(x + 1). What is the set of all x at which f is continuous?', md5('apcalcab-mcq-u1v-016-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The union of (-infinity, -1) and (-1, infinity)', false, 'This removes only x = -1 and ignores the logarithm. ln(6 - 2x) is undefined for x >= 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The union of (-infinity, -1) and (-1, 3)', true, 'The logarithm requires 6 - 2x > 0, which means x < 3. The denominator is 0 at x = -1, which lies in that range and must be removed. f is continuous at every point of its domain, which is (-infinity, -1) and (-1, 3).' from version_ins
union all select gen_random_uuid(), id, 'C', 'The interval (3, infinity)', false, 'This solves 6 - 2x > 0 as x > 3, failing to reverse the inequality when dividing by -2. The correct condition is x < 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The interval (-infinity, 3)', false, 'This satisfies the logarithm''s requirement but includes x = -1, where the denominator is 0 and f is undefined.' from version_ins
;
-- MCQ variant 016-v2 of 016 | medium | Continuity Set With a Radical in the Denominator
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-016-v2', 'mcq', 'Continuity Set With a Radical in the Denominator', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the function f(x) = 1/sqrt(x^2 - 4x - 5). What is the set of all x at which f is continuous?', md5('apcalcab-mcq-u1v-016-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The union of (-infinity, -1] and [5, infinity)', false, 'At x = -1 and x = 5 the radicand is 0, so the denominator sqrt(0) is 0 and f is undefined. Those endpoints must be excluded.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The union of (-infinity, -1), (-1, 5) and (5, infinity)', false, 'This removes only the points where the radicand is 0 and ignores the square root''s requirement. For -1 < x < 5 the radicand is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The union of (-infinity, -1) and (5, infinity)', true, 'Since x^2 - 4x - 5 = (x - 5)(x + 1), the radical is defined and nonzero only where (x - 5)(x + 1) > 0, which is x < -1 or x > 5. On that set f is continuous.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The interval (-1, 5)', false, 'This is where (x - 5)(x + 1) is negative, so the radicand is negative and the square root is undefined there.' from version_ins
;
-- MCQ variant 016-v3 of 016 | medium | Continuity Set of a Reciprocal With Absolute Value
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-016-v3', 'mcq', 'Continuity Set of a Reciprocal With Absolute Value', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the function f(x) = 1/(|x - 1| - 3). What is the set of all x at which f is continuous?', md5('apcalcab-mcq-u1v-016-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The union of (-infinity, 4) and (4, infinity)', false, 'This solves |x - 1| = 3 with only the positive case x - 1 = 3, missing the negative case x - 1 = -3, which gives x = -2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The union of (-infinity, -4), (-4, 2) and (2, infinity)', false, 'This solves x - 1 = 3 and x - 1 = -3 as x + 1 = 3 and x + 1 = -3, changing the sign of the 1. The correct solutions are x = 4 and x = -2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The union of (-infinity, -2), (-2, 1), (1, 4) and (4, infinity)', false, 'This treats the corner of |x - 1| at x = 1 as a discontinuity. The graph has a sharp corner there, but f is defined and continuous at x = 1, where it equals 1/(0 - 3) = -1/3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The union of (-infinity, -2), (-2, 4) and (4, infinity)', true, 'The denominator is 0 when |x - 1| = 3, which means x - 1 = 3 or x - 1 = -3, so x = 4 or x = -2. The absolute value function is continuous everywhere, so f is continuous at every other real number.' from version_ins
;
-- MCQ variant 017-v1 of 017 | hard | Continuous Calibration Curve on [-3, 4]
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-017-v1', 'mcq', 'Continuous Calibration Curve on [-3, 4]', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor is calibrated for input settings from -3 to 4 inclusive. Only one of four candidate response curves is defined and continuous at every setting in that range. Which curve is it?', md5('apcalcab-mcq-u1v-017-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R(x) = 1/(x^2 - 4)', false, 'Since x^2 - 4 = (x - 2)(x + 2), the denominator is 0 at x = 2 and x = -2, both in [-3, 4].' from version_ins
union all select gen_random_uuid(), id, 'B', 'R(x) = sqrt(1 - x)', false, 'The square root is undefined for x > 1, so R is not defined on (1, 4].' from version_ins
union all select gen_random_uuid(), id, 'C', 'R(x) = ln(x + 2)', false, 'The logarithm is undefined for x <= -2, so R is not defined on [-3, -2].' from version_ins
union all select gen_random_uuid(), id, 'D', 'R(x) = sqrt(x + 5)/(x^2 + 1)', true, 'The radical is defined for x >= -5, which includes all of [-3, 4], and the denominator x^2 + 1 is never 0. The quotient of continuous functions with a nonzero denominator is continuous on the whole interval.' from version_ins
;
-- MCQ variant 017-v2 of 017 | hard | Continuity on [1, 6] for a Logarithm of a Quadratic
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-017-v2', 'mcq', 'Continuity on [1, 6] for a Logarithm of a Quadratic', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A technician needs a model that is continuous at every input from 1 to 6, inclusive. Which of the following functions is continuous on the closed interval [1, 6]?', md5('apcalcab-mcq-u1v-017-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = ln(x^2 - 4x + 5)', true, 'The argument x^2 - 4x + 5 = (x - 2)^2 + 1 is at least 1 for every real x, so it is always positive. The logarithm of a positive continuous function is continuous, so f is continuous on [1, 6].' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = |x - 4|/(x - 4)', false, 'The function is undefined at x = 4, which lies in [1, 6].' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = sqrt(5 - x)', false, 'The square root is undefined for x > 5, so f is not defined on (5, 6].' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = 1/(x^2 - 7x + 10)', false, 'Since x^2 - 7x + 10 = (x - 2)(x - 5), the denominator is 0 at x = 2 and x = 5, both in [1, 6].' from version_ins
;
-- MCQ variant 017-v3 of 017 | hard | Continuity on [0, 4] of a Tangent Model
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-017-v3', 'mcq', 'Continuity on [0, 4] of a Tangent Model', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An oscillating gauge reading must be defined and continuous at every time from 0 to 4 seconds, inclusive. Which of the following functions is continuous on the closed interval [0, 4]?', md5('apcalcab-mcq-u1v-017-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = tan(pi x/10)', true, 'The tangent function is undefined only where its argument is pi/2 plus a multiple of pi. Here that happens at x = 5 + 10k for every integer k, and the nearest such x-values are x = 5 and x = -5, both outside [0, 4], so f is continuous on the whole interval.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = ln(2x - 3)', false, 'The logarithm requires 2x - 3 > 0, so x > 3/2. f is not defined on [0, 3/2].' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = tan(pi x/6)', false, 'The argument pi x/6 equals pi/2 at x = 3, which lies in [0, 4], so f is undefined there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = (x^2 - 3x)/(x - 3)', false, 'This simplifies to x for x != 3, but the original expression is undefined at x = 3, which lies in [0, 4]. Simplifying does not make f defined there.' from version_ins
;
-- MCQ variant 018-v1 of 018 | easy | Filling a Gap in a Cost Ratio With a Sum of Cubes
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-018-v1', 'mcq', 'Filling a Gap in a Cost Ratio With a Sum of Cubes', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An engineer models a cost ratio by g(x) = (x^3 + 125)/(x + 5) for x != -5, and sets g(-5) = k. For what value of k is g continuous at x = -5?', md5('apcalcab-mcq-u1v-018-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'No such value of k exists.', false, 'The denominator is 0 at x = -5, but the factor x + 5 cancels. The limit exists, so a value of k that matches it does exist.' from version_ins
union all select gen_random_uuid(), id, 'B', '75', true, 'The sum of cubes factors as x^3 + 125 = (x + 5)(x^2 - 5x + 25), so g(x) = x^2 - 5x + 25 for x != -5. The limit as x approaches -5 is 25 + 25 + 25 = 75, and continuity requires k to equal it.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'Substituting x = -5 gives 0 in the numerator, but the denominator is also 0. The form 0/0 is indeterminate, so the limit must be found by simplifying first.' from version_ins
union all select gen_random_uuid(), id, 'D', '25', false, 'This factors the sum of cubes with the wrong sign, as (x + 5)(x^2 + 5x + 25). At x = -5 that gives 25 - 25 + 25 = 25, but the correct middle term is -5x.' from version_ins
;
-- MCQ variant 018-v2 of 018 | easy | Filling a Gap in a Scaled Volume Ratio
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-018-v2', 'mcq', 'Filling a Gap in a Scaled Volume Ratio', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scaling model for a cube of side s uses the ratio V(s) = (8s^3 - 1)/(2s - 1) for s != 1/2, and defines V(1/2) = m. For what value of m is V continuous at s = 1/2?', md5('apcalcab-mcq-u1v-018-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'Substituting s = 1/2 gives 0 in the numerator, but the denominator is also 0. The form 0/0 is indeterminate, so the limit must be found by simplifying first.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This rewrites the denominator as 2(s - 1/2) and cancels only the factor s - 1/2, forgetting that the leftover 2 divides the result. The quotient is exactly 4s^2 + 2s + 1, which approaches 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This factors 8s^3 - 1 as (2s - 1)(4s^2 + 1), dropping the middle term. Expanding that product gives 8s^3 - 4s^2 + 2s - 1, not 8s^3 - 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'The difference of cubes 8s^3 - 1 = (2s)^3 - 1 factors as (2s - 1)(4s^2 + 2s + 1), so V(s) = 4s^2 + 2s + 1 for s != 1/2. The limit at s = 1/2 is 1 + 1 + 1 = 3, and continuity requires m to equal it.' from version_ins
;
-- MCQ variant 018-v3 of 018 | easy | Filling a Gap in a Reversed-Order Difference Quotient
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-018-v3', 'mcq', 'Filling a Gap in a Reversed-Order Difference Quotient', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The rate constant of a reaction is modeled by k(y) = (64 - y^3)/(4 - y) for y != 4, and k(4) = r. For what value of r is k continuous at y = 4?', md5('apcalcab-mcq-u1v-018-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '48', true, 'The difference of cubes factors as 64 - y^3 = (4 - y)(16 + 4y + y^2), so k(y) = y^2 + 4y + 16 for y != 4. The limit at y = 4 is 16 + 16 + 16 = 48, and continuity requires r to equal it.' from version_ins
union all select gen_random_uuid(), id, 'B', '-48', false, 'This flips the sign, as if the denominator were y - 4 instead of 4 - y. The factor 4 - y appears in both the numerator''s factorization and the denominator, so it cancels with no sign change and the limit is +48.' from version_ins
union all select gen_random_uuid(), id, 'C', '32', false, 'This factors 64 - y^3 as (4 - y)(16 + y^2), dropping the middle term 4y. Expanding that product gives 64 - 16y + 4y^2 - y^3, not 64 - y^3.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'Substituting y = 4 gives 0 in the numerator, but the denominator is also 0. The form 0/0 is indeterminate, so the limit must be found by simplifying first.' from version_ins
;
-- MCQ variant 019-v1 of 019 | medium | Removing a Gap With a Radical in the Denominator
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-019-v1', 'mcq', 'Removing a Gap With a Radical in the Denominator', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A power-output model is p(x) = (x - 4)/(sqrt(x) - 2) for x != 4, and p(4) = m. For what value of m is p continuous at x = 4?', md5('apcalcab-mcq-u1v-019-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The numerator 4 - 4 equals 0, but the denominator sqrt(4) - 2 is also 0. The quotient is 0/0, which is indeterminate, so the limit has to be found by simplifying first, for example by rationalizing with the conjugate.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This reduces the expression to sqrt(x) by dropping the +2 from sqrt(x) + 2, giving sqrt(4) = 2. Since the conjugate factor is sqrt(x) + 2, its value at 4 is 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', true, 'Multiplying the numerator and denominator by the conjugate sqrt(x) + 2 gives (x - 4)(sqrt(x) + 2)/(x - 4) = sqrt(x) + 2 for x != 4. As x approaches 4 this approaches 2 + 2 = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/4', false, 'This inverts the result. After multiplying by the conjugate the expression is sqrt(x) + 2, not 1/(sqrt(x) + 2), and it approaches 4.' from version_ins
;

commit;
