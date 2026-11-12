begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.8-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apchem-mcq-b6-sv-h-1.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.8-b-v3', 'mcq', 'combine electron transfer, ionic charges and formula ratios to count ions and transferred electrons in a sample. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of lithium nitride, Li₃N, contains 3.61 × 10²³ lithium ions, Li⁺. Which row correctly gives the number of nitride ions, N³⁻, in the sample and the total number of electrons transferred from lithium atoms to nitrogen atoms when the sample formed?', null, md5('apchem-mcq-b6-sv-h-1.8-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.08 × 10²⁴ N³⁻ ions; 3.61 × 10²³ electrons.', false, 'This multiplies the number of Li⁺ ions by three; Li₃N has three Li⁺ for each N³⁻, so the N³⁻ count is one third of the Li⁺ count.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.20 × 10²³ N³⁻ ions; 1.08 × 10²⁴ electrons.', false, 'This gives each Li atom three electrons, using the charge of the nitride ion; each Li atom loses only one.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.20 × 10²³ N³⁻ ions; 3.61 × 10²³ electrons.', true, 'Correct: N³⁻ = 3.61 × 10²³ ÷ 3 = 1.20 × 10²³; electrons = 1 × 3.61 × 10²³ (equals 3 × 1.20 × 10²³ gained by N).' from version_ins
union all select gen_random_uuid(), id, 'D', '3.61 × 10²³ N³⁻ ions; 1.08 × 10²⁴ electrons.', false, 'This assumes one N³⁻ per Li⁺, which does not balance the charge; Li₃N requires three Li⁺ to balance one N³⁻.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.8-b-v3']) and status='draft')<>1 then raise exception 'chunk 8: expected 1 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b6-sv-h-1.8-b-v3']))<>4 then raise exception 'chunk 8: expected 4 choices'; end if;
end $$;
commit;
