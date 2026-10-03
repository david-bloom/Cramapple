begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-023-v2','apprecalc-mcq-sv-023-v3','apprecalc-mcq-sv-024-v1','apprecalc-mcq-sv-024-v2','apprecalc-mcq-sv-024-v3','apprecalc-mcq-sv-025-v1','apprecalc-mcq-sv-025-v2','apprecalc-mcq-sv-025-v3','apprecalc-mcq-sv-026-v1','apprecalc-mcq-sv-026-v2','apprecalc-mcq-sv-026-v3','apprecalc-mcq-sv-027-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-023-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-023-v2', 'mcq', 'End behavior of an odd-degree polynomial with a large even term', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

A polynomial function is given by m(x)=−9x⁴+2x⁷+x. Which description of its graph is correct?', null, md5('apprecalc-mcq-sv-023-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both ends of the graph fall', false, 'This takes −9x⁴ as the leading term because it has the largest coefficient in absolute value. The degree controls end behavior, and the highest degree is 7, from 2x⁷.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The graph falls to the right and rises to the left', false, 'Odd degree is recognized, but the sign is taken as negative (from the −9 in −9x⁴). The leading coefficient is +2, so the right end rises, not falls.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The graph rises to the right and falls to the left', true, 'The leading term is 2x⁷ (degree 7 is odd, coefficient 2 is positive), so m(x)→∞ as x→∞ and m(x)→−∞ as x→−∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both ends of the graph rise', false, 'The positive leading coefficient 2 is used, but the behavior of an even-degree polynomial is applied. The degree is 7 (odd), so the two ends go in opposite directions.' from version_ins;
-- apprecalc-mcq-sv-023-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-023-v3', 'mcq', 'End behavior from a factored polynomial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Which statement describes the end behavior of p(x)=−3(x−1)²(x+2)(x−4)?', null, md5('apprecalc-mcq-sv-023-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'p(x)→∞ at both ends', false, 'The even degree 4 is found, but the −3 is ignored. A negative leading coefficient makes both ends go down, not up.' from version_ins
union all select gen_random_uuid(), id, 'B', 'p(x)→−∞ as x→∞ and p(x)→∞ as x→−∞', false, 'Counts only the three distinct factors, getting degree 3 instead of 4, since (x−1) appears squared. With an odd degree and coefficient −3 the right end falls and the left end rises, but the true degree is even.' from version_ins
union all select gen_random_uuid(), id, 'C', 'p(x)→∞ as x→∞ and p(x)→−∞ as x→−∞', false, 'Counts three distinct factors for an odd degree of 3 and also ignores the −3. The true degree is 4 and the leading coefficient is −3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'p(x)→−∞ at both ends', true, 'Multiplying the factors gives degree 2+1+1=4 with leading coefficient −3, an even degree with a negative coefficient, so p(x)→−∞ as x→∞ and as x→−∞.' from version_ins;
-- apprecalc-mcq-sv-024-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-024-v1', 'mcq', 'Vertical asymptotes of a rational function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Let r(x)=(x−10)/(x²+3x−28). At which values of x does the graph of r have vertical asymptotes?', null, md5('apprecalc-mcq-sv-024-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=10 only', false, 'x=10 is the zero of the numerator, which gives an x-intercept of the graph, not a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=7 and x=−4', false, 'The denominator is factored as (x−7)(x+4), which expands to x²−3x−28, not x²+3x−28. The signs of the roots are reversed; the correct roots are −7 and 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=−7 and x=4', true, 'The denominator factors as (x+7)(x−4). Neither factor cancels the numerator x−10, so both x=−7 and x=4 are vertical asymptotes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=4 only', false, 'x=4 is a zero of the denominator, but x=−7 is also a zero of (x+7)(x−4) and does not cancel with the numerator, so it is a vertical asymptote too.' from version_ins;
-- apprecalc-mcq-sv-024-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-024-v2', 'mcq', 'Vertical asymptote versus hole', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

The function t(x)=(x+8)/(x²−x−72) is defined wherever its denominator is nonzero. Determine where its graph has vertical asymptotes.', null, md5('apprecalc-mcq-sv-024-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Only at x=−8', false, 'x=−8 is the zero shared by numerator and denominator, which produces a hole. The only noncanceled denominator zero is x=9.' from version_ins
union all select gen_random_uuid(), id, 'B', 'At x=8 and x=−9', false, 'The denominator is factored as (x−8)(x+9), which expands to x²+x−72, not x²−x−72. The signs of the roots are reversed, and the cancellation is also missed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only at x=9', true, 'The denominator factors as (x−9)(x+8), so t(x)=1/(x−9) for x≠−8. The factor x+8 cancels, so x=−8 is a hole and only x=9 is a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At x=−8 and x=9', false, 'Both denominator zeros are used without checking for cancellation. The factor x+8 appears in the numerator too, so x=−8 is a hole, not an asymptote.' from version_ins;
-- apprecalc-mcq-sv-024-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-024-v3', 'mcq', 'Vertical asymptotes with numerator factors', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

For the rational function w(x)=(x²−25)/(x²−x−56), which are the vertical asymptotes of its graph?', null, md5('apprecalc-mcq-sv-024-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=−8 and x=7', false, 'The denominator is factored as (x+8)(x−7), which expands to x²+x−56, not x²−x−56. The signs of the roots are reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=−5 and x=5', false, 'These are the zeros of the numerator x²−25, which are x-intercepts, not vertical asymptotes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=−7 and x=8', true, 'The denominator factors as (x−8)(x+7) and the numerator is (x−5)(x+5). No factors cancel, so the vertical asymptotes are x=−7 and x=8.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=8 only', false, 'x=8 is a zero of the denominator, but x=−7 also makes (x−8)(x+7) equal to 0 and nothing cancels it, so it is also a vertical asymptote.' from version_ins;
-- apprecalc-mcq-sv-025-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-025-v1', 'mcq', 'Hole from a removable factor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Consider g(x)=(x²−x−6)/(x−3), defined for x≠3. Which description of the graph of g is correct?', null, md5('apprecalc-mcq-sv-025-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is a hole at (3,5).', true, 'For x≠3, g(x)=(x−3)(x+2)/(x−3)=x+2. The factor x−3 cancels, and the missing point has y-value 3+2=5, so there is a hole at (3,5).' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is a hole at (3,0).', false, 'The hole''s x-coordinate 3 is right, but the y-value is found by evaluating the original numerator at 3 (9−3−6=0). It should be found from the simplified expression: 3+2=5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a hole at (−2,0).', false, 'x=−2 is the zero of the remaining factor x+2, which is an x-intercept. The hole is at the canceled factor, x=3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=3 is a vertical asymptote.', false, 'A vertical asymptote needs a noncanceled denominator zero. The factor x−3 cancels completely, so x=3 is a hole.' from version_ins;
-- apprecalc-mcq-sv-025-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-025-v2', 'mcq', 'Hole coordinates from a factorable numerator', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

A function is defined by k(x)=(2x²+x−3)/(x−1) for x≠1. Which is true of the graph of k at x=1?', null, md5('apprecalc-mcq-sv-025-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A hole at (−3/2,0)', false, 'x=−3/2 is the zero of the remaining factor 2x+3, which is an x-intercept. The hole is at the canceled factor x=1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A vertical asymptote', false, 'The factor x−1 cancels with the numerator, so x=1 is a hole, not a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A hole at (1,5)', true, 'The numerator factors as (2x+3)(x−1), so k(x)=2x+3 for x≠1. The y-value of the hole is 2(1)+3=5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A hole at (1,0)', false, 'The numerator evaluates to 2+1−3=0 at x=1, but that is the unsimplified 0/0 form. The hole''s y-value comes from the simplified function: 2(1)+3=5.' from version_ins;
-- apprecalc-mcq-sv-025-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-025-v3', 'mcq', 'Hole and asymptote in the same function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Let p(x)=(x−5)/(x²−25) for x≠5 and x≠−5. Which statement is true?', null, md5('apprecalc-mcq-sv-025-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The graph has a hole at (5,0) and a vertical asymptote at x=−5.', false, 'The hole''s location x=5 and the asymptote are right, but the y-value of the hole must come from the simplified function 1/(x+5), which gives 1/10 at x=5, not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The graph has holes at x=5 and x=−5 and no vertical asymptote.', false, 'Only the factor x−5 cancels. The factor x+5 remains in the denominator after simplifying, so x=−5 is a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The graph has a hole at (5,1/10) and a vertical asymptote at x=−5.', true, 'For x≠5, p(x)=(x−5)/((x−5)(x+5))=1/(x+5). The factor x−5 cancels, leaving a hole at x=5 with y=1/10, and x+5 stays in the denominator, giving a vertical asymptote at x=−5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The graph has vertical asymptotes at x=5 and x=−5 and no holes.', false, 'The factor x−5 cancels with the numerator, so x=5 is a hole. Only x=−5 is a vertical asymptote.' from version_ins;
-- apprecalc-mcq-sv-026-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-026-v1', 'mcq', 'Reading shifts and a vertical shrink', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

If g(x)=(1/2)f(x+4)−6, which transformation takes the graph of f to the graph of g?', null, md5('apprecalc-mcq-sv-026-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Left 4, vertical shrink by factor 1/2, down 6', true, 'x+4 inside f shifts left 4, the factor 1/2 outside shrinks vertically by 1/2, and −6 outside shifts down 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Left 6, vertical shrink by factor 1/2, down 4', false, 'This swaps the two shifts. The +4 inside f gives the horizontal shift (left 4) and the −6 outside gives the vertical shift (down 6).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Left 4, vertical stretch by factor 2, down 6', false, 'This uses the reciprocal of the multiplier. Multiplying outputs by 1/2 halves them, which is a shrink by 1/2, not a stretch by 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Right 4, vertical shrink by factor 1/2, down 6', false, 'This reverses the horizontal shift. Replacing x with x+4 moves the graph left 4, not right.' from version_ins;
-- apprecalc-mcq-sv-026-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-026-v2', 'mcq', 'Reflection across the y-axis with an outside multiplier', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Let g(x)=3f(−x)+2. Describe how the graph of f is changed to obtain the graph of g.', null, md5('apprecalc-mcq-sv-026-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Flip over the y-axis, triple every output, then move up 2', true, 'The −x inside f flips the graph over the y-axis, the factor 3 outside multiplies every output by 3 (a vertical stretch), and +2 outside shifts up 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Flip over the y-axis, divide every x-value by 3, then move up 2', false, 'The multiplier 3 is outside f, so it scales the outputs (vertical stretch by 3). Dividing x-values by 3 (a horizontal shrink by 1/3) would come from f(3x).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Flip over the x-axis, triple every output, then move up 2', false, 'The negative sign is inside f (f(−x)), which flips the graph over the y-axis. A flip over the x-axis would need a negative outside, as in −f(x).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Flip over the y-axis, triple every output, then move left 2', false, 'The +2 is added outside f, so it shifts the graph up 2. A shift left 2 would come from f(x+2).' from version_ins;
-- apprecalc-mcq-sv-026-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-026-v3', 'mcq', 'Horizontal compression requiring factoring', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

If g(x)=−f(2x−6), which transformation takes the graph of f to the graph of g?', null, md5('apprecalc-mcq-sv-026-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Reflect across the x-axis, horizontal shrink by factor 1/2, right 6', false, 'The shift is read directly from the −6 without factoring out the 2. Since 2x−6=2(x−3), the shift is right 3, not 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Reflect across the y-axis, horizontal shrink by factor 1/2, right 3', false, 'The negative sign is outside f, −f(…), which negates outputs and reflects across the x-axis. A reflection across the y-axis would need a negative inside the argument.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Reflect across the x-axis, horizontal stretch by factor 2, right 3', false, 'The inside factor 2 makes the graph reach each output at half the x-distance, which is a horizontal shrink by 1/2, not a stretch by 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Reflect across the x-axis, horizontal shrink by factor 1/2, right 3', true, 'Writing 2x−6=2(x−3) gives g(x)=−f(2(x−3)). The factor 2 compresses horizontally by 1/2, x−3 shifts right 3, and the outside negative reflects across the x-axis.' from version_ins;
-- apprecalc-mcq-sv-027-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-027-v1', 'mcq', 'Second differences identify a quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

For equally spaced inputs x=0, 1, 2, 3, 4, a table gives y=3, 4, 7, 12, 19. Which model type is most appropriate, and why?', null, md5('apprecalc-mcq-sv-027-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cubic, because the first differences are not constant', false, 'Nonconstant first differences only rule out a linear model. The second differences are already constant (2, 2, 2), which identifies a quadratic, not a cubic.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Linear, because the first differences (1, 3, 5, 7) increase by a steady amount', false, 'A linear model needs constant first differences. These differ (1, 3, 5, 7), so the model is not linear; the steady change in the first differences is what indicates a quadratic.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Exponential, because the outputs increase by a larger amount each step', false, 'An exponential model needs a constant ratio between consecutive outputs. Here the ratios are 4/3, 7/4, 12/7, 19/12, which are not equal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Quadratic, because the second differences are constant (all equal to 2)', true, 'The first differences are 1, 3, 5, 7 and the second differences are 2, 2, 2. Constant nonzero second differences indicate a quadratic model.' from version_ins;
commit;
