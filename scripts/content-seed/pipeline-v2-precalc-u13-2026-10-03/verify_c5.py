import json,re,sympy as sp
from sympy import sqrt,pi,sin,cos,Rational as R,log,exp,simplify,symbols,factor,cancel,Eq,solve
V={v['id']:v for v in json.load(open('variants_c5.json'))}
def P(t):
    t=t.replace('−','-').replace('√','sqrt').replace('π','pi')
    t=re.sub(r'sqrt(\d+)',r'sqrt(\1)',t)
    t=re.sub(r'(\d)sqrt',r'\1*sqrt',t)
    t=re.sub(r'(\d)pi',r'\1*pi',t)
    return sp.sympify(t.replace('/', '/'),rational=True)
def eq(a,b): return sp.simplify(a-b)==0
th=symbols('theta'); x=symbols('x'); ok=True
def chk(c,msg):
    global ok
    if not c: ok=False; print("FAIL",msg)
def texts(v): return [v['correct']['text']]+[w['text'] for w in v['wrong']]
# ---- polar descriptions (numeric checks of facts used)
r=lambda f,a: sp.simplify(f.subs(th,a))
f=3-3*sin(th)
chk(r(f,3*pi/2)==6 and r(f,pi/2)==0 and r(f,pi)==3 and eq(f.subs(th,pi-th),f) and all(f.subs(th,k*pi/12)>=0 for k in range(24)),'049v1')
chk(r(3+3*sin(th),pi/2)==6,'049v1 C'); chk(r(3-3*cos(th),pi)==6,'049v1 B')
f=5*cos(3*th)
chk([r(f,a) for a in (0,2*pi/3,4*pi/3)]==[5,5,5] and r(f,pi/2)==0,'049v2')
f=1+2*cos(th)
chk(r(f,0)==3 and r(f,pi)==-1 and r(f,2*pi/3)==0 and r(f,pi/2)==1 and r(1+2*sin(th),pi/2)==3 and eq(f.subs(th,-th),f),'049v3')
# ---- end behavior numerics
h=lambda t:4*t**6-7*t**3+2
chk(h(-10)==4007002 and h(-100)>h(-10),'001v1')
p=lambda t:-2*t**2*(t-3)*(t+1)*(t+4)
chk(p(-10)==140400 and p(10)==-215600 and sp.degree(sp.expand(p(x)),x)==5 and sp.Poly(sp.expand(p(x)),x).LC()==-2 and p(-10**6)>0 and p(10**6)<0,'001v2')
f=lambda t:100*t**3-5*t**4+t**2
chk(f(10)==50100 and f(100)==-399990000,'001v3')
# ---- holes
h=(x**2+x-6)/(x**2-4); g=cancel(h)
chk(eq(g,(x+3)/(x+2)) and g.subs(x,2)==R(5,4) and (1/(x+2)).subs(x,2)==R(1,4) and (x**2+x-6).subs(x,2)==0,'002v1')
f=(x-1)*(x+2)*(x-5)/((x+2)*(x-5)*(x-3)); chk(eq(cancel(f),(x-1)/(x-3)),'002v2')
q=(x+1)/((x+1)**2*(x-2)); chk(eq(cancel(q),1/((x+1)*(x-2))),'002v3')
# ---- exp equations
u=symbols('u')
chk(set(solve(u**2-5*u-14,u))=={7,-2} and 49-35-14==0,'005v1')
chk(set(solve(u**2-4*u+3,u))=={1,3} and 9**0-4*3**0+3==0 and 9**3-4*27+3!=0 and abs(float(3**float(sp.log(3)))-3.34)<0.01,'005v2')
chk(set(solve(u**2-7*u+12,u))=={3,4},'005v3')
for xv in (sp.log(3),sp.log(4)): chk(sp.simplify(exp(xv)+12*exp(-xv)-7)==0,'005v3 root')
for xv in (-sp.log(3),sp.log(3)/1+0,3): pass
chk(sp.simplify(exp(-sp.log(3))+12*exp(sp.log(3))-7)!=0 and sp.simplify(exp(3)+12*exp(-3)-7)!=0 and abs(float(exp(3)+12*exp(-3))-20.7)<0.05,'005v3 wrong')
chk(set(solve(12*u**2-7*u+1,u))=={R(1,3),R(1,4)},'005v3 C')
chk(sp.simplify(exp(2*sp.log(7))-5*7-14)==0,'005v1 D')
# ---- b
chk(2*pi/R(6,9)==3*pi and R(9,6)==R(3,2) and 2*pi/6==pi/3 and R(6,9)==R(2,3),'006v1')
chk(2*pi*250==500*pi and 2*pi/250==pi/125 and pi*250==250*pi,'006v2')
per=2*(11-3); chk(per==16 and 2*pi/per==pi/8 and 2*pi/8==pi/4 and pi/per==pi/16,'006v3')
# ---- exact values
chk(eq(sin(7*pi/6),R(-1,2)) and eq(cos(pi/6),sqrt(3)/2),'007v1')
chk(eq(sin(-3*pi/4),-sqrt(2)/2) and eq(sin(3*pi/4),sqrt(2)/2),'007v2')
chk(eq(cos(4*pi/3),R(-1,2)) and eq(sin(4*pi/3),-sqrt(3)/2) and eq(sin(2*pi/3),sqrt(3)/2),'007v3')
# ---- polar->rect
def rect(rr,t): return (sp.simplify(rr*cos(t)),sp.simplify(rr*sin(t)))
a=rect(-6,5*pi/6); chk(eq(a[0],3*sqrt(3)) and a[1]==-3,'008v1')
a=rect(6,5*pi/6); chk(eq(a[0],-3*sqrt(3)) and a[1]==3,'008v1 B')
chk(eq(-6*sin(5*pi/6),-3) and eq(-6*cos(5*pi/6),3*sqrt(3)),'008v1 D')
a=rect(8,11*pi/6); chk(eq(a[0],4*sqrt(3)) and a[1]==-4,'008v2')
chk(eq(8*sin(11*pi/6),-4) and eq(8*cos(11*pi/6),4*sqrt(3)) and R(8)*R(1,2)==4 and eq(8*(-sqrt(3)/2),-4*sqrt(3)),'008v2 distractors')
a=rect(-4*sqrt(2),3*pi/4); chk(eq(a[0],4) and eq(a[1],-4),'008v3')
a=rect(4*sqrt(2),3*pi/4); chk(eq(a[0],-4) and eq(a[1],4),'008v3 B')
# ---- differences
def dif(l): return [l[i+1]-l[i] for i in range(len(l)-1)]
l=[t**4 for t in range(6)]; d=[l]
for _ in range(4): d.append(dif(d[-1]))
chk(d[1]==[1,15,65,175,369] and d[2]==[14,50,110,194] and d[3]==[36,60,84] and d[4]==[24,24],'009v1')
l=[5,8,15,26,41]; d1=dif(l); d2=dif(d1); chk(d1==[3,7,11,15] and d2==[4,4,4],'009v2')
l=[4,3,6,13,24,39]; d2=dif(l); d3=dif(d2); d4=dif(d3)
chk(d2==[-1,3,7,11,15] and d3==[4,4,4,4] and len(l)==6,'009v3'); 
# listed as first diffs: outputs 2nd diffs=-1,3,7,11,15, 3rd=4,4,4,4 -> degree 3; list as outputs: 2nd diffs of list const
chk(dif(dif(l))==[4,4,4,4],'009v3 B')
# ---- undefined
chk(cos(3*pi/2)==0 and cos(pi)==-1 and eq(1/cos(5*pi/4),-sqrt(2)) and eq(1/cos(2*pi/3),-2),'010v1')
chk(sin(2*pi)==0 and cos(pi/2)==0 and sin(pi/2)==1 and eq(cos(3*pi/4)/sin(3*pi/4),-1) and eq(cos(7*pi/6)/sin(7*pi/6),sqrt(3)),'010v2')
chk(cos(2*(pi/4))==0 and cos(2*(pi/2))==-1 and cos(2*pi)==1 and cos(0)==1,'010v3')
# ---- structural
def toks(v): return set((v['stem']+' '+' '.join(texts(v))).lower().split())
def jac(a,b): return len(a&b)/len(a|b)
seeds={s['key']:s for s in json.load(open('seeds_final.json'))}
for id,v in V.items():
    s=seeds[v['seed']]
    st=set((s['stem']+' '+' '.join([s['correct']['text']]+[w['text'] for w in s['wrong']])).lower().split())
    j=[jac(toks(v),st)]+[jac(toks(v),toks(V[o])) for o in V if o!=id and V[o]['seed']==v['seed']]
    chk(max(j)<0.7,f'jaccard {id} {max(j):.2f}')
    L=[len(w['text']) for w in v['wrong']]
    if len(v['correct']['text'])>1.4*max(L) and max(L)>12: chk(False,f'length {id} {len(v["correct"]["text"])} vs {max(L)}')
    chk(len(set(texts(v)))==4 and len(v['wrong'])==3 and not re.search(r'(^|\n)\s*[A-D][.)]',v['stem']),'struct '+id)
chk(len(V)==27,'count')
print("ALL OK" if ok else "FAILURES", len(V))
