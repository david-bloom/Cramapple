-- AP Chemistry FRQ canonical_answer_1 backfill, 2026-08-12.
--
-- Context: 37 of 50 published AP Chemistry FRQs (74%) are missing
-- canonical_answer_1 on their content_item_versions row, which blocks them
-- from gold-set generation eligibility (the filter used everywhere in this
-- codebase is v.status='published' AND v.review_status='question_review_approved'
-- AND v.canonical_answer_1 IS NOT NULL). This repair backfills
-- canonical_answer_1 for those 37 items with a complete, part-by-part model
-- student answer synthesized from each item's own app.frq_criteria rows --
-- no new chemistry content is invented; every number and claim below is
-- grounded in what the item's existing criteria already specify (a small
-- number of purely arithmetic derivations -- e.g. mass of excess reagent
-- remaining -- were completed from values the criteria already establish;
-- see remediation report for the specific items flagged for a second look).
--
-- Unlike the sibling short-FRQ repair in this directory, this repair does
-- NOT touch app.frq_criteria content -- the rubric stays exactly as-is. Each
-- new draft version copies the prior published version's frq_criteria rows
-- verbatim (same criterion_key/points_possible/learner_facing_text/
-- evidence_requirements/minimum_fix) into the new content_item_version_id,
-- and only canonical_answer_1 is newly populated. The structural QA gate
-- checks that the new version's criteria count and point-sum exactly match
-- the old (retired) version's, proving nothing about the rubric changed.
--
-- Owner-directed: "Do everything else you recommend" (chat instruction
-- following the AP Chemistry CED/eligibility cross-check). Drafted by an
-- agent, independently spot-checked (including its three self-flagged
-- arithmetic derivations), then executed against production 2026-08-12:
-- 37 repaired, 37 published, 0 blocked.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-canonical-answer-backfill-20260812'));

create temporary table repair_targets (
  content_key text primary key
) on commit drop;

insert into repair_targets values
('apchem-frq-l-010'),
('apchem-frq-l-011'),
('apchem-frq-l-013'),
('apchem-frq-l-014'),
('apchem-frq-l-016'),
('apchem-frq-l-017'),
('apchem-frq-l-020'),
('apchem-frq-l-021'),
('apchem-frq-l-022'),
('apchem-frq-l-023'),
('apchem-frq-l-024'),
('apchem-frq-l-025'),
('apchem-frq-l-026'),
('apchem-frq-l-027'),
('apchem-frq-l-028'),
('apchem-sfrq-014'),
('apchem-sfrq-015'),
('apchem-sfrq-016'),
('apchem-sfrq-018'),
('apchem-sfrq-019'),
('apchem-sfrq-021'),
('apchem-sfrq-022'),
('apchem-sfrq-023'),
('apchem-sfrq-024'),
('apchem-sfrq-026'),
('apchem-sfrq-027'),
('apchem-sfrq-028'),
('apchem-sfrq-029'),
('apchem-sfrq-030'),
('apchem-sfrq-031'),
('apchem-sfrq-032'),
('apchem-sfrq-033'),
('apchem-sfrq-034'),
('apchem-sfrq-035'),
('apchem-sfrq-036'),
('apchem-sfrq-037'),
('apchem-sfrq-038');

create temporary table canonical_answers (
  content_key text primary key,
  answer_text text not null
) on commit drop;

insert into canonical_answers values
('apchem-frq-l-010', $ans$(a) NaCl(s) is a crystal lattice of alternating Na+ and Cl- ions held together by strong, nondirectional electrostatic (ionic) attractions extending in a repeating three-dimensional pattern throughout the solid.
(b) When stress is applied, one layer of ions shifts relative to the next so that ions of like charge become aligned; the resulting strong repulsion between like-charged ions overcomes the lattice attractions and the crystal fractures (shatters) along that plane.
(c) In the electron-sea model of metallic bonding, brass's Cu and Zn cations sit in a lattice surrounded by a "sea" of delocalized, mobile valence electrons not associated with any particular atom. Because this bonding is nondirectional, layers of metal cations can slide past one another under stress without breaking bonds, since the delocalized electrons simply redistribute to keep the metal held together -- this is why brass is malleable.
(d) Brass is harder and less malleable than pure copper because the substitutional Zn atoms (a different size than Cu) disturb the regularity of the Cu lattice, impeding the motion of dislocations (the sliding of atomic layers past each other) that gives pure metals their malleability.
(e) In solid NaCl, the Na+ and Cl- ions are locked in fixed lattice positions and cannot move to carry charge, so the solid does not conduct electricity. In molten NaCl, the lattice has broken down and the ions are free to move throughout the liquid, acting as mobile charge carriers, so the melt conducts electricity.
(f) Aqueous NaCl also conducts electricity because the solid dissociates into freely-moving, hydrated Na+ and Cl- ions in solution, which act as mobile charge carriers.$ans$),
('apchem-frq-l-011', $ans$(a) n = PV/RT = (2.00 atm)(5.00 L) / [(0.0821 L*atm/mol*K)(300. K)] approximately 0.406 mol N2
(b) mass = 0.406 mol x 28.02 g/mol approximately 11.4 g N2
(c) At constant volume, P1/T1 = P2/T2, so P2 = P1 x (T2/T1) = 2.00 atm x (450./300.) = 3.00 atm
(d) Heating increases the average kinetic energy and speed of the N2 molecules, so they collide with the container walls more frequently and transfer more momentum per collision, increasing the pressure.
(e) At constant pressure, Charles's Law gives V2 = V1 x (T2/T1) = 5.00 L x (450./300.) = 7.50 L$ans$),
('apchem-frq-l-013', $ans$(a) First, filter the mixture through filter paper. The insoluble CaCO3(s) particles are too large to pass through the filter pores and are retained on the paper, while the water and dissolved Na+ and Cl- ions pass through as filtrate. Rinse the residue with a small amount of deionized water to remove adhering NaCl(aq), then dry it to obtain pure, dry CaCO3(s).
(b) The filtrate (NaCl dissolved in water) can be separated by distillation: heat it to boil off the water, then condense and collect the water vapor in a separate container, leaving solid NaCl behind. This exploits the difference in boiling point/volatility between water and NaCl.
(c) This proposal would not work. Paper chromatography separates soluble, colored/UV-active components dissolved in a mobile phase based on their differing attraction to the mobile phase versus the stationary phase (the paper). It cannot separate an insoluble solid like CaCO3 from a solution in a single step, since CaCO3 does not dissolve into a mobile phase or migrate up the paper.
(d) Measure the boiling point of the recovered liquid and compare it to 100 C (at standard pressure). Pure water boils at a sharp, constant temperature of 100 C, whereas water containing dissolved impurities boils at an elevated and less sharply defined temperature. A sharp boiling point at 100 C confirms the recovered water is pure.$ans$),
('apchem-frq-l-014', $ans$(a) At 60 C, the maximum solubility of KNO3 is 110 g per 100 g water. Since 80. g is less than 110 g, the solution is unsaturated.
(b) At 20 C, solubility is 32 g per 100 g water, so the mass of KNO3 that crystallizes out = 80. g - 32 g = 48 g KNO3(s).
(c) Dissolving KNO3 is endothermic, so lowering the temperature shifts the dissolution equilibrium toward the solid (crystallization) side; crystallization continues until the amount of dissolved KNO3 equals the lower equilibrium solubility at 20 C.
(d) This is a supersaturated solution -- it contains more dissolved KNO3 than the equilibrium solubility at that temperature. It is unstable (metastable) because introducing a seed crystal, scratching the container, or agitating the solution can trigger rapid nucleation and crystallization of the excess dissolved solute.
(e) Add a small seed crystal (or a few grains) of solid KNO3 to the solution. If the solution is supersaturated, this triggers rapid crystallization of the excess dissolved KNO3, which would confirm the solution was supersaturated.
(f) At 80 C, solubility = 169 g KNO3 per 100 g water. Water needed = 200. g KNO3 x (100 g water / 169 g KNO3) approximately 118 g water.$ans$),
('apchem-frq-l-016', $ans$(a) mol Al = 5.40 g / 26.98 g/mol approximately 0.200 mol Al; mol CuSO4 = 0.250 L x 0.500 M = 0.125 mol CuSO4
(b) The reaction requires a 2 Al : 3 CuSO4 mole ratio. Reacting all 0.125 mol CuSO4 would require (2/3)(0.125) approximately 0.0833 mol Al, and 0.200 mol Al is available -- more than enough. Reacting all 0.200 mol Al would require (3/2)(0.200) = 0.300 mol CuSO4, but only 0.125 mol CuSO4 is available. Since there is not enough CuSO4 to react with all the Al, CuSO4 is the limiting reagent.
(c) mass Cu = 0.125 mol CuSO4 x (3 mol Cu / 3 mol CuSO4) x 63.55 g/mol approximately 7.94 g Cu
(d) Al consumed = 0.125 mol CuSO4 x (2 mol Al / 3 mol CuSO4) approximately 0.0833 mol Al; Al remaining = 0.200 mol - 0.0833 mol approximately 0.117 mol; mass Al remaining approximately 0.117 mol x 26.98 g/mol approximately 3.15 g
(e) percent yield = 7.25 g / 7.94 g x 100% approximately 91.3%
(f) Yes, more Cu(s) would form, because Al(s), the excess reagent, remains available (approximately 3.15 g unreacted) to react with additional CuSO4(aq) until either reagent is fully consumed.$ans$),
('apchem-frq-l-017', $ans$(a) HC2H3O2(aq) + OH-(aq) -> C2H3O2-(aq) + H2O(l)
(b) mol NaOH = 0.03240 L x 0.150 M = 4.86 x 10^-3 mol
(c) By 1:1 stoichiometry, mol HC2H3O2 = 4.86 x 10^-3 mol; M = 4.86 x 10^-3 mol / 0.02500 L approximately 0.194 M
(d) The pH is greater than 7 at the equivalence point, because the solution at that point contains C2H3O2-, the conjugate base of a weak acid, which hydrolyzes water (C2H3O2- + H2O <-> HC2H3O2 + OH-) to produce OH-, making the solution basic.
(e) The equivalence-point pH is estimated to be about 8.8 (basic, consistent with part d). An appropriate indicator is phenolphthalein, because its color-change transition range lies within the steep, nearly vertical portion of the titration curve near this equivalence-point pH.
(f) [H+] = sqrt(Ka x C) = sqrt((1.8 x 10^-5)(0.194)) approximately 1.87 x 10^-3 M; pH approximately 2.73
(g) At the half-equivalence point, [HA] = [A-], so pH = pKa = -log(1.8 x 10^-5) approximately 4.74
(h) Near the half-equivalence point, comparable amounts of the weak acid and its conjugate base are present, giving the solution strong buffering capacity, so added NaOH produces little pH change. Near the equivalence point, little of the original weak acid remains to buffer against added base, so each additional increment of NaOH causes the pH to rise sharply.$ans$),
('apchem-frq-l-020', $ans$(a) q(water) = m x c x deltaT = (75.0 g)(4.18 J/(g*C))(24.6 C - 21.2 C) = (75.0)(4.18)(3.4) approximately 1066 J
(b) By conservation of energy, q(metal) = -q(water) approximately -1066 J. c(metal) = q(metal) / (m x deltaT) = 1066 J / [(45.0 g)(98.5 C - 24.6 C)] = 1066 / (45.0 x 73.9) approximately 0.32 J/(g*C)
(c) The calculated specific heat capacity would be too low. If the metal cooled somewhat below 98.5 C during the 15-second delay before transfer, its actual temperature change (and the heat it released to the water) would be smaller than assumed, while the calculation still uses the larger assumed deltaT (98.5 C minus final), which drives the calculated c(metal) down.
(d) The calculated specific heat (approximately 0.32 J/(g*C)) is closest to copper's reference value of 0.385 J/(g*C) among the choices given, so the metal is most likely copper.$ans$),
('apchem-frq-l-021', $ans$(a) Reaction 1 is used as written (x1); reaction 2 must be multiplied by 2 (to supply 2 S(s)); reaction 3 must be reversed (to put CS2 on the product side). Combining these three manipulated reactions cancels the O2, CO2, and SO2 terms, leaving C(s) + 2 S(s) -> CS2(l), the target equation.
(b) deltaH1 (x1) = -393.5 kJ/mol; deltaH2 (x2) = 2 x (-296.8) = -593.6 kJ/mol; deltaH3 reversed = +1103.9 kJ/mol. Summing: deltaH(rxn) = -393.5 + (-593.6) + 1103.9 approximately +116.8 kJ/mol
(c) The classmate is only partly correct. Reversing reaction 3 does correctly flip the sign of its deltaH from -1103.9 kJ/mol to +1103.9 kJ/mol (this reversed step is itself endothermic). However, that single reversed value does not by itself determine the sign of the overall target reaction -- the target deltaH is the sum of all three manipulated values (-393.5 + -593.6 + 1103.9), and the sum here comes out positive (+116.8 kJ/mol), meaning the target reaction is actually endothermic, not exothermic as the classmate claimed.
(d) Hess's Law is valid because enthalpy is a state function: deltaH for a reaction depends only on the initial and final states (reactants and products), not on the pathway taken between them. So any valid combination of steps that sums to the target reaction must sum to the same total deltaH regardless of the route used.$ans$),
('apchem-frq-l-022', $ans$First, calculate Qc using the initial concentrations: [H2]0 = [I2]0 = 0.200 M, [HI]0 = 0 M, so Qc = [HI]0^2 / ([H2]0[I2]0) = 0^2 / (0.200 x 0.200) = 0. Since Qc (0) is less than Kc (54.3), the reaction proceeds forward (toward products) to reach equilibrium.

ICE table (all concentrations in M):
H2(g) + I2(g) <-> 2HI(g)
Initial: 0.200, 0.200, 0
Change: -x, -x, +2x
Equilibrium: 0.200-x, 0.200-x, 2x

Equilibrium constant expression: Kc = [HI]^2 / ([H2][I2])

Substituting the ICE-table expressions: 54.3 = (2x)^2 / (0.200-x)^2. Taking the positive square root of both sides: sqrt(54.3) = 2x / (0.200-x), so 2x / (0.200-x) approximately 7.37. Solving gives x approximately 0.157 M.

Equilibrium concentrations: [H2] = [I2] = 0.200 - 0.157 approximately 0.043 M; [HI] = 2(0.157) approximately 0.315 M.$ans$),
('apchem-frq-l-023', $ans$Converting moles to concentrations by dividing by the 2.00 L container volume: [SO2] = 0.400 mol / 2.00 L = 0.200 M, [O2] = 0.200 mol / 2.00 L = 0.100 M, [SO3] = 1.600 mol / 2.00 L = 0.800 M.

Equilibrium expression: Kc = [SO3]^2 / ([SO2]^2[O2])

Kc = (0.800)^2 / [(0.200)^2(0.100)] = 0.640 / (0.0400 x 0.100) = 0.640 / 0.00400 = 160

Interpretation: since Kc (160) is much greater than 1, the equilibrium is product-favored -- at equilibrium the mixture contains far more SO3 than SO2 or O2, consistent with the given equilibrium amounts (1.600 mol SO3 versus 0.400 mol SO2 and 0.200 mol O2). This describes the actual equilibrium composition of this particular mixture, not a general claim that the reaction always goes to completion.

Effect of adding more O2(g): adding O2 increases [O2], so Q momentarily becomes less than Kc. By Le Chatelier's principle, the equilibrium shifts to the right (toward SO3) to partially consume the added O2 and re-establish equilibrium, so [SO2] and [O2] decrease and [SO3] increases relative to the disturbed state. The value of Kc itself does not change, since Kc is affected only by a change in temperature, not by a concentration disturbance.$ans$),
('apchem-frq-l-024', $ans$(a) C2H5COOH(aq) + H2O(l) <-> H3O+(aq) + C2H5COO-(aq); Ka = [H3O+][C2H5COO-] / [C2H5COOH]
(b) ICE table (M): C2H5COOH <-> H3O+ + C2H5COO-; Initial: 0.150, 0, 0; Change: -x, +x, +x; Equilibrium: 0.150-x, x, x. Using the small-x approximation, Ka = x^2/0.150 = 1.3 x 10^-5, so x^2 = 1.95 x 10^-6 and x approximately 1.4 x 10^-3 M = [H3O+]
(c) pH = -log[H3O+] = -log(1.4 x 10^-3) approximately 2.85
(d) The percent dissociation would increase upon dilution to 0.015 M. Diluting the solution shifts the equilibrium toward the side with more dissolved particles (the dissociated ions), per Le Chatelier's principle, so a larger fraction of the acid dissociates -- even though the actual [H3O+] decreases in absolute terms.
(e) Because Ka is small (1.3 x 10^-5), only a small fraction of the acid is expected to dissociate, so x should be small relative to the initial concentration (0.150 M). The approximation is valid because x/0.150 is well under about 5%, so neglecting x in the denominator introduces negligible error.
(f) percent dissociation = (1.4 x 10^-3 / 0.150) x 100% approximately 0.93%
(g) The 0.150 M HCl solution would have a lower pH (be more acidic) than the 0.150 M propanoic acid solution. HCl is a strong acid and fully dissociates, giving [H3O+] = 0.150 M, whereas propanoic acid is a weak acid that only partially dissociates (approximately 0.93%), giving a much smaller [H3O+] (approximately 1.4 x 10^-3 M) and therefore a higher pH.$ans$),
('apchem-frq-l-025', $ans$(a) CH3COOH(aq) + OH-(aq) -> CH3COO-(aq) + H2O(l)
(b) mol acid = 0.100 M x 0.0250 L = 2.50 x 10^-3 mol; at equivalence, mol NaOH needed = 2.50 x 10^-3 mol; V = 2.50 x 10^-3 mol / 0.100 M = 25.0 mL
(c) 12.5 mL is the half-equivalence point (half of the 25.0 mL equivalence volume), where moles of CH3COOH remaining equal moles of CH3COO- formed, so [CH3COOH] = [CH3COO-]. This is a convenient reference point because pH = pKa = -log(1.8 x 10^-5) approximately 4.74 at exactly this point, simplifying the calculation.
(d) At the equivalence point, total volume = 25.0 mL + 25.0 mL = 50.0 mL, so [CH3COO-] = 2.50 x 10^-3 mol / 0.0500 L = 0.0500 M. Using Kb = Kw/Ka = 1.0 x 10^-14 / 1.8 x 10^-5 approximately 5.56 x 10^-10 for the hydrolysis CH3COO-(aq) + H2O(l) <-> CH3COOH(aq) + OH-(aq): x^2/0.0500 = 5.56 x 10^-10, x approximately 5.27 x 10^-6 M = [OH-], pOH approximately 5.28, so pH approximately 8.7.
(e) The pH is greater than 7 at the equivalence point because the solution at that point contains the conjugate base CH3COO-, which reacts with water to produce OH-, making the solution basic -- the acid and base have reacted in stoichiometric amounts, but this does not mean the resulting solution is neutral.
(f) The equivalence-point volume would double to 50.0 mL, since doubling the acid concentration doubles the moles of acid that must be neutralized while the NaOH concentration stays the same.
(g) Phenolphthalein is the appropriate indicator, because its transition range lies within the steep pH rise near this weak-acid/strong-base equivalence point (approximately 8.7). Methyl orange (pH 3.1-4.4) would be inappropriate because its color-change range is far below the equivalence-point pH and would change color long before equivalence is reached, giving an inaccurate endpoint.$ans$),
('apchem-frq-l-026', $ans$(a) Ka(NH4+) = Kw/Kb = 1.0 x 10^-14 / 1.8 x 10^-5 approximately 5.6 x 10^-10; pKa approximately 9.25
(b) pH = pKa + log([NH3]/[NH4+]) = 9.25 + log(0.30/0.25) = 9.25 + log(1.2) approximately 9.25 + 0.08 approximately 9.33
(c) Net ionic equation: NH3(aq) + H+(aq) -> NH4+(aq). Mechanistically, the base component of the buffer, NH3, reacts directly with the added H+, converting it into NH4+ (the weak acid) -- this consumes the added strong acid's H+ before it can substantially lower the solution's pH.
(d) After adding 0.020 mol HCl: mol NH3 decreases from 0.30 to 0.28 mol; mol NH4+ increases from 0.25 to 0.27 mol. New pH = 9.25 + log(0.28/0.27) approximately 9.25 + 0.01 approximately 9.27, only a small pH change compared to what would occur without a buffer present.
(e) The buffer can neutralize up to (but not including) 0.30 mol of strong acid -- the amount of NH3 available -- while still retaining both buffer components; at exactly 0.30 mol added, all NH3 is consumed and buffering capacity is lost.
(f) After adding 0.020 mol NaOH instead: mol NH4+ decreases from 0.25 to 0.23 mol; mol NH3 increases from 0.30 to 0.32 mol. New pH = 9.25 + log(0.32/0.23) approximately 9.25 + 0.14 approximately 9.39
(g) A buffer prepared with equal concentrations of NH3 and NH4Cl at the same total buffer concentration has equal stoichiometric reserves of base and acid, so it can neutralize the same amount of added acid as added base before either component is exhausted -- giving more even (symmetric) resistance to pH change from both directions, unlike the given 0.30 M / 0.25 M buffer, which has more reserve capacity against added acid than against added base.$ans$),
('apchem-frq-l-027', $ans$(a) deltaG = deltaH - T x deltaS = 178 kJ/mol - (298 K)(0.161 kJ/(mol*K)) = 178 - 47.98 approximately +130 kJ/mol. Since deltaG is greater than 0 at 298 K, the reaction is not thermodynamically favorable at this temperature.
(b) Setting deltaG = 0: T = deltaH/deltaS = 178 kJ/mol / 0.161 kJ/(mol*K) approximately 1106 K
(c) Since deltaS is positive, the -TdeltaS term becomes more negative as T increases. At sufficiently high T, the magnitude of this negative -TdeltaS term exceeds the positive deltaH term, making the overall deltaG negative -- so raising the temperature makes this reaction more thermodynamically favorable.
(d) The student's claim is incorrect: thermodynamic favorability depends on the sign of deltaG, which depends on both deltaH and deltaS, and on temperature -- not on the sign of deltaS alone. Part (a) is a direct counterexample: although deltaS is greater than 0, deltaG is positive (unfavorable) at 298 K, showing the reaction is not spontaneous at all temperatures.
(e) At T = 1200 K: deltaG = 178,000 J/mol - (1200 K)(161 J/(mol*K)) = 178,000 - 193,200 = -15,200 J/mol approximately -15.2 kJ/mol. This negative value confirms the reaction is thermodynamically favorable at 1200 K, consistent with 1200 K being above the approximately 1106 K crossover temperature found in part (b).$ans$),
('apchem-frq-l-028', $ans$(a) Since Ag+/Ag has the more positive standard reduction potential (+0.80 V versus +0.34 V for Cu2+/Cu), Ag+ + e- -> Ag(s) is the reduction (cathode) half-reaction, and Cu(s) -> Cu2+ + 2e- is the oxidation (anode) half-reaction.
(b) Cu(s) | Cu2+(aq, 1.0 M) || Ag+(aq, 1.0 M) | Ag(s) -- the anode is written on the left and the cathode on the right, with the double line representing the salt bridge and phases labeled.
(c) Ecell = Ecathode - Eanode = 0.80 V - 0.34 V = +0.46 V
(d) 2 Ag+(aq) + Cu(s) -> 2 Ag(s) + Cu2+(aq)
(e) Electrons flow through the external wire from the copper (anode) electrode to the silver (cathode) electrode. If additional AgNO3 is dissolved into the cathode compartment, increasing [Ag+], the Nernst equation, Ecell = E(cell) - (RT/nF)ln Q, shows that increasing [Ag+] (a reactant in the overall cell reaction) decreases Q, making the ln Q term more negative and subtracting a smaller (more negative) amount from E(cell) -- so the measured cell potential increases above +0.46 V.$ans$),
('apchem-sfrq-014', $ans$(a) The electron-domain geometry around Xe is octahedral, because there are six total electron domains around Xe (4 bonding pairs to F plus 2 lone pairs), and six domains arrange themselves octahedrally to minimize repulsion.
(b) The molecular geometry of XeF4 is square planar. The two lone pairs occupy positions directly opposite each other (180 degrees apart, the axial positions of the octahedron) to minimize lone pair-lone pair repulsion, leaving the four F atoms arranged in a square plane around Xe.
(c) XeF4 is a nonpolar molecule. The four Xe-F bond dipoles are identical in magnitude and are arranged symmetrically in the square planar geometry, so they cancel by symmetry, resulting in no net molecular dipole moment.$ans$),
('apchem-sfrq-015', $ans$(a) Total moles = 0.200 mol + 0.300 mol = 0.500 mol. P(total) = nRT/V = (0.500 mol)(0.0821 L*atm/mol*K)(300. K) / 10.0 L approximately 1.23 atm
(b) Mole fraction of Ar = 0.300/0.500 = 0.600. P(Ar) = 0.600 x 1.23 atm approximately 0.739 atm
(c) Disagree with the claim. Collision frequency depends on both the number of particles present and their speed, not on moles alone. The ratio of collision rates He:Ar = (n(He)/n(Ar)) x (v(He)/v(Ar)) = (0.200/0.300) x sqrt(40./4.00) = 0.667 x 3.16 approximately 2.1. Even though fewer moles of He are present, He atoms move much faster (lower molar mass gives higher average speed at the same temperature, since both gases have the same average kinetic energy), and this speed advantage outweighs the smaller amount, so He particles actually collide with the walls more frequently than Ar particles.$ans$),
('apchem-sfrq-016', $ans$(a) The strongest IMF in pure propane is London dispersion forces; the strongest IMF in pure 1-propanol is hydrogen bonding.
(b) 1-propanol molecules contain an O-H bond, allowing them to form hydrogen bonds with each other (the O has lone pairs to accept a hydrogen bond, and the O-H hydrogen is highly polarized). These hydrogen bonds are stronger than the dipole-dipole forces present between acetone molecules, so more energy is required to separate 1-propanol molecules into the gas phase, giving 1-propanol the higher boiling point despite the two compounds having similar molar mass.
(c) The boiling point would increase upon forming 1-chloropropane. Replacing a hydrogen with a chlorine atom creates a molecular dipole (the C-Cl bond is polar) and increases molar mass/polarizability, adding dipole-dipole forces on top of stronger London dispersion forces -- both stronger than the dispersion-only interactions in propane -- requiring more energy to vaporize and raising the boiling point.$ans$),
('apchem-sfrq-018', $ans$(a) The strongest IMF in diethyl ether is dipole-dipole forces; the strongest IMF in ethanol is hydrogen bonding.
(b) Ethanol molecules can hydrogen bond through their O-H group, while diethyl ether molecules have no O-H bond and so cannot act as hydrogen-bond donors -- they experience only weaker dipole-dipole (plus dispersion) attractions. Because ethanol's intermolecular attractions are stronger, its molecules are held more tightly in the liquid, making escape into the vapor phase less favorable. This gives ethanol the far lower vapor pressure, even though its molar mass (approximately 46 g/mol) is smaller than diethyl ether's (approximately 74 g/mol).
(c) Ethanol's equilibrium vapor pressure would increase at 40 C. Higher temperature raises the average kinetic energy of the ethanol molecules, so a greater fraction have enough energy to overcome the hydrogen bonds holding them in the liquid and escape into the vapor phase. Evaporation initially exceeds condensation until a new dynamic equilibrium is established at a higher vapor concentration and pressure.$ans$),
('apchem-sfrq-019', $ans$(a) mol NaCl = 5.85 g / 58.5 g/mol = 0.100 mol; M = 0.100 mol / 0.250 L = 0.400 M
(b) At the particulate level, the Na+ and Cl- ions released upon dissolution are uniformly dispersed throughout the water, so any sample taken from the solution has the same composition and properties -- this uniform dispersion at the particle level is what makes the mixture homogeneous rather than heterogeneous.
(c) The solute is NaCl (the substance dissolved, present in the smaller amount), and the solvent is water (the substance doing the dissolving, present in the larger amount).$ans$),
('apchem-sfrq-021', $ans$(a) AgNO3(aq) + NaCl(aq) -> AgCl(s) + NaNO3(aq)
(b) Complete ionic equation: Ag+(aq) + NO3-(aq) + Na+(aq) + Cl-(aq) -> AgCl(s) + Na+(aq) + NO3-(aq). Canceling the spectator ions gives the net ionic equation: Ag+(aq) + Cl-(aq) -> AgCl(s)
(c) The spectator ions are Na+(aq) and NO3-(aq), since they appear unchanged on both sides of the complete ionic equation and do not participate in forming the precipitate.$ans$),
('apchem-sfrq-022', $ans$(a) mol Pb(NO3)2 = 0.1000 L x 0.200 M = 0.0200 mol; mol KI = 0.1000 L x 0.500 M = 0.0500 mol. The reaction requires 2 mol KI per 1 mol Pb(NO3)2, so reacting all 0.0200 mol Pb(NO3)2 requires 0.0400 mol KI, less than the 0.0500 mol KI available. Therefore Pb(NO3)2 is the limiting reagent.
(b) mass PbI2 = 0.0200 mol Pb(NO3)2 x (1 mol PbI2 / 1 mol Pb(NO3)2) x 461.0 g/mol approximately 9.22 g$ans$),
('apchem-sfrq-023', $ans$(a) Oxidation states: in MnO4-, Mn is +7 (each O is -2, giving 4 x (-2) = -8, and the overall charge is -1, so Mn = +7); in Mn2+, Mn is +2. In Fe2+, Fe is +2; in Fe3+, Fe is +3.
(b) Oxidation half-reaction: Fe2+(aq) -> Fe3+(aq) + e-. Reduction half-reaction: MnO4-(aq) + 8H+(aq) + 5e- -> Mn2+(aq) + 4H2O(l)
(c) To balance electrons, multiply the iron half-reaction by 5: 5Fe2+(aq) -> 5Fe3+(aq) + 5e-. Adding this to the reduction half-reaction and canceling the 5 electrons on each side gives the overall balanced net ionic equation: MnO4-(aq) + 8H+(aq) + 5Fe2+(aq) -> Mn2+(aq) + 4H2O(l) + 5Fe3+(aq). Charge check: left side = -1 + 8 + 10 = +17; right side = +2 + 15 = +17, balanced.
(d) MnO4- is the oxidizing agent, because it accepts electrons (Mn goes from +7 to +2) and is itself reduced.$ans$),
('apchem-sfrq-024', $ans$Increasing the concentration of a reactant increases the frequency of collisions between reactant particles per unit time (more particles in the same volume means more encounters), which increases the reaction rate. However, not every collision leads to a reaction -- particles must also collide with the proper orientation for the correct bonds to break and new bonds to form, so only a fraction of collisions are effective regardless of concentration.

Increasing temperature increases the average speed (kinetic energy) of the reactant particles, which modestly increases the frequency of collisions between particles. But temperature's main effect on rate is different: raising the temperature substantially increases the fraction of collisions that occur with kinetic energy equal to or greater than the activation energy. Because this fraction grows sharply with temperature, this is the primary reason reaction rate increases so much when temperature is raised, more so than the modest increase in collision frequency alone.$ans$),
('apchem-sfrq-026', $ans$(a) The process is endothermic. This is supported by the observation that the outside of the test tube feels colder -- since the test tube's temperature drops as the solid dissolves, the dissolution process is absorbing heat from its surroundings.
(b) The dissolving NH4NO3 (the system) absorbs thermal energy from the surroundings (the water and the tube itself) as it dissolves. Because the surroundings lose thermal energy to the system, the surroundings' own temperature decreases, which is what makes the outside of the tube feel cold -- the system is not producing cold, it is removing heat energy from its surroundings.
(c) deltaS is positive: the ordered solid lattice separates into dispersed, mobile, solvated ions in solution, so entropy increases. Even though deltaH is positive (endothermic), this positive deltaS is large enough that at room temperature the TdeltaS term outweighs deltaH, making deltaG = deltaH - TdeltaS negative -- so the process is spontaneous despite being endothermic.$ans$),
('apchem-sfrq-027', $ans$(a) The products have lower potential energy than the reactants. This is supported by the negative sign of deltaH(rxn) (-890.4 kJ/mol): since energy is released to the surroundings as the reaction proceeds, the system must move from a higher-energy state (reactants) to a lower-energy state (products).
(b) The error is that the student calls the value "a negative enthalpy," when in fact -890.4 kJ/mol is the enthalpy change (deltaH) of the reaction, not an enthalpy possessed by the products. A negative deltaH means heat is released, but it does not by itself establish that the products are "very stable" -- overall thermodynamic stability/spontaneity depends on deltaG (which also involves entropy), not on deltaH alone. Corrected statement: "This reaction has a negative enthalpy change (deltaH), meaning heat is released to the surroundings as the products form."
(c) mol CH4 = 25.0 g / 16.04 g/mol approximately 1.56 mol. Energy released = 1.56 mol x 890.4 kJ/mol approximately 1390 kJ$ans$),
('apchem-sfrq-028', $ans$(a) Bonds broken (reactants): H-H (436 kJ/mol) + F-F (159 kJ/mol) = +595 kJ/mol (energy must be added to break bonds). Bonds formed (products): 2 x H-F = 2 x (-565 kJ/mol) = -1130 kJ/mol (energy is released when bonds form). deltaH(rxn) = (bonds broken) + (bonds formed) = 595 + (-1130) = -535 kJ/mol
(b) The reaction is exothermic, consistent with the calculated negative deltaH(rxn) (-535 kJ/mol). This negative value means the bonds formed in the products (H-F) are collectively stronger than the bonds broken in the reactants (H-H and F-F) -- more energy is released forming the new bonds than was required to break the old ones.$ans$),
('apchem-sfrq-029', $ans$Ksp = [Mg2+][OH-]^2 = (s)(2s)^2 = 4s^3. Solving: 4s^3 = 5.61 x 10^-12, s^3 = 1.4025 x 10^-12, s approximately 1.1 x 10^-4 M. The molar solubility of Mg(OH)2 in pure water is approximately 1.1 x 10^-4 M.

If the solution pH were lowered, [H+] increases, and the added H+ reacts with and lowers [OH-]. By Le Chatelier's principle, the dissolution equilibrium Mg(OH)2(s) <-> Mg2+(aq) + 2OH-(aq) shifts to the right (toward dissolution) to replace the consumed OH-, so the molar solubility of Mg(OH)2 increases.

If solid Mg(NO3)2 were dissolved into the same solution instead, [Mg2+] increases. By the common-ion effect, this shifts the dissolution equilibrium to the left (toward solid Mg(OH)2), decreasing the molar solubility of Mg(OH)2.$ans$),
('apchem-sfrq-030', $ans$(i) Increasing the temperature: since this reaction is exothermic (deltaH = -92 kJ/mol), heat can be treated as a product. Adding thermal energy (increasing T) shifts the equilibrium left (toward reactants), and because K depends only on temperature, K decreases.
(ii) Decreasing the container volume (at constant temperature, via the movable piston): this increases the pressure/concentration of all species. The equilibrium shifts right (toward NH3), because the product side has fewer moles of gas (2 mol NH3 versus 4 mol total reactant gas), so shifting right partially relieves the increased pressure. K is unchanged, since K depends only on temperature.
(iii) Adding a catalyst: a catalyst does not shift the equilibrium position and does not change K. It only speeds up the rate at which equilibrium is reached, by increasing the rate of both the forward and reverse reactions equally.$ans$),
('apchem-sfrq-031', $ans$(a) HSO4- is the Bronsted-Lowry acid (it donates a proton), and H2O is the Bronsted-Lowry base (it accepts a proton) in the forward reaction.
(b) The conjugate base of HSO4- is SO4^2- (formed after HSO4- donates its proton); the conjugate acid of H2O is H3O+ (formed after H2O accepts a proton).
(c) The two conjugate acid-base pairs are HSO4-/SO4^2- and H3O+/H2O.
(d) The claim is incorrect because water is amphiprotic -- it can act as an acid, donating a proton, or as a base, accepting a proton, depending on what it reacts with. In this reaction, H2O accepts a proton from HSO4- and acts as a base. Water only fails to act as a base when paired with a species that is a weaker acid than water itself; it acts as a base only when reacting with a species (like HSO4-) that is a stronger acid than water.$ans$),
('apchem-sfrq-032', $ans$(a) At the equivalence point, mol HCl = mol NaOH needed. mol HCl = 0.0200 L x 0.200 M = 0.00400 mol. V(NaOH) = 0.00400 mol / 0.100 M = 0.0400 L = 40.0 mL
(b) 30.0 mL of NaOH added is before the 40.0 mL equivalence point. mol NaOH added = 0.0300 L x 0.100 M = 0.00300 mol. Excess mol H+ remaining = 0.00400 mol - 0.00300 mol = 0.00100 mol. Total solution volume = 20.0 mL + 30.0 mL = 50.0 mL. [H+] = 0.00100 mol / 0.0500 L = 0.0200 M; pH = -log(0.0200) approximately 1.70
(c) The pH curve rises gradually at first, then rises very steeply (nearly vertically) near the 40.0 mL equivalence point, before leveling off in the basic region past equivalence. At the equivalence point itself, since this is a strong acid-strong base titration, the resulting salt (NaCl) does not hydrolyze, so the pH is neutral, approximately 7.00.$ans$),
('apchem-sfrq-033', $ans$(a) A-(aq) + H+(aq) -> HA(aq) -- the conjugate base A- reacts with and consumes the added H+.
(b) HA(aq) + OH-(aq) -> A-(aq) + H2O(l) -- the weak acid HA reacts with and consumes the added OH-.
(c) The statement is vague -- it does not specify what is actually reacting. A more precise description: when strong acid is added, the conjugate base A- reacts directly with the added H+ to form HA (as shown in part a), consuming the added acid rather than simply "neutralizing anything." Because both HA and A- are present in significant, comparable concentrations, the buffer's [HA]/[A-] ratio changes only slightly when a small amount of strong acid or base is added, which is why the pH itself changes only slightly.$ans$),
('apchem-sfrq-034', $ans$(a) When pH = pKa, the Henderson-Hasselbalch equation, pH = pKa + log([A-]/[HA]), gives log([A-]/[HA]) = pH - pKa = 4.20 - 4.20 = 0, so [A-]/[HA] = 10^0 = 1. The ratio [A-]/[HA] is 1 (a 1:1 ratio).
(b) HA predominates in this solution. Since pH (3.20) is less than pKa (4.20), the solution is more acidic than the pH = pKa condition, meaning less of the acid has dissociated relative to its conjugate base -- so the protonated form, HA, is present in greater concentration than A-.
(c) In general, when pH is less than pKa, the protonated (acid, HA) form predominates; when pH is greater than pKa, the deprotonated (conjugate base, A-) form predominates; when pH equals pKa, the two forms are present in equal concentration. This follows directly from the Henderson-Hasselbalch equation, pH - pKa = log([A-]/[HA]): as pH moves above or below pKa, the ratio [A-]/[HA] moves above or below 1 accordingly.$ans$),
('apchem-sfrq-035', $ans$(a) Both buffers have an initial pH of 4.74. Using the Henderson-Hasselbalch equation, pH = pKa + log([A-]/[HA]); since both buffers have a 1:1 ratio of CH3COOH to CH3COO- regardless of total concentration, log(1) = 0, so pH = pKa = 4.74 for both Buffer A and Buffer B -- the total concentration does not affect pH as long as the ratio stays 1:1.
(b) Buffer A: initial mol CH3COOH = mol CH3COO- = 0.10 mol (in 1.00 L). Adding 0.010 mol HCl converts 0.010 mol CH3COO- to CH3COOH: new mol CH3COOH = 0.11 mol, new mol CH3COO- = 0.09 mol. New pH = 4.74 + log(0.09/0.11) approximately 4.74 - 0.09 approximately 4.65
(c) Buffer B: initial mol CH3COOH = mol CH3COO- = 1.0 mol. Adding 0.010 mol HCl: new mol CH3COOH = 1.01 mol, new mol CH3COO- = 0.99 mol. New pH = 4.74 + log(0.99/1.01) approximately 4.74 - 0.01 approximately 4.73
(d) Buffer B has the greater buffer capacity. Because Buffer B contains much larger absolute amounts of CH3COOH and CH3COO- (1.0 mol each versus 0.10 mol each) available to consume added H+ or OH-, the same 0.010 mol addition changes the [HA]/[A-] ratio, and therefore the pH, much less in Buffer B than in the more dilute Buffer A (deltapH approximately 0.01 for B versus approximately 0.09 for A).$ans$),
('apchem-sfrq-036', $ans$(a) deltaS(sys) is positive for this process. Before dissolution, the ions are locked in an ordered solid crystal lattice; after dissolution, they become dispersed, mobile, hydrated ions moving freely throughout the solution. This large increase in the number of independently moving particles and disorder outweighs any local ordering of water molecules around the ions, so the net entropy of the process increases.
(b) Since deltaH is greater than 0, the process is endothermic on its own, which would tend to make deltaG positive (unfavorable). However, because deltaS is greater than 0, the -TdeltaS term is negative, and at 298 K this term is large enough in magnitude to outweigh the positive deltaH term. The combination of these terms makes deltaG negative overall, so the process is thermodynamically favorable at room temperature even though it absorbs heat.$ans$),
('apchem-sfrq-037', $ans$(a) Ecell = Ecathode - Eanode. Sn2+/Sn (-0.14 V) is the cathode (more positive reduction potential) and Zn2+/Zn (-0.76 V) is the anode. Ecell = (-0.14 V) - (-0.76 V) = +0.62 V
(b) n = 2 mol electrons transferred per mole of reaction, based on the balanced equation (Zn loses 2 e-, Sn2+ gains 2 e-). deltaG = -nFE = -(2 mol e-)(96,485 C/mol e-)(0.62 V) approximately -120,000 J/mol approximately -120 kJ/mol
(c) The negative deltaG confirms the reaction is thermodynamically favorable (spontaneous). This is consistent in general: because deltaG = -nFE and n and F are always positive, a positive Ecell always corresponds to a negative deltaG (and vice versa) -- the negative sign in the equation directly links a spontaneous, favorable cell (positive E) to a negative deltaG.$ans$),
('apchem-sfrq-038', $ans$(a) Ca2+(l) + 2e- -> Ca(l)
(b) Convert time to seconds: 30.0 min x 60 s/min = 1800 s. Charge Q = I x t = (5.00 A)(1800 s) = 9000 C. mol e- = Q/F = 9000 C / 96,485 C/mol approximately 0.0933 mol e-
(c) Using the 2:1 electron-to-calcium ratio: mol Ca = 0.0933 mol e- x (1 mol Ca / 2 mol e-) approximately 0.0467 mol Ca. mass Ca = 0.0467 mol x 40.08 g/mol approximately 1.87 g Ca$ans$);

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null,
  old_criteria_count integer not null,
  old_points_sum numeric not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_answer text;
  v_new uuid;
  v_old_count integer;
  v_old_points numeric;
begin
  for t in select * from repair_targets order by content_key loop
    select ci.* into strict v_item
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    where ci.content_key = t.content_key
      and ci.item_type = 'frq'
      and ep.exam_name = 'AP Chemistry'
    for update of ci;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id = v_item.id and status = 'published'
    order by version_num desc
    limit 1
    for update;

    select count(*), coalesce(sum(points_possible), 0)
    into v_old_count, v_old_points
    from app.frq_criteria
    where content_item_version_id = v_old.id;

    select answer_text into strict v_answer
    from canonical_answers
    where content_key = t.content_key;

    v_new := gen_random_uuid();

    update app.content_review_assignments
    set status = 'skipped'
    where content_item_version_id = v_old.id
      and assignment_purpose = 'subject_review'
      and status in ('pending', 'in_progress');

    update app.content_item_versions
    set status = 'retired', updated_at = now()
    where id = v_old.id;

    update app.content_items
    set status = 'draft', updated_at = now()
    where id = v_item.id;

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, help_text, content_hash, status, created_by,
      canonical_answer_1, canonical_answer_2, review_status,
      rubric_type, evaluator_strategy, stimulus_image_path
    ) values (
      v_new, v_item.id, v_old.version_num + 1, v_old.stem, v_old.stimulus,
      coalesce(v_old.prompt_json, '{}'::jsonb) || jsonb_build_object(
        'content_version', v_old.version_num + 1,
        'qa_remediation', '2026-08-12 AP Chemistry FRQ canonical_answer_1 backfill (gold-set eligibility)',
        'qa_source_version_id', v_old.id
      ),
      v_old.explanation, v_old.help_text, v_old.content_hash,
      'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_answer, v_old.canonical_answer_2, null,
      v_old.rubric_type, v_old.evaluator_strategy, v_old.stimulus_image_path
    );

    insert into repaired values (t.content_key, v_old.id, v_new, v_old_count, v_old_points);
  end loop;
end $$;

-- Copy frq_criteria verbatim from each retired version to its replacement.
-- The rubric is not changed in any way by this repair.
insert into app.frq_criteria (
  content_item_version_id, criterion_key, learner_facing_text,
  points_possible, evidence_requirements, minimum_fix
)
select r.new_version_id, fc.criterion_key, fc.learner_facing_text,
       fc.points_possible, fc.evidence_requirements, fc.minimum_fix
from repaired r
join app.frq_criteria fc on fc.content_item_version_id = r.old_version_id;

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text||':'||fc.points_possible::text, E'\n' order by fc.criterion_key)
            from app.frq_criteria fc where fc.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

create temporary table qa_blocked as
select r.content_key,
  case
    when (select count(*) from app.frq_criteria fc where fc.content_item_version_id=civ.id) <> r.old_criteria_count then 'criteria count does not match retired version'
    when (select sum(fc.points_possible) from app.frq_criteria fc where fc.content_item_version_id=civ.id) <> r.old_points_sum then 'points do not match retired version'
    when nullif(trim(civ.canonical_answer_1), '') is null then 'blank canonical_answer_1'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table approve_set on commit drop as
select r.content_key, r.new_version_id
from repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','frq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from approve_set;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,
  decision_hash,created_by
)
select cra.content_review_assignment_id,p.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question',1,'Medium',false,array[]::text[],
       'Owner-directed AP Chemistry canonical_answer_1 backfill, 2026-08-12: populated canonical_answer_1 with a part-by-part model answer synthesized from the item''s own frq_criteria; rubric copied verbatim and unchanged -- ' || p.content_key,
       'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_canonical_answer_backfill','content_key',p.content_key,'qa_date','2026-08-12'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_canonical_answer_backfill','content_key',p.content_key,'qa_date','2026-08-12')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from approve_set p
join app.content_review_assignments cra on cra.content_item_version_id=p.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ
set status='reviewed_approved', review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()), updated_at=now()
from approve_set p where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from approve_set p join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now()
from approve_set p where civ.id=p.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from approve_set p join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>37 then raise exception 'expected 37 repaired items, got %', n; end if;

  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'AP Chemistry canonical_answer_1 backfill blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;

  select count(*) into n from approve_set;
  if n<>37 then raise exception 'expected 37 approved+published items, got %', n; end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after AP Chemistry canonical_answer_1 backfill: %', n; end if;
end $$;

select 'repaired' metric, count(*)::text value from repaired
union all select 'published', count(*)::text from approve_set
union all select 'qa_blocked', count(*)::text from qa_blocked
union all select 'published_keys', string_agg(content_key, ', ' order by content_key) from approve_set;

commit;
