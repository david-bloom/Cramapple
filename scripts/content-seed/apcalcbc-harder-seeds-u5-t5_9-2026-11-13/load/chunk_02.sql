begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b16-sv-h-5.9-c-v1','apcalcbc-mcq-b16-sv-h-5.9-c-v2','apcalcbc-mcq-b16-sv-h-5.9-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b16-sv-h-5.9-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b16-sv-h-5.9-c-v1', 'mcq', 'match trig graph landmarks (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval from x=π/2 to x=π/2+2π, let g(x)=-1sin(x−(π/2)). Which interior features of the graphs of g, g'', and g'''' correspond?', null, md5('apcalcbc-mcq-b16-sv-h-5.9-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g has inflections at x=π/2+3π/2 and x=π/2+π/2, because g'' is zero there; g has an extremum at x=π/2+π.', false, 'Zeros of g'' locate extrema of g, whereas a sign change of g'''' locates an inflection of g.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g has local extrema at all three listed interior points because either g'' or g'''' vanishes at each.', false, 'At the middle point g'' is nonzero, so g has no extremum there; g''''=0 alone does not mark an extremum of g.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g cannot have an inflection at the middle point because g'''' is zero there.', false, 'G'''' changes sign at the middle point, which is the defining concavity change for an inflection.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g has a local maximum at x=π/2+3π/2 and a local minimum at x=π/2+π/2; g has an inflection at x=π/2+π, where g'' has a local extremum.', true, 'Correct: g''=-1cos(x−(π/2)), g''''=−-1sin(x−(π/2)). The cosine zeros make g''s two extrema; g'''' changes sign at the middle point, where the cosine graph has an extremum.' from version_ins;
-- apcalcbc-mcq-b16-sv-h-5.9-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b16-sv-h-5.9-c-v2', 'mcq', 'match trig graph landmarks (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval from x=π to x=π+2π, let g(x)=1sin(x−(π)). Which interior features of the graphs of g, g'', and g'''' correspond?', null, md5('apcalcbc-mcq-b16-sv-h-5.9-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g has inflections at x=π+π/2 and x=π+3π/2, because g'' is zero there; g has an extremum at x=π+π.', false, 'Zeros of g'' locate extrema of g, whereas a sign change of g'''' locates an inflection of g.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g has local extrema at all three listed interior points because either g'' or g'''' vanishes at each.', false, 'At the middle point g'' is nonzero, so g has no extremum there; g''''=0 alone does not mark an extremum of g.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g cannot have an inflection at the middle point because g'''' is zero there.', false, 'G'''' changes sign at the middle point, which is the defining concavity change for an inflection.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g has a local maximum at x=π+π/2 and a local minimum at x=π+3π/2; g has an inflection at x=π+π, where g'' has a local extremum.', true, 'Correct: g''=1cos(x−(π)), g''''=−1sin(x−(π)). The cosine zeros make g''s two extrema; g'''' changes sign at the middle point, where the cosine graph has an extremum.' from version_ins;
-- apcalcbc-mcq-b16-sv-h-5.9-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b16-sv-h-5.9-c-v3', 'mcq', 'match trig graph landmarks (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval from x=−π/2 to x=−π/2+2π, let g(x)=-1sin(x−(−π/2)). Which interior features of the graphs of g, g'', and g'''' correspond?', null, md5('apcalcbc-mcq-b16-sv-h-5.9-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g has inflections at x=−π/2+3π/2 and x=−π/2+π/2, because g'' is zero there; g has an extremum at x=−π/2+π.', false, 'Zeros of g'' locate extrema of g, whereas a sign change of g'''' locates an inflection of g.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g has local extrema at all three listed interior points because either g'' or g'''' vanishes at each.', false, 'At the middle point g'' is nonzero, so g has no extremum there; g''''=0 alone does not mark an extremum of g.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g has a local maximum at x=−π/2+3π/2 and a local minimum at x=−π/2+π/2; g has an inflection at x=−π/2+π, where g'' has a local extremum.', true, 'Correct: g''=-1cos(x−(−π/2)), g''''=−-1sin(x−(−π/2)). The cosine zeros make g''s two extrema; g'''' changes sign at the middle point, where the cosine graph has an extremum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g cannot have an inflection at the middle point because g'''' is zero there.', false, 'G'''' changes sign at the middle point, which is the defining concavity change for an inflection.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b16-sv-h-5.9-c-v1','apcalcbc-mcq-b16-sv-h-5.9-c-v2','apcalcbc-mcq-b16-sv-h-5.9-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b16-sv-h-5.9-c-v1','apcalcbc-mcq-b16-sv-h-5.9-c-v2','apcalcbc-mcq-b16-sv-h-5.9-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
