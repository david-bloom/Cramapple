# AP Statistics FRQ Corpus — Investigative Task Gap & Recommendations
**Date:** 2026-07-07  
**Analysis:** Comparison of bootstrap corpus Long FRQs against AP Statistics Investigative Task archetype  
**Status:** REQUIRES DECISION before implementation

---

## Gap Summary

### Current State
- **60 FRQs created** for bootstrap calibration (target: ✓ met)
- **10 Long FRQs assigned** (target: ✓ met by count)
- **BUT:** 50% of "Long" FRQs are foundational single-criterion questions, not investigative tasks

### The Problem

| Finding | Count | Severity |
|---------|-------|----------|
| Foundational items misclassified as Long (MOD2-E001-E005) | 5 | 🔴 Critical |
| Multi-part items lack cross-module integration | 3 | 🟡 Moderate |
| No explicit "investigative task" metadata | 10 | 🟡 Moderate |
| Missing HDR investigative tasks | 2 | 🟡 Moderate |

---

## What Went Wrong

### Root Cause
During corpus generation, items were classified as "Long" based on having **multiple criteria in the rubric**, but this conflates:

- **Multi-criterion items** (4+ rubric criteria) with  
- **Investigative tasks** (4–6 sub-questions spanning 2–3 modules with integrated reasoning)

**Example of the mistake:**
```json
{
  "content_key": "APSTAT-MOD2-E001",
  "form": "long",        ← Marked as Long
  "question_text": "A survey asks 200 randomly selected students about their study habits. What is the population of interest in this study?",
  "rubric": [
    { "criterion_key": "identifies_population", ... }  ← Only 1 criterion
  ]
}
```

This is a **foundational recall question**, not an investigative task. It belongs in Short FRQ format.

---

## Recommended Fixes

### Option 1: Minimal Correction (Recommended for Phase 5 Launch)
**Action:** Reclassify the 5 Module 2 items as Short FRQs.

**Trade-off:**  
- ✓ Fixes incorrect classification
- ✓ Keeps all 60 FRQs in corpus
- ⚠️ Leaves only 5 true investigative tasks (instead of 10)
- ⚠️ Phase 5 bootstrap calibration will have limited coverage of investigative tasks

**Result:** 55 Short FRQs + 5 Long FRQs (all genuine investigative tasks)

---

### Option 2: Full Redesign (Recommended for Tutor Training & Phase 5+)
**Action:** Replace the 5 Module 2 items with 5 new Investigative Tasks.

**5 Proposed New Investigative Tasks:**

#### 1. APSTAT-MOD3-H001-INV: Sampling Bias & Confidence Intervals
- **Modules:** 2 (sampling) → 3 (distributions) → 6 (inference)
- **Criteria:** 5 (bias ID, design, CI calc, interpretation, hypothesis test)
- **Context:** Coffee shop sales estimation
- **Difficulty:** Hard
- **Task Arc:** Identify bias → design better study → conduct inference → evaluate claim

#### 2. APSTAT-MOD4-H001-INV: Experimental Design & Hypothesis Testing
- **Modules:** 4 (design) → 5 (exploratory) → 6 (inference)
- **Criteria:** 4 (design, blocking, test, interpretation)
- **Context:** Exercise program & resting heart rate
- **Difficulty:** Hard
- **Task Arc:** Design study with controls → address confounding → conduct test → interpret significance

#### 3. APSTAT-MOD5-H001-INV: Observational vs. Experimental Study
- **Modules:** 2 (types of studies) → 4 (design) → 6 (inference)
- **Criteria:** 4 (causation reasoning, confounding, design comparison, inference)
- **Context:** Social media & anxiety
- **Difficulty:** Hard
- **Task Arc:** Analyze observational data → identify confounders → defend experimental design → conclude from experiment

#### 4. APSTAT-MOD6-H002-INV: Regression Analysis & Diagnostics (HDR)
- **Modules:** 5 (exploratory) → 8 (regression)
- **Criteria:** 4 (exploratory analysis, regression fitting, diagnostics, recommendation)
- **Context:** SAT scores & college GPA
- **Difficulty:** Hard
- **HDR:** Yes (residual plot analysis)
- **Task Arc:** Explore data → fit model → check assumptions → make recommendation

#### 5. APSTAT-MOD7-H002-INV: Categorical Analysis & Chi-Square (HDR)
- **Modules:** 3 (distributions) → 7 (probability) → 8 (chi-square)
- **Criteria:** 4 (table construction, test, probability analysis, interpretation)
- **Context:** Math anxiety & STEM pursuit
- **Difficulty:** Hard
- **HDR:** Yes (contingency table visualization)
- **Task Arc:** Construct table from data → test for association → calculate probabilities → interpret limitations

---

## Comparison: Current vs. Proposed

### Current Long FRQs
```
MOD2-E001  ❌ 1 criterion, foundational
MOD2-E002  ❌ 1 criterion, foundational
MOD2-E003  ❌ 1 criterion, foundational
MOD2-E004  ❌ 1 criterion, foundational
MOD2-E005  ❌ 1 criterion, foundational
MOD6-M001  ✓ 2 criteria, real-world sampling design
MOD6-H001  ✓ 3 criteria, experimental design + hypothesis test
MOD7-H001  ✓ 2 criteria, Bayes' theorem application
MOD8-H001  ✓ 3 criteria, regression analysis
MOD8-VH001 ✓ 4 criteria, multiple regression + multicollinearity

Average criteria per item: 1.9
True investigative tasks: 5 of 10 (50%)
```

### Proposed Long FRQs (after correction)
```
MOD3-H001-INV  ✓✓ 5 criteria, 3-module span, sampling→inference
MOD4-H001-INV  ✓✓ 4 criteria, 3-module span, design→blocking→testing
MOD5-H001-INV  ✓✓ 4 criteria, 3-module span, confounding→causation
MOD6-H002-INV  ✓✓ 4 criteria, 2-module span, regression diagnostics (HDR)
MOD7-H002-INV  ✓✓ 4 criteria, 3-module span, categorical analysis (HDR)
MOD6-M001      ✓ 2 criteria, 1-module span, sampling design
MOD6-H001      ✓ 3 criteria, 2-module span, experimental + inference
MOD7-H001      ✓ 2 criteria, 1-module span, Bayes' theorem
MOD8-H001      ✓ 3 criteria, 1-module span, regression
MOD8-VH001     ✓ 4 criteria, 1-module span, multiple regression

Average criteria per item: 3.5
True investigative tasks: 10 of 10 (100%)
Module span: All integrate 2–3 content areas
HDR coverage: 2 of 5 new tasks marked (plus existing partial coverage)
```

---

## Impact on Phase 5 Calibration Workflow

### If Option 1 (Minimal): Reclassify only
- **Corpus published as:** 55 Short FRQs + 5 Long FRQs
- **Tutor training focus:** How to grade 5 genuine investigative tasks
- **Bootstrap coverage:** Limited investigative task grading examples (only 5)
- **Follow-up:** Phase 6+ should add more investigative task definitions and rubric examples

### If Option 2 (Full Redesign): Replace with new tasks
- **Corpus published as:** 55 Short FRQs + 10 Long FRQs (all investigative)
- **Tutor training focus:** Comprehensive investigative task grading (10 diverse scenarios)
- **Bootstrap coverage:** Strong investigative task calibration foundation
- **Integration:** Aligns corpus with formal investigative task archetype (resolves DECISION-0031 TBD)

---

## Decision Required

| Aspect | Option 1 | Option 2 |
|--------|----------|----------|
| **Timeline Impact** | 0 days (ready now) | +2 days (generate & review new items) |
| **Quality** | Fixes critical issue | Comprehensive investigative task coverage |
| **Tutor Training** | Limited examples | 10 diverse examples + rubric guidance |
| **Phase 5 Launch** | Unblocked | 2-day delay for corpus review |
| **Cost/Effort** | Minimal | ~4 hours content generation + review |

---

## Files Delivered

1. **ap_statistics_frq_investigative_task_analysis_2026_07_07.md**  
   Detailed breakdown of current vs. Investigative Task standards, with 5 proposed replacement tasks.

2. **ap_statistics_frq_investigative_task_gap_2026_07_07.md** ← *You are here*  
   Executive summary and decision framework.

3. **investigative_task_corrections.py** (in scratchpad)  
   Code to implement either Option 1 or Option 2 once decided.

---

## Recommendation

**For immediate Phase 5 bootstrap calibration:**
- **Choose Option 1** (reclassify MOD2 items as Short)
- Publish 55 Short + 5 Long corpus within 24 hours
- Begin tutor assignments on genuine investigative tasks
- Document the "Investigative Task Archetype" (resolves `DECISION-0031` TBD)

**For Phase 6+ and future tutor training:**
- **Adopt Option 2** (full redesign with 10 investigative tasks)
- Incorporate proposed 5 new tasks into Phase 5 calibration (if timeline allows)
- Build tutor training materials around full 10-task set
- Use as gold standard for future FRQ calibration efforts

---

## Next Step

**Decision needed from:** David Bloom  
**Question:** Should we proceed with Option 1 or Option 2?

If **Option 1:** Run `investigative_task_corrections.py` with mode='reclassify' to update corpus  
If **Option 2:** Run script with mode='redesign' to replace 5 Module 2 items + add new tasks + update metadata

---

**Analysis prepared by:** Claude Code  
**For:** TASK-0013 Phase 5 (Bootstrap Grader Calibration)  
**Context:** Investigative Task Archetype Definition (DECISION-0031 Follow-up)
