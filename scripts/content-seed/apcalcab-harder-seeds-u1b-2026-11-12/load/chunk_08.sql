begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.16-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apcalcab-mcq-b7-sv-h-1.16-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.16-b-v3', 'mcq', 'decide for which interval the Intermediate Value Theorem, applied to the endpoint values of a polynomial, guarantees a z (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let p(x) = x⁴ − 5x² + 2, which is continuous for all x. For which of the following intervals do the values of p at the endpoints let the Intermediate Value Theorem guarantee a zero of p in the interval?', null, md5('apcalcab-mcq-b7-sv-h-1.16-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[−1, 1]', false, 'Here p(−1) = −2 and p(1) = −2 have the same sign, so the theorem gives no guarantee, even though p has two zeros inside the interval.' from version_ins
union all select gen_random_uuid(), id, 'B', '[−2, −1]', false, 'Here p(−2) = −2 and p(−1) = −2 are both negative, so no sign change is shown.' from version_ins
union all select gen_random_uuid(), id, 'C', '[2, 3]', true, 'Correct: p(2) = 16 − 20 + 2 = −2 < 0 and p(3) = 81 − 45 + 2 = 38 > 0, so there is a zero in (2, 3).' from version_ins
union all select gen_random_uuid(), id, 'D', '[1, 2]', false, 'Here p(1) = −2 and p(2) = −2 are both negative, so no sign change is shown.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.16-b-v3']) and status='draft')<>1 then raise exception 'chunk 8: expected 1 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b7-sv-h-1.16-b-v3']))<>4 then raise exception 'chunk 8: expected 4 choices'; end if;
end $$;
commit;
