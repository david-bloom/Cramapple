import json
V=[]
def v(seed,n,diff,title,stem,c,w,note,check="conceptual"):
    V.append({"id":f"{seed}-v{n}","seed":seed,"difficulty":diff,"title":title,"stem":stem,
      "correct":{"text":c[0],"rationale":c[1]},
      "wrong":[{"text":t,"rationale":r,"error_pattern":e} for t,r,e in w],
      "change_note":note,"check":check})
s="APSTATS-MCQ-001"
v(s,1,"medium","Reporting delays on a commuter rail line",
"A transit agency records the delay (in minutes) of each of 60 commuter trains in one month. The histogram is strongly right-skewed: most delays are under 10 minutes, but a handful exceed two hours. An analyst wants one measure of center and one measure of spread that will not be distorted by those extreme delays. Which pair should the analyst report, and why?",
("Median and IQR, because both depend only on the ordered middle of the data and are not moved by a few very long delays.","The median is the middle value and the IQR (Q3 - Q1) covers the middle 50% of delays, so a few two-hour delays barely change either one; they are the resistant choices for a right-skewed distribution."),
[("Mean and standard deviation, because they take every train's delay into account and so reflect the whole month.","The mean and SD are both pulled upward by the few delays over two hours; including every value is a drawback, not an advantage, when the distribution is skewed with extreme values.","Believing that using all data values makes mean and SD best regardless of skew"),
("Median and range, because the range shows how bad the worst delays were.","The median is resistant, but the range is determined only by the shortest and longest delays, so it is the spread measure most affected by the two-hour outliers.","Pairing a resistant center with the least resistant spread measure"),
("Mean and IQR, because the mean gives the total delay spread evenly across all trains.","The IQR is resistant, but the mean is still pulled toward the long right tail; a resistant spread does not fix a non-resistant center, and the mean would sit above what a typical train experiences.","Mixing a non-resistant center with a resistant spread")],
"New context (train delays), reworded task to ask for non-distorted measures; distractors reframed around different reasons.")
v(s,2,"medium","Text messages sent by teens",
"A school counselor asks 80 teens how many text messages they sent yesterday. The distribution is strongly right-skewed with a five-number summary of: Min = 0, Q1 = 12, Median = 30, Q3 = 66, Max = 410. Which description of typical value and variation is most appropriate?",
("A median of 30 texts and an IQR of 54 texts, because neither is pulled by the few extremely high counts.","IQR = Q3 - Q1 = 66 - 12 = 54. The median (30) and IQR (54) depend on the middle of the ordered data, so the maximum of 410 does not distort them in this skewed distribution."),
[("A median of 30 texts and a range of 410 texts, because the range shows the full spread of the data.","The median is resistant, but the range 410 - 0 = 410 is determined entirely by the single extreme maximum and so is not resistant to the skew.","Pairing a resistant center with the range"),
("A mean and standard deviation, because they use all 80 reported values.","The mean and SD are both inflated by the few very high counts like 410; using every value is not a strength for a strongly skewed distribution.","Preferring mean and SD because they use all values"),
("A median of 30 texts and an IQR of 36 texts, because the IQR is the distance from the median to Q3.","The IQR is Q3 - Q1 = 66 - 12 = 54, not Q3 - median = 66 - 30 = 36; 36 is only the upper half of the middle 50%.","Computing the IQR as Q3 minus the median")],
"Numeric five-number summary included; IQR computed from quartiles; distractor adds an IQR computation error.","numeric")
v(s,3,"hard","Home prices in a neighborhood",
"A real estate agent reports that for homes sold in one neighborhood last year, the mean sale price was $410,000 and the median sale price was $325,000. A buyer asks for the single value that best represents a typical home price. Which response is best?",
("Report the median of $325,000, because the mean is pulled above the typical home by a few very expensive sales.","Mean greater than median signals right skew; the median is resistant to the few high-priced homes, so $325,000 better represents a typical sale."),
[("Report the mean of $410,000, because it accounts for every home's sale price.","Including every value is exactly why the mean is dragged upward by a few very expensive homes; $410,000 is higher than half of the homes sold and so overstates a typical price.","Preferring the mean because it uses all values"),
("Report the mean of $410,000, because the median ignores half of the data.","The median is based on the position of the middle value and is not affected by how extreme the other values are; it does not 'ignore' data, it resists outliers.","Misunderstanding the median as discarding data"),
("Report either one, because the mean and median always give the same typical value.","Here they differ by $85,000, and a mean well above the median indicates right skew; the two are only close in roughly symmetric distributions.","Believing mean and median always agree")],
"Reverses given info: mean and median reported instead of five-number summary; asks for a typical value.","numeric")

s="APSTATS-MCQ-019"
v(s,1,"easy","Apartment rents in a city",
"Monthly rents for apartments listed in a city are strongly right-skewed because a few luxury units cost far more than the rest. A housing researcher wants to describe the typical rent and how much rents vary. Which pair of statistics is most appropriate?",
("Median and IQR, since luxury listings barely affect either one.","Both are resistant: they depend on the middle of the ordered rents, so the few luxury units do not change them much."),
[("Mean and standard deviation, since they are the most commonly used.","Popularity is not the criterion; the luxury units inflate both the mean and SD in a right-skewed distribution.","Choosing based on familiarity instead of resistance"),
("Median and range, since the range includes all of the listings.","Although the median is resistant, the range depends only on the cheapest and most expensive unit, so the luxury listings dominate it.","Pairing median with non-resistant range"),
("Mean and IQR, since the IQR is the only resistant spread measure.","The IQR is resistant, but the mean is pulled toward the luxury rents, so this pair is only half-resistant.","Using the mean with a resistant spread")],
"Different context (rents); reasoning-style distractors.")
v(s,2,"easy","Wingspans of a bird species",
"A biologist measures the wingspan of 120 randomly captured adults of one bird species. A histogram is symmetric and mound-shaped with no outliers. Which pair of statistics is most appropriate to describe the center and spread?",
("Mean and SD, since a symmetric distribution without outliers does not distort them.","With symmetry and no outliers, the mean and SD summarize center and spread well and use all of the data."),
[("Median and IQR, since they should always be used no matter what shape the data have.","Median and IQR are preferred for skewed distributions or outliers, but nothing requires them for a symmetric distribution; mean and SD are appropriate here.","Overgeneralizing the skewed-data rule to every distribution"),
("Median and range, since the range is the easiest spread measure to compute.","Ease of computing is not the criterion, and the range uses only two values, discarding most of the information about spread.","Choosing the range for convenience"),
("Mean and range, since the range reports the distance between the two extreme wingspans.","The range uses only the two most extreme values and gives no information about how the middle of the data varies; SD is the better partner for the mean.","Pairing the mean with the range")],
"Flips the shape: symmetric case where mean/SD is correct, testing the same decision rule.")
v(s,3,"medium","Waiting times at an urgent care clinic",
"The waiting times (in minutes) of 150 patients at an urgent care clinic are strongly right-skewed with five-number summary: Min = 2, Q1 = 10, Median = 14, Q3 = 19, Max = 90. Which pair of values best describes the center and spread of the waiting times?",
("Median = 14 minutes and IQR = 9 minutes, since neither is affected much by the 90-minute wait.","IQR = Q3 - Q1 = 19 - 10 = 9. The median and IQR are resistant, so they describe the typical wait well despite the extreme 90."),
[("Median = 14 minutes and range = 88 minutes, since the range shows the full spread.","The range is 90 - 2 = 88 but it is determined only by the two extremes, so the 90-minute wait dominates it.","Using the range as spread for skewed data"),
("Median = 14 minutes and spread = 17 minutes, since that is the distance from the minimum to Q3.","19 - 2 = 17 uses the minimum instead of Q1; the IQR is Q3 - Q1 = 9.","Subtracting the minimum instead of Q1 when finding the IQR"),
("Median = 14 minutes and spread = 5 minutes, since that is the distance from the median to Q3.","19 - 14 = 5 covers only the upper half of the middle 50%; the IQR is Q3 - Q1 = 9.","Using Q3 minus median instead of the IQR")],
"Gives numeric summary; requires computing IQR correctly.","numeric")

s="APSTATS-MCQ-023"
v(s,1,"medium","Effect of replacing the largest value",
"A quiz has these scores: 5, 6, 6, 7, 8, 9, 9, 52. If the largest score were changed from 52 to 520, which summary would stay exactly the same?",
("The median, which stays at 7.5.","The median is the average of the middle two values (7 and 8) = 7.5, and neither of those changes when the largest value is replaced."),
[("The mean, which stays at 12.75.","The mean uses every value: the sum rises from 102 to 570, so the mean changes from 12.75 to 71.25.","Believing the mean ignores one extreme value"),
("The range, which stays at 47.","The range is max - min: 52 - 5 = 47 becomes 520 - 5 = 515, so it changes.","Believing the range is stable when only the maximum changes"),
("The standard deviation, which stays near 16.","The SD is about 15.9 now and would rise to about 181 because 520 lies far from the new mean of 71.25; SD depends on every value's distance from the mean.","Believing SD is unaffected by extreme values")],
"New data, asks which statistic is unchanged when an outlier grows; numeric statements recomputed.","numeric")
v(s,2,"medium","Lab timing with a recording error",
"A technician records the times (in seconds) for 8 lab trials: 12, 14, 15, 15, 16, 18, 19, 30. The 30 was later found to be a typing error for 300. Which statistic would be least affected by this error?",
("The IQR, which is 4 seconds with either value.","Q1 = (14 + 15)/2 = 14.5 and Q3 = (18 + 19)/2 = 18.5 either way, so IQR = 4; the largest value is not used in either quartile."),
[("The mean, because averaging dilutes one value among eight.","The sum changes from 139 to 409, so the mean goes from 17.375 to 51.125; dilution does not make it resistant.","Believing the mean dilutes a single extreme value"),
("The range, because it only involves the two ends of the data.","Being based on the ends is why it is affected: the range changes from 30 - 12 = 18 to 300 - 12 = 288.","Misreading dependence on the extreme as stability"),
("The standard deviation, because it measures typical deviation from the mean.","The mean itself rises sharply and the 300 is far from it, so the SD increases dramatically.","Believing SD is a typical deviation unaffected by outliers")],
"Typo/outlier-correction framing; IQR quartiles computed explicitly.","numeric")
v(s,3,"hard","Adding a very low score",
"A teacher's quiz scores are 62, 68, 71, 74, 75, 77, 79 (mean about 72.3, median 74). A late student then turns in a quiz with a score of 3. Which statement about the effect of the new score is correct?",
("The mean fell by about 8.7 points to 63.6, while the median fell by only 1.5 points to 72.5.","New mean = 509/8 = 63.625 (from 506/7 = 72.29, a drop of 8.66); new median = (71 + 74)/2 = 72.5 (a drop of 1.5). The median is resistant."),
[("The median fell by about 8.7 points while the mean fell only 1.5, since the median is the middle value.","The values are swapped: it is the mean that falls by about 8.7 (to 63.6); the median only moves to 72.5.","Swapping the effects on mean and median"),
("The mean and median both fell by about 8.7 points, since both measure center.","The median is determined by the middle positions: it only changes from 74 to 72.5.","Assuming all measures of center react equally"),
("Neither the mean nor the median changed, since only one score was added.","Adding a score changes the mean to 63.625 and shifts the middle of eight values to (71 + 74)/2 = 72.5.","Assuming one added value cannot change either measure")],
"Compares changes in mean and median after adding an outlier; full recomputation.","numeric")

s="APSTATS-MCQ-027"
v(s,1,"easy","Interpreting reported mean and median",
"For the lengths of 200 randomly selected leaves, a botanist reports a mean of 52.4 mm, a median of 52.1 mm, and a standard deviation of 6.0 mm. Which conclusion about the shape is most reasonable?",
("The distribution is roughly symmetric, since the mean and median are nearly equal compared to the spread.","A 0.3 mm gap is tiny relative to an SD of 6.0 mm, which is consistent with a roughly symmetric distribution."),
[("The distribution is right-skewed, since the mean is larger than the median.","Any skew rule needs a meaningful gap; a 0.3 mm difference relative to SD 6.0 is negligible and not evidence of right skew.","Treating any mean > median gap as skew"),
("The distribution is left-skewed, since the median is close to the mean rather than far above it.","Left skew pulls the mean below the median by a notable amount; a nearly equal mean and median do not show that.","Misapplying the left-skew rule"),
("Nothing can be said about shape, since the mean and median describe only center.","Comparing the mean to the median gives evidence of symmetry or skew, so these two summaries do provide information about shape.","Believing center statistics carry no shape information")],
"Reverses direction: given statistics, infer shape.","numeric")
v(s,2,"medium","Commute time shape from summary statistics",
"The commute times of 300 workers have a mean of 38 minutes and a median of 29 minutes. Which description of the distribution is most consistent with these values?",
("Right-skewed, because a few long commutes pull the mean above the median.","Mean (38) greater than median (29) by 9 minutes is the signature of a long right tail."),
[("Left-skewed, because the mean is greater than the median.","In left-skewed data the mean is pulled below the median, not above.","Reversing the skew-direction rule"),
("Symmetric, because the mean and median are both measures of center.","In a symmetric distribution the two would be close; a 9-minute gap indicates skew.","Ignoring the gap between mean and median"),
("Left-skewed, because most workers have commutes shorter than the mean.","Having more than half of values below the mean is consistent with right skew, not left.","Misreading the position of the bulk of the data")],
"Right-skew direction identification with numbers.","numeric")
v(s,3,"medium","Retirement age distribution",
"The ages at which employees at a large company retired form a left-skewed distribution, with a few people retiring in their early forties and most retiring in their sixties. Which statement is most likely true?",
("The mean retirement age is less than the median retirement age.","The few very early retirements pull the mean toward the low tail while the median stays near the bulk of the data."),
[("The mean retirement age is greater than the median retirement age.","This is the pattern for right skew; the low tail pulls the mean down in a left-skewed distribution.","Reversing skew rule"),
("The mean and median retirement ages are exactly equal.","Equality is expected only for symmetric distributions; skew separates them.","Ignoring skew's effect"),
("The median is pulled further toward the early retirees than the mean is.","The median is resistant to the early retirements and is pulled less than the mean.","Misattributing resistance")],
"Direction given, reasoning about mean vs median.")

s="APSTATS-MCQ-040"
v(s,1,"medium","Blocking in a fertilizer experiment",
"A gardener wants to compare two fertilizers using 24 tomato plants in a garden where half the plants are in full sun and half are in shade, and sunlight strongly affects growth. Which plan uses blocking?",
("Separate the plants into sun and shade groups, then randomly assign fertilizers within each group.","Sunlight is a known source of variability; random assignment within sun and shade blocks balances it across both fertilizers, so sunlight cannot be confounded with fertilizer."),
[("Flip a coin for each plant to choose its fertilizer, ignoring sunlight.","This is a completely randomized design; no blocks are formed.","Confusing complete randomization with blocking"),
("Apply fertilizer A to all sun plants and fertilizer B to all shade plants.","Fertilizer is completely confounded with sunlight, so differences cannot be attributed to fertilizer; no random assignment within blocks.","Assigning treatments to whole groups"),
("Use only the sun plants and randomly assign the two fertilizers.","This controls sunlight by restricting the study, but it is not blocking since shade plants are not included and results do not extend to shade.","Equating restricting the units with blocking")],
"Agricultural scenario; asks which plan uses blocking.")
v(s,2,"medium","Purpose of blocking in a study-method experiment",
"Researchers compare two study methods using students whose prior GPAs vary widely, and they place students into 'high GPA' and 'low GPA' blocks before randomly assigning methods within each block. What is the main purpose of blocking here?",
("To remove variation due to prior GPA so method differences are easier to detect.","Blocking removes variation tied to GPA from the comparison between methods, making treatment differences clearer."),
[("To make sure the sample is representative of every student in the school.","Representativeness comes from random sampling, not blocking.","Confusing blocking with random sampling"),
("To make sure neither the students nor the graders know which method was used.","That describes blinding; blocking concerns grouping similar units.","Confusing blocking with blinding"),
("To remove the need for random assignment of methods to students.","Random assignment is still done within each block.","Believing blocking replaces randomization")],
"Asks for purpose of an already specified block design.")
v(s,3,"hard","Identifying the design type",
"To compare two exercise programs, a researcher separates 60 volunteers into a male group and a female group, then within each group uses a random number generator to assign half to Program 1 and half to Program 2. Which description is most accurate?",
("A randomized block experiment, with sex as the blocking variable.","Subjects are grouped by sex and treatments are randomly assigned within each block."),
[("A stratified random sample, since subjects were grouped by sex.","Stratified sampling is about selecting units for a sample; here the researcher assigns treatments, so it is an experiment.","Confusing blocking with stratified sampling"),
("A completely randomized design, since random assignment was used.","In a completely randomized design all subjects are randomized together; here randomization is within sex groups.","Ignoring the grouping step"),
("An observational study, since sex cannot be assigned.","The researcher imposes the exercise programs, so it is an experiment; sex is only a blocking variable.","Confusing the blocking variable with the treatment")],
"Asks to classify a described design; distractors about sampling and CRD.")

s="APSTATS-MCQ-044"
v(s,1,"medium","Single-blind scoring in a tutoring study",
"Students are randomly assigned to use a tutoring app or a traditional workbook. The final tests are scored by a teacher who is not told which students used which method. What is the main benefit of having the scorer blinded?",
("It prevents the scorer's expectations about the app from influencing the scores.","Blinding evaluators keeps expectations from biasing measurements."),
[("It prevents the students' expectations from affecting their performance.","The students know which method they used, so blinding the scorer does not address student expectations.","Confusing who is blinded"),
("It removes confounding variables such as prior ability.","Confounding is handled by random assignment and design, not by blinding.","Confusing blinding with control"),
("It makes the sample representative of all students.","Representativeness comes from random sampling.","Confusing blinding with sampling")],
"Single-blind scorer scenario.")
v(s,2,"medium","Measuring the placebo effect",
"In a study of a headache remedy, a placebo group's pain score improved by an average of 4.1 points, while a no-treatment group's pain score improved by an average of 1.3 points. Using the definition of placebo effect as the difference between the average placebo response and the average no-treatment response, what is the placebo effect?",
("2.8 points","4.1 - 1.3 = 2.8, the extra improvement attributable to receiving a placebo rather than nothing."),
[("4.1 points","This is the placebo group's full average improvement; part of it (1.3) would have happened with no treatment.","Equating placebo response with placebo effect"),
("5.4 points","4.1 + 1.3 = 5.4 adds the two averages rather than taking the difference.","Adding instead of subtracting"),
("0 points, because a placebo contains no active ingredient.","A placebo effect can occur even without an active ingredient; here the placebo group improved 2.8 points more than the no-treatment group.","Believing an inert placebo cannot have an effect")],
"Numeric placebo-effect calculation; tests placebo definition.","numeric")
v(s,3,"medium","Identifying a double-blind design",
"Which setup for a trial of a new cholesterol drug is double-blind?",
("Identical-looking capsules coded by pharmacy; neither patients nor the clinicians recording outcomes know assignments.","Hiding assignments from both patients and outcome evaluators makes it double-blind, reducing placebo effects and observer bias."),
[("Patients are unaware of what they receive, but the clinician recording outcomes knows each assignment.","Since the clinician recording outcomes knows each assignment, only one party is blinded, so the design is single-blind.","Confusing single-blind with double-blind"),
("Patients choose between the drug and a placebo, but clinicians do not know who chose which.","Patients choosing their own treatment is not random assignment and the patients are not blinded, so it is not double-blind.","Confusing blinding with random assignment"),
("All patients receive the drug and both patients and clinicians know it.","Giving everyone the drug with everyone aware has no comparison group and no blinding, so it is neither single- nor double-blind.","Confusing the absence of blinding")],
"Identify double-blind among setups.")

s="APSTATS-MCQ-048"
v(s,1,"easy","Email open and click probabilities",
"For a marketing email, 45% of recipients open the message. Among those who open it, 20% click the link. What is the probability that a randomly selected recipient both opens the email and clicks the link?",
("0.09","P(open and click) = P(open) × P(click | open) = 0.45 × 0.20 = 0.09."),
[("0.65","0.45 + 0.20 = 0.65 adds the probabilities rather than multiplying along the path.","Adding"),
("0.11","0.55 × 0.20 = 0.11 uses the probability of not opening.","Using the complement"),
("0.25","0.45 - 0.20 = 0.25 subtracts instead of multiplying.","Subtracting")],
"New context, numbers 0.45/0.20; different distractors.","numeric")
v(s,2,"medium","Passing two exams in sequence",
"A student passes the first exam of a course with probability 0.80. If the student passes the first exam, the probability of passing the second exam is 0.75. What is the probability that the student passes both exams?",
("0.60","P(both) = 0.80 × 0.75 = 0.60."),
[("0.75","This is only the conditional probability of passing the second exam given the first.","Confusing conditional with joint"),
("0.95","0.80 + 0.75 - 0.60 = 0.95 is a union-type calculation.","Union instead of intersection"),
("0.20","0.80 × 0.25 = 0.20 is the probability of passing the first and failing the second.","Using the failure probability")],
"Different context, numbers.","numeric")
v(s,3,"medium","Three-stage multiplication",
"In a three-step security check, 50% of travelers pass step 1. Of those, 40% pass step 2. Of those who pass steps 1 and 2, 90% pass step 3. What proportion of all travelers pass all three steps?",
("0.18","0.50 × 0.40 × 0.90 = 0.18."),
[("0.20","0.50 × 0.40 = 0.20 stops after two steps.","Omitting the last stage"),
("0.02","0.50 × 0.40 × 0.10 = 0.02 uses the failure proportion for step 3.","Using the complement at the last stage"),
("0.60","The average of 0.50, 0.40, 0.90 is 0.60, not a probability of all three.","Averaging")],
"Three-stage version.","numeric")

s="APSTATS-MCQ-052"
v(s,1,"medium","Identify the binomial scenario",
"Which of the following random variables has a binomial distribution?",
("The number of heads in 15 flips of a fair coin.","A fixed 15 independent trials, two outcomes, constant p = 0.5."),
[("The number of hearts in a 5-card hand dealt without replacement from a standard deck.","Trials are dependent and P(heart) changes after each card.","Ignoring dependence"),
("The number of flips needed until the first head appears.","The number of trials is not fixed in advance.","Ignoring fixed n"),
("The sum of the faces in 10 rolls of a fair die.","A sum is not a count of successes; each roll has six outcomes.","Confusing sums with counts")],
"Scenario identification.")
v(s,2,"medium","Justifying a binomial model",
"A quality inspector randomly selects 12 bulbs from a very large shipment, where each bulb is independently defective with probability 0.03. Let X be the number of defective bulbs. Which statement correctly justifies that X is binomial?",
("There are a fixed 12 trials, each with two outcomes, independent, with constant P(defective) = 0.03.","These match all binomial conditions."),
[("X is binomial because the defect probability is small.","Small p is not a condition; the four conditions are required.","Small p"),
("X is binomial because it takes whole-number values.","Many discrete variables take whole numbers without being binomial.","Discrete implies binomial"),
("X is binomial because the sample is large enough for X to be approximately normal.","12 bulbs with p = 0.03 is not large enough, and normality is not what makes X binomial.","Binomial and normal confusion")],
"Justify binomial.")
v(s,3,"hard","Why a count is not binomial",
"A teacher randomly picks 6 students one at a time, without replacement, from a class of 20 students (10 girls and 10 boys). Let X be the number of girls selected. Why is X not binomial?",
("Picking without replacement from a small class makes trials dependent, so P(girl) shifts.","After one girl is picked P(girl) is 9/19; after a boy 10/19."),
[("Each pick has more than two possible outcomes for the student chosen.","Each pick is a girl or a boy, two outcomes.","Misidentifying outcomes"),
("The number of picks is not fixed in advance by the teacher.","Exactly 6 students are picked.","Misidentifying fixed n"),
("The probability of selecting a girl, 0.5, is too large for a binomial model.","Binomials allow any p.","Restricting p")],
"Explains violation.")

s="APSTATS-MCQ-058"
v(s,1,"medium","Quadrupling a poll's sample size",
"A 90% confidence interval for a population proportion, based on a random sample of 400 voters, has a margin of error of 0.04. If the pollsters instead sampled 1600 voters, with the same confidence level and about the same sample proportion, what would the margin of error be approximately?",
("0.02","Quadrupling n halves the standard error (SE is proportional to 1/√n), so MOE = 0.04/2 = 0.02."),
[("0.01","Dividing 0.04 by 4 treats MOE as proportional to 1/n instead of 1/√n.","Dividing by the factor 4 instead of its square root"),
("0.08","Doubling 0.04 goes the wrong direction; a larger sample reduces SE and MOE.","Increasing MOE"),
("0.04","Sample size appears in SE = sqrt(p̂(1-p̂)/n), so MOE cannot stay at 0.04 when n changes from 400 to 1600.","Ignoring n")],
"Quantitative version.","numeric")
v(s,2,"medium","Raising confidence level",
"A poll of 500 randomly chosen adults gives a 90% confidence interval for a population proportion. If the pollster keeps the same data but reports a 99% confidence interval, what happens to the margin of error?",
("It gets larger, because the critical value z* increases from about 1.645 to about 2.576.","MOE = z*·SE and SE is unchanged."),
[("It gets smaller, because greater confidence means a more precise estimate.","Greater confidence widens the interval.","Confidence = precision"),
("It stays the same, because the standard error depends only on n and p̂.","z* changes with confidence level.","Ignoring z*"),
("It gets larger, because 99% confidence needs a larger sample.","The sample is unchanged; the increase comes from z*.","Wrong reason")],
"Confidence-level effect.")
v(s,3,"hard","Required sample size for a margin of error",
"A researcher wants a 95% confidence interval for a population proportion with a margin of error no larger than 0.03, and has no prior estimate of the proportion. Using z* = 1.96 and the most conservative p̂ = 0.5, what is the minimum sample size?",
("1068","n = (1.96)²(0.5)(0.5)/(0.03)² ≈ 1067.1, which must be rounded up to 1068."),
[("1067","Rounding down gives a margin of error slightly above 0.03.","Rounding down"),
("278","0.25/0.03² = 277.8 omits z*².","Omitting z*"),
("545","1.96(0.25)/0.03² = 544.4 forgets to square z*.","Not squaring z*")],
"Sample size computation.","numeric")

s="APSTATS-MCQ-063"
v(s,1,"easy","Power from a Type II error probability",
"A significance test of H0: p = 0.5 at α = 0.05 has a 0.32 probability of failing to reject H0 when the true proportion is 0.6. What is the power of the test against p = 0.6?",
("0.68","Power = 1 - β = 1 - 0.32 = 0.68."),
[("0.32","0.32 is β, the Type II error probability; power is its complement, 1 - 0.32 = 0.68.","Confusing β with power"),
("0.95","0.95 = 1 - α is the probability of correctly not rejecting a true H0, not power against p = 0.6.","Using confidence"),
("0.05","0.05 is the significance level (Type I error rate), unrelated to detecting the true value of 0.6.","Using α")],
"Context; power at specific alternative.","numeric")
v(s,2,"medium","What increases power",
"A researcher tests H0: p = 0.50 against Ha: p > 0.50 with n = 100 and α = 0.05. Which change would increase the power of the test against the true value p = 0.60?",
("Increasing the sample size to 400.","Quadrupling n from 100 to 400 halves the standard error of p-hat, so the sampling distributions under H0 and under p = 0.60 overlap less and rejection is more likely."),
[("Decreasing α to 0.01.","Lowering α from 0.05 to 0.01 moves the rejection cutoff farther from 0.50, making rejection harder even when p = 0.60, so power decreases while Type I risk falls.","Thinking lower α helps"),
("Testing against a true value closer to H0, such as 0.52.","A true value of 0.52 is only 0.02 above the null value 0.50, much harder to detect than a gap of 0.10, so power decreases.","Gap direction"),
("Decreasing the sample size to 25.","Cutting n from 100 to 25 doubles the standard error, so the sampling distributions overlap more and power decreases.","Smaller n helps")],
"Factors affecting power.")
v(s,3,"medium","Defining power",
"A pharmaceutical company tests H0: the new drug has no effect on blood pressure, against Ha: the drug lowers blood pressure. Which statement correctly describes the power of this test?",
("The probability of rejecting H0 when the drug really does lower blood pressure by a specific amount.","Power = P(reject H0 | the stated alternative is true) = 1 - β, here the chance the test detects a real blood-pressure reduction of the specified size."),
[("The probability of rejecting H0 when the drug has no effect.","Rejecting H0 when the drug has no effect (H0 true) is a Type I error, whose probability is α, not power.","Confusing with α"),
("The probability of failing to reject H0 when the drug does lower blood pressure.","Failing to reject H0 when the drug does lower blood pressure is a Type II error, whose probability is β = 1 - power.","Confusing with β"),
("The probability that the drug lowers blood pressure given that H0 was rejected.","This reverses the conditional: power is P(reject H0 | alternative true), not P(alternative true | H0 rejected).","Reversed conditional")],
"Conceptual definition.")

s="APSTATS-MCQ-074"
v(s,1,"hard","Which machine made a defective item",
"A plant has three machines. Machine A makes 50% of items with a 2% defect rate; Machine B makes 30% with a 3% defect rate; Machine C makes 20% with a 5% defect rate. A randomly selected item is defective. What is the probability it came from Machine B?",
("About 0.310","P(B | defective) = (0.30)(0.03) / (0.50(0.02) + 0.30(0.03) + 0.20(0.05)) = 0.009/0.029 ≈ 0.310."),
[("About 0.030","This is P(defective | B), the reverse of the requested conditional probability P(B | defective).","Reversing the conditional"),
("About 0.300","This is Machine B's 30% production share, ignoring the information that the item is defective; Machine B has a 3% rate vs 2% and 5% for others, so the probability changes.","Using the prior share"),
("About 0.009","This is the joint probability P(B and defective) = 0.30 x 0.03; it must be divided by P(defective) = 0.029.","Omitting the denominator")],
"Numeric Bayes.","numeric")
v(s,2,"medium","Formula for a reversed conditional probability",
"A school tracks whether students studied and whether they passed. Which expression correctly gives P(studied | passed)?",
("P(passed | studied)P(studied) / P(passed)","P(studied and passed)/P(passed), with the numerator rewritten via the multiplication rule."),
[("P(passed | studied)P(passed)","This multiplies by P(passed) rather than dividing by it; it is not P(studied | passed), and could even exceed 1.","Multiplying by the wrong marginal"),
("P(studied) / P(passed | studied)","The denominator should be the marginal P(passed) and the numerator should be P(passed | studied)P(studied); this inverts the structure.","Mixing up the roles of the terms"),
("P(studied)P(passed)","This is P(studied and passed) only if the events are independent, and it is not a conditional probability.","Using independence")],
"Formula recognition.")
v(s,3,"medium","Conditional probability from a table",
"A school surveyed 400 commuters, grouped by mode, and recorded who arrived late this month: Bus 160 (24 late), Bike 100 (15 late), Car 140 (11 late). Among all students who arrived late, what is the probability a randomly chosen late arrival is a bike rider?",
("0.30","P(bike | late) = 15/50 = 0.30."),
[("0.15","P(late | bike) = 15/100.","Reversing"),
("0.0375","P(bike and late) = 15/400.","Joint"),
("0.25","P(bike) = 100/400.","Marginal")],
"Table version.","numeric")

s="APSTATS-MCQ-081"
v(s,1,"easy","Expected prize",
"A raffle ticket pays $10 with probability 0.5, $20 with probability 0.3, and $30 with probability 0.2. What is the expected payout of a ticket?",
("$17","10(0.5)+20(0.3)+30(0.2)=5+6+6=17."),
[("$20","Unweighted mean of 10, 20, 30.","Unweighted"),
("$10","The most likely value.","Mode"),
("$60","Sum of the payouts.","Sum")],
"Payout context.","numeric")
v(s,2,"medium","Expected winnings of a game",
"In a carnival game, a player wins $5 with probability 0.1, wins $1 with probability 0.3, and loses $2 with probability 0.6. What is the expected net winnings per play?",
("-$0.40","5(0.1)+1(0.3)+(-2)(0.6)=0.5+0.3-1.2=-0.40."),
[("$1.33","Unweighted mean of 5, 1, -2.","Unweighted"),
("$0.40","Sign error.","Sign"),
("$2.00","Treats loss as +2.","Loss as gain")],
"Game with a loss.","numeric")
v(s,3,"medium","Mean with a missing probability",
"A random variable X takes values 0, 2, and 5 with P(X = 0) = 0.25 and P(X = 2) = 0.35. What is E(X)?",
("2.7","P(X=5)=0.40; E=0+0.7+2.0=2.7."),
[("2.33","Unweighted mean.","Unweighted"),
("0.7","Omits the 5 term.","Omitted"),
("5","Most likely value.","Mode")],
"Missing probability.","numeric")
json.dump(V,open("variants_b1.json","w"),indent=1,ensure_ascii=False)
print(len(V))
