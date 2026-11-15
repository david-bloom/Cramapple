#!/usr/bin/env python3 -I
"""Residue round 5 load files. Read-only on Production. Topic = >=5 of the votes on one topic; units named by >=4 of the votes.
Statistics items already have a validated primary topic cell: it is KEPT (cell_action None) and the serving label is made consistent with it
(primary unit = that cell's unit); the vote disagreement is recorded in basis_note."""
import importlib.util, json, os, collections
HERE=os.path.dirname(os.path.abspath(__file__)); ROOT=os.path.join(HERE,'..')
spec=importlib.util.spec_from_file_location('pmb',os.path.join(ROOT,'..','publish_mcq_batch.py')); pmb=importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF=pmb.ENVS['prod']; assert REF=='pcntajvbdfqhbeewmdry'
PLAN={'apphy1-mcq-022':('ap_physics_1','mcq',None),'apphycm-frq-003':('ap_physics_c_mechanics','frq',None),'apchem-frq-l-017':('ap_chemistry','frq',None),
      'APSTAT-MOD4-H001-INV':('ap_statistics','frq','1.13'),'APSTAT-MOD5-H001-INV':('ap_statistics','frq','5.2')}
def load(f):
    d=collections.defaultdict(list)
    if os.path.exists(f):
        for l in open(f):
            v=json.loads(l)
            if v['ok']: d[v['key']].append(v)
    return d
a=load(os.path.join(ROOT,'stage3/votes.jsonl')); b=load(os.path.join(ROOT,'stage3_rerun/votes.jsonl'))
tax=json.load(open(os.path.join(ROOT,'raw/_taxonomy_topics.json'))); tunit={(t['subject_key'],t['topic_code']):t['unit_number'] for t in tax}
inl=','.join(pmb.lit(k) for k in PLAN)
st=pmb.query(REF,f"""select ci.content_key k, ci.id::text iid, v.id::text vid, v.status vs,
 (select coalesce(max(label_version),0) from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving') maxlv,
 (select coalesce(jsonb_agg(l.content_taxonomy_label_id::text),'[]'::jsonb) from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null) active_labels,
 (select string_agg(distinct l.label_status,',') from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null) active_status
 from app.content_items ci join lateral (select * from app.content_item_versions x where x.content_item_id=ci.id order by version_num desc limit 1) v on true where ci.content_key in ({inl})""")
S={r['k']:r for r in st}; out=collections.defaultdict(list)
for k,(sub,ty,cell_topic) in PLAN.items():
    vs=b.get(k) or a.get(k); n=len(vs)
    t=collections.Counter(v['label']['primary_topic_code'] for v in vs); top,tv=t.most_common(1)[0]
    uc=collections.Counter(u for v in vs for u in set(v['label']['required_units'])); ru=sorted(u for u,c in uc.items() if c>=4)
    s=S[k]; assert s['vs']=='published', (k,s)
    if cell_topic is None:
        assert tv>=5, (k,t); topic=top; ca='insert'; note='Blind six-vote probe: topic >= 5 of the votes cast; units named by >= 4. Topic sits in a unit different from the unit recorded before; the item was not served before this label, so nothing served changes.'
    else:
        topic=cell_topic; ca=None; note=f'Existing validated primary topic cell {cell_topic} KEPT unchanged. Topic votes were {dict(t)}; serving label made consistent with the existing cell (primary unit = its unit); required units named by >= 4 votes.'
    pu=tunit[(sub,topic)]; assert pu in ru,(k,pu,ru)
    out[sub].append({'content_key':k,'subject':sub,'item_id':s['iid'],'vid':s['vid'],'item_type':ty,'kind':'seed','unit_before':pu,'topic':topic,'primary_unit':pu,
      'required_units':ru,'max_required_unit':max(ru),'method':'six_vote_probe_residue_r5','basis_note':note,'topic_votes':dict(t),'unit_votes':{str(u):c for u,c in uc.items()},
      'cell_action':ca,'cell_id':None,'label_action':'insert_validated','label_version':s['maxlv']+1,'supersedes':s['active_labels'],'prior_label_status':s['active_status'],'hold_reason':'unit_or_cell_conflict_residue'})
for sub,rs in out.items():
    json.dump(rs,open(os.path.join(HERE,'load',f'load_{sub}.json'),'w'),indent=1); print(sub,[(r['content_key'],r['topic'],r['primary_unit'],r['required_units'],r['cell_action'],r['prior_label_status'],r['topic_votes']) for r in rs])
