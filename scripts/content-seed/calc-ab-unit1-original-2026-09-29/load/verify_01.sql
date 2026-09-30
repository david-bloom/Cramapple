with exp(content_key, h_stem, h_body) as (values
('apcalcab-mcq-u1n-001','db3b0ed6e8a6b5cd9a6ceaebbd59bff7','5d5ccdd45804188b09c32d00435118fa'),
('apcalcab-mcq-u1n-002','6b8ecd4f2488a2c36c5f5e3bda8df6a1','4556cd0587f9fe368d74b9b05d26147b'),
('apcalcab-mcq-u1n-003','c65ed2371d44f52795f79c5473cac97c','26765a856d4f071e8f6936e05f3c318d'),
('apcalcab-mcq-u1n-004','39a04720a9ac3265c5c66c5565bce71b','0994c3135a904577c46758f1bbbe5cbd'),
('apcalcab-mcq-u1n-005','607e34f5f51bdb068d8fd695aa4acf6f','eceb5474b251b48ce7d4d2ccf73d3938'),
('apcalcab-mcq-u1n-006','3ad0ccf42dc9bf8cdb5954c77ee57d41','f5b38a8f3e72357b7fa63b1c0066eb8c'),
('apcalcab-mcq-u1n-007','8ad717f3e43f1ec58cbfb92c857672d3','2148e40efe69658e77c1774f3a5d5ede'),
('apcalcab-mcq-u1n-008','2599264ae2a1f87ee8fec2c594eb52a4','ec830a4afdeca411b4b6a317f0e5aee9'),
('apcalcab-mcq-u1n-009','7a85d94f50b9e9f2fb19eb08b12502ce','8e4a2e5d1b57523216ab33af85798c8c'),
('apcalcab-mcq-u1n-010','09086230c3fb92271e8e324f97a09fc7','d074e00cdc522f5ceb99d4334d438c1d'),
('apcalcab-mcq-u1n-011','3b1b2b150d3043681892930465e5d971','fd4e6c9761ea0357bfc86a72eb76c3a7'),
('apcalcab-mcq-u1n-012','ee796b57763481d753d1a915ec56a8f2','dbf186ef0c7d69f2739fb3d753240288')
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
