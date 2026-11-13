begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4b-sv-h-4.14-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apprecalc-mcq-b4b-sv-h-4.14-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.14-a-v3', 'mcq', '4.14-A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A town''s voters prefer party P or party Q. Each election 70% of P voters stay with P and 30% switch to Q; 40% of Q voters switch to P and 60% stay. With state vector [P; Q], the update matrix is M = [0.7 0.4; 0.3 0.6] (each column describes where that party''s voters go). Currently 800 voters prefer P and 200 prefer Q. What is predicted for [P; Q] after two elections?', null, md5('apprecalc-mcq-b4b-sv-h-4.14-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[592; 408]', true, 'Correct: one step gives [640; 360]; a second application of M gives [592; 408]; the total 1000 is unchanged.' from version_ins
union all select gen_random_uuid(), id, 'B', '[640; 360]', false, 'This is the prediction after only one step, M times the starting vector; the question asks for two steps, which means applying M a second time.' from version_ins
union all select gen_random_uuid(), id, 'C', '[566; 512]', false, 'This multiplies by the transpose of M, treating rows as the ''from'' groups; here each column of M describes where one group goes, so rows and columns were confused.' from version_ins
union all select gen_random_uuid(), id, 'D', '[424; 144]', false, 'This squares each entry of M separately; M² is the matrix product M·M, and squared entries do not even keep the total population constant.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4b-sv-h-4.14-a-v3']) and status='draft')<>1 then raise exception 'chunk 4: expected 1 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b4b-sv-h-4.14-a-v3']))<>4 then raise exception 'chunk 4: expected 4 choices'; end if;
end $$;
commit;
