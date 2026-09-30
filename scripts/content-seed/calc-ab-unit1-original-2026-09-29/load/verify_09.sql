with exp(content_key, h_stem, h_body) as (values
('apcalcab-mcq-u1v-019-v2','d70d4d0c4ae72cc733616dfe4124a464','800b5b9d71d982971725311041e76b24'),
('apcalcab-mcq-u1v-019-v3','baa700dcb16d7ee39a94aabe4ec3de0e','3d9c1087e98202d0df75a35417eb65eb'),
('apcalcab-mcq-u1v-020-v1','08ef55a576dfc1c6cb7a5bea0b404b20','9ceec64b62833a155d796d10df6f8174'),
('apcalcab-mcq-u1v-020-v2','f23b2f54fabb8401fee420dfed7b29d5','284444580f6a275cb6302d847452791e'),
('apcalcab-mcq-u1v-020-v3','d00cd03e9760013f9064ab73368b4aeb','ba9b1cf7b835c719dc9251ebee337851'),
('apcalcab-mcq-u1v-021-v1','7190ca3f7d458f437f65d6125e77a405','41a2e4688a1c6114afeedc5bc10d9f63'),
('apcalcab-mcq-u1v-021-v2','7d073135f633a2d4f6a0b3242514dad4','d4da7475ecb67a58e4bc15097dfc54f1'),
('apcalcab-mcq-u1v-021-v3','fefa465444fd6c7518bfa6ef33edf514','2d89842d694676f83f3fd0e481ab2e63'),
('apcalcab-mcq-u1v-022-v1','6ad590d8626f23258211bdd661b7e68d','967a63a508a778d77b967794ce1a47af'),
('apcalcab-mcq-u1v-022-v2','d825a8059e46d5cce744c860aa3caebd','fb195c02f90442bde303946aa4090525'),
('apcalcab-mcq-u1v-022-v3','d4ebd52f9d3fbf7ddcd1627d1e9322c1','472376a0da836ad887ec7dfd4d0752ce')
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
