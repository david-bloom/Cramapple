begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-sv-h-1.7-b-v2','apprecalc-mcq-b10-sv-h-1.7-b-v3'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apprecalc-mcq-b10-sv-h-1.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.7-b-v2', 'mcq', 'describe the side of the horizontal asymptote y = 0 that a rational function approaches at each end by tracking the sign (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let R(x) = (2 − x)(x + 1) / (x⁴ + 3x² + 1). Which statement describes the end behavior of R?', null, md5('apprecalc-mcq-b10-sv-h-1.7-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R(x) approaches 0 from above as x → ∞ and from above as x → −∞', false, 'This reverses the side on both ends. At x = 1000 the value is about −9.99e−07 and at x = −1000 it is about −1.001e−06, which puts the graph below the axis on the right and below it on the left.' from version_ins
union all select gen_random_uuid(), id, 'B', 'R(x) approaches 0 from above as x → ∞ and from below as x → −∞', false, 'This gets the right end wrong. For a large positive input such as x = 1000 the value of R is about −9.99e−07, which is negative, so the graph is below the x-axis there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'R(x) approaches 0 from below as x → ∞ and from above as x → −∞', false, 'This gets the left end wrong. For a large negative input such as x = −1000 the value of R is about −1.001e−06, which is negative, so the graph is below the x-axis there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'R(x) approaches 0 from below as x → ∞ and from below as x → −∞', true, 'Correct: The denominator has the greater degree, so R(x) → 0. The sign of R for large |x| is the sign of the ratio of leading terms, which gives about −9.99e−07 at x = 1000 and −1.001e−06 at x = −1000, so the graph lies below the x-axis on the right and below it on the left.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.7-b-v3', 'mcq', 'describe the side of the horizontal asymptote y = 0 that a rational function approaches at each end by tracking the sign (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let R(x) = (x − 1)²(2x + 3) / ((x² + 1)(x² − 5)). Which statement describes the end behavior of R?', null, md5('apprecalc-mcq-b10-sv-h-1.7-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R(x) approaches 0 from above as x → ∞ and from above as x → −∞', false, 'This gets the left end wrong. For a large negative input such as x = −1000 the value of R is about −0.002001, which is negative, so the graph is below the x-axis there.' from version_ins
union all select gen_random_uuid(), id, 'B', 'R(x) approaches 0 from above as x → ∞ and from below as x → −∞', true, 'Correct: The denominator has the greater degree, so R(x) → 0. The sign of R for large |x| is the sign of the ratio of leading terms, which gives about 0.001999 at x = 1000 and −0.002001 at x = −1000, so the graph lies above the x-axis on the right and below it on the left.' from version_ins
union all select gen_random_uuid(), id, 'C', 'R(x) approaches 0 from below as x → ∞ and from above as x → −∞', false, 'This reverses the side on both ends. At x = 1000 the value is about 0.001999 and at x = −1000 it is about −0.002001, which puts the graph above the axis on the right and below it on the left.' from version_ins
union all select gen_random_uuid(), id, 'D', 'R(x) approaches 0 from below as x → ∞ and from below as x → −∞', false, 'This gets the right end wrong. For a large positive input such as x = 1000 the value of R is about 0.001999, which is positive, so the graph is above the x-axis there.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-sv-h-1.7-b-v2','apprecalc-mcq-b10-sv-h-1.7-b-v3']) and status='draft')<>2 then raise exception 'chunk 7: expected 2 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b10-sv-h-1.7-b-v2','apprecalc-mcq-b10-sv-h-1.7-b-v3']))<>8 then raise exception 'chunk 7: expected 8 choices'; end if;
end $$;
commit;
