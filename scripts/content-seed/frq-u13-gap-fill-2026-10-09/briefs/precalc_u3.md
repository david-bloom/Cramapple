# FRQ writing brief: precalc_u3

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

## Targets: write exactly one FRQ for each of these 11 topics

### ap_precalculus 3.11 The Secant, Cosecant, and Cotangent Functions (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.11
SUGGESTED SKILLS FOCUS
The Secant, Cosecant,
and Cotangent
Functions
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify key characteristics
of functions that involve
quotients of the sine and
cosinefunctions.
The secant function, f (θ ) = sec θ , is the
reciprocal of the cosine function, where
cos θ ≠ 0.
3.11.A
2.B
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
3.11.A.1
3.11.A.2
The cosecant function, f (θ ) = csc θ , is the
reciprocal of the sine function, where sin θ ≠ 0 .
3.11.A.3
The graphs of the secant and cosecant
functions have vertical asymptotes where
cosine and sine are zero, respectively, and have
arangeof (-∞, - 1] ∪ [1, ∞).
3.11.A.4
The cotangent function, f (θ ) = cot θ , is
the reciprocal of the tangent function, where
cos θ
tan θ ≠ 0. Equivalently, cot θ =
, where
sin θ
sin θ ≠ 0 .
3.11.A.5
The graph of the cotangent function has
vertical asymptotes for domain values
where tan θ = 0 and is decreasing between
consecutive asymptotes.
UNIT
SUGGESTED SKILLS FOCUS
1.A
Solve equations and
inequalities represented
analytically, with and without
technology.
1.B
Express functions, equations,
or expressions in analytically
equivalent formsthat areuseful
inagivenmathematical or
appliedcontext.
3.B
Applynumericalresults ina
given mathematical or applied
context.
Trigonometric and Polar Functions
```

### ap_precalculus 3.12 Equivalent Representations of Trigonometric Functions (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.12
Equivalent
Representations
of Trigonometric
Functions
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Rewrite trigonometric
expressions in equivalent
forms with the Pythagorean
identity.
The Pythagorean Theorem can be applied to
right triangles with points on the unit circle
at coordinates ( cos θ , sin θ ), resulting in the
3.12.A
3.12.A.1
Pythagorean identity: sin θ + cos θ = 1.
3.12.A.2
The Pythagorean identity can be
algebraically manipulated into other forms
involving trigonometric functions, such
as tan θ = sec θ - 1, and can be used to
establish other trigonometric relationships,
such as arcsin x = arccos
( 1 - x ), with
appropriate domain restrictions.
3.12.B
Rewrite trigonometric
expressions in equivalent
forms with sine and cosine
sumidentities.
3.12.B.1
The sum identity for sine is
sin (α + β ) = sin α cos β + cos α sin β .
3.12.B.2
The sum identity for cosine is
cos (α + β ) = cos α cos β - sin α sin β .
3.12.B.3
The sum identities for sine and cosine can
alsobeusedasdifferenceanddouble-angle
identities.
3.12.B.4
Properties of trigonometric functions, known
trigonometric identities, and other algebraic
properties can be used to verify additional
trigonometric identities.
continued on next page
Trigonometric and Polar Functions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Solve equations using
equivalent analytic
representations of
trigonometricfunctions.
Aspecificequivalentforminvolving
trigonometric expressions can make
information more accessible.
3.12.C
UNIT
3.12.C.1
3.12.C.2
Equivalent trigonometric forms may be
useful in solving trigonometric equations and
inequalities.
UNIT
SUGGESTED SKILLS FOCUS
1.B
Express functions, equations,
or expressions in analytically
equivalent formsthat areuseful
inagivenmathematical or
appliedcontext.
2.A
Trigonometric and Polar Functions
```

### ap_precalculus 3.13 Trigonometry and Polar Coordinates (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.13
Trigonometry and
Polar Coordinates
Identify information from
graphical, numerical, analytical,
and verbal representations to
answer aquestionorconstruct
a model, with and without
technology.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Determine the location of
a point in the plane using
both rectangular and polar
coordinates.
The polar coordinate system is based on a
grid of circles centered at the origin and on
lines through the origin. The positive x-axis is
called the polar axis. Polar coordinates of a
pointaredefinedasanorderedpair,( r, θ ).
The value of θ is given by the measure of an
angle in standard position whose terminal ray
lies in a line that passes through the point,
and r is the radial displacement of the point
from the origin. Positive values of r indicate
radial displacement from the origin along the
terminal ray of the angle θ . Negative values of
r indicate radial displacement from the origin
along the line containing the terminal ray of
the angle θ —but in the opposite direction of
the terminal ray of the angle θ . In the polar
coordinate system, the same point can be
represented many ways with combinations of
positive and negative values of r and θ .
3.13.A
3.13.A.1
3.13.A.2
The coordinates of a point in the polar
coordinate system, ( r, θ ), can be converted
to coordinates in the rectangular coordinate
system, ( x , y ), using x = r cos θ and
y = r sin θ .
continued on next page
UNIT
Trigonometric and Polar Functions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Determine the location of
a point in the plane using
both rectangular and polar
coordinates.
The coordinates of a point in the rectangular
coordinate system, ( x , y ), can be converted
to coordinates in the polar coordinate system,
3.13.A
3.13.A.3
( r, θ ), using r = x 2 + y 2 and θ = arctan |{ y }|
{y}
| + π for x < 0.
{x}
for x > 0 or θ = arctan |
3.13.A.4
{x}
A complex number can be understood as
a point in the complex plane and can be
determined by its corresponding rectangular or
polar coordinates. When the complex number
has the rectangular coordinates ( a, b ), it can
be expressed as a + bi. When the complex
number has polar coordinates ( r, θ ), it can be
expressed as ( r cos θ ) + i ( r sin θ ).
UNIT
SUGGESTED SKILLS FOCUS
2.B
Construct equivalent graphical,
numerical, analytical, and
verbal representations of
functions that are useful in a
given mathematical or applied
context, with and without
technology.
Trigonometric and Polar Functions
```

### ap_precalculus 3.15 Rates of Change in Polar Functions (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.15
SUGGESTED SKILLS FOCUS
Rates of Change in
Polar Functions
3.A
Describe the characteristics of
a function with varying levels
of precision, depending on the
functionrepresentation and
availablemathematicaltools.
3.C
Supportconclusions or
choices with a logical
rationale orappropriatedata.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Describe characteristics of
thegraphofapolarfunction.
If a polar function, r θ f (θ ), is positive and
increasing or negative and decreasing, then
the distance between the point with polar
coordinates ( f (θ ) , θ ) and the origin is
increasing.
3.15.A
3.15.A.1
3.15.A.2
If a polar function, r = f (θ ), is positive and
decreasing or negative and increasing, then
the distance between the point with polar
coordinates ( f (θ ) , θ ) and the origin is
decreasing.
3.15.A.3
For a polar function, r = f (θ ), if the function
changes from increasing to decreasing or
decreasing to increasing on an interval, then the
function has a relative extremum on the interval
corresponding to a point relatively closest to or
farthest from the origin.
3.15.A.4
The average rate of change of r with respect to
θ over an interval of θ is the ratio of the change
in the signed radius values to the change in θ
over an interval of θ .Graphically,theaverage
rate of change indicates the rate at which the
signed radius is changing per radian.
3.15.A.5
The average rate of change of r with respect to
θ over an interval of θ can be used to estimate
values of the function within the interval.
THIS PAGE HAS BEEN INTENTIONALLY LEFT BLANK
AP PRECALCULUS
UNIT 4
Functions
Involving
Parameters,
Vectors, and
Matrices
Additional Topics Available to Schools
(not included on AP Precalculus Exam)
0%
APEXAMWEIGHTING
CLASSPERIODS
Remember to go to AP Classroom
to assign students the online
optional Progress Checks for
this unit.
Whether assigned as homework or
completedinclass,the Progress
Checks provide each student with
immediate feedback related to this
unit’stopicsand skills.
Progress Check Unit 4
Part 1: Topics 4.1–4.7
Multiple-choice: 24 questions
Free-response: 2 questions
Progress Check Unit 4
Part 2: Topics 4.8–4.14
Multiple-choice: 21 questions
Free-response: 2 questions
UNIT
15–25% AP EXAM WEIGHTING
~30 CLASS PERIODS
Functions Involving
Parameters, Vectors,
and Matrices
Developing Understanding
ESSENTIAL
QUESTIONS
§ How can we determine
when the populations of
species in an ecosystem
will be relatively steady?
§ How can we analyze the
vertical and horizontal
aspects of motion
independently?
§ How does high resolution
computer-generated
imaging achieve smooth
and realistic motion on
screen with so many
pixels?
InUnit4,studentsexplorefunctiontypesthatexpandtheirunderstandingof
the function concept. Parametric functions have multiple dependent variables’
values paired with a single input variable or parameter. Modeling scenarios with
parametric functions allows students to explore change in terms of components.
This component-based understanding is important not only in calculus but in all
fieldsofthenaturalandsocialscienceswhereweseektounderstandoneaspectof
a phenomenon independent of other confounding aspects. Another major function
type in this unit involves matrices mapping a set of input vectors to output vectors.
The capacity to map large quantities of vectors instantaneously is the basis for
vector-based computer graphics. While students may see their favorite video game
character trip and fall or seemingly move closer or farther away, matrices implement
a rotation on a set of vectors or a dilation on a set of vectors. The power of matrices
to map vectors is not limited to graphics but to any system that can be expressed in
terms of components of vectors such as electrical systems, network connections,
and regional population distribution changes over time. Vectors and matrices are
also powerful tools of data science as they can be used to model aspects of complex
scientificandsocialsciencephenomena.
Building the Mathematical Practices
2.A
2.B
3.A
3.C
When encountering new function types, students are expected to engage with
multiple representations of each function type and practice communicating precise
```

### ap_precalculus 3.1 Periodic Phenomena (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.1
Periodic Phenomena
3.A
Describe the characteristics of
a function with varying levels
of precision, depending on the
functionrepresentation and
availablemathematicaltools.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Construct graphs of periodic
relationships based on verbal
representations.
Aperiodicrelationshipcanbeidentified
between two aspects of a context if, as the
input values increase, the output values
demonstrate a repeating pattern over
successive equal-length intervals.
3.1.A
3.1.A.1
3.1.A.2
The graph of a periodic relationship can be
constructed from the graph of a single cycle of
therelationship.
3.1.B
Describe key characteristics of
a periodic function based on a
verbalrepresentation.
3.1.B.1
The period of the function is the smallest
positive value k such that f ( x + k ) = f ( x )
for all x in the domain. Consequently, the
behavior of a periodic function is completely
determined by any interval of width k .
3.1.B.2
The period can be estimated by investigating
successive equal-length output values and
findingwherethepatternbeginstorepeat.
3.1.B.3
Periodic functions take on characteristics
of other functions, such as intervals of
increaseanddecrease,differentconcavities,
and various rates of change. However, with
periodic functions, all characteristics found
in one period of the function will be in every
period of the function.
UNIT
Trigonometric and Polar Functions
```

### ap_precalculus 3.2 Sine, Cosine, and Tangent (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.2
SUGGESTED SKILLS FOCUS
2.A
Sine, Cosine,
and Tangent
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
Determine the sine, cosine,
and tangent of an angle using
theunitcircle.
In the coordinate plane, an angle is in standard
position when the vertex coincides with the
origin and one ray coincides with the positive
x-axis. The other ray is called the terminal
ray. Positive and negative angle measures
indicate rotations from the positive x-axis in
the counterclockwise and clockwise direction,
respectively. Angles in standard position that
shareaterminalraydifferbyanintegernumber
ofrevolutions.
3.2.A
3.2.A.1
3.2.A.2
When considering a circle centered at the
origin, the radian measure of an angle in
standard position is the ratio of the length of
the arc of the circle that the angle subtends to
the radius of that same circle. For a unit circle,
which has radius 1, one radian is the measure of
the angle subtended at the center of the circle
by an arc that has length 1.
3.2.A.3
Givenanangleinstandardpositionandacircle
centered at the origin, there is a point, P ,
where the terminal ray intersects the circle.
The sine of the angle is the ratio of the vertical
displacement of P from the x-axis to the
distance between the origin and point P .
Therefore, for a unit circle, the sine of the angle
is the y-coordinate of point P .
continued on next page
UNIT
Trigonometric and Polar Functions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Determine the sine, cosine,
and tangent of an angle using
the unit circle.
Givenanangleinstandardpositionanda
circle centered at the origin, there is a point, P ,
where the terminal ray intersects the circle. The
cosine of the angle is the ratio of the horizontal
displacement of P from the y-axis to the
distance between the origin and point P .
Therefore, for a unit circle, the cosine of the
angle is the x-coordinate of point P .
3.2.A
3.2.A.4
3.2.A.5
Givenanangleinstandardposition,thetangent
of the angle is the slope, if it exists, of the
terminal ray. Because the slope of the terminal
ray is the ratio of the vertical displacement to
the horizontal displacement over any interval,
the tangent of the angle is the ratio of the
y-coordinate to the x-coordinate of the point at
which the terminal ray intersects the unit circle;
alternately, it is the ratio of the angle’s sine to its
cosine.
UNIT
Trigonometric and Polar Functions
```

### ap_precalculus 3.3 Sine and Cosine Function Values (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.3
SUGGESTED SKILLS FOCUS
2.A
Sine and Cosine
Function Values
Identify information from
graphical, numerical, analytical,
and verbal representations to
answer aquestionorconstruct
a model, with and without
technology.
3.B
Applynumericalresults ina
given mathematical or applied
context.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Determine coordinates of
points on a circle centered at
theorigin.
Givenanangleofmeasureθ in standard
position and a circle with radius r centered at
the origin, there is a point, P , where the terminal
ray intersects the circle. The coordinates of
point P are ( r cos θ , r sin θ ).
3.3.A
3.3.A.1
3.3.A.2
The geometry of isosceles right and equilateral
triangles, while attending to the signs of the
values based on the quadrant of the angle, can
beusedtofindexactvaluesforthecosineand
sine of angles that are multiples of
π
π
and
radians and whose terminal rays do not lie on
an axis.
UNIT
SUGGESTED SKILLS FOCUS
2.A
Identify information from
graphical, numerical,
analytical, and verbal
representations to answer
a question or construct a
model, with and without
technology.
Trigonometric and Polar Functions
```

### ap_precalculus 3.4 Sine and Cosine Function Graphs (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.4
Sine and Cosine
Function Graphs
3.A
Describe the characteristics
of a function with varying
levels of precision,
depending on the function
representation and available
mathematical tools.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Construct representations of
the sine and cosine functions
usingtheunitcircle.
Givenanangleofmeasureθ in standard
position and a unit circle centered at the
origin, there is a point, P , where the terminal
ray intersects the circle. The sine function,
f (θ ) = sin θ , gives the y-coordinate, or
vertical displacement from the x-axis, of point
P . The domain of the sine function is all real
numbers.
3.4.A
3.4.A.1
3.4.A.2
As the input values, or angle measures, of
the sine function increase, the output values
oscillate between −1 and 1, taking every
value in between and tracking the vertical
displacement of points on the unit circle from
the x-axis.
3.4.A.3
Givenanangleofmeasureθ in standard
position and a unit circle centered at the
origin, there is a point, P , where the terminal
ray intersects the circle. The cosine function,
f (θ ) = cos θ , gives the x-coordinate, or
horizontal displacement from the y-axis, of
point P . The domain of the cosine function is
all real numbers.
3.4.A.4
As the input values, or angle measures, of the
cosine function increase, the output values
oscillate between −1 and 1, taking every
value in between and tracking the horizontal
displacement of points on the unit circle from
the y-axis.
UNIT
Trigonometric and Polar Functions
```

### ap_precalculus 3.5 Sinusoidal Functions (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.5
SUGGESTED SKILLS FOCUS
Sinusoidal Functions
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
thesineandcosinefunctions.
A sinusoidal function is any function
that involves additive and multiplicative
transformations of f (θ ) = sin θ . The sine and
cosine functions are both sinusoidal functions,
3.5.A
3.5.A.1
(
with cos θ = sin θ +
3.5.A.2
)
π
.
The period and frequency of a sinusoidal
function are reciprocals. The period of
f (θ ) = sin θ and g (θ ) = cos θ is 2π , and the
frequency is
3.5.A.3
.
2π
The amplitude of a sinusoidal function is half the
differencebetweenitsmaximumandminimum
values. The amplitude of f (θ ) = sin θ and
g (θ ) = cos θ is 1.
3.5.A.4
The midline of the graph of a sinusoidal function
is determined by the average, or arithmetic
mean, of the maximum and minimum values
of the function. The midline of the graphs of
y = sin θ and y = cos θ is y = 0 .
3.5.A.5
As input values increase, the graphs of
sinusoidal functions oscillate between concave
down and concave up.
3.5.A.6
The graph of y = sin θ has rotational symmetry
about the origin and is therefore an odd
function. The graph of y = cos θ hasreflective
symmetry over the y-axis and is therefore an
even function.
UNIT
SUGGESTED SKILLS FOCUS
1.C
Construct new functions, using
transformations, compositions,
inverses, or regressions, that
may be useful in modeling
contexts,criteria, ordata,with
andwithouttechnology.
Trigonometric and Polar Functions
```

### ap_precalculus 3.8 The Tangent Function (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.8
SUGGESTED SKILLS FOCUS
The Tangent Function
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
Construct representations of
the tangent function using the
unitcircle.
Givenanangleofmeasureθ in standard
position and a unit circle centered at the
origin, there is a point, P , where the terminal
ray intersects the circle. The tangent function,
f (θ ) = tan θ , gives the slope of the terminal
ray.
3.8.A
3.8.A.1
3.8.A.2
Because the slope of the terminal ray is the ratio
of the change in the y-values to the change in
the x-values between any two points on the
ray, the tangent function is also the ratio of the
sine function to the cosine function. Therefore,
tan θ =
3.8.B
Describe key characteristics
ofthetangentfunction.
sin θ
, where cos θ ≠ 0.
cos θ
3.8.B.1
Because the slope values of the terminal ray
repeat every one-half revolution of the circle,
the tangent function has a period of π .
3.8.B.2
The tangent function demonstrates
periodic asymptotic behavior at input values
π
+ kπ , for integer values of k , because
cos θ = 0 at those values.
θ =
3.8.B.3
The tangent function increases and its graph
changes from concave down to concave up
between consecutive asymptotes.
continued on next page
UNIT
Trigonometric and Polar Functions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Describe additive and
multiplicative transformations
involving the tangent function.
The graph of the additive transformation
g (θ ) = tan θ + d of the tangent function
3.8.C
3.8.C.1
f (θ ) = tan θ is a vertical translation of the
graph of f and the line containing its points of
inflectionbyd units.
3.8.C.2
The graph of the additive transformation
g (θ ) = tan (θ + c ) of the tangent function
f (θ ) = tan θ is a horizontal translation, or
phase shift, of the graph of f by −c units.
3.8.C.3
The graph of the multiplicative transformation
g (θ ) = a tan θ of the tangent function
f (θ ) = tan θ is a vertical dilation of the
graph of f by a factor of a . If a < 0, the
transformationinvolvesareflectionoverthe
x-axis.
3.8.C.4
The graph of the multiplicative transformation
g (θ ) = tan ( bθ ) of the tangent function
f (θ ) = tan θ is a horizontal dilation of the
graph of f anddiffersinperiodbyafactor
. If b < 0, the transformation involves a
b
reflection over the y-axis.
of
3.8.C.5
The graph of y = f (θ ) = a tan ( b (θ + c ) ) + d
is a vertical dilation of the graph of y = tan θ
by a factor of a , has a period of
π units, is a
b
vertical shift of the line containing the points of
inflectionofthegraphof y = tan θ by d units,
and is a phase shift of −c units.
UNIT
Trigonometric and Polar Functions
```

### ap_precalculus 3.9 Inverse Trigonometric Functions (Unit 3: Trigonometric and Polar Functions)
Official CED text (governs):
```
TOPIC 3.9
SUGGESTED SKILLS FOCUS
1.C
Inverse Trigonometric
Functions
Construct new functions, using
transformations, compositions,
inverses, or regressions, that
may be useful in modeling
contexts,criteria, ordata,with
andwithouttechnology.
Required Course Content
Construct equivalent graphical,
numerical, analytical, and
verbal representations of
functions that are useful in a
given mathematical or applied
context, with and without
technology.
2.B
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Construct analytical and
graphical representations of
the inverse of the sine, cosine,
and tangent functions over a
restricteddomain.
For inverse trigonometric functions, the input
and output values are switched from their
corresponding trigonometric functions, so
the output value of an inverse trigonometric
function is often interpreted as an angle
measure and the input is a value in the range of
thecorrespondingtrigonometricfunction.
3.9.A
3.9.A.1
3.9.A.2
The inverse trigonometric functions are called
arcsine, arccosine, and arctangent (also
−1
−1
−1
represented as sin x , cos x , and tan x ).
Because the corresponding trigonometric
functions are periodic, they are only invertible if
theyhaverestricteddomains.
3.9.A.3
Inordertodefinetheirrespectiveinverse
functions, the domain of the sine function is
π π]
, the cosine function to
,
[| 2 2 ]|
]0, π ], and the tangent function to - π , π .
2 2
restricted to [ -
(
)
UNIT
SUGGESTED SKILLS FOCUS
1.A
Solve equations and
inequalities represented
analytically, with and without
technology.
2.A
Identify information from
graphical, numerical, analytical,
and verbal representations to
answer aquestionorconstruct
a model, with and without
technology.
3.B
Applynumericalresults ina
given mathematical or applied
context.
Trigonometric and Polar Functions
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

