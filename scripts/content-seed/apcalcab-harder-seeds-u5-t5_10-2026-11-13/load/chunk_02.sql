begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b17-sv-h-5.10-c-v1','apcalcab-mcq-b17-sv-h-5.10-c-v2','apcalcab-mcq-b17-sv-h-5.10-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b17-sv-h-5.10-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b17-sv-h-5.10-c-v1', 'mcq', 'cost-weighted cylinder objective (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cylindrical container must hold 64π cubic units. It has one circular base and no top. Material for each circular face costs 1 currency units per square unit, and material for the curved side costs 1 per square unit. If r>0 is the radius and h is height, which cost function of r alone should be minimized?', null, md5('apcalcab-mcq-b17-sv-h-5.10-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C(r)=1πr²+64π/r, for r>0.', false, 'The curved area is 2πrh; dropping its factor 2 undercounts side material.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C(r)=1πr²+128πr, for r>0.', false, 'Substituting h=V/(πr²) makes the curved cost proportional to 1/r, not r.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C(r)=1πr²+128π/r, for r>64.', false, 'Radius has no lower bound of the numerical volume; every positive radius yields a positive height.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C(r)=1πr²+128π/r, for r>0.', true, 'Correct: The volume constraint πr²h=64π gives h=64/r². Face cost is 1πr²; curved-side cost is 1(2πrh)=128π/r. Any r>0 gives a positive h.' from version_ins;
-- apcalcab-mcq-b17-sv-h-5.10-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b17-sv-h-5.10-c-v2', 'mcq', 'cost-weighted cylinder objective (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cylindrical container must hold 54π cubic units. It has two circular caps. Material for each circular face costs 2 currency units per square unit, and material for the curved side costs 1 per square unit. If r>0 is the radius and h is height, which cost function of r alone should be minimized?', null, md5('apcalcab-mcq-b17-sv-h-5.10-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C(r)=4πr²+54π/r, for r>0.', false, 'The curved area is 2πrh; dropping its factor 2 undercounts side material.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C(r)=4πr²+108πr, for r>0.', false, 'Substituting h=V/(πr²) makes the curved cost proportional to 1/r, not r.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C(r)=4πr²+108π/r, for r>54.', false, 'Radius has no lower bound of the numerical volume; every positive radius yields a positive height.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C(r)=4πr²+108π/r, for r>0.', true, 'Correct: The volume constraint πr²h=54π gives h=54/r². Face cost is 4πr²; curved-side cost is 1(2πrh)=108π/r. Any r>0 gives a positive h.' from version_ins;
-- apcalcab-mcq-b17-sv-h-5.10-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b17-sv-h-5.10-c-v3', 'mcq', 'cost-weighted cylinder objective (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cylindrical container must hold 200π cubic units. It has one circular base and no top. Material for each circular face costs 1 currency units per square unit, and material for the curved side costs 2 per square unit. If r>0 is the radius and h is height, which cost function of r alone should be minimized?', null, md5('apcalcab-mcq-b17-sv-h-5.10-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C(r)=1πr²+400π/r, for r>0.', false, 'The curved area is 2πrh; dropping its factor 2 undercounts side material.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C(r)=1πr²+800πr, for r>0.', false, 'Substituting h=V/(πr²) makes the curved cost proportional to 1/r, not r.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C(r)=1πr²+800π/r, for r>0.', true, 'Correct: The volume constraint πr²h=200π gives h=200/r². Face cost is 1πr²; curved-side cost is 2(2πrh)=800π/r. Any r>0 gives a positive h.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C(r)=1πr²+800π/r, for r>200.', false, 'Radius has no lower bound of the numerical volume; every positive radius yields a positive height.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b17-sv-h-5.10-c-v1','apcalcab-mcq-b17-sv-h-5.10-c-v2','apcalcab-mcq-b17-sv-h-5.10-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b17-sv-h-5.10-c-v1','apcalcab-mcq-b17-sv-h-5.10-c-v2','apcalcab-mcq-b17-sv-h-5.10-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
