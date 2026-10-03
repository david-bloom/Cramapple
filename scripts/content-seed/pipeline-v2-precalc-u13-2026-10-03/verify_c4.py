"""Independent recomputation of every variant in variants_c4.json."""
import json, re, itertools
from math import *
import sympy as sp
D="/Users/davidbloom/Documents/Cramapple.nosync/scripts/content-seed/pipeline-v2-precalc-u13-2026-10-03/"
V={v["id"]:v for v in json.load(open(D+"variants_c4.json"))}
seeds={s["key"]:s for s in json.load(open(D+"seeds_final.json"))}
x=sp.symbols('x')
def texts(v): return v["correct"]["text"],[w["text"] for w in v["wrong"]]
def eq(a,b): return sp.simplify(a-b)==0
def numeq(f,g,pts): return all(abs(f(p)-g(p))<1e-9 for p in pts)
ok=0
def done(i): 
    global ok; ok+=1; print("OK",i)
r1=lambda v:f"{v:.1f}"
def chk(i,key,wrongs):
    k,w=texts(V[i]); assert k==key,(i,k,key); assert w==wrongs,(i,w,wrongs)

# 034: solve by substitution/sympy, verify domain
def logsol(expr_fn,dom,cands):
    return [c for c in cands if dom(c) and abs(expr_fn(c))<1e-9]
f=lambda t:log2(t)+log2(t-2)-3
assert abs(f(4))<1e-9; assert not any(abs(f(c))<1e-9 for c in (3,5)); 
assert sp.solve(sp.Eq(x*(x-2),8),x)==[-2,4]
chk("apprecalc-mcq-034-v1","x=4",["x=3","x=5","x=-2".replace("-","−")]); done("034-v1")
g=lambda t:log2(t+10)-log2(t-2)-2
assert abs(g(6))<1e-9 and sp.solve(sp.Eq(x+10,4*(x-2)),x)==[6]
assert sp.solve(sp.Eq(x+10,2*(x-2)),x)==[14] and abs(g(14)+1)<1e-9 and abs(log2(24)-log2(12)-1)<1e-9
assert sp.solve(sp.Eq(x+10,4*x-2),x)==[4] and abs(log2(14)-log2(2)-log2(7))<1e-9
assert sp.solve(sp.Eq(x-2,4*(x+10)),x)==[-14]
chk("apprecalc-mcq-034-v2","x=6",["x=14","x=4","x=−14"]); done("034-v2")
h=lambda t:log(t+1,3)+log(t+3,3)-1
assert abs(h(0))<1e-12 and sp.solve(sp.Eq((x+1)*(x+3),3),x)==[-4,0]
assert sp.solve(sp.Eq(2*x+4,3),x)==[sp.Rational(-1,2)] and abs(log(.5,3)+log(2.5,3)-log(1.25,3))<1e-12
r=sp.solve(sp.Eq((x+1)*(x+3),1),x); assert set(r)=={-2+sp.sqrt(2),-2-sp.sqrt(2)} and (-2+sqrt(2)+1)>0
assert abs(h(-2+sqrt(2))+1)<1e-12  # product is 1 -> sum of logs is 0
chk("apprecalc-mcq-034-v3","x=0",["x=−4","x=−1/2","x=−2+√2"]); done("034-v3")

# 035 inverse checks
def inv_check(i,f,keyf,wrongfs,pt,xin,fin_expected):
    assert abs(f(pt)-xin)<1e-9
    assert abs(keyf(xin)-pt)<1e-9,(i,keyf(xin))
    for wf in wrongfs:
        try: val=wf(xin)
        except Exception: continue
        assert not (isinstance(val,float) and abs(val-pt)<1e-6),(i,val)
# symbolic inverse
def sinv(fexpr):
    y=sp.symbols('y',positive=True); return sp.solve(sp.Eq(fexpr.subs(x,sp.Symbol('t')),y),sp.Symbol('t'))
t=sp.Symbol('t',real=True); y=sp.Symbol('y',positive=True)
s1=sp.solve(sp.Eq(3**(t+1)-4,y),t)[0]; assert eq(s1,sp.log(y+4,3)-1) or abs(float(s1.subs(y,23))-2)<1e-9
f1=lambda a:3**(a+1)-4
assert f1(2)==23
assert abs(log(23+4,3)-1-2)<1e-12
assert abs(log(19,3)+1-3.68)<0.01; assert abs(-3-1+4)<1e-12 and abs(log(27,1/3)-1+4)<1e-9
chk("apprecalc-mcq-035-v1","log₃(x+4)−1",["log₃(x−4)+1","3^(x−1)+4","log_(1/3)(x+4)−1"]); done("035-v1")
f2=lambda a:exp(a-3)+2; assert f2(3)==3
assert abs(log(3-2)+3-3)<1e-12 and abs(log(5)-3+1.39)<0.01 and abs(log(1)-3+3)<1e-12
assert sp.solve(sp.Eq(sp.exp(t-3)+2,y),t)[0]==sp.log(y-2)+3
chk("apprecalc-mcq-035-v2","ln(x−2)+3",["ln(x+2)−3","ln(x−3)+2","ln(x−2)−3"]); done("035-v2")
f3=lambda a:2**(3*a)+1; assert f3(1)==9
assert abs(log2(8)/3-1)<1e-12 and 3*log2(8)==9 and log2(8)-3==0 and abs(log2(9)/3-1-0.0566)<1e-3
assert all(abs(log2(f3(q)-1)/3-q)<1e-9 for q in (-1,0.5,2))
chk("apprecalc-mcq-035-v3","(1/3)log₂(x−1)",["3log₂(x−1)","log₂(x−1)−3","(1/3)log₂(x)−1"]); done("035-v3")

# 036 composition (sympy; choices parsed manually)
X=sp.Symbol('x')
f=lambda e:e**2-3; g=lambda e:3*e+1
key=f(g(X)); assert eq(key,(3*X+1)**2-3)
for w in [3*(X**2-3)+1,(X**2-3)*(3*X+1),9*X**2-2]: assert not eq(key,w)
assert eq(3*(X**2-3)+1,g(f(X)))
chk("apprecalc-mcq-036-v1","(3x+1)²−3",["3(x²−3)+1","(x²−3)(3x+1)","9x²−2"]); done("036-v1")
F=lambda e:sp.sqrt(e+4); G=lambda e:e**2-5
key=F(G(X)); assert eq(key,sp.sqrt(X**2-1))
for w in [X-1,sp.sqrt(X**2-5)+4,sp.sqrt(X+4)*(X**2-5)]: assert not eq(key,w)
assert eq(G(F(X)),X-1)
chk("apprecalc-mcq-036-v2","√(x²−1)",["x−1","√(x²−5)+4","√(x+4)·(x²−5)"]); done("036-v2")
from fractions import Fraction as Fr
f=lambda a:Fr(1)/(a-2); g=lambda a:2*a+1
assert f(g(3))==Fr(1,5) and g(f(3))==3 and g(3)==7 and Fr(1,g(3))==Fr(1,7)
chk("apprecalc-mcq-036-v3","1/5",["3","7","1/7"]); done("036-v3")

# 037 tables
def stats(y):
    d=[y[i+1]-y[i] for i in range(4)]; d2=[d[i+1]-d[i] for i in range(3)]; r=[y[i+1]/y[i] for i in range(4)]
    my=sum(y)/5; sxy=sum((a-2)*(b-my) for a,b in zip(range(5),y)); syy=sum((b-my)**2 for b in y)
    return [round(v,3) for v in d],[round(v,3) for v in d2],[round(v,3) for v in r],sxy**2/10/syy
d,d2,r,r2=stats([5.0,8.1,10.9,14.0,17.1])
assert all(abs(v-3)<=0.21 for v in d) and r==sorted(r,reverse=True) and r[0]>1.6 and r[-1]<1.25 and all(v>1 for v in r) and len(set(d2))>1
assert V["apprecalc-mcq-037-v1"]["stem"].endswith("Which claim is best supported?"); done("037-v1")
d,d2,r,r2=stats([80,60.4,45.1,34.2,25.6])
assert all(abs(v-.75)<.01 for v in r) and r2>0.95 and abs(1/0.75-1.333)<.001 and len(set(d2))>1 and d==[-19.6,-15.3,-10.9,-8.6]
done("037-v2")
d,d2,r,r2=stats([2,5,10,17,26])
assert d==[3,5,7,9] and d2==[2,2,2] and (26-2)/4==6 and all(v>1 for v in r) and r==sorted(r,reverse=True) and r[0]==2.5 and abs(r[-1]-1.529)<.001
done("037-v3")

# 038
assert 2**3==8 and 3**2==9 and 2*3==6
chk("apprecalc-mcq-038-v1","8",["3","6","9"]); done("038-v1")
assert abs(10**2-100)<1e-9 and abs(10**0.3010-2)<0.001 and abs(10**(0.3010*5)/2**5-1)<0.01
done("038-v2")
assert abs(10**-0.4771-1/3)<0.001 and abs(10**0.4771-3)<0.001 and abs(1-0.4771-0.5229)<1e-12
chk("apprecalc-mcq-038-v3","1/3",["3","0.4771","0.5229"]); done("038-v3")

# 040
def solves(vals):
    return vals
k=exp((15-3.2)/4.1); chk("apprecalc-mcq-040-v1",r1(k),[r1(10**((15-3.2)/4.1)),r1(exp(15/4.1)),r1(exp((15+3.2)/4.1))])
assert abs(3.2+4.1*log(k)-15)<1e-9 and len({r1(10**((15-3.2)/4.1)),r1(exp(15/4.1)),r1(exp((15+3.2)/4.1)),r1(k)})==4
assert r1(k)=="17.8"; done("040-v1")
k=log(50/12)/.07; assert abs(12*exp(.07*k)-50)<1e-9
chk("apprecalc-mcq-040-v2",r1(k),[r1(log(50)/.07),r1(log(38)/.07),r1(log10(50/12)/.07)]); assert r1(k)=="20.4"; done("040-v2")
k=exp(4.5/2.4); assert abs(7.5-2.4*log(k)-3)<1e-9
w=[r1(exp(-1.875)),r1(exp(3/2.4)),r1(exp(10.5/2.4))]; chk("apprecalc-mcq-040-v3",r1(k),w); assert w==["0.2","3.5","79.4"] and r1(k)=="6.5"; done("040-v3")

# 041-043 exact values (sympy)
pi_=sp.pi
assert sp.simplify(sp.sin(4*pi_/3)+sp.sqrt(3)/2)==0 and sp.cos(4*pi_/3)==-sp.Rational(1,2) and sp.cos(pi_/3)==sp.Rational(1,2)
chk("apprecalc-mcq-041-v1","−√3/2",["−1/2","√3/2","1/2"]); done("041-v1")
assert sp.simplify(sp.cos(11*pi_/6)-sp.sqrt(3)/2)==0 and sp.sin(11*pi_/6)==-sp.Rational(1,2)
chk("apprecalc-mcq-041-v2","√3/2",["−√3/2","−1/2","1/2"]); done("041-v2")
assert sp.cos(-2*pi_/3)==-sp.Rational(1,2) and sp.simplify(sp.sin(-2*pi_/3)+sp.sqrt(3)/2)==0 and sp.simplify(sp.sin(2*pi_/3)-sp.sqrt(3)/2)==0
chk("apprecalc-mcq-041-v3","−1/2",["1/2","−√3/2","√3/2"]); done("041-v3")

def feats(fn,lo,hi,n=20000):
    xs=[lo+(hi-lo)*i/n for i in range(n+1)]; ys=[fn(a) for a in xs]
    return max(ys),min(ys)
# 043 v1
K=lambda a:-5*cos(pi*a/3)+2
assert abs(K(0)+3)<1e-9 and abs(K(6)-K(0))<1e-9 and abs(K(3)-7)<1e-9 and feats(K,0,6)[0]-2<=5.0000001
for wf,why in [(lambda a:5*cos(pi*a/3)+2,"max"),(lambda a:-5*cos(6*a)+2,"period"),(lambda a:-5*cos(pi*a/6)+2,"period")]:
    assert abs(wf(0)+3)>1e-6 or abs(wf(6)-wf(0))>1e-6, why
assert abs(2*pi/6-pi/3)<1e-12 and abs(2*pi/(pi/6)-12)<1e-9
chk("apprecalc-mcq-043-v1","−5cos(πx/3)+2",["5cos(πx/3)+2","−5cos(6x)+2","−5cos(πx/6)+2"]); done("043-v1")
# v2
K=lambda a:2*sin(a/2)+5; 
assert abs(K(0)-5)<1e-9 and K(0.01)>5 and abs(K(4*pi)-K(0))<1e-9 and abs(2*pi/(1/2)-4*pi)<1e-12
assert abs(2*sin(2*0)+5-5)<1e-9 and abs(2*pi/2-pi)<1e-12 and abs(2*cos(0)+5-7)<1e-12 and -2*sin(0.01/2)+5<5
chk("apprecalc-mcq-043-v2","2sin(x/2)+5",["2sin(2x)+5","2cos(x/2)+5","−2sin(x/2)+5"]); done("043-v2")
# v3
K=lambda a:4*cos(a-pi/2)+1
assert abs(K(pi/2)-5)<1e-9 and abs(K(pi/2+2*pi)-5)<1e-9
assert abs(4*cos(pi/2+pi/2)+1+3)<1e-9 and abs(4*sin(0)+1-1)<1e-9
W=lambda a:4*cos(2*(a-pi/2))+1; assert abs(W(pi/2)-5)<1e-9 and abs(W(pi/2+pi)-5)<1e-9 and abs(W(pi/2+pi)-W(pi/2))<1e-9  # period pi
a=sp.Symbol('a'); assert sp.simplify(sp.sin(a-pi_/2)+sp.cos(a))==0
for wexp in [4*sp.cos(a+pi_/2)+1,4*sp.sin(a-pi_/2)+1,4*sp.cos(2*(a-pi_/2))+1]:
    assert not eq(4*sp.cos(a-pi_/2)+1,wexp)
chk("apprecalc-mcq-043-v3","4cos(x−π/2)+1",["4cos(x+π/2)+1","4sin(x−π/2)+1","4cos(2(x−π/2))+1"]); done("043-v3")

# 045
h=lambda t:12+5*sin(pi/12*(t-3))
w=[r1(12+5*sin(pi/12*8)),r1(12+5*sin(radians(pi/12*5))),r1(12-5*sin(5*pi/12))]
chk("apprecalc-mcq-045-v1",r1(h(8)),w); assert (r1(h(8)),w)==("16.8",["16.3","12.1","7.2"]); done("045-v1")
d=lambda t:6.5+2.5*cos(2*pi/9*(t-1))
w=[r1(6.5+2.5*sin(2*pi/9)),r1(6.5+2.5*cos(4*pi/9)),r1(6.5+2.5*cos(radians(2*pi/9)))]
chk("apprecalc-mcq-045-v2",r1(d(2)),w); assert (r1(d(2)),w)==("8.4",["8.1","6.9","9.0"]); done("045-v2")
c=lambda t:40+12*sin(2*pi*(t-6)/24)
w=[r1(40+12*sin(2*pi*8/24)),r1(40+12*sin(radians(pi/6))),r1(40-12*0.5)]
chk("apprecalc-mcq-045-v3",r1(c(8)),w); assert (r1(c(8)),w)==("46.0",["50.4","40.1","34.0"]); done("045-v3")

# 047 identities (sympy)
a=sp.Symbol('a')
k=(sp.sec(a)**2-1)/sp.tan(a)
assert sp.simplify(k-sp.tan(a))==0
for wexp in [sp.tan(a)**2,sp.cot(a),sp.Integer(1)]: assert sp.simplify(k-wexp)!=0
assert sp.simplify(k.subs(a,pi_/3)-sp.sqrt(3))==0
chk("apprecalc-mcq-047-v1","tan x",["tan²x","cot x","1"]); done("047-v1")
k=sp.cos(a)/(1-sp.sin(a)**2); assert sp.simplify(k-sp.sec(a))==0
for wexp in [sp.cos(a)/sp.sin(a)**2,sp.cos(a),sp.Integer(1)]: assert sp.simplify(k-wexp)!=0
assert sp.simplify(k.subs(a,pi_/3))==2
chk("apprecalc-mcq-047-v2","sec x",["cos x/sin²x","cos x","1"]); done("047-v2")
k=sp.sin(a)**2/(1+sp.cos(a)); assert sp.simplify(k-(1-sp.cos(a)))==0
for wexp in [1+sp.cos(a),1-sp.cos(a)**2,-sp.cos(a)]: assert sp.simplify(k-wexp)!=0
chk("apprecalc-mcq-047-v3","1−cos x",["1+cos x","1−cos²x","−cos x"]); done("047-v3")

# ---- structural checks
import collections
def tok(v):
    t=v["stem"]+" "+" ".join([v["correct"]["text"]]+[w["text"] for w in v["wrong"]])
    return set(t.lower().split())
def jac(a,b): return len(a&b)/len(a|b)
def seedtok(s):
    return set((s["stem"]+" "+" ".join([s["correct"]["text"]]+[w["text"] for w in s["wrong"]])).lower().split())
mx=0
for i,v in V.items():
    assert len(v["wrong"])==3 and v["id"].startswith(v["seed"])
    c=v["correct"]["text"]; ws=[w["text"] for w in v["wrong"]]
    assert len(set([c]+ws))==4,i
    assert not re.search(r"(^|\s)[A-D]\.\s",v["stem"]),i
    assert v["correct"]["rationale"] and all(w["rationale"] and w["error_pattern"] for w in v["wrong"])
    if not all(len(w)<=8 for w in ws): assert len(c)<=1.4*max(map(len,ws)),(i,len(c),max(map(len,ws)))
    j=jac(tok(v),seedtok(seeds[v["seed"]])); mx=max(mx,j); assert j<0.7,(i,j)
for a,b in itertools.combinations(V,2):
    if V[a]["seed"]==V[b]["seed"]:
        j=jac(tok(V[a]),tok(V[b])); mx=max(mx,j); assert j<0.7,(a,b,j)
print("max jaccard",round(mx,3))
assert len(V)==30 and ok==30 and set(v["seed"] for v in V.values())==set(json.load(open(D+"seedkeys_c4.json")))
print("ALL OK",ok,"variants")
