# AP Statistics structured explainers, units 1-5 (recommendation #3), 2026-11-13

## What changed
For all 55 published AP Statistics rows in app.topic_explainers (3.1-5.5 authored in session by Claude; units 1-2 authored earlier), four text fields were reshaped using text markers only (no schema change):
core_idea and what_students_need_to_understand into 2-3 "- " bullets, how_this_becomes_points into numbered steps, and point_attaining_answer into short paragraphs, with a small table where the original had parallel values (3.2, 3.8, 3.9, 3.13, 4.6, 5.1 and the unit 1-2 tables). No facts were intentionally changed.
Files: current.json, proposed_u1..u5.json, proposed_all.json (55 topics), migration.sql, RULINGS.md, check_out*/ (raw checker output).

## Words (sum over the four fields; table pipes not counted)
| Unit | Before | After |
|---|---|---|
| 1 | 2321 | 2124 |
| 2 | 2766 | 2295 |
| 3 | 3396 | 2924 |
| 4 | 1547 | 1509 |
| 5 | 726 | 717 |
| Total | 10756 | 9569 |

## Checking
Models: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro (all 55 topics, 5 per call). Findings: 9 (all gpt-6.1-sol, all the missing Markdown table separator row), 0 from kimi. All 9 ruled not a defect (see RULINGS.md). One further real defect (2.12 lost "or description") was found by kimi on a re-check after a cap trim, fixed, and re-checked clean by both models.
Planted-defect control (changed number in 2.9): both models flagged 2.9.
Gateway cost: per-call market_cost summed to roughly $1.6 across the full run, control and re-checks (largest single call about $0.074). The credits balance fell from 16.15 to 11.12 over the session (about $5), more than the summed call costs; part of that may be other usage on the same key. Balance stayed above $5.

## Dev verification
migration.sql applied to Development only (project ref wmgjsdkphcyhngaffbqf, CLI pinned with --workdir to the Dev-linked checkout); it is guarded on each row's md5 and succeeded without raising. Independent SELECT afterwards: 55 published rows, 55 of 55 md5 of the four fields (joined with '|') equal the md5 computed from proposed_all.json, and 55 rows have source_note like '%Structured 2026-11-13%'.

## Not done
- Production not touched (no approval, no apply). Prod guard hashes may differ from Dev's current.json if Prod rows differ; current.json is Dev's read, so a Prod run needs its own guard check.
- Lovable publish / rendering not verified: whether the live renderer shows tables with no separator row, and how it renders the new layout, is unchecked.
- No human review of the reshaped text; only two model checkers plus Claude's arbitration.
- The two checkers share a blind spot risk: kimi returned zero findings on the first pass, and only the re-check of 2.12 caught the lost "or description", so subtle lost-content defects elsewhere cannot be ruled out.
