import json,collections,sys
suf=sys.argv[1] if len(sys.argv)>1 else ''
IT=json.load(open('items.json')); M={m['key']:m for m in json.load(open('math_items.json'))}
def rd(p): return [json.loads(l) for l in open(p)] if True else []
B=collections.defaultdict(list);A=collections.defaultdict(list);S=collections.defaultdict(list);C=collections.defaultdict(list)
for p in ('em','cm','p2'):
    import os
    for k,d,tgt in (('b','out_vblind_'+p+suf,B),('a','out_vaudit_'+p+suf,None),('c','out_vced_'+p+suf,C)):
        f=d+'/results.jsonl'
        if not os.path.exists(f): continue
        for r in rd(f):
            if k=='b': 
                if r['ok']: B[r['key']].append(r)
            elif k=='a':
                if r['ok']: (A if r['pass']=='audit' else S)[r['key']].append(r)
            else: C[r.get('key') or r.get('content_key')].append(r)
for k,m in M.items():
    seed=k[4:].rsplit('-v',1)[0]; st,un=IT[seed][3],int(IT[seed][3].split('.')[0])
    out=[k[4:],'key',m['keyed_label'],'seed',st]
    out.append('blind:'+','.join(f"{r['label']['chosen_label'].strip()}/{r['label']['primary_topic_code'].split()[0]}/{r['label']['required_units']}/{'AMB' if r['label']['more_than_one_defensible_choice'] else ''}{r['label']['scope_verdict'][:4]}" for r in B[k]))
    out.append('solve:'+','.join(r['object']['chosen_label'].strip()+('!'+r['object']['defect'][:80] if r['object']['defect'] else '') for r in S[k]))
    for r in A[k]:
        o=r['object']
        bad=[(x['label'],x['issue'][:140]) for x in o['per_choice'] if not x['rationale_accurate']]
        if (not o['keyed_choice_correct']) or bad or o['other_defects']: out.append(f"AUDIT[{r['model'][:6]}] keyok={o['keyed_choice_correct']} {bad} {[d[:100] for d in o['other_defects']]}")
    for r in C[k]:
        o=r.get('object') or r.get('result') or r
        out.append('ced:'+str(o.get('scope_verdict'))+(' '+str(o.get('out_of_scope_concepts'))[:100] if o.get('out_of_scope_concepts') else '')+(' INC:'+str(o.get('internal_consistency_issues'))[:150] if o.get('internal_consistency_issues') else ''))
    print(' | '.join(map(str,out))); print()
