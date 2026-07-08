# Spike Input Packet -- Uncoupling the Proton Gradient in Oxidative Phosphorylation

**Subject:** AP Biology
**Answer type:** Text FRQ
**Unit:** Unit 3 - Cellular Energetics
**Difficulty:** Hard
**Content type:** mechanism-heavy
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A researcher adds a chemical uncoupler to isolated mitochondria. The uncoupler makes the inner mitochondrial membrane freely permeable to protons, so protons can cross back into the matrix without passing through ATP synthase. Electron transport chain activity and oxygen consumption both increase after the uncoupler is added.

**A.** Describe how the electron transport chain normally establishes a proton gradient across the inner mitochondrial membrane, and explain how that gradient normally drives ATP synthesis.

**B.** Predict the effect of the uncoupler on the amount of ATP produced per oxygen molecule consumed, and justify your prediction using the proton gradient.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Describes that electron transport chain complexes pump protons from the matrix into the intermembrane space, creating a proton (electrochemical) gradient. | Must place proton movement matrix -> intermembrane space, not the reverse. |
| `C2` | Explains that protons normally flow back into the matrix through ATP synthase, and this flow drives the phosphorylation of ADP to ATP (chemiosmosis). | Accept 'chemiosmosis' by name or by mechanism description. |
| `C3` | Predicts that ATP produced per oxygen consumed will decrease despite increased electron transport chain activity and oxygen consumption. | Response must reconcile increased O2 use with decreased ATP yield, not just state one or the other. |
| `C4` | Justifies the prediction by explaining that protons leak back through the membrane itself instead of through ATP synthase, dissipating the gradient as heat and uncoupling electron transport from ATP synthesis. | Restating 'the uncoupler uncouples them' without the leak/heat mechanism should not earn full credit. |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 2 |
| `R6` | 1 |

#### R1

```text
(A) As electrons move through the electron transport chain complexes, energy released is used to actively pump protons from the matrix into the intermembrane space, building up a proton gradient. Protons flow back down this gradient through ATP synthase, and that flow provides the energy ATP synthase uses to phosphorylate ADP into ATP.

(B) Prediction: ATP produced per oxygen consumed will decrease. Justification: Because the membrane is now permeable to protons, protons can leak back into the matrix directly through the membrane instead of through ATP synthase. The gradient is dissipated as heat rather than captured by ATP synthase, so electron transport and oxygen consumption keep occurring (and even speed up as the cell tries to restore the gradient) while much less of that energy is converted to ATP.
```

#### R2

```text
(A) The electron transport chain pumps protons from the intermembrane space into the matrix, and this movement powers ATP synthase to make ATP.

(B) Prediction: ATP production will increase. Justification: Since the uncoupler lets protons move more freely, ATP synthase can work faster and make more ATP per oxygen used.
```

#### R3

```text
(A) Electron transport chain complexes pump protons into the intermembrane space, building a gradient. Protons flow back through ATP synthase to make ATP.

(B) Prediction: ATP per oxygen consumed will decrease. Justification: The uncoupler messes up the normal process so the cell can't make as much ATP anymore.
```

#### R4

```text
(A) The electron transport chain pumps protons from the matrix into the intermembrane space, creating a gradient that drives ATP synthase to produce ATP from ADP.

(B) Prediction: ATP produced per oxygen consumed will decrease. Justification: The uncoupler makes the membrane permeable to protons, so protons leak back into the matrix through the membrane itself, not through ATP synthase. This wastes the gradient as heat instead of ATP, even though the electron transport chain runs faster to try to keep up.
```

#### R5

```text
(A) Protons are pumped into the intermembrane space by the electron transport chain, creating a gradient that powers ATP synthase.

(B) Prediction: ATP production per oxygen will stay the same, because the electron transport chain is still running and oxygen is still being consumed at the end of the chain, so ATP synthase should still work normally.
```

#### R6

```text
(A) Electron transport chain complexes use energy from electrons to move protons across the membrane, and this makes ATP somehow through ATP synthase.

(B) Prediction: ATP will decrease per oxygen consumed. Justification: protons stop moving through the membrane entirely once the uncoupler is added, so ATP synthase has nothing to use.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response. Correctly places proton pumping direction, chemiosmotic ATP synthesis, and the leak/heat mechanism explaining decreased ATP yield despite increased O2 consumption. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Reverses the direction of proton pumping in (A), which breaks the chemiosmosis explanation in C2 as well. (B) gets both the direction of the ATP effect and the mechanism wrong -- treats the uncoupler as helping ATP synthase rather than bypassing it. Flags: invented mechanism, direction-reversal error. |
| `R3` | earned | earned | earned | not_earned | Part A is fully correct and the direction of the prediction is right, but the justification never explains *how* the uncoupler lowers ATP yield -- no mention of proton leak, bypassing ATP synthase, or heat dissipation. Restates the outcome rather than the mechanism. Flags: over-credit risk if graded on prediction direction alone. |
| `R4` | earned | earned | earned | earned | Second full-credit response with slightly different phrasing, useful as a paraphrase-robustness check against R1 -- the grader should not require R1's exact wording ('as heat') to award C4. |
| `R5` | earned | earned | not_earned | not_earned | Part A is correct, but the prediction ignores that the gradient itself is dissipated by the leak -- treats 'chain is running' as sufficient for normal ATP output, missing the core uncoupling concept. Flags: under-credit risk if grader mistakes 'chain still running' language for partial C4 credit -- it should not receive any C4 credit. |
| `R6` | unable_to_determine | not_earned | earned | not_earned | Direction of proton pumping in (A) is vague ('across the membrane' without specifying matrix-to-intermembrane direction) -- reviewer should confirm whether vague directionality still earns C1; flagged as unable_to_determine pending a rubric-drift decision rather than scored outright. (B) prediction direction is right but justification invents the wrong mechanism (protons stopping entirely, rather than leaking through the membrane instead of ATP synthase). Flags: rubric ambiguity on C1 vague-direction wording, invented mechanism on C4. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `invented_biology`, `direction_reversal_error`
- `R3`: `over_credit_risk`, `justification_restates_prompt`
- `R4`: (none)
- `R5`: `misconception_chain_activity_equals_atp_yield`
- `R6`: `rubric_ambiguity`, `invented_biology`
