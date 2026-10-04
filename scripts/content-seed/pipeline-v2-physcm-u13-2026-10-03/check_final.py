import sys
D=sys.argv[1] if len(sys.argv)>1 else ''
import json,collections
K={a['key']:a['keyed_label'] for a in json.load(open('final_check_items.json'))}
res=collections.defaultdict(list);bad=set()
for l in open(f'out_fblind{D}/results.jsonl'):
    r=json.loads(l)
    if not r['ok']: print('BLINDERR',r['key']);bad.add(r['key']);continue
    L=r['label']
    if L['chosen_label'].strip()!=K[r['key']] or L['more_than_one_defensible_choice'] or L['scope_verdict']!='fully_in_scope': res[r['key']].append(f"BLIND {r['model']}: {L['chosen_label']} multi={L['more_than_one_defensible_choice']} scope={L['scope_verdict']} {L['out_of_scope_concepts']}")
for l in open(f'out_faudit{D}/results.jsonl'):
    r=json.loads(l)
    if not r['ok']: print('AUDERR',r['key']);continue
    o=r['object']
    if r['pass']=='solve':
        if o['chosen_label'].strip()!=K[r['key']] or o['defect']: res[r['key']].append(f"SOLVE {r['model']} {o['chosen_label']} {o['defect'][:150]}")
    else:
        if not o['keyed_choice_correct']: res[r['key']].append('AUDITKEY '+r['model'])
        for c in o['per_choice']:
            if not c['rationale_accurate']: res[r['key']].append(f"RAT {r['model']} {c['label']}: {c['issue'][:200]}")
        for x in o['other_defects']: res[r['key']].append(f"other {r['model']}: {str(x)[:200]}")
for k in sorted(res): print(k); [print('   ',x) for x in res[k]]
print('items with issues:',len(res),'of',len(K))
