begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-043-v2','apprecalc-mcq-sv-043-v3','apprecalc-mcq-sv-045-v1','apprecalc-mcq-sv-045-v2','apprecalc-mcq-sv-045-v3','apprecalc-mcq-sv-047-v1','apprecalc-mcq-sv-047-v2','apprecalc-mcq-sv-047-v3','apprecalc-mcq-sv-049-v1','apprecalc-mcq-sv-049-v2','apprecalc-mcq-sv-049-v3','apprecalc-mcq-sv-np2-001-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-043-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-043-v2', 'mcq', 'Sine increasing through the midline', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Which function has midline y=5, amplitude 2, period 4π, and is increasing as it crosses its midline at x=0?', null, md5('apprecalc-mcq-sv-043-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2cos(x/2)+5', false, 'Has the right midline, amplitude and period but a maximum (value 7) at x=0, not a midline crossing.' from version_ins
union all select gen_random_uuid(), id, 'B', '2sin(2x)+5', false, 'Uses b=2, giving period 2π/2=π rather than 4π.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2sin(x/2)+5', false, 'Crosses the midline at x=0 but is decreasing there because of the reflection.' from version_ins
union all select gen_random_uuid(), id, 'D', '2sin(x/2)+5', true, 'With b=1/2 the period is 2π/(1/2)=4π. At x=0, 2sin(0)+5=5 (on the midline) and sine is increasing there.' from version_ins;
-- apprecalc-mcq-sv-043-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-043-v3', 'mcq', 'Cosine with horizontal shift', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Which function has midline y=1, amplitude 4, period 2π, and a maximum at x=π/2?', null, md5('apprecalc-mcq-sv-043-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4sin(x−π/2)+1', false, 'Equals −4cos(x)+1. At x=π/2 it is 4sin(0)+1=1, on the midline rather than at a maximum.' from version_ins
union all select gen_random_uuid(), id, 'B', '4cos(x−π/2)+1', true, 'Shifting cosine right by π/2 moves its maximum from x=0 to x=π/2. Check: 4cos(0)+1=5 is the maximum, with midline 1 and period 2π.' from version_ins
union all select gen_random_uuid(), id, 'C', '4cos(2(x−π/2))+1', false, 'Has a maximum at x=π/2 (4cos(0)+1=5), but b=2 gives period π rather than 2π.' from version_ins
union all select gen_random_uuid(), id, 'D', '4cos(x+π/2)+1', false, 'Shifts left instead of right, so the maximum is at x=−π/2. At x=π/2: 4cos(π)+1=−3, a minimum.' from version_ins;
-- apprecalc-mcq-sv-045-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-045-v1', 'mcq', 'Evaluate sine model in radians', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

The depth of water in a tank is modeled by H(t)=12+5sin((π/12)(t−3)), where t is in hours. What is H(8), to the nearest tenth?', null, md5('apprecalc-mcq-sv-045-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '16.3', false, 'Omits the shift and evaluates sin((π/12)(8))=sin(2π/3)≈0.8660, giving 12+5(0.8660)≈16.33.' from version_ins
union all select gen_random_uuid(), id, 'B', '16.8', true, 'H(8)=12+5sin((π/12)(5))=12+5sin(5π/12)≈12+5(0.9659)≈16.83, or 16.8 (calculator in radian mode).' from version_ins
union all select gen_random_uuid(), id, 'C', '7.2', false, 'Uses the negative of the sine value: 12−5(0.9659)≈7.17.' from version_ins
union all select gen_random_uuid(), id, 'D', '12.1', false, 'Evaluates sin(1.309) with the calculator in degree mode: sin(1.309°)≈0.0228, so 12+5(0.0228)≈12.11.' from version_ins;
-- apprecalc-mcq-sv-045-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-045-v2', 'mcq', 'Evaluate cosine model in radians', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

The daily high of a quantity D, in appropriate units, is modeled by D(t)=6.5+2.5cos((2π/9)(t−1)), where t is in days. What is D(2), to the nearest tenth?', null, md5('apprecalc-mcq-sv-045-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8.4', true, 'D(2)=6.5+2.5cos((2π/9)(1))=6.5+2.5cos(2π/9)≈6.5+2.5(0.7660)≈8.42, or 8.4 (radian mode).' from version_ins
union all select gen_random_uuid(), id, 'B', '9.0', false, 'Evaluates cos(0.698) with the calculator in degree mode: cos(0.698°)≈0.99993, so 6.5+2.5(0.99993)≈9.00.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.9', false, 'Omits the shift and evaluates cos((2π/9)(2))=cos(4π/9)≈0.1736: 6.5+2.5(0.1736)≈6.93.' from version_ins
union all select gen_random_uuid(), id, 'D', '8.1', false, 'Uses sine instead of cosine: 6.5+2.5sin(2π/9)≈6.5+2.5(0.6428)≈8.11.' from version_ins;
-- apprecalc-mcq-sv-045-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-045-v3', 'mcq', 'Sine model written with period 24', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

A temperature in °F is modeled by C(t)=40+12sin(2π(t−6)/24), where t is in hours after midnight. What is C(8), to the nearest tenth?', null, md5('apprecalc-mcq-sv-045-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40.1', false, 'Evaluates sin(π/6≈0.5236) in degree mode: sin(0.5236°)≈0.00914, so 40+12(0.00914)≈40.11.' from version_ins
union all select gen_random_uuid(), id, 'B', '46.0', true, 'C(8)=40+12sin(2π(2)/24)=40+12sin(π/6)=40+12(0.5)=46.0.' from version_ins
union all select gen_random_uuid(), id, 'C', '50.4', false, 'Omits the shift and evaluates sin(2π(8)/24)=sin(2π/3)≈0.8660: 40+12(0.8660)≈50.39.' from version_ins
union all select gen_random_uuid(), id, 'D', '34.0', false, 'Uses the negative of the sine value: 40−12(0.5)=34.0.' from version_ins;
-- apprecalc-mcq-sv-047-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-047-v1', 'mcq', 'Simplify with tan and sec identity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Which expression is equivalent to (sec²x−1)/tan x, where tan x is defined and nonzero?', null, md5('apprecalc-mcq-sv-047-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'Treats sec²x−1 as tan x (instead of tan²x), so the ratio is tan x/tan x=1. At x=π/3 the expression is (4−1)/√3=√3, not 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'cot x', false, 'Divides the wrong way, tan x/tan²x=1/tan x=cot x, instead of tan²x/tan x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'tan x', true, 'The identity tan²x=sec²x−1 gives (sec²x−1)/tan x=tan²x/tan x=tan x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'tan²x', false, 'Uses sec²x−1=tan²x correctly but forgets to divide by tan x.' from version_ins;
-- apprecalc-mcq-sv-047-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-047-v2', 'mcq', 'Simplify cos x over 1−sin²x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Simplify cos x/(1−sin²x) using a Pythagorean identity. Which choice is an equivalent expression, for cos x≠0?', null, md5('apprecalc-mcq-sv-047-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'cos x', false, 'Treats 1−sin²x as 1, dropping the sin²x part, so the quotient is cos x/1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'cos x/sin²x', false, 'Replaces 1−sin²x with sin²x; the identity gives 1−sin²x=cos²x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sec x', true, 'Since 1−sin²x=cos²x, the expression is cos x/cos²x=1/cos x=sec x.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'Treats 1−sin²x as cos x rather than cos²x, so cos x/cos x=1. At x=π/3 the expression is (1/2)/(1/4)=2, not 1.' from version_ins;
-- apprecalc-mcq-sv-047-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-047-v3', 'mcq', 'Simplify sin²x over 1+cos x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

A student wants to simplify a trigonometric fraction using the Pythagorean identity. Assuming cos x ≠ −1, which expression is equivalent to sin²x/(1 + cos x)?', null, md5('apprecalc-mcq-sv-047-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1−cos²x', false, 'Rewrites sin²x as 1−cos²x but never divides by 1+cos x.' from version_ins
union all select gen_random_uuid(), id, 'B', '1+cos x', false, 'Factors 1−cos²x=(1−cos x)(1+cos x) correctly but divides out the wrong factor, (1−cos x), leaving 1+cos x.' from version_ins
union all select gen_random_uuid(), id, 'C', '−cos x', false, 'Rewrites to (1−cos²x)/(1+cos x) and then cancels the 1s, leaving −cos²x/cos x=−cos x, which is not valid because the 1s are terms, not factors.' from version_ins
union all select gen_random_uuid(), id, 'D', '1−cos x', true, 'sin²x=1−cos²x=(1−cos x)(1+cos x), so sin²x/(1+cos x)=1−cos x.' from version_ins;
-- apprecalc-mcq-sv-049-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-049-v1', 'mcq', 'Identify a sine cardioid', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

For r = 3 − 3sinθ, which statement best describes the graph?', null, md5('apprecalc-mcq-sv-049-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A cardioid symmetric about the polar axis, with a cusp at the pole and its farthest point at (6, π)', false, 'This is the graph of r = 3 − 3cosθ, where the cosine makes r = 6 at θ = π. For r = 3 − 3sinθ the value at θ = π is r = 3 − 3·0 = 3, not 6, and the graph is symmetric about θ = π/2, not the polar axis.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A cardioid symmetric about the line θ = π/2, with a cusp at the pole and its farthest point at (6, 3π/2)', true, 'Since the two coefficients have equal size (a = b = 3), r = 3 − 3sinθ is a cardioid. sin(π − θ) = sinθ, so the graph is symmetric about the line θ = π/2. r = 0 when sinθ = 1 (θ = π/2), giving the cusp at the pole, and r is largest at θ = 3π/2, where r = 3 − 3(−1) = 6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A limaçon with an inner loop, symmetric about the line θ = π/2, whose outer loop reaches (6, 3π/2)', false, 'An inner loop appears only when r takes negative values, which requires the sine coefficient to be larger in size than the constant. Here r = 3 − 3sinθ ≥ 0 for every θ (sinθ ≤ 1), and r = 0 only at θ = π/2, so the graph has a cusp at the pole and no inner loop.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A cardioid symmetric about the line θ = π/2, with a cusp at the pole and its farthest point at (6, π/2)', false, 'This is the graph of r = 3 + 3sinθ. For r = 3 − 3sinθ, at θ = π/2 the value is r = 3 − 3(1) = 0, which is the cusp itself, not a farthest point; the farthest point is at θ = 3π/2.' from version_ins;
-- apprecalc-mcq-sv-049-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-049-v2', 'mcq', 'Describe a three-petal rose', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

Which statement best describes the graph of r = 5cos(3θ)?', null, md5('apprecalc-mcq-sv-049-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A six-petal rose with petals of length 5, one of which is centered on the polar axis', false, 'Doubling the petal count applies to roses with an even n (for example r = 5cos(2θ) has four petals). With n = 3 odd, r = 5cos(3θ) has exactly 3 petals; the tips at θ = 0, 2π/3, 4π/3 all have r = 5, and a six-tip pattern never appears.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A three-petal rose with petals of length 5, one of which is centered on the polar axis', true, 'For r = a·cos(nθ) with n odd, the graph is a rose with n petals, so n = 3 gives three petals, each of length |a| = 5. At θ = 0, r = 5cos(0) = 5, so a petal tip lies on the polar axis (the other tips are at θ = 2π/3 and 4π/3, where r = 5cos(2π) = 5 and 5cos(4π) = 5).' from version_ins
union all select gen_random_uuid(), id, 'C', 'A three-petal rose with petals of length 5, one of which is centered on the line θ = π/2', false, 'That placement belongs to r = 5sin(3θ). For r = 5cos(3θ) at θ = π/2 we get r = 5cos(3π/2) = 0, so the graph passes through the pole there instead of having a petal tip; the tips are at θ = 0, 2π/3, and 4π/3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A three-petal rose with petals of length 3, one of which is centered on the polar axis', false, 'The petal length is the amplitude |a| = 5, not the coefficient 3 of θ. At θ = 0 the value is r = 5cos(0) = 5, so the petal reaches 5 units from the pole. The 3 only sets the number of petals.' from version_ins;
-- apprecalc-mcq-sv-049-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-049-v3', 'mcq', 'Limaçon with an inner loop', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

A student plots the polar equation r = 1 + 2cosθ on a graphing tool and examines its features. Which statement best describes the graph?', null, md5('apprecalc-mcq-sv-049-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A limaçon with an inner loop, symmetric about the polar axis, whose outer loop reaches (3, 0)', true, 'The cosine makes the graph symmetric about the polar axis, and r(0) = 1 + 2 = 3 gives the outer point (3, 0). Because the coefficient of cosθ (2) is larger in size than the constant (1), r becomes negative when cosθ < −1/2 (for 2π/3 < θ < 4π/3), for example r(π) = 1 − 2 = −1, which creates an inner loop.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A cardioid with a cusp at the pole, symmetric about the polar axis, reaching (3, 0)', false, 'A cardioid needs the constant and the cosine coefficient to be equal in size (as in r = 2 + 2cosθ). Here they are 1 and 2, and r(π) = 1 − 2 = −1 ≠ 0, so the graph does not simply touch the pole at θ = π; r passes through 0 at θ = 2π/3 and goes negative, forming a loop.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A limaçon with no inner loop, symmetric about the polar axis, reaching (3, 0)', false, 'No inner loop occurs only when the constant is at least as large in size as the cosine coefficient. Here 1 < 2, and r(π) = 1 + 2cos π = −1 is negative; the negative r-values for 2π/3 < θ < 4π/3 trace the inner loop.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A limaçon with an inner loop, symmetric about the line θ = π/2, whose outer loop reaches (3, π/2)', false, 'This is the sine version, r = 1 + 2sinθ. For r = 1 + 2cosθ, at θ = π/2 the value is r = 1 + 2·0 = 1, not 3, and the symmetry is about the polar axis because cos(−θ) = cosθ.' from version_ins;
-- apprecalc-mcq-sv-np2-001-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-001-v1', 'mcq', 'End behavior of an even-degree polynomial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'As x approaches negative infinity, what is the end behavior of h(x) = 4x^6 − 7x^3 + 2?', null, md5('apprecalc-mcq-sv-np2-001-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h(x) approaches 0', false, 'This confuses the polynomial with a rational function whose denominator grows. A nonconstant polynomial is unbounded; h(−10) = 4,007,002 and h(−100) is even larger, so the values do not shrink toward 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h(x) approaches 2', false, 'This reads off the constant term as if it were a limiting value. The constant is dominated by 4x^6 for large |x|: h(−10) = 4,007,002, nowhere near 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h(x) approaches negative infinity', false, 'This treats x^6 as negative when x is negative, as an odd power would be. An even power of a negative number is positive: (−10)^6 = 1,000,000, so h(−10) = 4,007,002, which is large and positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h(x) approaches positive infinity', true, 'The leading term 4x^6 determines end behavior. The degree is even and the leading coefficient is positive, so h(x) approaches positive infinity at both ends. For example, h(−10) = 4,000,000 + 7,000 + 2 = 4,007,002.' from version_ins;
commit;
