begin;

-- Seed AP Statistics Unit 4 (Inference for Quantitative Data: Means)
-- topic point briefs and Learn More explainers -- first coverage for this
-- unit (0/10 published before this migration).
--
-- Authored under the revised protocol at
-- docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md: grounded
-- in docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md Sec3 (topic map) and
-- Sec10 (Unit 4 deep-tier detail: formulas, df rules, and CR-report-documented
-- misconceptions for t vs z, matched pairs vs two-sample, non-pooled df, and
-- non-definitive conclusion language).
--
-- CAVEAT (stated in the batch note per protocol Sec9 acknowledgement of the
-- current reviewer-independence gap): the fact pack's own Sec3 and Sec10 are
-- marked UNREVIEWED pending Jill/Orly subject-matter-expert sign-off. Content
-- here is faithful to the fact pack as written, but the fact pack itself has
-- not cleared SME review. Author and reviewer are the same session; there is
-- no independent human review of this batch.
--
-- Every explainer is genuinely topic-specific (not generated-from-brief):
-- core_idea differs from the paired brief's what_it_is on every row, and no
-- mini_example_question / weak_answer / point_attaining_answer / practice_bridge
-- value repeats across the batch (verified programmatically before migration).
--
-- This is a pure insert -- no existing rows are touched, so rollback is simply
-- deleting these 10 (subject_key='ap_statistics', unit_number=4) rows or
-- setting their status back to 'draft'.

with brief_seed (
  topic_code, title, class_importance, exam_importance, what_it_is,
  why_it_matters, how_points_are_earned, answer_move, common_point_loss,
  learn_more_path
) as (
  values
  ('4.1','Sampling Distributions for Sample Means','very-important','very-important',
   'The sampling distribution of the sample mean x-bar describes how x-bar would vary if you repeated the same random sample of size n over and over. Its center is mu, and its spread is sigma/sqrt(n), but its shape depends on the population and on n.',
   'Every confidence interval and test for a mean in this unit rests on describing this sampling distribution correctly. Get the shape justification wrong here and every later inference step inherits the error.',
   'You earn points by stating mu-x-bar = mu and sigma-x-bar = sigma/sqrt(n) with the right symbols, and by justifying shape separately from center and spread: exactly normal only if the population is normal, approximately normal from the Central Limit Theorem only when n is large enough.',
   'Report center and spread using the formulas, then justify shape on its own line: population known normal -> x-bar is exactly normal for any n; population shape unknown or skewed -> invoke n >= 30 (more for strong skew) for approximate normality, not before.',
   'Treating ''n is large'' as making the population itself normal, rather than making the sampling distribution of x-bar approximately normal.',
   '/learn/ap-statistics/unit-4/sampling-distributions-for-sample-means'),
  ('4.2','Constructing a Confidence Interval for a Population Mean or Mean Difference','very-important','very-important',
   'A one-sample t-interval estimates a population mean mu (or a population mean difference mu-d from matched pairs) as x-bar +/- t*(s/sqrt(n)), using a t-distribution with df = n - 1 because sigma is unknown.',
   'This is the standard tool whenever you have one quantitative sample, or paired before/after data reduced to differences, and need a range of plausible values for the true mean.',
   'You earn points by naming the t-procedure (not z, since sigma is unknown), checking all three conditions (random, 10%, and normal/large-n/no strong skew or outliers), then computing x-bar +/- t*(s/sqrt(n)) with the correct df = n - 1.',
   'State t not z because sigma is unknown, check randomization, then 10%, then the sample-data condition in that order, then substitute into x-bar +/- t*(s/sqrt(n)) with df = n - 1. For matched pairs, run this same one-sample procedure on the differences, not on the two original samples separately.',
   'Running a two-sample procedure on matched-pairs data instead of first reducing it to one column of differences and using the one-sample t-interval on those differences.',
   '/learn/ap-statistics/unit-4/confidence-interval-for-a-population-mean-or-mean-difference'),
  ('4.3','Justifying a Claim Based on a Confidence Interval for a Population Mean or Mean Difference','very-important','somewhat-important',
   'Once you have a confidence interval for mu or mu-d, this topic is about using the interval itself -- not a new calculation -- to decide whether a claimed value is plausible and to state that decision in context.',
   'Free-response scoring gives a separate point for the interpretation and claim beyond the arithmetic, so a perfect interval with no justification, or a justification that recomputes rather than reads the interval, both lose points.',
   'You earn the point by checking whether the claimed value falls inside or outside the interval you already built, then writing a conclusion in context using non-definitive language rather than a flat ''proves'' or ''is'' statement.',
   'Locate the claimed value against your interval''s two endpoints, then write: because [value] is/is not contained in the interval, there is convincing evidence that... naming the parameter and the population, never ''proves'' or ''is''.',
   'Recomputing a new statistic or running a hidden hypothesis test instead of simply checking whether the claimed value lies inside the already-built interval.',
   '/learn/ap-statistics/unit-4/justifying-a-claim-from-a-confidence-interval-for-a-mean'),
  ('4.4','Setting Up a Test for a Population Mean or Mean Difference','very-important','very-important',
   'Setting up a one-sample t-test for mu or mu-d means stating hypotheses in symbols (H0: mu = mu-0, Ha with the correct direction), identifying the correct procedure, and checking the same three conditions used for the matching interval.',
   'A test that is set up on the wrong hypotheses, the wrong procedure, or unchecked conditions cannot earn later points for the calculation or conclusion, even if those steps are done correctly.',
   'You earn points by writing H0 and Ha in terms of mu (or mu-d) with correct symbols and direction, naming the one-sample t-test because sigma is unknown, and checking randomization, 10%, and sample-data conditions before calculating.',
   'Write H0: mu = mu-0 and Ha with the direction matching the research question, state the test as a one-sample t-test (never z, since sigma is unknown), then check conditions in the fixed order before any arithmetic.',
   'Stating hypotheses about the sample mean x-bar instead of the population parameter mu, or choosing z instead of t because sigma was never actually given.',
   '/learn/ap-statistics/unit-4/setting-up-a-test-for-a-population-mean-or-mean-difference'),
  ('4.5','Carrying Out a Test for a Population Mean or Mean Difference','very-important','very-important',
   'Carrying out the one-sample t-test means computing t = (x-bar - mu-0)/(s/sqrt(n)) with df = n - 1, finding or bounding the p-value, and writing a conclusion in context using non-definitive language tied to the original hypotheses.',
   'This is where the arithmetic, the p-value comparison to alpha, and the final sentence all have to connect back to the exact hypotheses set up earlier -- a disconnected conclusion loses points even with correct numbers.',
   'You earn points by computing the test statistic and df correctly, comparing the p-value to a stated significance level, and writing a conclusion that names the parameter and population using non-definitive language such as convincing evidence to suggest, never prove or is.',
   'Compute t = (x-bar - mu-0)/(s/sqrt(n)), df = n - 1; compare the resulting p-value to alpha; then conclude in context: reject or fail to reject H0, and phrase the real-world conclusion as evidence for or against Ha, never as certainty.',
   'Concluding we have proven or stating the parameter is a certain value, instead of phrasing the conclusion as convincing evidence in the direction of Ha.',
   '/learn/ap-statistics/unit-4/carrying-out-a-test-for-a-population-mean-or-mean-difference'),
  ('4.6','Sampling Distributions for the Difference Between Two Sample Means','very-important','very-important',
   'For two independent samples, x-bar-1 minus x-bar-2 has sampling distribution centered at mu-1 minus mu-2, with SD sqrt(sigma-1-squared/n1 + sigma-2-squared/n2); it is approximately normal when both populations are normal or both n''s are at least 30.',
   'Every interval and test comparing two population means in this unit relies on describing this two-sample sampling distribution correctly before any calculation.',
   'You earn points by stating the center mu-1 minus mu-2 and the combined-variance spread formula correctly, and by justifying shape using both populations or both sample sizes, not just one of the two samples.',
   'State center as mu-1 minus mu-2, spread as sqrt(sigma-1-squared/n1 + sigma-2-squared/n2), then justify shape by checking both populations for normality or both n1 and n2 for the n >= 30 guideline -- a single sample meeting the condition is not enough.',
   'Checking the shape condition for only one of the two samples and treating that as sufficient for the whole difference''s sampling distribution.',
   '/learn/ap-statistics/unit-4/sampling-distributions-for-the-difference-between-two-sample-means'),
  ('4.7','Constructing a Confidence Interval for the Difference Between Two Population Means','very-important','very-important',
   'The two-sample t-interval estimates mu-1 minus mu-2 as (x-bar-1 - x-bar-2) +/- t*sqrt(s1-squared/n1 + s2-squared/n2), with degrees of freedom found by technology rather than the simpler pooled n1 + n2 - 2 formula some other courses use.',
   'This is the standard tool for comparing two independent group means, and its df rule is a specific, frequently mis-remembered detail that differs from the pooled two-sample formula taught elsewhere.',
   'You earn points by using the unpooled standard error sqrt(s1-squared/n1 + s2-squared/n2), citing a technology-based or conservative df rather than n1 + n2 - 2, and checking conditions on both samples independently.',
   'Use SE = sqrt(s1-squared/n1 + s2-squared/n2), state that df is found by technology (falling between n1 + n2 - 2 and the smaller of n1 - 1, n2 - 1) rather than defaulting to the pooled formula, and check both samples'' conditions separately.',
   'Defaulting to the pooled df = n1 + n2 - 2 formula from other courses instead of this course''s non-pooled, technology-based df rule.',
   '/learn/ap-statistics/unit-4/confidence-interval-for-the-difference-between-two-population-means'),
  ('4.8','Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Means','somewhat-important','somewhat-important',
   'Given a confidence interval for mu-1 minus mu-2, this topic is about reading whether zero (no difference) or another claimed value falls inside the interval, and stating the conclusion about the two populations in context.',
   'Whether zero falls inside a difference interval is the standard way to decide if two population means are convincingly different, and this decision has to be stated without overclaiming certainty.',
   'You earn the point by checking whether zero (or the claimed difference) lies inside your interval''s endpoints, then writing a conclusion about both populations using non-definitive language.',
   'Check whether zero is inside or outside the interval for mu-1 minus mu-2; if zero is excluded, there is convincing evidence the means differ (and the sign of the interval tells you which population is larger); if zero is included, there is not convincing evidence of a difference.',
   'Concluding the means are different just because x-bar-1 does not equal x-bar-2, without checking whether zero actually falls outside the confidence interval.',
   '/learn/ap-statistics/unit-4/justifying-a-claim-from-a-confidence-interval-for-the-difference-between-two-means'),
  ('4.9','Setting Up a Test for the Difference Between Two Population Means','very-important','very-important',
   'Setting up a two-sample t-test means stating H0: mu-1 minus mu-2 = 0 (or mu-1 = mu-2) with the correctly directed Ha, identifying the two-sample t-test, and checking conditions on both independent samples.',
   'As with the one-sample setup, an error in hypotheses, procedure choice, or unchecked conditions blocks credit for every later step even when the calculation itself is done correctly.',
   'You earn points by writing H0 and Ha in terms of mu-1 minus mu-2 with correct direction, naming the two-sample t-test, and checking randomization or random assignment, the 10% condition, and the shape condition for both samples.',
   'Write H0: mu-1 minus mu-2 = 0, Ha with direction from the research question, name the procedure as a two-sample t-test, then check both samples'' conditions separately before calculating.',
   'Writing hypotheses about x-bar-1 minus x-bar-2 instead of mu-1 minus mu-2, or checking conditions for only one of the two independent samples.',
   '/learn/ap-statistics/unit-4/setting-up-a-test-for-the-difference-between-two-population-means'),
  ('4.10','Carrying Out a Test for the Difference Between Two Population Means','very-important','very-important',
   'Carrying out the two-sample t-test means computing t = (x-bar-1 - x-bar-2)/sqrt(s1-squared/n1 + s2-squared/n2) with the same technology-based (non-pooled) df used for the matching interval, then concluding in context with non-definitive language.',
   'This closes out the unit''s inference sequence: the numeric result, the p-value comparison, and the final sentence must all connect back to the exact two-sample hypotheses set up earlier.',
   'You earn points by computing the test statistic and citing the correct df source, comparing the p-value to alpha, and writing a conclusion naming both populations and using non-definitive, evidence-based language.',
   'Compute t = (x-bar-1 - x-bar-2)/sqrt(s1-squared/n1 + s2-squared/n2); compare the resulting p-value to alpha; conclude in context naming both populations, phrased as convincing evidence for or against Ha, never as proof.',
   'Stating the conclusion as if the test proved which population mean is truly larger, instead of framing it as convincing evidence in the direction of Ha.',
   '/learn/ap-statistics/unit-4/carrying-out-a-test-for-the-difference-between-two-population-means')
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, practice_subject_key, practice_unit_number,
  practice_topic_code, source_note, status, published_at
)
select
  'ap_statistics', 4, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, 'ap_statistics', 4, topic_code,
  'cramapple-authored; grounded in AP_STATISTICS_2027_CED_FACT_PACK.md Sec3 topic map + Sec10 Unit 4 deep-tier detail (both sections UNREVIEWED pending Jill/Orly SME sign-off, per the fact pack''s own Sec9 note); batch 2026-08-21-ap-statistics-unit4; author=reviewer same session, no independent human review yet', 'published', now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  title = excluded.title,
  class_importance = excluded.class_importance,
  exam_importance = excluded.exam_importance,
  what_it_is = excluded.what_it_is,
  why_it_matters = excluded.why_it_matters,
  how_points_are_earned = excluded.how_points_are_earned,
  answer_move = excluded.answer_move,
  common_point_loss = excluded.common_point_loss,
  learn_more_path = excluded.learn_more_path,
  practice_subject_key = excluded.practice_subject_key,
  practice_unit_number = excluded.practice_unit_number,
  practice_topic_code = excluded.practice_topic_code,
  source_note = excluded.source_note,
  status = excluded.status,
  published_at = excluded.published_at;

with explainer_seed (
  topic_code, title, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('4.1','Sampling Distributions for Sample Means',
   'x-bar is a random variable with its own distribution across samples, not a fixed number. Center mu-x-bar = mu and spread sigma-x-bar = sigma/sqrt(n) hold regardless of shape; only the shape claim depends on whether the population is normal or n is large.',
   'The Central Limit Theorem is a claim about shape only, and it is conditional on n, not automatic. A skewed population needs a larger n before x-bar''s sampling distribution looks normal; a normal population needs no minimum n at all.',
   'A rubric component asks for center, a second for spread, and a third for shape justification stated as its own claim tied to n or to the population''s known shape -- three separate things to state, not one blended sentence.',
   'Separate the three claims: center (mu-x-bar = mu), spread (sigma-x-bar = sigma/sqrt(n)), and shape (normal population -> exact; else n >= 30 -> approximate).',
   'A shipping company''s package weights are strongly right-skewed with mu = 8 lb. A sample of n = 25 packages is weighed. Is it valid to treat x-bar as approximately normal?',
   'Yes, because n is a decent-sized sample so the average should be normal.',
   'No. Because the population is strongly skewed and n = 25 is below the n >= 30 guideline used for skewed populations, the sampling distribution of x-bar cannot be assumed approximately normal here; a larger sample would be needed.',
   'Treating ''n is large'' as making the population itself normal, rather than making the sampling distribution of x-bar approximately normal.',
   'Practice a few problems that give you a population shape and a sample size, and force yourself to write center, spread, and shape as three separate lines before you calculate anything.'),
  ('4.2','Constructing a Confidence Interval for a Population Mean or Mean Difference',
   'The t-interval borrows the same structure as a z-interval (statistic +/- critical value times standard error) but swaps in the t-distribution because s replaces the unknown sigma, which adds extra uncertainty the wider, flatter t-curve accounts for.',
   'Matched-pairs data is not two-sample data. Subtracting each pair down to one list of differences turns a two-variable problem into a one-sample t-interval on mu-d, with its own condition check applied to the differences, not to the original two columns.',
   'Full credit needs the correct symbol (t, not z), df = n - 1 stated explicitly, all three conditions checked in the fixed order, and the interval computed with the right standard error (s/sqrt(n)) substituted into the formula.',
   'Decide one-sample, matched-pairs, or two-sample first, in one sentence. For matched pairs, reduce to a single list of differences before applying the one-sample t formula.',
   'Ten runners'' resting heart rates were measured before and after eight weeks of training. A researcher wants a 95% interval for the mean change. What procedure applies, and why?',
   'A two-sample t-interval, since there are two measurements per runner.',
   'A one-sample t-interval on the ten before/after differences, because each pair comes from the same runner (matched pairs); reducing to one list of differences and finding x-bar-d +/- t*(s-d/sqrt(10)) with df = 9 is correct, not comparing the two original samples independently.',
   'Running a two-sample procedure on matched-pairs data instead of first reducing it to one column of differences and using the one-sample t-interval on those differences.',
   'Before you touch a formula, decide in one sentence whether your data is one sample, matched pairs (reduce to differences), or two independent samples -- that sentence decides which of Unit 4''s five formulas you need.'),
  ('4.3','Justifying a Claim Based on a Confidence Interval for a Population Mean or Mean Difference',
   'A confidence interval already contains every decision you need -- justifying a claim from it is a reading exercise, not a new computation, and the scoring rewards that reading being explicit and stated in context.',
   'The word justify here means point to the interval''s endpoints and compare, then translate that comparison into a sentence about the population parameter -- skipping straight to yes or no without showing the comparison loses the justification point even if the calculation was right.',
   'The rubric separates interval built correctly from claim justified from the interval, so students who nail the arithmetic but write so the claim is true instead of a non-definitive, context-specific sentence still lose the second point.',
   'Compare the claimed value to the interval''s two endpoints first, then write one sentence naming the parameter and population using convincing evidence language, never proof language.',
   'A 95% confidence interval for the mean caffeine content of a coffee brand is (78, 94) mg. A quality claim states the mean is 85 mg. Is this claim supported?',
   'Yes, the claim is proven true because 85 is a reasonable number.',
   'Because 85 mg falls inside the interval (78, 94), the interval is consistent with -- not proof of -- the claimed mean; there is no evidence against a true mean caffeine content of 85 mg for this brand.',
   'Recomputing a new statistic or running a hidden hypothesis test instead of simply checking whether the claimed value lies inside the already-built interval.',
   'Practice interpreting intervals you''re handed, without recomputing anything, and force every conclusion sentence to include the word evidence rather than proof.'),
  ('4.4','Setting Up a Test for a Population Mean or Mean Difference',
   'Setup is where a test lives or dies: the hypotheses must be about the unknown parameter, not the known sample statistic, and the procedure choice (t here, always) must be justified by the fact that sigma is unknown rather than assumed.',
   'Ha''s direction comes from the research question''s wording (greater than, less than, different from), and must be decided before seeing the data -- choosing direction after calculating the test statistic is exactly the kind of reasoning error the rubric checks for.',
   'Separate scoring components exist for hypotheses stated in correct parameter notation, for procedure identification with justification, and for conditions checked in order -- a student can lose one of the three even with a perfect final numeric answer.',
   'Write hypotheses in parameter notation first, decide direction from the research question''s wording before seeing any data, then name and justify the procedure.',
   'A cereal box is labeled as containing 350 g. A quality inspector suspects boxes are underfilled on average. Set up the hypotheses and identify the correct test.',
   'H0: x-bar = 350, Ha: x-bar < 350, using a z-test.',
   'H0: mu = 350, Ha: mu < 350, where mu is the true mean fill weight of all boxes; a one-sample t-test applies because the population standard deviation is unknown and must be estimated from the sample.',
   'Stating hypotheses about the sample mean x-bar instead of the population parameter mu, or choosing z instead of t because sigma was never actually given.',
   'Before calculating anything, write your hypotheses in parameter notation and state your procedure with its justification -- treat this as a checkpoint you cannot skip on the way to the arithmetic.'),
  ('4.5','Carrying Out a Test for a Population Mean or Mean Difference',
   'The test statistic and p-value are only half the work; the other half is translating a reject or fail-to-reject decision into a sentence about the real-world parameter that never overstates what a p-value can prove.',
   'A small p-value means the observed data would be unusual if H0 were true -- it does not mean H0 is false with certainty, which is exactly why the conclusion sentence must use hedged, evidence-based language rather than definitive claims.',
   'Scoring checks the calculation, the correct comparison direction (p-value versus alpha, not the reverse), and a conclusion that ties back to the specific parameter and population named in the original hypotheses -- generic conclusions lose this last point even when the math is right.',
   'Compute the statistic and df, compare p-value to alpha in that order, then write one hedged sentence naming the parameter and population -- never accept, prove, or a bare is.',
   'A sample of 40 batteries has a mean life of 502 hours (s = 18) against a claimed mean of 500 hours, tested at alpha = 0.05. The resulting p-value is 0.31. State the conclusion.',
   'Since p > 0.05, we accept H0 and prove the mean is 500 hours.',
   'Since p = 0.31 > alpha = 0.05, we fail to reject H0; there is not convincing evidence that the true mean battery life differs from 500 hours.',
   'Concluding we have proven or stating the parameter is a certain value, instead of phrasing the conclusion as convincing evidence in the direction of Ha.',
   'After every calculation, write your conclusion as one sentence with convincing evidence or not convincing evidence -- never prove, accept, or a bare is statement -- and check it against the original hypotheses.'),
  ('4.6','Sampling Distributions for the Difference Between Two Sample Means',
   'x-bar-1 minus x-bar-2 is itself a random variable with a predictable center and spread built from both original samples, and its shape claim requires both samples to satisfy the normality condition, not just the larger or more convenient one.',
   'Variances add under subtraction because the two samples are independent, which is why the spread formula uses a sum inside the square root even though the statistic itself is a difference -- this is a common source of sign confusion.',
   'A full-credit shape justification names both sample sizes or both population shapes explicitly; naming only one and asserting the difference is approximately normal is treated as an incomplete justification.',
   'Write two separate shape justifications, one per sample, before combining them into one conclusion about the difference''s shape.',
   'Sample A has n1 = 15 from a population known to be normal. Sample B has n2 = 45 from a population of unknown shape. Is x-bar-1 minus x-bar-2 approximately normal?',
   'Yes, because sample B is large enough (n = 45 >= 30).',
   'Yes, but the justification needs both samples: sample A''s population is known normal (any n1 works), and sample B''s n2 = 45 >= 30 supports approximate normality there -- both conditions together justify the difference being approximately normal.',
   'Checking the shape condition for only one of the two samples and treating that as sufficient for the whole difference''s sampling distribution.',
   'When two samples are involved, write two separate shape justifications, one per sample, before combining them into a conclusion about the difference.'),
  ('4.7','Constructing a Confidence Interval for the Difference Between Two Population Means',
   'The interval''s structure mirrors every other t-interval in this unit -- statistic plus or minus critical value times standard error -- but both the standard error and the df calculation are specific to two independent samples and do not simplify to the pooled formula from other statistics courses.',
   'This course deliberately does not use the pooled two-sample df = n1 + n2 - 2; the correct df is calculated by technology and falls between n1 + n2 - 2 and the smaller of n1 - 1 and n2 - 1, so citing the pooled formula by name is a scoring risk even if the final interval happens to be close.',
   'The standard error formula, the correct non-pooled df sourcing, and both samples'' conditions each earn separate credit, so a student can build a numerically reasonable interval and still lose the df-specific point.',
   'State the standard error formula, then explicitly say df comes from technology, not the pooled n1 + n2 - 2 formula, before checking both samples'' conditions.',
   'Two independent samples of plant heights are collected: n1 = 20, x-bar-1 = 34 cm, s1 = 4; n2 = 25, x-bar-2 = 31 cm, s2 = 5. Describe how to find the 95% confidence interval for mu-1 minus mu-2.',
   'Use df = n1 + n2 - 2 = 43 and plug into the pooled two-sample formula.',
   'Use SE = sqrt(4-squared/20 + 5-squared/25) and find t* from technology using the df calculated for unequal variances (not the pooled df = 43), then compute (34 - 31) +/- t* times SE.',
   'Defaulting to the pooled df = n1 + n2 - 2 formula from other courses instead of this course''s non-pooled, technology-based df rule.',
   'Every time you see two independent samples and a difference of means, write df by technology, not n1+n2-2 before you touch a calculator, so the habit sticks before the exam.'),
  ('4.8','Justifying a Claim Based on a Confidence Interval for the Difference Between Two Population Means',
   'Whether zero is inside or outside a difference interval is the entire justification -- no new hypothesis test is needed, and the interval''s sign, not just its exclusion of zero, tells you which population has the larger mean.',
   'Sample means being unequal is expected from random sampling even when the true population means are identical; the confidence interval, not the raw difference in x-bar''s, is what tells you whether that difference is convincing.',
   'The rubric wants the zero-check stated explicitly and a conclusion in context that names both populations and the direction of the difference when zero is excluded, not just a yes or no about whether the means differ.',
   'State explicitly whether the interval contains zero, and if it does not, state which population''s mean the sign points to as larger.',
   'A 90% confidence interval for mu-1 minus mu-2 (Method A minus Method B) is (2.1, 8.4) minutes. What can be concluded about the two methods?',
   'The methods are different because 2.1 and 8.4 aren''t zero.',
   'Because the interval (2.1, 8.4) does not contain zero, there is convincing evidence that the true mean time for Method A is greater than for Method B, by somewhere between 2.1 and 8.4 minutes.',
   'Concluding the means are different just because x-bar-1 does not equal x-bar-2, without checking whether zero actually falls outside the confidence interval.',
   'Every difference-interval conclusion should state explicitly whether zero is inside or outside, and if outside, which group''s mean is larger -- make that two-part structure automatic.'),
  ('4.9','Setting Up a Test for the Difference Between Two Population Means',
   'The setup for comparing two means mirrors the one-sample setup in structure -- parameter-based hypotheses, a named and justified procedure, and conditions checked before arithmetic -- but every condition now has to be verified twice, once per sample.',
   'Because the two samples are independent, satisfying a condition for one sample says nothing about the other; skipping the second sample''s check is treated the same as not checking conditions at all.',
   'Scoring separates hypotheses in correct notation, procedure identification with justification, and conditions checked for both groups -- missing any one of the three costs a distinct point even with a correct final test statistic.',
   'Write parameter-based hypotheses for the difference, name the two-sample t-test, then check both samples'' conditions separately, never assuming one check covers both.',
   'A researcher compares mean study hours between two independent groups of students (tutored vs. not tutored) to see if tutoring increases study time. Set up the hypotheses and name the test.',
   'H0: x-bar-1 = x-bar-2, Ha: x-bar-1 > x-bar-2, two-sample t-test.',
   'H0: mu-1 minus mu-2 = 0, Ha: mu-1 minus mu-2 > 0, where mu-1 and mu-2 are the true mean study hours for tutored and non-tutored students; a two-sample t-test applies since both population standard deviations are unknown and the samples are independent.',
   'Writing hypotheses about x-bar-1 minus x-bar-2 instead of mu-1 minus mu-2, or checking conditions for only one of the two independent samples.',
   'State your two-sample hypotheses in parameter notation and name your procedure before you check a single condition -- treat this as the same non-negotiable checkpoint as the one-sample setup.'),
  ('4.10','Carrying Out a Test for the Difference Between Two Population Means',
   'The final step of the unit ties the two-sample calculation to the same evidence-based conclusion language required everywhere else in Unit 4 -- a correct test statistic with an overclaiming conclusion still loses the conclusion point.',
   'A significant result compares two samples, not two populations directly; the conclusion sentence has to translate the observed gap is unusual if the true means were equal into a hedged statement about the two population means, never a flat claim that one group is better.',
   'Scoring checks the test statistic and df sourcing, the p-value-to-alpha comparison direction, and a final sentence that names both populations and uses convincing-evidence language -- a technically correct t and p-value with a definitive conclusion still loses a point.',
   'Compute the two-sample statistic and cite df from technology, compare p-value to alpha, then write one hedged sentence naming both populations.',
   'Two independent samples of commute times give t = 2.41, df from technology, and a resulting p-value of 0.018 at alpha = 0.05. State the conclusion in context.',
   'Since p < 0.05, Group 1''s commute time is definitely longer than Group 2''s.',
   'Since p = 0.018 < alpha = 0.05, we reject H0; there is convincing evidence that the true mean commute time differs between the two groups, with Group 1''s sample mean suggesting it is the longer of the two.',
   'Stating the conclusion as if the test proved which population mean is truly larger, instead of framing it as convincing evidence in the direction of Ha.',
   'Finish every two-sample test the same way you finish a one-sample test: p-value versus alpha, then one hedged sentence naming both populations -- make that final sentence a fixed habit across the whole unit.')
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, source_note, status, published_at
)
select
  'ap_statistics', 4, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge,
  'cramapple-authored; grounded in AP_STATISTICS_2027_CED_FACT_PACK.md Sec3 topic map + Sec10 Unit 4 deep-tier detail (both sections UNREVIEWED pending Jill/Orly SME sign-off, per the fact pack''s own Sec9 note); batch 2026-08-21-ap-statistics-unit4; author=reviewer same session, no independent human review yet', 'published', now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  title = excluded.title,
  core_idea = excluded.core_idea,
  what_students_need_to_understand = excluded.what_students_need_to_understand,
  how_this_becomes_points = excluded.how_this_becomes_points,
  answer_move = excluded.answer_move,
  mini_example_question = excluded.mini_example_question,
  weak_answer = excluded.weak_answer,
  point_attaining_answer = excluded.point_attaining_answer,
  common_point_loss = excluded.common_point_loss,
  practice_bridge = excluded.practice_bridge,
  source_note = excluded.source_note,
  status = excluded.status,
  published_at = excluded.published_at;

do $$
declare
  v_briefs integer;
  v_explainers integer;
begin
  select count(*) into v_briefs from app.topic_point_briefs
    where subject_key='ap_statistics' and unit_number=4 and status='published';
  select count(*) into v_explainers from app.topic_explainers
    where subject_key='ap_statistics' and unit_number=4 and status='published';
  if v_briefs <> 10 then
    raise exception 'expected 10 published AP Statistics Unit 4 briefs, got %', v_briefs;
  end if;
  if v_explainers <> 10 then
    raise exception 'expected 10 published AP Statistics Unit 4 explainers, got %', v_explainers;
  end if;
end $$;

commit;
