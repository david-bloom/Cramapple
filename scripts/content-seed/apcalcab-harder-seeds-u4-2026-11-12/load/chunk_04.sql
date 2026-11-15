begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-sv-h-4.4-a-v3','apcalcab-mcq-b4-h-4.4-b','apcalcab-mcq-b4-sv-h-4.4-b-v1','apcalcab-mcq-b4-sv-h-4.4-b-v2','apcalcab-mcq-b4-sv-h-4.4-b-v3','apcalcab-mcq-b4-h-4.5-a','apcalcab-mcq-b4-sv-h-4.5-a-v1','apcalcab-mcq-b4-sv-h-4.5-a-v2','apcalcab-mcq-b4-sv-h-4.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apcalcab-mcq-b4-sv-h-4.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.4-a-v3', 'mcq', 'build a relationship from similar triangles and differentiate it with respect to time. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4-foot-tall child walks toward a lantern that is 12 feet tall. Let x be the child''s distance from the base of the lantern and s the length of the child''s shadow, both in feet. Which equation correctly relates ds/dt and dx/dt?', null, md5('apcalcab-mcq-b4-sv-h-4.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ds/dt = (1/3)·dx/dt', false, 'This uses the ratio of heights 4/12 directly. The similar triangles give 12/(x + s) = 4/s, which leads to s = x/2, not s = x/3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'ds/dt = dx/dt', false, 'This assumes the shadow''s length changes at the same rate as the child''s distance. The shadow length s is only a fraction of x, so it changes more slowly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ds/dt = (3/2)·dx/dt', false, 'This is the rate at which the tip of the shadow moves, d(x + s)/dt, not the rate at which the shadow''s length s changes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ds/dt = (1/2)·dx/dt', true, 'Correct: Similar triangles: 12/(x + s) = 4/s, so 12s = 4x + 4s, 8s = 4x, s = x/2. Differentiating with respect to t gives ds/dt = (1/2)·dx/dt; dx/dt is negative here, so the shadow shortens.' from version_ins;
-- apcalcab-mcq-b4-h-4.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.4-b', 'mcq', 'reduce a two-variable volume formula to one variable using a stated constraint, then differentiate with respect to time.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water is draining from a conical tank with its vertex pointing down. At every moment the radius r and depth h of the water satisfy r = h/2, and the volume of water is V = (1/3)πr²h. Which expression gives dV/dt in terms of h and dh/dt?', null, md5('apcalcab-mcq-b4-h-4.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'dV/dt = (π/12)h²·dh/dt', false, 'This differentiates (1/3)πr²h as if r were constant and then replaces r by h/2. Since r changes with h, the constraint must be used before differentiating.' from version_ins
union all select gen_random_uuid(), id, 'B', 'dV/dt = (π/4)h²·dh/dt', true, 'Correct: Substitute r = h/2: V = (1/3)π(h/2)²h = (π/12)h³. Then dV/dt = (π/12)(3h²)·dh/dt = (π/4)h²·dh/dt.' from version_ins
union all select gen_random_uuid(), id, 'C', 'dV/dt = (π/12)h³', false, 'This is the volume V itself after substituting r = h/2. It has not been differentiated and has no factor dh/dt.' from version_ins
union all select gen_random_uuid(), id, 'D', 'dV/dt = (π/4)h³·dh/dt', false, 'The factor 3 is brought down but the exponent is not reduced. The derivative of h³ is 3h², not 3h³.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.4-b-v1', 'mcq', 'reduce a two-variable volume formula to one variable using a stated constraint, then differentiate with respect to time. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A conical funnel with its vertex pointing down is being filled with oil. At every moment the radius r and depth h of the oil satisfy r = h/3, and the volume of oil is V = (1/3)πr²h. Which expression gives dV/dt in terms of h and dh/dt?', null, md5('apcalcab-mcq-b4-sv-h-4.4-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'dV/dt = (π/27)h²·dh/dt', false, 'This differentiates (1/3)πr²h as if r were constant and then replaces r by h/3. Since r changes with h, the constraint must be used before differentiating.' from version_ins
union all select gen_random_uuid(), id, 'B', 'dV/dt = (π/27)h³', false, 'This is the volume V itself after substituting r = h/3. It has not been differentiated and has no factor dh/dt.' from version_ins
union all select gen_random_uuid(), id, 'C', 'dV/dt = (π/9)h²·dh/dt', true, 'Correct: Substitute r = h/3: V = (1/3)π(h/3)²h = (π/27)h³. Then dV/dt = (π/27)(3h²)·dh/dt = (π/9)h²·dh/dt.' from version_ins
union all select gen_random_uuid(), id, 'D', 'dV/dt = (π/9)h³·dh/dt', false, 'The factor 3 is brought down but the exponent is not reduced. The derivative of h³ is 3h², not 3h³.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.4-b-v2', 'mcq', 'reduce a two-variable volume formula to one variable using a stated constraint, then differentiate with respect to time. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Grain is poured into an inverted conical bin with its vertex pointing down. At every moment the radius r and depth h of the grain satisfy r = 2h, and the volume of grain is V = (1/3)πr²h. Which expression gives dV/dt in terms of h and dh/dt?', null, md5('apcalcab-mcq-b4-sv-h-4.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'dV/dt = (4π/3)h²·dh/dt', false, 'This differentiates (1/3)πr²h as if r were constant and then replaces r by 2h. Since r changes with h, the constraint must be used before differentiating.' from version_ins
union all select gen_random_uuid(), id, 'B', 'dV/dt = 4πh²·dh/dt', true, 'Correct: Substitute r = 2h: V = (1/3)π(2h)²h = (4π/3)h³. Then dV/dt = (4π/3)(3h²)·dh/dt = 4πh²·dh/dt.' from version_ins
union all select gen_random_uuid(), id, 'C', 'dV/dt = (4π/3)h³', false, 'This is the volume V itself after substituting r = 2h. It has not been differentiated and has no factor dh/dt.' from version_ins
union all select gen_random_uuid(), id, 'D', 'dV/dt = 4πh³·dh/dt', false, 'The factor 3 is brought down but the exponent is not reduced. The derivative of h³ is 3h², not 3h³.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.4-b-v3', 'mcq', 'reduce a two-variable volume formula to one variable using a stated constraint, then differentiate with respect to time. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A trough 5 meters long has triangular ends, and water is flowing into it. At every moment the width w of the water surface and the depth h of the water satisfy w = h, and the volume of water is V = (5/2)wh. Which expression gives dV/dt in terms of h and dh/dt?', null, md5('apcalcab-mcq-b4-sv-h-4.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'dV/dt = 5h·dh/dt', true, 'Correct: Substitute w = h: V = (5/2)h². Then dV/dt = (5/2)(2h)·dh/dt = 5h·dh/dt.' from version_ins
union all select gen_random_uuid(), id, 'B', 'dV/dt = (5/2)h·dh/dt', false, 'This differentiates (5/2)wh as if w were constant and then replaces w by h. Since w changes with h, the constraint must be used before differentiating.' from version_ins
union all select gen_random_uuid(), id, 'C', 'dV/dt = (5/2)h²', false, 'This is the volume V itself after substituting w = h. It has not been differentiated and has no factor dh/dt.' from version_ins
union all select gen_random_uuid(), id, 'D', 'dV/dt = 5h²·dh/dt', false, 'The factor 2 is brought down but the exponent is not reduced. The derivative of h² is 2h, not 2h².' from version_ins;
-- apcalcab-mcq-b4-h-4.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.5-a', 'mcq', 'use a constraint to write V in one variable, differentiate, and evaluate at an instant without substituting the value ea', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Sand is poured onto a flat surface at a rate of 5 cubic meters per minute and forms a conical pile whose height always equals its base radius. How fast is the height of the pile increasing at the instant when the height is 4 meters?', null, md5('apcalcab-mcq-b4-h-4.5-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15/(16π) meters per minute', false, 'This differentiates V = (1/3)πr²h with r held at its current value of 4, so the dependence of r on h is lost. The result is three times too large.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/(48π) meters per minute', false, 'This uses V = πh³ and omits the factor 1/3 from the volume of a cone, so the result is one third of the correct rate.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 meters per minute', false, 'This substitutes h = 4 into the volume formula before differentiating, which turns V into a constant whose derivative is 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '5/(16π) meters per minute', true, 'Correct: Since r = h, V = (1/3)πh³ and dV/dt = πh²·dh/dt. At h = 4: 5 = π(16)·dh/dt, so dh/dt = 5/(16π) ≈ 0.10 meters per minute.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.5-a-v1', 'mcq', 'use a constraint to write V in one variable, differentiate, and evaluate at an instant without substituting the value ea (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Salt falls from a conveyor at a rate of 3 cubic meters per minute and forms a conical pile whose base radius is always half its height. How fast is the height of the pile increasing at the instant when the height is 6 meters?', null, md5('apcalcab-mcq-b4-sv-h-4.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/π meters per minute', false, 'This differentiates V = (1/3)πr²h with r held at its current value of 3, so the dependence of r on h is lost. The result is three times too large.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/(3π) meters per minute', true, 'Correct: Since r = h/2, V = (1/3)π(h²/4)h = (π/12)h³ and dV/dt = (π/4)h²·dh/dt. At h = 6: 3 = 9π·dh/dt, so dh/dt = 1/(3π) meters per minute.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/(9π) meters per minute', false, 'This uses V = πr²h and omits the factor 1/3 from the volume of a cone, so the result is one third of the correct rate.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 meters per minute', false, 'This substitutes h = 6 into the volume formula before differentiating, which turns V into a constant whose derivative is 0.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.5-a-v2', 'mcq', 'use a constraint to write V in one variable, differentiate, and evaluate at an instant without substituting the value ea (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Grain pours from a chute at 8 cubic feet per minute and forms a conical pile whose base radius is always twice its height. How fast is the height of the pile increasing at the instant when the height is 1.5 feet?', null, md5('apcalcab-mcq-b4-sv-h-4.5-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8/(9π) feet per minute', true, 'Correct: Since r = 2h, V = (1/3)π(4h²)h = (4π/3)h³ and dV/dt = 4πh²·dh/dt. At h = 1.5: 8 = 9π·dh/dt, so dh/dt = 8/(9π) feet per minute.' from version_ins
union all select gen_random_uuid(), id, 'B', '8/(3π) feet per minute', false, 'This differentiates V = (1/3)πr²h with r held at its current value of 3, so the dependence of r on h is lost. The result is three times too large.' from version_ins
union all select gen_random_uuid(), id, 'C', '8/(27π) feet per minute', false, 'This uses V = πr²h and omits the factor 1/3 from the volume of a cone, so the result is one third of the correct rate.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 feet per minute', false, 'This substitutes h = 1.5 into the volume formula before differentiating, which turns V into a constant whose derivative is 0.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.5-a-v3', 'mcq', 'use a constraint to write V in one variable, differentiate, and evaluate at an instant without substituting the value ea (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water drains from a conical tank, vertex down, at 12 cubic feet per minute. The water''s radius is always three-fourths of its depth. How fast is the water level changing at the instant when the depth is 4 feet?', null, md5('apcalcab-mcq-b4-sv-h-4.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is falling at 4/π feet per minute.', false, 'This differentiates V = (1/3)πr²h with r held at its current value of 3, so the dependence of r on h is lost. The result is three times too large.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is falling at 4/(3π) feet per minute.', true, 'Correct: Since r = (3/4)h, V = (1/3)π(9h²/16)h = (3π/16)h³ and dV/dt = (9π/16)h²·dh/dt. At h = 4: −12 = 9π·dh/dt, so dh/dt = −4/(3π) feet per minute.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is falling at 4/(9π) feet per minute.', false, 'This uses V = πr²h and omits the factor 1/3 from the volume of a cone, so the result is one third of the correct rate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is rising at 4/(3π) feet per minute.', false, 'The magnitude is right, but the tank is draining, so dV/dt = −12 and the depth must be decreasing. This answer ignores the negative sign.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-sv-h-4.4-a-v3','apcalcab-mcq-b4-h-4.4-b','apcalcab-mcq-b4-sv-h-4.4-b-v1','apcalcab-mcq-b4-sv-h-4.4-b-v2','apcalcab-mcq-b4-sv-h-4.4-b-v3','apcalcab-mcq-b4-h-4.5-a','apcalcab-mcq-b4-sv-h-4.5-a-v1','apcalcab-mcq-b4-sv-h-4.5-a-v2','apcalcab-mcq-b4-sv-h-4.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b4-sv-h-4.4-a-v3','apcalcab-mcq-b4-h-4.4-b','apcalcab-mcq-b4-sv-h-4.4-b-v1','apcalcab-mcq-b4-sv-h-4.4-b-v2','apcalcab-mcq-b4-sv-h-4.4-b-v3','apcalcab-mcq-b4-h-4.5-a','apcalcab-mcq-b4-sv-h-4.5-a-v1','apcalcab-mcq-b4-sv-h-4.5-a-v2','apcalcab-mcq-b4-sv-h-4.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
