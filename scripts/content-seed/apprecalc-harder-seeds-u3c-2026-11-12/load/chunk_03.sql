begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-sv-h-3.12-a-v2','apprecalc-mcq-b3-sv-h-3.12-a-v3','apprecalc-mcq-b3-h-3.12-b','apprecalc-mcq-b3-sv-h-3.12-b-v1','apprecalc-mcq-b3-sv-h-3.12-b-v2','apprecalc-mcq-b3-sv-h-3.12-b-v3','apprecalc-mcq-b3-h-3.13-a','apprecalc-mcq-b3-sv-h-3.13-a-v1','apprecalc-mcq-b3-sv-h-3.13-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apprecalc-mcq-b3-sv-h-3.12-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.12-a-v2', 'mcq', 'identify the one invalid identity among four by recognizing which algebraic or trigonometric shortcut fails (square root (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following equations is NOT an identity (that is, is not true for every x for which both sides are defined)?', null, md5('apprecalc-mcq-b3-sv-h-3.12-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(sin x + cos x)² = 1 + 2sin x cos x', false, 'This is a true identity: expanding gives sin²x + 2sin x cos x + cos²x, and sin²x + cos²x = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'cot²x + 1 = csc²x', false, 'This is a true identity: dividing sin²x + cos²x = 1 by sin²x gives 1 + cot²x = csc²x.' from version_ins
union all select gen_random_uuid(), id, 'C', '(sin x + cos x)² = sin²x + cos²x', true, 'Correct: Take x = π/4: (√2/2 + √2/2)² = 2, but sin²x + cos²x = 1, so the equation fails because the cross term 2sin x cos x is missing.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sin(π/2 − x) = cos x', false, 'This is a true identity: sine of the complement equals the cosine, as the cofunction identity states.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.12-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.12-a-v3', 'mcq', 'identify the one invalid identity among four by recognizing which algebraic or trigonometric shortcut fails (square root (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following equations is NOT an identity (that is, is not true for every x for which both sides are defined)?', null, md5('apprecalc-mcq-b3-sv-h-3.12-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sin 2x = 2 sin x', true, 'Correct: Take x = π/2: sin π = 0 but 2sin(π/2) = 2, so the equation fails; the correct double-angle formula is sin 2x = 2 sin x cos x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'cos 2x = 2cos²x − 1', false, 'This is a true identity: it is the double-angle formula cos 2x = cos²x − sin²x with sin²x replaced by 1 − cos²x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'tan x + cot x = sec x csc x', false, 'This is a true identity: sin x/cos x + cos x/sin x = (sin²x + cos²x)/(sin x cos x) = 1/(sin x cos x).' from version_ins
union all select gen_random_uuid(), id, 'D', 'sin²x = (1 − cos 2x)/2', false, 'This is a true identity: it is the double-angle formula cos 2x = 1 − 2sin²x solved for sin²x.' from version_ins;
-- apprecalc-mcq-b3-h-3.12-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.12-b', 'mcq', 'apply the double-angle identity after recovering the missing ratio and its sign from the quadrant, avoiding the cos 2θ a', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The angle θ is in the fourth quadrant and cos θ = 3/5. What is the value of sin 2θ?', null, md5('apprecalc-mcq-b3-h-3.12-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24/25', false, 'This computes the magnitude correctly but gives it the wrong sign; in this quadrant sin θ and cos θ have signs whose product is the opposite of this.' from version_ins
union all select gen_random_uuid(), id, 'B', '−7/25', false, 'This is the value of cos 2θ = cos²θ − sin²θ, not sin 2θ.' from version_ins
union all select gen_random_uuid(), id, 'C', '−12/25', false, 'This is sin θ cos θ and omits the factor 2 in the identity sin 2θ = 2 sin θ cos θ.' from version_ins
union all select gen_random_uuid(), id, 'D', '−24/25', true, 'Correct: The Pythagorean identity gives sin θ = −4/5 (sign from the fourth quadrant). Then sin 2θ = 2 sin θ cos θ = 2(−4/5)(3/5) = −24/25.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.12-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.12-b-v1', 'mcq', 'apply the double-angle identity after recovering the missing ratio and its sign from the quadrant, avoiding the cos 2θ a (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The angle θ is in the second quadrant and sin θ = 5/13. What is the value of sin 2θ?', null, md5('apprecalc-mcq-b3-sv-h-3.12-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '120/169', false, 'This computes the magnitude correctly but gives it the wrong sign; in this quadrant sin θ and cos θ have signs whose product is the opposite of this.' from version_ins
union all select gen_random_uuid(), id, 'B', '119/169', false, 'This is the value of cos 2θ = cos²θ − sin²θ, not sin 2θ.' from version_ins
union all select gen_random_uuid(), id, 'C', '−60/169', false, 'This is sin θ cos θ and omits the factor 2 in the identity sin 2θ = 2 sin θ cos θ.' from version_ins
union all select gen_random_uuid(), id, 'D', '−120/169', true, 'Correct: The Pythagorean identity gives cos θ = −12/13 (sign from the second quadrant). Then sin 2θ = 2 sin θ cos θ = 2(5/13)(−12/13) = −120/169.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.12-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.12-b-v2', 'mcq', 'apply the double-angle identity after recovering the missing ratio and its sign from the quadrant, avoiding the cos 2θ a (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The angle θ is in the third quadrant and cos θ = −4/5. What is the value of sin 2θ?', null, md5('apprecalc-mcq-b3-sv-h-3.12-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−24/25', false, 'This computes the magnitude correctly but gives it the wrong sign; in this quadrant sin θ and cos θ have signs whose product is the opposite of this.' from version_ins
union all select gen_random_uuid(), id, 'B', '7/25', false, 'This is the value of cos 2θ = cos²θ − sin²θ, not sin 2θ.' from version_ins
union all select gen_random_uuid(), id, 'C', '24/25', true, 'Correct: The Pythagorean identity gives sin θ = −3/5 (sign from the third quadrant). Then sin 2θ = 2 sin θ cos θ = 2(−3/5)(−4/5) = 24/25.' from version_ins
union all select gen_random_uuid(), id, 'D', '12/25', false, 'This is sin θ cos θ and omits the factor 2 in the identity sin 2θ = 2 sin θ cos θ.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.12-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.12-b-v3', 'mcq', 'apply the double-angle identity after recovering the missing ratio and its sign from the quadrant, avoiding the cos 2θ a (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The angle θ is in the fourth quadrant and sin θ = −8/17. What is the value of sin 2θ?', null, md5('apprecalc-mcq-b3-sv-h-3.12-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '240/289', false, 'This computes the magnitude correctly but gives it the wrong sign; in this quadrant sin θ and cos θ have signs whose product is the opposite of this.' from version_ins
union all select gen_random_uuid(), id, 'B', '161/289', false, 'This is the value of cos 2θ = cos²θ − sin²θ, not sin 2θ.' from version_ins
union all select gen_random_uuid(), id, 'C', '−240/289', true, 'Correct: The Pythagorean identity gives cos θ = 15/17 (sign from the fourth quadrant). Then sin 2θ = 2 sin θ cos θ = 2(−8/17)(15/17) = −240/289.' from version_ins
union all select gen_random_uuid(), id, 'D', '−120/289', false, 'This is sin θ cos θ and omits the factor 2 in the identity sin 2θ = 2 sin θ cos θ.' from version_ins;
-- apprecalc-mcq-b3-h-3.13-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.13-a', 'mcq', 'convert a rectangular point to polar form with a required negative radius, choosing the direction opposite to the point''', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which polar pair (r, θ) with r < 0 and 0 ≤ θ < 2π names the point with rectangular coordinates (−3, 3)?', null, md5('apprecalc-mcq-b3-h-3.13-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−3√2, 7π/4)', true, 'Correct: The point is √18 = 3√2 from the pole in direction 3π/4. A negative radius points the opposite way, so use r = −3√2 with θ = 3π/4 + π = 7π/4. Check: x = −3√2 cos(7π/4) = −3 and y = −3√2 sin(7π/4) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−3√2, 3π/4)', false, 'This uses the actual direction 3π/4 of the point and also makes r negative, which sends the point to the opposite side, at (3, −3).' from version_ins
union all select gen_random_uuid(), id, 'C', '(−3√2, π/4)', false, 'This negative radius at angle π/4 lands in the third quadrant at (−3, −3); the reference angle was used without adjusting for the direction.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3√2, 7π/4)', false, 'This has a positive radius, which violates r < 0, and the angle 7π/4 points to the fourth quadrant, giving (3, −3).' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.13-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.13-a-v1', 'mcq', 'convert a rectangular point to polar form with a required negative radius, choosing the direction opposite to the point'' (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which polar pair (r, θ) with r < 0 and 0 ≤ θ < 2π names the point with rectangular coordinates (2√3, −2)?', null, md5('apprecalc-mcq-b3-sv-h-3.13-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−4, 11π/6)', false, 'This uses the actual direction 11π/6 with a negative radius, which lands at (−2√3, 2), the opposite point.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−4, π/6)', false, 'This uses the reference angle π/6 with a negative radius, giving (−2√3, −2), in the third quadrant.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−4, 7π/6)', false, 'This negative radius at 7π/6 gives (2√3, 2), which has the correct x-coordinate but the wrong sign of y.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−4, 5π/6)', true, 'Correct: The point is 4 units from the pole in direction 11π/6 (fourth quadrant). A negative radius points the opposite way, so use r = −4 with θ = 11π/6 − π = 5π/6. Check: x = −4 cos(5π/6) = 2√3 and y = −4 sin(5π/6) = −2.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.13-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.13-a-v2', 'mcq', 'convert a rectangular point to polar form with a required negative radius, choosing the direction opposite to the point'' (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which polar pair (r, θ) with r < 0 and 0 ≤ θ < 2π names the point with rectangular coordinates (−2, −2√3)?', null, md5('apprecalc-mcq-b3-sv-h-3.13-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−4, 4π/3)', false, 'This uses the actual direction 4π/3 with a negative radius, which lands at (2, 2√3), the opposite point.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−4, π/3)', true, 'Correct: The point is 4 units from the pole in direction 4π/3 (third quadrant). A negative radius points the opposite way, so use r = −4 with θ = 4π/3 − π = π/3. Check: x = −4 cos(π/3) = −2 and y = −4 sin(π/3) = −2√3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−4, 2π/3)', false, 'This negative radius at 2π/3 gives (2, −2√3), the mirror image across the y-axis.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−4, 5π/3)', false, 'This negative radius at 5π/3 gives (−2, 2√3), the mirror image across the x-axis.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-sv-h-3.12-a-v2','apprecalc-mcq-b3-sv-h-3.12-a-v3','apprecalc-mcq-b3-h-3.12-b','apprecalc-mcq-b3-sv-h-3.12-b-v1','apprecalc-mcq-b3-sv-h-3.12-b-v2','apprecalc-mcq-b3-sv-h-3.12-b-v3','apprecalc-mcq-b3-h-3.13-a','apprecalc-mcq-b3-sv-h-3.13-a-v1','apprecalc-mcq-b3-sv-h-3.13-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b3-sv-h-3.12-a-v2','apprecalc-mcq-b3-sv-h-3.12-a-v3','apprecalc-mcq-b3-h-3.12-b','apprecalc-mcq-b3-sv-h-3.12-b-v1','apprecalc-mcq-b3-sv-h-3.12-b-v2','apprecalc-mcq-b3-sv-h-3.12-b-v3','apprecalc-mcq-b3-h-3.13-a','apprecalc-mcq-b3-sv-h-3.13-a-v1','apprecalc-mcq-b3-sv-h-3.13-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
