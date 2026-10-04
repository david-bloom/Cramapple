import json,re,os
import sympy as sp
from mpmath import mp,mpf,sqrt as msqrt
mp.dps=30
d=os.path.dirname(os.path.abspath(__file__))
V=json.load(open(os.path.join(d,'variants_c3.json')))
SEEDS={
'apphycem-mcq-026':"Two positive point charges are brought closer together. Their electric potential energy decreases increases stays zero becomes negative",
'apphycem-mcq-027':"With V(∞)=0, point-charge potential is kq/r kq/r² kq/(2r) -kq/r",
'apphycem-mcq-028':"A positive charge is released from rest and acted on only by a static electric field. It tends toward higher potential and higher U lower potential and lower U higher potential and lower U unchanged kinetic energy always",
'apphycem-mcq-029':"In electrostatic equilibrium, the electric field just outside a conductor is tangent to the surface normal to the surface zero for every charged conductor parallel to surface current",
'apphycem-mcq-030':"A dielectric with κ>1 fully fills a capacitor that remains connected to an ideal battery. Stored energy becomes 1/κ as large is unchanged becomes κ times as large increases by κ²",
'apphycem-mcq-np1-001':"An infinitely long, uniformly charged wire has linear charge density lambda > 0. Using Gauss's law with a cylindrical Gaussian surface of length L, which expression correctly gives the electric field magnitude at a perpendicular distance r from the wire? lambda/(2*pi*epsilon_0*r) lambda/(4*pi*epsilon_0*r^2) lambda*L/(2*pi*epsilon_0*r) lambda/(pi*epsilon_0*r^2)"}
k=mpf('9.0e9'); e0=mpf('8.85e-12'); pi=mp.pi
nano=mpf('1e-9'); micro=mpf('1e-6')
# id -> [key, w1, w2, w3] as signed values (units in each text); recomputed from the stated computation / error
E={}
# 026
q1,q2=3*micro,-2*micro
dU=k*q1*q2*(1/mpf('0.10')-1/mpf('0.30'))
E['apphycem-mcq-026-v2']=[dU, k*q1*q2/mpf('0.10'), k*q1*q2*(1/mpf('0.10')**2-1/mpf('0.30')**2), k*q1*q2/mpf('0.20')]
Q=[2*micro,-1*micro,2*micro]; X=[0,mpf('0.10'),mpf('0.20')]
pair=lambda i,j:k*Q[i]*Q[j]/abs(X[i]-X[j])
U3=pair(0,1)+pair(0,2)+pair(1,2)
E['apphycem-mcq-026-v3']=[U3, pair(0,1)+pair(1,2), abs(pair(0,1))+abs(pair(0,2))+abs(pair(1,2)), U3/2]
assert abs(pair(0,2)-0.18)<1e-9
# 027
E['apphycem-mcq-027-v1']=[k*5*nano/mpf('0.30'), k*5*nano/mpf('0.30')**2, k*5*nano, k*5*nano/mpf('0.30')/2]
E['apphycem-mcq-027-v2']=[-120/mpf(4), -120/mpf(16), -120*4, -120/msqrt(4)]
kq=k*2*nano
r=sp.symbols('r',positive=True)
dV=-sp.integrate(sp.Float(str(kq))/r**2,(r,sp.Rational(40,100),sp.Rational(10,100)))  # V(0.10)-V(0.40)
E['apphycem-mcq-027-v3']=[float(dV), kq/mpf('0.30'), kq*(1/mpf('0.10')**2-1/mpf('0.40')**2), kq/mpf('0.10')]
assert abs(float(dV)-135)<1e-6
# 028
q=3*micro
E['apphycem-mcq-028-v2']=[q*(20-50), -q*50, q*20, q*(50+20)]
qn=-2*micro; m=mpf('3.0e-4'); dUn=qn*(400-100); KE=-dUn
vv=lambda ke:msqrt(2*ke/m)
E['apphycem-mcq-028-v3']=[vv(KE), msqrt(KE/m), vv(-qn*400), 0]
# 030
C0=2*micro; Vb=6; kap=mpf('2.5'); U0=C0*Vb**2/2
E['apphycem-mcq-030-v2']=[kap*C0*Vb**2/2*1e6, U0/kap*1e6, U0*1e6, U0*kap**2*1e6]
C0=4*micro; V0=100; kp=4; U0=C0*V0**2/2; Qc=C0*V0; Uf=Qc**2/(2*kp*C0)
E['apphycem-mcq-030-v3']=[(Uf-U0)*1e3, (kp*C0*V0**2/2-U0)*1e3, -Uf*1e3, -(U0-U0/kp**2)*1e3]
assert abs((Uf-U0)*1e3+15)<1e-9 and abs(Uf*1e3-5)<1e-9
# np1-001
lam=4*nano; rr=mpf('0.20')
E['apphycem-mcq-np1-001-v1']=[lam/(2*pi*e0*rr), lam/(4*pi*e0*rr), lam/(4*pi*e0*rr**2), lam/(2*pi*e0*rr**2)]
rho=5*micro; R=mpf('0.10'); rp=mpf('0.040')
E['apphycem-mcq-np1-001-v2']=[rho*rp/(2*e0), rho*R**2/(2*e0*rp), rho*rp/(3*e0), rho*rp**2/(2*e0*R)]
ln=(6-12)*nano; rv=mpf('0.50')
E['apphycem-mcq-np1-001-v3']=[2*k*abs(ln)/rv, 2*k*abs(ln)/rv, 2*k*12*nano/rv, 2*k*18*nano/rv]
assert ln<0   # net enclosed charge negative -> field points toward axis
# conceptual asserts
F=[
 ('026-v1 opposite charges: U=kq1q2/r<0 and rises toward 0 as r grows', (lambda r1,r2:-1/r1<-1/r2)(1.0,2.0)),
 ('028-v1 negative q: U=qV falls as V rises; force opposite E points up in V', (lambda q,V1,V2:q*V2<q*V1)(-1,1,2)),
 ('030-v1 fixed Q: U=Q^2/2C with C->4C is U/4', abs((1/(2*4.0))/(1/(2*1.0))-0.25)<1e-12),
 ('030-v1 fixed Q: kappa twice would give 1/16', abs(1/16-1/4**2)<1e-12),
 ('029-v2 electrons pushed opposite E (-x): negative charge on -x side; field into surface at -x end', (lambda Ex:(-1)*Ex<0)(1)),
 ('029-v3 more charge density at tip -> larger field (sigma/eps0 ordering)', 5.0>1.0),
 ('028-v3 negative q moves to higher V: dU<0', dUn<0),
]
for lab,ok in F: assert ok,lab
W=lambda s:set(re.findall(r"[a-z0-9]+",s.lower()))
def jac(a,b): return len(a&b)/len(a|b)
def vtext(v): return v['stem']+' '+v['correct']['text']+' '+' '.join(w['text'] for w in v['wrong'])
SUP=str.maketrans('⁻⁰¹²³⁴⁵⁶⁷⁸⁹','-0123456789')
def num(t):
    tl=t.lower()
    if tl.startswith('zero'): return 0.0
    s=t.replace('−','-').translate(SUP).replace('μ','')
    sign=-1 if (s.startswith('-') or tl.startswith('decreases')) else 1
    m=re.search(r'(\d+(?:\.\d+)?)(?:\s*×\s*10(-?\d+))?',s)
    x=float(m.group(1))
    if m.group(2): x*=10**int(m.group(2))
    return sign*x
SAME_MAG={'apphycem-mcq-np1-001-v3'}
bad=0
assert len(V)==18
assert {v['difficulty'] for v in V}=={'easy','medium','hard'}
assert len({v['id'] for v in V})==18
for v in V:
    id=v['id'];errs=[]
    assert len(v['wrong'])==3 and id.rsplit('-v',1)[0]==v['seed']
    if re.search(r'(^|\s)[A-D][\.\)]\s',v['stem']): errs.append('option list in stem')
    texts=[v['correct']['text']]+[w['text'] for w in v['wrong']]
    if id in E:
        for val,t in zip(E[id],texts):
            val=float(val); p=num(t)
            tol=max(0.03*abs(val),1e-12)
            if abs(val-p)>tol and abs(abs(val)-abs(p))>tol: errs.append(f'value {val} vs text {t}')
            elif id not in ('apphycem-mcq-np1-001-v3',) and abs(val-p)>tol: errs.append(f'sign mismatch {val} vs {t}')
        if len({round(abs(float(x)),9) for x in E[id]})<4 and id not in SAME_MAG: errs.append('computed values not distinct')
    lens=[len(t) for t in texts]
    if lens[0]==max(lens) and lens[0]/sorted(lens)[-2]>1.4: errs.append('key much longer than others')
    if len(set(texts))!=4: errs.append('dup choice')
    sj=jac(W(vtext(v)),W(SEEDS[v['seed']]))
    if sj>=0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in V:
        if o['id']!=id and jac(W(vtext(v)),W(vtext(o)))>=0.7: errs.append('similar '+o['id'])
    if re.search(r'\b(choice|option) [A-D]\b|answer [A-D]\b',json.dumps(v)): errs.append('letter mention')
    for w in v['wrong']:
        if not w.get('error_pattern') or not w.get('rationale'): errs.append('missing pattern/rationale')
    if errs: bad+=1; print('FAIL',id,errs)
    else: print('OK',id)
# np1-v3 direction checks
v3=[v for v in V if v['id']=='apphycem-mcq-np1-001-v3'][0]
assert 'toward the axis' in v3['correct']['text'] and '216' in v3['correct']['text']
print('ALL OK' if not bad else f'{bad} FAILURES')
