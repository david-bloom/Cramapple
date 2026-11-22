# AP Chemistry Unit 1: Cheat Sheet v3 drafts, topics 1.1 to 1.8 (2026-11-21)

Status: DRAFT FOR REVIEW. Applies `docs/product/CHEAT_SHEET_GUIDELINES_2026_11_21.md` to every published Unit 1 Chemistry topic. Nothing written to Development or Production, no migration, no approval number, no render, no human read. Claude-authored in session from each topic's published fields, its published worked example (Weak and Full credit are shortened from it) and the Unit 1 reference entries, all read from Production (SELECT only). Source snapshot: `source_snapshot.json`. Machine-readable text: `proposed.json`. Checker results: `CHECKER_RESULTS.md`.

Each topic: Know layer, then the Score unit (steps, Weak, Full credit render as one card), a Link, and the hook where one exists (1.5 only). `quick_take` is retired for all eight: it is null and the app must show no recap.

Topic 1.5 is the v3 text merged in PR 675 with one change: its levers table intro now reads "(generally, other things equal)" after a checker flagged the N to O exception.


## 1.1 Moles and Molar Mass

**Know: core_idea**
```
- Molar mass in g/mol is numerically equal to one particle's average mass in amu.
- A compound's molar mass sums every atom in its formula.
```

**Know: mechanism (what_students_need_to_understand)**
```
Pick the conversion from what you have and what you need:

| Given | Need | Use |
| Mass | Moles | n = m/M |
| Moles | Particles | × 6.022×10²³ per mole |
| Particles | Moles | ÷ 6.022×10²³ per mole |
```

**Score: steps (how_this_becomes_points)**
```
1. Write what is given and what is asked.
2. Pick the conversion from the table, using the molar mass of the substance asked about.
3. Carry on to particles if particles were asked; do not stop at moles.
```

**Score: Weak (common_point_loss)**
```
Weak: “n = 3.42 g ÷ 6.022×10²³ = 5.68×10⁻²⁴ mol, so that's the number of molecules.” It breaks step 2: Avogadro's number never converts mass to moles.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Given 3.42 g of glucose (C₆H₁₂O₆, 180.16 g/mol); need molecules. (2) n = 3.42 g ÷ 180.16 g/mol ≈ 0.01898 mol. (3) 0.01898 mol × 6.022×10²³ per mole ≈ 1.14×10²² molecules.
```

**Link (practice_bridge)**
```
Stoichiometry, solution concentration and gas laws all start with this conversion, and a wrong molar mass carries into every later calculation.
```

## 1.2 Mass Spectra of Elements

**Know: core_idea**
```
- One peak per isotope: position is its mass, height is its relative abundance.
- Average atomic mass is the isotope-weighted average of the peaks.
- Not tested: spectra of more than one element, or peaks from anything other than singly charged monatomic ions.
```

**Know: mechanism (what_students_need_to_understand)**
```
Isotopes of one element differ in one particle only:

| Particle | Across isotopes of an element |
| Protons | Same (they define the element) |
| Electrons (neutral atom) | Same |
| Neutrons | Different: this is the mass difference |
```

**Score: steps (how_this_becomes_points)**
```
1. Read each peak's mass and relative abundance.
2. Multiply each mass by its fractional abundance.
3. Add the products; to explain a mass difference, name neutrons.
```

**Score: Weak (common_point_loss)**
```
Weak: “Average mass ≈ 24.3 amu, and Mg-25 is heavier than Mg-24 because it has one more electron.” It names the wrong particle at step 3: a neutral atom's electron count does not change.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Mg-24: 23.985 amu, 78.99%; Mg-25: 24.986 amu, 10.00%; Mg-26: 25.983 amu, 11.01%. (2) 23.985 × 0.7899 + 24.986 × 0.1000 + 25.983 × 0.1101 = 18.946 + 2.499 + 2.861. (3) Sum ≈ 24.31 amu. Mg-25 has one more neutron than Mg-24; both have 12 protons and 12 electrons.
```

**Link (practice_bridge)**
```
This is how the periodic table's average atomic mass is actually measured, not memorized.
```

## 1.3 Elemental Composition of Pure Substances

**Know: core_idea**
```
- A pure compound has a fixed element mass ratio (law of definite proportions).
- Empirical formula: the lowest whole-number atom ratio.
- Molecular formula: a whole-number multiple of the empirical formula.
```

**Know: mechanism (what_students_need_to_understand)**
```
Where to stop depends on what is asked:

| Asked for | Finish at |
| Empirical formula | The whole-number mole ratio |
| Molecular formula | That ratio × (molar mass ÷ empirical mass) |
```

**Score: steps (how_this_becomes_points)**
```
1. With percent data, assume 100 g and convert each element's grams to moles.
2. Divide every mole value by the smallest; scale to whole numbers.
3. Divide the molar mass by the empirical mass and multiply the formula by that factor.
```

**Score: Weak (common_point_loss)**
```
Weak: “C 3.33 mol, H 6.66 mol, O 3.33 mol, so the formula is CH₂O.” It stops after step 2: a molar mass of about 180 g/mol was given and the molecular formula was asked.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) In 100 g: C 3.33 mol, H 6.66 mol, O 3.33 mol. (2) Dividing by 3.33 gives 1 : 2 : 1, so CH₂O, empirical mass ≈ 30.03 g/mol. (3) 180 ÷ 30.03 ≈ 6, so the molecular formula is (CH₂O)₆ = C₆H₁₂O₆.
```

**Link (practice_bridge)**
```
Topic 1.4 asks the reverse question: whether a composition ratio stays fixed across samples.
```

## 1.4 Composition of Mixtures

**Know: core_idea**
```
- Pure substance: one particle type in a fixed proportion.
- Mixture: two or more particle types in proportions that can vary.
- A homogeneous mixture can look as uniform as a compound.
```

**Know: mechanism (what_students_need_to_understand)**
```
Element mass ratio across independent samples:

| Across samples | Supports |
| Constant | A pure substance |
| Changes | A mixture |
```

**Score: steps (how_this_becomes_points)**
```
1. Get elemental analysis for two or more samples.
2. Compare the mass ratio of the same elements across them.
3. State the purity conclusion the comparison supports; appearance is not evidence.
```

**Score: Weak (common_point_loss)**
```
Weak: “Both samples are clear liquids that look identical, so this is a pure substance.” It skips steps 1 and 2: appearance is not evidence.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Water is 11.19% H and 88.81% O by mass; Sample A is 11.2% H, 88.8% O; Sample B is 9.5% H, 90.5% O. (2) A matches that ratio; B does not. (3) The ratio changed between bottles, so at least one is not the pure substance claimed; looking alike gives no evidence either way.
```

**Link (practice_bridge)**
```
Topic 1.3's empirical formulas are valid only because a pure compound's ratio is fixed; Unit 3's mixture-separation topics build on the same evidence.
```

## 1.5 Atomic Structure and Electron Configuration

**Know: core_idea**
```
- Coulomb's law: the pull between charges grows with the charges and shrinks with distance.
- Fill order, each subshell full: 1s² 2s² 2p⁶ 3s² 3p⁶ 4s² 3d¹⁰ 4p⁶ 5s² 4d¹⁰ 5p⁶ …
- Not tested: assigning n, l, mₗ, mₛ to single electrons.
```

**Know: mechanism (what_students_need_to_understand)**
```
Compare two atoms on three levers (generally, other things equal):

| If the atom has | Pull on its valence electrons | Ionization energy |
| More protons, same valence shell | Stronger | Higher |
| Valence shell farther out | Weaker | Lower |
| More inner (core) electrons in between | Weaker | Lower |
```

**Score: steps (how_this_becomes_points)**
```
1. Write each ground-state configuration in Aufbau order.
2. Find the lever that differs.
3. Say whose valence electrons are held more strongly and what that does to ionization energy.
```

**Score: Weak (common_point_loss)**
```
Weak: correct configurations, then “sulfur is farther right, so its first ionization energy is higher.” It skips step 2: it names a pattern, not a lever.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) S: 1s² 2s² 2p⁶ 3s² 3p⁴; Al: 1s² 2s² 2p⁶ 3s² 3p¹. (2) Sulfur has more protons, the same valence shell and the same 10 core electrons, (3) so its valence electrons are held more strongly and its first ionization energy is higher.
```

**Link (practice_bridge)**
```
Topic 1.7 applies these levers to trends; topic 1.6 reads these configurations in photoelectron spectra.
```

**Remember it (hook, unchanged)**
```
Diagonal rule: write the subshells in rows by shell number, then follow diagonal arrows from upper right to lower left.
```

## 1.6 Photoelectron Spectroscopy

**Know: core_idea**
```
- Peak position is the energy needed to remove an electron from that subshell (its binding energy); peak height is ideally proportional to its electron count.
- Photon energy hν = binding energy + kinetic energy of the ejected electron.
```

**Know: mechanism (what_students_need_to_understand)**
```
Binding energy follows the 1.5 levers, not the filling order:

| Electron is | Binding energy |
| Core: closer to the nucleus, less shielded | Higher |
| Valence: farther out, more shielded | Lower |
```

**Score: steps (how_this_becomes_points)**
```
1. Read the relative peak heights as the ratio of electrons in each subshell.
2. Scale the ratio to counts a subshell can hold (s up to 2, p up to 6), add them and match the configuration to an element.
3. Explain binding energy by distance and shielding, never by filling order.
```

**Score: Weak (common_point_loss)**
```
Weak: “The highest-binding-energy peak must be 3s, since 3s is one of the last subshells filled.” It breaks step 3: it ranks by filling order, not by distance and shielding.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Relative heights 2 : 2 : 6 : 2 give the electron ratio for 1s, 2s, 2p, 3s. (2) Those are valid counts (s holds 2, p holds 6): 2 + 2 + 6 + 2 = 12 electrons: 1s² 2s² 2p⁶ 3s², so magnesium. (3) The highest-binding-energy peak is 1s because 1s electrons are closest to the nucleus and least shielded, not because of when 1s was filled.
```

**Link (practice_bridge)**
```
PES reads the Topic 1.5 configurations directly off real data.
```

## 1.7 Periodic Trends

**Know: core_idea**
```
- Periodic position reflects recurring configuration patterns; ionization energy, atomic and ionic radius, electron affinity and electronegativity all follow from Coulomb's law, shielding and effective nuclear charge.
- Not tested: writing configurations of aufbau exceptions (Cr, Cu).
```

**Know: mechanism (what_students_need_to_understand)**
```
Position tells you which lever changes (generally):

| Moving | Lever that changes | Radius | Ionization energy |
| Across a period | More protons, same valence shell | Smaller | Higher |
| Down a group | Valence shell farther out | Larger | Lower |
```

**Score: steps (how_this_becomes_points)**
```
1. Find the lever that differs between the two atoms or ions: protons, valence shell or core electrons.
2. Justify the direction with that lever alone; a trend's name is not a reason. The same reasoning estimates an unknown property.
```

**Score: Weak (common_point_loss)**
```
Weak: “Chlorine has a higher ionization energy than sulfur because ionization energy increases across a period.” It skips step 1: it names the trend, not the lever.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Cl (Z = 17) and S (Z = 16) share a period, so the valence shell and shielding are similar, but Cl has one more proton. (2) Greater effective nuclear charge over a similar distance pulls Cl's valence electrons harder, so more energy is needed to remove one: Cl's first ionization energy is higher.
```

**Link (practice_bridge)**
```
This is the Coulomb logic from 1.5 applied to periodic position, and it returns whenever a later unit compares or estimates a property.
```

## 1.8 Valence Electrons and Ionic Compounds

**Know: core_idea**
```
- Typical ion charge follows from valence electrons and position in the periodic table.
- Elements in the same column tend to form analogous compounds.
- The total charge in a formula sums to zero.
```

**Know: mechanism (what_students_need_to_understand)**
```
Common main-group ions:

| Group | To reach a noble-gas configuration | Typical charge |
| 1 | Lose 1 | 1+ |
| 2 | Lose 2 | 2+ |
| 16 | Gain 2 | 2− |
| 17 | Gain 1 | 1− |
```

**Score: steps (how_this_becomes_points)**
```
1. Count valence electrons from the group and find the gain or loss that reaches a noble-gas configuration: that is the charge.
2. Combine ions so the total charge sums to zero.
3. Use same-column analogies, but never assume elements from different groups share a charge.
```

**Score: Weak (common_point_loss)**
```
Weak: “Calcium is near sodium, so the compound is probably CaCl, like NaCl.” It skips step 1: calcium is in a different group, so its charge is different.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Ca is in group 2, so it loses 2 electrons to give Ca²⁺; Cl is in group 17, so it gains 1 to give Cl⁻. (2) Zero total charge needs two Cl⁻ per Ca²⁺: CaCl₂. (3) NaCl predicts KCl (same column as Na) but not CaCl.
```

**Link (practice_bridge)**
```
This sets up bonding and compound formation in Unit 2.
```
