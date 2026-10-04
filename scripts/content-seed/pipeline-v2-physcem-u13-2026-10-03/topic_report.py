import json,collections,sys
bd=sys.argv[1];ad=sys.argv[2]
M={m['key']:m for m in json.load(open('math_items.json'))}
S={s['key']:s for s in json.load(open('seeds_u13.json'))}
B=collections.defaultdict(list);A=collections.defaultdict(list);SV=collections.defaultdict(list)
for l in open(bd+'/results.jsonl'):
    r=json.loads(l)
    if r['ok']:B[r['key']].append(r)
for l in open(ad+'/results.jsonl'):
    r=json.loads(l)
    if r['ok']:(A if r['pass']=='audit' else SV)[r['key']].append(r)
rows=[];bad=0
for k,m in M.items():
    seed=S[k[4:].rsplit('-v',1)[0]]
    tp=[r['label']['primary_topic_code'].split()[0] for r in B[k]]
    ru=[sorted(r['label']['required_units']) for r in B[k]]
    keys=[r['label']['chosen_label'].strip()==m['keyed_label'] for r in B[k]]
    sk=[r['object']['chosen_label'].strip()==m['keyed_label'] for r in SV[k]]
    sd=[r['object']['defect'][:120] for r in SV[k] if r['object']['defect']]
    tmatch=sum(t==seed['topic'] for t in tp); umatch=sum(int(t.split('.')[0])==seed['unit'] for t in tp)
    ok=all(keys) and len(keys)==2 and all(sk) and tmatch>=1 and umatch==len(tp)
    rows.append((k[4:],seed['topic'],tp,ru,m['keyed_label'],keys,sk,len(A[k]),sd))
    if not (len(keys)==2 and all(keys) and all(sk) and umatch==len(tp)) or tmatch<2 or any(max(u)>seed['unit'] for u in ru if u) or sd: print(rows[-1])
print(len(rows),'audit calls missing:',[k[4:] for k in M if len(A[k])<2])
