# AP Biology units 1-5: structured explainers (recommendation #3), 2026-11-13

## What changed
33 published rows in `app.topic_explainers` (subject_key `ap_biology`, units 1-5) had four fields reshaped: `core_idea` and `what_students_need_to_understand` into 2-3 "- " bullets, `how_this_becomes_points` into numbered steps, `point_attaining_answer` into short paragraphs, small tables (where the original had parallel values) or numbered steps (for a real chain). Text markers only, no schema change. Facts, numbers, named terms and exam-scope warnings kept; caps 360/360/320/520 respected (validator clean).

Files: `current.json` (Dev rows, = fetch.sql), `proposed_u1..u5.json`, `proposed_all.json`, `migration.sql`, `RULINGS.md`, `check_out/` (first pass), `check_ctl/` (control, partial), `check_re/`, `check_re55/`, `verify.sql`.

## Words (four fields)
| Unit | Before | After |
|---|---|---|
| 1 | 1566 | 1362 |
| 2 | 2247 | 1883 |
| 3 | 1156 | 980 |
| 4 | 1294 | 1160 |
| 5 | 380 | 417 |
| Total | 6643 | 5802 |

Unit 5 grew slightly: its current text is short templated sentences (and an answer that repeated the "You earn points by..." line), so reshaping adds marker overhead. Its bullets are the original sentences split in two; there is little content to structure.

## Models and spend
Authored by Claude in session, no gateway authoring. Checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro (5 topics per call). Largest single call about $0.08 (kimi). First pass about $0.47; control and a full re-pass about $0.5 each (re-pass over everything was more than needed); 5.5 re-check $0.014. Total roughly $1.5, approximate because only the first pass was logged. Gateway balance after: $29.59 (shared with other sessions).

## Control
Planted change in 2.8 (3 positive charges -> 10): flagged by both models.

## Rulings summary
2 real defects (2.5 lost "large molecules or particles"; 5.5 genotype/environment interaction split), both fixed and re-checked clean. 17 sol "no table separator row" findings ruled not a defect (renderer convention). See RULINGS.md.

## Dev verification
Migration applied to Development (wmgjsdkphcyhngaffbqf) only, transactional, md5-guarded, raise on wrong count: succeeded. Post-check SELECT: 33 rows, md5 of the four fields joined with '|' equals the md5 computed in Python from proposed_all.json for all 33, and exactly 33 rows carry the source_note sentence.

## NOT done
- Production not touched (David to confirm Prod rows match current.json hashes first; the guard will refuse otherwise).
- No Lovable publish; the renderer reading the markers is assumed from the Statistics and Chemistry 1.5 precedent, not re-tested on Biology.
- No human review; models never saw the rendered page. Table cells in 1.7, 2.3, 2.4, 2.10, 3.2, 4.x were condensed and are the likeliest places for subtle wording drift a model could miss.
