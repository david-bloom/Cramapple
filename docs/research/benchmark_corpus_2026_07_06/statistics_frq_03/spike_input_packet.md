# Spike Input Packet -- Confidence Interval for Mean Battery Life

**Subject:** AP Statistics
**Answer type:** Text FRQ
**Unit:** Unit 6 - Inference for Categorical/Quantitative Data (One Sample Means)
**Difficulty:** Medium
**Content type:** inference
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A quality-control engineer takes a random sample of 36 batteries from a large production run and records their lifetimes. The sample mean is 14.2 hours with a sample standard deviation of 1.8 hours. Assume the sampling distribution of the sample mean is approximately normal.

**A.** Construct a 95% confidence interval for the true mean battery lifetime, showing the formula, critical value, and calculation.

**B.** Interpret this confidence interval in context, and state one condition that should be checked before this interval is considered valid.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Uses the correct formula (sample mean +/- t* x (s / sqrt(n)), or z* if specified) with correct values substituted: 14.2 +/- t*(1.8/sqrt(36)). | Accept t* from a t-distribution with df=35 (approximately 2.03) or a reasonable z* approximation if the response states that choice; the key requirement is correct structure and correct substitution of given values. |
| `C2` | Computes a numerically correct interval (approximately 13.59 to 14.81 hours, depending on which critical value is used). | Accept a small range of correct numeric answers depending on t* vs z* choice, as long as the arithmetic from the response's own formula is internally consistent. |
| `C3` | Interprets the interval in context: states that we are 95% confident that the true mean lifetime of all batteries in this production run is captured by the calculated interval. | Must reference the population parameter (true mean lifetime) and 'confident the interval captures it,' not a claim about individual batteries or about repeated sample means. |
| `C4` | States a condition that should be checked (random sample, independence/10% condition given a large production run, or approximate normality of the sampling distribution/population) relevant to this scenario. | Any one correctly stated and relevant condition is sufficient. |

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
(A) Using x-bar +/- t* (s / sqrt(n)) with x-bar = 14.2, s = 1.8, n = 36, and t* = 2.03 (df = 35, 95% confidence): 14.2 +/- 2.03(1.8/sqrt(36)) = 14.2 +/- 2.03(0.30) = 14.2 +/- 0.609, giving an interval of about (13.59, 14.81) hours.

(B) We are 95% confident that the interval (13.59, 14.81) hours captures the true mean lifetime of all batteries in this production run. One condition to check is that the sample of 36 batteries was randomly selected from the production run (and, since the run is large, that 36 is less than 10% of the total batteries produced, satisfying independence).
```

#### R2

```text
(A) 14.2 +/- 1.8/sqrt(36) = 14.2 +/- 0.3, so (13.9, 14.5).

(B) We are 95% sure that 95% of all batteries last between 13.9 and 14.5 hours.
```

#### R3

```text
(A) 14.2 +/- 2.03(1.8/sqrt(36)) = 14.2 +/- 0.609, so (13.59, 14.81).

(B) We are 95% confident the true mean battery life is in this interval.
```

#### R4

```text
(A) x-bar +/- t*(s/sqrt(n)): 14.2 +/- 2.03(1.8/sqrt(36)) = 14.2 +/- 0.609 = (13.591, 14.809).

(B) We can be 95% confident that the interval (13.591, 14.809) hours captures the true mean lifetime of batteries from this production run. Before trusting this interval, we should check that the sampling distribution of the sample mean is approximately normal, which is reasonable to assume here given the problem states it directly, or otherwise would require either a large enough sample size or an approximately normal population distribution.
```

#### R5

```text
(A) 14.2 +/- 2.03(1.8/6) = 14.2 +/- 0.609, so (13.591, 14.809).

(B) We are 95% confident the interval captures the average lifetime of these 36 sample batteries. We should check that the sample size is large.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct formula, correct t* and arithmetic, a properly worded confidence-interval interpretation about the true mean, and a relevant condition (random sample / 10% condition). |
| `R2` | not_earned | not_earned | not_earned | not_earned | Omits the critical value entirely (uses just the standard error, not t* times the standard error), so the interval is far too narrow for a 95% confidence level. The interpretation in (B) also commits the classic misinterpretation of a confidence interval as describing where 95% of individual values fall, rather than a statement of confidence about the population mean. No condition is mentioned. Flags: missing critical value, classic CI misinterpretation, condition omitted. |
| `R3` | earned | earned | earned | not_earned | Formula, substitution, and arithmetic are all correct, and the interpretation correctly references the true mean. However, the response never states any condition that should be checked before trusting the interval (random sample, independence, or normality), which part B explicitly asked for. Flags: incomplete response -- condition omitted despite otherwise full credit on A and the interpretation. |
| `R4` | earned | earned | earned | earned | Second full-credit response with more detail on the normality condition specifically. |
| `R5` | earned | earned | not_earned | earned | Calculation is correct (sqrt(36)=6 correctly simplified). However, the interpretation in (B) refers to 'the average lifetime of these 36 sample batteries' rather than the true population mean of all batteries in the production run -- this is a common misinterpretation confusing the sample statistic with the population parameter the interval is meant to estimate. The condition stated ('sample size is large') is vague but plausibly acceptable as a stand-in for a normality/CLT condition. Flags: sample-vs-population confusion in interpretation. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `missing_critical_value`, `classic_ci_misinterpretation`, `condition_omitted`
- `R3`: `condition_omitted`
- `R4`: (none)
- `R5`: `sample_vs_population_confusion`
