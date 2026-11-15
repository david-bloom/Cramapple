begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b11-sv-h-5.4-c-v1','apcalcbc-mcq-b11-sv-h-5.4-c-v2','apcalcbc-mcq-b11-sv-h-5.4-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b11-sv-h-5.4-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b11-sv-h-5.4-c-v1', 'mcq', 'classify even and odd derivative zeros (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function g satisfies g''(x)=-1(x-(-1))²(x-(3)) for all real x. Which statement about the stationary points x=-1 and x=3 is correct?', null, md5('apcalcbc-mcq-b11-sv-h-5.4-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=-1 is a local maximum; x=3 is not an extremum because the factor at 3 has odd multiplicity.', false, 'The squared factor gives no derivative sign reversal at its root, while the simple factor does reverse sign at the other root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=3 is a local minimum, and x=-1 is also a local extremum because both factors vanish.', false, 'The simple factor changes sign, but its extremum type is reversed here; the repeated root stays stationary without an extremum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Neither point can be a local extremum because the derivative is a polynomial and therefore continuous.', false, 'A continuous polynomial derivative can change sign at a simple root and create a local extremum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=3 is a local maximum; x=-1 is stationary but not a local extremum because g'' keeps its sign there.', true, 'Correct: The squared factor at x=-1 does not flip sign. Away from that point the sign of g'' is the sign of -1(x-(3)), which changes positive to negative at x=3.' from version_ins;
-- apcalcbc-mcq-b11-sv-h-5.4-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b11-sv-h-5.4-c-v2', 'mcq', 'classify even and odd derivative zeros (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function g satisfies g''(x)=2(x-(4))²(x-(0)) for all real x. Which statement about the stationary points x=4 and x=0 is correct?', null, md5('apcalcbc-mcq-b11-sv-h-5.4-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=4 is a local minimum; x=0 is not an extremum because the factor at 0 has odd multiplicity.', false, 'The squared factor gives no derivative sign reversal at its root, while the simple factor does reverse sign at the other root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=0 is a local maximum, and x=4 is also a local extremum because both factors vanish.', false, 'The simple factor changes sign, but its extremum type is reversed here; the repeated root stays stationary without an extremum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Neither point can be a local extremum because the derivative is a polynomial and therefore continuous.', false, 'A continuous polynomial derivative can change sign at a simple root and create a local extremum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=0 is a local minimum; x=4 is stationary but not a local extremum because g'' keeps its sign there.', true, 'Correct: The squared factor at x=4 does not flip sign. Away from that point the sign of g'' is the sign of 2(x-(0)), which changes negative to positive at x=0.' from version_ins;
-- apcalcbc-mcq-b11-sv-h-5.4-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b11-sv-h-5.4-c-v3', 'mcq', 'classify even and odd derivative zeros (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function g satisfies g''(x)=-2(x-(-3))²(x-(2)) for all real x. Which statement about the stationary points x=-3 and x=2 is correct?', null, md5('apcalcbc-mcq-b11-sv-h-5.4-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=-3 is a local maximum; x=2 is not an extremum because the factor at 2 has odd multiplicity.', false, 'The squared factor gives no derivative sign reversal at its root, while the simple factor does reverse sign at the other root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=2 is a local minimum, and x=-3 is also a local extremum because both factors vanish.', false, 'The simple factor changes sign, but its extremum type is reversed here; the repeated root stays stationary without an extremum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=2 is a local maximum; x=-3 is stationary but not a local extremum because g'' keeps its sign there.', true, 'Correct: The squared factor at x=-3 does not flip sign. Away from that point the sign of g'' is the sign of -2(x-(2)), which changes positive to negative at x=2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither point can be a local extremum because the derivative is a polynomial and therefore continuous.', false, 'A continuous polynomial derivative can change sign at a simple root and create a local extremum.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b11-sv-h-5.4-c-v1','apcalcbc-mcq-b11-sv-h-5.4-c-v2','apcalcbc-mcq-b11-sv-h-5.4-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b11-sv-h-5.4-c-v1','apcalcbc-mcq-b11-sv-h-5.4-c-v2','apcalcbc-mcq-b11-sv-h-5.4-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
