# Spike Input Packet -- Independence vs. Mutually Exclusive Events in a Dice/Card Scenario

**Subject:** AP Statistics
**Answer type:** Text FRQ
**Unit:** Unit 4 - Probability, Random Variables, and Probability Distributions
**Difficulty:** Medium
**Content type:** reasoning
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

Let event A be 'drawing a King' from a standard 52-card deck, and event B be 'drawing a Heart.' A student claims: 'Since a King of Hearts exists, A and B cannot be independent, because independent events must be mutually exclusive.'

**A.** Explain what it means for two events to be independent, and what it means for two events to be mutually exclusive, and state whether these are the same concept.

**B.** Determine whether events A and B are independent by comparing P(A), P(B), and P(A and B), and explain what this shows about the student's claim.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Correctly defines independence: two events are independent if the occurrence of one does not change the probability of the other (P(A|B) = P(A), equivalently P(A and B) = P(A) x P(B)). | Must reference the conditional-probability-unchanged idea or the multiplication rule, not just 'they don't affect each other' with no further detail. |
| `C2` | Correctly defines mutually exclusive: two events are mutually exclusive if they cannot both occur at the same time (P(A and B) = 0), and states that independence and mutual exclusivity are different concepts (in fact, two mutually exclusive events with nonzero probability are never independent). | Must explicitly state these are different concepts, not treat them as synonyms. |
| `C3` | Correctly computes P(A) = 4/52, P(B) = 13/52, and P(A and B) = 1/52 (the King of Hearts), and checks P(A) x P(B) = (4/52)(13/52) = 52/2704 = 1/52, which equals P(A and B). | Numeric values must be correct and the comparison must be shown, not just asserted. |
| `C4` | Concludes that since P(A and B) = P(A) x P(B), events A and B are in fact independent, which directly contradicts the student's claim -- the existence of the King of Hearts (a nonzero intersection) is exactly why they are not mutually exclusive, but that has no bearing on whether they are independent. | Must explicitly connect the numeric check to refuting the student's claim, not just state 'they are independent' without addressing the claim. |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 1 |

#### R1

```text
(A) Two events are independent if knowing one occurred does not change the probability of the other -- that is, P(A|B) = P(A), which is equivalent to P(A and B) = P(A) x P(B). Two events are mutually exclusive if they cannot both happen at the same time, meaning P(A and B) = 0. These are different concepts: mutually exclusive events with nonzero individual probabilities are actually never independent, and independent events are usually not mutually exclusive (since both can occur together with the expected joint probability).

(B) P(A) = 4/52 (Kings), P(B) = 13/52 (Hearts), and P(A and B) = 1/52 (the King of Hearts). Checking P(A) x P(B) = (4/52)(13/52) = 1/52, which equals P(A and B). Since this equality holds, A and B are independent. This directly contradicts the student's claim: the King of Hearts existing is exactly why A and B are not mutually exclusive, but that has nothing to do with independence -- in fact these two events are independent.
```

#### R2

```text
(A) Independent and mutually exclusive mean the same thing -- both describe events that don't overlap.

(B) Since a King of Hearts exists, A and B overlap, so they are not independent. The student is correct.
```

#### R3

```text
(A) Independent means one event doesn't affect the other's probability. Mutually exclusive means they can't both happen. These are different things.

(B) P(A) x P(B) = 1/52, which is the same as P(A and B) = 1/52, so they are independent. The student is wrong.
```

#### R4

```text
(A) Two events are independent when the outcome of one has no effect on the probability of the other occurring. Two events are mutually exclusive when they cannot occur together. These are not the same idea -- mutually exclusive events (with nonzero probability) are always dependent, since knowing one happened makes the other impossible.

(B) P(A) = 4/52, P(B) = 13/52, P(A and B) = 1/52. Since P(A) x P(B) = (4/52)(13/52) = 1/52 = P(A and B), the events are independent. The student's claim is incorrect: the King of Hearts shows that A and B are not mutually exclusive, but mutual exclusivity has no bearing on independence, and the calculation shows these particular events actually are independent.
```

#### R5

```text
(A) Independent means the events are unrelated. Mutually exclusive means they overlap. They're different.

(B) P(A and B) = 1/52, and P(A) times P(B) also equals 1/52, so they're independent, meaning the student is wrong.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct definitions distinguishing the two concepts, correct probability calculations, and a direct refutation of the student's claim using the numeric result. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Repeats exactly the misconception the item is designed to test -- claims independence and mutual exclusivity are the same concept, and endorses the student's incorrect claim without ever computing P(A), P(B), or P(A and B) to check. Flags: core misconception endorsed, no calculation shown, unsupported conclusion. |
| `R3` | earned | earned | earned | not_earned | Definitions and calculation are correct, and the final claim ('the student is wrong') is the right conclusion, but the response never explains *why* the student is wrong -- it doesn't connect the King-of-Hearts intersection to mutual exclusivity being false while independence still holds, which is the actual point of confusion being tested. Flags: over-credit risk, conclusion stated without connecting reasoning back to the specific claim. |
| `R4` | earned | earned | earned | earned | Second full-credit response with an additional correct detail (mutually exclusive nonzero-probability events are always dependent); useful for confirming the grader accepts this extra correct elaboration without penalizing length. |
| `R5` | not_earned | not_earned | earned | not_earned | The calculation in (B) is correct and the final verdict happens to be right, but both definitions in (A) are stated backwards or vaguely: 'independent means unrelated' is too vague to demonstrate the conditional-probability concept, and 'mutually exclusive means they overlap' is the opposite of the correct definition (mutually exclusive events do NOT overlap). Because the definitions are wrong, the reasoning connecting the calculation to refuting the claim is not actually sound even though the numeric check and final verdict are correct. Flags: definition reversal error, correct answer via unsound reasoning. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `independence_mutual_exclusivity_conflation`, `unsupported_inference`
- `R3`: `over_credit_risk`, `justification_restates_prompt`
- `R4`: (none)
- `R5`: `definition_reversal_error`, `correct_conclusion_wrong_reasoning`
