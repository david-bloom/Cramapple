# Spike Input Packet -- Lac Operon Response to Lactose and Glucose Availability

**Subject:** AP Biology
**Answer type:** Text FRQ
**Unit:** Unit 6 - Gene Expression and Regulation
**Difficulty:** Hard
**Content type:** boundary-sensitive
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

*E. coli* cells are grown in a medium containing both glucose and lactose. Researchers then transfer the cells to a medium containing lactose but no glucose.

**A.** Describe the state of the lac operon (transcribed at low, moderate, or high level) while both glucose and lactose are present, and explain the role of the lac repressor and CAP/cAMP in producing that state.

**B.** Explain how removing glucose (while lactose remains present) changes lac operon transcription, referencing both the repressor and CAP/cAMP.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | States that with both glucose and lactose present, the lac operon is transcribed at a low level (not fully off, not fully high). | Full 'off' or full 'high' without qualification should not earn this criterion. |
| `C2` | Explains that lactose (via allolactose) binds and inactivates the lac repressor, removing repression of the operon, while low cAMP (because glucose is present) means CAP is not bound/active at the promoter, so RNA polymerase binding is not strongly enhanced. | Both halves (repressor inactivated by lactose AND CAP not active due to glucose) are needed for full credit. |
| `C3` | Explains that removing glucose raises cAMP levels, allowing CAP-cAMP to bind the promoter region and enhance RNA polymerase binding/transcription. | Must connect glucose removal to rising cAMP to CAP activation, not just assert 'transcription goes up.' |
| `C4` | Concludes that with lactose present and glucose absent, the operon is transcribed at a high level, because the repressor remains inactivated by lactose and CAP-cAMP is now active, both promoting transcription. | Requires the combined effect of both regulatory elements pointing the same direction (high transcription), not just one. |

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
(A) With both glucose and lactose present, the lac operon is transcribed at a low level. Lactose is converted to allolactose, which binds the lac repressor and inactivates it, so the repressor is not blocking transcription. However, glucose being present keeps cAMP levels low, so CAP is not bound to the promoter and cannot enhance RNA polymerase binding, keeping transcription at a baseline low level rather than a high level.

(B) Removing glucose causes cAMP levels to rise. Rising cAMP binds CAP, and the CAP-cAMP complex binds the promoter region, increasing RNA polymerase binding and boosting transcription. Since lactose is still present, the repressor remains inactivated. With both the repressor inactive and CAP-cAMP now active, the lac operon is transcribed at a high level.
```

#### R2

```text
(A) The lac operon is completely off when both sugars are present, because the cell prefers glucose and shuts down the lactose genes entirely.

(B) When glucose is removed, the operon turns on because now the cell needs to use lactose for energy.
```

#### R3

```text
(A) The operon is transcribed at a low level because lactose inactivates the repressor but glucose being present means CAP isn't very active.

(B) Removing glucose lets CAP become active, which increases transcription.
```

#### R4

```text
(A) Lac operon transcription is low with both sugars present: lactose/allolactose inactivates the repressor, removing that block, but low cAMP while glucose is present means CAP-cAMP isn't bound at the promoter, so RNA polymerase binding isn't strongly enhanced.

(B) Without glucose, cAMP rises and binds CAP, and CAP-cAMP binds the promoter to boost RNA polymerase activity. Because lactose is still present, the repressor stays off the operator. With the repressor inactive and CAP-cAMP now enhancing transcription, the operon reaches a high level of transcription.
```

#### R5

```text
(A) The operon is at a moderate level because both sugars are present and they balance each other out.

(B) When glucose disappears, cAMP goes up and CAP binds the promoter, so transcription increases to a high level, and lactose is still around so the repressor also stays inactive.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response correctly distinguishing the low-transcription (both sugars present) state from the high-transcription (lactose only) state, with both repressor and CAP/cAMP mechanisms explained in each part. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Claims the operon is 'completely off' with both sugars present, but lactose is still present and inactivates the repressor, so transcription is low, not zero. Neither part mentions the repressor or CAP/cAMP mechanism at all -- 'the cell prefers glucose' and 'the cell needs energy' are teleological restatements, not mechanisms. Flags: invented biology (operon fully off), mechanism omitted. |
| `R3` | earned | earned | earned | not_earned | Parts A and the first half of B correctly cover the repressor and CAP mechanisms, but part B never states the resulting transcription *level* (high) or reconnects it to the repressor still being inactivated by lactose -- it only says transcription 'increases' without characterizing the resulting state relative to (A)'s baseline. Flags: over-credit risk if grader treats 'increases' as equivalent to the specific high-level conclusion required by C4. |
| `R4` | earned | earned | earned | earned | Second full-credit response with equivalent phrasing to R1, useful for confirming grader consistency across near-duplicate high-quality answers. |
| `R5` | not_earned | not_earned | earned | earned | Part A's 'balance each other out' framing does not correctly characterize the low-transcription state or explain either the repressor or CAP mechanism -- it is a vague restatement rather than a mechanism, so C1/C2 are not earned. Part B, however, independently and correctly explains both the CAP/cAMP rise and the repressor remaining inactive, earning C3/C4 despite the weak first half. Illustrates that criteria for (A) and (B) should be scored independently rather than assuming a weak (A) implies a weak (B). |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `invented_biology`, `mechanism_omitted`
- `R3`: `over_credit_risk`, `rubric_ambiguity`
- `R4`: (none)
- `R5`: `rubric_ambiguity`, `vague_generality`
