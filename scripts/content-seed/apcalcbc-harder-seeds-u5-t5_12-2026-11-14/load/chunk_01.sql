begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b19-h-5.12-a','apcalcbc-mcq-b19-sv-h-5.12-a-v1','apcalcbc-mcq-b19-sv-h-5.12-a-v2','apcalcbc-mcq-b19-sv-h-5.12-a-v3','apcalcbc-mcq-b19-h-5.12-b','apcalcbc-mcq-b19-sv-h-5.12-b-v1','apcalcbc-mcq-b19-sv-h-5.12-b-v2','apcalcbc-mcq-b19-sv-h-5.12-b-v3','apcalcbc-mcq-b19-h-5.12-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b19-h-5.12-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b19-h-5.12-a', 'mcq', 'horizontal implicit critical points', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the implicit relation x²+xy+y²=3, find all points where its tangent is horizontal. Which reasoning confirms that the derivative is defined at those points?', null, md5('apcalcbc-mcq-b19-h-5.12-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(2,−1) and (−2,1); these make the numerator of y'' zero.', false, 'These are the vertical-tangent points where the denominator is zero, not horizontal tangents.' from version_ins
union all select gen_random_uuid(), id, 'B', '(1,−2) and (−1,2); y''=−(2x+y)/(x+2y), whose denominator is nonzero at both points.', true, 'Correct: Implicit differentiation gives y''=−(2x+y)/(x+2y). Horizontal tangents require y=−2x and x+2y≠0. Substitution gives 3x²=3, so x=±1 and y=∓2. The denominator equals −3x, nonzero at both points.' from version_ins
union all select gen_random_uuid(), id, 'C', '(1,2) and (−1,−2); these make the numerator of y'' zero.', false, 'The stated points do not satisfy the relation or the zero-numerator condition.' from version_ins
union all select gen_random_uuid(), id, 'D', '(1,−2) only; the negative-x point cannot have a horizontal tangent.', false, 'The equation has both signs of x, and the derivative denominator is nonzero at each resulting point.' from version_ins;
-- apcalcbc-mcq-b19-sv-h-5.12-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b19-sv-h-5.12-a-v1', 'mcq', 'horizontal implicit critical points (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the implicit relation x²+xy+y²=12, find all points where its tangent is horizontal. Which reasoning confirms that the derivative is defined at those points?', null, md5('apcalcbc-mcq-b19-sv-h-5.12-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(4,−2) and (−4,2); these make the numerator of y'' zero.', false, 'These are the vertical-tangent points where the denominator is zero, not horizontal tangents.' from version_ins
union all select gen_random_uuid(), id, 'B', '(2,4) and (−2,−4); these make the numerator of y'' zero.', false, 'The stated points do not satisfy the relation or the zero-numerator condition.' from version_ins
union all select gen_random_uuid(), id, 'C', '(2,−4) only; the negative-x point cannot have a horizontal tangent.', false, 'The equation has both signs of x, and the derivative denominator is nonzero at each resulting point.' from version_ins
union all select gen_random_uuid(), id, 'D', '(2,−4) and (−2,4); y''=−(2x+y)/(x+2y), whose denominator is nonzero at both points.', true, 'Correct: Implicit differentiation gives y''=−(2x+y)/(x+2y). Horizontal tangents require y=−2x and x+2y≠0. Substitution gives 3x²=12, so x=±2 and y=∓4. The denominator equals −3x, nonzero at both points.' from version_ins;
-- apcalcbc-mcq-b19-sv-h-5.12-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b19-sv-h-5.12-a-v2', 'mcq', 'horizontal implicit critical points (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the implicit relation x²+xy+y²=27, find all points where its tangent is horizontal. Which reasoning confirms that the derivative is defined at those points?', null, md5('apcalcbc-mcq-b19-sv-h-5.12-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(3,−6) and (−3,6); y''=−(2x+y)/(x+2y), whose denominator is nonzero at both points.', true, 'Correct: Implicit differentiation gives y''=−(2x+y)/(x+2y). Horizontal tangents require y=−2x and x+2y≠0. Substitution gives 3x²=27, so x=±3 and y=∓6. The denominator equals −3x, nonzero at both points.' from version_ins
union all select gen_random_uuid(), id, 'B', '(6,−3) and (−6,3); these make the numerator of y'' zero.', false, 'These are the vertical-tangent points where the denominator is zero, not horizontal tangents.' from version_ins
union all select gen_random_uuid(), id, 'C', '(3,6) and (−3,−6); these make the numerator of y'' zero.', false, 'The stated points do not satisfy the relation or the zero-numerator condition.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3,−6) only; the negative-x point cannot have a horizontal tangent.', false, 'The equation has both signs of x, and the derivative denominator is nonzero at each resulting point.' from version_ins;
-- apcalcbc-mcq-b19-sv-h-5.12-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b19-sv-h-5.12-a-v3', 'mcq', 'horizontal implicit critical points (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the implicit relation x²+xy+y²=48, find all points where its tangent is horizontal. Which reasoning confirms that the derivative is defined at those points?', null, md5('apcalcbc-mcq-b19-sv-h-5.12-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(8,−4) and (−8,4); these make the numerator of y'' zero.', false, 'These are the vertical-tangent points where the denominator is zero, not horizontal tangents.' from version_ins
union all select gen_random_uuid(), id, 'B', '(4,8) and (−4,−8); these make the numerator of y'' zero.', false, 'The stated points do not satisfy the relation or the zero-numerator condition.' from version_ins
union all select gen_random_uuid(), id, 'C', '(4,−8) and (−4,8); y''=−(2x+y)/(x+2y), whose denominator is nonzero at both points.', true, 'Correct: Implicit differentiation gives y''=−(2x+y)/(x+2y). Horizontal tangents require y=−2x and x+2y≠0. Substitution gives 3x²=48, so x=±4 and y=∓8. The denominator equals −3x, nonzero at both points.' from version_ins
union all select gen_random_uuid(), id, 'D', '(4,−8) only; the negative-x point cannot have a horizontal tangent.', false, 'The equation has both signs of x, and the derivative denominator is nonzero at each resulting point.' from version_ins;
-- apcalcbc-mcq-b19-h-5.12-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b19-h-5.12-b', 'mcq', 'circle second derivative and concavity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the upper branch of x²+y²=25, evaluate d²y/dx² at (3,4) and use its sign to describe the branch''s local concavity there.', null, md5('apcalcbc-mcq-b19-h-5.12-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd²y/dx²=+25/64; the upper branch is concave up.', false, 'The second derivative is negative on the upper half of the circle; this sign is reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd²y/dx²=−25/64; the upper branch is concave down.', true, 'Correct: From 2x+2yy''=0, y''=−x/y. Differentiating again gives 2+2(y'')²+2yy''''=0, hence y''''=−(x²+y²)/y³=−25/64 at (3,4). Because y>0, the branch is concave down.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd²y/dx²=−1/4; the upper branch is concave down.', false, 'Differentiating y'' requires the (y'')² term, which produces the circle-radius numerator rather than just 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'd²y/dx²=−3/4; the upper branch is concave down.', false, 'This is the first derivative y'', not the second derivative y''''.' from version_ins;
-- apcalcbc-mcq-b19-sv-h-5.12-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b19-sv-h-5.12-b-v1', 'mcq', 'circle second derivative and concavity (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the upper branch of x²+y²=169, evaluate d²y/dx² at (5,12) and use its sign to describe the branch''s local concavity there.', null, md5('apcalcbc-mcq-b19-sv-h-5.12-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd²y/dx²=−169/1728; the upper branch is concave down.', true, 'Correct: From 2x+2yy''=0, y''=−x/y. Differentiating again gives 2+2(y'')²+2yy''''=0, hence y''''=−(x²+y²)/y³=−169/1728 at (5,12). Because y>0, the branch is concave down.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd²y/dx²=+169/1728; the upper branch is concave up.', false, 'The second derivative is negative on the upper half of the circle; this sign is reversed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd²y/dx²=−1/12; the upper branch is concave down.', false, 'Differentiating y'' requires the (y'')² term, which produces the circle-radius numerator rather than just 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'd²y/dx²=−5/12; the upper branch is concave down.', false, 'This is the first derivative y'', not the second derivative y''''.' from version_ins;
-- apcalcbc-mcq-b19-sv-h-5.12-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b19-sv-h-5.12-b-v2', 'mcq', 'circle second derivative and concavity (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the upper branch of x²+y²=289, evaluate d²y/dx² at (8,15) and use its sign to describe the branch''s local concavity there.', null, md5('apcalcbc-mcq-b19-sv-h-5.12-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd²y/dx²=+289/3375; the upper branch is concave up.', false, 'The second derivative is negative on the upper half of the circle; this sign is reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd²y/dx²=−289/3375; the upper branch is concave down.', true, 'Correct: From 2x+2yy''=0, y''=−x/y. Differentiating again gives 2+2(y'')²+2yy''''=0, hence y''''=−(x²+y²)/y³=−289/3375 at (8,15). Because y>0, the branch is concave down.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd²y/dx²=−1/15; the upper branch is concave down.', false, 'Differentiating y'' requires the (y'')² term, which produces the circle-radius numerator rather than just 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'd²y/dx²=−8/15; the upper branch is concave down.', false, 'This is the first derivative y'', not the second derivative y''''.' from version_ins;
-- apcalcbc-mcq-b19-sv-h-5.12-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b19-sv-h-5.12-b-v3', 'mcq', 'circle second derivative and concavity (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the upper branch of x²+y²=625, evaluate d²y/dx² at (7,24) and use its sign to describe the branch''s local concavity there.', null, md5('apcalcbc-mcq-b19-sv-h-5.12-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd²y/dx²=−625/13824; the upper branch is concave down.', true, 'Correct: From 2x+2yy''=0, y''=−x/y. Differentiating again gives 2+2(y'')²+2yy''''=0, hence y''''=−(x²+y²)/y³=−625/13824 at (7,24). Because y>0, the branch is concave down.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd²y/dx²=+625/13824; the upper branch is concave up.', false, 'The second derivative is negative on the upper half of the circle; this sign is reversed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd²y/dx²=−1/24; the upper branch is concave down.', false, 'Differentiating y'' requires the (y'')² term, which produces the circle-radius numerator rather than just 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'd²y/dx²=−7/24; the upper branch is concave down.', false, 'This is the first derivative y'', not the second derivative y''''.' from version_ins;
-- apcalcbc-mcq-b19-h-5.12-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b19-h-5.12-c', 'mcq', 'ellipse second derivative and maximum', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Near (0,1), the ellipse x²+4y²=4 defines an upper-branch function y(x). Find y'''' at x=0 and use it to classify the point (0,1) on that branch.', null, md5('apcalcbc-mcq-b19-h-5.12-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y''''(0)=+1/4; (0,1) is a local minimum of the upper branch.', false, 'The sign is negative, so the upper branch has a local maximum, not a minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y''''(0)=−1/1; (0,1) is a local maximum of the upper branch.', false, 'This misses the factor 4 multiplying y² in the original relation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y''''(0)=−1/4; (0,1) is a local maximum of the upper branch.', true, 'Correct: Differentiate to get 2x+8yy''=0, so y''(0)=0. Differentiate again: 2+8[(y'')²+yy'''']=0. At (0,1), y''''=−2/(8·1)=−1/4<0, making this stationary point a local maximum on the upper branch.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y''''(0)=0; (0,1) is neither a maximum nor a minimum.', false, 'A horizontal tangent can still be a maximum; the implicit second derivative is nonzero and negative.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b19-h-5.12-a','apcalcbc-mcq-b19-sv-h-5.12-a-v1','apcalcbc-mcq-b19-sv-h-5.12-a-v2','apcalcbc-mcq-b19-sv-h-5.12-a-v3','apcalcbc-mcq-b19-h-5.12-b','apcalcbc-mcq-b19-sv-h-5.12-b-v1','apcalcbc-mcq-b19-sv-h-5.12-b-v2','apcalcbc-mcq-b19-sv-h-5.12-b-v3','apcalcbc-mcq-b19-h-5.12-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b19-h-5.12-a','apcalcbc-mcq-b19-sv-h-5.12-a-v1','apcalcbc-mcq-b19-sv-h-5.12-a-v2','apcalcbc-mcq-b19-sv-h-5.12-a-v3','apcalcbc-mcq-b19-h-5.12-b','apcalcbc-mcq-b19-sv-h-5.12-b-v1','apcalcbc-mcq-b19-sv-h-5.12-b-v2','apcalcbc-mcq-b19-sv-h-5.12-b-v3','apcalcbc-mcq-b19-h-5.12-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
