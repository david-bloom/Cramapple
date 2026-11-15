begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-sv-h-3.15-b-v1','apprecalc-mcq-b3-sv-h-3.15-b-v2','apprecalc-mcq-b3-sv-h-3.15-b-v3'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apprecalc-mcq-b3-sv-h-3.15-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.15-b-v1', 'mcq', 'compute the average rate of change of a signed polar radius and interpret it together with the sign of r, including when (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polar function r = f(θ) is continuous and strictly increasing on [π/4, π], with f(π/4) = −3 and f(π) = 6. Which statement is correct?', null, md5('apprecalc-mcq-b3-sv-h-3.15-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average rate of change of r is 12/π per radian, and the distance of the plotted point from the pole increases throughout the interval.', false, 'This finds the rate correctly but claims the distance increases throughout, reading the increase in r as a move away from the pole even where r is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average rate of change of r is 12/π per radian, and the distance of the plotted point from the pole decreases throughout the interval.', false, 'This finds the rate correctly but claims the distance decreases throughout, ignoring that r becomes positive and then moves farther from the pole.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average rate of change of r is 4/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.', false, 'This finds the change in distance, (6 − 3)/(3π/4), instead of the change in r itself, (6 − (−3))/(3π/4); the average rate of change is for r, signed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average rate of change of r is 12/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.', true, 'Correct: The average rate of change is (6 − (−3))/(π − π/4) = 9/(3π/4) = 12/π. Since r is continuous and increasing from −3 to 6, it passes through 0 once: |r| falls from 3 to 0 and then rises to 6.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.15-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.15-b-v2', 'mcq', 'compute the average rate of change of a signed polar radius and interpret it together with the sign of r, including when (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polar function r = f(θ) is continuous and strictly decreasing on [0, 2π/3], with f(0) = 5 and f(2π/3) = −1. Which statement is correct?', null, md5('apprecalc-mcq-b3-sv-h-3.15-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average rate of change of r is −9/π per radian, and the distance of the plotted point from the pole decreases throughout the interval.', false, 'This finds the rate correctly but claims the distance decreases throughout, reading the negative rate as a move toward the pole even after r becomes negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average rate of change of r is −9/π per radian, and the distance of the plotted point from the pole increases throughout the interval.', false, 'This finds the rate correctly but claims the distance increases throughout, ignoring that r starts at 5 and falls toward 0 before the sign change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average rate of change of r is −6/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.', false, 'This finds the change in distance, (1 − 5)/(2π/3), instead of the change in r itself, (−1 − 5)/(2π/3); the average rate of change is for r, signed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average rate of change of r is −9/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.', true, 'Correct: The average rate of change is (−1 − 5)/(2π/3 − 0) = −9/π. Since r is continuous and decreasing from 5 to −1, it passes through 0 once: |r| falls from 5 to 0 and then rises to 1.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.15-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.15-b-v3', 'mcq', 'compute the average rate of change of a signed polar radius and interpret it together with the sign of r, including when (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polar function r = f(θ) is continuous and strictly decreasing on [π/6, π/2], with f(π/6) = −1 and f(π/2) = −7. Which statement is correct?', null, md5('apprecalc-mcq-b3-sv-h-3.15-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average rate of change of r is −18/π per radian, and the distance of the plotted point from the pole decreases throughout the interval.', false, 'This finds the rate correctly but claims the distance decreases because the rate is negative; when r is negative, a decreasing r puts the point farther from the pole.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average rate of change of r is −18/π per radian, and the distance of the plotted point from the pole increases throughout the interval.', true, 'Correct: The average rate of change is (−7 − (−1))/(π/2 − π/6) = −6/(π/3) = −18/π. Since r stays negative and decreases from −1 to −7, |r| grows from 1 to 7, so the point moves away from the pole.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average rate of change of r is −18/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.', false, 'This finds the rate correctly but claims the distance first decreases to 0; r stays negative here, so it never reaches the pole.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average rate of change of r is 18/π per radian, and the distance of the plotted point from the pole increases throughout the interval.', false, 'This reports the opposite sign for the rate; r decreases from −1 to −7, so the average rate of change is negative.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-sv-h-3.15-b-v1','apprecalc-mcq-b3-sv-h-3.15-b-v2','apprecalc-mcq-b3-sv-h-3.15-b-v3']) and status='draft')<>3 then raise exception 'chunk 6: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b3-sv-h-3.15-b-v1','apprecalc-mcq-b3-sv-h-3.15-b-v2','apprecalc-mcq-b3-sv-h-3.15-b-v3']))<>12 then raise exception 'chunk 6: expected 12 choices'; end if;
end $$;
commit;
