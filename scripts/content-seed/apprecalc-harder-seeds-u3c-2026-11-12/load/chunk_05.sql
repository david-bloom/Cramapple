begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-h-3.14-b','apprecalc-mcq-b3-sv-h-3.14-b-v1','apprecalc-mcq-b3-sv-h-3.14-b-v2','apprecalc-mcq-b3-sv-h-3.14-b-v3','apprecalc-mcq-b3-h-3.15-a','apprecalc-mcq-b3-sv-h-3.15-a-v1','apprecalc-mcq-b3-sv-h-3.15-a-v2','apprecalc-mcq-b3-sv-h-3.15-a-v3','apprecalc-mcq-b3-h-3.15-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apprecalc-mcq-b3-h-3.14-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.14-b', 'mcq', 'classify a limaçon or cardioid from its equation using the ratio of the constant to the coefficient, and find its axis o', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement best describes the graph of the polar equation r = 3 − 5sin θ?', null, md5('apprecalc-mcq-b3-h-3.14-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A limaçon with an inner loop, symmetric about the polar axis, with a maximum distance of 8 from the pole', false, 'This swaps the axis of symmetry; an equation in sin θ is symmetric about the vertical line θ = π/2, while cos θ gives the polar axis.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A dimpled limaçon with no inner loop, symmetric about the line θ = π/2, with a maximum distance of 8 from the pole', false, 'This ignores that |3| < |−5|: when the constant is smaller than the sine coefficient, r becomes negative and an inner loop forms.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A limaçon with an inner loop, symmetric about the line θ = π/2, with a maximum distance of 8 from the pole', true, 'Correct: Here |a| = 3 is less than |b| = 5, so r takes negative values and the curve has an inner loop. The sin θ form makes it symmetric about θ = π/2, and the greatest |r| is 3 + 5 = 8 at θ = 3π/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A limaçon with an inner loop, symmetric about the line θ = π/2, with a maximum distance of 5 from the pole', false, 'This uses only the coefficient 5 as the maximum distance; the farthest point is 3 + 5 = 8 at θ = 3π/2.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.14-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.14-b-v1', 'mcq', 'classify a limaçon or cardioid from its equation using the ratio of the constant to the coefficient, and find its axis o (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement best describes the graph of the polar equation r = 3 + 2cos θ?', null, md5('apprecalc-mcq-b3-sv-h-3.14-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A dimpled limaçon with no inner loop, symmetric about the polar axis, with a maximum distance of 5 from the pole', true, 'Correct: Here b < a < 2b (2 < 3 < 4), so r stays positive and the curve has a dimple but no inner loop. The cos θ form makes it symmetric about the polar axis, and the greatest r is 3 + 2 = 5 at θ = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A limaçon with an inner loop, symmetric about the polar axis, with a maximum distance of 5 from the pole', false, 'This claims an inner loop, but a loop needs |a| < |b|; here 3 > 2, so r never becomes negative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A dimpled limaçon with no inner loop, symmetric about the line θ = π/2, with a maximum distance of 5 from the pole', false, 'This swaps the axis of symmetry; an equation in cos θ is symmetric about the polar axis, not the vertical line θ = π/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A dimpled limaçon with no inner loop, symmetric about the polar axis, with a maximum distance of 3 from the pole', false, 'This uses only the constant 3 as the maximum distance; the farthest point is 3 + 2 = 5 at θ = 0.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.14-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.14-b-v2', 'mcq', 'classify a limaçon or cardioid from its equation using the ratio of the constant to the coefficient, and find its axis o (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement best describes the graph of the polar equation r = 4 − 4sin θ?', null, md5('apprecalc-mcq-b3-sv-h-3.14-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A cardioid with a cusp at the pole, symmetric about the line θ = π/2, with a maximum distance of 8 from the pole', true, 'Correct: Here |a| = |b| = 4, so the curve is a cardioid with its cusp at the pole (r = 0 at θ = π/2). The sin θ form makes it symmetric about θ = π/2, and the greatest r is 4 + 4 = 8 at θ = 3π/2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A cardioid with a cusp at the pole, symmetric about the polar axis, with a maximum distance of 8 from the pole', false, 'This swaps the axis of symmetry; an equation in sin θ is symmetric about the vertical line θ = π/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A dimpled limaçon with no inner loop, symmetric about the line θ = π/2, with a maximum distance of 8 from the pole', false, 'This treats |a| = |b| as a dimpled limaçon, but when the constant equals the coefficient the dimple pinches to a cusp at the pole (a cardioid).' from version_ins
union all select gen_random_uuid(), id, 'D', 'A cardioid with a cusp at the pole, symmetric about the line θ = π/2, with a maximum distance of 4 from the pole', false, 'This uses the constant 4 as the maximum distance; the farthest point is 4 + 4 = 8 at θ = 3π/2.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.14-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.14-b-v3', 'mcq', 'classify a limaçon or cardioid from its equation using the ratio of the constant to the coefficient, and find its axis o (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement best describes the graph of the polar equation r = 7 − 2cos θ?', null, md5('apprecalc-mcq-b3-sv-h-3.14-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A limaçon with no dimple and no inner loop, symmetric about the polar axis, with a maximum distance of 9 from the pole', true, 'Correct: Here a = 7 is at least 2|b| = 4, so r stays positive and the curve is convex with no dimple and no loop. The cos θ form gives symmetry about the polar axis, and the greatest r is 7 + 2 = 9 at θ = π.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A dimpled limaçon with no inner loop, symmetric about the polar axis, with a maximum distance of 9 from the pole', false, 'This adds a dimple, but a dimple needs the constant to be less than twice the coefficient; here 7 > 4, so the curve is convex.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A limaçon with no dimple and no inner loop, symmetric about the line θ = π/2, with a maximum distance of 9 from the pole', false, 'This swaps the axis of symmetry; an equation in cos θ is symmetric about the polar axis.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A limaçon with no dimple and no inner loop, symmetric about the polar axis, with a maximum distance of 5 from the pole', false, 'This uses 7 − 2 = 5, which is the nearest distance (at θ = 0), not the farthest; the farthest is 7 + 2 = 9 at θ = π.' from version_ins;
-- apprecalc-mcq-b3-h-3.15-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.15-a', 'mcq', 'decide where a polar point moves toward the pole by comparing the signs of r and dr/dθ, rather than the sign of dr/dθ al', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The polar function r = 4sin θ − 2 is graphed for 0 ≤ θ ≤ π. On which interval(s) of θ does the plotted point get closer to the pole (its distance from the origin decreases)?', null, md5('apprecalc-mcq-b3-h-3.15-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(π/2, π)', false, 'This is where r is decreasing (cos θ < 0), but r is negative on part of it, where a decreasing r moves the point farther from the pole.' from version_ins
union all select gen_random_uuid(), id, 'B', '(0, π/6) ∪ (π/2, 5π/6)', true, 'Correct: r'' = 4cos θ and r = 0 at θ = π/6 and 5π/6. Distance decreases when r and r'' have opposite signs: r < 0 and r'' > 0 on (0, π/6); r > 0 and r'' < 0 on (π/2, 5π/6). So the point approaches the pole on (0, π/6) ∪ (π/2, 5π/6).' from version_ins
union all select gen_random_uuid(), id, 'C', '(0, π/2)', false, 'This is where r is increasing, but r is positive on part of it, where an increasing r moves the point away from the pole.' from version_ins
union all select gen_random_uuid(), id, 'D', '(π/6, π/2) ∪ (5π/6, π)', false, 'This is where the distance increases (r positive and increasing, or r negative and decreasing), the opposite of what is asked.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.15-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.15-a-v1', 'mcq', 'decide where a polar point moves toward the pole by comparing the signs of r and dr/dθ, rather than the sign of dr/dθ al (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The polar function r = 6cos θ − 3 is graphed for 0 ≤ θ ≤ π. On which interval(s) of θ does the plotted point get closer to the pole (its distance from the origin decreases)?', null, md5('apprecalc-mcq-b3-sv-h-3.15-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0, π/3)', true, 'Correct: r'' = −6 sin θ < 0 on (0, π), so r decreases throughout. r = 0 at θ = π/3. On (0, π/3), r is positive and decreasing, so the distance falls to 0; on (π/3, π), r is negative and decreasing, so the distance grows. The answer is (0, π/3).' from version_ins
union all select gen_random_uuid(), id, 'B', '(0, π)', false, 'This uses only that r is decreasing (r'' = −6 sin θ < 0); where r is negative, a decreasing r puts the point farther from the pole.' from version_ins
union all select gen_random_uuid(), id, 'C', '(π/3, π)', false, 'This takes the interval where r is negative and decreasing as approaching the pole, but a more negative r means a larger distance.' from version_ins
union all select gen_random_uuid(), id, 'D', '(π/2, π)', false, 'This is only where cos θ < 0, which does not relate to the sign changes of r (r = 0 at θ = π/3).' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.15-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.15-a-v2', 'mcq', 'decide where a polar point moves toward the pole by comparing the signs of r and dr/dθ, rather than the sign of dr/dθ al (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The polar function r = √3 − 2cos θ is graphed for 0 ≤ θ ≤ π. On which interval(s) of θ does the plotted point get closer to the pole (its distance from the origin decreases)?', null, md5('apprecalc-mcq-b3-sv-h-3.15-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0, π)', false, 'This uses only that r is increasing (r'' = 2 sin θ > 0); where r is positive, an increasing r puts the point farther from the pole.' from version_ins
union all select gen_random_uuid(), id, 'B', '(π/6, π)', false, 'This takes the interval where r is positive and increasing as approaching the pole, but a larger positive r means a larger distance.' from version_ins
union all select gen_random_uuid(), id, 'C', '(0, π/6)', true, 'Correct: r'' = 2 sin θ > 0 on (0, π), so r increases throughout. r = 0 where cos θ = √3/2, θ = π/6. On (0, π/6), r is negative and increasing, so the distance falls to 0; afterward r is positive and increasing, so the distance grows. The answer is (0, π/6).' from version_ins
union all select gen_random_uuid(), id, 'D', '(0, π/2)', false, 'This is only where cos θ > 0, which does not relate to the sign changes of r (r = 0 at θ = π/6).' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.15-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.15-a-v3', 'mcq', 'decide where a polar point moves toward the pole by comparing the signs of r and dr/dθ, rather than the sign of dr/dθ al (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The polar function r = 2√2 sin θ − 2 is graphed for 0 ≤ θ ≤ π. On which interval(s) of θ does the plotted point get closer to the pole (its distance from the origin decreases)?', null, md5('apprecalc-mcq-b3-sv-h-3.15-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0, π/4) ∪ (π/2, 3π/4)', true, 'Correct: r'' = 2√2 cos θ and r = 0 at θ = π/4 and 3π/4. Distance decreases when r and r'' have opposite signs: r < 0 and r'' > 0 on (0, π/4); r > 0 and r'' < 0 on (π/2, 3π/4). So the answer is (0, π/4) ∪ (π/2, 3π/4).' from version_ins
union all select gen_random_uuid(), id, 'B', '(π/2, π)', false, 'This is where r is decreasing (cos θ < 0), but r is negative on part of it, where a decreasing r moves the point farther from the pole.' from version_ins
union all select gen_random_uuid(), id, 'C', '(0, π/2)', false, 'This is where r is increasing, but r is positive on part of it, where an increasing r moves the point away from the pole.' from version_ins
union all select gen_random_uuid(), id, 'D', '(π/4, π/2) ∪ (3π/4, π)', false, 'This is where the distance increases (r positive and increasing, or r negative and decreasing), the opposite of what is asked.' from version_ins;
-- apprecalc-mcq-b3-h-3.15-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.15-b', 'mcq', 'compute the average rate of change of a signed polar radius and interpret it together with the sign of r, including when', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polar function r = f(θ) is continuous and strictly increasing on [π/6, π/2], with f(π/6) = −2 and f(π/2) = 4. Which statement is correct?', null, md5('apprecalc-mcq-b3-h-3.15-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average rate of change of r is 18/π per radian, and the distance of the plotted point from the pole increases throughout the interval.', false, 'This finds the rate correctly but claims the distance increases throughout, reading the increase in r as a move away from the pole even where r is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average rate of change of r is 18/π per radian, and the distance of the plotted point from the pole decreases throughout the interval.', false, 'This finds the rate correctly but claims the distance decreases throughout, ignoring that r becomes positive and then moves farther from the pole.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average rate of change of r is 18/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.', true, 'Correct: The average rate of change is (4 − (−2))/(π/2 − π/6) = 6/(π/3) = 18/π. Since r is continuous and increasing from −2 to 4, it passes through 0 once: |r| falls from 2 to 0 and then rises to 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average rate of change of r is 6/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.', false, 'This finds the change in distance, (4 − 2)/(π/3), instead of the change in r itself, (4 − (−2))/(π/3); the average rate of change is for r, signed.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-h-3.14-b','apprecalc-mcq-b3-sv-h-3.14-b-v1','apprecalc-mcq-b3-sv-h-3.14-b-v2','apprecalc-mcq-b3-sv-h-3.14-b-v3','apprecalc-mcq-b3-h-3.15-a','apprecalc-mcq-b3-sv-h-3.15-a-v1','apprecalc-mcq-b3-sv-h-3.15-a-v2','apprecalc-mcq-b3-sv-h-3.15-a-v3','apprecalc-mcq-b3-h-3.15-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b3-h-3.14-b','apprecalc-mcq-b3-sv-h-3.14-b-v1','apprecalc-mcq-b3-sv-h-3.14-b-v2','apprecalc-mcq-b3-sv-h-3.14-b-v3','apprecalc-mcq-b3-h-3.15-a','apprecalc-mcq-b3-sv-h-3.15-a-v1','apprecalc-mcq-b3-sv-h-3.15-a-v2','apprecalc-mcq-b3-sv-h-3.15-a-v3','apprecalc-mcq-b3-h-3.15-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
