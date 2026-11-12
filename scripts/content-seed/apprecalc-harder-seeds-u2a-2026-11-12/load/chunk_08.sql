begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.8-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apprecalc-mcq-b7-sv-h-2.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.8-b-v3', 'mcq', 'evaluate an expression combining an inverse with function values from a table, applying the inverse to the combined outp (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is one-to-one with domain {1, 2, 3, 4, 5}, and f(1) = 8, f(2) = 4, f(3) = 5, f(4) = 9, f(5) = 6. What is the value of f⁻¹(f(4) − f(3))?', null, md5('apprecalc-mcq-b7-sv-h-2.8-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9', false, 'This applies f to the result instead of f⁻¹. The expression asks for the input that f sends to 4, which is 2, not the output f(4) = 9.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This distributes f⁻¹ over the difference, computing f⁻¹(f(4)) − f⁻¹(f(3)) = 4 − 3. Inverse functions do not distribute over subtraction: the quantity 9 − 5 = 4 must be computed first, and then f⁻¹ applied to it.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', true, 'Correct: f(4) − f(3) = 9 − 5 = 4. Since f(2) = 4, f⁻¹(4) = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This stops after combining the outputs, f(4) − f(3) = 9 − 5 = 4. The question asks for f⁻¹ of that value, the input x with f(x) = 4, and that input is 2.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.8-b-v3']) and status='draft')<>1 then raise exception 'chunk 8: expected 1 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b7-sv-h-2.8-b-v3']))<>4 then raise exception 'chunk 8: expected 4 choices'; end if;
end $$;
commit;
