# FRQ writing brief: calculus

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


# Arbitration rulings for this group (Product Owner directed Claude to arbitrate edge cases)
- Topic 1.1 overlaps 2.1. Ruling: a 1.1 FRQ uses ONLY average rates over shrinking intervals on both sides of an instant, the zero-length-interval point (CED CHA-1.A.2), estimation from a table of averages, and interpretation in context. No limit notation, no algebraic limit evaluation, no word "derivative". The Product Owner approved this design for AP Calculus AB 1.1 (below). Write AP Calculus BC 1.1 on the same design with a different function, instant and context.
- Topic 2.1: average rates by difference quotients and the instantaneous rate written and evaluated as the limit of a difference quotient (linear or quadratic function), no derivative rules, no estimating a derivative from a table (that is 2.3). The Product Owner approved this design for AP Calculus AB 2.1 (below). Write AP Calculus BC 2.1 on the same design with a different context and data.
- AP Calculus AB 1.1 (approved design, do not copy its numbers):
```json
{
 "title": "Velocity at an Instant from Average Velocities",
 "calculator": "permitted",
 "stimulus": "The position of a particle moving along a straight line is s(t) = t³ − 4t + 2, where s(t) is measured in meters and t is measured in seconds, for 0 ≤ t ≤ 5.",
 "parts": [
  {
   "prompt": "A student says: \"To find the particle's velocity at exactly t = 1, I will use the average velocity formula [s(b) − s(a)] / (b − a) on the interval from t = 1 to t = 1.\" Explain why this does not work.",
   "criteria": [
    {
     "text": "Explains that the interval has length 0, so b − a = 0 and the formula divides by zero, which is undefined.",
     "evidence": "Response states that the change in time is 0 (b − a = 0) and that dividing by 0 makes the average velocity undefined.",
     "fix": "Check the denominator: an average rate needs two different times, so b − a cannot be 0.",
     "accepted_variants": []
    }
   ]
  },
  {
   "prompt": "Find the average velocity of the particle on each of these intervals: [0.9, 1], [0.99, 1], [0.999, 1], [1, 1.1], [1, 1.01] and [1, 1.001]. Show the calculation for the interval [1, 1.01]. Give each answer to four decimal places.",
   "criteria": [
    {
     "text": "Shows the average velocity on [1, 1.01]: [s(1.01) − s(1)] / (1.01 − 1) = (−1.009699 − (−1)) / 0.01 = −0.9699 m/s.",
     "evidence": "Response shows s(1.01) = −1.009699 and s(1) = −1, the difference quotient over a change in time of 0.01, and the value −0.9699.",
     "fix": "Write s(b) − s(a) over b − a with both position values before dividing.",
     "accepted_variants": [
      "-0.9699"
     ]
    },
    {
     "text": "Gives all six average velocities correctly: −1.2900, −1.0299, −1.0030, −0.6900, −0.9699 and −0.9970 m/s.",
     "evidence": "Response lists the six values for the intervals in the order given, each correct to four decimal places.",
     "fix": "Recompute s at each endpoint and keep s(1) = −1 the same in every quotient.",
     "accepted_variants": []
    }
   ]
  },
  {
   "prompt": "Use your results from part (b) to estimate the velocity of the particle at the instant t = 1. Explain how the values support your estimate.",
   "criteria": [
    {
     "text": "Estimates the velocity at t = 1 as −1 m/s.",
     "evidence": "Response states a single estimate of −1 meter per second for the velocity at t = 1.",
     "fix": "State one value with units, read from where the averages are heading.",
     "accepted_variants": [
      "-1 m/s",
      "-1 meter per second"
     ]
    },
    {
     "text": "Justifies that as the intervals shrink toward t = 1 from both sides, the average velocities approach −1.",
     "evidence": "Response notes that the left-interval values (−1.29, −1.0299, −1.0030) and the right-interval values (−0.69, −0.9699, −0.9970) both close in on −1 as the intervals get smaller.",
     "fix": "Describe what the averages do as the intervals shrink, from the left and from the right.",
     "accepted_variants": []
    }
   ]
  },
  {
   "prompt": "The average velocity of the particle over the interval [1, 4] is 17 meters per second. Explain what your answer to part (c) tells you about the particle's motion at the instant t = 1 that the average velocity over [1, 4] does not.",
   "criteria": [
    {
     "text": "States that at t = 1 the particle is moving in the negative direction (backward) at about 1 meter per second.",
     "evidence": "Response interprets the negative velocity at t = 1 as motion in the negative direction with speed about 1 meter per second.",
     "fix": "Interpret the sign of a velocity as a direction of motion.",
     "accepted_variants": []
    },
    {
     "text": "Contrasts this with the 17 m/s average, which describes the overall change in position over the 3 seconds and hides the backward motion at t = 1.",
     "evidence": "Response explains that the average over [1, 4] reflects only the net change in position over the whole interval, so it does not show the direction or speed at the instant t = 1.",
     "fix": "Contrast one instant with a whole interval, in the context of the particle.",
     "accepted_variants": []
    }
   ]
  }
 ],
 "model_answer": "(a) On the interval from t = 1 to t = 1, b − a = 0, so the formula divides by zero and the average velocity is undefined. An average velocity needs two different times.\n\n(b) s(1) = −1 and s(1.01) = −1.009699, so the average velocity on [1, 1.01] is (−1.009699 − (−1)) / 0.01 = −0.009699 / 0.01 = −0.9699 m/s.\nAverage velocities: [0.9, 1]: −1.2900 m/s; [0.99, 1]: −1.0299 m/s; [0.999, 1]: −1.0030 m/s; [1, 1.1]: −0.6900 m/s; [1, 1.01]: −0.9699 m/s; [1, 1.001]: −0.9970 m/s.\n\n(c) The velocity at t = 1 is about −1 m/s. As the intervals shrink toward t = 1, the averages from the left (−1.29, −1.0299, −1.0030) and from the right (−0.69, −0.9699, −0.9970) close in on −1 from both sides.\n\n(d) At t = 1 the particle is moving backward, in the negative direction, at about 1 meter per second. The average velocity of 17 m/s over [1, 4] only describes the net change in position from t = 1 to t = 4; it suggests steady forward motion and hides that the particle is moving backward at t = 1.",
 "verification_python": "from fractions import Fraction as F\ns = lambda t: t**3 - 4*t + 2\ndef avg(a, b): return (s(F(b)) - s(F(a))) / (F(b) - F(a))\nassert s(1) == -1 and s(F(101, 100)) == F(-1009699, 1000000) and s(4) == 50\nexpected = [((F(9,10),1), -1.29), ((F(99,100),1), -1.0299), ((F(999,1000),1), -1.0030), ((1,F(11,10)), -0.69), ((1,F(101,100)), -0.9699), ((1,F(1001,1000)), -0.9970)]\nfor (a, b), v in expected:\n    assert abs(round(float(avg(a, b)), 4) - v) < 1e-9, (a, b, float(avg(a, b)))\nassert avg(1, 4) == 17\nassert 3*1**2 - 4 == -1\nprint('ALL_CHECKS_PASSED')\n"
}
```
- AP Calculus AB 2.1 (approved design, do not copy its numbers):
```json
{
 "title": "Average and Instantaneous Heating Rates of a Metal Rod",
 "calculator": "not_permitted",
 "stimulus": "The temperature of a metal rod, in degrees Celsius (°C), is given by a differentiable function H(t), where t is the number of hours since heating began. Selected values of H(t) are given in the table.\n\nt (hours) | 0 | 2 | 5 | 8 | 12\nH(t) (°C) | 20 | 35 | 60 | 85 | 100",
 "parts": [
  {
   "prompt": "Find the average rate of change of H(t) over the interval [2, 8]. Show the difference quotient you use and include units.",
   "criteria": [
    {
     "text": "Sets up the difference quotient [H(8) − H(2)] / (8 − 2) = (85 − 35) / 6.",
     "evidence": "Response writes the change in H over the change in t using H(8) = 85, H(2) = 35 and a time change of 6 hours.",
     "fix": "Write H(b) − H(a) over b − a with the interval's endpoints before simplifying.",
     "accepted_variants": []
    },
    {
     "text": "Gives the value 25/3, about 8.333, degrees Celsius per hour.",
     "evidence": "Response states 25/3 (or 8.333) with units of degrees Celsius per hour.",
     "fix": "Simplify 50/6 and attach the units of H over the units of t.",
     "accepted_variants": [
      "25/3",
      "8.333",
      "8.33"
     ]
    }
   ]
  },
  {
   "prompt": "Find the average rate of change of H(t) over [0, 2] and over [8, 12]. Over which of these two intervals was the rod heating faster on average? Justify your answer.",
   "criteria": [
    {
     "text": "Gives the average rates 15/2 = 7.5 °C per hour on [0, 2] and 15/4 = 3.75 °C per hour on [8, 12].",
     "evidence": "Response computes (35 − 20)/2 = 7.5 and (100 − 85)/4 = 3.75, both in degrees Celsius per hour.",
     "fix": "Compute each difference quotient separately, dividing by that interval's own length.",
     "accepted_variants": []
    },
    {
     "text": "Concludes the rod heated faster on average over [0, 2], because 7.5 > 3.75.",
     "evidence": "Response names [0, 2] as the faster interval and justifies it by comparing the two average rates.",
     "fix": "Compare the two average rates directly and name the larger one's interval.",
     "accepted_variants": []
    }
   ]
  },
  {
   "prompt": "Write a limit expression, in terms of H, that represents the instantaneous rate of change of the rod's temperature at t = 5 hours. Then explain why the table alone cannot give the exact value of this limit.",
   "criteria": [
    {
     "text": "Writes lim h→0 [H(5 + h) − H(5)] / h, or lim t→5 [H(t) − H(5)] / (t − 5).",
     "evidence": "Response gives a limit of a difference quotient centred at t = 5 with h approaching 0 (or t approaching 5).",
     "fix": "Put the average rate over a shrinking interval at t = 5 inside a limit.",
     "accepted_variants": [
      "lim h→0 (H(5+h) − H(5))/h",
      "lim t→5 (H(t) − H(5))/(t − 5)"
     ]
    },
    {
     "text": "Explains that the table gives H only at t = 2 and t = 8 near t = 5, so the interval cannot be made arbitrarily small.",
     "evidence": "Response states that the limit needs values of H at times arbitrarily close to 5, which the table does not provide.",
     "fix": "Ask what values the limit needs as h shrinks, and whether the table has them.",
     "accepted_variants": []
    }
   ]
  },
  {
   "prompt": "A second rod's temperature is G(t) = 15t + 20 °C. Use the limit of a difference quotient to find the instantaneous rate of change of G at t = 5, showing the algebra. Interpret your answer in context.",
   "criteria": [
    {
     "text": "Evaluates lim h→0 [G(5 + h) − G(5)] / h = lim h→0 [15(5 + h) + 20 − 95] / h = lim h→0 15h / h = 15.",
     "evidence": "Response substitutes G(5 + h) and G(5) = 95, simplifies the numerator to 15h, cancels h and obtains 15.",
     "fix": "Expand G(5 + h), subtract G(5) = 95, and simplify before letting h approach 0.",
     "accepted_variants": []
    },
    {
     "text": "Interprets 15 as: at t = 5 hours, the second rod's temperature is increasing at 15 °C per hour.",
     "evidence": "Response states the rate with units of degrees Celsius per hour and describes the temperature as increasing at the instant t = 5.",
     "fix": "State the rate with units and say what is changing, at which time.",
     "accepted_variants": []
    }
   ]
  }
 ],
 "model_answer": "(a) [H(8) − H(2)] / (8 − 2) = (85 − 35) / 6 = 50/6 = 25/3 ≈ 8.333 degrees Celsius per hour.\n\n(b) Over [0, 2]: (35 − 20) / (2 − 0) = 15/2 = 7.5 °C per hour. Over [8, 12]: (100 − 85) / (12 − 8) = 15/4 = 3.75 °C per hour. The rod was heating faster on average over [0, 2], because 7.5 > 3.75.\n\n(c) The instantaneous rate of change at t = 5 is lim h→0 [H(5 + h) − H(5)] / h. The table gives H only at t = 2 and t = 8 near t = 5, so we cannot compute average rates over intervals that shrink to t = 5; the table can only approximate this limit, not give its exact value.\n\n(d) G(5) = 15(5) + 20 = 95. lim h→0 [G(5 + h) − G(5)] / h = lim h→0 [15(5 + h) + 20 − 95] / h = lim h→0 (75 + 15h + 20 − 95) / h = lim h→0 15h / h = 15. At t = 5 hours, the second rod's temperature is increasing at 15 degrees Celsius per hour.",
 "verification_python": "from fractions import Fraction as F\nimport sympy as sp\nH = {0: 20, 2: 35, 5: 60, 8: 85, 12: 100}\nr = lambda a, b: F(H[b] - H[a], b - a)\nassert r(2, 8) == F(25, 3) and abs(float(r(2, 8)) - 8.333) < 1e-3\nassert r(0, 2) == F(15, 2) and r(8, 12) == F(15, 4) and r(0, 2) > r(8, 12)\nh = sp.symbols('h')\nG = lambda t: 15*t + 20\nassert G(5) == 95\nassert sp.simplify(G(5 + h) - G(5)) == 15*h\nassert sp.limit((G(5 + h) - G(5)) / h, h, 0) == 15\nprint('ALL_CHECKS_PASSED')\n"
}
```

# Subject: AP Calculus AB (subject_key ap_calculus_ab)
Format: Short free-response in AP Calculus style: a function given algebraically, piecewise, or as a small table of values. Parts ask for limits, derivatives, values or justifications; justifications cite the relevant definition or theorem.
Parts: 3-4. Criteria (points) in total: 6-8.

Accepted item from this subject in this batch (style reference only):
```json
{
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
```

## Topics in this subject's Units 1, 2, 3 (stay inside the designated topic)
1.1 Introducing Calculus: Can Change Occur at an Instant? (Unit 1: Limits and Continuity)
1.10 Exploring Types of Discontinuities (Unit 1: Limits and Continuity)
1.11 Defining Continuity at a Point (Unit 1: Limits and Continuity)
1.12 Confirming Continuity over an Interval (Unit 1: Limits and Continuity)
1.13 Removing Discontinuities (Unit 1: Limits and Continuity)
1.14 Connecting Infinite Limits and Vertical Asymptotes (Unit 1: Limits and Continuity)
1.15 Connecting Limits at Infinity and Horizontal Asymptotes (Unit 1: Limits and Continuity)
1.16 Working with the Intermediate Value Theorem (Unit 1: Limits and Continuity)
1.2 Defining Limits and Using Limit Notation (Unit 1: Limits and Continuity)
1.3 Estimating Limit Values from Graphs (Unit 1: Limits and Continuity)
1.4 Estimating Limit Values from Tables (Unit 1: Limits and Continuity)
1.5 Determining Limits Using Algebraic Properties of Limits (Unit 1: Limits and Continuity)
1.6 Determining Limits Using Algebraic Manipulation (Unit 1: Limits and Continuity)
1.7 Selecting Procedures for Determining Limits (Unit 1: Limits and Continuity)
1.8 Determining Limits Using the Squeeze Theorem (Unit 1: Limits and Continuity)
1.9 Connecting Multiple Representations of Limits (Unit 1: Limits and Continuity)
2.1 Defining Average and Instantaneous Rates of Change at a Point (Unit 2: Differentiation: Definition and Fundamental Properties)
2.10 Derivatives of tan x, cot x, sec x, and csc x (Unit 2: Differentiation: Definition and Fundamental Properties)
2.2 Defining the Derivative of a Function and Using Derivative Notation (Unit 2: Differentiation: Definition and Fundamental Properties)
2.3 Estimating Derivatives of a Function at a Point (Unit 2: Differentiation: Definition and Fundamental Properties)
2.4 Connecting Differentiability and Continuity (Unit 2: Differentiation: Definition and Fundamental Properties)
2.5 Applying the Power Rule (Unit 2: Differentiation: Definition and Fundamental Properties)
2.6 Derivative Rules: Constant, Sum, Difference, and Constant Multiple (Unit 2: Differentiation: Definition and Fundamental Properties)
2.7 Derivatives of cos x, sin x, e^x, and ln x (Unit 2: Differentiation: Definition and Fundamental Properties)
2.8 The Product Rule (Unit 2: Differentiation: Definition and Fundamental Properties)
2.9 The Quotient Rule (Unit 2: Differentiation: Definition and Fundamental Properties)
3.1 The Chain Rule (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
3.2 Implicit Differentiation (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
3.3 Differentiating Inverse Functions (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
3.4 Differentiating Inverse Trigonometric Functions (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
3.5 Selecting Procedures for Calculating Derivatives (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
3.6 Calculating Higher-Order Derivatives (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)

## Targets: write exactly one FRQ for each of these 2 topics

### ap_calculus_ab 2.2 Defining the Derivative of a Function and Using Derivative Notation (Unit 2: Differentiation: Definition and Fundamental Properties)
Official CED text (governs):
```
TOPIC 2.2
Defining the Derivative
of a Function and Using
Derivative Notation
4.C
Use appropriate mathematical
symbols and notation.
Required Course Content
ENDURING UNDERSTANDING
CHA-2
Derivatives allow us to determine rates of change at an instant by applying limits to
knowledge about rates of change over intervals.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Represent the derivative of
a function as the limit of a
difference quotient.
The derivative of f is the function whose value
CHA-2.B
CHA-2.B.2
at x is lim f (x + h) - f ( x ) , provided this limit
exists.
h →0
h
CHA-2.B.3
For y = f ( x ), notations for the derivative
include
dy
, f ′( x ), and y′.
dx
CHA-2.B.4
The derivative can be represented graphically,
numerically, analytically, and verbally.
CHA-2.C
Determine the equation of a
line tangent to a curve at a
given point.
CHA-2.C.1
The derivative of a function at a point is the
slope of the line tangent to a graph of the
function at that point.
UNIT
Differentiation: Definition and Fundamental Properties
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Criterion c2 combines two separately observable elements—algebraically removing the indeterminate form and evaluating the limit—into one all-or-nothing point. Separate the algebra and final-value criteria. Also, a3 and c2 list rounded decimals a
- gpt-6.1-sol: accurate: The equivalent-form lists in a3 and c2 incorrectly treat −0.333 as equal to −1/3 and 0.1667 as equal to 1/6. These are approximations, not exact equivalents; remove them or explicitly identify an allowed approximation tolerance.
- gpt-6.1-sol: rubric_points: Criterion a2 requires a particular expanded intermediate expression and factoring step, although correct algebra can directly produce (4xh + 2h² − 5h)/h = 4x + 2h − 5. Criterion c2 mandates rationalizing the numerator, rejecting valid algebraic 
- gpt-6.1-sol: accurate: Criterion c2 lists 0.1667 as an equivalent form of 1/6. It is only an approximation, not an equivalent value; write 0.1666… or explicitly identify an acceptable approximation.
- deepseek-v4-pro: rubric_points: Part (c), criterion c2: accepted variant 0.1667 is a rounded decimal approximation of 1/6, not an exact equivalent; in a no-calculator section only exact values or algebraically equivalent forms should be accepted.
- deepseek-v4-pro: accurate: Part (c), criterion c2 lists 0.1667 as an equivalent form of 1/6, but 0.1667 is not exactly equal to 1/6.

### ap_calculus_ab 2.5 Applying the Power Rule (Unit 2: Differentiation: Definition and Fundamental Properties)
Official CED text (governs):
```
TOPIC 2.5
SUGGESTED SKILLS
Applying the
Power Rule
Implementing
Mathematical Processes
1.E
Apply appropriate
mathematical rules or
procedures, with and without
technology.
Required Course Content
ENDURING UNDERSTANDING
FUN-3
Recognizing opportunities to apply derivative rules can simplify differentiation.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Calculate derivatives of
familiar functions.
Direct application of the definition of the
derivative and specific rules can be used to
calculate the derivative for functions of the form
f (x ) = x r.
FUN-3.A
FUN-3.A.1
UNIT
SUGGESTED SKILLS
Implementing
Mathematical Processes
1.E
Apply appropriate
mathematical rules or
procedures, with and without
technology.
Differentiation: Definition and Fundamental Properties
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Criterion a1 combines two separately requested elements: rewriting g and finding its derivative. Criteria b1 and d1 bundle derivative setup and numerical execution into all-or-nothing points, contrary to the supplied scoring conventions. Criteri
- gpt-6.1-sol: accurate: Criterion b1 lists 0.333 as an equivalent form of 1/3. It is only an approximation, not an equivalent value; the question provides no rounding instruction or tolerance.
- gpt-6.1-sol: rubric_points: Criteria a2, b1, and c1 require specific power-rule work although the parts only ask students to find derivatives; valid derivative-definition solutions must also receive credit. Criteria b1 and c1 additionally require explicit power rewrites th
- gpt-6.1-sol: accurate: Criterion c2 incorrectly identifies 0.333 as equivalent to 1/3. Write 1/3 exactly, or explicitly identify 0.333 as an accepted rounded approximation rather than an equivalent value.
- gpt-6.1-sol: rubric_points: Criterion c1 requires rewriting h as x^(5/2), although part (c) does not prescribe this method; correct differentiation by the product rule should also earn credit. Criterion d2 requires division by x^(3/2), excluding other valid algebraic solut
- gpt-6.1-sol: accurate: Criterion d2 incorrectly lists 0.694 as an equivalent form of 25/36. The exact value is 0.694444…, so 0.694 is a rounded approximation.


## AP Calculus AB CED fact pack (course-wide sections and units up to 3)
# AP Calculus AB and BC - CED Fact Pack

Status: Primary-source verified. Use this version for 2026-27 authoring and review.

## Source control

Source document: College Board, AP Calculus AB and BC Course and Exam Description.

Edition shown on cover: Effective Fall 2020. The local College Board release carries 2026 copyright and 07/2026 metadata.

Local source: `docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf`

Source SHA-256: `fd571cdc252c24d33a75ed556ee20d9261ef1ad3dbb718d0caf78acecc8253ca`

Verification: PDF metadata, cover, course framework, unit weighting table, exam overview, topic maps, and AB/BC scope markers were checked directly. This pack supersedes the earlier digest whose unit-weight ranges were stale.

**2026-08-08 deep-tier update, extended to Units 9-10 (BC's remaining scope) same day — BC's full CED scope (Units 1-10) is now entirely deep tier.** Units 9-10 (Parametric, Polar, and Vector-Valued Functions; Infinite Sequences and Series) were brought to deep tier using the CED PDF (pages 163-195, `Subject Packs/Calculus BC/ap-calculus-ab-and-bc-course-and-exam-description copy.pdf`, same underlying document as the AB copy used earlier, verified identical content for this page range) plus BC-specific primary sources not used in the Units 1-8 passes: the 2025 **BC** Scoring Guidelines (`ap25-sg-calculus-bc.pdf` — distinct from the AB Scoring Guidelines used for Units 1-3, since Units 9-10 don't exist on the AB exam at all), the 2025 Chief Reader Report filtered for its BC-specific question data (`ap25-cr-report-calculus-ab-bc.pdf`, Questions BC2 and BC6), the 2025 BC **Question 2** Sample Student Responses and Scoring Commentary booklet (`ap25-apc-calculus-bc-q2.pdf` — Question 2 is the BC-only polar-curve FRQ; the Question 1 booklet covers a shared AB/BC average-value item already grounded in the Units 1-8 pass and was not re-mined here), and the 2025/2026 released BC FRQ booklets (`ap25-frq-calculus-bc.pdf`, `ap26-frq-calculus-bc.pdf`). Unlike the Units 4-8 pass, which leaned on AB-domain sources, this pass is the first genuinely BC-specific-source deep-tier pass, since Units 9-10 have no AB counterpart. One previously uncaptured, boxed, verbatim CED exclusion was found and added: Topic 10.8's exclusion statement restricts BC's entire in-scope convergence-test toolkit to exactly six named tests (nth term test, integral test, comparison test, limit comparison test, alternating series test, ratio test) and explicitly states other methods (e.g., the root test) "are not assessed on the exam." No topic-map naming errors were found in the existing Unit 9/10 topic-map entries — all topic titles verified correct against the CED. See "Units 9-10 deep-tier detail" below.

**2026-08-08 deep-tier update, extended to Units 4-8 (AB's full scope) same day.** Units 4-8 were brought to deep tier using the same CED PDF pages (77-160) plus additional David-supplied primary sources not used in the Units 1-3 pass: the 2025 AB **Sample Student Responses and Scoring Commentary** booklets for Q1 and Q2 (`ap25-apc-calculus-ab-q1.pdf`, `ap25-apc-calculus-ab-q2.pdf` — these contain 3 real graded student responses per question with reader commentary explaining exactly why each point was or wasn't earned, a materially different and more concrete source than the scoring guideline alone). One correction found and applied: the prior version of this pack stated arc length (Unit 8, topic 8.13) was shared AB/BC — verified false against the CED (explicitly BC-only in three places); checked the live Production corpus for any `apcalcab-*` item authored on arc length before fixing the claim — none found, no live defect from this specific error. **CORRECTION, 2026-09-29: that corpus check was wrong.** `apcalcab-mcq-050` ("What is the length of y=x² from x=0 to x=1.4") was a published AB arc-length item, found by the TASK-0050 topic pass when no AB topic would fit it. It has been moved to AP Calculus BC as `apcalcbc-mcq-mv050` with topic 8.13. Either the original check missed it or the item was authored afterwards.

**2026-08-08 deep-tier update, Units 1-3.** Per `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §1.6, this pack was previously "partial tier" (topic map + course-level removals, no per-topic inline exclusions or equation blocks) — thinner than the Biology/Chemistry deep tier. Units 1-3 were brought to deep tier using, in addition to the CED PDF above: the 2025 AP Calculus AB/BC Chief Reader Report (`ap25-cr-report-calculus-ab-bc.pdf`, 39pp, common-error data by FRQ point), the 2025 AB and BC Scoring Guidelines (`ap25-sg-calculus-ab.pdf`, `ap25-sg-calculus-bc.pdf`, 27pp each, point-earning criteria and general scoring notes), and the 2025/2026 released FRQ booklets (`ap25-frq-calculus-ab.pdf`, `ap25-frq-calculus-bc.pdf`, `ap26-frq-calculus-ab.pdf`, `ap26-frq-calculus-bc.pdf`) — all David-supplied primary-source PDFs, read directly page-by-page, not summarized from web search. **Units 4-10 remain at partial tier** — this was a scoped update to ground one authoring batch (Units 1-3 FRQ/MCQ), not a full ten-unit rebuild; see §7.3 of the protocol doc for why a scoped-per-need approach was chosen over a blanket rebuild.

## Course relationship and scope

AP Calculus AB is equivalent to a first-semester college calculus course. AP Calculus BC is equivalent to first- and second-semester college calculus. BC contains all AB content plus additional integration content, parametric/polar/vector-valued functions, and sequences and series.

AB contains Units 1-8. BC contains Units 1-10. Units 9 and 10 are BC-only. Within Unit 6, Topics 6.12 and 6.13 are also BC-only.

Do not infer AB eligibility from a shared unit number alone. Every AB item must be checked at topic level.

## Exam structure

Both exams are 3 hours 10 minutes, with 42 multiple-choice questions and 6 free-response questions.

Section I, Part A: 29 MCQs, no graphing calculator, 62 minutes, 35% of score.

Section I, Part B: 13 MCQs, graphing calculator required, 38 minutes, 15% of score.

Section II, Part A: 2 FRQs, graphing calculator required, 30 minutes, approximately 16.7% of score.

Section II, Part B: 4 FRQs, no graphing calculator, 60 minutes, approximately 33.3% of score.

The AB and BC exams share three FRQs drawn from the AB domain. Each exam includes multiple function types and analytical, graphical, numerical/tabular, and verbal representations. Each includes at least two real-world contexts.

Calculator-enabled work may require graphing, numerical zero solving, numerical differentiation, and numerical definite integration. On an FRQ, students must show the mathematical setup that produced a calculator result.

## Multiple-choice unit weighting

Unit 1 - Limits and Continuity: AB 10-15%; BC 5-10%.

Unit 2 - Differentiation: Definition and Basic Derivative Rules: AB 10-15%; BC 5-10%.

Unit 3 - Differentiation: Composite, Implicit, and Inverse Functions: AB 5-10%; BC 5-10%.

Unit 4 - Contextual Applications of Differentiation: AB 10-15%; BC 5-10%.

Unit 5 - Applying Derivatives to Analyze Functions: AB 15-20%; BC 10-15%.

Unit 6 - Integration and Accumulation of Change: AB 15-20%; BC 15-20%.

Unit 7 - Differential Equations: AB 5-10%; BC 5-10%.

Unit 8 - Applications of Integration: AB 10-15%; BC 5-10%.

Unit 9 - Parametric Equations, Polar Coordinates, and Vector-Valued Functions: BC only, 10-15%.

Unit 10 - Infinite Sequences and Series: BC only, 15-20%.

Naming note: the course-framework unit titles use “Fundamental Properties” for Unit 2 and “Analytical Applications of Differentiation” for Unit 5, while the exam-information weighting table uses “Basic Derivative Rules” and “Applying Derivatives to Analyze Functions.” Treat these as aliases for the same numbered units.

## Mathematical practices

Practice 1 - Implementing Mathematical Processes: determine expressions and values using mathematical procedures and rules.

Practice 2 - Connecting Representations: translate mathematical information within and across graphical, numerical, analytical, and verbal representations.

Practice 3 - Justification: select and apply definitions, theorems, and tests; support conclusions; confirm conditions and accuracy.

Practice 4 - Communication and Notation: use precise language, units, symbols, graphing conventions, and rounding.

MCQ practice weighting: Practice 1, 50-70%; Practice 2, 15-30%; Practice 3, 10-20%. Practice 4 is not assessed in the MCQ section.

FRQ practice weighting: Practice 1, 35-60%; Practice 2, 10-20%; Practice 3, 35-60%; Practice 4, 10-25%.

## Practice skills (sub-skills) — TASK-0050 Phase 0, added 2026-09-29

Source: CED "Mathematical Practices" page (Course Framework p. 12), supplied by David 2026-09-29 as
a direct capture of the College Board PDF. Transcribed verbatim, including the three sub-skills the
CED itself marks **not assessed**. These are the skill codes the skill dimension uses
(`app.taxonomy_skills`); **23 total, 20 assessed.**

### Practice 1 — Implementing Mathematical Processes
*Determine expressions and values using mathematical procedures and rules.*

- **1.A** Identify the question to be answered or problem to be solved. *(not assessed)*
- **1.B** Identify key and relevant information to answer a question or solve a problem. *(not assessed)*
- **1.C** Identify an appropriate mathematical rule or procedure based on the classification of a given expression (e.g., use the chain rule to find the derivative of a composite function).
- **1.D** Identify an appropriate mathematical rule or procedure based on the relationship between concepts (e.g., rate of change and accumulation) or processes (e.g., differentiation and its inverse process, anti-differentiation) to solve problems.
- **1.E** Apply appropriate mathematical rules or procedures, with and without technology.
- **1.F** Explain how an approximated value relates to the actual value.

### Practice 2 — Connecting Representations
*Translate mathematical information from a single representation or across multiple representations.*

- **2.A** Identify common underlying structures in problems involving different contextual situations.
- **2.B** Identify mathematical information from graphical, numerical, analytical, and/or verbal representations.
- **2.C** Identify a re-expression of mathematical information presented in a given representation.
- **2.D** Identify how mathematical characteristics or properties of functions are related in different representations.
- **2.E** Describe the relationships among different representations of functions and their derivatives.

### Practice 3 — Justification
*Justify reasoning and solutions.*

- **3.A** Apply technology to develop claims and conjectures. *(not assessed)*
- **3.B** Identify an appropriate mathematical definition, theorem, or test to apply.
- **3.C** Confirm whether hypotheses or conditions of a selected definition, theorem, or test have been satisfied.
- **3.D** Apply an appropriate mathematical definition, theorem, or test.
- **3.E** Provide reasons or rationales for solutions and conclusions.
- **3.F** Explain the meaning of mathematical solutions in context.
- **3.G** Confirm that solutions are accurate and appropriate.

### Practice 4 — Communication and Notation
*Use correct notation, language, and mathematical conventions to communicate results or solutions.*

- **4.A** Use precise mathematical language.
- **4.B** Use appropriate units of measure.
- **4.C** Use appropriate mathematical symbols and notation (e.g., represent a derivative using f'(x), y', and dy/dx).
- **4.D** Use appropriate graphing techniques.
- **4.E** Apply appropriate rounding procedures.

## Topic-to-practice alignment — TASK-0050 Phase 0, added 2026-09-29

Source: CED "Course at a Glance" (Course Framework pp. 9-10), supplied by David 2026-09-29. Each
topic carries the practice the CED aligns to it. This is the CED's **own** alignment, so the
topic × skill grid is transcribed rather than curated — the case `TASK-0050` §6.2 says to prefer.

**Independent verification of this transcription.** Counting topics here gives 87 across Units 1-8,
of which six are BC-only (6.11, 6.12, 6.13, 7.5, 7.9, 8.13). That predicts AB = 81 and
BC = 87 + 9 + 15 = 111. Production holds exactly **81** and **111**. The topic sets match the CED
exactly, which corroborates both the transcription and the existing topic map.

| Unit | Topic → Practice |
| --- | --- |
| 1 | 1.1→2, 1.2→2, 1.3→2, 1.4→2, 1.5→1, 1.6→1, 1.7→1, 1.8→3, 1.9→2, 1.10→3, 1.11→3, 1.12→1, 1.13→1, 1.14→3, 1.15→2, 1.16→3 |
| 2 | 2.1→2, **2.2→1 and 4**, 2.3→1, 2.4→3, 2.5→1, 2.6→1, 2.7→1, 2.8→1, 2.9→1, 2.10→1 |
| 3 | 3.1→1, 3.2→1, 3.3→3, 3.4→1, 3.5→1, 3.6→1 |
| 4 | 4.1→1, 4.2→1, 4.3→2, 4.4→1, 4.5→3, 4.6→1, 4.7→3 |
| 5 | 5.1→3, 5.2→3, 5.3→2, 5.4→3, 5.5→1, 5.6→2, 5.7→3, 5.8→2, 5.9→2, 5.10→2, 5.11→3, **5.12→1 and 3** |
| 6 | 6.1→4, 6.2→1, 6.3→2, 6.4→1, 6.5→2, 6.6→3, 6.7→3, 6.8→4, 6.9→1, 6.10→1, 6.11→1 *(BC)*, 6.12→1 *(BC)*, 6.13→1 *(BC)*, 6.14→1 |
| 7 | 7.1→2, 7.2→3, 7.3→2, 7.4→4, 7.5→1 *(BC)*, 7.6→1, 7.7→1, 7.8→3, 7.9→3 *(BC)* |
| 8 | 8.1→1, 8.2→1, 8.3→3, 8.4→4, 8.5→1, 8.6→2, 8.7→3, 8.8→3, 8.9→3, 8.10→2, 8.11→4, 8.12→2, 8.13→3 *(BC)* |
| 9 *(BC only)* | 9.1→2, 9.2→1, 9.3→1, 9.4→1, 9.5→1, 9.6→1, 9.7→2, 9.8→3, 9.9→3 |
| 10 *(BC only)* | 10.1→3, 10.2→3, 10.3→3, 10.4→3, 10.5→3, 10.6→3, 10.7→3, 10.8→3, 10.9→3, 10.10→1, **10.11→3 and 2**, 10.12→1, 10.13→2, 10.14→2, 10.15→3 |

**Three topics carry two practices** — 2.2 (1 and 4, confirmed by the page's own footnote), 5.12
(1 and 3), and 10.11 (3 and 2). Every other topic carries exactly one.

**Not a two-practice case:** topic 2.7 displays two *big-idea* badges (FUN and LIM) both tagged
practice 1. Big ideas (CHA Change, LIM Limits, FUN Analysis of Functions) are a separate axis from
practices and are not skill codes.

**How the grid derives from this.** A topic's candidate skills are the **assessed** sub-skills of its
aligned practice — so a Practice 3 topic offers 3.B–3.G (six candidates, 3.A excluded as not
assessed), a Practice 1 topic offers 1.C–1.F (four, 1.A/1.B excluded), Practice 2 offers 2.A–2.E
(five), Practice 4 offers 4.A–4.E (five). Item-level labelling then chooses one sub-skill from that
set, exactly as AP Statistics' Phase B did.

## Topic map

### Unit 1 - Limits and Continuity

1.1 Introducing Calculus: Can Change Occur at an Instant?; 1.2 Defining Limits and Using Limit Notation; 1.3 Estimating Limit Values from Graphs; 1.4 Estimating Limit Values from Tables; 1.5 Determining Limits Using Algebraic Properties of Limits; 1.6 Determining Limits Using Algebraic Manipulation; 1.7 Selecting Procedures for Determining Limits; 1.8 Determining Limits Using the Squeeze Theorem; 1.9 Connecting Multiple Representations of Limits; 1.10 Exploring Types of Discontinuities; 1.11 Defining Continuity at a Point; 1.12 Confirming Continuity over an Interval; 1.13 Removing Discontinuities; 1.14 Connecting Infinite Limits and Vertical Asymptotes; 1.15 Connecting Limits at Infinity and Horizontal Asymptotes; 1.16 Working with the Intermediate Value Theorem.

### Unit 2 - Differentiation: Definition and Fundamental Properties

2.1 Defining Average and Instantaneous Rates of Change at a Point; 2.2 Defining the Derivative of a Function and Using Derivative Notation; 2.3 Estimating Derivatives of a Function at a Point; 2.4 Connecting Differentiability and Continuity; 2.5 Applying the Power Rule; 2.6 Derivative Rules: Constant, Sum, Difference, and Constant Multiple; 2.7 Derivatives of cos x, sin x, e^x, and ln x; 2.8 The Product Rule; 2.9 The Quotient Rule; 2.10 Derivatives of tan x, cot x, sec x, and csc x.

### Unit 3 - Differentiation: Composite, Implicit, and Inverse Functions

3.1 The Chain Rule; 3.2 Implicit Differentiation; 3.3 Differentiating Inverse Functions; 3.4 Differentiating Inverse Trigonometric Functions; 3.5 Selecting Procedures for Calculating Derivatives; 3.6 Calculating Higher-Order Derivatives.

## High-risk authoring and review boundaries

AB scope excludes all of Units 9 and 10, linear partial fractions, and improper integrals.

BC items may assess any AB topic, so BC-only tagging is needed only when an item requires content unavailable in AB. Do not label a routine AB-domain item “BC-only” merely because it can appear on the BC exam.

**Correction, 2026-08-08: arc length (Unit 8, topic 8.13) is BC-only, not shared AB/BC** — the prior version of this line was wrong. Verified directly against the CED: topic 8.13's title, its Learning Objective (CHA-6.A), and its EK (CHA-6.A.1) all carry an explicit "BC ONLY" tag, and it uses its own dedicated Enduring Understanding (CHA-6) separate from the area/volume group (CHA-5). Do not author or approve an `apcalcab-*` item on arc length. Parametric arc length in Unit 9 is also BC-only (Unit 9 is BC-only in its entirety).

**Addition, 2026-08-08: BC's series-convergence-test toolkit is boxed and closed.** Topic 10.8 carries a verbatim CED exclusion statement restricting the entire in-scope convergence-test list to exactly six named tests (nth term test, integral test, comparison test, limit comparison test, alternating series test, ratio test) — "Other methods are not assessed on the exam." Do not author an item requiring the root test, condensation test, Raabe's test, Dirichlet's test, or any other convergence test outside this list, even though the CED notes teachers may cover additional methods in class. See "Units 9-10 deep-tier detail" below for the exact quote.

> **CORRECTION, 2026-09-29.** The line below was **wrong** and is struck through. Euler's method
> (7.5) and logistic models (7.9) are **BC-ONLY**, not shared AB/BC. This contradicted the same
> pack's own Unit 7 exclusion note, which correctly states "Two topics are BC-only, each tagged in
> three places: **7.5 Euler's Method** and **7.9 Logistic Models**." The taxonomy agrees with the
> exclusion note: `ap_calculus_ab` registers 7.1, 7.2, 7.3, 7.4, 7.6, 7.7, 7.8 and **no 7.5 or 7.9**.
>
> This error had a live consequence. Two published `apcalcab-*` items were authored on exactly these
> BC-only topics — `apcalcab-mcq-045` (Euler's method) and `apcalcab-mcq-046` (logistic model) — and
> were found by the TASK-0050 topic pass, which could not fit either to any AB topic. Both have been
> moved to AP Calculus BC (`apcalcbc-mcq-mv045`, `apcalcbc-mcq-mv046`). A line like this one is
> precisely what licenses authoring such an item, which is why it is corrected here rather than
> quietly deleted.

~~Euler's method and logistic differential equations are shared AB/BC content.~~ **Euler's method
(7.5) and logistic models (7.9) are BC-only. Do not author or approve an `apcalcab-*` item on
either.**

L'Hospital's Rule is shared AB/BC content.

Calculator-required questions must require or naturally support an approved calculator capability; do not add a calculator label to an item whose intended solution is purely symbolic.

FRQ scoring must reward setup, reasoning, context, units, and notation where the task demands them. A correct unsupported number is not automatically a complete response.

## Units 1-3 deep-tier detail (2026-08-08 addition)

Verified directly against the CED PDF (pages 27-76) plus the scoring/reader-report sources listed in Source control above. Exclusion density here is genuinely sparser than Biology/Chemistry — Calc AB/BC's scope-limiting signal comes mostly from illustrative examples and scoring-guideline precision rules, not boxed "do not assess" statements, except where noted. Do not infer a missing exclusion tag means "anything goes" — check the illustrative examples and common-error notes below, which function as the real boundary.

### Unit 1 — Limits and Continuity (AB 10-15%, BC 5-10%)

*Exclusion:* The epsilon-delta definition of a limit is **not assessed** on the AP Calculus AB or BC Exam (attached to EK LIM-1.A.1, topic 1.2). Teachers may cover it in class, but do not author an item requiring a student to produce or reason from an epsilon-delta proof.

*Scope boundary via illustrative examples:* "Limit does not exist" cases (topic 1.3, EK LIM-1.C.4) are scoped to three canonical patterns — unbounded behavior (`lim(x→0) 1/x² = ∞`), oscillation (`lim(x→0) sin(1/x)` DNE), and mismatched one-sided limits (`lim(x→0) |x|/x` DNE). Stay within these patterns; do not invent exotic DNE cases the CED doesn't illustrate.

*High-yield content requirement (topic 1.16, IVT):* An item is not "IVT-complete" unless the response explicitly (a) states the function is continuous — and *why* (e.g., "differentiable, therefore continuous," not just asserted), (b) states the target value is strictly between the two endpoint values with the actual numbers, and (c) concludes existence. Per the 2025 Chief Reader Report, this was the single lowest-scoring point pattern in the entire AB/BC exam (mean ≈0.27-0.28/1 on the continuity-justification point; ≈0.28-0.43 on the conclusion point) — the failure mode is *not* mathematical, it's stating the conclusion without the two hypothesis-checks. A rubric that awards credit for "the right final answer" without requiring both checks does not match real AP grading and will silently pass a response real graders would dock.

*Documented misconception, direct from the Chief Reader Report:* "A few responses incorrectly attempted to apply the Mean Value Theorem" where IVT was required. MVT-vs-IVT confusion is real, reader-documented, and appropriate as an MCQ distractor.

*Documented misconception (end behavior / limits at infinity, topic 1.15):* Students confuse "end behavior" (limit as the variable approaches infinity) with evaluating near zero — the Chief Reader Report's most common error on the relevant 2025 FRQ part was writing `lim(t→0)` instead of `lim(t→∞)`. Also appropriate as an MCQ distractor.

### Unit 2 — Differentiation: Definition and Fundamental Properties (AB 10-15%, BC 5-10%)

No boxed exclusion statement for this unit's topics. The real boundary is notational/structural, and it is scored, not stylistic:

*Structural requirement (product/quotient rule, topics 2.8-2.9):* the CED's own "Preparing for the AP Exam" note states plainly: "Failure to present this structure will cost students the point they might have earned, even with a correct numerical answer." For `f(x) = u(x)·v(x)`, a response must show `f′(3) = u(3)v′(3) + v(3)u′(3)` as an explicit structural step, separate from the final numeric value — these are scored as two separate point-earning line items in real AP scoring guidelines (setup point, value point), not one all-or-nothing check.

*Documented misconception (chain rule on exponentials, boundary with Unit 3 but rooted in Unit 2 derivative rules):* per the Chief Reader Report, students frequently differentiate `e^u` as `u·e^u` instead of `e^u·u′` — i.e. they apply a garbled product-rule-shaped pattern to what should be a direct chain-rule application of a known derivative rule. Confirmed, quotable, appropriate as an MCQ distractor for any `d/dx[e^(g(x))]` item.

*Documented misconception (notation, topic 2.2/2.8):* renaming a derivative expression to new notation without defining it (e.g. silently calling `x_H′(t)` as `H′(t)`), and omitting parentheses around a binomial factor before a trig/exponential term (`2t − 4·e^(...)` instead of `(2t−4)·e^(...)`) — both documented as causing real point loss even when the underlying calculus was otherwise correct.

*Calculator-answer convention:* when a calculator-permitted item requires a numeric derivative value, the CED's own guidance requires "presenting mathematical expressions evaluated on the calculator" with results "rounded or truncated to three places after the decimal point" — and per the 2025/2026 Scoring Guidelines' universal front-matter note, **at most one point per entire FRQ (all parts combined) may be lost to inappropriate rounding** — never more, regardless of how many sub-answers are mis-rounded. Rubrics for calculator-permitted items should reflect this cap, not deduct per-instance.

### Unit 3 — Differentiation: Composite, Implicit, and Inverse Functions (AB 5-10%, BC 5-10%)

No boxed exclusion statement for this unit's topics either. This is the highest-error-density unit in the whole Units-1-3 range per the Chief Reader Report (AB6, the flagship implicit-differentiation FRQ, had a mean score of 4.12/9) — the boundary here is almost entirely about which near-miss responses do *not* earn credit despite reaching a materially correct answer:

*Documented misconception (chain rule mechanics, topic 3.1):* "Misapplying the chain rule by forgetting to also differentiate the inner function, or misidentifying the inner function" (CED's own Building Math Practices note) — e.g. failing to recognize the chain rule applies to `sin²x`, `tan(2x−1)`, or `e^(x²)`, or (in an implicit-differentiation context) not recognizing that `y` itself requires the chain rule because it depends on `x`.

*Documented misconception (implicit differentiation, topic 3.2) — five specific, reader-quoted errors, all appropriate as FRQ near-miss rubric language or MCQ distractors:*
1. Using `dy` where `dy/dx` is meant, or `dy/dx` where the operator `d/dx` is meant (conflating the differential with the derivative).
2. Dropping the "= 0" on the right-hand side after implicitly differentiating a constant (silently losing a term).
3. Omitting parentheses around the coefficient of `dy/dx` after collecting terms — e.g. writing `3y² − 2y − 1 · dy/dx = −½x` instead of `(3y² − 2y − 1)·dy/dx = −½x`, which changes the meaning.
4. Using separation of variables instead of implicit differentiation — a wrong-technique-choice error, not an arithmetic slip.
5. **Vertical-vs-horizontal tangent inversion**: setting the *numerator* of `dy/dx` to zero (the horizontal-tangent condition) when the problem requires the *denominator* to be zero (the vertical-tangent condition). Chief Reader Report calls this out explicitly and it is a strong, real, quotable MCQ distractor.

*Documented misconception (related rates via implicit differentiation w.r.t. t, still topic 3.2):* differentiating with respect to `x` and never reconnecting the result to `t` (forgetting the problem requires `d/dt`, introducing `dx/dt`/`dy/dt` terms); writing the derivative of `2xy` as `2(dx/dt)(dy/dt)` instead of correctly applying the product rule (`2(x·dy/dt + y·dx/dt)`); writing `d/dt(ln y)` as `1/y` instead of `(1/y)(dy/dt)` (dropping the required chain-rule factor). The Scoring Guidelines explicitly reject the shortcut "stating `dy/dt = dy/dx · dx/dt` alone, with no completed numeric computation" as earning zero points — citing the identity is not sufficient, it must be carried through.

*Selection-of-root requirement (topic 3.2, vertical tangent):* per the Scoring Guidelines' own scoring notes, finding both roots of a resulting quadratic is not sufficient for credit — the response must explicitly state which root satisfies the problem's domain restriction (e.g. "the curve requires y > 0, so y = 1" — merely listing "y = −1/3 and y = 1" without that selection step does not earn the point).

### Cross-unit scoring conventions confirmed from the 2025/2026 Scoring Guidelines (apply when authoring FRQ rubrics for any Units 1-3 item)

- AP Calc FRQ scoring decomposes into three separable point types wherever a multi-step calculation is involved: (1) a *setup/method-identification* point (e.g. "states Product Rule," "sets up the ratio," "writes the implicit-differentiation equation"), (2) an *execution* point (correct value from correctly executing the method), and (3) sometimes a separate *supported-conclusion* point. A response can earn the setup point with an arithmetic slip in execution, and vice versa — do not write single all-or-nothing criteria for what real AP scoring treats as 2-3 independent points, except where the guidelines are explicit that a step is all-or-nothing (implicit differentiation of the *whole* equation, topic 3.2, is scored as all-or-nothing for that one point — no partial credit for a partially correct differentiation).
- "Answers need not be simplified" — unsimplified but correct expressions earn full credit; do not write a criterion requiring a specific simplified form unless the prompt explicitly asks the student to simplify.
- Consistent/follow-through credit is real: if an earlier part's numeric answer is wrong, a later part that correctly *applies* that wrong number can still earn its own points (except for points explicitly gated on the correct earlier value).
- "Incorrect or unclear communication accompanying an otherwise correct step is treated as scratch work and is not scored" — a sign error in a linking sentence around an otherwise-correct computation does not cost the computation's point.

## Units 4-8 deep-tier detail (2026-08-08 addition)

Verified directly against the CED PDF (pages 77-160) plus the 2025 AB Scoring Guidelines, 2025/2026 released FRQs, and the Q1/Q2 sample-response-with-commentary booklets. As with Units 1-3, exclusion density is sparse compared to Biology/Chemistry — most of the real scope discipline here lives in scoring architecture (what specific reasoning structure earns a point) rather than boxed "do not assess" statements. Two genuine boxed exclusions do exist in this range (Unit 4's other-indeterminate-forms exclusion, Unit 8's arc-length BC-only flag) and are called out below.

### Cross-unit scoring conventions confirmed from the 2025 AB Scoring Guidelines (apply across Units 4-8, extending the Units 1-3 list above)

- The **local-vs-global justification split from Unit 5** (a correct-but-local argument earns the answer point but not the justification point) recurs by the same logic anywhere an FRQ asks "justify that this is a maximum/minimum" — including accumulation-function extrema (Unit 6/8 crossover, e.g. 2025 Q4 Part D).
- **Cross-part consistency/follow-through credit is explicit and named in the guidelines**, not just a general convention: values "imported from part C" or "restated from part B" are explicitly permitted to satisfy a later part's evaluation requirement, including when the imported value is itself wrong — confirmed across three separate 2025 items (Q1D, Q4D, Q5C). When authoring multi-part FRQs, a later part's criterion should allow a numerically-consistent-with-an-earlier-wrong-value answer to still earn credit, matching real AP practice.
- **"Incorrect or unclear communication between a correct setup and a correct final answer is treated as scratch work and is not scored"** — confirmed verbatim across multiple 2025 questions' scoring notes. A sign error or transcription slip strictly *between* an already-credited setup step and an already-credited answer does not cost either point.
- **The differential (`dx`, `dt`) is sometimes fully optional and sometimes load-bearing — it depends on the specific point being scored, not a blanket rule.** Confirmed both ways in real 2025 scoring: Unit 8's cross-section volume setup explicitly does not require the differential for its structural-form point ("the presence or absence of dx will not be considered"), while Unit 4/8's related-rates and reversed-difference-of-squares cases specifically require the differential present to resolve an otherwise-ambiguous expression into full credit. Do not write a universal "always require dx" or "never require dx" rule into a rubric — check the specific point being scored.

## Units 9-10 deep-tier detail (2026-08-08 addition)

Verified directly against the CED PDF (pages 163-195) plus the 2025 BC Scoring Guidelines, the BC-specific data in the 2025 Chief Reader Report (Questions BC2 and BC6), the 2025 BC Question 2 Sample Student Responses and Scoring Commentary booklet, and the 2025/2026 released BC FRQ booklets. Unlike the Units 4-8 pass — which used AB-domain FRQs, AB Scoring Guidelines, and AB sample-response booklets, since that content exists on both exams — this is the first genuinely **BC-specific-source** deep-tier pass in this fact pack: Units 9-10 have no AB counterpart, so every scoring-architecture claim below comes from a BC-only question. A striking pattern specific to these two units, confirmed by reading every topic's Essential Knowledge text directly: roughly half of Units 9-10's topics state only that a rectangular-coordinate method or concept "can be extended to" the parametric/polar/vector/series setting, without ever writing out the resulting formula in the CED's required-content text. This mirrors the Unit 7 Euler's-method gap already flagged in the Units 4-8 pass, but it recurs far more often here — flagged topic-by-topic below so authoring doesn't mistake "commonly taught" for "CED-mandated." One genuine boxed exclusion exists in this range (Topic 10.8's closed list of assessed convergence tests) and is quoted verbatim below.

### Cross-unit scoring conventions confirmed from the 2025 BC Scoring Guidelines and Chief Reader Report (Units 9-10, extending the Units 1-3/4-8 lists above)

- **The granular three-way integral-setup split documented for Unit 8's washer method (structural-form point, full-correct-integrand point, constant/limits/final-answer point) recurs identically for Unit 9's polar area** (2025 BC2 Part B) — this is a general AP Calc BC integral-setup scoring pattern, not specific to volume problems.
- **The Unit 5 local-vs-global justification split recurs identically in Unit 9's polar optimization** (2025 BC2 Part C): a response using only a local sign-change argument does not earn the justification point but remains eligible for the separate final-answer point.
- **Naming an appropriate convergence test is explicitly sufficient for full credit at interval-of-convergence endpoints** — the 2025 BC Scoring Guidelines state this directly for Question 6 Part A: "Naming of an appropriate test is sufficient for the analysis at each endpoint." A full symbolic execution of the named test is not required if the correct test name and the correct conclusion are both present.
- **Absolute value bars are optional in ratio-test setup notation**, confirmed as a real, documented scoring tolerance (BC6 CR report notes) as long as the response resolves to a symmetric interval — do not require absolute-value notation as a rubric criterion on its own.

## Authoring distribution guidance

Use the weighting ranges when assembling representative practice exams and prioritizing review. Do not use weighting to omit low-weight units from the content bank.

For AB, Units 5 and 6 are the largest targets. For BC, Units 6 and 10 are the largest targets, followed by Units 5 and 9.

Across a representative set, mix procedures with interpretation, representation changes, justification, and contextual reasoning. Preserve the official calculator split and include both contextual and noncontextual work.

All questions and scoring criteria must be independently authored from this scope brief. Do not expose official sample questions, released question wording, scoring text, or recognizable item structures to the authoring model.

## Change record from superseded fact pack

Corrected all AB/BC unit-weight ranges to the current PDF tables.

Completed Unit 10 through Topics 10.13-10.15 rather than relying on an extraction caveat.

Added mathematical-practice weightings, the exact calculator/time split, current unit-title aliases, and topic-level AB/BC scope controls.

Removed the implication that the earlier weighting table was current.

**2026-08-08:** Brought Units 1-3 to deep tier (see Source control and the "Units 1-3 deep-tier detail" section) — per-topic exclusion/boundary language, documented common misconceptions from the 2025 Chief Reader Report, and scoring conventions from the 2025 AB/BC Scoring Guidelines. Done to ground a new FRQ/MCQ authoring batch against real scoring signal rather than the topic-map-only version.

**2026-08-08 (same day, second pass):** Extended deep tier through Unit 8, completing AB's full CED scope (Units 1-8; Units 9-10 are BC-only and remain partial tier, and BC's own extension beyond Unit 8 has not been done). Used the 2025 AB Q1/Q2 Sample Student Responses and Scoring Commentary booklets as an additional source type beyond the CED and Scoring Guidelines. **Found and corrected one real defect in this pack**: arc length (Unit 8, topic 8.13) was previously listed as shared AB/BC — verified false against the CED (explicitly BC-only). Checked the live Production corpus for this specific error before fixing the claim; found no existing `apcalcab-*` arc-length item, so no live content defect resulted from it this time — but the pack itself was wrong and authoring/review guidance built on it would have been wrong too. Flagged Unit 7 (Differential Equations) as lower-confidence than the other four: no released AB FRQ with an official scoring guide covers slope fields/Euler's method/separation of variables in either 2025 or 2026 as of this update.

**2026-08-08 (same day, third pass):** Extended deep tier through Units 9-10, completing BC's full CED scope (Units 1-10 are now entirely deep tier). This was the first deep-tier pass in this fact pack to use genuinely BC-specific sources throughout — the BC Scoring Guidelines, the BC-specific data in the Chief Reader Report (Questions BC2 and BC6), and the BC Question 2 Sample Student Responses booklet — since Units 9-10 have no AB counterpart to lean on. **No topic-map naming errors were found**: all Unit 9/10 topic titles verified correct against the CED, unlike the prior pass's Unit 8 arc-length correction. **One previously uncaptured, boxed, verbatim CED exclusion was found and added**: Topic 10.8 closes BC's entire in-scope convergence-test list to exactly six named tests (nth term test, integral test, comparison test, limit comparison test, alternating series test, ratio test) and explicitly excludes other methods (e.g., the root test) from assessment — this had not been documented anywhere in this fact pack before. Also documented a real, striking pattern specific to Units 9-10: roughly half of these units' Essential Knowledge statements describe a method as merely "extended" from rectangular coordinates without the CED ever writing out the resulting formula (parametric arc length, vector-valued derivative/integral component form, rectangular-polar conversion, polar area, Lagrange error bound, and the Maclaurin series for sin/cos/e^x are all left unstated in the CED's required-content text) — flagged throughout the new section so authoring doesn't mistake commonly-taught notation for CED-mandated notation. Flagged Unit 9 Topics 9.1-9.6 (parametric/vector-valued) as lower-confidence than 9.7-9.9 (polar): no released BC FRQ in 2025 or 2026 tests parametric equations or vector-valued functions directly, while polar curves are well covered by both years' Question 2. Flagged Unit 10 Topics 10.14-10.15 similarly: the 2026 released FRQ (Question 6) tests Maclaurin series manipulation but has no released scoring guide yet as of this update. Found two of the lowest documented point-mean scores in this fact pack's research to date (BC2 Part C's global-justification point at 0.06/1, and BC6 Part A's endpoint-analysis point at 0.14/1) — both substantially lower than the previously-lowest-documented Unit 1 IVT point (≈0.27-0.28/1) — worth prioritizing for authoring/review calibration on polar-optimization and interval-of-convergence items respectively.



# Subject: AP Calculus BC (subject_key ap_calculus_bc)
Format: Short free-response in AP Calculus style: a function given algebraically, piecewise, or as a small table of values. Parts ask for limits, derivatives, values or justifications; justifications cite the relevant definition or theorem.
Parts: 3-4. Criteria (points) in total: 6-8.

Accepted item from this subject in this batch (style reference only):
```json
{
 "title": "Intervals of Continuity and a Piecewise Parameter",
 "calculator": "not_permitted",
 "stimulus": "Let g(x) = ln(5 − x)/(x² − 4).\n\nLet h be the function defined by\nh(x) = x² + kx for x < 2,\nh(x) = 3k − x for x ≥ 2,\nwhere k is a constant.",
 "model_answer": "(a) ln(5 − x) requires 5 − x > 0, so x < 5. The denominator x² − 4 = (x − 2)(x + 2) is zero at x = −2 and x = 2, so these are excluded. Domain: (−∞, −2) ∪ (−2, 2) ∪ (2, 5). The function ln(5 − x) is a logarithmic function of a linear expression and is continuous for x < 5, and x² − 4 is a polynomial, continuous everywhere. A quotient of continuous functions is continuous wherever the denominator is not zero, so g is continuous at every point of each of the three intervals, and therefore continuous on each interval.\n\n(b) For x < 2, h(x) = x² + kx is a polynomial, and for x > 2, h(x) = 3k − x is a polynomial, so h is continuous on (−∞, 2) and (2, ∞). Only x = 2 must be checked.\nlim x→2⁻ h(x) = 2² + 2k = 4 + 2k.\nlim x→2⁺ h(x) = 3k − 2, and h(2) = 3k − 2.\nFor continuity, 4 + 2k = 3k − 2, so k = 6.\nCheck: with k = 6, lim x→2⁻ h(x) = 16, lim x→2⁺ h(x) = 16, so lim x→2 h(x) = 16 = h(2). Since h(2) is defined, the limit exists, and they are equal, h is continuous at 2, and hence on (−∞, ∞).\n\n(c) [−1, 1]: Yes. Every point of [−1, 1] lies in (−2, 2), where g is continuous by part (a), so g is continuous at every point of [−1, 1].\n[1, 3]: No. The point x = 2 is in [1, 3], and g(2) is undefined because 2² − 4 = 0. Since g is not continuous at x = 2, it is not continuous on [1, 3].",
 "verification_python": "import sympy as sp\nx,k=sp.symbols('x k',real=True)\ng=sp.log(5-x)/(x**2-4)\nassert set(sp.solve(x**2-4,x))=={-2,2}\nleft=(x**2+k*x).subs(x,2)\nright=(3*k-x).subs(x,2)\nassert sp.expand(left-(4+2*k))==0\nassert sp.expand(right-(3*k-2))==0\nsol=sp.solve(sp.Eq(left,right),k)\nassert sol==[6]\nassert left.subs(k,6)==16 and right.subs(k,6)==16\nassert sp.limit((x**2+6*x),x,2,'-')==16\nassert sp.limit((18-x),x,2,'+')==16\n# g defined on [-1,1]\nfor t in [sp.Rational(-1),sp.Rational(0),sp.Rational(1)]:\n    assert (t**2-4)!=0 and 5-t>0\nassert -2< -1 and 1<2\nassert (2**2-4)==0 and 1<=2<=3\nprint('ALL_CHECKS_PASSED')",
 "parts": [
  {
   "prompt": "Write the domain of g as a union of open intervals. Explain why g is continuous on each of these intervals.",
   "criteria": [
    {
     "text": "States the domain of g as (−∞, −2) ∪ (−2, 2) ∪ (2, 5).",
     "evidence": "Response requires 5 − x > 0 (x < 5), excludes x = −2 and x = 2 where x² − 4 = 0, and gives the three intervals (−∞, −2), (−2, 2), (2, 5).",
     "fix": "Find where the logarithm's input is positive, then remove every x that makes the denominator zero before writing intervals.",
     "accepted_variants": [
      "x < 5, x ≠ −2, x ≠ 2",
      "{x : x < 5, x ≠ ±2}"
     ]
    },
    {
     "text": "Justifies continuity using function types: ln(5 − x) and x² − 4 are continuous on their domains, so the quotient is continuous wherever it is defined.",
     "evidence": "Response states that logarithmic (or composite logarithmic) and polynomial functions are continuous on their domains and that a quotient of continuous functions is continuous where the denominator is nonzero, hence g is continuous at every point of each interval.",
     "fix": "Cite that logarithmic and polynomial functions are continuous on their domains, and a quotient is continuous wherever its denominator is nonzero.",
     "accepted_variants": []
    }
   ]
  },
  {
   "prompt": "Find the value of k for which h is continuous on (−∞, ∞). Justify your answer using the definition of continuity.",
   "criteria": [
    {
     "text": "Explains that h is continuous for all x ≠ 2 because each piece is a polynomial, so only x = 2 needs to be checked.",
     "evidence": "Response states that x² + kx and 3k − x are polynomials, continuous everywhere, so h is continuous on (−∞, 2) and (2, ∞), and identifies x = 2 as the only point to check.",
     "fix": "Before checking the break point, state that each piece is a polynomial and therefore continuous on its own open interval.",
     "accepted_variants": []
    },
    {
     "text": "Sets the left-hand limit equal to h(2): lim x→2⁻ h(x) = 4 + 2k and lim x→2⁺ h(x) = h(2) = 3k − 2, so 4 + 2k = 3k − 2.",
     "evidence": "Response computes both one-sided limits at x = 2 (or the left-hand limit and h(2)) and sets them equal.",
     "fix": "Compute lim x→2⁻ h(x) from the left piece and h(2) from the right piece, then set them equal.",
     "accepted_variants": [
      "4 + 2k = 3k − 2",
      "2² + 2k = 3k − 2"
     ]
    },
    {
     "text": "Solves to get k = 6 and confirms lim x→2 h(x) = h(2) = 16.",
     "evidence": "Response gives k = 6 and verifies that with k = 6 the limit at x = 2 exists and equals h(2) = 16, so h is continuous on (−∞, ∞).",
     "fix": "After solving for k, substitute back to show the limit and the function value at x = 2 are both 16.",
     "accepted_variants": [
      "k=6"
     ]
    }
   ]
  },
  {
   "prompt": "For each of the closed intervals [−1, 1] and [1, 3], determine whether g is continuous on that interval. Justify each answer.",
   "criteria": [
    {
     "text": "Concludes g is continuous on [−1, 1] because [−1, 1] lies inside (−2, 2), where g is continuous.",
     "evidence": "Response states yes and justifies that every point of [−1, 1] is in (−2, 2), an interval on which g is continuous (or that g is defined and continuous at each point of [−1, 1]).",
     "fix": "Check whether every point of the interval lies inside one of the intervals of continuity found in part (a).",
     "accepted_variants": [
      "yes, continuous on [−1, 1]"
     ]
    },
    {
     "text": "Concludes g is not continuous on [1, 3] because g(2) is undefined (x² − 4 = 0 at x = 2) and 2 is in [1, 3].",
     "evidence": "Response states no and identifies x = 2 in [1, 3] as a point where g is undefined, so g fails to be continuous at a point of the interval.",
     "fix": "A function is continuous on an interval only if continuous at every point; look for excluded x-values inside the interval.",
     "accepted_variants": [
      "no, not continuous on [1, 3]"
     ]
    }
   ]
  }
 ]
}
```

## Topics in this subject's Units 1, 2, 3 (stay inside the designated topic)
1.1 Introducing Calculus: Can Change Occur at an Instant? (Unit 1: Limits and Continuity)
1.10 Exploring Types of Discontinuities (Unit 1: Limits and Continuity)
1.11 Defining Continuity at a Point (Unit 1: Limits and Continuity)
1.12 Confirming Continuity over an Interval (Unit 1: Limits and Continuity)
1.13 Removing Discontinuities (Unit 1: Limits and Continuity)
1.14 Connecting Infinite Limits and Vertical Asymptotes (Unit 1: Limits and Continuity)
1.15 Connecting Limits at Infinity and Horizontal Asymptotes (Unit 1: Limits and Continuity)
1.16 Working with the Intermediate Value Theorem (Unit 1: Limits and Continuity)
1.2 Defining Limits and Using Limit Notation (Unit 1: Limits and Continuity)
1.3 Estimating Limit Values from Graphs (Unit 1: Limits and Continuity)
1.4 Estimating Limit Values from Tables (Unit 1: Limits and Continuity)
1.5 Determining Limits Using Algebraic Properties of Limits (Unit 1: Limits and Continuity)
1.6 Determining Limits Using Algebraic Manipulation (Unit 1: Limits and Continuity)
1.7 Selecting Procedures for Determining Limits (Unit 1: Limits and Continuity)
1.8 Determining Limits Using the Squeeze Theorem (Unit 1: Limits and Continuity)
1.9 Connecting Multiple Representations of Limits (Unit 1: Limits and Continuity)
2.1 Defining Average and Instantaneous Rates of Change at a Point (Unit 2: Differentiation: Definition and Fundamental Properties)
2.10 Derivatives of tan x, cot x, sec x, and csc x (Unit 2: Differentiation: Definition and Fundamental Properties)
2.2 Defining the Derivative of a Function and Using Derivative Notation (Unit 2: Differentiation: Definition and Fundamental Properties)
2.3 Estimating Derivatives of a Function at a Point (Unit 2: Differentiation: Definition and Fundamental Properties)
2.4 Connecting Differentiability and Continuity (Unit 2: Differentiation: Definition and Fundamental Properties)
2.5 Applying the Power Rule (Unit 2: Differentiation: Definition and Fundamental Properties)
2.6 Derivative Rules: Constant, Sum, Difference, and Constant Multiple (Unit 2: Differentiation: Definition and Fundamental Properties)
2.7 Derivatives of cos x, sin x, e^x, and ln x (Unit 2: Differentiation: Definition and Fundamental Properties)
2.8 The Product Rule (Unit 2: Differentiation: Definition and Fundamental Properties)
2.9 The Quotient Rule (Unit 2: Differentiation: Definition and Fundamental Properties)
3.1 The Chain Rule (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
3.2 Implicit Differentiation (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
3.3 Differentiating Inverse Functions (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
3.4 Differentiating Inverse Trigonometric Functions (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
3.5 Selecting Procedures for Calculating Derivatives (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
3.6 Calculating Higher-Order Derivatives (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)

## Targets: write exactly one FRQ for each of these 7 topics

### ap_calculus_bc 1.15 Connecting Limits at Infinity and Horizontal Asymptotes (Unit 1: Limits and Continuity)
Official CED text (governs):
```
TOPIC 1.15
SUGGESTED SKILLS
Connecting Limits at
Infinity and Horizontal
Asymptotes
Connecting
Representations
2.D
Identify how mathematical
characteristics or properties
of functions are related in
different representations.
Required Course Content
ENDURING UNDERSTANDING
LIM-2
Reasoning with definitions, theorems, and properties can be used to justify claims
about continuity.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Interpret the behavior
of functions using limits
involving infinity.
The concept of a limit can be extended to
include limits at infinity.
LIM-2.D
LIM-2.D.3
LIM-2.D.4
Limits at infinity describe end behavior.
LIM-2.D.5
Relative magnitudes of functions and their rates
of change can be compared using limits.
UNIT
SUGGESTED SKILLS
Justification
3.E
Provide reasons or rationales
for solutions or conclusions.
AVAILABLE RESOURCES
You can find the following
related resource in the Online
Teacher Community:
§ Classroom Resource >
Why We Use Theorem in
Calculus
Limits and Continuity
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: rubric_points: Part (b), criterion b1 prescribes clearing the denominator and obtaining −5x = 8, although the part does not require that method. A valid alternative is to write f(x) − 3 = (−5x − 8)/(2x² + 3), then set the numerator equal to zero. The evidence 
- lint: fix length 26 words
- gpt-6.1-sol: rubric_points: Criteria a1, b1, and b2 combine algebraic setup and correct execution into single all-or-nothing points, contrary to the fact pack’s required separation of these elements in multi-step calculations. Criteria c1 and c2 additionally bundle a justi

### ap_calculus_bc 1.1 Introducing Calculus: Can Change Occur at an Instant? (Unit 1: Limits and Continuity)
Official CED text (governs):
```
TOPIC 1.1
SUGGESTED SKILLS
Introducing Calculus:
Can Change Occur
at an Instant?
Connecting
Representations
2.B
Identify mathematical
information from graphical,
numerical, analytical, and/or
verbal representations.
Required Course Content
ENDURING UNDERSTANDING
CHA-1
Calculus allows us to generalize knowledge about motion to diverse problems
involving change.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Interpret the rate of change at
an instant in terms of average
rates of change over intervals
containing that instant.
Calculus uses limits to understand and model
dynamic change.
CHA-1.A
CHA-1.A.1
CHA-1.A.2
Because an average rate of change divides the
change in one variable by the change in another,
the average rate of change is undefined at a
point where the change in the independent
variable would be zero.
CHA-1.A.3
The limit concept allows us to define
instantaneous rate of change in terms of
average rates of change.
UNIT
SUGGESTED SKILLS
Connecting
Representations
2.B
Identify mathematical
information from graphical,
numerical, analytical, and/or
verbal representations.
Limits and Continuity
```
Earlier rejected attempts on this topic:
- topic vote went to {'2.1': 6} with required units [1, 2] (drifted off topic or needed a later unit)
- topic vote went to {'2.1': 6} with required units [1, 2] (drifted off topic or needed a later unit)
- topic vote went to {'2.1': 6} with required units [1, 2] (drifted off topic or needed a later unit)

### ap_calculus_bc 1.5 Determining Limits Using Algebraic Properties of Limits (Unit 1: Limits and Continuity)
Official CED text (governs):
```
TOPIC 1.5
SUGGESTED SKILLS
Determining Limits
Using Algebraic
Properties of Limits
Implementing
Mathematical Processes
1.E
Apply appropriate
mathematical rules or
procedures, with and without
technology.
Required Course Content
ENDURING UNDERSTANDING
LIM-1
Reasoning with definitions, theorems, and properties can be used to justify claims
about limits.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Determine the limits
of functions using limit
theorems.
One-sided limits can be determined analytically
or graphically.
LIM-1.D
LIM-1.D.1
LIM-1.D.2
Limits of sums, differences, products, quotients,
and composite functions can be found using
limit theorems.
UNIT
SUGGESTED SKILLS
Implementing
Mathematical Processes
Limits and Continuity
```
Earlier rejected attempts on this topic:
- lint: a criterion lacks text or evidence
- gpt-6.1-sol: rubric_points: Criterion b2 bundles the composite-limit setup and the final quotient value into one point. Criterion c1 bundles two separately requested one-sided limit values into one point. Criterion d1 bundles the shifted-function limit setup and the final 
- lint: fix length 26 words

### ap_calculus_bc 1.9 Connecting Multiple Representations of Limits (Unit 1: Limits and Continuity)
Official CED text (governs):
```
TOPIC 1.9
Connecting Multiple
Representations
of Limits
This topic is intended to focus on connecting representations. Students should be
given opportunities to practice when and how to apply all learning objectives relating
to limits and translating mathematical information from a single representation or
across multiple representations.
SUGGESTED SKILLS
Connecting
Representations
2.C
Identify a re-expression of
mathematical information
presented in a given
representation.
AVAILABLE RESOURCES
§ AP Calculator Policy
UNIT
SUGGESTED SKILLS
Justification
Limits and Continuity
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: on_topic: Most points assess connections among limit representations, but part (b), criterion b2, requires the definition of continuity from later Topic 1.11.
- gpt-6.1-sol: well_posed: Parts (b) and (d) are underdetermined. A finite table and the assertion that the limit exists do not determine its value. The table suggests 3, but any real limit L is compatible with the data; continuity and the numerical limits in (d) therefore c
- gpt-6.1-sol: well_posed: Parts (c) and (d) require definitive conclusions that the supplied information does not determine. A finite table and the existence of lim x→2 g(x) do not establish its value. Functions matching the table can have limit 3, 5, or −1, producing diffe
- gpt-6.1-sol: rubric_points: Criterion c1 combines a limit-law setup and its numerical execution into one all-or-nothing point rather than separating those observable elements. Criteria c1, d1, and d2 also require conclusions based on an unestablished exact limit of g, so a
- lint: fix length 28 words

### ap_calculus_bc 2.10 Derivatives of tan x, cot x, sec x, and csc x (Unit 2: Differentiation: Definition and Fundamental Properties)
Official CED text (governs):
```
TOPIC 2.10
Finding the Derivatives of
Tangent, Cotangent, Secant,
and/or Cosecant Functions
Required Course Content
ENDURING UNDERSTANDING
FUN-3
Recognizing opportunities to apply derivative rules can simplify differentiation.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Calculate derivatives of
products and quotients of
differentiable functions.
Rearranging tangent, cotangent, secant, and
cosecant functions using identities allows
differentiation using derivative rules.
FUN-3.B
FUN-3.B.3
AP CALCULUS AB AND BC
UNIT 3
Differentiation:
Composite,
Implicit,
and Inverse
Functions
5–10% AB
5–10% BC
AP EXAM WEIGHTING
~10–11 AB
~8–9 BC
CLASS PERIODS
Remember to go to AP Classroom
to assign students the online
Progress Check for this unit.
Whether assigned as homework or
completed in class, the Progress
Check provides each student with
immediate feedback related to this
unit’s topics and skills.
Progress Check 3
Multiple-choice: ~15 questions
Free-response: 3 questions
(partial/full)
UNIT
5–10% AB 5–10% BC AP EXAM WEIGHTING ~10–11 AB ~8–9 BC CLASS PERIODS
BIG IDEA 3
Analysis of
Functions FUN
§ If pressure experienced
by a diver is a function
of depth and depth is a
function of time, how might
we find the rate of change
in pressure with respect to
time?
Differentiation:
Composite, Implicit, and
Inverse Functions
Developing Understanding
In this unit, students learn how to differentiate composite functions using the chain rule
and apply that understanding to determine derivatives of implicit and inverse functions.
Students need to understand that for composite functions, y is a function of u while u
dy dy du
=
. , accounts for these
dx du dx
psi psi m
=
.
.
relationships. Units analysis can strengthen the connection, as in
min m min
is a function of x. Leibniz notation for the chain rule,
Saying, “times the derivative of what’s inside,” every time we apply the chain rule
reminds students to avoid a common error. Mastering the chain rule is essential to
success in all future units.
Building the Mathematical Practices
1.C
1.E
3.G
Identifying composite and implicit functions is a key differentiation skill. Students must
recognize functions embedded in functions and be able to decompose composite
functions into their “outer” and “inner” component functions. Misapplying the chain
rule by forgetting to also differentiate the “inner” function or misidentifying the “inner”
function are common errors. Provide sample responses that demonstrate these
errors to help students be mindful of them in their own work. Reinforcing the chain rule
structure sets the stage for Unit 6, when students learn the inverse of this process.
Students should continue to practice using correct notation and applying procedures
accurately. Checking one another’s work, reviewing sample responses (with and
without errors), and using technology to check calculations develop these skills.
Emphasize that taking higher-order derivatives mirrors familiar differentiation
processes (i.e., “function is to first derivative as first derivative is to second derivative”).
Use questioning techniques such as, “What does this mean?” to help students develop
a more solid conceptual understanding of higher-order differentiation.
Preparing for the AP Exam
Mastery of the chain rule and its applications is essential for success on the AP Exam.
The chain rule will be the target of assessment for many questions and a necessary
step along the way for others. One common error is not recognizing when the chain
rule applies, especially in composite functions such as sin2x, tan (2x - 1), and ex . In
y
, students must recognize that the chain rule applies to y
3y - x
because y depends on x. When multiple rules apply, students may struggle with the
expressions like
order of operations. Offer mixed practice differentiating general functions using select
values provided in tables and graphs. Focus on products, quotients, compositions,
and inverses of functions, especially those with names other than f and g. Connecting
graphs, tables, and algebraic reasoning builds understanding of differentiation of
inverse functions.
UNIT
Differentiation: Composite, Implicit, and Inverse Functions
FUN-3
Enduring
Understanding
UNIT AT A GLANCE
Class Periods
Topic
Suggested Skills
3.1 The Chain Rule
```
Earlier rejected attempts on this topic:
- lint: fix length 26 words; refers to a figure/graph/diagram
- gpt-6.1-sol: rubric_points: Criteria b1 and c1 prescribe methods not required by their parts. Part (b) permits rewriting f(x) = x/cos x and using the quotient rule, but b1 requires product-rule evidence. Part (c) permits rewriting k(x) = (1 + cos x)/sin x and differentiati
- deepseek-v4-pro: rubric_points: Part (b) criterion b1 requires the product rule and part (c) criterion c1 requires the memorized csc and cot derivative formulas, but neither part asks for a specific method; valid quotient-rule derivations (x/cos x for f, 1/sin x and cos x/sin 

### ap_calculus_bc 2.1 Defining Average and Instantaneous Rates of Change at a Point (Unit 2: Differentiation: Definition and Fundamental Properties)
Official CED text (governs):
```
TOPIC 2.1
SUGGESTED SKILLS
Defining Average and
Instantaneous Rates
of Change at a Point
Connecting
Representations
2.B
Identify mathematical
information from graphical,
numerical, analytical, and/or
verbal representations.
Required Course Content
ENDURING UNDERSTANDING
CHA-2
Derivatives allow us to determine rates of change at an instant by applying limits to
knowledge about rates of change over intervals.
LEARNING OBJECTIVE
ESSENTIAL KNOWLEDGE
Determine average rates
of change using difference
quotients.
The difference quotients f (a + h) - f (a) and
CHA-2.A
CHA-2.B
Represent the derivative of
a function as the limit of a
difference quotient.
CHA-2.A.1
f (x ) - f (a) express the averagehrate of change
x -a
of a function over an interval.
CHA-2.B.1
The instantaneous rate of change of a
function at x = a can be expressed by
f ( x ) - f (a )
f (a + h) - f (a) or
,
lim
x
→
a
x -a
h →0
h
lim
provided the limit exists. These are equivalent
forms of the definition of the derivative and are
denoted f ' a .
( )
UNIT
SUGGESTED SKILLS
Implementing
Mathematical Processes
1.D
Identify an appropriate
mathematical rule or procedure
based on the relationship
between concepts or processes
to solve problems.
Communication and
Notation
Differentiation: Definition and Fundamental Properties
```
Earlier rejected attempts on this topic:
- topic vote went to {'2.2': 4, '2.1': 2} with required units [1, 2] (drifted off topic or needed a later unit)
- gpt-6.1-sol: rubric_points: Part (b), criterion b2 requires explicitly multiplying numerator and denominator by the conjugate, although the prompt only requires rewriting the quotient. This rejects valid alternative algebraic derivations, such as using the difference-of-sq
- lint: a criterion lacks text or evidence

### ap_calculus_bc 3.5 Selecting Procedures for Calculating Derivatives (Unit 3: Differentiation: Composite, Implicit, and Inverse Functions)
Official CED text (governs):
```
TOPIC 3.5
Selecting Procedures
for Calculating
Derivatives
This topic is intended to focus on the skill of selecting an appropriate procedure for
calculating derivatives. Students should be given opportunities to practice when and
how to apply all learning objectives relating to calculating derivatives.
return to ContenTS
UNIT
Differentiation: Composite, Implicit, and Inverse Functions
```
Earlier rejected attempts on this topic:
- gpt-6.1-sol: well_posed: The setup is inconsistent: no differentiable, one-to-one function g can satisfy the table. By continuity and the Intermediate Value Theorem, g(2) = 3 and g(3) = 1 imply g(d) = 2 for some d in (2,3), but g(1) = 2 already. Thus parts (a) and (c) use 
- gpt-6.1-sol: rubric_points: Criterion d2 requires the quotient-rule numerical calculation even though d1 explicitly permits the product rule. A correct calculation q′(2) = (−2)/4 − 2(1)/8 = −3/4 must also earn d2. Criterion c2 lists 0.1667 and 0.167 as equivalent forms of 
- gpt-6.1-sol: well_posed: Part (d) contradicts the setup. Differentiability implies continuity, and f(1) = 3 and f(2) = 1 imply that f(c) = 2 for some c in (1, 2), by the Intermediate Value Theorem. Since f(3) = 2, f cannot be one-to-one.
- gpt-6.1-sol: rubric_points: Criterion b1 requires a quotient-rule expression, rejecting a valid alternative method that the prompt permits. Applying the product and chain rules to ln(f(x))·g(x)⁻¹ gives k′(x) = [f′(x)/f(x)]·g(x)⁻¹ − ln(f(x))·g′(x)·g(x)⁻² and should earn the
- gpt-6.1-sol: well_posed: Setup, affecting parts (b) and (d): No function g satisfies the stated assumptions and table. A continuous one-to-one function on ℝ is strictly monotonic. Since g(1) = 2 > g(2) = 1, g must be decreasing, contradicting g′(1) = 5 > 0.
- gpt-6.1-sol: rubric_points: Criterion b1 requires the general formula q′(x) = f′(g(x))·g′(x), rejecting the valid point-specific work q′(1) = f′(g(1))·g′(1) = f′(2)·5. The prompt requires showing the derivative rule, not writing it for general x; the listed variants do not


## AP Calculus BC CED fact pack (course-wide sections and units up to 3)
# AP Calculus AB and BC - CED Fact Pack

Status: Primary-source verified. Use this version for 2026-27 authoring and review.

## Source control

Source document: College Board, AP Calculus AB and BC Course and Exam Description.

Edition shown on cover: Effective Fall 2020. The local College Board release carries 2026 copyright and 07/2026 metadata.

Local source: `docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf`

Source SHA-256: `fd571cdc252c24d33a75ed556ee20d9261ef1ad3dbb718d0caf78acecc8253ca`

Verification: PDF metadata, cover, course framework, unit weighting table, exam overview, topic maps, and AB/BC scope markers were checked directly. This pack supersedes the earlier digest whose unit-weight ranges were stale.

**2026-08-08 deep-tier update, extended to Units 9-10 (BC's remaining scope) same day — BC's full CED scope (Units 1-10) is now entirely deep tier.** Units 9-10 (Parametric, Polar, and Vector-Valued Functions; Infinite Sequences and Series) were brought to deep tier using the CED PDF (pages 163-195, `Subject Packs/Calculus BC/ap-calculus-ab-and-bc-course-and-exam-description copy.pdf`, same underlying document as the AB copy used earlier, verified identical content for this page range) plus BC-specific primary sources not used in the Units 1-8 passes: the 2025 **BC** Scoring Guidelines (`ap25-sg-calculus-bc.pdf` — distinct from the AB Scoring Guidelines used for Units 1-3, since Units 9-10 don't exist on the AB exam at all), the 2025 Chief Reader Report filtered for its BC-specific question data (`ap25-cr-report-calculus-ab-bc.pdf`, Questions BC2 and BC6), the 2025 BC **Question 2** Sample Student Responses and Scoring Commentary booklet (`ap25-apc-calculus-bc-q2.pdf` — Question 2 is the BC-only polar-curve FRQ; the Question 1 booklet covers a shared AB/BC average-value item already grounded in the Units 1-8 pass and was not re-mined here), and the 2025/2026 released BC FRQ booklets (`ap25-frq-calculus-bc.pdf`, `ap26-frq-calculus-bc.pdf`). Unlike the Units 4-8 pass, which leaned on AB-domain sources, this pass is the first genuinely BC-specific-source deep-tier pass, since Units 9-10 have no AB counterpart. One previously uncaptured, boxed, verbatim CED exclusion was found and added: Topic 10.8's exclusion statement restricts BC's entire in-scope convergence-test toolkit to exactly six named tests (nth term test, integral test, comparison test, limit comparison test, alternating series test, ratio test) and explicitly states other methods (e.g., the root test) "are not assessed on the exam." No topic-map naming errors were found in the existing Unit 9/10 topic-map entries — all topic titles verified correct against the CED. See "Units 9-10 deep-tier detail" below.

**2026-08-08 deep-tier update, extended to Units 4-8 (AB's full scope) same day.** Units 4-8 were brought to deep tier using the same CED PDF pages (77-160) plus additional David-supplied primary sources not used in the Units 1-3 pass: the 2025 AB **Sample Student Responses and Scoring Commentary** booklets for Q1 and Q2 (`ap25-apc-calculus-ab-q1.pdf`, `ap25-apc-calculus-ab-q2.pdf` — these contain 3 real graded student responses per question with reader commentary explaining exactly why each point was or wasn't earned, a materially different and more concrete source than the scoring guideline alone). One correction found and applied: the prior version of this pack stated arc length (Unit 8, topic 8.13) was shared AB/BC — verified false against the CED (explicitly BC-only in three places); checked the live Production corpus for any `apcalcab-*` item authored on arc length before fixing the claim — none found, no live defect from this specific error. **CORRECTION, 2026-09-29: that corpus check was wrong.** `apcalcab-mcq-050` ("What is the length of y=x² from x=0 to x=1.4") was a published AB arc-length item, found by the TASK-0050 topic pass when no AB topic would fit it. It has been moved to AP Calculus BC as `apcalcbc-mcq-mv050` with topic 8.13. Either the original check missed it or the item was authored afterwards.

**2026-08-08 deep-tier update, Units 1-3.** Per `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §1.6, this pack was previously "partial tier" (topic map + course-level removals, no per-topic inline exclusions or equation blocks) — thinner than the Biology/Chemistry deep tier. Units 1-3 were brought to deep tier using, in addition to the CED PDF above: the 2025 AP Calculus AB/BC Chief Reader Report (`ap25-cr-report-calculus-ab-bc.pdf`, 39pp, common-error data by FRQ point), the 2025 AB and BC Scoring Guidelines (`ap25-sg-calculus-ab.pdf`, `ap25-sg-calculus-bc.pdf`, 27pp each, point-earning criteria and general scoring notes), and the 2025/2026 released FRQ booklets (`ap25-frq-calculus-ab.pdf`, `ap25-frq-calculus-bc.pdf`, `ap26-frq-calculus-ab.pdf`, `ap26-frq-calculus-bc.pdf`) — all David-supplied primary-source PDFs, read directly page-by-page, not summarized from web search. **Units 4-10 remain at partial tier** — this was a scoped update to ground one authoring batch (Units 1-3 FRQ/MCQ), not a full ten-unit rebuild; see §7.3 of the protocol doc for why a scoped-per-need approach was chosen over a blanket rebuild.

## Course relationship and scope

AP Calculus AB is equivalent to a first-semester college calculus course. AP Calculus BC is equivalent to first- and second-semester college calculus. BC contains all AB content plus additional integration content, parametric/polar/vector-valued functions, and sequences and series.

AB contains Units 1-8. BC contains Units 1-10. Units 9 and 10 are BC-only. Within Unit 6, Topics 6.12 and 6.13 are also BC-only.

Do not infer AB eligibility from a shared unit number alone. Every AB item must be checked at topic level.

## Exam structure

Both exams are 3 hours 10 minutes, with 42 multiple-choice questions and 6 free-response questions.

Section I, Part A: 29 MCQs, no graphing calculator, 62 minutes, 35% of score.

Section I, Part B: 13 MCQs, graphing calculator required, 38 minutes, 15% of score.

Section II, Part A: 2 FRQs, graphing calculator required, 30 minutes, approximately 16.7% of score.

Section II, Part B: 4 FRQs, no graphing calculator, 60 minutes, approximately 33.3% of score.

The AB and BC exams share three FRQs drawn from the AB domain. Each exam includes multiple function types and analytical, graphical, numerical/tabular, and verbal representations. Each includes at least two real-world contexts.

Calculator-enabled work may require graphing, numerical zero solving, numerical differentiation, and numerical definite integration. On an FRQ, students must show the mathematical setup that produced a calculator result.

## Multiple-choice unit weighting

Unit 1 - Limits and Continuity: AB 10-15%; BC 5-10%.

Unit 2 - Differentiation: Definition and Basic Derivative Rules: AB 10-15%; BC 5-10%.

Unit 3 - Differentiation: Composite, Implicit, and Inverse Functions: AB 5-10%; BC 5-10%.

Unit 4 - Contextual Applications of Differentiation: AB 10-15%; BC 5-10%.

Unit 5 - Applying Derivatives to Analyze Functions: AB 15-20%; BC 10-15%.

Unit 6 - Integration and Accumulation of Change: AB 15-20%; BC 15-20%.

Unit 7 - Differential Equations: AB 5-10%; BC 5-10%.

Unit 8 - Applications of Integration: AB 10-15%; BC 5-10%.

Unit 9 - Parametric Equations, Polar Coordinates, and Vector-Valued Functions: BC only, 10-15%.

Unit 10 - Infinite Sequences and Series: BC only, 15-20%.

Naming note: the course-framework unit titles use “Fundamental Properties” for Unit 2 and “Analytical Applications of Differentiation” for Unit 5, while the exam-information weighting table uses “Basic Derivative Rules” and “Applying Derivatives to Analyze Functions.” Treat these as aliases for the same numbered units.

## Mathematical practices

Practice 1 - Implementing Mathematical Processes: determine expressions and values using mathematical procedures and rules.

Practice 2 - Connecting Representations: translate mathematical information within and across graphical, numerical, analytical, and verbal representations.

Practice 3 - Justification: select and apply definitions, theorems, and tests; support conclusions; confirm conditions and accuracy.

Practice 4 - Communication and Notation: use precise language, units, symbols, graphing conventions, and rounding.

MCQ practice weighting: Practice 1, 50-70%; Practice 2, 15-30%; Practice 3, 10-20%. Practice 4 is not assessed in the MCQ section.

FRQ practice weighting: Practice 1, 35-60%; Practice 2, 10-20%; Practice 3, 35-60%; Practice 4, 10-25%.

## Practice skills (sub-skills) — TASK-0050 Phase 0, added 2026-09-29

Source: CED "Mathematical Practices" page (Course Framework p. 12), supplied by David 2026-09-29 as
a direct capture of the College Board PDF. Transcribed verbatim, including the three sub-skills the
CED itself marks **not assessed**. These are the skill codes the skill dimension uses
(`app.taxonomy_skills`); **23 total, 20 assessed.**

### Practice 1 — Implementing Mathematical Processes
*Determine expressions and values using mathematical procedures and rules.*

- **1.A** Identify the question to be answered or problem to be solved. *(not assessed)*
- **1.B** Identify key and relevant information to answer a question or solve a problem. *(not assessed)*
- **1.C** Identify an appropriate mathematical rule or procedure based on the classification of a given expression (e.g., use the chain rule to find the derivative of a composite function).
- **1.D** Identify an appropriate mathematical rule or procedure based on the relationship between concepts (e.g., rate of change and accumulation) or processes (e.g., differentiation and its inverse process, anti-differentiation) to solve problems.
- **1.E** Apply appropriate mathematical rules or procedures, with and without technology.
- **1.F** Explain how an approximated value relates to the actual value.

### Practice 2 — Connecting Representations
*Translate mathematical information from a single representation or across multiple representations.*

- **2.A** Identify common underlying structures in problems involving different contextual situations.
- **2.B** Identify mathematical information from graphical, numerical, analytical, and/or verbal representations.
- **2.C** Identify a re-expression of mathematical information presented in a given representation.
- **2.D** Identify how mathematical characteristics or properties of functions are related in different representations.
- **2.E** Describe the relationships among different representations of functions and their derivatives.

### Practice 3 — Justification
*Justify reasoning and solutions.*

- **3.A** Apply technology to develop claims and conjectures. *(not assessed)*
- **3.B** Identify an appropriate mathematical definition, theorem, or test to apply.
- **3.C** Confirm whether hypotheses or conditions of a selected definition, theorem, or test have been satisfied.
- **3.D** Apply an appropriate mathematical definition, theorem, or test.
- **3.E** Provide reasons or rationales for solutions and conclusions.
- **3.F** Explain the meaning of mathematical solutions in context.
- **3.G** Confirm that solutions are accurate and appropriate.

### Practice 4 — Communication and Notation
*Use correct notation, language, and mathematical conventions to communicate results or solutions.*

- **4.A** Use precise mathematical language.
- **4.B** Use appropriate units of measure.
- **4.C** Use appropriate mathematical symbols and notation (e.g., represent a derivative using f'(x), y', and dy/dx).
- **4.D** Use appropriate graphing techniques.
- **4.E** Apply appropriate rounding procedures.

## Topic-to-practice alignment — TASK-0050 Phase 0, added 2026-09-29

Source: CED "Course at a Glance" (Course Framework pp. 9-10), supplied by David 2026-09-29. Each
topic carries the practice the CED aligns to it. This is the CED's **own** alignment, so the
topic × skill grid is transcribed rather than curated — the case `TASK-0050` §6.2 says to prefer.

**Independent verification of this transcription.** Counting topics here gives 87 across Units 1-8,
of which six are BC-only (6.11, 6.12, 6.13, 7.5, 7.9, 8.13). That predicts AB = 81 and
BC = 87 + 9 + 15 = 111. Production holds exactly **81** and **111**. The topic sets match the CED
exactly, which corroborates both the transcription and the existing topic map.

| Unit | Topic → Practice |
| --- | --- |
| 1 | 1.1→2, 1.2→2, 1.3→2, 1.4→2, 1.5→1, 1.6→1, 1.7→1, 1.8→3, 1.9→2, 1.10→3, 1.11→3, 1.12→1, 1.13→1, 1.14→3, 1.15→2, 1.16→3 |
| 2 | 2.1→2, **2.2→1 and 4**, 2.3→1, 2.4→3, 2.5→1, 2.6→1, 2.7→1, 2.8→1, 2.9→1, 2.10→1 |
| 3 | 3.1→1, 3.2→1, 3.3→3, 3.4→1, 3.5→1, 3.6→1 |
| 4 | 4.1→1, 4.2→1, 4.3→2, 4.4→1, 4.5→3, 4.6→1, 4.7→3 |
| 5 | 5.1→3, 5.2→3, 5.3→2, 5.4→3, 5.5→1, 5.6→2, 5.7→3, 5.8→2, 5.9→2, 5.10→2, 5.11→3, **5.12→1 and 3** |
| 6 | 6.1→4, 6.2→1, 6.3→2, 6.4→1, 6.5→2, 6.6→3, 6.7→3, 6.8→4, 6.9→1, 6.10→1, 6.11→1 *(BC)*, 6.12→1 *(BC)*, 6.13→1 *(BC)*, 6.14→1 |
| 7 | 7.1→2, 7.2→3, 7.3→2, 7.4→4, 7.5→1 *(BC)*, 7.6→1, 7.7→1, 7.8→3, 7.9→3 *(BC)* |
| 8 | 8.1→1, 8.2→1, 8.3→3, 8.4→4, 8.5→1, 8.6→2, 8.7→3, 8.8→3, 8.9→3, 8.10→2, 8.11→4, 8.12→2, 8.13→3 *(BC)* |
| 9 *(BC only)* | 9.1→2, 9.2→1, 9.3→1, 9.4→1, 9.5→1, 9.6→1, 9.7→2, 9.8→3, 9.9→3 |
| 10 *(BC only)* | 10.1→3, 10.2→3, 10.3→3, 10.4→3, 10.5→3, 10.6→3, 10.7→3, 10.8→3, 10.9→3, 10.10→1, **10.11→3 and 2**, 10.12→1, 10.13→2, 10.14→2, 10.15→3 |

**Three topics carry two practices** — 2.2 (1 and 4, confirmed by the page's own footnote), 5.12
(1 and 3), and 10.11 (3 and 2). Every other topic carries exactly one.

**Not a two-practice case:** topic 2.7 displays two *big-idea* badges (FUN and LIM) both tagged
practice 1. Big ideas (CHA Change, LIM Limits, FUN Analysis of Functions) are a separate axis from
practices and are not skill codes.

**How the grid derives from this.** A topic's candidate skills are the **assessed** sub-skills of its
aligned practice — so a Practice 3 topic offers 3.B–3.G (six candidates, 3.A excluded as not
assessed), a Practice 1 topic offers 1.C–1.F (four, 1.A/1.B excluded), Practice 2 offers 2.A–2.E
(five), Practice 4 offers 4.A–4.E (five). Item-level labelling then chooses one sub-skill from that
set, exactly as AP Statistics' Phase B did.

## Topic map

### Unit 1 - Limits and Continuity

1.1 Introducing Calculus: Can Change Occur at an Instant?; 1.2 Defining Limits and Using Limit Notation; 1.3 Estimating Limit Values from Graphs; 1.4 Estimating Limit Values from Tables; 1.5 Determining Limits Using Algebraic Properties of Limits; 1.6 Determining Limits Using Algebraic Manipulation; 1.7 Selecting Procedures for Determining Limits; 1.8 Determining Limits Using the Squeeze Theorem; 1.9 Connecting Multiple Representations of Limits; 1.10 Exploring Types of Discontinuities; 1.11 Defining Continuity at a Point; 1.12 Confirming Continuity over an Interval; 1.13 Removing Discontinuities; 1.14 Connecting Infinite Limits and Vertical Asymptotes; 1.15 Connecting Limits at Infinity and Horizontal Asymptotes; 1.16 Working with the Intermediate Value Theorem.

### Unit 2 - Differentiation: Definition and Fundamental Properties

2.1 Defining Average and Instantaneous Rates of Change at a Point; 2.2 Defining the Derivative of a Function and Using Derivative Notation; 2.3 Estimating Derivatives of a Function at a Point; 2.4 Connecting Differentiability and Continuity; 2.5 Applying the Power Rule; 2.6 Derivative Rules: Constant, Sum, Difference, and Constant Multiple; 2.7 Derivatives of cos x, sin x, e^x, and ln x; 2.8 The Product Rule; 2.9 The Quotient Rule; 2.10 Derivatives of tan x, cot x, sec x, and csc x.

### Unit 3 - Differentiation: Composite, Implicit, and Inverse Functions

3.1 The Chain Rule; 3.2 Implicit Differentiation; 3.3 Differentiating Inverse Functions; 3.4 Differentiating Inverse Trigonometric Functions; 3.5 Selecting Procedures for Calculating Derivatives; 3.6 Calculating Higher-Order Derivatives.

## High-risk authoring and review boundaries

AB scope excludes all of Units 9 and 10, linear partial fractions, and improper integrals.

BC items may assess any AB topic, so BC-only tagging is needed only when an item requires content unavailable in AB. Do not label a routine AB-domain item “BC-only” merely because it can appear on the BC exam.

**Correction, 2026-08-08: arc length (Unit 8, topic 8.13) is BC-only, not shared AB/BC** — the prior version of this line was wrong. Verified directly against the CED: topic 8.13's title, its Learning Objective (CHA-6.A), and its EK (CHA-6.A.1) all carry an explicit "BC ONLY" tag, and it uses its own dedicated Enduring Understanding (CHA-6) separate from the area/volume group (CHA-5). Do not author or approve an `apcalcab-*` item on arc length. Parametric arc length in Unit 9 is also BC-only (Unit 9 is BC-only in its entirety).

**Addition, 2026-08-08: BC's series-convergence-test toolkit is boxed and closed.** Topic 10.8 carries a verbatim CED exclusion statement restricting the entire in-scope convergence-test list to exactly six named tests (nth term test, integral test, comparison test, limit comparison test, alternating series test, ratio test) — "Other methods are not assessed on the exam." Do not author an item requiring the root test, condensation test, Raabe's test, Dirichlet's test, or any other convergence test outside this list, even though the CED notes teachers may cover additional methods in class. See "Units 9-10 deep-tier detail" below for the exact quote.

> **CORRECTION, 2026-09-29.** The line below was **wrong** and is struck through. Euler's method
> (7.5) and logistic models (7.9) are **BC-ONLY**, not shared AB/BC. This contradicted the same
> pack's own Unit 7 exclusion note, which correctly states "Two topics are BC-only, each tagged in
> three places: **7.5 Euler's Method** and **7.9 Logistic Models**." The taxonomy agrees with the
> exclusion note: `ap_calculus_ab` registers 7.1, 7.2, 7.3, 7.4, 7.6, 7.7, 7.8 and **no 7.5 or 7.9**.
>
> This error had a live consequence. Two published `apcalcab-*` items were authored on exactly these
> BC-only topics — `apcalcab-mcq-045` (Euler's method) and `apcalcab-mcq-046` (logistic model) — and
> were found by the TASK-0050 topic pass, which could not fit either to any AB topic. Both have been
> moved to AP Calculus BC (`apcalcbc-mcq-mv045`, `apcalcbc-mcq-mv046`). A line like this one is
> precisely what licenses authoring such an item, which is why it is corrected here rather than
> quietly deleted.

~~Euler's method and logistic differential equations are shared AB/BC content.~~ **Euler's method
(7.5) and logistic models (7.9) are BC-only. Do not author or approve an `apcalcab-*` item on
either.**

L'Hospital's Rule is shared AB/BC content.

Calculator-required questions must require or naturally support an approved calculator capability; do not add a calculator label to an item whose intended solution is purely symbolic.

FRQ scoring must reward setup, reasoning, context, units, and notation where the task demands them. A correct unsupported number is not automatically a complete response.

## Units 1-3 deep-tier detail (2026-08-08 addition)

Verified directly against the CED PDF (pages 27-76) plus the scoring/reader-report sources listed in Source control above. Exclusion density here is genuinely sparser than Biology/Chemistry — Calc AB/BC's scope-limiting signal comes mostly from illustrative examples and scoring-guideline precision rules, not boxed "do not assess" statements, except where noted. Do not infer a missing exclusion tag means "anything goes" — check the illustrative examples and common-error notes below, which function as the real boundary.

### Unit 1 — Limits and Continuity (AB 10-15%, BC 5-10%)

*Exclusion:* The epsilon-delta definition of a limit is **not assessed** on the AP Calculus AB or BC Exam (attached to EK LIM-1.A.1, topic 1.2). Teachers may cover it in class, but do not author an item requiring a student to produce or reason from an epsilon-delta proof.

*Scope boundary via illustrative examples:* "Limit does not exist" cases (topic 1.3, EK LIM-1.C.4) are scoped to three canonical patterns — unbounded behavior (`lim(x→0) 1/x² = ∞`), oscillation (`lim(x→0) sin(1/x)` DNE), and mismatched one-sided limits (`lim(x→0) |x|/x` DNE). Stay within these patterns; do not invent exotic DNE cases the CED doesn't illustrate.

*High-yield content requirement (topic 1.16, IVT):* An item is not "IVT-complete" unless the response explicitly (a) states the function is continuous — and *why* (e.g., "differentiable, therefore continuous," not just asserted), (b) states the target value is strictly between the two endpoint values with the actual numbers, and (c) concludes existence. Per the 2025 Chief Reader Report, this was the single lowest-scoring point pattern in the entire AB/BC exam (mean ≈0.27-0.28/1 on the continuity-justification point; ≈0.28-0.43 on the conclusion point) — the failure mode is *not* mathematical, it's stating the conclusion without the two hypothesis-checks. A rubric that awards credit for "the right final answer" without requiring both checks does not match real AP grading and will silently pass a response real graders would dock.

*Documented misconception, direct from the Chief Reader Report:* "A few responses incorrectly attempted to apply the Mean Value Theorem" where IVT was required. MVT-vs-IVT confusion is real, reader-documented, and appropriate as an MCQ distractor.

*Documented misconception (end behavior / limits at infinity, topic 1.15):* Students confuse "end behavior" (limit as the variable approaches infinity) with evaluating near zero — the Chief Reader Report's most common error on the relevant 2025 FRQ part was writing `lim(t→0)` instead of `lim(t→∞)`. Also appropriate as an MCQ distractor.

### Unit 2 — Differentiation: Definition and Fundamental Properties (AB 10-15%, BC 5-10%)

No boxed exclusion statement for this unit's topics. The real boundary is notational/structural, and it is scored, not stylistic:

*Structural requirement (product/quotient rule, topics 2.8-2.9):* the CED's own "Preparing for the AP Exam" note states plainly: "Failure to present this structure will cost students the point they might have earned, even with a correct numerical answer." For `f(x) = u(x)·v(x)`, a response must show `f′(3) = u(3)v′(3) + v(3)u′(3)` as an explicit structural step, separate from the final numeric value — these are scored as two separate point-earning line items in real AP scoring guidelines (setup point, value point), not one all-or-nothing check.

*Documented misconception (chain rule on exponentials, boundary with Unit 3 but rooted in Unit 2 derivative rules):* per the Chief Reader Report, students frequently differentiate `e^u` as `u·e^u` instead of `e^u·u′` — i.e. they apply a garbled product-rule-shaped pattern to what should be a direct chain-rule application of a known derivative rule. Confirmed, quotable, appropriate as an MCQ distractor for any `d/dx[e^(g(x))]` item.

*Documented misconception (notation, topic 2.2/2.8):* renaming a derivative expression to new notation without defining it (e.g. silently calling `x_H′(t)` as `H′(t)`), and omitting parentheses around a binomial factor before a trig/exponential term (`2t − 4·e^(...)` instead of `(2t−4)·e^(...)`) — both documented as causing real point loss even when the underlying calculus was otherwise correct.

*Calculator-answer convention:* when a calculator-permitted item requires a numeric derivative value, the CED's own guidance requires "presenting mathematical expressions evaluated on the calculator" with results "rounded or truncated to three places after the decimal point" — and per the 2025/2026 Scoring Guidelines' universal front-matter note, **at most one point per entire FRQ (all parts combined) may be lost to inappropriate rounding** — never more, regardless of how many sub-answers are mis-rounded. Rubrics for calculator-permitted items should reflect this cap, not deduct per-instance.

### Unit 3 — Differentiation: Composite, Implicit, and Inverse Functions (AB 5-10%, BC 5-10%)

No boxed exclusion statement for this unit's topics either. This is the highest-error-density unit in the whole Units-1-3 range per the Chief Reader Report (AB6, the flagship implicit-differentiation FRQ, had a mean score of 4.12/9) — the boundary here is almost entirely about which near-miss responses do *not* earn credit despite reaching a materially correct answer:

*Documented misconception (chain rule mechanics, topic 3.1):* "Misapplying the chain rule by forgetting to also differentiate the inner function, or misidentifying the inner function" (CED's own Building Math Practices note) — e.g. failing to recognize the chain rule applies to `sin²x`, `tan(2x−1)`, or `e^(x²)`, or (in an implicit-differentiation context) not recognizing that `y` itself requires the chain rule because it depends on `x`.

*Documented misconception (implicit differentiation, topic 3.2) — five specific, reader-quoted errors, all appropriate as FRQ near-miss rubric language or MCQ distractors:*
1. Using `dy` where `dy/dx` is meant, or `dy/dx` where the operator `d/dx` is meant (conflating the differential with the derivative).
2. Dropping the "= 0" on the right-hand side after implicitly differentiating a constant (silently losing a term).
3. Omitting parentheses around the coefficient of `dy/dx` after collecting terms — e.g. writing `3y² − 2y − 1 · dy/dx = −½x` instead of `(3y² − 2y − 1)·dy/dx = −½x`, which changes the meaning.
4. Using separation of variables instead of implicit differentiation — a wrong-technique-choice error, not an arithmetic slip.
5. **Vertical-vs-horizontal tangent inversion**: setting the *numerator* of `dy/dx` to zero (the horizontal-tangent condition) when the problem requires the *denominator* to be zero (the vertical-tangent condition). Chief Reader Report calls this out explicitly and it is a strong, real, quotable MCQ distractor.

*Documented misconception (related rates via implicit differentiation w.r.t. t, still topic 3.2):* differentiating with respect to `x` and never reconnecting the result to `t` (forgetting the problem requires `d/dt`, introducing `dx/dt`/`dy/dt` terms); writing the derivative of `2xy` as `2(dx/dt)(dy/dt)` instead of correctly applying the product rule (`2(x·dy/dt + y·dx/dt)`); writing `d/dt(ln y)` as `1/y` instead of `(1/y)(dy/dt)` (dropping the required chain-rule factor). The Scoring Guidelines explicitly reject the shortcut "stating `dy/dt = dy/dx · dx/dt` alone, with no completed numeric computation" as earning zero points — citing the identity is not sufficient, it must be carried through.

*Selection-of-root requirement (topic 3.2, vertical tangent):* per the Scoring Guidelines' own scoring notes, finding both roots of a resulting quadratic is not sufficient for credit — the response must explicitly state which root satisfies the problem's domain restriction (e.g. "the curve requires y > 0, so y = 1" — merely listing "y = −1/3 and y = 1" without that selection step does not earn the point).

### Cross-unit scoring conventions confirmed from the 2025/2026 Scoring Guidelines (apply when authoring FRQ rubrics for any Units 1-3 item)

- AP Calc FRQ scoring decomposes into three separable point types wherever a multi-step calculation is involved: (1) a *setup/method-identification* point (e.g. "states Product Rule," "sets up the ratio," "writes the implicit-differentiation equation"), (2) an *execution* point (correct value from correctly executing the method), and (3) sometimes a separate *supported-conclusion* point. A response can earn the setup point with an arithmetic slip in execution, and vice versa — do not write single all-or-nothing criteria for what real AP scoring treats as 2-3 independent points, except where the guidelines are explicit that a step is all-or-nothing (implicit differentiation of the *whole* equation, topic 3.2, is scored as all-or-nothing for that one point — no partial credit for a partially correct differentiation).
- "Answers need not be simplified" — unsimplified but correct expressions earn full credit; do not write a criterion requiring a specific simplified form unless the prompt explicitly asks the student to simplify.
- Consistent/follow-through credit is real: if an earlier part's numeric answer is wrong, a later part that correctly *applies* that wrong number can still earn its own points (except for points explicitly gated on the correct earlier value).
- "Incorrect or unclear communication accompanying an otherwise correct step is treated as scratch work and is not scored" — a sign error in a linking sentence around an otherwise-correct computation does not cost the computation's point.

## Units 4-8 deep-tier detail (2026-08-08 addition)

Verified directly against the CED PDF (pages 77-160) plus the 2025 AB Scoring Guidelines, 2025/2026 released FRQs, and the Q1/Q2 sample-response-with-commentary booklets. As with Units 1-3, exclusion density is sparse compared to Biology/Chemistry — most of the real scope discipline here lives in scoring architecture (what specific reasoning structure earns a point) rather than boxed "do not assess" statements. Two genuine boxed exclusions do exist in this range (Unit 4's other-indeterminate-forms exclusion, Unit 8's arc-length BC-only flag) and are called out below.

### Cross-unit scoring conventions confirmed from the 2025 AB Scoring Guidelines (apply across Units 4-8, extending the Units 1-3 list above)

- The **local-vs-global justification split from Unit 5** (a correct-but-local argument earns the answer point but not the justification point) recurs by the same logic anywhere an FRQ asks "justify that this is a maximum/minimum" — including accumulation-function extrema (Unit 6/8 crossover, e.g. 2025 Q4 Part D).
- **Cross-part consistency/follow-through credit is explicit and named in the guidelines**, not just a general convention: values "imported from part C" or "restated from part B" are explicitly permitted to satisfy a later part's evaluation requirement, including when the imported value is itself wrong — confirmed across three separate 2025 items (Q1D, Q4D, Q5C). When authoring multi-part FRQs, a later part's criterion should allow a numerically-consistent-with-an-earlier-wrong-value answer to still earn credit, matching real AP practice.
- **"Incorrect or unclear communication between a correct setup and a correct final answer is treated as scratch work and is not scored"** — confirmed verbatim across multiple 2025 questions' scoring notes. A sign error or transcription slip strictly *between* an already-credited setup step and an already-credited answer does not cost either point.
- **The differential (`dx`, `dt`) is sometimes fully optional and sometimes load-bearing — it depends on the specific point being scored, not a blanket rule.** Confirmed both ways in real 2025 scoring: Unit 8's cross-section volume setup explicitly does not require the differential for its structural-form point ("the presence or absence of dx will not be considered"), while Unit 4/8's related-rates and reversed-difference-of-squares cases specifically require the differential present to resolve an otherwise-ambiguous expression into full credit. Do not write a universal "always require dx" or "never require dx" rule into a rubric — check the specific point being scored.

## Units 9-10 deep-tier detail (2026-08-08 addition)

Verified directly against the CED PDF (pages 163-195) plus the 2025 BC Scoring Guidelines, the BC-specific data in the 2025 Chief Reader Report (Questions BC2 and BC6), the 2025 BC Question 2 Sample Student Responses and Scoring Commentary booklet, and the 2025/2026 released BC FRQ booklets. Unlike the Units 4-8 pass — which used AB-domain FRQs, AB Scoring Guidelines, and AB sample-response booklets, since that content exists on both exams — this is the first genuinely **BC-specific-source** deep-tier pass in this fact pack: Units 9-10 have no AB counterpart, so every scoring-architecture claim below comes from a BC-only question. A striking pattern specific to these two units, confirmed by reading every topic's Essential Knowledge text directly: roughly half of Units 9-10's topics state only that a rectangular-coordinate method or concept "can be extended to" the parametric/polar/vector/series setting, without ever writing out the resulting formula in the CED's required-content text. This mirrors the Unit 7 Euler's-method gap already flagged in the Units 4-8 pass, but it recurs far more often here — flagged topic-by-topic below so authoring doesn't mistake "commonly taught" for "CED-mandated." One genuine boxed exclusion exists in this range (Topic 10.8's closed list of assessed convergence tests) and is quoted verbatim below.

### Cross-unit scoring conventions confirmed from the 2025 BC Scoring Guidelines and Chief Reader Report (Units 9-10, extending the Units 1-3/4-8 lists above)

- **The granular three-way integral-setup split documented for Unit 8's washer method (structural-form point, full-correct-integrand point, constant/limits/final-answer point) recurs identically for Unit 9's polar area** (2025 BC2 Part B) — this is a general AP Calc BC integral-setup scoring pattern, not specific to volume problems.
- **The Unit 5 local-vs-global justification split recurs identically in Unit 9's polar optimization** (2025 BC2 Part C): a response using only a local sign-change argument does not earn the justification point but remains eligible for the separate final-answer point.
- **Naming an appropriate convergence test is explicitly sufficient for full credit at interval-of-convergence endpoints** — the 2025 BC Scoring Guidelines state this directly for Question 6 Part A: "Naming of an appropriate test is sufficient for the analysis at each endpoint." A full symbolic execution of the named test is not required if the correct test name and the correct conclusion are both present.
- **Absolute value bars are optional in ratio-test setup notation**, confirmed as a real, documented scoring tolerance (BC6 CR report notes) as long as the response resolves to a symmetric interval — do not require absolute-value notation as a rubric criterion on its own.

## Authoring distribution guidance

Use the weighting ranges when assembling representative practice exams and prioritizing review. Do not use weighting to omit low-weight units from the content bank.

For AB, Units 5 and 6 are the largest targets. For BC, Units 6 and 10 are the largest targets, followed by Units 5 and 9.

Across a representative set, mix procedures with interpretation, representation changes, justification, and contextual reasoning. Preserve the official calculator split and include both contextual and noncontextual work.

All questions and scoring criteria must be independently authored from this scope brief. Do not expose official sample questions, released question wording, scoring text, or recognizable item structures to the authoring model.

## Change record from superseded fact pack

Corrected all AB/BC unit-weight ranges to the current PDF tables.

Completed Unit 10 through Topics 10.13-10.15 rather than relying on an extraction caveat.

Added mathematical-practice weightings, the exact calculator/time split, current unit-title aliases, and topic-level AB/BC scope controls.

Removed the implication that the earlier weighting table was current.

**2026-08-08:** Brought Units 1-3 to deep tier (see Source control and the "Units 1-3 deep-tier detail" section) — per-topic exclusion/boundary language, documented common misconceptions from the 2025 Chief Reader Report, and scoring conventions from the 2025 AB/BC Scoring Guidelines. Done to ground a new FRQ/MCQ authoring batch against real scoring signal rather than the topic-map-only version.

**2026-08-08 (same day, second pass):** Extended deep tier through Unit 8, completing AB's full CED scope (Units 1-8; Units 9-10 are BC-only and remain partial tier, and BC's own extension beyond Unit 8 has not been done). Used the 2025 AB Q1/Q2 Sample Student Responses and Scoring Commentary booklets as an additional source type beyond the CED and Scoring Guidelines. **Found and corrected one real defect in this pack**: arc length (Unit 8, topic 8.13) was previously listed as shared AB/BC — verified false against the CED (explicitly BC-only). Checked the live Production corpus for this specific error before fixing the claim; found no existing `apcalcab-*` arc-length item, so no live content defect resulted from it this time — but the pack itself was wrong and authoring/review guidance built on it would have been wrong too. Flagged Unit 7 (Differential Equations) as lower-confidence than the other four: no released AB FRQ with an official scoring guide covers slope fields/Euler's method/separation of variables in either 2025 or 2026 as of this update.

**2026-08-08 (same day, third pass):** Extended deep tier through Units 9-10, completing BC's full CED scope (Units 1-10 are now entirely deep tier). This was the first deep-tier pass in this fact pack to use genuinely BC-specific sources throughout — the BC Scoring Guidelines, the BC-specific data in the Chief Reader Report (Questions BC2 and BC6), and the BC Question 2 Sample Student Responses booklet — since Units 9-10 have no AB counterpart to lean on. **No topic-map naming errors were found**: all Unit 9/10 topic titles verified correct against the CED, unlike the prior pass's Unit 8 arc-length correction. **One previously uncaptured, boxed, verbatim CED exclusion was found and added**: Topic 10.8 closes BC's entire in-scope convergence-test list to exactly six named tests (nth term test, integral test, comparison test, limit comparison test, alternating series test, ratio test) and explicitly excludes other methods (e.g., the root test) from assessment — this had not been documented anywhere in this fact pack before. Also documented a real, striking pattern specific to Units 9-10: roughly half of these units' Essential Knowledge statements describe a method as merely "extended" from rectangular coordinates without the CED ever writing out the resulting formula (parametric arc length, vector-valued derivative/integral component form, rectangular-polar conversion, polar area, Lagrange error bound, and the Maclaurin series for sin/cos/e^x are all left unstated in the CED's required-content text) — flagged throughout the new section so authoring doesn't mistake commonly-taught notation for CED-mandated notation. Flagged Unit 9 Topics 9.1-9.6 (parametric/vector-valued) as lower-confidence than 9.7-9.9 (polar): no released BC FRQ in 2025 or 2026 tests parametric equations or vector-valued functions directly, while polar curves are well covered by both years' Question 2. Flagged Unit 10 Topics 10.14-10.15 similarly: the 2026 released FRQ (Question 6) tests Maclaurin series manipulation but has no released scoring guide yet as of this update. Found two of the lowest documented point-mean scores in this fact pack's research to date (BC2 Part C's global-justification point at 0.06/1, and BC6 Part A's endpoint-analysis point at 0.14/1) — both substantially lower than the previously-lowest-documented Unit 1 IVT point (≈0.27-0.28/1) — worth prioritizing for authoring/review calibration on polar-optimization and interval-of-convergence items respectively.

