begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.4-a-v3','apcalcbc-mcq-b5-h-2.4-b','apcalcbc-mcq-b5-sv-h-2.4-b-v1','apcalcbc-mcq-b5-sv-h-2.4-b-v2','apcalcbc-mcq-b5-sv-h-2.4-b-v3','apcalcbc-mcq-b5-h-2.5-a','apcalcbc-mcq-b5-sv-h-2.5-a-v1','apcalcbc-mcq-b5-sv-h-2.5-a-v2','apcalcbc-mcq-b5-sv-h-2.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b5-sv-h-2.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.4-a-v3', 'mcq', 'identify which function is differentiable at a point by diagnosing corners, cusps, and vertical tangents among similar-l (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following functions is differentiable at x = 0?', null, md5('apcalcbc-mcq-b5-sv-h-2.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = |sin x|', false, 'Near 0, |sin x| behaves like |x|: the one-sided slopes are −1 and +1, a corner.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = x^(1/3)', false, 'The difference quotient h^(−2/3) grows without bound, so there is a vertical tangent and no derivative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = x^(2/5)', false, 'The difference quotient h^(−3/5) is unbounded and changes sign across 0, a cusp, so f′(0) does not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = x|x|', true, 'Correct: For f(x) = x|x| the quotient (f(h) − f(0))/h = |h|, which tends to 0, so f′(0) = 0.' from version_ins;
-- apcalcbc-mcq-b5-h-2.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.4-b', 'mcq', 'conclude correctly about continuity and differentiability from one-sided information, avoiding the converse and averagin', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a function with f(2) = 5 and lim as x→2 of f(x) = 5. Also, lim as h→0⁺ of [f(2 + h) − 5]/h = 3 and lim as h→0⁻ of [f(2 + h) − 5]/h = −3. Which statement must be true?', null, md5('apcalcbc-mcq-b5-h-2.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is continuous at x = 2 but not differentiable at x = 2.', true, 'Correct: Continuity holds since the limit equals f(2); the one-sided derivatives 3 and −3 differ, so f′(2) does not exist.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is differentiable at x = 2 with f′(2) = 0.', false, 'Averaging the one-sided slopes 3 and −3 is not how derivatives work; the derivative exists only if the two one-sided limits are equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is not continuous at x = 2.', false, 'The values f(2) = 5 and the limit 5 agree, so f is continuous; failing to be differentiable does not imply failing to be continuous.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is differentiable at x = 2 because f is continuous at x = 2.', false, 'Continuity does not imply differentiability; the unequal one-sided slopes 3 and −3 give a corner.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.4-b-v1', 'mcq', 'conclude correctly about continuity and differentiability from one-sided information, avoiding the converse and averagin (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a function with f(4) = 1 and lim as x→4 of f(x) = 2. Which statement must be true?', null, md5('apcalcbc-mcq-b5-sv-h-2.4-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is continuous at x = 4, but f might not be differentiable there.', false, 'The limit exists but equals 2, while f(4) = 1, so f is not continuous at 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is differentiable at x = 4 because the limit of f(x) exists there.', false, 'Existence of the limit is not enough; differentiability requires continuity, which needs the limit to equal f(4).' from version_ins
union all select gen_random_uuid(), id, 'C', 'f could be differentiable at x = 4 even though f is not continuous there.', false, 'Differentiability at a point implies continuity there, so a function with a jump at 4 cannot be differentiable at 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is not differentiable at x = 4.', true, 'Correct: The limit 2 differs from f(4) = 1, so f is discontinuous at 4, and a discontinuous function cannot be differentiable there.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.4-b-v2', 'mcq', 'conclude correctly about continuity and differentiability from one-sided information, avoiding the converse and averagin (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be continuous at x = 4, and suppose lim as h→0⁺ of [f(4 + h) − f(4)]/h = 1/4 and lim as h→0⁻ of [f(4 + h) − f(4)]/h = 1/4. Which statement must be true?', null, md5('apcalcbc-mcq-b5-sv-h-2.4-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is differentiable at x = 4 with f′(4) = 1/2.', false, 'The derivative is the common value of the one-sided limits, not their sum, so it is 1/4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is not differentiable at x = 4 because continuity alone does not guarantee a derivative.', false, 'Here the two one-sided limits exist and agree, so the two-sided limit exists, which is the definition of differentiability.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is differentiable at x = 4 with f′(4) = 0.', false, 'The limit of the difference quotient is 1/4, not 0; a value of 0 would require both one-sided limits to be 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is differentiable at x = 4 with f′(4) = 1/4.', true, 'Correct: Equal one-sided limits of the difference quotient mean the two-sided limit exists and equals 1/4, so f′(4) = 1/4.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.4-b-v3', 'mcq', 'conclude correctly about continuity and differentiability from one-sided information, avoiding the converse and averagin (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be continuous at x = 1, and suppose lim as h→0⁺ of [f(1 + h) − f(1)]/h = ∞ and lim as h→0⁻ of [f(1 + h) − f(1)]/h = ∞. Which statement must be true?', null, md5('apcalcbc-mcq-b5-sv-h-2.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is continuous at x = 1 but not differentiable at x = 1.', true, 'Correct: A difference quotient that tends to infinity means the derivative does not exist (vertical tangent), though f remains continuous.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is differentiable at x = 1 with f′(1) = ∞.', false, 'A derivative must be a finite number; an infinite limit means a vertical tangent, where f′(1) does not exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is not continuous at x = 1 because the difference quotient is unbounded.', false, 'Continuity is given in the stem; an unbounded difference quotient indicates a vertical tangent, not a jump.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is differentiable at x = 1 with f′(1) = 0 because the one-sided limits agree.', false, 'Agreement of the one-sided limits only gives differentiability when the common value is a finite real number; here it is infinite.' from version_ins;
-- apcalcbc-mcq-b5-h-2.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.5-a', 'mcq', 'find the point of tangency for a tangent line to a power curve that passes through a given external point, by setting up', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of y = 1/x at the point where x = a (a > 0) passes through the point (0, 4). What is a?', null, md5('apcalcbc-mcq-b5-h-2.5-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/2', true, 'Correct: The tangent at a is y = 1/a − (x − a)/a²; at x = 0 it gives 2/a = 4, so a = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/3', false, 'This differentiates 1/x as −1/x, forgetting to lower the exponent to −2, so the tangent slope is −1/a and the equation becomes 1/a + 1 = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/4', false, 'This sets the height of the curve, 1/a, equal to 4, which finds where the curve reaches height 4 and ignores the tangent line altogether.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', false, 'The correct equation 2/a = 4 gives a = 1/2; solving it as a = 2 inverts the fraction.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.5-a-v1', 'mcq', 'find the point of tangency for a tangent line to a power curve that passes through a given external point, by setting up (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of y = x^(3/2) at the point where x = a (a > 0) passes through the point (1, 0). What is a?', null, md5('apcalcbc-mcq-b5-sv-h-2.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/3', false, 'This differentiates x^(3/2) as (3/2)x^(3/2), forgetting to lower the exponent, so the condition becomes 1 + (3/2)(1 − a) = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', true, 'Correct: The tangent at a is y = a^(3/2) + (3/2)a^(1/2)(x − a); at (1, 0) this gives a + (3/2)(1 − a) = 0, so a = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/5', false, 'This writes the run from (1, 0) to (a, a^(3/2)) as 1 − a instead of a − 1, a sign slip that turns a/(a − 1) = 3/2 into a/(1 − a) = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'This uses the x-coordinate of the given point as the point of tangency, but the tangent at x = 1 is y = (3/2)(x − 1) + 1, which does not pass through (1, 0).' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.5-a-v2', 'mcq', 'find the point of tangency for a tangent line to a power curve that passes through a given external point, by setting up (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of y = 1/x at the point where x = a (a > 0) passes through the point (3, 0). What is a?', null, md5('apcalcbc-mcq-b5-sv-h-2.5-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'This differentiates 1/x as −1/x, so the tangent slope is −1/a and the condition becomes 1 − 3 + a = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'This uses the x-coordinate of the given point as the point of tangency, but the tangent at x = 3 passes through (3, 1/3) on the curve, not through (3, 0).' from version_ins
union all select gen_random_uuid(), id, 'C', '3/2', true, 'Correct: The tangent at a is y = 1/a − (x − a)/a²; setting y = 0 at x = 3 gives a − (3 − a) = 0, so a = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/3', false, 'This sets 1/a = 3, which is where the curve reaches height 3, and does not use the tangent condition.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.5-a-v3', 'mcq', 'find the point of tangency for a tangent line to a power curve that passes through a given external point, by setting up (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of y = ∛x at the point where x = a (a > 0) passes through the point (0, 2). What is a?', null, md5('apcalcbc-mcq-b5-sv-h-2.5-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', false, 'This sets the height of the curve ∛a equal to 2, which finds where the curve reaches height 2 and ignores the tangent line.' from version_ins
union all select gen_random_uuid(), id, 'B', '27/8', false, 'This adds the tangent term instead of subtracting it, giving (4/3)∛a = 2 in place of (2/3)∛a = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '27', true, 'Correct: The tangent at a is y = a^(1/3) + (1/3)a^(−2/3)(x − a); at x = 0 it gives (2/3)a^(1/3) = 2, so a^(1/3) = 3 and a = 27.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'This solves (2/3)∛a = 2 correctly for the cube root ∛a = 3 but reports that value instead of a itself.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.4-a-v3','apcalcbc-mcq-b5-h-2.4-b','apcalcbc-mcq-b5-sv-h-2.4-b-v1','apcalcbc-mcq-b5-sv-h-2.4-b-v2','apcalcbc-mcq-b5-sv-h-2.4-b-v3','apcalcbc-mcq-b5-h-2.5-a','apcalcbc-mcq-b5-sv-h-2.5-a-v1','apcalcbc-mcq-b5-sv-h-2.5-a-v2','apcalcbc-mcq-b5-sv-h-2.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b5-sv-h-2.4-a-v3','apcalcbc-mcq-b5-h-2.4-b','apcalcbc-mcq-b5-sv-h-2.4-b-v1','apcalcbc-mcq-b5-sv-h-2.4-b-v2','apcalcbc-mcq-b5-sv-h-2.4-b-v3','apcalcbc-mcq-b5-h-2.5-a','apcalcbc-mcq-b5-sv-h-2.5-a-v1','apcalcbc-mcq-b5-sv-h-2.5-a-v2','apcalcbc-mcq-b5-sv-h-2.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
