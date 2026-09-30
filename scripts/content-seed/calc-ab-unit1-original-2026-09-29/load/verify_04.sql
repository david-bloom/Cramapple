with exp(content_key, h_stem, h_body) as (values
('apcalcab-frq-u1n-005','10eb5ddcfd1ce72ff108a0ce820552aa','05f2e1a989a21d3414d33cc8cb45919b'),
('apcalcab-mcq-u1v-001-v1','97aa191dd38c2428cbc719b4ba6d3d1d','b35c44b9ebc723ef7709851859a688bc'),
('apcalcab-mcq-u1v-001-v2','495836ef0d5772aa21a0b3d52aaa6379','535203f112e12c9b12b386dc57df901b'),
('apcalcab-mcq-u1v-001-v3','7873e87d1a4ef04c8d59699a473e43d0','28e4144b05632d4698dde07441e80ec3'),
('apcalcab-mcq-u1v-002-v1','045b5a63c58c304a4be2fd40c1696f63','0c5bf984ef49f7a9ed019d058efc629c'),
('apcalcab-mcq-u1v-002-v2','b2331cf849e83acce5f61642a20ef702','335be9cfd5e0c7f58f0c825b1e3aa141'),
('apcalcab-mcq-u1v-002-v3','acf81ab2bcc52bf7b698f63d88c10a26','0b890ecfb2fa9313249853666a34e0bd'),
('apcalcab-mcq-u1v-003-v1','b7a594f5318e58b3787a937baeec24e1','768571c67c943fc9f06d74586400ac4e'),
('apcalcab-mcq-u1v-003-v2','1fe8f8dc72282d319ee4079435edf23a','c9c0933cdc59f000881390594424e435'),
('apcalcab-mcq-u1v-003-v3','1cd00b8021e95ee2cc1ce765e1e0cbc3','1a06c745cb37d27be4e80913ee3f2c99')
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
