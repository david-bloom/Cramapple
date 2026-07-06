# Spike Input Packet -- RuBisCO Carbon Fixation Under Falling CO2 Concentration

**Subject:** AP Biology
**Answer type:** Text FRQ
**Unit:** Unit 3 - Cellular Energetics (Calvin Cycle)
**Difficulty:** Medium
**Content type:** concept-heavy
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A plant is moved from a chamber with normal atmospheric CO2 concentration into a sealed chamber where CO2 concentration is allowed to gradually fall as photosynthesis proceeds, while light intensity and temperature are held constant and unlimited ATP and NADPH from the light reactions remain available.

**A.** Describe the role of RuBisCO and CO2 in the first step of the Calvin cycle (carbon fixation).

**B.** Predict the effect of falling CO2 concentration on the rate of carbon fixation, and justify your prediction in terms of RuBisCO's substrate.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Describes that RuBisCO catalyzes the attachment (fixation) of CO2 to RuBP (ribulose bisphosphate), producing two molecules of 3-PGA (a 3-carbon compound). | Naming RuBP and 3-PGA specifically is preferred; general 'CO2 attaches to a 5-carbon molecule to form a 3-carbon product' is acceptable. |
| `C2` | Identifies CO2 as the substrate whose availability directly limits the rate of the RuBisCO-catalyzed reaction when CO2 is scarce. | Must specifically identify CO2 (not light, water, or temperature) as the limiting substrate for this step. |
| `C3` | Predicts that the rate of carbon fixation will decrease as CO2 concentration falls. | Direction must be explicit and tied to the falling-CO2 scenario, not a generic 'photosynthesis slows' statement. |
| `C4` | Justifies the prediction by explaining that with ATP and NADPH held constant/unlimited, CO2 becomes the limiting reagent/substrate for RuBisCO, so as its concentration falls, RuBisCO has less substrate to bind and the reaction rate (and thus carbon fixation rate) slows even though light-reaction products are still abundant. | Must explicitly rule out ATP/NADPH as the limiting factor in this scenario, connecting back to the prompt's statement that they remain available. |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 2 |
| `R4` | 4 |
| `R5` | 0 |

#### R1

```text
(A) RuBisCO catalyzes the attachment of a CO2 molecule to RuBP, a 5-carbon molecule, forming an unstable 6-carbon intermediate that immediately splits into two molecules of the 3-carbon compound 3-PGA. This is the carbon-fixation step of the Calvin cycle.

(B) Prediction: the rate of carbon fixation will decrease as CO2 concentration falls. Justification: because ATP and NADPH remain unlimited in this scenario, they are not the limiting factor here -- CO2 itself is RuBisCO's substrate for this reaction, so as CO2 becomes scarce, RuBisCO has fewer CO2 molecules available to bind to RuBP, directly slowing the rate at which 3-PGA (and therefore the rest of the Calvin cycle) is produced.
```

#### R2

```text
(A) RuBisCO uses ATP to attach CO2 to a 3-carbon molecule, making RuBP.

(B) Prediction: carbon fixation rate stays the same, because the light reactions are still providing plenty of ATP and NADPH, and those are what the Calvin cycle really depends on.
```

#### R3

```text
(A) RuBisCO fixes CO2 onto RuBP, producing 3-PGA.

(B) Prediction: carbon fixation will decrease because there's less CO2. Justification: CO2 is needed for the Calvin cycle.
```

#### R4

```text
(A) In the first step of the Calvin cycle, RuBisCO catalyzes fixation of CO2 onto the 5-carbon RuBP, producing two 3-carbon 3-PGA molecules.

(B) Prediction: carbon fixation rate will fall as CO2 falls. Justification: since ATP and NADPH supply is unlimited in this scenario, they cannot be the bottleneck; instead, CO2, which is RuBisCO's substrate in this reaction, becomes scarce, so RuBisCO has fewer molecules to bind per unit time, directly reducing the rate 3-PGA is produced.
```

#### R5

```text
(A) RuBisCO combines carbon dioxide with a starting molecule to make a product used later in the cycle.

(B) Prediction: carbon fixation rate will increase, because when CO2 gets low the plant will open its stomata wider to bring in more CO2, balancing things out.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct mechanism, correct identification of CO2 as the limiting substrate, and explicit ruling-out of ATP/NADPH limitation as given in the prompt. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Reverses the carbon-fixation reaction (RuBP is the starting substrate that CO2 attaches to, not the product) and incorrectly claims ATP is used directly in the fixation step itself. Then predicts no change and justifies it purely via ATP/NADPH availability, ignoring that CO2 -- not ATP/NADPH -- is the substrate that has actually become scarce. Flags: invented biology (reaction reversed), missed limiting-reagent identification. |
| `R3` | earned | not_earned | earned | not_earned | Part A is correct and concise. Prediction direction is correct, but the justification never explains RuBisCO's substrate role specifically or rules out ATP/NADPH as a possible limiting factor -- 'CO2 is needed for the Calvin cycle' is a restatement of the premise, not an explanation of why scarcity of that specific substrate slows the RuBisCO reaction. Flags: over-credit risk, justification restates prompt. |
| `R4` | earned | earned | earned | earned | Second full-credit response, near-paraphrase of R1; useful as a duplicate-quality check that the grader scores both identically. |
| `R5` | unable_to_determine | not_earned | not_earned | not_earned | Part A is vague enough ('a starting molecule,' 'a product used later') that it does not clearly demonstrate knowledge of RuBP/3-PGA identity or the 5-carbon-to-3-carbon transition -- flagged unable_to_determine rather than assumed earned, pending a rubric-drift decision on how much specificity 'first step' language requires. Part B invents an unsupported stomatal-response mechanism not established by the sealed-chamber scenario and predicts the wrong direction outright. Flags: invented biology, unsupported inference, rubric ambiguity on vague description credit. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `invented_biology`, `missed_limiting_reagent`
- `R3`: `over_credit_risk`, `justification_restates_prompt`
- `R4`: (none)
- `R5`: `invented_biology`, `unsupported_inference`, `rubric_ambiguity`
