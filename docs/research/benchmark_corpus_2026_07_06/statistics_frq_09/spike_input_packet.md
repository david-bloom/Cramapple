# Spike Input Packet -- Confounding Variable in an Observational Study of Screen Time and Sleep

**Subject:** AP Statistics
**Answer type:** Text FRQ
**Unit:** Unit 3 - Collecting Data
**Difficulty:** Medium
**Content type:** reasoning
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt

An observational study finds that teenagers who report more daily screen time also report fewer hours of sleep per night. A news article concludes: 'Screen time causes reduced sleep in teenagers.' A student points out that teenagers with more after-school jobs and extracurricular commitments tend to have both more screen time (used for quick breaks between activities) and less sleep (due to a busier schedule overall).

**A.** Explain why this is an observational study rather than an experiment, and explain why that distinction matters for the news article's causal claim.

**B.** Explain how 'busyness from jobs and extracurriculars' could be a confounding variable in this study, and explain what the researcher would need to do to establish a cause-and-effect relationship instead.

## Draft Rubric Criteria

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Explains that this is an observational study because the researcher measured screen time and sleep as they naturally occurred, without randomly assigning teenagers to different screen-time levels. | Must reference the lack of random assignment/treatment imposition, not just 'they just observed data.' |
| `C2` | Explains that this distinction matters because observational studies can only establish association/correlation, not causation, since other variables may differ systematically between groups (unlike a randomized experiment, which balances lurking variables). | Must connect observational design to the causation-vs-association limitation directly. |
| `C3` | Explains that busyness is a confounding variable because it is associated with both the explanatory variable (screen time) and the response variable (sleep), and its effect on sleep cannot be separated from the effect of screen time on sleep using this data. | Must state both associations (with screen time AND with sleep) and the inability to separate their effects, not just 'it's related to both.' |
| `C4` | States that to establish a cause-and-effect relationship, the researcher would need to conduct a randomized experiment, randomly assigning teenagers to different screen-time conditions (levels), which would balance out busyness and other lurking variables between groups on average. | Must specifically name random assignment to treatment groups as the fix, not just 'do more research' or 'control for busyness statistically' without mentioning randomization. |

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
(A) This is an observational study because the researcher simply measured teenagers' existing screen time and sleep habits without randomly assigning any teenager to a particular screen-time level -- the teenagers' screen time was already whatever it was. This distinction matters because observational studies can only show that two variables are associated; they cannot establish that one causes the other, since without random assignment, other variables might differ systematically between high- and low-screen-time teenagers and could be responsible for the sleep difference instead.

(B) Busyness from jobs and extracurriculars could be a confounding variable because it is associated with both variables in the study: busier teenagers may use screens more for quick breaks (associated with screen time) and also sleep less overall due to a packed schedule (associated with sleep). Because busyness affects both variables, it's impossible to tell from this data whether screen time itself is reducing sleep, or whether busyness is driving both the screen time and the reduced sleep independently. To establish causation, the researcher would need to conduct a randomized experiment, randomly assigning teenagers to different fixed screen-time conditions; random assignment would tend to balance busyness and other lurking variables evenly across the groups, isolating the effect of screen time itself on sleep.
```

#### R2

```text
(A) This is an experiment because the researcher collected real data from real teenagers. This matters because real data is more trustworthy than made-up data.

(B) Busyness isn't really a confounding variable -- it's just another thing that happens to be true about busy teenagers. The researcher doesn't need to do anything differently; the original conclusion about screen time causing less sleep is fine.
```

#### R3

```text
(A) It's observational because no one was randomly assigned to a screen-time group. This means we can't say screen time causes less sleep.

(B) Busyness is a confounding variable because it's related to both things. To fix this, researchers should run an experiment.
```

#### R4

```text
(A) This is an observational study, not an experiment, because the researcher recorded teenagers' screen time and sleep as they naturally occurred rather than randomly assigning teenagers to specific screen-time levels. This matters because, without random assignment, other differences between high- and low-screen-time teenagers (besides screen time itself) could be responsible for the sleep difference, so only association -- not causation -- can be concluded.

(B) Busyness could be a confounding variable because busier teenagers may both use screens more (for short breaks between commitments) and sleep less (due to less free time overall), meaning busyness is linked to both the explanatory and response variables. This makes it impossible to separate whether screen time itself, or busyness, is actually responsible for the reduced sleep. To establish causation, the researcher would need to run a randomized experiment that randomly assigns teenagers to different screen-time levels, which would tend to distribute busy and non-busy teenagers evenly across groups and remove busyness as an alternative explanation.
```

#### R5

```text
(A) It's observational since nothing was randomly assigned. This matters because observational studies are less accurate than experiments.

(B) Busyness could explain both the screen time and the lack of sleep, so it's a confounding variable. The researcher should control for busyness by only studying teenagers who report the same busyness level, without needing to randomly assign anything.
```

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality. Contrast with the Bio reference packet, where an equivalent matrix was confirmed by Orly / Learning Quality before use.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct observational/experimental distinction, correct causation-limitation reasoning, correct confounding-variable explanation naming both associations, and the correct experimental fix (random assignment). |
| `R2` | not_earned | not_earned | not_earned | not_earned | Misidentifies the study as an experiment (using 'real data from real teenagers' as the criterion, which is not what distinguishes observational studies from experiments -- the presence or absence of random assignment is), and the reasoning about trustworthiness is unrelated to the causation-vs-association distinction. Then denies that busyness is a confounding variable at all and endorses the original causal claim without any correction. Flags: observational/experiment misclassification, confounding variable concept rejected, unsupported endorsement of causal claim. |
| `R3` | earned | earned | not_earned | not_earned | Parts (A) are both correctly reasoned. But (B) never explains *how* busyness is related to both variables (the specific mechanisms -- quick breaks and a packed schedule) or explains *why* that shared relationship prevents separating the effects, and 'run an experiment' doesn't specify random assignment as the actual mechanism that would fix the confounding. Flags: over-credit risk, confounding mechanism underexplained, fix underspecified (missing 'random assignment' specifically). |
| `R4` | earned | earned | earned | earned | Second full-credit response, closely paraphrasing R1 with equivalent completeness; confirms grader consistency. |
| `R5` | earned | not_earned | earned | not_earned | C1 and the confounding-variable explanation in (B) are correct. But (A)'s reasoning for why the distinction matters ('observational studies are less accurate') mischaracterizes the actual issue -- it's not about accuracy/precision, it's about the inability to establish causation without random assignment. Additionally, (B)'s proposed fix (restricting the sample to a single busyness level) is a form of statistical control, not random assignment, and while a legitimate design idea in principle, it does not match the criterion's required fix (a randomized experiment) and the response even explicitly rejects needing randomization. Flags: causation-limitation reasoning replaced by vague accuracy claim, fix does not use required randomization mechanism. |

## Boundary Tags Index

- `R1`: (none)
- `R2`: `study_design_misclassification`, `confounding_variable_concept_rejected`
- `R3`: `over_credit_risk`, `mechanism_omitted`, `fix_underspecified`
- `R4`: (none)
- `R5`: `vague_generality`, `fix_does_not_match_required_mechanism`
