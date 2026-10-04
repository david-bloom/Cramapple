import json,re,os
import sympy as sp
d=os.path.dirname(os.path.abspath(__file__))
V=json.load(open(os.path.join(d,'variants_c1.json')))
BY={v['id']:v for v in V}
x=sp.symbols('x',real=True); t,T,r=sp.symbols('t T r',positive=True)
b,c,A,P0=sp.symbols('b c A P0',positive=True)
R=sp.Rational
S=sp.simplify

SEEDS={ # live text: stem (repaired/stripped) + choices
'apphycm-mcq-001':"If v(t)=3t² in SI units, the acceleration at t=2 s is 3 m/s² 6 m/s² 12 m/s² 24 m/s²",
'apphycm-mcq-002':"The displacement from t=0 to T for v(t)=kt is kT kT² kT²/2 k/T",
'apphycm-mcq-003':"A force F(x)=ax acts in one dimension. The work from 0 to L is aL aL² aL²/2 a/L",
'apphycm-mcq-006':"A particle moves in one dimension under a conservative force with potential energy U(x). The force on the particle is given by which of the following? dU/dx -dU/dx -U/x +d^2U/dx^2",
'apphycm-mcq-007':"A power law P(t)=ct² delivers energy from 0 to T equal to cT² cT³/2 cT³/3 2cT",
'apphycm-mcq-008':"At a stable equilibrium x₀, U(x) has a local minimum a local maximum an infinite slope no derivative"}

# expected (correct, w1, w2, w3) numeric values, each from sympy (derivatives/integrals done explicitly)
E={}
# 001
v=2*t**3; a=sp.diff(v,t); assert a==6*t**2
E['apphycm-mcq-001-v1']=[a.subs(t,2), v.subs(t,2), (6*t).subs(t,2), (6*t**3).subs(t,2)]
v=20+6*t-t**2; a=sp.diff(v,t); assert a==6-2*t
E['apphycm-mcq-001-v2']=[a.subs(t,4), (v.subs(t,4)-v.subs(t,0))/4, sp.diff(6*t,t), v.subs(t,4)]
assert v.subs(t,4)==28 and v.subs(t,0)==20
# 002
v=4*t; E['apphycm-mcq-002-v1']=[sp.integrate(v,(t,0,3)), v.subs(t,3), 4*3**2, sp.diff(v,t)]
assert sp.integrate(v,t)==2*t**2
v=2*t+3*t**2; E['apphycm-mcq-002-v2']=[sp.integrate(v,(t,1,3)), sp.integrate(v,(t,0,3)), v.subs(t,3)-v.subs(t,1), (v.subs(t,1)+v.subs(t,3))/2*2]
v=12-3*t**2; ts=[s for s in sp.solve(v,t) if s>0]; assert ts==[2]
X=sp.integrate(v,(t,0,2)); assert X==16 and sp.integrate(v,t)==12*t-t**3
E['apphycm-mcq-002-v3']=[X, 12*2, 12*2-R(3,2)*8, 12*2-3*8]
# 003
F=4*x; assert sp.integrate(F,x)==2*x**2
E['apphycm-mcq-003-v1']=[sp.integrate(F,(x,0,3)), F.subs(x,3), F.subs(x,3)*3, R(1,2)*4*3]
F=3*x**2; assert sp.integrate(F,x)==x**3
E['apphycm-mcq-003-v2']=[sp.integrate(F,(x,1,2)), sp.integrate(F,(x,0,2)), F.subs(x,2)*1, R(3,2)*(2**3-1)]
F=12-3*x; assert sp.solve(F,x)==[4]
E['apphycm-mcq-003-v3']=[sp.integrate(F,(x,0,6)), sp.integrate(F,(x,0,4)), sp.integrate(F,(x,0,4))+abs(sp.integrate(F,(x,4,6))), 12*6]
assert sp.integrate(F,(x,4,6))==-6 and sp.integrate(F,(x,0,4))==24 and F.subs(x,6)==-6
# 006
U=5*x**2; F=-sp.diff(U,x); assert F==-10*x
E['apphycm-mcq-006-v1']=[F.subs(x,2), -U.subs(x,2)/2, -(10*x**2).subs(x,2), -sp.diff(x**2,x).subs(x,2)]
assert U.subs(x,2)==20 and sp.diff(U,x).subs(x,2)==20 and sp.diff(5*x,x)==5
U=x**4-4*x; F=-sp.diff(U,x); assert F==-(4*x**3-4)
E['apphycm-mcq-006-v2']=[F.subs(x,2), sp.diff(U,x).subs(x,2), -(4*x**4-4).subs(x,2), -U.subs(x,2)/2]
# 007
P=6*t; E['apphycm-mcq-007-v1']=[sp.integrate(P,(t,0,4)), P.subs(t,4), P.subs(t,4)*4, sp.diff(P,t)]
P=3*t**2+4; E['apphycm-mcq-007-v2']=[sp.integrate(P,(t,1,3)), sp.integrate(P,(t,0,3)), (P.subs(t,1)+P.subs(t,3))/2*2, sp.integrate(3*t**2,(t,1,3))]
assert P.subs(t,1)==7 and P.subs(t,3)==31 and sp.integrate(4,(t,1,3))==8
# symbolic items: (text, sympy expr) per choice
SYM={}
v=b*t**3-c*t; a=sp.diff(v,t)
SYM['apphycm-mcq-001-v3']=[("3bT² − c",a.subs(t,T)),("bT² − c",b*T**2-c),("3bT³ − c",3*b*T**3-c),("3bT² − cT",3*b*T**2-c*T)]
assert sp.expand(a.subs(t,T)-(3*b*T**2-c))==0
U=-A/r; Fr=-sp.diff(U,r); assert sp.simplify(Fr+A/r**2)==0   # F_r = -A/r^2 <0 : toward origin
assert sp.simplify(sp.diff(U,r,2)+2*A/r**3)==0            # 2A/r^3 is d2U/dr2 magnitude
assert sp.diff(U,r)!=0
SYM['apphycm-mcq-006-v3']=[("A/r², toward the origin",A/r**2),("A/r, toward the origin",A/r),("2A/r³, toward the origin",2*A/r**3),("Zero, because U is negative",sp.Integer(0))]
SYM['apphycm-mcq-006-v3-sign']=Fr.subs({A:1,r:1})<0
Pp=P0*(t/T)*(1-t/T); Et=sp.integrate(Pp,(t,0,T))
assert sp.simplify(Et-P0*T/6)==0
assert sp.simplify(sp.integrate(P0*t/T,(t,0,T))-P0*T/2)==0 and sp.simplify(sp.integrate(P0*t**2/T**2,(t,0,T))-P0*T/3)==0
tp=sp.solve(sp.diff(Pp,t),t)[0]; assert sp.simplify(Pp.subs(t,tp)-P0/4)==0   # peak power P0/4 at T/2
SYM['apphycm-mcq-007-v3']=[("P₀T/6",Et),("P₀T/2",P0*T/2),("P₀T/4",P0*T/4),("5P₀T/6",5*P0*T/6)]
# 008 conceptual checks
U=x**3-3*x**2; crit=sp.solve(sp.diff(U,x),x); assert sorted(crit)==[0,2]
assert sp.diff(U,x,2).subs(x,2)==6 and sp.diff(U,x,2).subs(x,0)==-6 and sp.diff(U,x,2).subs(x,1)==0 and sp.diff(U,x).subs(x,1)==-3 and sp.diff(U,x).subs(x,3)==9
F=3*x-x**3; eq=sp.solve(F,x); assert sorted(eq,key=float)==[-sp.sqrt(3),0,sp.sqrt(3)]
dF=sp.diff(F,x)
assert dF.subs(x,0)==3 and dF.subs(x,sp.sqrt(3))==-6 and dF.subs(x,-sp.sqrt(3))==-6   # stable iff dF/dx<0 (d2U = -dF)
Uf=-sp.integrate(F,x); assert sp.diff(Uf,x,2).subs(x,0)<0 and sp.diff(Uf,x,2).subs(x,sp.sqrt(3))>0
# 008-v1 conceptual: restoring force F=-dU/dx at a minimum: U=k x^2/2
k=sp.symbols('k',positive=True); Ub=k*x**2/2
assert (-sp.diff(Ub,x)).subs(x,1)<0 and (-sp.diff(Ub,x)).subs(x,-1)>0 and sp.diff(Ub,x,2)>0
Uh=-k*x**2/2; assert (-sp.diff(Uh,x)).subs(x,1)>0   # maximum: pushes away

# ---- text checks
W=lambda s:set(re.findall(r"[a-z0-9]+",s.lower()))
def jac(p,q): return len(p&q)/len(p|q)
def vtext(v): return v['stem']+' '+v['correct']['text']+' '+' '.join(w['text'] for w in v['wrong'])
def num(tx):
    tx=tx.replace('−','-')
    m=re.search(r'([+-]?\d+(?:\.\d+)?)',tx); return float(m.group(1))
SAME_MAG={'apphycm-mcq-001-v2','apphycm-mcq-006-v2','apphycm-mcq-008-v2'}   # one sign/direction-only distinction per seed
bad=0
assert len(V)==18
assert {v['difficulty'] for v in V}=={'easy','medium','hard'}
from collections import Counter
assert all(n==3 for n in Counter(v['seed'] for v in V).values()) and len(set(v['seed'] for v in V))==6
for v in V:
    i=v['id']; errs=[]
    assert len(v['wrong'])==3 and i.rsplit('-v',1)[0]==v['seed']
    texts=[v['correct']['text']]+[w['text'] for w in v['wrong']]
    if re.search(r'(^|\s)[A-D][\.\)]\s',v['stem']): errs.append('option list in stem')
    if i in E:
        for val,tx in zip(E[i],texts):
            if abs(float(val)-num(tx))>1e-9: errs.append(f'value {float(val)} vs text {tx}')
        if len({round(float(q),9) for q in E[i]})<4: errs.append('computed values not distinct')
        if len({abs(round(float(q),9)) for q in E[i]})<4 and i not in SAME_MAG: errs.append('unexpected sign-only pair')
    if i in SYM:
        for (tx,ex),have in zip(SYM[i],texts):
            if tx!=have: errs.append(f'text mismatch {tx!r} vs {have!r}')
        ex=[q[1] for q in SYM[i]]
        for p in range(4):
            for q in range(p+1,4):
                if sp.simplify(ex[p]-ex[q])==0: errs.append('symbolic duplicates')
    if i=='apphycm-mcq-006-v3': assert SYM['apphycm-mcq-006-v3-sign']
    if not (i in E or i in SYM or i.startswith('apphycm-mcq-008')): errs.append('no verification')
    L=[len(q) for q in texts]
    if L[0]==max(L) and L[0]>1.4*sorted(L)[-2]: errs.append('key much longer')
    if len(set(texts))!=4: errs.append('dup choice')
    if any(not q['rationale'].strip() or not q['error_pattern'].strip() for q in v['wrong']): errs.append('blank')
    sj=jac(W(vtext(v)),W(SEEDS[v['seed']]))
    if sj>=0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in V:
        if o['id']!=i and jac(W(vtext(v)),W(vtext(o)))>=0.7: errs.append('similar '+o['id'])
    if re.search(r'\b(choice|option) [A-D]\b|answer [A-D]\b',json.dumps(v)): errs.append('letter mention')
    if errs: bad+=1; print('FAIL',i,errs)
    else: print('OK',i,'seedJ=%.2f'%sj)
print('ALL OK' if not bad else f'{bad} FAILURES')
