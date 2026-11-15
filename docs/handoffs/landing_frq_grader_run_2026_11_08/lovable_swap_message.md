Swap the four demo grading payloads in src/components/marketing/FrqDemo.tsx for real grader output. Content-only change: no layout, styling, behaviour, test or other-file changes.

CONTEXT. The chemistry, physics, statistics and calculus sets in FrqDemo.tsx currently carry owner-written demo gradings. The same twelve student answers have now been graded by the real production grader (evaluate-attempt, model gpt-5.4-mini, prompt v1.0.0, run 2026-11-08 in the Development environment, which runs the identical function bundle as Production). Replace ONLY the `repair` object of each of those twelve entries with the grader's payload below. Keep every `topic`, `prompt` and `answer` string exactly as it is. Do not touch BIOLOGY_FRQS, FRQ_SETS, the component, or any other file.

RULES
- Paste each `repair` object verbatim. Do not rewrite, shorten, "improve" or reformat any text, and do not add a teaching_note where it is null. The whole point is that this is captured grader output.
- `teaching_note: null` is valid; the Repair component already renders it only when present.
- Order within each array stays as it is (the content_key comment above each array already lists the order).
- Replace the file-top JSDoc comment with exactly this text:
  Demo payloads conform to RepairPayloadSchema. The biology set is an owner-supplied demo grading written against the question's published rubric. The chemistry, physics, statistics and calculus sets are captured output of the production grader (evaluate-attempt, gpt-5.4-mini, prompt v1.0.0, graded 2026-11-08): point_summary = feedback_preview, criteria = criterion_results joined to frq_criteria learner_facing_text with the grader's decision_explanation and evidence_quote, missing_concept = first unearned criterion, next_fix = the grader's minimum_fix for its highest-value gap, teaching_note = null (the grader returns none). Do not edit the content.
- After editing, run the existing tests (`npm test` or the project's test command). If a test asserts on the old demo text or on a points total, update only that expectation to the new values below and tell me which test changed.

PAYLOADS (JSON, one per entry, in array order):


===== CHEMISTRY_FRQS =====

--- CHEMISTRY_FRQS[0]  (apchem-sfrq-024)  ->  replace its `repair` with:
{
  "points_earned": 3,
  "points_possible": 4,
  "point_summary": "You earned 3 of 4 points. You explained the temperature effect well and included the concentration effect. The missing idea is molecular orientation: not all collisions lead to reaction unless the particles collide in the proper orientation.",
  "criteria": [
    {
      "label": "Explains that increasing the concentration of a reactant increases the frequency of collisions between reactant particles per unit time, increasing the reaction rate.",
      "status": "earned",
      "evidence": "This explicitly states that increasing concentration increases collision frequency and increases the reaction rate. Quoted: “Higher concentration packs more reactant particles into the same volume, so collisions happen more frequently per second and the rate goes up.”"
    },
    {
      "label": "States that not every collision results in a reaction because reactant particles must also collide with the proper orientation for old bonds to break and new bonds to form.",
      "status": "missing",
      "evidence": "The response does not state that not every collision leads to reaction because particles must collide with the proper orientation for bonds to break and form."
    },
    {
      "label": "States that increasing temperature substantially increases the fraction of collisions that occur with kinetic energy equal to or greater than the activation energy, which is the primary reason rate increases sharply with temperature.",
      "status": "earned",
      "evidence": "This directly addresses the increase in the fraction of collisions with energy at least equal to the activation energy. Quoted: “a much larger fraction of the collisions have energy at or above the activation energy, so more collisions are successful.”"
    },
    {
      "label": "States that increasing temperature increases the average speed (kinetic energy) of the reactant particles, which modestly increases the frequency of collisions between particles.",
      "status": "earned",
      "evidence": "This states that higher temperature increases particle speed and collision frequency. Quoted: “Higher temperature makes the particles move faster, so they collide more often”"
    }
  ],
  "missing_concept": "States that not every collision results in a reaction because reactant particles must also collide with the proper orientation for old bonds to break and new bonds to form.",
  "next_fix": "Add that collisions must occur with the proper orientation for a reaction to happen, so not every collision is successful.",
  "teaching_note": null
}

--- CHEMISTRY_FRQS[1]  (apchem-sfrq-031)  ->  replace its `repair` with:
{
  "points_earned": 4,
  "points_possible": 4,
  "point_summary": "All four parts are correct: you identified the acid/base, conjugate pairs, and showed that water can act as a base in the reaction.",
  "criteria": [
    {
      "label": "Correctly identifies HSO4- as the Bronsted-Lowry acid (proton donor) and H2O as the Bronsted-Lowry base (proton acceptor) in the forward reaction.",
      "status": "earned",
      "evidence": "Correctly identifies HSO4⁻ as the acid and H2O as the base in the forward reaction. Quoted: “HSO4⁻ is the Brønsted-Lowry acid because it donates a proton; H2O is the base because it accepts the proton.”"
    },
    {
      "label": "Correctly identifies SO4^2- as the conjugate base of HSO4- and H3O+ as the conjugate acid of H2O.",
      "status": "earned",
      "evidence": "Correctly identifies both conjugate species required by the rubric. Quoted: “SO4²⁻ is the conjugate base of HSO4⁻ and H3O⁺ is the conjugate acid of H2O.”"
    },
    {
      "label": "Correctly names both conjugate acid-base pairs: HSO4-/SO4^2- and H3O+/H2O.",
      "status": "earned",
      "evidence": "Correctly names both conjugate acid-base pairs. Quoted: “The pairs are HSO4⁻ / SO4²⁻ and H2O / H3O⁺.”"
    },
    {
      "label": "Explains that water is amphiprotic, it can donate a proton to act as an acid or accept a proton to act as a base (as shown here), so it does not act as a base in every reaction, only when paired with a species that is a stronger acid than water.",
      "status": "earned",
      "evidence": "This explains why the claim is incorrect by showing water can act as a base in the given reaction. Quoted: “The claim is wrong because in this reaction water accepts a proton, so it is acting as a base.”"
    }
  ],
  "missing_concept": null,
  "next_fix": null,
  "teaching_note": null
}

--- CHEMISTRY_FRQS[2]  (apchem-sfrq-030)  ->  replace its `repair` with:
{
  "points_earned": 4,
  "points_possible": 4,
  "point_summary": "All four parts are correct: temperature increase shifts the exothermic equilibrium left and lowers K, decreasing volume shifts it right without changing K, and a catalyst does not change equilibrium position or K.",
  "criteria": [
    {
      "label": "Explains the temperature effect by treating the exothermic reaction as responding to added thermal energy; increasing temperature shifts left and decreases K.",
      "status": "earned",
      "evidence": "The response uses thermal-energy reasoning for the exothermic equilibrium, predicts a left shift with increased temperature, and states that K decreases. Quoted: “Raising the temperature adds thermal energy and the system shifts left, toward the reactants, to use it up. Because the temperature changed, K itself decreases.”"
    },
    {
      "label": "For a closed container with a movable piston at constant temperature, decreasing volume shifts equilibrium right because the product side has fewer gas moles, but K is unchanged.",
      "status": "earned",
      "evidence": "The response explicitly assumes constant temperature, predicts a right shift for compression based on fewer gas moles on the product side, and states that K is unchanged. Quoted: “At constant temperature, decreasing the volume raises the pressure. The system shifts right toward NH3 because there are 2 moles of gas on the right and 4 on the left. K does not change, because only a temperature change changes K.”"
    },
    {
      "label": "Explains that the volume/pressure change alters the equilibrium position but does not change the value of K, since K is only affected by a change in temperature.",
      "status": "earned",
      "evidence": "The response clearly states that the volume/pressure change does not change K and identifies temperature as the only factor that changes K. Quoted: “K does not change, because only a temperature change changes K.”"
    },
    {
      "label": "States that adding a catalyst does not shift the equilibrium position and does not change K; it only increases the rate at which equilibrium is reached by speeding up the forward and reverse reactions equally.",
      "status": "earned",
      "evidence": "The response states that a catalyst does not shift equilibrium, does not change K, and only increases the rate of reaching equilibrium by speeding both directions equally. Quoted: “A catalyst speeds up the forward and reverse reactions equally, so the position of equilibrium and K are both unchanged; equilibrium is just reached faster.”"
    }
  ],
  "missing_concept": null,
  "next_fix": null,
  "teaching_note": null
}

===== PHYSICS_FRQS =====

--- PHYSICS_FRQS[0]  (apphy1-frq-024)  ->  replace its `repair` with:
{
  "points_earned": 2,
  "points_possible": 3,
  "point_summary": "You earned credit for the center-of-mass claim and for equal-and-opposite momentum changes. To get the last point, explicitly compare the velocity changes using the carts’ masses and show the lighter cart’s change is twice as large.",
  "criteria": [
    {
      "label": "States that the center-of-mass velocity remains constant, explaining that because no external horizontal force acts on the two-cart system, the spring force is purely internal, so total system momentum (and therefore center-of-mass velocity) is conserved.",
      "status": "earned",
      "evidence": "The response states that the center-of-mass velocity remains constant and justifies it by identifying the spring force as internal and the system momentum as conserved. Quoted: “The center-of-mass velocity stays the same. The spring force is internal to the two-cart system, so the system's momentum is conserved and the center of mass keeps moving exactly as it was.”"
    },
    {
      "label": "States that the carts receive equal-magnitude opposite momentum changes.",
      "status": "earned",
      "evidence": "This directly states the equal-magnitude, opposite momentum changes required by the rubric. Quoted: “Momentum is conserved, so the two carts receive equal and opposite changes in momentum.”"
    },
    {
      "label": "States that the lighter cart has twice the magnitude of velocity change.",
      "status": "missing",
      "evidence": "The response indicates the lighter cart has a larger speed, but it does not state that the lighter cart's velocity change is twice the magnitude of the heavier cart's change, as required. Quoted: “The lighter cart ends up moving faster.”"
    }
  ],
  "missing_concept": "States that the lighter cart has twice the magnitude of velocity change.",
  "next_fix": "Relate the velocity changes to momentum using Δp = mΔv and the 2:1 mass ratio to show the lighter cart's velocity change is twice as large.",
  "teaching_note": null
}

--- PHYSICS_FRQS[1]  (apphy1-frq-053)  ->  replace its `repair` with:
{
  "points_earned": 5,
  "points_possible": 5,
  "point_summary": "All parts are correct. You identified the independent variable, dependent variable, and a valid control, and you derived the correct friction expression with the correct mass-cancellation reasoning.",
  "criteria": [
    {
      "label": "Identifies any scientifically appropriate control variable held constant across trials (e.g., the same block, surface material, surface condition, or incline level).",
      "status": "earned",
      "evidence": "This is a scientifically appropriate control variable and matches the rubric's accepted examples. Quoted: “use the same block on the same surface for every trial”"
    },
    {
      "label": "Identifies the stopping distance as the dependent variable.",
      "status": "earned",
      "evidence": "The stopping distance is correctly identified as the dependent variable. Quoted: “Dependent variable: the distance it slides before stopping”"
    },
    {
      "label": "Identifies the block's initial speed as the independent variable.",
      "status": "earned",
      "evidence": "The initial speed is correctly identified as the independent variable. Quoted: “Independent variable: the initial speed of the block”"
    },
    {
      "label": "Derives μk = v0²/(2gd) by setting the initial kinetic energy equal to the work done by friction.",
      "status": "earned",
      "evidence": "The student sets initial kinetic energy equal to the work done by friction and derives the required expression for μk. Quoted: “½·m·v0² = μk·m·g·d, so μk = v0² / (2·g·d)”"
    },
    {
      "label": "Explains that mass cancels from both sides of the energy equation (kinetic energy and friction work are both proportional to mass), so μk can be found without knowing the block's mass.",
      "status": "earned",
      "evidence": "The equation shows mass on both sides and the final expression for μk has no mass term, which reflects the cancellation of mass in the derivation. Quoted: “½·m·v0² = μk·m·g·d, so μk = v0² / (2·g·d)”"
    }
  ],
  "missing_concept": null,
  "next_fix": null,
  "teaching_note": null
}

--- PHYSICS_FRQS[2]  (apphy1-frq-031)  ->  replace its `repair` with:
{
  "points_earned": 3,
  "points_possible": 3,
  "point_summary": "All three rubric points are earned: correct prediction, correct rotational-inertia explanation, and correct speed comparison with the rolling-energy equation.",
  "criteria": [
    {
      "label": "Predicts that the solid sphere arrives first.",
      "status": "earned",
      "evidence": "The student correctly predicts the solid sphere arrives first, which matches the rubric. Quoted: “The solid sphere reaches the bottom first.”"
    },
    {
      "label": "Explains that less energy is required for rotation at a given translational speed, producing greater acceleration.",
      "status": "earned",
      "evidence": "The response links the smaller rotational inertia to less energy going into rotation and greater acceleration, satisfying the reasoning requirement. Quoted: “Its rotational inertia, (2/5)MR², is smaller than the shell's, (2/3)MR², so at any given translational speed a smaller share of its energy is tied up in rotation. More of the gravitational energy goes into translation, so it accelerates faster down the incline.”"
    },
    {
      "label": "States that the solid sphere has the greater final translational speed and supports it with v²=2gh/[1+I/(MR²)].",
      "status": "earned",
      "evidence": "The student states the solid sphere has the greater final translational speed and supports it with the required rolling-energy expression. Quoted: “v² = 2gh / [1 + I/(MR²)]. The solid sphere has the smaller I/(MR²), so it has the greater translational speed at the bottom for the same drop.”"
    }
  ],
  "missing_concept": null,
  "next_fix": null,
  "teaching_note": null
}

===== STATISTICS_FRQS =====

--- STATISTICS_FRQS[0]  (APSTATS-SFRQ-002)  ->  replace its `repair` with:
{
  "points_earned": 4,
  "points_possible": 4,
  "point_summary": "Full credit. You correctly computed both z-scores, identified Quiz B as the better relative performance, and explained that z-scores allow comparison across quizzes.",
  "criteria": [
    {
      "label": "Computes the z-score for both quizzes.",
      "status": "earned",
      "evidence": "The student correctly computed both z-scores: 1.5 for Quiz A and 2.5 for Quiz B. Quoted: “(a) z = (86 − 74) / 8 = 1.5. (b) z = (62 − 52) / 4 = 2.5.”"
    },
    {
      "label": "States that the student performed better relative to the class on Quiz B.",
      "status": "earned",
      "evidence": "This correctly states that the student's performance was better relative to the class on Quiz B. Quoted: “The student did better on Quiz B, because 2.5 > 1.5.”"
    },
    {
      "label": "Explains that z-scores place scores on a common scale measured in standard deviations from the mean.",
      "status": "earned",
      "evidence": "This explains that z-scores provide a common basis for comparison across different quizzes. Quoted: “z-scores let you compare scores from different quizzes.”"
    }
  ],
  "missing_concept": null,
  "next_fix": null,
  "teaching_note": null
}

--- STATISTICS_FRQS[1]  (APSTATS-SFRQ-005)  ->  replace its `repair` with:
{
  "points_earned": 3,
  "points_possible": 4,
  "point_summary": "You earned 3 of 4 points. Your only missing point is part (c): you need to describe sampling all students by putting them in a list and randomly choosing 50 from that list.",
  "criteria": [
    {
      "label": "Identifies the method as a convenience sample or voluntary response sample.",
      "status": "earned",
      "evidence": "Correctly identifies the method as a convenience sample. Quoted: “This is a convenience sample.”"
    },
    {
      "label": "Describes undercoverage or self-selection bias from only surveying students at lunch who agree to respond.",
      "status": "earned",
      "evidence": "Describes undercoverage from surveying only students at lunch and those who agree to respond. Quoted: “Students who eat lunch somewhere else never get asked, so the sample underrepresents them.”"
    },
    {
      "label": "Explains that all students should be put in a list and 50 should be chosen randomly.",
      "status": "missing",
      "evidence": "This suggests some random selection, but it does not explain that all students should be put in a list and that 50 should be randomly chosen from that full list. Quoted: “Pick students at random from the hallway at different times of day.”"
    },
    {
      "label": "Explains that the sample may not represent the whole student body because of the selection method.",
      "status": "earned",
      "evidence": "Explains that the sample may not represent the whole student body because of the selection method. Quoted: “Because the sample was not chosen randomly it might not represent all students.”"
    }
  ],
  "missing_concept": "Explains that all students should be put in a list and 50 should be chosen randomly.",
  "next_fix": "Explain that all students should be placed in a list and that 50 students should be chosen randomly from that list.",
  "teaching_note": null
}

--- STATISTICS_FRQS[2]  (APSTATS-SFRQ-011)  ->  replace its `repair` with:
{
  "points_earned": 3,
  "points_possible": 4,
  "point_summary": "You earned full credit for (a) and (b). In (c), you need to interpret the interval as values for the true population proportion, not as a statement about 95% of students.",
  "criteria": [
    {
      "label": "Identifies the parameter and computes the point estimate.",
      "status": "earned",
      "evidence": "The response identifies the parameter as the proportion of all students who support a later start time and correctly computes the point estimate 84/120 = 0.70. Quoted: “The parameter is p, the proportion of all students at the school who support a later start time. p̂ = 84/120 = 0.70.”"
    },
    {
      "label": "Checks conditions and computes the confidence interval.",
      "status": "earned",
      "evidence": "The response checks the needed conditions, including success-failure using 84 and 36, and computes the one-proportion z-interval correctly as approximately (0.618, 0.782). Quoted: “Random: we have to assume the 120 students were a random sample. 10%: 120 is less than 10% of all students. Large counts: 84 successes and 36 failures are both at least 10. (c) 0.70 ± 1.96 × √(0.70 × 0.30 / 120) = 0.70 ± 0.082, so the interval is (0.618, 0.782).”"
    },
    {
      "label": "Interprets the interval as a range of plausible values for the true population proportion of supportive students.",
      "status": "missing",
      "evidence": "This does not clearly interpret the interval as a range of plausible values for the true population proportion. It instead says about 95% of students fall in the range, which is not the requested interpretation. Quoted: “We are 95% confident that between 61.8% and 78.2% of students support a later start time, so about 95% of students fall in that range.”"
    }
  ],
  "missing_concept": "Interprets the interval as a range of plausible values for the true population proportion of supportive students.",
  "next_fix": "Interpret the interval as plausible values for the true proportion of all students who support a later start time.",
  "teaching_note": null
}

===== CALCULUS_FRQS =====

--- CALCULUS_FRQS[0]  (apcalcab-frq-u1n-004)  ->  replace its `repair` with:
{
  "points_earned": 3,
  "points_possible": 4,
  "point_summary": "You earned full credit on parts (a) and (b). On part (c), you correctly showed the one-sided limits and that the function is not continuous, but you need to name the discontinuity as a jump discontinuity.",
  "criteria": [
    {
      "label": "Factors and cancels to find lim(x->1+) f(x) = 4.",
      "status": "earned",
      "evidence": "The response factors the numerator, cancels (x−1), and evaluates the resulting expression at x=1 to get 4. Quoted: “(x² + 2x − 3)/(x − 1) = (x + 3)(x − 1)/(x − 1) = x + 3, so lim(x→1⁺) f(x) = 4.”"
    },
    {
      "label": "Sets the left-hand limit equal to the right-hand limit and finds k = 2.",
      "status": "earned",
      "evidence": "The response sets the one-sided expressions equal and solves correctly for k = 2. Quoted: “For continuity the left-hand limit must equal the right-hand limit: k(1) + 2 = 4, so k = 2.”"
    },
    {
      "label": "Sets m equal to the limit and finds m = 4, citing the three conditions of continuity.",
      "status": "earned",
      "evidence": "The response correctly states that the function value at x=1 must equal the limit and gives m = 4. Quoted: “Then f(1) = m must equal the limit, so m = 4.”"
    },
    {
      "label": "Finds the one-sided limits 5 and 4, concludes f is not continuous, and classifies it as a jump discontinuity.",
      "status": "missing",
      "evidence": "The response finds the two one-sided limits and concludes the function is not continuous, but it does not classify the discontinuity as a jump discontinuity, which is required by the rubric. Quoted: “the left-hand limit is 3 + 2 = 5 and the right-hand limit is 4, so the limit does not exist and f is not continuous at x = 1.”"
    }
  ],
  "missing_concept": "Finds the one-sided limits 5 and 4, concludes f is not continuous, and classifies it as a jump discontinuity.",
  "next_fix": "Add the discontinuity type: since the one-sided limits are 5 and 4, state that f has a jump discontinuity at x=1.",
  "teaching_note": null
}

--- CALCULUS_FRQS[1]  (apcalcab-frq-002)  ->  replace its `repair` with:
{
  "points_earned": 6,
  "points_possible": 9,
  "point_summary": "Parts (a) and (c) are correct. In part (b), you need to say that the information does not prove exactly two zeros, because IVT only guarantees at least one zero in each interval, not that there are only two.",
  "criteria": [
    {
      "label": "There is at least one zero in each interval because the endpoint values change sign.",
      "status": "earned",
      "evidence": "The response correctly uses continuity, identifies sign changes on both intervals, and concludes that at least one zero is guaranteed in each interval. Quoted: “q is continuous, q(0) = 3 > 0 and q(2) = −1 < 0, so by the IVT there is at least one zero in (0, 2). Likewise q(2) = −1 < 0 and q(5) = 4 > 0, so there is at least one zero in (2, 5).”"
    },
    {
      "label": "No; continuity guarantees existence but not uniqueness, so additional crossings are possible.",
      "status": "missing",
      "evidence": "The rubric requires the conclusion that the given information does not establish exactly two zeros, because IVT guarantees existence but not uniqueness and additional crossings are possible. The student gives the opposite conclusion and does not address non-uniqueness. Quoted: “(b) Yes. There are exactly two zeros, one in each interval.”"
    },
    {
      "label": "Strict monotonicity on each interval, with the stated sign changes, would give uniqueness.",
      "status": "earned",
      "evidence": "The student proposes strict monotonicity on each interval and states that this would give exactly one zero in each interval, which leads to exactly two zeros total. Quoted: “If q were strictly increasing or strictly decreasing on each interval, there would be exactly one zero in each.”"
    }
  ],
  "missing_concept": "No; continuity guarantees existence but not uniqueness, so additional crossings are possible.",
  "next_fix": "State that the information is not enough to prove exactly two zeros, because continuity and the IVT guarantee existence but not uniqueness; additional zeros could occur within an interval.",
  "teaching_note": null
}

--- CALCULUS_FRQS[2]  (apcalcab-frq-001)  ->  replace its `repair` with:
{
  "points_earned": 8,
  "points_possible": 9,
  "point_summary": "You earned full credit on parts (a) and (c). In part (b), you correctly used continuity and found k=4, but you did not explicitly show that the simplified expression also gives 4 at x=2.",
  "criteria": [
    {
      "label": "The limit is 4 after factoring x²−4=(x−2)(x+2).",
      "status": "earned",
      "evidence": "The response shows the factoring, simplification to x+2, and evaluates the limit as 4. Quoted: “(a) g(x) = (x − 2)(x + 2)/(x − 2) = x + 2 for x ≠ 2, so lim(x→2) g(x) = 4.”"
    },
    {
      "label": "k=4 because continuity requires the function value to equal the limit.",
      "status": "missing",
      "evidence": "The response states the continuity condition and sets k=4, but it does not explicitly confirm that this value matches the simplified expression evaluated at x=2. Quoted: “(b) g is continuous at 2 when the function value equals the limit, so k = 4.”"
    },
    {
      "label": "Yes; the filled function equals x+2, so g′(2)=1.",
      "status": "earned",
      "evidence": "The response identifies the filled function as x+2, concludes differentiability at x=2, and computes the derivative as 1. Quoted: “(c) Yes. With k = 4, g(x) = x + 2 for every x, which is a line with slope 1, so g is differentiable at 2 and g′(2) = 1.”"
    }
  ],
  "missing_concept": "k=4 because continuity requires the function value to equal the limit.",
  "next_fix": "Add the missing check that the simplified expression x+2 gives 4 at x=2, so g(2)=4 matches the limit.",
  "teaching_note": null
}


EXPECTED TOTALS AFTER THE SWAP (for your self-check): chemistry 3/4, 4/4, 4/4; physics 2/3, 5/5, 3/3; statistics 4/4, 3/4, 3/4; calculus 3/4, 6/9, 8/9. Criterion status counts across the twelve: 36 earned, 7 missing, 0 partial.

Reply with: the list of files changed (should be FrqDemo.tsx only, plus at most one test file), the test result, and a confirmation that no topic/prompt/answer string changed.