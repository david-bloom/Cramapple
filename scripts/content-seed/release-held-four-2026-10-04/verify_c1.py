import json,re,math,os,itertools
import sympy as sp
from mpmath import mp,mpf,quad
d=os.path.dirname(os.path.abspath(__file__))
V=json.load(open(os.path.join(d,'variants_c1.json')))
IT=json.load(open(os.path.join(d,'items.json')))
mp.dps=30
e0=8.854187817e-12; g=10.0
SUPM={'⁰':'0','¹':'1','²':'2','³':'3','⁴':'4','⁵':'5','⁶':'6','⁷':'7','⁸':'8','⁹':'9','⁻':'-'}
def num(t):
    t=t.replace('−','-')
    m=re.search(r'(-?\d+(?:\.\d+)?)(?:\s*×\s*10([⁻⁰¹²³⁴⁵⁶⁷⁸⁹]+))?',t)
    x=float(m.group(1))
    if m.group(2): x*=10**int(''.join(SUPM[c] for c in m.group(2)))
    return x
def close(a,b,tol=0.05): return abs(a-b)<=tol*abs(b)+1e-9
t=sp.symbols('t',positive=True)
E={}
# ---- apphycem-003 (Gauss: only enclosed charge)
Ee,L=300.0,0.20; A=L*L
flux_faces=[-Ee*A,+Ee*A,0,0,0,0]          # entering, leaving, four parallel faces
assert sum(flux_faces)==0
E['apphycem-mcq-003-v1']=[sum(flux_faces),Ee*A,2*Ee*A,6*Ee*A]
f=lambda q:q*1e-9/e0
assert 4.0-4.0==0
E['apphycem-mcq-003-v2']=[f(4.0-4.0),f(6.0),f(4.0),f(8.0)]
Qs=12.0; R,r=0.20,0.10
E['apphycem-mcq-003-v3']=[0.0,f(Qs),f(Qs)*(r/R)**3,f(Qs)*(r/R)**2]   # surface charge: none inside r<R
# ---- apphycm-023 (N = mg cos(theta) on frictionless incline)
th=math.radians(30); m=4.0
E['apphycm-mcq-023-v1']=[m*g*math.cos(th),m*g,m*g*math.sin(th),m*g/math.cos(th)]
m=2.5; cs=4/5; sn=3/5; assert abs(math.hypot(4,3)-5)<1e-12
E['apphycm-mcq-023-v2']=[m*g*cs,m*g*sn,m*g,m*g*3/4]
m=2.0; th=math.radians(90-25)
E['apphycm-mcq-023-v3']=[m*g*math.cos(th),m*g*math.cos(math.radians(25)),m*g,m*g/math.cos(th)]
assert abs(m*g*math.cos(math.radians(25))-m*g*math.sin(th))<1e-9
# ---- apphycm-031 (F = m dv/dt, constant m), derivatives by sympy
m=3.0; v=4*t+1; a=sp.diff(v,t)
E['apphycm-mcq-031-v1']=[m*float(a),m*float(v.subs(t,2)/2),m*float(v.subs(t,2)),float(a)]
m=1.5; v=2*t**3-3*t; a=sp.diff(v,t)
integ=float(sp.integrate(v,(t,0,2)))
assert integ==2.0
E['apphycm-mcq-031-v2']=[m*float(a.subs(t,2)),m*float(v.subs(t,2)/2),m*float(v.subs(t,2)),m*integ]
m=2.0; x=sp.Rational(1,2)*t**4-2*t; v=sp.diff(x,t); a=sp.diff(v,t)
assert v==2*t**3-2 and a==6*t**2
ta=sp.Rational(3,2)
avg=float((v.subs(t,ta)-v.subs(t,0))/ta)
E['apphycm-mcq-031-v3']=[m*float(a.subs(t,ta)),float(a.subs(t,ta)),m*float(v.subs(t,ta)),m*avg]
# numeric cross-check of derivative via mpmath
assert abs(mp.diff(lambda s:mpf(2)*s**3-3*s,2)-21)<1e-12
# ---- apphy2-001 (P proportional to absolute T at fixed V)
C=lambda c:c+273.0
P0=1.0e5
E['apphy2-mcq-001-v1']=[P0*C(177)/C(27),P0*177/27,P0*C(27)/C(177),P0]
# v2: line through two data points; zero-pressure intercept
T,P=sp.symbols('T P')
sol=sp.solve(sp.Eq(P,120+(160-120)/(127-27)*(T-27)).subs(P,0),T)[0]
assert abs(float(sol)-(-300+27+0))<1e-9 or True
# line is exactly P = k*T_K with 273 offset? check
k=120/C(27); assert abs(k*C(127)-160)<0.5
zero_C=-273.0
E['apphy2-mcq-001-v2']=[zero_C,0.0,-120/0.40,27-100.0]
assert abs(float(sol)-(27-120/0.40))<1e-9           # straight-line extrapolation from the data = -273 C
assert abs(float(sol)-(-273))<1e-9
# v3
Tf=3*C(27)-273.0
E['apphy2-mcq-001-v3']=[Tf,3*27,3*C(27),27/3]
assert Tf==627
# ---- format / similarity checks
W=lambda s:set(re.findall(r"\w+",s.lower()))
def jac(a,b): return len(a&b)/len(a|b)
def vtext(v): return v['stem']+' '+v['correct']['text']+' '+' '.join(w['text'] for w in v['wrong'])
def seedtext(k): return IT[k][1]+' '+' '.join(IT[k][2])
assert len(V)==12
ids=[v['id'] for v in V]; assert len(set(ids))==12
bad=0
for v in V:
    id=v['id'];errs=[]
    assert len(v['wrong'])==3 and id.rsplit('-v',1)[0]==v['seed'] and v['seed'] in IT
    assert all(w['error_pattern'] for w in v['wrong'])
    if re.search(r'(^|\s)[A-D][\.\)]\s',v['stem']): errs.append('option list in stem')
    texts=[v['correct']['text']]+[w['text'] for w in v['wrong']]
    rats=[v['correct']['rationale']]+[w['rationale'] for w in v['wrong']]
    for val,tx in zip(E[id],texts):
        if not close(num(tx),val): errs.append(f'value {val:.4g} vs text {tx}')
    if len({round(x_,6) for x_ in E[id]})<4: errs.append('computed values not distinct')
    lens=[len(x_) for x_ in texts]
    if lens[0]==max(lens) and lens[0]/sorted(lens)[-2]>1.4: errs.append('key much longer')
    if len({x_.lower() for x_ in texts})!=4: errs.append('dup choice')
    if re.search(r'\b(choice|option) [A-D]\b|answer [A-D]\b|\([A-D]\)',json.dumps(v)): errs.append('letter mention')
    if any(not r_.strip() for r_ in rats): errs.append('blank rationale')
    if re.search(r'\b(probably|might be|perhaps|may be|likely)\b',' '.join(rats)): errs.append('hedging')
    sj=jac(W(vtext(v)),W(seedtext(v['seed'])))
    if sj>=0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in V:
        if o['id']!=id and jac(W(vtext(v)),W(vtext(o)))>=0.7: errs.append('similar '+o['id'])
    if errs: bad+=1; print('FAIL',id,errs)
    else: print('OK',id)
for s in IT:
    ds=[v['difficulty'] for v in V if v['seed']==s]; assert sorted(ds)==['easy','hard','medium'],(s,ds)
print('max pairwise jaccard: %.2f'%max(jac(W(vtext(a)),W(vtext(b))) for a,b in itertools.combinations(V,2)))
print('max seed jaccard: %.2f'%max(jac(W(vtext(v)),W(seedtext(v['seed']))) for v in V))
print('ALL OK' if not bad else f'{bad} FAILURES')
