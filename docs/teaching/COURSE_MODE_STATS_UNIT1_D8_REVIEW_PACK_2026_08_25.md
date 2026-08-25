# Course Mode — AP Stats Unit 1 D8 SME Review Pack

STATUS: **D8 validation evidence — awaiting David SME sign-off (D2).** | DATE: 2026-08-25 | GENERATED: `scripts/course_mode_stats_generator` harness (deterministic seeds).

**What this is.** The per-template D8 evidence for the ten AP Statistics Unit-1 pilot cells (`COURSE_MODE_STATS_UNIT1_PILOT_PLAN_2026_08_24.md` §4): the automated property-harness result (coverage + 0-reject bar) plus a **20-instance sample per template** for the human SME pass. Per D8 (`COURSE_MODE_D8_RELEASE_BARS_PROPOSED_DEFAULTS_2026_08_25.md`): validation n=20/template with **0 defects**, property coverage ≥100/proc & ≥120/frame at 0 rejects, + Gate-2 (0 defects).

**How to review (SME, per item):** (1) the **key** is correct; (2) each **distractor** is a distinct, plausible, on-scale error that matches its named misconception (the harness canNOT verify distractor-value fidelity — hand-check it, per the generator README); (3) the **prompt/scenario** is valid and unambiguous. Mark any defect; **0 defects across the 20** clears the template for CM-D19.

---

## Harness summary (this run)

- **Computational generator** (`generator.py`, 100/proc): total instances **1100**, checks **16300**, property failures **0**, rejects **0** across 11 procedures (each 0/100), meta_failures **0** → **GREEN**.
- **Slot-frames** (`slot_frames.py`, 120/frame): instances **960**, checks **9600**, meta_tests **5** → **GREEN**.
- **Loader** (`build_load_sql.py --check`): exit `0` —
  ```
  validated 34 packages, 0 problems
  ```

Per-template property coverage (this run):

| Cell | Template / frame | Serving | Instances | Checks | Failures |
|---|---|---|---|---|---|
| 1.7 x 3.B | `summary_stats` | numeric-entry | 100 | 1100 | 0* |
| 1.9 x 3.B | `compare_stats` | numeric-entry | 100 | 1600 | 0* |
| 1.2 x 2.A | `FB-U1-2-2A-VARIABLES-01` | MCQ | 120 | 1200 | 0 |
| 1.5 x 3.A | `FB-U1-5-3A-GRAPH-01` | MCQ | 120 | 960 | 0 |
| 1.6 x 4.A | `FB-U1-6-4A-DISTRIBUTION-01` | MCQ | 120 | 1560 | 0 |
| 1.8 x 3.A | `FB-U1-8-3A-BOXPLOT-01` | MCQ | 120 | 1320 | 0 |
| 1.11 x 2.A | `FB-U1-11-2A-SAMPLING-01` | MCQ | 120 | 1440 | 0 |
| 1.12 x 2.A | `FB-U1-12-2A-BIAS-01` | MCQ | 120 | 960 | 0 |
| 1.13 x 2.A | `FB-U1-13-2A-DESIGN-01` | MCQ | 120 | 960 | 0 |
| 1.9 x 4.B | `FB-4B-COMPARE-01` | MCQ | 120 | 1200 | 0 |

\* Computational property failures are reported in aggregate by the harness (**0** total across all procedures this run); the two pilot procedures emit within that green total.

---

## 1.7 x 3.B — Summary statistics for one quantitative variable (calculate)

Template/frame: `summary_stats` · serving: numeric-entry · sample: 20 instances (all valid: yes)

#### 1. seed `90000`  ·  valid: yes

**Prompt.** Consider the data set: 10, 17, 41, 46, 51, 70, 73, 76, 80. Calculate the sample mean.

- A. 24.20  · _distractor: reported_pop_sd_
- B. 58.00  · _distractor: divided_by_n_minus_1_
- C. 51.00  · _distractor: reported_median_not_mean_
- **D. 51.56**  ✔ _key_

**Worked solution.** mean = sum/n = 464/9 = 51.5556.

**Numeric key.** mean = 51.5556

#### 2. seed `90001`  ·  valid: yes

**Prompt.** Consider the data set: 28, 35, 43, 48, 49, 65, 66, 66, 71, 72, 74. Calculate the sample mean.

- A. 65.00  · _distractor: reported_median_not_mean_
- B. 61.70  · _distractor: divided_by_n_minus_1_
- C. 15.35  · _distractor: reported_pop_sd_
- **D. 56.09**  ✔ _key_

**Worked solution.** mean = sum/n = 617/11 = 56.0909.

**Numeric key.** mean = 56.0909

#### 3. seed `90002`  ·  valid: yes

**Prompt.** Consider the data set: 13, 24, 29, 31, 50, 55, 61, 65, 73, 78, 88. Calculate the sample mean.

- A. 23.25  · _distractor: reported_pop_sd_
- B. 56.70  · _distractor: divided_by_n_minus_1_
- **C. 51.55**  ✔ _key_
- D. 55.00  · _distractor: reported_median_not_mean_

**Worked solution.** mean = sum/n = 567/11 = 51.5455.

**Numeric key.** mean = 51.5455

#### 4. seed `90003`  ·  valid: yes

**Prompt.** Consider the data set: 20, 22, 23, 27, 30, 41, 56, 66, 77. Calculate the sample mean.

- A. 45.25  · _distractor: divided_by_n_minus_1_
- B. 30.00  · _distractor: reported_median_not_mean_
- **C. 40.22**  ✔ _key_
- D. 19.95  · _distractor: reported_pop_sd_

**Worked solution.** mean = sum/n = 362/9 = 40.2222.

**Numeric key.** mean = 40.2222

#### 5. seed `90004`  ·  valid: yes

**Prompt.** Consider the data set: 18, 27, 38, 41, 59, 59, 61, 62, 63, 67, 71. Calculate the sample mean.

- **A. 51.45**  ✔ _key_
- B. 59.00  · _distractor: reported_median_not_mean_
- C. 16.74  · _distractor: reported_pop_sd_
- D. 56.60  · _distractor: divided_by_n_minus_1_

**Worked solution.** mean = sum/n = 566/11 = 51.4545.

**Numeric key.** mean = 51.4545

#### 6. seed `90005`  ·  valid: yes

**Prompt.** Consider the data set: 17, 24, 55, 56, 57, 58, 58, 74, 78, 82, 89. Calculate the sample mean.

- A. 21.39  · _distractor: reported_pop_sd_
- B. 58.00  · _distractor: reported_median_not_mean_
- **C. 58.91**  ✔ _key_
- D. 64.80  · _distractor: divided_by_n_minus_1_

**Worked solution.** mean = sum/n = 648/11 = 58.9091.

**Numeric key.** mean = 58.9091

#### 7. seed `90006`  ·  valid: yes

**Prompt.** Consider the data set: 23, 27, 36, 45, 46, 55, 70, 75, 86. Calculate the sample mean.

- A. 57.88  · _distractor: divided_by_n_minus_1_
- **B. 51.44**  ✔ _key_
- C. 20.61  · _distractor: reported_pop_sd_
- D. 46.00  · _distractor: reported_median_not_mean_

**Worked solution.** mean = sum/n = 463/9 = 51.4444.

**Numeric key.** mean = 51.4444

#### 8. seed `90007`  ·  valid: yes

**Prompt.** Consider the data set: 21, 30, 37, 53, 53, 60, 67, 76, 90. Calculate the sample mean.

- A. 60.88  · _distractor: divided_by_n_minus_1_
- B. 53.00  · _distractor: reported_median_not_mean_
- C. 20.93  · _distractor: reported_pop_sd_
- **D. 54.11**  ✔ _key_

**Worked solution.** mean = sum/n = 487/9 = 54.1111.

**Numeric key.** mean = 54.1111

#### 9. seed `90008`  ·  valid: yes

**Prompt.** Consider the data set: 19, 30, 38, 50, 60, 74, 76, 86, 88. Calculate the sample mean.

- A. 23.66  · _distractor: reported_pop_sd_
- B. 60.00  · _distractor: reported_median_not_mean_
- **C. 57.89**  ✔ _key_
- D. 65.12  · _distractor: divided_by_n_minus_1_

**Worked solution.** mean = sum/n = 521/9 = 57.8889.

**Numeric key.** mean = 57.8889

#### 10. seed `90009`  ·  valid: yes

**Prompt.** Consider the data set: 15, 35, 43, 59, 61, 80, 86. Calculate the sample mean.

- A. 23.23  · _distractor: reported_pop_sd_
- B. 59.00  · _distractor: reported_median_not_mean_
- C. 63.17  · _distractor: divided_by_n_minus_1_
- **D. 54.14**  ✔ _key_

**Worked solution.** mean = sum/n = 379/7 = 54.1429.

**Numeric key.** mean = 54.1429

#### 11. seed `90010`  ·  valid: yes

**Prompt.** Consider the data set: 10, 30, 41, 47, 52, 76, 82, 82, 84. Calculate the sample mean.

- **A. 56.00**  ✔ _key_
- B. 63.00  · _distractor: divided_by_n_minus_1_
- C. 52.00  · _distractor: reported_median_not_mean_
- D. 25.06  · _distractor: reported_pop_sd_

**Worked solution.** mean = sum/n = 504/9 = 56.0000.

**Numeric key.** mean = 56.0000

#### 12. seed `90011`  ·  valid: yes

**Prompt.** Consider the data set: 18, 31, 37, 38, 41, 50, 70, 77, 82, 82, 83. Calculate the sample mean.

- **A. 55.36**  ✔ _key_
- B. 60.90  · _distractor: divided_by_n_minus_1_
- C. 50.00  · _distractor: reported_median_not_mean_
- D. 22.82  · _distractor: reported_pop_sd_

**Worked solution.** mean = sum/n = 609/11 = 55.3636.

**Numeric key.** mean = 55.3636

#### 13. seed `90012`  ·  valid: yes

**Prompt.** Consider the data set: 19, 42, 63, 65, 67, 78, 79. Calculate the sample mean.

- A. 68.83  · _distractor: divided_by_n_minus_1_
- **B. 59.00**  ✔ _key_
- C. 65.00  · _distractor: reported_median_not_mean_
- D. 19.88  · _distractor: reported_pop_sd_

**Worked solution.** mean = sum/n = 413/7 = 59.0000.

**Numeric key.** mean = 59.0000

#### 14. seed `90013`  ·  valid: yes

**Prompt.** Consider the data set: 12, 13, 26, 38, 58, 62, 63, 67, 78, 81, 86. Calculate the sample mean.

- A. 62.00  · _distractor: reported_median_not_mean_
- **B. 53.09**  ✔ _key_
- C. 25.47  · _distractor: reported_pop_sd_
- D. 58.40  · _distractor: divided_by_n_minus_1_

**Worked solution.** mean = sum/n = 584/11 = 53.0909.

**Numeric key.** mean = 53.0909

#### 15. seed `90014`  ·  valid: yes

**Prompt.** Consider the data set: 16, 34, 43, 55, 57, 58, 58, 71, 78, 81, 82. Calculate the sample mean.

- **A. 57.55**  ✔ _key_
- B. 63.30  · _distractor: divided_by_n_minus_1_
- C. 58.00  · _distractor: reported_median_not_mean_
- D. 19.65  · _distractor: reported_pop_sd_

**Worked solution.** mean = sum/n = 633/11 = 57.5455.

**Numeric key.** mean = 57.5455

#### 16. seed `90015`  ·  valid: yes

**Prompt.** Consider the data set: 11, 21, 25, 29, 37, 40, 47, 60, 61, 74, 90. Calculate the sample mean.

- A. 40.00  · _distractor: reported_median_not_mean_
- B. 49.50  · _distractor: divided_by_n_minus_1_
- C. 23.02  · _distractor: reported_pop_sd_
- **D. 45.00**  ✔ _key_

**Worked solution.** mean = sum/n = 495/11 = 45.0000.

**Numeric key.** mean = 45.0000

#### 17. seed `90016`  ·  valid: yes

**Prompt.** Consider the data set: 13, 27, 53, 58, 67, 72, 84, 85, 89. Calculate the sample mean.

- A. 68.50  · _distractor: divided_by_n_minus_1_
- B. 67.00  · _distractor: reported_median_not_mean_
- C. 24.90  · _distractor: reported_pop_sd_
- **D. 60.89**  ✔ _key_

**Worked solution.** mean = sum/n = 548/9 = 60.8889.

**Numeric key.** mean = 60.8889

#### 18. seed `90017`  ·  valid: yes

**Prompt.** Consider the data set: 10, 13, 26, 29, 30, 31, 35, 38, 41, 51, 76. Calculate the sample mean.

- A. 31.00  · _distractor: reported_median_not_mean_
- B. 17.18  · _distractor: reported_pop_sd_
- **C. 34.55**  ✔ _key_
- D. 38.00  · _distractor: divided_by_n_minus_1_

**Worked solution.** mean = sum/n = 380/11 = 34.5455.

**Numeric key.** mean = 34.5455

#### 19. seed `90018`  ·  valid: yes

**Prompt.** Consider the data set: 11, 14, 21, 23, 28, 34, 44, 60, 68, 75, 84. Calculate the sample mean.

- A. 24.61  · _distractor: reported_pop_sd_
- B. 46.20  · _distractor: divided_by_n_minus_1_
- C. 34.00  · _distractor: reported_median_not_mean_
- **D. 42.00**  ✔ _key_

**Worked solution.** mean = sum/n = 462/11 = 42.0000.

**Numeric key.** mean = 42.0000

#### 20. seed `90019`  ·  valid: yes

**Prompt.** Consider the data set: 15, 18, 30, 35, 50, 52, 89. Calculate the sample mean.

- **A. 41.29**  ✔ _key_
- B. 48.17  · _distractor: divided_by_n_minus_1_
- C. 23.51  · _distractor: reported_pop_sd_
- D. 35.00  · _distractor: reported_median_not_mean_

**Worked solution.** mean = sum/n = 289/7 = 41.2857.

**Numeric key.** mean = 41.2857

---

## 1.9 x 3.B — Comparing distributions (calculate)

Template/frame: `compare_stats` · serving: numeric-entry · sample: 20 instances (all valid: yes)

#### 1. seed `90000`  ·  valid: yes

**Prompt.** A researcher records study-session lengths for two groups. weekday sessions (Group A): 33, 34, 34, 35, 37, 45, 50 minutes. weekend sessions (Group B): 29, 29, 32, 32, 32, 34, 35 minutes. Calculate Group A's IQR minus Group B's IQR.

- **A. 6.00**  ✔ _key_
- B. -6.00  · _distractor: u1_9__sign_reversed_difference_
- C. 11.00  · _distractor: u1_9__used_range_not_iqr_
- D. 6.43  · _distractor: u1_9__used_mean_not_median_

**Worked solution.** Group A IQR = 11.0000; Group B IQR = 5.0000; A - B = 11.0000 - 5.0000 = 6.0000.

**Numeric key.** IQR difference = 6.0000

#### 2. seed `90001`  ·  valid: yes

**Prompt.** A researcher records customer receipt totals for two groups. morning customers (Group A): 46, 53, 53, 54, 58, 62, 62, 64, 68 dollars. evening customers (Group B): 46, 53, 54, 57, 61, 61, 67, 67, 86 dollars. Calculate Group A's median minus Group B's median.

- A. 3.00  · _distractor: u1_9__sign_reversed_difference_
- B. 58.00  · _distractor: u1_9__reported_single_group_stat_
- C. -3.56  · _distractor: u1_9__used_mean_not_median_
- **D. -3.00**  ✔ _key_

**Worked solution.** Group A median = 58.0000; Group B median = 61.0000; A - B = 58.0000 - 61.0000 = -3.0000.

**Numeric key.** median difference = -3.0000

#### 3. seed `90002`  ·  valid: yes

**Prompt.** A researcher records study-session lengths for two groups. weekday sessions (Group A): 41, 46, 48, 51, 61, 61, 67 minutes. weekend sessions (Group B): 34, 36, 37, 39, 39, 40, 42 minutes. Calculate Group A's median minus Group B's median.

- A. -12.00  · _distractor: u1_9__sign_reversed_difference_
- B. 51.00  · _distractor: u1_9__reported_single_group_stat_
- C. 15.43  · _distractor: u1_9__used_mean_not_median_
- **D. 12.00**  ✔ _key_

**Worked solution.** Group A median = 51.0000; Group B median = 39.0000; A - B = 51.0000 - 39.0000 = 12.0000.

**Numeric key.** median difference = 12.0000

#### 4. seed `90003`  ·  valid: yes

**Prompt.** A researcher records customer receipt totals for two groups. morning customers (Group A): 51, 53, 53, 55, 55, 56, 57 dollars. evening customers (Group B): 57, 59, 60, 61, 63, 65, 72 dollars. Calculate Group A's median minus Group B's median.

- A. -8.14  · _distractor: u1_9__used_mean_not_median_
- **B. -6.00**  ✔ _key_
- C. 55.00  · _distractor: u1_9__reported_single_group_stat_
- D. 6.00  · _distractor: u1_9__sign_reversed_difference_

**Worked solution.** Group A median = 55.0000; Group B median = 61.0000; A - B = 55.0000 - 61.0000 = -6.0000.

**Numeric key.** median difference = -6.0000

#### 5. seed `90004`  ·  valid: yes

**Prompt.** A researcher records delivery times for two groups. Route A (Group A): 57, 57, 61, 63, 64, 64, 65, 66, 66 minutes. Route B (Group B): 46, 50, 52, 53, 55, 56, 59, 60, 61 minutes. Calculate Group A's IQR minus Group B's IQR.

- A. 2.00  · _distractor: u1_9__sign_reversed_difference_
- B. 7.89  · _distractor: u1_9__used_mean_not_median_
- **C. -2.00**  ✔ _key_
- D. -6.00  · _distractor: u1_9__used_range_not_iqr_

**Worked solution.** Group A IQR = 6.5000; Group B IQR = 8.5000; A - B = 6.5000 - 8.5000 = -2.0000.

**Numeric key.** IQR difference = -2.0000

#### 6. seed `90005`  ·  valid: yes

**Prompt.** A researcher records daily trail-user counts for two groups. north trail (Group A): 38, 38, 39, 40, 41, 44, 46, 47, 53 people. south trail (Group B): 36, 43, 45, 45, 48, 49, 50, 53, 53 people. Calculate Group A's median minus Group B's median.

- A. 7.00  · _distractor: u1_9__sign_reversed_difference_
- B. -4.00  · _distractor: u1_9__used_mean_not_median_
- **C. -7.00**  ✔ _key_
- D. 41.00  · _distractor: u1_9__reported_single_group_stat_

**Worked solution.** Group A median = 41.0000; Group B median = 48.0000; A - B = 41.0000 - 48.0000 = -7.0000.

**Numeric key.** median difference = -7.0000

#### 7. seed `90006`  ·  valid: yes

**Prompt.** A researcher records customer receipt totals for two groups. morning customers (Group A): 47, 54, 55, 56, 56, 57, 64 dollars. evening customers (Group B): 43, 49, 49, 49, 51, 53, 54 dollars. Calculate Group A's median minus Group B's median.

- A. -7.00  · _distractor: u1_9__sign_reversed_difference_
- B. 5.86  · _distractor: u1_9__used_mean_not_median_
- **C. 7.00**  ✔ _key_
- D. 56.00  · _distractor: u1_9__reported_single_group_stat_

**Worked solution.** Group A median = 56.0000; Group B median = 49.0000; A - B = 56.0000 - 49.0000 = 7.0000.

**Numeric key.** median difference = 7.0000

#### 8. seed `90007`  ·  valid: yes

**Prompt.** A researcher records customer receipt totals for two groups. morning customers (Group A): 47, 48, 48, 49, 50, 51, 57, 59, 60 dollars. evening customers (Group B): 58, 58, 62, 62, 64, 64, 65, 66, 70 dollars. Calculate Group A's mean minus Group B's mean.

- **A. -11.11**  ✔ _key_
- B. 52.11  · _distractor: u1_9__reported_single_group_stat_
- C. -14.00  · _distractor: u1_9__used_mean_not_median_
- D. 11.11  · _distractor: u1_9__sign_reversed_difference_

**Worked solution.** Group A mean = 52.1111; Group B mean = 63.2222; A - B = 52.1111 - 63.2222 = -11.1111.

**Numeric key.** mean difference = -11.1111

#### 9. seed `90008`  ·  valid: yes

**Prompt.** A researcher records customer receipt totals for two groups. morning customers (Group A): 64, 66, 67, 69, 69, 74, 81, 83, 84 dollars. evening customers (Group B): 57, 59, 60, 61, 61, 64, 65, 65, 69 dollars. Calculate Group A's IQR minus Group B's IQR.

- **A. 10.00**  ✔ _key_
- B. -10.00  · _distractor: u1_9__sign_reversed_difference_
- C. 8.00  · _distractor: u1_9__used_range_not_iqr_
- D. 10.67  · _distractor: u1_9__used_mean_not_median_

**Worked solution.** Group A IQR = 15.5000; Group B IQR = 5.5000; A - B = 15.5000 - 5.5000 = 10.0000.

**Numeric key.** IQR difference = 10.0000

#### 10. seed `90009`  ·  valid: yes

**Prompt.** A researcher records seedling heights after four weeks for two groups. sunlit bed (Group A): 12, 19, 24, 28, 31, 32, 33, 37, 38 cm. shaded bed (Group B): 28, 29, 29, 32, 33, 37, 38, 42, 42 cm. Calculate Group A's median minus Group B's median.

- A. 31.00  · _distractor: u1_9__reported_single_group_stat_
- **B. -2.00**  ✔ _key_
- C. -6.22  · _distractor: u1_9__used_mean_not_median_
- D. 2.00  · _distractor: u1_9__sign_reversed_difference_

**Worked solution.** Group A median = 31.0000; Group B median = 33.0000; A - B = 31.0000 - 33.0000 = -2.0000.

**Numeric key.** median difference = -2.0000

#### 11. seed `90010`  ·  valid: yes

**Prompt.** A researcher records customer receipt totals for two groups. morning customers (Group A): 58, 59, 62, 68, 69, 69, 69, 71, 72 dollars. evening customers (Group B): 39, 61, 62, 62, 64, 65, 67, 70, 73 dollars. Calculate Group A's IQR minus Group B's IQR.

- A. 3.78  · _distractor: u1_9__used_mean_not_median_
- **B. 2.50**  ✔ _key_
- C. -20.00  · _distractor: u1_9__used_range_not_iqr_
- D. -2.50  · _distractor: u1_9__sign_reversed_difference_

**Worked solution.** Group A IQR = 9.5000; Group B IQR = 7.0000; A - B = 9.5000 - 7.0000 = 2.5000.

**Numeric key.** IQR difference = 2.5000

#### 12. seed `90011`  ·  valid: yes

**Prompt.** A researcher records daily trail-user counts for two groups. north trail (Group A): 119, 120, 121, 122, 122, 124, 126 people. south trail (Group B): 104, 105, 108, 108, 109, 111, 119 people. Calculate Group A's mean minus Group B's mean.

- **A. 12.86**  ✔ _key_
- B. 14.00  · _distractor: u1_9__used_mean_not_median_
- C. -12.86  · _distractor: u1_9__sign_reversed_difference_
- D. 122.00  · _distractor: u1_9__reported_single_group_stat_

**Worked solution.** Group A mean = 122.0000; Group B mean = 109.1429; A - B = 122.0000 - 109.1429 = 12.8571.

**Numeric key.** mean difference = 12.8571

#### 13. seed `90012`  ·  valid: yes

**Prompt.** A researcher records seedling heights after four weeks for two groups. sunlit bed (Group A): 13, 18, 28, 34, 36, 36, 37, 48, 48 cm. shaded bed (Group B): 22, 22, 26, 26, 28, 30, 31, 32, 33 cm. Calculate Group A's mean minus Group B's mean.

- A. 8.00  · _distractor: u1_9__used_mean_not_median_
- B. 33.11  · _distractor: u1_9__reported_single_group_stat_
- **C. 5.33**  ✔ _key_
- D. -5.33  · _distractor: u1_9__sign_reversed_difference_

**Worked solution.** Group A mean = 33.1111; Group B mean = 27.7778; A - B = 33.1111 - 27.7778 = 5.3333.

**Numeric key.** mean difference = 5.3333

#### 14. seed `90013`  ·  valid: yes

**Prompt.** A researcher records daily trail-user counts for two groups. north trail (Group A): 83, 83, 87, 87, 88, 90, 91, 91, 91 people. south trail (Group B): 88, 94, 98, 99, 100, 104, 107, 107, 110 people. Calculate Group A's IQR minus Group B's IQR.

- A. 5.00  · _distractor: u1_9__sign_reversed_difference_
- B. -12.89  · _distractor: u1_9__used_mean_not_median_
- C. -14.00  · _distractor: u1_9__used_range_not_iqr_
- **D. -5.00**  ✔ _key_

**Worked solution.** Group A IQR = 6.0000; Group B IQR = 11.0000; A - B = 6.0000 - 11.0000 = -5.0000.

**Numeric key.** IQR difference = -5.0000

#### 15. seed `90014`  ·  valid: yes

**Prompt.** A researcher records daily trail-user counts for two groups. north trail (Group A): 105, 105, 111, 111, 114, 115, 116, 117, 120 people. south trail (Group B): 99, 103, 106, 106, 107, 108, 109, 111, 127 people. Calculate Group A's median minus Group B's median.

- **A. 7.00**  ✔ _key_
- B. 114.00  · _distractor: u1_9__reported_single_group_stat_
- C. -7.00  · _distractor: u1_9__sign_reversed_difference_
- D. 4.22  · _distractor: u1_9__used_mean_not_median_

**Worked solution.** Group A median = 114.0000; Group B median = 107.0000; A - B = 114.0000 - 107.0000 = 7.0000.

**Numeric key.** median difference = 7.0000

#### 16. seed `90015`  ·  valid: yes

**Prompt.** A researcher records seedling heights after four weeks for two groups. sunlit bed (Group A): 27, 30, 31, 31, 35, 36, 37, 38, 38 cm. shaded bed (Group B): 26, 30, 36, 37, 37, 38, 41, 45, 48 cm. Calculate Group A's IQR minus Group B's IQR.

- **A. -3.00**  ✔ _key_
- B. 3.00  · _distractor: u1_9__sign_reversed_difference_
- C. -3.89  · _distractor: u1_9__used_mean_not_median_
- D. -11.00  · _distractor: u1_9__used_range_not_iqr_

**Worked solution.** Group A IQR = 7.0000; Group B IQR = 10.0000; A - B = 7.0000 - 10.0000 = -3.0000.

**Numeric key.** IQR difference = -3.0000

#### 17. seed `90016`  ·  valid: yes

**Prompt.** A researcher records customer receipt totals for two groups. morning customers (Group A): 27, 29, 29, 30, 31, 33, 34, 39, 41 dollars. evening customers (Group B): 20, 21, 21, 21, 21, 22, 23, 24, 25 dollars. Calculate Group A's median minus Group B's median.

- **A. 10.00**  ✔ _key_
- B. 31.00  · _distractor: u1_9__reported_single_group_stat_
- C. -10.00  · _distractor: u1_9__sign_reversed_difference_
- D. 10.56  · _distractor: u1_9__used_mean_not_median_

**Worked solution.** Group A median = 31.0000; Group B median = 21.0000; A - B = 31.0000 - 21.0000 = 10.0000.

**Numeric key.** median difference = 10.0000

#### 18. seed `90017`  ·  valid: yes

**Prompt.** A researcher records seedling heights after four weeks for two groups. sunlit bed (Group A): 17, 18, 27, 29, 39, 40, 48 cm. shaded bed (Group B): 26, 34, 35, 37, 37, 38, 41 cm. Calculate Group A's mean minus Group B's mean.

- A. 4.29  · _distractor: u1_9__sign_reversed_difference_
- B. 31.14  · _distractor: u1_9__reported_single_group_stat_
- **C. -4.29**  ✔ _key_
- D. -8.00  · _distractor: u1_9__used_mean_not_median_

**Worked solution.** Group A mean = 31.1429; Group B mean = 35.4286; A - B = 31.1429 - 35.4286 = -4.2857.

**Numeric key.** mean difference = -4.2857

#### 19. seed `90018`  ·  valid: yes

**Prompt.** A researcher records seedling heights after four weeks for two groups. sunlit bed (Group A): 28, 28, 30, 33, 36, 36, 38 cm. shaded bed (Group B): 31, 31, 32, 36, 38, 38, 38 cm. Calculate Group A's mean minus Group B's mean.

- A. 32.71  · _distractor: u1_9__reported_single_group_stat_
- **B. -2.14**  ✔ _key_
- C. 2.14  · _distractor: u1_9__sign_reversed_difference_
- D. -3.00  · _distractor: u1_9__used_mean_not_median_

**Worked solution.** Group A mean = 32.7143; Group B mean = 34.8571; A - B = 32.7143 - 34.8571 = -2.1429.

**Numeric key.** mean difference = -2.1429

#### 20. seed `90019`  ·  valid: yes

**Prompt.** A researcher records seedling heights after four weeks for two groups. sunlit bed (Group A): 25, 30, 32, 32, 38, 41, 41 cm. shaded bed (Group B): 24, 25, 25, 25, 26, 27, 28 cm. Calculate Group A's mean minus Group B's mean.

- **A. 8.43**  ✔ _key_
- B. 7.00  · _distractor: u1_9__used_mean_not_median_
- C. -8.43  · _distractor: u1_9__sign_reversed_difference_
- D. 34.14  · _distractor: u1_9__reported_single_group_stat_

**Worked solution.** Group A mean = 34.1429; Group B mean = 25.7143; A - B = 34.1429 - 25.7143 = 8.4286.

**Numeric key.** mean difference = 8.4286

---

## 1.2 x 2.A — Variables (identify)

Template/frame: `FB-U1-2-2A-VARIABLES-01` · serving: MCQ · sample: 20 instances (all valid: yes)

#### 1. seed `102000`  ·  valid: yes

**Prompt.** In a device quality-control study, the variable recorded for each phone is model code. Which choice best classifies this variable?

- A. categorical ordinal, because newer model codes are better  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- B. quantitative discrete, because model codes may contain numbers  · _distractor: u1_2__numeric_codes_called_quantitative_
- **C. categorical, because the value labels the phone model.**  ✔ _key_
- D. quantitative continuous, because model performance can be measured  · _distractor: u1_2__quantitative_called_categorical_

#### 2. seed `102001`  ·  valid: yes

**Prompt.** In a device quality-control study, the variable recorded for each phone is model code. Which choice best classifies this variable?

- A. quantitative discrete, because model codes may contain numbers  · _distractor: u1_2__numeric_codes_called_quantitative_
- B. quantitative continuous, because model performance can be measured  · _distractor: u1_2__quantitative_called_categorical_
- **C. categorical, because the value labels the phone model.**  ✔ _key_
- D. categorical ordinal, because newer model codes are better  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 3. seed `102002`  ·  valid: yes

**Prompt.** In a clinic operations study, the variable recorded for each patient is number of clinic visits last year. Which choice best classifies this variable?

- A. categorical ordinal, because more visits can indicate higher need  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- B. categorical, because patients can be grouped by visit frequency  · _distractor: u1_2__quantitative_called_categorical_
- **C. quantitative discrete, because the value is a count of visits.**  ✔ _key_
- D. quantitative continuous, because the mean number of visits can be a decimal  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 4. seed `102003`  ·  valid: yes

**Prompt.** In a city-services survey, the variable recorded for each household is number of people living in the household. Which choice best classifies this variable?

- **A. quantitative discrete, because the value is a count of people.**  ✔ _key_
- B. categorical ordinal, because larger households rank above smaller households  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- C. categorical, because households can be grouped as small or large  · _distractor: u1_2__quantitative_called_categorical_
- D. quantitative continuous, because the average household size can be a decimal  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 5. seed `102004`  ·  valid: yes

**Prompt.** In a device quality-control study, the variable recorded for each phone is model code. Which choice best classifies this variable?

- A. quantitative continuous, because model performance can be measured  · _distractor: u1_2__quantitative_called_categorical_
- B. quantitative discrete, because model codes may contain numbers  · _distractor: u1_2__numeric_codes_called_quantitative_
- **C. categorical, because the value labels the phone model.**  ✔ _key_
- D. categorical ordinal, because newer model codes are better  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 6. seed `102005`  ·  valid: yes

**Prompt.** In a clinic operations study, the variable recorded for each patient is number of clinic visits last year. Which choice best classifies this variable?

- **A. quantitative discrete, because the value is a count of visits.**  ✔ _key_
- B. categorical, because patients can be grouped by visit frequency  · _distractor: u1_2__quantitative_called_categorical_
- C. quantitative continuous, because the mean number of visits can be a decimal  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- D. categorical ordinal, because more visits can indicate higher need  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 7. seed `102006`  ·  valid: yes

**Prompt.** In a city-services survey, the variable recorded for each household is home ZIP code. Which choice best classifies this variable?

- A. quantitative continuous, because ZIP codes can be averaged  · _distractor: u1_2__numeric_codes_called_quantitative_
- B. quantitative discrete, because each household has exactly one ZIP code  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- **C. categorical, because the value labels a location category.**  ✔ _key_
- D. quantitative discrete, because ZIP codes are written as numbers  · _distractor: u1_2__numeric_codes_called_quantitative_

#### 8. seed `102007`  ·  valid: yes

**Prompt.** In a school attendance study, the variable recorded for each student is number of absences this semester. Which choice best classifies this variable?

- A. quantitative continuous, because absence totals can be averaged  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- **B. quantitative discrete, because the value is a count.**  ✔ _key_
- C. categorical ordinal, because a larger count means worse attendance  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- D. categorical, because students can be grouped by absence count  · _distractor: u1_2__quantitative_called_categorical_

#### 9. seed `102008`  ·  valid: yes

**Prompt.** In a clinic operations study, the variable recorded for each patient is primary insurance type. Which choice best classifies this variable?

- **A. categorical, because the value names an insurance category.**  ✔ _key_
- B. quantitative continuous, because insurance cost is numerical  · _distractor: u1_2__quantitative_called_categorical_
- C. categorical ordinal, because some plans cost more than others  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- D. quantitative discrete, because insurance types can be stored as billing codes  · _distractor: u1_2__numeric_codes_called_quantitative_

#### 10. seed `102009`  ·  valid: yes

**Prompt.** In a school attendance study, the variable recorded for each student is number of absences this semester. Which choice best classifies this variable?

- A. categorical, because students can be grouped by absence count  · _distractor: u1_2__quantitative_called_categorical_
- **B. quantitative discrete, because the value is a count.**  ✔ _key_
- C. quantitative continuous, because absence totals can be averaged  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- D. categorical ordinal, because a larger count means worse attendance  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 11. seed `102010`  ·  valid: yes

**Prompt.** In a device quality-control study, the variable recorded for each phone is number of cosmetic defects found during inspection. Which choice best classifies this variable?

- A. quantitative continuous, because the average defect count can be a decimal  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- B. categorical ordinal, because more defects means worse condition  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- C. categorical, because phones can be labeled acceptable or unacceptable  · _distractor: u1_2__quantitative_called_categorical_
- **D. quantitative discrete, because the value is a count of defects.**  ✔ _key_

#### 12. seed `102011`  ·  valid: yes

**Prompt.** In a city-services survey, the variable recorded for each household is number of people living in the household. Which choice best classifies this variable?

- A. quantitative continuous, because the average household size can be a decimal  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- **B. quantitative discrete, because the value is a count of people.**  ✔ _key_
- C. categorical, because households can be grouped as small or large  · _distractor: u1_2__quantitative_called_categorical_
- D. categorical ordinal, because larger households rank above smaller households  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 13. seed `102012`  ·  valid: yes

**Prompt.** In a device quality-control study, the variable recorded for each phone is number of cosmetic defects found during inspection. Which choice best classifies this variable?

- A. categorical ordinal, because more defects means worse condition  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- **B. quantitative discrete, because the value is a count of defects.**  ✔ _key_
- C. quantitative continuous, because the average defect count can be a decimal  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- D. categorical, because phones can be labeled acceptable or unacceptable  · _distractor: u1_2__quantitative_called_categorical_

#### 14. seed `102013`  ·  valid: yes

**Prompt.** In a school attendance study, the variable recorded for each student is number of absences this semester. Which choice best classifies this variable?

- A. categorical, because students can be grouped by absence count  · _distractor: u1_2__quantitative_called_categorical_
- **B. quantitative discrete, because the value is a count.**  ✔ _key_
- C. quantitative continuous, because absence totals can be averaged  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- D. categorical ordinal, because a larger count means worse attendance  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 15. seed `102014`  ·  valid: yes

**Prompt.** In a city-services survey, the variable recorded for each household is home ZIP code. Which choice best classifies this variable?

- A. quantitative continuous, because ZIP codes can be averaged  · _distractor: u1_2__numeric_codes_called_quantitative_
- B. quantitative discrete, because ZIP codes are written as numbers  · _distractor: u1_2__numeric_codes_called_quantitative_
- **C. categorical, because the value labels a location category.**  ✔ _key_
- D. quantitative discrete, because each household has exactly one ZIP code  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 16. seed `102015`  ·  valid: yes

**Prompt.** In a device quality-control study, the variable recorded for each phone is number of cosmetic defects found during inspection. Which choice best classifies this variable?

- **A. quantitative discrete, because the value is a count of defects.**  ✔ _key_
- B. quantitative continuous, because the average defect count can be a decimal  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- C. categorical ordinal, because more defects means worse condition  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- D. categorical, because phones can be labeled acceptable or unacceptable  · _distractor: u1_2__quantitative_called_categorical_

#### 17. seed `102016`  ·  valid: yes

**Prompt.** In a device quality-control study, the variable recorded for each phone is battery life on one charge. Which choice best classifies this variable?

- A. quantitative discrete, because battery life is often rounded to hours  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- **B. quantitative continuous, because the value is a duration measurement.**  ✔ _key_
- C. categorical, because phones can be labeled low, medium, or high battery life  · _distractor: u1_2__quantitative_called_categorical_
- D. categorical ordinal, because longer battery life is better  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 18. seed `102017`  ·  valid: yes

**Prompt.** In a school attendance study, the variable recorded for each student is number of absences this semester. Which choice best classifies this variable?

- A. categorical ordinal, because a larger count means worse attendance  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- B. quantitative continuous, because absence totals can be averaged  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- **C. quantitative discrete, because the value is a count.**  ✔ _key_
- D. categorical, because students can be grouped by absence count  · _distractor: u1_2__quantitative_called_categorical_

#### 19. seed `102018`  ·  valid: yes

**Prompt.** In a library service survey, the variable recorded for each patron is satisfaction rating from very dissatisfied to very satisfied. Which choice best classifies this variable?

- **A. categorical ordinal, because the value is an ordered label.**  ✔ _key_
- B. quantitative discrete, because the response choices can be coded 1 through 5  · _distractor: u1_2__numeric_codes_called_quantitative_
- C. categorical nominal, because the responses are words  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- D. quantitative continuous, because averages of ratings can be reported  · _distractor: u1_2__counts_or_ordinal_miscategorized_

#### 20. seed `102019`  ·  valid: yes

**Prompt.** In a clinic operations study, the variable recorded for each patient is number of clinic visits last year. Which choice best classifies this variable?

- A. categorical, because patients can be grouped by visit frequency  · _distractor: u1_2__quantitative_called_categorical_
- B. categorical ordinal, because more visits can indicate higher need  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- C. quantitative continuous, because the mean number of visits can be a decimal  · _distractor: u1_2__counts_or_ordinal_miscategorized_
- **D. quantitative discrete, because the value is a count of visits.**  ✔ _key_

---

## 1.5 x 3.A — Graphs for one quantitative variable (represent)

Template/frame: `FB-U1-5-3A-GRAPH-01` · serving: MCQ · sample: 20 instances (all valid: yes)

#### 1. seed `105000`  ·  valid: yes

**Prompt.** The quiz scores (points) are 62, 67, 68, 73, 73, 79, 79, 82, 85, 87, 92, 95. Which representation correctly displays these quantitative data?

- A. Bar chart with one bar for each named category of quiz scores, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- B. Histogram with counts 60-69 points: 3; 70-79 points: 3; 80-89 points: 4; 90-99 points: 2; 100-109 points: 0  · _distractor: u1_5__miscounted_bin_frequency_
- C. Stemplot 62 | 0; 67 | 0; 68 | 0; 73 | 0 0; 79 | 0 0; 82 | 0; 85 | 0; 87 | 0; 92 | 0; 95 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- **D. Histogram with counts 60-69 points: 3; 70-79 points: 4; 80-89 points: 3; 90-99 points: 2; 100-109 points: 0**  ✔ _key_

#### 2. seed `105001`  ·  valid: yes

**Prompt.** The one-way commute times (minutes) are 14, 14, 21, 23, 23, 26, 30, 31, 35, 36, 39, 45. Which representation correctly displays these quantitative data?

- **A. Histogram with counts 10-19 minutes: 2; 20-29 minutes: 4; 30-39 minutes: 5; 40-49 minutes: 1; 50-59 minutes: 0**  ✔ _key_
- B. Stemplot 14 | 0 0; 21 | 0; 23 | 0 0; 26 | 0; 30 | 0; 31 | 0; 35 | 0; 36 | 0; 39 | 0; 45 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- C. Histogram with counts 10-19 minutes: 2; 20-29 minutes: 4; 30-39 minutes: 5; 40-49 minutes: 0; 50-59 minutes: 1  · _distractor: u1_5__miscounted_bin_frequency_
- D. Bar chart with one bar for each named category of one-way commute times, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_

#### 3. seed `105002`  ·  valid: yes

**Prompt.** The battery life (hours) are 9, 7, 9, 10, 9, 11, 10, 14, 15, 13, 16, 17. Which representation correctly displays these quantitative data?

- A. Histogram with counts 5-9 hours: 4; 10-14 hours: 4; 15-19 hours: 4; 20-24 hours: 0  · _distractor: u1_5__miscounted_bin_frequency_
- B. Stemplot 7 | 0; 9 | 0 0 0; 10 | 0 0; 11 | 0; 13 | 0; 14 | 0; 15 | 0; 16 | 0; 17 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- C. Bar chart with one bar for each named category of battery life, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- **D. Histogram with counts 5-9 hours: 4; 10-14 hours: 5; 15-19 hours: 3; 20-24 hours: 0**  ✔ _key_

#### 4. seed `105003`  ·  valid: yes

**Prompt.** The one-way commute times (minutes) are 13, 15, 19, 24, 25, 24, 29, 32, 35, 37, 42, 44. Which representation correctly displays these quantitative data?

- A. Bar chart with one bar for each named category of one-way commute times, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- B. Stemplot 13 | 0; 15 | 0; 19 | 0; 24 | 0 0; 25 | 0; 29 | 0; 32 | 0; 35 | 0; 37 | 0; 42 | 0; 44 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- C. Histogram with counts 10-19 minutes: 3; 20-29 minutes: 3; 30-39 minutes: 4; 40-49 minutes: 2; 50-59 minutes: 0  · _distractor: u1_5__miscounted_bin_frequency_
- **D. Histogram with counts 10-19 minutes: 3; 20-29 minutes: 4; 30-39 minutes: 3; 40-49 minutes: 2; 50-59 minutes: 0**  ✔ _key_

#### 5. seed `105004`  ·  valid: yes

**Prompt.** The quiz scores (points) are 63, 68, 69, 72, 74, 79, 79, 81, 86, 87, 92, 95. Which representation correctly displays these quantitative data?

- **A. Histogram with counts 60-69 points: 3; 70-79 points: 4; 80-89 points: 3; 90-99 points: 2; 100-109 points: 0**  ✔ _key_
- B. Histogram with counts 60-69 points: 3; 70-79 points: 4; 80-89 points: 2; 90-99 points: 3; 100-109 points: 0  · _distractor: u1_5__miscounted_bin_frequency_
- C. Stemplot 63 | 0; 68 | 0; 69 | 0; 72 | 0; 74 | 0; 79 | 0 0; 81 | 0; 86 | 0; 87 | 0; 92 | 0; 95 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- D. Bar chart with one bar for each named category of quiz scores, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_

#### 6. seed `105005`  ·  valid: yes

**Prompt.** The battery life (hours) are 9, 10, 8, 10, 12, 9, 11, 11, 13, 16, 16, 14. Which representation correctly displays these quantitative data?

- A. Histogram with counts 5-9 hours: 3; 10-14 hours: 7; 15-19 hours: 1; 20-24 hours: 1  · _distractor: u1_5__miscounted_bin_frequency_
- B. Stemplot 8 | 0; 9 | 0 0; 10 | 0 0; 11 | 0 0; 12 | 0; 13 | 0; 14 | 0; 16 | 0 0  · _distractor: u1_5__stem_leaf_place_value_error_
- **C. Histogram with counts 5-9 hours: 3; 10-14 hours: 7; 15-19 hours: 2; 20-24 hours: 0**  ✔ _key_
- D. Bar chart with one bar for each named category of battery life, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_

#### 7. seed `105006`  ·  valid: yes

**Prompt.** The quiz scores (points) are 64, 65, 67, 72, 75, 78, 78, 81, 85, 87, 90, 97. Which representation correctly displays these quantitative data?

- A. Bar chart with one bar for each named category of quiz scores, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- B. Histogram with counts 60-69 points: 3; 70-79 points: 3; 80-89 points: 4; 90-99 points: 2; 100-109 points: 0  · _distractor: u1_5__miscounted_bin_frequency_
- C. Stemplot 64 | 0; 65 | 0; 67 | 0; 72 | 0; 75 | 0; 78 | 0 0; 81 | 0; 85 | 0; 87 | 0; 90 | 0; 97 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- **D. Histogram with counts 60-69 points: 3; 70-79 points: 4; 80-89 points: 3; 90-99 points: 2; 100-109 points: 0**  ✔ _key_

#### 8. seed `105007`  ·  valid: yes

**Prompt.** The one-way commute times (minutes) are 13, 17, 19, 21, 24, 25, 27, 33, 37, 38, 42, 43. Which representation correctly displays these quantitative data?

- A. Stemplot 13 | 0; 17 | 0; 19 | 0; 21 | 0; 24 | 0; 25 | 0; 27 | 0; 33 | 0; 37 | 0; 38 | 0; 42 | 0; 43 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- **B. Histogram with counts 10-19 minutes: 3; 20-29 minutes: 4; 30-39 minutes: 3; 40-49 minutes: 2; 50-59 minutes: 0**  ✔ _key_
- C. Bar chart with one bar for each named category of one-way commute times, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- D. Histogram with counts 10-19 minutes: 3; 20-29 minutes: 4; 30-39 minutes: 3; 40-49 minutes: 1; 50-59 minutes: 1  · _distractor: u1_5__miscounted_bin_frequency_

#### 9. seed `105008`  ·  valid: yes

**Prompt.** The quiz scores (points) are 63, 67, 68, 71, 75, 77, 79, 83, 87, 89, 90, 95. Which representation correctly displays these quantitative data?

- **A. Histogram with counts 60-64 points: 1; 65-69 points: 2; 70-74 points: 1; 75-79 points: 3; 80-84 points: 1; 85-89 points: 2; 90-94 points: 1; 95-99 points: 1; 100-104 points: 0**  ✔ _key_
- B. Histogram with counts 60-64 points: 1; 65-69 points: 1; 70-74 points: 2; 75-79 points: 3; 80-84 points: 1; 85-89 points: 2; 90-94 points: 1; 95-99 points: 1; 100-104 points: 0  · _distractor: u1_5__miscounted_bin_frequency_
- C. Stemplot 63 | 0; 67 | 0; 68 | 0; 71 | 0; 75 | 0; 77 | 0; 79 | 0; 83 | 0; 87 | 0; 89 | 0; 90 | 0; 95 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- D. Bar chart with one bar for each named category of quiz scores, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_

#### 10. seed `105009`  ·  valid: yes

**Prompt.** The quiz scores (points) are 61, 67, 67, 70, 73, 79, 81, 84, 86, 89, 93, 97. Which representation correctly displays these quantitative data?

- A. Stemplot 61 | 0; 67 | 0 0; 70 | 0; 73 | 0; 79 | 0; 81 | 0; 84 | 0; 86 | 0; 89 | 0; 93 | 0; 97 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- B. Histogram with counts 60-64 points: 1; 65-69 points: 2; 70-74 points: 2; 75-79 points: 1; 80-84 points: 2; 85-89 points: 2; 90-94 points: 1; 95-99 points: 0; 100-104 points: 1  · _distractor: u1_5__miscounted_bin_frequency_
- **C. Histogram with counts 60-64 points: 1; 65-69 points: 2; 70-74 points: 2; 75-79 points: 1; 80-84 points: 2; 85-89 points: 2; 90-94 points: 1; 95-99 points: 1; 100-104 points: 0**  ✔ _key_
- D. Bar chart with one bar for each named category of quiz scores, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_

#### 11. seed `105010`  ·  valid: yes

**Prompt.** The quiz scores (points) are 62, 68, 67, 72, 73, 76, 79, 84, 86, 87, 91, 94. Which representation correctly displays these quantitative data?

- A. Stemplot 62 | 0; 67 | 0; 68 | 0; 72 | 0; 73 | 0; 76 | 0; 79 | 0; 84 | 0; 86 | 0; 87 | 0; 91 | 0; 94 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- B. Histogram with counts 60-64 points: 0; 65-69 points: 3; 70-74 points: 2; 75-79 points: 2; 80-84 points: 1; 85-89 points: 2; 90-94 points: 2; 95-99 points: 0  · _distractor: u1_5__miscounted_bin_frequency_
- **C. Histogram with counts 60-64 points: 1; 65-69 points: 2; 70-74 points: 2; 75-79 points: 2; 80-84 points: 1; 85-89 points: 2; 90-94 points: 2; 95-99 points: 0**  ✔ _key_
- D. Bar chart with one bar for each named category of quiz scores, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_

#### 12. seed `105011`  ·  valid: yes

**Prompt.** The battery life (hours) are 7, 7, 10, 10, 10, 10, 13, 11, 13, 16, 16, 14. Which representation correctly displays these quantitative data?

- **A. Histogram with counts 0-9 hours: 2; 10-19 hours: 10; 20-29 hours: 0**  ✔ _key_
- B. Stemplot 7 | 0 0; 10 | 0 0 0 0; 11 | 0; 13 | 0 0; 14 | 0; 16 | 0 0  · _distractor: u1_5__stem_leaf_place_value_error_
- C. Bar chart with one bar for each named category of battery life, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- D. Histogram with counts 0-9 hours: 1; 10-19 hours: 11; 20-29 hours: 0  · _distractor: u1_5__miscounted_bin_frequency_

#### 13. seed `105012`  ·  valid: yes

**Prompt.** The battery life (hours) are 6, 8, 10, 8, 9, 12, 10, 12, 13, 16, 16, 17. Which representation correctly displays these quantitative data?

- A. Stemplot 6 | 0; 8 | 0 0; 9 | 0; 10 | 0 0; 12 | 0 0; 13 | 0; 16 | 0 0; 17 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- B. Bar chart with one bar for each named category of battery life, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- C. Histogram with counts 0-9 hours: 4; 10-19 hours: 7; 20-29 hours: 1  · _distractor: u1_5__miscounted_bin_frequency_
- **D. Histogram with counts 0-9 hours: 4; 10-19 hours: 8; 20-29 hours: 0**  ✔ _key_

#### 14. seed `105013`  ·  valid: yes

**Prompt.** The quiz scores (points) are 61, 68, 69, 70, 75, 79, 80, 84, 87, 88, 90, 96. Which representation correctly displays these quantitative data?

- A. Bar chart with one bar for each named category of quiz scores, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- **B. Histogram with counts 60-64 points: 1; 65-69 points: 2; 70-74 points: 1; 75-79 points: 2; 80-84 points: 2; 85-89 points: 2; 90-94 points: 1; 95-99 points: 1; 100-104 points: 0**  ✔ _key_
- C. Histogram with counts 60-64 points: 1; 65-69 points: 1; 70-74 points: 2; 75-79 points: 2; 80-84 points: 2; 85-89 points: 2; 90-94 points: 1; 95-99 points: 1; 100-104 points: 0  · _distractor: u1_5__miscounted_bin_frequency_
- D. Stemplot 61 | 0; 68 | 0; 69 | 0; 70 | 0; 75 | 0; 79 | 0; 80 | 0; 84 | 0; 87 | 0; 88 | 0; 90 | 0; 96 | 0  · _distractor: u1_5__stem_leaf_place_value_error_

#### 15. seed `105014`  ·  valid: yes

**Prompt.** The one-way commute times (minutes) are 14, 16, 20, 24, 25, 24, 29, 34, 36, 36, 42, 45. Which representation correctly displays these quantitative data?

- **A. Histogram with counts 10-14 minutes: 1; 15-19 minutes: 1; 20-24 minutes: 3; 25-29 minutes: 2; 30-34 minutes: 1; 35-39 minutes: 2; 40-44 minutes: 1; 45-49 minutes: 1; 50-54 minutes: 0**  ✔ _key_
- B. Stemplot 14 | 0; 16 | 0; 20 | 0; 24 | 0 0; 25 | 0; 29 | 0; 34 | 0; 36 | 0 0; 42 | 0; 45 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- C. Bar chart with one bar for each named category of one-way commute times, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- D. Histogram with counts 10-14 minutes: 1; 15-19 minutes: 1; 20-24 minutes: 3; 25-29 minutes: 2; 30-34 minutes: 1; 35-39 minutes: 1; 40-44 minutes: 2; 45-49 minutes: 1; 50-54 minutes: 0  · _distractor: u1_5__miscounted_bin_frequency_

#### 16. seed `105015`  ·  valid: yes

**Prompt.** The online order totals (dollars) are 20, 22, 28, 29, 31, 34, 38, 44, 47, 49, 52, 58. Which representation correctly displays these quantitative data?

- **A. Histogram with counts 20-29 dollars: 4; 30-39 dollars: 3; 40-49 dollars: 3; 50-59 dollars: 2; 60-69 dollars: 0**  ✔ _key_
- B. Histogram with counts 20-29 dollars: 4; 30-39 dollars: 2; 40-49 dollars: 4; 50-59 dollars: 2; 60-69 dollars: 0  · _distractor: u1_5__miscounted_bin_frequency_
- C. Bar chart with one bar for each named category of online order totals, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- D. Stemplot 20 | 0; 22 | 0; 28 | 0; 29 | 0; 31 | 0; 34 | 0; 38 | 0; 44 | 0; 47 | 0; 49 | 0; 52 | 0; 58 | 0  · _distractor: u1_5__stem_leaf_place_value_error_

#### 17. seed `105016`  ·  valid: yes

**Prompt.** The battery life (hours) are 8, 10, 10, 9, 12, 11, 10, 12, 12, 15, 15, 17. Which representation correctly displays these quantitative data?

- A. Histogram with counts 5-9 hours: 2; 10-14 hours: 6; 15-19 hours: 4; 20-24 hours: 0  · _distractor: u1_5__miscounted_bin_frequency_
- B. Stemplot 8 | 0; 9 | 0; 10 | 0 0 0; 11 | 0; 12 | 0 0 0; 15 | 0 0; 17 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- **C. Histogram with counts 5-9 hours: 2; 10-14 hours: 7; 15-19 hours: 3; 20-24 hours: 0**  ✔ _key_
- D. Bar chart with one bar for each named category of battery life, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_

#### 18. seed `105017`  ·  valid: yes

**Prompt.** The seedling heights (cm) are 8, 12, 13, 14, 13, 16, 15, 17, 21, 21, 22, 24. Which representation correctly displays these quantitative data?

- A. Histogram with counts 0-9 cm: 1; 10-19 cm: 7; 20-29 cm: 3; 30-39 cm: 1  · _distractor: u1_5__miscounted_bin_frequency_
- B. Stemplot 8 | 0; 12 | 0; 13 | 0 0; 14 | 0; 15 | 0; 16 | 0; 17 | 0; 21 | 0 0; 22 | 0; 24 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- C. Bar chart with one bar for each named category of seedling heights, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- **D. Histogram with counts 0-9 cm: 1; 10-19 cm: 7; 20-29 cm: 4; 30-39 cm: 0**  ✔ _key_

#### 19. seed `105018`  ·  valid: yes

**Prompt.** The online order totals (dollars) are 18, 22, 25, 31, 32, 36, 38, 43, 46, 49, 54, 58. Which representation correctly displays these quantitative data?

- **A. Histogram with counts 15-19 dollars: 1; 20-24 dollars: 1; 25-29 dollars: 1; 30-34 dollars: 2; 35-39 dollars: 2; 40-44 dollars: 1; 45-49 dollars: 2; 50-54 dollars: 1; 55-59 dollars: 1; 60-64 dollars: 0**  ✔ _key_
- B. Stemplot 18 | 0; 22 | 0; 25 | 0; 31 | 0; 32 | 0; 36 | 0; 38 | 0; 43 | 0; 46 | 0; 49 | 0; 54 | 0; 58 | 0  · _distractor: u1_5__stem_leaf_place_value_error_
- C. Bar chart with one bar for each named category of online order totals, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- D. Histogram with counts 15-19 dollars: 1; 20-24 dollars: 1; 25-29 dollars: 1; 30-34 dollars: 2; 35-39 dollars: 2; 40-44 dollars: 0; 45-49 dollars: 3; 50-54 dollars: 1; 55-59 dollars: 1; 60-64 dollars: 0  · _distractor: u1_5__miscounted_bin_frequency_

#### 20. seed `105019`  ·  valid: yes

**Prompt.** The battery life (hours) are 8, 7, 8, 9, 10, 11, 12, 12, 12, 15, 13, 15. Which representation correctly displays these quantitative data?

- A. Histogram with counts 5-9 hours: 4; 10-14 hours: 6; 15-19 hours: 1; 20-24 hours: 1  · _distractor: u1_5__miscounted_bin_frequency_
- B. Stemplot 7 | 0; 8 | 0 0; 9 | 0; 10 | 0; 11 | 0; 12 | 0 0 0; 13 | 0; 15 | 0 0  · _distractor: u1_5__stem_leaf_place_value_error_
- C. Bar chart with one bar for each named category of battery life, rather than a numeric axis  · _distractor: u1_5__wrong_plot_type_for_data_
- **D. Histogram with counts 5-9 hours: 4; 10-14 hours: 6; 15-19 hours: 2; 20-24 hours: 0**  ✔ _key_

---

## 1.6 x 4.A — Describe a distribution (interpret)

Template/frame: `FB-U1-6-4A-DISTRIBUTION-01` · serving: MCQ · sample: 20 instances (all valid: yes)

#### 1. seed `106000`  ·  valid: yes

**Prompt.** A summary of online order totals (dollars) is: min 30, Q1 45, median 55, Q3 65, max 80, and mean about 55. Which description is best supported by the summary?

- A. The distribution is right-skewed, centered near the median 55, with IQR 20, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- B. The distribution is roughly symmetric, centered near the IQR 20, with spread about the median 55, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- **C. The distribution is roughly symmetric, centered near the median 55, with IQR 20, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- D. The distribution is roughly symmetric, centered near the median 55, with IQR 20, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_

#### 2. seed `106001`  ·  valid: yes

**Prompt.** A summary of quiz scores (points) is: min 27, Q1 45, median 55, Q3 59, max 69, and mean about 50. Which description is best supported by the summary?

- **A. The distribution is left-skewed, centered near the median 55, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- B. The median is about 55 points and the IQR is about 14 points.  · _distractor: u1_6__ignores_shape_reports_center_only_
- C. The distribution is right-skewed, centered near the median 55, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- D. The distribution is left-skewed, centered near the IQR 14, with spread about the median 55, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_

#### 3. seed `106002`  ·  valid: yes

**Prompt.** A summary of quiz scores (points) is: min 22, Q1 40, median 50, Q3 54, max 64, and mean about 45. Which description is best supported by the summary?

- A. The distribution is right-skewed, centered near the median 50, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- **B. The distribution is left-skewed, centered near the median 50, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- C. The median is about 50 points and the IQR is about 14 points.  · _distractor: u1_6__ignores_shape_reports_center_only_
- D. The distribution is left-skewed, centered near the median 50, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_

#### 4. seed `106003`  ·  valid: yes

**Prompt.** A summary of quiz scores (points) is: min 20, Q1 30, median 34, Q3 44, max 62, and mean about 39. Which description is best supported by the summary?

- **A. The distribution is right-skewed, centered near the median 34, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- B. The distribution is right-skewed, centered near the IQR 14, with spread about the median 34, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- C. The median is about 34 points and the IQR is about 14 points.  · _distractor: u1_6__ignores_shape_reports_center_only_
- D. The distribution is right-skewed, centered near the median 34, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_

#### 5. seed `106004`  ·  valid: yes

**Prompt.** A summary of online order totals (dollars) is: min 40, Q1 55, median 65, Q3 75, max 90, and mean about 65. Which description is best supported by the summary?

- A. The distribution is roughly symmetric, centered near the median 65, with IQR 20, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_
- **B. The distribution is roughly symmetric, centered near the median 65, with IQR 20, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- C. The median is about 65 dollars and the IQR is about 20 dollars.  · _distractor: u1_6__ignores_shape_reports_center_only_
- D. The distribution is roughly symmetric, centered near the IQR 20, with spread about the median 65, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_

#### 6. seed `106005`  ·  valid: yes

**Prompt.** A summary of battery life (hours) is: min 32, Q1 50, median 60, Q3 64, max 74, and mean about 55. Which description is best supported by the summary?

- **A. The distribution is left-skewed, centered near the median 60, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- B. The distribution is left-skewed, centered near the median 60, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_
- C. The median is about 60 hours and the IQR is about 14 hours.  · _distractor: u1_6__ignores_shape_reports_center_only_
- D. The distribution is right-skewed, centered near the median 60, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_

#### 7. seed `106006`  ·  valid: yes

**Prompt.** A summary of one-way commute times (minutes) is: min 37, Q1 55, median 65, Q3 69, max 79, and mean about 60. Which description is best supported by the summary?

- **A. The distribution is left-skewed, centered near the median 65, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- B. The distribution is left-skewed, centered near the IQR 14, with spread about the median 65, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- C. The distribution is right-skewed, centered near the median 65, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- D. The distribution is left-skewed, centered near the median 65, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_

#### 8. seed `106007`  ·  valid: yes

**Prompt.** A summary of quiz scores (points) is: min 25, Q1 40, median 50, Q3 60, max 75, and mean about 50. Which description is best supported by the summary?

- A. The median is about 50 points and the IQR is about 20 points.  · _distractor: u1_6__ignores_shape_reports_center_only_
- B. The distribution is roughly symmetric, centered near the median 50, with IQR 20, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_
- C. The distribution is roughly symmetric, centered near the IQR 20, with spread about the median 50, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- **D. The distribution is roughly symmetric, centered near the median 50, with IQR 20, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_

#### 9. seed `106008`  ·  valid: yes

**Prompt.** A summary of seedling heights (cm) is: min 32, Q1 50, median 60, Q3 64, max 74, and mean about 55. Which description is best supported by the summary?

- A. The distribution is right-skewed, centered near the median 60, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- B. The median is about 60 cm and the IQR is about 14 cm.  · _distractor: u1_6__ignores_shape_reports_center_only_
- C. The distribution is left-skewed, centered near the median 60, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_
- **D. The distribution is left-skewed, centered near the median 60, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_

#### 10. seed `106009`  ·  valid: yes

**Prompt.** A summary of battery life (hours) is: min 27, Q1 45, median 55, Q3 59, max 69, and mean about 50. Which description is best supported by the summary?

- A. The distribution is left-skewed, centered near the IQR 14, with spread about the median 55, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- **B. The distribution is left-skewed, centered near the median 55, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- C. The distribution is left-skewed, centered near the median 55, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_
- D. The median is about 55 hours and the IQR is about 14 hours.  · _distractor: u1_6__ignores_shape_reports_center_only_

#### 11. seed `106010`  ·  valid: yes

**Prompt.** A summary of quiz scores (points) is: min 37, Q1 55, median 65, Q3 69, max 79, and mean about 60. Which description is best supported by the summary?

- A. The distribution is right-skewed, centered near the median 65, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- B. The distribution is left-skewed, centered near the IQR 14, with spread about the median 65, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- C. The median is about 65 points and the IQR is about 14 points.  · _distractor: u1_6__ignores_shape_reports_center_only_
- **D. The distribution is left-skewed, centered near the median 65, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_

#### 12. seed `106011`  ·  valid: yes

**Prompt.** A summary of one-way commute times (minutes) is: min 22, Q1 40, median 50, Q3 54, max 64, and mean about 45. Which description is best supported by the summary?

- A. The distribution is left-skewed, centered near the IQR 14, with spread about the median 50, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- B. The median is about 50 minutes and the IQR is about 14 minutes.  · _distractor: u1_6__ignores_shape_reports_center_only_
- **C. The distribution is left-skewed, centered near the median 50, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- D. The distribution is right-skewed, centered near the median 50, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_

#### 13. seed `106012`  ·  valid: yes

**Prompt.** A summary of quiz scores (points) is: min 37, Q1 55, median 65, Q3 69, max 79, and mean about 60. Which description is best supported by the summary?

- **A. The distribution is left-skewed, centered near the median 65, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- B. The distribution is right-skewed, centered near the median 65, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- C. The median is about 65 points and the IQR is about 14 points.  · _distractor: u1_6__ignores_shape_reports_center_only_
- D. The distribution is left-skewed, centered near the median 65, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_

#### 14. seed `106013`  ·  valid: yes

**Prompt.** A summary of seedling heights (cm) is: min 32, Q1 50, median 60, Q3 64, max 74, and mean about 55. Which description is best supported by the summary?

- **A. The distribution is left-skewed, centered near the median 60, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- B. The distribution is left-skewed, centered near the IQR 14, with spread about the median 60, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- C. The distribution is left-skewed, centered near the median 60, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_
- D. The distribution is right-skewed, centered near the median 60, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_

#### 15. seed `106014`  ·  valid: yes

**Prompt.** A summary of battery life (hours) is: min 40, Q1 55, median 65, Q3 75, max 90, and mean about 65. Which description is best supported by the summary?

- A. The distribution is right-skewed, centered near the median 65, with IQR 20, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- B. The median is about 65 hours and the IQR is about 20 hours.  · _distractor: u1_6__ignores_shape_reports_center_only_
- C. The distribution is roughly symmetric, centered near the IQR 20, with spread about the median 65, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- **D. The distribution is roughly symmetric, centered near the median 65, with IQR 20, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_

#### 16. seed `106015`  ·  valid: yes

**Prompt.** A summary of battery life (hours) is: min 27, Q1 45, median 55, Q3 59, max 69, and mean about 50. Which description is best supported by the summary?

- **A. The distribution is left-skewed, centered near the median 55, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- B. The distribution is left-skewed, centered near the IQR 14, with spread about the median 55, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- C. The distribution is right-skewed, centered near the median 55, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- D. The distribution is left-skewed, centered near the median 55, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_

#### 17. seed `106016`  ·  valid: yes

**Prompt.** A summary of seedling heights (cm) is: min 15, Q1 25, median 29, Q3 39, max 57, and mean about 34. Which description is best supported by the summary?

- **A. The distribution is right-skewed, centered near the median 29, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- B. The distribution is right-skewed, centered near the IQR 14, with spread about the median 29, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- C. The distribution is right-skewed, centered near the median 29, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_
- D. The distribution is left-skewed, centered near the median 29, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_

#### 18. seed `106017`  ·  valid: yes

**Prompt.** A summary of battery life (hours) is: min 32, Q1 50, median 60, Q3 64, max 74, and mean about 55. Which description is best supported by the summary?

- A. The distribution is left-skewed, centered near the median 60, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_
- B. The distribution is left-skewed, centered near the IQR 14, with spread about the median 60, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__center_spread_confused_
- C. The distribution is right-skewed, centered near the median 60, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- **D. The distribution is left-skewed, centered near the median 60, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_

#### 19. seed `106018`  ·  valid: yes

**Prompt.** A summary of quiz scores (points) is: min 32, Q1 50, median 60, Q3 64, max 74, and mean about 55. Which description is best supported by the summary?

- A. The median is about 60 points and the IQR is about 14 points.  · _distractor: u1_6__ignores_shape_reports_center_only_
- B. The distribution is right-skewed, centered near the median 60, with IQR 14, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- C. The distribution is left-skewed, centered near the median 60, with IQR 14, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_
- **D. The distribution is left-skewed, centered near the median 60, with IQR 14, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_

#### 20. seed `106019`  ·  valid: yes

**Prompt.** A summary of one-way commute times (minutes) is: min 35, Q1 50, median 60, Q3 70, max 85, and mean about 60. Which description is best supported by the summary?

- **A. The distribution is roughly symmetric, centered near the median 60, with IQR 20, and there are no outliers by the 1.5 x IQR rule.**  ✔ _key_
- B. The median is about 60 minutes and the IQR is about 20 minutes.  · _distractor: u1_6__ignores_shape_reports_center_only_
- C. The distribution is right-skewed, centered near the median 60, with IQR 20, and there are no outliers by the 1.5 x IQR rule.  · _distractor: u1_6__skew_direction_reversed_
- D. The distribution is roughly symmetric, centered near the median 60, with IQR 20, and the maximum is an outlier because it is far from the minimum.  · _distractor: u1_6__outlier_from_range_not_fences_

---

## 1.8 x 3.A — Boxplots (represent)

Template/frame: `FB-U1-8-3A-BOXPLOT-01` · serving: MCQ · sample: 20 instances (all valid: yes)

#### 1. seed `108000`  ·  valid: yes

**Prompt.** For seedling heights (cm), a summary is min 7, Q1 12, median 15, Q3 19, max 31. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 7 and 25. Which modified boxplot description matches this summary?

- A. Box from 15 to 19 cm, median line at 12, whiskers to 7 and 25, with plotted outlier(s) at 31.  · _distractor: u1_8__quartile_median_positions_swapped_
- **B. Box from 12 to 19 cm, median line at 15, whiskers to 7 and 25, with plotted outlier(s) at 31.**  ✔ _key_
- C. Box from 12 to 19 cm, median line at 15, whiskers to 7 and 31, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- D. Box from 7 to 31 cm, median line at 15, whiskers to 7 and 31, with plotted outlier(s) at 31.  · _distractor: u1_8__box_spans_range_not_iqr_

#### 2. seed `108001`  ·  valid: yes

**Prompt.** For one-way commute times (minutes), a summary is min 18, Q1 24, median 28, Q3 34, max 54. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 18 and 42. Which modified boxplot description matches this summary?

- **A. Box from 24 to 34 minutes, median line at 28, whiskers to 18 and 42, with plotted outlier(s) at 54.**  ✔ _key_
- B. Box from 24 to 34 minutes, median line at 28, whiskers to 18 and 54, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- C. Box from 18 to 54 minutes, median line at 28, whiskers to 18 and 54, with plotted outlier(s) at 54.  · _distractor: u1_8__box_spans_range_not_iqr_
- D. Box from 28 to 34 minutes, median line at 24, whiskers to 18 and 42, with plotted outlier(s) at 54.  · _distractor: u1_8__quartile_median_positions_swapped_

#### 3. seed `108002`  ·  valid: yes

**Prompt.** For quiz scores (points), a summary is min 38, Q1 70, median 76, Q3 84, max 96. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 60 and 96. Which modified boxplot description matches this summary?

- A. Box from 38 to 96 points, median line at 76, whiskers to 38 and 96, with plotted outlier(s) at 38.  · _distractor: u1_8__box_spans_range_not_iqr_
- B. Box from 76 to 84 points, median line at 70, whiskers to 60 and 96, with plotted outlier(s) at 38.  · _distractor: u1_8__quartile_median_positions_swapped_
- **C. Box from 70 to 84 points, median line at 76, whiskers to 60 and 96, with plotted outlier(s) at 38.**  ✔ _key_
- D. Box from 70 to 84 points, median line at 76, whiskers to 38 and 96, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_

#### 4. seed `108003`  ·  valid: yes

**Prompt.** For one-way commute times (minutes), a summary is min 16, Q1 22, median 26, Q3 32, max 52. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 16 and 40. Which modified boxplot description matches this summary?

- A. Box from 26 to 32 minutes, median line at 22, whiskers to 16 and 40, with plotted outlier(s) at 52.  · _distractor: u1_8__quartile_median_positions_swapped_
- **B. Box from 22 to 32 minutes, median line at 26, whiskers to 16 and 40, with plotted outlier(s) at 52.**  ✔ _key_
- C. Box from 22 to 32 minutes, median line at 26, whiskers to 16 and 52, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- D. Box from 16 to 52 minutes, median line at 26, whiskers to 16 and 52, with plotted outlier(s) at 52.  · _distractor: u1_8__box_spans_range_not_iqr_

#### 5. seed `108004`  ·  valid: yes

**Prompt.** For quiz scores (points), a summary is min 36, Q1 68, median 74, Q3 82, max 94. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 58 and 94. Which modified boxplot description matches this summary?

- **A. Box from 68 to 82 points, median line at 74, whiskers to 58 and 94, with plotted outlier(s) at 36.**  ✔ _key_
- B. Box from 74 to 82 points, median line at 68, whiskers to 58 and 94, with plotted outlier(s) at 36.  · _distractor: u1_8__quartile_median_positions_swapped_
- C. Box from 36 to 94 points, median line at 74, whiskers to 36 and 94, with plotted outlier(s) at 36.  · _distractor: u1_8__box_spans_range_not_iqr_
- D. Box from 68 to 82 points, median line at 74, whiskers to 36 and 94, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_

#### 6. seed `108005`  ·  valid: yes

**Prompt.** For quiz scores (points), a summary is min 36, Q1 68, median 74, Q3 82, max 94. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 58 and 94. Which modified boxplot description matches this summary?

- A. Box from 74 to 82 points, median line at 68, whiskers to 58 and 94, with plotted outlier(s) at 36.  · _distractor: u1_8__quartile_median_positions_swapped_
- **B. Box from 68 to 82 points, median line at 74, whiskers to 58 and 94, with plotted outlier(s) at 36.**  ✔ _key_
- C. Box from 68 to 82 points, median line at 74, whiskers to 36 and 94, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- D. Box from 36 to 94 points, median line at 74, whiskers to 36 and 94, with plotted outlier(s) at 36.  · _distractor: u1_8__box_spans_range_not_iqr_

#### 7. seed `108006`  ·  valid: yes

**Prompt.** For one-way commute times (minutes), a summary is min 12, Q1 18, median 22, Q3 28, max 48. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 12 and 36. Which modified boxplot description matches this summary?

- A. Box from 18 to 28 minutes, median line at 22, whiskers to 12 and 48, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- B. Box from 22 to 28 minutes, median line at 18, whiskers to 12 and 36, with plotted outlier(s) at 48.  · _distractor: u1_8__quartile_median_positions_swapped_
- **C. Box from 18 to 28 minutes, median line at 22, whiskers to 12 and 36, with plotted outlier(s) at 48.**  ✔ _key_
- D. Box from 12 to 48 minutes, median line at 22, whiskers to 12 and 48, with plotted outlier(s) at 48.  · _distractor: u1_8__box_spans_range_not_iqr_

#### 8. seed `108007`  ·  valid: yes

**Prompt.** For online order totals (dollars), a summary is min 20, Q1 30, median 37, Q3 44, max 73. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 20 and 61. Which modified boxplot description matches this summary?

- A. Box from 20 to 73 dollars, median line at 37, whiskers to 20 and 73, with plotted outlier(s) at 73.  · _distractor: u1_8__box_spans_range_not_iqr_
- B. Box from 30 to 44 dollars, median line at 37, whiskers to 20 and 73, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- **C. Box from 30 to 44 dollars, median line at 37, whiskers to 20 and 61, with plotted outlier(s) at 73.**  ✔ _key_
- D. Box from 37 to 44 dollars, median line at 30, whiskers to 20 and 61, with plotted outlier(s) at 73.  · _distractor: u1_8__quartile_median_positions_swapped_

#### 9. seed `108008`  ·  valid: yes

**Prompt.** For online order totals (dollars), a summary is min 20, Q1 30, median 37, Q3 44, max 73. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 20 and 61. Which modified boxplot description matches this summary?

- A. Box from 30 to 44 dollars, median line at 37, whiskers to 20 and 73, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- B. Box from 37 to 44 dollars, median line at 30, whiskers to 20 and 61, with plotted outlier(s) at 73.  · _distractor: u1_8__quartile_median_positions_swapped_
- C. Box from 20 to 73 dollars, median line at 37, whiskers to 20 and 73, with plotted outlier(s) at 73.  · _distractor: u1_8__box_spans_range_not_iqr_
- **D. Box from 30 to 44 dollars, median line at 37, whiskers to 20 and 61, with plotted outlier(s) at 73.**  ✔ _key_

#### 10. seed `108009`  ·  valid: yes

**Prompt.** For battery life (hours), a summary is min 11, Q1 14, median 16, Q3 18, max 26. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 11 and 21. Which modified boxplot description matches this summary?

- **A. Box from 14 to 18 hours, median line at 16, whiskers to 11 and 21, with plotted outlier(s) at 26.**  ✔ _key_
- B. Box from 14 to 18 hours, median line at 16, whiskers to 11 and 26, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- C. Box from 16 to 18 hours, median line at 14, whiskers to 11 and 21, with plotted outlier(s) at 26.  · _distractor: u1_8__quartile_median_positions_swapped_
- D. Box from 11 to 26 hours, median line at 16, whiskers to 11 and 26, with plotted outlier(s) at 26.  · _distractor: u1_8__box_spans_range_not_iqr_

#### 11. seed `108010`  ·  valid: yes

**Prompt.** For one-way commute times (minutes), a summary is min 14, Q1 20, median 24, Q3 30, max 50. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 14 and 38. Which modified boxplot description matches this summary?

- A. Box from 14 to 50 minutes, median line at 24, whiskers to 14 and 50, with plotted outlier(s) at 50.  · _distractor: u1_8__box_spans_range_not_iqr_
- **B. Box from 20 to 30 minutes, median line at 24, whiskers to 14 and 38, with plotted outlier(s) at 50.**  ✔ _key_
- C. Box from 20 to 30 minutes, median line at 24, whiskers to 14 and 50, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- D. Box from 24 to 30 minutes, median line at 20, whiskers to 14 and 38, with plotted outlier(s) at 50.  · _distractor: u1_8__quartile_median_positions_swapped_

#### 12. seed `108011`  ·  valid: yes

**Prompt.** For online order totals (dollars), a summary is min 18, Q1 28, median 35, Q3 42, max 71. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 18 and 59. Which modified boxplot description matches this summary?

- A. Box from 18 to 71 dollars, median line at 35, whiskers to 18 and 71, with plotted outlier(s) at 71.  · _distractor: u1_8__box_spans_range_not_iqr_
- **B. Box from 28 to 42 dollars, median line at 35, whiskers to 18 and 59, with plotted outlier(s) at 71.**  ✔ _key_
- C. Box from 35 to 42 dollars, median line at 28, whiskers to 18 and 59, with plotted outlier(s) at 71.  · _distractor: u1_8__quartile_median_positions_swapped_
- D. Box from 28 to 42 dollars, median line at 35, whiskers to 18 and 71, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_

#### 13. seed `108012`  ·  valid: yes

**Prompt.** For one-way commute times (minutes), a summary is min 14, Q1 20, median 24, Q3 30, max 50. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 14 and 38. Which modified boxplot description matches this summary?

- **A. Box from 20 to 30 minutes, median line at 24, whiskers to 14 and 38, with plotted outlier(s) at 50.**  ✔ _key_
- B. Box from 24 to 30 minutes, median line at 20, whiskers to 14 and 38, with plotted outlier(s) at 50.  · _distractor: u1_8__quartile_median_positions_swapped_
- C. Box from 20 to 30 minutes, median line at 24, whiskers to 14 and 50, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- D. Box from 14 to 50 minutes, median line at 24, whiskers to 14 and 50, with plotted outlier(s) at 50.  · _distractor: u1_8__box_spans_range_not_iqr_

#### 14. seed `108013`  ·  valid: yes

**Prompt.** For battery life (hours), a summary is min 7, Q1 10, median 12, Q3 14, max 22. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 7 and 17. Which modified boxplot description matches this summary?

- A. Box from 10 to 14 hours, median line at 12, whiskers to 7 and 22, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- B. Box from 12 to 14 hours, median line at 10, whiskers to 7 and 17, with plotted outlier(s) at 22.  · _distractor: u1_8__quartile_median_positions_swapped_
- C. Box from 7 to 22 hours, median line at 12, whiskers to 7 and 22, with plotted outlier(s) at 22.  · _distractor: u1_8__box_spans_range_not_iqr_
- **D. Box from 10 to 14 hours, median line at 12, whiskers to 7 and 17, with plotted outlier(s) at 22.**  ✔ _key_

#### 15. seed `108014`  ·  valid: yes

**Prompt.** For online order totals (dollars), a summary is min 20, Q1 30, median 37, Q3 44, max 73. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 20 and 61. Which modified boxplot description matches this summary?

- A. Box from 30 to 44 dollars, median line at 37, whiskers to 20 and 73, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- B. Box from 37 to 44 dollars, median line at 30, whiskers to 20 and 61, with plotted outlier(s) at 73.  · _distractor: u1_8__quartile_median_positions_swapped_
- C. Box from 20 to 73 dollars, median line at 37, whiskers to 20 and 73, with plotted outlier(s) at 73.  · _distractor: u1_8__box_spans_range_not_iqr_
- **D. Box from 30 to 44 dollars, median line at 37, whiskers to 20 and 61, with plotted outlier(s) at 73.**  ✔ _key_

#### 16. seed `108015`  ·  valid: yes

**Prompt.** For online order totals (dollars), a summary is min 14, Q1 24, median 31, Q3 38, max 67. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 14 and 55. Which modified boxplot description matches this summary?

- **A. Box from 24 to 38 dollars, median line at 31, whiskers to 14 and 55, with plotted outlier(s) at 67.**  ✔ _key_
- B. Box from 24 to 38 dollars, median line at 31, whiskers to 14 and 67, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- C. Box from 31 to 38 dollars, median line at 24, whiskers to 14 and 55, with plotted outlier(s) at 67.  · _distractor: u1_8__quartile_median_positions_swapped_
- D. Box from 14 to 67 dollars, median line at 31, whiskers to 14 and 67, with plotted outlier(s) at 67.  · _distractor: u1_8__box_spans_range_not_iqr_

#### 17. seed `108016`  ·  valid: yes

**Prompt.** For online order totals (dollars), a summary is min 14, Q1 24, median 31, Q3 38, max 67. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 14 and 55. Which modified boxplot description matches this summary?

- A. Box from 14 to 67 dollars, median line at 31, whiskers to 14 and 67, with plotted outlier(s) at 67.  · _distractor: u1_8__box_spans_range_not_iqr_
- B. Box from 31 to 38 dollars, median line at 24, whiskers to 14 and 55, with plotted outlier(s) at 67.  · _distractor: u1_8__quartile_median_positions_swapped_
- **C. Box from 24 to 38 dollars, median line at 31, whiskers to 14 and 55, with plotted outlier(s) at 67.**  ✔ _key_
- D. Box from 24 to 38 dollars, median line at 31, whiskers to 14 and 67, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_

#### 18. seed `108017`  ·  valid: yes

**Prompt.** For quiz scores (points), a summary is min 40, Q1 72, median 78, Q3 86, max 98. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 62 and 98. Which modified boxplot description matches this summary?

- A. Box from 72 to 86 points, median line at 78, whiskers to 40 and 98, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- B. Box from 40 to 98 points, median line at 78, whiskers to 40 and 98, with plotted outlier(s) at 40.  · _distractor: u1_8__box_spans_range_not_iqr_
- C. Box from 78 to 86 points, median line at 72, whiskers to 62 and 98, with plotted outlier(s) at 40.  · _distractor: u1_8__quartile_median_positions_swapped_
- **D. Box from 72 to 86 points, median line at 78, whiskers to 62 and 98, with plotted outlier(s) at 40.**  ✔ _key_

#### 19. seed `108018`  ·  valid: yes

**Prompt.** For battery life (hours), a summary is min 11, Q1 14, median 16, Q3 18, max 26. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 11 and 21. Which modified boxplot description matches this summary?

- **A. Box from 14 to 18 hours, median line at 16, whiskers to 11 and 21, with plotted outlier(s) at 26.**  ✔ _key_
- B. Box from 16 to 18 hours, median line at 14, whiskers to 11 and 21, with plotted outlier(s) at 26.  · _distractor: u1_8__quartile_median_positions_swapped_
- C. Box from 14 to 18 hours, median line at 16, whiskers to 11 and 26, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_
- D. Box from 11 to 26 hours, median line at 16, whiskers to 11 and 26, with plotted outlier(s) at 26.  · _distractor: u1_8__box_spans_range_not_iqr_

#### 20. seed `108019`  ·  valid: yes

**Prompt.** For seedling heights (cm), a summary is min 9, Q1 14, median 17, Q3 21, max 33. Using the 1.5 x IQR rule, the non-outlier whisker endpoints are 9 and 27. Which modified boxplot description matches this summary?

- **A. Box from 14 to 21 cm, median line at 17, whiskers to 9 and 27, with plotted outlier(s) at 33.**  ✔ _key_
- B. Box from 9 to 33 cm, median line at 17, whiskers to 9 and 33, with plotted outlier(s) at 33.  · _distractor: u1_8__box_spans_range_not_iqr_
- C. Box from 17 to 21 cm, median line at 14, whiskers to 9 and 27, with plotted outlier(s) at 33.  · _distractor: u1_8__quartile_median_positions_swapped_
- D. Box from 14 to 21 cm, median line at 17, whiskers to 9 and 33, with no plotted outliers.  · _distractor: u1_8__whisker_to_extreme_ignores_outlier_

---

## 1.11 x 2.A — Random sampling (describe)

Template/frame: `FB-U1-11-2A-SAMPLING-01` · serving: MCQ · sample: 20 instances (all valid: yes)

#### 1. seed `101000`  ·  valid: yes

**Prompt.** A researcher wants to study how many hours they spend in school clubs each week among all students at a high school. Sampling plan: The researcher chooses a random starting position, 11, in an alphabetized roster of all students and then selects that entry and every 8th entry after it. Which choice best describes the sampling method?

- A. SRS, because the researcher uses a random starting point from a list.  · _distractor: u1_11__systematic_srs_conflation_
- **B. Systematic random sample, because a random start is followed by a fixed interval.**  ✔ _key_
- C. Cluster sample, because the population is divided into groups such as grade level before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- D. Convenience sample, because the randomly selected units are the ones the researcher contacts.  · _distractor: u1_11__convenience_or_voluntary_called_random_

#### 2. seed `101001`  ·  valid: yes

**Prompt.** A researcher wants to study whether they show signs of insect damage among trees on a college campus. Sampling plan: The researcher separates the population by tree species, then uses a random number generator to select some trees from every tree species group. Which choice best describes the sampling method?

- A. Systematic random sample, because the researcher uses random selection after organizing the population.  · _distractor: u1_11__systematic_srs_conflation_
- **B. Stratified random sample, because the population is grouped by tree species and some trees are randomly selected from every group.**  ✔ _key_
- C. Cluster sample, because the population is divided into groups such as tree species before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- D. Stratified random sample, because the researcher should randomly choose whole tree species groups and include everyone in them.  · _distractor: u1_11__stratified_samples_whole_groups_

#### 3. seed `101002`  ·  valid: yes

**Prompt.** A researcher wants to study how many hours they spend in school clubs each week among all students at a high school. Sampling plan: The researcher uses responses from students who choose to answer after seeing a link posted in the school announcements. Which choice best describes the sampling method?

- A. SRS, because any member of the population could have ended up in the response group.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- B. Stratified random sample, because the researcher should randomly choose whole grade level groups and include everyone in them.  · _distractor: u1_11__stratified_samples_whole_groups_
- C. Cluster sample, because the population is divided into groups such as grade level before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- **D. Not a random sample; it is a voluntary-response sample because units choose whether to respond.**  ✔ _key_

#### 4. seed `101003`  ·  valid: yes

**Prompt.** A researcher wants to study how many hours they spend in school clubs each week among all students at a high school. Sampling plan: The researcher uses an alphabetized roster of all students and a random number generator to select 40 students from the entire population. Which choice best describes the sampling method?

- A. Systematic random sample, because the researcher uses random selection after organizing the population.  · _distractor: u1_11__systematic_srs_conflation_
- **B. SRS, because individuals are randomly selected from a list of the whole population.**  ✔ _key_
- C. Cluster sample, because the population is divided into groups such as grade level before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- D. Convenience sample, because the randomly selected units are the ones the researcher contacts.  · _distractor: u1_11__convenience_or_voluntary_called_random_

#### 5. seed `101004`  ·  valid: yes

**Prompt.** A researcher wants to study whether they show signs of insect damage among trees on a college campus. Sampling plan: The researcher uses responses from trees who choose to answer after seeing reports submitted by anyone who noticed a damaged tree. Which choice best describes the sampling method?

- A. Cluster sample, because the population is divided into groups such as tree species before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- **B. Not a random sample; it is a voluntary-response sample because units choose whether to respond.**  ✔ _key_
- C. SRS, because any member of the population could have ended up in the response group.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- D. Stratified random sample, because the researcher should randomly choose whole tree species groups and include everyone in them.  · _distractor: u1_11__stratified_samples_whole_groups_

#### 6. seed `101005`  ·  valid: yes

**Prompt.** A researcher wants to study how many hours they spend in school clubs each week among all students at a high school. Sampling plan: The researcher chooses a random starting position, 11, in an alphabetized roster of all students and then selects that entry and every 10th entry after it. Which choice best describes the sampling method?

- A. SRS, because the researcher uses a random starting point from a list.  · _distractor: u1_11__systematic_srs_conflation_
- **B. Systematic random sample, because a random start is followed by a fixed interval.**  ✔ _key_
- C. Convenience sample, because the randomly selected units are the ones the researcher contacts.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- D. Cluster sample, because the population is divided into groups such as grade level before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_

#### 7. seed `101006`  ·  valid: yes

**Prompt.** A researcher wants to study which library services they used last month among adult patrons of a county library system. Sampling plan: The researcher records responses from patrons at the front desk of the main branch on Saturday morning. Which choice best describes the sampling method?

- **A. Not a random sample; it is a convenience sample because the units are easy to reach.**  ✔ _key_
- B. Stratified random sample, because the researcher should randomly choose whole branch library groups and include everyone in them.  · _distractor: u1_11__stratified_samples_whole_groups_
- C. SRS, because any member of the population could have ended up in the response group.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- D. Cluster sample, because the population is divided into groups such as branch library before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_

#### 8. seed `101007`  ·  valid: yes

**Prompt.** A researcher wants to study which library services they used last month among adult patrons of a county library system. Sampling plan: The researcher uses a numbered membership list and a random number generator to select 50 patrons from the entire population. Which choice best describes the sampling method?

- A. Cluster sample, because the population is divided into groups such as branch library before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- B. Systematic random sample, because the researcher uses random selection after organizing the population.  · _distractor: u1_11__systematic_srs_conflation_
- **C. SRS, because individuals are randomly selected from a list of the whole population.**  ✔ _key_
- D. Convenience sample, because the randomly selected units are the ones the researcher contacts.  · _distractor: u1_11__convenience_or_voluntary_called_random_

#### 9. seed `101008`  ·  valid: yes

**Prompt.** A researcher wants to study whether the delivery arrived by the promised date among orders placed with an online store last month. Sampling plan: The researcher chooses a random starting position, 4, in a numbered export of all order IDs and then selects that entry and every 8th entry after it. Which choice best describes the sampling method?

- **A. Systematic random sample, because a random start is followed by a fixed interval.**  ✔ _key_
- B. Cluster sample, because the population is divided into groups such as shipping region before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- C. Convenience sample, because the randomly selected units are the ones the researcher contacts.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- D. SRS, because the researcher uses a random starting point from a list.  · _distractor: u1_11__systematic_srs_conflation_

#### 10. seed `101009`  ·  valid: yes

**Prompt.** A researcher wants to study whether they show signs of insect damage among trees on a college campus. Sampling plan: The researcher chooses a random starting position, 4, in a numbered campus tree inventory and then selects that entry and every 10th entry after it. Which choice best describes the sampling method?

- A. Cluster sample, because the population is divided into groups such as tree species before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- **B. Systematic random sample, because a random start is followed by a fixed interval.**  ✔ _key_
- C. SRS, because the researcher uses a random starting point from a list.  · _distractor: u1_11__systematic_srs_conflation_
- D. Convenience sample, because the randomly selected units are the ones the researcher contacts.  · _distractor: u1_11__convenience_or_voluntary_called_random_

#### 11. seed `101010`  ·  valid: yes

**Prompt.** A researcher wants to study whether the delivery arrived by the promised date among orders placed with an online store last month. Sampling plan: The researcher uses a numbered export of all order IDs and a random number generator to select 30 orders from the entire population. Which choice best describes the sampling method?

- A. Convenience sample, because the randomly selected units are the ones the researcher contacts.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- **B. SRS, because individuals are randomly selected from a list of the whole population.**  ✔ _key_
- C. Systematic random sample, because the researcher uses random selection after organizing the population.  · _distractor: u1_11__systematic_srs_conflation_
- D. Cluster sample, because the population is divided into groups such as shipping region before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_

#### 12. seed `101011`  ·  valid: yes

**Prompt.** A researcher wants to study which library services they used last month among adult patrons of a county library system. Sampling plan: The researcher records responses from patrons at the front desk of the main branch on Saturday morning. Which choice best describes the sampling method?

- A. Stratified random sample, because the researcher should randomly choose whole branch library groups and include everyone in them.  · _distractor: u1_11__stratified_samples_whole_groups_
- B. Cluster sample, because the population is divided into groups such as branch library before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- **C. Not a random sample; it is a convenience sample because the units are easy to reach.**  ✔ _key_
- D. SRS, because any member of the population could have ended up in the response group.  · _distractor: u1_11__convenience_or_voluntary_called_random_

#### 13. seed `101012`  ·  valid: yes

**Prompt.** A researcher wants to study their satisfaction with bus arrival times among weekday bus riders in a city. Sampling plan: The researcher uses responses from riders who choose to answer after seeing a survey QR code on posters inside buses. Which choice best describes the sampling method?

- A. SRS, because any member of the population could have ended up in the response group.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- **B. Not a random sample; it is a voluntary-response sample because units choose whether to respond.**  ✔ _key_
- C. Stratified random sample, because the researcher should randomly choose whole bus route groups and include everyone in them.  · _distractor: u1_11__stratified_samples_whole_groups_
- D. Cluster sample, because the population is divided into groups such as bus route before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_

#### 14. seed `101013`  ·  valid: yes

**Prompt.** A researcher wants to study whether the delivery arrived by the promised date among orders placed with an online store last month. Sampling plan: The researcher separates the population by shipping region, then uses a random number generator to select some orders from every shipping region group. Which choice best describes the sampling method?

- A. Systematic random sample, because the researcher uses random selection after organizing the population.  · _distractor: u1_11__systematic_srs_conflation_
- B. Cluster sample, because the population is divided into groups such as shipping region before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- C. Stratified random sample, because the researcher should randomly choose whole shipping region groups and include everyone in them.  · _distractor: u1_11__stratified_samples_whole_groups_
- **D. Stratified random sample, because the population is grouped by shipping region and some orders are randomly selected from every group.**  ✔ _key_

#### 15. seed `101014`  ·  valid: yes

**Prompt.** A researcher wants to study whether they show signs of insect damage among trees on a college campus. Sampling plan: The researcher chooses a random starting position, 7, in a numbered campus tree inventory and then selects that entry and every 12th entry after it. Which choice best describes the sampling method?

- A. Cluster sample, because the population is divided into groups such as tree species before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- B. Convenience sample, because the randomly selected units are the ones the researcher contacts.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- **C. Systematic random sample, because a random start is followed by a fixed interval.**  ✔ _key_
- D. SRS, because the researcher uses a random starting point from a list.  · _distractor: u1_11__systematic_srs_conflation_

#### 16. seed `101015`  ·  valid: yes

**Prompt.** A researcher wants to study their satisfaction with bus arrival times among weekday bus riders in a city. Sampling plan: The researcher divides the population into bus trips, randomly selects 5 bus trips, and records data from every rider in the selected bus trips. Which choice best describes the sampling method?

- A. Stratified random sample, because the population is divided into bus trips before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- **B. Cluster sample, because whole bus trips are randomly selected and every rider in those selected groups is included.**  ✔ _key_
- C. Convenience sample, because the randomly selected units are the ones the researcher contacts.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- D. Stratified random sample, because all riders in the selected bus trips are included.  · _distractor: u1_11__stratified_samples_whole_groups_

#### 17. seed `101016`  ·  valid: yes

**Prompt.** A researcher wants to study whether the delivery arrived by the promised date among orders placed with an online store last month. Sampling plan: The researcher uses responses from orders who choose to answer after seeing a feedback form sent only to customers who chose to click it. Which choice best describes the sampling method?

- A. Stratified random sample, because the researcher should randomly choose whole shipping region groups and include everyone in them.  · _distractor: u1_11__stratified_samples_whole_groups_
- **B. Not a random sample; it is a voluntary-response sample because units choose whether to respond.**  ✔ _key_
- C. Cluster sample, because the population is divided into groups such as shipping region before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- D. SRS, because any member of the population could have ended up in the response group.  · _distractor: u1_11__convenience_or_voluntary_called_random_

#### 18. seed `101017`  ·  valid: yes

**Prompt.** A researcher wants to study how many hours they spend in school clubs each week among all students at a high school. Sampling plan: The researcher chooses a random starting position, 4, in an alphabetized roster of all students and then selects that entry and every 10th entry after it. Which choice best describes the sampling method?

- A. Convenience sample, because the randomly selected units are the ones the researcher contacts.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- **B. Systematic random sample, because a random start is followed by a fixed interval.**  ✔ _key_
- C. SRS, because the researcher uses a random starting point from a list.  · _distractor: u1_11__systematic_srs_conflation_
- D. Cluster sample, because the population is divided into groups such as grade level before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_

#### 19. seed `101018`  ·  valid: yes

**Prompt.** A researcher wants to study their satisfaction with bus arrival times among weekday bus riders in a city. Sampling plan: The researcher uses responses from riders who choose to answer after seeing a survey QR code on posters inside buses. Which choice best describes the sampling method?

- **A. Not a random sample; it is a voluntary-response sample because units choose whether to respond.**  ✔ _key_
- B. SRS, because any member of the population could have ended up in the response group.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- C. Cluster sample, because the population is divided into groups such as bus route before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- D. Stratified random sample, because the researcher should randomly choose whole bus route groups and include everyone in them.  · _distractor: u1_11__stratified_samples_whole_groups_

#### 20. seed `101019`  ·  valid: yes

**Prompt.** A researcher wants to study their satisfaction with bus arrival times among weekday bus riders in a city. Sampling plan: The researcher uses responses from riders who choose to answer after seeing a survey QR code on posters inside buses. Which choice best describes the sampling method?

- **A. Not a random sample; it is a voluntary-response sample because units choose whether to respond.**  ✔ _key_
- B. SRS, because any member of the population could have ended up in the response group.  · _distractor: u1_11__convenience_or_voluntary_called_random_
- C. Cluster sample, because the population is divided into groups such as bus route before the sample is chosen.  · _distractor: u1_11__stratified_cluster_confusion_
- D. Stratified random sample, because the researcher should randomly choose whole bus route groups and include everyone in them.  · _distractor: u1_11__stratified_samples_whole_groups_

---

## 1.12 x 2.A — Problems with sampling (describe)

Template/frame: `FB-U1-12-2A-BIAS-01` · serving: MCQ · sample: 20 instances (all valid: yes)

#### 1. seed `101200`  ·  valid: yes

**Prompt.** A survey asks, 'Do you support the wasteful plan to raise parking fees?' Which statement best identifies the bias, if any?

- **A. Response or wording bias, because the question pushes respondents toward a negative answer.**  ✔ _key_
- B. Undercoverage bias, because people who like parking fees are excluded.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- C. Voluntary-response bias, because respondents may have strong opinions.  · _distractor: u1_12__bias_type_confused_
- D. Nonresponse bias, because some people may refuse to answer a rude question.  · _distractor: u1_12__bias_type_confused_

#### 2. seed `101201`  ·  valid: yes

**Prompt.** A registrar uses a random-number generator to select 80 students from the complete school roster and all selected students answer the neutral survey question. Which statement best identifies the bias, if any?

- A. Voluntary-response bias, because students were allowed to answer the question.  · _distractor: u1_12__no_bias_called_biased_
- **B. No clear bias is described; the frame is complete, selection is random, everyone responds, and the wording is neutral.**  ✔ _key_
- C. Undercoverage bias, because 80 students is fewer than the whole school.  · _distractor: u1_12__no_bias_called_biased_
- D. Nonresponse bias, because not every student in the school was selected.  · _distractor: u1_12__no_bias_called_biased_

#### 3. seed `101202`  ·  valid: yes

**Prompt.** A city surveys residents about bus service by randomly calling numbers from a landline phone directory. Which statement best identifies the bias, if any?

- **A. Undercoverage bias, because residents without landlines are left out of the sampling frame.**  ✔ _key_
- B. Nonresponse bias, because some selected residents might not answer the phone.  · _distractor: u1_12__bias_type_confused_
- C. Response bias, because the wording of the bus-service question must be leading.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- D. Voluntary-response bias, because people choose whether to have a landline.  · _distractor: u1_12__bias_type_confused_

#### 4. seed `101203`  ·  valid: yes

**Prompt.** A survey asks, 'Do you support the wasteful plan to raise parking fees?' Which statement best identifies the bias, if any?

- A. Nonresponse bias, because some people may refuse to answer a rude question.  · _distractor: u1_12__bias_type_confused_
- B. Voluntary-response bias, because respondents may have strong opinions.  · _distractor: u1_12__bias_type_confused_
- **C. Response or wording bias, because the question pushes respondents toward a negative answer.**  ✔ _key_
- D. Undercoverage bias, because people who like parking fees are excluded.  · _distractor: u1_12__sampling_vs_nonsampling_error_

#### 5. seed `101204`  ·  valid: yes

**Prompt.** A news website posts an open poll asking visitors to click if they support a proposed rule. Which statement best identifies the bias, if any?

- A. Response bias only, because the issue may be controversial.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- B. Simple random sampling, because every website visitor can click the poll.  · _distractor: u1_12__bias_type_confused_
- **C. Voluntary-response bias, because people decide for themselves whether to participate.**  ✔ _key_
- D. Nonresponse bias, because visitors who never see the website do not answer.  · _distractor: u1_12__bias_type_confused_

#### 6. seed `101205`  ·  valid: yes

**Prompt.** A school mails a survey to 600 randomly selected families, but only 94 families send it back. Which statement best identifies the bias, if any?

- **A. Nonresponse bias, because many selected families did not respond.**  ✔ _key_
- B. Response bias, because families must have misunderstood every question.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- C. Voluntary-response bias, because the original 600 families were randomly selected.  · _distractor: u1_12__bias_type_confused_
- D. Undercoverage bias, because the sample was too small to include everyone.  · _distractor: u1_12__bias_type_confused_

#### 7. seed `101206`  ·  valid: yes

**Prompt.** A registrar uses a random-number generator to select 80 students from the complete school roster and all selected students answer the neutral survey question. Which statement best identifies the bias, if any?

- A. Undercoverage bias, because 80 students is fewer than the whole school.  · _distractor: u1_12__no_bias_called_biased_
- **B. No clear bias is described; the frame is complete, selection is random, everyone responds, and the wording is neutral.**  ✔ _key_
- C. Voluntary-response bias, because students were allowed to answer the question.  · _distractor: u1_12__no_bias_called_biased_
- D. Nonresponse bias, because not every student in the school was selected.  · _distractor: u1_12__no_bias_called_biased_

#### 8. seed `101207`  ·  valid: yes

**Prompt.** A clinic estimates patient satisfaction by asking only patients in the waiting room on Tuesday morning. Which statement best identifies the bias, if any?

- A. Response bias, because satisfaction cannot be measured by a survey.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- B. Voluntary-response bias, because patients are physically present at the clinic.  · _distractor: u1_12__bias_type_confused_
- C. Nonresponse bias, because Tuesday patients are different from Monday patients.  · _distractor: u1_12__bias_type_confused_
- **D. Undercoverage bias, because patients with appointments at other times are not represented.**  ✔ _key_

#### 9. seed `101208`  ·  valid: yes

**Prompt.** A survey asks, 'Do you support the wasteful plan to raise parking fees?' Which statement best identifies the bias, if any?

- **A. Response or wording bias, because the question pushes respondents toward a negative answer.**  ✔ _key_
- B. Voluntary-response bias, because respondents may have strong opinions.  · _distractor: u1_12__bias_type_confused_
- C. Nonresponse bias, because some people may refuse to answer a rude question.  · _distractor: u1_12__bias_type_confused_
- D. Undercoverage bias, because people who like parking fees are excluded.  · _distractor: u1_12__sampling_vs_nonsampling_error_

#### 10. seed `101209`  ·  valid: yes

**Prompt.** A clinic estimates patient satisfaction by asking only patients in the waiting room on Tuesday morning. Which statement best identifies the bias, if any?

- A. Nonresponse bias, because Tuesday patients are different from Monday patients.  · _distractor: u1_12__bias_type_confused_
- **B. Undercoverage bias, because patients with appointments at other times are not represented.**  ✔ _key_
- C. Response bias, because satisfaction cannot be measured by a survey.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- D. Voluntary-response bias, because patients are physically present at the clinic.  · _distractor: u1_12__bias_type_confused_

#### 11. seed `101210`  ·  valid: yes

**Prompt.** A city surveys residents about bus service by randomly calling numbers from a landline phone directory. Which statement best identifies the bias, if any?

- A. Voluntary-response bias, because people choose whether to have a landline.  · _distractor: u1_12__bias_type_confused_
- B. Response bias, because the wording of the bus-service question must be leading.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- **C. Undercoverage bias, because residents without landlines are left out of the sampling frame.**  ✔ _key_
- D. Nonresponse bias, because some selected residents might not answer the phone.  · _distractor: u1_12__bias_type_confused_

#### 12. seed `101211`  ·  valid: yes

**Prompt.** A school mails a survey to 600 randomly selected families, but only 94 families send it back. Which statement best identifies the bias, if any?

- **A. Nonresponse bias, because many selected families did not respond.**  ✔ _key_
- B. Response bias, because families must have misunderstood every question.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- C. Voluntary-response bias, because the original 600 families were randomly selected.  · _distractor: u1_12__bias_type_confused_
- D. Undercoverage bias, because the sample was too small to include everyone.  · _distractor: u1_12__bias_type_confused_

#### 13. seed `101212`  ·  valid: yes

**Prompt.** A registrar uses a random-number generator to select 80 students from the complete school roster and all selected students answer the neutral survey question. Which statement best identifies the bias, if any?

- A. Nonresponse bias, because not every student in the school was selected.  · _distractor: u1_12__no_bias_called_biased_
- **B. No clear bias is described; the frame is complete, selection is random, everyone responds, and the wording is neutral.**  ✔ _key_
- C. Undercoverage bias, because 80 students is fewer than the whole school.  · _distractor: u1_12__no_bias_called_biased_
- D. Voluntary-response bias, because students were allowed to answer the question.  · _distractor: u1_12__no_bias_called_biased_

#### 14. seed `101213`  ·  valid: yes

**Prompt.** A registrar uses a random-number generator to select 80 students from the complete school roster and all selected students answer the neutral survey question. Which statement best identifies the bias, if any?

- **A. No clear bias is described; the frame is complete, selection is random, everyone responds, and the wording is neutral.**  ✔ _key_
- B. Nonresponse bias, because not every student in the school was selected.  · _distractor: u1_12__no_bias_called_biased_
- C. Undercoverage bias, because 80 students is fewer than the whole school.  · _distractor: u1_12__no_bias_called_biased_
- D. Voluntary-response bias, because students were allowed to answer the question.  · _distractor: u1_12__no_bias_called_biased_

#### 15. seed `101214`  ·  valid: yes

**Prompt.** A clinic estimates patient satisfaction by asking only patients in the waiting room on Tuesday morning. Which statement best identifies the bias, if any?

- A. Response bias, because satisfaction cannot be measured by a survey.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- B. Nonresponse bias, because Tuesday patients are different from Monday patients.  · _distractor: u1_12__bias_type_confused_
- **C. Undercoverage bias, because patients with appointments at other times are not represented.**  ✔ _key_
- D. Voluntary-response bias, because patients are physically present at the clinic.  · _distractor: u1_12__bias_type_confused_

#### 16. seed `101215`  ·  valid: yes

**Prompt.** A city surveys residents about bus service by randomly calling numbers from a landline phone directory. Which statement best identifies the bias, if any?

- **A. Undercoverage bias, because residents without landlines are left out of the sampling frame.**  ✔ _key_
- B. Voluntary-response bias, because people choose whether to have a landline.  · _distractor: u1_12__bias_type_confused_
- C. Nonresponse bias, because some selected residents might not answer the phone.  · _distractor: u1_12__bias_type_confused_
- D. Response bias, because the wording of the bus-service question must be leading.  · _distractor: u1_12__sampling_vs_nonsampling_error_

#### 17. seed `101216`  ·  valid: yes

**Prompt.** A city surveys residents about bus service by randomly calling numbers from a landline phone directory. Which statement best identifies the bias, if any?

- A. Voluntary-response bias, because people choose whether to have a landline.  · _distractor: u1_12__bias_type_confused_
- B. Response bias, because the wording of the bus-service question must be leading.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- **C. Undercoverage bias, because residents without landlines are left out of the sampling frame.**  ✔ _key_
- D. Nonresponse bias, because some selected residents might not answer the phone.  · _distractor: u1_12__bias_type_confused_

#### 18. seed `101217`  ·  valid: yes

**Prompt.** A city surveys residents about bus service by randomly calling numbers from a landline phone directory. Which statement best identifies the bias, if any?

- A. Voluntary-response bias, because people choose whether to have a landline.  · _distractor: u1_12__bias_type_confused_
- B. Response bias, because the wording of the bus-service question must be leading.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- C. Nonresponse bias, because some selected residents might not answer the phone.  · _distractor: u1_12__bias_type_confused_
- **D. Undercoverage bias, because residents without landlines are left out of the sampling frame.**  ✔ _key_

#### 19. seed `101218`  ·  valid: yes

**Prompt.** A survey asks, 'Do you support the wasteful plan to raise parking fees?' Which statement best identifies the bias, if any?

- A. Nonresponse bias, because some people may refuse to answer a rude question.  · _distractor: u1_12__bias_type_confused_
- **B. Response or wording bias, because the question pushes respondents toward a negative answer.**  ✔ _key_
- C. Voluntary-response bias, because respondents may have strong opinions.  · _distractor: u1_12__bias_type_confused_
- D. Undercoverage bias, because people who like parking fees are excluded.  · _distractor: u1_12__sampling_vs_nonsampling_error_

#### 20. seed `101219`  ·  valid: yes

**Prompt.** A survey asks, 'Do you support the wasteful plan to raise parking fees?' Which statement best identifies the bias, if any?

- A. Undercoverage bias, because people who like parking fees are excluded.  · _distractor: u1_12__sampling_vs_nonsampling_error_
- B. Nonresponse bias, because some people may refuse to answer a rude question.  · _distractor: u1_12__bias_type_confused_
- C. Voluntary-response bias, because respondents may have strong opinions.  · _distractor: u1_12__bias_type_confused_
- **D. Response or wording bias, because the question pushes respondents toward a negative answer.**  ✔ _key_

---

## 1.13 x 2.A — Experimental design (describe)

Template/frame: `FB-U1-13-2A-DESIGN-01` · serving: MCQ · sample: 20 instances (all valid: yes)

#### 1. seed `101300`  ·  valid: yes

**Prompt.** A researcher randomly assigns volunteers with headaches to receive a new pill or an identical-looking inactive pill, then compares pain ratings. Which statement best identifies the design element or flaw?

- **A. The inactive pill is a placebo control, helping separate the pill effect from expectation or natural improvement.**  ✔ _key_
- B. The study is observational because pain ratings are observed after treatment.  · _distractor: u1_13__observational_treated_as_experiment_
- C. The main flaw is confounding because one group receives an inactive pill.  · _distractor: u1_13__confounding_vs_lurking_confused_
- D. The inactive pill is the randomization method because it decides which group each person joins.  · _distractor: u1_13__control_blinding_randomization_confused_

#### 2. seed `101301`  ·  valid: yes

**Prompt.** Students who choose to drink caffeine before studying are compared with students who choose not to; the caffeine group also tends to study later at night. Which statement best identifies the design element or flaw?

- A. Blinding would remove the confounding because students would not know their own study time.  · _distractor: u1_13__control_blinding_randomization_confused_
- **B. This is observational and has possible confounding, because caffeine use is mixed with study time and was not randomly assigned.**  ✔ _key_
- C. There is only a lurking variable and no confounding, because study time was measured.  · _distractor: u1_13__confounding_vs_lurking_confused_
- D. This is a randomized experiment because the students naturally fell into two groups.  · _distractor: u1_13__observational_treated_as_experiment_

#### 3. seed `101302`  ·  valid: yes

**Prompt.** A researcher randomly assigns volunteers with headaches to receive a new pill or an identical-looking inactive pill, then compares pain ratings. Which statement best identifies the design element or flaw?

- A. The inactive pill is the randomization method because it decides which group each person joins.  · _distractor: u1_13__control_blinding_randomization_confused_
- **B. The inactive pill is a placebo control, helping separate the pill effect from expectation or natural improvement.**  ✔ _key_
- C. The study is observational because pain ratings are observed after treatment.  · _distractor: u1_13__observational_treated_as_experiment_
- D. The main flaw is confounding because one group receives an inactive pill.  · _distractor: u1_13__confounding_vs_lurking_confused_

#### 4. seed `101303`  ·  valid: yes

**Prompt.** A researcher records students' usual screen time and usual sleep hours, then compares sleep between students with high and low screen time. Which statement best identifies the design element or flaw?

- A. This is an experiment because the researcher compares two screen-time groups.  · _distractor: u1_13__observational_treated_as_experiment_
- B. The comparison group is a placebo group because it has lower screen time.  · _distractor: u1_13__control_blinding_randomization_confused_
- C. Randomization is present because students' usual schedules vary naturally.  · _distractor: u1_13__control_blinding_randomization_confused_
- **D. This is an observational study, because the researcher records existing habits and does not assign screen-time treatments.**  ✔ _key_

#### 5. seed `101304`  ·  valid: yes

**Prompt.** A researcher records students' usual screen time and usual sleep hours, then compares sleep between students with high and low screen time. Which statement best identifies the design element or flaw?

- A. This is an experiment because the researcher compares two screen-time groups.  · _distractor: u1_13__observational_treated_as_experiment_
- B. Randomization is present because students' usual schedules vary naturally.  · _distractor: u1_13__control_blinding_randomization_confused_
- C. The comparison group is a placebo group because it has lower screen time.  · _distractor: u1_13__control_blinding_randomization_confused_
- **D. This is an observational study, because the researcher records existing habits and does not assign screen-time treatments.**  ✔ _key_

#### 6. seed `101305`  ·  valid: yes

**Prompt.** A researcher records students' usual screen time and usual sleep hours, then compares sleep between students with high and low screen time. Which statement best identifies the design element or flaw?

- A. This is an experiment because the researcher compares two screen-time groups.  · _distractor: u1_13__observational_treated_as_experiment_
- **B. This is an observational study, because the researcher records existing habits and does not assign screen-time treatments.**  ✔ _key_
- C. The comparison group is a placebo group because it has lower screen time.  · _distractor: u1_13__control_blinding_randomization_confused_
- D. Randomization is present because students' usual schedules vary naturally.  · _distractor: u1_13__control_blinding_randomization_confused_

#### 7. seed `101306`  ·  valid: yes

**Prompt.** Students who choose to drink caffeine before studying are compared with students who choose not to; the caffeine group also tends to study later at night. Which statement best identifies the design element or flaw?

- A. This is a randomized experiment because the students naturally fell into two groups.  · _distractor: u1_13__observational_treated_as_experiment_
- B. Blinding would remove the confounding because students would not know their own study time.  · _distractor: u1_13__control_blinding_randomization_confused_
- C. There is only a lurking variable and no confounding, because study time was measured.  · _distractor: u1_13__confounding_vs_lurking_confused_
- **D. This is observational and has possible confounding, because caffeine use is mixed with study time and was not randomly assigned.**  ✔ _key_

#### 8. seed `101307`  ·  valid: yes

**Prompt.** A researcher randomly assigns volunteers with headaches to receive a new pill or an identical-looking inactive pill, then compares pain ratings. Which statement best identifies the design element or flaw?

- **A. The inactive pill is a placebo control, helping separate the pill effect from expectation or natural improvement.**  ✔ _key_
- B. The inactive pill is the randomization method because it decides which group each person joins.  · _distractor: u1_13__control_blinding_randomization_confused_
- C. The main flaw is confounding because one group receives an inactive pill.  · _distractor: u1_13__confounding_vs_lurking_confused_
- D. The study is observational because pain ratings are observed after treatment.  · _distractor: u1_13__observational_treated_as_experiment_

#### 9. seed `101308`  ·  valid: yes

**Prompt.** A company randomly assigns users either to receive a new app notification or to receive no notification, then compares next-day app use. Which statement best identifies the design element or flaw?

- A. There must be confounding because people use apps for many reasons.  · _distractor: u1_13__confounding_vs_lurking_confused_
- B. This is observational because the company compares existing users.  · _distractor: u1_13__observational_treated_as_experiment_
- C. The no-notification group is blinding, because users know they did not get a notification.  · _distractor: u1_13__control_blinding_randomization_confused_
- **D. The no-notification group is a control group, providing a baseline for comparison with the new notification treatment.**  ✔ _key_

#### 10. seed `101309`  ·  valid: yes

**Prompt.** One teacher uses a new review method in the morning class and the old method in the afternoon class, then compares exam scores. Which statement best identifies the design element or flaw?

- **A. Class time is confounded with review method, because each method is tied to a different class period.**  ✔ _key_
- B. This is randomized because the teacher chose which period got each method.  · _distractor: u1_13__control_blinding_randomization_confused_
- C. There is no confounding because both classes have the same teacher.  · _distractor: u1_13__confounding_vs_lurking_confused_
- D. This is only observational because exam scores are observed after class.  · _distractor: u1_13__observational_treated_as_experiment_

#### 11. seed `101310`  ·  valid: yes

**Prompt.** A researcher records students' usual screen time and usual sleep hours, then compares sleep between students with high and low screen time. Which statement best identifies the design element or flaw?

- **A. This is an observational study, because the researcher records existing habits and does not assign screen-time treatments.**  ✔ _key_
- B. Randomization is present because students' usual schedules vary naturally.  · _distractor: u1_13__control_blinding_randomization_confused_
- C. This is an experiment because the researcher compares two screen-time groups.  · _distractor: u1_13__observational_treated_as_experiment_
- D. The comparison group is a placebo group because it has lower screen time.  · _distractor: u1_13__control_blinding_randomization_confused_

#### 12. seed `101311`  ·  valid: yes

**Prompt.** A company randomly assigns users either to receive a new app notification or to receive no notification, then compares next-day app use. Which statement best identifies the design element or flaw?

- **A. The no-notification group is a control group, providing a baseline for comparison with the new notification treatment.**  ✔ _key_
- B. The no-notification group is blinding, because users know they did not get a notification.  · _distractor: u1_13__control_blinding_randomization_confused_
- C. There must be confounding because people use apps for many reasons.  · _distractor: u1_13__confounding_vs_lurking_confused_
- D. This is observational because the company compares existing users.  · _distractor: u1_13__observational_treated_as_experiment_

#### 13. seed `101312`  ·  valid: yes

**Prompt.** A researcher randomly assigns volunteers with headaches to receive a new pill or an identical-looking inactive pill, then compares pain ratings. Which statement best identifies the design element or flaw?

- A. The inactive pill is the randomization method because it decides which group each person joins.  · _distractor: u1_13__control_blinding_randomization_confused_
- B. The main flaw is confounding because one group receives an inactive pill.  · _distractor: u1_13__confounding_vs_lurking_confused_
- C. The study is observational because pain ratings are observed after treatment.  · _distractor: u1_13__observational_treated_as_experiment_
- **D. The inactive pill is a placebo control, helping separate the pill effect from expectation or natural improvement.**  ✔ _key_

#### 14. seed `101313`  ·  valid: yes

**Prompt.** A researcher randomly assigns volunteers with headaches to receive a new pill or an identical-looking inactive pill, then compares pain ratings. Which statement best identifies the design element or flaw?

- **A. The inactive pill is a placebo control, helping separate the pill effect from expectation or natural improvement.**  ✔ _key_
- B. The study is observational because pain ratings are observed after treatment.  · _distractor: u1_13__observational_treated_as_experiment_
- C. The main flaw is confounding because one group receives an inactive pill.  · _distractor: u1_13__confounding_vs_lurking_confused_
- D. The inactive pill is the randomization method because it decides which group each person joins.  · _distractor: u1_13__control_blinding_randomization_confused_

#### 15. seed `101314`  ·  valid: yes

**Prompt.** One teacher uses a new review method in the morning class and the old method in the afternoon class, then compares exam scores. Which statement best identifies the design element or flaw?

- A. There is no confounding because both classes have the same teacher.  · _distractor: u1_13__confounding_vs_lurking_confused_
- B. This is only observational because exam scores are observed after class.  · _distractor: u1_13__observational_treated_as_experiment_
- C. This is randomized because the teacher chose which period got each method.  · _distractor: u1_13__control_blinding_randomization_confused_
- **D. Class time is confounded with review method, because each method is tied to a different class period.**  ✔ _key_

#### 16. seed `101315`  ·  valid: yes

**Prompt.** A botanist assigns similar seedlings at random to fertilizer A or fertilizer B and grows all seedlings in the same greenhouse. Which statement best identifies the design element or flaw?

- **A. Random assignment helps balance other variables between treatment groups so differences can be attributed more credibly to fertilizer type.**  ✔ _key_
- B. This is observational because the botanist records plant heights instead of controlling the outcome.  · _distractor: u1_13__observational_treated_as_experiment_
- C. The greenhouse is a lurking variable that proves the fertilizers are confounded.  · _distractor: u1_13__confounding_vs_lurking_confused_
- D. Random assignment guarantees both fertilizers produce exactly the same spread of plant heights.  · _distractor: u1_13__control_blinding_randomization_confused_

#### 17. seed `101316`  ·  valid: yes

**Prompt.** Students who choose to drink caffeine before studying are compared with students who choose not to; the caffeine group also tends to study later at night. Which statement best identifies the design element or flaw?

- A. There is only a lurking variable and no confounding, because study time was measured.  · _distractor: u1_13__confounding_vs_lurking_confused_
- **B. This is observational and has possible confounding, because caffeine use is mixed with study time and was not randomly assigned.**  ✔ _key_
- C. This is a randomized experiment because the students naturally fell into two groups.  · _distractor: u1_13__observational_treated_as_experiment_
- D. Blinding would remove the confounding because students would not know their own study time.  · _distractor: u1_13__control_blinding_randomization_confused_

#### 18. seed `101317`  ·  valid: yes

**Prompt.** Students who choose to drink caffeine before studying are compared with students who choose not to; the caffeine group also tends to study later at night. Which statement best identifies the design element or flaw?

- A. This is a randomized experiment because the students naturally fell into two groups.  · _distractor: u1_13__observational_treated_as_experiment_
- **B. This is observational and has possible confounding, because caffeine use is mixed with study time and was not randomly assigned.**  ✔ _key_
- C. There is only a lurking variable and no confounding, because study time was measured.  · _distractor: u1_13__confounding_vs_lurking_confused_
- D. Blinding would remove the confounding because students would not know their own study time.  · _distractor: u1_13__control_blinding_randomization_confused_

#### 19. seed `101318`  ·  valid: yes

**Prompt.** A botanist assigns similar seedlings at random to fertilizer A or fertilizer B and grows all seedlings in the same greenhouse. Which statement best identifies the design element or flaw?

- A. The greenhouse is a lurking variable that proves the fertilizers are confounded.  · _distractor: u1_13__confounding_vs_lurking_confused_
- B. This is observational because the botanist records plant heights instead of controlling the outcome.  · _distractor: u1_13__observational_treated_as_experiment_
- **C. Random assignment helps balance other variables between treatment groups so differences can be attributed more credibly to fertilizer type.**  ✔ _key_
- D. Random assignment guarantees both fertilizers produce exactly the same spread of plant heights.  · _distractor: u1_13__control_blinding_randomization_confused_

#### 20. seed `101319`  ·  valid: yes

**Prompt.** One teacher uses a new review method in the morning class and the old method in the afternoon class, then compares exam scores. Which statement best identifies the design element or flaw?

- **A. Class time is confounded with review method, because each method is tied to a different class period.**  ✔ _key_
- B. This is only observational because exam scores are observed after class.  · _distractor: u1_13__observational_treated_as_experiment_
- C. This is randomized because the teacher chose which period got each method.  · _distractor: u1_13__control_blinding_randomization_confused_
- D. There is no confounding because both classes have the same teacher.  · _distractor: u1_13__confounding_vs_lurking_confused_

---

## 1.9 x 4.B — Comparing distributions (justify)

Template/frame: `FB-4B-COMPARE-01` · serving: MCQ · sample: 20 instances (all valid: yes)

#### 1. seed `97000`  ·  valid: yes

**Prompt.** In a survey of study habits, students who study mostly at night had a mean self-reported focus rating of 40 points (SD about 14) and students who study mostly in the morning had a mean of 35 points (SD about 14). A student claims: "students who study mostly at night always have a higher self-reported focus rating than students who study mostly in the morning." Which statement best justifies whether the data support this claim?

- A. Since the mean for students who study mostly at night (40) is greater than for students who study mostly in the morning (35), every member of students who study mostly at night must have a higher self-reported focus rating than every member of students who study mostly in the morning.  · _distractor: ignores_variability_claims_every_value_
- **B. On average students who study mostly at night had a higher self-reported focus rating (mean 40 vs 35), so the data support a typical difference; but because both SDs are about 14, the distributions overlap substantially, so the data do not support a claim that students who study mostly at night are always higher.**  ✔ _key_
- C. These results prove that students who study mostly at night will always outperform students who study mostly in the morning on self-reported focus rating in any future study or population.  · _distractor: over_generalizes_beyond_data_
- D. Because students who study mostly at night had a higher mean self-reported focus rating, being in students who study mostly at night causes a higher self-reported focus rating.  · _distractor: association_implies_causation_

#### 2. seed `97001`  ·  valid: yes

**Prompt.** In an observational garden study, plants in sunny spots had a mean recorded height of 48 cm (SD about 14) and plants in shaded spots had a mean of 45 cm (SD about 14). A student claims: "plants in sunny spots always have a higher recorded height than plants in shaded spots." Which statement best justifies whether the data support this claim?

- A. Since the mean for plants in sunny spots (48) is greater than for plants in shaded spots (45), every member of plants in sunny spots must have a higher recorded height than every member of plants in shaded spots.  · _distractor: ignores_variability_claims_every_value_
- B. These results prove that plants in sunny spots will always outperform plants in shaded spots on recorded height in any future study or population.  · _distractor: over_generalizes_beyond_data_
- C. Because plants in sunny spots had a higher mean recorded height, being in plants in sunny spots causes a higher recorded height.  · _distractor: association_implies_causation_
- **D. On average plants in sunny spots had a higher recorded height (mean 48 vs 45), so the data support a typical difference; but because both SDs are about 14, the distributions overlap substantially, so the data do not support a claim that plants in sunny spots are always higher.**  ✔ _key_

#### 3. seed `97002`  ·  valid: yes

**Prompt.** In a survey of study habits, students who study mostly at night had a mean self-reported focus rating of 59 points (SD about 14) and students who study mostly in the morning had a mean of 55 points (SD about 14). A student claims: "students who study mostly at night always have a higher self-reported focus rating than students who study mostly in the morning." Which statement best justifies whether the data support this claim?

- A. These results prove that students who study mostly at night will always outperform students who study mostly in the morning on self-reported focus rating in any future study or population.  · _distractor: over_generalizes_beyond_data_
- **B. On average students who study mostly at night had a higher self-reported focus rating (mean 59 vs 55), so the data support a typical difference; but because both SDs are about 14, the distributions overlap substantially, so the data do not support a claim that students who study mostly at night are always higher.**  ✔ _key_
- C. Because students who study mostly at night had a higher mean self-reported focus rating, being in students who study mostly at night causes a higher self-reported focus rating.  · _distractor: association_implies_causation_
- D. Since the mean for students who study mostly at night (59) is greater than for students who study mostly in the morning (55), every member of students who study mostly at night must have a higher self-reported focus rating than every member of students who study mostly in the morning.  · _distractor: ignores_variability_claims_every_value_

#### 4. seed `97003`  ·  valid: yes

**Prompt.** In a survey of eating habits, self-described high-fiber eaters had a mean daily satiety score of 51 points (SD about 14) and self-described low-fiber eaters had a mean of 45 points (SD about 14). A student claims: "self-described high-fiber eaters always have a higher daily satiety score than self-described low-fiber eaters." Which statement best justifies whether the data support this claim?

- A. These results prove that self-described high-fiber eaters will always outperform self-described low-fiber eaters on daily satiety score in any future study or population.  · _distractor: over_generalizes_beyond_data_
- B. Because self-described high-fiber eaters had a higher mean daily satiety score, being in self-described high-fiber eaters causes a higher daily satiety score.  · _distractor: association_implies_causation_
- **C. On average self-described high-fiber eaters had a higher daily satiety score (mean 51 vs 45), so the data support a typical difference; but because both SDs are about 14, the distributions overlap substantially, so the data do not support a claim that self-described high-fiber eaters are always higher.**  ✔ _key_
- D. Since the mean for self-described high-fiber eaters (51) is greater than for self-described low-fiber eaters (45), every member of self-described high-fiber eaters must have a higher daily satiety score than every member of self-described low-fiber eaters.  · _distractor: ignores_variability_claims_every_value_

#### 5. seed `97004`  ·  valid: yes

**Prompt.** In a survey of study habits, students who study mostly at night had a mean self-reported focus rating of 58 points (SD about 10) and students who study mostly in the morning had a mean of 55 points (SD about 10). A student claims: "students who study mostly at night always have a higher self-reported focus rating than students who study mostly in the morning." Which statement best justifies whether the data support this claim?

- **A. On average students who study mostly at night had a higher self-reported focus rating (mean 58 vs 55), so the data support a typical difference; but because both SDs are about 10, the distributions overlap substantially, so the data do not support a claim that students who study mostly at night are always higher.**  ✔ _key_
- B. The claim is correct because students who study mostly at night clearly did better on self-reported focus rating.  · _distractor: restates_claim_without_evidence_
- C. These results prove that students who study mostly at night will always outperform students who study mostly in the morning on self-reported focus rating in any future study or population.  · _distractor: over_generalizes_beyond_data_
- D. Because students who study mostly at night had a higher mean self-reported focus rating, being in students who study mostly at night causes a higher self-reported focus rating.  · _distractor: association_implies_causation_

#### 6. seed `97005`  ·  valid: yes

**Prompt.** In a survey of study habits, students who study mostly at night had a mean self-reported focus rating of 51 points (SD about 14) and students who study mostly in the morning had a mean of 45 points (SD about 14). A student claims: "students who study mostly at night always have a higher self-reported focus rating than students who study mostly in the morning." Which statement best justifies whether the data support this claim?

- **A. On average students who study mostly at night had a higher self-reported focus rating (mean 51 vs 45), so the data support a typical difference; but because both SDs are about 14, the distributions overlap substantially, so the data do not support a claim that students who study mostly at night are always higher.**  ✔ _key_
- B. These results prove that students who study mostly at night will always outperform students who study mostly in the morning on self-reported focus rating in any future study or population.  · _distractor: over_generalizes_beyond_data_
- C. Because students who study mostly at night had a higher mean self-reported focus rating, being in students who study mostly at night causes a higher self-reported focus rating.  · _distractor: association_implies_causation_
- D. The claim is correct because students who study mostly at night clearly did better on self-reported focus rating.  · _distractor: restates_claim_without_evidence_

#### 7. seed `97006`  ·  valid: yes

**Prompt.** In a survey of eating habits, self-described high-fiber eaters had a mean daily satiety score of 49 points (SD about 12) and self-described low-fiber eaters had a mean of 45 points (SD about 12). A student claims: "self-described high-fiber eaters always have a higher daily satiety score than self-described low-fiber eaters." Which statement best justifies whether the data support this claim?

- A. Since the mean for self-described high-fiber eaters (49) is greater than for self-described low-fiber eaters (45), every member of self-described high-fiber eaters must have a higher daily satiety score than every member of self-described low-fiber eaters.  · _distractor: ignores_variability_claims_every_value_
- B. The claim is correct because self-described high-fiber eaters clearly did better on daily satiety score.  · _distractor: restates_claim_without_evidence_
- C. Because self-described high-fiber eaters had a higher mean daily satiety score, being in self-described high-fiber eaters causes a higher daily satiety score.  · _distractor: association_implies_causation_
- **D. On average self-described high-fiber eaters had a higher daily satiety score (mean 49 vs 45), so the data support a typical difference; but because both SDs are about 12, the distributions overlap substantially, so the data do not support a claim that self-described high-fiber eaters are always higher.**  ✔ _key_

#### 8. seed `97007`  ·  valid: yes

**Prompt.** In a survey of eating habits, self-described high-fiber eaters had a mean daily satiety score of 50 points (SD about 14) and self-described low-fiber eaters had a mean of 45 points (SD about 14). A student claims: "self-described high-fiber eaters always have a higher daily satiety score than self-described low-fiber eaters." Which statement best justifies whether the data support this claim?

- **A. On average self-described high-fiber eaters had a higher daily satiety score (mean 50 vs 45), so the data support a typical difference; but because both SDs are about 14, the distributions overlap substantially, so the data do not support a claim that self-described high-fiber eaters are always higher.**  ✔ _key_
- B. Since the mean for self-described high-fiber eaters (50) is greater than for self-described low-fiber eaters (45), every member of self-described high-fiber eaters must have a higher daily satiety score than every member of self-described low-fiber eaters.  · _distractor: ignores_variability_claims_every_value_
- C. Because self-described high-fiber eaters had a higher mean daily satiety score, being in self-described high-fiber eaters causes a higher daily satiety score.  · _distractor: association_implies_causation_
- D. The claim is correct because self-described high-fiber eaters clearly did better on daily satiety score.  · _distractor: restates_claim_without_evidence_

#### 9. seed `97008`  ·  valid: yes

**Prompt.** In a survey of study habits, students who study mostly at night had a mean self-reported focus rating of 38 points (SD about 10) and students who study mostly in the morning had a mean of 35 points (SD about 10). A student claims: "students who study mostly at night always have a higher self-reported focus rating than students who study mostly in the morning." Which statement best justifies whether the data support this claim?

- A. The claim is correct because students who study mostly at night clearly did better on self-reported focus rating.  · _distractor: restates_claim_without_evidence_
- **B. On average students who study mostly at night had a higher self-reported focus rating (mean 38 vs 35), so the data support a typical difference; but because both SDs are about 10, the distributions overlap substantially, so the data do not support a claim that students who study mostly at night are always higher.**  ✔ _key_
- C. Because students who study mostly at night had a higher mean self-reported focus rating, being in students who study mostly at night causes a higher self-reported focus rating.  · _distractor: association_implies_causation_
- D. These results prove that students who study mostly at night will always outperform students who study mostly in the morning on self-reported focus rating in any future study or population.  · _distractor: over_generalizes_beyond_data_

#### 10. seed `97009`  ·  valid: yes

**Prompt.** In a survey of study habits, students who study mostly at night had a mean self-reported focus rating of 40 points (SD about 10) and students who study mostly in the morning had a mean of 35 points (SD about 10). A student claims: "students who study mostly at night always have a higher self-reported focus rating than students who study mostly in the morning." Which statement best justifies whether the data support this claim?

- **A. On average students who study mostly at night had a higher self-reported focus rating (mean 40 vs 35), so the data support a typical difference; but because both SDs are about 10, the distributions overlap substantially, so the data do not support a claim that students who study mostly at night are always higher.**  ✔ _key_
- B. Because students who study mostly at night had a higher mean self-reported focus rating, being in students who study mostly at night causes a higher self-reported focus rating.  · _distractor: association_implies_causation_
- C. These results prove that students who study mostly at night will always outperform students who study mostly in the morning on self-reported focus rating in any future study or population.  · _distractor: over_generalizes_beyond_data_
- D. The claim is correct because students who study mostly at night clearly did better on self-reported focus rating.  · _distractor: restates_claim_without_evidence_

#### 11. seed `97010`  ·  valid: yes

**Prompt.** In a commuting survey, people who bike to work had a mean commute time of 38 minutes (SD about 12) and people who take the bus had a mean of 35 minutes (SD about 12). A student claims: "people who bike to work always have a higher commute time than people who take the bus." Which statement best justifies whether the data support this claim?

- A. The claim is correct because people who bike to work clearly did better on commute time.  · _distractor: restates_claim_without_evidence_
- B. Because people who bike to work had a higher mean commute time, being in people who bike to work causes a higher commute time.  · _distractor: association_implies_causation_
- C. Since the mean for people who bike to work (38) is greater than for people who take the bus (35), every member of people who bike to work must have a higher commute time than every member of people who take the bus.  · _distractor: ignores_variability_claims_every_value_
- **D. On average people who bike to work had a higher commute time (mean 38 vs 35), so the data support a typical difference; but because both SDs are about 12, the distributions overlap substantially, so the data do not support a claim that people who bike to work are always higher.**  ✔ _key_

#### 12. seed `97011`  ·  valid: yes

**Prompt.** In a survey of eating habits, self-described high-fiber eaters had a mean daily satiety score of 48 points (SD about 12) and self-described low-fiber eaters had a mean of 45 points (SD about 12). A student claims: "self-described high-fiber eaters always have a higher daily satiety score than self-described low-fiber eaters." Which statement best justifies whether the data support this claim?

- A. These results prove that self-described high-fiber eaters will always outperform self-described low-fiber eaters on daily satiety score in any future study or population.  · _distractor: over_generalizes_beyond_data_
- **B. On average self-described high-fiber eaters had a higher daily satiety score (mean 48 vs 45), so the data support a typical difference; but because both SDs are about 12, the distributions overlap substantially, so the data do not support a claim that self-described high-fiber eaters are always higher.**  ✔ _key_
- C. Since the mean for self-described high-fiber eaters (48) is greater than for self-described low-fiber eaters (45), every member of self-described high-fiber eaters must have a higher daily satiety score than every member of self-described low-fiber eaters.  · _distractor: ignores_variability_claims_every_value_
- D. The claim is correct because self-described high-fiber eaters clearly did better on daily satiety score.  · _distractor: restates_claim_without_evidence_

#### 13. seed `97012`  ·  valid: yes

**Prompt.** In an observational garden study, plants in sunny spots had a mean recorded height of 49 cm (SD about 12) and plants in shaded spots had a mean of 45 cm (SD about 12). A student claims: "plants in sunny spots always have a higher recorded height than plants in shaded spots." Which statement best justifies whether the data support this claim?

- **A. On average plants in sunny spots had a higher recorded height (mean 49 vs 45), so the data support a typical difference; but because both SDs are about 12, the distributions overlap substantially, so the data do not support a claim that plants in sunny spots are always higher.**  ✔ _key_
- B. Since the mean for plants in sunny spots (49) is greater than for plants in shaded spots (45), every member of plants in sunny spots must have a higher recorded height than every member of plants in shaded spots.  · _distractor: ignores_variability_claims_every_value_
- C. Because plants in sunny spots had a higher mean recorded height, being in plants in sunny spots causes a higher recorded height.  · _distractor: association_implies_causation_
- D. The claim is correct because plants in sunny spots clearly did better on recorded height.  · _distractor: restates_claim_without_evidence_

#### 14. seed `97013`  ·  valid: yes

**Prompt.** In a survey of study habits, students who study mostly at night had a mean self-reported focus rating of 49 points (SD about 10) and students who study mostly in the morning had a mean of 45 points (SD about 10). A student claims: "students who study mostly at night always have a higher self-reported focus rating than students who study mostly in the morning." Which statement best justifies whether the data support this claim?

- A. These results prove that students who study mostly at night will always outperform students who study mostly in the morning on self-reported focus rating in any future study or population.  · _distractor: over_generalizes_beyond_data_
- **B. On average students who study mostly at night had a higher self-reported focus rating (mean 49 vs 45), so the data support a typical difference; but because both SDs are about 10, the distributions overlap substantially, so the data do not support a claim that students who study mostly at night are always higher.**  ✔ _key_
- C. Since the mean for students who study mostly at night (49) is greater than for students who study mostly in the morning (45), every member of students who study mostly at night must have a higher self-reported focus rating than every member of students who study mostly in the morning.  · _distractor: ignores_variability_claims_every_value_
- D. The claim is correct because students who study mostly at night clearly did better on self-reported focus rating.  · _distractor: restates_claim_without_evidence_

#### 15. seed `97014`  ·  valid: yes

**Prompt.** In a survey of eating habits, self-described high-fiber eaters had a mean daily satiety score of 41 points (SD about 12) and self-described low-fiber eaters had a mean of 35 points (SD about 12). A student claims: "self-described high-fiber eaters always have a higher daily satiety score than self-described low-fiber eaters." Which statement best justifies whether the data support this claim?

- **A. On average self-described high-fiber eaters had a higher daily satiety score (mean 41 vs 35), so the data support a typical difference; but because both SDs are about 12, the distributions overlap substantially, so the data do not support a claim that self-described high-fiber eaters are always higher.**  ✔ _key_
- B. Since the mean for self-described high-fiber eaters (41) is greater than for self-described low-fiber eaters (35), every member of self-described high-fiber eaters must have a higher daily satiety score than every member of self-described low-fiber eaters.  · _distractor: ignores_variability_claims_every_value_
- C. The claim is correct because self-described high-fiber eaters clearly did better on daily satiety score.  · _distractor: restates_claim_without_evidence_
- D. Because self-described high-fiber eaters had a higher mean daily satiety score, being in self-described high-fiber eaters causes a higher daily satiety score.  · _distractor: association_implies_causation_

#### 16. seed `97015`  ·  valid: yes

**Prompt.** In a survey of study habits, students who study mostly at night had a mean self-reported focus rating of 41 points (SD about 12) and students who study mostly in the morning had a mean of 35 points (SD about 12). A student claims: "students who study mostly at night always have a higher self-reported focus rating than students who study mostly in the morning." Which statement best justifies whether the data support this claim?

- A. Because students who study mostly at night had a higher mean self-reported focus rating, being in students who study mostly at night causes a higher self-reported focus rating.  · _distractor: association_implies_causation_
- B. Since the mean for students who study mostly at night (41) is greater than for students who study mostly in the morning (35), every member of students who study mostly at night must have a higher self-reported focus rating than every member of students who study mostly in the morning.  · _distractor: ignores_variability_claims_every_value_
- C. The claim is correct because students who study mostly at night clearly did better on self-reported focus rating.  · _distractor: restates_claim_without_evidence_
- **D. On average students who study mostly at night had a higher self-reported focus rating (mean 41 vs 35), so the data support a typical difference; but because both SDs are about 12, the distributions overlap substantially, so the data do not support a claim that students who study mostly at night are always higher.**  ✔ _key_

#### 17. seed `97016`  ·  valid: yes

**Prompt.** In an observational garden study, plants in sunny spots had a mean recorded height of 51 cm (SD about 12) and plants in shaded spots had a mean of 45 cm (SD about 12). A student claims: "plants in sunny spots always have a higher recorded height than plants in shaded spots." Which statement best justifies whether the data support this claim?

- A. These results prove that plants in sunny spots will always outperform plants in shaded spots on recorded height in any future study or population.  · _distractor: over_generalizes_beyond_data_
- B. Since the mean for plants in sunny spots (51) is greater than for plants in shaded spots (45), every member of plants in sunny spots must have a higher recorded height than every member of plants in shaded spots.  · _distractor: ignores_variability_claims_every_value_
- C. The claim is correct because plants in sunny spots clearly did better on recorded height.  · _distractor: restates_claim_without_evidence_
- **D. On average plants in sunny spots had a higher recorded height (mean 51 vs 45), so the data support a typical difference; but because both SDs are about 12, the distributions overlap substantially, so the data do not support a claim that plants in sunny spots are always higher.**  ✔ _key_

#### 18. seed `97017`  ·  valid: yes

**Prompt.** In an observational garden study, plants in sunny spots had a mean recorded height of 59 cm (SD about 10) and plants in shaded spots had a mean of 55 cm (SD about 10). A student claims: "plants in sunny spots always have a higher recorded height than plants in shaded spots." Which statement best justifies whether the data support this claim?

- A. Since the mean for plants in sunny spots (59) is greater than for plants in shaded spots (55), every member of plants in sunny spots must have a higher recorded height than every member of plants in shaded spots.  · _distractor: ignores_variability_claims_every_value_
- **B. On average plants in sunny spots had a higher recorded height (mean 59 vs 55), so the data support a typical difference; but because both SDs are about 10, the distributions overlap substantially, so the data do not support a claim that plants in sunny spots are always higher.**  ✔ _key_
- C. These results prove that plants in sunny spots will always outperform plants in shaded spots on recorded height in any future study or population.  · _distractor: over_generalizes_beyond_data_
- D. The claim is correct because plants in sunny spots clearly did better on recorded height.  · _distractor: restates_claim_without_evidence_

#### 19. seed `97018`  ·  valid: yes

**Prompt.** In a survey of eating habits, self-described high-fiber eaters had a mean daily satiety score of 49 points (SD about 14) and self-described low-fiber eaters had a mean of 45 points (SD about 14). A student claims: "self-described high-fiber eaters always have a higher daily satiety score than self-described low-fiber eaters." Which statement best justifies whether the data support this claim?

- A. Since the mean for self-described high-fiber eaters (49) is greater than for self-described low-fiber eaters (45), every member of self-described high-fiber eaters must have a higher daily satiety score than every member of self-described low-fiber eaters.  · _distractor: ignores_variability_claims_every_value_
- B. The claim is correct because self-described high-fiber eaters clearly did better on daily satiety score.  · _distractor: restates_claim_without_evidence_
- **C. On average self-described high-fiber eaters had a higher daily satiety score (mean 49 vs 45), so the data support a typical difference; but because both SDs are about 14, the distributions overlap substantially, so the data do not support a claim that self-described high-fiber eaters are always higher.**  ✔ _key_
- D. These results prove that self-described high-fiber eaters will always outperform self-described low-fiber eaters on daily satiety score in any future study or population.  · _distractor: over_generalizes_beyond_data_

#### 20. seed `97019`  ·  valid: yes

**Prompt.** In a survey of study habits, students who study mostly at night had a mean self-reported focus rating of 51 points (SD about 10) and students who study mostly in the morning had a mean of 45 points (SD about 10). A student claims: "students who study mostly at night always have a higher self-reported focus rating than students who study mostly in the morning." Which statement best justifies whether the data support this claim?

- A. Because students who study mostly at night had a higher mean self-reported focus rating, being in students who study mostly at night causes a higher self-reported focus rating.  · _distractor: association_implies_causation_
- **B. On average students who study mostly at night had a higher self-reported focus rating (mean 51 vs 45), so the data support a typical difference; but because both SDs are about 10, the distributions overlap substantially, so the data do not support a claim that students who study mostly at night are always higher.**  ✔ _key_
- C. These results prove that students who study mostly at night will always outperform students who study mostly in the morning on self-reported focus rating in any future study or population.  · _distractor: over_generalizes_beyond_data_
- D. The claim is correct because students who study mostly at night clearly did better on self-reported focus rating.  · _distractor: restates_claim_without_evidence_

---

