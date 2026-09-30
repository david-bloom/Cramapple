begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apcalcab-mcq-sv-001-v1','apcalcab-mcq-sv-001-v2','apcalcab-mcq-sv-026-v1','apcalcab-mcq-sv-026-v2','apcalcab-mcq-sv-029-v1','apcalcab-mcq-sv-029-v2','apcalcab-mcq-sv-031-v1','apcalcab-mcq-sv-031-v2'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- apcalcab-mcq-sv-001-v1 (seed apcalcab-mcq-001)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-001-v1', 'mcq', 'Calibration Ratio Near a Reference Setting', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor''s calibration ratio at setting x is R(x) = (x^2 - 25)/(x - 5) for x != 5. What is the limit of R(x) as x approaches 5?', null, md5('apcalcab-mcq-sv-001-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10', true, 'Since x^2 - 25 = (x - 5)(x + 5), R(x) = x + 5 for x != 5, so the limit as x approaches 5 is 10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit does not exist', false, 'The factor x - 5 cancels, leaving a hole at x = 5 that does not prevent the two-sided limit from existing.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'Substituting x = 5 into the numerator alone gives 0, but the denominator is also 0, so the quotient is not evaluated this way.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, 'This is the value x approaches, not the limit of the simplified expression x + 5.' from version_ins
;
-- apcalcab-mcq-sv-001-v2 (seed apcalcab-mcq-001)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-001-v2', 'mcq', 'Rate Ratio Near a Negative Value', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pump''s efficiency ratio is E(x) = (x^2 - 4)/(x + 2) for x != -2. What is the limit of E(x) as x approaches -2?', null, md5('apcalcab-mcq-sv-001-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'Substituting x = -2 into the numerator alone gives 0, but the denominator is also 0, so this does not evaluate the quotient.' from version_ins
union all select gen_random_uuid(), id, 'B', '-4', true, 'Since x^2 - 4 = (x - 2)(x + 2), E(x) = x - 2 for x != -2, and its limit as x approaches -2 is -4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'The factor x + 2 cancels, so the hole at x = -2 does not prevent the two-sided limit from existing.' from version_ins
union all select gen_random_uuid(), id, 'D', '-2', false, 'This is the value x approaches, not the limit of the simplified expression x - 2.' from version_ins
;
-- apcalcab-mcq-sv-026-v1 (seed apcalcab-mcq-026)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-026-v1', 'mcq', 'Charge Rate of a Battery Model', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The charge in a battery is modeled by Q(t) = t^3 e^t. What is Q''(1)?', 'No calculator is permitted.', md5('apcalcab-mcq-sv-026-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3+e', false, 'Adds the two derivatives 3t^2 and e^t instead of applying the product rule: 3(1)^2 + e^1 = 3 + e.' from version_ins
union all select gen_random_uuid(), id, 'B', '4e', true, 'The product rule gives Q''(t) = 3t^2 e^t + t^3 e^t. At t = 1 this is 3e + e = 4e.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e', false, 'Differentiates only the exponential factor: t^3 e^t evaluated at t = 1 is e, dropping the 3t^2 e^t term.' from version_ins
union all select gen_random_uuid(), id, 'D', '3e', false, 'Differentiates only the polynomial factor: 3t^2 e^t evaluated at t = 1 is 3e, dropping the t^3 e^t term.' from version_ins
;
-- apcalcab-mcq-sv-026-v2 (seed apcalcab-mcq-026)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-026-v2', 'mcq', 'Growth Model With a Logarithm Factor', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population index is modeled by g(x) = x^3 ln x for x > 0. What is g''(e)?', 'No calculator is permitted.', md5('apcalcab-mcq-sv-026-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'e^2', false, 'Differentiates only the logarithm: x^3 (1/x) evaluated at x = e is e^2, dropping the 3x^2 ln x term.' from version_ins
union all select gen_random_uuid(), id, 'B', '3e^2', false, 'Differentiates only the polynomial: 3x^2 ln x evaluated at x = e is 3e^2, dropping the x^2 term.' from version_ins
union all select gen_random_uuid(), id, 'C', '3e^2+1/e', false, 'Adds the two derivatives 3x^2 and 1/x instead of applying the product rule: 3e^2 + 1/e.' from version_ins
union all select gen_random_uuid(), id, 'D', '4e^2', true, 'The product rule gives g''(x) = 3x^2 ln x + x^3 (1/x) = 3x^2 ln x + x^2. At x = e this is 3e^2 + e^2 = 4e^2.' from version_ins
;
-- apcalcab-mcq-sv-029-v1 (seed apcalcab-mcq-029)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-029-v1', 'mcq', 'Voltage Signal With a Squared Inner Term', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor voltage is modeled by V(x) = cos(3x^2). What is V''(x)?', 'No calculator is permitted.', md5('apcalcab-mcq-sv-029-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-sin(6x)', false, 'Moves the inner derivative inside the sine, replacing 3x^2 by 6x instead of multiplying by it.' from version_ins
union all select gen_random_uuid(), id, 'B', '-6x sin(3x^2)', true, 'By the chain rule, V''(x) = -sin(3x^2) times the derivative of the inner function 3x^2, which is 6x.' from version_ins
union all select gen_random_uuid(), id, 'C', '-sin(3x^2)', false, 'Omits the inner derivative 6x.' from version_ins
union all select gen_random_uuid(), id, 'D', '6x sin(3x^2)', false, 'Uses the derivative of cosine as +sin instead of -sin, losing the negative sign.' from version_ins
;
-- apcalcab-mcq-sv-029-v2 (seed apcalcab-mcq-029)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-029-v2', 'mcq', 'Exponential Response to a Sine Input', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A response function is R(x) = e^(sin x). What is R''(x)?', 'No calculator is permitted.', md5('apcalcab-mcq-sv-029-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'e^(sin(x))', false, 'Omits the inner derivative cos x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'sin(x) e^(sin(x))', false, 'Uses sin x as the derivative of the inner function sin x, instead of cos x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e^(cos(x))', false, 'Moves the inner derivative inside the exponent, replacing sin x by cos x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'cos(x) e^(sin(x))', true, 'By the chain rule, R''(x) = e^(sin x) times the derivative of the inner function sin x, which is cos x.' from version_ins
;
-- apcalcab-mcq-sv-031-v1 (seed apcalcab-mcq-031)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-031-v1', 'mcq', 'Cart Velocity on a Track', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart has position s(t) = t^3 - 5.2t^2 + 3.4t + 8 meters. What is its velocity at t = 2.6 seconds, to the nearest hundredth?', 'A graphing calculator is permitted.', md5('apcalcab-mcq-sv-031-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-0.74 m/s', false, 'Evaluates the position s(2.6) rather than the velocity.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.60 m/s', false, 'Reports the time as though it were a velocity.' from version_ins
union all select gen_random_uuid(), id, 'C', '10.16 m/s', false, 'Evaluates 3t^2 - 5.2t + 3.4, forgetting to double the coefficient of the quadratic term when differentiating t^2.' from version_ins
union all select gen_random_uuid(), id, 'D', '-3.36 m/s', true, 'The velocity is s''(t) = 3t^2 - 10.4t + 3.4. At t = 2.6 this is 20.28 - 27.04 + 3.4 = -3.36 m/s.' from version_ins
;
-- apcalcab-mcq-sv-031-v2 (seed apcalcab-mcq-031)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-sv-031-v2', 'mcq', 'Speed of a Falling Marker', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A marker''s height above the ground is s(t) = 2t^3 - 7.3t^2 + 1.9t + 12 meters. What is its velocity at t = 1.8 seconds, to the nearest hundredth?', 'A graphing calculator is permitted.', md5('apcalcab-mcq-sv-031-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-4.94 m/s', true, 'The velocity is s''(t) = 6t^2 - 14.6t + 1.9. At t = 1.8 this is 19.44 - 26.28 + 1.9 = -4.94 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.80 m/s', false, 'Reports the time as though it were a velocity.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.20 m/s', false, 'Evaluates 6t^2 - 7.3t + 1.9, forgetting to double the coefficient of the quadratic term when differentiating t^2.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.43 m/s', false, 'Evaluates the position s(1.8) rather than the velocity.' from version_ins
;
commit;
