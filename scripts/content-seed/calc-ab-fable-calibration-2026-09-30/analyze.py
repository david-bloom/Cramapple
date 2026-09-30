import json,collections
mp=json.load(open('anon_map.json'))
PRICE={'anthropic/claude-fable-5.1':(10e-6,50e-6),'google/gemini-3.8-flash':(0.75e-6,3.75e-6),'deepseek/deepseek-v4-pro':(0.66e-6,1.98e-6)}
def load(p): return [json.loads(l) for l in open(p)]
def summarize(rows,label):
    solve_bad=collections.defaultdict(set); flags=collections.defaultdict(dict)
    for r in rows:
        if not r['ok']: print("ERROR",r['key'],r['model']); continue
        o=r['object']
        if r['pass']=='solve':
            if o['chosen_label']!=r['keyed_label']: solve_bad[r['key']].add(r['model'])
        else:
            bad=[(c['label'],c['issue'][:230]) for c in o['per_choice'] if not c['rationale_accurate']]
            flags[r['key']][r['model']]=(bool(bad) or (not o['keyed_choice_correct']) or bool(o['other_defects']),bad,o['other_defects'],o['keyed_choice_correct'])
    return solve_bad,flags
def cost(rows):
    c=collections.defaultdict(float);t=collections.defaultdict(lambda:[0,0])
    for r in rows:
        u=r.get('usage') or {};p=PRICE[r['model']];c[r['model']]+=u.get('inputTokens',0)*p[0]+u.get('outputTokens',0)*p[1];t[r['model']][0]+=u.get('inputTokens',0);t[r['model']][1]+=u.get('outputTokens',0)
    return dict(c),dict(t)
F=load('out_fable/results.jsonl'); R=load('out_rerun/results.jsonl')
sb,fl=summarize(F,'fable')
print("== FABLE (blind, 48 items)")
print("solve disagreements with stored key:",{mp[k]['orig']+' ['+mp[k]['group']+']':list(v) for k,v in sb.items()})
by=collections.defaultdict(lambda:[0,0])
for k,d in fl.items():
    g=mp[k]['group']; f=d['anthropic/claude-fable-5.1'][0]; by[g][0]+=f; by[g][1]+=1
for g,(a,b) in sorted(by.items()): print(f"  {g:18s} flagged {a}/{b}")
print("== per item (Fable flags)")
for k,d in sorted(fl.items()):
    m=mp[k]; f=d['anthropic/claude-fable-5.1']
    if f[0] or m['group'] in('seed_flagged','control_prepatch'):
        print(f"  {k} {m['group']:16s} {m['orig']:34s} fable={'FLAG' if f[0] else 'clean'} {f[1] if f[0] else ''} {f[2][:1] if f[2] else ''}")
sb2,fl2=summarize(R,'rerun')
print("== FIXED-POINT RERUN (Gemini 3.8 + DeepSeek V4 Pro again on 24 unchanged final variants)")
print("solve disagreements:",sb2)
n=0
for k,d in sorted(fl2.items()):
    for mod,f in d.items():
        if f[0]: n+=1; print("  NEW FLAG",mp[k]['orig'],mod.split('/')[1],f[1],f[2][:1])
print("flag rows on unchanged final text:",n)
cf,tf=cost(F);cr,tr=cost(R)
print("cost fable $%.2f"%sum(cf.values()),tf,"| rerun $%.2f"%sum(cr.values()))
