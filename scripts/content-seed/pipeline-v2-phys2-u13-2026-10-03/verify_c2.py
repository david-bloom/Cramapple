import json,re,os,itertools
d=os.path.dirname(os.path.abspath(__file__))
V=json.load(open(os.path.join(d,'variants_c2.json')))
# live seed text (Production, published versions, read 2026-10-03)
S={
'apphy2-mcq-008':'A 12 V battery drives 3 A through a resistor. Its resistance is 0.25 Ω 4 Ω 9 Ω 36 Ω',
'apphy2-mcq-009':"Immediately after an uncharged capacitor is connected through a resistor to a battery, the capacitor behaves approximately like an open circuit a wire a charged battery a resistor with the same resistance as the series resistor",
'apphy2-mcq-021':'At fixed temperature and volume, doubling the number of ideal-gas molecules makes pressure half as large unchanged twice as large four times as large',
'apphy2-mcq-022':"Two rods have equal dimensions and temperature difference. Rod A has twice Rod B's thermal conductivity. The steady conduction rate through A is half as large the same twice as large four times as large",
'apphy2-mcq-023':'Two different ideal gases initially separated at the same temperature mix in an insulated container. The total entropy decreases stays constant increases becomes zero',
'apphy2-mcq-024':"Identical isolated conducting spheres carry charges +6Q and 0. They touch and separate. After separating, the two spheres' charges are +6Q and 0 +3Q and +3Q +6Q and +6Q 0 and 0",
}
W=lambda s:set(re.findall(r"\w+",s.lower()))
jac=lambda a,b:len(W(a)&W(b))/len(W(a)|W(b))
vt=lambda v:v['stem']+' '+v['correct']['text']+' '+' '.join(w['text'] for w in v['wrong'])
def num(t):
    t=t.replace('−','-'); return float(re.search(r'[+-]?\d+(\.\d+)?',t).group())
def close(a,b): return abs(a-b)<=max(0.011*abs(b),0.0006) or (abs(a-b)<=0.051 and abs(b*10-round(b*10))<1e-9)
g=lambda f:f  # no-op
# charge sharing simulation
def share(q,i,j):
    m=(q[i]+q[j])/2; q[i]=q[j]=m
q=[12,0,0]; share(q,0,1); share(q,1,2); sim3=q[:]
q2=[12,0,0]; share(q2,0,1)
E={ # id: [correct, wrong1, wrong2, wrong3] in stated order of the JSON
'apphy2-mcq-008-v1':[120/5.0,5.0/120,120-5.0,120*5.0],
'apphy2-mcq-008-v2':[9.0/45,45/9.0,45-9.0,9.0*45],
'apphy2-mcq-008-v3':[0.30*6.0/1.5,0.30*1.5/6.0,0.30,0.30+(6.0-1.5)],
'apphy2-mcq-009-v1':[12/400*1000,0,12/400*1000/2,None],
'apphy2-mcq-009-v2':[0,9.0,9.0/2,18.0],
'apphy2-mcq-009-v3':[20/2000*1000,0,0.63*20/2000*1000,0.37*20/2000*1000],
'apphy2-mcq-021-v2':[2.0*450/300,2.0*177/27,2.0*300/450,2.0*(450/300)**2],
'apphy2-mcq-024-v1':[-8/2,None,None,None],
'apphy2-mcq-024-v2':[(9-3)/2,(9-3),0,None],
}
F={ # factor items: [correct, w1, w2, w3] as multiplicative factors given in text order
'apphy2-mcq-021-v1':[3,1/3,9,1],
'apphy2-mcq-021-v3':[(1/2)/(1/3),3,6,(1/2)*(1/3)],
'apphy2-mcq-022-v1':[80/40,40/80,1,(80/40)**2],
'apphy2-mcq-022-v2':[1/2,2,1,1/4],
'apphy2-mcq-022-v3':[(3*0.5)/3,1,2,3*3*0.5],
}
WORD={'unchanged':1,'three times the original':3,'one-third of the original':1/3,'nine times the original':9,
 '1.5 times as large':1.5,'3.0 times as large':3,'6.0 times as large':6,'one-sixth as large':1/6,
 'twice as large':2,'half as large':.5,'four times as large':4,'the same':1,'4.5 times as large':4.5,
 'twice as large as before':2,'half as large as before':.5,'one-fourth as large as before':.25}
def wf(t):
    t=t.split(',')[0]
    return WORD[t]
bad=0
assert len(V)==18
diffs=set(v['difficulty'] for v in V); assert diffs=={'easy','medium','hard'}
for v in V:
    id=v['id'];errs=[]
    assert len(v['wrong'])==3 and id.rsplit('-v',1)[0]==v['seed']
    texts=[v['correct']['text']]+[w['text'] for w in v['wrong']]
    if re.search(r'(^|\s)[A-D][\.\)]\s',v['stem']): errs.append('option list in stem')
    if len({t.lower() for t in texts})!=4: errs.append('dup text')
    if id in E:
        for k,(val,t) in enumerate(zip(E[id],texts)):
            if val is None: continue
            if not close(val,num(t)): errs.append(f'num {val} vs {t}')
    if id in F:
        for val,t in zip(F[id],texts):
            if abs(wf(t)-val)>1e-9: errs.append(f'factor {val} vs {t}')
        assert len({round(x,9) for x in F[id]})==4,'factors distinct '+id
    if id=='apphy2-mcq-024-v1': assert [num(t) for t in texts[:3]]==[-4.0,-8.0,-8.0]
    if id=='apphy2-mcq-024-v2':
        assert texts[3].startswith('+4.5 nC and −1.5') and abs(9/2-4.5)<1e-9 and abs(-3/2+1.5)<1e-9
    if id=='apphy2-mcq-024-v3':
        assert sim3==[6,3,3] and texts[0]=='+6.0 nC, +3.0 nC, +3.0 nC'
        assert texts[1]=='+4.0 nC each' and abs(12/3-4)<1e-9
        assert texts[2]=='+6.0 nC, +6.0 nC, 0' and q2==[6,6,0]
        assert 6*3==18 and sum(sim3)==12
    if id=='apphy2-mcq-009-v1': assert abs(12/400-0.030)<1e-12
    if id=='apphy2-mcq-009-v3': assert abs(20/2000-0.010)<1e-12 and abs(0.63*10-6.3)<1e-9 and abs(0.37*10-3.7)<1e-9
    if id=='apphy2-mcq-009-v2': assert texts==['0 V','9.0 V','4.5 V','18 V']
    if id.startswith('apphy2-mcq-023'):
        assert v['correct']['text'] not in [w['text'] for w in v['wrong']]
    L=[len(t) for t in texts]
    if L[0]==max(L) and L[0]>1.4*sorted(L)[-2]: errs.append(f'key much longer {L}')
    sj=jac(vt(v),S[v['seed']])
    if sj>=0.7: errs.append(f'seed jac {sj:.2f}')
    for o in V:
        if o['id']!=id and jac(vt(v),vt(o))>=0.7: errs.append('sim '+o['id'])
    for t in [v['correct']]+v['wrong']:
        if not t['rationale'].strip(): errs.append('blank rationale')
        if re.search(r'\b(choice|option|answer) [A-D]\b|\b[A-D]\)',t['rationale']): errs.append('letter ref')
    if errs: bad+=1; print('FAIL',id,errs)
    else: print('OK',id,'seedjac=%.2f'%sj)
print('ALL OK' if not bad else f'{bad} FAILURES')
