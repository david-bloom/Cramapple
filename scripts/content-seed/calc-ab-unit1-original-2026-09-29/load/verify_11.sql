with exp(content_key, h_stem, h_body) as (values
('apcalcab-mcq-u1v-026-v3','592899cff9b531b590c6b68ed88d8464','7604ef2b1b3c6d832afc147e779570cb'),
('apcalcab-mcq-u1v-027-v1','5ca08dc4a6392ff4db1dc24df7a0c6ef','8f5f226df8429bf69ebbf820ee0ff3b4'),
('apcalcab-mcq-u1v-027-v2','daf26fa551fb5a79f8964659e3384746','e803c068f4083843f64feca9f48b7f14'),
('apcalcab-mcq-u1v-027-v3','4dc4fa2dec7e2096f98853bee0ec7d5a','4c58c80fedbbbf5eff30e6458f96dda0'),
('apcalcab-mcq-u1v-028-v1','f1160af16a560435b035cb38b44ec47b','bb55ba8c46b1975ec0996465b338a9c0'),
('apcalcab-mcq-u1v-028-v2','d92cfb508d905e255e381cd296d76f11','7b1d3f0dcb21259480963a0fce112abd'),
('apcalcab-mcq-u1v-028-v3','1752f9f67260e0693b41950f590b35df','1d1b0e1db016ac8294e34a2f74505b08'),
('apcalcab-mcq-u1v-029-v1','2b1ad52cf4ac7a7c7dfa95069040b7c6','44c69fe1b8414d45d69e89969646665c'),
('apcalcab-mcq-u1v-029-v2','d12166164c3eeef05c900c4eeb85cd29','1f52df0421e28e5ead3bffd1a66d1e51'),
('apcalcab-mcq-u1v-029-v3','7202b48351c962ef73f63b8fecc1f782','42d8c95fb8c51d2a309f2744d0015576')
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
