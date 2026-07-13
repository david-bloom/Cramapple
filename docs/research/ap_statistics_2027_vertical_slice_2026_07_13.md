# AP Statistics 2026-27 — Vertical Slice (pipeline proof artifacts)

**Status:** WORKFLOW ARTIFACTS ONLY. **Not staged to any database. Not published. Not a gold set.** Pending Codex independent review (orchestration Gate **G3V**, 100% of the slice). Authored per `AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md`.
**Authoring input:** `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md` (G0A draft — **not yet Orly-confirmed**, so this slice is provisional and may be reworked when the fact pack is signed off).
**Author / verification:** authored by Opus (`claude-opus-4-8`); every numeric claim **recomputed inline by the author** (deterministic self-check shown per item). This is author self-recomputation, **NOT independent verification** — the independent adversarial/numeric check is Codex's G3V, still pending.
**No College Board material** was used as input; all contexts, data, and wording are independently constructed.
**Prepared:** 2026-07-13 · **G3V-remediated** — Codex G3V (2026-07-13) passed 7/10 review units; Q1, Q3, Q4 FAILed on **rubric validity** (not arithmetic — all numbers verified) and are remediated below; **pending G3V re-review**. See `docs/research/CODEX_G3V_AP_STATISTICS_VERTICAL_SLICE_QA_2026_07_13.md`.

Vertical-slice target (orchestration spec): one 3-question MCQ set · one standalone MCQ per unit (5) · one complete 10-point Q1/Q2/Q3/Q4. Purpose: prove authoring → deterministic check → package assembly → (Codex) review end-to-end **before** any bulk generation.

---

## MCQ Set 1 — Unit 1 (Exploring One-Variable Data & Collecting Data)

**Shared scenario (set-based item, `exam_aligned_digital`):** A teacher records, for each of 40 students in a class, the **number of hours** spent on a semester project (a quantitative variable) and the **collaboration type** — *solo*, *pair*, or *group* (a categorical variable). The five-number summary of project hours, in hours, is: minimum **2**, Q1 **5**, median **8**, Q3 **12**, maximum **25**.

### MCQ 1.1 — appropriate representation
**Unit/Topic:** 1 / 1.9 · **Practice/Skill:** P3 / 3.A · **Difficulty:** Easy
**Stem:** The teacher wants to compare the distribution of project hours across the three collaboration types. Which display is most appropriate?
- (A) A single histogram of all 40 students' hours
- (B) A pie chart of collaboration type
- (C) **Parallel (side-by-side) boxplots of hours by collaboration type** ✓
- (D) A scatterplot of hours versus collaboration type

**Rationales:** (A) collapses the groups, so it can't compare them. (B) shows only the categorical variable's proportions, not the quantitative distribution. (C) correct — parallel boxplots compare a quantitative distribution across categories. (D) scatterplots require two quantitative variables; collaboration type is categorical.
**Deterministic check:** conceptual; exactly one keyed correct option; distractors mutually exclusive. ✓

### MCQ 1.2 — 1.5×IQR outlier boundary
**Unit/Topic:** 1 / 1.7 · **Practice/Skill:** P3 / 3.B · **Difficulty:** Medium
**Stem:** Using the 1.5 × IQR rule on the project-hours summary above, a value is flagged as a high outlier if it is greater than which value?
- (A) 12
- (B) 19
- (C) **22.5** ✓
- (D) 24

**Rationales:** IQR = Q3 − Q1 = 12 − 5 = 7. Upper fence = Q3 + 1.5·IQR = 12 + 1.5(7) = 12 + 10.5 = **22.5**. (A) is Q3 itself. (B) uses 1.0·IQR (12+7). (D) is arbitrary. (Note: the maximum 25 > 22.5, so it *is* an outlier — but the question asks for the boundary.)
**Deterministic check:** IQR 12−5=7; 12+1.5·7 = 22.5 ✓. Distractors: 12 (Q3), 19 (12+7), 24 (no rule) — all distinct from 22.5. ✓

### MCQ 1.3 — sampling / generalizability
**Unit/Topic:** 1 / 1.11 · **Practice/Skill:** P2 / 2.B · **Difficulty:** Medium
**Stem:** The teacher wants to estimate the mean project hours for **all students in the school**, not just this class, and plans to survey this one class because it is convenient. Which statement best describes a limitation of this plan?
- (A) The sample is too small to compute a mean.
- (B) **The class is not a random sample of the school, so results may not generalize to all students.** ✓
- (C) Project hours cannot be averaged because they are categorical.
- (D) A census of the school is the only valid option.

**Rationales:** (A) a mean is computable for any n ≥ 1; size isn't the core issue. (B) correct — a convenience sample of one class is not representative of the school; generalizing is unjustified. (C) project hours are quantitative. (D) overstates — a random sample would suffice, a census isn't required.
**Deterministic check:** conceptual; one keyed correct; distractors each state a distinct false claim. ✓

---

## FRQ Q1 — Multi-Focus on Practices 1 & 2 (10 points)

**Unit/Topics:** primarily 1 (1.10–1.13), with 1.6–1.9 · **Archetype:** Q1 · **Modality:** `exam_aligned_digital` · **Difficulty:** Medium

**Stimulus (independently constructed):** A regional library system wants to study how long members spend per visit, in minutes, and will let each of three branches choose its own data-collection method.

- **Branch P:** every member on the branch's registered-membership list is mailed the survey and required to report their time per visit; non-responders are reminded until **every member** has answered. (The population is all registered members, so all are reached.)
- **Branch Q:** the branch's service area is divided into **eight zones that are similar to one another**; **two of the eight zones are selected at random**, and every member living in those two zones is surveyed.
- **Branch R:** only members who responded to a *previous* library survey are surveyed again.

For Branch Q, the five-number summaries of time per visit (minutes) for the two selected zones are:

| Zone | Min | Q1 | Median | Q3 | Max |
|---|---|---|---|---|---|
| Zone 1 | 4 | 10 | 14 | 18 | 40 |
| Zone 2 | 2 | 16 | 22 | 25 | 30 |

**Parts** (label all subparts):
- **A.** (i) Identify the sampling method used by Branch P. (ii) Identify the sampling method used by Branch Q.
- **B.** (i) Explain why the results from Branch Q's method can be generalized to the branch's service area. (ii) A committee member claims Branch R's method will give a higher response rate and therefore better represent all members. Explain why this claim is **not** correct.
- **C.** Identify whether "time per visit" is a quantitative or a categorical variable.
- **D.** (i) Identify a single type of graphical display that could be used to compare the two zones' distributions using the table. (ii) Explain why that display is appropriate.
- **E.** Using the summary statistics, describe and compare the likely **shape** of the two zones' distributions.
- **F.** The branch wants to compare the two zones. Determine a valid investigative question for this comparison, ensuring it identifies (i) the population and (ii) a specific quantitative variable and comparison.

### Model solution (author-constructed)
- **A.** (i) Census (of that week's visitors). (ii) Cluster random sampling.
- **B.** (i) The two zones were selected **at random** from eight **similar** zones, so the surveyed members are representative of the whole service area. (ii) Branch R surveys only prior respondents — a non-random, self-selected group — so it cannot represent all members regardless of response rate; a higher response rate among a biased group does not remove the bias.
- **C.** Quantitative.
- **D.** (i) A boxplot (parallel/side-by-side boxplots). (ii) The table gives the five-number summary, which is exactly what a boxplot displays.
- **E.** Zone 1 is likely **right-skewed**: the distance from Q3 to the max (40 − 18 = 22) is much larger than from the min to Q1 (10 − 4 = 6), i.e., a long right tail. Zone 2 is likely **left-skewed**: the distance from the min to Q1 (16 − 2 = 14) is much larger than from Q3 to the max (30 − 25 = 5), i.e., a long left tail.
- **F.** Example: "Is there a difference in the **mean time per visit** between the members of **Zone 1 and Zone 2** of the library's service area?" (population = members of Zones 1 and 2; quantitative variable = time per visit; comparison = difference in means).

**Deterministic check (author self-recompute):** Zone 1 whiskers: max−Q3 = 40−18 = **22**; Q1−min = 10−4 = **6** → 22 ≫ 6, right skew ✓. Zone 2 whiskers: Q1−min = 16−2 = **14**; max−Q3 = 30−25 = **5** → 14 ≫ 5, left skew ✓. All five-number summaries ordered (min ≤ Q1 ≤ med ≤ Q3 ≤ max) ✓. Points sum to 10 (below) ✓.

### Criterion-boundary contract (10 independently-earnable points)

Each point is earned independently (a wrong earlier part does not forfeit a later point).

**Point 1 — A(i) sampling method for Branch P**
- Earns: identifies Branch P as a **census** (every member of the defined population is surveyed).
- Does not earn: "random sample," "convenience sample," "simple random sample," or no identification.
- Minimum fix (repair): *Every member on the membership list is surveyed — that reaches the whole population, so it is a census, not a sample.*

**Point 2 — A(ii) sampling method for Branch Q**
- Earns: identifies **cluster random sampling** (or "cluster sample").
- Does not earn: "stratified random sample," "random sample" (unqualified), "SRS."
- Minimum fix: *Whole zones (not individuals) are randomly chosen and everyone in them surveyed — that's cluster sampling. Distinguish it from stratified, where you sample within every group.*

**Point 3 — B(i) explain Q is generalizable**
- Earns: explains the two zones were **randomly selected** from **similar** zones, so results represent the service area.
- Does not earn: restates "it can be generalized" with no reason; cites only sample size.
- Minimum fix: *Say **why**: the zones are similar and were chosen at random, so the two selected zones represent the whole area.*

**Point 4 — B(ii) explain R claim is wrong**
- Earns: explains Branch R surveys only **prior respondents** (non-random / self-selected), so it is **not representative** regardless of response rate.
- Does not earn: "R is bad" with no reason; argues only about sample size; asserts higher response rate is good.
- Minimum fix: *Name the flaw: only past respondents are surveyed — a self-selected, non-random group — so it can't represent all members even with a high response rate.*

**Point 5 — C classify the variable**
- Earns: **quantitative**.
- Does not earn: "categorical," "numerical category," no answer.
- Minimum fix: *Time in minutes is a measured number → quantitative.*

**Point 6 — D(i) identify the display**
- Earns: **boxplot** (or box-and-whisker / parallel boxplots).
- Does not earn: "histogram," "dotplot," "bar chart," or a display the table can't produce.
- Minimum fix: *You only have the five-number summary — the display built directly from it is a boxplot.*

**Point 7 — D(ii) explain why the display is appropriate**
- Earns: states the **table gives the five-number summary**, which is exactly what a boxplot shows. (A response that names a wrong display in D(i) but gives a correct reason for *its* display earns Point 7 but not Point 6.)
- Does not earn: "because it compares the data" with no link to the five-number summary; "the data are quantitative" alone.
- Minimum fix: *Connect the display to the data you have: the table is a five-number summary, and a boxplot is the display of a five-number summary.*

**Point 8 — E shape via comparison of summary statistics**
- Earns: describes **both** zones' shapes with support from the summary (Zone 1 right-skewed, Zone 2 left-skewed), citing whisker lengths or min/Q1/median/Q3/max distances.
- Does not earn: gives shapes with no numerical support; reverses a skew; describes only one zone.
- Minimum fix: *Support each shape with the numbers: compare each side's spread (e.g., max−Q3 vs Q1−min). Long right tail → right-skewed; long left tail → left-skewed.*

**Point 9 — F(i) investigative question identifies the population**
- Earns: the question names the **population** (members of Zone 1 and Zone 2 / the two zones' members).
- Does not earn: a question with no population, or an ambiguous "people."
- Minimum fix: *State whose data you're asking about — the members of the two zones.*

**Point 10 — F(ii) investigative question is statistical & comparative**
- Earns: names a **specific quantitative variable** (time per visit) **and** poses a **comparison** answerable with data (e.g., difference in means/medians between zones).
- Does not earn: a yes/no question with no variable; a non-statistical question; asks about a single zone with no comparison.
- Minimum fix: *Make it answerable with data: compare a specific measured variable (time per visit) between the two zones.*

---

## Standalone MCQs — one per unit (`exam_aligned_digital`)

### MCQ U1 — linear transformation (Unit 1 / 1.7 · P3 / 3.B · Easy)
**Stem:** Every value in a data set is increased by 5. What happens to the mean and the standard deviation?
- (A) Mean increases by 5; SD increases by 5
- (B) **Mean increases by 5; SD unchanged** ✓
- (C) Mean unchanged; SD increases by 5
- (D) Both unchanged

**Rationales:** Adding a constant shifts center but not spread. (A)/(C) change SD, which a shift never does. (D) ignores the shift in center.
**Deterministic check:** adding a constant → mean + c, SD invariant. ✓

### MCQ U2 — binomial mean & SD (Unit 2 / 2.10 · P3 / 3.D · Medium)
**Stem:** A binomial random variable has n = 20 and p = 0.3. What are its mean and standard deviation?
- (A) **Mean 6; SD ≈ 2.05** ✓
- (B) Mean 6; SD 4.2
- (C) Mean 0.3; SD ≈ 2.05
- (D) Mean 14; SD ≈ 2.05

**Rationales:** μ = np = 20(0.3) = 6; σ = √(np(1−p)) = √(20·0.3·0.7) = √4.2 ≈ 2.05. (B) reports the *variance* 4.2 as SD. (C) uses p as the mean. (D) uses n(1−p).
**Deterministic check:** np = 6 ✓; np(1−p) = 4.2, √4.2 = 2.049 ✓.

### MCQ U3 — SE of a sample proportion (Unit 3 / 3.2 · P3 / 3.C · Medium)
**Stem:** In a random sample of 200 people, 60 said yes (p̂ = 0.30). What is the standard error of the sample proportion?
- (A) **≈ 0.032** ✓
- (B) 0.30
- (C) ≈ 0.021
- (D) ≈ 0.046

**Rationales:** SE = √(p̂(1−p̂)/n) = √(0.30·0.70/200) = √0.00105 ≈ 0.0324. (B) is p̂. (C) drops a factor. (D) uses n = 100.
**Deterministic check:** 0.21/200 = 0.00105; √0.00105 = 0.0324 ✓.

### MCQ U4 — SE of the mean & df (Unit 4 / 4.1–4.2 · P3 / 3.C · Medium)
**Stem:** A random sample of n = 25 has mean 40 and **sample** SD s = 10. For a one-sample t procedure, what are the standard error of the mean and the degrees of freedom?
- (A) SE 2; df 25
- (B) **SE 2; df 24** ✓
- (C) SE 10; df 24
- (D) SE 0.4; df 24

**Rationales:** SE = s/√n = 10/√25 = 10/5 = 2; df = n − 1 = 24. (A) uses df = n. (C) forgets to divide by √n. (D) divides s by n. (Since only the *sample* SD is known, this is a **t** procedure — not z.)
**Deterministic check:** 10/5 = 2 ✓; 25 − 1 = 24 ✓.

### MCQ U5 — residual (Unit 5 / 5.4 · P3 / 3.B · Easy) — *descriptive regression only; no slope inference (removed)*
**Stem:** The least-squares regression line is ŷ = 3 + 2x. For an observation with x = 5 and observed y = 15, what is the residual?
- (A) **2** ✓
- (B) −2
- (C) 13
- (D) 15

**Rationales:** predicted ŷ = 3 + 2(5) = 13; residual = observed − predicted = 15 − 13 = 2. (B) reverses the sign. (C) is the predicted value. (D) is the observed value.
**Deterministic check:** 3 + 2(5) = 13; 15 − 13 = 2 ✓.

---

## FRQ Q2 — Multi-Focus on Practices 3 & 4 (10 points)

**Unit/Topics:** primarily 1 (1.6–1.9) · **Archetype:** Q2 · **Modality:** `exam_aligned_digital` · **Difficulty:** Medium

**Stimulus (constructed):** A researcher measures the caffeine content (mg) of samples from two energy-drink brands.
- **Brand A** (n = 7): 80, 85, 90, 95, 100, 105, 250
- **Brand B** (n = 7): 118, 120, 122, 124, 126, 128, 130

**Parts:** **A.** (i) median of A (ii) mean of A (iii) state the relationship between them and why. **B.** (i) compute Q1, Q3, IQR for A (ii) using the 1.5×IQR rule, determine whether 250 is an outlier (show work). **C.** (i) compare the centers of A and B (ii) compare the spreads using a resistant measure. **D.** Explain why the median and IQR describe Brand A better than the mean and SD. **E.** (i) describe the shape of Brand B (ii) justify it from the data.

**Model solution & deterministic check:** median A = 95 (4th of 7). Mean A = 805/7 = **115** (80+85+90+95+100+105+250 = 805 ✓). Mean > median (the value 250 pulls the mean up). Brand A: Q1 = 85 (median of 80,85,90), Q3 = 105 (median of 100,105,250), IQR = 20; upper fence = 105 + 1.5(20) = **135**; 250 > 135 → **outlier** ✓. Brand B: median = 124, Q1 = 120, Q3 = 128, IQR = 8; mean = 868/7 = 124 ✓. Centers: median A (95) < median B (124). Spreads: IQR A (20) > IQR B (8) → A more variable. Shape B: roughly **symmetric** (mean = median = 124; values evenly spaced).

**Criterion-boundary contract (10 points, independently earned):**
1. **A(i) median A = 95.** Not earned: any other value / averages the wrong positions. Fix: *with 7 ordered values the median is the 4th.*
2. **A(ii) mean A = 115.** Not earned: arithmetic error / omits 250. Fix: *sum all 7 (805) and divide by 7.*
3. **A(iii) mean > median because of the high value 250.** Not earned: states relationship with no reason, or reverses it. Fix: *name the outlier as the cause; a high outlier pulls the mean above the median.*
4. **B(i) Q1 = 85, Q3 = 105, IQR = 20.** Not earned: wrong quartiles / IQR. Fix: *quartiles are the medians of the lower and upper halves (excluding the overall median).*
5. **B(ii) upper fence 135 and conclude 250 is an outlier.** Not earned: no fence shown, or concludes without comparison. Fix: *fence = Q3 + 1.5·IQR = 135; compare 250 to it.*
6. **C(i) compare centers using medians (A < B).** Not earned: compares means only despite the outlier, or no direction. Fix: *use the (resistant) medians: A's center is lower.* (**ECF**: Points 6–7 judged against the student's own Point 1/4 values.)
7. **C(ii) compare spreads with IQR (A > B).** Not earned: uses range/SD only, or no direction. Fix: *compare IQRs: A is more variable.*
8. **D explain median/IQR resistant → appropriate for A.** Not earned: "they're better" with no link to the outlier. Fix: *because 250 is an outlier, the resistant median/IQR are not distorted; mean/SD are.*
9. **E(i) shape of B is roughly symmetric.** Not earned: skewed/other with no basis. Fix: *look at balance of the values around the center.*
10. **E(ii) justify symmetry from the data.** Not earned: names a shape with no numeric support. Fix: *cite mean ≈ median (both 124) and even spacing.*

---

## FRQ Q3 — Inference (10 points) *(highest-risk; Codex G3V reviews inference FRQs at 100%)*

**Unit/Topics:** 4 (4.4–4.5), inference across P2/P3/P4 · **Archetype:** Q3 · **Modality:** `exam_aligned_digital` · **Difficulty:** Medium-Hard

**Stimulus (constructed):** A company states that its bottles contain a mean of 500 mL. A quality inspector suspects the true mean **differs** from 500 mL. A random sample of **n = 36** bottles, selected independently at random from a production run of **more than 10,000 bottles**, has sample mean **x̄ = 496.5 mL** and sample standard deviation **s = 9 mL**. Test at **α = 0.05**.

**Parts:** **A.** State the hypotheses. **B.** (i) identify the appropriate inference procedure (ii) verify the randomness/independence condition (iii) verify the normality/large-sample condition. **C.** (i) calculate the test statistic (ii) give the degrees of freedom and the p-value (or a critical-value comparison). **D.** (i) state the reject/fail-to-reject decision (ii) state the conclusion in context. **E.** Describe what a Type I error would mean in this context.

**Model solution & deterministic check:** H0: μ = 500; Ha: μ ≠ 500 (two-sided). Procedure: **one-sample t-test for a mean** (population SD unknown, only s given). Conditions: random sample (stated); n = 36 ≤ 10% of the >10,000-bottle run and bottles chosen independently (independence met); n = 36 ≥ 30 → sampling distribution of x̄ approximately normal (CLT). SE = s/√n = 9/√36 = 9/6 = **1.5**. t = (x̄ − μ0)/SE = (496.5 − 500)/1.5 = −3.5/1.5 = **−2.33**; df = n − 1 = **35**. Two-sided p-value ≈ 2·P(T35 < −2.33) ≈ **0.025**. Since p ≈ 0.025 < 0.05 → **reject H0**; there is convincing evidence the true mean differs from 500 mL. Type I error: concluding the mean differs from 500 mL when in fact it equals 500 mL.

**Criterion-boundary contract (10 points, independently earned):**
1. **A: H0: μ = 500.** Not earned: uses x̄/p̂, or an inequality. Fix: *null is equality of the population mean to 500.*
2. **A: Ha: μ ≠ 500 (two-sided).** Not earned: one-sided (<, >). Fix: *"differs" ⇒ ≠, a two-sided alternative.*
3. **B(i): one-sample t-test for a mean.** Not earned: z-test, or a proportion test. Fix: *only sample SD is known ⇒ t, not z; the parameter is a mean.*
4. **B(ii): randomness/independence checked.** Not earned: no mention. Fix: *state the sample is random and n ≤ 10% of the population.*
5. **B(iii): normality/large-sample checked.** Not earned: no mention, or claims population must be normal without noting n ≥ 30. Fix: *n = 36 ≥ 30, so CLT applies.*
6. **C(i): t = −2.33 (correct SE and formula).** Not earned: wrong SE, sign, or uses σ. Fix: *SE = s/√n = 1.5; t = (496.5−500)/1.5.*
7. **C(ii): df = 35 and p ≈ 0.025 (two-sided) — or correct critical-value comparison.** Not earned: df = 36, one-sided p, or no p/critical value. Fix: *df = n−1 = 35; double the one-tail area for a two-sided test.*
8. **D(i): correct decision — reject H0 (p < α).** Not earned: decision inconsistent with the student's own p vs α (**ECF**: judged against the student's computed t/p, not only the model value). Fix: *compare p to α = 0.05 and decide accordingly.*
9. **D(ii): conclusion in context.** Not earned: "reject H0" with no context, or restates significance without the bottles. Fix: *phrase the conclusion about the true mean fill in mL.*
10. **E: Type I error in context.** Not earned: generic definition, or describes a Type II error. Fix: *concluding the mean differs from 500 when it truly is 500.*

---

## FRQ Q4 — Multi-Focus on Practices 2, 3 & 4 (10 points, multiple content areas)

**Unit/Topics:** 2 (2.8–2.9) + 3 (3.2, 3.5) · **Archetype:** Q4 · **Modality:** `exam_aligned_digital` · **Difficulty:** Medium-Hard

**Stimulus (constructed):** An online store models the number of items per order, X, with this probability distribution:

| x | 0 | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|---|
| P(x) | 0.05 | 0.15 | 0.30 | 0.25 | 0.15 | 0.10 |

**Parts:** **A.** (i) find P(X ≥ 3) (ii) find E(X). **B.** interpret E(X) in context. **C.** In a random sample of **250** orders, selected independently at random from the store's **more than 5,000 monthly orders**, **68** had 4 or more items. (i) compute the sample proportion (ii) compute the standard error using the model's P(X ≥ 4) (iii) compute the standardized statistic and its two-sided p-value. **D.** At the **α = 0.05** level, (i) state whether there is convincing evidence the true proportion of orders with 4+ items differs from 0.25 (ii) justify using your p-value. **E.** (i) state one condition needed for the part-C inference (ii) verify the large-counts and 10% conditions.

**Model solution & deterministic check:** distribution sums to 1 (0.05+0.15+0.30+0.25+0.15+0.10 = 1.00 ✓). P(X ≥ 3) = 0.25+0.15+0.10 = **0.50** ✓. E(X) = 0(0.05)+1(0.15)+2(0.30)+3(0.25)+4(0.15)+5(0.10) = 0+0.15+0.60+0.75+0.60+0.50 = **2.60** ✓. Model P(X ≥ 4) = 0.15+0.10 = 0.25. Sample p̂ = 68/250 = **0.272** ✓. SE = √(0.25·0.75/250) = √0.00075 = **0.0274** ✓. z = (0.272 − 0.25)/0.0274 = 0.022/0.0274 ≈ **0.80**; two-sided p-value ≈ 2·P(Z > 0.80) ≈ **0.42** ✓. Since p ≈ 0.42 > α = 0.05, **fail to reject** — no convincing evidence the true proportion differs from 0.25. Conditions: independent random sample, n = 250 ≤ 10% of the >5,000 orders; large counts np0 = 250(0.25) = 62.5 ≥ 10 and n(1−p0) = 250(0.75) = 187.5 ≥ 10 ✓.

**Criterion-boundary contract (10 points, independently earned):**
1. **A(i): P(X ≥ 3) = 0.50.** Not earned: uses P(X > 3) = 0.25, or wrong terms. Fix: *include x = 3, 4, 5.*
2. **A(ii): E(X) = 2.60.** Not earned: averages x without weighting, or arithmetic error. Fix: *E(X) = Σ x·P(x).*
3. **B: interpret E(X) in context.** Not earned: "the mean is 2.6" with no context, or calls it the most likely value. Fix: *over many orders, the average items per order is ≈ 2.6.*
4. **C(i): p̂ = 0.272.** Not earned: 68/1000 or other. Fix: *68/250.*
5. **C(ii): SE ≈ 0.0274 using p0 = 0.25.** Not earned: uses p̂ in the SE, or wrong n. Fix: *for a model-based comparison use SE = √(p0(1−p0)/n) with p0 = 0.25.*
6. **C(iii): z ≈ 0.80.** Not earned: wrong numerator/denominator, or wrong sign handling. Fix: *z = (p̂ − p0)/SE.*
7. **D(i): decision — fail to reject at α = 0.05 (two-sided p ≈ 0.42 > α).** Not earned: decision inconsistent with the student's two-sided p-value vs α (**ECF**: judged against the student's own p-value). Fix: *compare the two-sided p-value to α = 0.05.*
8. **D(ii): justify with the statistic.** Not earned: conclusion with no reference to z / probability. Fix: *cite that |z| ≈ 0.8 is small, so the deviation is within ordinary sampling variability.*
9. **E(i): a validity condition (random sample / independence).** Not earned: none, or an irrelevant condition. Fix: *state the sample must be random (and n ≤ 10% of orders).*
10. **E(ii): large-counts condition with the check.** Not earned: states the rule with no numbers, or uses p̂. Fix: *np0 = 62.5 and n(1−p0) = 187.5, both ≥ 10; and n = 250 ≤ 10% of the >5,000 orders.*

---

## Slice self-check summary (author)

- **12 atomic questions across 10 review units** (1 linked 3-question set + 5 standalone unit MCQs + 4 FRQs); all 5 units and all 4 practices represented; all 4 FRQ archetypes present. *(Deterministic counters must declare the convention: 10 review units / 12 atomic questions — not "9 items.")*
- **No removed topics** authored as tested content (U5 is descriptive regression only; no slope inference, no chi-square GOF, no geometric/combining-RV/departures-from-linearity).
- **Every numeric claim recomputed inline** (shown per item).
- **Each FRQ = exactly 10 independently-earnable points** with evidence boundary + counterexample + minimum-fix repair text.
- **Status:** artifacts only, not staged, not published. Codex G3V returned **7/10 pass**; Q1/Q3/Q4 remediated above; **pending G3V re-review** and the tutor's fact-pack review.

## G3V remediation log (2026-07-13)

Codex G3V confirmed **every numeric claim** and that **no removed topic** is tested. The three FAILs were rubric-validity defects (not arithmetic), all remediated:

- **Q1** — Branch P was ambiguous ("census" only under one reading; visiting-that-week undercovers "all members"). Fix: redefined the population as all registered members, reached in full → an unambiguous census.
- **Q3** — B(ii) asked students to *verify* the 10% independence condition, but the stimulus gave no population size ("presumably" ≠ verification). Fix: stated the run is >10,000 bottles and the sample is independent, so n ≤ 10% is verifiable.
- **Q4** — Part D demanded an inferential decision with no α or explicit rule (the model silently used "well under ~2"). Fix: stated α = 0.05, added the two-sided p-value (≈ 0.42), decided by p vs α; added the >5,000-order population so the 10% condition is verifiable.
- Added **consequential-error/ECF** language to dependent calc→decision chains so "independently earnable" is operational; corrected the item count to 10 units / 12 atomic questions.

### Authoring invariants for BULK (enforce in Orchestration A/B — this is the systematic lesson)

Every FRQ the cascade authors must, before it passes internal verification:
1. **Define the population precisely** and ensure the keyed sampling method is unambiguous for that population.
2. **Supply the information needed to verify any condition the item asks to verify** — if it says "verify n ≤ 10%," the stimulus must give (or bound) the population size; never rely on "presumably."
3. **State decision rules explicitly** — α and/or an explicit threshold (e.g., "within two standard errors"); never leave the decision criterion implicit in the model answer.
4. **Attach ECF/consequential-error rules** to every dependent calc→decision chain, so a wrong upstream value is judged against the student's own subsequent work.
5. Keep inferential-shape language hedged ("apparent/likely") when inferring from summary statistics.
