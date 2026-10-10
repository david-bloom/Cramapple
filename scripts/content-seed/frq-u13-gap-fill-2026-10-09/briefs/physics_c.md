# FRQ writing brief: physics_c

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


# Subject: AP Physics C: Mechanics (subject_key ap_physics_c_mechanics)
Format: Short free-response in AP Physics C style: a setup described fully in words (no diagram). Calculus-based derivations are expected where the topic calls for them; numeric answers carry units.
Parts: 2-4. Criteria (points) in total: 3-5.

## Topics in this subject's Units 1, 2, 3 (stay inside the designated topic)
1.1 Scalars and Vectors (Unit 1: Kinematics)
1.2 Displacement, Velocity, and Acceleration (Unit 1: Kinematics)
1.3 Representing Motion (Unit 1: Kinematics)
1.4 Reference Frames and Relative Motion (Unit 1: Kinematics)
1.5 Motion in Two or Three Dimensions (Unit 1: Kinematics)
2.1 Systems and Center of Mass (Unit 2: Force and Translational Dynamics)
2.10 Circular Motion (Unit 2: Force and Translational Dynamics)
2.2 Forces and Free-Body Diagrams (Unit 2: Force and Translational Dynamics)
2.3 Newton's Third Law (Unit 2: Force and Translational Dynamics)
2.4 Newton's First Law (Unit 2: Force and Translational Dynamics)
2.5 Newton's Second Law (Unit 2: Force and Translational Dynamics)
2.6 Gravitational Force (Unit 2: Force and Translational Dynamics)
2.7 Kinetic and Static Friction (Unit 2: Force and Translational Dynamics)
2.8 Spring Forces (Unit 2: Force and Translational Dynamics)
2.9 Resistive Forces (Unit 2: Force and Translational Dynamics)
3.1 Translational Kinetic Energy (Unit 3: Work, Energy, and Power)
3.2 Work (Unit 3: Work, Energy, and Power)
3.3 Potential Energy (Unit 3: Work, Energy, and Power)
3.4 Conservation of Energy (Unit 3: Work, Energy, and Power)
3.5 Power (Unit 3: Work, Energy, and Power)

## Targets: write exactly one FRQ for each of these 11 topics

### ap_physics_c_mechanics 1.1 Scalars and Vectors (Unit 1: Kinematics)
Official CED text (governs):
```
TOPIC 1.1
SUGGESTED SKILLS
Scalars and Vectors
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
2.A
Derive a symbolic
expression from known
quantities by selecting
and following a logical
mathematical pathway.
2.B
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.1.A
1.1.A.1
Describe a scalar or vector
quantity using magnitude and
direction,asappropriate.
Scalars are quantities described by magnitude
only; vectors are quantities described by both
magnitude and direction.
Calculate or estimate an
unknown quantity with units
from known quantities, by
selecting and following
a logical computational
pathway.
3.B
1.1.A.2
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
Vectors can be visually modeled as arrows with
appropriate direction and lengths proportional
to their magnitude.
1.1.A.3
Distance and speed are examples of scalar
quantities, while position, displacement,
velocity, and acceleration are examples of
vector quantities.
1.1.A.4
Vectors can be expressed in unit vector
notation or as a magnitude and a direction.
1.1.A.4.i
Unit vector notation can be used to
represent vectors as the sum of their
constituent components in the x-, y-,
and z-directions,denotedbyi , j, and k ,
respectively.
Relevant equation:
1.1.A.4.ii

The position vector of a point is given by r ,
and the unit vector in the direction of the
position vector is denoted r .
continued on next page
Return to Table of Contents
UNIT
Kinematics
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.1.A
1.1.A.4.iii
Describe a scalar or vector
quantity using magnitude and
direction, as appropriate.
A resultant vector is the vector sum of the
addend vectors’ components.
Relevant equations:
1.1.A.5
Inagivenone-dimensionalcoordinatesystem,
opposite directions are denoted by opposite
signs.
Return to Table of Contents
UNIT
Kinematics
```

### ap_physics_c_mechanics 1.4 Reference Frames and Relative Motion (Unit 1: Kinematics)
Official CED text (governs):
```
TOPIC 1.4
SUGGESTED SKILLS
Reference Frames
and Relative Motion
Required Course Content
LEARNING OBJECTIVE
The suggested skills note the course skills that could be paired
with the learning objectives for that topic.
UNIT
Kinematics
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
2.B
Calculate or estimate an
unknown quantity with units
from known quantities, by
selecting and following
a logical computational
pathway.
2.C
ESSENTIAL KNOWLEDGE
1.4.A
1.4.A.1
Describe the reference frame
of a given observer.
The choice of reference frame will determine
the direction and magnitude of quantities
measured by an observer in that reference
frame.
1.4.B
1.4.B.1
Describe the motion of
objects as measured by
observers in different inertial
reference frames.
Measurements from a given reference frame
may be converted to measurements from
another reference frame.
Compare physical
quantities between two
or more scenarios or at
different times and/or
locations within a single
scenario.
3.B
Learning objectivesdefinewhatastudentneedstobeableto
do with content knowledge to progress through the course.
Essential knowledgestatementsdefinetherequiredcontent
knowledge associated with each learning objective assessed on
the AP Exam.
Boundary statements provide guidance to teachers regarding
the content boundaries of the AP Physics courses. Boundary
statements appear at the end of essential knowledge
statements where appropriate.
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
1.4.B.2
The observed velocity of an object results from
the combination of the object’s velocity and
the velocity of the observer’s reference frame.
1.4.B.2.i
Combining the motion of an object and the
motion of an observer in a given reference
frame involves the addition or subtraction
of vectors.
1.4.B.2.ii
The acceleration of any object is the same
as measured from all inertial reference
frames.
BOUNDARY STATEMENT
Unless otherwise stated, the frame of reference of any problem may be assumed to
be inertial.
00762-139-CED-Physics C-Mechanics_Unit 1.indd 33
| 33
09/05/26 7:15 PM
Return to Table of Contents
THIS PAGE IS INTENTIONALLY LEFT BLANK.
AP PHYSICS C: MECHANICS
UNIT 1
Kinematics
10–15%
AP EXAM WEIGHTING
~14–19
CLASS PERIODS
Return to Table of Contents
Remember to go to AP Classroom
to assign students the online
Progress Check for this unit.
Whether assigned as homework or
completedinclass,the Progress
Check provides each student with
immediate feedback related to this
unit’stopicand skills.
Progress Check 1
Multiple-choice: ~18 questions
Free-response: 4 questions
§ Mathematical Routines
§ Translation Between
Representations
§ Experimental Design and
Analysis
§ Qualitative/Quantitative
Translation
Return to Table of Contents
UNIT
10–15% AP EXAM WEIGHTING ~14–19 CLASS PERIODS
Kinematics
Developing Understanding
ESSENTIAL
```

### ap_physics_c_mechanics 2.1 Systems and Center of Mass (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.1
Systems and
Center of Mass
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.1.A
2.1.A.1
Describe the properties and
interactions of a system.
System properties are determined by the
interactions between objects within the
system.
2.1.A.2
If the properties or interactions of the
constituent objects within a system are not
important in modeling the behavior of the
macroscopic system, the system can itself be
treated as a single object.
2.1.A.3
Systems may allow interactions between
constituent parts of the system and the
environment, which may result in the transfer of
energy or mass.
2.1.A.4
Individual objects within a chosen system may
behavedifferentlyfromeachotheraswellas
from the system as a whole.
2.1.A.5
Theinternalstructureofasystemaffectsthe
analysis of that system.
2.1.A.6
As variables external to a system are changed,
the system’s substructure may change.
continued on next page
Return to Table of Contents
Force and Translational Dynamics
LEARNING OBJECTIVE
UNIT
ESSENTIAL KNOWLEDGE
2.1.B
2.1.B.1
Describe the location of a
system’s center of mass
with respect to the system’s
constituent parts.
For objects or systems with symmetrical mass
distributions, the center of mass is located on
lines of symmetry.
2.1.B.2
The location of a system’s center of mass along a
given axis can be calculated using the equation
.
2.1.B.3
For a nonuniform solid that can be considered
asacollectionofdifferentialmasses,dm , the
solid’s center of mass can be calculated using
the equation
2.1.B.3.i
The linear mass density of a rod or other
linear rigid body is the derivative of the
rod’s mass with respect to the position of
thedifferentialmasselementontherigid
body.
Relevant equation:
2.1.B.3.ii
If a function of mass density is given for
a solid, the total mass can be determined
by integrating the mass density over
the length (one dimension), area (two
dimensions), or volume (three dimensions)
of the solid. For example:
2.1.B.4
A system can be modeled as a singular object
that is located at the system’s center of mass.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
2.C
Compare physical
quantities between two
or more scenarios or at
different times and/or
locations within a single
scenario.
3.B
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
3.C
Justify or support a claim
using evidence from
experimental data, physical
representations, or physical
principles or laws.
Force and Translational Dynamics
```

### ap_physics_c_mechanics 2.2 Forces and Free-Body Diagrams (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.2
Forces and
Free-Body
Diagrams
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.2.A
2.2.A.1
Describe a force as an
interaction between two
objects or systems
Forces are vector quantities that describe the
interactions between objects or systems.
2.2.A.1.i
A force exerted on an object or system is
always due to the interaction of that object
or system with another object or system.
2.2.A.1.ii
An object or system cannot exert a net
force on itself.
2.2.A.2
Contact forces describe the interaction of
an object or system touching another object
orsystemandaremacroscopiceffectsof
interatomic electric forces.
2.2.B
2.2.B.1
Describe the forces exerted
on an object or system using
afree-bodydiagram.
Free-bodydiagramsareusefultoolsfor
visualizingforcesbeingexertedonasingle
object or system and for determining the
equations that represent a physical situation.
2.2.B.2
Thefree-bodydiagramofanobjectorsystem
shows each of the forces exerted on the object
or system by the environment.
2.2.B.3
Forces exerted on an object or system are
represented as vectors originating from the
representation of the center of mass, such as
a dot. A system is treated as though all of its
mass is located at the center of mass.
continued on next page
Return to Table of Contents
Force and Translational Dynamics
LEARNING OBJECTIVE
UNIT
ESSENTIAL KNOWLEDGE
2.2.B
2.2.B.4
Describe the forces exerted
on an object or system using
a free-body diagram.
A coordinate system with one axis parallel to
the direction of acceleration of the object or
systemsimplifiesthetranslationfromfreebody diagram to algebraic representation. For
example,inafree-bodydiagramofanobject
on an inclined plane, it is useful to set one axis
parallel to the surface of the incline.
BOUNDARY STATEMENT
AP Physics C: Mechanics and AP Physics C: Electricity and Magnetism only expect
students to depict the forces exerted on objects, not the force components on
free-bodydiagrams.OntheAPPhysicsexams,individualforcesrepresentedona
free-bodydiagrammustbedrawnasindividualstraightarrows,originatingonthe
dot and pointing in the direction of the force. Individual forces that are in the same
direction must be drawn side by side, not overlapping.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
Force and Translational Dynamics
```

### ap_physics_c_mechanics 2.3 Newton's Third Law (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.3
Newton’s Third Law
2.C
Compare physical
quantities between two
or more scenarios or at
different times and/or
locations within a single
scenario.
3.B
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
3.C
Justify or support a claim
using evidence from
experimental data, physical
representations, or physical
principles or laws.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.3.A
2.3.A.1
Describe the interaction
of two objects or systems
using Newton’s third law and
a representation of paired
forces exerted on each
object or system.
Newton’s third law describes the interaction of
two objects or systems in terms of the paired
forces that each exerts on the other.
2.3.A.2
Interactions between objects within a system
(internalforces)donotinfluencethemotionof
a system’s center of mass.
2.3.A.3
Tension is the macroscopic net result of forces
thatinfinitesimalsegmentsofastring,cable,
chain, or similar system exert on each other in
response to an external force.
2.3.A.3.i
An ideal string has negligible mass and
does not stretch when under tension.
2.3.A.3.ii
The tension in an ideal string is the same at
all points within the string.
2.3.A.3.iii
In a string with nonnegligible mass, tension
may not be the same at all points within the
string.
2.3.A.3.iv
An ideal pulley is a pulley that has negligible
mass and rotates about an axle through its
center of mass with negligible friction.
Return to Table of Contents
UNIT
Force and Translational Dynamics
```

### ap_physics_c_mechanics 2.4 Newton's First Law (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.4
SUGGESTED SKILLS
Newton’s First Law
1.C
Create qualitative sketches
of graphs that represent
features of a model or the
behavior of the physical
system.
2.B
Calculate or estimate an
unknown quantity with units
from known quantities, by
selecting and following
a logical computational
pathway.
Required Course Content
LEARNING OBJECTIVE
2.C
ESSENTIAL KNOWLEDGE
2.4.A
2.4.A.1
Describe the conditions
under which a system’s
velocity remains constant.
The net force on a system is the vector sum of
all forces exerted on the system.
2.4.A.2
Translationalequilibriumistheconfiguration
of forces such that the net force exerted on a
systemiszero.
Derived equation:
Compare physical
quantities between two
or more scenarios or at
different times and/or
locations within a single
scenario.
3.C
Justify or support a claim
using evidence from
experimental data, physical
representations, or physical
principles or laws.
2.4.A.3
Newton’sfirstlawstatesthatifthenetforce
exertedonasystemiszero,thevelocityofthat
system will remain constant.
2.4.A.4
Forces may be balanced in one dimension
but unbalanced in another. The system’s
velocity will change only in the direction of the
unbalanced force.
2.4.A.5
An inertial reference frame is one from which
anobserverwouldverifyNewton’sfirstlawof
motion.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.B
Create quantitative graphs
with appropriate scales
and units, including plotting
data.
Force and Translational Dynamics
```

### ap_physics_c_mechanics 2.5 Newton's Second Law (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.5
Newton’s Second Law
2.B
Calculate or estimate an
unknown quantity with units
from known quantities, by
selecting and following
a logical computational
pathway.
2.D
Predict new values or
factors of change of
physical quantities using
functional dependence
between variables.
3.A
Create experimental
procedures that are
appropriate for a given
scientific question.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.5.A
2.5.A.1
Describe the conditions
under which a system’s
velocity changes.
Unbalancedforcesareaconfigurationof
forces such that the net force exerted on a
systemisnotequaltozero.
3.C
Justify or support a claim
using evidence from
experimental data, physical
representations, or physical
principles or laws.
2.5.A.2
Newton’s second law of motion states that the
acceleration of a system’s center of mass has
a magnitude proportional to the magnitude of
the net force exerted on the system and is in
the same direction as that net force.
Relevant equation:
2.5.A.3
The velocity of a system’s center of mass will
onlychangeifanonzeronetexternalforceis
exerted on that system.
Return to Table of Contents
UNIT
Force and Translational Dynamics
```

### ap_physics_c_mechanics 2.7 Kinetic and Static Friction (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.7
SUGGESTED SKILLS
1.B
Kinetic and Static
Friction
Create quantitative graphs
with appropriate scales
and units, including plotting
data.
Required Course Content
Calculate or estimate an
unknown quantity with units
from known quantities, by
selecting and following
a logical computational
pathway.
2.A
Derive a symbolic
expression from known
quantities by selecting
and following a logical
mathematical pathway.
2.B
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.7.A
2.7.A.1
Describe kinetic friction
between two surfaces.
Kinetic friction occurs when two surfaces in
contact move relative to each other.
3.A
2.7.A.1.i
The kinetic friction force is exerted in a
direction opposite the motion of each
surface relative to the other surface.
2.7.A.1.ii
The force of friction between two surfaces
doesnotdependonthesizeofthesurface
area of contact.
Create experimental
procedures that are
appropriate for a given
scientific question.
3.B
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
2.7.A.2
The magnitude of the kinetic friction force
exerted on an object is the product of the
normal force the surface exerts on the object
andthecoefficientofkineticfriction.
Relevant equation:


Ff ,k = µ k FN
2.7.A.2.i
Thecoefficientofkineticfrictiondepends
on the material properties of the surfaces
that are in contact.
2.7.A.2.ii
Normal force is the perpendicular
component of the force exerted on an
object by the surface with which it is
in contact; it is directed away from the
surface.
continued on next page
Return to Table of Contents
UNIT
Force and Translational Dynamics
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.7.B
2.7.B.1
Describe static friction
between two surfaces.
Static friction may occur between the
contacting surfaces of two objects that are not
moving relative to each other.
2.7.B.2
Static friction adopts the value and direction
required to prevent an object from slipping or
sliding on a surface.
Relevant equation:
2.7.B.2.i
Slipping and sliding refer to situations in
which two surfaces are moving relative to
each other.
2.7.B.2.ii
There exists a maximum value for which
static friction will prevent an object from
slipping on a given surface.
Derived equation:
Ff ,s ,max = µ s FN
2.7.B.3
Thecoefficientofstaticfrictionistypically
greaterthanthecoefficientofkineticfriction
for a given pair of surfaces.
Return to Table of Contents
UNIT
Force and Translational Dynamics
```

### ap_physics_c_mechanics 2.8 Spring Forces (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.8
SUGGESTED SKILLS
1.A
Spring Forces
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
2.B
Calculate or estimate an
unknown quantity with units
from known quantities, by
selecting and following
a logical computational
pathway.
Required Course Content
2.D
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.8.A
2.8.A.1
Describe the force exerted on
an object by an ideal spring.
An ideal spring has negligible mass and exerts
a force that is proportional to the change in its
length as measured from its relaxed length. A
nonideal spring either has nonnegligible mass
or exerts a force that is not proportional to
the change in its length as measured from its
relaxed length.
Predict new values or
factors of change of
physical quantities using
functional dependence
between variables.
3.C
Justify or support a claim
using evidence from
experimental data, physical
representations, or physical
principles or laws.
2.8.A.2
The magnitude of the force exerted by an ideal
spring on an object is given by Hooke’s law:
2.8.A.3
The force exerted on an object by a spring is
always directed toward the equilibrium position
of the object–spring system.
2.8.B
2.8.B.1
Describe the equivalent
spring constant of a
combination of springs
exerting forces on an object.
A collection of springs that exert forces on
an object may behave as though they were
a single spring with an equivalent spring
constant keq .
2.8.B.1.i
The inverse of the equivalent spring
constant of a set of springs in series is
equal to the sum of the inverses of the
individual spring constants.
Derived equation:
continued on next page
Return to Table of Contents
UNIT
Force and Translational Dynamics
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.8.B
2.8.B.1.ii
Describe the equivalent
spring constant of a
combination of springs
exerting forces on an object.
The equivalent spring constant of a set of
springs arranged in series is smaller than
the smallest constituent spring constant.
2.8.B.1.iii
The equivalent spring constant of a set of
springs arranged in parallel is the sum of
the individual spring constants.
Derived equation:
BOUNDARY STATEMENT
APPhysicsC:Mechanicsonlyexpectsstudentstofindtheeffectivespring
constant of systems of springs that are arranged either in series or in parallel and
doesnotexpectstudentstofindtheeffectivespringconstantofasysteminwhich
springs are arranged in both series and parallel.
Return to Table of Contents
UNIT
Force and Translational Dynamics
```

### ap_physics_c_mechanics 3.1 Translational Kinetic Energy (Unit 3: Work, Energy, and Power)
Official CED text (governs):
```
TOPIC 3.1
SUGGESTED SKILLS
Translational
Kinetic Energy
1.C
Create qualitative sketches
of graphs that represent
features of a model or the
behavior of the physical
system.
2.C
Compare physical
quantities between two
or more scenarios or at
different times and/or
locations within a single
scenario.
Required Course Content
3.B
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.1.A
3.1.A.1
Describe the translational
kinetic energy of an object in
terms of the object’s mass
and velocity.
An object’s translational kinetic energy is given
by the equation
K = mv 2.
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
3.C
Justify or support a claim
using evidence from
experimental data, physical
representations, or physical
principles or laws.
3.1.A.2
Translational kinetic energy is a scalar quantity.
3.1.A.3
Differentobserversmaymeasuredifferent
values of the translational kinetic energy of an
object, depending on the observer’s frame of
reference.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
Work, Energy, and Power
```

### ap_physics_c_mechanics 3.5 Power (Unit 3: Work, Energy, and Power)
Official CED text (governs):
```
TOPIC 3.5
Power
2.B
Calculate or estimate an
unknown quantity with units
from known quantities, by
selecting and following
a logical computational
pathway.
2.C
Compare physical
quantities between two
or more scenarios or at
different times and/or
locations within a single
scenario.
3.B
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.5.A
3.5.A.1
Describe the transfer of
energy into, out of, or within a
system in terms of power.
Power is the rate at which energy changes with
respect to time, either by transfer into or out
of a system or by conversion from one type to
another within a system.
3.5.A.2
Average power is the amount of energy being
transferred or converted, divided by the time it
took for that transfer or conversion to occur.
Relevant equation:
3.5.A.3
Because work is the change in energy of an
object or system due to a force, average power
is the total work done, divided by the time
during which that work was done.
Relevant equation:
3.5.A.4
The instantaneous power delivered to an
object by a force is given by the equation
Pinst =
dW .
dt
3.5.A.5
The instantaneous power delivered to an
object by the component of a constant
force parallel to the object’s velocity can be
described with the derived equation
Return to Table of Contents
AP PHYSICS C: MECHANICS
UNIT 4
Linear
Momentum
10–20%
AP EXAM WEIGHTING
~11–15
CLASS PERIODS
Return to Table of Contents
Remember to go to AP Classroom
to assign students the online
Progress Checkforthis unit.
Whether assigned as homework or
completedinclass,the Progress
Check provides each student with
immediate feedback related to this
unit’stopicand skills.
Progress Check 4
Multiple-choice: ~18 questions
Free-response: 4 questions
§ Mathematical Routines
§ Translation Between
Representations
§ Experimental Design and
Analysis
§ Qualitative/Quantitative
Translation
Return to Table of Contents
UNIT
10–20% AP EXAM WEIGHTING
~11–15 CLASS PERIODS
Linear Momentum
Developing Understanding
ESSENTIAL
QUESTIONS
§ Why does water move
a ship forward when its
propellers push water
backward?
§ Why are cannon
barrels so much longer
and heavier than
cannonballs?
§ Why might a person land
in the water instead of
on the dock when trying
to exit a canoe?
Unit 4 introduces students to the relationships between force, time, impulse, and linear
momentum via calculations, data analysis, designing experiments, and making predictions.
Students will learn how to use new models and representations to illustrate the law of
conservationoflinearmomentumofobjectsandsystemswhilegainingproficiencyusing
previously studied representations. Using the law of conservation of linear momentum to
analyzephysicalsituationsprovidesstudentswithamorecompletepictureofforcesand
opportunities to revisit misconceptions surrounding Newton’s third law. Students will also
have the opportunity to make connections between momentum and kinetic energy of objects
or systems and see under what conditions these quantities remain constant.
Building the
Science Practices
1.B
2.B
2.D
3.A
```


## AP Physics C: Mechanics CED fact pack (course-wide sections and units up to 3)
# AP Physics C: Mechanics - CED Fact Pack

Status: Primary-source verified, deep tier for all 7 units (full assessed scope). Use this version for 2026-27 authoring and review. Mirrored into this repo from Google Drive on 2026-08-03 so all subject fact packs live in one place; no content was changed in the move.

## Source control

Source document: College Board, AP Physics C: Mechanics Course and Exam Description.

Edition: "Effective Fall 2024," copyright 2026 College Board. David-supplied primary-source PDF, extracted and verified directly.

No local copy of the source PDF exists in this repo's `docs/teaching/` directory as of 2026-08-03 — unlike the Statistics/Precalculus/Calculus/Chemistry fact packs, this one cannot cite a local file path or SHA-256. If the PDF is added to `docs/teaching/`, update this section with its path and hash.

Drive fact-pack source: "AP Physics C Mechanics 2026-27 — CED Fact Pack (v2, primary source, use this one)", file ID `1rc_z7A4CmhDx1Ya6zJswnKYm2wtOrLsJRK-7qBzDxG0`, created 2026-07-23.

This replaces an earlier low-confidence version built from web-search summaries, which was wrong about the unit structure — the web-search version had Unit 7 as "Gravitation." The actual current CED has no standalone Gravitation unit at all; that content is now folded into Unit 6.

**2026-08-08 deep-tier build (this session) — first Physics C: Mechanics pass off bare tier, all 7 units (full assessed scope).** David supplied the full primary-source set for the first time: the 220-page CED PDF (`ap-physics-c-mechanics-course-and-exam-description.pdf`, "Effective Fall 2024," read directly page-by-page for all 7 units, pages 21-133), the CED clarifications/corrections document (`ap-physics-c-mechanics-course-and-exam-description-clarifications.pdf`), the 2025 Chief Reader Report, the 2025 Scoring Guidelines, and the 2025/2026 released FRQ booklets. (The Q1/Q2 Sample Student Responses and Scoring Commentary booklets were not needed in depth — the Chief Reader Report and Scoring Guidelines together already supplied concrete, quotable misconception and scoring-convention evidence for every unit except Unit 1.) Every equation, LO/EK claim, and boundary statement below was read directly from the cited CED pages; every misconception/scoring claim was read directly from the 2025 Chief Reader Report or 2025 Scoring Guidelines, not inferred. **Correction to prior content: none found** — the Section 2 weighting table and Section 3 topic map both check out exactly against the primary source, topic-by-topic and number-by-number, including the already-correct notes about Unit 6.6 absorbing gravitation content and rotation being split across Units 5/6. See the new "Units 1-3 deep-tier detail" and "Units 4-7 deep-tier detail" sections below.

**Confirmed exam-structure update (from the clarifications document, to be implemented Fall 2026):** multiple-choice section is now **42 questions in 85 minutes** (was 40/80), and the free-response section is now **95 minutes** (was 100) — the point/question counts and FRQ archetypes are unchanged. This is a real, source-verified correction/addition to Section 1 below, not present in the prior version of this fact pack.

## 1. Exam structure

- Calculus-based course.
- 3 hours total: Section I is 42 multiple-choice questions (50% of score, 85 minutes); Section II is 4 free-response questions (50% of score, 95 minutes). A four-function, scientific, or graphing calculator is allowed on both sections.
- FRQ types (per scoring guidelines section, in fixed exam order): Question 1 Mathematical Routines (10 pts, ~20-25 min), Question 2 Translation Between Representations (12 pts, ~25-30 min), Question 3 Experimental Design and Analysis/LAB (10 pts, ~25-30 min), Question 4 Qualitative/Quantitative Translation (8 pts, ~15-20 min).
- 2025 global exam stats (Chief Reader Report): 66,267 students scored, global mean 3.30, score distribution 5=21.7%, 4=24.0%, 3=27.5%, 2=16.0%, 1=10.9%.

## 2. Units and MC exam weighting (verified, primary source, current edition)

| Unit | Title | MC Weighting |
|---|---|---|
| 1 | Kinematics | 10-15% |
| 2 | Force and Translational Dynamics | 20-25% |
| 3 | Work, Energy, and Power | 15-25% |
| 4 | Linear Momentum | 10-20% |
| 5 | Torque and Rotational Dynamics | 10-15% |
| 6 | Energy and Momentum of Rotating Systems | 10-15% |
| 7 | Oscillations | 10-15% |

**7 units total. No standalone Gravitation unit** — gravitational/orbital content now lives inside Unit 6 (topic 6.6). Rotation is split across two units (5 and 6) rather than one combined unit.

## 3. Topic map (verified from primary source, current edition)

**Unit 1 (Kinematics):** 1.1 Scalars and Vectors, 1.2 Displacement/Velocity/Acceleration, 1.3 Representing Motion, 1.4 Reference Frames and Relative Motion, 1.5 Motion in Two or Three Dimensions

**Unit 2 (Force and Translational Dynamics):** 2.1 Systems and Center of Mass, 2.2 Forces and Free-Body Diagrams, 2.3 Newton's Third Law, 2.4 Newton's First Law, 2.5 Newton's Second Law, 2.6 Gravitational Force, 2.7 Kinetic and Static Friction, 2.8 Spring Forces, 2.9 Resistive Forces, 2.10 Circular Motion

**Unit 3 (Work, Energy, and Power):** 3.1 Translational Kinetic Energy, 3.2 Work, 3.3 Potential Energy, 3.4 Conservation of Energy, 3.5 Power

**Unit 4 (Linear Momentum):** 4.1 Linear Momentum, 4.2 Change in Momentum and Impulse, 4.3 Conservation of Linear Momentum, 4.4 Elastic and Inelastic Collisions

**Unit 5 (Torque and Rotational Dynamics):** 5.1 Rotational Kinematics, 5.2 Connecting Linear and Rotational Motion, 5.3 Torque, 5.4 Rotational Inertia, 5.5 Rotational Equilibrium and Newton's First Law in Rotational Form, 5.6 Newton's Second Law in Rotational Form

**Unit 6 (Energy and Momentum of Rotating Systems):** 6.1 Rotational Kinetic Energy, 6.2 Torque and Work, 6.3 Angular Momentum and Angular Impulse, 6.4 Conservation of Angular Momentum, 6.5 Rolling, **6.6 Motion of Orbiting Satellites (this is where gravitation/orbital mechanics content lives now)**

**Unit 7 (Oscillations):** 7.1 Defining Simple Harmonic Motion (SHM), 7.2 Frequency and Period of SHM, 7.3 Representing and Analyzing SHM, 7.4 Energy of Simple Harmonic Oscillators, 7.5 Simple and Physical Pendulums

## 4. Authoring/review guidance

- **Do not author or approve any item under a standalone "Gravitation" topic label** — it doesn't exist as a unit in the current CED. Orbital mechanics / universal gravitation content belongs under Unit 6, Topic 6.6 (Motion of Orbiting Satellites), and should be framed in that context (energy/momentum of orbiting systems), not as isolated gravitation-only content.
- Rotational content is split: kinematics/torque/Newton's laws in rotational form live in Unit 5; rotational energy, angular momentum, rolling, and orbital motion live in Unit 6. Check which sub-topic a rotation question actually targets before filing it.
- This is a calculus-based course — content should use derivatives/integrals where appropriate (e.g., angular impulse as the integral of torque dt, matching the linear-momentum treatment in Unit 4).
- If any existing `apphycm-*` content references a standalone "gravitation" unit or topic tag, it needs to be re-mapped to Unit 6 topic 6.6 rather than treated as its own unit.
- This course's unit structure and topic numbering are the calculus-based counterpart to AP Physics 1 (see that fact pack) — the two are now structured identically, unit-for-unit and topic-for-topic, aside from calculus notation.

## 5. Units 1-3 deep-tier detail (2026-08-08)

This section and Section 6 deepen all 7 units to the same tier as the Physics 1 and Physics C: E&M fact packs, using the full CED PDF (pages 21-76 for Units 1-3), the CED clarifications document, the 2025 Chief Reader Report, and the 2025 Scoring Guidelines. Per-topic entries below give exact equations with symbol conventions, boundary/exclusion statements quoted verbatim (or an explicit "zero explicit exclusion statements" where the CED page was checked and carries no boundary box), and brief conceptual framing. Physics C: Mechanics is calculus-based throughout — where the CED itself uses derivative/integral notation (e.g. `v_x = dx/dt`, `ΔU = -∫F·dr`), that notation is preserved below rather than paraphrased into the algebra-based language Physics 1 uses for the same concept, and every place where this course's calculus treatment genuinely diverges from Physics 1's algebra-based treatment of the parallel topic is flagged explicitly as a verified difference (not assumed from the topic-map parallel).

### General exam-wide conventions (apply to every FRQ, not just Units 1-3)

- **`g ≈ 10 m/s²` is used for all numeric problems, and students are not penalized for using `9.81 m/s²` or `9.8 m/s²` instead — identical convention to Physics 1.** Verbatim boundary statement (topic 1.3, and shared with Physics C: E&M): "AP Physics C: Mechanics and AP Physics C: Electricity and Magnetism expects that for all situations in which a numerical quantity is required for `g`, the value `g ≈ 10 m/s²` will be used. However, students will not be penalized for correctly using the more precise commonly accepted values of `g = 9.81 m/s²` or `g = 9.8 m/s²`." This directly answers the prompt's open question: Physics C: Mechanics shares Physics 1's exact `g` convention — it is **not** the Physics 2-style "9.8 only" convention.
- **Free-body-diagram convention is identical to Physics 1's, verbatim (topic 2.2):** "AP Physics C: Mechanics and AP Physics C: Electricity and Magnetism only expect students to depict the forces exerted on objects, not the force components on free-body diagrams. On the AP Physics exams, individual forces represented on a free-body diagram must be drawn as individual straight arrows, originating on the dot and pointing in the direction of the force. Individual forces that are in the same direction must be drawn side by side, not overlapping." Re-confirmed for **momentum-vector diagrams** by the 2025 Scoring Guidelines (Q1 Part A): the same "arrow starting on, and pointing away from, the dot" convention governs momentum arrows, not just force arrows — this is a standing Physics-C-family vector-diagram rule, not FBD-specific, exactly as documented for Physics 1.
- **A key, verified calculus-vs-algebra split in vector-direction treatment that is *not* uniform across the course:** rotational-**kinematics** vectors (angular displacement/velocity/acceleration, topics 5.1-5.2) stay **magnitude-only** in this course, with an explicit boundary statement matching Physics 1's: "AP Physics C: Mechanics expects students to be able to mathematically manipulate the magnitudes of angular displacement, angular velocity, and angular acceleration using vector conventions. However, the directions of said vectors will not be assessed on the exam. Descriptions of the directions of rotational kinematics quantities for a point or rigid body are limited to clockwise and counterclockwise with respect to a given axis of rotation." **But torque (5.3) and angular momentum (6.3) are full vector cross-product quantities in Physics C: Mechanics, with no such magnitude-only boundary statement** — `τ = r⃗ × F⃗` and `L⃗ = r⃗ × p⃗` are both presented with explicit right-hand-rule direction determination (EK 5.3.B.2.ii-iii, 6.3.A.2). This is the opposite of Physics 1, where torque and angular momentum are both explicitly magnitude-only ("the direction of torque is beyond the scope of the course"). **Do not assume Physics C: Mechanics torque/angular-momentum items are magnitude-only just because Physics 1's parallel topics are** — cross-product/right-hand-rule reasoning is fair game here.
- Credit is part-specific with real, source-documented follow-through/consistency leniency: the 2025 Scoring Guidelines allow a bar-chart point to be earned "regardless of the signs of either bar" (Q2, Part A3), allow LAB-question graphing points to be earned "independently of the response in part A" (Q3, Part B1), and accept either order of integration limits without penalty. Do not assume a stricter, all-or-nothing grading convention than the sibling packs document for Physics 1 and Physics C: E&M.

### Unit 1 — Kinematics (10-15%)

**1.1 Scalars and Vectors.** Scalars = magnitude only; vectors = magnitude + direction. Unit vector notation: $\vec{r} = A\hat{i} + B\hat{j} + C\hat{k}$; position vector $\vec{r}$ with unit vector $\hat{r}$ in its direction; resultant vector $\vec{C} = \vec{A} + \vec{B} = (A_x+B_x)\hat{i} + (A_y+B_y)\hat{j}$. Zero explicit exclusion statements.

**1.2 Displacement, Velocity, and Acceleration.** $\Delta x = x - x_0$; average velocity $\vec{v}_{avg} = \Delta\vec{x}/\Delta t$; average acceleration $\vec{a}_{avg} = \Delta\vec{v}/\Delta t$. **Instantaneous velocity and acceleration are defined as true derivatives, not as "the limit of the average over a small interval" the way Physics 1 phrases it (verified difference — Physics 1 explicitly avoids derivative notation; this course uses it directly):** $\vec{v} = d\vec{r}/dt$, $v_x = dx/dt$, $\vec{a} = d\vec{v}/dt$, $a_x = dv_x/dt$. EK 1.2.C.2 states directly: "Time-dependent functions and instantaneous values of position, velocity, and acceleration can be determined using differentiation and integration." Zero explicit exclusion statements.

**1.3 Representing Motion.** Constant-acceleration kinematic equations (written in $x$, usable in any single dimension): $v_x=v_{x0}+a_xt$; $x=x_0+v_{x0}t+\tfrac12a_xt^2$; $v_x^2=v_{x0}^2+2a_x(x-x_0)$. Integral (calculus) definitions, not present in Physics 1's treatment of the same topic: $\Delta x = \int_{t_1}^{t_2}v_x(t)\,dt$; $\Delta v_x = \int_{t_1}^{t_2}a_x(t)\,dt$. **Boundary statement (verbatim, shared with Physics C: E&M):** "AP Physics C: Mechanics and AP Physics C: Electricity and Magnetism expects that for all situations in which a numerical quantity is required for $g$, the value $g \approx 10\ m/s^2$ will be used. However, students will not be penalized for correctly using the more precise commonly accepted values of $g=9.81\ m/s^2$ or $g=9.8\ m/s^2$."

**1.4 Reference Frames and Relative Motion.** Choice of frame determines direction/magnitude measured; measurements convert between inertial frames via vector addition/subtraction; acceleration is frame-independent across all inertial frames. **Boundary statement (verbatim): "Unless otherwise stated, the frame of reference of any problem may be assumed to be inertial."** **Verified difference from Physics 1:** Physics 1 carries a *second* boundary statement explicitly restricting relative-velocity vector addition/subtraction "to motion along one dimension." **That restriction does not exist in the Physics C: Mechanics CED page for this topic** — checked directly, no such cap appears. Two-dimensional relative-velocity problems (e.g., a full vector-addition "boat crossing a river" scenario) are therefore in scope for Physics C: Mechanics even though they are out of scope for Physics 1.

**1.5 Motion in Two or Three Dimensions.** Motion in 2D/3D analyzed by separating into 1D components per axis; velocity/acceleration may differ and be nonuniform per dimension; motion in one dimension may change without affecting a perpendicular dimension; projectile motion = zero acceleration in one dimension + constant nonzero acceleration in the other. **Boundary statement (verbatim):** "AP Physics C: Mechanics only expects students to quantitatively analyze the motion of an object in two dimensions. AP Physics C: Electricity and Magnetism expects students to also qualitatively describe the motion of a particle in three dimensions." (I.e., 3D motion is out of scope for a Mechanics-specific item; that's an E&M-course expectation only.)

**Documented misconception/coverage note:** none of the 2025 Chief Reader Report's four FRQs targets Unit 1 content in isolation (Q1=momentum/Unit 4, Q2=oscillations+conservation/Units 3&7, Q3=conservation-of-energy LAB/Unit 3, Q4=rotation+friction/Units 2&5). The released 2026 MC sample-question set (Section "Sample Exam Questions" in the CED itself) does exercise Unit 1 directly — e.g. a graph-interpretation item asking which labeled segments of a velocity-time graph have constant, nonzero acceleration, and a variable-force momentum-change item requiring $\Delta p = \int F(t)\,dt$ — confirming graph-reading and integral-setup are the core Unit 1 exam skills, but there is **no FRQ-level misconception/error-rate evidence for Unit 1** in the sources reviewed this session. Flag this the same way the Physics 1 fact pack flags its own lower-confidence units — the CED content above is fully verified, but there is no Chief-Reader-level student-error data to ground question-writing guidance for this specific unit yet.

### Unit 2 — Force and Translational Dynamics (20-25%)

**2.1 Systems and Center of Mass.** System properties emerge from constituent-object interactions; a system may be treated as a single object if internal structure doesn't matter for the analysis. Discrete center of mass: $\bar{x}_{cm} = \Sigma m_i\bar{x}_i/\Sigma m_i$. **Continuous (calculus) form, not present in Physics 1's treatment of this topic:** $\vec{r}_{cm} = \int \vec{r}\,dm / \int dm$; linear mass density as a derivative, $\lambda = \dfrac{d}{d\ell}m(\ell)$; total mass from a density function via integration over length/area/volume, e.g. $M_{total} = \int \rho(r)\,dV$. **Verified difference from Physics 1:** Physics 1 caps center-of-mass calculation at "systems of five or fewer particles arranged in a two-dimensional configuration, or systems that are highly symmetrical" — **no such numeric cap or boundary statement exists for this Physics C: Mechanics topic** (checked directly, no boundary box on the topic page); continuous, integral-based center-of-mass calculations for arbitrary density distributions are explicitly in scope. Zero explicit exclusion statements.

**2.2 Forces and Free-Body Diagrams.** Forces are vectors describing interactions between objects/systems; an object/system cannot exert net force on itself; contact forces are macroscopic effects of interatomic electric forces; FBDs represent forces as vectors from the center-of-mass dot; choosing an axis parallel to the acceleration direction simplifies analysis. **Boundary statement — same wording as Physics 1, see "General exam-wide conventions" above.**

**2.3 Newton's Third Law.** $\vec{F}_{A\ on\ B} = -\vec{F}_{B\ on\ A}$; internal forces don't affect a system's center-of-mass motion; tension is the macroscopic net result of infinitesimal string-segment interactions responding to an external force. Ideal string: massless, does not stretch under tension, uniform tension throughout. Non-ideal (massive) string: **"tension may not be the same at all points within the string"** — stated as a plain, quantitatively-framed essential-knowledge item (EK 2.3.A.3.iii), not capped to qualitative-only treatment. Ideal pulley: negligible mass, rotates about an axle through its center of mass with negligible friction. **Verified difference from Physics 1:** Physics 1 has a boundary statement explicitly restricting massive-string tension analysis to "qualitative" description only, plus a second boundary statement restricting action-at-a-distance forces to gravity only. **Neither boundary statement appears on this Physics C: Mechanics topic page** — checked directly. Zero explicit exclusion statements.

**2.4 Newton's First Law.** $\Sigma_i\vec{F}_i = 0$ (translational equilibrium, derived equation); velocity constant iff net force is zero; forces may be balanced in one dimension and unbalanced in another, changing velocity only in the unbalanced direction; an inertial frame is one where Newton's first law holds for an observer. Zero explicit exclusion statements.

**2.5 Newton's Second Law.** $\vec{a}_{sys} = \Sigma\vec{F}/m_{sys} = \vec{F}_{net}/m_{sys}$; velocity of a system's center of mass changes only under a nonzero net external force. Zero explicit exclusion statements.

**2.6 Gravitational Force.** $|\vec{F}_g| = Gm_1m_2/r^2$ (always attractive, along the center-of-mass line, treated as acting at the system's center of mass); gravitational field $|\vec{g}| = |\vec{F}_g|/m = GM/r^2$; weight $=F_g=mg$; near Earth's surface $g \approx 10\ N/kg$; apparent weight = normal-force magnitude, $\ne F_g$ under acceleration; weightlessness = zero net force, or gravity as the *only* net force; equivalence principle (observer in a noninertial frame can't distinguish apparent weight from a gravitational field); inertial mass and gravitational mass experimentally verified equivalent. **Newton's shell theorem, presented with a full derivation chain not found anywhere in the Physics 1 fact pack's Unit 2 treatment:** net force outside a thin spherical shell = force from an equivalent point mass at the shell's center; net force inside a thin spherical shell = zero; inside a uniform sphere, only the enclosed partial mass $m_{partial} = \rho\tfrac43\pi(r_{partial})^3$ contributes, giving a derived **linear** restoring-force relation $F_{g,partial} = -kr_{partial}$ — i.e., gravity inside a uniform sphere behaves like a Hooke's-law spring force, a genuine, calculus-course-specific setup for later SHM connections (Unit 7). **Boundary statement (verbatim):** "AP Physics C: Mechanics does not expect students to mathematically prove or derive Newton's shell theorem." (The *result* is examinable; the derivation of the theorem itself is not — though the linear-force-inside-a-sphere *consequence* of the theorem, shown above, is presented as a derived equation the student should be able to use.)

**2.7 Kinetic and Static Friction.** Kinetic friction is an **equality**: $|\vec{F}_{f,k}| = |\mu_k\vec{F}_n|$, independent of contact-surface area, opposing relative sliding motion. Static friction is an **inequality**: $|\vec{F}_{f,s}| \le |\mu_s\vec{F}_n|$, with the slipping threshold as a separate derived equation $F_{f,s,max}=\mu_sF_N$; $\mu_s$ is "typically" (not universally) greater than $\mu_k$. Zero explicit exclusion statements on this topic itself (no banked-curve-friction cap appears under 2.10 either — see below).

**2.8 Spring Forces.** Ideal (massless) spring: Hooke's law $\vec{F}_s = -k\Delta\vec{x}$, directed toward the object-spring-system equilibrium position. Springs in series: $\dfrac{1}{k_{eq,series}} = \Sigma_i\dfrac{1}{k_i} = \dfrac{1}{k_1}+\dfrac{1}{k_2}+\ldots$ (smaller than the smallest constituent constant). Springs in parallel: $k_{eq,parallel} = \Sigma_ik_i = k_1+k_2+\ldots$. **Boundary statement (verbatim):** "AP Physics C: Mechanics only expects students to find the effective spring constant of systems of springs that are arranged either in series or in parallel and does not expect students to find the effective spring constant of a system in which springs are arranged in both series and parallel."

**2.9 Resistive Forces.** **This topic does not exist in AP Physics 1 at all — it is exclusive to the calculus-based Mechanics course and is one of its most differential-equations-heavy topics.** A resistive force is velocity-dependent and opposes the object's velocity, e.g. $\vec{F}_r = -k\vec{v}$. Applying Newton's second law to a resistive-force object yields a **differential equation for velocity**; the method of separation of variables integrates over the proper limits to solve for velocity; position, velocity, and acceleration under a $\vec{F}_r=-k\vec{v}$ resistive force are all **exponential functions of time** with asymptotes set by initial conditions and the forces exerted. Terminal velocity = the maximum speed reached when a constant force and an opposing resistive force are exerted on an object in opposite directions and net force reaches zero. Zero explicit exclusion statements — the full separation-of-variables/exponential-solution treatment is squarely in scope. (The 2026 released FRQ Question 1 confirms this is live exam content: a box-and-cube system decelerating under a resistive force $\vec{F}_R=-b\vec{v}$, requiring a multistep differential-equation derivation for $F_N(t)$ and a critical-time expression $t_{crit}$.)

**2.10 Circular Motion.** $a_c = v^2/r$ (toward the center); tangential acceleration = rate of speed change, tangent to the path; net acceleration = vector sum of centripetal + tangential components; centripetal acceleration may result from one force, multiple forces, or force components (normal + friction components on a banked curve; a tension component on a conical pendulum). Vertical-loop minimum-speed case (gravity alone supplies centripetal force at the top): $v=\sqrt{gr}$ (derived). Uniform circular motion: $T=1/f$; $T=2\pi r/v$ (derived). Orbital period-radius relation (Kepler's third law, circular case): $T^2 = (4\pi^2/GM)R^3$ (derived). **Verified difference from Physics 1:** Physics 1's parallel topic (2.9, folded into the same unit there) carries an explicit boundary statement capping banked-curve-with-friction analysis to qualitative-only. **No such cap appears on this Physics C: Mechanics topic page** — checked directly, page 58 through the Kepler boundary statement on page 60 contains no banked-curve-friction restriction. Quantitative banked-curve-with-friction items are therefore in scope here even though they're out of scope for Physics 1. **Boundary statement (verbatim, the only one on this topic):** "AP Physics C: Mechanics does not expect students to know Kepler's first or second laws of planetary motion."

**Documented misconceptions (2025 Question 3, Experimental Design and Analysis/LAB, "Conservation of Energy," overall mean 6.57/10 — the archetypal Unit-2/3-crossover FRQ):**
- Roughly 80% of responses designed a valid experiment measuring change in height and speed with the specified equipment (meterstick, motion sensor); a meaningful share instead reasoned from concepts not relevant to the given scenario, or proposed measurements the specified equipment couldn't make — the CED's "materials list restriction" pattern already documented for the Physics 1 sibling pack recurs here.
- ~80% either repeated a measurement or proposed a reasonable uncertainty-reduction method — a real, quoted strength.
- **Central, quoted misconception:** "Many responses indicated that velocity rather than velocity squared should be plotted versus height, showing a lack of understanding of the relationship between the quantities in an accelerating system" — a linearization error that recurs across the Physics 1/Physics C family (see also the Physics 1 fact pack's Unit-3 findings on the same skill).
- Responses that explicitly wrote a conservation-of-energy equation with initial gravitational PE and final KE (or PE and work done by friction, in the friction-coefficient part) were **substantially more successful** on the downstream slope-interpretation parts — a direct "write the governing equation before manipulating it" scoring pattern.
- Axis-labeling, units, and best-fit-line mechanics were handled well generally; the recurring failure was **connecting the slope of the best-fit line back to the target physical quantity** ($g$ or $\mu$) rather than the graphing mechanics themselves.

### Unit 3 — Work, Energy, and Power (15-25%)

**3.1 Translational Kinetic Energy.** $K = \tfrac12mv^2$ (scalar); different observers in different reference frames may measure different values of $K$ for the same object. Zero explicit exclusion statements.

**3.2 Work.** Work = energy transferred into/out of a system by a force exerted over a distance. **Calculus (line-integral) definition, absent from Physics 1's treatment of this topic — Physics 1 defines work only via $W=Fd\cos\theta$ for a constant force and never presents a dot-product or integral form:**
$$W = \int_a^b \vec{F}(r)\cdot d\vec{r}, \qquad \vec{A}\cdot\vec{B} = AB\cos\theta$$
For a constant force with constant parallel component: $W = F_\parallel d = Fd\cos\theta$ (derived equation, a special case of the line integral above, not an independent definition the way Physics 1 treats it). Work-energy theorem: $\Delta K = \Sigma_iW_i = \Sigma_iF_{\parallel,i}d_i$. Conservative-force work is path-independent, depends only on initial/final configuration, is zero over a closed loop; potential energy is associated only with conservative forces; nonconservative-force work (friction, air resistance) is path-dependent; friction energy dissipation typically equated to $\Delta E_{mech} = F_fd\cos\theta$; work also equals the area under an $F_\parallel$-vs-displacement graph. **Boundary statement (verbatim):** "AP Physics C: Mechanics only expects students to analyze the transfer of mechanical energy, although students should be aware that mechanical energy may be dissipated in the form of thermal energy or sound."

**3.3 Potential Energy.** PE exists for a system where objects interact only via conservative forces; PE is a scalar tied to configuration; the zero of PE is an observer's choice made for analytical convenience. **Calculus (line-integral and derivative) definitions, both absent from Physics 1's algebra-based treatment of this topic:**
$$\Delta U = -\int_a^b \vec{F}_{cf}(r)\cdot d\vec{r} \qquad F_x = -\frac{dU(x)}{dx}$$
(The second equation is an explicit derivative — Physics 1's parallel EK describes the same relationship only as "using the slope," never as a formal derivative.) Stable equilibrium = local minimum of $U$ in a given dimension (small displacement restores the object); unstable equilibrium = local maximum (small displacement accelerates the object away). Spring PE: $U_s = \tfrac12k(\Delta x)^2$. General (inverse-distance) gravitational PE between two approximately spherical masses: $U_g = -Gm_1m_2/r$. Near-surface approximation: $\Delta U_g = mg\Delta y$. Multi-object system PE = sum over all pairs. Zero explicit exclusion statements.

**3.4 Conservation of Energy.** A single-object system can have only $K$; a system with internally conservative interactions (or reversible shape change) can have both $K$ and $U$; mechanical energy = $K+U$; any energy change within a system is balanced by another internal energy change or a transfer across the system boundary; a system may be chosen so total energy is constant. **Boundary statement (verbatim):** "AP Physics C: Mechanics expects students to know that mechanical energy can be dissipated as thermal energy or sound by nonconservative forces."

**3.5 Power.** Average power: $P_{avg} = \Delta E/\Delta t = W/\Delta t$. **Calculus (derivative) definition of instantaneous power, absent from Physics 1's treatment — Physics 1 only ever gives instantaneous power via a constant force, labeled explicitly as a "derived equation," never as a true derivative:**
$$P_{inst} = \frac{dW}{dt}$$
For the special case of a constant-parallel-component force: $P_{inst} = F_\parallel v = Fv\cos\theta$ (derived equation, a special case of the general derivative form). Zero explicit exclusion statements.

**Documented misconceptions (2025 Question 2, Translation Between Representations, "Conservation Laws and Oscillation," overall mean 7.74/12 — a Unit 2.8/3.3/3.4/7.x crossover item):**
- Most responses correctly sketched energy bar graphs, but a real, documented error pattern was treating **spring PE as signed** (positive or negative depending on whether the spring is stretched vs. compressed) rather than recognizing $U_s=\tfrac12k(\Delta x)^2 \ge 0$ always. A related error: treating the two different springs' energies as equal rather than correctly proportional to their (different) spring constants.
- A significant share of responses either omitted one spring's energy term from the governing conservation-of-energy equation, used the *difference* of the two spring constants rather than their sum, or **treated a parallel spring configuration as if it were in series** — directly reinforcing the series/parallel confusion the Unit 2.8 scope note above already flags as a recurring failure mode across topics.
- Responses that explicitly identified all energy types present in **both** the initial and final states before substituting were "generally successful at the entire derivation" — the same explicit-equation-first pattern documented for Unit 3's Question 3 above.
- On the damped-oscillation kinetic-energy sketch, **fewer than half** of responses correctly represented $K$ as starting at zero and always $\ge 0$; a common, quoted failure was sketching **position or velocity** versus time instead of kinetic energy — a variable-mismatch graphing error, not a conceptual one about damping itself.
- **A specific, quoted mass-dependence misconception:** "Responses identified that increasing the mass of the object would increase the kinetic energy of the object, because the equation for kinetic energy contains mass" — the correct reasoning is that the *system's total energy* is fixed by amplitude (all spring PE at max displacement, independent of the object's mass), so mass alone doesn't change total energy, only how it's partitioned between $K$ and the *period* of oscillation ($T \propto \sqrt{m}$). A second quoted variant: "Responses indicated that increasing the mass of the object would lengthen the time for the energy to dissipate from the system" — contrasted correctly by responses that instead identified the mass-driven *period* increase as the mechanism (per $T=2\pi\sqrt{m/k}$), not a mass-driven change in the friction-dissipation rate itself.

## 6. Units 4-7 deep-tier detail (2026-08-08)

This section deepens Units 4-7 (Linear Momentum; Torque and Rotational Dynamics; Energy and Momentum of Rotating Systems; Oscillations) to the same tier as Section 5 above, using the CED PDF (pages 77-133), the 2025 Chief Reader Report, and the 2025 Scoring Guidelines. **All 7 units of AP Physics C: Mechanics — the full assessed scope of this exam — are now deep tier.** The 2025 FRQ set maps cleanly to these units: Question 1 (Mathematical Routines) = Unit 4 momentum; Question 4 (QQT) = Units 2/5 rotation-and-friction crossover. The 2026 released Question 1 (Unit 2.9 resistive forces) is cited in Section 5 above.

### Cross-unit scoring conventions (Units 4-7 additions to Section 5's list)

- **Follow-through/consistency credit is real and documented across multiple FRQs**, matching the pattern already confirmed for Physics 1 and Physics C: E&M — e.g., the 2025 Q3 LAB question's graphing point (Part B1) "may be earned independently of the response in part A," and the 2025 Q2 bar-chart point (Part A3) "may be earned regardless of the signs of either bar." Do not write rubric criteria that require a *correct* upstream value to be repeated; require *consistency* with the student's own prior answer instead.
- **Integration-mechanics fluency, not conceptual understanding, is the most consistently documented bottleneck across this pass.** The single most dramatic statistic found in this entire session — only 6% of 2025 Q1 responses reached the fully correct final $F_{max}$ expression, with ~85% failing the definite integral itself — recurs in weaker form across Q2 (spring-energy derivations) and Q4 (Newton's-second-law system-of-equations setup). Authoring guidance: items that require a multistep calculus derivation should budget rubric points for the *setup* (recognizing which equation/approach to use) separately from the *execution* (correctly integrating or solving the resulting system), since real exam data shows these are frequently decoupled skills.
- **"Static friction is not automatically at its maximum value" is a real, explicitly-named, high-value misconception** (2025 Q4) — do not author or approve rubric language that implicitly assumes $f_s=\mu_sF_N$ as an equality; the CED itself (topic 2.7) defines static friction as an inequality, $|\vec F_{f,s}|\le|\mu_s\vec F_n|$, and the Chief Reader Report flags exactly this equality-assumption error as a common, documented failure mode.
- **Drawing a free-body or force diagram, even when not explicitly required by the prompt, is documented as correlating with meaningfully better outcomes** (2025 Q4) — worth surfacing as authoring/reviewer guidance parallel to the "extraneous force diagram" misconception families already documented in the Physics 1 sibling pack.



# Subject: AP Physics C: Electricity and Magnetism (subject_key ap_physics_c_em)
Format: Short free-response in AP Physics C style: a setup described fully in words (no diagram). Calculus-based derivations are expected where the topic calls for them; numeric answers carry units.
Parts: 2-4. Criteria (points) in total: 3-5.

## Topics in this subject's Units 8, 9, 10 (stay inside the designated topic)
8.1 Electric Charge and Electric Force (Unit 8: Electric Charges, Fields, and Gauss's Law)
8.2 Conservation of Electric Charge and the Process of Charging (Unit 8: Electric Charges, Fields, and Gauss's Law)
8.3 Electric Fields (Unit 8: Electric Charges, Fields, and Gauss's Law)
8.4 Electric Fields of Charge Distributions (Unit 8: Electric Charges, Fields, and Gauss's Law)
8.5 Electric Flux (Unit 8: Electric Charges, Fields, and Gauss's Law)
8.6 Gauss's Law (Unit 8: Electric Charges, Fields, and Gauss's Law)
9.1 Electric Potential Energy (Unit 9: Electric Potential)
9.2 Electric Potential (Unit 9: Electric Potential)
9.3 Conservation of Electric Energy (Unit 9: Electric Potential)
10.1 Electrostatics with Conductors (Unit 10: Conductors and Capacitors)
10.2 Redistribution of Charge between Conductors (Unit 10: Conductors and Capacitors)
10.3 Capacitors (Unit 10: Conductors and Capacitors)
10.4 Dielectrics (Unit 10: Conductors and Capacitors)

## Targets: write exactly one FRQ for each of these 4 topics

### ap_physics_c_em 10.2 Redistribution of Charge between Conductors (Unit 10: Conductors and Capacitors)
Official CED text (governs):
```
TOPIC 10.2
SUGGESTED SKILLS
1.A
Redistribution of Charge
Between Conductors
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
Required Course Content
Compare physical
quantities between two
or more scenarios or
at different times and
locations in a single
scenario.
2.A
Derive a symbolic
expression from known
quantities by selecting
and following a logical
mathematical pathway.
2.C
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
10.2.A
10.2.A.1
Describe the movement of
charge and the resulting
interactions when
conductors physically
contact each other.
When conductors are in electrical contact,
charges will be redistributed such that the
surfaces of each conductor are at the same
electric potential.
3.B
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
10.2.A.2
Groundisanidealizedreferencepointthat
haszeroelectricpotentialandcanabsorbor
provideaninfiniteamountofchargewithout
changing its electric potential.
10.2.A.3
Charge can be induced on a conductor by
grounding the conductor in the presence of an
externalelectricfield.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.C
Create qualitative sketches
of graphs that represent
features of a model or
the behavior of a physical
system.
Conductors and Capacitors
```

### ap_physics_c_em 8.1 Electric Charge and Electric Force (Unit 8: Electric Charges, Fields, and Gauss's Law)
Official CED text (governs):
```
TOPIC 8.1
SUGGESTED SKILLS
Electric Charge and
Electric Force
Required Course Content
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
2.B
Calculate or estimate an
unknown quantity with units
from known quantities, by
selecting and following
a logical computational
pathway.
2.D
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
8.1.A
8.1.A.1
Describe the electric
force that results from
the interactions between
chargedobjectsorsystems.
Charge is a fundamental property of all matter.
Predict new values or
factors of change of
physical quantities using
functional dependence
between variables.
3.B
8.1.A.1.i
Charge is a scalar quantity and is described
as positive or negative.
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
8.1.A.1.ii
The magnitude of the charge of a single
electron or proton, the elementary charge e,
can be considered to be the smallest
indivisible amount of charge.
8.1.A.1.iii
The charge of an electron is −e and the
charge of a proton is +e, and a neutron has
no electric charge.
8.1.A.1.iv
A point charge is a model in which the
physicalsizeofachargedobjectorsystem
is negligible in the context of the situation
beinganalyzed.
8.1.A.2
Coulomb’s law describes the electrostatic
force between two charged objects as directly
proportional to the magnitude of each of the
charges and inversely proportional to the
square of the distance between the objects.
Relevant equation:
continued on next page
Return to Table of Contents
UNIT
Electric Charges, Fields, and Gauss’s Law
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
8.1.A
8.1.A.3
Describe the electric
force that results from
the interactions between
charged objects or systems.
The direction of the electrostatic force
depends on the signs of the charges of the
interacting objects and is along the line of
separation between the objects.
8.1.A.3.i
Two objects with charges of the same sign
exert repulsive forces on each other.
8.1.A.3.ii
Two objects with charges of opposite signs
exert attractive forces on each other.
8.1.A.4
Electric forces are responsible for some of the
macroscopic properties of objects in everyday
experiences. However, the large number of
particle interactions that occur make it more
convenient to treat everyday forces in terms of
nonfundamental forces called contact forces,
such as normal force, friction, and tension.
8.1.B
8.1.B.1
Describe the electric and
gravitational forces that
result from interactions
between charged objects
withmass.
Electrostatic forces can be attractive or repulsive,
while gravitational forces are always attractive.
8.1.B.2
For any two objects that have mass and
electric charge, the magnitude of the
gravitational force is usually much smaller than
the magnitude of the electrostatic force.
8.1.B.3
Gravitational forces dominate at larger scales
even though they are weaker than electrostatic
forces, because systems at large scales tend
to be electrically neutral.
8.1.C
8.1.C.1
Describe the electric
permittivity of a material or
medium.
Electric permittivity is a measurement of
the degree to which a material or medium is
polarizedinthepresenceofanelectricfield.
8.1.C.2
Electricpolarizationcanbemodeledasthe
induced rearrangement of electrons by an
externalelectricfield,resultinginaseparation
of positive and negative charges within a
material or medium.
8.1.C.3
Free space has a constant value of electric
permittivity, , that appears in physical
relationships.
continued on next page
```

### ap_physics_c_em 8.2 Conservation of Electric Charge and the Process of Charging (Unit 8: Electric Charges, Fields, and Gauss's Law)
Official CED text (governs):
```
TOPIC 8.2
Conservation of
Electric Charge and the
Process of Charging
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
8.2.A
8.2.A.1
Describe the behavior of a
system using conservation of
charge.
The net charge or charge distribution of
a system can change in response to the
presence of, or changes in, the net charge or
charge distribution of other systems.
8.2.A.1.i
The net charge of a system can change due
to friction or contact between systems.
8.2.A.1.ii
Induced charge separation occurs when
the electrostatic force between two
systems alters the distribution of charges
within the systems, resulting in the
polarizationofoneorbothsystems.
8.2.A.1.iii
Induced charge separation can occur in
neutral systems.
8.2.A.2
Any change to a system’s net charge is due to
a transfer of charge between the system and
its surroundings.
8.2.A.2.i
The charging of a system typically involves
the transfer of electrons to and from the
system.
8.2.A.2.ii
The net charge of a system will be constant
unless there is a transfer of charge to or
from the system.
8.2.A.3
Grounding involves electrically connecting
a charged object to a much larger and
approximately neutral system (e.g., Earth).
Return to Table of Contents
UNIT
Electric Charges, Fields, and Gauss’s Law
```

### ap_physics_c_em 8.5 Electric Flux (Unit 8: Electric Charges, Fields, and Gauss's Law)
Official CED text (governs):
```
TOPIC 8.5
Electric Flux
2.A
Derive a symbolic
expression from known
quantities by selecting
and following a logical
mathematical pathway.
2.C
Compare physical
quantities between two
or more scenarios or
at different times and
locations in a single
scenario.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.B
8.5.A
8.5.A.1
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
Describetheelectricflux
through an arbitrary area or
geometric shape.
Flux describes the amount of a given quantity
that passes through a given area.
8.5.A.2

Foranelectricfield E that is constant across

an area A,theelectricfluxthroughtheareais
definedas
8.5.A.2.i
Thedirectionoftheareavectorisdefined
as perpendicular to the plane of the surface
and outward from a closed surface.
8.5.A.2.ii
Thesignoffluxisgivenbythedotproduct
oftheelectricfieldvectorandthearea
vector.
8.5.A.3
Thetotalelectricfluxpassingthrougha
surfaceisdefinedbythesurfaceintegralofthe
electricfieldoverthesurface.
Relevant equation:
Return to Table of Contents
UNIT
Electric Charges, Fields, and Gauss’s Law
```


## AP Physics C: Electricity and Magnetism CED fact pack (course-wide sections and units up to 10)
# AP Physics C: Electricity and Magnetism - CED Fact Pack

Status: Primary-source verified. Use this version for 2026-27 authoring and review. Mirrored into this repo from Google Drive on 2026-08-03 so all subject fact packs live in one place; no content was changed in the move.

## Source control

Source document: College Board, AP Physics C: Electricity and Magnetism Course and Exam Description.

Edition: "Effective Fall 2024," copyright 2026 College Board. David-supplied primary-source PDF, extracted and verified directly.

No local copy of the source PDF exists in this repo's `docs/teaching/` directory as of 2026-08-03 — unlike the Statistics/Precalculus/Calculus/Chemistry fact packs, this one cannot cite a local file path or SHA-256. If the PDF is added to `docs/teaching/`, update this section with its path and hash.

Drive fact-pack source: "AP Physics C E&M 2026-27 — CED Fact Pack (v2, primary source, use this one)", file ID `1AwMAtwpUj798kRROyz4O8q9w36YubauEeB7122mrJM0`, created 2026-07-23.

**2026-08-08 deep-tier update, Units 8-10.** David supplied the full primary-source CED PDF directly (`ap-physics-c-electricity-and-magnetism-course-and-exam-description.pdf`, "Effective Fall 2024," 189 pages) for the first time — this is the first Physics subject to move off bare tier. Brought Units 8-10 to deep tier using that PDF (pages 21-58, read directly) plus the 2025 Scoring Guidelines, 2025 Chief Reader Report, 2025/2026 released FRQs, and the 2025 Q1 Sample Student Responses and Scoring Commentary booklet. Units 11-13 (Circuits, Magnetic Fields, Electromagnetic Induction) remained bare tier as of this update — that pass was scoped to ground a Units 8/9/10 authoring batch, not a full six-unit rebuild. See the "Units 8-10 deep-tier detail" section below.

**2026-08-08 deep-tier update, Units 11-13 (same day, second pass).** Extended the same treatment to the remaining three units using the same primary-source CED PDF (pages 66-116: Unit 11 pp. 66-79, Unit 12 pp. 81-94, Unit 13 pp. 95-109, read directly) plus the 2025 Scoring Guidelines, 2025 Chief Reader Report, and the 2025 Q2 Sample Student Responses and Scoring Commentary booklet (Q2 = electromagnetic induction / Unit 13). The 2025 FRQ set conveniently maps one question per unit cluster (Q1 = Units 8-10, Q2 = Unit 13, Q3 = Unit 11, Q4 = Unit 12), and the released 2026 Q1 (Unit 12, Ampère's law with nonuniform current density) was also checked for current framing. **All 6 units of Physics C: Electricity and Magnetism (8-13) — the full assessed scope of this exam — are now deep tier.** See the new "Units 11-13 deep-tier detail" section below.

This replaces the earlier fact pack (© 2019 edition). Core content scope is essentially unchanged, but **units have been renumbered from 1-5 to 8-13** (continuing the sequence from Physics C: Mechanics' 7 units), and Electrostatics has been split into two units instead of one.

**Calculus-based course** — use derivatives/integrals where appropriate (e.g., Gauss's law via flux integrals, capacitor energy via ∫(q/C)dq).

## 1. Exam structure

- Same format as Physics C: Mechanics — FRQ types: Mathematical Routines, Translation Between Representations, Experimental Design and Analysis, Qualitative/Quantitative Translation.
- 40 multiple-choice questions (50% of E&M score) + FRQ section (50%).

## 2. Units and MC exam weighting (verified, primary source, current edition)

| Unit | Title | MC Weighting |
|---|---|---|
| 8 | Electric Charges, Fields, and Gauss's Law | 15-25% |
| 9 | Electric Potential | 10-20% |
| 10 | Conductors and Capacitors | 10-15% |
| 11 | Electric Circuits | 15-25% |
| 12 | Magnetic Fields and Electromagnetism | 10-20% |
| 13 | Electromagnetic Induction | 10-20% |

**6 units total, numbered 8-13** (not 1-5 as in the old edition). No standalone "Electrostatics" unit anymore — it's split into Unit 8 (charge, fields, Gauss's law) and Unit 9 (potential). Content coverage itself is essentially the same as the old 5-unit version; this is a renumbering/regrouping, not new or removed topics, as far as the primary-source pass could verify.

## 3. Topic map (verified from primary source, current edition)

Unit 8 (Electric Charges, Fields, and Gauss's Law): 8.1 Electric Charge and Electric Force, 8.2 Conservation of Electric Charge and the Charge Distribution, 8.3 Electric Fields, 8.4 Electric Fields of Charge Distributions, 8.5 Electric Flux, 8.6 Gauss's Law

Unit 9 (Electric Potential): 9.1 Electric Potential Energy, 9.2 Electric Potential, 9.3 Conservation of Electric Energy

Unit 10 (Conductors and Capacitors): 10.1 Electrostatics with Conductors, 10.2 Redistribution of Charge Between Conductors, 10.3 Capacitors, 10.4 Dielectrics

Unit 11 (Electric Circuits): 11.1 Electric Current, 11.2 Simple Circuits, 11.3 Resistance, Resistivity, and Ohm's Law, 11.4 Electric Power, 11.5 Compound Direct Current Circuits, 11.6 Kirchhoff's Loop Rule, 11.7 Kirchhoff's Junction Rule, 11.8 Resistor-Capacitor (RC) Circuits

Unit 12 (Magnetic Fields and Electromagnetism): 12.1 Magnetic Fields, 12.2 Magnetism and Moving Charges, 12.3 Magnetic Fields of Current-Carrying Wires, 12.4 Ampère's Law

Unit 13 (Electromagnetic Induction): 13.1 Magnetic Flux, 13.2 Electromagnetic Induction, 13.3 Induced Currents and Magnetic Forces, 13.4 Inductance, 13.5 Circuits with Resistors and Inductors, 13.6 Circuits with Capacitors and Inductors

## Units 8-10 deep-tier detail (2026-08-08 addition)

Verified directly against the CED PDF (pages 21-58) plus the 2025 Scoring Guidelines, Chief Reader Report, and Q1 Sample Student Responses booklet. Unlike the bare topic-title list this pack previously had, most topics here do carry real boxed exclusion statements — Physics C: E&M's CED is more exclusion-explicit than Calculus's, closer to Chemistry's density.

### Unit 8 — Electric Charges, Fields, and Gauss's Law (15-25%)

*Exclusion, boxed and verbatim (topic 8.1):* "AP Physics C: Electricity & Magnetism only expects students to make calculations of the electric force between four or fewer interacting charged objects or systems. The analysis of the resulting electric force from more charges is allowed in situations of high symmetry." Do not author a direct-Coulomb's-law-summation item with 5+ discrete point charges unless the configuration has high symmetry (in which case it belongs to 8.4/8.6 instead).

*Exclusion, boxed and verbatim (topic 8.4, calculus-based field derivation):* "AP Physics C: Electricity & Magnetism only expects students to use calculus to find the electric field resulting from the following charge distributions and locations: an infinitely long, uniformly charged wire or cylinder at a distance from its central axis, a thin ring of charge at a location along the axis of the ring, a semicircular arc or part of a semicircular arc at its center, and a finite wire or line charge at a point collinear with the line charge or at a location along its perpendicular bisector." Five geometries only — do not author a calculus-based field-derivation FRQ for any other shape (e.g. a full disk, a non-uniform arc, a general 2D distribution).

*Exclusion, boxed and verbatim (topic 8.6, Gauss's law):* "AP Physics C: Electricity & Magnetism only expects students to quantitatively apply Gauss's law to point charges and charge distributions that have spherical, cylindrical, or planar symmetry." No other symmetry is fair game for a Gauss's-law FRQ.

*Key formulas confirmed:* Coulomb's law `|F_E| = (1/4πε₀)(|q₁q₂|/r²) = k|q₁q₂|/r²`; field definition `E⃗ = F⃗_E/q`; field via superposition/integration `E⃗ = (1/4πε₀)∫(dq/r²)r̂`; flux `Φ_E = E⃗·A⃗` (uniform) and `Φ_E = ∫E⃗·dA⃗` (general); Gauss's law `∮E⃗·dA⃗ = q_enc/ε₀`; charge from density `Q_total = ∫ρ(r⃗)dV` (and by extension `∫λ dl`, `∫σ dA` for 1D/2D, though only the volume form is explicitly typeset in the CED).

*Real, highest-value documented error pattern (2025 Q1 Part A, Gauss's law for a coaxial cylindrical shell — the single lowest-scoring setup in the Units 8-10 exam content, mean scores A2=0.40, A3=0.34 vs. A1=0.80):* students correctly write the Gauss's-law equation (`∮E⃗·dA⃗=q_enc/ε₀`, easy point) but then fail on the two application points. Specific, quotable, real wrong substitutions from the Chief Reader Report: `∮dA = πr²` or `∮dA = 4πr²` (treating a cylindrical Gaussian surface like a disk or sphere, instead of the correct curved lateral area `2πrl`); using the Gaussian surface's variable radius r instead of the shell's actual radius R₁ when computing enclosed charge (`q_enc = σ₁(2πrl)` instead of the correct `σ₁(2πR₁l)`); conflating charge density types (`q_enc=σ₁` alone, or `q_enc=ρV`, confusing surface density σ with volume density ρ). All four are real, graded, documented errors — strong material for MCQ distractors or FRQ near-miss rubric language.

*Real, explicitly-flagged wrong methodology:* a "significant number" of 2025 responses abandoned Gauss's law entirely and tried direct `E=k∫dq/r²` point-charge-style integration for the cylindrical problem — the Chief Reader Report states this models spherical symmetry and "the calculus required to model cylindrical symmetry is beyond the scope of the course." Do not accept a rubric criterion that credits this approach for a cylindrical/planar Gauss's-law item.

*Graph-sketching nuance (2025 Q1 Part A(iii), sketching E(r) for a cylindrical shell pair):* scored leniently on endpoint precision — "the curve does not have to intersect the vertical dashed lines to earn this point," only the correct shape/trend (zero outside the shells, decreasing-and-concave-up i.e. 1/r-shaped between them) is graded. Documented wrong sketches, all real: flat/constant field in the middle region, an increasing (backwards) curve, a linear ramp, or nonzero decreasing field in the regions that should read zero.

### Unit 9 — Electric Potential (10-20%)

*Exclusion, boxed and verbatim (topic 9.2, calculus-based potential derivation) — same five geometries as Unit 8's field exclusion, applied to potential instead:* "AP Physics C: Electricity & Magnetism only expects students to use calculus to find the electric potential resulting from the following charge distributions and locations: an infinitely long, uniformly charged wire or cylinder at a distance from its central axis, a thin ring of charge at a location along the axis of the ring, a semicircular arc or part of a semicircular arc at its center, and a finite wire or line charge at a point collinear with the line charge or at a location along its perpendicular bisector."

*Key formulas confirmed:* potential energy of a pair `U_E = (1/4πε₀)(q₁q₂/r) = kq₁q₂/r`; potential via superposition/integration `V = (1/4πε₀)∫(dq/r)`; point-charge potential `V = q/(4πε₀r)`; multi-charge superposition `V = (1/4πε₀)Σ(qᵢ/rᵢ)`; potential difference `ΔV = ΔU_E/q`; field-potential relationship `E_x = -dV/dx` and `ΔV = V_b - V_a = -∫[a→b]E⃗·dr⃗`; energy change `ΔU_E = qΔV` (topic 9.3).

*Real scoring architecture, confirmed from 2025 Q1 Part A(ii) (deriving ΔV from a previously-derived E(r)):* the substitution-into-the-integral point and the correct-integration-limits point are scored **separately**, and both carry explicit leniency: "vector notation is not required" and "the sign of ΔV is not considered" for the substitution point; the limits-of-integration point "may be earned regardless of the order of the limits" (R₁→R₂ or R₂→R₁ both count, as long as the correct pair of radii is used). **Explicit follow-through/consistency credit confirmed**: real graded responses that got the upstream E(r) wrong (Unit 8 Gauss's-law error) still earned both ΔV-integral points by correctly carrying their own (wrong) E(r) through the integration mechanics — an incorrect earlier answer, applied correctly downstream, still earns credit.

*Documented misconception directly reusable for a "vector vs. scalar superposition" contrast item:* E-field superposition is vector addition (magnitude and direction both matter); potential superposition is scalar addition (no direction). The 2026 Q2 FRQ (no official scoring guide yet, but confirms current item-writing framing) explicitly contrasts these — Part A asks for direction of net E⃗ (vector), Part C/D ask about V (scalar, magnitude/shape only) from the same two-rod configuration.

### Unit 10 — Conductors and Capacitors (10-15%)

*Exclusion, boxed and verbatim (topic 10.3, capacitor geometries):* "While other shapes are also able to separate charges, AP Physics C: Electricity & Magnetism only expects the quantitative analysis and description of parallel-plate capacitors, concentric spherical capacitors, and coaxial cylindrical capacitors." Three geometries only.

*Confirmed NOT in this unit's scope: series/parallel capacitor-combination rules.* Checked directly — no combination formulas appear anywhere in topics 10.1-10.4. That content belongs to Unit 11 (Electric Circuits), not here; do not author a capacitor-network item under a Unit 10 tag.

*Conductor electrostatics, confirmed qualitative/no-equation topic (10.1):* excess charge resides entirely on the surface; field inside a conductor in electrostatic equilibrium is zero; field is perpendicular to the surface; the whole conductor is an equipotential surface; charge density is higher at points/edges than planar areas; electrostatic shielding (Faraday cage) works by this mechanism. No formulas are given for this topic — it is tested conceptually.

*Key formulas confirmed:* capacitance `C = Q/ΔV`; parallel-plate capacitance `C = κε₀A/d`; field between parallel plates (small-separation limit, via Gauss's law) `E = Q/(ε₀A)`; energy stored `U_C = ½QΔV`; dielectric constant `κ = ε/ε₀`; field reduction with dielectric `κ = E₀/E`; capacitance increase with dielectric `C = κC₀`. Dielectrics (topic 10.4) require only the qualitative polarization mechanism and these three relational equations — **no microscopic/molecular-dipole derivation is in scope**.

*Real, single-most-costly documented error in the entire Units 8-10 exam content (2025 Q1 Part B, capacitance of a coaxial cylindrical capacitor with a dielectric — the lowest-scoring part of the exam, means B1=0.26, B2=0.21, B3=0.19, roughly a quarter of students earning any of these three points):* per the Chief Reader Report verbatim, "a significant number of responses simply used the equation for parallel plate capacitance, `C = κε₀A/d`, as provided on the reference sheet... The use of this equation indicates a lack of understanding of the different geometries studied in electrostatics." A real documented wrong substitution: force-fitting cylindrical dimensions into the flat-plate formula, `C = κε₀(2πR₂L − 2πR₁L)/(R₂−R₁)`. The correct approach is always to re-derive `C=Q/ΔV` from the geometry's actual Q and ΔV expressions (e.g. reuse the Unit 9 cylindrical ΔV derivation), never to reach for the parallel-plate formula by default. **This is the single highest-value trap for MCQ distractor design or FRQ rubric near-miss language anywhere in Units 8-10** — offering `C=κε₀A/d` as a bait answer for any non-parallel-plate geometry is a real, high-frequency, officially documented failure mode, not a hypothetical one.

### Cross-unit scoring conventions confirmed from the 2025 Scoring Guidelines and FRQ booklets (apply across Units 8-10)

- **"Vector notation is not required" is a standing, explicitly repeated rule** for derivation/setup points (confirmed on both the Gauss's-law equation point and the ΔV-substitution point) — even though the underlying physics is vectorial, writing the scalar magnitude form does not cost credit at the setup stage.
- **Follow-through/consistency credit is real and confirmed across multiple points**: a wrong upstream value (e.g. an incorrect E(r) from a botched Gauss's-law application), carried through correctly in a later part, still earns that later part's points. Do not write FRQ criteria that require the *correct* upstream numeric value to be repeated — require *consistency* with the student's own prior answer instead.
- **Two-step derivations should be graded as separate visible steps, not one collapsed line**: the Chief Reader Report explicitly advises teachers "not to integrate and make substitutions of the limits of integration in the same step" — graders want substitution and evaluation shown separately.
- **General front-matter rule, verbatim, from the FRQ booklet directions:** "All final numerical answers should include appropriate units when applicable. Credit for your work depends on demonstrating that you know which physical principles to apply in a particular situation... you should show your work for each part in the space provided for that part."
- **2026-dated policy tightening, worth using for "current" framing:** 2026 added explicit scratch-paper exclusion language not present in 2025 — "You may use the available paper for scratch work and planning, but only work written in the free-response booklet will be scored. Any work done on scratch paper will not be scored."

## Units 11-13 deep-tier detail (2026-08-08 addition)

Verified directly against the CED PDF (pages 66-116: Unit 11 pp. 66-79, Unit 12 pp. 81-94, Unit 13 pp. 95-109) plus the 2025 Scoring Guidelines, Chief Reader Report, and the 2025 Q2 Sample Student Responses and Scoring Commentary booklet (Q2 = electromagnetic induction, i.e. Unit 13). The 2025 FRQ set maps cleanly one-question-per-unit-cluster: Q1 = Units 8-10 (already covered above), Q2 = Unit 13 (rotating-loop induction), Q3 = Unit 11 (LAB question, resistivity of a cylindrical resistor), Q4 = Unit 12 (QQT question, magnetic fields/forces from current-carrying wires). The 2026 released Q1 (Unit 12, Ampère's law with a nonuniform current density) is also cited below for current framing, consistent with how the Units 8-10 section cited 2026 Q2.

### Cross-unit scoring conventions confirmed from the 2025 Scoring Guidelines and Chief Reader Report (apply across Units 11-13)

- **The Units 8-10 "vector notation is not required" rule is reconfirmed for Unit 12** (Biot-Savart/Ampère's-law derivation points) and **extended with a sign-convention analogue for Unit 13** ("the negative sign does not have to be present" for Faraday's-law setup points). Setup/derivation-stage leniency on vectors and signs is a standing pattern across all six units checked so far, not unit-specific.
- **LAB-question points can be earned independently across parts, not just within a single derivation**, confirmed by Q3 Part B1's explicit note ("This point may be earned independently of the response in part A"). This generalizes the Units 8-10 follow-through/consistency principle to cross-part independence specifically within the Experimental Design and Analysis (LAB) question type.
- **Multiple valid justification paths can earn the same point (OR-scoring)**, confirmed by Q4 Part C2, which awards credit for *either* explicitly computing the new field expression *or* simply "indicating that the net magnitude of the magnetic field at the location of Sphere 2 will remain the same even though the field from Wire T will change" — a fully qualitative justification earns full credit alongside a quantitative one.
- **"Measure" vs. "calculate" is a graded distinction, confirmed as a real, named error category** in LAB questions (Unit 11's Q3): stating a directly-measured quantity was "calculated," or vice versa, costs credit even when the physics is otherwise correct. Authoring LAB-type items should preserve this precise-verb requirement in rubric language.
- **Graph-sketch points are graded as separable sub-criteria** (shape, cycle count, and extrema-matching each independently gradable, per Q2 Part C's three separate points and the Part C scoring note above), not as a single holistic "is this the right graph" judgment — consistent with, and reinforcing, the analogous Units 8-10 finding for the cylindrical-shell E(r) sketch.

## 4. Authoring/review guidance

- If any existing `apphycem-*` content or tags reference "Unit 1-5" numbering, they need to be re-mapped to the current 8-13 numbering (content itself is very likely still valid; it's the unit/topic tags that need updating).
- Confirm capacitor energy derivations use the calculus form (∫(q/C)dq = Q²/2C).
- Confirm Ampère's law / Biot-Savart content lives in Unit 12 (Magnetic Fields and Electromagnetism), not misfiled under Unit 13 (Electromagnetic Induction, which is induction/RL/RC/LC circuits).

