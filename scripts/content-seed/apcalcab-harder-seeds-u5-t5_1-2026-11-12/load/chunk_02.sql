begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b8-sv-h-5.1-c-v1','apcalcab-mcq-b8-sv-h-5.1-c-v2','apcalcab-mcq-b8-sv-h-5.1-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b8-sv-h-5.1-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-sv-h-5.1-c-v1', 'mcq', 'interpret average and instantaneous rate (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A tank''s water volume rises from 20 to 68 liters over four minutes. Volume is continuous over the closed interval and differentiable inside. An observer says inflow was always under 10 liters per minute. What does MVT imply?', null, md5('apcalcab-mcq-b8-sv-h-5.1-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An interior instant has rate 10 liters per minute, confirming the claim.', false, 'The 48-liter increase over four minutes yields 12, not 10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The volume must rise at 12 liters per minute during every minute.', false, 'MVT supplies at least one instant, not a constant rate over the full interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only endpoint rates can be inferred, so the claim cannot be evaluated.', false, 'The theorem yields an interior rate from endpoints and regularity, not an endpoint derivative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'An interior instant has volume-change rate 12 liters per minute, contradicting the claimed upper bound.', true, 'Correct: The average change is (68-20)/4=12 liters per minute; MVT guarantees an interior derivative of 12, which exceeds the claimed upper bound 10.' from version_ins;
-- apcalcab-mcq-b8-sv-h-5.1-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-sv-h-5.1-c-v2', 'mcq', 'interpret average and instantaneous rate (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuously differentiable cooling object''s temperature falls from 80 to 56 degrees over six minutes. A sensor report claims its temperature-change rate was always greater than -3 degrees per minute. Which conclusion is justified?', null, md5('apcalcab-mcq-b8-sv-h-5.1-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'MVT gives +4 degrees per minute because temperature is positive.', false, 'The signed rate is negative because temperature decreased, despite positive temperature values.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The report is consistent because -4 is greater than -3.', false, 'On the number line -4 is less than -3, contradicting an always-greater-than--3 report.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The rate must have been exactly -4 throughout the six minutes.', false, 'MVT guarantees one matching instant, not a constant rate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'MVT guarantees an interior temperature-change rate of -4 degrees per minute, so the report is inconsistent.', true, 'Correct: The average change is (56-80)/6=-4 degrees per minute. At some interior time the instantaneous derivative equals -4, which is not greater than -3.' from version_ins;
-- apcalcab-mcq-b8-sv-h-5.1-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-sv-h-5.1-c-v3', 'mcq', 'interpret average and instantaneous rate (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A plant''s measured height increases from 8 to 23 centimeters in five days. Assume height is continuous and differentiable on the required intervals. Which claim is guaranteed by MVT, and which is not?', null, md5('apcalcab-mcq-b8-sv-h-5.1-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The growth rate equals 3 centimeters per day on every day.', false, 'An average rate does not imply the same instantaneous rate throughout the interval.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The growth rate equals 15 centimeters per day at the fifth-day endpoint.', false, 'The total increase is 15 centimeters, not a per-day rate, and an endpoint derivative is not guaranteed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At least one interior instant has growth rate 3 centimeters per day; the theorem does not say when or that the rate stays 3.', true, 'Correct: The secant slope is (23-8)/5=3 centimeters per day. MVT guarantees at least one interior derivative equal to that average, without fixing its time or constancy.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No instantaneous rate can be inferred without knowing the formula for height.', false, 'MVT needs endpoints and its regularity hypotheses, not an explicit height formula.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b8-sv-h-5.1-c-v1','apcalcab-mcq-b8-sv-h-5.1-c-v2','apcalcab-mcq-b8-sv-h-5.1-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b8-sv-h-5.1-c-v1','apcalcab-mcq-b8-sv-h-5.1-c-v2','apcalcab-mcq-b8-sv-h-5.1-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
