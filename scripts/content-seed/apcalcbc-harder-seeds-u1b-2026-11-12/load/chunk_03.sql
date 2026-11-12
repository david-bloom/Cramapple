begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.11-a-v2','apcalcbc-mcq-b7-sv-h-1.11-a-v3','apcalcbc-mcq-b7-h-1.11-b','apcalcbc-mcq-b7-sv-h-1.11-b-v1','apcalcbc-mcq-b7-sv-h-1.11-b-v2','apcalcbc-mcq-b7-sv-h-1.11-b-v3','apcalcbc-mcq-b7-h-1.12-a','apcalcbc-mcq-b7-sv-h-1.12-a-v1','apcalcbc-mcq-b7-sv-h-1.12-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b7-sv-h-1.11-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.11-a-v2', 'mcq', 'apply the three-part definition of continuity to a piecewise function with exponential and logarithmic pieces, evaluatin (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h be defined by h(x) = a·e^x + 2b for x < 0, h(0) = 6, and h(x) = 2a·cos x + b·arctan x for x > 0. If h is continuous at x = 0, what is the value of b?', null, md5('apcalcbc-mcq-b7-sv-h-1.11-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', false, 'This reads the left limit as a + b instead of a + 2b, which gives b = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This drops the factor 2 on the right, writing a = 6, and then a + 2b = 6 gives b = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '9/2', false, 'This solves 2b = 6 + 3 = 9 (adding a instead of subtracting it) and gets b = 9/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '3/2', true, 'Correct: Right limit: 2a·cos 0 + b·arctan 0 = 2a, so 2a = 6 and a = 3. Left limit: a + 2b = 6, so b = 3/2.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.11-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.11-a-v3', 'mcq', 'apply the three-part definition of continuity to a piecewise function with exponential and logarithmic pieces, evaluatin (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let p be defined by p(x) = ax − b for x < 1, p(1) = 2, and p(x) = b·e^(x − 1) + a·ln x for x > 1. If p is continuous at x = 1, what is the value of a?', null, md5('apcalcbc-mcq-b7-sv-h-1.11-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', true, 'Correct: Right limit: b·e⁰ + a·ln 1 = b, so b = 2. Left limit: a − b = 2, so a = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This reads the left piece ax − b as ax + b, so the left limit is a + b = 2 and with b = 2 gives a = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This takes ln 1 = 1, so the right limit is a + b = 2, which with a − b = 2 gives a = 2 and b = 0; but ln 1 = 0, so the right limit is just b = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'This solves a − b = 2 as a = 2 + 2b = 6, adding b twice instead of once.' from version_ins;
-- apcalcbc-mcq-b7-h-1.11-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.11-b', 'mcq', 'translate the definition of continuity into limit notation, separating conditions that only compare the two sides from t', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a function f defined at every real number, which of the following is equivalent to the statement that f is continuous at x = 2?', null, md5('apcalcbc-mcq-b7-h-1.11-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(h→0) [f(2 + h) − f(2 − h)] = 0', false, 'This says the values at symmetric points agree in the limit, which is satisfied by a function with f(2) = 7 and f(x) = 0 elsewhere; it never mentions f(2).' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→2) f(x) exists', false, 'The limit can exist while f(2) is different from it or is not equal; existence of the limit is only one of the three conditions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(h→0) [f(2 + h) − f(2)] = 0', true, 'Correct: The definition needs lim(x→2) f(x) = f(2). Setting x = 2 + h, this says f(2 + h) − f(2) → 0 as h → 0 from both sides, which is C.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(n→∞) f(2 + 1/n) = f(2)', false, 'This tests only one sequence of inputs approaching 2 from the right, so it says nothing about the left side or about other sequences.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.11-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.11-b-v1', 'mcq', 'translate the definition of continuity into limit notation, separating conditions that only compare the two sides from t (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a function f defined at every real number, which of the following is equivalent to the statement that f is continuous at x = 3?', null, md5('apcalcbc-mcq-b7-sv-h-1.11-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(h→0+) [f(3 + h) − f(3 − h)] = 0', false, 'This only says the two sides approach the same thing in difference; it can hold for a function whose left and right limits do not exist or whose common value differs from f(3).' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(h→0+) f(3 + h) = f(3) and lim(h→0+) f(3 − h) = f(3)', true, 'Correct: The first expression is the right-hand limit equal to f(3), the second is the left-hand limit equal to f(3); both together are exactly continuity at 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(h→0+) f(3 + h) = lim(h→0+) f(3 − h)', false, 'The two one-sided limits agree, but their common value is not required to be f(3); a removable discontinuity satisfies C.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→3) f(x) exists and f(3) is defined', false, 'Both parts hold at a removable discontinuity, where the limit exists and f(3) is defined but the two are not equal.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.11-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.11-b-v2', 'mcq', 'translate the definition of continuity into limit notation, separating conditions that only compare the two sides from t (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a function f defined at every real number, which of the following is equivalent to the statement that f is continuous at x = 1?', null, md5('apcalcbc-mcq-b7-sv-h-1.11-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'For the sequence x_n = 1 + 1/n, f(x_n) approaches f(1) as n increases.', false, 'This examines one sequence from the right only, which cannot control the left side or other sequences.' from version_ins
union all select gen_random_uuid(), id, 'B', 'For every sequence x_n that approaches 1, f(x_n) approaches f(1).', true, 'Correct: Continuity at 1 means lim(x→1) f(x) = f(1), which is equivalent to f(x_n) → f(1) along every sequence x_n → 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(1 + 1/n) and f(1 − 1/n) approach the same value as n increases.', false, 'Two sequences giving the same limit show a kind of symmetry but not that this common value equals f(1), and other sequences are not tested.' from version_ins
union all select gen_random_uuid(), id, 'D', '|f(x) − f(1)| < 1 for every x sufficiently close to 1.', false, 'This only keeps f within distance 1 of f(1), a bound, whereas continuity requires |f(x) − f(1)| to be made smaller than every positive number.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.11-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.11-b-v3', 'mcq', 'translate the definition of continuity into limit notation, separating conditions that only compare the two sides from t (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies f(5) = 3, lim(h→0+) f(5 + h) = 3, and lim(h→0+) f(5 − h) = 3. Which conclusion is justified?', null, md5('apcalcbc-mcq-b7-sv-h-1.11-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is continuous from the right at x = 5 but not necessarily from the left.', false, 'The second limit, with 5 − h approaching 5 from the left, shows left continuity as well, so nothing is missing on the left.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is differentiable at x = 5.', false, 'Continuity does not imply differentiability; f(x) = |x − 5| + 3 satisfies all the given conditions but has a corner at 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is continuous at x = 5.', true, 'Correct: The first limit is the right-hand limit at 5, the second is the left-hand limit; both equal f(5) = 3, which is the definition of continuity at 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is continuous on an open interval containing x = 5.', false, 'The information concerns only the point x = 5; f could be discontinuous at points arbitrarily close to 5 (for example at every nearby rational), so an interval of continuity is not guaranteed.' from version_ins;
-- apcalcbc-mcq-b7-h-1.12-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.12-a', 'mcq', 'find the largest set of continuity for a quotient of inverse-trigonometric and logarithmic expressions by intersecting d', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the largest set of x-values on which f(x) = arcsin(x − 1)/ln x is continuous?', null, md5('apcalcbc-mcq-b7-h-1.12-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, 1) ∪ (1, 2]', false, 'This keeps x = 0 because arcsin(−1) is defined, but ln 0 is undefined, so f is not defined at 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '(0, 2]', false, 'This keeps x = 1, but ln 1 = 0 makes the denominator zero, so f is not defined at 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '(0, 1) ∪ (1, 2)', false, 'This drops the endpoint x = 2, but at x = 2 both arcsin(1) = π/2 and ln 2 are defined and ln 2 ≠ 0, so f is continuous there from the left.' from version_ins
union all select gen_random_uuid(), id, 'D', '(0, 1) ∪ (1, 2]', true, 'Correct: arcsin(x − 1) needs −1 ≤ x − 1 ≤ 1, so 0 ≤ x ≤ 2. ln x needs x > 0, and ln x = 0 at x = 1. Intersecting gives (0, 1) ∪ (1, 2]; the endpoint 2 is allowed since arcsin(1) and ln 2 are defined.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.12-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.12-a-v1', 'mcq', 'find the largest set of continuity for a quotient of inverse-trigonometric and logarithmic expressions by intersecting d (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the largest set of x-values on which g(x) = √(4 − x²)/ln(x + 2) is continuous?', null, md5('apcalcbc-mcq-b7-sv-h-1.12-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−2, −1) ∪ (−1, 2]', true, 'Correct: √(4 − x²) needs −2 ≤ x ≤ 2. ln(x + 2) needs x > −2 and equals 0 at x = −1. Intersecting gives (−2, −1) ∪ (−1, 2]; x = 2 gives 0/ln 4, which is defined.' from version_ins
union all select gen_random_uuid(), id, 'B', '[−2, −1) ∪ (−1, 2]', false, 'This keeps x = −2, but there ln(0) is undefined, so g is not defined at −2.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−2, −1) ∪ (−1, 2)', false, 'This drops x = 2, but there the numerator √0 = 0 is defined and ln 4 ≠ 0, so g is defined and continuous from the left at 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−2, 2]', false, 'This keeps x = −1, where ln 1 = 0 makes the denominator zero, so g is not defined at −1.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.12-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.12-a-v2', 'mcq', 'find the largest set of continuity for a quotient of inverse-trigonometric and logarithmic expressions by intersecting d (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the largest set of x-values on which h(x) = ln(9 − x²)/(eˣ − e) is continuous?', null, md5('apcalcbc-mcq-b7-sv-h-1.12-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−3, 3)', false, 'This ignores the denominator, but eˣ − e = 0 at x = 1, where h is not defined.' from version_ins
union all select gen_random_uuid(), id, 'B', '[−3, 1) ∪ (1, 3]', false, 'This includes the endpoints ±3, but ln 0 is undefined, so the domain stops short of them.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−3, 0) ∪ (0, 3)', false, 'This removes x = 0 by treating e⁰ = e, but e⁰ = 1, so the denominator is nonzero at 0; the zero of eˣ − e is at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−3, 1) ∪ (1, 3)', true, 'Correct: ln(9 − x²) needs 9 − x² > 0, so −3 < x < 3. The denominator eˣ − e = 0 only at x = 1. So h is continuous on (−3, 1) ∪ (1, 3).' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.11-a-v2','apcalcbc-mcq-b7-sv-h-1.11-a-v3','apcalcbc-mcq-b7-h-1.11-b','apcalcbc-mcq-b7-sv-h-1.11-b-v1','apcalcbc-mcq-b7-sv-h-1.11-b-v2','apcalcbc-mcq-b7-sv-h-1.11-b-v3','apcalcbc-mcq-b7-h-1.12-a','apcalcbc-mcq-b7-sv-h-1.12-a-v1','apcalcbc-mcq-b7-sv-h-1.12-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b7-sv-h-1.11-a-v2','apcalcbc-mcq-b7-sv-h-1.11-a-v3','apcalcbc-mcq-b7-h-1.11-b','apcalcbc-mcq-b7-sv-h-1.11-b-v1','apcalcbc-mcq-b7-sv-h-1.11-b-v2','apcalcbc-mcq-b7-sv-h-1.11-b-v3','apcalcbc-mcq-b7-h-1.12-a','apcalcbc-mcq-b7-sv-h-1.12-a-v1','apcalcbc-mcq-b7-sv-h-1.12-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
