begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-h-3.8-b','apprecalc-mcq-b2-sv-h-3.8-b-v1','apprecalc-mcq-b2-sv-h-3.8-b-v2','apprecalc-mcq-b2-sv-h-3.8-b-v3','apprecalc-mcq-b2-h-3.9-a','apprecalc-mcq-b2-sv-h-3.9-a-v1','apprecalc-mcq-b2-sv-h-3.9-a-v2','apprecalc-mcq-b2-sv-h-3.9-a-v3','apprecalc-mcq-b2-h-3.9-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apprecalc-mcq-b2-h-3.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.8-b', 'mcq', 'determine whether a transformed tangent goes to +∞ or −∞ approaching an asymptote from a given side, using the signs of ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = −3tan(x − π/4) + 1. The graph of g has a vertical asymptote at x = 3π/4. What happens to g(x) as x approaches 3π/4 from the left?', null, md5('apprecalc-mcq-b2-h-3.8-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(x) increases without bound.', false, 'This has the direction reversed: near this asymptote the tangent part goes to +∞, and the factor −3 flips that direction, so g goes to −∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(x) approaches 1, the vertical shift.', false, 'This treats the vertical shift as a horizontal asymptote, but a tangent graph has no horizontal asymptote; its values are unbounded near a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(x) decreases without bound.', true, 'Correct: Approaching from the left, the inside expression approaches an odd multiple of π/2 from below, so the tangent part goes to +∞; multiplying by −3 gives −∞. Numerical check: g at 1e−7 left of the asymptote is about −3e+07.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(x) approaches 0.', false, 'This assumes the outputs settle at 0 near the asymptote, but the tangent function is undefined there and its values grow without bound in size.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.8-b-v1', 'mcq', 'determine whether a transformed tangent goes to +∞ or −∞ approaching an asymptote from a given side, using the signs of  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = 2tan(2x) − 1. The graph of g has a vertical asymptote at x = π/4. What happens to g(x) as x approaches π/4 from the right?', null, md5('apprecalc-mcq-b2-sv-h-3.8-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(x) decreases without bound.', true, 'Correct: Approaching from the right, the inside expression approaches an odd multiple of π/2 from above, so the tangent part goes to −∞; multiplying by 2 gives −∞. Numerical check: g at 1e−7 right of the asymptote is about −1e+07.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(x) increases without bound.', false, 'This has the direction reversed: near this asymptote the tangent part goes to −∞, and the factor 2 keeps that direction, so g goes to −∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(x) approaches −1, the vertical shift.', false, 'This treats the vertical shift as a horizontal asymptote, but a tangent graph has no horizontal asymptote; its values are unbounded near a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(x) approaches 0.', false, 'This assumes the outputs settle at 0 near the asymptote, but the tangent function is undefined there and its values grow without bound in size.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.8-b-v2', 'mcq', 'determine whether a transformed tangent goes to +∞ or −∞ approaching an asymptote from a given side, using the signs of  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = 4tan(x/2 + π/6) − 2. The graph of g has a vertical asymptote at x = 2π/3. What happens to g(x) as x approaches 2π/3 from the left?', null, md5('apprecalc-mcq-b2-sv-h-3.8-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(x) increases without bound.', true, 'Correct: Approaching from the left, the inside expression approaches an odd multiple of π/2 from below, so the tangent part goes to +∞; multiplying by 4 gives +∞. Numerical check: g at 1e−7 left of the asymptote is about 8e+07.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(x) decreases without bound.', false, 'This has the direction reversed: near this asymptote the tangent part goes to +∞, and the factor 4 keeps that direction, so g goes to +∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(x) approaches −2, the vertical shift.', false, 'This treats the vertical shift as a horizontal asymptote, but a tangent graph has no horizontal asymptote; its values are unbounded near a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(x) approaches 0.', false, 'This assumes the outputs settle at 0 near the asymptote, but the tangent function is undefined there and its values grow without bound in size.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.8-b-v3', 'mcq', 'determine whether a transformed tangent goes to +∞ or −∞ approaching an asymptote from a given side, using the signs of  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = 3tan(−2x + π/6) + 2. The graph of g has a vertical asymptote at x = π/3. What happens to g(x) as x approaches π/3 from the right?', null, md5('apprecalc-mcq-b2-sv-h-3.8-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(x) increases without bound.', true, 'Correct: Approaching from the right, the inside expression approaches an odd multiple of π/2 from below, so the tangent part goes to +∞; multiplying by 3 gives +∞. Numerical check: g at 1e−7 right of the asymptote is about 1.5e+07.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(x) decreases without bound.', false, 'This has the direction reversed: near this asymptote the tangent part goes to +∞, and the factor 3 keeps that direction, so g goes to +∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(x) approaches 2, the vertical shift.', false, 'This treats the vertical shift as a horizontal asymptote, but a tangent graph has no horizontal asymptote; its values are unbounded near a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(x) approaches 0.', false, 'This assumes the outputs settle at 0 near the asymptote, but the tangent function is undefined there and its values grow without bound in size.' from version_ins;
-- apprecalc-mcq-b2-h-3.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.9-a', 'mcq', 'evaluate arcsin, arccos or arctan of the matching trigonometric function at an angle outside the principal range, instea', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the exact value of arcsin(sin(7π/6))?', null, md5('apprecalc-mcq-b2-h-3.9-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7π/6', false, 'This cancels arcsin and sin directly, but arcsin only returns angles in [−π/2, π/2], and 7π/6 is outside that interval.' from version_ins
union all select gen_random_uuid(), id, 'B', '−π/6', true, 'Correct: sin(7π/6) = −1/2 and the angle in [−π/2, π/2] whose sine is −1/2 is −π/6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/6', false, 'This uses the reference angle with a positive sign; sin(7π/6) = −1/2, so the output must have a negative sine.' from version_ins
union all select gen_random_uuid(), id, 'D', '5π/6', false, 'This is an angle with sin(5π/6) = +1/2; the sine of 7π/6 is −1/2, and 5π/6 is also outside the range [−π/2, π/2].' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.9-a-v1', 'mcq', 'evaluate arcsin, arccos or arctan of the matching trigonometric function at an angle outside the principal range, instea (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the exact value of arccos(cos(−2π/3))?', null, md5('apprecalc-mcq-b2-sv-h-3.9-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2π/3', true, 'Correct: cos(−2π/3) = −1/2 and the angle in [0, π] whose cosine is −1/2 is 2π/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2π/3', false, 'This cancels arccos and cos directly, but arccos only returns angles in [0, π], and −2π/3 is outside that interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/3', false, 'This uses the reference angle, but cos(π/3) = 1/2 while cos(−2π/3) = −1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '4π/3', false, 'This is an angle with the same cosine as −2π/3, but it is outside the range [0, π] of arccos.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.9-a-v2', 'mcq', 'evaluate arcsin, arccos or arctan of the matching trigonometric function at an angle outside the principal range, instea (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the exact value of arctan(tan(5π/6))?', null, md5('apprecalc-mcq-b2-sv-h-3.9-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5π/6', false, 'This cancels arctan and tan directly, but arctan only returns angles in (−π/2, π/2), and 5π/6 is outside that interval.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/6', false, 'This uses the reference angle with a positive sign; tan(5π/6) = −√3/3, so the output must be negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '−π/6', true, 'Correct: tan(5π/6) = −√3/3 and the angle in (−π/2, π/2) with that tangent is −π/6.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5π/6', false, 'This is outside (−π/2, π/2), and tan(−5π/6) = +√3/3, which has the wrong sign.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.9-a-v3', 'mcq', 'evaluate arcsin, arccos or arctan of the matching trigonometric function at an angle outside the principal range, instea (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the exact value of arccos(cos(7π/4))?', null, md5('apprecalc-mcq-b2-sv-h-3.9-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/4', true, 'Correct: cos(7π/4) = √2/2 and the angle in [0, π] whose cosine is √2/2 is π/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '7π/4', false, 'This cancels arccos and cos directly, but arccos only returns angles in [0, π], and 7π/4 is outside that interval.' from version_ins
union all select gen_random_uuid(), id, 'C', '−π/4', false, 'This is the angle in the fourth quadrant with the same cosine, but arccos never returns negative angles; its range is [0, π].' from version_ins
union all select gen_random_uuid(), id, 'D', '3π/4', false, 'This is in [0, π], but cos(3π/4) = −√2/2, while cos(7π/4) = +√2/2.' from version_ins;
-- apprecalc-mcq-b2-h-3.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.9-b', 'mcq', 'evaluate a trigonometric function of an inverse trigonometric value, using the principal range to fix the sign.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the exact value of sin(arccos(−3/5))?', null, md5('apprecalc-mcq-b2-h-3.9-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4/5', false, 'This gives sine a negative sign because the cosine is negative, but arccos returns an angle in [0, π], where sine is never negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/5', false, 'This takes the magnitude of the given ratio, but the value asked for is the sine; the cosine is −3/5 and the sine is found from sin² = 1 − cos².' from version_ins
union all select gen_random_uuid(), id, 'C', '4/5', true, 'Correct: Let θ = arccos(−3/5), in [0, π]; cos θ = −3/5, so sin θ = √(1 − 9/25) = 4/5, positive in the second quadrant.' from version_ins
union all select gen_random_uuid(), id, 'D', '4/3', false, 'This divides the sine 4/5 by the cosine magnitude 3/5, which gives a tangent-like ratio, not the sine.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-h-3.8-b','apprecalc-mcq-b2-sv-h-3.8-b-v1','apprecalc-mcq-b2-sv-h-3.8-b-v2','apprecalc-mcq-b2-sv-h-3.8-b-v3','apprecalc-mcq-b2-h-3.9-a','apprecalc-mcq-b2-sv-h-3.9-a-v1','apprecalc-mcq-b2-sv-h-3.9-a-v2','apprecalc-mcq-b2-sv-h-3.9-a-v3','apprecalc-mcq-b2-h-3.9-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b2-h-3.8-b','apprecalc-mcq-b2-sv-h-3.8-b-v1','apprecalc-mcq-b2-sv-h-3.8-b-v2','apprecalc-mcq-b2-sv-h-3.8-b-v3','apprecalc-mcq-b2-h-3.9-a','apprecalc-mcq-b2-sv-h-3.9-a-v1','apprecalc-mcq-b2-sv-h-3.9-a-v2','apprecalc-mcq-b2-sv-h-3.9-a-v3','apprecalc-mcq-b2-h-3.9-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
