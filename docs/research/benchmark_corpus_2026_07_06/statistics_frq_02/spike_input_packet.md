# Spike Input Packet -- Interpreting Slope and a Residual Plot in a Regression Model

**Subject:** AP Statistics
**Answer type:** Text FRQ
**Unit:** Unit 2 - Exploring Two-Variable Data
**Difficulty:** Medium
**Content type:** modeling
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A least-squares regression line is fit to predict a car's fuel economy (miles per gallon, mpg) from its weight (in thousands of pounds): `predicted mpg = 42.1 - 5.3(weight)`. The residual plot for this model shows a clear curved (U-shaped) pattern.

**A.** Interpret the slope of this regression line in context.

**B.** Explain what the residual plot's curved pattern indicates about the appropriateness of this linear model, and describe what a researcher should conclude as a result.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Interprets the slope in context: for each additional 1,000 pounds of weight, predicted fuel economy decreases by about 5.3 mpg. | Must include direction (decrease), magnitude (5.3), units (mpg per 1,000 lbs), and 'predicted'/'on average' language. |
| `C2` | Does not misinterpret the intercept as a meaningful prediction outside the data's scope, and correctly restricts the slope interpretation to association/prediction rather than causation. | This criterion checks for absence of a causal claim ('weight causes lower mpg') or an unsupported extrapolation claim, not a separate calculation. |
| `C3` | Explains that a curved residual pattern indicates the relationship between weight and mpg is not actually linear, so a linear model is not appropriate for these data. | Must connect the curved pattern specifically to linearity, not to some other assumption (e.g., outliers, equal variance) unless linearity is also mentioned. |
| `C4` | Concludes that the researcher should not use this linear model for prediction (or should consider a different, non-linear model / transformation) because the residual pattern shows the linear model systematically over- or under-predicts at different weight values. | Must state a concrete consequence (don't use this model / consider transforming or fitting a different model), not just 'the model has a problem.' |

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
(A) For each additional 1,000 pounds a car weighs, the model predicts fuel economy decreases by about 5.3 mpg, on average.

(B) The curved pattern in the residual plot shows that the relationship between weight and mpg is not actually linear -- if it were, the residuals would scatter randomly around zero with no pattern. Because the linear model systematically over-predicts in some weight ranges and under-predicts in others, the researcher should conclude that this linear model is not appropriate for these data and should consider a different model, such as a curved (nonlinear) fit or a transformation of the variables, rather than using this line for prediction.
```

#### R2

```text
(A) Weight causes mpg to go down by 5.3 for every unit of weight.

(B) The residual plot being curved just means there were a few outlier cars; the linear model is still fine to use for prediction.
```

#### R3

```text
(A) The slope means mpg decreases by 5.3 as weight increases.

(B) The curved residual pattern means the linear model isn't appropriate. The researcher should try a different model.
```

#### R4

```text
(A) On average, for every 1,000-pound increase in a car's weight, its predicted fuel economy decreases by about 5.3 mpg.

(B) A curved pattern in a residual plot means the association between weight and mpg isn't linear, so a straight-line model doesn't capture the true relationship well. As a result, the researcher shouldn't rely on this linear equation to predict mpg and should instead look for a model that better fits the curved pattern, such as fitting a quadratic model or transforming one of the variables.
```

#### R5

```text
(A) For every 1,000 lbs of extra weight, predicted mpg drops by 5.3, on average.

(B) The curved residuals mean the model has some error in it, but since R-squared is probably still high, the linear model can still be trusted for prediction.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response. Slope interpretation includes direction, magnitude, units, and 'predicted/on average' language; residual explanation correctly ties the curve to linearity and gives a concrete next step. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Uses causal language ('weight causes') rather than association/prediction language, and drops the units (per 1,000 lbs) and 'predicted/on average' qualifier from the slope. Then misattributes the curved pattern to outliers rather than nonlinearity, and incorrectly concludes the model is still fine to use. Flags: causal language misuse, misdiagnosed residual pattern, unsupported conclusion. |
| `R3` | not_earned | earned | earned | earned | The slope interpretation is missing the unit of weight (per 1,000 lbs) and the 'predicted/on average' qualifier -- as written it reads as a deterministic per-unit-of-weight statement rather than a per-1,000-lb, on-average prediction, so C1 is not earned even though direction and magnitude are present. Parts about linearity and next steps are both correct, if brief. Flags: over-credit risk if grader treats direction+magnitude alone as sufficient for C1. |
| `R4` | earned | earned | earned | earned | Second full-credit response with slightly different phrasing; confirms grader tolerance for 'straight-line model' as equivalent to 'linear model.' |
| `R5` | earned | earned | not_earned | not_earned | Slope interpretation is fully correct. But part B never actually says the relationship is nonlinear -- 'has some error in it' is vague -- and then invents an unsupported claim about R-squared being high (no R-squared value was given, and a high R-squared doesn't excuse a clear curved residual pattern anyway). Flags: unsupported inference, vague generality, misconception that R-squared alone validates linearity. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `causal_language_misuse`, `unsupported_inference`
- `R3`: `over_credit_risk`, `units_omitted`
- `R4`: (none)
- `R5`: `unsupported_inference`, `vague_generality`, `r_squared_misconception`
