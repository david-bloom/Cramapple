begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.10-a-v1','apcalcbc-mcq-b7-sv-h-1.10-a-v2','apcalcbc-mcq-b7-sv-h-1.10-a-v3','apcalcbc-mcq-b7-h-1.10-b','apcalcbc-mcq-b7-sv-h-1.10-b-v1','apcalcbc-mcq-b7-sv-h-1.10-b-v2','apcalcbc-mcq-b7-sv-h-1.10-b-v3','apcalcbc-mcq-b7-h-1.11-a','apcalcbc-mcq-b7-sv-h-1.11-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b7-sv-h-1.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.10-a-v1', 'mcq', 'classify a discontinuity from one-sided limits of an inverse-trigonometric expression and reject an argument that confus (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = 1/(1 + e^(1/(x − 1))) for x ≠ 1, and let g(1) = 1/2. Which statement correctly describes g at x = 1?', null, md5('apcalcbc-mcq-b7-sv-h-1.10-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is a removable discontinuity, because g(1) = 1/2 lies halfway between the one-sided limits.', false, 'Removable requires lim g to exist; the one-sided limits are 1 and 0, so no two-sided limit exists, regardless of where g(1) is placed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is an infinite discontinuity, because the exponent 1/(x − 1) is unbounded near 1.', false, 'The exponent is unbounded, but g itself is squeezed between 0 and 1 near x = 1, so its one-sided limits are finite and the discontinuity is not infinite.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is a jump discontinuity, of size 1.', true, 'Correct: As x → 1+, the exponent → +∞, e^(…) → ∞, so g → 0. As x → 1−, the exponent → −∞, e^(…) → 0, so g → 1. Finite, unequal one-sided limits 1 and 0 give a jump of size 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is a jump discontinuity, of size 1/2.', false, 'The jump size is the difference of the one-sided limits, 1 − 0 = 1; the value 1/2 is only the defined value g(1).' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.10-a-v2', 'mcq', 'classify a discontinuity from one-sided limits of an inverse-trigonometric expression and reject an argument that confus (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = e^(1/(x + 1)) for x ≠ −1. Which statement correctly describes the discontinuity of h at x = −1?', null, md5('apcalcbc-mcq-b7-sv-h-1.10-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is removable, because lim(x→−1−) h(x) = 0 exists.', false, 'Removable needs the two-sided limit to exist, and the right-hand limit is infinite, so the limit does not exist even though the left-hand limit is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is a jump, because the one-sided limits 0 and ∞ are different.', false, 'A jump requires both one-sided limits to be finite numbers; here the right-hand one is +∞, which makes it an infinite discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is oscillating, because the exponent 1/(x + 1) changes sign at x = −1.', false, 'The exponent changes sign but the function does not oscillate; it tends monotonically to 0 on one side and grows without bound on the other.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is infinite, because lim(x→−1+) h(x) = +∞.', true, 'Correct: As x → −1−, the exponent → −∞ so h → 0. As x → −1+, the exponent → +∞ so h → +∞. One side is unbounded, so the discontinuity is infinite.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.10-a-v3', 'mcq', 'classify a discontinuity from one-sided limits of an inverse-trigonometric expression and reject an argument that confus (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = arctan(1/(x − 3)²) for x ≠ 3, and let g(3) = 0. Which statement correctly describes g at x = 3?', null, md5('apcalcbc-mcq-b7-sv-h-1.10-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is an infinite discontinuity, because 1/(x − 3)² is unbounded near 3.', false, 'The inside expression is unbounded, but arctan is bounded, so g stays below π/2 and approaches π/2 from both sides; the limit is finite, which rules out an infinite discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is a removable discontinuity, because lim(x→3) g(x) = π/2 exists but is not equal to g(3).', true, 'Correct: As x → 3 from either side, 1/(x − 3)² → +∞ and arctan → π/2. So lim g = π/2, while g(3) = 0 ≠ π/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is a jump of size π/2, the difference between g(3) = 0 and the value π/2 near 3.', false, 'Both one-sided limits equal π/2, so there is no jump between the left and right sides; the mismatch is only with the defined value g(3).' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is not a discontinuity, because g(3) = 0 is a finite number.', false, 'Continuity requires g(3) to equal the limit π/2, and being finite is not enough; since g(3) = 0 ≠ π/2, g is discontinuous.' from version_ins;
-- apcalcbc-mcq-b7-h-1.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.10-b', 'mcq', 'read a described graph, sort each special x-value into removable, jump, infinite, or continuous, and count correctly wit', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is described near six x-values. At x = −2, lim f(x) = 1 and f(−2) = 4. At x = 0, the left-hand limit is 2, the right-hand limit is −1, and f(0) = −1. At x = 1, f(x) → +∞ from both sides and f(1) is undefined. At x = 3, lim f(x) = 2 and f(3) = 2. At x = 4, lim f(x) = 5 and f(4) is undefined. At x = 5, the left-hand limit is −∞ and the right-hand limit is +∞. Which row correctly counts the discontinuities of f at these six x-values by type?', null, md5('apcalcbc-mcq-b7-h-1.10-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3 removable, 1 jump, 2 infinite', false, 'This counts x = 3 as removable, but there lim f = 2 = f(3), so f is continuous at 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '2 removable, 1 jump, 2 infinite', true, 'Correct: x = −2 and x = 4 are removable (the limit exists but is not f''s value or f is undefined). x = 0 is a jump (2 versus −1). x = 1 and x = 5 are infinite. x = 3 is continuous because lim = f(3) = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 removable, 2 jump, 1 infinite', false, 'This calls x = 5 a jump, but a jump needs both one-sided limits to be finite; here they are −∞ and +∞, so it is infinite.' from version_ins
union all select gen_random_uuid(), id, 'D', '1 removable, 2 jump, 2 infinite', false, 'This calls x = −2 a jump, but a jump requires different one-sided limits; at −2 the limit exists (equal to 1), so the discontinuity is removable even though f(−2) = 4.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.10-b-v1', 'mcq', 'read a described graph, sort each special x-value into removable, jump, infinite, or continuous, and count correctly wit (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is described near seven x-values. At x = −3, lim f(x) = 0 and f(−3) = 0. At x = −1, lim f(x) = 4 and f(−1) = 1. At x = 2, the left-hand limit is −1, the right-hand limit is 3, and f(2) = 3. At x = 3, f(x) → +∞ from both sides. At x = 5, lim f(x) = 2 and f(5) is undefined. At x = 6, the left-hand limit is −∞ and the right-hand limit is 7. At x = 7, the left-hand limit is 1, the right-hand limit is 4, and f(7) = 4. Which row correctly counts the discontinuities of f at these seven x-values by type?', null, md5('apcalcbc-mcq-b7-sv-h-1.10-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 removable, 3 jump, 1 infinite', false, 'This calls x = 6 a jump because the one-sided limits differ, but a jump needs both finite; the left-hand limit is −∞, so it is infinite.' from version_ins
union all select gen_random_uuid(), id, 'B', '3 removable, 2 jump, 2 infinite', false, 'This counts x = −3 as removable, but there lim f = f(−3) = 0, so f is continuous at −3.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 removable, 2 jump, 2 infinite', true, 'Correct: Removable: x = −1 and x = 5. Jump: x = 2 and x = 7. Infinite: x = 3 and x = 6 (one infinite one-sided limit suffices). x = −3 is continuous.' from version_ins
union all select gen_random_uuid(), id, 'D', '1 removable, 3 jump, 2 infinite', false, 'This calls x = −1 a jump because f(−1) differs from the limit, but the limit 4 exists, so the discontinuity is removable.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.10-b-v2', 'mcq', 'read a described graph, sort each special x-value into removable, jump, infinite, or continuous, and count correctly wit (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is described near five x-values. At x = −1, the left-hand limit is 3, the right-hand limit is −2, and f(−1) = −2. At x = 1, lim f(x) = 1 and f(1) = 4. At x = 2, the left-hand limit is 0, the right-hand limit is 6, and f(2) = 6. At x = 4, the left-hand limit is 1, the right-hand limit is −3, and f(4) = −3. At x = 5, lim f(x) = 2 and f(5) = 2. What is the sum of the sizes of the jumps of f at the x-values where f has a jump discontinuity?', null, md5('apcalcbc-mcq-b7-sv-h-1.10-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18', false, 'This adds the gap |4 − 1| = 3 at x = 1, but that point is a removable discontinuity with equal one-sided limits, so it contributes no jump.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3', false, 'This adds signed changes, (−2 − 3) + (6 − 0) + (−3 − 1) = −3, but sizes of jumps are absolute differences so downward jumps must be counted as positive.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'This counts only the one upward jump at x = 2 and ignores the two downward jumps at x = −1 and x = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '15', true, 'Correct: Jumps at x = −1 (|−2 − 3| = 5), x = 2 (6 − 0 = 6), x = 4 (|−3 − 1| = 4). Total 5 + 6 + 4 = 15. x = 1 is removable (not a jump) and x = 5 is continuous.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.10-b-v3', 'mcq', 'read a described graph, sort each special x-value into removable, jump, infinite, or continuous, and count correctly wit (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x² − x − 2)/(x² − 2x). Which statement correctly describes the discontinuities of f?', null, md5('apcalcbc-mcq-b7-sv-h-1.10-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An infinite discontinuity at x = 0 and a removable discontinuity at x = 2.', true, 'Correct: f(x) = (x − 2)(x + 1)/(x(x − 2)) = (x + 1)/x for x ≠ 0, 2. At x = 2 the limit is 3/2, finite. Near 0, (x + 1)/x → −∞ from the left and +∞ from the right.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A jump at x = 0 and a removable discontinuity at x = 2.', false, 'The one-sided behavior at 0 has opposite signs, but the one-sided limits are −∞ and +∞, not finite numbers, so it is an infinite discontinuity rather than a jump.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Infinite discontinuities at both x = 0 and x = 2.', false, 'At x = 2 both numerator and denominator vanish, and the factor x − 2 cancels, leaving a finite limit 3/2; the denominator being zero does not by itself make it infinite.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A removable discontinuity at x = 0 and an infinite discontinuity at x = 2.', false, 'This swaps the two points; at x = 0 only the denominator vanishes (the numerator 0 − 0 − 2 = −2 is nonzero) so it is infinite there, and at x = 2 the common factor x − 2 cancels so it is removable.' from version_ins;
-- apcalcbc-mcq-b7-h-1.11-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.11-a', 'mcq', 'apply the three-part definition of continuity to a piecewise function with exponential and logarithmic pieces, evaluatin', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be defined by f(x) = ax + b for x < 2, f(2) = 5, and f(x) = a·e^(x − 2) + b·ln(x − 1) for x > 2. If f is continuous at x = 2, what is the value of b?', null, md5('apcalcbc-mcq-b7-h-1.11-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−5', true, 'Correct: Right limit: a·e⁰ + b·ln 1 = a. Left limit: 2a + b. Continuity needs 2a + b = a = 5, so a = 5 and b = 5 − 10 = −5.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This evaluates the left piece at x = 1 instead of x = 2, writing a + b = 5, which with a = 5 gives b = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This takes ln(1) = 1, so the right limit is a + b = 5, which together with 2a + b = 5 gives a = 0 and b = 5; but ln 1 = 0, so the b term vanishes on the right.' from version_ins
union all select gen_random_uuid(), id, 'D', '−10', false, 'This drops f(2) = 5 from the left-hand equation, writing 2a + b = 0 with a = 5, which gives b = −10.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.11-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.11-a-v1', 'mcq', 'apply the three-part definition of continuity to a piecewise function with exponential and logarithmic pieces, evaluatin (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g be defined by g(x) = ax² + b for x < 1, g(1) = 6, and g(x) = 2a·e^(x − 1) + b·ln x for x > 1. If g is continuous at x = 1, what is the value of b?', null, md5('apcalcbc-mcq-b7-sv-h-1.11-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', false, 'This takes ln 1 = 1, so the right limit is 2a + b = 6; with a + b = 6 this gives a = 0 and b = 6, but ln 1 = 0 removes the b term on the right.' from version_ins
union all select gen_random_uuid(), id, 'B', '9', false, 'This writes b = 6 + a with a = 3, adding instead of subtracting when solving a + b = 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', true, 'Correct: Right limit: 2a·e⁰ + b·ln 1 = 2a = 6, so a = 3. Left limit: a + b = 6, so b = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3', false, 'This writes b = a − 6 = −3, a sign slip when solving a + b = 6 for b.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.10-a-v1','apcalcbc-mcq-b7-sv-h-1.10-a-v2','apcalcbc-mcq-b7-sv-h-1.10-a-v3','apcalcbc-mcq-b7-h-1.10-b','apcalcbc-mcq-b7-sv-h-1.10-b-v1','apcalcbc-mcq-b7-sv-h-1.10-b-v2','apcalcbc-mcq-b7-sv-h-1.10-b-v3','apcalcbc-mcq-b7-h-1.11-a','apcalcbc-mcq-b7-sv-h-1.11-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b7-sv-h-1.10-a-v1','apcalcbc-mcq-b7-sv-h-1.10-a-v2','apcalcbc-mcq-b7-sv-h-1.10-a-v3','apcalcbc-mcq-b7-h-1.10-b','apcalcbc-mcq-b7-sv-h-1.10-b-v1','apcalcbc-mcq-b7-sv-h-1.10-b-v2','apcalcbc-mcq-b7-sv-h-1.10-b-v3','apcalcbc-mcq-b7-h-1.11-a','apcalcbc-mcq-b7-sv-h-1.11-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
