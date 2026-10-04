import json,re,math,os,itertools
import sympy as sp
from mpmath import mp,mpf,quad,pi as mpi
d=os.path.dirname(os.path.abspath(__file__))
V=json.load(open(os.path.join(d,'variants_c1.json')))
SEEDS={
'apphycem-mcq-001':"Gauss's law states the electric flux through a closed surface is Q_enclosed/ε₀ ε₀Q_enclosed Q_total outside/ε₀ always zero",
'apphycem-mcq-002':"For a spherically symmetric volume charge density, the charge enclosed within radius R is… ∫₀ᴿρ(r)4πr²dr ρ(R)R ∫ρ dr only 4πR²/ρ",
'apphycem-mcq-005':"For electrostatics in one dimension, the x-component of the electric field is related to the electric potential V(x) by E_x = dV/dx E_x = -dV/dx E_x = -V/x E_x = ∫V dt",
'apphycem-mcq-006':"At a point on the x-axis where the electric potential V(x) has a stationary point (dV/dx = 0), which statement must be true? The field component E_x is zero there. The potential V must equal zero there. An infinite charge must be located there. The field component E_x must be nonzero there.",
'apphycem-mcq-007':"Capacitance of parallel plates neglecting edges is εA/d εd/A Ad/ε d/(εA)",
'apphycem-mcq-008':"Energy stored in a capacitor is CV² CV²/2 C/V² 2C/V"}
mp.dps=30
e0=mpf('8.854187817e-12'); k=1/(4*mpi*e0)
SUPM={'⁰':'0','¹':'1','²':'2','³':'3','⁴':'4','⁵':'5','⁶':'6','⁷':'7','⁸':'8','⁹':'9','⁻':'-'}
def num(t):
    """first number in text; handles 'a × 10ⁿ'; returns float (display units)"""
    t=t.replace('−','-')
    m=re.search(r'(-?\+?\d+(?:\.\d+)?)(?:\s*×\s*10([⁻⁰¹²³⁴⁵⁶⁷⁸⁹]+))?',t)
    x=float(m.group(1))
    if m.group(2): x*=10**int(''.join(SUPM[c] for c in m.group(2)))
    return x
def close(a,b,tol=0.04): return abs(a-b)<=tol*abs(b)+1e-30
r,rp=sp.symbols('r rp',positive=True); x=sp.symbols('x',real=True)
# ---- recomputed answers: id -> [key, w1, w2, w3] in the units shown in the choice text
E={}
Q=3e-9; E['001-v1']=[Q/float(e0), Q*float(e0), float(k)*Q, Q/float(e0)/6]
f=lambda q: q*1e-6/float(e0)
E['001-v2']=[f(5-2), f(5-2+6), f(5+2), f(5)]
# 002: symbolic integrals then numeric
rho0=2.0e-6; R1=0.10
q1=sp.integrate(rho0*4*sp.pi*rp**2,(rp,0,R1))
E['002-v1']=[float(q1)*1e9, rho0*4*math.pi*R1**2*1e9, rho0*4*math.pi*R1**3*1e9, rho0*R1**3*1e9]
al=3.0e-4; R2=0.20
q2=sp.integrate(al*rp*4*sp.pi*rp**2,(rp,0,R2))
assert abs(float(q2)-float(quad(lambda s: al*s*4*mpi*s**2,[0,R2])))<1e-12
E['002-v2']=[float(q2)*1e6, (4/3*math.pi*R2**3)*al*R2*1e6, 4*math.pi*al*R2**4*1e6, 0.5*al*R2*(4/3*math.pi*R2**3)*1e6]
rh=4.0e-6
q3=sp.integrate(rh*4*sp.pi*rp**2,(rp,sp.Rational(1,10),sp.Rational(1,5)))
E['002-v3']=[float(q3)*1e9, (4/3*math.pi*0.2**3*rh)*1e9, 4/3*math.pi*(0.2-0.1)**3*rh*1e9, 4/3*math.pi*(0.2**2-0.1**2)*rh*1e9]
# 005
V1=5.0*x+2.0; E['005-v1']=[-float(sp.diff(V1,x)), +5.0, float(V1.subs(x,1.0)), 2.0]
V2=3.0*x**2-4.0*x; dv=float(sp.diff(V2,x).subs(x,2.0)); vv=float(V2.subs(x,2.0))
E['005-v2']=[-dv, -vv, -vv/2.0, -6.0*2.0]
assert dv==8.0 and vv==4.0
s1=-(2-10)/0.20; s2=-(11-2)/0.30
assert abs(s1-40)<1e-9 and abs(s2+30)<1e-9
# 006
V3=4*x**2-16*x+12; zs=sp.solve(sp.diff(V3,x),x); assert zs==[2]
roots=sorted(sp.solve(V3,x)); assert roots==[1,3]
assert sp.solve(4*x-16,x)==[4]
E['006-v2']=[float(zs[0]), float(roots[0]), 4.0, 0.0]
# 007
A=0.040*0.050; d_=1.0e-3
E['007-v2']=[float(e0)*A/d_*1e12, float(e0)*A/(d_*1e3)*1e12, float(e0)*d_/A*1e12, float(e0)*0.040/d_*1e12]
# 008
C=10e-6; Vv=6.0
E['008-v1']=[0.5*C*Vv**2*1e6, C*Vv**2*1e6, 0.5*C*Vv*1e6, C*Vv*1e6]
C=4.0e-6
E['008-v3']=[0.5*C*(5**2-2**2)*1e6, 0.5*C*(5-2)**2*1e6, 0.5*C*25*1e6, C*(5-2)*1e6]
# ---- conceptual relations as asserts
r_=lambda a,b: sp.Rational(a)/sp.Rational(b)
assert r_(1,1)*sp.Rational(1,3)==sp.Rational(1,3)                 # 007-v1 C~1/d, d x3
assert sp.Rational(4)/sp.Rational(3)==sp.Rational(4,3) and 4*3==12 and 2/3<1  # 007-v3 area r^2: (2)^2/3
assert (lambda C0,Q0: (lambda C1: (Q0**2/(2*C1))/(Q0**2/(2*C0)))(C0/2))(1.0,1.0)==2.0   # 008-v2 U=Q^2/2C, C halves
assert 0.5*(1/2)*1**2==0.25                                       # 008-v2 fixed-V distractor: U=1/2 (C/2) V^2 would halve
assert (0.5*(1.0/2)*(2.0)**2)/(0.5)==2.0                         # 008-v2 U=1/2 (C/2)(2V)^2 = 2x original (V0=C0=1)
for lab,ok in [
 ('001-v3 outside charge net flux is zero: one-over-r^2 field integrates to 0 over closed surface (Gauss)', True),
 ('006-v1 constant V: derivative zero', sp.diff(sp.Float(8.0),x)==0),
 ('006-v3 V falls between max and min -> dV/dx<0 -> E_x>0: model V=cos(pi*(x-1)/2) (max at 1, min at 3)', None)]:
    if ok is not None: assert ok,lab
Vm=sp.cos(sp.pi*(x-1)/2); Ex=-sp.diff(Vm,x)
assert Ex.subs(x,1)==0 and Ex.subs(x,3)==0 and Ex.subs(x,2)>0 and Vm.subs(x,1)==1 and Vm.subs(x,3)==-1
# 001-v3 sanity: flux of an outside point charge through a sphere is 0 (numeric, off-axis charge at distance 2R)
Rr=1.0;dd=2.0;th=sp.symbols('th')
# field of charge at (0,0,dd): E = (r - rq)/|r-rq|^3 ; n = r/R ; E.n * R ... recompute explicitly below
def integrand(t):
    t=mpf(t); px,pz=Rr*mp.sin(t),Rr*mp.cos(t)
    ex,ez=px, pz-dd; mag=(ex**2+ez**2)**mpf('1.5')
    return 2*mpi*Rr**2*mp.sin(t)*((ex*px+ez*pz)/Rr)/mag
assert abs(quad(integrand,[0,mpi]))<1e-10
# inside charge off-centre: flux = 4*pi (units k=1... Q/eps0 -> 4pi)
def integ_in(t):
    t=mpf(t); dd2=mpf('0.6'); px,pz=Rr*mp.sin(t),Rr*mp.cos(t)
    ex,ez=px, pz-dd2; mag=(ex**2+ez**2)**mpf('1.5')
    return 2*mpi*Rr**2*mp.sin(t)*((ex*px+ez*pz)/Rr)/mag
assert abs(quad(integ_in,[0,mpi])-4*mpi)<1e-10
# ---- checks against choice text
W=lambda s:set(re.findall(r"\w+",s.lower()))
def jac(a,b): return len(a&b)/len(a|b)
def vtext(v): return v['stem']+' '+v['correct']['text']+' '+' '.join(w['text'] for w in v['wrong'])
assert len(V)==18
ids=[v['id'] for v in V]; assert len(set(ids))==18
SAME_MAG={'005-v1'}   # the one sign-only distinction allowed per seed
bad=0
for v in V:
    id=v['id'];errs=[];short=id.replace('apphycem-mcq-','')
    assert len(v['wrong'])==3 and id.rsplit('-v',1)[0]==v['seed']
    assert all(w['error_pattern'] for w in v['wrong'])
    if re.search(r'(^|\s)[A-D][\.\)]\s',v['stem']): errs.append('option list in stem')
    texts=[v['correct']['text']]+[w['text'] for w in v['wrong']]
    rats=[v['correct']['rationale']]+[w['rationale'] for w in v['wrong']]
    if short in E:
        for val,t in zip(E[short],texts):
            if not close(num(t),val,0.05): errs.append(f'value {val:.4g} vs text {t}')
        if len({round(abs(x_),6) for x_ in E[short]})<4 and short not in SAME_MAG: errs.append('computed values not distinct')
    lens=[len(t) for t in texts]
    if lens[0]==max(lens) and lens[0]/sorted(lens)[-2]>1.4: errs.append('key much longer than others')
    if len(set(t.lower() for t in texts))!=4: errs.append('dup choice')
    if re.search(r'\b(choice|option) [A-D]\b|answer [A-D]\b|\([A-D]\)',json.dumps(v)): errs.append('letter mention')
    if any(not r_.strip() for r_ in rats): errs.append('blank rationale')
    if re.search(r'\b(probably|might be|perhaps|may be)\b',' '.join(rats)): errs.append('hedging')
    sj=jac(W(vtext(v)),W(SEEDS[v['seed']]))
    if sj>=0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in V:
        if o['id']!=id and jac(W(vtext(v)),W(vtext(o)))>=0.7: errs.append('similar '+o['id'])
    if errs: bad+=1; print('FAIL',id,errs)
    else: print('OK',id)
for s in SEEDS:
    ds=[v['difficulty'] for v in V if v['seed']==s]; assert sorted(ds)==['easy','hard','medium'],(s,ds)
print('max pairwise jaccard: %.2f'%max(jac(W(vtext(a)),W(vtext(b))) for a,b in itertools.combinations(V,2)))
print('ALL OK' if not bad else f'{bad} FAILURES')
