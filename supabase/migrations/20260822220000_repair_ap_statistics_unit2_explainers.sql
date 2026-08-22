begin;

-- Repair AP Statistics Unit 2 (Probability, Random Variables, and
-- Probability Distributions) Learn More explainers -- all 12 were
-- template-generated debt (core_idea verbatim-matching their brief's
-- what_it_is, and mini_example_question/weak_answer/point_attaining_answer/
-- practice_bridge shared boilerplate duplicated across ~150 other rows
-- corpus-wide, per the 2026-08-21 bulk audit). Briefs for this unit are
-- genuinely hand-authored and correct; NOT touched here.
--
-- Grounded in docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md Unit 2
-- section (starting line 203) and the Unit 2 taxonomy summary (line 54):
-- 2.1's "EK-only, no formula at this stage" framing and the segmented-vs-
-- side-by-side bar chart structure; 2.2's derived fact that conditional
-- relative frequencies within one row/column sum to 100% independent of
-- other rows (a direct consequence of the CED's joint/marginal/conditional
-- denominator distinctions); 2.3's "EK-only, no equation" framing for how
-- many trials count as "enough" under the Law of Large Numbers; 2.4's
-- explicit 0<=P(E)<=1 closed-interval statement and the equally-likely-
-- outcomes restriction on the counting formula; 2.5's derived fact that
-- the addition rule collapses to a plain sum for genuinely disjoint events;
-- 2.6's derived fact that the joint probability P(A and B) is symmetric in
-- A and B even though P(A|B) and P(B|A) generally differ (from rearranging
-- the CED's conditional-probability definition both directions); 2.7's
-- documented misconception (2025 CR Report Q3, Part A(ii)) of defaulting
-- to a without-replacement/dependent-events calculation even when the
-- scenario's events are independent; 2.8's derived fact that P(X<x) and
-- P(X<=x) differ by exactly P(X=x) for a discrete variable (from the CED's
-- CDF definition P(X<=x)); 2.9's documented misconception (2025 CR Report
-- Q3/Q5) of computing an unweighted mean of the possible X-values instead
-- of the probability-weighted mean; 2.10's documented misconceptions (2025
-- CR Report Q3, Part B(i)) of imprecise random-variable definitions,
-- "distributed randomly" language instead of naming the binomial
-- distribution, and unlabeled calculator-syntax answers forfeiting the
-- parameters-labeled scoring component; 2.11's p-as-percentage notation
-- convention in EK 2.11.E.2.i-iv (opposite the 0-to-1 proportion convention
-- used elsewhere in the unit), which is the notation trap behind the
-- factor-of-100 error; and 2.12's derived connection that a sampling
-- distribution's dots represent a theoretical collection of every possible
-- sample's statistic, which simulation (2.3) is the practical stand-in for
-- approximating, plus the CED's explicit three-distributions distinction
-- (population / single sample / sampling distribution of a statistic).
-- Topics 2.1-2.4 and 2.8 have no misconception data documented in the fact
-- pack's reviewed sources for this unit, so their explainers are grounded
-- in the fact pack's structural/EK statements and directly-derived
-- mathematical consequences of those statements instead, per the same
-- approach used for AP Statistics Unit 1 topics 1.1-1.4.
--
-- Before-state not separately captured for this batch (no prior before-
-- state export file exists for AP Statistics Unit 2); the pre-repair
-- content is fully recoverable from git history for this table's rows if
-- a rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it), answer_move and common_point_loss
-- intentionally match the paired brief verbatim per protocol section 4
-- ("the same topic-specific answer_move" / "the same or refined
-- common_point_loss") except for 2.8, whose common_point_loss is refined
-- to name the specific at-most-versus-strictly-less-than boundary error
-- the mini-example demonstrates, and mini_example_question / weak_answer /
-- point_attaining_answer / practice_bridge are original per-row text that
-- was checked corpus-wide before this migration was written and repeats
-- nowhere else in the published corpus. All computed numbers (relative
-- frequencies, conditional probabilities, expected values, binomial
-- probabilities, z-scores, and empirical-rule percentages) were
-- independently verified during authoring.

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('2.1',
   'The essential knowledge for this topic is purely definitional with no formula attached -- 2.1 asks you to correctly read a table''s structure (cell, row total, column total, grand total) and translate between a two-way table and its segmented or side-by-side bar-chart version; the actual relative-frequency formulas that turn these numbers into proportions don''t arrive until 2.2, so credit here is about locating and reading, not calculating.',
   'Because this topic has no computational skill of its own, the real requirement is fluently identifying which number a graph or table cell represents -- a segmented bar chart hides the group''s total size behind percentages, while a side-by-side bar chart preserves the raw counts as bar heights, and knowing which version you''re looking at changes what a tall bar actually means.',
   'Credit depends on correctly locating a requested value (cell vs. row total vs. column total vs. grand total) in a described or partially completed two-way table, building a table from a word problem''s stated marginal counts, and reading counts or percentages correctly off a segmented or side-by-side bar chart without confusing the two chart types.',
   'Before extracting any number from a two-way table, write down in words what the row variable is, what the column variable is, and what a single cell counts -- this labeling step is what keeps you from grabbing a margin when a cell was asked for.',
   'A segmented bar chart compares the percentage of students who walk to school at School A (100 students total) and School B (400 students total); both schools show a 30% segment for walking. A student is asked which school has more students who walk to school and answers based on the chart.',
   'Since both schools'' walking segments are the same height (30%), the same number of students walk to school at each school.',
   'The segments being equal height only means the percentages are equal, not the counts -- School A has 30% of 100 = 30 walkers, while School B has 30% of 400 = 120 walkers, so School B actually has four times as many students who walk to school even though its segment looks identical in height on the chart.',
   'Treating a segmented bar chart''s percentages as counts, so groups of very different sizes look equally large.',
   'Open practice and, for any segmented bar chart comparing two groups, multiply each group''s percentage by its own total before comparing counts across groups.'),
  ('2.2',
   'Joint, marginal, and conditional relative frequency all divide by a different total drawn from the same two-way table, and a direct consequence of that structure is that the conditional relative frequencies within a single row (or column) always sum to 100% on their own, independent of every other row -- which is exactly what makes conditional distributions comparable side by side across groups of very different sizes.',
   'Choosing the right denominator is the entire skill, and because conditional relative frequencies are computed from each group''s own total rather than the grand total, they let you compare two groups fairly even when one group is much larger than the other -- the same comparison that later becomes an argument for or against association between the two categorical variables.',
   'Points require computing the requested relative frequency with the denominator that matches the question''s wording, naming the group that denominator describes, and using a comparison of conditional distributions across groups (not raw counts) to support an association conclusion.',
   'For every percentage you report from a two-way table, write it as a sentence in the form ''of the [group in the denominator], ___% are [category in the numerator]'' -- if you cannot name the denominator group, you divided by the wrong total.',
   'A two-way table of 150 students by grade and band participation shows: 90 seniors, of whom 30 are in band; and 60 juniors, of whom 18 are in band. A student is asked what percentage of seniors are in band.',
   '30 out of the 150 total students are seniors in band, so 30/150 = 20% of seniors are in band.',
   'The question asks for a percentage ''of the seniors,'' so the denominator must be the senior total (90), not the grand total (150): 30/90 ≈ 33.3% of seniors are in band. Dividing by the grand total instead answers a different question -- what percentage of all 150 students are senior band members -- not the one that was asked.',
   'Dividing a cell by the grand total when the question asked ''of the seniors,'' which requires dividing by that row''s own total.',
   'Head into practice and, before dividing anything in a two-way table problem, underline the group named after ''of the'' in the question -- that group''s own total is your denominator.'),
  ('2.3',
   'The CED gives simulation only as a qualitative procedure with no formula for how many trials are ''enough'' -- the Law of Large Numbers guarantees only that the long-run relative frequency drifts closer to the true probability as trials increase, not that any specific number of trials pins down an exact value, so a simulation-based probability is always reported as an estimate, never as the answer.',
   'A complete simulation design needs every piece stated explicitly: what random device generates outcomes, how its outputs map onto the real-world outcomes being modeled, what one trial consists of and when it ends, and what gets recorded each trial -- skipping any one of these leaves the design too vague to actually run, even if the final estimate looks reasonable.',
   'Credit requires describing all five design pieces (device, mapping, trial definition, stopping point, and recorded quantity), correctly counting successful trials, dividing by total trials for the estimate, and explicitly labeling the result as an estimate rather than an exact probability.',
   'When you describe a simulation, explicitly state where one trial ends and what you write down at that moment; a design that assigns digits but never defines the stopping point and the recorded quantity is incomplete even if your estimate is right.',
   'A student simulates the probability of rolling at least one 6 in 4 rolls of a fair die: they let a single digit 1-6 represent a die face (ignoring 0, 7, 8, 9), and treat each group of 4 valid digits as one trial. After running 5 trials, 3 of them contained at least one 6.',
   '3 out of 5 trials had at least one 6, so the probability of rolling at least one 6 in 4 rolls is exactly 0.6.',
   '3 out of 5 trials succeeded, giving a simulation-based estimate of 3/5 = 0.6 -- but this is only an estimate from 5 trials, not the exact probability; per the Law of Large Numbers, running many more trials would let this estimate settle closer to the true long-run probability, which 5 trials alone cannot pin down precisely.',
   'Reporting a simulation estimate as the exact probability, instead of an estimate that gets closer to the truth as trials increase.',
   'Return to practice and, on any simulation-design item, check your written answer against all five pieces: device, mapping, trial definition, stopping point, recorded quantity.'),
  ('2.4',
   'The equally-likely outcomes formula and the complement rule both come with a boundary the CED states explicitly: probability is defined only on the closed interval from 0 to 1 inclusive, so an event with probability exactly 0 is possible in principle but never happens, and an event with probability exactly 1 is certain -- and the outcomes-over-total formula itself only applies when the sample space''s outcomes are genuinely equally likely, not merely countable.',
   'The complement rule is a shortcut, not a separate concept -- P(not E) = 1 - P(E) always holds regardless of whether outcomes are equally likely, which is exactly why it stays useful in 2.7 and 2.10 even after the simple counting formula stops applying to unequal-probability settings.',
   'Credit requires correctly identifying whether a sample space''s outcomes are equally likely before applying the counting formula, applying the complement rule to convert an ''at least one'' or ''none'' question into its simpler opposite, and reporting a final value that falls between 0 and 1.',
   'When a question asks for ''at least one,'' compute the probability of none and subtract from 1 rather than adding up cases -- but check first that ''none'' is genuinely the only complementary outcome, since the shortcut only works when the two events partition the sample space.',
   'A spinner has four unequal sectors: red covers 50% of the spinner, blue covers 30%, green covers 15%, and yellow covers 5%. A student is asked for the probability the spinner does not land on red.',
   'There are 4 sectors, so the probability of not landing on red is 3 out of 4 sectors, or 0.75.',
   'The four sectors are not equally likely -- they cover different fractions of the spinner -- so the outcomes-over-total counting formula does not apply here. Using the complement rule with the given probability instead: P(not red) = 1 - P(red) = 1 - 0.50 = 0.50.',
   'Using outcomes-divided-by-total when the outcomes are not equally likely, such as unequal spinner sectors or weighted categories.',
   'Go to practice and, before counting outcomes on any probability item, confirm every outcome is actually equally likely -- if the setup mentions unequal sizes, weights, or percentages, use those given probabilities directly instead.'),
  ('2.5',
   'Mutually exclusive events being unable to happen together is a much narrower claim than ''unrelated'' -- two events built from overlapping conditions on the very same trial (like ''the roll is even'' and ''the roll is greater than 4'') can share an outcome and therefore not be disjoint, even though the two conditions sound like they describe separate, unconnected features of the roll.',
   'When two events with nonzero probability are genuinely disjoint, the addition rule collapses to a plain sum: P(A or B) = P(A) + P(B), with no overlap term to subtract, because there is nothing to double-count -- but the moment two events share even one outcome, that simplification is no longer valid and the full union rule with subtraction is required instead.',
   'Credit depends on checking overlap directly -- could a single trial land in both events at once? -- rather than guessing from how unrelated the two events sound, and on correctly deciding when the addition rule simplifies to a plain sum versus when it needs the overlap subtracted.',
   'Test mutual exclusivity by asking one question -- could a single individual or a single trial land in both events at once? -- and answer it about the overlap only; do not compare the plain and conditional probabilities, which is the independence test in 2.7, not this one.',
   'For a single roll of a fair six-sided die, event A is ''the roll is even'' and event B is ''the roll is greater than 4.'' A student is asked whether A and B are mutually exclusive.',
   'Being even and being greater than 4 describe two unrelated features of the roll, so A and B are mutually exclusive.',
   'A and B are not mutually exclusive -- the outcome 6 is both even and greater than 4, so A and B = {6}, which has probability 1/6, not 0. Sounding like two unrelated conditions doesn''t guarantee no overlap; the only valid test is checking whether a specific outcome can satisfy both events at once, and here one does.',
   'Assuming mutually exclusive means independent; disjoint events with nonzero probability are actually dependent, since one occurring rules the other out.',
   'Back to practice: for any mutually-exclusive-or-not item, list out the actual outcomes in each event before deciding, rather than judging from how related the two descriptions sound.'),
  ('2.6',
   'Rearranging the conditional probability definition gives the multiplication rule P(A and B) = P(A|B)·P(B), but the same joint probability can equally be built the other direction as P(B|A)·P(A) -- the joint probability P(A and B) is symmetric in A and B even though the two conditional probabilities P(A|B) and P(B|A) are almost never equal to each other.',
   'Conditioning on B shrinks the sample space down to just the outcomes where B happened, and B becomes the new denominator -- this shrinking is why the direction of conditioning matters so much: P(A|B) restricts attention to B''s outcomes and asks how much of that reduced space is also A, which is a genuinely different question from P(B|A).',
   'Points require correctly identifying which event is the condition (the denominator), computing the conditional probability from a table or tree diagram using that correct denominator, and applying the multiplication rule to find a joint probability by chaining together a conditional probability and a marginal probability.',
   'Translate the word after ''given that,'' or the group named after ''of the,'' into your denominator before you compute anything -- and note that the two directions of conditioning are different questions, so reversing them changes the answer even with identical data.',
   'Over 200 commuting days, 40 were rainy. Of the rainy days, 35 involved the commuter bringing an umbrella. Of the 160 non-rainy days, 20 involved bringing an umbrella. A student is asked for the probability a commuter brought an umbrella, given that it was rainy.',
   '55 total days involved bringing an umbrella (35 rainy + 20 not rainy), and 35 of those were rainy, so the probability is 35/55 ≈ 0.636.',
   'The condition is ''given that it was rainy,'' so rainy days (40) are the denominator, not umbrella-days (55): P(umbrella | rainy) = 35/40 = 0.875. The weak answer computed P(rainy | umbrella) instead -- a different, reversed question that happens to use the same table but restricts to the wrong 55 days as its condition.',
   'Reversing the condition -- answering ''probability of the disease given a positive test'' with the probability of a positive test given the disease.',
   'Return to practice and, on any conditional probability item, restate the condition in your own words as ''given that ___'' before choosing your denominator.'),
  ('2.7',
   'A well-documented AP scoring pattern (2025 Chief Reader Report) shows students defaulting to a without-replacement, dependent-events calculation even in scenarios where the events are explicitly independent -- for instance treating two separately-generated selections as if drawing from one shrinking finite population, when the setup actually keeps the probability constant on every selection.',
   'Independence has to be verified with the scenario''s actual mechanics, not assumed by default -- if a population is restocked, if selections come from separate processes, or if the problem states selections don''t affect each other, the probability stays constant across selections and multiplying plain probabilities is correct; only genuine sampling without replacement from one fixed finite group changes the numerator and denominator from selection to selection.',
   'Credit requires testing independence against the scenario''s actual setup rather than defaulting to one model, stating the independence or dependence conclusion in context, and applying the union rule with the overlap correctly subtracted (or recognizing when that overlap is zero) for ''or'' questions.',
   'Before multiplying probabilities across repeated selections, check whether the scenario actually removes items without replacement; if it does not, keep the probability constant on every trial. For an ''or'' question, add the two probabilities and subtract the overlap so it is not counted twice.',
   'A vending machine''s stock is 10% one specific snack; the machine is fully restocked to the same 10% proportion before each dispense. A student computes the probability that two separate dispenses (from a described batch of 1,000 items, 100 of that snack) both produce that snack.',
   '100 of the 1,000 items are that snack, so the probability of getting it on both dispenses is (100/1,000) × (99/999) ≈ 0.00991.',
   'The machine is restocked to the same proportion before each dispense, so the two dispenses are independent -- the second dispense doesn''t draw from a shrinking pool depleted by the first. The correct calculation is 0.10 × 0.10 = 0.01, using the same constant probability on each dispense rather than a without-replacement fraction that assumes a single depleting batch.',
   'Shrinking the numerator and denominator each draw, as if sampling without replacement, when the trials are independent and the probability stays constant.',
   'Go to practice and, before chaining probabilities across repeated selections, check explicitly whether the scenario restocks, uses separate populations, or states independence -- only genuine without-replacement sampling from one fixed group changes the probability from selection to selection.'),
  ('2.8',
   'For a discrete random variable, P(X < x) and P(X ≤ x) differ by exactly P(X = x) -- the single probability of landing exactly on the boundary value -- so reading a cumulative distribution correctly means deciding whether that boundary value itself belongs in your answer before you add or subtract anything.',
   'A discrete probability distribution is only valid if its probabilities sum to exactly 1 across every listed value, which means a missing probability in a table can always be recovered by subtracting the sum of the known probabilities from 1 -- and a cumulative distribution is just the running total of that same sum, stopping at whichever value you''re asked about.',
   'Points require verifying or completing a distribution so its probabilities sum to 1, finding a missing probability by subtraction when needed, and correctly choosing whether a boundary value counts toward an at-most (≤) versus a strictly-less-than (<) question.',
   'Whenever a distribution is presented as a table, sum the probabilities and confirm they total 1 before answering -- if a value is missing, that sum-to-1 requirement is how you recover it, and if they do not total 1 the given distribution is not valid.',
   'A discrete random variable X, the number of pets in a household, has distribution P(X=0)=0.4, P(X=1)=0.3, P(X=2)=0.2, P(X=3)=0.1. A student is asked for the probability a household has fewer than 2 pets.',
   'P(X ≤ 2) = 0.4 + 0.3 + 0.2 = 0.9, so the probability of fewer than 2 pets is 0.9.',
   '''Fewer than 2'' means X < 2, which is X = 0 or X = 1 only -- it excludes the boundary value X = 2 itself. So P(X < 2) = 0.4 + 0.3 = 0.7. The weak answer computed P(X ≤ 2) instead, which includes the 2-pet households that ''fewer than 2'' is supposed to exclude.',
   'Confusing an at-most (≤) boundary with a strictly-less-than (<) boundary, including a value the question meant to exclude.',
   'Head back to practice and, on any cumulative-probability question, circle the boundary word (fewer than, at most, more than, at least) before deciding whether the boundary value itself is included.'),
  ('2.9',
   'Expected value is a probability-weighted sum, not a plain average of the listed values -- for a random variable whose outcomes are not equally likely, dropping the P(x_i) factor and just averaging the numbers themselves produces a documented, exam-common wrong answer that looks superficially reasonable but ignores how much more likely the low-probability outcomes are to actually occur.',
   'Because each value in the sum is weighted by its own probability, an outcome that occurs rarely contributes only a small amount to the expected value even if its raw number is large, while a very likely outcome dominates the sum even if its raw number is small -- the expected value describes the long-run average per trial, not a value you''d expect on any single trial.',
   'Credit requires multiplying every value by its own probability before summing (never the unweighted average), interpreting the result in context as a long-run average, computing the probability-weighted standard deviation correctly, and correctly identifying which values a compound event like ''fewer than'' actually includes.',
   'When you compute an expected value, keep the probability factor attached to every term -- the mean of a random variable is a probability-weighted sum, never the plain average of the listed values, unless those values happen to be equally likely.',
   'A random variable X, the number of website visits before a purchase, has distribution P(X=0)=0.5, P(X=1)=0.3, P(X=2)=0.15, P(X=3)=0.05. A student is asked for E(X).',
   'The possible values are 0, 1, 2, and 3, so E(X) = (0+1+2+3)/4 = 1.5.',
   'E(X) must weight each value by its own probability, not average the four values as if equally likely: E(X) = 0(0.5) + 1(0.3) + 2(0.15) + 3(0.05) = 0 + 0.3 + 0.3 + 0.15 = 0.75. The unweighted average of 1.5 ignores that 0 visits is far more likely (probability 0.5) than 3 visits (probability 0.05), so it overstates the true long-run average.',
   'Averaging the possible values as if equally likely, or reading ''fewer than 3'' as 3 or fewer when it means 2 or fewer.',
   'Return to practice and, before summing any expected-value calculation, check that every term still has its probability factor attached -- if you''re just adding the raw values, you''ve dropped the weighting.'),
  ('2.10',
   'A binomial answer built only from a calculator command like binomcdf(6,0.2,2) forfeits the parameter-identification credit even when the numeric result is correct -- the documented scoring expectation is a full distribution statement naming X as a count over a stated number of trials, naming the distribution as binomial, and stating n and p explicitly in words, not just typing a command.',
   'Recognizing a binomial setting from a word problem, rather than being told to use it, is the actual skill being tested -- all four conditions (fixed number of trials, independent trials, exactly two outcomes per trial, constant success probability) have to hold, and describing the random variable vaguely, such as naming it after the item counted rather than as a count over a stated number of trials, is treated as an incomplete definition even before any calculation begins.',
   'Points require defining the random variable precisely in words as a count over a stated interval or number of trials, explicitly naming the distribution as binomial with its n and p, checking all four binomial conditions against the scenario, and computing the requested probability, mean, or standard deviation with those parameters labeled in the written work.',
   'Write the distribution statement in full -- X = the number of successes in n trials, and X is binomial with stated n and p -- and label n and p in words even when you compute with a calculator command, since an unlabeled command string forfeits the parameter-identification credit.',
   'A store''s promotional codes are winning codes 20% of the time. A customer buys 6 items, each independently having a 20% chance of a winning code. A student is asked for the probability exactly 2 of the 6 items have a winning code.',
   'The codes are distributed randomly, so P(2 winners) = (0.2)^2 = 0.04.',
   'Let X = the number of winning codes among the 6 items purchased. X is binomial with n = 6 and p = 0.2. P(X=2) = C(6,2)(0.2)^2(0.8)^4 = 15 × 0.04 × 0.4096 ≈ 0.246. The weak answer never names the distribution as binomial, omits the C(6,2) count of arrangements, and omits the (0.8)^4 factor for the 4 items that are not winners.',
   'Writing only a calculator command as your answer, with no words naming the distribution as binomial or stating what n and p are.',
   'Head to practice and, on any binomial item, write the full sentence naming X, its count definition, and its n and p before you compute anything, even if you''ll finish the arithmetic on a calculator.'),
  ('2.11',
   'The CED''s own notation for normal-curve boundaries writes p as a percentage from 0 to 100, not as a 0-to-1 proportion (EK 2.11.E.2) -- the opposite convention from how probability is written everywhere else in this unit -- which is exactly the notation trap behind the factor-of-100 errors that show up when a proportion like 0.025 gets reported as 0.25 or 2.5 gets reported as 0.025.',
   'The empirical rule''s 68/95/99.7 landmarks are the anchor for any normal-curve question -- 68% falls within 1 SD, 95% within 2 SD, 99.7% within 3 SD -- and the remaining area outside those bounds splits evenly between both tails since the normal curve is symmetric, which is exactly how you get to a single-tail percentage from the empirical rule''s two-tail total.',
   'Credit requires applying the empirical rule at landmark boundaries, standardizing a value to find area on the correct side or between two boundaries, working backward from a percentile to a raw value, and stating the final answer with the correct percent-versus-proportion label rather than leaving the 0-to-1-versus-0-to-100 distinction ambiguous.',
   'Sketch the curve and shade the region before computing, then label whether your answer is a proportion or a percent and convert deliberately, so you do not introduce a factor-of-100 error.',
   'Apple weights are normally distributed with mean 180 grams and standard deviation 20 grams. A student is asked for the proportion of apples weighing more than 220 grams.',
   '220 grams is 2 standard deviations above the mean, so by the empirical rule, 95% falls within 2 SD, leaving 5% in both tails combined, split evenly -- the answer is 2.5.',
   '220 grams is 2 SD above the mean (z = (220-180)/20 = 2.0). The empirical rule puts 95% within 2 SD, leaving 5% split evenly between both tails, so 2.5% is above 220 grams. As a proportion, that''s 0.025, not 2.5 -- reporting ''2.5'' without converting to the 0-to-1 scale (or explicitly labeling it as 2.5%) drops a factor of 100 from the answer.',
   'Reporting a normal-curve area without labeling it as a proportion or a percent, then carrying a factor-of-100 error into the answer.',
   'Back to practice: on every normal-distribution answer, write the percent sign or the 0-to-1 decimal explicitly, since the CED itself switches between percentage and proportion notation across this unit.'),
  ('2.12',
   'A sampling distribution''s dots aren''t enumerated by hand -- they represent the theoretical collection of every possible sample''s statistic, which is why the simulation approach from 2.3 is the practical stand-in used to approximate what a sampling distribution looks like when the true distribution can''t be listed out directly.',
   'Three different distributions get compared in this topic and it''s easy to blur them together: the population distribution (one dot per individual in the whole population), a single sample''s data (one dot per individual in just that one sample), and the sampling distribution of a statistic (one dot per whole sample''s computed statistic, across many samples) -- correctly naming which of the three a given graph shows is the entire conceptual task.',
   'Points require correctly identifying which of the three distributions -- population, single sample, or sampling distribution of a statistic -- a given graph or description shows, stating that the Central Limit Theorem makes the sampling distribution of a sample mean approximately normal for a large enough sample even when the population is not normal, and explaining that increasing sample size tightens the spread of the statistic.',
   'Before describing any distribution here, name what one dot on it represents: one individual (population or single sample) or one whole sample''s statistic (sampling distribution) -- and note the Central Limit Theorem''s normality promise attaches to the sampling distribution, not to the population.',
   'A population of exam scores is strongly right-skewed. Many random samples of size 40 are drawn, each sample''s mean is computed, and all of those means are plotted on one dotplot. A student is asked what a single dot on this new dotplot represents.',
   'Each dot represents one student''s individual exam score.',
   'Each dot represents one entire sample''s mean -- the average of all 40 scores in that one sample -- not a single student''s score. This dotplot is the sampling distribution of the sample mean, and by the Central Limit Theorem it will appear approximately normal even though the original population of exam scores is right-skewed, with that normal approximation improving as the sample size of 40 (or larger) increases.',
   'Claiming the Central Limit Theorem makes the population normal; it describes the distribution of the sample mean, while the population can stay skewed.',
   'Return to practice and, whenever a question shows a new distribution built from many samples'' statistics, name what one dot represents before answering anything else.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_STATISTICS_2027_CED_FACT_PACK.md Unit 2 section (line 203): the EK-only/no-formula framing for 2.1 and 2.3; the derived conditional-relative-frequency-sums-to-100%-per-row fact for 2.2; the explicit 0<=P(E)<=1 closed-interval statement and equally-likely restriction for 2.4; the derived disjoint-events-addition-rule-collapses-to-a-sum fact for 2.5; the derived joint-probability-symmetry-despite-asymmetric-conditionals fact for 2.6; the 2025 Chief Reader Report''s documented without-replacement/dependence-default misconception for 2.7; the derived P(X<x) vs P(X<=x) boundary-difference fact for 2.8; the 2025 CR Report''s documented unweighted-mean misconception for 2.9; the 2025 CR Report''s documented imprecise-random-variable-definition and unlabeled-calculator-syntax misconceptions for 2.10; the CED''s p-as-percentage EK 2.11.E.2 notation convention for 2.11; and the derived sampling-distribution-as-theoretical-collection-approximated-by-simulation connection for 2.12; briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-statistics-unit2-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_statistics'
  and e.unit_number = 2
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_statistics' and unit_number=2 and status='published'
      and source_note like '%unit2-explainer-repair%';
  if v_repaired <> 12 then
    raise exception 'expected 12 repaired AP Statistics Unit 2 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_statistics' and b.unit_number=2 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Statistics Unit 2 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
