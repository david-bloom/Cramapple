begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.8-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apcalcab-mcq-b6-sv-h-1.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.8-b-v3', 'mcq', 'identify where two quadratic bounds meet so the Squeeze Theorem applies, and recognize it applies nowhere else (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies x² − 6x ≤ f(x) ≤ 3x² − 2x + 2 for all x. For which values of a can the Squeeze Theorem be used to find lim(x→a) f(x) from these bounds, and what is the limit?', null, md5('apcalcab-mcq-b6-sv-h-1.8-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'For every a, because f lies between two continuous functions.', false, 'A limit is forced only where both bounds approach the same value. Away from x = −1 the bounds disagree.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only for a = 0, where the bounds equal 0 and 2.', false, 'The Squeeze Theorem needs equal limits for the two bounds. At x = 0 they are 0 and 2, which differ.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only for a = −1, where both bounds equal 7, so the limit is 7.', true, 'Correct: The bounds differ by (3x² − 2x + 2) − (x² − 6x) = 2(x + 1)², which is zero only at x = −1. There both bounds equal 7, so the limit is 7. At other values of a the bounds differ.' from version_ins
union all select gen_random_uuid(), id, 'D', 'For no value of a, because the two bounds are different functions.', false, 'Bounds may be different functions provided they approach the same value at the point. At x = −1 both approach 7.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.8-b-v3']) and status='draft')<>1 then raise exception 'chunk 8: expected 1 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b6-sv-h-1.8-b-v3']))<>4 then raise exception 'chunk 8: expected 4 choices'; end if;
end $$;
commit;
