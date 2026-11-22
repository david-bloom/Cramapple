# Checker results: Unit 1 v3 drafts (2026-11-21)

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro (different families from the Claude author). Script: `check_unit1.py` (key from the gitignored `scripts/vercel-gateway-check/.env.local`, never printed; every plant asserts its target text exists). Raw output: `check_out/`. Gateway spend about $0.95 (gpt about $0.19, kimi about $0.76). Claude authored and arbitrated; no human review.

## Controls
Four planted: 1.1 (1.14×10²³ molecules), 1.3 (empirical mass 60.06), 1.6 (core binding energy "Lower"), 1.8 (group 2 "Gain 2"). Kimi flagged all four. gpt flagged all four cards (1.1, 1.3, 1.6, 1.8) as well.

## Real defects found and fixed (all arbitrated against the sources)
| Topic | Finding | Found by | Fix |
|---|---|---|---|
| 1.2 | 23.985 × 0.7899 = 18.9458, rounds to 18.946 (not 18.945). **Production's published worked example has the same rounding slip**; reported, not changed | gpt | 18.946 |
| 1.4 | "a single sample is not evidence" is too absolute (one sample can rule out a claimed compound) | gpt | "appearance is not evidence" |
| 1.5 | Levers table needs "generally, other things equal" (N to O ionization energy exception) | gpt | header qualified (also changes the v3 text merged in PR 675) |
| 1.6 | Heights are proportional to, not equal to, electron counts; "scale to whole numbers" is not enough; scaling must use valid subshell occupancies | gpt (twice), kimi suggestion | steps, Full credit and Know reworded ("ideally proportional", s up to 2, p up to 6) |
| 1.8 | Group 13 does not always reach a noble-gas configuration (Ga); "different groups do not share one" is too absolute | gpt | group 13 row dropped; source wording "never assume ... share a charge" |

Applied suggestions: 1.1 "numerically equal"; 1.7 step 3 folded into step 2 so the Full-credit answer demonstrates every step; 1.8 same-column analogy "tend to".

## Final status
Last runs on the final text: 1.6 both models clean; 1.5, 1.1, 1.7, 1.8 clean on both models in the preceding per-topic rechecks (the later edits touched only 1.6). 1.2, 1.3 and 1.4 passed both models in the first four-topic batch after the fixes (kimi 0 findings; gpt clean on the recheck). Kimi returned empty output twice on the four-topic 1.5 to 1.8 batch, so those topics were checked one at a time.

## What this does not show
- Both checkers treat the sources as truth. The 1.7 trend directions and Radius column and the 1.8 group table are not in the published fields or the CED fact pack; they were judged as chemistry only.
- Not done: render at desktop and 375px, human read, any write to Development or Production, the app changes (one merged Score card, no recap), the Reference clean-up.
- Words a student sees across the eight topics (same counting method as the 1.5 work: pipes and list markers excluded): **2045 now → 1588 drafted** (22% less). Per topic: 1.1 233→173, 1.2 235→197, 1.3 255→191, 1.4 245→180, 1.5 314→217, 1.6 241→228, 1.7 254→213, 1.8 268→189.
