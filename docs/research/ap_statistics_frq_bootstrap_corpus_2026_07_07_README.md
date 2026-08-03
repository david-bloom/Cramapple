# AP Statistics FRQ Bootstrap Grading Corpus
**Date:** 2026-07-07  
**Task:** TASK-0013 Phase 5 Bootstrap Calibration  
**Total Items:** 100

## Distribution Summary

### By Difficulty
| Level | Count | Breakdown |
|-------|-------|-----------|
| Easy | 10 | Modules 2-3 (foundational concepts) |
| Medium | 20 | Modules 4-5 & 6-7 (data analysis, distributions) |
| Hard | 20 | Modules 6-7 (inference, statistical testing) |
| Very Hard | 10 | Module 8 (advanced inference & design) |

### By Module
| Module | Count | Difficulty Distribution |
|--------|-------|------------------------|
| 2 | 5 | 5 Easy |
| 3 | 5 | 5 Easy |
| 4 | 5 | 5 Medium |
| 5 | 5 | 5 Medium |
| 6 | 15 | 5 Medium, 10 Hard |
| 7 | 15 | 5 Medium, 10 Hard |
| 8 | 10 | 5 Medium, 4 Hard, 1 Very Hard |

**Note:** Very hard items (VH002-VH010) are spread to maintain module integrity.

### By Format & HDR Status

| Format | Count | HDR Marked | Plain |
|--------|-------|-----------|-------|
| Long FRQ | 10 | 2 | 8 |
| Short FRQ | 90 | 28 | 62 |
| **Total** | **100** | **30** | **70** |

✓ **Status:** 30 HDR-marked items total (28 short + 2 long), exceeding the minimum requirement

## Structure & Usage

Each item in the corpus follows this schema:

```json
{
  "content_key": "APSTAT-MOD[X]-[DIFFICULTY][###]",
  "module": 2-8,
  "difficulty": "easy|medium|hard|very_hard",
  "form": "short|long",
  "hdr": true|false,
  "question_text": "string",
  "rubric": [
    {
      "criterion_key": "string",
      "learner_facing_text": "string", 
      "points_possible": 1
    }
  ]
}
```

### To Use With Grader Bootstrap Prompt

1. **Load the FRQ definition** from this corpus
2. **Generate student responses** (synthetic or real) for each item
3. **Apply GRADER_BOOTSTRAP_DRAFT_ROLE_PROMPT** using:
   - The FRQ's `rubric` as the scoring criteria
   - Student response (text/image) as input
   - Output structure defined in the prompt (criterion-level scores with confidence tiers)

4. **Aggregate** criterion-level scores to produce draft labels for calibration

### Supabase Calibration Mirror

The corpus now has a lightweight Supabase mirror for content testing:

- Table: [`app.calibration_sets`](/Users/davidbloom/Documents/Cramapple/supabase/migrations/202607070002_calibration_sets.sql)
- Seed row: [`supabase/seed/calibration_sets.sql`](/Users/davidbloom/Documents/Cramapple/supabase/seed/calibration_sets.sql)

The mirror stores the corpus summary, hashes, and source file paths, while the full item list stays in this repository for review and reuse.

### Investigative Task Labeling

AP Statistics Question 6 should be stored as a long-form FRQ subtype, not as an undifferentiated long question:

- `frq_type`: `frq`
- `frq_form`: `long`
- `frq_subtype`: `investigative_task`

Use that label for the multi-part, cross-topic AP Statistics task that tests synthesis across several concepts. If a prompt is only a single-criterion concept check, it should not be labeled as an investigative task even if the stem is wordy.

Prefer `codex.frq_subtype = investigative_task` as the canonical filter when the subtype and top-level boolean differ.

## Rubric Coverage

All items include explicit criterion-level rubrics. Criteria emphasize:
- **Foundational** (Modules 2-3): Variable types, basic distributions, descriptive stats
- **Application** (Modules 4-5): Sampling design, exploratory data analysis
- **Inference** (Modules 6-7): Confidence intervals, hypothesis tests, probability
- **Advanced** (Module 8): Multiple regression, comparative design, Bayesian reasoning

## HDR (Hand-Drawn Response) Items

HDR-marked items are designed for responses that include graphs, diagrams, or other visual elements:
- **Modules 4-5:** Scatter plots, histograms, box plots
- **Modules 6-8:** Residual plots, probability distributions, complex visual analysis

Current HDR count: **30**. The corpus already exceeds the original 20-item HDR target; if you want a narrower calibration slice, filter down to the short-FRQ subset you want to stress test.

## Next Steps

1. **If regenerating synthetic responses:** Prioritize items by module/difficulty to balance holdout sets
2. **If marking real student responses:** Randomly assign to raters; start with 5-10 items per rater to establish ground truth
3. **If updating HDR count:** Review questions suitable for hand-drawn responses and set `"hdr": true`
4. **After scoring:** Analyze disagreement patterns and refine rubric wording if criteria prove ambiguous

## Metadata

- **Dataset Version:** ap_statistics_frq_v1_2026_07_07
- **Subject:** ap-statistics (id: 30660307-eebd-4caf-a521-ca425ffa3017)
- **Exam Pack Version:** 548f06be-ccf4-426d-b82b-b424137a4438
- **Calibration Role:** GRADER_BOOTSTRAP_DRAFT_ROLE_PROMPT (v1)
- **Rubric Confidence:** High (criterion-level, discrete point scales)
