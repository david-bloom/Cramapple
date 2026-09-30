with exp(content_key, h_stem, h_body) as (values
('apcalcab-mcq-u1v-007-v3','1685c8a3ca457abecf1b45ec8dbd3719','45b30b4805058a3eb38dd7b449b6b75d'),
('apcalcab-mcq-u1v-008-v1','dc7a5302acce7115724ab45598170caf','3f34ee970af3e6a7e853a512e30db99a'),
('apcalcab-mcq-u1v-008-v2','cb04e137c4e902d0022f284be6db17ea','683cf1089d5ef59eb1779c50b01d09a2'),
('apcalcab-mcq-u1v-008-v3','c7307db23ad7f306a0dbd88c153e8769','7284131efd990bcfac8d04f8c2600e2a'),
('apcalcab-mcq-u1v-009-v1','2a55cfe2c90af5c2c2492e319fbbaa7d','71c1b15264f60a56f0f8802cb6604fdb'),
('apcalcab-mcq-u1v-009-v2','bef2570c0d2363aa0b9970aabf0824df','f0db674d5ca90079404b285e9b3253c3'),
('apcalcab-mcq-u1v-009-v3','07f2471edb8b0a48624486a974ddc249','95ccaf9181da7a9c0fc4c327fb508f96'),
('apcalcab-mcq-u1v-010-v1','5e7477853eb48efe53fc53d3b56f1f81','bcafaf43a9513839ce616d2db8d401ec'),
('apcalcab-mcq-u1v-010-v2','225d7ffc7b1e1eb8c9ad351870b0cfae','b5058645fc483c09651dcc8053c52d20'),
('apcalcab-mcq-u1v-010-v3','bae9548a5637cede361db4a658862f9f','203d320eed860442051fe44c66fc7b91'),
('apcalcab-mcq-u1v-011-v1','242c8d6fcbb981989b1bdc1e2894a20e','26f799b1de25bcabe67644bc8887e766'),
('apcalcab-mcq-u1v-011-v2','870cc266086dec0f2b51b5ee23762dfa','2eb144b1b9693f801ff2297bcfb7e936')
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
