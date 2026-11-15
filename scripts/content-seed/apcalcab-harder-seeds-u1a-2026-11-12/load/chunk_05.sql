begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-h-1.5-b','apcalcab-mcq-b6-sv-h-1.5-b-v1','apcalcab-mcq-b6-sv-h-1.5-b-v2','apcalcab-mcq-b6-sv-h-1.5-b-v3','apcalcab-mcq-b6-h-1.6-a','apcalcab-mcq-b6-sv-h-1.6-a-v1','apcalcab-mcq-b6-sv-h-1.6-a-v2','apcalcab-mcq-b6-sv-h-1.6-a-v3','apcalcab-mcq-b6-h-1.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apcalcab-mcq-b6-h-1.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.5-b', 'mcq', 'decide what the limit laws force about one function when a combination and the other function have limits', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→a) [f(x) + g(x)] exists as a finite number. Which statement must be true?', null, md5('apcalcab-mcq-b6-h-1.5-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'If lim(x→a) f(x) exists, then lim(x→a) g(x) exists.', true, 'Correct: Since g(x) = [f(x) + g(x)] − f(x), the difference rule gives lim g(x) = lim[f + g] − lim f whenever lim f exists. So the existence of lim f forces the existence of lim g.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both lim(x→a) f(x) and lim(x→a) g(x) exist.', false, 'The sum can have a limit even if its parts do not. For f(x) = 1/(x − a) and g(x) = −1/(x − a), the sum is 0 but neither part has a finite limit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(a) + g(a) equals the limit of the sum.', false, 'This holds only when the sum is continuous at a. The limit of a sum can differ from the value at a, or the value might not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→a) f(x) = lim(x→a) g(x).', false, 'Nothing forces the two limits to be equal. For f(x) = 1 and g(x) = 2, the sum has a limit of 3 while the parts have limits 1 and 2.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.5-b-v1', 'mcq', 'decide what the limit laws force about one function when a combination and the other function have limits (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→2) [f(x)·g(x)] = 0 and lim(x→2) f(x) = 5. Which statement must be true?', null, md5('apcalcab-mcq-b6-sv-h-1.5-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→2) g(x) = 0', true, 'Correct: Near 2, f is not zero, so g(x) = [f(x)g(x)]/f(x). Using the quotient rule, lim g(x) = 0/5 = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(2) = 0', false, 'The limit of g is 0, but the value of g at 2 can be anything, or g may be undefined there. Limits do not control the value at the point.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→2) g(x) = 5', false, 'The value 5 is lim f(x). The product''s limit is 0, which gives lim g = 0 rather than 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(x) = 0 for every x near 2', false, 'The limit is 0 even if g(x) is never exactly 0 near 2. For example, g(x) = x − 2 has limit 0 and is nonzero for every x ≠ 2.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.5-b-v2', 'mcq', 'decide what the limit laws force about one function when a combination and the other function have limits (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→1) [f(x)/g(x)] = 3 and lim(x→1) g(x) = 0. Which statement must be true?', null, md5('apcalcab-mcq-b6-sv-h-1.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→1) f(x) = 3', false, 'The value 3 is the limit of the quotient, not of f. The product of 3 and lim g = 0 shows lim f = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→1) f(x) = 0', true, 'Correct: Near 1, f(x) = [f(x)/g(x)]·g(x), so by the product rule lim f(x) = 3 · 0 = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→1) f(x) does not exist, because the denominator approaches 0.', false, 'A quotient with a denominator approaching 0 can still have a finite limit when the numerator also approaches 0. Here the product rule forces lim f = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(1) = 3·g(1)', false, 'The relation holds for the limits as x approaches 1, not necessarily at x = 1, where f or g may not even be defined.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.5-b-v3', 'mcq', 'decide what the limit laws force about one function when a combination and the other function have limits (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→−4) [f(x)/g(x)] = 5 and lim(x→−4) g(x) = 2. Which statement must be true?', null, md5('apcalcab-mcq-b6-sv-h-1.5-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→−4) f(x) = 5/2', false, 'The value 5/2 divides the limit of the quotient by lim g. Since f = (f/g)·g, the limits are multiplied, not divided.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→−4) f(x) = 10', true, 'Correct: Near −4, f(x) = [f(x)/g(x)]·g(x), so by the product rule lim f(x) = 5 · 2 = 10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→−4) f(x) = 7', false, 'The value 7 adds the two limits. The relationship between f, g and the quotient is multiplicative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(−4) = 10', false, 'The limits give lim f = 10 but say nothing about the function value f(−4), which may be anything or undefined.' from version_ins;
-- apcalcab-mcq-b6-h-1.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.6-a', 'mcq', 'choose the constant that makes a 0/0 form removable, factor, and evaluate the resulting limit', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let a be the constant for which lim(x→2) (x² + ax + 2)/(x − 2) exists. What is the value of this limit?', null, md5('apcalcab-mcq-b6-h-1.6-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The numerator does approach 0, but so does the denominator. Canceling x − 2 leaves x − 1, whose limit is 1, not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3', false, 'The number −3 is the value of a that makes the limit exist, not the value of the limit.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This comes from factoring the numerator as (x + 1)(x − 2), which expands to x² − x − 2, not x² − 3x + 2. The correct factor left over is x − 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', true, 'Correct: The denominator approaches 0, so the numerator must approach 0: 4 + 2a + 2 = 0 gives a = −3. Then x² − 3x + 2 = (x − 1)(x − 2), and the limit of (x − 1) as x→2 is 1.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.6-a-v1', 'mcq', 'choose the constant that makes a 0/0 form removable, factor, and evaluate the resulting limit (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let a be the constant for which lim(x→3) (x² + ax − 3)/(x − 3) exists. What is the value of this limit?', null, md5('apcalcab-mcq-b6-sv-h-1.6-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'Both numerator and denominator approach 0, so the limit is found after canceling x − 3. The remaining factor x + 1 approaches 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2', false, 'The number −2 is the value of a that makes the limit exist, not the value of the limit.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', true, 'Correct: The numerator must approach 0 as the denominator does: 9 + 3a − 3 = 0 gives a = −2. Then x² − 2x − 3 = (x − 3)(x + 1), and the limit of (x + 1) as x→3 is 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'The number 3 is the value x approaches, not the value of the limit. The limit is the value of the simplified factor x + 1 at x = 3.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.6-a-v2', 'mcq', 'choose the constant that makes a 0/0 form removable, factor, and evaluate the resulting limit (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let a be the constant for which lim(x→−1) (x² + ax + 6)/(x + 1) exists. What is the value of this limit?', null, md5('apcalcab-mcq-b6-sv-h-1.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'Both numerator and denominator approach 0. After canceling x + 1, the remaining factor x + 6 approaches 5, not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'The number 7 is the value of a that makes the limit exist, not the value of the limit.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', true, 'Correct: The numerator must approach 0 as x→−1: 1 − a + 6 = 0 gives a = 7. Then x² + 7x + 6 = (x + 1)(x + 6), and the limit of (x + 6) as x→−1 is 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1', false, 'The number −1 is the value x approaches, not the limit. The limit is the value of the factor x + 6 at x = −1.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.6-a-v3', 'mcq', 'choose the constant that makes a 0/0 form removable, factor, and evaluate the resulting limit (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let a be the constant for which lim(x→4) (x² + ax − 8)/(x − 4) exists. What is the value of this limit?', null, md5('apcalcab-mcq-b6-sv-h-1.6-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', true, 'Correct: The numerator must approach 0 as the denominator does: 16 + 4a − 8 = 0 gives a = −2. Then x² − 2x − 8 = (x − 4)(x + 2), and the limit of (x + 2) as x→4 is 6.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'Both numerator and denominator approach 0, so the limit comes from the canceled form. The remaining factor x + 2 approaches 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2', false, 'The number −2 is the value of a that makes the limit exist, not the value of the limit.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'The number 4 is the value x approaches. The limit is the value of the simplified factor x + 2 at x = 4.' from version_ins;
-- apcalcab-mcq-b6-h-1.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.6-b', 'mcq', 'evaluate a 0/0 limit by combining a complex fraction or rationalizing a radical', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [1/(4 + x) − 1/4]/x?', null, md5('apcalcab-mcq-b6-h-1.6-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The numerator 1/(4 + x) − 1/4 does approach 0, but so does the denominator x. The limit is found after simplifying, not by treating the numerator alone.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/16', false, 'The limit has the right size but the wrong sign. Combining gives 4 − (4 + x) = −x in the numerator, so the result is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'The form 0/0 does not mean the limit fails to exist; it signals that algebra is needed. After simplifying, the limit is −1/16.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/16', true, 'Correct: Combining over a common denominator gives [4 − (4 + x)]/[4(4 + x)] = −x/[4(4 + x)]. Dividing by x gives −1/[4(4 + x)], whose limit as x→0 is −1/16.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-h-1.5-b','apcalcab-mcq-b6-sv-h-1.5-b-v1','apcalcab-mcq-b6-sv-h-1.5-b-v2','apcalcab-mcq-b6-sv-h-1.5-b-v3','apcalcab-mcq-b6-h-1.6-a','apcalcab-mcq-b6-sv-h-1.6-a-v1','apcalcab-mcq-b6-sv-h-1.6-a-v2','apcalcab-mcq-b6-sv-h-1.6-a-v3','apcalcab-mcq-b6-h-1.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b6-h-1.5-b','apcalcab-mcq-b6-sv-h-1.5-b-v1','apcalcab-mcq-b6-sv-h-1.5-b-v2','apcalcab-mcq-b6-sv-h-1.5-b-v3','apcalcab-mcq-b6-h-1.6-a','apcalcab-mcq-b6-sv-h-1.6-a-v1','apcalcab-mcq-b6-sv-h-1.6-a-v2','apcalcab-mcq-b6-sv-h-1.6-a-v3','apcalcab-mcq-b6-h-1.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
