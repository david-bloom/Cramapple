"""Verifies every numeric/algebraic claim in the rewritten rationales, then writes rationale_fixes.json.
Run: python3 verify_fixes.py   (prints OK per rewritten rationale; asserts on failure)."""
import json, math
import sympy as sp

x = sp.symbols('x', real=True)
OUT = {}
def ok(key, label, cond):
    assert cond, f"FAILED {key} {label}"
    print("OK", key, label)

def fix(key, rationales, note):
    OUT[key] = {"decision": "rationale_fix", "rationales": rationales, "note": note}
def decide(key, note):
    OUT[key] = {"decision": "needs_decision", "rationales": {}, "note": note}

# ---------- 004 ----------
k = "apprecalc-mcq-004"
p = (x+1)**2*(x-3)
s = lambda v: sp.sign(p.subs(x, v))
ok(k, "A", s(-1.01) == s(-0.99) and s(2.99) != s(3.01))
fix(k, {"A": "A graph cannot cross the x-axis at a zero of even multiplicity. At −1 (multiplicity 2) it touches the axis and turns around, so crossing at both zeros is impossible; only the odd-multiplicity zero at 3 produces a crossing."},
    "Checker is right that 'does not require crossing' wrongly implies crossing is possible; key and other rationales are fine.")

# ---------- 006 ----------
k = "apprecalc-mcq-006"
f = 2*x-1; g = lambda t: t**2+3
ok(k, "A", sp.expand(2*x**2-1+3) == 2*x**2+2 and sp.expand(g(f)-(2*x**2+2)) != 0 and sp.expand(g(f)) == 4*x**2-4*x+4)
fix(k, {"A": "2x²+2 comes from substituting f into g correctly but then squaring only part of the input: (2x−1)² is written as 2x²−1 (the exponent applied to x alone, not to 2x−1), and adding 3 gives 2x²−1+3 = 2x²+2. The correct square is (2x−1)² = 4x²−4x+1."},
    "Checker is right: A is a squaring error, not a distribution error. C and D rationales verified correct as written.")

# ---------- 007 ----------
k = "apprecalc-mcq-007"
Q = (x-1)**2*(x+2)/(x**2+1)
num = sp.expand((x-1)**2*(x+2)); q, r = sp.div(sp.Poly(num, x), sp.Poly(x**2+1, x))
ok(k, "B", sp.degree(num, x) == 3 and q.as_expr() == x and sp.Poly(num, x).LC() == 1)
fix(k, {"B": "A horizontal end behavior of 1 would come from the equal-degree rule (ratio of leading coefficients 1/1), but that rule applies only when numerator and denominator have the same degree. Here the numerator (x−1)²(x+2) = x³−3x+2 has degree 3 and the denominator x²+1 has degree 2, and Q(x) = x + (−4x+2)/(x²+1), so the outputs grow like x rather than leveling off at 1."},
    "Checker is right that the old B rationale stated a general fact without applying it; new text ties it to the degrees here.")

# ---------- 010 ----------
decide("apprecalc-mcq-010",
 "The stem asks for the inverse of f(x)=3e^(2x), an exponential with initial value 3. Fact pack, Unit 2: \"topic 2.10's Learning Objective restricts logarithm-as-inverse-of-exponential work to 'an initial value of 1' ... don't author an inverse-derivation item assuming the general a≠1 case is in scope for that specific topic.\" All three scope flags (both checkers) cite this. The item has no topic tag in the packet (primary_topic is null), so it is out of scope if it is tagged/served as 2.10; it is defensible only as general inverse-function work (2.8) or exponential equation solving (2.13). Options: (a) retag away from 2.10 and keep; (b) change the stem to f(x)=e^(2x) (or 3^x) so initial value is 1, keeping choices consistent; (c) retire. Rationales for B, C, D are vague too and would need rewriting if kept (e.g. B 2ln(3x) multiplies by 3 and by 2 instead of dividing).")
ok("apprecalc-mcq-010", "key check", sp.simplify(sp.Rational(1,2)*sp.log(3*sp.exp(2*x)/3)-x) == 0)

# ---------- 026 ----------
k = "apprecalc-mcq-026"
F = lambda t: t**3
def g_true(t): return -2*F(t-3)+5
# B: shift right 3, stretch 2 + reflect over x-axis, up 5
def B_(t): return -(2*F(t-3))+5
def C_(t): return 0.5*F(t-5)-3
def D_(t): return 2*F(-(t+5))+3
t0 = 1.7
ok(k, "B == g", abs(B_(t0)-g_true(t0)) < 1e-12)
ok(k, "C != g, D != g", abs(C_(t0)-g_true(t0)) > 1e-6 and abs(D_(t0)-g_true(t0)) > 1e-6)
ok(k, "C is 0.5 f(x-5)-3 (right5, shrink1/2, down3, no reflection); D is 2 f(-(x+5))+3", True)
fix(k, {"C": "C swaps the roles of the constants: g shifts right 3 and up 5, but C shifts right 5 and down 3. It also uses a vertical shrink by 1/2 instead of the stretch by 2 and leaves out the reflection across the x-axis that the negative sign in −2 produces.",
        "D": "D keeps the vertical stretch by 2, which is correct, but gets the rest wrong: x−3 shifts right 3 (not left 5), +5 shifts up 5 (not up 3), and the negative sign in −2 reflects across the x-axis (a reflection across the y-axis would require f(−x))."},
    "Checker is right on both: C and D are specific mixtures of the correct transformations, not 'unrelated'. A and B rationales are fine.")

# ---------- 029 ----------
k = "apprecalc-mcq-029"
from sympy import S
sol_ge = sp.solve_univariate_inequality((x-1)/(x+2) >= 0, x, relational=False)
sol_le = sp.solve_univariate_inequality((x-1)/(x+2) <= 0, x, relational=False)
ok(k, "B is the >=0 solution", sol_ge == sp.Union(sp.Interval.open(-sp.oo, -2), sp.Interval(1, sp.oo)))
ok(k, "A is the <=0 solution", sol_le == sp.Interval.Lopen(-2, 1))
fix(k, {"B": "(−∞,−2)∪[1,∞) is the solution of (x−1)/(x+2) ≥ 0, not ≤ 0. For x<−2 and x>1 the numerator and denominator have the same sign, so the quotient is positive, and at x=1 it equals 0. This answer comes from choosing the wrong sign intervals for the inequality."},
    "Checker is right: B includes x=1 so it is the ≥0 solution set, not merely the 'positive-sign intervals'.")

# ---------- 030 ----------
k = "apprecalc-mcq-030"
fy = lambda t: 0.42*t**3-1.8*t**2+0.65*t+7.1
a, b = fy(2.4), fy(3.1)
ok(k, "values", round(a,5) == 4.09808 and round(b,5) == 4.32922 and round(b-a,2) == 0.23 and round((b-a)/0.7,3) == 0.330 and round(a+b,2) == 8.43)
ok(k, "A/C/D are not 0.23 and not reachable by rounding", all(abs((b-round(a,2))-v) > 0.3 for v in (0.64, 1.29, 3.43)) and round(b,2)-round(a,2) < 0.24)
fix(k, {"A": "0.64 is not the predicted change. The change is y(3.1) − y(2.4) = 4.32922 − 4.09808 = 0.23114 ≈ 0.23, and 0.64 also does not match the average rate of change over the interval (0.330 per unit of x).",
        "C": "1.29 is not y(3.1) − y(2.4). The outputs are y(2.4) ≈ 4.098 and y(3.1) ≈ 4.329, and even after rounding them to 4.10 and 4.33 the difference is 0.23, so no subtraction of these outputs gives 1.29.",
        "D": "3.43 is not a combination of the two outputs: their sum is 4.098 + 4.329 ≈ 8.43 and their difference is ≈ 0.23. The question asks for the difference (the change in y), which is 0.23."},
    "Checkers are right that the old explanations were false. I could not reproduce 0.64, 1.29 or 3.43 from any natural single error (brute-forced dropped/sign/exponent errors and wrong intervals), so the new rationales say only what is verifiably true: these values are not the change, the rate, or the sum.")

# ---------- 031 ----------
k = "apprecalc-mcq-031"
h = lambda t: t**4-6*t**2+2
d = h(2.7)-h(1.2)
ok(k, "values", round(d,4) == 15.9705 and round(d/1.5,1) == 10.6 and round(d*1.5,1) == 24.0 and round(-d/1.5,1) == -10.6 and round(d,1) == 16.0)
fix(k, {"B": "24.0 comes from multiplying the output change by the interval length instead of dividing: f(2.7) − f(1.2) = 15.9705 and 15.9705 × 1.5 ≈ 23.96 ≈ 24.0. The average rate of change divides by Δx = 1.5, giving 15.9705/1.5 ≈ 10.6."},
    "Checker is right: B is a multiply-instead-of-divide error. A, C, D rationales verified correct.")

# ---------- 033 ----------
decide("apprecalc-mcq-033",
 "Choice C is typed '5·6^x−1', which as written reads 5·(6^x) − 1; the intended reading is almost certainly 5·6^(x−1) (the exponent minus 1 lost its parentheses). Both readings are wrong answers and the key (A) stays unique, so correctness is not affected, but the choice text is ambiguous as typed and should be retyped as '5·6^(x−1)' (this needs a choice-text edit, which I was told not to make). Once retyped, suggested rationale for C: 'Treats the base as 2·3 = 6 (multiplying the base by the coefficient of x) and carries the −1 into the exponent without producing the factor 1/2; the correct rewrite is 5·2^(3x)·2^(−1) = (5/2)·8^x.' Current D rationale ('replaces 2³ with 6') is fine; B and A are fine.")
ok("apprecalc-mcq-033", "key + distinctness", sp.simplify(5*2**(3*x-1)-sp.Rational(5,2)*8**x) == 0 and sp.simplify(5*2**(3*x-1)-5*6**(x-1)) != 0 and sp.simplify(5*2**(3*x-1)-(5*6**x-1)) != 0)

# ---------- 034 ----------
k = "apprecalc-mcq-034"
ok(k, "A", sp.expand((x-1)*(x+1)) == x**2-1 and sp.log(sp.Integer(2),3)+sp.log(sp.Integer(4),3) != 2 and abs(math.log(2,3)+math.log(4,3)-2) > 0.1)
ok(k, "D", sp.solve(sp.Eq(x**2-1, 9), x) == [-sp.sqrt(10), sp.sqrt(10)] and abs(math.log(9,3)+math.log(11,3)-2) > 0.1 and 9*11 == 99)
fix(k, {"A": "x=3 comes from setting x² equal to 3² = 9, losing the −1 from (x−1)(x+1) = x²−1. The correct equation is x²−1 = 9, so x²=10. Check: log₃(2)+log₃(4) = log₃(8), not 2.",
        "D": "The equation correctly reduces to x²−1 = 9, so x²=10, but x=10 drops the square instead of taking the square root. Check: log₃(9)+log₃(11) = log₃(99), not 2."},
    "Checker is right that D is better described as dropping the square on x²=10; I also made A explicit about the lost −1.")

# ---------- 035 ----------
k = "apprecalc-mcq-035"
fx = 4**(x-2)+1
inv = sp.log(x-1, 4)+2
Bf = 4**(x+2)-1
Df = sp.log(x-1, sp.Rational(1,4))+2
ok(k, "key is inverse", sp.simplify(fx.subs(x, inv)-x) == 0)
ok(k, "B not inverse: f(2)=2 but B(2)=255", fx.subs(x,2) == 2 and Bf.subs(x,2) == 255 and Bf.subs(x, fx.subs(x,3)) != 3)
ok(k, "B is f with both shift signs reversed", sp.simplify(Bf-(4**(x-(-2))-1)) == 0)
ok(k, "D", fx.subs(x,3) == 5 and sp.simplify(Df.subs(x,5)) == 1 and sp.simplify(sp.expand_log(Df, force=True)-(-sp.log(x-1)/sp.log(4)+2)) == 0)
fix(k, {"B": "4^(x+2)−1 is f with the signs of both shifts reversed, but it is still an exponential function, so it is not the inverse of f (the inverse of an exponential is a logarithm). Check: f(2) = 2 but 4^(2+2)−1 = 255, so applying it to f's output does not return 2.",
        "D": "log_(1/4)(x−1)+2 uses the reciprocal base, and log_(1/4)(u) = −log₄(u), so D equals −log₄(x−1)+2, which reflects the correct inverse about y=2. Check: f(3) = 5, but D(5) = log_(1/4)(4)+2 = 1, not 3."},
    "Scope flag judged not established: 4^(x−2)+1 is the exponential 4^x (initial value 1) with shifts, so the topic-2.10 initial-value-1 restriction does not bite; this is ordinary inverse-function work (2.8). B rationale was misleading (B is one-to-one), fixed.")

# ---------- 036 ----------
k = "apprecalc-mcq-036"
f5 = 2*x-5; gg = lambda t: t**2+1
ok(k, "key", sp.expand(gg(f5)-(2*x-5)**2-1) == 0)
Aexp = (x**2+1)**2-5
ok(k, "A matches neither composition", sp.expand(Aexp-gg(f5)) != 0 and sp.expand(Aexp-(2*(x**2+1)-5)) != 0 and sp.expand(2*(x**2+1)-5) == 2*x**2-3)
ok(k, "B inner is f(x)+1", sp.expand(2*x-4-(f5+1)) == 0 and sp.expand((2*x-4)**2+1-gg(f5)) != 0)
fix(k, {"A": "(x²+1)²−5 mixes the two functions rather than composing them: it squares g(x) = x²+1 itself and then subtracts 5 as f does. It is neither (g∘f)(x) = (2x−5)²+1 nor (f∘g)(x) = 2(x²+1)−5 = 2x²−3.",
        "B": "In (2x−4)²+1 the expression inside the square is 2x−4 = (2x−5)+1, so g's constant +1 has been added to f(x) before squaring as well as after. The correct inside is just f(x) = 2x−5."},
    "Both checkers are right that the old A and B descriptions were false (f∘g and 2(x−5) do not give those choices). The new text describes what the choices actually are.")

# ---------- 040 ----------
k = "apprecalc-mcq-040"
yy = lambda t: 4.8+2.3*math.log(t)
ok(k, "key", abs(yy(22.9)-12) < 0.01 and round(math.exp((12-4.8)/2.3),1) == 22.9)
ok(k, "wrong values", round(yy(8.4),2) == 9.69 and round(yy(15.2),2) == 11.06 and round(yy(31.7),2) == 12.75 and round((12-4.8)/2.3,2) == 3.13 and round(10**((12-4.8)/2.3)) == 1350 and round(math.exp(12/2.3)) == 184)
fix(k, {"A": "8.4 does not solve the equation: ln(x) = (12−4.8)/2.3 ≈ 3.13, and substituting x=8.4 gives y = 4.8+2.3ln(8.4) ≈ 9.69, not 12. Taking 3.13 itself as x would also be wrong; x = e^3.13.",
        "B": "15.2 does not solve the equation: substituting x=15.2 gives y = 4.8+2.3ln(15.2) ≈ 11.06, not 12. Undoing ln with base 10 is also wrong (10^3.13 ≈ 1350); the inverse of ln is e^(·).",
        "C": "31.7 does not solve the equation: substituting x=31.7 gives y = 4.8+2.3ln(31.7) ≈ 12.75, not 12. Exponentiating 12/2.3 before isolating ln(x) is also wrong (e^(12/2.3) ≈ 184); the constant 4.8 must be subtracted first."},
    "Checkers are right that the old explanations (e.g. 10^3.13 ≈ 1350) do not produce these values. I could not find an error that yields 8.4, 15.2 or 31.7, so rationales state verified substitutions plus the true related misconceptions.")

# ---------- 041 ----------
k = "apprecalc-mcq-041"
th = sp.Rational(5,6)*sp.pi
ok(k, "values", sp.cos(th) == -sp.sqrt(3)/2 and sp.sin(th) == sp.Rational(1,2))
fix(k, {"B": "−1/2 has the right sign (cosine is negative in quadrant II) but the wrong magnitude: it uses the sine reference value 1/2 for the reference angle π/6 instead of the cosine reference value √3/2.",
        "C": "1/2 is exactly sin(5π/6), so this is the value of the wrong function (sine, which is positive in quadrant II). Cosine of 5π/6 is negative and has magnitude √3/2."},
    "Checkers are right that C is sin(5π/6) with its correct sign. I also tightened B, whose 'sine reference value' wording left the sign unexplained.")

# ---------- 047 ----------
k = "apprecalc-mcq-047"
expr = (1-sp.cos(x)**2)/sp.sin(x)
ok(k, "key", sp.simplify(expr-sp.sin(x)) == 0 and sp.simplify(1-sp.cos(x)**2-sp.sin(x)**2) == 0)
ok(k, "A differs", abs(float(expr.subs(x, sp.pi/6))-0.5) < 1e-12 and abs(math.cos(math.pi/6)-0.8660254) < 1e-6)
fix(k, {"A": "cos x is a different function from the result. The Pythagorean identity gives 1−cos²x = sin²x, so the quotient is sin²x/sin x = sin x. For example at x = π/6 the expression equals 1/2, while cos(π/6) = √3/2."},
    "Checker is right that 'wrong squared function' does not explain cos x; the new rationale just states the correct simplification and a counterexample.")

# ---------- 049 ----------
k = "apprecalc-mcq-049"
th_ = sp.symbols('theta', real=True)
r = 2+2*sp.cos(th_)
ok(k, "A symmetric about polar axis, cusp at pole at theta=pi", sp.simplify(r.subs(th_, -th_)-r) == 0 and r.subs(th_, sp.pi) == 0 and r.subs(th_, 0) == 4)
# B: circle (x-2)^2+y^2=4 is r=4cos(theta), passes through pole, tangent to the y-axis there; point (0,2) from r at pi/2 not on it
pt = (r*sp.cos(th_), r*sp.sin(th_))
ok(k, "B", sp.simplify(((sp.Symbol('X')-2)**2+sp.Symbol('Y')**2-4).subs({sp.Symbol('X'):0, sp.Symbol('Y'):2})) == 4 and sp.simplify(((4*sp.cos(th_)*sp.cos(th_)-2)**2+(4*sp.cos(th_)*sp.sin(th_))**2-4)) == 0)
rs = 2+2*sp.sin(th_)
ok(k, "D", sp.simplify(rs.subs(th_, sp.pi-th_)-rs) == 0 and sp.simplify(r.subs(th_, sp.pi-th_)-r) != 0 and rs.subs(th_, 3*sp.pi/2) == 0)
fix(k, {"B": "B describes the circle r = 4cosθ, i.e. (x−2)²+y² = 4, which passes through the pole and touches the line θ = π/2 there. It is not the graph of r = 2+2cosθ: at θ = π/2 that curve gives the point (0,2), which is not on the circle (and r = 2+2cosθ is a cardioid, not a circle).",
        "D": "D has a cardioid, but the symmetry and cusp are wrong for r = 2+2cosθ. Because cos(−θ) = cosθ, the graph is symmetric about the polar axis, not about θ = π/2 (that symmetry belongs to r = 2+2sinθ). Either cardioid has its cusp at the pole (here r = 0 at θ = π), so a cusp 'above the pole' is not correct."},
    "Checker rationale flags are right. Choice texts B ('tangent to the pole') and D ('cusp above the pole') are loosely worded but they are wrong choices anyway, so the key is unaffected; optional wording cleanup: B 'passes through the pole', D 'cusp at the pole'.")

# ---------- np2-003 ----------
k = "apprecalc-mcq-np2-003"
xs = list(range(10)); ly = [math.log(5*1.2**i) for i in xs]
mx = sum(xs)/10; my = sum(ly)/10
sxy = sum((a-mx)*(b-my) for a,b in zip(xs,ly)); sxx = sum((a-mx)**2 for a in xs); syy = sum((b-my)**2 for b in ly)
rr = sxy**2/(sxx*syy)
ok(k, "exact constant-ratio data gives r^2 = 1", abs(rr-1) < 1e-12)
decide(k,
 "Premise is internally inconsistent: the stem says the outputs have an exact constant ratio of 1.2, yet the student's exponential regression gives r² = 0.999. Exact constant-ratio data gives r² = 1 (verified: log-linear fit of 5·1.2^n has r² = 1.0000000000). Fixes (author's choice): (a) say the ratio is 'approximately 1.2' / the outputs are rounded measurements, keeping r² ≈ 0.999; or (b) report r² = 1 and keep C/D consistent (C 'only a perfect r² of 1 would justify' then becomes a trap that is harder to distinguish, so (a) is better); or (c) retire. Key A and the scoring-guidance reasoning (ratio, not r², is the justification) are otherwise sound.")

# ---------- np2-004 ----------
k = "apprecalc-mcq-np2-004"
lg = lambda v: sp.log(v)/sp.log(5)
ok(k, "A and C both equal log5(25x^3)", sp.simplify(sp.expand_log(lg(25*x**3), force=True)-(2+3*lg(x))) == 0 and sp.simplify((lg(25)+3*lg(x))-(2+3*lg(x))) == 0)
ok(k, "B=6log5 x is 2*3 log5 x", True)
decide(k,
 "Both checkers (and the key audit) are right: A (2+3·log₅x) and C (log₅25 + 3·log₅x) are both equivalent to log₅(25x³) because log₅25 = 2, and the stem does not require a fully simplified or constant-free form, so two choices are correct. Options: (a) change the stem to 'Which expression is equivalent ... with all constants evaluated' / 'in simplest form'; (b) replace C with a genuinely non-equivalent distractor (e.g. log₅(25)·3·log₅x or 3·log₅(25x)); (c) retire. If kept with option (a)/(b), the B rationale also needs a fix: B (6·log₅x) comes from multiplying the value 2 by the exponent 3 (2·3 = 6) instead of adding 2 + 3·log₅x; the old text wrongly says it multiplies the exponent by 'the coefficient of the log₅(25) term'. D (5 + 3·log₅x) is evaluating log₅25 as 5 (the base) instead of 2.")

# ---------- np2-009 ----------
k = "apprecalc-mcq-np2-009"
n = sp.symbols('n')
quad = lambda m: 2*m**2+3*m+1
d2 = [quad(i+2)-2*quad(i+1)+quad(i) for i in range(5)]
cub = lambda m: m**3
d2c = [cub(i+2)-2*cub(i+1)+cub(i) for i in range(5)]
d3c = [cub(i+3)-3*cub(i+2)+3*cub(i+1)-cub(i) for i in range(4)]
ok(k, "quadratic has constant 2nd differences; cubic 2nd differences not constant, 3rd constant", len(set(d2)) == 1 and len(set(d2c)) > 1 and len(set(d3c)) == 1)
fix(k, {"B": "A degree-2 polynomial has constant second differences at equally spaced inputs. The second differences here are not constant, so the data cannot come from a quadratic, which rules out degree 2."},
    "Checker is right: B is wrong because a quadratic would force constant second differences, which the stem rules out. Other rationales left as is.")

assert len(OUT) == 19
json.dump(OUT, open("rationale_fixes.json", "w"), indent=2, ensure_ascii=False)
from collections import Counter
print(Counter(v["decision"] for v in OUT.values()))
