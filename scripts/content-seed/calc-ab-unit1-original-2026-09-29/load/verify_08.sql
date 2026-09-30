with exp(content_key, h_stem, h_body) as (values
('apcalcab-mcq-u1v-015-v2','3dd99b428c36ba55f064efc4202d5731','e460ff2421eea874a6487a6bda7283e3'),
('apcalcab-mcq-u1v-015-v3','148ea8c7e469e4644588f259e0de0610','179207b5277b06f7a56fbc88ff17d675'),
('apcalcab-mcq-u1v-016-v1','07800bc8398ba6f94740f66aa45b74c8','4e741fe3d86fd11346451f4db1e601b6'),
('apcalcab-mcq-u1v-016-v2','0eb02f45d45817150affc2d2a592579f','f91c70dd66b1e78331e8cbd9ac5cc649'),
('apcalcab-mcq-u1v-016-v3','e374216709608dbc9635408206c1782a','4cd8c69ba3a6e0e0cce8aa41e9da7fa7'),
('apcalcab-mcq-u1v-017-v1','6eb137a5c0f1235abbd96f93eb6a9f2c','ff564cd3e08e82650ea58b98e5e4ad05'),
('apcalcab-mcq-u1v-017-v2','acd6898cc1af16c797ebd0f32c5d528b','9baf29d543bd8998c6211354098d712a'),
('apcalcab-mcq-u1v-017-v3','9a91581f1a8f2010349dd372601b8d6d','b9826c0e202e7e388e5dbc77055d6f66'),
('apcalcab-mcq-u1v-018-v1','25dc8ffbe15f68666d7cb0a918e854b7','547b70f5e5853a12abd7ee4c638d3ef4'),
('apcalcab-mcq-u1v-018-v2','99bf0188afa0e7e38a8d3393050cd57b','7f986b1970e36192972a4a6402001408'),
('apcalcab-mcq-u1v-018-v3','0c00a0143064cc9e8c6062b1d63543af','40f83e3c7c426849b2bf26162c36f599'),
('apcalcab-mcq-u1v-019-v1','7fa0a671bdb4888fcc36819fe51b02d6','d6f7e61d8cf212bc5c08b082ffc7eb5a')
), act as (
  select ci.content_key,
    case when ci.item_type = 'mcq'
      then md5(civ.stem)
      else md5(coalesce(civ.stem,'') || E'\n' || coalesce(civ.stimulus,'')) end as h_stem,
    case when ci.item_type = 'mcq'
      then md5((select string_agg(m.choice_text || '|' || m.is_correct::text || '|' || m.rationale, E'\n' order by (m.choice_text || '|' || m.is_correct::text || '|' || m.rationale) collate "C") from app.mcq_choices m where m.content_item_version_id = civ.id))
      else md5((select string_agg(c.criterion_key || '|' || c.learner_facing_text || '|' || c.points_possible::text || '|' || c.evidence_requirements || '|' || c.minimum_fix, E'\n' order by (c.criterion_key || '|' || c.learner_facing_text || '|' || c.points_possible::text || '|' || c.evidence_requirements || '|' || c.minimum_fix) collate "C") from app.frq_criteria c where c.content_item_version_id = civ.id)) end as h_body,
    ci.item_type, civ.canonical_answer_1,
    (select m.choice_key from app.mcq_choices m where m.content_item_version_id = civ.id and m.is_correct limit 1) as correct_letter
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id and civ.version_num = 1
  where ci.exam_pack_version_id = '826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and (ci.content_key like 'apcalcab-%-u1n-%' or ci.content_key like 'apcalcab-%-u1v-%')
)
select
  (select count(*) from exp) as expected_items,
  (select count(*) from act) as loaded_items,
  (select count(*) from exp e join act a using (content_key) where e.h_stem = a.h_stem and e.h_body = a.h_body) as exact_matches,
  (select coalesce(string_agg(e.content_key, ', '), 'none') from exp e join act a using (content_key) where e.h_stem <> a.h_stem or e.h_body <> a.h_body) as loaded_but_mismatched,
  (select count(*) from exp e left join act a using (content_key) where a.content_key is null) as not_yet_loaded,
  (select count(*) from act where item_type = 'mcq' and canonical_answer_1 is distinct from correct_letter) as letter_key_inconsistent;
