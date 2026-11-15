begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4a-sv-h-4.7-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apprecalc-mcq-b4a-sv-h-4.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.7-a-v3', 'mcq', 'choose a parametrization that traces an entire implicitly defined curve, checking the denominators, shifts and parameter (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which parametrization traces the entire curve x = y² + 1?', null, md5('apprecalc-mcq-b4a-sv-h-4.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = t² + 1, y = t, for all real t', true, 'Correct: With y = t and x = t² + 1, we have x = y² + 1, and y = t takes every real value as t ranges over all reals.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = t², y = t + 1, for all real t', false, 'The shift is placed on the wrong variable: y² + 1 = (t + 1)² + 1 = t² + 2t + 2, which is not equal to x = t².' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = t + 1, y = t², for all real t', false, 'This swaps the roles of x and y: y² + 1 = t⁴ + 1, which is not equal to x = t + 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = t² + 1, y = t, for t ≥ 0', false, 'These equations satisfy the relation, but t ≥ 0 gives y ≥ 0, so only the upper half of the curve is traced.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4a-sv-h-4.7-a-v3']) and status='draft')<>1 then raise exception 'chunk 4: expected 1 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b4a-sv-h-4.7-a-v3']))<>4 then raise exception 'chunk 4: expected 4 choices'; end if;
end $$;
commit;
