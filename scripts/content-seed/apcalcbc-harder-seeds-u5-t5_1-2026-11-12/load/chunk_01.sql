begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b8-h-5.1-a','apcalcbc-mcq-b8-sv-h-5.1-a-v1','apcalcbc-mcq-b8-sv-h-5.1-a-v2','apcalcbc-mcq-b8-sv-h-5.1-a-v3','apcalcbc-mcq-b8-h-5.1-b','apcalcbc-mcq-b8-sv-h-5.1-b-v1','apcalcbc-mcq-b8-sv-h-5.1-b-v2','apcalcbc-mcq-b8-sv-h-5.1-b-v3','apcalcbc-mcq-b8-h-5.1-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b8-h-5.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-h-5.1-a', 'mcq', 'derive MVT matching point', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x)=x^3-3x on [-2,2]. Which set contains every c in (-2,2) guaranteed by the Mean Value Theorem to satisfy f''(c)=[f(2)-f(-2)]/4?', null, md5('apcalcbc-mcq-b8-h-5.1-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'c=0 only', false, 'At c=0 the derivative is -3, not the secant slope 1; the equation has two solutions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'c=-2/sqrt(3) and c=2/sqrt(3)', true, 'Correct: The polynomial meets both hypotheses. f(2)=2 and f(-2)=-2, so the secant slope is 1. Solve 3c²-3=1 to get c²=4/3, hence both interior solutions ±2/sqrt(3).' from version_ins
union all select gen_random_uuid(), id, 'C', 'c=-2 and c=2', false, 'The theorem specifies c strictly inside the interval, and the endpoint derivatives do not equal 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No c exists because f'' changes sign on the interval.', false, 'A derivative may change sign while a polynomial remains continuous and differentiable; that does not invalidate MVT.' from version_ins;
-- apcalcbc-mcq-b8-sv-h-5.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-sv-h-5.1-a-v1', 'mcq', 'derive MVT matching point (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x)=x^3+2x on [-3,3]. What are all interior c values whose instantaneous slope equals the secant slope over the interval, as MVT guarantees?', null, md5('apcalcbc-mcq-b8-sv-h-5.1-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'c=0 only', false, 'G''(0)=2, which differs from the secant slope 11; two interior points work.' from version_ins
union all select gen_random_uuid(), id, 'B', 'c=-3 and c=3', false, 'Endpoints are excluded by the theorem, and their slopes are 29 rather than 11.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is no such c because g is increasing throughout the interval.', false, 'Increasing functions can still have an instantaneous slope equal to their average slope.' from version_ins
union all select gen_random_uuid(), id, 'D', 'c=-sqrt(3) and c=sqrt(3)', true, 'Correct: The secant slope is (g(3)-g(-3))/6=11. Since g''(x)=3x²+2, solving 3c²+2=11 gives c=±sqrt(3), both interior.' from version_ins;
-- apcalcbc-mcq-b8-sv-h-5.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-sv-h-5.1-a-v2', 'mcq', 'derive MVT matching point (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial h(x)=x^3-6x is examined on [-1,3]. Which interior c values make h''(c) equal to its average rate of change on that interval?', null, md5('apcalcbc-mcq-b8-sv-h-5.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'c=sqrt(7/3) only', true, 'Correct: h(-1)=5 and h(3)=9, so the secant slope is 1. h''(c)=3c²-6=1 gives c=±sqrt(7/3), but only the positive root lies in (-1,3).' from version_ins
union all select gen_random_uuid(), id, 'B', 'c=-1 and c=3', false, 'The endpoints are excluded and do not solve the derivative equation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'c=1 only', false, 'H''(1)=-3, so the midpoint is not the matching point.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No interior point is required because h has a local maximum.', false, 'A polynomial satisfies MVT even when it has extrema within the interval.' from version_ins;
-- apcalcbc-mcq-b8-sv-h-5.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-sv-h-5.1-a-v3', 'mcq', 'derive MVT matching point (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For p(x)=x^3 on [0,3], which interior value c has p''(c) equal to the average rate of change from 0 to 3?', null, md5('apcalcbc-mcq-b8-sv-h-5.1-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'c=3', false, 'C=3 is an endpoint, excluded by MVT, and p''(3)=27 rather than 9.' from version_ins
union all select gen_random_uuid(), id, 'B', 'c=1', false, 'P''(1)=3, which is below the average rate 9.' from version_ins
union all select gen_random_uuid(), id, 'C', 'c=sqrt(3)', true, 'Correct: The secant slope is (27-0)/3=9. Solving 3c²=9 gives c=±sqrt(3), but only +sqrt(3) lies in (0,3).' from version_ins
union all select gen_random_uuid(), id, 'D', 'No c exists because p''(0)=0 differs from the average rate.', false, 'Endpoint derivatives need not equal the secant slope; MVT guarantees an interior equality for this polynomial.' from version_ins;
-- apcalcbc-mcq-b8-h-5.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-h-5.1-b', 'mcq', 'check MVT hypotheses', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student applies MVT to f(x)=|x| on [-1,1] and says there must be an interior c with f''(c)=0 because the endpoint values agree. Which response is correct?', null, md5('apcalcbc-mcq-b8-h-5.1-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'MVT applies because f is continuous, and c=0 has derivative 0.', false, 'A cusp has no derivative at 0; continuity alone is insufficient for MVT.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The conclusion is not guaranteed: f is not differentiable at 0, and its derivative is -1 or +1 wherever defined inside.', true, 'Correct: The closed-interval continuity condition holds, but the open-interval differentiability condition fails at the cusp x=0. At other interior points f'' is ±1, never 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'MVT applies because f is differentiable at both endpoints.', false, 'Endpoint differentiability is not the theorem''s requirement and does not repair the interior cusp.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Every interior point works because the secant slope is 0.', false, 'A zero secant slope does not force each derivative to be zero, and here none is.' from version_ins;
-- apcalcbc-mcq-b8-sv-h-5.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-sv-h-5.1-b-v1', 'mcq', 'check MVT hypotheses (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For q(x)=sqrt(x) on [0,4], a student rejects MVT because q''(0) is undefined. Which conclusion is justified?', null, md5('apcalcbc-mcq-b8-sv-h-5.1-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'MVT applies: differentiability is required on (0,4), not at 0; the secant slope is 1/2 and q''(1)=1/2.', true, 'Correct: sqrt(x) is continuous on [0,4] and differentiable on (0,4). Its secant slope is (2-0)/4=1/2, and 1/(2sqrt(c))=1/2 gives c=1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'MVT fails because the derivative must exist at both endpoints of a closed interval.', false, 'The theorem asks for continuity at endpoints and differentiability only in the open interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'MVT applies, but the matching derivative occurs only at x=0.', false, 'X=0 is excluded from the sought interior point and has no finite derivative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'MVT fails because the graph is not a straight line.', false, 'MVT applies to nonlinear differentiable curves; the graph need not itself be a straight line.' from version_ins;
-- apcalcbc-mcq-b8-sv-h-5.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-sv-h-5.1-b-v2', 'mcq', 'check MVT hypotheses (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student uses MVT on r(x)=1/x over [-1,1], claiming that some interior tangent has slope [r(1)-r(-1)]/2=1. Which objection is decisive?', null, md5('apcalcbc-mcq-b8-sv-h-5.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'MVT applies because the endpoint values are finite, so a tangent of slope +1 is guaranteed.', false, 'Finite endpoint values do not imply continuity through the interval''s interior.' from version_ins
union all select gen_random_uuid(), id, 'B', 'r is undefined at 0, so it is not continuous on [-1,1]; in fact r''(x)=-1/x² never equals +1 where defined.', true, 'Correct: The domain gap at 0 breaks closed-interval continuity and open-interval differentiability. Every defined derivative is negative, while the endpoint secant slope is positive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'MVT fails only because r'' is undefined at x=-1 and x=1.', false, 'Endpoint derivative values are not required by MVT; the interior discontinuity is decisive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'MVT applies with c=0 because the two branches are symmetric.', false, 'The function and derivative are undefined at c=0, so symmetry supplies no MVT point.' from version_ins;
-- apcalcbc-mcq-b8-sv-h-5.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-sv-h-5.1-b-v3', 'mcq', 'check MVT hypotheses (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student applies MVT to s(x)=x^(2/3) on [-1,1], where both endpoint values equal 1, and concludes s''(c)=0 for some interior c. Which analysis is correct?', null, md5('apcalcbc-mcq-b8-sv-h-5.1-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cusp at 0 makes s nondifferentiable there; at every other interior x the derivative is nonzero, so MVT does not apply and no such c exists.', true, 'Correct: s is continuous, but s''(x)=(2/3)x^(-1/3) is undefined at 0 and nonzero elsewhere in (-1,1). The differentiability hypothesis fails.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The equal endpoints force c=0 with derivative 0.', false, 'A cusp derivative does not become zero merely because endpoint values match.' from version_ins
union all select gen_random_uuid(), id, 'C', 'MVT applies because s is continuous, regardless of interior differentiability.', false, 'MVT requires differentiability throughout the open interval as well as closed-interval continuity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The theorem guarantees c=-1 or c=1 because both are endpoint extrema.', false, 'The theorem seeks an interior point, not either endpoint.' from version_ins;
-- apcalcbc-mcq-b8-h-5.1-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-h-5.1-c', 'mcq', 'interpret average and instantaneous rate', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable distance function records 0 miles at noon and 150 miles at 3 p.m. It is continuous throughout the trip. A driver claims the instantaneous rate was always below 45 miles per hour. Which statement follows?', null, md5('apcalcbc-mcq-b8-h-5.1-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average rate is 45 miles per hour, so the claim could be correct.', false, '150 miles divided by three hours is 50 miles per hour, not 45.' from version_ins
union all select gen_random_uuid(), id, 'B', 'MVT guarantees the rate is 50 miles per hour at every moment of the trip.', false, 'MVT guarantees at least one interior time, not a constant rate at every time.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The endpoint data imply an average rate of 50 miles per hour, so MVT guarantees a time strictly between noon and 3 p.m. with instantaneous rate 50; the claim is incompatible.', true, 'Correct: The average rate is (150-0)/3=50. The stated continuity and differentiability imply at least one interior instantaneous rate of 50, contradicting an always-below-45 bound.' from version_ins
union all select gen_random_uuid(), id, 'D', 'MVT cannot apply because the distance at intermediate times is not listed.', false, 'An explicit formula or intermediate observations are unnecessary when the hypotheses and endpoints are known.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b8-h-5.1-a','apcalcbc-mcq-b8-sv-h-5.1-a-v1','apcalcbc-mcq-b8-sv-h-5.1-a-v2','apcalcbc-mcq-b8-sv-h-5.1-a-v3','apcalcbc-mcq-b8-h-5.1-b','apcalcbc-mcq-b8-sv-h-5.1-b-v1','apcalcbc-mcq-b8-sv-h-5.1-b-v2','apcalcbc-mcq-b8-sv-h-5.1-b-v3','apcalcbc-mcq-b8-h-5.1-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b8-h-5.1-a','apcalcbc-mcq-b8-sv-h-5.1-a-v1','apcalcbc-mcq-b8-sv-h-5.1-a-v2','apcalcbc-mcq-b8-sv-h-5.1-a-v3','apcalcbc-mcq-b8-h-5.1-b','apcalcbc-mcq-b8-sv-h-5.1-b-v1','apcalcbc-mcq-b8-sv-h-5.1-b-v2','apcalcbc-mcq-b8-sv-h-5.1-b-v3','apcalcbc-mcq-b8-h-5.1-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
