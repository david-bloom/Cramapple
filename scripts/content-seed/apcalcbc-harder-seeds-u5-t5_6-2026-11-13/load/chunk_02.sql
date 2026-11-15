begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b13-sv-h-5.6-c-v1','apcalcbc-mcq-b13-sv-h-5.6-c-v2','apcalcbc-mcq-b13-sv-h-5.6-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b13-sv-h-5.6-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-sv-h-5.6-c-v1', 'mcq', 'exclude domain gaps from inflection points (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function g is twice differentiable for all real x except x=-1 and satisfies g''''(x)=-1(x−(-3))(x−(2))/(x−(-1))² on that domain, with -3<-1<2. The function has no value at x=-1. Which statement correctly describes concavity and inflection points?', null, md5('apcalcbc-mcq-b13-sv-h-5.6-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g has inflection points at x=-3, x=-1, and x=2 because the displayed formula is zero or undefined at all three.', false, 'An inflection point must lie on the graph; g is undefined at the domain gap.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is concave up outside (-3,2) and concave down between the roots because the squared denominator is negative there.', false, 'A nonzero square is positive, so it does not reverse the numerator''s sign pattern.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g has no inflection points because its domain is disconnected at x=-1.', false, 'The domain gap does not prevent concavity from changing at the included points x=a and x=b.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is concave down for x<-3 and x>2, concave up on (-3,-1) and (-1,2), and has inflection points at x=-3 and x=2 only.', true, 'Correct: The squared denominator is positive wherever defined. The numerator has sign negative, positive, negative across -3,2; the gap at -1 is not a point on the graph.' from version_ins;
-- apcalcbc-mcq-b13-sv-h-5.6-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-sv-h-5.6-c-v2', 'mcq', 'exclude domain gaps from inflection points (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function g is twice differentiable for all real x except x=1 and satisfies g''''(x)=2(x−(-1))(x−(4))/(x−(1))² on that domain, with -1<1<4. The function has no value at x=1. Which statement correctly describes concavity and inflection points?', null, md5('apcalcbc-mcq-b13-sv-h-5.6-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g has inflection points at x=-1, x=1, and x=4 because the displayed formula is zero or undefined at all three.', false, 'An inflection point must lie on the graph; g is undefined at the domain gap.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is concave down outside (-1,4) and concave up between the roots because the squared denominator is negative there.', false, 'A nonzero square is positive, so it does not reverse the numerator''s sign pattern.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g has no inflection points because its domain is disconnected at x=1.', false, 'The domain gap does not prevent concavity from changing at the included points x=a and x=b.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is concave up for x<-1 and x>4, concave down on (-1,1) and (1,4), and has inflection points at x=-1 and x=4 only.', true, 'Correct: The squared denominator is positive wherever defined. The numerator has sign positive, negative, positive across -1,4; the gap at 1 is not a point on the graph.' from version_ins;
-- apcalcbc-mcq-b13-sv-h-5.6-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-sv-h-5.6-c-v3', 'mcq', 'exclude domain gaps from inflection points (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function g is twice differentiable for all real x except x=2 and satisfies g''''(x)=-2(x−(0))(x−(5))/(x−(2))² on that domain, with 0<2<5. The function has no value at x=2. Which statement correctly describes concavity and inflection points?', null, md5('apcalcbc-mcq-b13-sv-h-5.6-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g has inflection points at x=0, x=2, and x=5 because the displayed formula is zero or undefined at all three.', false, 'An inflection point must lie on the graph; g is undefined at the domain gap.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is concave up outside (0,5) and concave down between the roots because the squared denominator is negative there.', false, 'A nonzero square is positive, so it does not reverse the numerator''s sign pattern.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is concave down for x<0 and x>5, concave up on (0,2) and (2,5), and has inflection points at x=0 and x=5 only.', true, 'Correct: The squared denominator is positive wherever defined. The numerator has sign negative, positive, negative across 0,5; the gap at 2 is not a point on the graph.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g has no inflection points because its domain is disconnected at x=2.', false, 'The domain gap does not prevent concavity from changing at the included points x=a and x=b.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b13-sv-h-5.6-c-v1','apcalcbc-mcq-b13-sv-h-5.6-c-v2','apcalcbc-mcq-b13-sv-h-5.6-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b13-sv-h-5.6-c-v1','apcalcbc-mcq-b13-sv-h-5.6-c-v2','apcalcbc-mcq-b13-sv-h-5.6-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
