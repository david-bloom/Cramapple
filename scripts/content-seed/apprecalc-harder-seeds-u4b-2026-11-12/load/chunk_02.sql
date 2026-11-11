begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4b-sv-h-4.10-a-v1','apprecalc-mcq-b4b-sv-h-4.10-a-v2','apprecalc-mcq-b4b-sv-h-4.10-a-v3','apprecalc-mcq-b4b-h-4.11-a','apprecalc-mcq-b4b-sv-h-4.11-a-v1','apprecalc-mcq-b4b-sv-h-4.11-a-v2','apprecalc-mcq-b4b-sv-h-4.11-a-v3','apprecalc-mcq-b4b-h-4.12-a','apprecalc-mcq-b4b-sv-h-4.12-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apprecalc-mcq-b4b-sv-h-4.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.10-a-v1', 'mcq', '4.10-A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A café tracks hours worked with a matrix S whose rows are 3 employees and whose columns are 2 shifts, so S = [4 6; 5 2; 0 9]. The pay matrix P = [7; 3] gives the hourly wage in dollars for each shift. Which statement about computing each employee''s total pay is correct?', null, md5('apprecalc-mcq-b4b-sv-h-4.10-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'PS is defined and gives the same totals, because matrix products can be taken in either order.', false, 'P is 2×1 and S is 3×2, so in PS the inner dimensions are 1 and 3, which do not match; PS is undefined, and products are not commutative anyway.' from version_ins
union all select gen_random_uuid(), id, 'B', 'SP is defined, is 2×1, and gives one total for each of the 2 columns of S.', false, 'The product of an 3×2 matrix and a 2×1 matrix has 3 rows and 1 column, so it has one entry for each row of S and not for each column.' from version_ins
union all select gen_random_uuid(), id, 'C', 'SP is defined, is 3×1, and equals [46; 41; 27], with one entry for each of the 3 rows of S.', true, 'Correct: S is 3×2 and P is 2×1, so SP is defined and 3×1: row 1: 4·7 + 6·3 = 46. row 2: 5·7 + 2·3 = 41. row 3: 0·7 + 9·3 = 27.' from version_ins
union all select gen_random_uuid(), id, 'D', 'SP is undefined, because S has 3 rows while P has 2 rows.', false, 'The rule for a product is that the number of columns of S (2) equals the number of rows of P (2); the row counts need not match.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.10-a-v2', 'mcq', '4.10-A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A warehouse records shipments in a matrix S with rows for 2 trucks and columns for 4 goods, so S = [2 1 0 3; 4 5 1 0] counts crates. The weight matrix P = [5; 8; 2; 1] gives the weight in kilograms of one crate of each good. Which statement about computing the total weight carried by each truck is correct?', null, md5('apprecalc-mcq-b4b-sv-h-4.10-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'SP is defined, is 2×1, and equals [21; 62], with one entry for each of the 2 rows of S.', true, 'Correct: S is 2×4 and P is 4×1, so SP is defined and 2×1: row 1: 2·5 + 1·8 + 0·2 + 3·1 = 21. row 2: 4·5 + 5·8 + 1·2 + 0·1 = 62.' from version_ins
union all select gen_random_uuid(), id, 'B', 'PS is defined and gives the same totals, because matrix products can be taken in either order.', false, 'P is 4×1 and S is 2×4, so in PS the inner dimensions are 1 and 2, which do not match; PS is undefined, and products are not commutative anyway.' from version_ins
union all select gen_random_uuid(), id, 'C', 'SP is defined, is 4×1, and gives one total for each of the 4 columns of S.', false, 'The product of an 2×4 matrix and a 4×1 matrix has 2 rows and 1 column, so it has one entry for each row of S and not for each column.' from version_ins
union all select gen_random_uuid(), id, 'D', 'SP is undefined, because S has 2 rows while P has 4 rows.', false, 'The rule for a product is that the number of columns of S (4) equals the number of rows of P (4); the row counts need not match.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.10-a-v3', 'mcq', '4.10-A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A theater''s ticket matrix S has rows for 3 shows and columns for 2 ticket types, so S = [6 1; 2 3; 4 4] counts tickets sold. The price matrix P = [10; 5] lists the price in dollars of each ticket type. Which statement about computing the revenue from each show is correct?', null, md5('apprecalc-mcq-b4b-sv-h-4.10-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'PS is defined and gives the same totals, because matrix products can be taken in either order.', false, 'P is 2×1 and S is 3×2, so in PS the inner dimensions are 1 and 3, which do not match; PS is undefined, and products are not commutative anyway.' from version_ins
union all select gen_random_uuid(), id, 'B', 'SP is defined, is 3×1, and equals [65; 35; 60], with one entry for each of the 3 rows of S.', true, 'Correct: S is 3×2 and P is 2×1, so SP is defined and 3×1: row 1: 6·10 + 1·5 = 65. row 2: 2·10 + 3·5 = 35. row 3: 4·10 + 4·5 = 60.' from version_ins
union all select gen_random_uuid(), id, 'C', 'SP is defined, is 2×1, and gives one total for each of the 2 columns of S.', false, 'The product of an 3×2 matrix and a 2×1 matrix has 3 rows and 1 column, so it has one entry for each row of S and not for each column.' from version_ins
union all select gen_random_uuid(), id, 'D', 'SP is undefined, because S has 3 rows while P has 2 rows.', false, 'The rule for a product is that the number of columns of S (2) equals the number of rows of P (2); the row counts need not match.' from version_ins;
-- apprecalc-mcq-b4b-h-4.11-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-h-4.11-a', 'mcq', '4.11-A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The system 3x + y = 5 and 4x + 2y = 6 is written as AX = B with A = [3 1; 4 2], X = [x; y], and B = [5; 6]. Which ordered pair (x, y) solves it?', null, md5('apprecalc-mcq-b4b-h-4.11-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(4, -2)', false, 'This uses the adjugate [2 -1; -4 3] but forgets to divide by the determinant 2, so each coordinate is 2 times too large.' from version_ins
union all select gen_random_uuid(), id, 'B', '(2, -1)', true, 'Correct: det A = 3·2 − 1·4 = 2, A⁻¹ = (1/2)[2 -1; -4 3], and X = A⁻¹B = [2; -1].' from version_ins
union all select gen_random_uuid(), id, 'C', '(-2, 1)', false, 'This uses the negative of the inverse, because the diagonal entries were negated as well as the off-diagonal entries, which reverses the sign of the solution.' from version_ins
union all select gen_random_uuid(), id, 'D', '(-7, 6.5)', false, 'This puts the negated entries in the wrong places, using −c in the top right and −b in the bottom left, which is the transpose of the correct adjugate and so not the inverse of A.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.11-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.11-a-v1', 'mcq', '4.11-A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The system 4x + 3y = 10 and 2x + 2y = 6 is written as AX = B with A = [4 3; 2 2], X = [x; y], and B = [10; 6]. Which ordered pair (x, y) solves it?', null, md5('apprecalc-mcq-b4b-sv-h-4.11-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(1, 2)', true, 'Correct: det A = 4·2 − 3·2 = 2, A⁻¹ = (1/2)[2 -3; -2 4], and X = A⁻¹B = [1; 2].' from version_ins
union all select gen_random_uuid(), id, 'B', '(2, 4)', false, 'This uses the adjugate [2 -3; -2 4] but forgets to divide by the determinant 2, so each coordinate is 2 times too large.' from version_ins
union all select gen_random_uuid(), id, 'C', '(-1, -2)', false, 'This uses the negative of the inverse, because the diagonal entries were negated as well as the off-diagonal entries, which reverses the sign of the solution.' from version_ins
union all select gen_random_uuid(), id, 'D', '(4, -3)', false, 'This puts the negated entries in the wrong places, using −c in the top right and −b in the bottom left, which is the transpose of the correct adjugate and so not the inverse of A.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.11-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.11-a-v2', 'mcq', '4.11-A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The system 2x + 5y = 1 and 1x + 4y = -1 is written as AX = B with A = [2 5; 1 4], X = [x; y], and B = [1; -1]. Which ordered pair (x, y) solves it?', null, md5('apprecalc-mcq-b4b-sv-h-4.11-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(9, -3)', false, 'This uses the adjugate [4 -5; -1 2] but forgets to divide by the determinant 3, so each coordinate is 3 times too large.' from version_ins
union all select gen_random_uuid(), id, 'B', '(3, -1)', true, 'Correct: det A = 2·4 − 5·1 = 3, A⁻¹ = (1/3)[4 -5; -1 2], and X = A⁻¹B = [3; -1].' from version_ins
union all select gen_random_uuid(), id, 'C', '(-3, 1)', false, 'This uses the negative of the inverse, because the diagonal entries were negated as well as the off-diagonal entries, which reverses the sign of the solution.' from version_ins
union all select gen_random_uuid(), id, 'D', '(5/3, -7/3)', false, 'This puts the negated entries in the wrong places, using −c in the top right and −b in the bottom left, which is the transpose of the correct adjugate and so not the inverse of A.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.11-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.11-a-v3', 'mcq', '4.11-A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The system 5x + y = 13 and 3x + y = 9 is written as AX = B with A = [5 1; 3 1], X = [x; y], and B = [13; 9]. Which ordered pair (x, y) solves it?', null, md5('apprecalc-mcq-b4b-sv-h-4.11-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(4, 6)', false, 'This uses the adjugate [1 -1; -3 5] but forgets to divide by the determinant 2, so each coordinate is 2 times too large.' from version_ins
union all select gen_random_uuid(), id, 'B', '(-2, -3)', false, 'This uses the negative of the inverse, because the diagonal entries were negated as well as the off-diagonal entries, which reverses the sign of the solution.' from version_ins
union all select gen_random_uuid(), id, 'C', '(2, 3)', true, 'Correct: det A = 5·1 − 1·3 = 2, A⁻¹ = (1/2)[1 -1; -3 5], and X = A⁻¹B = [2; 3].' from version_ins
union all select gen_random_uuid(), id, 'D', '(-7, 16)', false, 'This puts the negated entries in the wrong places, using −c in the top right and −b in the bottom left, which is the transpose of the correct adjugate and so not the inverse of A.' from version_ins;
-- apprecalc-mcq-b4b-h-4.12-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-h-4.12-a', 'mcq', '4.12-A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'T first reflects the plane across the x-axis and then rotates it 90° counterclockwise. The reflection has matrix R = [1 0; 0 −1] and the rotation has matrix Q = [0 −1; 1 0]. Which choice gives the matrix of T and the image of the point (2, 3)?', null, md5('apprecalc-mcq-b4b-h-4.12-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0 -1; -1 0], and (2, 3) maps to (-3, -2)', false, 'This is RQ, the matrices multiplied in the order they are listed; the transformation done first must be written on the right, so T = QR.' from version_ins
union all select gen_random_uuid(), id, 'B', '[0 1; 1 0], and (2, 3) maps to (3, 2)', true, 'Correct: the first step is applied first, so T = QR = [0 -1; 1 0][1 0; 0 -1] = [0 1; 1 0]; then T(2, 3) = (3, 2).' from version_ins
union all select gen_random_uuid(), id, 'C', '[1 -1; 1 -1], and (2, 3) maps to (-1, -1)', false, 'This adds the two matrices; applying one transformation after another corresponds to a matrix product, not a sum.' from version_ins
union all select gen_random_uuid(), id, 'D', '[0 -1; 1 0], and (2, 3) maps to (-3, 2)', false, 'This is the matrix of the second step alone, which ignores the first transformation.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.12-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.12-a-v1', 'mcq', '4.12-A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'T first applies a horizontal shear with matrix H = [1 2; 0 1] and then reflects the plane across the y-axis with matrix R = [−1 0; 0 1]. Which choice gives the matrix of T and the image of the point (1, 3)?', null, md5('apprecalc-mcq-b4b-sv-h-4.12-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[-1 2; 0 1], and (1, 3) maps to (5, 3)', false, 'This is HR, the matrices multiplied in the order they are listed; the transformation done first must be written on the right, so T = RH.' from version_ins
union all select gen_random_uuid(), id, 'B', '[0 2; 0 2], and (1, 3) maps to (6, 6)', false, 'This adds the two matrices; applying one transformation after another corresponds to a matrix product, not a sum.' from version_ins
union all select gen_random_uuid(), id, 'C', '[-1 -2; 0 1], and (1, 3) maps to (-7, 3)', true, 'Correct: the first step is applied first, so T = RH = [-1 0; 0 1][1 2; 0 1] = [-1 -2; 0 1]; then T(1, 3) = (-7, 3).' from version_ins
union all select gen_random_uuid(), id, 'D', '[-1 0; 0 1], and (1, 3) maps to (-1, 3)', false, 'This is the matrix of the second step alone, which ignores the first transformation.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4b-sv-h-4.10-a-v1','apprecalc-mcq-b4b-sv-h-4.10-a-v2','apprecalc-mcq-b4b-sv-h-4.10-a-v3','apprecalc-mcq-b4b-h-4.11-a','apprecalc-mcq-b4b-sv-h-4.11-a-v1','apprecalc-mcq-b4b-sv-h-4.11-a-v2','apprecalc-mcq-b4b-sv-h-4.11-a-v3','apprecalc-mcq-b4b-h-4.12-a','apprecalc-mcq-b4b-sv-h-4.12-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b4b-sv-h-4.10-a-v1','apprecalc-mcq-b4b-sv-h-4.10-a-v2','apprecalc-mcq-b4b-sv-h-4.10-a-v3','apprecalc-mcq-b4b-h-4.11-a','apprecalc-mcq-b4b-sv-h-4.11-a-v1','apprecalc-mcq-b4b-sv-h-4.11-a-v2','apprecalc-mcq-b4b-sv-h-4.11-a-v3','apprecalc-mcq-b4b-h-4.12-a','apprecalc-mcq-b4b-sv-h-4.12-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
