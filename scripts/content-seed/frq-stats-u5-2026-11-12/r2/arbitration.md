# r2 arbitration (difficulty rewrite), 2026-11-12
Gate added: `--min-difficulty=Medium` (any checker rating Easy rejects) plus an AP-exam difficulty scale in the audit prompt; the variant diff check also flags `easier than parent`.
First r2 run: 4.3, 4.5, 4.6 accepted (both checkers Medium). Seven items flagged. Rulings:
- 5.1 and 4.7 (one checker still Easy): ACCEPT the signal. 5.1 gets a second claim to evaluate with a data comparison. 4.7 drops the SE criterion (folded into the interval) and adds an explanation of why the table's conservative df gives a wider interval than technology.
- 5.3 (Easy vote; GPT: negative-price criterion also demanded extrapolation, which the part did not ask): ACCEPT. The part now asks for both; a reliability critique part is added.
- 5.4 (DeepSeek: interpretation criterion lacked context and magnitude): ACCEPT. Replaced by a contextual sign criterion plus a magnitude criterion.
- 5.5: topic vote 5.3 x4 vs 5.5 x2 again. REJECT the vote on CED text, as in r1: slope (5.5.B.2), intercept (5.5.B.3), r-squared (5.5.A.5) and the line passing through the means (5.5.A.1). Topic ruling recorded in the slot.
- 4.4 (GPT: randomization criterion demanded randomized order too): ACCEPT, order randomization now only in the stem. 4.4 and 4.9 (both checkers: evidence said why the condition 'is met' where it is not): ACCEPT, evidence now says whether it is met.
- 4.9 (DeepSeek: subscript assignment not given): ACCEPT, prompt now assigns mu1 and mu2.

## r2 second run: accepted 5.4, 4.7, 4.9 (plus 4.3, 4.5, 4.6 earlier). Flagged: 5.1, 5.3, 5.5, 4.4.
- 5.1 (GPT): a3 and b1 double-count 'strength is closeness to the pattern', and c2 required listing all three scores. ACCEPT both: a3 now only says all points lie close to one smooth curve; the claim 2 criterion accepts comparing the highest score (78) with the lowest (82).
- 5.5 (GPT): R2_ERR and R2_INTERP overlapped. ACCEPT: R2_ERR now only rejects the 'points on the line / correct predictions' reading; the explained-variation statement belongs to R2_INTERP. Topic vote this time 5.3 x3, 5.5 x3: the CED-text ruling stands.
- 5.3 and 4.4 (DeepSeek still rated Easy): ACCEPT the signal. 5.3 part (c) now asks the student to rank three predictions by reliability using how far each x-value lies outside the data. 4.4 now defines the difference as (without minus with) so the sign of the alternative must be reasoned out rather than copied.
