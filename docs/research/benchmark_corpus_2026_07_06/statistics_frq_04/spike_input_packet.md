# Spike Input Packet -- One-Sample z-Test for a Claimed Defect Rate

**Subject:** AP Statistics
**Answer type:** Text FRQ
**Unit:** Unit 6 - Inference for Categorical Data (One Sample Proportions)
**Difficulty:** Medium
**Content type:** inference
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A factory claims that no more than 4% of its products are defective. A quality inspector takes a random sample of 250 products and finds 16 defective, a sample proportion of 0.064. The inspector wants to test whether the true defect rate is actually greater than 4%.

**A.** State the null and alternative hypotheses in terms of the true population proportion of defective products, and verify that the conditions for this significance test are met.

**B.** Given that this test produces a p-value of 0.006, state a conclusion in context at the alpha = 0.05 significance level.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | States H0: p = 0.04 and Ha: p > 0.04, where p is the true proportion of defective products, using a one-sided (greater than) alternative. | Must define p in context and use a one-sided alternative matching 'greater than 4%.' |
| `C2` | Verifies conditions: random sample (stated in the problem), and large counts using the null proportion (n*p0 = 250*0.04 = 10 and n*(1-p0) = 250*0.96 = 240, both >= 10), plus independence/10% condition (250 products is less than 10% of all products from a large factory run). | Must use the null value p0=0.04 for the large-counts check, not the sample proportion 0.064 -- this is the key boundary-sensitive point. |
| `C3` | States that because the p-value (0.006) is less than alpha (0.05), the result is statistically significant. | Must explicitly compare p-value to alpha. |
| `C4` | Concludes in context that there is convincing evidence that the true proportion of defective products is greater than 4% (rejecting the factory's claim). | Must state the conclusion in context (about the defect rate), not just 'reject the null hypothesis' with no context. |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 1 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 3 |

#### R1

```text
(A) H0: p = 0.04, Ha: p > 0.04, where p is the true proportion of defective products from this factory. Conditions: the sample was randomly selected (stated). Using the null proportion, n*p0 = 250(0.04) = 10 and n*(1-p0) = 250(0.96) = 240, both at least 10, so the large counts condition is met. Also, 250 products is almost certainly less than 10% of all products the factory produces, so independence is reasonable.

(B) Since the p-value (0.006) is less than alpha (0.05), the result is statistically significant. There is convincing evidence that the true proportion of defective products from this factory is greater than 4%, so we reject the factory's claim.
```

#### R2

```text
(A) H0: p = 0.064, Ha: p != 0.04. Conditions: n*p-hat = 250(0.064) = 16 and n(1-p-hat) = 234, both >= 10, so conditions are met.

(B) The p-value is small, so we reject H0 and conclude the defect rate is different from 4%.
```

#### R3

```text
(A) H0: p = 0.04, Ha: p > 0.04. Conditions are met since the sample was random and large enough.

(B) Since 0.006 < 0.05, we reject H0. There is convincing evidence the defect rate is greater than 4%.
```

#### R4

```text
(A) H0: p = 0.04 (true proportion of defective products equals 4%), Ha: p > 0.04 (true proportion is greater than 4%). Random: stated in the problem. Large counts: n*p0 = 250(0.04) = 10 >= 10 and n*(1-p0) = 250(0.96) = 240 >= 10, so this condition is met. Independence: 250 sampled products is reasonably less than 10% of the factory's total output.

(B) Because the p-value of 0.006 is less than alpha = 0.05, we have convincing evidence that the true proportion of defective products exceeds 4%, contradicting the factory's claim.
```

#### R5

```text
(A) H0: p = 0.04, Ha: p > 0.04. Conditions: np0 = 10 and n(1-p0) = 240, both >= 10, so we can use a normal approximation.

(B) Since the p-value is less than 0.05, the sample proportion of 0.064 is statistically significantly different from 0.04, so the factory's claim is false.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response. Hypotheses correctly defined in context, large-counts condition correctly checked using the null proportion (not the sample proportion), and a properly contextualized conclusion. |
| `R2` | not_earned | not_earned | earned | not_earned | H0 uses the sample proportion (0.064) instead of the claimed value (0.04), and the alternative is two-sided when the scenario specifically asks about greater than 4%. The large-counts check then also uses the sample proportion p-hat instead of the null proportion p0 -- this is the classic boundary error the item is designed to catch. The conclusion vaguely says 'different from 4%' rather than the specific 'greater than' direction and context. Flags: null hypothesis value error, wrong-proportion-used-in-conditions error, direction lost in conclusion. |
| `R3` | earned | not_earned | earned | earned | Hypotheses and conclusion are both correct and well-contextualized. However, the condition check in (A) is only asserted ('random and large enough') without showing the actual np0 and n(1-p0) calculations, so the large-counts verification the criterion requires is not demonstrated. Flags: over-credit risk if grader accepts an asserted-but-unshown condition check. |
| `R4` | earned | earned | earned | earned | Second full-credit response with more explicit condition labeling; useful for confirming grader consistency across differently-formatted but equally complete answers. |
| `R5` | earned | earned | earned | not_earned | Hypotheses and condition check are both fully correct. But the conclusion states the factory's claim is simply 'false' rather than stating there is convincing evidence the true defect rate is greater than 4% -- inference conclusions should be framed as evidence for/against a claim about the parameter, not a flat true/false verdict, and it drops the 'greater than' directional framing established in the hypotheses. Flags: overstated certainty, directional framing lost in conclusion. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `null_value_error`, `wrong_proportion_used_in_conditions`, `direction_lost_in_conclusion`
- `R3`: `over_credit_risk`, `condition_asserted_not_shown`
- `R4`: (none)
- `R5`: `overstated_certainty`, `direction_lost_in_conclusion`
