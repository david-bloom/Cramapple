# AP Statistics Unit 4: replacement and new seed drafts

DRAFT for owner review. Not checked by any checker. Not in the database. Author-in-session drafts; every number recomputed in Python (scratchpad nums4.py, tlib.py). Correct-answer position is varied on purpose and will be rebalanced at build time.
Scope (owner request 2026-11-11): rewrite the R1 seeds as R3, remove duplicates and near-twins, clean up the defective items, and add seeds for the topics with no MCQs (4.5 to 4.8).
Target level: interpretation, multi-step, or misconception reasoning; distractors are real student errors; no impossible values.

| Seed | Topic | Replaces / purpose |
|---|---|---|
| N-4.1-A | 4.1 Sampling distributions for sample means | replaces 055, 056, 059 |
| N-4.1-B | 4.1 | replaces 057 and gives the family its second seed |
| N-4.2-A | 4.2 CI for a mean | replaces 065 (z shortcut) and 062 |
| N-4.2-B | 4.2 CI for a mean | replaces 070, 096, and the misfiled proportion item 058 |
| N-4.3-A | 4.3 Claim from a CI for a mean | adds claim justification (064 only interprets) |
| N-4.4-A | 4.4 Setting up a test for a mean | replaces 069, 093 |
| N-4.5-A | 4.5 Carrying out a test for a mean | new |
| N-4.6-A | 4.6 Sampling distribution, difference of means | new |
| N-4.7-A | 4.7 CI for difference of means | new |
| N-4.8-A | 4.8 Claim from CI for difference of means | new |
| N-4.9-A | 4.9 Setting up a test for a difference | replaces 091, 099 |
| N-4.10-A | 4.10 Carrying out a test for a difference | replaces 068, 072 |

---

## Seed N-4.1-A (replaces 055, 056, 059) — Topic 4.1 Sampling Distributions for Sample Means
**Skill:** standardize a sample mean using the standard error and decide whether a normal model for x-bar is justified.

The lifetimes of a certain brand of battery have a strongly right-skewed distribution with mean 120 hours and standard deviation 24 hours. A random sample of 64 batteries is selected. What is the approximate probability that the sample mean lifetime is greater than 125 hours?

- **A. About 0.05, using a normal model for the sample mean with a standard deviation of 24/√64 = 3 hours.**
- B. About 0.42, using a normal model for individual lifetimes with a standard deviation of 24 hours.
- C. Essentially 0, using a standard deviation of 24/64 = 0.375 hours for the sample mean.
- D. It cannot be approximated with a normal model because the population is strongly skewed.

Check: SD of x-bar = 24/8 = 3; z = (125 - 120)/3 = 1.67; P(Z > 1.67) = 0.048. With n = 64 the Central Limit Theorem justifies the normal model.
Rationales: B: this treats x-bar like a single battery and uses the population standard deviation, so the spread is far too large. C: divided by n instead of the square root of n, which makes the standard deviation of x-bar too small. D: the Central Limit Theorem makes the sampling distribution of x-bar approximately normal for a large sample even when the population is skewed.

**N-4.1-A-v1.** Scores on a placement test are normally distributed with mean 50 and standard deviation 9. A random sample of 9 students is selected. What is the probability that the sample mean score is below 48?

- A. About 0.41, using a standard deviation of 9 for the sample mean.
- B. About 0.02, using a standard deviation of 9/9 = 1 for the sample mean.
- **C. About 0.25, using a standard deviation of 9/√9 = 3 for the sample mean.**
- D. It cannot be found because the sample size is less than 30.

Check: SD of x-bar = 9/3 = 3; z = (48 - 50)/3 = -0.67; P(Z < -0.67) = 0.252. The population is normal, so x-bar is exactly normal for any n.
Rationales: A: this uses the standard deviation of individual scores, not the standard deviation of the sample mean. B: divided by n instead of the square root of n, so the standard deviation of x-bar is too small. D: the sample size matters only when the population is not normal, and here the population is normal so x-bar is normal for any n.

**N-4.1-A-v2.** The weights of cereal boxes from a production line have mean 120 grams and standard deviation 24 grams, and the distribution is strongly skewed. A random sample of 100 boxes is selected. What is the approximate probability that the sample mean weight is between 118 and 122 grams?

- A. About 0.07, using a standard deviation of 24 grams for the sample mean.
- **B. About 0.60, using a normal model with a standard deviation of 24/√100 = 2.4 grams.**
- C. About 1.00, using a standard deviation of 24/100 = 0.24 grams.
- D. About 0.68, because 118 and 122 are within one standard deviation of 120.

Check: SD of x-bar = 2.4; z = ±2/2.4 = ±0.83; P(-0.83 < Z < 0.83) = 0.595.
Rationales: A: this uses the population standard deviation, which describes individual boxes, not the spread of sample means. C: divided by n instead of the square root of n, making the standard deviation of x-bar much too small and the probability nearly 1. D: the 68% rule applies to one standard deviation of the sampling distribution, which is 2.4 grams, not the 24 grams of the population.

**N-4.1-A-v3.** The weights of cereal boxes from a production line have mean 120 grams and standard deviation 24 grams, and the distribution is strongly right-skewed. A random sample of only 20 boxes is selected. Which statement about finding P(x-bar > 125) is correct?

- A. About 0.18, because x-bar is approximately normal with a standard deviation of 24/√20 = 5.4 grams.
- B. About 0.42, because x-bar has a standard deviation of 24 grams.
- C. Essentially 0, because x-bar has a standard deviation of 24/20 = 1.2 grams.
- **D. A normal calculation is not justified, because the sample is small and the population is strongly skewed.**

Check: with n = 20 and strong skew, the Central Limit Theorem does not yet justify a normal model, so any normal probability, including 0.18 from a standard deviation of 5.4, is not trustworthy.
Rationales: A: the standard deviation of 5.4 is right, but the normal shape is not justified for n = 20 from a strongly skewed population. B: this also uses the wrong standard deviation, the population value, for the sample mean. C: divided by n instead of the square root of n, which gives a standard deviation far too small.

---

## Seed N-4.1-B (replaces 057) — Topic 4.1
**Skill:** separate the center and spread of a sampling distribution of x-bar from the population, and see what changes with n.

A population has mean 40 and standard deviation 12. Ana takes many random samples of size 25 and Ben takes many random samples of size 100, and each records the sample mean from every sample. Which statement is correct?

- A. Both sets of sample means have a standard deviation of 12, because sample means vary as much as individual values do.
- **B. Ben's sample means vary less: their standard deviation is 1.2, compared with 2.4 for Ana's, and both sets are centered at 40.**
- C. Ana's sample means have a standard deviation of 0.48 and Ben's have 0.12, because the standard deviation is divided by n.
- D. Ben's sample means are centered closer to 40 than Ana's, because a larger sample reduces bias.

Check: SD for Ana = 12/5 = 2.4; SD for Ben = 12/10 = 1.2; both sampling distributions have mean 40 because x-bar is unbiased.
Rationales: A: the standard deviation of x-bar is the population value divided by the square root of n, so it is smaller than 12. C: divided by n instead of the square root of n. D: x-bar is unbiased at every sample size, so both distributions are centered at 40 and a larger n only reduces the spread.

**N-4.1-B-v1.** A population has standard deviation 15. A researcher currently uses samples of size 25, so the standard deviation of the sample mean is 3. How large must the samples be to cut the standard deviation of the sample mean to 1.5?

- A. 50
- B. 75
- **C. 100**
- D. 625

Check: 15/√n = 1.5 gives √n = 10, so n = 100. Halving the standard deviation requires four times the sample size.
Rationales: A: doubling n only divides the standard deviation by √2, not by 2. B: tripling n does not halve the standard deviation, since the spread falls with the square root of n. D: squared the original n, but halving the spread needs a factor of 4 on n, not n squared.

**N-4.1-B-v2.** Scores on a standardized test are normally distributed with mean 50 and standard deviation 10. Compare P(one randomly chosen student scores above 54) with P(the mean of 25 randomly chosen students is above 54). Which statement is correct?

- A. Both probabilities are about 0.34, because the mean and the individual have the same distribution.
- **B. The first is about 0.34 and the second is about 0.02, because the sample mean has a standard deviation of 2.**
- C. The first is about 0.02 and the second is about 0.34, because larger samples make high values more likely.
- D. Both probabilities are about 0.02, because averaging only changes the center.

Check: individual z = 4/10 = 0.4, P = 0.345; sample mean z = 4/(10/5) = 2.0, P = 0.023.
Rationales: A: the mean of 25 scores varies much less than one score, so extreme means are rarer than extreme individuals. C: this reverses the two probabilities; averaging makes a value 4 above the mean harder to reach, not easier. D: averaging does not change the center, but it shrinks the spread, which changes the probability for the individual value.

**N-4.1-B-v3.** Repeated random samples of size 36 are taken from a population with mean 80 and standard deviation 18. Which statement describes the sampling distribution of the sample mean?

- A. Its mean is 80 and its standard deviation is 18.
- B. Its mean is 13.3 and its standard deviation is 3.
- **C. Its mean is 80 and its standard deviation is 3.**
- D. Its mean is 80 and its standard deviation is 0.5.

Check: mean of x-bar = 80; SD = 18/√36 = 3.
Rationales: A: the standard deviation of x-bar is not the population standard deviation; it is divided by the square root of n. B: the center of x-bar equals the population mean and is not divided by anything. D: divided 18 by n = 36 instead of by its square root.

---

## Seed N-4.2-A (replaces 065, 062) — Topic 4.2 Constructing a Confidence Interval for a Population Mean
**Skill:** build a t-interval for a mean with a small sample, using the standard error and a t critical value.

A researcher measures the nightly sleep, in hours, of a random sample of 9 college students. The sample values are roughly symmetric with no outliers, and the sample has mean 6.8 hours and standard deviation 1.2 hours. For df = 8, t* = 2.306 at 95% confidence. What is the 95% confidence interval for the population mean?

- A. (4.03, 9.57)
- **B. (5.88, 7.72)**
- C. (6.02, 7.58)
- D. (6.49, 7.11)

Check: SE = 1.2/√9 = 0.4; margin = 2.306 x 0.4 = 0.92; interval 6.8 ± 0.92 = (5.88, 7.72).
Rationales: A: used the standard deviation instead of the standard error, so the margin is far too wide. C: used z* = 1.96 in place of the t critical value, which understates the margin for a sample this small. D: divided s by n instead of the square root of n when finding the standard error.

**N-4.2-A-v1.** A lab measures the concentration of a chemical in 6 independent water samples. The data are roughly symmetric with no outliers; the mean is 52 and the standard deviation is 8. For df = 5, t* = 2.015 at 90% confidence. What is the 90% confidence interval for the mean concentration?

- A. (46.63, 57.37)
- B. (35.88, 68.12)
- C. (49.31, 54.69)
- **D. (45.42, 58.58)**

Check: SE = 8/√6 = 3.266; margin = 2.015 x 3.266 = 6.58; interval (45.42, 58.58).
Rationales: A: used z* = 1.645, which ignores the extra uncertainty from estimating the standard deviation with a sample of 6. B: used the standard deviation instead of the standard error, so the margin is much too large. C: divided s by n instead of √n when computing the standard error.

**N-4.2-A-v2.** The lengths of 12 randomly selected trout from a lake have mean 14.2 inches and standard deviation 3.0 inches, and the data are roughly symmetric with no outliers. For df = 11, t* = 3.106 at 99% confidence. What is the 99% confidence interval for the mean length?

- **A. (11.51, 16.89)**
- B. (11.97, 16.43)
- C. (4.88, 23.52)
- D. (13.42, 14.98)

Check: SE = 3.0/√12 = 0.866; margin = 3.106 x 0.866 = 2.69; interval (11.51, 16.89).
Rationales: B: used z* = 2.576 instead of the t critical value, so the interval is too narrow. C: used the standard deviation instead of the standard error. D: divided s by n instead of √n, which makes the standard error much too small.

**N-4.2-A-v3.** A sample of 8 measurements from an approximately normal population has mean 30 and standard deviation 5. For df = 7, t* = 2.998 at 98% confidence. What is the 98% confidence interval for the population mean?

- A. (25.89, 34.11)
- **B. (24.70, 35.30)**
- C. (28.13, 31.87)
- D. (15.01, 44.99)

Check: SE = 5/√8 = 1.768; margin = 2.998 x 1.768 = 5.30; interval (24.70, 35.30).
Rationales: A: used z* = 2.326 instead of the t critical value. C: divided s by n instead of √n, which makes the standard error and the margin far too small. D: used the standard deviation in place of the standard error, so the margin is much too wide.

---

## Seed N-4.2-B (replaces 070, 096, 058) — Topic 4.2
**Skill:** plan a sample size for a desired margin of error for a mean, and see how n and confidence level change an interval.

A researcher plans a 95% confidence interval for a population mean. A pilot study suggests the population standard deviation is about 10, and she wants a margin of error of at most 2. Using z* = 1.96 for planning, what is the smallest sample size that guarantees this margin of error?

- A. 25
- B. 10
- C. 96
- **D. 97**

Check: n >= (1.96 x 10 / 2)^2 = 96.04, so n = 97.
Rationales: A: left out the critical value, computing (10/2)^2. B: found 1.96 x 10/2 = 9.8 but forgot to square it. C: rounded 96.04 down, which would give a margin slightly larger than 2.

**N-4.2-B-v1.** A researcher plans a 90% confidence interval for a population mean. A pilot study suggests the population standard deviation is about 15, and she wants a margin of error of at most 3. Using z* = 1.645, what is the smallest sample size that guarantees this margin of error?

- A. 25
- B. 67
- **C. 68**
- D. 9

Check: n >= (1.645 x 15 / 3)^2 = 67.65, so n = 68.
Rationales: A: left out the critical value, computing (15/3)^2. B: rounded 67.65 down, which gives a margin slightly above 3. D: computed 1.645 x 15/3 = 8.2 and rounded it up without squaring.

**N-4.2-B-v2.** A 95% confidence interval for a population mean based on a random sample of 36 has a width of 6. About how large a sample is needed to get a 95% interval of width 3, assuming the sample standard deviation stays about the same?

- A. 72
- B. 108
- C. 18
- **D. 144**

Check: halving the width halves the margin of error, which requires four times the sample size: 36 x 4 = 144.
Rationales: A: doubling n divides the margin by only √2, not 2. B: tripling n divides the margin by √3, not 2. C: this reduces the sample size, which would widen the interval.

**N-4.2-B-v3.** A 95% confidence interval for a population mean, based on a random sample of 25 from an approximately normal population, is (40, 48). Use t* = 2.064 for 95% and t* = 2.797 for 99% (df = 24). If a 99% interval is built from the same data, which interval results?

- A. (40, 48)
- B. (41.0, 47.0)
- C. (39.83, 48.17)
- **D. (38.58, 49.42)**

Check: the 95% margin is 4, so SE = 4/2.064 = 1.938; the 99% margin is 2.797 x 1.938 = 5.42; interval 44 ± 5.42 = (38.58, 49.42).
Rationales: A: the interval depends on the confidence level, so changing from 95% to 99% changes the endpoints. B: higher confidence needs a larger critical value and a wider interval, not a narrower one. C: scaled the margin by 99/95, but the margin scales with the ratio of critical values, 2.797/2.064.

---

## Seed N-4.3-A (adds claim justification) — Topic 4.3 Justifying a Claim Based on a Confidence Interval for a Population Mean
**Skill:** use whether a claimed value falls inside an interval, and avoid reading the interval as a statement about individual values or probabilities.

A company claims that the mean life of its batteries is 14 hours. A random sample of batteries is tested, and a 95% confidence interval for the mean life is (11.2, 13.8) hours. Which conclusion is justified?

- A. The claim is still supported, because 14 is only 0.2 above the upper endpoint.
- B. There is a 5% chance that the claim is true.
- C. About 95% of these batteries last between 11.2 and 13.8 hours, so the claim is false.
- **D. Because 14 is not in the interval, 14 is not a plausible value for the mean life, so there is convincing evidence the mean differs from 14 hours.**

Check: 14 lies outside (11.2, 13.8), so a two-sided test at the 5% level would reject a mean of 14.
Rationales: A: a value just outside the interval is still outside, so it is not a plausible value at this confidence level. B: the interval does not give a probability that a claimed value is true; the parameter is fixed. C: the interval describes the population mean, not the spread of individual battery lives.

**N-4.3-A-v1.** A coach claims that the mean time to finish a run is 50 minutes. A 95% confidence interval for the mean time, from a random sample of runners, is (46.1, 52.7) minutes. Which conclusion is justified?

- A. The data prove the mean is 50 minutes.
- **B. There is not convincing evidence that the mean differs from 50 minutes, because 50 is a plausible value in the interval.**
- C. The mean is more likely to be 50 than any other value, because 50 is close to the middle of the interval.
- D. About 95% of the runners finish between 46.1 and 52.7 minutes.

Check: 50 is inside (46.1, 52.7), so it is a plausible value and the data do not contradict the claim; the data do not prove it either.
Rationales: A: an interval that contains the claimed value fails to contradict it but cannot prove it, since many other values are also plausible. C: every value in the interval is plausible, and the interval does not rank values by probability. D: the interval is about the population mean, not the spread of individual finishing times.

**N-4.3-A-v2.** A 95% confidence interval for a population mean is (3.1, 4.9). A student tests H0: μ = 5 against Ha: μ ≠ 5 at the 5% significance level. Which conclusion follows from the interval?

- A. The p-value is greater than 0.05, because 5 is close to the interval.
- B. The p-value equals 0.05, because the interval has 95% confidence.
- **C. The p-value is less than 0.05, because 5 is not in the interval.**
- D. Nothing can be said, because intervals and tests are unrelated.

Check: a 95% interval and a two-sided test at the 5% level agree; 5 lies outside the interval, so H0 is rejected and p < 0.05.
Rationales: A: closeness does not matter; any value outside the interval is rejected by the matching two-sided test. B: the confidence level sets the cutoff of 0.05, but the p-value itself is below it when the value is outside the interval. D: a confidence interval and a two-sided test at the matching level give the same decision.

**N-4.3-A-v3.** To test whether a tutoring program changes test scores, researchers record the score difference (after - before) for each of 20 randomly chosen students. A 95% confidence interval for the population mean difference is (-3.4, 0.6) points. Which conclusion is justified?

- A. The program lowers scores, because more of the interval is negative than positive.
- B. The program has no effect on scores.
- C. About 95% of students had a change between -3.4 and 0.6 points.
- **D. There is not convincing evidence that the program changes the mean score, because 0 is in the interval.**

Check: 0 is inside (-3.4, 0.6), so a mean difference of 0 is plausible, but the data do not prove it.
Rationales: A: the position of the center within the interval does not matter; any interval containing 0 allows no change as a plausible value. B: failing to find evidence of an effect is not the same as proving there is no effect. C: the interval is about the mean difference, not individual students.

---

## Seed N-4.4-A (replaces 069, 093) — Topic 4.4 Setting Up a Test for a Population Mean
**Skill:** write hypotheses about a parameter that match the claim and the suspicion, and avoid using the sample result.

A cereal box states that the mean sodium per serving is 250 mg. An inspector suspects the true mean is higher and measures 30 randomly chosen servings, finding a sample mean of 262 mg. Which hypotheses should be tested, where μ is the true mean sodium per serving?

- **A. H0: μ = 250 and Ha: μ > 250**
- B. H0: x-bar = 250 and Ha: x-bar > 250
- C. H0: μ = 262 and Ha: μ > 262
- D. H0: μ = 250 and Ha: μ ≠ 250

Check: the null states the claimed value and the alternative reflects the suspicion of a higher mean, both about the parameter μ.
Rationales: B: hypotheses are about the population parameter, not the sample mean. C: the null value comes from the claim, not from the sample result. D: the inspector suspects the mean is higher, so a two-sided alternative does not match the question.

**N-4.4-A-v1.** Twelve students take a test before and after a tutoring program. Let d = after - before for each student, and let μd be the population mean of these differences. The tutor believes the program improves scores. Which hypotheses should be tested?

- A. H0: μd = 0 and Ha: μd < 0
- B. H0: μd > 0 and Ha: μd = 0
- **C. H0: μd = 0 and Ha: μd > 0**
- D. H0: μd = 0 and Ha: μd ≠ 0

Check: with d = after - before, an improvement means a positive mean difference, so the alternative is μd > 0.
Rationales: A: this sign would describe a decrease; with d = after - before, improvement is positive. B: the null hypothesis must contain equality, and here it is placed on the wrong side. D: a two-sided alternative does not match the tutor's belief that scores improve.

**N-4.4-A-v2.** A coffee shop labels its cups as holding 12 oz. A regulator wants to know whether the true mean fill differs from 12 oz and finds a mean of 11.8 oz in a random sample of 40 cups. Which hypotheses should be tested?

- A. H0: μ = 12 and Ha: μ < 12
- **B. H0: μ = 12 and Ha: μ ≠ 12**
- C. H0: μ = 11.8 and Ha: μ ≠ 11.8
- D. H0: μ ≠ 12 and Ha: μ = 12

Check: the regulator asks whether the mean differs from 12, which is two-sided, and the null uses the labeled value.
Rationales: A: the sample mean is below 12, but the question was set before seeing the data, so the alternative must be two-sided. C: the null value is the labeled value, not the observed sample mean. D: the null hypothesis must contain equality, and the alternative states the difference.

**N-4.4-A-v3.** A battery maker states that the mean life of its batteries is 10 hours. A consumer group suspects the mean life is shorter, and a random sample of 25 batteries has mean 9.4 hours. Which hypotheses should be tested?

- **A. H0: μ = 10 and Ha: μ < 10**
- B. H0: μ = 10 and Ha: μ > 10
- C. H0: μ = 9.4 and Ha: μ < 9.4
- D. H0: μ < 10 and Ha: μ = 10

Check: null is the stated mean; the alternative matches the suspicion of a shorter life.
Rationales: B: the consumer group suspects a shorter life, so the alternative points the other way here. C: the null value comes from the claim, not from the sample mean. D: the null must hold the equality, and the suspicion belongs in the alternative.

---

## Seed N-4.5-A (new) — Topic 4.5 Carrying Out a Test for a Population Mean
**Skill:** compute t and the p-value for a one-sided mean test and state the conclusion correctly.

A cereal box states that the mean sodium per serving is 250 mg. An inspector tests H0: μ = 250 versus Ha: μ > 250 using a random sample of 25 servings, which has mean 262 mg and standard deviation 30 mg. The sampling distribution is approximately normal. Which is the correct result and conclusion at the 5% level?

- A. t = 0.40 and p ≈ 0.35, so there is not convincing evidence that the mean exceeds 250 mg.
- B. t = 2.00 and p ≈ 0.06, so there is not convincing evidence that the mean exceeds 250 mg.
- C. t = 2.00 and p ≈ 0.03, so there is about a 3% chance that the mean is 250 mg.
- **D. t = 2.00 and p ≈ 0.03, so there is convincing evidence that the mean exceeds 250 mg.**

Check: SE = 30/√25 = 6; t = 12/6 = 2.00; df = 24; one-sided p = 0.0285 < 0.05, so reject H0.
Rationales: A: divided by s instead of the standard error, giving a t statistic far too small. B: doubled the p-value for a two-sided test even though the alternative is one-sided. C: a p-value is the probability of data this extreme if H0 is true, not the probability that H0 is true.

**N-4.5-A-v1.** A random sample of 16 observations from an approximately normal population has mean 47.2 and standard deviation 6. To test H0: μ = 50 versus Ha: μ ≠ 50, which is the correct result and conclusion at the 5% level?

- A. t = -1.87 and p ≈ 0.04, so there is convincing evidence that the mean differs from 50.
- B. t = -0.47 and p ≈ 0.65, so there is not convincing evidence that the mean differs from 50.
- **C. t = -1.87 and p ≈ 0.08, so there is not convincing evidence that the mean differs from 50.**
- D. t = -7.47 and p < 0.001, so there is convincing evidence that the mean differs from 50.

Check: SE = 6/√16 = 1.5; t = -2.8/1.5 = -1.87; df = 15; two-sided p = 0.082 > 0.05, so fail to reject H0.
Rationales: A: used a single tail even though the alternative is two-sided, which halves the p-value and flips the conclusion. B: divided the difference by s instead of the standard error. D: divided s by n instead of √n, which inflates the t statistic.

**N-4.5-A-v2.** Ten randomly chosen students take a reading test before and after a program. The mean of the differences (after - before) is 3.1 points with a standard deviation of 4.0, and the differences are roughly symmetric with no outliers. To test H0: μd = 0 versus Ha: μd > 0, which is correct at the 5% level?

- **A. t = 2.45 with df = 9 and p ≈ 0.02, so there is convincing evidence that the mean difference is positive.**
- B. t = 0.78 and p ≈ 0.23, so there is not convincing evidence that the mean difference is positive.
- C. t = 2.45 and p ≈ 0.04 using a two-sided p-value, so the evidence is only borderline.
- D. t = 2.45 and p ≈ 0.02, so there is a 2% chance that the mean difference is 0.

Check: SE = 4.0/√10 = 1.265; t = 3.1/1.265 = 2.45; df = 9; one-sided p = 0.018 < 0.05.
Rationales: B: divided by the standard deviation instead of the standard error. C: the alternative is one-sided, so the p-value is not doubled. D: the p-value is not the probability that the null hypothesis is true.

**N-4.5-A-v3.** A random sample of 36 observations has mean 102.5 and standard deviation 15. To test H0: μ = 100 versus Ha: μ ≠ 100, which is the correct result and conclusion at the 5% level?

- A. t = 1.00 and p ≈ 0.16, so there is convincing evidence that the mean differs from 100.
- B. t = 1.00 and p ≈ 0.32, so the data show that the mean equals 100.
- **C. t = 1.00 and p ≈ 0.32, so there is not convincing evidence that the mean differs from 100.**
- D. t = 6.00 and p < 0.001, so there is convincing evidence that the mean differs from 100.

Check: SE = 15/√36 = 2.5; t = 2.5/2.5 = 1.00; df = 35; two-sided p = 0.324.
Rationales: A: used one tail for a two-sided alternative, and a p of 0.16 would still not be below 0.05. B: failing to reject does not prove the null; it only means the data are consistent with it. D: divided s by n instead of √n, which inflates the t statistic.

---

## Seed N-4.6-A (new) — Topic 4.6 Sampling Distributions for the Difference Between Two Sample Means
**Skill:** find the center and spread of x-bar1 minus x-bar2 for independent samples.

Population 1 has mean 70 and standard deviation 12, and population 2 has mean 64 and standard deviation 10. An independent random sample of 36 is taken from population 1 and a random sample of 25 from population 2. What are the mean and standard deviation of the sampling distribution of x-bar1 - x-bar2?

- A. Mean 6, standard deviation 2.0.
- B. Mean 6, standard deviation 8.
- **C. Mean 6, standard deviation 2.83.**
- D. Mean 6, standard deviation 4.

Check: mean = 70 - 64 = 6; SD = sqrt(144/36 + 100/25) = sqrt(4 + 4) = 2.83.
Rationales: A: this pools everything as if both samples were one combined group instead of adding the two variances. B: this is the variance 4 + 4 and was never square-rooted. D: added the two standard errors, 2 + 2, instead of adding the variances and taking the square root.

**N-4.6-A-v1.** Population 1 has mean 70 and standard deviation 12, and population 2 has mean 64 and standard deviation 10. Independent random samples of 36 and 25 are taken, respectively, and both sampling distributions are approximately normal. What is the probability that the sample mean from population 1 is greater than the sample mean from population 2?

- A. About 0.50, because the samples are the same kind of random sample.
- B. About 0.65, using the population standard deviations without dividing by the sample sizes.
- **C. About 0.98, because x-bar1 - x-bar2 has mean 6 and standard deviation 2.83.**
- D. About 0.02, because the difference is more likely to be negative.

Check: P(x-bar1 - x-bar2 > 0) = P(Z > -6/2.83) = P(Z > -2.12) = 0.983.
Rationales: A: the two means differ by 6 and the standard deviation of the difference is only 2.83, so a result above 0 is far from a coin flip. B: this uses the spread of individual values, sqrt(144 + 100) = 15.6, instead of the spread of the sample means. D: this reverses the direction; the mean difference is positive, so the sample difference is likely to be positive.

**N-4.6-A-v2.** Two independent random samples, each of size 30, are taken from two populations. If both sample sizes are doubled to 60 and the population standard deviations stay the same, what happens to the standard deviation of x-bar1 - x-bar2?

- A. It is cut in half.
- B. It stays the same, since the population standard deviations did not change.
- C. It doubles.
- **D. It is multiplied by about 0.71, which is 1/√2.**

Check: SD = sqrt(σ1²/n1 + σ2²/n2); doubling both n divides the inside by 2, so SD is multiplied by 1/√2 = 0.71.
Rationales: A: halving the standard deviation would require four times the sample sizes, not two times. B: the sample sizes appear in the standard deviation of the difference, so changing them changes it. C: larger samples reduce the spread of the difference; they do not increase it.

**N-4.6-A-v3.** Two independent random samples of sizes 12 and 14 are taken from two strongly right-skewed populations. Which statement is correct about using a normal model for x-bar1 - x-bar2?

- A. It is justified, because the samples are independent and random.
- B. It is justified, because the combined sample size is more than 25.
- C. It is justified, because the difference of two skewed distributions is always symmetric.
- **D. It is not justified, because both samples are small and both populations are strongly skewed.**

Check: with small samples from strongly skewed populations, the Central Limit Theorem does not yet apply to either sample mean.
Rationales: A: independence and randomness are needed, but they do not make a small sample from a skewed population approximately normal. B: the sample sizes are checked separately for each sample; adding them does not help. C: subtracting two skewed distributions does not remove the skewness of each sample mean.

---

## Seed N-4.7-A (new) — Topic 4.7 Constructing a Confidence Interval for the Difference Between Two Population Means
**Skill:** build a two-sample t interval from summary statistics, using the correct standard error and order of subtraction.

Independent random samples of 30 students from each of two schools give the following test scores. School 1 has mean 82 and standard deviation 10; school 2 has mean 76 and standard deviation 12. Both samples are roughly symmetric. Using t* = 2.00, which is the 95% confidence interval for μ1 - μ2?

- A. (-2.03, 14.03)
- **B. (0.30, 11.70)**
- C. (-25.24, 37.24)
- D. (-11.70, -0.30)

Check: SE = sqrt(100/30 + 144/30) = 2.85; margin = 2.00 x 2.85 = 5.70; interval 6 ± 5.70 = (0.30, 11.70).
Rationales: A: added the two separate standard errors, 1.83 + 2.19, instead of adding the variances and taking the square root. C: forgot to divide by the sample sizes inside the square root, so the standard error is far too large. D: subtracted in the wrong order; the question asks for μ1 - μ2 with school 1 first.

**N-4.7-A-v1.** Independent random samples give these results: sample 1 has n = 40, mean 15.2, standard deviation 3.0; sample 2 has n = 35, mean 13.9, standard deviation 2.4. Both are roughly symmetric. Using t* = 1.68, which is the 90% confidence interval for μ1 - μ2?

- A. (0.65, 1.95)
- B. (-2.35, -0.25)
- **C. (0.25, 2.35)**
- D. (-0.18, 2.78)

Check: SE = sqrt(9/40 + 5.76/35) = 0.624; margin = 1.68 x 0.624 = 1.05; interval 1.3 ± 1.05 = (0.25, 2.35).
Rationales: A: added the two variances over n but did not take the square root, so the margin is too small. B: subtracted in the wrong order, giving the interval for μ2 - μ1. D: added the two standard errors instead of adding the variances first, which widens the interval across 0.

**N-4.7-A-v2.** A 95% confidence interval for μA - μB, where μA and μB are the mean completion times in seconds for two tasks, is (2.1, 7.9). Which interpretation is correct?

- A. About 95% of individual A times are 2.1 to 7.9 seconds greater than individual B times.
- B. There is a 95% probability that the difference in sample means is between 2.1 and 7.9 seconds.
- **C. We are 95% confident that the mean time for A is greater than the mean time for B by between 2.1 and 7.9 seconds.**
- D. The mean time for A is between 2.1 and 7.9 seconds.

Check: the interval estimates the difference in population means, μA - μB.
Rationales: A: the interval is about the difference in means, not about individual times. B: the sample difference is known, and the interval is a statement about the population difference. D: the interval is for the difference between the two means, not for the mean of A.

**N-4.7-A-v3.** A 95% confidence interval for μ1 - μ2 is (-1.2, 5.6). What are the difference in sample means and the margin of error?

- A. Difference 2.2 and margin of error 6.8.
- B. Difference 3.4 and margin of error 2.2.
- **C. Difference 2.2 and margin of error 3.4.**
- D. Difference 5.6 and margin of error 1.2.

Check: the center is (-1.2 + 5.6)/2 = 2.2 and the half-width is (5.6 - (-1.2))/2 = 3.4.
Rationales: A: used the full width of the interval as the margin of error instead of half the width. B: swapped the center and the half-width, treating the margin of error as the difference in sample means. D: used the endpoints as the difference and margin of error.

---

## Seed N-4.8-A (new) — Topic 4.8 Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Means
**Skill:** decide whether an interval for a difference supports a claim, including the case where 0 is plausible.

In a randomized experiment, a 95% confidence interval for μtreatment - μcontrol, the difference in mean weight loss in kilograms, is (-0.4, 6.8). A manager claims the treatment increases mean weight loss. Which conclusion is justified?

- A. The treatment increases weight loss, because most of the interval is positive.
- B. The treatment has no effect on weight loss.
- C. There is a 95% chance that the true difference is positive.
- **D. There is not convincing evidence of a difference, because 0 is in the interval.**

Check: the interval contains 0, so no difference is a plausible value and the claim of an increase is not justified at this confidence level.
Rationales: A: the proportion of the interval that is positive does not matter; if 0 is in the interval, no difference is plausible. B: failing to find convincing evidence of a difference does not prove there is no difference. C: the interval does not give the probability that the true difference is positive.

**N-4.8-A-v1.** A 95% confidence interval for μA - μB, the difference in mean reaction time in milliseconds between two groups, is (1.2, 5.4). Which conclusion is justified?

- A. The difference in the sample means is exactly 5.4 milliseconds.
- B. Every individual in group A is slower than every individual in group B.
- **C. There is convincing evidence that group A has a greater mean reaction time than group B.**
- D. There is no convincing evidence of a difference, because the interval is narrow.

Check: the interval lies entirely above 0, so μA - μB > 0 at the 95% level.
Rationales: A: the interval gives a range, and the sample difference is its midpoint, 3.3. B: the interval concerns the difference in means, not each individual. D: the width of the interval does not decide the conclusion; whether it contains 0 does.

**N-4.8-A-v2.** In a study of two teaching methods, a 95% confidence interval for the mean score under method 1 is (62.0, 70.0) and a 95% confidence interval for the mean score under method 2 is (68.0, 76.0). The two samples have the same size and similar variability, and the intervals overlap. A student concludes there is no convincing evidence of a difference. Which statement is correct?

- A. The student is correct, because overlapping intervals always mean no difference.
- **B. The conclusion is not justified, because the interval for the difference must be examined, and it can exclude 0 even when the separate intervals overlap.**
- C. The student is wrong, because method 2 has a higher mean in the samples.
- D. The student is correct, because two 95% intervals together give 90% confidence.

Check: each separate interval has margin 4, so each standard error is about 2.04; the difference in sample means is 72 - 66 = 6, and the standard error of the difference is sqrt(2.04² + 2.04²) = 2.89, so the interval for the difference is about 6 ± 1.96(2.89) = (0.3, 11.7), which excludes 0.
Rationales: A: overlapping separate intervals do not prove there is no difference, because the standard error of the difference is smaller than the sum of the two standard errors. C: a larger sample mean in one group is not enough; the decision depends on the interval for the difference. D: the confidence level of the difference interval is set by its own construction, not by combining two intervals.

**N-4.8-A-v3.** A 95% confidence interval for μ1 - μ2 is (-5.1, -0.9). A researcher tests H0: μ1 - μ2 = 0 versus Ha: μ1 - μ2 ≠ 0 at the 5% level. Which conclusion follows from the interval?

- A. Fail to reject H0, because the interval includes negative values.
- **B. Reject H0, and there is convincing evidence that μ2 is greater than μ1.**
- C. Reject H0, and there is convincing evidence that μ1 is greater than μ2.
- D. Fail to reject H0, because the interval is entirely on one side.

Check: the interval excludes 0 and is entirely negative, so μ1 - μ2 < 0, which means μ2 is greater than μ1.
Rationales: A: negative values are not a reason to retain H0; what matters is whether 0 is in the interval. C: a negative difference μ1 - μ2 means the second mean is larger. D: an interval that lies entirely on one side of 0 is evidence against H0, not for it.

---

## Seed N-4.9-A (replaces 091, 099) — Topic 4.9 Setting Up a Test for the Difference Between Two Population Means
**Skill:** choose between a two-sample and a paired design from how data were collected, and write matching hypotheses.

A researcher randomly assigns 40 volunteers to two groups of 20. One group uses a new study app and the other uses an old one, and each volunteer's weekly study time is recorded. The researcher wants to know whether the new app leads to a lower mean study time than the old app. Which setup is appropriate, where μN and μO are the true mean study times?

- A. A paired t test, because there are two sets of study times.
- B. A two-sample t test with H0: μN - μO = 0 and Ha: μN - μO > 0.
- **C. A two-sample t test with H0: μN - μO = 0 and Ha: μN - μO < 0.**
- D. A two-sample t test with H0: x-bar_N - x-bar_O = 0 and Ha: x-bar_N - x-bar_O < 0.

Check: the groups are independent, so a two-sample t test applies; "lower" means μN - μO < 0.
Rationales: A: a paired test requires that each observation in one group be linked to one in the other, which is not the case when volunteers are randomly split. B: the researcher expects the new app to give a lower mean, so a greater-than alternative points the wrong way. D: hypotheses are about the population means, not the sample means.

**N-4.9-A-v1.** To compare two running shoes, 15 pairs of identical twins are used. In each pair, one twin is randomly assigned to shoe A and the other to shoe B, and each runs the same course. Which setup is appropriate?

- A. A two-sample t test, because there are two groups of runners.
- **B. A paired t test on the 15 within-pair differences.**
- C. A two-proportion z test comparing runners who finish.
- D. A two-sample t test, because the runners in the two groups are different people.

Check: each twin in one group is matched to a twin in the other, so the data are paired and the analysis uses the differences.
Rationales: A: two groups exist, but the observations are matched by pair, so they are not independent samples. C: the response is a time, which is quantitative, not a proportion. D: different people does not mean independent; the twin pairs link the two groups.

**N-4.9-A-v2.** A researcher compares the mean wait times at two clinics using independent random samples of 12 patients from one clinic and 15 from the other. Dotplots of each sample show roughly symmetric shapes with no outliers. Which statement about the conditions for a two-sample t procedure is correct?

- A. The conditions are not met, because the sample sizes differ.
- B. The conditions are not met, because the two standard deviations are not known to be equal.
- C. The conditions are met only if the combined data from both clinics look approximately normal.
- **D. The conditions are met, because the samples are random and independent, and each sample is roughly symmetric with no outliers.**

Check: a two-sample t procedure requires random, independent samples, and each sample should not show strong skew or outliers when n is small.
Rationales: A: the two sample sizes can differ; the unpooled t procedure does not require equal sizes. B: the unpooled two-sample t procedure does not require equal standard deviations. C: normality is checked for each sample separately, not for the combined data.

**N-4.9-A-v3.** Random samples of 40 vegetarians and 40 non-vegetarians have mean cholesterol levels of 182 and 191 mg/dL. A researcher wants to know whether mean cholesterol differs between the two populations. Which hypotheses should be tested, where μV and μN are the population mean cholesterol levels?

- A. H0: x-bar_V = x-bar_N and Ha: x-bar_V ≠ x-bar_N
- B. H0: μV - μN = 0 and Ha: μV - μN < 0
- **C. H0: μV - μN = 0 and Ha: μV - μN ≠ 0**
- D. H0: μV - μN = 9 and Ha: μV - μN ≠ 9

Check: the question asks whether the means differ, so the alternative is two-sided and the null difference is 0.
Rationales: A: hypotheses concern the population means, not the sample means. B: the sample direction should not decide the alternative; the question asks only whether the means differ. D: the null value is 0, the no-difference value, not the observed sample difference.

---

## Seed N-4.10-A (replaces 068, 072) — Topic 4.10 Carrying Out a Test for the Difference Between Two Population Means
**Skill:** compute and interpret a two-sample t statistic and p-value, and state the conclusion in context.

Two independent random samples of 40 students from two schools give test scores: school 1 has mean 78 and standard deviation 10; school 2 has mean 73 and standard deviation 12. Both samples are roughly symmetric. To test H0: μ1 - μ2 = 0 versus Ha: μ1 - μ2 > 0, which is the correct result and conclusion at the 5% level?

- A. t = 0.32 and p ≈ 0.37, so there is not convincing evidence that school 1 has the higher mean.
- B. t = 2.86 and p ≈ 0.003, using a standard error of 1.75.
- C. t = 2.02 and p ≈ 0.02, so there is a 2% chance that the two means are equal.
- **D. t = 2.02 and p ≈ 0.02, so there is convincing evidence that the mean score at school 1 is higher.**

Check: SE = sqrt(100/40 + 144/40) = 2.47; t = 5/2.47 = 2.02; df ≈ 76; one-sided p = 0.023.
Rationales: A: forgot to divide the variances by the sample sizes, so the standard error and the t value are wrong. B: divided the combined variance by the total sample size, which understates the standard error. C: a p-value is not the probability that the null hypothesis is true.

**N-4.10-A-v1.** Independent random samples give these results: sample 1 has n = 25, mean 14.1, standard deviation 3.2; sample 2 has n = 30, mean 12.9, standard deviation 2.8. Both are roughly symmetric. To test H0: μ1 - μ2 = 0 versus Ha: μ1 - μ2 ≠ 0, which is correct at the 5% level?

- A. t = 1.47 and p ≈ 0.07, so there is convincing evidence of a difference in means.
- **B. t = 1.47 and p ≈ 0.15, so there is not convincing evidence of a difference in means.**
- C. t = 0.28 and p ≈ 0.78, so there is not convincing evidence of a difference in means.
- D. t = 1.47 and p ≈ 0.15, so the two means are equal.

Check: SE = sqrt(3.2²/25 + 2.8²/30) = 0.819; t = 1.2/0.819 = 1.47; df ≈ 48; two-sided p = 0.149.
Rationales: A: used one tail for a two-sided alternative, and even a p of 0.07 would not be below 0.05. C: divided by the square root of the sum of the variances without dividing by the sample sizes. D: failing to reject does not show the means are equal; it means the data do not rule that out.

**N-4.10-A-v2.** In a test of H0: μ1 - μ2 = 0 versus Ha: μ1 - μ2 < 0, a two-sample t procedure gives t = -2.31 with about 21 degrees of freedom. Which p-value is correct?

- A. About 0.03
- B. About 0.98
- **C. About 0.016**
- D. About 0.0016

Check: the alternative is lower-tailed, so p = P(T < -2.31) = 0.016 with df = 21.
Rationales: A: this doubles the tail area, which is correct only for a two-sided alternative. B: this is the upper tail, the wrong direction for a less-than alternative. D: this is ten times too small and does not match the t value.

**N-4.10-A-v3.** A study of 5,000 students at each of two schools finds mean scores of 74.0 and 73.0 on a 100-point test with standard deviations near 15. A two-sample t test of H0: μ1 = μ2 versus Ha: μ1 ≠ μ2 gives t = 3.33 and p ≈ 0.001. Which conclusion is best?

- A. The 1-point difference must be large, because the p-value is so small.
- B. There is a 0.1% chance that the two population means are equal.
- C. The small p-value proves that school 1 causes higher scores.
- **D. There is convincing evidence of a difference in population means, but a difference of about 1 point may be too small to matter in practice.**

Check: with very large samples, even a 1-point difference gives a small p-value; statistical significance does not mean practical importance.
Rationales: A: a small p-value reflects the large sample size, not necessarily a large difference. B: the p-value is a probability computed assuming the null hypothesis is true; it is not the probability that the null is true. C: schools were not randomly assigned to students, so an association does not prove cause.
