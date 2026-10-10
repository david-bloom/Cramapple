#!/usr/bin/env python3
"""Read-only: build the slot plan (Units 1-3 topics with fewer than 2 published FRQs) and fetch seed/exemplar FRQs."""
import importlib.util, json, os
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py'))
pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']
U13 = "case tsv.subject_key when 'ap_physics_2' then array[9,10,11] when 'ap_physics_c_em' then array[8,9,10] else array[1,2,3] end"
topics = pmb.query(REF, f"""
with u13 as (select t.taxonomy_source_version tsv, tsv.subject_key sk, t.unit_number u, t.unit_title ut, t.topic_code c, t.topic_title tt
  from app.taxonomy_topics t join app.taxonomy_source_versions tsv using (taxonomy_source_version) where t.unit_number = any({U13})),
frq as (select c.taxonomy_source_version tsv, c.topic_code, ci.content_key, v.id vid from app.content_item_cells c
  join app.content_items ci on ci.id=c.content_item_id join app.content_item_versions v on v.id=c.content_item_version_id and v.status='published'
  where ci.item_type='frq' and ci.status='published' and c.is_primary and c.superseded_by is null and c.skill_code is null)
select u13.sk, u13.tsv, u13.u, u13.ut, u13.c, u13.tt, coalesce((select json_agg(content_key order by content_key) from frq where frq.tsv=u13.tsv and frq.topic_code=u13.c),'[]') keys
from u13 order by sk, u, c""")
epv = {r['sk']: r['epv'] for r in pmb.query(REF, """select s.subject_key sk, epv.id epv from app.exam_pack_versions epv join app.exam_packs ep on ep.id=epv.exam_pack_id
  join app.subjects s on s.id=ep.subject_id where epv.status='published' and epv.id <> '7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada'""")}
slots, seeds = [], set()
for t in topics:
    keys = t['keys'] if isinstance(t['keys'], list) else json.loads(t['keys'])
    need = max(0, 2 - len(keys))
    if need:
        seeds.update(keys)
        slots.append(dict(subject_key=t['sk'], tsv=t['tsv'], unit=t['u'], unit_title=t['ut'], topic_code=t['c'], topic_title=t['tt'], existing=keys, need=need))
json.dump(slots, open(os.path.join(HERE, 'inputs', 'slots.json'), 'w'), indent=1)
json.dump(epv, open(os.path.join(HERE, 'inputs', 'exam_pack_versions.json'), 'w'), indent=1)
print(len(slots), 'topics,', sum(s['need'] for s in slots), 'FRQs needed,', len(seeds), 'single-FRQ seeds')
# seeds (the lone FRQ on a 1-FRQ topic) + one format exemplar per subject (most recent short FRQ in Units 1-3 with a topic cell)
ex = pmb.query(REF, f"""select distinct on (tsv.subject_key) ci.content_key from app.content_items ci
  join app.content_item_versions v on v.content_item_id=ci.id and v.status='published'
  join app.content_item_cells c on c.content_item_version_id=v.id and c.is_primary and c.superseded_by is null
  join app.taxonomy_source_versions tsv on tsv.taxonomy_source_version=c.taxonomy_source_version
  join app.taxonomy_topics t on t.taxonomy_source_version=c.taxonomy_source_version and t.topic_code=c.topic_code
  where ci.item_type='frq' and ci.status='published' and ci.frq_form='short' and t.unit_number = any({U13})
  and (select count(*) from app.frq_criteria fc where fc.content_item_version_id=v.id) between 3 and 7
  order by tsv.subject_key, v.published_at desc nulls last""")
keys = sorted(seeds | {r['content_key'] for r in ex})
lit = ','.join(pmb.lit(k) for k in keys)
items = pmb.query(REF, f"""select ci.content_key, ci.frq_form, ci.frq_archetype, ci.title, v.stem, v.stimulus, v.canonical_answer_1,
  (select json_agg(json_build_object('key',c.criterion_key,'points',c.points_possible,'text',c.learner_facing_text,'evidence',c.evidence_requirements,'fix',c.minimum_fix) order by c.criterion_key)
   from app.frq_criteria c where c.content_item_version_id=v.id) criteria
  from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id and v.status='published'
  where ci.content_key in ({lit}) and ci.item_type='frq' and ci.status='published'""")
json.dump({'seeds': sorted(seeds), 'exemplars': {r['content_key'] for r in ex} and sorted(r['content_key'] for r in ex), 'items': items},
          open(os.path.join(HERE, 'inputs', 'seed_items.json'), 'w'), indent=1)
print(len(items), 'seed/exemplar items fetched; exemplars:', sorted(r['content_key'] for r in ex))
