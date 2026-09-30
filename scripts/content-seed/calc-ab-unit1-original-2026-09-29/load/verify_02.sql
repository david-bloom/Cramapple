with exp(content_key, h_stem, h_body) as (values
('apcalcab-mcq-u1n-013','ca8f3cf7192fa877e878cff2938f8f6e','a1b5e29cf15b052298fc014356287835'),
('apcalcab-mcq-u1n-014','537bea144ac07f8007a84f690f8f4b53','240b13f95d325115316198abe9d22d96'),
('apcalcab-mcq-u1n-015','0cc87115e593d629f48ddea467876c83','3c2b2412e00539023b1f9f4b13988ade'),
('apcalcab-mcq-u1n-016','5940651a3fb0083d7e580cd5aa56160c','3b1150a8a02eb50a3d45576d8be17802'),
('apcalcab-mcq-u1n-017','390145ce42a6e70a1d2ae83f70dc116e','c3c9d2093bda45d2b27012ab014e8ff1'),
('apcalcab-mcq-u1n-018','e703a4e8718bde8ab4a3878d16cca962','7ffec00226c9d68fc22d15c4671e6257'),
('apcalcab-mcq-u1n-019','62df5a8c8b7fdd5e09444629f40f28b9','4b6be78d2e3e1cb5c9a60f518069217f'),
('apcalcab-mcq-u1n-020','2f6ee5154dc5dfa6411584edbd2add11','16214cb71aacce32fdb36bce0c8ba8f9'),
('apcalcab-mcq-u1n-021','f95dc3f428c2cf7cca5309b6ef775796','7d7d7466dabfb25b91a7f4052c7607c8'),
('apcalcab-mcq-u1n-022','58be755b81889e48d76c7af405eacb8b','524de63e6d78cbf9ecab5523e489f850'),
('apcalcab-mcq-u1n-023','3c9fbcc6d91001e202f6b0f80d5e77a2','8ec5e6cbf15c72592017488a351f0e70'),
('apcalcab-mcq-u1n-024','a7cdf71871a4da84308f4e6acc2caecd','380044af46c8ce934976138a55d4d8d7')
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
