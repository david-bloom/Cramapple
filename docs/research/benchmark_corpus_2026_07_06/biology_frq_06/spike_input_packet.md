# Spike Input Packet -- A Primase-Deficient Mutant and Lagging Strand Synthesis

**Subject:** AP Biology
**Answer type:** Text FRQ
**Unit:** Unit 6 - DNA Replication
**Difficulty:** Hard
**Content type:** mechanism-heavy
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A bacterial mutant produces a nonfunctional primase enzyme but has normal helicase, DNA polymerase, and ligase activity. Researchers examine DNA replication in this mutant.

**A.** Describe the normal roles of helicase and primase at a replication fork, and explain why DNA polymerase requires the product that primase makes.

**B.** Predict the effect of nonfunctional primase on leading strand synthesis and on lagging strand synthesis, and justify each prediction.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Describes helicase unwinding the double helix at the replication fork, and primase synthesizing short RNA primers that provide a free 3' end. | Both enzymes must be described, not just one. |
| `C2` | Explains that DNA polymerase can only add nucleotides to an existing 3' end and cannot initiate a new strand on its own, so it requires the RNA primer as a starting point. | Must state the 3'-OH extension requirement, not just 'DNA polymerase needs primase to work.' |
| `C3` | Predicts that both leading and lagging strand synthesis will fail to initiate (no new DNA strand is made on either strand) because both require an RNA primer to begin, even though leading strand normally needs only one primer and lagging strand needs many. | A response that says only lagging strand is affected should not earn this criterion -- leading strand also needs one initial primer. |
| `C4` | Justifies that although the lagging strand normally requires repeated primase activity for each Okazaki fragment (making it more heavily dependent on primase), the leading strand also needs at least one primer to begin synthesis in the first place, so eliminating primase blocks initiation of DNA replication on both strands. | Response should explicitly compare the two strands' primer dependence rather than treating only lagging strand as affected. |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 2 |
| `R4` | 4 |
| `R5` | 1 |

#### R1

```text
(A) Helicase unwinds the double helix at the replication fork, separating the two strands and creating two single-stranded templates. Primase then synthesizes a short RNA primer on each template, providing a free 3'-OH end. DNA polymerase can only add new nucleotides onto an existing 3' end -- it cannot start a new strand from scratch -- so it requires the primer primase provides before it can begin extending DNA.

(B) Prediction: Neither leading strand nor lagging strand synthesis will initiate. Justification: the leading strand needs one initial RNA primer to start continuous synthesis, and the lagging strand needs a new primer for every Okazaki fragment. Without functional primase, no primers are made on either strand, so DNA polymerase has no 3' end to extend on either strand, and replication cannot begin at all.
```

#### R2

```text
(A) Helicase makes RNA primers and primase unwinds the DNA.

(B) Prediction: only the lagging strand will be affected, because it's the one made in pieces. Justification: the leading strand is made continuously so it doesn't need primase.
```

#### R3

```text
(A) Helicase unwinds the DNA at the fork. Primase makes RNA primers so DNA polymerase has somewhere to start.

(B) Prediction: both strands will fail to replicate, because DNA polymerase needs a primer on both strands.
```

#### R4

```text
(A) Helicase separates the two DNA strands at the replication fork by breaking hydrogen bonds between bases. Primase synthesizes short RNA primers complementary to the template, giving a 3'-OH group. DNA polymerase can only extend an existing strand by adding nucleotides to a free 3' end; it cannot join two free nucleotides together to start a strand, so it depends on primase's RNA primer as the starting point.

(B) Prediction: leading strand synthesis will fail to start and lagging strand synthesis will also fail to start. Justification: the leading strand still requires one primer at the origin before continuous synthesis can proceed, and the lagging strand requires a new primer at the start of every Okazaki fragment; without any primase activity, DNA polymerase has no 3' end on either template, so no new DNA is synthesized on either strand.
```

#### R5

```text
(A) Helicase unwinds DNA and primase lays down RNA primers so polymerase has a place to attach.

(B) Prediction: the lagging strand will fail completely, but the leading strand will still replicate normally since it doesn't need repeated primers the way the lagging strand does.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response. Correctly generalizes primer dependence to both strands rather than assuming only the lagging strand is affected. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Swaps the roles of helicase and primase entirely in (A). (B) contains the classic misconception that continuous (leading-strand) synthesis means no primer is ever needed -- in fact the leading strand still needs one initial primer to begin. Flags: role-swap error, common misconception (continuous synthesis needs no primer at all). |
| `R3` | earned | not_earned | earned | not_earned | Part A correctly describes both enzymes' roles but never explains *why* DNA polymerase needs a free 3' end to extend (just says 'somewhere to start'), so C2 is not fully earned. Part B reaches the correct prediction but the justification is a one-clause restatement without comparing the strands' differing primer dependence (single primer vs. repeated primers). Flags: over-credit risk if grader accepts 'needs a primer' alone as the mechanism. |
| `R4` | earned | earned | earned | earned | Second full-credit response with more detailed 3'-OH/hydrogen-bond phrasing; useful for confirming the grader doesn't require exact wording to award C1/C2. |
| `R5` | earned | not_earned | not_earned | not_earned | Part A is acceptable at a general level but again doesn't explain the 3'-OH extension requirement. Part B makes the same continuous-synthesis misconception as R2 in a subtler form -- correctly notes the lagging strand needs *repeated* primers but wrongly concludes the leading strand needs none at all, missing that it still needs one initial primer. Flags: under-credit risk if grader only checks 'lagging strand affected' without checking that leading strand is also predicted to fail. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `invented_biology`, `common_misconception_continuous_strand_no_primer`
- `R3`: `over_credit_risk`, `justification_restates_prompt`
- `R4`: (none)
- `R5`: `common_misconception_continuous_strand_no_primer`, `under_credit_risk`
