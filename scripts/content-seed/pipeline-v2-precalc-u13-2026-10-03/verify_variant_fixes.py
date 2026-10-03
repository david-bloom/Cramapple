import json, math
import sympy as sp
P='u13-apprecalc-mcq-'
fx={}
def ok(name,c):
    assert c,name; print('OK',name)
x=sp.symbols('x')

# 002-v2
R=sp.expand((1-x**2)*(x**2+4)); ok('002 A',sp.degree(R,x)==4 and sp.LC(R,x)==-1)
fx['002-v2']={'A':"Describes an odd-degree polynomial with a negative leading coefficient (rises left, falls right). R has even degree 4, so both ends point the same direction, and the leading term is -x^4, so both ends fall."}

# 011-v3
ok('011 A', abs(2*math.exp(math.log(14))-28)<1e-9 and abs(2*math.exp(math.log(7))-14)<1e-9)
fx['011-v3']={'A':"Drops the factor 2, treating the equation as e^(3x) = 14, so 3x = ln 14. Check: x = (ln 14)/3 gives 2e^(ln 14) = 28, not 14."}

# 017-v2
ok('017 B', abs(math.sin(5*math.pi/6)-.5)<1e-12 and abs(math.sin(7*math.pi/6)+.5)<1e-12 and abs(2*math.sin(5*math.pi/6)+1-2)<1e-12)
fx['017-v2']={'B':"Pairs 7*pi/6, which is a solution of sin x = -1/2, with 5*pi/6, which is a solution of sin x = +1/2. Check: sin(5*pi/6) = +1/2, so 2 sin x + 1 = 2, not 0, and 5*pi/6 is not a solution. It also omits 11*pi/6."}

# 022-v1
q=lambda v:v**4-13*v**2+36
ok('022 A', sp.solve(x**2-13*x+36,x)==[4,9] and q(4)==84 and q(9)==9**4-13*81+36 and q(9)!=0)
fx['022-v1']={'A':"Uses u = 4 and u = 9 (values of x^2) and their negatives as if they were values of x. The values 4 and 9 are solutions for x^2, not x; check: q(4) = 256 - 208 + 36 = 84, not 0."}

# 029-v2
f=lambda t:(9-t)/(t+8)
ok('029 C', f(10)<0 and f(-9)<0 and f(9)==0 and f(1)>0)
fx['029-v2']={'C':"This is the solution set of (x-9)/(x+8) >= 0, with the numerator sign reversed. For (9-x)/(x+8), values with x < -8 or x > 9 give negative quotients (x = 10 gives -1/18, x = -9 gives -18). Only the single value x = 9 (quotient 0) works there, and the interval (-8, 9), where the quotient is positive, is missing."}

# 037-v2
xs=[0,1,2,3,4];ys=[80,60.4,45.1,34.2,25.6]
mx=sum(xs)/5;my=sum(ys)/5
sxy=sum((a-mx)*(b-my) for a,b in zip(xs,ys));sxx=sum((a-mx)**2 for a in xs);syy=sum((b-my)**2 for b in ys)
r2=sxy**2/(sxx*syy)
d=[b-a for a,b in zip(ys,ys[1:])]; rat=[b/a for a,b in zip(ys,ys[1:])]
ok('037 C', abs(r2-.973)<.0005 and abs(min(d)+19.6)<1e-9 and abs(max(d)+8.6)<1e-9 and min(rat)>.746 and max(rat)<.759)
fx['037-v2']={'C':"A linear fit does have r^2 = 0.973, but a high r^2 alone does not show that a linear model is the best description. The first differences are -19.6, -15.3, -10.9, -8.6, which are not constant (linear data would have constant differences), while the successive ratios are all near 0.75, so an exponential model is better supported."}

# 040-v2
ok('040 B', round(math.log(50)/.07,1)==55.9 and abs(math.log(12)+.07*55.88-math.log(50))>1)
fx['040-v2']={'B':"Takes the log of both sides without handling the factor 12, writing 0.07t = ln 50, so t = ln(50)/0.07 = 55.9. But ln(12e^(0.07t)) = ln 12 + 0.07t, so the 12 must be divided out first. Check: P(55.9) = 12e^(3.913) is about 600, not 50."}
ok('040 B check', abs(12*math.exp(.07*55.9)-50)>500)

# 040-v3
ok('040v3 B', round(math.exp((3+7.5)/2.4),1)==79.4)
ok('040v3 D', round(math.exp(3/2.4),1)==3.5)
ok('040v3 true', round(math.exp((3-7.5)/-2.4),1)==6.5)
fx['040-v3']={'B':"Makes two sign errors: adds 7.5 instead of subtracting it and also drops the negative sign on -2.4, giving ln(x) = (3 + 7.5)/2.4 = 4.375 and x = e^4.375, about 79.4.",
 'D':"Ignores the constant 7.5 and also drops the negative sign on -2.4, giving ln(x) = 3/2.4 = 1.25 and x = e^1.25, about 3.5."}

# np2-001-v3
F=lambda t:100*t**3-5*t**4+t**2
ok('np1', F(10)==50100 and F(100)==-399990000 and F(1000)<F(100))
fx['np2-001-v3']={'A':"This chooses 100x^3 because it has the largest coefficient. Degree, not coefficient size, decides which term dominates. f(10) = 50,100 is still positive, but f(100) = -399,990,000, and the values keep getting more negative as x increases.",
 'C':"This reports the leading coefficient as if it were the limiting value. The leading term -5x^4 becomes arbitrarily large and negative as x increases; f(100) = -399,990,000, not about -5."}

# np2-002-v3
pp=sp.cancel((x+1)/((x+1)**2*(x-2)))
ok('np2 A', sp.simplify(pp-1/((x+1)*(x-2)))==0 and sp.denom(pp).subs(x,2)==0)
fx['np2-002-v3']={'A':"Gets x = -1 right but x = 2 wrong. The factor (x - 2) appears only in the denominator and cancels with nothing, so x = 2 is a vertical asymptote, not a hole."}

# np2-009-v1
v=[0,1,16,81,256,625]
dd=v
for _ in range(4): dd=[b-a for a,b in zip(dd,dd[1:])]
ok('np9', v==[k**4 for k in range(6)] and dd==[24,24])
fx['np2-009-v1']={'B':"Degree 5 is not needed. Any six points can be fit by some polynomial of degree at most 5, but the minimum degree is set by the first constant row of differences. Here the outputs equal x^4 and the fourth differences are already constant (24, 24), so degree 4 suffices."}

notes={'002-v2':'Only rationale A relied on degree alone; now states the pattern it mimics and the leading-coefficient sign.',
'011-v3':'A rationale mis-stated how ln(2e^(3x)) behaves; replaced with a verified check by substitution.',
'017-v2':'B incorrectly implied 7*pi/6 is not a sine-negative angle; rewritten around sin(5*pi/6) = +1/2.',
'022-v1':'A rationale wrongly said u = +/-4, +/-9; rewritten with a verified check q(4) = 84.',
'029-v2':'C rationale wrongly called the whole of [9, inf) negative; x = 9 gives 0, now stated precisely.',
'037-v2':'C rationale wrongly said high r^2 does not show linear pattern; now says it does not show linear is best.',
'040-v2':'B rationale misdescribed the error; now states ln(12e^(0.07t)) = ln 12 + 0.07t and substitution check.',
'040-v3':'B and D now describe the two-error combos that actually produce 79.4 and 3.5.',
'np2-001-v3':'A and C wording fixed: values decrease without bound rather than grow.',
'np2-002-v3':'A no longer says roles are swapped; says x=-1 is right and x=2 is wrong.',
'np2-009-v1':'B no longer claims degree 5 always passes through six points; says at most 5.'}
m={i['key']:i for i in json.load(open('math_items.json'))}
out={}
for k,r in fx.items():
    key=P+k; assert key in m
    out[key]={'decision':'rationale_fix','rationales':r,'note':notes[k]}
if True:
    # 029-v2 check of D/other unchanged ok
    pass
assert len(out)==11, len(out)
# 029 present
json.dump(out,open('variant_fixes.json','w'),indent=1,ensure_ascii=False)
print('written',len(out))
