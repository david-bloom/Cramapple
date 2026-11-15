begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b18-h-5.11-a','apcalcab-mcq-b18-sv-h-5.11-a-v1','apcalcab-mcq-b18-sv-h-5.11-a-v2','apcalcab-mcq-b18-sv-h-5.11-a-v3','apcalcab-mcq-b18-h-5.11-b','apcalcab-mcq-b18-sv-h-5.11-b-v1','apcalcab-mcq-b18-sv-h-5.11-b-v2','apcalcab-mcq-b18-sv-h-5.11-b-v3','apcalcab-mcq-b18-h-5.11-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-b18-h-5.11-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b18-h-5.11-a', 'mcq', 'open-top cylinder minimum area', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An open-top cylindrical tank must contain 8π cubic meters. Its circular base and curved side use the same material. What radius and height minimize the material area, and what does that result mean for the tank?', null, md5('apcalcab-mcq-b18-h-5.11-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Radius 1 m and height 8 m; this is the least material area.', false, 'These dimensions meet the volume requirement, but the area derivative is negative at radius 1, so a larger radius uses less material.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Radius 2 m and height 2 m; this is the least material area among positive dimensions holding 8π m³.', true, 'Correct: From πr²h=8π, h=8/r² and S(r)=πr²+16π/r. S''(r)=2πr−16π/r² vanishes only at r³=8, so r=2 and h=2. The area tends to infinity at both positive-domain ends, so this is the global minimum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Radius 4 m and height 0.5 m; this is the least material area.', false, 'Doubling the optimal radius keeps the volume but increases area; the area derivative is positive there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Radius 6 m and height 2/9 m; this is the least material area.', false, 'Tripling the optimal radius makes a much wider, shallower tank and increases material area.' from version_ins;
-- apcalcab-mcq-b18-sv-h-5.11-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b18-sv-h-5.11-a-v1', 'mcq', 'open-top cylinder minimum area (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An open-top cylindrical tank must contain 27π cubic meters. Its circular base and curved side use the same material. What radius and height minimize the material area, and what does that result mean for the tank?', null, md5('apcalcab-mcq-b18-sv-h-5.11-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Radius 1 m and height 27 m; this is the least material area.', false, 'These dimensions meet the volume requirement, but the area derivative is negative at radius 1, so a larger radius uses less material.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Radius 6 m and height 0.75 m; this is the least material area.', false, 'Doubling the optimal radius keeps the volume but increases area; the area derivative is positive there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Radius 9 m and height 3/9 m; this is the least material area.', false, 'Tripling the optimal radius makes a much wider, shallower tank and increases material area.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Radius 3 m and height 3 m; this is the least material area among positive dimensions holding 27π m³.', true, 'Correct: From πr²h=27π, h=27/r² and S(r)=πr²+54π/r. S''(r)=2πr−54π/r² vanishes only at r³=27, so r=3 and h=3. The area tends to infinity at both positive-domain ends, so this is the global minimum.' from version_ins;
-- apcalcab-mcq-b18-sv-h-5.11-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b18-sv-h-5.11-a-v2', 'mcq', 'open-top cylinder minimum area (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An open-top cylindrical tank must contain 64π cubic meters. Its circular base and curved side use the same material. What radius and height minimize the material area, and what does that result mean for the tank?', null, md5('apcalcab-mcq-b18-sv-h-5.11-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Radius 4 m and height 4 m; this is the least material area among positive dimensions holding 64π m³.', true, 'Correct: From πr²h=64π, h=64/r² and S(r)=πr²+128π/r. S''(r)=2πr−128π/r² vanishes only at r³=64, so r=4 and h=4. The area tends to infinity at both positive-domain ends, so this is the global minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Radius 1 m and height 64 m; this is the least material area.', false, 'These dimensions meet the volume requirement, but the area derivative is negative at radius 1, so a larger radius uses less material.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Radius 8 m and height 1 m; this is the least material area.', false, 'Doubling the optimal radius keeps the volume but increases area; the area derivative is positive there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Radius 12 m and height 4/9 m; this is the least material area.', false, 'Tripling the optimal radius makes a much wider, shallower tank and increases material area.' from version_ins;
-- apcalcab-mcq-b18-sv-h-5.11-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b18-sv-h-5.11-a-v3', 'mcq', 'open-top cylinder minimum area (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An open-top cylindrical tank must contain 125π cubic meters. Its circular base and curved side use the same material. What radius and height minimize the material area, and what does that result mean for the tank?', null, md5('apcalcab-mcq-b18-sv-h-5.11-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Radius 1 m and height 125 m; this is the least material area.', false, 'These dimensions meet the volume requirement, but the area derivative is negative at radius 1, so a larger radius uses less material.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Radius 10 m and height 1.25 m; this is the least material area.', false, 'Doubling the optimal radius keeps the volume but increases area; the area derivative is positive there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Radius 5 m and height 5 m; this is the least material area among positive dimensions holding 125π m³.', true, 'Correct: From πr²h=125π, h=125/r² and S(r)=πr²+250π/r. S''(r)=2πr−250π/r² vanishes only at r³=125, so r=5 and h=5. The area tends to infinity at both positive-domain ends, so this is the global minimum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Radius 15 m and height 5/9 m; this is the least material area.', false, 'Tripling the optimal radius makes a much wider, shallower tank and increases material area.' from version_ins;
-- apcalcab-mcq-b18-h-5.11-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b18-h-5.11-b', 'mcq', 'two-pen fence maximum area', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A farmer has 120 meters of fencing for a rectangular field and one interior fence parallel to the two shorter sides, making two pens. The interior fence spans the field''s width. What field dimensions give the greatest total enclosed area, and what is that area?', null, md5('apcalcab-mcq-b18-h-5.11-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Width 30 m, length 15 m; total area 450 m².', false, 'This feasible width lies past the vertex of the concave area function, so its area is smaller.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Width 20 m, length 30 m; maximum total area 600 m².', true, 'Correct: With width w and length l, 3w+2l=120. Thus A(w)=w(120−3w)/2, 0<w<40. The quadratic is concave and A''=(120−6w)/2=0 at w=20; l=30, giving 600 m².' from version_ins
union all select gen_random_uuid(), id, 'C', 'Width 10 m, length 45 m; total area 450 m².', false, 'This feasible width lies before the vertex, so its area is smaller.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Width 30 m, length 30 m; total area 900 m².', false, 'A square of those dimensions requires more fencing once the interior divider is included.' from version_ins;
-- apcalcab-mcq-b18-sv-h-5.11-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b18-sv-h-5.11-b-v1', 'mcq', 'two-pen fence maximum area (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A farmer has 144 meters of fencing for a rectangular field and one interior fence parallel to the two shorter sides, making two pens. The interior fence spans the field''s width. What field dimensions give the greatest total enclosed area, and what is that area?', null, md5('apcalcab-mcq-b18-sv-h-5.11-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Width 24 m, length 36 m; maximum total area 864 m².', true, 'Correct: With width w and length l, 3w+2l=144. Thus A(w)=w(144−3w)/2, 0<w<48. The quadratic is concave and A''=(144−6w)/2=0 at w=24; l=36, giving 864 m².' from version_ins
union all select gen_random_uuid(), id, 'B', 'Width 36 m, length 18 m; total area 648 m².', false, 'This feasible width lies past the vertex of the concave area function, so its area is smaller.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Width 12 m, length 54 m; total area 648 m².', false, 'This feasible width lies before the vertex, so its area is smaller.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Width 36 m, length 36 m; total area 1296 m².', false, 'A square of those dimensions requires more fencing once the interior divider is included.' from version_ins;
-- apcalcab-mcq-b18-sv-h-5.11-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b18-sv-h-5.11-b-v2', 'mcq', 'two-pen fence maximum area (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A farmer has 168 meters of fencing for a rectangular field and one interior fence parallel to the two shorter sides, making two pens. The interior fence spans the field''s width. What field dimensions give the greatest total enclosed area, and what is that area?', null, md5('apcalcab-mcq-b18-sv-h-5.11-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Width 42 m, length 21 m; total area 882 m².', false, 'This feasible width lies past the vertex of the concave area function, so its area is smaller.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Width 28 m, length 42 m; maximum total area 1176 m².', true, 'Correct: With width w and length l, 3w+2l=168. Thus A(w)=w(168−3w)/2, 0<w<56. The quadratic is concave and A''=(168−6w)/2=0 at w=28; l=42, giving 1176 m².' from version_ins
union all select gen_random_uuid(), id, 'C', 'Width 14 m, length 63 m; total area 882 m².', false, 'This feasible width lies before the vertex, so its area is smaller.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Width 42 m, length 42 m; total area 1764 m².', false, 'A square of those dimensions requires more fencing once the interior divider is included.' from version_ins;
-- apcalcab-mcq-b18-sv-h-5.11-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b18-sv-h-5.11-b-v3', 'mcq', 'two-pen fence maximum area (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A farmer has 192 meters of fencing for a rectangular field and one interior fence parallel to the two shorter sides, making two pens. The interior fence spans the field''s width. What field dimensions give the greatest total enclosed area, and what is that area?', null, md5('apcalcab-mcq-b18-sv-h-5.11-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Width 32 m, length 48 m; maximum total area 1536 m².', true, 'Correct: With width w and length l, 3w+2l=192. Thus A(w)=w(192−3w)/2, 0<w<64. The quadratic is concave and A''=(192−6w)/2=0 at w=32; l=48, giving 1536 m².' from version_ins
union all select gen_random_uuid(), id, 'B', 'Width 48 m, length 24 m; total area 1152 m².', false, 'This feasible width lies past the vertex of the concave area function, so its area is smaller.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Width 16 m, length 72 m; total area 1152 m².', false, 'This feasible width lies before the vertex, so its area is smaller.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Width 48 m, length 48 m; total area 2304 m².', false, 'A square of those dimensions requires more fencing once the interior divider is included.' from version_ins;
-- apcalcab-mcq-b18-h-5.11-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b18-h-5.11-c', 'mcq', 'linear-demand maximum profit', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A shop can sell q=100−2p items per week when each sells for p dollars, where demand is positive. The variable cost is $10 per item and there is no fixed cost. Which price maximizes weekly profit, and what maximum profit does the model predict?', null, md5('apcalcab-mcq-b18-h-5.11-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Price $25; maximum profit equals revenue, so $1250 per week.', false, 'This maximizes revenue p·q but ignores the per-item cost, so it does not maximize profit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Price $10; maximum profit $0 per week.', false, 'Pricing at marginal cost gives zero profit, while the interior critical price gives positive profit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Price $30; maximum profit $800 per week.', true, 'Correct: Profit is P(p)=(p−10)(100−2p). Its derivative is 120−4p, which is zero at p=30; the second derivative is −4<0. Then q=40 and P=800. This price lies in the feasible positive-demand interval.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Price $50; maximum profit $0 per week.', false, 'At this price demand is zero, so profit is zero rather than maximal.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b18-h-5.11-a','apcalcab-mcq-b18-sv-h-5.11-a-v1','apcalcab-mcq-b18-sv-h-5.11-a-v2','apcalcab-mcq-b18-sv-h-5.11-a-v3','apcalcab-mcq-b18-h-5.11-b','apcalcab-mcq-b18-sv-h-5.11-b-v1','apcalcab-mcq-b18-sv-h-5.11-b-v2','apcalcab-mcq-b18-sv-h-5.11-b-v3','apcalcab-mcq-b18-h-5.11-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b18-h-5.11-a','apcalcab-mcq-b18-sv-h-5.11-a-v1','apcalcab-mcq-b18-sv-h-5.11-a-v2','apcalcab-mcq-b18-sv-h-5.11-a-v3','apcalcab-mcq-b18-h-5.11-b','apcalcab-mcq-b18-sv-h-5.11-b-v1','apcalcab-mcq-b18-sv-h-5.11-b-v2','apcalcab-mcq-b18-sv-h-5.11-b-v3','apcalcab-mcq-b18-h-5.11-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
