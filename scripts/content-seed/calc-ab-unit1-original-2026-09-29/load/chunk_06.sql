begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-mcq-u1v-007-v3','apcalcab-mcq-u1v-008-v1','apcalcab-mcq-u1v-008-v2','apcalcab-mcq-u1v-008-v3','apcalcab-mcq-u1v-009-v1','apcalcab-mcq-u1v-009-v2','apcalcab-mcq-u1v-009-v3','apcalcab-mcq-u1v-010-v1','apcalcab-mcq-u1v-010-v2','apcalcab-mcq-u1v-010-v3','apcalcab-mcq-u1v-011-v1','apcalcab-mcq-u1v-011-v2'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- MCQ variant 007-v3 of 007 | medium | Choosing Functions With a Given Ratio Limit
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-007-v3', 'mcq', 'Choosing Functions With a Given Ratio Limit', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In each option, both f and g approach 0 as x approaches 2. For which pair does lim(x->2) f(x)/g(x) equal 3?', md5('apcalcab-mcq-u1v-007-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = 6(x - 2)^2 and g(x) = 2(x - 2)^2', true, 'The factors of (x - 2)^2 cancel for x != 2, leaving 6/2 = 3. Both functions approach 0, but their ratio approaches 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = 3(x - 2) and g(x) = (x - 2)^2', false, 'The quotient simplifies to 3/(x - 2), which grows without bound in magnitude near 2 and has different signs on the two sides, so the limit does not exist. The coefficient 3 is not the limit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = x - 2 and g(x) = 3(x - 2)', false, 'The quotient simplifies to 1/3, which is the inverse of the intended ratio. The limit is 1/3, not 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = (x - 2)^3 and g(x) = 3(x - 2)^2', false, 'The quotient simplifies to (x - 2)/3, which approaches 0. Having a 3 in the expression does not make the ratio''s limit 3.' from version_ins
;
-- MCQ variant 008-v1 of 008 | easy | Which Plug-In Gives the Real Limit
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-008-v1', 'mcq', 'Which Plug-In Gives the Real Limit', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A lab technician tries to evaluate four limits by simply plugging in the target input. For which one does plugging in actually give the value of the limit?', md5('apcalcab-mcq-u1v-008-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(t->1) (ln(t) + 5)/(t^2 + 1)', true, 'Substituting t = 1 gives (0 + 5)/(1 + 1) = 5/2. Every piece is defined at t = 1 and the denominator is nonzero, so direct substitution gives the limit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(t->0) 4t/sin(t)', false, 'Substituting t = 0 gives 0/0. The value 4 comes from the special limit sin(t)/t = 1, not from plugging in.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(t->5) (sqrt(t + 4) - 3)/(t - 5)', false, 'Substituting t = 5 gives 0/0. The expression is most directly handled by rationalizing with the conjugate sqrt(t + 4) + 3, since substitution alone does not give the limit.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(t->-2) (t^2 - 4)/(t + 2)^2', false, 'Substituting t = -2 gives 0/0. Cancelling one factor of t + 2 leaves (t - 2)/(t + 2), which is unbounded near -2, so substitution does not give the limit.' from version_ins
;
-- MCQ variant 008-v2 of 008 | easy | Spotting the Substitution-Friendly Limit
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-008-v2', 'mcq', 'Spotting the Substitution-Friendly Limit', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student wants to evaluate each limit below. For which one does plugging in the x-value directly give the limit?', md5('apcalcab-mcq-u1v-008-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x->2) |x - 2|/(x - 2)', false, 'Substituting x = 2 gives 0/0, and the one-sided limits are 1 from the right and -1 from the left, so the limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x->-1) (x^3 + 2x)/(x^2 + 4)', true, 'Substituting x = -1 gives (-1 - 2)/(1 + 4) = -3/5. The denominator is nonzero at x = -1, so direct substitution gives the limit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x->-3) (x^2 + 2x - 3)/(x + 3)', false, 'Substituting x = -3 gives 0/0. The numerator must be factored as (x + 3)(x - 1) and the common factor cancelled first.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x->1) (1/x - 1)/(x - 1)', false, 'Substituting x = 1 gives 0/0. The complex fraction must be simplified first, for example 1/x - 1 = (1 - x)/x.' from version_ins
;
-- MCQ variant 008-v3 of 008 | easy | Substitution Versus Simplifying First
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-008-v3', 'mcq', 'Substitution Versus Simplifying First', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following limits equals the value obtained by substituting the x-value into the expression?', md5('apcalcab-mcq-u1v-008-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x->1/2) (2x - 1)/(4x^2 - 1)', false, 'Substituting x = 1/2 gives 0/0. The denominator must be factored as (2x - 1)(2x + 1) and the common factor cancelled first.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x->-2) (x^4 - 16)/(x + 2)', false, 'Substituting x = -2 gives 0/0. The numerator must be factored, for example x^4 - 16 = (x + 2)(x - 2)(x^2 + 4), before cancelling.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x->0) (1 - cos(x))/x', false, 'Substituting x = 0 gives 0/0. This requires the special limit of (1 - cos x)/x, not substitution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x->5) (x^2 - 3x)/(2x - 9)', true, 'Substituting x = 5 gives (25 - 15)/(10 - 9) = 10. The denominator is nonzero at x = 5, so direct substitution gives the limit.' from version_ins
;
-- MCQ variant 009-v1 of 009 | medium | Low-Frequency Filter Response Near Zero
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-009-v1', 'mcq', 'Low-Frequency Filter Response Near Zero', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A filter''s normalized response to a small input of size x is modeled by G(x) = sin(8x)/(6x). What value does G(x) approach as x approaches 0?', md5('apcalcab-mcq-u1v-009-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', false, 'This treats sin(8x)/(6x) as if the denominator were just x, dropping the factor 6. That gives sin(8x)/x, whose limit is 8, but the actual denominator is 6x.' from version_ins
union all select gen_random_uuid(), id, 'B', '4/3', true, 'Write sin(8x)/(6x) as (8/6) * sin(8x)/(8x) = (4/3) * sin(8x)/(8x). As x approaches 0, sin(8x)/(8x) approaches 1, so G approaches 4/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', false, 'The special limit sin(u)/u = 1 needs the same expression in the argument and the denominator. Here they are 8x and 6x, so constants remain.' from version_ins
union all select gen_random_uuid(), id, 'D', '3/4', false, 'This inverts the factor. Since sin(8x) behaves like 8x near 0, the ratio behaves like 8x/(6x) = 4/3, not 3/4.' from version_ins
;
-- MCQ variant 009-v2 of 009 | medium | Small-Angle Ratio With a Tangent
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-009-v2', 'mcq', 'Small-Angle Ratio With a Tangent', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a small-angle model of a swinging arm, the ratio R(x) = 5x/tan(2x) compares a scaled angle to the tangent of twice the angle, where x is measured in radians. What is lim(x->0) R(x)?', md5('apcalcab-mcq-u1v-009-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'Both 5x and tan(2x) approach 0, giving 0/0, which is not automatically 0. The ratio behaves like 5x/(2x) = 5/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/2', true, 'Write 5x/tan(2x) as 5x cos(2x)/sin(2x) = (5/2) * cos(2x) * (2x)/sin(2x). As x approaches 0, cos(2x) approaches 1 and (2x)/sin(2x) approaches 1, so the limit is 5/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This treats tan(2x) as if it behaved like x, ignoring the 2 in the argument. It behaves like 2x, so the ratio behaves like 5x/(2x) = 5/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/5', false, 'This inverts the factor. Since tan(2x) behaves like 2x near 0, the ratio behaves like 5x/(2x) = 5/2, not 2/5.' from version_ins
;
-- MCQ variant 009-v3 of 009 | medium | Ratio of Two Sines Near Zero
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-009-v3', 'mcq', 'Ratio of Two Sines Near Zero', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two waves have amplitudes proportional to sin(2x) and sin(7x). What is lim(x->0) sin(2x)/sin(7x)?', md5('apcalcab-mcq-u1v-009-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'The special limit sin(u)/u = 1 needs the same expression in the numerator''s argument and the denominator. Here the arguments 2x and 7x differ, so factors remain.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'Both sines approach 0, giving 0/0, which is not automatically 0. The ratio behaves like 2x/(7x) = 2/7.' from version_ins
union all select gen_random_uuid(), id, 'C', '7/2', false, 'This inverts the ratio. Since sin(2x) behaves like 2x and sin(7x) like 7x, the quotient behaves like 2x/(7x) = 2/7.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/7', true, 'Write sin(2x)/sin(7x) as (2x/7x) * [sin(2x)/(2x)] / [sin(7x)/(7x)]. Both bracketed ratios approach 1, so the limit is 2/7.' from version_ins
;
-- MCQ variant 010-v1 of 010 | easy | Squeezing a Measurement Between Bounds
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-010-v1', 'mcq', 'Squeezing a Measurement Between Bounds', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quantity f satisfies 9 - 5(x - 2)^2 <= f(x) <= 9 + 4|x - 2| for all x. What is lim(x->2) f(x)?', md5('apcalcab-mcq-u1v-010-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9', true, 'Both bounding functions approach 9 as x approaches 2. Since f is between them, the Squeeze Theorem gives lim f(x) = 9.' from version_ins
union all select gen_random_uuid(), id, 'B', '18', false, 'This adds the two bounding limits, 9 + 9. The Squeeze Theorem says f has the same limit as the bounds, not their sum.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'The terms 5(x - 2)^2 and 4|x - 2| approach 0, but the bounds are 9 - 5(x - 2)^2 and 9 + 4|x - 2|, and those approach 9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It cannot be determined because the two bounds are different functions.', false, 'The bounds do not need to be the same function. The Squeeze Theorem applies because both bounds have the same limit, 9, as x approaches 2.' from version_ins
;
-- MCQ variant 010-v2 of 010 | easy | Squeeze From an Absolute-Value Inequality
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-010-v2', 'mcq', 'Squeeze From an Absolute-Value Inequality', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function g satisfies |g(x) - 5| <= 4(x - 1)^2 for all x. What is lim(x->1) g(x)?', md5('apcalcab-mcq-u1v-010-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The bound 4(x - 1)^2 approaches 0, but it is only an upper bound on how far g is from 5 (on |g(x) - 5|), not the value of g. The bounds on g itself are 5 - 4(x - 1)^2 and 5 + 4(x - 1)^2.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This reads the coefficient 4 in the bound as the limit. The bound controls the distance |g(x) - 5|, which shrinks to 0, so g approaches 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', true, 'The inequality means 5 - 4(x - 1)^2 <= g(x) <= 5 + 4(x - 1)^2. Both bounds approach 5 as x approaches 1, so the Squeeze Theorem gives lim g(x) = 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It cannot be determined because g is not given by a formula.', false, 'A formula for g is not needed. Its bounds 5 - 4(x - 1)^2 and 5 + 4(x - 1)^2 have the same limit, 5, so the Squeeze Theorem applies.' from version_ins
;
-- MCQ variant 010-v3 of 010 | easy | Bounded Oscillation Times a Vanishing Factor
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-010-v3', 'mcq', 'Bounded Oscillation Times a Vanishing Factor', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x != 0, -1 <= sin(1/x) <= 1. What is lim(x->0) x^2 sin(1/x)?', md5('apcalcab-mcq-u1v-010-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', true, 'Multiplying by x^2 >= 0 gives -x^2 <= x^2 sin(1/x) <= x^2. Both bounds approach 0 as x approaches 0, so the Squeeze Theorem gives a limit of 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This takes the bound 1 on sin(1/x) as if it were the limit of the whole product and ignores the factor x^2. The bound that matters is x^2: the product lies between -x^2 and x^2, and x^2 shrinks to 0, which forces the product to 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist because sin(1/x) oscillates.', false, 'sin(1/x) alone has no limit at 0, but the product does. The bounds -x^2 and x^2 both approach 0, and the product is squeezed between them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'infinity', false, 'This lets 1/x grow without bound and assumes the product does too. The sine keeps the second factor between -1 and 1, while x^2 approaches 0, so the product approaches 0.' from version_ins
;
-- MCQ variant 011-v1 of 011 | medium | Enzyme Rate Model at a Reference Time
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-011-v1', 'mcq', 'Enzyme Rate Model at a Reference Time', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The reaction rate r(t), in millimoles per second, of an enzyme at time t minutes is modeled by r(t) = (2t^2 - 7t - 4)/(t - 4) for t != 4, and a lab instrument records r(4) = 3. Consider the following statements.

I. lim(t->4) r(t) exists.
II. r is continuous at t = 4.
III. r has a removable discontinuity at t = 4.

Which of the statements are true?', md5('apcalcab-mcq-u1v-011-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'II and III only', false, 'Statement II is false because r(4) = 3 does not equal the limit 9, and statement I is true because the one-sided limits are both 9.' from version_ins
union all select gen_random_uuid(), id, 'B', 'I only', false, 'Statement I is true, but III is also true. A discontinuity at which the limit exists but differs from the function value is removable.' from version_ins
union all select gen_random_uuid(), id, 'C', 'I and III only', true, 'Since 2t^2 - 7t - 4 = (2t + 1)(t - 4), r(t) = 2t + 1 for t != 4, so the limit at 4 exists and equals 9 (I). The recorded value r(4) = 3 differs from 9, so r is not continuous (II is false). A discontinuity where the limit exists is removable (III).' from version_ins
union all select gen_random_uuid(), id, 'D', 'I and II only', false, 'Continuity requires r(4) to equal the limit. Here r(4) = 3 but the limit is 9, so r is not continuous at t = 4.' from version_ins
;
-- MCQ variant 011-v2 of 011 | medium | Shipping Fee at a Weight Threshold
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-011-v2', 'mcq', 'Shipping Fee at a Weight Threshold', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A carrier charges F(w) dollars to ship a package of w pounds, where F(w) = 3w + 2 for w < 5 and F(w) = 30 - 2w for w >= 5 (heavy-package rebate schedule). Consider the following statements.

I. lim(w->5) F(w) exists.
II. F is continuous at w = 5.
III. F has a jump discontinuity at w = 5.

Which of the statements are true?', md5('apcalcab-mcq-u1v-011-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'II only', false, 'F(5) = 20 does match the right-hand limit, but continuity needs the limit from both sides to equal F(5). The left-hand limit is 17.' from version_ins
union all select gen_random_uuid(), id, 'B', 'III only', true, 'From the left the fee approaches 3(5) + 2 = 17, and from the right it approaches 30 - 10 = 20. The one-sided limits are unequal, so the limit does not exist (I is false), F is not continuous (II is false), and the finite unequal one-sided limits make a jump discontinuity (III).' from version_ins
union all select gen_random_uuid(), id, 'C', 'I and III only', false, 'A jump discontinuity means the one-sided limits exist but are unequal, so the two-sided limit does not exist. Statement I is false.' from version_ins
union all select gen_random_uuid(), id, 'D', 'I and II only', false, 'The one-sided limits are 17 and 20, so the two-sided limit does not exist, and continuity (which requires the limit to exist) fails as well.' from version_ins
;

commit;
