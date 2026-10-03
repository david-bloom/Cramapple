import json, itertools
from sympy import *
import re
D="/Users/davidbloom/Documents/Cramapple.nosync/scripts/content-seed/pipeline-v2-precalc-u13-2026-10-03/"
V={v["id"]:v for v in json.load(open(D+"variants_c1.json"))}
seeds={s["key"]:s for s in json.load(open(D+"seeds_final.json"))}
x,t=symbols('x t'); R=Rational
def num(s):  # parse choice text to number
    s=s.replace("−","-").replace("x = ","").replace("√","sqrt").replace("^","**")
    return sympify(s.replace("(","(").strip())
def expr(s):
    s=s.replace("−","-").replace("^","**").replace("√","sqrt").replace("²","**2").replace("³","**3")
    s=s.split("=",1)[-1] if s.startswith(("P(x)","x =")) else s
    s=re.sub(r'(\d)\(',r'\1*(',s); s=re.sub(r'\)\(',r')*(',s); s=re.sub(r'(\d)(x|t)',r'\1*\2',s)
    s=s.replace("log₃20","log(20,3)").replace("log₇30","log(30,7)").replace("log₃5","log(5,3)").replace("log₇34","log(34,7)")
    s=s.replace("ln 14","log(14)").replace("ln 7","log(7)").replace("ln(7/3)","log(R(7,3))")
    return sympify(s,locals={"x":x,"t":t,"R":R})
ok=True
def chk(i,cond,msg):
    global ok
    if not cond: ok=False; print("FAIL",i,msg)
def vals(i):
    v=V[i]; return [v["correct"]["text"]]+[w["text"] for w in v["wrong"]]
def eq(i,expected):  # expected: list of 4 values (key first) from error computations
    got=[num(c) for c in vals(i)]
    chk(i,all(simplify(g-e)==0 for g,e in zip(got,expected)),f"{got} vs {expected}")
    chk(i,len(set(expected))==4,"duplicate values")
# 001
s=lambda t_:t_**3-2*t_
eq("apprecalc-mcq-001-v1",[R(s(2)-s(-1),3),s(3),R(s(-1)-s(2),3),s(2)-s(-1)])
N={0:10,2:18,4:29,6:42}
eq("apprecalc-mcq-001-v2",[R(N[6]-N[2],4),N[6]-N[2],R(N[2]+N[6],2),R(N[6]-N[2],6+2)])
r=lambda q:R(6,q)
eq("apprecalc-mcq-001-v3",[R(r(6)-r(2),4),R(r(2)-r(6),4),r(6)-r(2),r(4)])
# 002 end behavior via sympy leading terms
def lead(p):
    p=Poly(expand(p),x); return p.degree(),p.LC()
def beh(p):
    d,c=lead(p)
    L="falls" if (d%2==1 and c>0) else None
    return d,c
for i,p,key in [("v1",3*x**4-5*x**3+x,"bothup"),("v2",(1-x**2)*(x**2+4),"bothdown"),("v3",4*x**7-x**6+9,"oddup")]:
    d,c=lead(p)
    got={"bothup":d%2==0 and c>0,"bothdown":d%2==0 and c<0,"oddup":d%2==1 and c>0}[key]
    chk(i,got,"end behavior"); 
    lt={"v1":"rises on both","v2":"falls on both","v3":"falls on the left and rises"}[i]
    chk(i,lt in V["apprecalc-mcq-002-"+i]["correct"]["text"],"key text")
chk("002v2",expand((1-x**2)*(x**2+4))==-x**4-3*x**2+4,"expansion")
# 003
def hole(num_,den_,x0):
    f=cancel(num_/den_); return f.subs(x,x0)
chk("003v1",factor(x**2-x-12)==(x-4)*(x+3) and hole(x**2-x-12,x-4,4)==7 and (x**2-x-12).subs(x,4)==0,"v1")
chk("003v2",hole(x**2-4,(x-2)*(x+5),2)==R(4,7) and (x**2-4).subs(x,2)==0 and abs(limit(((x**2-4)/((x-2)*(x+5))),x,-5,'+'))==oo,"v2")
chk("003v3",hole(x**3-8,x-2,2)==12 and (x**3-8).subs(x,2)==0 and (x**2).subs(x,2)==4 and factor(x**3-8)==(x-2)*(x**2+2*x+4),"v3")
# 004
P=(x+2)**3*(x-5)**2*(x-1)
mult={r_:m for r_,m in roots(Poly(expand(P),x)).items()}
chk("004v1",mult=={-2:3,5:2,1:1},"mult")
chk("004v1b",[r_ for r_ in mult if mult[r_]%2==1]==[-2,1] or set(r_ for r_ in mult if mult[r_]%2)=={-2,1},"cross set")
def beh2(f):
    m=roots(Poly(expand(f),x)); return {r_:('touch' if k%2==0 else 'cross') for r_,k in m.items()}
want={3:'touch',-2:'cross'}
cands=[(x-3)**2*(x+2),(x-3)*(x+2)**2,(x+3)**2*(x-2),(x-3)*(x+2)]
res=[beh2(c)==want for c in cands]
chk("004v2",res==[True,False,False,False],str(res))
chk("004v3",2+1+1==4 and 3+1+1==5 and 2+2+2==6 and 1+1+1==3,"deg")
# 006
f1=lambda z:3*z+2; g1=lambda z:z**2-1
chk("006v1",expand(f1(g1(x))-3*x**2+1)==0 and expand(g1(f1(x)))==9*x**2+12*x+3 and expand(f1(x)+g1(x))==x**2+3*x+1 and expand(f1(x)*g1(x))==3*x**3+2*x**2-3*x-2,"v1")
f2=lambda z:sqrt(z+5); g2=lambda z:z**2-4
chk("006v2",simplify(f2(g2(x))-sqrt(x**2+1))==0 and simplify(g2(f2(x))-(x+1))==0 and simplify(f2(g2(x))-(sqrt(x**2-4)+5))!=0 and simplify(f2(g2(x))-x-1)!=0,"v2")
f3=lambda z:2**z; g3=lambda z:z**2-5
chk("006v3",(g3(f3(3)),f3(g3(3)),f3(3)+g3(3),f3(3)**2)==(59,16,12,64),"v3")
# 007
Q=(2*x**2-3*x+1)/(x**2+4); chk("007v1",limit(Q,x,oo)==2,"v1")
Rr=(x+3)*(2*x-1)*(x-4)/(x**2+1); chk("007v2",limit(Rr/x,x,oo)==2 and limit(Rr-2*x,x,oo)!=oo and limit(Rr/(2*x**2),x,oo)==0,"v2")
S=(5*x**2+1)/(2*x**3-x); chk("007v3",limit(S,x,oo)==0 and abs(float(S.subs(x,100))-0.025)<0.001 and S.subs(x,100)==R(50001,1999900),"v3")
# 008
chk("008v1",(250*R(88,100),250*R(12,100),250*R(112,100))==(220,30,280),"v1")
a=lambda tt:40*2**R(tt,3); chk("008v2",a(3)==80 and 40*2**(3*1)==320 and 40*2**3==320 and abs(float(40*R(4,3)**3)-94.81)<0.01,"v2")
tab={0:12,1:18,2:27,3:R(81,2)}
chk("008v3",all(12*R(3,2)**k==v for k,v in tab.items()) and 12+6*2==24 and 12*6==72 and 18*R(3,2)**0==18 and [tab[k+1]-tab[k] for k in range(3)]==[6,9,R(27,2)],"v3")
# 009
sol=solve(Eq(log(x+2,3),4),x); chk("009v1",sol==[79] and (4-2,81+2,3*4-2)==(2,83,10),"v1")
chk("009v2",solve(Eq(log(2*x,5),2),x)==[R(25,2)] and (R(25,2)*2==25) and R(5*2,2)==5 and R(2,2)==1,"v2")
cand=solve(x*(x-6)-16,x); chk("009v3",set(cand)=={8,-2} and 8>6 and (2*x-6).subs(x,11)==16,"quad")
chk("009v3b",simplify(log(8,4)+log(2,4)-2)==0 and (x+(x-6)).subs(x,11)==16 and set(solve(x**2-6*x-2,x))=={3+sqrt(11),3-sqrt(11)} and 3-sqrt(11)<0,"v3")
# 011: verify key solves, distractors do not
def lg(a,b): return log(a)/log(b)
def test(i,eqf,xs):
    vs=[N_(z) for z in xs]; return vs
def N_(z): return float(z.evalf()) if hasattr(z,'evalf') else float(z)
def solves(lhs,rhs,z): return abs(N_(lhs(z))-rhs)<1e-9
def l(a,b): return log(a)/log(b)
c1=[(l(20,3)-2)/4,(l(20,3)+2)/4,l(20,3)/4-2,l(5,3)-2]
chk("011v1",solves(lambda z:3**(4*z+2),20,c1[0]) and not any(solves(lambda z:3**(4*z+2),20,c) for c in c1[1:]),"v1")
c2=[4+l(30,7),l(30,7)-4,4*l(30,7),l(34,7)]
chk("011v2",solves(lambda z:7**(z-4),30,c2[0]) and not any(solves(lambda z:7**(z-4),30,c) for c in c2[1:]),"v2")
c3=[log(7)/3,log(14)/3,log(R(7,3)),3*log(7)]
chk("011v3",solves(lambda z:2*exp(3*z),14,c3[0]) and not any(solves(lambda z:2*exp(3*z),14,c) for c in c3[1:]),"v3")
# ---- structural checks
def toks(v): return set(re.findall(r"\S+"," ".join([v["stem"]]+vals(v["id"]))))
def jac(a,b): return len(a&b)/len(a|b)
for i,v in V.items():
    chk(i,len(v["wrong"])==3,"3 wrong")
    chk(i,all(w["rationale"].strip() and w["error_pattern"] for w in v["wrong"]) and v["correct"]["rationale"],"rats")
    chk(i,not re.search(r"\b[A-D]\.\s",v["stem"]),"option list in stem")
    texts=vals(i); chk(i,len(set(texts))==4,"dup choice text")
    L=[len(c) for c in texts]
    if max(L[1:])>8: chk(i,L[0]<=1.4*max(L[1:]),f"key length {L}")
    sd=seeds[v["seed"]]; st=set(re.findall(r"\S+"," ".join([sd["stem"],sd["correct"]["text"]]+[w["text"] for w in sd["wrong"]])))
    j=jac(toks(v),st); chk(i,j<0.7,f"jaccard seed {j:.2f}")
    print(f"{i} jseed={j:.2f}", end="  ")
    sibs=[k for k in V if k.startswith(i[:-3]) and k!=i]
    print("jsib=",[round(jac(toks(v),toks(V[k])),2) for k in sibs])
    chk(i,all(not any(w["text"]==c for c in [v["correct"]["text"]]) for w in v["wrong"]),"")
print("ALL OK" if ok else "FAILURES"); print(len(V),"variants")
