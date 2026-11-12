# AP Statistics Unit 1 topics 1.8 to 1.13: harder seeds (second batch)

DRAFT. Author-in-session; numbers recomputed in Python. Each seed is a harder, multi-step or misconception-based item with three variants; nothing is retired.

| Seed | Topic | Replaces |
|---|---|---|
| N-1.8-A | 1.8 Graphical Representations of Summary Statistics for One Quantitative Variable | new |
| N-1.8-B | 1.8 Graphical Representations of Summary Statistics for One Quantitative Variable | new |
| N-1.9-A | 1.9 Comparisons of the Distributions for One Quantitative Variable | new |
| N-1.9-B | 1.9 Comparisons of the Distributions for One Quantitative Variable | new |
| N-1.10-A | 1.10 The Investigative Question Revisited and Data Collection | new |
| N-1.10-B | 1.10 The Investigative Question Revisited and Data Collection | new |
| N-1.11-A | 1.11 Random Sampling | new |
| N-1.11-B | 1.11 Random Sampling | new |
| N-1.12-A | 1.12 Potential Problems with Sampling | new |
| N-1.12-B | 1.12 Potential Problems with Sampling | new |
| N-1.13-A | 1.13 Experimental Design | new |
| N-1.13-B | 1.13 Experimental Design | new |

---

## Seed N-1.8-A (new) — Topic 1.8 Graphical Representations of Summary Statistics for One Quantitative Variable
**Skill:** reason about how correcting an outlying value changes (and does not change) a modified boxplot, fences, whiskers and summary statistics.

A data set of 40 delivery times (minutes) has minimum 6, Q1 15, median 19, Q3 27 and maximum 61, and the next-largest value is 33. The value 61 was a data-entry error, and the correct value is 38. After the correction, which statement about the modified boxplot is correct?

- A. The upper whisker ends at the upper fence of 45, because 38 is inside the fence.
- B. The IQR decreases, so the box becomes shorter, because the maximum value decreased.
- **C. Only the maximum of the five-number summary changes, the point at 61 is no longer plotted, and the upper whisker now ends at 38.**
- D. The median decreases, because the corrected value is smaller than the original one.

Check: IQR = 27 − 15 = 12, upper fence = 27 + 1.5(12) = 45; 61 was beyond it but 38 is not, and 38 exceeds 33, so it becomes the largest non-outlier.
Rationales: A: A whisker ends at the largest actual data value inside the fence, not at the fence itself, so it ends at 38. B: The IQR is Q3 minus Q1 and the corrected value lies above Q3 both before and after, so the box does not change. D: The median depends on the position of the middle value, and the changed value stays above the median, so the median stays at 19.

**N-1.8-A-v1.** A data set of 50 service times (minutes) has minimum 5, Q1 14, median 18, Q3 26 and maximum 70, and the next-largest value is 35. The value 70 was a typing error, and the correct value is 53. After the correction, which statement about the modified boxplot is correct?

- **A. The point is still plotted as an outlier, now at 53, the upper whisker still ends at 35, and the box is unchanged.**
- B. The point is no longer an outlier, because 53 is smaller than 70, and the whisker extends to 53.
- C. The upper whisker extends to the fence at 44, because the maximum moved closer to it.
- D. Q3 decreases, so the box becomes shorter, because the maximum decreased.

Check: IQR = 26 − 14 = 12, upper fence = 26 + 18 = 44; 53 > 44 so it remains an outlier and the whisker still ends at the largest value inside the fence, 35.
Rationales: B: Being smaller than before does not remove an outlier; the upper fence is 44 and 53 is still beyond it. C: Whiskers end at actual data values, and the largest value inside the fence is 35, so the whisker stays at 35. D: The changed value stays above Q3, so the third quartile and the box are exactly as before.

**N-1.8-A-v2.** A set of 50 quiz scores has minimum 5, Q1 62, median 71, Q3 80 and maximum 99. The minimum of 5 was a recording error, and the correct score is 38. Which statement about the numerical summaries after the correction is correct?

- A. The mean, median, Q1, Q3 and standard deviation all stay the same, because only the minimum changes.
- B. The median increases, because the mean increases.
- C. The IQR decreases, because the range of the data decreases.
- **D. The median, Q1, Q3 and IQR do not change, the mean increases, and the standard deviation decreases.**

Check: Both 5 and 38 lie below Q1, so the order positions of Q1, median and Q3 are unchanged; replacing 5 by 38 raises the sum and removes a large deviation from the mean.
Rationales: A: The mean and standard deviation use every value, so replacing 5 with 38 changes them even though the quartiles are resistant. B: The median depends only on the middle position, and the corrected value stays below the median, so the median does not move. C: The IQR comes from Q1 and Q3 only, and both stay the same; only the range shrinks.

**N-1.8-A-v3.** A boxplot of 60 daily step counts (in thousands) has Q1 6.0, median 8.5 and Q3 11.0, the upper whisker ends at 15.5, and one point at 21.0 is plotted as an outlier. The 21.0 is correct. Suppose instead that this participant had recorded 40.0. Which statement is correct?

- A. The upper fence moves above 40.0, because the maximum is larger, so the point may no longer be an outlier.
- **B. The upper fence stays at 18.5 and the quartiles stay the same, so the point is still an outlier but is plotted higher.**
- C. The upper whisker extends to 40.0, because a whisker always ends at the maximum.
- D. Q3 and the IQR increase, because the data now contain a larger value.

Check: IQR = 11.0 − 6.0 = 5.0, upper fence = 11.0 + 7.5 = 18.5; both 21.0 and 40.0 exceed it, and replacing one value above Q3 leaves the quartiles unchanged.
Rationales: A: The fence is computed from Q3 and the IQR, not from the maximum, so one larger value does not move it. C: A whisker ends at the largest value inside the fence; 40.0 is beyond the fence at 18.5 so it is plotted separately. D: The quartiles are resistant to one extreme value that stays above Q3, so Q3 and the IQR are unchanged.
---

## Seed N-1.8-B (new) — Topic 1.8 Graphical Representations of Summary Statistics for One Quantitative Variable
**Skill:** interpret what a boxplot does and does not show about proportions of data, skew and shape.

A boxplot of 200 exam scores shows a minimum of 43, Q1 55, median 62, Q3 84 and a maximum of 98, with no outliers. Which statement is best supported by the boxplot?

- A. Fewer students scored between 55 and 62 than between 62 and 84, because the first interval is shorter.
- **B. Half of the students scored above 62, and those scores are spread over a wider interval than the scores below 62, which suggests the distribution is skewed right.**
- C. About half of the students scored between 62 and 84, because that interval is the right part of the box.
- D. The distribution is bimodal, because the median line splits the box into two parts.

Check: Quartile gaps: 62 − 55 = 7 below the median and 84 − 62 = 22 above it; each quarter of the data lies between consecutive summary values, so the upper quarters are stretched out.
Rationales: A: Each section between consecutive quartiles holds about 25% of the data regardless of its length, so both hold about 50 students. C: The whole box from 55 to 84 holds about 50% of the data, so 62 to 84 holds only about 25%. D: A boxplot does not display peaks, so it cannot show that a distribution has two modes.

**N-1.8-B-v1.** A boxplot of 150 phone-battery lifetimes (hours) shows a minimum of 9, Q1 31, median 38, Q3 42 and a maximum of 47. Which statement is best supported by the boxplot?

- A. The distribution is skewed right, because most of the lifetimes are bunched at the high end.
- B. About 75% of the batteries last between 31 and 42 hours, because that interval is the box.
- C. The mean battery life is greater than 38 hours, because the median is closer to Q3 than to Q1.
- **D. About 75% of the batteries last longer than 31 hours, and the long lower whisker suggests the distribution is skewed left.**

Check: Q1 = 31 means about 75% of values are above 31; the lower whisker spans 31 − 9 = 22 hours while the upper whisker spans only 47 − 42 = 5 hours.
Rationales: A: Skew is named by the direction of the longer tail; the longer tail here is on the low side, so the distribution is skewed left. B: The box from Q1 to Q3 holds only about 50% of the data, not 75%. C: With the long tail on the low side, the mean is pulled below the median, so it is expected to be less than 38.

**N-1.8-B-v2.** A boxplot summarizes 120 reaction times (milliseconds). Which of the following can NOT be determined from the boxplot alone?

- **A. Whether the distribution of reaction times has one peak or two peaks.**
- B. The approximate value of the median reaction time.
- C. Whether any reaction times would be flagged as outliers by the 1.5 IQR rule.
- D. The approximate size of the IQR.

Check: A boxplot shows only the five-number summary and flagged outliers, so features such as modes require a histogram or dotplot.
Rationales: B: The median is marked by the line inside the box, so it can be read from the plot. C: Modified boxplots show flagged values as separate points beyond the whiskers, so these can be seen. D: The IQR is the length of the box, from Q1 to Q3, so it can be read from the plot.

**N-1.8-B-v3.** A boxplot of 80 delivery times (minutes) has Q1 31, median 40 and Q3 52. About how many of the 80 deliveries took between 31 and 52 minutes?

- A. About 20 deliveries.
- B. About 60 deliveries.
- **C. About 40 deliveries.**
- D. About 21 deliveries.

Check: Q1 to Q3 contains the middle 50% of the data, so 0.50 × 80 = 40 deliveries.
Rationales: A: One quarter of the data lies between 31 and 40, but the interval from 31 to 52 contains two quarters, not one. B: Three quarters of the data lie below Q3, but the question asks only about the part above Q1, which is the middle 50%. D: The difference 52 − 31 = 21 is a length in minutes, not a count of deliveries.
---

## Seed N-1.9-A (new) — Topic 1.9 Comparisons of the Distributions for One Quantitative Variable
**Skill:** choose resistant or non-resistant summaries to compare two distributions given skew and outliers.

Commute times (minutes) are recorded for two routes. Route A: mean 31, median 27, standard deviation 14, IQR 10, skewed right with two very long trips. Route B: mean 29, median 29, standard deviation 6, IQR 8, roughly symmetric with no outliers. Which comparison is most appropriate?

- A. Route B has the shorter typical commute, because its mean of 29 is smaller than the mean of 31.
- B. The middle half of Route A's commutes is more than twice as spread out as Route B's, because 14 is more than twice 6.
- C. The two routes cannot be compared, because only one of the distributions is skewed.
- **D. Typical commutes are slightly shorter on Route A (median 27 compared with 29), its higher mean comes from a few very long trips, and its middle half is only a little more spread out.**

Check: Medians 27 and 29 show A is typically shorter; mean 31 above median 27 signals right skew; IQRs 10 and 8 compare the middle halves, while SD 14 reflects the outliers.
Rationales: A: For a right-skewed distribution with outliers the mean is pulled upward, so the medians are the better measure of typical commute. B: The standard deviation is inflated by the long trips; the IQRs, 10 and 8, show the middle halves are similar in spread. C: Distributions with different shapes can still be compared on center, spread and unusual values using resistant measures.

**N-1.9-A-v1.** Scores on a final exam are recorded for two classes. Class 1: mean 74, median 80, standard deviation 15, IQR 12, skewed left with three very low scores. Class 2: mean 77, median 77, standard deviation 8, IQR 11, roughly symmetric. Which comparison is most appropriate?

- **A. The typical score is higher in Class 1 (median 80 compared with 77), its mean is pulled down by a few very low scores, and the middle halves have similar spread.**
- B. Class 2 has the higher typical score, because its mean of 77 is greater than 74.
- C. The middle half of Class 1 is nearly twice as wide as that of Class 2, because 15 is nearly twice 8.
- D. Most students in Class 1 scored below most students in Class 2, because the Class 1 mean is lower.

Check: Median 80 > 77 gives Class 1 the higher typical value; mean below median signals left skew; IQR 12 versus 11 compares the middle halves.
Rationales: B: In a left-skewed distribution the mean is pulled below the typical value, so the medians give the fairer comparison of typical score. C: The standard deviation is inflated by the very low scores; the IQRs, 12 and 11, show the middle halves are similar. D: A lower mean caused by a few extreme scores does not mean most students scored lower; the Class 1 median is actually higher.

**N-1.9-A-v2.** Two machines fill bottles, and the fill volumes (mL) are roughly symmetric with no outliers for each. Machine X: mean 500.2, median 500.1, standard deviation 0.8, IQR 1.1. Machine Y: mean 500.3, median 500.3, standard deviation 2.4, IQR 3.2. Which comparison is best supported?

- A. The machines are essentially the same, because their means differ by only 0.1 mL.
- **B. The centers are nearly the same, but Machine Y's fill volumes are about three times as variable as Machine X's.**
- C. Machine Y fills each bottle about 2.4 mL more than Machine X.
- D. Machine X is the more variable machine, because its mean is the smaller of the two.

Check: Ratios: 2.4/0.8 = 3.0 and 3.2/1.1 ≈ 2.9, while the means 500.2 and 500.3 are almost equal.
Rationales: A: Similar centers say nothing about spread; the standard deviations and IQRs differ by a factor of about three. C: A standard deviation measures typical distance from the mean within one machine, not a shift between machines. D: The size of the mean says nothing about spread; both SD and IQR are much smaller for Machine X, so it is less variable.

**N-1.9-A-v3.** Wait times (minutes) for two bus routes are summarized. Route 1: minimum 2, Q1 5, median 7, Q3 10, maximum 30, where 30 is the only flagged outlier. Route 2: minimum 1, Q1 4, median 8, Q3 14, maximum 16, with no outliers. Which statement about variability is best supported?

- A. Route 1 is more variable, because its range of 28 is larger than the range of 15 for Route 2.
- **B. Typical waits are more variable on Route 2, because its IQR is 10 compared with 5, while Route 1's larger range of 28 comes from a single outlier.**
- C. Route 1 has longer typical waits, because its maximum of 30 is larger than 16.
- D. The routes have the same variability, because their medians differ by only 1 minute.

Check: IQR1 = 10 − 5 = 5, IQR2 = 14 − 4 = 10; range1 = 30 − 2 = 28 and range2 = 16 − 1 = 15.
Rationales: A: The range depends only on the two extreme values and is inflated by one outlier; the IQRs describe the bulk of the data. C: Typical wait is measured by a center such as the median; the medians are 7 and 8, so Route 1 is not typically longer. D: Medians describe center, not spread; the IQRs of 5 and 10 differ by a factor of two.
---

## Seed N-1.9-B (new) — Topic 1.9 Comparisons of the Distributions for One Quantitative Variable
**Skill:** compare two distributions from five-number summaries without confusing box size, extremes and sample size.

Final scores for two classes are summarized by five-number summaries. Class P: 40, 58, 66, 78, 96. Class Q: 62, 72, 80, 86, 94. Which statement is supported?

- A. Every student in Class Q scored higher than every student in Class P.
- B. Class P's typical score is higher, because Class P's maximum of 96 is above Class Q's maximum of 94.
- **C. Class Q's median of 80 is above Class P's third quartile of 78, so more than half of Class Q's scores are higher than about 75% of Class P's scores.**
- D. Class P has more students, because its boxplot is wider.

Check: P's third quartile is 78 and Q's median is 80 > 78; the overlap (62 below 66, 94 and 96 near the top) rules out a complete separation.
Rationales: A: The distributions overlap; for example Class Q's minimum of 62 is below Class P's median of 66. B: Typical score is described by the median, not the maximum, and Class Q's median is 80 compared with 66. D: The width or length of a boxplot reflects spread of values, not the number of observations.

**N-1.9-B-v1.** Reaction times (milliseconds, lower is faster) for two groups are summarized by five-number summaries. Group P: 210, 240, 260, 290, 340. Group Q: 190, 215, 232, 250, 280. Which statement is supported?

- **A. At least 75% of Group Q's times are below Group P's median of 260 milliseconds.**
- B. Every time in Group Q is faster than every time in Group P.
- C. Group P is typically faster, because its box is longer.
- D. Group Q has the larger spread in times, because its maximum of 280 is the smaller maximum.

Check: Group Q's third quartile is 250 < 260, the median of P, so at least 75% of Q is below it.
Rationales: B: Group Q's slowest time of 280 is slower than Group P's fastest time of 210, so the distributions overlap. C: A longer box means greater spread, not faster times; the median of 260 is slower than Group Q's median of 232. D: A smaller maximum does not imply a larger spread; the IQR is 35 for Group Q compared with 50 for Group P.

**N-1.9-B-v2.** Heights (cm) of plants in two groups are summarized by five-number summaries. Group 1: 12, 18, 22, 26, 38. Group 2: 14, 21, 25, 27, 30. Which statement is supported?

- A. Group 1 has the higher median, because its maximum of 38 is larger.
- B. The groups have the same center, because the boxes overlap.
- C. Group 2 is more variable, because its Q1 of 21 is higher than the Q1 of 18.
- **D. Group 2 has the higher median and less variability, with both a smaller IQR and a smaller range.**

Check: IQR1 = 26 − 18 = 8, IQR2 = 27 − 21 = 6; range1 = 26, range2 = 16; medians 22 and 25.
Rationales: A: The median is the middle value; the median of Group 1 is 22 and that of Group 2 is 25, so a large maximum does not raise it. B: Overlapping boxes do not make the medians equal; the medians are 22 and 25. C: A higher quartile is a shift in location, not more spread; the IQRs are 8 for Group 1 and 6 for Group 2.

**N-1.9-B-v3.** Daily step counts (thousands) are recorded for two people. Person A: minimum 3, Q1 6, median 8, Q3 11, maximum 14, no outliers. Person B: the same Q1, median and Q3, but two days at 25 and 27 are plotted as outliers, and the whisker ends at 14. Which statement is correct?

- A. Person B's mean must equal Person A's mean, because the boxes are identical.
- **B. The centers and middle-half spreads are the same, but Person B has two unusually high days that Person A does not, and these raise B's mean.**
- C. Person B has a larger IQR, because B's range is larger.
- D. Person B's median is higher, because of the two high days.

Check: Both IQRs are 11 − 6 = 5 and both medians are 8; the outliers affect only the mean and the range.
Rationales: A: The mean uses every value, so two extremely high days raise B's mean even though the quartiles are the same. C: The IQR depends on Q1 and Q3 only, and these are identical, so the IQRs are equal. D: The median is resistant to extreme values, and both medians are 8.
---

## Seed N-1.10-A (new) — Topic 1.10 The Investigative Question Revisited and Data Collection
**Skill:** distinguish parameters from statistics and explain why statistics vary from sample to sample.

A county health office wants to know what proportion of the 8,400 households in the county have a working smoke detector. Inspectors visit a random sample of 350 households and find working detectors in 301 of them. Which choice correctly identifies the parameter and the statistic?

- A. Parameter: 301/350 = 0.86. Statistic: the proportion of all 8,400 households with a working detector.
- **B. Parameter: the proportion of all 8,400 households with a working detector. Statistic: 301/350 = 0.86 from the sample.**
- C. Parameter: the 350 households inspected. Statistic: the 301 households with working detectors.
- D. Parameter: the proportion of all 8,400 households with a working detector. Statistic: the count 301.

Check: The population is all 8,400 households, the parameter is its true proportion, and the statistic is the sample proportion 301/350 = 0.86.
Rationales: A: The roles are reversed; a parameter describes the whole population and a statistic describes the sample. C: Neither is a numerical summary of the right kind; the parameter is a proportion for all households, not the sample itself. D: The statistic should be the sample proportion 301/350, since the parameter is a proportion and the count 301 depends on the sample size.

**N-1.10-A-v1.** A call center wants to know the mean wait time of all 2,000 calls it received last month. A random sample of 60 of these calls has a mean wait of 7.4 minutes. Which choice correctly identifies the parameter and the statistic?

- A. Parameter: the sample mean of 7.4 minutes. Statistic: the mean wait time of all 2,000 calls.
- B. Parameter: the 2,000 calls. Statistic: the 60 calls.
- C. Parameter: the sample size of 60. Statistic: the mean of 7.4 minutes.
- **D. Parameter: the mean wait time of all 2,000 calls. Statistic: the sample mean of 7.4 minutes.**

Check: The parameter is the population mean for all 2,000 calls, and the statistic is the mean of the 60 sampled calls, 7.4 minutes.
Rationales: A: The roles are reversed; the parameter describes the population and the statistic describes the sample. B: Groups of calls are the population and sample; the parameter and statistic are numerical values computed from them. C: The sample size is not the parameter; the parameter is the unknown mean wait time for all 2,000 calls.

**N-1.10-A-v2.** A company has 5,000 employees. In a random sample of 100 employees, 42 commute by car. Which of the following describes a parameter?

- **A. The proportion of all 5,000 employees who commute by car.**
- B. The proportion 0.42 of the sampled employees who commute by car.
- C. The number of employees in the sample, which is 100.
- D. The difference between the sample proportion and the proportion of all employees.

Check: A parameter is a fixed numerical summary of the whole population, here the proportion of all 5,000 employees who commute by car.
Rationales: B: This value is computed from the sample, so it is a statistic. C: A sample size describes the data collection, not a characteristic of the population. D: This is the sampling error, which varies from sample to sample and cannot be computed because the population value is unknown.

**N-1.10-A-v3.** Two different random samples of 50 students are taken from the same school and each is asked whether they own a laptop. In the first sample 30% own one and in the second sample 38% own one. Which statement best explains the difference?

- A. One of the two samples must be biased, because random samples from one population give the same proportion.
- B. The population proportion changed between the two samples.
- **C. Sample proportions vary from sample to sample, while the population proportion is a single fixed value.**
- D. The sample with 38% is closer to the true proportion, because it is the larger value.

Check: A statistic changes with the sample drawn; a parameter does not, and this natural variation does not by itself indicate bias.
Rationales: A: Random samples from the same population typically give different statistics because of sampling variability, not necessarily bias. B: The population proportion is fixed at the time of sampling; it is the statistics that change. D: Size alone does not show which sample is closer; the true proportion is unknown.
---

## Seed N-1.10-B (new) — Topic 1.10 The Investigative Question Revisited and Data Collection
**Skill:** judge whether a data-collection plan matches the population, groups and variable named in the question.

A principal wants to know the typical number of hours per night that all 1,800 students at her school sleep. She surveys the 28 students in her first-period AP Calculus class. Which statement best describes how well this plan matches her question?

- A. The plan matches the question, because any sample of students estimates the whole school.
- B. The plan matches the question, as long as the 28 students answer honestly.
- **C. The question is about all 1,800 students, but the data come from only one class, so the results cannot be used to describe all students.**
- D. The plan does not match the question only because 28 is fewer than 30 students.

Check: The population in the question is all 1,800 students; a single advanced class is a different, narrower group, so the data answer a different question.
Rationales: A: Only a sample selected in a way that represents the population can be used to estimate it; one class is not chosen that way. B: Honest answers do not fix a sample that does not represent the population in the question. D: The problem is who is included, not a threshold on the sample size.

**N-1.10-B-v1.** A coach wants to know whether students who play a sport sleep more on school nights than students who do not play a sport. She records sleep hours for 60 randomly chosen athletes only. Which statement best describes how well this plan matches her question?

- **A. The question compares two groups, so the plan fails to collect data from students who do not play a sport.**
- B. The plan is sufficient, because she can compare the athletes' mean sleep with the recommended 8 hours.
- C. The plan would be sufficient with a larger sample of athletes.
- D. The plan is sufficient, because random selection makes the athletes' data representative of all students.

Check: A comparison question needs data on both groups; the plan measures only one of them.
Rationales: B: An outside benchmark does not answer the question about athletes compared with non-athletes. C: More athletes still give no information about non-athletes, so it cannot answer a comparison. D: Random selection of athletes represents athletes only, not students who do not play a sport.

**N-1.10-B-v2.** A city wants to estimate the average amount of water that a household uses in a day. It records the total dollar amount on the most recent water bill for each household in a random sample of 200 households. Which statement best describes how well this plan matches the question?

- A. The plan matches the question, because the bill is proportional to the water used for every household.
- B. The plan matches the question, because 200 households is a large enough sample.
- C. The plan does not match the question, because a random sample cannot be used for a mean.
- **D. The variable recorded, a dollar amount, is not the variable in the question, since rate schedules and fees differ among households.**

Check: The question concerns volume of water used, but bills measure money, so the data do not answer the question as asked.
Rationales: A: Bills include fixed fees and different rates, so the amount owed is not simply proportional to the volume used. B: The sample size does not matter if the wrong variable is measured. C: Random samples are suitable for estimating means; the issue is the variable, not the method of selection.

**N-1.10-B-v3.** A park manager wants to know the typical number of visitors on a day throughout the year. She counts the visitors on every Saturday in July. Which statement best describes how well this plan matches her question?

- A. The plan matches the question, because every Saturday in July was counted, so there is no sampling error.
- **B. The question covers every day of the year, but the data come only from summer Saturdays, which are likely not typical of other days.**
- C. The plan matches the question, because the number of visitors is a quantitative variable.
- D. The plan does not match the question, because a typical value cannot be found from counts.

Check: The population is all days of the year; one weekday type in one month covers a small, unrepresentative part of it.
Rationales: A: Counting all July Saturdays gives no information about days outside that time, which is the problem of the match. C: The type of variable is correct, but the days observed are not representative of the whole year. D: Typical values such as a mean or median can be found from counts; the issue is which days were observed.
---

## Seed N-1.11-A (new) — Topic 1.11 Random Sampling
**Skill:** recognize why equal individual chances do not make a sample a simple random sample.

A school has 600 students in 24 homerooms of 25 students each. The principal randomly selects 2 homerooms and surveys all 50 students in them. Every student has the same chance, 1/12, of being selected. Is this sample a simple random sample of 50 students?

- **A. No, because only groups made of two complete homerooms are possible, so not every group of 50 students has a chance of being chosen.**
- B. Yes, because every student has the same chance of being selected.
- C. No, because the homerooms were not chosen using chance.
- D. Yes, because the sample was drawn without bias in the selection of homerooms.

Check: 2 of 24 homerooms gives each student probability 2/24 = 1/12, but only C(24,2) = 276 of the possible groups of 50 students can occur.
Rationales: B: An SRS requires every group of the given size to be equally likely, not just every individual. C: The homerooms were chosen randomly; the sample is a cluster sample, not a non-random one. D: Equal individual chances do not make a sample an SRS; many groups of 50, such as ones with students from 10 different homerooms, cannot occur.

**N-1.11-A-v1.** A list of 400 students is in alphabetical order. A researcher chooses a random starting number from 1 to 10 and then selects every 10th student after that, giving a sample of 40. Every student has a 1/10 chance of being selected. Is this a simple random sample of 40 students?

- A. Yes, because every student has the same chance of being selected.
- B. Yes, because the starting point was chosen at random.
- C. No, because an alphabetical list makes the sample biased toward certain letters.
- **D. No, because two students who are next to each other in the list can never both be chosen, so not every group of 40 is possible.**

Check: Only 10 different samples are possible (one per starting number), while an SRS of 40 from 400 allows all C(400,40) groups.
Rationales: A: Equal individual chances are not enough for an SRS; every possible group of 40 must be equally likely. B: Using a random start gives equal chances but still allows only 10 possible samples, instead of all groups of 40. C: The order of the list matters only if it is related to the response; the reason this is not an SRS is that most groups of 40 are impossible.

**N-1.11-A-v2.** A school has 1,000 students, with 250 in each of four grades. A researcher takes a simple random sample of 15 students from each grade, for a total of 60. Every student has the same chance, 15/250, of being selected. Is the combined sample a simple random sample of 60 students from the school?

- A. Yes, because every student has the same chance of being selected.
- B. Yes, because each grade was sampled using a simple random sample.
- **C. No, because the number of students from each grade is fixed at 15, so groups with, for example, 30 freshmen are impossible.**
- D. No, because stratified sampling is not a random method.

Check: Stratification fixes 15 per grade, so only some of the possible groups of 60 can occur; an SRS allows all of them.
Rationales: A: Equal individual chances are not enough for an SRS; every possible group of 60 must be equally likely. B: Using an SRS within each grade makes this a stratified random sample, which is different from an SRS of the whole school. D: A stratified sample uses chance within strata; it is random, just not an SRS.

**N-1.11-A-v3.** A teacher has 8 students and chooses a simple random sample of 2 students to present. What is the probability that Ana and Ben are both chosen?

- A. 1/4
- **B. 1/28**
- C. 1/56
- D. 1/16

Check: There are C(8,2) = 28 equally likely pairs and the pair (Ana, Ben) is exactly one of them, so the probability is 1/28.
Rationales: A: This is the chance that one given student is chosen, 2/8, and not the chance that two given students are both chosen. C: This counts ordered pairs, 8 × 7 = 56, but the order of selection does not matter, so each pair has probability 1/28. D: This treats the two selections as independent with replacement, (1/4) × (1/4), but a sample without replacement has no repeats.
---

## Seed N-1.11-B (new) — Topic 1.11 Random Sampling
**Skill:** carry out simple random selection with a table of random digits, handling invalid labels and repeats.

A manager numbers 80 employees 01 to 80 and uses a table of random digits to select an SRS of 5. Reading two digits at a time from the left in the string 71298403715512904728, skipping invalid labels and repeats, which sample is selected?

- **A. 71, 29, 03, 55, 12**
- B. 71, 29, 03, 71, 55
- C. 71, 29, 04, 03, 55
- D. 7, 1, 2, 9, 8

Check: Pairs: 71, 29, 84 (invalid), 03, 71 (repeat), 55, 12; the first five valid, distinct labels are 71, 29, 03, 55, 12.
Rationales: B: This allows 71 to be chosen twice, but an SRS selects each individual at most once, so a repeat is skipped. C: The pair 84 was changed to 04 by subtracting 80, but invalid labels should be skipped rather than converted. D: These are single digits, but labels have two digits, so the digits must be read in pairs.

**N-1.11-B-v1.** A club numbers its 250 members 001 to 250 and uses a table of random digits to select an SRS of 4. Reading three digits at a time from the left in the string 812436091847225017199346, skipping invalid labels and repeats, which sample is selected?

- A. 062, 186, 091, 097
- **B. 091, 225, 017, 199**
- C. 091, 225, 017, 346
- D. 81, 24, 36, 09

Check: Triples: 812, 436 (invalid), 091, 847 (invalid), 225, 017, 199; the first four valid labels are 091, 225, 017, 199.
Rationales: A: These come from subtracting 250 from 812, 436 and 847, but invalid labels should be skipped, not converted. C: The group 346 is not a valid label because it is above 250, and the sample should include 199 before it. D: These come from reading two digits at a time, but the labels have three digits.

**N-1.11-B-v2.** A lab labels 50 samples 00 to 49 and uses a table of random digits to select an SRS of 4. Reading two digits at a time from the left in the string 6341872905534816207, skipping invalid labels and repeats, which sample is selected?

- A. 13, 41, 37, 29
- B. 41, 29, 05, 53
- C. 6, 3, 4, 1
- **D. 41, 29, 05, 48**

Check: Pairs: 63 (invalid), 41, 87 (invalid), 29, 05, 53 (invalid), 48; the first four valid labels are 41, 29, 05, 48.
Rationales: A: These come from replacing 63 by 13 and 87 by 37, but invalid labels should be skipped, not reduced to valid ones. B: The pair 53 is not a valid label, because labels end at 49, and the sample should continue to 48. C: These are single digits, but labels have two digits, so digits must be read in pairs.

**N-1.11-B-v3.** A researcher numbers 60 people 01 to 60 and uses two-digit groups from a random digit table to select an SRS. The next two-digit group is 87. What should she do so that every person remains equally likely to be selected?

- A. Use 87 − 60 = 27 so that no digits are wasted.
- B. Select person 60 for any group above 60.
- **C. Skip 87 and read the next two-digit group.**
- D. Stop and restart the table from the beginning.

Check: Discarding invalid groups leaves all valid labels equally likely; converting or reassigning invalid groups does not.
Rationales: A: Then 27 could be chosen by 27 or by 87, so people numbered 01 to 27 would be more likely than others. B: This gives person 60 a much greater chance of being selected than the others. D: Restarting is unnecessary and can repeat earlier results; an invalid label is simply skipped.
---

## Seed N-1.12-A (new) — Topic 1.12 Potential Problems with Sampling
**Skill:** identify the type of sampling bias in a scenario and the likely direction of the error.

A college estimates the mean number of hours its students work at paid jobs each week. It emails a survey to a random sample of 500 students and 90 respond. Students who work long hours often say they were too busy to respond. Which statement best describes the bias and its likely direction?

- **A. Nonresponse bias; the sample mean likely underestimates the true mean.**
- B. Nonresponse bias; the sample mean likely overestimates the true mean.
- C. Undercoverage; the sample mean likely underestimates the true mean.
- D. Voluntary response bias; the sample mean likely overestimates the true mean.

Check: Nonresponse bias arises when selected individuals do not respond; if heavy workers respond less, the average hours among respondents is too low.
Rationales: B: The students who are missing work the most hours, so removing them lowers the mean, not raises it. C: The sample was selected randomly from the students, so there is no group left out of the sampling frame; the issue is that selected students did not respond. D: The students did not volunteer to be in the sample; they were selected and then some did not respond.

**N-1.12-A-v1.** A researcher estimates the mean number of hours per week that all adults in a city stream video. She selects phone numbers at random from a landline directory, which lists only about 38% of households, and these households tend to be older. Which statement best describes the bias and its likely direction?

- A. Undercoverage; the sample mean likely overestimates the true mean.
- B. Nonresponse bias; the sample mean likely underestimates the true mean.
- **C. Undercoverage; the sample mean likely underestimates the true mean.**
- D. Response bias; the sample mean likely overestimates the true mean.

Check: A landline directory excludes younger households that stream more, so the average among those sampled is expected to be too low.
Rationales: A: The omitted households are younger and stream more, so leaving them out lowers the estimate. B: The problem is that the sampling frame leaves out many households before anyone is selected, which is undercoverage. D: Response bias arises from wording or untruthful answers, and nothing in the question suggests this.

**N-1.12-A-v2.** An online store adds an optional pop-up poll to its website asking visitors, "Do you enjoy shopping online?" The store reports the percent of respondents who answer yes as an estimate for all adults. Which statement best describes the bias and its likely direction?

- A. Voluntary response bias; the sample proportion likely underestimates the proportion of all adults.
- **B. Voluntary response bias; the sample proportion likely overestimates the proportion of all adults.**
- C. Response bias; the sample proportion likely overestimates the proportion of all adults.
- D. Nonresponse bias; the sample proportion likely underestimates the proportion of all adults.

Check: Visitors to an online store who choose to take the poll are likely to enjoy online shopping, so the sample percent is expected to be too high.
Rationales: A: People who visit an online store and choose to answer are more likely to enjoy online shopping, so the estimate is too high. C: Response bias comes from the wording of a question or untruthful answers, and the question here is neutral. D: No random sample was selected, so there is no group of selected people who failed to respond; the respondents chose themselves.

**N-1.12-A-v3.** A school randomly selects 120 students from the full roster and a teacher reads each of them the question, "Have you ever copied a classmate's homework?" in front of other teachers, and everyone answers. The school reports the percent who answer yes as an estimate for all students. Which statement best describes the bias and its likely direction?

- A. Response bias; the sample proportion likely overestimates the true proportion.
- B. Undercoverage; the sample proportion likely underestimates the true proportion.
- C. Nonresponse bias; the sample proportion likely underestimates the true proportion.
- **D. Response bias; the sample proportion likely underestimates the true proportion.**

Check: Social pressure from the setting leads to untruthful answers, which is response bias, and denials make the proportion of yes answers too low.
Rationales: A: Students are likely to deny the behavior in front of teachers, so fewer yes answers are given and the estimate is too low. B: Students were selected from the full roster, so no group is left out of the sampling frame. C: Everyone selected answered, so the issue is the honesty of the answers, not missing responses.
---

## Seed N-1.12-B (new) — Topic 1.12 Potential Problems with Sampling
**Skill:** choose a change that reduces bias and know that larger samples do not remove bias.

A radio station asks listeners to call in during one evening show to vote on whether the city should build a stadium. It receives 1,200 calls, and 71% favor the stadium. The station wants a more trustworthy estimate of the opinion of all city residents. Which plan would best reduce the bias?

- A. Keep the call-in format but let people call for a full week, so that many more calls are received.
- **B. Select 300 residents at random from the city's voter registry and follow up with those who do not respond.**
- C. Keep the call-in format but have the host read the question in a more neutral way.
- D. Randomly choose 300 of the 1,200 callers and use only their opinions.

Check: Random selection from a list covering the population, plus follow-up of nonrespondents, removes self-selection; more volunteers or neutral wording does not.
Rationales: A: A larger voluntary sample has the same bias, because the people who call are still those who chose to. C: Neutral wording helps with response bias but does not fix the bias from self-selection. D: A random sample of volunteers is still a sample of volunteers, so the self-selection bias remains.

**N-1.12-B-v1.** A county mails a survey about library hours to a random sample of 1,000 residents, and 150 return it. County staff worry about nonresponse bias. Which plan would best reduce the bias?

- **A. Follow up with a second mailing and phone calls to the residents who did not return the survey.**
- B. Mail the survey to a random sample of 3,000 residents instead of 1,000.
- C. Replace the nonresponders with volunteers who visit the library and agree to fill out a survey.
- D. Check that the survey question is worded neutrally.

Check: Nonresponse bias is reduced by following up with the people selected, not by getting more people who are easy to reach.
Rationales: B: A larger sample with the same low response rate has the same nonresponse bias; it only has more returned surveys. C: Volunteers at the library are different from nonresponders and introduce voluntary response bias. D: Neutral wording helps with response bias but does not fix the fact that 85% of selected residents did not respond.

**N-1.12-B-v2.** A student wants to estimate how many hours per week all residents of her town exercise. She surveys 100 people who are leaving a gym on weekday evenings. Which plan would best reduce the bias?

- A. Survey 500 people leaving the gym instead of 100.
- B. Survey people leaving the gym at several different times of day, including mornings.
- **C. Select 100 residents at random from the town's list of households and survey each of them.**
- D. Ask the exercise question in a more neutral way.

Check: A random sample from a list covering all residents gives every resident a chance to be chosen; a larger convenience sample does not.
Rationales: A: A larger sample from the same gym entrance still excludes people who do not go to the gym, so the bias remains. B: This varies the time but still samples only gym members, who tend to exercise more than other residents. D: Wording is not the main problem; the people who were chosen are not representative of the town.

**N-1.12-B-v3.** A poll of 200 customers selected by convenience at one store overestimates the proportion of all shoppers who prefer a brand. Researchers repeat the same procedure with 2,000 customers selected the same way. Which statement is expected to be true for the new estimate?

- A. The bias will shrink toward zero, because the sample is larger.
- B. The estimate will be unbiased, because a large sample always represents the population.
- C. The bias will increase, because convenience samples get worse as the sample grows.
- **D. The estimates will vary less from sample to sample, but they will still be centered away from the true proportion.**

Check: Larger n reduces sampling variability around the center of the procedure's estimates, but the center itself, which is off target, is unchanged.
Rationales: A: Increasing the sample size reduces variability but does not remove bias that comes from how people are selected. B: A large sample drawn with a flawed method still systematically misses parts of the population. C: The bias stays about the same; it does not get larger or smaller with the sample size.
---

## Seed N-1.13-A (new) — Topic 1.13 Experimental Design
**Skill:** find the confounding flaw in an experiment design and choose the best fix.

A coach tests whether a new warm-up reduces 100-meter sprint times. On one day, each of 12 sprinters runs once in the morning after the new warm-up and once in the afternoon after the standard warm-up. The mean time is 0.15 seconds faster in the morning. Which statement identifies the most serious problem and the best fix?

- A. The sample is too small; she should use 120 sprinters but keep the same morning and afternoon plan.
- B. There is no control group; she should give sprinters a fake warm-up that does nothing.
- **C. Warm-up is confounded with time of day; she should randomly decide for each sprinter whether the new warm-up is used in the morning or the afternoon.**
- D. There is no problem, because using the same sprinters in both conditions removes all differences.

Check: Every sprinter did the new warm-up in the morning and the standard warm-up in the afternoon, so time of day cannot be separated from the effect of the warm-up.
Rationales: A: A larger sample still has the new warm-up always in the morning, so the confounding with time of day remains. B: Using the same sprinters for both warm-ups already provides a comparison; the problem is the fixed order. D: Using the same sprinters controls for differences between people, but not for time of day or fatigue.

**N-1.13-A-v1.** A school compares a new tutoring program with the usual program. All students in first period are placed in the new program and all students in second period get the usual program. At the end, first-period students score higher on a test. Which statement identifies the most serious problem and the best fix?

- **A. Program is confounded with class period; students should be randomly assigned to the programs regardless of period.**
- B. There is no control group; the usual program should be replaced by no tutoring.
- C. The students and teachers should be unaware of which program is the new one.
- D. More students should be added to each period.

Check: The two groups differ in more than the program, such as class period and teacher, so the observed difference cannot be attributed to the program.
Rationales: B: The students in the usual program already act as a comparison group; the problem is how students were put into groups. C: Blinding helps against bias in responses and evaluation, but the groups still differ systematically by class period. D: A larger number of students in each fixed group does not remove differences between the periods.

**N-1.13-A-v2.** Researchers compare a new diet with the current diet. Sixty volunteers choose which diet to follow for 12 weeks, and the new-diet group loses more weight on average. Which statement identifies the most serious problem and the best fix?

- A. The study should use a larger group of volunteers who each choose a diet.
- B. Participants should be asked to report their weight honestly.
- C. Every participant should follow the new diet first and the current diet second.
- **D. Diet is confounded with participants' motivation; volunteers should be randomly assigned to the diets.**

Check: When people choose their own treatment, those who choose differ in other ways such as motivation, so the groups are not comparable.
Rationales: A: More volunteers choosing their own diets still allow motivation to differ between the groups. B: Honest reporting does not remove the systematic difference between those who chose each diet. C: A fixed order confounds the diet with time, so this introduces another confounding variable.

**N-1.13-A-v3.** A gym puts all 40 of its members on a new training program for 8 weeks. Their mean strength gain is 12 pounds, and the manager concludes that the program caused the gain. Which statement identifies the most serious problem and the best fix?

- A. There is no problem, because the same members were measured before and after the program.
- **B. There is no comparison group; some members should be randomly assigned to the new program and others to a comparison treatment at the same time.**
- C. The program should be extended to 16 weeks.
- D. Only members who volunteer for the program should be used.

Check: Without a concurrently treated comparison group chosen at random, the gain cannot be attributed to the program.
Rationales: A: Before and after measurements cannot separate the program from other changes such as natural progress or the season. C: A longer program still has no comparison group and a longer period also allows more other changes. D: Using only volunteers adds selection issues and still provides no comparison group.
---

## Seed N-1.13-B (new) — Topic 1.13 Experimental Design
**Skill:** determine the scope of conclusions (cause, generalization) from random assignment and random selection.

Researchers recruit 80 volunteer adult cyclists from one city and use a random number generator to assign 40 to a new electrolyte drink and 40 to a placebo drink. Time to exhaustion is significantly longer for the electrolyte group. Which conclusion is justified?

- **A. The drink caused the longer times for volunteer cyclists like these, but the result cannot be generalized to all adult cyclists.**
- B. The drink caused longer times, and the result can be generalized to all adult cyclists.
- C. There is only an association, because volunteers rather than a random sample were used.
- D. Nothing can be concluded, because the cyclists were not a random sample.

Check: Random assignment allows a causal conclusion within the study group; volunteers limit the scope of inference to similar cyclists.
Rationales: B: Generalizing requires random selection from the population, and these cyclists were volunteers. C: Random assignment supports a cause-and-effect conclusion for these participants, no matter how they were recruited. D: The lack of a random sample limits generalization but does not remove the cause-and-effect conclusion from random assignment.

**N-1.13-B-v1.** Researchers select a simple random sample of 600 adults from a county and record each person's daily coffee intake and whether the person has been diagnosed with high blood pressure. Those who drink more coffee are more likely to have high blood pressure. Which conclusion is justified?

- A. Coffee causes high blood pressure, and this can be generalized to all adults in the county.
- B. Coffee causes high blood pressure among the 600 adults, but the result cannot be generalized.
- **C. The association can be generalized to all adults in the county, but it cannot be concluded that coffee causes high blood pressure.**
- D. The association applies only to the 600 adults, because only they were studied.

Check: A random sample supports generalization to the county; no random assignment means association only.
Rationales: A: The study is observational, so confounding variables could explain the association, and no cause can be concluded. B: There was no random assignment, so a cause-and-effect conclusion is not justified, even for the sample. D: The random selection of adults supports generalizing the association to the county population.

**N-1.13-B-v2.** A researcher selects a simple random sample of 120 students from a school of 2,000, then uses a random number generator to assign 60 to a new study app and 60 to the usual materials. Test scores are significantly higher for the app group. Which conclusion is justified?

- A. The app caused the higher scores, but the result cannot be generalized to all students at the school.
- B. The result can be generalized to the school, but there is only an association with the app.
- C. There is only an association between the app and scores, and it applies only to the 120 students.
- **D. The app caused the higher scores, and the result can be generalized to all students at the school.**

Check: Random selection supports generalizing to the school and random assignment supports a causal conclusion.
Rationales: A: The random selection of the students from the school supports generalizing to that school. B: Random assignment to the app supports a cause-and-effect conclusion. C: Both random selection and random assignment were used, so both generalization and causation are supported.

**N-1.13-B-v3.** Eighty volunteers from a community center choose whether to join a walking group or not join it. After 10 weeks, the walking group has lower mean blood pressure. Which conclusion is justified?

- A. Walking caused the lower blood pressure, and the result can be generalized to all adults.
- **B. There is an association among these volunteers, but the walking cannot be concluded to cause the lower blood pressure and the result cannot be generalized to all adults.**
- C. Walking caused the lower blood pressure among these volunteers, because the groups were compared over 10 weeks.
- D. The association can be generalized to all adults, because 80 people is a large enough sample.

Check: No random assignment (self-chosen groups) and no random sampling (volunteers) means neither a causal conclusion nor generalization.
Rationales: A: The participants chose their group and were volunteers, so neither causation nor generalization is supported. C: Comparison over time is not random assignment; the people who chose to walk may differ in other ways. D: The sample size does not matter without random selection, and these volunteers were not randomly selected.
