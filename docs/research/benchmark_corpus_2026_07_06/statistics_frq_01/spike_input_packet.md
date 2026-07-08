# Spike Input Packet -- Conditional Relative Frequencies and a Claim of Independence

**Subject:** AP Statistics
**Answer type:** Text FRQ
**Unit:** Unit 1 - Exploring One-Variable Data / Categorical Data
**Difficulty:** Medium
**Content type:** interpretation
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A survey of 400 students classified them by grade level (Freshman/Senior) and whether they participate in an after-school club (Yes/No).

| | Club: Yes | Club: No | Total |
| --- | --- | --- | --- |
| Freshman | 60 | 140 | 200 |
| Senior | 100 | 100 | 200 |
| Total | 160 | 240 | 400 |

**A.** Calculate the conditional relative frequency of club participation given Freshman status, and the conditional relative frequency of club participation given Senior status. Show your work.

**B.** Based on these conditional relative frequencies, explain whether grade level and club participation appear to be associated (not independent) in this sample, and justify your answer using the values from part A.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Calculates P(Club Yes | Freshman) = 60/200 = 0.30 (30%). | Must divide by the row total (200), not the grand total (400). |
| `C2` | Calculates P(Club Yes | Senior) = 100/200 = 0.50 (50%). | Must divide by the row total (200), not the grand total. |
| `C3` | States that grade level and club participation appear to be associated (not independent) in this sample. | Must conclude association, not independence, given the differing conditional frequencies. |
| `C4` | Justifies the association claim by explicitly comparing the two conditional relative frequencies from A (30% vs. 50%) and noting that if the variables were independent, these conditional frequencies would be approximately equal. | Must reference the specific numeric comparison, not just assert 'the numbers are different.' |

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
(A) P(Club Yes | Freshman) = 60/200 = 0.30. P(Club Yes | Senior) = 100/200 = 0.50.

(B) Grade level and club participation appear to be associated in this sample. If the two variables were independent, the conditional relative frequency of club participation should be roughly the same for Freshmen and Seniors. Instead, only 30% of Freshmen participate compared to 50% of Seniors, a substantial difference, which suggests club participation depends on grade level rather than being independent of it.
```

#### R2

```text
(A) P(Club Yes | Freshman) = 60/400 = 0.15. P(Club Yes | Senior) = 100/400 = 0.25.

(B) They are independent because both grades have some students in the club.
```

#### R3

```text
(A) P(Club Yes | Freshman) = 60/200 = 0.30. P(Club Yes | Senior) = 100/200 = 0.50.

(B) They appear to be associated since the percentages are different.
```

#### R4

```text
(A) Freshman: 60 out of 200 Freshmen are in the club, so 60/200 = 0.30. Senior: 100 out of 200 Seniors are in the club, so 100/200 = 0.50.

(B) Since 30% of Freshmen and 50% of Seniors participate in the club, and these conditional percentages would be roughly equal if grade level and club participation were independent, the large gap between 30% and 50% indicates that the two variables are associated, not independent, in this sample.
```

#### R5

```text
(A) P(Club Yes | Freshman) = 60/200 = 0.30. P(Freshman | Club Yes) = 60/160 = 0.375.

(B) Since these two conditional probabilities are different (0.30 vs. 0.375), grade level and club participation are associated.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct conditional frequencies computed off the correct row totals and a comparison-based justification referencing the independence definition. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Divides by the grand total (400) instead of the row total (200) for both conditional frequencies, which is the classic conditional-relative-frequency error. The independence conclusion in (B) is also wrong (the correct conditional frequencies of 30% vs 50% show association) and the justification ('both grades have some students') doesn't address conditional frequencies at all. Flags: arithmetic method error (wrong denominator), unsupported conclusion. |
| `R3` | earned | earned | earned | not_earned | Correct calculations and correct conclusion, but the justification never states the actual values being compared (30% vs. 50%) or connects the comparison to the definition of independence -- 'the percentages are different' is a vague restatement rather than the specific numeric justification the criterion requires. Flags: over-credit risk, vague generality. |
| `R4` | earned | earned | earned | earned | Second full-credit response with slightly more detailed work shown; useful for confirming grader consistency. |
| `R5` | earned | not_earned | earned | not_earned | C1 is correct, but the second calculation answers a different conditional probability than asked (P(Freshman | Club) instead of P(Club | Senior)), so C2 is not earned. The conclusion in B happens to be correct, but the justification compares two conditional probabilities that are not the correct comparison pair for testing independence between grade level and club participation (comparing P(Club|Freshman) to P(Club|Senior) is the correct test, not comparing P(Club|Freshman) to P(Freshman|Club)). Flags: wrong conditional computed, unsupported reasoning despite correct final conclusion. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `arithmetic_method_error`, `unsupported_inference`
- `R3`: `over_credit_risk`, `vague_generality`
- `R4`: (none)
- `R5`: `wrong_conditional_computed`, `correct_conclusion_wrong_reasoning`
