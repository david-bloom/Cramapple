# Spike Input Packet -- Prezygotic vs. Postzygotic Reproductive Isolation in Two Cricket Populations

**Subject:** AP Biology
**Answer type:** Text FRQ
**Unit:** Unit 8 - Ecology / Evolution (Speciation)
**Difficulty:** Medium
**Content type:** boundary-sensitive
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

Two populations of crickets, once part of a single species, have been geographically separated for many generations. Population A now produces a mating call at a different pitch than Population B, and A and B rarely attempt to mate with each other. In laboratory crosses where mating is forced to occur, most resulting hybrid offspring are produced, but these hybrids are sterile as adults.

**A.** Identify the reproductive barrier responsible for A and B rarely mating in the wild, and explain whether it is classified as prezygotic or postzygotic.

**B.** Identify the reproductive barrier responsible for hybrid sterility, explain whether it is classified as prezygotic or postzygotic, and explain why both barriers being present would make these populations more likely to be classified as separate species.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Identifies the mating-call/pitch difference as a behavioral isolation barrier and correctly classifies it as prezygotic (it prevents mating/fertilization from occurring at all). | Must use 'prezygotic' correctly -- occurs before a zygote can form. |
| `C2` | Justifies the prezygotic classification by explaining that behavioral isolation prevents mating attempts/fertilization in the first place, before any zygote is formed. | Should not simply assert 'prezygotic' without the before-fertilization reasoning. |
| `C3` | Identifies hybrid sterility as a postzygotic barrier and correctly classifies it as postzygotic (a zygote/hybrid offspring does form, but it cannot itself reproduce). | Must use 'postzygotic' correctly -- occurs after a zygote/hybrid has already formed. |
| `C4` | Explains that the presence of both a prezygotic barrier (limiting gene flow before mating) and a postzygotic barrier (limiting gene flow through infertile hybrids, even on the rare occasions mating does occur) means gene flow between the populations is restricted at multiple points, supporting classification as separate species under the biological species concept. | Must connect both barriers to restricted gene flow and tie that to the species-concept reasoning, not just restate that both barriers exist. |

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
(A) The barrier is behavioral isolation -- the mating call pitch difference means members of A and B do not recognize each other as potential mates. This is a prezygotic barrier because it prevents mating (and therefore fertilization/zygote formation) from occurring at all between the two populations.

(B) The barrier responsible for hybrid sterility is a postzygotic barrier, since a hybrid zygote does form and develop into an offspring, but that offspring is unable to reproduce. Having both barriers present means gene flow is restricted at two separate points: the behavioral barrier prevents most matings from happening in the first place, and even on the rare occasions when mating does occur, the postzygotic sterility barrier prevents any genes from passing to a further generation. Because gene flow between the populations is blocked both before and after mating, the populations are reproductively isolated overall, supporting their classification as separate species.
```

#### R2

```text
(A) The barrier is hybrid sterility, and it's postzygotic because it happens before mating.

(B) The barrier is behavioral isolation, which is prezygotic because it happens after fertilization. Both barriers being present means the populations are the same species since they can still produce some offspring.
```

#### R3

```text
(A) Behavioral isolation, prezygotic.

(B) Hybrid sterility, postzygotic. Both barriers together make it more likely they're separate species.
```

#### R4

```text
(A) The mating call difference causes behavioral isolation, a prezygotic barrier, because it stops fertilization from happening in the first place -- the crickets never mate, so no zygote ever forms.

(B) Hybrid sterility is a postzygotic barrier, because a zygote does form and develop into a living hybrid, but that hybrid cannot pass on its genes since it's sterile. Since gene flow is blocked both before fertilization (behavioral isolation) and after a hybrid forms (sterility), the two populations are effectively unable to exchange genes at all, which supports treating them as separate species under the biological species concept.
```

#### R5

```text
(A) Behavioral isolation is the barrier. It's postzygotic because the crickets are already separate species by the time they'd try to mate.

(B) Hybrid sterility is postzygotic, since the offspring can't reproduce. Since both are postzygotic, gene flow is blocked after zygotes form, so they're separate species.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct barrier identification and classification for both parts, and a complete explanation connecting both barriers to restricted gene flow and species classification. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Swaps which barrier answers which part of the question (behavioral isolation explains the mating-avoidance in the wild, not hybrid sterility; hybrid sterility explains the offspring being infertile, not the mating avoidance). Also inverts the definitions of prezygotic/postzygotic in both directions. The conclusion in (B) is the opposite of the expected reasoning -- some offspring being produced does not override reproductive isolation caused by their sterility. Flags: barrier/part mismatch, prezygotic/postzygotic definitions reversed, invented biology in conclusion. |
| `R3` | earned | not_earned | earned | not_earned | Correct identifications and classifications for both barriers, but neither is justified (no explanation of why the call difference is prezygotic or why sterility is postzygotic), and the species-classification conclusion in (B) is asserted without explaining the gene-flow-restriction reasoning connecting the two barriers. Flags: over-credit risk if grader scores bare correct labels as sufficient -- illustrates the ID-vs-justification split this rubric is built to catch. |
| `R4` | earned | earned | earned | earned | Second full-credit response, slightly more detailed than R1 on the gene-flow reasoning; useful for confirming grader consistency. |
| `R5` | not_earned | not_earned | earned | not_earned | Correctly identifies behavioral isolation as the barrier in (A) but misclassifies it as postzygotic with circular reasoning ('already separate species' assumes the conclusion the question is trying to establish). (B)'s barrier ID and classification are correct, but the response then incorrectly claims *both* barriers are postzygotic, missing that behavioral isolation is prezygotic -- this understates how gene flow is restricted at two different points rather than one. Flags: definition/classification error, circular reasoning, invented biology in the final synthesis. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `invented_biology`, `definition_reversal_error`
- `R3`: `over_credit_risk`, `justification_restates_prompt`
- `R4`: (none)
- `R5`: `definition_reversal_error`, `invented_biology`
