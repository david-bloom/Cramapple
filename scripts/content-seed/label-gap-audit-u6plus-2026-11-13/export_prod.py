#!/usr/bin/env python3
"""READ-ONLY export of every published content item's label state from Production (Stage 1 of the label-gap audit).
Writes raw/<exam_code>.json. Only SELECTs are issued. Production ref is taken from pmb.ENVS['prod'] and printed before use.
  python3 -I export_prod.py
"""
import importlib.util, json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py'))
pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']; assert REF == 'pcntajvbdfqhbeewmdry'
print('Production ref', REF)

SQL = """
select ci.id::text item_id, ci.content_key, ci.item_type, ci.frq_form, ci.status item_status, ci.exam_pack_version_id::text epv,
  civ.id::text vid, civ.version_num, civ.status vstatus, civ.prompt_json->>'unit' pj_unit, civ.prompt_json->>'topic' pj_topic,
  civ.prompt_json->'provenance'->>'kind' pkind, civ.prompt_json->'provenance'->>'seed_key' pseed,
  app.content_item_is_teaching(ci.id) teaching,
  app.taxonomy_relevant_hash(civ.id) h,
  (select count(*) from app.content_item_versions v2 where v2.content_item_id=ci.id and v2.status='published') n_pub_versions,
  coalesce((select jsonb_agg(jsonb_build_object('t',c.topic_code,'s',c.skill_code,'st',c.assignment_status,'p',c.is_primary,'unit',tt.unit_number))
     from app.content_item_cells c left join app.taxonomy_topics tt on tt.taxonomy_source_version=c.taxonomy_source_version and tt.topic_code=c.topic_code
     where c.content_item_version_id=civ.id),'[]'::jsonb) cells,
  (select count(*) from app.content_item_cells c where c.content_item_id=ci.id and c.content_item_version_id<>civ.id) cells_other_versions,
  coalesce((select jsonb_agg(jsonb_build_object('v',l.label_version,'st',l.label_status,'hm',(l.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)),
       'pu',l.primary_unit,'mx',l.max_required_unit,'ru',l.required_units,'sup',l.superseded_by is not null,'src',l.source,'ver',l.validated_against_version_id::text) order by l.label_version)
     from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving'),'[]'::jsonb) labels,
  coalesce((select jsonb_agg(jsonb_build_object('d',d.difficulty,'b',d.basis,'c',d.confidence))
     from app.content_item_difficulty d where d.content_item_version_id=civ.id),'[]'::jsonb) diffs
from app.content_items ci
join lateral (select * from app.content_item_versions v where v.content_item_id=ci.id order by v.version_num desc limit 1) civ on true
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id join app.exam_packs ep on ep.id=epv.exam_pack_id
where ep.exam_code='%s' and ci.status='published' order by ci.content_key
"""
codes = [r['exam_code'] for r in pmb.query(REF, "select exam_code from app.exam_packs order by 1")]
for code in codes:
    rows = pmb.query(REF, SQL % code)
    json.dump(rows, open(os.path.join(HERE, 'raw', code + '.json'), 'w'), indent=0, default=str)
    print(code, len(rows))
# taxonomy (units/topics/skills) per subject
tax = pmb.query(REF, """select tsv.subject_key, tsv.taxonomy_source_version::text tsv, tt.unit_number, tt.topic_code, tt.topic_title
  from app.taxonomy_source_versions tsv join app.taxonomy_topics tt using (taxonomy_source_version) order by 1,3,4""")
json.dump(tax, open(os.path.join(HERE, 'raw', '_taxonomy_topics.json'), 'w'))
skills = pmb.query(REF, """select tsv.subject_key, ts.skill_code from app.taxonomy_source_versions tsv join app.taxonomy_skills ts using (taxonomy_source_version) order by 1,2""")
json.dump(skills, open(os.path.join(HERE, 'raw', '_taxonomy_skills.json'), 'w'))
print('taxonomy topics', len(tax), 'skills', len(skills))
