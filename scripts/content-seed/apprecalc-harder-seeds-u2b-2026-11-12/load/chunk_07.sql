begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-sv-h-2.15-b-v2','apprecalc-mcq-b8-sv-h-2.15-b-v3'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apprecalc-mcq-b8-sv-h-2.15-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.15-b-v2', 'mcq', 'interpret the slope of a semi-log line as growth per unit of time and use it to find a doubling or tripling time. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A semi-log plot of log₂(Q) against time in hours for a quantum sensor''s signal is a straight line with slope 0.25. About how many hours does it take to double?', null, md5('apprecalc-mcq-b8-sv-h-2.15-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.25', false, 'This reads the slope itself as the time. The slope is the gain in log₂(Q) per hour, and doubling adds 1 to log₂(Q), so the time is 1 ÷ 0.25.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.2', false, 'This uses log₁₀(2) ≈ 0.301 even though the vertical axis is in base 2. With log₂, doubling adds exactly 1 to log₂(Q), so the time is 1 ÷ slope.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.0', false, 'This divides 2 by the slope, treating the doubling factor 2 as the change in log₂(Q). Doubling adds log₂(2) = 1 to the vertical value, so the time is 1 ÷ 0.25 = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '4.0', true, 'Correct: Doubling adds log₂(2) = 1 to log₂(Q). At 0.25 per hour, the time is 1/0.25 = 4.0 hours.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.15-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.15-b-v3', 'mcq', 'interpret the slope of a semi-log line as growth per unit of time and use it to find a doubling or tripling time. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A semi-log plot of log₁₀(C) against time in years for an invasive plant''s coverage is a straight line with slope 0.12. Using log₁₀(3) ≈ 0.477, about how many years does it take to triple?', null, md5('apprecalc-mcq-b8-sv-h-2.15-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.25', false, 'This divides the slope by 0.477, which is the reverse of the needed quotient. The time is the required change in the log, 0.477, divided by the slope 0.12.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.0', true, 'Correct: The vertical value must rise by log₁₀(3) ≈ 0.477. At 0.12 per year, the time is 0.477/0.12 ≈ 4.0 years.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.3', false, 'This divides 1 by the slope, which would give the time for a tenfold increase. Tripling adds log₁₀(3) ≈ 0.477 to the vertical value, not 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '25.0', false, 'This divides 3 by the slope, using the factor 3 as if it were the change in the logarithm. The required change is log₁₀(3) ≈ 0.477.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-sv-h-2.15-b-v2','apprecalc-mcq-b8-sv-h-2.15-b-v3']) and status='draft')<>2 then raise exception 'chunk 7: expected 2 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b8-sv-h-2.15-b-v2','apprecalc-mcq-b8-sv-h-2.15-b-v3']))<>8 then raise exception 'chunk 7: expected 8 choices'; end if;
end $$;
commit;
