import json,collections,sys
PRICE={'google/gemini-3.8-flash':(0.75e-6,3.75e-6),'deepseek/deepseek-v4-pro':(0.66e-6,1.98e-6)}
def cost(r):
    u=r.get('usage') or {}
    p=PRICE[r['model']]
    return u.get('inputTokens',0)*p[0]+u.get('outputTokens',0)*p[1]
m=[json.loads(l) for l in open('out_math/results.jsonl')]
print("== MATH: blind solve vs key")
solve=collections.defaultdict(dict)
for r in m:
    if r['pass']=='solve': solve[r['key']][r['model']]=r
dis=[]
for k,d in sorted(solve.items()):
    for mod,r in d.items():
        o=r['object']; ch=o.get('chosen_label')
        if ch!=r['keyed_label'] or o.get('defect') not in ('','none',None):
            dis.append((k,mod,ch,r['keyed_label'],o.get('defect','')[:200]))
print("solve rows:",sum(len(d) for d in solve.values()),"disagree-or-defect:",len(dis))
for x in dis: print("  ",x)
print("== MATH: audit flags")
flags=[]
for r in m:
    if r['pass']!='audit': continue
    o=r['object']
    bad=[c for c in o['per_choice'] if not c['rationale_accurate']]
    if (not o['keyed_choice_correct']) or bad or o['other_defects']:
        flags.append((r['key'],r['model'],o['keyed_choice_correct'],[(c['label'],c['issue'][:220]) for c in bad],[d[:200] for d in o['other_defects']]))
print("items flagged by >=1 auditor:",len({f[0] for f in flags}),"of",len({r['key'] for r in m}),"| flag rows",len(flags))
for f in flags: print("  ",f)
print("== COST (math check)")
tot=collections.defaultdict(float);ms=collections.defaultdict(list);tok=collections.defaultdict(lambda:[0,0])
for r in m:
    tot[r['model']]+=cost(r); ms[r['model']].append(r['ms'])
    u=r.get('usage') or {}; tok[r['model']][0]+=u.get('inputTokens',0); tok[r['model']][1]+=u.get('outputTokens',0)
for k in tot: print(k,f"${tot[k]:.4f}",tok[k],f"median {sorted(ms[k])[len(ms[k])//2]/1000:.1f}s")
print(f"math total ${sum(tot.values()):.4f} for {len({r['key'] for r in m})} items")
