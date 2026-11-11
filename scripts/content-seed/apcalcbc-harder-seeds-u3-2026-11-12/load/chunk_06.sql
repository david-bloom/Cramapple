begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-sv-h-3.6-b-v1','apcalcbc-mcq-b2-sv-h-3.6-b-v2','apcalcbc-mcq-b2-sv-h-3.6-b-v3'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b2-sv-h-3.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.6-b-v1', 'mcq', 'decide the concavity of a composite function from the signs of f′, f″, g′ and g″ using h″ = f″(g)(g′)² + f′(g)g″. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The functions f and g are twice differentiable on the real numbers. For all real t, f′(t) < 0 and f″(t) > 0, and for all real x, g′(x) > 0 and g″(x) > 0. Let h(x) = f(g(x)). Which statement is justified by this information alone?', null, md5('apcalcbc-mcq-b2-sv-h-3.6-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h is concave up on the real numbers, because f and g are both concave up.', false, 'Composing two concave up functions does not guarantee concave up; the term f′(g(x))·g″(x) is negative here.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h is concave down on the real numbers, because f is decreasing.', false, 'This confuses decreasing with concave down; h″ = f″(g)(g′)² + f′(g)g″ has a positive and a negative term here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h is concave down on the real numbers, because f′(g(x))·g″(x) < 0 outweighs the other term.', false, 'Nothing in the information shows that the negative term is larger in size than f″(g(x))(g′(x))² for every x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sign of h″ cannot be determined, because the two terms of h″ can have opposite signs.', true, 'Correct: h″ = f″(g)(g′)² + f′(g)g″. Here f″(g)(g′)² > 0 but f′(g)g″ < 0, so the sign of h″ depends on which term is larger, and the information does not decide that.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.6-b-v2', 'mcq', 'decide the concavity of a composite function from the signs of f′, f″, g′ and g″ using h″ = f″(g)(g′)² + f′(g)g″. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The functions f and g are twice differentiable on the real numbers. For all real t, f′(t) > 0 and f″(t) < 0, and for all real x, g′(x) < 0 and g″(x) < 0. Let h(x) = f(g(x)). Which statement about the graph of h is correct?', null, md5('apcalcbc-mcq-b2-sv-h-3.6-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h is concave up on the real numbers, because g′ and g″ are both negative.', false, 'Two negative signs in g do not produce a positive h″; the terms are f″(g)(g′)² < 0 and f′(g)g″ < 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The concavity of h cannot be determined, because g′ < 0 and f″ < 0 have the same sign.', false, 'This drops the square, so f″(g)·g′ would be positive; the actual term f″(g)(g′)² is negative because the square is positive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h is concave up on the real numbers, because f′(g(x))·g″(x) is negative and a negative times f″ is positive.', false, 'Both terms of h″ are negative, so h″ < 0; multiplying by f″ is not part of the term f′(g)g″.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h is concave down on the real numbers, because both terms of h″(x) are negative.', true, 'Correct: h″(x) = f″(g(x))·(g′(x))² + f′(g(x))·g″(x). First term: (negative)(positive) < 0. Second term: (positive)(negative) < 0. So h″ < 0.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.6-b-v3', 'mcq', 'decide the concavity of a composite function from the signs of f′, f″, g′ and g″ using h″ = f″(g)(g′)² + f′(g)g″. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The functions f and g are twice differentiable. At x = 1, g′(1) = −1 and g″(1) = 4, and the values f′(g(1)) = −2 and f″(g(1)) = 3 are known. Let h(x) = f(g(x)). Which statement about h at x = 1 is correct?', null, md5('apcalcbc-mcq-b2-sv-h-3.6-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h″(1) = −11, so the graph of h is concave down at x = 1.', false, 'This does not square g′(1): it uses f″(g)·g′ + f′(g)·g″ = −3 − 8 instead of f″(g)(g′)² + f′(g)g″.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h″(1) = −5, so the graph of h is concave down at x = 1.', true, 'Correct: h″ = f″(g(x))·(g′(x))² + f′(g(x))·g″(x) = 3·(−1)² + (−2)(4) = 3 − 8 = −5 < 0, so h is concave down at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h″(1) = 12, so the graph of h is concave up at x = 1.', false, 'This multiplies the two second derivatives, f″(g(1))·g″(1), which ignores the chain and product rules.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h″(1) = 3, so the graph of h is concave up at x = 1.', false, 'This keeps only f″(g(1))·(g′(1))² and drops the term f′(g(1))·g″(1) = −8.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-sv-h-3.6-b-v1','apcalcbc-mcq-b2-sv-h-3.6-b-v2','apcalcbc-mcq-b2-sv-h-3.6-b-v3']) and status='draft')<>3 then raise exception 'chunk 6: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b2-sv-h-3.6-b-v1','apcalcbc-mcq-b2-sv-h-3.6-b-v2','apcalcbc-mcq-b2-sv-h-3.6-b-v3']))<>12 then raise exception 'chunk 6: expected 12 choices'; end if;
end $$;
commit;
