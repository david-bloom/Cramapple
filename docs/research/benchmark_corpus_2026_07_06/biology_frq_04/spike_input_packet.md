# Spike Input Packet -- Tonicity Shift in a Plant Cell Vacuole

**Subject:** AP Biology
**Answer type:** Text FRQ
**Unit:** Unit 2 - Cell Structure and Function
**Difficulty:** Medium
**Content type:** concept-heavy
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A turgid plant cell with a large central vacuole is placed in a hypertonic solution of sucrose. After 30 minutes, the cell is observed to be plasmolyzed.

**A.** Describe the direction of net water movement across the plasma membrane during this 30-minute period, and explain why water moves in that direction.

**B.** Predict what would happen to the same plasmolyzed cell if it were then moved into distilled water, and justify your prediction.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Describes net water movement as out of the cell (cytoplasm/vacuole into the surrounding solution). | Direction must be explicit, not just 'water moves.' |
| `C2` | Explains the direction using water potential/solute concentration: the hypertonic solution has a lower water potential (higher solute concentration) than the cell interior, so water moves down its water potential gradient out of the cell. | Accept either water-potential language or solute-concentration/osmosis language, but the explanation must reference the gradient, not just define plasmolysis. |
| `C3` | Predicts that the cell will regain turgor / water will move back into the cell (deplasmolysis) when placed in distilled water. | Must state the direction reverses, not just 'the cell will be affected.' |
| `C4` | Justifies the prediction by explaining that distilled water has a higher water potential (essentially no solutes) than the cell interior, so water now moves down its gradient into the cell, re-inflating the vacuole and pushing the membrane back against the cell wall. | Should mention the cell wall limiting expansion / turgor pressure being restored, not unlimited swelling. |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 2 |
| `R4` | 4 |
| `R5` | 2 |

#### R1

```text
(A) Water moves out of the cell during the 30 minutes. Because the surrounding sucrose solution is hypertonic, it has a higher solute concentration and therefore a lower water potential than the cell's interior. Water moves down its water potential gradient, from the higher-water-potential cell interior to the lower-water-potential external solution, causing the cell to lose water and the membrane to pull away from the wall (plasmolysis).

(B) Prediction: The cell will regain turgor pressure as water moves back in (deplasmolysis). Justification: Distilled water has almost no solutes, so it has a much higher water potential than the cell interior, which still has a relatively high solute concentration after losing water. Water now flows down its gradient into the cell, re-inflating the central vacuole until the cell membrane presses against the cell wall again, restoring turgor pressure.
```

#### R2

```text
(A) Water moves into the cell because the cell has more solutes than the sucrose solution, so water tries to balance it out.

(B) The cell will burst because distilled water has no solutes and will keep flowing in until the cell membrane pops.
```

#### R3

```text
(A) Water moves out of the cell, causing plasmolysis, because the solution outside is hypertonic.

(B) Prediction: the cell will regain turgor pressure. Justification: distilled water will move into the cell.
```

#### R4

```text
(A) Net water movement is out of the cell. The hypertonic sucrose solution has less water and more solute than the cell's cytoplasm, so water diffuses from where it's more concentrated (inside the cell) to where it's less concentrated (outside), which is osmosis down the water concentration gradient.

(B) Prediction: the cell will deplasmolyze and regain turgor. Justification: distilled water is almost pure water, so it has a much higher concentration of water molecules than the cell's interior, and water diffuses back into the cell until the vacuole pushes the membrane against the cell wall again.
```

#### R5

```text
(A) Water leaves the cell because the outside solution is hypertonic and has a lower water potential, so water moves out down its gradient.

(B) Prediction: the cell will keep losing water and shrink further, because the sucrose residue left on the cell surface will keep drawing water out even in distilled water.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct direction, water-potential-based mechanism in both parts, and correct mention of the cell wall limiting re-expansion. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Reverses the direction of water movement in (A) relative to the given hypertonic condition (should be out, not in), which is inconsistent with the stated observation that the cell plasmolyzed. (B) ignores the cell wall entirely and predicts bursting, which does not occur in walled plant cells at normal turgor. Flags: direction-reversal error, invented outcome (animal-cell lysis logic applied to a plant cell). |
| `R3` | earned | not_earned | earned | not_earned | Both parts get the direction right but never explain the water-potential/solute-gradient mechanism behind either movement -- (A) just restates 'hypertonic' as the cause without saying why that produces outward water movement, and (B) states the conclusion of C4 as its own justification. Flags: over-credit risk if graded on direction alone; useful boundary case distinguishing 'correct direction' (C1/C3) from 'correct mechanism' (C2/C4). |
| `R4` | earned | earned | earned | earned | Full-credit response phrased entirely in terms of relative water concentration/osmosis rather than water-potential terminology -- confirms both phrasings should be accepted for C2/C4 as the rubric notes allow. |
| `R5` | earned | earned | not_earned | not_earned | Part A is fully correct. Part B invents a 'sucrose residue on the cell surface' mechanism that isn't supported -- once the cell is moved into distilled water, the external solute concentration is what determines water potential outside the cell, not a residue. Predicts the wrong direction of change as a result. Flags: invented biology, unsupported inference. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `invented_biology`, `direction_reversal_error`
- `R3`: `over_credit_risk`, `justification_restates_prompt`
- `R4`: (none)
- `R5`: `invented_biology`, `unsupported_inference`
