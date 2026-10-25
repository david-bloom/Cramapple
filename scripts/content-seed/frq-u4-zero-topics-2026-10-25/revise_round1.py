import re
def sub(s, old, new, count=1):
    assert s.count(old) == count, (s.count(old), old[:80])
    return s.replace(old, new)

# ---------------- Biology ----------------
b = open('build_bio.py').read()
i0 = b.index("# ---------------- AP Biology 4.2 (A) ----------------")
i1 = b.index("# ---------------- AP Biology 4.2 (B) ----------------")
new42a = '''# ---------------- AP Biology 4.2 (A) ---------------- (round 2: replaced; round 1 voted 6 of 6 for 4.3)
items.append({"subject_key": "ap_biology", "topic_code": "4.2", "item": {
 "title": "Amplification in a Hormone Signal Transduction Pathway",
 "calculator": "not_applicable",
 "stimulus": """Epinephrine is a hormone released into the blood during stress. It binds to a G protein-coupled receptor (GPCR) in the plasma membrane of liver cells. The activated receptor activates a G protein, and the G protein activates the enzyme adenylyl cyclase. Adenylyl cyclase converts ATP to the second messenger cAMP. cAMP activates protein kinase A, a protein kinase that phosphorylates and activates the next enzyme in the pathway. A series of such steps ends with the activation of glycogen phosphorylase, an enzyme that breaks down glycogen to release glucose.

For each step, the table gives the approximate number of activated molecules produced per single activated receptor.

Step | Activated molecules per activated receptor
1. Receptor | 1
2. G protein | 100
3. Adenylyl cyclase | 100
4. cAMP | 10,000
5. Protein kinase A | 10,000
6. Glycogen phosphorylase | 1,000,000""",
 "parts": [
  P("Identify the second messenger in this pathway and the cellular response that the pathway produces.",
    C("Identifies cAMP as the second messenger in the pathway.",
      "Response names cAMP (cyclic AMP) as the second messenger.",
      "Find the small molecule that adenylyl cyclase produces from ATP; that molecule relays the signal and is the second messenger.", ["cyclic AMP"]),
    C("Identifies the cellular response as the breakdown of glycogen, releasing glucose.",
      "Response names glycogen breakdown or glucose release as the response produced by the pathway.",
      "Read the end of the pathway: the cellular response is what the final activated enzyme does.", ["glucose release"])),
  P("Use the table to state how many molecules of glycogen phosphorylase are activated per activated receptor, and explain how a series of steps like these can produce such a large response from a single hormone-binding event.",
    C("States that about 1,000,000 molecules of glycogen phosphorylase are activated per activated receptor.",
      "Response reads the value 1,000,000 from the last row of the table.",
      "Read the value for the final step directly from the table and state it with what it counts.", ["1 million", "10^6"]),
    C("Explains that each activated enzyme can activate many molecules of the next component, so the number of activated molecules increases at successive steps and the signal is amplified.",
      "Response states that each step activates multiple molecules of the next step, so the response is much larger than the original signal.",
      "Explain amplification by counting: one activated molecule at a step activates many molecules at the next step.")),
  P("Protein kinase A adds phosphate groups to its target proteins. Describe the effect of phosphorylation on a target protein.",
    C("Describes that phosphorylation changes the shape of the target protein, which changes its activity (for example, activating an enzyme).",
      "Response states that adding a phosphate group changes the target protein's shape or activity.",
      "Say what phosphorylation does to the target: it changes the protein's shape, and that change switches its activity on or off.", ["changes conformation"]))],
 "model_answer": """(a) The second messenger is cAMP. The cellular response is the breakdown of glycogen, which releases glucose.

(b) About 1,000,000 molecules of glycogen phosphorylase are activated per activated receptor. The signal is amplified because each activated component can activate many molecules of the next component. One activated receptor activates about 100 G proteins, and later steps multiply the number of activated molecules again, so one hormone-binding event leads to a very large response.

(c) Phosphorylation changes the shape of the target protein, which changes its activity, for example by switching an enzyme on.""",
 "verification_python": """steps = [1, 100, 100, 10000, 10000, 1000000]
assert steps[-1] == 1000000 and steps[0] == 1
assert steps == sorted(steps)
assert steps[-1] // steps[0] == 10**6
print('ALL_CHECKS_PASSED')
"""}})

'''
b = b[:i0] + new42a + b[i1:]
# 4.2 B: a2 only needs the Y blocker data
b = sub(b, '''    C("Supports the answer with the blocker data: the response to signal Y fell from 90 to 2 when the blocker was present, while the response to signal X stayed about the same (85 and 83).",
      "Response compares treatments with and without the blocker for both signals and states that only the response to Y was lost.",
      "Compare each signal with and without the blocker, and state which response disappeared and which stayed about the same.")),''',
'''    C("Supports the answer with the blocker data: the response to signal Y fell from 90 to 2 when the blocker, which acts only outside the cell, was present.",
      "Response cites the loss of the response to signal Y (about 90 to about 2) when the blocker was present. A comparison with signal X may be included but is not required.",
      "Cite the values for signal Y with and without the blocker; a large drop shows its receptor is reachable by the outside-only blocker.")),''')
# 4.6 A: ask for the evidence that criterion b1 awards
b = sub(b, 'P("Based on the second table, identify the stage of the cell cycle at which most drug-treated cells are stopped, and explain what this shows about the role of the cyclin-CDK complex that the drug blocks.",',
           'P("Based on the second table, identify the stage of the cell cycle at which most drug-treated cells are stopped, support your answer with values from the table, and explain what this shows about the role of the cyclin-CDK complex that the drug blocks.",')
open('build_bio.py', 'w').write(b)

# ---------------- Statistics ----------------
s = open('build_stats.py').read()
# 4.2 A: split off the bundled calculation
s = sub(s, '''    C("Computes the standard error as 4.2/√22 ≈ 0.895 cm and the margin of error as 2.080 × 0.895 ≈ 1.86 cm.",
      "Response shows a standard error near 0.895 and a margin of error near 1.86 using t* = 2.080.",
      "Divide s by the square root of n for the standard error, then multiply by t* for the margin of error.", ["SE ≈ 0.9", "margin of error ≈ 1.9"]),''',
'''    C("Sets up the interval as 31.4 ± 2.080(4.2/√22), with the sample mean, t*, s and n correctly substituted (the standard error is about 0.895 cm).",
      "Response shows the t interval expression with 31.4, 2.080, 4.2 and 22 correctly substituted, or an equivalent calculator setup that names the same values.",
      "Write the interval as the sample mean plus or minus t* times s over the square root of n, then substitute each value.", ["SE ≈ 0.895"]),''')
# 4.2 B: give the population size so the 10% condition can hold
s = sub(s, "She randomly selects 14 students from her school.", "She randomly selects 14 of the 1,150 students at her school.")
s = sub(s, "assert abs((d - me) - 1.49) < 0.01 and abs((d + me) - 6.31) < 0.01\n", "assert abs((d - me) - 1.49) < 0.01 and abs((d + me) - 6.31) < 0.01\nassert 1150 > 10 * n\n")
# 4.4 A: random is given; ask for 10% and sample data, accept either form of the 10% check
s = sub(s, '''  P("Verify the conditions for using this procedure.",
    C("Verifies the random condition and the 10% condition: the calls are a simple random sample, and 5,400 is more than 10 × 36 = 360.",
      "Response states that the sample is random and compares the population of about 5,400 calls with 10 times the sample size, 360.",
      "State how the sample was selected and compare the population size with 10 times the sample size."),''',
'''  P("The calls are a simple random sample. Verify the 10% condition and the sample data condition for using this procedure.",
    C("States that the 10% condition is met because the population of about 5,400 calls is more than 10 times the sample size of 36 (equivalently, 36 is less than 10% of 5,400).",
      "Response compares 5,400 with 10 × 36 = 360, or 36 with 10% of 5,400 = 540, and concludes the condition is met.",
      "Compare the sample size with 10% of the population size, or the population size with 10 times the sample size, and state the conclusion.", ["n < 0.10N", "36 < 540"]),''')
s = sub(s, "(c) Random: the 36 calls are a simple random sample. 10%: there are about 5,400 calls, which is more than 10 × 36 = 360. Sample data:",
           "(c) 10%: there are about 5,400 calls, which is more than 10 × 36 = 360 (equivalently, 36 is less than 10% of 5,400), so the condition is met. Sample data:")
s = sub(s, "assert 10 * 36 == 360 and 5400 > 360\n", "assert 10 * 36 == 360 and 5400 > 360 and 36 < 0.10 * 5400\n")
# 4.6 A: enough bags for the 10% condition; split the calculation from the comparison
s = sub(s, "Each machine fills far more than 360 bags in a day.", "Each machine fills at least 5,000 bags in a day.")
s = sub(s, '''    C("Calculates the new standard deviation √(6²/36 + 5²/60) ≈ 1.190 g and states that it is smaller than 1.354 g.",
      "Response gives a new value near 1.19 g and states that increasing a sample size decreases the standard deviation.",
      "Recalculate with the new sample size; a larger sample size gives a smaller standard deviation for the sampling distribution."))],''',
'''    C("Calculates the new standard deviation √(6²/36 + 5²/60) ≈ 1.190 g.",
      "Response gives a value near 1.19 g from the correct formula with n2 = 60.",
      "Replace n2 with 60 in the variance of the second sample mean, add the two variances, then take the square root.", ["1.19", "1.190 g"]),
    C("States that the new standard deviation is smaller than the original 1.354 g.",
      "Response compares the new value with 1.354 g and states that the new value is smaller.",
      "Compare the new value with the earlier one and say which is smaller; a larger sample gives a smaller value.", ["smaller", "decreases"]))],''')
s = sub(s, "assert 36 >= 30 and 30 >= 30\n", "assert 36 >= 30 and 30 >= 30\nassert 5000 > 10 * 60\n")
# 4.7 A and B: the point estimate rides inside the interval criterion
s = sub(s, '''    C("Calculates the point estimate 6.8 − 7.3 = −0.5 and the standard error √(1.1²/45 + 0.9²/52) ≈ 0.206 hours.",
      "Response gives the difference in sample means and a standard error near 0.206 hours.",
      "Compute the point estimate in the order of the parameter, then the standard error from both sample variances over their sample sizes.", ["SE ≈ 0.21"]),
    C("Gives the interval −0.5 ± 1.988(0.206), which is approximately (−0.91, −0.09) hours.",
      "Response gives limits near −0.91 and −0.09 hours.",''',
'''    C("Calculates the standard error √(1.1²/45 + 0.9²/52) ≈ 0.206 hours.",
      "Response shows a standard error near 0.206 hours computed from both sample variances and both sample sizes.",
      "Add s1²/n1 and s2²/n2, then take the square root of the sum.", ["SE ≈ 0.21"]),
    C("Gives the interval (6.8 − 7.3) ± 1.988(0.206), which is approximately (−0.91, −0.09) hours.",
      "Response uses −0.5 as the point estimate, in the order group 1 minus group 2, and gives limits near −0.91 and −0.09 hours.",''')
s = sub(s, '''    C("Calculates the point estimate 4.60 − 4.15 = 0.45 kg and the standard error √(0.62²/12 + 0.75²/14) ≈ 0.269 kg.",
      "Response gives the difference in sample means and a standard error near 0.269 kg.",
      "Compute the point estimate in the order of the parameter, then the standard error from both sample variances over their sample sizes.", ["SE ≈ 0.27"]),
    C("Gives the interval 0.45 ± 1.711(0.269), which is approximately (−0.01, 0.91) kg.",
      "Response gives limits near −0.01 and 0.91 kg.",''',
'''    C("Calculates the standard error √(0.62²/12 + 0.75²/14) ≈ 0.269 kg.",
      "Response shows a standard error near 0.269 kg computed from both sample variances and both sample sizes.",
      "Add s1²/n1 and s2²/n2, then take the square root of the sum.", ["SE ≈ 0.27"]),
    C("Gives the interval (4.60 − 4.15) ± 1.711(0.269), which is approximately (−0.01, 0.91) kg.",
      "Response uses 0.45 as the point estimate, in the order A minus B, and gives limits near −0.01 and 0.91 kg.",''')
# 4.8 A: the part must ask for the justification that its criteria award
s = sub(s, "If so, state which condition has the lower mean.\",", "If so, state which condition has the lower mean. Justify both answers using the interval.\",")
# 4.9 A: independence is given; ask for 10% and sample data, and n >= 30 alone meets the sample data condition
i = s.index("# ---------------- 4.9 A ----------------"); j = s.index("# ---------------- 4.9 B ----------------")
blk = s[i:j]
blk = sub(blk, '''  P("Verify the conditions for using this procedure.",
    C("States that the samples are independent random samples, and that the 10% condition is met in each group because 7,000 is more than 10 × 60 = 600 and 4,500 is more than 10 × 48 = 480.",
      "Response states random and independent samples and compares each population size with 10 times its sample size.",
      "Check randomness and independence of the two samples, then compare each population size with 10 times its sample size."),
    C("States that the sample data condition is met, because both sample sizes (60 and 48) are at least 30 and the samples are not strongly skewed with no outliers.",
      "Response cites both sample sizes being at least 30, with no strong skewness or outliers.",
      "Compare both sample sizes with 30; when both are at least 30, the sampling distribution of the difference is approximately normal."))],''',
'''  P("The samples are independent random samples. Verify the 10% condition for each group and the sample data condition for using this procedure.",
    C("States that the 10% condition is met in each group: 7,000 is more than 10 × 60 = 600 and 4,500 is more than 10 × 48 = 480.",
      "Response compares each population size with 10 times the corresponding sample size (or each sample size with 10% of its population size).",
      "Check each group separately by comparing its sample size with 10% of its population size.", ["60 < 700", "48 < 450"]),
    C("States that the sample data condition is met because both sample sizes (60 and 48) are at least 30.",
      "Response cites both n1 = 60 and n2 = 48 being at least 30.",
      "Compare both sample sizes with 30; when both are at least 30, the sampling distribution of the difference is approximately normal."))],''')
blk = sub(blk, "(c) Random and independent: the two samples are independent random samples from the two groups. 10%: 7,000 is more than 10 × 60 = 600, and 4,500 is more than 10 × 48 = 480. Sample data: both sample sizes (60 and 48) are at least 30, and the samples are not strongly skewed with no outliers, so",
               "(c) 10%: 7,000 is more than 10 × 60 = 600, and 4,500 is more than 10 × 48 = 480, so the condition is met for both groups. Sample data: both sample sizes (60 and 48) are at least 30, so")
s = s[:i] + blk + s[j:]
# 4.9 B: matched pairs can use different, deliberately matched people; parameter may be the difference
s = sub(s, "to two groups of 12. Group 1 drinks", "to two groups of 12, without matching them on any characteristic. Group 1 drinks")
s = sub(s, '''    C("Explains that each cyclist is in only one group and receives only one drink, so there is no pairing between the groups, and the two groups are independent.",
      "Response states that different cyclists are in the two groups, so the data are two independent samples, not pairs.",
      "Check whether the same individuals receive both treatments; if each is in one group only, use a two-sample procedure.")),''',
'''    C("Explains that there is no pairing: each cyclist is in only one group and was not matched with a cyclist in the other group, so the two groups are independent.",
      "Response states that no individual is measured twice and no cyclists were matched across the groups, so the data are two independent samples.",
      "Check for pairing: the same individual measured twice, or deliberately matched individuals; if neither, use a two-sample procedure.")),''')
s = sub(s, '''    C("Defines μ1 as the true mean 20 km time (in minutes) of cyclists after the new recovery drink and μ2 as the true mean time of cyclists after the standard recovery drink.",
      "Response defines both parameters as population means for the two treatments, in context.",
      "Define each parameter as a true mean time for one treatment, in context, with units."),''',
'''    C("Defines the parameters in context: μ1 and μ2 as the true mean 20 km times (in minutes) after the new drink and the standard drink, or one parameter μ1 − μ2 as the true difference in mean times.",
      "Response defines either both population means or their difference as population parameters in context, with the order of subtraction if a difference is used.",
      "Define each parameter as a true mean time for one treatment, or the difference of the two, in context with units."),''')
open('build_stats.py', 'w').write(s)
print('patched')
