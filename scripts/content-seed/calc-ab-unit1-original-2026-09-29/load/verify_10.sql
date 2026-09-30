with exp(content_key, h_stem, h_body) as (values
('apcalcab-mcq-u1v-023-v1','7078c00b8a9a6794a934db4ad5f751a9','2854d3e4e676c4fa00e4736fc8c8c54e'),
('apcalcab-mcq-u1v-023-v2','7adc0ed84e2b205c37494f8c0d12456a','4b10aefc9bf04fcde070ccbca2293c19'),
('apcalcab-mcq-u1v-023-v3','25be0957ba993eb61607985d5d20e582','b905fd7435e3995199821550323482f3'),
('apcalcab-mcq-u1v-024-v1','76a37c775d1deed2bbb018d7b85eb113','3497950d83ecf78679d933ab4578c2fa'),
('apcalcab-mcq-u1v-024-v2','96de502e7fa693bbab27ba4eaf1f08e5','6ddfbd84b2925b55be8feb942f0adb7b'),
('apcalcab-mcq-u1v-024-v3','f5dea8b32384a49d83e87db26d75d136','bd93f28ffb9d2fb8a71dc08a6c3acf4d'),
('apcalcab-mcq-u1v-025-v1','f6116bd5eaa1dcb6c316831e8e7b48d0','c3d769560d7457ead735ef38ce1114ec'),
('apcalcab-mcq-u1v-025-v2','a04030188c4a761432063864c304a17e','fab76db1fb46429c99c36033f862f041'),
('apcalcab-mcq-u1v-025-v3','5a22a694b5581a63b8593824c119991b','ae1cf99a7d1b88a9fbc37762ed89d8a7'),
('apcalcab-mcq-u1v-026-v1','e007422191c6328305bed7472e266c4c','ad25e23fa354304fee9a4988c721b7a8'),
('apcalcab-mcq-u1v-026-v2','44b8685c9983f359227830b7757aa2fa','c4f3dd09a07aaf05bfc00b9df3a6a9ff')
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
