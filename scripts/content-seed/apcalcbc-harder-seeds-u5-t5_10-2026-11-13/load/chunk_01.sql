begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b17-h-5.10-a','apcalcbc-mcq-b17-sv-h-5.10-a-v1','apcalcbc-mcq-b17-sv-h-5.10-a-v2','apcalcbc-mcq-b17-sv-h-5.10-a-v3','apcalcbc-mcq-b17-h-5.10-b','apcalcbc-mcq-b17-sv-h-5.10-b-v1','apcalcbc-mcq-b17-sv-h-5.10-b-v2','apcalcbc-mcq-b17-sv-h-5.10-b-v3','apcalcbc-mcq-b17-h-5.10-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b17-h-5.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b17-h-5.10-a', 'mcq', 'three-sided fence area and domain', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rectangular pen borders a straight river, so no fence is needed along the river. Exactly 40 meters of fence covers the other three sides. If x is the width perpendicular to the river, which single-variable area function and physical domain should be optimized?', null, md5('apcalcbc-mcq-b17-h-5.10-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A(x)=x(40−x), with 0<x<40.', false, 'Only one perpendicular side is subtracted; the enclosure requires two fenced widths.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A(x)=x(40−2x), with 0<x<20.', true, 'Correct: Two widths use 2x of the 40 units of fence, leaving river-parallel length 40−2x. Area is width times that length, and both must be positive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A(x)=x(40−4x), with 0<x<10.', false, 'This subtracts four widths as if all sides used equal fence, contrary to the three-sided constraint.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A(x)=2x(40−2x), with 0<x<20.', false, 'The factor 2 counts two copies of the area rather than the single rectangle''s area.' from version_ins;
-- apcalcbc-mcq-b17-sv-h-5.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b17-sv-h-5.10-a-v1', 'mcq', 'three-sided fence area and domain (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rectangular pen borders a straight river, so no fence is needed along the river. Exactly 60 feet of fence covers the other three sides. If x is the width perpendicular to the river, which single-variable area function and physical domain should be optimized?', null, md5('apcalcbc-mcq-b17-sv-h-5.10-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A(x)=x(60−x), with 0<x<60.', false, 'Only one perpendicular side is subtracted; the enclosure requires two fenced widths.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A(x)=x(60−4x), with 0<x<15.', false, 'This subtracts four widths as if all sides used equal fence, contrary to the three-sided constraint.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A(x)=2x(60−2x), with 0<x<30.', false, 'The factor 2 counts two copies of the area rather than the single rectangle''s area.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A(x)=x(60−2x), with 0<x<30.', true, 'Correct: Two widths use 2x of the 60 units of fence, leaving river-parallel length 60−2x. Area is width times that length, and both must be positive.' from version_ins;
-- apcalcbc-mcq-b17-sv-h-5.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b17-sv-h-5.10-a-v2', 'mcq', 'three-sided fence area and domain (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rectangular pen borders a straight river, so no fence is needed along the river. Exactly 80 meters of fence covers the other three sides. If x is the width perpendicular to the river, which single-variable area function and physical domain should be optimized?', null, md5('apcalcbc-mcq-b17-sv-h-5.10-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A(x)=x(80−2x), with 0<x<40.', true, 'Correct: Two widths use 2x of the 80 units of fence, leaving river-parallel length 80−2x. Area is width times that length, and both must be positive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A(x)=x(80−x), with 0<x<80.', false, 'Only one perpendicular side is subtracted; the enclosure requires two fenced widths.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A(x)=x(80−4x), with 0<x<20.', false, 'This subtracts four widths as if all sides used equal fence, contrary to the three-sided constraint.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A(x)=2x(80−2x), with 0<x<40.', false, 'The factor 2 counts two copies of the area rather than the single rectangle''s area.' from version_ins;
-- apcalcbc-mcq-b17-sv-h-5.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b17-sv-h-5.10-a-v3', 'mcq', 'three-sided fence area and domain (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rectangular pen borders a straight river, so no fence is needed along the river. Exactly 100 feet of fence covers the other three sides. If x is the width perpendicular to the river, which single-variable area function and physical domain should be optimized?', null, md5('apcalcbc-mcq-b17-sv-h-5.10-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A(x)=x(100−x), with 0<x<100.', false, 'Only one perpendicular side is subtracted; the enclosure requires two fenced widths.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A(x)=x(100−4x), with 0<x<25.', false, 'This subtracts four widths as if all sides used equal fence, contrary to the three-sided constraint.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A(x)=x(100−2x), with 0<x<50.', true, 'Correct: Two widths use 2x of the 100 units of fence, leaving river-parallel length 100−2x. Area is width times that length, and both must be positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A(x)=2x(100−2x), with 0<x<50.', false, 'The factor 2 counts two copies of the area rather than the single rectangle''s area.' from version_ins;
-- apcalcbc-mcq-b17-h-5.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b17-h-5.10-b', 'mcq', 'open-top box volume and domain', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An open-top box is made by cutting an x-by-x square from every corner of a square sheet with side 12 inches, then folding up the flaps. Which volume function and allowable positive x interval give the optimization problem?', null, md5('apcalcbc-mcq-b17-h-5.10-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'V(x)=x(12−x)² for 0<x<12.', false, 'A base side loses two cut lengths, not one; this overstates the base and domain.' from version_ins
union all select gen_random_uuid(), id, 'B', 'V(x)=x(12−2x)² for 0<x<6.', true, 'Correct: Each base side loses x at each end, becoming 12−2x; the folded height is x. A positive base requires x<6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'V(x)=x(12−2x) for 0<x<6.', false, 'This omits one base dimension and has area units rather than volume units.' from version_ins
union all select gen_random_uuid(), id, 'D', 'V(x)=(12−2x)² for 0<x<6.', false, 'This gives base area but omits the height x needed for volume.' from version_ins;
-- apcalcbc-mcq-b17-sv-h-5.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b17-sv-h-5.10-b-v1', 'mcq', 'open-top box volume and domain (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An open-top box is made by cutting an x-by-x square from every corner of a square sheet with side 18 centimeters, then folding up the flaps. Which volume function and allowable positive x interval give the optimization problem?', null, md5('apcalcbc-mcq-b17-sv-h-5.10-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'V(x)=x(18−2x)² for 0<x<9.', true, 'Correct: Each base side loses x at each end, becoming 18−2x; the folded height is x. A positive base requires x<9.' from version_ins
union all select gen_random_uuid(), id, 'B', 'V(x)=x(18−x)² for 0<x<18.', false, 'A base side loses two cut lengths, not one; this overstates the base and domain.' from version_ins
union all select gen_random_uuid(), id, 'C', 'V(x)=x(18−2x) for 0<x<9.', false, 'This omits one base dimension and has area units rather than volume units.' from version_ins
union all select gen_random_uuid(), id, 'D', 'V(x)=(18−2x)² for 0<x<9.', false, 'This gives base area but omits the height x needed for volume.' from version_ins;
-- apcalcbc-mcq-b17-sv-h-5.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b17-sv-h-5.10-b-v2', 'mcq', 'open-top box volume and domain (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An open-top box is made by cutting x-by-x squares from the four corners of a 24-inch square sheet and folding up the flaps. Among boxes with positive height and base dimensions, which cut size produces the greatest volume, and what is that volume?', null, md5('apcalcbc-mcq-b17-sv-h-5.10-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cut x=12 inches; the maximum volume is 0 cubic inches.', false, 'A cut of 12 leaves zero base dimensions and is outside the positive-volume domain.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cut x=4 inches; the maximum volume is 1,024 cubic inches.', true, 'Correct: The domain is 0<x<12, and V=x(24−2x)². Its derivative is (24−2x)(24−6x), so the interior critical point is x=4; V(4)=4(16)²=1,024, while volume tends to zero at both domain boundaries.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cut x=6 inches; the maximum volume is 864 cubic inches.', false, 'The stated volume at x=6 is correct, but V''(6)<0 and it is smaller than V(4).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cut x=8 inches; the maximum volume is 512 cubic inches.', false, 'The stated volume at x=8 is correct, but it is smaller than V(4).' from version_ins;
-- apcalcbc-mcq-b17-sv-h-5.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b17-sv-h-5.10-b-v3', 'mcq', 'open-top box volume and domain (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An open-top box is made by cutting an x-by-x square from every corner of a square sheet with side 30 centimeters, then folding up the flaps. Which volume function and allowable positive x interval give the optimization problem?', null, md5('apcalcbc-mcq-b17-sv-h-5.10-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'V(x)=x(30−2x)² for 0<x<15.', true, 'Correct: Each base side loses x at each end, becoming 30−2x; the folded height is x. A positive base requires x<15.' from version_ins
union all select gen_random_uuid(), id, 'B', 'V(x)=x(30−x)² for 0<x<30.', false, 'A base side loses two cut lengths, not one; this overstates the base and domain.' from version_ins
union all select gen_random_uuid(), id, 'C', 'V(x)=x(30−2x) for 0<x<15.', false, 'This omits one base dimension and has area units rather than volume units.' from version_ins
union all select gen_random_uuid(), id, 'D', 'V(x)=(30−2x)² for 0<x<15.', false, 'This gives base area but omits the height x needed for volume.' from version_ins;
-- apcalcbc-mcq-b17-h-5.10-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b17-h-5.10-c', 'mcq', 'cost-weighted cylinder objective', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cylindrical container must hold 100π cubic units. It has two circular caps. Material for each circular face costs 1 currency units per square unit, and material for the curved side costs 1 per square unit. If r>0 is the radius and h is height, which cost function of r alone should be minimized?', null, md5('apcalcbc-mcq-b17-h-5.10-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C(r)=2πr²+100π/r, for r>0.', false, 'The curved area is 2πrh; dropping its factor 2 undercounts side material.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C(r)=2πr²+200πr, for r>0.', false, 'Substituting h=V/(πr²) makes the curved cost proportional to 1/r, not r.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C(r)=2πr²+200π/r, for r>0.', true, 'Correct: The volume constraint πr²h=100π gives h=100/r². Face cost is 2πr²; curved-side cost is 1(2πrh)=200π/r. Any r>0 gives a positive h.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C(r)=2πr²+200π/r, for r>100.', false, 'Radius has no lower bound of the numerical volume; every positive radius yields a positive height.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b17-h-5.10-a','apcalcbc-mcq-b17-sv-h-5.10-a-v1','apcalcbc-mcq-b17-sv-h-5.10-a-v2','apcalcbc-mcq-b17-sv-h-5.10-a-v3','apcalcbc-mcq-b17-h-5.10-b','apcalcbc-mcq-b17-sv-h-5.10-b-v1','apcalcbc-mcq-b17-sv-h-5.10-b-v2','apcalcbc-mcq-b17-sv-h-5.10-b-v3','apcalcbc-mcq-b17-h-5.10-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b17-h-5.10-a','apcalcbc-mcq-b17-sv-h-5.10-a-v1','apcalcbc-mcq-b17-sv-h-5.10-a-v2','apcalcbc-mcq-b17-sv-h-5.10-a-v3','apcalcbc-mcq-b17-h-5.10-b','apcalcbc-mcq-b17-sv-h-5.10-b-v1','apcalcbc-mcq-b17-sv-h-5.10-b-v2','apcalcbc-mcq-b17-sv-h-5.10-b-v3','apcalcbc-mcq-b17-h-5.10-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
