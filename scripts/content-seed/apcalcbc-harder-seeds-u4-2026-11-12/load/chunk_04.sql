begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-sv-h-4.4-a-v3','apcalcbc-mcq-b4-h-4.4-b','apcalcbc-mcq-b4-sv-h-4.4-b-v1','apcalcbc-mcq-b4-sv-h-4.4-b-v2','apcalcbc-mcq-b4-sv-h-4.4-b-v3','apcalcbc-mcq-b4-h-4.5-a','apcalcbc-mcq-b4-sv-h-4.5-a-v1','apcalcbc-mcq-b4-sv-h-4.5-a-v2','apcalcbc-mcq-b4-sv-h-4.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b4-sv-h-4.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.4-a-v3', 'mcq', 'relate a changing hypotenuse to a changing leg by differentiating the Pythagorean relationship before substituting value (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The legs of a right triangular metal plate are x cm and y cm. As the plate is heated, x increases at 3 cm/min and y decreases at 2 cm/min. When x = 6 and y = 8, how fast is the hypotenuse changing?', null, md5('apcalcbc-mcq-b4-sv-h-4.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Increasing at 1 cm/min', false, 'This adds the leg rates, 3 − 2 = 1, as if the hypotenuse were the sum of the legs; the hypotenuse satisfies z² = x² + y² and does not add linearly.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Increasing at 2 cm/min', false, 'This computes x·x′ + y·y′ = 18 − 16 = 2 but does not divide by the hypotenuse z = 10; the rate is (x·x′ + y·y′)/z.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Increasing at 3.4 cm/min', false, 'This treats the decreasing leg as increasing, using 18 + 16 = 34 divided by 10; the rate of y is −2, so its term is 8(−2) = −16.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Increasing at 0.2 cm/min', true, 'Correct: z² = x² + y², so z′ = (x·x′ + y·y′)/z. With x = 6, y = 8, z = 10, z′ = (6·3 + 8·(−2))/10 = 2/10 = 0.2 cm/min.' from version_ins;
-- apcalcbc-mcq-b4-h-4.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.4-b', 'mcq', 'set up the volume relationship for a cone or trough using the stated shape constraint, so that only one variable changes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Sand falls from a conveyor at 10 ft³/min and forms a conical pile whose height always equals its base diameter. How fast is the height of the pile increasing when the height is 4 ft?', null, md5('apcalcbc-mcq-b4-h-4.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15/(2π) ft/min', false, 'This treats the radius as a constant 2 ft when differentiating V = (1/3)πr²h, so only the height changes; the radius r = h/2 grows with the height and must be replaced first.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/(2π) ft/min', true, 'Correct: With r = h/2, V = (1/3)π(h/2)²h = πh³/12, so dV/dt = (π/4)h²·dh/dt. At h = 4, 10 = 4π·dh/dt, so dh/dt = 5/(2π) ft/min.' from version_ins
union all select gen_random_uuid(), id, 'C', '5/(8π) ft/min', false, 'This uses r = h, taking the height to equal the radius, but the height equals the base diameter, so r = h/2 and V = πh³/12.' from version_ins
union all select gen_random_uuid(), id, 'D', '5/(32π) ft/min', false, 'This inverts the relationship and uses r = 2h; the height equals the diameter 2r, so the radius is half the height, r = h/2.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.4-b-v1', 'mcq', 'set up the volume relationship for a cone or trough using the stated shape constraint, so that only one variable changes (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Gravel falls from a hopper at 6 ft³/min and forms a conical pile whose height is always 3 times its base radius. How fast is the height of the pile increasing when the height is 3 ft?', null, md5('apcalcbc-mcq-b4-sv-h-4.4-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18/π ft/min', false, 'This treats the radius as a constant 1 ft when differentiating V = (1/3)πr²h; the radius r = h/3 grows with the height and must be replaced before differentiating.' from version_ins
union all select gen_random_uuid(), id, 'B', '2/(3π) ft/min', false, 'This uses r = h, taking the radius to equal the height, but the height is 3 times the radius, so r = h/3 and V = πh³/27.' from version_ins
union all select gen_random_uuid(), id, 'C', '6/π ft/min', true, 'Correct: With r = h/3, V = (1/3)π(h/3)²h = πh³/27, so dV/dt = (π/9)h²·dh/dt. At h = 3, 6 = π·dh/dt, so dh/dt = 6/π ft/min.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/(27π) ft/min', false, 'This inverts the relationship and uses r = 3h; the height is three times the radius, so r = h/3 and not 3h.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.4-b-v2', 'mcq', 'set up the volume relationship for a cone or trough using the stated shape constraint, so that only one variable changes (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A horizontal trough is 10 ft long and its ends are triangles. The width of the water surface is always 1.5 times the depth h of the water. Water is poured in at 6 ft³/min. How fast is the depth increasing when the depth is 2 ft?', null, md5('apcalcbc-mcq-b4-sv-h-4.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.1 ft/min', false, 'This leaves out the factor 1/2 in the triangle''s area, using V = 10(1.5h)(h) = 15h² instead of V = 10·(1/2)(1.5h)(h) = 7.5h².' from version_ins
union all select gen_random_uuid(), id, 'B', '0.2 ft/min', true, 'Correct: The end area is (1/2)(1.5h)(h) = 0.75h², so V = 7.5h² and dV/dt = 15h·dh/dt. At h = 2, 6 = 30·dh/dt, so dh/dt = 0.2 ft/min.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.4 ft/min', false, 'This treats the surface width as a constant 3 ft when differentiating; the width 1.5h grows with the depth and must be replaced by 1.5h before differentiating.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.45 ft/min', false, 'This inverts the ratio and uses width = h/1.5; the width is 1.5 times the depth, so the cross-sectional area is (1/2)(1.5h)(h) = 0.75h².' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.4-b-v3', 'mcq', 'set up the volume relationship for a cone or trough using the stated shape constraint, so that only one variable changes (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Salt falls onto a table at 24 cm³/min and forms a conical pile whose base radius is always twice its height. How fast is the height of the pile increasing when the height is 3 cm?', null, md5('apcalcbc-mcq-b4-sv-h-4.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/(3π) cm/min', true, 'Correct: With r = 2h, V = (1/3)π(2h)²h = 4πh³/3, so dV/dt = 4πh²·dh/dt. At h = 3, 24 = 36π·dh/dt, so dh/dt = 2/(3π) cm/min.' from version_ins
union all select gen_random_uuid(), id, 'B', '2/π cm/min', false, 'This treats the radius as a constant 6 cm when differentiating V = (1/3)πr²h; the radius r = 2h grows with the height and must be replaced before differentiating.' from version_ins
union all select gen_random_uuid(), id, 'C', '8/(3π) cm/min', false, 'This uses r = h, taking the radius to equal the height, but the radius is twice the height, so V = (1/3)π(2h)²h = 4πh³/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '32/(3π) cm/min', false, 'This inverts the relationship and uses r = h/2; the radius is twice the height, so r = 2h and not h/2.' from version_ins;
-- apcalcbc-mcq-b4-h-4.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.5-a', 'mcq', 'solve a related-rates problem involving an angle or similar triangles by differentiating the trigonometric or proportion', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A camera on the ground is 90 m horizontally from the point where a drone lifts straight up at 15 m/s. When the drone is 120 m above the ground, how fast is the camera''s angle of elevation to the drone changing?', null, md5('apcalcbc-mcq-b4-h-4.5-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/6 radian per second', false, 'This differentiates tan θ = h/90 but treats dθ/dt as h′/90, dropping the factor sec²θ that comes from the chain rule on tan θ.' from version_ins
union all select gen_random_uuid(), id, 'B', '25/54 radian per second', false, 'This multiplies (1/6) by sec²θ = 25/9, but the equation sec²θ·θ′ = h′/90 requires dividing by sec²θ, which is the same as multiplying by cos²θ.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/32 radian per second', false, 'This takes cos²θ as (90/120)², mixing up the hypotenuse with the height; at h = 120 the hypotenuse is 150 and cos θ = 90/150.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.06 radian per second', true, 'Correct: tan θ = h/90, so sec²θ·θ′ = h′/90. At h = 120 the hypotenuse is 150, cos θ = 3/5 and sec²θ = 25/9, so θ′ = (15/90)(9/25) = 0.06 radian per second.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.5-a-v1', 'mcq', 'solve a related-rates problem involving an angle or similar triangles by differentiating the trigonometric or proportion (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A person 1.8 m tall walks directly away from a lamp post 6 m tall at 1.2 m/s. How fast is the tip of the person''s shadow moving along the ground?', null, md5('apcalcbc-mcq-b4-sv-h-4.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.2 m/s', false, 'This assumes the tip of the shadow moves at the same speed as the person, but similar triangles show the tip must move faster to stay ahead of the person.' from version_ins
union all select gen_random_uuid(), id, 'B', '12/7 m/s', true, 'Correct: Let x be the person''s distance from the lamp and T the tip''s distance. Similar triangles give T/6 = (T − x)/1.8, so T = (10/7)x and T′ = (10/7)(1.2) = 12/7 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '18/35 m/s', false, 'This is the rate at which the shadow''s length is growing, not the speed of its tip; the tip also moves with the person, so its speed is the sum.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 m/s', false, 'This uses the ratio 6/1.8 from the heights directly; the similar triangles give 6/(6 − 1.8) = 10/7, not 6/1.8, as the factor multiplying the walking speed.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.5-a-v2', 'mcq', 'solve a related-rates problem involving an angle or similar triangles by differentiating the trigonometric or proportion (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A lighthouse is 3 km from a straight shore. Its beam rotates at 0.2 radian per minute and sweeps a spot along the shore. When the spot is 4 km from the point on shore nearest the lighthouse, how fast is the spot moving along the shore?', null, md5('apcalcbc-mcq-b4-sv-h-4.5-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/3 km/min', true, 'Correct: x = 3 tan θ, so x′ = 3 sec²θ·θ′. At x = 4 the beam length is 5, so sec θ = 5/3 and x′ = 3(25/9)(0.2) = 5/3 km/min.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.6 km/min', false, 'This uses x′ = 3θ′ and leaves out the factor sec²θ that comes from differentiating x = 3 tan θ.' from version_ins
union all select gen_random_uuid(), id, 'C', '16/15 km/min', false, 'This takes sec²θ as (4/3)², mixing the shore distance 4 with the secant; at x = 4 the beam length is 5, so sec θ = 5/3 and sec²θ = 25/9.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.216 km/min', false, 'This multiplies by cos²θ = 9/25 instead of sec²θ = 25/9; differentiating x = 3 tan θ gives x′ = 3 sec²θ·θ′.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.5-a-v3', 'mcq', 'solve a related-rates problem involving an angle or similar triangles by differentiating the trigonometric or proportion (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two sides of a triangular sail are 8 m and 10 m long, and the angle θ between them increases at 0.1 radian per second. How fast is the area of the sail changing when θ = π/6?', null, md5('apcalcbc-mcq-b4-sv-h-4.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 m²/s', false, 'This uses sin(π/6) = 1/2 where the derivative of the area A = 40 sin θ, namely 40 cos θ·θ′, needs cos(π/6) = √3/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '2√3 m²/s', true, 'Correct: A = (1/2)(8)(10) sin θ = 40 sin θ, so A′ = 40 cos θ·θ′. At θ = π/6, A′ = 40(√3/2)(0.1) = 2√3 m²/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '4 m²/s', false, 'This multiplies 40 by θ′ and drops the trigonometric factor entirely; the derivative of sin θ is cos θ, which must be evaluated at π/6.' from version_ins
union all select gen_random_uuid(), id, 'D', '4√3 m²/s', false, 'This uses A = 80 sin θ and omits the factor 1/2 in the triangle area formula A = (1/2)(8)(10) sin θ = 40 sin θ.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-sv-h-4.4-a-v3','apcalcbc-mcq-b4-h-4.4-b','apcalcbc-mcq-b4-sv-h-4.4-b-v1','apcalcbc-mcq-b4-sv-h-4.4-b-v2','apcalcbc-mcq-b4-sv-h-4.4-b-v3','apcalcbc-mcq-b4-h-4.5-a','apcalcbc-mcq-b4-sv-h-4.5-a-v1','apcalcbc-mcq-b4-sv-h-4.5-a-v2','apcalcbc-mcq-b4-sv-h-4.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b4-sv-h-4.4-a-v3','apcalcbc-mcq-b4-h-4.4-b','apcalcbc-mcq-b4-sv-h-4.4-b-v1','apcalcbc-mcq-b4-sv-h-4.4-b-v2','apcalcbc-mcq-b4-sv-h-4.4-b-v3','apcalcbc-mcq-b4-h-4.5-a','apcalcbc-mcq-b4-sv-h-4.5-a-v1','apcalcbc-mcq-b4-sv-h-4.5-a-v2','apcalcbc-mcq-b4-sv-h-4.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
