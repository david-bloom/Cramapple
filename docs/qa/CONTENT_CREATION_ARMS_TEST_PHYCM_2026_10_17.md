# Content-creation test: cheaper/faster/better? (Physics C: Mechanics, 2026-10-17)

STATUS: results recorded; no content loaded to any database. Costs are estimates (tokens x Gateway list prices), not bills.
Plan as run (owner-approved): Arm A baseline on 15 Mechanics topics (10 empty + 5 thin), 2 slots each; Arm B dropped; Arm C replaced by a 200-seed helpability sample of the existing corpus; Arm D (cheaper checker profile) compared with A on A's own candidates under pre-registered one-sided exact tests (alpha 0.05, stop when all four significant). Tooling: `scripts/content-seed/arms-test-phycm-2026-10-17/`, `seed_pipeline.mjs --arm`, `run.mjs CHECKER_PROFILE=D`.

## Baseline (arm A, standard pipeline)
30 slots: 29 accepted, 46 candidates (13 rejected by checkers: 8 solve, 5 audit; 4 by the similarity gate). 516 calls, about $6.10, 20 minutes wall clock at 8 topics in parallel (about $0.21 per accepted seed). Cost split: audit 42%, authoring 25%, veto 13%, label votes 11%, solve 9%.

## Helpability of the existing corpus (stands in for arm C)
200 seeds, 10 subjects, real More help prompt + runtime check + up to 2 rewrites. 185 testable: 11 first drafts flagged (5.9%), all 11 repaired by one rewrite, 0 refused after rewrites (95% upper bound 1.6%). One item (Physics 2 `apphy2-mcq-007`) was refused by the older pattern checks at generation, which rewrites do not cover. 13 items had no reference facts (all units 4+). Cost about $0.23. Conclusion: no need for an authoring-time leak gate (arm C); the runtime loop holds.

## Arm D (cheaper evaluation profile) vs A, paired on A's 42 checked candidates (+14 planted defects)
D = gpt-6-luna, claude-haiku-5.5, gemini-3.8-flash, deepseek-v4-pro, qwen3.7-plus (replacing Meta).
| Test | Result | Significant? |
| --- | --- | --- |
| H1 cost | D $1.61 vs A $3.90 on the same candidates (D = 41% of A) | Yes, p < 0.001 |
| H2 time | summed call time D 115 min vs A 90 min (D slower) | No (reversed) |
| H3 detection of planted defects (> 80%) | 13 of 14 caught; missed a changed-number stem | No (p = 0.20) |
| H4 acceptance of A-accepted (> 75%) | 23 of 29 (79%) | No (p = 0.39) |
Also: D accepted 8 of the 13 candidates A rejected (D rejected 5 of 13), so on this evidence D is weaker at screening, not just cheaper. The 14 disagreements (6 + 8) were NOT adjudicated; without that, we cannot say who was right.
Latency: DeepSeek v4-pro, Meta and Qwen average 26-28 s per call; Opus, Haiku, Gemini Flash and GPT average 5-7 s. Parallel checkers wait for the slowest, so wall time per stage is about 27 s whichever profile is used; D also ran more calls because it passed more candidates deeper.

## Conclusions and caveats
Cost fell 59% on evaluation but safety is unproven; speed did not improve; B and C were not pursued. Small samples (planted n=14, A-accepted n=29); no human review; the planted set was designed after a first version was fully caught by deterministic lint.
