import json, re, sympy as sp
from sympy.parsing.sympy_parser import parse_expr, standard_transformations, implicit_multiplication_application
x, t = sp.symbols('x t')
E, pi, sqrt, sin, cos, tan, ln = sp.E, sp.pi, sp.sqrt, sp.sin, sp.cos, sp.tan, sp.log
sec = lambda a: 1/sp.cos(a); csc = lambda a: 1/sp.sin(a); cot = lambda a: 1/sp.tan(a)
R = sp.Rational
def d(f, v, p): return sp.diff(f, v).subs(v, p)
TR = standard_transformations + (implicit_multiplication_application,)
SUP = {'²':'**2','³':'**3','⁴':'**4','⁵':'**5','⁻³':'**(-3)'}
def parse(s):
    s = s.replace('−','-')
    for k,v in sorted(SUP.items(), key=lambda kv:-len(kv[0])): s = s.replace(k, v)
    s = s.replace('^','**').replace('π',' pi ').replace('√',' sqrt')
    s = re.sub(r'(\d)e', r'\1 e', s)
    s = re.sub(r'sqrt(\d+)', r'sqrt(\1)', s)
    s = s.replace('ln ','log').replace('ln(','log(')
    return parse_expr(s, local_dict={'e':E,'x':x,'t':t,'pi':pi,'sqrt':sp.sqrt,'sin':sp.sin,'cos':sp.cos,'log':sp.log}, transformations=TR)
def same(a, b):
    if sp.simplify(a-b) == 0: return True
    return all(abs(sp.N((a-b).subs({x:v,t:v}))) < 1e-9 for v in (0.7, 1.1, 1.3))

V = []
def add(id, seed, diff, title, stem, correct, wrongs, note, check, vals):
    V.append(dict(id=id, seed=seed, difficulty=diff, title=title, stem=stem, correct=dict(text=correct[0], rationale=correct[1]),
        wrong=[dict(text=w[0], rationale=w[1], error_pattern=w[2]) for w in wrongs], change_note=note, check=check, _vals=vals))

# ---------------- u2n-011 product rule at a point
s='apcalcab-mcq-u2n-011'
f=(x**3-4)*(2*x+5)
add(s+'-v1',s,'easy','Product rule with a cubic factor',
 'The function g is defined by g(x) = (x³ − 4)(2x + 5). Find the value of g′(1).',
 ('15','By the product rule, g′(x) = 3x²(2x + 5) + (x³ − 4)(2). At x = 1: 3(7) + (−3)(2) = 21 − 6 = 15.'),
 [('21','This keeps only u′v = 3·7 = 21 and omits the second term uv′ = (−3)(2) = −6. The product rule needs both terms, so g′(1) = 21 − 6 = 15.','Omits second product-rule term'),
  ('6','This multiplies the derivatives of the factors, (3x²)(2) = 3·2 = 6 at x = 1. The product rule is u′v + uv′ = 21 + (−6) = 15, not u′v′.','Product of derivatives'),
  ('27','This subtracts the terms, u′v − uv′ = 21 − (−6) = 27, using a quotient-rule-style sign. The product rule adds them: 21 + (−6) = 15.','Subtracts terms')],
 'Cubic and linear factors with a different evaluation point; same two-term product rule structure.','numeric',
 [(d(f,x,1),None),(3*7,None),(3*2,None),(3*7-(-3)*2,None)])
w=(t**2+2); l=4*t-1; A=w*l
add(s+'-v2',s,'easy','Rate of change of a rectangle area',
 'A rectangle has width w(t) = t² + 2 centimeters and length ℓ(t) = 4t − 1 centimeters, where t is time in seconds. At what rate, in square centimeters per second, is the area of the rectangle changing at t = 3?',
 ('110','Area A = w·ℓ, so A′ = w′ℓ + wℓ′ = 2t(4t − 1) + (t² + 2)(4). At t = 3: 6(11) + 11(4) = 66 + 44 = 110.'),
 [('66','This keeps only w′ℓ = 6·11 = 66 and omits wℓ′ = 11·4 = 44. Both terms are needed: 66 + 44 = 110.','Omits second product-rule term'),
  ('24','This multiplies the rates of change of the sides, w′(3)·ℓ′(3) = 6·4 = 24. The rate of change of a product is w′ℓ + wℓ′ = 110, not w′ℓ′.','Product of derivatives'),
  ('121','This is the area itself, A(3) = 11·11 = 121 cm², not its rate of change. The rate requires A′(3) = 110.','Evaluates the function instead of the derivative')],
 'Applied context (rectangle area as a product of two changing sides) with a different pair of functions.','numeric',
 [(d(A,t,3),None),(d(w,t,3)*l.subs(t,3),None),(d(w,t,3)*d(l,t,3),None),(A.subs(t,3),None)])
f=(x**2+1)*sin(x)
add(s+'-v3',s,'easy','Product rule with a sine factor',
 'Consider the function h(x) = (x² + 1) sin x. Evaluate h′(π).',
 ('−π² − 1','h′(x) = 2x sin x + (x² + 1) cos x. At x = π: 2π(0) + (π² + 1)(−1) = −π² − 1.'),
 [('0','This keeps only u′v = 2π·sin π = 0 and omits uv′ = (π² + 1)cos π = −(π² + 1). The product rule needs both terms, so h′(π) = −π² − 1.','Omits second product-rule term'),
  ('−2π','This multiplies the derivatives of the factors, (2x)(cos x) = 2π·(−1) = −2π. The product rule is u′v + uv′ = −π² − 1, not u′v′.','Product of derivatives'),
  ('π² + 1','This subtracts the terms, u′v − uv′ = 0 − (π² + 1)(−1) = π² + 1, a quotient-rule-style sign. The product rule adds: 0 + (−(π² + 1)) = −π² − 1.','Subtracts terms')],
 'Trigonometric second factor, evaluated at a multiple of pi so one term vanishes.','numeric',
 [(d(f,x,pi),None),(2*pi*sin(pi),None),(2*pi*cos(pi),None),(2*pi*sin(pi)-(pi**2+1)*cos(pi),None)])

# ---------------- u2n-012 identify product-rule error (conceptual)
s='apcalcab-mcq-u2n-012'
add(s+'-v1',s,'medium','Spot the product rule error with a cube',
 'Let k(x) = x³·f(x), where f(2) = −1 and f′(2) = 4. A student writes k′(2) = (3·2²)(4) = 48. Which statement correctly identifies the student\'s error and gives the correct value of k′(2)?',
 ('The student multiplied the derivatives of the factors; the product rule gives k′(2) = 12·(−1) + 8·4 = 20.','k′(x) = 3x²·f(x) + x³·f′(x), so k′(2) = 12·(−1) + 8·4 = −12 + 32 = 20. The student computed (x³)′·f′(2) = 12·4 = 48, which is the product of the derivatives, not the product rule.'),
 [('The student differentiated x³ when only f should be differentiated; k′(2) = 8·4 = 32.','Both factors must be differentiated, with one term for each. 8·4 = 32 is only the x³f′ term; the full value is 12·(−1) + 8·4 = 20.','Keeps only second term'),
  ('The student should have differentiated only x³; k′(2) = 12·(−1) = −12.','−12 is only the (x³)′f term. The product rule also needs the term x³f′(2) = 8·4 = 32, so k′(2) = −12 + 32 = 20.','Keeps only first term'),
  ('The student should have subtracted the two product-rule terms; k′(2) = 12·(−1) − 8·4 = −44.','The product rule adds the terms: 12·(−1) + 8·4 = 20. Subtracting would give −12 − 32 = −44. The student\'s actual error was multiplying the derivatives, 12·4 = 48.','Subtracts terms')],
 'Cube factor and different f data; same diagnose-the-error structure.','conceptual',
 [(3*4*(-1)+8*4,20),(8*4,32),(12*(-1),-12),(12*(-1)-8*4,-44)])
add(s+'-v2',s,'medium','Identify the product rule slip with a square root',
 'The function m is given by m(x) = √x·f(x), with f(4) = 3 and f′(4) = −2. Working at x = 4, a student computes m′(4) = (1/4)(−2) = −1/2. What did the student do wrong, and what is the correct value of m′(4)?',
 ('The student multiplied the derivatives of the two factors; the correct value is m′(4) = (1/4)(3) + 2(−2) = −13/4.','m′(x) = (1/(2√x))f(x) + √x·f′(x), so m′(4) = (1/4)(3) + 2(−2) = 3/4 − 4 = −13/4. The student multiplied (√x)′ = 1/4 by f′(4) = −2, which is not the product rule.'),
 [('The student differentiated √x when only f should be differentiated; the correct value is m′(4) = 2(−2) = −4.','Both factors must be differentiated. 2(−2) = −4 is only the √x·f′ term; the full value is 3/4 + (−4) = −13/4.','Keeps only second term'),
  ('The student should have differentiated only √x; the correct value is m′(4) = (1/4)(3) = 3/4.','3/4 is only the (√x)′f term. The product rule also contains √x·f′(4) = 2(−2) = −4, so m′(4) = 3/4 − 4 = −13/4.','Keeps only first term'),
  ('The student should have subtracted the product-rule terms; the correct value is m′(4) = (1/4)(3) − 2(−2) = 19/4.','The product rule adds the terms: 3/4 + (−4) = −13/4. Subtracting gives 3/4 + 4 = 19/4, a quotient-rule-style sign. The student\'s own error was multiplying the derivatives.','Subtracts terms')],
 'Square-root factor with fractional values; wrong choices are anchored to omission of a term or a sign change.','conceptual',
 [(R(1,4)*3+2*(-2),R(-13,4)),(2*(-2),-4),(R(1,4)*3,R(3,4)),(R(1,4)*3-2*(-2),R(19,4))])
add(s+'-v3',s,'medium','Product rule diagnosis with a logarithm',
 'Suppose n(x) = f(x)·ln x, where f(e) = 2 and f′(e) = 3. To find n′(e), a student writes n′(e) = f′(e)·(1/e) = 3/e. Which response correctly diagnoses the mistake and states the true value of n′(e)?',
 ('The student multiplied the derivatives of f and ln x; the product rule gives n′(e) = 3·ln e + 2·(1/e) = 3 + 2/e.','n′(x) = f′(x)·ln x + f(x)·(1/x), so n′(e) = 3·1 + 2/e = 3 + 2/e. The student multiplied f′(e) by (ln x)′ = 1/e, the product of the derivatives, which is not the product rule.'),
 [('The student should have differentiated only ln x; the correct value is n′(e) = 2·(1/e) = 2/e.','2/e is only the f·(ln x)′ term. The product rule also contains f′(e)·ln e = 3·1 = 3, so n′(e) = 3 + 2/e.','Keeps only second term'),
  ('The student should have differentiated only f; the correct value is n′(e) = 3·ln e = 3.','3 is only the f′·ln x term. The product rule also contains f(e)·(1/e) = 2/e, so n′(e) = 3 + 2/e.','Keeps only first term'),
  ('The student should have subtracted the product-rule terms; the correct value is n′(e) = 3·ln e − 2·(1/e) = 3 − 2/e.','The product rule adds the terms: 3 + 2/e. Subtracting gives 3 − 2/e, a quotient-rule-style sign. The student\'s own error was multiplying the derivatives.','Subtracts terms')],
 'Logarithmic factor; evaluation at x = e makes ln e = 1 so every wrong value is checkable by hand.','conceptual',
 [(3*1+2/E,3+2/E),(2/E,2/E),(3,3),(3-2/E,3-2/E)])

# ---------------- u2n-013 quotient at a point
s='apcalcab-mcq-u2n-013'
g=(x**2+3)/(x+2)
add(s+'-v1',s,'medium','Quotient rule with a quadratic numerator',
 'The function g is defined by g(x) = (x² + 3)/(x + 2). What is the value of g′(1)?',
 ('2/9','g′(x) = [2x(x + 2) − (x² + 3)(1)]/(x + 2)². At x = 1: [2(3) − 4]/9 = 2/9.'),
 [('−2/9','This reverses the numerator, (x² + 3) − 2x(x + 2) = 4 − 6 = −2, instead of (low)(d high) − (high)(d low) = 6 − 4 = 2. So g′(1) = 2/9.','Reversed quotient-rule numerator'),
  ('10/9','This adds the terms in the numerator, 2(1)(3) + 4 = 10, using a product-rule sign. The quotient rule subtracts: 6 − 4 = 2, giving 2/9.','Adds terms in numerator'),
  ('2/3','This forgets to square the denominator, using 2/(x + 2) = 2/3. The quotient rule divides by (x + 2)² = 9, giving 2/9.','Denominator not squared')],
 'Polynomial quotient with a different denominator; distractors target sign, addition and squaring slips.','numeric',
 [(d(g,x,1),None),(R(4-6,9),None),(R(6+4,9),None),(R(2,3),None)])
C=E**t/(t+2)
add(s+'-v2',s,'medium','Rate of change of a drug concentration',
 'The concentration of a medication in the bloodstream, in milligrams per liter, is modeled by C(t) = eᵗ/(t + 2), where t is the number of hours after the dose. What is C′(0), the rate of change in milligrams per liter per hour at t = 0?',
 ('1/4','C′(t) = [eᵗ(t + 2) − eᵗ(1)]/(t + 2)². At t = 0: [1(2) − 1(1)]/4 = 1/4.'),
 [('−1/4','This reverses the numerator, eᵗ − eᵗ(t + 2) = 1 − 2 = −1, instead of eᵗ(t + 2) − eᵗ = 2 − 1 = 1. So C′(0) = 1/4.','Reversed quotient-rule numerator'),
  ('3/4','This adds the terms in the numerator, 2 + 1 = 3, using a product-rule sign. The quotient rule subtracts: 2 − 1 = 1, giving 1/4.','Adds terms in numerator'),
  ('1','This divides the derivatives, e⁰/1 = 1, as if (u/v)′ = u′/v′. The quotient rule gives [u′v − uv′]/v² = 1/4.','Quotient of derivatives')],
 'Exponential numerator in an applied concentration context.','numeric',
 [(d(C,t,0),None),(R(1-2,4),None),(R(2+1,4),None),(1,None)])
f=sp.log(x)/x**2
add(s+'-v3',s,'medium','Quotient rule with a logarithm',
 'If f(x) = (ln x)/x², what is the value of f′(e)?',
 ('−1/e³','f′(x) = [(1/x)x² − (ln x)(2x)]/x⁴ = (1 − 2 ln x)/x³. At x = e: (1 − 2)/e³ = −1/e³.'),
 [('1/e³','This reverses the numerator, (ln x)(2x) − (1/x)x² = 2e − e = e, instead of (low)(d high) − (high)(d low) = e − 2e = −e. So f′(e) = −e/e⁴ = −1/e³.','Reversed quotient-rule numerator'),
  ('1/(2e²)','This divides the derivatives, (1/x)/(2x) = 1/(2x²) = 1/(2e²), as if (u/v)′ = u′/v′. The quotient rule gives −1/e³.','Quotient of derivatives'),
  ('3/e³','This adds the terms in the numerator, e + 2e = 3e, using a product-rule sign. The quotient rule subtracts: e − 2e = −e, so f′(e) = −e/e⁴ = −1/e³.','Adds terms in numerator')],
 'Logarithm over a power; evaluation at x = e keeps all values closed-form.','numeric',
 [(d(f,x,E),None),(E**-3,None),(1/(2*E**2),None),(3/E**3,None)])

# ---------------- u2n-014 horizontal tangents
s='apcalcab-mcq-u2n-014'
def roots(num): return sorted(sp.solve(num,x))
add(s+'-v1',s,'hard','Horizontal tangents of x²/(x − 2)',
 'Consider the curve y = x²/(x − 2). Find every x-value at which the tangent line to this curve is horizontal.',
 ('x = 0 or x = 4','y′ = [2x(x − 2) − x²(1)]/(x − 2)² = (x² − 4x)/(x − 2)² = x(x − 4)/(x − 2)². The numerator is 0 at x = 0 and x = 4, and neither makes the denominator 0.'),
 [('x = 4 only','Dividing x² − 4x = 0 by x loses the root x = 0 (x(x − 4) = 0 gives both). At x = 0, y′ = 0 as well.','Divides out a factor and loses a root'),
  ('x = 2 only','x = 2 makes the denominator 0, so the curve has a vertical asymptote there and y′ is undefined. Horizontal tangents occur where the numerator x² − 4x = 0, at x = 0 and x = 4.','Uses denominator zero'),
  ('x = 0 or x = 4/3','This adds the terms in the numerator, 2x(x − 2) + x² = 3x² − 4x, whose roots are 0 and 4/3. The quotient rule subtracts: 2x(x − 2) − x² = x² − 4x, whose roots are 0 and 4.','Adds terms in numerator')],
 'Different rational function; distractors mirror sign, lost root and asymptote errors.','numeric',
 [(roots(x**2-4*x),[0,4]),([4],[4]),([2],[2]),(roots(3*x**2-4*x),[0,R(4,3)])])
add(s+'-v2',s,'hard','Horizontal tangent of eˣ/x',
 'For which values of x does the graph of y = eˣ/x have a horizontal tangent line?',
 ('x = 1','y′ = [eˣ·x − eˣ(1)]/x² = eˣ(x − 1)/x². Since eˣ is never 0, y′ = 0 only when x − 1 = 0, so x = 1.'),
 [('x = −1','This adds the terms in the numerator, eˣ·x + eˣ = eˣ(x + 1), which is 0 at x = −1. The quotient rule subtracts: eˣ·x − eˣ = eˣ(x − 1), which is 0 at x = 1.','Adds terms in numerator'),
  ('x = 0','The graph has no point at x = 0 because x is in the denominator, and y′ is undefined there. Horizontal tangents occur where the numerator eˣ(x − 1) = 0, at x = 1.','Uses denominator zero'),
  ('There are no such values of x.','This divides the derivatives, eˣ/1 = eˣ, which is never 0, as if (u/v)′ = u′/v′. The quotient rule gives eˣ(x − 1)/x², which is 0 at x = 1.','Quotient of derivatives')],
 'Exponential numerator; one critical point, with sign, domain and derivative-quotient distractors.','numeric',
 [(sp.solve(sp.exp(x)*(x-1),x),[1]),(sp.solve(sp.exp(x)*(x+1),x),[-1]),([0],[0]),(sp.solve(sp.exp(x)/1,x),[])])
add(s+'-v3',s,'hard','Horizontal tangent of (x − 3)/x²',
 'The curve y = (x − 3)/x² is graphed for x ≠ 0. At which value or values of x is its tangent line horizontal?',
 ('x = 6','y′ = [(1)x² − (x − 3)(2x)]/x⁴ = (−x² + 6x)/x⁴ = (6 − x)/x³. This is 0 only at x = 6.'),
 [('x = 0 and x = 6','Setting the numerator −x² + 6x = 0 gives 0 and 6, but x = 0 is not in the domain of the curve, so there is no tangent line there. Only x = 6 works.','Ignores the domain restriction'),
  ('x = 3','x = 3 is where y = 0 (the numerator of y), not where y′ = 0. At x = 3, y′ = (6 − 3)/27 = 1/9, so the tangent is not horizontal.','Confuses zero of y with zero of y′'),
  ('x = 2','This adds the terms in the numerator, x² + 2x(x − 3) = 3x² − 6x = 3x(x − 2), whose nonzero root is x = 2. The quotient rule subtracts: x² − 2x(x − 3) = −x² + 6x, giving x = 6.','Adds terms in numerator')],
 'Reduced-fraction trap: x = 0 solves the numerator but is excluded from the domain.','numeric',
 [([r for r in sp.solve(sp.together(sp.diff((x-3)/x**2,x)).as_numer_denom()[0],x) if r!=0],[6]),
  (roots(-x**2+6*x),[0,6]),(sp.solve(x-3,x),[3]),([r for r in roots(3*x**2-6*x) if r!=0],[2])])

# ---------------- u2n-015 sec/cot style
s='apcalcab-mcq-u2n-015'
a=pi/6
add(s+'-v1',s,'hard','Derivatives of csc x and tan x',
 'If f(x) = csc x + tan x, what is f′(π/6)?',
 ('4/3 − 2√3','f′(x) = −csc x cot x + sec² x. At π/6: csc = 2, cot = √3, sec² = 4/3, so f′(π/6) = −2√3 + 4/3.'),
 [('4/3 + 2√3','This uses (csc x)′ = +csc x cot x. The correct derivative is −csc x cot x = −2√3, so f′(π/6) = 4/3 − 2√3.','Wrong sign on csc derivative'),
  ('−4/3 − 2√3','This uses (tan x)′ = −sec² x, a sign borrowed from cos. The derivative of tan x is +sec² x = 4/3, so f′(π/6) = 4/3 − 2√3.','Wrong sign on tan derivative'),
  ('−8/3','This uses (csc x)′ = −csc² x = −4 (confusing it with cot), giving −4 + 4/3 = −8/3. The derivative of csc x is −csc x cot x = −2√3.','Confuses csc derivative with cot derivative')],
 'Different trig pair (csc and tan) at pi/6; same family of sign and identity confusions.','numeric',
 [(d(csc(x)+tan(x),x,a),None),(csc(a)*cot(a)+sec(a)**2,None),(-csc(a)*cot(a)-sec(a)**2,None),(-csc(a)**2+sec(a)**2,None)])
a=pi/3
add(s+'-v2',s,'hard','Derivatives of sec x and cot x at pi/3',
 'Let g(x) = sec x − cot x. Find g′(π/3).',
 ('2√3 + 4/3','g′(x) = sec x tan x + csc² x. At π/3: sec = 2, tan = √3, csc² = 4/3, so g′(π/3) = 2√3 + 4/3.'),
 [('2√3 − 4/3','This uses (cot x)′ = +csc² x, so the subtracted term gives −4/3. Since (cot x)′ = −csc² x, the term −cot x contributes +csc² x = +4/3, so g′(π/3) = 2√3 + 4/3.','Wrong sign on cot derivative'),
  ('16/3','This uses (sec x)′ = sec² x = 4, giving 4 + 4/3 = 16/3. The derivative of sec x is sec x tan x = 2√3.','Confuses sec derivative with tan derivative'),
  ('2√3 + 2/3','This uses (cot x)′ = −csc x cot x = −2/3, so −cot x contributes +2/3. The derivative of cot x is −csc² x, which makes −cot x contribute +4/3, so g′(π/3) = 2√3 + 4/3.','Confuses cot derivative with csc derivative')],
 'Sec and cot combination at pi/3 with a subtraction that flips the cot sign.','numeric',
 [(d(sec(x)-cot(x),x,a),None),(sec(a)*tan(a)-csc(a)**2,None),(sec(a)**2+csc(a)**2,None),(sec(a)*tan(a)+csc(a)*cot(a),None)])
a=pi/4
ps=2*csc(t)-3*cot(t)
add(s+'-v3',s,'hard','Velocity from csc t and cot t',
 'A particle moves along a line so that its position, in meters, is s(t) = 2 csc t − 3 cot t for 0 < t < π, where t is in seconds. What is the velocity of the particle at t = π/4 seconds, in meters per second?',
 ('6 − 2√2','s′(t) = −2 csc t cot t + 3 csc² t. At π/4: csc = √2, cot = 1, csc² = 2, so s′(π/4) = −2√2 + 6.'),
 [('6 + 2√2','This uses (csc t)′ = +csc t cot t, giving +2√2. The correct derivative is −csc t cot t, so the first term is −2√2 and s′(π/4) = 6 − 2√2.','Wrong sign on csc derivative'),
  ('−6 − 2√2','This uses (cot t)′ = +csc² t, so −3 cot t gives −3·2 = −6. Since (cot t)′ = −csc² t, that term is +6 and s′(π/4) = 6 − 2√2.','Wrong sign on cot derivative'),
  ('2','This uses (csc t)′ = −csc² t = −2, so the first term is 2(−2) = −4 and s′ = −4 + 6 = 2. The derivative of csc t is −csc t cot t = −√2, giving 6 − 2√2.','Confuses csc derivative with cot derivative')],
 'Kinematic context with csc and cot and scalar multiples; velocity is the derivative of position.','numeric',
 [(d(ps,t,a),None),(2*csc(a)*cot(a)+3*csc(a)**2,None),(-2*csc(a)*cot(a)-3*csc(a)**2,None),(2*(-csc(a)**2)+3*csc(a)**2,None)])

# ---------------- u3n-001 chain power
s='apcalcab-mcq-u3n-001'
add(s+'-v1',s,'easy','Chain rule on a power of a cubic',
 'Let f(x) = (x³ − 2x)⁵. Which expression gives f′(x)?',
 ('5(3x² − 2)(x³ − 2x)⁴','The outer power u⁵ has derivative 5u⁴ and the inner function x³ − 2x has derivative 3x² − 2, so f′(x) = 5(x³ − 2x)⁴(3x² − 2).'),
 [('5(x³ − 2x)⁴','This applies the power rule to the outer function but omits the inner derivative 3x² − 2. The chain rule requires that factor.','Omits inner derivative'),
  ('5(3x² − 2)(x³ − 2x)⁵','The factor 5(3x² − 2) is correct, but the exponent was not lowered: the power rule turns 5 into 4, so the factor is (x³ − 2x)⁴.','Exponent not lowered'),
  ('5(3x² − 2)⁴','This replaces the inside x³ − 2x by its derivative 3x² − 2 and raises that to the fourth power. The inner function must stay inside the power, with 3x² − 2 appearing only as a multiplier.','Differentiates the inside in place')],
 'Cubic inside a fifth power; same three chain-rule slips.','numeric',
 [(sp.diff((x**3-2*x)**5,x),None),(5*(x**3-2*x)**4,None),(5*(3*x**2-2)*(x**3-2*x)**5,None),(5*(3*x**2-2)**4,None)])
add(s+'-v2',s,'easy','Chain rule on a square root',
 'The function f is defined by f(x) = √(6x − x²) on the interval 0 < x < 6. What is f′(x)?',
 ('(3 − x)/√(6x − x²)','Write f(x) = (6x − x²)^(1/2). Then f′(x) = (1/2)(6x − x²)^(−1/2)(6 − 2x) = (6 − 2x)/(2√(6x − x²)) = (3 − x)/√(6x − x²).'),
 [('(6 − 2x)/√(6x − x²)','This drops the factor 1/2 from the power rule: d/du √u = 1/(2√u). With it, (6 − 2x)/(2√(6x − x²)) simplifies to (3 − x)/√(6x − x²).','Drops the 1/2'),
  ('1/(2√(6x − x²))','This differentiates the square root but omits the inner derivative 6 − 2x. The chain rule multiplies by 6 − 2x, giving (3 − x)/√(6x − x²).','Omits inner derivative'),
  ('(3 − x)√(6x − x²)','This keeps the exponent 1/2 instead of lowering it to −1/2: (1/2)(6 − 2x)(6x − x²)^(1/2) = (3 − x)√(6x − x²). The power rule gives (6x − x²)^(−1/2), which belongs in the denominator.','Exponent not lowered')],
 'Radical outer function written with a rational exponent.','numeric',
 [(sp.diff(sqrt(6*x-x**2),x),None),((6-2*x)/sqrt(6*x-x**2),None),(1/(2*sqrt(6*x-x**2)),None),(R(1,2)*(6-2*x)*(6*x-x**2)**R(1,2),None)])
add(s+'-v3',s,'easy','Chain rule on a reciprocal power',
 'If f(x) = 1/(4x² + 3)², what is f′(x)?',
 ('−16x/(4x² + 3)³','Write f(x) = (4x² + 3)^(−2). Then f′(x) = −2(4x² + 3)^(−3)(8x) = −16x/(4x² + 3)³.'),
 [('−2/(4x² + 3)³','This applies the power rule to the outer function but omits the inner derivative 8x. The chain rule requires that factor, giving −16x/(4x² + 3)³.','Omits inner derivative'),
  ('−16x/(4x² + 3)²','The coefficient −16x is correct, but the exponent −2 was not lowered to −3. The denominator must be (4x² + 3)³.','Exponent not lowered'),
  ('16x/(4x² + 3)³','The exponent is correct, but the negative sign from the outer exponent −2 was lost: (−2)(8x) = −16x, not 16x.','Loses the negative sign')],
 'Negative exponent / reciprocal form of a composite power.','numeric',
 [(sp.diff(1/(4*x**2+3)**2,x),None),(-2/(4*x**2+3)**3,None),(-16*x/(4*x**2+3)**2,None),(16*x/(4*x**2+3)**3,None)])

# ---------------- u3n-002 tangent slope
s='apcalcab-mcq-u3n-002'
add(s+'-v1',s,'medium','Tangent slope of e^(x² − 4x)',
 'The graph of y = e^(x² − 4x) contains the point (3, e^(−3)). Find the slope of the tangent line to the graph at x = 3.',
 ('2e^(−3)','dy/dx = e^(x² − 4x)·(2x − 4). At x = 3 the exponent is −3 and 2x − 4 = 2, so the slope is 2e^(−3).'),
 [('e^(−3)','This is e^(x² − 4x) at x = 3 with no inner derivative. The chain rule multiplies by 2x − 4 = 2, so the slope is 2e^(−3).','Omits inner derivative'),
  ('2e²','This writes e^(u′) = e^(2x − 4) = e² and multiplies by 2. The exponent must stay u = x² − 4x = −3, and u′ = 2 appears only as a multiplier, giving 2e^(−3).','Differentiates the exponent in place'),
  ('−3e^(−3)','This multiplies by the exponent value u = −3 instead of u′ = 2, treating e^u like u·e^u. The derivative of e^u is e^u·u′, so the slope is 2e^(−3).','Multiplies by u instead of u′')],
 'Different exponent and evaluation point, giving a negative power of e.','numeric',
 [(d(E**(x**2-4*x),x,3),None),(E**-3,None),(2*E**2,None),(-3*E**-3,None)])
add(s+'-v2',s,'medium','Tangent slope of a logarithm of a quadratic',
 'The curve y = ln(x² + 3x) passes through the point (2, ln 10). What is the slope of the tangent line to the curve at x = 2?',
 ('7/10','dy/dx = (2x + 3)/(x² + 3x). At x = 2: (4 + 3)/(4 + 6) = 7/10.'),
 [('1/10','This is 1/(x² + 3x) = 1/10, the derivative of ln u as 1/u with no inner derivative. The chain rule multiplies by u′ = 2x + 3 = 7, giving 7/10.','Omits inner derivative'),
  ('7','This uses only the inner derivative u′ = 2x + 3 = 7 and omits the factor 1/u = 1/10 from differentiating ln u. The slope is u′/u = 7/10.','Omits the 1/u factor'),
  ('70','This multiplies u′ = 7 by u = 10 instead of dividing, as if (ln u)′ = u′·u. The derivative of ln u is u′/u, so the slope is 7/10.','Multiplies instead of divides by u')],
 'Logarithmic outer function on a quadratic; slope evaluated at a point.','numeric',
 [(d(sp.log(x**2+3*x),x,2),None),(R(1,10),None),(7,None),(70,None)])
add(s+'-v3',s,'medium','Tangent slope of cos(πx²)',
 'The graph of y = cos(πx²) passes through the point (1/2, √2/2). What is the slope of the tangent line at x = 1/2?',
 ('−π√2/2','dy/dx = −sin(πx²)·(2πx). At x = 1/2: −sin(π/4)·π = −(√2/2)π = −π√2/2.'),
 [('π√2/2','This uses (cos u)′ = +sin u, dropping the negative sign. The derivative of cos u is −sin u·u′, so the slope is −π√2/2.','Wrong sign on cosine derivative'),
  ('−√2/2','This is −sin(πx²) = −sin(π/4) at x = 1/2 with no inner derivative. The chain rule multiplies by 2πx = π, giving −π√2/2.','Omits inner derivative'),
  ('0','This replaces the inside πx² by its derivative 2πx, giving −sin(2πx) = −sin π = 0. The inner function must stay inside sine, with 2πx appearing only as a multiplier.','Differentiates the inside in place')],
 'Trigonometric outer function with a scaled quadratic inside, evaluated at a rational point.','numeric',
 [(d(cos(pi*x**2),x,R(1,2)),None),(sin(pi/4)*pi,None),(-sin(pi/4),None),(-sin(2*pi*R(1,2)),None)])

# ---------------- u3n-003 chain from data
s='apcalcab-mcq-u3n-003'
add(s+'-v1',s,'medium','Chain rule from a table, f of g',
 'Selected values of the differentiable functions f and g are listed below.\n\nx | f(x) | f′(x) | g(x) | g′(x)\n1 | 4 | −3 | 2 | 6\n2 | 0 | 7 | −1 | 5\n4 | 3 | 2 | 4 | −2\n\nDefine p by composing f with g, so that p(x) = f(g(x)). Find the value of p′(1).',
 ('42','p′(x) = f′(g(x))·g′(x). Since g(1) = 2, p′(1) = f′(2)·g′(1) = 7·6 = 42.'),
 [('−18','This uses f′(1)·g′(1) = (−3)(6) = −18, evaluating f′ at x = 1. The outer derivative must be evaluated at g(1) = 2, so f′(2) = 7 is needed.','Outer derivative at wrong input'),
  ('7','This is f′(g(1)) = f′(2) = 7 only; it omits the factor g′(1) = 6 required by the chain rule.','Omits inner derivative'),
  ('14','This multiplies f′(2) = 7 by g(1) = 2, using the value of g instead of its derivative. The chain rule needs g′(1) = 6, giving 42.','Uses g instead of g′')],
 'New table; composite f(g(x)) at x = 1 with a three-row table.','numeric',
 [(7*6,None),((-3)*6,None),(7,None),(7*2,None)])
add(s+'-v2',s,'medium','Chain rule from function values',
 'Let F and G be differentiable functions with G(2) = 5, G′(2) = 3, F(2) = −1, F′(2) = 4, F(5) = 2, and F′(5) = −6. If H(x) = F(G(x)), what is H′(2)?',
 ('−18','H′(x) = F′(G(x))·G′(x). Since G(2) = 5, H′(2) = F′(5)·G′(2) = (−6)(3) = −18.'),
 [('12','This uses F′(2)·G′(2) = 4·3 = 12, evaluating F′ at x = 2. The outer derivative must be evaluated at G(2) = 5, so F′(5) = −6 is needed.','Outer derivative at wrong input'),
  ('−30','This multiplies F′(5) = −6 by G(2) = 5, using the value of G instead of its derivative. The chain rule needs G′(2) = 3, giving −18.','Uses G instead of G′'),
  ('−6','This is F′(G(2)) = F′(5) = −6 only; it omits the factor G′(2) = 3 required by the chain rule.','Omits inner derivative')],
 'Given as listed values instead of a table; same structure with new numbers and function names.','numeric',
 [((-6)*3,None),(4*3,None),(-6*5,None),(-6,None)])
add(s+'-v3',s,'medium','Chain rule from a table, g of f',
 'The differentiable functions f and g have the following values.\n\nx | f(x) | f′(x) | g(x) | g′(x)\n1 | 3 | −2 | 4 | 5\n3 | 1 | 6 | −2 | 3\n\nIf q(x) = g(f(x)), what is q′(1)?',
 ('−6','q′(x) = g′(f(x))·f′(x). Since f(1) = 3, q′(1) = g′(3)·f′(1) = 3·(−2) = −6.'),
 [('−10','This uses g′(1)·f′(1) = 5·(−2) = −10, evaluating g′ at x = 1. The outer derivative must be evaluated at f(1) = 3, so g′(3) = 3 is needed.','Outer derivative at wrong input'),
  ('9','This multiplies g′(3) = 3 by f(1) = 3, using the value of f instead of its derivative. The chain rule needs f′(1) = −2, giving −6.','Uses f instead of f′'),
  ('3','This is g′(f(1)) = g′(3) = 3 only; it omits the factor f′(1) = −2 required by the chain rule.','Omits inner derivative')],
 'Reversed composite order g(f(x)) with a two-row table.','numeric',
 [(3*(-2),None),(5*(-2),None),(3*3,None),(3,None)])

# ---------------- u3n-004 three layers
s='apcalcab-mcq-u3n-004'
add(s+'-v1',s,'hard','Three-layer exponential-radical composite',
 'If f(x) = e^(√(x² + 1)), what is f′(x)?',
 ('x e^(√(x² + 1))/√(x² + 1)','Differentiate layer by layer: e^(√(x² + 1))·(1/(2√(x² + 1)))·2x = 2x e^(√(x² + 1))/(2√(x² + 1)) = x e^(√(x² + 1))/√(x² + 1).'),
 [('e^(√(x² + 1))/(2√(x² + 1))','This applies the exponential and square-root layers but omits the innermost derivative 2x of x² + 1. Including it gives x e^(√(x² + 1))/√(x² + 1).','Omits innermost derivative'),
  ('2x e^(√(x² + 1))/√(x² + 1)','This drops the factor 1/2 from differentiating the square root: d/du √u = 1/(2√u). With it, the 2x in the numerator cancels to x.','Drops the 1/2'),
  ('x/√(x² + 1)','This differentiates only the exponent √(x² + 1) and omits the factor e^(√(x² + 1)), which is the derivative of the outer exponential layer.','Omits the outer exponential factor')],
 'Exponential outer, radical middle, quadratic inner layer.','numeric',
 [(sp.diff(E**sqrt(x**2+1),x),None),(E**sqrt(x**2+1)/(2*sqrt(x**2+1)),None),(2*x*E**sqrt(x**2+1)/sqrt(x**2+1),None),(x/sqrt(x**2+1),None)])
add(s+'-v2',s,'hard','Logarithm of a sine of a quadratic',
 'The function f is defined by f(x) = ln(sin(x²)) for 0 < x < √π. What is f′(x)?',
 ('2x cos(x²)/sin(x²)','Differentiate layer by layer: (1/sin(x²))·cos(x²)·2x = 2x cos(x²)/sin(x²).'),
 [('cos(x²)/sin(x²)','This applies the logarithm and sine layers but omits the innermost derivative 2x of x². The chain rule requires that factor.','Omits innermost derivative'),
  ('2x/sin(x²)','This applies the logarithm layer and the innermost derivative 2x but omits the derivative of the sine layer, cos(x²).','Omits middle-layer derivative'),
  ('−2x cos(x²)/sin(x²)','This uses (sin u)′ = −cos u, a sign borrowed from cosine. The derivative of sin u is +cos u, so the result is +2x cos(x²)/sin(x²).','Wrong sign on sine derivative')],
 'Logarithm outer, sine middle, quadratic inner layer on a restricted domain.','numeric',
 [(sp.diff(sp.log(sin(x**2)),x),None),(cos(x**2)/sin(x**2),None),(2*x/sin(x**2),None),(-2*x*cos(x**2)/sin(x**2),None)])
add(s+'-v3',s,'hard','Cube of a sine of a multiple',
 'Let f(x) = (sin(2x))³. Which expression gives f′(x)?',
 ('6(sin(2x))²cos(2x)','Differentiate layer by layer: 3(sin(2x))²·cos(2x)·2 = 6(sin(2x))²cos(2x).'),
 [('3(sin(2x))²cos(2x)','This applies the power and sine layers but omits the innermost derivative 2 of 2x. Including it doubles the result to 6(sin(2x))²cos(2x).','Omits innermost derivative'),
  ('−6(sin(2x))²cos(2x)','This uses (sin u)′ = −cos u, a sign borrowed from cosine. The derivative of sin u is +cos u, so the result is +6(sin(2x))²cos(2x).','Wrong sign on sine derivative'),
  ('6(sin(2x))²','This applies the power layer and the innermost factor 2 but omits the derivative of the sine layer, cos(2x).','Omits middle-layer derivative')],
 'Trigonometric power composite with a scaled argument.','numeric',
 [(sp.diff(sin(2*x)**3,x),None),(3*sin(2*x)**2*cos(2*x),None),(-6*sin(2*x)**2*cos(2*x),None),(6*sin(2*x)**2,None)])

# ---------------- u3n-005 implicit
s='apcalcab-mcq-u3n-005'
y=sp.Symbol('y'); yp=sp.Symbol('yp')
def implicit(F, pt):
    # F(x,y)=const; slope = -Fx/Fy
    return (-sp.diff(F,x)/sp.diff(F,y)).subs(pt)
add(s+'-v1',s,'easy','Implicit slope of xy² = 18',
 'A curve is defined implicitly by xy² = 18, and the point (2, 3) lies on the curve. Find the slope of the tangent line at that point.',
 ('−3/4','Differentiate both sides with the product rule: y² + 2xy·dy/dx = 0. At (2, 3): 9 + 12·dy/dx = 0, so dy/dx = −3/4.'),
 [('−3/2','This differentiates xy² as y² + 2y·dy/dx, dropping the factor x from the term 2xy·dy/dx. Then 9 + 6·dy/dx = 0 gives −3/2. The correct equation is 9 + 12·dy/dx = 0.','Drops a factor in the product rule'),
  ('−9','This stops at 12·dy/dx = −9 and does not divide by 12. Dividing gives dy/dx = −9/12 = −3/4.','Does not divide by the coefficient'),
  ('3/4','This has the wrong sign: it moves y² across as 12·dy/dx = +9, giving 3/4. The equation y² + 2xy·dy/dx = 0 gives 12·dy/dx = −9, so dy/dx = −3/4.','Sign error when isolating dy/dx')],
 'Product with y² (needs the chain rule on y) rather than a single power of x.','numeric',
 [(implicit(x*y**2,{x:2,y:3}),None),(R(-9,6),None),(-9,None),(R(9,12),None)])
add(s+'-v2',s,'medium','Implicit slope of x² + xy + y² = 7',
 'The relation x² + xy + y² = 7 holds at the point (2, 1). What is dy/dx at (2, 1)?',
 ('−5/4','Differentiate: 2x + y + x·dy/dx + 2y·dy/dx = 0. At (2, 1): 4 + 1 + 2·dy/dx + 2·dy/dx = 0, so 5 + 4·dy/dx = 0 and dy/dx = −5/4.'),
 [('−1','This differentiates xy as x·dy/dx, leaving out the term y from the product rule. Then 4 + 2·dy/dx + 2·dy/dx = 0 gives −1. The product rule gives y + x·dy/dx, so the equation is 5 + 4·dy/dx = 0.','Omits a product-rule term'),
  ('−7/2','This differentiates y² as 2y without the factor dy/dx. Then 4 + 1 + 2·dy/dx + 2 = 0 gives dy/dx = −7/2. The chain rule gives 2y·dy/dx, so the equation is 5 + 4·dy/dx = 0.','Omits dy/dx on the y² term'),
  ('5/4','This has the wrong sign: from 5 + 4·dy/dx = 0 it takes dy/dx = +5/4. Moving 5 to the other side gives 4·dy/dx = −5, so dy/dx = −5/4.','Sign error when isolating dy/dx')],
 'Three-term relation with a mixed xy term; slope at a lattice point.','numeric',
 [(implicit(x**2+x*y+y**2,{x:2,y:1}),None),(R(-4,4),None),(R(-7,2),None),(R(5,4),None)])
add(s+'-v3',s,'easy','Implicit slope of y·eˣ = 5e',
 'Point P = (1, 5) lies on the graph of the relation y·eˣ = 5e. Determine the slope of the tangent line to the graph at P.',
 ('−5','Differentiate with the product rule: (dy/dx)eˣ + y·eˣ = 0. At (1, 5): e·dy/dx + 5e = 0, so dy/dx = −5.'),
 [('−5e','This stops at e·dy/dx = −5e without dividing by e. Dividing by e gives dy/dx = −5.','Does not divide by the coefficient'),
  ('0','This omits the term y·eˣ from the product rule, leaving (dy/dx)eˣ = 0 and dy/dx = 0. The product rule gives e·dy/dx + 5e = 0, so dy/dx = −5.','Omits a product-rule term'),
  ('5','This has the wrong sign: from e·dy/dx + 5e = 0 it takes dy/dx = +5. Moving 5e across gives e·dy/dx = −5e, so dy/dx = −5.','Sign error when isolating dy/dx')],
 'Exponential factor times y; dividing by e is the final step.','numeric',
 [(implicit(y*sp.exp(x),{x:1,y:5}),None),(-5*E,None),(0,None),(5,None)])

# ---------------- verification
def stmt_value(text):
    tail = text.rsplit('=',1)[1].strip().rstrip('.')
    return parse(tail)
def xset(text):
    if 'no such' in text: return []
    return sorted(parse(m) for m in re.findall(r'x = ([^ ]+)', text.replace(' only','')))
assert len(V)==30
SEEDS={r['key']:r for r in json.load(open('seeds_final.json'))}
fails=0
for v in V:
    choices=[v['correct']]+v['wrong']
    ok=True
    for c,(comp,exp) in zip(choices,v['_vals']):
        text=c['text']
        try:
            if isinstance(comp,list):
                got=xset(text); good = (sorted(sp.nsimplify(q) for q in got)==sorted(sp.nsimplify(q) for q in comp)) and sorted(sp.nsimplify(q) for q in comp)==sorted(sp.nsimplify(q) for q in exp)
            elif v['check']=='conceptual':
                good = same(sp.nsimplify(comp),sp.nsimplify(exp)) and same(stmt_value(text),sp.nsimplify(comp))
            else:
                good = same(parse(text), comp) and (exp is None or same(sp.nsimplify(comp),sp.nsimplify(exp)))
        except Exception as e:
            good=False; print('ERR',v['id'],text,e)
        if not good: ok=False; print('MISMATCH',v['id'],repr(text),comp)
    if not ok: fails+=1
    else: print('OK',v['id'])
# similarity & structure checks
tok=lambda s:set(re.findall(r'\w+',s.lower()))
def bag(stem,ch): return tok(stem+' '+' '.join(ch))
def jac(a,b): return len(a&b)/len(a|b)
mx=0
for v in V:
    sd=SEEDS[v['seed']]
    sb=bag(sd['stem'],[sd['correct']['text']]+[w['text'] for w in sd['wrong']])
    vb=bag(v['stem'],[c['text'] for c in [v['correct']]+v['wrong']])
    j=jac(sb,vb); mx=max(mx,j)
    if j>=0.7: print('JACCARD seed',v['id'],j); fails+=1
    L=len(v['correct']['text']); M=max(len(w['text']) for w in v['wrong'])
    if L>1.4*M and not all(len(w['text'])<=6 for w in v['wrong']): print('LENGTH',v['id'],L,M); fails+=1
    if re.search(r'(^|\n)\s*[A-D][.)]\s',v['stem']): print('LIST IN STEM',v['id']); fails+=1
    texts=[c['text'] for c in [v['correct']]+v['wrong']]
    if len(set(texts))!=4: print('DUP',v['id']); fails+=1
for i in range(0,30,3):
    bs=[bag(V[k]['stem'],[c['text'] for c in [V[k]['correct']]+V[k]['wrong']]) for k in range(i,i+3)]
    for a in range(3):
        for b in range(a+1,3):
            j=jac(bs[a],bs[b]); mx=max(mx,j)
            if j>=0.7: print('JACCARD sib',V[i+a]['id'],V[i+b]['id'],j); fails+=1
print('max jaccard',round(mx,3))
out=[{k:v[k] for k in ['id','seed','difficulty','title','stem','correct','wrong','change_note','check']} for v in V]
json.dump(out,open('variants_c2.json','w'),ensure_ascii=False,indent=1)
print('ALL 30 OK' if fails==0 else f'{fails} PROBLEMS')
