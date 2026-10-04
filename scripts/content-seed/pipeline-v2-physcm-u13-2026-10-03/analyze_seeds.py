import json,glob,collections
M={m['key']:m for m in json.load(open('seeds_math_items.json'))}
S={s['key']:s for s in json.load(open('seeds_all.json'))['candidate_seeds']}
tax=json.load(open('taxonomy.json')); U={t['code']:t['unit'] for t in tax['topics']}
B=collections.defaultdict(list);A=collections.defaultdict(list);SV=collections.defaultdict(list);PR=collections.defaultdict(list)
for l in open('out_sblind/results.jsonl'):
    r=json.loads(l)
    if r['ok']: B[r['key']].append(r)
for l in open('out_saudit/results.jsonl'):
    r=json.loads(l)
    if r['ok']: (A if r['pass']=='audit' else SV)[r['key']].append(r)
for f in glob.glob('out_probe_*/labels.jsonl'):
    for l in open(f):
        r=json.loads(l)
        if r['ok']: PR[r['key']].append(r['label'])
out={}
for k,m in M.items():
    f=[]
    rs=B[k]; ks=sum(r['label']['chosen_label'].strip()==m['keyed_label'] for r in rs)
    ss=sum(r['label']['chosen_label'].strip()==m['keyed_label'] for r in []) 
    sk=sum(r['object']['chosen_label'].strip()==m['keyed_label'] for r in SV[k])
    f.append(f"blindKEY {ks}/{len(rs)} solveKEY {sk}/{len(SV[k])}")
    mu=sum(r['label']['more_than_one_defensible_choice'] for r in rs)
    if mu: f.append(f"MULTI {mu}/{len(rs)}")
    for r in SV[k]:
        if r['object']['defect']: f.append("SOLVEDEFECT "+r['model'].split('/')[1][:5]+": "+r['object']['defect'][:150])
    sc=[(r['model'].split('/')[1][:5],r['label']['out_of_scope_concepts'][:3]) for r in rs if r['label']['scope_verdict']!='fully_in_scope']
    if sc: f.append(f"SCOPE {sc}")
    for r in A[k]:
        o=r['object']
        for c in o['per_choice']:
            if not c['rationale_accurate']: f.append(f"RAT {r['model'].split('/')[1][:5]} {c['label']}: {c['issue'][:160]}")
        if not o['keyed_choice_correct']: f.append('AUDITKEY '+r['model'])
        for x in o['other_defects']: f.append(f"other {r['model'].split('/')[1][:5]}: {str(x)[:160]}")
    L=PR[k]
    mxs=collections.Counter(max(l['required_units']) if l['required_units'] else U.get(l['primary_topic_code'].split()[0],0) for l in L)
    mx=mxs.most_common(1)[0]
    tp=collections.Counter(l['primary_topic_code'].split()[0] for l in L).most_common(1)[0]
    un=collections.Counter(U.get(l['primary_topic_code'].split()[0],0) for l in L).most_common(1)[0]
    out[k]=dict(keyed=m['keyed_label'],db_mru=S[k]['max_required_unit'],db_status=S[k]['label_status'],topic=tp[0],topic_votes=f"{tp[1]}/{len(L)}",topic_unit=un[0],maxU=mx[0],maxU_votes=f"{mx[1]}/{len(L)}",maxU_dist=dict(mxs),flags=f)
    print(k[7:],'db',S[k]['max_required_unit'],S[k]['label_status'][:4],'| topic',tp,'unit',un,'maxU',dict(mxs)); [print('    ',x) for x in f]
json.dump(out,open('seed_analysis.json','w'),indent=1,ensure_ascii=False)
