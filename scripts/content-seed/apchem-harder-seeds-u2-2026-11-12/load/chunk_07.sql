begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-sv-h-2.7-b-v2','apchem-mcq-b5-sv-h-2.7-b-v3'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apchem-mcq-b5-sv-h-2.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.7-b-v2', 'mcq', 'use electron-domain repulsion, including the greater repulsion of lone pairs, to explain observed deviations in bond ang (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the trigonal bipyramidal electron-domain geometry, the ideal angle between two equatorial positions is 120°. In SF₄, which has this electron-domain geometry, the equatorial F–S–F angle is about 102°. Which explanation best accounts for the smaller angle?', null, md5('apchem-mcq-b5-sv-h-2.7-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sulfur has 34 valence electrons, which compresses every bond angle by the same amount.', false, 'Sulfur has 6 valence electrons and the molecule has 34 in total, and the number of electrons does not equally compress the angles of the molecule.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The lone pair attracts the equatorial fluorine atoms and pulls them toward each other.', false, 'A lone pair repels bonding pairs, so it pushes the fluorine atoms away from it and does not pull them.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fluorine atoms are small, so they can approach each other more closely than the bonding pairs would allow.', false, 'Bond angles in VSEPR come from repulsions between electron domains and not from the sizes of the outer atoms.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The lone pair sits in an equatorial position and repels the two equatorial bonding pairs more strongly than they repel each other, pushing them closer together.', true, 'Correct: SF₄ has 5 electron domains (4 bonds, 1 lone pair); the lone pair repels bonding pairs more strongly than they repel one another, so the equatorial angle falls below 120°.' from version_ins;
-- apchem-mcq-b5-sv-h-2.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.7-b-v3', 'mcq', 'use electron-domain repulsion, including the greater repulsion of lone pairs, to explain observed deviations in bond ang (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The O–S–O bond angle is about 109.5° in the sulfate ion, SO₄²⁻, and about 106° in the sulfite ion, SO₃²⁻, in Lewis diagrams that give sulfur an octet in both ions. Which explanation best accounts for the smaller angle in SO₃²⁻?', null, md5('apchem-mcq-b5-sv-h-2.7-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'SO₃²⁻ has fewer oxygen atoms, so there is less space for them and they must be closer together.', false, 'Having fewer oxygen atoms would leave more room around sulfur and not less, and the angle changes because of the lone pair.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sulfur in SO₃²⁻ has a lone pair that repels the three bonding pairs more strongly than they repel one another, compressing the O–S–O angle.', true, 'Correct: SO₄²⁻ has 4 bonding domains and no lone pair (tetrahedral, 109.5°); SO₃²⁻ has 3 bonding domains and 1 lone pair (trigonal pyramidal), and the lone pair compresses the angles below 109.5°.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The extra negative charge of SO₃²⁻ attracts the oxygen atoms to each other.', false, 'Negative charge does not attract oxygen atoms to each other, and they carry partial negative charges that repel each other.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sulfite sulfur is bonded to oxygen by double bonds, which are shorter and so pull the oxygen atoms together.', false, 'In the octet-rule diagram of SO₃²⁻ all S–O bonds are single, and bond length is not what sets the angle.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-sv-h-2.7-b-v2','apchem-mcq-b5-sv-h-2.7-b-v3']) and status='draft')<>2 then raise exception 'chunk 7: expected 2 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b5-sv-h-2.7-b-v2','apchem-mcq-b5-sv-h-2.7-b-v3']))<>8 then raise exception 'chunk 7: expected 8 choices'; end if;
end $$;
commit;
