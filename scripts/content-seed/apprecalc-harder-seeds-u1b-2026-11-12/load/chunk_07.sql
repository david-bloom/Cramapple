begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-sv-h-1.14-b-v2','apprecalc-mcq-b9-sv-h-1.14-b-v3'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apprecalc-mcq-b9-sv-h-1.14-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.14-b-v2', 'mcq', 'construct an average-cost model with a fixed amount and a per-person amount, solve an inequality for the number of peopl (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A class trip has a bus fee of $650 plus $8 per student for tickets, so the cost per student for n students is A(n) = 8 + 650/n dollars. What is the smallest whole number of students n for which the cost per student is at most $15?', null, md5('apprecalc-mcq-b9-sv-h-1.14-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '92', false, 'This rounds 650/7 down. At n = 92 the average is 8 + 650/92 ≈ 15.07, which is still above 15, so the goal is not met until the next whole number.' from version_ins
union all select gen_random_uuid(), id, 'B', '29', false, 'This adds the per-student cost to the target instead of subtracting it, dividing 650 by 23. The fixed amount only has to be covered by the part of the target left after the per-student cost, 7.' from version_ins
union all select gen_random_uuid(), id, 'C', '44', false, 'This divides the fixed cost by the whole target of 15, ignoring that each student also pays 8 directly. Only 7 per student is left to cover the fixed cost, so 650/7 is needed.' from version_ins
union all select gen_random_uuid(), id, 'D', '93', true, 'Correct: The average per student is A(n) = 8 + 650/n. A(n) ≤ 15 gives 650/n ≤ 7, so n ≥ 650/7 ≈ 92.86; n must be a whole number, so the smallest is 93.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.14-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.14-b-v3', 'mcq', 'construct an average-cost model with a fixed amount and a per-person amount, solve an inequality for the number of peopl (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bakery buys a mixer for $750 and spends $3 in ingredients per batch. The average cost per batch over n batches is B(n) = 3 + 750/n dollars. What is the smallest whole number of batches n for which the average cost per batch is at most $10?', null, md5('apprecalc-mcq-b9-sv-h-1.14-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '107', false, 'This rounds 750/7 down. At n = 107 the average is 3 + 750/107 ≈ 10.01, which is still above 10, so the goal is not met until the next whole number.' from version_ins
union all select gen_random_uuid(), id, 'B', '108', true, 'Correct: The average per batch is A(n) = 3 + 750/n. A(n) ≤ 10 gives 750/n ≤ 7, so n ≥ 750/7 ≈ 107.14; n must be a whole number, so the smallest is 108.' from version_ins
union all select gen_random_uuid(), id, 'C', '58', false, 'This adds the per-batch cost to the target instead of subtracting it, dividing 750 by 13. The fixed amount only has to be covered by the part of the target left after the per-batch cost, 7.' from version_ins
union all select gen_random_uuid(), id, 'D', '75', false, 'This divides the fixed cost by the whole target of 10, ignoring that each batch also pays 3 directly. Only 7 per batch is left to cover the fixed cost, so 750/7 is needed.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-sv-h-1.14-b-v2','apprecalc-mcq-b9-sv-h-1.14-b-v3']) and status='draft')<>2 then raise exception 'chunk 7: expected 2 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b9-sv-h-1.14-b-v2','apprecalc-mcq-b9-sv-h-1.14-b-v3']))<>8 then raise exception 'chunk 7: expected 8 choices'; end if;
end $$;
commit;
