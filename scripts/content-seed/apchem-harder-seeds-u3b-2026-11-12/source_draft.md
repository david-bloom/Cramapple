# AP Chemistry topics 3.4 to 3.13: replacement seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Numbers were recomputed in Python (R = 0.0821 L·atm/(mol·K), h = 6.626 × 10⁻³⁴ J·s, c = 3.00 × 10⁸ m/s, Nₐ = 6.022 × 10²³ /mol). Data tables for solubility and gas constants are standard reference values, rounded.
Scope: replace the weak (mostly R1, one-step) families published for topics 3.4 to 3.13 and add at least two new seeds per topic. Teaching items (OHT and the flagged variants) are kept.
Target level: R3 reasoning where the setup, a representation or a data set is the difficulty, and each wrong choice is a real student error.

| Seed | Topic | Replaces |
|---|---|---|
| N-3.4-A | 3.4 Ideal gas law | apchem-mcq-008 family |
| N-3.4-B | 3.4 Ideal gas law | apchem-mcq-032 family |
| N-3.5-A | 3.5 Kinetic molecular theory | apchem-mcq-005 family |
| N-3.5-B | 3.5 Kinetic molecular theory | apchem-mcq-033 family |
| N-3.6-A | 3.6 Deviation from ideal gas law | apchem-mcq-034 family |
| N-3.6-B | 3.6 Deviation from ideal gas law | new |
| N-3.7-A | 3.7 Solutions and mixtures | apchem-mcq-039 family |
| N-3.7-B | 3.7 Solutions and mixtures | new |
| N-3.8-A | 3.8 Representations of solutions | new |
| N-3.8-B | 3.8 Representations of solutions | new |
| N-3.9-A | 3.9 Separation of solutions and mixtures | apchem-mcq-038 family |
| N-3.9-B | 3.9 Separation of solutions and mixtures | new |
| N-3.10-A | 3.10 Solubility | apchem-mcq-007 |
| N-3.10-B | 3.10 Solubility | apchem-mcq-035 family |
| N-3.11-A | 3.11 Spectroscopy and the electromagnetic spectrum | new |
| N-3.11-B | 3.11 Spectroscopy and the electromagnetic spectrum | new |
| N-3.12-A | 3.12 Photoelectric effect | apchem-mcq-037 family |
| N-3.12-B | 3.12 Photoelectric effect | new |
| N-3.13-A | 3.13 Beer-Lambert law | apchem-mcq-006 family |
| N-3.13-B | 3.13 Beer-Lambert law | apchem-mcq-036 family |

---

## Seed N-3.4-A (replaces 008 family) — Topic 3.4 Ideal Gas Law
**Skill:** change two gas variables at once and combine the pressure ratios, using kelvin temperatures.

A gas in a cylinder with a movable piston is at 1.0 atm, 300 K and 4.0 L. It is heated to 600 K while the piston is moved so that the volume becomes 8.0 L. No gas enters or leaves. What is the final pressure?

- A. 4.0 atm
- B. 2.0 atm
- **C. 1.0 atm**
- D. 0.25 atm

Check: P₂ = P₁ × (T₂/T₁) × (V₁/V₂) = 1.0 × 2 × 0.5 = 1.0 atm; the doubling of temperature is cancelled by the doubling of volume.
Rationales: A: 4.0 atm treats the doubled volume as if it also raised the pressure, so both factors of 2 are multiplied together. B: 2.0 atm accounts for the temperature increase only and ignores the larger volume, which lowers the pressure. D: 0.25 atm inverts the temperature relation as well, as if a hotter gas had a lower pressure.

**N-3.4-A-v1.** A gas at 2.0 atm and 27°C occupies 3.0 L in a cylinder with a movable piston. It is heated to 177°C and the piston is pushed in until the volume is 2.4 L. No gas leaves. What is the final pressure?

- A. 2.5 atm
- **B. 3.75 atm**
- C. 3.0 atm
- D. 16 atm

Check: T₁ = 300 K and T₂ = 450 K, so P₂ = 2.0 × (450/300) × (3.0/2.4) = 2.0 × 1.5 × 1.25 = 3.75 atm.
Rationales: A: 2.5 atm accounts for the volume compression only and ignores that the gas was heated. C: 3.0 atm accounts for the temperature increase only and ignores the compression. D: 16 atm uses the Celsius temperatures 177 and 27 instead of kelvin, which overstates the temperature ratio.

**N-3.4-A-v2.** A 12.0 L sample of gas at 1.50 atm and 27°C is compressed to 4.0 L while it is cooled to -73°C. No gas leaves. What is the final pressure?

- A. 1.0 atm
- B. 4.5 atm
- C. 0.75 atm
- **D. 3.0 atm**

Check: T₁ = 300 K and T₂ = 200 K, so P₂ = 1.50 × (200/300) × (12.0/4.0) = 1.50 × 0.667 × 3 = 3.0 atm.
Rationales: A: 1.0 atm uses only the temperature ratio and forgets that the volume fell to one third. B: 4.5 atm uses only the volume ratio and forgets that cooling lowers the pressure. C: 0.75 atm inverts the volume ratio and the temperature ratio, so the pressure falls when the gas is compressed.

**N-3.4-A-v3.** A gas at 3.0 atm, 400 K and 6.0 L is allowed to expand to 9.0 L while its temperature is lowered to 300 K. No gas enters or leaves. What is the final pressure?

- **A. 1.5 atm**
- B. 2.25 atm
- C. 2.0 atm
- D. 3.4 atm

Check: P₂ = 3.0 × (300/400) × (6.0/9.0) = 3.0 × 0.75 × 0.667 = 1.5 atm.
Rationales: B: 2.25 atm accounts for the cooling only and ignores the expansion, which also lowers the pressure. C: 2.0 atm accounts for the expansion only and ignores the cooling. D: 3.4 atm applies the volume ratio upside down (9.0/6.0), so it says the pressure rises when the gas expands.

---

## Seed N-3.4-B (replaces 032 family) — Topic 3.4 Ideal Gas Law
**Skill:** work with moles, not grams, when finding a partial pressure in a gas mixture.

A rigid 10.0 L vessel at 300 K holds 4.0 g of H₂ (2.0 g/mol) and 32.0 g of O₂ (32.0 g/mol). Use R = 0.0821 L·atm/(mol·K). What is the partial pressure of O₂?

- **A. 2.46 atm**
- B. 6.57 atm
- C. 7.39 atm
- D. 3.69 atm

Check: n(O₂) = 32.0/32.0 = 1.00 mol; P = nRT/V = 1.00 × 0.0821 × 300 / 10.0 = 2.46 atm. (n(H₂) = 2.0 mol, total pressure 7.39 atm.)
Rationales: B: 6.57 atm uses the mass fraction of O₂ (32/36) of the total pressure, but pressure fractions follow mole fractions, and H₂ has twice as many moles. C: 7.39 atm is the total pressure of both gases, not the share due to O₂. D: 3.69 atm assumes the two gases split the pressure equally, which would need equal numbers of moles.

**N-3.4-B-v1.** A rigid 5.00 L tank at 350 K holds 8.0 g of He (4.0 g/mol) and 28.0 g of N₂ (28.0 g/mol). Use R = 0.0821 L·atm/(mol·K). What is the partial pressure of N₂?

- A. 17.2 atm
- B. 13.4 atm
- **C. 5.75 atm**
- D. 8.62 atm

Check: n(He) = 2.0 mol and n(N₂) = 1.0 mol; P(N₂) = 1.0 × 0.0821 × 350 / 5.00 = 5.75 atm (total 17.2 atm).
Rationales: A: 17.2 atm is the total pressure of the mixture, not the part due to N₂. B: 13.4 atm uses the mass fraction of N₂ (28/36), but N₂ is only one third of the moles. D: 8.62 atm splits the total pressure equally between the two gases.

**N-3.4-B-v2.** A rigid vessel at 300 K holds 2.0 g of H₂ (2.0 g/mol) and 16.0 g of CH₄ (16.0 g/mol). Which comparison of the partial pressures is correct?

- A. CH₄ has a partial pressure 8 times that of H₂, because its mass is 8 times as large.
- **B. The partial pressures are essentially equal, because each gas is present at about 1 mol.**
- C. H₂ has the greater partial pressure, because its molecules are faster.
- D. H₂ has the greater partial pressure, because lighter molecules take up less space.

Check: n(H₂) = 2.0/2.0 = 1.0 mol and n(CH₄) = 16.0/16.0 = 1.0 mol; same T and V, so equal partial pressures.
Rationales: A: pressure follows the number of moles, not the mass, and the mass ratio of 8 is cancelled by the molar mass ratio of 8. C: H₂ molecules are faster, but they are also lighter, so each collision transfers less momentum, and the effects cancel at equal moles. D: in an ideal gas the molecular size is ignored, so the size of the molecules does not set the partial pressure.

**N-3.4-B-v3.** A rigid container holds 7.0 g of N₂ (28 g/mol) and 4.0 g of He (4.0 g/mol). The total pressure is 3.00 atm. What is the partial pressure of He?

- A. 1.09 atm
- B. 1.50 atm
- C. 0.60 atm
- **D. 2.40 atm**

Check: n(N₂) = 7.0/28 = 0.25 mol; n(He) = 4.0/4.0 = 1.0 mol; mole fraction of He = 1.0/1.25 = 0.80; P(He) = 0.80 × 3.00 = 2.40 atm.
Rationales: A: 1.09 atm uses the mass fraction of He (4/11) as the pressure fraction, instead of the mole fraction. B: 1.50 atm splits the total pressure equally between the two gases. C: 0.60 atm is the partial pressure of N₂, the other gas, so the wrong gas was chosen.

---

## Seed N-3.5-A (replaces 005 family) — Topic 3.5 Kinetic Molecular Theory
**Skill:** read a Maxwell-Boltzmann speed distribution as fractions of molecules, not as a single speed.

A sample of N₂(g) at 300 K has 10% of its molecules moving faster than 700 m/s. The sample is heated to 450 K in a rigid container. Which statement about the heated sample is correct?

- A. Fewer than 10% of the molecules move faster than 700 m/s, because the distribution becomes broader and flatter.
- B. Exactly 10% of the molecules move faster than 700 m/s, because that fraction depends only on the gas, not on temperature.
- **C. More than 10% of the molecules move faster than 700 m/s, and some molecules still move more slowly than the average speed at 300 K.**
- D. More than 10% of the molecules move faster than 700 m/s, and no molecule moves more slowly than the average speed at 300 K.

Check: raising T shifts the whole distribution to higher speeds, so the fraction above a fixed speed grows; the distribution still has a low-speed tail, so some molecules are slower than the old average.
Rationales: A: a broader and flatter curve still has more area at high speeds, so the fraction above 700 m/s grows with temperature. B: the fraction above a fixed speed depends strongly on temperature, because only the average kinetic energy scales simply. D: temperature raises the average, but the distribution always keeps a tail of slow molecules, so a few molecules are still slower than the old average.

**N-3.5-A-v1.** At 200 K, 15% of the Ar atoms in a sample move more slowly than 150 m/s. The sample is heated to 400 K in a rigid container. Which statement about the heated sample is correct?

- **A. Fewer than 15% move more slowly than 150 m/s, and the average kinetic energy doubles.**
- B. Fewer than 15% move more slowly than 150 m/s, and the average speed doubles.
- C. More than 15% move more slowly than 150 m/s, because collisions slow some atoms down.
- D. Exactly 15% move more slowly than 150 m/s, and the average kinetic energy doubles.

Check: heating shifts the distribution upward, so the fraction below a fixed low speed falls; average kinetic energy is proportional to T, so it doubles, while the average speed rises only by a factor of √2.
Rationales: B: average speed is proportional to the square root of T, so doubling T raises the speed by about 1.41, not 2. C: more collisions at higher temperature exchange energy but do not change the overall trend, and the average speed rises, so the slow fraction falls. D: the slow fraction cannot stay fixed while the whole distribution moves to higher speed.

**N-3.5-A-v2.** He(g) and Ne(g) are in separate containers at the same temperature, 300 K. Which statement correctly compares their speeds?

- A. Every He atom moves faster than every Ne atom, because He atoms are lighter.
- B. The fraction of atoms above any given speed is the same for both gases, because the average kinetic energies are equal.
- C. A larger fraction of Ne atoms than He atoms moves faster than any chosen speed, because Ne atoms have more momentum.
- **D. A larger fraction of He atoms than Ne atoms moves faster than any chosen high speed, although the distributions overlap so some Ne atoms are faster than some He atoms.**

Check: equal T gives equal average KE; He is lighter so its distribution is shifted to higher speeds, but both are broad curves that overlap.
Rationales: A: the distributions overlap, so the fastest Ne atoms move faster than the slowest He atoms. B: equal average kinetic energy does not give equal speeds, because lighter atoms need a higher speed to have the same energy. C: momentum differences do not raise speeds; at equal energy the heavier atoms move more slowly.

**N-3.5-A-v3.** The speed distribution of CO₂(g) at 300 K is compared with that of the same sample of CO₂(g) at 600 K. Which description of the 600 K curve, relative to the 300 K curve, is correct?

- A. The peak is higher and narrower, because the molecules are more energetic and more alike.
- **B. The peak is lower, broader and at a higher speed, and the area under the curve is the same.**
- C. The peak is at the same speed but taller, because more molecules reach that speed.
- D. The peak is at a higher speed with the same height, and the area is larger because the molecules are more energetic.

Check: heating moves the most probable speed up, spreads the speeds over a wider range, so the peak lowers; the number of molecules, and so the area, is unchanged.
Rationales: A: a wider range of speeds means a lower, broader curve, not a narrower one. C: the most probable speed rises with temperature, so the peak moves. D: the area under the curve represents the total number of molecules, which does not change when the gas is heated.

---

## Seed N-3.5-B (replaces 033 family) — Topic 3.5 Kinetic Molecular Theory
**Skill:** separate collision frequency, momentum per collision and speed when explaining gas pressure.

Two rigid 2.0 L flasks at 300 K each hold 1.0 mol of gas. One holds He and the other holds Ar. Their pressures are equal. Which statement best explains this using kinetic molecular theory?

- A. The He atoms are faster, so they hit the walls harder and the pressure should be higher, but Ar atoms are heavier, which makes up the difference.
- B. The Ar atoms are heavier, so they have more kinetic energy and make a higher pressure than He.
- C. Both gases have the same average speed at the same temperature, so the pressures are equal.
- **D. The He atoms hit the walls more often, but each collision transfers less momentum, so the pressure is the same.**

Check: same T gives the same average KE; He is lighter and faster, so more collisions per second, each with a smaller momentum change; with equal n, V, T the pressures are equal.
Rationales: A: the equality does come from a balance between speed and mass, but the pressure is not higher for He, because the two effects exactly cancel; the statement contradicts the given equal pressures. B: the average kinetic energy depends only on temperature, so Ar atoms do not have more kinetic energy. C: at the same temperature lighter atoms are faster, so the average speeds are not the same.

**N-3.5-B-v1.** A rigid container of Ne(g) is heated from 300 K to 600 K. The pressure doubles. Which statement best explains the doubling?

- A. The average speed doubles, so the pressure doubles.
- **B. The atoms strike the walls about √2 times as often and with about √2 times the momentum per collision.**
- C. The atoms strike the walls twice as often, with the same momentum per collision.
- D. The atoms strike the walls at the same rate, but the momentum per collision doubles.

Check: speed ∝ √T, so doubling T raises the speed by √2; collision frequency ∝ speed and momentum per collision ∝ speed, so pressure ∝ speed² ∝ T, which doubles.
Rationales: A: the average speed rises by √2, not by a factor of 2; the pressure doubles because speed enters twice. C: the collision frequency rises by √2 only, and the momentum per collision also rises. D: faster atoms also reach the walls more often, so the collision rate does not stay the same.

**N-3.5-B-v2.** A sample of gas in a cylinder is compressed to half its volume at constant temperature, and the pressure doubles. Which statement best explains the pressure change?

- **A. The collisions with the walls become twice as frequent per unit area, while the average speed is unchanged.**
- B. The average speed of the molecules doubles because the molecules are closer together.
- C. The average kinetic energy of the molecules doubles because work was done on the gas.
- D. The momentum transferred per collision doubles because the molecules are squeezed together.

Check: constant T means the same average KE and speed; half the volume means twice the number density, so twice as many collisions per second per unit wall area.
Rationales: B: speed depends on temperature, and the temperature is constant. C: at constant temperature the work is released as heat to the surroundings and the average kinetic energy stays the same. D: momentum per collision depends on the speed and mass, both unchanged here.

**N-3.5-B-v3.** At 400 K, samples of He (4.00 g/mol) and CH₄ (16.0 g/mol) are compared. Which choice gives the correct ratios, He to CH₄, for average speed and for average kinetic energy?

- A. Speed ratio 4 : 1; kinetic energy ratio 1 : 1
- B. Speed ratio 2 : 1; kinetic energy ratio 4 : 1
- **C. Speed ratio 2 : 1; kinetic energy ratio 1 : 1**
- D. Speed ratio 1 : 1; kinetic energy ratio 1 : 1

Check: average speed ∝ √(1/M), so the ratio is √(16.0/4.00) = 2; average KE depends only on T, so the ratio is 1.
Rationales: A: the speed ratio is the square root of the molar mass ratio, so 4 comes from leaving out the square root. B: the kinetic energy depends on temperature only, so squaring the speed ratio while ignoring the masses is wrong. D: equal temperature gives equal kinetic energy, not equal speed, because the masses differ.

---

## Seed N-3.6-A (replaces 034 family) — Topic 3.6 Deviation from Ideal Gas Law
**Skill:** use a measured compressibility value to find the real volume and decide whether attractions or particle volume dominate.

At 300 K and 100 atm, 1.00 mol of CH₄ has Z = PV/(nRT) = 0.87. Use R = 0.0821 L·atm/(mol·K) and V = Z·nRT/P. What is the measured volume, and what does the result show?

- A. 0.246 L; CH₄ behaves ideally at this pressure.
- **B. 0.214 L; attractions between CH₄ molecules pull them closer, so the volume is smaller than the ideal value.**
- C. 0.283 L; the volume of the CH₄ molecules makes the volume larger than the ideal value.
- D. 0.214 L; the volume of the CH₄ molecules makes the real volume smaller than the ideal value.

Check: ideal V = 1.00 × 0.0821 × 300 / 100 = 0.246 L; real V = 0.87 × 0.246 = 0.214 L; Z < 1 indicates attractions.
Rationales: A: ideal behavior would give Z = 1.00, and 0.246 L is the ideal volume, not the measured one. C: a volume above ideal would need Z greater than 1, which is the sign of particle volume, but Z is 0.87 here. D: the number is right, but molecular volume would increase the real volume; the smaller volume comes from attractions.

**N-3.6-A-v1.** At 300 K and 100 atm, 1.00 mol of He has Z = PV/(nRT) = 1.06. Use R = 0.0821 L·atm/(mol·K) and V = Z·nRT/P. What is the measured volume, and what does the result show?

- A. 0.246 L; He behaves ideally because it is a noble gas.
- B. 0.232 L; attractions between He atoms make the volume smaller than the ideal value.
- C. 0.261 L; attractions between He atoms make the volume larger than the ideal value.
- **D. 0.261 L; the volume of the He atoms themselves becomes significant, so the real volume is larger than the ideal value.**

Check: ideal V = 0.246 L; real V = 1.06 × 0.246 = 0.261 L; Z > 1 means the finite size of the atoms dominates because He attractions are very weak.
Rationales: A: a noble gas still deviates at 100 atm, and Z = 1.06 is not 1. B: a smaller volume would need Z < 1, and He has almost no attractions. C: attractions pull the molecules together and make the volume smaller, so they cannot explain a larger volume.

**N-3.6-A-v2.** A 1.00 mol sample of gas in a 0.500 L rigid container at 300 K has a measured pressure of 44 atm. Use R = 0.0821 L·atm/(mol·K). What is the ideal pressure, and what does the comparison show?

- **A. 49.3 atm; the measured pressure is lower, which points to attractions between the molecules.**
- B. 24.6 atm; the measured pressure is higher, which points to the volume of the molecules.
- C. 49.3 atm; the measured pressure is lower, which points to the volume of the molecules.
- D. 12.3 atm; the measured pressure is higher, which points to the volume of the molecules.

Check: P(ideal) = 1.00 × 0.0821 × 300 / 0.500 = 49.3 atm; 44 < 49.3, so attractions reduce the force of collisions with the walls.
Rationales: B: 24.6 atm forgets to divide by the 0.500 L volume, which then makes the measured value look high. C: the ideal pressure is right, but molecular volume would raise the pressure above ideal, not lower it. D: 12.3 atm multiplies by the volume instead of dividing by it.

**N-3.6-A-v3.** A 2.00 mol sample of H₂ in a 1.00 L rigid container at 300 K has a measured pressure of 52.5 atm. Use R = 0.0821 L·atm/(mol·K). What is the ideal pressure, and what does the comparison show?

- A. 24.6 atm; the measured pressure is higher, which points to the volume of the molecules.
- B. 49.3 atm; the measured pressure is higher, which points to attractions between the molecules.
- **C. 49.3 atm; the measured pressure is higher, which points to the volume of the molecules.**
- D. 98.5 atm; the measured pressure is lower, which points to attractions between the molecules.

Check: P(ideal) = 2.00 × 0.0821 × 300 / 1.00 = 49.3 atm; 52.5 > 49.3, so the finite volume of the molecules leaves less free space and raises the pressure.
Rationales: A: 24.6 atm uses 1.00 mol instead of 2.00 mol. B: attractions would lower the pressure below the ideal value, not raise it. D: 98.5 atm doubles the amount twice, and the lower-pressure conclusion would not match 52.5 atm anyway.

---

## Seed N-3.6-B (new) — Topic 3.6 Deviation from Ideal Gas Law
**Skill:** judge which gas sample deviates most from ideal behavior from its conditions and intermolecular forces.

Which sample of gas is expected to deviate most from ideal gas behavior, and why?

- A. Ar at 600 K and 1.0 atm, because Ar has the largest atoms of the four samples.
- B. H₂ at 300 K and 10 atm, because it is at the highest pressure.
- **C. NH₃ at 250 K and 1.0 atm, because it is only about 10 K above its boiling point (240 K) and its molecules attract each other strongly.**
- D. CH₄ at 400 K and 1.0 atm, because CH₄ is nonpolar, so its molecules attract strongly.

Check: deviation is greatest when the gas is close to condensing (low T, strong attractions) or at high pressure; H₂ has very weak attractions and ten atm is modest, while Ar at 600 K and CH₄ at 400 K at 1 atm are hot, low-pressure samples.
Rationales: A: at 600 K and 1 atm the atoms are fast and far apart, so Ar behaves very nearly ideally. B: ten atm is modest, and H₂ has very weak attractions and tiny molecules, so it stays close to ideal. D: nonpolar molecules have only weak dispersion forces, and at 400 K and 1 atm CH₄ is far above its boiling point.

**N-3.6-B-v1.** Which sample of gas is expected to deviate most from ideal gas behavior, and why?

- **A. SO₂ at 280 K and 1.0 atm, because it is only about 17 K above its boiling point (263 K) and its polar molecules attract each other.**
- B. Ne at 300 K and 20 atm, because 20 atm is the highest pressure listed.
- C. N₂ at 500 K and 5.0 atm, because it has the largest number of molecules.
- D. He at 150 K and 1.0 atm, because it is the coldest sample.

Check: SO₂ is a polar gas just above its boiling point, so its attractions are important; Ne, N₂ and He are weakly attracting and the conditions are far from condensation.
Rationales: B: Ne attractions are extremely weak, and 20 atm at 300 K does not bring the atoms close enough for large deviations. C: the number of molecules is not a measure of deviation, and N₂ at 500 K is fast and weakly attracting. D: He has the weakest attractions of any gas, and 150 K is far above its boiling point of 4 K.

**N-3.6-B-v2.** Carbon dioxide has a critical temperature of 304 K. Under which conditions does CO₂ deviate most from ideal gas behavior, and why?

- A. 500 K and 2.0 atm, because the gas is hot and the molecules are far apart.
- B. 400 K and 1.0 atm, because the pressure is lowest at this temperature.
- C. 600 K and 0.50 atm, because the molecules are moving fastest.
- **D. 310 K and 50 atm, because the molecules are close together and slow enough for attractions to matter, near the point where CO₂ condenses.**

Check: deviations grow at high pressure and at temperatures near condensation; 310 K is just above the critical temperature and 50 atm packs the molecules together.
Rationales: A: hot and fairly dilute conditions make CO₂ nearly ideal. B: low pressure and high temperature give nearly ideal behavior, since the molecules rarely interact. C: fast molecules at low pressure are the ideal case; fast motion reduces the effect of attractions.

**N-3.6-B-v3.** Ethane (C₂H₆, 30.1 g/mol) boils at 185 K and nitric oxide (NO, 30.0 g/mol) boils at 121 K. Each gas is at 200 K and 1.0 atm. Which statement is correct?

- A. NO deviates more, because its lower boiling point means weaker bonds in the molecule.
- **B. Ethane deviates more, because its higher boiling point shows stronger attractions between molecules, and 200 K is only 15 K above that boiling point.**
- C. The two gases deviate equally, because their molar masses are almost the same.
- D. Neither gas deviates, because 1.0 atm is a low pressure.

Check: a higher boiling point reflects stronger intermolecular attractions; at 200 K ethane is much closer to condensing than NO.
Rationales: A: boiling points reflect forces between molecules, not the strength of the bonds inside them. C: equal molar mass does not mean equal intermolecular attractions, and the boiling points differ by 64 K. D: low pressure reduces deviation but does not remove it, and ethane at 200 K is close to condensation.

---

## Seed N-3.7-A (replaces 039 family) — Topic 3.7 Solutions and Mixtures
**Skill:** find an ion concentration after mixing two solutions, using moles of the ion and the total volume.

A student mixes 150.0 mL of 0.200 M NaCl(aq) with 100.0 mL of 0.300 M CaCl₂(aq). Assume the volumes are additive and both salts dissociate completely. What is the concentration of Cl⁻ in the mixture?

- A. 0.240 M
- **B. 0.360 M**
- C. 0.400 M
- D. 0.600 M

Check: mol Cl⁻ = 0.1500 × 0.200 + 2 × 0.1000 × 0.300 = 0.0300 + 0.0600 = 0.0900 mol; total volume 0.2500 L; 0.0900/0.2500 = 0.360 M.
Rationales: A: 0.240 M counts only one Cl⁻ for each formula unit, so the two Cl⁻ in each CaCl₂ are missed. C: 0.400 M averages the Cl⁻ concentrations of the two solutions (0.200 and 0.600) without weighting by volume. D: 0.600 M is the Cl⁻ concentration of the CaCl₂ solution before mixing, and ignores the NaCl and the dilution.

**N-3.7-A-v1.** A student mixes 200.0 mL of 0.150 M Na₂SO₄(aq) with 300.0 mL of 0.100 M NaNO₃(aq). Assume the volumes are additive and both salts dissociate completely. What is the concentration of Na⁺ in the mixture?

- A. 0.120 M
- B. 0.200 M
- C. 0.400 M
- **D. 0.180 M**

Check: mol Na⁺ = 2 × 0.2000 × 0.150 + 0.3000 × 0.100 = 0.0600 + 0.0300 = 0.0900 mol; total volume 0.5000 L; 0.0900/0.5000 = 0.180 M.
Rationales: A: 0.120 M counts one Na⁺ per formula unit of Na₂SO₄, so the factor of 2 is missed. B: 0.200 M averages the Na⁺ concentrations (0.300 M and 0.100 M) without weighting by volume. C: 0.400 M adds the two Na⁺ concentrations and ignores that mixing dilutes both.

**N-3.7-A-v2.** A student mixes 100.0 mL of 0.100 M Al(NO₃)₃(aq) with 150.0 mL of 0.200 M KNO₃(aq). Assume the volumes are additive and both salts dissociate completely. What is the concentration of NO₃⁻ in the mixture?

- **A. 0.240 M**
- B. 0.160 M
- C. 0.250 M
- D. 0.500 M

Check: mol NO₃⁻ = 3 × 0.1000 × 0.100 + 0.1500 × 0.200 = 0.0300 + 0.0300 = 0.0600 mol; total volume 0.2500 L; 0.0600/0.2500 = 0.240 M.
Rationales: B: 0.160 M counts one NO₃⁻ per formula unit of Al(NO₃)₃, so the factor of 3 is missed. C: 0.250 M averages the NO₃⁻ concentrations (0.300 M and 0.200 M) without weighting by volume. D: 0.500 M adds the two NO₃⁻ concentrations and ignores the dilution on mixing.

**N-3.7-A-v3.** A student mixes 75.0 mL of 0.200 M MgCl₂(aq) with 125.0 mL of 0.0800 M AlCl₃(aq). Assume the volumes are additive and both salts dissociate completely. What is the concentration of Cl⁻ in the mixture?

- A. 0.125 M
- B. 0.320 M
- **C. 0.300 M**
- D. 0.640 M

Check: mol Cl⁻ = 2 × 0.0750 × 0.200 + 3 × 0.125 × 0.0800 = 0.0300 + 0.0300 = 0.0600 mol; total volume 0.2000 L; 0.0600/0.2000 = 0.300 M.
Rationales: A: 0.125 M counts one Cl⁻ per formula unit, so the subscripts 2 and 3 are missed. B: 0.320 M averages the Cl⁻ concentrations (0.400 M and 0.240 M) without weighting by volume. D: 0.640 M adds the two Cl⁻ concentrations and ignores the dilution on mixing.

---

## Seed N-3.7-B (new) — Topic 3.7 Solutions and Mixtures
**Skill:** follow a two-step serial dilution, using the final volume at each step rather than the water added.

A stock solution is 0.500 M. A 10.0 mL portion of the stock is diluted with water to a final volume of 100.0 mL (solution 1). Then 20.0 mL of solution 1 is diluted with water to a final volume of 50.0 mL (solution 2). What is the molarity of solution 2?

- A. 0.0500 M
- B. 0.200 M
- C. 0.0143 M
- **D. 0.0200 M**

Check: solution 1 = 0.500 × 10.0/100.0 = 0.0500 M; solution 2 = 0.0500 × 20.0/50.0 = 0.0200 M.
Rationales: A: 0.0500 M is the concentration of solution 1, and the second dilution was left out. B: 0.200 M applies the second dilution to the 0.500 M stock and skips the first dilution. C: 0.0143 M treats 50.0 mL as water added, giving 20.0 mL out of 70.0 mL.

**N-3.7-B-v1.** A 1.20 M stock solution is used. A 5.00 mL portion of stock is diluted to a final volume of 250.0 mL (solution 1). Then 10.0 mL of solution 1 is diluted to a final volume of 100.0 mL (solution 2). What is the molarity of solution 2?

- A. 0.0240 M
- B. 0.120 M
- **C. 0.00240 M**
- D. 0.00218 M

Check: solution 1 = 1.20 × 5.00/250.0 = 0.0240 M; solution 2 = 0.0240 × 10.0/100.0 = 0.00240 M.
Rationales: A: 0.0240 M is the concentration of solution 1, and the second dilution was left out. B: 0.120 M applies the second dilution to the stock and skips the first dilution. D: 0.00218 M treats 100.0 mL as water added, giving 10.0 mL out of 110.0 mL.

**N-3.7-B-v2.** A 0.400 M stock solution is used. A 25.0 mL portion of stock is diluted to a final volume of 500.0 mL (solution 1). Then 50.0 mL of solution 1 is diluted to a final volume of 200.0 mL (solution 2). What is the molarity of solution 2?

- A. 0.0200 M
- **B. 0.00500 M**
- C. 0.100 M
- D. 0.00400 M

Check: solution 1 = 0.400 × 25.0/500.0 = 0.0200 M; solution 2 = 0.0200 × 50.0/200.0 = 0.00500 M.
Rationales: A: 0.0200 M is the concentration of solution 1, and the second dilution was left out. C: 0.100 M applies the second dilution to the stock and skips the first dilution. D: 0.00400 M treats 200.0 mL as water added, giving 50.0 mL out of 250.0 mL.

**N-3.7-B-v3.** A 2.00 M stock solution is used. A 1.00 mL portion of stock is diluted to a final volume of 100.0 mL (solution 1). Then 5.00 mL of solution 1 is diluted to a final volume of 250.0 mL (solution 2). What is the molarity of solution 2?

- **A. 4.00 × 10⁻⁴ M**
- B. 0.0200 M
- C. 0.0400 M
- D. 1.00 × 10⁻³ M

Check: solution 1 = 2.00 × 1.00/100.0 = 0.0200 M; solution 2 = 0.0200 × 5.00/250.0 = 4.00 × 10⁻⁴ M.
Rationales: B: 0.0200 M is the concentration of solution 1, and the second dilution was left out. C: 0.0400 M applies the second dilution (5.00/250.0) directly to the 2.00 M stock and skips the first dilution. D: 1.00 × 10⁻³ M uses 100.0 mL instead of 250.0 mL as the final volume of the second dilution.

---

## Seed N-3.8-A (new) — Topic 3.8 Representations of Solutions
**Skill:** decide what a correct particulate drawing of a dissolved ionic compound must show (ion ratio, intact polyatomic ions, water orientation).

A student draws a particulate model of 3 formula units of CaCl₂ dissolved in water. Which description of the drawing is correct?

- A. Three intact CaCl₂ units, each surrounded by water molecules with the O atoms pointing toward the unit.
- **B. Three Ca²⁺ ions and six Cl⁻ ions, separated; water molecules around each Ca²⁺ point their O atoms toward the ion and water molecules around each Cl⁻ point their H atoms toward the ion.**
- C. Three Ca²⁺ ions and six Cl⁻ ions, separated; water molecules around each Ca²⁺ point their H atoms toward the ion and water molecules around each Cl⁻ point their O atoms toward the ion.
- D. Three Ca²⁺ ions and three Cl⁻ ions, separated; water molecules around each Ca²⁺ point their O atoms toward the ion and around each Cl⁻ point their H atoms toward the ion.

Check: CaCl₂ is an ionic compound that dissociates into 1 Ca²⁺ and 2 Cl⁻ per unit; the partial negative O of water is attracted to cations and the partial positive H is attracted to anions.
Rationales: A: ionic solids dissociate in water, so the solution has separated ions and not intact units. C: the orientation is reversed, since the partially negative O atoms are attracted to the positive ions. D: each CaCl₂ unit gives two Cl⁻ ions, so three units must show six Cl⁻ for the charges to balance.

**N-3.8-A-v1.** A student draws a particulate model of 2 formula units of Al(NO₃)₃ dissolved in water. Which description of the drawing is correct?

- **A. Two Al³⁺ ions and six NO₃⁻ ions, separated and with each NO₃⁻ intact; water O atoms point toward the Al³⁺ ions and water H atoms point toward the NO₃⁻ ions.**
- B. Two Al³⁺ ions, six N atoms and eighteen O atoms, all separated, each surrounded by water molecules.
- C. Two Al³⁺ ions and two NO₃⁻ ions, separated; water O atoms point toward Al³⁺ and H atoms point toward NO₃⁻.
- D. Two Al³⁺ ions and six NO₃⁻ ions, separated; water H atoms point toward the Al³⁺ ions and water O atoms point toward the NO₃⁻ ions.

Check: Al(NO₃)₃ gives 1 Al³⁺ and 3 NO₃⁻ per unit; the polyatomic nitrate ion stays intact in solution; water orients O toward cations and H toward anions.
Rationales: B: the covalent bonds inside nitrate are not broken when the salt dissolves, so N and O atoms are not drawn separately. C: each Al(NO₃)₃ unit supplies three nitrate ions, so two units must show six nitrate ions. D: the orientation is reversed, since the partially negative O atoms are attracted to the positive Al³⁺.

**N-3.8-A-v2.** A student draws a particulate model of 4 formula units of Na₂SO₄ dissolved in water. Which description of the drawing is correct?

- A. Eight Na⁺ ions, four S atoms and sixteen O atoms, all separated, each surrounded by water molecules.
- B. Four Na⁺ ions and four SO₄²⁻ ions, separated; water O atoms point toward the SO₄²⁻ ions.
- **C. Eight Na⁺ ions and four intact SO₄²⁻ ions, separated; water O atoms point toward the Na⁺ ions and water H atoms point toward the SO₄²⁻ ions.**
- D. Four intact Na₂SO₄ units, each surrounded by water molecules hydrogen bonded to the O atoms of the sulfate.

Check: Na₂SO₄ gives 2 Na⁺ and 1 SO₄²⁻ per unit, so 4 units give 8 Na⁺ and 4 SO₄²⁻, with sulfate intact; water O toward Na⁺, water H toward SO₄²⁻.
Rationales: A: sulfate is a polyatomic ion whose atoms stay bonded together in solution. B: the charges do not balance, since four Na⁺ and four SO₄²⁻ have a net charge of -4, and each unit supplies two Na⁺. D: Na₂SO₄ is ionic and dissociates in water, so intact units would not be drawn.

**N-3.8-A-v3.** A student draws a particulate model of 4 molecules of glucose, C₆H₁₂O₆, dissolved in water. Glucose is a molecular compound with several O-H groups. Which description of the drawing is correct?

- A. Four glucose molecules broken into separate C, H and O atoms spread through the water.
- B. Four C₆H₁₁O₆⁻ ions and four H⁺ ions, separated, because glucose has O-H groups.
- C. Four glucose molecules clumped into one cluster with water molecules around the outside.
- **D. Four intact glucose molecules, separated from each other, each with water molecules hydrogen bonded to its O-H groups.**

Check: glucose dissolves as intact molecules because its polar O-H groups form hydrogen bonds with water; it does not form ions.
Rationales: A: dissolving breaks the attractions between molecules and not the covalent bonds inside them. B: glucose is a molecular compound and a nonelectrolyte, so it does not release H⁺ ions. C: dissolved molecules are dispersed individually among the solvent, so a clump would represent undissolved solid.

---

## Seed N-3.8-B (new) — Topic 3.8 Representations of Solutions
**Skill:** compare solutions from two particulate drawings by dividing by volume and counting the right particles.

Diagram X represents 100 mL of NaCl(aq) and shows 8 Na⁺ ions and 8 Cl⁻ ions (water not drawn). Diagram Y represents 50 mL of CaCl₂(aq) and shows 3 Ca²⁺ ions and 6 Cl⁻ ions (water not drawn). Which statement correctly compares the solutions?

- **A. The NaCl solution has the higher concentration of formula units, but the CaCl₂ solution has the higher concentration of Cl⁻ ions.**
- B. The CaCl₂ solution has the higher concentration of formula units and also the higher concentration of Cl⁻ ions.
- C. The NaCl solution has the higher concentration of formula units and also the higher concentration of Cl⁻ ions, because its diagram has more particles.
- D. The NaCl solution has the higher concentration of Cl⁻ ions, because it shows 8 Cl⁻ ions and the CaCl₂ solution shows only 6.

Check: formula units per mL: X 8/100 = 0.080, Y 3/50 = 0.060; Cl⁻ per mL: X 8/100 = 0.080, Y 6/50 = 0.120.
Rationales: B: the CaCl₂ solution has more Cl⁻ per mL, but only 0.060 formula units per mL against 0.080 for NaCl. C: counting particles without dividing by the volume ignores that Y is only 50 mL, so its Cl⁻ concentration is higher. D: the number of ions drawn must be divided by the volume represented, and 6 Cl⁻ in 50 mL is more concentrated than 8 Cl⁻ in 100 mL.

**N-3.8-B-v1.** Diagram X represents 200 mL of NaBr(aq) and shows 12 Na⁺ ions and 12 Br⁻ ions (water not drawn). Diagram Y represents 100 mL of MgBr₂(aq) and shows 5 Mg²⁺ ions and 10 Br⁻ ions (water not drawn). Which statement correctly compares the solutions?

- A. The MgBr₂ solution has the higher concentration of formula units and also the higher concentration of Br⁻ ions.
- B. The NaBr solution has the higher concentration of Br⁻ ions, because its diagram shows more Br⁻ ions.
- **C. The NaBr solution has the higher concentration of formula units, but the MgBr₂ solution has the higher concentration of Br⁻ ions.**
- D. The two solutions have equal concentrations of Br⁻ ions, because each shows the same number of Br⁻ ions per formula unit.

Check: formula units per mL: X 12/200 = 0.060, Y 5/100 = 0.050; Br⁻ per mL: X 12/200 = 0.060, Y 10/100 = 0.100.
Rationales: A: MgBr₂ has more Br⁻ per mL, but its formula unit concentration (0.050 per mL) is lower than that of NaBr (0.060 per mL). B: the ion count must be divided by the volume, and 10 Br⁻ in 100 mL is more concentrated than 12 Br⁻ in 200 mL. D: NaBr gives one Br⁻ per unit and MgBr₂ gives two, so the Br⁻ concentrations are different.

**N-3.8-B-v2.** Diagram X represents 150 mL of LiCl(aq) and shows 9 Li⁺ ions and 9 Cl⁻ ions (water not drawn). Diagram Y represents 100 mL of AlCl₃(aq) and shows 4 Al³⁺ ions and 12 Cl⁻ ions (water not drawn). Which statement correctly compares the solutions?

- A. The AlCl₃ solution has the higher concentration of formula units and also the higher concentration of Cl⁻ ions.
- B. The LiCl solution has the higher concentration of Cl⁻ ions, because its diagram shows 9 Cl⁻ ions in a larger volume.
- **C. The LiCl solution has the higher concentration of formula units, but the AlCl₃ solution has the higher concentration of Cl⁻ ions.**
- D. The LiCl solution is more concentrated in formula units and in Cl⁻ ions, because 18 particles are drawn against 16.

Check: formula units per mL: X 9/150 = 0.060, Y 4/100 = 0.040; Cl⁻ per mL: X 9/150 = 0.060, Y 12/100 = 0.120.
Rationales: A: AlCl₃ has far more Cl⁻ per mL, but only 0.040 formula units per mL against 0.060 for LiCl. B: the Cl⁻ concentration is the number of ions divided by the volume, and 12 Cl⁻ in 100 mL is double the 9 Cl⁻ in 150 mL. D: totals of 18 and 16 particles ignore the volumes, and AlCl₃ has the higher Cl⁻ concentration.

**N-3.8-B-v3.** Diagram X represents 100 mL of KCl(aq) and shows 10 K⁺ ions and 10 Cl⁻ ions (water not drawn). Diagram Y represents 50 mL of Na₃PO₄(aq) and shows 3 PO₄³⁻ ions and 9 Na⁺ ions (water not drawn). Which statement correctly compares the solutions?

- A. The Na₃PO₄ solution has the higher concentration of formula units and also the higher concentration of cations.
- B. The KCl solution has the higher concentration of cations, because 10 K⁺ ions are drawn against 9 Na⁺ ions.
- C. The two solutions have equal concentrations of cations, because each diagram shows nearly the same number of cations.
- **D. The KCl solution has the higher concentration of formula units, but the Na₃PO₄ solution has the higher concentration of cations.**

Check: formula units per mL: X 10/100 = 0.100, Y 3/50 = 0.060; cations per mL: X 10/100 = 0.100, Y 9/50 = 0.180.
Rationales: A: Na₃PO₄ has more cations per mL, but its formula unit concentration (0.060 per mL) is lower than that of KCl (0.100 per mL). B: the number of ions drawn must be divided by the volume, and 9 Na⁺ in 50 mL is more concentrated than 10 K⁺ in 100 mL. C: the diagrams show nearly equal cation counts but represent volumes that differ by a factor of two.

---

## Seed N-3.9-A (replaces 038 family) — Topic 3.9 Separation of Solutions and Mixtures
**Skill:** calculate Rf from measurements taken at the origin line and use it to compare polarity.

A paper chromatography strip uses polar paper and a nonpolar solvent. The starting line was drawn 1.5 cm above the bottom edge. After the run, the center of spot X is 4.5 cm above the bottom edge, the center of spot Y is 6.0 cm above it, and the solvent front is 8.5 cm above it. Which statement is correct?

- A. The Rf of X is 0.53, and X is more polar than Y.
- **B. The Rf of X is 0.43, and X is more polar than Y.**
- C. The Rf of X is 0.43, and X is less polar than Y.
- D. The Rf of X is 0.64, and X is more polar than Y.

Check: distance moved by X = 4.5 - 1.5 = 3.0 cm; solvent front distance = 8.5 - 1.5 = 7.0 cm; Rf = 3.0/7.0 = 0.43; Y has Rf 4.5/7.0 = 0.64; on polar paper the more polar compound moves less.
Rationales: A: 0.53 divides the height above the bottom edge instead of the distance from the starting line. C: on a polar stationary phase the compound that moves less is held more strongly, so X is the more polar one. D: 0.64 is the Rf of spot Y, which was used in place of X.

**N-3.9-A-v1.** A thin-layer plate has a nonpolar stationary phase and a polar solvent. The starting line is 2.0 cm above the bottom edge. After the run, spot P is at 5.0 cm, spot Q is at 8.0 cm, and the solvent front is at 10.0 cm above the bottom edge. Which statement is correct?

- A. The Rf of P is 0.50, and P is less polar than Q.
- B. The Rf of P is 0.38, and P is more polar than Q.
- **C. The Rf of P is 0.38, and P is less polar than Q.**
- D. The Rf of P is 0.75, and P is less polar than Q.

Check: Rf(P) = (5.0 - 2.0)/(10.0 - 2.0) = 0.375; Rf(Q) = 0.75; with a nonpolar stationary phase and polar solvent, the more polar compound travels farther, so P (less travel) is less polar.
Rationales: A: 0.50 divides the height above the bottom edge instead of the distance from the starting line. B: the rule from polar paper was applied, but with a nonpolar stationary phase the polar compound travels farther. D: 0.75 is the Rf of spot Q, used in place of P.

**N-3.9-A-v2.** A silica (polar) TLC plate is developed with a nonpolar solvent. The starting line is 1.0 cm above the bottom edge and the solvent front is at 7.0 cm. The spots are at 3.0 cm (compound A), 5.5 cm (compound B) and 2.5 cm (compound C). Which choice lists the compounds from least polar to most polar and gives the Rf of A?

- **A. B, A, C; Rf of A = 0.33**
- B. C, A, B; Rf of A = 0.33
- C. B, A, C; Rf of A = 0.43
- D. C, A, B; Rf of A = 0.43

Check: Rf(A) = (3.0 - 1.0)/(7.0 - 1.0) = 0.33; Rf(B) = 0.75 and Rf(C) = 0.25; on polar silica the compound that travels farthest is least polar, so the order is B, A, C.
Rationales: B: the order is reversed, since on polar silica the most polar compound (C) moves the least. C: Rf = 0.43 divides the spot height above the bottom edge (3.0 cm) by the 7.0 cm front distance, mixing the two measurement bases. D: both the order and the distance were wrong, because the most polar compound moves least and the starting line was ignored.

**N-3.9-A-v3.** Dye Z is polar. On polar paper the starting line is 1.5 cm above the bottom edge, the dye spot is at 5.0 cm and the solvent front is at 9.0 cm after a run with a mostly nonpolar solvent. A second run uses a more polar solvent mixture. Which choice gives the Rf in the first run and the expected change in the second run?

- A. Rf = 0.56; the Rf increases.
- B. Rf = 0.56; the Rf decreases.
- C. Rf = 0.47; the Rf decreases.
- **D. Rf = 0.47; the Rf increases.**

Check: Rf = (5.0 - 1.5)/(9.0 - 1.5) = 3.5/7.5 = 0.47; a more polar solvent dissolves the polar dye better and competes with the polar paper for it, so the dye moves farther.
Rationales: A: 0.56 divides by the height above the bottom edge rather than the distance from the starting line. B: both the Rf value and the direction are wrong, since the more polar solvent helps the polar dye move. C: the Rf is right, but a more polar solvent would not hold a polar dye back; it carries the dye farther.

---

## Seed N-3.9-B (new) — Topic 3.9 Separation of Solutions and Mixtures
**Skill:** predict the order of elution from interactions with the stationary phase and mobile phase.

A mixture is loaded on a column packed with polar silica, and nonpolar hexane is passed through. Compound 1 is a hydrocarbon, compound 2 is a ketone (C=O, no O-H group) and compound 3 is an alcohol (O-H group, forms hydrogen bonds). Which choice gives the order in which the compounds leave the column and a way to speed up the slowest one?

- **A. 1, then 2, then 3; adding a more polar solvent such as ethanol to the mobile phase would speed up compound 3.**
- B. 3, then 2, then 1; adding a more polar solvent such as ethanol would speed up compound 1.
- C. 1, then 2, then 3; making the mobile phase even less polar would speed up compound 3.
- D. 2, then 1, then 3; adding a more polar solvent would speed up compound 3.

Check: the polar silica holds the most polar compound longest; the hydrocarbon is not retained and elutes first, the ketone next, the alcohol last; a more polar mobile phase competes with the alcohol for the silica.
Rationales: B: the order is reversed, since the compound with the strongest attraction to the polar silica (the alcohol) is held longest. C: a less polar solvent competes even less with the polar silica for compound 3, so it would slow compound 3 further. D: the hydrocarbon has no polar groups to bind to silica, so it is not retained any longer than the ketone.

**N-3.9-B-v1.** A mixture is separated on a column packed with a nonpolar stationary phase, using a polar mobile phase of water and methanol. Compound P is glucose (very polar), compound Q is benzoic acid (moderately polar) and compound R is a long-chain hydrocarbon (nonpolar). Which choice gives the order in which the compounds leave the column and a way to speed up the slowest one?

- A. R, then Q, then P; making the mobile phase more polar would speed up compound P.
- B. P, then Q, then R; making the mobile phase more polar would speed up compound R.
- C. R, then Q, then P; making the mobile phase less polar would speed up compound P.
- **D. P, then Q, then R; making the mobile phase less polar (more methanol) would speed up compound R.**

Check: a nonpolar stationary phase retains nonpolar compounds, so the polar glucose leaves first and the hydrocarbon last; a less polar mobile phase dissolves the hydrocarbon better and carries it along.
Rationales: A: this is the order for a polar stationary phase, and the polar compound is held longest there, not here. B: the order is right, but a more polar mobile phase would hold the nonpolar compound back even more. C: the order is the reverse of the one expected for a nonpolar stationary phase.

**N-3.9-B-v2.** A mixture of pentane (boiling point 36°C), hexane (69°C) and heptane (98°C) is slowly heated in a fractional distillation setup. Which statement correctly gives the first liquid collected and the reason?

- A. Heptane, because its larger molecules have stronger dispersion forces and escape the liquid most easily.
- **B. Pentane, because its weaker dispersion forces give it the lowest boiling point, so it vaporizes first.**
- C. Hexane, because it is the middle component and reaches its boiling point first.
- D. All three together, because the liquids are miscible and cannot be separated by heating.

Check: smaller nonpolar molecules have weaker dispersion forces and lower boiling points; the lowest-boiling component vaporizes first and is collected first.
Rationales: A: stronger dispersion forces hold molecules in the liquid, so heptane has the highest boiling point and leaves last. C: the order of vaporization follows the boiling points and not the position in the mixture, so hexane comes second. D: miscible liquids with different boiling points are exactly what distillation separates.

**N-3.9-B-v3.** A student has a mixture of sand, dissolved NaCl and water. Which procedure recovers the sand, the salt and the water as separate samples?

- A. Evaporate the water, then filter the remaining solids to separate the sand from the salt.
- B. Distill the mixture, then filter the distillate to remove the salt.
- **C. Filter the mixture to remove the sand, then distill the filtrate so that water is collected and the salt remains.**
- D. Filter the mixture through paper to remove the dissolved NaCl, then boil the filtrate to recover the sand.

Check: sand is insoluble and is removed by filtration; dissolved ions pass through the paper, and distillation separates water from the salt by boiling point.
Rationales: A: after evaporation the sand and salt are two dry solids, and filtering does not separate them; the water is also lost. B: distillation gives pure water in the distillate, which contains no salt to filter, and the sand is still in the flask. D: dissolved ions pass through filter paper, so filtration cannot remove NaCl, and the sand would be caught on the paper instead.

---

## Seed N-3.10-A (replaces 007) — Topic 3.10 Solubility
**Skill:** use a solubility-versus-temperature data set to find how much solid crystallizes, scaling by the mass of water.

Approximate solubility of KNO₃ in water: 31 g per 100 g of water at 20°C; 85 g per 100 g at 50°C; 110 g per 100 g at 60°C; 170 g per 100 g at 80°C. A solution saturated at 50°C is made with 200 g of water and is then cooled to 20°C. What mass of KNO₃ crystallizes?

- A. 54 g
- B. 62 g
- **C. 108 g**
- D. 170 g

Check: dissolved at 50°C = 2 × 85 = 170 g; still dissolved at 20°C = 2 × 31 = 62 g; crystallized = 170 - 62 = 108 g.
Rationales: A: 54 g is the difference per 100 g of water (85 - 31), and it was not doubled for 200 g of water. B: 62 g is the mass that stays dissolved at 20°C, not the mass that crystallizes. D: 170 g is the total mass that was dissolved at 50°C, and it ignores the KNO₃ that stays in solution at 20°C.

**N-3.10-A-v1.** Approximate solubility of a salt Q in water: 22 g per 100 g of water at 40°C and 54 g per 100 g at 90°C. A solution saturated at 90°C is made with 150 g of water and is then cooled to 40°C. What mass of salt Q crystallizes?

- **A. 48 g**
- B. 32 g
- C. 33 g
- D. 81 g

Check: dissolved at 90°C = 1.5 × 54 = 81 g; still dissolved at 40°C = 1.5 × 22 = 33 g; crystallized = 81 - 33 = 48 g.
Rationales: B: 32 g is the difference per 100 g of water (54 - 22), and it was not scaled for 150 g of water. C: 33 g is the mass that stays dissolved at 40°C, not the mass that crystallizes. D: 81 g is the total mass dissolved at 90°C, and it ignores the salt that stays in solution.

**N-3.10-A-v2.** Approximate solubility of KNO₃ in water: 31 g per 100 g of water at 20°C; 85 g per 100 g at 50°C; 110 g per 100 g at 60°C; 170 g per 100 g at 80°C. A solution is saturated at 20°C using 300 g of water and is then warmed to 60°C. What additional mass of KNO₃ can dissolve to give a saturated solution at 60°C?

- A. 79 g
- B. 93 g
- C. 330 g
- **D. 237 g**

Check: dissolved at 20°C = 3 × 31 = 93 g; capacity at 60°C = 3 × 110 = 330 g; additional = 330 - 93 = 237 g.
Rationales: A: 79 g is the difference per 100 g of water (110 - 31), and it was not scaled for 300 g of water. B: 93 g is the mass already dissolved at 20°C, not the additional amount. C: 330 g is the total capacity at 60°C, and it ignores the KNO₃ already in solution.

**N-3.10-A-v3.** Approximate solubility of KNO₃ in water: 31 g per 100 g of water at 20°C; 85 g per 100 g at 50°C; 110 g per 100 g at 60°C; 170 g per 100 g at 80°C. A solution saturated at 80°C is made with 50.0 g of water and is then cooled to 20°C. What mass of KNO₃ remains dissolved at 20°C?

- A. 31 g
- **B. 15.5 g**
- C. 69.5 g
- D. 85 g

Check: at 20°C, 50.0 g of water holds 0.500 × 31 = 15.5 g (69.5 g of the original 85 g crystallizes).
Rationales: A: 31 g is the solubility per 100 g of water, and it was not scaled to 50.0 g of water. C: 69.5 g is the mass that crystallizes, not the mass that remains dissolved. D: 85 g is the mass that dissolved in 50.0 g of water at 80°C, before cooling.

---

## Seed N-3.10-B (replaces 035 family) — Topic 3.10 Solubility
**Skill:** apply gas solubility proportional to partial pressure, using the share of each gas in air.

The solubility of O₂ in water at 25°C is 1.3 × 10⁻³ M for each 1.0 atm of O₂ partial pressure. Air is 21% O₂ by volume. Water is in equilibrium with air compressed to a total pressure of 3.0 atm. What is the concentration of dissolved O₂?

- A. 3.9 × 10⁻³ M
- **B. 8.2 × 10⁻⁴ M**
- C. 2.7 × 10⁻⁴ M
- D. 2.1 × 10⁻³ M

Check: P(O₂) = 0.21 × 3.0 = 0.63 atm; [O₂] = 1.3 × 10⁻³ × 0.63 = 8.2 × 10⁻⁴ M.
Rationales: A: 3.9 × 10⁻³ M uses the total pressure of 3.0 atm as if all of the gas were O₂. C: 2.7 × 10⁻⁴ M is the value for air at 1.0 atm, so the increase to 3.0 atm was ignored. D: 2.1 × 10⁻³ M divides the solubility by the partial pressure instead of multiplying.

**N-3.10-B-v1.** The solubility of N₂ in water at 25°C is 6.1 × 10⁻⁴ M for each 1.0 atm of N₂ partial pressure. Air is 78% N₂ by volume. Water is in equilibrium with air at a total pressure of 2.0 atm. What is the concentration of dissolved N₂?

- A. 1.2 × 10⁻³ M
- B. 4.8 × 10⁻⁴ M
- C. 3.9 × 10⁻⁴ M
- **D. 9.5 × 10⁻⁴ M**

Check: P(N₂) = 0.78 × 2.0 = 1.56 atm; [N₂] = 6.1 × 10⁻⁴ × 1.56 = 9.5 × 10⁻⁴ M.
Rationales: A: 1.2 × 10⁻³ M uses the total pressure of 2.0 atm as if the gas were pure N₂. B: 4.8 × 10⁻⁴ M is the value for air at 1.0 atm, so the doubling of the pressure was ignored. C: 3.9 × 10⁻⁴ M divides the solubility by the partial pressure instead of multiplying.

**N-3.10-B-v2.** The solubility of CO₂ in water at 25°C is 0.034 M for each 1.0 atm of CO₂ partial pressure. A bottle of soda is sealed with CO₂ at 4.0 atm above the liquid. The bottle is opened and left until the liquid has come to equilibrium with the air, where the CO₂ partial pressure is 4.0 × 10⁻⁴ atm. At the same temperature, what is the final concentration of dissolved CO₂?

- **A. 1.4 × 10⁻⁵ M**
- B. 0.136 M
- C. 0.034 M
- D. 1.4 × 10⁻³ M

Check: [CO₂] = 0.034 × 4.0 × 10⁻⁴ = 1.4 × 10⁻⁵ M (compared with 0.034 × 4.0 = 0.136 M while sealed).
Rationales: B: 0.136 M is the concentration while the bottle was sealed at 4.0 atm, before the gas escaped. C: 0.034 M is the value for 1.0 atm of CO₂, which is not the CO₂ pressure in air. D: 1.4 × 10⁻³ M treats the 0.04% of CO₂ in air as a fraction of 0.04 instead of 0.0004.

**N-3.10-B-v3.** The solubility of N₂ in water at 25°C is 6.1 × 10⁻⁴ M for each 1.0 atm of N₂ partial pressure. Air is 78% N₂. At the surface the total pressure is 1.0 atm. A diver breathes air at a total pressure of 4.0 atm, and body water is assumed to come to equilibrium with the N₂ in the air. By how much does the dissolved N₂ concentration increase compared with the surface?

- A. 1.9 × 10⁻³ M
- B. 4.8 × 10⁻⁴ M
- **C. 1.4 × 10⁻³ M**
- D. 1.8 × 10⁻³ M

Check: [N₂] at depth = 6.1 × 10⁻⁴ × 0.78 × 4.0 = 1.9 × 10⁻³ M; at the surface 6.1 × 10⁻⁴ × 0.78 = 4.8 × 10⁻⁴ M; increase = 1.4 × 10⁻³ M.
Rationales: A: 1.9 × 10⁻³ M is the total concentration at depth, and the concentration already present at the surface was not subtracted. B: 4.8 × 10⁻⁴ M is the surface concentration, not the increase. D: 1.8 × 10⁻³ M treats the air as pure N₂ and ignores that only 78% is N₂.

---

## Seed N-3.11-A (new) — Topic 3.11 Spectroscopy and the Electromagnetic Spectrum
**Skill:** compare photon energies from wavelengths and match each region to the type of molecular change it causes.

A compound absorbs radiation at 3.0 μm (infrared) and at 250 nm (ultraviolet). Which statement correctly compares the two absorptions?

- A. The 3.0 μm photons have 12 times the energy of the 250 nm photons, and they excite electronic transitions.
- B. The 250 nm photons have 144 times the energy of the 3.0 μm photons, and they excite electronic transitions.
- C. The 250 nm photons have 12 times the energy of the 3.0 μm photons, and they excite bond vibrations.
- **D. The 250 nm photons have 12 times the energy of the 3.0 μm photons, and they excite electronic transitions, while the 3.0 μm photons excite bond vibrations.**

Check: E is proportional to 1/λ, so the energy ratio is 3000 nm / 250 nm = 12; UV photons promote electrons, IR photons change vibrations.
Rationales: A: energy is inversely proportional to wavelength, so the longer-wavelength IR photon has the lower energy, not 12 times more. B: the energy ratio is the wavelength ratio itself, not its square. C: the ratio is right, but the UV photons carry enough energy to promote electrons, while bond vibrations need the smaller energy of IR photons.

**N-3.11-A-v1.** A gas absorbs microwave radiation at 3.0 cm and infrared radiation at 3.0 μm. Which statement correctly compares the two absorptions?

- A. The microwave photons have 1.0 × 10⁴ times the energy of the IR photons, and they excite molecular vibrations.
- **B. The IR photons have 1.0 × 10⁴ times the energy of the microwave photons; the IR absorption changes the molecular vibrations and the microwave absorption changes the molecular rotations.**
- C. The IR photons have 1.0 × 10⁴ times the energy of the microwave photons; the IR absorption changes the rotations and the microwave absorption changes the vibrations.
- D. The IR photons have 1.0 × 10² times the energy of the microwave photons; the IR absorption changes the vibrations and the microwave absorption changes the rotations.

Check: 3.0 cm / 3.0 μm = 3.0 × 10⁻² m / 3.0 × 10⁻⁶ m = 1.0 × 10⁴; rotational energy changes are smaller than vibrational ones.
Rationales: A: the microwave photon has the longer wavelength, so it has the lower energy. C: rotational changes take far less energy than vibrational changes, so the smaller microwave photons match rotations. D: the energy ratio is the full wavelength ratio of 10⁴, not its square root.

**N-3.11-A-v2.** A dye absorbs visible light at 500 nm and infrared radiation at 5.0 μm. Which statement correctly compares the two absorptions?

- A. The 5.0 μm photons have 10 times the energy of the 500 nm photons, and they excite electronic transitions.
- B. The 500 nm photons have 100 times the energy of the 5.0 μm photons, and they excite electronic transitions.
- **C. The 500 nm photons have 10 times the energy of the 5.0 μm photons, and they excite electronic transitions, while the 5.0 μm photons excite bond vibrations.**
- D. The 500 nm photons have 10 times the energy of the 5.0 μm photons, and they excite bond vibrations, while the 5.0 μm photons excite electronic transitions.

Check: 5000 nm / 500 nm = 10; visible photons promote electrons, IR photons change vibrations.
Rationales: A: the longer-wavelength IR photon has the lower energy, not 10 times more. B: the energy ratio is the wavelength ratio of 10, not its square. D: the ratio is right, but the assignments are reversed, since vibrations need less energy than electronic transitions.

**N-3.11-A-v3.** A molecule absorbs ultraviolet radiation at 200 nm and visible light at 600 nm, and both absorptions are caused by electronic transitions. Which statement is correct?

- **A. The 200 nm photons have 3.0 times the energy of the 600 nm photons, so the 200 nm absorption involves a larger energy gap between electronic levels.**
- B. The 200 nm photons have 9.0 times the energy of the 600 nm photons, so the 200 nm absorption involves a larger energy gap.
- C. The 600 nm photons have 3.0 times the energy of the 200 nm photons, so the 600 nm absorption involves a larger energy gap.
- D. The 200 nm photons have 3.0 times the energy of the 600 nm photons, so the 200 nm absorption is a vibrational transition.

Check: 600 nm / 200 nm = 3.0; the photon energy matches the gap between electronic energy levels.
Rationales: B: the energy ratio equals the wavelength ratio, not its square. C: the shorter wavelength has the higher energy, so the 600 nm photons carry less, not more. D: the problem states that both absorptions are electronic, and vibrational transitions need IR photons.

---

## Seed N-3.11-B (new) — Topic 3.11 Spectroscopy and the Electromagnetic Spectrum
**Skill:** convert a bond energy per mole to energy per photon and decide which light can break one bond, ignoring intensity.

Use h = 6.626 × 10⁻³⁴ J·s, c = 3.00 × 10⁸ m/s and Nₐ = 6.022 × 10²³ /mol. A C-H bond has a bond energy of 410 kJ/mol. Which light can break a C-H bond by absorption of a single photon per bond?

- A. A red laser at 650 nm, because red light is the most intense visible light.
- B. A blue laser at 450 nm, because blue light carries the most energy of the visible region.
- **C. Ultraviolet light at 250 nm, because each photon carries more than 410 kJ per mole of photons.**
- D. A very intense infrared source at 10 μm, because it delivers many photons per second.

Check: the energy of a mole of photons is 119,600 / λ(nm) kJ/mol: 650 nm gives 184, 450 nm gives 266, 250 nm gives 479, 10 μm gives 12.0; only 250 nm exceeds 410 kJ/mol; the longest wavelength that can break the bond is about 292 nm.
Rationales: A: a 650 nm photon carries only about 184 kJ per mole of photons, and color does not make the energy larger. B: a 450 nm photon carries about 266 kJ per mole of photons, which is still below 410 kJ/mol. D: intensity counts photons, but each IR photon at 10 μm carries only about 12 kJ per mole, and photon energies do not add up on one bond.

**N-3.11-B-v1.** Use h = 6.626 × 10⁻³⁴ J·s, c = 3.00 × 10⁸ m/s and Nₐ = 6.022 × 10²³ /mol. The O-O bond in a peroxide has a bond energy of 142 kJ/mol. Which light can break an O-O bond by absorption of a single photon per bond?

- **A. Near-infrared light at 780 nm, because each photon carries more than 142 kJ per mole of photons.**
- B. Near-infrared light at 950 nm, because it is close to the energy needed.
- C. Infrared light at 1.5 μm, because a strong beam provides many photons.
- D. Far-infrared light at 20 μm, because infrared radiation is absorbed by bond vibrations.

Check: 780 nm photons carry 153 kJ per mole of photons, above 142 kJ/mol; the threshold is about 843 nm; 950 nm gives 126, 1.5 μm gives 80, 20 μm gives 6.0.
Rationales: B: a 950 nm photon carries about 126 kJ per mole of photons, which is below 142 kJ/mol. C: many low-energy photons do not combine on a single bond, and each 1.5 μm photon carries about 80 kJ per mole. D: absorption by vibrations does not break the bond, since each 20 μm photon carries only about 6 kJ per mole.

**N-3.11-B-v2.** Use h = 6.626 × 10⁻³⁴ J·s, c = 3.00 × 10⁸ m/s and Nₐ = 6.022 × 10²³ /mol. The N≡N bond in N₂ has a bond energy of 945 kJ/mol. Which light can break an N≡N bond by absorption of a single photon per bond?

- A. Blue light at 450 nm, because it is the highest-energy visible light.
- B. Ultraviolet light at 250 nm, because ultraviolet light breaks bonds.
- C. Ultraviolet light at 150 nm, because it is far into the ultraviolet.
- **D. Far-ultraviolet light at 100 nm, because each photon carries more than 945 kJ per mole of photons.**

Check: photon energy per mole = 119,600 / λ(nm): 450 nm gives 266, 250 nm gives 479, 150 nm gives 797, 100 nm gives 1196 kJ/mol; the threshold is about 127 nm.
Rationales: A: a 450 nm photon carries about 266 kJ per mole of photons, far below 945 kJ/mol. B: a 250 nm photon carries about 479 kJ per mole of photons, which can break a weaker bond but not this triple bond. C: a 150 nm photon carries about 797 kJ per mole of photons, still below 945 kJ/mol.

**N-3.11-B-v3.** Use h = 6.626 × 10⁻³⁴ J·s, c = 3.00 × 10⁸ m/s and Nₐ = 6.022 × 10²³ /mol. The Cl-Cl bond in Cl₂ has a bond energy of 242 kJ/mol. Which light can break a Cl-Cl bond by absorption of a single photon per bond?

- A. Red light at 700 nm, because red light is the lowest-energy visible light and so is gentlest.
- **B. Blue light at 450 nm, because each photon carries more than 242 kJ per mole of photons.**
- C. Green light at 550 nm, because green is in the middle of the visible region.
- D. An intense infrared lamp at 10 μm, because it can deliver the most photons.

Check: photon energy per mole = 119,600 / λ(nm): 700 nm gives 171, 550 nm gives 218, 450 nm gives 266, 10 μm gives 12.0 kJ/mol; the threshold is about 494 nm.
Rationales: A: a 700 nm photon carries only about 171 kJ per mole of photons, below 242 kJ/mol. C: a 550 nm photon carries about 218 kJ per mole of photons, just below 242 kJ/mol. D: intensity does not matter, because each 10 μm photon carries only about 12 kJ per mole of photons.

---

## Seed N-3.12-A (replaces 037 family) — Topic 3.12 Photoelectric Effect
**Skill:** separate the effects of frequency (kinetic energy, threshold) and intensity (number of electrons).

A metal has a threshold frequency of 5.0 × 10¹⁴ s⁻¹. Three lights shine on it: light X has frequency 7.0 × 10¹⁴ s⁻¹ and low intensity; light Y has frequency 6.0 × 10¹⁴ s⁻¹ and 10 times the intensity of X; light Z has frequency 4.0 × 10¹⁴ s⁻¹ and 1000 times the intensity of X. Which statement is correct?

- A. Light Z ejects electrons with the largest kinetic energy, because its intensity is the greatest.
- B. Light Y ejects electrons with the largest kinetic energy, because it is 10 times as intense as X.
- **C. Light X gives the electrons with the greatest maximum kinetic energy; light Y gives electrons with less, even though it is more intense; light Z ejects no electrons.**
- D. All three lights eject electrons, because enough intensity can make up for a low frequency.

Check: maximum KE = hν - Φ rises with frequency only; Z is below the threshold, so no photon has enough energy no matter how many arrive.
Rationales: A: Z is below the threshold frequency, so its photons cannot eject any electron regardless of intensity. B: intensity changes how many electrons are ejected, but the maximum kinetic energy depends only on the frequency. D: an electron absorbs one photon at a time, so many low-energy photons cannot combine to eject it.

**N-3.12-A-v1.** A metal has a threshold wavelength of 500 nm. Light P has a wavelength of 400 nm and a low intensity. Light Q has a wavelength of 450 nm and 20 times the intensity of P. Light R has a wavelength of 550 nm and 500 times the intensity of P. Which statement is correct?

- A. Light R ejects electrons with the largest kinetic energy, because its intensity is the greatest.
- **B. Light P gives the electrons with the greatest maximum kinetic energy; light Q gives electrons with less, even though it is more intense; light R ejects no electrons.**
- C. Light Q ejects electrons with the largest kinetic energy, because both P and Q are above the threshold and Q is more intense.
- D. All three lights eject electrons, but those from light R have the smallest kinetic energy.

Check: ν = c/λ, so P is 7.5 × 10¹⁴ s⁻¹, Q is 6.7 × 10¹⁴ s⁻¹ and R is 5.5 × 10¹⁴ s⁻¹, against a threshold of 6.0 × 10¹⁴ s⁻¹; R is below the threshold.
Rationales: A: R has a wavelength longer than the threshold wavelength, so its photons cannot eject electrons. C: intensity raises the number of electrons and not their maximum kinetic energy, and P has the higher frequency. D: light R is below the threshold frequency, so it ejects none.

**N-3.12-A-v2.** Light of frequency 8.0 × 10¹⁴ s⁻¹ ejects electrons from a metal with a threshold frequency of 5.0 × 10¹⁴ s⁻¹. Which change would double the number of electrons ejected per second without changing their maximum kinetic energy?

- **A. Double the intensity of the light at the same frequency.**
- B. Double the frequency of the light at the same intensity.
- C. Switch to a metal with a lower threshold frequency.
- D. Halve the frequency of the light and double its intensity.

Check: the electron count follows the number of photons, which rises with intensity; the maximum KE depends only on frequency and the metal.
Rationales: B: doubling the frequency raises the maximum kinetic energy, so that condition is not met. C: a lower threshold frequency lowers the work function, which raises the maximum kinetic energy. D: halving the frequency to 4.0 × 10¹⁴ s⁻¹ goes below the threshold, so no electrons are ejected at all.

**N-3.12-A-v3.** Two metals are lit with 450 nm light (photon energy 4.4 × 10⁻¹⁹ J). Metal 1 has a work function of 3.0 × 10⁻¹⁹ J and metal 2 has a work function of 4.5 × 10⁻¹⁹ J. Which statement is correct?

- A. Both metals emit electrons, and the electrons from metal 1 have the higher maximum kinetic energy.
- B. Metal 1 emits electrons with a maximum kinetic energy of about 4.4 × 10⁻¹⁹ J, and metal 2 emits none.
- C. Metal 1 emits electrons with a maximum kinetic energy of about 1.4 × 10⁻¹⁹ J, and metal 2 also emits at high intensity, with lower kinetic energy.
- **D. Metal 1 emits electrons with a maximum kinetic energy of about 1.4 × 10⁻¹⁹ J, and metal 2 emits none whatever the intensity.**

Check: photon energy = 6.626 × 10⁻³⁴ × 3.00 × 10⁸ / 450 × 10⁻⁹ = 4.4 × 10⁻¹⁹ J; metal 1: KE = 4.4 - 3.0 = 1.4 × 10⁻¹⁹ J; metal 2: 4.4 < 4.5, so the photons are below its threshold.
Rationales: A: the photon energy is below the work function of metal 2, so metal 2 emits no electrons. B: the maximum kinetic energy is the photon energy minus the work function, not the photon energy itself. C: electrons absorb one photon at a time, so a high intensity cannot make up for photons that are too low in energy.

---

## Seed N-3.12-B (new) — Topic 3.12 Photoelectric Effect
**Skill:** find a threshold wavelength from one measurement of kinetic energy, using energy conservation.

Use h = 6.626 × 10⁻³⁴ J·s and c = 3.00 × 10⁸ m/s. Light of wavelength 400 nm ejects electrons from a metal with a maximum kinetic energy of 1.5 × 10⁻¹⁹ J. What is the threshold wavelength of the metal?

- A. 307 nm
- **B. 573 nm**
- C. 400 nm
- D. 1330 nm

Check: E(photon) = 4.97 × 10⁻¹⁹ J; Φ = 4.97 × 10⁻¹⁹ - 1.5 × 10⁻¹⁹ = 3.47 × 10⁻¹⁹ J; λ₀ = hc/Φ = 573 nm.
Rationales: A: 307 nm adds the kinetic energy to the photon energy instead of subtracting it to find the work function. C: 400 nm treats the photon energy as the work function, which would leave no kinetic energy. D: 1330 nm converts the kinetic energy itself into a wavelength, and the kinetic energy is not the work function.

**N-3.12-B-v1.** Use h = 6.626 × 10⁻³⁴ J·s and c = 3.00 × 10⁸ m/s. Light of wavelength 300 nm ejects electrons from a metal with a maximum kinetic energy of 2.0 × 10⁻¹⁹ J. What is the threshold wavelength of the metal?

- A. 230 nm
- B. 300 nm
- C. 994 nm
- **D. 430 nm**

Check: E(photon) = 6.63 × 10⁻¹⁹ J; Φ = 6.63 × 10⁻¹⁹ - 2.0 × 10⁻¹⁹ = 4.63 × 10⁻¹⁹ J; λ₀ = hc/Φ = 430 nm.
Rationales: A: 230 nm adds the kinetic energy to the photon energy instead of subtracting it. B: 300 nm treats the photon energy as the work function, which would leave no kinetic energy. C: 994 nm converts the kinetic energy itself into a wavelength.

**N-3.12-B-v2.** Use h = 6.626 × 10⁻³⁴ J·s and c = 3.00 × 10⁸ m/s. Light of wavelength 250 nm ejects electrons from a metal with a maximum kinetic energy of 3.0 × 10⁻¹⁹ J. What is the threshold wavelength of the metal?

- **A. 401 nm**
- B. 182 nm
- C. 250 nm
- D. 663 nm

Check: E(photon) = 7.95 × 10⁻¹⁹ J; Φ = 7.95 × 10⁻¹⁹ - 3.0 × 10⁻¹⁹ = 4.95 × 10⁻¹⁹ J; λ₀ = hc/Φ = 401 nm.
Rationales: B: 182 nm adds the kinetic energy to the photon energy instead of subtracting it. C: 250 nm treats the photon energy as the work function, which would leave no kinetic energy. D: 663 nm converts the kinetic energy itself into a wavelength.

**N-3.12-B-v3.** Use h = 6.626 × 10⁻³⁴ J·s and c = 3.00 × 10⁸ m/s. Light of wavelength 500 nm ejects electrons from a metal with a maximum kinetic energy of 8.0 × 10⁻²⁰ J. What is the threshold wavelength of the metal?

- A. 416 nm
- B. 500 nm
- **C. 626 nm**
- D. 2490 nm

Check: E(photon) = 3.98 × 10⁻¹⁹ J; Φ = 3.98 × 10⁻¹⁹ - 0.80 × 10⁻¹⁹ = 3.18 × 10⁻¹⁹ J; λ₀ = hc/Φ = 626 nm.
Rationales: A: 416 nm adds the kinetic energy to the photon energy instead of subtracting it. B: 500 nm treats the photon energy as the work function, which would leave no kinetic energy. D: 2490 nm converts the kinetic energy itself into a wavelength.

---

## Seed N-3.13-A (replaces 006 family) — Topic 3.13 Beer-Lambert Law
**Skill:** use a calibration data set and undo a dilution to find an original concentration.

A calibration set for a colored complex, measured at its wavelength of maximum absorbance in a 1.00 cm cuvette, gives these absorbances: 0.160 at 2.0 × 10⁻⁵ M, 0.320 at 4.0 × 10⁻⁵ M, 0.480 at 6.0 × 10⁻⁵ M and 0.640 at 8.0 × 10⁻⁵ M. A 5.00 mL sample of an unknown solution is diluted with water to a final volume of 50.0 mL. The diluted solution has an absorbance of 0.400 in the same cuvette. What is the concentration of the original unknown solution?

- A. 5.0 × 10⁻⁵ M
- **B. 5.0 × 10⁻⁴ M**
- C. 5.5 × 10⁻⁴ M
- D. 5.0 × 10⁻⁶ M

Check: the slope is 0.160 / 2.0 × 10⁻⁵ = 8.0 × 10³ M⁻¹; diluted c = 0.400 / 8.0 × 10³ = 5.0 × 10⁻⁵ M; original = 5.0 × 10⁻⁵ × (50.0/5.00) = 5.0 × 10⁻⁴ M.
Rationales: A: 5.0 × 10⁻⁵ M is the concentration in the diluted solution, and the dilution factor was not applied. C: 5.5 × 10⁻⁴ M treats 50.0 mL as the volume of water added, giving a total of 55.0 mL. D: 5.0 × 10⁻⁶ M divides by the dilution factor instead of multiplying by it.

**N-3.13-A-v1.** A calibration set for a dye, measured at its wavelength of maximum absorbance in a 1.00 cm cuvette, gives these absorbances: 0.120 at 1.0 × 10⁻⁵ M, 0.240 at 2.0 × 10⁻⁵ M, 0.360 at 3.0 × 10⁻⁵ M and 0.480 at 4.0 × 10⁻⁵ M. A 2.00 mL sample of an unknown solution is diluted with water to a final volume of 25.0 mL. The diluted solution has an absorbance of 0.288 in the same cuvette. What is the concentration of the original unknown solution?

- A. 2.4 × 10⁻⁵ M
- B. 3.24 × 10⁻⁴ M
- C. 1.9 × 10⁻⁶ M
- **D. 3.00 × 10⁻⁴ M**

Check: the slope is 0.120 / 1.0 × 10⁻⁵ = 1.2 × 10⁴ M⁻¹; diluted c = 0.288 / 1.2 × 10⁴ = 2.4 × 10⁻⁵ M; original = 2.4 × 10⁻⁵ × (25.0/2.00) = 3.00 × 10⁻⁴ M.
Rationales: A: 2.4 × 10⁻⁵ M is the concentration in the diluted solution, and the dilution factor was not applied. B: 3.24 × 10⁻⁴ M treats 25.0 mL as the volume of water added, giving a total of 27.0 mL. C: 1.9 × 10⁻⁶ M divides by the dilution factor instead of multiplying by it.

**N-3.13-A-v2.** A calibration set for a complex, measured at its wavelength of maximum absorbance in a 1.00 cm cuvette, gives these absorbances: 0.200 at 5.0 × 10⁻⁵ M, 0.400 at 1.0 × 10⁻⁴ M, 0.600 at 1.5 × 10⁻⁴ M and 0.800 at 2.0 × 10⁻⁴ M. A 10.0 mL sample of an unknown solution is diluted with water to a final volume of 100.0 mL. The diluted solution is measured in a 2.00 cm cuvette and has an absorbance of 0.560. What is the concentration of the original unknown solution?

- **A. 7.0 × 10⁻⁴ M**
- B. 1.4 × 10⁻³ M
- C. 7.0 × 10⁻⁵ M
- D. 7.7 × 10⁻⁴ M

Check: the slope for 1.00 cm is 4.0 × 10³ M⁻¹ (that is, ε·1.00 cm); with b = 2.00 cm, c = 0.560 / (4.0 × 10³ × 2.00) = 7.0 × 10⁻⁵ M; original = 7.0 × 10⁻⁵ × (100.0/10.0) = 7.0 × 10⁻⁴ M.
Rationales: B: 1.4 × 10⁻³ M uses the 1.00 cm calibration slope directly and ignores that the sample was measured in a cuvette twice as long. C: 7.0 × 10⁻⁵ M is the concentration in the diluted solution, and the dilution factor was not applied. D: 7.7 × 10⁻⁴ M treats 100.0 mL as the volume of water added, giving a total of 110.0 mL.

**N-3.13-A-v3.** A calibration set for a complex, measured at its wavelength of maximum absorbance in a 1.00 cm cuvette, gives these absorbances: 0.150 at 1.0 × 10⁻⁵ M, 0.300 at 2.0 × 10⁻⁵ M, 0.450 at 3.0 × 10⁻⁵ M and 0.600 at 4.0 × 10⁻⁵ M. A 1.00 mL sample of an unknown solution is diluted to a final volume of 100.0 mL. Then 10.0 mL of that solution is diluted to a final volume of 50.0 mL. The final solution has an absorbance of 0.375 in the same cuvette. What is the concentration of the original unknown solution?

- A. 2.5 × 10⁻⁵ M
- B. 2.5 × 10⁻³ M
- **C. 1.25 × 10⁻² M**
- D. 1.25 × 10⁻⁴ M

Check: the slope is 0.150 / 1.0 × 10⁻⁵ = 1.5 × 10⁴ M⁻¹; final c = 0.375 / 1.5 × 10⁴ = 2.5 × 10⁻⁵ M; original = 2.5 × 10⁻⁵ × (50.0/10.0) × (100.0/1.00) = 1.25 × 10⁻² M.
Rationales: A: 2.5 × 10⁻⁵ M is the concentration of the final solution, and neither dilution was undone. B: 2.5 × 10⁻³ M undoes only the first dilution (factor 100) and leaves out the second dilution. D: 1.25 × 10⁻⁴ M undoes only the second dilution (factor 5) and leaves out the first dilution.

---

## Seed N-3.13-B (replaces 036 family) — Topic 3.13 Beer-Lambert Law
**Skill:** keep absorbance (linear in concentration and path length) separate from percent transmittance (logarithmic).

A colored solution in a 1.00 cm cuvette transmits 50.0% of the light at its wavelength of maximum absorbance (A = 0.301, using A = -log₁₀ T). The concentration is then tripled and the same cuvette and wavelength are used. What percent of the light is transmitted?

- **A. 12.5%**
- B. 16.7%
- C. 25.0%
- D. 33%

Check: A is proportional to c, so A = 3 × 0.301 = 0.903; T = 10⁻⁰·⁹⁰³ = 0.125, or 12.5%.
Rationales: B: 16.7% divides the transmittance by 3, but the transmittance changes exponentially with concentration and not linearly. C: 25.0% is the transmittance for a doubled concentration, so the factor of 3 was treated as 2. D: 33% multiplies the transmittance by two thirds, which is not the relationship in the Beer-Lambert law.

**N-3.13-B-v1.** A solution in a 2.00 cm cuvette transmits 25.0% of the light at its wavelength of maximum absorbance (A = 0.602, using A = -log₁₀ T). The same solution is then placed in a 1.00 cm cuvette. What percent of the light is transmitted?

- A. 12.5%
- B. 37.5%
- **C. 50.0%**
- D. 62.5%

Check: A is proportional to path length, so A = 0.602 / 2 = 0.301; T = 10⁻⁰·³⁰¹ = 0.500, or 50.0%.
Rationales: A: 12.5% halves the transmittance, but a shorter path lets more light through, and the relation is logarithmic. B: 37.5% takes half of the 75% of light absorbed and reports it as the percent transmitted. D: 62.5% halves the percent absorbed (75% to 37.5%) and subtracts from 100%, but absorbance, not percent absorbed, is proportional to path length.

**N-3.13-B-v2.** A solution in a 1.00 cm cuvette transmits 10.0% of the light at its wavelength of maximum absorbance (A = 1.000, using A = -log₁₀ T). The solution is diluted to one quarter of its original concentration and measured in the same cuvette. What percent of the light is transmitted?

- A. 2.5%
- **B. 56%**
- C. 40%
- D. 77.5%

Check: A is proportional to c, so A = 1.000 / 4 = 0.250; T = 10⁻⁰·²⁵⁰ = 0.562, or 56%.
Rationales: A: 2.5% divides the transmittance by 4, which is the wrong direction, since dilution lets more light through. C: 40% multiplies the transmittance by 4, but the transmittance changes exponentially with concentration. D: 77.5% divides the percent absorbed (90%) by 4 and subtracts the result from 100%, but absorbance is proportional to concentration, not the percent absorbed.

**N-3.13-B-v3.** A solution in a 1.00 cm cuvette transmits 60.0% of the light at its wavelength of maximum absorbance (A = 0.222, using A = -log₁₀ T). The concentration is increased to 4 times its original value and measured in the same cuvette. What percent of the light is transmitted?

- A. 15%
- B. 36%
- C. 25%
- **D. 13%**

Check: A = 4 × 0.222 = 0.888; T = 10⁻⁰·⁸⁸⁸ = 0.129, or about 13%.
Rationales: A: 15% divides the transmittance by 4, but the transmittance changes exponentially with concentration. B: 36% squares the transmittance, which corresponds to doubling the concentration and not to quadrupling it. C: 25% takes one quarter of the incident light and ignores the 60% that was already transmitted.
