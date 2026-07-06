# Spike Input Packet -- Effect of Sample Size on the Standard Error of the Sample Mean

**Subject:** AP Statistics
**Answer type:** Text FRQ
**Unit:** Unit 5 - Sampling Distributions
**Difficulty:** Medium
**Content type:** modeling
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A population of adult resting heart rates has mean 72 beats per minute and standard deviation 9 beats per minute. Researchers plan to take a random sample and compute the sample mean heart rate.

**A.** Describe the shape, center, and spread of the sampling distribution of the sample mean if a sample size of n = 9 is used, versus a sample size of n = 100. Assume the population distribution is approximately normal.

**B.** Explain why increasing the sample size from 9 to 100 changes the spread of the sampling distribution but does not change its center, and explain the practical consequence for how precisely the sample mean estimates the population mean.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | States that both sampling distributions are approximately normal in shape (since the population is approximately normal, the sampling distribution of the sample mean is normal for any sample size), and both are centered at the population mean, 72 bpm. | Must state shape (normal) and center (72) for both sample sizes. |
| `C2` | Correctly calculates the standard error for each sample size: for n=9, SE = 9/sqrt(9) = 3 bpm; for n=100, SE = 9/sqrt(100) = 0.9 bpm, and states that the n=100 sampling distribution has a smaller spread (less variability) than the n=9 sampling distribution. | Both SE values must be numerically correct and compared. |
| `C3` | Explains that the center of the sampling distribution (population mean) does not depend on sample size -- the sample mean is an unbiased estimator of the population mean regardless of n -- while the spread (standard error) decreases as sample size increases because dividing by a larger sqrt(n) reduces variability among sample means. | Must explain both halves: why center is unaffected and why spread decreases, tied to the standard error formula. |
| `C4` | Explains the practical consequence: with the larger sample size (n=100), the sample mean is likely to be closer to the true population mean (less variable from sample to sample), making it a more precise estimator, whereas with n=9 individual sample means could vary more widely from the true population mean. | Must state precision/estimation-quality consequence, not just repeat the standard error values. |

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
(A) For n=9, the sampling distribution of the sample mean is approximately normal, centered at 72 bpm, with standard error 9/sqrt(9) = 3 bpm. For n=100, the sampling distribution is also approximately normal, still centered at 72 bpm, but with a much smaller standard error of 9/sqrt(100) = 0.9 bpm.

(B) The center of the sampling distribution doesn't change with sample size because the sample mean is an unbiased estimator of the population mean no matter how large the sample is -- on average, sample means from either sample size center on 72. The spread decreases as sample size increases because the standard error formula divides the population standard deviation by sqrt(n); a larger n produces a larger denominator and therefore a smaller standard error. Practically, this means that with n=100, sample means will tend to be much closer to the true population mean of 72 bpm from sample to sample, making it a more precise estimate than with the smaller sample of n=9, where sample means could vary more widely around 72.
```

#### R2

```text
(A) For n=9, the distribution is skewed with mean around 72 and spread of 9. For n=100, the distribution becomes normal with a mean higher than 72 and a spread of 9 also.

(B) Bigger samples make the distribution more normal and shift the mean closer to the true average, but the spread stays the same because the population standard deviation doesn't change.
```

#### R3

```text
(A) Both are approximately normal, centered at 72. For n=9, spread is 3; for n=100, spread is 0.9.

(B) The center stays the same, but spread decreases with a bigger sample. This means the estimate is better with more data.
```

#### R4

```text
(A) For n=9, the sampling distribution is approximately normal with mean 72 bpm and standard error 9/sqrt(9) = 3 bpm. For n=100, it is also approximately normal with mean 72 bpm and standard error 9/sqrt(100) = 0.9 bpm -- much less spread out.

(B) The center is unaffected by sample size because the sample mean is unbiased regardless of n; averaging more or fewer values doesn't systematically push the average away from 72. The spread shrinks as n grows because the standard error formula (population SD divided by the square root of n) has n in the denominator under a square root, so a bigger sample makes the denominator bigger and the standard error smaller. Practically, this means sample means computed from n=100 will cluster much more tightly around 72 than sample means computed from n=9, so the n=100 sample mean is a more precise, reliable estimate of the true population mean.
```

#### R5

```text
(A) Both distributions are approximately normal and centered at 72 bpm. Standard errors are 3 and 0.9 respectively.

(B) The spread decreases with sample size because you're including more people, which makes outliers matter less and less. The mean stays the same because averages don't really change with sample size.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct shape/center/spread for both sample sizes, a correct explanation tied to the standard error formula, and a clear precision consequence. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Incorrectly claims the n=9 sampling distribution is skewed (it should be approximately normal since the population itself is approximately normal) and that the mean shifts with n=100 (the center never changes -- it stays at the population mean regardless of n). Also uses the population standard deviation (9) as the standard error for both sample sizes instead of dividing by sqrt(n), and claims spread doesn't change, which is the opposite of the correct relationship. Flags: shape misconception, center-shifts-with-n misconception, standard-error-formula omitted entirely. |
| `R3` | earned | earned | not_earned | earned | Shape/center/spread values in (A) are all correct, and the practical-precision consequence in (B) is stated (though briefly). However, (B) never explains *why* the center is unaffected (unbiasedness) or *why* the spread decreases (the sqrt(n) relationship in the standard error formula) -- it just restates that these things happen without the underlying mechanism the criterion asks for. Flags: over-credit risk, mechanism omitted despite correct numeric values. |
| `R4` | earned | earned | earned | earned | Second full-credit response with more explicit mechanism detail; useful for confirming grader consistency on the mechanism-explanation requirement in C3. |
| `R5` | earned | earned | not_earned | not_earned | Shape/center/spread numbers are all correct. But the explanation in (B) never invokes the standard-error formula (SD/sqrt(n)) -- 'outliers matter less' is an informal and incomplete mechanism, and 'averages don't really change with sample size' asserts the conclusion without explaining unbiasedness. Also never states the practical precision consequence for estimating the population mean. Flags: mechanism incomplete/informal, practical consequence omitted. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `shape_misconception`, `center_shifts_with_n_misconception`, `standard_error_formula_omitted`
- `R3`: `over_credit_risk`, `mechanism_omitted`
- `R4`: (none)
- `R5`: `mechanism_omitted`, `vague_generality`
