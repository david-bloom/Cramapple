begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.6-b-v1','apcalcab-mcq-b6-sv-h-1.6-b-v2','apcalcab-mcq-b6-sv-h-1.6-b-v3','apcalcab-mcq-b6-h-1.7-a','apcalcab-mcq-b6-sv-h-1.7-a-v1','apcalcab-mcq-b6-sv-h-1.7-a-v2','apcalcab-mcq-b6-sv-h-1.7-a-v3','apcalcab-mcq-b6-h-1.7-b','apcalcab-mcq-b6-sv-h-1.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apcalcab-mcq-b6-sv-h-1.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.6-b-v1', 'mcq', 'evaluate a 0/0 limit by combining a complex fraction or rationalizing a radical (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [√(x + 16) − 4]/x?', null, md5('apcalcab-mcq-b6-sv-h-1.6-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The numerator approaches 0, but so does the denominator. The limit comes from rationalizing, and the result is 1/8.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/4', false, 'This uses 4 in the denominator after rationalizing instead of √16 + 4 = 8. The conjugate sum is 8.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/8', true, 'Correct: Multiply numerator and denominator by √(x + 16) + 4. The numerator becomes x, which cancels, leaving 1/[√(x + 16) + 4], whose limit as x→0 is 1/8.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'The 0/0 form calls for more algebra rather than meaning the limit does not exist. Rationalizing gives 1/8.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.6-b-v2', 'mcq', 'evaluate a 0/0 limit by combining a complex fraction or rationalizing a radical (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→2) [1/x − 1/2]/(x − 2)?', null, md5('apcalcab-mcq-b6-sv-h-1.6-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4', false, 'This has the right magnitude but the wrong sign. The numerator combines to 2 − x, which is the opposite of x − 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'The numerator approaches 0, but so does the denominator, so the limit is determined after simplification, which gives −1/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/4', true, 'Correct: Combining the numerator gives (2 − x)/(2x) = −(x − 2)/(2x). Dividing by x − 2 leaves −1/(2x), whose limit as x→2 is −1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'A 0/0 form does not imply that the limit fails to exist. After canceling x − 2, the remaining expression −1/(2x) has a limit.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.6-b-v3', 'mcq', 'evaluate a 0/0 limit by combining a complex fraction or rationalizing a radical (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→3) [√(x + 1) − 2]/(x − 3)?', null, md5('apcalcab-mcq-b6-sv-h-1.6-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The numerator approaches 0, but so does the denominator, so the limit is found after rationalizing and equals 1/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/2', false, 'This uses 2 in the denominator, as if the conjugate sum were √(x + 1) alone. The conjugate sum at x = 3 is 2 + 2 = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'The form 0/0 is a signal to simplify, not evidence that the limit fails to exist. The result is 1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/4', true, 'Correct: Multiply by [√(x + 1) + 2]/[√(x + 1) + 2]. The numerator becomes (x + 1) − 4 = x − 3, which cancels, leaving 1/[√(x + 1) + 2], whose limit as x→3 is 1/4.' from version_ins;
-- apcalcab-mcq-b6-h-1.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.7-a', 'mcq', 'select the procedure of combining fractions over a common denominator for a difference of unbounded terms', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [1/x − 1/(x² + x)]?', null, md5('apcalcab-mcq-b6-h-1.7-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'Each term grows without bound, but ∞ − ∞ is not automatically 0. Combining the fractions gives 1/(x + 1), with limit 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit does not exist', false, 'Neither term has a finite limit, but the difference can still have one. Combining the terms removes the unbounded behavior.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This subtracts the numerators in the wrong order, getting 1 − (x + 1) = −x. The first fraction has numerator x + 1 over the common denominator.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', true, 'Correct: Writing the difference over a common denominator gives [(x + 1) − 1]/[x(x + 1)] = 1/(x + 1), whose limit as x→0 is 1.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.7-a-v1', 'mcq', 'select the procedure of combining fractions over a common denominator for a difference of unbounded terms (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [1/x − 3/(x² + 3x)]?', null, md5('apcalcab-mcq-b6-sv-h-1.7-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'Each term is unbounded, but ∞ − ∞ is not automatically 0. Combining gives 1/(x + 3), with limit 1/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/3', true, 'Correct: Over the common denominator x(x + 3) the difference is [(x + 3) − 3]/[x(x + 3)] = 1/(x + 3), whose limit as x→0 is 1/3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'The individual terms have no finite limit, but their difference does. Combining over a common denominator removes the unbounded part.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/3', false, 'This reverses the order of subtraction in the numerator, giving 3 − (x + 3) = −x. The first fraction''s numerator is x + 3.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.7-a-v2', 'mcq', 'select the procedure of combining fractions over a common denominator for a difference of unbounded terms (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→2) [1/(x − 2) − 4/(x² − 4)]?', null, md5('apcalcab-mcq-b6-sv-h-1.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'Each term is unbounded near 2, but ∞ − ∞ is not automatically 0. Combining gives 1/(x + 2), with limit 1/4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit does not exist', false, 'Neither term has a finite limit, but the difference can. Combining over a common denominator and canceling x − 2 gives a finite limit.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/4', true, 'Correct: Over the common denominator (x − 2)(x + 2) the difference is [(x + 2) − 4]/[(x − 2)(x + 2)] = (x − 2)/[(x − 2)(x + 2)] = 1/(x + 2), whose limit as x→2 is 1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/4', false, 'This reverses the subtraction in the numerator, giving 4 − (x + 2) = 2 − x. The first fraction contributes x + 2.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.7-a-v3', 'mcq', 'select the procedure of combining fractions over a common denominator for a difference of unbounded terms (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→3) [1/(x − 3) − 6/(x² − 9)]?', null, md5('apcalcab-mcq-b6-sv-h-1.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/6', true, 'Correct: Over the common denominator (x − 3)(x + 3) the difference is [(x + 3) − 6]/[(x − 3)(x + 3)] = 1/(x + 3), whose limit as x→3 is 1/6.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'Each term is unbounded near 3, but ∞ − ∞ is not automatically 0. Combining gives 1/(x + 3), with limit 1/6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'The terms have no finite limits individually, but the difference does. Combining and canceling x − 3 reveals the limit.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/6', false, 'This reverses the order of subtraction in the numerator, giving 6 − (x + 3) = 3 − x. The first fraction contributes x + 3.' from version_ins;
-- apcalcab-mcq-b6-h-1.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.7-b', 'mcq', 'split a limit into a special trigonometric limit and a rational factor and combine the pieces', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [sin(2x)·(x + 3)]/[x(x + 1)]?', null, md5('apcalcab-mcq-b6-h-1.7-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', true, 'Correct: Rewrite as [sin(2x)/x]·[(x + 3)/(x + 1)]. The first factor approaches 2 and the second approaches 3, so the limit is 2 · 3 = 6.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'This treats sin(2x)/x as approaching 1, as if the argument were x. The special limit gives sin(2x)/x → 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This finds the limit of sin(2x)/x but ignores the factor (x + 3)/(x + 1), which approaches 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'Substituting x = 0 makes the numerator 0, but the denominator is also 0. The limit must be found with the special trigonometric limit.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.7-b-v1', 'mcq', 'split a limit into a special trigonometric limit and a rational factor and combine the pieces (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [sin(5x)·(x + 4)]/[x(x + 2)]?', null, md5('apcalcab-mcq-b6-sv-h-1.7-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'This treats sin(5x)/x as approaching 1. The special limit gives sin(5x)/x → 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'This finds the limit of sin(5x)/x but ignores the factor (x + 4)/(x + 2), which approaches 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '10', true, 'Correct: Rewrite as [sin(5x)/x]·[(x + 4)/(x + 2)]. The first factor approaches 5 and the second approaches 2, so the limit is 5 · 2 = 10.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'Substituting x = 0 makes the numerator 0, but the denominator is 0 too. The limit needs the special trigonometric limit.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.6-b-v1','apcalcab-mcq-b6-sv-h-1.6-b-v2','apcalcab-mcq-b6-sv-h-1.6-b-v3','apcalcab-mcq-b6-h-1.7-a','apcalcab-mcq-b6-sv-h-1.7-a-v1','apcalcab-mcq-b6-sv-h-1.7-a-v2','apcalcab-mcq-b6-sv-h-1.7-a-v3','apcalcab-mcq-b6-h-1.7-b','apcalcab-mcq-b6-sv-h-1.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b6-sv-h-1.6-b-v1','apcalcab-mcq-b6-sv-h-1.6-b-v2','apcalcab-mcq-b6-sv-h-1.6-b-v3','apcalcab-mcq-b6-h-1.7-a','apcalcab-mcq-b6-sv-h-1.7-a-v1','apcalcab-mcq-b6-sv-h-1.7-a-v2','apcalcab-mcq-b6-sv-h-1.7-a-v3','apcalcab-mcq-b6-h-1.7-b','apcalcab-mcq-b6-sv-h-1.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
