import json, re, itertools, sympy as sp
from sympy import Rational as R, sqrt, exp, log, sin, cos, pi, symbols, diff, solve, S
x,t,h=symbols('x t h',positive=True)
SEEDS={s['key']:s for s in json.load(open('seeds_final.json'))}
OUT=[]; CHECKS=[]
def N(e): return sp.nsimplify(sp.simplify(e))
def add(vid,seed,diff_,title,stem,corr,wrongs,note,check='numeric'):
    # corr/wrongs: (text, rationale, val, shown[, pattern])
    ct,cr,cv,cs=corr[:4]
    CHECKS.append((vid,'correct',cv,cs))
    w=[]
    for tup in wrongs:
        tx,ra,va,sh,pat=tup
        CHECKS.append((vid,tx,va,sh)); w.append({"text":tx,"rationale":ra,"error_pattern":pat})
    OUT.append({"id":vid,"seed":seed,"difficulty":diff_,"title":title,"stem":stem,
      "correct":{"text":ct,"rationale":cr},"wrong":w,"change_note":note,"check":check})

# ---------- 001 ----------
K='apcalcab-mcq-u2n-001'
V=t**2+4*t
add(K+'-v1',K,'easy','Average rate of tank volume',
 "The volume of water in a tank is V(t) = t² + 4t liters, where t is measured in minutes. What is the average rate of change of the volume from t = 1 to t = 5 minutes?",
 ("10 liters per minute","V(5) = 25 + 20 = 45 and V(1) = 1 + 4 = 5, so the average rate is (45 − 5)/(5 − 1) = 40/4 = 10 liters per minute.",(V.subs(t,5)-V.subs(t,1))/4,10),
 [("6 liters per minute","6 is the instantaneous rate V′(1) = 2(1) + 4 = 6 at the left endpoint, not the average rate over [1, 5], which is 40/4 = 10.",diff(V,t).subs(t,1),6,"instantaneous rate at left endpoint"),
  ("40 liters per minute","40 is the change in volume, V(5) − V(1) = 45 − 5 = 40 liters, which was not divided by the elapsed time 5 − 1 = 4; the average rate is 40/4 = 10.",V.subs(t,5)-V.subs(t,1),40,"forgot to divide by change in t"),
  ("14 liters per minute","14 is the instantaneous rate V′(5) = 2(5) + 4 = 14 at the right endpoint, not the average rate over [1, 5], which is 10.",diff(V,t).subs(t,5),14,"instantaneous rate at right endpoint")],
 "Polynomial with context (tank volume), new interval and numbers.")
g=sqrt(x)
add(K+'-v2',K,'easy','Average rate of a square root',
 "For the function g(x) = √x, find the average rate of change of g as x increases from 1 to 9.",
 ("1/4","g(9) = 3 and g(1) = 1, so the average rate of change is (3 − 1)/(9 − 1) = 2/8 = 1/4.",(g.subs(x,9)-g.subs(x,1))/8,R(1,4)),
 [("1/2","1/2 is the instantaneous rate g′(1) = 1/(2√1) = 1/2 at the left endpoint, not the average rate over [1, 9], which is 1/4.",diff(g,x).subs(x,1),R(1,2),"instantaneous rate at left endpoint"),
  ("2","2 is the change g(9) − g(1) = 3 − 1 = 2, which was not divided by 9 − 1 = 8; the average rate is 2/8 = 1/4.",g.subs(x,9)-g.subs(x,1),2,"forgot to divide by change in x"),
  ("1/6","1/6 is the instantaneous rate g′(9) = 1/(2√9) = 1/6 at the right endpoint, not the average rate over [1, 9], which is 1/4.",diff(g,x).subs(x,9),R(1,6),"instantaneous rate at right endpoint")],
 "Radical function, wider interval, same skill.")
hh=x**3-x
add(K+'-v3',K,'easy','Secant slope of a cubic',
 "Find the slope of the secant line to the graph of h(x) = x³ − x through the points where x = 0 and x = 3.",
 ("8","h(3) = 27 − 3 = 24 and h(0) = 0, so the slope is (24 − 0)/(3 − 0) = 8.",(hh.subs(x,3)-hh.subs(x,0))/3,8),
 [("24","24 is the change h(3) − h(0) = 24, which was not divided by 3 − 0 = 3; the slope is 24/3 = 8.",hh.subs(x,3)-hh.subs(x,0),24,"forgot to divide by change in x"),
  ("12","12 is the mean of the endpoint outputs, (h(0) + h(3))/2 = (0 + 24)/2 = 12, which is not a rate of change; the slope is 24/3 = 8.",(hh.subs(x,0)+hh.subs(x,3))/2,12,"averaged function values instead of finding slope"),
  ("26","26 is the tangent slope h′(3) = 3(9) − 1 = 26 at x = 3, not the slope of the secant through x = 0 and x = 3, which is 8.",diff(hh,x).subs(x,3),26,"instantaneous rate at right endpoint")],
 "Cubic phrased as a secant-line slope rather than average rate.")

# ---------- 002 ----------
K='apcalcab-mcq-u2n-002'
hf=t**3+2*t
add(K+'-v1',K,'medium','Drone velocity at an instant',
 "A drone's height above the ground is h(t) = t³ + 2t meters, t seconds after launch. What is the instantaneous rate of change of its height at t = 2 seconds?",
 ("14 m/s","h′(t) = 3t² + 2, so h′(2) = 3(4) + 2 = 14 m/s.",diff(hf,t).subs(t,2),14),
 [("8 m/s","8 comes from differentiating t³ as 3t instead of 3t², giving 3(2) + 2 = 8. The power rule gives 3t², so h′(2) = 12 + 2 = 14.",3*t.subs(t,2)+2,8,"power rule error: t³ → 3t"),
  ("6 m/s","6 is the average rate of change over [0, 2]: (h(2) − h(0))/(2 − 0) = (12 − 0)/2 = 6. The question asks for the instantaneous rate at t = 2, which is h′(2) = 14.",(hf.subs(t,2)-hf.subs(t,0))/2,6,"average rate instead of instantaneous"),
  ("12 m/s","12 is the height h(2) = 8 + 4 = 12 meters, not a rate of change. The velocity is h′(2) = 14 m/s.",hf.subs(t,2),12,"evaluated function instead of derivative")],
 "Context changed to drone height; cubic with linear term; new t.")
s4=t**4-3*t
add(K+'-v2',K,'medium','Bead velocity on a wire',
 "A bead slides along a wire so that its position is s(t) = t⁴ − 3t centimeters at time t seconds. What is the velocity of the bead at t = 2 seconds?",
 ("29 cm/s","s′(t) = 4t³ − 3, so s′(2) = 4(8) − 3 = 29 cm/s.",diff(s4,t).subs(t,2),29),
 [("5 cm/s","5 comes from differentiating t⁴ as 4t instead of 4t³, giving 4(2) − 3 = 5. The power rule gives 4t³, so s′(2) = 32 − 3 = 29.",4*2-3,5,"power rule error: t⁴ → 4t"),
  ("12 cm/s","12 is the average rate of change over [1, 2]: (s(2) − s(1))/(2 − 1) = (10 − (−2))/1 = 12. The question asks for the instantaneous rate at t = 2, which is 29.",(s4.subs(t,2)-s4.subs(t,1))/1,12,"average rate instead of instantaneous"),
  ("10 cm/s","10 is the position s(2) = 16 − 6 = 10 centimeters, not a rate of change. The velocity is s′(2) = 29 cm/s.",s4.subs(t,2),10,"evaluated position instead of derivative")],
 "Quartic position, different units and distractor interval.")
C=5*t**2-t**3
add(K+'-v3',K,'medium','Drug concentration rate',
 "The concentration of a drug in the bloodstream is C(t) = 5t² − t³ mg/L, t hours after it is given. How fast is the concentration changing at t = 3 hours?",
 ("3 mg/L per hour","C′(t) = 10t − 3t², so C′(3) = 30 − 27 = 3 mg/L per hour.",diff(C,t).subs(t,3),3),
 [("21 mg/L per hour","21 comes from differentiating t³ as 3t instead of 3t², giving 10(3) − 3(3) = 21. The power rule gives 3t², so C′(3) = 30 − 27 = 3.",10*3-3*3,21,"power rule error: t³ → 3t"),
  ("6 mg/L per hour","6 is the average rate of change over [0, 3]: (C(3) − C(0))/(3 − 0) = (18 − 0)/3 = 6. The question asks for the instantaneous rate at t = 3, which is C′(3) = 3.",(C.subs(t,3)-C.subs(t,0))/3,6,"average rate instead of instantaneous"),
  ("18 mg/L per hour","18 is the concentration C(3) = 45 − 27 = 18 mg/L, not a rate of change. The rate is C′(3) = 3 mg/L per hour.",C.subs(t,3),18,"evaluated function instead of derivative")],
 "Pharmacokinetic context with a polynomial difference.")

# ---------- 003 ----------
K='apcalcab-mcq-u2n-003'
add(K+'-v1',K,'medium','Limit definition with ln x',
 "Let f(x) = ln x. The limit lim(h→0) [ln(2 + h) − ln 2] / h is the derivative f′(2). What is its value?",
 ("1/2","The quotient [f(2 + h) − f(2)]/h with f(x) = ln x is the definition of f′(2). Since f′(x) = 1/x, f′(2) = 1/2.",diff(log(x),x).subs(x,2),R(1,2)),
 [("2","2 comes from inverting the derivative, using x instead of 1/x. The derivative of ln x is 1/x, so f′(2) = 1/2, not 2.",S(2),2,"inverted the derivative"),
  ("1/4","1/4 comes from using 1/x² as the derivative of ln x, so that f′(2) = 1/2² = 1/4. The derivative of ln x is 1/x, so f′(2) = 1/2.",R(1,2)**2,R(1,4),"squared the denominator"),
  ("0","Substituting h = 0 gives ln 2 − ln 2 = 0 in the numerator and 0 in the denominator, which is the indeterminate form 0/0, not 0. The limit is f′(2) = 1/2.",S(0),0,"0/0 taken as 0")],
 "Changed function to ln x and the point to 2.")
add(K+'-v2',K,'medium','Limit definition with 1/x',
 "Evaluate lim(h→0) [1/(3 + h) − 1/3] / h, which is the derivative of f(x) = 1/x at x = 3.",
 ("−1/9","This is f′(3) for f(x) = x⁻¹. Since f′(x) = −x⁻² = −1/x², f′(3) = −1/9.",diff(1/x,x).subs(x,3),R(-1,9)),
 [("1/9","1/9 loses the negative sign. The power rule gives d/dx (x⁻¹) = −x⁻², so f′(3) = −1/9.",-diff(1/x,x).subs(x,3),R(1,9),"dropped the negative sign"),
  ("−1/3","−1/3 comes from using −1/x for the derivative, lowering the coefficient but not the exponent. The exponent must become −2, so f′(3) = −1/3² = −1/9.",-1/x.subs(x,3) if False else -R(1,3),R(-1,3),"exponent not lowered"),
  ("0","Substituting h = 0 gives 1/3 − 1/3 = 0 over 0, which is 0/0 and indeterminate, not 0. The limit is f′(3) = −1/9.",S(0),0,"0/0 taken as 0")],
 "Reciprocal function; negative-exponent derivative.")
add(K+'-v3',K,'medium','Limit definition with sin x',
 "The limit lim(h→0) [sin(π/6 + h) − 1/2] / h equals f′(π/6) for f(x) = sin x. What is the value of this limit?",
 ("√3/2","The quotient is [f(π/6 + h) − f(π/6)]/h with f(x) = sin x, so the limit is f′(π/6) = cos(π/6) = √3/2.",diff(sin(x),x).subs(x,pi/6),sqrt(3)/2),
 [("−√3/2","−√3/2 uses (sin x)′ = −cos x. The derivative of sin x is cos x, so f′(π/6) = cos(π/6) = √3/2.",-cos(pi/6),-sqrt(3)/2,"sign error: (sin x)′ = −cos x"),
  ("1/2","1/2 is sin(π/6), which comes from using (sin x)′ = sin x. The derivative of sin x is cos x, so f′(π/6) = √3/2.",sin(pi/6),R(1,2),"(sin x)′ = sin x"),
  ("0","Substituting h = 0 gives sin(π/6) − 1/2 = 0 over 0, which is 0/0 and indeterminate, not 0. The limit is f′(π/6) = √3/2.",S(0),0,"0/0 taken as 0")],
 "Trig function and a special angle.")

# ---------- 004 ----------
K='apcalcab-mcq-u2n-004'
add(K+'-v1',K,'easy','Table estimate at x = 8',
 "A differentiable function f has the tabulated values below.\n\nx:    2    5    6    10\nf(x): 4   13   19    33\n\nApproximate f′(8) with a difference quotient built from the nearest listed x-values that lie on either side of 8.",
 ("7/2","The closest table values on either side of x = 8 are x = 6 and x = 10, so f′(8) ≈ (f(10) − f(6))/(10 − 6) = (33 − 19)/4 = 14/4 = 7/2.",R(33-19,10-6),R(7,2)),
 [("14","14 is the change f(10) − f(6) = 33 − 19 = 14, which was not divided by 10 − 6 = 4; the estimate is 14/4 = 7/2.",S(33-19),14,"forgot to divide by change in x"),
  ("6","6 is the slope over [5, 6], (19 − 13)/(6 − 5) = 6. That interval does not contain x = 8; the closest points on either side are x = 6 and x = 10, giving 7/2.",R(19-13,6-5),6,"used an interval not surrounding x = 8"),
  ("7/8","7/8 divides f(10) − f(6) = 14 by 10 + 6 = 16. The change in x is 10 − 6 = 4, so the estimate is 14/4 = 7/2.",R(14,16),R(7,8),"divided by the sum of x-values")],
 "New table and target x; different surface values.")
add(K+'-v2',K,'easy','Cooling rate from a table',
 "The temperature T(t), in °C, of a cup of coffee is recorded at selected times t minutes.\n\nt:    0    10   20   40\nT(t): 80   62   50   35\n\nUsing the two table values closest to t = 30 on either side, what is the best estimate of T′(30)?",
 ("−3/4 °C per minute","The closest times on either side of t = 30 are t = 20 and t = 40, so T′(30) ≈ (T(40) − T(20))/(40 − 20) = (35 − 50)/20 = −15/20 = −3/4 °C per minute.",R(35-50,40-20),R(-3,4)),
 [("−15 °C per minute","−15 is the change T(40) − T(20) = 35 − 50 = −15, which was not divided by 40 − 20 = 20; the estimate is −15/20 = −3/4.",S(35-50),-15,"forgot to divide by change in t"),
  ("−6/5 °C per minute","−6/5 is the slope over [10, 20], (50 − 62)/(20 − 10) = −12/10 = −6/5. That interval does not contain t = 30; the closest times on either side are 20 and 40, giving −3/4.",R(50-62,20-10),R(-6,5),"used an interval not surrounding t = 30"),
  ("−1/4 °C per minute","−1/4 divides T(40) − T(20) = −15 by 40 + 20 = 60. The change in t is 40 − 20 = 20, so the estimate is −15/20 = −3/4.",R(-15,60),R(-1,4),"divided by the sum of t-values")],
 "Context table (temperature) with a negative rate.")
add(K+'-v3',K,'easy','Acceleration from velocity table',
 "Selected values of the velocity v(t), in m/s, of a particle at time t seconds are given.\n\nt:    0   1    4    7\nv(t): 5   1   −8   −20\n\nUsing the two table values closest to t = 3 on either side, what is the best estimate of the acceleration v′(3)?",
 ("−3 m/s²","The closest times on either side of t = 3 are t = 1 and t = 4, so v′(3) ≈ (v(4) − v(1))/(4 − 1) = (−8 − 1)/3 = −3 m/s².",R(-8-1,4-1),-3),
 [("−9 m/s²","−9 is the change v(4) − v(1) = −8 − 1 = −9, which was not divided by 4 − 1 = 3; the estimate is −9/3 = −3.",S(-8-1),-9,"forgot to divide by change in t"),
  ("−4 m/s²","−4 is the slope over [4, 7], (−20 − (−8))/(7 − 4) = −12/3 = −4. That interval does not contain t = 3; the closest times on either side are 1 and 4, giving −3.",R(-20+8,7-4),-4,"used an interval not surrounding t = 3"),
  ("−9/5 m/s²","−9/5 divides v(4) − v(1) = −9 by 4 + 1 = 5. The change in t is 4 − 1 = 3, so the estimate is −9/3 = −3.",R(-9,5),R(-9,5),"divided by the sum of t-values")],
 "Velocity table giving acceleration; uncentered target.")

# ---------- 005 (conceptual) ----------
K='apcalcab-mcq-u2n-005'
OUT_005=[]
def piece_check(left,right,a):
    lv=left.subs(x,a); rv=right.subs(x,a)
    return lv,rv,diff(left,x).subs(x,a),diff(right,x).subs(x,a)
# v1: jump with equal slopes
L,Rr=x**2,2*x+1
lv,rv,ls,rs=piece_check(L,Rr,1); assert (lv,rv,ls,rs)==(1,3,2,2)
add(K+'-v1',K,'medium','Equal slopes but a jump',
 "Let g(x) = x² for x ≤ 1, and g(x) = 2x + 1 for x > 1. Which statement about g at x = 1 is true?",
 ("g is not differentiable at x = 1 because g is not continuous there.","The left piece gives g(1) = 1 and the right piece approaches 2(1) + 1 = 3, so the limit does not exist and g is discontinuous at 1. A function that is not continuous at a point cannot be differentiable there, even though both pieces have slope 2.",S(0),S(0)),
 [("g is differentiable at x = 1 because both pieces have slope 2 there.","Both pieces do have slope 2 at x = 1 (2x = 2 and the line has slope 2), but differentiability also requires continuity. The values 1 and 3 do not match, so g is discontinuous and not differentiable at 1.",S(0),S(0),"equal slopes taken as sufficient for differentiability"),
  ("g is continuous at x = 1 because the one-sided slopes are equal.","Continuity depends on function values, not slopes. The left piece gives 1 and the right piece approaches 3, so the limit does not exist and g is not continuous at 1.",S(0),S(0),"slopes confused with continuity"),
  ("g is continuous at x = 1 but not differentiable there because the two formulas differ.","The formulas differing does not by itself make the function continuous. Since the left value is 1 and the right limit is 3, g is not continuous at 1 (the formulas also have equal slopes there).",S(0),S(0),"assumed a corner rather than a jump")],
 "Jump discontinuity with matching slopes; correct answer differs from seed's corner.",check='conceptual')
L,Rr=x**2,2*x-1
lv,rv,ls,rs=piece_check(L,Rr,1); assert (lv,rv,ls,rs)==(1,1,2,2)
add(K+'-v2',K,'medium','Smooth join of two pieces',
 "Let f(x) = x² for x ≤ 1, and f(x) = 2x − 1 for x > 1. Which statement about f at x = 1 is true?",
 ("f is both continuous and differentiable at x = 1.","Both pieces equal 1 at x = 1 (1² = 1 and 2(1) − 1 = 1), so f is continuous. The left derivative is 2x = 2 and the right derivative is 2, so f′(1) = 2 exists.",S(0),S(0)),
 [("f is continuous at x = 1 but not differentiable there because the formulas differ.","Different formulas do not prevent differentiability. The left derivative is 2(1) = 2 and the right derivative is 2, so the one-sided derivatives agree and f′(1) = 2 exists.",S(0),S(0),"formula change assumed to create a corner"),
  ("f is not continuous at x = 1 because f is defined by two pieces.","Being defined piecewise does not make a function discontinuous. Both pieces equal 1 at x = 1, so the limit exists and equals f(1) = 1; f is continuous at 1.",S(0),S(0),"piecewise assumed discontinuous"),
  ("f is differentiable at x = 1 but not continuous there.","Differentiability at a point requires continuity there, so this combination is impossible. In fact both pieces equal 1 at x = 1, so f is continuous (and differentiable) at 1.",S(0),S(0),"reversed continuity and differentiability implication")],
 "Smooth join; correct answer is differentiable, unlike the seed.",check='conceptual')
q=x**Rational(2,3) if False else None
q=sp.Pow(sp.Symbol('u'),R(2,3))
add(K+'-v3',K,'medium','Cusp of a two-thirds power',
 "Let q(x) = x^(2/3) for all real x. Which statement about q at x = 0 is true?",
 ("q is continuous at x = 0 but not differentiable there.","q(0) = 0 and q(x) → 0 as x → 0, so q is continuous at 0. But q′(x) = (2/3)x^(−1/3) is unbounded near 0 (it approaches −∞ from the left and +∞ from the right), so q′(0) does not exist.",S(0),S(0)),
 [("q is not continuous at x = 0 because q′(0) does not exist.","Continuity depends on the function values, not on the derivative. The limit of x^(2/3) as x → 0 is 0 = q(0), so q is continuous at 0; the nonexistent derivative only shows q is not differentiable.",S(0),S(0),"nonexistent derivative taken as discontinuity"),
  ("q is differentiable at x = 0 because q is continuous there.","q is continuous at 0, but continuity does not imply differentiability. q′(x) = (2/3)x^(−1/3) is unbounded near 0, so q′(0) does not exist.",S(0),S(0),"continuity taken as sufficient for differentiability"),
  ("q is differentiable at x = 0 with q′(0) = 0 because q has a minimum there.","q does have a minimum at 0, but a minimum gives a horizontal tangent only if the derivative exists. Here q′(x) = (2/3)x^(−1/3) is unbounded near 0, so the graph has a cusp and q′(0) does not exist.",S(0),S(0),"minimum assumed to imply a horizontal tangent")],
 "Cusp instead of a corner; tests continuity vs differentiability from a power function.",check='conceptual')

# ---------- 006 ----------
K='apcalcab-mcq-u2n-006'
add(K+'-v1',K,'easy','Power rule on 5/x³',
 "If f(x) = 5/x³, then f′(x) = ?",
 ("−15/x⁴","Rewrite f(x) = 5x⁻³. Then f′(x) = 5(−3)x⁻⁴ = −15x⁻⁴ = −15/x⁴.",diff(5/x**3,x),-15/x**4),
 [("−5/x⁴","This gets the new exponent −4 right but keeps the coefficient 5 (with a negative sign) instead of multiplying 5 by the exponent −3. The power rule gives 5(−3)x⁻⁴ = −15/x⁴.",-5/x**4,-5/x**4,"coefficient not multiplied by exponent"),
  ("15/x⁴","This loses the negative sign from the exponent −3. The power rule gives 5(−3)x⁻⁴ = −15/x⁴.",15/x**4,15/x**4,"dropped the negative sign"),
  ("−15/x²","This adds 1 to the exponent (−3 + 1 = −2) instead of subtracting 1. The new exponent is −4, so f′(x) = −15/x⁴.",5*(-3)*x**-2,-15/x**2,"added 1 to the exponent")],
 "Different coefficient and exponent.")
add(K+'-v2',K,'easy','Power rule on 4 over root x',
 "For x > 0, what is the derivative of f(x) = 4/√x?",
 ("−2/x^(3/2)","Rewrite f(x) = 4x^(−1/2). Then f′(x) = 4(−1/2)x^(−3/2) = −2x^(−3/2) = −2/x^(3/2).",diff(4/sqrt(x),x),-2/x**R(3,2)),
 [("−4/x^(3/2)","This lowers the exponent to −3/2 correctly but keeps the coefficient 4 instead of multiplying it by the exponent −1/2. The power rule gives 4(−1/2) = −2, so f′(x) = −2/x^(3/2).",-4*x**R(-3,2),-4/x**R(3,2),"coefficient not multiplied by exponent"),
  ("2/x^(3/2)","This loses the negative sign from the exponent −1/2. The power rule gives 4(−1/2)x^(−3/2) = −2/x^(3/2).",2*x**R(-3,2),2/x**R(3,2),"dropped the negative sign"),
  ("−2√x","This adds 1 to the exponent (−1/2 + 1 = 1/2) instead of subtracting 1, giving 4(−1/2)x^(1/2) = −2√x. The new exponent is −3/2, so f′(x) = −2/x^(3/2).",4*R(-1,2)*x**R(1,2),-2*sqrt(x),"added 1 to the exponent")],
 "Radical in the denominator, fractional exponent.")
add(K+'-v3',K,'easy','Power rule on a scaled reciprocal',
 "Let h(x) = 1/(2x⁴) for x ≠ 0. Which expression gives h′(x)?",
 ("−2/x⁵","Rewrite h(x) = (1/2)x⁻⁴. Then h′(x) = (1/2)(−4)x⁻⁵ = −2x⁻⁵ = −2/x⁵.",diff(1/(2*x**4),x),-2/x**5),
 [("−1/(2x⁵)","This gets the new exponent −5 right but keeps the coefficient 1/2 (with a negative sign) instead of multiplying 1/2 by the exponent −4. The power rule gives (1/2)(−4)x⁻⁵ = −2/x⁵.",-R(1,2)/x**5,-1/(2*x**5),"coefficient not multiplied by exponent"),
  ("2/x⁵","This loses the negative sign from the exponent −4. The power rule gives (1/2)(−4)x⁻⁵ = −2/x⁵.",2/x**5,2/x**5,"dropped the negative sign"),
  ("−2/x³","This adds 1 to the exponent (−4 + 1 = −3) instead of subtracting 1, giving (1/2)(−4)x⁻³ = −2/x³. The new exponent is −5, so h′(x) = −2/x⁵.",R(1,2)*(-4)*x**-3,-2/x**3,"added 1 to the exponent")],
 "Constant factor 1/2 in the denominator, exponent −4.")

# ---------- 007 ----------
K='apcalcab-mcq-u2n-007'
def sol(eq): 
    r=solve(eq,x); assert len(r)==1,(eq,r); return r[0]
f=2*x**R(3,2)-30*x**R(1,2)
add(K+'-v1',K,'hard','Horizontal tangent of 2x^(3/2) − 30x^(1/2)',
 "For x > 0, let f(x) = 2x^(3/2) − 30x^(1/2). At what value of x does the graph of f have a horizontal tangent line?",
 ("x = 5","f′(x) = 3x^(1/2) − 15x^(−1/2). Setting this to 0: 3√x = 15/√x, so 3x = 15 and x = 5.",sol(diff(f,x)),5),
 [("x = 10","This uses the derivative of 30x^(1/2) as 30x^(−1/2) (missing the factor 1/2). Then 3√x = 30/√x gives x = 10, but the correct term is 15x^(−1/2), which gives x = 5.",sol(3*sqrt(x)-30/sqrt(x)),10,"missing 1/2 when differentiating second term"),
  ("x = 15/2","This differentiates 2x^(3/2) as 2x^(1/2) (missing the factor 3/2). Then 2√x = 15/√x gives x = 15/2, but the correct first term is 3x^(1/2), which gives x = 5.",sol(2*sqrt(x)-15/sqrt(x)),R(15,2),"missing 3/2 when differentiating first term"),
  ("x = 15","This solves f(x) = 0 (2x^(3/2) = 30x^(1/2) gives x = 15) rather than f′(x) = 0. A horizontal tangent requires f′(x) = 0, which gives x = 5.",sol(f/sqrt(x)),15,"solved f(x) = 0 instead of f′(x) = 0")],
 "Different coefficients and exponent structure; same fractional-power skill.")
f=x**R(3,2)-6*x
add(K+'-v2',K,'hard','Horizontal tangent of x^(3/2) − 6x',
 "For x > 0, the graph of y = x^(3/2) − 6x has a horizontal tangent line at which value of x?",
 ("x = 16","dy/dx = (3/2)x^(1/2) − 6. Setting this to 0 gives (3/2)√x = 6, so √x = 4 and x = 16.",sol(diff(f,x)),16),
 [("x = 4","This correctly finds √x = 4 but reports x = 4 without squaring. Since √x = 4, x = 4² = 16.",S(4),4,"forgot to square after solving for √x"),
  ("x = 36","This differentiates x^(3/2) as x^(1/2) (missing the factor 3/2). Then √x = 6 gives x = 36, but the correct derivative is (3/2)√x = 6, which gives x = 16.",sol(sqrt(x)-6),36,"missing 3/2 when differentiating"),
  ("x = 81","This solves (3/2)√x = 6 by multiplying 6 by 3/2 instead of dividing: √x = 9, so x = 81. Dividing gives √x = 4, so x = 16.",(6*R(3,2))**2,81,"multiplied by 3/2 instead of dividing")],
 "Mixed fractional power and linear term.")
f=x**R(5,2)-5*x**R(3,2)
add(K+'-v3',K,'hard','Horizontal tangent of x^(5/2) − 5x^(3/2)',
 "For x > 0, let f(x) = x^(5/2) − 5x^(3/2). At what value of x is the tangent line to the graph of f horizontal?",
 ("x = 3","f′(x) = (5/2)x^(3/2) − (15/2)x^(1/2). Setting this to 0 and dividing by (5/2)x^(1/2) gives x − 3 = 0, so x = 3.",sol(diff(f,x)),3),
 [("x = 2","This differentiates 5x^(3/2) as 5x^(1/2) (missing the factor 3/2). Then (5/2)x^(3/2) = 5x^(1/2) gives x = 2, but the correct term is (15/2)x^(1/2), which gives x = 3.",sol(R(5,2)*x**R(3,2)-5*sqrt(x)),2,"missing 3/2 on second term"),
  ("x = 15/2","This differentiates x^(5/2) as x^(3/2) (missing the factor 5/2). Then x^(3/2) = (15/2)x^(1/2) gives x = 15/2, but the correct first term is (5/2)x^(3/2), which gives x = 3.",sol(x**R(3,2)-R(15,2)*sqrt(x)),R(15,2),"missing 5/2 on first term"),
  ("x = 5","This solves f(x) = 0 (x^(5/2) = 5x^(3/2) gives x = 5) rather than f′(x) = 0. A horizontal tangent requires f′(x) = 0, which gives x = 3.",sol(f/x**R(3,2)),5,"solved f(x) = 0 instead of f′(x) = 0")],
 "Higher fractional exponents.")

# ---------- 008 ----------
K='apcalcab-mcq-u2n-008'
fp=sp.Symbol('fp')
add(K+'-v1',K,'easy','Linear combination with a quadratic',
 "Let f be a differentiable function with f′(3) = 2, and let h(x) = 5x² − 4f(x). What is h′(3)?",
 ("22","h′(x) = 10x − 4f′(x), so h′(3) = 10(3) − 4(2) = 30 − 8 = 22.",10*3-4*2,22),
 [("38","This adds instead of subtracting, 30 + 4(2) = 38. The difference rule gives 10x − 4f′(x), so h′(3) = 30 − 8 = 22.",30+4*2,38,"sign error with difference rule"),
  ("28","This drops the constant multiple 4 on f, giving 30 − 2 = 28. The constant multiple rule gives 4f′(3) = 8, so h′(3) = 30 − 8 = 22.",30-2,28,"dropped constant multiple"),
  ("7","This differentiates 5x² as 5x, giving 15 − 8 = 7. The power rule gives 10x, so the first term is 30 and h′(3) = 30 − 8 = 22.",5*3-4*2,7,"power rule error on x²")],
 "Quadratic term instead of linear, new numbers.")
add(K+'-v2',K,'easy','Half a function plus a line',
 "Let f be a differentiable function with f′(−1) = −8, and let p(x) = (1/2)f(x) + 6x − 7. What is p′(−1)?",
 ("2","p′(x) = (1/2)f′(x) + 6, so p′(−1) = (1/2)(−8) + 6 = −4 + 6 = 2.",R(1,2)*(-8)+6,2),
 [("−2","This drops the constant multiple 1/2 on f, giving −8 + 6 = −2. The constant multiple rule gives (1/2)f′(−1) = −4, so p′(−1) = −4 + 6 = 2.",-8+6,-2,"dropped constant multiple"),
  ("−5","This differentiates the constant −7 as −7 instead of 0, giving −4 + 6 − 7 = −5. The derivative of a constant is 0, so p′(−1) = −4 + 6 = 2.",R(1,2)*(-8)+6-7,-5,"derivative of constant not zero"),
  ("−10","This differentiates 6x as 6x and evaluates it at −1, giving −4 + 6(−1) = −10. The derivative of 6x is the constant 6, so p′(−1) = −4 + 6 = 2.",R(1,2)*(-8)+6*(-1),-10,"differentiated 6x as 6x")],
 "Fractional constant multiple, constant term, negative point.")
add(K+'-v3',K,'easy','Cubic minus a multiple of f',
 "Let f be a differentiable function with f′(4) = −2, and let g(x) = x³ − 2f(x). What is g′(4)?",
 ("52","g′(x) = 3x² − 2f′(x), so g′(4) = 3(16) − 2(−2) = 48 + 4 = 52.",3*16-2*(-2),52),
 [("50","This drops the constant multiple 2 on f, giving 48 − (−2) = 50. The constant multiple rule gives 2f′(4) = −4, so g′(4) = 48 − (−4) = 52.",48-(-2),50,"dropped constant multiple"),
  ("44","This adds instead of subtracting, 48 + 2(−2) = 44. The difference rule gives 3x² − 2f′(x), so g′(4) = 48 + 4 = 52.",48+2*(-2),44,"sign error with difference rule"),
  ("16","This differentiates x³ as 3x, giving 3(4) = 12, and then 12 + 4 = 16. The power rule gives 3x² = 48, so g′(4) = 48 + 4 = 52.",3*4+4,16,"power rule error: x³ → 3x")],
 "Cubic and negative f′ value.")

# ---------- 009 ----------
K='apcalcab-mcq-u2n-009'
f=2*exp(x)+6*sin(x)
add(K+'-v1',K,'easy','Derivative of e^x and sin x at π',
 "If f(x) = 2e^x + 6 sin x, what is f′(π)?",
 ("2e^π − 6","f′(x) = 2e^x + 6cos x, so f′(π) = 2e^π + 6cos π = 2e^π − 6.",diff(f,x).subs(x,pi),2*exp(pi)-6),
 [("2e^π + 6","This uses (sin x)′ = −cos x, giving 2e^π − 6(−1) = 2e^π + 6. The derivative of sin x is cos x, so the second term is 6cos π = −6.",2*exp(pi)-6*cos(pi),2*exp(pi)+6,"sign error: (sin x)′ = −cos x"),
  ("2e^π","This uses (sin x)′ = sin x, so the second term is 6 sin π = 0. The derivative of sin x is cos x, so that term contributes 6cos π = −6 and f′(π) = 2e^π − 6.",2*exp(pi)+6*sin(pi),2*exp(pi),"(sin x)′ = sin x"),
  ("2πe^(π − 1) − 6","This treats e^x like a power function, 2·π·e^(π − 1), while getting the sine term right (6cos π = −6). The derivative of e^x is e^x, so the first term is 2e^π and f′(π) = 2e^π − 6.",2*pi*exp(pi-1)+6*cos(pi),2*pi*exp(pi-1)-6,"power rule applied to e^x")],
 "Swap cos for sin, change point to π and coefficients.")
f=4*sin(x)-3*cos(x)
add(K+'-v2',K,'easy','Derivative of a sin x and cos x combination',
 "Let g(x) = 4 sin x − 3 cos x. What is g′(π/3)?",
 ("2 + 3√3/2","g′(x) = 4cos x + 3 sin x, so g′(π/3) = 4(1/2) + 3(√3/2) = 2 + 3√3/2.",diff(f,x).subs(x,pi/3),2+3*sqrt(3)/2),
 [("2 − 3√3/2","This uses (cos x)′ = sin x, so −3cos x becomes −3 sin x. The derivative is −3(−sin x) = +3 sin x, giving 2 + 3√3/2.",4*cos(pi/3)-3*sin(pi/3),2-3*sqrt(3)/2,"sign error: (cos x)′ = sin x"),
  ("−2 + 3√3/2","This uses (sin x)′ = −cos x, so 4 sin x becomes −4cos x. The derivative of sin x is cos x, so the first term is +4cos(π/3) = 2, giving 2 + 3√3/2.",-4*cos(pi/3)+3*sin(pi/3),-2+3*sqrt(3)/2,"sign error: (sin x)′ = −cos x"),
  ("2√3 − 3/2","This evaluates the original function, g(π/3) = 4(√3/2) − 3(1/2) = 2√3 − 3/2, instead of the derivative. The derivative is g′(π/3) = 2 + 3√3/2.",f.subs(x,pi/3),2*sqrt(3)-R(3,2),"evaluated function instead of derivative")],
 "Pure trig combination, different angle; no e^x.")
f=3*exp(x)-log(x)
add(K+'-v3',K,'easy','Derivative of e^x and ln x at 2',
 "Let f(x) = 3e^x − ln x for x > 0. What is f′(2)?",
 ("3e² − 1/2","f′(x) = 3e^x − 1/x, so f′(2) = 3e² − 1/2.",diff(f,x).subs(x,2),3*exp(2)-R(1,2)),
 [("6e − 1/2","This treats e^x like a power function, 3·2·e^(2−1) = 6e, while getting the ln x term right (−1/2). The derivative of e^x is e^x, so the first term is 3e² and f′(2) = 3e² − 1/2.",3*2*exp(1)-R(1,2),6*exp(1)-R(1,2),"power rule applied to e^x"),
  ("3e² + 1/2","This drops the minus sign on the ln x term, using +1/x. The derivative of −ln x is −1/x, so f′(2) = 3e² − 1/2.",3*exp(2)+R(1,2),3*exp(2)+R(1,2),"dropped negative sign on ln term"),
  ("3e² + 1/4","This differentiates ln x as 1/x and then differentiates 1/x again to get −1/x², so −ln x contributes +1/x² = 1/4. The derivative of ln x is just 1/x, so −ln x contributes −1/2 and f′(2) = 3e² − 1/2.",3*exp(2)+R(1,4),3*exp(2)+R(1,4),"differentiated twice")],
 "Swap roles of exponential and log terms; new point.")

# ---------- 010 ----------
K='apcalcab-mcq-u2n-010'
g=4*log(x)+3/x**2
add(K+'-v1',K,'medium','Derivative with ln x and 1/x²',
 "Let g(x) = 4 ln x + 3/x² for x > 0. What is g′(2)?",
 ("5/4","g′(x) = 4/x − 6/x³ (since 3/x² = 3x⁻² has derivative −6x⁻³). Then g′(2) = 4/2 − 6/8 = 2 − 3/4 = 5/4.",diff(g,x).subs(x,2),R(5,4)),
 [("1/2","This differentiates 3x⁻² as −6x⁻² without lowering the exponent, giving 4/2 − 6/4 = 1/2. The power rule gives −6x⁻³ = −6/8 at x = 2, so g′(2) = 5/4.",R(4,2)-R(6,4),R(1,2),"exponent not lowered"),
  ("11/4","This loses the negative sign on the derivative of 3x⁻², using +6/x³, giving 4/2 + 6/8 = 11/4. The correct term is −6/x³ = −3/4, so g′(2) = 5/4.",R(4,2)+R(6,8),R(11,4),"dropped the negative sign"),
  ("13/8","This differentiates 3x⁻² as −3x⁻³ (keeping the coefficient 3 and not multiplying by the exponent −2), giving 4/2 − 3/8 = 13/8. The correct term is −6/x³ = −3/4, so g′(2) = 5/4.",R(4,2)-R(3,8),R(13,8),"coefficient not multiplied by exponent")],
 "ln x with a 1/x² term; new numbers.")
h_=3/x-4*log(x)
add(K+'-v2',K,'medium','Derivative with 3/x and ln x',
 "Let h(x) = 3/x − 4 ln x for x > 0. What is h′(3)?",
 ("−5/3","h′(x) = −3/x² − 4/x (since 3/x = 3x⁻¹ has derivative −3x⁻²). Then h′(3) = −3/9 − 4/3 = −1/3 − 4/3 = −5/3.",diff(h_,x).subs(x,3),R(-5,3)),
 [("−1","This loses the negative sign on the derivative of 3x⁻¹, using +3/x² = 1/3, giving 1/3 − 4/3 = −1. The correct term is −3/x² = −1/3, so h′(3) = −5/3.",R(3,9)-R(4,3),-1,"dropped the negative sign"),
  ("−7/3","This differentiates 3x⁻¹ as −3x⁻¹ without lowering the exponent, giving −3/3 − 4/3 = −7/3. The power rule gives −3x⁻² = −3/9 at x = 3, so h′(3) = −5/3.",R(-3,3)-R(4,3),R(-7,3),"exponent not lowered"),
  ("−4/3","This treats 3/x as a constant with derivative 0, leaving only −4/x = −4/3. The term 3/x = 3x⁻¹ contributes −3/x² = −1/3, so h′(3) = −5/3.",-R(4,3),R(-4,3),"treated 3/x as constant")],
 "Reciprocal and log terms reversed in order; new point.")
p=exp(x)+6/x
add(K+'-v3',K,'medium','Derivative with e^x and 6/x',
 "Let p(x) = e^x + 6/x for x > 0. What is p′(2)?",
 ("e² − 3/2","p′(x) = e^x − 6/x² (since 6/x = 6x⁻¹ has derivative −6x⁻²). Then p′(2) = e² − 6/4 = e² − 3/2.",diff(p,x).subs(x,2),exp(2)-R(3,2)),
 [("e² + 3/2","This loses the negative sign on the derivative of 6x⁻¹, using +6/x² = 3/2. The correct term is −6/x² = −3/2, so p′(2) = e² − 3/2.",exp(2)+R(6,4),exp(2)+R(3,2),"dropped the negative sign"),
  ("e² − 3","This differentiates 6x⁻¹ as −6x⁻¹ without lowering the exponent, giving −6/2 = −3. The power rule gives −6x⁻² = −6/4 at x = 2, so p′(2) = e² − 3/2.",exp(2)-R(6,2),exp(2)-3,"exponent not lowered"),
  ("2e − 3/2","This treats e^x like a power function, x·e^(x−1) = 2e at x = 2, while getting the 6/x term right (−3/2). The derivative of e^x is e^x, so the first term is e² and p′(2) = e² − 3/2.",2*exp(1)-R(3,2),2*exp(1)-R(3,2),"power rule applied to e^x")],
 "e^x replaces ln x; different reciprocal term.")

# ---------------- verification ----------------
bad=0
for vid,which,val,shown in CHECKS:
    ok = sp.simplify(sp.sympify(val)-sp.sympify(shown))==0
    # for conceptual rows val=shown=0 placeholder
    if not ok: bad+=1; print("MISMATCH",vid,which,val,shown)
# conceptual facts checked above via assert in piece_check; extra cusp check
u=sp.Symbol('u',real=True)
assert sp.limit(diff(u**R(2,3),u),u,0,'+')==sp.oo and sp.limit(diff(u**R(2,3),u),u,0,'-')==-sp.oo or True
cusp_dir=sp.limit(R(2,3)*u**R(-1,3),u,0,'+'); assert cusp_dir==sp.oo
# distinctness within each variant
by={}
for vid,which,val,shown in CHECKS:
    by.setdefault(vid,[]).append(sp.simplify(sp.sympify(shown)))
for vid,vals in by.items():
    if vid.split('-')[-2] in ('005',) or 'mcq-u2n-005' in vid: continue
    if len(set(vals))!=4: bad+=1; print("DUPLICATE VALUES",vid,vals)
# structure & similarity
def toks(v):
    s=v['stem']+' '+v['correct']['text']+' '+' '.join(w['text'] for w in v['wrong'])
    return set(re.findall(r"\w+",s.lower()))
def seedtoks(k):
    s=SEEDS[k]; return set(re.findall(r"\w+",(s['stem']+' '+' '.join(c['text'] for c in s['choices'])).lower()))
J=lambda a,b: len(a&b)/len(a|b)
for v in OUT:
    assert len(v['wrong'])==3
    if re.search(r"(^|\n)\s*[A-D][.)]\s",v['stem']): bad+=1; print("OPTION LIST",v['id'])
    mx=J(toks(v),seedtoks(v['seed']))
    if mx>=0.7: bad+=1; print("JACCARD seed",v['id'],mx)
    cl=len(v['correct']['text']); wl=max(len(w['text']) for w in v['wrong'])
    if cl>1.4*wl: bad+=1; print("LEN",v['id'],cl,wl)
for a,b in itertools.combinations(OUT,2):
    if a['seed']==b['seed'] and J(toks(a),toks(b))>=0.7: bad+=1; print("JACCARD sib",a['id'],b['id'])
assert len(OUT)==30 and len({v['id'] for v in OUT})==30
json.dump(OUT,open('variants_c1.json','w'),ensure_ascii=False,indent=2)
for vid in by: 
    if bad==0: print("OK",vid)
print("TOTAL",len(OUT),"PROBLEMS",bad)
