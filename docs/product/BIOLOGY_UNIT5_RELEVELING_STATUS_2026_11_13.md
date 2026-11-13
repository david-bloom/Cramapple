# AP Biology Unit 5 Heredity — topic release status (2026-11-13)

David directed Biology Unit 5 authoring and Production publication topic by topic after the approved two-model checks, without another permission request. This follows his instruction to move from Calculus to Biology and supersedes the old handoff's stop-before-Production sentence for this named batch. The one-time exception to the four-checker/planted-control protocol applies. Model tiers are uncalibrated triage judgments; no subject-expert review is claimed.

Production project `pcntajvbdfqhbeewmdry`, served AP Biology pack `2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`, taxonomy source version `c676d1fc-3b58-4896-89e3-852d9bd1f81b`. The 2025 College Board AP Biology CED and live taxonomy map Unit 5 to 5.1 Meiosis, 5.2 Meiosis and Genetic Diversity, 5.3 Mendelian Genetics, 5.4 Non-Mendelian Genetics, and 5.5 Environmental Effects on Phenotype. The existing validated 5.1 label requires units `[4,5]`; the new 5.1 items use that conservative mapping. The 5.4 validated labels require `[5]`; the remaining topics map to Unit 5 in the taxonomy and CED.

## Before audit

Read-only Production audit on 2026-11-13: `python3 -u scripts/difficulty-audit/audit.py --subject 'AP Biology' --units 5 --workers 4 --out /private/tmp/cramapple-bio-u5-before --workdir /private/tmp/cramapple-unit5-calculus`. The workdir was pinned to the Production-linked worktree. Zero R1 families were found. The five served-pack MCQs and valid serving labels were independently counted in Production.

| Topic | Published / valid-serving | R1 | R2 | R3 | R1 families |
|---|---:|---:|---:|---:|---:|
| 5.1 | 1 / 1 | 0 | 1 | 0 | 0 |
| 5.2 | 0 / 0 | 0 | 0 | 0 | 0 |
| 5.3 | 0 / 0 | 0 | 0 | 0 | 0 |
| 5.4 | 4 / 4 | 0 | 3 | 1 | 0 |
| 5.5 | 0 / 0 | 0 | 0 | 0 | 0 |
| **Total** | **5 / 5** | **0** | **4** | **1** | **0** |

## Topic 5.1 — Meiosis

Concrete package: `scripts/content-seed/apbio-harder-seeds-u5-t5_1-2026-11-13/`, prefix `apbio-mcq-b1` (zero existing Production keys). Three new families with three variants each cover meiotic stage inference, chromosome/chromatid counts, and comparison with mitosis. The author checked each chromosome count, division sequence, key, and distractor rationale against the stem. Existing `APBIO-MCQ-043` is retained; it was rated R2 and is the only old topic 5.1 item. No retirement is proposed.

The draft validator passed 12 items and the builder made two chunks. DeepSeek and Kimi blind solves each agreed with 12/12 keys. Both tier models returned all 12 ratings: zero R1, eleven R2, one R3; zero duplicate or disputed-key flags. Five items had R2/R3 model disagreement and are reported conservatively as R2. The R3 is seed A; seeds B and C and all nine variants are R2. Cross-family and retained-old stem similarity over 0.80: zero. The variants change the observed stage, measurement, or experimental comparison; count examples share the same underlying counting skill but test different stages.

| State | R1 seed / variant | R2 seed / variant | R3 seed / variant | Published / valid-serving |
|---|---:|---:|---:|---:|
| Retained old | 0 / 0 | 1 / 0 | 0 / 0 | 1 / 1 |
| New package | 0 / 0 | 2 / 9 | 1 / 0 | 12 / 12 expected |
| After release | 0 / 0 | 3 / 9 | 1 / 0 | 13 / 13 expected |

**Execution state:** Prepared under `APPROVAL-0272`; update after Production write.
