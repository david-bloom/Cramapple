begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-sv-h-4.7-b-v2','apcalcbc-mcq-b4-sv-h-4.7-b-v3'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b4-sv-h-4.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.7-b-v2', 'mcq', 'rewrite a 0·∞ or 1^∞ form with a logarithm or a quotient so that L''Hôpital''s rule can be used, then evaluate the limit. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim (x→π/2⁻) (π/2 − x)·tan x?', null, md5('apcalcbc-mcq-b4-sv-h-4.7-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This takes the first factor to 0 and concludes the product is 0, but tan x grows without bound as x approaches π/2, so this is a 0·∞ form.' from version_ins
union all select gen_random_uuid(), id, 'B', '∞', false, 'This takes tan x to ∞ and concludes the product is unbounded, ignoring that π/2 − x tends to 0; the 0·∞ form must be rewritten as a quotient.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This rewrites as (π/2 − x)/cot x but takes the derivative of π/2 − x as +1 instead of −1, which flips the sign of the result.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', true, 'Correct: Rewrite as (π/2 − x)/cot x, a 0/0 form. L′Hôpital''s rule gives (−1)/(−csc² x) = sin² x, which tends to 1 as x → π/2.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.7-b-v3', 'mcq', 'rewrite a 0·∞ or 1^∞ form with a logarithm or a quotient so that L''Hôpital''s rule can be used, then evaluate the limit. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim (x→1) x^(3/(x − 1))?', null, md5('apcalcbc-mcq-b4-sv-h-4.7-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This treats 1^∞ as 1, but the base approaches 1 while the exponent grows without bound, which is an indeterminate form that must be resolved with a logarithm.' from version_ins
union all select gen_random_uuid(), id, 'B', 'e³', true, 'Correct: Let y = x^(3/(x−1)). Then ln y = 3·ln x/(x − 1), a 0/0 form. L′Hôpital''s rule gives 3·(1/x)/1, which tends to 3 as x → 1. So y → e³.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e', false, 'This finds lim ln x/(x − 1) = 1 but forgets the factor 3 in the exponent; the log of the expression is 3·ln x/(x − 1), which tends to 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '∞', false, 'This reasons that a base near 1 raised to an unbounded power must be unbounded, but the product 3·ln x/(x − 1) stays finite, so the result is finite.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-sv-h-4.7-b-v2','apcalcbc-mcq-b4-sv-h-4.7-b-v3']) and status='draft')<>2 then raise exception 'chunk 7: expected 2 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b4-sv-h-4.7-b-v2','apcalcbc-mcq-b4-sv-h-4.7-b-v3']))<>8 then raise exception 'chunk 7: expected 8 choices'; end if;
end $$;
commit;
