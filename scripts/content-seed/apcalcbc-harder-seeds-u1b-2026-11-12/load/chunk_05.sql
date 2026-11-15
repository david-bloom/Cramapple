begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-h-1.13-b','apcalcbc-mcq-b7-sv-h-1.13-b-v1','apcalcbc-mcq-b7-sv-h-1.13-b-v2','apcalcbc-mcq-b7-sv-h-1.13-b-v3','apcalcbc-mcq-b7-h-1.14-a','apcalcbc-mcq-b7-sv-h-1.14-a-v1','apcalcbc-mcq-b7-sv-h-1.14-a-v2','apcalcbc-mcq-b7-sv-h-1.14-a-v3','apcalcbc-mcq-b7-h-1.14-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b7-h-1.13-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.13-b', 'mcq', 'first find the constant that makes a radical quotient a 0/0 form, then rationalize and find the value that removes the d', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = (√(x + a) − 2)/(x − 3) for x ≠ 3, where a is a constant. The limit of g as x approaches 3 is a finite number, and g(3) is defined so that g is continuous at x = 3. What is g(3)?', null, md5('apcalcbc-mcq-b7-h-1.13-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4', true, 'Correct: A finite limit needs the numerator to vanish at 3: √(3 + a) = 2, so a = 1. Then (√(x + 1) − 2)/(x − 3) = 1/(√(x + 1) + 2) → 1/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/2', false, 'This rationalizes correctly but then drops the +2 in the denominator, using 1/√4 = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/8', false, 'This treats the derivative-like factor as 1/(2(√(x + 1) + 2)) with an extra factor 2 in the denominator, giving 1/8.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This inverts the simplified quotient, reporting √(x + 1) + 2 = 4 instead of its reciprocal 1/4.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.13-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.13-b-v1', 'mcq', 'first find the constant that makes a radical quotient a 0/0 form, then rationalize and find the value that removes the d (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = (√(2x + a) − 3)/(x − 4) for x ≠ 4, where a is a constant. The limit of g as x approaches 4 is a finite number, and g(4) is defined so that g is continuous at x = 4. What is g(4)?', null, md5('apcalcbc-mcq-b7-sv-h-1.13-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/3', true, 'Correct: Finite limit needs √(8 + a) = 3, so a = 1. Then (√(2x + 1) − 3)/(x − 4) = (2x − 8)/((x − 4)(√(2x + 1) + 3)) = 2/(√(2x + 1) + 3) → 2/6 = 1/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/6', false, 'This forgets the factor 2 that comes from 2x + 1 − 9 = 2(x − 4), giving 1/6.' from version_ins
union all select gen_random_uuid(), id, 'C', '2/3', false, 'This drops the +3 from the denominator after rationalizing, giving 2/√9 = 2/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'This inverts the simplified quotient, giving 6/2 = 3 instead of 2/6.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.13-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.13-b-v2', 'mcq', 'first find the constant that makes a radical quotient a 0/0 form, then rationalize and find the value that removes the d (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = (√(5x + a) − 4)/(x − 2) for x ≠ 2, where a is a constant. The limit of g as x approaches 2 is a finite number, and g(2) is defined so that g is continuous at x = 2. What is g(2)?', null, md5('apcalcbc-mcq-b7-sv-h-1.13-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/4', false, 'This drops the +4 from the denominator, using 5/√16 = 5/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/8', true, 'Correct: Finite limit needs √(10 + a) = 4, so a = 6. Then (√(5x + 6) − 4)/(x − 2) = 5/(√(5x + 6) + 4) → 5/8.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/8', false, 'This forgets the factor 5 that comes from 5x + 6 − 16 = 5(x − 2), giving 1/8.' from version_ins
union all select gen_random_uuid(), id, 'D', '8/5', false, 'This inverts the simplified quotient, giving 8/5 instead of 5/8.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.13-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.13-b-v3', 'mcq', 'first find the constant that makes a radical quotient a 0/0 form, then rationalize and find the value that removes the d (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = (3 − √(a − x))/(x + 1) for x ≠ −1, where a is a constant. The limit of g as x approaches −1 is a finite number, and g(−1) is defined so that g is continuous at x = −1. What is g(−1)?', null, md5('apcalcbc-mcq-b7-sv-h-1.13-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/3', false, 'This drops the √(8 − x) term from the denominator, using 1/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/6', true, 'Correct: Finite limit needs √(a + 1) = 3, so a = 8. Then (3 − √(8 − x))/(x + 1) = (9 − (8 − x))/((x + 1)(3 + √(8 − x))) = 1/(3 + √(8 − x)) → 1/6.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/6', false, 'This writes the numerator of the rationalized form as (8 − x) − 9 = −(x + 1), a sign error that makes the limit negative.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'This inverts the simplified quotient, reporting 3 + 3 = 6 instead of 1/6.' from version_ins;
-- apcalcbc-mcq-b7-h-1.14-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.14-a', 'mcq', 'locate vertical asymptotes of a quotient with a logarithm, rejecting a false asymptote at the edge of the domain, and de', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x + 2)/ln x. Which statement correctly describes the vertical asymptotes of the graph of f and the one-sided limits there?', null, md5('apcalcbc-mcq-b7-h-1.14-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There are vertical asymptotes at x = 0 and x = 1, with lim(x→1−) f(x) = −∞ and lim(x→1+) f(x) = +∞.', false, 'At x = 0 the denominator ln x tends to −∞, making f(x) tend to 0 rather than infinity, so x = 0 is not an asymptote.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is a vertical asymptote at x = 1 only, with f(x) → +∞ from both sides.', false, 'For x slightly less than 1, ln x is negative, so the quotient is negative and the left limit is −∞, not +∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a vertical asymptote at x = 0 only, because ln x is undefined at 0.', false, 'Ln x being undefined at 0 does not produce an infinite limit; f(x) approaches 0 as x → 0+, and the true vertical asymptote comes from the zero ln 1 = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is a vertical asymptote at x = 1 only, with lim(x→1−) f(x) = −∞ and lim(x→1+) f(x) = +∞.', true, 'Correct: ln x = 0 at x = 1 with numerator 3 > 0. For x < 1, ln x < 0 so f → −∞; for x > 1, ln x > 0 so f → +∞. As x → 0+, ln x → −∞ and f(x) → 2/(−∞) = 0, not infinity.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.14-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.14-a-v1', 'mcq', 'locate vertical asymptotes of a quotient with a logarithm, rejecting a false asymptote at the edge of the domain, and de (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x − 3)/(eˣ − e). Which statement correctly describes the vertical asymptotes of the graph of f and the one-sided limits there?', null, md5('apcalcbc-mcq-b7-sv-h-1.14-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is a vertical asymptote at x = 1 only, with lim(x→1−) f(x) = −∞ and lim(x→1+) f(x) = +∞.', false, 'This reverses both signs: for x < 1 the denominator eˣ − e is negative and the numerator is negative, so the quotient is positive and the left limit is +∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is a vertical asymptote at x = 1 only, with f(x) → −∞ from both sides.', false, 'This ignores that the denominator changes sign at x = 1; it is negative on the left and positive on the right, so the infinite limits have opposite signs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a vertical asymptote at x = 1 only, with lim(x→1−) f(x) = +∞ and lim(x→1+) f(x) = −∞.', true, 'Correct: eˣ − e = 0 at x = 1 and numerator 1 − 3 = −2 < 0. For x < 1, the denominator is negative, so f is (−)/(−) → +∞; for x > 1, the denominator is positive, so f → −∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is a vertical asymptote at x = 3 only, because the numerator is zero there.', false, 'A zero of the numerator makes f zero there (f(3) = 0), not infinite; the denominator, not the numerator, creates the asymptote.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.14-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.14-a-v2', 'mcq', 'locate vertical asymptotes of a quotient with a logarithm, rejecting a false asymptote at the edge of the domain, and de (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x² + 4)/ln(x²). How many vertical asymptotes does the graph of f have, and what is lim(x→−1+) f(x)?', null, md5('apcalcbc-mcq-b7-sv-h-1.14-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Three vertical asymptotes; lim(x→−1+) f(x) = −∞.', false, 'This counts x = 0 as an asymptote, but there f(x) tends to 0, not to infinity, so only x = −1 and x = 1 qualify.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Two vertical asymptotes; lim(x→−1+) f(x) = +∞.', false, 'For x just above −1 we have x² slightly less than 1, so ln(x²) is negative and the quotient is negative, giving −∞ rather than +∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Two vertical asymptotes; lim(x→−1+) f(x) = −∞.', true, 'Correct: ln(x²) = 0 at x = ±1; at x = 0, ln(x²) → −∞ so f → 4/(−∞) = 0 (no asymptote). For x slightly greater than −1, x² < 1, so ln(x²) < 0 and the numerator is about 5, so f → −∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Three vertical asymptotes; lim(x→−1+) f(x) = +∞.', false, 'Both errors combined: x = 0 is not an asymptote, and the sign near −1 from the right is negative.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.14-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.14-a-v3', 'mcq', 'locate vertical asymptotes of a quotient with a logarithm, rejecting a false asymptote at the edge of the domain, and de (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (2x + 1)/(π − 4·arctan x). Which statement gives all vertical asymptotes of the graph of f and the value of lim(x→1+) f(x)?', null, md5('apcalcbc-mcq-b7-sv-h-1.14-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The only vertical asymptote is x = 1, and lim(x→1+) f(x) = −∞.', true, 'Correct: π − 4 arctan x = 0 when arctan x = π/4, i.e., x = 1, and arctan is increasing so the denominator is positive for x < 1 and negative for x > 1. The numerator at x = 1 is 3 > 0, so lim(x→1+) f(x) = −∞ and lim(x→1−) f(x) = +∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is no vertical asymptote, because arctan x is bounded.', false, 'A bounded arctan does not prevent the denominator from being zero; π − 4 arctan x equals 0 at x = 1, creating an asymptote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The only vertical asymptote is x = 1, and lim(x→1+) f(x) = +∞.', false, 'For x slightly greater than 1, arctan x > π/4, so the denominator is negative and the quotient is negative, giving −∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The only vertical asymptote is x = π/4, and lim(x→1+) f(x) = −∞.', false, 'The value π/4 is where arctan x equals the critical level, but the asymptote is the x-value that produces it, namely x = tan(π/4) = 1.' from version_ins;
-- apcalcbc-mcq-b7-h-1.14-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.14-b', 'mcq', 'evaluate a difference of two unbounded terms by combining them first, deciding which term dominates instead of treating ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→2) [1/(x − 2)² − 1/(x − 2)⁴]?', null, md5('apcalcbc-mcq-b7-h-1.14-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This treats ∞ − ∞ as 0, but the two terms have different rates of growth, and the second term dominates.' from version_ins
union all select gen_random_uuid(), id, 'B', '+∞', false, 'This keeps the sign of the first term, but 1/(x − 2)⁴ grows faster than 1/(x − 2)² and is subtracted, so the difference is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This keeps only the numerator (x − 2)² − 1 → −1 and ignores the denominator (x − 2)⁴, which approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '−∞', true, 'Correct: Combine: [(x − 2)² − 1]/(x − 2)⁴. As x → 2 the numerator → −1 and the denominator → 0⁺, so the quotient → −∞.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-h-1.13-b','apcalcbc-mcq-b7-sv-h-1.13-b-v1','apcalcbc-mcq-b7-sv-h-1.13-b-v2','apcalcbc-mcq-b7-sv-h-1.13-b-v3','apcalcbc-mcq-b7-h-1.14-a','apcalcbc-mcq-b7-sv-h-1.14-a-v1','apcalcbc-mcq-b7-sv-h-1.14-a-v2','apcalcbc-mcq-b7-sv-h-1.14-a-v3','apcalcbc-mcq-b7-h-1.14-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b7-h-1.13-b','apcalcbc-mcq-b7-sv-h-1.13-b-v1','apcalcbc-mcq-b7-sv-h-1.13-b-v2','apcalcbc-mcq-b7-sv-h-1.13-b-v3','apcalcbc-mcq-b7-h-1.14-a','apcalcbc-mcq-b7-sv-h-1.14-a-v1','apcalcbc-mcq-b7-sv-h-1.14-a-v2','apcalcbc-mcq-b7-sv-h-1.14-a-v3','apcalcbc-mcq-b7-h-1.14-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
