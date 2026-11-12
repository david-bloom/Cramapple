begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-h-1.13-b','apcalcab-mcq-b7-sv-h-1.13-b-v1','apcalcab-mcq-b7-sv-h-1.13-b-v2','apcalcab-mcq-b7-sv-h-1.13-b-v3','apcalcab-mcq-b7-h-1.14-a','apcalcab-mcq-b7-sv-h-1.14-a-v1','apcalcab-mcq-b7-sv-h-1.14-a-v2','apcalcab-mcq-b7-sv-h-1.14-a-v3','apcalcab-mcq-b7-h-1.14-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apcalcab-mcq-b7-h-1.13-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.13-b', 'mcq', 'combine a given function value with continuity at a point to determine unknown coefficients in the numerator of a ration', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = (x² + ax + b)/(x − 3) for x ≠ 3 and f(3) = 5, where a and b are constants. If f is continuous at x = 3, what is the value of b?', null, md5('apcalcab-mcq-b7-h-1.13-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−6', true, 'Correct: The numerator must be (x − 3)(x + c) with limit 3 + c = 5, so c = 2 and the numerator is x² − x − 6, giving b = −6.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This has a sign error. The numerator (x − 3)(x + 2) = x² − x − 6 has constant term −6, not +6.' from version_ins
union all select gen_random_uuid(), id, 'C', '−15', false, 'This takes the remaining factor as x + 5, using the limit 5 as the second constant instead of 5 − 3 = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−9', false, 'This uses −3 × 3, treating the second factor''s constant as 3.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.13-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.13-b-v1', 'mcq', 'combine a given function value with continuity at a point to determine unknown coefficients in the numerator of a ration (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = (x² + ax + b)/(x − 2) for x ≠ 2 and f(2) = 7, where a and b are constants. If f is continuous at x = 2, what is the value of a?', null, md5('apcalcab-mcq-b7-sv-h-1.13-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 3', true, 'Correct: The numerator must be (x − 2)(x + c) with limit 2 + c = 7, so c = 5, and (x − 2)(x + 5) = x² + 3x − 10, so a = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 5', false, 'This reports the second constant c = 5 in (x − 2)(x + c) rather than a = c − 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = −3', false, 'This has a sign error when expanding (x − 2)(x + 5) = x² + 3x − 10.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 7', false, 'This takes a equal to the given value f(2).' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.13-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.13-b-v2', 'mcq', 'combine a given function value with continuity at a point to determine unknown coefficients in the numerator of a ration (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = (x² + ax + b)/(x + 1) for x ≠ −1 and f(−1) = −4, where a and b are constants. If f is continuous at x = −1, what is the value of b?', null, md5('apcalcab-mcq-b7-sv-h-1.13-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'b = 3', false, 'This has a sign error. With c = −3, (x + 1)(x − 3) has constant term −3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'b = −3', true, 'Correct: The numerator must be (x + 1)(x + c) with limit −1 + c = −4, so c = −3, and (x + 1)(x − 3) = x² − 2x − 3, giving b = −3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'b = −4', false, 'This takes b equal to the given value f(−1).' from version_ins
union all select gen_random_uuid(), id, 'D', 'b = −2', false, 'This reports a = −2 instead of the constant term b = −3.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.13-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.13-b-v3', 'mcq', 'combine a given function value with continuity at a point to determine unknown coefficients in the numerator of a ration (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = (x² + ax + b)/(x − 4) for x ≠ 4 and f(4) = −2, where a and b are constants. If f is continuous at x = 4, what is the value of a?', null, md5('apcalcab-mcq-b7-sv-h-1.13-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = −6', false, 'This reports the second constant c = −6 in (x − 4)(x + c) rather than a = c − 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = −10', true, 'Correct: The numerator must be (x − 4)(x + c) with limit 4 + c = −2, so c = −6, and (x − 4)(x − 6) = x² − 10x + 24, so a = −10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 10', false, 'This has a sign error when expanding (x − 4)(x − 6) = x² − 10x + 24.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = −2', false, 'This takes a equal to the given value f(4).' from version_ins;
-- apcalcab-mcq-b7-h-1.14-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.14-a', 'mcq', 'determine the parameter values for which a rational function has exactly one vertical asymptote, using that a numerator ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x² + kx − 6)/(x² − x − 2), where k is a constant. For which values of k does the graph of f have exactly one vertical asymptote?', null, md5('apcalcab-mcq-b7-h-1.14-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = −1 or k = 5', false, 'This reverses the signs of the correct values. Substituting x = 2 into the numerator gives 2k − 2, so k = 1, not −1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 2 or k = −1', false, 'These are the zeros of the denominator, not values of the parameter. The parameter must make the numerator vanish at one of them.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 1 only', false, 'This finds the value that cancels x − 2 but misses that k = −5 cancels x + 1, which also leaves exactly one asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 1 or k = −5', true, 'Correct: The denominator is (x − 2)(x + 1). The numerator vanishes at 2 when k = 1 (leaving an asymptote at −1) and at −1 when k = −5 (leaving an asymptote at 2).' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.14-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.14-a-v1', 'mcq', 'determine the parameter values for which a rational function has exactly one vertical asymptote, using that a numerator  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x² + kx + 6)/(x² − 3x + 2), where k is a constant. For which values of k does the graph of f have exactly one vertical asymptote?', null, md5('apcalcab-mcq-b7-sv-h-1.14-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 7 or k = 5', false, 'This reverses the signs. Substituting x = 1 gives 7 + k, so k = −7, not 7.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 1 or k = 2', false, 'These are the zeros of the denominator, not values of the parameter.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = −7 or k = −5', true, 'Correct: The denominator is (x − 1)(x − 2). The numerator vanishes at 1 when k = −7 and at 2 when k = −5; either removes one asymptote and leaves one.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = −5 only', false, 'This finds the value that cancels x − 2 but misses that k = −7 cancels x − 1.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.14-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.14-a-v2', 'mcq', 'determine the parameter values for which a rational function has exactly one vertical asymptote, using that a numerator  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x² + kx − 12)/(x² − x − 6), where k is a constant. For which values of k does the graph of f have exactly one vertical asymptote?', null, md5('apcalcab-mcq-b7-sv-h-1.14-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = −1 or k = 4', false, 'This reverses the signs. Substituting x = 3 gives 3k − 3, so k = 1, not −1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 3 or k = −2', false, 'These are the zeros of the denominator, not values of the parameter.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 1 or k = −4', true, 'Correct: The denominator is (x − 3)(x + 2). The numerator vanishes at 3 when k = 1 and at −2 when k = −4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = −4 only', false, 'This finds the value that cancels x + 2 but misses that k = 1 cancels x − 3.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.14-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.14-a-v3', 'mcq', 'determine the parameter values for which a rational function has exactly one vertical asymptote, using that a numerator  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x² + kx − 6)/(x² + 2x − 3), where k is a constant. For which values of k does the graph of f have exactly one vertical asymptote?', null, md5('apcalcab-mcq-b7-sv-h-1.14-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 1 or k = 5', true, 'Correct: The denominator is (x − 1)(x + 3). The numerator vanishes at 1 when k = 5 and at −3 when k = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = −1 or k = −5', false, 'This reverses the signs. Substituting x = 1 gives k − 5, so k = 5, not −5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 1 or k = −3', false, 'The value −3 is a zero of the denominator, not a value of the parameter that works.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 5 only', false, 'This finds the value that cancels x − 1 but misses that k = 1 cancels x + 3.' from version_ins;
-- apcalcab-mcq-b7-h-1.14-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.14-b', 'mcq', 'analyse the sign of each factor to decide whether the one-sided limits at two vertical asymptotes agree, distinguishing ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x + 1)/((x − 2)²(x + 3)). Which of the following is true?', null, md5('apcalcab-mcq-b7-h-1.14-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both lim(x→2) f(x) = ∞ and lim(x→−3) f(x) = ∞', false, 'The factor x + 3 changes sign at −3, so the one-sided limits there are +∞ from the left and −∞ from the right, which do not agree.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Neither limit exists, because the one-sided limits at 2 have opposite signs', false, 'The squared factor (x − 2)² is positive on both sides of 2, so the signs agree and f tends to ∞ on both sides.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→2) f(x) = −∞ and lim(x→−3) f(x) does not exist', false, 'Near 2 the numerator is 3 and x + 3 is 5, both positive, and (x − 2)² is positive, so f is positive, tending to +∞, not −∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→2) f(x) = ∞, but lim(x→−3) f(x) does not exist', true, 'Correct: Near 2: numerator 3 > 0, x + 3 = 5 > 0, (x − 2)² > 0 gives +∞ both sides. Near −3: numerator −2 and the sign of x + 3 flips, so the one-sided limits are +∞ and −∞.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-h-1.13-b','apcalcab-mcq-b7-sv-h-1.13-b-v1','apcalcab-mcq-b7-sv-h-1.13-b-v2','apcalcab-mcq-b7-sv-h-1.13-b-v3','apcalcab-mcq-b7-h-1.14-a','apcalcab-mcq-b7-sv-h-1.14-a-v1','apcalcab-mcq-b7-sv-h-1.14-a-v2','apcalcab-mcq-b7-sv-h-1.14-a-v3','apcalcab-mcq-b7-h-1.14-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b7-h-1.13-b','apcalcab-mcq-b7-sv-h-1.13-b-v1','apcalcab-mcq-b7-sv-h-1.13-b-v2','apcalcab-mcq-b7-sv-h-1.13-b-v3','apcalcab-mcq-b7-h-1.14-a','apcalcab-mcq-b7-sv-h-1.14-a-v1','apcalcab-mcq-b7-sv-h-1.14-a-v2','apcalcab-mcq-b7-sv-h-1.14-a-v3','apcalcab-mcq-b7-h-1.14-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
