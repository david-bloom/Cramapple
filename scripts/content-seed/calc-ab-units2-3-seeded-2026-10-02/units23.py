#!/usr/bin/env python3
"""AP Calc AB Units 2-3 seeded variants, 3 per seed, 10 seeds = 30 variants (2026-10-02). Author: Claude Sonnet 5.5.
Seeds (class A, S0a-audited 2026-10-02, out_seed_audit/): 006, 025, 026, 027, 028 (Unit 2); 005, 007, 008, 029, 030 (Unit 3).
Skipped: u1n-001 and u1n-002 already have 3 variants each from the Unit 1 batch (u1v-001-v1..3, u1v-002-v1..3).
Authored against docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Units 1-3 (no boxed exclusions; product/quotient structure,
chain-rule-forgetting and implicit-differentiation misconceptions are the documented distractor sources).
Every key and every distractor value is recomputed with sympy before being asserted; rationales are written from those computations.
Keys use v3-v5 for seeds that already have published sv-<seed>-v1/v2 (005, 007, 008, 026, 029, 030), else v1-v3.
Usage: python3 units23.py check | export <math.json> <ced.json> <manifest.json>
WARNING: export re-randomizes the correct-answer letters. Run it ONCE; never rebuild after anything is loaded (protocol finding 7)."""
import itertools, json, re, secrets, sys
import sympy as sp
from sympy import symbols, diff, exp, cos, sin, tan, sec, csc, cot, log, sqrt, Rational, limit, Piecewise, pi, E, oo, S, simplify, nsimplify
from sympy.parsing.sympy_parser import parse_expr, standard_transformations, implicit_multiplication_application, convert_xor

x, y, h = symbols("x y h", real=True)

def parse(txt):
    s = txt.replace("−", "-").replace("·", "*").replace("π", "pi")
    for a, b in (("²", "^2"), ("³", "^3"), ("⁴", "^4"), ("⁵", "^5")): s = s.replace(a, b)
    s = s.replace("√", " sqrt")
    s = re.sub(r"(sin|cos|tan|sec|csc|cot)\^(\d)\s*x", r"\1(x)^\2", s)
    s = re.sub(r"\b(sin|cos|tan|sec|csc|cot)\s+x\b", r"\1(x)", s)
    s = re.sub(r"(\d)e\b", r"\1*E", s); s = re.sub(r"\be\b", "E", s); s = re.sub(r"\)e\b", ")*E", s); s = s.replace("ln", "log")
    return parse_expr(s, local_dict={"E": E, "x": x, "y": y, "pi": pi}, transformations=standard_transformations + (implicit_multiplication_application, convert_xor))

def eq(expr, txt):
    return simplify(nsimplify(expr) - parse(txt)) == 0

V = []
def add(vid, seed, diff_, title, stem, correct, wrong, verify, change, stimulus=None):
    """correct=(text, rationale); wrong=[(text, rationale)]*3; verify() returns a list of failure strings."""
    V.append(dict(id=vid, seed=seed, diff=diff_, title=title, stem=stem, stimulus=stimulus, correct=correct, wrong=wrong, verify=verify, change=change))

def exprs(key, wrongs, prefix=""):
    """Verifier for expression-valued items: key and each wrong text must equal the sympy expression computed from the stated error."""
    def f(v):
        out = []
        def t(s): return s[len(prefix):] if prefix and s.startswith(prefix) else s
        if not eq(key, t(v["correct"][0])): out.append(f"key {v['correct'][0]!r} != {key}")
        for (txt, _), w in zip(v["wrong"], wrongs):
            if not eq(w, t(txt)): out.append(f"distractor {txt!r} != computed {w}")
            if eq(key - w, "0"): out.append(f"distractor {txt!r} equals the key")
        return out
    return f

# ------------------------------------------------------------------ 006: tangent line at a point
def line(f, a):
    a = sympify_ = sp.nsimplify(a)
    return f.subs(x, a) + diff(f, x).subs(x, a) * (x - a)
add("006-v1", "apcalcab-mcq-006", "medium", "Tangent Line to a Square-Root Curve",
    "A ramp's profile follows the curve y = √x. Which equation describes the line tangent to the profile at the point where x = 9?",
    ("y = 3 + (x − 9)/6", "At x = 9 the point is (9, 3), and dy/dx = 1/(2√x) = 1/6 there, so the tangent line is y = 3 + (x − 9)/6."),
    [("y = 3 + (x − 9)/3", "Uses 1/√x = 1/3 as the slope, dropping the factor 1/2 in the derivative of √x."),
     ("y = 3 + 6(x − 9)", "Uses 6, the reciprocal of the slope 1/6, as the slope of the tangent line."),
     ("y = (x − 9)/6", "Has the correct slope 1/6 but leaves out the y-coordinate 3 of the point of tangency.")],
    lambda v: exprs(line(sqrt(x), 9), [3 + (x - 9) / 3, 3 + 6 * (x - 9), (x - 9) / 6], "y = ")(v),
    "ln x at x=e -> sqrt x at x=9; slope 1/(2 sqrt x)")
add("006-v2", "apcalcab-mcq-006", "medium", "Tangent Line to a Product Curve",
    "Find an equation of the tangent line to y = x·e^x at x = 1.",
    ("y = e + 2e(x − 1)", "At x = 1 the point is (1, e). By the product rule, dy/dx = (1 + x)e^x, which is 2e at x = 1, so the tangent line is y = e + 2e(x − 1)."),
    [("y = e + e(x − 1)", "Differentiates only the exponential factor, using the slope x·e^x = e at x = 1 instead of applying the product rule."),
     ("y = e + (1 + e)(x − 1)", "Adds the derivatives of the two factors, 1 + e^x = 1 + e at x = 1, instead of applying the product rule."),
     ("y = 2e(x − 1)", "Has the correct slope 2e but leaves out the y-coordinate e of the point of tangency.")],
    lambda v: exprs(line(x * exp(x), 1), [E + E * (x - 1), E + (1 + E) * (x - 1), 2 * E * (x - 1)], "y = ")(v),
    "ln x -> x e^x (product rule makes the slope a step); tangent at x=1")
add("006-v3", "apcalcab-mcq-006", "medium", "Tangent Line to a Reciprocal Curve",
    "The hyperbola y = 1/x passes through the point with x-coordinate 2. Which equation describes the tangent line to the hyperbola there?",
    ("y = 1/2 − (x − 2)/4", "At x = 2 the point is (2, 1/2). Since dy/dx = −1/x², the slope is −1/4, so the tangent line is y = 1/2 − (x − 2)/4."),
    [("y = 1/2 + (x − 2)/4", "Has the right size of slope but loses the negative sign in dy/dx = −1/x²."),
     ("y = 1/2 − (x − 2)/2", "Divides by x instead of x² when differentiating 1/x, giving slope −1/2 instead of −1/4."),
     ("y = 2 − (x − 2)/4", "Has the correct slope −1/4 but uses 2 as the y-coordinate of the point of tangency instead of 1/2.")],
    lambda v: exprs(line(1 / x, 2), [Rational(1, 2) + (x - 2) / 4, Rational(1, 2) - (x - 2) / 2, 2 - (x - 2) / 4], "y = ")(v),
    "ln x -> 1/x; negative power rule; tangent at x=2")

# ------------------------------------------------------------------ 025: limit definition of the derivative
def lim_ok(expr, var, to, expect, dne=False):
    """True/False for: the two-sided limit equals `expect` (or, if dne, does not exist as a finite value)."""
    a = limit(expr, var, to, "+"); b = limit(expr, var, to, "-")
    if dne: return not (a == b and a.is_finite)
    return a == b and simplify(a - expect) == 0

def v025(v1_fn):
    return lambda v: [] if v1_fn() else ["limit verification failed"]
add("025-v1", "apcalcab-mcq-025", "easy", "Limit Form of the Derivative of a Cubic",
    "If f(x) = x³, which of the following limits is equal to f′(2)?",
    ("lim(h→0) [(2+h)³ − 8]/h", "This is [f(2 + h) − f(2)]/h with f(2) = 8, the limit definition of f′(2). It equals 12."),
    [("lim(h→0) [(2+h)³ − h³]/h", "Subtracts f(h) = h³ where f(2) = 8 belongs. The quotient is (8 + 12h + 6h²)/h, which tends to +∞ as h → 0⁺ and to −∞ as h → 0⁻, so the limit does not exist."),
     ("lim(h→0) [(2+h)³ − 8]/2", "Divides by the fixed point 2 instead of the increment h. The numerator tends to 0, so this limit is 0."),
     ("lim(h→0) [(2+h)³ − 8]/(2h)", "Divides by 2h instead of h. The limit is 6, half of f′(2) = 12.")],
    v025(lambda: lim_ok(((2 + h) ** 3 - 8) / h, h, 0, 12) and lim_ok(((2 + h) ** 3 - h ** 3) / h, h, 0, 0, dne=True)
        and lim_ok(((2 + h) ** 3 - 8) / 2, h, 0, 0) and lim_ok(((2 + h) ** 3 - 8) / (2 * h), h, 0, 6) and diff(x ** 3, x).subs(x, 2) == 12),
    "f at 3 -> x^3 at 2; h-form with explicit function")
add("025-v2", "apcalcab-mcq-025", "medium", "Limit Form of the Derivative of a Reciprocal",
    "If g(x) = 1/x, which of the following limits is equal to g′(4)?",
    ("lim(x→4) [1/x − 1/4]/(x − 4)", "This is [g(x) − g(4)]/(x − 4), the x → a form of the definition of g′(4). It equals −1/16."),
    [("lim(x→4) [1/x − 1/4]/4", "Divides by the fixed value 4 instead of x − 4. The numerator tends to 0, so this limit is 0."),
     ("lim(x→4) [1/x − 4]/(x − 4)", "Uses 4, the input, where g(4) = 1/4 belongs. The numerator tends to −15/4 while the denominator tends to 0, so the limit does not exist."),
     ("lim(x→0) [1/x − 1/4]/(x − 4)", "Lets x approach 0 instead of 4. Because 1/x is unbounded near 0, the one-sided limits differ and the limit does not exist.")],
    v025(lambda: lim_ok((1 / x - Rational(1, 4)) / (x - 4), x, 4, Rational(-1, 16)) and diff(1 / x, x).subs(x, 4) == Rational(-1, 16)
        and lim_ok((1 / x - Rational(1, 4)) / 4, x, 4, 0) and lim_ok((1 / x - 4) / (x - 4), x, 4, 0, dne=True) and lim_ok((1 / x - Rational(1, 4)) / (x - 4), x, 0, 0, dne=True)),
    "x->a form (not h form); reciprocal function; point 4")
add("025-v3", "apcalcab-mcq-025", "medium", "Instantaneous Rate as a Limit",
    "The volume of a balloon is V(t) = 4t² cubic centimeters at time t seconds. Which of the following limits is equal to the instantaneous rate of change of V at t = 5?",
    ("lim(h→0) [4(5+h)² − 100]/h", "This is [V(5 + h) − V(5)]/h with V(5) = 100, the definition of V′(5). It equals 40 cubic centimeters per second."),
    [("lim(h→0) [4(5+h)² − 4h²]/h", "Subtracts V(h) = 4h² where V(5) = 100 belongs. The quotient is (100 + 40h)/h, which tends to +∞ as h → 0⁺ and to −∞ as h → 0⁻, so the limit does not exist."),
     ("lim(h→0) [4(5+h)² − 100]/5", "Divides by the fixed time 5 instead of the increment h. The numerator tends to 0, so this limit is 0."),
     ("lim(h→0) [4(5+h)² − 100]/(5h)", "Divides by 5h instead of h. The limit is 8, one fifth of V′(5) = 40.")],
    v025(lambda: lim_ok((4 * (5 + h) ** 2 - 100) / h, h, 0, 40) and lim_ok((4 * (5 + h) ** 2 - 4 * h ** 2) / h, h, 0, 0, dne=True)
        and lim_ok((4 * (5 + h) ** 2 - 100) / 5, h, 0, 0) and lim_ok((4 * (5 + h) ** 2 - 100) / (5 * h), h, 0, 8) and diff(4 * x ** 2, x).subs(x, 5) == 40),
    "adds a rate-of-change context; h-form; quadratic")

# ------------------------------------------------------------------ 026: product rule, value of f'(a)
add("026-v3", "apcalcab-mcq-026", "medium", "Derivative of a Logarithmic Product at e",
    "If f(x) = x³ ln x, what is f′(e)?",
    ("4e²", "By the product rule, f′(x) = 3x² ln x + x³·(1/x) = 3x² ln x + x². At x = e, ln e = 1, so f′(e) = 3e² + e² = 4e²."),
    [("3e²", "Keeps only the term 3x² ln x and drops the second product-rule term x³·(1/x) = x², which contributes e² at x = e."),
     ("3e", "Multiplies the derivatives of the two factors, 3x² and 1/x, getting 3x, which is 3e at x = e."),
     ("3e² + 1/e", "Writes the second product-rule term as 1/x instead of x³·(1/x) = x², forgetting to keep the factor x³.")],
    lambda v: exprs(diff(x ** 3 * log(x), x).subs(x, E), [3 * E ** 2, 3 * E, 3 * E ** 2 + 1 / E])(v),
    "x^2 e^x -> x^3 ln x; evaluation at e; second term is x^2 not a derivative of e^x")
add("026-v4", "apcalcab-mcq-026", "medium", "Derivative of a Trigonometric Product at Pi",
    "If f(x) = (x² + 1) sin x, what is f′(π)?",
    ("−(π² + 1)", "By the product rule, f′(x) = 2x sin x + (x² + 1) cos x. At x = π, sin π = 0 and cos π = −1, so f′(π) = −(π² + 1)."),
    [("π² + 1", "Uses cos π = 1 instead of −1 when evaluating (x² + 1) cos x at π."),
     ("−2π", "Multiplies the derivatives of the two factors, 2x and cos x, getting 2π cos π = −2π, instead of applying the product rule."),
     ("0", "Keeps only the first product-rule term 2x sin x, which is 0 at π, and leaves out (x² + 1) cos x.")],
    lambda v: exprs(diff((x ** 2 + 1) * sin(x), x).subs(x, pi), [pi ** 2 + 1, -2 * pi, 0])(v),
    "x^2 e^x -> (x^2+1) sin x; evaluation at pi (trig values)")
add("026-v5", "apcalcab-mcq-026", "medium", "Derivative of a Polynomial-Exponential Product at 2",
    "If f(x) = (x² − 3)eˣ, what is f′(2)?",
    ("5e²", "By the product rule, f′(x) = 2x eˣ + (x² − 3)eˣ. At x = 2 this is 4e² + 1·e² = 5e²."),
    [("4e²", "Multiplies the derivatives of the two factors, 2x and eˣ, getting 2·2·e² = 4e², instead of applying the product rule."),
     ("e²", "Differentiates only the factor eˣ, leaving (x² − 3)eˣ, which equals 1·e² = e² at x = 2."),
     ("4 + e²", "Adds the derivatives of the two factors, 2x + eˣ, which is 4 + e² at x = 2, instead of applying the product rule.")],
    lambda v: exprs(diff((x ** 2 - 3) * exp(x), x).subs(x, 2), [4 * E ** 2, E ** 2, 4 + E ** 2])(v),
    "x^2 e^x -> (x^2-3) e^x at 2; the polynomial factor gives a nonzero value that the exponential-only distractor exposes")

# ------------------------------------------------------------------ 027: product rule with trigonometric functions
add("027-v1", "apcalcab-mcq-027", "medium", "Product of Cosecant and Cotangent",
    "What is d/dx[csc x cot x]?",
    ("−csc x(cot²x + csc²x)", "By the product rule, d/dx[csc x cot x] = (−csc x cot x)(cot x) + (csc x)(−csc²x) = −csc x(cot²x + csc²x)."),
    [("csc x(cot²x + csc²x)", "Uses +csc x cot x and +csc²x as the derivatives of csc x and cot x, dropping both negative signs."),
     ("csc x(csc²x − cot²x)", "Uses +csc²x as the derivative of cot x (sign error), so the second term is +csc³x instead of −csc³x."),
     ("−cot x(csc²x + cot²x)", "The two product-rule terms are −csc x cot²x and −csc³x, whose common factor is csc x, not cot x.")],
    lambda v: exprs(diff(csc(x) * cot(x), x), [csc(x) * (cot(x) ** 2 + csc(x) ** 2), csc(x) * (csc(x) ** 2 - cot(x) ** 2), -cot(x) * (csc(x) ** 2 + cot(x) ** 2)])(v),
    "sec x tan x -> csc x cot x (every derivative is negative); same factored-form choices")
add("027-v2", "apcalcab-mcq-027", "medium", "Power Times Secant",
    "What is d/dx[x² sec x]?",
    ("x sec x(2 + x tan x)", "By the product rule, d/dx[x² sec x] = 2x sec x + x² sec x tan x = x sec x(2 + x tan x)."),
    [("x sec x(2 + tan x)", "Writes the second product-rule term as x sec x tan x, losing one factor of x from x²."),
     ("2x sec x tan x", "Multiplies the derivatives of the two factors, 2x and sec x tan x, instead of applying the product rule."),
     ("x sec x(2 − x tan x)", "Uses −sec x tan x as the derivative of sec x (sign error).")],
    lambda v: exprs(diff(x ** 2 * sec(x), x), [x * sec(x) * (2 + tan(x)), 2 * x * sec(x) * tan(x), x * sec(x) * (2 - x * tan(x))])(v),
    "trig x trig -> power x sec; common factor x sec x")
add("027-v3", "apcalcab-mcq-027", "medium", "Power Times Cosine",
    "If g(x) = x² cos x, find g′(x).",
    ("2x cos x − x² sin x", "By the product rule, g′(x) = (2x)(cos x) + (x²)(−sin x) = 2x cos x − x² sin x."),
    [("2x cos x + x² sin x", "Uses +sin x as the derivative of cos x (sign error)."),
     ("−2x sin x", "Multiplies the derivatives of the two factors, 2x and −sin x, instead of applying the product rule."),
     ("−x² sin x", "Keeps only the term x²(−sin x) and leaves out (2x)(cos x).")],
    lambda v: exprs(diff(x ** 2 * cos(x), x), [2 * x * cos(x) + x ** 2 * sin(x), -2 * x * sin(x), -x ** 2 * sin(x)])(v),
    "trig x trig -> power x cosine; two-term answer, no common factor")

# ------------------------------------------------------------------ 028: differentiability and continuity (conceptual; verified with one-sided limits)
def onesided(f_left, f_right, a):
    return dict(vl=limit(f_left, x, a, "-"), vr=limit(f_right, x, a, "+"), fa=f_right.subs(x, a) if f_right.subs(x, a).is_finite else None,
                dl=diff(f_left, x).subs(x, a), dr=diff(f_right, x).subs(x, a))
add("028-v1", "apcalcab-mcq-028", "medium", "Absolute Value at a Corner",
    "Let f(x) = |x − 2|. Which of the following statements is true?",
    ("f is continuous at x = 2 but not differentiable at x = 2.", "f(2) = 0 and f(x) approaches 0 from both sides, so f is continuous at 2. The slope is −1 to the left of 2 and +1 to the right, so the graph has a corner and f′(2) does not exist."),
    [("f is differentiable at x = 2 but not continuous at x = 2.", "A function that is differentiable at a point must be continuous there, so this combination cannot occur."),
     ("f is neither continuous nor differentiable at x = 2.", "f is continuous at 2: f(2) = 0 and both one-sided limits equal 0."),
     ("f is both continuous and differentiable at x = 2.", "The one-sided slopes are −1 and +1, which differ, so f is not differentiable at x = 2 even though it is continuous.")],
    lambda v: [] if (lambda o: o["vl"] == 0 and o["vr"] == 0 and o["fa"] == 0 and o["dl"] == -1 and o["dr"] == 1)(onesided(2 - x, x - 2, 2)) else ["028-v1 facts wrong"],
    "general statement -> a specific function with a corner")
add("028-v2", "apcalcab-mcq-028", "medium", "Piecewise Function That Joins Smoothly",
    "A function g is defined by g(x) = x² for x ≤ 1 and g(x) = 2x − 1 for x > 1. Which statement about g at x = 1 is true?",
    ("g is continuous at 1, and g′(1) = 2.", "Both pieces equal 1 at x = 1, so g is continuous. The left derivative 2x is 2 at x = 1 and the right derivative is 2, so they agree and g′(1) = 2."),
    [("g is continuous at 1, but g′(1) does not exist because the graph has a corner.", "The one-sided derivatives are both 2, so the graph has no corner at x = 1; g is differentiable there."),
     ("g′(1) exists, but g is not continuous at 1.", "A function that is differentiable at a point must be continuous there. Also, both pieces equal 1 at x = 1, so g is continuous."),
     ("g has a jump discontinuity at 1, so g′(1) does not exist.", "Both pieces equal 1 at x = 1, so there is no jump and g is continuous. The one-sided derivatives are both 2, so g′(1) exists.")],
    lambda v: [] if (lambda o: o["vl"] == 1 and o["vr"] == 1 and o["fa"] == 1 and o["dl"] == 2 and o["dr"] == 2)(onesided(x ** 2, 2 * x - 1, 1)) else ["028-v2 facts wrong"],
    "adds a piecewise definition that is smooth at the join; reverses which statement is true")
add("028-v3", "apcalcab-mcq-028", "medium", "Piecewise Function With a Jump",
    "Let h(x) = x² for x < 1 and h(x) = x + 2 for x ≥ 1. Which of the following statements is true?",
    ("h is not differentiable at x = 1 because h is not continuous at x = 1.", "As x approaches 1 from the left, h(x) approaches 1, but h(1) = 3, so h has a jump at x = 1. A function that is not continuous at a point cannot be differentiable there."),
    [("h is differentiable at x = 1 because each piece is differentiable.", "Each piece is differentiable on its own interval, but that says nothing about x = 1, where the two pieces do not meet (1 versus 3)."),
     ("h is continuous at x = 1 because h(1) is defined.", "Continuity also requires the limit to equal h(1). The left-hand limit is 1 while h(1) = 3, so h is not continuous at 1."),
     ("h is continuous at x = 1 but not differentiable there because the slopes of the two pieces differ.", "h is not continuous at x = 1 (left limit 1, h(1) = 3), so the first claim is false. Comparing the slopes of the two pieces is not the test: the jump already rules out differentiability.")],
    lambda v: [] if (lambda o: o["vl"] == 1 and o["vr"] == 3 and o["fa"] == 3 and o["dl"] == 2 and o["dr"] == 1)(onesided(x ** 2, x + 2, 1)) else ["028-v3 facts wrong"],
    "adds a jump discontinuity; the true statement now uses the continuity-differentiability implication in the contrapositive")

# ------------------------------------------------------------------ 005: product rule with a chain-rule factor
add("005-v3", "apcalcab-mcq-005", "medium", "Damped Voltage Signal",
    "A damped voltage signal is modeled by D(x) = e^(−4x) cos x. What is D′(x)?",
    ("−e^(−4x)(4 cos x + sin x)", "By the product rule with the chain rule on e^(−4x): −4e^(−4x) cos x + e^(−4x)(−sin x) = −e^(−4x)(4 cos x + sin x)."),
    [("e^(−4x)(sin x − 4 cos x)", "Uses +sin x as the derivative of cos x (sign error) in the second product-rule term."),
     ("4e^(−4x) sin x", "Multiplies the derivatives of the two factors, −4e^(−4x) and −sin x, instead of applying the product rule."),
     ("e^(−4x)(4 cos x − sin x)", "Loses the negative sign from the chain rule on e^(−4x) in the first product-rule term.")],
    lambda v: exprs(diff(exp(-4 * x) * cos(x), x), [exp(-4 * x) * (sin(x) - 4 * cos(x)), 4 * exp(-4 * x) * sin(x), exp(-4 * x) * (4 * cos(x) - sin(x))])(v),
    "e^(2x) sin x -> e^(-4x) cos x; negative chain factor and the cosine sign both matter")
add("005-v4", "apcalcab-mcq-005", "medium", "Power Times a Sine of 3x",
    "Find d/dx [x² sin(3x)].",
    ("2x sin(3x) + 3x² cos(3x)", "By the product rule with the chain rule on sin(3x): 2x sin(3x) + x²·3cos(3x) = 2x sin(3x) + 3x² cos(3x)."),
    [("2x sin(3x) + x² cos(3x)", "Differentiates sin(3x) as cos(3x) and forgets the inner derivative factor 3."),
     ("6x cos(3x)", "Multiplies the derivatives of the two factors, 2x and 3cos(3x), instead of applying the product rule."),
     ("2x sin(3x) − 3x² cos(3x)", "Uses −3cos(3x) as the derivative of sin(3x): keeps the inner factor 3 but gets the sign wrong.")],
    lambda v: exprs(diff(x ** 2 * sin(3 * x), x), [2 * x * sin(3 * x) + x ** 2 * cos(3 * x), 6 * x * cos(3 * x), 2 * x * sin(3 * x) - 3 * x ** 2 * cos(3 * x)])(v),
    "exponential-with-chain factor -> sine-with-chain factor; polynomial first factor")
add("005-v5", "apcalcab-mcq-005", "medium", "Linear Factor Times a Gaussian Exponential",
    "Find d/dx [x e^(x²)].",
    ("e^(x²)(1 + 2x²)", "By the product rule with the chain rule on e^(x²): 1·e^(x²) + x·2x e^(x²) = e^(x²)(1 + 2x²)."),
    [("2x e^(x²)", "Multiplies the derivatives of the two factors, 1 and 2x e^(x²), instead of applying the product rule."),
     ("e^(x²)(1 + 2x)", "Writes the derivative of e^(x²) as 2x e^(x²) but does not multiply it by the first factor x."),
     ("2x² e^(x²)", "Keeps only the term x·2x e^(x²) and leaves out the term 1·e^(x²).")],
    lambda v: exprs(diff(x * exp(x ** 2), x), [2 * x * exp(x ** 2), exp(x ** 2) * (1 + 2 * x), 2 * x ** 2 * exp(x ** 2)])(v),
    "chain factor becomes a quadratic exponent; the product rule mistakes look different from the seed")

# ------------------------------------------------------------------ 007: chain rule with a radical or power
add("007-v3", "apcalcab-mcq-007", "medium", "Radical of a Quadratic",
    "Find d/dx √(x² − 6x + 10).",
    ("(x − 3)/√(x² − 6x + 10)", "By the chain rule, the derivative is 1/(2√(x² − 6x + 10)) times the inner derivative 2x − 6, which simplifies to (x − 3)/√(x² − 6x + 10)."),
    [("(2x − 6)/√(x² − 6x + 10)", "Uses 1/√u instead of 1/(2√u) for the derivative of the square root, dropping the factor 1/2."),
     ("(x − 3)/(2√(x² − 6x + 10))", "Includes the factor 1/2 twice: once from the square root's derivative and again after already simplifying (2x − 6)/2."),
     ("(2x − 6)√(x² − 6x + 10)", "Multiplies the inner derivative 2x − 6 by √u instead of by the derivative of the square root, 1/(2√u).")],
    lambda v: exprs(diff(sqrt(x ** 2 - 6 * x + 10), x), [(2 * x - 6) / sqrt(x ** 2 - 6 * x + 10), (x - 3) / (2 * sqrt(x ** 2 - 6 * x + 10)), (2 * x - 6) * sqrt(x ** 2 - 6 * x + 10)])(v),
    "1+x^3 -> x^2-6x+10; the 2 in the inner derivative cancels the 1/2")
add("007-v4", "apcalcab-mcq-007", "medium", "Reciprocal of a Radical",
    "Find d/dx [1/√(2x + 5)].",
    ("−1/(2x + 5)^(3/2)", "Write the function as (2x + 5)^(−1/2). By the chain rule, the derivative is (−1/2)(2x + 5)^(−3/2) times the inner derivative 2, which is −1/(2x + 5)^(3/2)."),
    [("−1/(2(2x + 5)^(3/2))", "Applies the power rule but omits the inner derivative 2."),
     ("1/(2x + 5)^(3/2)", "Loses the negative sign from the exponent −1/2 when applying the power rule."),
     ("−1/(2x + 5)^(1/2)", "Does not reduce the exponent by 1: it differentiates (2x + 5)^(−1/2) to (−1/2)(2x + 5)^(−1/2)·2.")],
    lambda v: exprs(diff(1 / sqrt(2 * x + 5), x), [-1 / (2 * (2 * x + 5) ** Rational(3, 2)), 1 / (2 * x + 5) ** Rational(3, 2), -1 / sqrt(2 * x + 5)])(v),
    "radical -> reciprocal radical; negative fractional exponent; inner derivative 2")
add("007-v5", "apcalcab-mcq-007", "medium", "Power of a Quadratic",
    "Find d/dx (x² + 1)⁵.",
    ("10x(x² + 1)⁴", "By the chain rule, the derivative is 5(x² + 1)⁴ times the inner derivative 2x, which is 10x(x² + 1)⁴."),
    [("5(x² + 1)⁴", "Applies the power rule to the outer function but omits the inner derivative 2x."),
     ("10x(x² + 1)⁵", "Multiplies by the inner derivative 2x and the exponent 5 but does not reduce the exponent from 5 to 4."),
     ("5x(x² + 1)⁴", "Takes the derivative of the inner function x² + 1 to be x instead of 2x.")],
    lambda v: exprs(diff((x ** 2 + 1) ** 5, x), [5 * (x ** 2 + 1) ** 4, 10 * x * (x ** 2 + 1) ** 5, 5 * x * (x ** 2 + 1) ** 4])(v),
    "radical -> an integer power; the same chain rule, a different outer function")

# ------------------------------------------------------------------ 008 / 030: implicit differentiation, value of dy/dx at a point
def idv(F, px, py):  # dy/dx of F(x,y)=0 at a point, computed independently with idiff
    assert F.subs({x: px, y: py}) == 0, "point not on curve"
    return sp.idiff(F, y, x).subs({x: px, y: py})
def frac_text(r): return str(r).replace("-", "−")
def numeric(v, key, wrongs):
    def f(v):
        out = []
        if v["correct"][0] != frac_text(key): out.append(f"key text {v['correct'][0]} != {frac_text(key)}")
        for (txt, _), w in zip(v["wrong"], wrongs):
            if txt != frac_text(w): out.append(f"distractor {txt} != {frac_text(w)}")
            if w == key: out.append(f"distractor {txt} equals the key")
        return out
    return f
F8a = x ** 3 + y ** 3 - 9
add("008-v3", "apcalcab-mcq-008", "medium", "Slope on a Cubic Curve",
    "On the curve x³ + y³ = 9, what is dy/dx at the point (1, 2)?",
    ("−1/4", "Implicit differentiation gives 3x² + 3y²·y′ = 0, so y′ = −x²/y². At (1, 2) this is −1/4."),
    [("1/4", "Loses the negative sign when solving 3x² + 3y² y′ = 0 for y′."),
     ("−4", "Inverts the ratio: uses −y²/x² instead of −x²/y²."),
     ("−1/2", "Differentiates y³ as 3y·y′ instead of 3y²·y′, giving y′ = −x²/y, which is −1/2 at (1, 2).")],
    lambda v: numeric(v, idv(F8a, 1, 2), [Rational(1, 4), -4, Rational(-1, 2)])(v),
    "x^2+xy+y^2=7 -> x^3+y^3=9; no product rule, power-of-y chain factor is the crux")
F8b = x * y + y ** 2 - 8
add("008-v4", "apcalcab-mcq-008", "medium", "Slope on a Curve With an xy Term",
    "On the curve xy + y² = 8, what is dy/dx at the point (2, 2)?",
    ("−1/3", "Implicit differentiation with the product rule gives y + x·y′ + 2y·y′ = 0, so y′ = −y/(x + 2y). At (2, 2) this is −2/(2 + 4) = −1/3."),
    [("1/3", "Loses the negative sign when solving y + x y′ + 2y y′ = 0 for y′."),
     ("−3", "Inverts the ratio, using −(x + 2y)/y instead of −y/(x + 2y)."),
     ("−1/2", "Differentiates y² as y·y′ instead of 2y·y′, so the denominator is 2 + 2 = 4 instead of 2 + 4 = 6.")],
    lambda v: numeric(v, idv(F8b, 2, 2), [Rational(1, 3), -3, Rational(-1, 2)])(v),
    "xy term differentiated by the product rule; quadratic in y; different point values")
F8c = x ** 2 * y + y ** 3 - 10
add("008-v5", "apcalcab-mcq-008", "hard", "Slope on a Curve With x²y",
    "On the curve x²y + y³ = 10, what is dy/dx at the point (1, 2)?",
    ("−4/13", "Implicit differentiation with the product rule gives 2xy + x²·y′ + 3y²·y′ = 0, so y′ = −2xy/(x² + 3y²). At (1, 2) this is −4/(1 + 12) = −4/13."),
    [("−1/3", "Treats y as a constant in x²y, so the term is 2xy with no y′ part: 2xy + 3y² y′ = 0 gives y′ = −4/12 = −1/3."),
     ("4/13", "Loses the negative sign when solving 2xy + x² y′ + 3y² y′ = 0 for y′."),
     ("−13/4", "Inverts the ratio, using −(x² + 3y²)/(2xy) instead of −2xy/(x² + 3y²).")],
    lambda v: numeric(v, idv(F8c, 1, 2), [Rational(-1, 3), Rational(4, 13), Rational(-13, 4)])(v),
    "x^2 y term needs the product rule with the chain factor on y; the 'y is constant' distractor targets it")
F30a = x ** 2 + y ** 2 - 34
add("030-v3", "apcalcab-mcq-030", "medium", "Slope on a Circle at (5, 3)",
    "For the curve x² + y² = 34, what is dy/dx at the point (5, 3)?",
    ("−5/3", "Differentiating implicitly gives 2x + 2y·y′ = 0, so y′ = −x/y. At (5, 3) this is −5/3."),
    [("−3/5", "Inverts the ratio, using −y/x instead of −x/y."),
     ("5/3", "Loses the negative sign when solving 2x + 2y y′ = 0 for y′."),
     ("3/5", "Inverts the ratio and loses the negative sign.")],
    lambda v: numeric(v, idv(F30a, 5, 3), [Rational(-3, 5), Rational(5, 3), Rational(3, 5)])(v),
    "x^2+y^2=25 at (3,4) -> 34 at (5,3)")
F30b = (x - 1) ** 2 + (y + 2) ** 2 - 25
add("030-v4", "apcalcab-mcq-030", "medium", "Slope on a Shifted Circle",
    "For the curve (x − 1)² + (y + 2)² = 25, what is dy/dx at the point (4, 2)?",
    ("−3/4", "Differentiating implicitly gives 2(x − 1) + 2(y + 2)·y′ = 0, so y′ = −(x − 1)/(y + 2). At (4, 2) this is −3/4."),
    [("3/4", "Loses the negative sign when solving 2(x − 1) + 2(y + 2) y′ = 0 for y′."),
     ("−4/3", "Inverts the ratio, using −(y + 2)/(x − 1) instead of −(x − 1)/(y + 2)."),
     ("−3/2", "Uses y instead of y + 2 in the denominator: −(x − 1)/y = −3/2 at (4, 2).")],
    lambda v: numeric(v, idv(F30b, 4, 2), [Rational(3, 4), Rational(-4, 3), Rational(-3, 2)])(v),
    "circle centered at the origin -> shifted center; the shift must be carried into the ratio")
F30c = 4 * x ** 2 + y ** 2 - 20
add("030-v5", "apcalcab-mcq-030", "medium", "Slope on an Ellipse",
    "For the curve 4x² + y² = 20, what is dy/dx at the point (2, 2)?",
    ("−4", "Differentiating implicitly gives 8x + 2y·y′ = 0, so y′ = −4x/y. At (2, 2) this is −4."),
    [("−1", "Ignores the coefficient 4: uses −x/y, which is −1 at (2, 2)."),
     ("4", "Loses the negative sign when solving 8x + 2y y′ = 0 for y′."),
     ("−1/4", "Inverts the ratio, using −y/(4x) instead of −4x/y.")],
    lambda v: numeric(v, idv(F30c, 2, 2), [-1, 4, Rational(-1, 4)])(v),
    "circle -> ellipse with a coefficient; the coefficient survives into the slope")

# ------------------------------------------------------------------ 029: chain rule, f'(x) of a composite
add("029-v3", "apcalcab-mcq-029", "medium", "Derivative of a Cosine of a Quadratic",
    "If f(x) = cos(3x²), what is f′(x)?",
    ("−6x sin(3x²)", "By the chain rule, f′(x) = −sin(3x²) times the inner derivative 6x, which is −6x sin(3x²)."),
    [("−sin(3x²)", "Omits the inner derivative 6x."),
     ("6x sin(3x²)", "Uses +sin as the derivative of cos (sign error)."),
     ("−sin(6x)", "Differentiates the inner function inside the sine, 3x² to 6x, instead of multiplying by it.")],
    lambda v: exprs(diff(cos(3 * x ** 2), x), [-sin(3 * x ** 2), 6 * x * sin(3 * x ** 2), -sin(6 * x)])(v),
    "sin(x^2) -> cos(3x^2); the outer derivative has a negative sign and the inner has a coefficient")
add("029-v4", "apcalcab-mcq-029", "medium", "Derivative of an Exponential of a Sine",
    "If f(x) = e^(sin x), what is f′(x)?",
    ("cos x · e^(sin x)", "By the chain rule, f′(x) = e^(sin x) times the inner derivative cos x, which is cos x · e^(sin x)."),
    [("e^(sin x)", "Omits the inner derivative cos x."),
     ("e^(cos x)", "Differentiates the exponent inside the exponential, changing sin x to cos x, instead of multiplying by it."),
     ("sin x · e^(sin x − 1)", "Applies the power rule to e^(sin x) as if e were the variable base.")],
    lambda v: exprs(diff(exp(sin(x)), x), [exp(sin(x)), exp(cos(x)), sin(x) * exp(sin(x) - 1)])(v),
    "polynomial inner function -> trigonometric inner function; exponential outer function")
add("029-v5", "apcalcab-mcq-029", "medium", "Derivative of a Natural Log of a Quadratic",
    "If f(x) = ln(x² + 4), what is f′(x)?",
    ("2x/(x² + 4)", "By the chain rule, f′(x) = (1/(x² + 4)) times the inner derivative 2x, which is 2x/(x² + 4)."),
    [("1/(x² + 4)", "Omits the inner derivative 2x."),
     ("ln(2x)", "Replaces the argument by its derivative inside the logarithm instead of using the rule for the derivative of ln."),
     ("2x ln(x² + 4)", "Multiplies the inner derivative 2x by ln(x² + 4) instead of by 1/(x² + 4).")],
    lambda v: exprs(diff(log(x ** 2 + 4), x), [1 / (x ** 2 + 4), log(2 * x), 2 * x * log(x ** 2 + 4)])(v),
    "sine outer -> natural log outer; reciprocal outer derivative")

# ------------------------------------------------------------------ checks
SEEDS = {s["key"]: s for s in json.load(open("seed_items.json"))}
def text_of(stem, choices): return stem + " " + " ".join(choices)
def vt(v): return text_of(v["stem"], [v["correct"][0]] + [w[0] for w in v["wrong"]])
def jaccard(a, b):
    wa, wb = set(re.findall(r"\w+", a.lower())), set(re.findall(r"\w+", b.lower()))
    return len(wa & wb) / len(wa | wb) if wa | wb else 0
def existing_texts():
    out = {}
    for path in ("../calc-ab-pilot-2026-09-30/all_math_items.json", "../calc-ab-unit3-variants-2026-09-30/math_items.json"):
        try:
            for it in json.load(open(path)):
                out[it["key"]] = text_of(it["stem"], [c["text"] for c in it["choices"]])
        except FileNotFoundError: pass
    return out
def check():
    fails = []; ex = existing_texts()
    for v in V:
        try: fails += [f"{v['id']}: {m}" for m in v["verify"](v)]
        except Exception as e: fails.append(f"{v['id']} raised {type(e).__name__}: {e}")
        if len({t[0].lower() for t in [v["correct"]] + v["wrong"]}) != 4: fails.append(f"{v['id']}: duplicate choices")
        if any(not t[1].strip() for t in [v["correct"]] + v["wrong"]): fails.append(f"{v['id']}: blank rationale")
        s = SEEDS[v["seed"]]; j = jaccard(vt(v), text_of(s["stem"], [c["text"] for c in s["choices"]]))
        if j >= 0.7: fails.append(f"{v['id']}: similar to seed {j:.2f}")
        for k, t in ex.items():
            if jaccard(vt(v), t) >= 0.7: fails.append(f"{v['id']}: similar to existing {k}")
    for a, b in itertools.combinations(V, 2):
        if jaccard(vt(a), vt(b)) >= 0.7: fails.append(f"{a['id']}/{b['id']} similar")
    ids = [v["id"] for v in V]
    if len(set(ids)) != len(ids): fails.append("duplicate ids")
    print("FAILED:" if fails else f"OK: {len(V)} variants verified (every key and distractor recomputed with sympy)")
    for f in fails: print("  -", f)
    mx = max(jaccard(vt(v), text_of(SEEDS[v['seed']]['stem'], [c['text'] for c in SEEDS[v['seed']]['choices']])) for v in V)
    print(f"max similarity to a seed: {mx:.2f}")
    return 1 if fails else 0

def export(mo, co, mf):
    rng = secrets.SystemRandom(); L = "ABCD"; rows = []; ced = []; man = []
    for v in V:
        ch = [(v["correct"][0], v["correct"][1], True)] + [(w[0], w[1], False) for w in v["wrong"]]; rng.shuffle(ch)
        key = f"u23-{v['id']}"
        rows.append(dict(key=key, kind="mcq", stem=v["stem"], choices=[dict(label=L[i], text=c[0]) for i, c in enumerate(ch)],
                         keyed_label=next(L[i] for i, c in enumerate(ch) if c[2]), rationales={L[i]: c[1] for i, c in enumerate(ch)}))
        ced.append(dict(content_key=key, item_type="mcq", stem=v["stem"], stimulus=v["stimulus"],
                        criteria=[f"{L[i]}." + (" (correct)" if c[2] else "") + f" {c[0]}" for i, c in enumerate(ch)]))
        man.append(dict(key=key, id=v["id"], seed=v["seed"], title=v["title"], difficulty=v["diff"], change=v["change"],
                        content_key="apcalcab-mcq-sv-" + v["id"].replace("-v", "-v")))
    json.dump(rows, open(mo, "w"), indent=1, ensure_ascii=False); json.dump(ced, open(co, "w"), indent=1, ensure_ascii=False)
    json.dump(man, open(mf, "w"), indent=1, ensure_ascii=False)
    print(len(rows), "exported; letters drawn:", "".join(r["keyed_label"] for r in rows))

if __name__ == "__main__":
    if sys.argv[1] == "check": sys.exit(check())
    if sys.argv[1] == "export":
        rc = check()
        if rc == 0: export(sys.argv[2], sys.argv[3], sys.argv[4])
        sys.exit(rc)
