# Chemistry 1.5 cheat sheet redraft (prototype, 2026-11-21)

SUPERSEDED the same day by `TWO_LAYER_1_5.md` (Know / Score layers, recap retired) and `UNIT_1_ROLLUP_MOCK.md` (unit-level sheet). This v1 file is kept for the record.

Status: DRAFT FOR REVIEW ONLY. Nothing written to Development or Production, no migration, no approval number, no checker pass, no render check. Every text below is Claude-authored in session from the topic's existing fields plus the Unit 1 reference entries (read from Production, SELECT only).

Inputs: the other-LLM feedback (repeated rule, prose instead of mechanics, textbook definitions) and the thread's ruling that repetition is judged by job, not by count: the same concept may reappear when each appearance does a different job for the student.

## The contract used: one job per card

| Card (field) | Job | What it adds that no other card does |
|---|---|---|
| In 30 seconds (`quick_take`) | The one deliberate recap | A 10-second version of the whole sheet; the only place the rule is restated |
| Core idea (`core_idea`) | What is true | Coulomb in words (formula lives in Reference as LaTeX), the Aufbau order with maximum occupancy as one notation string, what is out of scope |
| What to understand (`what_students_need_to_understand`) | The mechanism | The three levers (protons, valence shell, core electrons) and the direction each pushes. New information; the old text only restated the rule |
| How points are earned (`how_this_becomes_points`) | The procedure | Three steps, direction-neutral (the old step 3 only covered "higher") |
| Example (`answer_move`, shown directly under the steps) | The procedure applied once | One concrete answer (S vs Al) written as a student would write it. Revised 2026-11-21 per David: the answer move is the application of "how points are earned", so it is the example, not a separate rule or template |
| Common point loss (`common_point_loss`) | The trap | The losing answer itself ("farther right, so higher") in one line |
| Practice bridge (`practice_bridge`) | Transfer | Radius uses the same levers; 1.6 builds on these configurations. Cross-topic re-use, not a restatement |

## Draft text (new)

### core_idea
```
- Coulomb's law: the pull between charges grows with the charges and shrinks with distance.
- Fill lowest energy first (Aufbau), each subshell to its maximum: 1s² 2s² 2p⁶ 3s² 3p⁶ 4s² 3d¹⁰ 4p⁶ 5s² 4d¹⁰ 5p⁶ …
- Not tested: assigning n, l, mₗ, mₛ to single electrons.
```

### what_students_need_to_understand
```
Three levers decide a comparison of two atoms:

| If the atom has | Pull on its valence electrons | Ionization energy |
| More protons, same shell | Stronger | Higher |
| Valence electrons in a farther shell | Weaker | Lower |
| More core electrons in between | Weaker | Lower |
```

### how_this_becomes_points
```
1. Write each ground-state configuration in Aufbau order.
2. Find the lever that differs: protons, valence shell, or core electrons.
3. Say whose valence electrons are held more strongly: stronger hold, more energy to remove one; weaker hold, less.
```

### answer_move (now an explicit example of the steps above)
```
Example: sulfur has more protons than aluminum, the same valence shell and the same 10 core electrons, so its valence electrons are held more strongly and its first ionization energy is higher.
```
(Replaces the bracketed answer frame in the first draft. 32 words. It uses the same S vs Al case as the deep-dive worked answer, which no longer shows on the cheat sheet, so nothing repeats on the page. Mechanism: `answer_move` is NOT NULL-style content in every row, so content alone cannot delete the card. Smallest app change: label the card "Example" and render it directly under "How points are earned". Without the app change the card would still say "The answer move", which keeps the original name but loses the explicit "example" framing. Also, `quick_take` line 1 carries the label "The answer move", so the label would need to change with the card.)

### common_point_loss
```
Stopping at a trend label (“farther right, so higher”) after a correct configuration: it names a pattern but does not explain it.
```

### practice_bridge
```
The same three levers explain atomic radius. Topic 1.6 builds on these configurations when it reads photoelectron spectra.
```

### quick_take
```
The answer move: Write the configuration, then explain the property by comparing nuclear charge, distance and shielding.
How points are lost: Explaining a related property with a vague label like "periodic trend" after a correct configuration.
Remember it: Diagonal rule: write subshells in rows by shell number, then follow diagonals from upper right to lower left.
```
(Line 1 changed from "...then explain ionization energy through...": it no longer narrows to ionization energy. Lines 2 and 3 unchanged. Hook text is unchanged.)

## Measured (Python, this session)
- Caps: core_idea 264/360, what_to_understand 278/360, how_points 248/320, quick_take 366/400 chars. All structured paragraphs follow the marker rules (no mixed paragraph).
- quick_take sentences: 14, 15, 18 words; label lines 17, 19, 20.
- Words across the seven cards: about 302 before (rough, from the Production row) -> 277 after. Only about 8%: the repeats are gone, but the freed space went to new content (levers table, notation string, answer frame). The reviewer's "40%" is not reached by this draft. If the full cards stop repeating the recap (decision 1 below), the figure falls to about 221 (-27%).

## Facts to check (not yet independently checked)
- Filling string through 5p⁶ (Xe core) follows the CED/Aufbau entry order; capacities s2 p6 d10.
- Levers table: more protons in the same shell raises effective nuclear charge; a farther valence shell lowers the pull; more core electrons between nucleus and valence electrons raise shielding. Each "holding other things equal."
- Step 3 direction-neutral wording; the 1.6 sentence is a scope pointer only.
- Unicode superscripts/subscripts (², ⁶, ₗ) are plain text, so they avoid the open LaTeX rollout (DECISION-0119/0120), but the renderer's font coverage at 375px has not been seen.

## Not changed by this draft (decisions for David)
1. **Recap versus full cards.** `quick_take` is a deliberate recap of the answer move and point loss, and both cards still follow it. Option A (this draft): keep both. Option B: show `quick_take` on top and move answer move and common point loss into the Deep Dive toggle. B cuts about 55 more words on this topic but is a frontend change (app PR).
2. **Unit reference (shared, other pipeline).**
   - `Aufbau subshell filling order` is a `list_sequence` of "1s first / 2s then / 2p then ..." (the text list the feedback called out). With the string now in Core idea, the entry repeats it with the same job. Options: hide it for 1.5 or render its items as the arrow string.
   - `Atom composition`, `Valence electrons`, `Core electrons`, `Shells and subshells` are one-sentence CED definitions (not long, but low value for this topic; Valence electrons is also used by 1.8). Suggest demoting them to a glossary/Deep Dive and keeping `Coulomb's law` (LaTeX), `Effective (shielded) nuclear charge`, `Ionization energy`.
   - Core idea no longer repeats the formula; Reference's LaTeX formula carries it.
3. **Figure.** The Diagonal-rule hook describes a picture in words. A diagonal-rule or subshell-block figure qualifies under the need-based image policy (spatial arrangement). Figure lane task, not part of this draft.
4. **Left as is:** `mini_example_question`, `weak_answer`, `point_attaining_answer` (not shown on the cheat sheet since PR 62; they still use plain "1s2" digits), the hook, and the brief rows.

## Before any apply
Checker pass (gpt-6.1-sol and kimi-k3.1-pro with a planted control), render check at desktop and 375px, a human read, then an APPROVAL record (check open PRs for the next number; 0279 was last used) and a Development rehearsal before a guarded Production write. Rollback: current Production text is captured in `scripts/content-seed/ap-chemistry-explainer-u1-1-5-structured-test-2026-11-12/proposed.json` (`current`) for the four structured fields; `answer_move`, `common_point_loss`, `practice_bridge` and `quick_take` current text is in the Production snapshot for this session (see the thread) and should be saved to a `current.json` before any apply.
