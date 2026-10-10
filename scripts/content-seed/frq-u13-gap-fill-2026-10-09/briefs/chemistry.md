# FRQ writing brief: chemistry

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


# Subject: AP Chemistry (subject_key ap_chemistry)
Format: Short free-response in AP Chemistry style: a chemical system or experiment described in words, with data as a small plain-text table. Parts mix calculation (with units and correct significant figures) and particle-level explanation.
Parts: 3-5. Criteria (points) in total: 4-5.

Accepted item from this subject in this batch (style reference only):
```json
{
 "title": "Interpreting the Photoelectron Spectrum of an Unknown Element",
 "calculator": "not_permitted",
 "stimulus": "A student obtains the photoelectron spectrum of a gaseous sample of an unknown element X. All atoms are in the ground state. The spectrum shows five peaks. The binding energy of each peak and its relative peak height are listed below.\n\nPeak | Binding energy (MJ/mol) | Relative peak height\n1 | 210 | 2\n2 | 18.7 | 2\n3 | 13.5 | 6\n4 | 1.95 | 2\n5 | 1.06 | 3\n\nAnswer the following.",
 "model_answer": "(a) In PES, the relative height of each peak is proportional to the number of electrons in that subshell. Assigning subshells from highest to lowest binding energy: peak 1 = 1s (2 electrons), peak 2 = 2s (2), peak 3 = 2p (6), peak 4 = 3s (2), peak 5 = 3p (3). The configuration is 1s² 2s² 2p⁶ 3s² 3p³. The total is 2 + 2 + 6 + 2 + 3 = 15 electrons, so a neutral atom has 15 protons and X is phosphorus.\n\n(b) Peak 1 corresponds to 1s electrons and peak 4 to 3s electrons. The 1s electrons are in the first shell, much closer to the nucleus, and have no inner electrons shielding them, so they experience a much greater effective nuclear charge. By Coulomb's law, the attraction between the nucleus and the 1s electrons is much stronger than for the 3s electrons, which are farther away and shielded by the 10 electrons in the first and second shells. Therefore much more energy is required to remove a 1s electron.\n\n(c) Sulfur has 16 electrons, with configuration 1s² 2s² 2p⁶ 3s² 3p⁴. The peak with the lowest binding energy corresponds to the 3p subshell, which holds 4 electrons, so its relative height is 4.\n\n(d) The sulfur 1s peak appears at a binding energy greater than 210 MJ/mol. Sulfur has 16 protons compared with 15 for phosphorus, while its 1s electrons are still in the first shell at a similar distance and with no shielding. The greater nuclear charge attracts the 1s electrons more strongly, so more energy is needed to remove them.",
 "verification_python": "heights={'1s':2,'2s':2,'2p':6,'3s':2,'3p':3}\ntotal=sum(heights.values())\nassert total==15\nZ_P=15\nassert total==Z_P\nenergies=[210,18.7,13.5,1.95,1.06]\nassert energies==sorted(energies,reverse=True)\nassert energies[0]>energies[3]\n# sulfur configuration\nZ_S=16\ncaps=[('1s',2),('2s',2),('2p',6),('3s',2),('3p',6)]\nrem=Z_S\nconf={}\nfor s,c in caps:\n    n=min(c,rem)\n    conf[s]=n\n    rem-=n\nassert conf=={'1s':2,'2s':2,'2p':6,'3s':2,'3p':4}\nassert conf['3p']==4\nassert Z_S>Z_P\ninner=heights['1s']+heights['2s']+heights['2p']\nassert inner==10\nprint('ALL_CHECKS_PASSED')",
 "parts": [
  {
   "prompt": "Using the data in the table, write the complete ground-state electron configuration of element X and identify the element. Explain how the relative peak heights support your answer.",
   "criteria": [
    {
     "text": "Gives the configuration 1s² 2s² 2p⁶ 3s² 3p³ and identifies X as phosphorus (P), using the peak heights as electron counts.",
     "evidence": "States the full configuration 1s² 2s² 2p⁶ 3s² 3p³, names phosphorus, and explains that each relative peak height equals the number of electrons in that subshell, totaling 15 electrons.",
     "fix": "Treat each relative peak height as the electron count in a subshell, assign subshells from highest to lowest binding energy, then sum electrons.",
     "accepted_variants": [
      "[Ne] 3s² 3p³",
      "P"
     ]
    }
   ]
  },
  {
   "prompt": "The binding energy of peak 1 (210 MJ/mol) is much greater than that of peak 4 (1.95 MJ/mol). Explain this difference in terms of the interactions between the electrons and the nucleus.",
   "criteria": [
    {
     "text": "Explains that 1s electrons are much closer to the nucleus and experience little shielding, so the Coulombic attraction to the nucleus is much stronger than for 3s electrons.",
     "evidence": "Identifies peak 1 as 1s and peak 4 as 3s, and states that the 1s electrons are closer to the nucleus (smaller distance) and less shielded (greater effective nuclear charge), giving greater Coulombic attraction and requiring more energy to remove.",
     "fix": "Use Coulomb's law: compare distance from the nucleus and shielding by inner electrons for each subshell, then link stronger attraction to larger binding energy.",
     "accepted_variants": []
    }
   ]
  },
  {
   "prompt": "A photoelectron spectrum of sulfur (atomic number 16) is obtained under the same conditions. Identify the relative height of the sulfur peak with the lowest binding energy, and justify your answer using the electron configuration of sulfur.",
   "criteria": [
    {
     "text": "States the lowest-energy (3p) peak of sulfur has a relative height of 4 because sulfur's configuration is 1s² 2s² 2p⁶ 3s² 3p⁴.",
     "evidence": "Gives a relative height of 4 for the lowest binding energy peak and supports it with the configuration ending in 3p⁴ (four 3p electrons).",
     "fix": "Write the configuration of the new element first, then match the lowest binding energy peak to its outermost subshell and count those electrons.",
     "accepted_variants": [
      "4",
      "3p⁴"
     ]
    }
   ]
  },
  {
   "prompt": "Predict whether the 1s peak of sulfur appears at a binding energy greater than, less than, or equal to 210 MJ/mol. Justify your prediction in terms of the interactions between the electrons and the nucleus.",
   "criteria": [
    {
     "text": "Predicts the sulfur 1s peak is at a binding energy greater than 210 MJ/mol because sulfur has one more proton, giving greater nuclear charge and stronger attraction for 1s electrons.",
     "evidence": "Claims greater than 210 MJ/mol and justifies it by sulfur's larger nuclear charge (16 protons versus 15) attracting the 1s electrons, which are in the same shell and essentially unshielded, more strongly.",
     "fix": "For the same subshell in two elements, compare the number of protons; more protons means greater Coulombic attraction and a higher binding energy.",
     "accepted_variants": [
      "greater than",
      "higher"
     ]
    }
   ]
  }
 ]
}
```

## Topics in this subject's Units 1, 2, 3 (stay inside the designated topic)
1.1 Moles and Molar Mass (Unit 1: Atomic Structure and Properties)
1.2 Mass Spectra of Elements (Unit 1: Atomic Structure and Properties)
1.3 Elemental Composition of Pure Substances (Unit 1: Atomic Structure and Properties)
1.4 Composition of Mixtures (Unit 1: Atomic Structure and Properties)
1.5 Atomic Structure and Electron Configuration (Unit 1: Atomic Structure and Properties)
1.6 Photoelectron Spectroscopy (Unit 1: Atomic Structure and Properties)
1.7 Periodic Trends (Unit 1: Atomic Structure and Properties)
1.8 Valence Electrons and Ionic Compounds (Unit 1: Atomic Structure and Properties)
2.1 Types of Chemical Bonds (Unit 2: Compound Structure and Properties)
2.2 Intramolecular Force and Potential Energy (Unit 2: Compound Structure and Properties)
2.3 Structure of Ionic Solids (Unit 2: Compound Structure and Properties)
2.4 Structure of Metals and Alloys (Unit 2: Compound Structure and Properties)
2.5 Lewis Diagrams (Unit 2: Compound Structure and Properties)
2.6 Resonance and Formal Charge (Unit 2: Compound Structure and Properties)
2.7 VSEPR and Hybridization (Unit 2: Compound Structure and Properties)
3.1 Intermolecular and Interparticle Forces (Unit 3: Properties of Substances and Mixtures)
3.10 Solubility (Unit 3: Properties of Substances and Mixtures)
3.11 Spectroscopy and the Electromagnetic Spectrum (Unit 3: Properties of Substances and Mixtures)
3.12 Properties of Photons (Unit 3: Properties of Substances and Mixtures)
3.13 Beer-Lambert Law (Unit 3: Properties of Substances and Mixtures)
3.2 Properties of Solids (Unit 3: Properties of Substances and Mixtures)
3.3 Solids, Liquids, and Gases (Unit 3: Properties of Substances and Mixtures)
3.4 Ideal Gas Law (Unit 3: Properties of Substances and Mixtures)
3.5 Kinetic Molecular Theory (Unit 3: Properties of Substances and Mixtures)
3.6 Deviation from Ideal Gas Law (Unit 3: Properties of Substances and Mixtures)
3.7 Solutions and Mixtures (Unit 3: Properties of Substances and Mixtures)
3.8 Representations of Solutions (Unit 3: Properties of Substances and Mixtures)
3.9 Separation of Solutions and Mixtures (Unit 3: Properties of Substances and Mixtures)

## Targets: write exactly one FRQ for each of these 13 topics

### ap_chemistry 1.1 Moles and Molar Mass (Unit 1: Atomic Structure and Properties)
Official CED text (governs):
```
TOPIC 1.1
Moles and
Molar Mass
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.1.A
1.1.A.1
Calculate quantities of a
substance or its relative
number of particles using
dimensional analysis and the
mole concept.
One cannot count particles directly while
performing laboratory work. Thus, there must
be a connection between the masses of
substances reacting and the actual number of
particles undergoing chemical changes.
1.1.A.2
Avogadro’s number (NA = 6.022 × 1023 mol−1)
provides the connection between the number
of moles in a pure sample of a substance and
the number of constituent particles (or formula
units) of that substance.
1.1.A.3
Expressing the mass of an individual atom
or molecule in atomic mass units (amu) is
useful because the average mass in amu of
one particle (atom or molecule) or formula
unit of a substance will always be numerically
equal to the molar mass of that substance
in grams. Thus, there is a quantitative
connection between the mass of a substance
and the number of particles that the
substance contains.
EQN: n = m/M
Return to Table of Contents
UNIT
Atomic Structure and Properties
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: well_posed: Part (e) is blank despite having a scoring criterion. It provides no task for the student to answer.
- gpt-6.1-sol: rubric_points: Criterion e1 awards an explanation that part (e) does not request; that explanation is requested in part (d). Move e1 to part (d) or supply an appropriate prompt for part (e). Criterion c1 also lists 3.01 × 10²² as accepted while its evidence ex
- deepseek-v4-pro: well_posed: Part (e) is listed but has no prompt, while criterion e1 is assigned to it. There is no answerable part (e) in the question, and the explanation criterion appears only under part (d).
- deepseek-v4-pro: rubric_points: Criterion e1 is assigned to the blank part (e), so it does not belong to an actual part. Criterion c1 also accepts 3.01 × 10^22 as an equivalent of 3.011 × 10^22, but 3.01 × 10^22 has only three significant figures and is not an equivalent form 
- gpt-6.1-sol: rubric_points: Criteria b1 and c1 prescribe calculation methods that the parts do not require. For b1, a valid alternative is dividing the sample mass by the mass per sucrose molecule and multiplying by 11. For c1, a valid alternative is converting 342.30 amu 

### ap_chemistry 1.2 Mass Spectra of Elements (Unit 1: Atomic Structure and Properties)
Official CED text (governs):
```
TOPIC 1.2
SUGGESTED SKILL
Mathematical
Routines
Mass Spectra
of Elements
5.D
Identify information
presented graphically to
solve a problem.
Required Course Content
LEARNING OBJECTIVE
AVAILABLE RESOURCES
§ Classroom Resource >
Exploring Atomic
Structure Using
Photoelectron
Spectroscopy (PES)
Data
ESSENTIAL KNOWLEDGE
1.2.A
1.2.A.1
Explain the quantitative
relationship between the
mass spectrum of an element
and the masses of the
element’s isotopes.
The mass spectrum of a sample containing a
single element can be used to determine the
identity of the isotopes of that element and the
relative abundance of each isotope in nature.
Where possible, available resources are provided that might
help teachers address a particular topic.
Learning objectivesdefinewhatastudentneedstobeable
to do with content knowledge in order to progress toward the
enduring understandings.
Essential knowledgestatementsdefinetherequiredcontent
knowledge associated with each learning objective assessed on
the AP Exam.
1.2.A.2
The average atomic mass of an element can
be estimated from the weighted average of
the isotopic masses using the mass of each
isotope and its relative abundance.
Exclusion Statement: Interpreting mass
spectra of samples containing multiple
elements or peaks arising from species other
than singly charged monatomic ions will not
be assessed on
the AP Exam.
The suggested skilloffersapossibleskilltopairwiththetopic.
Exclusion statementsdefinecontentorspecificdetailsabout
content that will not be assessed on the AP Chemistry Exam.
However, such content may be provided as background or
additional information for the concepts and science practices
being assessed.
| 31
Return to Table of Contents
THIS PAGE IS INTENTIONALLY LEFT BLANK.
AP CHEMISTRY
UNIT 1
Atomic
Structure and
Properties
7–9%
AP EXAM WEIGHTING
~9–10
CLASS PERIODS
Return to Table of Contents
Remember to go to AP Classroom
to assign students the online
Progress Check for this unit.
Whether assigned as homework or
completed in class, the Progress
Check provides each student with
immediate feedback related to this
unit’s topics and skills.
Progress Check 1
Multiple-choice: ~20 questions
Free-response: 2 questions
§ Short
§ Short
Return to Table of Contents
UNIT
7–9% AP EXAM WEIGHTING
~9–10 CLASS PERIODS
Atomic Structure
and Properties
Developing Understanding
ESSENTIAL
QUESTIONS
§ How can the same
element be used in
nuclear fuel rods and
fake diamonds?
§ How can large quantities
of objects be counted
by weighing?
§ If atoms are too small
to be observed directly,
how do we know how
they're structured?
§ Why does the periodic
table have the shape
that it does?
Thisfirstunitsetsthefoundationforthecoursebyexaminingtheatomictheoryofmatter,
the fundamental premise of chemistry. Although atoms represent the foundational level
of chemistry, observations of chemical properties are made on collections of atoms.
Macroscopic systems involve such large numbers of particles that they require the units of
molestotranslatebetweenthisandtheparticulatescale.Theorganizationoftheperiodic
tablereflectstheperiodicityofelementpropertiesasafunctionofatomicnumber.The
electronicstructureofanatomcanbedescribedbyanelectronconfigurationthatprovides
a method for describing the distribution of electrons in an atom or ion. In subsequent units,
students will apply their understanding of atomic structure to models and representations
of chemical phenomena to explain changes and interactions of chemical substances.
Building the
Science Practices
1.A
2.A
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Criterion b1 accepts 69.72 g/mol as an equivalent form of average atomic mass. This is a molar mass, not an equivalent expression of the requested atomic mass; remove this accepted variant.
- gpt-6.1-sol: accurate: Criterion b1's fix and accepted variants incorrectly allow g/mol as the unit of average atomic mass. Average atomic mass is expressed in amu; g/mol expresses molar mass.
- gpt-6.1-sol: rubric_points: Criterion b1 accepts 28.09 g/mol as equivalent to 28.09 amu. Molar mass is a different quantity, not an equivalent form of the requested average atomic mass. Remove the g/mol variant.
- gpt-6.1-sol: accurate: Criterion b1 incorrectly treats 28.09 g/mol as equivalent to 28.09 amu. These quantities are numerically related but have different dimensions: molar mass versus average mass per atom.

### ap_chemistry 1.3 Elemental Composition of Pure Substances (Unit 1: Atomic Structure and Properties)
Official CED text (governs):
```
TOPIC 1.3
Elemental
Composition of
Pure Substances
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.3.A
1.3.A.1
Explain the quantitative
relationship between the
elemental composition by
mass and the empirical
formula of a pure substance.
Some pure substances are composed of
individual molecules, while others consist
ofatomsorionsheldtogetherinfixed
proportions as described by a formula unit.
1.3.A.2
Accordingtothelawofdefiniteproportions,
the ratio of the masses of the constituent
elements in any pure sample of that compound
is always the same.
1.3.A.3
The chemical formula that lists the lowest
whole number ratio of atoms of the elements in
a compound is the empirical formula.
Return to Table of Contents
UNIT
Atomic Structure and Properties
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Criterion b2 prescribes dividing by the smaller mole amount, rejecting valid alternatives such as directly calculating the Fe:O mole ratio. Criterion c1 limits its evidence to mass percent or mass ratio; determining and comparing empirical formu
- gpt-6.1-sol: accurate: Criterion a1 lists 0.6996 as an equivalent form of the requested percentage. It is the mass fraction, not the percent by mass; the equivalent percentage is 69.96%. The evidence requirement still demands 69.96%, making this accepted variant internally
- gpt-6.1-sol: well_posed: Part (c): Sample 3 is not clearly identified as pure. Its different composition establishes that it is not a pure sample of the same compound, but does not distinguish another compound from a mixture. Explicitly state that Sample 3 is a pure compou
- gpt-6.1-sol: rubric_points: Parts (b), criteria b1 and b2: The evidence requirements prescribe calculating the actual sample's mole amounts, dividing by the smaller amount, and multiplying by 2. The prompt only requires a justified empirical formula; valid alternatives inc
- topic vote went to {'1.3': 6} with required units [1, 2] (drifted off topic or needed a later unit)

### ap_chemistry 1.4 Composition of Mixtures (Unit 1: Atomic Structure and Properties)
Official CED text (governs):
```
TOPIC 1.4
SUGGESTED SKILL
Composition
of Mixtures
Mathematical
Routines
5.A
Identify quantities needed
to solve a problem from
given information (e.g., text,
mathematical expressions,
graphs, or tables).
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.4.A
1.4.A.1
Explain the quantitative
relationship between the
elemental composition by
mass and the composition of
substances in a mixture.
Pure substances contain atoms, molecules,
or formula units of a single type. Mixtures
contain atoms, molecules, or formula units of
two or more types, whose relative proportions
can vary.
1.4.A.2
Elemental analysis can be used to determine
the relative numbers of atoms in a substance
and to determine its purity.
Return to Table of Contents
UNIT
SUGGESTED SKILL
Models and
Representations
1.A
Describe the components
of and quantitative
information from models
and representations that
illustrateparticulate-level
properties only.
Atomic Structure and Properties
```
Earlier rejected attempts on this topic:
- lint: fix length 27 words
- gpt-6.1-sol: rubric_points: Part (b), criterion b1 requires an explicit statement that pure substances have fixed composition and that the sample must be a mixture. The requested claim is only that the sample is not pure KCl. Calculating 50.00% Cl, comparing it with 47.55%
- gpt-6.1-sol: solution: The numerical results and particle-level explanation agree: (a) 47.55% Cl; (b) 50.00% Cl supports nonpurity; (c) 0.2801 g NaCl; (d) the lighter sodium ion makes chlorine a larger fraction of the formula-unit mass. However, the independently supplied 
- lint: fix length 27 words

### ap_chemistry 1.5 Atomic Structure and Electron Configuration (Unit 1: Atomic Structure and Properties)
Official CED text (governs):
```
TOPIC 1.5
Atomic Structure and
Electron Configuration
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.5.A
1.5.A.1
Representtheground-state
electronconfigurationofan
atom of an element or its ions
using the Aufbau principle.
The atom is composed of negatively charged
electrons and a positively charged nucleus that
is made of protons and neutrons.
1.5.A.2
Coulomb’s law is used to calculate the force
between two charged particles.
EQN: Fcoulombic ∝
q1q2
r2
1.5.A.3
In atoms and ions, the electrons can be
thought of as being in “shells (energy levels)”
and “subshells (sublevels),” as described by
theground-stateelectronconfiguration.Inner
electrons are called core electrons, and outer
electrons are called valence electrons. The
electronconfigurationisexplainedbyquantum
mechanics, as delineated in the Aufbau principle
andexemplifiedintheperiodictableofthe
elements.
Exclusion Statement: The assignment of
quantum numbers to electrons in subshells of
an atom will not be assessed on the AP Exam.
continued on next page
Return to Table of Contents
Atomic Structure and Properties
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.5.A
1.5.A.4
Represent the ground-state
electron configuration of an
atom of an element or its ions
using the Aufbau principle.
The relative energy required to remove an
electronfromdifferentsubshellsofanatomor
ionorfromthesamesubshellindifferentatoms
orions(ionizationenergy)canbeestimated
through a qualitative application of Coulomb’s
law. This energy is related to the distance from
thenucleusandtheeffective(shield)chargeof
the nucleus.
UNIT
Return to Table of Contents
UNIT
SUGGESTED SKILL
Model Analysis
4.B
Explain whether a model is
consistent with chemical
theories.
AVAILABLE RESOURCES
You can find related
resources below in AP
Classroom.
§ Exploring Atomic
Structure Using
Photoelectron
Spectroscopy
(PES) Data
Atomic Structure and Properties
```
Earlier rejected attempts on this topic:
- topic vote went to {'1.5': 6} with required units [1, 2] (drifted off topic or needed a later unit)
- topic vote went to {'1.7': 6} with required units [1] (drifted off topic or needed a later unit)
- topic vote went to {'1.5': 4, '1.7': 1, '2.2': 1} with required units [1, 2] (drifted off topic or needed a later unit)

### ap_chemistry 1.8 Valence Electrons and Ionic Compounds (Unit 1: Atomic Structure and Properties)
Official CED text (governs):
```
TOPIC 1.8
Valence Electrons and
Ionic Compounds
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
1.8.A
1.8.A.1
Explain the relationship
between trends in the
reactivity of elements
and periodicity.
The likelihood that two elements will form
a chemical bond is determined by the
interactions between the valence electrons
and nuclei of elements.
1.8.A.2
Elements in the same column of the periodic
table tend to form analogous compounds.
1.8.A.3
Typical charges of atoms in ionic compounds
are governed by the number of valence
electrons and predicted by their location on the
periodic table.
Return to Table of Contents
AP CHEMISTRY
UNIT 2
Compound
Structure and
Properties
7–9%
AP EXAM WEIGHTING
~12–13
CLASS PERIODS
Return to Table of Contents
Remember to go to AP Classroom
to assign students the online
Progress Check for this unit.
Whether assigned as homework or
completed in class, the Progress
Check provides each student with
immediate feedback related to this
unit’s topics and skills.
Progress Check 2
Multiple-choice: ~15 questions
Free-response: 1 question
§ Long
Return to Table of Contents
UNIT
7–9% AP EXAM WEIGHTING
~12–13 CLASS PERIODS
Compound Structure
and Properties
Developing Understanding
ESSENTIAL
QUESTIONS
§ How are molecular
compounds arranged?
§ Why are some bonds
easier to break than
others?
§ In what ways does a
diagram drawn on paper
accuratelyreflectthe
structure of a molecule?
In what ways does it not
accuratelyreflectthe
structure?
In Unit 2, students apply their knowledge of atomic structure at the particulate level and
connect it to the macroscopic properties of a substance. Both the chemical and physical
properties of materials can be explained by the structure and arrangement of atoms, ions,
or molecules and the forces between them. These forces, called chemical bonds, are
distinct from typical intermolecular interactions. Electronegativity can be used to make
predictions about the type of bonding present between two atoms. In subsequent units,
students will use the periodic table and the atomic properties to predict the type of bonding
present between two atoms based on position.
Building the
Science Practices
3.A
3.B
4.C
6.A
6.C
In this unit, students will learn how to
interpret simple graphical representations
of changes in potential energy as two atoms
approach each other to explain optimal bond
length as well as why bonds may or may
not occur. Students should also practice
constructing representations and models for
chemical phenomena (e.g., ionic and metallic
solids) and using representations to make
claims or predictions. For example, students
can use VSEPR theory to draw Lewis
structures of molecules and predict their
three-dimensionalgeometryandpolarity.
Instead of simply connecting chemical
theories to phenomena occurring at the
atomic level, it is important to provide
explanations across scales. For example,
teachers can ask students to explain the
connection between electronegativity and
ionizationenergywiththetypeofbond
formed and the macroscopic properties
of a particular substance. Students should
also work with several chemical concepts
(Coulomb’s law, formal charge, and resonance)
to evaluate the accuracy of a model in
representingboththeparticulate-level
structure and macroscopic observations. In
future units, students will use the practice of
constructing and understanding molecular
representations to make predictions and
claims about interparticle interactions,
intermolecular forces, and their connections
to macroscopic observations.
Preparing for the AP Exam
On the AP Exam, students must be able
to construct Lewis structures and make
predictions or claims based on them.
However, students often struggle to predict
the correct molecular shape or bond angle
based on VSEPR and the use of formal
charge. Mistakes include: using the incorrect
number of valence electrons, violating
the octet rule, or confusing molecular
geometry with bond angles. Teachers can
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Criterion a1 bundles two independently requested calculations—moles of Sr and moles of Cl—into one point. Criterion d1 likewise bundles two independently requested formula predictions and their justifications. Each criterion should award one spe

### ap_chemistry 2.1 Types of Chemical Bonds (Unit 2: Compound Structure and Properties)
Official CED text (governs):
```
TOPIC 2.1
Types of
Chemical Bonds
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.1.A
2.1.A.1
Explain the relationship
between the type of bonding
and the properties of the
elements participating in
the bond.
Electronegativity values for the representative
elements increase going from left to right
across a period and decrease going down
a group. These trends can be understood
qualitatively through the electronic structure of
the atoms, the shell model, and Coulomb’s law.
2.1.A.2
Valence electrons shared between atoms
of similar electronegativity constitute a
nonpolar covalent bond. For example, bonds
betweencarbonandhydrogenareeffectively
nonpolar even though carbon is slightly more
electronegative than hydrogen.
2.1.A.3
Valence electrons shared between atoms of
unequal electronegativity constitute a polar
covalent bond.
i. The atom with a higher electronegativity will
develop a partial negative charge relative to
the other atom in the bond.
 ii.In
 singlebonds,greaterdifferencesin
electronegativity lead to greater bond dipoles.
iii. All polar bonds have some ionic character,
andthedifferencebetweenionicand
covalent bonding is not distinct but rather
a continuum.
continued on next page
Return to Table of Contents
Compound Structure and Properties
LEARNING OBJECTIVE
UNIT
ESSENTIAL KNOWLEDGE
2.1.A
2.1.A.4
Explain the relationship
between the type of bonding
and the properties of the
elements participating in
the bond.
Thedifferenceinelectronegativityisnotthe
only factor in determining if a bond should
be designated as ionic or covalent. Generally,
bonds between a metal and nonmetal are
ionic, and bonds between two nonmetals are
covalent. Examination of the properties of a
compoundisthebestwaytocharacterizethe
type of bonding.
2.1.A.5
In a metallic solid, the valence electrons
from the metal atoms are considered to be
delocalizedandnotassociatedwithany
individual atom.
Return to Table of Contents
UNIT
SUGGESTED SKILL
Representing Data
and Phenomena
3.A
Represent chemical
phenomena using
appropriate graphing
techniques, including
correct scale and units.
AVAILABLE RESOURCES
§ AP Chemistry
Lab Manual >
Investigation 5: Sticky
Question: How Do You
Separate Molecules
That Are Attracted to
One Another?
You can find related
resources below in the
Online Teacher Community.
§ Ending Misconceptions
About the Energy of
Chemical Bonds
Compound Structure and Properties
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Part (a), criterion a1 bundles multiple independently observable results into one point: three calculated electronegativity differences and a bond-dipole ranking. Separate the calculations from the ranking, or narrow the requested and scored res
- deepseek-v4-pro: on_topic: Part (d), criterion d1 requires the particle-level explanation that ions in an ionic solid are fixed in a lattice but become mobile when melted; this is not part of Topic 2.1 and is introduced in later Topic 2.3.

### ap_chemistry 2.4 Structure of Metals and Alloys (Unit 2: Compound Structure and Properties)
Official CED text (governs):
```
TOPIC 2.4
Structure of Metals
and Alloys
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
2.4.A
2.4.A.1
Represent a metallic
solid and/or alloy using a
model to show essential
characteristics of the
structure and interactions
present in the substance.
Metallic bonding can be represented as an
array of positive metal ions surrounded by
delocalizedvalenceelectrons(i.e.,a“sea
of electrons”).
2.4.A.2
Interstitial alloys form between atoms of
significantlydifferentradii,wherethesmaller
atomsfilltheinterstitialspacesbetweenthe
larger atoms (e.g., with steel in which carbon
occupies the interstices in iron).
2.4.A.3
Substitutional alloys form between atoms
of comparable radius, where one atom
substitutes for the other in the lattice. (e.g., in
certain brass alloys, other elements, usually
zinc,substituteforcopper.)
Return to Table of Contents
UNIT
Compound Structure and Properties
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Part (a), criterion a1 requires mole conversions with explicit intermediate mole quantities, although the question does not prescribe that method. A valid direct calculation, (0.90/99.10) × (55.85/12.01) × 100 = 4.2, shows sufficient work withou
- lint: fix length 27 words

### ap_chemistry 3.11 Spectroscopy and the Electromagnetic Spectrum (Unit 3: Properties of Substances and Mixtures)
Official CED text (governs):
```
TOPIC 3.11
Predict and/or explain
chemical properties or
phenomena (e.g., of atoms
or molecules) using given
chemical theories, models,
and representations.
Spectroscopy and
the Electromagnetic
Spectrum
AVAILABLE RESOURCES
Required Course Content
4.A
§§ AP Chemistry
Lab Manual >
Investigation 1: What
is the Relationship
Between the
Concentration of
a Solution and the
Amount of Transmitted
Light Through the
Solution?
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.11.A
3.11.A.1
Explain the relationship
between a region of the
electromagnetic spectrum
and the types of molecular
or electronic transitions
associated with that region.
Differencesinabsorptionoremissionof
photonsindifferentspectralregionsare
relatedtothedifferenttypesofmolecular
motion or electronic transition:
i. Microwave radiation is associated with
transitions in molecular rotational levels.
ii. Infrared radiation is associated with
transitions in molecular vibrational levels.
iii. Ultraviolet/visible radiation is associated with
transitions in electronic energy levels.
Return to Table of Contents
UNIT
Properties of Substances and Mixtures
```
Earlier rejected attempts on this topic:
- topic vote went to {'3.11': 6} with required units [1, 3, 6] (drifted off topic or needed a later unit)

### ap_chemistry 3.12 Properties of Photons (Unit 3: Properties of Substances and Mixtures)
Official CED text (governs):
```
TOPIC 3.12
SUGGESTED SKILL
Properties of Photons
Required Course Content
LEARNING OBJECTIVE
Mathematical
Routines
5.F
Calculate, estimate, or
predict an unknown
quantity from known
quantities by selecting
and following a logical
computational pathway and
attending to precision (e.g.,
performing dimensional
analysis and attending to
significant figures).
ESSENTIAL KNOWLEDGE
3.12.A
3.12.A.1
Explain the properties of
an absorbed or emitted
photon in relationship to an
electronic transition in an
atom or molecule.
When a photon is absorbed (or emitted) by an
atom or molecule, the energy of the species is
increased (or decreased) by an amount equal
to the energy of the photon.
3.12.A.2
The wavelength of the electromagnetic wave is
related to its frequency and the speed of light
by the equation:
EQN: c = λν.
The energy of a photon is related to the
frequency of the electromagnetic wave
through Planck’s equation:
EQN: E = ℎν.
Return to Table of Contents
UNIT
SUGGESTED SKILL
Question and
Method
2.E
Identify or describe
potential sources of
experimental error.
Properties of Substances and Mixtures
```

### ap_chemistry 3.3 Solids, Liquids, and Gases (Unit 3: Properties of Substances and Mixtures)
Official CED text (governs):
```
TOPIC 3.3
Solids, Liquids,
and Gases
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.3.A
3.3.A.1
Representthedifferences
between solid, liquid, and gas
phasesusingaparticulatelevel model.
Solids can be crystalline, where the particles
arearrangedinaregularthree-dimensional
structure, or they can be amorphous, where
the particles do not have a regular, orderly
arrangement. In both cases, the motion of the
individual particles is limited, and the particles
do not undergo overall translation with respect
to each other. The structure of the solid is
influencedbyinterparticleinteractionsandthe
ability of the particles to pack together.
3.3.A.2
The constituent particles in liquids are in
close contact with each other, and they
are continually moving and colliding. The
arrangement and movement of particles are
influencedbythenatureandstrengthofthe
forces (e.g., polarity, hydrogen bonding, and
temperature) between the particles.
3.3.A.3
The solid and liquid phases for a particular
substance typically have similar molar volume
because, in both phases, the constituent
particles are in close contact at all times.
3.3.A.4
In the gas phase, the particles are in constant
motion. Their frequencies of collision and the
average spacing between them are dependent
on temperature, pressure, and volume. Because
ofthisconstantmotion,andminimaleffectsof
forces between particles, a gas has neither a
definitevolumenoradefiniteshape.
Exclusion Statement: Understanding/
interpreting phase diagrams will not be assessed
on the AP Exam.
Return to Table of Contents
UNIT
Properties of Substances and Mixtures
```

### ap_chemistry 3.5 Kinetic Molecular Theory (Unit 3: Properties of Substances and Mixtures)
Official CED text (governs):
```
TOPIC 3.5
Kinetic Molecular
Theory
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.5.A
3.5.A.1
Explain the relationship
between the motion
of particles and the
macroscopic properties of
gases with:
The kinetic molecular theory (KMT) relates
the macroscopic properties of gases to
motions of the particles in the gas. The
Maxwell-Boltzmanndistributiondescribesthe
distribution of the kinetic energies of particles
at a given temperature.
i. The kinetic molecular
theory (KMT).
ii. A particulate model.
iii. A graphical representation.
3.5.A.2
All the particles in a sample of matter are in
continuous, random motion. The average
kinetic energy of a particle is related to its
average velocity by the equation:
EQN: KE = ½ mv2.
3.5.A.3
The Kelvin temperature of a sample of matter
is proportional to the average kinetic energy of
the particles in the sample.
3.5.A.4
TheMaxwell-Boltzmanndistributionprovides
a graphical representation of the energies/
velocities of particles at a given temperature.
Return to Table of Contents
UNIT
Properties of Substances and Mixtures
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Criterion c1 combines three independently requested distribution features into one point. It also requires a broader spread, although part (c) asks only about peak position, peak height, and total area. Separate the requested features into indiv

### ap_chemistry 3.8 Representations of Solutions (Unit 3: Properties of Substances and Mixtures)
Official CED text (governs):
```
TOPIC 3.8
SUGGESTED SKILL
Representations
of Solutions
Representing Data
and Phenomena
3.C
Represent visually the
relationship between the
structures and interactions
across multiple levels or
scales (e.g., particulate to
macroscopic).
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
3.8.A
3.8.A.1
Using particulate models for
mixtures:
Particulate representations of solutions
communicate the structure and properties
of solutions, by illustration of the relative
concentrations of the components in the
solution and/or drawings that show interactions
among the components.
i. Represent interactions
between components.
ii. Represent concentrations
of components.
Exclusion Statement: Colligative properties will
not be assessed on the AP Exam.
Exclusion Statement: Calculations of molality,
percent by mass, and percent by volume for
solutions will not be assessed on the AP Exam.
Return to Table of Contents
UNIT
SUGGESTED SKILL
Question and
Method
2.C
Identify experimental
procedures that are
aligned tothequestion
(which may include a
sketch ofalabsetup).
AVAILABLE RESOURCES
§§ AP Chemistry
Lab Manual >
Investigation 5: Sticky
Question: How Do You
Separate Molecules
That Are Attracted to
One Another?
Properties of Substances and Mixtures
```


## AP Chemistry CED fact pack (course-wide sections and units up to 3)
# AP Chemistry - CED Fact Pack

Status: Primary-source verified. Use this version for 2026-27 authoring and review.

## Source control

Source document: College Board, AP Chemistry Course and Exam Description.

Edition: Effective Fall 2024, Course Framework V.1, copyright 2024. The local PDF was modified in the 2026 release cycle.

Local source: `docs/teaching/ap-chemistry-course-and-exam-description.pdf`

Source SHA-256: `b5dfe8677ef3d88c613865d2e2a3e8d6125d652e2b24c71ef1e8ce4e011094f0`

Verification: PDF metadata, cover, course framework, unit weighting table, science practices, topic maps, exclusion statements, laboratory requirements, and exam overview were checked directly. This pack supersedes the Fall 2020 digest.

2026-08-08 deep-tier build: extended this pack from topic-map/weighting tier
to full deep tier across all 9 units (AP Chemistry's complete assessed
scope). Read the CED unit-guide pages directly (Topics 1.1 through 9.11) for
per-topic Learning Objective/Essential Knowledge content, exact equations
with symbol conventions, and verbatim exclusion/boundary statements — the
prior flat "High-risk exclusion boundaries" list was cross-checked
statement-by-statement against the source PDF and re-attached to its
specific topic (several flat-list sentences were found to merge 2-3 distinct
CED exclusion statements; all are now itemized per topic without discarding
the original list). Additionally read the 2025 Chief Reader Report, 2025
Scoring Guidelines, and 2025 Sample Student Responses/Scoring Commentary
booklets (Q1 and Q2) for real observed error rates and misconception
patterns by FRQ point, cited with mean point scores where the source
reports them. See "Units 1-3 deep-tier detail," "Units 4-6 deep-tier
detail," and "Units 7-9 deep-tier detail" below.

## Course and laboratory requirements

AP Chemistry is equivalent to a college-level general chemistry course.

Students should have completed an introductory high school chemistry course and Algebra II or an equivalent course.

At least 25% of instructional time must be hands-on laboratory work. The course requires at least 16 hands-on labs, including at least six inquiry-based investigations.

Laboratory content is not an optional appendix to the course. Authoring and review should include experimental design, procedure analysis, data representation, error analysis, and evidence-based argumentation across the bank.

## Exam structure

The exam is 3 hours 15 minutes.

Section I: 60 multiple-choice questions, 90 minutes, 50% of the score.

Section II: 7 free-response questions, 105 minutes, 50% of the score. The section contains three 10-point long questions and four 4-point short questions.

A scientific or graphing calculator is recommended on both sections. Students receive a periodic table and an equations-and-constants sheet.

## Multiple-choice unit weighting

Unit 1 - Atomic Structure and Properties: 7-9%.

Unit 2 - Compound Structure and Properties: 7-9%.

Unit 3 - Properties of Substances and Mixtures: 18-22%.

Unit 4 - Chemical Reactions: 7-9%.

Unit 5 - Kinetics: 7-9%.

Unit 6 - Thermochemistry: 7-9%.

Unit 7 - Principles of Equilibrium: 7-9%.

Unit 8 - Acids and Bases: 11-15%.

Unit 9 - Thermodynamics and Electrochemistry: 7-9%.

Naming note: some framework pages shorten Unit 7 to “Equilibrium.” Treat “Principles of Equilibrium” and “Equilibrium” as aliases for Unit 7.

## Science practices

Practice 1 - Models and Representations: describe and extract quantitative information from particulate and macroscopic models.

Practice 2 - Question and Method: identify testable questions, formulate hypotheses, select procedures, collect observations, identify error, and predict how procedural changes affect results.

Practice 3 - Representing Data and Phenomena: create graphs, diagrams, and cross-scale representations.

Practice 4 - Model Analysis: use, test, and connect models across particulate and macroscopic scales.

Practice 5 - Mathematical Routines: identify quantities and relationships, interpret graphs, balance equations, and calculate with dimensional and significant-figure discipline.

Practice 6 - Argumentation: make claims and support them with experimental evidence, models, chemical principles, quantitative justification, and error analysis.

MCQ practice weighting: Practice 1, 8-12%; Practice 2, 8-12%; Practice 4, 23-30%; Practice 5, 35-42%; Practice 6, 8-12%. Practice 3 is not assessed in the MCQ section.

## Practice skills (sub-skills) — TASK-0050 Phase 0, added 2026-09-29

Source: CED "Science Practices" pages (Course Framework V.1 pp. 12-13, © 2024 College Board),
supplied by David 2026-09-29 as a direct capture of the College Board PDF — the same Fall 2024
edition this pack's Source control section records. Transcribed verbatim. These are the skill codes
the skill dimension uses (`app.taxonomy_skills`): **28 total, all assessed.**

Unlike AP Calculus, whose CED marks three sub-skills *not assessed* (1.A, 1.B, 3.A), the AP
Chemistry page marks none — so all 28 are candidates. Note separately that Practice 3 as a whole is
not assessed in the **MCQ** section (see the weighting line above); that is a section-level
restriction, not a per-skill exclusion, and it does not remove 3.A-3.C from FRQ scope.

### Practice 1 — Models and Representations
*Describe models and representations, including across scales.*

- **1.A** Describe the components of and quantitative information from models and representations that illustrate particulate-level properties only.
- **1.B** Describe the components of and quantitative information from models and representations that illustrate both particulate-level and macroscopic-level properties.

### Practice 2 — Question and Method
*Determine scientific questions and methods.*

- **2.A** Identify a testable scientific question based on an observation, data, or a model.
- **2.B** Formulate a hypothesis or predict the results of an experiment.
- **2.C** Identify experimental procedures that are aligned to a scientific question (which may include a sketch of a lab setup).
- **2.D** Make observations or collect data from representations of laboratory setups or results, while attending to precision where appropriate.
- **2.E** Identify or describe potential sources of experimental error.
- **2.F** Explain how modifications to an experimental procedure will alter results.

### Practice 3 — Representing Data and Phenomena
*Create representations or models of chemical phenomena.*

- **3.A** Represent chemical phenomena using appropriate graphing techniques, including correct scale and units.
- **3.B** Represent chemical substances or phenomena with appropriate diagrams or models (e.g., electron configuration).
- **3.C** Represent visually the relationship between the structures and interactions across multiple levels or scales (e.g., particulate to macroscopic).

### Practice 4 — Model Analysis
*Analyze and interpret models and representations on a single scale or across multiple scales.*

- **4.A** Predict and/or explain chemical properties or phenomena (e.g., of atoms or molecules) using given chemical theories, models, and representations.
- **4.B** Explain whether a model is consistent with chemical theories.
- **4.C** Explain the connection between particulate-level and macroscopic properties of a substance using models and representations.
- **4.D** Explain the degree to which a model or representation describes the connection between particulate-level properties and macroscopic properties.

### Practice 5 — Mathematical Routines
*Solve problems using mathematical relationships.*

- **5.A** Identify quantities needed to solve a problem from given information (e.g., text, mathematical expressions, graphs, or tables).
- **5.B** Identify an appropriate theory, definition, or mathematical relationship to solve a problem.
- **5.C** Explain the relationship between variables within an equation when one variable changes.
- **5.D** Identify information presented graphically to solve a problem.
- **5.E** Determine a balanced chemical equation for a given chemical phenomenon.
- **5.F** Calculate, estimate, or predict an unknown quantity from known quantities by selecting and following a logical computational pathway and attending to precision (e.g., performing dimensional analysis and attending to significant figures).

### Practice 6 — Argumentation
*Develop an explanation or scientific argument.*

- **6.A** Make a scientific claim.
- **6.B** Support a claim with evidence from experimental data.
- **6.C** Support a claim with evidence from representations or models at the particulate level, such as the structure of atoms and/or molecules.
- **6.D** Provide reasoning to justify a claim using chemical principles or laws, or using mathematical justification.
- **6.E** Provide reasoning to justify a claim using connections between particulate and macroscopic scales or levels.
- **6.F** Explain the connection between experimental results and chemical concepts, processes, or theories.
- **6.G** Explain how potential sources of experimental error may affect the experimental results.

## Topic-to-practice alignment — TASK-0050 Phase 0, COMPLETE (all 9 units)

Source: CED "Course at a Glance" (Course Framework V.1 pp. 16-20, © 2024 College Board), supplied by
David 2026-09-29 in two batches. Each topic carries the Science Practice the CED aligns to it, so the topic × skill
grid is **transcribed rather than curated** for the units covered — the case `TASK-0050` §6.2 says to
prefer.

**COVERAGE: complete — all 91 topics across all 9 units.** Units 6-9 were supplied first
(2026-09-29), Units 1-5 in a second batch the same day.

**Verification of this transcription.** The per-unit topic counts read from the captures are 8, 7,
13, 9, 11, 9, 12, 11, 11 for Units 1-9, totalling 91. `app.taxonomy_topics` holds exactly those nine
counts and exactly 91 topics. A miscount in any unit would have broken that equality.

| Unit | Topic → Practice |
| --- | --- |
| 1 — Atomic Structure and Properties | 1.1→5, 1.2→5, 1.3→2, 1.4→5, 1.5→1, 1.6→4, 1.7→4, 1.8→4 |
| 2 — Compound Structure and Properties | 2.1→6, 2.2→3, 2.3→4, 2.4→4, 2.5→3, 2.6→6, 2.7→6 |
| 3 — Properties of Substances and Mixtures | 3.1→4, 3.2→4, 3.3→3, 3.4→5, 3.5→4, 3.6→6, 3.7→5, 3.8→3, 3.9→2, 3.10→4, 3.11→4, 3.12→5, 3.13→2 |
| 4 — Chemical Reactions | 4.1→2, 4.2→5, 4.3→3, 4.4→6, 4.5→5, 4.6→3, 4.7→1, 4.8→1, 4.9→5 |
| 5 — Kinetics | 5.1→6, 5.2→5, 5.3→5, 5.4→5, 5.5→6, 5.6→3, 5.7→1, 5.8→5, 5.9→5, 5.10→3, 5.11→6 |
| 6 — Thermochemistry | 6.1→6, 6.2→3, 6.3→6, 6.4→2, 6.5→1, 6.6→4, 6.7→5, 6.8→5, 6.9→5 |
| 7 — Equilibrium | 7.1→6, 7.2→4, 7.3→3, 7.4→5, 7.5→6, 7.6→5, 7.7→3, 7.8→3, 7.9→6, 7.10→5, 7.11→5, 7.12→2 |
| 8 — Acids and Bases | 8.1→5, 8.2→5, 8.3→5, 8.4→5, 8.5→5, 8.6→6, 8.7→2, 8.8→6, 8.9→5, 8.10→6, 8.11→2 |
| 9 — Thermodynamics and Electrochemistry | 9.1→6, 9.2→5, 9.3→6, 9.4→6, 9.5→6, 9.6→4, 9.7→4, 9.8→2, 9.9→5, 9.10→6, 9.11→5 |

Every Chemistry topic in these units carries **exactly one** practice — unlike AP Calculus, where
three topics (2.2, 5.12, 10.11) carry two.

Exam weightings captured alongside, for authoring reference: Unit 1 7-9%, Unit 2 7-9%,
**Unit 3 18-22%** (the heaviest unit in the course), Unit 4 7-9%, Unit 5 7-9%, Unit 6 7-9%,
Unit 7 7-9%, **Unit 8 11-15%**, Unit 9 7-9%.

**How the grid derives from this.** A topic's candidate skills are the sub-skills of its aligned
practice — so a Practice 5 topic offers 5.A-5.F (six candidates), Practice 6 offers 6.A-6.G (seven),
Practice 2 offers 2.A-2.F (six), Practice 4 offers 4.A-4.D (four), Practice 3 offers 3.A-3.C (three),
Practice 1 offers 1.A-1.B (two). No Chemistry sub-skill is marked *not assessed*, so none are
excluded — unlike AP Calculus, which excludes 1.A, 1.B and 3.A.

### Practice distribution across the course

Useful when sizing a labelling run, since a topic's candidate count is the size of its practice:

| Practice | Sub-skills | Topics aligned to it |
| --- | --- | --- |
| 1 Models and Representations | 2 | 5 |
| 2 Question and Method | 6 | 9 |
| 3 Representing Data and Phenomena | 3 | 12 |
| 4 Model Analysis | 4 | 14 |
| 5 Mathematical Routines | 6 | 30 |
| 6 Argumentation | 7 | 21 |
| **Total** | | **91** |

Practice 5 (Mathematical Routines) carries a third of the course, consistent with its 35-42% MCQ
weighting recorded above.

Mean candidates per topic is **5.31** — larger than AP Statistics' 2.33, so expect lower proposer
agreement than Statistics' 85.6% on the eventual Phase B run, though far better than the 28-way
choice that would apply without this alignment.

**Phase 0 for AP Chemistry is complete.** Phase A (building `taxonomy_skills` and `taxonomy_cells`)
can now be transcribed from this section plus the sub-skill list above. Phase B still requires the
topic pass first: no AP Chemistry item currently carries a topic assignment.

FRQ practice weighting: Practice 1, 2-4%; Practice 2, 10-16%; Practice 3, 8-16%; Practice 4, 5-9%; Practice 5, 43-53%; Practice 6, 15-24%.

## Topic map

### Unit 1 - Atomic Structure and Properties

1.1 Moles and Molar Mass; 1.2 Mass Spectra of Elements; 1.3 Elemental Composition of Pure Substances; 1.4 Composition of Mixtures; 1.5 Atomic Structure and Electron Configuration; 1.6 Photoelectron Spectroscopy; 1.7 Periodic Trends; 1.8 Valence Electrons and Ionic Compounds.

### Unit 2 - Compound Structure and Properties

2.1 Types of Chemical Bonds; 2.2 Intramolecular Force and Potential Energy; 2.3 Structure of Ionic Solids; 2.4 Structure of Metals and Alloys; 2.5 Lewis Diagrams; 2.6 Resonance and Formal Charge; 2.7 VSEPR and Hybridization.

### Unit 3 - Properties of Substances and Mixtures

3.1 Intermolecular and Interparticle Forces; 3.2 Properties of Solids; 3.3 Solids, Liquids, and Gases; 3.4 Ideal Gas Law; 3.5 Kinetic Molecular Theory; 3.6 Deviation from Ideal Gas Law; 3.7 Solutions and Mixtures; 3.8 Representations of Solutions; 3.9 Separation of Solutions and Mixtures; 3.10 Solubility; 3.11 Spectroscopy and the Electromagnetic Spectrum; 3.12 Properties of Photons; 3.13 Beer-Lambert Law.

## High-risk exclusion boundaries

Do not assess interpretation of mass spectra containing multiple elements or peaks from species other than singly charged monatomic ions.

Do not assess assigning quantum numbers to individual electrons or writing electron configurations for aufbau exceptions.

Do not require memorized specific crystal structures.

Hybridization scope is sp, sp2, and sp3 nomenclature plus sigma/pi distinctions. Do not assess derivation or depiction of hybrid orbitals, d-orbital hybridization, or molecular-orbital diagrams and filling.

Do not assess phase-diagram interpretation.

Do not assess colligative properties or solution calculations using molality, percent by mass, or percent by volume.

Do not assess the vocabulary labels “reducing agent” and “oxidizing agent,” rote solubility-rule memorization beyond the framework, or Lewis acid-base concepts.

Do not assess Arrhenius-equation calculations or experimental collection of data intended to detect a reaction intermediate.

Do not assess technical distinctions between enthalpy and internal energy or the formal concept of state functions.

Do not assess conversion between Kc and Kp or equilibria in which a dissolved species is in equilibrium with the same species in the gas phase.

For polyprotic-acid titrations, do not require concentration calculations for every species. Qualitative reasoning about dominant species remains in scope.

Do not assess calculating buffer pH change after adding acid/base or deriving the Henderson-Hasselbalch equation.

Do not assess calculating solubility as a function of pH.

Do not assess labeling an electrochemical electrode as positive or negative. Anode/cathode roles, oxidation/reduction, electron flow, cell potential, and galvanic/electrolytic behavior remain in scope.

## High-risk authoring and review guidance

Unit 3 is the largest MCQ domain and needs proportionally broad representation, not repeated ideal-gas calculations.

Unit 8 is the second-largest domain. Include conceptual particulate reasoning, equilibrium calculations, titration interpretation, buffers, molecular structure, pKa, capacity, and qualitative pH-solubility relationships.

The current framework places pH and solubility in Topic 8.11, not Unit 7. Free energy of dissolution is Topic 9.6.

Electrochemistry is part of Unit 9 and runs through Topic 9.11. Do not use the older 9.7-9.10 numbering.

Topic 3.12 is Properties of Photons. Do not retain the older “Photoelectric Effect” topic label.

Topic 5.9 is Pre-Equilibrium Approximation. Do not retain the older “Steady-State Approximation” label.

MCQs must combine content with Practices 1, 2, 4, 5, or 6. Representing Data and Phenomena is FRQ-only in the exam weighting.

FRQ sets must preserve the current three-long/four-short structure and include quantitative reasoning, experimental/laboratory reasoning, representations, and evidence-based justification.

Use the provided equations sheet as the boundary for formula availability. Avoid making recall of a provided equation the only source of difficulty.

All questions, diagrams, data, and scoring criteria must be independently authored from this scope brief. Do not expose official sample questions, released question wording, scoring text, or recognizable item structures to the authoring model.

## Units 1-3 deep-tier detail (2026-08-08)

David supplied the full primary-source PDF set for the first time this session:
the 220-page CED itself, the 2025 Chief Reader Report (CRR), the 2025 Scoring
Guidelines (SG), the 2025 Sample Student Responses/Scoring Commentary
booklets (Q1 and Q2), and the 2025/2026 released FRQ booklets. This section
and the two that follow deepen all 9 units (previously topic-map/weighting
only) to the same tier as Biology/Physics: per-topic LO/EK content, exact
equations with symbol conventions, verbatim CED exclusion statements
re-attached to their specific topic (the prior "High-risk exclusion
boundaries" section above is preserved unchanged; every sentence in it is
cross-referenced to its topic below), and real scoring/misconception data
from the CRR and Sample Responses booklets. All 9 units are AP Chemistry's
full assessed scope, so the pack is now deep tier end-to-end.

### General exam-wide conventions (apply beyond Units 1-3)
- "Thermodynamically favored" is the CED's preferred term over
  "spontaneous," specifically to avoid students conflating it with "sudden"
  or "without cause" (EK 9.3.A.2). Authored items/rubrics should use
  "thermodynamically favored," not "spontaneous."
- "Hydronium ion" and $H_3O^+(aq)$ are the CED's preferred terms/notation for
  the aqueous hydrogen ion, but $H^+(aq)$ is explicitly stated as also
  accepted on the AP Exam (EK 8.1.A.1).
- Scoring is part-specific and frequently carries explicit
  error-carried-forward credit: 2025 Scoring Guidelines repeatedly award a
  later point "consistent with" an earlier (possibly wrong) part's answer
  (verified directly in Q1 parts D/E(ii)/E(iii)/F of the 2025 SG).
- Chief Reader Report guidance (not a CED rule, but an observed reader
  convention): the number of decimal places reported for a log-derived value
  (pH, pOH, pKa, pKb) should match the number of significant figures in the
  underlying concentration/K value — e.g. a $2.75\times10^{-6}$ M (3 sig
  fig) $[OH^-]$ should yield a pOH reported to 3 decimal places (5.561), not
  fewer or more.
- Some rubric points explicitly do **not** require units or a sign to earn
  credit, while others explicitly do — this is stated point-by-point in the
  2025 SG, not by a blanket exam-wide rule; do not assume uniform
  units/sign requirements across all criteria when authoring rubrics.

### Unit 1 — Atomic Structure and Properties (7-9%)

- **1.1 Moles and Molar Mass.** EK: no direct particle count in the lab, so
  mass-to-particle-count needs a bridge. $N_A = 6.022\times10^{23}\,mol^{-1}$
  connects moles to particle count; average mass in amu of one particle
  equals the molar mass in grams. **EQN:** $n = m/M$. Zero explicit
  exclusion statements.
- **1.2 Mass Spectra of Elements.** EK: a single-element mass spectrum gives
  isotope identity and relative abundance; average atomic mass is the
  isotope-weighted average. **Exclusion Statement (verbatim):**
  "Interpreting mass spectra of samples containing multiple elements or
  peaks arising from species other than singly charged monatomic ions will
  not be assessed on the AP Exam." (This is the CED source of the existing
  flat-list item 1.)
- **1.3 Elemental Composition of Pure Substances.** EK: law of definite
  proportions — the mass ratio of constituent elements in any pure sample of
  a compound is always the same; empirical formula = lowest whole-number
  atom ratio. Zero explicit exclusion statements.
- **1.4 Composition of Mixtures.** EK: pure substances contain one particle
  type; mixtures contain two-or-more types in variable proportion; elemental
  analysis determines relative atom counts and purity. Zero explicit
  exclusion statements.
- **1.5 Atomic Structure and Electron Configuration.** EK: atom =
  negatively-charged electrons + positively-charged nucleus (protons +
  neutrons). Coulomb's law gives force between charged particles: **EQN:**
  $F_{coulombic}\propto q_1q_2/r^2$. Shell/subshell structure from the Aufbau
  principle; ionization energy trends estimated qualitatively via Coulomb's
  law (distance from nucleus + effective/shielded nuclear charge).
  **Exclusion Statement (verbatim):** "The assignment of quantum numbers to
  electrons in subshells of an atom will not be assessed on the AP Exam."
  (Source of the first half of existing flat-list item 2.)
- **1.6 Photoelectron Spectroscopy.** EK: PES peak position = energy needed
  to remove an electron from that subshell; peak height is (ideally)
  proportional to the number of electrons in that subshell. Zero explicit
  exclusion statements.
- **1.7 Periodic Trends.** EK: periodic table organization reflects
  recurring ground-state electron-configuration patterns and filled/partial
  shell presence. Periodicity (ionization energy, atomic/ionic radii,
  electron affinity, electronegativity) is explained qualitatively via
  Coulomb's law, shell model, shielding, and effective nuclear charge; used
  to predict/estimate property values absent data. **Exclusion Statement
  (verbatim):** "Writing the electron configuration of elements that are
  exceptions to the aufbau principle will not be assessed on the AP Exam."
  (Source of the second half of existing flat-list item 2 — this is a
  distinct topic/statement from the 1.5 quantum-number exclusion, though
  the prior flat list merged them into one sentence.)
- **1.8 Valence Electrons and Ionic Compounds.** EK: bond likelihood is
  governed by valence-electron/nucleus interactions; same-column elements
  form analogous compounds; typical ionic charges are predicted from
  valence-electron count and periodic-table position. Zero explicit
  exclusion statements.

**Documented misconception (2025 FRQ Q1, mass spectrum/isotopes, Topics
1.2/1.7):** mean score on the isotope-mass-difference point was 0.55/1.0.
The dominant error was attributing the mass difference between Mg-25 and
Mg-26 to differing numbers of *electrons and/or protons* rather than
neutrons — a real, frequently-observed confusion between isotope identity
(protons, fixed) and isotope mass (neutrons, variable), worth mirroring as a
distractor pattern. A companion point (annotating a mass-spectrum graph with
a second isotope line) scored 0.72/1.0, with the main error being
misreading the y-axis scale.

### Unit 2 — Compound Structure and Properties (7-9%)

- **2.1 Types of Chemical Bonds.** EK: electronegativity increases
  left-to-right across a period, decreases down a group (explained via
  shell model + Coulomb's law). Nonpolar covalent = shared valence electrons
  between similar-electronegativity atoms (C–H bonds are "effectively
  nonpolar" despite a small real difference); polar covalent = shared
  electrons between unequal-electronegativity atoms, with greater
  electronegativity difference producing greater bond dipole in single
  bonds; all polar bonds have some ionic character (ionic/covalent is a
  continuum, not a hard distinction). Metal-nonmetal bonds are generally
  ionic, nonmetal-nonmetal generally covalent, but compound *properties* are
  the best characterization tool. In metallic solids, valence electrons are
  delocalized, not tied to individual atoms. Zero explicit exclusion
  statements.
- **2.2 Intramolecular Force and Potential Energy.** EK: a potential-energy-
  vs-internuclear-distance graph shows equilibrium bond length (lowest PE
  point) and bond energy (energy to separate atoms). Higher bond order
  (single→double→triple) = shorter bond, larger bond energy. Coulomb's law
  governs cation-anion interaction strength: larger charges and smaller ions
  (shorter internuclear distance) both increase strength. Zero explicit
  exclusion statements.
- **2.3 Structure of Ionic Solids.** EK: cations/anions arrange in a
  systematic, periodic 3-D array maximizing attractive and minimizing
  repulsive Coulombic forces. **Exclusion Statement (verbatim):**
  "Knowledge of specific crystal structures is not essential to an
  understanding of the learning objective and will not be assessed on the
  AP Exam." (Source of existing flat-list item 3.)
- **2.4 Structure of Metals and Alloys.** EK: metallic bonding = positive
  metal-ion array + delocalized "sea of electrons." Interstitial alloys
  (e.g. steel: C in Fe interstices) form between atoms of significantly
  different radii; substitutional alloys (e.g. some brass) form between
  atoms of comparable radius. Zero explicit exclusion statements.
- **2.5 Lewis Diagrams.** EK: Lewis diagrams follow an established
  construction procedure. Zero explicit exclusion statements.
- **2.6 Resonance and Formal Charge.** EK: when more than one equivalent
  Lewis structure is possible, resonance is a required refinement for
  qualitatively accurate structure/property prediction. Octet rule + formal
  charge select among nonequivalent candidate structures. The Lewis model
  has real limitations, particularly for odd-electron-count species. Zero
  explicit exclusion statements.
- **2.7 VSEPR and Hybridization.** EK: VSEPR uses Coulombic repulsion
  between electron pairs to predict arrangement around a central atom;
  applies with Lewis diagrams to predict geometry (linear, trigonal planar,
  tetrahedral, trigonal pyramidal, bent, trigonal bipyramidal, seesaw,
  T-shaped, octahedral, square pyramidal, square planar), bond angles,
  relative bond energies/lengths, dipole presence, and valence-orbital
  hybridization. Ideal bond angles: sp = 180°, sp² = 120°, sp³ = 109.5°.
  Sigma bonds (stronger, from head-on orbital overlap) vs. pi bonds (from
  multiple-bond overlap; prevent bond rotation, cause geometric isomers;
  weaker, lower bond energy than sigma). **Exclusion Statements (verbatim,
  three — the prior flat list merged all three into one sentence):** (1)
  "An understanding of the derivation and depiction of hybrid orbitals will
  not be assessed on the AP Exam. The course includes the distinction
  between sigma and pi bonding, the use of VSEPR to explain the shapes of
  molecules, and the sp, sp2, and sp3 nomenclature." (2) "Hybridization
  involving d orbitals will not be assessed on the AP Exam. When an atom has
  more than four pairs of electrons surrounding the central atom, students
  are only responsible for the shape of the resulting molecule." (3)
  "Molecular orbital theory is recommended as a way to provide deeper
  insight into bonding. However, the AP Exam will neither explicitly assess
  molecular orbital diagrams, filling of molecular orbitals, nor the
  distinction between bonding, nonbonding, and antibonding orbitals."

**Documented misconception (2025 FRQ Q4/Q5, Topic 2.7):** hybridization
identification (Q4 Part A) scored only 0.56/1.0 — the dominant error was
counting four electron domains on a carbon with a C=O double bond (yielding
incorrect sp³) instead of the correct three bonding regions (sp²); other
wrong-format responses gave sigma/pi counts, electron configurations, or
molecular geometry instead of a hybridization label. VSEPR geometry
identification for a more complex, multi-central-atom molecule (Q5 Part A,
trimethylsilanol) was comparatively accessible (0.65/1.0), but common wrong
answers included "tetrahedral pyramidal" (an invalid compound label) and
giving a bond angle (109.5°) without a geometry name.

### Unit 3 — Properties of Substances and Mixtures (18-22%, the largest MCQ domain)

- **3.1 Intermolecular and Interparticle Forces.** EK: London dispersion
  forces arise from Coulombic interaction between temporary/fluctuating
  dipoles and are often the strongest net IMF between large molecules — the
  CED explicitly cautions "the term 'London dispersion forces' should not be
  used synonymously with the term 'van der Waals forces.'" Dipole-dipole
  forces occur between polar molecules (typically stronger than comparable
  nonpolar-molecule London forces because dipole-dipole acts *in addition
  to* London forces). Ion-dipole forces occur between ions and polar
  molecules and are typically stronger than dipole-dipole. Hydrogen bonding
  = strong IMF when H covalently bonded to N/O/F is attracted to the
  negative end of a dipole from N/O/F in a different molecule (or different
  part of the same molecule). Zero explicit exclusion statements on this
  topic itself.
- **3.2 Properties of Solids.** EK: vapor pressure/boiling point correlate
  directly with IMF strength (IMFs fully overcome on vaporization); melting
  point correlates more subtly (IMFs only rearrange). Four solid classes:
  ionic (low vapor pressure, high mp/bp, brittle, conducts only when ions
  are mobile — molten or dissolved), covalent network (3-D like diamond or
  layered like graphite; nonmetals/metalloids only; high mp, rigid — except
  graphite, soft because layers slide), molecular (weak IMFs between
  covalently-bonded units; low mp; non-conducting), metallic (good
  conductors, malleable/ductile; interstitial alloying reduces
  malleability/ductility but retains conductivity). Zero explicit exclusion
  statements.
- **3.3 Solids, Liquids, and Gases.** EK: solids may be crystalline
  (regular 3-D arrangement) or amorphous (irregular); solid/liquid molar
  volumes are typically similar (particles in close contact in both); gas
  particles are in constant motion with neither definite volume nor shape.
  **Exclusion Statement (verbatim):** "Understanding/interpreting phase
  diagrams will not be assessed on the AP Exam." (Source of existing
  flat-list item 5.)
- **3.4 Ideal Gas Law.** **EQN:** $PV = nRT$. Partial pressure is
  proportional to mole fraction: **EQN:** $P_A = P_{total}\times X_A$, where
  $X_A = mol_A/mol_{total}$; **EQN:** $P_{total}=P_A+P_B+P_C+\ldots$. Zero
  explicit exclusion statements.
- **3.5 Kinetic Molecular Theory.** EK: KMT relates macroscopic gas
  properties to particle motion; the Maxwell-Boltzmann distribution
  describes the kinetic-energy distribution at a given temperature. **EQN:**
  $KE=\tfrac12mv^2$. Kelvin temperature is proportional to average particle
  KE. Zero explicit exclusion statements.
- **3.6 Deviation from Ideal Gas Law.** EK: real-gas deviations arise from
  interparticle attraction (especially near condensation conditions) and
  from particle volume (especially at very high pressure). Zero explicit
  exclusion statements.
- **3.7 Solutions and Mixtures.** EK: solutions (homogeneous mixtures) can
  be solid/liquid/gas, with uniform macroscopic properties throughout (vs.
  heterogeneous mixtures, which vary by location). **EQN:**
  $M = n_{solute}/L_{solution}$. Zero explicit exclusion statements on this
  specific topic (the molality/percent exclusion below is filed under 3.8).
- **3.8 Representations of Solutions.** EK: particulate models communicate
  solution structure/properties via relative concentration and interaction
  drawings. **Exclusion Statements (verbatim, two — the prior flat list
  merged both into one sentence):** (1) "Colligative properties will not be
  assessed on the AP Exam." (2) "Calculations of molality, percent by mass,
  and percent by volume for solutions will not be assessed on the AP Exam."
  (Source of existing flat-list item 6.)
- **3.9 Separation of Solutions and Mixtures.** EK: liquid-solution
  components cannot be separated by filtration; separation instead exploits
  differential IMF strength (e.g. chromatography — paper, thin-layer,
  column — separates by differential interaction strength between mobile-
  and stationary-phase components; the resulting chromatogram infers
  relative component polarity). Zero explicit exclusion statements.
- **3.10 Solubility.** EK: substances with similar IMFs tend to be miscible/
  soluble in one another ("like dissolves like," stated via IMF-similarity
  language rather than the mnemonic itself). Zero explicit exclusion
  statements.
- **3.11 Spectroscopy and the Electromagnetic Spectrum.** EK: absorption/
  emission region correlates with transition type — microwave = molecular
  rotational transitions; infrared = molecular vibrational transitions;
  UV/visible = electronic energy-level transitions. Zero explicit exclusion
  statements. (Topic renumbering note: this topic's correct current CED
  number is 3.11 — verified directly against the source PDF, matching the
  existing topic map.)
- **3.12 Properties of Photons.** EK: photon absorption/emission changes
  species energy by an amount equal to the photon's energy. **EQN:**
  $c=\lambda\nu$ (wavelength/frequency/speed of light); **EQN:** $E=h\nu$
  (Planck's equation). Zero explicit exclusion statements. (Confirms the
  existing fact pack's correction that this topic is "Properties of
  Photons," not an older "Photoelectric Effect" label — verified directly
  against the CED page.)
- **3.13 Beer-Lambert Law.** **EQN:** $A=\varepsilon bc$ (absorbance = molar
  absorptivity × path length × concentration). In most experiments path
  length and wavelength are held constant, so absorbance is proportional
  only to concentration; spectrophotometers are typically set to the
  wavelength of maximum absorbance for best sensitivity. Zero explicit
  exclusion statements.

**Documented misconception (2025 FRQ Q1/Q2/Q4/Q5, Topic 3.1 IMF —
recurring across multiple questions this cycle):** the single most
frequently-tested topic-3 concept in 2025. In Q1 Part B(ii) (ionic radius
vs. Coulombic attraction strength), the dominant error (mean score only
0.11/1.0, the lowest point on the entire exam) was treating "r" in
Coulomb's law as the radius of one ion rather than the interparticle
separation between ion and water — explicitly flagged by the Chief Reader
as the single most important IMF-reasoning error observed in the whole
2025 administration. In Q4 Part B (hydrogen-bond identification in a
particulate diagram), common wrong answers included drawing the
attraction from the wrong atom (O of methanol to H of formaldehyde, rather
than O–H hydrogen to formaldehyde O), drawing same-molecule-type
attractions instead of the prompted cross-molecule pair, and confusing
intramolecular bonds with intermolecular forces. In Q5 Part B (comparing
London dispersion strength between C- and Si-centered molecules), the
dominant error was citing molar mass alone as justification rather than the
correct reasoning (more occupied electron shells → larger, more
polarizable electron cloud).

## Units 4-6 deep-tier detail (2026-08-08)

## Units 7-9 deep-tier detail (2026-08-08)

## Change record from superseded fact pack

Updated the source from Effective Fall 2020 to Effective Fall 2024 and removed the old uncertainty caveat.

Updated unit names to Compound Structure and Properties; Properties of Substances and Mixtures; Thermochemistry; Principles of Equilibrium; and Thermodynamics and Electrochemistry.

Corrected Topic 3.12 to Properties of Photons and Topic 5.9 to Pre-Equilibrium Approximation.

Moved pH and Solubility to 8.11; moved Free Energy of Dissolution to 9.6; inserted Coupled Reactions at 9.7; and renumbered electrochemistry through 9.11.

Added current exam timing, long/short FRQ point structure, science-practice weightings, laboratory requirements, and explicit exclusion controls.

2026-08-08: Added deep-tier per-topic detail for all 9 units (Topics
1.1-9.11) — Learning Objective/Essential Knowledge summaries, exact
equations with symbol conventions, and the existing flat exclusion-statement
list re-organized per topic with 11 additional distinct exclusion
statements identified that the flat list had merged into fewer sentences
(verified 25 distinct CED exclusion-statement instances total, vs. 14
sentences in the prior flat list). Added a "General exam-wide conventions"
subsection (preferred terminology, error-carried-forward scoring pattern,
significant-figure convention for log-derived values) not previously
captured. Added unit-level "Documented misconception" callouts sourced from
the 2025 Chief Reader Report and Sample Student Responses booklets, citing
real observed mean point scores. No errors were found in the existing
topic-map, weighting, or unit-title content during this pass — all cross-
checked exactly against the primary-source PDF.

