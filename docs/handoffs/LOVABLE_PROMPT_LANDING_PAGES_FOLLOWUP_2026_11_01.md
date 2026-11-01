# Lovable prompt — landing pages follow-up (2026-11-01)

**Status:** sent to Lovable marketing project `61dd6602-6991-4561-b418-e988bb7c8a0b` on 2026-11-01 (result recorded at the end of this file).
**Owner:** David Bloom. **Builds on:** `LOVABLE_PROMPT_LANDING_PAGES_CONVERSION_2026_10_31.md` (commit `695ec382`, unpublished).
**David's asks (2026-11-01):** (1) on phones, Prev/Next for the image block at the top and the bottom; (2) `/ap-calculus-prep` must say it covers Calculus AB, BC and Precalculus, `/ap-physics-prep` all four physics courses; (3) FRQ demo content and images must match the page's subject; (4) the home-page product image must match the subject, as a slideshow.

## Provenance of what this prompt supplies

- **Product screenshots (12 PNGs, `landing_product_shots_2026_11_01/`)** are real `/question` pages from the live app. They were
  captured by calling Production's `public.get_question_experience` for David's own graded sessions (one per subject: Biology
  Topic 3.2, Chemistry 1.2, Physics C E&M 8.6, Calculus AB 2.1, Precalculus 2.15; Statistics is the app's existing 1.5 fixture)
  and rendering them through the local app harness (`.worktrees/cramapple-app`, `/dev-qx-harness?state=<subject>`) at app
  commit `bfd5718` (Lovable app HEAD on 2026-11-01) with headless Chrome at 1920×1403. The phone variant is a 408×1163 crop of the
  answer-key column, the same treatment as the existing `bio-answer-key-mobile.webp`. No Physics 1 graded session exists in
  Production, so the physics capture is Physics C: E&M and is labelled as such.
- **FRQ demo content for Chemistry, Physics 1, Statistics and Calculus AB** uses published Cramapple questions verbatim
  (stimulus, parts and rubric criteria from `app.content_item_versions` / `app.frq_criteria`, content keys given inline). The
  student answers and the criterion-by-criterion gradings were **written by Claude against each question's published rubric**;
  they are not captured grader output. Production has no graded FRQ attempts outside Statistics (6, pre-`/question`) and no
  photo attachments at all, so there was nothing real to capture. The prompt tells Lovable to say so in the component comment.
  Replacing these with real grader runs is listed under "After this lands".
- **Catalog counts** follow the definition already on the page (items with `status = 'published'`, Production 2026-11-01):
  the per-course figures below sum to the existing "2,499 multiple-choice and 761 free-response" line.

## Prompt as sent

<!-- PROMPT_START -->
Follow-up to the landing-page change (commit 695ec382). Four changes to `/`, `/ap-biology-prep`, `/ap-statistics-prep`, `/ap-chemistry-prep`, `/ap-physics-prep`, `/ap-calculus-prep` and, where noted, `/ap-stem-prep`. Do not touch anything under `src/components/checkout`, `src/lib/trial-checkout.ts`, `src/lib/purchase-*.ts`, `src/lib/attribution.ts`, or any price. Keep the zero-motion rule: no autoplay, no slide transitions, no animation. Twelve PNG files are attached; section 4 says where they go.

## 1. Prev / Next controls above AND below the examples

In `src/components/marketing/FrqDemo.tsx` the "← Prev · n / 4 · Next →" row sits only under the cards. On a phone the three stacked cards are taller than the screen, so a student who wants the next example has to scroll to the bottom first. Render the same control row twice: once directly under the section title (above the cards) and once below them, at every width. Both rows drive the same index. Keep the 42px minimum targets and the aria-labels; give the region an id and point both rows' buttons at it with `aria-controls`. The product showcase in section 4 uses the same pattern.

## 2. Say what the Calculus and Physics pages cover

Today the only hint is a parenthesis in proof line 01.

a. **Course strip in the hero**, directly under the eyebrow, on both pages. One line, small uppercase, middle dots, wraps on phones:
   - `/ap-calculus-prep`: `COVERS AP CALCULUS AB · AP CALCULUS BC · AP PRECALCULUS`
   - `/ap-physics-prep`: `COVERS AP PHYSICS 1 · AP PHYSICS 2 · AP PHYSICS C: MECHANICS · AP PHYSICS C: E&M`

b. **Proof line 01** (`PROOF_LINES` in `src/lib/landing.ts`) becomes a per-course breakdown on these two pages. Exact figures (published items in Production, 2026-11-01; they sum to the existing 2,499 / 761 line):
   - `physics`: `AP Physics 1: 176 multiple-choice and 69 free-response · Physics 2: 95 and 51 · Physics C Mechanics: 196 and 53 · Physics C E&M: 109 and 59`
   - `calculus`: `AP Calculus AB: 357 multiple-choice and 93 free-response · Calculus BC: 353 and 78 · Precalculus: 315 and 88`
   Leave biology, statistics, chemistry and default as they are (they already match).

c. **Subject chooser** (`CHOOSER_SUBJECTS`): replace the single "AP Physics" entry with four entries, in this order and with these checkout keys, all linking to the `/ap-physics` hub for study guides: `AP Physics 1` → `ap-physics-1`, `AP Physics 2` → `ap-physics-2`, `AP Physics C: Mechanics` → `ap-physics-c-mechanics`, `AP Physics C: E&M` → `ap-physics-c-em`. Final list order: Biology, Chemistry, Physics 1, Physics 2, Physics C: Mechanics, Physics C: E&M, Calculus AB, Calculus BC, Precalculus, Statistics. These ten slugs are exactly checkout's `ACTIVE_PURCHASE_SUBJECTS`, and `resolvePurchaseSubject` accepts each of them, so `/checkout?subjects=<key>` works unchanged. The `/ap-stem-prep` chooser picks up the same list.

d. **`/ap-physics-prep` behaves like the calculus page:** in `src/lib/prep-pages.ts` drop `checkoutKey` from `physics` and give it `highlight: ["ap-physics-1", "ap-physics-2", "ap-physics-c-mechanics", "ap-physics-c-em"]`, so the hero and pricing CTAs go to `/checkout` (the student picks the course there) and all four physics rows are pre-highlighted in the chooser. Update `prepHead` descriptions: physics → "Know exactly what earns the point on every AP Physics question: Physics 1, Physics 2 and both Physics C courses. 7-day free trial, then $39.99 one-time per course."; calculus → "Know exactly what earns the point on every AP Calculus AB, Calculus BC and Precalculus question. 7-day free trial, then $39.99 one-time per course."

e. On these two pages the single price card's note reads `one-time, per course` instead of `one-time`.

## 3. The FRQ demo must match the page's subject

`FrqDemo` is hard-coded to four AP Biology examples, a biology hand-drawn photo and the label `AP BIOLOGY · …`. Key the examples by subject and pass the page's subject in from `Homepage`:
- `biology` and `/` (no subject): the existing four examples, unchanged.
- `chemistry`, `physics`, `statistics`, `calculus`: the three examples below, typed answers only. No hand-drawn example on those pages (we have no graded photo in those subjects yet; proof line 03 stays). The card label reads `AP CHEMISTRY · <TOPIC>`, `AP PHYSICS 1 · <TOPIC>`, `AP STATISTICS · <TOPIC>`, `AP CALCULUS AB · <TOPIC>`.
- Replace the comment at the top of `FrqDemo.tsx` with: "Demo payloads conform to RepairPayloadSchema. The biology set and the sets below are owner-supplied demo gradings written against each question's published rubric; they are not captured grader output. Do not edit the content."
- The counter reads `n / 3` on those pages.

Content, verbatim. Each example gives: topic, prompt (stimulus first, then the parts), the submitted answer, and the repair payload fields in the schema's order.

### Chemistry (content keys apchem-sfrq-024, apchem-sfrq-031, apchem-sfrq-030)

**C1 · topic: "Collision theory"**
prompt: "A student observes that a gas-phase reaction proceeds noticeably faster when the temperature of the reaction vessel is increased, and also proceeds faster when the initial concentration of a reactant is increased. Using collision theory, explain why increasing the temperature increases the reaction rate and why increasing the initial concentration of a reactant increases the reaction rate. In your response, address collision frequency, the fraction of collisions with energy at least equal to the activation energy, and the role of molecular orientation."
answer: "Higher temperature makes the particles move faster, so they collide more often, and a much larger fraction of the collisions have energy at or above the activation energy, so more collisions are successful. Higher concentration packs more reactant particles into the same volume, so collisions happen more frequently per second and the rate goes up."
points_earned 3, points_possible 4
point_summary: "Both rate effects are explained through collision frequency and the activation-energy fraction, but the response never mentions orientation, so one of the three collision-theory requirements is absent."
criteria:
- "Concentration raises collision frequency" · earned · "More reactant particles in the same volume, so collisions happen more frequently per second."
- "Temperature raises collision frequency" · earned · "Particles move faster, so they collide more often."
- "Temperature raises the fraction at or above Ea" · earned · "A much larger fraction of the collisions have energy at or above the activation energy."
- "Orientation requirement" · missing · "The prompt asks for the role of molecular orientation; the response does not mention it."
missing_concept: "Orientation: a collision with enough energy still fails unless the particles meet in the orientation that lets the old bonds break and the new bonds form."
next_fix: "Not every collision reacts: the particles must also collide in the correct orientation for old bonds to break and new bonds to form, so only energetic, properly oriented collisions are effective."
teaching_note: "Collision-theory FRQs score three ideas separately: frequency, energy fraction, orientation. Naming two of the three leaves a point on the table."

**C2 · topic: "Acids and bases"**
prompt: "Answer the following about the acid-base reaction below. HSO4⁻(aq) + H2O(l) ⇌ SO4²⁻(aq) + H3O⁺(aq). (a) Identify the Brønsted-Lowry acid and the Brønsted-Lowry base among the reactants. (b) Identify the conjugate base of HSO4⁻ and the conjugate acid of H2O as they appear among the products. (c) Identify the two conjugate acid-base pairs in this reaction. (d) A student claims that H2O can never act as a base. Using this reaction (or a different one), explain why this claim is incorrect."
answer: "(a) HSO4⁻ is the Brønsted-Lowry acid because it donates a proton; H2O is the base because it accepts the proton. (b) SO4²⁻ is the conjugate base of HSO4⁻ and H3O⁺ is the conjugate acid of H2O. (c) The pairs are HSO4⁻ / SO4²⁻ and H2O / H3O⁺. (d) The claim is wrong because in this reaction water accepts a proton, so it is acting as a base."
points_earned 3, points_possible 4
point_summary: "Parts (a) to (c) are complete and correct. Part (d) gives a counterexample but never explains why water can play either role, so the principle the rubric scores is missing."
criteria:
- "Acid and base among the reactants" · earned · "HSO4⁻ named as the proton donor, H2O as the proton acceptor."
- "Conjugate base and conjugate acid" · earned · "SO4²⁻ and H3O⁺ identified correctly."
- "Both conjugate pairs" · earned · "HSO4⁻ / SO4²⁻ and H2O / H3O⁺."
- "Why water can act as a base" · missing · "States that water accepts a proton here, but does not explain that water is amphiprotic and that its role depends on the other species."
missing_concept: "Amphiprotic behaviour: water's role depends on its partner. It accepts a proton from a stronger acid like HSO4⁻ and donates one to a stronger base like NH3."
next_fix: "Water is amphiprotic. Here it accepts a proton from HSO4⁻ and acts as a base; with NH3 it donates a proton and acts as an acid. Its role depends on whether the other species is a stronger acid or a stronger base than water."
teaching_note: "A counterexample earns the point only when it is explained; the rubric wants the principle (amphiprotic) plus the condition (relative strength)."

**C3 · topic: "Equilibrium"**
prompt: "Consider the exothermic reaction N2(g) + 3H2(g) ⇌ 2NH3(g), ΔH = −92 kJ/mol, at equilibrium in a closed container fitted with a movable piston. A student also proposes adding a catalyst to the system. For each change below, predict and justify the effect on the equilibrium position and state whether the value of K changes: (i) increase the temperature; (ii) decrease the container volume; (iii) add a catalyst. Use added-thermal-energy language for the temperature change in this exothermic equilibrium."
answer: "(i) The reaction is exothermic, so thermal energy behaves like a product. Raising the temperature adds thermal energy and the system shifts left, toward the reactants, to use it up. Because the temperature changed, K itself decreases. (ii) At constant temperature, decreasing the volume raises the pressure. The system shifts right toward NH3 because there are 2 moles of gas on the right and 4 on the left. K does not change, because only a temperature change changes K. (iii) A catalyst speeds up the forward and reverse reactions equally, so the position of equilibrium and K are both unchanged; equilibrium is just reached faster."
points_earned 4, points_possible 4
point_summary: "Full credit. Each change is answered twice over, as the rubric requires: which way the position shifts, and whether K changes, with the exothermic case argued in added-thermal-energy terms."
criteria:
- "Temperature, in added-thermal-energy terms" · earned · "Thermal energy treated as a product; shift left; K decreases."
- "Volume decrease at constant temperature" · earned · "Shift right because 2 moles of gas versus 4; constant temperature stated."
- "K unchanged by the volume change" · earned · "Only a temperature change changes K."
- "Catalyst" · earned · "Forward and reverse rates rise equally; position and K unchanged; equilibrium reached faster."
missing_concept: null
next_fix: "Try the next step: predict what happens to the rate of NH3 formation in the instant after the compression, and explain why that is a different question from where the equilibrium ends up."
teaching_note: "Full-credit equilibrium answers separate two questions every time: which way does the position shift, and does K change."

### Physics 1 (content keys apphy1-frq-024, apphy1-frq-053, apphy1-frq-031)

**P1 · topic: "Momentum and center of mass"**
prompt: "Two carts initially move together on a nearly frictionless track. A compressed spring between them is released, pushing them apart without any external horizontal force. (a) Predict how the center-of-mass velocity changes during the separation and justify your prediction. (b) If one cart has twice the mass of the other, compare the magnitudes of their momentum changes and velocity changes."
answer: "(a) The center-of-mass velocity stays the same. The spring force is internal to the two-cart system, so the system's momentum is conserved and the center of mass keeps moving exactly as it was. (b) Momentum is conserved, so the two carts receive equal and opposite changes in momentum. The lighter cart ends up moving faster."
points_earned 2, points_possible 3
point_summary: "The center-of-mass argument and the equal-and-opposite momentum changes are both earned. The velocity comparison stops at 'faster' and never gives the factor of two the rubric asks for."
criteria:
- "Center-of-mass velocity constant, justified" · earned · "Spring force identified as internal; momentum conserved; center of mass unchanged."
- "Equal-magnitude opposite momentum changes" · earned · "Equal and opposite changes in momentum."
- "Lighter cart has twice the velocity change" · missing · "Says the lighter cart moves faster; does not state that its velocity change is twice as large."
missing_concept: "The quantitative link Δv = Δp / m: equal momentum changes mean the velocity change scales inversely with mass, so half the mass gives twice the velocity change."
next_fix: "Because Δp is the same size for both carts and Δv = Δp / m, the cart with half the mass has twice the magnitude of velocity change."
teaching_note: "'Faster' is a direction; the rubric wants the factor. When masses are given as a ratio, give the velocity ratio."

**P2 · topic: "Designing a friction experiment"**
prompt: "A student wants to determine the coefficient of kinetic friction between a block and a horizontal surface by giving the block an initial push and measuring how far it slides before stopping. The push ends before the block begins the measured sliding interval, and the coefficient of kinetic friction remains constant during the slide. (a) Design the experiment: identify the independent variable, the dependent variable, and one variable to hold constant as a control. (b) Derive an expression for the coefficient of kinetic friction in terms of the initial speed and stopping distance using the work-energy theorem, and explain why the block's mass does not need to be known."
answer: "(a) Independent variable: the initial speed of the block. Dependent variable: the distance it slides before stopping. Control: use the same block on the same surface for every trial. (b) Friction does work −μk·m·g·d on the block, and that work removes all of its kinetic energy: ½·m·v0² = μk·m·g·d, so μk = v0² / (2·g·d)."
points_earned 4, points_possible 5
point_summary: "The design is complete and the derivation is correct. The prompt also asks why the mass is not needed, and the response cancels m without ever saying so."
criteria:
- "Independent variable" · earned · "Initial speed of the block."
- "Dependent variable" · earned · "Stopping distance."
- "A control variable" · earned · "Same block, same surface, every trial."
- "Derivation of μk = v0² / (2gd)" · earned · "Sets ½mv0² equal to μk·m·g·d and solves."
- "Why mass is not needed" · missing · "Mass cancels in the algebra but the response never explains that both terms are proportional to m."
missing_concept: "Why mass drops out: the kinetic energy and the friction work are both proportional to m, so m cancels and μk depends only on v0, g and d."
next_fix: "The mass appears on both sides of ½mv0² = μk·m·g·d, so it cancels; μk = v0² / (2gd) can be found without weighing the block."
teaching_note: "When a prompt says 'explain why X is not needed', the explanation is its own point, even after a correct derivation that silently cancels X."

**P3 · topic: "Rolling without slipping"**
prompt: "A solid sphere and a thin spherical shell have equal mass and radius and roll without slipping from rest down the same incline. (a) Predict which reaches the bottom first and justify using rotational inertia. (b) Compare their final translational speeds for the same vertical drop."
answer: "(a) The solid sphere reaches the bottom first. Its rotational inertia, (2/5)MR², is smaller than the shell's, (2/3)MR², so at any given translational speed a smaller share of its energy is tied up in rotation. More of the gravitational energy goes into translation, so it accelerates faster down the incline. (b) From energy conservation, Mgh = ½Mv² + ½Iω² with ω = v/R, which gives v² = 2gh / [1 + I/(MR²)]. The solid sphere has the smaller I/(MR²), so it has the greater translational speed at the bottom for the same drop."
points_earned 3, points_possible 3
point_summary: "Full credit. The prediction is tied to the dimensionless rotational-inertia factors, the reasoning explains why less rotational share means more acceleration, and the speed comparison is supported by the derived expression."
criteria:
- "Predicts the solid sphere arrives first" · earned · "Stated, with (2/5)MR² versus (2/3)MR²."
- "Explains why smaller rotational inertia means greater acceleration" · earned · "A smaller share of the energy goes to rotation at any translational speed."
- "Greater speed supported by v² = 2gh / [1 + I/(MR²)]" · earned · "Expression derived from energy conservation and applied."
missing_concept: null
next_fix: "Push it further: show that the result is independent of M and R, which is why the demonstration works with any two objects of these shapes."
teaching_note: "Rolling-object rubrics want the dimensionless factor I/(MR²), not just the words 'more rotational inertia'."

### Statistics (content keys APSTATS-SFRQ-002, APSTATS-SFRQ-005, APSTATS-SFRQ-011)

**S1 · topic: "z-scores"**
prompt: "Two classes took different quizzes. On Quiz A, the class mean was 74 and the standard deviation was 8. On Quiz B, the class mean was 52 and the standard deviation was 4. A student scored 86 on Quiz A and 62 on Quiz B. (a) Calculate the student's z-score on Quiz A. (b) Calculate the student's z-score on Quiz B. (c) Determine on which quiz the student performed better relative to the class. (d) Explain why z-scores are useful for comparing scores from different quizzes."
answer: "(a) z = (86 − 74) / 8 = 1.5. (b) z = (62 − 52) / 4 = 2.5. (c) The student did better on Quiz B, because 2.5 > 1.5. (d) z-scores let you compare scores from different quizzes."
points_earned 3, points_possible 4
point_summary: "Both z-scores and the comparison are correct. Part (d) restates the question instead of saying what a z-score measures, so the explanation point is not earned."
criteria:
- "z-scores for both quizzes" · earned · "1.5 and 2.5, with the work shown."
- "Better relative performance on Quiz B" · earned · "Chosen by comparing the two z-scores."
- "Why z-scores allow the comparison" · missing · "'z-scores let you compare' names no unit; the rubric wants standard deviations from the mean as a common scale."
missing_concept: "What a z-score measures: standard deviations from the mean, which puts scores from different scales onto one common scale."
next_fix: "z-scores are useful because each one measures how many standard deviations a score is from its own class mean, so scores from quizzes with different means and spreads can be compared on the same scale."
teaching_note: "Restating the question earns nothing; the point is for naming the standardised unit."

**S2 · topic: "Sampling methods"**
prompt: "A school newspaper wants to estimate the proportion of students who support a later start time. Reporters stand outside the cafeteria at lunch and ask the first 50 students who agree to answer. (a) Identify the sampling method used. (b) Describe one source of bias in the sample. (c) Explain how a simple random sample of 50 students could be selected instead. (d) Explain why the results should not be generalized to all students without caution."
answer: "(a) This is a convenience sample. (b) Students who eat lunch somewhere else never get asked, so the sample underrepresents them. (c) Pick students at random from the hallway at different times of day. (d) Because the sample was not chosen randomly it might not represent all students."
points_earned 3, points_possible 4
point_summary: "The method, the bias and the generalisation caution are all earned. The SRS description is still a convenience sample with a wider net; it names no sampling frame and no random mechanism."
criteria:
- "Identifies a convenience or voluntary response sample" · earned · "Convenience sample."
- "Describes undercoverage or self-selection" · earned · "Students who eat elsewhere are never asked."
- "Describes a simple random sample" · missing · "'At random from the hallway' has no list of all students and no random device; every set of 50 is not equally likely."
- "Explains the limit on generalisation" · earned · "Non-random selection may not represent all students."
missing_concept: "An SRS needs a sampling frame: a list of every student, with 50 chosen by a random mechanism so that every set of 50 is equally likely."
next_fix: "Number every student on a complete school roster, then use a random number generator to select 50 distinct numbers; those students are the sample."
teaching_note: "'Random' in a hallway is still convenience sampling. SRS answers must name the frame and the random mechanism."

**S3 · topic: "Confidence interval for a proportion"**
prompt: "A school surveys 120 students about whether they support a later start time. Eighty-four students say yes. (a) State the parameter of interest and calculate p̂. (b) Check the conditions for a one-proportion confidence interval. (c) Calculate a 95% confidence interval for the proportion of all students who support a later start time. (d) Interpret the interval in context."
answer: "(a) The parameter is p, the proportion of all students at the school who support a later start time. p̂ = 84/120 = 0.70. (b) Random: we have to assume the 120 students were a random sample. 10%: 120 is less than 10% of all students. Large counts: 84 successes and 36 failures are both at least 10. (c) 0.70 ± 1.96 × √(0.70 × 0.30 / 120) = 0.70 ± 0.082, so the interval is (0.618, 0.782). (d) We are 95% confident that between 61.8% and 78.2% of students support a later start time, so about 95% of students fall in that range."
points_earned 3, points_possible 4
point_summary: "Parameter, estimate, conditions and interval are all correct. The interpretation attaches the 95% to the students instead of to the method, and that reverses what the interval says."
criteria:
- "Parameter and point estimate" · earned · "p defined in context; p̂ = 0.70."
- "Conditions checked and interval computed" · earned · "Random, 10% and large-counts conditions addressed; (0.618, 0.782)."
- "Interpretation in context" · missing · "'About 95% of students fall in that range' describes individuals; the interval estimates one population proportion."
missing_concept: "What the interval estimates: a single parameter (the proportion of all students), not a share of individual students, with the confidence attached to the method."
next_fix: "We are 95% confident that the interval from 0.618 to 0.782 captures the true proportion of all students at the school who support a later start time."
teaching_note: "Interpretations are scored on the object: the population proportion, in context, with the confidence level attached to the interval, never to the students."

### Calculus AB (content keys apcalcab-frq-u1n-004, apcalcab-frq-002, apcalcab-frq-001)

**K1 · topic: "Continuity of a piecewise function"**
prompt: "Let f be the function defined by f(x) = kx + 2 for x < 1, f(1) = m, and f(x) = (x² + 2x − 3)/(x − 1) for x > 1, where k and m are constants. (a) Find lim(x→1⁺) f(x). Show the work that leads to your answer. (b) Find the values of k and m for which f is continuous at x = 1. Justify your answer using the definition of continuity. (c) Suppose k = 3 and m = 4. Is f continuous at x = 1? If not, classify the discontinuity and justify your answer."
answer: "(a) For x > 1, (x² + 2x − 3)/(x − 1) = (x + 3)(x − 1)/(x − 1) = x + 3, so lim(x→1⁺) f(x) = 4. (b) For continuity the left-hand limit must equal the right-hand limit: k(1) + 2 = 4, so k = 2. Then f(1) = m must equal the limit, so m = 4. (c) With k = 3 and m = 4, the left-hand limit is 3 + 2 = 5 and the right-hand limit is 4, so the limit does not exist and f is not continuous at x = 1."
points_earned 3, points_possible 4
point_summary: "The limit, k and m are all correct with reasons. Part (c) correctly shows the one-sided limits disagree but never classifies the discontinuity, which the prompt asks for."
criteria:
- "Factors and cancels to find the right-hand limit 4" · earned · "(x + 3)(x − 1)/(x − 1) = x + 3, limit 4."
- "Sets the one-sided limits equal and finds k = 2" · earned · "k(1) + 2 = 4."
- "Sets m equal to the limit, m = 4" · earned · "f(1) = m must equal the limit."
- "Concludes not continuous and classifies the discontinuity" · missing · "Shows limits of 5 and 4 and says not continuous, but does not name it a jump discontinuity."
missing_concept: "Classifying the discontinuity: unequal finite one-sided limits (5 and 4) make it a jump discontinuity, not a removable one."
next_fix: "Since lim(x→1⁻) f(x) = 5 and lim(x→1⁺) f(x) = 4 are different finite values, the limit does not exist and f has a jump discontinuity at x = 1."
teaching_note: "'Not continuous' is half the answer when the prompt says classify; name the type and tie it to the one-sided limits."

**K2 · topic: "Intermediate Value Theorem"**
prompt: "A continuous function q satisfies q(0) = 3, q(2) = −1, and q(5) = 4. (a) Explain what the Intermediate Value Theorem guarantees about zeros on (0, 2) and (2, 5). (b) Can the given information establish exactly two zeros on [0, 5]? Explain. (c) Give one additional condition that would make exactly one zero in each interval follow."
answer: "(a) q is continuous, q(0) = 3 > 0 and q(2) = −1 < 0, so by the IVT there is at least one zero in (0, 2). Likewise q(2) = −1 < 0 and q(5) = 4 > 0, so there is at least one zero in (2, 5). (b) Yes. There are exactly two zeros, one in each interval. (c) If q were strictly increasing or strictly decreasing on each interval, there would be exactly one zero in each."
points_earned 2, points_possible 3
point_summary: "The IVT argument and the monotonicity condition are both earned. Part (b) treats the theorem as if it counted zeros; it only guarantees that at least one exists."
criteria:
- "At least one zero in each interval from the sign change" · earned · "Sign changes on (0, 2) and (2, 5) stated with the continuity hypothesis."
- "Existence, not uniqueness" · missing · "Answers 'yes, exactly two'; the IVT cannot rule out additional crossings inside either interval."
- "Strict monotonicity on each interval gives uniqueness" · earned · "Strictly increasing or decreasing on each interval."
missing_concept: "The IVT is an existence theorem: it guarantees at least one zero, never exactly one, so the given values cannot rule out extra crossings."
next_fix: "No. The IVT only guarantees at least one zero in each interval; q could cross zero three times in (0, 2) and still have q(0) = 3 and q(2) = −1, so exactly two zeros cannot be established."
teaching_note: "Any time an FRQ asks 'can we conclude exactly …' after an IVT setup, the scored idea is existence versus uniqueness."

**K3 · topic: "Removable discontinuity"**
prompt: "Define g(x) = (x² − 4)/(x − 2) for x ≠ 2 and g(2) = k. (a) Find lim(x→2) g(x) and show the algebra used. (b) Choose k so that g is continuous at x = 2 and justify the choice. (c) State whether g is differentiable at x = 2 for this k and give g′(2)."
answer: "(a) g(x) = (x − 2)(x + 2)/(x − 2) = x + 2 for x ≠ 2, so lim(x→2) g(x) = 4. (b) g is continuous at 2 when the function value equals the limit, so k = 4. (c) Yes. With k = 4, g(x) = x + 2 for every x, which is a line with slope 1, so g is differentiable at 2 and g′(2) = 1."
points_earned 3, points_possible 3
point_summary: "Full credit. The limit is found by factoring, continuity is justified by matching the function value to the limit, and differentiability follows from the simplified function."
criteria:
- "Limit is 4 after factoring" · earned · "(x − 2)(x + 2)/(x − 2) = x + 2; limit 4."
- "k = 4 because the function value must equal the limit" · earned · "Stated as the condition for continuity."
- "Differentiable, g′(2) = 1 from g(x) = x + 2" · earned · "Line with slope 1."
missing_concept: null
next_fix: "Try the harder version: keep g(2) = 5 instead and explain which of continuity and differentiability fail at x = 2, and why."
teaching_note: "Removable-discontinuity FRQs chain three ideas: the limit by factoring, continuity by matching the value, differentiability from the simplified function."

## 4. Product screenshots that match the subject; slideshow on the home page

The figure after the FRQ demo (`hm-product` in `Homepage.tsx`) shows the AP Biology screenshot with the caption "AP Biology in Cramapple" on every page. Attached are 12 PNGs: for each of biology, chemistry, physics, calculus, precalculus, statistics a desktop capture (`<subject>-desktop.png`, 1920×1403) and a phone crop of the answer-key column (`<subject>-answerkey-crop.png`, 408×1163). They are real `/question` pages from the live app. Save them as `src/assets/product/<subject>-desktop.png` and `src/assets/product/<subject>-answerkey.png` (convert to webp if that is how other large assets are handled; keep the pixel dimensions).

Build `src/components/landing/ProductShowcase.tsx`. One slide per subject: `<picture>` with the answer-key crop under 640px and the desktop image above, `width`/`height` set, alt text in the form "Cramapple AP Chemistry question with its answer key, scoring explanation and reference materials side by side", a small subject label above the image ("AP Chemistry"), and the figcaption "AP Chemistry in Cramapple — connect what you know to what earns credit." Slides and labels: biology "AP Biology", chemistry "AP Chemistry", physics "AP Physics C: E&M" (the only physics capture we have; label it exactly that, never just "AP Physics"), calculus "AP Calculus AB", precalculus "AP Precalculus", statistics "AP Statistics".

- `/` (Homepage with no subject): slideshow of all six in the order biology, chemistry, physics, calculus, precalculus, statistics. "← Prev · n / 6 · Next →" above and below the figure, real `<button>`s, `aria-controls`, `aria-live="polite"` on the figure, no autoplay, no transition. First slide eager, the rest `loading="lazy"`.
- Subject pages show the matching slide(s) only: biology → biology; chemistry → chemistry; statistics → statistics; physics → physics (E&M); calculus → two slides, Calculus AB then Precalculus, with the controls.
- Replace the old figure and remove the imports of `bio-prep-screenshot.png.asset.json` and `bio-answer-key-mobile.webp` from `Homepage.tsx`; delete those two asset files if nothing else imports them.

## 5. Tests and report

Update `src/lib/landing.test.ts` for the new chooser list and proof lines. Add tests that: `FrqDemo` renders the subject label and three examples for chemistry and the existing four for biology; both control rows change the index; `ProductShowcase` renders six slides on `/` and one on `/ap-chemistry-prep`; `/ap-physics-prep` CTAs link to `/checkout` with no subject. Run the suite. Report: files changed, where each attached image was saved and at what size, and anything you could not do. Do not publish.
<!-- PROMPT_END -->

## After this lands (not for Lovable)

- **Real grader runs for the demo FRQs.** David can answer each of the nine questions above in the live app as admin (the keys are listed) and we replace the authored payloads with the grader's own output, criterion by criterion. Same for a hand-drawn photo per subject: chemistry and calculus photos exist on disk (`docs/hand drawn samples/Chem HDR`, `Calc AB HDR`), physics has none; a graded photo needs the `TASK-0069` admin run that is still pending.
- **Physics 1 screenshot.** Once David has a graded Physics 1 session, re-capture with `?state=physics` pointed at it; the harness states live in `.worktrees/cramapple-app/src/dev-harness/` (uncommitted by design).
- **Content defect found on the way:** `APSTATS-SFRQ-008` part (d) says "a positive expected value" but the stimulus gives E[X] = −1.40. Not used in the demo for that reason; needs a content fix.
- Visual check before publishing: `/` slideshow at 375px (controls above and below), `/ap-physics-prep` course strip and chooser highlight, `/ap-calculus-prep` two-slide showcase.

## Result (2026-11-01)

**Round 1 — commit `955bebb7`, 11.3 credits, 359 tests passing by Lovable's report, NOT published.** Sent with 10 of the 12 images
(Lovable's per-message limit); the biology and precalculus phone crops went in a second message (below).

Reviewed by diff (9 files; nothing under checkout, trial-checkout, purchase-*, attribution; no `transition`/`animation` added
to the CSS, no autoplay or timers in the showcase):

| Ask | What landed |
| --- | --- |
| 1 Controls above and below | `FrqDemo` renders the Prev / counter / Next row twice, both with `aria-controls="frq-demo-examples"`; `ProductShowcase` does the same when it has more than one slide. |
| 2 Course coverage | `prep-pages.ts`: physics drops `checkoutKey`, highlights all four physics keys, carries the `courses` strip and `priceNote: "one-time, per course"`; calculus the same; both page descriptions updated. `landing.ts`: the two per-course proof lines verbatim; chooser is the ten purchasable subjects (Lovable kept Statistics in second position instead of last; otherwise as asked). |
| 3 FRQ demo by subject | 12 new examples keyed by subject; criterion statuses in the diff total 34 earned / 9 missing, which is exactly the authored set; the provenance comment is in place verbatim; label is built from the subject. |
| 4 Product showcase | `src/components/landing/ProductShowcase.tsx` + `src/styles/homepage-mockup.css`; images saved as WebP at original pixel size under `src/assets/product/` (desktop 83–161 KB, crops 34–55 KB); `<picture>` switches at 639px; `aria-live="polite"`; six slides on `/`, two on calculus, one elsewhere; physics slide labelled "AP Physics C: E&M". `bio-answer-key-mobile.webp` deleted; `bio-prep-screenshot.png.asset.json` kept because `/ap-stem-prep`'s device frame still uses it. |
| 5 Tests | `landing.test.ts`, `prep-pages.test.tsx` added/updated; `index.test.tsx` physics-link assertion replaced. |

Lovable's own caveats: it saw the home slideshow controls on a phone but the first slide image had not finished loading in its
capture, so it did not see a slide render; it checked the physics course strip wraps cleanly.

Not verified by eye here: the Lovable preview needs a Lovable login. Before publishing, David should open `/` (slideshow,
controls above and below, 375px), `/ap-physics-prep` (strip, four highlighted chooser rows, CTA to `/checkout`),
`/ap-calculus-prep` (two-slide showcase), `/ap-chemistry-prep` (three chemistry FRQ examples, chemistry screenshot).

**Round 2 — commit `2f325a7e`, 2.2 credits.** The biology and precalculus phone crops saved as PNG (142 KB, 59 KB; the other four
crops are WebP) and wired as the phone source for those two slides; 359 tests pass; not published. Lovable checked both at
375×812 and notes a thin sliver of the neighbouring panel at the right edge of every crop and the last biology option cut off at
the bottom; that is in the crop itself (offset 170 px from the desktop capture). Re-crop a little narrower if it shows.

**Latest marketing commit to publish: `2f325a7e`** (includes `695ec382` from 2026-10-31 and `955bebb7`).
