begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.8-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b6-sv-h-1.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.8-b-v3', 'mcq', 'use a bound on |f| to squeeze a quotient f(x)/xⁿ, and recognize when the bound is too weak. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function k satisfies |k(x)| ≤ 5x² for all x. What can be concluded about lim(x→0) k(x)/x²?', null, md5('apcalcbc-mcq-b6-sv-h-1.8-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It equals 0, because |k(x)| is squeezed to 0', false, 'The bound gives k(x) → 0, but after dividing by x² the bound only says |k(x)/x²| ≤ 5, which does not force a limit of 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It equals 5, because the bound is 5x²', false, 'The bound is only an upper limit on |k(x)|/x²; k(x) = 3x² satisfies it and gives 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Nothing definite: k(x) = 3x² gives 3, while k(x) = 5x² sin(1/x) gives no limit', true, 'Correct: Both k(x) = 3x² and k(x) = 5x² sin(1/x) satisfy |k(x)| ≤ 5x², yet the quotients tend to 3 and oscillate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It does not exist, because k is not specified', false, 'A limit may exist or not depending on k; for k(x) = 3x² it exists and equals 3, so nonexistence is not forced.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.8-b-v3']) and status='draft')<>1 then raise exception 'chunk 8: expected 1 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b6-sv-h-1.8-b-v3']))<>4 then raise exception 'chunk 8: expected 4 choices'; end if;
end $$;
commit;
