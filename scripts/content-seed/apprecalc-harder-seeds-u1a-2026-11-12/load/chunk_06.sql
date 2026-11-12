begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-sv-h-1.6-b-v1','apprecalc-mcq-b10-sv-h-1.6-b-v2','apprecalc-mcq-b10-sv-h-1.6-b-v3','apprecalc-mcq-b10-h-1.7-a','apprecalc-mcq-b10-sv-h-1.7-a-v1','apprecalc-mcq-b10-sv-h-1.7-a-v2','apprecalc-mcq-b10-sv-h-1.7-a-v3','apprecalc-mcq-b10-h-1.7-b','apprecalc-mcq-b10-sv-h-1.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apprecalc-mcq-b10-sv-h-1.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.6-b-v1', 'mcq', 'build a sign chart from end behavior and zero multiplicities, changing sign only at odd-multiplicity zeros. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial q has the form q(x) = a(x + 2)²x(x − 5) for some nonzero constant a, with zeros −2 with multiplicity 2, 0 with multiplicity 1, and 5 with multiplicity 1. Also q(x) → ∞ as x → ∞. On which set of x-values is q(x) > 0?', null, md5('apprecalc-mcq-b10-sv-h-1.6-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−∞, −2) ∪ (−2, 0) ∪ (5, ∞)', true, 'Correct: Since a polynomial''s ends follow the leading term, the sign on the far right is positive. Moving left, the sign changes only at zeros of odd multiplicity. This gives p(x) > 0 on (−∞, −2) ∪ (−2, 0) ∪ (5, ∞).' from version_ins
union all select gen_random_uuid(), id, 'B', '(0, 5)', false, 'This takes the sign to be negative on the far right, reversing the end behavior. Because p(x) → ∞ as x → ∞, a is positive, and the intervals found here are where p is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−2, 0) ∪ (5, ∞)', false, 'This changes sign at every zero. A zero of even multiplicity only touches the x-axis, so p does not change sign there; only the zeros of odd multiplicity are sign changes.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−∞, −2) ∪ (0, 5)', false, 'This makes two errors. It reverses the sign on the far right and also changes sign at every zero, so it lists the intervals where p would be negative if every zero were a crossing.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.6-b-v2', 'mcq', 'build a sign chart from end behavior and zero multiplicities, changing sign only at odd-multiplicity zeros. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial r has the form r(x) = a(x + 5)(x + 1)³(x − 2)² for some nonzero constant a, with zeros −5 with multiplicity 1, −1 with multiplicity 3, and 2 with multiplicity 2. It is known that r(x) → −∞ as x → ∞. On which set of x-values is r(x) > 0?', null, md5('apprecalc-mcq-b10-sv-h-1.6-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−5, −1)', true, 'Correct: Since a polynomial''s ends follow the leading term, the sign on the far right is negative. Moving left, the sign changes only at zeros of odd multiplicity. This gives p(x) > 0 on (−5, −1).' from version_ins
union all select gen_random_uuid(), id, 'B', '(−∞, −5) ∪ (−1, 2) ∪ (2, ∞)', false, 'This takes the sign to be negative on the far right, reversing the end behavior. Because p(x) → −∞ as x → ∞, a is negative, and the intervals found here are where p is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−∞, −5) ∪ (−1, 2)', false, 'This changes sign at every zero. A zero of even multiplicity only touches the x-axis, so p does not change sign there; only the zeros of odd multiplicity are sign changes.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−5, −1) ∪ (2, ∞)', false, 'This makes two errors. It reverses the sign on the far right and also changes sign at every zero, so it lists the intervals where p would be negative if every zero were a crossing.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.6-b-v3', 'mcq', 'build a sign chart from end behavior and zero multiplicities, changing sign only at odd-multiplicity zeros. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial w has the form w(x) = a(x + 4)²(x − 1)(x − 3)²(x − 6) for some nonzero constant a, with zeros −4 with multiplicity 2, 1 with multiplicity 1, 3 with multiplicity 2, and 6 with multiplicity 1. It is known that w(x) → ∞ as x → ∞. On which set of x-values is w(x) > 0?', null, md5('apprecalc-mcq-b10-sv-h-1.6-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−∞, −4) ∪ (−4, 1) ∪ (6, ∞)', true, 'Correct: Since a polynomial''s ends follow the leading term, the sign on the far right is positive. Moving left, the sign changes only at zeros of odd multiplicity. This gives p(x) > 0 on (−∞, −4) ∪ (−4, 1) ∪ (6, ∞).' from version_ins
union all select gen_random_uuid(), id, 'B', '(1, 3) ∪ (3, 6)', false, 'This takes the sign to be negative on the far right, reversing the end behavior. Because p(x) → ∞ as x → ∞, a is positive, and the intervals found here are where p is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−∞, −4) ∪ (1, 3) ∪ (6, ∞)', false, 'This changes sign at every zero. A zero of even multiplicity only touches the x-axis, so p does not change sign there; only the zeros of odd multiplicity are sign changes.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−4, 1) ∪ (3, 6)', false, 'This makes two errors. It reverses the sign on the far right and also changes sign at every zero, so it lists the intervals where p would be negative if every zero were a crossing.' from version_ins;
-- apprecalc-mcq-b10-h-1.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.7-a', 'mcq', 'find the horizontal asymptote of an unexpanded rational function with equal degrees by multiplying the leading coefficie', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The rational function R is given by R(x) = 3(2x − 1)²(x + 3) / ((x² + 5)(−4x + 1)). Which equation gives the horizontal asymptote of the graph of R?', null, md5('apprecalc-mcq-b10-h-1.7-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = −1.5', false, 'This forgets to square the leading coefficient 2 of the squared factor. The leading coefficient of the numerator is 3·2²·1 = 12, not 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = −3', true, 'Correct: Both numerator and denominator have degree 3. The numerator''s leading coefficient is 3·2²·1 = 12 and the denominator''s is −4, so the horizontal asymptote is y = −3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 3', false, 'This has the right size but the wrong sign. The leading coefficient of the numerator is 12 and of the denominator is −4, so their quotient is −3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −1/3', false, 'This inverts the ratio, putting the denominator''s leading coefficient over the numerator''s. The horizontal asymptote is numerator over denominator, 12 / −4.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.7-a-v1', 'mcq', 'find the horizontal asymptote of an unexpanded rational function with equal degrees by multiplying the leading coefficie (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The rational function S is given by S(x) = −2(3x + 1)²(x − 4) / ((x² + 2)(2x − 5)). Which equation gives the horizontal asymptote of the graph of S?', null, md5('apprecalc-mcq-b10-sv-h-1.7-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = −9', true, 'Correct: Both numerator and denominator have degree 3. The numerator''s leading coefficient is -2·3²·1 = −18 and the denominator''s is 2, so the horizontal asymptote is y = −9.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = −3', false, 'This forgets to square the leading coefficient 3 of the squared factor. The leading coefficient of the numerator is -2·3²·1 = -18, not -6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 9', false, 'This has the right size but the wrong sign. The leading coefficient of the numerator is −18 and of the denominator is 2, so their quotient is −9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −1/9', false, 'This inverts the ratio, putting the denominator''s leading coefficient over the numerator''s. The horizontal asymptote is numerator over denominator, −18 / 2.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.7-a-v2', 'mcq', 'find the horizontal asymptote of an unexpanded rational function with equal degrees by multiplying the leading coefficie (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The rational function T is given by T(x) = 5(2x + 3)²(3x − 1) / ((x² + 1)(−3x + 2)). Which equation gives the horizontal asymptote of the graph of T?', null, md5('apprecalc-mcq-b10-sv-h-1.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = −10', false, 'This forgets to square the leading coefficient 2 of the squared factor. The leading coefficient of the numerator is 5·2²·3 = 60, not 30.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 20', false, 'This has the right size but the wrong sign. The leading coefficient of the numerator is 60 and of the denominator is −3, so their quotient is −20.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = −20', true, 'Correct: Both numerator and denominator have degree 3. The numerator''s leading coefficient is 5·2²·3 = 60 and the denominator''s is −3, so the horizontal asymptote is y = −20.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −0.05', false, 'This inverts the ratio, putting the denominator''s leading coefficient over the numerator''s. The horizontal asymptote is numerator over denominator, 60 / −3.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.7-a-v3', 'mcq', 'find the horizontal asymptote of an unexpanded rational function with equal degrees by multiplying the leading coefficie (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The rational function U is given by U(x) = −3(−2x + 1)²(x + 5) / ((x² + 4)(6x − 1)). Which equation gives the horizontal asymptote of the graph of U?', null, md5('apprecalc-mcq-b10-sv-h-1.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = −2', true, 'Correct: Both numerator and denominator have degree 3. The numerator''s leading coefficient is -3·-2²·1 = −12 and the denominator''s is 6, so the horizontal asymptote is y = −2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 1', false, 'This forgets to square the leading coefficient -2 of the squared factor. The leading coefficient of the numerator is -3·-2²·1 = -12, not 6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 2', false, 'This has the right size but the wrong sign. The leading coefficient of the numerator is −12 and of the denominator is 6, so their quotient is −2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −0.5', false, 'This inverts the ratio, putting the denominator''s leading coefficient over the numerator''s. The horizontal asymptote is numerator over denominator, −12 / 6.' from version_ins;
-- apprecalc-mcq-b10-h-1.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.7-b', 'mcq', 'describe the side of the horizontal asymptote y = 0 that a rational function approaches at each end by tracking the sign', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let R(x) = (5 − 2x²) / (x³ + 7x). Which statement describes the end behavior of R?', null, md5('apprecalc-mcq-b10-h-1.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R(x) approaches 0 from above as x → ∞ and from above as x → −∞', false, 'This gets the right end wrong. For a large positive input such as x = 1000 the value of R is about −0.002, which is negative, so the graph is below the x-axis there.' from version_ins
union all select gen_random_uuid(), id, 'B', 'R(x) approaches 0 from above as x → ∞ and from below as x → −∞', false, 'This reverses the side on both ends. At x = 1000 the value is about −0.002 and at x = −1000 it is about 0.002, which puts the graph below the axis on the right and above it on the left.' from version_ins
union all select gen_random_uuid(), id, 'C', 'R(x) approaches 0 from below as x → ∞ and from above as x → −∞', true, 'Correct: The denominator has the greater degree, so R(x) → 0. The sign of R for large |x| is the sign of the ratio of leading terms, which gives about −0.002 at x = 1000 and 0.002 at x = −1000, so the graph lies below the x-axis on the right and above it on the left.' from version_ins
union all select gen_random_uuid(), id, 'D', 'R(x) approaches 0 from below as x → ∞ and from below as x → −∞', false, 'This gets the left end wrong. For a large negative input such as x = −1000 the value of R is about 0.002, which is positive, so the graph is above the x-axis there.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.7-b-v1', 'mcq', 'describe the side of the horizontal asymptote y = 0 that a rational function approaches at each end by tracking the sign (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let R(x) = (3x + 1) / (x³ − 4x). Which statement describes the end behavior of R?', null, md5('apprecalc-mcq-b10-sv-h-1.7-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R(x) approaches 0 from above as x → ∞ and from below as x → −∞', false, 'This gets the left end wrong. For a large negative input such as x = −1000 the value of R is about 2.999e−06, which is positive, so the graph is above the x-axis there.' from version_ins
union all select gen_random_uuid(), id, 'B', 'R(x) approaches 0 from below as x → ∞ and from above as x → −∞', false, 'This gets the right end wrong. For a large positive input such as x = 1000 the value of R is about 3.001e−06, which is positive, so the graph is above the x-axis there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'R(x) approaches 0 from below as x → ∞ and from below as x → −∞', false, 'This reverses the side on both ends. At x = 1000 the value is about 3.001e−06 and at x = −1000 it is about 2.999e−06, which puts the graph above the axis on the right and above it on the left.' from version_ins
union all select gen_random_uuid(), id, 'D', 'R(x) approaches 0 from above as x → ∞ and from above as x → −∞', true, 'Correct: The denominator has the greater degree, so R(x) → 0. The sign of R for large |x| is the sign of the ratio of leading terms, which gives about 3.001e−06 at x = 1000 and 2.999e−06 at x = −1000, so the graph lies above the x-axis on the right and above it on the left.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-sv-h-1.6-b-v1','apprecalc-mcq-b10-sv-h-1.6-b-v2','apprecalc-mcq-b10-sv-h-1.6-b-v3','apprecalc-mcq-b10-h-1.7-a','apprecalc-mcq-b10-sv-h-1.7-a-v1','apprecalc-mcq-b10-sv-h-1.7-a-v2','apprecalc-mcq-b10-sv-h-1.7-a-v3','apprecalc-mcq-b10-h-1.7-b','apprecalc-mcq-b10-sv-h-1.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b10-sv-h-1.6-b-v1','apprecalc-mcq-b10-sv-h-1.6-b-v2','apprecalc-mcq-b10-sv-h-1.6-b-v3','apprecalc-mcq-b10-h-1.7-a','apprecalc-mcq-b10-sv-h-1.7-a-v1','apprecalc-mcq-b10-sv-h-1.7-a-v2','apprecalc-mcq-b10-sv-h-1.7-a-v3','apprecalc-mcq-b10-h-1.7-b','apprecalc-mcq-b10-sv-h-1.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
