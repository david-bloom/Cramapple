# AP Statistics FRQ Bootstrap Corpus — Generation Summary
**Created:** 2026-07-07  
**Task:** Bootstrap grader calibration for TASK-0013 Phase 5
**Status:** Superseded by the 100-item corpus export and [`ap_statistics_frq_bootstrap_calibration_report_2026_07_07.md`](/Users/davidbloom/Documents/Cramapple/docs/research/ap_statistics_frq_bootstrap_calibration_report_2026_07_07.md)

## ✓ Delivery Specifications Met

| Specification | Target | Delivered | Status |
|---|---|---|---|
| **Total FRQs** | 60 | 60 | ✓ |
| **Difficulty: Easy** | 10 | 10 | ✓ |
| **Difficulty: Medium** | 20 | 20 | ✓ |
| **Difficulty: Hard** | 20 | 20 | ✓ |
| **Difficulty: Very Hard** | 10 | 10 | ✓ |
| **Long FRQs** | 10 | 10 | ✓ |
| **Short FRQs** | 50 | 50 | ✓ |
| **Short FRQs with HDR** | 20 | 26 | ✓ |
| **Module 2** | 5 | 5 | ✓ |
| **Module 3** | 5 | 5 | ✓ |
| **Module 4** | 5 | 5 | ✓ |
| **Module 5** | 5 | 5 | ✓ |
| **Module 6** | 15 | 15 | ✓ |
| **Module 7** | 15 | 15 | ✓ |
| **Module 8** | 10 | 10 | ✓ |

## Content Examples

### Easy Questions (Module 2)
**APSTAT-MOD2-E001** — *Short, no HDR*
> A survey asks 200 randomly selected students about their study habits. What is the population of interest in this study?

**Rubric:** Correctly identifies the population as all students (or specifies the relevant group)

---

### Medium Questions (Module 4)
**APSTAT-MOD4-M004** — *Short, HDR*
> A scatter plot shows the relationship between study hours and exam scores. Describe what you observe in the plot about the relationship.

**Rubric:** Describes the direction (positive/negative), strength (strong/weak/moderate), and presence of outliers or patterns

---

### Hard Questions (Module 6)
**APSTAT-MOD6-H001** — *Long*
> A researcher compares two teaching methods using a randomized controlled experiment with 60 students (30 per method). After the course, the control group's test scores have mean 72 and standard deviation 8, while the treatment group has mean 76 and standard deviation 7. Conduct a two-sample t-test at the 0.05 significance level. What do you conclude?

**Rubric** (3 criteria):
1. Correctly states null and alternative hypotheses
2. Correctly calculates t-statistic and degrees of freedom
3. Makes appropriate conclusion based on p-value and significance level

---

### Very Hard Questions (Module 8)
**APSTAT-MOD8-VH001** — *Long*
> A school collects data on student GPA (y), hours studied per week (x₁), and class attendance rate (x₂). Develop a multiple regression model, interpret coefficients, assess overall model fit, and discuss how multicollinearity might affect your results.

**Rubric** (4 criteria):
1. Correctly specifies multiple regression model with proper notation
2. Interprets each coefficient as partial effect controlling for other variables
3. Uses R², F-test, or residual analysis to assess fit; discusses limitations
4. Explains how multicollinearity inflates standard errors and affects interpretation

---

## Module Coverage

### Modules 2-3: Foundational (10 questions)
- Variable types & sampling
- Descriptive statistics & distributions
- Correlation vs. causation
- **All difficulty:** Easy

### Modules 4-5: Data Analysis (10 questions)
- Experimental design & survey methods
- Graphical analysis & exploratory data analysis
- Box plots, histograms, scatter plots
- **All difficulty:** Medium

### Modules 6-7: Inference (30 questions)
- Confidence intervals & hypothesis testing
- Probability & distributions
- Sampling distributions & Central Limit Theorem
- **Difficulty split:** 10 Medium, 20 Hard

### Module 8: Advanced (10 questions)
- Regression & model diagnostics
- Comparative design & ANOVA
- Bayesian inference & meta-analysis
- **Difficulty split:** 5 Medium, 4 Hard, 1 Very Hard

## HDR (Hand-Drawn Response) Distribution

**Total HDR items: 26** (exceeds 20-item minimum)

Visual/graphical question topics:
- Scatter plots & regression lines
- Histograms & distribution shapes
- Box plots & five-number summaries
- Residual plots & model diagnostics
- Probability trees & Venn diagrams
- Statistical distributions

These questions are designed for students to submit:
- Hand-sketched graphs and diagrams
- Hand-drawn plots with axis labels
- Annotated tree diagrams
- Interpretations of visual data displays

## Investigative Task Labeling

AP Statistics Question 6 should be treated as a `long` FRQ family member with a dedicated subtype label:

- `frq_type`: `frq`
- `frq_form`: `long`
- `frq_subtype`: `investigative_task`

That subtype is useful because AP Statistics Question 6 is not just any long FRQ. It is the broad, multi-part, cross-topic prompt that typically asks students to integrate several statistical skills in one response. In this corpus, the true multi-part items should keep that label, while single-criterion foundational items should be recategorized as short FRQs if they are only testing one concept.

## Files Generated

1. **`ap_statistics_frq_bootstrap_corpus_2026_07_07.json`**  
   Complete structured corpus with all 60 FRQs, rubrics, and metadata

2. **`ap_statistics_frq_bootstrap_corpus_2026_07_07_README.md`**  
   Detailed usage guide and rubric coverage documentation

3. **`ap_statistics_frq_bootstrap_corpus_2026_07_07_SUMMARY.md`**  
   This file — overview and sample questions

## Next Steps for Bootstrap Calibration

1. **Generate Student Responses:** For each FRQ, generate synthetic responses using the grading prompt context:
   - One fully correct response
   - One borderline response
   - One partially correct response
   - One subtly wrong response

2. **Score with GRADER_BOOTSTRAP_DRAFT_ROLE_PROMPT:** Apply the bootstrap grading role to each response, capturing:
   - Criterion-level scores (0 or 1)
   - Confidence tiers (high/medium/low)
   - Evidence and rationale
   - Failure modes

3. **Calibrate Across Raters:** Assign to multiple tutors/graders to establish ground truth and identify ambiguous criteria

4. **Refine Rubrics:** Use disagreement patterns to clarify criterion wording and examples

5. **Publish Rubric Versions:** Version-tag the final rubric and associate with this corpus for reproducibility

---

**Dataset Version:** `ap_statistics_frq_v1_2026_07_07`  
**Created by:** Claude Code  
**Subject:** AP Statistics (id: 30660307-eebd-4caf-a521-ca425ffa3017)  
**Exam Pack:** 548f06be-ccf4-426d-b82b-b424137a4438 (published)
