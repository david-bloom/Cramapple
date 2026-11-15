# Blinded paired read: MCQ coaching, baseline vs linked topic passage

For each pair, read the item and the authored rationales, then choose the better text for a student who just missed the question (Text 1, Text 2 or tie) and note why in a few words. Mark any text that says something false or unsupported. Key at the end; do not read it first.

## 1. AP Statistics (student picked B)

A test of H₀: p = 0.50 versus Hₐ: p > 0.50 uses n = 100 and α = 0.05, and the true proportion is p = 0.60. Which change would increase the power of the test?

- A. Increasing the sample size to 400, which reduces the standard error. (correct)
  - authored rationale: A larger n shrinks the standard error of p̂, making a true difference easier to detect, so power increases.
- B. Decreasing the sample size to 25, since a smaller sample has fewer chances for error.
  - authored rationale: A smaller sample gives a larger standard error, which lowers power; sample size reduction does not reduce error.
- C. Lowering α to 0.01, which makes the test more careful about rejecting.
  - authored rationale: A smaller α makes rejection harder, which reduces the probability of rejecting a false H₀ and so decreases power.
- D. Using the hypothesized value 0.58 in place of 0.50, so the null is closer to the truth.
  - authored rationale: A smaller gap between the null value and the true value makes the difference harder to detect, which lowers power.

**Text 1** (140 words)
> The question asks which change raises power, meaning the chance of rejecting H₀ when p = 0.60 is true. A correct answer must name a change that makes it easier to detect the difference between 0.50 and 0.60.
> 
> Option B says a smaller sample, n = 25, has fewer chances for error. That is the defect: it treats sample size as a source of error. A smaller n increases the standard error of p̂, which makes detecting the true difference harder and lowers power.
> 
> To earn this point, answer it differently: tie each choice to its effect on the standard error or the gap between the null and true values. Next time, ask whether the change makes the test more or less able to detect the true p. Here, a larger n (A) reduces the standard error and raises power.

**Text 2** (115 words)
> **What the question requires:** A change that makes the test more likely to reject H₀ when the true proportion is 0.60.
> 
> **What B says:** A smaller sample has fewer chances for error. That fails because n = 25 increases the standard error of p̂, so a true difference is harder to detect and power falls.
> 
> **How the point is lost:** This is a "learn this first" gap. Power increases with a larger sample size, a bigger gap between the null and true values, or a larger α. Next time, check each option against these three factors and keep only the one that improves them. Here, that is the larger sample, which shrinks the standard error.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 2. AP Statistics (student picked D)

A test of H0: p = 0.30 versus Ha: p < 0.30 has a probability of 0.18 of failing to reject H0 when the true proportion is 0.20. Which statement is correct?

- A. The test has power 0.18 against p = 0.20.
  - authored rationale: 0.18 is the Type II error probability, not the power.
- B. The test has power 0.82, so there is an 82% chance that the true proportion is 0.20.
  - authored rationale: Power is not a probability that the parameter takes a value.
- C. The test has power 0.82, so there is an 82% chance the test rejects H0 if the true proportion is 0.20. (correct)
  - authored rationale: Correct: power = 1 - 0.18 = 0.82.
- D. The test has power 0.82, so there is an 18% chance that H0 is true.
  - authored rationale: Power does not give the probability that H0 is true.

**Text 1** (165 words)
> What the question requires: the power of the test against p = 0.20, which is the probability of rejecting H0 when the true proportion is 0.20. Since the given probability of failing to reject is 0.18, power is 1 minus that.
> 
> Option D says power is 0.82 (correct), but then claims there is an 18% chance H0 is true. That is the defect: it turns a statement about the test's behavior under p = 0.20 into a probability about whether H0 is true. Power is conditional on H0 being false, and it says nothing about the probability that H0 is true.
> 
> Next time, answer it differently: after computing power, state what it means in terms of rejecting H0 when the alternative is true. Do not attach a probability to H0. The fix is to read each claim and check it against what power measures. Learn this first: power = P(reject H0 | Ha is true at a specific value) = 1 − P(Type II error).

**Text 2** (126 words)
> **What the question requires:** the power value (1 − 0.18 = 0.82) and its meaning: the chance the test rejects H0 when p is actually 0.20.
> 
> **Choice D:** The power value of 0.82 is correct. The error is the claim that 18% is the chance H0 is true. Power and Type II error are conditional on the alternative being true. Neither gives the probability that H0 is true.
> 
> **How the point is lost:** The interpretation is wrong. This is a learn-this-first fix. Power = P(reject H0 | the specific alternative is true) = 1 − P(Type II error). Next time, state power as the probability of rejecting H0 when the specific alternative value is true. Do not attach a probability to H0 or to the parameter.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 3. AP Statistics (student picked C)

A study classified adults by exercise habit and sleep. The table gives the proportion of all adults in each category.
Exercises regularly, Sleeps 8+ hours: 0.24
Exercises regularly, Sleeps less: 0.16
Does not exercise regularly, Sleeps 8+ hours: 0.21
Does not exercise regularly, Sleeps less: 0.39
Among adults who sleep 8 or more hours, what proportion exercise regularly?

- A. 0.24
  - authored rationale: This is the joint proportion of the whole group for both categories, not the proportion within the group the question names.
- B. 0.60
  - authored rationale: This is P(sleeps 8+ | exercises) = 0.24/0.40, the reverse of what the question asks.
- C. 0.40
  - authored rationale: This is P(exercises), the overall proportion who exercise, not the proportion among those who sleep 8 or more hours.
- D. 0.53 (correct)
  - authored rationale: Correct: P(sleeps 8+) = 0.24 + 0.21 = 0.45, so P(exercises | sleeps 8+) = 0.24/0.45 ≈ 0.53.

**Text 1** (111 words)
> **What the question requires:** A proportion among adults who sleep 8 or more hours. The base you divide by must be that sleep group only.
> 
> **What C says:** 0.40 is the overall share who exercise. It ignores the sleep condition and uses all adults as the base, so it answers a different question.
> 
> **How the point is lost and how to earn it:** Answer it differently. Divide the proportion who both exercise and sleep 8+ by the proportion who sleep 8+. Learn first: P(A | B) = P(A and B) / P(B). Here P(sleeps 8+) = 0.24 + 0.21 = 0.45, so the answer is 0.24 / 0.45 ≈ 0.53 (D).

**Text 2** (110 words)
> **What the question requires:** The proportion who exercise among only the adults who sleep 8 or more hours. The denominator must be the sleep 8+ group total.
> 
> **What C says:** 0.40 is the overall share of adults who exercise. It ignores the sleep condition, so it answers a different question.
> 
> **The fix:** Answer it differently. Next time, restrict to the sleep 8+ column, then divide the exercise cell by that column total: 0.24/0.45 ≈ 0.53 (choice D).
> 
> **Learn this first:** A conditional relative frequency is a cell divided by its own row or column total. A marginal relative frequency is a row or column total divided by the table total.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 4. AP Statistics (student picked D)

A random sample of 100 people was classified by group and response. Group 1 (20 people): 15 responded yes and 5 responded no. Group 2 (80 people): 75 responded yes and 5 responded no. A researcher plans a chi-square test. Which statement about the conditions is correct?

- A. The expected counts condition is not met, because the expected count for Group 1 and response no is 20(10)/100 = 2, which is less than 5. (correct)
  - authored rationale: Correct: column totals are 90 and 10; expected counts: Group 1: 18 and 2; Group 2: 72 and 8; the smallest is 2.
- B. The conditions are met, because every observed count is at least 5.
  - authored rationale: The condition is on expected counts, and an expected count can be small even when all observed counts are at least 5.
- C. The conditions are met, because the total sample size of 100 is greater than 30.
  - authored rationale: The sample-size rule of 30 does not replace checking expected counts.
- D. The expected counts condition is not met, because Group 2 has more people than Group 1.
  - authored rationale: Unequal group sizes are not a violation; the condition is about expected counts.

**Text 1** (98 words)
> What the question requires: decide whether the expected-counts condition holds by computing the expected counts and checking each one against 5.
> 
> Option D claims the condition fails because Group 2 is larger. That is not a violation, since group sizes may differ. The condition concerns expected counts, so D gives a wrong reason and earns no point.
> 
> Next time, answer differently: compute each expected count (row total × column total ÷ 100) before judging. Group 1 and "no" gives 20×10/100 = 2, which fails. Learn this first: every expected count must be at least 5.
> 
> Correct answer: A.

**Text 2** (121 words)
> **What the question requires:** A correct statement must check the expected-count condition using the table's totals, then state the result.
> 
> **What D says:** The expected-count condition fails because Group 2 is larger. This reason is wrong. Unequal group sizes are not a violation, and D never calculates an expected count.
> 
> **Fix (answer it differently):** Next time, compute each expected count as (row total × column total) ÷ n, then check whether any is below 5. Here, Group 1 and "no" gives 20 × 10 ÷ 100 = 2, which is below 5, so the condition fails. Correct answer: A.
> 
> **Learn this first:** Expected count = (row total × column total) ÷ total n. Every expected count must be at least 5.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 5. AP Statistics (student picked B)

Which conclusion is appropriately supported by this study design?

- A. There is an association between meditation habits and blood pressure in this sample, but causation cannot be concluded because participants were not randomly assigned to meditate or not. (correct)
  - authored rationale: This was an observational, voluntary-response study with no random assignment of the explanatory variable, so an association can be described but a causal claim is not supported.
- B. Meditating for 20 minutes a day causes lower blood pressure.
  - authored rationale: This draws a causal conclusion from an observational study with no random assignment, which cannot rule out confounding variables.
- C. Because the sample size is large (500 people), causation can be concluded even without random assignment.
  - authored rationale: A large sample size reduces sampling variability but does nothing to address confounding; only random assignment supports causal claims.
- D. No conclusion can be drawn because the study did not use a randomized experiment.
  - authored rationale: This overcorrects -- observational studies can still support conclusions about association, just not causation.

**Text 1** (101 words)
> **What the question requires:** State what this design supports (an association) and whether it supports a cause-and-effect claim.
> 
> **What B says:** It claims meditation causes lower blood pressure. The study was observational: people chose whether to meditate and reported their own habits. Confounding variables, such as exercise or diet, could explain the difference, so B overstates what the design shows.
> 
> **How to earn the point:** Answer differently. Describe the association and state that causation cannot be concluded without random assignment. Learn this first: only random assignment of treatments, with extraneous variables controlled, supports a causal claim. Option A states this correctly.

**Text 2** (118 words)
> What the question requires: name the conclusion the design can support. Here, the design is observational with no random assignment, so the answer must describe an association and must not claim cause.
> 
> What B says: it states that meditating causes lower blood pressure. The rationale is that this is a causal claim from an observational study, which cannot rule out confounding variables. Causal language is the defect.
> 
> How the point is lost and how to earn it: Next time, check the study design first. If the explanatory variable was not randomly assigned, reword the conclusion to describe association only, and state why causation is not supported. This is an "answer it differently" fix. The correct answer is A.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 6. AP Statistics (student picked C)

Which prediction is most appropriate?

- A. Use the line to predict at x = 25, because that is within the observed x-range. (correct)
  - authored rationale: Interpolation within the observed range is much safer than extrapolation beyond it.
- B. Use the line to predict at x = 100, because the line works for all x-values.
  - authored rationale: This is extrapolation far beyond the data range.
- C. Use the line only when x equals the mean of the data.
  - authored rationale: Predictions are not limited to the mean.
- D. Never use a regression line for prediction.
  - authored rationale: Regression is often used for prediction within the data range.

**Text 1** (109 words)
> **What the question requires:** Pick the prediction the data support. That means an x-value inside the observed range, 10 to 40.
> 
> **What C says:** Predictions are valid only at the mean of x. This is the defect. A regression line gives a predicted y for any x in the data range, so the restriction is invented and the choice fails.
> 
> **How to earn the point:** Learn this first: predictions within the observed x-range (interpolation) are reasonably reliable, and predictions beyond it (extrapolation) are not. Next time, check each choice's x-value against the range 10 to 40 before choosing.
> 
> **Correct answer:** A. x = 25 lies within 10 to 40.

**Text 2** (123 words)
> The question asks for an appropriate prediction, so a correct answer must pick an x-value and justify it by checking it against the range of x-values used to fit the line.
> 
> Option C says to use the line only when x equals the mean. This is wrong because predictions are not limited to the mean. The error is restricting the line to one point instead of its whole data range.
> 
> Next time, state the range check. The line reliably predicts only within x = 10 to 40. A is correct because x = 25 lies inside that range, while B (x = 100) extrapolates far beyond the data.
> 
> Fix type: answer differently. Name the observed range and whether the x-value falls inside it.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 7. AP Statistics (student picked A)

A test of H0: p = 0.50 versus Ha: p > 0.50 uses a significance level of alpha = 0.05. The test has power 0.70 against the alternative p = 0.60. Which statement is correct?

- A. There is a 70% chance that the true proportion is 0.60.
  - authored rationale: Power is a probability about the test's decision, computed for an assumed true value, not a probability about the parameter.
- B. If the true proportion is 0.50, there is a 70% chance that the test rejects H0.
  - authored rationale: Rejecting a true H0 is a Type I error, whose probability is alpha = 0.05.
- C. If the true proportion is 0.60, there is a 30% chance that the test fails to reject H0, which would be a Type II error. (correct)
  - authored rationale: Correct: Type II error probability = 1 - power = 0.30.
- D. If the true proportion is 0.60, there is a 5% chance that the test makes a Type II error.
  - authored rationale: 0.05 is the probability of a Type I error, not a Type II error.

**Text 1** (118 words)
> The question requires a statement that is conditional on a specific true value and correctly identifies the test's decision. Power is a probability about that decision, not about the parameter.
> 
> Option A says there is a 70% chance the true proportion is 0.60. The defect is that it treats the parameter as random and assigns power to its value. The parameter is fixed. Power is P(reject H0 | p = 0.60).
> 
> To earn the point, answer it differently: begin with the condition "If p = 0.60," then state what the test does. Learn this first: power = 1 − P(Type II error). Here the Type II error probability is 1 − 0.70 = 0.30, so C is correct.

**Text 2** (126 words)
> **What the question requires:** A statement about the test's error probabilities when p = 0.60, the stated alternative.
> 
> **What A says:** It gives a 70% chance that the true proportion is 0.60. That treats power as a probability about the parameter. Power is not that. It is the chance the test rejects H0 if p = 0.60, a statement about the test's decision.
> 
> **How to earn the point:** Learn this first: power = P(reject H0 | assumed true value), and Type II error = P(fail to reject H0 | that value) = 1 − power. Next time, check whether each choice describes the decision or the parameter before selecting.
> 
> Correct answer: **C**. With power 0.70, the Type II error probability is 1 − 0.70 = 0.30.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 8. AP Statistics (student picked B)

A school asks 200 students whether they favor an earlier start time. Among 80 juniors, 20 say yes and 60 say no. Among 120 seniors, 60 say yes and 60 say no. Among seniors, what proportion favor the earlier start?

- A. 0.50 (correct)
  - authored rationale: This earns the point because a conditional relative frequency divides by the total of the group named in the question: 60/120 = 0.50. Conditioning on seniors makes 120 the denominator.
- B. 0.30
  - authored rationale: Tempting if you divide by the grand total (60/200) — but that is a joint relative frequency, not the proportion within seniors. Fix: divide by the number of seniors.
- C. 0.75
  - authored rationale: Tempting if you divide by the number of yes responses (60/80) — but that gives the share of yes responses who are seniors, the reverse of what was asked. Fix: the group in the condition supplies the denominator.
- D. 0.40
  - authored rationale: Tempting if you use the overall proportion saying yes (80/200) — but that is a marginal relative frequency for all students. Fix: restrict to the seniors' row.

**Text 1** (105 words)
> The question asks for the proportion of seniors who favor the earlier start, so the denominator must be the number of seniors, 120.
> 
> B divides 60 by 200, the whole school. That gives a joint relative frequency (seniors who favor it, out of all students), not the proportion within seniors. The point is lost because the denominator is the total instead of the group named in the question.
> 
> Next time, restrict your attention to the seniors' row, then divide the "yes" count by that row's total. This is an answer-it-differently fix: reframe which group forms the denominator. The correct answer is A: 60/120 = 0.50.

**Text 2** (90 words)
> The question asks for the proportion of seniors who favor the earlier start, so the denominator must be the total number of seniors, 120.
> 
> Choice B divides 60 by 200, the whole school. That gives the share of all students who are senior "yes" responses, which is a joint relative frequency, not the proportion within seniors. The defect is the denominator.
> 
> To earn the point, answer it differently: name the group in the condition, take its total as the denominator, then divide. Here, 60/120 = 0.50, which is choice A.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 9. AP Statistics (student picked B)

A candidate needs more than 50% of the vote to win. A campaign wants to test whether the proportion of all voters supporting the candidate exceeds 50%. In a random sample of 400 voters, 188 support the candidate (47%). Which hypotheses should the campaign test?

- A. H0: p = 0.50, Ha: p < 0.50, where p is the proportion of all voters who support the candidate.
  - authored rationale: Followed the sample result (47% is below 50%) instead of the question.
- B. H0: p >= 0.50, Ha: p = 0.50, where p is the proportion of all voters who support the candidate.
  - authored rationale: The alternative hypothesis never contains equality.
- C. H0: p = 0.47, Ha: p > 0.47, where p is the proportion of all voters who support the candidate.
  - authored rationale: Used the sample proportion as the null value.
- D. H0: p = 0.50, Ha: p > 0.50, where p is the proportion of all voters who support the candidate. (correct)
  - authored rationale: Correct: the question is whether support exceeds 50%.

**Text 1** (100 words)
> The question asks for hypotheses where the alternative states the claim the campaign wants to support: that support is more than 50%. Choice B reverses the roles. It puts equality in Ha and uses ≥ in H0. The null hypothesis must always contain the equality, and the alternative must never contain it. Learn this first: H0 uses =, and Ha uses >, <, or ≠ to match the claim. Answer it differently by writing Ha from the words "more than 50%" first, then setting H0 to p = 0.50. Correct answer: D, H0: p = 0.50, Ha: p > 0.50.

**Text 2** (124 words)
> The question requires a null hypothesis containing equality, and an alternative hypothesis stating the campaign's claim that support exceeds 50%.
> 
> Option B makes the alternative hypothesis contain equality (Ha: p = 0.50) and sets H0 to p ≥ 0.50. An alternative hypothesis never contains equality, so this pair is invalid. The direction is also reversed: the claim to be tested, that p exceeds 0.50, belongs in Ha.
> 
> Learn this first: H0 always contains the equal sign and the boundary value. Ha uses <, >, or ≠ and states what is being tested. Next time, write Ha from the claim in the question ("exceeds 50%"), then set H0 as p = 0.50.
> 
> The correct answer is D: H0: p = 0.50, Ha: p > 0.50.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 10. AP Statistics (student picked C)

Among all users of app A, 40% renew their subscription, and among all users of app B, 25% renew. Independent random samples of 200 users of app A and 150 users of app B are selected, and the difference in sample proportions (p-hat A - p-hat B) is recorded. Which statement describes its sampling distribution?

- A. Approximately normal with mean 0.15 and standard deviation 0.0700.
  - authored rationale: Added the two standard deviations instead of adding the two variances and taking the square root.
- B. Approximately normal with mean 0.15 and standard deviation 0.0495. (correct)
  - authored rationale: Correct: mean = 0.40 - 0.25 = 0.15; variance = 0.4(0.6)/200 + 0.25(0.75)/150 = 0.00245; SD = 0.0495; counts 80, 120, 37.5, 112.5 are all at least 10.
- C. Approximately normal with mean 1.6 and standard deviation 0.0495.
  - authored rationale: Divided the two proportions instead of subtracting them.
- D. Approximately normal with mean 0.15 and standard deviation 0.00245.
  - authored rationale: Reported the variance as the standard deviation.

**Text 1** (115 words)
> **What the question requires:** The center and spread of the distribution of p-hat A minus p-hat B, based on the given proportions and sample sizes.
> 
> **What C says:** Its mean of 1.6 comes from dividing 0.40 by 0.25. That is the error. Its standard deviation of 0.0495 is correct, so the spread part is already earned.
> 
> **How the point is lost and how to earn it:** Learn this first. The mean of p-hat A minus p-hat B is p_A minus p_B, so here it is 0.40 − 0.25 = 0.15. Variances of independent differences add. Next time, compute the mean by subtracting and check each part of the answer separately. The correct answer is B.

**Text 2** (89 words)
> The question asks for the mean and standard deviation of phat A − phat B.
> 
> Choice C gives a mean of 1.6, which comes from dividing 0.40 by 0.25. The difference of two proportions requires subtraction: 0.40 − 0.25 = 0.15. Its standard deviation, 0.0495, is correct, but the wrong mean costs the point. The correct answer is B.
> 
> Next time, answer it differently: write the mean as p1 − p2 before comparing choices.
> 
> Learn this first: means of differences subtract, and variances of differences add: p1(1−p1)/n1 + p2(1−p2)/n2.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 11. AP Biology (student picked C)

Two clear solutions are prepared by dissolving 10 g of table salt (NaCl) in one beaker of water and 10 g of sugar (C12H22O11) in another. A conductivity probe shows that the salt solution conducts electricity well and the sugar solution does not conduct. Both solids dissolve completely. Which statement best explains why the sugar solution does not conduct even though the sugar dissolved?

- A. Sugar dissolves by forming bonds with water that remove all charge from the water molecules.
  - authored rationale: Water molecules keep their partial charges while hydrogen bonding, and conductivity depends on free ions, not on water losing charge.
- B. Sugar dissolves because water breaks its covalent bonds into individual atoms, which carry no charge.
  - authored rationale: Dissolving sugar does not break covalent bonds within the sugar molecule, so atoms are not released.
- C. Sugar is nonpolar, so it dissolves by being trapped between water molecules without any attraction to them.
  - authored rationale: Sugar has many polar -OH groups and is not nonpolar, and a nonpolar substance would not dissolve well in water.
- D. Sugar stays as intact, uncharged molecules whose many -OH groups form hydrogen bonds with water, so no free ions are produced. (correct)
  - authored rationale: Correct: Conduction requires free ions; sugar's polar -OH groups hydrogen bond with water so the molecules disperse intact without becoming ions.

**Text 1** (120 words)
> **What the question requires:** Explain why sugar, though fully dissolved, produces no charged particles, so the solution cannot carry current. The answer must say what happens to the sugar molecules and why they disperse in water.
> 
> **Option C** says sugar is nonpolar and sits between water molecules with no attraction. This is wrong on two counts: sugar has many polar -OH groups, and a nonpolar solid would not dissolve well in water. Both facts must be right to earn the point.
> 
> **Fix:** Learn this first: the -OH groups make sugar polar, and conduction requires free ions. Then answer it differently: state that sugar stays as intact, uncharged molecules whose -OH groups hydrogen bond with water.
> 
> The correct answer is D.

**Text 2** (100 words)
> **What's required:** Explain why sugar dissolves yet produces no ions. Conduction needs free charged particles, so the answer must show dissolving without ion formation.
> 
> **Choice C:** Says sugar is nonpolar and sits between water molecules with no attraction. This is wrong on both counts. Sugar has many polar -OH groups, and dissolving requires attraction to water.
> 
> **Learn this first:** Water's polar O-H bonds form hydrogen bonds with the polar -OH groups on sugar.
> 
> **Answer it differently:** Next time, state that sugar molecules stay intact and uncharged, held in solution by hydrogen bonds, so no free ions form. Correct answer: D.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 12. AP Biology (student picked B)

A computer simulation models a membrane-bound compartment in a yeast cell. Enzymes attached to the compartment’s membrane carry out metabolic reactions. A remodeling step smooths out membrane folds, reducing total internal membrane area from 60 μm² to 30 μm². Cell volume and plasma membrane area remain unchanged. The number of attached enzymes per unit membrane area stays constant, and reactants remain abundant.

Which prediction best explains how remodeling affects the cell’s function?

- A. The compartment can support the same number of simultaneous reactions because the cell’s volume has not changed.
  - authored rationale: Volume-for-surface substitution: This uses unchanged cell volume to infer unchanged capacity for membrane-associated reactions. Here, enzyme number depends on internal membrane area, which decreases. Fix: Determine whether enzyme number depends on membrane area or cell volume.
- B. The cell takes up nutrients more slowly because smoothing the internal folds reduces its surface area for exchange with the surroundings.
  - authored rationale: Internal–external membrane confusion: This treats the compartment’s membrane as the cell’s external boundary. Plasma membrane area remains unchanged, so the internal area reduction does not remove surface for external exchange. Fix: Identify which membrane contacts the surroundings before predicting nutrient uptake.
- C. The compartment can support fewer simultaneous reactions because the smaller internal membrane area accommodates fewer enzymes. (correct)
  - authored rationale: The internal membrane provides attachment surfaces for the reaction enzymes. Halving its area while maintaining the same enzyme density halves the number of attached enzymes, reducing the capacity for simultaneous reactions.
- D. The compartment can support more simultaneous reactions because smoothing the folds increases the membrane area available for enzymes.
  - authored rationale: Folding-means-less-area misconception: This assumes that removing folds creates more membrane surface. The stated area instead decreases from 60 μm² to 30 μm², leaving room for fewer attached enzymes. Fix: Compare total membrane areas before inferring how folding affects enzyme capacity.

**Text 1** (95 words)
> The question asks which prediction follows from the change in internal membrane area, with enzyme density and reactant supply held constant.
> 
> Choice B predicts slower nutrient uptake because the cell's exchange surface shrinks. This treats the internal compartment membrane as the cell's outer boundary. The question states that plasma membrane area is unchanged, so B's reasoning fails.
> 
> To earn this point, answer differently: tie your prediction to the membrane the question describes. The correct answer is C. Halving membrane area at constant enzyme density halves the attached enzymes, so fewer reactions can run at once.

**Text 2** (115 words)
> You picked B, which says the cell takes up nutrients more slowly. That treats the compartment's membrane as the cell's outer boundary. The question states that plasma membrane area is unchanged, so the internal membrane is the one being reduced, and it is not the surface that exchanges with the surroundings.
> 
> The question asks you to predict how the change in internal membrane area affects the compartment's enzyme-driven reactions. A correct answer must link the 60 to 30 μm² drop to fewer attached enzymes and fewer simultaneous reactions.
> 
> To earn this point, answer it differently: first identify which membrane the change affects, then reason from enzyme number to reaction capacity. The correct answer is C.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 13. AP Biology (student picked A)

A ripening apple releases ethylene gas. Ethylene triggers cells in the apple, and in nearby apples, to make more ethylene, so the ethylene concentration rises rapidly. A student claims: "A feedback loop must keep a variable steady, so this cannot be a feedback loop at all." Which evaluation is best?

- A. The claim is correct, because ethylene production keeps changing and so there is no feedback.
  - authored rationale: Feedback means the output influences its own production, and ethylene production is controlled by ethylene, so feedback is present.
- B. The claim is correct, because only negative feedback loops count as feedback.
  - authored rationale: Positive feedback loops are feedback too, and they amplify a change.
- C. The claim is wrong, because this is negative feedback with a set point at a very high ethylene level.
  - authored rationale: No set point is being defended, and the ethylene level keeps rising instead of returning to a value.
- D. The claim is wrong: this is a positive feedback loop, in which the output increases the stimulus and drives the variable further from its starting value. (correct)
  - authored rationale: Correct: ethylene stimulates more ethylene, so the output amplifies the change; keeping a variable near a set point describes negative feedback only.

**Text 1** (109 words)
> The question asks you to judge the student's claim by identifying the loop type from the described mechanism: ethylene triggers more ethylene.
> 
> Option A says there is no feedback because ethylene production keeps changing. This fails because feedback means the output influences its own production, and here ethylene stimulates its own synthesis. Changing production is what feedback produces, so it does not refute the loop.
> 
> To earn the point, answer differently: name the loop type and justify it from the stimulus-output relationship. Learn this first: positive feedback amplifies a change, while negative feedback returns a variable toward a set point. The correct answer is D, a positive feedback loop.

**Text 2** (137 words)
> You picked A. The claim that feedback requires steady output is the error. A feedback loop only requires that the output affects its own production. Here, ethylene stimulates cells to make more ethylene, so the loop is present, and that is what the question asks you to evaluate.
> 
> Choice A fails because it says production "keeps changing" means no feedback. Changing output does not rule out feedback; a loop that amplifies change is still feedback.
> 
> To earn this point next time, answer it differently: first state what the scenario shows (output drives more of the same output), then judge the student's claim against that. Also learn this first: positive feedback amplifies the original stimulus until a decisive endpoint, while negative feedback keeps a variable near a set point. The correct answer is D, a positive feedback loop.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 14. AP Biology (student picked A)

A mutation in a bacterial enzyme replaces a serine (polar, uncharged) on the protein's surface with leucine (nonpolar, hydrophobic). The mutant enzyme folds normally and remains active, but in water its molecules clump together into large aggregates, whereas the normal enzyme stays dispersed. Which best explains why the mutant molecules aggregate?

- A. The leucine side chains form peptide bonds with neighboring enzyme molecules, joining the proteins into one large covalent polymer.
  - authored rationale: Peptide bonds form only between the amino group and carboxyl group of amino acids during translation; R groups do not form them with other proteins.
- B. The exposed nonpolar leucine side chains on separate molecules associate with each other to avoid water, linking the molecules through hydrophobic interactions. (correct)
  - authored rationale: Hydrophobic side chains exposed on the surface cluster together away from water, so separate protein molecules stick together.
- C. The leucine side chains form strong hydrogen bonds with water, which pulls the molecules together into aggregates.
  - authored rationale: Nonpolar side chains cannot form hydrogen bonds with water; serine, the polar residue that was replaced, could.
- D. The leucine substitution adds a negative charge, so the neighboring molecules are attracted to each other by ionic bonds.
  - authored rationale: Leucine's side chain is nonpolar and uncharged, so it contributes no charge and no ionic attraction.

**Text 1** (130 words)
> **What the question requires:** Explain why exposing a nonpolar residue on the surface makes separate molecules stick together, and name the interaction that links them.
> 
> **What A says:** Leucine side chains form covalent peptide bonds between molecules, creating one large polymer. This fails because peptide bonds form only between the amino and carboxyl groups of backbone residues during translation. Side chains do not form them with other proteins.
> 
> **How the point is lost:** The answer names the wrong kind of bond. To earn the point, learn this first: peptide bonds are covalent links within one chain's backbone, while R-group interactions between molecules are noncovalent (hydrophobic, hydrogen, or ionic). Next time, answer differently: start from the substitution (nonpolar leucine exposed to water) and name the hydrophobic interaction that links the molecules.

**Text 2** (131 words)
> Incorrect. The question asks why the mutant molecules clump in water while the normal ones stay dispersed. A correct answer must name the force that joins separate molecules, and tie it to the new exposed leucine.
> 
> Option A says leucine side chains form peptide bonds with neighboring molecules. This fails because peptide bonds form between the amino and carboxyl groups of amino acids during translation, not between side chains of different proteins. Any answer relying on a covalent link misreads the mutation, which changed only the surface residue's polarity.
> 
> To earn this point, answer differently: name the interaction between the exposed nonpolar groups, and state that these groups cluster to avoid water. Learn this first: hydrophobic interactions are weak, noncovalent associations between nonpolar side chains that are pushed together by water.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 15. AP Biology (student picked C)

Hydrolytic enzymes that digest worn-out cell components are made by ribosomes on the rough ER, then modified and sorted in the Golgi complex into vesicles that become lysosomes. A drug prevents the Golgi complex from packaging these enzymes into vesicles but does not affect enzyme synthesis. Which outcome is most likely in the treated cells?

- A. The enzymes are no longer made, because the Golgi complex supplies the ribosomes that carry out their synthesis.
  - authored rationale: Ribosomes make enzymes independent of the Golgi complex, and the drug is stated not to affect synthesis.
- B. The enzymes are digested by the Golgi complex, so worn-out components are broken down faster than in untreated cells.
  - authored rationale: The Golgi complex modifies and packages proteins; it does not digest them or speed up breakdown of cell components.
- C. The enzymes are made inside the lysosomes instead, so worn-out components are digested at the normal rate.
  - authored rationale: Lysosomal enzymes are made at the rough ER; the lysosome receives them and does not make them.
- D. The enzymes are still made, but they do not reach lysosomes, so worn-out cell components are digested less and accumulate. (correct)
  - authored rationale: Packaging in the Golgi complex is required to deliver enzymes to lysosomes, so digestion falls and material accumulates.

**Text 1** (109 words)
> The question asks what happens to lysosomal enzymes when the Golgi cannot package them, while their synthesis continues.
> 
> Option C says the enzymes are made inside lysosomes. The question states that ribosomes on the rough ER make them, and the drug does not affect synthesis. Lysosomes receive enzymes; they do not make them.
> 
> The defect is that the answer ignores the stated pathway. Next time, answer it differently: trace the steps (rough ER synthesis, Golgi packaging, delivery to lysosomes), identify the blocked step, and state the consequence. Here, enzymes are still made but do not reach lysosomes, so digestion falls and worn-out components accumulate. The correct answer is D.

**Text 2** (143 words)
> This question asks what happens to digestion when enzymes are made but cannot be packaged into vesicles. A correct answer must say the enzymes are still synthesized, that they fail to reach lysosomes, and that digestion drops so material builds up.
> 
> Choice C says the enzymes are made inside the lysosomes. That is wrong: the enzymes are made on the rough ER, and the lysosome only receives them after the Golgi packages them. Choice C also says digestion stays at the normal rate, which ignores the packaging block. The stem states the drug stops packaging, so delivery fails.
> 
> Next time, do two things. Trace where each step happens, then state what the drug blocks and what happens downstream. Learn this first: the rough ER makes the enzymes, and the Golgi packages them into lysosome-forming vesicles. Without packaging, lysosomes lack enzymes and digestion falls.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 16. AP Biology (student picked C)

An enzyme is heated to 95°C for 5 minutes and cooled to 25°C. Before heating, the enzyme is active, the amino acid sequence is determined, and a measurement finds that 40% of the chain is in alpha helices. After heating and cooling, activity is zero, the amino acid sequence is unchanged, the molecular mass is unchanged, and helices account for 5% of the chain. Which statement best explains the results?

- A. Heating broke peptide bonds, which changed the amino acid sequence.
  - authored rationale: The sequence is the same after heating, so peptide bonds were not broken.
- B. Heating disrupted hydrogen bonds and other weak interactions that maintain secondary and tertiary structure, but left the covalent peptide bonds and primary structure intact. (correct)
  - authored rationale: Correct: Unchanged sequence and mass show that peptide bonds were not broken, while loss of helices and activity shows the folded structure was disrupted.
- C. Heating changed the gene that codes for the enzyme, so a new protein was made.
  - authored rationale: Heating a purified protein does not change genes or make a new protein, and no DNA is present in the sample.
- D. Heating removed amino acids from the chain, which lowered the helix content.
  - authored rationale: The unchanged molecular mass shows that no amino acids were removed.

**Text 1** (140 words)
> **What the question requires:** Explain why activity and helix content dropped while the sequence and mass stayed the same. The answer must identify which level of structure changed and which bonds broke.
> 
> **What C says:** Heating altered the gene and produced a new protein. The data contradict this. The sequence and mass are unchanged, so the same protein remains, now unfolded. The sample is purified protein with no DNA.
> 
> **How the point is lost and how to earn it:** The answer ignores the measured evidence and invents an outside cause. Next time, answer differently: tie each result to the data. Unchanged sequence and mass mean no peptide bonds broke, so the loss of helices and activity must come from disrupted weak interactions. Learn this first: heat denatures proteins by breaking hydrogen bonds and other weak interactions, leaving primary structure intact.

**Text 2** (99 words)
> The question asks which statement fits data showing an unchanged sequence and mass, but lost helices and activity.
> 
> Option C's defect is that it invents a gene change and a new protein. The sample is a purified protein with no DNA, and the unchanged sequence shows the same protein is present, only unfolded.
> 
> Next time, answer by linking each result to its cause: unchanged sequence and mass rule out covalent changes, while lost helices and activity show disrupted folding.
> 
> Learn this first: heat denatures proteins by breaking weak bonds (hydrogen bonds and similar interactions) and leaves peptide bonds intact.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____

## 17. AP Biology (student picked C)

A protease that cannot cross the plasma membrane is added to two preparations of red blood cells: intact cells and cells that have been made leaky so the enzyme can reach the cytoplasm. Protein P is digested in both preparations. Protein Q is digested only in the leaky preparation. Both proteins are integral membrane proteins. Which conclusion is best supported?

- A. Protein Q is not part of the membrane, because the protease cannot reach it in intact cells.
  - authored rationale: The problem states that Q is an integral membrane protein, and its digestion in leaky cells shows it is exposed on the inner surface.
- B. Protein P has an exposed region on the outer surface of the cell, and the exposed region of protein Q faces the cytoplasm. (correct)
  - authored rationale: Correct: In intact cells the enzyme can reach only the outer surface, so digestion of P in intact cells places a domain of P outside; Q is digested only when the enzyme enters the cytoplasm, so its accessible region faces the cytoplasm.
- C. Protein P is a peripheral protein, because the protease can digest it from outside the cell.
  - authored rationale: Digestion from outside shows an exposed outer domain, but both proteins are integral, so this does not make P peripheral.
- D. Protein Q is deeper in the hydrophobic core than protein P, so it is protected from the protease on both sides.
  - authored rationale: Q is digested when the enzyme reaches the cytoplasm, which shows an accessible inner domain rather than complete protection.

**Text 1** (152 words)
> **What the question requires:** Identify which side of the membrane each protein's accessible region faces, using which preparation was digested.
> 
> **What C says:** P is peripheral because the enzyme digests it from outside. This is wrong because the stem states P is integral. Digestion from outside shows only that P has an exposed outer region, which an integral protein can also have.
> 
> **How the point is lost:** The answer misreads what the digestion shows and ignores the stem's classification. Next time, answer differently: state which side each result reveals, and keep the integral classification given in the stem. Learn this first: embedded proteins have hydrophilic regions facing water on each side, so an integral protein can be reached from outside, inside, or both.
> 
> **Correct answer, B:** P is digested in intact cells, so an outer domain is exposed. Q is digested only in leaky cells, so its accessible region faces the cytoplasm.

**Text 2** (108 words)
> The question asks which membrane surface each protein exposes, based on digestion in intact versus leaky cells. Choice C says P is peripheral because the enzyme digests it from outside. That fails because digestion from outside shows only an outer-facing domain, and the problem states both proteins are integral. To earn this point, answer it differently: link each protein's digestion pattern to a surface (outside for P, inside for Q), and reject any choice that contradicts the stated integral status. Learn this first: integral proteins span the bilayer and can expose domains on either side, while peripheral proteins sit loosely on one surface. The correct answer is B.

Better: ____   False or unsupported text (1 / 2 / none): ____   Why: ____


---

## Key (do not read until all pairs are marked)

1: Text 1 = baseline (APSTATS-MCQ-SV-095-v2)
2: Text 1 = with passage (APSTATS-MCQ-SV-H-3.8-A-v3)
3: Text 1 = baseline (APSTATS-MCQ-SV-H-2.2-B-v1)
4: Text 1 = with passage (APSTATS-MCQ-H-3.15-A)
5: Text 1 = with passage (APSTATS-MCQ-005-CAL)
6: Text 1 = baseline (APSTATS-MCQ-030)
7: Text 1 = baseline (APSTATS-MCQ-H-3.8-A)
8: Text 1 = baseline (APSTATS-OHT-2.2)
9: Text 1 = with passage (APSTATS-MCQ-SV-H-3.5-A-v3)
10: Text 1 = baseline (APSTATS-MCQ-H-3.9-A)
11: Text 1 = baseline (apbio-mcq-b6-sv-h-1.1-a-v2)
12: Text 1 = with passage (APBIO-MCQ-SV-139-v1)
13: Text 1 = baseline (apbio-mcq-b4-sv-h-4.4-b-v2)
14: Text 1 = with passage (APBIO-MCQ-SV-008-v1)
15: Text 1 = baseline (APBIO-MCQ-SV-021-v2)
16: Text 1 = baseline (apbio-mcq-b6-h-1.7-a)
17: Text 1 = with passage (apbio-mcq-b5-h-2.3-b)
