# Spike Input Packet -- Comparing Two Distributions of Commute Times from Summary Statistics

**Subject:** AP Statistics
**Answer type:** Text FRQ
**Unit:** Unit 1 - Exploring One-Variable Data
**Difficulty:** Medium
**Content type:** interpretation
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

Two groups of employees report their one-way commute times in minutes. Group A: mean = 28, median = 24, standard deviation = 9, IQR = 8. Group B: mean = 30, median = 30, standard deviation = 6, IQR = 9.

**A.** Using the relationship between the mean and median for each group, describe the likely shape of each group's distribution.

**B.** Compare the two groups' commute times in terms of center and spread, and state which summary statistics (mean/median, standard deviation/IQR) are more appropriate to report for each group, with justification.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | States that Group A's distribution is likely right-skewed, because the mean (28) is noticeably greater than the median (24), which typically happens when a few high commute-time values pull the mean up. | Must reference the mean-greater-than-median pattern specifically for Group A. |
| `C2` | States that Group B's distribution is likely roughly symmetric, because the mean (30) and median (30) are equal (or nearly equal). | Must reference the mean-approximately-equal-to-median pattern specifically for Group B. |
| `C3` | Compares center and spread appropriately: e.g., using medians, Group B (30) has a somewhat longer typical commute than Group A (24); using IQR, Group B (9) has slightly more spread in the middle 50% than Group A (8). | Must use the median/IQR (not mean/SD) as the primary center/spread comparison for Group A, since it is skewed; comparing using Group B's mean/median (which are close) is acceptable for Group B. |
| `C4` | Justifies that median and IQR are the more appropriate summary statistics for Group A because it is skewed (median/IQR are resistant to the skew and to potential outliers pulling the mean and standard deviation), while mean and standard deviation are reasonably appropriate for Group B since it is roughly symmetric. | Must connect the skew/symmetry conclusions from A to the choice of appropriate statistics -- this is the key reasoning link the item tests. |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 2 |

#### R1

```text
(A) Group A is likely right-skewed, since its mean (28) is noticeably higher than its median (24) -- this pattern typically occurs when a few unusually long commute times pull the mean upward relative to the median. Group B is likely roughly symmetric, since its mean (30) and median (30) are equal.

(B) Comparing centers using medians (since Group A is skewed): Group B's typical commute (median 30) is somewhat longer than Group A's (median 24). Comparing spread using IQR: Group B (IQR 9) has slightly more spread in the middle 50% of its data than Group A (IQR 8). Median and IQR are the more appropriate statistics to report for Group A, because its distribution is skewed and these measures are resistant to the skew and to any outliers that may be pulling its mean and standard deviation. For Group B, since its distribution is roughly symmetric, mean and standard deviation are also reasonably appropriate to report.
```

#### R2

```text
(A) Group A is left-skewed because the mean is less than the median. Group B is right-skewed because the mean and median are different.

(B) Group A has a longer commute on average (mean 28 vs 30... wait, Group B's mean is higher, so Group B is longer). We should use the mean and standard deviation for both groups since those are the standard statistics.
```

#### R3

```text
(A) Group A is right-skewed since mean > median. Group B is symmetric since mean = median.

(B) Group B has a longer commute and about the same spread. Median and IQR should be used for Group A since it's skewed.
```

#### R4

```text
(A) Since Group A's mean (28) is greater than its median (24), Group A's distribution is likely right-skewed. Since Group B's mean (30) equals its median (30), Group B's distribution is likely roughly symmetric.

(B) Using medians, Group B's typical commute (30 minutes) is longer than Group A's (24 minutes). Using IQR, Group B's middle 50% (IQR = 9) is slightly more spread out than Group A's (IQR = 8). Because Group A is skewed, median and IQR are more appropriate for it, since they resist being pulled by the skew or outliers the way mean and standard deviation would be; for Group B, since it's roughly symmetric, mean and standard deviation are equally appropriate.
```

#### R5

```text
(A) Group A is right-skewed (mean > median). Group B is symmetric (mean = median).

(B) Group B has a longer typical commute (mean 30 vs mean 28) and less spread (SD 6 vs SD 9). We should use mean and standard deviation for both groups because that's what most statistics classes use by default.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct skew/symmetry conclusions, an appropriate median/IQR-based comparison for the skewed group, and correct justification connecting shape to statistic choice. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Gets the skew direction backwards for Group A (mean 28 > median 24 means right-skewed, not left-skewed, and the response also has the mean/median comparison backwards) and incorrectly calls Group B skewed despite mean=median=30 indicating symmetry. The comparison in (B) is confused and self-contradictory, and the recommendation to use mean/SD 'for both groups since those are standard' ignores the skew in Group A entirely, which is exactly the case where mean/SD are not resistant and median/IQR are preferred. Flags: skew direction reversed, symmetry misclassified, recommendation ignores skew. |
| `R3` | earned | earned | not_earned | earned | Skew/symmetry conclusions and the statistic-choice justification are both correct. However, the center/spread comparison in (B) is vague and slightly inaccurate -- 'about the same spread' glosses over the actual IQR values (8 vs 9) rather than stating and comparing them, and doesn't specify which center measure (median) is being used for the comparison. Flags: over-credit risk, comparison lacks the actual numeric values needed to demonstrate the correct approach. |
| `R4` | earned | earned | earned | earned | Second full-credit response, near-equivalent to R1 with slightly different ordering; confirms grader consistency. |
| `R5` | earned | earned | not_earned | not_earned | Skew/symmetry conclusions in (A) are correct. But (B) uses mean and standard deviation to compare Group A even after correctly identifying it as skewed in (A) -- comparing means/SD for a skewed distribution is exactly the inappropriate choice the item is testing for, and the justification given ('what most classes use by default') is not a statistical reason and directly contradicts the skew finding from part A. Flags: recommendation ignores skew, unsupported justification. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `skew_direction_reversed`, `recommendation_ignores_skew`
- `R3`: `over_credit_risk`, `vague_generality`
- `R4`: (none)
- `R5`: `recommendation_ignores_skew`, `unsupported_inference`
