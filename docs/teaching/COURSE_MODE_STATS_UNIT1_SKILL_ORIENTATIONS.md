# Course Mode — AP Stats Unit 1 Skill Orientations (pilot)

STATUS: **DRAFT authored content — pending David D8/SME review (D2); NOT released.** | DATE: 2026-08-25 | AUDIENCE: David (SME reviewer) → Claude Design / Lovable (renders it) → authoring record.

**What this is.** The per-skill **orientation** content for the ~10 AP Statistics Unit-1 pilot cells
(`COURSE_MODE_STATS_UNIT1_PILOT_PLAN_2026_08_24.md` §4) — the skill-grain, points-led explainer
that the session UX renders. It fills the "new content dependency" flagged in
`COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md` §5 / §9.

**Structure (four beats, per that spec §5 and David's framing).** Each cell carries:
1. **What this is about** — the concept in plain language.
2. **The skill you need** — the move the skill requires.
3. **The move that earns the points** — the concrete, AP-scored action.
4. **Where students lose it** — the common miss (also used as the repair "Tighten" nudge).

**Where each beat is used (spec §3.6 / §5).**
- *What this is about* → also the `/home` skills-rail **hover** teaser.
- *What this is about* + *the skill you need* → shown ambiently on any attempt.
- *The move that earns the points* + *where students lose it* → **learn-first opener** (up front,
  coached) and **repair** (after a miss); **withheld from a cold attempt** (they are answer-shaped).

**Rules these obey.** Plain-language only — the `topic×skill` codes below are internal authoring
labels, **never shown to students** (INV-1). Two skills in one topic get **distinct** orientations
(see 1.9 calculate vs. justify). The "move" describes the *general* skill move only — never the
answer to any served item or worked example (the no-answer-key security invariant). Content is
keyed to the 2026-27 CED (`AP_STATISTICS_2027_CED_FACT_PACK.md`); **descriptive** statistics only
(no inference in Unit 1). All illustrative numbers are examples for the explainer, not keys.

**Review note.** These are drafts for the SME (David, D2). Sign-off here is a prerequisite to the
learn-first (E3) path serving; the open-hand worked example that follows each orientation is a
separate authored asset (one parallel item per skill) — not included here, flagged as the next
authoring step.

---

## 1.7 × 3.B — Summary statistics for one quantitative variable *(calculate; numeric-entry)*

- **What this is about:** Putting a single number on a quantitative distribution — its center (mean, median) and its spread (range, IQR, standard deviation).
- **The skill you need:** Compute the right summary statistic from a data set or table, and know which measure fits the data.
- **The move that earns the points:** Match the measure to the shape — **median and IQR** when the data are skewed or have outliers, **mean and standard deviation** when they're roughly symmetric — and compute it correctly (IQR = Q3 − Q1; a sample standard deviation divides by n − 1). Report the value with its units.
- **Where students lose it:** Using the mean and standard deviation on skewed data or data with an outlier (should be median and IQR); confusing range with IQR; dividing by n instead of n − 1.

## 1.9 × 3.B — Comparing distributions *(calculate; numeric-entry)*

- **What this is about:** Putting numbers on the comparison of two groups — not describing one, but measuring the difference.
- **The skill you need:** Compute and compare summary statistics (median, mean, IQR, range, standard deviation) across two groups.
- **The move that earns the points:** Use the **resistant measures (median, IQR)** when a group is skewed or has outliers and the mean/SD only when it's roughly symmetric; compute the matching statistic for **each** group and state the numerical comparison in context.
- **Where students lose it:** Reporting a mean and standard deviation for a clearly skewed group; an arithmetic slip in the five-number summary; comparing a mean in one group to a median in the other.

## 1.2 × 2.A — Variables *(identify; MCQ)*

- **What this is about:** Telling what *kind* of data you have — because the type decides every graph and statistic that's allowed next.
- **The skill you need:** Classify a variable as **categorical** (labels/groups) or **quantitative** (measured numbers you can meaningfully average).
- **The move that earns the points:** Ask whether the values are *categories* or *counts/measurements*: if you'd summarize them with counts and proportions it's categorical; if with a mean or median it's quantitative — and remember a number can still be categorical (zip codes, jersey numbers).
- **Where students lose it:** Calling every number "quantitative" (zip codes, area codes, ratings-as-labels are categorical); confusing the variable itself with the values it takes.

## 1.5 × 3.A — Graphs for one quantitative variable *(represent; MCQ)*

- **What this is about:** Choosing and reading the right picture for one quantitative variable — dotplot, stemplot, or histogram.
- **The skill you need:** Match a display to the data and read it correctly — each dot or leaf is one data value; a histogram's bars are counts within intervals.
- **The move that earns the points:** Pick the display that fits the data size and the question, and read values or frequencies off it accurately — a **histogram** shows numeric **intervals (bins)** with bars that touch, not individual points.
- **Where students lose it:** Confusing a **histogram** (quantitative, bars touch, x-axis is numeric) with a **bar chart** (categorical, bars separated); miscounting values from a stemplot; misreading a bin's frequency.

## 1.6 × 4.A — Describe a distribution *(interpret; MCQ)*

- **What this is about:** Describing what one quantitative distribution looks like, in words.
- **The skill you need:** Report **shape, center, spread, and unusual features/outliers** — in context.
- **The move that earns the points:** Name the **shape** (roughly symmetric, or skewed left/right), give a **center** and a **spread**, and flag any **outliers** — every part tied to the variable and its units.
- **Where students lose it:** Getting skew direction backwards (the skew points toward the long **tail** — a long right tail is skewed **right**); giving only a center and stopping; describing out of context; calling any mound-shaped distribution "normal."

## 1.8 × 3.A — Graphical representation of summary statistics: boxplots *(represent; MCQ)*

- **What this is about:** Building and reading a boxplot from the five-number summary.
- **The skill you need:** Use min, Q1, median, Q3, max — and the 1.5 × IQR rule — to construct or read a boxplot.
- **The move that earns the points:** Draw the box from **Q1 to Q3** with the **median** line inside, extend whiskers to the most extreme values **that aren't outliers**, and mark any outlier separately using the **1.5 × IQR** fence.
- **Where students lose it:** Running whiskers all the way to the min/max even when there are outliers; treating the middle of the box as the median instead of the actual median line; thinking a wider section holds more data — **each of the four sections holds about 25%**, so a wider section means more *spread*, not more values.

## 1.11 × 2.A — Random sampling *(describe; MCQ)*

- **What this is about:** The methods for drawing a sample that fairly represents a population.
- **The skill you need:** Identify and describe simple random (SRS), stratified, cluster, and systematic sampling — and what makes each one *random*.
- **The move that earns the points:** Match the method to its defining move — **SRS** (every possible sample of size n equally likely), **stratified** (split into similar groups, then randomly sample **within each**), **cluster** (split into groups, then randomly take **whole groups**), **systematic** (every k-th unit from a random start).
- **Where students lose it:** Swapping **stratified** (sample within every stratum) and **cluster** (take whole clusters); calling a convenience or voluntary-response sample "random"; assuming a bigger sample fixes a bad method.

## 1.12 × 2.A — Problems with sampling *(describe; MCQ)*

- **What this is about:** How samples go wrong even when you're trying to be fair.
- **The skill you need:** Identify sources of bias — voluntary response, convenience, undercoverage, nonresponse, response bias, and question wording.
- **The move that earns the points:** Name the **specific** bias and say **which direction** it likely pushes the result — and recognize that bias is about the **method**, so a larger sample does not remove it.
- **Where students lose it:** Believing a larger sample cancels bias (it doesn't); confusing **nonresponse** (selected, didn't answer) with **voluntary response** (self-selected in); saying "it's biased" without naming the type or the direction.

## 1.13 × 2.A — Experimental design *(describe; MCQ)*

- **What this is about:** Designing studies that can actually support cause and effect.
- **The skill you need:** Identify and describe control, randomization, replication, and confounding — and tell an experiment apart from an observational study.
- **The move that earns the points:** **Randomly assign** treatments, **compare** against a control group, and **replicate** — and explain that random **assignment** is what balances out confounding, so only a randomized experiment supports a cause-and-effect claim.
- **Where students lose it:** Confusing random **sampling** (which lets you generalize) with random **assignment** (which lets you claim causation); calling an observational study an experiment; overlooking a confounding variable; thinking a placebo by itself is the control.

## 1.9 × 4.B — Comparing distributions *(justify; MCQ)*

- **What this is about:** Given two groups — two classes, two brands, treatment vs. control — saying how they *differ*, from a graph or the summary numbers.
- **The skill you need:** Read shape, center, spread, and outliers for each group and line them up against each other, using comparative language and context.
- **The move that earns the points:** Make an **explicit comparison in context** — compare **center and spread** with words like "higher than" / "more spread out than," e.g. *"the downtown median is higher than the suburban median, and downtown is more spread out."*
- **Where students lose it:** Describing the two groups **separately** ("A is skewed right, median 12; B is symmetric, median 15") and never comparing them — two side-by-side descriptions is not a comparison; or comparing center but forgetting spread.

---

## Coverage check (vs. PILOT_PLAN §4)

| # | Cell | Serving | Orientation |
|---|---|---|---|
| 1 | 1.7×3.B | numeric-entry | ✔ |
| 2 | 1.9×3.B | numeric-entry | ✔ |
| 3 | 1.2×2.A | MCQ | ✔ |
| 4 | 1.5×3.A | MCQ | ✔ |
| 5 | 1.6×4.A | MCQ | ✔ |
| 6 | 1.8×3.A | MCQ | ✔ |
| 7 | 1.11×2.A | MCQ | ✔ |
| 8 | 1.12×2.A | MCQ | ✔ |
| 9 | 1.13×2.A | MCQ | ✔ |
| 10 | 1.9×4.B | MCQ | ✔ |

All ten pilot cells covered. **Next authoring step:** one **open-hand worked example** (a parallel
item, worked in full to demonstrate the "move") per skill, for the learn-first (E3) opener.
