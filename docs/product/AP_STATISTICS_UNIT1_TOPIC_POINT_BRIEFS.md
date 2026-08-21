# AP Statistics Unit 1 Topic Point Briefs

Status: Draft content system seed for new-user home and unit selector planning.

Purpose: preserve Cramapple-original topic point brief content for AP
Statistics Unit 1 (Exploring One-Variable Data and Collecting Data). These
briefs help a new student understand how each topic turns into
point-attainment behavior without replacing a full lesson.

Source basis: AP Statistics Course and Exam Description, plus the local CED
fact pack in `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md` (Unit 1
deep-tier detail, including documented 2025 Chief Reader Report
misconception patterns — note that fact pack section is marked unreviewed
pending SME sign-off; treat this brief set with the same caveat until that
sign-off lands).

Topic titles were verified verbatim against the primary-source PDF
(`subject packs/Statistics/ap-statistics-course-and-exam-description.pdf`,
"Course at a Glance," Unit 1 topic list) to match the approved §3 topic map
exactly, since §3 itself carries deferred (not waived) SME confirmation.

Content rules: same as the AP Chemistry / Physics / Calculus / Biology Unit
1 briefs — no external links, no copied third-party language, subject- and
topic-specific, concept tied to point-earning behavior.

## Type

```ts
type Importance = "not-important" | "somewhat-important" | "very-important";

type TopicPointBrief = {
  unitId: string;
  topicId: string;
  title: string;
  classImportance: Importance;
  examImportance: Importance;
  whatItIs: string;
  whyItMatters: string;
  howPointsAreEarned: string;
  answerMove: string;
  commonPointLoss: string;
  learnMorePath: string;
  practiceParams: {
    subject: string;
    unit: string;
    topic: string;
  };
};
```

## Unit 1 Seed Content

```ts
const apStatisticsUnit1TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-1",
    topicId: "1.1",
    title: "Introducing Statistics: What Can We Learn from Data?",
    classImportance: "somewhat-important",
    examImportance: "not-important",
    whatItIs:
      "Statistics is the science of collecting, describing, and drawing conclusions from data that varies — every real dataset has variability, and a good investigative question asks what pattern or explanation exists behind that variability.",
    whyItMatters:
      "This framing sets up the whole course: every unit that follows is really just a different tool for answering an investigative question in the presence of variability, from simple graphs to inference.",
    howPointsAreEarned:
      "This topic is not tested as a standalone skill on the exam — it is the conceptual frame that later free-response questions assume you already understand when they ask you to connect a statistical procedure back to a real-world question.",
    answerMove:
      "When a free-response question opens with a real-world scenario, read the investigative question first and keep referring back to it in context — this habit matters most in later inference units, not as its own gradable step here.",
    commonPointLoss:
      "Treating statistics as just calculating numbers instead of connecting those numbers back to the real question the data was collected to answer.",
    learnMorePath: "/learn/ap-statistics/unit-1/investigative-question",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.1" },
  },
  {
    unitId: "unit-1",
    topicId: "1.2",
    title: "Variables",
    classImportance: "very-important",
    examImportance: "somewhat-important",
    whatItIs:
      "Every variable is either categorical (labels/categories) or quantitative (numeric measurements), and quantitative variables are further either discrete (countable, gaps between values) or continuous (any value in an interval). A parameter describes a population (size N); a statistic describes a sample (size n).",
    whyItMatters:
      "This vocabulary determines which graph types, summary statistics, and inference procedures are even valid to use later in the course — using a mean on a categorical variable, for example, is a category error, not just an arithmetic mistake.",
    howPointsAreEarned:
      "Multiple-choice and free-response items expect you to correctly classify a described variable and to use parameter/statistic and population/sample language precisely when a question asks you to identify what a number represents.",
    answerMove:
      "When a question gives you a variable description, decide categorical-vs-quantitative first, then (if quantitative) discrete-vs-continuous, before choosing any graph or statistic — this classification step is specific to reading the variable, not to analyzing it.",
    commonPointLoss:
      "Mixing up parameter and statistic, or calling a numeric label (like a zip code) quantitative just because it's written as digits.",
    learnMorePath: "/learn/ap-statistics/unit-1/variables-vocabulary",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.2" },
  },
  {
    unitId: "unit-1",
    topicId: "1.3",
    title: "Tabular Representation and Summary Statistics for One Categorical Variable",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "A frequency table lists the count of observational units in each category of a categorical variable; a relative frequency table converts each count to a proportion by dividing by the total.",
    whyItMatters:
      "Tables are the raw material for the bar charts in 1.4 and for two-way table reasoning later in the course — getting the count-vs-proportion distinction right here prevents errors downstream.",
    howPointsAreEarned:
      "You earn credit by correctly computing relative frequencies (count divided by total, not count divided by number of categories) and by labeling values as counts or proportions/percentages exactly as the question asks.",
    answerMove:
      "When asked for a relative frequency, divide the category count by the total number of observational units in the whole table, not by the number of rows or categories.",
    commonPointLoss:
      "Dividing a category's count by the number of categories instead of by the total number of observations.",
    learnMorePath: "/learn/ap-statistics/unit-1/categorical-tables",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.3" },
  },
  {
    unitId: "unit-1",
    topicId: "1.4",
    title: "Graphical Representations for One Categorical Variable",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "A bar chart displays a categorical variable's frequencies or relative frequencies as separate, non-touching bars, one per category.",
    whyItMatters:
      "It's the standard visual for categorical data throughout the course, including comparisons across groups using side-by-side bar charts.",
    howPointsAreEarned:
      "Points depend on correct construction — accurately-scaled axis, one bar per category with equal width and gaps between bars — and on correctly reading values off a given bar chart when asked to compare categories.",
    answerMove:
      "When constructing or reading a bar chart, keep the bars separated with gaps (never touching) and check whether the vertical axis is counts or relative frequencies before comparing bar heights across two charts.",
    commonPointLoss:
      "Drawing or reading bars as if they touch like a histogram, or comparing two bar charts on different scales without noticing the axes don't match.",
    learnMorePath: "/learn/ap-statistics/unit-1/categorical-bar-charts",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.4" },
  },
  {
    unitId: "unit-1",
    topicId: "1.5",
    title: "Graphical Representations for One Quantitative Variable",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Histograms, stem-and-leaf plots, and dotplots all display the distribution of a single quantitative variable, but each preserves different information — a stem-and-leaf plot and dotplot keep every individual data value visible, while a histogram groups values into bins and loses the individual values.",
    whyItMatters:
      "Choosing the right graph type is itself a tested skill, because some features of a distribution (like a gap or cluster inside one histogram bin) are only visible in a graph that shows individual values.",
    howPointsAreEarned:
      "Free-response questions can ask you to justify which graph type reveals a specific feature (like a gap within what a histogram would show as a single bin) — credit requires naming the graph type and explaining what individual-value information it preserves that a coarser graph would hide.",
    answerMove:
      "When a question asks which graph best reveals a specific feature like a small gap or cluster, choose a graph that shows every individual data value (stem-and-leaf plot or dotplot) over a histogram, and explain that histogram bins can hide sub-bin structure.",
    commonPointLoss:
      "Assuming any graph of a quantitative variable shows the same information, when a histogram's bins can actually hide gaps or clusters that a stem-and-leaf plot or dotplot would reveal.",
    learnMorePath: "/learn/ap-statistics/unit-1/quantitative-graphs",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.5" },
  },
  {
    unitId: "unit-1",
    topicId: "1.6",
    title: "Descriptions for One Quantitative Variable Distributions",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A distribution's shape is described by skew direction (left/right), modality (unimodal, bimodal, multimodal, or uniform), and notable features like outliers, gaps, and clusters — read directly off a histogram, dotplot, or stem-and-leaf plot.",
    whyItMatters:
      "Shape determines which summary statistics are appropriate to trust later (1.7-1.8) and is one of the most heavily and repeatedly tested description skills in the course.",
    howPointsAreEarned:
      "You must name shape features using the graph actually given, and — critically — modality (unimodal/bimodal) and normality can never be determined from a boxplot alone; from a boxplot only skew direction is describable, and only by comparing the relative lengths of the box sections and whiskers, not by eyeballing overall lopsidedness.",
    answerMove:
      "If you're given a boxplot, describe only skew direction (by comparing box-section and whisker lengths on each side) and never claim unimodal, bimodal, or symmetric/normal shape from it; if you're given a histogram or dotplot, modality is visible and can be described directly.",
    commonPointLoss:
      "Calling a boxplot's shape 'symmetric,' 'normal,' or 'unimodal' — modality can never be read off a boxplot, only skew direction can, and only by comparing section lengths.",
    learnMorePath: "/learn/ap-statistics/unit-1/distribution-shape",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.6" },
  },
  {
    unitId: "unit-1",
    topicId: "1.7",
    title: "Summary Statistics for One Quantitative Variable",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Mean, median, range, IQR, standard deviation, and variance numerically summarize center and spread; median and IQR are resistant to outliers/skew, while mean, range, and standard deviation are not. An outlier is flagged as more than 1.5 times the IQR beyond Q1/Q3, or as more than 2 standard deviations from the mean — the CED gives both rules with no preference stated.",
    whyItMatters:
      "These numeric summaries are the computational backbone for every later comparison, boxplot, and z-score calculation in the unit, and resistance is a recurring reasoning tool for justifying which statistic to trust.",
    howPointsAreEarned:
      "Points require both the correct concept (for example, mean pulled above median by a right skew or high outlier) and the actual numeric values from the problem stated to back it up — a correct claim without the specific numbers earns only partial credit. When outlier status is asked, either the 1.5-IQR rule or the 2-standard-deviation rule is acceptable, but you must show the calculation for whichever one you pick. When merging two datasets' medians, you must reorder all combined values and find the true middle position — averaging the two groups' separate medians is not valid.",
    answerMove:
      "When comparing mean and median, state the actual numeric median (and mean, if given or calculable) from the problem, not just 'the mean is pulled above the median' in the abstract; when combining two groups' data into one dataset, re-sort all values together and find the middle position of the full combined list rather than averaging the two separate medians.",
    commonPointLoss:
      "Stating the mean-median relationship correctly in words but never writing down the actual numeric values from the problem to support it.",
    learnMorePath: "/learn/ap-statistics/unit-1/summary-statistics",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.7" },
  },
  {
    unitId: "unit-1",
    topicId: "1.8",
    title: "Graphical Representations of Summary Statistics for One Quantitative Variable",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "The five-number summary (min, Q1, median, Q3, max) is displayed as a boxplot: the box spans the middle 50% of data (Q1 to Q3), whiskers extend to the most extreme non-outlier values, and outliers are plotted as separate points beyond the whiskers.",
    whyItMatters:
      "Boxplots are the standard tool for visually comparing multiple groups' distributions side by side and for applying the mean-vs-median position rule tied to skew.",
    howPointsAreEarned:
      "Constructing a boxplot correctly requires computing the five-number summary first, correctly identifying and separately plotting any outliers rather than extending a whisker to them, and applying the position rule: mean is close to median when symmetric, mean is greater than median under right skew, mean is less than median under left skew.",
    answerMove:
      "When constructing a boxplot, first check every value against the outlier rule and plot outliers as separate points — stop the whisker at the most extreme non-outlier value instead of stretching it all the way to an outlier.",
    commonPointLoss:
      "Drawing the whisker all the way out to an outlier value instead of stopping it at the last non-outlier point and marking the outlier separately.",
    learnMorePath: "/learn/ap-statistics/unit-1/boxplot-construction",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.8" },
  },
  {
    unitId: "unit-1",
    topicId: "1.9",
    title: "Comparisons of the Distributions for One Quantitative Variable",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A z-score, z = (value minus mean) divided by standard deviation, converts a raw value into the number of standard deviations it sits above or below the mean, using the same formula whether you're given true population parameters or sample statistics.",
    whyItMatters:
      "z-scores let you compare an individual's standing across two different distributions (like two different tests) on a common scale, and the same formula reappears throughout the course in probability and inference units.",
    howPointsAreEarned:
      "Credit requires computing the z-score correctly with the right mean and standard deviation for the specific distribution in question, and then interpreting its sign and magnitude in context (for example, 'this value is 1.4 standard deviations above the mean of this group').",
    answerMove:
      "When comparing two individuals from two different distributions, compute a separate z-score for each person using that person's own group's mean and standard deviation, then compare the z-scores directly rather than comparing the raw values.",
    commonPointLoss:
      "Comparing raw scores directly across two different distributions instead of converting each to a z-score first using its own group's mean and standard deviation.",
    learnMorePath: "/learn/ap-statistics/unit-1/z-scores",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.9" },
  },
  {
    unitId: "unit-1",
    topicId: "1.10",
    title: "The Investigative Question Revisited and Data Collection",
    classImportance: "very-important",
    examImportance: "somewhat-important",
    whatItIs:
      "An observational study records data without intervening on subjects, while an experiment imposes a treatment; observational studies are further split into prospective (collected going forward from now) and retrospective (collected by looking back at past records).",
    whyItMatters:
      "This distinction determines whether a causal claim is ever justified — only a well-designed experiment can support cause-and-effect, which becomes central once 1.13 introduces experimental design.",
    howPointsAreEarned:
      "You earn credit by correctly classifying a described study as observational or experimental, and observational studies further as prospective or retrospective, based on whether a treatment was imposed and whether data collection looks forward or backward in time.",
    answerMove:
      "When classifying a study, ask first whether the researcher imposed a treatment (experiment) or just measured/recorded existing conditions (observational); only if it's observational, then ask whether data collection moves forward from now (prospective) or looks back at existing records (retrospective).",
    commonPointLoss:
      "Calling a study an experiment just because researchers measured or tracked subjects over time, without checking whether a treatment was actually imposed.",
    learnMorePath: "/learn/ap-statistics/unit-1/observational-vs-experiment",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.10" },
  },
  {
    unitId: "unit-1",
    topicId: "1.11",
    title: "Random Sampling",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A census surveys the entire population; a sample surveys part of it. The four sampling methods are simple random sample (every possible group of the target size equally likely), stratified random sample (a separate random sample taken within every stratum), cluster sample (a few whole clusters randomly selected, then every unit within only those clusters is sampled), and systematic random sample (every kth unit from a randomly-started list). The four named bias types are voluntary response bias, undercoverage, nonresponse bias, and response/question-wording bias.",
    whyItMatters:
      "Correctly identifying sampling method and bias type is foundational to judging whether any study's conclusions can be trusted or generalized to the population.",
    howPointsAreEarned:
      "Points require using the exact correct vocabulary term for the sampling method or bias type described — recognizing that 'something is biased' is not enough; you must name which specific bias (for example undercoverage vs. nonresponse) or which specific method (stratified vs. cluster) applies, since cluster and stratified are structural opposites.",
    answerMove:
      "When identifying bias in a described sampling procedure, name the single most precise bias term that fits the described flaw (undercoverage, voluntary response, nonresponse, or response bias) rather than a vague or unrelated term like 'confounding' or 'small sample size.'",
    commonPointLoss:
      "Correctly noticing a sampling method is biased but naming the wrong specific type, such as calling undercoverage 'confounding' or blaming sample size.",
    learnMorePath: "/learn/ap-statistics/unit-1/sampling-methods-bias",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.11" },
  },
  {
    unitId: "unit-1",
    topicId: "1.12",
    title: "Potential Problems with Sampling",
    classImportance: "somewhat-important",
    examImportance: "very-important",
    whatItIs:
      "This topic covers the practical mechanics of actually carrying out a random sampling procedure step by step, not just naming a sampling method.",
    whyItMatters:
      "The AP exam distinguishes between knowing what a random sample is (1.11) and being able to describe, in enough operational detail, exactly how you would generate one from a real list of individuals.",
    howPointsAreEarned:
      "Full credit on a 'describe how you would select a random sample' free-response prompt requires specifying: the exact range of random numbers to use (matched to how individuals are labeled), what happens if a number repeats or is generated twice (skip it), and precisely how a generated number maps back to a specific individual on the population list.",
    answerMove:
      "When asked to describe a sampling procedure, write out the concrete implementation details as a numbered process: label every individual, state the exact number range you'll generate from, state what happens on a repeat number, and state exactly how a number selects a specific individual — not just 'use a random number generator.'",
    commonPointLoss:
      "Describing a sampling procedure as just 'generate random numbers' without specifying the number range, how repeats are handled, or how numbers map to individuals.",
    learnMorePath: "/learn/ap-statistics/unit-1/sampling-implementation",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.12" },
  },
  {
    unitId: "unit-1",
    topicId: "1.13",
    title: "Experimental Design",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A well-designed experiment needs comparison of two or more treatment groups, random assignment of subjects to treatments, replication (enough subjects per group), and direct control of extraneous variables. Blinding can be single (subjects don't know their treatment) or double (subjects and evaluators don't know). The placebo effect is specifically the measurable difference between the average response of a placebo group and the average response of a true no-treatment group. Designs include completely randomized, randomized block, and matched-pairs.",
    whyItMatters:
      "This is the only topic in the unit that supports a cause-and-effect conclusion, making it the conceptual foundation for every later claim in the course about what a study can and cannot prove.",
    howPointsAreEarned:
      "Points require naming all applicable required elements (comparison, random assignment, replication, control) when critiquing or designing an experiment, correctly distinguishing single- from double-blind, and — if the placebo effect is invoked — defining it as the measured outcome difference between a placebo group and a genuine no-treatment group, not just as 'a fake treatment.'",
    answerMove:
      "When defining or invoking the placebo effect, state it as the difference in average response between a placebo group and a true no-treatment group, not merely as 'subjects believe they got treated' — the placebo effect is that measured difference, not the belief itself.",
    commonPointLoss:
      "Defining the placebo effect as just 'a fake treatment with no effect' instead of the actual measured difference between a placebo group and a no-treatment group.",
    learnMorePath: "/learn/ap-statistics/unit-1/experimental-design",
    practiceParams: { subject: "ap_statistics", unit: "1", topic: "1.13" },
  },
];
```
