begin;

-- Repair AP Statistics Unit 1 (Exploring One-Variable Data and Collecting
-- Data) Learn More explainers -- all 13 were template-generated debt
-- (core_idea verbatim-matching their brief's what_it_is, and
-- mini_example_question/weak_answer/point_attaining_answer/practice_bridge
-- shared boilerplate duplicated across ~150 other rows corpus-wide, per the
-- 2026-08-21 bulk audit). Briefs for this unit are genuinely hand-authored
-- and correct; NOT touched here.
--
-- Grounded in docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md Unit 1
-- deep-tier detail (section 10) and the general exam-wide conventions
-- (section 10, general note): the 2026 FRQ Q1 stem-and-leaf-vs-boxplot
-- gap/cluster contrast (1.5); the 2025 Chief Reader Report's single most
-- repeated scoring error, boxplot shape described as symmetric/normal/
-- unimodal, which the 2025 SG explicitly bars (1.6); the CED's two
-- undated outlier rules (1.5xIQR or 2 SD) with no stated preference, and
-- the documented combined-group-median averaging error (1.7); the
-- five-number-summary/whisker-stops-at-non-outlier construction rule tied
-- to the same outlier check (1.8); the z-score formula's reuse for both
-- population and sample statistics with no separate notation (1.9); the
-- observational-vs-experimental treatment-imposed test and
-- prospective/retrospective split (1.10); the CED's explicit cluster-vs-
-- stratified opposite-mechanism distinction (EK 1.11.A.3-6) and the
-- documented wrong-specific-bias-name error (1.11); the documented
-- implementation-completeness distractor for describing a sampling
-- procedure (2025 CR Report Q2) (1.12); and the CED's precise placebo-
-- effect definition as a measured group-average difference, not just
-- "fake treatment" (1.13). Topics 1.1-1.4 have no misconception data in
-- the fact pack's reviewed sources, so their explainers are grounded in
-- the fact pack's structural/EK statements only (1.1's "not tested as a
-- standalone skill" framing; 1.2's vocabulary-only EK with no formula;
-- 1.3's frequency/relative-frequency table definitions; 1.4's categorical-
-- variable bar-chart construction rules).
--
-- Before-state not separately captured for this batch (no prior before-
-- state export file exists for AP Statistics Unit 1); the pre-repair
-- content is fully recoverable from git history for this table's rows if
-- a rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it), answer_move and common_point_loss
-- intentionally match the paired brief verbatim per protocol section 4
-- ("the same topic-specific answer_move" / "the same or refined
-- common_point_loss"), and mini_example_question / weak_answer /
-- point_attaining_answer / practice_bridge are original per-row text that
-- was checked corpus-wide before this migration was written and repeats
-- nowhere else in the published corpus.

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('1.1',
   'Every AP Statistics unit is really a different tool for answering the same underlying investigative question in the presence of variability -- Topic 1.1 itself carries no separate points on the exam; later free-response prompts simply assume you already open by restating the investigative question before calculating anything.',
   'Because 1.1 is never scored as its own step, the real skill it teaches is a habit: treat every dataset as evidence toward answering a stated real-world question, not as numbers to process in isolation, since later inference units grade you on connecting statistical results back to that question.',
   'No item tests 1.1 in isolation -- credit shows up indirectly, in later free-response parts that expect your final interpretation to explicitly reference the investigative question the scenario opened with, rather than stopping at a bare numeric result.',
   'When a free-response question opens with a real-world scenario, read the investigative question first and keep referring back to it in context -- this habit matters most in later inference units, not as its own gradable step here.',
   'A scenario states researchers want to know whether a new fertilizer increases average tomato yield, then gives sample yield data. A student computes the sample mean yield and stops.',
   'The sample mean yield is 14.2 pounds, so that''s the answer.',
   'The investigative question is whether the new fertilizer increases average tomato yield; the sample mean yield of 14.2 pounds is the evidence gathered toward answering that question, and this number should be compared against a baseline or interpreted with the original question restated -- a bare mean by itself, disconnected from the question, doesn''t complete the response later units will expect.',
   'Treating statistics as just calculating numbers instead of connecting those numbers back to the real question the data was collected to answer.',
   'Go to practice and, on any scenario-based question, write the investigative question in your own words as your first line before touching any calculation.'),
  ('1.2',
   'Categorical-vs-quantitative and discrete-vs-continuous is pure vocabulary with no formula attached, but the CED treats it as a gate: using a mean or standard deviation on a categorical variable, or a bar chart on a continuous one, is scored as a category error, not partial credit for a numeric mistake.',
   'This classification step determines which graphs, statistics, and inference procedures are even valid to reach for later in the course, so misclassifying a variable at this stage can invalidate an otherwise-correct calculation several units later.',
   'Multiple-choice and free-response items expect a stated variable to be correctly classified before any statistic or graph choice is judged -- picking the right numeric answer for the wrong variable type earns no credit for the classification component.',
   'When a question gives you a variable description, decide categorical-vs-quantitative first, then (if quantitative) discrete-vs-continuous, before choosing any graph or statistic -- this classification step is specific to reading the variable, not to analyzing it.',
   'A dataset records each student''s five-digit home zip code. A student classifies zip code as a quantitative variable since it''s written using digits.',
   'Zip code is quantitative because it''s a number.',
   'Zip code is categorical, not quantitative, even though it''s written with digits -- arithmetic on a zip code (like averaging two zip codes) produces a meaningless result, which is the test for whether a numeric-looking variable is actually categorical.',
   'Mixing up parameter and statistic, or calling a numeric label (like a zip code) quantitative just because it''s written as digits.',
   'Head back to practice and, before answering any variable-classification item, ask whether averaging or subtracting the value would produce a meaningful result -- if not, it''s categorical no matter how it''s written.'),
  ('1.3',
   'A relative frequency table converts each category''s count into a proportion of the whole table''s total observational units, and a documented AP error is dividing by the number of categories or rows instead of that grand total, which produces proportions that don''t sum to 1.',
   'Tables here are the raw material both for the bar charts in 1.4 and for two-way table reasoning used throughout the course, so a proportion computed against the wrong denominator propagates into every downstream graph and comparison.',
   'Credit requires the correct count-vs-proportion label on each value and the proportion computed as category count divided by the total number of observations, not by the number of category rows in the table.',
   'When asked for a relative frequency, divide the category count by the total number of observational units in the whole table, not by the number of rows or categories.',
   'A frequency table of favorite pizza toppings shows four categories: pepperoni (40), cheese (30), veggie (20), and other (10), for 100 total responses. A student reports pepperoni''s relative frequency as 40/4 = 10.',
   'Pepperoni''s relative frequency is 10, found by dividing the count by the number of categories.',
   'Pepperoni''s relative frequency is 40/100 = 0.40, found by dividing its count by the total number of observations across all categories, not by the number of categories in the table -- checking that all four relative frequencies sum to 1 (0.40+0.30+0.20+0.10) confirms the correct denominator was used.',
   'Dividing a category''s count by the number of categories instead of by the total number of observations.',
   'Return to practice and, on any relative-frequency item, check that your computed proportions across all categories sum to 1 before submitting an answer.'),
  ('1.4',
   'A bar chart''s bars are drawn with gaps between them specifically because the variable is categorical -- categories have no inherent order or continuity -- while a histogram''s touching bars signal a quantitative variable''s continuous number line, so the gap itself is a meaningful visual marker, not a stylistic choice.',
   'Because bar charts are the standard visual for categorical comparisons across groups throughout the course, reading the vertical axis scale correctly (counts versus relative frequencies) is required before any cross-chart comparison of two groups can be trusted.',
   'Points depend on construction details -- gaps between bars, equal bar widths, an accurately labeled and scaled axis -- and on correctly reading values off a given chart, including catching when two charts being compared use different axis scales.',
   'When constructing or reading a bar chart, keep the bars separated with gaps (never touching) and check whether the vertical axis is counts or relative frequencies before comparing bar heights across two charts.',
   'Two bar charts compare pet ownership in two towns, but one chart''s vertical axis goes from 0 to 50 (counts) and the other''s goes from 0 to 1 (relative frequencies). A student says Town A clearly has more dog owners because its bar looks taller.',
   'Town A has more dog owners since its bar is visually taller than Town B''s.',
   'The two charts use different vertical axis scales -- Town A''s is counts (0 to 50) and Town B''s is relative frequencies (0 to 1) -- so comparing raw bar heights across the two charts is invalid; a fair comparison requires converting both to the same scale, such as relative frequencies, before judging which town has proportionally more dog owners.',
   'Drawing or reading bars as if they touch like a histogram, or comparing two bar charts on different scales without noticing the axes don''t match.',
   'Back to practice: before comparing two bar charts, check that both vertical axes use the same units and scale.'),
  ('1.5',
   'A histogram groups values into bins and can hide sub-bin structure like a gap or cluster, while a stem-and-leaf plot or dotplot preserves every individual data value -- the 2026 released FRQ tests exactly this contrast, asking students to name a shape feature visible in a stem-and-leaf plot that the same data''s boxplot cannot show.',
   'Choosing a graph type is itself a tested skill, not a formatting preference, because different graphs of the identical dataset can reveal or conceal specific features depending on whether individual values or only binned/summarized values are shown.',
   'Free-response credit for a compare-representations item requires naming the specific graph type that preserves the needed information and explaining, in terms of what that graph shows and the other doesn''t, why it reveals the feature in question.',
   'When a question asks which graph best reveals a specific feature like a small gap or cluster, choose a graph that shows every individual data value (stem-and-leaf plot or dotplot) over a histogram, and explain that histogram bins can hide sub-bin structure.',
   'A dataset of 20 exam scores is displayed as both a histogram with bins of width 10 and a stem-and-leaf plot. A student is asked which graph would better reveal a small gap between two scores of 71 and 79 within the same 70-79 bin, and answers that both graphs show this equally well.',
   'Both the histogram and the stem-and-leaf plot show the gap equally well, since they display the same data.',
   'The stem-and-leaf plot better reveals the gap, because it preserves every individual value (each leaf), while the histogram groups all scores from 70-79 into one bin and displays only the bin''s total count, hiding whether those scores are spread out or clustered within that range.',
   'Assuming any graph of a quantitative variable shows the same information, when a histogram''s bins can actually hide gaps or clusters that a stem-and-leaf plot or dotplot would reveal.',
   'Return to practice and, for any compare-the-graphs question, ask which graph keeps individual values visible before deciding which one reveals a fine-grained feature.'),
  ('1.6',
   'Modality (unimodal, bimodal) and normality can never be determined from a boxplot -- only skew direction, inferred from comparing box-section and whisker lengths -- and the 2025 Chief Reader Report names describing boxplot shape as symmetric, normal, or unimodal the single most repeated scoring error across the entire exam.',
   'Shape determines which summary statistics are trustworthy later in 1.7-1.8 (mean versus median, for instance), so a shape claim has to come from the graph type actually given -- a histogram or dotplot shows modality directly, but a boxplot only ever supports a skew-direction claim.',
   'Scoring guidelines explicitly bar full credit whenever a shape description of a boxplot uses the words symmetric, normal, or unimodal -- from a boxplot, only a skew-direction statement backed by comparing section lengths earns credit.',
   'If you''re given a boxplot, describe only skew direction (by comparing box-section and whisker lengths on each side) and never claim unimodal, bimodal, or symmetric/normal shape from it; if you''re given a histogram or dotplot, modality is visible and can be described directly.',
   'Given only a boxplot of delivery times with a longer right whisker and a right-shifted median line within the box, a student describes the distribution as approximately normal.',
   'The distribution looks approximately normal based on the boxplot.',
   'Modality and normality can never be read off a boxplot -- only skew direction can, from comparing section and whisker lengths; here the longer right whisker and the median positioned closer to Q1 than Q3 both indicate the distribution is right-skewed, which is the only shape claim a boxplot alone can support.',
   'Calling a boxplot''s shape symmetric, normal, or unimodal -- modality can never be read off a boxplot, only skew direction can, and only by comparing section lengths.',
   'Head to practice and, whenever a boxplot is the only graph given, restrict your shape claim to skew direction only.'),
  ('1.7',
   'A value counts as an outlier under either of two CED-given rules -- more than 1.5 times the IQR beyond Q1/Q3, or more than 2 standard deviations from the mean -- with no stated preference between them, so either rule earns credit as long as the calculation supporting it is shown.',
   'A documented, exam-worthy error is finding the median of two combined groups by averaging the two groups'' separate medians instead of re-sorting all values together and finding the true middle position of the full combined list -- the shortcut looks plausible but is mathematically wrong.',
   'Full credit requires stating the actual numeric median or mean from the problem to support a mean-median relationship claim -- correctly describing the relationship in words alone, without the specific numbers, earns only partial credit.',
   'When comparing mean and median, state the actual numeric median (and mean, if given or calculable) from the problem, not just the mean is pulled above the median in the abstract; when combining two groups'' data into one dataset, re-sort all values together and find the middle position of the full combined list rather than averaging the two separate medians.',
   'Group A (5 values) has median 12, and Group B (5 values) has median 20. A student combines the two groups into one 10-value dataset and reports its median as (12+20)/2 = 16.',
   'The combined dataset''s median is 16, the average of the two group medians.',
   'Averaging the two group medians is not a valid way to find the combined dataset''s median -- the correct method re-sorts all 10 values together into one ordered list and finds the mean of the 5th and 6th values in that combined order, which will only coincidentally equal 16; the two separate medians don''t determine the combined median without knowing every individual value.',
   'Stating the mean-median relationship correctly in words but never writing down the actual numeric values from the problem to support it.',
   'Back to practice: whenever a question asks for a combined-group median, re-sort all individual values together rather than averaging the separate medians.'),
  ('1.8',
   'A boxplot''s whisker stops at the most extreme non-outlier value, not at an outlier itself -- outliers are plotted as separate points beyond the whisker -- and the mean-versus-median position rule (mean pulled toward the longer tail under skew) follows directly from whichever outlier rule from 1.7 was applied to build the five-number summary.',
   'Boxplots are the standard tool for comparing multiple groups'' distributions side by side, so a whisker drawn incorrectly out to an outlier misrepresents both that single distribution''s spread and any group comparison built on top of it.',
   'Constructing a boxplot correctly requires the five-number summary computed first, outliers identified and plotted separately rather than absorbed into the whisker, and the mean-median position rule applied correctly to the skew direction shown.',
   'When constructing a boxplot, first check every value against the outlier rule and plot outliers as separate points -- stop the whisker at the most extreme non-outlier value instead of stretching it all the way to an outlier.',
   'A dataset''s five-number summary is min=2, Q1=10, median=15, Q3=20, max=52, with 52 flagged as an outlier by the 1.5xIQR rule. A student draws the right whisker extending all the way to 52.',
   'The right whisker should extend to the maximum value, 52.',
   'Since 52 is flagged as an outlier by the 1.5xIQR rule, the right whisker should stop at the most extreme non-outlier value below 52, and 52 should be plotted as a separate point beyond the whisker -- stretching the whisker to an outlier misrepresents the boxplot''s middle-50%-and-spread structure.',
   'Drawing the whisker all the way out to an outlier value instead of stopping it at the last non-outlier point and marking the outlier separately.',
   'Return to practice and, before drawing any whisker, check the outlier rule against every extreme value first.'),
  ('1.9',
   'The z-score formula z=(x-mean)/SD is reused identically whether population parameters (mu, sigma) or sample statistics (x-bar, s) are available -- the CED gives no separate notation for the sample-statistic version, so the same formula and same interpretation apply either way.',
   'z-scores put two individuals from two different distributions -- like two different tests with different means and spreads -- onto one common comparable scale, and this exact computation reappears later in the course inside probability and inference formulas.',
   'Credit requires the z-score computed using that specific individual''s own group''s mean and standard deviation, and then the sign and magnitude interpreted in context, not left as a bare unlabeled number.',
   'When comparing two individuals from two different distributions, compute a separate z-score for each person using that person''s own group''s mean and standard deviation, then compare the z-scores directly rather than comparing the raw values.',
   'On Test A (mean 70, SD 5), Maria scores 80. On Test B (mean 500, SD 100), Josh scores 580. A student concludes Josh performed better since 580 is a bigger raw improvement over the mean than Maria''s 10-point gap.',
   'Josh did better because his score is 80 points above his test''s mean, compared to Maria''s 10 points above hers.',
   'Comparing raw point gaps across two different distributions is invalid -- converting to z-scores first, Maria''s is (80-70)/5=2.0 and Josh''s is (580-500)/100=0.8, so Maria actually performed better relative to her own test''s distribution, standing 2 standard deviations above the mean compared to Josh''s 0.8.',
   'Comparing raw scores directly across two different distributions instead of converting each to a z-score first using its own group''s mean and standard deviation.',
   'Go to practice and, whenever comparing two people across two different tests or distributions, compute both z-scores before drawing any conclusion.'),
  ('1.10',
   'The defining test for observational versus experimental is whether the researcher imposed a treatment -- tracking or measuring subjects over time, even repeatedly, is still observational unless a treatment was actively assigned, and observational studies split further into prospective (forward-looking) and retrospective (looking back at existing records).',
   'This classification determines whether a causal claim is ever justified from the study -- only a well-designed experiment (1.13) can support cause-and-effect, so correctly naming a study as observational is also implicitly a signal that no causal conclusion can be drawn from it.',
   'Credit requires the observational/experimental classification made correctly first, based specifically on whether a treatment was imposed, and then, only for observational studies, the prospective-versus-retrospective distinction made based on the direction data collection moves in time.',
   'When classifying a study, ask first whether the researcher imposed a treatment (experiment) or just measured/recorded existing conditions (observational); only if it''s observational, then ask whether data collection moves forward from now (prospective) or looks back at existing records (retrospective).',
   'Researchers track a group of runners'' knee health by recording their training logs over the next five years as the runners train however they choose. A student classifies this as an experiment since the runners were tracked over time.',
   'This is an experiment because the researchers followed the runners'' knee health over five years.',
   'This is an observational study, not an experiment, because the researchers never imposed a treatment -- the runners trained however they chose, and the researchers only recorded outcomes; since data collection moves forward from now, this is specifically a prospective observational study.',
   'Calling a study an experiment just because researchers measured or tracked subjects over time, without checking whether a treatment was actually imposed.',
   'Back to practice: before classifying any described study, ask specifically whether a treatment was imposed by the researcher, not just whether subjects were tracked over time.'),
  ('1.11',
   'Cluster sampling and stratified sampling are near-opposites that get confused often -- stratified sampling takes a separate random sample from within every stratum, while cluster sampling randomly selects a few whole clusters and then samples every unit within only those selected clusters, leaving the other clusters entirely unsampled.',
   'Naming the wrong specific bias type after correctly spotting that a sampling method is flawed is a documented, exam-worthy error -- undercoverage, voluntary response, nonresponse, and response/question-wording bias are each a distinct, precisely defined failure mode, not interchangeable labels for any sampling problem.',
   'Correctly identifying a sampling method (SRS, stratified, cluster, or systematic) requires matching its specific mechanism, not just recognizing that randomness was involved, and correctly identifying bias requires naming the one specific type that matches the described flaw.',
   'When identifying bias in a described sampling procedure, name the single most precise bias term that fits the described flaw (undercoverage, voluntary response, nonresponse, or response bias) rather than a vague or unrelated term like confounding or small sample size.',
   'A researcher randomly selects 8 apartment buildings from a city of 200 buildings, then surveys every household in only those 8 buildings. A student calls this a stratified random sample.',
   'This is a stratified random sample because buildings were randomly chosen and then surveyed.',
   'This is a cluster sample, not a stratified sample -- the researcher randomly selected whole clusters (the 8 buildings) and then sampled every household within only those selected clusters; a stratified sample would instead take a separate random sample of households from within every one of the 200 buildings, not skip most of them entirely.',
   'Correctly noticing a sampling method is biased but naming the wrong specific type, such as calling undercoverage confounding or blaming sample size.',
   'Return to practice and, when a sampling method skips most of the population''s groups entirely after a first random selection, check for cluster sampling before assuming stratified.'),
  ('1.12',
   'A sampling procedure described only as generate random numbers is incomplete for full credit -- an exam-worthy response must specify the exact number range used, what happens when a number repeats (skip it), and precisely how each generated number maps back to one specific individual on a labeled list.',
   'This topic tests the difference between knowing what a random sample is (1.11) and being able to describe, step by step, exactly how you would generate one from a real population list -- a correct-sounding method with a missing implementation detail is still incomplete.',
   'Full credit on a describe-the-procedure item requires all three implementation details present: the exact range of random numbers matched to how individuals are labeled, the handling of a repeated number, and the exact rule mapping a number back to an individual.',
   'When asked to describe a sampling procedure, write out the concrete implementation details as a numbered process: label every individual, state the exact number range you''ll generate from, state what happens on a repeat number, and state exactly how a number selects a specific individual -- not just use a random number generator.',
   'A class of 30 students is numbered 1-30. A student describes the sampling procedure as use a random number generator to pick 10 students.',
   'Use a random number generator to pick 10 students from the class.',
   'Label the 30 students 01 through 30, generate random two-digit numbers from 01 to 30, skip any number that repeats or falls outside 01-30, and continue until 10 distinct numbers are generated, selecting the students whose labels match those numbers -- specifying the exact label range, the repeat-handling rule, and the number-to-individual mapping is what makes this a complete implementation, not just naming a random number generator.',
   'Describing a sampling procedure as just generate random numbers without specifying the number range, how repeats are handled, or how numbers map to individuals.',
   'Head back to practice and, for any describe-the-sampling-procedure item, check that your answer states the label range, the repeat rule, and the mapping rule explicitly.'),
  ('1.13',
   'The placebo effect has a precise, testable CED definition -- the measured difference between a placebo group''s average response and a true no-treatment group''s average response -- which is a sharper claim than merely fake treatment with no effect, since it requires an actual no-treatment comparison group to even be defined.',
   'This is the only topic in the unit that supports a cause-and-effect conclusion, so the four requirements (comparison of treatment groups, random assignment, replication, direct control of extraneous variables) function as the checklist for whether any later causal claim in the course is even valid.',
   'Points require naming every applicable required element when critiquing or designing an experiment, correctly distinguishing single- from double-blind, and, whenever the placebo effect is invoked, defining it as the measured outcome difference against a genuine no-treatment group, not just as subjects believing they were treated.',
   'When defining or invoking the placebo effect, state it as the difference in average response between a placebo group and a true no-treatment group, not merely as subjects believe they got treated -- the placebo effect is that measured difference, not the belief itself.',
   'A study gives one group a sugar pill and compares their reported pain relief to a second group given nothing at all. A student defines the placebo effect as when the pill group just imagines they feel better because they think they got real medicine.',
   'The placebo effect is when the pill group imagines feeling better because they believe they received real medicine.',
   'The placebo effect is specifically the measured difference between the placebo group''s average reported pain relief and the no-treatment group''s average reported pain relief -- defining it only as subjects'' belief, without the actual comparison to a genuine no-treatment group''s average response, misses the precise, measurable definition this course requires.',
   'Defining the placebo effect as just a fake treatment with no effect instead of the actual measured difference between a placebo group and a no-treatment group.',
   'Return to practice and, whenever a question invokes the placebo effect, state it as a measured difference between two groups'' averages, not as a description of what subjects believe.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_STATISTICS_2027_CED_FACT_PACK.md section 10 Unit 1 deep-tier detail (the 2026 FRQ Q1 stem-and-leaf-vs-boxplot gap/cluster contrast for 1.5; the 2025 Chief Reader Report''s most-repeated boxplot-shape scoring error for 1.6; the CED''s dual undated outlier rules and the documented combined-median averaging error for 1.7; the whisker-stops-at-non-outlier construction rule for 1.8; the reused population/sample z-score formula for 1.9; the treatment-imposed observational/experimental test for 1.10; the CED''s cluster-vs-stratified opposite-mechanism distinction for 1.11; the documented sampling-procedure implementation-completeness distractor for 1.12; and the CED''s precise measured-difference placebo-effect definition for 1.13; 1.1-1.4 grounded in the fact pack''s structural/EK statements where no misconception data was available); briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-statistics-unit1-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_statistics'
  and e.unit_number = 1
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_statistics' and unit_number=1 and status='published'
      and source_note like '%unit1-explainer-repair%';
  if v_repaired <> 13 then
    raise exception 'expected 13 repaired AP Statistics Unit 1 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_statistics' and b.unit_number=1 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Statistics Unit 1 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
