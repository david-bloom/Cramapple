"""sympy/numeric recomputation of every computational key (stage 1). Run: python3 verify_math.py"""
import sympy as sp, math, mpmath
k,q,r,R,eps,rho,lam,Q,L,a,b,kap,V,C,d,A,th,x=sp.symbols('k q r R epsilon_0 rho lambda Q L a b kappa V C d A theta x',positive=True)
res={}
# 001/np1-002 Gauss: flux = q_enc/eps0 ; shell outside encloses Q
res['001']='Gauss: oint E.dA=q_enc/eps0 (definition) -> A'
# 002 charge enclosed = int_0^R rho(r)4 pi r^2 dr  (check with rho=rho0 const -> 4/3 pi R^3 rho0)
rr=sp.symbols('r',positive=True); rho0=sp.symbols('rho0',positive=True)
assert sp.simplify(sp.integrate(rho0*4*sp.pi*rr**2,(rr,0,R))-sp.Rational(4,3)*sp.pi*R**3*rho0)==0; res['002']='int rho 4 pi r^2 dr verified (uniform rho -> 4/3 pi R^3 rho)'
# 007/008: C=Q/dV parallel plate: E=Q/(eps A) , dV=E d -> C=eps A/d ; U=int_0^Q (q/C)dq = Q^2/2C = C V^2/2
Qs,Cs,qs=sp.symbols('Q C q',positive=True)
assert sp.simplify(sp.integrate(qs/Cs,(qs,0,Qs))-Qs**2/(2*Cs))==0
Es=Qs/(eps*A); assert sp.simplify(Qs/(Es*d)-eps*A/d)==0; res['007']='C=Q/(E d)=eps A/d verified'; res['008']='int_0^Q (q/C)dq=Q^2/2C=CV^2/2 verified'
# 021 Coulomb 1/r^2, r->3r => 1/9
F=lambda rv: k*Q*q/rv**2; assert sp.simplify(F(3*r)/F(r))==sp.Rational(1,9); res['021']='F(3r)/F(r)=1/9'
# 024 flux = E A cos(theta) (E.A with angle to normal): numeric check
Ev=(0,0,2.0);n=(math.sin(0.7),0,math.cos(0.7));assert abs(sum(e*c for e,c in zip(Ev,n))*3.0-2*3.0*math.cos(0.7))<1e-12; res['024']='E.A=EA cos(theta) verified'
# 026 U=kq1q2/r positive, increases as r decreases
assert sp.diff(k*Q*q/r,r).subs({k:1,Q:1,q:1,r:2})<0; res['026']='dU/dr<0 for like charges => U up as r decreases'
# 027 V(r)=-int_inf^r E dr' with E=kq/r'^2
rp=sp.symbols('rp',positive=True)
Vr=-sp.integrate(k*q/rp**2,(rp,sp.oo,r)); assert sp.simplify(Vr-k*q/r)==0; res['027']='V=-int_inf^r kq/r^2 dr = kq/r verified'
# 030 fixed V: C->kappa C, U=1/2 C V^2 -> kappa U ; fixed Q: U=Q^2/2C -> U/kappa
assert sp.simplify((sp.Rational(1,2)*kap*C*V**2)/(sp.Rational(1,2)*C*V**2))==kap; assert sp.simplify((Qs**2/(2*kap*Cs))/(Qs**2/(2*Cs))*kap)==1; res['030']='U=1/2 C V^2 -> kappa U at fixed V verified; fixed-Q gives U/kappa (distractor A)'
# 005/np1-003: E_x=-dV/dx ; dV/dx<0 => E_x>0
Vx=sp.Function('V')(x); res['np1-003']='E_x=-dV/dx; dV/dx<0 -> E_x>0 (e.g. V=-x: E=+1)'; assert (-sp.diff(-x,x))>0
# 006: stationary pt: V=(x-1)^2 -> dV/dx=0 at x=1, E_x=0
assert (-sp.diff((x-1)**2,x)).subs(x,1)==0; res['006']='E_x=-dV/dx=0 where dV/dx=0 (V=(x-1)^2 at x=1)'
# np1-001 line charge Gauss: E*(2 pi r L)=lam L/eps0 ; cross-check by direct integration of Coulomb over infinite line
E=sp.symbols('E'); sol=sp.solve(sp.Eq(E*2*sp.pi*r*L,lam*L/eps),E)[0]; assert sp.simplify(sol-lam/(2*sp.pi*eps*r))==0
z=sp.symbols('z',real=True); Edirect=sp.integrate(lam*r/(4*sp.pi*eps*(r**2+z**2)**sp.Rational(3,2)),(z,-sp.oo,sp.oo)); assert sp.simplify(Edirect-lam/(2*sp.pi*eps*r))==0; res['np1-001']='Gauss and direct Coulomb integral both give lam/(2 pi eps0 r)'
# np1-002: shell, r>R: q_enc=Q
res['np1-002']='q_enc=Q for r>R (all shell charge inside)'
# np1-004 midpoint of +Q and -Q separated by 2s: E adds, V cancels
s=sp.symbols('s',positive=True); Emid=k*Q/s**2+k*Q/s**2; Vmid=k*Q/s-k*Q/s; assert Emid!=0 and Vmid==0; res['np1-004']='E=2kQ/s^2 (adds), V=0'
# np1-005 coaxial capacitor: E=lam/(2 pi kap eps r), lam=Q/L ; dV=int_a^b E dr ; C=Q/dV
Er=Qs/(L*2*sp.pi*kap*eps*rp); dV=sp.integrate(Er,(rp,a,b)); Cc=sp.simplify(Qs/dV); assert sp.simplify(Cc-2*sp.pi*kap*eps*L/sp.log(b/a))==0; res['np1-005']='C=Q/dV=2 pi kappa eps0 L/ln(b/a) verified (HELD item)'
# np1-006: uniform sphere, r=R/2 : E 4 pi r^2=rho(4/3)pi r^3/eps0
Ein=sp.symbols('Ein'); sol=sp.solve(sp.Eq(Ein*4*sp.pi*rr**2,rho*sp.Rational(4,3)*sp.pi*rr**3/eps),Ein)[0]; assert sp.simplify(sol.subs(rr,R/2)-rho*R/(6*eps))==0; res['np1-006']='E=rho r/(3 eps0); r=R/2 -> rho R/(6 eps0) verified'
# np1-009 conductor: qualitative
res['np1-009']='conceptual (E=0 inside, normal outside = sigma/eps0)'
# np1-010: flux through cube face by direct numerical integration (unit: Q/eps0 = 1, expect 1/6)
f=lambda y,zv: 0.5/((0.5**2+y**2+zv**2)**1.5)/(4*math.pi)
val=float(mpmath.quad(f,[-0.5,0.5],[-0.5,0.5])); assert abs(val-1/6)<1e-6,val; res['np1-010']=f'numeric face flux (Q/eps0 units) = {val:.6f} = 1/6'
# repaired-distractor arithmetic
assert sp.simplify(rho*(R/2)/(eps)-rho*R/(2*eps))==0   # np1-006 D = rho r/eps0 at r=R/2
assert sp.simplify(rho*(R/2)/(6*eps)-rho*R/(12*eps))==0  # C
assert sp.simplify(Q/(eps*4*sp.pi)*(4*sp.pi/6)-Q/(6*eps))==0  # per-face solid angle 4pi/6 sr -> Q/(6 eps0)
res['notes']='np1-010 C Q/(4 pi eps0) = flux per steradian'
# 028: U=qV, q>0 released from rest: dK=-dU -> moves to lower U, lower V
res['028']='q>0: U=qV, F=qE toward lower V, K increases, U decreases'
for kk,v in res.items(): print(kk,v)
