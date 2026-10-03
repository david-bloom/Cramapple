begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-018-v2','apprecalc-mcq-sv-018-v3','apprecalc-mcq-sv-019-v1','apprecalc-mcq-sv-019-v2','apprecalc-mcq-sv-019-v3','apprecalc-mcq-sv-020-v1','apprecalc-mcq-sv-020-v2','apprecalc-mcq-sv-020-v3','apprecalc-mcq-sv-022-v1','apprecalc-mcq-sv-022-v2','apprecalc-mcq-sv-022-v3','apprecalc-mcq-sv-023-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-018-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-018-v2', 'mcq', 'Principal value of arctangent', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Evaluate tan⁻¹(−1), using the principal range of the inverse tangent function.', null, md5('apprecalc-mcq-sv-018-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3π/4', false, 'tan(3π/4) = −1, but 3π/4 is outside the principal range (−π/2, π/2) of inverse tangent.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/4', false, 'tan(π/4) = +1, which is positive. The sign was dropped.' from version_ins
union all select gen_random_uuid(), id, 'C', '7π/4', false, 'tan(7π/4) = −1, but 7π/4 is outside the principal range (−π/2, π/2) of inverse tangent.' from version_ins
union all select gen_random_uuid(), id, 'D', '−π/4', true, 'The principal range of tan⁻¹ is (−π/2, π/2), and tan(−π/4) = −1 there.' from version_ins;
-- apprecalc-mcq-sv-018-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-018-v3', 'mcq', 'Principal value of arccosine, √2/2', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The angle θ satisfies cos θ = −√2/2 and is the output of the inverse cosine function. What is θ?', null, md5('apprecalc-mcq-sv-018-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/4', false, 'cos(π/4) = +√2/2, which is positive. The sign was dropped.' from version_ins
union all select gen_random_uuid(), id, 'B', '3π/4', true, 'The output of cos⁻¹ lies in [0, π], and cos(3π/4) = −√2/2 there.' from version_ins
union all select gen_random_uuid(), id, 'C', '5π/4', false, 'cos(5π/4) = −√2/2, but 5π/4 is outside the range [0, π] of inverse cosine.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3π/4', false, 'cos(−3π/4) = −√2/2, but −3π/4 is outside the range [0, π] of inverse cosine.' from version_ins;
-- apprecalc-mcq-sv-019-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-019-v1', 'mcq', 'Polar to Cartesian, (−4, π/3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A robot''s sensor reports a target location in polar form with a negative radius, namely r = −4 at angle θ = π/3. Converting this reading to rectangular form, which ordered pair (x, y) gives the target''s Cartesian coordinates?', null, md5('apprecalc-mcq-sv-019-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−2, −2√3)', true, 'x = r cos θ = −4·(1/2) = −2 and y = r sin θ = −4·(√3/2) = −2√3.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−2√3, −2)', false, 'Interchanges the components: x = r sin θ = −4·(√3/2) = −2√3 and y = r cos θ = −4·(1/2) = −2.' from version_ins
union all select gen_random_uuid(), id, 'C', '(2, 2√3)', false, 'Ignores the negative radius: 4·(1/2) = 2 and 4·(√3/2) = 2√3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−2, 2√3)', false, 'Applies the negative radius to x but not to y: x = −2, y = +4·(√3/2) = 2√3.' from version_ins;
-- apprecalc-mcq-sv-019-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-019-v2', 'mcq', 'Polar to Cartesian, (6, 5π/6)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On a radar screen, an aircraft appears at distance r = 6 from the origin along the direction θ = 5π/6. Converting from polar to rectangular form, which ordered pair (x, y) gives its position?', null, md5('apprecalc-mcq-sv-019-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−3√3, 3)', true, 'x = 6 cos(5π/6) = 6·(−√3/2) = −3√3 and y = 6 sin(5π/6) = 6·(1/2) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−3√3, −3)', false, 'Gets x right but gives y a negative sign: sin(5π/6) = +1/2, so y = +3, not −3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(3√3, 3)', false, 'Uses the reference angle π/6 for both coordinates without adjusting for Quadrant II: x = 6·(√3/2) = 3√3. But cos(5π/6) is negative.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3, −3√3)', false, 'Interchanges the components: x = 6 sin(5π/6) = 3 and y = 6 cos(5π/6) = −3√3.' from version_ins;
-- apprecalc-mcq-sv-019-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-019-v3', 'mcq', 'Polar to Cartesian, (−6, 7π/6)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A point is plotted using polar coordinates (r, θ) = (−6, 7π/6). What are its Cartesian coordinates?', null, md5('apprecalc-mcq-sv-019-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(3√3, 3)', true, 'x = r cos θ = −6·(−√3/2) = 3√3 and y = r sin θ = −6·(−1/2) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '(3√3, −3)', false, 'Applies the negative radius to x correctly, 3√3, but forgets it for y: y = 6·(−1/2) = −3 instead of −6·(−1/2) = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−3√3, −3)', false, 'Ignores the negative radius: 6·(−√3/2) = −3√3 and 6·(−1/2) = −3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3, 3√3)', false, 'Interchanges the components: x = r sin θ = −6·(−1/2) = 3 and y = r cos θ = −6·(−√3/2) = 3√3.' from version_ins;
-- apprecalc-mcq-sv-020-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-020-v1', 'mcq', 'Polar circle r = 6cos θ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the graph of the polar equation r = 6cos θ drawn in the polar plane. Which of the following correctly describes the shape and location of this graph?', null, md5('apprecalc-mcq-sv-020-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A circle of radius 3 centered at (0, 3)', false, 'A center on the y-axis corresponds to a sine form such as r = 6sin θ. Here x² + y² = 6x gives (x − 3)² + y² = 9, centered at (3, 0).' from version_ins
union all select gen_random_uuid(), id, 'B', 'A circle of radius 6 centered at the origin', false, 'That would be r = 6. For r = 6cos θ, x² + y² = 6x gives (x − 3)² + y² = 9, which is not centered at the origin.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A circle of radius 6 centered at (3, 0)', false, 'Gets the center right but uses the coefficient 6 as the radius. (x − 3)² + y² = 9 gives radius 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A circle of radius 3 centered at (3, 0)', true, 'Multiplying by r gives x² + y² = 6x, which becomes (x − 3)² + y² = 9.' from version_ins;
-- apprecalc-mcq-sv-020-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-020-v2', 'mcq', 'Polar circle r = −10sin θ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the polar curve r = −10sin θ, which description is correct?', null, md5('apprecalc-mcq-sv-020-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A circle of radius 5 centered at (0, 5)', false, 'Ignores the negative sign. x² + y² = −10y gives x² + (y + 5)² = 25, centered at (0, −5), not (0, 5).' from version_ins
union all select gen_random_uuid(), id, 'B', 'A circle of radius 10 centered at (0, −10)', false, 'Uses the coefficient 10 as the radius and for the center distance. x² + (y + 5)² = 25 gives radius 5, center (0, −5).' from version_ins
union all select gen_random_uuid(), id, 'C', 'A circle of radius 5 centered at (0, −5)', true, 'Multiplying by r gives x² + y² = −10y, which becomes x² + (y + 5)² = 25.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A circle of radius 5 centered at (−5, 0)', false, 'A center on the x-axis corresponds to a cosine form. Here x² + (y + 5)² = 25 is centered at (0, −5).' from version_ins;
-- apprecalc-mcq-sv-020-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-020-v3', 'mcq', 'Polar circle r = −2cos θ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A designer sketches the polar equation r = −2cos θ and notices that the radius is negative for many angles. Which description of the resulting curve is correct?', null, md5('apprecalc-mcq-sv-020-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A circle of radius 1 centered at (−1, 0)', true, 'Multiplying by r gives x² + y² = −2x, which becomes (x + 1)² + y² = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A circle of radius 1 centered at (1, 0)', false, 'Ignores the negative sign. x² + y² = −2x gives (x + 1)² + y² = 1, centered at (−1, 0), not (1, 0).' from version_ins
union all select gen_random_uuid(), id, 'C', 'A circle of radius 2 centered at (−1, 0)', false, 'Gets the center right but uses the coefficient 2 as the radius. (x + 1)² + y² = 1 gives radius 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A circle of radius 1 centered at (0, −1)', false, 'A center on the y-axis corresponds to a sine form. Here (x + 1)² + y² = 1 is centered at (−1, 0).' from version_ins;
-- apprecalc-mcq-sv-022-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-022-v1', 'mcq', 'Zeros of a biquadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

The polynomial q(x) = x⁴ − 13x² + 36 has which complete set of real zeros?', null, md5('apprecalc-mcq-sv-022-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '{−9, −4, 4, 9}', false, 'Uses u = 4 and u = 9 (values of x^2) and their negatives as if they were values of x. The values 4 and 9 are solutions for x^2, not x; check: q(4) = 256 - 208 + 36 = 84, not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '{−3, −2, 2, 3}', true, 'Let u = x². Then u² − 13u + 36 = (u − 4)(u − 9) = 0, so x² = 4 or x² = 9, giving x = ±2 and x = ±3.' from version_ins
union all select gen_random_uuid(), id, 'C', '{2, 3}', false, 'Takes only the positive square roots of x² = 4 and x² = 9, omitting −2 and −3.' from version_ins
union all select gen_random_uuid(), id, 'D', '{−3, −2, 2}', false, 'Omits the positive root +3 from x² = 9.' from version_ins;
-- apprecalc-mcq-sv-022-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-022-v2', 'mcq', 'Real zeros when x² = −4 appears', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

While sketching a graph, a student factors the polynomial r(x) = x⁴ + 3x² − 4 and then finds where it crosses the x-axis. Which choice is the complete set of real zeros of r?', null, md5('apprecalc-mcq-sv-022-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '{−2, −1, 1, 2}', false, 'Treats x² = −4 as if it gave x = ±2. But x² = −4 has no real solutions (its solutions are ±2i).' from version_ins
union all select gen_random_uuid(), id, 'B', '{−1, 1}', true, 'Factor as (x² + 4)(x² − 1). The factor x² + 4 has no real zeros, and x² − 1 = 0 gives x = ±1.' from version_ins
union all select gen_random_uuid(), id, 'C', '{−4, 1}', false, 'Solves u² + 3u − 4 = (u + 4)(u − 1) = 0 for u = x² and reports u = −4 and u = 1 as the values of x.' from version_ins
union all select gen_random_uuid(), id, 'D', '{1}', false, 'Omits the root −1 from x² = 1 (and discards x² = −4 correctly).' from version_ins;
-- apprecalc-mcq-sv-022-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-022-v3', 'mcq', 'Cubic zeros by grouping', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

The polynomial p(x) = x³ − 3x² − 4x + 12 has which complete set of real zeros?', null, md5('apprecalc-mcq-sv-022-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '{2, 3}', false, 'Omits −2 from x² − 4 = 0, which has both x = 2 and x = −2.' from version_ins
union all select gen_random_uuid(), id, 'B', '{−2, 2, 3}', true, 'Group: x²(x − 3) − 4(x − 3) = (x − 3)(x² − 4) = (x − 3)(x − 2)(x + 2), so the zeros are 3, 2, and −2.' from version_ins
union all select gen_random_uuid(), id, 'C', '{−3, −2, 2}', false, 'Reads the factor (x − 3) as giving x = −3 instead of x = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '{−2, 2}', false, 'Solves x² − 4 = 0 but ignores the factor (x − 3), which gives the zero x = 3.' from version_ins;
-- apprecalc-mcq-sv-023-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-023-v1', 'mcq', 'End behavior of an even-degree polynomial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Which statement describes the end behavior of h(x)=9−x³+4x⁶?', null, md5('apprecalc-mcq-sv-023-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h(x)→∞ as x→∞ and h(x)→−∞ as x→−∞', false, 'This mixes terms: it reads the odd exponent 3 from x³ but the positive coefficient 4 from the leading term. With degree 6 (even), both ends go the same direction.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h(x)→∞ in both directions', true, 'The leading term is 4x⁶ (degree 6 is even, coefficient 4 is positive), so h(x)→∞ as x→∞ and as x→−∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h(x)→−∞ as x→∞ and h(x)→∞ as x→−∞', false, 'This treats −x³ as the leading term (odd degree 3, coefficient −1), which falls to the right and rises to the left. The highest power is x⁶, not x³.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h(x)→−∞ in both directions', false, 'The sign is taken from the −x³ term instead of the leading term 4x⁶. An even degree with a negative coefficient would give −∞ at both ends, but the actual leading coefficient is +4.' from version_ins;
commit;
