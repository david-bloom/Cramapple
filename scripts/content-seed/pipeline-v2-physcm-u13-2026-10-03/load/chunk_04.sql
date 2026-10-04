begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-sv-025-v3','apphycm-mcq-sv-026-v1','apphycm-mcq-sv-026-v2','apphycm-mcq-sv-026-v3','apphycm-mcq-sv-027-v1','apphycm-mcq-sv-027-v2','apphycm-mcq-sv-027-v3','apphycm-mcq-sv-028-v1','apphycm-mcq-sv-028-v2','apphycm-mcq-sv-028-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycm-mcq-sv-025-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-025-v3', 'mcq', 'Total distance traveled with linear drag', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 5.0 kg sled moves with initial speed 8.0 m/s. The only horizontal force on it is a resistive force F = −bv, with b = 2.0 kg/s. What is the total distance the sled travels from t = 0 as t → ∞?', null, md5('apphycm-mcq-sv-025-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.2 m', false, 'This is v₀b/m = (8.0)(2.0)/5.0 = 3.2, which has units of acceleration (m/s²), not length, because the ratio of the parameters is inverted. The total distance is v₀m/b = 20 m.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Infinite', false, 'The speed approaches zero but never reaches it, yet the distance stays finite. The speed decays exponentially, so the area under the speed-time curve converges to 20 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '12.6 m', false, 'This is the distance traveled during the first time constant only, v₀(m/b)(1 − 1/e) ≈ 12.6 m. The sled keeps moving afterward, and the total includes all later time.' from version_ins
union all select gen_random_uuid(), id, 'D', '20 m', true, 'The speed is v = v₀e^(−bt/m). Integrating, the distance is ∫₀^∞ v₀e^(−bt/m) dt = v₀m/b = (8.0)(5.0)/2.0 = 20 m.' from version_ins;
-- apphycm-mcq-sv-026-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-026-v1', 'mcq', 'Car on a circular track', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A car travels at a constant speed of 20 m/s around a flat circular track of radius 50 m. What is the car''s acceleration?', null, md5('apphycm-mcq-sv-026-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 m/s², because the speed is constant', false, 'Constant speed does not mean zero acceleration. The velocity vector keeps changing direction, which requires the inward acceleration v²/r = 8.0 m/s².' from version_ins
union all select gen_random_uuid(), id, 'B', '8.0 m/s² directed away from the center of the track', false, 'The magnitude v²/r = 8.0 m/s² is right, but the acceleration of a body in uniform circular motion points inward, toward the center, not outward.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.40 m/s² directed toward the center of the track', false, 'This divides the speed by the radius (v/r) instead of using v²/r. The correct magnitude is (20)²/50 = 8.0 m/s².' from version_ins
union all select gen_random_uuid(), id, 'D', '8.0 m/s² directed toward the center of the track', true, 'The velocity direction changes continuously, so there is an acceleration of magnitude v²/r = (20 m/s)²/(50 m) = 8.0 m/s², directed toward the center.' from version_ins;
-- apphycm-mcq-sv-026-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-026-v2', 'mcq', 'Ball on a string, speed doubled', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball on a light string moves at constant speed in a horizontal circle of fixed radius on a frictionless table, and the string tension is the only horizontal force on the ball. The ball is then set moving at twice the original speed in a circle of the same radius. How does the string tension compare with its original value?', null, md5('apphycm-mcq-sv-026-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is 2 times as large', false, 'This treats the required inward force as proportional to v. Because T = mv²/r, it is proportional to v², so doubling the speed gives a factor of 4, not 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is unchanged, because the speed is still constant', false, 'Constant speed does not mean no net force. The ball always accelerates inward at v²/r, and a larger v requires a larger inward force, so the tension increases.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is 4 times as large', true, 'The tension is the net force, which supplies the centripetal acceleration: T = mv²/r. With r fixed, doubling v multiplies the tension by 2² = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is one-fourth as large', false, 'This inverts the dependence on speed. The required inward force grows as v², so doubling the speed increases the tension by a factor of 4.' from version_ins;
-- apphycm-mcq-sv-026-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-026-v3', 'mcq', 'Hammer-throw ball', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a hammer throw, a 4.0 kg ball moves in a horizontal circle of radius 1.5 m with a constant period of 0.50 s. Neglect gravity''s effect on the circle. What is the net force on the ball?', null, md5('apphycm-mcq-sv-026-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '470 N, directed toward the center', false, 'This uses 4π²r/T instead of 4π²r/T², leaving the period unsquared. With a = 4π²r/T² the net force is 4.0 × 4π² × 1.5/0.25 ≈ 950 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '75 N, directed toward the center', false, 'This is mv, the product of mass and speed, which is not a force. The centripetal force needs v²/r: mv²/r ≈ 950 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '950 N, directed toward the center', true, 'The speed is v = 2πr/T ≈ 18.8 m/s. The net force is the centripetal force F = mv²/r = (4.0)(18.8)²/1.5 ≈ 950 N, directed inward.' from version_ins
union all select gen_random_uuid(), id, 'D', '2100 N, directed toward the center', false, 'This multiplies mv² by the radius instead of dividing by it (mv²r ≈ 2132 would not even have units of force). The centripetal force is mv²/r ≈ 950 N.' from version_ins;
-- apphycm-mcq-sv-027-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-027-v1', 'mcq', 'Work by a quadratic force', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A variable force F(x) = 3.0x² (F in newtons, x in meters) acts on a crate along the x-axis. How much work does this force do on the crate from x = 1.0 m to x = 3.0 m?', null, md5('apphycm-mcq-sv-027-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '54 J', false, 'This multiplies the final force F(3.0) = 27 N by the full 2.0 m displacement. The force is not constant, so the work must be the integral, which is 26 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '26 J', true, 'W = ∫F dx from 1.0 to 3.0 = [x³] = 27 − 1 = 26 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '27 J', false, 'This evaluates the antiderivative x³ only at the upper limit and forgets to subtract its value at the lower limit (1). The definite integral is 27 − 1 = 26 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '30 J', false, 'This averages the force at the two endpoints, (3 + 27)/2, and multiplies by 2.0 m. That shortcut is not valid in general for a nonlinear force such as F = 3x², where it gives 30 J while the integral gives 26 J.' from version_ins;
-- apphycm-mcq-sv-027-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-027-v2', 'mcq', 'Work by a force that reverses sign', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A force F(x) = 8.0 − 2.0x (F in newtons, x in meters) acts on an object along the x-axis. How much net work does it do as the object moves from x = 0 to x = 6.0 m?', null, md5('apphycm-mcq-sv-027-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20 J', false, 'This adds the magnitudes of the two areas (16 J + 4 J). Work done where the force opposes the motion is negative and must be subtracted, giving 16 − 4 = 12 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '−24 J', false, 'This multiplies the final force F(6.0) = −4.0 N by the full 6.0 m. The force changes along the path, so the work is the integral, 12 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '16 J', false, 'This stops at x = 4.0 m, where the force becomes zero, and ignores the region from 4.0 m to 6.0 m. The force there points opposite to the motion and does −4 J of work, so the net work is 12 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '12 J', true, 'W = ∫(8.0 − 2.0x) dx from 0 to 6.0 = [8.0x − x²] = 48 − 36 = 12 J. The force reverses at x = 4.0 m, so part of the path contributes negative work.' from version_ins;
-- apphycm-mcq-sv-027-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-027-v3', 'mcq', 'Work by an exponentially decaying force', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A force F(x) = 20e^(−0.50x) (F in newtons, x in meters) acts on an object along the x-axis. How much work does it do from x = 0 to x = 2.0 m?', null, md5('apphycm-mcq-sv-027-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '25.3 J', true, 'W = ∫20e^(−0.50x) dx from 0 to 2.0 = (20/0.50)(1 − e^(−1.0)) = 40(0.632) ≈ 25.3 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '14.7 J', false, 'This multiplies the final force F(2.0) = 20e^(−1) ≈ 7.36 N by the 2.0 m displacement. The force decays along the path, so the work is the integral, about 25.3 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '27.4 J', false, 'This averages the endpoint forces, (20 + 7.36)/2, and multiplies by 2.0 m. For a nonlinear force that over-estimates the integral, which is about 25.3 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '12.6 J', false, 'This integrates without dividing by the coefficient 0.50 in the exponent: 20(1 − e^(−1)) ≈ 12.6 J. The antiderivative of e^(−0.50x) is −2.0e^(−0.50x), so the correct result is twice as large.' from version_ins;
-- apphycm-mcq-sv-028-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-028-v1', 'mcq', 'Force from a quartic potential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with potential energy U(x) = bx⁴, where b is a positive constant. The x-component of the force on the particle is', null, md5('apphycm-mcq-sv-028-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4bx³', true, 'The force is the negative derivative of the potential energy: F = −dU/dx = −4bx³.' from version_ins
union all select gen_random_uuid(), id, 'B', '−bx³', false, 'This lowers the power correctly but forgets the power-rule factor of 4 that comes down when differentiating x⁴.' from version_ins
union all select gen_random_uuid(), id, 'C', '−(b/5)x⁵', false, 'This integrates U(x) instead of differentiating it. The force is the negative derivative of U, not its antiderivative.' from version_ins
union all select gen_random_uuid(), id, 'D', '−4bx⁴', false, 'This brings down the factor 4 but leaves the exponent unchanged. Differentiating x⁴ gives x³.' from version_ins;
-- apphycm-mcq-sv-028-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-028-v2', 'mcq', 'Force at a point from a cubic potential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with potential energy U(x) = 3.0x² − 2.0x³ (U in joules, x in meters). What is the x-component of the force on the particle at x = 2.0 m?', null, md5('apphycm-mcq-sv-028-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4.0 N', false, 'This is the value of U at x = 2.0 m (12 − 16 = −4.0 J) reported as a force. The force comes from the derivative of U, not from U itself.' from version_ins
union all select gen_random_uuid(), id, 'B', '−12 N', false, 'This is dU/dx, the slope of U, without the minus sign. The force is the negative of the slope, so F = +12 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '+12 N', true, 'F = −dU/dx = −(6.0x − 6.0x²) = −(12 − 24) = +12 N, directed along +x.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 N', false, 'This differentiates the cubic term as 3x², dropping its coefficient 2.0, giving 6.0x − 3.0x² = 0 at x = 2.0 m. The correct derivative of 2.0x³ is 6.0x², so F = +12 N.' from version_ins;
-- apphycm-mcq-sv-028-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-028-v3', 'mcq', 'Force from an inverse-square potential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the positive x-axis with potential energy U(x) = 4.0/x² (U in joules, x in meters). What is the force on the particle at x = 0.50 m?', null, md5('apphycm-mcq-sv-028-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '32 N in the +x direction', false, 'This forgets the power-rule factor of 2 from x⁻², giving a magnitude 4.0/x³ = 32. Differentiating 4.0x⁻² gives −8.0x⁻³, so F = −dU/dx = +8.0x⁻³ = 64 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '128 N in the +x direction', false, 'This brings down the factor 2 but leaves the exponent as −4 (8.0/x⁴). Differentiating x⁻² lowers the exponent to −3, so the force is 8.0/x³ = 64 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '16 N in the +x direction', false, 'This is the value of U at x = 0.50 m (4.0/0.25 = 16 J) used as a force. The force is the negative derivative of U, not U itself.' from version_ins
union all select gen_random_uuid(), id, 'D', '64 N in the +x direction', true, 'F = −dU/dx = −d(4.0x⁻²)/dx = +8.0x⁻³ = 8.0/(0.50)³ = 64 N. The positive sign means the force pushes the particle toward larger x, where U is lower.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-sv-025-v3','apphycm-mcq-sv-026-v1','apphycm-mcq-sv-026-v2','apphycm-mcq-sv-026-v3','apphycm-mcq-sv-027-v1','apphycm-mcq-sv-027-v2','apphycm-mcq-sv-027-v3','apphycm-mcq-sv-028-v1','apphycm-mcq-sv-028-v2','apphycm-mcq-sv-028-v3']) and status='draft')<>10 then raise exception 'chunk 4: expected 10 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.content_key = any (array['apphycm-mcq-sv-025-v3','apphycm-mcq-sv-026-v1','apphycm-mcq-sv-026-v2','apphycm-mcq-sv-026-v3','apphycm-mcq-sv-027-v1','apphycm-mcq-sv-027-v2','apphycm-mcq-sv-027-v3','apphycm-mcq-sv-028-v1','apphycm-mcq-sv-028-v2','apphycm-mcq-sv-028-v3']))<>40 then raise exception 'chunk 4: choice rows'; end if;
end $$;
commit;
