# AP Statistics Unit 2 Topic Point Briefs

Status: Draft content system seed, pending QA.

Deployment state is deliberately NOT asserted here — it drifts. The canonical
record of where these rows exist is the migration
(`supabase/migrations/20260821030000_chemistry_statistics_unit2_topic_point_briefs_seed.sql`)
and the `app.topic_point_briefs` table in each environment.

Purpose: preserve Cramapple-original topic point brief content for AP
Statistics Unit 2 (Probability, Random Variables, and Probability
Distributions, 15-25% of the MC exam). These briefs help a student
understand how each topic turns into point-attainment behavior without
replacing a full lesson.

Source basis: AP Statistics Course and Exam Description, plus the local CED
fact pack in `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md` (Unit 2
deep-tier detail, §10 — which carries its own UNREVIEWED status pending
Jill/Orly sign-off, separate from the fact pack's §1-§9 APPROVED status;
treat this brief set with that same caveat).

Topic titles are verbatim from the §3 topic map, itself verified against the
primary-source PDF (`subject packs/Statistics/ap-statistics-course-and-exam-description.pdf`,
"Course at a Glance," p. 15).

Removed-content guard: per fact pack §8, **combining random variables** and
the **geometric distribution** are removed from the current course. Topic 2.9
covers expected value and standard deviation only; topic 2.10 covers the
binomial distribution only. Neither removed topic appears in these briefs.

Content rules: same as the AP Statistics Unit 1 briefs — no external links,
no copied third-party language, subject- and topic-specific, concept tied to
point-earning behavior.

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

## Unit 2 Seed Content

```ts
const apStatisticsUnit2TopicPointBriefs: TopicPointBrief[] = [
  {
    unitId: "unit-2",
    topicId: "2.1",
    title:
      "Tabular and Graphical Representations for the Distributions of Two Categorical Variables",
    classImportance: "very-important",
    examImportance: "somewhat-important",
    whatItIs:
      "A two-way (contingency) table cross-classifies every individual by two categorical variables at once, with the cell counts in the body, the row and column totals in the margins, and the grand total in the corner. The same data can be displayed as a segmented (stacked) bar chart or a side-by-side bar chart.",
    whyItMatters:
      "This is the first time in the course that two variables are examined together rather than one distribution at a time, and the cells of a two-way table are literally the events whose joint, marginal, and conditional probabilities you compute in 2.2 and again in 2.4 through 2.7.",
    howPointsAreEarned:
      "You earn credit for correctly locating a requested count in the table (cell versus row total versus column total versus grand total), for building or completing a two-way table from a described scenario, and for reading a segmented or side-by-side bar chart back into the counts or percentages it represents.",
    answerMove:
      "Before extracting any number from a two-way table, write down in words what the row variable is, what the column variable is, and what a single cell counts — this labeling step is what keeps you from grabbing a margin when a cell was asked for.",
    commonPointLoss:
      "Treating a segmented bar chart's percentages as counts, so groups of very different sizes look equally large.",
    learnMorePath: "/learn/ap-statistics/unit-2/two-way-tables-and-graphs",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.1" },
  },
  {
    unitId: "unit-2",
    topicId: "2.2",
    title: "Summary Statistics for Two Categorical Variables",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Three different relative frequencies computed from the same two-way table: a joint relative frequency is one cell divided by the table total; a marginal relative frequency is a whole row or column total divided by the table total; a conditional relative frequency is a cell divided by its own row or column total. Same numerator, three different denominators.",
    whyItMatters:
      "Which total you divide by is the entire skill here, and it is the same distinction that reappears as joint, marginal, and conditional probability in 2.6. Comparing conditional relative frequencies across groups is also how you argue two categorical variables are or are not associated.",
    howPointsAreEarned:
      "You earn credit for computing the requested relative frequency with the correct denominator, for stating which group the percentage describes, and for comparing conditional distributions across groups and drawing the association conclusion those comparisons support rather than just restating the numbers.",
    answerMove:
      "For every percentage you report from a two-way table, write it as a sentence in the form 'of the [group in the denominator], ___% are [category in the numerator]' — if you cannot name the denominator group, you divided by the wrong total.",
    commonPointLoss:
      "Dividing a cell by the grand total when the question asked 'of the seniors,' which requires dividing by that row's own total.",
    learnMorePath:
      "/learn/ap-statistics/unit-2/joint-marginal-conditional-relative-frequency",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.2" },
  },
  {
    unitId: "unit-2",
    topicId: "2.3",
    title: "Estimating Probabilities Using Simulation",
    classImportance: "very-important",
    examImportance: "somewhat-important",
    whatItIs:
      "A simulation models a chance process by running many artificial trials — with a random digit table, a spinner, cards, or technology — and estimates a probability as the proportion of trials in which the outcome of interest happened. The Law of Large Numbers is the justification: as trials grow, that long-run relative frequency approaches the true probability.",
    whyItMatters:
      "Simulation is the course's escape hatch for probabilities that are awkward to compute with a formula, and the same design-and-count logic returns later for randomization distributions and simulation-based inference. It is also where 'long-run relative frequency' gets its meaning.",
    howPointsAreEarned:
      "You earn credit for describing a complete simulation design: what device generates the randomness, how digits map to real-world outcomes, what counts as one trial and when a trial stops, what you record each trial, and dividing successful trials by total trials to state an estimated probability.",
    answerMove:
      "When you describe a simulation, explicitly state where one trial ends and what you write down at that moment; a design that assigns digits but never defines the stopping point and the recorded quantity is incomplete even if your estimate is right.",
    commonPointLoss:
      "Reporting a simulation estimate as the exact probability, instead of an estimate that gets closer to the truth as trials increase.",
    learnMorePath:
      "/learn/ap-statistics/unit-2/simulation-and-long-run-relative-frequency",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.3" },
  },
  {
    unitId: "unit-2",
    topicId: "2.4",
    title: "Introduction to Probability",
    classImportance: "very-important",
    examImportance: "somewhat-important",
    whatItIs:
      "Probability measures how often an outcome happens in the long run. When every outcome in the sample space is equally likely, P(E) = (number of outcomes in E) / (total number of outcomes). Every probability satisfies 0 <= P(E) <= 1, and the complement rule says P(not E) = 1 - P(E).",
    whyItMatters:
      "This topic sets ground rules the rest of the unit assumes without restating: the counting formula only works under equal likelihood, and the complement rule is the shortcut that makes 'at least one' problems tractable in 2.7 and in binomial problems in 2.10.",
    howPointsAreEarned:
      "You earn credit for listing or counting the sample space correctly, for applying the equally-likely formula only when the setup justifies it, for using the complement rule to convert an 'at least one' or 'none' question into its easier opposite, and for reporting a value between 0 and 1.",
    answerMove:
      "When a question asks for 'at least one,' compute P(none) and subtract from 1 rather than adding up cases — but check first that 'none' is genuinely the only complementary outcome, since the shortcut only works when the two events partition the sample space.",
    commonPointLoss:
      "Using outcomes-divided-by-total when the outcomes are not equally likely, such as unequal spinner sectors or weighted categories.",
    learnMorePath:
      "/learn/ap-statistics/unit-2/probability-basics-and-complements",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.4" },
  },
  {
    unitId: "unit-2",
    topicId: "2.5",
    title: "Mutually Exclusive Events",
    classImportance: "somewhat-important",
    examImportance: "somewhat-important",
    whatItIs:
      "Two events are mutually exclusive (disjoint) exactly when they cannot both happen on the same trial — formally, the probability of both occurring together is zero. There is no overlap between them in the sample space; a single card cannot be both a heart and a spade.",
    whyItMatters:
      "Mutual exclusivity is the condition that makes the addition rule collapse to a simple sum, and it is the most confused idea in the unit because students hear 'cannot happen together' and think 'unrelated,' which is independence. Anchoring it here protects 2.6 and 2.7 from collapsing into each other.",
    howPointsAreEarned:
      "You earn credit for deciding whether two described events can occur on the same trial, for supporting that decision with a zero overlap or with a nonzero overlap you can point to in a table or Venn diagram, and for recognizing when disjointness lets you add probabilities directly.",
    answerMove:
      "Test mutual exclusivity by asking one question — 'could a single individual or a single trial land in both events at once?' — and answer it about the overlap only; do not compare P(A) with P(A given B), which is the independence test in 2.7, not this one.",
    commonPointLoss:
      "Assuming mutually exclusive means independent; disjoint events with nonzero probability are actually dependent, since one occurring rules the other out.",
    learnMorePath: "/learn/ap-statistics/unit-2/mutually-exclusive-events",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.5" },
  },
  {
    unitId: "unit-2",
    topicId: "2.6",
    title: "Conditional Probability",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "The conditional probability of A given B equals the probability of both divided by the probability of B. Conditioning shrinks the sample space down to B alone, so B becomes the new denominator. Rearranged, this is the general multiplication rule for the probability that both events occur.",
    whyItMatters:
      "Conditional probability is the engine of the rest of the unit and of the course. It is the definition that makes the independence test in 2.7 meaningful, it is what a conditional relative frequency in 2.2 computes, and 'given' language is exactly how p-values are phrased in Units 3 and 4.",
    howPointsAreEarned:
      "You earn credit for identifying which event is the condition and using it as the denominator, for computing the conditional probability correctly from a table or tree diagram, for applying the multiplication rule to chained events, and for interpreting the result in context as a probability restricted to the given group.",
    answerMove:
      "Translate the word after 'given that,' or the group named after 'of the,' into your denominator before you compute anything — and note that P(A given B) and P(B given A) are different questions, so reversing them changes the answer even with identical data.",
    commonPointLoss:
      "Reversing the condition — answering 'probability of the disease given a positive test' with the probability of a positive test given the disease.",
    learnMorePath: "/learn/ap-statistics/unit-2/conditional-probability",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.6" },
  },
  {
    unitId: "unit-2",
    topicId: "2.7",
    title: "Independent Events and Unions of Events",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "Two events are independent when knowing one occurred does not change the probability of the other, so the probability of both equals the product of the two probabilities. Separately, the union (addition) rule finds the probability that A or B (or both) occurs by adding the two and subtracting the overlap so it is not counted twice. The addition rule is on the formula sheet.",
    whyItMatters:
      "Independence is the assumption that licenses multiplying probabilities, and it is a stated condition for the binomial setting in 2.10 and for essentially every inference procedure later in the course. The union rule is where 'or' problems live, and its subtraction term is the overlap that mutual exclusivity in 2.5 sets to zero.",
    howPointsAreEarned:
      "You earn credit for testing independence with actual numbers rather than asserting it, for stating the conclusion in context, and for applying the union rule with the overlap subtracted — including recognizing when that overlap is zero.",
    answerMove:
      "Before multiplying probabilities across repeated selections, check whether the scenario actually removes items without replacement; if it does not, keep the probability constant on every trial. For an 'or' question, add the two probabilities and subtract the overlap so it is not counted twice.",
    commonPointLoss:
      "Shrinking the numerator and denominator each draw, as if sampling without replacement, when the trials are independent and the probability stays constant.",
    learnMorePath: "/learn/ap-statistics/unit-2/independence-and-unions",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.7" },
  },
  {
    unitId: "unit-2",
    topicId: "2.8",
    title: "Introduction to Random Variables and Probability Distributions",
    classImportance: "very-important",
    examImportance: "somewhat-important",
    whatItIs:
      "A random variable assigns a number to each outcome of a chance process. A discrete probability distribution lists every possible value together with its probability, and those probabilities must sum to exactly 1. It can be given as a table, a graph, or a function. A cumulative distribution instead reports the accumulated probability up to and including a value.",
    whyItMatters:
      "This topic is about what a probability distribution is, before you compute anything from it. Everything downstream depends on that object being defined correctly: 2.9 computes its mean and standard deviation, 2.10 studies one specific named distribution, and 2.12 treats a statistic as a random variable with a distribution of its own.",
    howPointsAreEarned:
      "You earn credit for defining the random variable in words as a numeric quantity, for verifying or completing a distribution so the probabilities sum to 1, for finding a missing probability by subtraction, and for reading probabilities off either the distribution or its cumulative version, including at-most versus strictly-less-than boundaries.",
    answerMove:
      "Whenever a distribution is presented as a table, sum the probabilities and confirm they total 1 before answering — if a value is missing, that sum-to-1 requirement is how you recover it, and if they do not total 1 the given distribution is not valid.",
    commonPointLoss:
      "Confusing a cumulative value with an individual probability, and using the accumulated total as one value's probability.",
    learnMorePath:
      "/learn/ap-statistics/unit-2/random-variables-and-distributions",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.8" },
  },
  {
    unitId: "unit-2",
    topicId: "2.9",
    title: "Parameters of Random Variables",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "The parameters that summarize a discrete random variable's distribution. The expected value (mean) is the sum of each value multiplied by its own probability — every possible value weighted by how likely it is. The standard deviation is the square root of the probability-weighted sum of squared deviations from that mean, and the variance is its square. All three appear on the official formula sheet.",
    whyItMatters:
      "Expected value is what 'the long-run average outcome' means numerically, and it is the tool behind fair-game, insurance, and expected-payoff questions. Because the mean is a weighted average, it is also the conceptual bridge to the mean of a sampling distribution in 2.12.",
    howPointsAreEarned:
      "You earn credit for multiplying each value by its own probability and summing, for interpreting the result in context as a long-run average per trial rather than a value you expect on any single trial, for computing the standard deviation with squared deviations weighted by their probabilities, and for handling compound-event boundaries correctly.",
    answerMove:
      "When you compute an expected value, keep the probability factor attached to every term — the mean of a random variable is a probability-weighted sum, never the plain average of the listed values, unless those values happen to be equally likely.",
    commonPointLoss:
      "Averaging the possible values as if equally likely, or reading 'fewer than 3' as 3 or fewer when it means 2 or fewer.",
    learnMorePath:
      "/learn/ap-statistics/unit-2/expected-value-and-standard-deviation",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.9" },
  },
  {
    unitId: "unit-2",
    topicId: "2.10",
    title: "The Binomial Distribution",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "The binomial random variable counts the number of successes in a fixed number of trials, with mean equal to n times p and standard deviation equal to the square root of n times p times one minus p — all on the formula sheet. A binomial setting requires all four conditions: a fixed number of trials, independent trials, exactly two outcomes per trial, and a constant success probability on every trial.",
    whyItMatters:
      "This is the course's first named probability model, and the one students are most often asked to recognize from a word problem rather than being told to use. Establishing that a count is binomial is also what licenses the proportion-based inference procedures in the later units.",
    howPointsAreEarned:
      "You earn credit for defining the random variable precisely as a count over a stated interval or set of trials, for naming the distribution as binomial and stating its n and p, for checking the four conditions against the scenario, and for computing the probability, mean, or standard deviation with the parameters identified in words.",
    answerMove:
      "Write the distribution statement in full — 'X = the number of [successes] in [n] trials, and X is binomial with n = ___ and p = ___' — and label n and p in words even when you compute with a calculator command, since an unlabeled command string forfeits the parameter-identification credit.",
    commonPointLoss:
      "Writing only a calculator command as your answer, with no words naming the distribution as binomial or stating what n and p are.",
    learnMorePath: "/learn/ap-statistics/unit-2/binomial-distribution",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.10" },
  },
  {
    unitId: "unit-2",
    topicId: "2.11",
    title: "The Normal Distribution",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A continuous, symmetric, bell-shaped model for a quantitative variable, described entirely by its mean and standard deviation. The empirical rule says roughly 68%, 95%, and 99.7% of values fall within 1, 2, and 3 standard deviations of the mean. The standard normal distribution is the special case with mean 0 and standard deviation 1.",
    whyItMatters:
      "The normal distribution is the reference model for individual values in a population, and the machinery behind proportion and percentile questions. It is also the shape the Central Limit Theorem promises for a sample mean in 2.12 — but there it describes a statistic, not an individual, and keeping those two uses separate is the central distinction of this unit.",
    howPointsAreEarned:
      "You earn credit for applying the empirical rule to landmark boundaries, for standardizing a value and finding the area on the correct side or between two boundaries, for working backward from a given percentile to a raw value, and for stating the answer as a proportion or percentage of individuals in the population described.",
    answerMove:
      "Sketch the curve and shade the region before computing, then label whether your answer is a proportion or a percent and convert deliberately, so you do not introduce a factor-of-100 error.",
    commonPointLoss:
      "Reporting a normal-curve area without labeling it as a proportion or a percent, then carrying a factor-of-100 error into the answer.",
    learnMorePath: "/learn/ap-statistics/unit-2/normal-distribution",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.11" },
  },
  {
    unitId: "unit-2",
    topicId: "2.12",
    title: "Sampling Distributions and the Central Limit Theorem",
    classImportance: "very-important",
    examImportance: "very-important",
    whatItIs:
      "A sampling distribution is the distribution of a statistic across all possible samples of a given size drawn from a population — a distribution whose individual dots are whole samples' summary values, not individual subjects. It is distinct from the population distribution and from one particular sample's data. A randomization distribution is simulation-based and answers a different question than a sampling distribution. The Central Limit Theorem says the sampling distribution of a sample mean is approximately normal, improving as sample size grows.",
    whyItMatters:
      "This is the conceptual hinge of the whole course. Units 3 and 4 restate this same idea once per statistic and attach conditions and standard errors to it, so every confidence interval and significance test later is a specialization of what happens here.",
    howPointsAreEarned:
      "You earn credit for identifying which of the three distributions a graph or description shows — population, single sample, or sampling distribution of a statistic — for stating that the Central Limit Theorem makes the sampling distribution of a sample mean approximately normal for a large enough sample, and for explaining that increasing sample size tightens the spread of the statistic.",
    answerMove:
      "Before describing any distribution here, name what one dot on it represents: one individual (population or single sample) or one whole sample's statistic (sampling distribution) — and note the Central Limit Theorem's normality promise attaches to the sampling distribution, not to the population.",
    commonPointLoss:
      "Claiming the Central Limit Theorem makes the population normal; it describes the distribution of the sample mean, while the population can stay skewed.",
    learnMorePath:
      "/learn/ap-statistics/unit-2/sampling-distributions-and-clt",
    practiceParams: { subject: "ap_statistics", unit: "2", topic: "2.12" },
  },
];
```
