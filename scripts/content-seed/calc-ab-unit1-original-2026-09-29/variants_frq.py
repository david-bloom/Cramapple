# Variants of the five original Unit 1 short FRQs (001-005). Three per original.
import re
from sympy import symbols, limit, sqrt, Rational, oo, simplify, expand, factor, S, Symbol, N as sN
from vlib import F

x = symbols("x", real=True)
t = symbols("t", real=True)
n = symbols("n", real=True)

ANS = "Answer all parts of the following question."


def lim(e, a, d="+-", v=x):
    return limit(e, v, a, d)


def same(a, b):
    return simplify(a - b) == 0


def C(key, text, ev, fix, acc=None):
    return (key, text, 1, ev, fix, acc or [])


def table_stimulus(intro, hfun, pts):
    lines = []
    for p in pts:
        val = float(hfun(Rational(p)))
        lines.append(f"x = {p}: h(x) = {val:.4f}")
    return intro + "\n\n" + "\n".join(lines)


def table_check(stim, hfun, tol=6e-5):
    rows = re.findall(r"x = ([0-9.]+): h\(x\) = (-?[0-9.]+)", stim)
    return len(rows) == 6 and all(abs(float(v) - float(hfun(Rational(p)))) < tol for p, v in rows)


VARIANTS = []

# ------------------------------------------------------------------ 001
g1 = (3 * x**2 - x - 14) / (x**2 - x - 6)
g1s = (3 * x - 7) / (x - 3)
VARIANTS.append(F(
    "001-v1", "001", "medium", "Gain Ratio of a Circuit With a Hole and a Pole",
    "The gain g of an amplifier circuit at input level x is modeled by g(x) = (3x^2 - x - 14)/(x^2 - x - 6) for x != -2 and x != 3.",
    ANS + "\n\n(a) Find lim(x->-2) g(x). Show the algebra that leads to your answer.\n\n(b) The graph of g has a removable discontinuity at x = -2. Justify this, and state the value that would have to be assigned to g(-2) to make the function continuous at x = -2.\n\n(c) Find lim(x->3-) g(x) and lim(x->3+) g(x). Give a reason for the sign of each.",
    [
        C("part-a-criterion-01", "Factors and cancels x + 2 (for x not equal to -2), then evaluates to obtain the limit 13/5.",
          "Response factors the numerator as (x + 2)(3x - 7) and the denominator as (x + 2)(x - 3), cancels x + 2 (for x not equal to -2), and evaluates (3x - 7)/(x - 3) at x = -2 to get (-13)/(-5) = 13/5.",
          "Show the factoring and cancellation step before evaluating. A correct value with no algebra does not earn the point.", ["13/5", "2.6"]),
        C("part-b-criterion-01", "Justifies a removable discontinuity: the limit at x = -2 exists but g(-2) is not defined.",
          "Response states that the limit exists as a finite number while g(-2) is undefined, so the discontinuity is removable.",
          "State that the limit exists and that g(-2) is undefined. Saying only 'the factors cancel' is not sufficient."),
        C("part-b-criterion-02", "States that g(-2) would have to equal 13/5 for continuity.",
          "Response states that assigning g(-2) = 13/5 (the limit found in part (a)) makes g continuous at x = -2.",
          "Give the value 13/5 and connect it to the limit.", ["13/5", "2.6"]),
        C("part-c-criterion-01", "Finds the one-sided limits at x = 3 as -infinity from the left and infinity from the right, with sign reasoning.",
          "Response gives lim(x->3-) g(x) = -infinity and lim(x->3+) g(x) = infinity, using the simplified form (3x - 7)/(x - 3): the numerator approaches 2 and is positive near x = 3, and x - 3 is negative on the left and positive on the right.",
          "Give both one-sided limits and explain the sign of x - 3 on each side. Both must be correct.",
          ["+infinity", "positive infinity", "negative infinity"]),
    ],
    [
        ("numerator factors as (x+2)(3x-7)", lambda: expand((x + 2) * (3 * x - 7)) == expand(3 * x**2 - x - 14)),
        ("denominator factors as (x+2)(x-3)", lambda: expand((x + 2) * (x - 3)) == expand(x**2 - x - 6)),
        ("g equals (3x-7)/(x-3) away from -2", lambda: same(g1, g1s)),
        ("lim x->-2 g = 13/5", lambda: lim(g1, -2) == Rational(13, 5)),
        ("(3x-7)/(x-3) at x=-2 is 13/5", lambda: g1s.subs(x, -2) == Rational(13, 5)),
        ("g(-2) is undefined (denominator zero)", lambda: (x**2 - x - 6).subs(x, -2) == 0),
        ("numerator of simplified form at 3 is 2 > 0", lambda: (3 * x - 7).subs(x, 3) == 2),
        ("lim x->3- g = -oo", lambda: lim(g1, 3, "-") == -oo),
        ("lim x->3+ g = +oo", lambda: lim(g1, 3, "+") == oo),
    ],
    change="numbers: hole at 3 -> hole at -2, pole at -3 -> pole at 3 (signs left -, right +); context: pure function -> amplifier gain"))

g2 = (2 + x - x**2) / (x**2 - 3 * x - 4)
g2s = (2 - x) / (x - 4)
VARIANTS.append(F(
    "001-v2", "001", "medium", "Concentration Ratio Along a Tube",
    "In a diffusion experiment, the ratio r of two concentrations at position x cm from a marker on a tube is modeled by r(x) = (2 + x - x^2)/(x^2 - 3x - 4) for x != -1 and x != 4.",
    ANS + "\n\n(a) Find lim(x->-1) r(x). Show the algebra that leads to your answer.\n\n(b) The graph of r has a removable discontinuity at x = -1. Justify this, and state the value that would have to be assigned to r(-1) to make the function continuous at x = -1.\n\n(c) Find lim(x->4-) r(x) and lim(x->4+) r(x). Give a reason for the sign of each.",
    [
        C("part-a-criterion-01", "Factors and cancels x + 1 (for x not equal to -1), then evaluates to obtain the limit -3/5.",
          "Response factors the numerator as (x + 1)(2 - x) and the denominator as (x + 1)(x - 4), cancels x + 1 (for x not equal to -1), and evaluates (2 - x)/(x - 4) at x = -1 to get 3/(-5) = -3/5.",
          "Show the factoring and cancellation step before evaluating. A correct value with no algebra does not earn the point.", ["-3/5", "-0.6"]),
        C("part-b-criterion-01", "Justifies a removable discontinuity: the limit at x = -1 exists but r(-1) is not defined.",
          "Response states that the limit exists as a finite number while r(-1) is undefined, so the discontinuity is removable.",
          "State that the limit exists and that r(-1) is undefined. Saying only 'the factors cancel' is not sufficient."),
        C("part-b-criterion-02", "States that r(-1) would have to equal -3/5 for continuity.",
          "Response states that assigning r(-1) = -3/5 (the limit found in part (a)) makes r continuous at x = -1.",
          "Give the value -3/5 and connect it to the limit.", ["-3/5", "-0.6"]),
        C("part-c-criterion-01", "Finds the one-sided limits at x = 4 as infinity from the left and -infinity from the right, with sign reasoning.",
          "Response gives lim(x->4-) r(x) = infinity and lim(x->4+) r(x) = -infinity, using the simplified form (2 - x)/(x - 4): the numerator approaches -2 and is negative near x = 4, and x - 4 is negative on the left (so the quotient is positive) and positive on the right (so the quotient is negative).",
          "Give both one-sided limits and explain the sign of the numerator and of x - 4 on each side. Both must be correct.",
          ["+infinity", "positive infinity", "negative infinity"]),
    ],
    [
        ("numerator 2+x-x^2 factors as (x+1)(2-x)", lambda: expand((x + 1) * (2 - x)) == expand(2 + x - x**2)),
        ("denominator factors as (x+1)(x-4)", lambda: expand((x + 1) * (x - 4)) == expand(x**2 - 3 * x - 4)),
        ("r equals (2-x)/(x-4) away from -1", lambda: same(g2, g2s)),
        ("lim x->-1 r = -3/5", lambda: lim(g2, -1) == Rational(-3, 5)),
        ("r(-1) is undefined (denominator zero)", lambda: (x**2 - 3 * x - 4).subs(x, -1) == 0),
        ("numerator of simplified form at 4 is -2", lambda: (2 - x).subs(x, 4) == -2),
        ("lim x->4- r = +oo", lambda: lim(g2, 4, "-") == oo),
        ("lim x->4+ r = -oo", lambda: lim(g2, 4, "+") == -oo),
    ],
    change="numbers: new hole at -1 (limit -3/5) and pole at 4 with negative numerator (signs left +, right -); context: pure function -> concentration ratio in diffusion"))

g3 = (2 * x**2 + 9 * x + 9) / (3 - 2 * x - x**2)
g3s = (2 * x + 3) / (1 - x)
VARIANTS.append(F(
    "001-v3", "001", "medium", "Force Ratio on a Track",
    "A physics lab models the ratio w of two measured forces at position x meters along a track by w(x) = (2x^2 + 9x + 9)/(3 - 2x - x^2) for x != -3 and x != 1.",
    ANS + "\n\n(a) Find lim(x->-3) w(x). Show the algebra that leads to your answer.\n\n(b) The graph of w has a removable discontinuity at x = -3. Justify this, and state the value that would have to be assigned to w(-3) to make the function continuous at x = -3.\n\n(c) Find lim(x->1-) w(x) and lim(x->1+) w(x). Give a reason for the sign of each.",
    [
        C("part-a-criterion-01", "Factors and cancels x + 3 (for x not equal to -3), then evaluates to obtain the limit -3/4.",
          "Response factors the numerator as (x + 3)(2x + 3) and the denominator as (x + 3)(1 - x), cancels x + 3 (for x not equal to -3), and evaluates (2x + 3)/(1 - x) at x = -3 to get (-3)/4 = -3/4.",
          "Show the factoring and cancellation step before evaluating. A correct value with no algebra does not earn the point.", ["-3/4", "-0.75"]),
        C("part-b-criterion-01", "Justifies a removable discontinuity: the limit at x = -3 exists but w(-3) is not defined.",
          "Response states that the limit exists as a finite number while w(-3) is undefined, so the discontinuity is removable.",
          "State that the limit exists and that w(-3) is undefined. Saying only 'the factors cancel' is not sufficient."),
        C("part-b-criterion-02", "States that w(-3) would have to equal -3/4 for continuity.",
          "Response states that assigning w(-3) = -3/4 (the limit found in part (a)) makes w continuous at x = -3.",
          "Give the value -3/4 and connect it to the limit.", ["-3/4", "-0.75"]),
        C("part-c-criterion-01", "Finds the one-sided limits at x = 1 as infinity from the left and -infinity from the right, with sign reasoning.",
          "Response gives lim(x->1-) w(x) = infinity and lim(x->1+) w(x) = -infinity, using the simplified form (2x + 3)/(1 - x): the numerator approaches 5 and is positive near x = 1, and 1 - x is small and positive on the left and small and negative on the right.",
          "Give both one-sided limits and explain the sign of 1 - x on each side. Both must be correct.",
          ["+infinity", "positive infinity", "negative infinity"]),
    ],
    [
        ("numerator factors as (x+3)(2x+3)", lambda: expand((x + 3) * (2 * x + 3)) == expand(2 * x**2 + 9 * x + 9)),
        ("denominator 3-2x-x^2 factors as (x+3)(1-x)", lambda: expand((x + 3) * (1 - x)) == expand(3 - 2 * x - x**2)),
        ("w equals (2x+3)/(1-x) away from -3", lambda: same(g3, g3s)),
        ("lim x->-3 w = -3/4", lambda: lim(g3, -3) == Rational(-3, 4)),
        ("w(-3) is undefined (denominator zero)", lambda: (3 - 2 * x - x**2).subs(x, -3) == 0),
        ("numerator of simplified form at 1 is 5", lambda: (2 * x + 3).subs(x, 1) == 5),
        ("lim x->1- w = +oo", lambda: lim(g3, 1, "-") == oo),
        ("lim x->1+ w = -oo", lambda: lim(g3, 1, "+") == -oo),
    ],
    change="numbers: new hole at -3 (limit -3/4), pole at 1 written as 1 - x (signs left +, right -), non-monic numerator; context: pure function -> force ratio on a track"))

# ------------------------------------------------------------------ 002
f1 = (2 * x - 1) / (x**2 + x - 12)
VARIANTS.append(F(
    "002-v1", "002", "medium", "Asymptotes of a Reaction Rate Model",
    "The rate R of a chemical reaction, in moles per second, at temperature setting x is modeled by R(x) = (2x - 1)/(x^2 + x - 12).",
    ANS + "\n\n(a) Find all vertical asymptotes of the graph of R. Justify your answer.\n\n(b) Find lim(x->3+) R(x). Give a reason for the sign of your answer.\n\n(c) Find lim(x->-4-) R(x). Give a reason for the sign of your answer.\n\n(d) Write an equation for the horizontal asymptote of the graph of R, or explain why there is none.",
    [
        C("part-a-criterion-01", "Identifies x = 3 and x = -4 and justifies each with a zero denominator and a nonzero numerator.",
          "Response factors the denominator as (x - 3)(x + 4) and identifies x = 3 and x = -4, noting that the numerator 2x - 1 is nonzero (5 and -9) at each.",
          "Name both asymptotes and state that the numerator is nonzero at each. Listing the zeros of the denominator alone is not enough."),
        C("part-b-criterion-01", "Finds lim(x->3+) R(x) = infinity, with sign reasoning.",
          "Response gives infinity and explains that near 3 from the right the numerator is positive (about 5), x - 3 is small and positive, and x + 4 is positive.",
          "Give infinity and justify the sign of each factor.", ["+infinity", "positive infinity"]),
        C("part-c-criterion-01", "Finds lim(x->-4-) R(x) = -infinity, with sign reasoning.",
          "Response gives -infinity and explains that near -4 from the left the numerator is negative (about -9), and both x + 4 and x - 3 are negative, so the denominator is small and positive.",
          "Give -infinity and justify the sign of the numerator and denominator.", ["negative infinity"]),
        C("part-d-criterion-01", "States the horizontal asymptote y = 0 with a valid reason based on degrees or a limit at infinity.",
          "Response gives y = 0 and justifies it with the degree of the denominator exceeding the degree of the numerator, or by evaluating lim(x->infinity) R(x) = 0.",
          "State y = 0 and give a reason based on degrees or the limit at infinity.", ["y = 0"]),
    ],
    [
        ("denominator factors as (x-3)(x+4)", lambda: expand((x - 3) * (x + 4)) == expand(x**2 + x - 12)),
        ("numerator at 3 is 5, at -4 is -9", lambda: ((2 * x - 1).subs(x, 3), (2 * x - 1).subs(x, -4)) == (5, -9)),
        ("lim x->3+ R = +oo", lambda: lim(f1, 3, "+") == oo),
        ("lim x->3- R = -oo (so x=3 is a vertical asymptote)", lambda: lim(f1, 3, "-") == -oo),
        ("lim x->-4- R = -oo", lambda: lim(f1, -4, "-") == -oo),
        ("lim x->-4+ R = +oo (so x=-4 is a vertical asymptote)", lambda: lim(f1, -4, "+") == oo),
        ("lim x->oo R = 0", lambda: lim(f1, oo, "-") == 0),
        ("lim x->-oo R = 0", lambda: lim(f1, -oo, "+") == 0),
    ],
    change="numbers: 3x/(x^2-4x-5) -> (2x-1)/(x^2+x-12), asymptotes 3 and -4; context: pure function -> reaction rate"))

f2 = (5 * x**2 - 3) / (2 * x**2 - 8 * x)
VARIANTS.append(F(
    "002-v2", "002", "medium", "Asymptotes of a Dosage Ratio With Equal Degrees",
    "A pharmacology model gives the ratio D of absorbed to administered dose at dose setting x as D(x) = (5x^2 - 3)/(2x^2 - 8x).",
    ANS + "\n\n(a) Find all vertical asymptotes of the graph of D. Justify your answer.\n\n(b) Find lim(x->4-) D(x). Give a reason for the sign of your answer.\n\n(c) Find lim(x->0+) D(x). Give a reason for the sign of your answer.\n\n(d) Write an equation for the horizontal asymptote of the graph of D, or explain why there is none.",
    [
        C("part-a-criterion-01", "Identifies x = 0 and x = 4 and justifies each with a zero denominator and a nonzero numerator.",
          "Response factors the denominator as 2x(x - 4) and identifies x = 0 and x = 4, noting that the numerator 5x^2 - 3 is nonzero (-3 and 77) at each.",
          "Name both asymptotes and state that the numerator is nonzero at each. Listing the zeros of the denominator alone is not enough."),
        C("part-b-criterion-01", "Finds lim(x->4-) D(x) = -infinity, with sign reasoning.",
          "Response gives -infinity and explains that near 4 from the left the numerator is positive (about 77), 2x is positive (about 8), and x - 4 is small and negative, so the denominator is small and negative.",
          "Give -infinity and justify the sign of the numerator and of each denominator factor.", ["negative infinity"]),
        C("part-c-criterion-01", "Finds lim(x->0+) D(x) = infinity, with sign reasoning.",
          "Response gives infinity and explains that near 0 from the right the numerator is negative (about -3), 2x is small and positive, and x - 4 is negative (about -4), so the denominator is small and negative and the quotient is positive.",
          "Give infinity and justify the sign of the numerator and denominator.", ["+infinity", "positive infinity"]),
        C("part-d-criterion-01", "States the horizontal asymptote y = 5/2 with a valid reason based on equal degrees or a limit at infinity.",
          "Response gives y = 5/2 and justifies it with the numerator and denominator having equal degree (ratio of leading coefficients 5 and 2), or by evaluating lim(x->infinity) D(x) = 5/2, for example by dividing by x^2.",
          "State y = 5/2 and give a reason based on the equal degrees or the limit at infinity.", ["y = 5/2", "y = 2.5"]),
    ],
    [
        ("denominator factors as 2x(x-4)", lambda: expand(2 * x * (x - 4)) == expand(2 * x**2 - 8 * x)),
        ("numerator at 0 is -3, at 4 is 77", lambda: ((5 * x**2 - 3).subs(x, 0), (5 * x**2 - 3).subs(x, 4)) == (-3, 77)),
        ("lim x->4- D = -oo", lambda: lim(f2, 4, "-") == -oo),
        ("lim x->4+ D = +oo (x=4 is a vertical asymptote)", lambda: lim(f2, 4, "+") == oo),
        ("lim x->0+ D = +oo", lambda: lim(f2, 0, "+") == oo),
        ("lim x->0- D = -oo (x=0 is a vertical asymptote)", lambda: lim(f2, 0, "-") == -oo),
        ("lim x->oo D = 5/2", lambda: lim(f2, oo, "-") == Rational(5, 2)),
        ("lim x->-oo D = 5/2", lambda: lim(f2, -oo, "+") == Rational(5, 2)),
    ],
    change="numbers: new function with equal degrees, asymptotes 0 and 4, horizontal asymptote 5/2 instead of 0; context: pure function -> dosage ratio"))

f3 = (x + 4) / ((x - 1) ** 2 * (x + 2))
VARIANTS.append(F(
    "002-v3", "002", "hard", "Asymptotes of a Signal Model With a Repeated Factor",
    "The strength S of a signal at distance x meters from a transmitter mast is modeled by S(x) = (x + 4)/((x - 1)^2 (x + 2)).",
    ANS + "\n\n(a) Find all vertical asymptotes of the graph of S. Justify your answer.\n\n(b) Find lim(x->1) S(x). Give a reason for the sign of your answer.\n\n(c) Find lim(x->-2-) S(x). Give a reason for the sign of your answer.\n\n(d) Write an equation for the horizontal asymptote of the graph of S, or explain why there is none.",
    [
        C("part-a-criterion-01", "Identifies x = 1 and x = -2 and justifies each with a zero denominator and a nonzero numerator.",
          "Response identifies x = 1 and x = -2 as the zeros of the denominator (x - 1)^2 (x + 2), noting that the numerator x + 4 is nonzero (5 and 2) at each.",
          "Name both asymptotes and state that the numerator is nonzero at each. Listing the zeros of the denominator alone is not enough."),
        C("part-b-criterion-01", "Finds lim(x->1) S(x) = infinity, with sign reasoning that uses the squared factor.",
          "Response gives infinity and explains that near 1 the numerator is positive (about 5), (x - 1)^2 is small and positive on both sides of 1, and x + 2 is positive (about 3), so S is large and positive from both the left and the right.",
          "Give infinity and explain why the sign is the same on both sides, using that (x - 1)^2 is positive.", ["+infinity", "positive infinity"]),
        C("part-c-criterion-01", "Finds lim(x->-2-) S(x) = -infinity, with sign reasoning.",
          "Response gives -infinity and explains that near -2 from the left the numerator is positive (about 2), (x - 1)^2 is positive (about 9), and x + 2 is small and negative, so the quotient is negative.",
          "Give -infinity and justify the sign of each factor.", ["negative infinity"]),
        C("part-d-criterion-01", "States the horizontal asymptote y = 0 with a valid reason based on degrees or a limit at infinity.",
          "Response gives y = 0 and justifies it with the degree of the denominator (3) exceeding the degree of the numerator (1), or by evaluating lim(x->infinity) S(x) = 0.",
          "State y = 0 and give a reason based on degrees or the limit at infinity.", ["y = 0"]),
    ],
    [
        ("numerator x+4 at 1 is 5, at -2 is 2", lambda: ((x + 4).subs(x, 1), (x + 4).subs(x, -2)) == (5, 2)),
        ("lim x->1- S = +oo", lambda: lim(f3, 1, "-") == oo),
        ("lim x->1+ S = +oo", lambda: lim(f3, 1, "+") == oo),
        ("lim x->1 S = +oo (two-sided)", lambda: lim(f3, 1) == oo),
        ("(x+2) at 1 is 3 and (x-1)^2 is nonnegative", lambda: (x + 2).subs(x, 1) == 3),
        ("lim x->-2- S = -oo", lambda: lim(f3, -2, "-") == -oo),
        ("(x-1)^2 at -2 is 9", lambda: ((x - 1) ** 2).subs(x, -2) == 9),
        ("lim x->-2+ S = +oo (x=-2 is a vertical asymptote)", lambda: lim(f3, -2, "+") == oo),
        ("lim x->oo S = 0", lambda: lim(f3, oo, "-") == 0),
        ("lim x->-oo S = 0", lambda: lim(f3, -oo, "+") == 0),
    ],
    change="numbers: new function with a repeated factor (x-1)^2 and cubic denominator; part (b) becomes a two-sided limit; context: pure function -> signal strength"))

# ------------------------------------------------------------------ 003
A1 = (72 * t + 30) / (4 * t + 9)
q1 = (5 * x - 2) / sqrt(4 * x**2 + 7)
c1 = (7**x + x**6) / (4**x + x**10)
VARIANTS.append(F(
    "003-v1", "003", "hard", "Long-Run Drug Concentration and Growth-Rate Comparison",
    "The concentration of a medication in a patient's bloodstream, in milligrams per liter, t hours after an injection is modeled by C(t) = (72t + 30)/(4t + 9) for t >= 0.",
    ANS + "\n\n(a) Find lim(t->infinity) C(t). Include units and interpret the meaning of your answer in context.\n\n(b) Let q(x) = (5x - 2)/sqrt(4x^2 + 7). Find all horizontal asymptotes of the graph of q. Show the work that leads to each.\n\n(c) Evaluate lim(x->infinity) (7^x + x^6)/(4^x + x^10). Justify your answer using the relative growth rates of the functions involved.",
    [
        C("part-a-criterion-01", "Finds lim(t->infinity) C(t) = 18 using the leading terms or dividing by t.",
          "Response evaluates the limit as 18, for example by dividing by t or comparing leading coefficients 72 and 4.",
          "Show the method (dividing by t or comparing leading terms) along with the value 18.", ["18"]),
        C("part-a-criterion-02", "Interprets the limit with units: the concentration approaches 18 milligrams per liter in the long run.",
          "Response states that as time increases without bound, the concentration of the medication approaches (levels off near) 18 milligrams per liter.",
          "Include the units (milligrams per liter) and say what quantity approaches 18 as time grows.", ["18 mg/L", "18 milligrams per liter"]),
        C("part-b-criterion-01", "Finds both horizontal asymptotes y = 5/2 and y = -5/2, using sqrt(4x^2) = 2|x|.",
          "Response gives y = 5/2 (as x approaches infinity) and y = -5/2 (as x approaches negative infinity), showing that the radical behaves like 2|x|.",
          "Give both asymptotes and show that the denominator behaves like 2|x|, so its sign relative to x flips for negative x.", ["y = 5/2 and y = -5/2"]),
        C("part-c-criterion-01", "Finds the limit is infinity and justifies with 7^x growing faster than 4^x and any power of x.",
          "Response gives infinity and justifies that 7^x outgrows 4^x and powers of x (for example by dividing by 7^x to obtain a numerator approaching 1 and a denominator approaching 0 from above).",
          "State infinity and compare growth rates of 7^x, 4^x, x^6 and x^10.", ["infinity", "positive infinity"]),
    ],
    [
        ("lim t->oo C = 18", lambda: lim(A1, oo, "-", t) == 18),
        ("ratio of leading coefficients 72/4 = 18", lambda: Rational(72, 4) == 18),
        ("lim x->oo q = 5/2", lambda: lim(q1, oo, "-") == Rational(5, 2)),
        ("lim x->-oo q = -5/2", lambda: lim(q1, -oo, "+") == Rational(-5, 2)),
        ("sqrt(4x^2) = 2|x|", lambda: same(sqrt(4 * x**2), 2 * abs(x))),
        ("lim of (1 + x^6/7^x) is 1", lambda: lim(1 + x**6 / 7**x, oo, "-") == 1),
        ("lim of ((4/7)^x + x^10/7^x) is 0", lambda: lim((Rational(4, 7)) ** x + x**10 / 7**x, oo, "-") == 0),
        ("the divided form equals the original", lambda: same(c1, (1 + x**6 / 7**x) / ((Rational(4, 7)) ** x + x**10 / 7**x))),
        ("lim x->oo (7^x+x^6)/(4^x+x^10) = oo", lambda: lim(c1, oo, "-") == oo),
    ],
    change="numbers: 80/2->72/4 (limit 18), radical (4x+1)/sqrt(9x^2+2)->(5x-2)/sqrt(4x^2+7), 5^x/3^x -> 7^x/4^x with x^6, x^10; context: salt in a tank -> drug concentration"))

A2 = (90 * t**2 + 40) / (3 * t**2 + 2 * t + 1)
q2 = (6 - 3 * x) / sqrt(x**2 + 5)
c2 = (3 * 2**x + x**8) / (5 * 2**x + x**3)
VARIANTS.append(F(
    "003-v2", "003", "hard", "Terminal Speed and Growth Rates With Matching Exponentials",
    "The speed of a rocket sled, in meters per second, t seconds after release is modeled by v(t) = (90t^2 + 40)/(3t^2 + 2t + 1) for t >= 0.",
    ANS + "\n\n(a) Find lim(t->infinity) v(t). Include units and interpret the meaning of your answer in context.\n\n(b) Let q(x) = (6 - 3x)/sqrt(x^2 + 5). Find all horizontal asymptotes of the graph of q. Show the work that leads to each.\n\n(c) Evaluate lim(x->infinity) (3(2^x) + x^8)/(5(2^x) + x^3). Justify your answer using the relative growth rates of the functions involved.",
    [
        C("part-a-criterion-01", "Finds lim(t->infinity) v(t) = 30 using the leading terms or dividing by t^2.",
          "Response evaluates the limit as 30, for example by dividing by t^2 or comparing leading coefficients 90 and 3.",
          "Show the method (dividing by t^2 or comparing leading terms) along with the value 30.", ["30"]),
        C("part-a-criterion-02", "Interprets the limit with units: the speed approaches 30 meters per second in the long run.",
          "Response states that as time increases without bound, the speed of the sled approaches (levels off near) 30 meters per second.",
          "Include the units (meters per second) and say what quantity approaches 30 as time grows.", ["30 m/s", "30 meters per second"]),
        C("part-b-criterion-01", "Finds both horizontal asymptotes y = -3 and y = 3, using sqrt(x^2) = |x|.",
          "Response gives y = -3 (as x approaches infinity) and y = 3 (as x approaches negative infinity), showing that the radical behaves like |x|, so the quotient behaves like (-3x)/|x|.",
          "Give both asymptotes and show that the denominator behaves like |x|, so the sign of the ratio flips for negative x.", ["y = -3 and y = 3"]),
        C("part-c-criterion-01", "Finds the limit is 3/5 and justifies that 2^x dominates x^8 and x^3 in numerator and denominator.",
          "Response gives 3/5 and justifies that 2^x grows faster than any power of x, so x^8 and x^3 become negligible next to the 2^x terms (for example by dividing by 2^x to obtain (3 + x^8/2^x)/(5 + x^3/2^x) with both power-over-exponential terms approaching 0).",
          "State 3/5 and explain that the exponential 2^x outgrows both x^8 and x^3, leaving the ratio of coefficients 3 and 5.", ["3/5", "0.6"]),
    ],
    [
        ("lim t->oo v = 30", lambda: lim(A2, oo, "-", t) == 30),
        ("ratio of leading coefficients 90/3 = 30", lambda: Rational(90, 3) == 30),
        ("lim x->oo q = -3", lambda: lim(q2, oo, "-") == -3),
        ("lim x->-oo q = 3", lambda: lim(q2, -oo, "+") == 3),
        ("sqrt(x^2) = |x|", lambda: same(sqrt(x**2), abs(x))),
        ("lim x^8/2^x = 0 and lim x^3/2^x = 0", lambda: lim(x**8 / 2**x, oo, "-") == 0 and lim(x**3 / 2**x, oo, "-") == 0),
        ("divided form equals the original", lambda: same(c2, (3 + x**8 / 2**x) / (5 + x**3 / 2**x))),
        ("lim x->oo (3*2^x+x^8)/(5*2^x+x^3) = 3/5", lambda: lim(c2, oo, "-") == Rational(3, 5)),
    ],
    change="numbers: new degree-2 rational (limit 30), radical with negative leading coefficient (6-3x)/sqrt(x^2+5), part (c) now a finite nonzero limit 3/5 from matching 2^x; context: rocket sled speed"))

A3 = (250 * n + 4000) / (n + 50)
q3 = sqrt(4 * x**2 + 1) / (x + 3)
c3 = (x**12 + 2**x) / (3**x + 8 * x**2)
VARIANTS.append(F(
    "003-v3", "003", "hard", "Average Cost in the Long Run and a Radical Numerator",
    "A workshop's average cost per unit, in dollars, when n units are produced is modeled by A(n) = (250n + 4000)/(n + 50) for n >= 1.",
    ANS + "\n\n(a) Find lim(n->infinity) A(n). Include units and interpret the meaning of your answer in context.\n\n(b) Let q(x) = sqrt(4x^2 + 1)/(x + 3). Find all horizontal asymptotes of the graph of q. Show the work that leads to each.\n\n(c) Evaluate lim(x->infinity) (x^12 + 2^x)/(3^x + 8x^2). Justify your answer using the relative growth rates of the functions involved.",
    [
        C("part-a-criterion-01", "Finds lim(n->infinity) A(n) = 250 using the leading terms or dividing by n.",
          "Response evaluates the limit as 250, for example by dividing by n or comparing leading coefficients 250 and 1.",
          "Show the method (dividing by n or comparing leading terms) along with the value 250.", ["250"]),
        C("part-a-criterion-02", "Interprets the limit with units: the average cost approaches 250 dollars per unit as production grows.",
          "Response states that as the number of units produced increases without bound, the average cost per unit approaches (levels off near) 250 dollars per unit.",
          "Include the units (dollars per unit) and say what quantity approaches 250 as production grows.", ["$250 per unit", "250 dollars per unit"]),
        C("part-b-criterion-01", "Finds both horizontal asymptotes y = 2 and y = -2, using sqrt(4x^2) = 2|x|.",
          "Response gives y = 2 (as x approaches infinity) and y = -2 (as x approaches negative infinity), showing that the radical in the numerator behaves like 2|x|, so the quotient behaves like 2|x|/x.",
          "Give both asymptotes and show that the numerator behaves like 2|x|, so the sign of the ratio flips for negative x.", ["y = 2 and y = -2"]),
        C("part-c-criterion-01", "Finds the limit is 0 and justifies with 3^x growing faster than 2^x and any power of x.",
          "Response gives 0 and justifies that 3^x outgrows 2^x and powers of x, and x^12 is negligible next to 2^x, so the denominator grows faster than the numerator (for example by dividing by 3^x to obtain a numerator approaching 0 and a denominator approaching 1).",
          "State 0 and compare growth rates of 3^x, 2^x, x^12 and x^2.", ["0", "zero"]),
    ],
    [
        ("lim n->oo A = 250", lambda: lim(A3, oo, "-", n) == 250),
        ("lim x->oo q = 2", lambda: lim(q3, oo, "-") == 2),
        ("lim x->-oo q = -2", lambda: lim(q3, -oo, "+") == -2),
        ("sqrt(4x^2) = 2|x|", lambda: same(sqrt(4 * x**2), 2 * abs(x))),
        ("lim (x^12+2^x)/3^x = 0", lambda: lim((x**12 + 2**x) / 3**x, oo, "-") == 0),
        ("lim (1 + 8x^2/3^x) = 1", lambda: lim(1 + 8 * x**2 / 3**x, oo, "-") == 1),
        ("divided form equals the original", lambda: same(c3, ((x**12 + 2**x) / 3**x) / (1 + 8 * x**2 / 3**x))),
        ("lim x->oo (x^12+2^x)/(3^x+8x^2) = 0", lambda: lim(c3, oo, "-") == 0),
    ],
    change="numbers: new average-cost rational (limit 250), radical now in the numerator (asymptotes +-2), part (c) now limit 0 with 3^x in the denominator; context: pure salt tank -> workshop average cost"))

# ------------------------------------------------------------------ 004
fr1 = (x**2 + x - 6) / (x - 2)
VARIANTS.append(F(
    "004-v1", "004", "medium", "Continuity of a Shipping Fee at a Weight Threshold",
    "A shipping fee f, in dollars, for a package of weight x kilograms is modeled by\n\nf(x) = kx - 1 for x < 2\nf(2) = m\nf(x) = (x^2 + x - 6)/(x - 2) for x > 2\n\nwhere k and m are constants.",
    ANS + "\n\n(a) Find lim(x->2+) f(x). Show the work that leads to your answer.\n\n(b) Find the values of k and m for which f is continuous at x = 2. Justify your answer using the definition of continuity.\n\n(c) Suppose k = 3 and m = 4. Is f continuous at x = 2? If not, classify the discontinuity and justify your answer.",
    [
        C("part-a-criterion-01", "Factors and cancels to find lim(x->2+) f(x) = 5.",
          "Response factors x^2 + x - 6 = (x + 3)(x - 2), cancels x - 2, and evaluates x + 3 at x = 2 to get 5.",
          "Show the factoring and cancellation, not just the value 5.", ["5"]),
        C("part-b-criterion-01", "Sets the left-hand limit equal to the right-hand limit and finds k = 3.",
          "Response sets k(2) - 1 = 5 (the left-hand limit equals the right-hand limit) and finds k = 3.",
          "Set the one-sided limits equal and solve for k.", ["k = 3"]),
        C("part-b-criterion-02", "Sets m equal to the limit and finds m = 5, citing the three conditions of continuity.",
          "Response states that f(2) must equal the limit as x approaches 2, so m = 5, referencing that f(2) is defined, the limit exists, and the two are equal.",
          "State that f(2) must equal the limit and give m = 5.", ["m = 5"]),
        C("part-c-criterion-01", "Finds that the limit exists (5 from both sides) but f(2) = 4, concludes f is not continuous, and classifies the discontinuity as removable.",
          "Response gives lim(x->2-) f(x) = 3(2) - 1 = 5 and lim(x->2+) f(x) = 5, so the limit is 5, notes that f(2) = 4 does not equal 5, concludes f is not continuous, and names the discontinuity removable.",
          "Give both one-sided limits (each 5), compare with f(2) = 4, conclude f is not continuous, and name the discontinuity type.", ["removable"]),
    ],
    [
        ("x^2+x-6 factors as (x+3)(x-2)", lambda: expand((x + 3) * (x - 2)) == expand(x**2 + x - 6)),
        ("lim x->2+ f = 5", lambda: lim(fr1, 2, "+") == 5),
        ("continuity in (b): 2k-1 = 5 gives k = 3", lambda: S(2) * 3 - 1 == 5),
        ("m equals the limit 5", lambda: lim(fr1, 2, "+") == 5),
        ("part (c) left limit 3*2-1 = 5", lambda: (3 * x - 1).subs(x, 2) == 5),
        ("part (c) right limit 5, f(2)=4 differs, so removable", lambda: lim(fr1, 2, "+") == 5 and 4 != 5),
    ],
    change="numbers: point 1 -> 2, limit 4 -> 5, k 2 -> 3, m 4 -> 5; context: pure function -> shipping fee; part (c) uses k, m giving a removable (not jump) discontinuity"))

fr2 = (x - 4) / (sqrt(x) - 2)
VARIANTS.append(F(
    "004-v2", "004", "medium", "Continuity of a Sensor Reading With a Radical Piece",
    "A sensor's calibrated reading f, in volts, at input level x is modeled by\n\nf(x) = kx^2 - 4 for x < 4\nf(4) = m\nf(x) = (x - 4)/(sqrt(x) - 2) for x > 4\n\nwhere k and m are constants.",
    ANS + "\n\n(a) Find lim(x->4+) f(x). Show the work that leads to your answer.\n\n(b) Find the values of k and m for which f is continuous at x = 4. Justify your answer using the definition of continuity.\n\n(c) Suppose k = 1/2 and m = 0. Is f continuous at x = 4? If not, classify the discontinuity and justify your answer.",
    [
        C("part-a-criterion-01", "Multiplies by the conjugate sqrt(x) + 2 (or equivalent) and cancels to find lim(x->4+) f(x) = 4.",
          "Response multiplies numerator and denominator by sqrt(x) + 2, obtains (x - 4)(sqrt(x) + 2)/(x - 4), cancels x - 4, and evaluates sqrt(x) + 2 at x = 4 to get 4. Recognizing x - 4 = (sqrt(x) - 2)(sqrt(x) + 2) and cancelling is equivalent.",
          "Show the conjugate (or difference-of-squares) step and the cancellation, not just the value 4.", ["4"]),
        C("part-b-criterion-01", "Sets the left-hand limit equal to the right-hand limit and finds k = 1/2.",
          "Response sets k(4)^2 - 4 = 4, that is 16k - 4 = 4 (the left-hand limit equals the right-hand limit), and finds k = 1/2.",
          "Set the one-sided limits equal and solve for k.", ["k = 1/2", "k = 0.5"]),
        C("part-b-criterion-02", "Sets m equal to the limit and finds m = 4, citing the three conditions of continuity.",
          "Response states that f(4) must equal the limit as x approaches 4, so m = 4, referencing that f(4) is defined, the limit exists, and the two are equal.",
          "State that f(4) must equal the limit and give m = 4.", ["m = 4"]),
        C("part-c-criterion-01", "Finds that the limit exists (4 from both sides) but f(4) = 0, concludes f is not continuous, and classifies the discontinuity as removable.",
          "Response gives lim(x->4-) f(x) = (1/2)(16) - 4 = 4 and lim(x->4+) f(x) = 4, so the limit is 4, notes that f(4) = 0 does not equal 4, concludes f is not continuous, and names the discontinuity removable.",
          "Give both one-sided limits (each 4), compare with f(4) = 0, conclude f is not continuous, and name the discontinuity type.", ["removable"]),
    ],
    [
        ("f equals sqrt(x)+2 for x > 4", lambda: same(fr2, sqrt(x) + 2) or same(fr2.subs(x, 9), S(5))),
        ("lim x->4+ f = 4", lambda: lim(fr2, 4, "+") == 4),
        ("(sqrt(x)-2)(sqrt(x)+2) = x-4", lambda: same((sqrt(x) - 2) * (sqrt(x) + 2), x - 4)),
        ("16k - 4 = 4 gives k = 1/2", lambda: 16 * Rational(1, 2) - 4 == 4),
        ("m equals the limit 4", lambda: lim(fr2, 4, "+") == 4),
        ("part (c) left limit with k=1/2 is 4", lambda: lim(Rational(1, 2) * x**2 - 4, 4, "-") == 4),
        ("part (c) two-sided limit 4 differs from f(4)=0", lambda: lim(fr2, 4, "+") == 4 and 0 != 4),
    ],
    change="numbers: point 1 -> 4, right piece now a radical quotient needing the conjugate, left piece quadratic in k; context: pure function -> sensor reading; part (c) gives a removable discontinuity"))

fr3 = (2 * x**2 + 5 * x - 3) / (x + 3)
VARIANTS.append(F(
    "004-v3", "004", "medium", "Continuity of a Temperature Adjustment Across a Boundary",
    "The temperature adjustment f, in degrees, at position x along a heated rod is modeled by\n\nf(x) = (2x^2 + 5x - 3)/(x + 3) for x < -3\nf(-3) = m\nf(x) = kx + 5 for x > -3\n\nwhere k and m are constants.",
    ANS + "\n\n(a) Find lim(x->-3-) f(x). Show the work that leads to your answer.\n\n(b) Find the values of k and m for which f is continuous at x = -3. Justify your answer using the definition of continuity.\n\n(c) Suppose k = 1 and m = -7. Is f continuous at x = -3? If not, classify the discontinuity and justify your answer.",
    [
        C("part-a-criterion-01", "Factors and cancels to find lim(x->-3-) f(x) = -7.",
          "Response factors 2x^2 + 5x - 3 = (2x - 1)(x + 3), cancels x + 3, and evaluates 2x - 1 at x = -3 to get -7.",
          "Show the factoring and cancellation, not just the value -7.", ["-7"]),
        C("part-b-criterion-01", "Sets the right-hand limit equal to the left-hand limit and finds k = 4.",
          "Response sets k(-3) + 5 = -7 (the right-hand limit equals the left-hand limit) and finds k = 4.",
          "Set the one-sided limits equal and solve for k.", ["k = 4"]),
        C("part-b-criterion-02", "Sets m equal to the limit and finds m = -7, citing the three conditions of continuity.",
          "Response states that f(-3) must equal the limit as x approaches -3, so m = -7, referencing that f(-3) is defined, the limit exists, and the two are equal.",
          "State that f(-3) must equal the limit and give m = -7.", ["m = -7"]),
        C("part-c-criterion-01", "Finds the one-sided limits -7 and 2, concludes f is not continuous, and classifies it as a jump discontinuity.",
          "Response gives lim(x->-3-) f(x) = -7 and lim(x->-3+) f(x) = 1(-3) + 5 = 2, concludes that the limit does not exist so f is not continuous (even though f(-3) = -7), and names the discontinuity a jump discontinuity.",
          "Give both one-sided limits (-7 and 2), conclude f is not continuous, and name the discontinuity type.", ["jump"]),
    ],
    [
        ("2x^2+5x-3 factors as (2x-1)(x+3)", lambda: expand((2 * x - 1) * (x + 3)) == expand(2 * x**2 + 5 * x - 3)),
        ("lim x->-3- f = -7", lambda: lim(fr3, -3, "-") == -7),
        ("-3k + 5 = -7 gives k = 4", lambda: -3 * 4 + 5 == -7),
        ("m equals the limit -7", lambda: lim(fr3, -3, "-") == -7),
        ("part (c) right limit with k=1 is 2", lambda: lim(1 * x + 5, -3, "+") == 2),
        ("part (c) one-sided limits differ (-7 vs 2)", lambda: lim(fr3, -3, "-") != lim(x + 5, -3, "+")),
    ],
    change="numbers: point 1 -> -3; the rational (hole) piece is now on the LEFT and part (a) asks for the left-hand limit; context: pure function -> temperature adjustment along a rod; part (c) is a jump"))

# ------------------------------------------------------------------ 005
h1 = lambda v: (v**3 - 4 * v) / (v**2 + v - 6)
p1 = ["1.9", "1.99", "1.999", "2.001", "2.01", "2.1"]
s1 = table_stimulus("A technician records the response ratio h of a sensor at setting x and models it by h(x) = (x^3 - 4x)/(x^2 + x - 6) for x != 2 and x != -3. Selected values of h(x) are given in the table.", h1, p1)
VARIANTS.append(F(
    "005-v1", "005", "medium", "Table Estimate and Factoring Confirmation of a Sensor Ratio",
    s1,
    ANS + "\n\n(a) Use the table to estimate lim(x->2) h(x). Explain how the table supports your estimate.\n\n(b) Use algebra to find the exact value of lim(x->2) h(x). Show your work.\n\n(c) The function h is extended by defining h(2) = 1.5. Is the extended function continuous at x = 2? If not, classify the discontinuity and justify your answer.",
    [
        C("part-a-criterion-01", "Estimates the limit near 1.6 and supports it with values from both sides of 2.",
          "Response gives an estimate of about 1.6 and notes that the values from both the left and the right of x = 2 approach that number.",
          "Cite values from both sides of 2, not just one side, when supporting the estimate.", ["1.6", "8/5"]),
        C("part-b-criterion-01", "Factors the numerator as x(x - 2)(x + 2) and the denominator, and cancels the common factor x - 2.",
          "Response factors the numerator as x(x - 2)(x + 2) and the denominator as (x - 2)(x + 3), then cancels the common factor x - 2 (x is a factor of the numerator only, not a common factor) to obtain x(x + 2)/(x + 3).",
          "Show the complete factoring of x^3 - 4x and the cancellation of x - 2.", []),
        C("part-b-criterion-02", "Evaluates to the exact limit 8/5.",
          "Response evaluates x(x + 2)/(x + 3) at x = 2 to obtain 2(4)/5 = 8/5.",
          "State the exact value 8/5.", ["8/5", "1.6"]),
        C("part-c-criterion-01", "Concludes the extended function is not continuous because 1.5 does not equal 8/5, and calls the discontinuity removable.",
          "Response states that the limit 8/5 exists but does not equal h(2) = 1.5 (which is 3/2), so h is not continuous at x = 2, and that the discontinuity is removable.",
          "Compare the limit 8/5 with the value 1.5, state that they differ, and name the discontinuity removable.", ["removable"]),
    ],
    [
        ("table values match h(x) to 4 decimals", lambda: table_check(s1, h1)),
        ("table has points on both sides of 2", lambda: all(Rational(p) < 2 for p in p1[:3]) and all(Rational(p) > 2 for p in p1[3:])),
        ("numerator x^3-4x = x(x-2)(x+2)", lambda: expand(x * (x - 2) * (x + 2)) == expand(x**3 - 4 * x)),
        ("denominator = (x-2)(x+3)", lambda: expand((x - 2) * (x + 3)) == expand(x**2 + x - 6)),
        ("h equals x(x+2)/(x+3) away from 2", lambda: same(h1(x), x * (x + 2) / (x + 3))),
        ("lim x->2 h = 8/5", lambda: lim(h1(x), 2) == Rational(8, 5)),
        ("8/5 is 1.6 and 3/2 is 1.5, so they differ", lambda: Rational(8, 5) == Rational(16, 10) and Rational(3, 2) == Rational(15, 10)),
    ],
    change="function family: conjugate radical -> rational needing a common factor x pulled out then factoring; point 5 -> 2, limit 1/6 -> 8/5; context: pure function -> sensor response ratio"))

h2 = lambda v: (1 / v - Rational(1, 4)) / (v - 4)
p2 = ["3.9", "3.99", "3.999", "4.001", "4.01", "4.1"]
s2 = table_stimulus("A lens designer models the ratio h of two focal readings at setting x by h(x) = (1/x - 1/4)/(x - 4) for x != 4 and x != 0. Selected values of h(x) are given in the table.", h2, p2)
VARIANTS.append(F(
    "005-v2", "005", "medium", "Table Estimate and Complex-Fraction Confirmation of a Lens Ratio",
    s2,
    ANS + "\n\n(a) Use the table to estimate lim(x->4) h(x). Explain how the table supports your estimate.\n\n(b) Use algebra to find the exact value of lim(x->4) h(x). Show your work.\n\n(c) The function h is extended by defining h(4) = -0.05. Is the extended function continuous at x = 4? If not, classify the discontinuity and justify your answer.",
    [
        C("part-a-criterion-01", "Estimates the limit near -0.0625 and supports it with values from both sides of 4.",
          "Response gives an estimate of about -0.0625 (or -1/16) and notes that the values from both the left and the right of x = 4 approach that number.",
          "Cite values from both sides of 4, not just one side, when supporting the estimate.", ["-0.0625", "-0.063", "-0.06", "-1/16"]),
        C("part-b-criterion-01", "Combines 1/x - 1/4 over a common denominator and cancels x - 4.",
          "Response rewrites 1/x - 1/4 as (4 - x)/(4x), so h(x) = (4 - x)/(4x(x - 4)) = -(x - 4)/(4x(x - 4)), and cancels x - 4 to obtain -1/(4x).",
          "Show the common-denominator step, the factor 4 - x = -(x - 4), and the cancellation.", []),
        C("part-b-criterion-02", "Evaluates to the exact limit -1/16.",
          "Response evaluates -1/(4x) at x = 4 to obtain -1/16.",
          "State the exact value -1/16.", ["-1/16", "-0.0625"]),
        C("part-c-criterion-01", "Concludes the extended function is not continuous because -0.05 does not equal -1/16, and calls the discontinuity removable.",
          "Response states that the limit -1/16 exists but does not equal h(4) = -0.05 (which is -1/20), so h is not continuous at x = 4, and that the discontinuity is removable.",
          "Compare the limit -1/16 with the value -0.05, state that they differ, and name the discontinuity removable.", ["removable"]),
    ],
    [
        ("table values match h(x) to 4 decimals", lambda: table_check(s2, h2)),
        ("table has points on both sides of 4", lambda: all(Rational(p) < 4 for p in p2[:3]) and all(Rational(p) > 4 for p in p2[3:])),
        ("1/x - 1/4 = (4-x)/(4x)", lambda: same(1 / x - Rational(1, 4), (4 - x) / (4 * x))),
        ("h equals -1/(4x) away from 4", lambda: same(h2(x), -1 / (4 * x))),
        ("lim x->4 h = -1/16", lambda: lim(h2(x), 4) == Rational(-1, 16)),
        ("-1/16 = -0.0625 differs from -0.05 = -1/20", lambda: Rational(-1, 16) == Rational(-625, 10000) and Rational(-5, 100) == Rational(-1, 20) and Rational(-1, 16) != Rational(-1, 20)),
    ],
    change="function family: conjugate radical -> complex fraction (1/x - 1/4)/(x-4); point 5 -> 4, limit 1/6 -> -1/16 (negative); context: pure function -> lens focal ratio"))

h3 = lambda v: (sqrt(3 * v - 2) - 4) / (v - 6)
p3 = ["5.9", "5.99", "5.999", "6.001", "6.01", "6.1"]
s3 = table_stimulus("A chemist models the rate h of a reaction at concentration x by h(x) = (sqrt(3x - 2) - 4)/(x - 6) for x != 6. Selected values of h(x) are given in the table.", h3, p3)
VARIANTS.append(F(
    "005-v3", "005", "medium", "Table Estimate and Conjugate Confirmation of a Reaction Rate",
    s3,
    ANS + "\n\n(a) Use the table to estimate lim(x->6) h(x). Explain how the table supports your estimate.\n\n(b) Use algebra to find the exact value of lim(x->6) h(x). Show your work.\n\n(c) The function h is extended by defining h(6) = 0.4. Is the extended function continuous at x = 6? If not, classify the discontinuity and justify your answer.",
    [
        C("part-a-criterion-01", "Estimates the limit near 0.375 and supports it with values from both sides of 6.",
          "Response gives an estimate of about 0.375 (or 3/8) and notes that the values from both the left and the right of x = 6 approach that number.",
          "Cite values from both sides of 6, not just one side, when supporting the estimate.", ["0.375", "0.38", "3/8"]),
        C("part-b-criterion-01", "Multiplies by the conjugate sqrt(3x - 2) + 4 and simplifies.",
          "Response multiplies numerator and denominator by sqrt(3x - 2) + 4 and simplifies the numerator to (3x - 2) - 16 = 3x - 18 = 3(x - 6), then cancels x - 6.",
          "Show the multiplication by the conjugate, the factoring 3x - 18 = 3(x - 6), and the cancellation of x - 6.", []),
        C("part-b-criterion-02", "Evaluates to the exact limit 3/8.",
          "Response evaluates 3/(sqrt(3x - 2) + 4) at x = 6 to obtain 3/(4 + 4) = 3/8.",
          "State the exact value 3/8.", ["3/8", "0.375"]),
        C("part-c-criterion-01", "Concludes the extended function is not continuous because 0.4 does not equal 3/8, and calls the discontinuity removable.",
          "Response states that the limit 3/8 exists but does not equal h(6) = 0.4 (which is 2/5), so h is not continuous at x = 6, and that the discontinuity is removable.",
          "Compare the limit 3/8 with the value 0.4, state that they differ, and name the discontinuity removable.", ["removable"]),
    ],
    [
        ("table values match h(x) to 4 decimals", lambda: table_check(s3, h3)),
        ("table has points on both sides of 6", lambda: all(Rational(p) < 6 for p in p3[:3]) and all(Rational(p) > 6 for p in p3[3:])),
        ("(3x-2)-16 = 3(x-6)", lambda: expand((3 * x - 2) - 16) == expand(3 * (x - 6))),
        ("h equals 3/(sqrt(3x-2)+4) away from 6", lambda: same(h3(x).subs(x, 11), S(3) / (sqrt(31) + 4)) and same(h3(x), 3 / (sqrt(3 * x - 2) + 4))),
        ("lim x->6 h = 3/8", lambda: lim(h3(x), 6) == Rational(3, 8)),
        ("3/8 = 0.375 differs from 0.4 = 2/5", lambda: Rational(3, 8) != Rational(2, 5) and Rational(2, 5) == Rational(4, 10)),
    ],
    change="function family: same conjugate idea but different radical sqrt(3x-2) with coefficient 3 in the numerator after simplifying; point 5 -> 6, limit 1/6 -> 3/8; context: pure function -> reaction rate"))
