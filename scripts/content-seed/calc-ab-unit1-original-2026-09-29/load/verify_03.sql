with exp(content_key, h_stem, h_body) as (values
('apcalcab-frq-u1n-001','4b9669a2df32d9d8ec59fc88d3fedaf2','5a7d9a18a90c503d63fb372d412b67e1'),
('apcalcab-frq-u1n-002','23324333e3fde67a3facb0448338a4ea','7eb0fee89d75e82453d947410ed42242'),
('apcalcab-frq-u1n-003','43ea97dc9cedacb77187b32e5b7a241b','eb9be051731ae270ed457eeab1497189'),
('apcalcab-frq-u1n-004','2a948317f8952ff242fe6e66f46f3820','c1dc327ab6b1d4c2c10feb860bdf119d'),
('apcalcab-mcq-u1n-025','b20ce2d4739e49f9d1adcb84d3244b05','827c1cf27df7acb3c0ec240423f87622'),
('apcalcab-mcq-u1n-026','58b267ab2db916a0655fe83244e32889','077e9cf645542075e2ba29676dbdfa72'),
('apcalcab-mcq-u1n-027','8261474cbfc8da555b080ece1902c894','038fc7191f49d8ddd970cf1b7ffd91f4'),
('apcalcab-mcq-u1n-028','591293af043c8661b687eea2e332154b','fb82737719441359ab714e823ee66ee4'),
('apcalcab-mcq-u1n-029','ecd1ed074bd14617131bf5a792622d77','47344cf9bc2ea3ffd2a44059bbe7982c')
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
