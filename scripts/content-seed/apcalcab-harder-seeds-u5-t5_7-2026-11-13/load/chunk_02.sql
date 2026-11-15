begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b14-sv-h-5.7-c-v1','apcalcab-mcq-b14-sv-h-5.7-c-v2','apcalcab-mcq-b14-sv-h-5.7-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b14-sv-h-5.7-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-sv-h-5.7-c-v1', 'mcq', 'infer a global extremum from one critical point (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function h is differentiable for every real x and has h''(x)=-1(x−(1))/(1+x²). This is its only critical point. What can be concluded about x=1 using the second derivative test together with the one-critical-point result?', null, md5('apcalcab-mcq-b14-sv-h-5.7-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h has a local minimum at x=1, and it is also an absolute minimum because the denominator is positive.', false, 'The sign of h'''' at the critical point is reversed here, so the local type is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h has a local maximum at x=1, but it cannot be an absolute extremum because the real-line interval has no endpoints.', false, 'A continuous function with only this critical point and a local extremum has the same absolute extremum on its real-line domain; endpoints are not required.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h has no extremum at x=1 because the first derivative vanishes there.', false, 'A zero first derivative is a critical point, and the nonzero second derivative classifies an extremum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h has a local maximum at x=1, and it is also an absolute maximum on the real line.', true, 'Correct: h''''(1)=-1/(1+1²), with sign negative. The denominator of h'' is always positive, so h'' changes positive to negative at its unique zero; the local maximum is absolute.' from version_ins;
-- apcalcab-mcq-b14-sv-h-5.7-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-sv-h-5.7-c-v2', 'mcq', 'infer a global extremum from one critical point (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function h is differentiable for every real x and has h''(x)=2(x−(3))/(1+x²). This is its only critical point. What can be concluded about x=3 using the second derivative test together with the one-critical-point result?', null, md5('apcalcab-mcq-b14-sv-h-5.7-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h has a local maximum at x=3, and it is also an absolute maximum because the denominator is positive.', false, 'The sign of h'''' at the critical point is reversed here, so the local type is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h has a local minimum at x=3, but it cannot be an absolute extremum because the real-line interval has no endpoints.', false, 'A continuous function with only this critical point and a local extremum has the same absolute extremum on its real-line domain; endpoints are not required.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h has no extremum at x=3 because the first derivative vanishes there.', false, 'A zero first derivative is a critical point, and the nonzero second derivative classifies an extremum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h has a local minimum at x=3, and it is also an absolute minimum on the real line.', true, 'Correct: h''''(3)=2/(1+3²), with sign positive. The denominator of h'' is always positive, so h'' changes negative to positive at its unique zero; the local minimum is absolute.' from version_ins;
-- apcalcab-mcq-b14-sv-h-5.7-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-sv-h-5.7-c-v3', 'mcq', 'infer a global extremum from one critical point (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function h is differentiable for every real x and has h''(x)=-2(x−(-1))/(1+x²). This is its only critical point. What can be concluded about x=-1 using the second derivative test together with the one-critical-point result?', null, md5('apcalcab-mcq-b14-sv-h-5.7-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h has a local minimum at x=-1, and it is also an absolute minimum because the denominator is positive.', false, 'The sign of h'''' at the critical point is reversed here, so the local type is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h has a local maximum at x=-1, but it cannot be an absolute extremum because the real-line interval has no endpoints.', false, 'A continuous function with only this critical point and a local extremum has the same absolute extremum on its real-line domain; endpoints are not required.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h has a local maximum at x=-1, and it is also an absolute maximum on the real line.', true, 'Correct: h''''(-1)=-2/(1+-1²), with sign negative. The denominator of h'' is always positive, so h'' changes positive to negative at its unique zero; the local maximum is absolute.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h has no extremum at x=-1 because the first derivative vanishes there.', false, 'A zero first derivative is a critical point, and the nonzero second derivative classifies an extremum.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b14-sv-h-5.7-c-v1','apcalcab-mcq-b14-sv-h-5.7-c-v2','apcalcab-mcq-b14-sv-h-5.7-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b14-sv-h-5.7-c-v1','apcalcab-mcq-b14-sv-h-5.7-c-v2','apcalcab-mcq-b14-sv-h-5.7-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
