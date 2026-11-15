begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b15-h-5.8-a','apcalcbc-mcq-b15-sv-h-5.8-a-v1','apcalcbc-mcq-b15-sv-h-5.8-a-v2','apcalcbc-mcq-b15-sv-h-5.8-a-v3','apcalcbc-mcq-b15-h-5.8-b','apcalcbc-mcq-b15-sv-h-5.8-b-v1','apcalcbc-mcq-b15-sv-h-5.8-b-v2','apcalcbc-mcq-b15-sv-h-5.8-b-v3','apcalcbc-mcq-b15-h-5.8-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b15-h-5.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b15-h-5.8-a', 'mcq', 'combine f'' and f'''' for graph features', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f has f''(x)=1(x−(-3))(x−(1)) for all real x, with -3<1. Which set of features belongs in an accurate sketch of f?', null, md5('apcalcbc-mcq-b15-h-5.8-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A local minimum at x=-3, a local maximum at x=1, and an inflection at x=-1.', false, 'The first derivative sign changes at both zeros are reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A local maximum at x=-3, a local minimum at x=1, and an inflection at x=-1 where f is decreasing.', true, 'Correct: f'' has signs positive, negative, positive across -3,1. Also f''''=1(2x−(-3)−(1)) changes sign at -1; f''(-1) has sign negative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Inflection points at both x=-3 and x=1 because f'' is zero there, with no local extrema.', false, 'Zeros of f'' classify extrema of f; f'''' changes sign at the midpoint, not at both derivative zeros.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No inflection point, because the given first derivative is a quadratic polynomial.', false, 'The derivative of the quadratic f'' is linear and changes sign at its zero, producing an inflection of f.' from version_ins;
-- apcalcbc-mcq-b15-sv-h-5.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b15-sv-h-5.8-a-v1', 'mcq', 'combine f'' and f'''' for graph features (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f has f''(x)=-1(x−(-2))(x−(4)) for all real x, with -2<4. Which set of features belongs in an accurate sketch of f?', null, md5('apcalcbc-mcq-b15-sv-h-5.8-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A local maximum at x=-2, a local minimum at x=4, and an inflection at x=1.', false, 'The first derivative sign changes at both zeros are reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Inflection points at both x=-2 and x=4 because f'' is zero there, with no local extrema.', false, 'Zeros of f'' classify extrema of f; f'''' changes sign at the midpoint, not at both derivative zeros.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No inflection point, because the given first derivative is a quadratic polynomial.', false, 'The derivative of the quadratic f'' is linear and changes sign at its zero, producing an inflection of f.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A local minimum at x=-2, a local maximum at x=4, and an inflection at x=1 where f is increasing.', true, 'Correct: f'' has signs negative, positive, negative across -2,4. Also f''''=-1(2x−(-2)−(4)) changes sign at 1; f''(1) has sign positive.' from version_ins;
-- apcalcbc-mcq-b15-sv-h-5.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b15-sv-h-5.8-a-v2', 'mcq', 'combine f'' and f'''' for graph features (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f has f''(x)=2(x−(0))(x−(6)) for all real x, with 0<6. Which set of features belongs in an accurate sketch of f?', null, md5('apcalcbc-mcq-b15-sv-h-5.8-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A local maximum at x=0, a local minimum at x=6, and an inflection at x=3 where f is decreasing.', true, 'Correct: f'' has signs positive, negative, positive across 0,6. Also f''''=2(2x−(0)−(6)) changes sign at 3; f''(3) has sign negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A local minimum at x=0, a local maximum at x=6, and an inflection at x=3.', false, 'The first derivative sign changes at both zeros are reversed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Inflection points at both x=0 and x=6 because f'' is zero there, with no local extrema.', false, 'Zeros of f'' classify extrema of f; f'''' changes sign at the midpoint, not at both derivative zeros.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No inflection point, because the given first derivative is a quadratic polynomial.', false, 'The derivative of the quadratic f'' is linear and changes sign at its zero, producing an inflection of f.' from version_ins;
-- apcalcbc-mcq-b15-sv-h-5.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b15-sv-h-5.8-a-v3', 'mcq', 'combine f'' and f'''' for graph features (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f has f''(x)=-2(x−(-4))(x−(2)) for all real x, with -4<2. Which set of features belongs in an accurate sketch of f?', null, md5('apcalcbc-mcq-b15-sv-h-5.8-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A local maximum at x=-4, a local minimum at x=2, and an inflection at x=-1.', false, 'The first derivative sign changes at both zeros are reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Inflection points at both x=-4 and x=2 because f'' is zero there, with no local extrema.', false, 'Zeros of f'' classify extrema of f; f'''' changes sign at the midpoint, not at both derivative zeros.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A local minimum at x=-4, a local maximum at x=2, and an inflection at x=-1 where f is increasing.', true, 'Correct: f'' has signs negative, positive, negative across -4,2. Also f''''=-2(2x−(-4)−(2)) changes sign at -1; f''(-1) has sign positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No inflection point, because the given first derivative is a quadratic polynomial.', false, 'The derivative of the quadratic f'' is linear and changes sign at its zero, producing an inflection of f.' from version_ins;
-- apcalcbc-mcq-b15-h-5.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b15-h-5.8-b', 'mcq', 'translate derivative table into local sketch', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A table from a twice-differentiable function records f''(-3)=5, f''''(-3)=-6, f''(1)=-3, and f''''(1)=2. A student is drawing local pieces of the graph near x=-3 and x=1. Which annotations match the table?', null, md5('apcalcbc-mcq-b15-h-5.8-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is rising at both points because f'''' is nonzero at both.', false, 'A nonzero second derivative controls concavity, not whether f is rising; one listed f'' is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Near x=-3, f is rising and concave down; near x=1, f is falling and concave up.', true, 'Correct: f'' signs at -3,1 are 5,-3, setting rise/fall; f'''' signs are -6,2, setting concavity. Neither f'' value is zero.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Near x=-3, f is falling, and near x=1, f is rising; the f'' values give the opposite slope signs.', false, 'This reverses the sign interpretation of f'' at both sampled points.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both sampled points must be local extrema of f because f'''' is nonzero at each.', false, 'A nonzero f'' rules out a differentiable local extremum at these sampled points.' from version_ins;
-- apcalcbc-mcq-b15-sv-h-5.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b15-sv-h-5.8-b-v1', 'mcq', 'translate derivative table into local sketch (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function has f''(-1)=-3, f''''(-1)=-2, f''(3)=5, and f''''(3)=6. For a sufficiently small neighborhood of each point, compare the graph with its tangent line there. Which pair of sketch notes is justified?', null, md5('apcalcbc-mcq-b15-sv-h-5.8-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At x=-1, the tangent slopes down and lies locally above the graph; at x=3, it slopes up and lies locally below the graph.', true, 'Correct: f'' gives tangent slopes -3,5. Negative f'''' puts a graph below its tangent locally; positive f'''' puts a graph above it. The tangent sides are above,below.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The tangent slopes have the same signs as stated, but lie below the graph near x=-1 and above the graph near x=3.', false, 'This reverses the local tangent-versus-graph relation implied by each nonzero second derivative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The tangent lies on the stated side of the graph at each point, but its slope signs are the reverse of the listed f'' values.', false, 'The sign of f'' directly gives each tangent slope; these slope directions are reversed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The tangent must cross the graph at both points because both second derivatives are nonzero.', false, 'Nonzero second derivative makes the tangent stay on one local side of the graph rather than cross it immediately.' from version_ins;
-- apcalcbc-mcq-b15-sv-h-5.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b15-sv-h-5.8-b-v2', 'mcq', 'translate derivative table into local sketch (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function has f''(-3)=5, f''''(-3)=-6, f''(-1)=-3, and f''''(-1)=-2. For a sufficiently small neighborhood of each point, compare the graph with its tangent line there. Which pair of sketch notes is justified?', null, md5('apcalcbc-mcq-b15-sv-h-5.8-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The tangent slopes have the same signs as stated, but lie below the graph near x=-3 and below the graph near x=-1.', false, 'This reverses the local tangent-versus-graph relation implied by each nonzero second derivative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'At x=-3, the tangent slopes up and lies locally above the graph; at x=-1, it slopes down and lies locally above the graph.', true, 'Correct: f'' gives tangent slopes 5,-3. Negative f'''' puts a graph below its tangent locally; positive f'''' puts a graph above it. The tangent sides are above,above.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The tangent lies on the stated side of the graph at each point, but its slope signs are the reverse of the listed f'' values.', false, 'The sign of f'' directly gives each tangent slope; these slope directions are reversed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The tangent must cross the graph at both points because both second derivatives are nonzero.', false, 'Nonzero second derivative makes the tangent stay on one local side of the graph rather than cross it immediately.' from version_ins;
-- apcalcbc-mcq-b15-sv-h-5.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b15-sv-h-5.8-b-v3', 'mcq', 'translate derivative table into local sketch (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function has f''(1)=-3, f''''(1)=2, f''(3)=5, and f''''(3)=6. For a sufficiently small neighborhood of each point, compare the graph with its tangent line there. Which pair of sketch notes is justified?', null, md5('apcalcbc-mcq-b15-sv-h-5.8-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At x=1, the tangent slopes down and lies locally below the graph; at x=3, it slopes up and lies locally below the graph.', true, 'Correct: f'' gives tangent slopes -3,5. Negative f'''' puts a graph below its tangent locally; positive f'''' puts a graph above it. The tangent sides are below,below.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The tangent slopes have the same signs as stated, but lie above the graph near x=1 and above the graph near x=3.', false, 'This reverses the local tangent-versus-graph relation implied by each nonzero second derivative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The tangent lies on the stated side of the graph at each point, but its slope signs are the reverse of the listed f'' values.', false, 'The sign of f'' directly gives each tangent slope; these slope directions are reversed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The tangent must cross the graph at both points because both second derivatives are nonzero.', false, 'Nonzero second derivative makes the tangent stay on one local side of the graph rather than cross it immediately.' from version_ins;
-- apcalcbc-mcq-b15-h-5.8-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b15-h-5.8-c', 'mcq', 'classify stationary inflection and local extremum', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function g has g''(x)=1(x−(-2))²(x−(4)) for all real x. A proposed sketch marks x=-2 as a horizontal tangent and x=4 as another horizontal tangent. Which additional classification is correct?', null, md5('apcalcbc-mcq-b15-h-5.8-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=-2 and x=4 are both local minimum points because g'' vanishes at both.', false, 'A repeated derivative zero does not change g'' sign, while the simple zero does.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=-2 is a stationary inflection, but x=4 is also an inflection because g'' vanishes there.', false, 'The simple zero of g'' is an extremum of g, not an inflection; g'''' does not vanish there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=-2 is a stationary inflection, x=2 is another inflection, and x=4 is a local minimum.', true, 'Correct: The squared factor makes g'' keep its sign at -2; the simple factor changes sign at 4, giving a local minimum. Differentiation gives g''''=1(x−(-2))(3x−(6)), whose signs change at -2 and 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=2 is a local minimum of g because it is a zero of g''''.', false, 'A zero of g'''' can signal an inflection of g, not a local extremum unless g'' also changes sign.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b15-h-5.8-a','apcalcbc-mcq-b15-sv-h-5.8-a-v1','apcalcbc-mcq-b15-sv-h-5.8-a-v2','apcalcbc-mcq-b15-sv-h-5.8-a-v3','apcalcbc-mcq-b15-h-5.8-b','apcalcbc-mcq-b15-sv-h-5.8-b-v1','apcalcbc-mcq-b15-sv-h-5.8-b-v2','apcalcbc-mcq-b15-sv-h-5.8-b-v3','apcalcbc-mcq-b15-h-5.8-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b15-h-5.8-a','apcalcbc-mcq-b15-sv-h-5.8-a-v1','apcalcbc-mcq-b15-sv-h-5.8-a-v2','apcalcbc-mcq-b15-sv-h-5.8-a-v3','apcalcbc-mcq-b15-h-5.8-b','apcalcbc-mcq-b15-sv-h-5.8-b-v1','apcalcbc-mcq-b15-sv-h-5.8-b-v2','apcalcbc-mcq-b15-sv-h-5.8-b-v3','apcalcbc-mcq-b15-h-5.8-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
