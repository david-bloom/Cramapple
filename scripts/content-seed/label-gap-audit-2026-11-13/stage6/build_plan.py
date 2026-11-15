#!/usr/bin/env python3 -I
"""Apply rubric_edits.EDITS to the pulled Production rubrics; write plan.json (new criteria, new prompt_json, totals). Offline."""
import json, os, copy, sys
HERE=os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0,HERE)
from rubric_edits import EDITS
rows={r['content_key']:r for r in json.load(open(os.path.join(HERE,'rubric_held_full.json')))}
plan=[]
for ck,ops in EDITS.items():
    r=rows[ck]; crit={c['criterion_key']:copy.deepcopy(c) for c in r['crit']}
    order=sorted(crit)
    for op in ops:
        kind,key=op[0],op[1]
        if kind=='set':
            c=crit[key]
            for f,v in zip(('learner_facing_text','evidence_requirements','minimum_fix'),op[2:]):
                if v is not None: c[f]=v
        elif kind=='add':
            assert key not in crit
            crit[key]={'criterion_key':key,'learner_facing_text':op[2],'evidence_requirements':op[3],'minimum_fix':op[4],'points_possible':1,'accepted_variants':[],'judgement_kind':'text'}
        elif kind=='del':
            del crit[key]
    pj=copy.deepcopy(r['prompt_json'] or {}); old_total=sum(c['points_possible'] for c in r['crit'])
    for p in pj.get('parts',[]):
        pre=p['part_key']+'-criterion'
        keys=sorted(k for k in crit if k.startswith(pre))
        p['criteria']=[{'criterion_key':k,'points':crit[k]['points_possible']} for k in keys]
        p['points']=sum(crit[k]['points_possible'] for k in keys)
    if pj.get('parts'):
        assert sum(p['points'] for p in pj['parts'])==sum(c['points_possible'] for c in crit.values()), ck
    pj['content_version']=r['version_num']+1
    pj['qa_remediation']='2026-11-13 rubric preflight repair (APPROVAL pending): criteria aligned to the operations the prompt asks'
    plan.append({'content_key':ck,'old_version_id':r['vid'],'old_version_num':r['version_num'],'stem':r['stem'],'stimulus':r['stimulus'],
      'prompt_json':pj,'criteria':[crit[k] for k in sorted(crit)],'old_total':old_total,'new_total':sum(c['points_possible'] for c in crit.values()),
      'ops':[[o[0],o[1]] for o in ops]})
json.dump(plan,open(os.path.join(HERE,'plan.json'),'w'),indent=1,ensure_ascii=False)
for p in plan: print(p['content_key'],p['old_total'],'->',p['new_total'],p['ops'])
