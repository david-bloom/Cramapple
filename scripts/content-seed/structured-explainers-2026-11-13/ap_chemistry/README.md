# AP Chemistry units 1-5 (except 1.5): structured pieces, 2026-11-13

Recommendation #3 (bullets, numbered steps and small tables instead of paragraphs), applied to 47 published AP Chemistry explainer rows. Topic 1.5 was done earlier and is not touched.

## What changed
Four text fields per topic (core_idea, what_students_need_to_understand, how_this_becomes_points, point_attaining_answer), reshaped with text markers inside the existing columns: "- " bullets, "1. " steps, "| a | b |" tables (first row header). No schema change, no facts added or removed except as noted in RULINGS.md. Authored by Claude in session; the gateway only checked. Source of CURRENT: Development rows (current.json, 47 rows, 7/7/13/9/11 for units 1-5). Unit 2 was already in its 2026-10-31 rewritten form on Development. Tables use only values from the original answer or the topic's mini_example_question.

Files: current.json, u1-u5.txt (authoring source), proposed_u1..u5.json, proposed_all.json, RULINGS.md, migration.sql, check_out/ (raw checker output), recheck_out/, control_out/, verify.sql.

## Word counts (four fields; tables counted without pipes)
| Unit | Topics | Before | After |
|---|---|---|---|
| 1 | 7 | 1487 | 1298 |
| 2 | 7 | 1442 | 1386 |
| 3 | 13 | 3165 | 2370 |
| 4 | 9 | 1053 | 1045 |
| 5 | 11 | 1227 | 1232 |
| Total | 47 | 8374 | 7331 |

Unit 3 shrank most (about 25 percent) because its originals were long and had to meet the character caps; the checkers found five places where that cost content, all restored (RULINGS.md).

## Checks
- tools.py validate: all 47 within caps, no marker problems.
- Models: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, 47 topics in batches of 5, plus a recheck of the 6 edited topics and one planted-defect control.
- Findings: 5 real lost-content defects (1.2, 3.1, 3.3, 3.5, 3.8) fixed and rechecked; kimi passed all rechecked topics. sol's only remaining findings on recheck are the rejected "no separator row" markup complaint. 1.7 suggestion applied (exclusion qualifiers).
- Control: planted number change in 3.4 flagged by both models.
- Gateway spend by this run: about $1.02 (sol about $0.15, kimi about $0.87); no call above $0.15. Balance read at start $15.40 and at the end $29.52 (top-up or other sessions' use is not attributable to this run).

## Development
migration.sql applied to Development (project wmgjsdkphcyhngaffbqf) only: transactional, per-row md5 guard, count guard. The first attempt crashed on a CLI telemetry-file error and changed nothing (verified 0 rows changed); the second applied cleanly. Verified with a SELECT: all 47 rows' four-field md5 equals the Python md5 of proposed_all.json, and 47 of 47 carry the source_note sentence.

## NOT done
- Production: not touched. No approval record, no Production migration.
- Lovable publish / frontend: not done; whether the renderer shows these markers on these fields in the live app was not re-tested here (1.5 is already live with the same conventions).
- No human review. Only two model checkers plus Claude's own arbitration. The checkers see the CURRENT text as truth; they cannot catch an error that was already in CURRENT.
- Not an ongoing check that the first-round gpt/kimi pass of topics not edited after the check is still valid (only the edited topics were rechecked).
