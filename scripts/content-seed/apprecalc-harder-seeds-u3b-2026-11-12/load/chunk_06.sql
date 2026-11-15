begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-sv-h-3.9-b-v1','apprecalc-mcq-b2-sv-h-3.9-b-v2','apprecalc-mcq-b2-sv-h-3.9-b-v3'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apprecalc-mcq-b2-sv-h-3.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.9-b-v1', 'mcq', 'evaluate a trigonometric function of an inverse trigonometric value, using the principal range to fix the sign. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the exact value of cos(arcsin(−5/13))?', null, md5('apprecalc-mcq-b2-sv-h-3.9-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12/13', false, 'This gives cosine a negative sign because the sine is negative, but arcsin returns an angle in [−π/2, π/2], where cosine is never negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/13', false, 'This takes the magnitude of the given ratio, but the cosine is found from cos² = 1 − sin², giving 12/13.' from version_ins
union all select gen_random_uuid(), id, 'C', '13/12', false, 'This is the reciprocal of the correct value 12/13, which would be the secant, not the cosine.' from version_ins
union all select gen_random_uuid(), id, 'D', '12/13', true, 'Correct: Let θ = arcsin(−5/13), in [−π/2, π/2]; sin θ = −5/13, so cos θ = √(1 − 25/169) = 12/13, positive in the fourth quadrant.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.9-b-v2', 'mcq', 'evaluate a trigonometric function of an inverse trigonometric value, using the principal range to fix the sign. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the exact value of tan(arccos(−4/5))?', null, md5('apprecalc-mcq-b2-sv-h-3.9-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/4', false, 'This drops the negative sign; the angle is in the second quadrant, where sine is positive and cosine is negative, so tangent is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '−4/3', false, 'This inverts the ratio, using adjacent over opposite; tangent is sine divided by cosine, which is (3/5)/(−4/5).' from version_ins
union all select gen_random_uuid(), id, 'C', '3/5', false, 'This is the sine of the angle, not the tangent; the tangent is the sine divided by the cosine.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3/4', true, 'Correct: Let θ = arccos(−4/5), in [0, π]; cos θ = −4/5, sin θ = 3/5 (positive), so tan θ = (3/5)/(−4/5) = −3/4.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.9-b-v3', 'mcq', 'evaluate a trigonometric function of an inverse trigonometric value, using the principal range to fix the sign. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the exact value of sin(arctan(−3/4))?', null, md5('apprecalc-mcq-b2-sv-h-3.9-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/5', false, 'This drops the negative sign; arctan(−3/4) is in the fourth quadrant, where sine is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3/5', true, 'Correct: Let θ = arctan(−3/4), in (−π/2, π/2); the legs are −3 and 4 with hypotenuse 5, so sin θ = −3/5.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3/4', false, 'This is the tangent of the angle itself; the sine is the opposite side over the hypotenuse 5, which is −3/5.' from version_ins
union all select gen_random_uuid(), id, 'D', '−4/5', false, 'This is the cosine''s magnitude with a negative sign; the sine is the opposite side −3 over the hypotenuse 5.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-sv-h-3.9-b-v1','apprecalc-mcq-b2-sv-h-3.9-b-v2','apprecalc-mcq-b2-sv-h-3.9-b-v3']) and status='draft')<>3 then raise exception 'chunk 6: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b2-sv-h-3.9-b-v1','apprecalc-mcq-b2-sv-h-3.9-b-v2','apprecalc-mcq-b2-sv-h-3.9-b-v3']))<>12 then raise exception 'chunk 6: expected 12 choices'; end if;
end $$;
commit;
