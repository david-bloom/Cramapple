# Fact-pack excerpt (paraphrase; the CED governs)

### Unit 3 - Differentiation: Composite, Implicit, and Inverse Functions

3.1 The Chain Rule; 3.2 Implicit Differentiation; 3.3 Differentiating Inverse Functions; 3.4 Differentiating Inverse Trigonometric Functions; 3.5 Selecting Procedures for Calculating Derivatives; 3.6 Calculating Higher-Order Derivatives.


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

