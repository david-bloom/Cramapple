begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apcalcab-mcq-sv-038-v1','apcalcab-mcq-sv-038-v2','apcalcab-mcq-sv-017-v1','apcalcab-mcq-sv-017-v2','apcalcab-mcq-sv-np2-006-v1','apcalcab-mcq-sv-np2-006-v2','apcalcab-mcq-sv-016-v1','apcalcab-mcq-sv-016-v2'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- apcalcab-mcq-sv-038-v1 (seed apcalcab-mcq-038)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-038-v1', 'mcq', 'Curvature of a Ramp Profile', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f''''(x) = 4x + 8, on which interval is the graph of f concave up?', 'No calculator is permitted.', md5('apcalcab-mcq-sv-038-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x > 0', false, 'Uses the sign of x rather than the sign of the second derivative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x > -2', true, 'The graph is concave up where f''''(x) > 0. Solving 4x + 8 > 0 gives x > -2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x > 2', false, 'Makes a sign error when solving, moving +8 across the inequality as +8 instead of -8.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x < -2', false, 'Reverses the inequality: f'''' is negative, not positive, for x < -2.' from version_ins
;
-- apcalcab-mcq-sv-038-v2 (seed apcalcab-mcq-038)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-038-v2', 'mcq', 'Concavity With a Negative Leading Coefficient', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f''''(x) = 18 - 3x, on which interval is the graph of f concave up?', 'No calculator is permitted.', md5('apcalcab-mcq-sv-038-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x < 6', true, 'The graph is concave up where f''''(x) > 0. Solving 18 - 3x > 0 gives -3x > -18, and dividing by -3 reverses the inequality: x < 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x > 6', false, 'Divides by -3 without reversing the inequality, giving x > 6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x > 0', false, 'Uses the sign of x rather than the sign of the second derivative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x < -6', false, 'Makes a sign error when solving, treating 18 - 3x > 0 as 3x + 18 < 0.' from version_ins
;
-- apcalcab-mcq-sv-017-v1 (seed apcalcab-mcq-017)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-017-v1', 'mcq', 'Accumulated Stock Level Falling', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'B(x) = 25 + ∫[0 to x](u^2 - 6u + 8)du. On which interval is B decreasing?', null, md5('apcalcab-mcq-sv-017-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(4, oo)', false, 'B''(x) is positive for x > 4, so B is increasing there.' from version_ins
union all select gen_random_uuid(), id, 'B', '(-oo, 2)', false, 'B''(x) is positive for x < 2, so B is increasing there.' from version_ins
union all select gen_random_uuid(), id, 'C', '(2, 4)', true, 'By the Fundamental Theorem of Calculus, B''(x) = x^2 - 6x + 8 = (x - 2)(x - 4), which is negative between its zeros.' from version_ins
union all select gen_random_uuid(), id, 'D', 'B never decreases', false, 'B''(x) is negative on (2, 4), so B does decrease there.' from version_ins
;
-- apcalcab-mcq-sv-017-v2 (seed apcalcab-mcq-017)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-017-v2', 'mcq', 'Decreasing After a Peak Rate', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Q(t) = 5 + ∫[0 to t](12 - u - u^2)du for t >= 0. On which interval is Q decreasing?', null, md5('apcalcab-mcq-sv-017-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Q never decreases', false, 'Q''(t) is negative for t > 3, so Q does decrease there.' from version_ins
union all select gen_random_uuid(), id, 'B', '(0, 3)', false, 'Q''(t) is positive on (0, 3), so Q is increasing there.' from version_ins
union all select gen_random_uuid(), id, 'C', '(0, oo)', false, 'Q''(t) is positive on (0, 3), so Q is not decreasing on the whole interval.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3, oo)', true, 'By the Fundamental Theorem of Calculus, Q''(t) = 12 - t - t^2 = -(t - 3)(t + 4), which is negative for t > 3 when t >= 0.' from version_ins
;
-- apcalcab-mcq-sv-np2-006-v1 (seed apcalcab-mcq-np2-006)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-np2-006-v1', 'mcq', 'Separable Growth With an Initial Value', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If dy/dx = xy and y(0) = 4, then y(2) = ?', null, md5('apcalcab-mcq-sv-np2-006-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4e^2', true, 'Separating variables gives ln|y| = x^2/2 + C; y(0) = 4 gives C = ln 4, so y = 4e^(x^2/2). At x = 2, y = 4e^2.' from version_ins
union all select gen_random_uuid(), id, 'B', '12', false, 'Treats y as the constant 4 while integrating, giving y = 2x^2 + 4 and y(2) = 12.' from version_ins
union all select gen_random_uuid(), id, 'C', '4e^4', false, 'Integrates x as x^2 instead of x^2/2, giving y = 4e^(x^2) and y(2) = 4e^4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'e^2', false, 'Sets the constant of integration to C = 0 instead of using y(0) = 4, giving y = e^(x^2/2), so y(2) = e^2.' from version_ins
;
-- apcalcab-mcq-sv-np2-006-v2 (seed apcalcab-mcq-np2-006)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-np2-006-v2', 'mcq', 'Decay Model With an Initial Concentration', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A concentration y satisfies dy/dx = -2xy with y(0) = 5. What is y(1)?', null, md5('apcalcab-mcq-sv-np2-006-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/e^2', false, 'Integrates -2x as -2x^2 instead of -x^2, giving y = 5e^(-2x^2) and y(1) = 5/e^2.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'Treats y as the constant 5 while integrating, giving y = 5 - 5x^2 and y(1) = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '5e', false, 'Drops the negative sign, giving y = 5e^(x^2) and y(1) = 5e.' from version_ins
union all select gen_random_uuid(), id, 'D', '5/e', true, 'Separating variables gives ln|y| = -x^2 + C; y(0) = 5 gives C = ln 5, so y = 5e^(-x^2). At x = 1, y = 5/e.' from version_ins
;
-- apcalcab-mcq-sv-016-v1 (seed apcalcab-mcq-016)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-016-v1', 'mcq', 'Average Cost Over a Production Range', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The marginal cost of a product is modeled by c(x) = 3x^2 dollars per unit for 1 <= x <= 3. What is the average value of c on [1, 3]?', null, md5('apcalcab-mcq-sv-016-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '27', false, 'This is c(3), the value at the right endpoint, not the average.' from version_ins
union all select gen_random_uuid(), id, 'B', '26', false, 'Computes the integral (26) but omits the division by the interval length 3 - 1 = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '15', false, 'Averages the endpoint values (3 + 27)/2 instead of integrating.' from version_ins
union all select gen_random_uuid(), id, 'D', '13', true, 'The average value is (1/(3 - 1)) times the integral of 3x^2 from 1 to 3, which is (1/2)(27 - 1) = 13.' from version_ins
;
-- apcalcab-mcq-sv-016-v2 (seed apcalcab-mcq-016)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-016-v2', 'mcq', 'Average Power Over an Interval', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The power drawn by a device is P(t) = t^2 + 2t watts for 0 <= t <= 4. What is the average value of P on [0, 4]?', null, md5('apcalcab-mcq-sv-016-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '28/3', true, 'The average value is (1/4) times the integral of t^2 + 2t from 0 to 4, which is (1/4)(64/3 + 16) = (1/4)(112/3) = 28/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '12', false, 'Averages the endpoint values (0 + 24)/2 instead of integrating.' from version_ins
union all select gen_random_uuid(), id, 'C', '24', false, 'This is P(4), the value at the right endpoint, not the average.' from version_ins
union all select gen_random_uuid(), id, 'D', '112/3', false, 'Computes the integral (112/3) but omits the division by the interval length 4.' from version_ins
;
commit;
