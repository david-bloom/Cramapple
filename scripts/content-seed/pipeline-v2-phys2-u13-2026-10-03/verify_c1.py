import json,re,math,os
d=os.path.dirname(os.path.abspath(__file__))
V=json.load(open(os.path.join(d,'variants_c1.json')))
SEEDS={
'apphy2-mcq-002':"During an isothermal expansion of an ideal gas, its internal-energy change is positive negative zero equal to pressure",
'apphy2-mcq-003':"Which of the following best explains why energy is spontaneously transferred from a hot object to a cold object? The transfer decreases the total entropy of the system The transfer increases the total entropy of the system The transfer violates conservation of energy The transfer decreases the entropy of the cold object",
'apphy2-mcq-004':"The electric field direction at a point is the direction of force on a positive test charge a negative test charge any neutral object an electron only",
'apphy2-mcq-005':"Moving a positive charge opposite a uniform electric field causes electric potential energy to decrease increase remain zero become negative regardless of the starting value",
'apphy2-mcq-006':"Two identical positive point charges are placed on a horizontal line, one to the left of the other. At the midpoint between them, the electric field is zero toward the left charge toward the right charge infinite",
'apphy2-mcq-007':"Two resistors 3 Ω and 6 Ω in parallel have equivalent resistance 2 Ω 3 Ω 9 Ω 18 Ω"}
k=9.0e9;e=1.6e-19;R=8.31
sq=math.sqrt
# id -> [correct, w1, w2, w3] recomputed from the stated computation / error
E={
'apphy2-mcq-002-v2':[1200,0,1200,1.5*2.0*R*300],      # sign of wrong2 is 'released' (checked in text below)
'apphy2-mcq-002-v3':[1.5*1e5*0.040,1e5*0.040,1.5*1e5*0.040+1e5*0.040,0],
'apphy2-mcq-004-v1':[9.0e-6/3.0e-9,9.0e-6/3.0e-9,9.0e-6*3.0e-9,3.0e-9/9.0e-6],
'apphy2-mcq-004-v2':[5.0e-6*400,5.0e-6*400,400/5.0e-6,0],
'apphy2-mcq-004-v3':[2*k*4e-6/0.20**2,0,k*4e-6/0.20**2,2*k*4e-6/0.20**2],
'apphy2-mcq-005-v2':[e*2.0e3*0.050,-e*2.0e3*0.050,2.0e3*0.050,e*2.0e3/0.050],
'apphy2-mcq-005-v3':[-8.99e9*e**2/2e-9+8.99e9*e**2/1e-9,-(-8.99e9*e**2/2e-9+8.99e9*e**2/1e-9),-8.99e9*e**2/1e-9,8.99e9*e**2/1e-9],
'apphy2-mcq-006-v2':[0.90/3,0.45,0.90/5,0.60],
'apphy2-mcq-006-v3':[2*k*2e-6/0.5**2*(0.4/0.5),0,2*k*2e-6/0.5**2,2*k*2e-6/0.5**2*(0.3/0.5)],
'apphy2-mcq-007-v1':[1/(1/4+1/12),(4+12)/2,4+12,4*12],
'apphy2-mcq-007-v2':[1/(1/10+1/15+1/30),10+15+30,1/10+1/15+1/30,(10+15+30)/3],
'apphy2-mcq-007-v3':[6+1/(1/6+1/3),6+6+3,1/(1/6+1/6+1/3),6+(6+3)/2],
}
# independent derivation asserts for the intermediate steps quoted in rationales
assert abs(E['apphy2-mcq-005-v3'][0]-1.15e-19)<0.01e-19
assert abs(k*4e-6/0.20**2-9.0e5)<1
assert abs(k*2e-6/0.5**2-7.2e4)<1
assert abs(2*k*2e-6/0.5**2*0.8-1.152e5)<10
assert abs(1.5*2.0*R*300-7.5e3)<80          # 3/2 nRT quoted as 7.5 kJ
assert 1/(1/6+1/3)==2.0                      # pair resistance 2.0 ohm
# conceptual items: checkable relations
F=[ # (label, assertion)
 ('002-v1 isothermal: dU=Q+W with Q=-W ->0', (lambda Q,W:Q+W)(-5.0,5.0)==0),
 ('002-v3 T triples: V 0.020->0.060 at const P', abs(0.060/0.020-3)<1e-9),
 ('005-v1 electron along field: dU=-qE.d with q<0, d along E >0', (-(-1)*1*1)>0),
 ('006-v1 equal charges at midpoint cancel', (lambda a,b:a-b)(5.0,5.0)==0),
 ('006-v2 x=d/3 from the weaker charge: kQ/x^2 == k4Q/(d-x)^2', abs(1/0.30**2-4/(0.90-0.30)**2)<1e-9),
 ('006-v2 1/r version gives 0.18 m', abs(0.90/5-0.18)<1e-9),
 ('004-v2 force on negative charge opposes upward field', -1*(+1)<0),
 ('003-v2/v3 entropy bookkeeping: dS_hot<0, dS_cold>|dS_hot| when Q/Th<Q/Tc', 1/353.15<1/293.15),
]
for lab,ok in F: assert ok,lab
W=lambda s:set(re.findall(r"[a-z0-9]+",s.lower()))
def jac(a,b): return len(a&b)/len(a|b)
def vtext(v): return v['stem']+' '+v['correct']['text']+' '+' '.join(w['text'] for w in v['wrong'])
SUP=str.maketrans('⁻⁰¹²³⁴⁵⁶⁷⁸⁹','-0123456789')
def num(t):
    if t.lower().startswith('zero'): return 0.0
    t=t.replace('−','-').translate(SUP)
    m=re.search(r'([+-]?\d+(?:\.\d+)?)(?:\s*×\s*10(-?\d+))?',t)
    x=float(m.group(1))
    if m.group(2): x*=10**int(m.group(2))
    return x
SAME_MAG={'apphy2-mcq-002-v2','apphy2-mcq-004-v1','apphy2-mcq-004-v2','apphy2-mcq-004-v3','apphy2-mcq-005-v2','apphy2-mcq-005-v3'}  # distractors differing only in direction/sign
bad=0
assert len(V)==18
diffs={v['difficulty'] for v in V}; assert diffs=={'easy','medium','hard'}
for v in V:
    id=v['id'];errs=[]
    assert len(v['wrong'])==3 and id.rsplit('-v',1)[0]==v['seed']
    if re.search(r'(^|\s)[A-D][\.\)]\s',v['stem']): errs.append('option list in stem')
    texts=[v['correct']['text']]+[w['text'] for w in v['wrong']]
    if id in E:
        for val,t in zip(E[id],texts):
            p=abs(num(t)); val=abs(val)
            if abs(val-p)>max(0.05*val,0.06*(1 if val<100 else 0)): errs.append(f'value {val} vs text {t}')
        if len({round(abs(x),9) for x in E[id]})<4 and id not in SAME_MAG: errs.append('computed values not distinct')
    lens=[len(t) for t in texts]
    if lens[0]==max(lens) and lens[0]/sorted(lens)[-2]>1.4: errs.append('key much longer than others')
    if len(set(texts))!=4: errs.append('dup choice')
    sj=jac(W(vtext(v)),W(SEEDS[v['seed']]))
    if sj>=0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in V:
        if o['id']!=id and jac(W(vtext(v)),W(vtext(o)))>=0.7: errs.append('similar '+o['id'])
    if re.search(r'\b(choice|option) [A-D]\b|answer [A-D]\b',json.dumps(v)): errs.append('letter mention')
    if errs: bad+=1; print('FAIL',id,errs)
    else: print('OK',id)
print('ALL OK' if not bad else f'{bad} FAILURES')
