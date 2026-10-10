# FRQ writing brief: physics2

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


# Subject: AP Physics 2 (subject_key ap_physics_2)
Format: Short free-response in AP Physics style: a physical setup described fully in words (no diagram; describe any circuit by listing each element and how it is connected). Parts ask for symbolic derivations, numeric calculations with units, or claims justified with physics principles.
Parts: 2-4. Criteria (points) in total: 3-5.

## Topics in this subject's Units 9, 10, 11 (stay inside the designated topic)
9.1 Kinetic Theory of Temperature and Pressure (Unit 9: Thermodynamics)
9.2 The Ideal Gas Law (Unit 9: Thermodynamics)
9.3 Thermal Energy Transfer and Equilibrium (Unit 9: Thermodynamics)
9.4 The First Law of Thermodynamics (Unit 9: Thermodynamics)
9.5 Specific Heat and Thermal Conductivity (Unit 9: Thermodynamics)
9.6 Entropy and the Second Law of Thermodynamics (Unit 9: Thermodynamics)
10.1 Electric Charge and Electric Force (Unit 10: Electric Force, Field, and Potential)
10.2 Conservation of Electric Charge and the Process of Charging (Unit 10: Electric Force, Field, and Potential)
10.3 Electric Fields (Unit 10: Electric Force, Field, and Potential)
10.4 Electric Potential Energy (Unit 10: Electric Force, Field, and Potential)
10.5 Electric Potential (Unit 10: Electric Force, Field, and Potential)
10.6 Capacitors (Unit 10: Electric Force, Field, and Potential)
10.7 Conservation of Electric Energy (Unit 10: Electric Force, Field, and Potential)
11.1 Electric Current (Unit 11: Electric Circuits)
11.2 Simple Circuits (Unit 11: Electric Circuits)
11.3 Resistance, Resistivity, and Ohm's Law (Unit 11: Electric Circuits)
11.4 Electric Power (Unit 11: Electric Circuits)
11.5 Compound Direct Current (DC) Circuits (Unit 11: Electric Circuits)
11.6 Kirchhoff's Loop Rule (Unit 11: Electric Circuits)
11.7 Kirchhoff's Junction Rule (Unit 11: Electric Circuits)
11.8 Resistor-Capacitor (RC) Circuits (Unit 11: Electric Circuits)

## Targets: write exactly one FRQ for each of these 14 topics

### ap_physics_2 10.1 Electric Charge and Electric Force (Unit 10: Electric Force, Field, and Potential)
Official CED text (governs):
```
TOPIC 10.1
SUGGESTED SKILLS
1.A
Electric Charge and
Electric Force
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
Required Course Content
Predict new values or
factors of change of
physical quantities using
functional dependence
between variables.
2.A
Derive a symbolic
expression from known
quantities by selecting
and following a logical
mathematical pathway.
2.D
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
10.1.A
10.1.A.1
Describe the electric
force that results from
the interactions between
charged objects or systems.
Charge is a fundamental property of all matter.
10.1.A.1.i
Charge is described as positive or negative.
3.B
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
10.1.A.1.ii
The magnitude of the charge of a single
electron or proton, the elementary charge
e , can be considered to be the smallest
indivisible amount of charge.
10.1.A.1.iii
The charge of an electron is −e , the charge
of a proton is +e, and a neutron has no
electric charge.
10.1.A.1.iv
A point charge is a model in which the
physicalsizeofachargedobjectorsystem
is negligible in the context of the situation
beinganalyzed.
10.1.A.2
Coulomb’s law describes the electrostatic
force between two charged objects as directly
proportional to the magnitude of each of the
charges and inversely proportional to the
square of the distance between the objects.
Relevant equation:
continued on next page
Return to Table of Contents
UNIT
Electric Force, Field, and Potential
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
10.1.A
10.1.A.3
Describe the electric
force that results from
the interactions between
charged objects or systems
The direction of the electrostatic force
depends on the signs of the charges of the
interacting objects and is parallel to the line of
separation between the objects.
10.1.A.3.i
Two objects with charges of the same sign
exert repulsive forces on each other.
10.1.A.3.ii
Two objects with charges of opposite signs
exert attractive forces on each other.
10.1.A.4
Electric forces are responsible for some of the
macroscopic properties of objects in everyday
experiences. However, the large number of
particle interactions that occur make it more
convenient to treat everyday forces in terms of
nonfundamental forces called contact forces,
such as normal force, friction, and tension.
10.1.B
10.1.B.1
Describe the electric and
gravitational forces that
result from interactions
between charged objects
with mass.
Electrostatic forces can be attractive or
repulsive, while gravitational forces are always
attractive.
10.1.B.2
For any two objects that have mass and
electric charge, the magnitude of the
gravitational force is usually much smaller than
the magnitude of the electrostatic force.
10.1.B.3
Gravitational forces dominate at larger scales
even though they are weaker than electrostatic
forces, because systems at large scales tend
to be electrically neutral.
10.1.C
10.1.C.1
Describe the electric
permittivity of a material or
medium.
Electric permittivity is a measurement of
the degree to which a material or medium is
polarizedinthepresenceofanelectricfield.
10.1.C.2
Electricpolarizationcanbemodeledasthe
induced rearrangement of electrons by an
external electric field, resulting in a separation
of positive and negative charges within a
material or medium.
continued on next page
Return to Table of Contents
```

### ap_physics_2 10.2 Conservation of Electric Charge and the Process of Charging (Unit 10: Electric Force, Field, and Potential)
Official CED text (governs):
```
TOPIC 10.2
Conservation of
Electric Charge and
the Process of Charging
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
10.2.A
10.2.A.1
Describe the behavior of a
system using conservation of
charge.
The net charge or charge distribution of
a system can change in response to the
presence of, or changes in, the net charge or
charge distribution of other systems.
10.2.A.1.i
The net charge of a system can change due
to friction or contact between systems.
10.2.A.1.ii
Induced charge separation occurs when
the electrostatic force between two
systems alters the distribution of charges
within the systems, resulting in the
polarizationofoneorbothsystems.
10.2.A.1.iii
Induced charge separation can occur in
neutral systems.
10.2.A.2
Any change to a system’s net charge is due to
a transfer of charge between the system and
its surroundings.
10.2.A.2.i
The charging of a system typically involves
the transfer of electrons to and from the
system.
10.2.A.2.ii
The net charge of a system will be constant
unless there is a transfer of charge to or
from the system.
10.2.A.3
Grounding involves electrically connecting
a charged system to a much larger and
approximately neutral system (e.g., Earth).
Return to Table of Contents
UNIT
Electric Force, Field, and Potential
```

### ap_physics_2 10.3 Electric Fields (Unit 10: Electric Force, Field, and Potential)
Official CED text (governs):
```
TOPIC 10.3
SUGGESTED SKILLS
1.A
Electric Fields
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
10.3.A
10.3.A.1
Describe the electric field
produced by a charged
object or configuration of
point charges.
Electric fields may originate from charged
objects.
Calculate or estimate an
unknown quantity with units
from known quantities, by
selecting and following
a logical computational
pathway.
3.B
10.3.A.2
The electric field at a given point is the ratio of
the electric force exerted on a test charge at
that point to the charge of the test charge.
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
Relevant equation:

 FE
E=
q
10.3.A.2.i
A test charge is a point charge of small
enough magnitude such that its presence
doesnotsignificantlyaffectanelectricfield
in its vicinity.
10.3.A.2.ii
Anelectricfieldpointsawayfromisolated
positive charges and toward isolated
negative charges.
10.3.A.2.iii
The electric force exerted on a positive test
chargebyanelectricfieldisinthesame
directionastheelectricfield.
10.3.A.3
The electric field is a vector quantity and can
be represented in space using vector field
maps.
continued on next page
Return to Table of Contents
UNIT
Electric Force, Field, and Potential
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
10.3.A
10.3.A.3.i
Describe the electric field
produced by a charged
object or configuration of
point charges.
Thenetelectricfieldatagivenlocationis
thevectorsumofindividualelectricfields
created by nearby charged objects.
10.3.A.3.ii
Electricfieldmapsusevectorstodepict
the magnitude and direction of the electric
fieldatmanylocationswithinagivenregion.
10.3.A.3.iii
Electricfieldlinediagramsaresimplified
modelsofelectricfieldmapsandcanbe
used to determine the relative magnitude
anddirectionoftheelectricfieldatany
position in the diagram.
10.3.B
10.3.B.1
Describe the electric field
generated by charged
conductors or insulators.
While in electrostatic equilibrium, the excess
charge of a solid conductor is distributed on
the surface of the conductor, and the electric
fieldwithintheconductoriszero.
10.3.B.1.i
At the surface of a charged conductor, the
electricfieldisperpendiculartothesurface.
10.3.B.1.ii
Theelectricfieldoutsideanisolated
sphere with spherically symmetric charge
distributionisthesameastheelectricfield
due to a point charge with the same net
charge as the sphere located at the center
of the sphere.
10.3.B.2
While in electrostatic equilibrium, the excess
charge of an insulator is distributed throughout
the interior of the insulator as well as at the
surface, and the electric field within the
insulatormayhaveanonzerovalue.
BOUNDARY STATEMENT
AP Physics 2 only expects students to make calculations of the electric field
resulting from four or fewer charged objects or systems. Analysis of the electric field
resulting from more charges is allowed in situations of high symmetry. Students will
only be expected to perform qualitative analysis of electric fields within insulators.
Return to Table of Contents
UNIT
Electric Force, Field, and Potential
```

### ap_physics_2 10.4 Electric Potential Energy (Unit 10: Electric Force, Field, and Potential)
Official CED text (governs):
```
TOPIC 10.4
SUGGESTED SKILLS
Electric Potential
Energy
1.C
Create qualitative sketches
of graphs that represent
features of a model or
the behavior of a physical
system.
2.A
Derive a symbolic
expression from known
quantities by selecting
and following a logical
mathematical pathway.
Required Course Content
2.D
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
10.4.A
10.4.A.1
Describe the electric
potential energy of a system.
The electric potential energy of a system of
two point charges equals the amount of work
required for an external force to bring the
point charges to their current positions from
infinitely far away.
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
10.4.A.2
The general form for the electric potential
energy of two charged objects is given by the
equation
10.4.A.3
The total electric potential energy of a system
can be determined by finding the sum of the
electric potential energies of the individual
interactions between each pair of charged
objects in the system.
BOUNDARY STATEMENT
As the methods to calculate the electric potential energy due to extended
charge distributions exceed the scope of the course, AP Physics 2 only requires
that students calculate the electric potential energy of configurations of four or
fewer point charges.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
Electric Force, Field, and Potential
```

### ap_physics_2 11.1 Electric Current (Unit 11: Electric Circuits)
Official CED text (governs):
```
TOPIC 11.1
SUGGESTED SKILLS
Electric Current
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
2.C
Compare physical
quantities between two
or more scenarios or
at different times and
locations in a single
scenario.
Required Course Content
3.B
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
11.1.A
11.1.A.1
Describe the movement of
electric charges through a
medium.
Current is the rate at which charge passes
throughacross-sectionalareaofawire.
Relevant equation:
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
11.1.A.1.i
Electric charge moves in a circuit in
responsetoanelectricpotentialdifference,
sometimes referred to as electromotive
force, or emf ( ).
11.1.A.1.ii
Ifthecurrentiszeroinasectionofwire,
the net motion of charge carriers in the
wireisalsozero,althoughindividualcharge
carrierswillnothavezerospeed.
11.1.A.2
Although current is not a vector quantity, it
does have a direction. The direction of current
is associated with what the motion of positive
charge would be but not with any coordinate
system in space.
11.1.A.2.i
The direction of conventional current is
chosen to be the direction in which positive
charge would move.
11.1.A.2.ii
In common circuits, current is actually due
to the movement of electrons (negative
charge carriers).
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
Electric Circuits
```

### ap_physics_2 11.2 Simple Circuits (Unit 11: Electric Circuits)
Official CED text (governs):
```
TOPIC 11.2
Simple Circuits
2.C
Compare physical
quantities between two
or more scenarios or
at different times and
locations in a single
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
11.2.A
11.2.A.1
Describe the behavior of a
circuit.
A circuit is composed of electrical loops, which
may include circuit elements such as wires,
batteries, resistors, lightbulbs, capacitors,
switches, ammeters, and voltmeters.
11.2.A.2
A closed electrical loop is a closed path
through which charges may flow.
11.2.A.2.i
A closed circuit is one in which charges
wouldbeabletoflow.
11.2.A.2.ii
An open circuit is one in which charges
wouldnotbeabletoflow.
11.2.A.2.iii
A short circuit is one in which charges
wouldbeabletoflowwithnochangein
potentialdifference.
11.2.A.3
A single circuit element may be part of multiple
electrical loops.
11.2.A.4
Circuit schematics are representations used to
describeandanalyzeelectriccircuits.
11.2.A.4.i
The properties of an electric circuit are
dependent on the physical arrangement of
its constituent elements.
continued on next page
Return to Table of Contents
UNIT
Electric Circuits
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
11.2.A
11.2.A.4.ii
Describe the behavior of a
circuit.
Circuit elements have common symbols
that are used to create schematic
diagrams. Variable elements are indicated
by a diagonal strikethrough arrow across
the standard symbol for that element.
Battery
Bulb
Switch
Capacitor
Resistor
A
Ammeter
V
Voltmeter
BOUNDARY STATEMENT
Unless otherwise specified, all circuit schematic diagrams will be drawn using
conventional current.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.B
Create quantitative graphs
with appropriate scales
and units, including plotting
data.
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
Electric Circuits
```

### ap_physics_2 11.3 Resistance, Resistivity, and Ohm's Law (Unit 11: Electric Circuits)
Official CED text (governs):
```
TOPIC 11.3
Resistance,
Resistivity, and
Ohm’s Law
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
11.3.A
11.3.A.1
Describe the resistance of
an object using physical
properties of that object.
Resistance is a measure of the degree to which
an object opposes the movement of electric
charge.
11.3.A.2
3.B
The resistance of a resistor with uniform
geometry is proportional to its resistivity and
length and is inversely proportional to its
cross-sectionalarea.
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
Relevant equation:
11.3.A.2.i
Resistivity is a fundamental property of a
material that depends on its atomic and
molecularstructureandquantifieshow
strongly the material opposes the motion
of electric charge.
11.3.A.2.ii
The resistivity of a conductor typically
increases with temperature.
11.3.B
11.3.B.1
Describe the electrical
characteristics of elements
of a circuit.
Ohm’s law relates current, resistance, and
potential difference across a conductive
element of a circuit.
Relevant equation:
continued on next page
Return to Table of Contents
UNIT
Electric Circuits
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
11.3.B
11.3.B.1.i
Describe the electrical
characteristics of elements
of a circuit.
Materials that obey Ohm’s law have
constant resistance for all currents and are
called ohmic materials.
11.3.B.1.ii
The resistivity of an ohmic material is
constant regardless of temperature.
11.3.B.1.iii
Resistors can also convert electrical energy
to thermal energy, which may change the
temperature of both the resistor and the
resistor’s environment.
11.3.B.1.iv
The resistance of an ohmic circuit element
can be determined from the slope of a
graph of the current in the element as a
functionofthepotentialdifferenceacross
the element.
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.C
Create qualitative sketches
of graphs that represent
features of a model or
the behavior of a physical
system.
Electric Circuits
```

### ap_physics_2 11.4 Electric Power (Unit 11: Electric Circuits)
Official CED text (governs):
```
TOPIC 11.4
Electric Power
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
11.4.A
11.4.A.1
Describe the transfer of
energy into, out of, or within
an electric circuit, in terms of
power.
The rate at which energy is transferred,
converted, or dissipated by a circuit element
depends on the current in the element and the
electric potential difference across it.
Relevant equation:
Derived equations:
11.4.A.2
The brightness of a bulb increases with power,
so power can be used to qualitatively predict
the brightness of bulbs in a circuit.
Return to Table of Contents
UNIT
Electric Circuits
```

### ap_physics_2 11.6 Kirchhoff's Loop Rule (Unit 11: Electric Circuits)
Official CED text (governs):
```
TOPIC 11.6
Kirchhoff’s Loop Rule
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
3.B
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
11.6.A
11.6.A.1
Describe a circuit or
elements of a circuit by
applying Kirchhoff’s loop rule.
Energy changes in simple electrical circuits
may be represented in terms of charges
moving through electric potential differences
within circuit elements.
Relevant equation:
11.6.A.2
Kirchhoff’s loop rule is a consequence of the
conservation of energy.
11.6.A.3
Kirchhoff’s loop rule states that the sum of
potential differences across all circuit elements
inasingleclosedloopmustequalzero.
Relevant equation:
11.6.A.4
The values of electric potential at points in
a circuit can be represented by a graph of
electric potential as a function of position
within a loop.
Return to Table of Contents
UNIT
Electric Circuits
```

### ap_physics_2 11.7 Kirchhoff's Junction Rule (Unit 11: Electric Circuits)
Official CED text (governs):
```
TOPIC 11.7
SUGGESTED SKILLS
Kirchhoff’s
Junction Rule
Required Course Content
LEARNING OBJECTIVE
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
11.7.A
11.7.A.1
Describe a circuit or
elements of a circuit by
applying Kirchhoff’s junction
rule.
Kirchhoff’s junction rule is a consequence of
the conservation of electric charge.
11.7.A.2
Kirchhoff’s junction rule states that the total
amount of charge entering a junction per unit
time must equal the total amount of charge
exiting that junction per unit time.
Compare physical
quantities between two
or more scenarios or
at different times and
locations in a single
scenario.
3.C
Justify or support a claim
using evidence from
experimental data, physical
representations, or physical
principles or laws.
Relevant equation:
Return to Table of Contents
UNIT
SUGGESTED SKILLS
1.B
Create quantitative graphs
with appropriate scales
and units, including plotting
data.
1.C
Create qualitative sketches
of graphs that represent
features of a model or
the behavior of a physical
system.
Electric Circuits
```

### ap_physics_2 9.2 The Ideal Gas Law (Unit 9: Thermodynamics)
Official CED text (governs):
```
TOPIC 9.2
SUGGESTED SKILLS
The Ideal Gas Law
1.A
Create diagrams, tables,
charts, or schematics
to represent physical
situations.
2.C
Compare physical
quantities between two
or more scenarios or
at different times and
locations in a single
scenario.
Required Course Content
3.B
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
9.2.A
9.2.A.1
Describe the properties of an
ideal gas.
The classical model of an ideal gas assumes
that the instantaneous velocities of atoms
are random, the volumes of the atoms are
negligible compared to the total volume
occupied by the gas, the atoms collide
elastically, and the only appreciable forces
on the atoms are those that occur during
collisions.
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
9.2.A.2
An ideal gas is one in which the relationships
between pressure, volume, the number of
moles or number of atoms, and temperature of
a gas can be modeled using the equation
PV = nRT = NkBT .
9.2.A.3
Graphs modeling the pressure, temperature,
and volume of gases can be used to describe
or determine properties of that gas.
9.2.A.4
Atemperatureatwhichanidealgashaszero
pressure can be extrapolated from a graph of
pressure as a function of temperature.
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
or more scenarios or
at different times and
locations in a single
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
Thermodynamics
```

### ap_physics_2 9.3 Thermal Energy Transfer and Equilibrium (Unit 9: Thermodynamics)
Official CED text (governs):
```
TOPIC 9.3
Thermal Energy
Transfer and
Equilibrium
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
9.3.A
9.3.A.1
Describe the transfer of
energy between two systems
in thermal contact due to
temperature differences of
those two systems.
Two systems are in thermal contact if the
systems may transfer energy by thermal
processes.
9.3.A.1.i
Heating is the transfer of energy into a
system by thermal processes.
9.3.A.1.ii
Cooling is the transfer of energy out of a
system by thermal processes.
9.3.A.2
The thermal processes by which energy may
be transferred between systems at different
temperatures are conduction, convection, and
radiation.
9.3.A.3
Energy is transferred through thermal processes
spontaneouslyfromahigher-temperature
systemtoalower-temperaturesystem.
9.3.A.3.i
Incollisionsbetweenatomsfromdifferent
systems, energy is most likely to be
transferredfromhigher-energyatomsto
lower-energyatoms.
9.3.A.3.ii
After many collisions of atoms from
differentsystems,themostprobablestate
is one in which both systems have the
same temperature.
9.3.A.4
Thermal equilibrium results when no net energy
is transferred by thermal processes between
two systems in thermal contact with each other.
Return to Table of Contents
UNIT
Thermodynamics
```

### ap_physics_2 9.5 Specific Heat and Thermal Conductivity (Unit 9: Thermodynamics)
Official CED text (governs):
```
TOPIC 9.5
SUGGESTED SKILLS
Specific Heat and
Thermal Conductivity
Required Course Content
1.B
Create quantitative graphs
with appropriate scales
and units, including plotting
data.
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
9.5.A
9.5.A.1
Describe the energy required
to change the temperature
of an object by a certain
amount.
The amount of energy required to change
the temperature of a material is related to the
material’s specific heat.
Relevant equation:
9.5.A.2
The specific heat of a material is an intrinsic
property of that material that depends on the
arrangement and interactions of the atoms that
make up the material.
9.5.B
9.5.B.1
Describe the rate at which
energy is transferred by
conduction through a given
material.
The rate at which energy is transferred
by conduction through a given material
is related to the thermal conductivity, the
physical dimensions of the material, and the
temperature difference across the material.
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
3.B
Apply an appropriate law,
definition, theoretical
relationship, or model to
make a claim.
Relevant equation:
9.5.B.2
The thermal conductivity of a material is an
intrinsic property of that material that depends
on the arrangement and interactions of the
atoms that make up the material.
BOUNDARY STATEMENT
AP Physics 2 will model specific heat as independent of temperature.
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
or more scenarios or
at different times and
locations in a single
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
Thermodynamics
```

### ap_physics_2 9.6 Entropy and the Second Law of Thermodynamics (Unit 9: Thermodynamics)
Official CED text (governs):
```
TOPIC 9.6
Entropy and the
Second Law of
Thermodynamics
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
9.6.A
9.6.A.1
Describe the change in
entropy for a given system
over time.
The second law of thermodynamics states
that the total entropy of an isolated system
can never decrease and is constant only
when all processes the system undergoes are
reversible.
9.6.A.2
Entropy can be qualitatively described as
the tendency of energy to spread or the
unavailability of some of the system’s energy to
do work.
9.6.A.2.i
Localizedenergywilltendtodisperseand
spread out.
9.6.A.2.ii
Entropy is a state function and therefore
only depends on the current state or
configurationofasystem,nothowthe
system reached that state.
9.6.A.2.iii
Maximum entropy occurs when a system is
in thermodynamic equilibrium.
9.6.A.3
The change in a system’s entropy is
determined by the system’s interactions with
its surroundings.
9.6.A.3.i
Isolated systems spontaneously move
toward thermodynamic equilibrium.
continued on next page
Return to Table of Contents
UNIT
Thermodynamics
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
9.6.A
9.6.A.3.ii
Describe the change in
entropy for a given system
over time.
The entropy of an isolated system never
decreases, but the entropy of a closed
system can decrease because energy can
be transferred into or out of the system.
BOUNDARY STATEMENT
Only qualitative treatment of the second law of thermodynamics is within the
scope of AP Physics 2.
Return to Table of Contents
THIS PAGE IS INTENTIONALLY LEFT BLANK.
AP PHYSICS 2
UNIT 10
Electric Force,
Field, and
Potential
15–18%
AP EXAM WEIGHTING
~14–21
CLASS PERIODS
Return to Table of Contents
Remember to go to AP Classroom
to assign students the online
Progress Check for this unit.
Whether assigned as homework or
completed in class, the Progress
Check provides each student with
immediate feedback related to this
unit’s topics and science practices.
Progress Check 10
Multiple-choice: ~24 questions
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
15–18% AP EXAM WEIGHTING
~14–21 CLASS PERIODS
Electric Force, Field,
and Potential
Developing Understanding
§ How can you suspend a
charged water droplet in
the air?
Unit 10 begins the study of electrostatic phenomena at a fundamental level, introducing
students to the model of field forces. Despite the topical shift from gases to charged
particles, this unit continues the study of interactions and change. Unit 10 reinforces the idea
that interactions can be described by forces, and that the electric force, like the other forces
introduced in AP Physics 1, can be described with Newton’s laws. Students are encouraged
to apply fundamental physics principles studied in AP Physics 1 when learning about fields
(gravitational and electric) and the forces experienced by objects in a field.
§ Where is the safest
place to be during a
lightning storm?
Building the
Science Practices
ESSENTIAL
QUESTIONS
§ Since balloons are made
```


## AP Physics 2 CED fact pack (course-wide sections and units up to 11)
# AP Physics 2: Algebra-Based - CED Fact Pack

Status: Primary-source verified, deep tier (all 7 units, 9-15 — full assessed scope). Use this version for 2026-27 authoring and review. Mirrored into this repo from Google Drive on 2026-08-03 so all subject fact packs live in one place; no content was changed in the move. Brought from bare (topic-map/weighting only) to deep tier on 2026-08-08 — see Source control and Section 5 below.

## Source control

Source document: College Board, AP Physics 2: Algebra-Based Course and Exam Description.

Edition: "Effective Fall 2024," copyright 2026 College Board. David-supplied primary-source PDF, extracted and verified directly.

No local copy of the source PDF exists in this repo's `docs/teaching/` directory as of 2026-08-03 — unlike the Statistics/Precalculus/Calculus/Chemistry fact packs, this one cannot cite a local file path or SHA-256. If the PDF is added to `docs/teaching/`, update this section with its path and hash.

Drive fact-pack source: "AP Physics 2 2026-27 — CED Fact Pack (v3, primary source, use this one — v2 was a placeholder error)", file ID `10jX6Pmtd6vxhg-iqKAPh56UCyjy5l4kLFZC2AOaUo84`, created 2026-07-23.

This replaces the earlier fact pack (© 2020 edition), which is now out of date. The course was restructured for 2024-25: **the Fluids unit has been removed from AP Physics 2 entirely.** Units are now numbered 9-15 (continuing the numbering sequence from AP Physics 1, which occupies units 1-8 — see the AP Physics 1 fact pack, which confirms Fluids moved there as the new Unit 8, closing the open follow-up noted in the original Physics 2 document).

**2026-08-08 deep-tier build (this session — first Physics 2 pass off bare tier).** This fact pack previously contained only the topic map and MC weighting table (Sections 1-4 below); no per-topic equations, boundary statements, or misconception data had been extracted. David supplied the full primary-source document set for the first time this session:
- `ap-physics-2-course-and-exam-description.pdf` — the full 231-page CED (Fall 2024 edition, "Course Framework V.1"), read directly page-by-page for all 7 units (9-15) via the PDF's rendered pages, not text extraction alone (equations in this CED are embedded as images and do not survive plain-text extraction — every equation below was read visually off the actual page).
- `ap-physics-2-course-and-exam-description-clarifications.pdf` — a short (2-page) Fall-2026 clarifications/corrections document. It changes two things relevant to authoring: (1) the MC section is now **42 questions in 85 minutes** (was 40/80) and the FRQ section is **95 minutes** (was 100), and (2) EK 15.7.B.1 was reworded to: "Radioactive decay is the spontaneous transformation of a nucleus into one or more different nuclei, or to a lower energy level of the same nucleus."
- `ap25-cr-report-physics-2.pdf` — 2025 Chief Reader Report, read in full (all 4 FRQs).
- `ap25-sg-physics-2.pdf` — 2025 Scoring Guidelines, read in full (all 4 FRQs).
- `ap25-frq-physics-2.pdf` and `ap26-frq-physics-2.pdf` — the 2025 and 2026 released free-response booklets, both read in full.
- `ap25-apc-physics-2-q1.pdf` and `ap25-apc-physics-2-q2.pdf` — 2025 Sample Student Responses and Scoring Commentary booklets. The scoring-guideline text embedded in these booklets was read and cross-checked against `ap25-sg-physics-2.pdf` (identical); the student-sample images and scoring-commentary annotations are embedded as scanned images without an extractable text layer, so **misconception/error-rate evidence in this fact pack is drawn from the Chief Reader Report's quantitative summaries (percentages, common-error tables), not by independently re-reading the scanned commentary** — flagged here as a methodology note, not a gap, since the Chief Reader Report is itself College Board's synthesis of that same commentary.

**All 7 units of AP Physics 2 (9-15) — its full assessed scope — are now deep tier.** See Section 5 below. **One topic-map correction found and fixed:** Unit 14 (Waves, Sound, and Physical Optics) actually has **9 topics (14.1-14.9)**, not 5 as the prior topic map in Section 3 stated — the CED's own Unit 14 "Unit at a Glance" table lists 14.6 Wave Interference and Standing Waves, 14.7 Diffraction, 14.8 Double-Slit Interference, and 14.9 Thin-Film Interference in addition to the previously-listed 14.1-14.5. This is now corrected in Section 3. All other unit topic counts (9: 6 topics, 10: 7, 11: 8, 12: 4, 13: 4, 15: 8) were re-verified against the primary source and found accurate. One further correction: Topic 9.3's title was previously misrendered in this document as "Thermal Energy Transfer and (Specific Heat/Calorimetry)"; the CED's actual title is **"Thermal Energy Transfer and Equilibrium"** — corrected in Section 3.

**Confirmed low/zero-FRQ-coverage area:** Unit 13 (Geometric Optics) had **zero FRQ items in either the 2025 or 2026 released exam** — neither year's four-question FRQ set touches mirrors, lenses, reflection, or refraction. (2025 FRQs: Q1 Magnetism/Unit 12, Q2 Thermodynamics/Unit 9, Q3 RC Circuits/Units 10-11, Q4 Double-Slit Interference/Units 14-15. 2026 FRQs: Q1 Thermodynamics/Unit 9, Q2 Photon Emission/Unit 15, Q3 Magnetism (experimental)/Unit 12, Q4 Electric Potential/Unit 10.) Unit 13's CED content below is fully primary-source-verified and safe to author against, but — mirroring the convention this session's Physics 1 pass used for its Fluids unit — there is no released-exam misconception/scoring-pattern evidence to ground Unit 13 question-writing yet. Re-check this gap once a Unit 13 FRQ is released.

## 1. Exam structure

- 3 hours, hybrid digital exam (Bluebook + handwritten FRQ booklets).
- Algebra-based (no calculus).

## 2. Units and MC exam weighting (verified, primary source, current edition)

| Unit | Title | MC Weighting |
|---|---|---|
| 9 | Thermodynamics | 15-18% |
| 10 | Electric Force, Field, and Potential | 15-18% |
| 11 | Electric Circuits | 15-18% |
| 12 | Magnetism and Electromagnetism | 12-15% |
| 13 | Geometric Optics | 12-15% |
| 14 | Waves, Sound, and Physical Optics | 12-15% |
| 15 | Modern Physics | 12-15% |

**7 units total, numbered 9-15. No Fluids unit** (was Unit 1 in the old 2020 edition — removed, not merely renumbered). Optics is now split into two separate units (13: Geometric Optics; 14: Waves, Sound, and Physical Optics) rather than one combined optics unit.

## 3. Topic map (verified from primary source, current edition)

Unit 9 (Thermodynamics): 9.1 Kinetic Theory of Temperature and Pressure, 9.2 The Ideal Gas Law, 9.3 Thermal Energy Transfer and Equilibrium (corrected 2026-08-08 — the title in this document was previously misrendered as "Thermal Energy Transfer and (Specific Heat/Calorimetry)"), 9.4 The First Law of Thermodynamics, 9.5 Specific Heat and Thermal Conductivity, 9.6 Entropy and the Second Law of Thermodynamics

Unit 10 (Electric Force, Field, and Potential): 10.1 Electric Charge and Electric Force, 10.2 Conservation of Electric Charge and Charge Distribution, 10.3 Electric Fields, 10.4 Electric Potential Energy, 10.5 Electric Potential, 10.6 Capacitors, 10.7 Conservation of Electric Energy

Unit 11 (Electric Circuits): 11.1 Electric Current, 11.2 Simple Circuits, 11.3 Resistance, Resistivity, and Ohm's Law, 11.4 Electric Power, 11.5 Compound Direct Current (DC) Circuits, 11.6 Kirchhoff's Loop Rule, 11.7 Kirchhoff's Junction Rule, 11.8 Resistor-Capacitor (RC) Circuits

Unit 12 (Magnetism and Electromagnetism): 12.1 Magnetic Fields, 12.2 Magnetism and Moving Charges, 12.3 Magnetism and Current-Carrying Wires, 12.4 Electromagnetic Induction and Faraday's Law

Unit 13 (Geometric Optics): 13.1 Reflection, 13.2 Images Formed by Mirrors, 13.3 Refraction, 13.4 Images Formed by Lenses

Unit 14 (Waves, Sound, and Physical Optics): 14.1 Properties of Wave Pulses and Waves, 14.2 Periodic Waves, 14.3 Boundary Behavior of Waves and Polarization, 14.4 Electromagnetic Waves, 14.5 The Doppler Effect, 14.6 Wave Interference and Standing Waves, 14.7 Diffraction, 14.8 Double-Slit Interference and Diffraction Gratings, 14.9 Thin-Film Interference (**corrected 2026-08-08 — this unit has 9 topics, not the 5 previously listed here; 14.6-14.9 were missing from this document**)

Unit 15 (Modern Physics): 15.1 Quantum Theory and Wave-Particle Duality, 15.2 The Bohr Model of Atomic Structure, 15.3 Emission and Absorption Spectra, 15.4 Blackbody Radiation, 15.5 The Photoelectric Effect, 15.6 Compton Scattering, 15.7 Fission, Fusion, and Nuclear Decay, 15.8 Types of Radioactive Decay

## 4. Authoring/review guidance

- **Do not author or approve any AP Physics 2 content about fluids/buoyancy/pressure/Bernoulli's principle — that topic no longer exists in this course.** Any existing `apphy2-*` items on fluids need to be flagged: per the AP Physics 1 fact pack, that content now belongs in Physics 1 (Unit 8) instead.
- Algebra-based only — no calculus notation.
- Optics is two units now, not one: geometric optics (mirrors/lenses/reflection/refraction) is Unit 13; wave/sound/physical optics (interference, diffraction, Doppler, EM waves) is Unit 14. Don't conflate them when tagging content.
- Historical note (resolved): the original Drive document flagged an open follow-up asking where Fluids went after being removed from Physics 2. The AP Physics 1 fact pack (mirrored alongside this one) confirms Fluids is now Physics 1's Unit 8 — that follow-up is closed.
- **New (2026-08-08): the MC/FRQ timing changed for Fall 2026.** MC is 42 questions / 85 minutes (was 40/80); FRQ is 4 questions / 95 minutes (was 100). Update any authoring guidance or timed-practice tooling that references the old 40Q/80min, 100min figures.
- **New (2026-08-08): Physics 2's reference-sheet value of g is 9.8 m/s², not 10 m/s².** Unlike AP Physics 1 — whose CED explicitly instructs "g = 10 m/s² will be used... students will not be penalized for correctly using... 9.81 m/s² or 9.8 m/s²" — nowhere in the Physics 2 CED does "g = 10" appear. The Physics 2 Table of Information reference sheet lists only `g = 9.8 m/s²` / `g = 9.8 N/kg`. Do not carry the Physics 1 "use 10, allow 9.8" convention into Physics 2 authoring or grading — use 9.8 as the expected value.

## 5. Units 9-15 deep-tier detail (2026-08-08 addition)

This section deepens all 7 units (9-15) — Physics 2's full assessed scope — from the bare topic-map/weighting-only tier this document previously had, to the same tier as the Physics 1 and Physics C: E&M fact packs. Sources: the full CED PDF (every unit read directly, page-by-page, off the rendered pages so embedded equation images could be transcribed exactly — not from plain-text extraction, which loses all equations in this document), the Fall-2026 clarifications/corrections document, the 2025 Chief Reader Report, the 2025 Scoring Guidelines, and the 2025 and 2026 released FRQ booklets. Every equation, LO/EK claim, and boundary statement below was read directly from the CED page cited; every misconception/scoring claim was read directly from the named 2025 source. As this is an algebra-based course (like Physics 1), no derivative/integral notation is used below or should be used in authored content — mirror Physics 1's algebra-only convention, not Physics C's calculus notation.

### General exam-wide conventions (apply across all 7 units)

Physics 2's Table of Information (the reference sheet given to every student during the exam) states these conventions apply "unless otherwise stated":
- The frame of reference is inertial.
- Frictional forces are negligible.
- Strings, springs, batteries, wires, and meters are ideal.
- Resistors and lightbulbs are ohmic.
- Ideal gases are monatomic.
- The electric potential is zero at an infinite distance from an isolated point charge.
- Current is conventional current.
- Capacitors are air-filled (dielectric constant κ = 1 unless otherwise stated).
- The small-angle approximation is valid for single- and double-slit diffraction.
- **g = 9.8 m/s² (= 9.8 N/kg)** — the only value of g given anywhere in this course's materials (see the authoring-guidance note above; this is a genuine difference from Physics 1's "use 10" convention).

Vector/force-diagram convention (confirmed in the 2025 Scoring Guidelines' example responses and repeated verbatim in the 2025 FRQ Q2 instructions): **"Each force must be represented by a distinct arrow starting on, and pointing away from, the dot."** This is the same convention documented in the Physics 1 fact pack — treat it as a standing convention across the whole algebra-based Physics 1/2 family, not unit- or course-specific.

Free-response task-verb definitions (from the CED's "Task Verbs Used in Free-Response Questions" glossary — these recur constantly in scoring guidelines and should inform how authored rubrics are worded):
- **Derive:** "Starting with a fundamental law or relationship, perform a series of mathematical steps to arrive at a final answer." (Nearly every FRQ derivation part opens with an instruction to "begin your derivation by writing a fundamental physics principle or an equation from the reference information" — this is not boilerplate, it is graded as its own point in the Scoring Guidelines, e.g. 2025 Q1 point A3, Q2 point B1.)
- **Justify:** "Provide qualitative reasoning beyond mathematical derivations or expressions to support, qualify, or defend a claim." (2026 FRQs repeatedly require justifications that "must include conceptual reasoning beyond algebraic solutions" — a derivation alone does not earn justification credit.)
- **Indicate:** "Provide information about a specified topic, without elaboration or explanation" — lower-bar than Justify; used for direction/greater-than-less-than selections that get their own point separate from the justification.
- **Estimate:** "Roughly calculate... based on experimental evidence or provided data. When making estimations, showing steps in calculations are not required."

Cross-unit scoring conventions found repeatedly in the 2025 Scoring Guidelines (all four FRQs):
- **"Vector notation is not required for this point to be earned"** is stated explicitly as a scoring note on multiple derivation points (2025 Q1 point A3, Q2 point B1) — do not require vector arrow notation over quantities in rubrics unless the CED specifically calls for a directional answer.
- **"A correct, isolated, final expression earns points X, Y, and Z"** — a recurring credit-consolidation pattern: if a student's final simplified answer is correct, they retroactively earn every intermediate derivation point even without showing each intermediate substitution explicitly (2025 Q1 points A4-A7; Q2 points B2-B4). Mirror this when writing multi-point derivation rubrics — full-credit final answers should not be penalized for skipped algebra shown.
- **Follow-through/error-carried-forward credit is real and part-specific**, same as documented in the Physics 1 pack. 2025 Q2 part D's scoring notes spell out three explicit branches: a justification consistent with an earlier incorrect diagram/derivation/graph earns the justification point even though the underlying physics was wrong, and can earn the selection point too if the two are mutually consistent.
- **Functional-dependence answers do not need to cancel/simplify correctly to earn a linearization point** (2025 Q3 point C1 scoring note: "Any response that correctly identifies the functional dependence between varied quantities earns this point, regardless of any coefficients that contain numbers or physical/fundamental constants, or which axis is chosen to graph each of those quantities") — the same "functional dependence credited even if not perfectly executed" pattern the Physics 1 pack documents for Unit 4-8 content, now confirmed in Physics 2 as well.
- Scientific notation and unit errors are real, repeated failure points: 2025 Q3's Chief Reader Report flags that dropping the `×10⁻¹⁰` scientific-notation factor when computing capacitance from a slope was a common, scored error (responses landed at `C ≈ 0.8 F` instead of `~8×10⁻¹¹ F`) — a good item-design trap to reuse (embed small-magnitude scientific notation in tabulated data and see whether students carry it through a slope calculation).

### Unit 9 — Thermodynamics (15-18%)

**9.1 Kinetic Theory of Temperature and Pressure.** Pressure from a gas is the ratio of the sum of the magnitudes of the perpendicular force components exerted by the gas's atoms on a surface to that surface's area: $P = F_\perp/A$; pressure exists throughout the gas, not just at its boundary. Temperature is characterized by the atoms' average kinetic energy; the Maxwell-Boltzmann distribution gives a graphical (not functional-form) representation of atomic energies/speeds at a given temperature. Root-mean-square speed relation: $K_{avg} = \tfrac32 k_BT = \tfrac12 mv_{rms}^2$. **Boundary statement (verbatim):** "AP Physics 2 only expects students to perform qualitative and quantitative analysis of collisions in one and two dimensions. Students are not expected to know the functional form of the Maxwell-Boltzmann distribution but are expected to be familiar with how features of the distribution are related to the temperature of the gas."

**9.2 The Ideal Gas Law.** Classical ideal-gas model: instantaneous atomic velocities are random, atomic volumes are negligible vs. total gas volume, collisions are elastic, and only collision forces are appreciable. $PV = nRT = Nk_BT$. Graphs of P, T, V can describe/determine gas properties; the temperature at which an ideal gas would have zero pressure can be extrapolated from a P-vs-T graph. Zero explicit exclusion statements on this topic.

**9.3 Thermal Energy Transfer and Equilibrium.** Two systems are in thermal contact if they can exchange energy thermally. Heating = energy transfer into a system by thermal processes; cooling = energy transfer out. Thermal processes: conduction, convection, radiation. Energy transfers spontaneously from higher- to lower-temperature systems (atomic-collision picture: energy is more likely transferred from higher- to lower-energy atoms; after many collisions the most probable state is equal temperatures). Thermal equilibrium = zero net thermal energy transfer between two systems in contact. Zero explicit exclusion statements.

**9.4 The First Law of Thermodynamics.** Internal energy = sum of kinetic energy of constituent objects + potential energy of their configuration. Ideal-gas atoms don't interact via conservative forces and have no internal structure considered, so an ideal gas has no internal potential energy: $U = \tfrac32 nRT = \tfrac32 Nk_BT$ (monatomic ideal gas). Internal-energy change can occur via internal-structure/behavior changes without moving the system's center of mass. First law = conservation of energy restated for a system's internal-energy accounting for work/heating: $\Delta U = Q + W$; work done on a system by a constant/average external pressure changing its volume: $W = -P\Delta V$. PV diagrams represent thermodynamic processes; isotherms are constant-temperature lines; $|W|$ = area under the P-vs-V curve. Special-case processes: isovolumetric (constant volume), isothermal (constant temperature), isobaric (constant pressure), adiabatic (zero thermal energy transfer). Zero explicit exclusion statements.

**9.5 Specific Heat and Thermal Conductivity.** Energy to change temperature: $Q = mc\Delta T$; specific heat is an intrinsic material property depending on atomic arrangement/interactions. Conductive energy-transfer rate: $Q/\Delta t = kA\Delta T/L$; thermal conductivity is likewise intrinsic. **Boundary statement (verbatim):** "AP Physics 2 will model specific heat as independent of temperature."

**9.6 Entropy and the Second Law of Thermodynamics.** Second law: total entropy of an isolated system never decreases, and is constant only when all processes are reversible. Entropy qualitatively = tendency of energy to spread / unavailability of some energy to do work; localized energy tends to disperse; entropy is a state function depending only on current configuration, not history; maximum entropy occurs at thermodynamic equilibrium. Isolated systems spontaneously move toward equilibrium; an isolated system's entropy never decreases, but a closed system's entropy can decrease because energy can be transferred into/out of it. **Boundary statement (verbatim):** "Only qualitative treatment of the second law of thermodynamics is within the scope of AP Physics 2."

**Documented misconceptions (2025 Question 2, Translation Between Representations, "Ideal Gas Law, Thermal Processes, and PV Diagrams," mean 8.19/12):**
- ~75% correctly identified/labeled the three forces on the piston (gravity, gas, atmosphere) on a free-body diagram, but many omitted the piston's own weight or the atmospheric force, and a number labeled arrows with *pressure* (a scalar) rather than the *force due to* that pressure — the Chief Reader Report explicitly flags "Fpiston" (implying an object exerting force on itself) as a wrong label pattern, alongside generic unsubscripted "applied force" labels.
- Derivation performance (Skill 2.A) was reported as improved vs. prior years (~63% correct), but ~55% of responses that attempted substitutions did so unclearly (no subscripts to identify which quantity was substituted), and a "significant number" of responses did not distinguish pressure from force in a net-force equation (writing $PA - P_{atm}A - Mg = 0$ correctly is credited; mixing bare pressures into a $\Sigma F$ equation is the recurring error).
- ~73% correctly sketched the concave-up PV curve for the described process; a documented distractor pattern is sketching a straight downward-sloping line for two inversely-proportional quantities instead of a concave-up hyperbola — worth reusing as an MC wrong-answer option.
- Only ~43% of responses on the final justification part (D) explicitly tied their claim back to a named earlier part ("In part A...", "In part B..."); the Chief Reader Report's advice is to explicitly train students to name the referenced representation in TBR/QQT justification answers.
- A "correct, isolated final expression" scoring convention was demonstrated concretely here: $U = \tfrac32 P_{atm}V_0$-style derivations earn full credit for points B2-B4 even without every intermediate substitution shown, provided the final isolated answer is correct.

### Unit 10 — Electric Force, Field, and Potential (15-18%)

**10.1 Electric Charge and Electric Force.** Charge is a fundamental property of matter, positive or negative; elementary charge $e$ is the smallest indivisible amount; electron charge $= -e$, proton $= +e$, neutron $=0$. Point charge = model where physical size is negligible for the analysis. Coulomb's law: $|\vec F_E| = \frac{1}{4\pi\varepsilon_0}\frac{|q_1q_2|}{r^2} = k\frac{|q_1q_2|}{r^2}$ — direction depends on sign combination (like charges repel, opposite attract) and is parallel to the line connecting the objects. Electric forces underlie many everyday macroscopic/contact forces (normal, friction, tension) even though those are treated as separate nonfundamental forces for convenience. Gravitational vs. electric force: gravity is always attractive, electrostatic can be either; for objects with both mass and charge, gravitational force is usually much smaller than electrostatic — gravity dominates at large scales only because large-scale systems tend to be electrically neutral. Electric permittivity measures how polarized a material becomes in an external field (induced electron rearrangement separating + and − charge); free space has constant permittivity $\varepsilon_0$; matter's permittivity differs and depends on composition/arrangement; conductors' charge carriers move easily, insulators' do not. **Boundary statement (verbatim):** "AP Physics 2 only expects students to make calculations of the electric force between four or fewer interacting charged objects or systems. The analysis of the resulting electric force from more charges is allowed in situations of high symmetry."

**10.2 Conservation of Electric Charge and the Process of Charging.** A system's net charge/charge distribution can change in response to other systems' presence/changes. Net charge can change via friction/contact; induced charge separation occurs when electrostatic force redistributes charge within a system (polarizing it), including in neutral systems. Charging typically involves electron transfer; net charge stays constant absent a charge transfer to/from the system. Grounding = electrically connecting a charged system to a much larger, approximately neutral system (e.g. Earth). Zero explicit exclusion statements.

**10.3 Electric Fields.** Electric fields originate from charged objects. Field at a point = electric force on a test charge there divided by the test charge's magnitude: $\vec E = \vec F_E/q$; a test charge is small enough not to significantly perturb the field it's testing. Field points away from isolated positive charges, toward isolated negative charges; force on a positive test charge is in the field's direction. Field is a vector, representable via vector field maps; net field at a location = vector sum of individual fields; field line diagrams are simplified field maps usable to infer relative field magnitude/direction anywhere. In electrostatic equilibrium, a solid conductor's excess charge sits on its surface and the field inside is zero; field at a charged conductor's surface is perpendicular to the surface; the field outside an isolated spherically-symmetric charge distribution equals that of an equivalent point charge at the sphere's center. In electrostatic equilibrium, an insulator's excess charge is distributed through its interior as well as surface, and the field inside an insulator may be nonzero. **Boundary statement (verbatim):** "AP Physics 2 only expects students to make calculations of the electric field resulting from four or fewer charged objects or systems. Analysis of the electric field resulting from more charges is allowed in situations of high symmetry. Students will only be expected to perform qualitative analysis of electric fields within insulators."

**10.4 Electric Potential Energy.** Electric PE of a two-point-charge system = work an external force must do to bring the charges to their current positions from infinite separation. General form: $U_E = \frac{1}{4\pi\varepsilon_0}\frac{q_1q_2}{r} = k\frac{q_1q_2}{r}$. Total system PE = sum over all pairwise interactions. **Boundary statement (verbatim):** "As the methods to calculate the electric potential energy due to extended charge distributions exceed the scope of the course, AP Physics 2 only requires that students calculate the electric potential energy of configurations of four or fewer point charges."

**10.5 Electric Potential.** Electric potential = electric PE per unit charge at a point in space. Potential from multiple point charges = scalar superposition: $V = \frac{1}{4\pi\varepsilon_0}\sum_i q_i/r_i$. Potential difference between two points = change in PE per unit charge moving a test charge between them: $\Delta V = \Delta U_E/q$; potential differences can also arise from chemical processes (e.g. separating charge in a battery). Conductors in electrical contact redistribute electrons until their surfaces reach the same potential. Average field between two points = potential difference divided by distance: $|\vec E| = |\Delta V|/\Delta r$. Field vector maps and equipotential lines (isolines of electric potential) are complementary representations; isolines are perpendicular to field vectors and can be constructed from a field map (and vice versa); field vectors point toward decreasing potential; there is no field component along an isoline. **Boundary statement (verbatim):** "As the methods to calculate the electric potential due to extended charges exceed the scope of the course, AP Physics 2 only expects that students calculate the electric potential of configurations of four or fewer particles (or more in situations of high symmetry)."

**10.6 Capacitors.** A parallel-plate capacitor = two separated parallel conducting surfaces holding equal-and-opposite charge. Capacitance relates stored charge magnitude to the potential difference the separated charge creates: $C = Q/\Delta V$; capacitance depends only on the capacitor's physical properties (shape, separating material). Parallel-plate capacitance: $C = \kappa\varepsilon_0 A/d$ (κ = dielectric constant of the material between plates). Field between charged parallel plates (plate separation ≪ plate size) is constant except near the edges: $E_C = Q/(\kappa\varepsilon_0 A)$; a charged particle between the plates undergoes constant acceleration, sharing kinematics with near-surface projectile motion. Capacitor PE = work an external force does to separate that charge onto the plates: $U_C = \tfrac12 Q\Delta V$. Adding a dielectric changes capacitance and induces a field within the dielectric opposite to the field between the plates. **Boundary statement (verbatim):** "While other shapes are also able to separate charges, only the analysis and descriptions of parallel-plate capacitors are required for AP Physics 2. Edge effects will be ignored unless explicitly stated otherwise."

**10.7 Conservation of Electric Energy.** When a charged object moves between two points of different electric potential, the resulting change in electric PE of the object-field system: $\Delta U_E = q\Delta V$. That movement produces a kinetic-energy change consistent with conservation of energy. Zero explicit exclusion statements.

**Coverage note:** the 2025/2026 released FRQs do not include a standalone Unit-10 item, but Unit 10 content is tested in combination with other units: 2025 Q3 (RC circuits, Units 10-11) requires the capacitance relationship $C=Q/\Delta V$ and linearizing charge-vs-potential-difference data (see Unit 11 misconceptions below — same question), and 2026 Q4 (equipotential lines, Unit 10 alone) is a genuine standalone Unit 10 QQT item, but its scoring guidelines/Chief Reader Report were not yet available in the sources reviewed this session (2026 grading data postdates the documents supplied). Treat Unit 10 misconception evidence as thinner than Units 9, 11, 12, and 14 until the 2026 CR report is available.

### Unit 11 — Electric Circuits (15-18%)

**11.1 Electric Current.** Current = rate charge passes through a wire's cross-sectional area: $I = \Delta q/\Delta t$. Charge moves in response to a potential difference (emf, $\mathcal{E}$); if current in a wire section is zero, net charge-carrier motion there is zero even though individual carriers still move. Current is not a vector but does have an associated direction, tied to the direction positive charge would move (not to any coordinate system). Conventional current direction = direction positive charge would move; in real circuits, current is actually due to electron (negative-carrier) motion. Zero explicit exclusion statements on this topic itself (the course-wide conventional-current convention is filed under 11.2 below).

**11.2 Simple Circuits.** A circuit = composed of electrical loops, which may include wires, batteries, resistors, lightbulbs, capacitors, switches, ammeters, voltmeters. A closed electrical loop is a closed charge-flow path; closed circuit = charges can flow; open circuit = charges cannot flow; short circuit = charges can flow with no potential-difference change. A single circuit element may belong to multiple loops. Circuit schematics represent/analyze circuits; a circuit's properties depend on its elements' physical arrangement. Standard schematic symbols given for battery, bulb, switch, capacitor, resistor, ammeter, voltmeter; variable elements get a diagonal strikethrough arrow across the standard symbol. **Boundary statement (verbatim):** "Unless otherwise specified, all circuit schematic diagrams will be drawn using conventional current."

**11.3 Resistance, Resistivity, and Ohm's Law.** Resistance measures an object's opposition to charge movement. For uniform geometry: $R = \rho\ell/A$; resistivity is an intrinsic material property depending on atomic/molecular structure and typically increases with temperature. Ohm's law: $I = \Delta V/R$. Ohmic materials have constant resistance for all currents; an ohmic material's resistivity is constant regardless of temperature (contrast with 11.3.A.2.ii's general statement that resistivity typically increases with temperature — the "ohmic" idealization holds resistivity fixed). Resistors convert electrical to thermal energy, potentially changing the resistor's and its environment's temperature. An ohmic element's resistance can be found from the slope of a current-vs-potential-difference graph. Zero explicit exclusion statements on this topic.

**11.4 Electric Power.** Rate of energy transfer/conversion/dissipation by a circuit element depends on its current and potential difference: $P = I\Delta V$ (relevant equation); derived equations $P = I^2R = (\Delta V)^2/R$. Bulb brightness increases with power, so power can qualitatively predict relative bulb brightness. Zero explicit exclusion statements.

**11.5 Compound Direct Current (DC) Circuits.** Elements may connect in series and/or parallel: series = charge through one element must proceed through all elements in that connection (same current in each); parallel = charge may flow through one or more paths (same potential difference across each path). A resistor collection may be analyzed as one equivalent resistor $R_{eq}$: series $R_{eq,s} = \Sigma_i R_i$; parallel $1/R_{eq,p} = \Sigma_i 1/R_i$; adding parallel paths increases available paths and decreases equivalent resistance. Ideal batteries/wires have negligible internal resistance; wire resistance may be neglected only when the circuit has other elements whose resistance is much larger. A battery's ideal potential difference (its emf, $\mathcal{E}$) is what it would supply with no current; nonideal-battery internal resistance $r$ reduces terminal potential difference when current flows: $\Delta V_{terminal} = \mathcal{E} - Ir$ (derived equation). Ammeters measure current at a specific point and must connect in series with the measured element; ideal ammeters have zero resistance. Voltmeters measure potential difference between two points and must connect in parallel with the measured element; ideal voltmeters have infinite resistance. Nonideal ammeters/voltmeters change the measured circuit's properties. **Boundary statement (verbatim):** "AP Physics 2 only expects students to qualitatively discuss how a nonideal ammeter or voltmeter will affect the results of measurements. Unless otherwise stated, all batteries, wires, and meters are assumed to be ideal. Circuits with batteries of different potential differences connected in parallel will not be assessed."

**11.6 Kirchhoff's Loop Rule.** Energy changes in simple circuits can be represented as charge moving through potential differences within elements: $\Delta U_E = q\Delta V$. Kirchhoff's loop rule is a consequence of conservation of energy; it states the sum of potential differences across all elements in a single closed loop equals zero: $\Sigma\Delta V = 0$. Electric-potential values at points in a circuit can be graphed as a function of position within a loop. Zero explicit exclusion statements.

**11.7 Kirchhoff's Junction Rule.** A consequence of conservation of electric charge; states total charge entering a junction per unit time equals total charge exiting per unit time: $\Sigma I_{in} = \Sigma I_{out}$. Zero explicit exclusion statements.

**11.8 Resistor-Capacitor (RC) Circuits.** A capacitor collection may be analyzed as one equivalent capacitance $C_{eq}$: series $1/C_{eq,s} = \Sigma_i 1/C_i$ (equivalent series capacitance is less than the smallest individual capacitance); parallel $C_{eq,p} = \Sigma_i C_i$. Conservation of charge requires equal-magnitude charge on each series capacitor's plates. Time constant $\tau = R_{eq}C_{eq}$ is a significant RC-circuit feature: for a charging capacitor, $\tau$ is the time for charge to rise from zero to ~63% of its final asymptotic value; for a discharging capacitor, $\tau$ is the time for charge to fall from full to ~37% of its initial value. Potential difference/current across the capacitor branch both change over time as the capacitor (dis)charges, approaching steady state after a long interval: immediately after connection, an uncharged capacitor acts like a wire (charge flows freely to/from its plates); as it charges, potential difference/current/stored energy all change and asymptotically approach steady-state; after a long time a charging capacitor reaches maximum potential difference and zero branch current; immediately upon discharging, stored charge/energy begin decreasing; while discharging, charge/potential-difference/current all decrease toward steady state; for times ≫ τ, both charging and discharging branches may be modeled with steady-state conditions. **Boundary statement (verbatim):** "Descriptions of charging/discharging RC circuits in AP Physics 2 are limited to qualitative descriptions and representations. While students should be able to mathematically describe initial and final states of RC circuits, students are not expected to mathematically model these behaviors with respect to time."

**Documented misconceptions (2025 Question 3, Experimental Design and Analysis, "RC Circuits," mean 7.22/10):**
- ~63% of responses identified appropriate data (capacitor dimensions + a current measurement) to predict τ, but ~46% failed to address a method for reducing experimental uncertainty (repeated trials is the expected minimal answer); some responses padded procedures with unnecessary steps (e.g., describing how to physically assemble the already-given circuit).
- ~90% correctly recognized that charge on one capacitor plate should be graphed against potential difference across the capacitor to linearize $C=Q/\Delta V$, but a documented, specific misconception: some responses **doubled** the one-plate charge value, reasoning "a capacitor has two plates" — the correct relation uses the single-plate charge magnitude only.
- A separate, distinct misconception: treating instantaneous current × elapsed time as if it gave instantaneous charge ($q = It$) — the Chief Reader Report explicitly distinguishes this from the correct incremental relationship, since current in an RC circuit changes continuously over time and a single instantaneous-current reading cannot be multiplied by elapsed time to get charge.
- ~37% of responses correctly propagated the data table's scientific notation (`×10⁻¹⁰`) through the slope calculation to arrive at a capacitance within the accepted range (7-9 ×10⁻¹¹ F); many instead reported nonsensical values like `C ≈ 0.8 F` by silently dropping the exponent — a strong, reusable item-design signal (embed scientific notation in tabulated data specifically to test whether it survives a linearization calculation).
- Graphing mechanics (labeling axes with units, plotting data, drawing a best-fit line) were strong (~85-91% correct) — the weak points cluster specifically around the physics-to-data translation (what to measure/plot) and unit/notation carrying, not graphing skill itself.

