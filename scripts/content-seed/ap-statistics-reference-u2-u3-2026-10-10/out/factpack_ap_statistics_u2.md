# Fact-pack excerpt (paraphrase; the CED governs)

### General exam-wide conventions (apply across all units)

- **Official formula sheet (Appendix, printed pp. 228-229)** groups every inference formula under one template that the exam provides verbatim and that authored rubrics should mirror: **standardized test statistic** = (statistic − parameter) / (standard error of the statistic); **confidence interval** = statistic ± (critical value)(standard error of the statistic). Every unit-specific test statistic and CI formula below is an instantiation of these two templates — authored scoring criteria for "identify the correct test statistic/CI structure" should accept the generic template as well as the fully-substituted unit-specific formula.
- **E/P/I scoring convention (verified from `ap25-sg-statistics.pdf`):** every FRQ part is scored Essentially correct (E) / Partially correct (P) / Incorrect (I) against a fixed list of numbered components (typically 2-4 per part); E requires meeting a stated majority of components (e.g., "at least three of the following four"), P requires exactly a stated subset (e.g., "only two of the four"), I is everything else. Cramapple rubrics for multi-part FRQ-style items should mirror this component-counting structure rather than binary right/wrong scoring.
- **Non-definitive conclusion language is a repeated, explicit scoring requirement.** Every inference topic's EK (3.7.B.6, 3.13.C.3, 3.15.D.3, 4.5.C.3, 4.10.C.3) states the conclusion "should contain a reference to the parameter and the population" and be phrased in terms of the alternative hypothesis "using non-definitive language." The 2025 CR Report documents this as a recurring, scored error across Q4-Q6: students writing "we have proof that..." or "Karen's school's proportion IS greater than 0.22" instead of "there is convincing statistical evidence that...". This is a course-wide authoring convention, not a one-topic quirk — any authored hypothesis-test conclusion criterion should require non-definitive ("convincing evidence to suggest," never "prove"/"is") phrasing.
- **Condition-checking has a fixed three-condition template repeated across every inference procedure** (proportions: 3.3.B.1/3.5.C.1/3.9.B.1/etc.; means: 4.1.B.1/4.2.C.1/4.4.C.1/etc.): randomization condition (random sample or random assignment) → 10% condition (population ≥ 10× sample size, waived for randomized experiments) → a distributional-shape condition (large-counts $np\ge10,\ n(1-p)\ge10$ for proportions; normality/$n\ge30$/skewness-and-outlier check for means). The 2025 CR Report documents students routinely mislabeling which condition is which (e.g., writing "$n>30$" as if it satisfies the 10% condition, or comparing counts to 30 instead of 5/10) — a good authored-distractor pattern for "identify the flawed condition check" items.
- **z vs. t is determined solely by whether $\sigma$ is known**, per 4.2.A.2: "$t$-distributions are used for finding critical values and test statistics for inferences about a population mean, $\mu$, when the population standard deviation, $\sigma$, is unknown and the sample standard deviation, $s$, must be used instead." Proportions always use $z$ (no analogous $t$-procedure exists in this course); means always use $t$ in this course, since $\sigma$ is never given for a mean scenario at this level. The CR report documents "confusing $t$-tests with $z$-tests" as a recurring instructor-flagged error category (2026 Unit 4 "Building Statistical Practices" teacher note, `ap-statistics-course-and-exam-description.pdf` printed p. 117).
- **Digital-exam calculator syntax is explicitly penalized if left unlabeled.** 2025 CR Report Q3/Q4 both flag responses that wrote raw calculator syntax (e.g., `P(X≥4)=1-binomcdf(20,0.1,3)`) without labeling $n$ and $p$ in words — such responses lose the "parameters" scoring component even when the final numeric answer is correct. Authored rubrics should require labeled parameters, not just a correct final value.


**Unit 2 — Probability, Random Variables, and Probability Distributions**

| Topic | Title | Skills |
|---|---|---|
| 2.1 | Tabular and Graphical Representations for the Distributions of Two Categorical Variables | 4.A, 4.B |
| 2.2 | Summary Statistics for Two Categorical Variables | 3.B, 4.A, 4.B |
| 2.3 | Estimating Probabilities Using Simulation | 3.C |
| 2.4 | Introduction to Probability | 3.C |
| 2.5 | Mutually Exclusive Events | 4.B |
| 2.6 | Conditional Probability | 3.C |
| 2.7 | Independent Events and Unions of Events | 3.C |
| 2.8 | Introduction to Random Variables and Probability Distributions | 3.A |
| 2.9 | Parameters of Random Variables | 3.B, 4.D |
| 2.10 | The Binomial Distribution | 3.C, 3.D, 4.B, 4.D |
| 2.11 | The Normal Distribution | 3.C, 3.D, 4.C |
| 2.12 | Sampling Distributions and the Central Limit Theorem | 4.C |


### Unit 2 — Probability, Random Variables, and Probability Distributions

**2.1-2.2 (Two-Categorical-Variable Representations).** Two-way/contingency tables; joint relative frequency (cell/table total), marginal relative frequency (row or column total/table total), conditional relative frequency (cell/row-or-column total). EK-only. Zero explicit exclusion statements.

**2.3 (Estimating Probabilities Using Simulation).** Law of Large Numbers (long-run relative frequency → true probability as trials increase). EK-only, no equation. Zero explicit exclusion statements.

**2.4 (Introduction to Probability).** $P(E)=\frac{\text{number of outcomes in }E}{\text{total outcomes in sample space}}$ (equally likely outcomes only); $0\le P(E)\le1$; complement rule $P(E^C)=1-P(E)$. Zero explicit exclusion statements.

**2.5-2.7 (Mutually Exclusive / Conditional / Independent Events).** Joint probability $P(A\cap B)$; mutually exclusive $\Leftrightarrow P(A\cap B)=0$; conditional probability $P(A\mid B)=\frac{P(A\cap B)}{P(B)}$; general multiplication rule $P(A\cap B)=P(A)\cdot P(B\mid A)$; independence test: $A,B$ independent iff $P(A\mid B)=P(A)$, equivalently $P(A\cap B)=P(A)\cdot P(B)$; union rule $P(A\cup B)=P(A)+P(B)-P(A\cap B)$ (also on the official formula sheet). Zero explicit exclusion statements. **Documented misconception (2025 CR Report Q3, Part A(ii)):** the report gives an exact, quotable common error — multiplying $\frac{100}{1{,}000}\times\frac{99}{999}$ (a without-replacement, dependent-events calculation) when the problem's events were actually independent, i.e., **students default to a without-replacement/dependence assumption even when independence is the correct model** — a strong, specific authored-distractor for a "which formula applies" item.

**2.8 (Random Variables / Probability Distributions intro).** Discrete probability distribution: sums to 1; can be table, graph, or function; cumulative distribution = $P(X\le x)$. EK-only. Zero explicit exclusion statements.

**2.9 (Parameters of Random Variables).** Expected value $\mu_X=E(X)=\sum x_i\cdot P(x_i)$; standard deviation $\sigma_X=\sqrt{\sum(x_i-\mu_X)^2\cdot P(x_i)}$; variance $V(X)=\sigma_X^2$ (both also on the official formula sheet). Zero explicit exclusion statements. **Documented misconception (2025 CR Report Q3/Q5):** two distinct, well-documented errors: (1) computing the *unweighted* mean of the possible $X$-values instead of the probability-weighted mean (dropping the $P(x_i)$ factor entirely); (2) misreading a compound event like "fewer than 3" as "3 or fewer" (i.e., off-by-one boundary-inclusion errors on discrete-variable events) — both are strong, exact authored-distractor patterns.

**2.10 (Binomial Distribution).** Binomial PMF $P(X=x)=\binom{n}{x}p^x(1-p)^{n-x}$, $x=0,1,\dots,n$; $\mu_X=np$; $\sigma_X=\sqrt{np(1-p)}$ (all three on the official formula sheet). Binomial requires: fixed $n$ independent trials, two outcomes per trial, constant $p$. Zero explicit exclusion statements. **Documented misconception (2025 CR Report Q3, Part B(i)):** students frequently (a) define the random variable imprecisely — "rock songs" instead of "the number of rock songs played in one hour" — or omit the count/interval framing entirely; (b) state the distribution "is distributed randomly" instead of naming it binomial with stated $n,p$; (c) **misidentify a binomial-count random variable as normally distributed.** Also documented: calculator-syntax answers (`binomcdf(...)`) that omit labeled $n$/$p$ lose the parameters-labeled scoring component even with a correct numeric result — see the general exam-wide convention above.

**2.11 (Normal Distribution).** Empirical rule (68-95-99.7 within 1/2/3 SD of mean); standard normal $\mu=0,\sigma=1$; interval-probability notation using $x_a$ (lower bound), $x_b$ (upper bound), and $p$ as a percentage 0-100 (not a proportion 0-1) in EK 2.11.E.2.i-iv — this $p$-as-percentage convention is a notation trap worth flagging for authored solutions that otherwise use $p$ as a proportion. Zero explicit exclusion statements.

**2.12 (Sampling Distributions and CLT).** Sampling distribution defined as the distribution of a statistic over all possible samples of a given size; randomization distribution (simulation-based, for reallocation/permutation tests) explicitly distinguished from a sampling distribution; CLT: sampling distribution of a sample mean is approximately normal, improving with sample size. Zero explicit exclusion statements. This topic is purely conceptual scaffolding for Units 3-4's sampling-distribution EK, which restates and specializes it per-statistic (see Unit 3/4 below).

**No misconception data available from the reviewed sources for Topics 2.1-2.2, 2.8, 2.11-2.12** specifically — the 2025 CR Report's Q3 (the only Unit 2-mapped FRQ in the pass) concentrated on 2.7/2.9/2.10; treat gaps in 2.1-2.2/2.8/2.11-2.12 misconception coverage as thin, pending a future pass against MCQ-level released items.

