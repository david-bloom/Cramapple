#!/usr/bin/env python3
"""AP Calc AB seeded-variant PILOT (2026-09-30): one published MCQ seed per unit, two variants each.

Purpose: test whether the Unit 1 findings (quality, yield, cost) hold on a small, cross-unit sample.
Nothing here is loaded into any database. Seeds are class A (Cramapple-owned, published).

Every variant recomputes its keyed answer independently with sympy: `key_calc` returns a sympy value/expr, `same()`
asserts it equals the keyed text (parsed), and wrong_calcs assert that each distractor's stated error pattern
produces the distractor's text. The harness never reads the keyed text to decide what is correct.

Usage: python3 pilot.py check | export <math.json> <ced.json> <seeds_math.json>
"""
import itertools
import json
import re
import secrets
import sys
from pathlib import Path

import sympy as sp
from sympy import (E, Interval, Rational, cos, diff, exp, integrate, limit, ln, log, oo, sin, solve, solveset,
                   symbols, sympify, S)
from sympy.parsing.sympy_parser import parse_expr, standard_transformations, implicit_multiplication_application, convert_xor

x, t, u, h, C = symbols("x t u h C", real=True)


def parse(txt):
    s = txt.replace("−", "-").replace("√", " sqrt")
    s = re.sub(r"(\d)e\b", r"\1*E", s)
    s = re.sub(r"\be\b", "E", s)
    s = re.sub(r"\)e\b", ")*E", s)
    s = s.replace("ln", "log")
    return parse_expr(s, local_dict={"E": E, "x": x, "t": t, "u": u},
                      transformations=standard_transformations + (implicit_multiplication_application, convert_xor))


def same(expr, txt):
    """Return txt iff sympy's independently computed expr equals the parsed text exactly."""
    if sp.simplify(sp.nsimplify(expr) - parse(txt)) != 0:
        raise AssertionError(f"computed {expr} != keyed text {txt}")
    return txt


def num(expr, places, unit=""):
    v = sp.N(expr, 12)
    return f"{round(float(v), places):.{places}f}{unit}".replace("-", "−") if False else f"{round(float(v), places):.{places}f}{unit}"


def intervaltxt(iv):
    if iv == S.EmptySet:
        return "never"
    l = "-oo" if iv.start == -oo else str(iv.start)
    r = "oo" if iv.end == oo else str(iv.end)
    return f"({l}, {r})"


def relt(ineq):
    """Solve a univariate inequality and print it as text like 'x > -2'."""
    iv = sp.solve_univariate_inequality(ineq, x, relational=False)
    if iv.end == oo:
        return f"x > {iv.start}"
    if iv.start == -oo:
        return f"x < {iv.end}"
    return f"{iv.start} < x < {iv.end}"


# ---------------------------------------------------------------- seeds (verbatim from Production, published)
SEEDS = [
    dict(key="apcalcab-mcq-001", unit=1, stem="Evaluate lim(x→3) (x²−9)/(x−3).", stimulus=None,
         correct="6", wrong=["0", "3", "The limit does not exist"],
         rats={"6": "Factoring gives x+3 for x≠3, whose limit is 6.",
               "0": "Substitution into the uncanceled numerator alone does not evaluate the quotient.",
               "3": "This uses only the approach value, not the simplified function.",
               "The limit does not exist": "The removable hole does not prevent the two-sided limit from existing."}),
    dict(key="apcalcab-mcq-026", unit=2, stem="If f(x)=x²e^x, what is f′(1)?", stimulus="No calculator is permitted.",
         correct="3e", wrong=["e", "e²", "2+e"],
         rats={"3e": "Correctly applies the product rule and evaluates.", "e": "Differentiates only the polynomial factor.",
               "e²": "Confuses evaluation at 1 with squaring e.", "2+e": "Adds derivatives without preserving the product factors."}),
    dict(key="apcalcab-mcq-029", unit=3, stem="If f(x)=sin(x²), what is f′(x)?", stimulus="No calculator is permitted.",
         correct="2x cos(x²)", wrong=["cos(2x)", "2x sin(x²)", "cos(x²)"],
         rats={"2x cos(x²)": "Correctly applies the chain rule.", "cos(2x)": "Moves the inner derivative inside the cosine.",
               "2x sin(x²)": "Uses the original outer function instead of its derivative.", "cos(x²)": "Omits the inner derivative."}),
    dict(key="apcalcab-mcq-031", unit=4,
         stem="A particle has position s(t)=t³−4.7t²+2.1t+6 meters. What is its velocity at t=2.35 seconds, to the nearest hundredth?",
         stimulus="A graphing calculator is required.", correct="−3.42 m/s", wrong=["−5.34 m/s", "−3.81 m/s", "2.35 m/s"],
         rats={"−3.42 m/s": "Correctly differentiates and evaluates with units.", "−5.34 m/s": "Evaluates the derivative with an incorrect linear coefficient.",
               "−3.81 m/s": "Evaluates the position rather than the velocity.", "2.35 m/s": "Reports the time as though it were a velocity."}),
    dict(key="apcalcab-mcq-038", unit=5, stem="If f″(x)=6x−12, on which interval is f concave up?", stimulus="No calculator is permitted.",
         correct="x>2", wrong=["x<0", "x<2", "0<x<2"],
         rats={"x>2": "Correctly solves the second-derivative inequality.", "x<0": "Uses the sign of x rather than the second derivative.",
               "x<2": "Reverses the inequality.", "0<x<2": "Restricts the solution without justification."}),
    dict(key="apcalcab-mcq-017", unit=6, stem="A(t)=10+∫[0 to t](u²−4u+3)du. On which interval is A decreasing?", stimulus=None,
         correct="(1,3)", wrong=["(−∞,1)", "(3,∞)", "A never decreases"],
         rats={"(1,3)": "A′(t)=(t−1)(t−3), which is negative between its zeros.", "(−∞,1)": "The derivative is positive there.",
               "(3,∞)": "The derivative is positive there.", "A never decreases": "The integrand, and hence A′, is negative on (1,3)."}),
    dict(key="apcalcab-mcq-np2-006", unit=7, stem="If dy/dx = 2xy and y(0) = 3, then y(1) = ?", stimulus=None,
         correct="3e", wrong=["3e^2", "e", "6"],
         rats={"3e": "Separating variables gives ln|y|=x^2+C; y(0)=3 gives C=ln3, so y=3e^(x^2). At x=1, y=3e.",
               "3e^2": "This misapplies the exponent, effectively doubling the x^2 term incorrectly.",
               "e": "Omits the initial condition: setting C=0 instead of C=ln 3 gives y=e^(x^2), so y(1)=e.",
               "6": "This treats the differential equation as if y were constant during integration, producing a linear rather than exponential result."}),
    dict(key="apcalcab-mcq-016", unit=8, stem="The average value of f(x)=x² on [0,3] is", stimulus=None,
         correct="3", wrong=["6", "9", "27"],
         rats={"3": "(1/3)∫[0 to 3]x²dx=(1/3)(9)=3.", "6": "Uses the correct change in function value but divides by an incorrect interval length of 1.5.",
               "9": "This is f(3), not the average.", "27": "This is the endpoint cube before dividing by the needed factors."}),
]

# ---------------------------------------------------------------- variants
V = []


def add(vid, seed, unit, diff_, title, stem, stimulus, correct, wrong, key_calc, wrong_calcs=None, change=""):
    V.append(dict(id=vid, seed=seed, unit=unit, diff=diff_, title=title, stem=stem, stimulus=stimulus, correct=correct,
                  wrong=wrong, key_calc=key_calc, wrong_calcs=wrong_calcs or [None, None, None], change=change))


# ---- Unit 1  (seed 001: factor-and-cancel limit)
add("001-v1", "apcalcab-mcq-001", 1, "easy", "Calibration Ratio Near a Reference Setting",
    "A sensor's calibration ratio at setting x is R(x) = (x^2 - 25)/(x - 5) for x != 5. What is the limit of R(x) as x approaches 5?", None,
    ("10", "Since x^2 - 25 = (x - 5)(x + 5), R(x) = x + 5 for x != 5, so the limit as x approaches 5 is 10."),
    [("0", "Substituting x = 5 into the numerator alone gives 0, but the denominator is also 0, so the quotient is not evaluated this way."),
     ("5", "This is the value x approaches, not the limit of the simplified expression x + 5."),
     ("The limit does not exist", "The factor x - 5 cancels, leaving a hole at x = 5 that does not prevent the two-sided limit from existing.")],
    lambda: same(limit((x**2 - 25) / (x - 5), x, 5), "10"),
    [None, lambda: same(5, "5"), None], "numbers 3,9 -> 5,25; context: bare limit -> sensor calibration ratio")
add("001-v2", "apcalcab-mcq-001", 1, "easy", "Rate Ratio Near a Negative Value",
    "A pump's efficiency ratio is E(x) = (x^2 - 4)/(x + 2) for x != -2. What is the limit of E(x) as x approaches -2?", None,
    ("-4", "Since x^2 - 4 = (x - 2)(x + 2), E(x) = x - 2 for x != -2, and its limit as x approaches -2 is -4."),
    [("0", "Substituting x = -2 into the numerator alone gives 0, but the denominator is also 0, so this does not evaluate the quotient."),
     ("-2", "This is the value x approaches, not the limit of the simplified expression x - 2."),
     ("The limit does not exist", "The factor x + 2 cancels, so the hole at x = -2 does not prevent the two-sided limit from existing.")],
    lambda: same(limit((x**2 - 4) / (x + 2), x, -2), "-4"),
    [None, lambda: same(-2, "-2"), None], "numbers 3,9 -> -2,4 (negative approach value, sign of result flips); context: pump efficiency")

# ---- Unit 2  (seed 026: product rule then evaluate)
add("026-v1", "apcalcab-mcq-026", 2, "medium", "Charge Rate of a Battery Model",
    "The charge in a battery is modeled by Q(t) = t^3 e^t. What is Q'(1)?", "No calculator is permitted.",
    ("4e", "The product rule gives Q'(t) = 3t^2 e^t + t^3 e^t. At t = 1 this is 3e + e = 4e."),
    [("3e", "Differentiates only the polynomial factor: 3t^2 e^t evaluated at t = 1 is 3e, dropping the t^3 e^t term."),
     ("e", "Differentiates only the exponential factor: t^3 e^t evaluated at t = 1 is e, dropping the 3t^2 e^t term."),
     ("3+e", "Adds the two derivatives 3t^2 and e^t instead of applying the product rule: 3(1)^2 + e^1 = 3 + e.")],
    lambda: same(diff(t**3 * exp(t), t).subs(t, 1), "4e"),
    [lambda: same(diff(t**3, t).subs(t, 1) * exp(1), "3e"), lambda: same(1 * diff(exp(t), t).subs(t, 1), "e"),
     lambda: same(diff(t**3, t).subs(t, 1) + diff(exp(t), t).subs(t, 1), "3+e")], "x^2 e^x -> t^3 e^t; context: battery charge")
add("026-v2", "apcalcab-mcq-026", 2, "medium", "Growth Model With a Logarithm Factor",
    "A population index is modeled by g(x) = x^3 ln x for x > 0. What is g'(e)?", "No calculator is permitted.",
    ("4e^2", "The product rule gives g'(x) = 3x^2 ln x + x^3 (1/x) = 3x^2 ln x + x^2. At x = e this is 3e^2 + e^2 = 4e^2."),
    [("e^2", "Differentiates only the logarithm: x^3 (1/x) evaluated at x = e is e^2, dropping the 3x^2 ln x term."),
     ("3e^2", "Differentiates only the polynomial: 3x^2 ln x evaluated at x = e is 3e^2, dropping the x^2 term."),
     ("3e^2+1/e", "Adds the two derivatives 3x^2 and 1/x instead of applying the product rule: 3e^2 + 1/e.")],
    lambda: same(diff(x**3 * log(x), x).subs(x, E), "4e^2"),
    [lambda: same((x**3 * diff(log(x), x)).subs(x, E), "e^2"), lambda: same((diff(x**3, x) * log(x)).subs(x, E), "3e^2"),
     lambda: same((diff(x**3, x) + diff(log(x), x)).subs(x, E), "3e^2+1/e")], "x^2 e^x -> x^3 ln x (new second factor); context: population index")

# ---- Unit 3  (seed 029: chain rule)
add("029-v1", "apcalcab-mcq-029", 3, "medium", "Voltage Signal With a Squared Inner Term",
    "A sensor voltage is modeled by V(x) = cos(3x^2). What is V'(x)?", "No calculator is permitted.",
    ("-6x sin(3x^2)", "By the chain rule, V'(x) = -sin(3x^2) times the derivative of the inner function 3x^2, which is 6x."),
    [("-sin(3x^2)", "Omits the inner derivative 6x."),
     ("-sin(6x)", "Moves the inner derivative inside the sine, replacing 3x^2 by 6x instead of multiplying by it."),
     ("6x sin(3x^2)", "Uses the derivative of cosine as +sin instead of -sin, losing the negative sign.")],
    lambda: same(diff(cos(3 * x**2), x), "-6x sin(3x^2)"),
    [lambda: same(-sin(3 * x**2), "-sin(3x^2)"), lambda: same(-sin(6 * x), "-sin(6x)"), lambda: same(6 * x * sin(3 * x**2), "6x sin(3x^2)")],
    "sin(x^2) -> cos(3x^2); context: sensor voltage; new sign trap")
add("029-v2", "apcalcab-mcq-029", 3, "medium", "Exponential Response to a Sine Input",
    "A response function is R(x) = e^(sin x). What is R'(x)?", "No calculator is permitted.",
    ("cos(x) e^(sin(x))", "By the chain rule, R'(x) = e^(sin x) times the derivative of the inner function sin x, which is cos x."),
    [("e^(sin(x))", "Omits the inner derivative cos x."),
     ("e^(cos(x))", "Moves the inner derivative inside the exponent, replacing sin x by cos x."),
     ("sin(x) e^(sin(x))", "Uses sin x as the derivative of the inner function sin x, instead of cos x.")],
    lambda: same(diff(exp(sin(x)), x), "cos(x) e^(sin(x))"),
    [lambda: same(exp(sin(x)), "e^(sin(x))"), lambda: same(exp(cos(x)), "e^(cos(x))"), lambda: same(sin(x) * exp(sin(x)), "sin(x) e^(sin(x))")],
    "outer function sin -> exp (new outer function); inner x^2 -> sin x; context: response function")

# ---- Unit 4  (seed 031: velocity from position, calculator)
add("031-v1", "apcalcab-mcq-031", 4, "medium", "Cart Velocity on a Track",
    "A cart has position s(t) = t^3 - 5.2t^2 + 3.4t + 8 meters. What is its velocity at t = 2.6 seconds, to the nearest hundredth?",
    "A graphing calculator is required.",
    ("-3.36 m/s", "The velocity is s'(t) = 3t^2 - 10.4t + 3.4. At t = 2.6 this is 20.28 - 27.04 + 3.4 = -3.36 m/s."),
    [("2.60 m/s", "Reports the time as though it were a velocity."),
     ("-0.74 m/s", "Evaluates the position s(2.6) rather than the velocity."),
     ("10.16 m/s", "Evaluates 3t^2 - 5.2t + 3.4, forgetting to double the coefficient of the quadratic term when differentiating t^2.")],
    lambda: num(diff(t**3 - Rational(52, 10) * t**2 + Rational(34, 10) * t + 8, t).subs(t, Rational(26, 10)), 2, " m/s"),
    [lambda: "2.60 m/s", lambda: num((t**3 - Rational(52, 10) * t**2 + Rational(34, 10) * t + 8).subs(t, Rational(26, 10)), 2, " m/s"),
     lambda: num((3 * t**2 - Rational(52, 10) * t + Rational(34, 10)).subs(t, Rational(26, 10)), 2, " m/s")],
    "coefficients and time changed; context: cart on a track; distractor patterns kept")
add("031-v2", "apcalcab-mcq-031", 4, "medium", "Speed of a Falling Marker",
    "A marker's height above the ground is s(t) = 2t^3 - 7.3t^2 + 1.9t + 12 meters. What is its velocity at t = 1.8 seconds, to the nearest hundredth?",
    "A graphing calculator is required.",
    ("-4.94 m/s", "The velocity is s'(t) = 6t^2 - 14.6t + 1.9. At t = 1.8 this is 19.44 - 26.28 + 1.9 = -4.94 m/s."),
    [("1.80 m/s", "Reports the time as though it were a velocity."),
     ("3.43 m/s", "Evaluates the position s(1.8) rather than the velocity."),
     ("8.20 m/s", "Evaluates 6t^2 - 7.3t + 1.9, forgetting to double the coefficient of the quadratic term when differentiating t^2.")],
    lambda: num(diff(2 * t**3 - Rational(73, 10) * t**2 + Rational(19, 10) * t + 12, t).subs(t, Rational(18, 10)), 2, " m/s"),
    [lambda: "1.80 m/s", lambda: num((2 * t**3 - Rational(73, 10) * t**2 + Rational(19, 10) * t + 12).subs(t, Rational(18, 10)), 2, " m/s"),
     lambda: num((6 * t**2 - Rational(73, 10) * t + Rational(19, 10)).subs(t, Rational(18, 10)), 2, " m/s")],
    "cubic leading coefficient 1 -> 2 and different numbers; context: falling marker")

# ---- Unit 5  (seed 038: concavity from f'')
add("038-v1", "apcalcab-mcq-038", 5, "easy", "Curvature of a Ramp Profile",
    "If f''(x) = 4x + 8, on which interval is the graph of f concave up?", "No calculator is permitted.",
    ("x > -2", "The graph is concave up where f''(x) > 0. Solving 4x + 8 > 0 gives x > -2."),
    [("x < -2", "Reverses the inequality: f'' is negative, not positive, for x < -2."),
     ("x > 2", "Makes a sign error when solving, moving +8 across the inequality as +8 instead of -8."),
     ("x > 0", "Uses the sign of x rather than the sign of the second derivative.")],
    lambda: relt(4 * x + 8 > 0),
    [lambda: relt(4 * x + 8 < 0), lambda: relt(4 * x - 8 > 0), None], "6x-12 -> 4x+8 (positive intercept, root at -2); context: ramp profile")
add("038-v2", "apcalcab-mcq-038", 5, "medium", "Concavity With a Negative Leading Coefficient",
    "If f''(x) = 18 - 3x, on which interval is the graph of f concave up?", "No calculator is permitted.",
    ("x < 6", "The graph is concave up where f''(x) > 0. Solving 18 - 3x > 0 gives -3x > -18, and dividing by -3 reverses the inequality: x < 6."),
    [("x > 6", "Divides by -3 without reversing the inequality, giving x > 6."),
     ("x < -6", "Makes a sign error when solving, treating 18 - 3x > 0 as 3x + 18 < 0."),
     ("x > 0", "Uses the sign of x rather than the sign of the second derivative.")],
    lambda: relt(18 - 3 * x > 0),
    [lambda: relt(3 * x - 18 > 0), lambda: relt(18 + 3 * x < 0), lambda: relt(x > 0)], "negative leading coefficient (inequality flips); context: none, pure f''")

# ---- Unit 6  (seed 017: accumulation function decreasing)
add("017-v1", "apcalcab-mcq-017", 6, "medium", "Accumulated Stock Level Falling",
    "B(x) = 25 + ∫[0 to x](u^2 - 6u + 8)du. On which interval is B decreasing?", None,
    ("(2, 4)", "By the Fundamental Theorem of Calculus, B'(x) = x^2 - 6x + 8 = (x - 2)(x - 4), which is negative between its zeros."),
    [("(-oo, 2)", "B'(x) is positive for x < 2, so B is increasing there."),
     ("(4, oo)", "B'(x) is positive for x > 4, so B is increasing there."),
     ("B never decreases", "B'(x) is negative on (2, 4), so B does decrease there.")],
    lambda: intervaltxt(solveset(diff(25 + integrate(u**2 - 6 * u + 8, (u, 0, x)), x) < 0, x, S.Reals)),
    [lambda: intervaltxt(solveset(x**2 - 6 * x + 8 > 0, x, Interval(-oo, 2))), None, None], "u^2-4u+3 -> u^2-6u+8 (zeros 2,4); context: stock level")
add("017-v2", "apcalcab-mcq-017", 6, "medium", "Decreasing After a Peak Rate",
    "Q(t) = 5 + ∫[0 to t](12 - u - u^2)du for t >= 0. On which interval is Q decreasing?", None,
    ("(3, oo)", "By the Fundamental Theorem of Calculus, Q'(t) = 12 - t - t^2 = -(t - 3)(t + 4), which is negative for t > 3 when t >= 0."),
    [("(0, 3)", "Q'(t) is positive on (0, 3), so Q is increasing there."),
     ("(0, oo)", "Q'(t) is positive on (0, 3), so Q is not decreasing on the whole interval."),
     ("Q never decreases", "Q'(t) is negative for t > 3, so Q does decrease there.")],
    lambda: intervaltxt(solveset(diff(5 + integrate(12 - u - u**2, (u, 0, t)), t) < 0, t, Interval(0, oo))),
    [lambda: intervaltxt(solveset(12 - t - t**2 > 0, t, Interval(0, oo))), None, None],
    "integrand with negative leading coefficient and domain t>=0; decreasing interval is unbounded; context: rate model")

# ---- Unit 7  (seed np2-006: separable DE with IC)
add("np2-006-v1", "apcalcab-mcq-np2-006", 7, "medium", "Separable Growth With an Initial Value",
    "If dy/dx = xy and y(0) = 4, then y(2) = ?", None,
    ("4e^2", "Separating variables gives ln|y| = x^2/2 + C; y(0) = 4 gives C = ln 4, so y = 4e^(x^2/2). At x = 2, y = 4e^2."),
    [("4e^4", "Integrates x as x^2 instead of x^2/2, giving y = 4e^(x^2) and y(2) = 4e^4."),
     ("e^2", "Omits the initial condition: C = 0 gives y = e^(x^2/2), so y(2) = e^2."),
     ("12", "Treats y as the constant 4 while integrating, giving y = 2x^2 + 4 and y(2) = 12.")],
    lambda: same(4 * exp(Rational(1, 2) * 2**2), "4e^2"),
    [lambda: same(4 * exp(2**2), "4e^4"), lambda: same(exp(Rational(1, 2) * 2**2), "e^2"), lambda: same((2 * x**2 + 4).subs(x, 2), "12")],
    "coefficient 2x -> x, y(0)=3 -> 4, evaluate at 2 instead of 1")
add("np2-006-v2", "apcalcab-mcq-np2-006", 7, "medium", "Decay Model With an Initial Concentration",
    "A concentration y satisfies dy/dx = -2xy with y(0) = 5. What is y(1)?", None,
    ("5/e", "Separating variables gives ln|y| = -x^2 + C; y(0) = 5 gives C = ln 5, so y = 5e^(-x^2). At x = 1, y = 5/e."),
    [("5e", "Drops the negative sign, giving y = 5e^(x^2) and y(1) = 5e."),
     ("5/e^2", "Integrates -2x as -2x^2 instead of -x^2, giving y = 5e^(-2x^2) and y(1) = 5/e^2."),
     ("0", "Treats y as the constant 5 while integrating, giving y = 5 - 5x^2 and y(1) = 0.")],
    lambda: same(5 * exp(-1), "5/e"),
    [lambda: same(5 * exp(1), "5e"), lambda: same(5 * exp(-2), "5/e^2"), lambda: same((5 - 5 * x**2).subs(x, 1), "0")],
    "growth -> decay (negative coefficient); context: concentration")

# ---- Unit 8  (seed 016: average value)
add("016-v1", "apcalcab-mcq-016", 8, "medium", "Average Cost Over a Production Range",
    "The marginal cost of a product is modeled by c(x) = 3x^2 dollars per unit for 1 <= x <= 3. What is the average value of c on [1, 3]?", None,
    ("13", "The average value is (1/(3 - 1)) times the integral of 3x^2 from 1 to 3, which is (1/2)(27 - 1) = 13."),
    [("26", "Computes the integral (26) but omits the division by the interval length 3 - 1 = 2."),
     ("27", "This is c(3), the value at the right endpoint, not the average."),
     ("15", "Averages the endpoint values (3 + 27)/2 instead of integrating.")],
    lambda: same(integrate(3 * x**2, (x, 1, 3)) / 2, "13"),
    [lambda: same(integrate(3 * x**2, (x, 1, 3)), "26"), lambda: same((3 * x**2).subs(x, 3), "27"), lambda: same((3 * 1 + 3 * 9) / S(2), "15")],
    "f(x)=x^2 on [0,3] -> 3x^2 on [1,3]; context: marginal cost; distractors: no division, endpoint value, endpoint average")
add("016-v2", "apcalcab-mcq-016", 8, "medium", "Average Power Over an Interval",
    "The power drawn by a device is P(t) = t^2 + 2t watts for 0 <= t <= 4. What is the average value of P on [0, 4]?", None,
    ("28/3", "The average value is (1/4) times the integral of t^2 + 2t from 0 to 4, which is (1/4)(64/3 + 16) = (1/4)(112/3) = 28/3."),
    [("112/3", "Computes the integral (112/3) but omits the division by the interval length 4."),
     ("24", "This is P(4), the value at the right endpoint, not the average."),
     ("12", "Averages the endpoint values (0 + 24)/2 instead of integrating.")],
    lambda: same(integrate(t**2 + 2 * t, (t, 0, 4)) / 4, "28/3"),
    [lambda: same(integrate(t**2 + 2 * t, (t, 0, 4)), "112/3"), lambda: same((t**2 + 2 * t).subs(t, 4), "24"), lambda: same((0 + 24) / S(2), "12")],
    "f(x)=x^2 on [0,3] -> t^2+2t on [0,4] (non-integer answer); context: device power")


def jaccard(a, b):
    wa, wb = set(re.findall(r"\w+", a.lower())), set(re.findall(r"\w+", b.lower()))
    return len(wa & wb) / len(wa | wb) if wa | wb else 0


def seed_text(s):
    return s["stem"] + " " + " ".join([s["correct"]] + s["wrong"])


def variant_text(v):
    return v["stem"] + " " + " ".join([v["correct"][0]] + [w[0] for w in v["wrong"]])


def check():
    seeds = {s["key"]: s for s in SEEDS}
    fails = []
    for v in V:
        try:
            got = v["key_calc"]()
            if got != v["correct"][0]:
                fails.append(f"{v['id']}: key calc {got!r} != keyed {v['correct'][0]!r}")
        except Exception as e:  # noqa
            fails.append(f"{v['id']}: key calc raised {e}")
        for i, wc in enumerate(v["wrong_calcs"]):
            if wc is None:
                continue
            try:
                got = wc()
                if got != v["wrong"][i][0]:
                    fails.append(f"{v['id']}: distractor {i} calc {got!r} != text {v['wrong'][i][0]!r}")
            except Exception as e:  # noqa
                fails.append(f"{v['id']}: distractor {i} calc raised {e}")
        texts = [v["correct"][0]] + [w[0] for w in v["wrong"]]
        if len({t.lower().strip() for t in texts}) != 4:
            fails.append(f"{v['id']}: duplicate choice text")
        for txt, rat in [v["correct"]] + v["wrong"]:
            if not rat.strip():
                fails.append(f"{v['id']}: blank rationale")
        j = jaccard(variant_text(v), seed_text(seeds[v["seed"]]))
        if j >= 0.7:
            fails.append(f"{v['id']}: too similar to seed ({j:.2f})")
    for a, b in itertools.combinations([v for v in V], 2):
        if a["seed"] == b["seed"] and jaccard(variant_text(a), variant_text(b)) >= 0.7:
            fails.append(f"{a['id']} / {b['id']}: sibling similarity too high")
    if fails:
        print("FAILED:")
        for f in fails:
            print("  -", f)
        return 1
    print(f"OK: {len(V)} variants verified against {len(SEEDS)} seeds; max seed similarity "
          f"{max(jaccard(variant_text(v), seed_text(seeds[v['seed']])) for v in V):.2f}")
    return 0


L = "ABCD"


def shuffled(correct_txt, wrong_txts, rats):
    rng = secrets.SystemRandom()
    ch = [(correct_txt, True)] + [(w, False) for w in wrong_txts]
    rng.shuffle(ch)
    return ch


def export(math_out, ced_out, seeds_out):
    rows, ced, seedrows = [], [], []
    for v in V:
        ch = shuffled(v["correct"][0], [w[0] for w in v["wrong"]], None)
        rat = {v["correct"][0]: v["correct"][1], **{w[0]: w[1] for w in v["wrong"]}}
        key = f"pilot-{v['id']}"
        rows.append(dict(key=key, kind="mcq", stem=v["stem"] + (("\n" + v["stimulus"]) if v["stimulus"] else ""),
                         choices=[dict(label=L[i], text=c[0]) for i, c in enumerate(ch)],
                         keyed_label=next(L[i] for i, c in enumerate(ch) if c[1]),
                         rationales={L[i]: rat[c[0]] for i, c in enumerate(ch)}))
        ced.append(dict(content_key=key, item_type="mcq", stem=v["stem"], stimulus=v["stimulus"],
                        criteria=[f"{L[i]}." + (" (correct)" if c[1] else "") + f" {c[0]}" for i, c in enumerate(ch)]))
    for s in SEEDS:
        ch = shuffled(s["correct"], s["wrong"], None)
        seedrows.append(dict(key=f"pilotseed-{s['key']}", kind="mcq", stem=s["stem"] + (("\n" + s["stimulus"]) if s["stimulus"] else ""),
                             choices=[dict(label=L[i], text=c[0]) for i, c in enumerate(ch)],
                             keyed_label=next(L[i] for i, c in enumerate(ch) if c[1]),
                             rationales={L[i]: s["rats"][c[0]] for i, c in enumerate(ch)}))
    json.dump(rows, open(math_out, "w"), indent=1)
    json.dump(ced, open(ced_out, "w"), indent=1)
    json.dump(seedrows, open(seeds_out, "w"), indent=1)
    json.dump([dict(id=f"pilot-{v['id']}", seed=v["seed"], unit=v["unit"], title=v["title"], change=v["change"]) for v in V],
              open(Path(math_out).with_name("pilot_manifest.json"), "w"), indent=1)
    print(len(rows), "variants,", len(seedrows), "seeds exported")


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "check"
    if cmd == "check":
        sys.exit(check())
    if cmd == "export":
        if check():
            sys.exit(1)
        export(*sys.argv[2:5])
