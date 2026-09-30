# Variants (3 each) of original MCQs 021-029 (Unit 1, topics 1.13-1.15).
import sympy as sp
from sympy import symbols, limit, sqrt, exp, sin, cos, tan, pi, Rational, oo, Interval, solveset, S
from vlib import M, fmt

x, t, p, v, q = symbols("x t p v q", real=True)


def _den(expr, var):
    return sp.fraction(expr)[1]


def _real_roots(expr, var):
    return sorted([r for r in sp.solve(_den(expr, var), var) if r.is_real])


def disc(expr, var):
    """Classify every zero of the denominator: 'R' (removable, finite two-sided limit) or 'I' (infinite)."""
    out = {}
    for r in _real_roots(expr, var):
        lp, lm = limit(expr, var, r, "+"), limit(expr, var, r, "-")
        out[r] = "R" if (lp.is_finite and lm.is_finite and lp == lm) else "I"
    return out


def _names(rs):
    n = ["x = " + fmt(r) for r in rs]
    if len(n) == 1:
        return n[0]
    return ", ".join(n[:-1]) + " and " + n[-1]


def build(d):
    rem = [r for r in sorted(d) if d[r] == "R"]
    inf = [r for r in sorted(d) if d[r] == "I"]
    if not rem or not inf:
        rs, T = (rem, "Removable") if rem else (inf, "Infinite")
        if len(rs) == 2:
            return f"{T} at both {_names(rs)}"
        return f"{T} at {_names(rs)}"
    sep = "; " if len(d) > 2 else " and "
    return f"Removable at {_names(rem)}{sep}infinite at {_names(inf)}"


def flip(d):
    return {r: ("I" if k == "R" else "R") for r, k in d.items()}


def vas(expr, var):
    rs = [r for r, k in disc(expr, var).items() if k == "I"]
    return ("x = " + fmt(rs[0]) + " only") if len(rs) == 1 else _names(rs)


def hz(expr, var):
    a, b = limit(expr, var, oo), limit(expr, var, -oo)
    if a == b:
        return "y = " + fmt(a) + " only"
    return "y = " + fmt(a) + " and y = " + fmt(b)


def tr(val):
    return fmt(val).replace("*", "")


def lst(vals):
    vals = [tr(z) for z in vals]
    return vals[0] + (" only" if len(vals) == 1 else "")


# ------------------------------------------------------------------ 021
f21a = (x**2 - x - 12) / (x**2 + x - 20)
f21b = (x**2 - 1) / (x**3 - 3 * x**2 + 2 * x)
f21c = (x**2 - 2 * x) / (x**3 - 4 * x**2 + 4 * x)

V21 = [
    M("021-v1", "021", "hard", "Classifying Discontinuities of a Gain Ratio",
      "A sensor's gain ratio is modeled by g(x) = (x^2 - x - 12)/(x^2 + x - 20), where x is the input setting. Which of the following describes the discontinuities of g?",
      (build(disc(f21a, x)),
       "Factoring gives g(x) = (x - 4)(x + 3)/((x + 5)(x - 4)). The factor x - 4 cancels, so the limit at x = 4 is 7/9 and that discontinuity is removable. The factor x + 5 stays in the denominator while the numerator is 18 at x = -5, so g is unbounded near -5."),
      [("Infinite at both x = -5 and x = 4",
        "Both are zeros of the denominator, but at x = 4 the factor x - 4 also appears in the numerator and cancels, so the limit there is the finite value 7/9."),
       ("Removable at both x = -5 and x = 4",
        "At x = -5 the numerator is 25 + 5 - 12 = 18, not 0, so no factor cancels and g is unbounded near -5. Only x = 4 is removable."),
       ("Removable at x = -5 and infinite at x = 4",
        "This reverses the roles. The common factor x - 4 cancels at x = 4, making that point removable, while x + 5 remains in the denominator at x = -5.")],
      calc=lambda: build(disc(f21a, x)),
      wrong_calcs=[lambda: build({r: "I" for r in disc(f21a, x)}), lambda: build({r: "R" for r in disc(f21a, x)}),
                   lambda: build(flip(disc(f21a, x)))],
      change="numbers: (x^2-9)/(x^2-5x+6) -> (x^2-x-12)/(x^2+x-20), hole moves to positive root; context: sensor gain ratio"),
    M("021-v2", "021", "hard", "Three Zeros of a Denominator in a Flow Model",
      "The ratio of outflow to inflow in a pipe network is modeled by r(x) = (x^2 - 1)/(x^3 - 3x^2 + 2x), where x is the valve setting. Which of the following describes the discontinuities of r?",
      (build(disc(f21b, x)),
       "Factoring gives r(x) = (x - 1)(x + 1)/(x(x - 1)(x - 2)). The factor x - 1 cancels, so the discontinuity at x = 1 is removable. After cancelling, r(x) = (x + 1)/(x(x - 2)), so the limit at x = 1 is 2/(1 * (-1)) = -2. The reduced numerator x + 1 equals 1 at x = 0 while the denominator x(x - 2) is 0 there, and at x = 2 the numerator is 3 while the denominator is 0, so x = 0 and x = 2 are vertical asymptotes and r is unbounded near them."),
      [("Infinite at x = 0, x = 1 and x = 2",
        "All three are zeros of the denominator, but at x = 1 the factor x - 1 also appears in the numerator and cancels, so the limit there is finite."),
       ("Removable at x = 0 and x = 2; infinite at x = 1",
        "This reverses the roles. It is at x = 1 that a common factor cancels; the factors x and x - 2 remain in the denominator, so x = 0 and x = 2 are infinite."),
       ("Removable at x = -1; infinite at x = 0 and x = 2",
        "This reads the zero of the numerator, x = -1, as a removable discontinuity. But r(-1) = 0 is defined, so r is continuous there; the removable point is where a factor cancels, x = 1.")],
      calc=lambda: build(disc(f21b, x)),
      wrong_calcs=[lambda: build({r: "I" for r in disc(f21b, x)}), lambda: build(flip(disc(f21b, x))), None],
      change="numbers: quadratic/quadratic -> quadratic/cubic with three zeros; context: pipe flow ratio; adds numerator-zero distractor"),
    M("021-v3", "021", "hard", "A Repeated Factor Leaves an Infinite Discontinuity",
      "A lens-maker models a magnification ratio by m(x) = (x^2 - 2x)/(x^3 - 4x^2 + 4x), where x is the object distance in a scaled unit. Which of the following describes the discontinuities of m?",
      (build(disc(f21c, x)),
       "Factoring gives m(x) = x(x - 2)/(x(x - 2)^2). The factor x cancels completely, so the limit at x = 0 is -1/2 and that point is removable. After one factor x - 2 cancels, x - 2 is still in the denominator, so m behaves like 1/(x - 2) and is unbounded near 2."),
      [("Removable at both x = 0 and x = 2",
        "This notices that x - 2 cancels once, but the denominator has (x - 2)^2, so a factor x - 2 remains and m is still unbounded near 2."),
       ("Infinite at both x = 0 and x = 2",
        "Both are zeros of the denominator, but the factor x appears in the numerator and cancels completely, so the limit at x = 0 is the finite value -1/2."),
       ("Removable at x = 2 and infinite at x = 0",
        "This reverses the roles. The factor x cancels entirely, making x = 0 removable, while (x - 2) is only partly cancelled, leaving an infinite discontinuity at x = 2.")],
      calc=lambda: build(disc(f21c, x)),
      wrong_calcs=[lambda: build({r: "R" for r in disc(f21c, x)}), lambda: build({r: "I" for r in disc(f21c, x)}),
                   lambda: build(flip(disc(f21c, x)))],
      change="numbers: adds a squared factor in the denominator so only one of two cancellations is complete; context: lens magnification"),
]

# ------------------------------------------------------------------ 022
V22 = [
    M("022-v1", "022", "easy", "One-Sided Limit of a Strain Ratio From Below",
      "An engineer models the strain ratio on a support cable by S(t) = (3 - t)/(t^2 - 16), where t is a load parameter that rises toward 4. What is lim(t->4-) (3 - t)/(t^2 - 16)?",
      (fmt(limit((3 - t) / (t**2 - 16), t, 4, "-")),
       "As t approaches 4 from the left, the numerator approaches -1, which is negative. The denominator (t - 4)(t + 4) is a small negative number times a number near 8, so it is small and negative. A negative number divided by a small negative number is a large positive number, so the quotient grows without bound."),
      [("-infinity",
        "This notices that the numerator is negative but overlooks that the denominator is also negative for t slightly less than 4, so the quotient is positive."),
       ("0",
        "The denominator approaches 0 while the numerator approaches -1. A small denominator makes the quotient large in magnitude, not small."),
       ("-1/8",
        "This substitutes t = 4 into the factors that do not vanish, (3 - t)/(t + 4), and ignores the factor t - 4 that approaches 0 in the denominator.")],
      calc=lambda: fmt(limit((3 - t) / (t**2 - 16), t, 4, "-")),
      wrong_calcs=[None, None, lambda: fmt(limit((3 - t) / (t + 4), t, 4))],
      change="numbers: 2x/(x^2-9) at 3+ -> (3-t)/(t^2-16) at 4-, both signs negative; context: cable strain"),
    M("022-v2", "022", "easy", "One-Sided Limit of a Mixing Ratio",
      "In a mixing model, the ratio of solute to solvent is Q(p) = (p + 5)/(p^2 + 5p + 6), where p is a pressure setting that decreases toward -3 from above. What is lim(p->-3+) (p + 5)/(p^2 + 5p + 6)?",
      (fmt(limit((p + 5) / (p**2 + 5 * p + 6), p, -3, "+")),
       "Factor the denominator as (p + 2)(p + 3). As p approaches -3 from the right, p + 3 is a small positive number and p + 2 is near -1, so the denominator is small and negative. The numerator approaches 2, which is positive, so the quotient is a large negative number."),
      [("infinity",
        "This treats p + 2 as positive. Near p = -3 it is close to -1, so the denominator is negative even though p + 3 is positive."),
       ("0",
        "The denominator approaches 0 while the numerator approaches 2. A small denominator makes the quotient large in magnitude, not small."),
       ("-2",
        "This cancels or ignores the vanishing factor p + 3 and evaluates (p + 5)/(p + 2) at p = -3. The factor p + 3 is not in the numerator, so nothing cancels.")],
      calc=lambda: fmt(limit((p + 5) / (p**2 + 5 * p + 6), p, -3, "+")),
      wrong_calcs=[None, None, lambda: fmt(limit((p + 5) / (p + 2), p, -3))],
      change="numbers: unfactored quadratic denominator with a second nonvanishing factor, answer -infinity; context: solute mixing"),
    M("022-v3", "022", "easy", "One-Sided Limit at a Speed Barrier",
      "A model for the energy needed to move an object gives E(v) = (3 - 2v)/(1 - v^2), where v is the fraction of a wave speed and v < 1. What is lim(v->1-) (3 - 2v)/(1 - v^2)?",
      (fmt(limit((3 - 2 * v) / (1 - v**2), v, 1, "-")),
       "As v approaches 1 from the left, the numerator approaches 1, which is positive. For v slightly less than 1, v^2 < 1, so 1 - v^2 is a small positive number. A positive number divided by a small positive number grows without bound."),
      [("-infinity",
        "This treats 1 - v^2 as negative. That is true for v > 1, but for v slightly less than 1, v^2 is slightly less than 1 and the denominator is positive."),
       ("0",
        "The denominator approaches 0 while the numerator approaches 1. A small denominator makes the quotient large, not small."),
       ("1/2",
        "This factors 1 - v^2 as (1 - v)(1 + v), then ignores the vanishing factor 1 - v and evaluates (3 - 2v)/(1 + v) at v = 1.")],
      calc=lambda: fmt(limit((3 - 2 * v) / (1 - v**2), v, 1, "-")),
      wrong_calcs=[None, None, lambda: fmt(limit((3 - 2 * v) / (1 + v), v, 1))],
      change="numbers: reversed-order denominator 1 - v^2 approached from the left; context: energy near a speed limit"),
]

# ------------------------------------------------------------------ 023
f23a = (x**2 + 2 * x - 3) / (x**3 - 4 * x**2 - 7 * x + 10)
f23b = (2 * x**2 + 5 * x - 3) / (2 * x**2 - 3 * x + 1)
f23c = (x**2 - 4) / (x**3 - 4 * x**2 + 4 * x)

V23 = [
    M("023-v1", "023", "medium", "Asymptotes of a Circuit Response",
      "The response of a circuit is modeled by f(x) = (x^2 + 2x - 3)/(x^3 - 4x^2 - 7x + 10), where x is the input frequency setting. The denominator factors as (x - 1)(x + 2)(x - 5). Which of the following gives all vertical asymptotes of the graph of f?",
      (vas(f23a, x),
       "The numerator factors as (x + 3)(x - 1). The factor x - 1 cancels, leaving a hole at x = 1. In the simplified form (x + 3)/((x + 2)(x - 5)), the denominator is 0 at x = -2 and x = 5 while the numerator is 1 and 8 there, so both are vertical asymptotes."),
      [("x = -2, x = 1 and x = 5",
        "These are all the zeros of the denominator, but at x = 1 the factor x - 1 cancels with the numerator, leaving a hole rather than an asymptote."),
       ("x = -3, x = -2 and x = 5",
        "x = -3 is a zero of the numerator, so f(-3) = 0. It is not a zero of the denominator, so there is no asymptote there."),
       ("x = 1 only",
        "At x = 1 the common factor cancels, leaving a hole. The asymptotes are at the zeros of the denominator that remain after simplifying, x = -2 and x = 5.")],
      calc=lambda: vas(f23a, x),
      wrong_calcs=[lambda: _names(_real_roots(f23a, x)), None,
                   lambda: "x = " + fmt([r for r, k in disc(f23a, x).items() if k == "R"][0]) + " only"],
      change="numbers: cubic denominator with three zeros and one hole; context: circuit response; adds numerator-zero distractor"),
    M("023-v2", "023", "medium", "Asymptotes of an Average-Cost Model With Fractional Zeros",
      "A firm models its average cost per unit by f(x) = (2x^2 + 5x - 3)/(2x^2 - 3x + 1), where x is a production level. Which of the following gives all vertical asymptotes of the graph of f?",
      (vas(f23b, x),
       "Factoring gives f(x) = (2x - 1)(x + 3)/((2x - 1)(x - 1)). The factor 2x - 1 cancels, leaving a hole at x = 1/2. In the simplified form (x + 3)/(x - 1), the denominator is 0 at x = 1 while the numerator is 4, so there is a vertical asymptote at x = 1."),
      [("x = 1/2 and x = 1",
        "Both are zeros of the denominator, but the factor 2x - 1 cancels with the numerator, so x = 1/2 is a hole rather than an asymptote."),
       ("x = 1/2 only",
        "At x = 1/2 the common factor cancels, leaving a hole. The remaining denominator factor x - 1 gives the asymptote at x = 1."),
       ("x = -3 and x = 1",
        "x = -3 is a zero of the numerator, so f(-3) = 0. It is not a zero of the denominator, so the graph has no asymptote there.")],
      calc=lambda: vas(f23b, x),
      wrong_calcs=[lambda: _names(_real_roots(f23b, x)),
                   lambda: "x = " + fmt([r for r, k in disc(f23b, x).items() if k == "R"][0]) + " only", None],
      change="numbers: non-monic factors give fractional hole x = 1/2; context: average cost per unit"),
    M("023-v3", "023", "medium", "A Squared Factor Keeps an Asymptote",
      "The flow rate through a valve is modeled by f(x) = (x^2 - 4)/(x^3 - 4x^2 + 4x), where x is the valve opening. Note that x^3 - 4x^2 + 4x = x(x - 2)^2. Which of the following gives all vertical asymptotes of the graph of f?",
      (vas(f23c, x),
       "Factoring gives f(x) = (x - 2)(x + 2)/(x(x - 2)^2). One factor x - 2 cancels, leaving (x + 2)/(x(x - 2)). This is still zero in the denominator at x = 0 and x = 2, and the numerator is 2 and 4 there, so both are vertical asymptotes."),
      [("x = 0 only",
        "This assumes the factor x - 2 cancels completely. The denominator has (x - 2)^2, so one factor x - 2 remains after cancelling and f is unbounded near 2."),
       ("x = 0, x = 2 and x = -2",
        "x = -2 is a zero of the numerator, so f(-2) = 0. It is not a zero of the denominator, so there is no asymptote there."),
       ("x = 2 only",
        "This overlooks the factor x in the denominator. It does not cancel with anything in the numerator, so f is also unbounded near x = 0.")],
      calc=lambda: vas(f23c, x),
      wrong_calcs=[None, None, None],
      change="numbers: repeated factor (x - 2)^2 so partial cancellation; context: valve flow rate"),
]

# ------------------------------------------------------------------ 024
V24 = [
    M("024-v1", "024", "medium", "Negative Numerator Over a Squared Denominator",
      "A detector's signal strength near a resonance point is modeled by S(x) = (2 - x)/(x - 3)^2, where x is the drive setting. What is lim(x->3+) (2 - x)/(x - 3)^2?",
      (fmt(limit((2 - x) / (x - 3) ** 2, x, 3, "+")),
       "The numerator approaches -1, which is negative. The denominator (x - 3)^2 is positive for every x != 3 and approaches 0, so the quotient is negative and its magnitude grows without bound."),
      [("infinity",
        "This ignores the sign of the numerator. Because (x - 3)^2 > 0, the sign of the quotient is the sign of 2 - x, which is negative near x = 3."),
       ("0",
        "The numerator approaches -1, a nonzero number. When the numerator approaches a nonzero number, a denominator approaching 0 makes the quotient large in magnitude, not small."),
       ("The limit does not exist because the one-sided limits are different.",
        "The squared denominator is positive on both sides of 3, so the quotient tends to negative infinity from the left as well as from the right. The one-sided limits agree.")],
      calc=lambda: fmt(limit((2 - x) / (x - 3) ** 2, x, 3, "+")),
      wrong_calcs=[lambda: fmt(-limit((2 - x) / (x - 3) ** 2, x, 3, "+")), None, None],
      change="numbers: (x+5)/(x+2)^2 at -2- -> (2-x)/(x-3)^2 at 3+, negative numerator; context: resonance detector"),
    M("024-v2", "024", "medium", "Fourth-Power Denominator on the Left",
      "The rate of a reaction is modeled by R(t) = (t^2 + 3)/(t + 1)^4, where t is a temperature offset. What is lim(t->-1-) (t^2 + 3)/(t + 1)^4?",
      (fmt(limit((t**2 + 3) / (t + 1) ** 4, t, -1, "-")),
       "The numerator approaches 4, which is positive. The denominator (t + 1)^4 is positive for every t != -1 (an even power of a negative number is positive) and approaches 0, so the quotient is positive and unbounded."),
      [("-infinity",
        "It is tempting to say t + 1 is negative when t < -1. But it is raised to the fourth power, so the denominator is positive on both sides of -1."),
       ("0",
        "The numerator approaches 4, a nonzero number. When the numerator approaches a nonzero number, a denominator approaching 0 makes the quotient large in magnitude, not small."),
       ("4",
        "This evaluates only the numerator at t = -1. The denominator approaches 0, so the quotient does not settle on the numerator's value.")],
      calc=lambda: fmt(limit((t**2 + 3) / (t + 1) ** 4, t, -1, "-")),
      wrong_calcs=[lambda: fmt(-limit((t**2 + 3) / (t + 1) ** 4, t, -1, "-")), None, lambda: fmt((t**2 + 3).subs(t, -1))],
      change="numbers: even power 4, positive numerator (t^2+3); context: reaction rate"),
    M("024-v3", "024", "medium", "Hidden Perfect Square in a Denominator",
      "A firm's marginal profit is modeled by P(x) = (x - 4)/(x^2 - 2x + 1), where x is the quantity sold in thousands. What is lim(x->1-) (x - 4)/(x^2 - 2x + 1)?",
      (fmt(limit((x - 4) / (x**2 - 2 * x + 1), x, 1, "-")),
       "The denominator is a perfect square: x^2 - 2x + 1 = (x - 1)^2, which is positive for x != 1 and approaches 0. The numerator approaches -3, which is negative, so the quotient is negative and unbounded."),
      [("infinity",
        "This recognizes that the denominator is positive but ignores that the numerator is negative near x = 1, so the quotient is negative."),
       ("0",
        "The numerator approaches -3, a nonzero number. When the numerator approaches a nonzero number, a denominator approaching 0 makes the quotient large in magnitude, not small."),
       ("-3",
        "This evaluates only the numerator at x = 1. The denominator approaches 0, so the quotient does not settle on the numerator's value.")],
      calc=lambda: fmt(limit((x - 4) / (x**2 - 2 * x + 1), x, 1, "-")),
      wrong_calcs=[lambda: fmt(-limit((x - 4) / (x**2 - 2 * x + 1), x, 1, "-")), None, lambda: fmt((x - 4).subs(x, 1))],
      change="numbers: squared factor hidden as x^2 - 2x + 1; context: marginal profit"),
]

# ------------------------------------------------------------------ 025
sols25a = sorted(solveset(2 * sin(x) - 1, x, Interval(0, pi)))
sols25b = sorted(solveset(1 + 2 * cos(x), x, Interval(0, pi)))
f25c = 1 / (tan(x) - 1)


def asym25c():
    out = []
    for c in [pi / 4, pi / 2]:
        lp, lm = limit(f25c, x, c, "+"), limit(f25c, x, c, "-")
        if not (lp.is_finite and lm.is_finite):
            out.append(c)
    return out


V25 = [
    M("025-v1", "025", "hard", "Two Asymptotes of a Sine Denominator",
      "A signal amplitude is modeled by f(x) = 3/(2 sin x - 1) on the interval 0 <= x <= pi, where x is the phase in radians. Which of the following gives all values of x in this interval at which the graph of f has a vertical asymptote?",
      (" and ".join(tr(z) for z in sols25a),
       "A vertical asymptote occurs where the denominator is 0 and the numerator is not. Setting 2 sin x - 1 = 0 gives sin x = 1/2. In [0, pi] this has two solutions, x = pi/6 and x = 5pi/6, and the numerator is 3 at both."),
      [("pi/6 only",
        "This finds the reference angle but stops there. Sine is also 1/2 at pi - pi/6 = 5pi/6, which lies in the interval, so there is a second asymptote."),
       ("pi/3 and 2pi/3",
        "These are the angles where sin x = sqrt(3)/2 (and cos x = 1/2 at pi/3). The equation to solve is sin x = 1/2."),
       ("pi/6 and 7pi/6",
        "sin(7pi/6) = -1/2, not 1/2, and 7pi/6 is outside 0 <= x <= pi. The second solution of sin x = 1/2 in the interval is pi - pi/6 = 5pi/6.")],
      calc=lambda: " and ".join(tr(z) for z in sorted(solveset(2 * sin(x) - 1, x, Interval(0, pi)))),
      wrong_calcs=[lambda: tr(min(solveset(2 * sin(x) - 1, x, Interval(0, pi)))) + " only", None, None],
      change="numbers: cos x = 1/2 -> sin x = 1/2 with two solutions in [0, pi]; context: signal amplitude"),
    M("025-v2", "025", "hard", "Asymptote Where Cosine Is Negative",
      "The brightness of a light through a filter is modeled by f(x) = (x + 1)/(1 + 2cos x) on the interval 0 <= x <= pi, where x is the filter angle in radians. On this interval, the graph of f has a vertical asymptote at x =",
      (" and ".join(tr(z) for z in sols25b),
       "A vertical asymptote occurs where the denominator is 0 and the numerator is not. Setting 1 + 2cos x = 0 gives cos x = -1/2, and the only solution in [0, pi] is x = 2pi/3. The numerator x + 1 is not 0 there."),
      [("pi/3",
        "cos(pi/3) = +1/2, but the equation is cos x = -1/2. This drops the negative sign when solving 1 + 2cos x = 0."),
       ("5pi/6",
        "sin(5pi/6) equals 1/2, but the denominator involves cosine. At 5pi/6, cos x = -sqrt(3)/2, so 1 + 2cos x is not 0."),
       ("4pi/3",
        "cos(4pi/3) = -1/2, but 4pi/3 is larger than pi and lies outside the interval 0 <= x <= pi.")],
      calc=lambda: " and ".join(tr(z) for z in sorted(solveset(1 + 2 * cos(x), x, Interval(0, pi)))),
      wrong_calcs=[None, None, None],
      change="numbers: cos x = 1/2 -> cos x = -1/2 (second quadrant), nonconstant numerator; context: light through a filter"),
    M("025-v3", "025", "hard", "Tangent Denominator With an Undefined Point",
      "A ramp-angle model gives f(x) = 1/(tan x - 1) for values of x in 0 <= x <= pi (x not equal to pi/2, where tan x is undefined). Which of the following gives all values of x in this interval at which the graph of f has a vertical asymptote?",
      (lst(asym25c()),
       "The denominator tan x - 1 is 0 when tan x = 1, which in [0, pi] happens only at x = pi/4, and the numerator is 1 there, so f is unbounded near pi/4. At x = pi/2, tan x becomes unbounded, so 1/(tan x - 1) approaches 0 from both sides. There is no asymptote at pi/2."),
      [("pi/4 and pi/2",
        "This treats pi/2 as an asymptote because tan x has one there. But tan x is huge near pi/2, so 1/(tan x - 1) is close to 0 there, not unbounded."),
       ("pi/2 only",
        "The undefined point of tan x does not produce an asymptote of f: as tan x grows without bound, 1/(tan x - 1) approaches 0. The asymptote comes from tan x = 1."),
       ("pi/4 and 5pi/4",
        "tan(5pi/4) = 1 as well, but 5pi/4 is greater than pi and lies outside the interval 0 <= x <= pi.")],
      calc=lambda: lst(asym25c()),
      wrong_calcs=[lambda: " and ".join(tr(c) for c in [pi / 4, pi / 2]), None, None],
      change="numbers/function family: cosine denominator -> tangent, with a tempting non-asymptote at pi/2; context: ramp angle"),
]

# ------------------------------------------------------------------ 026
V26 = [
    M("026-v1", "026", "easy", "Limit at Infinity of a Radical Over a Linear Term",
      "The ratio of a sensor's output to its input is modeled by G(x) = sqrt(9x^2 + 4x)/(2x - 1) for large input x > 0. What is lim(x->infinity) sqrt(9x^2 + 4x)/(2x - 1)?",
      (fmt(limit(sqrt(9 * x**2 + 4 * x) / (2 * x - 1), x, oo)),
       "For large x, sqrt(9x^2 + 4x) behaves like sqrt(9x^2) = 3x. The numerator and denominator then both grow linearly, and dividing each by x gives (sqrt(9 + 4/x))/(2 - 1/x), which approaches 3/2."),
      [("9/2",
        "This treats sqrt(9x^2 + 4x) as behaving like 9x, forgetting to take the square root of the coefficient 9. The radical behaves like 3x."),
       ("2/3",
        "This inverts the ratio of leading behaviors. The numerator behaves like 3x and the denominator like 2x, so the ratio is 3/2."),
       ("infinity",
        "This treats the numerator as if it grew like x^2, ignoring the square root. The radical grows only linearly, at the same rate as 2x - 1.")],
      calc=lambda: fmt(limit(sqrt(9 * x**2 + 4 * x) / (2 * x - 1), x, oo)),
      wrong_calcs=[lambda: fmt(limit(9 * x / (2 * x - 1), x, oo)), lambda: fmt(limit((2 * x - 1) / (3 * x), x, oo)), None],
      change="function family: polynomial ratio -> radical over linear; context: sensor output-to-input ratio"),
    M("026-v2", "026", "easy", "Limit at Infinity of a Ratio of Exponentials",
      "Two bacterial cultures are compared. Their sizes are A(t) = 7e^(3t) + 2 and B(t) = 4e^(3t) - e^t, where t is the time in hours. What is lim(t->infinity) A(t)/B(t)?",
      (fmt(limit((7 * exp(3 * t) + 2) / (4 * exp(3 * t) - exp(t)), t, oo)),
       "For large t, e^(3t) dominates both the constant 2 and the term e^t. Dividing the numerator and denominator by e^(3t) gives (7 + 2e^(-3t))/(4 - e^(-2t)), which approaches 7/4."),
      [("4/7",
        "This inverts the ratio of the coefficients of e^(3t). The numerator's coefficient is 7 and the denominator's is 4."),
       ("0",
        "A limit of 0 would require the denominator to grow faster than the numerator. Both are dominated by e^(3t), so they grow at the same rate."),
       ("infinity",
        "A limit of infinity would require the numerator to grow faster than the denominator. Both are dominated by a multiple of e^(3t).")],
      calc=lambda: fmt(limit((7 * exp(3 * t) + 2) / (4 * exp(3 * t) - exp(t)), t, oo)),
      wrong_calcs=[lambda: fmt(limit((4 * exp(3 * t)) / (7 * exp(3 * t)), t, oo)), None, None],
      change="function family: polynomial ratio -> exponential ratio with a lower-order exponential term; context: bacterial cultures"),
    M("026-v3", "026", "easy", "Limit at Infinity When the Numerator Has Greater Degree",
      "An athlete's energy output is modeled by E(x) = 4x^3 - x and the recovery required is modeled by D(x) = 5x^2 + 9, where x is the training load. What is lim(x->infinity) E(x)/D(x)?",
      (fmt(limit((4 * x**3 - x) / (5 * x**2 + 9), x, oo)),
       "The numerator has degree 3 and the denominator has degree 2. Dividing each term by x^2 gives (4x - 1/x)/(5 + 9/x^2). The numerator grows without bound while the denominator approaches 5, so the quotient grows without bound."),
      [("4/5",
        "This applies the equal-degree rule and compares leading coefficients. That rule only applies when both degrees are the same; here the degrees are 3 and 2."),
       ("0",
        "A limit of 0 would require the denominator's degree to exceed the numerator's. Here the numerator has the greater degree."),
       ("5/4",
        "This inverts the leading coefficients and also applies the equal-degree rule. The degrees are different, so the limit is not a ratio of coefficients.")],
      calc=lambda: fmt(limit((4 * x**3 - x) / (5 * x**2 + 9), x, oo)),
      wrong_calcs=[lambda: fmt(Rational(4, 5)), None, lambda: fmt(Rational(5, 4))],
      change="numbers: equal degrees -> numerator degree 3 vs 2 (limit infinity); context: athlete energy"),
]

# ------------------------------------------------------------------ 027
def f27n(s):
    return (8 * s - 5) / sqrt(4 * s**2 + 7)


f27a = (x + 3 * sqrt(x**2 + 5)) / (2 * x + 1)
f27b = (3 * exp(x) + 1) / (exp(x) + 2)
f27c = 6 * x / (x + 2 * sqrt(x**2 + 1))

V27 = [
    M("027-v1", "027", "hard", "Steady Output of a Signal-Conditioning Circuit",
      "The output voltage of a signal-conditioning circuit is modeled by V(s) = (8s - 5)/sqrt(4s^2 + 7), where s is any real input setting. Which of the following gives all horizontal asymptotes of the graph of V?",
      ("V = 4 and V = -4",
       "For large positive s, sqrt(4s^2 + 7) behaves like 2s, so V approaches 8s/(2s) = 4. For large negative s, the radical behaves like 2|s| = -2s, so V approaches 8s/(-2s) = -4."),
      [("V = 4 only",
        "This considers only s approaching positive infinity. As s approaches negative infinity, the radical is positive while 8s - 5 is negative, giving the limit -4."),
       ("V = 0 only",
        "The numerator is first degree in s, and the radical behaves like 2|s|, also first degree. Equal growth rates give a nonzero limit, not 0."),
       ("V = 8 and V = -8",
        "This treats sqrt(4s^2 + 7) as behaving like |s|. It behaves like 2|s|, because sqrt(4s^2) = 2|s|, so the limits are 4 and -4.")],
      calc=lambda: (lambda s: "V = " + fmt(limit(f27n(s), s, oo)) + " and V = " + fmt(limit(f27n(s), s, -oo)))(symbols("s", real=True)),
      wrong_calcs=[lambda: (lambda s: "V = " + fmt(limit(f27n(s), s, oo)) + " only")(symbols("s", real=True)),
                   None,
                   lambda: (lambda s: "V = " + fmt(limit(8*s/sqrt(s**2), s, oo)) + " and V = " + fmt(limit(8*s/sqrt(s**2), s, -oo)))(symbols("s", real=True))],
      change="numbers/function: 3x/sqrt(4x^2+1) -> (8s-5)/sqrt(4s^2+7), asymptotes 4 and -4; context: bare function -> circuit output voltage"),
    M("027-v2", "027", "hard", "Two Horizontal Asymptotes of an Exponential Ratio",
      "An enzyme's activity level is modeled by f(x) = (3e^x + 1)/(e^x + 2), where x is a concentration setting that can take any real value. Which of the following gives all horizontal asymptotes of the graph of f?",
      (hz(f27b, x),
       "As x approaches infinity, e^x dominates and f approaches 3e^x/e^x = 3. As x approaches negative infinity, e^x approaches 0, so the numerator approaches 1 and the denominator approaches 2, giving the limit 1/2."),
      [("y = 3 only",
        "This considers only x approaching positive infinity. As x approaches negative infinity, e^x approaches 0 and f approaches 1/2, giving a second horizontal asymptote."),
       ("y = 3 and y = 0",
        "This treats e^x approaching 0 as making the whole expression approach 0. But the constants 1 and 2 remain, so f approaches 1/2 as x approaches negative infinity."),
       ("y = 1/2 only",
        "This considers only x approaching negative infinity. As x approaches positive infinity, e^x dominates and f approaches 3, giving a second horizontal asymptote.")],
      calc=lambda: hz(f27b, x),
      wrong_calcs=[lambda: "y = " + fmt(limit(f27b, x, oo)) + " only", None, lambda: "y = " + fmt(limit(f27b, x, -oo)) + " only"],
      change="function family: radical -> exponential ratio (no radical at all); context: enzyme activity"),
    M("027-v3", "027", "hard", "Radical in a Denominator With Unequal Sides",
      "A gain function is modeled by f(x) = 6x/(x + 2sqrt(x^2 + 1)). The denominator is positive for every real x. Which of the following gives all horizontal asymptotes of the graph of f?",
      (hz(f27c, x),
       "For large positive x, sqrt(x^2 + 1) behaves like x, so f behaves like 6x/(x + 2x) = 2. For large negative x, sqrt(x^2 + 1) behaves like |x| = -x, so the denominator behaves like x - 2x = -x and f behaves like 6x/(-x) = -6."),
      [("y = 2 only",
        "This considers only x approaching positive infinity, or treats sqrt(x^2) as x for negative x as well. For negative x the denominator behaves like -x, giving the limit -6."),
       ("y = 2 and y = -2",
        "This assumes the two asymptotes are opposites. For negative x the radical contributes -2x to the denominator, which changes its size as well as its sign, giving -6, not -2."),
       ("y = 2 and y = 6",
        "This replaces sqrt(x^2) with -x for negative x but then loses a sign when simplifying 6x/(-x). That quotient is -6, not 6.")],
      calc=lambda: hz(f27c, x),
      wrong_calcs=[lambda: "y = " + fmt(limit(f27c, x, oo)) + " only", None, None],
      change="numbers/function family: radical in the denominator added to x, asymptotes 2 and -6; context: gain function"),
]

# ------------------------------------------------------------------ 028
f28a = 12 - 9 * exp(-t / 5)
f28b = 400 * t / (t + 5)
f28c = 900 / (1 + 8 * exp(-t / 3))


def ctx(val, tmpl):
    return fmt(val) + "; " + tmpl.replace("{v}", fmt(val))


V28 = [
    M("028-v1", "028", "medium", "Interpreting a Long-Run Capacitor Voltage",
      "The voltage across a charging capacitor is modeled by V(t) = 12 - 9e^(-t/5) volts, where t >= 0 is the time in seconds. What is lim(t->infinity) V(t), and what does it mean in this context?",
      (ctx(limit(f28a, t, oo), "the voltage levels off near {v} volts."),
       "As t increases, e^(-t/5) approaches 0, so V(t) approaches 12 - 9(0) = 12. The model predicts the voltage settles near 12 volts."),
      [("3; the voltage levels off near 3 volts.",
        "The value 3 is V(0) = 12 - 9, the starting voltage. The question is about what happens as t grows large, not at t = 0."),
       ("0; the voltage eventually falls to 0 volts.",
        "The exponential term approaches 0, but the constant 12 remains, so V(t) approaches 12, not 0."),
       ("-infinity; the voltage decreases without bound.",
        "The minus sign in front of 9e^(-t/5) does not make the term grow. The exponent -t/5 is negative, so e^(-t/5) decays toward 0 and V(t) approaches 12 for large t.")],
      calc=lambda: ctx(limit(f28a, t, oo), "the voltage levels off near {v} volts."),
      wrong_calcs=[lambda: ctx(f28a.subs(t, 0), "the voltage levels off near {v} volts."), None, None],
      change="numbers: 20 + 60e^(-t/4) -> 12 - 9e^(-t/5), approach from below; context: capacitor charging"),
    M("028-v2", "028", "medium", "Interpreting a Long-Run Visitor Rate",
      "After a website launches, its visitor rate is modeled by R(t) = 400t/(t + 5) visitors per hour, where t >= 0 is the time in hours since launch. What is lim(t->infinity) R(t), and what does it mean in this context?",
      (ctx(limit(f28b, t, oo), "the visitor rate levels off near {v} visitors per hour."),
       "Dividing the numerator and denominator by t gives 400/(1 + 5/t), which approaches 400 as t grows. The model predicts the rate settles near 400 visitors per hour."),
      [("0; the visitor rate falls to 0 visitors per hour.",
        "This assumes a growing denominator forces the quotient to 0, but the numerator grows at the same rate. Both have degree 1, so the limit is the ratio of leading coefficients."),
       ("infinity; the visitor rate grows without bound.",
        "This assumes the growing numerator makes the quotient grow, but the denominator grows at the same rate, so the rate levels off."),
       ("80; the visitor rate levels off near 80 visitors per hour.",
        "This divides the leading coefficient 400 by the constant term 5 in the denominator (t + 5), as if the denominator were just its constant. For large t the 5 is negligible next to t, and the limit is 400/1 = 400.")],
      calc=lambda: ctx(limit(f28b, t, oo), "the visitor rate levels off near {v} visitors per hour."),
      wrong_calcs=[None, None, lambda: ctx(Rational(400, 5), "the visitor rate levels off near {v} visitors per hour.")],
      change="function family: exponential decay to a constant -> rational saturation; context: website visitor rate"),
    M("028-v3", "028", "medium", "Long-Run Speed of a Probe",
      "The average speed of a research probe t hours after launch is modeled by s(t) = 30t/sqrt(t^2 + 9) kilometers per hour, where t >= 0. What is lim(t->infinity) s(t), and what does it mean in this context?",
      (f"{fmt(limit(30 * t / sqrt(t**2 + 9), t, oo))}; the probe's speed levels off near {fmt(limit(30 * t / sqrt(t**2 + 9), t, oo))} kilometers per hour.",
       "For large t, sqrt(t^2 + 9) behaves like t, so s(t) behaves like 30t/t = 30. Dividing the numerator and denominator by t gives 30/sqrt(1 + 9/t^2), which approaches 30. The model predicts the speed settles near 30 kilometers per hour."),
      [("0; the probe eventually comes to a stop.",
        "The value 0 is s(0), the speed at launch. The question is about what happens as t grows large, and s(t) increases toward 30, not toward 0."),
       ("infinity; the probe's speed grows without bound.",
        "The numerator grows like t, but the denominator also grows like t, so the ratio does not grow without bound. It approaches a finite limit."),
       ("10; the probe's speed levels off near 10 kilometers per hour.",
        "This treats sqrt(t^2 + 9) as if it were 3t, giving 30t/(3t) = 10. But for large t, sqrt(t^2 + 9) behaves like t, not 3t, so the limit is 30.")],
      calc=lambda: f"{fmt(limit(30 * t / sqrt(t**2 + 9), t, oo))}; the probe's speed levels off near {fmt(limit(30 * t / sqrt(t**2 + 9), t, oo))} kilometers per hour.",
      wrong_calcs=[lambda: f"{fmt((30 * t / sqrt(t**2 + 9)).subs(t, 0))}; the probe eventually comes to a stop.", None,
                   lambda: f"{fmt(Rational(30, 3))}; the probe's speed levels off near {fmt(Rational(30, 3))} kilometers per hour."],
      change="function family: additive decay -> radical quotient; context: probe speed (non-logistic; the fact pack excludes logistic models)"),
]

# ------------------------------------------------------------------ 029
f29a = (5**x + x**4) / (3**x + x**7)
f29b = (9 * 2**x + x**12) / (6 * 2**x + x**5)
f29c = (3 * x**8 + 4 * x**2) / (5 * 2**x - x**3)

V29 = [
    M("029-v1", "029", "hard", "Comparing Two Running Times With Different Exponential Bases",
      "Two data-processing methods have running times A(x) = 5^x + x^4 and B(x) = 3^x + x^7 milliseconds for a job of size x, where x can be any real number with x >= 1. What is lim(x->infinity) A(x)/B(x)?",
      (fmt(limit(f29a, x, oo)),
       "The exponential 5^x outgrows the polynomial x^4, so the numerator behaves like 5^x. The exponential 3^x outgrows x^7, so the denominator behaves like 3^x. The ratio behaves like (5/3)^x, which grows without bound."),
      [("0",
        "This compares only the polynomial parts, x^4 and x^7, and concludes the denominator is larger. Any exponential a^x with a > 1 eventually outgrows every polynomial, so the polynomials do not decide the limit."),
       ("1",
        "This assumes that because both expressions are a sum of an exponential and a polynomial, their sizes are comparable. The base 5 exponential grows much faster than the base 3 exponential."),
       ("5/3",
        "This treats the bases as if they were coefficients and takes 5/3 as the limit. The ratio behaves like (5/3)^x, and since 5/3 > 1 that expression grows without bound.")],
      calc=lambda: fmt(limit(f29a, x, oo)),
      wrong_calcs=[None, None, lambda: fmt(Rational(5, 3))],
      change="numbers/structure: answer 0 -> infinity, exponentials with different bases in both numerator and denominator plus polynomials; context: algorithm step counts"),
    M("029-v2", "029", "hard", "Same Exponential Base With Polynomial Terms",
      "The daily views of two videos are modeled by V1(x) = 9 * 2^x + x^12 and V2(x) = 6 * 2^x + x^5, where x is the day number. What is lim(x->infinity) V1(x)/V2(x)?",
      (fmt(limit(f29b, x, oo)),
       "The exponential 2^x grows faster than every power of x, so x^12 is negligible next to 9 * 2^x and x^5 is negligible next to 6 * 2^x. Dividing the numerator and denominator by 2^x gives (9 + x^12/2^x)/(6 + x^5/2^x), which approaches 9/6 = 3/2."),
      [("infinity",
        "This compares the polynomials and concludes that x^12 outgrows x^5. But 2^x grows faster than both, so the polynomial terms do not matter in the limit."),
       ("1",
        "This assumes the two expressions grow at the same rate, so their ratio is 1. Growing at the same rate means the ratio approaches the ratio of the leading coefficients, 9/6, which is not 1."),
       ("12/5",
        "This treats the exponents 12 and 5 as if they were leading coefficients. The polynomial terms are negligible, and the leading terms 9 * 2^x and 6 * 2^x give 9/6.")],
      calc=lambda: fmt(limit(f29b, x, oo)),
      wrong_calcs=[None, None, lambda: fmt(Rational(12, 5))],
      change="numbers/structure: same exponential base in both parts so the answer is a finite nonzero coefficient ratio; context: video views"),
    M("029-v3", "029", "hard", "Polynomial Revenue Against an Exponential Cost",
      "A company's revenue is modeled by R(x) = 3x^8 + 4x^2 and its cost by C(x) = 5(2^x) - x^3, where x is the number of years. What is lim(x->infinity) R(x)/C(x)?",
      (fmt(limit(f29c, x, oo)),
       "The exponential 2^x grows faster than any power of x, so 5(2^x) - x^3 behaves like 5(2^x) for large x, and the numerator behaves like 3x^8. Since x^8/2^x approaches 0, the quotient approaches 0."),
      [("infinity",
        "This assumes the numerator's higher power, x^8, wins by comparing only polynomial degrees. But 2^x eventually outgrows any polynomial, so the denominator wins and the quotient approaches 0."),
       ("-infinity",
        "This assumes the subtraction makes the denominator negative. For large x, 2^x is much larger than x^3, so the denominator is positive and grows."),
       ("-3",
        "This compares the coefficients of the top-degree polynomial terms, 3x^8 in R and -x^3 in C, and forms 3/(-1) as if both were polynomials of equal degree. But the degrees differ, and C is dominated by 5(2^x), not by -x^3.")],
      calc=lambda: fmt(limit(f29c, x, oo)),
      wrong_calcs=[None, None, None],
      change="function family: exponential/exponential -> polynomial/(exponential minus polynomial); context: revenue against cost"),
]

VARIANTS = V21 + V22 + V23 + V24 + V25 + V26 + V27 + V28 + V29
