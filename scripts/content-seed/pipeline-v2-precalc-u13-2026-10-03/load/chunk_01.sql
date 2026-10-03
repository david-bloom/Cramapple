begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-001-v1','apprecalc-mcq-sv-001-v2','apprecalc-mcq-sv-001-v3','apprecalc-mcq-sv-002-v1','apprecalc-mcq-sv-002-v2','apprecalc-mcq-sv-002-v3','apprecalc-mcq-sv-003-v1','apprecalc-mcq-sv-003-v2','apprecalc-mcq-sv-003-v3','apprecalc-mcq-sv-004-v1','apprecalc-mcq-sv-004-v2','apprecalc-mcq-sv-004-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-001-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-001-v1', 'mcq', 'Average rate of change of a position function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a line with position s(t) = t³ − 2t meters at time t seconds. What is the average rate of change of s over the interval −1 ≤ t ≤ 2, in meters per second?', null, md5('apprecalc-mcq-sv-001-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '21', false, 'Evaluates the function at the length of the interval instead of forming the difference quotient: 2 − (−1) = 3, and s(3) = 27 − 6 = 21.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'Finds the change in output, s(2) − s(−1) = 4 − 1 = 3, and forgets to divide by the change in input, 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', true, 's(2) = 8 − 4 = 4 and s(−1) = −1 + 2 = 1, so the average rate of change is [s(2) − s(−1)]/(2 − (−1)) = (4 − 1)/3 = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1', false, 'Subtracts the outputs in the wrong order but divides by the interval length in the usual order: [s(−1) − s(2)]/(2 − (−1)) = (1 − 4)/3 = −1.' from version_ins;
-- apprecalc-mcq-sv-001-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-001-v2', 'mcq', 'Average rate of change from a table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The population N(t) of a town, in thousands, t years after 2000 is recorded in the table: N(0) = 10, N(2) = 18, N(4) = 29, N(6) = 42. What is the average rate of change of the population from t = 2 to t = 6, in thousands of people per year?', null, md5('apprecalc-mcq-sv-001-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', true, 'The average rate of change is [N(6) − N(2)]/(6 − 2) = (42 − 18)/4 = 24/4 = 6.' from version_ins
union all select gen_random_uuid(), id, 'B', '24', false, 'Computes only the change in output, 42 − 18 = 24, and does not divide by the 4-year change in input.' from version_ins
union all select gen_random_uuid(), id, 'C', '30', false, 'Averages the two endpoint values, (18 + 42)/2 = 30, instead of dividing the change in output by the change in input.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'Divides the change in output by the sum of the inputs instead of their difference: 24/(6 + 2) = 3.' from version_ins;
-- apprecalc-mcq-sv-001-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-001-v3', 'mcq', 'Average rate of change of a rational function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 6-mile trip takes r(x) = 6/x hours when driven at a constant speed of x miles per hour. What is the average rate of change of r as the speed x increases from 2 to 6 miles per hour, in hours per (mile per hour)?', null, md5('apprecalc-mcq-sv-001-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/2', false, 'Evaluates r at the change in input, 6 − 2 = 4: r(4) = 6/4 = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2', false, 'Finds the change in output, 1 − 3 = −2, and does not divide by the change in input, 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2', false, 'Subtracts the outputs in the wrong order, (r(2) − r(6)), giving (3 − 1)/(6 − 2) = 1/2 with the wrong sign.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/2', true, 'r(2) = 3 and r(6) = 1, so the average rate of change is (1 − 3)/(6 − 2) = −2/4 = −1/2.' from version_ins;
-- apprecalc-mcq-sv-002-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-002-v1', 'mcq', 'End behavior of an even-degree polynomial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement describes the end behavior of the polynomial function P(x) = 3x⁴ − 5x³ + x?', null, md5('apprecalc-mcq-sv-002-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The graph falls on the left and rises on the right', false, 'This is the pattern of an odd degree with a positive leading coefficient. The degree here is 4, which is even, so both ends point the same direction.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The graph rises on both the left and the right', true, 'The leading term 3x⁴ has even degree and a positive coefficient, so P(x) → ∞ as x → −∞ and as x → ∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The graph falls on both the left and the right', false, 'Treats the leading coefficient 3 as if it were negative; for an even degree this is the pattern of a negative leading coefficient, not 3x⁴.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The graph rises on the left and falls on the right', false, 'This is the pattern of an odd-degree polynomial with a negative leading coefficient; the degree here is 4 and the leading coefficient is positive.' from version_ins;
-- apprecalc-mcq-sv-002-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-002-v2', 'mcq', 'End behavior from a product of factors', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The polynomial function R(x) = (1 − x²)(x² + 4) is written as a product of two factors. Which statement describes its end behavior?', null, md5('apprecalc-mcq-sv-002-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The graph rises on the left and falls on the right', false, 'Describes an odd-degree polynomial with a negative leading coefficient (rises left, falls right). R has even degree 4, so both ends point the same direction, and the leading term is -x^4, so both ends fall.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The graph rises on both the left and the right', false, 'Reads the factor 1 − x² as if its leading term were +x², obtaining x²·x² = x⁴ with a positive coefficient; the leading term is actually −x².' from version_ins
union all select gen_random_uuid(), id, 'C', 'The graph falls on the left and rises on the right', false, 'Treats the function as odd-degree. Expanding gives R(x) = −x⁴ − 3x² + 4, whose degree is 4 (even), so the ends point the same direction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The graph falls on both the left and the right', true, 'Multiplying leading terms gives (−x²)(x²) = −x⁴, so R has even degree 4 and a negative leading coefficient (R(x) = −x⁴ − 3x² + 4); both ends fall.' from version_ins;
-- apprecalc-mcq-sv-002-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-002-v3', 'mcq', 'End behavior of an odd-degree polynomial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let S(x) = 4x⁷ − x⁶ + 9. Which statement correctly describes the behavior of the graph of S for inputs of very large magnitude?', null, md5('apprecalc-mcq-sv-002-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It falls on both the left and the right', false, 'Uses the second term, −x⁶ (even degree, negative coefficient), as the dominant term; the term with the highest degree is 4x⁷.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It rises on the left and falls on the right', false, 'Reverses the pattern, as would happen for a negative leading coefficient. The leading coefficient of 4x⁷ is positive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It falls on the left and rises on the right', true, 'The dominant term is 4x⁷, with odd degree and positive coefficient, so S(x) → −∞ as x → −∞ and S(x) → ∞ as x → ∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It rises on both the left and the right', false, 'Treats the degree 7 as even, as in a positive even-degree polynomial; but 4x⁷ is negative when x is a large negative number.' from version_ins;
-- apprecalc-mcq-sv-003-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-003-v1', 'mcq', 'Identify a hole in a rational function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement describes the discontinuity of the rational function R(x) = (x² − x − 12)/(x − 4)?', null, md5('apprecalc-mcq-sv-003-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A hole at (−3, 0)', false, 'Places the hole at the zero of the remaining factor x + 3. That gives the x-intercept; the hole is at the canceled factor''s zero, x = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A hole at (4, 7)', true, 'Factoring gives (x − 4)(x + 3)/(x − 4). The factor x − 4 cancels, leaving x + 3 for x ≠ 4, so the hole is at x = 4 with y = 4 + 3 = 7.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A vertical asymptote at x = 4', false, 'The factor x − 4 appears in both numerator and denominator and cancels, so the discontinuity is removable (a hole), not an asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A hole at (4, 0)', false, 'Substitutes x = 4 into the original numerator, 16 − 4 − 12 = 0, to get the y-coordinate; the y-coordinate of a hole comes from the simplified function x + 3, which gives 7.' from version_ins;
-- apprecalc-mcq-sv-003-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-003-v2', 'mcq', 'Hole and asymptote together', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement is true about the graph of g(x) = (x² − 4)/((x − 2)(x + 5))?', null, md5('apprecalc-mcq-sv-003-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It has a hole at (2, 0) and a vertical asymptote at x = −5', false, 'Gets the right locations but takes the y-coordinate from the original numerator, 2² − 4 = 0; the simplified function gives (2 + 2)/(2 + 5) = 4/7.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It has a vertical asymptote at x = 2 and a hole at x = −5', false, 'Reverses the roles: the factor x − 2 cancels, so x = 2 is the hole, while x + 5 stays in the denominator, so x = −5 is the asymptote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It has a hole at (2, 4/7) and a vertical asymptote at x = −5', true, 'Since x² − 4 = (x − 2)(x + 2), the factor x − 2 cancels, leaving (x + 2)/(x + 5) for x ≠ 2. The hole is at x = 2 with y = (2 + 2)/(2 + 5) = 4/7, and x = −5 remains a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It has vertical asymptotes at x = 2 and at x = −5', false, 'Treats every zero of the denominator as an asymptote without checking for cancelation; x − 2 cancels with the factor in x² − 4.' from version_ins;
-- apprecalc-mcq-sv-003-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-003-v3', 'mcq', 'Hole in a quotient with a cubic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function h(x) = (x³ − 8)/(x − 2) is not defined at x = 2. Which statement describes its graph near x = 2?', null, md5('apprecalc-mcq-sv-003-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A hole at (2, 12)', true, 'Since x³ − 8 = (x − 2)(x² + 2x + 4), h(x) = x² + 2x + 4 for x ≠ 2, and the hole is at (2, 4 + 4 + 4) = (2, 12).' from version_ins
union all select gen_random_uuid(), id, 'B', 'A hole at (2, 0)', false, 'Uses the numerator''s value at x = 2, 2³ − 8 = 0, as the y-coordinate; the y-coordinate comes from the simplified expression x² + 2x + 4, which equals 12 at x = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A vertical asymptote at x = 2', false, 'The factor x − 2 divides the numerator exactly, so it cancels and the discontinuity is removable rather than an asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A hole at (2, 4)', false, 'Divides only the leading term, x³ ÷ x = x², and discards the rest of the quotient, 2x + 4; then evaluates x² at 2 to get 4.' from version_ins;
-- apprecalc-mcq-sv-004-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-004-v1', 'mcq', 'Crossing versus touching from multiplicities', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The polynomial P(x) = (x + 2)³(x − 5)²(x − 1) has real zeros at −2, 5, and 1. At which of these zeros does the graph of P cross the x-axis rather than touch it and turn around?', null, md5('apprecalc-mcq-sv-004-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2, 5, and 1', false, 'Ignores multiplicity and assumes the graph crosses at every zero; at 5 (multiplicity 2) it touches and turns.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2 and 1 only', true, 'The zero −2 has multiplicity 3 (odd) and the zero 1 has multiplicity 1 (odd), so the graph crosses at both. The zero 5 has multiplicity 2 (even), so the graph touches and turns.' from version_ins
union all select gen_random_uuid(), id, 'C', '5 only', false, 'Reverses the parity rule: the zero 5 has even multiplicity 2, so the graph touches and turns there rather than crossing.' from version_ins
union all select gen_random_uuid(), id, 'D', '1 only', false, 'Counts only a multiplicity of exactly 1 as a crossing. Any odd multiplicity crosses, so the zero −2 (multiplicity 3) is also a crossing.' from version_ins;
-- apprecalc-mcq-sv-004-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-004-v2', 'mcq', 'Choose a polynomial from graph behavior', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial function touches the x-axis and turns at x = 3, crosses the x-axis at x = −2, and has no other x-intercepts. Which of the following could be its equation?', null, md5('apprecalc-mcq-sv-004-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P(x) = (x + 3)²(x − 2)', false, 'Writes the factors with the signs reversed, so the zeros are −3 and 2 instead of 3 and −2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P(x) = (x − 3)(x + 2)', false, 'Both zeros have multiplicity 1, so the graph crosses at both 3 and −2; it does not touch and turn at 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P(x) = (x − 3)(x + 2)²', false, 'Swaps the multiplicities: this graph crosses at 3 (multiplicity 1) and touches at −2 (multiplicity 2).' from version_ins
union all select gen_random_uuid(), id, 'D', 'P(x) = (x − 3)²(x + 2)', true, 'The factor (x − 3)² gives an even multiplicity at 3, so the graph touches and turns there; (x + 2) has multiplicity 1, so the graph crosses at −2.' from version_ins;
-- apprecalc-mcq-sv-004-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-004-v3', 'mcq', 'Least possible degree from behavior', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of a polynomial function touches the x-axis and turns at x = −1, and crosses the x-axis at x = 2 and at x = 4. What is the least possible degree of the polynomial?', null, md5('apprecalc-mcq-sv-004-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', true, 'The touch at −1 requires an even multiplicity, at least 2. Each crossing requires an odd multiplicity, at least 1. The least degree is 2 + 1 + 1 = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'Assigns the touching zero an odd multiplicity of 3, giving 3 + 1 + 1 = 5; a touch needs an even multiplicity, and the least even multiplicity is 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'Counts one for each of the three zeros, as if every zero had multiplicity 1; but a zero where the graph touches and turns needs an even multiplicity, at least 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'Gives every zero multiplicity 2: 2 + 2 + 2 = 6. A crossing needs an odd multiplicity, and 1 is the least.' from version_ins;
commit;
