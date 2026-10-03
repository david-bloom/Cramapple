import json, re
import sympy as sp
D="/Users/davidbloom/Documents/Cramapple.nosync/scripts/content-seed/pipeline-v2-precalc-u13-2026-10-03/"
V={x["id"]:x for x in json.load(open(D+"variants_c2.json"))}
seeds={s["key"]:s for s in json.load(open(D+"seeds_final.json"))}
x=sp.symbols('x'); pi=sp.pi; R=sp.Rational
def P(t):
    t=t.replace("−","-").replace("π","*pi").replace("√","*sqrt")
    t=re.sub(r"sqrt(\d+)",r"sqrt(\1)",t)
    t=t.lstrip("*").replace("(*","(").replace(",*",",").replace("/*","/")
    t=re.sub(r"(\d)(sqrt|pi)",r"\1*\2",t)
    t=re.sub(r"(^|[(,/])-\*",r"\1-",t)
    return sp.sympify(t)
def Ptup(t): return tuple(P(s) for s in t.strip("()").split(","))
def texts(v): return v["correct"]["text"],[w["text"] for w in v["wrong"]]
def eq(a,b): return sp.simplify(a-b)==0
def tupeq(a,b): return all(eq(i,j) for i,j in zip(a,b))
errs=[]
def chk(c,m):
    if not c: errs.append(m)
def num_check(i,key,wr,parse=P,cmp=eq):
    c,w=texts(V[i])
    chk(cmp(parse(c),key),f"{i} key {c} != {key}")
    for t,val in zip(w,wr): chk(cmp(parse(t),val),f"{i} wrong {t} != {val}")
    for t in w: chk(not cmp(parse(t),key),f"{i} wrong {t} equals key")
# 013
frac=lambda t: R(int(t.split("/")[0]),int(t.split("/")[1]))
num_check("apprecalc-mcq-013-v1",R(1,2)**(20//4),[R(1,20//4),R(1,5*2),R(1,5**2)],frac)
pct=lambda t: sp.nsimplify(t.strip("%"))/100
num_check("apprecalc-mcq-013-v2",R(1,2)**4,[R(1,4),R(1,2)**(24//6-1),R(1,2)**5],pct)
mg=lambda t: sp.nsimplify(t.replace(" mg",""))
num_check("apprecalc-mcq-013-v3",80*R(1,2)**3,[80*R(1,2)**2,R(80,3),80-24],mg,lambda a,b:abs(float(a)-float(b))<0.05)
# 015
d=lambda n: R(n,180)*pi
num_check("apprecalc-mcq-015-v1",d(210),[210*pi/90,210*pi/360,R(180,210)*pi])
num_check("apprecalc-mcq-015-v2",d(135),[135*pi/360,R(180,135)*pi,135*pi])
num_check("apprecalc-mcq-015-v3",d(-120),[d(120),-R(180,120)*pi,-120*pi/360])
# 016
def pair(t):
    a,b=t.split(" and y="); return (P(a),P(b))
mx_,mn_=R(74,10),R(12,10)
num_check("apprecalc-mcq-016-v1",((mx_-mn_)/2,(mx_+mn_)/2),[(mx_-mn_,(mx_+mn_)/2),((mx_-mn_)/2,mx_),((mx_+mn_)/2,(mx_-mn_)/2)],pair,tupeq)
num_check("apprecalc-mcq-016-v2",((10+2)/2,(10-2)/2),[(12,4),(6,10-2),(4,6)],pair,tupeq)
num_check("apprecalc-mcq-016-v3",((9-1)/2,(9+1)/2),[(8,5),(5,4),(3.5-0.5,5)],pair,tupeq)
# 019
c=sp.cos; s_=sp.sin
num_check("apprecalc-mcq-019-v1",(-4*c(pi/3),-4*s_(pi/3)),[(4*c(pi/3),4*s_(pi/3)),(-4*c(pi/3),4*s_(pi/3)),(-4*s_(pi/3),-4*c(pi/3))],Ptup,tupeq)
num_check("apprecalc-mcq-019-v2",(6*c(5*pi/6),6*s_(5*pi/6)),[(6*c(pi/6),6*s_(5*pi/6)),(6*s_(5*pi/6),6*c(5*pi/6)),(6*c(5*pi/6),-6*s_(5*pi/6))],Ptup,tupeq)
t7=7*pi/6
num_check("apprecalc-mcq-019-v3",(-6*c(t7),-6*s_(t7)),[(6*c(t7),6*s_(t7)),(-6*c(t7),6*s_(t7)),(-6*s_(t7),-6*c(t7))],Ptup,tupeq)
# 018
num_check("apprecalc-mcq-018-v1",sp.asin(-sp.sqrt(3)/2),[sp.asin(sp.sqrt(3)/2),4*pi/3,5*pi/3])
for t in ["4π/3","5π/3"]: chk(eq(sp.sin(P(t)),-sp.sqrt(3)/2),"018v1 sin "+t)
num_check("apprecalc-mcq-018-v2",sp.atan(-1),[3*pi/4,7*pi/4,pi/4])
for t in ["3π/4","7π/4"]: chk(eq(sp.tan(P(t)),-1),"018v2 tan "+t)
num_check("apprecalc-mcq-018-v3",sp.acos(-sp.sqrt(2)/2),[-3*pi/4,5*pi/4,pi/4])
for t in ["−3π/4","5π/4"]: chk(eq(sp.cos(P(t)),-sp.sqrt(2)/2),"018v3 cos "+t)
# 017
def sols(f):
    out=[]
    for k in range(0,24):
        a=k*pi/12
        try:
            if abs(float(f(a)))<1e-9: out.append(a)
        except Exception: pass
    return out
def solset(t): return [P(p.strip()) for p in t.replace(" only","").split(" and ")]
def same(a,b): return len(a)==len(b) and all(any(eq(p,q) for q in b) for p in a)
def sc(i,f,wrongs):
    c,w=texts(V[i]); true=sols(f)
    chk(same(solset(c),true),f"{i} key sols")
    for t,val in zip(w,wrongs):
        chk(same(solset(t),val),f"{i} wrong {t}")
        chk(not same(solset(t),true),f"{i} wrong eq key")
sc("apprecalc-mcq-017-v1",lambda a:2*sp.cos(a)+sp.sqrt(2),[[pi/4,7*pi/4],[5*pi/6,7*pi/6],[3*pi/4,7*pi/4]])
sc("apprecalc-mcq-017-v2",lambda a:2*sp.sin(a)+1,[[pi/6,5*pi/6],[5*pi/6,7*pi/6],[7*pi/6]])
sc("apprecalc-mcq-017-v3",lambda a: sp.tan(a)+1 if abs(float(sp.cos(a)))>1e-9 else 99,[[pi/4,5*pi/4],[3*pi/4,5*pi/4],[3*pi/4]])
chk(eq(sp.cos(7*pi/4),sp.sqrt(2)/2) and eq(sp.cos(5*pi/6),-sp.sqrt(3)/2) and eq(sp.sin(5*pi/6),R(1,2)) and eq(sp.tan(5*pi/4),1) and eq(3*pi/4+pi,7*pi/4),"017 facts")
chk(eq(sp.cos(pi/4),sp.sqrt(2)/2) and eq(sp.sin(7*pi/6),-R(1,2)) and eq(sp.sin(11*pi/6),-R(1,2)),"017 facts2")
# 014
def dom(arg_f,preds,i,claims):
    pts=[R(k,4) for k in range(-80,81)]
    good=lambda t: (lambda a: a is not None and a>0)(arg_f(t))
    chk(all(good(t)==preds[0](t) for t in pts),f"{i} key domain")
    for j,p in enumerate(preds[1:]): chk(any(good(t)!=p(t) for t in pts),f"{i} wrong{j} equals key")
    chk(all(claims),f"{i} claim")
a1=lambda t: 9-t*t
dom(a1,[lambda t:-3<t<3,lambda t:t<-3 or t>3,lambda t:-3<=t<=3,lambda t:t<3],"apprecalc-mcq-014-v1",[a1(4)==-7,a1(3)==0,a1(-5)==-16])
a2=lambda t: t*t-t-6
dom(a2,[lambda t:t<-2 or t>3,lambda t:-2<t<3,lambda t:t<-3 or t>2,lambda t:t<=-2 or t>=3],"apprecalc-mcq-014-v2",[a2(0)==-6,sp.expand((x+3)*(x-2))==x**2+x-6,a2(R(5,2))==R(-9,4),a2(3)==0])
a3=lambda t: None if t==5 else (t+1)/(t-5)
dom(a3,[lambda t:t<-1 or t>5,lambda t:-1<t<5,lambda t:t>-1 and t!=5,lambda t:t not in(-1,5)],"apprecalc-mcq-014-v3",[a3(R(0))==R(-1,5)])
# 020
X,Y=sp.symbols('X Y')
def parse_circle(t):
    t=t.replace("the origin","(0, 0)")
    m=re.match(r"A circle of radius (\d+) centered at \((.*?)\)",t.replace("−","-"))
    return (int(m.group(1)),tuple(int(q) for q in m.group(2).split(",")))
def cc(i,k,form,wr):
    c,w=texts(V[i])
    ctr=(R(k,2),0) if form=="cos" else (0,R(k,2)); r=abs(R(k,2))
    chk(parse_circle(c)==(r,ctr),f"{i} key circle")
    for t,val in zip(w,wr): chk(parse_circle(t)==val,f"{i} wrong {t}")
    ex=sp.expand(X**2+Y**2-(k*X if form=="cos" else k*Y))
    chk(sp.expand(ex-((X-ctr[0])**2+(Y-ctr[1])**2-r**2))==0,f"{i} square")
cc("apprecalc-mcq-020-v1",6,"cos",[(3,(0,3)),(6,(0,0)),(6,(3,0))])
cc("apprecalc-mcq-020-v2",-10,"sin",[(5,(0,5)),(5,(-5,0)),(10,(0,-10))])
cc("apprecalc-mcq-020-v3",-2,"cos",[(1,(1,0)),(1,(0,-1)),(2,(-1,0))])
# 022
zset=lambda t: set(int(q) for q in t.strip("{}").replace("−","-").split(","))
def zc(i,poly,wr):
    c,w=texts(V[i]); real=set(int(r) for r in sp.real_roots(poly))
    chk(zset(c)==real,f"{i} key zeros")
    for t,val in zip(w,wr): chk(zset(t)==set(val),f"{i} wrong {t}"); chk(zset(t)!=real,f"{i} eq key")
zc("apprecalc-mcq-022-v1",sp.Poly(x**4-13*x**2+36),[[-9,-4,4,9],[2,3],[-3,-2,2]])
zc("apprecalc-mcq-022-v2",sp.Poly(x**4+3*x**2-4),[[-2,-1,1,2],[-4,1],[1]])
zc("apprecalc-mcq-022-v3",sp.Poly(x**3-3*x**2-4*x+12),[[2,3],[-2,2],[-3,-2,2]])
chk(sp.expand((x**2+4)*(x**2-1))==x**4+3*x**2-4 and sp.expand((x-3)*(x**2-4))==x**3-3*x**2-4*x+12,"factor")
# structure
toks=lambda v: set(re.findall(r"\S+",(v["stem"]+" "+" ".join([v["correct"]["text"]]+[w["text"] for w in v["wrong"]])).lower()))
stoks=lambda s: set(re.findall(r"\S+",(s["stem"]+" "+" ".join(c["text"] for c in s["choices"])).lower()))
jac=lambda a,b: len(a&b)/len(a|b)
mx=0
for i,v in V.items():
    chk(len(v["wrong"])==3,i+" wrong count")
    allt=[v["correct"]["text"]]+[w["text"] for w in v["wrong"]]
    chk(len(set(allt))==4,i+" dup")
    chk(not re.search(r"(^|\n)\s*[A-D][.)]\s",v["stem"]),i+" options in stem")
    lc=len(allt[0]); lw=max(len(t) for t in allt[1:])
    if lc>1.4*lw: errs.append(f"{i} length ratio {lc/lw:.2f}")
    j=jac(toks(v),stoks(seeds_k:=next(s for s in seeds.values() if s["key"]==v["seed"]))); mx=max(mx,j)
    chk(j<0.7,f"{i} jaccard seed {j:.2f}")
    for k in V:
        if k!=i and V[k]["seed"]==v["seed"]:
            jj=jac(toks(v),toks(V[k])); mx=max(mx,jj); chk(jj<0.7,f"{i}~{k} {jj:.2f}")
print("max jaccard",round(mx,2),"variants",len(V))
print("\n".join(errs)+f"\nFAILURES {len(errs)}" if errs else "OK all variants")
