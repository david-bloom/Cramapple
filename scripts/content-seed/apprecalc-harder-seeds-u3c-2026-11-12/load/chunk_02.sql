begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-sv-h-3.11-a-v1','apprecalc-mcq-b3-sv-h-3.11-a-v2','apprecalc-mcq-b3-sv-h-3.11-a-v3','apprecalc-mcq-b3-h-3.11-b','apprecalc-mcq-b3-sv-h-3.11-b-v1','apprecalc-mcq-b3-sv-h-3.11-b-v2','apprecalc-mcq-b3-sv-h-3.11-b-v3','apprecalc-mcq-b3-h-3.12-a','apprecalc-mcq-b3-sv-h-3.12-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apprecalc-mcq-b3-sv-h-3.11-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.11-a-v1', 'mcq', 'find the range of a transformed secant or cosecant function by combining the |value| ≥ 1 restriction with a stretch, ref (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the range of the function y = 3sec x + 2?', null, md5('apprecalc-mcq-b3-sv-h-3.11-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[−1, 5]', false, 'This treats sec x like a bounded wave oscillating about the shift; the secant has no maximum or minimum on its two branches, so the range is unbounded.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−∞, −1] ∪ [5, ∞)', true, 'Correct: sec x ≤ −1 or sec x ≥ 1. Tripling gives ≤ −3 or ≥ 3, and adding 2 gives y ≤ −1 or y ≥ 5, so the range is (−∞, −1] ∪ [5, ∞).' from version_ins
union all select gen_random_uuid(), id, 'C', '(−∞, −3] ∪ [3, ∞)', false, 'This applies the vertical stretch by 3 but forgets the shift up by 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−∞, −5] ∪ [1, ∞)', false, 'This shifts the stretched range down by 2 instead of up by 2.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.11-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.11-a-v2', 'mcq', 'find the range of a transformed secant or cosecant function by combining the |value| ≥ 1 restriction with a stretch, ref (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the range of the function y = −2csc x + 1?', null, md5('apprecalc-mcq-b3-sv-h-3.11-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[−1, 3]', false, 'This treats the values between the two branches as attained, but |csc x| ≥ 1, so the stretched and shifted function never takes values between −1 and 3 and is unbounded.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−∞, −1] ∪ [3, ∞)', true, 'Correct: csc x ≤ −1 or csc x ≥ 1, so −2csc x ≥ 2 or ≤ −2 (a reflection keeps the same two pieces). Adding 1 gives y ≤ −1 or y ≥ 3, so the range is (−∞, −1] ∪ [3, ∞).' from version_ins
union all select gen_random_uuid(), id, 'C', '(−∞, −3] ∪ [1, ∞)', false, 'This shifts the range down by 1 instead of up by 1; the reflection does not change the symmetric set of magnitudes ≥ 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−∞, −2] ∪ [2, ∞)', false, 'This applies the stretch and reflection but forgets the shift up by 1.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.11-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.11-a-v3', 'mcq', 'find the range of a transformed secant or cosecant function by combining the |value| ≥ 1 restriction with a stretch, ref (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the range of the function y = (1/2)sec x − 3?', null, md5('apprecalc-mcq-b3-sv-h-3.11-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[−7/2, −5/2]', false, 'This takes the endpoints of the two branches as a closed bounded interval; the secant is unbounded on both branches, so the range is not bounded.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−∞, −1/2] ∪ [1/2, ∞)', false, 'This applies the vertical compression by 1/2 but forgets the shift down by 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−∞, −7/2] ∪ [−5/2, ∞)', true, 'Correct: sec x ≤ −1 or sec x ≥ 1. Halving gives ≤ −1/2 or ≥ 1/2, and subtracting 3 gives y ≤ −7/2 or y ≥ −5/2, so the range is (−∞, −7/2] ∪ [−5/2, ∞).' from version_ins
union all select gen_random_uuid(), id, 'D', '(−∞, −4] ∪ [−2, ∞)', false, 'This forgets the vertical compression and uses magnitudes of at least 1, then shifts down by 3.' from version_ins;
-- apprecalc-mcq-b3-h-3.11-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.11-b', 'mcq', 'locate every vertical asymptote of a secant or cosecant graph with a horizontal compression and phase shift, on a given ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x ≤ π, at which x-values does the graph of y = csc(2x − π/3) have vertical asymptotes?', null, md5('apprecalc-mcq-b3-h-3.11-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '{π/6, 2π/3}', true, 'Correct: Asymptotes occur where sin(2x − π/3) = 0, so 2x − π/3 = kπ and x = π/6 + kπ/2. In [0, π] this gives k = 0 and k = 1: x = π/6 and x = 2π/3 (k = 2 gives 7π/6, outside the interval).' from version_ins
union all select gen_random_uuid(), id, 'B', '{π/3, 5π/6}', false, 'This solves 2x + π/3 = kπ, shifting the wrong way, so every asymptote lands π/3 away from the true location.' from version_ins
union all select gen_random_uuid(), id, 'C', '{0, π/2, π}', false, 'This gives the zeros of sin(2x), ignoring the phase shift of π/3 inside the argument.' from version_ins
union all select gen_random_uuid(), id, 'D', '{π/6}', false, 'This finds the first asymptote but steps by π instead of π/2 between asymptotes, forgetting that 2x halves the spacing.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.11-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.11-b-v1', 'mcq', 'locate every vertical asymptote of a secant or cosecant graph with a horizontal compression and phase shift, on a given  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x ≤ 2π/3, at which x-values does the graph of y = sec(3x + π/2) have vertical asymptotes?', null, md5('apprecalc-mcq-b3-sv-h-3.11-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '{π/6, π/2}', false, 'This gives the zeros of cos(3x), ignoring the phase shift of π/2 inside the argument.' from version_ins
union all select gen_random_uuid(), id, 'B', '{π/3, 2π/3}', false, 'This solves 3x − π/2 = π/2 + kπ, shifting the wrong way, which loses the asymptote at x = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '{0, 2π/3}', false, 'This steps by 2π/3 instead of π/3 between asymptotes, treating the spacing as a full period of the argument rather than a half period.' from version_ins
union all select gen_random_uuid(), id, 'D', '{0, π/3, 2π/3}', true, 'Correct: Asymptotes occur where cos(3x + π/2) = 0, so 3x + π/2 = π/2 + kπ and x = kπ/3. In [0, 2π/3] this gives x = 0, π/3 and 2π/3 (equivalently cos(3x + π/2) = −sin 3x, which is zero at multiples of π/3).' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.11-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.11-b-v2', 'mcq', 'locate every vertical asymptote of a secant or cosecant graph with a horizontal compression and phase shift, on a given  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x ≤ 4π, at which x-values does the graph of y = csc(x/2 − π/4) have vertical asymptotes?', null, md5('apprecalc-mcq-b3-sv-h-3.11-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '{0, 2π, 4π}', false, 'This gives the zeros of sin(x/2), ignoring the phase shift of π/4 inside the argument.' from version_ins
union all select gen_random_uuid(), id, 'B', '{3π/2, 7π/2}', false, 'This solves x/2 + π/4 = kπ, shifting the wrong way, which moves each asymptote by π.' from version_ins
union all select gen_random_uuid(), id, 'C', '{π/2, 5π/2}', true, 'Correct: Asymptotes occur where sin(x/2 − π/4) = 0, so x/2 − π/4 = kπ and x = π/2 + 2kπ. In [0, 4π] this gives x = π/2 and x = 5π/2 (k = 2 gives 9π/2, outside the interval).' from version_ins
union all select gen_random_uuid(), id, 'D', '{π/2, 3π/2, 5π/2, 7π/2}', false, 'This steps by π between asymptotes, forgetting that x/2 stretches the spacing to 2π.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.11-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.11-b-v3', 'mcq', 'locate every vertical asymptote of a secant or cosecant graph with a horizontal compression and phase shift, on a given  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x ≤ 2π, at which x-values does the graph of y = sec(2x − π) have vertical asymptotes?', null, md5('apprecalc-mcq-b3-sv-h-3.11-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '{0, π/2, π, 3π/2, 2π}', false, 'This gives the zeros of sin(2x), as for a cosecant function; a secant has asymptotes where cosine is zero instead.' from version_ins
union all select gen_random_uuid(), id, 'B', '{π/2, 3π/2}', false, 'This gives the zeros of cos x, ignoring both the compression by 2 and the phase shift.' from version_ins
union all select gen_random_uuid(), id, 'C', '{π/4, 3π/4, 5π/4, 7π/4}', true, 'Correct: Asymptotes occur where cos(2x − π) = 0, so 2x − π = π/2 + kπ and x = 3π/4 + kπ/2. In [0, 2π] the values are π/4, 3π/4, 5π/4 and 7π/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '{3π/4, 7π/4}', false, 'This solves 2x − π = π/2 + kπ but steps by π between asymptotes instead of π/2, so it loses half of them.' from version_ins;
-- apprecalc-mcq-b3-h-3.12-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.12-a', 'mcq', 'identify the one invalid identity among four by recognizing which algebraic or trigonometric shortcut fails (square root', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following equations is NOT an identity (that is, is not true for every x for which both sides are defined)?', null, md5('apprecalc-mcq-b3-h-3.12-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√(sin²x) = sin x', true, 'Correct: For x = 3π/2, the left side √(sin²x) = √1 = 1, but sin x = −1, so the equation fails. The other three simplify to equal expressions.' from version_ins
union all select gen_random_uuid(), id, 'B', '(1 − cos x)(1 + cos x) = sin²x', false, 'This is a true identity: the product is a difference of squares equal to 1 − cos²x, which equals sin²x by the Pythagorean identity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sec²x − tan²x = 1', false, 'This is a true identity: dividing sin²x + cos²x = 1 by cos²x gives tan²x + 1 = sec²x, which rearranges to this.' from version_ins
union all select gen_random_uuid(), id, 'D', 'csc x · tan x = sec x', false, 'This is a true identity: (1/sin x)(sin x/cos x) = 1/cos x, so both sides equal sec x.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.12-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.12-a-v1', 'mcq', 'identify the one invalid identity among four by recognizing which algebraic or trigonometric shortcut fails (square root (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following equations is NOT an identity (that is, is not true for every x for which both sides are defined)?', null, md5('apprecalc-mcq-b3-sv-h-3.12-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'cos x · tan x = sin x', false, 'This is a true identity: cos x · (sin x/cos x) = sin x wherever tan x is defined.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/(1 − sin x) + 1/(1 + sin x) = 2sec²x', false, 'This is a true identity: the sum is 2/(1 − sin²x) = 2/cos²x = 2sec²x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sin(x + π) = −sin x', false, 'This is a true identity: a half-turn of π moves the point to the opposite side of the unit circle and negates the sine.' from version_ins
union all select gen_random_uuid(), id, 'D', 'cos(π − x) = cos x', true, 'Correct: Take x = π/3: cos(π − π/3) = cos(2π/3) = −1/2, but cos(π/3) = 1/2, so the equation fails; it holds only with a negative sign.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-sv-h-3.11-a-v1','apprecalc-mcq-b3-sv-h-3.11-a-v2','apprecalc-mcq-b3-sv-h-3.11-a-v3','apprecalc-mcq-b3-h-3.11-b','apprecalc-mcq-b3-sv-h-3.11-b-v1','apprecalc-mcq-b3-sv-h-3.11-b-v2','apprecalc-mcq-b3-sv-h-3.11-b-v3','apprecalc-mcq-b3-h-3.12-a','apprecalc-mcq-b3-sv-h-3.12-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b3-sv-h-3.11-a-v1','apprecalc-mcq-b3-sv-h-3.11-a-v2','apprecalc-mcq-b3-sv-h-3.11-a-v3','apprecalc-mcq-b3-h-3.11-b','apprecalc-mcq-b3-sv-h-3.11-b-v1','apprecalc-mcq-b3-sv-h-3.11-b-v2','apprecalc-mcq-b3-sv-h-3.11-b-v3','apprecalc-mcq-b3-h-3.12-a','apprecalc-mcq-b3-sv-h-3.12-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
