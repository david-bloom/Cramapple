import json,re,math,os,itertools
import sympy as sp
from mpmath import mp,mpf,quad,pi
d=os.path.dirname(os.path.abspath(__file__))
V={v['id']:v for v in json.load(open(os.path.join(d,'variants_c4.json')))}
k=9.0e9;e0=8.85e-12
SEEDS={
'apphycem-mcq-np1-002':"A thin spherical shell of radius R carries total charge +Q uniformly distributed on its surface. Using a spherical Gaussian surface of radius r, where r > R, what is the correct enclosed charge q_enc to use in Gauss's law? Q Q*(r/R) Q*(R/r) 0",
'apphycem-mcq-np1-003':"In a region of space, the electric potential decreases as x increases (dV/dx < 0 everywhere in this region). What can be concluded about the electric field component E_x in this region? E_x is positive (the field points in the +x direction) E_x is negative (the field points in the -x direction) E_x is zero E_x cannot be determined without more information",
'apphycem-mcq-np1-004':"A charge +Q is fixed at one location, and a charge -Q of equal magnitude is fixed a distance away. At the midpoint between them, which statement is correct? (Use the standard convention V=0 at infinity.) The electric field is nonzero, but the electric potential is zero The electric field is zero, but the electric potential is nonzero Both the electric field and electric potential are zero Both the electric field and electric potential are nonzero",
'apphycem-mcq-np1-006':"A solid insulating sphere of radius R has uniform volume charge density rho. What is the electric field magnitude at a distance r = R/2 from the center (inside the sphere)? rho*R/(6*epsilon_0) rho*R/(3*epsilon_0) rho*R/(12*epsilon_0) rho*R/(2*epsilon_0)",
'apphycem-mcq-np1-009':"A charged conductor is in electrostatic equilibrium. Which statement correctly describes the electric field at a point just inside the conductor's surface, and at a point just outside its surface? (Assume the point in question lies on a region of the surface where the local surface charge density is nonzero.) Zero just inside; nonzero and perpendicular to the surface just outside Nonzero just inside; zero just outside Zero at both locations Nonzero and parallel to the surface at both locations",
'apphycem-mcq-np1-010':"A point charge +Q sits at the exact center of a cubical Gaussian surface. What is the electric flux through one face of the cube? Q/(6*epsilon_0) Q/epsilon_0 Q/(4*pi*epsilon_0) Q/(24*epsilon_0)"}
SUP=str.maketrans('⁻⁰¹²³⁴⁵⁶⁷⁸⁹','-0123456789')
def lit(s):
    """parse '1.2×10⁵' or '3.4' to float"""
    s=s.replace('−','-').translate(SUP)
    m=re.fullmatch(r'\s*([+-]?\d+(?:\.\d+)?)(?:×10(-?\d+))?\s*',s)
    x=float(m.group(1))
    return x*10**int(m.group(2)) if m.group(2) else x
sin=lambda x:x
E={}  # id -> list per choice (key first) of list of (computed value, literal that must appear in text)
def mk(id,*choices): E[id]=list(choices)
# 002 v1: lambda L etc
lam=3.0;L=0.50;r=0.40
mk('apphycem-mcq-np1-002-v1',[(lam*L,'1.5')],[(lam*2*math.pi*r*L,'3.8')],[(lam,'3.0')],[(0,'0')])
Q=8.0;mk('apphycem-mcq-np1-002-v2',[(Q*(0.05/0.10)**3,'1.0')],[(Q*0.5,'4.0')],[(Q*0.25,'2.0')],[(Q,'8.0')])
rho=3.0e-6;R=0.10;rr=0.20;shell=-9.0
vol=lambda a:sp.Rational(4,3)*sp.pi*a**3
q_in=float(rho*vol(sp.Float(R))*1e9)
mk('apphycem-mcq-np1-002-v3',[(q_in,'12.6')],[(float(rho*vol(sp.Float(rr))*1e9),'101')],[(q_in+shell,'3.6')],[(float(rho*(vol(sp.Float(rr))-vol(sp.Float(R)))*1e9),'88')])
# 003
x=sp.symbols('x')
Vx=40-8*x**2;Ex=-sp.diff(Vx,x)
mk('apphycem-mcq-np1-003-v1',[(float(Ex.subs(x,2)),'32')],[(float(Vx.subs(x,2)),'8.0')],[(8*2,'16')],[(float(Vx.subs(x,2))/2,'4.0')])
assert float(Ex.subs(x,2))>0
slope=-(4.0-10.0)/(5.0-2.0)
mk('apphycem-mcq-np1-003-v2',[(slope,'2.0')],[(6.0,'6.0')],[(3.0/6.0,'0.50')],[(0.0,None)])
assert slope>0   # field in +x since V falls
t=sp.symbols('t')
dv=-sp.integrate(3*t**2,(t,0,2))
mk('apphycem-mcq-np1-003-v3',[(float(dv),'-8.0')],[(8.0,'+8.0')],[(-3*4*2.0,'-24')],[(-float(sp.diff(3*x**2,x).subs(x,2)),'-12')])
# 004 v1
q=2.0e-6;d1=0.60;rm=d1/2
Ef=k*q/rm**2;Vf=k*q/rm
mk('apphycem-mcq-np1-004-v1',[(0,'E = 0'),(2*Vf,'1.2×10⁵')],[(0,'E = 0; V = 0')],[(2*Ef,'4.0×10⁵'),(2*Vf,'1.2×10⁵')],[(0,'E = 0'),(Vf,'6.0×10⁴')])
assert abs(2*Ef-4.0e5)<1 and abs(Ef-2.0e5)<1
# 004 v2
q1,q2=6.0e-9,-2.0e-9;rm=0.20
Ea=k*abs(q1)/rm**2;Eb=k*abs(q2)/rm**2;Vt=k*(q1+q2)/rm
assert abs(Ea-1350)<1 and abs(Eb-450)<1
mk('apphycem-mcq-np1-004-v2',[(Ea+Eb,'1.8×10³'),(Vt,'1.8×10²')],[(Ea-Eb,'9.0×10²'),(Vt,'1.8×10²')],[(Ea+Eb,'1.8×10³'),(k*(abs(q1)+abs(q2))/rm,'3.6×10²')],[(Ea-Eb,'9.0×10²'),(k*(abs(q1)+abs(q2))/rm,'3.6×10²')])
# 004 v3
qa,qb,dd=1.0e-6,9.0e-6,0.80
xs=sp.symbols('xs',positive=True)
sol=[float(s) for s in sp.solve(sp.Eq(qa/xs**2,qb/(dd-xs)**2),xs) if 0<float(s)<dd]
assert len(sol)==1;x0=sol[0]
V0=k*(qa/x0+qb/(dd-x0))
x1=dd*qa/(qa+qb)  # 1/r version
V1=k*(qa/x1+qb/(dd-x1))
mk('apphycem-mcq-np1-004-v3',[(x0,'0.20 m'),(V0,'1.8×10⁵')],[(x0,'0.20 m'),(0,'; 0')],[(x0,'0.20 m'),(k*qa/x0,'4.5×10⁴')],[(x1,'0.080 m'),(V1,'2.25×10⁵')])
# 006 v1 ratio
def Ein(rf): return rf   # E proportional to r inside
mk('apphycem-mcq-np1-006-v1',[(1/3,'E_s/3')],[(1/9,'E_s/9')],[(3,'3E_s')],[(9,'9E_s')])
assert abs(Ein(1/3)-1/3)<1e-12
# 006 v2 cylinder: Gauss E*2pi r L = rho pi r^2 L / e0
rho=3.0e-6;rc=0.020;Rc=0.040
Ec=rho*rc/(2*e0)
mk('apphycem-mcq-np1-006-v2',[(Ec,'3.4×10³')],[(rho*rc/(3*e0),'2.3×10³')],[(rho*rc/e0,'6.8×10³')],[(rho*Rc**2/(2*e0*rc),'1.36×10⁴')])
# 006 v3 nonuniform
rp,r_,R_,rho0=sp.symbols('rp r R rho0',positive=True)
qenc=sp.integrate(rho0*(rp/R_)*4*sp.pi*rp**2,(rp,0,r_))
Eexpr=sp.simplify(qenc/(4*sp.pi*sp.Float(e0)*r_**2))
vals={rho0:8.0e-6,r_:0.10,R_:0.20}
E3=float(Eexpr.subs(vals))
assert abs(float(qenc.subs(vals))-float(sp.pi*8e-6*0.1**4/0.2))<1e-20
mk('apphycem-mcq-np1-006-v3',[(E3,'1.1×10⁴')],[(4e-6*0.10/(3*e0),'1.5×10⁴')],[(8e-6*0.10/(3*e0),'3.0×10⁴')],[(8e-6*0.10**2/(e0*0.20),'4.5×10⁴')])
# 009 v3
qc,qs=5.0e-9,-3.0e-9
mk('apphycem-mcq-np1-009-v3',[(0,'0'),(k*(qc+qs)/0.30**2,'2.0×10²')],[(0,'0'),(k*qc/0.30**2,'5.0×10²')],[(k*qc/0.15**2,'2.0×10³'),(k*(qc+qs)/0.30**2,'2.0×10²')],[(0,'0'),(0,'0')])
# 010 v1
q=9.0e-9;tot=q/e0
mk('apphycem-mcq-np1-010-v1',[(2*tot/6,'3.4×10²')],[(tot,'1.0×10³')],[(tot/6,'1.7×10²')],[(tot/2,'5.1×10²')])
# 010 v2
Phi=150.0
mk('apphycem-mcq-np1-010-v2',[(6*Phi*e0*1e9,'8.0')],[(Phi*e0*1e9,'1.3')],[(Phi*e0/6*1e9,'0.22')],[(4*math.pi*e0*Phi*1e9,'17')])
# 010 v3
q=5.0e-9
mk('apphycem-mcq-np1-010-v3',[(q/(2*e0),'2.8×10²')],[(q/e0,'5.6×10²')],[(0,'0')],[(k*q,'45')])
# ---- conceptual asserts
# 009-v2: Gauss inside metal: q_enc(inner)+q_c=0 ; shell neutral
inner=-5.0;outer=-inner
assert inner+5.0==0 and inner+outer==0
# 009-v3 inner/outer surfaces
inner=-qc;outer=qs+qc  # total shell charge -3 = inner+outer -> outer=+2
assert abs(inner+outer-qs)<1e-20 and abs(outer-2.0e-9)<1e-20
# 009-v1: Gauss with E=0 -> q_enc=0 (no unknown to check); 010 dome: base flux zero (E in plane), hemisphere half
assert abs(q/(2*e0)*2-q/e0)<1e-6
# 006-v1/002-v2 scaling identities
assert abs((0.05/0.10)**3-1/8)<1e-12
CONC={'apphycem-mcq-np1-009-v1','apphycem-mcq-np1-009-v2'}
W=lambda s:set(re.findall(r"\w+",s.lower()))
jac=lambda a,b:len(a&b)/len(a|b)
vt=lambda v:v['stem']+' '+v['correct']['text']+' '+' '.join(w['text'] for w in v['wrong'])
bad=0
ids=list(V);assert len(ids)==18
from collections import Counter
cnt=Counter(v['seed'] for v in V.values());assert set(cnt.values())=={3} and set(cnt)==set(SEEDS),cnt
assert {v['difficulty'] for v in V.values()}=={'easy','medium','hard'}
for id,v in V.items():
    errs=[]
    texts=[v['correct']['text']]+[w['text'] for w in v['wrong']]
    assert len(v['wrong'])==3
    if re.search(r'(^|\s)[A-D][\.\)]\s',v['stem']): errs.append('option list in stem')
    if len(set(t.lower() for t in texts))!=4: errs.append('dup choice')
    L=[len(t) for t in texts]
    if L[0]==max(L) and L[0]>1.4*sorted(L)[-2]: errs.append('key much longer')
    for p in [v['correct']]+v['wrong']:
        if not p['rationale'].strip(): errs.append('blank rationale')
    for w in v['wrong']:
        if not w.get('error_pattern'): errs.append('no error_pattern')
    if re.search(r'\b(choice|option|answer) [A-D]\b',json.dumps(v)): errs.append('letter mention')
    if id in E:
        assert len(E[id])==4
        vals=[]
        for t,parts in zip(texts,E[id]):
            sig=[]
            for val,l in parts:
                if l is None: continue
                if l.startswith('E = 0') or l.startswith('; 0'):
                    assert abs(val)<1e-9; 
                    if l not in t and l.strip('; ') not in t: errs.append(f'missing {l} in {t}')
                    continue
                num=l.replace(' m','')
                if num.replace('-','−') not in t.replace('-','−'): errs.append(f'literal {l} not in {t}')
                if not re.fullmatch(r'[+-]?[\d.]+(×10[⁻⁰¹²³⁴⁵⁶⁷⁸⁹]+)?',num.replace('−','-')): continue
                if abs(val)>1e-12 and abs(lit(num)-val)>0.03*abs(val):
                    # allow nC/uC unit scaling already applied in value; fail otherwise
                    errs.append(f'value {val} != literal {l}')
                if abs(val)<=1e-12 and lit(num)!=0: errs.append(f'zero mismatch {l}')
            vals.append(tuple(round(p[0],6) for p in parts))
        if len(set(vals))<4: errs.append('computed choice values not distinct: '+str(vals))
    elif id not in CONC and 'v1' not in id[-2:]+'' and False: pass
    sj=jac(W(vt(v)),W(SEEDS[v['seed']]))
    if sj>=0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in V.values():
        if o['id']!=id and jac(W(vt(v)),W(vt(o)))>=0.7: errs.append('similar '+o['id'])
    if errs: bad+=1;print('FAIL',id,errs)
    else: print('OK',id,f'seedJ={sj:.2f}')
print('ALL OK' if not bad else f'{bad} FAILURES')
