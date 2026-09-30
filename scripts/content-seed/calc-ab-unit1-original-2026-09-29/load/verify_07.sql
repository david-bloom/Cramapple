with exp(content_key, h_stem, h_body) as (values
('apcalcab-mcq-u1v-011-v3','f1a603f68a0080c1189a6c366fb03b38','24d28c0ae530b472146af1a76908dd00'),
('apcalcab-mcq-u1v-012-v1','359490193a5d409089c27ab00d975f47','2fa7d38d0ef94f5ea2c4c71ecaa0cc3b'),
('apcalcab-mcq-u1v-012-v2','be99a0cff0efa23bcb8fecc8ec887460','a4afe1a8ec4ed08fa318675e693fb706'),
('apcalcab-mcq-u1v-012-v3','e823602e5fb0444af795f2cdef76b255','16ee67210f154c22b98eddb8824365c4'),
('apcalcab-mcq-u1v-013-v1','04d8b4cb54bf70a23d1b93e2e0bc5c06','706c7390e135178e14c27fe024da59ab'),
('apcalcab-mcq-u1v-013-v2','7aa072c0d9d021f6949c99e558ce0a87','373929547b6a536e94cd7aff29f82ea7'),
('apcalcab-mcq-u1v-013-v3','b97ad338b851464456b0ff235232188f','6c6a1f1662ff06c47d9e86116fc31779'),
('apcalcab-mcq-u1v-014-v1','198e529bfa05c0010a1f3163de3a84bd','a2537e98827d1556ef3c38d85ec7698c'),
('apcalcab-mcq-u1v-014-v2','9cc96730314f09f818bf98717c270095','b20736e114c3968177d2a971090fdfa7'),
('apcalcab-mcq-u1v-014-v3','0416398ea622641fa289e52c0267deba','110c3a05f29f63b17bd4a8ddbc1f0d5c'),
('apcalcab-mcq-u1v-015-v1','1bf02f628a80a777ace1851cd6560245','744a25f0340c4b6bac9da69d5f7c3edc')
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
