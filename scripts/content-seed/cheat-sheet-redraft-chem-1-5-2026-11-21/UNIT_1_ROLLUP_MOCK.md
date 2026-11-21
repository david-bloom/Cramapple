# Unit 1 roll-up sheet, mock (AP Chemistry, 2026-11-21)

Status: MOCK FOR REVIEW ONLY. Checked 2026-11-21 (see CHECKER_RESULTS.md): 5 defects fixed and re-checked clean; 3 style suggestions open. A unit-level cheat sheet assembled from each topic's published fields, shortened by me. No schema, no write, no render. Not a replacement for the topic page: topic pages keep the Know and Score layers; this is a one-page roll-up in the style of the Albert and OnePrep unit sheets, with our added Do and Trap lines.

Sources: the published Production fields for AP Chemistry Unit 1 (explainers, hooks, reference formulas). One line is new and unchecked (marked NEW). Albert and OnePrep text was read for approach only; no wording copied.

## Unit 1: Atomic Structure and Properties

### Formulas
```
n = m/M · Nₐ = 6.022×10²³ per mole · average mass = Σ(mass × fractional abundance) · F ∝ q₁q₂/r² · E = hν
```

### Three levers (used in 1.5, 1.6 and 1.7; shown once)
```
| If the atom has | Pull on valence electrons | Ionization energy | Radius |
| More protons, same valence shell | Stronger | Higher | Smaller |
| Valence shell farther out | Weaker | Lower | Larger |
| More inner (core) electrons in between | Weaker | Lower | Larger |
```

### 1.1 Moles and molar mass
```
- Know: n = m/M links mass to moles; × Nₐ links moles to particles. Molar mass in g/mol equals one particle's average mass in amu.
- Do: write what is given and what is asked, then pick the conversion.
- Trap: the wrong molar mass (an element's in a compound problem), a miscounted atom, or stopping at moles when particles were asked.
```

### 1.2 Mass spectra of elements
```
- Know: one peak per isotope; position is its mass, height is its relative abundance. Not tested: multi-element spectra.
- Do: multiply each peak's mass by its fractional abundance, then add; explain a mass difference with neutrons.
- Trap: blaming electrons or protons for isotope mass differences (2025 FRQ mean 0.55/1.0).
```

### 1.3 Composition of pure substances
```
- Know: a pure compound has a fixed element mass ratio. Empirical formula = lowest whole-number atom ratio; molecular = a whole multiple of it.
- Do: with percent data assume 100 g, then grams to moles, divide by the smallest, scale to whole numbers; multiple = molar mass ÷ empirical mass.
- Trap: stopping at the empirical formula when the molecular formula was asked.
```

### 1.4 Composition of mixtures
```
- Know: a pure substance has one particle type in a fixed proportion; a mixture has two or more in a proportion that can vary.
- Do: compare element mass ratios across two or more samples: constant supports pure, changing means mixture.
- Trap: calling a sample pure because it looks uniform.
```

### 1.5 Atomic structure and electron configuration
```
- Know: fill order 1s² 2s² 2p⁶ 3s² 3p⁶ 4s² 3d¹⁰ 4p⁶ … Not tested: assigning quantum numbers (n, l, mₗ, mₛ) to electrons.
- Do: write the configurations, find the lever that differs (table above), say whose valence electrons are held more strongly.
- Trap: “farther right, so higher” names a pattern; it does not explain it.
- Remember it: diagonal rule, rows by shell number, arrows from upper right to lower left.
```

### 1.6 Photoelectron spectroscopy
```
- Know: peak position is a subshell's binding energy; height is roughly its electron count. Photon energy hν = binding + kinetic energy.
- Do: peak heights give electron counts per subshell, match them to an element; explain binding energy by distance and shielding (levers above).
- Trap: ranking binding energy by filling order. Core electrons always bind more tightly than valence electrons.
```

### 1.7 Periodic trends
```
- Know: trends follow from Coulomb's law with effective nuclear charge, distance and shielding. Not tested: writing configurations of aufbau exceptions (Cr, Cu).
- Know (NEW, unchecked): across a period effective nuclear charge rises, radius falls and ionization energy generally rises; down a group radius rises and ionization energy generally falls.
- Do: pick the one lever that differs and justify the direction with it.
- Trap: stating the direction without the reason.
```

### 1.8 Valence electrons and ionic compounds
```
- Know: typical ion charge comes from valence electrons and position; same column, analogous compounds; total charge sums to zero.
- Do: for common main-group ions, count valence electrons from the group, gain or lose to reach a noble-gas configuration, check the formula balances.
- Trap: a guessed charge, or an unbalanced formula (CaCl instead of CaCl₂).
```

## Measured (pipes and list markers excluded)
- Unit sheet: **514 words** (60 shared tools, 454 across eight topics; per topic 48 to 65). Per topic: 1.1 60, 1.2 48, 1.3 58, 1.4 49, 1.5 65, 1.6 60, 1.7 64, 1.8 50.
- Current Production explainer fields for the same eight topics (core, understand, steps, answer move, point loss, bridge, quick take): about 2025 words, before hooks and reference. OnePrep's Unit 1 (pasted): 82 words, facts only.
- So the roll-up is roughly 6.3 times OnePrep's length and about 75% shorter than reading the eight topic pages' text.

## How it differs from Albert and OnePrep
- Keeps the **Do** (the move that earns the point) and **Trap** lines per topic. Neither competitor has a per-topic scoring move; Albert gives one FRQ line per unit.
- The levers table appears once for the unit and is referenced by 1.5, 1.6 and 1.7. That is the re-use-by-job rule: the same concept, one home, three uses.
- No rule-of-thumb cutoffs that contradict the course (Albert's "EN > 1.7 = ionic" treats bonds as boxes; our 2.1 teaches a continuum). Not an issue in Unit 1, but a guard for Unit 2.

## Open items and cautions
1. **NEW line in 1.7** (trend directions) and the **Radius column** in the levers table are standard chemistry but are in neither the published fields nor the CED fact pack (which says only that trends are explained qualitatively). Needs a checker pass and your call. They are also the facts OnePrep leads with, so the roll-up is thin without them.
2. **Subshell exceptions** (N vs O, Be vs B ionization energy dips) are deliberately left out; OnePrep mentions them. Whether the AP asks them is a content decision.
3. **Derivation.** If this becomes a product, the lines should be generated from structured per-topic fields (know bullets, do line, trap line), not written once per unit, or the unit sheet will drift from the topic pages. That needs a schema and generate-select pass (DECISION-0099), with per-subject approval for any Production write.
4. **Not done:** independent checkers, render (a table and a unicode formula strip at 375px), human read. The 1.1 to 1.4 and 1.8 lines are condensed from published fields and not independently re-derived.
5. Trap and Do lines for 1.6 and 1.7 each fold two published fields into one line; check nothing was lost (1.6's "match peak count then heights" vs "sum peak heights" differ in the source and I used the heights-give-counts reading).
