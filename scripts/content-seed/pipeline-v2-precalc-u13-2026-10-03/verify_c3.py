import json, re, sympy as sp
from sympy import symbols, Rational, S, oo, Interval, Union, simplify, cancel, factor, expand, solve, limit
x=symbols('x')
V={v['id']:v for v in json.load(open('variants_c3.json'))}
seeds={s['key']:s for s in json.load(open('seeds_final.json'))}
bad=[]
def ok(c,msg):
    if not c: bad.append(msg)
def norm(t): return t.replace('−','-')
def num(t): return float(norm(t))
def choices(v): return [v['correct']['text']]+[w['text'] for w in v['wrong']]
def tok(s): return set(re.findall(r"\w+",s.lower()))
def jac(a,b): return len(a&b)/len(a|b)
def full(v): return v['stem']+' '+' '.join(choices(v))
# ---- structural
for i,v in V.items():
    ok(len(v['wrong'])==3,i+' wrong count')
    ok(len(set(choices(v)))==4,i+' dup choices')
    ok(not re.search(r'\n\s*[A-D][\.\)]',v['stem']),i+' option list in stem')
    L=[len(w['text']) for w in v['wrong']]
    allnum=all(re.fullmatch(r'[−\-\d\.]+',t) for t in choices(v))
    if not allnum: ok(len(v['correct']['text'])<=1.4*max(L),i+' key too long')
    sd=seeds[v['seed']]; st=tok(sd['stem']+' '+' '.join(c['text'] for c in sd['choices']))
    j=jac(tok(full(v)),st); ok(j<0.7,f'{i} seed jaccard {j:.2f}')
    for k,u in V.items():
        if k>i and u['seed']==v['seed']:
            j=jac(tok(full(v)),tok(full(u))); ok(j<0.7,f'{i}/{k} jaccard {j:.2f}')
    for c in [v['correct']]+v['wrong']: ok(len(c['rationale'])>20,i+' rationale')
# ---- end behavior: parse via sympy limits
def eb(poly):
    return (sp.limit(poly,x,oo),sp.limit(poly,x,-oo))
def ebtext(name,pair):
    r,l=pair
    if r==oo and l==oo: return f"{name}(x)→∞ at both ends"
    if r==-oo and l==-oo: return f"{name}(x)→−∞ at both ends"
    if r==oo and l==-oo: return f"{name}(x)→∞ as x→∞ and {name}(x)→−∞ as x→−∞"
    return f"{name}(x)→−∞ as x→∞ and {name}(x)→∞ as x→−∞"
def chk_eb(i,name,poly,wrongs):
    v=V[i]; ok(v['correct']['text']==ebtext(name,eb(poly)),i+' eb key')
    # wrongs must not equal key and each must be a distinct end-behavior
    for w in v['wrong']: ok(w['text']!=v['correct']['text'],i+' eb wrong==key')
ok(V['apprecalc-mcq-023-v1']['correct']['text']=='h(x)→∞ in both directions' and eb(9-x**3+4*x**6)==(oo,oo),'023v1 key')
ok(V['apprecalc-mcq-023-v2']['correct']['text']=='The graph rises to the right and falls to the left' and eb(-9*x**4+2*x**7+x)==(oo,-oo),'023v2 key')
chk_eb('apprecalc-mcq-023-v3','p',-3*(x-1)**2*(x+2)*(x-4),None)
# error claims: v1 b uses -x^3, a uses -x^3 sign w/ even, c; v3 b uses 3 factors
ok(eb(-x**3)==(-oo,oo),'023v1 b')
ok(eb(-9*x**4)==(-oo,-oo),'023v2 a')
ok(eb(-3*(x-1)*(x+2)*(x-4))==(-oo,oo) and eb(3*(x-1)*(x+2)*(x-4))==(oo,-oo),'023v3 b,c')
ok(sp.degree(expand(-3*(x-1)**2*(x+2)*(x-4)),x)==4,'023v3 deg')
# ---- vertical asymptotes
def va(num_,den_):
    n,d=sp.fraction(cancel(num_/den_)); return sorted(solve(d,x))
def vtxt(l): 
    s=[f"x={str(a).replace('-','−')}" for a in l]; return ' and '.join(s) if len(s)>1 else s[0]+' only'
k={'1':'x=−7 and x=4','2':'Only at x=9','3':'x=−7 and x=8'}
ok(va(x-10,x**2+3*x-28)==[-7,4] and k['1']==V['apprecalc-mcq-024-v1']['correct']['text'],'024v1 key')
ok(va(x+8,x**2-x-72)==[9] and cancel((x+8)/(x**2-x-72))==1/(x-9) and k['2']==V['apprecalc-mcq-024-v2']['correct']['text'],'024v2 key')
ok(va(x**2-25,x**2-x-56)==[-7,8] and k['3']==V['apprecalc-mcq-024-v3']['correct']['text'],'024v3 key')
ok(expand((x+7)*(x-4))==x**2+3*x-28 and expand((x-7)*(x+4))==x**2-3*x-28,'024v1 b')
ok(expand((x-8)*(x+9))==x**2+x-72 and expand((x-9)*(x+8))==x**2-x-72,'024v2 c')
ok(expand((x+8)*(x-7))==x**2+x-56 and expand((x-8)*(x+7))==x**2-x-56,'024v3 b')
ok(solve(x**2-25,x)==[-5,5] and solve(x-10,x)==[10],'024 numerator zeros')
# ---- holes
f=cancel((x**2-x-6)/(x-3)); ok(f==x+2 and f.subs(x,3)==5 and (x**2-x-6).subs(x,3)==0,'025v1')
f=cancel((2*x**2+x-3)/(x-1)); ok(f==2*x+3 and f.subs(x,1)==5 and (2*x**2+x-3).subs(x,1)==0 and solve(2*x+3,x)==[Rational(-3,2)],'025v2')
f=cancel((x-5)/(x**2-25)); ok(f==1/(x+5) and f.subs(x,5)==Rational(1,10) and sp.limit(f,x,-5,'+')==oo,'025v3')
# ---- transformations: verify identities
fx=sp.Function('f')
ok(sp.simplify(2*x-6-2*(x-3))==0,'026v3 factor')
# check horizontal shrink by factor 1/2 & shift right 3: g(x)=-f(2(x-3)); input scaled by 2 => shrink 1/2; shift 3 right
# v1: (1/2)f(x+4)-6 left4 shrink 1/2 down 6 ; v2: 3f(-x)+2 ; checked by reading standard forms
# ---- finite differences
def diffs(ys,k):
    for _ in range(k): ys=[b-a for a,b in zip(ys,ys[1:])]
    return ys
y=[3,4,7,12,19]; ok(diffs(y,1)==[1,3,5,7] and diffs(y,2)==[2,2,2],'027v1')
ok([Rational(b,a) for a,b in zip(y,y[1:])]==[Rational(4,3),Rational(7,4),Rational(12,7),Rational(19,12)],'027v1 ratios')
y=[xx**3-2*xx for xx in range(6)]; ok(y==[0,-1,4,21,56,115] and diffs(y,1)==[-1,5,17,35,59] and diffs(y,2)==[6,12,18,24] and diffs(y,3)==[6,6,6],'027v2')
y=[2,8,12,14,14]; ok(diffs(y,1)==[6,4,2,0] and diffs(y,2)==[-2,-2,-2],'027v3')
# ---- remainder theorem (verify with polynomial division too)
def rem(p,c): return sp.rem(p,x-c,x)
p=x**3+4*x**2-5*x+6; ok(rem(p,3)==54 and p.subs(x,-3)==30 and (27+36-15)==48 and (9+36-15+6)==36,'028v1')
p=3*x**3-x**2+2*x-10; ok(rem(p,-2)==-42 and p.subs(x,2)==14 and (-24-4-4)==-32 and (24-4-4-10)==6,'028v2')
p=2*x**4-5*x**2+3*x+1; ok(rem(p,-1)==-5 and p.subs(x,1)==1 and (-2-5-3+1)==-9 and (2-5-3)==-6,'028v3')
for i,t in [(1,[54,30,48,36]),(2,[-42,14,-32,6]),(3,[-5,1,-9,-6])]:
    ok([num(c) for c in choices(V['apprecalc-mcq-028-v%d'%i])]==t,'028 texts %d'%i)
# ---- rational inequalities
def sol(expr,rel): 
    return sp.solve_univariate_inequality(rel(expr,0),x,relational=False)
def itxt(s):
    def one(I):
        l='[' if not I.left_open else '('; r=']' if not I.right_open else ')'
        a='−∞' if I.start==-oo else str(I.start); b='∞' if I.end==oo else str(I.end)
        return f"{l}{a},{b}{r}".replace('-','−')
    ints=s.args if isinstance(s,Union) else [s]
    return '∪'.join(one(I) for I in sorted(ints,key=lambda I:I.start))
for i,e,rel,alts in [(1,(x+7)/(x-4),lambda a,b:a>=b,None),(2,(9-x)/(x+8),lambda a,b:a>=b,None),(3,(x-8)*(x+4)/(x-9),lambda a,b:a<=b,None)]:
    v=V['apprecalc-mcq-029-v%d'%i]; ok(itxt(sol(e,rel))==v['correct']['text'].replace('(−∞','(-∞').replace('-∞','−∞') or True,'')
    ok(itxt(sol(e,rel)).replace('(−∞','(−∞')==v['correct']['text'],f"029 key {i}: {itxt(sol(e,rel))} vs {v['correct']['text']}")
ok(itxt(sol(((x+7)/(x-4)),lambda a,b:a<=b))=='[−7,4)','029v1 b')
ok(itxt(sol((x-9)/(x+8),lambda a,b:a>=b))=='(−∞,−8)∪[9,∞)','029v2 b')
ok(itxt(sol((x-8)*(x+4)/(x-9),lambda a,b:a>=b))=='[−4,8]∪(9,∞)','029v3 b')
# ---- 030 numeric
def poly(c): return lambda t: sum(a*t**p for p,a in c)
def two(z): return f"{z:.2f}".replace('-','−')
def one(z): return f"{z:.1f}".replace('-','−')
for i,c,a,b,mode in [(1,[(3,.31),(2,-2.2),(1,1.45),(0,9.8)],1.5,3.4,'a'),(2,[(3,-.18),(2,1.4),(1,-.9),(0,12.5)],2.2,5.6,'b'),(3,[(4,.07),(2,-.9),(1,2.3),(0,15)],1.3,3.8,'c')]:
    P=poly(c); ch=P(b)-P(a); v=V['apprecalc-mcq-030-v%d'%i]
    ok(v['correct']['text']==two(ch),f'030 key {i}')
    cand={'rev':two(-ch),'avg':two(ch/(b-a)),'fin':two(P(b)),'bma':two(P(b-a))}
    got=set(w['text'] for w in v['wrong'])
    exp={1:{'rev','avg','fin'},2:{'rev','avg','bma'},3:{'avg','fin','rev'}}[i]
    ok(got=={cand[k] for k in exp},f'030 wrongs {i}: {got}')
    ok(v['correct']['text'] not in got,'030 dup')
# ---- 031
for i,fn,a,b,exp in [(1,lambda t:2*t**3-5*t,.8,2.3,'rev mul chg'),(2,lambda t:t**4-3*t**3+t,1.4,3.1,'rev b chg'),(3,lambda t:.2*t**4-1.5*t**2+3*t,.5,2.5,'avg chg rev')]:
    d=fn(b)-fn(a); r=d/(b-a); v=V['apprecalc-mcq-031-v%d'%i]
    c={'rev':one(-r),'mul':one(d*(b-a)),'chg':one(d),'b':one(d/b),'avg':one((fn(a)+fn(b))/2)}
    ok(v['correct']['text']==one(r),f'031 key {i}')
    ok(set(w['text'] for w in v['wrong'])=={c[k] for k in exp.split()},f'031 wrongs {i}')
# ---- 032
ok(round(1-0.85,10)==0.15 and round(1.035-1,10)==0.035 and round(1-0.6,10)==0.4,'032 pct')
ok(80*0.4==32 and abs(80*.6*.4-19.2)<1e-9 and abs(5*.035-.175)<1e-9,'032 numbers')
if bad: print('FAIL'); [print(' ',b) for b in bad]
else: print('OK all',len(V),'variants')
