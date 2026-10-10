# FRQ writing brief: statistics

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


# Subject: AP Statistics (subject_key ap_statistics)
Format: Short free-response in AP Statistics style: a real-world context with any data as a small plain-text table. Answers must be communicated in context, following AP conventions for the topic (for example parameters defined, conditions checked, conclusions stated in context).
Parts: 2-4. Criteria (points) in total: 4-6.

## Topics in this subject's Units 1, 2, 3 (stay inside the designated topic)
1.1 Introducing Statistics: What Can We Learn from Data? (Unit 1: Exploring One-Variable Data and Collecting Data)
1.10 The Investigative Question Revisited and Data Collection (Unit 1: Exploring One-Variable Data and Collecting Data)
1.11 Random Sampling (Unit 1: Exploring One-Variable Data and Collecting Data)
1.12 Potential Problems with Sampling (Unit 1: Exploring One-Variable Data and Collecting Data)
1.13 Experimental Design (Unit 1: Exploring One-Variable Data and Collecting Data)
1.2 Variables (Unit 1: Exploring One-Variable Data and Collecting Data)
1.3 Tabular Representation and Summary Statistics for One Categorical Variable (Unit 1: Exploring One-Variable Data and Collecting Data)
1.4 Graphical Representations for One Categorical Variable (Unit 1: Exploring One-Variable Data and Collecting Data)
1.5 Graphical Representations for One Quantitative Variable (Unit 1: Exploring One-Variable Data and Collecting Data)
1.6 Descriptions for One Quantitative Variable Distributions (Unit 1: Exploring One-Variable Data and Collecting Data)
1.7 Summary Statistics for One Quantitative Variable (Unit 1: Exploring One-Variable Data and Collecting Data)
1.8 Graphical Representations of Summary Statistics for One Quantitative Variable (Unit 1: Exploring One-Variable Data and Collecting Data)
1.9 Comparisons of the Distributions for One Quantitative Variable (Unit 1: Exploring One-Variable Data and Collecting Data)
2.1 Tabular and Graphical Representations for the Distributions of Two Categorical Variables (Unit 2: Probability, Random Variables, and Probability Distributions)
2.10 The Binomial Distribution (Unit 2: Probability, Random Variables, and Probability Distributions)
2.11 The Normal Distribution (Unit 2: Probability, Random Variables, and Probability Distributions)
2.12 Sampling Distributions and the Central Limit Theorem (Unit 2: Probability, Random Variables, and Probability Distributions)
2.2 Summary Statistics for Two Categorical Variables (Unit 2: Probability, Random Variables, and Probability Distributions)
2.3 Estimating Probabilities Using Simulation (Unit 2: Probability, Random Variables, and Probability Distributions)
2.4 Introduction to Probability (Unit 2: Probability, Random Variables, and Probability Distributions)
2.5 Mutually Exclusive Events (Unit 2: Probability, Random Variables, and Probability Distributions)
2.6 Conditional Probability (Unit 2: Probability, Random Variables, and Probability Distributions)
2.7 Independent Events and Unions of Events (Unit 2: Probability, Random Variables, and Probability Distributions)
2.8 Introduction to Random Variables and Probability Distributions (Unit 2: Probability, Random Variables, and Probability Distributions)
2.9 Parameters of Random Variables (Unit 2: Probability, Random Variables, and Probability Distributions)
3.1 Estimators (Unit 3: Inference for Categorical Data: Proportions)
3.10 Constructing a Confidence Interval for the Difference Between Two Population Proportions (Unit 3: Inference for Categorical Data: Proportions)
3.11 Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Proportions (Unit 3: Inference for Categorical Data: Proportions)
3.12 Setting Up a Test for the Difference Between Two Population Proportions (Unit 3: Inference for Categorical Data: Proportions)
3.13 Carrying Out a Test for the Difference Between Two Population Proportions (Unit 3: Inference for Categorical Data: Proportions)
3.14 Setting Up a Chi-Square Test for Homogeneity or Independence (Unit 3: Inference for Categorical Data: Proportions)
3.15 Carrying Out a Chi-Square Test for Homogeneity or Independence (Unit 3: Inference for Categorical Data: Proportions)
3.2 Sampling Distributions for Sample Proportions (Unit 3: Inference for Categorical Data: Proportions)
3.3 Constructing a Confidence Interval for a Population Proportion (Unit 3: Inference for Categorical Data: Proportions)
3.4 Justifying a Claim Based on a Confidence Interval for a Population Proportion (Unit 3: Inference for Categorical Data: Proportions)
3.5 Setting Up a Test for a Population Proportion (Unit 3: Inference for Categorical Data: Proportions)
3.6 p-Values (Unit 3: Inference for Categorical Data: Proportions)
3.7 Carrying Out a Test for a Population Proportion (Unit 3: Inference for Categorical Data: Proportions)
3.8 Potential Errors When Performing Tests (Unit 3: Inference for Categorical Data: Proportions)
3.9 Sampling Distributions for the Difference Between Sample Proportions (Unit 3: Inference for Categorical Data: Proportions)

## Targets: write exactly one FRQ for each of these 14 topics

### ap_statistics 1.1 Introducing Statistics: What Can We Learn from Data? (Unit 1: Exploring One-Variable Data and Collecting Data)
Official CED text (governs):
```
TOPIC 1.1
Introducing Statistics:
What Can We
Learn from Data?
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify components within a
statistical study.
A statistical study is a study in which data
are collected from a sample to answer
an investigative question about a larger
population.
1.1.A
[Skill 2.A]
1.1.A.1
TOPIC PAGES
The skills note the course skills that are paired with
the learning objectives for that topic.
Learning objectives define what a student needs to
be able to do with content knowledge to progress
through the course.
Essential knowledge statements define the required
content knowledge associated with each learning
objective assessed on the AP Exam.
1.1.A.2
Statistical studies are necessary when the
population is too large or it is too difficult to
collect data from every item or individual in the
population.
1.1.A.3
A datum (singular form of data) is a piece of
information about an item or individual. A
collection of data is called a data set.
1.1.A.4
A population consists of all items or individuals
of interest. The population size is represented
by the symbol N.
1.1.A.5
A sample selected for study is a subset of
the population from which data are obtained.
The number of items in the sample, called the
sample size, is represented by the symbol n.
1.1.A.6
Each component of a statistical study and
the resulting calculations can be related to
an aspect of the corresponding real-world
context from which the components were
derived. This identification of a statistical
result with the corresponding contextual
component is what is meant by “in context.”
continued on next page
Return To contents
THIS PAGE HAS BEEN INTENTIONALLY LEFT BLANK
AP STATISTICS
UNIT 1
Exploring
One-Variable
Data and
Collecting Data
20–30%
AP EXAM WEIGHTING
~26
CLASS PERIODS
Remember to go to AP Classroom
to assign students the online
Progress Checks for this unit.
Whether assigned as homework or
completed in class, the Progress
Checks provide each student with
immediate feedback related to this
unit’s topics and skills.
Progress Check 1
Multiple-choice: ~44 questions
Free-response: 3 questions
§ Question 1: Multi-Focus on
Practices 1 and 2
§ Question 2: Multi-Focus on
Practices 3 and 4
§ Question 2: Multi-Focus on
Practices 3 and 4
UNIT
20–30% AP EXAM WEIGHTING
~26 CLASS PERIODS
Exploring One-Variable
Data and Collecting Data
Developing Understanding
ESSENTIAL
QUESTIONS
§ What kind of question can
be answered using data
from websites?
§ What kind of data is
collected about me on
social media?
§ What methods should I
use to collect the data to
conduct future inference
procedures?
In each unit of the course, students engage with the principles and processes in the
discipline of statistics. Starting in Unit 1, students identify components and formulate
investigative questions of a statistical study, define and represent categorical and
quantitative variables, describe and compare distributions of one-variable data,
interpret statistical calculations to assess claims about individual data points or
samples, and justify the use of important principles of sampling and experimental
design. Students also learn to talk about data in real-world contexts. Variability in data
may suggest certain conclusions about the data distribution, but not all variation is
meaningful. Statistics allow us to develop shared understandings of uncertainty and
variation.
Additionally, students learn that, depending on how data are collected, they may or
may not be able to generalize findings or establish evidence of causal relationships.
For example, if random selection is not used to obtain a sample from a population,
bias may result and statistics from the sample could not be assumed to generalize
to the population. For data collected using well-designed experiments, statistically
significant differences between or among experimental treatment groups are
evidence that the treatments caused the effect.
Building Statistical Practices
1.A
2.A
2.B
3.A
3.B
4.A
```

### ap_statistics 2.2 Summary Statistics for Two Categorical Variables (Unit 2: Probability, Random Variables, and Probability Distributions)
Official CED text (governs):
```
TOPIC 2.2
SKILLS
Summary Statistics
for Two Categorical
Variables
3.B
Calculate summary statistics,
relative positions of points
within a distribution, and
predicted responses.
4.A
Describe and compare tabular
and graphical representations
of data, as well as summary
statistics.
4.B
Justify a claim based on
statistical calculations and
results.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Calculate summary statistics
from two-way tables.
A joint relative frequency in a two-way table is a
cell frequency divided by the total for the entire
table.
2.2.A
[Skill 3.B]
2.2.A.1
2.2.A.2
A marginal relative frequency in a two-way table
is a row total divided by the total for the entire
table or a column total divided by the total for
the entire table.
2.2.A.3
A conditional relative frequency is a relative
frequency computed by restricting to a
particular level, or category of interest. A
conditional relative frequency can be a cell
frequency in a row divided by the total for that
row or it can be a cell frequency in a column
divided by the total for that column.
2.2.B
Compare summary statistics
for two categorical variables.
[Skill 4.A]
2.2.C
Justify a claim using summary
statistics for two categorical
variables.
[Skill 4.B]
2.2.B.1
Summary statistics for two categorical
variables can be used to compare distributions
for evidence of association between the two
variables.
2.2.C.1
Summary statistics for two categorical
variables may reveal information that can be
used to justify claims about the variables in
context.
Return To contents
UNIT
SKILLS
3.C
Calculate and estimate
expected counts, percentages,
probabilities, and intervals.
Probability, Random Variables, and Probability Distributions
```

### ap_statistics 2.7 Independent Events and Unions of Events (Unit 2: Probability, Random Variables, and Probability Distributions)
Official CED text (governs):
```
TOPIC 2.7
Independent Events
and Unions of Events
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Calculate probabilities for
independent events and for
the union of two events.
Events A and B are independent if and only if
knowing whether event A has occurred (or will
occur) does not change the probability that
event B will occur. When events A and B are
independent, then P ( A | B) = P A ,
2.7.A
[Skill 3.C]
2.7.A.1
( )
P (B | A) = P ( B ), and P ( A ∩ B ) = P ( A ) . P ( B ).
2.7.A.2
The probability that event A or event B (or
both) will occur is the probability of A union B.
The probability of the union is defined as
P A∪B .
(
)
2.7.A.3
P ( A union B ) =
P ( A ) + P ( B ) - P ( A intersect B ), or
P ( A ∪ B ) = P ( A) + P ( B ) - P ( A ∩ B ) .
Return To contents
UNIT
Probability, Random Variables, and Probability Distributions
```

### ap_statistics 3.10 Constructing a Confidence Interval for the Difference Between Two Population Proportions (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.10
Constructing a
Confidence Interval for
the Difference Between
Two Population
Proportions
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify an appropriate
confidence interval procedure
including the parameters for
the difference between two
population proportions.
Based on the sample data, a confidence
interval can be calculated to estimate
the difference between two population
proportions. The appropriate confidence
interval procedure is a two-sample z-interval
for a difference between population
proportions.
3.10.A
[Skill 2.C]
3.10.A.1
3.10.A.2
The parameters of a confidence interval
for the difference between two population
proportions should refer to the difference in
the proportions, the response variable, and the
populations in context.
3.10.B
Justify the appropriateness
of constructing a confidence
interval for the difference
between two population
proportions by verifying
conditions.
[Skill 4.E]
3.10.B.1
A two-sample z-interval for a difference
between two population proportions requires
that three conditions be met:
3.10.B.1.i
The randomization condition—the data
should be collected using two independent
random samples or a randomized
experiment.
continued on next page
UNIT
Inference for Categorical Data: Proportions
LEARNING OBJECTIVE
3.10.B
ESSENTIAL KNOWLEDGE
3.10.B.1.ii
The 10% condition—when sampling without
replacement, the size of each sample
should be less than or equal to 10% of the
respective population size: n1 ≤ 10%N1
and n2 ≤ 10%N 2 , where N 1 is the size of
population 1 and N 2 is the size of population
2. The sample sizes are represented as n1
and n2 . (Note: This condition is unnecessary
when the data are from a randomized
experiment.)
Justify the appropriateness
of constructing a confidence
interval for the difference
between two population
proportions by verifying
conditions.
[Skill 4.E]
3.10.B.1.iii
The normality condition—the number of
 1 and n2 p 2, and
observed successes, n1 p
 and
number of observed failures, n1 1 p
n2 1 p 2 , for both samples are all at
least 10.
3.10.C
Calculate an appropriate
confidence interval for the
difference between two
population proportions.
[Skill 3.E]
3.10.C.1
The point estimate for the difference between
two population proportions is p 1
3.10.C.2
For the difference between two
population proportions, the interval
estimate can be constructed as
point estimate (margin of error).
The interval estimate for the difference
between two population proportions is
( p p ) z
3.10.D
Calculate the standard
error and margin of error for
estimating the difference
between two population
proportions.
[Skill 3.E]
p 2 .
p1 1 p1
p 2 1 p 2
n1
n2
.
3.10.D.1
The standard error (SE ) for the difference
between two population proportions is
SE p p
p 1 1 p 1
p 2 1 p 2
n1
n2
.
3.10.D.2
```

### ap_statistics 3.11 Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Proportions (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.11
Justifying a Claim
Based on a Confidence
Interval for the
Difference Between
Two Population
Proportions
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Interpret a confidence interval
in context for the difference
between two population
proportions.
Because the confidence interval for
the difference between two population
proportions is calculated based on samples
from two populations, the computed interval
may or may not contain the value for the
difference between those two population
proportions.
3.11.A
[Skill 4.F]
3.11.A.1
3.11.A.2
The interpretation of the confidence level
is as follows: In repeated random sampling
with the same sample sizes from the same
populations, approximately C% of confidence
intervals created will capture the difference
between the two population proportions,
where C represents the numerical value of the
confidence level used.
3.11.A.3
When interpreting a C% confidence interval
for the difference between two population
proportions, we say we are C% confident
that the interval a, b contains the parameter
for the difference between the populations,
where a represents the lower limit and b
represents the upper limit. An interpretation
of a confidence interval for the difference
between two population proportions includes
a reference to the parameter with the details
about the populations it represents in the
context of the study.
continued on next page
Inference for Categorical Data: Proportions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Justify a claim based on a
confidence interval for the
difference between two
population proportions.
A confidence interval for the difference
between two population proportions provides
an interval of values that may provide
convincing evidence to support a particular
claim about the difference between the two
population proportions. For example, if the
interval contains 0, then there is insufficient
evidence to conclude there is a difference
between the two population proportions. If the
interval does not contain 0, there is sufficient
evidence to conclude there is a difference
between the two population proportions.
3.11.B
[Skill 4.G]
UNIT
3.11.B.1
UNIT
SKILLS
2.C
Identify appropriate statistical
inference methods.
2.E
Identify the null and alternative
hypotheses.
4.E
Justify the use of a chosen
statistical inference method by
verifying conditions.
Inference for Categorical Data: Proportions
```

### ap_statistics 3.12 Setting Up a Test for the Difference Between Two Population Proportions (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.12
Setting Up a Test for
the Difference Between
Two Population
Proportions
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify an appropriate
testing method for the
difference between population
proportions including the
parameters.
The appropriate testing method for
the difference between two population
proportions is a two-sample z-test for
the difference between two population
proportions.
3.12.A
[Skill 2.C]
3.12.B
Identify the null and alternative
hypotheses for the difference
between population
proportions.
[Skill 2.E]
3.12.A.1
3.12.A.2
The parameters for a hypothesis test for
the difference between two population
proportions should reference the population
parameters, the response variables, and the
populations in context.
3.12.B.1
For a two-sample z-test for the difference
between two population proportions, the
null hypothesis indicates no difference. The
null hypothesis for the difference between
two population proportions can be written as
either H0 : p1 p2 or H0 : p1 p2 0. A onesided alternative hypothesis for the difference
between two population proportions
can be written as either Ha : p1 p2 or
equivalently Ha : p1 p2 0, or Ha : p1 p2
or equivalently Ha : p1 p2 0. A two-sided
alternative hypothesis for the difference
between two population proportions can be
written as either Ha : p1 p2 or equivalently
Ha : p1 p2 0 .
UNIT
Inference for Categorical Data: Proportions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Justify the appropriateness
of a hypothesis test for the
difference between two
population proportions by
verifying conditions.
A two-sample z-test for a difference between
two population proportions requires that three
conditions be met:
3.12.C
3.12.C.1
[Skill 4.E]
3.12.C.1.i
The randomization condition—the data
should be collected using two independent
random samples or a randomized
experiment.
3.12.C.1.ii
The 10% condition—when sampling without
replacement, the size of each sample
should be less than or equal to 10% of the
respective population size: n1 10%N1
and n2 10%N2 , where N1 is t he size of
population 1 and N 2 is the size of population
2. The sample sizes are represented as n1
and n2 . (Note: This condition is unnecessary
when the data are from a randomized
experiment.)
3.12.C.1.iii
c , n1 1 pc ,
The normality condition—n1 p
n2 pc , and n2 1 pc , must all be at least 10,


c n1 p 1 n2 p 2 being the combined
with p
n1 n2
(or pooled) proportion assuming that H0 is
true (H0 : p1
p2 or H0 : p1
p2
0).
UNIT
SKILLS
3.E
Calculate appropriate
statistical inference method
results.
4.F
Interpret results of statistical
inference methods.
4.G
Justify a claim based on
statistical inference method
results.
Inference for Categorical Data: Proportions
```

### ap_statistics 3.13 Carrying Out a Test for the Difference Between Two Population Proportions (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.13
Carrying Out a Test for
the Difference Between
Two Population
Proportions
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Calculate an appropriate
test statistic and p-value
for testing a hypothesis for
the difference between two
population proportions.
The test statistic for the difference between
two population proportions is
3.13.A
3.13.A.1
z
[Skill 3.E]
p c
p 1 p 2
p c 1 p c
n1
n2
, where
n1 p 1 n2 p 2
is the proportion of
n1 n2
successes for the two groups combined. The
z-statistic has a standard normal distribution
when the null hypothesis is true.
3.13.A.2
The p-value for a two-sample z-test for
the difference between two population
proportions can be found from the standard
normal distribution using a table or technology.
3.13.B
Interpret the p-value of
a hypothesis test for the
difference between two
population proportions.
[Skill 4.F]
3.13.B.1
The p-value is the probability of obtaining
a test statistic as extreme or more extreme
than the test statistic that was observed (i.e.,
in the direction of the alternative hypothesis)
given that the null hypothesis is true. An
interpretation of the p-value of a hypothesis
test for a difference between two population
proportions should include a statement that
the p-value is computed assuming the null
hypothesis is true (i.e., by assuming that the
true population proportions are equal to each
other in context).
continued on next page
Inference for Categorical Data: Proportions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Justify a claim about the
populations based on the
results of a hypothesis test for
the difference between two
population proportions.
A formal decision in a hypothesis test for the
difference between two population proportions
explicitly compares the p-value to the
significance level, α . If the p-value
,
then reject the null hypothesis, H0 : p1 p2 or
H0 : p1 p2 0. If the p-value
, then fail to
reject the null hypothesis.
3.13.C
[Skill 4.G]
UNIT
3.13.C.1
3.13.C.2
The results of a hypothesis test for the
difference between two population proportions
can serve as the statistical reasoning to
support the answer to an investigative question
about the two populations that were sampled.
3.13.C.3
A conclusion for the hypothesis test for the
difference between two population proportions
is stated in context consistent with, and in
terms of, the alternative hypothesis using nondefinitive language. The conclusion should
contain a reference to the parameters and the
populations.
UNIT
SKILLS
2.C
Identify appropriate statistical
inference methods.
2.E
Identify the null and alternative
hypotheses.
4.C
Describe distributions and
compare relative positions of
points within a distribution.
4.E
Justify the use of a chosen
statistical inference method by
verifying conditions.
Inference for Categorical Data: Proportions
```

### ap_statistics 3.14 Setting Up a Chi-Square Test for Homogeneity or Independence (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.14
Setting Up a
Chi-Square Test
for Homogeneity
or Independence
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Describe chi-square
distributions.
The chi-square statistic measures the
distance between observed and expected
counts relative to expected counts.
3.14.A
[Skill 4.C]
3.14.A.1
3.14.A.2
Chi-square distributions have positive values
and are skewed right. Within this family of
density curves, the skew becomes less
pronounced with increasing degrees of
freedom.
3.14.B
Identify an appropriate
testing method for comparing
distributions in two-way tables
of categorical data including
the populations and variables.
[Skill 2.C]
3.14.B.1
To determine whether the distributions
of a categorical variable for two or more
populations are different, the appropriate test
is the chi-square test for homogeneity.
3.14.B.2
A chi-square test for homogeneity should
reference the categorical variable and the
populations in context.
3.14.B.3
To determine whether row and column
variables in a two-way table of categorical data
might be associated in the single population
from which the data were sampled, the
appropriate test is the chi-square test for
independence.
3.14.B.4
A chi-square test for independence should
reference the categorical variables and the
population in context.
continued on next page
Inference for Categorical Data: Proportions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify the null and
alternative hypotheses
for a chi-square test
for homogeneity or
independence.
The appropriate null hypothesis for a chisquare test for homogeneity is H0: there is no
difference in the distributions of the categorical
variable across populations or treatments. The
appropriate alternative hypothesis for a chisquare test for homogeneity is Ha : there is a
difference in the distributions of the categorical
variable across populations or treatments.
3.14.C
[Skill 2.E]
UNIT
3.14.C.1
3.14.C.2
The appropriate null hypothesis for a chisquare test for independence is H0 : there
is no association between two categorical
variables in a given population or the two
categorical variables in a given population are
independent of each other. The appropriate
alternative hypothesis for a chi-square test for
independence is Ha : there is an association
between two categorical variables in a given
population or the two categorical variables in a
given population are not independent of each
other.
3.14.D
Justify the appropriateness
of a chi-square test
for independence or
homogeneity by verifying
conditions.
3.14.D.1
A chi-square test for homogeneity or
independence requires that three conditions
must be met:
[Skill 4.E]
3.14.D.1.i
The randomization condition—the test of
independence states that the data should
be collected using a random sample. The
test for homogeneity states that the data
should be collected using independent
random samples or a randomized
experiment.
3.14.D.1.ii
The 10% condition—when sampling
without replacement, check that n 10%N ,
where N is the size of the population and
n is the sample size. (Note: This condition
is unnecessary when the data are from a
randomized experiment.)
3.14.D.1.iii
The expected counts condition—all
expected counts should be greater than 5.
UNIT
SKILLS
3.C
Calculate and estimate
expected counts, percentages,
probabilities, and intervals.
3.E
Calculate appropriate
statistical inference method
results.
4.F
Interpret results of statistical
inference methods.
4.G
```

### ap_statistics 3.1 Estimators (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.1
Estimators
4.B
Justify a claim based on
statistical calculations and
results.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Justify why an estimator is or
is not unbiased.
When estimating a population parameter, an
estimator is unbiased if, on average, the value
of the estimator does not underestimate or
overestimate the population parameter.
3.1.A
[Skill 4.B]
3.1.B
Calculate estimates for a
population parameter.
[Skill 3.D]
3.1.A.1
3.1.B.1
A sample statistic is a point estimator of
the corresponding population parameter
and can be thought of as the estimate of
the population parameter. For example, the
 is a point estimator for
sample proportion p
the population proportion p.
UNIT
Inference for Categorical Data: Proportions
```

### ap_statistics 3.4 Justifying a Claim Based on a Confidence Interval for a Population Proportion (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.4
Justifying a Claim
Based on a Confidence
Interval for a
Population Proportion
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Interpret a confidence interval
in context for a population
proportion.
Because the confidence interval for a
population proportion is calculated based on
a sample from a population, the computed
interval may or may not contain the value of
the population proportion.
3.4.A
[Skill 4.F]
3.4.A.1
3.4.A.2
The interpretation of the confidence level
is that in repeated random sampling with
the same sample size, approximately C% of
confidence intervals calculated will capture
the population proportion, with C representing
the numerical value of the confidence level
used.
3.4.A.3
When interpreting a C% confidence interval
for a population proportion, we say we are C%
confident that the interval (a, b) contains the
true value of the parameter for the population,
where a represents the lower limit and b
represents the upper limit. An interpretation
of a confidence interval for a population
proportion includes a reference to the
parameter with details about the population it
represents in the context of the study.
3.4.B
Justify a claim based on a
confidence interval for a
population proportion.
[Skill 4.G]
3.4.B.1
A confidence interval for a population
proportion provides a range of plausible
values that may serve as convincing evidence
to support a particular claim about the
population proportion.
continued on next page
UNIT
Inference for Categorical Data: Proportions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify the relationships
among sample size,
confidence interval width,
confidence level, and margin
of error for a population
proportion.
For a given sample, increasing the confidence
level will result in the following:
3.4.C
3.4.C.1
3.4.C.1.i
The critical value will increase.
3.4.C.1.ii
The margin of error will increase.
[Skill 2.D]
3.4.C.1.iii
The width of the confidence interval will
increase.
3.4.C.2
Increasing the sample size decreases the
standard error. Thus, when all other things
remain the same, the width of the confidence
interval for a population proportion tends to
decrease as the sample size increases. For a
confidence interval for a population proportion
with a given confidence level, the width of the
interval is approximately proportional to
n
.
UNIT
SKILLS
2.C
Identify appropriate statistical
inference methods.
2.E
Identify the null and alternative
hypotheses.
4.E
Justify the use of a chosen
statistical inference method by
verifying conditions.
Inference for Categorical Data: Proportions
```

### ap_statistics 3.5 Setting Up a Test for a Population Proportion (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.5
Setting Up a Test
for a Population
Proportion
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify an appropriate testing
method for a population
proportion including the
parameter for the population
proportion.
A hypothesis test is a statistical inference
procedure that is used to make a decision
about the value of a population parameter. The
appropriate hypothesis testing procedure is a
one-sample z-test for a population proportion.
3.5.A
[Skill 2.C]
3.5.B
Identify the null and alternative
hypotheses for a population
proportion.
[Skill 2.E]
3.5.A.1
3.5.A.2
The parameter for a hypothesis test for a
population proportion should reference the
population parameter, the response variable,
and the population in context.
3.5.B.1
In the hypothesis testing procedure, the
null hypothesis, H0, is the statement about
a parameter that is assumed to be correct
unless there is convincing statistical evidence
suggesting otherwise. It is the status quo
condition. The alternative hypothesis, Ha , is
the claim or belief about a parameter for which
evidence is being collected. A researcher’s
claim or belief about the population parameter
is represented by the alternative hypothesis.
3.5.B.2
The null hypothesis contains an equality
reference , , or . Although the null
hypothesis for a one-sided test may include an
inequality symbol, in AP Statistics it is tested
at the boundary of equality. The alternative
hypothesis with < or > is called one-sided, and
the alternative hypothesis with is called twosided.
continued on next page
Inference for Categorical Data: Proportions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify the null and
alternative hypotheses for a
population proportion.
The null hypothesis for a one-sample z-test for a
population proportion is as follows: H0 : p p0 ,
where p0 is the null hypothesized value for the
population proportion. A one-sided alternative
hypothesis for a one-sample z-test for a
population proportion is either Ha : p p0 or
Ha : p p0 . A two-sided alternative hypothesis is
Ha : p p0 .
3.5.B
[Skill 2.E]
3.5.C
Justify the appropriateness
of a hypothesis test for a
population proportion by
verifying conditions.
UNIT
3.5.B.3
3.5.C.1
A one-sample z-test for a population proportion
requires that three conditions be met:
[Skill 4.E]
3.5.C.1.i
The randomization condition—the data
should be collected using a random sample.
3.5.C.1.ii
The 10% condition—when sampling without
replacement, the population size must be
at least 10 times larger than the sample
size n 10 N , where N is the size of the
population and n is the sample size.
3.5.C.1.iii
The normality condition—the expected
number of successes, np0 , and the
expected number of failures, n 1 p0 ,
should be at least 10.
UNIT
SKILLS
4.F
Interpret results of statistical
inference methods.
Inference for Categorical Data: Proportions
```

### ap_statistics 3.6 p-Values (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.6
p-Values
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Interpret the p-value of
a hypothesis test for a
population proportion.
Given the null hypothesis is true, there is a
probability distribution of the test statistic
called the null distribution. Using the null
distribution, the p-value is the probability of
obtaining a test statistic as extreme or more
extreme (i.e., in the direction of the alternative
hypothesis) than the test statistic that is
observed given that the null hypothesis is true.
That is, when x is the test statistic, the p-value
is determined by finding the following:
3.6.A
[Skill 4.F]
3.6.A.1
3.6.A.1.i
The probability at or above the observed
value of the test statistic P z x , if the
alternative is >
3.6.A.1.ii
The probability at or below the observed
value of the test statistic P z x , if the
alternative is <
3.6.A.1.iii
The probability less than or equal to the
negative of the absolute value of the test
statistic plus the probability greater than
or equal to the absolute value of the test
statistic, P z
x
P z x , if the
alternative is ≠
continued on next page
Inference for Categorical Data: Proportions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Interpret the p-value of
a hypothesis test for a
population proportion.
If the distribution of the test statistic has
been simulated, the p-value is the proportion
of values in the null distribution that are as
extreme or more extreme than the observed
value of the test statistic. This is as follows:
3.6.A
[Skill 4.F]
UNIT
3.6.A.2
3.6.A.2.i
The proportion at or above the observed
value of the test statistic, if the alternative
is >
3.6.A.2.ii
The proportion at or below the observed
value of the test statistic, if the alternative
is <
3.6.A.2.iii
The proportion less than or equal to the
negative of the absolute value of the test
statistic plus the proportion greater than
or equal to the absolute value of the test
statistic, if the alternative is
3.6.A.3
An interpretation of the p-value of a hypothesis
test for a population proportion should include
a statement that the p-value is computed by
assuming the null hypothesis is true (i.e., by
assuming the true population proportion is
equal to the particular value stated in the null
hypothesis in context).
3.6.A.4
Small p-values indicate that the observed
value of the test statistic would be unusual if
the null hypothesis were true and therefore
provide evidence for the alternative hypothesis.
The lower the p-value, the more convincing
the statistical evidence for the alternative
hypothesis.
3.6.A.5
p-values that are not small indicate that the
observed value of the test statistic would not
be unusual if the null hypothesis were true and
therefore do not provide convincing statistical
evidence for the alternative hypothesis, nor do
they provide evidence that the null hypothesis
is true.
UNIT
SKILLS
3.E
Calculate appropriate
statistical inference method
results.
4.G
Justify a claim based on
statistical inference method
results.
Inference for Categorical Data: Proportions
```

### ap_statistics 3.8 Potential Errors When Performing Tests (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.8
Potential Errors
When Performing
Tests
Interpret statistical calculations
and results to assess meaning
or a claim.
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify Type I and Type II
errors.
A Type I error occurs when there is convincing
statistical evidence that the alternative
hypothesis is true (due to the small p-value),
but it is not.
3.8.A
[Skill 2.D]
3.8.A.1
3.8.A.2
A Type II error occurs when there is not
convincing statistical evidence that the
alternative hypothesis is true (due to the large
p-value), but it is.
3.8.A.3
The power of a hypothesis test is the
probability that a hypothesis test will correctly
reject the false null hypothesis.
3.8.B
Calculate the probability of
Type I and Type II errors.
[Skill 3.C]
3.8.B.1
The probability of making a Type I error is
defined as the significance level, α . For a given
study and hypothesis test, the probability of
making a Type I error is typically set to a small
value (e.g., 0.01, 0.05, 0.10) prior to collecting
the data.
3.8.B.2
The probability of making a Type II error is
1 power.
continued on next page
UNIT
Inference for Categorical Data: Proportions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Identify the factors that affect
the probability of errors in
hypothesis testing.
For a given study and hypothesis test, the
probability of a Type II error should ideally be
small, and thus, the power will be large (e.g.,
P Type II error 0.20 and power 0.80).
The probability of a Type II error decreases
and the power increases when any one of the
following occurs, provided the others do not
change:
3.8.C
[Skill 2.D]
3.8.C.1
3.8.C.1.i
Sample size(s) increases.
3.8.C.1.ii
Standard error decreases.
3.8.C.1.iii
True parameter value is farther from the null
hypothesis.
3.8.C.1.iv
Significance level
3.8.D
Interpret Type I and Type II
errors.
[Skill 4.D]
of a test increases.
3.8.D.1
In some studies, making a Type I error may
have more serious consequences than making
a Type II error. In other studies, making a Type
II error may have more serious consequences
than making a Type I error. The consequences
of each error should be considered prior to
conducting the study.
3.8.D.2
Because the significance level, α , is the
probability of making a Type I error, the
consequences of a Type I error influence
decisions about a significance level.
3.8.D.3
Because sample size influences the probability
of making a Type II error, the consequences of
a Type II error influence decisions about how
large the sample size should be.
UNIT
SKILLS
3.D
Calculate means, standard
deviations, and parameters for
probability distributions.
4.D
Interpret statistical calculations
and results to assess meaning
or a claim.
4.E
Justify the use of a chosen
statistical inference method by
verifying conditions.
Inference for Categorical Data: Proportions
```

### ap_statistics 3.9 Sampling Distributions for the Difference Between Sample Proportions (Unit 3: Inference for Categorical Data: Proportions)
Official CED text (governs):
```
TOPIC 3.9
Sampling
Distributions for the
Difference Between
Sample Proportions
Required Course Content
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Calculate the mean and
standard deviation of the
sampling distribution for
the difference between two
sample proportions.
For two independent populations, with
population proportions p1 and p2 , when
the sampled values are independent, the
sampling distribution for the difference in
 1 p 2, has a mean,
sample proportions, p
p
p
,
and
standar
d deviation,
 
3.9.A
[Skill 3.D]
3.9.A.1
p1 p 2
p 1 p 2
3.9.B
Justify the appropriateness
of conditions for the sampling
distribution for the difference
between two sample
proportions.
[Skill 4.E]
p1 1 p1
n1
p2 1 p2
.
n2
3.9.B.1
When sampling without replacement, two
conditions must be met:
3.9.B.1.i
The randomization condition—the data
should be collected using two independent
random samples.
3.9.B.1.ii
The 10% condition—the size of each
sample should be less than or equal to
10% of the respective population size:
n1 10%N1 and n2 10%N 2 , where N 1
is the size of population 1 and N 2 is the
size of population 2. The sample sizes are
represented as n1 and n2 .
3.9.B.2
If the data come from an experiment, the
data only need to meet the randomization
condition. The treatments must be randomly
assigned to the experimental units to meet the
randomization condition.
continued on next page
Inference for Categorical Data: Proportions
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Justify the appropriateness
of conditions for the sampling
distribution for the difference
between two sample
proportions.
The sampling distribution for the difference
 1 p 2, will have
between sample proportions, p
an approximately normal distribution provided
both sample sizes are large enough. To ensure
that both samples are large enough, the data
must meet the following conditions: n1 p1 10,
n1 1 p1 10, n2 p2 10, and n2 1 p2 10,
where n1 p1 and n2 p2 are the expected number of
successes and n1 1 p1 and n2 1 p2 are the
expected number of failures.
3.9.B
[Skill 4.E]
3.9.C
Interpret the mean, standard
deviation, and probabilities for
the sampling distribution for
the difference between two
sample proportions.
[Skill 4.D]
UNIT
3.9.B.3
3.9.C.1
The mean, standard deviation, and probabilities
for the sampling distribution for the difference
between two sample proportions should be
interpreted within the context of two specific
populations.
UNIT
SKILLS
2.C
Identify appropriate statistical
inference methods.
3.E
Calculate appropriate
statistical inference method
results.
4.E
Justify the use of a chosen
statistical inference method by
verifying conditions.
Inference for Categorical Data: Proportions
```


## AP Statistics CED fact pack (course-wide sections and units up to 3)
# AP Statistics 2026-27 — CED Fact Pack (G0A authoring input)

**Status:** APPROVED (2026-08-02) — approved with Jill's edits incorporated (curvature clarification in §8; "4 removed topics" correction in §9, item 2). This is the **only sanctioned authoring input** for the AP Statistics content rebuild cascade (`AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md`, Gate G0A). Claude authors items from *this* document, not from the CED PDF.
**School year:** `2026-27` (canonical form per `DECISION-0037`) · **Exam administered:** May 2027
**Prepared:** 2026-07-13 · **Owner to confirm:** Orly Bloom
**Related:** `DECISION-0036`, `DECISION-0037`, `TASK-0017`, orchestration spec.

## Provenance & rights (read first)

This fact pack is derived from the **structure and metadata** of the *AP Statistics Course and Exam Description, Effective Fall 2026* (unit/topic map, practices, weights, exam blueprint, task-verb definitions, published revisions) and from the College Board revision page. It contains **no official College Board questions, scoring guidelines, or verbatim exam content** — those must never enter authoring (`DECISION-0031`/`0033`). Any item authored from this pack is independently constructed synthetic content.

**Confidence flags:** exam structure, practices/skills, unit weights, FRQ archetypes, task verbs, and the confirmed removals are transcribed directly from the CED and verified. **Per-topic skill tags (§3) are SOURCE-VERIFIED as of 2026-08-02:** all 55 topic rows were independently checked against the Fall-2026 CED's Unit-at-a-Glance tables (`docs/teaching/ap-statistics-course-and-exam-description.pdf`, Units at pp. 27–28, 59–60, 83–84, 118–119, 146) — zero missing skills, zero extra skills, zero wrong codes, zero material title mismatches; the Unit 5 LO→skill footnote was additionally confirmed against CED topic pages 151–154. This verification is transcription-fidelity only, performed by AI against the source PDF. **Jill's SME confirmation of the anchoring remains open but was explicitly DEFERRED by David on 2026-08-02** (she's needed elsewhere; blast radius is zero until bulk Statistics authoring begins) — the prepared review Sheet exists and can be sent whenever convenient, and her eventual pass is now exceptions-oriented rather than a row-by-row proofread. Learning-Objective codes follow the pattern `X.Y.A / X.Y.B / …`; **Essential-Knowledge codes** (`X.Y.A.n`) are the granular sub-statements on each CED topic page and are cited per item at authoring time, not bulk-transcribed here.

## 1. Exam structure (verified)

- **3 hours.** Section I: **42 multiple-choice**, 90 min, **50%**. Section II: **4 free-response**, 90 min, **50%**.
- Graphing calculator with statistical capability expected for both sections; formulas/tables provided.
- **Fully digital** (Bluebook) starting this administration — see §7.

## 2. Units, pacing, and MC weighting (verified)

| Unit | Title | ~Class periods | MC exam weight |
|---|---|---|---|
| 1 | Exploring One-Variable Data and Collecting Data | ~26 | 20–30% |
| 2 | Probability, Random Variables, and Probability Distributions | ~24 | 15–25% |
| 3 | Inference for Categorical Data: Proportions | ~30 | 15–25% |
| 4 | Inference for Quantitative Data: Means | ~18 | 10–20% |
| 5 | Regression Analysis | ~9 | 10–20% |

## 3. Topic map with anchored skills — source-verified 2026-08-02; Jill's SME confirmation deferred (see §9, item 2)

Per topic: **skills** (read from the CED Unit-at-a-Glance). Skill → practice: `1.x`→P1, `2.x`→P2, `3.x`→P3, `4.x`→P4. LO codes follow `X.Y.A/B/C`; EK codes `X.Y.A.n` are cited per item at authoring time. **Provenance:** this table was salvaged from the archived branch (`archive/codex-five-subject-20260727`) and then independently verified against the Fall-2026 CED Unit-at-a-Glance tables on 2026-08-02 — all 55 rows exact (see Confidence flags above). Jill's SME confirmation is deferred, not waived: it must land before bulk Statistics authoring keys items off these tags.

**Unit 1 — Exploring One-Variable Data and Collecting Data**

| Topic | Title | Skills |
|---|---|---|
| 1.1 | Introducing Statistics: What Can We Learn from Data? | 1.A, 2.A |
| 1.2 | Variables | 2.A |
| 1.3 | Tabular Representation and Summary Statistics for One Categorical Variable | 3.A, 4.A |
| 1.4 | Graphical Representations for One Categorical Variable | 3.A, 4.A, 4.B |
| 1.5 | Graphical Representations for One Quantitative Variable | 3.A |
| 1.6 | Descriptions for One Quantitative Variable Distributions | 4.A, 4.B |
| 1.7 | Summary Statistics for One Quantitative Variable | 3.B, 4.A, 4.B |
| 1.8 | Graphical Representations of Summary Statistics for One Quantitative Variable | 3.A, 4.A |
| 1.9 | Comparisons of the Distributions for One Quantitative Variable | 3.B, 4.A, 4.B, 4.C |
| 1.10 | The Investigative Question Revisited and Data Collection | 1.A, 2.A, 2.B |
| 1.11 | Random Sampling | 2.A, 2.B |
| 1.12 | Potential Problems with Sampling | 2.A |
| 1.13 | Experimental Design | 2.A, 2.B |

*LO→skill (from topic pages):* 1.1.A [2.A], 1.1.B [1.A]; 1.2.A/B/C [2.A]; 1.3.A [3.A], 1.3.B [4.A]; 1.4.A [3.A], 1.4.B [4.B], 1.4.C [4.A]; 1.5.A [3.A]; 1.6.A [4.A], 1.6.B [4.B]; 1.7.A/B [3.B] (+ measures-of-spread LO).

**Unit 2 — Probability, Random Variables, and Probability Distributions**

| Topic | Title | Skills |
|---|---|---|
| 2.1 | Tabular and Graphical Representations for the Distributions of Two Categorical Variables | 4.A, 4.B |
| 2.2 | Summary Statistics for Two Categorical Variables | 3.B, 4.A, 4.B |
| 2.3 | Estimating Probabilities Using Simulation | 3.C |
| 2.4 | Introduction to Probability | 3.C |
| 2.5 | Mutually Exclusive Events | 4.B |
| 2.6 | Conditional Probability | 3.C |
| 2.7 | Independent Events and Unions of Events | 3.C |
| 2.8 | Introduction to Random Variables and Probability Distributions | 3.A |
| 2.9 | Parameters of Random Variables | 3.B, 4.D |
| 2.10 | The Binomial Distribution | 3.C, 3.D, 4.B, 4.D |
| 2.11 | The Normal Distribution | 3.C, 3.D, 4.C |
| 2.12 | Sampling Distributions and the Central Limit Theorem | 4.C |

**Unit 3 — Inference for Categorical Data: Proportions**

| Topic | Title | Skills |
|---|---|---|
| 3.1 | Estimators | 3.D, 4.B |
| 3.2 | Sampling Distributions for Sample Proportions | 3.D, 4.D, 4.E |
| 3.3 | Constructing a Confidence Interval for a Population Proportion | 2.C, 3.E, 4.E |
| 3.4 | Justifying a Claim Based on a Confidence Interval for a Population Proportion | 2.D, 4.F, 4.G |
| 3.5 | Setting Up a Test for a Population Proportion | 2.C, 2.E, 4.E |
| 3.6 | p-Values | 4.F |
| 3.7 | Carrying Out a Test for a Population Proportion | 3.E, 4.G |
| 3.8 | Potential Errors When Performing Tests | 2.D, 3.C, 4.D |
| 3.9 | Sampling Distributions for the Difference Between Sample Proportions | 3.D, 4.D, 4.E |
| 3.10 | Constructing a Confidence Interval for the Difference Between Two Population Proportions | 2.C, 3.E, 4.E |
| 3.11 | Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Proportions | 4.F, 4.G |
| 3.12 | Setting Up a Test for the Difference Between Two Population Proportions | 2.C, 2.E, 4.E |
| 3.13 | Carrying Out a Test for the Difference Between Two Population Proportions | 3.E, 4.F, 4.G |
| 3.14 | Setting Up a Chi-Square Test for Homogeneity or Independence | 2.C, 2.E, 4.C, 4.E |
| 3.15 | Carrying Out a Chi-Square Test for Homogeneity or Independence | 3.C, 3.E, 4.F, 4.G |

**Unit 4 — Inference for Quantitative Data: Means**

| Topic | Title | Skills |
|---|---|---|
| 4.1 | Sampling Distributions for Sample Means | 3.D, 4.D, 4.E |
| 4.2 | Constructing a Confidence Interval for a Population Mean or Population Mean Difference | 2.C, 3.E, 4.C, 4.E |
| 4.3 | Justifying a Claim Based on a Confidence Interval for a Population Mean or Population Mean Difference | 2.D, 4.F, 4.G |
| 4.4 | Setting Up a Test for a Population Mean or Population Mean Difference | 2.C, 2.E, 4.E |
| 4.5 | Carrying Out a Test for a Population Mean or Population Mean Difference | 3.E, 4.F, 4.G |
| 4.6 | Sampling Distributions for the Difference Between Two Sample Means | 3.D, 4.D, 4.E |
| 4.7 | Constructing a Confidence Interval for the Difference Between Two Population Means | 2.C, 3.E, 4.E |
| 4.8 | Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Means | 4.F, 4.G |
| 4.9 | Setting Up a Test for the Difference Between Two Population Means | 2.C, 2.E, 4.E |
| 4.10 | Carrying Out a Test for the Difference Between Two Population Means | 3.E, 4.F, 4.G |

**Unit 5 — Regression Analysis**

| Topic | Title | Skills |
|---|---|---|
| 5.1 | Graphical Representations Between Two Quantitative Variables | 3.A, 4.A, 4.B |
| 5.2 | Correlation | 4.D |
| 5.3 | Linear Regression Models | 3.B |
| 5.4 | Residuals | 3.B, 4.A, 4.D |
| 5.5 | Least-Squares Regression | 3.B, 4.D |

*LO→skill (from topic pages):* 5.3.A [3.B]; 5.4.A [3.B], 5.4.B [4.D], 5.4.C [4.A]; 5.5.A [3.B], 5.5.B [4.D].

**Removed-topic note:** the four removed in-unit topics plus the wholesale removal of old Unit 9 (§8) are already absent from this map — the new Unit 5 has no slope-inference topic, and Unit 3's chi-square is homogeneity/independence only (no goodness-of-fit). Author only against the topics listed above.

## 4. Statistical practices & skills (verified)

- **Practice 1 — Formulate Questions:** determine an investigative question for a statistical study. Skill **1.A** (determine a valid investigative question requiring a statistical investigation).
- **Practice 2 — Collect Data:** identify/justify methods for collecting data and conducting inference. Skills **2.A** identify information to answer a question/solve a problem · **2.B** justify an appropriate method for ethically gathering and representing data · **2.C** identify appropriate statistical inference methods · **2.D** identify types of errors and relationships among components in inference methods · **2.E** identify the null and alternative hypotheses.
- **Practice 3 — Analyze Data:** construct representations and calculate numerical outputs. Skills **3.A** construct tabular/graphical representations · **3.B** calculate summary statistics, relative positions, predicted responses · **3.C** calculate/estimate expected counts, percentages, probabilities, intervals · **3.D** calculate means, SDs, parameters for probability distributions · **3.E** calculate appropriate inference-method results.
- **Practice 4 — Interpret Results:** interpret results and justify conclusions/methods. Skills **4.A** describe/compare representations & summary stats · **4.B** justify a claim from calculations/results · **4.C** describe distributions & compare relative positions · **4.D** interpret calculations/results to assess meaning or a claim · **4.E** justify a chosen inference method by verifying conditions · **4.F** interpret inference-method results · **4.G** justify a claim from inference-method results.

**MC practice weighting (verified):** P1 5–10% · P2 20–30% · P3 25–35% · P4 25–35%.

## 5. Free-response archetypes (verified) — authoring targets

Section II is **4 questions, 10 points each, 12.5% weight each**, multi-part (lettered parts A/B/C…, numbered sub-parts i/ii…), **each point scored independently**.

- **Q1 — Multi-Focus on Practices 1 & 2:** multi-part; primarily formulating questions + collecting/representing data (sampling methods, study design, investigative questions).
- **Q2 — Multi-Focus on Practices 3 & 4:** multi-part; analyzing data + interpreting results (representations, summary statistics, describing/comparing distributions).
- **Q3 — Inference:** a hypothesis test **or** confidence interval; inference skills across Practices 2, 3, 4 (identify procedure → check conditions → calculate → justify conclusion in context).
- **Q4 — Multi-Focus on Practices 2, 3, & 4:** multi-part, spans multiple content areas.

## 6. Task verbs (verified) — the rubric must match the verb's demand

**Calculate** (perform steps to a final answer) · **Compare** (describe similarities/differences; numerically or across distributions) · **Complete** (identify parts, justify conditions, calculate the inference result) · **Construct** (represent data graphically/tabularly) · **Describe** (give relevant characteristics) · **Determine** (apply a method / reach a conclusion from findings) · **Estimate** (use models/representations to approximate) · **Explain** (give reasoning for how/why, with evidence) · **Identify/Classify** (name without elaboration) · **Interpret** (connect a result to the real-world context) · **Justify** (give evidence/statistical reasoning to support or qualify a claim).

Authoring rule: an "Identify" part must not require justification in its criterion; an "Explain"/"Justify" part must require reasoning, not a bare term. (Mirrored in the reviewer standard, `TUTOR_REVIEWER_QUICKSTART.md`.)

## 7. Response modality / digital constraints (verified)

Fully digital in Bluebook: keyboard entry, an updated symbols menu, a **built-in Desmos graphing calculator**, and questions designed to **minimize burdensome symbolic entry**. Scratch paper for planning only; printed reference booklet provided. Cramapple has **no Desmos-equivalent**, so hand-drawn graph practice remains valuable but is tagged **supplemental** (`supplemental_hand_drawn`), never represented as simulating the real exam. Exam-aligned items are tagged `exam_aligned_digital`.

## 8. Confirmed removals (verified against the CB revision page) — do NOT author these as tested content

1. Analyzing **departures from linearity** (old 2.9)
2. **Combining random variables** (old 4.9)
3. **Geometric distribution** (old 4.12)
4. **Chi-square goodness-of-fit** test (old 8.2/8.3)
5. **Inference for slopes** — the entire old Unit 9

**Retained:** residual plots and determination of appropriateness of the linear model by analyzing patterns (especially curvature) in the residuals (new Topic 5.4) — only the "departures from linearity" framing is removed. Do not conflate. Chi-square tests for **homogeneity/independence** remain (Topics 3.14–3.15); only goodness-of-fit is gone.

## 9. Open items for Orly (G0A sign-off)

1. **Confirm** the unit/topic map and weights above (correct any transcription).
2. **Jill: confirm the §3 skill/LO anchoring is correct.** This table (all 60 topics) was salvaged from an unmerged branch and has never been checked by a subject-matter expert — treat it as a candidate, not a verified fact, until she signs off. Flag any topic whose skill tag looks wrong.
3. **Remap rules** for the 4 removed topics: which legacy items truly test a removed concept vs. can be remapped; residual-plot items given the retained-but-reframed status.
4. **Supplemental policy** (`DECISION-0037` Q3 default = keep removed-topic/hand-drawn as clearly labeled supplemental) — confirm.
5. **Inventory distribution:** 71 MCQ / 33 FRQ across the 5 units by MC weight + the 4 FRQ archetypes (Claude to propose the per-unit split for Orly's OK).

**2026-08-08 addition note:** the section below was added by Claude on 2026-08-08 by reading the primary-source PDFs directly (`Subject Packs/Statistics/ap-statistics-course-and-exam-description.pdf`, topic pages for Units 1-5 plus the Appendix formula sheet pp. 227-229; `ap25-cr-report-statistics.pdf`; `ap25-sg-statistics.pdf`; `ap26-frq-statistics.pdf`) to deepen this fact pack to the same equation/boundary-statement/misconception density already built for Biology, Chemistry, Calculus AB/BC, Precalculus, and the three Physics packs. **It carries no governance status of its own — it is UNREVIEWED, pending the same Jill/Orly sign-off gate that applies to §3's existing anchoring table (see §9, item 2). Do not treat §10 as APPROVED alongside §1-§9.**

## 10. Units 1-5 deep-tier detail (2026-08-08 addition — UNREVIEWED, pending Jill/Orly sign-off, same gate as §3)

Added 2026-08-08, NOT yet reviewed by Jill/Orly — same sign-off gate as §3's existing anchoring table applies to this section too. Sourced from direct PDF reads of the Fall-2026 CED topic pages (printed pp. 29-154, offset +5 from PDF page number) for every topic 1.1-5.5 already listed in §3, plus the Appendix Formula Sheet (printed pp. 227-229). Misconception data is drawn from the *2025 AP Statistics Chief Reader Report* (`ap25-cr-report-statistics.pdf`) and cross-checked against `ap25-sg-statistics.pdf` and `ap26-frq-statistics.pdf`.

**Critical dating caveat, applied throughout this section:** all four exam-cycle sources (2025 Chief Reader Report, 2025 Scoring Guidelines, 2025 FRQ booklet, 2026 FRQ booklet) predate the Fall-2026 restructure this fact pack documents — the restructured exam is not administered until May 2027 (see header block). The 2025 Chief Reader Report scores a **6-question, old-unit-numbering** FRQ format (old Units 1, 3, 4, 6, 7 cited by name in the report text) that no longer matches this pack's 4-question Section II (§5) or 5-unit map (§2-§3). Two specific pieces of content encountered while reading these sources were confirmed **out of scope** under §8's removals and excluded from what follows: (1) 2025 CR Report Question 6, which scores a Cohen's *d* effect-size calculation — no topic page in Units 1-5 of the Fall-2026 CED mentions Cohen's *d* or effect size at all, so it is treated as legacy/non-current content, not reintroduced; (2) 2026 FRQ Question 3, Part C, which asks students to find the mean and standard deviation of "the number of games Ben will attend until a performance takes longer than 120 seconds" — a textbook **geometric distribution** setup, explicitly on §8's removed-topics list (old 4.12) — excluded. Parts A and B of that same 2026 FRQ Question 3 (normal-distribution probability; binomial count of exceedances) test retained content and are used below. Every other misconception cited below was checked against §8's removal list before inclusion and maps to a topic that remains in the current 5-unit map.

**General finding — boundary/exclusion statements:** a full-text search of the CED PDF for the phrasing patterns Physics/Chemistry/Biology topic pages use for scope caps ("does not expect," "is not expected," "only expect," "not required to," "out of scope," "not assessed") returns **zero matches** anywhere in the Statistics CED outside one unrelated sentence in the front matter about AP's Course Audit policy. Unlike the Physics 1/2/C packs, **no Statistics topic page in Units 1-5 contains a verbatim boundary/exclusion statement of that form.** Scope in this course is instead conveyed entirely through the Learning Objective / Essential Knowledge (LO/EK) text itself — e.g., a topic's EK simply never mentions a rejected alternative (no EK anywhere states a distribution-shape claim is acceptable from a boxplot, for instance; the *absence* is the boundary, confirmed independently by 2025 SG Q1's scoring note that shape claims from a boxplot always score Incorrect). Per-topic entries below therefore state "Zero explicit exclusion statements (CED-wide finding — see general note above)" rather than repeating a search result 55 times.

### General exam-wide conventions (apply across all units)

- **Official formula sheet (Appendix, printed pp. 228-229)** groups every inference formula under one template that the exam provides verbatim and that authored rubrics should mirror: **standardized test statistic** = (statistic − parameter) / (standard error of the statistic); **confidence interval** = statistic ± (critical value)(standard error of the statistic). Every unit-specific test statistic and CI formula below is an instantiation of these two templates — authored scoring criteria for "identify the correct test statistic/CI structure" should accept the generic template as well as the fully-substituted unit-specific formula.
- **E/P/I scoring convention (verified from `ap25-sg-statistics.pdf`):** every FRQ part is scored Essentially correct (E) / Partially correct (P) / Incorrect (I) against a fixed list of numbered components (typically 2-4 per part); E requires meeting a stated majority of components (e.g., "at least three of the following four"), P requires exactly a stated subset (e.g., "only two of the four"), I is everything else. Cramapple rubrics for multi-part FRQ-style items should mirror this component-counting structure rather than binary right/wrong scoring.
- **Non-definitive conclusion language is a repeated, explicit scoring requirement.** Every inference topic's EK (3.7.B.6, 3.13.C.3, 3.15.D.3, 4.5.C.3, 4.10.C.3) states the conclusion "should contain a reference to the parameter and the population" and be phrased in terms of the alternative hypothesis "using non-definitive language." The 2025 CR Report documents this as a recurring, scored error across Q4-Q6: students writing "we have proof that..." or "Karen's school's proportion IS greater than 0.22" instead of "there is convincing statistical evidence that...". This is a course-wide authoring convention, not a one-topic quirk — any authored hypothesis-test conclusion criterion should require non-definitive ("convincing evidence to suggest," never "prove"/"is") phrasing.
- **Condition-checking has a fixed three-condition template repeated across every inference procedure** (proportions: 3.3.B.1/3.5.C.1/3.9.B.1/etc.; means: 4.1.B.1/4.2.C.1/4.4.C.1/etc.): randomization condition (random sample or random assignment) → 10% condition (population ≥ 10× sample size, waived for randomized experiments) → a distributional-shape condition (large-counts $np\ge10,\ n(1-p)\ge10$ for proportions; normality/$n\ge30$/skewness-and-outlier check for means). The 2025 CR Report documents students routinely mislabeling which condition is which (e.g., writing "$n>30$" as if it satisfies the 10% condition, or comparing counts to 30 instead of 5/10) — a good authored-distractor pattern for "identify the flawed condition check" items.
- **z vs. t is determined solely by whether $\sigma$ is known**, per 4.2.A.2: "$t$-distributions are used for finding critical values and test statistics for inferences about a population mean, $\mu$, when the population standard deviation, $\sigma$, is unknown and the sample standard deviation, $s$, must be used instead." Proportions always use $z$ (no analogous $t$-procedure exists in this course); means always use $t$ in this course, since $\sigma$ is never given for a mean scenario at this level. The CR report documents "confusing $t$-tests with $z$-tests" as a recurring instructor-flagged error category (2026 Unit 4 "Building Statistical Practices" teacher note, `ap-statistics-course-and-exam-description.pdf` printed p. 117).
- **Digital-exam calculator syntax is explicitly penalized if left unlabeled.** 2025 CR Report Q3/Q4 both flag responses that wrote raw calculator syntax (e.g., `P(X≥4)=1-binomcdf(20,0.1,3)`) without labeling $n$ and $p$ in words — such responses lose the "parameters" scoring component even when the final numeric answer is correct. Authored rubrics should require labeled parameters, not just a correct final value.

### Unit 1 — Exploring One-Variable Data and Collecting Data

**1.1-1.2 (Introducing Statistics / Variables).** No equations; pure vocabulary EK (statistical study, population $N$, sample $n$, parameter vs. statistic, categorical vs. quantitative, discrete vs. continuous). Zero explicit exclusion statements (CED-wide finding — see general note above).

**1.3-1.4 (Tabular/Graphical Representations for One Categorical Variable).** Frequency table = observational-unit counts per category; relative frequency table = proportions. No equations beyond counts/proportions. Zero explicit exclusion statements.

**1.5 (Graphical Representations for One Quantitative Variable).** Histogram, stem-and-leaf plot, dotplot — all EK-only, no formulas. Zero explicit exclusion statements. **Documented misconception (2026 FRQ Q1):** the released 2026 FRQ Question 1 (Breed H/J goat weights) explicitly tests that a **stem-and-leaf plot reveals gaps/clusters within a bin that a boxplot's five-number summary cannot show** — Part C directly asks students to name a shape characteristic visible in the stem-and-leaf plot but not the boxplot, and explain why. Good template for an authored "compare representations" item.

**1.6 (Descriptions for One Quantitative Variable Distributions).** Shape (skew direction, uni/bi/multimodal, uniform), outliers, gaps, clusters — EK-only. Zero explicit exclusion statements. **Documented misconception (2025 CR Report Q1, boxplot shape):** the single most repeated error in the entire report — students describe boxplot shape as "normal," "unimodal," or with an unjustifiable skew direction. The 2025 SG explicitly bars this: "If the response describes the shape of either distribution as just 'symmetric,' 'normal,' 'unimodal,' or an incorrect shape... then part A cannot be scored E" — **modality and normality can never be read off a boxplot**, only skew direction inferred from whisker/box asymmetry, and even that requires the box position, not just eyeballing.

**1.7 (Summary Statistics for One Quantitative Variable).** Mean $\bar{x}=\frac{1}{n}\sum x_i$; median (middle value, or mean of two middle values if $n$ even); range = max − min; IQR = $Q_3-Q_1$; sample standard deviation $s=\sqrt{\frac{1}{n-1}\sum(x_i-\bar{x})^2}$, sample variance $s^2$; outlier rules: $>1.5\times IQR$ beyond $Q_1$/$Q_3$, **or** $>2$ standard deviations from the mean (both rules given — EK 1.7.D.1.i/ii — with no stated preference between them). Median/IQR = resistant; mean/range/SD = nonresistant. Zero explicit exclusion statements. **Documented misconception (2025 CR Report Q1, Parts B-C):** (1) students correctly state the mean is pulled above the median by a right skew/upper outlier but fail to *link* the numeric median value (18 mpg) to the justification — a common "correct concept, missing the numeric tie-in" pattern; (2) for the median of a *combined* two-sample dataset, many responses incorrectly averaged the two group medians rather than reasoning from the combined ordered position (a well-documented, exam-worthy distractor: "average the medians" is a plausible-looking but wrong shortcut).

**1.8 (Graphical Representations of Summary Statistics).** Five-number summary (min, $Q_1$, median, $Q_3$, max); boxplot construction (box = middle 50%, whiskers to non-outlier extremes, outliers marked separately); mean-vs-median-position rule (symmetric ⇒ close; right-skewed ⇒ mean > median; left-skewed ⇒ mean < median). Zero explicit exclusion statements.

**1.9 (Comparisons of Distributions / z-scores).** $z=\frac{x_i-\mu}{\sigma}$ (population parameters; sample mean/SD substituted when population values unknown — no separate notation given for that substitution, i.e., the same $z$ formula is reused with $\bar{x}$/$s$). Zero explicit exclusion statements.

**1.10-1.13 (Investigative Question / Sampling / Experimental Design).** All EK-only, no equations. Key vocabulary distinctions worth flagging for authoring: census vs. sample; prospective vs. retrospective observational study; SRS vs. stratified vs. cluster vs. systematic random sample (1.11.A.3-6 — note clustering samples *all* observational units within *selected clusters*, the opposite of stratified sampling which samples *within every* stratum); four bias types (voluntary response, undercoverage, nonresponse, response/question-wording); four experimental-design requirements (comparison of ≥2 treatment groups, random assignment, replication, direct control of extraneous variables); single- vs. double-blind; placebo effect defined as *difference between average placebo response and average no-treatment response* (a precise, testable definition, not just "fake treatment"); completely randomized vs. randomized block vs. matched-pairs design. Zero explicit exclusion statements anywhere in 1.10-1.13. **Documented misconception (2025 CR Report Q2, sampling):** students correctly identify a biased sampling method but reach for the wrong named bias (confounding, small sample size) instead of the actually-applicable one (undercoverage/nonrepresentativeness) — vocabulary-precision distractor pattern; and when asked to *implement* a random sampling procedure, responses often assert "generate random numbers" without specifying the process (range of numbers, what happens on a repeat, mapping numbers back to labeled units) — an implementation-completeness distractor pattern good for "identify the incomplete sampling procedure" MCQ or short-FRQ items.

### Unit 2 — Probability, Random Variables, and Probability Distributions

**2.1-2.2 (Two-Categorical-Variable Representations).** Two-way/contingency tables; joint relative frequency (cell/table total), marginal relative frequency (row or column total/table total), conditional relative frequency (cell/row-or-column total). EK-only. Zero explicit exclusion statements.

**2.3 (Estimating Probabilities Using Simulation).** Law of Large Numbers (long-run relative frequency → true probability as trials increase). EK-only, no equation. Zero explicit exclusion statements.

**2.4 (Introduction to Probability).** $P(E)=\frac{\text{number of outcomes in }E}{\text{total outcomes in sample space}}$ (equally likely outcomes only); $0\le P(E)\le1$; complement rule $P(E^C)=1-P(E)$. Zero explicit exclusion statements.

**2.5-2.7 (Mutually Exclusive / Conditional / Independent Events).** Joint probability $P(A\cap B)$; mutually exclusive $\Leftrightarrow P(A\cap B)=0$; conditional probability $P(A\mid B)=\frac{P(A\cap B)}{P(B)}$; general multiplication rule $P(A\cap B)=P(A)\cdot P(B\mid A)$; independence test: $A,B$ independent iff $P(A\mid B)=P(A)$, equivalently $P(A\cap B)=P(A)\cdot P(B)$; union rule $P(A\cup B)=P(A)+P(B)-P(A\cap B)$ (also on the official formula sheet). Zero explicit exclusion statements. **Documented misconception (2025 CR Report Q3, Part A(ii)):** the report gives an exact, quotable common error — multiplying $\frac{100}{1{,}000}\times\frac{99}{999}$ (a without-replacement, dependent-events calculation) when the problem's events were actually independent, i.e., **students default to a without-replacement/dependence assumption even when independence is the correct model** — a strong, specific authored-distractor for a "which formula applies" item.

**2.8 (Random Variables / Probability Distributions intro).** Discrete probability distribution: sums to 1; can be table, graph, or function; cumulative distribution = $P(X\le x)$. EK-only. Zero explicit exclusion statements.

**2.9 (Parameters of Random Variables).** Expected value $\mu_X=E(X)=\sum x_i\cdot P(x_i)$; standard deviation $\sigma_X=\sqrt{\sum(x_i-\mu_X)^2\cdot P(x_i)}$; variance $V(X)=\sigma_X^2$ (both also on the official formula sheet). Zero explicit exclusion statements. **Documented misconception (2025 CR Report Q3/Q5):** two distinct, well-documented errors: (1) computing the *unweighted* mean of the possible $X$-values instead of the probability-weighted mean (dropping the $P(x_i)$ factor entirely); (2) misreading a compound event like "fewer than 3" as "3 or fewer" (i.e., off-by-one boundary-inclusion errors on discrete-variable events) — both are strong, exact authored-distractor patterns.

**2.10 (Binomial Distribution).** Binomial PMF $P(X=x)=\binom{n}{x}p^x(1-p)^{n-x}$, $x=0,1,\dots,n$; $\mu_X=np$; $\sigma_X=\sqrt{np(1-p)}$ (all three on the official formula sheet). Binomial requires: fixed $n$ independent trials, two outcomes per trial, constant $p$. Zero explicit exclusion statements. **Documented misconception (2025 CR Report Q3, Part B(i)):** students frequently (a) define the random variable imprecisely — "rock songs" instead of "the number of rock songs played in one hour" — or omit the count/interval framing entirely; (b) state the distribution "is distributed randomly" instead of naming it binomial with stated $n,p$; (c) **misidentify a binomial-count random variable as normally distributed.** Also documented: calculator-syntax answers (`binomcdf(...)`) that omit labeled $n$/$p$ lose the parameters-labeled scoring component even with a correct numeric result — see the general exam-wide convention above.

**2.11 (Normal Distribution).** Empirical rule (68-95-99.7 within 1/2/3 SD of mean); standard normal $\mu=0,\sigma=1$; interval-probability notation using $x_a$ (lower bound), $x_b$ (upper bound), and $p$ as a percentage 0-100 (not a proportion 0-1) in EK 2.11.E.2.i-iv — this $p$-as-percentage convention is a notation trap worth flagging for authored solutions that otherwise use $p$ as a proportion. Zero explicit exclusion statements.

**2.12 (Sampling Distributions and CLT).** Sampling distribution defined as the distribution of a statistic over all possible samples of a given size; randomization distribution (simulation-based, for reallocation/permutation tests) explicitly distinguished from a sampling distribution; CLT: sampling distribution of a sample mean is approximately normal, improving with sample size. Zero explicit exclusion statements. This topic is purely conceptual scaffolding for Units 3-4's sampling-distribution EK, which restates and specializes it per-statistic (see Unit 3/4 below).

**No misconception data available from the reviewed sources for Topics 2.1-2.2, 2.8, 2.11-2.12** specifically — the 2025 CR Report's Q3 (the only Unit 2-mapped FRQ in the pass) concentrated on 2.7/2.9/2.10; treat gaps in 2.1-2.2/2.8/2.11-2.12 misconception coverage as thin, pending a future pass against MCQ-level released items.

### Unit 3 — Inference for Categorical Data: Proportions

**3.1 (Estimators).** Unbiased estimator: does not systematically over/underestimate on average; $\hat{p}$ is the point estimator for $p$. Zero explicit exclusion statements.

**3.2 (Sampling Distribution for $\hat p$).** $\mu_{\hat p}=p$; $\sigma_{\hat p}=\sqrt{\frac{p(1-p)}{n}}$ (formula sheet). Normality requires $np\ge10$ and $n(1-p)\ge10$ (large-counts condition); randomization + 10% conditions per the general template above. Zero explicit exclusion statements.

**3.3-3.4 (CI for One Proportion; Justifying a Claim).** One-sample $z$-interval: $\hat{p}\pm z^{*}\sqrt{\frac{\hat p(1-\hat p)}{n}}$; standard error $SE_{\hat p}=\sqrt{\frac{\hat p(1-\hat p)}{n}}$; margin of error $=z^{*}\cdot SE$; required sample size (solve MOE formula for $n$, use $\hat p=0.5$ worst-case if $\hat p$ unknown): $n=\frac{(z^{*})^2\hat p(1-\hat p)}{MOE^2}$. Three conditions: randomization, 10%, normality ($n\hat p\ge10$ and $n(1-\hat p)\ge10$). Confidence-level interpretation is the repeated-sampling long-run-capture-rate frame (EK 3.4.A.2), not "probability the parameter is in this interval." Zero explicit exclusion statements.

**3.5-3.8 (Test for One Proportion; p-Values; Type I/II Errors).** $H_0: p=p_0$; one- or two-sided $H_a$; test statistic (formula sheet standardized-statistic template, specialized): $z=\frac{\hat p-p_0}{\sqrt{\frac{p_0(1-p_0)}{n}}}$ — note the null-hypothesized $p_0$, not $\hat p$, appears under the radical (a common authored-distractor: swapping $\hat p$ and $p_0$ in the denominator). Conditions: randomization, 10%, normality using $np_0\ge10$/$n(1-p_0)\ge10$ (note: uses $p_0$ here, vs. $\hat p$ for the CI condition — another precise, testable distinction). Type I error: reject true $H_0$ (rate $=\alpha$); Type II error: fail to reject false $H_0$ (rate $=1-\text{power}$); power increases with larger $n$, smaller $SE$, larger true-vs-null gap, or larger $\alpha$. Zero explicit exclusion statements. **Documented misconception (2025 CR Report Q4 and Q5, extensively documented):** (1) writing hypotheses in nonstandard/undefined notation, e.g. $H_0: x=0.22$ instead of $H_0: p=0.22$; (2) an incomplete parameter description lacking population context; (3) failing to check *both* halves of the randomization+10% condition (stating "random" without specifying sample vs. assignment, or 10%-checking against an unstated/contradicted population); (4) comparing counts to 30 instead of 5/10 for the large-counts condition (confusing the means large-sample rule with the proportions large-counts rule — a cross-unit confusion worth flagging); (5) placing $\hat p$ instead of $p_0$ under the radical in the test statistic (yields a materially different, wrong $z$); (6) using a confidence interval to conduct what should be a one-sided significance test — flagged explicitly as an error pattern in the CR report; (7) definitive conclusion language ("we have proof," "IS greater than") — see the general exam-wide convention above; (8) for Type I/II error definitions specifically (2025 CR Report Q5): omitting the conditional framing ("...given $H_0$ is true"), or defining a Type I error using Type II's logic (and vice versa) — both very common and good MCQ-distractor material.

**3.9-3.11 (Sampling Distribution / CI for Difference of Two Proportions).** $\mu_{\hat p_1-\hat p_2}=p_1-p_2$; $\sigma_{\hat p_1-\hat p_2}=\sqrt{\frac{p_1(1-p_1)}{n_1}+\frac{p_2(1-p_2)}{n_2}}$; two-sample $z$-interval $(\hat p_1-\hat p_2)\pm z^{*}\sqrt{\frac{\hat p_1(1-\hat p_1)}{n_1}+\frac{\hat p_2(1-\hat p_2)}{n_2}}$; large-counts condition uses each sample's own $\hat p_i$ (not pooled) for the CI. If the interval excludes 0, convincing evidence of a difference; if it contains 0, insufficient evidence. Zero explicit exclusion statements.

**3.12-3.13 (Test for Difference of Two Proportions).** $H_0: p_1=p_2$ (equivalently $p_1-p_2=0$); pooled proportion $\hat p_c=\frac{n_1\hat p_1+n_2\hat p_2}{n_1+n_2}$ (used *only* for the test, under the $H_0$ assumption $p_1=p_2$ — **not** used for the CI, which uses each $\hat p_i$ separately: a sharp, testable CI-vs-test distinction); test statistic $z=\frac{(\hat p_1-\hat p_2)-0}{\sqrt{\hat p_c(1-\hat p_c)}\sqrt{\frac{1}{n_1}+\frac{1}{n_2}}}$; large-counts condition uses $n_1\hat p_c,\ n_1(1-\hat p_c),\ n_2\hat p_c,\ n_2(1-\hat p_c)$, all $\ge10$ (pooled, unlike the CI's unpooled condition). Zero explicit exclusion statements.

**3.14-3.15 (Chi-Square Test for Homogeneity/Independence).** Chi-square statistic (formula sheet) $\chi^2=\sum\frac{(\text{Observed}-\text{Expected})^2}{\text{Expected}}$; expected count $=\frac{(\text{row total})(\text{column total})}{\text{table total}}$; $df=(\text{rows}-1)(\text{columns}-1)$; distribution is right-skewed, less skewed as $df$ increases; homogeneity (same categorical variable, multiple populations/treatments) vs. independence (two categorical variables, one population) is a naming distinction only — same statistic, same expected-count formula. Conditions: randomization (random sample for independence; independent random samples or randomized experiment for homogeneity), 10% (waived for randomized experiments), expected-counts condition (**all expected counts $>5$** — note this differs numerically from the proportions/means large-counts threshold of 10, a precise cross-topic distinction). **§8 cross-check: chi-square goodness-of-fit is confirmed absent from these two topics and from the entire Unit 3 topic list — only homogeneity and independence appear, consistent with the fact pack's existing §8 removal note.** Zero explicit exclusion statements otherwise. **No chi-square-specific misconception data was found in the reviewed 2025 CR Report** (its Q4 tested a one-proportion z-test, not chi-square) — treat chi-square misconception coverage as thin pending a future pass against released chi-square FRQs/MCQs.

