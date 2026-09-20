# Course Mode — AP Stats Unit 1 Open-Hand Worked Examples (pilot)

STATUS: **DRAFT authored content — pending David D8/SME review (D2); NOT released.** | DATE: 2026-08-25 | AUDIENCE: David (SME reviewer) → Claude Design / Lovable (renders it) → authoring record.

**What this is.** The **open-hand worked example** for each of the ~10 AP Statistics Unit-1 pilot
cells — the "here's one done all the way through, watch the move" step of the **learn-first (E3)**
entry (`COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md` §5). It pairs with the orientation
in `COURSE_MODE_STATS_UNIT1_SKILL_ORIENTATIONS.md`: the orientation *names* the move; this **shows
it** on a concrete item.

**How it's used (spec §5, §6).** Rendered right after the skill orientation, before the student's
own cold attempt. It is **COACHED → zero mastery evidence** (INV-5). Each example is a **parallel
item** — a distinct scenario authored for teaching — **never the item the student is then served
cold** (no answer-key leak; the same rule that makes an in-loop "Show" a parallel item, spec §3.4).
The bold **The move** line is the beat to give the strongest visual treatment.

**Rules.** Plain-language; internal `topic×skill` codes are authoring labels, never shown to
students (INV-1). 2026-27 CED, **descriptive only**. All numbers are authored for the example.
Drafts for the SME (David, D2).

---

## 1.7 × 3.B — Summary statistics for one quantitative variable *(calculate)*

**Scenario.** Minutes seven students spent on a quiz: **2, 4, 6, 8, 10, 12, 40**. Give a typical value and a measure of spread.

**Worked.**
1. Order the data (already ordered), n = 7. The **median** is the 4th value: **8 minutes**.
2. Notice the **40** — it's far above the rest, so the data are right-skewed with an outlier. The mean (82 ÷ 7 ≈ 11.7) is dragged upward by that one value, so it's *not* a typical minute count.
3. Use the **resistant** measures. Q1 = median of the lower half (2, 4, 6) = **4**; Q3 = median of the upper half (10, 12, 40) = **12**. **IQR = Q3 − Q1 = 12 − 4 = 8**.

> **The move:** because of the outlier, report the **median (8 min)** and **IQR (8 min)** — not the mean and standard deviation. Match the measure to the shape.

## 1.9 × 3.B — Comparing distributions *(calculate)*

**Scenario.** Wait times (minutes) at two bus stops. **Route A:** 3, 4, 4, 5, 6, 7, 25. **Route B:** 9, 10, 10, 11, 12. Compare them with numbers.

**Worked.**
1. Route A has a high outlier (25), so use resistant measures for both groups to compare fairly. **A:** median = 5, Q1 = 4, Q3 = 7, IQR = 3. **B:** median = 10, Q1 = 9.5, Q3 = 11.5, IQR = 2.
2. **Center:** B's median (10) is higher than A's (5) — B's waits are typically longer.
3. **Spread:** A's IQR (3) is a bit larger than B's (2), and A has a high outlier (25); A is the more variable route.

> **The move:** compute the **same resistant statistic** (median, IQR) for **each** group — chosen because A is skewed with an outlier — then state the **numeric comparison** of center and spread.

## 1.2 × 2.A — Variables *(identify)*

**Scenario.** A team roster records each player's: (i) **grade level** (9–12), (ii) **number of siblings**, (iii) **jersey number**, (iv) **height (cm)**. Which are quantitative?

**Worked.**
1. Ask of each: *would averaging it mean something?*
2. **Siblings** — a count you can average → **quantitative**. **Height** — a measurement → **quantitative**.
3. **Jersey number** — a label that happens to be a number; "average jersey number" is meaningless → **categorical**. **Grade level** — an ordered label (a category), not a measured amount → **categorical**.

> **The move:** classify by *what the values mean*, not whether they look like numbers — **jersey number is categorical**. Quantitative here: siblings and height.

## 1.5 × 3.A — Graphs for one quantitative variable *(represent)*

**Scenario.** You have the number of text messages sent yesterday by **60** students and want to see the overall shape. Which display: bar chart, **histogram**, pie chart, or two-way table?

**Worked.**
1. The variable (texts per day) is **quantitative**, and there are many values — bar charts and pie charts are for **categorical** data, and a two-way table shows two categorical variables.
2. A **histogram** groups the counts into equal-width **intervals (bins)** and shows how many students fall in each — revealing shape, center, and spread.

> **The move:** quantitative + many values → **histogram**; its bars **touch** and the x-axis is a **number line of bins**, unlike a bar chart's separated categories.

## 1.6 × 4.A — Describe a distribution *(interpret)*

**Scenario.** A histogram of 50 homes' sale prices piles up around \$250k with a long tail toward high prices and one home near \$900k. Describe the distribution.

**Worked.**
1. **Shape:** the long tail points toward the high prices → **skewed right**.
2. **Center & spread:** because it's skewed, use the **median** (≈ \$250k) and the **IQR** for spread rather than the mean.
3. **Unusual features:** the **\$900k** home stands apart — a high outlier. Say it all **in context** (home sale prices, dollars).

> **The move:** report **S**hape, **O**utliers, **C**enter, **S**pread — in context. The skew points toward the **tail**, so a long right tail is **skewed right** (not left).

## 1.8 × 3.A — Graphical representation of summary statistics: boxplots *(represent)*

**Scenario.** Same quiz-minute data as the summary-stats skill: **2, 4, 6, 8, 10, 12, 40**. Build the boxplot — does 40 get a whisker?

**Worked.**
1. Five-number summary: min 2, **Q1 4, median 8, Q3 12**, max 40. IQR = 8.
2. Outlier check with the **1.5 × IQR** rule: upper fence = Q3 + 1.5·IQR = 12 + 12 = **24**. Since **40 > 24**, 40 is an **outlier**.
3. Draw the box from **4 to 12** with the median line at **8**. Left whisker to the min (**2**); right whisker only to the **largest non-outlier value (12)**; plot **40 as a separate point**.

> **The move:** use the **1.5 × IQR fence** to flag outliers, stop the whisker at the last non-outlier, and mark the outlier as its own point — don't run the whisker to 40.

## 1.11 × 2.A — Random sampling *(describe)*

**Scenario.** A principal wants to survey 100 students. She sorts all students **by grade**, then **randomly picks 25 from each grade**. Which sampling method is this?

**Worked.**
1. The population was split into groups that are similar inside (grades = **strata**).
2. She took a **random sample within every group** → **stratified random sampling**.
3. Contrast: if she'd instead put students into homerooms and **randomly chosen whole homerooms**, that would be **cluster** sampling.

> **The move:** "random sample **within each** similar group" is the signature of **stratified** — don't confuse it with **cluster** (randomly take **whole** groups).

## 1.12 × 2.A — Problems with sampling *(describe)*

**Scenario.** A magazine prints a survey and asks readers to mail it back; **3,000** readers respond. Why might the results be biased?

**Worked.**
1. The respondents **chose themselves** — people with strong opinions are likelier to reply. That's **voluntary-response bias**.
2. It over-represents strong feelings and can't be trusted to reflect all readers.
3. The large number (3,000) does **not** fix it — bias is about **how** the sample was gathered, not its size.

> **The move:** name the **specific** bias — **voluntary response** (self-selected in) — and remember a bigger sample **doesn't** remove bias.

## 1.13 × 2.A — Experimental design *(describe)*

**Scenario.** Researchers want to know whether a new study app **causes** higher test scores. They have 200 volunteers. What design supports a cause-and-effect claim?

**Worked.**
1. **Randomly assign** the 200 volunteers to two groups — one uses the app, one is a **control** that doesn't.
2. This random **assignment** balances out other differences (motivation, prior grades — potential **confounders**) between the groups.
3. Compare the groups' scores, with enough subjects (**replication**). A difference can now be attributed to the app.

> **The move:** **random assignment** to treatment vs. control is what licenses a **causal** claim — that's different from random **sampling**, which only lets you generalize to a population.

## 1.9 × 4.B — Comparing distributions *(justify)*

**Scenario.** Dotplots show commute times (minutes) for two office sites. **North** clusters around 20 with a couple of long commutes; **South** clusters around 30 and is more spread out. Which statement best *compares* them?

**Worked.**
1. Read each: North — center ≈ 20 min, fairly tight; South — center ≈ 30 min, wider spread.
2. A correct comparison names **both center and spread**, explicitly, in context: *"South's typical commute (≈ 30 min) is longer than North's (≈ 20 min), and South's commutes are more spread out."*
3. A wrong-but-tempting choice describes each site **separately** ("North is around 20; South is around 30") without ever comparing — that earns nothing.

> **The move:** make an **explicit comparison in context** — compare **center and spread** with words like "longer than" / "more spread out than," not two separate descriptions.

---

## Coverage check

| Cell | Skill | Worked example |
|---|---|---|
| 1.7×3.B | Summary stats (calc) | ✔ |
| 1.9×3.B | Comparing (calc) | ✔ |
| 1.2×2.A | Variables | ✔ |
| 1.5×3.A | Quant graphs | ✔ |
| 1.6×4.A | Describe (SOCS) | ✔ |
| 1.8×3.A | Boxplots | ✔ |
| 1.11×2.A | Random sampling | ✔ |
| 1.12×2.A | Sampling problems | ✔ |
| 1.13×2.A | Experiment design | ✔ |
| 1.9×4.B | Comparing (justify) | ✔ |

All ten covered. Each is a **parallel** teaching item (coached, zero evidence); the student's own
**cold** attempt that follows uses a **different** instance from the generator/slot-frame.
