# FRQ writing brief: physics1_biology

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


# Subject: AP Physics 1 (subject_key ap_physics_1)
Format: Short free-response in AP Physics style: a physical setup described fully in words (no diagram). Parts ask for symbolic derivations, numeric calculations with units, or claims justified with physics principles.
Parts: 2-4. Criteria (points) in total: 3-5.

## Topics in this subject's Units 1, 2, 3 (stay inside the designated topic)
1.1 Scalars and Vectors in One Dimension (Unit 1: Kinematics)
1.2 Displacement, Velocity, and Acceleration (Unit 1: Kinematics)
1.3 Representing Motion (Unit 1: Kinematics)
1.4 Reference Frames and Relative Motion (Unit 1: Kinematics)
1.5 Vectors and Motion in Two Dimensions (Unit 1: Kinematics)
2.1 Systems and Center of Mass (Unit 2: Force and Translational Dynamics)
2.2 Forces and Free-Body Diagrams (Unit 2: Force and Translational Dynamics)
2.3 Newton's Third Law (Unit 2: Force and Translational Dynamics)
2.4 Newton's First Law (Unit 2: Force and Translational Dynamics)
2.5 Newton's Second Law (Unit 2: Force and Translational Dynamics)
2.6 Gravitational Force (Unit 2: Force and Translational Dynamics)
2.7 Kinetic and Static Friction (Unit 2: Force and Translational Dynamics)
2.8 Spring Forces (Unit 2: Force and Translational Dynamics)
2.9 Circular Motion (Unit 2: Force and Translational Dynamics)
3.1 Translational Kinetic Energy (Unit 3: Work, Energy, and Power)
3.2 Work (Unit 3: Work, Energy, and Power)
3.3 Potential Energy (Unit 3: Work, Energy, and Power)
3.4 Conservation of Energy (Unit 3: Work, Energy, and Power)
3.5 Power (Unit 3: Work, Energy, and Power)

## Targets: write exactly one FRQ for each of these 8 topics

### ap_physics_1 1.1 Scalars and Vectors in One Dimension (Unit 1: Kinematics)
Official CED text (governs):
```
TOPIC 1.1
SUGGESTED SKILLS
Scalars and Vectors
in One Dimension
Required Course Content
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
2.C
Compare physical
quantities between two
or more scenarios or
atdifferenttimesand
locations in a single
scenario.
3.B
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.1.A
1.1.A.1
Describe a scalar or vector
quantity using magnitude and
direction, as appropriate.
Scalars are quantities described by magnitude
only; vectors are quantities described by both
magnitude and direction.
1.1.A.2
Apply an appropriate law,
definition,theoretical
relationship, or model to
make a claim.
3.C
Justify or support a claim
using evidence from
experimental data, physical
representations, or physical
principles or laws.
Vectors can be visually modeled as arrows with
appropriate direction and lengths proportional
to their magnitude.
1.1.A.3
Distance and speed are examples of scalar
quantities, while position, displacement,
velocity, and acceleration are examples of
vector quantities.
1.1.A.3.i
Vectors are notated with an arrow above
the symbol for that quantity.
Relevant equation:
 

v = v 0 + at
1.1.A.3.ii
Vector notation is not required for
vector components along an axis. In one
dimension, the sign of the component
completely describes the direction of that
component.
Derived equation:
v x = v x 0 + ax t
1.1.B
1.1.B.1
Describe a vector sum in one
dimension.
When determining a vector sum in a given
one-dimensionalcoordinatesystem,opposite
directions are denoted by opposite signs.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.C
Create qualitative sketches
of graphs that represent
features of a model or
the behavior of a physical
system.
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
or more scenarios or
atdifferenttimesand
locations in a single
scenario.
3.C
Justify or support a claim
using evidence from
experimental data, physical
representations, or physical
principles or laws.
Kinematics
```

### ap_physics_1 2.1 Systems and Center of Mass (Unit 2: Force and Translational Dynamics)
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
For systems with symmetrical mass
distributions, the center of mass is located on
lines of symmetry.
2.1.B.2
The location of a system’s center of mass
along a given axis can be calculated using the
equation
2.1.B.3
A system can be modeled as a singular object
that is located at the system’s center of mass.
BOUNDARY STATEMENT
AP Physics 1 only expects students to calculate the center of mass for systems of
fiveorfewerparticlesarrangedinatwo-dimensionalconfigurationorforsystems
that are highly symmetrical.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
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
Compare physical
quantities between two
or more scenarios or
atdifferenttimesand
locations in a single
scenario.
3.C
Justify or support a claim
using evidence from
experimental data, physical
representations, or physical
principles or laws.
Force and Translational Dynamics
```

### ap_physics_1 2.2 Forces and Free-Body Diagrams (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.2
Forces and
Free-Body Diagrams
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.2.A
2.2.A.1
Describe a force as an
interaction between two
objects or systems.
Forces are vector quantities that describe the
interactions between objects or systems.
2.2.A.1.i
A force exerted on an object or system is
always due to the interaction of that object
with another object or system.
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
by the environment.
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
on an object using a freebody diagram.
A coordinate system with one axis parallel to
the direction of acceleration of the object or
systemsimplifiesthetranslationfromfreebody diagram to algebraic representation. For
example,inafree-bodydiagramofanobject
on an inclined plane, it is useful to set one axis
parallel to the surface of the incline.
BOUNDARY STATEMENT
AP Physics 1 only expects students to depict the forces exerted on objects, not
theforcecomponentsonfree-bodydiagrams.OntheAPPhysicsexams,individual
forcesrepresentedonafree-bodydiagrammustbedrawnasindividualstraight
arrows, originating on the dot and pointing in the direction of the force. Individual
forces that are in the same direction must be drawn side by side, not overlapping.
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

### ap_physics_1 2.3 Newton's Third Law (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.3
Newton’s Third Law
2.D
Predict new values or
factors of change of
physical quantities using
functional dependence
between variables.
3.B
Apply an appropriate law,
definition,theoretical
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
Describe the interaction of
two objects using Newton’s
third law and a representation
of paired forces exerted on
each object.
Newton’s third law describes the interaction of
two objects in terms of the paired forces that
each exerts on the other.
-→
-→
F A on B = −F B on A
2.3.A.2
Interactions between objects within a system
(internal forces) do not influence the motion of
a system’s center of mass.
2.3.A.3
Tension is the macroscopic net result of forces
that segments of a string, cable, chain, or
similar system exert on each other in response
to an external force.
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
continued on next page
Return to Table of Contents
Force and Translational Dynamics
LEARNING OBJECTIVE
UNIT
ESSENTIAL KNOWLEDGE
2.3.A
Describe the interaction of
two objects using Newton’s
third law and a representation
of paired forces exerted on
each object.
BOUNDARY STATEMENT
AP Physics 1 only expects students to describe tension qualitatively in a string,
cable, chain, or similar system with mass. For example, students might note that the
tension in a hanging chain is greater toward the top of the chain.
BOUNDARY STATEMENT
The interaction between objects or systems at a distance is limited to gravitational
forces in AP Physics 1. In AP Physics 2, gravitational, electric, and magnetic forces
may be considered.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.C
Create qualitative sketches
of graphs that represent
features of a model or
the behavior of a physical
system.
Force and Translational Dynamics
```

### ap_physics_1 2.4 Newton's First Law (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.4
Newton’s First Law
2.A
Derive a symbolic
expression from known
quantities by selecting
and following a logical
mathematical pathway.
3.B
Apply an appropriate law,
definition,theoretical
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
2.4.A
2.4.A.1
Describe the conditions
under which a system’s
velocity remains constant.
The net force on a system is the vector sum of
all forces exerted on the system.
2.4.A.2
Translationalequilibriumisaconfigurationof
forces such that the net force exerted on a
systemiszero.
Derived equation:
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
Force and Translational Dynamics
```

### ap_physics_1 2.6 Gravitational Force (Unit 2: Force and Translational Dynamics)
Official CED text (governs):
```
TOPIC 2.6
Gravitational Force
2.A
Derive a symbolic
expression from known
quantities by selecting
and following a logical
mathematical pathway.
2.D
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
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.6.A
2.6.A.1
Describe the gravitational
interaction between two
objects or systems with
mass.
Newton’s law of universal gravitation describes
the gravitational force between two objects
or systems as directly proportional to each of
their masses and inversely proportional to the
square of the distance between the systems’
centers of mass.
Relevant equation:
-mm
Fg = G
r2
2.6.A.1.i
The gravitational force is attractive.
2.6.A.1.ii
The gravitational force is always exerted
along the line connecting the centers of
mass of the two interacting systems.
2.6.A.1.iii
The gravitational force on a system can be
considered to be exerted on the system’s
center of mass.
2.6.A.2
Afieldmodelstheeffectsofanoncontact
force exerted on an object at various positions
in space.
2.6.A.2.i
Themagnitudeofthegravitationalfield
created by a system of mass M at a
point in space is equal to the ratio of the
gravitational force exerted by the system
on a test object of mass m to the mass of
the test object.
continued on next page
Return to Table of Contents
UNIT
Force and Translational Dynamics
LEARNING OBJECTIVE
2.6.A
Describe the gravitational
interaction between two
objects with mass.
ESSENTIAL KNOWLEDGE
Derived equation:
--Fg
M
g =
=G 2
m
r
2.6.A.2.ii
If the gravitational force is the only force
exerted on an object, the observed
acceleration of the object (in m/s2) is
numerically equal to the magnitude of the
gravitationalfieldstrength(inN/kg)atthat
location.
2.6.A.3
The gravitational force exerted by an
astronomical body on a relatively small nearby
object is called weight.
Derived Equation:
Weight = Fg = mg
2.6.B
Describe situations in which
the gravitational force can be
considered constant.
2.6.B.1
If the gravitational force between two systems’
centers of mass has a negligible change as the
relative position of the two systems changes,
the gravitational force can be considered
constant at all points between the initial and
finalpositionsofthesystems.
2.6.B.2
Near the surface of Earth, the strength of the
gravitationalfieldis g
10 N/kg
2.6.C
2.6.C.1
Describe the conditions
under which the magnitude of
a system’s apparent weight is
differentfromthemagnitude
of the gravitational force
exerted on that system.
The magnitude of the apparent weight of a
system is the magnitude of the normal force
exerted on the system.
2.6.C.2
If the system is accelerating, the apparent weight
of the system is not equal to the magnitude of
the gravitational force exerted on the system.
2.6.C.3
A system appears weightless when there are no
forces exerted on the system or when the force
of gravity is the only force exerted on the system.
2.6.C.4
The equivalence principle states that an
observer in a noninertial reference frame is
```

### ap_physics_1 3.1 Translational Kinetic Energy (Unit 3: Work, Energy, and Power)
Official CED text (governs):
```
TOPIC 3.1
SUGGESTED SKILLS
Translational
Kinetic Energy
1.C
Create qualitative sketches
of graphs that represent
features of a model or
the behavior of a physical
system.
2.B
Calculate or estimate an
unknown quantity with units
from known quantities, by
selecting and following
a logical computational
pathway.
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
K=
1 2
mv
Apply an appropriate law,
definition,theoretical
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
1.B
Create quantitative graphs
with appropriate scales
and units, including plotting
data.
Work, Energy, and Power
```

### ap_physics_1 3.3 Potential Energy (Unit 3: Work, Energy, and Power)
Official CED text (governs):
```
TOPIC 3.3
SUGGESTED SKILLS
1.C
Potential Energy
Create qualitative sketches
of graphs that represent
features of a model or
the behavior of a physical
system.
2.C
Compare physical
quantities between two
or more scenarios or
atdifferenttimesand
locations in a single
scenario.
Required Course Content
LEARNING OBJECTIVE
2.D
ESSENTIAL KNOWLEDGE
3.3.A
3.3.A.1
Describe the potential energy
of a system.
A system composed of two or more objects
has potential energy if the objects within that
system only interact with each other through
conservative forces.
3.3.A.2
Predict new values or
factors of change of
physical quantities using
functional dependence
between variables.
3.B
Apply an appropriate law,
definition,theoretical
relationship, or model to
make a claim.
Potential energy is a scalar quantity associated
with the position of objects within a system.
3.3.A.3
Thedefinitionofzeropotentialenergyfor
a given system is a decision made by the
observer considering the situation to simplify
or otherwise assist in analysis.
3.3.A.4
The potential energy of common physical
systems can be described using the physical
properties of that system.
3.3.A.4.i
The elastic potential energy of an ideal
spring is given by the following equation,
where
is the distance the spring has
been stretched or compressed from its
equilibrium length.
Relevant equation:
continued on next page
Return to Table of Contents
UNIT
Work, Energy, and Power
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.3.A
3.3.A.4.ii
Describe the potential energy
of a system.
The general form for the gravitational
potential energy of a system consisting of
two approximately spherical distributions of
mass (e.g., moons, planets or stars) is given
by the equation
U g = −G
m1m2
r
3.3.A.4.iii
Becausethegravitationalfieldnearthe
surface of a planet is nearly constant, the
change in gravitational potential energy in
a system consisting of an object with mass
mandaplanetwithgravitationalfieldof
magnitude g when the object is near the
surface of the planet may be approximated
by the equation
3.3.A.5
The total potential energy of a system
containing more than two objects is the sum
of the potential energy of each pair of objects
within the system.
Return to Table of Contents
UNIT
Work, Energy, and Power
```


## AP Physics 1 CED fact pack (course-wide sections and units up to 3)
# AP Physics 1: Algebra-Based - CED Fact Pack

Status: Primary-source verified. Use this version for 2026-27 authoring and review. Mirrored into this repo from Google Drive on 2026-08-03 so all subject fact packs live in one place; no content was changed in the move.

## Source control

Source document: College Board, AP Physics 1: Algebra-Based Course and Exam Description.

Edition: "Effective Fall 2024," copyright 2026 College Board. David-supplied primary-source PDF, extracted and verified directly (not a web-search summary).

No local copy of the source PDF exists in this repo's `docs/teaching/` directory as of 2026-08-03 — unlike the Statistics/Precalculus/Calculus/Chemistry fact packs, this one cannot cite a local file path or SHA-256. If the PDF is added to `docs/teaching/`, update this section with its path and hash.

**2026-08-08 deep-tier update, Units 4-8 (this session, continuing the same-day Units 1-3 pass):**
David supplied the same primary-source set already used for Units 1-3 — the full
220-page CED PDF plus the 2024 Chief Reader Report, 2024 Scoring Guidelines,
2024 Q1/Q2 Sample Student Responses and Scoring Commentary booklets, and the
2024 and 2026 released FRQ booklets — and this pass extracts the required
course content (LO/EK text, exact equations, verbatim boundary statements) for
Units 4-8 (Linear Momentum; Torque and Rotational Dynamics; Energy and
Momentum of Rotating Systems; Oscillations; Fluids) directly from CED pages
78-138, plus every 2024/2026 FRQ, scoring guideline, and Chief-Reader-Report
passage that touches those units' content (Questions 2, 3, 4, and 5 of the
2024 exam; the momentum and rotational-inertia items of the 2026 released FRQ
booklet). **All 8 units of AP Physics 1 are now deep tier** — this is the
full assessed scope of the course. The one confirmed gap: Unit 8 (Fluids) has
zero FRQ-level misconception/scoring data in any of the four sources reviewed
this session (see Unit 8 detail below) — the CED content for that unit is
solid, but there is no released-exam evidence yet to ground question-writing
guidance beyond the CED itself.

Drive fact-pack source (superseded/authoritative history):
- **v3 (current, this document):** "AP Physics 1 2026-27 — CED Fact Pack (v3, primary source Fall 2024, use this one)", file ID `1WTHwHrJujEuBzAXsL92zQdnHXlE-cvgsArE_FOVdR1g`, created 2026-07-24.
- v2 (superseded — Fall 2021 edition, now out of date): "AP Physics 1 2026-27 — CED Fact Pack (v2 - use this one)", file ID `1Ac-GXgNblqwxjXWfE98FhIZ-huxsyNw_p3RIrKfPYLI`.

This replaces the earlier fact pack (Fall 2021 edition), which is now significantly out of date. Physics 1 was substantially restructured for 2024-25: it now has 8 units (was 7), the unit names/order were rewritten to closely mirror Physics C: Mechanics' structure, and **Fluids was added as a new Unit 8** — this is the same Fluids content that was removed from AP Physics 2 (confirming the earlier hypothesis from the Physics 2 recheck: Fluids moved from Physics 2 to Physics 1, it wasn't simply cut).

## 1. Exam structure

- 3 hours, hybrid digital exam (Bluebook + handwritten FRQ booklets).
- Algebra-based (no calculus).
- FRQ types (now match the same 4 archetypes used across the whole Physics C/1 family): Mathematical Routines, Translation Between Representations, Experimental Design and Analysis, Qualitative/Quantitative Translation.

## 2. Units and MC exam weighting (verified, primary source, current edition)

| Unit | Title | MC Weighting |
|---|---|---|
| 1 | Kinematics | 10-15% |
| 2 | Force and Translational Dynamics | 18-23% |
| 3 | Work, Energy, and Power | 18-23% |
| 4 | Linear Momentum | 10-15% |
| 5 | Torque and Rotational Dynamics | 10-15% |
| 6 | Energy and Momentum of Rotating Systems | 5-8% |
| 7 | Oscillations | 5-8% |
| 8 | Fluids | 10-15% |

**8 units total.** No more "Circular Motion and Gravitation" as its own unit (old Unit 3) — circular motion content is folded into Unit 2 (Force and Translational Dynamics, topic 2.9), and orbital/gravitation content lives in Unit 6 (topic 6.6, "Motion of Orbiting Satellites") — **exactly mirroring the Physics C: Mechanics structure already documented in that fact pack.** Rotation is likewise split across two units (5 and 6), matching Physics C: Mechanics.

## 3. Topic map (verified from primary source, current edition)

Unit 1 (Kinematics): 1.1 Scalars and Vectors in One Dimension, 1.2 Displacement, Velocity, and Acceleration, 1.3 Representing Motion, 1.4 Reference Frames and Relative Motion, 1.5 Vectors and Motion in Two Dimensions

Unit 2 (Force and Translational Dynamics): 2.1 Systems and Center of Mass, 2.2 Forces and Free-Body Diagrams, 2.3 Newton's Third Law, 2.4 Newton's First Law, 2.5 Newton's Second Law, 2.6 Gravitational Force, 2.7 Kinetic and Static Friction, 2.8 Spring Forces, 2.9 Circular Motion

Unit 3 (Work, Energy, and Power): 3.1 Translational Kinetic Energy, 3.2 Work, 3.3 Potential Energy, 3.4 Conservation of Energy, 3.5 Power

Unit 4 (Linear Momentum): 4.1 Linear Momentum, 4.2 Change in Momentum and Impulse, 4.3 Conservation of Linear Momentum, 4.4 Elastic and Inelastic Collisions

Unit 5 (Torque and Rotational Dynamics): 5.1 Rotational Kinematics, 5.2 Connecting Linear and Rotational Motion, 5.3 Torque, 5.4 Rotational Inertia, 5.5 Rotational Equilibrium and Newton's First Law in Rotational Form, 5.6 Newton's Second Law in Rotational Form

Unit 6 (Energy and Momentum of Rotating Systems): 6.1 Rotational Kinetic Energy, 6.2 Torque and Work, 6.3 Angular Momentum and Angular Impulse, 6.4 Conservation of Angular Momentum, 6.5 Rolling, 6.6 Motion of Orbiting Satellites (gravitation/orbital content lives here, not a standalone unit)

Unit 7 (Oscillations): 7.1 Defining Simple Harmonic Motion (SHM), 7.2 Frequency and Period of SHM, 7.3 Representing and Analyzing SHM, 7.4 Energy of Simple Harmonic Oscillators

Unit 8 (Fluids): 8.1 Internal Structure and Density, 8.2 Pressure, 8.3 Fluids and Newton's Laws, 8.4 Fluids and Conservation Laws

## 4. Authoring/review guidance

- Do not author or approve any Physics 1 content under a standalone "Circular Motion and Gravitation" unit label — it doesn't exist anymore. Circular motion belongs under Unit 2 (topic 2.9); orbital/gravitation belongs under Unit 6 (topic 6.6).
- Any existing `apphy1-*` content referencing the old 7-unit structure (esp. old Unit 3 "Circular Motion and Gravitation," old Unit 6 "Simple Harmonic Motion," old Unit 7 "Torque and Rotational Motion") needs to be re-mapped to the current 8-unit/topic numbering.
- **New authoring scope: Physics 1 now covers Fluids (Unit 8).** If Cramapple has zero `apphy1-*` fluids content today, that's a real content gap now that Fluids lives here instead of (or in addition to) Physics 2.
- Algebra-based only — no calculus notation.
- This course's unit structure, topic numbering, and FRQ archetypes are now essentially parallel to Physics C: Mechanics (algebra-based version of the same skeleton) — cross-reference that fact pack when in doubt about topic placement, since the two courses are now structured the same way.

## 5. Units 1-3 deep-tier detail (2026-08-08)

David supplied the full 220-page primary-source CED PDF for the first time this
session (previously this fact pack was topic-map/weighting only). This section
deepens Units 1-3 to the same tier as Biology/Chemistry: per-topic LO/EK text,
verbatim exclusion/boundary statements (or an explicit "zero found" where none
exist), exact equations with symbol conventions, and real scoring/misconception
signal from the 2024 Scoring Guidelines, Chief Reader Report, and Q1/Q2 Sample
Student Responses booklets. Units 4-8 were deepened to the same tier in a
same-day follow-up pass — see Section 6.

### General exam-wide conventions (apply to every FRQ, not just Units 1-3)
- Positive work is defined as work done **on** a system.
- Free-body-diagram convention: each force is a distinct straight arrow
  **starting on, and pointing away from,** the dot representing the object/
  system's center of mass; forces in the same direction are drawn side by
  side, never overlapping/stacked.
- Accepted force labels are specific: gravity accepts $F_G, F_g, F_{grav}, W,
  mg$ — **"G" or "g" alone is explicitly NOT acceptable.** Normal force
  accepts $F_n, F_N, N$; tension accepts $F_T, F_s$ (spring), etc.
- $g = 10\ m/s^2$ is used for all numeric problems; students are **not**
  penalized for using $9.8$ or $9.81\ m/s^2$ instead.
- Credit is part-specific and often carries follow-through/error-carried-
  forward credit — a wrong earlier substitution does not zero out a later,
  internally-consistent part (verified directly in a real 5/7-scored Q1
  sample response: wrong height substitution, but full downstream
  qualitative-reasoning credit still earned).

### Unit 1 — Kinematics (10-15%)

**1.1 Scalars and Vectors in One Dimension.** Vectors carry an arrow
($\vec{v}$); vector notation is *not* required for a signed one-dimensional
component ($v_x$) — sign alone conveys direction. Zero explicit exclusion
statements.

**1.2 Displacement/Velocity/Acceleration.** $\Delta x = x - x_0$;
$\vec{v}_{avg} = \Delta\vec{x}/\Delta t$; $\vec{a}_{avg} = \Delta\vec{v}/\Delta t$.
Instantaneous velocity/acceleration are defined as the limit of the average
over a *very small* time interval — **never via a derivative**; no derivative
notation appears anywhere in this course. Zero explicit exclusion statements
(the algebra-based framing is implicit, not stated as an exclusion).

**1.3 Representing Motion.** Constant-acceleration kinematic equations (in
any single dimension, written in $x$):
$$v_x = v_{x0}+a_xt \qquad x=x_0+v_{x0}t+\tfrac12a_xt^2 \qquad v_x^2=v_{x0}^2+2a_x(x-x_0)$$
Graphical relationships: instantaneous velocity = slope of the position-time
tangent; instantaneous acceleration = slope of the velocity-time tangent;
displacement = area under a velocity-time graph; change in velocity = area
under an acceleration-time graph.
**Boundary statement (verbatim):** "AP Physics 1 does not expect students to
quantitatively analyze nonuniform acceleration. However, students will be
expected to be able to qualitatively analyze, sketch appropriate graphs of,
and discuss situations in which acceleration is nonuniform." — i.e. the three
kinematic equations above apply to constant-acceleration cases only; a
nonuniform-acceleration item may only be graphical/qualitative.
**Boundary statement #2 (verbatim):** "For all situations in which a
numerical quantity is required for g, the value g = 10 m/s² will be used.
However, students will not be penalized for correctly using the more precise
commonly accepted values of g = 9.81 m/s² or g = 9.8 m/s²."

**1.4 Reference Frames and Relative Motion.** Acceleration is frame-
independent across all inertial reference frames; velocity is not (it
combines object velocity + observer-frame velocity via vector addition/
subtraction). **Boundary statement (verbatim):** "Unless otherwise stated,
the frame of reference of any problem may be assumed to be inertial. Adding
or subtracting vectors to find relative velocities is restricted to motion
along one dimension for AP Physics 1." — 2-D relative-velocity problems
(e.g. "boat crossing a river" vector addition) are **out of scope**.

**1.5 Vectors and Motion in Two Dimensions.** Standard right-triangle
resolution: $\sin\theta=a/c$, $\cos\theta=b/c$, $\tan\theta=a/b$,
$a^2+b^2=c^2$. Projectile motion = zero acceleration in one dimension +
constant nonzero acceleration in the other; solved by separating into 1-D
kinematics per axis. Zero explicit exclusion statements on this topic itself
(the 1.4 restriction to 1-D relative motion is the only nearby scope cap, not
repeated here).

**Documented misconception (2026 released FRQ, projectile item):**
qualitative reasoning is scored as a *separate, distinct* requirement from
the mathematical derivation — "include qualitative reasoning beyond
mathematical derivations" is an explicit, separately-graded instruction, not
boilerplate. A second 2026 item requires linearizing $v^2$ vs. $d$ data from
a friction-ramp experiment to extract $\mu_k$ from the slope — a real
Experimental-Design-and-Analysis pattern worth mirroring.

### Unit 2 — Force and Translational Dynamics (18-23%)

**2.1 Systems and Center of Mass.** $\bar{x}_{cm} = \Sigma m_i\bar{x}_i /
\Sigma m_i$. **Boundary statement (verbatim):** "AP Physics 1 only expects
students to calculate the center of mass for systems of five or fewer
particles arranged in a two-dimensional configuration or for systems that
are highly symmetrical."

**2.2 Forces and Free-Body Diagrams.** Forces are vectors originating from
the object's center-of-mass dot; a coordinate axis should be chosen parallel
to the acceleration direction. **Boundary statement (verbatim):** "AP
Physics 1 only expects students to depict the forces exerted on objects, not
the force components on free-body diagrams." (Component-decomposed FBDs are
out of scope — draw whole force vectors only.)

**2.3 Newton's Third Law.** $\vec{F}_{A\ on\ B} = -\vec{F}_{B\ on\ A}$;
internal forces don't affect a system's center-of-mass motion. Ideal string:
massless, inextensible, uniform tension throughout; non-ideal (massive)
string: tension may vary along its length. **Boundary statements (verbatim,
two):** (1) "AP Physics 1 only expects students to describe tension
qualitatively in a string, cable, chain, or similar system with mass." (2)
"The interaction between objects or systems at a distance is limited to
gravitational forces in AP Physics 1. In AP Physics 2, gravitational,
electric, and magnetic forces may be considered." — action-at-a-distance
items must be gravity-only.

**2.4 Newton's First Law.** $\Sigma_i\vec{F}_i = 0$ (equilibrium); velocity
constant iff net force zero; forces can be balanced in one dimension and
unbalanced in another. Zero explicit exclusion statements.

**2.5 Newton's Second Law.** $\vec{a}_{sys} = \Sigma\vec{F}/m_{sys} =
\vec{F}_{net}/m_{sys}$. Zero explicit exclusion statements.

**2.6 Gravitational Force.** $|\vec{F}_g| = Gm_1m_2/r^2$ (always attractive,
acts along the center-of-mass line); gravitational field
$|\vec{g}| = |\vec{F}_g|/m = GM/r^2$; weight $=F_g=mg$; near Earth's surface
$g=10\ N/kg$. Apparent weight = normal force magnitude, which is $\ne
F_g$ under acceleration; "weightless" = zero net force or gravity-only net
force. Equivalence principle: an observer in a noninertial frame can't
distinguish apparent weight from a gravitational field. Zero explicit
exclusion statements in this topic.

**2.7 Kinetic and Static Friction.** Kinetic friction is an **equality**:
$|\vec{F}_{f,k}| = |\mu_k\vec{F}_n|$ — independent of contact-surface area.
Static friction is an **inequality**: $|\vec{F}_{f,s}| \le |\mu_s\vec{F}_n|$,
with the slipping threshold as a separate derived equation
$F_{f,s,max} = \mu_sF_n$. $\mu_s$ is "typically" (not universally) greater
than $\mu_k$. Zero explicit exclusion statements on this topic (the only
friction-scope cap is under 2.9, banked curves).

**2.8 Spring Forces.** Ideal spring (massless): Hooke's law
$\vec{F}_s = -k\Delta\vec{x}$, directed toward the spring-system equilibrium
position. Zero explicit exclusion statements.

**2.9 Circular Motion.** $a_c = v^2/r$ (toward center); tangential
acceleration = rate of speed change, tangent to the path; net acceleration =
vector sum of centripetal + tangential. Only **uniform** circular motion
(constant speed) gets period/frequency treatment: $T=1/f$,
$T=2\pi r/v$. Vertical-loop minimum speed (gravity alone supplies centripetal
force at the top): $v=\sqrt{gr}$. Banked curves and conical pendulums:
normal-force/tension components can supply centripetal force. Orbital
period-radius relation (Kepler's third law, circular case only):
$T^2 = (4\pi^2/GM)R^3$. **Boundary statements (verbatim, two):** (1) "AP
Physics 1 only expects students to quantitatively analyze banked curves in
which no friction is required to maintain uniform circular motion. Analysis
of situations in which friction is required on a banked curve is limited to
qualitative descriptions." (2) "AP Physics 1 does not expect students to know
Kepler's first or second laws of planetary motion."

**Documented misconception (2024 Chief Reader Report, Q1 vertical-loop FBD):
only ~50% of students correctly drew the normal force pointing *downward* at
the top of a vertical loop** — the single strongest documented Unit 2 error
in this research pass; students default to "normal force points up" from
flat-surface habit. Other documented errors: drawing an illegitimate extra
"net centripetal force" vector on an FBD (centripetal force is not a
distinct force, it's the net result); labeling non-force quantities
(friction, "KE," "momentum") as if they were forces on an FBD; miscalculating
vertical-loop height as $3R$ instead of $4R$ (loop diameter, not radius, from
bottom to top); believing mechanical energy "decreases" on a frictionless
loop. Gravitation (CED 2.6): documented misuse of $g=F_g/m$ backward,
concluding more planetary mass *lowers* $g$, and confusing mass with weight
across different planets.

### Unit 3 — Work, Energy, and Power (18-23%)

**3.1 Translational Kinetic Energy.** $K=\tfrac12mv^2$ (scalar; frame-
dependent — different observers can measure different $K$ for the same
object). Zero explicit exclusion statements.

**3.2 Work.** Work is scalar, signed. For a **constant** force only:
$W=F_\parallel d = Fd\cos\theta$ — **never presented as a dot product**, and
never given an integral/calculus treatment; the only nod to variable-force
work is graphical: "work is equal to the area under the curve of $F_\parallel$
vs. displacement." Work-energy theorem: $\Delta K=\Sigma_iW_i=\Sigma_iF_{\parallel,i}d$.
Conservative-force work is path-independent, depends only on initial/final
configuration, and is exactly zero over a closed loop; potential energy
exists *only* for conservative forces; nonconservative-force work is
path-dependent (friction, air resistance named as the examples).
**Boundary statement (verbatim):** "AP Physics 1 only expects students to
analyze the transfer of mechanical energy... although students should be
aware that mechanical energy may be dissipated in the form of thermal energy
or sound."

**3.3 Potential Energy.** Zero of PE is an observer's choice, not fixed.
Spring: $U_s=\tfrac12k(\Delta x)^2$. General (inverse-square) gravitational
PE between two spherical masses: $U_g=-Gm_1m_2/r$. Near-surface
**approximation** of that general form (explicitly labeled an approximation,
not an independent formula): $\Delta U_g = mg\Delta y$. Multi-object system
PE = sum over all pairs. Zero explicit exclusion statements.

**3.4 Conservation of Energy.** A single-object system can only have $K$
(never $U$); a system needs internally-conservative interactions (or
reversible shape change) to have both $K$ and $U$. Mechanical energy =
$K+U$; any energy change within a system is balanced by another internal
energy change or a transfer across the system boundary. **Boundary statement
(verbatim, framed as inclusion not exclusion):** "AP Physics 1 expects
students to know that mechanical energy can be dissipated as thermal energy
or sound by nonconservative forces."

**3.5 Power.** $P_{avg}=\Delta E/\Delta t = W/\Delta t$. Instantaneous power
for a **constant** force parallel component: $P_{inst}=F_\parallel v =
Fv\cos\theta$ (explicitly labeled a *derived* equation) — no treatment given
for instantaneous power under a time-varying force/velocity. Zero explicit
exclusion statements.

**Documented misconceptions/scoring patterns (2024 Q1 energy-bar-chart FRQ,
Chief Reader Report + Q1/Q2 Sample Responses):**
- Default 50/50 KE/$U_g$ energy split regardless of the scenario's actual
  height ratio — the most common bar-chart error, despite ~90% of students
  getting *total*-energy conservation conceptually right.
- $\Delta K = \tfrac12m(\Delta v)^2$ used instead of the correct
  $\Delta K=\tfrac12m\,\Delta(v^2)$ — a recurring algebra error, not a
  conceptual one.
- A real 2/7-scored response invoked $W=Fd\cos\theta$ and $P=\Delta E/\Delta t$
  in place of conservation of energy (0 pts on the derivation), mislabeled a
  normal-force arrow as "$F_f$" on a *frictionless* track (an "extraneous
  vector" FBD error, same family as the Unit 2 loop misconception), and lost
  qualitative credit for a bare, unjustified assertion.
- Point-earning is precise and part-specific: "a correct response with no
  supporting work earns this point only" for some points; "the unit and the
  negative sign are not required to earn this point" for others — do not
  assume a blanket units/sign requirement across all criteria.

## 6. Units 4-8 deep-tier detail (2026-08-08 addition)

This section deepens Units 4-8 (Linear Momentum; Torque and Rotational
Dynamics; Energy and Momentum of Rotating Systems; Oscillations; Fluids) to
the same tier as Units 1-3 above, using the same primary sources: the full
CED PDF (pages 78-138 for these five units), the 2024 Chief Reader Report,
the 2024 Scoring Guidelines, the 2024 Q1/Q2 Sample Student Responses and
Scoring Commentary booklets, and the 2024 and 2026 released FRQ booklets.
Every equation, LO/EK claim, and boundary statement below was read directly
from the CED pages cited; every misconception/scoring claim was read directly
from the named 2024/2026 source, not inferred. **Correction to prior content:**
none found — the Section 3 topic map and Section 2 weighting table for Units
4-8 both check out exactly against the primary source (topic numbering,
titles, and MC weighting all verified page-by-page below).

**Confirmed source-coverage gap:** the 2024 Chief Reader Report, 2024 Scoring
Guidelines, 2024 Q1/Q2 Sample Response booklets, and both the 2024 and 2026
released FRQ booklets were grepped in full for "fluid," "buoyant,"
"Bernoulli," "density," and "pressure." None of the four sources contain a
Fluids FRQ. Unit 8's CED content (equations, boundary statement) below is
solid and primary-source-verified, but there is currently **no released-exam
misconception or scoring-pattern evidence** to ground Fluids question-writing
the way the Chief Reader Report grounds Units 4-7 — flagged explicitly, the
same way the Calculus fact pack flags its Unit 7 Differential Equations
coverage as lower-confidence.

### Cross-unit scoring conventions (Units 4-8 additions to Section 5's list)

- **Functional-dependence points can be earned even when applied
  incorrectly**, as long as an attempt is made to connect it to prior
  reasoning — 2024 Q3 scoring note, verbatim: "The functional dependance
  does not need to be used correctly to earn this point." This is a distinct,
  explicit convention not covered by the Units 1-3 pass and should inform how
  strictly "connect your claim to your derivation"-style rubric items are
  graded/authored.
- **Vector-diagram convention extends beyond force diagrams to momentum
  vectors.** The Units 1-3 FBD convention ("each force is a distinct arrow
  starting on, and pointing away from, the object/system dot") is restated
  verbatim for momentum-vector diagrams in the 2026 released FRQ: "Each
  arrow must start on, and point away from, each dot." Treat this as a
  general Physics 1 vector-diagram convention, not FBD-specific.
- **Torque and angular momentum are both magnitude-only vector quantities in
  this course.** AP Physics 1 expects students to mathematically manipulate
  the *magnitude* of both torque (5.3 boundary statement) and angular
  momentum/angular impulse (6.3 boundary statement) using one-dimensional
  (signed, CW/CCW) conventions; true vector direction (e.g., right-hand-rule
  cross products) is explicitly out of scope for both quantities — a
  consistent pattern across Units 5 and 6, not an isolated exclusion.
- **Multi-feature graphs are scored in separate point buckets per feature.**
  The 2024 Q3(e) angular-speed-vs-time sketch awards one point for
  "monotonically increasing" and a separate point for "concave down" —
  confirming, with a rotational-motion example, the same piecewise
  graph-scoring pattern already documented for Units 1-3 (e.g., the vertical-
  loop energy bar chart).



# Subject: AP Biology (subject_key ap_biology)
Format: Short free-response in AP Biology style: a scenario or experiment described in words, with any data as a small plain-text table. Parts use AP task verbs (identify, describe, explain, predict, justify, calculate).
Parts: 3-4. Criteria (points) in total: 4-5.

Accepted item from this subject in this batch (style reference only):
```json
{
 "title": "Base Composition and Structure of Nucleic Acid Samples",
 "calculator": "not_permitted",
 "stimulus": "A research team isolates nucleic acid from three different viruses. Some viruses carry DNA and others carry RNA as their genetic material, and the genetic material may be single-stranded or double-stranded. The team measures the percentage of each nitrogenous base in each sample. A dash (—) means the base was not detected.\n\nSample | %A | %T | %G | %C | %U\n1 | 30 | 30 | 20 | 20 | —\n2 | 25 | 33 | 24 | 18 | —\n3 | 22 | — | 30 | 20 | 28\n\nThe team also studies a short segment of one DNA strand with the sequence 5′-ATGCCA-3′.",
 "model_answer": "(a) Sample 3 is RNA. It contains uracil (28%) and no thymine. RNA contains the base uracil, while DNA contains thymine, so Samples 1 and 2 (which contain thymine) are DNA.\n\n(b) In double-stranded DNA, C pairs with G and A pairs with T, so %C = %G = 18%. G + C = 36%, so A + T = 100% − 36% = 64%. Since %A = %T, adenine = 64% ÷ 2 = 32%.\n\n(c) Sample 2 is not double-stranded; it is single-stranded DNA. In double-stranded DNA every A is hydrogen-bonded to a T and every C to a G, so %A would equal %T and %G would equal %C. In Sample 2, A is 25% but T is 33%, and G is 24% but C is 18%, so the bases are not paired in complementary strands.\n\n(d) (i) The complementary strand is 5′-TGGCAT-3′ (aligned with the given strand it reads 3′-TACGGT-5′), because A pairs with T, G pairs with C, and the two strands run antiparallel.\n(ii) A new nucleotide would be added to the 3′ end of the strand, which has a hydroxyl (–OH) group on the sugar; the new nucleotide forms a covalent bond there.",
 "verification_python": "from fractions import Fraction\nsamples={1:{'A':30,'T':30,'G':20,'C':20,'U':0},2:{'A':25,'T':33,'G':24,'C':18,'U':0},3:{'A':22,'T':0,'G':30,'C':20,'U':28}}\nfor s in samples.values():\n    assert sum(s.values())==100\nrna=[k for k,v in samples.items() if v['U']>0 and v['T']==0]\nassert rna==[3]\nassert samples[1]['A']==samples[1]['T'] and samples[1]['G']==samples[1]['C']\nassert samples[2]['A']!=samples[2]['T'] and samples[2]['G']!=samples[2]['C']\nG=18;C=G;at=100-(G+C);assert at==64\nA=Fraction(at,2);assert A==32\nseq='ATGCCA'\ncomp={'A':'T','T':'A','G':'C','C':'G'}\naligned=''.join(comp[b] for b in seq)\nassert aligned=='TACGGT'\nassert aligned[::-1]=='TGGCAT'\nprint('ALL_CHECKS_PASSED')",
 "parts": [
  {
   "prompt": "Identify which sample (1, 2, or 3) is RNA, and justify your answer using a structural difference between DNA and RNA shown in the data.",
   "criteria": [
    {
     "text": "Identifies Sample 3 as RNA because it contains uracil and no thymine.",
     "evidence": "Names Sample 3 and justifies with the presence of uracil (U) in place of thymine (T), since RNA contains uracil while DNA contains thymine.",
     "fix": "Remember RNA contains uracil instead of thymine; look for the sample with U present and T absent.",
     "accepted_variants": [
      "contains U instead of T",
      "uracil replaces thymine"
     ]
    }
   ]
  },
  {
   "prompt": "A fourth virus is found to have double-stranded DNA in which 18% of the bases are guanine. Calculate the percentage of bases in this DNA that are adenine. Show your work.",
   "criteria": [
    {
     "text": "Calculates adenine = 32% using complementary base pairing.",
     "evidence": "Shows C = G = 18%, so G + C = 36%; A + T = 100 − 36 = 64%; A = T, so A = 64 ÷ 2 = 32%.",
     "fix": "In double-stranded DNA set C equal to G and A equal to T, subtract G + C from 100, then halve.",
     "accepted_variants": [
      "32%",
      "0.32",
      "32 percent"
     ]
    }
   ]
  },
  {
   "prompt": "Make a claim about whether the DNA in Sample 2 is double-stranded, and justify your claim using the data.",
   "criteria": [
    {
     "text": "Claims Sample 2 is not double-stranded (single-stranded) because A does not equal T and G does not equal C.",
     "evidence": "States Sample 2 is single-stranded (not double-stranded) and cites that %A (25) ≠ %T (33) and/or %G (24) ≠ %C (18), whereas complementary pairing in a double strand would make these equal.",
     "fix": "Compare %A with %T and %G with %C; double-stranded DNA pairs A–T and C–G, so those percentages must match.",
     "accepted_variants": [
      "single-stranded",
      "not double-stranded"
     ]
    }
   ]
  },
  {
   "prompt": "For the DNA segment 5′-ATGCCA-3′: (i) write the sequence of the complementary strand, labeled with its 5′ and 3′ ends, and (ii) identify the end of the given strand (5′ or 3′) to which a new nucleotide would be added if the strand were being extended, and name the chemical group found at that end.",
   "criteria": [
    {
     "text": "Writes the antiparallel complementary strand 5′-TGGCAT-3′.",
     "evidence": "Gives 5′-TGGCAT-3′, or equivalently 3′-TACGGT-5′ aligned under the given strand, with correct base pairing (A–T, C–G) and opposite orientation.",
     "fix": "Pair each base (A with T, G with C), then remember strands are antiparallel; read the new strand 5′ to 3′.",
     "accepted_variants": [
      "5′-TGGCAT-3′",
      "3′-TACGGT-5′"
     ]
    },
    {
     "text": "Identifies the 3′ end, which has a hydroxyl (–OH) group, as the end where new nucleotides are added.",
     "evidence": "States nucleotides are added to the 3′ end and names the hydroxyl group of the sugar at that end.",
     "fix": "Recall nucleic acid synthesis adds nucleotides only to the 3′ end, defined by the sugar's 3′ hydroxyl group.",
     "accepted_variants": [
      "3′ hydroxyl",
      "3′ OH end"
     ]
    }
   ]
  }
 ]
}
```

## Topics in this subject's Units 1, 2, 3 (stay inside the designated topic)
1.1 Structure of Water and Hydrogen Bonding (Unit 1: Chemistry of Life)
1.2 Elements of Life (Unit 1: Chemistry of Life)
1.3 Introduction to Macromolecules (Unit 1: Chemistry of Life)
1.4 Carbohydrates (Unit 1: Chemistry of Life)
1.5 Lipids (Unit 1: Chemistry of Life)
1.6 Nucleic Acids (Unit 1: Chemistry of Life)
1.7 Proteins (Unit 1: Chemistry of Life)
2.1 Cell Structure and Function (Unit 2: Cells)
2.10 Origins of Cell Compartmentalization (Unit 2: Cells)
2.2 Cell Size (Unit 2: Cells)
2.3 Plasma Membrane (Unit 2: Cells)
2.4 Membrane Permeability (Unit 2: Cells)
2.5 Membrane Transport (Unit 2: Cells)
2.6 Facilitated Diffusion (Unit 2: Cells)
2.7 Tonicity and Osmoregulation (Unit 2: Cells)
2.8 Mechanisms of Transport (Unit 2: Cells)
2.9 Cell Compartmentalization (Unit 2: Cells)
3.1 Enzymes (Unit 3: Cellular Energetics)
3.2 Environmental Impacts on Enzyme Function (Unit 3: Cellular Energetics)
3.3 Cellular Energy (Unit 3: Cellular Energetics)
3.4 Photosynthesis (Unit 3: Cellular Energetics)
3.5 Cellular Respiration (Unit 3: Cellular Energetics)

## Targets: write exactly one FRQ for each of these 8 topics

### ap_biology 1.2 Elements of Life (Unit 1: Chemistry of Life)
Official CED text (governs):
```
TOPIC 1.2
SUGGESTED SKILL
Elements of Life
Visual
Representations
2.A
Describe characteristics
of visual representations
of biological concepts and
processes.
Required Course Content
BIG IDEA 2
Energetics: Biological systems use energy and molecular building blocks to grow,
reproduce, and maintain dynamic homeostasis.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.2.A
1.2.A.1
Describe the composition of
macromolecules required by
living organisms.
Atoms and molecules from the environment
are necessary to build new molecules. Carbon,
hydrogen, and oxygen are the most prevalent
elements used to build biological molecules
such as carbohydrates, proteins, lipids, and
nucleic acids. Additionally:
i.Sulfurisusedinthebuildingofproteins.
ii. Phosphorus is used in the building of
phospholipids (a type of lipid) and nucleic
acids.
iii. Nitrogen is used in the building of nucleic
acids.
Return to Table of Contents
UNIT
SUGGESTED SKILL
Visual
Representations
2.A
Describe characteristics
of visual representations
of biological concepts and
processes.
AVAILABLE RESOURCE
You can find related
resources below in the
Online Teacher Community.
§ VisualizingInformation
Chemistry of Life
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Part (b), criterion b1: The accepted variants '9000 cpm' and '9.0 × 10³ cpm' are bare values, although the part explicitly requires showing work. These variants must include an equivalent calculation.
- gpt-6.1-sol: accurate: Part (d), criterion d2: The accepted statement 'carbon forms the backbone of all biological molecules' is overbroad. Not all biologically relevant molecules contain carbon. Restrict the statement to the three macromolecule types listed.
- deepseek-v4-pro: rubric_points: Part (a) criterion a1 combines two separate observable elements—identifying the protein fraction and explaining sulfur's use in proteins—into one 1-point criterion; each criterion should award one specific element.
- deepseek-v4-pro: rubric_evidence: Part (a) criterion a1 requires explaining that sulfur is not typically in nucleic acids or phospholipids, but the Evidence only asks for naming proteins and stating sulfur builds proteins; the Fix also omits the absence part, so an incomplete 
- gpt-6.1-sol: on_topic: Although most points assess elemental composition, full credit requires later content: a1 requires sulfur-containing amino acids (Topic 1.7), and b1 requires nucleotide phosphate groups (Topic 1.6) and membrane phospholipids (later cell topics). Thes
- gpt-6.1-sol: rubric_points: Criterion a1 combines identifying the fraction and explaining sulfur incorporation into one point. Criterion b1 combines two independently assessable explanations—labeling nucleic acids and labeling phospholipids—into one point. Each criterion m

### ap_biology 1.4 Carbohydrates (Unit 1: Chemistry of Life)
Official CED text (governs):
```
TOPIC 1.4
SUGGESTED SKILL
Carbohydrates
Required Course Content
Concept Explanation
1.A
Describe biological
concepts and processes.
ILLUSTRATIVE EXAMPLES
EK 1.4.A.1
§ Cellulose
§ Starch
BIG IDEA 4
Systems Interactions: Biological systems interact, and these systems and their
interactions exhibit complex properties.
LEARNING OBJECTIVE
§ Glycogen
ESSENTIAL KNOWLEDGE
1.4.A
1.4.A.1
Describe the structure and
function of carbohydrates.
Monosaccharides (simple sugars) are the
monomers for polysaccharides (complex
carbohydrates). These monomers are
connected by covalent bonds to form polymers
such as complex carbohydrates, which may be
linear or branched.
X EXCLUSION STATEMENT—The molecular
structure of specific carbohydrate polymers is
beyond the scope of the AP Exam.
Return to Table of Contents
UNIT
SUGGESTED SKILL
Argumentation
6.E
Predict the causes or effects
of a change in, or disruption
to, one or more components
in a biological system.
Chemistry of Life
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: well_posed: Part (d) does not establish exactly equal glucose yields. Equal polymer masses need not contain exactly equal numbers of glucose units if their average chain lengths differ. State that end-group mass differences are negligible, or specify equal num
- gpt-6.1-sol: rubric_points: Criterion d2 requires the unsupported assertion that equal masses contain the same number of glucose units. A correct justification of approximately equal yields that acknowledges end-group differences need not satisfy this requirement.
- gpt-6.1-sol: rubric_points: Criterion a1 bundles identification of the monomer with description of the bond and synthesis reaction into one point. Criterion c1 bundles two separately requested release-rate calculations and a rate-ratio calculation into one point. These cri
- deepseek-v4-pro: rubric_points: Part (a) criterion a1 bundles three independent required elements—naming glucose/monosaccharide, stating a covalent bond, and naming dehydration synthesis/water release—into one point. Part (c) criterion c1 bundles the rates for both polymers an
- gpt-6.1-sol: well_posed: The setup gives physically inconsistent data for part (c): 10 mg of a glucose polysaccharide contains at most approximately 62 µmol of glucose residues, so tube 2 cannot release 90 µmol of glucose. Correct the starting mass or the glucose measureme
- gpt-6.1-sol: accurate: The setup's tube 2 measurement violates conservation of glucose units. Releasing 90 µmol requires approximately 14.58 mg of glucose residues in the starting polysaccharide, exceeding the stated 10 mg. Hydrolysis adds water but cannot create additiona

### ap_biology 1.5 Lipids (Unit 1: Chemistry of Life)
Official CED text (governs):
```
TOPIC 1.5
Lipids
Required Course Content
BIG IDEA 4
Systems Interactions: Biological systems interact, and these systems and their
interactions exhibit complex properties.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.5.A
1.5.A.1
Describe the structure and
function of lipids.
Lipids are typically nonpolar, hydrophobic
molecules whose structure and function are
derived from the way their subcomponents are
assembled. Fatty acids can be described as
either saturated or unsaturated.
i. Saturated fatty acids contain only single
bonds between carbon atoms.
ii. Unsaturated fatty acids contain at least
one double bond between carbon atoms,
which causes the carbon chain to kink.
iii. The more double bonds in a fatty acid tail,
the more unsaturated the lipid becomes.
iv. The more unsaturated a lipid is, the more
liquid it is at room temperature.
continued on next page
Return to Table of Contents
UNIT
Chemistry of Life
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.5.A
1.5.A.2
Describe the structure and
function of lipids.
Lipids provide a variety of functions for
living organisms. Some examples of lipids
are fats, steroids including cholesterol, and
phospholipids.
i. Fats provide energy storage and support
cell function. In some cases, they can also
provide insulation to help keep mammals
warm.
ii. Steroids are hormones that support
physiological functions including growth
and development, energy metabolism,
and homeostasis.
iii. Cholesterol provides essential structural
stability to animal cell membranes.
iv. Phospholipids group together to form
the lipid bilayers found in plasma and cell
membranes.
X 
Return to Table of Contents
UNIT
SUGGESTED SKILL
Visual
Representations
2.A
Describe characteristics
of visual representations
of biological concepts and
processes.
Chemistry of Life
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: ced_scope: Part (b), criterion b2 requires explaining melting through molecular packing and reduced intermolecular attractions. These required mechanisms are not included in the supplied CED content, which specifies kinks and the relationship between unsaturat
- gpt-6.1-sol: well_posed: Part (d) does not establish that stored fat has the melting behavior of its constituent free fatty acids. Stored fats are mixtures, typically of triglycerides; their liquidity at 4 °C does not uniquely establish that most constituent fatty acids ha
- gpt-6.1-sol: well_posed: Setup, sample W: The composition measurements are inconsistent. With 52% saturated tails, 48% are unsaturated and each contains at least one C=C bond. The mean must therefore be at least 0.48 double bonds per tail, not 0.45. Correct either value.
- gpt-6.1-sol: accurate: Setup, sample W: A saturated-tail percentage of 52% cannot coexist with a mean of 0.45 C=C bonds per tail; the minimum compatible mean is 0.48.
- deepseek-v4-pro: well_posed: Setup table, rule 4: The W row is internally inconsistent. It lists 52% saturated tails and a mean of 0.45 C=C double bonds per tail, but the remaining 48% unsaturated tails must each have at least one double bond, so the minimum possible mean is 0
- deepseek-v4-pro: accurate: Setup table, rule 7: Sample W's 52% saturated tails cannot coexist with a mean of 0.45 double bonds per tail; because 48% unsaturated tails must have at least one double bond each, the minimum possible mean is 0.48.

### ap_biology 2.2 Cell Size (Unit 2: Cells)
Official CED text (governs):
```
TOPIC 2.2
Cell Size
Statistical Tests and
Data Analysis
5.A
Perform mathematical
calculations, including:
Required Course Content
i. mathematicalequations
in the curriculum
ii. means
iii. rates
iv. ratios
v. percentagesandpercent
changes
BIG IDEA 2
Energetics: Biological systems use energy and molecular building blocks to grow,
reproduce, and maintain dynamic homeostasis.
LEARNING OBJECTIVE
ILLUSTRATIVE EXAMPLES
EK 2.2.A.1
§ SA/V Ratios and
Exchanges
§ Root hairs
ESSENTIAL KNOWLEDGE
2.2.A
2.2.A.1
Explaintheeffectofsurface
area-to-volumeratioson
the exchange of materials
between cells or organisms
and the environment.
Surfacearea-to-volumeratiosaffecttheability
of a biological system to obtain necessary
nutrients, eliminate waste products, acquire
or dissipate thermal energy, and otherwise
exchange chemicals and energy with the
environment.
§ Guard cells
§ Gut epithelial cells
§ Cilia
§ Stomata
RELEVANT EQUATIONS
Volume of a Sphere: V =
Volume of a Cube: V = s
r3
Volume of a Rectangular Solid: V = lwh
=
Volume of a Cylinder:
Surface Area of a Sphere:
r2
=
Surface Area of a Cube: SA = 6s
Surface Area of a Rectangular Solid:
SA = 2lh + 2lw + 2wh
Surface Area of a Cylinder:
r = radius
l = length
h = height
w = width
s = length of one side of a cube
+
r
continued on next page
Return to Table of Contents
UNIT
Cells
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.2.A
2.2.A.2
Explain the effect of surface
area-to-volume ratios on
the exchange of materials
between cells or organisms
and the environment.
The surface area of the plasma membrane
must be large enough to adequately exchange
materials.
i. Thesurfacearea-to-volumeratiocan
restrictcellsizeandshape.Smaller
cells typically have a higher surface
area-to-volumeratioaswellasamore
efficientexchangeofmaterialswiththe
environment than do larger cells.
ii. As cells increase in volume, the surface
area-to-volumeratiodecreasesandthe
demand for internal resources increases.
iii. More complex cellular structures (e.g.,
membrane folds) are necessary to
adequately exchange materials with the
environment.
iv.Asorganismsincreaseinsize,their
surfacearea-to-volumeratiodecreases,
affectingpropertieslikerateofheat
exchange with the environment.
Smaller amounts of mass exchange
proportionally more heat with the ambient
environment than do larger masses. As
massincreases,boththesurfaceareato-volumeratioandtherateofheat
exchange decrease.
v. There is a relationship between metabolic
rateperunitbodymassandthesizeof
multicellular organisms; typically, the
smaller the organism, the higher the
metabolic rate per unit body mass.
Return to Table of Contents
UNIT
SUGGESTED SKILL
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Criteria a1 and b1 explicitly accept bare answers although both parts require work. Criterion a1 also requires separate surface-area and volume calculations, potentially rejecting the valid method SA/V = 6/s = 6/2 = 3 cm⁻¹. Criterion d2 accepts 
- gpt-6.1-sol: accurate: Criterion b1 accepts 0.488 as the requested percent. This is the pink fraction, not the percent; the correct percent is 48.8%. Accept 0.488 only when explicitly converted to a percentage.
- gpt-6.1-sol: rubric_points: Part (c), criterion c1: The prompt requires using the data, but the evidence allows full credit for a purely conceptual explanation linking increased volume, decreased SA:V, and increased resource demand without referencing the observed results.
- gpt-6.1-sol: rubric_points: Criterion b1 prescribes a particular calculation sequence, excluding valid alternatives such as [1 − (3.2/4)³] × 100 = 48.8%. Criterion c2 unnecessarily requires explicit square/cube scaling, increased diffusion distance, and a claim that diffus
- gpt-6.1-sol: solution: The independent solution agrees with the rubric's numerical results and predictions: (a) 3.0 cm⁻¹; (b) 48.8%; (c) higher SA:V corresponds to greater penetration; (d) greater penetration, calculated as 90.4%. However, its correct explanation in (c) do
- gpt-6.1-sol: rubric_points: Part (a), criterion a1 prescribes separately calculating surface area and volume, rejecting valid shown work such as SA:V = 6s²/s³ = 6/s = 2 cm⁻¹. Part (d), criterion d2 rejects a valid justification based solely on calculating the penetrated vo

### ap_biology 2.5 Membrane Transport (Unit 2: Cells)
Official CED text (governs):
```
TOPIC 2.5
Membrane Transport
Required Course Content
BIG IDEA 2
Energetics: Biological systems use energy and molecular building blocks to grow,
reproduce, and maintain dynamic homeostasis.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.5.A
2.5.A.1
Describe the mechanisms
that organisms use to
maintain solute and water
balance.
The selective permeability of membranes
allows for the formation of concentration
gradients of solutes across the membrane.
2.5.A.2
Passive transport is the net movement of
molecules from regions of high concentration
to regions of low concentration without the
direct input of metabolic energy.
2.5.A.3
Active transport requires the direct input of
energy to move molecules. In some cases, active
transportisutilizedtomovemoleculesfrom
regions of low concentration to regions of high
concentration.
2.5.B
2.5.B.1
Describe the mechanisms
that organisms use to
transport large molecules
across the plasma
membrane.
The processes of endocytosis and exocytosis
require energy to move large substances or large
amounts of substances into and out of cells.
i. In endocytosis, the cell takes in large
molecules and particulate matter by folding
the plasma membrane in on itself and
forming new (small) vesicles that engulf
material from the external environment.
ii.
Return to Table of Contents
UNIT
Cells
```
Earlier rejected attempts on this topic:
- topic vote went to {'2.8': 6} with required units [2] (drifted off topic or needed a later unit)
- topic vote went to {'2.8': 5, '2.5': 1} with required units [2] (drifted off topic or needed a later unit)
- topic vote went to {'2.8': 5, '2.5': 1} with required units [2] (drifted off topic or needed a later unit)
- topic vote went to {'2.8': 6} with required units [2] (drifted off topic or needed a later unit)

### ap_biology 2.9 Cell Compartmentalization (Unit 2: Cells)
Official CED text (governs):
```
TOPIC 2.9
SUGGESTED SKILL
Cell
Compartmentalization
Argumentation
6.E
Predict the causes or
effects of a change in, or
disruption to, one or more
components in a biological
system.
Required Course Content
BIG IDEA 2
Energetics: Biological systems use energy and molecular building blocks to grow,
reproduce, and maintain dynamic homeostasis.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.9.A
2.9.A.1
Describethemembranebound structures of the
eukaryotic cell.
Membranesandmembrane-boundorganelles
ineukaryoticcellscompartmentalize
intracellularmetabolicprocessesandspecific
enzymaticreactions.
2.9.B
2.9.B.1
Explain how internal
membranesandmembranebound organelles contribute
tocompartmentalizationof
eukaryotic cell functions.
Internal membranes facilitate cellular
processesbyminimizingcompeting
interactions and by increasing the surface area
where reactions can occur.
Return to Table of Contents
UNIT
SUGGESTED SKILL
Argumentation
6.B
Support a claim with
evidence from biological
principles, concepts,
processes, and data.
Cells
```
Earlier rejected attempts on this topic:
- topic vote went to {'2.9': 6} with required units [2, 3] (drifted off topic or needed a later unit)
- topic vote went to {'2.9': 6} with required units [2, 3] (drifted off topic or needed a later unit)
- topic vote went to {'2.9': 3, '3.2': 3} with required units [2, 3] (drifted off topic or needed a later unit)
- topic vote went to {'2.1': 2, '2.9': 4} with required units [2] (drifted off topic or needed a later unit)

### ap_biology 3.1 Enzymes (Unit 3: Cellular Energetics)
Official CED text (governs):
```
TOPIC 3.1
Enzymes
Questions and
Methods
3.C
Identify experimental
procedures that align with
the question, including:
i. identifyingdependent
and independent
variables
Required Course Content
identifyingappropriate
controls
iii. justifyingappropriate
controls
BIG IDEA 2
Energetics: Biological systems use energy and molecular building blocks to grow,
reproduce, and maintain dynamic homeostasis.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.1.A
3.1.A.1
Explainhowenzymes
affecttherateofbiological
reactions.
Thestructureandfunctionofenzymes
contribute to the regulation of biological
processes.Enzymesareproteinsthatare
biological catalysts that facilitate chemical
reactions in cells by lowering the activation
energy.
3.1.A.2
Foranenzyme-mediatedchemicalreactionto
occur, the shape and charge of the substrate
must be compatible with the active site of the
enzyme.Thisisillustratedbytheenzymesubstrate complex model.
Return to Table of Contents
UNIT
Cellular Energetics
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Criterion a1 bundles two independently observable elements—identifying the independent variable and identifying the dependent variable—into one point. Criterion c1 explicitly accepts bare numerical answers even though its evidence requires subtr
- gpt-6.1-sol: accurate: Criterion b1's accepted statement that tube 2 'rules out that sucrose breaks down on its own' overstates the control's result. The control measures background glucose without enzyme; it does not establish that nonenzymatic sucrose breakdown never occ
- deepseek-v4-pro: on_topic: Only part (d) criteria d1 and d2 directly assess 3.1 EKs (activation energy, active-site compatibility); parts (a)-(c) assess experimental-design and calculation practices without requiring 3.1 content, so only 2 of 5 points target the designated top
- lint: 5 parts (allowed 3-4)
- gpt-6.1-sol: rubric_points: Part (a), criterion a1 combines two separately observable elements—identifying the independent variable and identifying the dependent variable—into one all-or-nothing point. Split these into separate 1-point criteria, or ask for only one variabl
- gpt-6.1-sol: rubric_points: Part (c), criterion c1 bundles three separately assessable results into one point: the wild-type rate, mutant rate, and percent decrease. The rule requires one specific observable element per criterion; split these into separate 1-point criteria

### ap_biology 3.3 Cellular Energy (Unit 3: Cellular Energetics)
Official CED text (governs):
```
TOPIC 3.3
SUGGESTED SKILL
Argumentation
Cellular Energy
6.C
Provide reasoning to justify
a claim by connecting
evidence to biological
theories.
Required Course Content
BIG IDEA 2
Energetics: Biological systems use energy and molecular building blocks to grow,
reproduce, and maintain dynamic homeostasis.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.3.A
3.3.A.1
Describe the role of energy in
living organisms.
All living systems require an input of energy.
3.3.A.2
Life requires a highly ordered system and
doesnotviolatethefirstandsecondlawsof
thermodynamics.
i. Energy input must exceed energy loss
to maintain order and to power cellular
processes.
ii. Cellular processes that release energy
may be coupled with cellular processes
that require energy.
iii.Significantlossoforderorenergyflow
results in death.
X  EXCLUSION STATEMENT—Students will
need to understand the concept of energy, but the
equation for Gibbs free energy is beyond the scope
of the AP Exam.
3.3.A.3
Energy-relatedpathwaysinbiologicalsystems
are sequential to allow for a more controlled
transfer of energy. A product of a reaction in a
metabolic pathway is typically the reactant for
the subsequent step in the pathway.
continued on next page
Return to Table of Contents
UNIT
Cellular Energetics
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.3.B
3.3.B.1
Explain how shared,
conserved, and fundamental
processes and features
support the concept of
common ancestry for all
organisms.
Core metabolic pathways (e.g., glycolysis,
oxidative phosphorylation) are conserved
acrossallcurrentlyrecognizeddomains
(Archaea, Bacteria, and Eukarya).
Return to Table of Contents
UNIT
Cellular Energetics
```
Earlier rejected attempts on this topic:
- topic vote went to {'3.3': 6} with required units [3, 7] (drifted off topic or needed a later unit)
- lint: fix length 26 words
- lint: fix length 28 words
- topic vote went to {'3.3': 6} with required units [3, 7] (drifted off topic or needed a later unit)


## AP Biology CED fact pack (course-wide sections and units up to 3)
# AP Biology — CED Fact Pack (authoring/review input)

> **Confidence status: VERIFIED** against *AP Biology Course and Exam
> Description, Effective Fall 2025* (© 2025 College Board, V.1), checked
> 2026-08-04 directly from the PDF.
>
> Verified from source: exam structure and FRQ specification (CED pp. 197–203),
> unit list and MC weightings (pp. 17, 198), full topic list for all eight units
> (Course at a Glance, pp. 20–22), the six science practices and their skills
> (pp. 12–13), big ideas (pp. 15–16), and task verbs (p. 203).
>
> **§10 added 2026-08-04:** per-topic Learning Objective / Essential Knowledge
> detail for all 8 units (unit guides, pp. 27–165) is now transcribed below.
> Extracted via 8 parallel independent reads of the source PDF (one per unit)
> plus an independent spot-check pass re-verifying §1, §2, §3, §5, §6 of this
> document against the PDF; the spot-check found no discrepancies. §10 itself
> has not had a second independent verification pass — treat its EK summaries
> as high-confidence paraphrase, not verbatim-checked text, and re-confirm
> against the source PDF before quoting EK wording in a rubric or scoring
> guideline.
>
> **Supersedes** the earlier provisional pack, which listed four topics that do
> not exist in this CED and mis-numbered three units. See §9.

## 1. Exam structure

3 hours. A four-function, scientific, or graphing calculator is allowed on
**both** sections. An Equations and Formulas appendix is provided (CED p. 229).

| Section | Type | Questions | Weighting | Timing |
|---|---|---|---:|---|
| I | Multiple-choice | 60 | 50% | 90 min |
| II | Free-response | 6 | 50% | 90 min |

MCQs appear as individual questions or in **sets of typically 4–5 questions**.

Section II is **two long (9 points each) + four short (4 points each)**. Each of
the four short-answer questions focuses on a different big idea and a different
unit of instruction.

| FRQ | Type | Points |
|---|---|---:|
| 1 | Interpreting and Evaluating Experimental Results | 9 |
| 2 | Interpreting and Evaluating Experimental Results with Graphing | 9 |
| 3 | Scientific Investigation | 4 |
| 4 | Conceptual Analysis | 4 |
| 5 | Analyze Model or Visual Representation of a Biological Concept or Process | 4 |
| 6 | Analyze Data | 4 |

### FRQ part structure (authoring targets)

- **Q1 (9 pts):** A — describe concepts/processes/models (1). B — identify
  experimental methods or describe data (3). C — identify methods, analyze data,
  or perform calculations (3). D — make and justify predictions (2).
- **Q2 (9 pts):** A — describe concepts/processes/models (1). B — **construct the
  appropriate graph from the data provided (4)**. C — analyze data, perform
  calculations, state a null hypothesis, or predict results (2). D — make and
  justify predictions (2).
- **Q3 (4 pts):** A — describe concepts/processes. B — identify experimental
  procedures. C — state the null hypothesis or predict results. D — justify
  predictions. (1 pt each.)
- **Q4 (4 pts):** A — describe. B — explain. C — predict causes or effects of a
  change in a biological system. D — justify predictions. (1 pt each.)
- **Q5 (4 pts):** A — describe characteristics of a visually represented concept.
  B — explain relationships between characteristics. C — represent relationships
  within a biological model. D — explain how the visual relates to a larger
  principle. (1 pt each.)
- **Q6 (4 pts):** A — describe data. B — describe data. C — use data to evaluate a
  hypothesis or prediction. D — explain how experimental results relate to
  biological principles. (1 pt each.)

## 2. Big ideas

1. **Evolution** — the process of evolution drives the diversity and unity of life.
2. **Energetics** — biological systems use energy and molecular building blocks to
   grow, reproduce, and maintain dynamic homeostasis.
3. **Information Storage and Transmission** — living systems store, retrieve,
   transmit, and respond to information essential to life processes.
4. **Systems Interactions** — biological systems interact, and these systems and
   their interactions exhibit complex properties.

## 3. Units and MC weighting

| Unit | Title | MC weight | Class periods |
|---|---|---:|---|
| 1 | Chemistry of Life | 8–11% | ~9–11 |
| 2 | **Cells** | 10–13% | ~14–16 |
| 3 | Cellular Energetics | 12–16% | ~12–14 |
| 4 | Cell Communication and Cell Cycle | 10–15% | ~12–14 |
| 5 | Heredity | 8–11% | ~8–10 |
| 6 | Gene Expression and Regulation | 12–16% | ~18–20 |
| 7 | Natural Selection | 13–20% | ~19–21 |
| 8 | Ecology | 10–15% | ~19–21 |

## 4. Topic map (authoritative at topic level)

**A topic not listed here is out of scope for this course.**

### Unit 1 — Chemistry of Life (8–11%)
- 1.1 Structure of Water and Hydrogen Bonding
- 1.2 Elements of Life
- 1.3 Introduction to Macromolecules
- 1.4 Carbohydrates
- 1.5 Lipids
- 1.6 Nucleic Acids
- 1.7 Proteins

### Unit 2 — Cells (10–13%)
- 2.1 Cell Structure and Function
- 2.2 Cell Size
- 2.3 Plasma Membrane
- 2.4 Membrane Permeability
- 2.5 Membrane Transport
- 2.6 Facilitated Diffusion
- 2.7 Tonicity and Osmoregulation
- 2.8 Mechanisms of Transport
- 2.9 Cell Compartmentalization
- 2.10 Origins of Cell Compartmentalization

### Unit 3 — Cellular Energetics (12–16%)
- 3.1 Enzymes
- 3.2 Environmental Impacts on Enzyme Function
- 3.3 Cellular Energy
- 3.4 Photosynthesis
- 3.5 Cellular Respiration

## 5. Science practices and skills

All six practices are assessed on every exam, in both sections.

**1. Concept Explanation** *(MC weight 25–33%)* — explain biological concepts and
processes presented in written format.
- 1.A Describe biological concepts and processes.
- 1.B Explain biological concepts and processes.
- 1.C Explain biological concepts and processes in applied contexts.

**2. Visual Representations** *(MC 16–24%)* — analyze visual representations.
- 2.A Describe characteristics of visual representations.
- 2.B Explain relationships between characteristics of biological models in both
  theoretical and applied contexts.
- 2.C Explain how biological models relate to larger principles, concepts,
  systems, or theories.
- 2.D Represent relationships within biological models, including mathematical
  models, diagrams, flowcharts, and systems.

**3. Questions and Methods** *(MC 8–14%)* — determine scientific questions and
methods.
- 3.A Identify or pose a testable question based on an observation, data, or a model.
- 3.B State the null hypothesis or predict the results of an experiment.
- 3.C Identify experimental procedures that align with the question, including
  identifying dependent and independent variables, identifying appropriate
  controls, and justifying appropriate controls.
- 3.D Propose a new investigation based on an evaluation of the experimental
  design or evidence.

**4. Representing and Describing Data** *(MC 8–14%)*
- 4.A Construct a graph to represent the data, including: type of graph
  appropriate for the data; axis labeling with appropriate units and legend;
  scaling; accurately plotted data (including error bars when appropriate);
  trend line (when appropriate). Graph types named: bar, histogram, line, log
  scale, dual y, scatter plot, box and whisker plot, pie chart.
- 4.B Describe data from a table or graph, including identifying specific data
  points, describing trends and patterns, and describing relationships between
  variables.

**5. Statistical Tests and Data Analysis** *(MC 8–14%)*
- 5.A Perform mathematical calculations, including: mathematical equations in the
  curriculum, means, rates, ratios, percentages and percent changes.
- 5.B Use confidence intervals and error bars to estimate whether sample means
  are statistically different.
- 5.C **Perform chi-square hypothesis testing.** (In scope for AP Biology — do not
  confuse with AP Statistics, where goodness-of-fit was removed.)
- 5.D Use data to evaluate a hypothesis or prediction, including rejecting or
  failing to reject the null hypothesis.

**6. Argumentation** *(MC 20–26%)*
- 6.A Make a scientific claim.
- 6.B Support a claim with evidence from biological principles, concepts,
  processes, and data.
- 6.C Provide reasoning to justify a claim by connecting evidence to biological
  concepts, processes, or theories.
- 6.D Explain the relationship between experimental results and larger biological
  concepts, processes, or theories.
- 6.E Predict the causes or effects of a change in, or disruption to, one or more
  components in a biological system.

## 6. Task verbs

**Calculate** · **Construct/Draw** · **Describe** · **Determine** · **Evaluate** ·
**Explain** (incl. "how" and "why" variants) · **Identify** · **Justify** ·
**Make a claim** · **Predict/Make a prediction** · **Represent** ·
**State (the null hypothesis)** · **Support a claim**

Authoring/review rule: "Identify" indicates information *without elaboration* and
needs no justification; "Explain", "Justify", and "Support a claim" require
reasoning connecting evidence to a claim. An item whose task verb demands
justification but whose rubric awards credit without it is a rubric defect.

Note "Make a claim" and "Support a claim" are **separate** verbs in this CED, and
**Evaluate** is a distinct verb (judge the significance, importance, or accuracy
of information or a claim).

## 7. Laboratory requirement

The course includes a laboratory investigation component (CED pp. 167–169). Items
referencing lab procedures should be consistent with a hands-on inquiry-based lab
program.

## 8. Response modality — Cramapple operational note

> **Not CED-verified.** The claim that AP Biology is hybrid (MCQ digital, FRQ
> handwritten in paper booklets) is a Cramapple operational assumption about
> College Board's digital rollout, not something stated in this CED. Confirm
> against current College Board exam-administration guidance before relying on it.

If it holds, Cramapple's hand-drawn-graph capture (HDG) work is exam-aligned for
Biology — note that FRQ 2 Part B is worth 4 of 9 points for constructing a graph,
so graph-construction fidelity matters more here than in most subjects.

## 9. Corrections applied 2026-08-04

The prior provisional pack contained the following errors, all corrected above.
Recorded because content authored or reviewed against the old pack may be
affected.

**Topics that do NOT exist in the Fall 2025 CED but were listed as in scope:**

| Removed topic (old numbering) | Status |
|---|---|
| 3.7 Fitness | Not in CED |
| 4.4 Changes in Signal Transduction Pathways | Not in CED |
| 5.6 Chromosomal Inheritance | Not in CED |
| 7.11 Extinction | Not in CED |

**Structural corrections:**

- Unit 2 title is **Cells**, not "Cell Structure and Function".
- Unit 1 restructured: macromolecules are now separate topics
  (1.4 Carbohydrates, 1.5 Lipids, 1.7 Proteins). The old pack's "Properties of
  Biological Macromolecules" and "Structure and Function of Biological
  Macromolecules" do not exist; Unit 1 has 7 topics, not 6.
- Unit 2: old 2.1/2.2 are merged into 2.1 Cell Structure and Function; all later
  Unit 2 topics shift down one number (10 topics, not 11).
- Unit 3: old 3.1 Enzyme Structure and 3.2 Enzyme Catalysis are merged into
  3.1 Enzymes (5 topics, not 7).
- Unit 7: 12 topics, not 13; Origins of Life on Earth is 7.12.
- Unit 8: 8.7 is "Disruptions **in** Ecosystems".
- Task verbs: **Evaluate** was missing; "Make a claim" and "Support a claim" are
  separate verbs.
- Long FRQs are **9 points each** exactly, not "≈8–10".

**MC weights in the old pack were correct** and are confirmed against CED pp. 17
and 198.

## 10. Topic-level Learning Objectives and Essential Knowledge

Extracted 2026-08-04 from the unit guides (CED pp. 27–165) via 8 independent
per-unit passes over the source PDF. Codes and structure below (LO letter,
EK number) are as printed in the CED. **This CED does not print a distinct
EU code string per topic** (e.g. no "ENE-1"-style label appears on these
pages) — each topic instead states its Big Idea by name directly, so "EU"
below is reported as the Big Idea name, not a code. Exclusion statements
("beyond exam scope") are noted inline where the CED states one; treat them
as authoritative scope boundaries for item authoring.

Cross-check: every unit's stated AP exam weighting % and class-period count
(from the unit-opener page) matched §3 exactly — no discrepancies.

### Unit 1 — Chemistry of Life (8–11%, ~9–11 periods)

**1.1 Structure of Water and Hydrogen Bonding** — Big Idea 4 (Systems Interactions)
- **LO 1.1.A** Explain how the properties of water resulting from polarity and
  hydrogen bonding affect its biological function.
  - EK 1.1.A.1 — Water's polarity (polar covalent H–O bonds) enables hydrogen
    bonding; high specific heat capacity maintains homeostatic temperature;
    high heat of vaporization enables evaporative cooling.
  - EK 1.1.A.2 — Hydrogen bonds between water molecules produce cohesion,
    adhesion, and surface tension.

**1.2 Elements of Life** — Big Idea 2 (Energetics)
- **LO 1.2.A** Describe the composition of macromolecules required by living
  organisms.
  - EK 1.2.A.1 — C, H, O are most prevalent in biological molecules; S builds
    proteins, P builds phospholipids/nucleic acids, N builds nucleic acids.

**1.3 Introduction to Macromolecules** — Big Idea 4
- **LO 1.3.A** Describe the chemical reactions that build and break biological
  macromolecules.
  - EK 1.3.A.1 — Hydrolysis cleaves a polymer bond by adding water (H to one
    monomer, OH to the other).
  - EK 1.3.A.2 — Dehydration synthesis joins two monomers via covalent bond,
    releasing water; repeated joining = polymerization.

**1.4 Carbohydrates** — Big Idea 4
- **LO 1.4.A** Describe the structure and function of carbohydrates.
  - EK 1.4.A.1 — Monosaccharides are monomers for polysaccharides (e.g.
    cellulose, starch, glycogen), joined by covalent bonds into linear or
    branched polymers. *Exclusion: specific carbohydrate polymer molecular
    structure is beyond exam scope.*

**1.5 Lipids** — Big Idea 4
- **LO 1.5.A** Describe the structure and function of lipids.
  - EK 1.5.A.1 — Lipids are typically nonpolar/hydrophobic. Fatty acids:
    saturated = only single C–C bonds; unsaturated = ≥1 double bond causing
    kinks; more double bonds = more unsaturated = more liquid at room temp.
  - EK 1.5.A.2 — Functions: fats store energy/support function/insulate;
    steroids are hormones supporting growth, metabolism, homeostasis;
    cholesterol stabilizes animal membranes; phospholipids form the lipid
    bilayer. *Exclusion: specific lipid molecular structure beyond scope.*

**1.6 Nucleic Acids** — Big Idea 3 (Information Storage and Transmission)
- **LO 1.6.A** Describe the structure and function of DNA and RNA.
  - EK 1.6.A.1 — Nucleic acids encode information via nucleotide sequence;
    each nucleotide = 5-C sugar (deoxyribose/ribose) + phosphate + base
    (A, T, G, C, or U).
  - EK 1.6.A.2 — Linear sequence with 3'/5' ends; synthesis adds nucleotides
    to the 3' end. *Exclusion: specific nucleotide molecular structure beyond
    scope.*
  - EK 1.6.A.3 — DNA is an antiparallel double helix; A–T and C–G pair via H
    bonds in DNA; A–U in RNA.
  - EK 1.6.A.4 — DNA vs. RNA: deoxyribose vs. ribose; thymine vs. uracil;
    typically double- vs. single-stranded.

**1.7 Proteins** — Big Idea 3
- **LO 1.7.A** Describe the structure and function of proteins.
  - EK 1.7.A.1 — Proteins are amino-acid chains joined by peptide bonds
    (carboxyl-to-amine).
  - EK 1.7.A.2 — Amino acid = central C + H + carboxyl + amine + variable R
    group (hydrophobic, hydrophilic, or ionic); R-group interactions drive
    local structure/function.
  - EK 1.7.A.3 — Amino acid sequence determines primary structure/overall
    shape. *Exclusion: specific amino acid molecular structure beyond scope.*
  - EK 1.7.A.4 — Secondary structure (alpha-helix, beta-sheet) from H-bonding
    between backbone atoms.
  - EK 1.7.A.5 — Tertiary structure (3D shape) from H-bonds, hydrophobic
    interactions, ionic interactions, disulfide bridges.
  - EK 1.7.A.6 — Quaternary structure from interactions between multiple
    polypeptides; all four levels determine function.

### Unit 2 — Cells (10–13%, ~14–16 periods)

**2.1 Cell Structure and Function** — Big Idea 4
- **LO 2.1.A** Explain how the structure/function of subcellular components and
  organelles contribute to cell function.
  - EK 2.1.A.1 — Ribosomes (rRNA + protein) synthesize proteins per mRNA.
  - EK 2.1.A.2 — Endomembrane system (ER, Golgi, lysosomes, vacuoles, nuclear
    envelope, plasma membrane) modifies/packages/transports products.
  - EK 2.1.A.3 — ER: rough (ribosome-studded, protein synthesis) vs. smooth
    (detox, lipid synthesis). *Exclusion: specific smooth-ER functions in
    specialized cells beyond scope.*
  - EK 2.1.A.4 — Golgi: flattened sacs that fold/modify/package proteins for
    trafficking. *Exclusion: specific Golgi roles in lysosome/peroxisome/
    secretory-vesicle enzyme synthesis beyond scope.*
  - EK 2.1.A.5 — Mitochondria: double membrane compartmentalizes aerobic
    respiration; convoluted inner membrane for efficient ATP synthesis.
  - EK 2.1.A.6 — Lysosomes: hydrolytic-enzyme sacs; digest material, drive
    apoptosis.
  - EK 2.1.A.7 — Vacuoles: large plant vacuole maintains turgor pressure;
    animal vacuoles smaller/more numerous, store materials.
  - EK 2.1.A.8 — Chloroplasts: double-membrane, site of photosynthesis.
  - *Source: CED V.1 (© 2025), printed pp. 49-51; confirmed by the Product Owner on
    2026-10-01 as the latest edition.*
  - *Not in the CED (2026-10-01 check of printed pp. 49-51 and a full-text search):*
    *signal sequence / signal peptide, signal recognition particle (SRP),
    co-translational ER targeting, and sorting of proteins to specific organelles. The CED
    states only that rough ER has membrane-bound ribosomes and helps carry out protein
    synthesis (2.1.A.3.i), and that the endomembrane system works together to modify, package
    and transport proteins (2.1.A.2). Items must not depend on those mechanisms. The Golgi
    exclusion (2.1.A.4) also puts packaging of specific enzymes for lysosomes, peroxisomes and
    secretory vesicles out of scope.*

**2.2 Cell Size** — Big Idea 2
- **LO 2.2.A** Explain the effect of surface area-to-volume ratio on exchange
  between cells/organisms and environment.
  - EK 2.2.A.1 — SA:V affects nutrient/waste/thermal/chemical exchange
    (includes relevant volume/SA equations).
  - EK 2.2.A.2 — Smaller cells → higher SA:V → more efficient exchange; as
    volume grows SA:V drops, raising internal resource demand; membrane folds
    compensate; larger organisms have lower SA:V affecting heat exchange;
    smaller organisms generally have higher mass-specific metabolic rate.

**2.3 Plasma Membrane** — Big Idea 2
- **LO 2.3.A** Describe the roles of each membrane component in maintaining
  internal environment.
  - EK 2.3.A.1 — Phospholipids: hydrophilic heads face out, hydrophobic tails
    face in.
  - EK 2.3.A.2 — Embedded proteins can be hydrophilic, hydrophobic, or both,
    oriented accordingly.
- **LO 2.3.B** Describe the fluid mosaic model.
  - EK 2.3.B.1 — Membranes = phospholipid framework with mobile proteins,
    steroids (e.g. cholesterol), glycoproteins, glycolipids.

**2.4 Membrane Permeability** — Big Idea 2
- **LO 2.4.A** Explain how membrane structure influences selective
  permeability.
  - EK 2.4.A.1 — Hydrophobic interior gives selective permeability.
  - EK 2.4.A.2 — Small nonpolar molecules (N₂, O₂, CO₂) cross freely;
    hydrophilic substances need channels/transport proteins.
  - EK 2.4.A.3 — Hydrocarbon tails block ions/polar molecules; small polar
    uncharged molecules (H₂O, NH₃) pass in small amounts.
- **LO 2.4.B** Describe the role of the cell wall.
  - EK 2.4.B.1 — Cell walls (Bacteria, Archaea, Fungi, plants) provide
    structural boundary, permeability barrier, protection from osmotic lysis.

**2.5 Membrane Transport** — Big Idea 2
- **LO 2.5.A** Describe mechanisms for solute/water balance.
  - EK 2.5.A.1 — Selective permeability creates solute concentration
    gradients.
  - EK 2.5.A.2 — Passive transport: net high→low movement, no direct energy.
  - EK 2.5.A.3 — Active transport: requires energy, can move low→high.
- **LO 2.5.B** Describe transport of large molecules across the membrane.
  - EK 2.5.B.1 — Endocytosis (membrane folds inward to engulf) / exocytosis
    (vesicle fuses with membrane to secrete) use energy.

**2.6 Facilitated Diffusion** — Big Idea 2
- **LO 2.6.A** Explain how molecule structure affects membrane passage.
  - EK 2.6.A.1 — Charged ions (Na⁺, K⁺) need channel proteins; ion movement
    can polarize membranes.
  - EK 2.6.A.2 — Facilitated diffusion moves large polar molecules down
    gradient, no energy input.
  - EK 2.6.A.3 — Aquaporins transport large quantities of water.

**2.7 Tonicity and Osmoregulation** — Big Idea 2
- **LO 2.7.A** Explain how concentration gradients affect molecule movement.
  - EK 2.7.A.1 — Environments can be hypo-/hyper-/isotonic; water moves by
    osmosis high→low water potential (Ψ = Ψp + Ψs).
- **LO 2.7.B** Explain how osmoregulation contributes to health/survival.
  - EK 2.7.B.1 — Growth/homeostasis maintained by constant cross-membrane
    movement.
  - EK 2.7.B.2 — Osmoregulation maintains water balance/solute composition;
    water moves low→high osmolarity (Ψs = −iCRT).

**2.8 Mechanisms of Transport** — Big Idea 2
- **LO 2.8.A** Describe processes for ion/molecule movement across membranes.
  - EK 2.8.A.1 — Metabolic energy (e.g. ATP) required for active transport and
    electrochemical gradient maintenance; Na⁺/K⁺ pump and ATPase maintain
    membrane potential.

**2.9 Cell Compartmentalization** — Big Idea 2
- **LO 2.9.A** Describe membrane-bound structures of the eukaryotic cell.
  - EK 2.9.A.1 — Membranes/membrane-bound organelles compartmentalize
    metabolic processes and enzymatic reactions.
- **LO 2.9.B** Explain how internal membranes contribute to compartmentalized
  function.
  - EK 2.9.B.1 — Internal membranes minimize competing interactions and
    increase reaction surface area.

**2.10 Origins of Cell Compartmentalization** — Big Idea 1 (Evolution)
- **LO 2.10.A** Describe similarities/differences in compartmentalization
  between prokaryotes and eukaryotes.
  - EK 2.10.A.1 — Mitochondria/chloroplasts evolved from free-living
    prokaryotes via endosymbiosis.
  - EK 2.10.A.2 — Prokaryotes typically lack membrane-bound organelles but
    have specialized internal regions.
  - EK 2.10.A.3 — Eukaryotic internal membranes partition specialized
    regions.

### Unit 3 — Cellular Energetics (12–16%, ~12–14 periods)

All topics roll up to Big Idea 2 (Energetics).

**3.1 Enzymes**
- **LO 3.1.A** Explain how enzymes affect reaction rate.
  - EK 3.1.A.1 — Enzymes are protein catalysts that lower activation energy.
  - EK 3.1.A.2 — Enzyme-substrate complex model: substrate shape/charge must
    fit the active site.

**3.2 Environmental Impacts on Enzyme Function**
- **LO 3.2.A** Explain how enzyme structure changes affect function.
  - EK 3.2.A.1 — Denaturation (temp/pH/chemical) eliminates catalytic
    ability; temp/pH outside optimum alters H-bonding and efficiency.
  - EK 3.2.A.2 — Denaturation is sometimes reversible.
- **LO 3.2.B** Explain how cellular environment affects enzyme activity.
  - EK 3.2.B.1 — Relative substrate/product concentration affects reaction
    efficiency.
  - EK 3.2.B.2 — Higher temperature raises collision frequency/rate up to the
    optimum.
  - EK 3.2.B.3 — Competitive inhibitors bind the active site reversibly;
    noncompetitive inhibitors bind allosteric sites.

**3.3 Cellular Energy**
- **LO 3.3.A** Describe the role of energy in living organisms.
  - EK 3.3.A.1 — All living systems require energy input.
  - EK 3.3.A.2 — Life requires a highly ordered system and does not violate
    the first and second laws of thermodynamics. (i) Energy input must exceed
    energy loss to maintain order and to power cellular processes. (ii)
    Cellular processes that release energy may be coupled with cellular
    processes that require energy. (iii) Significant loss of order or energy
    flow results in death. *Exclusion: students need the concept of energy,
    but the Gibbs free energy equation is beyond the scope of the exam.*
    *(Sub-points i-iii restored verbatim from CED p. 63 on 2026-10-06; the
    earlier paraphrase dropped (ii) energy coupling. TASK-0065.)*
  - EK 3.3.A.3 — Metabolic pathways are sequential; a product is typically the
    next step's reactant.
- **LO 3.3.B** Explain how conserved processes support common ancestry.
  - EK 3.3.B.1 — Core pathways (glycolysis, oxidative phosphorylation) are
    conserved across Archaea, Bacteria, Eukarya.

**3.4 Photosynthesis** *(Exclusion: Calvin-cycle steps, molecule structures,
enzyme names beyond ATP synthase are out of scope.)*
- **LO 3.4.A** Describe photosynthetic processes and chloroplast structure.
  - EK 3.4.A.1 — Photosynthesis uses CO₂ + H₂O + light → carbohydrates + O₂;
    first evolved in prokaryotes; cyanobacterial photosynthesis produced
    Earth's oxygenated atmosphere.
  - EK 3.4.A.2 — Stroma (Calvin cycle site) and thylakoids (grana; light
    reactions, two photosystems + ETC).
  - EK 3.4.A.3 — Light reactions yield ATP and NADPH powering the Calvin
    cycle.
- **LO 3.4.B** Explain how cells capture and transfer light energy.
  - EK 3.4.B.1 — ETC reactions occur in chloroplasts/mitochondria/prokaryotic
    membranes; electrons cross the thylakoid membrane, reducing NADP⁺ at
    photosystem I. *Exclusion: specific electron-carrier names/intermediates
    out of scope.*
  - EK 3.4.B.2 — Chlorophylls absorb light, boosting electrons in
    photosystems I/II; water splits to replace electrons lost at PS II.
  - EK 3.4.B.3 — PS I and II connected via ETC in the thylakoid membrane.
  - EK 3.4.B.4 — ETC establishes a proton gradient across the thylakoid
    membrane.
  - EK 3.4.B.5 — Chemiosmosis through ATP synthase drives photophosphorylation.
  - EK 3.4.B.6 — ATP/NADPH power Calvin-cycle carbohydrate production.

**3.5 Cellular Respiration**
- **LO 3.5.A** Describe processes/structures allowing energy use from
  macromolecules. *Exclusion: specific electron carrier names, intermediates/
  enzyme names out of scope.*
  - EK 3.5.A.1 — Respiration/fermentation synthesize ATP from macromolecules;
    occur in all life forms.
  - EK 3.5.A.2 — Aerobic respiration involves coordinated enzyme-catalyzed
    reactions.
  - EK 3.5.A.3 — ETC electron transfer builds a proton gradient (across inner
    mitochondrial membrane in eukaryotes, plasma membrane in prokaryotes);
    NADH/FADH₂ deliver electrons ending in O₂ (aerobic) or other acceptors
    (anaerobic); chemiosmosis through ATP synthase drives oxidative
    phosphorylation; decoupling generates heat for endotherm
    thermoregulation.
- **LO 3.5.B** Explain how cells obtain energy from macromolecules.
  *(Exclusion: memorization of glycolysis/Krebs steps, structures, enzyme
  names out of scope.)*
  - EK 3.5.B.1 — Glycolysis: glucose → ATP, NADH, pyruvate.
  - EK 3.5.B.2 — Pyruvate → mitochondrion; Krebs cycle reduces NAD⁺/FAD,
    releases CO₂.
  - EK 3.5.B.3 — Krebs cycle occurs in the matrix.
  - EK 3.5.B.4 — NADH/FADH₂ carry electrons from glycolysis/Krebs to the ETC.
  - EK 3.5.B.5 — ETC builds the proton gradient (matrix pH higher than
    intermembrane space).
  - EK 3.5.B.6 — Fermentation lets glycolysis proceed without O₂, producing
    alcohol or lactic acid.

