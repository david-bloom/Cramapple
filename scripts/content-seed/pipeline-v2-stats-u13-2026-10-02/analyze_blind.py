#!/usr/bin/env python3
"""Combine the blind pass (out_blind) and the audit (out_audit) per item. Flags: key disagreement, more-than-one-defensible, CED scope (union of models), topic/unit consensus vs registered."""
import json,glob,collections,sys
P={p['content_key']:p for p in json.load(open('packets.json'))}
tax=json.load(open('taxonomy.json')); U={t['code']:t['unit'] for t in tax['topics']}
B=collections.defaultdict(list)
for f in glob.glob('out_blind*/results.jsonl'):
    for l in open(f):
        r=json.loads(l)
        if r['ok']: B[r['key']].append(r)
A=collections.defaultdict(list)
for f in glob.glob('out_audit*/results.jsonl'):
    for l in open(f):
        r=json.loads(l)
        if r['ok'] and r['pass']=='audit': A[r['key']].append(r)
out={}
for k,p in P.items():
    rs=B.get(k,[]); key=None
    if p['item_type']=='mcq': key=[c['label'] for c in p['choices'] if c['is_correct']][0]
    d=dict(type=p['item_type'],reg_topic=p['primary_topic'],reg_unit=p['current_primary_unit'],label_status=p['current_label_status'])
    d['key_disagree']=[r['model'].split('/')[1] for r in rs if key and r['label']['chosen_label'].strip()!=key]
    d['multi_defensible']=[r['model'].split('/')[1] for r in rs if r['label']['more_than_one_defensible_choice']]
    d['scope']=[(r['model'].split('/')[1],r['label']['out_of_scope_concepts'][:2]) for r in rs if r['label']['scope_verdict']!='fully_in_scope']
    d['topics']=[r['label']['primary_topic_code'] for r in rs]; d['units']=[max(r['label']['required_units']) if r['label']['required_units'] else U.get(r['label']['primary_topic_code'],0) for r in rs]
    af=[]
    for r in A.get(k,[]):
        o=r['object']
        for c in o['per_choice']:
            if not c['rationale_accurate']: af.append((r['model'].split('/')[1],c['label'],c['issue'][:220]))
        if not o['keyed_choice_correct']: af.append((r['model'].split('/')[1],'KEY','audit: keyed choice not correct'))
        for x in o['other_defects']: af.append((r['model'].split('/')[1],'other',str(x)[:200]))
    d['audit']=af
    out[k]=d
json.dump(out,open('analysis.json','w'),indent=1,ensure_ascii=False)
mcq=[k for k,d in out.items() if d['type']=='mcq']
print("items",len(out),"| MCQ",len(mcq))
print("MCQ key disagrees (any model):",sum(1 for k in mcq if out[k]['key_disagree']),"| both models:",sum(1 for k in mcq if len(out[k]['key_disagree'])==2))
print("MCQ more-than-one-defensible:",sum(1 for k in mcq if out[k]['multi_defensible']),"| both:",sum(1 for k in mcq if len(out[k]['multi_defensible'])==2))
print("scope flagged (any model):",sum(1 for d in out.values() if d['scope']),"| both:",sum(1 for d in out.values() if len(d['scope'])==2))
print("MCQ audit-flagged:",sum(1 for k in mcq if out[k]['audit']),"| both models:",sum(1 for k in mcq if len({m for m,_,_ in out[k]['audit']})==2))
tu=collections.Counter(); 
for k,d in out.items():
    if len(d['topics'])==2:
        tu['topic agree between models']+= d['topics'][0]==d['topics'][1]
        tu['unit agree between models']+= d['units'][0]==d['units'][1]
        tu['topic agrees with registered (both)']+= all(t==d['reg_topic'] for t in d['topics'])
        tu['unit of model topics == registered unit (both)']+= (d['reg_unit'] is not None and all(u==d['reg_unit'] for u in d['units']))
print(dict(tu))
