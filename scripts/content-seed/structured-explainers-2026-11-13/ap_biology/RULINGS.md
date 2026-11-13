# Rulings: AP Biology units 1-5 structured explainers (2026-11-13)

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, first pass over all 33 topics (check_out), re-pass over the final text (check_re) and 5.5 alone (check_re55). Arbitrated by Claude from the cited text.

| Topic | Field | Claim | Verdict | Reason |
|---|---|---|---|---|
| 2.5 | what_students_need_to_understand | Lost "bulk transport of large molecules or particles" (sol and kimi) | Real defect, fixed | CURRENT names large molecules or particles; the bullet had shortened it to "Bulk transport differs". Restored; re-pass clean. |
| 1.2, 1.4, 1.5, 1.7, 2.2, 2.3, 2.4, 2.8, 2.10, 3.1, 3.2, 4.1, 4.2, 4.4, 4.5, 4.6, 5.1 (17 topics, sol only, repeated in re-pass) | point_attaining_answer | Table has no `\| --- \|` header separator row | Not a defect, not counted | The renderer's marker convention (and the live Statistics and Chemistry 1.5 tables) is first row = header, no delimiter row. Adding one would render a literal row. |
| 5.5 (re-pass, kimi) | core_idea | Splitting "phenotype results from genotype interacting with environmental conditions" into two bullets made it read as genotype-only | Real meaning risk, fixed | Rewrote as "Phenotype results from genotype interacting with environmental conditions." plus "Genotype sets a potential, which the environment shifts." (the second line restates the original answer's "genotype potential ... environment shifts the phenotype"). Re-checked by both models: pass. |

Control: topic 2.8 answer had "3 positive charges" changed to 10. Both models flagged it (kimi: wrong stoichiometry; sol: number changed from 3 to 10, contradicts CURRENT and mini question). The control run was stopped after 4 kimi batches and all 7 sol batches (only batch 2 holds 2.8).

Validator note: `validate` prints "numbers only in PROPOSED: 1" on most topics. This is the "1." of the first numbered step in how_this_becomes_points (the numbered-step stripper anchors on line start and that step is mid-string after the join). No number was lost on any topic ("only in CURRENT" never fired).

Genuine count of factual/meaning/lost-content defects: 2 (2.5, 5.5), both fixed.
