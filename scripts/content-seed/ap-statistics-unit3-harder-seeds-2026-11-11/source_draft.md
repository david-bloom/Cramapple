# AP Statistics Unit 3: replacement and new seed drafts

DRAFT for owner review. Not checked by any checker. Not in the database. Author-in-session drafts; every number recomputed in Python (scratchpad nums.py). Correct-answer position is varied on purpose and will be rebalanced at build time.
Scope (owner request 2026-11-11): (1) replace the nine R1 seeds with R3 seeds; (2) remove the duplicate seed 011-CAL, the near-twin OHT-3.3, and the variants-without-a-seed family 058; (3) clean up inconsistent formatting; (4) add seeds for topics 3.7 and 3.9 to 3.14.
Target level: interpretation, multi-step, or misconception reasoning; distractors are real student errors; no impossible values.

| Seed | Topic | Replaces / purpose |
|---|---|---|
| N-3.1-A | 3.1 Estimators | replaces 060 family |
| N-3.2-A | 3.2 Sampling distributions, p-hat | replaces 061 family |
| N-3.3-A | 3.3 Constructing a CI | replaces 058 family (seed was unpublished) |
| N-3.3-B | 3.3 Constructing a CI | replaces OHT-3.3 (near-twin of 058-v3) |
| N-3.4-B | 3.4 Justifying a claim from a CI | replaces 011-CAL (byte-identical to 011) |
| N-3.5-A | 3.5 Setting up a test | replaces 067 family |
| N-3.6-A | 3.6 p-values | replaces 066 |
| N-3.6-B | 3.6 p-values | replaces 080 family |
| N-3.7-A | 3.7 Carrying out a test | new |
| N-3.8-A | 3.8 Errors in tests | replaces 063 family |
| N-3.8-B | 3.8 Errors in tests | replaces 071 family |
| N-3.8-C | 3.8 Errors in tests | replaces 092 family |
| N-3.9-A | 3.9 Sampling distribution, difference | new |
| N-3.10-A | 3.10 CI for difference | new |
| N-3.11-A | 3.11 Claim from CI for difference | new |
| N-3.12-A | 3.12 Setting up difference test | new |
| N-3.13-A | 3.13 Carrying out difference test | new |
| N-3.14-A | 3.14 Setting up chi-square | new |
| N-3.15-A | 3.15 Carrying out chi-square | replaces 076 family |

---

## Seed N-3.1-A (replaces 060 family) — Topic 3.1 Estimators
**Skill:** separate bias (where the sampling distribution is centered) from variability (how spread out it is), and know what a larger sample does and does not fix.

A statistician simulates 1,000 random samples of size 50 from a population whose true proportion is 0.30 and records two estimators of that proportion. Estimator X has a sampling distribution centered at 0.30 with a standard deviation of 0.065. Estimator Y has a sampling distribution centered at 0.36 with a standard deviation of 0.020. The statistician then repeats the simulation with samples of size 200. Which statement is correct?

- A. Estimator Y is better, because its smaller standard deviation means its estimates are closer to 0.30 on average.
- B. Estimator X is biased, because many individual estimates differ from 0.30.
- C. Estimator Y's bias should disappear at n = 200, because larger samples remove bias.
- **D. Estimator X is unbiased but more variable; samples of size 200 should reduce its variability, but they would not remove Y's bias.**

Check: X is centered at the true value 0.30 (unbiased); Y is centered 0.06 above it (biased). Larger n shrinks the spread, not the center.
Rationales: A: a small standard deviation measures consistency, not accuracy, and Y's estimates cluster around 0.36, not 0.30. B: bias refers to the center of the sampling distribution, and individual estimates varying around 0.30 is variability, not bias. C: bias comes from the estimator or the sampling method, so a larger sample only makes Y cluster more tightly around 0.36.

## Seed N-3.2-A (replaces 061 family) — Topic 3.2 Sampling Distributions for Sample Proportions
**Skill:** find the standard deviation of the sampling distribution of p-hat, standardize an observed p-hat, and judge how unusual it is.

In a large city, 30% of households recycle. A random sample of 200 households is selected, and 38% of the sampled households recycle. Which statement is correct?

- **A. The sample proportion is about 2.5 standard deviations above 0.30, so a result this large would be unusual if the true proportion were 0.30.**
- B. The sample proportion is about 35 standard deviations above 0.30, since the standard deviation of the sampling distribution is 0.0023.
- C. The sample proportion is about 76 standard deviations above 0.30, since the standard deviation of the sampling distribution is 0.00105.
- D. The sample proportion is only 0.08 above 0.30, so it is within normal sampling variability for any sample size.

Check: SD = sqrt(0.30 x 0.70 / 200) = 0.0324; z = 0.08 / 0.0324 = 2.47.
Rationales: B: divided sqrt[p(1 - p)] by n instead of taking the square root of p(1 - p)/n, which makes the standard deviation far too small. C: used the variance p(1 - p)/n as if it were the standard deviation. D: whether a difference is unusual depends on its size relative to the standard deviation, which shrinks as the sample size grows.

## Seed N-3.3-A (replaces 058 family) — Topic 3.3 Constructing a Confidence Interval for a Population Proportion
**Skill:** how sample size and confidence level combine to change the margin of error.

A 90% confidence interval for a population proportion, based on a random sample of 400 people, has a margin of error of 0.04. A second interval uses a random sample of 1,600 people from the same population, at a 99% confidence level, with about the same sample proportion. About what is its margin of error?

- A. 0.016
- B. 0.063
- **C. 0.031**
- D. 0.020

Check: quadrupling n halves the margin to 0.02; the critical value rises from 1.645 to 2.576, a factor of 1.566; 0.02 x 1.566 = 0.0313.
Rationales: A: divided by 4 for the sample size instead of 2, then applied the critical value change. B: accounted for the higher confidence level but ignored the larger sample. D: accounted for the larger sample but ignored the higher confidence level.

## Seed N-3.3-B (replaces OHT-3.3) — Topic 3.3
**Skill:** sample size for a desired margin of error when a prior estimate of p is available, rather than the conservative 0.5.

A researcher wants a 95% confidence interval for a population proportion with a margin of error no larger than 0.04. A pilot study estimated the proportion to be about 0.20. Using z* = 1.96 and the pilot estimate, what is the smallest sample size that guarantees this margin of error?

- A. 601
- **B. 385**
- C. 384
- D. 481

Check: n >= 1.96^2 (0.20)(0.80) / 0.04^2 = 384.16, so n = 385.
Rationales: A: ignored the pilot estimate and used the conservative p = 0.5. C: rounded 384.16 down, which would give a margin slightly above 0.04. D: used p = 0.20 in place of p(1 - p) = 0.16.

## Seed N-3.4-B (replaces 011-CAL) — Topic 3.4 Justifying a Claim Based on a Confidence Interval for a Population Proportion
**Skill:** recover p-hat and the margin of error from an interval and decide whether the interval supports a claim.

A random sample of adults is used to construct a 95% confidence interval for the proportion who prefer a new product to the current one. The interval is (0.44, 0.56). The marketing manager says, "A majority of adults prefer the new product." Which statement is correct?

- A. The interval supports the claim, because the upper endpoint 0.56 is above 0.50.
- B. The sample proportion was 0.56 and the margin of error was 0.12, so the claim is supported.
- **C. The sample proportion was 0.50 with a margin of error of 0.06, and since 0.50 and values below it are plausible, the interval does not support a majority.**
- D. The interval shows that exactly 50% of adults prefer the new product, so the claim is false.

Check: p-hat = (0.44 + 0.56)/2 = 0.50; margin of error = (0.56 - 0.44)/2 = 0.06; 0.44 to 0.50 are plausible values below a majority.
Rationales: A: a claim is supported only when every plausible value agrees with it, and this interval also contains values at or below 0.50. B: the sample proportion is the midpoint of the interval, and the margin of error is half its width. D: a confidence interval gives a range of plausible values, not a single exact value, so it cannot show that the proportion equals 0.50.

## Seed N-3.5-A (replaces 067 family) — Topic 3.5 Setting Up a Test for a Population Proportion
**Skill:** write hypotheses from the research question, not from the sample result; hypotheses describe the parameter.

A mayor claims that at most 30% of residents oppose a new bike lane. A reporter wants to test whether the true proportion who oppose it is greater than 30%. In a random sample of 150 residents, 40 oppose the bike lane (about 27%). Which hypotheses should the reporter test?

- A. H0: p = 0.30, Ha: p < 0.30, where p is the proportion of all residents who oppose the bike lane.
- B. H0: p = 0.27, Ha: p > 0.27, where p is the proportion of all residents who oppose the bike lane.
- **C. H0: p = 0.30, Ha: p > 0.30, where p is the proportion of all residents who oppose the bike lane.**
- D. H0: p-hat = 0.30, Ha: p-hat > 0.30, where p-hat is the proportion of sampled residents who oppose the bike lane.

Check: the question asks about more than 30%; the null sets p to the claimed 0.30; the sample 0.27 is data, not part of the hypotheses.
Rationales: A: chose the direction suggested by the sample result (0.27 is below 0.30) instead of the question being asked. B: set the null value equal to the sample proportion, but hypotheses use the claimed value, not data. D: hypotheses must be about the population parameter p, not about the sample statistic p-hat.

## Seed N-3.6-A (replaces 066) — Topic 3.6 p-Values
**Skill:** turn a z statistic into a p-value for the stated alternative (one- vs two-sided) before deciding.

A significance test of H0: p = 0.50 versus Ha: p != 0.50 gives a test statistic z = 1.80. For a standard normal distribution, P(Z > 1.80) = 0.036. Using a significance level of alpha = 0.05, which conclusion is correct?

- A. Reject H0, because the p-value is 0.036, which is less than 0.05.
- **B. Fail to reject H0, because the two-sided p-value is 2(0.036) = 0.072, which is greater than 0.05.**
- C. Reject H0, because z = 1.80 is greater than 1.
- D. Fail to reject H0, because 0.072 means there is a 7.2% chance that H0 is true.

Check: for Ha: p != 0.50 the p-value counts both tails, 2 x 0.0359 = 0.072 > 0.05.
Rationales: A: used a one-sided tail area for a two-sided alternative. C: compared z with 1 instead of comparing the p-value with alpha. D: the decision is right, but a p-value is not the probability that H0 is true.

## Seed N-3.6-B (replaces 080 family) — Topic 3.6
**Skill:** statistical significance versus practical significance; a tiny p-value does not mean a large effect.

A company claims that 50% of its customers renew their subscription. An analyst tests H0: p = 0.50 versus Ha: p != 0.50 using a random sample of 50,000 customers, of whom 50.6% renew. The p-value is about 0.007. Which conclusion is best?

- **A. There is convincing evidence that the renewal rate differs from 50%, but the sample difference is only about 0.6 percentage points, so the difference may be too small to matter in practice.**
- B. There is convincing evidence that the renewal rate is far from 50%, because the p-value is so small.
- C. There is a 0.7% chance that the renewal rate is exactly 50%, so the company's claim is nearly certainly false.
- D. There is no evidence of a difference, because 50.6% is very close to 50%.

Check: SE = sqrt(0.5 x 0.5 / 50,000) = 0.00224; z = 0.006 / 0.00224 = 2.7; two-sided p about 0.007.
Rationales: B: a small p-value says the difference is unlikely to be chance, not that it is large; with n this big even a small difference is detectable. C: a p-value is computed assuming H0 is true, so it is not the probability that H0 is true. D: the p-value of 0.007 is below common significance levels, so the evidence of a difference is convincing even though the difference is small.

---

## Seed N-3.7-A (new) — Topic 3.7 Carrying Out a Test for a Population Proportion
**Skill:** check the conditions for a one-sample z-test using the hypothesized p0, not the sample proportion.

A delivery company claims that 92% of its packages arrive on time. A random sample of 80 packages is selected from the company's very large volume of shipments, and 70 of them (87.5%) arrive on time. An analyst plans a one-sample z-test of H0: p = 0.92 versus Ha: p < 0.92. Which statement about the conditions for the test is correct?

- A. The large counts condition is met, because np-hat = 70 and n(1 - p-hat) = 10 are both at least 10.
- B. The large counts condition is met, because the sample size of 80 is greater than 30.
- **C. The large counts condition is not met, because n(1 - p0) = 80(0.08) = 6.4 is less than 10.**
- D. The independence condition is not met, because the packages were sampled without replacement.

Check: np0 = 73.6 and n(1 - p0) = 6.4; the 10% condition holds since the shipments are very numerous.
Rationales: A: the conditions for a test use the hypothesized proportion p0, not the sample proportion. B: the sample-size rule of 30 is for means; for proportions the large counts condition is what matters. D: sampling without replacement is fine when the sample is less than 10% of a very large population.

## Seed N-3.8-A (replaces 063 family) — Topic 3.8 Potential Errors When Performing Tests
**Skill:** interpret power and the probability of a Type II error in context.

A test of H0: p = 0.50 versus Ha: p > 0.50 uses a significance level of alpha = 0.05. The test has power 0.70 against the alternative p = 0.60. Which statement is correct?

- **A. If the true proportion is 0.60, there is a 30% chance that the test fails to reject H0, which would be a Type II error.**
- B. There is a 70% chance that the true proportion is 0.60.
- C. If the true proportion is 0.50, there is a 70% chance that the test rejects H0.
- D. If the true proportion is 0.60, there is a 5% chance that the test makes a Type II error.

Check: Type II error probability = 1 - power = 0.30.
Rationales: B: power is a probability about the test's decision, computed for an assumed true value, not a probability about the parameter. C: rejecting a true H0 is a Type I error, whose probability is alpha = 0.05. D: 0.05 is the probability of a Type I error, not a Type II error.

## Seed N-3.8-B (replaces 071 family) — Topic 3.8
**Skill:** how sample size and the significance level jointly change the two error probabilities.

A researcher wants a test that has a smaller probability of a Type I error and also a smaller probability of a Type II error against a particular alternative value. Which plan can accomplish both?

- A. Lower alpha and keep the sample size the same.
- B. Raise alpha and increase the sample size.
- C. Keep alpha the same and decrease the sample size.
- **D. Lower alpha and increase the sample size enough to shrink the standard error.**

Check: lowering alpha alone raises the Type II probability; a larger n shrinks the standard error and lowers the Type II probability, offsetting the loss.
Rationales: A: with the sample size fixed, lowering alpha makes rejecting harder, which raises the Type II error probability. B: raising alpha raises the Type I error probability. C: a smaller sample increases the standard error and the Type II error probability, and leaves the Type I probability at alpha.

## Seed N-3.8-C (replaces 092 family) — Topic 3.8
**Skill:** identify a Type II error from a null hypothesis that has to be framed correctly in context.

An airport tests each bag with a procedure that tests H0: the bag contains no prohibited item versus Ha: the bag contains a prohibited item. Rejecting H0 means the bag is flagged. Which statement correctly describes a Type II error?

- A. Type II error: a bag with no prohibited item is flagged and searched, which delays the passenger.
- B. Type I error: a bag with a prohibited item is not flagged and is allowed through.
- C. Type II error: a bag with a prohibited item is flagged and removed.
- **D. Type II error: a bag with a prohibited item is not flagged, so H0 is not rejected even though it is false.**

Check: Type II means failing to reject a false H0; here H0 (no prohibited item) is false when the bag contains one.
Rationales: A: flagging a bag that has no prohibited item rejects a true H0, which is a Type I error. B: the situation described is right, but it is a Type II error, not a Type I error. C: flagging a bag that contains a prohibited item is the correct decision, not an error.

## Seed N-3.9-A (new) — Topic 3.9 Sampling Distributions for the Difference Between Sample Proportions
**Skill:** mean, standard deviation and shape of the sampling distribution of p-hat1 - p-hat2.

Among all users of app A, 40% renew their subscription, and among all users of app B, 25% renew. Independent random samples of 200 users of app A and 150 users of app B are selected, and the difference in sample proportions (p-hat A - p-hat B) is recorded. Which statement describes its sampling distribution?

- **A. Approximately normal with mean 0.15 and standard deviation 0.0495.**
- B. Approximately normal with mean 0.15 and standard deviation 0.0700.
- C. Approximately normal with mean 1.6 and standard deviation 0.0495.
- D. Approximately normal with mean 0.15 and standard deviation 0.00245.

Check: mean = 0.40 - 0.25 = 0.15; variance = 0.4(0.6)/200 + 0.25(0.75)/150 = 0.00245; SD = 0.0495; counts 80, 120, 37.5, 112.5 are all at least 10.
Rationales: B: added the two standard deviations instead of adding the two variances and taking the square root. C: divided the two proportions instead of subtracting them. D: reported the variance as the standard deviation.

## Seed N-3.10-A (new) — Topic 3.10 Constructing a Confidence Interval for the Difference Between Two Population Proportions
**Skill:** interpret an interval for p1 - p2 with the correct direction and parameter.

An online retailer randomly assigns visitors to see site A or site B. A 95% confidence interval for p_A - p_B, where p_A and p_B are the proportions of all visitors who would make a purchase using site A and site B, is (0.02, 0.14). Which interpretation is correct?

- **A. We are 95% confident that the proportion of all visitors who purchase using site A is between 0.02 and 0.14 higher than the proportion using site B.**
- B. We are 95% confident that between 2% and 14% of all visitors make a purchase.
- C. There is a 95% probability that p-hat A - p-hat B in a new sample will be between 0.02 and 0.14.
- D. We are 95% confident that the proportion of all visitors who purchase using site B is between 0.02 and 0.14 higher than the proportion using site A.

Check: the interval is for p_A - p_B and is entirely positive, so p_A is larger.
Rationales: B: the interval estimates a difference between two proportions, not a single proportion. C: the confidence level refers to the method capturing the population difference, not to a future sample statistic. D: reversed the direction; a positive p_A - p_B means site A is higher.

## Seed N-3.11-A (new) — Topic 3.11 Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Proportions
**Skill:** decide whether an interval for a difference supports a claim, including the direction.

A company randomly samples users of its new app and its old app. A 95% confidence interval for p_new - p_old, the difference in the proportions of all users who renew, is (-0.11, -0.02). A manager claims the new app lowered the renewal rate. Which conclusion is best?

- A. The interval does not support the claim, because a proportion cannot be negative.
- **B. The interval supports the claim, because every plausible value of p_new - p_old is negative, so the new app's renewal proportion is lower.**
- C. The interval shows the new app raised the renewal rate, because the interval is centered near zero.
- D. The interval shows the renewal rate fell by exactly 6.5 percentage points.

Check: all plausible differences new - old are below 0; midpoint -0.065.
Rationales: A: the interval is for a difference between proportions, which can be negative. C: negative values mean the new proportion is smaller. D: the midpoint is the sample difference; the interval gives a range of plausible values for the population difference.

## Seed N-3.12-A (new) — Topic 3.12 Setting Up a Test for the Difference Between Two Population Proportions
**Skill:** write hypotheses for a difference from the research question, with defined parameters and a direction that does not follow the sample result.

A teacher wants to test whether the proportion of students who pass an exam is higher when students use study app A than when they use study app B. In independent random samples, 60 of 100 students using app A passed and 66 of 100 students using app B passed. Which hypotheses should the teacher test?

- A. H0: p_A - p_B = 0 versus Ha: p_A - p_B < 0, where p_A and p_B are the proportions of all students who would pass using each app.
- B. H0: p-hat A - p-hat B = 0 versus Ha: p-hat A - p-hat B > 0.
- **C. H0: p_A - p_B = 0 versus Ha: p_A - p_B > 0, where p_A and p_B are the proportions of all students who would pass using each app.**
- D. H0: p_A - p_B = -0.06 versus Ha: p_A - p_B > -0.06, where p_A and p_B are the proportions of all students who would pass using each app.

Check: the question is whether app A is higher; the null is no difference; the sample difference of -0.06 is data.
Rationales: A: followed the sample result (app A is lower in the sample) instead of the question. B: hypotheses are about population parameters, not sample statistics. D: used the sample difference as the null value, but the null value for a difference of proportions is 0.

## Seed N-3.13-A (new) — Topic 3.13 Carrying Out a Test for the Difference Between Two Population Proportions
**Skill:** two-proportion z-test with the pooled standard error and a two-sided p-value.

In an email campaign, 84 of 150 customers randomly assigned to version A clicked a link, and 90 of 200 customers randomly assigned to version B clicked. A test of H0: p_A = p_B versus Ha: p_A != p_B uses the pooled proportion 174/350 = 0.497. For a standard normal distribution, P(Z > 2.04) = 0.021. Which result is correct at alpha = 0.05?

- **A. z = 2.04, p-value = 0.042; reject H0, so there is convincing evidence that the click rates differ.**
- B. z = 2.04, p-value = 0.021; reject H0, so there is convincing evidence that the click rates differ.
- C. z = 4.12, p-value < 0.001; reject H0, so there is convincing evidence that the click rates differ.
- D. z = 2.04, p-value = 0.042; fail to reject H0, because 0.042 is greater than 0.025.

Check: p-hat A = 0.56, p-hat B = 0.45; SE = sqrt(0.497 x 0.503 x (1/150 + 1/200)) = 0.054; z = 0.11 / 0.054 = 2.04; two-sided p = 2(0.021) = 0.042 < 0.05.
Rationales: B: used a one-sided tail area for a two-sided alternative. C: divided the pooled variance by n1 + n2 instead of using 1/n1 + 1/n2, which makes the standard error far too small. D: split alpha across two tails twice; for a two-sided test the p-value is compared with alpha itself.

## Seed N-3.14-A (new) — Topic 3.14 Setting Up a Chi-Square Test for Homogeneity or Independence
**Skill:** choose homogeneity or independence from the sampling design and give the correct degrees of freedom.

A school district randomly selects 150 students from each of three high schools and asks each student to choose a preferred lunch option from four choices. The district wants to know whether the distribution of preferred lunch option is the same at all three schools. Which test and degrees of freedom are correct?

- A. A test of independence, with df = 6.
- **B. A test of homogeneity, with df = (3 - 1)(4 - 1) = 6.**
- C. A test of homogeneity, with df = 12.
- D. A test of homogeneity, with df = 3 + 4 - 2 = 5.

Check: separate random samples from three populations classified on one categorical variable gives homogeneity; df = (rows - 1)(columns - 1) = 2 x 3 = 6.
Rationales: A: independence applies when one sample is classified on two variables, not when separate samples are taken from each school. C: used rows times columns instead of (rows - 1)(columns - 1). D: added the numbers of rows and columns minus 2, which is not how degrees of freedom are found for a table.

## Seed N-3.15-A (replaces 076 family) — Topic 3.15 Carrying Out a Chi-Square Test for Homogeneity or Independence
**Skill:** the large counts condition applies to expected counts, which come from the totals, not to observed counts.

A random sample of 100 people was classified by group and response. Group 1 (20 people): 15 responded yes and 5 responded no. Group 2 (80 people): 75 responded yes and 5 responded no. A researcher plans a chi-square test. Which statement about the conditions is correct?

- A. The conditions are met, because every observed count is at least 5.
- B. The conditions are met, because the total sample size of 100 is greater than 30.
- **C. The expected counts condition is not met, because the expected count for Group 1 and response no is 20(10)/100 = 2, which is less than 5.**
- D. The expected counts condition is not met, because Group 2 has more people than Group 1.

Check: column totals are 90 and 10; expected counts: Group 1: 18 and 2; Group 2: 72 and 8; the smallest is 2.
Rationales: A: the condition is on expected counts, and an expected count can be small even when all observed counts are at least 5. B: the sample-size rule of 30 does not replace checking expected counts. D: unequal group sizes are not a violation; the condition is about expected counts.

## N-3.1-A variants (bias versus variability)

**N-3.1-A-v1.** A county health office estimates the proportion of residents who exercise weekly using an online sign-up poll. The poll is repeated many times, and each time about 5,000 people respond. The estimates are tightly clustered around 0.72, but the true proportion in the county is 0.55. Which statement is correct?
- A. The estimator is unbiased, because the estimates are so consistent from poll to poll.
- B. The estimator has high variability, because its estimates are far from 0.55.
- **C. The estimator is biased but has low variability, and asking even more volunteers in the same way would not remove the bias.**
- D. The estimator is biased, but the bias would shrink if the poll used 50,000 volunteers.
Check: centered at 0.72, not 0.55 (biased); spread is small (low variability); a voluntary-response method is biased at any size.
Rationales: A: consistent results show low variability, not accuracy. B: variability is the spread of the estimates, not their distance from the truth. D: bias from the sampling method is not reduced by a larger sample of the same kind.

**N-3.1-A-v2.** Statisticians compare two methods of estimating a true proportion of 0.40. Method P uses samples of size 100, and its sampling distribution has a mean of 0.40 and a standard deviation of 0.049. Method Q uses samples of size 400, and its sampling distribution has a mean of 0.40 and a standard deviation of 0.025. Which statement is correct?
- A. Method Q is less biased than Method P, because its sample size is larger.
- B. Method P is better, because a smaller sample leaves less room for error.
- C. The two methods are equally good, because both are centered at 0.40.
- **D. Both methods are unbiased, but Method Q is more precise because its estimates vary less from sample to sample.**
Check: both means equal 0.40 (unbiased); SD 0.025 < 0.049.
Rationales: A: sample size changes variability, not bias, and both methods already have zero bias. B: smaller samples give more variable estimates. C: unbiasedness alone does not make estimators equally good; the more precise one is preferred.

**N-3.1-A-v3.** Repeated random samples are used to estimate a true proportion of 0.50 with three estimators. Estimator R has a sampling distribution centered at 0.50 with a standard deviation of 0.08. Estimator S is centered at 0.58 with a standard deviation of 0.02. Estimator T is centered at 0.59 with a standard deviation of 0.09. Which statement is correct?
- A. Estimator S is the best choice, because it has the smallest standard deviation.
- B. Estimator T is unbiased, because its large standard deviation means it sometimes hits 0.50.
- **C. Estimator R is the only unbiased estimator, and Estimator S has the least variability but is biased.**
- D. Estimator R is biased, because it has a wider spread than Estimator S.
Check: only R is centered at 0.50; S has the smallest SD but is centered at 0.58.
Rationales: A: a small standard deviation does not make up for being centered at the wrong value. B: unbiasedness is about the center, not the spread. D: a wide spread of estimates is variability, and bias is about where the sampling distribution is centered.

## N-3.2-A variants (standardizing a sample proportion)

**N-3.2-A-v1.** About 60% of the students at a large school own a laptop. A random sample of 150 students is selected, and 52% of the sample own a laptop. Which statement is correct?
- A. The sample proportion is about 24 standard deviations below 0.60, since the standard deviation of the sampling distribution is 0.0033.
- **B. The sample proportion is about 2 standard deviations below 0.60, so a result this low would be fairly unusual if the true proportion were 0.60.**
- C. The sample proportion is 0.08 below 0.60, which is too small a gap to ever be unusual.
- D. The sample proportion is about 50 standard deviations below 0.60, since the standard deviation of the sampling distribution is 0.0016.
Check: SD = sqrt(0.6 x 0.4 / 150) = 0.04; z = -0.08 / 0.04 = -2.0.
Rationales: A: divided sqrt[p(1 - p)] by n instead of taking the square root of p(1 - p)/n, which makes the standard deviation far too small. C: unusualness depends on the gap measured in standard deviations, not the raw gap. D: used the variance p(1 - p)/n as the standard deviation.

**N-3.2-A-v2.** A hospital knows that 15% of its patients are readmitted within 30 days. In a random sample of 400 patients, 19% were readmitted. Which statement is correct?
- A. The sample proportion is only 0.04 above 0.15, so it is within normal sampling variability for a sample of any size.
- B. The sample proportion is about 45 standard deviations above 0.15, since the standard deviation of the sampling distribution is 0.00089.
- **C. The sample proportion is about 2.2 standard deviations above 0.15, so a result this large would be somewhat unusual if the true proportion were 0.15.**
- D. The sample proportion is about 125 standard deviations above 0.15, since the standard deviation of the sampling distribution is 0.00032.
Check: SD = sqrt(0.15 x 0.85 / 400) = 0.01785; z = 0.04 / 0.01785 = 2.24.
Rationales: A: the gap must be compared with the standard deviation, which is small for n = 400. B: divided sqrt[p(1 - p)] by n instead of taking the square root of p(1 - p)/n, which makes the standard deviation far too small. D: used p(1 - p)/n as the standard deviation.

**N-3.2-A-v3.** A manufacturer reports that 45% of its tablets pass inspection on the first try. A random sample of 100 tablets gives a sample proportion of 0.50. Which statement is correct?
- A. The sample proportion is about 10 standard deviations above 0.45, since the standard deviation of the sampling distribution is 0.005.
- B. The sample proportion is 0.05 above 0.45, which is too large a gap to be ordinary sampling variability.
- C. The sample proportion is about 20 standard deviations above 0.45, since the standard deviation of the sampling distribution is 0.0025.
- **D. The sample proportion is about 1 standard deviation above 0.45, so a result this large would not be unusual if the true proportion were 0.45.**
Check: SD = sqrt(0.45 x 0.55 / 100) = 0.0497; z = 0.05 / 0.0497 = 1.01.
Rationales: A: divided sqrt[p(1 - p)] by n instead of taking the square root of p(1 - p)/n, which makes the standard deviation far too small. B: with n = 100 the standard deviation is about 0.05, so a gap of 0.05 is ordinary. C: used p(1 - p)/n as the standard deviation.

## N-3.3-A variants (margin of error: sample size and confidence level)

**N-3.3-A-v1.** A 95% confidence interval for a population proportion, based on a random sample of 625 people, has a margin of error of 0.03. A second interval uses a random sample of 2,500 people at a 90% confidence level, with about the same sample proportion. About what is its margin of error?
- A. 0.025
- B. 0.015
- C. 0.006
- **D. 0.013**
Check: n quadrupled so 0.03 / 2 = 0.015; critical value falls from 1.96 to 1.645 (factor 0.839); 0.015 x 0.839 = 0.0126.
Rationales: A: accounted for the lower confidence level but ignored the larger sample. B: accounted for the larger sample but ignored the lower confidence level. C: divided by 4 instead of 2 for the sample size, then applied the critical value change.

**N-3.3-A-v2.** A 95% confidence interval for a population proportion, based on a random sample of 200 people, has a margin of error of 0.05. A second interval uses a random sample of 800 people at a 99% confidence level, with about the same sample proportion. About what is its margin of error?
- **A. 0.033**
- B. 0.066
- C. 0.025
- D. 0.016
Check: 0.05 / 2 = 0.025; 2.576 / 1.96 = 1.314; 0.025 x 1.314 = 0.0329.
Rationales: B: accounted for the higher confidence level but ignored the larger sample. C: accounted for the larger sample but ignored the higher confidence level. D: divided by 4 for the sample size instead of 2, then applied the critical value change.

**N-3.3-A-v3.** A 99% confidence interval for a population proportion, based on a random sample of 500 people, has a margin of error of 0.02. A second interval uses a random sample of only 125 people at a 90% confidence level, with about the same sample proportion. About what is its margin of error?
- A. 0.040
- B. 0.013
- **C. 0.026**
- D. 0.051
Check: n cut to a quarter, so the margin doubles to 0.04; 1.645 / 2.576 = 0.639; 0.04 x 0.639 = 0.0255.
Rationales: A: accounted for the smaller sample but ignored the lower confidence level. B: accounted for the lower confidence level but ignored the smaller sample. D: multiplied by 4 instead of 2 for the sample-size change, then applied the critical value change.

## N-3.3-B variants (sample size with a prior estimate)

**N-3.3-B-v1.** A researcher wants a 90% confidence interval for a population proportion with a margin of error no larger than 0.05. A pilot study estimated the proportion to be about 0.35. Using z* = 1.645 and the pilot estimate, what is the smallest sample size that guarantees this margin of error?
- A. 271
- B. 246
- **C. 247**
- D. 379
Check: n >= 1.645^2 (0.35)(0.65) / 0.05^2 = 246.25, so n = 247.
Rationales: A: ignored the pilot estimate and used p = 0.5. B: rounded 246.25 down to 246, but any value with a fractional part must be rounded up to guarantee the margin of error. D: used p = 0.35 in place of p(1 - p) = 0.2275.

**N-3.3-B-v2.** A researcher wants a 99% confidence interval for a population proportion with a margin of error no larger than 0.02. A pilot study estimated the proportion to be about 0.10. Using z* = 2.576 and the pilot estimate, what is the smallest sample size that guarantees this margin of error?
- **A. 1,494**
- B. 4,148
- C. 1,493
- D. 1,659
Check: n >= 2.576^2 (0.10)(0.90) / 0.02^2 = 1493.05, so n = 1,494.
Rationales: B: ignored the pilot estimate and used p = 0.5. C: rounded 1,493.05 down to 1,493, but any value with a fractional part must be rounded up to guarantee the margin of error. D: used p = 0.10 in place of p(1 - p) = 0.09.

**N-3.3-B-v3.** A researcher wants a 95% confidence interval for a population proportion with a margin of error no larger than 0.03. A pilot study estimated the proportion to be about 0.70. Using z* = 1.96 and the pilot estimate, what is the smallest sample size that guarantees this margin of error?
- A. 1,068
- B. 896
- C. 2,988
- **D. 897**
Check: n >= 1.96^2 (0.70)(0.30) / 0.03^2 = 896.37, so n = 897.
Rationales: A: ignored the pilot estimate and used p = 0.5. B: rounded 896.37 down to 896, but any value with a fractional part must be rounded up to guarantee the margin of error. C: used p = 0.70 in place of p(1 - p) = 0.21.

## N-3.4-B variants (justifying claims from an interval)

**N-3.4-B-v1.** A random sample of voters is used to construct a 95% confidence interval for the proportion who support a school bond. The interval is (0.52, 0.64). A board member claims that a majority of voters support the bond. Which statement is correct?
- A. The interval does not support the claim, because the interval does not capture the sample proportion exactly.
- B. There is a 95% probability that more than half of all voters support the bond.
- **C. The interval supports the claim, because every plausible value for the population proportion is above 0.50.**
- D. The interval supports the claim only for the 95% of voters inside the interval.
Check: lower endpoint 0.52 > 0.50, so all plausible values exceed one half.
Rationales: A: the sample proportion is the midpoint of the interval by construction. B: the true proportion is a fixed number, so probability statements describe the method, not this interval. D: the interval is about a population proportion, not about subsets of voters.

**N-3.4-B-v2.** A random sample of 900 teenagers is used to construct a 99% confidence interval for the proportion who text while walking. The interval is (0.31, 0.39). A safety group claims that the proportion is 0.30. Which statement is correct?
- A. The claim is supported, because 0.30 is close to the lower endpoint 0.31.
- **B. The claim is not supported, because 0.30 is not a plausible value; every plausible value is above 0.30.**
- C. The claim is supported, because the interval is centered at 0.35 and that is near 0.30.
- D. The claim is not supported, because 99% of teenagers are outside the interval.
Check: 0.30 lies below the lower endpoint 0.31.
Rationales: A: being close to an endpoint is not the same as being inside the interval. C: the center of the interval is the sample proportion, and the claim must be a plausible value for the population. D: a confidence level does not describe the share of teenagers.

**N-3.4-B-v3.** A random sample of 250 customers is used to construct a 90% confidence interval for the proportion who are satisfied. The interval is (0.33, 0.43). A manager claims that fewer than 40% of customers are satisfied. Which statement is correct?
- A. The claim is supported, because the sample proportion of 0.38 is less than 0.40.
- B. The claim is supported, because most of the interval is below 0.40.
- **C. The claim is not supported, because values from 0.40 to 0.43 are plausible for the population proportion.**
- D. The claim is not supported, because the interval would need to be a 95% interval to be used.
Check: the interval contains 0.40 and values above it; p-hat = 0.38.
Rationales: A: a claim about a population cannot be judged from the sample proportion alone. B: the whole range of plausible values must agree with the claim. D: a 90% interval can be used to evaluate a claim; the level only sets the level of confidence.

## N-3.5-A variants (hypotheses from the research question)

**N-3.5-A-v1.** A school claims that at least 70% of its graduates enroll in college. A skeptical reporter wants to test whether the true proportion is less than 70%. In a random sample of 120 graduates, 90 enrolled in college (75%). Which hypotheses should the reporter test?
- A. H0: p = 0.70, Ha: p > 0.70, where p is the proportion of all graduates who enroll in college.
- **B. H0: p = 0.70, Ha: p < 0.70, where p is the proportion of all graduates who enroll in college.**
- C. H0: p = 0.75, Ha: p < 0.75, where p is the proportion of all graduates who enroll in college.
- D. H0: p-hat = 0.70, Ha: p-hat < 0.70, where p-hat is the proportion of sampled graduates who enroll.
Check: the reporter's question is "less than 70%"; the sample 75% is data.
Rationales: A: followed the direction of the sample result instead of the question. C: used the sample proportion as the null value. D: hypotheses are about the population parameter, not the statistic.

**N-3.5-A-v2.** A manufacturer says that 4% of its batteries are defective. An inspector suspects the true defect rate is different from 4%. In a random sample of 500 batteries, 24 are defective (4.8%). Which hypotheses should the inspector test?
- A. H0: p = 0.048, Ha: p != 0.048, where p is the proportion of all batteries that are defective.
- B. H0: p = 0.04, Ha: p > 0.04, where p is the proportion of all batteries that are defective.
- C. H0: p-hat = 0.04, Ha: p-hat != 0.04, where p-hat is the proportion of sampled batteries that are defective.
- **D. H0: p = 0.04, Ha: p != 0.04, where p is the proportion of all batteries that are defective.**
Check: "different from" is two-sided and the null uses the manufacturer's 4%.
Rationales: A: used the sample proportion as the null value. B: the inspector's suspicion is a difference in either direction, not just an increase. C: hypotheses are about the population parameter, not the statistic.

**N-3.5-A-v3.** A candidate needs more than 50% of the vote to win. A campaign wants to test whether the proportion of all voters supporting the candidate exceeds 50%. In a random sample of 400 voters, 188 support the candidate (47%). Which hypotheses should the campaign test?
- A. H0: p = 0.50, Ha: p < 0.50, where p is the proportion of all voters who support the candidate.
- B. H0: p >= 0.50, Ha: p = 0.50, where p is the proportion of all voters who support the candidate.
- **C. H0: p = 0.50, Ha: p > 0.50, where p is the proportion of all voters who support the candidate.**
- D. H0: p = 0.47, Ha: p > 0.47, where p is the proportion of all voters who support the candidate.
Check: the question is whether support exceeds 50%.
Rationales: A: followed the sample result (47% is below 50%) instead of the question. B: the alternative hypothesis never contains equality. D: used the sample proportion as the null value.

## N-3.6-A variants (p-value for the stated alternative)

**N-3.6-A-v1.** A significance test of H0: p = 0.30 versus Ha: p != 0.30 gives a test statistic z = 2.10. For a standard normal distribution, P(Z > 2.10) = 0.018. Using a significance level of alpha = 0.01, which conclusion is correct?
- A. Reject H0, because 0.018 is less than 0.05.
- B. Reject H0, because z = 2.10 is greater than 2.
- **C. Fail to reject H0, because the two-sided p-value is 2(0.018) = 0.036, which is greater than 0.01.**
- D. Fail to reject H0, because 0.036 is the probability that H0 is true.
Check: two-sided p = 0.036 > 0.01.
Rationales: A: compared with the wrong significance level, 0.05. B: compared z with a number instead of comparing the p-value with alpha. D: the decision is right, but a p-value is not the probability that H0 is true.

**N-3.6-A-v2.** A significance test of H0: p = 0.40 versus Ha: p > 0.40 gives a test statistic z = 1.70. For a standard normal distribution, P(Z > 1.70) = 0.045. Using a significance level of alpha = 0.05, which conclusion is correct?
- A. Fail to reject H0, because the two-sided p-value is 2(0.045) = 0.090.
- **B. Reject H0, because the p-value for this one-sided alternative is 0.045, which is less than 0.05.**
- C. Fail to reject H0, because z = 1.70 is smaller than 1.96.
- D. Reject H0, because 0.045 is the probability that H0 is true.
Check: Ha is one-sided so the p-value is the single tail, 0.045 < 0.05.
Rationales: A: doubled the tail area, but the alternative is one-sided. C: 1.96 applies to a two-sided 5% test, not to this one-sided test. D: the decision is right, but a p-value is not the probability that H0 is true.

**N-3.6-A-v3.** A significance test of H0: p = 0.25 versus Ha: p != 0.25 gives a test statistic z = -2.40. For a standard normal distribution, P(Z < -2.40) = 0.008. Using a significance level of alpha = 0.01, which conclusion is correct?
- A. Reject H0, because the p-value is 0.008, which is less than 0.01.
- B. Fail to reject H0, because the test statistic is negative.
- **C. Fail to reject H0, because the two-sided p-value is 2(0.008) = 0.016, which is greater than 0.01.**
- D. Reject H0, because 0.016 is smaller than 0.05.
Check: two-sided p = 0.016 > 0.01.
Rationales: A: used a one-sided tail for a two-sided alternative. B: the sign of z only gives the direction, and the p-value depends on the size of z. D: compared with 0.05 although alpha is 0.01.

## N-3.6-B variants (statistical versus practical significance)

**N-3.6-B-v1.** A principal claims that 40% of students walk to school. A researcher tests H0: p = 0.40 versus Ha: p != 0.40 using a random sample of only 40 students, 21 of whom (52.5%) walk. The p-value is about 0.11. Using alpha = 0.05, which conclusion is best?
- A. There is convincing evidence that exactly 40% of students walk, because the test failed to reject H0.
- B. There is convincing evidence that the proportion differs from 40%, because 65% is much larger than 40%.
- **C. There is not convincing evidence of a difference at the 0.05 level, but the sample was small and the gap of 12.5 percentage points is sizable, so a larger sample would be informative.**
- D. There is an 11% chance that the principal is correct.
Check: z = 0.125 / sqrt(0.4 x 0.6 / 40) = 1.61; two-sided p = 0.107; np0 = 16 and n(1 - p0) = 24 so the z-test is valid.
Rationales: A: failing to reject H0 does not show that H0 is true. B: the p-value of 0.11 is above 0.05, and a small sample can produce a large gap by chance. D: a p-value is computed assuming H0 is true; it is not the probability that H0 is true.

**N-3.6-B-v2.** A city claims that 80% of its buses run on time. A transit analyst tests H0: p = 0.80 versus Ha: p != 0.80 using a random sample of 100,000 bus trips, 79.5% of which were on time. The p-value is about 0.0001. Which conclusion is best?
- **A. There is convincing evidence that the on-time rate differs from 80%, but a half-percentage-point gap is small, so it may not matter in practice.**
- B. There is convincing evidence that the on-time rate is much lower than 80%, because the p-value is tiny.
- C. The sample is too large to be trusted, so no conclusion can be drawn.
- D. There is a 0.01% chance that the city's claim of 80% is correct.
Check: SE = sqrt(0.8 x 0.2 / 100,000) = 0.00126; z = -0.005 / 0.00126 = -3.95; two-sided p about 0.0001.
Rationales: B: a small p-value says the gap is unlikely to be chance, not that it is large. C: large samples give more reliable estimates, and the evidence of a difference is real. D: a p-value is computed assuming H0 is true, not the probability that H0 is true.

**N-3.6-B-v3.** Two researchers each test H0: p = 0.50 about different populations. Researcher 1 finds a p-value of about 0.005 with a sample proportion of 0.51 from 20,000 people. Researcher 2 finds a p-value of about 0.005 with a sample proportion of 0.70 from 50 people. Which statement is correct?
- A. Researcher 2 has stronger evidence, because 0.70 is farther from 0.50 than 0.51.
- B. The two results have equal evidence against H0 and equal practical importance, because the p-values are the same.
- **C. The evidence against H0 is equally strong, but Researcher 1's difference is much smaller and may not matter in practice.**
- D. Researcher 1 has stronger evidence, because the sample size is larger.
Check: z = 0.01 / sqrt(0.25 / 20,000) = 2.83 and z = 0.20 / sqrt(0.25 / 50) = 2.83, so both p-values are about 0.005; the sample differences are 0.01 and 0.20.
Rationales: A: strength of evidence is measured by the p-value, which is the same. B: the same p-value does not mean the same size of effect. D: the p-values already incorporate sample size.

## N-3.7-A variants (conditions and test statistic)

**N-3.7-A-v1.** A phone company claims that 20% of its customers use a certain feature. A random sample of 100 customers is selected from the company's very large customer base, and only 6 of them use the feature. An analyst plans a one-sample z-test of H0: p = 0.20 versus Ha: p < 0.20. Which statement about the large counts condition is correct?
- A. The condition is not met, because only 6 sampled customers use the feature, which is less than 10.
- B. The condition is not met, because p0 = 0.20 is less than 0.50.
- **C. The condition is met, because np0 = 100(0.20) = 20 and n(1 - p0) = 100(0.80) = 80 are both at least 10.**
- D. The condition is met, because 6 sampled customers is at least 5.
Check: the test uses p0 = 0.20: np0 = 20 and n(1 - p0) = 80.
Rationales: A: the condition uses the hypothesized proportion, not the sample count of successes. B: the proportion does not need to be at least 0.50; both expected counts must be at least 10. D: the rule of 5 applies to expected counts in chi-square tests, and this check uses np0 and n(1 - p0) with a threshold of 10.

**N-3.7-A-v2.** A town has 500 households. A resident claims that 40% of its households recycle. A random sample of 80 households is selected, and 30 of them (37.5%) recycle. An analyst plans a one-sample z-test of H0: p = 0.40 versus Ha: p < 0.40. Which statement about the conditions is correct?
- A. All conditions are met, because np0 = 32 and n(1 - p0) = 48 are both at least 10.
- B. The large counts condition is not met, because p-hat = 0.375 does not equal 0.40.
- **C. The independence (10%) condition is not met, because the sample of 80 is more than 10% of the 500 households.**
- D. The random condition is not met, because a sample of 80 is too small.
Check: 10% of 500 = 50 < 80; np0 = 32 and n(1 - p0) = 48 are fine.
Rationales: A: the counts condition is met, but the 10% condition also has to be checked. B: the test statistic compares p-hat with p0; the two need not be equal for conditions to hold. D: the condition is about how the sample was selected, not about its size alone.

**N-3.7-A-v3.** A researcher wants to know whether more than half of the voters in a large state support a ballot measure. In a random sample of 100 voters, 62 support it. For a one-sample z-test of H0: p = 0.50 versus Ha: p > 0.50, which value is the test statistic?
- A. z = 0.24
- B. z = 2.47
- **C. z = 2.40**
- D. z = 24
Check: z = (0.62 - 0.50) / sqrt(0.50 x 0.50 / 100) = 0.12 / 0.05 = 2.40.
Rationales: A: left n out of the standard error, dividing by sqrt[p0(1 - p0)] only. B: used p-hat in the standard error; in a test the standard error uses the hypothesized p0. D: divided sqrt[p0(1 - p0)] by n instead of taking the square root of p0(1 - p0)/n.

## N-3.8-A variants (power and Type II error)

**N-3.8-A-v1.** A significance test has power 0.85 against a particular alternative value of the parameter. Which statement is correct?
- **A. If that alternative is true, the probability of a Type II error is 0.15.**
- B. If the null hypothesis is true, the probability of a Type I error is 0.15.
- C. The probability that the null hypothesis is false is 0.85.
- D. If the null hypothesis is true, the probability that the test rejects it is 0.85.
Check: Type II probability = 1 - 0.85 = 0.15.
Rationales: B: the Type I error probability is alpha and is not 1 minus the power. C: power is a conditional probability about the test's decision, not a probability that the null is false. D: if the null is true the probability of rejecting it is alpha.

**N-3.8-A-v2.** A test of H0: p = 0.50 versus Ha: p > 0.50 has power 0.70 against p = 0.60 for a particular sample size and significance level. With the same sample size and significance level, how would the power against p = 0.55 compare?
- A. Greater than 0.70, because values closer to the null give a larger gap to detect.
- B. Equal to 0.70, because the sample size and significance level are the same.
- **C. Less than 0.70, because a true value closer to the null value is harder to detect.**
- D. Equal to the significance level, because 0.55 is close to 0.50.
Check: smaller effect size, same standard error, so less power.
Rationales: A: a value closer to the null is a smaller gap, not a larger one. B: power also depends on how far the true value is from the null value. D: power equals alpha only when the true value equals the null value.

**N-3.8-A-v3.** A test of H0: p = 0.30 versus Ha: p < 0.30 has a probability of 0.18 of failing to reject H0 when the true proportion is 0.20. Which statement is correct?
- A. The test has power 0.18 against p = 0.20.
- **B. The test has power 0.82, so there is an 82% chance the test rejects H0 if the true proportion is 0.20.**
- C. The test has power 0.82, so there is an 82% chance that the true proportion is 0.20.
- D. The test has power 0.82, so there is an 18% chance that H0 is true.
Check: power = 1 - 0.18 = 0.82.
Rationales: A: 0.18 is the Type II error probability, not the power. C: power is not a probability that the parameter takes a value. D: power does not give the probability that H0 is true.

## N-3.8-B variants (trading off Type I and Type II error)

**N-3.8-B-v1.** A researcher increases the significance level from alpha = 0.01 to alpha = 0.10 and keeps the same sample size and the same true parameter value. Which statement is correct?
- **A. The probability of a Type I error increases, and the probability of a Type II error decreases.**
- B. The probability of a Type I error decreases, and the probability of a Type II error increases.
- C. The probabilities of both types of error decrease.
- D. The probability of a Type I error increases, and the probability of a Type II error is unchanged.
Check: a larger alpha makes rejection easier, so Type I goes up and power goes up (Type II goes down).
Rationales: B: reversed the effect of raising alpha, which makes rejection easier and so raises the Type I probability and lowers the Type II probability. C: with the sample size fixed, the two error probabilities move in opposite directions. D: raising alpha makes rejection easier, which also lowers the Type II error probability.

**N-3.8-B-v2.** A drug company tests H0: the drug is not effective versus Ha: the drug is effective. A Type I error would approve an ineffective drug, which could harm patients. Which plan best addresses this concern while keeping the test useful?
- A. Raise alpha to 0.10 so the test is more sensitive.
- **B. Lower alpha to 0.01 and increase the sample size so the test keeps its power.**
- C. Lower alpha to 0.01 and decrease the sample size to save cost.
- D. Keep alpha at 0.05 and decrease the sample size.
Check: lowering alpha reduces false approvals; a larger n offsets the power loss.
Rationales: A: a larger alpha makes false approvals more likely. C: a smaller sample would lower power further. D: the sample size does not change the Type I error probability, which stays at alpha.

**N-3.8-B-v3.** A researcher doubles the sample size for a test while keeping the significance level and the true parameter value the same. Which statement is correct?
- **A. The probability of a Type I error stays at alpha, and the probability of a Type II error decreases.**
- B. The probability of a Type I error decreases, and the probability of a Type II error stays the same.
- C. The probabilities of both Type I and Type II errors decrease.
- D. The probability of a Type I error stays at alpha, and the power decreases.
Check: alpha is chosen by the researcher; a larger n shrinks the standard error and raises power.
Rationales: B: the Type I error probability is set by alpha, and the Type II probability falls with a larger n. C: the Type I error probability is alpha and does not change with the sample size. D: power increases with a larger sample size.

## N-3.8-C variants (errors in context)

**N-3.8-C-v1.** A food plant tests each batch with H0: the batch is not contaminated versus Ha: the batch is contaminated. Rejecting H0 means the batch is discarded. Which statement correctly describes a Type I error?
- A. Type I error: a contaminated batch is not discarded and is shipped to stores.
- B. Type II error: a clean batch is discarded.
- **C. Type I error: a clean batch is discarded even though it was not contaminated.**
- D. Type I error: a contaminated batch is discarded.
Check: Type I means rejecting a true H0; H0 (not contaminated) is true for a clean batch.
Rationales: A: this describes failing to reject a false H0, which is a Type II error. B: discarding a clean batch is a Type I error, not a Type II error. D: discarding a contaminated batch is the correct decision.

**N-3.8-C-v2.** A cereal machine is set to fill boxes with a mean of 500 g. An inspector tests H0: mu = 500 versus Ha: mu != 500 and stops the machine when H0 is rejected. Which statement correctly describes a Type II error?
- A. Type I error: the machine is stopped even though it is filling correctly.
- B. Type II error: the machine is stopped even though it is filling correctly.
- C. Type II error: the machine is stopped because it is filling incorrectly.
- **D. Type II error: the machine is not stopped even though its true mean is not 500 g.**
Check: a Type II error fails to reject a false H0; here H0 is false when the true mean differs from 500.
Rationales: A: stopping a correct machine is a Type I error, and the question asks about a Type II error. B: stopping a correct machine rejects a true H0, which is a Type I error. C: stopping an incorrect machine is the correct decision.

**N-3.8-C-v3.** A researcher tests H0: the new teaching method is no better than the current method versus Ha: the new method is better. Which statement correctly describes a Type I error?
- **A. The researcher concludes the new method is better when it is actually no better.**
- B. The researcher concludes the new method is no better when it is actually better.
- C. The researcher concludes the new method is no better when it is actually no better.
- D. The researcher concludes the new method is better when it is actually better.
Check: Type I means rejecting a true H0.
Rationales: B: failing to find an effect that exists is a Type II error. C: concluding no benefit when there is none is a correct decision, not an error. D: concluding a benefit when there really is one is a correct decision, not an error.

## N-3.9-A variants (difference of sample proportions)

**N-3.9-A-v1.** In one large school district 70% of students walk to school, and in another 55% walk. Independent random samples of 120 students from the first district and 100 students from the second district are selected. Which statement describes the sampling distribution of p-hat 1 - p-hat 2?
- A. Approximately normal with mean 0.15 and standard deviation 0.0916.
- B. Approximately normal with mean 0.15 and standard deviation 0.00422.
- **C. Approximately normal with mean 0.15 and standard deviation 0.0650.**
- D. Approximately normal with mean 1.27 and standard deviation 0.0650.
Check: variance = 0.7(0.3)/120 + 0.55(0.45)/100 = 0.00422; SD = 0.065; counts 84, 36, 55, 45 are at least 10.
Rationales: A: added the two standard deviations instead of adding the two variances and taking the square root. B: reported the variance as the standard deviation. D: divided the proportions instead of subtracting them.

**N-3.9-A-v2.** In each of two large cities, 30% of residents support a new tax. Independent random samples of 80 residents are taken from each city. Which statement describes the sampling distribution of p-hat 1 - p-hat 2?
- A. Approximately normal with mean 0.30 and standard deviation 0.0725.
- **B. Approximately normal with mean 0 and standard deviation 0.0725.**
- C. Approximately normal with mean 0 and standard deviation 0.00525.
- D. Approximately normal with mean 0 and standard deviation 0.1025.
Check: mean = 0; variance = 2 x 0.3(0.7)/80 = 0.00525; SD = 0.0725; counts 24 and 56 are at least 10.
Rationales: A: used the common proportion as the mean instead of the difference. C: reported the variance as the standard deviation. D: added the two standard deviations instead of adding the two variances and taking the square root.

**N-3.9-A-v3.** In population 1, 90% of members have a trait, and in population 2, 80% have it. Independent random samples of 40 members from population 1 and 60 from population 2 are taken. Which statement describes the sampling distribution of p-hat 1 - p-hat 2?
- A. Approximately normal with mean 0.10 and standard deviation 0.0701, since the sample sizes are both at least 30.
- **B. Mean 0.10 and standard deviation 0.0701, but not approximately normal, since 40(0.10) = 4 is less than 10.**
- C. Mean 0.10 and standard deviation 0.0991, and not approximately normal, since 40(0.10) = 4 is less than 10.
- D. Approximately normal with mean 0.10 and standard deviation 0.00492.
Check: variance = 0.9(0.1)/40 + 0.8(0.2)/60 = 0.00492; SD = 0.0701; n1(1 - p1) = 4 < 10.
Rationales: A: the rule of 30 does not apply; the large counts condition fails for population 1. C: the shape conclusion is right, but the standard deviation was found by adding the two standard deviations. D: reported the variance as the standard deviation and ignored the large counts condition.

## N-3.10-A variants (interpreting a difference interval)

**N-3.10-A-v1.** A tutoring company compares a new curriculum with its old curriculum. A 95% confidence interval for p_new - p_old, the difference in the proportions of all students who would pass an exam, is (-0.12, -0.03). Which interpretation is correct?
- **A. We are 95% confident that the proportion of all students who pass with the new curriculum is between 0.03 and 0.12 lower than the proportion with the old curriculum.**
- B. We are 95% confident that between 3% and 12% of all students pass.
- C. We are 95% confident that the proportion of all students who pass with the old curriculum is between 0.03 and 0.12 lower than with the new curriculum.
- D. There is a 95% chance that a student is between 3% and 12% less likely to pass with the new curriculum.
Check: the interval is for new - old and is negative, so new is lower.
Rationales: B: the interval estimates a difference between two proportions, not a single proportion. C: reversed the direction; negative new - old means the old proportion is higher. D: the interval is about population proportions, not about the chance for one student.

**N-3.10-A-v2.** A 90% confidence interval for p_T - p_C, the difference in the proportions of all patients who recover with a treatment and with a control, is (0.05, 0.19). Which interpretation is correct?
- **A. We are 90% confident that the proportion of all patients who recover with the treatment is between 0.05 and 0.19 higher than with the control.**
- B. We are 90% confident that between 5% and 19% of all patients recover.
- C. Between 5% and 19% of patients in the sample recovered with the treatment.
- D. We are 90% confident that the proportion who recover with the control is between 0.05 and 0.19 higher than with the treatment.
Check: the interval for T - C is entirely positive, so the treatment proportion is higher.
Rationales: B: the interval describes a difference, not a single proportion. C: the interval is about the populations, not the patients in the sample. D: reversed the direction of the comparison, since a positive T - C means the treatment proportion is the higher one.

**N-3.10-A-v3.** A 95% confidence interval for p_1 - p_2, the difference in the proportions of all adults in two cities who favor a plan, is (-0.04, 0.08). Which interpretation is correct?
- **A. We are 95% confident that p_1 - p_2 is between -0.04 and 0.08, so a difference of zero is a plausible value.**
- B. We are 95% confident that p_1 equals p_2, because the interval contains 0.
- C. We are 95% confident that p_1 is between 4% and 8% higher than p_2.
- D. There is a 95% probability that p-hat 1 - p-hat 2 in a new sample falls between -0.04 and 0.08.
Check: the interval contains 0 so equal proportions are plausible but not proven.
Rationales: B: an interval containing 0 shows that no difference is plausible, not that the proportions are equal. C: the interval includes negative values, so p_1 could be lower than p_2. D: the confidence level refers to the method capturing the population difference.

## N-3.11-A variants (supporting claims from a difference interval)

**N-3.11-A-v1.** A 95% confidence interval for p_1 - p_2, the difference in the proportions of all customers in two regions who prefer a product, is (0.03, 0.17). A manager claims that the proportion in region 1 is at least 0.10 higher than in region 2. Which statement is correct?
- A. The interval supports the claim, because the whole interval is positive.
- B. The interval supports the claim, because the center of the interval, 0.10, equals 0.10.
- **C. The interval shows region 1 is higher, but it does not support the claim of at least 0.10, because values below 0.10 are plausible.**
- D. The interval does not show region 1 is higher, because the lower endpoint 0.03 is close to 0.
Check: all plausible differences are positive; 0.03 to 0.10 are plausible and below the claimed value.
Rationales: A: a positive interval supports a positive difference, not a difference of at least 0.10. B: the midpoint is the sample difference; the claim needs every plausible value to be at least 0.10. D: any interval entirely above 0 supports a positive difference.

**N-3.11-A-v2.** A 90% confidence interval for p_1 - p_2 is (0.01, 0.15), and a 99% confidence interval computed from the same data is (-0.03, 0.19). A researcher claims p_1 is greater than p_2. Which statement is correct?
- A. The claim is supported at both confidence levels, because the 99% interval is wider.
- **B. The claim is supported at the 90% confidence level but not at the 99% level, because 0 is plausible in the 99% interval.**
- C. The claim is not supported at either level, because the intervals are different.
- D. The claim is supported at the 99% level but not at the 90% level, because higher confidence is stronger evidence.
Check: 90% interval excludes 0; 99% interval contains 0.
Rationales: A: the 99% interval contains 0, so it does not rule out no difference. C: different intervals from different levels do not contradict each other; each answers its own level. D: a higher confidence level makes the interval wider, which makes it harder to exclude 0.

**N-3.11-A-v3.** A 95% confidence interval for p_B - p_A, the difference in the proportions of all voters who support a candidate in group B and in group A, is (0.04, 0.12). A pollster claims that group A has the higher proportion. Which statement is correct?
- A. The claim is supported, because 0.04 and 0.12 are both positive.
- B. The claim is not supported, because the interval does not contain 0.
- **C. The claim is not supported; the interval suggests group B has the higher proportion, since every plausible value of p_B - p_A is positive.**
- D. The claim cannot be judged, because the interval does not say which group is larger.
Check: p_B - p_A > 0 means B is higher.
Rationales: A: positive values of B - A mean B is larger, not A. B: the interval excluding 0 shows a difference, but its direction contradicts the claim. D: the order in the subtraction tells which group is larger.

## N-3.12-A variants (hypotheses for a difference)

**N-3.12-A-v1.** A researcher wants to know whether the proportion of adults who exercise regularly is different for people who live in cities (population 1) and people who live in rural areas (population 2). In independent random samples, 90 of 150 city residents and 70 of 120 rural residents exercise regularly. Which hypotheses should be tested?
- A. H0: p_1 - p_2 = 0 versus Ha: p_1 - p_2 > 0, where p_1 and p_2 are the proportions of all residents who exercise regularly in each setting.
- B. H0: p-hat 1 = p-hat 2 versus Ha: p-hat 1 != p-hat 2.
- **C. H0: p_1 - p_2 = 0 versus Ha: p_1 - p_2 != 0, where p_1 and p_2 are the proportions of all residents who exercise regularly in each setting.**
- D. H0: p_1 - p_2 = 0.017 versus Ha: p_1 - p_2 != 0.017, where p_1 and p_2 are the proportions of all residents who exercise regularly in each setting.
Check: "different" is two-sided; sample proportions are 0.60 and 0.583.
Rationales: A: the question asks about any difference, not only that city residents are higher. B: hypotheses are about population parameters, not statistics. D: used the sample difference as the null value.

**N-3.12-A-v2.** A factory manager wants evidence that a new process produces a lower proportion of defective items than the old process. In independent random samples, 24 of 200 items from the new process and 18 of 200 items from the old process were defective. Which hypotheses should be tested?
- A. H0: p_new - p_old = 0 versus Ha: p_new - p_old > 0, where p_new and p_old are the proportions of all items that are defective.
- **B. H0: p_new - p_old = 0 versus Ha: p_new - p_old < 0, where p_new and p_old are the proportions of all items that are defective.**
- C. H0: p_new - p_old = 0.03 versus Ha: p_new - p_old < 0.03, where p_new and p_old are the proportions of all items that are defective.
- D. H0: p-hat new - p-hat old = 0 versus Ha: p-hat new - p-hat old < 0.
Check: the question asks whether new is lower than old, even though the sample has new (0.12) higher than old (0.09).
Rationales: A: followed the sample result (new was higher in the sample) instead of the question. C: used the sample difference 0.03 as the null value. D: hypotheses are about parameters, not statistics.

**N-3.12-A-v3.** A pollster wants to test whether the proportion of voters who support a measure is greater among voters under 30 (population 1) than among voters 30 and over (population 2). In independent random samples, 45 of 100 young voters and 60 of 120 older voters support the measure. Which hypotheses should be tested?
- A. H0: p_1 - p_2 = 0 versus Ha: p_1 - p_2 < 0, where p_1 and p_2 are the proportions of all voters in each group who support the measure.
- B. H0: p_1 - p_2 = -0.05 versus Ha: p_1 - p_2 > -0.05, where p_1 and p_2 are the proportions of all voters in each group who support the measure.
- **C. H0: p_1 - p_2 = 0 versus Ha: p_1 - p_2 > 0, where p_1 and p_2 are the proportions of all voters in each group who support the measure.**
- D. H0: p_1 = p_2 versus Ha: p-hat 1 > p-hat 2.
Check: the question asks whether young voters are higher; the sample proportions are 0.45 and 0.50.
Rationales: A: followed the sample result (young voters were lower in the sample). B: used the sample difference as the null value. D: mixes a parameter statement in the null with a statistic statement in the alternative.

## N-3.13-A variants (two-proportion z-test)

**N-3.13-A-v1.** In a random sample of 120 customers who received coupon A, 66 redeemed it; in an independent random sample of 100 customers who received coupon B, 45 redeemed it. A test of H0: p_A = p_B versus Ha: p_A > p_B uses the pooled proportion 111/220 = 0.505. For a standard normal distribution, P(Z > 1.48) = 0.069. Which result is correct at alpha = 0.05?
- **A. z = 1.48, p-value = 0.069; fail to reject H0, so there is not convincing evidence that the redemption rate for coupon A is higher.**
- B. z = 1.48, p-value = 0.139; fail to reject H0, so there is not convincing evidence that the redemption rate for coupon A is higher.
- C. z = 2.97, p-value = 0.001; reject H0, so there is convincing evidence that the redemption rate for coupon A is higher.
- D. z = 1.48, p-value = 0.069; reject H0, because 0.069 is close to 0.05.
Check: p-hat A = 0.55, p-hat B = 0.45; SE = sqrt(0.505 x 0.495 x (1/120 + 1/100)) = 0.0677; z = 0.10 / 0.0677 = 1.48.
Rationales: B: doubled the tail area, but the alternative is one-sided. C: divided the pooled variance by n1 + n2, which makes the standard error too small. D: a p-value above alpha means fail to reject, no matter how close it is.

**N-3.13-A-v2.** In a random sample of 130 members of group 1, 39 prefer a plan; in an independent random sample of 90 members of group 2, 54 prefer it. A test of H0: p_1 = p_2 versus Ha: p_1 != p_2 uses the pooled proportion 93/220 = 0.423. Which result is correct at alpha = 0.05?
- **A. z = -4.43, p-value < 0.001; reject H0, so there is convincing evidence that the proportions differ.**
- B. z = -9.01, p-value < 0.001; reject H0, so there is convincing evidence that the proportions differ.
- C. z = -4.43, p-value = 0.99; fail to reject H0.
- D. z = -4.58, p-value < 0.001; reject H0, so there is convincing evidence that the proportions differ.
Check: p-hat 1 = 0.30, p-hat 2 = 0.60; SE = sqrt(0.423 x 0.577 x (1/130 + 1/90)) = 0.0677; z = -0.30 / 0.0677 = -4.43.
Rationales: B: divided the pooled variance by n1 + n2, which makes the standard error too small. C: used the wrong tail of the distribution for a statistic far below 0. D: used separate (unpooled) proportions in the standard error; under H0: p_1 = p_2 the pooled proportion is used.

**N-3.13-A-v3.** In a random sample of 160 patients given treatment X, 72 improved; in an independent random sample of 140 patients given treatment Y, 50 improved. A test of H0: p_X = p_Y versus Ha: p_X > p_Y uses the pooled proportion 122/300 = 0.407. For a standard normal distribution, P(Z > 1.63) = 0.052. Which result is correct at alpha = 0.05?
- A. z = 1.63, p-value = 0.103; fail to reject H0.
- B. z = 3.27, p-value = 0.001; reject H0, so there is convincing evidence that X is better.
- **C. z = 1.63, p-value = 0.052; fail to reject H0, so there is not convincing evidence that treatment X has the higher improvement rate.**
- D. z = 1.63, p-value = 0.052; reject H0, because 0.052 rounds to 0.05.
Check: p-hat X = 0.45, p-hat Y = 0.357; SE = sqrt(0.407 x 0.593 x (1/160 + 1/140)) = 0.0568; z = 0.093 / 0.0568 = 1.63.
Rationales: A: doubled the tail area, but the alternative is one-sided. B: divided the pooled variance by n1 + n2 instead of using 1/n1 + 1/n2, which makes the standard error too small. D: a p-value of 0.052 is not less than alpha = 0.05, so H0 is not rejected.

## N-3.14-A variants (homogeneity or independence, and df)

**N-3.14-A-v1.** A researcher randomly selects 400 adults from one city and records each adult's age group (3 groups) and favorite social media platform (3 platforms). The researcher wants to know whether age group and favorite platform are associated. Which test and degrees of freedom are correct?
- A. A test of homogeneity, with df = 4.
- **B. A test of independence, with df = (3 - 1)(3 - 1) = 4.**
- C. A test of independence, with df = 9.
- D. A test of independence, with df = 3.
Check: one sample classified on two variables gives independence; df = 2 x 2 = 4.
Rationales: A: homogeneity applies to separate samples from different populations, and here there is one sample. C: used rows times columns instead of (rows - 1)(columns - 1) for the degrees of freedom. D: used the number of categories minus 1 for one variable only.

**N-3.14-A-v2.** A health researcher takes independent random samples of 100 patients from each of two clinics and records whether each patient's outcome is improved, unchanged or worse. The researcher wants to know whether the distribution of outcomes is the same at the two clinics. Which test and degrees of freedom are correct?
- A. A test of independence, with df = 2.
- B. A test of homogeneity, with df = 5.
- **C. A test of homogeneity, with df = (2 - 1)(3 - 1) = 2.**
- D. A test of homogeneity, with df = 1.
Check: separate samples from two populations gives homogeneity; df = 1 x 2 = 2.
Rationales: A: independence applies to one sample classified on two variables. B: used the number of cells minus 1, which is the degrees of freedom for a goodness-of-fit test, not for a two-way table. D: used the number of clinics minus 1 only.

**N-3.14-A-v3.** A random sample of 300 students is classified by grade level (freshman, sophomore, junior, senior) and by whether the student owns a car (yes or no). The researcher wants to know whether grade level and car ownership are related. Which test and degrees of freedom are correct?
- A. A test of independence, with df = 8.
- B. A test of homogeneity, with df = 3.
- **C. A test of independence, with df = (4 - 1)(2 - 1) = 3.**
- D. A test of independence, with df = 5.
Check: one sample classified on two variables gives independence; df = 3 x 1 = 3.
Rationales: A: used rows times columns instead of (rows - 1)(columns - 1) for the degrees of freedom. B: homogeneity applies to separate samples from different populations, and here there is one sample. D: added the numbers of rows and columns minus 1.

## N-3.15-A variants (expected counts and conditions)

**N-3.15-A-v1.** A random sample of 100 people was classified by group and response. Group 1 (40 people): 4 responded yes and 36 responded no. Group 2 (60 people): 16 responded yes and 44 responded no. A researcher plans a chi-square test. Which statement about the conditions is correct?
- A. The conditions are not met, because the observed count of 4 is less than 5.
- **B. The expected counts condition is met, because every expected count is at least 5; the smallest is 40(20)/100 = 8.**
- C. The conditions are not met, because the two groups are not the same size.
- D. The expected counts condition is met, because the observed counts add to 100.
Check: column totals 20 and 80; expected counts: 8, 32, 12, 48.
Rationales: A: the condition applies to expected counts, and an observed count below 5 does not violate it. C: groups of different sizes do not violate any condition, because the check is on expected counts. D: the total being 100 does not by itself guarantee every expected count is at least 5.

**N-3.15-A-v2.** A chi-square test of independence is planned for a random sample of 200 people classified in a 3 x 3 table. The row totals are 30, 50 and 120, and the column totals are 10, 90 and 100. Which statement is correct?
- A. The expected counts condition is met, because the sample size of 200 is large.
- B. The expected counts condition is met, because every row total is at least 30.
- **C. The expected counts condition is not met, because some expected counts are less than 5; for example, 30(10)/200 = 1.5.**
- D. The expected counts condition is not met, because the column totals are not equal.
Check: expected count for row 1, column 1 = 1.5 < 5; row 2, column 1 = 2.5.
Rationales: A: the total sample size does not guarantee that every expected count is large. B: the condition is about expected counts in every cell, not row totals. D: unequal column totals do not violate the condition, because the check is on each expected count.

**N-3.15-A-v3.** A chi-square test of independence on a 3 x 3 table gives a test statistic of 11.5. For a chi-square distribution with 4 degrees of freedom, P(chi-square > 9.49) = 0.05 and P(chi-square > 13.28) = 0.01. Which conclusion is correct at alpha = 0.05?
- A. Fail to reject H0, because 11.5 is less than 13.28.
- **B. Reject H0, because 11.5 is greater than 9.49; the p-value is between 0.01 and 0.05, so there is convincing evidence of an association.**
- C. Reject H0, because the test statistic is greater than 4, the number of degrees of freedom.
- D. Reject H0, because 11.5 proves that the two variables are related by cause and effect.
Check: df = (3 - 1)(3 - 1) = 4; 9.49 < 11.5 < 13.28.
Rationales: A: compared with the critical value for 0.01 instead of alpha = 0.05. C: the comparison is with a critical value or p-value, not with the degrees of freedom. D: a significant association does not establish cause and effect.
