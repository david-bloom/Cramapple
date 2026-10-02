# Chemistry Units 1-3: full pipeline run, 2026-10-02 (time, cost, tokens from scratch)

Scope: AP Chemistry, Units 1-3. Chemistry had 119 live items (68 MCQ, 51 FRQ), no topic cells, no skill grid, no variants, 40 items with no unit, 25 stale hashes.
A blind three-family probe over all 119 items put **37 items in Units 1-3** (25 MCQ, 12 FRQ). Everything below is for those 37 and their 25 MCQ seeds.

## Measured cost (raw: METRICS_RAW.log, COST_BY_STAGE.json, cost.py)
| Resource | Amount |
|---|---|
| Wall clock (log span, includes waiting on jobs and agents) | **86 min** |
| Gateway calls / tokens | 2,040 calls; 3.19M input, 2.00M output |
| Gateway list price (floor: no DeepSeek peak 2x, no Gemini long-context tier) | **$7.55** |
| Subagent tokens (6 agents: 1 fetch + 5 authors) | 691,431 |
| My own context tokens (counter 15,000,000 to 14,785,045) | about 215,000 |
| Claude tokens priced at Sonnet 5.5 list ($2 in / $10 out per M), bounded | $2 (all input) to $9 (all output) |
| **Estimated total** | **about $10 to $17** |

| Step | Clock | Gateway $ | Notes |
|---|---|---|---|
| 1 live set + packets | 1.5 min | 0 | 1 read-only agent, 96,548 tokens |
| 3 topic+unit probe (all 119 items; scopes the run) | 17 min | 1.99 | 714 calls; DeepSeek is the slow model |
| 2 content integrity, 25 MCQs (solve + audit + patched recheck) | 12.7 min | 0.49 | 6 real defects of 25 |
| 3+4 topic cells + serving labels | 1.7 min | 0 | 36 topic cells from zero; 37 labels; fixed 2 duplicate active labels |
| 5 grid | 0.6 min | 0 | 28 skills, 136 cells (practice-aligned) |
| 6 skill labels, 4 voters | 1.7 min | 1.21 | 30 validated, 4 provisional, 2 none |
| 7 variants, 75 drafts | 49.5 min | 4.07 | authoring 5 min (5 parallel agents, 594,883 tokens), checks about 26 min wall, 3 patch rounds |

## What each step found
- Step 2: 6 of 25 seeds (24%) had a real defect (one key-level: `037` had two correct answers), caught by two models and verified by hand. A further 2 (`025`, `027`) were missed by the audit and found by the variant author (so audit recall is about 75%). No stored key was wrong. DeepSeek raised 2 false positives (`032`, `038`).
- Gap: the CED scope check was never run on the seeds. Run afterwards: seed `007` (gas solubility vs temperature and pressure) is flagged by both models, and I read seed `028` (electron-domain geometry for SF4) as violating the CED line on more than four pairs. Neither was changed.
- Step 3: Chemistry had no topic cells at all. 107 of 115 consensus items agreed on topic at >= 5/6; existing unit labels agreed with the consensus on 69 of 73.
- Step 6: constraining candidates to the topic's aligned practice raised agreement a lot (25 of 36 unanimous, versus Bio's 46 of 117).
- Step 7: 21 variants were patched after the first audit: 15 stale embedded A-D lists (artifact of my letter shuffle; the batch-2 agent had reported none), 9 hand-verified content defects (wrong 1/sqrt(m), a 1 + 8 = 10, an intensity claim, a missing diagram, and others), 1 length-parity defect. 2 variants were reworded for the CED line on >4 electron pairs. 3 variants (`007`) held out. CED check on variants: 9 flagged, 4 of them dispositioned.
- Label inheritance on variants: 75 of 75 for unit and topic.

## Not done / needs a decision
- The 72 variants are NOT loaded. Loading and publishing needs its own approval.
- Seeds `007` and `028` (scope), 49 of 68 Chemistry MCQs have no `canonical_answer_1` (grading reads `is_correct`, so low risk), 20 stale hashes outside Units 1-3, 14 FRQs in scope were not audited (rubric audit is not part of S0a), FRQ variants not authored.
