begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-sv-021-v2','apphycm-mcq-sv-021-v3','apphycm-mcq-sv-018-v1','apphycm-mcq-sv-018-v2','apphycm-mcq-sv-018-v3','apphycm-mcq-sv-024-v1','apphycm-mcq-sv-024-v2','apphycm-mcq-sv-024-v3','apphycm-mcq-sv-025-v1','apphycm-mcq-sv-025-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycm-mcq-sv-021-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-021-v2', 'mcq', 'Acceleration of a fifth-power position with a linear term', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle''s position along a line is x(t) = Dt⁵ − Et, where D and E are positive constants. Which expression gives its acceleration a(t)?', null, md5('apphycm-mcq-sv-021-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20Dt³', true, 'Differentiating once gives v = 5Dt⁴ − E. Differentiating again gives a = 20Dt³, because the constant −E has zero derivative.' from version_ins
union all select gen_random_uuid(), id, 'B', '5Dt⁴ − E', false, 'This is the velocity, the first derivative of x(t). Acceleration needs a second derivative.' from version_ins
union all select gen_random_uuid(), id, 'C', '5Dt³', false, 'Differentiating 5Dt⁴ without bringing down the exponent 4 gives 5Dt³. The second differentiation must multiply by 4 to give 20Dt³.' from version_ins
union all select gen_random_uuid(), id, 'D', '20Dt³ − E', false, 'The term −E belongs to the velocity. It is a constant, so it disappears in the second derivative and does not appear in the acceleration.' from version_ins;
-- apphycm-mcq-sv-021-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-021-v3', 'mcq', 'Acceleration of an exponentially decaying position', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A damped slider has position x(t) = A e^(−bt), where A and b are positive constants. Which expression gives its acceleration a(t)?', null, md5('apphycm-mcq-sv-021-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A b² e^(−bt)', true, 'The velocity is v = dx/dt = −A b e^(−bt). Differentiating again brings out another factor of −b, so a = (−b)(−A b e^(−bt)) = A b² e^(−bt).' from version_ins
union all select gen_random_uuid(), id, 'B', '−A b² e^(−bt)', false, 'The chain rule brings out a factor of −b at each differentiation, so the two negative signs multiply to a positive result. Keeping a single minus sign gives the wrong direction for the acceleration.' from version_ins
union all select gen_random_uuid(), id, 'C', '−A b e^(−bt)', false, 'This is the velocity, the first derivative of x(t). The acceleration is the derivative of this expression.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A e^(−bt)/b²', false, 'This is what integrating twice would give. Acceleration comes from differentiating twice, which multiplies by b² instead of dividing.' from version_ins;
-- apphycm-mcq-sv-018-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-018-v1', 'mcq', 'Work by a force that grows as x squared', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A force F(x) = 4x² acts along the direction of motion, with F in newtons and x in meters. How much work does it do on an object that moves from x = 0 to x = 3.0 m?', null, md5('apphycm-mcq-sv-018-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '36 J', true, 'Work is W = ∫F dx = ∫₀³ 4x² dx = (4/3)(3³) = 36 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '24 J', false, 'This differentiates the force instead of integrating it: dF/dx = 8x, which equals 24 at x = 3.0 m. Work is the integral of the force over distance.' from version_ins
union all select gen_random_uuid(), id, 'C', '54 J', false, 'Integrating x² gives x³/3, not x³/2. Dividing by the old exponent instead of the new one gives 4(27)/2 = 54.' from version_ins
union all select gen_random_uuid(), id, 'D', '108 J', false, 'This multiplies the final force F(3) = 36 N by the distance 3 m, as if the force were constant. The force grows from zero, so the work is smaller.' from version_ins;
-- apphycm-mcq-sv-018-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-018-v2', 'mcq', 'Work by a force that falls to zero at the end', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A force along +x is F(x) = F₀(1 − x²/L²) for 0 ≤ x ≤ L, where F₀ and L are positive constants. Which expression gives the work done by this force as an object moves from x = 0 to x = L?', null, md5('apphycm-mcq-sv-018-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'F₀L/3', false, 'This is the size of the integral of the x²/L² term alone. That term is subtracted from F₀L, so the result is F₀L − F₀L/3, not F₀L/3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'F₀L', false, 'This uses the initial force F₀ as if it stayed constant over the distance L. The force actually drops to zero at x = L, so the work is smaller.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Zero', false, 'The force is zero at x = L, but work depends on the force at every point along the path. The force is positive for 0 ≤ x < L, so the work is positive.' from version_ins
union all select gen_random_uuid(), id, 'D', '2F₀L/3', true, 'W = ∫₀ᴸ F₀(1 − x²/L²) dx = F₀[x − x³/(3L²)] from 0 to L = F₀(L − L/3) = 2F₀L/3.' from version_ins;
-- apphycm-mcq-sv-018-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-018-v3', 'mcq', 'Work by an inverse-cube force over an infinite path', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A force F(x) = F₀L³/(x + L)³ acts along the direction of motion, where F₀ and L are positive constants. Which expression gives the work done as the object moves from x = 0 to x → ∞?', null, md5('apphycm-mcq-sv-018-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'F₀L/8', false, 'This takes the magnitude of the antiderivative at x = L, F₀L³/(2(2L)²) = F₀L/8, as the lower-limit term. The path starts at x = 0, where that term is F₀L³/(2L²) = F₀L/2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'F₀L/2', true, 'W = ∫₀^∞ F₀L³(x + L)⁻³ dx = F₀L³[−1/(2(x + L)²)] from 0 to ∞ = 0 + F₀L³/(2L²) = F₀L/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'F₀L', false, 'The antiderivative of (x + L)⁻³ is −1/(2(x + L)²). Leaving out the factor of 1/2 from the power rule doubles the result.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Infinite', false, 'An infinite upper limit does not guarantee an infinite integral. The force falls off as 1/x³, which is fast enough for the area to converge to a finite value.' from version_ins;
-- apphycm-mcq-sv-024-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-024-v1', 'mcq', 'Equilibrium at a potential-energy maximum', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle has potential energy U(x) = −(1/2)cx², where c is a positive constant. The particle is placed at rest at x = 0. The equilibrium there is', null, md5('apphycm-mcq-sv-024-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'unstable, because U has a local maximum there', true, 'The force is F = −dU/dx = cx, which is zero at x = 0, so this is an equilibrium. U has a local maximum at x = 0, so a small displacement produces a force pointing away from the origin.' from version_ins
union all select gen_random_uuid(), id, 'B', 'stable, because U has a local maximum there', false, 'A local maximum of U is the signature of unstable equilibrium. A stable equilibrium needs a local minimum, where the force pushes back toward the point.' from version_ins
union all select gen_random_uuid(), id, 'C', 'stable, because the net force is zero there', false, 'Zero net force defines an equilibrium point but does not make it stable. Here F = cx points away from x = 0 on both sides, so any small displacement grows.' from version_ins
union all select gen_random_uuid(), id, 'D', 'unstable, because the net force there is nonzero', false, 'The net force F = cx is exactly zero at x = 0, which is why it is an equilibrium point. The instability comes from the shape of U, not from a nonzero force.' from version_ins;
-- apphycm-mcq-sv-024-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-024-v2', 'mcq', 'Locating a stable equilibrium from U(x)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with potential energy U(x) = x³ − 12x, where U is in joules and x is in meters. At which position is there a stable equilibrium?', null, md5('apphycm-mcq-sv-024-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = −2.0 m', false, 'The force is also zero at x = −2.0 m, but U″ = 6x is negative there, so U has a local maximum and the equilibrium is unstable.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = +2.0 m', true, 'The force is F = −dU/dx = 12 − 3x², which is zero at x = ±2.0 m. The second derivative U″ = 6x is positive at x = +2.0 m, so U has a local minimum there and the equilibrium is stable.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 0', false, 'The force at x = 0 is F = 12 N, not zero, so x = 0 is not an equilibrium. It is the point where U″ = 0, an inflection point of U.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 3.46 m', false, 'U is zero at x = √12 ≈ 3.46 m, but equilibrium requires zero force, not zero potential energy. The force there is 12 − 36 = −24 N.' from version_ins;
-- apphycm-mcq-sv-024-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-024-v3', 'mcq', 'Stability of an equilibrium in an inverse-power potential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the positive x-axis with potential energy U(x) = A/x² − B/x, where A and B are positive constants. Which statement correctly gives its equilibrium position and stability?', null, md5('apphycm-mcq-sv-024-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = A/B, stable because U has a local minimum there', false, 'This results from differentiating A/x² as −A/x³ instead of −2A/x³. The force is not zero at x = A/B, so U has no extremum there.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 2A/B, stable because U has a local minimum there', true, 'The force is F = −dU/dx = 2A/x³ − B/x², which is zero at x = 2A/B. At that point U″ = 6A/x⁴ − 2B/x³ = B/x³ > 0, so U has a local minimum and the equilibrium is stable.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = B/(2A), stable because U has a local minimum there', false, 'This inverts the ratio found by setting F = 0. The force vanishes at x = 2A/B, so no extremum of U exists at x = B/(2A).' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 2A/B, unstable because U is negative there', false, 'The equilibrium position is correct, and U there equals −B²/(4A), which is negative. The sign of U does not decide stability; the positive curvature U″ = B/x³ does, and it makes this a minimum.' from version_ins;
-- apphycm-mcq-sv-025-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-025-v1', 'mcq', 'Time constant for a sliding block with drag', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg block slides on a surface where the only horizontal force is a resistive force F = −bv with b = 0.50 kg/s. How long does it take for the block''s speed to fall to 1/e of its initial value?', null, md5('apphycm-mcq-sv-025-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.0 s', false, 'This multiplies m and b. The time constant is their ratio m/b, which also has the correct unit of seconds.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.8 s', false, 'This is the half-life, (m/b) ln 2. It is the time for the speed to drop to one half of its initial value, not to 1/e.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.0 s', true, 'Newton''s second law gives m dv/dt = −bv, so v = v₀e^(−bt/m). The speed is v₀/e when bt/m = 1, so t = m/b = 2.0/0.50 = 4.0 s.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.25 s', false, 'This is b/m, the decay rate, which has units of 1/s. The time for the speed to fall to 1/e is its inverse, m/b.' from version_ins;
-- apphycm-mcq-sv-025-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-025-v2', 'mcq', 'Speed of a decelerating cart at a later time', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 3.0 kg cart moves with initial speed 12 m/s. The only horizontal force on it is a resistive force F = −bv, with b = 1.5 kg/s. What is the cart''s speed 4.0 s later?', null, md5('apphycm-mcq-sv-025-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.0 m/s', false, 'This treats the 2.0 s time constant as a half-life, so the speed would halve every 2.0 s. The speed actually falls by a factor of e per time constant: 12e⁻² ≈ 1.6 m/s, not 12/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 m/s, the cart has stopped', false, 'This applies a constant-deceleration formula using the initial deceleration of 6 m/s², which would stop the cart at 2.0 s. The resistive force shrinks as the speed falls, so the cart is still moving at 4.0 s.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.6 m/s', true, 'From m dv/dt = −bv, v = v₀e^(−bt/m). Here bt/m = (1.5)(4.0)/3.0 = 2.0, so v = 12e⁻² ≈ 1.6 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.030 m/s', false, 'This uses e^(−bt) without dividing by the mass, giving 12e⁻⁶. The decay exponent is bt/m, so the mass must appear.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-sv-021-v2','apphycm-mcq-sv-021-v3','apphycm-mcq-sv-018-v1','apphycm-mcq-sv-018-v2','apphycm-mcq-sv-018-v3','apphycm-mcq-sv-024-v1','apphycm-mcq-sv-024-v2','apphycm-mcq-sv-024-v3','apphycm-mcq-sv-025-v1','apphycm-mcq-sv-025-v2']) and status='draft')<>10 then raise exception 'chunk 3: expected 10 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.content_key = any (array['apphycm-mcq-sv-021-v2','apphycm-mcq-sv-021-v3','apphycm-mcq-sv-018-v1','apphycm-mcq-sv-018-v2','apphycm-mcq-sv-018-v3','apphycm-mcq-sv-024-v1','apphycm-mcq-sv-024-v2','apphycm-mcq-sv-024-v3','apphycm-mcq-sv-025-v1','apphycm-mcq-sv-025-v2']))<>40 then raise exception 'chunk 3: choice rows'; end if;
end $$;
commit;
