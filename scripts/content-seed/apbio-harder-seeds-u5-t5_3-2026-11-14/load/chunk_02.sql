begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b3-sv-h-5.3-c-v1','apbio-mcq-b3-sv-h-5.3-c-v2','apbio-mcq-b3-sv-h-5.3-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apbio-mcq-b3-sv-h-5.3-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-sv-h-5.3-c-v1', 'mcq', 'pedigree two-child probability (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a fully penetrant autosomal trait, two unaffected parents have an affected child. Assume no new mutation and independent outcomes for later births. What is the probability that, among their next two children, both affected? Explain the parents’ inferred genotypes.', null, md5('apbio-mcq-b3-sv-h-5.3-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4; only one birth needs to be considered despite the question asking about two.', false, 'This uses a one-child probability or drops one of the possible two-child orders.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/8; the affected child shows that one parent must be homozygous recessive.', false, 'The parents are unaffected, so neither can be aa under complete penetrance; both are Aa.' from version_ins
union all select gen_random_uuid(), id, 'C', '0; two unaffected parents cannot have a child with a recessive trait.', false, 'Recessive inheritance allows unaffected carriers to have affected offspring.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/16; both parents must be heterozygous carriers (Aa × Aa), so each birth has a 1/4 affected chance.', true, 'Correct: Unaffected parents of an affected aa child must both carry a: Aa×Aa. Each later child independently has P(affected)=1/4 and P(unaffected)=3/4. For both affected among two children, the binomial/complement calculation gives 1/16.' from version_ins;
-- apbio-mcq-b3-sv-h-5.3-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-sv-h-5.3-c-v2', 'mcq', 'pedigree two-child probability (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a fully penetrant autosomal trait, two unaffected parents have an affected child. Assume no new mutation and independent outcomes for later births. What is the probability that, among their next two children, neither affected? Explain the parents’ inferred genotypes.', null, md5('apbio-mcq-b3-sv-h-5.3-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/4; only one birth needs to be considered despite the question asking about two.', false, 'This uses a one-child probability or drops one of the possible two-child orders.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/2; the affected child shows that one parent must be homozygous recessive.', false, 'The parents are unaffected, so neither can be aa under complete penetrance; both are Aa.' from version_ins
union all select gen_random_uuid(), id, 'C', '0; two unaffected parents cannot have a child with a recessive trait.', false, 'Recessive inheritance allows unaffected carriers to have affected offspring.' from version_ins
union all select gen_random_uuid(), id, 'D', '9/16; both parents must be heterozygous carriers (Aa × Aa), so each birth has a 1/4 affected chance.', true, 'Correct: Unaffected parents of an affected aa child must both carry a: Aa×Aa. Each later child independently has P(affected)=1/4 and P(unaffected)=3/4. For neither affected among two children, the binomial/complement calculation gives 9/16.' from version_ins;
-- apbio-mcq-b3-sv-h-5.3-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-sv-h-5.3-c-v3', 'mcq', 'pedigree two-child probability (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a fully penetrant autosomal trait, two unaffected parents have an affected child. Assume no new mutation and independent outcomes for later births. What is the probability that, among their next two children, at least one affected? Explain the parents’ inferred genotypes.', null, md5('apbio-mcq-b3-sv-h-5.3-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4; only one birth needs to be considered despite the question asking about two.', false, 'This uses a one-child probability or drops one of the possible two-child orders.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/8; the affected child shows that one parent must be homozygous recessive.', false, 'The parents are unaffected, so neither can be aa under complete penetrance; both are Aa.' from version_ins
union all select gen_random_uuid(), id, 'C', '7/16; both parents must be heterozygous carriers (Aa × Aa), so each birth has a 1/4 affected chance.', true, 'Correct: Unaffected parents of an affected aa child must both carry a: Aa×Aa. Each later child independently has P(affected)=1/4 and P(unaffected)=3/4. For at least one affected among two children, the binomial/complement calculation gives 7/16.' from version_ins
union all select gen_random_uuid(), id, 'D', '0; two unaffected parents cannot have a child with a recessive trait.', false, 'Recessive inheritance allows unaffected carriers to have affected offspring.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b3-sv-h-5.3-c-v1','apbio-mcq-b3-sv-h-5.3-c-v2','apbio-mcq-b3-sv-h-5.3-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b3-sv-h-5.3-c-v1','apbio-mcq-b3-sv-h-5.3-c-v2','apbio-mcq-b3-sv-h-5.3-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
