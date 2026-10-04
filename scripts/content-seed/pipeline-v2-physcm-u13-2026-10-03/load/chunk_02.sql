begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-sv-007-v1','apphycm-mcq-sv-007-v2','apphycm-mcq-sv-007-v3','apphycm-mcq-sv-008-v1','apphycm-mcq-sv-008-v2','apphycm-mcq-sv-008-v3','apphycm-mcq-sv-017-v1','apphycm-mcq-sv-017-v2','apphycm-mcq-sv-017-v3','apphycm-mcq-sv-021-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycm-mcq-sv-007-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-007-v1', 'mcq', 'Energy delivered by a winch', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A winch delivers power P(t) = 6t, with P in watts and t in seconds. How much energy does it deliver from t = 0 to t = 4.0 s?', null, md5('apphycm-mcq-sv-007-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6.0 J', false, 'The number 6 is the derivative dP/dt. Differentiating instead of integrating does not give the energy.' from version_ins
union all select gen_random_uuid(), id, 'B', '24 J', false, 'This is the instantaneous power at the end, P(4.0) = 24 W. Power is a rate, so its value at one instant is not the energy delivered over the interval.' from version_ins
union all select gen_random_uuid(), id, 'C', '96 J', false, 'P(4.0) × 4.0 s = 96 J treats the power as constant at its final value. The power grows from zero, which introduces a factor 1/2, giving 48 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '48 J', true, 'Energy is the time integral of power: ∫₀⁴ 6t dt = 3t² evaluated from 0 to 4.0 s = 48 J.' from version_ins;
-- apphycm-mcq-sv-007-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-007-v2', 'mcq', 'Energy from a motor over a later interval', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A motor''s power output is P(t) = 3t² + 4, with P in watts and t in seconds. How much energy does it deliver from t = 1.0 s to t = 3.0 s?', null, md5('apphycm-mcq-sv-007-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '26 J', false, 'Integrating only the 3t² term gives t³ and 27 − 1 = 26 J. The constant 4 W also contributes 4 × 2.0 s = 8 J, giving 34 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '34 J', true, 'E = ∫₁³ (3t² + 4) dt = [t³ + 4t] from 1.0 to 3.0 s = (27 + 12) − (1 + 4) = 34 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '38 J', false, 'The average of the endpoint powers, (7 + 31)/2 = 19 W, times 2.0 s gives 38 J. The power is not linear in time, so the endpoint average is not the average power.' from version_ins
union all select gen_random_uuid(), id, 'D', '39 J', false, 'This is the energy from t = 0 to t = 3.0 s. The integral must begin at t = 1.0 s, so the value 1 + 4 = 5 J at the lower limit is subtracted.' from version_ins;
-- apphycm-mcq-sv-007-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-007-v3', 'mcq', 'Energy from a pulse of power', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A motor''s power output is P(t) = P₀(t/T)(1 − t/T) for 0 ≤ t ≤ T, where P₀ and T are positive constants. How much energy does it deliver during this interval?', null, md5('apphycm-mcq-sv-007-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P₀T/2', false, 'This integrates only the P₀t/T term, which gives P₀T/2. The −P₀t²/T² term subtracts P₀T/3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P₀T/6', true, 'E = ∫₀ᵀ P₀(t/T − t²/T²) dt = P₀(T/2 − T/3) = P₀T/6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P₀T/4', false, 'The maximum power is P₀/4, reached at t = T/2. Multiplying the peak power by T treats the power as constant at its maximum, which overestimates the energy.' from version_ins
union all select gen_random_uuid(), id, 'D', '5P₀T/6', false, 'Adding P₀T/2 and P₀T/3 uses the wrong sign on the second term. The factor (1 − t/T) subtracts, so the result is P₀T/2 − P₀T/3 = P₀T/6.' from version_ins;
-- apphycm-mcq-sv-008-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-008-v1', 'mcq', 'Marble in a bowl', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A marble rests at the bottom of a smooth bowl. Treat its gravitational potential energy as a function of horizontal position. The equilibrium at the bottom is stable because the potential energy there has', null, md5('apphycm-mcq-sv-008-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a local maximum, so a displaced marble is pushed back toward the bottom', false, 'The restoring behavior is correct, but it comes from a minimum. Near a maximum of U, a displacement lowers U and the force points away from equilibrium.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a local minimum, so a displaced marble is pushed back toward the bottom', true, 'At a local minimum of U, any small displacement raises the potential energy, and the force F = −dU/dx points back toward the equilibrium position. That restoring force is what makes the equilibrium stable.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a value of zero, so no force acts on a displaced marble', false, 'The value of U depends on where the zero of potential energy is chosen. Equilibrium is set by the slope of U being zero, and stability by the sign of the curvature, not by the value of U.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a local maximum, so a displaced marble speeds up away from the bottom', false, 'A local maximum describes unstable equilibrium. The bottom of the bowl is a minimum: a displaced marble loses kinetic energy as it climbs and is pushed back.' from version_ins;
-- apphycm-mcq-sv-008-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-008-v2', 'mcq', 'Stable point of a cubic potential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A marble rolls on a track where its potential energy is U(x) = x³ − 3x² in SI units. Which of these positions is a stable equilibrium?', null, md5('apphycm-mcq-sv-008-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = +1.0 m', false, 'Here d²U/dx² = 0, but the slope dU/dx = −3 J/m is not zero, so a force acts and the marble is not in equilibrium. The curvature alone does not locate equilibria.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = +3.0 m, where U = 0', false, 'At x = 3.0 m the slope dU/dx = 9 J/m is not zero, so a force acts and the marble is not in equilibrium there. The value of U is irrelevant.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 0', false, 'The slope is zero here, but d²U/dx² = 6x − 6 = −6 J/m² is negative, so this is a local maximum and the equilibrium is unstable.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = +2.0 m', true, 'dU/dx = 3x² − 6x = 3x(x − 2) = 0 gives x = 0 and x = +2.0 m. The curvature d²U/dx² = 6x − 6 is +6 J/m² at x = +2.0 m, a local minimum, so that equilibrium is stable.' from version_ins;
-- apphycm-mcq-sv-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-008-v3', 'mcq', 'Equilibria from a force function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moving along the x-axis feels a net force F(x) = 3x − x³ (F in newtons, x in meters), which comes from a conservative potential energy. Which statement about its equilibrium positions is correct?', null, md5('apphycm-mcq-sv-008-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 0 is stable; x = ±√3 m are unstable', false, 'This reverses the result. At x = 0, a small positive x gives a positive force that pushes the particle farther away, so it is unstable; at ±√3 the force opposes displacement.' from version_ins
union all select gen_random_uuid(), id, 'B', 'All three positions are stable, because the net force is zero at each', false, 'A zero net force only makes a point an equilibrium. Stability requires that the force points back toward the point for small displacements, and that fails at x = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 0 is unstable; x = ±√3 m are stable', true, 'F = 0 at x = 0 and x = ±√3. Since F = −dU/dx, stability requires d²U/dx² = −dF/dx > 0. Here dF/dx = 3 − 3x², which is +3 at x = 0 (maximum of U, unstable) and −6 at x = ±√3 (minima of U, stable).' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 0 is the only equilibrium position, and it is unstable', false, 'F = x(3 − x²) also vanishes at x = ±√3, so there are three equilibrium positions, not one.' from version_ins;
-- apphycm-mcq-sv-017-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-017-v1', 'mcq', 'Velocity from a cubic position function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart moves along a straight track with position x(t) = 2t³ − 5t, where x is in meters and t is in seconds. What is the cart''s velocity at t = 2.0 s?', null, md5('apphycm-mcq-sv-017-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '19 m/s', true, 'Velocity is the time derivative of position: v = dx/dt = 6t² − 5. At t = 2.0 s this gives 6(4) − 5 = 19 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '6 m/s', false, 'This is the numerical value of the position, x(2.0) = 16 − 10 = 6 m. Velocity requires differentiating x(t) before substituting the time.' from version_ins
union all select gen_random_uuid(), id, 'C', '14 m/s', false, 'The cubic term is differentiated correctly to 6t², but the linear term −5t must also be differentiated to give −5. Leaving −5t in place gives 24 − 10 = 14, which is not the velocity.' from version_ins
union all select gen_random_uuid(), id, 'D', '3 m/s', false, 'Differentiating 2t³ gives 6t², not 2t². Dropping the exponent multiplier produces 2t² − 5, which equals 3 at t = 2.0 s.' from version_ins;
-- apphycm-mcq-sv-017-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-017-v2', 'mcq', 'Velocity from a quartic with a quadratic term', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a line with position x(t) = Bt⁴ − Ct², where B and C are positive constants. Which expression gives its velocity v(t)?', null, md5('apphycm-mcq-sv-017-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4Bt³ − 2Ct', true, 'Velocity is v = dx/dt. Applying the power rule to each term gives 4Bt³ for the quartic term and −2Ct for the quadratic term.' from version_ins
union all select gen_random_uuid(), id, 'B', '4Bt³ − Ct', false, 'The quartic term is differentiated correctly, but the quadratic term must give −2Ct. The multiplier 2 from the exponent was left out.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Bt³ − Ct', false, 'This lowers each exponent by one but omits the multipliers 4 and 2 that the power rule brings down.' from version_ins
union all select gen_random_uuid(), id, 'D', '12Bt² − 2C', false, 'This is the second derivative of x(t), which is the acceleration, not the velocity.' from version_ins;
-- apphycm-mcq-sv-017-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-017-v3', 'mcq', 'When a particle is momentarily at rest', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a line with position x(t) = 3t² − t³, where x is in meters and t is in seconds. At what time after t = 0 is the particle momentarily at rest?', null, md5('apphycm-mcq-sv-017-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 1 s', false, 'At t = 1 s the acceleration a = 6 − 6t is zero, which is where the velocity is largest (v = 3 m/s), not zero.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 6 s', false, 'This comes from differentiating t³ as t² instead of 3t². The resulting v = 6t − t² would vanish at 6 s, but the actual velocity at 6 s is 36 − 108 = −72 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 3 s', false, 'At t = 3 s the position x = 3(9) − 27 is zero, but the particle is moving there with v = 6(3) − 3(9) = −9 m/s. Being at the origin does not mean being at rest.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 2 s', true, 'Velocity is v = dx/dt = 6t − 3t² = 3t(2 − t). It is zero at t = 0 and at t = 2 s, so the later instant of rest is t = 2 s.' from version_ins;
-- apphycm-mcq-sv-021-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-021-v1', 'mcq', 'Acceleration of a cubic position', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sled moves along a straight line with position x(t) = 2t³, where x is in meters and t is in seconds. What is its acceleration at t = 3.0 s?', null, md5('apphycm-mcq-sv-021-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18 m/s²', false, 'The first derivative 6t² is correct, but its derivative is 12t, not 6t. Dropping the multiplier 2 gives 6(3) = 18, which is half the true value.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 m/s²', false, 'The expression a = 12t is correct, but 12 is only its coefficient. The time t = 3.0 s must be substituted to get 36 m/s².' from version_ins
union all select gen_random_uuid(), id, 'C', '36 m/s²', true, 'Acceleration is the second time derivative of position: v = dx/dt = 6t² and a = dv/dt = 12t. At t = 3.0 s, a = 36 m/s².' from version_ins
union all select gen_random_uuid(), id, 'D', '54 m/s²', false, 'This is the velocity 6t² evaluated at 3.0 s (54 m/s). Acceleration requires a second differentiation.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-sv-007-v1','apphycm-mcq-sv-007-v2','apphycm-mcq-sv-007-v3','apphycm-mcq-sv-008-v1','apphycm-mcq-sv-008-v2','apphycm-mcq-sv-008-v3','apphycm-mcq-sv-017-v1','apphycm-mcq-sv-017-v2','apphycm-mcq-sv-017-v3','apphycm-mcq-sv-021-v1']) and status='draft')<>10 then raise exception 'chunk 2: expected 10 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.content_key = any (array['apphycm-mcq-sv-007-v1','apphycm-mcq-sv-007-v2','apphycm-mcq-sv-007-v3','apphycm-mcq-sv-008-v1','apphycm-mcq-sv-008-v2','apphycm-mcq-sv-008-v3','apphycm-mcq-sv-017-v1','apphycm-mcq-sv-017-v2','apphycm-mcq-sv-017-v3','apphycm-mcq-sv-021-v1']))<>40 then raise exception 'chunk 2: choice rows'; end if;
end $$;
commit;
