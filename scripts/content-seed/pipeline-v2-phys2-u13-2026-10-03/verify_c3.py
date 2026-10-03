import json,re,math,os,itertools
d=os.path.dirname(os.path.abspath(__file__))
V=json.load(open(os.path.join(d,'variants_c3.json')))
# live seed text (Production, published versions, 2026-10-03)
S={
'apphy2-mcq-025':"At a point where electric potential is zero, the electric field must be zero must be constant nearby may be nonzero must point toward that point",
'apphy2-mcq-026':"An electron accelerated from rest through a potential difference of magnitude ΔV gains kinetic energy equal to eΔV (1/2)eΔV 2eΔV -eΔV",
'apphy2-mcq-027':"The voltage across a fixed resistor is doubled. Its power dissipation becomes half twice four times unchanged",
'apphy2-mcq-028':"Traversing an ideal battery from its negative terminal to its positive terminal in a loop equation contributes +emf -emf zero depends on the current direction",
'apphy2-mcq-029':"Currents 2.0 A and 3.5 A enter a junction. If one current leaves, its magnitude is 1.5 A 2.75 A 5.5 A 3.5 A",
'apphy2-mcq-030':"A capacitor in series with a resistor has been connected to a DC battery for a very long time. The circuit current is battery voltage divided by R zero infinite set only by C",
}
k=8.99e9; e=1.60e-19; me=9.11e-31
sq=math.sqrt
# expected numbers in each choice's own units: [correct, w1, w2, w3] as lists of numbers present in the text
E={
'apphy2-mcq-025-v1':[[0,2*k*4e-9/0.1**2],[0,0],[2*k*4e-9/0.1,0],[0,2*k*4e-9/0.1**2]],
'apphy2-mcq-025-v2':[[40/0.020],[0],[40/0.020],[20/0.020]],
'apphy2-mcq-025-v3':[[6/(6+2)*0.40*1+0.0, k*6e-9/0.30**2+k*2e-9/0.10**2],[0.30,0],[0.20,k*6e-9/0.2**2+k*2e-9/0.2**2],[0.30,abs(k*6e-9/0.30**2-k*2e-9/0.10**2)]],
'apphy2-mcq-026-v1':[[e*500],[0.5*e*500],[2*e*500],[e]],
'apphy2-mcq-026-v2':[[sq(2*e*250/me)/1e6*1e6],[sq(e*250/me)],[sq(e*250/(2*me))],[sq(4*e*250/me)]],
'apphy2-mcq-026-v3':[[-e*100,e*100],[e*100,e*100],[-e*100,-e*100],[-e*140,e*140]],
'apphy2-mcq-030-v1':[[12/2000*1000],[0],[0.632*12/2000*1000],[2000/12]],
'apphy2-mcq-028-v1':[[(15-2.0*4.0)/2.0],[(15+8.0)/2.0],[15/2.0],[(15-4.0)/2.0]],
'apphy2-mcq-028-v2':[[(12-5)/7],[(12+5)/7],[12/7],[0]],
'apphy2-mcq-028-v3':[[24-0.6*10],[0.6*10],[12],[24+0.6*10]],
'apphy2-mcq-029-v1':[[4.5+2.5],[4.5-2.5],[(4.5+2.5)/2],[4.5]],
'apphy2-mcq-029-v2':[[3.0+1.2-2.5],[3.0+1.2+2.5],[abs(3.0-1.2-2.5)],[3.0+1.2]],
'apphy2-mcq-029-v3':[[12/4+12/6+12/12],[(12/4+12/6+12/12)/3],[12/4],[12/(4+6+12)]],
'apphy2-mcq-030-v2':[[12/(4+8)*8],[12],[12/(4+8)*4],[0]],
'apphy2-mcq-030-v3':[[0.632*4e-6*12*1e6],[0.368*4e-6*12*1e6],[4e-6*12*1e6],[24]],
'apphy2-mcq-027-v2':[[60**2/(120**2/360)],[180],[360],[1440]],
}
# unit exponents applied to parsed numbers where text units differ (e.g. mantissa x10^n handled by parser)
SUP=str.maketrans('⁰¹²³⁴⁵⁶⁷⁸⁹⁻','0123456789-')
def nums(t):
    t=t.replace('−','-').replace('+','')
    out=[]
    for m in re.finditer(r'(?<![\w.])-?\d+(?:\.\d+)?(?:×10[⁰¹²³⁴⁵⁶⁷⁸⁹⁻]+)?',t):
        s=m.group()
        if '×10' in s:
            a,b=s.split('×10'); out.append(float(a)*10**int(b.translate(SUP)))
        else: out.append(float(s))
    return out
# conceptual factor / ratio items
F={'apphy2-mcq-027-v1':(['nine','three','six','unchanged'],[3**2,3,3*2,1]),
   'apphy2-mcq-027-v3':(['three times as much as the 4.0','three times as much as the 12','nine times','equal'],[12/4.0,4.0/12*0+ (12/4.0),(12/4.0)**2,1])}
W=lambda s:set(re.findall(r"\w+",s.lower()))
def jac(a,b): return len(a&b)/len(a|b)
def vt(v): return v['stem']+' '+v['correct']['text']+' '+' '.join(w['text'] for w in v['wrong'])
bad=0
assert len(V)==18
for v in V:
    id=v['id'];errs=[]
    texts=[v['correct']['text']]+[w['text'] for w in v['wrong']]
    assert len(v['wrong'])==3 and id.rsplit('-v',1)[0]==v['seed']
    if re.search(r'\bA[\.\)] .*\bB[\.\)] ',v['stem']): errs.append('option list in stem')
    if id in E:
        for exp,t in zip(E[id],texts):
            got=nums(t)
            # drop trailing numbers from text that are part of identifiers (none expected); compare multiset in order
            if len(got)!=len(exp): errs.append(f'count {got} vs {exp} in {t}')
            else:
                for g,x in zip(got,exp):
                    tol=0.04*abs(x) if x else 1e-12
                    if abs(g-x)>tol: errs.append(f'value {x} vs {g} in {t}')
    if id=='apphy2-mcq-027-v1':
        for w,val in zip(['nine','three','six','unchanged'],[3**2,3,3*2,1]): pass
        assert [x in t for x,t in zip(['nine','three','six','unchanged'],texts)]==[True]*4
    if id=='apphy2-mcq-027-v3':
        assert 12/4.0==3 and (12/4.0)**2==9
        assert 'The 12 Ω' in texts[0] and 'three times' in texts[0] and 'The 4.0 Ω' in texts[1] and 'nine' in texts[2] and 'equal' in texts[3]
    if id=='apphy2-mcq-025-v3':
        x=0.30; assert abs(6/x-2/(0.40-x))<1e-9
    if id=='apphy2-mcq-030-v3':
        assert abs(5.0e3*4.0e-6-0.020)<1e-12
    if len({t.strip().lower() for t in texts})!=4: errs.append('dup choice text')
    L=[len(t) for t in texts]
    if L[0]==max(L) and L[0]>1.4*sorted(L)[-2]: errs.append('correct much longer')
    if id.endswith('v3') or True:
        pass
    sj=jac(W(vt(v)),W(S[v['seed']]))
    if sj>=0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in V:
        if o['id']<id:
            j=jac(W(vt(v)),W(vt(o)))
            if j>=0.7: errs.append(f'similar {o["id"]} {j:.2f}')
    for c in [v['correct']]+v['wrong']:
        if not c['rationale'].strip(): errs.append('blank rationale')
        if re.search(r'\b(choice|option) [A-D]\b',c['rationale']): errs.append('letter in rationale')
    if errs: bad+=1; print('FAIL',id,errs)
    else: print('OK',id)
print('ALL OK' if not bad else f'{bad} FAILURES')
