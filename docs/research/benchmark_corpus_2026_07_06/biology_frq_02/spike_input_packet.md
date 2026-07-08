# Spike Input Packet -- A CDK Inhibitor and the G1/S Checkpoint

**Subject:** AP Biology
**Answer type:** Text FRQ
**Unit:** Unit 4 - Cell Communication and Cell Cycle
**Difficulty:** Medium
**Content type:** mechanism-heavy
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

A drug inhibits cyclin-dependent kinase (CDK) activity in cultured human cells. Treated cells accumulate in the G1 phase of the cell cycle and do not progress to S phase, even though nutrients and growth signals are present.

**A.** Describe how cyclin-CDK complexes normally regulate passage through the G1 checkpoint.

**B.** Explain why inhibiting CDK activity causes cells to arrest in G1 rather than progressing to S phase.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Describes that cyclin binds CDK to form an active cyclin-CDK complex. | Accept 'cyclin activates CDK' as equivalent. |
| `C2` | Explains that the active cyclin-CDK complex phosphorylates target proteins (e.g., Rb) needed to pass the G1 checkpoint. | Naming Rb specifically is not required; 'phosphorylates checkpoint target proteins' is sufficient. |
| `C3` | Explains that phosphorylation of these targets normally releases transcription factors (e.g., E2F) that allow expression of S-phase genes / entry into S phase. | Accept general 'triggers genes needed for DNA replication/S phase' language. |
| `C4` | Connects CDK inhibition to arrest by explaining that without CDK activity, target proteins remain unphosphorylated, checkpoint proteins keep blocking the pathway, and the cell cannot pass into S phase regardless of external growth signals. | Must explicitly link the missing phosphorylation step to the arrest, not just restate 'CDK is blocked so the cycle stops.' |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 2 |
| `R4` | 2 |
| `R5` | 2 |
| `R6` | 3 |

#### R1

```text
(A) Cyclin proteins bind to and activate CDK, forming a cyclin-CDK complex. This active complex phosphorylates checkpoint target proteins such as Rb, which releases transcription factors like E2F that turn on genes needed for DNA replication, allowing the cell to pass the G1 checkpoint into S phase.

(B) Without CDK activity, the cyclin-CDK complex cannot form an active kinase, so Rb (or equivalent checkpoint proteins) is never phosphorylated. Unphosphorylated Rb continues to hold E2F inactive, so S-phase genes are never turned on. The cell therefore arrests in G1 even with growth signals present, because the checkpoint block was never removed.
```

#### R2

```text
(A) CDK makes cyclin, and together they check if the cell is big enough to divide.

(B) The drug stops CDK from making cyclin, so the cell doesn't know it's ready and stays in G1.
```

#### R3

```text
(A) Cyclin binds CDK to activate it. The active complex phosphorylates target proteins that let the cell move into S phase.

(B) Without CDK, the checkpoint stays closed and the cell can't move to S phase.
```

#### R4

```text
(A) Cyclin-CDK complexes phosphorylate Rb, which releases E2F to turn on genes needed for S phase.

(B) Since the drug inhibits CDK, cyclin can't bind to it anymore, so no complex ever forms and the checkpoint can't be passed.
```

#### R5

```text
(A) Cyclin binds CDK, forming an active complex that phosphorylates checkpoint proteins so the cell can enter S phase.

(B) The cell arrests in G1 because CDK is inhibited, so the checkpoint doesn't pass.
```

#### R6

```text
(A) Active cyclin-CDK phosphorylates Rb, releasing E2F, which activates transcription of genes required for DNA replication and S-phase entry.

(B) If CDK is inhibited, Rb is never phosphorylated, so it continues binding and inactivating E2F. Without free E2F, S-phase genes are never transcribed, so the cell cannot leave G1 even though external growth signals are present.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with the complete cyclin-CDK-Rb-E2F chain and an explicit link between missing phosphorylation and continued arrest. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Reverses the cyclin-CDK relationship (CDK does not make cyclin) and never describes phosphorylation of any checkpoint target. 'Checks if the cell is big enough' is a vague restatement of 'checkpoint' rather than a mechanism. Flags: invented biology, mechanism omitted entirely. |
| `R3` | earned | earned | not_earned | not_earned | C1 and C2 are earned in general terms, but (A) never names or describes what the phosphorylation releases (E2F / S-phase gene expression), so C3 is not earned. (B) restates 'checkpoint stays closed' without tying it back to the missing phosphorylation step from (A), so C4 is not earned either. Flags: over-credit risk if grader assumes C3 is implied by C2. |
| `R4` | not_earned | earned | earned | not_earned | Part A skips describing complex formation itself (jumps straight to phosphorylation), so C1 is not clearly earned, though C2/C3 are described well. Part B invents an incorrect mechanism -- CDK inhibitors typically block kinase activity, not cyclin binding -- so the arrest explanation is built on an unsupported claim. Flags: invented biology in the inhibition mechanism, C1 boundary case (implied but not stated). |
| `R5` | earned | earned | not_earned | not_earned | Same shape as R3 -- correct on complex formation and phosphorylation in general, but part A never states what phosphorylation releases (E2F/S-phase genes), and part B just restates the observation in the prompt ('CDK is inhibited so the checkpoint doesn't pass') without tracing the missing-phosphorylation link. Useful paired example with R3 for calibrating the C3/C4 boundary. |
| `R6` | unable_to_determine | earned | earned | earned | B, C, D of the chain are fully and precisely described. However, (A) never explicitly states that cyclin *binds* CDK to activate it -- it starts from 'active cyclin-CDK' as a given. Reviewer should decide whether starting from the already-formed complex still earns C1, or whether binding must be stated explicitly; flagged unable_to_determine pending that call rather than assumed earned. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `invented_biology`, `mechanism_omitted`
- `R3`: `over_credit_risk`, `justification_restates_prompt`
- `R4`: `invented_biology`, `rubric_ambiguity`
- `R5`: `under_credit_risk_if_merged_with_R3`, `justification_restates_prompt`
- `R6`: `rubric_ambiguity`
