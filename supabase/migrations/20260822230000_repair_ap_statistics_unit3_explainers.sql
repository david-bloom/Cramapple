begin;

-- Repair AP Statistics Unit 3 (Inference for Categorical Data: Proportions)
-- Learn More explainers -- all 15 were template-generated debt (core_idea
-- verbatim-matching their brief's what_it_is, and mini_example_question/
-- weak_answer/point_attaining_answer/practice_bridge shared boilerplate
-- duplicated across ~150 other rows corpus-wide, per the 2026-08-21 bulk
-- audit). Briefs for this unit are genuinely hand-authored and correct;
-- NOT touched here. This is the final AP Statistics batch: Units 1-2 are
-- already repaired, and this closes out AP Statistics' template-debt
-- backlog entirely.
--
-- Grounded in docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md Unit 3
-- section (starting line 225) plus the "General exam-wide conventions"
-- section (line 176) and the confirmed-removals list (line 148):
-- 3.1's derived fact that unbiasedness describes phat's sampling
-- distribution across repeated sampling (mu_phat=p, from 3.2), not any
-- one sample's distance from p; 3.2's explicit large-counts condition
-- np>=10/n(1-p)>=10 stated in terms of the true p, not an observed
-- sample's phat; 3.3's SE=sqrt(phat(1-phat)/n) and required-sample-size
-- formula (worst-case phat=0.5), plus the general convention that
-- proportions always use z, never t; 3.4's EK-3.4.A.2 repeated-sampling
-- long-run-capture-rate confidence-level interpretation, contrasted with
-- an invalid probability-about-this-interval statement; 3.5's documented
-- misconception of nonstandard hypothesis notation (H0: x=0.22 instead of
-- H0: p=0.22); 3.6's p-value definition as P(result this extreme | H0
-- true), contrasted with the documented p-value-as-P(H0 true)
-- misconception; 3.7's test-statistic and large-counts condition both
-- using p0 (not phat) under the radical, a documented authored-distractor
-- swap; 3.8's Type I/Type II error definitions requiring the conditional
-- framing (H0's true state stated together with the test's incorrect
-- conclusion), a documented CR-report-flagged omission; 3.9's four-value
-- large-counts condition for a difference of proportions (n1p1, n1(1-p1),
-- n2p2, n2(1-p2), all individually checked); 3.10's unpooled two-sample SE
-- formula, explicitly contrasted with the pooled test formula reserved for
-- 3.12-3.13; 3.11's derived fact that an interval containing 0 blocks a
-- directional claim regardless of how the interval's area is split; 3.12's
-- pooled-proportion formula phat_c=(n1phat1+n2phat2)/(n1+n2), valid only
-- because H0 assumes p1=p2; 3.13's pooled test statistic and pooled
-- large-counts condition, contrasted with 3.10's unpooled CI condition;
-- 3.14's homogeneity-vs-independence naming distinction (same statistic,
-- same expected-count formula) plus the confirmed CED removal of
-- chi-square goodness-of-fit (fact pack line 148-153); and 3.15's
-- expected-counts-condition threshold of >5, numerically distinct from
-- the >=10 large-counts threshold used for proportions/means elsewhere in
-- this course. All 15 topics had misconception or boundary data available
-- in the fact pack's Unit 3 section, so none required the structural/EK
-- fallback approach used for the thinner topics in Units 1-2.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Statistics Unit 3); the
-- pre-repair content is fully recoverable from git history for this
-- table's rows if a rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4
-- ("the same topic-specific answer_move" / "the same or refined
-- common_point_loss") -- the Unit 3 briefs already carry specific,
-- correct, non-templated point-earning language, so no refinement was
-- needed. mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge are original per-row text that was checked corpus-wide
-- before this migration was written and repeats nowhere else in the
-- published corpus. All computed numbers (standard errors, test
-- statistics, confidence intervals, pooled proportions, expected counts,
-- and chi-square values) were independently verified during authoring;
-- see the 3.2/3.7/3.9/3.10/3.13/3.15 mini-examples in particular, which
-- were deliberately constructed so an incorrect method (wrong p in a
-- large-counts check, unpooled vs. pooled SE, wrong expected-counts
-- threshold) produces a numerically different result from the correct
-- method, rather than merely a differently-worded but numerically
-- coincidental answer.

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('3.1',
   'phat is the point estimator of the population proportion p, and unbiasedness is a property of the sampling distribution of phat across every possible sample of size n, not a property of any single sample''s result -- an unbiased estimator''s sampling distribution has mean exactly equal to p (mu_phat = p, formalized in 3.2), even though almost every individual sample''s phat will land somewhat above or below p by chance.',
   'Because bias describes the estimator''s long-run behavior over repeated sampling, a single sample landing far from the true p is completely consistent with phat being unbiased -- what would make phat biased is a sampling method that systematically pulls results in one direction (for example, a convenience sample that over-represents one group), not ordinary sample-to-sample variability.',
   'Points require correctly naming phat as the estimator of the population parameter p, explaining unbiasedness in terms of the estimator''s average behavior across repeated sampling rather than any one sample''s result, and not mistaking sampling variability (a single result differing from p) for bias (a systematic direction to that difference).',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then identify the statistic as an estimator of a population parameter and explain unbiasedness as no systematic over- or underestimation before doing arithmetic or writing the final sentence.',
   'A citywide poll of n=50 randomly selected voters finds phat=0.58 support for a ballot measure. The true (but unknown to the pollster) population support is later revealed to be p=0.52. A student is asked whether this poll''s estimator was biased.',
   'Since the poll''s result of 0.58 doesn''t match the true value of 0.52, the estimator phat must be biased.',
   'phat is an unbiased estimator of p regardless of this one result, because unbiasedness describes the mean of phat''s sampling distribution across every possible random sample of size 50, which equals p=0.52 (mu_phat=p) -- not whether any single sample happens to land exactly on p. This particular sample''s phat=0.58 differing from p=0.52 by 0.06 reflects ordinary sampling variability, not bias; bias would require the sampling method itself to systematically favor one outcome.',
   'Calling one sample result biased just because it is not exactly equal to the parameter',
   'Open practice and, for any biased-vs-unbiased question, ask whether the described issue is about one sample''s distance from p (not bias) or the sampling method''s systematic direction (bias).'),
  ('3.2',
   'The sampling distribution of phat has mean mu_phat=p and standard deviation sigma_phat=sqrt(p(1-p)/n) (formula sheet), and its large-counts condition for approximate normality -- np>=10 and n(1-p)>=10 -- is defined using the true population proportion p, not the sample''s observed phat; later procedures substitute an estimate (phat for confidence intervals, p0 for tests) for p only because the real p is unknown, not because the underlying condition is stated in terms of an estimate.',
   'Three separate conditions have to hold before treating phat''s sampling distribution as approximately normal: independence (random sample, plus the 10% condition if sampling without replacement) and large counts -- and mixing up which value (true p, phat, or p0) belongs in the large-counts check is one of the most common setup errors across every proportion procedure that follows this topic.',
   'Points require stating mu_phat=p and sigma_phat=sqrt(p(1-p)/n) correctly, checking randomization and the 10% condition, and checking the large-counts condition with the correct value of p for the situation described -- using an observed sample''s phat when the question is about the sampling distribution''s theoretical shape is a documented setup error.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then state the mean and standard deviation of p-hat and check randomization, 10 percent, and large-counts conditions before doing arithmetic or writing the final sentence.',
   'A factory claims its defect rate is p=0.05. A quality inspector plans to sample n=150 items. A test sample turns up 15 defective items (phat=0.10). A student checks the large-counts condition using n(phat)=15 and n(1-phat)=135, both at least 10, and concludes the sampling distribution of phat is approximately normal.',
   'n(phat)=150(0.10)=15 and n(1-phat)=135, both at least 10, so the large-counts condition is satisfied and phat''s sampling distribution is approximately normal.',
   'The large-counts condition for the sampling distribution of phat uses the claimed/true proportion p=0.05, not an observed sample''s phat: n(p)=150(0.05)=7.5, which is less than 10, so the condition fails here. Using the observed phat=0.10 instead gives n(phat)=15, which would incorrectly appear to satisfy the condition -- but the sampling distribution''s theoretical shape depends on the population value p, not on any one sample''s estimate of it.',
   'Checking large counts with observed p-hat when the sampling distribution is built from the true p',
   'Head into practice and, before checking large counts on any sampling-distribution question, confirm whether the problem gives you a claimed/true p to use, rather than defaulting to a sample''s phat.'),
  ('3.3',
   'The one-sample interval phat ± z*·SE uses standard error SE=sqrt(phat(1-phat)/n), substituting the sample''s phat for the unknown true p -- a different quantity from 3.2''s theoretical sigma_phat=sqrt(p(1-p)/n) -- and this procedure always uses a z critical value, never t, because proportions have no t-based procedure in this course; t-distributions apply only to mean procedures, where sigma is unknown.',
   'Margin of error (z*·SE) is the amount added and subtracted from phat to build the interval, and the required-sample-size formula n=(z*)^2·phat(1-phat)/MOE^2 uses phat=0.5 as a worst-case placeholder whenever no prior estimate of phat is available, because phat(1-phat) is largest -- and therefore requires the biggest sample -- exactly at phat=0.5.',
   'Points require computing phat=x/n correctly, using SE=sqrt(phat(1-phat)/n) with the correct z* for the stated confidence level, verifying all three conditions (randomization, 10%, large counts using phat) before interpreting, and not substituting a t critical value from a means procedure.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then compute a one-proportion z interval with p-hat in the standard error and verify conditions before interpreting before doing arithmetic or writing the final sentence.',
   'A survey of n=200 randomly selected customers finds 124 who would recommend the product (phat=0.62). A student is asked to construct and interpret a 95% confidence interval for the true proportion p.',
   'Since SE was computed from sample data with 199 degrees of freedom, use a t* critical value: with t*≈1.972 and SE=sqrt(0.62×0.38/200)≈0.0343, the interval is 0.62 ± 1.972(0.0343) ≈ (0.552, 0.688).',
   'This is a one-sample proportion procedure, which always uses z*, never t* -- t-distributions apply only to mean procedures in this course, regardless of whether the standard error is estimated from sample data. With z*=1.96, phat=0.62, and SE=sqrt(0.62×0.38/200)≈0.0343, the interval is 0.62 ± 1.96(0.0343) ≈ (0.553, 0.687): we are 95% confident the true proportion of customers who would recommend the product is between 0.553 and 0.687.',
   'Using p0 from a test in the confidence-interval standard error',
   'Go to practice and, before choosing a critical value on any interval question, confirm whether the procedure is for a proportion (always z) or a mean (always t in this course).'),
  ('3.4',
   'The confidence level describes the long-run capture rate of the interval-construction method across repeated sampling (EK 3.4.A.2) -- roughly, ''if we repeated this sampling and interval process many times, about C% of the resulting intervals would contain the true p'' -- not a probability statement about this one already-computed interval, because the true p is a fixed number that either is or isn''t inside this specific interval.',
   'Deciding whether a claimed value of p is plausible only requires checking whether that value lies inside the already-built interval -- no new calculation is needed -- but the reasoning has to be phrased around the interval as a range of plausible values, never as a probability statement about the fixed parameter.',
   'Points require checking whether the claimed value lies inside the constructed interval, stating a plausibility conclusion tied to that check (not a probability that p is in the interval), and, when asked to interpret the confidence level itself, using the repeated-sampling capture-rate language rather than a probability statement about this one interval.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then decide whether a claimed parameter value is plausible by checking whether it lies inside the interval before doing arithmetic or writing the final sentence.',
   'A 90% confidence interval for the true proportion of defective items is (0.41, 0.53). A company claims its true defect proportion is 0.60. A student is asked to evaluate the claim and interpret the confidence level.',
   'Since there is a 90% probability the true proportion is between 0.41 and 0.53, and 0.60 falls outside that range, the company''s claimed defect proportion of 0.60 is essentially impossible.',
   'Because 0.60 falls outside the interval (0.41, 0.53), the interval gives convincing evidence against the company''s claimed value -- but this rests on 0.60 lying outside a range of plausible values, not on a probability statement about this one interval. The 90% confidence level means that if this sampling and interval-construction process were repeated many times, about 90% of the resulting intervals would capture the true (fixed) population proportion; it does not mean there is a 90% probability that this specific, already-computed interval contains p.',
   'Saying there is a certain probability the fixed parameter is inside this already-computed interval',
   'Return to practice and, on any confidence-level interpretation question, rewrite your answer around ''repeated sampling would capture p in about C% of intervals'' instead of a probability about this one interval.'),
  ('3.5',
   'A well-documented AP scoring pattern shows students writing hypotheses in nonstandard notation, such as H0: x=0.22 or H0: phat=0.22, instead of the required population-parameter form H0: p=0.22 -- hypotheses must always be stated about the fixed population proportion p, never about a sample count x or a sample statistic phat, which are random and vary from sample to sample.',
   'The direction of Ha has to match the research question''s wording exactly -- ''more than,'' ''greater than,'' or ''increased'' point to a one-sided Ha: p>p0; ''less than'' or ''decreased'' point to Ha: p<p0; ''different from,'' ''changed,'' or no directional wording at all point to the two-sided Ha: p≠p0 -- guessing the direction without matching the question''s actual language is a setup error even if every other part of the test is correct.',
   'Points require defining p in words with full population context, writing H0: p=p0 and Ha in the correct notation (never x or phat), and selecting a one- or two-sided Ha that matches the direction implied by the research question''s wording.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then define p in context, write H0 and Ha with p, and choose the correct one- or two-sided alternative before doing arithmetic or writing the final sentence.',
   'A researcher believes more than 30% of a company''s customers prefer a newly redesigned product (historical rate p0=0.30). A student is asked to set up the hypotheses for a test.',
   'H0: x=0.30, Ha: x>0.30, since the sample count of customers who prefer the new design should be compared to 30%.',
   'Let p = the true proportion of all the company''s customers who prefer the redesigned product. H0: p=0.30. Since the researcher''s belief is that MORE than 30% prefer it, this is a one-sided alternative: Ha: p>0.30. Writing hypotheses in terms of x (a sample count) or phat (a sample proportion) instead of the fixed population parameter p is a documented, frequently penalized notation error, even when the rest of the test is set up correctly.',
   'Writing hypotheses about x, p-hat, or sample counts instead of the population proportion p',
   'Head to practice and, before writing any hypothesis, underline the directional word in the question (more, less, different) and match it to Ha before writing a single symbol.'),
  ('3.6',
   'A p-value is the probability, computed assuming H0 is true, of getting a sample result at least as extreme as the one observed -- it is not the probability that H0 itself is true, since H0 is a fixed claim about the population, not a random event with its own probability; a small p-value means the observed result would be unusual if H0 were true, which is evidence against H0, not a probability attached to H0.',
   'The decision rule compares the p-value directly to the chosen significance level alpha: reject H0 if the p-value is less than alpha, and fail to reject H0 otherwise -- getting this comparison backwards, or treating a small p-value as proof H0 is false rather than evidence against it, both cost points even when the numeric p-value itself is computed correctly.',
   'Points require computing the p-value correctly from the test statistic, interpreting it in context as a conditional probability assuming H0 is true (never as the probability H0 is true), and correctly comparing it to alpha to reach a decision about H0.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then interpret the p-value as the chance of a result at least as extreme, assuming the null hypothesis is true before doing arithmetic or writing the final sentence.',
   'A one-proportion z-test comparing a sample result to a hypothesized p0=0.5 produces a p-value of 0.03, and the significance level was set at alpha=0.05.',
   'A p-value of 0.03 means there is a 3% chance the null hypothesis is true, so the null hypothesis is probably false.',
   'A p-value of 0.03 means: if H0 is actually true, there is a 3% chance of getting a sample result at least as extreme as the one observed, purely from sampling variability -- it says nothing about the probability that H0 itself is true or false. Since 0.03 is less than alpha=0.05, the result is statistically significant at the 5% level, giving convincing evidence against H0.',
   'Interpreting the p-value as the probability that the null hypothesis is true',
   'Back to practice: on every p-value interpretation, start the sentence with ''assuming H0 is true...'' -- if that phrase is missing, the interpretation is incomplete.'),
  ('3.7',
   'The one-proportion test statistic uses the null-hypothesized p0 under the radical, not the sample''s phat: z=(phat-p0)/sqrt(p0(1-p0)/n) -- and the large-counts condition for this procedure likewise uses p0 (np0>=10 and n(1-p0)>=10), unlike 3.3''s confidence-interval condition, which uses phat because no p0 exists in that context.',
   'The test statistic measures how far the observed phat is from p0, expressed in units of the standard error the sampling distribution WOULD have if H0 were exactly true -- which is why p0, not phat, belongs under the radical; substituting phat there answers a subtly different, unintended question and can produce a materially different z-value.',
   'Points require checking conditions using p0 (not phat), computing z=(phat-p0)/sqrt(p0(1-p0)/n) with p0 correctly placed under the radical, finding the p-value, and stating a conclusion in context using non-definitive language (''convincing evidence,'' never ''proves'').',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then check conditions with p0, compute the z statistic using p0 in the standard error, and make a contextual conclusion before doing arithmetic or writing the final sentence.',
   'A claim states p0=0.5. A random sample of n=100 finds 58 successes (phat=0.58). A student computes the test statistic for H0: p=0.5 vs Ha: p≠0.5.',
   'z = (phat-p0)/sqrt(phat(1-phat)/n) = 0.08/sqrt(0.58×0.42/100) ≈ 0.08/0.0494 ≈ 1.62.',
   'The test statistic''s standard error must use p0=0.5, the null-hypothesized value, not phat: sqrt(0.5×0.5/100)=0.05, giving z=(0.58-0.5)/0.05=1.6. This is a genuinely different value from using phat (1.62 vs. 1.6), because the test statistic measures the distance of phat from p0 in units of the standard error the sampling distribution would have under H0, not the standard error estimated from this one sample. With this z, there is not strong evidence against H0 at typical significance levels -- the data don''t give convincing evidence that p differs from 0.5.',
   'Putting p-hat under the radical in a one-proportion test statistic',
   'Return to practice and, on every test-statistic calculation, circle p0 in the problem before computing -- p0 belongs under the radical for a test, phat never does.'),
  ('3.8',
   'A Type I error requires both pieces stated together: H0 is actually true, AND the test incorrectly rejects it -- its probability equals alpha, the chosen significance level exactly, not merely ''small.'' A Type II error is the mirror case: H0 is actually false, AND the test fails to reject it; its probability is 1 minus the test''s power, and power increases with larger sample size, a bigger true-vs-null gap, or a larger alpha.',
   'Dropping the conditional framing -- stating only ''H0 is true'' without connecting it to what the test concludes, or vice versa -- is a documented, frequently penalized incompleteness, and confusing which error is which (defining Type I using Type II''s logic) is an equally common, exam-tested mistake.',
   'Points require defining Type I and Type II errors with both the true state of H0 and the test''s incorrect conclusion stated together in context, correctly relating the significance level alpha to the Type I error rate, and correctly describing how power changes with sample size, effect size, or alpha.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then define Type I and Type II errors with conditional framing and relate significance level to Type I error rate before doing arithmetic or writing the final sentence.',
   'A hypothesis test evaluates whether a new drug is more effective than a placebo (H0: the drug has no effect beyond placebo). The test rejects H0 and concludes the drug works.',
   'A Type I error here would be if the drug actually doesn''t work.',
   'A Type I error occurs if H0 is actually true (the drug has no effect beyond placebo) BUT the test incorrectly rejects H0 (concludes the drug works when it really doesn''t) -- both the true state and the wrong conclusion have to be stated together. Its probability equals alpha, the significance level chosen before the test. A Type II error would be the reverse: H0 is actually false (the drug really does work) but the test fails to reject H0 (misses the effect); its probability is 1 minus the test''s power, and power would improve with a larger sample size.',
   'Describing a Type I error without the phrase or idea that the null hypothesis is actually true',
   'Go to practice and, for every Type I/II error question, write out both halves of the definition explicitly -- the true state of H0, and what the test incorrectly concludes -- before choosing which error type applies.'),
  ('3.9',
   'The sampling distribution of phat1-phat2 has mean p1-p2 and standard deviation sqrt(p1(1-p1)/n1 + p2(1-p2)/n2) (formula sheet) -- and its large-counts condition requires checking all four separate values n1p1, n1(1-p1), n2p2, and n2(1-p2) individually, each needing to be at least 10; passing the check for one sample''s two values says nothing about the other sample''s.',
   'Because the two samples are independent of each other, the variance of the difference is the SUM of each sample''s own variance (p1(1-p1)/n1 + p2(1-p2)/n2), never a difference of variances -- and every one of the four large-counts values has to be checked, since a small second sample can fail the condition even when the first sample easily passes.',
   'Points require stating the center (p1-p2) and standard deviation of the sampling distribution correctly, checking randomization and the 10% condition for BOTH samples, and checking all four large-counts values (not just one sample''s pair) before treating the sampling distribution as approximately normal.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then state the center and standard deviation of p-hat1 minus p-hat2 and check conditions for both samples before doing arithmetic or writing the final sentence.',
   'Sample 1: n1=50 with claimed p1=0.4. Sample 2: n2=40 with claimed p2=0.15. A student checks the large-counts condition using only sample 1: n1p1=20 and n1(1-p1)=30, both at least 10, and concludes the condition is satisfied.',
   'n1p1=20 and n1(1-p1)=30 are both at least 10, so the large-counts condition for the difference in proportions is satisfied.',
   'The large-counts condition for a difference of two proportions requires checking all four values separately: n1p1=20, n1(1-p1)=30, n2p2=40(0.15)=6, and n2(1-p2)=34. Since n2p2=6 is less than 10, the condition fails overall -- checking only sample 1''s two values and ignoring sample 2''s two values is incomplete, even though sample 1 alone would pass on its own.',
   'Checking only one sample''s large-counts condition in a two-proportion setting',
   'Head into practice and, on every two-proportion large-counts check, write out all four values before concluding anything -- two samples means four numbers to check, not two.'),
  ('3.10',
   'The two-sample interval (phat1-phat2) ± z*·SE uses standard error sqrt(phat1(1-phat1)/n1 + phat2(1-phat2)/n2), built from each sample''s OWN phat separately -- never a pooled proportion. Pooling assumes p1=p2, which is exactly the claim a significance test evaluates; a confidence interval makes no such assumption, so pooling has no place in this formula.',
   'Because each sample keeps its own phat in this formula, the large-counts condition here also uses each sample''s own unpooled phat_i (as in 3.9), which is a different large-counts check from the pooled version used in the corresponding test (3.12-3.13) -- mixing up which proportion belongs in which procedure is the single most common error connecting these topics.',
   'Points require computing each sample''s phat separately, using the unpooled standard error formula, verifying conditions for both samples, and correctly interpreting the resulting interval as a range of plausible values for p1-p2.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then build an unpooled two-proportion z interval and interpret it as an interval for p1 minus p2 before doing arithmetic or writing the final sentence.',
   'Sample 1: n1=80, phat1=0.45. Sample 2: n2=100, phat2=0.30. A student is asked to construct a 95% confidence interval for the difference p1-p2, and pools the two proportions first.',
   'Pool the two sample proportions first: phat_c=(80×0.45+100×0.30)/180=(36+30)/180≈0.367, then use phat_c in the standard error for the interval.',
   'A confidence interval for p1-p2 must use each sample''s own proportion in the standard error separately: SE=sqrt(0.45×0.55/80 + 0.30×0.70/100)≈0.072, giving (0.45-0.30) ± 1.96(0.072) ≈ 0.15 ± 0.141, or (0.009, 0.291). Pooling assumes p1=p2, which is the claim a significance test evaluates, not an assumption a confidence interval makes -- pooling belongs only in the corresponding test''s standard error (3.12-3.13), never here.',
   'Pooling the sample proportions in a confidence interval, which is only for the corresponding test',
   'Go to practice and, before computing any two-proportion interval''s standard error, confirm you used each sample''s own phat separately -- if you pooled first, that''s the significance-test formula, not this one.'),
  ('3.11',
   'If the interval for p1-p2 excludes 0, that is convincing evidence of a real difference between the two population proportions; if the interval contains 0, that is insufficient evidence of a difference -- because 0 (meaning p1=p2, no difference) remains a plausible value for p1-p2, even when most of the interval sits on one side of 0.',
   'An interval that is mostly positive but still contains 0 does not support a directional claim -- the conclusion has to be about whether 0 is inside or outside the interval, not about which side of the interval has more area, since a plausible value of exactly 0 is still enough to block a claim of difference.',
   'Points require correctly checking whether 0 lies inside the constructed interval, stating a conclusion about the existence (not necessarily the direction) of a difference tied to that check, and avoiding a directional claim when the interval still contains 0.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then use whether zero is inside the interval to support or reject a claim of difference before doing arithmetic or writing the final sentence.',
   'A 95% confidence interval for the difference in success rates between a new treatment and a control (treatment minus control) is (-0.05, 0.18).',
   'Since the interval is mostly positive, running from -0.05 to 0.18, the new treatment has a higher success rate than the control.',
   'Because the interval (-0.05, 0.18) contains 0, this is not convincing evidence of a difference between the treatment and control success rates -- 0 (no difference) remains a plausible value for p1-p2. The interval being mostly positive doesn''t override this: as long as 0 falls inside the interval, the data don''t rule out p1=p2, so no directional claim that the treatment is more effective can be made from this interval.',
   'Concluding one group is larger when the interval includes zero',
   'Return to practice and, on every two-proportion interval question, check only one thing first -- is 0 inside or outside the interval -- before considering how the interval is split between positive and negative values.'),
  ('3.12',
   'Because H0 assumes p1=p2, the test statistic''s standard error uses one pooled estimate phat_c=(n1phat1+n2phat2)/(n1+n2), built from both samples combined, since under H0 there is really only a single common p to estimate -- unlike 3.10''s confidence interval, which never pools because it makes no such assumption.',
   'Defining exactly which population is p1 and which is p2 in words, before writing any symbols, is what keeps the sign of the alternative hypothesis unambiguous -- Ha: p1>p2 and Ha: p2>p1 describe opposite claims, and without a stated definition of p1 and p2 a grader cannot tell which direction the alternative actually claims.',
   'Points require defining both p1 and p2 in words with population context, writing H0: p1=p2 (or p1-p2=0), choosing Ha''s direction to match the research question, and identifying that the standard error for the test uses the pooled proportion phat_c rather than each sample''s own phat_i.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then define both population proportions, write hypotheses for p1 minus p2, and identify the pooled proportion for the null model before doing arithmetic or writing the final sentence.',
   'A study compares the proportion of grade 9 students (p1) and grade 12 students (p2) who report using a specific study app. A student writes hypotheses without defining p1 and p2 in words.',
   'H0: p1=p2, Ha: p1≠p2.',
   'Let p1 = the true proportion of all grade 9 students at this school who use the study app, and p2 = the true proportion of all grade 12 students who use it. H0: p1=p2 (equivalently, p1-p2=0); Ha: p1≠p2, two-sided since no direction was specified. Because H0 assumes the two population proportions are equal, the test''s standard error uses one pooled estimate phat_c=(n1phat1+n2phat2)/(n1+n2) built from both samples combined -- unlike the confidence interval in 3.10, which never pools because it doesn''t assume p1=p2.',
   'Forgetting to define which population is p1 and which is p2, making the sign of the alternative unclear',
   'Head to practice and, before writing any two-proportion hypotheses, write one full sentence defining p1 and one full sentence defining p2 -- the sign of Ha only makes sense once both are pinned down.'),
  ('3.13',
   'The pooled test statistic z=[(phat1-phat2)-0]/sqrt(phat_c(1-phat_c)(1/n1+1/n2)) uses the pooled proportion phat_c under the radical, and the large-counts condition here likewise uses pooled counts (n1phat_c, n1(1-phat_c), n2phat_c, n2(1-phat_c), all at least 10) -- a genuinely different, pooled condition from 3.10''s unpooled confidence-interval condition.',
   'Using the confidence interval''s unpooled standard error formula in a significance test produces a numerically different, generally incorrect z-value -- the two formulas aren''t interchangeable even though they look similar, because the test''s pooled formula reflects the H0 assumption that p1=p2, which the CI never assumes.',
   'Points require computing the pooled proportion phat_c correctly, using it (not each sample''s own phat_i) in both the large-counts check and the test statistic''s standard error, computing z correctly, and concluding in context using non-definitive language.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then check two-sample conditions with the pooled proportion, compute z, and conclude in context before doing arithmetic or writing the final sentence.',
   'Sample 1: n1=60, phat1=0.50 (30 successes). Sample 2: n2=50, phat2=0.30 (15 successes). A student tests H0: p1=p2 vs Ha: p1≠p2 using the unpooled standard error.',
   'SE = sqrt(phat1(1-phat1)/n1 + phat2(1-phat2)/n2) = sqrt(0.50×0.50/60 + 0.30×0.70/50) ≈ 0.0915, so z=(0.50-0.30)/0.0915 ≈ 2.19.',
   'For a significance test, the standard error must use the pooled proportion, since H0 assumes p1=p2: phat_c=(30+15)/110≈0.409. SE=sqrt(0.409×0.591×(1/60+1/50))≈0.0942, giving z=(0.50-0.30)/0.0942≈2.12. Using each sample''s own unpooled phat_i, as in the confidence-interval formula, is the wrong standard error for a test and produces a different, inflated z-value (2.19 instead of 2.12) here.',
   'Using the unpooled confidence-interval standard error in a two-proportion significance test',
   'Go to practice and, before computing any two-proportion test statistic, compute phat_c first -- if your standard-error formula never uses phat_c, you''ve built the confidence-interval formula instead of the test''s.'),
  ('3.14',
   'Homogeneity (the same categorical variable measured across multiple populations or treatment groups) and independence (two categorical variables measured within one population) are a naming distinction only -- both use the identical chi-square statistic and identical expected-count formula, expected count = (row total)(column total)/table total; chi-square goodness-of-fit, which compares one sample to a fixed claimed distribution, was removed from the current AP Statistics course and is not tested.',
   'Telling homogeneity and independence apart requires identifying the study design, not the data table''s shape -- multiple separate samples (one per population or treatment group) point to homogeneity, while one single sample cross-classified by two categorical variables points to independence; both then use df=(rows-1)(columns-1).',
   'Points require correctly identifying homogeneity vs. independence from the study design described, computing expected counts using the row-total-times-column-total-over-table-total formula, setting df=(rows-1)(columns-1), and not defaulting to a goodness-of-fit setup, which is outside this course''s current scope.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then choose homogeneity or independence from the study design, compute expected counts, and set df from the table dimensions before doing arithmetic or writing the final sentence.',
   'A study samples students separately from three different high schools (three independent samples) and records each student''s favorite music genre, to compare whether the distribution of favorite genres differs across the three schools.',
   'Set up a chi-square goodness-of-fit test to check whether genre preference differs across the three schools.',
   'This is a chi-square test for homogeneity, not goodness-of-fit -- goodness-of-fit compares one sample to a fixed claimed distribution and was removed from the current course. Here, three separate samples (one per school) are compared on the same categorical variable (genre preference), which is exactly the homogeneity setup. Expected count for each cell = (row total)(column total)/table total, and df=(rows-1)(columns-1) based on the resulting table''s dimensions.',
   'Using a goodness-of-fit test when the current Unit 3 scope only includes homogeneity and independence',
   'Return to practice and, before naming any chi-square procedure, ask how many separate samples were drawn -- one sample with two variables is independence, multiple samples is homogeneity, and neither is goodness-of-fit.'),
  ('3.15',
   'The chi-square statistic sums (observed-expected)^2/expected across every cell of the table, and its expected-counts condition requires every expected count to exceed 5 -- a numerically different, lower threshold than the value-of-10 large-counts condition used for proportion and mean procedures elsewhere in this course; applying the 10-threshold here is a documented cross-topic confusion.',
   'A chi-square test can still be valid even when some expected counts sit between 5 and 10 -- checking against the wrong (10) threshold could incorrectly disqualify a perfectly usable table, so getting the correct threshold (5) right matters before any chi-square value gets computed at all.',
   'Points require checking the expected-counts condition against the correct threshold of 5 (not 10), computing chi-square = sum((observed-expected)^2/expected) across all cells correctly, setting df=(rows-1)(columns-1), and interpreting the resulting p-value for the association or homogeneity question in context.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then calculate chi-square contributions from observed and expected counts and interpret the p-value for the categorical association question before doing arithmetic or writing the final sentence.',
   'A 2×2 table has row totals 30 and 70, column totals 20 and 80, and observed counts 8, 22, 12, and 58 filling the four cells (matching those totals). A student computes expected counts of 6, 24, 14, and 56, and checks the expected-counts condition.',
   'The smallest expected count is 6, which is less than 10, so the expected-counts condition fails and a chi-square test should not be run on this table.',
   'The chi-square expected-counts condition requires all expected counts to exceed 5, not 10 -- the 10-count threshold is the large-counts condition used for proportions and means, a different procedure with a numerically distinct threshold. Here, all four expected counts (6, 24, 14, 56) exceed 5, so the condition is satisfied and the test may proceed: chi-square = (8-6)^2/6 + (22-24)^2/24 + (12-14)^2/14 + (58-56)^2/56 ≈ 1.19, with df=(2-1)(2-1)=1.',
   'Checking expected counts against 10 instead of the chi-square threshold that all expected counts exceed 5',
   'Head back to practice and, on every chi-square expected-counts check, compare against 5, not 10 -- that mix-up is one of the most common cross-topic errors in this unit.')
)
update app.topic_explainers e
set
  core_idea = u.core_idea,
  what_students_need_to_understand = u.what_students_need_to_understand,
  how_this_becomes_points = u.how_this_becomes_points,
  answer_move = u.answer_move,
  mini_example_question = u.mini_example_question,
  weak_answer = u.weak_answer,
  point_attaining_answer = u.point_attaining_answer,
  common_point_loss = u.common_point_loss,
  practice_bridge = u.practice_bridge,
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_STATISTICS_2027_CED_FACT_PACK.md Unit 3 section (line 225) and the general exam-wide-conventions section (line 176): the derived mu_phat=p sampling-distribution fact for 3.1; the true-p-vs-observed-phat large-counts distinction for 3.2; the phat-based SE/required-sample-size formula and the proportions-always-z convention for 3.3; the EK 3.4.A.2 repeated-sampling capture-rate confidence-level interpretation for 3.4; the 2025 CR Report''s documented nonstandard-hypothesis-notation misconception for 3.5; the p-value-vs-P(H0 true) distinction for 3.6; the p0-under-the-radical test-statistic and condition distinction for 3.7; the conditional-framing requirement for Type I/II error definitions for 3.8; the four-value large-counts condition for a difference of proportions for 3.9; the unpooled two-sample CI standard-error formula for 3.10; the interval-contains-zero-blocks-a-directional-claim fact for 3.11; the pooled-proportion formula valid only under H0''s p1=p2 assumption for 3.12; the pooled test statistic and pooled large-counts condition for 3.13; the homogeneity-vs-independence naming distinction plus the CED''s confirmed removal of chi-square goodness-of-fit for 3.14; and the expected-counts->5 threshold (numerically distinct from the >=10 large-counts threshold) for 3.15; briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-statistics-unit3-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_statistics'
  and e.unit_number = 3
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_statistics' and unit_number=3 and status='published'
      and source_note like '%unit3-explainer-repair%';
  if v_repaired <> 15 then
    raise exception 'expected 15 repaired AP Statistics Unit 3 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_statistics' and b.unit_number=3 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Statistics Unit 3 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
