# AP Statistics Unit 3 topics 3.7, 3.12 and 3.14: second seeds

DRAFT. Author-in-session; numbers recomputed in Python. Each of these topics had one seed family (R2, with an R1-leaning variant) and a teaching item. This adds a second, harder seed per topic; nothing is retired.

| Seed | Topic | Skill |
|---|---|---|
| N-3.7-B | 3.7 Carrying out a test for a proportion | statistic, p-value and conclusion, with the traps of tail, doubling and p-value meaning |
| N-3.12-B | 3.12 Setting up a test for a difference of proportions | conditions and the pooled proportion |
| N-3.14-B | 3.14 Setting up a chi-square test | hypotheses and expected-count conditions |

---

## Seed N-3.7-B — Topic 3.7 Carrying Out a Test for a Population Proportion
**Skill:** carry out a one-proportion z-test and state the conclusion without the common tail and interpretation errors.

A company claims that 40% of its customers renew their subscription. A random sample of 150 customers, a small fraction of all customers, shows that 33% renewed. A manager tests H0: p = 0.40 versus Ha: p < 0.40 at the 5% significance level. Which choice gives the correct test statistic, p-value and conclusion?

- A. z ≈ −1.75 and p ≈ 0.08, so there is not convincing evidence that fewer than 40% of customers renew.
- B. z ≈ −1.75 and p ≈ 0.04, so there is a 4% probability that the company's claim is true.
- C. z ≈ −1.75 and p ≈ 0.96, so there is not convincing evidence that fewer than 40% of customers renew.
- **D. z ≈ −1.75 and p ≈ 0.04, so there is convincing evidence that fewer than 40% of customers renew.**

Check: SE = sqrt(0.40 × 0.60 / 150) = 0.04; z = (0.33 − 0.40)/0.04 = −1.75; the lower-tail p-value is 0.040, which is below 0.05.
Rationales: A: the alternative is one-sided, so the p-value is not doubled; doubling gives 0.08 and reverses the conclusion. B: a p-value is the probability of a result this extreme if H0 is true, not the probability that H0 is true. C: the alternative p < 0.40 asks for the lower tail, and 0.96 is the upper tail.

**N-3.7-B-v1.** A supplier claims that 30% of its parts are defective. A random sample of 250 parts, a small fraction of the shipment, has 35% defective. An inspector tests H0: p = 0.30 versus Ha: p ≠ 0.30 at the 5% significance level. Which choice gives the correct test statistic, p-value and conclusion?

- A. z ≈ 1.72 and p ≈ 0.042, so there is convincing evidence that the proportion differs from 0.30.
- B. z ≈ 1.72 and p ≈ 0.085, so the data prove that the proportion is 0.30.
- C. z ≈ 1.66 and p ≈ 0.098, so there is not convincing evidence that the proportion differs from 0.30.
- **D. z ≈ 1.72 and p ≈ 0.085, so there is not convincing evidence that the proportion differs from 0.30.**

Check: SE = sqrt(0.30 × 0.70 / 250) = 0.0290; z = 0.05/0.0290 = 1.72; the two-sided p-value is 2 × 0.0422 = 0.085 > 0.05.
Rationales: A: the alternative is two-sided, so the tail area must be doubled; 0.042 is a one-tail area. B: failing to reject does not prove that H0 is true. C: this standard error uses p̂ instead of the hypothesized p0, which is not how a test of a proportion is done.

**N-3.7-B-v2.** A town claims that 50% of voters support a measure. A random sample of 400 voters, a small fraction of all voters, has 54.5% in support. A researcher tests H0: p = 0.50 versus Ha: p > 0.50 at the 1% significance level. Which choice gives the correct test statistic, p-value and conclusion?

- A. z ≈ 1.80 and p ≈ 0.036, so there is convincing evidence that more than 50% support the measure.
- B. z ≈ 1.80 and p ≈ 0.072, so there is not convincing evidence that more than 50% support the measure.
- C. z ≈ 0.09 and p ≈ 0.46, so there is not convincing evidence that more than 50% support the measure.
- **D. z ≈ 1.80 and p ≈ 0.036, so there is not convincing evidence that more than 50% support the measure.**

Check: SE = sqrt(0.5 × 0.5 / 400) = 0.025; z = 0.045/0.025 = 1.80; the upper-tail p-value is 0.036, which is greater than 0.01.
Rationales: A: the p-value 0.036 is below 0.05 but not below the stated significance level of 0.01, so H0 is not rejected. B: the alternative is one-sided, so the p-value is not doubled. C: this leaves the sample size out of the standard error, which makes z far too small.

**N-3.7-B-v3.** A phone maker claims that 25% of its phones need a repair within a year. In a random sample of 120 phones, a small fraction of all phones, 18% needed a repair. For H0: p = 0.25 versus Ha: p < 0.25, the p-value is about 0.038. Which statement correctly interprets this p-value?

- A. There is a 3.8% probability that the true proportion is 0.25.
- **B. If the true proportion were 0.25, about 3.8% of samples of 120 phones would have a proportion of 0.18 or lower.**
- C. The probability that exactly 18% of a sample of 120 phones need a repair is 3.8%.
- D. There is a 3.8% probability that the true proportion is less than 0.25.

Check: the p-value is P(p̂ ≤ 0.18 | p = 0.25); here z = (0.18 − 0.25)/sqrt(0.25 × 0.75/120) = −1.77 and the lower-tail area is 0.038.
Rationales: A: the p-value is computed assuming the null is true, so it is not the probability that the null is true. C: the p-value is a tail probability for results at least this extreme, not the probability of exactly the observed value. D: a p-value is not the probability of the alternative hypothesis, since the parameter is fixed and not random.

---

## Seed N-3.12-B — Topic 3.12 Setting Up a Test for the Difference Between Two Population Proportions
**Skill:** check the conditions for a two-proportion z-test, including large counts computed from the pooled proportion.

Two independent random samples, each a small fraction of its population, are used to test H0: p1 − p2 = 0. Sample 1 has 6 successes out of 40 and sample 2 has 9 successes out of 50. Which statement about the large counts condition for the two-proportion z-test is correct?

- A. The condition is met, because each sample has at least 5 successes.
- B. The condition is met, because both sample sizes are at least 30.
- C. The condition is not met, because the sample proportions 0.15 and 0.18 are not equal.
- **D. The condition is not met, because with the pooled proportion 15/90 ≈ 0.167, the expected successes are 40(0.167) ≈ 6.7 and 50(0.167) ≈ 8.3, both less than 10.**

Check: pooled p̂c = (6 + 9)/(40 + 50) = 0.167; n1·p̂c = 6.67 and n2·p̂c = 8.33 are below 10.
Rationales: A: the counts to check are n·p̂c and n·(1 − p̂c) for each sample, and the threshold is 10, not 5. B: a sample size of at least 30 is not the large counts condition for proportions. C: the sample proportions are not expected to be equal even when H0 is true, and equality is not a condition.

**N-3.12-B-v1.** An analyst takes an independent random sample of 40 workers from a plant of 300 workers and a sample of 50 workers from a plant of 600 workers, and plans a two-proportion z-test of H0: p1 − p2 = 0. In sample 1, 18 workers are satisfied; in sample 2, 25 are satisfied. Which condition is NOT met?

- A. The large counts condition, because 18 is less than 25.
- B. The random condition, because the plants have different sizes.
- **C. The independence (10%) condition for sample 1, because 40 is more than 10% of 300.**
- D. All conditions are met, because both samples are random.

Check: 40/300 = 13.3% > 10%, while 50/600 = 8.3%; pooled p̂c = 43/90 = 0.478, so all counts are far above 10.
Rationales: A: large counts uses the pooled proportion with each sample size, and all those counts are well above 10. B: the plants can have different sizes, and the random condition is about how each sample was selected. D: the 10% condition fails for sample 1, so being random is not enough.

**N-3.12-B-v2.** A statistician carries out a two-proportion z-test of H0: p1 − p2 = 0 and uses the pooled proportion in the standard error. Which statement best explains why the pooled proportion is used for the test?

- **A. If H0 is true, both samples come from populations with the same proportion, so the combined sample gives the best single estimate of that proportion.**
- B. The pooled proportion is always closer to the true value than either sample proportion, even when H0 is false.
- C. Pooling always makes the standard error larger, which guarantees that the test is conservative.
- D. The pooled proportion is also used for confidence intervals, so the test and the interval must agree.

Check: under H0 the common proportion p is estimated by total successes over total trials; the standard error is computed assuming H0 is true.
Rationales: B: when H0 is false the two populations differ, so a single pooled value does not estimate either population well. C: pooling changes the standard error in either direction depending on the data, and it does not guarantee a conservative test. D: a confidence interval for a difference does not assume equal proportions, so it uses the two sample proportions separately.

**N-3.12-B-v3.** Volunteers are randomly assigned to two treatments: 30 of 60 improve with treatment 1 and 28 of 70 improve with treatment 2. A student plans a two-proportion z-test of H0: p1 − p2 = 0. Which statement is correct?

- A. The test cannot be done, because the volunteers were not randomly sampled from a population.
- B. The test is not appropriate, because 130 volunteers is not less than 10% of any population.
- **C. The conditions are met: the treatments were randomly assigned and, with the pooled proportion 58/130 ≈ 0.446, all expected counts are at least 10.**
- D. The large counts condition is not met, because 28 is less than 30.

Check: random assignment replaces random sampling in an experiment, so the 10% condition is not needed; 60(0.446) ≈ 26.8, 60(0.554) ≈ 33.2, 70(0.446) ≈ 31.2, 70(0.554) ≈ 38.8.
Rationales: A: in an experiment, random assignment of treatments takes the place of random sampling for the conditions. B: the 10% condition applies to sampling without replacement from a population, and not to randomly assigned groups. D: the large counts condition uses the pooled proportion, and all of those counts are above 10.

---

## Seed N-3.14-B — Topic 3.14 Setting Up a Chi-Square Test for Homogeneity or Independence
**Skill:** state chi-square hypotheses correctly and check the expected-count condition.

A random sample of 200 residents of a city is classified by age group (3 groups) and by usual transportation mode (4 modes). Which hypotheses are appropriate for a chi-square test?

- **A. H0: Age group and transportation mode are independent in the population of residents. Ha: Age group and transportation mode are not independent.**
- B. H0: In the sample, the proportion using each mode is the same in every age group. Ha: In the sample, the proportions differ.
- C. H0: The four transportation modes are equally likely. Ha: The four transportation modes are not equally likely.
- D. H0: Age group and transportation mode are independent. Ha: Age group and transportation mode are positively correlated.

Check: one sample classified on two categorical variables calls for a test of independence, with hypotheses about the population.
Rationales: B: hypotheses are about the population, not the sample, and this setup would suit a test of homogeneity with separate samples. C: this describes a goodness-of-fit test for a single variable and does not involve two variables. D: correlation applies to quantitative variables, and the alternative for a chi-square test is only that the variables are not independent.

**N-3.14-B-v1.** A quality manager takes independent random samples of 100 items from each of three plants and classifies each item by defect type (4 types). Which hypotheses are appropriate for a chi-square test?

- A. H0: Defect type and plant are independent. Ha: Defect type and plant are not independent.
- **B. H0: The distribution of defect types is the same in the populations of items from the three plants. Ha: The distribution of defect types is not the same in all three populations.**
- C. H0: In the samples, the distribution of defect types is the same for each plant. Ha: In the samples, the distributions differ.
- D. H0: The mean number of defects is the same at the three plants. Ha: At least one mean is different.

Check: independent random samples from several populations, with one categorical response, calls for a test of homogeneity.
Rationales: A: this states the hypotheses of a test of independence, which fits one sample classified on two variables and not separate samples from each plant. C: hypotheses must be about the populations, since samples would almost never have identical distributions. D: the response is categorical, so means are not defined, and this is a hypothesis for a different procedure.

**N-3.14-B-v2.** A chi-square test is planned for the table below, from a random sample of 70 people classified by group (rows) and response (columns).

| | Response 1 | Response 2 | Response 3 | Total |
|---|---|---|---|---|
| Group 1 | 12 | 18 | 10 | 40 |
| Group 2 | 5 | 9 | 16 | 30 |
| Total | 17 | 27 | 26 | 70 |

Which statement about the expected count for Group 2, Response 1 and the condition is correct?

- **A. The expected count is 7.29, and all expected counts are at least 5, so the condition is met.**
- B. The expected count is 5, and the condition is not met because that count is below 10.
- C. The expected count is 10, so the condition is met.
- D. The expected count is 7.29, but the condition requires all expected counts to be at least 10, so it is not met.

Check: expected = (30 × 17)/70 = 7.29; the smallest expected count is 7.29, which is at least 5.
Rationales: B: the expected count is not the observed count, and the usual threshold for expected counts is 5, not 10. C: this divides the row total by 3 and ignores the column total. D: the standard condition is that every expected count is at least 5.

**N-3.14-B-v3.** A random sample of 90 students is classified by grade (rows: Freshman 40, Sophomore 30, Junior 20) and by whether they own a car (columns: Yes 70, No 20), with observed counts Freshman 30 and 10, Sophomore 22 and 8, Junior 18 and 2. Which statement about the expected count for Junior, No and the large counts condition is correct?

- **A. The expected count is 4.44, which is less than 5, so the condition is not met.**
- B. The expected count equals the observed count of 2, which is less than 5, so the condition is not met.
- C. The expected count is 4.44, but the condition only requires that observed counts be at least 5, so it is met.
- D. The expected count is 10, so the condition is met.

Check: expected = (20 × 20)/90 = 4.44 < 5, so the condition on expected counts fails.
Rationales: B: an expected count comes from the row and column totals and is not the observed count, so it is not 2 here. C: the condition applies to expected counts, so the small expected value matters. D: this does not use the row and column totals, which give 20 × 20 / 90.
