# Spike Input Packet -- Blocking a Downstream Kinase in a GPCR Signaling Cascade

**Subject:** AP Biology
**Answer type:** Text FRQ
**Unit:** Unit 4 - Cell Communication and Cell Cycle
**Difficulty:** Hard
**Content type:** boundary-sensitive
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A hormone binds a G-protein-coupled receptor (GPCR) on the surface of a target cell, triggering a signal transduction cascade that activates protein kinase A (PKA), which phosphorylates a transcription factor needed to turn on a target gene. A researcher adds a drug that specifically blocks PKA's kinase activity, without affecting the GPCR, G-protein, or second messenger production.

**A.** Describe how binding of the hormone to the GPCR ultimately leads to activation of PKA, including the role of the G-protein and second messenger.

**B.** Predict the effect of the PKA-blocking drug on target gene transcription in the presence of hormone, and explain why steps upstream of PKA still occur normally.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Describes that hormone binding causes a conformational change in the GPCR, which activates an associated G-protein (e.g., exchanging GDP for GTP). | Accept general G-protein activation language without requiring GDP/GTP detail by name, but conformational change + G-protein activation must both appear. |
| `C2` | Explains that the activated G-protein activates an enzyme (e.g., adenylyl cyclase) that produces a second messenger (e.g., cAMP). | Naming cAMP/adenylyl cyclase specifically is preferred but general 'second messenger produced' language is acceptable if the enzyme-activation step is present. |
| `C3` | Explains that the second messenger activates PKA, and predicts that target gene transcription will not occur (or will be blocked) because the drug prevents PKA from phosphorylating the transcription factor. | Must state transcription is blocked specifically due to the phosphorylation step failing, not just 'signaling stops.' |
| `C4` | Explains that the upstream steps (GPCR activation, G-protein activation, second messenger production) do not require PKA activity to occur, so they still happen normally -- the block is specific to the one downstream step where PKA acts on the transcription factor. | This tests whether the response understands the drug acts at one specific point in the cascade rather than shutting down the whole pathway. |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 1 |
| `R3` | 4 |
| `R4` | 3 |
| `R5` | 2 |

#### R1

```text
(A) Hormone binding causes a conformational change in the GPCR, which activates an associated G-protein by causing it to exchange GDP for GTP. The activated G-protein then activates an enzyme such as adenylyl cyclase, which converts ATP into the second messenger cAMP. Rising cAMP levels bind to and activate PKA.

(B) Prediction: target gene transcription will not occur, because although PKA is activated by cAMP, the drug blocks its kinase activity, so it cannot phosphorylate the transcription factor needed to turn on the gene. The steps upstream of PKA -- GPCR activation, G-protein activation, and cAMP production -- still occur normally because none of those steps require PKA's kinase activity; the drug only interferes with the one specific step where PKA acts on its target, not the earlier parts of the cascade.
```

#### R2

```text
(A) The hormone enters the cell and directly turns on PKA.

(B) Since PKA is blocked, none of the signaling happens at all -- the GPCR, G-protein, and second messenger steps also stop because the whole pathway shuts down.
```

#### R3

```text
(A) The GPCR activates a G-protein, which leads to production of a second messenger that activates PKA.

(B) Target gene transcription won't happen because PKA can't do its job. Everything before that step still happens normally.
```

#### R4

```text
(A) Hormone binding activates the GPCR, which activates a G-protein, which produces a second messenger that activates PKA.

(B) Since PKA can't phosphorylate the transcription factor, transcription is blocked. The second messenger also stops being made once PKA is blocked, since PKA blocking disrupts the whole cascade upstream of it too.
```

#### R5

```text
(A) The hormone binds the GPCR, activating a G-protein that triggers second messenger production, which activates PKA to phosphorylate transcription factors.

(B) Transcription will decrease somewhat because signaling is disrupted, but some transcription may still occur through backup pathways.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response tracing the entire cascade correctly and explicitly explaining why the block is localized to one step rather than the whole pathway. |
| `R2` | not_earned | not_earned | earned | not_earned | Part A skips the entire GPCR/G-protein/second-messenger cascade and incorrectly has the hormone entering the cell (GPCR ligands for this type of receptor act at the surface). Part B correctly predicts transcription is blocked, but incorrectly claims the entire upstream pathway also stops -- this is the key misconception the item is designed to catch (treating a downstream block as if it shuts down the whole cascade). Flags: invented biology (hormone entering cell), mechanism omitted, downstream-block-treated-as-whole-pathway-block misconception. |
| `R3` | earned | earned | earned | earned | Full-credit at a more general level of detail than R1 -- doesn't name GTP exchange, adenylyl cyclase, or cAMP specifically, but the rubric notes allow general language for C1/C2, and C3/C4 are both clearly and correctly stated. Useful for calibrating how much specificity is actually required versus preferred. |
| `R4` | earned | earned | earned | not_earned | Parts A and the first sentence of B are correct, but the response then incorrectly claims second-messenger production stops because of the PKA block -- inventing feedback that reverses causality (a downstream block does not stop an upstream step). Flags: invented biology, downstream-to-upstream causality reversal; a subtler version of R2's whole-pathway misconception limited to just one upstream step instead of all of them. |
| `R5` | earned | earned | not_earned | unable_to_determine | Part A is fully correct. Part B hedges into an unsupported 'backup pathways' claim not established by the prompt, and never clearly states that transcription is blocked because the phosphorylation step specifically fails -- 'decrease somewhat' is vaguer than the rubric's required 'blocked' conclusion. Because the response never actually addresses the upstream-steps-still-occur point directly, C4 is flagged unable_to_determine rather than scored as earned or not; reviewer should decide whether the silence on upstream steps defaults to not_earned. Flags: unsupported inference, vague generality. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `invented_biology`, `downstream_block_treated_as_whole_pathway_block`
- `R3`: (none)
- `R4`: `invented_biology`, `downstream_block_treated_as_whole_pathway_block`
- `R5`: `unsupported_inference`, `vague_generality`, `rubric_ambiguity`
