import json
def C(text, evidence, fix, v=None):
    return {"text": text, "evidence": evidence, "fix": fix, "accepted_variants": v or []}
def P(prompt, *crit):
    return {"prompt": prompt, "criteria": list(crit)}
SK = "ap_statistics"
items = []
def add(code, item):
    items.append({"subject_key": SK, "topic_code": code, "item": item})

TBETA = """
from mpmath import mp, mpf, betainc, findroot
mp.dps = 25
def _cdf(t, df):
    x = df / (df + t * t)
    p = betainc(df / 2, mpf(1) / 2, 0, x, regularized=True) / 2
    return 1 - p if t > 0 else p
def tstar(conf, df):
    q = 1 - (1 - mpf(conf)) / 2
    return float(findroot(lambda t: _cdf(t, df) - q, 2))
def welch(s1, n1, s2, n2):
    a = s1 * s1 / n1
    b = s2 * s2 / n2
    return (a + b) ** 2 / (a * a / (n1 - 1) + b * b / (n2 - 1))
"""

# ---------------- 4.2 A ----------------
add("4.2", {
 "title": "Confidence Interval for the Mean Length of Rainbow Trout",
 "calculator": "permitted",
 "stimulus": """A fisheries biologist wants to estimate the mean length of rainbow trout in a large lake that holds many thousands of trout. She catches and measures a random sample of 22 trout. The sample mean length is 31.4 cm and the sample standard deviation is 4.2 cm. A dotplot of the 22 lengths is roughly symmetric, with no outliers.

For 95% confidence with 21 degrees of freedom, the critical value is t* = 2.080.""",
 "parts": [
  P("Check the conditions for constructing a t interval for the population mean length.",
    C("States that the trout were randomly selected, which meets the random condition.",
      "Response states that the sample is a random sample of the trout in the lake.",
      "Name the sampling method given in the problem and say that it meets the random sampling condition."),
    C("States that the 10% condition is met because the lake holds more than 10 × 22 = 220 trout.",
      "Response compares the population size to 10 times the sample size, 220, and concludes the 10% condition is satisfied.",
      "Compare the population size to 10 times the sample size; if the population is larger, the 10% condition is met."),
    C("States that although n = 22 is less than 30, the sample is roughly symmetric with no outliers, so the sample data condition is met.",
      "Response notes n is below 30 and uses the symmetric shape and absence of outliers to justify using t procedures.",
      "When n is under 30, describe the sample's shape: no strong skewness and no outliers supports using a t interval.")),
  P("Construct a 95% confidence interval for the mean length of all rainbow trout in the lake.",
    C("Sets up the interval as 31.4 ± 2.080(4.2/√22), with the sample mean, t*, s and n correctly substituted (the standard error is about 0.895 cm).",
      "Response shows the t interval expression with 31.4, 2.080, 4.2 and 22 correctly substituted, or an equivalent calculator setup that names the same values.",
      "Write the interval as the sample mean plus or minus t* times s over the square root of n, then substitute each value.", ["SE ≈ 0.895"]),
    C("Gives the interval 31.4 ± 1.86, or (29.54, 33.26) cm.",
      "Response gives lower and upper limits near 29.54 and 33.26 cm.",
      "Add and subtract the margin of error from the sample mean, and write both limits with units.", ["(29.5, 33.3)"])),
  P("Interpret the interval in the context of the study.",
    C("States that we are 95% confident that the interval from 29.54 to 33.26 cm captures the true mean length of all rainbow trout in the lake.",
      "Response gives the confidence level, the interval, the parameter as a population mean, and the context of trout in the lake.",
      "Use the pattern: I am 95% confident the interval from a to b contains the true mean of the population described."))],
 "model_answer": """(a) Random: the 22 trout are a random sample from the lake. 10% condition: the lake holds many thousands of trout, which is more than 10 × 22 = 220, so the 10% condition is met. Sample data: n = 22 is less than 30, but the dotplot is roughly symmetric with no outliers, so it is reasonable to use a t interval.

(b) Standard error = 4.2/√22 ≈ 0.895 cm. Margin of error = 2.080 × 0.895 ≈ 1.86 cm. The interval is 31.4 ± 1.86, or (29.54, 33.26) cm.

(c) I am 95% confident that the interval from 29.54 cm to 33.26 cm captures the true mean length of all rainbow trout in the lake.""",
 "verification_python": TBETA + """
import math
n, xbar, s = 22, 31.4, 4.2
assert abs(tstar(0.95, n - 1) - 2.080) < 0.001
se = s / math.sqrt(n)
assert abs(se - 0.895) < 0.001
me = 2.080 * se
assert abs(me - 1.86) < 0.01
assert abs((xbar - me) - 29.54) < 0.01 and abs((xbar + me) - 33.26) < 0.01
assert 10 * n == 220
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.2 B ----------------
add("4.2", {
 "title": "Confidence Interval for a Mean Change in Quiz Scores",
 "calculator": "permitted",
 "stimulus": """A teacher wants to estimate the mean change in quiz scores when students use a review app. She randomly selects 14 of the 1,150 students at her school. Each student takes a quiz on a topic, studies the topic with the app for a week, and then takes a different quiz of equal difficulty on the same topic. For each student she computes the difference d = (score after) − (score before).

The 14 differences have a mean of 3.9 points and a standard deviation of 5.1 points. Their distribution has no strong skewness and no outliers.

For 90% confidence with 13 degrees of freedom, the critical value is t* = 1.771.""",
 "parts": [
  P("Explain why the teacher should analyze the 14 differences with a one-sample t procedure instead of treating the before scores and the after scores as two independent samples.",
    C("Explains that each student provides both a before score and an after score, so the two sets of scores are paired (not independent), and analyzing the differences accounts for the pairing.",
      "Response states that the data are matched pairs because each student is measured twice, and that the differences are analyzed as one sample.",
      "Check whether the same individuals appear in both sets of data; if so, the data are paired and you analyze the differences.")),
  P("Define the parameter of interest and construct a 90% confidence interval for it.",
    C("Defines μd as the true mean difference (score after − score before) in quiz scores for all students at the school.",
      "Response defines the parameter as a population mean difference, states the order of subtraction, and states the population of students.",
      "Define the parameter as a population mean of the differences, with the direction of subtraction and the population named.", ["μd = mean change in quiz score for all students at her school"]),
    C("Computes the interval 3.9 ± 1.771(5.1/√14), which is approximately (1.49, 6.31) points.",
      "Response shows the t interval formula with correct values and gives limits near 1.49 and 6.31.",
      "Use the mean of the differences, t*, and s divided by the square root of 14; then add and subtract the margin of error.", ["(1.5, 6.3)"])),
  P("Interpret the interval in context, and interpret the confidence level.",
    C("States that we are 90% confident that the interval from 1.49 to 6.31 points captures the true mean change (after − before) in quiz scores for all students at the school.",
      "Response interprets the interval as capturing a population mean difference, in context, with the interval and 90% confidence stated.",
      "Interpret the interval by naming the parameter in context, including the direction of the difference and its units."),
    C("Interprets the confidence level: if the teacher repeated the sampling process many times, about 90% of the intervals constructed this way would capture the true mean difference.",
      "Response describes the long-run proportion of intervals from repeated samples that capture the true parameter, with a value of about 90%.",
      "Describe the method, not one interval: in many repeated samples, about 90% of the intervals made this way capture the parameter."))],
 "model_answer": """(a) Each student takes a quiz before and after using the app, so the before and after scores for a student are paired and are not independent. The teacher should compute each student's difference and use a one-sample t interval on those 14 differences.

(b) Let μd be the true mean difference (score after − score before) in quiz scores for all students at the school. The interval is 3.9 ± 1.771(5.1/√14) = 3.9 ± 2.41, which is approximately (1.49, 6.31) points.

(c) I am 90% confident that the interval from 1.49 to 6.31 points captures the true mean change (after − before) in quiz scores for all students at the school. If she repeated this process many times, about 90% of the intervals constructed this way would capture the true mean difference.""",
 "verification_python": TBETA + """
import math
n, d, s = 14, 3.9, 5.1
assert abs(tstar(0.90, n - 1) - 1.771) < 0.001
se = s / math.sqrt(n)
me = 1.771 * se
assert abs(me - 2.41) < 0.01
assert abs((d - me) - 1.49) < 0.01 and abs((d + me) - 6.31) < 0.01
assert 1150 > 10 * n
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.4 A ----------------
add("4.4", {
 "title": "Setting Up a Test About Mean Ambulance Response Time",
 "calculator": "not_applicable",
 "stimulus": """A city's emergency services department states that the mean response time for ambulance calls is 8.0 minutes. A resident believes the true mean response time is longer. The resident obtains the department's records of about 5,400 calls from the past year and takes a simple random sample of 36 of those calls. The sample mean response time is 8.7 minutes and the sample standard deviation is 2.9 minutes. The distribution of the 36 response times is skewed to the right, with no extreme outliers.""",
 "parts": [
  P("State the null and alternative hypotheses for a test of the resident's belief, defining any parameter you use.",
    C("Defines μ as the true mean response time (in minutes) for all ambulance calls in the city.",
      "Response defines the parameter as a population mean in context, with the population of ambulance calls and units of minutes.",
      "Define the parameter in words: name it as a population mean and say which population it describes, with units."),
    C("States the null hypothesis H0: μ = 8.0 minutes.",
      "Response writes H0 with equality and the claimed value 8.0.",
      "Write H0 as the parameter equal to the value claimed by the department, 8.0 minutes."),
    C("States the alternative hypothesis Ha: μ > 8.0 minutes.",
      "Response writes Ha with the greater-than sign, reflecting the resident's belief that the mean is longer.",
      "Match the direction of Ha to the belief: longer than 8.0 minutes means the parameter is greater than 8.0.")),
  P("Name the inference procedure that is appropriate for these hypotheses.",
    C("Identifies a one-sample t-test for a population mean.",
      "Response names a one-sample t-test (or t-test for a mean), not a z-test and not a two-sample test.",
      "One quantitative variable from one sample with unknown population standard deviation calls for a one-sample t-test for a mean.", ["t-test for a population mean"])),
  P("The calls are a simple random sample. Verify the 10% condition and the sample data condition for using this procedure.",
    C("States that the 10% condition is met because the population of about 5,400 calls is more than 10 times the sample size of 36 (equivalently, 36 is less than 10% of 5,400).",
      "Response compares 5,400 with 10 × 36 = 360, or 36 with 10% of 5,400 = 540, and concludes the condition is met.",
      "Compare the sample size with 10% of the population size, or the population size with 10 times the sample size, and state the conclusion.", ["n < 0.10N", "36 < 540"]),
    C("Verifies the sample data condition: n = 36 is at least 30, so the sampling distribution of the sample mean is approximately normal even though the sample is skewed to the right.",
      "Response states that n ≥ 30 justifies approximate normality of the sampling distribution despite skewness.",
      "Compare n with 30; when n is at least 30, skewness in the sample does not stop you from using t procedures."))],
 "model_answer": """(a) Let μ be the true mean response time, in minutes, for all ambulance calls in the city. H0: μ = 8.0 minutes. Ha: μ > 8.0 minutes.

(b) A one-sample t-test for a population mean is appropriate.

(c) 10%: there are about 5,400 calls, which is more than 10 × 36 = 360 (equivalently, 36 is less than 10% of 5,400), so the condition is met. Sample data: n = 36 is at least 30, so the sampling distribution of the sample mean is approximately normal even though the sample is skewed to the right.""",
 "verification_python": """assert 10 * 36 == 360 and 5400 > 360 and 36 < 0.10 * 5400
assert 36 >= 30
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.4 B ----------------
add("4.4", {
 "title": "Setting Up a Matched-Pairs Test for Caffeine Gum and 5 km Times",
 "calculator": "not_applicable",
 "stimulus": """A sports scientist wants to know whether chewing caffeine gum before a 5 km run reduces the mean running time. She recruits 15 volunteer runners. Each runner completes two 5 km time trials one week apart, once after chewing caffeine gum and once after chewing placebo gum. For each runner, the order of the two conditions is assigned at random.

For each runner she records d = (time after placebo gum) − (time after caffeine gum), in seconds, so a positive d means the runner was faster with caffeine. The 15 values of d have a mean of 14 seconds and a standard deviation of 21 seconds. The distribution of the 15 values of d is roughly symmetric, with no outliers.""",
 "parts": [
  P("Explain why a matched-pairs procedure is appropriate here instead of a two-sample procedure.",
    C("Explains that each runner is measured under both conditions, so the two sets of times are paired (dependent), and the differences d form one sample to analyze.",
      "Response states that the same runners appear in both conditions, so the data are paired and the differences are analyzed as one sample.",
      "Check whether the same individuals are measured under both conditions; if so, use matched pairs on the differences.")),
  P("State the null and alternative hypotheses for the scientist's test, defining any parameter you use.",
    C("Defines μd as the true mean difference (placebo time − caffeine time) in 5 km time, in seconds, for all runners like these volunteers.",
      "Response defines the parameter as a population mean difference, states the order of subtraction, and states the population.",
      "Define the parameter as the population mean of the differences, with the order of subtraction and units."),
    C("States H0: μd = 0 seconds.",
      "Response writes H0 as the mean difference equal to 0.",
      "Write H0 as no mean difference: the parameter equals 0."),
    C("States Ha: μd > 0 seconds.",
      "Response writes Ha as the mean difference greater than 0, consistent with d = placebo − caffeine.",
      "Match Ha to how d is defined: caffeine reducing time means placebo minus caffeine is greater than 0.")),
  P("Verify the conditions for using a matched-pairs t procedure.",
    C("Verifies the random condition: the order of the two conditions was randomly assigned for each runner.",
      "Response states that random assignment of the order of conditions satisfies the randomization condition.",
      "In an experiment, the random condition is satisfied by random assignment; state what was randomized."),
    C("Verifies the sample data condition: n = 15 is less than 30, but the differences are roughly symmetric with no outliers, so the sampling distribution of the mean difference is approximately normal.",
      "Response notes that n is below 30 and uses the symmetric shape of d and the absence of outliers to justify using t procedures.",
      "When the number of differences is under 30, check the differences themselves for strong skewness and outliers."))],
 "model_answer": """(a) Every runner completes the 5 km trial under both conditions, so the times with caffeine and the times with placebo are paired and are not independent. The scientist should analyze the 15 differences d as a single sample.

(b) Let μd be the true mean difference (placebo time − caffeine time), in seconds, in 5 km time for all runners like these volunteers. H0: μd = 0. Ha: μd > 0.

(c) Random: the order of the conditions was randomly assigned for each runner. Sample data: n = 15 is less than 30, but the differences are roughly symmetric with no outliers, so it is reasonable to use a t procedure.""",
 "verification_python": """assert 15 < 30
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.6 A ----------------
add("4.6", {
 "title": "Sampling Distribution of the Difference in Mean Bag Weights",
 "calculator": "permitted",
 "stimulus": """Two machines fill bags of rice. Machine 1 fills bags with a mean weight of μ1 = 502 g and a standard deviation of σ1 = 6 g. Machine 2 fills bags with a mean weight of μ2 = 500 g and a standard deviation of σ2 = 5 g. The shapes of the two distributions of bag weights are not known.

An inspector takes an independent random sample of n1 = 36 bags from Machine 1 and an independent random sample of n2 = 30 bags from Machine 2, and computes the difference in the sample means, x̄1 − x̄2. Each machine fills at least 5,000 bags in a day.""",
 "parts": [
  P("What is the mean of the sampling distribution of x̄1 − x̄2?",
    C("States that the mean of the sampling distribution is μ1 − μ2 = 502 − 500 = 2 g.",
      "Response gives the mean as 2 g, found by subtracting the two population means in the order x̄1 − x̄2.",
      "The mean of the sampling distribution of x̄1 − x̄2 is the difference of the population means, taken in the same order.", ["2", "2 g"])),
  P("Calculate the standard deviation of the sampling distribution of x̄1 − x̄2.",
    C("Calculates the standard deviation as √(6²/36 + 5²/30) ≈ 1.354 g.",
      "Response adds the two variances of the sample means before taking the square root, and gives a value near 1.35 g.",
      "Add σ1²/n1 and σ2²/n2 first, then take the square root; do not subtract or add standard deviations directly.", ["1.35", "1.354 g"])),
  P("Describe the shape of the sampling distribution of x̄1 − x̄2, and justify your answer.",
    C("States that the sampling distribution of x̄1 − x̄2 is approximately normal.",
      "Response states the shape is approximately normal.",
      "State the shape of the sampling distribution of the difference, not of the population distributions."),
    C("Justifies the shape because both sample sizes (36 and 30) are at least 30, so the sampling distribution is approximately normal regardless of the population shapes.",
      "Response cites both n1 = 36 and n2 = 30 being at least 30 (central limit theorem) as the reason.",
      "When population shapes are unknown, check that both sample sizes are at least 30 before claiming a normal shape.")),
  P("Suppose the inspector increases the sample from Machine 2 to 60 bags and keeps 36 bags from Machine 1. Calculate the new standard deviation of the sampling distribution of x̄1 − x̄2, and state whether it is smaller than, larger than, or the same as before.",
    C("Calculates the new standard deviation √(6²/36 + 5²/60) ≈ 1.190 g.",
      "Response gives a value near 1.19 g from the correct formula with n2 = 60.",
      "Replace n2 with 60 in the variance of the second sample mean, add the two variances, then take the square root.", ["1.19", "1.190 g"]),
    C("States that the new standard deviation is smaller than the original 1.354 g.",
      "Response compares the new value with 1.354 g and states that the new value is smaller.",
      "Compare the new value with the earlier one and say which is smaller; a larger sample gives a smaller value.", ["smaller", "decreases"]))],
 "model_answer": """(a) The mean is μ1 − μ2 = 502 − 500 = 2 g.

(b) The standard deviation is √(6²/36 + 5²/30) = √(1 + 0.8333) ≈ 1.354 g.

(c) The sampling distribution of x̄1 − x̄2 is approximately normal. Both sample sizes, 36 and 30, are at least 30, so the central limit theorem applies to each sample mean and the difference is approximately normal even though the shapes of the populations are not known.

(d) The new standard deviation is √(6²/36 + 5²/60) = √(1 + 0.4167) ≈ 1.190 g. This is smaller than 1.354 g, because a larger sample size reduces the variability of the sample mean.""",
 "verification_python": """import math
assert 502 - 500 == 2
sd1 = math.sqrt(6**2 / 36 + 5**2 / 30)
assert abs(sd1 - 1.354) < 0.001
sd2 = math.sqrt(6**2 / 36 + 5**2 / 60)
assert abs(sd2 - 1.190) < 0.001 and sd2 < sd1
assert 36 >= 30 and 30 >= 30
assert 5000 > 10 * 60
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.6 B ----------------
add("4.6", {
 "title": "Sampling Distribution of the Difference in Mean Battery Life",
 "calculator": "permitted",
 "stimulus": """A consumer lab compares two brands of rechargeable flashlight batteries. The battery life of Brand A is normally distributed with a mean of 18.0 hours and a standard deviation of 2.4 hours. The battery life of Brand B is normally distributed with a mean of 16.5 hours and a standard deviation of 3.0 hours.

The lab tests an independent random sample of 9 Brand A batteries and an independent random sample of 12 Brand B batteries, and computes the difference in the sample means, x̄A − x̄B.""",
 "parts": [
  P("Find the mean of the sampling distribution of x̄A − x̄B.",
    C("States that the mean is 18.0 − 16.5 = 1.5 hours.",
      "Response gives the mean as 1.5 hours, found by subtracting the two population means in the order A − B.",
      "Subtract the population means in the same order as the sample means: Brand A minus Brand B.", ["1.5", "1.5 hours"])),
  P("Calculate the standard deviation of the sampling distribution of x̄A − x̄B.",
    C("Calculates the standard deviation as √(2.4²/9 + 3.0²/12) ≈ 1.179 hours.",
      "Response adds the variances 2.4²/9 and 3.0²/12 before taking the square root, giving a value near 1.18 hours.",
      "Add the two variances of the sample means, then take the square root of the sum.", ["1.18", "1.179 hours"])),
  P("Describe the shape of the sampling distribution of x̄A − x̄B, and justify your answer even though both sample sizes are less than 30.",
    C("States that the sampling distribution of x̄A − x̄B is normal.",
      "Response states that the sampling distribution of the difference is normal (or approximately normal).",
      "State the shape of the sampling distribution of the difference between the sample means."),
    C("Justifies the shape because both populations are normally distributed, so each sample mean is normal for any sample size and so is their difference.",
      "Response cites that both populations are normal, so small sample sizes do not matter.",
      "If both populations are normal, the difference in sample means is normal for any sample sizes; cite that fact.")),
  P("A second lab tests the same sample sizes of 9 and 12 batteries but does not know the shape of either population. Can it assume that the sampling distribution of x̄A − x̄B is approximately normal? Explain.",
    C("States that it cannot assume this, because neither sample size is at least 30 and the populations are not known to be normal.",
      "Response answers no and gives both reasons: sample sizes below 30 and no knowledge that the populations are normal.",
      "To assume a normal shape you need normal populations or both sample sizes at least 30; check each before answering."))],
 "model_answer": """(a) The mean is μA − μB = 18.0 − 16.5 = 1.5 hours.

(b) The standard deviation is √(2.4²/9 + 3.0²/12) = √(0.64 + 0.75) = √1.39 ≈ 1.179 hours.

(c) The sampling distribution of x̄A − x̄B is normal. Both populations are normally distributed, so each sample mean is normally distributed for any sample size, and the difference of two independent normal variables is also normal. The small sample sizes (9 and 12) do not matter here.

(d) No. If the shapes of the populations are unknown, neither sample size is at least 30, so the central limit theorem cannot be used, and the populations are not known to be normal. The second lab cannot assume a normal sampling distribution.""",
 "verification_python": """import math
assert abs((18.0 - 16.5) - 1.5) < 1e-9
sd = math.sqrt(2.4**2 / 9 + 3.0**2 / 12)
assert abs(sd - 1.179) < 0.001
assert 9 < 30 and 12 < 30
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.7 A ----------------
add("4.7", {
 "title": "Confidence Interval for the Difference in Mean Sleep Time",
 "calculator": "permitted",
 "stimulus": """A researcher at a large university compares the nightly sleep of students who use a phone in bed and students who do not. About 9,000 students at the university use a phone in bed and about 6,000 do not. She takes an independent random sample of 45 students from the first group and 52 students from the second group, and records each student's mean nightly sleep (in hours) over a week.

Group 1 (phone in bed): n1 = 45, mean 6.8 hours, standard deviation 1.1 hours.
Group 2 (no phone in bed): n2 = 52, mean 7.3 hours, standard deviation 0.9 hours.

Technology gives about 85.1 degrees of freedom. For 95% confidence, the critical value is t* = 1.988.""",
 "parts": [
  P("Check the conditions for constructing a two-sample t interval for μ1 − μ2.",
    C("States that the two samples are independent random samples from the two groups.",
      "Response states that each sample is random and that the two samples are independent of each other.",
      "Say how each sample was chosen and that the groups are independent samples."),
    C("States that the 10% condition is met in each group: 9,000 is more than 10 × 45 = 450 and 6,000 is more than 10 × 52 = 520.",
      "Response compares each group's population size to 10 times its sample size.",
      "Check each group separately: its population size must be at least 10 times its sample size."),
    C("States that both sample sizes (45 and 52) are at least 30, so the sampling distribution of x̄1 − x̄2 is approximately normal.",
      "Response cites both sample sizes being at least 30 as satisfying the sample data condition.",
      "For two samples, check that both n1 and n2 are at least 30 before relying on approximate normality.")),
  P("Construct a 95% confidence interval for μ1 − μ2.",
    C("Calculates the standard error √(1.1²/45 + 0.9²/52) ≈ 0.206 hours.",
      "Response shows a standard error near 0.206 hours computed from both sample variances and both sample sizes.",
      "Add s1²/n1 and s2²/n2, then take the square root of the sum.", ["SE ≈ 0.21"]),
    C("Gives the interval (6.8 − 7.3) ± 1.988(0.206), which is approximately (−0.91, −0.09) hours.",
      "Response uses −0.5 as the point estimate, in the order group 1 minus group 2, and gives limits near −0.91 and −0.09 hours.",
      "Multiply t* by the standard error for the margin of error, then add and subtract it from the point estimate.", ["(−0.91, −0.09)", "(-0.91, -0.09)"])),
  P("Interpret the interval in context.",
    C("States that we are 95% confident that the interval from −0.91 to −0.09 hours captures the true difference in mean nightly sleep (phone in bed minus no phone in bed) for the two groups of students at the university.",
      "Response states the confidence level, the interval, the order of subtraction, and that the parameter is a difference in population mean sleep times.",
      "Interpret with the confidence level, the interval, the order of subtraction, and the two populations named."))],
 "model_answer": """(a) Random and independent: the students in each group were chosen by random sampling, and the two samples are independent of each other. 10%: 9,000 is more than 10 × 45 = 450 and 6,000 is more than 10 × 52 = 520. Sample data: both n1 = 45 and n2 = 52 are at least 30, so the sampling distribution of x̄1 − x̄2 is approximately normal.

(b) Point estimate: 6.8 − 7.3 = −0.5 hours. Standard error: √(1.1²/45 + 0.9²/52) ≈ 0.206. Margin of error: 1.988(0.206) ≈ 0.41. The interval is −0.5 ± 0.41, which is approximately (−0.91, −0.09) hours.

(c) I am 95% confident that the interval from −0.91 to −0.09 hours captures the true difference in mean nightly sleep (students who use a phone in bed minus students who do not) among students at the university.""",
 "verification_python": TBETA + """
import math
n1, m1, s1 = 45, 6.8, 1.1
n2, m2, s2 = 52, 7.3, 0.9
df = welch(s1, n1, s2, n2)
assert abs(df - 85.1) < 0.1
assert abs(tstar(0.95, df) - 1.988) < 0.001
se = math.sqrt(s1**2 / n1 + s2**2 / n2)
assert abs(se - 0.206) < 0.001
diff = m1 - m2
me = 1.988 * se
assert abs(diff + 0.5) < 1e-9
assert abs((diff - me) + 0.91) < 0.01 and abs((diff + me) + 0.09) < 0.01
assert 9000 > 10 * n1 and 6000 > 10 * n2
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.7 B ----------------
add("4.7", {
 "title": "Confidence Interval for the Difference in Mean Tomato Yield",
 "calculator": "permitted",
 "stimulus": """A gardener randomly assigns 26 tomato plants of the same variety to two fertilizers: 12 plants receive fertilizer A and 14 plants receive fertilizer B. After 12 weeks she records the total mass of tomatoes (in kg) harvested from each plant. Dotplots of the yields in each group are roughly symmetric with no outliers.

Fertilizer A: n1 = 12, mean 4.60 kg, standard deviation 0.62 kg.
Fertilizer B: n2 = 14, mean 4.15 kg, standard deviation 0.75 kg.

Technology gives about 24.0 degrees of freedom. For 90% confidence, the critical value is t* = 1.711.""",
 "parts": [
  P("Check the conditions for constructing a two-sample t interval for μA − μB.",
    C("States that the plants were randomly assigned to the two fertilizers, so the groups are independent and the random condition is met.",
      "Response states that random assignment of plants to the two fertilizers satisfies the random condition and gives two independent groups.",
      "In an experiment, the random condition is met by random assignment to treatments; state what was randomly assigned."),
    C("States that both sample sizes are less than 30, but each group's yields are roughly symmetric with no outliers, so the sample data condition is met.",
      "Response notes that n1 and n2 are below 30 and uses the symmetric shape and absence of outliers in each group.",
      "When either sample size is under 30, check both samples for strong skewness and outliers.")),
  P("Construct a 90% confidence interval for μA − μB.",
    C("Calculates the standard error √(0.62²/12 + 0.75²/14) ≈ 0.269 kg.",
      "Response shows a standard error near 0.269 kg computed from both sample variances and both sample sizes.",
      "Add s1²/n1 and s2²/n2, then take the square root of the sum.", ["SE ≈ 0.27"]),
    C("Gives the interval (4.60 − 4.15) ± 1.711(0.269), which is approximately (−0.01, 0.91) kg.",
      "Response uses 0.45 as the point estimate, in the order A minus B, and gives limits near −0.01 and 0.91 kg.",
      "Multiply t* by the standard error for the margin of error, then add and subtract it from the point estimate.", ["(−0.01, 0.91)", "(-0.01, 0.91)"])),
  P("Interpret the interval in context.",
    C("States that we are 90% confident that the interval from −0.01 to 0.91 kg captures the true difference in mean tomato yield per plant (fertilizer A minus fertilizer B).",
      "Response states the confidence level, the interval, the order of subtraction, and that the parameter is a difference in mean yield per plant.",
      "Interpret with the confidence level, the interval, the order of subtraction, and the two fertilizers named."))],
 "model_answer": """(a) Random: the 26 plants were randomly assigned to the two fertilizers, so the two groups are independent. Sample data: both sample sizes (12 and 14) are less than 30, but the yields in each group are roughly symmetric with no outliers, so it is reasonable to use a two-sample t interval.

(b) Point estimate: 4.60 − 4.15 = 0.45 kg. Standard error: √(0.62²/12 + 0.75²/14) ≈ 0.269. Margin of error: 1.711(0.269) ≈ 0.46. The interval is 0.45 ± 0.46, which is approximately (−0.01, 0.91) kg.

(c) I am 90% confident that the interval from −0.01 to 0.91 kg captures the true difference in mean tomato yield per plant (fertilizer A minus fertilizer B) for plants like these.""",
 "verification_python": TBETA + """
import math
n1, m1, s1 = 12, 4.60, 0.62
n2, m2, s2 = 14, 4.15, 0.75
df = welch(s1, n1, s2, n2)
assert abs(df - 24.0) < 0.1
assert abs(tstar(0.90, df) - 1.711) < 0.001
se = math.sqrt(s1**2 / n1 + s2**2 / n2)
assert abs(se - 0.269) < 0.001
diff = m1 - m2
me = 1.711 * se
assert abs(diff - 0.45) < 1e-9
assert abs((diff - me) + 0.01) < 0.01 and abs((diff + me) - 0.91) < 0.01
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.8 A ----------------
add("4.8", {
 "title": "Using an Interval to Judge Claims About Puzzle Times with Music",
 "calculator": "not_applicable",
 "stimulus": """A psychologist randomly assigns 80 volunteers to solve the same puzzle, 40 with background music and 40 without music. She records each volunteer's completion time in seconds. Let μmusic − μnone be the true difference in mean completion time (music minus no music). A 95% confidence interval for μmusic − μnone is (−4.8, 1.9) seconds. The conditions for the interval were met.""",
 "parts": [
  P("Does the interval provide convincing evidence of a difference in mean completion time between the two conditions? Justify your answer.",
    C("States that the interval does not provide convincing evidence of a difference in the true mean completion times.",
      "Response concludes that there is not convincing evidence of a difference.",
      "Answer the question asked: state whether the interval gives convincing evidence of a difference in the population means."),
    C("Justifies the answer because 0 is in the interval, so 0 is a plausible value for the true difference.",
      "Response cites that the interval (−4.8, 1.9) contains 0 as the reason.",
      "Check whether 0 lies between the interval's limits; if it does, no difference is a plausible value.")),
  P("Suppose that instead the interval had been (−6.2, −0.7) seconds. Would the interval provide convincing evidence of a difference in mean completion time? If so, state which condition has the lower mean. Justify both answers using the interval.",
    C("States that the interval would provide convincing evidence of a difference, because 0 is not in the interval.",
      "Response concludes there is convincing evidence of a difference and cites that 0 is not in (−6.2, −0.7).",
      "If 0 is not in the interval, 0 is not a plausible value, so there is convincing evidence of a difference."),
    C("States that the mean completion time with music is lower than without music, because every value in the interval is negative.",
      "Response identifies music as having the lower mean and ties it to the interval containing only negative values of music minus none.",
      "Use the order of subtraction: if every value of music minus none is negative, the music mean is lower.")),
  P("A coach claims that music lowers the mean completion time by 6 seconds, that is, μmusic − μnone = −6. Does the original interval (−4.8, 1.9) support this claim? Explain.",
    C("States that the interval does not support the claim because −6 is not in the interval, so −6 is not a plausible value for the difference.",
      "Response answers no and cites that −6 is outside (−4.8, 1.9).",
      "Compare the claimed value with the interval's limits; a value outside the interval is not supported."))],
 "model_answer": """(a) No. The interval (−4.8, 1.9) contains 0, so 0 is a plausible value for the true difference in mean completion time. There is not convincing evidence of a difference between the conditions.

(b) Yes. The interval (−6.2, −0.7) does not contain 0, so 0 is not a plausible value, and there would be convincing evidence of a difference. Every value in the interval is negative for music minus no music, so the mean completion time is lower with music.

(c) No. The claimed value −6 is not in the interval (−4.8, 1.9), so −6 is not a plausible value for the true difference. The interval does not support the coach's claim.""",
 "verification_python": """lo, hi = -4.8, 1.9
assert lo < 0 < hi
lo2, hi2 = -6.2, -0.7
assert not (lo2 < 0 < hi2) and hi2 < 0
assert not (lo < -6 < hi)
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.8 B ----------------
add("4.8", {
 "title": "Using an Interval to Judge Claims About Two Teaching Methods",
 "calculator": "not_applicable",
 "stimulus": """A school district randomly assigns 120 students to learn a unit with Method A and 120 students to learn it with Method B. Each student takes the same end-of-unit exam, scored out of 100. Let μA − μB be the true difference in mean exam score (Method A minus Method B). A 95% confidence interval for μA − μB is (2.1, 9.7) points. The conditions for the interval were met.""",
 "parts": [
  P("Does the interval provide convincing evidence of a difference in mean exam score between the two methods? If so, state which method has the higher mean, and explain.",
    C("States that the interval provides convincing evidence of a difference, because 0 is not in the interval.",
      "Response concludes there is convincing evidence of a difference and cites that 0 is not in (2.1, 9.7).",
      "If 0 is outside the interval, state that 0 is not a plausible value and so there is convincing evidence of a difference."),
    C("States that Method A has the higher mean score, because every value in the interval is positive for A minus B.",
      "Response identifies Method A as having the higher mean and ties it to all values in the interval being positive.",
      "Use the order of subtraction: all values of A minus B positive means the mean for A is higher.")),
  P("A school board member claims that the true mean difference is exactly 5 points. Is the claim consistent with the interval? Does the interval establish that the claim is true? Explain.",
    C("States that the claim is consistent with the interval, because 5 is in the interval (2.1, 9.7) and so is a plausible value.",
      "Response states 5 lies inside the interval and is a plausible value for the difference.",
      "Check whether the claimed value lies between the limits; if it does, the interval is consistent with the claim."),
    C("States that the interval does not establish that the difference is exactly 5, because other values in the interval are also plausible.",
      "Response notes that many other values in the interval, such as 3 or 8, are also plausible, so exactly 5 is not shown.",
      "A plausible value is not a proven value; point out that other values in the interval remain plausible.")),
  P("A principal claims that Method A gives a mean exam score that is more than 10 points higher than Method B, that is, μA − μB > 10. Does the interval support this claim? Explain.",
    C("States that the interval does not support the claim, because 10 is greater than every value in the interval (the upper limit is 9.7).",
      "Response answers no and cites that the upper limit 9.7 is below 10.",
      "Compare the claimed threshold with the limits; if the whole interval is below 10, the claim of more than 10 is not supported."))],
 "model_answer": """(a) Yes. The interval (2.1, 9.7) does not contain 0, so 0 is not a plausible value for the true difference, and there is convincing evidence of a difference in mean exam score. Every value in the interval is positive for A minus B, so Method A has the higher mean score.

(b) The claim is consistent with the interval because 5 is between 2.1 and 9.7, so 5 is a plausible value. The interval does not establish that the difference is exactly 5, because many other values in the interval, such as 3 or 8, are also plausible.

(c) No. The upper limit of the interval is 9.7, so every plausible value of μA − μB is less than 10. The interval does not support the claim that Method A is more than 10 points higher.""",
 "verification_python": """lo, hi = 2.1, 9.7
assert not (lo < 0 < hi) and lo > 0
assert lo < 5 < hi
assert hi < 10
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.9 A ----------------
add("4.9", {
 "title": "Setting Up a Test Comparing Mean GPA of On-Campus and Commuting Students",
 "calculator": "not_applicable",
 "stimulus": """A university registrar wants to know whether the mean GPA of students who live on campus differs from the mean GPA of students who commute. About 7,000 students live on campus and about 4,500 commute. She takes an independent random sample of 60 on-campus students and a separate independent random sample of 48 commuting students and records each student's GPA. The GPAs in each sample are not strongly skewed and there are no outliers.""",
 "parts": [
  P("State the null and alternative hypotheses for the registrar's test, defining any parameters you use.",
    C("Defines μ1 as the true mean GPA of all on-campus students and μ2 as the true mean GPA of all commuting students at the university.",
      "Response defines both parameters as population means in context for the two groups.",
      "Define each parameter as a population mean and name which group it describes."),
    C("States the null hypothesis H0: μ1 − μ2 = 0 (equivalently μ1 = μ2).",
      "Response writes H0 as no difference between the two population means.",
      "Write H0 as the two population means being equal, which is a difference of 0."),
    C("States the alternative hypothesis Ha: μ1 − μ2 ≠ 0 (equivalently μ1 ≠ μ2).",
      "Response writes a two-sided Ha, because the registrar wants to know whether the means differ.",
      "Match Ha to the question: asking whether the means differ, with no direction, calls for a not-equal alternative.")),
  P("Name the inference procedure that is appropriate for these hypotheses.",
    C("Identifies a two-sample t-test for the difference between two population means.",
      "Response names a two-sample t-test for μ1 − μ2, not a paired t-test and not a z-test.",
      "Two independent samples measured on one quantitative variable call for a two-sample t-test for a difference in means.", ["two-sample t-test"])),
  P("The samples are independent random samples. Verify the 10% condition for each group and the sample data condition for using this procedure.",
    C("States that the 10% condition is met in each group: 7,000 is more than 10 × 60 = 600 and 4,500 is more than 10 × 48 = 480.",
      "Response compares each population size with 10 times the corresponding sample size (or each sample size with 10% of its population size).",
      "Check each group separately by comparing its sample size with 10% of its population size.", ["60 < 700", "48 < 450"]),
    C("States that the sample data condition is met because both sample sizes (60 and 48) are at least 30.",
      "Response cites both n1 = 60 and n2 = 48 being at least 30.",
      "Compare both sample sizes with 30; when both are at least 30, the sampling distribution of the difference is approximately normal."))],
 "model_answer": """(a) Let μ1 be the true mean GPA of all on-campus students at the university, and let μ2 be the true mean GPA of all commuting students at the university. H0: μ1 − μ2 = 0. Ha: μ1 − μ2 ≠ 0.

(b) A two-sample t-test for the difference between two population means is appropriate.

(c) 10%: 7,000 is more than 10 × 60 = 600, and 4,500 is more than 10 × 48 = 480, so the condition is met for both groups. Sample data: both sample sizes (60 and 48) are at least 30, so the sampling distribution of the difference in sample means is approximately normal.""",
 "verification_python": """assert 10 * 60 == 600 and 7000 > 600
assert 10 * 48 == 480 and 4500 > 480
assert 60 >= 30 and 48 >= 30
print('ALL_CHECKS_PASSED')
"""})

# ---------------- 4.9 B ----------------
add("4.9", {
 "title": "Setting Up a Test for a New Recovery Drink in a Cycling Experiment",
 "calculator": "not_applicable",
 "stimulus": """A sports scientist wants to test whether a new recovery drink lowers the mean time needed to complete a 20 km cycling time trial. She randomly assigns 24 cyclists to two groups of 12, without matching them on any characteristic. Group 1 drinks the new recovery drink and Group 2 drinks the standard recovery drink after a hard workout. The next day, each cyclist rides a 20 km time trial, and the scientist records the time in minutes. The times in each group are roughly symmetric with no outliers.""",
 "parts": [
  P("Explain why a two-sample procedure is appropriate here instead of a matched-pairs procedure.",
    C("Explains that there is no pairing: each cyclist is in only one group and was not matched with a cyclist in the other group, so the two groups are independent.",
      "Response states that no individual is measured twice and no cyclists were matched across the groups, so the data are two independent samples.",
      "Check for pairing: the same individual measured twice, or deliberately matched individuals; if neither, use a two-sample procedure.")),
  P("State the null and alternative hypotheses for the scientist's test, defining any parameters you use.",
    C("Defines the parameters in context: μ1 and μ2 as the true mean 20 km times (in minutes) after the new drink and the standard drink, or one parameter μ1 − μ2 as the true difference in mean times.",
      "Response defines either both population means or their difference as population parameters in context, with the order of subtraction if a difference is used.",
      "Define each parameter as a true mean time for one treatment, or the difference of the two, in context with units."),
    C("States the null hypothesis H0: μ1 − μ2 = 0 (equivalently μ1 = μ2).",
      "Response writes H0 as no difference between the two true mean times.",
      "Write H0 as the two true means being equal, which is a difference of 0."),
    C("States the alternative hypothesis Ha: μ1 − μ2 < 0 (equivalently μ1 < μ2).",
      "Response writes Ha with a less-than sign, because the new drink is expected to lower the mean time.",
      "Match Ha to the claim: a lower mean time with the new drink means the first mean is less than the second.")),
  P("Verify the conditions for using a two-sample t procedure.",
    C("States that the random condition is met because the cyclists were randomly assigned to the two groups.",
      "Response states that random assignment of cyclists to the two drinks satisfies the random condition.",
      "In an experiment, the random condition is met by random assignment of subjects to treatments; state what was randomized."),
    C("States that both sample sizes (12 and 12) are less than 30, but the times in each group are roughly symmetric with no outliers, so the sample data condition is met.",
      "Response notes both n are below 30 and uses the symmetric shape and absence of outliers in each group.",
      "When a sample size is under 30, check each group for strong skewness and outliers before using t procedures."))],
 "model_answer": """(a) Each cyclist is in only one group and drinks only one of the two drinks, so the two groups are independent and there is no pairing between them. A two-sample procedure is appropriate.

(b) Let μ1 be the true mean 20 km time trial time, in minutes, for cyclists after the new recovery drink, and let μ2 be the true mean time for cyclists after the standard recovery drink. H0: μ1 − μ2 = 0. Ha: μ1 − μ2 < 0.

(c) Random: the 24 cyclists were randomly assigned to the two groups. Sample data: both sample sizes (12 and 12) are less than 30, but the times in each group are roughly symmetric with no outliers, so it is reasonable to use a two-sample t procedure.""",
 "verification_python": """assert 12 + 12 == 24
assert 12 < 30
print('ALL_CHECKS_PASSED')
"""})

json.dump(items, open('authored_stats.json', 'w'), ensure_ascii=False, indent=1)
print(len(items), 'stats items written')
