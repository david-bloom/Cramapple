begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b10-sv-h-5.3-c-v1','apcalcab-mcq-b10-sv-h-5.3-c-v2','apcalcab-mcq-b10-sv-h-5.3-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b10-sv-h-5.3-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b10-sv-h-5.3-c-v1', 'mcq', 'handle derivative sign across domain gaps (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable g has g''(x)=(x-3)/(x+1) wherever x≠-1; g is undefined at -1. On which intervals is g decreasing?', null, md5('apcalcab-mcq-b10-sv-h-5.3-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g decreases on (-infinity,-1) and (3,infinity), because both factors share a sign there.', false, 'Equal signs make a quotient positive, so g increases on the two outer intervals.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g decreases on (-infinity,3) as a single interval, crossing the excluded x=-1.', false, 'A monotonic interval cannot contain the point -1 where g is not defined.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g never decreases because the derivative is a quotient rather than a product.', false, 'A quotient can be negative; its sign is determined by numerator and denominator signs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g decreases on (-1,3) only, where the numerator and denominator have opposite signs.', true, 'Correct: For x<-1 the ratio is positive, for -1<x<3 it is negative, and for x>3 it is positive. The domain gap at -1 prevents merging across it.' from version_ins;
-- apcalcab-mcq-b10-sv-h-5.3-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b10-sv-h-5.3-c-v2', 'mcq', 'handle derivative sign across domain gaps (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function h has h''(x)=(x+2)/(x-1) wherever x≠1, and h is undefined at 1. Which statement is warranted by the derivative?', null, md5('apcalcab-mcq-b10-sv-h-5.3-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h decreases on both intervals to the left of 1 because the denominator is negative there.', false, 'For x<-2 both numerator and denominator are negative, making h'' positive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=1 is a critical point because h'' does not exist there, even though h itself is undefined.', false, 'An excluded input is not a point of h, so it cannot be a critical point on its graph.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h increases throughout (-infinity,infinity) because h'' is positive for large x.', false, 'Positive derivative for some large x-values does not establish increase on intervals where h''<0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h decreases on (-2,1) and increases on (-infinity,-2) and (1,infinity); x=1 is a domain break, not a critical point of h.', true, 'Correct: Across -2 and 1, ratio signs are positive, negative, positive. A critical point must be in the function''s domain; x=1 is excluded.' from version_ins;
-- apcalcab-mcq-b10-sv-h-5.3-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b10-sv-h-5.3-c-v3', 'mcq', 'handle derivative sign across domain gaps (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable p has p''(x)=(x-2)/(x+4) except at x=-4, where p is also undefined. A student says p increases on (-infinity,2) because the numerator is negative there. Which correction is correct?', null, md5('apcalcab-mcq-b10-sv-h-5.3-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'p increases on (-4,2) because a negative numerator always makes a quotient positive.', false, 'On (-4,2), the denominator is positive while the numerator is negative, so p''<0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'p increases on all x<2 as one interval because x=-4 is just an isolated point.', false, 'No monotonic interval can cross an input at which the function is undefined.' from version_ins
union all select gen_random_uuid(), id, 'C', 'p increases on (-infinity,-4) and (2,infinity), but decreases on (-4,2); the quotient changes sign at the excluded x=-4.', true, 'Correct: The ratio is positive for x<-4, negative for -4<x<2, and positive for x>2. The excluded point splits the domain and the derivative sign.' from version_ins
union all select gen_random_uuid(), id, 'D', 'p decreases on both outer intervals because the numerator has a zero at x=2.', false, 'A derivative zero at x=2 does not make the derivative negative on either outer interval.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b10-sv-h-5.3-c-v1','apcalcab-mcq-b10-sv-h-5.3-c-v2','apcalcab-mcq-b10-sv-h-5.3-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b10-sv-h-5.3-c-v1','apcalcab-mcq-b10-sv-h-5.3-c-v2','apcalcab-mcq-b10-sv-h-5.3-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
