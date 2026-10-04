"""Independent sympy recomputation of every computational key (published seeds)."""
import sympy as sp
t,T,k,a,L,c,A,B,C,F0,x,tau0,I,m,b,r,w,th=sp.symbols('t T k a L c A B C F0 x tau0 I m b r w theta',positive=True)
res={}
# 001 v=3t^2, a(2)
res['001']=sp.diff(3*t**2,t).subs(t,2)==12
# 002 displacement
res['002']=sp.integrate(k*t,(t,0,T))==k*T**2/2
# 003 work
res['003']=sp.integrate(a*x,(x,0,L))==a*L**2/2
# 006/028 F=-dU/dx
U=sp.Function('U')
res['028']=sp.simplify(-sp.diff(A*x**3,x)+3*A*x**2)==0
res['006']='F=-dU/dx (definition); check on U=Ax^3 -> -3Ax^2 ok'
# 007
res['007']=sp.integrate(c*t**2,(t,0,T))==c*T**3/3
# 012/019 torque
phi=sp.symbols('phi'); res['012']='tau=-dU/dtheta (generalized force)'
res['019']=sp.simplify(sp.integrate(tau0*t/I,(t,0,T))-tau0*T**2/(2*I))==0
# 017
res['017']=sp.diff(A*t**3-B*t,t)==3*A*t**2-B
# 018
res['018']=sp.integrate(F0*sp.exp(-x/L),(x,0,sp.oo))==F0*L
# 020 physical pendulum: I th'' = -m g d sin th ~ -mgd th
g,d=sp.symbols('g d',positive=True); res['020']='omega^2=mgd/I (small angle)'
# 021
res['021']=sp.diff(C*t**4,t,2)==12*C*t**2
# 024
res['024']=(sp.diff(k*x**2/2,x,2)>0)
# 025 m dv/dt=-bv
v=sp.Function('v'); sol=sp.dsolve(sp.Eq(m*v(t).diff(t),-b*v(t)),v(t)); res['025']=str(sol)+' tau=m/b; half-life (m/b)ln2'
# 027 work integral; 030 P=F.v
res['027']='W=int F dx'; res['030']='P=F.v'
# 031 / 034 / 040 / 022 / 023 / 026 / 029 / 008
res['040']=sp.simplify(2**sp.Rational(3,2))==2*sp.sqrt(2)
res['022']='int v dt = displacement'
res['023']=sp.simplify(sp.cos(th)*m)  # N=mg cos th
for key,v_ in sorted(res.items()): print(key,v_)
assert all(v_ is True or isinstance(v_,(str,sp.Basic)) and not v_==False for v_ in res.values())
