begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-sv-h-3.13-a-v3','apprecalc-mcq-b3-h-3.13-b','apprecalc-mcq-b3-sv-h-3.13-b-v1','apprecalc-mcq-b3-sv-h-3.13-b-v2','apprecalc-mcq-b3-sv-h-3.13-b-v3','apprecalc-mcq-b3-h-3.14-a','apprecalc-mcq-b3-sv-h-3.14-a-v1','apprecalc-mcq-b3-sv-h-3.14-a-v2','apprecalc-mcq-b3-sv-h-3.14-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apprecalc-mcq-b3-sv-h-3.13-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.13-a-v3', 'mcq', 'convert a rectangular point to polar form with a required negative radius, choosing the direction opposite to the point'' (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which polar pair (r, θ) with r < 0 and 0 ≤ θ < 2π names the point with rectangular coordinates (3, 3√3)?', null, md5('apprecalc-mcq-b3-sv-h-3.13-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−6, π/3)', false, 'This uses the actual direction π/3 with a negative radius, which lands at (−3, −3√3), the opposite point.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−6, 2π/3)', false, 'This negative radius at 2π/3 gives (3, −3√3), the mirror image across the x-axis.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−6, 5π/3)', false, 'This negative radius at 5π/3 gives (−3, 3√3), the mirror image across the y-axis.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−6, 4π/3)', true, 'Correct: The point is 6 units from the pole in direction π/3 (first quadrant). A negative radius points the opposite way, so use r = −6 with θ = π/3 + π = 4π/3. Check: x = −6 cos(4π/3) = 3 and y = −6 sin(4π/3) = 3√3.' from version_ins;
-- apprecalc-mcq-b3-h-3.13-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.13-b', 'mcq', 'recognize which polar pair names the same point as a given pair with a negative radius, adjusting the angle by π when th', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which polar pair names the same point as (r, θ) = (−2, 5π/4)?', null, md5('apprecalc-mcq-b3-h-3.13-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(2, π/4)', true, 'Correct: (−2, 5π/4) is at (−2cos(5π/4), −2sin(5π/4)) = (√2, √2). Flipping the sign of r requires adding or subtracting π to the angle, giving (2, π/4), which is also (√2, √2).' from version_ins
union all select gen_random_uuid(), id, 'B', '(2, 5π/4)', false, 'This changes only the sign of r, which reflects the point through the pole to (−√2, −√2) instead of keeping it at (√2, √2).' from version_ins
union all select gen_random_uuid(), id, 'C', '(−2, π/4)', false, 'This changes the angle by π but keeps r negative, so the point is still reflected through the pole and lands at (−√2, −√2).' from version_ins
union all select gen_random_uuid(), id, 'D', '(2, −5π/4)', false, 'This negates the angle instead of shifting it by π and also makes r positive; the point lands at (−√2, √2), not at (√2, √2).' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.13-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.13-b-v1', 'mcq', 'recognize which polar pair names the same point as a given pair with a negative radius, adjusting the angle by π when th (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which polar pair names the same point as (r, θ) = (−5, π/3)?', null, md5('apprecalc-mcq-b3-sv-h-3.13-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(5, π/3)', false, 'This changes only the sign of r, which reflects the point through the pole to the first quadrant.' from version_ins
union all select gen_random_uuid(), id, 'B', '(5, −2π/3)', true, 'Correct: (−5, π/3) is at (−5/2, −5√3/2) in the third quadrant. Flipping the sign of r requires shifting the angle by π: (5, π/3 − π) = (5, −2π/3) is at the same point.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−5, −2π/3)', false, 'This subtracts π from the angle but keeps r negative, so the point is reflected through the pole.' from version_ins
union all select gen_random_uuid(), id, 'D', '(5, −π/3)', false, 'This negates the angle instead of shifting it by π, which reflects the point across an axis into the fourth quadrant rather than the third.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.13-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.13-b-v2', 'mcq', 'recognize which polar pair names the same point as a given pair with a negative radius, adjusting the angle by π when th (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which polar pair names the same point as (r, θ) = (3, 7π/6)?', null, md5('apprecalc-mcq-b3-sv-h-3.13-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−3, 7π/6)', false, 'This changes only the sign of r, which reflects the point through the pole to (3√3/2, 3/2).' from version_ins
union all select gen_random_uuid(), id, 'B', '(3, π/6)', false, 'This changes the angle by π but keeps r positive, which reflects the point through the pole.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−3, −π/6)', false, 'This negates the angle instead of shifting it by π and also flips r, giving (−3√3/2, 3/2), not the original point at (−3√3/2, −3/2).' from version_ins
union all select gen_random_uuid(), id, 'D', '(−3, π/6)', true, 'Correct: (3, 7π/6) is at (−3√3/2, −3/2) in the third quadrant. A negative radius at the angle 7π/6 − π = π/6 points the opposite way and lands at the same place: (−3, π/6).' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.13-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.13-b-v3', 'mcq', 'recognize which polar pair names the same point as a given pair with a negative radius, adjusting the angle by π when th (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which polar pair names the same point as (r, θ) = (−4, 11π/6)?', null, md5('apprecalc-mcq-b3-sv-h-3.13-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(4, 11π/6)', false, 'This changes only the sign of r, which reflects the point through the pole to (2√3, −2).' from version_ins
union all select gen_random_uuid(), id, 'B', '(−4, 5π/6)', false, 'This changes the angle by π but keeps r negative, so the point is reflected through the pole to (2√3, −2).' from version_ins
union all select gen_random_uuid(), id, 'C', '(4, 5π/6)', true, 'Correct: (−4, 11π/6) is at (−2√3, 2) in the second quadrant. Flipping the sign of r requires subtracting π from the angle: (4, 11π/6 − π) = (4, 5π/6), which is the same point.' from version_ins
union all select gen_random_uuid(), id, 'D', '(4, −5π/6)', false, 'This negates the angle instead of shifting it by π, giving (−2√3, −2), not the original point at (−2√3, 2).' from version_ins;
-- apprecalc-mcq-b3-h-3.14-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.14-a', 'mcq', 'describe a rose curve from its equation: petal count (n or 2n), petal length (amplitude) and tip direction (sine versus ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement correctly describes the graph of the polar equation r = 6cos 2θ?', null, md5('apprecalc-mcq-b3-h-3.14-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 petals, each of length 6, with tips on the coordinate axes', false, 'This counts n petals for n = 2, but a rose with an even coefficient n has 2n petals.' from version_ins
union all select gen_random_uuid(), id, 'B', '4 petals, each of length 6, with tips on the lines y = x and y = −x', false, 'This puts the tips on the diagonals, which is where r = 6 sin 2θ has them; for cosine r = 6 at θ = 0, so a tip lies on the x-axis.' from version_ins
union all select gen_random_uuid(), id, 'C', '4 petals, each of length 2, with tips on the coordinate axes', false, 'This takes the petal length from the coefficient 2 of θ; the petal length is the amplitude 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 petals, each of length 6, with tips on the coordinate axes', true, 'Correct: The coefficient of θ is 2 (even), so there are 2·2 = 4 petals, each of length |6| = 6. r(0) = 6, r(π/2) = −6, r(π) = 6 and r(3π/2) = −6 put the four tips on the axes.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.14-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.14-a-v1', 'mcq', 'describe a rose curve from its equation: petal count (n or 2n), petal length (amplitude) and tip direction (sine versus  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement correctly describes the graph of the polar equation r = 4sin 2θ?', null, md5('apprecalc-mcq-b3-sv-h-3.14-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 petals, each of length 4, with tips on the lines y = x and y = −x', false, 'This counts n petals for n = 2, but a rose with an even coefficient n has 2n petals.' from version_ins
union all select gen_random_uuid(), id, 'B', '4 petals, each of length 4, with tips on the coordinate axes', false, 'This puts the tips on the axes, which is where r = 4cos 2θ has them; for sine, r = 0 at θ = 0, so no tip lies on the x-axis.' from version_ins
union all select gen_random_uuid(), id, 'C', '4 petals, each of length 4, with tips on the lines y = x and y = −x', true, 'Correct: The coefficient of θ is 2 (even), so there are 4 petals, each of length 4. The maximum |r| first occurs at 2θ = π/2, θ = π/4, and then at 3π/4, 5π/4 and 7π/4, so the tips lie on y = x and y = −x.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 petals, each of length 2, with tips on the lines y = x and y = −x', false, 'This takes the petal length from the coefficient 2 of θ; the petal length is the amplitude 4.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.14-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.14-a-v2', 'mcq', 'describe a rose curve from its equation: petal count (n or 2n), petal length (amplitude) and tip direction (sine versus  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement correctly describes the graph of the polar equation r = 2sin 5θ?', null, md5('apprecalc-mcq-b3-sv-h-3.14-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10 petals, each of length 2, with one tip at θ = π/10', false, 'This doubles the petal count as for an even coefficient, but for an odd coefficient n the rose has exactly n petals.' from version_ins
union all select gen_random_uuid(), id, 'B', '5 petals, each of length 5, with one tip at θ = π/10', false, 'This takes the petal length from the coefficient 5 of θ; the petal length is the amplitude 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '5 petals, each of length 2, with one tip on the positive x-axis', false, 'This puts a tip on the positive x-axis, as for cosine; for sine, r(0) = 0, so the first tip is at θ = π/10.' from version_ins
union all select gen_random_uuid(), id, 'D', '5 petals, each of length 2, with one tip at θ = π/10', true, 'Correct: The coefficient of θ is 5 (odd), so there are 5 petals, each of length 2. The first maximum is where 5θ = π/2, θ = π/10, where r = 2; r(0) = 0, so no tip lies on the positive x-axis.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.14-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.14-a-v3', 'mcq', 'describe a rose curve from its equation: petal count (n or 2n), petal length (amplitude) and tip direction (sine versus  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement correctly describes the graph of the polar equation r = 3cos 4θ?', null, md5('apprecalc-mcq-b3-sv-h-3.14-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4 petals, each of length 3, with one tip on the positive x-axis', false, 'This counts n petals for n = 4, but a rose with an even coefficient n has 2n petals.' from version_ins
union all select gen_random_uuid(), id, 'B', '8 petals, each of length 3, with one tip on the positive x-axis', true, 'Correct: The coefficient of θ is 4 (even), so there are 2·4 = 8 petals, each of length 3. r(0) = 3cos 0 = 3, so one tip lies on the positive x-axis; r(π/8) = 0, so no tip is at π/8.' from version_ins
union all select gen_random_uuid(), id, 'C', '8 petals, each of length 4, with one tip on the positive x-axis', false, 'This takes the petal length from the coefficient 4 of θ; the petal length is the amplitude 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '8 petals, each of length 3, with one tip at θ = π/8', false, 'This puts a tip at θ = π/8, but r(π/8) = 3cos(π/2) = 0, so the curve passes through the pole there.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-sv-h-3.13-a-v3','apprecalc-mcq-b3-h-3.13-b','apprecalc-mcq-b3-sv-h-3.13-b-v1','apprecalc-mcq-b3-sv-h-3.13-b-v2','apprecalc-mcq-b3-sv-h-3.13-b-v3','apprecalc-mcq-b3-h-3.14-a','apprecalc-mcq-b3-sv-h-3.14-a-v1','apprecalc-mcq-b3-sv-h-3.14-a-v2','apprecalc-mcq-b3-sv-h-3.14-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b3-sv-h-3.13-a-v3','apprecalc-mcq-b3-h-3.13-b','apprecalc-mcq-b3-sv-h-3.13-b-v1','apprecalc-mcq-b3-sv-h-3.13-b-v2','apprecalc-mcq-b3-sv-h-3.13-b-v3','apprecalc-mcq-b3-h-3.14-a','apprecalc-mcq-b3-sv-h-3.14-a-v1','apprecalc-mcq-b3-sv-h-3.14-a-v2','apprecalc-mcq-b3-sv-h-3.14-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
