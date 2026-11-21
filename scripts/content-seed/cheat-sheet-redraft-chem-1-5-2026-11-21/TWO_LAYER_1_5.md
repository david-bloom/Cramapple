# Chemistry 1.5, two-layer redraft (prototype v2, 2026-11-21)

Status: DRAFT FOR REVIEW ONLY. Checked 2026-11-21 by gpt-6.1-sol and kimi-k3.1-pro: 0 findings from either on all eight items, planted controls caught (see CHECKER_RESULTS.md). Nothing written to Development or Production, no migration, no approval number, no checker pass, no render check, no human read. Claude-authored in session from the topic's published fields and the Unit 1 reference entries (Production, SELECT only). Supersedes the v1 draft in `README.md` (kept for the record).

## Design
Two layers plus a link, one job per card. The same concept (Coulomb's law, the three levers) may appear in more than one card or topic only when each appearance does a different job (delta test; see "Findings applied").

- **Know layer** (recall, terse, symbols and a table): `core_idea`, `what_students_need_to_understand`.
- **Score layer** (what earns the point): `how_this_becomes_points` (steps), `answer_move` (now an explicit Example), `common_point_loss` (the trap, one line).
- **Link** (`practice_bridge`): where the same levers are applied next.
- **Remember it** (hook, unchanged). **In 30 seconds** (`quick_take`) retired for this topic: the whole sheet is now short enough to be its own recap.

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

### Score: how_this_becomes_points
```
1. Write each ground-state configuration in Aufbau order.
2. Find the lever that differs.
3. Say whose valence electrons are held more strongly and what that does to ionization energy.
```

### Score: answer_move (explicit Example of the steps)
```
Example: sulfur has more protons than aluminum, the same valence shell and the same 10 core electrons, so its valence electrons are held more strongly and its first ionization energy is higher.
```

### Score: common_point_loss (Trap)
```
Stopping at a trend label (“farther right, so higher”): it names a pattern but does not explain it.
```

### Link: practice_bridge
```
Topic 1.7 applies these levers to trends; topic 1.6 reads these configurations in photoelectron spectra.
```

### Remember it (unchanged)
```
Diagonal rule: write the subshells in rows by shell number, then follow diagonal arrows from upper right to lower left.
```

## Findings applied (where each thread finding went)
| Finding | Where it landed |
|---|---|
| Same rule five times (reviewer) | The "name the lever, not the trend" rule now lives in three cards with three jobs: the levers table (mechanism), the steps (procedure), the Example (applied once). The trap card shows the losing answer, not the rule. The old step 3 restated the table's mapping and is now one clause pointing at it |
| Prose instead of mechanics (reviewer) | Filling order is one notation string with occupancy; the levers are a table |
| Textbook definitions (reviewer) | "An atom is a nucleus..." bullet and the valence/core definition bullet removed; the table rows carry the terms ("valence shell", "inner (core) electrons") |
| Repetition judged by job, not count (David) | Contract table below; coulomb appears in Know (words), the table (mechanism) and the Link (cross-topic), never as the same sentence twice |
| Answer move is the application of the steps (David) | Merged: the card is an explicit worked Example |
| Core idea vs In 30 seconds (David) | Recap retired for 1.5; Know layer is the recap |
| Albert and OnePrep: terse recall, markers, unit view | Know layer in their style; unit roll-up mock in `UNIT_1_ROLLUP_MOCK.md` |
| Direction-neutral step 3 (my own check) | Step 3 no longer says only "more energy" |
| Quick_take line 1 narrowing to ionization energy (my own check) | Moot: recap retired. If the recap is kept, line 1 must say "related property" |
| Coulomb formula stored as LaTeX in Reference | Not restated in Core idea |
| Unicode over LaTeX for exponents (open DECISION-0119/0120 rollout) | ², ⁶, ₗ, ₛ are plain characters; fonts at 375px unseen |
| Reference demotions | See "App and reference changes" |

## Contract (one job per card)
| Card | Job | Delta: what no other card gives |
|---|---|---|
| Core idea | What is true | Coulomb in words, fill order with occupancy, scope exclusion |
| Levers table | The mechanism | Which way each lever moves the pull and ionization energy |
| Steps | The procedure | The order of work (configure, find the lever, state the consequence) |
| Example | The procedure applied once | A finished S vs Al sentence |
| Trap | The failure | The losing answer itself |
| Link | Transfer | 1.7 uses the levers for trends, 1.6 reads these configurations |

## Measured (same counting method for old and new: pipes and list markers excluded)
- Words across the cards a student sees: **314 before** (six explainer fields, `quick_take` and the hook card) → **191 after** (79 Know, 92 Score, 20 hook): about 39% less. Part of that is retiring `quick_take` (about 54 words).
- Caps: core_idea 231/360, levers 271/360, steps 184/320 characters. No paragraph mixes marker and plain lines.
- Highest pairwise word overlap between any two cards (min-set): 0.52 (levers table vs Example, they share the lever words by design). Below the 0.80 C13 line; lexical tripwire only.
- Miss to note: my target was 120 to 160 words; the table and the Example are the bulk and I did not cut them, since they carry the new content.

## App and reference changes this needs (not part of the draft text)
1. Label `answer_move` "Example" and render it directly under the steps (and name the groups Know / Score). App PR, goes to David.
2. Allow "no recap": today a null `quick_take` falls back to a derived block built from the answer move, point loss and hook, which would restate the Example and trap. App PR.
3. Reference (shared, other pipeline): hide the `Aufbau subshell filling order` list entry for 1.5 (now duplicated by the string, job unchanged), and demote `Atom composition`, `Valence electrons`, `Core electrons`, `Shells and subshells` to a glossary. Keep `Coulomb's law` (LaTeX), `Effective (shielded) nuclear charge`, `Ionization energy`.
4. Figure candidate: the diagonal rule or a subshell-block map (need-based policy). Figure lane, not this draft.

## Not done
No independent fact check (gpt-6.1-sol and kimi-k3.1-pro with a planted control are the standard; not run, gateway spend not authorised this session). Facts to check: the fill string through 5p⁶; the levers table (all "holding other things equal"); the S vs Al Example (Z=16 and 13, both valence shell n=3, 10 core electrons each; same facts as the verified deep-dive answer); the 1.7 pointer. No render at desktop or 375px. No human read. Rollback for any future apply: current Production text of every field above is the row now in Production; save a `current.json` first.
