# Spike Input Packet -- Chi-Square Goodness-of-Fit Test for a Claimed Uniform Distribution

**Subject:** AP Statistics
**Answer type:** Text FRQ
**Unit:** Unit 8 - Inference for Categorical Data (Chi-Square Tests)
**Difficulty:** Hard
**Content type:** inference
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A game designer claims that a spinner lands on each of its 4 equally-sized colored regions (Red, Blue, Green, Yellow) with equal probability. A tester spins it 200 times and records: Red 62, Blue 58, Green 41, Yellow 39.

**A.** State the null and alternative hypotheses for a chi-square goodness-of-fit test, and calculate the expected count for each color under the null hypothesis.

**B.** The resulting chi-square test statistic is 8.68 with 3 degrees of freedom, giving a p-value of approximately 0.034. State a conclusion in context at alpha = 0.05.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | States H0: the spinner lands on each of the 4 colors with equal probability (p_Red = p_Blue = p_Green = p_Yellow = 0.25), and Ha: the spinner does not land on all 4 colors with equal probability (at least one proportion differs from 0.25). | Must state both hypotheses in context, not just symbolically. |
| `C2` | Calculates the expected count for each color as 200 x 0.25 = 50 for all four colors. | All four expected counts must be stated as 50, not computed from the observed counts. |
| `C3` | States that degrees of freedom = number of categories - 1 = 4 - 1 = 3, consistent with the given chi-square statistic, and correctly compares the p-value (0.034) to alpha (0.05) to determine statistical significance. | Must explicitly compare p-value to alpha, not just restate the p-value. |
| `C4` | Concludes in context that because the p-value (0.034) is less than alpha (0.05), there is convincing evidence that the spinner does not land on all 4 colors with equal probability, contradicting the designer's claim. | Must state the conclusion in context (about the spinner's colors), not just 'reject H0.' |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 3 |

#### R1

```text
(A) H0: the spinner lands on Red, Blue, Green, and Yellow each with probability 0.25. Ha: the spinner does not land on all four colors with equal probability. Expected count for each color = 200 x 0.25 = 50.

(B) Degrees of freedom = 4 - 1 = 3, matching the given chi-square statistic. Since the p-value (0.034) is less than alpha (0.05), the result is statistically significant. There is convincing evidence that the spinner does not land on all four colors with equal probability, contradicting the designer's claim of a uniform distribution.
```

#### R2

```text
(A) H0: the observed counts equal the expected counts. Ha: they don't. Expected counts: Red 62, Blue 58, Green 41, Yellow 39 (same as observed, since that's what we saw happen).

(B) Since the p-value is small, we reject H0 and conclude the spinner is unfair, meaning it will never land on all colors equally again.
```

#### R3

```text
(A) H0: p = 0.25 for each color. Ha: not all p = 0.25. Expected count = 50 for each color.

(B) Since 0.034 < 0.05, we reject H0. The spinner is not fair.
```

#### R4

```text
(A) H0: the spinner lands on each of the 4 colors with equal probability (p_Red = p_Blue = p_Green = p_Yellow = 0.25). Ha: at least one color's true probability differs from 0.25. Expected count for each color: 200 x 0.25 = 50.

(B) With 4 categories, degrees of freedom = 4 - 1 = 3, matching the given statistic. Because the p-value (0.034) is less than alpha = 0.05, there is convincing evidence that the spinner does not land on all four colors with equal probability, so the designer's claim of a uniform distribution across the four regions is not supported by these data.
```

#### R5

```text
(A) H0: all colors are equally likely, Ha: not all equally likely. Expected count for each: 50.

(B) Since 0.034 < 0.05, we have convincing evidence that the spinner isn't landing on each color 25% of the time, exactly as the designer intended, so the spinner is broken and needs to be physically rebuilt.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correctly stated hypotheses in context, correct expected counts, correct degrees of freedom check, and a properly contextualized conclusion. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Hypotheses are stated in circular, non-substantive terms ('observed equals expected') rather than referencing the actual claimed proportions (0.25 each). Expected counts are incorrectly set equal to the observed counts -- expected counts under H0 must be calculated from the claimed/null proportions (200 x 0.25 = 50 each), not copied from what was actually observed, which would make a chi-square test meaningless. The conclusion also overreaches with an absolute, deterministic claim ('will never land on all colors equally again') rather than a probabilistic evidence-based conclusion. Flags: expected counts computed from observed data (invalidates the test), overstated/deterministic conclusion. |
| `R3` | earned | earned | not_earned | earned | Hypotheses and expected counts are both correct, and the final conclusion correctly reflects the evidence found. However, the response never mentions or verifies degrees of freedom (df = 4 - 1 = 3) as part of the significance check, which the criterion specifically requires alongside the p-value/alpha comparison. Flags: over-credit risk if grader treats the p-value comparison alone as sufficient without the df check. |
| `R4` | earned | earned | earned | earned | Second full-credit response with equivalent completeness to R1; confirms grader consistency. |
| `R5` | earned | earned | not_earned | earned | Hypotheses and expected counts are correct, and the core statistical conclusion (evidence against the uniform-probability claim) is correctly reached, so C4 is earned. But like R3, degrees of freedom are never checked, and the response also adds an unsupported real-world claim ('the spinner is broken and needs to be physically rebuilt') that goes beyond what the statistical test itself can establish -- the test shows the observed proportions are unlikely under H0, not a specific physical cause. Flags: df check omitted, unsupported inference beyond the scope of the test. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `expected_counts_computed_from_observed_data`, `overstated_certainty`
- `R3`: `over_credit_risk`, `df_check_omitted`
- `R4`: (none)
- `R5`: `df_check_omitted`, `unsupported_inference`
