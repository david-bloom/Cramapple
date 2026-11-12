begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.16-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b7-sv-h-1.16-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.16-b-v3', 'mcq', 'choose the interval on which the Intermediate Value Theorem actually applies to an equation, checking both continuity an (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following intervals can be used with the Intermediate Value Theorem to guarantee a solution of x·ln x = 3?', null, md5('apcalcbc-mcq-b7-sv-h-1.16-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, 3]', false, 'The function x ln x is not defined at x = 0, so h is not continuous on the closed interval [0, 3] and the theorem cannot be used there.' from version_ins
union all select gen_random_uuid(), id, 'B', '[1, 2]', false, 'Here h(1) = −3 and h(2) ≈ −1.61 are both negative, so there is no sign change.' from version_ins
union all select gen_random_uuid(), id, 'C', '[2, 3]', true, 'Correct: Let h(x) = x ln x − 3. h(1) = −3, h(2) ≈ −1.61, h(3) ≈ 0.30, h(4) ≈ 2.55. Only [2, 3] has a sign change; h is continuous for x > 0 and not defined at 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '[3, 4]', false, 'Here h(3) ≈ 0.30 and h(4) ≈ 2.55 are both positive, so no sign change.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.16-b-v3']) and status='draft')<>1 then raise exception 'chunk 8: expected 1 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b7-sv-h-1.16-b-v3']))<>4 then raise exception 'chunk 8: expected 4 choices'; end if;
end $$;
commit;
