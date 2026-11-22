# AP Chemistry Unit 9: Cheat Sheet v3 drafts, topics 9.1 to 9.11 (2026-11-21)

Status: DRAFT FOR REVIEW. Generated from `proposed.json`. Nothing written to Development or Production. `quick_take` retired (null). Checker results: `CHECKER_RESULTS.md`.

## 9.1 Introduction to Entropy

**Know: core_idea**
```
- Entropy (S) rises as matter or energy becomes more dispersed among particles.
- “More disorder” alone is not an explanation: name the particles or the energy.
```

**Know: mechanism (what_students_need_to_understand)**
```
| Change | Entropy | What disperses |
| Solid → liquid → gas | Increases | Matter |
| Gas expands at constant T | Increases | Matter |
| Temperature rises | Increases | Kinetic energy (distribution broadens) |
| More moles of gas in products | Generally increases | Matter |
```

**Score: steps (how_this_becomes_points)**
```
1. Say what is dispersing: particles (matter) or kinetic energy.
2. Find the change in the table: phase, volume, temperature or moles of gas.
3. State the direction of ΔS and tie it to that dispersal.
```

**Score: Weak (common_point_loss)**
```
Weak: “Because products are more disordered.” It skips step 1: it names no particles and no energy.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Gas particles are dispersing. (2) The products have more moles of gas, (3) so the particles can occupy more positions and energy arrangements, the number of microstates rises, and the system's entropy increases.
```

**Link (practice_bridge)**
```
Topic 9.2 puts numbers on ΔS, and topic 9.3 combines it with ΔH.
```

## 9.2 Absolute Entropy and Entropy Change

**Know: core_idea**
```
- ΔS°ᵣₓₙ = Σ n S°(products) − Σ n S°(reactants), n = coefficient.
- Each S° is per mole of that species, in J/(mol·K).
```

**Know: mechanism (what_students_need_to_understand)**
```
Check the calculated sign against the particles (generally):

| Moles of gas, products vs reactants | Expected sign of ΔS° |
| More | Positive |
| Fewer | Negative |
| Equal | No gas-count prediction; rely on the calculation |
```

**Score: steps (how_this_becomes_points)**
```
1. Multiply each S° by its coefficient in the balanced equation.
2. Subtract: products minus reactants.
3. Check the sign against the change in moles of gas.
```

**Score: Weak (common_point_loss)**
```
Weak: “Do not multiply; the table already gives entropy for each substance.” It breaks step 1: the table gives entropy per mole, and the equation counts moles.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) A tabulated S° is per mole, so each is multiplied by its coefficient in the balanced equation. (2) ΔS° is the sum for the products minus the sum for the reactants, not the reverse. (3) The sign is then compared with the change in moles of gas.
```

**Link (practice_bridge)**
```
Topic 9.3 uses this ΔS° in ΔG° = ΔH° − TΔS°.
```

## 9.3 Gibbs Free Energy and Thermodynamic Favorability

**Know: core_idea**
```
- Thermodynamically favored (standard state): ΔG° < 0. The CED prefers this term to “spontaneous”.
- ΔG° = ΔH° − TΔS°, with T in kelvin.
- ΔG°ᵣₓₙ = Σ nΔG°f(products) − Σ nΔG°f(reactants), n = coefficient.
```

**Know: mechanism (what_students_need_to_understand)**
```
| ΔH° | ΔS° | Favored (ΔG° < 0) |
| − | + | At all T |
| + | − | At no T |
| + | + | At high T |
| − | − | At low T |
```

**Score: steps (how_this_becomes_points)**
```
1. Give the signs of ΔH° and ΔS°.
2. Find which term favors ΔG° < 0: negative ΔH°, or positive ΔS° (making −TΔS° negative).
3. If the terms oppose, say which one wins at the temperature in question.
```

**Score: Weak (common_point_loss)**
```
Weak: “Yes, because positive entropy always wins.” It skips step 3: with ΔH° > 0, TΔS° must outweigh ΔH°, and that depends on T.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) ΔH° > 0 and ΔS° > 0. (2) Only −TΔS° favors ΔG° < 0; ΔH° opposes it. (3) ΔG° < 0 only when TΔS° > ΔH°, so the process is favored at high enough T, not at all temperatures.
```

**Link (practice_bridge)**
```
Topic 9.5 turns the sign of ΔG° into K, and topic 9.9 reaches the same sign from E°.
```

## 9.4 Thermodynamic and Kinetic Control

**Know: core_idea**
```
- ΔG° < 0 says a process is thermodynamically favored; it says nothing about rate.
- Kinetic control: favored but not measurable, commonly because of a high activation energy.
```

**Know: mechanism (what_students_need_to_understand)**
```
Two separate questions:

| Question | Set by | Tells you |
| Favored? | Sign of ΔG° | Direction |
| Fast? | Activation energy | Whether change is measurable |
```

**Score: steps (how_this_becomes_points)**
```
1. Ask “favored?” from ΔG° (or K).
2. Ask “fast?” separately, from activation energy.
3. Blame the question that fails: no visible change is not evidence of equilibrium.
```

**Score: Weak (common_point_loss)**
```
Weak: “It must not be thermodynamically favored.” It skips step 2: it never asks about rate.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) ΔG° < 0, so the reaction is thermodynamically favored. (2) A high activation energy can make the rate too slow to measure, so the reaction is under kinetic control. (3) No visible change does not show equilibrium.
```

**Link (practice_bridge)**
```
Topic 9.5 reads ΔG° as K, which also says nothing about how fast equilibrium is reached.
```

## 9.5 Free Energy and Equilibrium

**Know: core_idea**
```
- ΔG° = −RT ln K, so K = e^(−ΔG°/RT).
- Standard state: pure substances, 1.0 M solutions, gases at 1.0 atm (or 1.0 bar).
```

**Know: mechanism (what_students_need_to_understand)**
```
The sign of ΔG° sets K relative to 1 (K is far from 1 when |ΔG°| is much larger than RT):

| ΔG° | K | At equilibrium |
| < 0 | > 1 | Products favored |
| > 0 | < 1 | Reactants favored |
| ≈ 0 | ≈ 1 | Neither strongly favored |
```

**Score: steps (how_this_becomes_points)**
```
1. Read the sign of ΔG°.
2. Convert it to K relative to 1 using ΔG° = −RT ln K.
3. State which side is favored at equilibrium under standard conditions.
```

**Score: Weak (common_point_loss)**
```
Weak: “K is less than 1 because energy is released.” It breaks step 2: ΔG° < 0 gives K > 1; releasing energy is not the link.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) ΔG° < 0. (2) Then −RT ln K < 0, so ln K > 0 and K > 1. (3) Products are favored at equilibrium under standard conditions.
```

**Link (practice_bridge)**
```
Topic 9.9 links the same sign of ΔG° to E° through ΔG° = −nFE°.
```

## 9.6 Free Energy of Dissolution

**Know: core_idea**
```
- ΔG° of dissolution reflects three factors, each with enthalpy and entropy contributions:
- separating solute particles from one another;
- reorganizing the solvent;
- solute–solvent attraction.
```

**Know: mechanism (what_students_need_to_understand)**
```
| Factor | Typical main contribution |
| Breaking solute–solute attractions | Enthalpy up (costs energy) |
| Solvent reorganization | Either; depends on the system |
| Solute–solvent attraction | Enthalpy down (releases energy) |
| Dispersal of solute | Generally entropy up, lowering ΔG° via −TΔS° |
```

**Score: steps (how_this_becomes_points)**
```
1. List the factors with their enthalpy and entropy effects.
2. Weigh the unfavorable terms against the favorable ones, using the strength of the attractions.
3. Conclude no further than the weighing supports; entropy alone does not decide.
```

**Score: Weak (common_point_loss)**
```
Weak: “Entropy always makes dissolving happen, so it should dissolve.” It skips step 2: it never weighs the enthalpy terms against the entropy gain.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Mixing disperses the ions (entropy gain) and ion–solvent attraction releases energy, but breaking strong ionic attractions costs energy and solvent reorganization can too. (2) If the unfavorable terms outweigh the favorable ones, (3) ΔG° can be positive, so the salt may fail to dissolve.
```

**Link (practice_bridge)**
```
Topic 9.3's sign table applies once these factors are combined into ΔH° and ΔS°.
```

## 9.7 Coupled Reactions

**Know: core_idea**
```
- Coupling joins an unfavorable step (ΔG° > 0) to a favorable one through a shared intermediate.
- Net ΔG° = sum of the steps' ΔG° values.
- External energy (electrical, light) can also drive an unfavorable process.
```

**Know: mechanism (what_students_need_to_understand)**
```
| Item | ΔG° | Status |
| Unfavorable step alone | > 0 | Still unfavorable |
| Favorable step alone | < 0 | Favored |
| Coupled net process | Sum of the two | Favored only if the sum < 0 |
```

**Score: steps (how_this_becomes_points)**
```
1. Identify the steps and the shared intermediate.
2. Add their ΔG° values for the net process.
3. Call the net process favored only if the sum is negative; the unfavorable step is still unfavorable alone.
```

**Score: Weak (common_point_loss)**
```
Weak: “No, because one step is positive.” It skips step 2: it never adds the ΔG° values.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Two coupled steps: +20 and −35 kJ/mol. (2) Net ΔG = +20 + (−35) = −15 kJ/mol. (3) The net is negative, so the coupled overall process is thermodynamically favored.
```

**Link (practice_bridge)**
```
Topic 9.8 applies the external-energy case: an electrolytic cell drives an unfavorable reaction.
```

## 9.8 Galvanic and Electrolytic Cells

**Know: core_idea**
```
- Oxidation at the anode and reduction at the cathode, in galvanic and electrolytic cells alike.
- Galvanic: favored reaction. Electrolytic: unfavored, needs an applied potential.
- Not assessed: positive/negative electrode labeling.
```

**Know: mechanism (what_students_need_to_understand)**
```
| Component | Role |
| Anode | Oxidation; mass loss or gas evolution can occur |
| Cathode | Reduction; mass gain or gas evolution can occur |
| Half-cell solutions | Contain each half-reaction's species |
| Salt bridge | Lets ions flow between half-cells |
```

**Score: steps (how_this_becomes_points)**
```
1. Write each half-reaction and mark which loses electrons.
2. Label oxidation the anode and reduction the cathode; do not go by charge labels or a role from an earlier part.
```

**Score: Weak (common_point_loss)**
```
Weak: “At the electrode labeled positive.” It skips step 2: it assigns the anode by a charge label, not by oxidation.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Oxidation is the half-reaction in which electrons are lost. (2) It occurs at the anode, in both galvanic and electrolytic cells; reduction occurs at the cathode.
```

**Link (practice_bridge)**
```
Topic 9.9 uses these roles to choose the half-cells and find E°.
```

**Remember it (hook, unchanged)**
```
An Ox, Red Cat
```

## 9.9 Cell Potential and Free Energy

**Know: core_idea**
```
- E°cell = E°(cathode) − E°(anode), both as reduction potentials.
- ΔG° = −nFE°.
- E° > 0: thermodynamically favored; E° < 0: unfavored.
```

**Know: mechanism (what_students_need_to_understand)**
```
Opposite signs of E° and ΔG°:

| E° | ΔG° | K |
| > 0 | < 0 | > 1 |
| < 0 | > 0 | < 1 |
```

**Score: steps (how_this_becomes_points)**
```
1. For a galvanic cell, take the reduction with the greater reduction potential as the cathode, then subtract to get E°cell.
2. Use ΔG° = −nFE° to write the sign of ΔG° (opposite to E°).
```

**Score: Weak (common_point_loss)**
```
Weak: “Positive, because both indicate a strong reaction.” It skips step 2: ΔG° = −nFE° makes ΔG° the opposite sign to E°.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) For a galvanic pairing, the greater reduction potential is the cathode and E°cell is positive. (2) n and F are positive, so ΔG° = −nFE° is negative: the reaction is thermodynamically favored.
```

**Link (practice_bridge)**
```
Topic 9.10 shows how E moves away from E° as Q changes.
```

**Remember it (hook, unchanged)**
```
An Ox, Red Cat
```

## 9.10 Cell Potential under Nonstandard Conditions

**Know: core_idea**
```
- E = E° − (RT/nF) ln Q.
- Standard conditions: Q = 1, so E = E°.
- At equilibrium: Q = K and E = 0.
```

**Know: mechanism (what_students_need_to_understand)**
```
| Q | Cell | E |
| Q = 1 | Same Q as at standard conditions | E = E° |
| Moves toward K | Closer to equilibrium | E falls in size toward 0 |
| Moves farther from K than 1 | Farther from equilibrium | E larger in size than E° |
| Q = K | At equilibrium | E = 0 |
```

**Score: steps (how_this_becomes_points)**
```
1. Say how the concentrations change Q.
2. Say whether the cell is closer to or farther from equilibrium (Q versus K).
3. State the effect on E; do not use Le Chatelier shift language.
```

**Score: Weak (common_point_loss)**
```
Weak: “It increases because more products are present.” It breaks step 2: more products move Q toward K, closer to equilibrium, so the driving force shrinks.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) As the cell runs, products build and reactants are used, so Q rises toward K. (2) The cell is moving closer to equilibrium, (3) so its driving force is used up and E decreases toward zero (E = 0 at Q = K).
```

**Link (practice_bridge)**
```
E = 0 at Q = K is the electrochemical form of the equilibrium condition behind ΔG° = −RT ln K in topic 9.5.
```

## 9.11 Electrolysis and Faraday's Law

**Know: core_idea**
```
- I = q/t (amperes = coulombs per second).
- F ≈ 96,485 C per mole of electrons.
- Plating: reduction at the cathode; the ion's charge sets the electrons per atom plated.
```

**Know: mechanism (what_students_need_to_understand)**
```
Chain from what is given to what is asked:

| Convert | Using |
| Current, time → charge | q = I × t (t in seconds) |
| Charge → mol e⁻ | ÷ F |
| mol e⁻ → mol substance | Half-reaction ratio (mol e⁻ per mol substance) |
| mol substance → mass | × molar mass |
```

**Score: steps (how_this_becomes_points)**
```
1. Write the half-reaction; read mol e⁻ per mol of substance from it.
2. Run the chain in the table from the given quantity to the asked one.
```

**Score: Weak (common_point_loss)**
```
Weak: “One mole, because one mole of copper is made.” It skips step 1: it ignores that each Cu²⁺ must gain 2 electrons.
```

**Score: Full credit (answer_move)**
```
Full credit: (1) Cu²⁺ + 2e⁻ → Cu(s): 2 mol e⁻ per mol Cu. (2) So 1 mol Cu needs 2 mol e⁻ (about 2 × 96,485 ≈ 1.93×10⁵ C).
```

**Link (practice_bridge)**
```
The same chain works for any electrochemical cell once the half-reaction fixes mol e⁻ per mol of substance.
```

**Remember it (hook, unchanged)**
```
An Ox, Red Cat
```
