import importlib.util, json, os, sys
HERE=os.path.dirname(os.path.abspath(__file__))
spec=importlib.util.spec_from_file_location('pmb',os.path.join(HERE,'..','..','publish_mcq_batch.py'))
pmb=importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF=pmb.ENVS['prod']; assert REF=='pcntajvbdfqhbeewmdry'
keys="apcalcbc-frq-u13-014 apchem-frq-l-017 apphy1-mcq-022 apphycm-frq-003 apprecalc-frq-np2-010 APSTAT-MOD4-H001-INV APSTAT-MOD5-H001-INV".split()
inl=",".join("'%s'"%k for k in keys)
rows=pmb.query(REF,f"""select ci.content_key, ci.id::text item_id, ci.status, ci.frq_form, ci.item_type, civ.id::text vid, civ.version_num, civ.status vstatus,
 civ.prompt_json, 
 (select jsonb_agg(jsonb_build_object('t',c.topic_code,'s',c.skill_code,'st',c.assignment_status,'p',c.is_primary)) from app.content_item_cells c where c.content_item_version_id=civ.id) cells,
 (select jsonb_agg(jsonb_build_object('v',l.label_version,'st',l.label_status,'ru',l.required_units,'pu',l.primary_unit,'src',l.source)) from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving') labels
from app.content_items ci join lateral (select * from app.content_item_versions v where v.content_item_id=ci.id order by version_num desc limit 1) civ on true
where ci.content_key in ({inl})""")
json.dump(rows,open(os.path.join(HERE,'prod_state.json'),'w'),indent=1,default=str)
for r in rows:
    pj=r['prompt_json'] or {}
    print('=====',r['content_key'],r['status'],r['vstatus'],'v',r['version_num'],r['frq_form'])
    print(' pj keys',list(pj.keys()), 'unit',pj.get('unit'),'topic',pj.get('topic'))
    print(' parts',json.dumps(pj.get('parts'))[:600])
    print(' cells',r['cells']); print(' labels',r['labels'])
