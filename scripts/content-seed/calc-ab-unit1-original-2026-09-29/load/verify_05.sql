with exp(content_key, h_stem, h_body) as (values
('apcalcab-mcq-u1v-004-v1','7ab3960346bed9d820e51f488c340567','6c13a0e6f4430a358dc841f549d0d3f4'),
('apcalcab-mcq-u1v-004-v2','1873e73a893bbfd13be792af453336e2','e447d41c3599cb2948c5cb49b1e53e59'),
('apcalcab-mcq-u1v-004-v3','da9753fd0a00e90bc3863177f5d42b16','b8c885cc1491b4f0957f39bf28976052'),
('apcalcab-mcq-u1v-005-v1','c6438006b93295c1c102f9b84587c555','370ee1c4a3c72507151ca37fb9322067'),
('apcalcab-mcq-u1v-005-v2','1ffd7e2a51d88d461e81f0527a4076fe','f91bcf6790ff83c7a7ab4520ced8b24f'),
('apcalcab-mcq-u1v-005-v3','2826269104d17e4e603d27a4de032ce7','a3e62b0e0838849ed799030767b8a040'),
('apcalcab-mcq-u1v-006-v1','2266f7875de244914a358a21d6e2c0d8','aa4530dbaf9af8d6f1bddc78634428c9'),
('apcalcab-mcq-u1v-006-v2','e44ae8be7ef828164281d0cf9df38351','a21c260fbef83efac52bc90f0715fe1a'),
('apcalcab-mcq-u1v-006-v3','c194cdae504c704d250bdc8b8cc66bf4','12ef05e238805b6554008407db9e9113'),
('apcalcab-mcq-u1v-007-v1','6999ad860a053cf534d9b61367cf1f44','68872b0a7cccc1d08248db0364f7dd3e'),
('apcalcab-mcq-u1v-007-v2','cc1400c756d045c156d96f4ae7f2f89b','bc8a956855d8969c85484248cfabe708')
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
