# Spike Input Packet -- Two-Sample t-Test for Difference in Mean Plant Growth

**Subject:** AP Statistics
**Answer type:** Text FRQ
**Unit:** Unit 6 - Inference for Categorical/Quantitative Data (Two Samples)
**Difficulty:** Hard
**Content type:** inference
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A researcher randomly assigns 40 seedlings to two groups of 20: one group receives a new fertilizer, and the other receives standard fertilizer. After 6 weeks, the new fertilizer group has a mean height of 34.2 cm (s = 5.1 cm) and the standard fertilizer group has a mean height of 30.8 cm (s = 4.6 cm). The researcher wants to test whether the new fertilizer produces greater mean growth.

**A.** State appropriate hypotheses for a two-sample t-test in this context, and identify the design feature that supports treating this as a valid experiment for making a cause-and-effect conclusion.

**B.** The resulting p-value is 0.031. State a conclusion at alpha = 0.05, explicitly addressing whether a cause-and-effect conclusion is justified.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | States H0: mu_new - mu_standard = 0 (or mu_new = mu_standard) and Ha: mu_new - mu_standard > 0 (or mu_new > mu_standard), where mu refers to true mean seedling height for each fertilizer group. | Must define parameters in context and use a one-sided alternative matching 'greater mean growth.' |
| `C2` | Identifies random assignment of seedlings to treatment groups as the design feature supporting a cause-and-effect conclusion. | Must specifically name random assignment (not random sampling, which supports generalizability, not causation). |
| `C3` | States that because the p-value (0.031) is less than alpha (0.05), the result is statistically significant, so there is convincing evidence that the true mean height for the new-fertilizer population is greater than for the standard-fertilizer population. | Must state the conclusion in context with correct direction. |
| `C4` | States that because this was a randomized experiment (not an observational study), a cause-and-effect conclusion is justified: the new fertilizer causes greater mean seedling growth, assuming other conditions for inference are met. | Must explicitly connect random assignment to the causal claim being justified, not just restate 'it's significant.' |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 2 |
| `R4` | 4 |
| `R5` | 3 |

#### R1

```text
(A) H0: mu_new - mu_standard = 0; Ha: mu_new - mu_standard > 0, where mu_new and mu_standard are the true mean heights of seedlings under each fertilizer treatment. Random assignment of seedlings to the two fertilizer groups is the design feature that supports a cause-and-effect conclusion, since it balances out other lurking variables between the groups.

(B) Because the p-value (0.031) is less than alpha (0.05), the result is statistically significant: there is convincing evidence that the true mean height of seedlings given the new fertilizer is greater than that of seedlings given the standard fertilizer. Because seedlings were randomly assigned to treatment groups (a randomized experiment), this significant difference can be attributed to the fertilizer itself, so a cause-and-effect conclusion is justified: the new fertilizer causes greater mean growth.
```

#### R2

```text
(A) H0: x-bar1 = x-bar2, Ha: x-bar1 != x-bar2. The design feature is that the seedlings were randomly sampled from all seedlings, which supports a cause-and-effect conclusion.

(B) Since p < 0.05, the fertilizers are different, and since the sample was random, we can say the fertilizer caused the difference.
```

#### R3

```text
(A) H0: mu_new = mu_standard, Ha: mu_new > mu_standard. Random assignment supports a cause-and-effect conclusion.

(B) Since p = 0.031 < 0.05, we reject H0. The new fertilizer works better.
```

#### R4

```text
(A) H0: mu_new - mu_standard = 0, Ha: mu_new - mu_standard > 0, where mu_new and mu_standard represent the true mean seedling heights under the new and standard fertilizers. Since seedlings were randomly assigned to the two treatment groups (rather than the groups being pre-existing or self-selected), this random assignment supports making a cause-and-effect conclusion.

(B) Because p = 0.031 < alpha = 0.05, there is convincing evidence that the true mean height of seedlings receiving the new fertilizer is greater than that of seedlings receiving the standard fertilizer. Because this was a randomized experiment, we can conclude that the new fertilizer causes this increase in mean growth, assuming the other conditions for inference (random assignment, independence, and approximate normality of the sampling distribution) are satisfied.
```

#### R5

```text
(A) H0: mu_new = mu_standard, Ha: mu_new > mu_standard. Random assignment is the design feature that supports cause and effect.

(B) The p-value is significant, so the new fertilizer definitely causes better growth in all seedlings everywhere, not just this sample.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correctly defined hypotheses and parameters, correctly identified design feature (random assignment, not random sampling), a properly directional and contextualized conclusion, and an explicit causal claim tied to the experimental design. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Hypotheses are written in terms of sample statistics (x-bar) rather than population parameters (mu), and use a two-sided alternative rather than the one-sided 'greater growth' direction specified. The design feature identified is random *sampling*, which supports generalizability to a population, not random *assignment*, which is what actually supports causal claims -- this is the key concept confusion the item targets. The conclusion is vague ('the fertilizers are different') rather than directional and in context. Flags: parameter notation error, direction lost, random-sampling/random-assignment conflation. |
| `R3` | earned | earned | not_earned | not_earned | Hypotheses and design-feature identification are both correct. But the conclusion in (B) is under-specified: 'the new fertilizer works better' doesn't reference the population parameters (true mean heights) or state the result is in terms of convincing evidence, and the response never explicitly revisits the cause-and-effect question that part B specifically asks the response to address, even though C2 correctly named random assignment in part A. Flags: over-credit risk, conclusion lacks parameter context, causal claim not explicitly revisited in B as asked. |
| `R4` | earned | earned | earned | earned | Second full-credit response with more explicit qualification about the other inference conditions; useful for confirming the grader doesn't require exactly R1's phrasing. |
| `R5` | earned | earned | earned | not_earned | Hypotheses, design feature, and significance conclusion are all correct up through stating convincing evidence exists. But the causal claim in (B) overreaches by extending the conclusion to 'all seedlings everywhere,' which is a generalizability claim -- generalizing beyond the sampled population requires random *sampling*, which was not established here (only random assignment was), so this overstates what the experiment supports. Flags: overstated generalizability, random-assignment/random-sampling scope confusion. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `random_sampling_random_assignment_conflation`, `parameter_notation_error`, `direction_lost_in_conclusion`
- `R3`: `over_credit_risk`, `causal_claim_not_revisited`
- `R4`: (none)
- `R5`: `overstated_generalizability`, `random_sampling_random_assignment_conflation`
