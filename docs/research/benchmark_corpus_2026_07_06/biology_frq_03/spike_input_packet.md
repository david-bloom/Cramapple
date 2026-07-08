# Spike Input Packet -- Competitive vs. Noncompetitive Inhibition from Kinetics Data

**Subject:** AP Biology
**Answer type:** Text FRQ
**Unit:** Unit 3 - Cellular Energetics (Enzymes)
**Difficulty:** Medium
**Content type:** concept-heavy
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

An enzyme's reaction rate is measured across a range of substrate concentrations under three conditions: no inhibitor, Inhibitor X, and Inhibitor Y. Adding Inhibitor X raises the substrate concentration needed to reach half of Vmax but does not change Vmax itself. Adding Inhibitor Y lowers Vmax but does not change the substrate concentration needed to reach half of the (now lower) Vmax.

**A.** Identify which inhibitor (X or Y) is a competitive inhibitor and which is a noncompetitive inhibitor, and justify each identification using the data described.

**B.** Explain why increasing substrate concentration can overcome the effect of a competitive inhibitor but cannot overcome the effect of a noncompetitive inhibitor.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Identifies Inhibitor X as competitive. | Must be paired with correct data-based justification in C2 to earn full identification credit conceptually, but ID and justification are labeled separately. |
| `C2` | Justifies X as competitive using the data: unchanged Vmax with increased apparent Km (more substrate needed to reach half-Vmax) indicates competition at the active site. | Response should reference the Vmax-unchanged / Km-increased pattern, not just assert 'it competes.' |
| `C3` | Identifies Inhibitor Y as noncompetitive and justifies using the data: Vmax decreases while the substrate level needed to reach half of the new Vmax is unchanged, indicating the inhibitor acts at a site other than the active site. | Both ID and data justification bundled in this criterion for Y. |
| `C4` | Explains that excess substrate can out-compete a competitive inhibitor for the active site (restoring Vmax), but a noncompetitive inhibitor binds elsewhere and reduces functional enzyme regardless of substrate concentration, so adding substrate cannot restore Vmax. | Must address both halves (why competitive is overcome, why noncompetitive is not) for full credit. |

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 0 |
| `R3` | 1 |
| `R4` | 4 |
| `R5` | 2 |

#### R1

```text
(A) Inhibitor X is competitive: Vmax stays the same but more substrate is needed to reach half of Vmax, which means the inhibitor is competing with substrate for the active site rather than permanently blocking the enzyme. Inhibitor Y is noncompetitive: Vmax decreases, but the substrate level needed to reach half of that new (lower) Vmax is unchanged, which fits an inhibitor binding somewhere other than the active site and taking some enzyme out of action regardless of substrate levels.

(B) Adding more substrate increases the chance that substrate molecules occupy the active site instead of the competitive inhibitor, so at high enough substrate concentration the enzyme can still reach its normal Vmax. A noncompetitive inhibitor binds at a different site (often changing enzyme shape), so it doesn't matter how much substrate is present -- the affected enzyme molecules stay non-functional, permanently lowering Vmax.
```

#### R2

```text
(A) Inhibitor X is noncompetitive and Inhibitor Y is competitive, because X changes the shape of the enzyme and Y blocks the active site.

(B) More substrate can push past a competitive inhibitor because there's more of it, but noncompetitive inhibitors are stronger so substrate can't overcome them.
```

#### R3

```text
(A) Inhibitor X is competitive because Vmax is unchanged. Inhibitor Y is noncompetitive because Vmax decreases.

(B) Substrate can overcome a competitive inhibitor by outcompeting it, but it can't overcome a noncompetitive inhibitor.
```

#### R4

```text
(A) X is competitive -- more substrate is needed to reach half-Vmax while Vmax itself doesn't change, which fits competition for the active site. Y is noncompetitive -- Vmax drops, showing some enzyme is taken out of action no matter how much substrate is present, and since the half-Vmax substrate level relative to the new Vmax doesn't shift, the inhibitor isn't competing at the active site.

(B) Because X only slows the enzyme down by competing for the same site substrate uses, flooding the reaction with substrate molecules gives substrate the numeric advantage and lets the enzyme reach full speed again. Y's damage doesn't depend on the active site being occupied, so no amount of substrate changes how much active enzyme exists.
```

#### R5

```text
(A) Inhibitor X is competitive because it directly competes with the substrate; Inhibitor Y is noncompetitive because it does not compete with the substrate.

(B) A competitive inhibitor can be overcome with more substrate because there's a competition, and whoever has more numbers wins the active site. A noncompetitive inhibitor doesn't compete for the active site so more substrate doesn't help.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with data-grounded justification for both inhibitors and a complete explanation of why excess substrate rescues one but not the other. |
| `R2` | not_earned | not_earned | not_earned | not_earned | Swaps the identities of X and Y relative to the data (X is actually competitive based on unchanged Vmax/raised apparent Km). Justification in (A) asserts mechanism without citing the data at all, and (B) explains the difference via inhibitor 'strength' rather than binding site/site competition, which is not a supported mechanism. Flags: identity swap, invented mechanism, data not used. |
| `R3` | earned | not_earned | not_earned | not_earned | Correct identifications, but neither justification cites the full data pattern required (X: increased apparent Km specifically; Y: unchanged half-Vmax substrate level specifically) -- both are one-clause restatements of the ID. Part B restates the conclusion of C4 without any mechanism (no active-site competition, no alternate binding site). Flags: over-credit risk if grader accepts bare Vmax mention as sufficient data justification. |
| `R4` | earned | earned | earned | earned | Second full-credit response with different phrasing, useful for calibrating paraphrase tolerance on the Vmax/apparent-Km justification language. |
| `R5` | earned | not_earned | not_earned | earned | Correctly identifies X and part B's mechanism explanation is acceptable, but neither identification is justified using the actual Vmax/half-Vmax data from the prompt -- both restate the definition of 'competitive'/'noncompetitive' circularly ('competitive because it competes'). Flags: circular justification, data not cited; illustrates that C4 can be earned independent of C2/C3 when the general mechanism is right but the data-tie is missing. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `invented_biology`, `data_not_cited`
- `R3`: `over_credit_risk`, `justification_restates_prompt`
- `R4`: (none)
- `R5`: `data_not_cited`, `rubric_ambiguity`
