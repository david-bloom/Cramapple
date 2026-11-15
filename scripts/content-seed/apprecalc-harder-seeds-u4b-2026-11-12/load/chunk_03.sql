begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4b-sv-h-4.12-a-v2','apprecalc-mcq-b4b-sv-h-4.12-a-v3','apprecalc-mcq-b4b-h-4.13-a','apprecalc-mcq-b4b-sv-h-4.13-a-v1','apprecalc-mcq-b4b-sv-h-4.13-a-v2','apprecalc-mcq-b4b-sv-h-4.13-a-v3','apprecalc-mcq-b4b-h-4.14-a','apprecalc-mcq-b4b-sv-h-4.14-a-v1','apprecalc-mcq-b4b-sv-h-4.14-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apprecalc-mcq-b4b-sv-h-4.12-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.12-a-v2', 'mcq', '4.12-A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'T first stretches the plane horizontally by a factor of 3, with matrix S = [3 0; 0 1], and then rotates it 90° counterclockwise, with matrix Q = [0 −1; 1 0]. Which choice gives the matrix of T and the image of the point (2, 1)?', null, md5('apprecalc-mcq-b4b-sv-h-4.12-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0 -3; 1 0], and (2, 1) maps to (-3, 2)', false, 'This is SQ, the matrices multiplied in the order they are listed; the transformation done first must be written on the right, so T = QS.' from version_ins
union all select gen_random_uuid(), id, 'B', '[0 -1; 3 0], and (2, 1) maps to (-1, 6)', true, 'Correct: the first step is applied first, so T = QS = [0 -1; 1 0][3 0; 0 1] = [0 -1; 3 0]; then T(2, 1) = (-1, 6).' from version_ins
union all select gen_random_uuid(), id, 'C', '[3 -1; 1 1], and (2, 1) maps to (5, 3)', false, 'This adds the two matrices; applying one transformation after another corresponds to a matrix product, not a sum.' from version_ins
union all select gen_random_uuid(), id, 'D', '[0 -1; 1 0], and (2, 1) maps to (-1, 2)', false, 'This is the matrix of the second step alone, which ignores the first transformation.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.12-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.12-a-v3', 'mcq', '4.12-A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'T first rotates the plane 90° clockwise, with matrix C = [0 1; −1 0], and then reflects it across the line y = x, with matrix R = [0 1; 1 0]. Which choice gives the matrix of T and the image of the point (3, 4)?', null, md5('apprecalc-mcq-b4b-sv-h-4.12-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[-1 0; 0 1], and (3, 4) maps to (-3, 4)', true, 'Correct: the first step is applied first, so T = RC = [0 1; 1 0][0 1; -1 0] = [-1 0; 0 1]; then T(3, 4) = (-3, 4).' from version_ins
union all select gen_random_uuid(), id, 'B', '[1 0; 0 -1], and (3, 4) maps to (3, -4)', false, 'This is CR, the matrices multiplied in the order they are listed; the transformation done first must be written on the right, so T = RC.' from version_ins
union all select gen_random_uuid(), id, 'C', '[0 2; 0 0], and (3, 4) maps to (8, 0)', false, 'This adds the two matrices; applying one transformation after another corresponds to a matrix product, not a sum.' from version_ins
union all select gen_random_uuid(), id, 'D', '[0 1; 1 0], and (3, 4) maps to (4, 3)', false, 'This is the matrix of the second step alone, which ignores the first transformation.' from version_ins;
-- apprecalc-mcq-b4b-h-4.13-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-h-4.13-a', 'mcq', '4.13-A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear transformation T of the plane is given by T(v) = Av with A = [1 3; 2 1]. A triangle of area 6 square units is mapped by T to a new triangle. Which statement about the image is correct?', null, md5('apprecalc-mcq-b4b-h-4.13-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The image has area 30 square units, and its orientation is preserved.', false, 'The area factor |det A| = 5 is right, but the sign of det A = -5 is negative, so orientation is reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The image has area 30 square units, and its orientation is reversed.', true, 'Correct: det A = 1·1 − 3·2 = -5; areas scale by |-5|, giving 30, and the sign is negative, so orientation is reversed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The image has area 42 square units, and its orientation is reversed.', false, 'The area factor is the determinant 1·1 − 3·2 = -5 (in absolute value), not the sum of the entries 7.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The image has area -30 square units, and its orientation is reversed.', false, 'An area cannot be negative; the negative determinant -5 means orientation reverses, and the area is scaled by |det| = 5, giving 30.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.13-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.13-a-v1', 'mcq', '4.13-A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear transformation T of the plane is given by T(v) = Av with A = [4 1; 3 2]. A region of area 8 square units is mapped by T to a new region. Which statement about the image is correct?', null, md5('apprecalc-mcq-b4b-sv-h-4.13-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The image has area 40 square units, and its orientation is reversed.', false, 'The area factor |det A| = 5 is right, but the sign of det A = 5 is positive, so orientation is preserved.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The image has area 80 square units, and its orientation is preserved.', false, 'The area factor is the determinant 4·2 − 1·3 = 5 (in absolute value), not the sum of the entries 10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The image has area 40 square units, and its orientation is preserved.', true, 'Correct: det A = 4·2 − 1·3 = 5; areas scale by |5|, giving 40, and the sign is positive, so orientation is preserved.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The image has area 8 square units, and its orientation is preserved.', false, 'A linear map with det A = 5 scales areas by |det A| = 5, so the area is 40; areas are not preserved unless |det| = 1.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.13-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.13-a-v2', 'mcq', '4.13-A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear transformation T of the plane is given by T(v) = Av with A = [1 4; 2 2]. A triangle of area 4 square units is mapped by T to a new triangle. Which statement about the image is correct?', null, md5('apprecalc-mcq-b4b-sv-h-4.13-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The image has area 24 square units, and its orientation is preserved.', false, 'The area factor |det A| = 6 is right, but the sign of det A = -6 is negative, so orientation is reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The image has area 24 square units, and its orientation is reversed.', true, 'Correct: det A = 1·2 − 4·2 = -6; areas scale by |-6|, giving 24, and the sign is negative, so orientation is reversed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The image has area 36 square units, and its orientation is reversed.', false, 'The area factor is the determinant 1·2 − 4·2 = -6 (in absolute value), not the sum of the entries 9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The image has area -24 square units, and its orientation is reversed.', false, 'An area cannot be negative; the negative determinant -6 means orientation reverses, and the area is scaled by |det| = 6, giving 24.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.13-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.13-a-v3', 'mcq', '4.13-A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear transformation T of the plane is given by T(v) = Av with A = [5 2; 1 3]. A region of area 3 square units is mapped by T to a new region. Which statement about the image is correct?', null, md5('apprecalc-mcq-b4b-sv-h-4.13-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The image has area 39 square units, and its orientation is reversed.', false, 'The area factor |det A| = 13 is right, but the sign of det A = 13 is positive, so orientation is preserved.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The image has area 33 square units, and its orientation is preserved.', false, 'The area factor is the determinant 5·3 − 2·1 = 13 (in absolute value), not the sum of the entries 11.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The image has area 39 square units, and its orientation is preserved.', true, 'Correct: det A = 5·3 − 2·1 = 13; areas scale by |13|, giving 39, and the sign is positive, so orientation is preserved.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The image has area 3 square units, and its orientation is preserved.', false, 'A linear map with det A = 13 scales areas by |det A| = 13, so the area is 39; areas are not preserved unless |det| = 1.' from version_ins;
-- apprecalc-mcq-b4b-h-4.14-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-h-4.14-a', 'mcq', '4.14-A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A streaming service has two plans, X and Y. Each week 80% of X subscribers stay on X and 20% move to Y; 30% of Y subscribers move to X and 70% stay on Y. The state vector is [X; Y], and M = [0.8 0.3; 0.2 0.7] updates it from one week to the next (each column describes where that plan''s subscribers go). Now there are 500 subscribers on X and 300 on Y. How many are predicted on [X; Y] after two weeks?', null, md5('apprecalc-mcq-b4b-h-4.14-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[490; 310]', false, 'This is the prediction after only one step, M times the starting vector; the question asks for two steps, which means applying M a second time.' from version_ins
union all select gen_random_uuid(), id, 'B', '[440; 390]', false, 'This multiplies by the transpose of M, treating rows as the ''from'' groups; here each column of M describes where one group goes, so rows and columns were confused.' from version_ins
union all select gen_random_uuid(), id, 'C', '[485; 315]', true, 'Correct: one step gives [490; 310]; a second application of M gives [485; 315]; the total 800 is unchanged.' from version_ins
union all select gen_random_uuid(), id, 'D', '[347; 167]', false, 'This squares each entry of M separately; M² is the matrix product M·M, and squared entries do not even keep the total population constant.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.14-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.14-a-v1', 'mcq', '4.14-A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'People in a metro area live in the city (C) or the suburbs (S). Each year 90% of city residents stay and 10% move to the suburbs; 20% of suburban residents move to the city and 80% stay. With state vector [C; S], the yearly update matrix is M = [0.9 0.2; 0.1 0.8] (each column describes where that group''s residents go). The population is now 600 thousand in the city and 400 thousand in the suburbs. What is predicted for [C; S] after two years?', null, md5('apprecalc-mcq-b4b-sv-h-4.14-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[620; 380]', false, 'This is the prediction after only one step, M times the starting vector; the question asks for two steps, which means applying M a second time.' from version_ins
union all select gen_random_uuid(), id, 'B', '[566; 468]', false, 'This multiplies by the transpose of M, treating rows as the ''from'' groups; here each column of M describes where one group goes, so rows and columns were confused.' from version_ins
union all select gen_random_uuid(), id, 'C', '[502; 262]', false, 'This squares each entry of M separately; M² is the matrix product M·M, and squared entries do not even keep the total population constant.' from version_ins
union all select gen_random_uuid(), id, 'D', '[634; 366]', true, 'Correct: one step gives [620; 380]; a second application of M gives [634; 366]; the total 1000 is unchanged.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.14-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.14-a-v2', 'mcq', '4.14-A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bike-share network has stations in the north (N) and south (S). Each day 60% of bikes at N stay there and 40% end the day at S; 50% of bikes at S end at N and 50% stay. With state vector [N; S], the daily update matrix is M = [0.6 0.5; 0.4 0.5] (each column describes where bikes from that station end up). Today there are 200 bikes at N and 100 at S. How many are predicted at [N; S] after two days?', null, md5('apprecalc-mcq-b4b-sv-h-4.14-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[170; 130]', false, 'This is the prediction after only one step, M times the starting vector; the question asks for two steps, which means applying M a second time.' from version_ins
union all select gen_random_uuid(), id, 'B', '[156; 155]', false, 'This multiplies by the transpose of M, treating rows as the ''from'' groups; here each column of M describes where one group goes, so rows and columns were confused.' from version_ins
union all select gen_random_uuid(), id, 'C', '[97; 57]', false, 'This squares each entry of M separately; M² is the matrix product M·M, and squared entries do not even keep the total population constant.' from version_ins
union all select gen_random_uuid(), id, 'D', '[167; 133]', true, 'Correct: one step gives [170; 130]; a second application of M gives [167; 133]; the total 300 is unchanged.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4b-sv-h-4.12-a-v2','apprecalc-mcq-b4b-sv-h-4.12-a-v3','apprecalc-mcq-b4b-h-4.13-a','apprecalc-mcq-b4b-sv-h-4.13-a-v1','apprecalc-mcq-b4b-sv-h-4.13-a-v2','apprecalc-mcq-b4b-sv-h-4.13-a-v3','apprecalc-mcq-b4b-h-4.14-a','apprecalc-mcq-b4b-sv-h-4.14-a-v1','apprecalc-mcq-b4b-sv-h-4.14-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b4b-sv-h-4.12-a-v2','apprecalc-mcq-b4b-sv-h-4.12-a-v3','apprecalc-mcq-b4b-h-4.13-a','apprecalc-mcq-b4b-sv-h-4.13-a-v1','apprecalc-mcq-b4b-sv-h-4.13-a-v2','apprecalc-mcq-b4b-sv-h-4.13-a-v3','apprecalc-mcq-b4b-h-4.14-a','apprecalc-mcq-b4b-sv-h-4.14-a-v1','apprecalc-mcq-b4b-sv-h-4.14-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
