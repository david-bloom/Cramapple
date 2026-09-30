with exp(content_key, h_stem, h_body) as (values
('apcalcab-frq-u1v-001-v1','a088716b313239b4ce726a72910e1d23','b132c2d67391da657bd5abda8499b1a3'),
('apcalcab-frq-u1v-001-v2','aae9ee42e90379a85bd1493c1752f2bf','b2cc07f424ff0bad7ef856a4fbffa3a6'),
('apcalcab-frq-u1v-001-v3','e678d22ed9945762b5ae5efa5c5429f8','95e4e002a374370c39d0fa4d6d440af4'),
('apcalcab-frq-u1v-002-v1','5eec17073ca5a887f418d08d4d73516f','981b43b83a0cd3858563f10ad4126dd7'),
('apcalcab-frq-u1v-002-v2','13e145c67e161cc7e3ad03d21d67f8d3','6892294b960615a365208ab34bd6f2de'),
('apcalcab-frq-u1v-002-v3','d306ef9e37fd3c30c6c51cafe7f1ef29','a50cc733baa92c5335684e9b70e1255e')
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
