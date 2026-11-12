begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-sv-h-1.9-a-v1','apprecalc-mcq-b9-sv-h-1.9-a-v2','apprecalc-mcq-b9-sv-h-1.9-a-v3','apprecalc-mcq-b9-h-1.9-b','apprecalc-mcq-b9-sv-h-1.9-b-v1','apprecalc-mcq-b9-sv-h-1.9-b-v2','apprecalc-mcq-b9-sv-h-1.9-b-v3','apprecalc-mcq-b9-h-1.10-a','apprecalc-mcq-b9-sv-h-1.10-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apprecalc-mcq-b9-sv-h-1.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.9-a-v1', 'mcq', 'describe the unbounded behavior of a rational function at a vertical asymptote from an even-multiplicity factor and at o (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider f(x) = (x + 4)/[(x − 2)²(x + 1)]. Which statement correctly describes the graph of f near its two vertical asymptotes?', null, md5('apprecalc-mcq-b9-sv-h-1.9-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) → −∞ as x → 2 from either side, and f(x) → ∞ as x → −1 from the right', false, 'This treats the squared factor as if it changed sign across x = 2, so the sign at that asymptote is reversed. A squared factor is positive on both sides, so the sign there is set by the remaining factors and f → ∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) → ∞ as x → 2 from either side, and f(x) → −∞ as x → −1 from the right', false, 'This gives the right behavior at x = 2 but takes the sign on the wrong side of x = −1. The factor (x + 1) is positive on the right, which makes f → ∞ there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) → ∞ as x → 2 from either side, and f(x) → ∞ as x → −1 from the right', true, 'Correct: Near x = 2: the squared factor is positive, and the other factors have the sign of (2 − (−4))/(2 − (−1)) = 6/3, which is positive, so f → ∞ from both sides. Near x = −1 from the right: numerator sign +, squared factor +, and (x + 1) is positive, so f → ∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) → −∞ as x → 2 from either side, and f(x) → −∞ as x → −1 from the right', false, 'This reverses the sign of f at both asymptotes, as if the numerator (x + 4) were evaluated with the wrong sign. At x = 2 the sign is positive and just right of x = −1 it is positive.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.9-a-v2', 'mcq', 'describe the unbounded behavior of a rational function at a vertical asymptote from an even-multiplicity factor and at o (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x − 5)/[(x − 1)²(x + 3)]. Which statement correctly describes the graph of f near its two vertical asymptotes?', null, md5('apprecalc-mcq-b9-sv-h-1.9-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) → ∞ as x → 1 from either side, and f(x) → ∞ as x → −3 from the left', false, 'This treats the squared factor as if it changed sign across x = 1, so the sign at that asymptote is reversed. A squared factor is positive on both sides, so the sign there is set by the remaining factors and f → −∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) → −∞ as x → 1 from either side, and f(x) → −∞ as x → −3 from the left', false, 'This gives the right behavior at x = 1 but takes the sign on the wrong side of x = −3. The factor (x + 3) is negative on the left, which makes f → ∞ there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) → ∞ as x → 1 from either side, and f(x) → −∞ as x → −3 from the left', false, 'This reverses the sign of f at both asymptotes, as if the numerator (x − 5) were evaluated with the wrong sign. At x = 1 the sign is negative and just left of x = −3 it is positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) → −∞ as x → 1 from either side, and f(x) → ∞ as x → −3 from the left', true, 'Correct: Near x = 1: the squared factor is positive, and the other factors have the sign of (1 − 5)/(1 − (−3)) = −4/4, which is negative, so f → −∞ from both sides. Near x = −3 from the left: numerator sign −, squared factor +, and (x + 3) is negative, so f → ∞.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.9-a-v3', 'mcq', 'describe the unbounded behavior of a rational function at a vertical asymptote from an even-multiplicity factor and at o (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the rational function f(x) = (x + 2)/[(x − 4)²(x − 1)]. Which statement correctly describes the graph of f near its two vertical asymptotes?', null, md5('apprecalc-mcq-b9-sv-h-1.9-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) → ∞ as x → 4 from either side, and f(x) → ∞ as x → 1 from the right', true, 'Correct: Near x = 4: the squared factor is positive, and the other factors have the sign of (4 − (−2))/(4 − 1) = 6/3, which is positive, so f → ∞ from both sides. Near x = 1 from the right: numerator sign +, squared factor +, and (x − 1) is positive, so f → ∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) → −∞ as x → 4 from either side, and f(x) → ∞ as x → 1 from the right', false, 'This treats the squared factor as if it changed sign across x = 4, so the sign at that asymptote is reversed. A squared factor is positive on both sides, so the sign there is set by the remaining factors and f → ∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) → ∞ as x → 4 from either side, and f(x) → −∞ as x → 1 from the right', false, 'This gives the right behavior at x = 4 but takes the sign on the wrong side of x = 1. The factor (x − 1) is positive on the right, which makes f → ∞ there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) → −∞ as x → 4 from either side, and f(x) → −∞ as x → 1 from the right', false, 'This reverses the sign of f at both asymptotes, as if the numerator (x + 2) were evaluated with the wrong sign. At x = 4 the sign is positive and just right of x = 1 it is positive.' from version_ins;
-- apprecalc-mcq-b9-h-1.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.9-b', 'mcq', 'determine the parameter values that make a vertical asymptote disappear (become a hole) so the graph has exactly one asy', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a real constant k, let f(x) = (x² + kx − 12)/(x² − x − 6). What is the sum of all values of k for which the graph of f has exactly one vertical asymptote?', null, md5('apprecalc-mcq-b9-h-1.9-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3', true, 'Correct: The denominator is (x − 3)(x + 2). Exactly one asymptote needs the numerator to vanish at x = 3 (k = 1) or at x = −2 (k = −4), but the numerator cannot vanish at both. The sum is −3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−4', false, 'This multiplies the two valid values 1 and −4 instead of adding them. The question asks for their sum, which is −3.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', false, 'This finds only one of the two values of k, the larger one, 1. Cancelling the factor at x = 3 and cancelling the factor at x = −2 each give a different valid k, and both must be included.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'This finds both values of k but then reports the opposite of their sum. Requiring the numerator to be zero at x = 3 and x = −2 gives k = 1 and k = −4, whose sum is −3.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.9-b-v1', 'mcq', 'determine the parameter values that make a vertical asymptote disappear (become a hole) so the graph has exactly one asy (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a real constant k, let f(x) = (x² + kx + 6)/(x² + 4x − 12). What is the sum of all values of k for which the graph of f has exactly one vertical asymptote?', null, md5('apprecalc-mcq-b9-sv-h-1.9-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−35', false, 'This multiplies the two valid values −5 and 7 instead of adding them. The question asks for their sum, which is 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', true, 'Correct: The denominator is (x − 2)(x + 6). Exactly one asymptote needs the numerator to vanish at x = 2 (k = −5) or at x = −6 (k = 7), but the numerator cannot vanish at both. The sum is 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', false, 'This finds only one of the two values of k, the larger one, 7. Cancelling the factor at x = 2 and cancelling the factor at x = −6 each give a different valid k, and both must be included.' from version_ins
union all select gen_random_uuid(), id, 'D', '−2', false, 'This finds both values of k but then reports the opposite of their sum. Requiring the numerator to be zero at x = 2 and x = −6 gives k = −5 and k = 7, whose sum is 2.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.9-b-v2', 'mcq', 'determine the parameter values that make a vertical asymptote disappear (become a hole) so the graph has exactly one asy (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a real constant k, let f(x) = (x² + kx − 40)/(x² + 4x − 32). What is the sum of all values of k for which the graph of f has exactly one vertical asymptote?', null, md5('apprecalc-mcq-b9-sv-h-1.9-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18', false, 'This multiplies the two valid values 6 and 3 instead of adding them. The question asks for their sum, which is 9.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This finds only one of the two values of k, the larger one, 6. Cancelling the factor at x = 4 and cancelling the factor at x = −8 each give a different valid k, and both must be included.' from version_ins
union all select gen_random_uuid(), id, 'C', '−9', false, 'This finds both values of k but then reports the opposite of their sum. Requiring the numerator to be zero at x = 4 and x = −8 gives k = 6 and k = 3, whose sum is 9.' from version_ins
union all select gen_random_uuid(), id, 'D', '9', true, 'Correct: The denominator is (x − 4)(x + 8). Exactly one asymptote needs the numerator to vanish at x = 4 (k = 6) or at x = −8 (k = 3), but the numerator cannot vanish at both. The sum is 9.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.9-b-v3', 'mcq', 'determine the parameter values that make a vertical asymptote disappear (become a hole) so the graph has exactly one asy (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a real constant k, let f(x) = (x² + kx − 24)/(x² − 3x − 18). What is the sum of all values of k for which the graph of f has exactly one vertical asymptote?', null, md5('apprecalc-mcq-b9-sv-h-1.9-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10', false, 'This multiplies the two valid values −2 and −5 instead of adding them. The question asks for their sum, which is −7.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2', false, 'This finds only one of the two values of k, the larger one, −2. Cancelling the factor at x = 6 and cancelling the factor at x = −3 each give a different valid k, and both must be included.' from version_ins
union all select gen_random_uuid(), id, 'C', '−7', true, 'Correct: The denominator is (x − 6)(x + 3). Exactly one asymptote needs the numerator to vanish at x = 6 (k = −2) or at x = −3 (k = −5), but the numerator cannot vanish at both. The sum is −7.' from version_ins
union all select gen_random_uuid(), id, 'D', '7', false, 'This finds both values of k but then reports the opposite of their sum. Requiring the numerator to be zero at x = 6 and x = −3 gives k = −2 and k = −5, whose sum is −7.' from version_ins;
-- apprecalc-mcq-b9-h-1.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.10-a', 'mcq', 'locate the hole of a rational function given in expanded form by factoring, cancelling the common factor, and finding th', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x² − 2x − 15)/(x² − 4x − 5). Which ordered pair is the location of the hole in the graph of f?', null, md5('apprecalc-mcq-b9-h-1.10-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(5, 4/3)', true, 'Correct: Factoring gives f(x) = (x − 5)(x + 3)/[(x − 5)(x + 1)], so the common factor (x − 5) produces a hole at x = 5. The reduced function (x + 3)/(x + 1) at x = 5 equals 4/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '(5, 0)', false, 'This notices the hole at x = 5 but reads its height as 0 because the numerator factor is zero there. After cancelling, the remaining numerator (x + 3) is not zero at x = 5; the height is 4/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(5, 3/4)', false, 'This evaluates the reduced function upside down, using (5 − (−1))/(5 − (−3)). The numerator of the reduced function is (x + 3) and the denominator is (x + 1), so the height is 4/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−1, 4/3)', false, 'This puts the hole at the zero of the leftover denominator factor, x = −1. That factor is not cancelled, so x = −1 is a vertical asymptote; the hole is where the common factor (x − 5) is zero, at x = 5.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.10-a-v1', 'mcq', 'locate the hole of a rational function given in expanded form by factoring, cancelling the common factor, and finding th (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider f(x) = (x² − 8x + 12)/(x² + 2x − 8). Which ordered pair is the location of the hole in the graph of f?', null, md5('apprecalc-mcq-b9-sv-h-1.10-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(2, 0)', false, 'This notices the hole at x = 2 but reads its height as 0 because the numerator factor is zero there. After cancelling, the remaining numerator (x − 6) is not zero at x = 2; the height is −2/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '(2, −3/2)', false, 'This evaluates the reduced function upside down, using (2 − (−4))/(2 − 6). The numerator of the reduced function is (x − 6) and the denominator is (x + 4), so the height is −2/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(2, −2/3)', true, 'Correct: Factoring gives f(x) = (x − 2)(x − 6)/[(x − 2)(x + 4)], so the common factor (x − 2) produces a hole at x = 2. The reduced function (x − 6)/(x + 4) at x = 2 equals −2/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−4, −2/3)', false, 'This puts the hole at the zero of the leftover denominator factor, x = −4. That factor is not cancelled, so x = −4 is a vertical asymptote; the hole is where the common factor (x − 2) is zero, at x = 2.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-sv-h-1.9-a-v1','apprecalc-mcq-b9-sv-h-1.9-a-v2','apprecalc-mcq-b9-sv-h-1.9-a-v3','apprecalc-mcq-b9-h-1.9-b','apprecalc-mcq-b9-sv-h-1.9-b-v1','apprecalc-mcq-b9-sv-h-1.9-b-v2','apprecalc-mcq-b9-sv-h-1.9-b-v3','apprecalc-mcq-b9-h-1.10-a','apprecalc-mcq-b9-sv-h-1.10-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b9-sv-h-1.9-a-v1','apprecalc-mcq-b9-sv-h-1.9-a-v2','apprecalc-mcq-b9-sv-h-1.9-a-v3','apprecalc-mcq-b9-h-1.9-b','apprecalc-mcq-b9-sv-h-1.9-b-v1','apprecalc-mcq-b9-sv-h-1.9-b-v2','apprecalc-mcq-b9-sv-h-1.9-b-v3','apprecalc-mcq-b9-h-1.10-a','apprecalc-mcq-b9-sv-h-1.10-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
