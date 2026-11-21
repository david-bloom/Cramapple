# Checker results, 2026-11-21 (TWO_LAYER_1_5.md and UNIT_1_ROLLUP_MOCK.md)

Checkers: openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro (different families from the Claude author). Script: `check_drafts.py` (key read from the gitignored `scripts/vercel-gateway-check/.env.local`, never printed). Raw output: `check_out/`. Gateway spend about $0.59 (gpt about $0.12, kimi about $0.47). Claude authored and arbitrated; no human review.

## Controls (planted defects)
Four planted: 1.5 fill string (3d before 4s), 1.5 levers table (more core electrons = stronger pull, higher ionization energy), unit 1.4 (constant ratio means mixture), unit 1.6 (core electrons bind more loosely).
- 1.5 plants: both models failed both planted cards.
- Unit plants: both models failed 1.4 and 1.6. gpt also raised its genuine clean-run findings again; kimi did not.

## Topic 1.5 draft (clean run)
Both models: 0 findings, verdict pass on all eight items (six cards, hook, and the overlap check). The overlap check found no two cards making the same claim for the same job.

## Unit 1 mock (clean run): 5 defects, all real, all fixed
| # | Topic | Finding | Found by | Fix |
|---|---|---|---|---|
| 1 | 1.4 | "constant means pure" overstates; the source says a constant ratio supports purity | both | "constant supports pure, changing means mixture" |
| 2 | 1.5 | "Not tested: n, l, mₗ, mₛ" broadens the CED exclusion, which is about assigning quantum numbers to electrons | gpt | reworded to the exclusion |
| 3 | 1.7 | "Not tested: Cr and Cu exceptions" broadens the exclusion (writing aufbau-exception configurations) | gpt | reworded |
| 4 | 1.7 (NEW line) | ionization energy trend needs "generally": Be/B and N/O dips | gpt | "generally" added; the dips themselves stay an open content decision |
| 5 | 1.8 | Do line dropped "common main-group ions"; the noble-gas method does not work for transition-metal ions | gpt | restored |
Recheck of the fixed unit mock: kimi 0 findings; gpt 0 defects, 3 style suggestions (1.1 add "numerically"; 1.2 keep the other half of the exclusion; 1.3 qualify "assume 100 g" with percent data). Only the 1.3 suggestion was applied (faithful to the source's wording); the 1.1 and 1.2 suggestions are left as style. The 1.3 edit was made after the recheck and was not itself re-run.

## What this does not show
- Both checkers treat the sources as truth, as in the earlier rollouts. The NEW 1.7 trend line and the Radius column were judged as chemistry only: gpt accepted the radius column and the trend (with "generally"); neither is in the CED fact pack.
- Kimi found 1 of the 5 real defects that gpt found; the pair covers more than either alone.
- Not done: render at desktop and 375px, human read, any write to Development or Production, app changes.
