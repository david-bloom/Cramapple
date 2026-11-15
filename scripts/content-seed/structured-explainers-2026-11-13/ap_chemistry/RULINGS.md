# Rulings: AP Chemistry units 1-5 (except 1.5), structured pieces, 2026-11-13

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, 47 topics, raw output in check_out/. Each finding was re-derived from the CURRENT text (Development rows) and the PROPOSED text by Claude in session.

## Real defects (lost content), fixed by rewriting the field, then re-checked

| Topic | Field | Claim | Verdict | Reason |
|---|---|---|---|---|
| 1.2 | what_students_need_to_understand | Lost "This is how average atomic mass is actually measured, not memorized." | Real (sol) | Sentence was in CURRENT and absent. Restored as a first bullet. |
| 3.1 | core_idea | "Roughly weakest to strongest" became "Weak to strong"; "ion-dipole (ions with polar molecules)" lost its definition | Real (sol and kimi) | Both were in CURRENT. Restored "Roughly weakest to strongest" and "(ions with polar molecules)". |
| 3.3 | point_attaining_answer | Gas row lost "no fixed spacing or order" | Real (kimi) | CURRENT says gas has no fixed spacing or order, and the question asks for spacing, motion and order per phase. Added to the table row. |
| 3.5 | core_idea | Lost "speed-vs-fraction-of-particles" description of the Maxwell-Boltzmann curve | Real (sol), minor | In CURRENT. Restored. |
| 3.8 | core_idea | Lost "relative concentration or interaction type between two solutions" | Real (sol) | In CURRENT; I had kept only concentration. Restored. |

Net: 5 real topics-fields fixed (1.2, 3.1, 3.3, 3.5, 3.8). 3.1 was found by both models.

## Suggestions taken anyway (not counted as defects)

| Topic | Field | Claim | Verdict | Reason |
|---|---|---|---|---|
| 1.7 | core_idea | Exclusion scope shortened ("Excluded: ..." lost "from the AP Exam" and "wherever trends are tested") | Suggestion (kimi); fixed because the brief says exclusion statements must survive | Restored both qualifiers. The wording now says "aufbau-exception configurations (chromium, copper)" instead of "writing the electron configuration of an aufbau-exception element, such as chromium or copper"; the excluded topic is unchanged. |

## Rejected findings

| Topic | Field | Claim | Verdict | Reason |
|---|---|---|---|---|
| 1.2, 1.4, 1.6, 1.8, 2.1, 2.2, 2.4, 2.5, 2.6, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.8, 3.9, 3.10, 3.12, 4.6, 5.7 (21 findings, sol only; repeated on recheck for 1.2, 3.1, 3.3, 3.5, 3.8, 2.2, 3.4) | point_attaining_answer | Table has no Markdown "| --- |" separator row, so it will not render | Rejected | The renderer convention given in the brief and used by the live 1.5 row and the Statistics batch is: first row is the header, same column count per row, no separator row. A separator row would be shown as a data row. All tables pass tools.py validate (column counts equal). |
| 2.1 | point_attaining_answer | Make the least-to-most ranking explicit (kimi, suggestion) | Rejected | The table is already in ranked order and the question is answered; adding a sentence adds nothing and the field is near its cap. |

## Control

Planted a changed number into 3.4 (first number in the answer, 0.50 became 7) in a five-topic subset (1.1, 1.3, 2.2, 3.4, 4.5). Both models flagged it as a defect (sol twice, kimi once) and neither flagged 1.1, 1.3 or 4.5 for content. Pass.

## Numbers listed as only in CURRENT / only in PROPOSED (tools.py validate), justified

- Step numbers ("1") show as "only in PROPOSED" in every topic: validator artifact (the first numbered step of the later fields is not stripped).
- 1.2: 26 comes from Mg-26 (mass 25.983, 11.01%) in the topic's mini_example_question; the table lists all three isotopes with the products already in the original answer.
- 1.4: 11.2 and 88.8 are Sample A from mini_example_question; the original answer said only "Sample A matches that ratio".
- 2.5: 22 (intermediate 4 + 18) is no longer printed; the table shows 4, 18, 2 and the total 24.
- 3.1: 16 (CH4 molar mass) is from mini_example_question; 3 and 4 are subscripts in CH3Cl, CH4, CH3OH table rows.
- 3.3: 19.6 and 22,400 are from mini_example_question (the original answer had only "about 18-20 mL/mol" and "roughly a thousand times", both kept).
- 3.5: 4.00 and 131.3 are the molar masses from mini_example_question.
