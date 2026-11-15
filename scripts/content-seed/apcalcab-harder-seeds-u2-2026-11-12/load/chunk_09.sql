begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-h-2.10-a','apcalcab-mcq-b5-sv-h-2.10-a-v1','apcalcab-mcq-b5-sv-h-2.10-a-v2','apcalcab-mcq-b5-sv-h-2.10-a-v3','apcalcab-mcq-b5-h-2.10-b','apcalcab-mcq-b5-sv-h-2.10-b-v1','apcalcab-mcq-b5-sv-h-2.10-b-v2','apcalcab-mcq-b5-sv-h-2.10-b-v3'])) then raise exception 'chunk 9 already loaded'; end if;
end $$;
-- apcalcab-mcq-b5-h-2.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.10-a', 'mcq', 'solve for the points where the tangent to tan x or cot x has a given slope, using sec²x and csc²x and keeping both solut', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For −π/2 < x < π/2, at which values of x does the tangent line to the graph of y = tan x have slope 4?', null, md5('apcalcab-mcq-b5-h-2.10-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = π/3 only', false, 'Since sec²x = 4 gives cos x = ±1/2, both x = π/3 and x = −π/3 lie in the interval. Keeping only the positive solution misses the symmetric one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = π/6 and x = −π/6', false, 'The angle π/6 has cos x = √3/2, not 1/2. The condition sec²x = 4 needs cos²x = 1/4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = π/3 and x = −π/3', true, 'Correct: d/dx[tan x] = sec²x. Setting sec²x = 4 gives cos x = ±1/2, so x = ±π/3 in (−π/2, π/2).' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = arctan 4 and x = −arctan 4', false, 'This sets tan x = 4. The derivative of tan x is sec²x, so the condition is sec²x = 4, not tan x = 4.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.10-a-v1', 'mcq', 'solve for the points where the tangent to tan x or cot x has a given slope, using sec²x and csc²x and keeping both solut (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For −π/2 < x < π/2, at which values of x does the tangent line to the graph of y = tan x have slope 2?', null, md5('apcalcab-mcq-b5-sv-h-2.10-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = π/4 and x = −π/4', true, 'Correct: d/dx[tan x] = sec²x. Setting sec²x = 2 gives cos x = ±√2/2, so x = ±π/4 in (−π/2, π/2).' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = π/4 only', false, 'Since sec²x = 2 gives cos x = ±√2/2, both x = π/4 and x = −π/4 lie in the interval. Keeping only the positive solution misses the symmetric one.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = π/3 and x = −π/3', false, 'The angle π/3 has sec²x = 4, giving slope 4. The condition sec²x = 2 needs cos²x = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = arctan 2 and x = −arctan 2', false, 'This sets tan x = 2. The derivative of tan x is sec²x, so the condition is sec²x = 2, not tan x = 2.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.10-a-v2', 'mcq', 'solve for the points where the tangent to tan x or cot x has a given slope, using sec²x and csc²x and keeping both solut (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For 0 < x < π, at which values of x does the tangent line to the graph of y = cot x have slope −4?', null, md5('apcalcab-mcq-b5-sv-h-2.10-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = π/6 only', false, 'Since csc²x = 4 gives sin x = 1/2 (positive on (0, π)), both x = π/6 and x = 5π/6 are solutions. Keeping only π/6 misses the second.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = π/6 and x = 5π/6', true, 'Correct: d/dx[cot x] = −csc²x. Setting −csc²x = −4 gives sin x = 1/2, so x = π/6 or 5π/6 in (0, π).' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = π/3 and x = 2π/3', false, 'This solves cos x = ±1/2, which would correspond to sec²x = 4. The condition here is csc²x = 4, so sin x = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = π/6 and x = 7π/6', false, 'The value 7π/6 is outside the interval (0, π). The second solution of sin x = 1/2 in (0, π) is 5π/6.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.10-a-v3', 'mcq', 'solve for the points where the tangent to tan x or cot x has a given slope, using sec²x and csc²x and keeping both solut (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For 0 < x < π, at which values of x does the tangent line to the graph of y = cot x have slope −2?', null, md5('apcalcab-mcq-b5-sv-h-2.10-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = π/4 and x = 3π/4', true, 'Correct: d/dx[cot x] = −csc²x. Setting −csc²x = −2 gives sin x = √2/2, so x = π/4 or 3π/4 in (0, π).' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = π/4 only', false, 'Since csc²x = 2 gives sin x = √2/2, both x = π/4 and x = 3π/4 are solutions. Keeping only π/4 misses the second.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = π/6 and x = 5π/6', false, 'The angles π/6 and 5π/6 have sin x = 1/2, giving csc²x = 4 and slope −4, not −2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = π/3 and x = 2π/3', false, 'The angles π/3 and 2π/3 have sin x = √3/2, giving csc²x = 4/3 and slope −4/3, not −2.' from version_ins;
-- apcalcab-mcq-b5-h-2.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.10-b', 'mcq', 'combine derivative formulas and identities to determine the sign of a derivative and describe monotonic behaviour.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = tan x − x for −π/2 < x < π/2. Which statement about f is true?', null, md5('apcalcab-mcq-b5-h-2.10-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local minimum at x = 0 because f′(0) = 0.', false, 'A zero of f′ gives a local extremum only if f′ changes sign. Here f′ = tan²x is nonnegative on both sides of 0, so there is no extremum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f′(x) = tan²x ≥ 0 with equality only at x = 0, so f is increasing and its graph has a horizontal tangent at x = 0 but no extremum there.', true, 'Correct: f′(x) = sec²x − 1 = tan²x, which is nonnegative and equals 0 only at x = 0. So f is increasing, with a horizontal tangent at 0 and no extremum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is decreasing for x < 0 and increasing for x > 0.', false, 'This assumes f′ changes sign at 0 like the derivative of x². But f′(x) = tan²x is positive on both sides of 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f′(x) = sec²x + 1 > 0, so f is increasing and never has a horizontal tangent.', false, 'This has a sign error: the derivative of −x is −1, so f′(x) = sec²x − 1 = tan²x, which is 0 at x = 0.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.10-b-v1', 'mcq', 'combine derivative formulas and identities to determine the sign of a derivative and describe monotonic behaviour. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = sec x − tan x for −π/2 < x < π/2. Which statement about g is true?', null, md5('apcalcab-mcq-b5-sv-h-2.10-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g′(0) = 0, so the graph has a horizontal tangent line at x = 0.', false, 'Since g′(x) = sec x tan x − sec²x, g′(0) = 0 − 1 = −1, so the tangent at x = 0 has slope −1, not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g′(x) = sec x tan x + sec²x > 0, so g is increasing.', false, 'This has a sign error: the derivative of −tan x is −sec²x, so g′(x) = sec x tan x − sec²x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is decreasing for x < 0 and increasing for x > 0.', false, 'This assumes g′ changes sign at 0, but g′(x) = −(1 − sin x)/cos²x is negative on the whole interval.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g′(x) < 0 for every x in the interval, so g is decreasing and its graph has no horizontal tangent line.', true, 'Correct: g′(x) = sec x tan x − sec²x = sec x (tan x − sec x) = −(1 − sin x)/cos²x, which is negative on the interval since sin x < 1. So g is decreasing.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.10-b-v2', 'mcq', 'combine derivative formulas and identities to determine the sign of a derivative and describe monotonic behaviour. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = cot x + x for 0 < x < π. Which statement about h is true?', null, md5('apcalcab-mcq-b5-sv-h-2.10-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h has a local maximum at x = π/2 because h′(π/2) = 0.', false, 'A zero of h′ gives a local extremum only if h′ changes sign. Here h′ = −cot²x is nonpositive on both sides of π/2, so there is no extremum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h′(x) = csc²x + 1 > 0, so h is increasing.', false, 'This has two sign errors: the derivative of cot x is −csc²x, and the derivative of x is +1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h′(x) = −csc²x − 1 < 0, so h is decreasing and never has a horizontal tangent.', false, 'This has a sign error on the term x: its derivative is +1, so h′(x) = −csc²x + 1 = −cot²x, which is 0 at π/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h′(x) = −cot²x ≤ 0 with equality only at x = π/2, so h is decreasing and its graph has a horizontal tangent at x = π/2 but no extremum there.', true, 'Correct: h′(x) = −csc²x + 1 = −cot²x, which is nonpositive and equals 0 only at x = π/2. So h is decreasing, with a horizontal tangent at π/2 and no extremum.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.10-b-v3', 'mcq', 'combine derivative formulas and identities to determine the sign of a derivative and describe monotonic behaviour. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let k(x) = csc x + cot x for 0 < x < π. Which statement about k is true?', null, md5('apcalcab-mcq-b5-sv-h-2.10-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k′(π/2) = 0, so the graph has a horizontal tangent line at x = π/2.', false, 'Here k′(x) = −csc x cot x − csc²x, so k′(π/2) = 0 − 1 = −1. The tangent at π/2 has slope −1, not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k′(x) = csc x cot x + csc²x > 0, so k is increasing.', false, 'This has sign errors: the derivatives of csc x and cot x are −csc x cot x and −csc²x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k′(x) < 0 for every x in the interval, so k is decreasing and its graph has no horizontal tangent line.', true, 'Correct: k′(x) = −csc x cot x − csc²x = −csc x (cot x + csc x) = −(1 + cos x)/sin²x, which is negative on (0, π). So k is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k is decreasing for x < π/2 and increasing for x > π/2.', false, 'This assumes k′ changes sign at π/2, but k′(x) = −(1 + cos x)/sin²x is negative on the whole interval.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-h-2.10-a','apcalcab-mcq-b5-sv-h-2.10-a-v1','apcalcab-mcq-b5-sv-h-2.10-a-v2','apcalcab-mcq-b5-sv-h-2.10-a-v3','apcalcab-mcq-b5-h-2.10-b','apcalcab-mcq-b5-sv-h-2.10-b-v1','apcalcab-mcq-b5-sv-h-2.10-b-v2','apcalcab-mcq-b5-sv-h-2.10-b-v3']) and status='draft')<>8 then raise exception 'chunk 9: expected 8 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b5-h-2.10-a','apcalcab-mcq-b5-sv-h-2.10-a-v1','apcalcab-mcq-b5-sv-h-2.10-a-v2','apcalcab-mcq-b5-sv-h-2.10-a-v3','apcalcab-mcq-b5-h-2.10-b','apcalcab-mcq-b5-sv-h-2.10-b-v1','apcalcab-mcq-b5-sv-h-2.10-b-v2','apcalcab-mcq-b5-sv-h-2.10-b-v3']))<>32 then raise exception 'chunk 9: expected 32 choices'; end if;
end $$;
commit;
