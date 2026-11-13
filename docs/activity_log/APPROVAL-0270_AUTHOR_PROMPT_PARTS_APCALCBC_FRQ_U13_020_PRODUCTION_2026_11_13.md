# APPROVAL-0270 — Author the missing prompt parts of `apcalcbc-frq-u13-020`, publish, and label it (2026-11-13)

- **Date:** 2026-11-13.
- **Authorization:** David Bloom (Product Owner), in chat: "Author prompt" (answering the question whether to author the missing prompt of `apcalcbc-frq-u13-020` or retire it). Follows APPROVAL-0269, which excluded this item.
- **What is written (Production `pcntajvbdfqhbeewmdry`):** one new published version (version 3) of `apcalcbc-frq-u13-020` whose `prompt_json` now has three parts authored from the surviving rubric criteria: (a) show dy/dx = -(2x+y)/(x+2y) and evaluate at (1, 2) [2 points]; (b) find d²y/dx² at (1, 2) [3]; (c) say whether the curve is concave up or down near (1, 2) and justify using part (b) [2]. Stem, stimulus (x^2 + xy + y^2 = 7, point (1, 2)) and all seven criteria unchanged; total stays 7. Old version retired, difficulty row copied. Then one validated primary topic cell and one validated, hash-fresh serving label (the old held label superseded).
- **Label result and a flag for the owner:** the blind six-vote probe on the new prompt gave topic **5.12 Exploring Behaviors of Implicit Relations** at 5 of 6 (one vote 3.2), required units [2, 3, 5]. Part (c) (concavity) is what the CED files under Unit 5, so the item is now served from Unit 5, not Unit 3 as its old metadata said. Its `prompt_json` unit/topic are set to 5 / 5.12 to match.
- **Checks before writing:** rubric preflight by GPT-6.1 Sol, DeepSeek V4 Pro and Gemini 3.8 Flash, all pass; all three recomputed y' = -4/5 and y'' = -42/125.
- **NOT changed:** any other item, any validated cell or label, schema, functions, migrations, edge functions, frontends.
- **Rollback:** set the new version to `retired` and the old version back to `published`; delete the cell/label rows tagged `rubric_preflight_repair_2026_11_13%` / `label_gap_fill_u1_5_r3_2026_11_13%` for this item.
- **Cost:** about $0.05 measured (vote $0.034, rubric check $0.019). Within the $3 cap with APPROVAL-0269 ($0.55 total).
- **Numbering check:** highest APPROVAL on origin/main, open PRs and all remote branches was 0269 (mine); this record takes 0270.
- **Rehearsal:** `REHEARSAL OK` (rolled back, constraints forced immediate).
- **Result:** see the execution record appended below.
