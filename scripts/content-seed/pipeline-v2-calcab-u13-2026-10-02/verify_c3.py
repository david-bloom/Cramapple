import json, re, sympy as sp
import build_c3 as B
seeds={s['key']:s for s in json.load(open('seeds_final.json'))}
def same(a,b):
    if isinstance(a,bool) or isinstance(b,bool): return a==b
    d=sp.sympify(a)-sp.sympify(b)
    return abs(complex(sp.N(d.subs(B.x,0.3))))<1e-12 and abs(complex(sp.N(d.subs(B.x,0.17))))<1e-12
def toks(v): return set((v['stem']+' '+' '.join([v['correct']['text']]+[w['text'] for w in v['wrong']])).lower().split())
def stoks(sd): return set((sd['stem']+' '+' '.join([sd['correct']['text']]+[w['text'] for w in sd['wrong']])).lower().split())
def jac(a,b): return len(a&b)/len(a|b)
ok_all=True
for v in B.V:
    errs=[]
    ch=[v['correct']]+v['wrong']
    for c in ch:
        if c['calc'] is None or not same(c['claim'],c['calc']): errs.append('mismatch: '+c['text'])
    ex=v.get('extra')
    if ex:
        pt={B.x:ex['pt'][0],B.y:ex['pt'][1]}
        Fx=sp.diff(ex['F'],B.x).subs(pt); Fy=sp.diff(ex['F'],B.y).subs(pt)
        if abs(complex(sp.N(ex['F'].subs(pt))))>1e-12: errs.append('pt not on curve')
        if abs(complex(sp.N(-Fx/Fy-ex['slope'])))>1e-12: errs.append('idiff mismatch')
    cl=[c['claim'] for c in ch]
    if not all(isinstance(c,bool) for c in cl):
        vals=[complex(sp.N(sp.sympify(c).subs(B.x,0.3))) for c in cl]
        if len(set((round(z.real,9),round(z.imag,9)) for z in vals))!=4: errs.append('non-distinct values')
    elif len(set(c['text'] for c in ch))!=4: errs.append('dup text')
    if re.search(r'(^|\s)[A-D][\.\)]\s',v['stem']): errs.append('option list in stem')
    L=len(v['correct']['text']); mx=max(len(w['text']) for w in v['wrong'])
    if L>1.4*mx and mx>12: errs.append(f'length {L} vs {mx}')
    for c in ch:
        if not c['rationale'] or (c is not v['correct'] and not c['error_pattern']): errs.append('missing text')
    sd=seeds[v['seed']]
    j=jac(toks(v),stoks(sd))
    if j>=0.7: errs.append('jaccard seed %.2f'%j)
    for w in B.V:
        if w is not v and w['seed']==v['seed'] and jac(toks(v),toks(w))>=0.7: errs.append('jaccard sibling '+w['id'])
    print(v['id'],'OK' if not errs else 'FAIL '+'; '.join(errs),'(max jac seed %.2f)'%j); ok_all&=not errs
js=[dict(id=v['id'],seed=v['seed'],difficulty=v['difficulty'],title=v['title'],stem=v['stem'],
 correct=dict(text=v['correct']['text'],rationale=v['correct']['rationale']),
 wrong=[dict(text=w['text'],rationale=w['rationale'],error_pattern=w['error_pattern']) for w in v['wrong']],
 change_note=v['change_note'],check=v['check']) for v in B.V]
if ok_all and len(js)==30:
    json.dump(js,open('variants_c3.json','w'),ensure_ascii=False,indent=1); print('ALL 30 OK; wrote variants_c3.json')
else: print('FAILURES')
