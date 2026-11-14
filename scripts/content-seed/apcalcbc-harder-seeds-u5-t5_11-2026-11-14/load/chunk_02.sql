begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b18-sv-h-5.11-c-v1','apcalcbc-mcq-b18-sv-h-5.11-c-v2','apcalcbc-mcq-b18-sv-h-5.11-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b18-sv-h-5.11-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b18-sv-h-5.11-c-v1', 'mcq', 'linear-demand maximum profit (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A shop can sell q=120−3p items per week when each sells for p dollars, where demand is positive. The variable cost is $8 per item and there is no fixed cost. Which price maximizes weekly profit, and what maximum profit does the model predict?', null, md5('apcalcbc-mcq-b18-sv-h-5.11-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Price $20; maximum profit equals revenue, so $1200 per week.', false, 'This maximizes revenue p·q but ignores the per-item cost, so it does not maximize profit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Price $8; maximum profit $0 per week.', false, 'Pricing at marginal cost gives zero profit, while the interior critical price gives positive profit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Price $40; maximum profit $0 per week.', false, 'At this price demand is zero, so profit is zero rather than maximal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Price $24; maximum profit $768 per week.', true, 'Correct: Profit is P(p)=(p−8)(120−3p). Its derivative is 144−6p, which is zero at p=24; the second derivative is −6<0. Then q=48 and P=768. This price lies in the feasible positive-demand interval.' from version_ins;
-- apcalcbc-mcq-b18-sv-h-5.11-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b18-sv-h-5.11-c-v2', 'mcq', 'linear-demand maximum profit (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A shop can sell q=80−2p items per week when each sells for p dollars, where demand is positive. The variable cost is $12 per item and there is no fixed cost. Which price maximizes weekly profit, and what maximum profit does the model predict?', null, md5('apcalcbc-mcq-b18-sv-h-5.11-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Price $20; maximum profit equals revenue, so $800 per week.', false, 'This maximizes revenue p·q but ignores the per-item cost, so it does not maximize profit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Price $12; maximum profit $0 per week.', false, 'Pricing at marginal cost gives zero profit, while the interior critical price gives positive profit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Price $40; maximum profit $0 per week.', false, 'At this price demand is zero, so profit is zero rather than maximal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Price $26; maximum profit $392 per week.', true, 'Correct: Profit is P(p)=(p−12)(80−2p). Its derivative is 104−4p, which is zero at p=26; the second derivative is −4<0. Then q=28 and P=392. This price lies in the feasible positive-demand interval.' from version_ins;
-- apcalcbc-mcq-b18-sv-h-5.11-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b18-sv-h-5.11-c-v3', 'mcq', 'linear-demand maximum profit (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A shop can sell q=90−3p items per week when each sells for p dollars, where demand is positive. The variable cost is $10 per item and there is no fixed cost. Which price maximizes weekly profit, and what maximum profit does the model predict?', null, md5('apcalcbc-mcq-b18-sv-h-5.11-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Price $15; maximum profit equals revenue, so $675 per week.', false, 'This maximizes revenue p·q but ignores the per-item cost, so it does not maximize profit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Price $10; maximum profit $0 per week.', false, 'Pricing at marginal cost gives zero profit, while the interior critical price gives positive profit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Price $20; maximum profit $300 per week.', true, 'Correct: Profit is P(p)=(p−10)(90−3p). Its derivative is 120−6p, which is zero at p=20; the second derivative is −6<0. Then q=30 and P=300. This price lies in the feasible positive-demand interval.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Price $30; maximum profit $0 per week.', false, 'At this price demand is zero, so profit is zero rather than maximal.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b18-sv-h-5.11-c-v1','apcalcbc-mcq-b18-sv-h-5.11-c-v2','apcalcbc-mcq-b18-sv-h-5.11-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b18-sv-h-5.11-c-v1','apcalcbc-mcq-b18-sv-h-5.11-c-v2','apcalcbc-mcq-b18-sv-h-5.11-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
