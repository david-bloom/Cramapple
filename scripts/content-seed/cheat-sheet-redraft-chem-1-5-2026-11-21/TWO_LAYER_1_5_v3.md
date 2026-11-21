# Chemistry 1.5, two-layer redraft v3 (prototype, 2026-11-21)

Status: DRAFT, v3. Checked 2026-11-21 by gpt-6.1-sol and kimi-k3.1-pro: 0 findings from either, all four planted controls caught (CHECKER_RESULTS.md). Not rendered, no human read, nothing written to Development or Production. Supersedes `TWO_LAYER_1_5.md` (v2). Changes from David's review of v2 and the follow-up reviewer feedback.

## What changed from v2
1. **Recap retired.** `quick_take` is null for 1.5 and the app must not fall back to a derived block (app change below). The whole sheet is its own recap.
2. **Earned, lost and answer move merged into one worked unit.** Steps (how points are earned), a Weak answer (how points are lost) and a Full-credit answer (the answer move) now read as one card, "How to earn the point":
   - Steps are the procedure.
   - The Weak answer shows which step is skipped, so the trap is no longer a separate rule.
   - The Full-credit answer carries the step numbers (1), (2), (3), so it demonstrates the steps instead of restating them.
3. The Example in v2 had no configurations (step 1). The Full-credit answer now shows them.

## Draft text

### Know: core_idea
```
- Coulomb's law: the pull between charges grows with the charges and shrinks with distance.
- Fill order, each subshell full: 1s² 2s² 2p⁶ 3s² 3p⁶ 4s² 3d¹⁰ 4p⁶ 5s² 4d¹⁰ 5p⁶ …
- Not tested: assigning n, l, mₗ, mₛ to single electrons.
```

### Know: what_students_need_to_understand (the levers)
```
Compare two atoms on three levers:

| If the atom has | Pull on its valence electrons | Ionization energy |
| More protons, same valence shell | Stronger | Higher |
| Valence shell farther out | Weaker | Lower |
| More inner (core) electrons in between | Weaker | Lower |
```

### Score: how_this_becomes_points (steps)
```
1. Write each ground-state configuration in Aufbau order.
2. Find the lever that differs.
3. Say whose valence electrons are held more strongly and what that does to ionization energy.
```

### Score: common_point_loss (shown as "Weak")
```
Weak: correct configurations, then “sulfur is farther right, so its first ionization energy is higher.” It skips step 2: it names a pattern, not a lever.
```

### Score: answer_move (shown as "Full credit")
```
Full credit: (1) S: 1s² 2s² 2p⁶ 3s² 3p⁴; Al: 1s² 2s² 2p⁶ 3s² 3p¹. (2) Sulfur has more protons, the same valence shell and the same 10 core electrons, (3) so its valence electrons are held more strongly and its first ionization energy is higher.
```

### Link: practice_bridge
```
Topic 1.7 applies these levers to trends; topic 1.6 reads these configurations in photoelectron spectra.
```

### Remember it (unchanged)
```
Diagonal rule: write the subshells in rows by shell number, then follow diagonal arrows from upper right to lower left.
```

## Field mapping and app changes
No schema change: the three Score fields stay as they are and the app renders them as one card, in this order: steps, then `common_point_loss` labelled "Weak", then `answer_move` labelled "Full credit".
1. App PR: render those three fields as one card, relabel `common_point_loss` "Weak" and `answer_move` "Full credit", and place them under the steps. Goes to David.
2. App PR: when `quick_take` is null show no recap (today a null falls back to a derived block that would restate the Weak and Full-credit answers).
3. Check whether the renderer structures `answer_move` and `common_point_loss` (only four fields were restructured in Production). If not, the two lines render as plain prose, which is fine for single sentences.
4. Reference (shared pipeline, unchanged recommendation): hide the Aufbau list entry for 1.5; demote Atom composition, Valence electrons, Core electrons, Shells and subshells; keep Coulomb's law, Effective (shielded) nuclear charge, Ionization energy.

## Measured (same counting method as v2: pipes and list markers excluded)
- Words across the cards a student sees: **314 live → 191 v2 → 213 v3** (79 Know, 114 Score, 20 hook).
- Caps: core_idea 231/360, levers 271/360, steps 184/320 characters. No paragraph mixes marker and plain lines.
- Highest pairwise word overlap (min-set, lexical tripwire only): 0.43 levers table vs Full credit, 0.43 steps vs Full credit, 0.39 Weak vs Full credit. All are expected: Full credit demonstrates the steps and uses the lever words; they are one unit now. Below the 0.80 C13 line.
- v3 is 22 words longer than v2 (213 vs 191) because the weak answer and the configurations are back; it is still 32% shorter than the live page's 314.
- The Full-credit answer is longer than v2's Example because it now carries the configurations (step 1).

## Open items
- **Cation trap** ("remove 4s before 3d when forming transition-metal cations"): suggested by a reviewer, true, but in neither the published fields nor the CED fact pack. Not added. If wanted: one bullet in Know, marked NEW, through the checkers first.
- Checker pass done (see CHECKER_RESULTS.md): 0 findings, controls caught.
- No render at desktop or 375px (unicode superscripts and the table), no human read.
- If PR 62's removal of the worked example stands as David's rule, this merged unit is its compact replacement, not a return of the old side-by-side table.
