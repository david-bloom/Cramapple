with exp(content_key, h_stem, h_body) as (values
('apcalcab-frq-u1v-003-v1','ad0ef87abad0701e5cb5973d0904ee8f','f98efd7360c7f999a4f29d45ec0c6733'),
('apcalcab-frq-u1v-003-v2','c1676f5c8b5de9e67cdf8703fd0409f1','6990008ec89f6830acd6ae850d683747'),
('apcalcab-frq-u1v-003-v3','277cce0a6fd24093177d60df0192cb78','41fa5b2569cf6a6958d0cf75ec596066'),
('apcalcab-frq-u1v-004-v1','abd960f43178f9a8c44674522b58f917','4254ef7f7715e602d238b5e02d52d040'),
('apcalcab-frq-u1v-004-v2','58f0d130fe285e401fca3b4433675c06','5dc0bf04a372f567abe9e6cbce485951'),
('apcalcab-frq-u1v-004-v3','0ef51fc794141fdff8f46fd84381a1bb','b75e2d676ed6227907de09cc9c591bdd')
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
