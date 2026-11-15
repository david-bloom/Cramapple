begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-h-4.5-b','apcalcbc-mcq-b4-sv-h-4.5-b-v1','apcalcbc-mcq-b4-sv-h-4.5-b-v2','apcalcbc-mcq-b4-sv-h-4.5-b-v3','apcalcbc-mcq-b4-h-4.6-a','apcalcbc-mcq-b4-sv-h-4.6-a-v1','apcalcbc-mcq-b4-sv-h-4.6-a-v2','apcalcbc-mcq-b4-sv-h-4.6-a-v3','apcalcbc-mcq-b4-h-4.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b4-h-4.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.5-b', 'mcq', 'apply the product rule to a quantity that depends on two changing variables, keeping the sign of each rate.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The radius of a cylindrical can increases at 0.2 cm/s while its height decreases at 0.5 cm/s. At the instant when r = 4 cm and h = 10 cm, which statement about the volume V = πr²h is correct?', null, md5('apcalcbc-mcq-b4-h-4.5-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The volume is increasing at 16π cm³/s.', false, 'This accounts for the growing radius, 2πrh·r′ = 16π, but leaves out the term πr²·h′ from the shrinking height.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The volume is increasing at 24π cm³/s.', false, 'This treats the height''s rate as +0.5 when computing πr²h′, adding 8π instead of subtracting it; the height is decreasing, so h′ = −0.5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The volume is decreasing at 0.8π cm³/s.', false, 'This multiplies the derivatives of the factors, π(2rr′)(h′), instead of using the product rule, which gives 2πrh·r′ + πr²·h′.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The volume is increasing at 8π cm³/s.', true, 'Correct: V′ = π(2rh·r′ + r²·h′) = π(2·4·10·0.2 + 16·(−0.5)) = π(16 − 8) = 8π cm³/s, so the volume is increasing.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.5-b-v1', 'mcq', 'apply the product rule to a quantity that depends on two changing variables, keeping the sign of each rate. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The length of a rectangular plate increases at 0.3 cm/s while its width decreases at 0.4 cm/s. At the instant when the length is 12 cm and the width is 8 cm, which statement about the area is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.5-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The area is increasing at 7.2 cm²/s.', false, 'This treats the width''s rate as +0.4, adding 12(0.4) = 4.8 to 0.3(8) = 2.4; the width is decreasing, so w′ = −0.4 and that term is −4.8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The area is decreasing at 0.12 cm²/s.', false, 'This multiplies the two rates, ℓ′·w′ = (0.3)(−0.4), instead of using the product rule A′ = ℓ′w + ℓw′.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The area is decreasing at 2.4 cm²/s.', true, 'Correct: A = ℓw, so A′ = ℓ′w + ℓw′ = (0.3)(8) + (12)(−0.4) = 2.4 − 4.8 = −2.4 cm²/s, so the area is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The area is increasing at 0.4 cm²/s.', false, 'This computes ℓ·ℓ′ + w·w′ = 3.6 − 3.2, pairing each rate with its own dimension; the product rule pairs ℓ′ with w and w′ with ℓ.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.5-b-v2', 'mcq', 'apply the product rule to a quantity that depends on two changing variables, keeping the sign of each rate. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sealed syringe holds a gas whose pressure P and volume V satisfy PV = k at constant temperature. At the instant when P = 200 kPa and V = 1.5 L, the pressure is increasing at 10 kPa/min. Which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.5-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The volume is increasing at 0.075 L/min.', false, 'Differentiating PV = k gives P′V + PV′ = 0, so V′ = −VP′/P is negative; rising pressure at constant temperature means shrinking volume.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The volume is decreasing at 0.05 L/min.', false, 'This uses V′ = −P′/P and drops the factor V = 1.5; solving P′V + PV′ = 0 gives V′ = −VP′/P = −1.5(10)/200.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The volume is decreasing at 0.075 L/min.', true, 'Correct: PV = k gives P′V + PV′ = 0, so V′ = −V·P′/P = −(1.5)(10)/200 = −0.075 L/min.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The volume is decreasing at about 1333 L/min.', false, 'This inverts the ratio, V′ = −(P/V)P′, but solving P′V + PV′ = 0 for V′ gives −(V/P)P′, with V on top.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.5-b-v3', 'mcq', 'apply the product rule to a quantity that depends on two changing variables, keeping the sign of each rate. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The radius of a cone increases at 0.5 cm/s while its height decreases at 1 cm/s. At the instant when r = 6 cm and h = 9 cm, which statement about the volume V = (1/3)πr²h is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.5-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The volume is increasing at 18π cm³/s.', false, 'This applies the product rule correctly but leaves out the factor 1/3 from V = (1/3)πr²h, tripling the result.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The volume is increasing at 30π cm³/s.', false, 'This treats the height''s rate as +1 and adds r² to 2rh·r′ inside the parentheses; the height is decreasing, so h′ = −1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The volume is decreasing at 2π cm³/s.', false, 'This multiplies the derivatives of the factors, (π/3)(2rr′)(h′), instead of using the product rule, which gives (π/3)(2rh·r′ + r²·h′).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The volume is increasing at 6π cm³/s.', true, 'Correct: V′ = (π/3)(2rh·r′ + r²·h′) = (π/3)(2·6·9·0.5 + 36·(−1)) = (π/3)(54 − 36) = 6π cm³/s, so the volume is increasing.' from version_ins;
-- apcalcbc-mcq-b4-h-4.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.6-a', 'mcq', 'use a tangent-line approximation at the correct point and decide whether it overestimates or underestimates from the con', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has f(3) = 4, and f′ is decreasing on the interval [2, 4]. Selected values of f′ are given.
x | f′(x)
2.5 | 1.5
3 | 1.1
3.5 | 0.6
4 | 0.2
The tangent line at x = 3 is used to approximate f(3.4). Which statement is correct?', null, md5('apcalcbc-mcq-b4-h-4.6-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The approximation is 4.44, and it is an underestimate of f(3.4).', false, 'F′ is decreasing, so f″ < 0 and f is concave down; a tangent line to a concave-down graph lies above the graph, so it overestimates.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The approximation is 4.24, and it is an overestimate of f(3.4).', false, 'This uses the slope f′(3.5) = 0.6, the table value nearest 3.4, but the tangent line at x = 3 must use the slope at the point of tangency, f′(3) = 1.1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The approximation is 4.44, and it is an overestimate of f(3.4).', true, 'Correct: L(x) = f(3) + f′(3)(x − 3) = 4 + 1.1(0.4) = 4.44. Since f′ is decreasing, f″ < 0, the graph is concave down and lies below its tangent line, so 4.44 overestimates f(3.4).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The approximation is 3.56, and it is an underestimate of f(3.4).', false, 'This subtracts f′(3)(0.4) even though 3.4 is to the right of 3; the tangent line gives f(3) + f′(3)(3.4 − 3) = 4 + 0.44.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.6-a-v1', 'mcq', 'use a tangent-line approximation at the correct point and decide whether it overestimates or underestimates from the con (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = e^(x/2). The tangent line at x = 0 is used to approximate h(0.6). Which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.6-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The approximation is 1.3, and it is an overestimate of h(0.6).', false, 'H″(x) = (1/4)e^(x/2) > 0, so the graph is concave up and lies above its tangent line; the tangent line therefore underestimates.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The approximation is 1.6, and it is an overestimate of h(0.6).', false, 'This uses h′(0) = 1 by omitting the chain-rule factor 1/2; the correct derivative is h′(x) = (1/2)e^(x/2), so h′(0) = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The approximation is 0.7, and it is an underestimate of h(0.6).', false, 'This subtracts h′(0)(0.6) = 0.3 from h(0) = 1 even though 0.6 is to the right of 0; the tangent line gives 1 + (1/2)(0.6).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The approximation is 1.3, and it is an underestimate of h(0.6).', true, 'Correct: h′(0) = 1/2, so L(x) = 1 + x/2 and L(0.6) = 1.3. Since h″(x) = (1/4)e^(x/2) > 0, the graph is concave up and lies above its tangent line, so 1.3 underestimates h(0.6).' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.6-a-v2', 'mcq', 'use a tangent-line approximation at the correct point and decide whether it overestimates or underestimates from the con (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f has f(10) = 20 and f′(10) = −1.5, and f′ is increasing on [10, 11]. The tangent line at x = 10 is used to approximate f(10.4). Which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.6-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The approximation is 19.4, and it is an overestimate of f(10.4).', false, 'F′ is increasing, so f″ > 0 and f is concave up; the tangent line lies below the graph, so it underestimates even though the slope is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The approximation is 20.6, and it is an overestimate of f(10.4).', false, 'This adds 1.5(0.4) to f(10); the slope is −1.5, so the tangent line moves down as x increases, giving 20 − 1.5(0.4).' from version_ins
union all select gen_random_uuid(), id, 'C', 'The approximation is 18.5, and it is an underestimate of f(10.4).', false, 'This uses a step of 1 unit instead of 0.4; the tangent line changes by f′(10)(10.4 − 10) = −1.5(0.4) = −0.6.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The approximation is 19.4, and it is an underestimate of f(10.4).', true, 'Correct: L(10.4) = 20 + (−1.5)(0.4) = 19.4. Since f′ is increasing, f″ > 0, the graph is concave up and lies above its tangent line, so 19.4 underestimates f(10.4).' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.6-a-v3', 'mcq', 'use a tangent-line approximation at the correct point and decide whether it overestimates or underestimates from the con (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = x^(1/3). The tangent line at x = 27 is used to approximate the cube root of 25, which is g(25). Which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.6-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The approximation is about 2.926, and it is an underestimate of g(25).', false, 'G″(x) = −(2/9)x^(−5/3) < 0, so the graph is concave down and lies below its tangent line; the tangent line therefore overestimates.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The approximation is about 2.926, and it is an overestimate of g(25).', true, 'Correct: g′(x) = (1/3)x^(−2/3), so g′(27) = 1/27 and L(25) = 3 + (1/27)(−2) ≈ 2.926. Since g″(x) < 0 the graph is concave down and lies below its tangent line, so L(25) overestimates g(25) ≈ 2.924.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The approximation is about 2.778, and it is an underestimate of g(25).', false, 'This uses g′(27) = 1/9 by writing (1/3)x^(−1/3) instead of (1/3)x^(−2/3); the correct slope is 1/27.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The approximation is about 3.074, and it is an overestimate of g(25).', false, 'This adds 2/27 to g(27) = 3; since 25 is to the left of 27 the change is g′(27)(25 − 27) = −2/27 and the approximation is below 3.' from version_ins;
-- apcalcbc-mcq-b4-h-4.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.6-b', 'mcq', 'use a tangent-line model in reverse to estimate when a target value is reached, and use concavity to decide whether the ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pie is removed from an oven at t = 10 minutes. Its temperature T(t), in degrees Fahrenheit, satisfies T(10) = 250 and T′(10) = −4, and T is concave up for t ≥ 10. The tangent line at t = 10 is used to estimate when the pie reaches 200 degrees Fahrenheit. Which statement is correct?', null, md5('apcalcbc-mcq-b4-h-4.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The tangent line gives t = 22.5 minutes, and the pie actually reaches 200 degrees earlier than that.', false, 'T is concave up, so the graph lies above its tangent line; at t = 22.5 the true temperature is still above 200, so the pie reaches 200 later.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The tangent line gives t = 12.5 minutes, and the pie actually reaches 200 degrees later than that.', false, 'Solving 250 − 4(t − 10) = 200 gives t − 10 = 12.5; 12.5 is the elapsed time since t = 10, so 10 must be added to get t = 22.5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The tangent line gives t = 22.5 minutes, and the pie actually reaches 200 degrees later than that.', true, 'Correct: L(t) = 250 − 4(t − 10) = 200 gives t = 22.5. Because T is concave up, T(t) ≥ L(t), so T(22.5) > 200 and the pie has not yet reached 200 at t = 22.5; the true time is later.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The tangent line gives t = 62.5 minutes, and the pie actually reaches 200 degrees earlier than that.', false, '250/4 = 62.5 divides the temperature by the rate instead of dividing the 50-degree drop by the rate; the equation is 250 − 4(t − 10) = 200.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-h-4.5-b','apcalcbc-mcq-b4-sv-h-4.5-b-v1','apcalcbc-mcq-b4-sv-h-4.5-b-v2','apcalcbc-mcq-b4-sv-h-4.5-b-v3','apcalcbc-mcq-b4-h-4.6-a','apcalcbc-mcq-b4-sv-h-4.6-a-v1','apcalcbc-mcq-b4-sv-h-4.6-a-v2','apcalcbc-mcq-b4-sv-h-4.6-a-v3','apcalcbc-mcq-b4-h-4.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b4-h-4.5-b','apcalcbc-mcq-b4-sv-h-4.5-b-v1','apcalcbc-mcq-b4-sv-h-4.5-b-v2','apcalcbc-mcq-b4-sv-h-4.5-b-v3','apcalcbc-mcq-b4-h-4.6-a','apcalcbc-mcq-b4-sv-h-4.6-a-v1','apcalcbc-mcq-b4-sv-h-4.6-a-v2','apcalcbc-mcq-b4-sv-h-4.6-a-v3','apcalcbc-mcq-b4-h-4.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
