import json,collections,sys
bd=sys.argv[1] if len(sys.argv)>1 else 'out_vblind'; ad=sys.argv[2] if len(sys.argv)>2 else 'out_vaudit'
M={m['key']:m for m in json.load(open('math_items.json'))}
S={s['key']:s for s in json.load(open('seeds_u13.json'))}
tax=json.load(open('taxonomy.json')); U={t['code']:t['unit'] for t in tax['topics']}
B=collections.defaultdict(list);A=collections.defaultdict(list)
for l in open(bd+'/results.jsonl'):
    r=json.loads(l)
    if r['ok']: B[r['key']].append(r)
for l in open(ad+'/results.jsonl'):
    r=json.loads(l)
    if r['ok'] and r['pass']=='audit': A[r['key']].append(r)
flags={}
for k,m in M.items():
    f=[]
    for r in B.get(k,[]):
        mm=r['model'].split('/')[1];L=r['label']
        if L['chosen_label'].strip()!=m['keyed_label']: f.append((mm,'KEY','chose '+L['chosen_label']))
        if L['more_than_one_defensible_choice']: f.append((mm,'MULTI',''))
        if L['scope_verdict']!='fully_in_scope': f.append((mm,'SCOPE',str(L['out_of_scope_concepts'][:2])[:150]))
        mx=max(L['required_units']) if L['required_units'] else U.get(L['primary_topic_code'],0)
        if mx>3: f.append((mm,'UNIT>3',str(L['required_units'])))
    for r in A.get(k,[]):
        o=r['object'];mm=r['model'].split('/')[1]
        for c in o['per_choice']:
            if not c['rationale_accurate']: f.append((mm,'RAT '+c['label'],c['issue'][:200]))
        if not o['keyed_choice_correct']: f.append((mm,'AUDITKEY',''))
        for x in o['other_defects']: f.append((mm,'other',str(x)[:200]))
    if f: flags[k]=f
print(len(B),len(A),'flagged items',len(flags),'of',len(M),'| nodata',[k for k in M if len(B[k])<2 or len(A[k])<2][:5])
json.dump(flags,open('vflags.json','w'),indent=1,ensure_ascii=False)
for k,f in flags.items():
    print(k); [print('  ',x) for x in f]
