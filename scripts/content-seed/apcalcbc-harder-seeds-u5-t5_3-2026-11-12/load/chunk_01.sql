begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b10-h-5.3-a','apcalcbc-mcq-b10-sv-h-5.3-a-v1','apcalcbc-mcq-b10-sv-h-5.3-a-v2','apcalcbc-mcq-b10-sv-h-5.3-a-v3','apcalcbc-mcq-b10-h-5.3-b','apcalcbc-mcq-b10-sv-h-5.3-b-v1','apcalcbc-mcq-b10-sv-h-5.3-b-v2','apcalcbc-mcq-b10-sv-h-5.3-b-v3','apcalcbc-mcq-b10-h-5.3-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b10-h-5.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b10-h-5.3-a', 'mcq', 'factor derivative and determine intervals', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has f''(x)=(x+2)(x-1) on (-4,4). On which intervals is f increasing, and why?', null, md5('apcalcbc-mcq-b10-h-5.3-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f increases only on (-2,1), where the two factors have opposite signs.', false, 'Opposite factor signs make f'' negative between the roots, so f decreases there.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f increases on (-4,-2) and (1,4), where both derivative factors have the same sign.', true, 'Correct: The product is positive for x<-2 and x>1, negative between the roots, and zero only at the roots. f increases where f''>0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f increases on all of (-4,4) because f'' has two zeros.', false, 'Zeros split the domain into sign intervals; they do not make f positive everywhere.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f increases only at x=-2 and x=1 because f''=0 there.', false, 'At the two isolated zeros the instantaneous slope is zero; intervals of increase come from positive derivative signs.' from version_ins;
-- apcalcbc-mcq-b10-sv-h-5.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b10-sv-h-5.3-a-v1', 'mcq', 'factor derivative and determine intervals (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose g''(x)=-(x+3)(x-2) for every x in (-5,4). Which description of g is supported?', null, md5('apcalcbc-mcq-b10-sv-h-5.3-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g decreases on (-3,2) because the two factors have opposite signs there.', false, 'The leading minus sign reverses the sign of the negative product between roots.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g increases on both outer intervals because a quadratic derivative is positive for large |x|.', false, 'The leading minus sign makes the derivative negative outside the roots in this case.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is constant on (-3,2) because g'' vanishes at the interval''s ends.', false, 'The derivative vanishes only at two points, not throughout the open interval between them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g increases on (-3,2) and decreases on (-5,-3) and (2,4).', true, 'Correct: Inside (-3,2) the product (x+3)(x-2) is negative, so its negative is positive. On either outer interval the product is positive and g'' negative.' from version_ins;
-- apcalcbc-mcq-b10-sv-h-5.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b10-sv-h-5.3-a-v2', 'mcq', 'factor derivative and determine intervals (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable h has h''(x)=x(x-2)(x+1) on (-3,3). Which intervals of increase follow from a sign analysis?', null, md5('apcalcbc-mcq-b10-sv-h-5.3-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h increases on (-1,0) and (2,3), where the three-factor product is positive.', true, 'Correct: Across roots -1,0,2, the cubic derivative signs are negative, positive, negative, positive. Positive signs give (-1,0) and (2,3).' from version_ins
union all select gen_random_uuid(), id, 'B', 'h increases on (-3,-1) and (0,2), where the product is negative.', false, 'A negative derivative means h decreases on those two intervals, not increases.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h increases on all intervals because h'' has three real zeros.', false, 'Roots identify sign boundaries; the derivative is negative on two of the four intervals.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h increases only at x=-1, 0, and 2.', false, 'A derivative equal to zero at isolated points does not define an increasing interval.' from version_ins;
-- apcalcbc-mcq-b10-sv-h-5.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b10-sv-h-5.3-a-v3', 'mcq', 'factor derivative and determine intervals (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable p satisfies p''(x)=(x-1)²(x+2) on (-4,4). Where does p decrease?', null, md5('apcalcbc-mcq-b10-sv-h-5.3-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'p decreases on (-4,-2) and (1,4), since every derivative zero flips its sign.', false, 'An even-multiplicity zero at 1 does not switch derivative sign.' from version_ins
union all select gen_random_uuid(), id, 'B', 'p decreases on (-2,1), because x+2 is positive there.', false, 'Both x+2 and the squared factor are positive on (-2,1), so p increases there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'p decreases on (-4,-2); the squared factor does not reverse the derivative''s sign at x=1.', true, 'Correct: (x-1)² is nonnegative and positive away from 1, so the sign comes from x+2. It is negative only for x<-2; the zero at 1 does not change sign.' from version_ins
union all select gen_random_uuid(), id, 'D', 'p never decreases, because a squared factor makes p'' nonnegative everywhere.', false, 'The other factor x+2 is negative to the left of -2, making p'' negative there.' from version_ins;
-- apcalcbc-mcq-b10-h-5.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b10-h-5.3-b', 'mcq', 'read derivative sign representation', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A graph of f'' lies above the x-axis on (-3,-1), below it on (-1,2), and above it on (2,4), crossing at -1 and 2. A student says f is negative on (-1,2). What is the justified conclusion?', null, md5('apcalcbc-mcq-b10-h-5.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is negative on (-1,2) because its derivative graph is below the axis.', false, 'A negative derivative means negative slope, not necessarily negative function values.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f decreases on (-1,2); the sign of f'' gives direction, but it does not determine whether f itself is positive or negative there.', true, 'Correct: f''<0 throughout (-1,2), so f decreases. Derivative sign alone cannot determine the vertical position or sign of f.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f increases on (-1,2) because the graph of f'' may be rising there.', false, 'Whether f'' itself rises does not change its negative sign on the stated interval.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is constant on (-1,2) because f'' equals zero at both ends.', false, 'Zero derivative at isolated boundaries does not make f constant across the interval.' from version_ins;
-- apcalcbc-mcq-b10-sv-h-5.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b10-sv-h-5.3-b-v1', 'mcq', 'read derivative sign representation (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The derivative of a differentiable g is negative on (0,2) and positive on (2,5), with g(2)=7. Which comparison is certain?', null, md5('apcalcbc-mcq-b10-sv-h-5.3-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(1)>7 and g(4)>7; g decreases toward x=2 then increases away from it, but g(1) versus g(4) is undetermined.', true, 'Correct: As x increases from 1 to 2, g falls to 7, so g(1)>7. As x increases from 2 to 4, g rises from 7, so g(4)>7. Their relative heights need rate magnitudes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(1)<7 and g(4)<7 because g'' changes sign at 2.', false, 'Both side values exceed the local minimum g(2)=7, not fall below it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(1)>g(4) because the negative derivative on (0,2) controls the whole interval.', false, 'Derivative signs establish each comparison to g(2), but not between g(1) and g(4).' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(1)=g(4) because the intervals lie on opposite sides of x=2.', false, 'Opposite sides of a minimum need not have equal function values without symmetry or rate information.' from version_ins;
-- apcalcbc-mcq-b10-sv-h-5.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b10-sv-h-5.3-b-v2', 'mcq', 'read derivative sign representation (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function h has h''(x)>0 on (-4,0) and h''(x)<0 on (0,3). Which statement about h(-2), h(0), and h(2) must hold?', null, md5('apcalcbc-mcq-b10-sv-h-5.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h(-2)<h(2)<h(0) must hold because -2<2.', false, 'X-order alone cannot compare values across two intervals with opposite derivative signs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h(-2)<h(0) and h(2)<h(0); the chart does not order h(-2) against h(2).', true, 'Correct: A positive derivative up to 0 raises h from -2 to 0, and a negative derivative afterward lowers it from 0 to 2. The two side values can differ either way.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h(-2)>h(0)>h(2) because a positive derivative makes earlier values larger.', false, 'A positive derivative makes later values greater on (-4,0), not earlier ones.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h(-2)=h(2) because the derivative signs switch at 0.', false, 'A sign change at 0 establishes a peak, not symmetry of the two side values.' from version_ins;
-- apcalcbc-mcq-b10-sv-h-5.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b10-sv-h-5.3-b-v3', 'mcq', 'read derivative sign representation (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A graph shows q'' positive for 1<x<3, zero at x=3, and negative for 3<x<6. A student concludes q is increasing on (1,6) because q''(3)=0. What correction is valid?', null, md5('apcalcbc-mcq-b10-sv-h-5.3-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'q increases on (1,3) and decreases on (3,6); one zero does not override the derivative signs on either side.', true, 'Correct: The sign of q'' is positive before 3 and negative afterward. Those signs determine the two monotonic intervals independently of the isolated zero.' from version_ins
union all select gen_random_uuid(), id, 'B', 'q increases on all of (1,6) because a derivative can be zero at one point.', false, 'A zero derivative at one point does not erase a negative derivative on the entire right interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'q decreases on (1,3) because q'' is above the axis there.', false, 'A derivative graph above zero means q has positive slope and increases to the left of 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Nothing can be inferred about monotonicity unless q values are also given.', false, 'Derivative signs are sufficient to establish monotonic intervals when differentiability is given.' from version_ins;
-- apcalcbc-mcq-b10-h-5.3-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b10-h-5.3-c', 'mcq', 'handle derivative sign across domain gaps', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is differentiable wherever x≠2 and satisfies f''(x)=(x+1)/(x-2). Its domain includes both sides of x=2 but excludes x=2. Which monotonic intervals follow?', null, md5('apcalcbc-mcq-b10-h-5.3-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f increases on (-1,2) because the numerator is positive there.', false, 'The denominator is negative on (-1,2), making the positive numerator produce a negative derivative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f increases on (-infinity,-1) and (-1,infinity) because only the zero at -1 matters.', false, 'The denominator changes sign at the excluded point 2, so the sign chart must split there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f increases on (-infinity,-1) and (2,infinity), and decreases on (-1,2); the domain gap separates the last two intervals.', true, 'Correct: The ratio signs across -1 and 2 are positive, negative, positive. x=2 is outside the domain, so monotonic intervals cannot be joined through it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f decreases on both sides of x=2 because the denominator is zero there.', false, 'A derivative undefined at one point does not force the same sign on both neighboring intervals.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b10-h-5.3-a','apcalcbc-mcq-b10-sv-h-5.3-a-v1','apcalcbc-mcq-b10-sv-h-5.3-a-v2','apcalcbc-mcq-b10-sv-h-5.3-a-v3','apcalcbc-mcq-b10-h-5.3-b','apcalcbc-mcq-b10-sv-h-5.3-b-v1','apcalcbc-mcq-b10-sv-h-5.3-b-v2','apcalcbc-mcq-b10-sv-h-5.3-b-v3','apcalcbc-mcq-b10-h-5.3-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b10-h-5.3-a','apcalcbc-mcq-b10-sv-h-5.3-a-v1','apcalcbc-mcq-b10-sv-h-5.3-a-v2','apcalcbc-mcq-b10-sv-h-5.3-a-v3','apcalcbc-mcq-b10-h-5.3-b','apcalcbc-mcq-b10-sv-h-5.3-b-v1','apcalcbc-mcq-b10-sv-h-5.3-b-v2','apcalcbc-mcq-b10-sv-h-5.3-b-v3','apcalcbc-mcq-b10-h-5.3-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
