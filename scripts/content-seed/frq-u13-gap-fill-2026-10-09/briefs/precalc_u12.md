# FRQ writing brief: precalc_u12

You are writing original short free-response questions (FRQs) for Cramapple, a practice app for AP courses. Students type answers; an automated grader awards each 1-point criterion; the student then sees the criteria and the fix for any missed point. Each FRQ targets ONE designated topic: at least half the points assess that topic's learning objectives, earlier topics may appear only as background, and no part may need a later topic or a later unit. Write everything yourself; do not call any external model or API, do not touch any database, do not commit to git.

Two independent checkers (GPT-6.1 Sol and DeepSeek V4 Pro) and a six-vote topic classifier will judge every item against exactly the rules below. Lessons from earlier rejected attempts are listed per topic; avoid them.

## Rules (the checkers apply exactly these)
1. [on_topic] The question squarely tests the designated topic: at least half of its points assess that topic's learning objectives and essential knowledge (the official CED text below). A student who has studied the designated topic and the earlier units can answer every part; no part needs a later topic or unit.
2. [ced_scope] Every concept, term, formula and method a full-credit answer needs is inside the CED (the official topic text and the fact pack), including its exclusion statements. Do not flag a specific numeric value, named object, or illustrative example merely because it is not verbatim in the fact pack; flag it only if the underlying concept it requires is absent or explicitly excluded.
3. [self_contained_typed] Answerable entirely in typed text. No figure, image, graph or diagram is shown or needed (data appear as plain-text tables, setups are described in words), and no part asks the student to draw, sketch, plot or label a picture. Do not use the words figure or diagram at all; where a topic is usually shown with a picture (free-body diagrams, circuits, graphs of functions), describe it in words and ask the student to list or describe, for example to name each force with its direction.
4. [well_posed] Every part has one defensible correct answer or a clearly stated set of acceptable answers. The given information is consistent and sufficient and numbers are realistic. Judge at the level of the AP course: the standard simplifying assumptions the course itself makes (for example ideal behavior, effects the course tells students to neglect, the usual biological or chemical generalizations taught in the CED) may be left unstated. Flag only a missing given, a contradiction, or an assumption a careful AP student could reasonably make differently.
5. [rubric_points] Every scoring criterion is worth exactly 1 point and awards one specific, observable element of a correct answer to the part it belongs to. A complete correct answer earns every criterion. No criterion rewards something the part did not ask for, double-counts another criterion, prescribes a method the part does not require, or rejects a valid alternative method. Accepted variants are only equivalent forms of a key value or key phrase (for example 3/8, 0.375 and 37.5%); they never replace the evidence requirement, which always applies. When a part asks for a magnitude, the rubric and model answer give a magnitude (with any condition that makes a signed expression positive stated in the question).
6. [rubric_evidence] Every criterion states what a response must show (evidence) and gives a fix: one concrete action, at most 25 words (count them), that a student who missed the point should take next time. Generic advice ("review the topic") fails.
7. [accurate] Every statement and number in the question, the rubric and the model answer is factually and mathematically correct at the level of the AP course. The standard explanation the CED teaches is accurate even where a more advanced treatment would add caveats; flag a statement only if it is wrong, or wrong as an AP teacher would judge it.
8. [model_answer] The model answer is written as a strong student would write it in an exam, labelled by part, shows the work each criterion asks for, and earns every criterion.
9. [style] Plain, calm wording. Mathematics as plain text with Unicode symbols (lim x→3 f(x), f′(x), x², √(x+1), ≤, ≠, π); never LaTeX, HTML, emoji or exclamation marks.
10. [distinct] Not a near-duplicate of the existing questions listed for this topic: a different scenario, function or data set, and where possible a different angle on the topic.

## Hard limits (a program rejects the item otherwise)
- Each criterion is worth exactly 1 point; criteria count and part count per subject are given below.
- Every fix is at most 25 words. Never use the words "figure" or "diagram"; never ask students to draw, sketch, plot or shade. Describe any setup in words; give data as a plain-text table (columns separated by " | ", one row per line).
- Plain text with Unicode maths (x², √, π, ≤, ≠, →, ′, θ, Δ, μ, ε). No LaTeX, no HTML, no emoji, no exclamation marks, no !=, <=, >=.
- accepted_variants: only equivalent forms of a key value or phrase (for example "3/8", "0.375"); never a full alternative answer. Empty list if none.
- verification_python: Python 3 that recomputes EVERY number appearing in the criteria and model answer from the givens, using only sympy, math, fractions, statistics, decimal, itertools, functools, mpmath, cmath; assert each value (tolerances for decimals); last line prints ALL_CHECKS_PASSED. No file, system or network access, no open/eval/exec. For a question with no computed numbers, assert the few facts you can (for example a count) and print ALL_CHECKS_PASSED.
- Lessons from the checkers: do not prescribe a method the part does not require; when a part asks for a magnitude, give a magnitude; state any condition a correct answer depends on; judge accuracy at AP-course level (the standard CED explanation is correct); make every given consistent; ask for justification only where a criterion awards it.

## Output
Write ONE JSON file (UTF-8): a list with one object per topic, exactly:
{"subject_key": "...", "topic_code": "...", "item": {"title": "...", "calculator": "not_permitted|permitted|not_applicable", "stimulus": "...", "parts": [{"prompt": "...", "criteria": [{"text": "...", "evidence": "...", "fix": "...", "accepted_variants": []}]}], "model_answer": "(a) ...\n\n(b) ...", "verification_python": "..."}}
Do not put part letters in prompts (the app adds them). The model answer is a full-credit answer as a strong student writes it, labelled (a), (b), ...
Validate with (free, local):  node /Users/davidbloom/Documents/Cramapple.nosync/.worktrees/frq-gen-2026-10-09/scripts/vercel-gateway-check/frq_pipeline/validate.mjs <your file>
Fix and re-run until every item passes. Then re-read each item once more against the Rules as a strict checker would, especially accuracy, well_posed and rubric_points, and fix what you find.

## Example of one accepted item in the exact output shape (Calculus AB; format only)
```json
{
 "subject_key": "ap_calculus_ab",
 "topic_code": "1.4",
 "item": {
  "title": "Intervals of Continuity for Log, Rational and Piecewise Functions",
  "calculator": "not_permitted",
  "stimulus": "Let h be the function defined by h(x) = ln(x + 2)/(x² − 1).\n\nLet f be the function defined, for a constant k, by\nf(x) = k·cos(πx) + 3 for x ≤ 1\nf(x) = x² + k for x > 1.",
  "model_answer": "(a) The numerator ln(x + 2) is defined only when x + 2 > 0, so x > −2. The denominator x² − 1 = (x − 1)(x + 1) equals 0 at x = −1 and x = 1, so h is undefined there. Logarithmic functions and polynomials are continuous on their domains, and a quotient of continuous functions is continuous wherever the denominator is nonzero. Therefore h is continuous at every point of its domain, which is the intervals (−2, −1), (−1, 1) and (1, ∞).\n\n(b) Yes, h is continuous on [2, 5]. Every x with 2 ≤ x ≤ 5 lies in (1, ∞), where h is continuous at each point, so h is continuous at each point of [2, 5].\nNo, h is not continuous on [0, 2]. The value x = 1 is in [0, 2], and h(1) is undefined because the denominator is 0, so h is not continuous at x = 1 and therefore not continuous on [0, 2].\n\n(c) For x < 1, f(x) = k·cos(πx) + 3 is continuous (cosine is continuous everywhere), and for x > 1, f(x) = x² + k is a polynomial, which is continuous everywhere. So f can fail to be continuous only at x = 1.\nf(1) = k·cos(π) + 3 = 3 − k, and lim x→1⁻ f(x) = 3 − k.\nlim x→1⁺ f(x) = 1² + k = 1 + k.\nFor continuity at x = 1: 3 − k = 1 + k, so 2k = 2 and k = 1. Check: both one-sided limits and f(1) equal 2.",
  "verification_python": "import sympy as sp\nx,k=sp.symbols('x k',real=True)\n# (a) denominator zeros\nroots=sp.solve(sp.Eq(x**2-1,0),x)\nassert set(roots)=={-1,1}\n# ln domain\nassert sp.solve(x+2>0,x)==sp.And(sp.Lt(-2,x),sp.Lt(x,sp.oo)) or True\nassert sp.solve(sp.Eq(x+2,0),x)==[-2]\nh=sp.log(x+2)/(x**2-1)\n# (b) [2,5] inside (1,oo): no excluded points in [2,5]\nfor r in [-2,-1,1]:\n    assert not (2<=r<=5)\nassert 0<=1<=2\nassert h.subs(x,3)==sp.log(5)/8\n# (c)\nleft=k*sp.cos(sp.pi*x)+3\nright=x**2+k\nL=sp.limit(left,x,1,'-')\nR=sp.limit(right,x,1,'+')\nassert sp.simplify(L-(3-k))==0\nassert sp.simplify(R-(1+k))==0\nsol=sp.solve(sp.Eq(L,R),k)\nassert sol==[1]\nassert L.subs(k,1)==2 and R.subs(k,1)==2\nprint('ALL_CHECKS_PASSED')",
  "parts": [
   {
    "prompt": "Determine all intervals on which h is continuous. Justify your answer using properties of the functions that make up h.",
    "criteria": [
     {
      "text": "Excludes x ≤ −2 because ln(x + 2) is defined only when x + 2 > 0, that is, x > −2.",
      "evidence": "Response states that the logarithm requires x + 2 > 0, so values with x ≤ −2 are not in the domain of h.",
      "fix": "Before listing intervals, write the domain condition for every logarithm: its argument must be strictly positive.",
      "accepted_variants": [
       "x > −2",
       "domain starts at −2, not included"
      ]
     },
     {
      "text": "Excludes x = −1 and x = 1 because they make the denominator x² − 1 equal to 0.",
      "evidence": "Response solves x² − 1 = 0 (or factors (x − 1)(x + 1)) and states that h is undefined at x = −1 and x = 1.",
      "fix": "Set the denominator equal to zero, solve, and remove each solution from the domain, even when the numerator is also zero.",
      "accepted_variants": [
       "x ≠ ±1"
      ]
     },
     {
      "text": "States h is continuous on (−2, −1), (−1, 1) and (1, ∞), justified because ln and polynomials are continuous on their domains and a quotient is continuous where the denominator is nonzero.",
      "evidence": "Response lists exactly the three open intervals (−2, −1), (−1, 1), (1, ∞) and cites continuity of logarithmic and polynomial (or rational) functions on their domains.",
      "fix": "After finding the domain, name the function types involved and state they are continuous on their domains, so h is continuous on its domain.",
      "accepted_variants": [
       "−2 < x < −1, −1 < x < 1, x > 1"
      ]
     }
    ]
   },
   {
    "prompt": "Is h continuous on the closed interval [2, 5]? Is h continuous on the closed interval [0, 2]? Explain each answer.",
    "criteria": [
     {
      "text": "Yes, h is continuous on [2, 5] because [2, 5] lies inside (1, ∞), where h is continuous at every point.",
      "evidence": "Response answers yes and explains that every point of [2, 5] belongs to an interval on which h is continuous (or is in the domain of h).",
      "fix": "Check whether the whole interval lies inside one interval of continuity; if so, h is continuous at each of its points.",
      "accepted_variants": [
       "continuous on [2, 5]"
      ]
     },
     {
      "text": "No, h is not continuous on [0, 2] because x = 1 is in [0, 2] and h(1) is undefined.",
      "evidence": "Response answers no and identifies x = 1 as a point of [0, 2] where h is not defined, so h is not continuous at every point of the interval.",
      "fix": "Test each excluded value against the interval; one point where the function is undefined breaks continuity on the whole interval.",
      "accepted_variants": [
       "not continuous on [0, 2]"
      ]
     }
    ]
   },
   {
    "prompt": "Find the value of k for which f is continuous for all real numbers x. Show the work that leads to your answer.",
    "criteria": [
     {
      "text": "Explains that each piece of f is continuous on its own interval (a trigonometric plus constant function and a polynomial), so only x = 1 needs to be checked.",
      "evidence": "Response states that k·cos(πx) + 3 and x² + k are continuous everywhere, so continuity of f can fail only at x = 1.",
      "fix": "Begin piecewise continuity problems by stating each piece is continuous on its interval because of its function type, then check the boundary.",
      "accepted_variants": []
     },
     {
      "text": "Sets up the continuity condition at x = 1: lim x→1⁻ f(x) = 3 − k equals lim x→1⁺ f(x) = 1 + k, and f(1) = 3 − k.",
      "evidence": "Response computes the left-hand limit (or f(1)) as k·cos(π) + 3 = 3 − k and the right-hand limit as 1 + k and sets them equal.",
      "fix": "Evaluate both one-sided limits at the boundary using cos(π) = −1, then require they agree with f(1).",
      "accepted_variants": [
       "3 − k = 1 + k"
      ]
     },
     {
      "text": "Finds k = 1.",
      "evidence": "Response solves 3 − k = 1 + k correctly to obtain k = 1.",
      "fix": "Solve the equation from equal one-sided limits carefully and substitute back to confirm both sides give the same value, here 2.",
      "accepted_variants": [
       "k=1"
      ]
     }
    ]
   }
  ]
 }
}
```


# Subject: AP Precalculus (subject_key ap_precalculus)
Format: Short free-response in AP Precalculus style: exactly three parts, (a), (b) and (c), each worth exactly 2 points (two criteria per part). A function or context is given algebraically, in words, or as a small plain-text table.
Parts: 3-3. Criteria (points) in total: 6-6.

## Topics in this subject's Units 1, 2, 3 (stay inside the designated topic)
1.1 Change in Tandem (Unit 1: Polynomial and Rational Functions)
1.10 Rational Functions and Holes (Unit 1: Polynomial and Rational Functions)
1.11 Equivalent Representations (Unit 1: Polynomial and Rational Functions)
1.12 Transformations of Functions (Unit 1: Polynomial and Rational Functions)
1.13 Function Model Selection and Assumption Articulation (Unit 1: Polynomial and Rational Functions)
1.14 Function Model Construction and Application (Unit 1: Polynomial and Rational Functions)
1.2 Rates of Change (Unit 1: Polynomial and Rational Functions)
1.3 Rates of Change and Behavior of Graphs (Unit 1: Polynomial and Rational Functions)
1.4 Polynomial Functions and Rates of Change (Unit 1: Polynomial and Rational Functions)
1.5 Polynomial Functions and Complex Zeros (Unit 1: Polynomial and Rational Functions)
1.6 Polynomial Functions and End Behavior (Unit 1: Polynomial and Rational Functions)
1.7 Rational Functions and End Behavior (Unit 1: Polynomial and Rational Functions)
1.8 Rational Functions and Zeros (Unit 1: Polynomial and Rational Functions)
1.9 Rational Functions and Vertical Asymptotes (Unit 1: Polynomial and Rational Functions)
2.1 Change in Arithmetic and Geometric Sequences (Unit 2: Exponential and Logarithmic Functions)
2.10 Inverses of Exponential Functions (Unit 2: Exponential and Logarithmic Functions)
2.11 Logarithmic Functions (Unit 2: Exponential and Logarithmic Functions)
2.12 Logarithmic Function Manipulation (Unit 2: Exponential and Logarithmic Functions)
2.13 Exponential and Logarithmic Equations and Inequalities (Unit 2: Exponential and Logarithmic Functions)
2.14 Logarithmic Function Context and Data Modeling (Unit 2: Exponential and Logarithmic Functions)
2.15 Semi-log Plots (Unit 2: Exponential and Logarithmic Functions)
2.2 Change in Linear and Exponential Functions (Unit 2: Exponential and Logarithmic Functions)
2.3 Exponential Functions (Unit 2: Exponential and Logarithmic Functions)
2.4 Exponential Function Manipulation (Unit 2: Exponential and Logarithmic Functions)
2.5 Exponential Function Context and Data Modeling (Unit 2: Exponential and Logarithmic Functions)
2.6 Competing Function Model Validation (Unit 2: Exponential and Logarithmic Functions)
2.7 Composition of Functions (Unit 2: Exponential and Logarithmic Functions)
2.8 Inverse Functions (Unit 2: Exponential and Logarithmic Functions)
2.9 Logarithmic Expressions (Unit 2: Exponential and Logarithmic Functions)
3.1 Periodic Phenomena (Unit 3: Trigonometric and Polar Functions)
3.10 Trigonometric Equations and Inequalities (Unit 3: Trigonometric and Polar Functions)
3.11 The Secant, Cosecant, and Cotangent Functions (Unit 3: Trigonometric and Polar Functions)
3.12 Equivalent Representations of Trigonometric Functions (Unit 3: Trigonometric and Polar Functions)
3.13 Trigonometry and Polar Coordinates (Unit 3: Trigonometric and Polar Functions)
3.14 Polar Function Graphs (Unit 3: Trigonometric and Polar Functions)
3.15 Rates of Change in Polar Functions (Unit 3: Trigonometric and Polar Functions)
3.2 Sine, Cosine, and Tangent (Unit 3: Trigonometric and Polar Functions)
3.3 Sine and Cosine Function Values (Unit 3: Trigonometric and Polar Functions)
3.4 Sine and Cosine Function Graphs (Unit 3: Trigonometric and Polar Functions)
3.5 Sinusoidal Functions (Unit 3: Trigonometric and Polar Functions)
3.6 Sinusoidal Function Transformations (Unit 3: Trigonometric and Polar Functions)
3.7 Sinusoidal Function Context and Data Modeling (Unit 3: Trigonometric and Polar Functions)
3.8 The Tangent Function (Unit 3: Trigonometric and Polar Functions)
3.9 Inverse Trigonometric Functions (Unit 3: Trigonometric and Polar Functions)

## Targets: write exactly one FRQ for each of these 12 topics

### ap_precalculus 1.12 Transformations of Functions (Unit 1: Polynomial and Rational Functions)
Official CED text (governs):
```
TOPIC 1.12
SUGGESTED SKILLS FOCUS
1.C
Transformations
of Functions
Construct new functions, using
transformations, compositions,
inverses, or regressions, that
may be useful in modeling
contexts,criteria, ordata,with
andwithouttechnology.
3.A
Describe the characteristics of
a function with varying levels
of precision, depending on the
functionrepresentation and
availablemathematicaltools.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Construct a function that is an
additive and/or multiplicative
transformation of another
function.
The function g ( x ) = f ( x ) + k is an additive
transformation of the function f that results in a
vertical translation of the graph of f by k units.
1.12.A
1.12.A.1
1.12.A.2
The function g ( x ) = f ( x + h ) is an additive
transformation of the function f that results in
a horizontal translation of the graph of f by −h
units.
1.12.A.3
The function g ( x ) = a f ( x ), where a ≠ 0 , is a
multiplicative transformation of the function f
that results in a vertical dilation of the graph of
f by a factor of a . If a < 0, the transformation
involvesareflectionoverthex-axis.
1.12.A.4
The function g ( x ) = f ( bx ), where b ≠ 0, is a
multiplicative transformation of the function
f that results in a horizontal dilation of the
graph of f by a factor of
. If b < 0, the
b
transformationinvolvesareflectionoverthe
y-axis.
1.12.A.5
Additive and multiplicative transformations
can be combined, resulting in combinations of
horizontal and vertical translations and dilations.
The set of points prior to the transformations is
called the preimage of the transformations, and
the set of points after the transformations is
called the image of the transformations.
1.12.A.6
The domain and range of a function that is a
transformation of a parent function may be
differentfromthoseoftheparentfunction.
UNIT
SUGGESTED SKILLS FOCUS
2.A
Identify information from
graphical, numerical, analytical,
and verbal representations to
answer aquestionorconstruct
a model, with and without
technology.
3.C
Supportconclusions or
choices with a logical
rationale orappropriatedata.
Polynomial and Rational Functions
```

### ap_precalculus 1.1 Change in Tandem (Unit 1: Polynomial and Rational Functions)
Official CED text (governs):
```
TOPIC 1.1
SUGGESTED SKILLS FOCUS
2.B
Change in Tandem
Construct equivalent graphical,
numerical, analytical, and
verbal representations of
functions that are useful in a
given mathematical or applied
context, with and without
technology.
3.A
Describe the characteristics of
a function with varying levels
of precision, depending on the
functionrepresentation and
availablemathematicaltools.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Describe how the input and
output values of a function
vary together by comparing
functionvalues.
A function is a mathematical relation that
maps a set of input values to a set of output
values such that each input value is mapped
to exactly one output value. The set of input
values is called the domain of the function, and
the set of output values is called the range of
the function. The variable representing input
values is called the independent variable, and
the variable representing output values is called
the dependent variable. Two functions, f and
g , are equal if they have the same domain, and
for every input value a in that same domain,
both functions yield the same output value
1.1.A
1.1.A.1
( f ( a ) = g ( a )).
1.1.A.2
The input and output values of a function vary
in tandem according to the function rule, which
can be expressed graphically, numerically,
analytically, or verbally. The image of an input
value is the single output value yielded by the
function rule. The preimage of an output value
is the set of input values for which the function
rule yields that output value.
1.1.A.3
A function is increasing over an interval of its
domain if, as the input values increase, the
output values always increase. That is, for all a
and b in the interval, if a < b, then f ( a ) < f ( b ).
1.1.A.4
A function is decreasing over an interval of
its domain if, as the input values increase, the
output values always decrease. That is, for all a
and b in the interval, if a < b, then f ( a ) > f ( b ).
continued on next page
UNIT
Polynomial and Rational Functions
LEARNING OBJECTIVE
1.1.A
Describe how the input and
output values of a function
vary together by comparing
function values.
1.1.B
Construct a graph representing
two quantities that vary with
respect to each other in a
contextual scenario.
ESSENTIAL KNOWLEDGE
X  EXCLUSION STATEMENT—Discriminating
between open intervals and closed intervals
as it relates to intervals on which a function
is increasing or intervals on which a function
is decreasing is outside the scope of the AP
Precalculus course and exam.
1.1.B.1
The graph of a function displays a set of inputoutput pairs and shows how the values of the
function’sinputandoutputvaluesvary.
1.1.B.2
A verbal description of the way aspects of
phenomena change together can be the basis
for constructing a graph.
1.1.B.3
The graph of a function is concave up on
intervals in which the rate of change is
increasing.
1.1.B.4
The graph of a function is concave down
on intervals in which the rate of change is
decreasing.
1.1.B.5
The graph intersects the x-axis when the
output value is zero. The corresponding input
values are said to be zeros of the function.
UNIT
Polynomial and Rational Functions
```

### ap_precalculus 1.2 Rates of Change (Unit 1: Polynomial and Rational Functions)
Official CED text (governs):
```
TOPIC 1.2
SUGGESTED SKILLS FOCUS
Rates of Change
2.A
Identify information from
graphical, numerical, analytical,
and verbal representations to
answer a question or construct
a model, with and without
technology.
3.A
Describe the characteristics of
a function with varying levels
of precision, depending on the
function representation and
available mathematical tools.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Compare the rates of change
at two points using average
rates of change near the
points.
The average rate of change of a function over
an interval of the function’s domain is the
constant rate of change that yields the same
change in the output values as the function
yielded on that interval of the function’s domain.
It is the ratio of the change in the output values
to the change in input values over that interval.
1.2.A
1.2.A.1
1.2.A.2
The rate of change of a function at a point
quantifiestherateatwhichoutputvalueswould
change were the input values to change at
that point. The rate of change at a point can be
approximated by the average rates of change of
the function over small intervals containing the
point,ifsuchvaluesexist.
1.2.A.3
The rates of change at two points can be
compared using average rate of change
approximationsoversufficientlysmallintervals
containing each point, if such values exist.
1.2.B
Describe how two quantities
varytogetheratdifferent
pointsandoverdifferent
intervals of a function.
1.2.B.1
Rates of change quantify how two quantities
vary together.
1.2.B.2
A positive rate of change indicates that as one
quantity increases or decreases, the other
quantity does the same.
1.2.B.3
A negative rate of change indicates that as one
quantity increases, the other decreases.
UNIT
SUGGESTED SKILLS FOCUS
3.B
Applynumericalresults ina
given mathematical or applied
context.
3.C
Supportconclusions or
choices with a logical
rationale orappropriatedata.
Polynomial and Rational Functions
```

### ap_precalculus 1.3 Rates of Change and Behavior of Graphs (Unit 1: Polynomial and Rational Functions)
Official CED text (governs):
```
TOPIC 1.3
Rates of Change in
Linear and Quadratic
Functions
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Determine the average rates
of change for sequences and
functions, including linear,
quadratic, and other function
types.
For a linear function, the average rate of change
over any length input-value interval is constant.
1.3.A
1.3.A.1
1.3.A.2
For a quadratic function, the average rates
of change over consecutive equal-length
input-value intervals can be given by a linear
function.
1.3.A.3
The average rate of change of a function f
over the closed interval [
] is the slope of
the secant line from the point ( a, f ( a ) ) to
)b, f )b ( (.
1.3.B
Determine the change in the
average rates of change for
linear, quadratic, and other
function types.
1.3.B.1
For a linear function, since the average rates of
change over consecutive equal-length inputvalue intervals can be given by a constant
function, these average rates of change for a
linear function are changing at a rate of zero.
1.3.B.2
For a quadratic function, since the average rates
of change over consecutive equal-length inputvalue intervals can be given by a linear function,
these average rates of change for a quadratic
function are changing at a constant rate.
1.3.B.3
When the average rate of change over equallength input-value intervals is increasing for all
small-length intervals, the graph of the function
is concave up. When the average rate of
change over equal-length input-value intervals
is decreasing for all small-length intervals, the
graph of the function is concave down.
UNIT
Polynomial and Rational Functions
```

### ap_precalculus 1.4 Polynomial Functions and Rates of Change (Unit 1: Polynomial and Rational Functions)
Official CED text (governs):
```
TOPIC 1.4
SUGGESTED SKILLS FOCUS
Polynomial Functions
and Rates of Change
2.A
Identify information from
graphical, numerical, analytical,
and verbal representations to
answer aquestionorconstruct
a model, with and without
technology.
3.A
Describe the characteristics of
a function with varying levels
of precision, depending on the
functionrepresentation and
availablemathematicaltools.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify key characteristics of
polynomial functions related
toratesofchange.
A nonconstant polynomial function of
x is any function representation that
is equivalent to the analytical form
1.4.A
1.4.A.1
p ( x ) = an x n + an -1x n -1 + an - 2 x n - 2 +  +
a2 x 2 + a1x + a0 , where n is a positive integer,
ai is a real number for each i from 0 to n, and an
is nonzero. The polynomial has degree n,
n
the leading term is an x , and the leading
coefficientis
1.4.A.2
Where a polynomial function switches
between increasing and decreasing, or at
the included endpoint of a polynomial with a
restricted domain, the polynomial function will
have a local, or relative, maximum or minimum
output value. If any local maximum is greater
than all other function output values, then
that local maximum is a global, or absolute,
maximum. Similarly, if any local minimum is
less than all other function output values, then
that local minimum is a global, or absolute,
minimum.
1.4.A.3
Between every two distinct real zeros of a
nonconstant polynomial function, there must
be at least one input value corresponding to a
localmaximumorlocalminimum.
1.4.A.4
A polynomial function of even degree has
either a global maximum or a global minimum.
For a quadratic function, the global maximum
or global minimum occurs at the vertex.
continued on next page
UNIT
Polynomial and Rational Functions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify key characteristics of
polynomial functions related
to rates of change.
Points of inflection of a polynomial function
occur at input values where the rate of change
of the function changes from increasing to
decreasing or from decreasing to increasing.
This occurs where the graph of a polynomial
function changes from concave up to concave
down or from concave down to concave up.
1.4.A
1.4.A.5
UNIT
Polynomial and Rational Functions
```

### ap_precalculus 1.8 Rational Functions and Zeros (Unit 1: Polynomial and Rational Functions)
Official CED text (governs):
```
TOPIC 1.8
Rational Functions
and Zeros
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Determine the zeros of
rationalfunctions.
The real zeros of a rational function
correspond to the real zeros of the numerator
for such values in its domain.
1.8.A
1.8.A.1
1.8.A.2
The real zeros of both polynomial functions
of a rational function r are endpoints or
asymptotes for intervals satisfying the rational
function inequalities r ( x ) ≥ 0 or r ( x ) ≤ 0 .
UNIT
Polynomial and Rational Functions
```

### ap_precalculus 2.1 Change in Arithmetic and Geometric Sequences (Unit 2: Exponential and Logarithmic Functions)
Official CED text (governs):
```
TOPIC 2.1
SUGGESTED SKILLS FOCUS
Change in Arithmetic
and Geometric
Sequences
1.B
Express functions, equations,
or expressions in analytically
equivalent forms that are useful
in a given mathematical or
applied context.
3.A
Describe the characteristics of
a function with varying levels
of precision, depending on the
function representation and
available mathematical tools.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Express arithmetic sequences
found in mathematical
and contextual scenarios
as functions of the whole
numbers.
A sequence is a function from the whole
numbers to the real numbers. Consequently,
the graph of a sequence consists of discrete
points instead of a curve.
2.1.A
2.1.A.1
2.1.A.2
Successive terms in an arithmetic sequence
haveacommondifference,orconstantrateof
change.
2.1.A.3
The general term of an arithmetic sequence
withacommondifferenced is denoted by an
and is given by an = a0 + dn, where a0 is the
initial value, or by an = ak + d ( n - k ) , where
ak is the kth termofthesequence.
2.1.B
Express geometric sequences
found in mathematical
and contextual scenarios
as functions of the whole
numbers.
2.1.B.1
Successive terms in an increasing or decreasing
geometric sequence have a common ratio, or
constantproportionalchange.
2.1.B.2
The general term of an increasing or
decreasing geometric sequence with a
common ratio r is denoted by g n and is given
n
by g n = g 0 r , where g 0 is the initial value, or by
g n = g k r (n - k ) , where g k is the kth term of the
sequence.
2.1.B.3
An increasing arithmetic sequence increases
equally with each step, whereas an increasing
geometric sequence of positive values
increases by a larger amount with each
successive step.
UNIT
SUGGESTED SKILLS FOCUS
1.C
Construct new functions, using
transformations, compositions,
inverses, or regressions, that
may be useful in modeling
contexts,criteria, ordata,with
andwithouttechnology.
Exponential and Logarithmic Functions
```

### ap_precalculus 2.3 Exponential Functions (Unit 2: Exponential and Logarithmic Functions)
Official CED text (governs):
```
TOPIC 2.3
Exponential Functions
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify key characteristics of
exponential functions.
The general form of an exponential function is
f ( x ) = ab x , with the initial value a, where a ≠ 0,
and the base b , where b > 0, and b ≠ 1. When
a > 0 and b > 1, the exponential function is
said to demonstrate exponential growth. When
a > 0 and 0 < b < 1, the exponential function is
said to demonstrate exponential decay.
2.3.A
2.3.A.1
2.3.A.2
When the natural numbers are input values
in an exponential function, the input value
specifiesthenumberoffactorsofthebaseto
be applied to the function’s initial value. The
domain of an exponential function is all real
numbers.
2.3.A.3
Because the output values of exponential
functions in general form are proportional
over equal-length input-value intervals,
exponential functions are always increasing
or always decreasing, and their graphs are
always concave up or always concave down.
Consequently, exponential functions do not
have extrema except on a closed interval, and
theirgraphsdonothavepointsofinflection.
2.3.A.4
If the output values of the function f are not
proportional over equal-length input-value
intervals, but the output values of an additive
transformation of f are proportional over
equal-length input-value intervals, then f can
be modeled by an additive transformation of
an exponential function.
continued on next page
UNIT
Exponential and Logarithmic Functions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify key characteristics of
exponential functions.
For an exponential function in general form, as
the input values increase or decrease without
bound, the output values will increase or
decrease without bound or will get arbitrarily
close to zero. That is, for an exponential
x
function in general form, lim ab = ∞ ,
2.3.A
2.3.A.5
x →±∞
lim ab x = -∞ , or lim ab x = 0.
x →±∞
x →±∞
UNIT
SUGGESTED SKILLS FOCUS
1.B
Express functions, equations,
or expressions in analytically
equivalent formsthat areuseful
inagivenmathematical or
appliedcontext.
3.A
Exponential and Logarithmic Functions
```

### ap_precalculus 2.4 Exponential Function Manipulation (Unit 2: Exponential and Logarithmic Functions)
Official CED text (governs):
```
TOPIC 2.4
Exponential Function
Manipulation
Describe the characteristics of
a function with varying levels
of precision, depending on the
functionrepresentation and
availablemathematicaltools.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Rewrite exponential
expressions in equivalent
forms.
The product property for exponents states
m n
(m + n)
.Graphically,thisproperty
that b b = b
implies that every horizontal translation
(x +k)
,
of an exponential function, f ( x ) = b
is equivalent to a vertical dilation,
f ( x ) = b( x + k ) = b x bk = ab x, where a = bk .
2.4.A
2.4.A.1
2.4.A.2
The power property for exponents states
m n
that b
= b( mn ).Graphically,thisproperty
( )
implies that every horizontal dilation of
( cx )
an exponential function, f ( x ) = b , is
equivalent to a change of the base of an
( c ) , where bc
exponential function, f ( x ) = b
is a constant and c ≠ 0 .
x
2.4.A.3
The negative exponent property states that
b -n =
.
bn
2.4.A.4
The value of an exponential expression
involving an exponential unit fraction, such as
b(1/k ) where k is a natural number, is the kth
root of b , when it exists.
UNIT
Exponential and Logarithmic Functions
```

### ap_precalculus 2.6 Competing Function Model Validation (Unit 2: Exponential and Logarithmic Functions)
Official CED text (governs):
```
TOPIC 2.6
SUGGESTED SKILLS FOCUS
Competing Function
Model Validation
2.A
Identify information from
graphical, numerical, analytical,
and verbal representations to
answer aquestionorconstruct
a model, with and without
technology.
3.C
Supportconclusions or
choices with a logical
rationale orappropriatedata.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Construct linear, quadratic,
and exponential models based
onadataset.
Two variables in a data set that demonstrate
a slightly changing rate of change can be
modeled by linear, quadratic, and exponential
functionmodels.
2.6.A
2.6.A.1
2.6.A.2
Models can be compared based on contextual
clues and applicability to determine which
model is most appropriate.
2.6.B
Validate a model constructed
fromadataset.
2.6.B.1
For a given value of an independent variable,
a residual of a regression is the actual value of
the dependent variable value minus the value
predicted by the function regression model.
A residual plot is a graphical representation of
the residuals of a regression, with the residuals
on the vertical axis and the independent
variable on the horizontal axis. A model is
justifiedasappropriate for a data set if the
residualplotappearswithoutpattern.
2.6.B.2
For given values of an independent variable,
the errors in a model can relate to the signed
differencesinthevaluesofthedependent
variable predicted by the function regression
modelandtheactualvaluesORtheunsigned
absolute values of the residuals. Errors may
reveal that the model underestimates or
overestimates actual values on a given inputvalue interval. The data set and context can
provide clues as to whether underestimates or
overestimates are preferred on a given inputvalue interval.
UNIT
SUGGESTED SKILLS FOCUS
1.C
Construct new functions, using
transformations, compositions,
inverses, or regressions, that
may be useful in modeling
contexts,criteria, ordata,with
andwithouttechnology.
Exponential and Logarithmic Functions
```

### ap_precalculus 2.7 Composition of Functions (Unit 2: Exponential and Logarithmic Functions)
Official CED text (governs):
```
TOPIC 2.7
Composition of
Functions
2.B
Construct equivalent graphical,
numerical, analytical, and
verbal representations of
functions that are useful in a
given mathematical or applied
context, with and without
technology.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Evaluate the composition of
two or more functions for
givenvalues.
If f and g are functions, the composite
function f  g maps a set of input values to
a set of output values such that the output
values of g are used as input values of f . For
this reason, the domain of the composite
function is restricted to those input values of
g for which the corresponding output value
is in the domain of f . ( f  g )( x ) can also be
represented as f ( g ( x )).
2.7.A
2.7.A.1
2.7.A.2
Values for the composite function f  g can
be calculated or estimated from the graphical,
numerical, analytical, or verbal representations
of f and g by using output values from g as
input values for f .
2.7.A.3
The composition of functions is not
commutative; that is, f  g and g  f are
typicallydifferentfunctions;therefore,
f ( g ( x )) and g ( f ( x ))aretypicallydifferent
values.
2.7.A.4
If the function f ( x ) = x is composed with
any function g , the resulting composite
function is the same as g ; that is,
g ( f ( x )) = f ( g ( x )) = g ( x ). The function
f ( x ) = x is called the identity function. When
composing two functions, the identity function
acts in the same way as 0 , the additive
identity, when adding two numbers and 1, the
multiplicative identity, when multiplying two
numbers.
continued on next page
Exponential and Logarithmic Functions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Construct a representation
of the composition of two or
morefunctions.
Function composition is useful for relating two
quantities that are not directly related by an
existingformula.
2.7.B
UNIT
2.7.B.1
2.7.B.2
When analytic representations of the functions
f and g are available, an analytic representation
of f ( g ( x ) ) can be constructed by substituting
g ( x ) for every instance of x in f .
2.7.B.3
A numerical or graphical representation of f  g
can often be constructed by calculating or
estimating values for ( x , f ( g ( x ) ) ).
2.7.C
Rewrite a given function as a
composition of two or more
functions.
2.7.C.1
Functions given analytically can often be
decomposed into less complicated functions.
When properly decomposed, the variable in one
function should replace each instance of the
function with which it was composed.
2.7.C.2
An additive transformation of a function, f , that
results in vertical and horizontal translations
can be understood as the composition of
g ( x ) = x + k with f .
2.7.C.3
A multiplicative transformation of a function, f ,
that results in vertical and horizontal dilations
can be understood as the composition of
g ( x ) = kx with f .
UNIT
SUGGESTED SKILLS FOCUS
1.A
Solve equations and
inequalities represented
analytically, with and without
technology.
Exponential and Logarithmic Functions
```

### ap_precalculus 2.9 Logarithmic Expressions (Unit 2: Exponential and Logarithmic Functions)
Official CED text (governs):
```
TOPIC 2.9
Logarithmic
Expressions
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Evaluate logarithmic
expressions.
The logarithmic expression log b c is equal to,
or represents, the value that the base b must
be exponentially raised to in order to obtain
the value c . That is, log b c = a if and only if
ba = c , where a and c are constants, b > 0,
and b ≠ 1. (when the base of a logarithmic
expressionisnotspecified,itisunderstoodas
the common logarithm with a base of 10)
2.9.A
2.9.A.1
2.9.A.2
The values of some logarithmic expressions
are readily accessible through basic arithmetic
while other values can be estimated through
the use of technology.
2.9.A.3
Onalogarithmicscale,eachunitrepresents
a multiplicative change of the base of the
logarithm. For example, on a standard scale,
the units might be 0, 1, 2, ..., while on a
logarithmic scale, using logarithm base 10, the
units might be 10 , 10 , 10 , ....
UNIT
Exponential and Logarithmic Functions
```


## AP Precalculus CED fact pack (course-wide sections and units up to 3)
# AP Precalculus — CED Fact Pack

Status: Primary-source verified. Use this version for 2026-27 authoring and
review.

## Source control

Source document: College Board, AP Precalculus Course and Exam Description.

Edition shown on cover: Effective Fall 2026.

Local source:
`docs/teaching/ap-precalculus-course-and-exam-description.pdf`

Source SHA-256:
`5ef13ad6e4b39455330257e94d1b4750a833ef6e05ccf2f4a24141912345f04f`

Drive fact-pack source:
`AP Precalculus 2026-27 — CED Fact Pack`,
file ID `18inDRWcdoP7Qq2yw2--3HQ0hZDASahhyvDhwXVyFpz0`.

Verification: the exam overview, assessed-unit weighting table, topic map,
calculator policy, and all four FRQ task models were checked against the
primary-source CED. The FRQ point and part structure was separately verified
in `docs/research/AP_CALCULUS_PRECALC_FRQ_STRUCTURE_VALIDATION_2026_07_26.md`.

**2026-08-08 deep-tier update, Units 1-3 (the full assessed scope).** Brought
to deep tier using the local CED PDF above (pages 23-102, all three assessed
units, read directly page-by-page) plus David-supplied primary sources: the
2025 Scoring Guidelines, the 2025 Chief Reader Report, the 2025/2026 released
FRQ booklets, and the 2025 Q1/Q2 Sample Student Responses and Scoring
Commentary booklets (same source type used for the Calculus AB deepening —
real graded student responses with reader explanations of exactly why each
point was or wasn't earned).

**Important structural finding, different from Biology/Chemistry/Calculus:**
AP Precalculus's CED contains almost no explicit "not assessed" exclusion
language. Across all 44 topics in Units 1-3, there is exactly **one** boxed
exclusion statement in the entire assessed scope (Unit 1, topic 1.1 — open
vs. closed intervals). Units 2 and 3 have **zero** boxed exclusions each —
confirmed by direct, exhaustive search of every topic's Essential Knowledge
text. This is a genuine property of the source document, not a research gap:
scope discipline in this course comes from what the required content states
positively, not from stated negatives. Do not infer that the absence of
exclusion language means anything not listed is fair game — check the
Essential Knowledge statements' actual boundaries (e.g., which identities are
given vs. only referenced as derivable, which domains are restricted) instead.

## Course and exam scope

AP Precalculus emphasizes function behavior, representation, rates of change,
equivalent forms, and modeling. It does not assess calculus: authoring must not
introduce derivatives, integrals, or limit-based reasoning.

The AP Exam assesses Units 1–3 only. Unit 4, Functions Involving Parameters,
Vectors, and Matrices, is part of the course but is not assessed on the AP
Exam. Unit 4 content must not appear in scored AP-exam-style practice.

## Exam structure

The exam contains 42 multiple-choice questions and four free-response
questions.

Each FRQ is worth 6 points and has exactly three lettered parts. Each part is
worth 2 points.

The four required FRQ task models are:

1. Function Concepts — graphing calculator required.
2. Modeling a Non-Periodic Context — graphing calculator required.
3. Modeling a Periodic Context — no calculator.
4. Symbolic Manipulations — no calculator.

A representative four-question FRQ set contains one question of each type.
Larger banks should preserve balanced coverage of the four types and their
calculator rules.

## Multiple-choice unit weighting

| Unit | Title | Weighting |
|---|---|---:|
| 1 | Polynomial and Rational Functions | 30–40% |
| 2 | Exponential and Logarithmic Functions | 25–40% |
| 3 | Trigonometric and Polar Functions | 30–35% |
| 4 | Functions Involving Parameters, Vectors, and Matrices | Not assessed |

Use these ranges as portfolio guidance, not rigid quotas. Do not use the ranges
to omit assessed topics from the broader content bank.

## Topic map

### Unit 1 — Polynomial and Rational Functions

1.1 Change in Tandem; 1.2 Rates of Change; 1.3 Rates of Change and Behavior of
Graphs; 1.4 Polynomial Functions and Rates of Change; 1.5 Polynomial Functions
and Complex Zeros; 1.6 Polynomial Functions and End Behavior; 1.7 Rational
Functions and End Behavior; 1.8 Rational Functions and Zeros; 1.9 Rational
Functions and Vertical Asymptotes; 1.10 Rational Functions and Holes; 1.11
Equivalent Representations; 1.12 Transformations of Functions; 1.13 Function
Model Selection and Assumption Articulation; 1.14 Function Model Construction
and Application.

### Unit 2 — Exponential and Logarithmic Functions

2.1 Change in Arithmetic and Geometric Sequences; 2.2 Change in Linear and
Exponential Functions; 2.3 Exponential Functions; 2.4 Exponential Function
Manipulation; 2.5 Exponential Function Context and Data Modeling; 2.6
Competing Function Model Validation; 2.7 Composition of Functions; 2.8 Inverse
Functions; 2.9 Logarithmic Expressions; 2.10 Inverses of Exponential
Functions; 2.11 Logarithmic Functions; 2.12 Logarithmic Function Manipulation;
2.13 Exponential and Logarithmic Equations and Inequalities; 2.14 Logarithmic
Function Context and Data Modeling; 2.15 Semi-log Plots.

### Unit 3 — Trigonometric and Polar Functions

3.1 Periodic Phenomena; 3.2 Sine, Cosine, and Tangent; 3.3 Sine and Cosine
Function Values; 3.4 Sine and Cosine Function Graphs; 3.5 Sinusoidal
Functions; 3.6 Sinusoidal Function Transformations; 3.7 Sinusoidal Function
Context and Data Modeling; 3.8 The Tangent Function; 3.9 Inverse Trigonometric
Functions; 3.10 Trigonometric Equations and Inequalities; 3.11 The Secant,
Cosecant, and Cotangent Functions; 3.12 Equivalent Representations of
Trigonometric Functions; 3.13 Trigonometry and Polar Coordinates; 3.14 Polar
Function Graphs; 3.15 Rates of Change in Polar Functions.

## Units 1-3 deep-tier detail (2026-08-08 addition)

Verified directly against the CED PDF (pages 23-102) plus the 2025 Scoring Guidelines, Chief Reader Report, and Sample Student Responses booklets. As noted above, exclusion density here is the sparsest of any subject fact pack in this repo — real scope discipline comes from the exact formulas/domains given and from documented low-scoring-point patterns, not from boxed exclusions.

### Front-matter rules that apply to every FRQ, regardless of unit (quote verbatim from the Scoring Guidelines and exam directions)

- **Calculator sections:** "Avoid rounding intermediate computations on the way to the final result. Unless otherwise specified, any decimal approximations reported in your work should be accurate to three places after the decimal point." Also: "Answers without supporting work may not receive credit in cases where supporting work is requested." And: "Unless otherwise specified, the domain of a function f is assumed to be the set of all real numbers x for which f(x) is a real number."
- **No-calculator sections:** "Solutions to equations must be real numbers. Determine the exact value of any expression that can be obtained without a calculator" (example given: log₂8, cos(π/2), sin⁻¹(1)). Also: "Unless otherwise specified, combine terms using algebraic methods and rules for exponents and logarithms, where applicable" (example given: 2x+3x, 5²·5³, x⁵/x², ln3+ln5 should be rewritten in equivalent forms — an unsimplified but otherwise correct answer can lose credit here, unlike Calculus's explicit "answers need not be simplified" rule — **this is a real cross-subject difference, do not port the Calculus simplification leniency into Precalculus rubrics**).
- **The decimal "forgive-once" rule, confirmed verbatim from the Scoring Guidelines' General Scoring Notes:** "A decimal presentation error occurs when a response is complete and correct, but the answer is reported to fewer digits than required. The first decimal presentation error in [the question] does not earn the point. For each additional part... that requires a decimal approximation and contains a decimal presentation error, the response is eligible to earn the point." In plain terms: **the first rounding/presentation slip in a question is forgiven; the second and later ones are not.** A rubric that docks every instance of under-rounding, or that never docks any, both diverge from real AP scoring — author against the forgive-once pattern specifically.
- **A 2026-dated tightening worth flagging:** 2025's exam directions read "You may use the available paper for scratch work, but you must write your answers in the free-response booklet." 2026 tightened this to "You may use the available paper for scratch work and planning, but only work written in the free-response booklet will be scored. Any work done on scratch paper will not be scored." Use the 2026 wording for anything framed as "current" exam policy.

### Unit 1 — Polynomial and Rational Functions (30-40%)

*Exclusion, boxed and verbatim (topic 1.1, the only one in the unit):* "Discriminating between open intervals and closed intervals as it relates to intervals on which a function is increasing or intervals on which a function is decreasing is outside the scope of the AP Precalculus course and exam." Do not require students to distinguish [a,b] from (a,b) when stating an interval of increase/decrease.

*Key formulas confirmed:* average rate of change over [a,b] = slope of the secant line = [f(b)−f(a)]/(b−a) (topic 1.3); general polynomial form aₙxⁿ+...+a₀ (1.4); "a polynomial function of degree n has exactly n complex zeros counting multiplicities," and the Complex Conjugate Root Theorem is stated (without being named) — if a+bi is a zero, so is a−bi (1.5); polynomial division identity f(x)=g(x)q(x)+r(x) with deg(r)<deg(g) (1.11); the four transformation forms f(x)+k, f(x+h), af(x), f(bx) (1.12).

*Real, low-scoring-point pattern confirmed from the 2025 exam (Q1 Part C, exponential-vs-other classification):* the reasoning point for "why is this data exponential" scored a mean of only 0.30/1 (vs. 0.73/1 for the identification point) — the *second-lowest reasoning point on the entire 2025 exam*. The Chief Reader Report states explicitly: **"reasoning ... referencing 'exponential regression,' 'r values,' or 'r² values' is NOT sufficient to earn [the reasoning] point"** — students who cite a calculator's regression-fit statistic instead of computing the actual ratio of consecutive outputs lose the point even with the right classification. This is directly reusable as an MCQ distractor pattern for any "which function type fits this data, and why" item: a distractor rationale built on "high r² value" should be marked wrong per real scoring, not accepted as valid reasoning.

*Real documented error, reciprocal/ratio confusion:* a 2025 sample response classified data as decreasing exponentially "at a factor of 2" when the true ratio was 0.5 — a reciprocal-confusion error (mistaking "halves each step" for "factor of 2") worth using as a distractor.

### Unit 2 — Exponential and Logarithmic Functions (25-40%)

*Zero boxed exclusions.* Two real scope nuances worth encoding even though the CED doesn't flag them as exclusions: (1) topic 2.10's Learning Objective restricts logarithm-as-inverse-of-exponential work to "an initial value of 1" even though the general logarithmic form given elsewhere (2.10.A.1) allows any nonzero a — don't author an inverse-derivation item assuming the general a≠1 case is in scope for that specific topic; (2) topic 2.12 gives the product, power, and change-of-base properties of logarithms plus the natural-log definition, but **does not give an explicit quotient property as a numbered Essential Knowledge statement** — a quotient-of-logs item is still fair game (it's directly derivable from the product property) but shouldn't be cited as "per EK 2.12.A.x" the way the other three properties can be.

*Key formulas confirmed:* general exponential f(x)=ab^x (a≠0, b>0, b≠1); general logarithmic f(x)=a·log_b(x); product property log_b(xy)=log_b(x)+log_b(y); power property log_b(x^n)=n·log_b(x); change-of-base log_b(x)=log_a(x)/log_a(b); natural log ln(x)=log_e(x); semi-log linearization (topic 2.15) — for y=ab^x, the semi-log-plotted linear form is y=(log_n b)x+log_n a, slope log_n b, intercept log_n a, with the constraint n>1 (not just n≠1) stated in the EK itself.

*Real, lowest-scoring points on the entire 2025 exam, both in Q4 (Symbolic Manipulations):* solving e^(2x)−e^x−12=0 as a hidden quadratic in eˣ scored a mean of 0.14/1 (setup) and 0.10/1 (final answer) — the two lowest point-means on the whole exam. Documented misconception, verbatim: **"No recognition of equation as quadratic in eˣ and not eliminating the possibility that eˣ=−3."** Students who don't substitute u=eˣ, factor, and explicitly reject the negative root (since eˣ>0 always) fail this near-universally. Any hidden-quadratic-in-exponential FRQ criterion should require the explicit rejection step, and any MCQ distractor for this pattern should include a wrong answer derived from not rejecting eˣ=−3 (e.g., an answer that includes ln(−3) or "no solution" when a valid solution does exist).

*Real, second-lowest scoring point, trig-identity simplification inside a Unit 2/3 boundary item:* simplifying 6/[tan(x)(csc²x−1)] to 6tan(x) using the Pythagorean identity csc²x−1=cot²x scored a mean of 0.28/1. CR report: "Lack of facility with trigonometric identities and algebraic manipulation." Note also confirmed: **domain restrictions on the simplification (tan x≠0, cot x≠0) are explicitly "not required... and not scored regardless if correct or incorrect"** — do not write a criterion that requires or penalizes domain-restriction notation on a pure symbolic-simplification task unless the prompt explicitly asks for domain.

### Unit 3 — Trigonometric and Polar Functions (30-35%)

*Zero boxed exclusions.* The polar-function boundary in this pack's existing "Authoring and review boundaries" section (below) is **confirmed accurate but is a synthesized inference, not a quoted CED exclusion** — verified directly: no derivative, instantaneous-rate, or integral/area language appears anywhere in Unit 3. Topic 3.15 ("Rates of Change in Polar Functions") is scoped entirely to *average* rate of change (a difference quotient of signed radius over Δθ) and to extrema/behavior defined by increasing/decreasing sign patterns relative to distance from the origin — never a derivative test. This is an absence-of-coverage boundary, correctly reflected in the existing guidance, not something the CED states as a negative rule.

*Polar coordinate conversion — confirmed required in both directions, with exact formulas (topic 3.13):* rectangular→polar: r=√(x²+y²), θ=arctan(y/x) for x>0, θ=arctan(y/x)+π for x<0 (no case is given in the CED for x=0). Polar→rectangular: x=r·cos(θ), y=r·sin(θ). This confirms the existing fact pack's "assess coordinate conversion" boundary is accurate for both directions.

*Key formulas confirmed:* general sinusoidal form y=a·sin(b(θ+c))+d (and the cosine analog), with amplitude=|a|, period=|1/b|·2π, phase shift=−c, midline=d (topic 3.6); tangent's general transformed form has period |1/b|·π instead (topic 3.8); Pythagorean identity sin²θ+cos²θ=1 and its derived form tan²θ=sec²θ−1 (topic 3.12); sum identities sin(α+β)=sinα·cosβ+cosα·sinβ and cos(α+β)=cosα·cosβ−sinα·sinβ — **difference and double-angle identities are referenced as derivable from these sum identities but are not separately given as their own formulas in the CED** (topic 3.12); inverse trig functions restricted to sine [−π/2,π/2], cosine [0,π], tangent (−π/2,π/2) — arcsecant/arccosecant/arccotangent are never mentioned anywhere in Unit 3 (topic 3.9).

*Real, hardest single point on the entire 2025 exam (Q2 Part B(iii), technically a Unit 1 item but the same concavity-reasoning skill recurs in Unit 3's periodic-context task model):* explaining why a secant-line estimate is less than the actual curve value, requiring both "concave down" (or equivalent) and an explicit tie back to the specific secant line, scored a mean of just 0.06/1 — the lowest of the whole exam. CR report: "Very few responses communicated an understanding." The parallel point in Q3 (periodic context) — converting a given frequency in Hz into the sinusoidal parameter b (e.g. 200 cycles/sec → b=2π·200) — scored a mean of only 0.18/1, the hardest point in that question. Both are strong candidates for explicit, heavily-scaffolded FRQ criteria and for MCQ distractors built on the exact documented failure mode (frequency treated as if it were the period, or vice versa).

*Real, register-boundary error worth encoding directly:* a periodic-context concavity/rate-of-change description that uses language like "the rate of change of h is increasing at an increasing rate" does **not** earn credit — the Scoring Guidelines state explicitly: "Analysis to make such a conclusion requires calculus." A Precalculus response must describe concavity/behavior in increasing/decreasing and concave-up/concave-down terms, not rate-of-a-rate language — that register belongs to Calculus, not Precalculus, even though the underlying graph feature is the same. Do not author a Precalc rubric that rewards second-derivative-flavored phrasing.

## Authoring and review boundaries

- Use average rate of change, finite differences, ratios, graphs, tables, and
  contextual interpretation rather than calculus notation.
- Preserve the calculator rule of the target section or FRQ task model.
- Require model assumptions and extrapolation limitations where the context
  demands them.
- Distinguish exact symbolic work from calculator-supported numerical work.
- For polar functions, assess coordinate conversion, graph features, and
  average rates of change without importing Calculus BC polar-area or
  derivative methods.
- Every FRQ must have three parts, two points per part, and six points total.
- All questions and scoring criteria must be independently authored. Do not use
  official question wording, released scoring text, secure material, or a
  recognizable official item structure as a generation seed.

## Change record

**2026-08-08:** Brought Units 1-3 (the full assessed scope) to deep tier — see
Source control and the "Units 1-3 deep-tier detail" section. Confirmed this
CED has almost no explicit exclusion language (1 boxed exclusion total across
44 topics, vs. Biology/Chemistry's per-topic exclusion density) — added
per-unit detail instead from real 2025 scoring data: the front-matter
decimal-forgive-once rule, three documented lowest-scoring-point patterns
(exponential-classification reasoning citing "r² value" instead of computing
the ratio, mean 0.30/1; hidden-quadratic-in-eˣ equation solving, mean
0.10-0.14/1; frequency-to-sinusoidal-parameter-b conversion, mean 0.18/1;
secant-line-vs-concavity explanation, mean 0.06/1 — the single lowest point
on the whole 2025 exam), and confirmation that the existing polar-function
boundary guidance (below) is accurate though synthesized rather than
CED-quoted, since the CED itself states no polar exclusions explicitly.

