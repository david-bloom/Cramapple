begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b19-sv-h-5.12-c-v1','apcalcab-mcq-b19-sv-h-5.12-c-v2','apcalcab-mcq-b19-sv-h-5.12-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b19-sv-h-5.12-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b19-sv-h-5.12-c-v1', 'mcq', 'ellipse second derivative and maximum (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Near (0,2), the ellipse x²+4y²=16 defines an upper-branch function y(x). Find y'''' at x=0 and use it to classify the point (0,2) on that branch.', null, md5('apcalcab-mcq-b19-sv-h-5.12-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y''''(0)=+1/8; (0,2) is a local minimum of the upper branch.', false, 'The sign is negative, so the upper branch has a local maximum, not a minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y''''(0)=−1/2; (0,2) is a local maximum of the upper branch.', false, 'This misses the factor 4 multiplying y² in the original relation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y''''(0)=0; (0,2) is neither a maximum nor a minimum.', false, 'A horizontal tangent can still be a maximum; the implicit second derivative is nonzero and negative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y''''(0)=−1/8; (0,2) is a local maximum of the upper branch.', true, 'Correct: Differentiate to get 2x+8yy''=0, so y''(0)=0. Differentiate again: 2+8[(y'')²+yy'''']=0. At (0,2), y''''=−2/(8·2)=−1/8<0, making this stationary point a local maximum on the upper branch.' from version_ins;
-- apcalcab-mcq-b19-sv-h-5.12-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b19-sv-h-5.12-c-v2', 'mcq', 'ellipse second derivative and maximum (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Near (0,3), the ellipse x²+4y²=36 defines an upper-branch function y(x). Find y'''' at x=0 and use it to classify the point (0,3) on that branch.', null, md5('apcalcab-mcq-b19-sv-h-5.12-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y''''(0)=+1/12; (0,3) is a local minimum of the upper branch.', false, 'The sign is negative, so the upper branch has a local maximum, not a minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y''''(0)=−1/3; (0,3) is a local maximum of the upper branch.', false, 'This misses the factor 4 multiplying y² in the original relation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y''''(0)=0; (0,3) is neither a maximum nor a minimum.', false, 'A horizontal tangent can still be a maximum; the implicit second derivative is nonzero and negative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y''''(0)=−1/12; (0,3) is a local maximum of the upper branch.', true, 'Correct: Differentiate to get 2x+8yy''=0, so y''(0)=0. Differentiate again: 2+8[(y'')²+yy'''']=0. At (0,3), y''''=−2/(8·3)=−1/12<0, making this stationary point a local maximum on the upper branch.' from version_ins;
-- apcalcab-mcq-b19-sv-h-5.12-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b19-sv-h-5.12-c-v3', 'mcq', 'ellipse second derivative and maximum (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Near (0,4), the ellipse x²+4y²=64 defines an upper-branch function y(x). Find y'''' at x=0 and use it to classify the point (0,4) on that branch.', null, md5('apcalcab-mcq-b19-sv-h-5.12-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y''''(0)=+1/16; (0,4) is a local minimum of the upper branch.', false, 'The sign is negative, so the upper branch has a local maximum, not a minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y''''(0)=−1/4; (0,4) is a local maximum of the upper branch.', false, 'This misses the factor 4 multiplying y² in the original relation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y''''(0)=−1/16; (0,4) is a local maximum of the upper branch.', true, 'Correct: Differentiate to get 2x+8yy''=0, so y''(0)=0. Differentiate again: 2+8[(y'')²+yy'''']=0. At (0,4), y''''=−2/(8·4)=−1/16<0, making this stationary point a local maximum on the upper branch.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y''''(0)=0; (0,4) is neither a maximum nor a minimum.', false, 'A horizontal tangent can still be a maximum; the implicit second derivative is nonzero and negative.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b19-sv-h-5.12-c-v1','apcalcab-mcq-b19-sv-h-5.12-c-v2','apcalcab-mcq-b19-sv-h-5.12-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b19-sv-h-5.12-c-v1','apcalcab-mcq-b19-sv-h-5.12-c-v2','apcalcab-mcq-b19-sv-h-5.12-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
