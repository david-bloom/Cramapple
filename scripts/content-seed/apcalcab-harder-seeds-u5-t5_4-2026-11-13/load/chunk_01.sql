begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b11-h-5.4-a','apcalcab-mcq-b11-sv-h-5.4-a-v1','apcalcab-mcq-b11-sv-h-5.4-a-v2','apcalcab-mcq-b11-sv-h-5.4-a-v3','apcalcab-mcq-b11-h-5.4-b','apcalcab-mcq-b11-sv-h-5.4-b-v1','apcalcab-mcq-b11-sv-h-5.4-b-v2','apcalcab-mcq-b11-sv-h-5.4-b-v3','apcalcab-mcq-b11-h-5.4-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-b11-h-5.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b11-h-5.4-a', 'mcq', 'classify simple derivative zeros', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has f''(x)=1(x-(-2))(x-(1)) for all real x, with -2<1. Which classification of its local extrema follows from the first derivative test?', null, md5('apcalcab-mcq-b11-h-5.4-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local minimum at x=-2 and a local maximum at x=1.', false, 'This reverses the derivative sign changes: positive-to-negative makes a maximum and negative-to-positive a minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local maximum at x=-2 and a local minimum at x=1.', true, 'Correct: For x<-2, between -2 and 1, and x>1, the derivative signs are positive, negative, positive. Thus x=-2 is a positive-to-negative switch and x=1 a negative-to-positive switch.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both x=-2 and x=1 are local maxima because f'' is zero at both.', false, 'Zeros are candidates; the sign changes around each root determine opposite extremum types.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither zero of f'' can be a local extremum because f is differentiable there.', false, 'Differentiability does not prevent local extrema; these derivative sign reversals establish them.' from version_ins;
-- apcalcab-mcq-b11-sv-h-5.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b11-sv-h-5.4-a-v1', 'mcq', 'classify simple derivative zeros (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has f''(x)=-1(x-(-3))(x-(2)) for all real x, with -3<2. Which classification of its local extrema follows from the first derivative test?', null, md5('apcalcab-mcq-b11-sv-h-5.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local minimum at x=2 and a local maximum at x=-3.', false, 'This reverses the derivative sign changes: positive-to-negative makes a maximum and negative-to-positive a minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both x=-3 and x=2 are local maxima because f'' is zero at both.', false, 'Zeros are candidates; the sign changes around each root determine opposite extremum types.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Neither zero of f'' can be a local extremum because f is differentiable there.', false, 'Differentiability does not prevent local extrema; these derivative sign reversals establish them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f has a local maximum at x=2 and a local minimum at x=-3.', true, 'Correct: For x<-3, between -3 and 2, and x>2, the derivative signs are negative, positive, negative. Thus x=2 is a positive-to-negative switch and x=-3 a negative-to-positive switch.' from version_ins;
-- apcalcab-mcq-b11-sv-h-5.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b11-sv-h-5.4-a-v2', 'mcq', 'classify simple derivative zeros (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has f''(x)=2(x-(0))(x-(4)) for all real x, with 0<4. Which classification of its local extrema follows from the first derivative test?', null, md5('apcalcab-mcq-b11-sv-h-5.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local maximum at x=0 and a local minimum at x=4.', true, 'Correct: For x<0, between 0 and 4, and x>4, the derivative signs are positive, negative, positive. Thus x=0 is a positive-to-negative switch and x=4 a negative-to-positive switch.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local minimum at x=0 and a local maximum at x=4.', false, 'This reverses the derivative sign changes: positive-to-negative makes a maximum and negative-to-positive a minimum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both x=0 and x=4 are local maxima because f'' is zero at both.', false, 'Zeros are candidates; the sign changes around each root determine opposite extremum types.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither zero of f'' can be a local extremum because f is differentiable there.', false, 'Differentiability does not prevent local extrema; these derivative sign reversals establish them.' from version_ins;
-- apcalcab-mcq-b11-sv-h-5.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b11-sv-h-5.4-a-v3', 'mcq', 'classify simple derivative zeros (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has f''(x)=-2(x-(-1))(x-(3)) for all real x, with -1<3. Which classification of its local extrema follows from the first derivative test?', null, md5('apcalcab-mcq-b11-sv-h-5.4-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local minimum at x=3 and a local maximum at x=-1.', false, 'This reverses the derivative sign changes: positive-to-negative makes a maximum and negative-to-positive a minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both x=-1 and x=3 are local maxima because f'' is zero at both.', false, 'Zeros are candidates; the sign changes around each root determine opposite extremum types.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f has a local maximum at x=3 and a local minimum at x=-1.', true, 'Correct: For x<-1, between -1 and 3, and x>3, the derivative signs are negative, positive, negative. Thus x=3 is a positive-to-negative switch and x=-1 a negative-to-positive switch.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither zero of f'' can be a local extremum because f is differentiable there.', false, 'Differentiability does not prevent local extrema; these derivative sign reversals establish them.' from version_ins;
-- apcalcab-mcq-b11-h-5.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b11-h-5.4-b', 'mcq', 'interpret a derivative sign chart', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A graph of a continuous derivative f'' crosses or touches the x-axis only at x=-2, 0, and 3. On the four successive intervals its signs are +,-,-,+. Which conclusion about f follows?', null, md5('apcalcab-mcq-b11-h-5.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local minimum at x=-2, a local maximum at x=3, and neither at x=0.', false, 'The sign-switch directions are reversed: positive-to-negative is a local maximum, not a minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local maximum at x=-2, a local minimum at x=3, and neither type of extremum at x=0.', true, 'Correct: Read derivative signs in x order: +,-,-,+. A + to - switch marks a maximum, - to + marks a minimum, and no sign switch at x=0 marks neither.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All three zeros are local extrema because f'' is zero at each.', false, 'A derivative zero without a sign reversal need not be a local extremum; inspect all adjacent intervals.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No local extrema can be inferred because the numerical values of f at the zeros are unknown.', false, 'The first derivative test uses signs of f'', so explicit function values are unnecessary to classify local extrema.' from version_ins;
-- apcalcab-mcq-b11-sv-h-5.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b11-sv-h-5.4-b-v1', 'mcq', 'interpret a derivative sign chart (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A graph of a continuous derivative f'' crosses or touches the x-axis only at x=-3, 1, and 4. On the four successive intervals its signs are -,+,+,-. Which conclusion about f follows?', null, md5('apcalcab-mcq-b11-sv-h-5.4-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local maximum at x=4, a local minimum at x=-3, and neither type of extremum at x=1.', true, 'Correct: Read derivative signs in x order: -,+,+,-. A + to - switch marks a maximum, - to + marks a minimum, and no sign switch at x=1 marks neither.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local minimum at x=4, a local maximum at x=-3, and neither at x=1.', false, 'The sign-switch directions are reversed: positive-to-negative is a local maximum, not a minimum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All three zeros are local extrema because f'' is zero at each.', false, 'A derivative zero without a sign reversal need not be a local extremum; inspect all adjacent intervals.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No local extrema can be inferred because the numerical values of f at the zeros are unknown.', false, 'The first derivative test uses signs of f'', so explicit function values are unnecessary to classify local extrema.' from version_ins;
-- apcalcab-mcq-b11-sv-h-5.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b11-sv-h-5.4-b-v2', 'mcq', 'interpret a derivative sign chart (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A graph of a continuous derivative f'' crosses or touches the x-axis only at x=-1, 2, and 5. On the four successive intervals its signs are +,+,-,+. Which conclusion about f follows?', null, md5('apcalcab-mcq-b11-sv-h-5.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local minimum at x=2, a local maximum at x=5, and neither at x=-1.', false, 'The sign-switch directions are reversed: positive-to-negative is a local maximum, not a minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local maximum at x=2, a local minimum at x=5, and neither type of extremum at x=-1.', true, 'Correct: Read derivative signs in x order: +,+,-,+. A + to - switch marks a maximum, - to + marks a minimum, and no sign switch at x=-1 marks neither.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All three zeros are local extrema because f'' is zero at each.', false, 'A derivative zero without a sign reversal need not be a local extremum; inspect all adjacent intervals.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No local extrema can be inferred because the numerical values of f at the zeros are unknown.', false, 'The first derivative test uses signs of f'', so explicit function values are unnecessary to classify local extrema.' from version_ins;
-- apcalcab-mcq-b11-sv-h-5.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b11-sv-h-5.4-b-v3', 'mcq', 'interpret a derivative sign chart (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A graph of a continuous derivative f'' crosses or touches the x-axis only at x=-4, -1, and 2. On the four successive intervals its signs are -,-,+,-. Which conclusion about f follows?', null, md5('apcalcab-mcq-b11-sv-h-5.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local maximum at x=2, a local minimum at x=-1, and neither type of extremum at x=-4.', true, 'Correct: Read derivative signs in x order: -,-,+,-. A + to - switch marks a maximum, - to + marks a minimum, and no sign switch at x=-4 marks neither.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local minimum at x=2, a local maximum at x=-1, and neither at x=-4.', false, 'The sign-switch directions are reversed: positive-to-negative is a local maximum, not a minimum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All three zeros are local extrema because f'' is zero at each.', false, 'A derivative zero without a sign reversal need not be a local extremum; inspect all adjacent intervals.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No local extrema can be inferred because the numerical values of f at the zeros are unknown.', false, 'The first derivative test uses signs of f'', so explicit function values are unnecessary to classify local extrema.' from version_ins;
-- apcalcab-mcq-b11-h-5.4-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b11-h-5.4-c', 'mcq', 'classify even and odd derivative zeros', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function g satisfies g''(x)=1(x-(1))²(x-(-2)) for all real x. Which statement about the stationary points x=1 and x=-2 is correct?', null, md5('apcalcab-mcq-b11-h-5.4-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=1 is a local minimum; x=-2 is not an extremum because the factor at -2 has odd multiplicity.', false, 'The squared factor gives no derivative sign reversal at its root, while the simple factor does reverse sign at the other root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=-2 is a local maximum, and x=1 is also a local extremum because both factors vanish.', false, 'The simple factor changes sign, but its extremum type is reversed here; the repeated root stays stationary without an extremum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=-2 is a local minimum; x=1 is stationary but not a local extremum because g'' keeps its sign there.', true, 'Correct: The squared factor at x=1 does not flip sign. Away from that point the sign of g'' is the sign of 1(x-(-2)), which changes negative to positive at x=-2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither point can be a local extremum because the derivative is a polynomial and therefore continuous.', false, 'A continuous polynomial derivative can change sign at a simple root and create a local extremum.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b11-h-5.4-a','apcalcab-mcq-b11-sv-h-5.4-a-v1','apcalcab-mcq-b11-sv-h-5.4-a-v2','apcalcab-mcq-b11-sv-h-5.4-a-v3','apcalcab-mcq-b11-h-5.4-b','apcalcab-mcq-b11-sv-h-5.4-b-v1','apcalcab-mcq-b11-sv-h-5.4-b-v2','apcalcab-mcq-b11-sv-h-5.4-b-v3','apcalcab-mcq-b11-h-5.4-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b11-h-5.4-a','apcalcab-mcq-b11-sv-h-5.4-a-v1','apcalcab-mcq-b11-sv-h-5.4-a-v2','apcalcab-mcq-b11-sv-h-5.4-a-v3','apcalcab-mcq-b11-h-5.4-b','apcalcab-mcq-b11-sv-h-5.4-b-v1','apcalcab-mcq-b11-sv-h-5.4-b-v2','apcalcab-mcq-b11-sv-h-5.4-b-v3','apcalcab-mcq-b11-h-5.4-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
