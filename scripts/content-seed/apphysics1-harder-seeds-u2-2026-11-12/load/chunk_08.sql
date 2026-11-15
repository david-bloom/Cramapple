begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.8-b-v3','apphysics1-mcq-b5-h-2.9-a','apphysics1-mcq-b5-sv-h-2.9-a-v1','apphysics1-mcq-b5-sv-h-2.9-a-v2','apphysics1-mcq-b5-sv-h-2.9-a-v3','apphysics1-mcq-b5-h-2.9-b','apphysics1-mcq-b5-sv-h-2.9-b-v1','apphysics1-mcq-b5-sv-h-2.9-b-v2','apphysics1-mcq-b5-sv-h-2.9-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apphysics1-mcq-b5-sv-h-2.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.8-b-v3', 'mcq', 'combine springs: the same force passes through springs in series so their stretches add, while parallel springs share th (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.5 kg block rests on a frictionless horizontal track between two walls. A spring with k = 100 N/m joins the block to the left wall and a spring with k = 300 N/m joins it to the right wall. Both springs are relaxed at the block''s equilibrium position. The block is pulled 0.050 m to the right of equilibrium and held. What is the net horizontal spring force on the block?', null, md5('apphysics1-mcq-b5-sv-h-2.8-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20 N, directed toward the left.', true, 'Correct: Left spring stretched: 100(0.050) = 5 N toward the left. Right spring compressed: 300(0.050) = 15 N toward the left. The sum is 20 N toward the left.' from version_ins
union all select gen_random_uuid(), id, 'B', '5 N, directed toward the left, because only the softer spring acts.', false, 'Both springs exert force. The right spring, compressed by 0.050 m, pushes left with 15 N, and the left one pulls left with 5 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '15 N, directed toward the left, because only the stiffer spring acts.', false, 'The left spring is stretched and also pulls the block back toward the left, adding 5 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 N, directed toward the left, because the two spring forces partly cancel.', false, 'Both spring forces point left, because one spring is stretched and the other is compressed. They add rather than cancel.' from version_ins;
-- apphysics1-mcq-b5-h-2.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.9-a', 'mcq', 'use friction as the centripetal force on a flat curve: the maximum speed does not depend on mass', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1000 kg car can just barely round a flat circular curve of radius 50 m at its maximum speed without skidding. The static friction coefficient between tires and road is 0.80. Use g = 10 m/s². The same car is then loaded with passengers and cargo until its mass is 1500 kg. What is the maximum speed at which it can now round the curve?', null, md5('apphysics1-mcq-b5-h-2.9-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24 m/s, because the greater weight gives more friction.', false, 'Greater weight increases friction, but it also increases the mass that must be accelerated. The two effects cancel, so the speed limit is unchanged.' from version_ins
union all select gen_random_uuid(), id, 'B', '16 m/s, because a heavier car needs more force to turn.', false, 'The friction limit grows in proportion to mass just as the required centripetal force does, so the maximum speed does not decrease.' from version_ins
union all select gen_random_uuid(), id, 'C', '20 m/s', true, 'Correct: μ m g = m v²/r gives v = √(μ g r) = √(0.80 × 10 × 50) = 20 m/s, independent of mass.' from version_ins
union all select gen_random_uuid(), id, 'D', '30 m/s, because the maximum speed scales in proportion to mass.', false, 'The maximum speed does not depend on mass at all. It depends on μ, g and the radius: v = √(μ g r).' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.9-a-v1', 'mcq', 'use friction as the centripetal force on a flat curve: the maximum speed does not depend on mass (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 200 kg motorcycle and rider can just barely round a flat circular curve of radius 45 m at their maximum speed without skidding. The static friction coefficient is 0.50. Use g = 10 m/s². A passenger is added so the total mass becomes 400 kg. What is the maximum speed now?', null, md5('apphysics1-mcq-b5-sv-h-2.9-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15 m/s', true, 'Correct: v = √(μ g r) = √(0.50 × 10 × 45) = 15 m/s. The mass cancels, so adding a passenger does not change it.' from version_ins
union all select gen_random_uuid(), id, 'B', '21 m/s, because the greater weight gives more friction.', false, 'More weight increases friction, but the mass to be accelerated increases equally, so the limit does not change.' from version_ins
union all select gen_random_uuid(), id, 'C', '11 m/s, because a heavier vehicle needs more force to turn.', false, 'The friction force limit also doubles when the mass doubles. The maximum speed stays the same.' from version_ins
union all select gen_random_uuid(), id, 'D', '30 m/s, because the maximum speed doubles when the mass doubles.', false, 'The maximum speed does not depend on mass. It is set by μ, g and r.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.9-a-v2', 'mcq', 'use friction as the centripetal force on a flat curve: the maximum speed does not depend on mass (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An empty 3000 kg truck can just barely round a flat circular curve of radius 20 m at its maximum speed without skidding. The static friction coefficient is 0.50. Use g = 10 m/s². The truck is then loaded until its mass is 12000 kg. What is the maximum speed now?', null, md5('apphysics1-mcq-b5-sv-h-2.9-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20 m/s, because the maximum speed grows as the square root of the mass.', false, 'Mass does not appear in v = √(μ g r). Friction and the required centripetal force scale together with mass.' from version_ins
union all select gen_random_uuid(), id, 'B', '10 m/s', true, 'Correct: v = √(μ g r) = √(0.50 × 10 × 20) = 10 m/s, independent of the truck''s mass.' from version_ins
union all select gen_random_uuid(), id, 'C', '5 m/s, because the maximum speed falls as the mass increases.', false, 'A heavier truck has proportionally more friction available. The speed limit does not decrease.' from version_ins
union all select gen_random_uuid(), id, 'D', '40 m/s, because the maximum speed is proportional to the mass.', false, 'The maximum speed does not depend on mass at all. It depends on μ, g and the radius.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.9-a-v3', 'mcq', 'use friction as the centripetal force on a flat curve: the maximum speed does not depend on mass (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 800 kg car can just barely round a flat circular curve of radius 24 m at its maximum speed without skidding. The static friction coefficient is 0.60. Use g = 10 m/s². The car is then loaded until its mass is 2400 kg. What is the maximum speed now?', null, md5('apphysics1-mcq-b5-sv-h-2.9-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12 m/s', true, 'Correct: v = √(μ g r) = √(0.60 × 10 × 24) = 12 m/s, the same for any mass.' from version_ins
union all select gen_random_uuid(), id, 'B', '21 m/s, because the maximum speed grows as the square root of the mass.', false, 'The mass cancels in μ m g = m v²/r. A heavier car has more friction but also needs more centripetal force.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.9 m/s, because the heavier car must go slower.', false, 'The maximum speed is unchanged because both the available friction and the required force scale with mass.' from version_ins
union all select gen_random_uuid(), id, 'D', '36 m/s, because the maximum speed is proportional to the mass.', false, 'The speed limit does not depend on mass; it is √(μ g r).' from version_ins;
-- apphysics1-mcq-b5-h-2.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.9-b', 'mcq', 'scale the centripetal force with speed and radius together using F proportional to v²/r', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small ball on a light string moves in a horizontal circle on a frictionless table, so the string tension is the only horizontal force on it. At speed v on a circle of radius r the tension is 20 N. The ball is later whirled at speed 2v on a circle of radius 2r. What is the new tension?', null, md5('apphysics1-mcq-b5-h-2.9-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '80 N, because the tension is proportional to v².', false, 'The tension is proportional to v²/r. The larger radius divides the factor of 4 by 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '40 N', true, 'Correct: T = mv²/r. The factor is (2)²/2 = 2, so the tension becomes 2 × 20 = 40 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '160 N, because both doubling the speed and doubling the radius increase the tension.', false, 'Doubling the radius reduces the tension. It appears in the denominator of F = mv²/r.' from version_ins
union all select gen_random_uuid(), id, 'D', '20 N, because the doubling of speed and radius cancel.', false, 'The speed enters as v², giving a factor of 4, while the radius gives a factor of 1/2. They do not cancel exactly; the net factor is 2.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.9-b-v1', 'mcq', 'scale the centripetal force with speed and radius together using F proportional to v²/r (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small ball on a light string moves in a horizontal circle on a frictionless table, so the string tension is the only horizontal force on it. At speed v on a circle of radius r the tension is 12 N. The ball is later whirled at speed 3v on a circle of radius 3r. What is the new tension?', null, md5('apphysics1-mcq-b5-sv-h-2.9-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '108 N, because the tension is proportional to v².', false, 'The tension is proportional to v²/r. The tripled radius divides the factor of 9 by 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 N, because the triple speed and triple radius cancel.', false, 'The speed counts as v², a factor of 9, but the radius is only a factor of 1/3. The net factor is 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '324 N, because both the speed and the radius increase the tension.', false, 'A larger radius lowers the tension, since r is in the denominator of mv²/r.' from version_ins
union all select gen_random_uuid(), id, 'D', '36 N', true, 'Correct: T = mv²/r. The factor is 3²/3 = 3, so the tension becomes 3 × 12 = 36 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.9-b-v2', 'mcq', 'scale the centripetal force with speed and radius together using F proportional to v²/r (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small ball on a light string moves in a horizontal circle on a frictionless table, so the string tension is the only horizontal force on it. At speed v on a circle of radius r the tension is 15 N. The ball is later whirled at speed 2v on a circle of radius 4r. What is the new tension?', null, md5('apphysics1-mcq-b5-sv-h-2.9-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 N, because the tension is proportional to v².', false, 'The tension is proportional to v²/r, and the larger radius divides the factor of 4 by 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '30 N, because the tension is proportional to the speed.', false, 'The tension is proportional to the square of the speed, not the speed itself. The factor from speed is 4 and the factor from radius is 1/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.75 N, because only the larger radius matters.', false, 'The doubled speed multiplies the tension by 4 and the quadrupled radius divides it by 4. The effect of the radius alone is not the full picture.' from version_ins
union all select gen_random_uuid(), id, 'D', '15 N', true, 'Correct: T = mv²/r. The factor is 2²/4 = 1, so the tension stays 15 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.9-b-v3', 'mcq', 'scale the centripetal force with speed and radius together using F proportional to v²/r (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small ball on a light string moves in a horizontal circle on a frictionless table, so the string tension is the only horizontal force on it. At speed v on a circle of radius r the tension is 4.0 N. The ball is later whirled at speed 3v on a circle of radius r/2. What is the new tension?', null, md5('apphysics1-mcq-b5-sv-h-2.9-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '36 N, because the tension is proportional to v².', false, 'The speed gives a factor of 9, but the halved radius gives another factor of 2, since r is in the denominator.' from version_ins
union all select gen_random_uuid(), id, 'B', '24 N, because the tension is proportional to the speed.', false, 'The tension varies with the square of the speed, so the speed alone contributes a factor of 9, not 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '72 N', true, 'Correct: T = mv²/r. The factor is 3²/(1/2) = 18, so the tension becomes 18 × 4.0 = 72 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '12 N, because only the tripled speed matters.', false, 'The speed change alone gives 9 times, and the smaller radius doubles it again. A factor of 3 is wrong on both counts.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.8-b-v3','apphysics1-mcq-b5-h-2.9-a','apphysics1-mcq-b5-sv-h-2.9-a-v1','apphysics1-mcq-b5-sv-h-2.9-a-v2','apphysics1-mcq-b5-sv-h-2.9-a-v3','apphysics1-mcq-b5-h-2.9-b','apphysics1-mcq-b5-sv-h-2.9-b-v1','apphysics1-mcq-b5-sv-h-2.9-b-v2','apphysics1-mcq-b5-sv-h-2.9-b-v3']) and status='draft')<>9 then raise exception 'chunk 8: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b5-sv-h-2.8-b-v3','apphysics1-mcq-b5-h-2.9-a','apphysics1-mcq-b5-sv-h-2.9-a-v1','apphysics1-mcq-b5-sv-h-2.9-a-v2','apphysics1-mcq-b5-sv-h-2.9-a-v3','apphysics1-mcq-b5-h-2.9-b','apphysics1-mcq-b5-sv-h-2.9-b-v1','apphysics1-mcq-b5-sv-h-2.9-b-v2','apphysics1-mcq-b5-sv-h-2.9-b-v3']))<>36 then raise exception 'chunk 8: expected 36 choices'; end if;
end $$;
commit;
