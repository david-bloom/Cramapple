import json,glob,collections
M={m['key']:m for m in json.load(open('seeds_math_items.json'))}
tax=json.load(open('taxonomy.json')); U={t['code']:t['unit'] for t in tax['topics']}
B=collections.defaultdict(list);A=collections.defaultdict(list);PR=collections.defaultdict(list)
for l in open('out_sblind/results.jsonl'):
    r=json.loads(l)
    if r['ok']: B[r['key']].append(r)
for l in open('out_saudit/results.jsonl'):
    r=json.loads(l)
    if r['ok'] and r['pass']=='audit': A[r['key']].append(r)
for f in glob.glob('out_probe_*/labels.jsonl'):
    for l in open(f):
        r=json.loads(l)
        if r['ok']: PR[r['key']].append(r['label'])
out={}
for k,m in M.items():
    f=[]
    rs=B[k]; ks=sum(r['label']['chosen_label'].strip()==m['keyed_label'] for r in rs)
    if ks<len(rs): f.append(f"KEY {ks}/{len(rs)}")
    mu=sum(r['label']['more_than_one_defensible_choice'] for r in rs)
    if mu: f.append(f"MULTI {mu}/{len(rs)}")
    sc=[(r['model'].split('/')[1][:5],r['label']['out_of_scope_concepts'][:2]) for r in rs if r['label']['scope_verdict']!='fully_in_scope']
    if sc: f.append(f"SCOPE {sc}")
    for r in A[k]:
        o=r['object']
        for c in o['per_choice']:
            if not c['rationale_accurate']: f.append(f"RAT {r['model'].split('/')[1][:5]} {c['label']}: {c['issue'][:150]}")
        if not o['keyed_choice_correct']: f.append('AUDITKEY '+r['model'].split('/')[1])
        for x in o['other_defects']: f.append(f"other {r['model'].split('/')[1][:5]}: {str(x)[:150]}")
    L=PR[k]; n=len(L)
    mx=collections.Counter(max(l['required_units']) if l['required_units'] else U.get(l['primary_topic_code'].split()[0],0) for l in L).most_common(1)[0]
    tp=collections.Counter(l['primary_topic_code'].split()[0] for l in L).most_common(1)[0]
    cnt=collections.Counter(u for l in L for u in set(l['required_units'])); req=sorted({u for u,c in cnt.items() if c>=4}|{mx[0]})
    out[k]=dict(cur_unit=m['cur_unit'],cur_status=m['cur_status'],topic=tp[0],tsup=tp[1],mu=mx[0],musup=mx[1],req=req,n=n,flags=f)
    print(f"{k[7:]:10} cur U{m['cur_unit']} {m['cur_status'][:4]} | cons topic {tp[0]:4}({tp[1]}) maxU {mx[0]}({mx[1]}) req {req} | {f if f else ''}")
json.dump(out,open('seed_analysis.json','w'),indent=1,ensure_ascii=False)
