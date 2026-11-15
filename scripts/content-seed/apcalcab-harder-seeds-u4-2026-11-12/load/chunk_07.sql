begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-sv-h-4.7-b-v2','apcalcab-mcq-b4-sv-h-4.7-b-v3'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apcalcab-mcq-b4-sv-h-4.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.7-b-v2', 'mcq', 'recognize when L''Hospital''s Rule is inconclusive because the limit of the derivative quotient does not exist. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement about lim(x→∞) (x² + 2 sin x)/x² is correct?', null, md5('apcalcab-mcq-b4-sv-h-4.7-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist, because L''Hospital''s Rule eventually gives 1 − sin x, which oscillates.', false, 'L''Hospital''s Rule only concludes something when the limit of the derivative quotient exists. Here (x² + 2 sin x)/x² = 1 + 2 sin x/x² → 1 by direct reasoning.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit is 2, because the numerator contains the term 2 sin x.', false, 'The term 2 sin x is bounded and is divided by x², so it contributes 0 in the limit. The quotient equals 1 + 2 sin x/x², which approaches 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit is ∞, because the form ∞/∞ equals ∞.', false, 'The form ∞/∞ is indeterminate and can have any value. Here the quotient equals 1 + 2 sin x/x², which approaches 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit is 1, even though repeated use of L''Hospital''s Rule ends in 1 − sin x, which has no limit.', true, 'Correct: (x² + 2 sin x)/x² = 1 + 2 sin x/x² → 1. L''Hospital: (2x + 2 cos x)/(2x), again ∞/∞: (2 − 2 sin x)/2 = 1 − sin x, which oscillates, so the rule never concludes.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.7-b-v3', 'mcq', 'recognize when L''Hospital''s Rule is inconclusive because the limit of the derivative quotient does not exist. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement about lim(x→∞) (5x + 2 cos x)/(x + 1) is correct?', null, md5('apcalcab-mcq-b4-sv-h-4.7-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist, because L''Hospital''s Rule gives 5 − 2 sin x, which oscillates.', false, 'L''Hospital''s Rule only concludes something when the limit of the derivative quotient exists. Dividing the top and bottom by x shows the limit is 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit is 5, and L''Hospital''s Rule gives no conclusion because the limit of 5 − 2 sin x does not exist.', true, 'Correct: Divide top and bottom by x: (5 + 2 cos x/x)/(1 + 1/x) → 5. L''Hospital''s Rule gives (5 − 2 sin x)/1, which oscillates between 3 and 7, so the rule is inconclusive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit is 3, because L''Hospital''s Rule gives 5 − 2 sin x and sin x approaches 1.', false, 'Sin x does not approach any value as x grows; it keeps oscillating. The bounded term 2 cos x does not change the limit, which is 5 by dividing numerator and denominator by x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit is 0, because cos x is bounded and the denominator grows without bound.', false, 'Only the term 2 cos x/(x + 1) approaches 0. The leading terms 5x and x give a ratio of 5, so the limit is 5, not 0.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-sv-h-4.7-b-v2','apcalcab-mcq-b4-sv-h-4.7-b-v3']) and status='draft')<>2 then raise exception 'chunk 7: expected 2 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b4-sv-h-4.7-b-v2','apcalcab-mcq-b4-sv-h-4.7-b-v3']))<>8 then raise exception 'chunk 7: expected 8 choices'; end if;
end $$;
commit;
