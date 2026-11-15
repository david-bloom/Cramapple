begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-h-3.3-a-v2','apprecalc-mcq-sv-h-3.3-a-v3','apprecalc-mcq-h-3.3-b','apprecalc-mcq-sv-h-3.3-b-v1','apprecalc-mcq-sv-h-3.3-b-v2','apprecalc-mcq-sv-h-3.3-b-v3'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-h-3.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.3-a-v2', 'mcq', 'Solve for angles from a sine or cosine value (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval [0, 2π), sin θ = 1/2 and cos θ < 0. What is θ?', null, md5('apprecalc-mcq-sv-h-3.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/6', false, 'Π/6 has sin θ = 1/2, but its cosine is positive, so it fails the second condition.' from version_ins
union all select gen_random_uuid(), id, 'B', '7π/6', false, '7π/6 has cosine negative but sine −1/2, so it fails the first condition.' from version_ins
union all select gen_random_uuid(), id, 'C', '11π/6', false, '11π/6 has sine −1/2 and cosine positive, so it fails both conditions.' from version_ins
union all select gen_random_uuid(), id, 'D', '5π/6', true, 'Correct: sin θ = 1/2 gives π/6 and 5π/6; cosine is negative only in Quadrant II, so θ = 5π/6.' from version_ins;
-- apprecalc-mcq-sv-h-3.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.3-a-v3', 'mcq', 'Solve for angles from a sine or cosine value (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'How many solutions does the equation cos θ = 1/2 have on the interval [0, 4π)?', null, md5('apprecalc-mcq-sv-h-3.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'This counts only the solutions on one revolution, but the interval covers two.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', true, 'Correct: on [0, 2π) the solutions are π/3 and 5π/3, and adding 2π gives 7π/3 and 11π/3, for 4 in total.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'The solutions come in pairs, one in Quadrant I and one in Quadrant IV on each revolution, so an odd count is impossible.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'There are exactly two solutions per revolution, not three.' from version_ins;
-- apprecalc-mcq-h-3.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-h-3.3-b', 'mcq', 'Symmetry and shift identities', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let θ be an angle with 0 < θ < π/2 and sin θ = 3/5. What is the value of cos(θ + π)?', null, md5('apprecalc-mcq-h-3.3-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4/5', false, 'Adding π reverses the direction of the point on the unit circle, so the cosine changes sign.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3/5', false, 'Cos(θ + π) is −cos θ, which is not −sin θ.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/5', false, 'Cos(θ + π) is the negative of cos θ, so it is not sin θ.' from version_ins
union all select gen_random_uuid(), id, 'D', '−4/5', true, 'Correct: cos θ = 4/5 in Quadrant I, and cos(θ + π) = −cos θ = −4/5.' from version_ins;
-- apprecalc-mcq-sv-h-3.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.3-b-v1', 'mcq', 'Symmetry and shift identities (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let θ be an angle in Quadrant II with cos θ = −5/13. What is the value of sin(π − θ)?', null, md5('apprecalc-mcq-sv-h-3.3-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12/13', false, 'Sin(π − θ) equals sin θ, and sine is positive in Quadrant II, so it is not negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/13', false, 'This is −cos θ, which is the value of cos(π − θ), not of sin(π − θ).' from version_ins
union all select gen_random_uuid(), id, 'C', '−5/13', false, 'This is cos θ itself, but the question asks for a sine.' from version_ins
union all select gen_random_uuid(), id, 'D', '12/13', true, 'Correct: sin θ = 12/13 in Quadrant II, and sin(π − θ) = sin θ = 12/13.' from version_ins;
-- apprecalc-mcq-sv-h-3.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.3-b-v2', 'mcq', 'Symmetry and shift identities (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let θ be an angle in Quadrant III with sin θ = −4/5. What is the value of cos(θ − π)?', null, md5('apprecalc-mcq-sv-h-3.3-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/5', true, 'Correct: cos θ = −3/5 in Quadrant III, and cos(θ − π) = −cos θ = 3/5.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3/5', false, 'This is cos θ itself, but shifting by π changes the sign.' from version_ins
union all select gen_random_uuid(), id, 'C', '4/5', false, 'This is −sin θ, and it is not the cosine of the shifted angle.' from version_ins
union all select gen_random_uuid(), id, 'D', '−4/5', false, 'This is sin θ itself, and the question asks for a cosine.' from version_ins;
-- apprecalc-mcq-sv-h-3.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.3-b-v3', 'mcq', 'Symmetry and shift identities (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let θ be an angle in Quadrant IV with cos θ = 4/5. What is the value of sin(−θ)?', null, md5('apprecalc-mcq-sv-h-3.3-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3/5', false, 'This is sin θ itself, but reflecting the angle changes the sign of sine.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/5', true, 'Correct: sin θ = −3/5 in Quadrant IV, and sin(−θ) = −sin θ = 3/5.' from version_ins
union all select gen_random_uuid(), id, 'C', '4/5', false, 'This is cos θ, and cos(−θ) = cos θ, not sin(−θ).' from version_ins
union all select gen_random_uuid(), id, 'D', '−4/5', false, 'This is −cos θ, which does not equal sin(−θ).' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-h-3.3-a-v2','apprecalc-mcq-sv-h-3.3-a-v3','apprecalc-mcq-h-3.3-b','apprecalc-mcq-sv-h-3.3-b-v1','apprecalc-mcq-sv-h-3.3-b-v2','apprecalc-mcq-sv-h-3.3-b-v3']) and status='draft')<>6 then raise exception 'chunk 3: expected 6 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-sv-h-3.3-a-v2','apprecalc-mcq-sv-h-3.3-a-v3','apprecalc-mcq-h-3.3-b','apprecalc-mcq-sv-h-3.3-b-v1','apprecalc-mcq-sv-h-3.3-b-v2','apprecalc-mcq-sv-h-3.3-b-v3']))<>24 then raise exception 'chunk 3: expected 24 choices'; end if;
end $$;
commit;
