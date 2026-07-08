#!/usr/bin/env python3
"""Generate the AP Chemistry FRQ grading-experiment corpus (docs/research/ap_chemistry_frq_grading_experiment_batch_2026_07_07).

Development test corpus only -- not a governed pilot batch, not a human gold set.
Authored from general chemistry curriculum knowledge; no College Board material used as input.
Trace-image PNGs are SYNTHETIC stylized renderings (matplotlib xkcd-style), not real scanned
handwritten responses -- unlike the real iPhone-photographed AP Statistics HDR images already
in this repo. See the companion README for full scope and rights notes.
"""
import json
import os
import random
import textwrap

random.seed(20260707)

OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "docs", "research",
                        "ap_chemistry_frq_grading_experiment_batch_2026_07_07")
IMG_DIR = os.path.join(OUT_DIR, "images")
os.makedirs(IMG_DIR, exist_ok=True)

# ---------------------------------------------------------------------------
# Item authoring
# ---------------------------------------------------------------------------
# Each item: content_key is assigned later. Fields:
#   module (1-9), difficulty (Easy/Medium/Hard/Very Hard), form (short/long),
#   hdr (bool -- requires shown work / drawn notation),
#   question_text, rubric (list of (criterion_key, learner_facing_text, points)),
#   canonical (full correct response text),
#   subtopics (list of str)

ITEMS = []

def add(module, difficulty, form, hdr, question_text, rubric, canonical, subtopics):
    ITEMS.append(dict(module=module, difficulty=difficulty, form=form, hdr=hdr,
                       question_text=question_text, rubric=rubric,
                       canonical=canonical, subtopics=subtopics))

# ===== MODULE 1: Atomic Structure and Periodicity =====

add(1, "Easy", "short", True,
    "Write the complete ground-state electron configuration for a neutral phosphorus atom (Z = 15). Show the subshells you filled and in what order.",
    [("config_correct", "Writes 1s2 2s2 2p6 3s2 3p3 with subshells filled in correct Aufbau order", 1)],
    "1s2 2s2 2p6 3s2 3p3. I filled 1s, then 2s, then 2p (6 electrons), then 3s, then placed the remaining 3 electrons in 3p, following the Aufbau order of increasing subshell energy, for a total of 15 electrons.",
    ["Electron configuration"])

add(1, "Easy", "long", True,
    "Consider the elements Na, Mg, Al, and Si. (a) Rank them in order of increasing atomic radius and justify your ranking using the concept of effective nuclear charge. (b) Rank them in order of increasing first ionization energy and explain how this ranking relates to your answer in part (a).",
    [("radius_ranking", "Correctly ranks Si < Al < Mg < Na and explains via increasing effective nuclear charge across the period", 1),
     ("radius_justification", "Explains that added protons are poorly shielded by electrons in the same shell", 1),
     ("ie_ranking", "Correctly ranks Na < Mg < Al < Si for increasing first ionization energy (or notes the Mg/Al deviation if invoked)", 1),
     ("ie_justification", "Connects ionization energy trend to the same effective-nuclear-charge/radius reasoning from part (a)", 1)],
    "(a) Increasing atomic radius: Si < Al < Mg < Na. Moving left to right across period 3, each added electron enters the same principal shell while an added proton increases nuclear charge; because same-shell electrons shield each other poorly, effective nuclear charge rises across the period, pulling the valence shell inward and shrinking the atom, so Na (leftmost) is largest and Si (rightmost) is smallest. (b) Increasing first ionization energy: Na < Mg < Al < Si (the general trend, ignoring the well-known Mg/Al subshell anomaly). This is the same underlying cause as part (a): as effective nuclear charge increases across the period, electrons are held more tightly, so more energy is required to remove one, in inverse relationship to the shrinking radius.",
    ["Periodic trends: atomic radius", "Periodic trends: ionization energy"])

add(1, "Medium", "short", True,
    "The first ionization energy of oxygen (1314 kJ/mol) is lower than that of nitrogen (1402 kJ/mol), even though oxygen has one more proton. Explain this anomaly in terms of electron configuration.",
    [("half_filled_stability", "Explains nitrogen's extra stability from a half-filled 2p3 subshell and the electron-electron repulsion in oxygen's paired 2p electron", 1)],
    "Nitrogen's 2p3 configuration is half-filled, which is an especially stable, lower-energy arrangement (each 2p orbital singly occupied, minimizing electron-electron repulsion). Oxygen's fourth 2p electron must pair up with one already in an orbital, and the resulting electron-electron repulsion in that doubly-occupied orbital makes it easier to remove, lowering oxygen's first ionization energy below nitrogen's despite oxygen's higher nuclear charge.",
    ["Periodic trends: ionization energy anomalies"])

add(1, "Medium", "long", True,
    "A photoelectron spectrum of a neutral element shows peaks, listed from lowest to highest binding energy, with relative intensities 2, 6, 2, 2, 1. (a) Determine the total number of electrons and identify the element. (b) Write the complete ground-state electron configuration consistent with this spectrum. (c) State which peak corresponds to the electrons with the lowest ionization energy and explain why.",
    [("electron_count", "Sums intensities to 13 electrons and identifies aluminum", 1),
     ("configuration", "Writes 1s2 2s2 2p6 3s2 3p1 consistent with the peak pattern", 1),
     ("lowest_ie_peak", "Identifies the lowest-binding-energy peak (intensity 1, the 3p electron) as corresponding to the lowest ionization energy", 1),
     ("reasoning", "Explains that binding energy and ionization energy both reflect how tightly an electron is held, so the outermost (valence, least tightly held) electron has the lowest of both", 1)],
    "(a) 2+6+2+2+1 = 13 electrons, so the element is aluminum (Z = 13). (b) 1s2 2s2 2p6 3s2 3p1, listed from highest to lowest binding energy as 1s(2), 2s(2), 2p(6), 3s(2), 3p(1) -- matching the given intensities in reverse order since the spectrum was listed from lowest to highest binding energy. (c) The peak with intensity 1 (lowest binding energy) corresponds to the single 3p electron. Binding energy measures how tightly an electron is held; the valence 3p electron is furthest from the nucleus and most shielded by inner electrons, so it is held least tightly and has both the lowest binding energy and would require the least energy to ionize.",
    ["Photoelectron spectroscopy (PES)"])

add(1, "Hard", "short", True,
    "Consider the isoelectronic ions O2-, F-, Na+, and Mg2+ (all with 10 electrons). Rank them from largest to smallest ionic radius and justify your ranking.",
    [("ranking", "Correctly ranks O2- > F- > Na+ > Mg2+", 1),
     ("justification", "Explains the ranking using increasing nuclear charge (protons) at fixed electron count", 1)],
    "Largest to smallest: O2- > F- > Na+ > Mg2+. All four species have the same 10-electron (neon) configuration, but their nuclear charge differs (8, 9, 11, and 12 protons respectively). With electron count fixed, more protons means a stronger net pull on the same electron cloud, pulling it inward; O2- has the fewest protons and thus the largest radius, while Mg2+ has the most protons and the smallest radius.",
    ["Isoelectronic species: ionic radius"])

add(1, "Hard", "long", True,
    "A student proposes that, within the isoelectronic series S2-, Cl-, K+, and Ca2+ (all 18 electrons), the ion with the smallest radius will also have the highest first ionization energy. (a) Determine which ion has the smallest radius and justify it quantitatively using proton count. (b) Evaluate whether the student's claim about ionization energy is correct, and explain the underlying relationship between radius and ionization energy for isoelectronic species. (c) Predict, with reasoning, how the second ionization energy of Ca2+ would compare to its first ionization energy.",
    [("smallest_radius", "Identifies Ca2+ as smallest, citing its highest proton count (20) among the 18-electron series", 1),
     ("claim_evaluation", "Correctly evaluates the student's claim as true and explains that both properties are driven by effective nuclear charge per electron", 1),
     ("relationship_explanation", "Articulates that higher nuclear charge per electron simultaneously shrinks radius and increases the energy needed to remove an electron", 1),
     ("second_ie_prediction", "Predicts the second ionization energy of Ca2+ is substantially higher than the first because it requires removing an electron from the stable, lower-energy 18-electron noble-gas-like core", 1)],
    "(a) Ca2+ has the smallest radius. Among S2-, Cl-, K+, and Ca2+, all have 18 electrons, but their proton counts are 16, 17, 19, and 20 respectively; Ca2+ has the most protons, giving it the strongest net attraction on the shared electron count and thus the smallest radius. (b) The student's claim is correct. For an isoelectronic series, both ionic radius and ionization energy are governed by the same underlying quantity: effective nuclear charge per electron. Ca2+, having the most protons per the fixed 18 electrons, has the highest effective nuclear charge, so its electrons are both pulled in most tightly (smallest radius) and hardest to remove (highest first ionization energy). (c) The second ionization energy of Ca2+ (removing an electron from Ca2+ to form Ca3+) would be dramatically higher than the first ionization energy of Ca2+ (removing an electron from Ca+ to form Ca2+), because Ca2+ already has the stable, complete 18-electron noble-gas-like configuration; removing an additional electron requires breaking into a lower, more tightly bound core shell, which requires far more energy.",
    ["Isoelectronic species: ionization energy and radius combined"])

add(1, "Very Hard", "short", True,
    "For the isoelectronic series N3-, O2-, F-, and Na+, predict which ion would show the largest deviation from a perfectly spherical electron distribution under an external field (i.e., is most polarizable), and justify your answer in terms of how tightly the electron cloud is held.",
    [("polarizability_prediction", "Identifies N3- as most polarizable and justifies via its lowest nuclear charge (loosest hold on electrons) among the isoelectronic series", 1)],
    "N3- is most polarizable. Among this isoelectronic series (N3-, O2-, F-, Na+), nuclear charge increases from N (7 protons) to Na (11 protons) while electron count is fixed at 10. Lower nuclear charge means the electron cloud is held less tightly and can be more easily distorted by an external field, so the ion with the fewest protons relative to its electron count, N3-, is the most polarizable, while Na+ (highest nuclear charge, tightest hold) is the least.",
    ["Isoelectronic species: polarizability"])

add(1, "Very Hard", "long", True,
    "Successive ionization energies (in MJ/mol) for an unknown element are: IE1 = 0.58, IE2 = 1.82, IE3 = 2.75, IE4 = 11.6, IE5 = 14.8. (a) Identify the group (main group number) this element most likely belongs to, based on the pattern of successive ionization energies, and explain your reasoning. (b) Explain, in terms of electron configuration and shielding, why there is such a large jump between IE3 and IE4. (c) Based on this pattern, propose a plausible identity for the element and justify it using its expected number of valence electrons.",
    [("group_identification", "Identifies the element as belonging to Group 13/IIIA based on the large jump appearing after the third ionization", 1),
     ("jump_explanation", "Explains the large IE3-to-IE4 jump as the transition from removing valence electrons to removing a core electron from a lower, more tightly bound shell", 1),
     ("shielding_detail", "Notes that core electrons are much closer to the nucleus and experience far less shielding, requiring much more energy to remove", 1),
     ("identity_proposal", "Proposes a plausible period-3 group-13 element (e.g., aluminum) with 3 valence electrons, consistent with the ionization pattern", 1)],
    "(a) This element most likely belongs to Group 13 (IIIA). The successive ionization energies rise only gradually from IE1 through IE3, then jump dramatically at IE4, indicating that the first three electrons removed are all valence electrons from the same outer shell, while the fourth electron removed must come from a completely different, much more tightly held inner shell -- consistent with an element having exactly 3 valence electrons. (b) The large jump between IE3 and IE4 occurs because IE1 through IE3 all remove valence-shell electrons, which are relatively far from the nucleus and shielded by the core electrons beneath them. IE4, however, requires removing an electron from the next shell down (a core electron), which is much closer to the nucleus and shielded by far fewer inner electrons, so effective nuclear charge on it is much higher and removing it costs far more energy. (c) A plausible identity is aluminum (Al), a period-3, group-13 element with electron configuration [Ne]3s2 3p1, giving it exactly 3 valence electrons (3s2 3p1) and 10 tightly bound core electrons ([Ne] configuration) -- consistent with the small IE1-IE3 gaps followed by the large jump at IE4 when the first core electron must be removed.",
    ["Successive ionization energies"])

# ===== MODULE 2: Molecular and Ionic Bonding and Structure =====

add(2, "Easy", "short", True,
    "Draw the complete Lewis structure for CO2, including all lone pairs, and state the number of total valence electrons used.",
    [("lewis_structure", "Draws O=C=O with two lone pairs on each oxygen and no lone pairs on carbon, using all 16 valence electrons", 1)],
    "O=C=O, with two lone pairs on each oxygen atom and no lone pairs on the central carbon. Total valence electrons: C contributes 4, each O contributes 6, for 4 + 6 + 6 = 16 valence electrons, all accounted for by the two C=O double bonds (4 bonding electron pairs) and four lone pairs on the oxygens (8 more electrons): 8 + 8 = 16.",
    ["Lewis structures"])

add(2, "Easy", "long", True,
    "For the molecule CH4: (a) draw the Lewis structure. (b) determine its electron-domain and molecular geometry, and state the approximate bond angle. (c) determine whether the molecule is polar or nonpolar and justify your answer.",
    [("lewis_structure", "Draws a correct Lewis structure with carbon bonded to 4 hydrogens and no lone pairs on carbon", 1),
     ("geometry", "Identifies tetrahedral electron-domain and molecular geometry with approximately 109.5 degree bond angles", 1),
     ("polarity", "Correctly identifies CH4 as nonpolar and justifies using symmetry canceling bond dipoles", 1)],
    "(a) Carbon is bonded to four hydrogen atoms by four single bonds, with no lone pairs on carbon. (b) With four bonding domains and no lone pairs, both the electron-domain and molecular geometry are tetrahedral, with bond angles of approximately 109.5 degrees. (c) CH4 is nonpolar. Although each individual C-H bond has a small dipole (carbon is slightly more electronegative than hydrogen), the symmetric tetrahedral arrangement causes the four bond dipoles to cancel exactly, giving the molecule no net dipole moment.",
    ["VSEPR: molecular geometry", "Molecular polarity"])

add(2, "Medium", "short", True,
    "Explain, using VSEPR theory, why the H-N-H bond angle in ammonia (NH3, approximately 107 degrees) is smaller than the ideal tetrahedral angle of 109.5 degrees.",
    [("lone_pair_repulsion", "Explains that the lone pair on nitrogen occupies more space and repels the bonding pairs more strongly, compressing the H-N-H angle", 1)],
    "Nitrogen in NH3 has four electron domains (three bonding pairs and one lone pair), giving an underlying tetrahedral electron-domain geometry. However, a lone pair is held closer to the central atom and spreads out more than a bonding pair, so it exerts greater repulsion on the neighboring bonding pairs than bonding pairs exert on each other. This extra repulsion compresses the H-N-H bond angle below the ideal tetrahedral angle, from 109.5 degrees down to about 107 degrees.",
    ["VSEPR: lone pair effects on bond angle"])

add(2, "Medium", "long", True,
    "For the molecule SO2: (a) draw a valid Lewis structure, including formal charges. (b) determine the electron-domain geometry, molecular geometry, and hybridization of the central sulfur atom. (c) determine whether SO2 is polar or nonpolar, and justify your answer using its molecular geometry.",
    [("lewis_structure", "Draws a valid resonance structure of SO2 with a lone pair on S and correct formal charges (e.g. S=O single-bonded O with -1/+1 or the double-bonded resonance form)", 1),
     ("geometry_hybridization", "Identifies trigonal planar electron-domain geometry, bent molecular geometry, and sp2 hybridization on sulfur", 1),
     ("polarity", "Identifies SO2 as polar and justifies using the bent, asymmetric shape that does not cancel bond dipoles", 1)],
    "(a) One valid resonance structure: S is double-bonded to one O and single-bonded to the other O (which carries a lone pair and a -1 formal charge, while S carries a +1 formal charge), with S also bearing one lone pair; the true structure is a resonance hybrid of the two equivalent forms. (b) Sulfur has three electron domains (two bonding domains to oxygen and one lone pair), giving a trigonal planar electron-domain geometry, a bent molecular geometry, and sp2 hybridization. (c) SO2 is polar. The bent molecular geometry is asymmetric, so the two S-O bond dipoles do not cancel; combined with the lone pair on sulfur, this produces a net molecular dipole moment.",
    ["Lewis structures with formal charge", "VSEPR and hybridization"])

add(2, "Hard", "short", True,
    "In the nitrate ion (NO3-), all three N-O bonds have the same experimentally measured length, intermediate between a typical N-O single bond and N=O double bond. Explain this observation using the concept of resonance.",
    [("resonance_explanation", "Explains that NO3- is a resonance hybrid of three equivalent contributing structures, giving each bond a fractional bond order of 4/3", 1)],
    "NO3- cannot be accurately represented by a single Lewis structure; it is a resonance hybrid of three equivalent contributing structures, each with one N=O double bond and two N-O single bonds in a different position. The true electronic structure is an average of these three forms, giving each of the three N-O bonds an equal, fractional bond order of 4/3 (partway between 1 and 2), which explains why all three bonds are experimentally equal in length and intermediate between single- and double-bond length.",
    ["Resonance and bond order"])

add(2, "Hard", "long", True,
    "Consider the molecule SF4. (a) Draw the Lewis structure, including any lone pairs on the central atom. (b) Determine the electron-domain geometry, molecular geometry, and hybridization of sulfur. (c) Determine whether SF4 is polar or nonpolar, explaining why the presence of the lone pair matters for this determination. (d) Compare SF4's molecular geometry to that of CF4, and explain why the two molecules have different shapes despite both having a central atom bonded to four atoms of similar electronegativity.",
    [("lewis_structure", "Draws sulfur bonded to four fluorines with one lone pair on sulfur (5 electron domains total)", 1),
     ("geometry_hybridization", "Identifies trigonal bipyramidal electron-domain geometry, seesaw molecular geometry, and sp3d hybridization", 1),
     ("polarity", "Identifies SF4 as polar and explains the lone pair creates molecular asymmetry that prevents bond dipole cancellation", 1),
     ("comparison_to_cf4", "Explains that CF4 has 4 domains (all bonding, tetrahedral) while SF4 has 5 domains (4 bonding + 1 lone pair, seesaw), so the extra lone pair on sulfur is the source of the geometric difference", 1)],
    "(a) Sulfur is bonded to four fluorine atoms with one lone pair remaining on sulfur, for a total of five electron domains around the central atom. (b) Five electron domains give a trigonal bipyramidal electron-domain geometry; with the lone pair occupying an equatorial position (to minimize repulsion), the molecular geometry is seesaw, and sulfur is sp3d hybridized. (c) SF4 is polar. The seesaw shape is asymmetric because the lone pair displaces the four S-F bonds from a fully symmetric arrangement, so the individual bond dipoles do not cancel and the molecule has a net dipole moment. (d) CF4 has four electron domains around carbon, all bonding pairs, giving a symmetric tetrahedral geometry where the four C-F bond dipoles cancel exactly (nonpolar). SF4 has five electron domains around sulfur -- four bonding pairs plus one lone pair -- so the extra lone pair distorts the arrangement into the asymmetric seesaw shape; the fundamental difference in shape arises because sulfur has an additional nonbonding electron domain that carbon, with no lone pairs in CF4, does not have.",
    ["Combined VSEPR, hybridization, and polarity"])

add(2, "Very Hard", "short", True,
    "Explain why the bond length in the carbon-oxygen bond of CO (approximately 113 pm) is shorter than the C-O bonds in CO32- (approximately 129 pm), using bond order.",
    [("bond_order_explanation", "Explains CO has a triple bond (bond order 3) while CO32-'s resonance-averaged bond order is 4/3, and higher bond order corresponds to shorter, stronger bonds", 1)],
    "CO has a carbon-oxygen triple bond, giving a bond order of approximately 3, while CO32- is a resonance hybrid whose three equivalent C-O bonds each have a fractional bond order of about 4/3 (intermediate between single and double). Higher bond order corresponds to greater orbital overlap and a shorter, stronger bond, so CO's much higher bond order explains its noticeably shorter bond length compared to the more single-bond-like character of the C-O bonds in CO32-.",
    ["Bond order and bond length comparison"])

add(2, "Very Hard", "long", True,
    "A student is comparing the molecules XeF4 and CF4. (a) Draw the Lewis structure for XeF4, including lone pairs on the central atom. (b) Determine the electron-domain geometry, molecular geometry, and hybridization of xenon in XeF4. (c) Determine whether XeF4 is polar or nonpolar, and explain your reasoning fully, including how the arrangement of lone pairs (not just their presence) affects the outcome. (d) A student claims that XeF4 must be polar because xenon has lone pairs, using the same logic that made SF4 polar. Evaluate this claim.",
    [("lewis_structure", "Draws xenon bonded to four fluorines with two lone pairs on xenon (6 electron domains total)", 1),
     ("geometry_hybridization", "Identifies octahedral electron-domain geometry, square planar molecular geometry, and sp3d2 hybridization", 1),
     ("polarity_reasoning", "Correctly identifies XeF4 as nonpolar and explains that the two lone pairs occupy opposite (axial) positions, leaving a symmetric square planar arrangement of bonds whose dipoles cancel", 1),
     ("claim_evaluation", "Correctly refutes the student's claim, explaining that having lone pairs alone doesn't guarantee polarity -- the specific symmetric arrangement of the remaining bonds matters, unlike SF4's asymmetric seesaw shape", 1)],
    "(a) Xenon is bonded to four fluorine atoms with two lone pairs remaining on xenon, for a total of six electron domains. (b) Six electron domains give an octahedral electron-domain geometry; because the two lone pairs occupy opposite positions (to minimize repulsion between them), the molecular geometry is square planar, and xenon is sp3d2 hybridized. (c) XeF4 is nonpolar. The two lone pairs are positioned on opposite sides of xenon (180 degrees apart), leaving the four Xe-F bonds arranged in a perfectly symmetric square planar pattern around the equatorial plane; the four equivalent bond dipoles point outward symmetrically and cancel exactly, giving no net dipole moment. (d) The student's claim is incorrect. Having lone pairs on the central atom does not automatically make a molecule polar -- what matters is whether the overall arrangement of bonds (and any lone pairs) is symmetric enough for the bond dipoles to cancel. In SF4, the single lone pair sits in an equatorial position of a trigonal bipyramid, breaking the symmetry and leaving a net dipole (polar). In XeF4, the two lone pairs occupy opposite axial-type positions, which actually preserves symmetry in the remaining square planar arrangement of bonds, so the dipoles do cancel (nonpolar). The number and geometric arrangement of lone pairs must be considered together, not just their presence.",
    ["Lone pair geometry and molecular polarity"])

# ===== MODULE 3: Intermolecular Forces, States of Matter, and Solutions =====

add(3, "Easy", "short", True,
    "A gas sample occupies 6.00 L at 2.00 atm and constant temperature. Calculate the volume when the pressure changes to 3.00 atm, showing your work.",
    [("calculation", "Correctly applies Boyle's law: P1V1 = P2V2 to find V2 = 4.00 L", 1)],
    "Boyle's law: P1V1 = P2V2. (2.00 atm)(6.00 L) = (3.00 atm)(V2). V2 = 12.0 / 3.00 = 4.00 L.",
    ["Gas laws: Boyle's law"])

add(3, "Easy", "long", True,
    "A 2.00 L rigid container holds an ideal gas at 1.50 atm and 27 degrees C (300 K). (a) Calculate the number of moles of gas present, showing your work. (b) If the temperature is raised to 600 K at constant volume, calculate the new pressure, showing your work. (c) Explain, in terms of kinetic molecular theory, why increasing the temperature at constant volume increases the pressure.",
    [("moles_calc", "Correctly applies PV = nRT to find n = 0.122 mol", 1),
     ("pressure_calc", "Correctly applies the pressure-temperature relationship at constant V, n to find P2 = 3.00 atm", 1),
     ("kmt_explanation", "Explains that higher temperature increases average molecular speed and collision frequency/force with the container walls, increasing pressure", 1)],
    "(a) PV = nRT: n = PV/RT = (1.50 atm)(2.00 L) / (0.0821 L atm/(mol K) x 300 K) = 3.00 / 24.63 = 0.122 mol. (b) At constant V and n, P/T is constant: P1/T1 = P2/T2, so P2 = P1(T2/T1) = 1.50 x (600/300) = 3.00 atm. (c) Raising the temperature increases the average kinetic energy, and therefore the average speed, of the gas molecules. Faster-moving molecules collide with the container walls more frequently and with greater force per collision, so the total force per unit area (pressure) on the walls increases.",
    ["Ideal gas law", "Kinetic molecular theory"])

add(3, "Medium", "short", True,
    "Identify the strongest type of intermolecular force present in liquid NH3, and explain why it is stronger than the intermolecular forces in liquid CH4.",
    [("imf_identification", "Identifies hydrogen bonding as the strongest force in NH3 and explains CH4 has only weak dispersion forces since it lacks a polar N-H, O-H, or F-H bond", 1)],
    "The strongest intermolecular force in liquid NH3 is hydrogen bonding, since NH3 has N-H bonds (nitrogen is highly electronegative and small) that allow strong dipole-based attractions between the partially positive H on one molecule and the lone pair on N of a neighboring molecule. CH4 has no N-H, O-H, or F-H bonds and is nonpolar, so its molecules only experience weak London dispersion forces, which are much weaker than hydrogen bonding.",
    ["Intermolecular forces: hydrogen bonding"])

add(3, "Medium", "long", True,
    "A solution is prepared by dissolving 4.00 mol of NaCl in enough water to make 2.00 L of solution. (a) Calculate the molarity of the solution, showing your work. (b) If the solution is diluted to 8.00 L total volume, calculate the new molarity, showing your work. (c) Explain, using the dilution equation, why the number of moles of solute stays constant during a dilution even though molarity changes.",
    [("molarity_calc", "Correctly calculates M = 2.00 mol/L", 1),
     ("dilution_calc", "Correctly applies M1V1 = M2V2 to find the new molarity of 0.500 M", 1),
     ("conceptual_explanation", "Explains that dilution only adds solvent, not solute, so moles of solute are unchanged even though concentration decreases as volume increases", 1)],
    "(a) M = mol/L = 4.00 mol / 2.00 L = 2.00 M. (b) M1V1 = M2V2: (2.00 M)(2.00 L) = M2(8.00 L), so M2 = 4.00/8.00 = 0.500 M. (c) Dilution only involves adding more solvent (water) to the solution; no solute is added or removed. Since moles of solute (n = M x V) must stay constant, as volume increases, molarity must decrease proportionally to keep the product M x V equal to the original constant number of moles.",
    ["Molarity and dilution"])

add(3, "Medium", "short", True,
    "A solution contains 3.00 mol of a nonvolatile, nonelectrolyte solute dissolved in 2.00 kg of water. Calculate the boiling point elevation of this solution, showing your work. (Kb for water = 0.512 degrees C/m)",
    [("calculation", "Correctly calculates molality (1.50 m) and applies delta-Tb = Kb x m to get 0.768 degrees C", 1)],
    "Molality = 3.00 mol / 2.00 kg = 1.50 m. Delta-Tb = Kb x m = 0.512 degrees C/m x 1.50 m = 0.768 degrees C.",
    ["Boiling point elevation calculation"])

add(3, "Medium", "long", True,
    "A 0.0500 M aqueous solution of a nonelectrolyte is prepared. (a) Calculate the osmotic pressure of this solution at 25 degrees C (298 K), showing your work. (R = 0.0821 L atm/(mol K)). (b) A second solution is prepared at the same molarity, but the solute is CaCl2, a strong electrolyte. Calculate the expected osmotic pressure of this second solution, showing your work and explaining the role of the van't Hoff factor. (c) Explain why measuring osmotic pressure can be a more sensitive method than measuring freezing point depression for determining the molar mass of a solute at very low concentrations.",
    [("osmotic_pressure_1", "Correctly applies pi = MRT to calculate 1.22 atm for the nonelectrolyte", 1),
     ("osmotic_pressure_2", "Correctly applies pi = iMRT with i = 3 for CaCl2 to calculate 3.67 atm", 1),
     ("van_hoff_explanation", "Explains that CaCl2 dissociates into 3 ions per formula unit, tripling the effective particle concentration", 1),
     ("sensitivity_explanation", "Explains that osmotic pressure produces a measurable, larger-magnitude effect at low concentration compared to the very small freezing-point-depression signal, making it easier to measure precisely", 1)],
    "(a) pi = MRT = 0.0500 mol/L x 0.0821 L atm/(mol K) x 298 K = 1.22 atm. (b) CaCl2 dissociates into Ca2+ and 2 Cl-, giving i = 3. pi = iMRT = 3 x 0.0500 x 0.0821 x 298 = 3.67 atm. (c) At very low solute concentrations, osmotic pressure produces a comparatively large, easily measurable pressure difference (on the order of atmospheres), whereas the corresponding freezing point depression would be an extremely small temperature change (a small fraction of a degree) that is much harder to measure precisely with standard thermometry; osmotic pressure's larger measurable signal per unit concentration makes it more sensitive for determining molar mass at low concentration.",
    ["Osmotic pressure calculation", "Van't Hoff factor"])

add(3, "Medium", "short", True,
    "Two liquids, water and diethyl ether, are compared at the same temperature. Diethyl ether has a significantly higher vapor pressure than water. Explain this difference in terms of intermolecular forces, even though both molecules contain an oxygen atom.",
    [("explanation", "Explains water can both donate and accept hydrogen bonds (extensive network) while ether can only accept, giving ether weaker net intermolecular forces and higher vapor pressure", 1)],
    "Water molecules have O-H bonds, allowing each water molecule to act as both a hydrogen bond donor and acceptor, forming an extensive three-dimensional hydrogen-bonding network that holds molecules together strongly. Diethyl ether's oxygen has no O-H bond to donate; it can only accept hydrogen bonds from other molecules that have one, so its net intermolecular attractions are considerably weaker than water's. Weaker intermolecular forces mean ether molecules escape the liquid surface more easily, giving diethyl ether a much higher vapor pressure than water at the same temperature.",
    ["Vapor pressure and intermolecular forces"])

add(3, "Medium", "long", True,
    "A metal crystallizes in a body-centered cubic (BCC) unit cell with an edge length of 3.30 x 10^-8 cm. (a) Determine how many atoms are contained in one BCC unit cell, showing the corner and body-center contributions separately. (b) If the molar mass of the metal is 55.8 g/mol, calculate the density of the metal in g/cm3, showing your work. (Avogadro's number = 6.022 x 10^23/mol) (c) Explain conceptually why a BCC structure has a lower packing efficiency (68%) than a face-centered cubic (FCC) structure (74%).",
    [("atoms_per_cell", "Correctly determines 8 corners x 1/8 + 1 body center = 2 atoms per BCC cell", 1),
     ("density_calc", "Correctly calculates the unit cell volume, mass, and density (approximately 7.86 g/cm3)", 1),
     ("packing_explanation", "Explains that BCC atoms touch only along the body diagonal (fewer nearest-neighbor contacts) leaving more empty space than the more tightly packed FCC arrangement", 1)],
    "(a) A BCC cell has 8 corner atoms, each shared among 8 adjacent cells (contributing 8 x 1/8 = 1 atom), plus 1 atom entirely within the cell at the body center, for a total of 2 atoms per unit cell. (b) Unit cell volume = (3.30e-8 cm)^3 = 3.594e-23 cm3. Mass of unit cell = 2 atoms x (55.8 g/mol / 6.022e23 /mol) = 2 x 9.267e-23 g = 1.853e-22 g. Density = mass/volume = 1.853e-22 / 3.594e-23 = 5.16 g/cm3. (c) In a BCC structure, atoms touch only along the body diagonal of the cube, giving each atom 8 nearest neighbors, while in an FCC structure atoms touch along the face diagonal, giving each atom 12 nearest neighbors. The more numerous, closer-packed contacts in FCC fill space more efficiently (74%) than the looser BCC arrangement (68%), which leaves proportionally more empty space between atoms.",
    ["Unit cells: packing efficiency and density"])

add(3, "Medium", "short", True,
    "A 0.100 m aqueous solution of KBr is compared to a 0.100 m aqueous solution of glucose (a nonelectrolyte). Predict which solution has the lower freezing point, and justify your answer.",
    [("prediction_and_justification", "Correctly predicts KBr has the lower freezing point and justifies using the van't Hoff factor (i=2 for KBr vs i=1 for glucose)", 1)],
    "The KBr solution will have the lower freezing point. KBr is a strong electrolyte that dissociates completely into K+ and Br- ions in solution, giving a van't Hoff factor of i = 2, so its effective particle concentration is 0.200 m. Glucose is a nonelectrolyte with i = 1, so its effective particle concentration remains 0.100 m. Since freezing point depression is proportional to the total effective particle concentration (delta-Tf = i x Kf x m), the KBr solution, with twice the effective particle concentration, has the greater freezing point depression and therefore the lower freezing point.",
    ["Colligative properties: qualitative comparison"])

add(3, "Medium", "long", True,
    "A phase diagram for a pure substance shows a triple point at 0.500 atm and -10 degrees C, a normal boiling point at 1.00 atm and 80 degrees C, and a critical point at 40 atm and 250 degrees C. (a) Using this phase diagram, predict the phase of the substance at 0.100 atm and -20 degrees C, and explain your reasoning. (b) Predict what would be directly observed if a sample of this substance at 0.100 atm and -20 degrees C were slowly heated at constant pressure to 100 degrees C, referencing the location of the triple point. (c) Explain what is meant physically by the critical point, and describe what happens to the substance above the critical temperature and pressure.",
    [("phase_prediction", "Predicts the solid phase at 0.100 atm, -20 C, reasoning that this point lies below and to the left of the triple point on the diagram", 1),
     ("heating_observation", "Predicts the substance would sublime directly from solid to gas without passing through a liquid phase, since 0.100 atm is below the triple point pressure", 1),
     ("critical_point_explanation", "Explains the critical point as where the liquid-gas boundary terminates, above which distinct liquid and gas phases no longer exist", 1)],
    "(a) At 0.100 atm and -20 degrees C, the substance is a solid. This point lies at a lower pressure than the triple point (0.500 atm) and a lower temperature, placing it in the solid region of the phase diagram, to the left of both the solid-liquid and solid-gas boundaries. (b) Because 0.100 atm is below the triple point pressure of 0.500 atm, heating the substance at this constant pressure will never cross into the liquid region of the phase diagram; instead, the substance will sublime directly from solid to gas as temperature increases, with no liquid phase observed. (c) The critical point marks the temperature and pressure beyond which the liquid and gas phases become indistinguishable; the liquid-gas phase boundary line terminates at this point. Above the critical temperature and pressure, the substance exists as a single supercritical fluid phase, with properties intermediate between a typical liquid and gas, and no amount of increased pressure alone can condense it into a distinct liquid.",
    ["Phase diagrams"])

add(3, "Hard", "short", True,
    "A gas sample occupies 4.00 L at 200 K and 1.00 atm. Calculate the volume of the gas at 400 K and 2.50 atm, showing your work.",
    [("calculation", "Correctly applies the combined gas law to find V2 = 3.20 L", 1)],
    "Combined gas law: P1V1/T1 = P2V2/T2. V2 = (P1V1T2)/(T1P2) = (1.00 atm x 4.00 L x 400 K) / (200 K x 2.50 atm) = 1600/500 = 3.20 L.",
    ["Combined gas law"])

add(3, "Hard", "long", True,
    "A solution is made by mixing 4.00 mol of benzene (pure vapor pressure = 95.0 mmHg) with 1.00 mol of toluene (pure vapor pressure = 28.0 mmHg), forming an ideal solution at a given temperature. (a) Calculate the mole fraction of each component in the liquid solution. (b) Calculate the partial vapor pressure of each component above the solution, showing your work. (c) Calculate the total vapor pressure of the solution. (d) Calculate the mole fraction of benzene in the vapor phase above the solution, and explain why it differs from the mole fraction of benzene in the liquid phase.",
    [("mole_fractions", "Correctly calculates X_benzene = 0.800 and X_toluene = 0.200 in the liquid", 1),
     ("partial_pressures", "Correctly applies Raoult's law to find P_benzene = 76.0 mmHg and P_toluene = 5.60 mmHg", 1),
     ("total_pressure", "Correctly sums to find P_total = 81.6 mmHg", 1),
     ("vapor_composition", "Correctly calculates vapor-phase mole fraction of benzene as approximately 0.931 and explains the vapor is enriched in the more volatile component (benzene)", 1)],
    "(a) X_benzene = 4.00/(4.00+1.00) = 0.800; X_toluene = 1.00/5.00 = 0.200. (b) P_benzene = X_benzene x P-pure = 0.800 x 95.0 = 76.0 mmHg. P_toluene = 0.200 x 28.0 = 5.60 mmHg. (c) P_total = 76.0 + 5.60 = 81.6 mmHg. (d) Mole fraction of benzene in vapor = P_benzene/P_total = 76.0/81.6 = 0.931. This is higher than benzene's 0.800 mole fraction in the liquid because benzene is more volatile (higher pure vapor pressure) than toluene, so it evaporates preferentially, enriching the vapor phase in the more volatile component relative to the liquid composition.",
    ["Raoult's law: two volatile components"])

add(3, "Hard", "short", True,
    "A 0.100 m aqueous solution of a weak acid HA has a measured freezing point of -0.198 degrees C. Calculate the van't Hoff factor for this solution, showing your work, and state what this value suggests about the acid's behavior in water. (Kf for water = 1.86 degrees C/m)",
    [("calculation_and_interpretation", "Correctly calculates i = 1.06 and interprets it as indicating the acid is only weakly/partially ionized", 1)],
    "Delta-Tf = i x Kf x m, so i = delta-Tf / (Kf x m) = 0.198 / (1.86 x 0.100) = 1.06. Since i is only slightly greater than 1 (rather than close to 2, which would indicate near-complete dissociation into 2 ions), this suggests HA is a weak acid that ionizes only to a small extent in water, remaining mostly in its molecular (undissociated) form.",
    ["Van't Hoff factor: weak electrolyte"])

add(3, "Hard", "long", True,
    "A metal crystallizes in a face-centered cubic (FCC) unit cell with an edge length of 3.62 x 10^-8 cm. (a) Using the relationship 4r = a-times-the-square-root-of-2 for an FCC cell, calculate the atomic radius of the metal, showing your work. (b) If the molar mass of the metal is 63.5 g/mol, calculate its density, showing your work. (c) A second metal crystallizes in a simple cubic structure with the same atomic radius as the metal in part (a). Predict, with reasoning (not calculation), whether this second metal's density would be higher or lower than the FCC metal's density, assuming the same molar mass.",
    [("radius_calc", "Correctly calculates r = 1.28e-8 cm using the FCC face-diagonal relationship", 1),
     ("density_calc", "Correctly calculates the FCC density as approximately 8.94 g/cm3 using 4 atoms per cell", 1),
     ("simple_cubic_comparison", "Correctly predicts lower density for the simple cubic structure and explains it packs atoms less efficiently (fewer atoms per unit cell volume) than FCC", 1)],
    "(a) r = a x sqrt(2) / 4 = (3.62e-8 cm x 1.414) / 4 = 5.119e-8 / 4 = 1.28e-8 cm. (b) FCC unit cell volume = (3.62e-8)^3 = 4.746e-23 cm3. An FCC cell contains 4 atoms, so mass = 4 x (63.5 / 6.022e23) = 4 x 1.0545e-22 = 4.218e-22 g. Density = 4.218e-22 / 4.746e-23 = 8.89 g/cm3. (c) The second metal's density would be lower. A simple cubic structure contains only 1 atom per unit cell (8 corners x 1/8) and has the lowest packing efficiency (about 52%) of common cubic structures, compared to FCC's 74% packing efficiency; with the same atomic radius and molar mass, the simple cubic arrangement leaves proportionally more empty space, so its mass-per-volume (density) would be lower than the more efficiently packed FCC structure.",
    ["Unit cell geometry: atomic radius, density, and packing comparison"])

add(3, "Very Hard", "short", True,
    "A 15.0 g sample of an unknown nonelectrolyte is dissolved in 250. g of water, and the resulting solution freezes at -1.55 degrees C. Calculate the approximate molar mass of the unknown solute, showing your work. (Kf for water = 1.86 degrees C/m)",
    [("calculation", "Correctly calculates molality (0.833 m), moles of solute (0.2083 mol), and molar mass (approximately 72.0 g/mol)", 1)],
    "Molality = delta-Tf / Kf = 1.55 / 1.86 = 0.833 m. Moles of solute = 0.833 m x 0.250 kg = 0.2083 mol. Molar mass = 15.0 g / 0.2083 mol = 72.0 g/mol.",
    ["Freezing point depression: solving for molar mass"])

add(3, "Very Hard", "long", True,
    "A rigid 3.00 L container at 27 degrees C (300 K) initially contains N2 gas at a partial pressure of 1.50 atm. Additional He gas is pumped into the container until the total pressure reaches 4.00 atm at the same temperature. (a) Calculate the number of moles of He added, showing your work. (R = 0.0821 L atm/(mol K)) (b) After the He is added, the container is heated to 600 K at constant volume. Calculate the new total pressure, showing your work. (c) Predict, with reasoning (not calculation), how the average speed of the He molecules compares to the average speed of the N2 molecules at 600 K, and explain why, despite this speed difference, both gases contribute to pressure according to Dalton's law independent of their identity.",
    [("moles_he", "Correctly calculates the He partial pressure (2.50 atm) and uses PV=nRT to find approximately 0.305 mol He added", 1),
     ("new_pressure", "Correctly applies the pressure-temperature relationship at constant V, n to find the new total pressure of 8.00 atm", 1),
     ("speed_comparison", "Correctly predicts He molecules move faster on average due to their much lower molar mass, at the same temperature", 1),
     ("dalton_reasoning", "Explains that each gas's partial pressure depends only on its own moles, volume, and temperature (via the ideal gas law), independent of the identity or speed of other gases present, which is why partial pressures simply sum", 1)],
    "(a) The partial pressure of He added = 4.00 - 1.50 = 2.50 atm. n(He) = PV/RT = (2.50 atm)(3.00 L) / (0.0821 x 300) = 7.50/24.63 = 0.305 mol. (b) At constant volume and constant total moles, P/T is constant: P2 = P1 x (T2/T1) = 4.00 x (600/300) = 8.00 atm. (c) At the same temperature, average kinetic energy is equal for both gases, but since KE = 1/2 m v^2, the much lighter He atoms (M = 4 g/mol) must move at a considerably higher average speed than the heavier N2 molecules (M = 28 g/mol) to have the same average kinetic energy. Despite this speed difference, Dalton's law holds because each gas's partial pressure is determined independently by its own moles, the container volume, and the temperature (via PV = nRT for that gas alone) -- gas molecules behave as if the other gas were not present (ignoring intermolecular interactions in the ideal gas approximation), so the identity and speed of one gas do not alter how the other gas's partial pressure is calculated; the total pressure is simply the sum of these independent contributions.",
    ["Gas stoichiometry with partial pressure and kinetic molecular theory"])

add(3, "Hard", "short", True,
    "A real gas is compared to an ideal gas at high pressure and low temperature. Explain, using the assumptions of kinetic molecular theory, why the real gas's measured pressure is typically lower than what the ideal gas law would predict under these conditions.",
    [("explanation", "Explains that at high pressure/low temperature, intermolecular attractions become significant, pulling molecules together and reducing the force of their collisions with the container walls below the ideal (no-attraction) prediction", 1)],
    "The ideal gas law assumes no intermolecular attractions between gas particles. At high pressure, molecules are forced close together, and at low temperature they have less kinetic energy to overcome any attractive forces between them; these attractions pull neighboring molecules slightly together just before they strike the container wall, softening the force of each collision. Because measured pressure depends on the actual force of wall collisions, this attraction-reduced collision force makes the real gas's measured pressure lower than the ideal gas law (which assumes no such attraction) would predict.",
    ["Real gas deviations from ideality"])

add(3, "Hard", "short", True,
    "It takes 40.0 seconds for a fixed amount of an unknown gas to effuse through a small opening under given conditions. Under the same conditions, the same number of moles of O2 gas (M = 32.0 g/mol) takes 20.0 seconds to effuse. Calculate the molar mass of the unknown gas, showing your work.",
    [("calculation", "Correctly applies Graham's law (time ratio equals the square root of the molar mass ratio) to find M(unknown) = 128 g/mol", 1)],
    "By Graham's law, the ratio of effusion times equals the square root of the ratio of molar masses: t(unknown)/t(O2) = sqrt(M(unknown)/M(O2)). 40.0/20.0 = sqrt(M(unknown)/32.0). 2.00 = sqrt(M(unknown)/32.0). Squaring both sides: 4.00 = M(unknown)/32.0, so M(unknown) = 4.00 x 32.0 = 128 g/mol.",
    ["Graham's law: solving for unknown molar mass"])

add(3, "Hard", "long", True,
    "A 0.150 m aqueous solution of a weak electrolyte HX has a measured boiling point elevation of 0.104 degrees C. (Kb for water = 0.512 degrees C/m) (a) Calculate the van't Hoff factor for this solution, showing your work. (b) Estimate the approximate percent ionization of HX in this solution, using the fact that i = 1 would correspond to no dissociation and i = 2 would correspond to complete dissociation into two ions. (c) Explain why boiling point elevation, like other colligative properties, depends on the total concentration of dissolved particles rather than the chemical identity of the solute.",
    [("van_hoff_calc", "Correctly calculates i = 0.104/(0.512 x 0.150) = 1.35", 1),
     ("percent_ionization", "Correctly estimates percent ionization as (i-1)/(2-1) x 100 = 35%", 1),
     ("colligative_explanation", "Explains that colligative properties depend on the number of dissolved particles, not their chemical identity, because they arise from dilution of the solvent's own vapor pressure/chemical potential", 1)],
    "(a) i = delta-Tb / (Kb x m) = 0.104 / (0.512 x 0.150) = 0.104 / 0.0768 = 1.35. (b) Since i = 1 corresponds to no dissociation and i = 2 corresponds to complete dissociation into two ions, the calculated i = 1.35 sits about 35% of the way between these two extremes: percent ionization is approximately (i-1)/(2-1) x 100 = (1.35-1)/1 x 100 = 35%, meaning about 35% of the HX molecules have dissociated into ions in this solution. (c) Colligative properties depend only on the total number (concentration) of dissolved particles because they arise from how much the solute dilutes the solvent's own vapor pressure or chemical potential at the liquid surface; a solute particle blocks a solvent molecule from occupying that surface position regardless of whether the particle is a molecule or an ion, so only the total particle count, not the specific chemical identity, determines the magnitude of the effect.",
    ["Van't Hoff factor: weak electrolyte percent ionization"])

add(3, "Hard", "long", True,
    "Two sealed, rigid 1.00 L containers at the same temperature (300 K) each hold 0.500 mol of gas: Container A holds Ne (M = 20.0 g/mol) and Container B holds Kr (M = 83.8 g/mol). (a) Calculate the pressure in each container, showing your work, and explain why the two pressures are equal despite the different gas identities. (b) Compare the average kinetic energy of the gas particles in the two containers, with reasoning. (c) Compare the average speed (rms speed) of the gas particles in the two containers, with reasoning, and explain how this is consistent with your answer to part (b) despite the different masses involved.",
    [("pressure_calc", "Correctly calculates equal pressures (12.3 atm each) using PV=nRT, and explains pressure depends on moles/volume/temperature, not molar mass, under ideal gas assumptions", 1),
     ("kinetic_energy_comparison", "Correctly states average kinetic energy is equal in both containers since it depends only on temperature", 1),
     ("speed_comparison", "Correctly states Ne particles have a higher average speed than Kr particles, and reconciles this with equal kinetic energy via KE = 1/2 m v^2 (lighter mass requires higher speed for equal KE)", 1)],
    "(a) P = nRT/V = (0.500 mol)(0.0821 L atm/(mol K))(300 K) / 1.00 L = 12.3 atm for both containers. The pressures are equal because the ideal gas law depends only on moles, volume, and temperature -- all identical between the two containers -- and does not depend on the identity or molar mass of the gas. (b) Average kinetic energy is equal in both containers, because average kinetic energy of an ideal gas depends only on absolute temperature, which is the same (300 K) in both containers, regardless of the different gas identities or molar masses. (c) The Ne particles have a higher average (rms) speed than the Kr particles. Since kinetic energy is KE = 1/2 m v^2, and both gases must have the same average KE at the same temperature, the much lighter Ne particles must move at a higher average speed than the much heavier Kr particles to achieve that same kinetic energy; this is fully consistent with part (b), since equal kinetic energy with unequal mass necessarily requires unequal speed.",
    ["Kinetic molecular theory: pressure, kinetic energy, and speed comparison"])

# ===== MODULE 4: Chemical Reactions and Stoichiometry =====

add(4, "Easy", "short", True,
    "Balance the following equation using the smallest whole-number coefficients, and show how you verified that atoms balance on both sides: __C3H8 + __O2 -> __CO2 + __H2O",
    [("balanced_equation", "Correctly balances as C3H8 + 5O2 -> 3CO2 + 4H2O and verifies atom counts", 1)],
    "C3H8 + 5 O2 -> 3 CO2 + 4 H2O. Verification: Carbon: 3 on left (in C3H8), 3 on right (in 3 CO2). Hydrogen: 8 on left (in C3H8), 8 on right (in 4 H2O, since 4x2=8). Oxygen: 5x2=10 on left, and on the right 3 CO2 contributes 3x2=6 plus 4 H2O contributes 4x1=4, for 6+4=10. All three elements balance.",
    ["Balancing equations"])

add(4, "Easy", "long", True,
    "For the reaction 2 Al + 3 Cl2 -> 2 AlCl3, 4.00 mol of Al reacts with 4.00 mol of Cl2. (a) Determine which reactant is limiting, showing your work. (b) Calculate the maximum moles of AlCl3 that can be produced, showing your work. (c) Calculate the moles of the excess reactant that remain unreacted, showing your work.",
    [("limiting_reagent", "Correctly determines Cl2 is limiting by comparing mole ratios (4.00 mol Al would need 6.00 mol Cl2, but only 4.00 mol Cl2 is available)", 1),
     ("product_moles", "Correctly calculates 2.67 mol AlCl3 produced based on the limiting Cl2", 1),
     ("excess_remaining", "Correctly calculates 1.33 mol Al remains unreacted", 1)],
    "(a) The required ratio is 2 mol Al : 3 mol Cl2. To react with 4.00 mol Al would require 4.00 x (3/2) = 6.00 mol Cl2, but only 4.00 mol Cl2 is available, so Cl2 is the limiting reactant. (b) Using the limiting Cl2: moles AlCl3 = 4.00 mol Cl2 x (2 mol AlCl3 / 3 mol Cl2) = 2.67 mol AlCl3. (c) Moles of Al consumed = 4.00 mol Cl2 x (2 mol Al / 3 mol Cl2) = 2.67 mol Al consumed; moles of Al remaining = 4.00 - 2.67 = 1.33 mol Al unreacted.",
    ["Limiting reagent"])

add(4, "Medium", "short", True,
    "A reaction has a theoretical yield of 18.5 g of product. If the percent yield is 82.0%, calculate the actual yield obtained, showing your work.",
    [("calculation", "Correctly calculates actual yield = 0.820 x 18.5 g = 15.2 g", 1)],
    "Percent yield = (actual yield / theoretical yield) x 100, so actual yield = (percent yield / 100) x theoretical yield = 0.820 x 18.5 g = 15.2 g.",
    ["Percent yield"])

add(4, "Medium", "long", True,
    "Aqueous solutions of Pb(NO3)2 and KI are mixed, forming a yellow precipitate. (a) Write the balanced molecular equation for this reaction. (b) Write the complete ionic equation, showing all soluble species as ions. (c) Write the net ionic equation, identifying and removing the spectator ions.",
    [("molecular_equation", "Correctly writes Pb(NO3)2(aq) + 2 KI(aq) -> PbI2(s) + 2 KNO3(aq)", 1),
     ("complete_ionic", "Correctly shows Pb2+, NO3-, K+, and I- as dissociated ions, with PbI2 remaining as a solid", 1),
     ("net_ionic", "Correctly identifies K+ and NO3- as spectators and writes Pb2+(aq) + 2 I-(aq) -> PbI2(s)", 1)],
    "(a) Pb(NO3)2(aq) + 2 KI(aq) -> PbI2(s) + 2 KNO3(aq). (b) Pb2+(aq) + 2 NO3-(aq) + 2 K+(aq) + 2 I-(aq) -> PbI2(s) + 2 K+(aq) + 2 NO3-(aq). (c) K+ and NO3- appear unchanged on both sides and are spectator ions; removing them gives the net ionic equation: Pb2+(aq) + 2 I-(aq) -> PbI2(s).",
    ["Net ionic equations"])

add(4, "Hard", "short", True,
    "A 30.00 mL sample of H2SO4 solution is titrated to the equivalence point with 42.60 mL of 0.150 M NaOH. Given the reaction H2SO4 + 2 NaOH -> Na2SO4 + 2 H2O, calculate the molarity of the H2SO4 solution, showing your work.",
    [("calculation", "Correctly applies the 1:2 mole ratio to find M(H2SO4) = 0.1065 M", 1)],
    "Moles NaOH = 0.04260 L x 0.150 M = 0.00639 mol. By the 1:2 ratio (1 mol H2SO4 per 2 mol NaOH), moles H2SO4 = 0.00639 / 2 = 0.003195 mol. Molarity H2SO4 = 0.003195 mol / 0.03000 L = 0.1065 M.",
    ["Titration stoichiometry"])

add(4, "Hard", "long", True,
    "A 12.0 g sample of impure calcium carbonate (CaCO3) reacts completely with excess HCl according to: CaCO3 + 2 HCl -> CaCl2 + H2O + CO2. The reaction produces 3.85 g of CO2 (molar mass 44.0 g/mol). (a) Calculate the moles of CO2 produced, showing your work. (b) Calculate the mass of pure CaCO3 (molar mass 100.1 g/mol) that reacted, showing your work. (c) Calculate the percent purity of the original 12.0 g sample (i.e., the percent by mass that was actually CaCO3), showing your work.",
    [("moles_co2", "Correctly calculates 0.0875 mol CO2", 1),
     ("mass_caco3", "Correctly uses the 1:1 mole ratio to calculate 8.75 g of pure CaCO3", 1),
     ("percent_purity", "Correctly calculates percent purity = (8.75/12.0) x 100 = 72.9%", 1)],
    "(a) Moles CO2 = 3.85 g / 44.0 g/mol = 0.0875 mol. (b) By the 1:1 mole ratio of CaCO3 to CO2, moles CaCO3 = 0.0875 mol; mass CaCO3 = 0.0875 mol x 100.1 g/mol = 8.76 g. (c) Percent purity = (mass of pure CaCO3 / mass of impure sample) x 100 = (8.76 g / 12.0 g) x 100 = 73.0%.",
    ["Multi-step stoichiometry: percent purity"])

add(4, "Very Hard", "short", True,
    "A hydrocarbon sample of unknown formula CxHy undergoes complete combustion. A 5.00 g sample produces 15.4 g of CO2 (molar mass 44.0 g/mol) and 6.30 g of H2O (molar mass 18.0 g/mol). Determine the empirical formula of the hydrocarbon, showing your work.",
    [("empirical_formula", "Correctly calculates moles of C (0.350) and H (0.700) and reduces to the empirical formula CH2", 1)],
    "Moles C = moles CO2 = 15.4/44.0 = 0.350 mol C. Moles H = 2 x moles H2O = 2 x (6.30/18.0) = 2 x 0.350 = 0.700 mol H. Ratio C:H = 0.350:0.700 = 1:2. Empirical formula: CH2.",
    ["Empirical formula from combustion data"])

add(4, "Very Hard", "long", True,
    "A hydrocarbon undergoes complete combustion: CxHy + O2 -> CO2 + H2O. In one trial, 8.00 g of the hydrocarbon reacts with 32.0 g of O2 (molar mass 32.0 g/mol), and O2 is confirmed to be the limiting reactant. The theoretical yield of CO2 (molar mass 44.0 g/mol) under these conditions is 21.6 g, but only 17.8 g is actually recovered from the experiment. (a) Calculate the percent yield of CO2 for this reaction, showing your work. (b) Explain two plausible experimental reasons why the actual yield might be lower than the theoretical yield. (c) If the same experiment were repeated with a more precise, sealed collection apparatus that eliminated all gas leaks, predict how this would affect the observed percent yield, and justify your prediction.",
    [("percent_yield_calc", "Correctly calculates percent yield = (17.8/21.6) x 100 = 82.4%", 1),
     ("experimental_reasons", "Gives two plausible reasons for yield loss, such as incomplete reaction, loss of gaseous product during collection, or side reactions", 1),
     ("apparatus_prediction", "Correctly predicts the percent yield would increase (move closer to 100%) and justifies it by noting that eliminating leaks prevents loss of the gaseous CO2 product before it can be measured", 1)],
    "(a) Percent yield = (actual/theoretical) x 100 = (17.8/21.6) x 100 = 82.4%. (b) Two plausible reasons: (1) some of the gaseous CO2 product may have escaped or leaked from the collection apparatus before being measured, since it is a gas and difficult to fully contain; (2) the combustion reaction may not have gone to 100% completion, leaving some unreacted hydrocarbon or forming some CO (incomplete combustion) instead of CO2, reducing the actual CO2 yield. (c) With a more precise, fully sealed collection apparatus, the observed percent yield would be expected to increase, moving closer to 100%. This is because one of the main sources of yield loss for a gaseous product like CO2 is physical loss during collection (leaks or incomplete capture); eliminating that loss pathway means a larger fraction of the CO2 that is actually produced by the reaction would be successfully measured, raising the calculated percent yield even if the underlying chemistry (completeness of the reaction itself) is unchanged.",
    ["Combined limiting reagent and percent yield analysis"])

# ===== MODULE 5: Chemical Kinetics =====

add(5, "Easy", "short", True,
    "For the rate law Rate = k[A][B]^2, determine the overall order of the reaction and the order with respect to each reactant.",
    [("order_identification", "Correctly identifies first order in A, second order in B, and third order overall", 1)],
    "The reaction is first order with respect to A (exponent of 1), second order with respect to B (exponent of 2), and third order overall (1 + 2 = 3).",
    ["Reaction order"])

add(5, "Easy", "long", True,
    "A reaction has the experimental rate law Rate = k[NO]^2[O2]. (a) If the concentration of NO is doubled while [O2] is held constant, predict the factor by which the rate changes, showing your reasoning. (b) If the concentration of O2 is tripled while [NO] is held constant, predict the factor by which the rate changes, showing your reasoning. (c) If both [NO] and [O2] are doubled simultaneously, predict the factor by which the rate changes, showing your reasoning.",
    [("no_doubling", "Correctly predicts the rate increases by a factor of 4 (2^2) when [NO] doubles", 1),
     ("o2_tripling", "Correctly predicts the rate increases by a factor of 3 (3^1) when [O2] triples", 1),
     ("both_doubling", "Correctly predicts the rate increases by a factor of 8 (2^2 x 2^1) when both double", 1)],
    "(a) Since the rate law has [NO]^2, doubling [NO] increases the rate by a factor of 2^2 = 4, holding [O2] constant. (b) Since the rate law has [O2]^1, tripling [O2] increases the rate by a factor of 3^1 = 3, holding [NO] constant. (c) Doubling both simultaneously combines both effects multiplicatively: the rate increases by a factor of (2^2) x (2^1) = 4 x 2 = 8.",
    ["Rate law: predicting rate changes"])

add(5, "Medium", "short", True,
    "A reaction is found to be first order overall, with a rate constant k = 0.0347 min^-1. Calculate the half-life of this reaction, showing your work.",
    [("calculation", "Correctly applies half-life = 0.693/k to find t1/2 = 20.0 min", 1)],
    "For a first-order reaction, half-life = 0.693 / k = 0.693 / 0.0347 min^-1 = 20.0 min.",
    ["First-order half-life"])

add(5, "Medium", "long", True,
    "The following initial rate data were collected for the reaction 2 NO + Br2 -> 2 NOBr: Trial 1: [NO] = 0.10 M, [Br2] = 0.10 M, rate = 12 M/s. Trial 2: [NO] = 0.20 M, [Br2] = 0.10 M, rate = 48 M/s. Trial 3: [NO] = 0.10 M, [Br2] = 0.20 M, rate = 24 M/s. (a) Determine the order of the reaction with respect to NO, showing your reasoning. (b) Determine the order of the reaction with respect to Br2, showing your reasoning. (c) Write the complete rate law for this reaction, and calculate the value of the rate constant k with correct units.",
    [("no_order", "Correctly determines second order in NO by comparing trials 1 and 2 (rate quadruples when [NO] doubles)", 1),
     ("br2_order", "Correctly determines first order in Br2 by comparing trials 1 and 3 (rate doubles when [Br2] doubles)", 1),
     ("rate_law_and_k", "Writes Rate = k[NO]^2[Br2] and correctly calculates k = 1.2 x 10^4 M^-2 s^-1", 1)],
    "(a) Comparing Trial 1 to Trial 2: [NO] doubles (0.10 to 0.20 M) while [Br2] stays constant, and rate increases from 12 to 48 M/s, a factor of 4. Since 2^2 = 4, the reaction is second order in NO. (b) Comparing Trial 1 to Trial 3: [Br2] doubles (0.10 to 0.20 M) while [NO] stays constant, and rate increases from 12 to 24 M/s, a factor of 2. Since 2^1 = 2, the reaction is first order in Br2. (c) Rate = k[NO]^2[Br2]. Using Trial 1: 12 = k(0.10)^2(0.10) = k(0.0010), so k = 12/0.0010 = 1.2 x 10^4 M^-2 s^-1.",
    ["Determining rate law from initial rates data"])

add(5, "Hard", "short", True,
    "A reaction has an activation energy of 75.0 kJ/mol. If the temperature is increased from 300 K to 320 K, explain (without calculating the exact new rate) why even a relatively small temperature increase like this can lead to a large increase in reaction rate, referencing the Boltzmann distribution.",
    [("boltzmann_explanation", "Explains that the fraction of molecules with kinetic energy exceeding the activation energy increases exponentially (not linearly) with temperature, per the Boltzmann distribution", 1)],
    "According to the Boltzmann distribution, only molecules with kinetic energy equal to or greater than the activation energy can react upon collision, and the fraction of molecules meeting this threshold depends exponentially on temperature (as reflected in the exponential term of the Arrhenius equation). Even a modest increase in temperature, like 300 K to 320 K, shifts the entire distribution of molecular energies such that a disproportionately larger fraction of molecules now exceeds the activation energy threshold, so the reaction rate can increase substantially even though the temperature increase itself seems small.",
    ["Boltzmann distribution and temperature effects on rate"])

add(5, "Hard", "long", True,
    "A proposed two-step mechanism for the overall reaction 2 NO2 + F2 -> 2 NO2F is: Step 1 (slow): NO2 + F2 -> NO2F + F. Step 2 (fast): NO2 + F -> NO2F. (a) Verify that the two elementary steps sum to the given overall reaction. (b) Identify any reaction intermediate in this mechanism, and explain how you identified it. (c) Write the rate law predicted by this mechanism, based on the rate-determining step, and explain why the rate law depends only on the slow step's reactants.",
    [("step_verification", "Correctly adds the two steps, canceling the intermediate F, to reproduce the overall reaction", 1),
     ("intermediate_identification", "Identifies F as the intermediate because it is produced in step 1 and consumed in step 2, not appearing in the overall reaction", 1),
     ("rate_law_reasoning", "Writes Rate = k[NO2][F2] and explains that the slow step acts as a bottleneck, so the overall rate cannot exceed the rate of that step", 1)],
    "(a) Adding the two steps: (NO2 + F2 -> NO2F + F) + (NO2 + F -> NO2F) gives 2 NO2 + F2 + F -> 2 NO2F + F; canceling F from both sides gives 2 NO2 + F2 -> 2 NO2F, matching the overall reaction. (b) F is the reaction intermediate: it is produced in step 1 but does not appear in the overall balanced equation, and it is fully consumed in step 2, confirming it is formed and consumed within the mechanism rather than being a starting reactant or final product. (c) Rate = k[NO2][F2]. The rate law is determined by the slow (rate-determining) step alone, because that step acts as a bottleneck -- the overall reaction cannot proceed any faster than its slowest step, so the concentrations that appear in the rate-determining step's own rate expression (NO2 and F2 from step 1) are the only ones that directly control the overall observed rate; the fast second step keeps up with whatever intermediate is supplied by the slow step and does not independently limit the rate.",
    ["Reaction mechanisms and rate-determining step"])

add(5, "Very Hard", "short", True,
    "A second-order reaction has an initial concentration [A]0 = 0.500 M and a rate constant k = 0.0250 M^-1 s^-1. Calculate the concentration of A remaining after 120 seconds, showing your work.",
    [("calculation", "Correctly applies the second-order integrated rate law 1/[A] = kt + 1/[A]0 to find [A] = 0.250 M", 1)],
    "For a second-order reaction: 1/[A] = kt + 1/[A]0 = (0.0250)(120) + 1/0.500 = 3.00 + 2.00 = 5.00. So [A] = 1/5.00 = 0.200 M.",
    ["Second-order integrated rate law"])

add(5, "Very Hard", "long", True,
    "A reaction is studied at two temperatures: at 300 K, k1 = 2.00 x 10^-3 s^-1, and at 350 K, k2 = 3.50 x 10^-2 s^-1. (a) Using the two-point form of the Arrhenius equation, ln(k2/k1) = -(Ea/R)(1/T2 - 1/T1), calculate the activation energy Ea for this reaction, showing your work. (R = 8.314 J/(mol K)) (b) Using your calculated Ea, predict the rate constant k3 at 400 K, showing your work. (c) Explain conceptually why extrapolating a measured Arrhenius relationship to predict rate constants at much higher or lower temperatures than were actually measured can be scientifically risky.",
    [("ea_calculation", "Correctly calculates Ea using the two-point Arrhenius equation to find approximately 62 kJ/mol", 1),
     ("k3_prediction", "Correctly uses the calculated Ea to predict k3 at 400 K using the Arrhenius relationship", 1),
     ("extrapolation_caution", "Explains that extrapolation assumes the same mechanism and activation energy hold outside the measured range, which may not be valid (e.g., mechanism change, phase change)", 1)],
    "(a) ln(k2/k1) = -(Ea/R)(1/T2 - 1/T1). ln(0.0350/0.00200) = ln(17.5) = 2.862. 1/350 - 1/300 = 0.002857 - 0.003333 = -0.000476. So 2.862 = -(Ea/8.314)(-0.000476) = Ea(0.0000573)/8.314... solving: Ea = 2.862 x 8.314 / 0.000476 = 23.79/0.000476 = 49,980 J/mol, approximately 50.0 kJ/mol. (b) Using the Arrhenius relationship between 350 K and 400 K with the calculated Ea: ln(k3/k2) = -(Ea/R)(1/400 - 1/350) = -(50000/8.314)(0.00250 - 0.002857) = -(6014)(-0.000357) = 2.147. k3 = k2 x e^2.147 = 0.0350 x 8.56 = 0.300 s^-1 (approximately). (c) The Arrhenius equation's derivation assumes a constant activation energy and an unchanged reaction mechanism across the temperature range considered. Extrapolating far beyond the actually measured temperature range risks inaccuracy because the reaction mechanism itself, or even the physical state of reactants (e.g., a phase change), could change at temperatures outside the tested range, invalidating the assumption of a single constant Ea; the calculated Ea is only guaranteed to be reliable within (or close to) the range where it was actually measured.",
    ["Arrhenius equation: two-point calculation and extrapolation"])

# ===== MODULE 6: Thermodynamics =====

add(6, "Easy", "short", True,
    "Calculate the heat (q) required to raise the temperature of 75.0 g of water from 22.0 degrees C to 55.0 degrees C, showing your work. (specific heat of water = 4.18 J/(g degrees C))",
    [("calculation", "Correctly applies q = mc(delta-T) to find q = 10,300 J (10.3 kJ)", 1)],
    "q = mc(delta-T) = 75.0 g x 4.18 J/(g degrees C) x (55.0 - 22.0) degrees C = 75.0 x 4.18 x 33.0 = 10,346 J, approximately 10.3 kJ.",
    ["Specific heat calculation"])

add(6, "Easy", "long", True,
    "A reaction releases 45.0 kJ of heat and has delta-S = +30.0 J/K at 298 K. (a) State whether this reaction is exothermic or endothermic, and explain how you know. (b) Calculate delta-G for this reaction at 298 K, showing your work, being careful with units. (c) Based on your answer to part (b), state whether the reaction is spontaneous at 298 K, and explain what the sign of delta-G indicates about spontaneity in general.",
    [("exo_endo", "Correctly identifies the reaction as exothermic because it releases heat, so delta-H = -45.0 kJ", 1),
     ("delta_g_calc", "Correctly calculates delta-G = delta-H - T(delta-S) = -45.0 kJ - (298)(0.0300 kJ/K) = -53.9 kJ, converting units consistently", 1),
     ("spontaneity", "Correctly identifies the reaction as spontaneous since delta-G is negative, and explains negative delta-G indicates a spontaneous process under the given conditions", 1)],
    "(a) The reaction is exothermic, because it releases heat to the surroundings; this corresponds to delta-H = -45.0 kJ. (b) delta-G = delta-H - T(delta-S). Converting delta-S to kJ/K: 30.0 J/K = 0.0300 kJ/K. delta-G = -45.0 kJ - (298 K)(0.0300 kJ/K) = -45.0 - 8.94 = -53.9 kJ. (c) Since delta-G is negative (-53.9 kJ), the reaction is spontaneous at 298 K. In general, a negative delta-G indicates a process is thermodynamically spontaneous (favorable) under the given conditions, while a positive delta-G indicates the process is non-spontaneous as written and would require energy input to proceed.",
    ["Gibbs free energy calculation", "Spontaneity"])

add(6, "Medium", "short", True,
    "Given the following reactions: (1) 2 C(s) + O2(g) -> 2 CO(g), delta-H1 = -221.0 kJ; (2) 2 CO(g) + O2(g) -> 2 CO2(g), delta-H2 = -566.0 kJ. Using Hess's law, calculate delta-H for the reaction: C(s) + O2(g) -> CO2(g), showing your work.",
    [("calculation", "Correctly combines half of reaction 1 and half of reaction 2 to find delta-H = -393.5 kJ", 1)],
    "The target reaction (C + O2 -> CO2) is exactly half of reaction (1) plus half of reaction (2): (1/2)(2C + O2 -> 2CO) + (1/2)(2CO + O2 -> 2CO2) gives C + 1/2 O2 -> CO, then CO + 1/2 O2 -> CO2, summing to C + O2 -> CO2. delta-H = (1/2)(-221.0) + (1/2)(-566.0) = -110.5 + (-283.0) = -393.5 kJ.",
    ["Hess's law"])

add(6, "Medium", "long", True,
    "In a coffee-cup calorimeter, 50.0 g of water at 24.0 degrees C is mixed with a dissolving 5.00 g sample of an ionic solid. The final temperature of the solution is 31.5 degrees C. (specific heat of the solution = 4.18 J/(g degrees C); assume the total solution mass is 55.0 g) (a) Calculate the heat absorbed by the solution, showing your work. (b) Calculate the molar enthalpy of dissolution (in kJ/mol) if the solid has a molar mass of 58.5 g/mol, showing your work and the correct sign for the process. (c) Based on the sign of your answer to part (b), state whether the dissolution process is exothermic or endothermic, and explain how this is consistent with the temperature change observed.",
    [("heat_calc", "Correctly calculates q(solution) = 55.0 x 4.18 x 7.5 = 1724 J", 1),
     ("molar_enthalpy_calc", "Correctly calculates moles of solid (0.0855 mol) and molar enthalpy of dissolution (approximately -20.1 kJ/mol, negative since the process released the heat the solution absorbed)", 1),
     ("exo_endo_consistency", "Correctly explains the process is exothermic since the solution's temperature rose, meaning the dissolving solid released heat into the solution", 1)],
    "(a) q(solution) = mc(delta-T) = 55.0 g x 4.18 J/(g degrees C) x (31.5 - 24.0) degrees C = 55.0 x 4.18 x 7.5 = 1724 J = 1.72 kJ. (b) Moles of solid = 5.00 g / 58.5 g/mol = 0.0855 mol. The heat absorbed by the solution (+1.72 kJ) was released by the dissolving process, so the dissolution itself has delta-H = -1.72 kJ / 0.0855 mol = -20.1 kJ/mol (negative, since the process released the heat the solution absorbed). (c) The dissolution process is exothermic (delta-H is negative). This is consistent with the observed temperature rise: since the dissolving solid released heat into the surrounding water, the water's temperature increased, which is exactly what an exothermic process happening within a calorimeter would produce.",
    ["Calorimetry: molar enthalpy of dissolution"])

add(6, "Hard", "short", True,
    "A reaction has delta-H = +55.0 kJ and delta-S = +125 J/K. Calculate the temperature above which this reaction becomes spontaneous, showing your work.",
    [("calculation", "Correctly calculates T = delta-H/delta-S = 440 K, converting units consistently", 1)],
    "At the crossover temperature, delta-G = 0, so T = delta-H / delta-S. Converting delta-H to J: 55,000 J / 125 J/K = 440 K. Above 440 K, T(delta-S) exceeds delta-H, making delta-G negative and the reaction spontaneous.",
    ["Spontaneity crossover temperature"])

add(6, "Hard", "long", True,
    "Using average bond enthalpies (C-H = 413 kJ/mol, O=O = 495 kJ/mol, C=O = 799 kJ/mol, O-H = 467 kJ/mol, C-C = 347 kJ/mol), estimate delta-H for the complete combustion of ethane: 2 C2H6(g) + 7 O2(g) -> 4 CO2(g) + 6 H2O(g). (Each C2H6 has 6 C-H bonds and 1 C-C bond; each CO2 has 2 C=O bonds; each H2O has 2 O-H bonds.) (a) Calculate the total bond energy of all bonds broken in the reactants, showing your work. (b) Calculate the total bond energy of all bonds formed in the products, showing your work. (c) Calculate delta-H for the reaction, and state whether the reaction is exothermic or endothermic based on the sign.",
    [("bonds_broken", "Correctly calculates total energy to break all reactant bonds (2x[6 C-H + 1 C-C] + 7 O=O) = 2(6x413+347)+7(495) = 5650+3465=9115 kJ", 1),
     ("bonds_formed", "Correctly calculates total energy released forming all product bonds (4x[2 C=O] + 6x[2 O-H]) = 4(1598)+6(934)=6392+5604=11,996 kJ", 1),
     ("delta_h_and_sign", "Correctly calculates delta-H = bonds broken - bonds formed = 9115-11996 = -2881 kJ and identifies the reaction as exothermic", 1)],
    "(a) Bonds broken: 2 C2H6 contain 2 x (6 C-H + 1 C-C) = 12 C-H + 2 C-C bonds; energy = 12(413) + 2(347) = 4956 + 694 = 5650 kJ. Plus 7 O2 (7 O=O bonds): 7(495) = 3465 kJ. Total bonds broken = 5650 + 3465 = 9115 kJ. (b) Bonds formed: 4 CO2 contain 4 x 2 C=O = 8 C=O bonds; energy = 8(799) = 6392 kJ. Plus 6 H2O contain 6 x 2 O-H = 12 O-H bonds; energy = 12(467) = 5604 kJ. Total bonds formed = 6392 + 5604 = 11,996 kJ. (c) delta-H = (bonds broken) - (bonds formed) = 9115 - 11,996 = -2881 kJ. Since delta-H is negative, the reaction is exothermic, consistent with combustion reactions generally releasing large amounts of energy.",
    ["Bond enthalpy calculation: multi-bond reaction"])

add(6, "Very Hard", "short", True,
    "A reaction has delta-H-standard = -85.0 kJ/mol and delta-S-standard = -170 J/(mol K). Calculate delta-G-standard at 298 K, and explain, using the temperature dependence of delta-G, whether increasing the temperature would make this reaction more or less spontaneous.",
    [("calculation_and_reasoning", "Correctly calculates delta-G = -85.0 - (298)(-0.170) = -34.3 kJ/mol and explains that since delta-S is negative, increasing T makes delta-G less negative (less spontaneous)", 1)],
    "delta-G = delta-H - T(delta-S) = -85.0 kJ - (298 K)(-0.170 kJ/(mol K)) = -85.0 - (-50.7) = -85.0 + 50.7 = -34.3 kJ/mol. Since delta-S is negative, the -T(delta-S) term becomes more positive as temperature increases, which works against the negative delta-H and makes delta-G less negative (closer to zero, eventually becoming positive) at higher temperatures; therefore, increasing the temperature makes this reaction less spontaneous, not more.",
    ["Temperature dependence of spontaneity"])

add(6, "Very Hard", "long", True,
    "Consider the reaction N2(g) + 3 H2(g) -> 2 NH3(g), which has delta-H-standard = -92.0 kJ and delta-S-standard = -199 J/K at 298 K. (a) Calculate delta-G-standard at 298 K, showing your work, and state whether the reaction is spontaneous under standard conditions at this temperature. (b) Calculate the temperature at which this reaction would switch from spontaneous to non-spontaneous, showing your work. (c) Industrially, this reaction (the Haber process) is run at high temperature (around 700 K) despite your answer to part (b) suggesting it becomes non-spontaneous above a certain temperature. Explain, using the distinction between thermodynamics and kinetics, why running the reaction at high temperature can still make practical sense.",
    [("delta_g_calc", "Correctly calculates delta-G = -92.0 - (298)(-0.199) = -32.7 kJ, spontaneous at 298 K", 1),
     ("crossover_temp", "Correctly calculates the crossover temperature T = delta-H/delta-S = 92,000/199 = 462 K", 1),
     ("kinetics_vs_thermo_explanation", "Explains that although higher temperature reduces the thermodynamic favorability (per part b), it dramatically increases the reaction rate (kinetics), and industrial processes often trade some equilibrium yield for a practically useful reaction rate", 1)],
    "(a) delta-G = delta-H - T(delta-S) = -92.0 kJ - (298 K)(-0.199 kJ/K) = -92.0 - (-59.3) = -92.0 + 59.3 = -32.7 kJ. Since delta-G is negative, the reaction is spontaneous under standard conditions at 298 K. (b) At the crossover point, delta-G = 0, so T = delta-H/delta-S = 92,000 J / 199 J/K = 462 K. Above this temperature, the reaction becomes non-spontaneous under standard conditions. (c) This reaction is exothermic with decreasing entropy, so thermodynamically, lower temperature favors more complete conversion to product (higher equilibrium yield). However, at low temperature, the reaction proceeds extremely slowly due to a high activation energy barrier -- an industrial process needs a reaction to occur at a practical, economically useful rate, not just at a thermodynamically favorable equilibrium position. Running the Haber process at around 700 K sacrifices some equilibrium yield (since the reaction is less thermodynamically favorable at high T, per part (b)) in exchange for a dramatically faster reaction rate (a kinetic benefit), illustrating that industrial reaction conditions are often chosen as a practical compromise between thermodynamic favorability and reaction kinetics, not by thermodynamics alone.",
    ["Combined thermodynamics and kinetics reasoning"])

# ===== MODULE 7: Chemical Equilibrium =====

add(7, "Easy", "short", True,
    "Write the equilibrium expression, Keq, for the reaction: 4 NH3(g) + 5 O2(g) <=> 4 NO(g) + 6 H2O(g)",
    [("expression", "Correctly writes Keq = [NO]^4[H2O]^6 / ([NH3]^4[O2]^5)", 1)],
    "Keq = ([NO]^4 [H2O]^6) / ([NH3]^4 [O2]^5).",
    ["Equilibrium expression"])

add(7, "Easy", "long", True,
    "Consider the equilibrium 2 SO2(g) + O2(g) <=> 2 SO3(g), which is exothermic in the forward direction. (a) Predict the direction the equilibrium shifts if the volume of the container is decreased at constant temperature, and explain using Le Chatelier's principle. (b) Predict the direction the equilibrium shifts if the temperature is increased, and explain your reasoning. (c) Predict what happens to the value of Keq (increases, decreases, or stays the same) in each of the two scenarios above, and explain the key difference between how volume changes and temperature changes affect Keq.",
    [("volume_shift", "Correctly predicts the equilibrium shifts toward products (fewer moles of gas) when volume decreases", 1),
     ("temperature_shift", "Correctly predicts the equilibrium shifts toward reactants (endothermic direction) when temperature increases, since the forward reaction is exothermic", 1),
     ("keq_distinction", "Correctly explains that Keq is unchanged by the volume change but does change (decreases here) with the temperature change, since Keq depends only on temperature", 1)],
    "(a) Decreasing the volume increases pressure, and by Le Chatelier's principle, the equilibrium shifts toward the side with fewer moles of gas to partially counteract the pressure increase; the product side (2 mol SO3) has fewer gas moles than the reactant side (2 + 1 = 3 mol), so the equilibrium shifts toward products (right). (b) Since the forward reaction is exothermic, heat can be treated as a product; increasing temperature adds heat, so by Le Chatelier's principle the equilibrium shifts toward the endothermic direction (the reverse reaction) to absorb the added heat, shifting toward reactants (left). (c) In the volume-change scenario, Keq stays exactly the same, because Keq depends only on temperature, and temperature was held constant; only the position of equilibrium (concentrations) shifted, not the value of the constant itself. In the temperature-change scenario, Keq does change (it decreases here), because Keq is fundamentally a function of temperature -- shifting toward reactants at higher temperature for an exothermic reaction corresponds to a genuinely smaller equilibrium constant, not just a repositioning of the same constant.",
    ["Le Chatelier's principle: volume vs temperature effects on Keq"])

add(7, "Medium", "short", True,
    "A reaction has Keq = 2.5 x 10^-3 at a given temperature. At a certain moment, the reaction quotient Q is calculated to be 8.0 x 10^-5. State which direction the reaction will proceed to reach equilibrium, and justify your answer.",
    [("direction_and_justification", "Correctly states the reaction proceeds forward (toward products) because Q is less than Keq", 1)],
    "The reaction will proceed forward, toward products. Since Q (8.0 x 10^-5) is less than Keq (2.5 x 10^-3), the system currently has a lower ratio of products to reactants than it will have at equilibrium, so the reaction must produce more products (and consume reactants) until Q increases to equal Keq.",
    ["Reaction quotient Q vs Keq"])

add(7, "Medium", "long", True,
    "For the reaction A(g) + B(g) <=> C(g), Keq = 9.00 at a given temperature. A reaction vessel is initially charged with [A]0 = 2.00 M, [B]0 = 2.00 M, and no C present. (a) Set up an ICE table for this reaction. (b) Using the ICE table and the given Keq, solve for the equilibrium concentration of C, showing your work (a quadratic will be needed; you may assume the physically reasonable root). (c) Verify your answer by substituting the equilibrium concentrations back into the equilibrium expression.",
    [("ice_table_setup", "Correctly sets up the ICE table with initial 2.00, 2.00, 0 and changes -x, -x, +x", 1),
     ("quadratic_solution", "Correctly solves x/((2.00-x)^2) = 9.00 using the quadratic formula to find the physically valid x = 1.42 M", 1),
     ("verification", "Correctly substitutes back to verify Keq = 9.00 within rounding", 1)],
    "(a) ICE table: Initial [A]=2.00, [B]=2.00, [C]=0. Change: [A]=-x, [B]=-x, [C]=+x. Equilibrium: [A]=2.00-x, [B]=2.00-x, [C]=x. (b) Keq = [C]/([A][B]) = x/(2.00-x)^2 = 9.00. Rearranging: x = 9.00(2.00-x)^2 = 9.00(4.00 - 4.00x + x^2) = 36.0 - 36.0x + 9.00x^2. So 9.00x^2 - 37.0x + 36.0 = 0. Using the quadratic formula: x = [37.0 +/- sqrt(37.0^2 - 4(9.00)(36.0))] / (2 x 9.00) = [37.0 +/- sqrt(1369 - 1296)] / 18.0 = [37.0 +/- sqrt(73.0)] / 18.0 = [37.0 +/- 8.54] / 18.0. This gives x = 2.53 (not physically valid, since it exceeds the initial 2.00 M available) or x = 1.58. The physically reasonable root is x = 1.58 M, so [C] = 1.58 M. (c) Verification: [A] = [B] = 2.00 - 1.58 = 0.42 M. Keq = [C]/([A][B]) = 1.58/(0.42 x 0.42) = 1.58/0.176 = 8.98, which matches the given Keq of 9.00 within rounding error.",
    ["ICE table with quadratic solution"])

add(7, "Hard", "short", True,
    "The Ksp of PbCl2 is 1.6 x 10^-5. Calculate the molar solubility of PbCl2 in pure water, showing your work. (Note: PbCl2 dissociates into one Pb2+ ion and two Cl- ions.)",
    [("calculation", "Correctly sets up Ksp = s(2s)^2 = 4s^3 and solves for s = 1.59 x 10^-2 M", 1)],
    "PbCl2 -> Pb2+ + 2 Cl-. If molar solubility is s, then [Pb2+] = s and [Cl-] = 2s. Ksp = [Pb2+][Cl-]^2 = (s)(2s)^2 = 4s^3 = 1.6 x 10^-5. s^3 = 4.0 x 10^-6. s = (4.0 x 10^-6)^(1/3) = 1.59 x 10^-2 M.",
    ["Ksp and molar solubility: unequal stoichiometry"])

add(7, "Hard", "long", True,
    "The Ksp of Ag2CrO4 is 1.1 x 10^-12 (Ag2CrO4 dissociates into 2 Ag+ and 1 CrO4^2-). (a) Calculate the molar solubility of Ag2CrO4 in pure water, showing your work. (b) Calculate the molar solubility of Ag2CrO4 in a 0.100 M AgNO3 solution, showing your work and any simplifying assumptions you make. (c) Compare your answers to parts (a) and (b), and explain the direction of the difference in terms of the common ion effect.",
    [("pure_water_solubility", "Correctly sets up Ksp = (2s)^2(s) = 4s^3 and solves for s = 6.50 x 10^-5 M", 1),
     ("common_ion_solubility", "Correctly sets [Ag+] = 0.100 M (approximately, since s is much smaller) and solves Ksp = (0.100)^2(s) for s = 1.1 x 10^-10 M", 1),
     ("comparison", "Correctly explains solubility is much lower in the AgNO3 solution due to the common ion (Ag+) effect suppressing further dissociation", 1)],
    "(a) Ag2CrO4 -> 2 Ag+ + CrO4^2-. If solubility is s, [Ag+] = 2s and [CrO4^2-] = s. Ksp = (2s)^2(s) = 4s^3 = 1.1 x 10^-12. s^3 = 2.75 x 10^-13. s = (2.75e-13)^(1/3) = 6.50 x 10^-5 M. (b) In 0.100 M AgNO3, [Ag+] is already approximately 0.100 M from the AgNO3 (assuming the small additional contribution from dissolved Ag2CrO4 is negligible). Ksp = [Ag+]^2[CrO4^2-] = (0.100)^2 (s') = 1.1 x 10^-12. s' = 1.1 x 10^-12 / 0.0100 = 1.1 x 10^-10 M, which is indeed much smaller than 0.100 M, confirming the simplifying assumption was valid. (c) The molar solubility in the AgNO3 solution (1.1 x 10^-10 M) is dramatically lower than in pure water (6.50 x 10^-5 M), a difference of roughly 6 orders of magnitude. This is the common ion effect: the Ag+ already present from the fully dissociated AgNO3 shifts the Ag2CrO4 dissolution equilibrium back toward the solid (undissolved) side, per Le Chatelier's principle, sharply suppressing how much additional Ag2CrO4 can dissolve.",
    ["Ksp with common ion effect: unequal stoichiometry"])

add(7, "Very Hard", "short", True,
    "For the equilibrium 2 NOCl(g) <=> 2 NO(g) + Cl2(g), Keq = 1.6 x 10^-5 at a given temperature. If the initial concentration of NOCl is 1.00 M with no NO or Cl2 present, use the small-x approximation to estimate the equilibrium concentration of Cl2, and verify that the approximation is valid.",
    [("calculation_and_check", "Correctly sets up Keq = (2x)^2(x)/(1.00)^2 = 4x^3 (using the small-x approximation for NOCl), solves for x = 0.0159 M, and verifies 2x/1.00 is under 5%", 1)],
    "Using the small-x approximation, [NOCl] remains approximately 1.00 M. Keq = [NO]^2[Cl2]/[NOCl]^2 = (2x)^2(x)/(1.00)^2 = 4x^3 = 1.6 x 10^-5. x^3 = 4.0 x 10^-6. x = 0.0159 M, so [Cl2] = 0.0159 M. Checking the approximation: the amount of NOCl consumed is 2x = 0.0318 M, which is 0.0318/1.00 = 3.18% of the initial 1.00 M -- under the 5% threshold, so the small-x approximation is valid.",
    ["Small-x approximation with unequal stoichiometric coefficients"])

add(7, "Very Hard", "long", True,
    "For the equilibrium PCl5(g) <=> PCl3(g) + Cl2(g), Keq = 0.0410 at 500 K. A 2.00 L container is initially charged with 1.00 mol of PCl5 and no PCl3 or Cl2. (a) Set up an ICE table in terms of concentration (not moles), and write the equilibrium expression. (b) Solve for the equilibrium concentration of Cl2 using the quadratic formula (the small-x approximation is not valid here; show why it fails before proceeding with the exact solution). (c) Calculate the percent dissociation of PCl5 at equilibrium, showing your work.",
    [("ice_setup", "Correctly converts to initial concentration (0.500 M) and sets up the ICE table and equilibrium expression x^2/(0.500-x) = 0.0410", 1),
     ("quadratic_solution", "Correctly shows the small-x approximation would predict x too large relative to 0.500 M (failing the 5% check) and solves the full quadratic to find x = 0.124 M", 1),
     ("percent_dissociation", "Correctly calculates percent dissociation = (0.124/0.500) x 100 = 24.8%", 1)],
    "(a) Initial [PCl5] = 1.00 mol / 2.00 L = 0.500 M; [PCl3] = [Cl2] = 0. ICE: Initial 0.500, 0, 0. Change -x, +x, +x. Equilibrium: 0.500-x, x, x. Keq = [PCl3][Cl2]/[PCl5] = x^2/(0.500-x) = 0.0410. (b) A quick small-x check: assuming 0.500-x is approximately 0.500 gives x^2 = 0.0410(0.500) = 0.0205, so x = 0.143 M; checking 0.143/0.500 = 28.6%, far above the 5% threshold, so the small-x approximation is invalid and the full quadratic must be solved. Rearranging: x^2 = 0.0410(0.500-x) = 0.0205 - 0.0410x, so x^2 + 0.0410x - 0.0205 = 0. Quadratic formula: x = [-0.0410 +/- sqrt(0.0410^2 + 4(0.0205))] / 2 = [-0.0410 +/- sqrt(0.00168 + 0.0820)] / 2 = [-0.0410 +/- sqrt(0.0837)] / 2 = [-0.0410 +/- 0.2893] / 2. Taking the positive root: x = (0.2483)/2 = 0.124 M. (c) Percent dissociation = (x / [PCl5]initial) x 100 = (0.124 / 0.500) x 100 = 24.8%.",
    ["Full quadratic ICE solution with percent dissociation"])

# ===== MODULE 8: Acids and Bases =====

add(8, "Easy", "short", True,
    "A solution has a hydrogen ion concentration [H+] = 4.0 x 10^-4 M. Calculate the pH of this solution, showing your work.",
    [("calculation", "Correctly calculates pH = -log(4.0e-4) = 3.40", 1)],
    "pH = -log[H+] = -log(4.0 x 10^-4) = 3.40.",
    ["pH calculation"])

add(8, "Easy", "short", True,
    "Identify the conjugate base of HSO4- in the reaction HSO4-(aq) + H2O(l) <=> H3O+(aq) + SO4^2-(aq), and explain how you identified it.",
    [("conjugate_base", "Correctly identifies SO4^2- as the conjugate base, formed when HSO4- loses a proton", 1)],
    "The conjugate base of HSO4- is SO4^2-. A conjugate base is what remains after an acid donates (loses) a proton (H+); HSO4- loses one H+ to form SO4^2-, so SO4^2- is HSO4-'s conjugate base.",
    ["Conjugate acid-base pairs"])

add(8, "Easy", "long", True,
    "A 0.0250 M solution of HNO3 (a strong acid) is prepared. (a) Calculate [H+] in this solution, explaining why the strong acid assumption simplifies this calculation. (b) Calculate the pH of the solution, showing your work. (c) Calculate the pOH of the solution, showing your work, and verify that pH + pOH = 14.00 at 25 degrees C.",
    [("h_concentration", "Correctly identifies [H+] = 0.0250 M because HNO3 fully dissociates as a strong acid", 1),
     ("ph_calc", "Correctly calculates pH = 1.60", 1),
     ("poh_verification", "Correctly calculates pOH = 12.40 and verifies pH + pOH = 14.00", 1)],
    "(a) Since HNO3 is a strong acid, it dissociates essentially 100% in water, so [H+] equals the initial concentration of HNO3 directly, without needing an equilibrium (Ka-based) calculation: [H+] = 0.0250 M. (b) pH = -log(0.0250) = 1.60. (c) pOH = 14.00 - pH = 14.00 - 1.60 = 12.40. Verification: pH + pOH = 1.60 + 12.40 = 14.00, confirming the relationship holds at 25 degrees C.",
    ["Strong acid pH and pOH"])

add(8, "Medium", "short", True,
    "A 0.200 M solution of a weak acid HA has Ka = 4.0 x 10^-4. Calculate the pH of this solution, showing your work and stating any approximation used.",
    [("calculation", "Correctly sets up x^2/0.200=4.0e-4, solves x=[H+]=0.00894 M, and calculates pH=2.05", 1)],
    "Using the small-x approximation: Ka = x^2/[HA]0, so x^2 = Ka x [HA]0 = (4.0 x 10^-4)(0.200) = 8.0 x 10^-5. x = sqrt(8.0e-5) = 0.00894 M = [H+]. pH = -log(0.00894) = 2.05. (Checking the approximation: 0.00894/0.200 = 4.5%, under the 5% threshold, so it is valid.)",
    ["Weak acid pH from Ka"])

add(8, "Medium", "short", True,
    "Predict whether a 0.100 M aqueous solution of NaF will be acidic, basic, or neutral, and justify your prediction using the concept of hydrolysis.",
    [("prediction_and_justification", "Correctly predicts a basic solution because F- (conjugate base of the weak acid HF) hydrolyzes water to produce OH-, while Na+ does not hydrolyze", 1)],
    "The solution will be basic. NaF is the salt of a strong base (NaOH) and a weak acid (HF). Na+ does not hydrolyze appreciably (it is the cation of a strong base). F-, however, is the conjugate base of the weak acid HF, and being a moderately strong conjugate base, it hydrolyzes water: F- + H2O <=> HF + OH-, producing excess OH- and making the solution basic.",
    ["Salt hydrolysis"])

add(8, "Medium", "long", True,
    "A buffer solution is prepared by mixing 0.250 mol of NH3 and 0.250 mol of NH4Cl in 1.00 L of solution. (Kb of NH3 = 1.8 x 10^-5) (a) Calculate the pKa of the conjugate acid NH4+, showing your work. (b) Using the Henderson-Hasselbalch equation, calculate the pH of this buffer, showing your work. (c) Explain, without further calculation, why this buffer's pH would remain the same if the solution were diluted with water (assuming the dilution does not change the mol ratio significantly).",
    [("pka_calc", "Correctly calculates Ka = Kw/Kb = 5.6 x 10^-10 and pKa = 9.25", 1),
     ("ph_calc", "Correctly applies Henderson-Hasselbalch with equal concentrations to find pH = pKa = 9.25", 1),
     ("dilution_explanation", "Explains that Henderson-Hasselbalch depends on the ratio of moles (or concentrations) of base to acid, which is unchanged by dilution since both are diluted equally", 1)],
    "(a) Ka(NH4+) = Kw/Kb(NH3) = 1.0 x 10^-14 / 1.8 x 10^-5 = 5.6 x 10^-10. pKa = -log(5.6 x 10^-10) = 9.25. (b) pH = pKa + log([NH3]/[NH4+]) = 9.25 + log(0.250/0.250) = 9.25 + log(1) = 9.25 + 0 = 9.25. (c) The Henderson-Hasselbalch equation depends on the ratio of [base]/[acid], not their absolute concentrations. Diluting the buffer with water reduces both [NH3] and [NH4+] by the same factor, so their ratio (and therefore the pH) remains unchanged -- this is exactly why buffers are effective at maintaining a stable pH even when somewhat diluted.",
    ["Henderson-Hasselbalch and buffer dilution"])

add(8, "Medium", "long", True,
    "A weak acid, HA, has a measured [H+] = 2.65 x 10^-3 M in a 0.150 M solution at equilibrium. (a) Calculate the percent ionization of HA under these conditions, showing your work. (b) Calculate the Ka of HA, showing your work. (c) Predict, with reasoning (not calculation), how the percent ionization would change if the same acid HA were dissolved to make a more dilute solution (e.g., 0.0150 M instead of 0.150 M).",
    [("percent_ionization", "Correctly calculates percent ionization = (2.65e-3/0.150) x 100 = 1.77%", 1),
     ("ka_calc", "Correctly calculates Ka = (2.65e-3)^2 / (0.150 - 2.65e-3) = 4.79 x 10^-5", 1),
     ("dilution_prediction", "Correctly predicts percent ionization increases at lower concentration, per Le Chatelier's principle / Ostwald dilution reasoning", 1)],
    "(a) Percent ionization = ([H+]/[HA]0) x 100 = (2.65 x 10^-3 / 0.150) x 100 = 1.77%. (b) Ka = [H+][A-]/[HA] = (2.65e-3)(2.65e-3)/(0.150 - 2.65e-3) = (7.02e-6)/(0.1473) = 4.77 x 10^-5. (c) Percent ionization would increase at the more dilute concentration. As a weak acid solution is diluted, the equilibrium HA <=> H+ + A- shifts toward more dissociation (more moles of products relative to reactant) to partially counteract the reduced concentration, per Le Chatelier's principle; even though the absolute [H+] decreases with dilution, the fraction of the original HA that has ionized (percent ionization) increases.",
    ["Percent ionization and Ka", "Dilution effect on weak acid ionization"])

add(8, "Medium", "long", True,
    "Phosphoric acid, H3PO4, is triprotic with Ka1 = 7.5 x 10^-3, Ka2 = 6.2 x 10^-8, and Ka3 = 4.8 x 10^-13. A 0.100 M solution of H3PO4 is prepared. (a) Explain why, for the purpose of calculating the solution's pH, only the first dissociation step needs to be considered. (b) Using only the first dissociation step and the small-x approximation (checking its validity), calculate the pH of the solution. (c) Estimate the equilibrium concentration of PO4^3- in this solution, and explain qualitatively why it is exceedingly small compared to [H2PO4-].",
    [("dominant_step_explanation", "Explains that Ka1 is many orders of magnitude larger than Ka2 and Ka3, so essentially all of the [H+] comes from the first dissociation step", 1),
     ("ph_calculation", "Sets up x^2/(0.100-x) = 7.5e-3, solves (noting the small-x approximation likely fails and a quadratic may be needed) to find [H+] and pH", 1),
     ("po4_estimate", "Explains PO4^3- is exceedingly small because it requires three successive dissociation steps, the last two of which (Ka2, Ka3) proceed to a vanishingly small extent", 1)],
    "(a) Ka1 (7.5 x 10^-3) is roughly 100,000 times larger than Ka2, and Ka2 is roughly 100,000 times larger than Ka3; because each successive dissociation constant is dramatically smaller, essentially all of the H+ produced in solution comes from the first dissociation step, making the second and third steps' contributions to [H+] negligible by comparison. (b) Checking small-x first: x^2 = 7.5e-3(0.100) = 7.5e-4, x = 0.0274; checking 0.0274/0.100 = 27.4%, well above 5%, so the approximation fails and the quadratic must be solved: x^2 = 7.5e-3(0.100 - x), giving x^2 + 0.0075x - 0.00075 = 0. Quadratic formula: x = [-0.0075 + sqrt(0.0075^2 + 4(0.00075))]/2 = [-0.0075 + sqrt(0.0000563+0.00300)]/2 = [-0.0075+sqrt(0.003056)]/2 = [-0.0075+0.05528]/2 = 0.02389. So [H+] = 0.0239 M, and pH = -log(0.0239) = 1.62. (c) [PO4^3-] would be extremely small, far below any concentration relevant to this solution's pH, because reaching PO4^3- requires the acid to lose all three protons, and the second and third dissociation steps (governed by the very small Ka2 and Ka3) proceed to only a minuscule extent; nearly all of the phosphate species in solution remains as H2PO4- (from the essentially-complete first dissociation) or, to a much smaller extent, HPO4^2-, with PO4^3- present only in trace amounts.",
    ["Polyprotic acid: dominant step and successive dissociation extent"])

add(8, "Medium", "long", True,
    "50.0 mL of 0.100 M HCl is titrated with 0.100 M NaOH. (a) Calculate the pH of the original HCl solution before any titrant is added, showing your work. (b) Calculate the pH after 25.0 mL of NaOH has been added, showing your work. (c) Calculate the pH at the equivalence point (i.e., after exactly 50.0 mL of NaOH has been added), and explain why this value makes sense given that both HCl and NaOH are strong.",
    [("initial_ph", "Correctly calculates the initial pH = 1.00 since [H+] = 0.100 M for the strong acid", 1),
     ("midpoint_ph", "Correctly calculates the pH after 25.0 mL of NaOH added using remaining excess H+ (approximately pH = 1.48)", 1),
     ("equivalence_ph", "Correctly identifies the equivalence point pH as 7.00 (neutral) and explains this is expected for a strong acid-strong base titration since the resulting salt (NaCl) does not hydrolyze", 1)],
    "(a) Initial [H+] = 0.100 M (HCl is a strong acid, fully dissociated). pH = -log(0.100) = 1.00. (b) Moles HCl initial = 0.0500 L x 0.100 M = 0.00500 mol. Moles NaOH added = 0.0250 L x 0.100 M = 0.00250 mol. Moles H+ remaining = 0.00500 - 0.00250 = 0.00250 mol. Total volume = 50.0 + 25.0 = 75.0 mL = 0.0750 L. [H+] = 0.00250/0.0750 = 0.0333 M. pH = -log(0.0333) = 1.48. (c) At the equivalence point, moles NaOH added (0.00500 mol) exactly equal moles HCl (0.00500 mol), so all H+ and OH- have reacted completely to form water and the neutral salt NaCl. Since both Na+ and Cl- are spectator ions that do not hydrolyze (conjugate species of a strong base and strong acid, respectively), the resulting solution is neutral, giving pH = 7.00, exactly as expected for any strong acid-strong base titration equivalence point.",
    ["Strong acid-strong base titration curve"])

add(8, "Hard", "short", True,
    "A buffer is prepared with 0.400 mol of CH3COOH and 0.250 mol of CH3COONa in 1.00 L of solution (pKa of acetic acid = 4.74). If 0.0500 mol of NaOH is added to this buffer (assume no volume change), calculate the new pH, showing your work.",
    [("calculation", "Correctly updates the moles after reaction (0.350 mol acid, 0.300 mol base) and applies Henderson-Hasselbalch to find pH = 4.67", 1)],
    "Added NaOH reacts with CH3COOH: new mol CH3COOH = 0.400 - 0.0500 = 0.350 mol; new mol CH3COO- = 0.250 + 0.0500 = 0.300 mol. pH = pKa + log([A-]/[HA]) = 4.74 + log(0.300/0.350) = 4.74 + log(0.857) = 4.74 + (-0.067) = 4.67.",
    ["Buffer response to added strong base"])

add(8, "Hard", "short", True,
    "For a diprotic acid H2A, Ka1 = 4.5 x 10^-3 and Ka2 = 1.9 x 10^-8. In a titration of H2A with NaOH, the second equivalence point occurs at 40.0 mL of titrant added. Predict the volume of titrant at the first equivalence point, and explain your reasoning.",
    [("prediction_and_reasoning", "Correctly predicts 20.0 mL, reasoning that the first equivalence point requires exactly half as much titrant as the second (since H2A -> HA- requires 1 equivalent, HA- -> A2- requires 1 more)", 1)],
    "The first equivalence point should occur at 20.0 mL, exactly half the volume of the second equivalence point. Each proton removed from a diprotic acid requires the same number of moles of NaOH (1 mole NaOH per mole of acid per proton). Since the first equivalence point corresponds to removing only the first, more acidic proton (H2A -> HA-) and the second equivalence point corresponds to removing both protons (H2A -> A2-), and both steps require equal moles of the same original H2A, the first equivalence point must occur at exactly half the total titrant volume needed to reach the second.",
    ["Diprotic acid titration: equivalence point volumes"])

add(8, "Hard", "long", True,
    "50.0 mL of 0.100 M CH3COOH (Ka = 1.8 x 10^-5, pKa = 4.74) is titrated with 0.100 M NaOH. (a) Calculate the pH after 10.0 mL of NaOH has been added, showing your work. (b) Calculate the pH at the half-equivalence point, and explain why this calculation is simpler than part (a). (c) Calculate the pH at the equivalence point (50.0 mL of NaOH added), noting that this requires a different approach than parts (a) and (b) since no CH3COOH remains -- set up and solve the appropriate equilibrium.",
    [("early_titration_ph", "Correctly calculates moles reacted and remaining, then applies Henderson-Hasselbalch to find pH = 4.22", 1),
     ("half_equivalence_ph", "Correctly identifies pH = pKa = 4.74 at half-equivalence (25.0 mL) and explains the log term becomes zero since [HA]=[A-]", 1),
     ("equivalence_point_ph", "Recognizes the solution now contains only CH3COO- (a weak base) and sets up a Kb equilibrium to find a basic pH (approximately 8.72)", 1)],
    "(a) Moles CH3COOH initial = 0.0500 x 0.100 = 0.00500 mol. Moles NaOH added = 0.0100 x 0.100 = 0.00100 mol. Remaining CH3COOH = 0.00500-0.00100 = 0.00400 mol; CH3COO- formed = 0.00100 mol. pH = pKa + log([A-]/[HA]) = 4.74 + log(0.00100/0.00400) = 4.74 + log(0.250) = 4.74 - 0.602 = 4.14. (b) At the half-equivalence point (25.0 mL added), exactly half the original CH3COOH has been converted to CH3COO-, so [HA] = [A-], making log([A-]/[HA]) = log(1) = 0; therefore pH = pKa = 4.74 directly, with no further calculation needed -- simpler than part (a) because the log term vanishes. (c) At the equivalence point, all 0.00500 mol CH3COOH has been converted to 0.00500 mol CH3COO-, dissolved in a total volume of 50.0+50.0=100.0 mL = 0.1000 L, giving [CH3COO-] = 0.0500 M. CH3COO- is a weak base: Kb = Kw/Ka = 1.0e-14/1.8e-5 = 5.6e-10. Setting up Kb = x^2/(0.0500-x) is approximately x^2/0.0500 = 5.6e-10 (small-x valid), x^2 = 2.8e-11, x = [OH-] = 5.29e-6 M. pOH = -log(5.29e-6) = 5.28. pH = 14.00 - 5.28 = 8.72, confirming the equivalence point of a weak acid-strong base titration is basic, as expected.",
    ["Weak acid titration: three-point pH calculation"])

add(8, "Hard", "long", True,
    "A diprotic acid H2A has Ka1 = 1.0 x 10^-3 and Ka2 = 1.0 x 10^-7. A 0.100 M solution of H2A is prepared. (a) Calculate [H+] and pH using only the first dissociation step (with the small-x approximation, checking its validity). (b) Using your result from part (a), estimate the concentration of A2- in solution, explaining why the second dissociation step can be treated somewhat independently once [H+] and [HA-] are established from the first step. (c) Verify that your assumption that the second dissociation does not significantly affect [H+] is reasonable, by comparing the magnitude of [A2-] to [H+].",
    [("first_step_calc", "Sets up x^2/0.100=1.0e-3, checks validity (x=0.01, 10% -- borderline/invalid, quadratic needed), solves for [H+] approximately 0.00916 M, pH approximately 2.04", 1),
     ("a2_estimate", "Uses Ka2 = [H+][A2-]/[HA-] with [H+] approx [HA-] from step 1 to estimate [A2-] approximately equal to Ka2 = 1.0e-7 M", 1),
     ("verification", "Explains that [A2-] (about 1.0e-7 M) is many orders of magnitude smaller than [H+] (about 0.00916 M), confirming the second step's negligible effect on total [H+]", 1)],
    "(a) Small-x check: x^2 = 1.0e-3(0.100) = 1.0e-4, x = 0.0100; checking 0.0100/0.100 = 10.0%, above the 5% threshold, so a quadratic is more accurate: x^2 = 1.0e-3(0.100-x), x^2+0.0010x-0.0001=0. x = [-0.0010+sqrt(0.0010^2+4(0.0001))]/2 = [-0.0010+sqrt(0.000001+0.0004)]/2 = [-0.0010+sqrt(0.000401)]/2 = [-0.0010+0.02002]/2 = 0.00951. So [H+] is approximately 0.00951 M and pH = -log(0.00951) = 2.02. (b) For the second dissociation step, HA- <=> H+ + A2-, Ka2 = [H+][A2-]/[HA-]. From step 1, [H+] and [HA-] are both approximately equal to x = 0.00951 M (since each ionization event of H2A produces one H+ and one HA-). Since [H+] approximately equals [HA-] in this expression, they approximately cancel: Ka2 = [H+][A2-]/[HA-] is approximately [A2-] when [H+] is approximately [HA-], so [A2-] is approximately equal to Ka2 itself = 1.0 x 10^-7 M. (c) [A2-] (approximately 1.0 x 10^-7 M) is roughly 5 orders of magnitude smaller than [H+] (approximately 0.00951 M), confirming that the tiny additional H+ contributed by the second dissociation step is utterly negligible compared to the H+ already present from the first step -- validating the assumption that only the first dissociation step needs to be considered when calculating the solution's overall pH.",
    ["Diprotic acid: successive equilibrium approximation"])

add(8, "Hard", "long", True,
    "Trichloroacetic acid (Cl3CCOOH, Ka approximately 3.0 x 10^-1) is compared to acetic acid (CH3COOH, Ka = 1.8 x 10^-5). (a) Calculate the pH of a 0.100 M solution of trichloroacetic acid; note that because Ka is so large relative to the initial concentration, the small-x approximation is not valid and you should instead solve the full quadratic (or recognize the acid ionizes to a very large extent). (b) Calculate the pH of a 0.100 M solution of acetic acid using the small-x approximation. (c) Explain, in terms of molecular structure (specifically the electron-withdrawing effect of the chlorine atoms), why trichloroacetic acid is so much stronger than acetic acid despite both being carboxylic acids.",
    [("tcaa_ph", "Recognizes the small-x approximation fails badly (Ka approaches the same order as the concentration) and solves the quadratic to find a large extent of ionization and correspondingly low pH", 1),
     ("acetic_acid_ph", "Correctly calculates pH approximately 2.87 using the small-x approximation for acetic acid", 1),
     ("structural_explanation", "Explains that the three highly electronegative chlorine atoms inductively withdraw electron density, stabilizing the negative charge on the conjugate base and shifting the ionization equilibrium strongly toward products", 1)],
    "(a) Ka = x^2/(0.100-x) = 0.30. Since Ka (0.30) is comparable in magnitude to the initial concentration (0.100 M), the small-x approximation clearly fails (it would predict x = sqrt(0.030) = 0.173 M, exceeding the initial concentration entirely, which is impossible), so the full quadratic must be solved: x^2 = 0.30(0.100-x) = 0.0300-0.30x, so x^2+0.30x-0.0300=0. x = [-0.30+sqrt(0.30^2+4(0.0300))]/2 = [-0.30+sqrt(0.0900+0.1200)]/2 = [-0.30+sqrt(0.2100)]/2 = [-0.30+0.4583]/2 = 0.0791. So [H+] = 0.0791 M and pH = -log(0.0791) = 1.10, reflecting that trichloroacetic acid ionizes to a very large extent (about 79% of the original 0.100 M) at this concentration, behaving almost like a strong acid. (b) Using small-x: x^2 = 1.8e-5(0.100) = 1.8e-6, x = 0.00134 M = [H+]; checking 0.00134/0.100 = 1.34%, valid. pH = -log(0.00134) = 2.87. (c) The three chlorine atoms in trichloroacetic acid are highly electronegative and withdraw electron density inductively through the carbon backbone toward the carboxyl group; this inductive electron withdrawal stabilizes the negative charge that develops on the conjugate base (trichloroacetate ion, Cl3CCOO-) after the proton is lost, making that ionized form energetically much more favorable relative to the neutral acid. Acetic acid's methyl group, by contrast, is only weakly electron-donating (or roughly neutral) and does not provide this stabilization, so acetic acid's conjugate base is comparatively less stabilized, and acetic acid ionizes to a much smaller extent, making it a much weaker acid.",
    ["Acid strength and molecular structure: inductive effect"])

add(8, "Very Hard", "short", True,
    "A 40.0 mL sample of 0.100 M NH3 (Kb = 1.8 x 10^-5) is titrated with 0.100 M HCl. Calculate the pH after 15.0 mL of HCl has been added (before the equivalence point, which occurs at 40.0 mL), showing your work.",
    [("calculation", "Correctly sets up the resulting NH3/NH4+ buffer, calculates pKa of NH4+ (9.25), and applies Henderson-Hasselbalch to find pH = 9.60", 1)],
    "Moles NH3 initial = 0.0400 x 0.100 = 0.00400 mol. Moles HCl added = 0.0150 x 0.100 = 0.00150 mol. NH3 remaining = 0.00400-0.00150 = 0.00250 mol; NH4+ formed = 0.00150 mol. Ka(NH4+) = Kw/Kb = 1.0e-14/1.8e-5 = 5.6e-10, pKa = 9.25. pH = pKa + log([NH3]/[NH4+]) = 9.25 + log(0.00250/0.00150) = 9.25 + log(1.667) = 9.25 + 0.222 = 9.47.",
    ["Weak base titration: pH before equivalence"])

add(8, "Very Hard", "short", True,
    "The solubility of Ca(OH)2 (Ksp = 5.5 x 10^-6) is measured in pure water and again in a solution buffered at pH = 13.00. Given that pure water produces a natural equilibrium [OH-] of approximately 2.24 x 10^-2 M (from Ca(OH)2 dissolving alone), and the pH 13.00 buffer fixes [OH-] at 1.0 x 10^-1 M, predict and justify whether Ca(OH)2 is more or less soluble in the pH 13.00 buffer than in pure water.",
    [("prediction_and_justification", "Correctly predicts lower solubility in the pH 13 buffer because the buffer's fixed [OH-] (0.10 M) is higher than the natural pure-water level (0.0224 M), triggering the common ion effect", 1)],
    "Ca(OH)2 is less soluble in the pH 13.00 buffer. Since Ksp = [Ca2+][OH-]^2 is fixed, and the pH 13.00 buffer imposes a higher fixed [OH-] (0.10 M) than the [OH-] that would naturally accumulate from Ca(OH)2 dissolving in pure water alone (0.0224 M), the excess common ion (OH-) suppresses further dissolution of Ca(OH)2 via Le Chatelier's principle, resulting in a lower equilibrium [Ca2+] and lower overall solubility compared to pure water.",
    ["Ksp and pH-dependent solubility: common ion suppression"])

add(8, "Very Hard", "long", True,
    "A 40.0 mL sample of 0.100 M H2A (a diprotic acid with Ka1 = 1.0 x 10^-3 and Ka2 = 1.0 x 10^-8) is titrated with 0.100 M NaOH. (a) Calculate the volumes of NaOH needed to reach the first and second equivalence points, showing your work. (b) Calculate the pH at the first equivalence point, recognizing that at this point the solution contains only the amphiprotic species HA-, whose pH can be approximated as pH = (pKa1 + pKa2)/2. (c) Explain conceptually why this amphiprotic-species approximation makes sense, referencing HA-'s ability to act as both an acid and a base.",
    [("equivalence_volumes", "Correctly calculates 40.0 mL for the first equivalence point and 80.0 mL for the second", 1),
     ("first_eq_ph", "Correctly calculates pH = (3.00+8.00)/2 = 5.50 at the first equivalence point", 1),
     ("amphiprotic_explanation", "Explains that HA- can either donate a proton (acting as an acid, governed by Ka2) or accept a proton back to reform H2A (acting as a base, governed by Ka1's reverse), and the midpoint approximation balances these two competing tendencies", 1)],
    "(a) Moles H2A = 0.0400 L x 0.100 M = 0.00400 mol. The first equivalence point requires 1 mole of NaOH per mole of H2A (removing the first proton): 0.00400 mol NaOH needed, at 0.100 M that is 0.00400/0.100 = 0.0400 L = 40.0 mL. The second equivalence point requires a second full equivalent, so an additional 40.0 mL, for a total of 80.0 mL. (b) pH at the first equivalence point (where only the amphiprotic species HA- is present) is approximated as pH = (pKa1+pKa2)/2 = (3.00+8.00)/2 = 5.50, using pKa1 = -log(1.0e-3) = 3.00 and pKa2 = -log(1.0e-8) = 8.00. (c) HA- is amphiprotic: it can act as an acid by donating its remaining proton (HA- <=> H+ + A2-, governed by Ka2) or it can act as a base by accepting a proton to reform H2A (the reverse of the first dissociation, related to Ka1). These two competing equilibria pull the pH in opposite directions -- Ka2 alone would suggest further ionization (lowering pH further), while HA-'s basic tendency to reform H2A pulls the other way -- and the (pKa1+pKa2)/2 approximation reflects a pH balanced between these two competing acid-base tendencies of the same amphiprotic species.",
    ["Amphiprotic species pH approximation"])

add(8, "Very Hard", "long", True,
    "A 0.200 M solution of a weak acid HA (Ka = 6.3 x 10^-5) is titrated with 0.200 M NaOH. At a certain point in the titration, the pH is measured to be 4.50. (a) Using the Henderson-Hasselbalch equation, calculate the ratio [A-]/[HA] at this point in the titration, showing your work. (b) If the original acid sample was 50.0 mL, calculate the volume of NaOH that must have been added to produce this ratio, showing your work (hint: relate the ratio to the fraction of the original acid that has been neutralized). (c) Explain why knowing only the pH (without any other titration data) is sufficient to determine the ratio of conjugate base to acid present, regardless of the total volume or concentration of the titration.",
    [("ratio_calc", "Correctly rearranges Henderson-Hasselbalch to find [A-]/[HA] = 10^(pH-pKa) = 10^(4.50-4.20) = 2.00", 1),
     ("volume_calc", "Correctly relates the 2:1 ratio to the fraction neutralized (2/3 of the acid converted to A-) to find the NaOH volume added (approximately 33.3 mL)", 1),
     ("conceptual_explanation", "Explains that the Henderson-Hasselbalch equation depends only on the ratio of concentrations (which is the same as the ratio of moles, since both species share the same solution volume), not on the absolute amounts or total volume", 1)],
    "(a) pKa = -log(6.3e-5) = 4.20. Rearranging Henderson-Hasselbalch: pH = pKa + log([A-]/[HA]), so log([A-]/[HA]) = pH - pKa = 4.50 - 4.20 = 0.30. [A-]/[HA] = 10^0.30 = 2.00. (b) A ratio of [A-]/[HA] = 2.00 means twice as much A- as HA is present, so of the original acid, the fraction converted to A- is 2/(2+1) = 2/3. Original moles HA = 0.0500 L x 0.200 M = 0.0100 mol. Moles converted to A- = (2/3)(0.0100) = 0.00667 mol, which equals moles of NaOH added (since each mole of NaOH converts one mole of HA to A-). Volume NaOH = 0.00667 mol / 0.200 M = 0.0333 L = 33.3 mL. (c) The Henderson-Hasselbalch equation is expressed purely as a ratio of concentrations, [A-]/[HA]; since both species exist in the same total solution volume at any point in the titration, this concentration ratio is numerically identical to the mole ratio of A- to HA, regardless of what that total volume actually is. Because the equation depends only on this ratio (and the fixed pKa), knowing the pH alone is enough to determine the ratio of conjugate base to acid present, without needing to know the specific total volume or original concentration separately.",
    ["Henderson-Hasselbalch: solving for ratio and titration volume from pH"])

add(8, "Medium", "short", True,
    "A 25.0 mL sample of 0.150 M HBr is mixed with 25.0 mL of 0.150 M KOH. Calculate the pH of the resulting mixture, showing your work.",
    [("calculation", "Correctly recognizes equal moles of strong acid and strong base fully neutralize each other, giving pH = 7.00", 1)],
    "Moles HBr = 0.0250 L x 0.150 M = 0.00375 mol. Moles KOH = 0.0250 L x 0.150 M = 0.00375 mol. Since these are equal moles of a strong acid and a strong base, they neutralize each other completely, leaving only water and the neutral spectator ions K+ and Br- in solution. The resulting solution is neutral: pH = 7.00.",
    ["Strong acid-strong base neutralization"])

add(8, "Medium", "short", True,
    "A 0.0800 M solution of a weak base B has Kb = 5.0 x 10^-5. Calculate the pOH and pH of this solution, showing your work and stating any approximation used.",
    [("calculation", "Correctly sets up x^2/0.0800=5.0e-5, solves x=[OH-]=0.00200 M, finds pOH=2.70 and pH=11.30", 1)],
    "Using the small-x approximation: Kb = x^2/[B]0, so x^2 = (5.0e-5)(0.0800) = 4.0e-6. x = sqrt(4.0e-6) = 0.00200 M = [OH-]. (Checking: 0.00200/0.0800 = 2.5%, valid.) pOH = -log(0.00200) = 2.70. pH = 14.00 - 2.70 = 11.30.",
    ["Weak base pOH and pH from Kb"])

add(8, "Hard", "short", True,
    "A buffer is prepared with 0.300 mol of NaH2PO4 and 0.200 mol of Na2HPO4 in 1.00 L of solution (Ka2 of H3PO4, relevant to this pair, = 6.2 x 10^-8). Calculate the pH of this buffer, showing your work.",
    [("calculation", "Correctly identifies pKa2 = 7.21 and applies Henderson-Hasselbalch with the H2PO4-/HPO4^2- pair to find pH = 7.03", 1)],
    "H2PO4- and HPO4^2- form a conjugate acid-base pair governed by Ka2. pKa2 = -log(6.2e-8) = 7.21. pH = pKa2 + log([HPO4^2-]/[H2PO4-]) = 7.21 + log(0.200/0.300) = 7.21 + log(0.667) = 7.21 - 0.176 = 7.03.",
    ["Buffer from a polyprotic acid conjugate pair"])

add(8, "Hard", "short", True,
    "A 20.0 mL sample of 0.100 M HCOOH (formic acid, Ka = 1.8 x 10^-4, pKa = 3.74) is titrated with 0.100 M NaOH. Calculate the pH after 5.00 mL of NaOH has been added, showing your work.",
    [("calculation", "Correctly calculates moles reacted/remaining and applies Henderson-Hasselbalch to find pH = 3.32", 1)],
    "Moles HCOOH initial = 0.0200 x 0.100 = 0.00200 mol. Moles NaOH added = 0.00500 x 0.100 = 0.000500 mol. Remaining HCOOH = 0.00200-0.000500 = 0.00150 mol; HCOO- formed = 0.000500 mol. pH = pKa + log([A-]/[HA]) = 3.74 + log(0.000500/0.00150) = 3.74 + log(0.333) = 3.74 - 0.477 = 3.26.",
    ["Weak acid titration: early-point pH"])

add(8, "Easy", "long", True,
    "A solution has a pOH of 3.00 at 25 degrees C. (a) Calculate the pH of this solution, showing your work. (b) Calculate [OH-] and [H+] for this solution, showing your work. (c) State whether the solution is acidic, basic, or neutral, and justify your classification using your calculated pH.",
    [("ph_calc", "Correctly calculates pH = 14.00 - 3.00 = 11.00", 1),
     ("concentration_calc", "Correctly calculates [OH-] = 1.0 x 10^-3 M and [H+] = 1.0 x 10^-11 M", 1),
     ("classification", "Correctly classifies the solution as basic since pH is above 7.00", 1)],
    "(a) pH = 14.00 - pOH = 14.00 - 3.00 = 11.00. (b) [OH-] = 10^-pOH = 10^-3.00 = 1.0 x 10^-3 M. [H+] = 10^-pH = 10^-11.00 = 1.0 x 10^-11 M. (c) The solution is basic, since its pH (11.00) is greater than 7.00, indicating a higher concentration of OH- than H+, characteristic of a basic solution at 25 degrees C.",
    ["pH, pOH, and classification"])

add(8, "Hard", "long", True,
    "A 0.100 M solution of NaCN (sodium cyanide) is prepared. (Ka of HCN = 6.2 x 10^-10) (a) Write the hydrolysis reaction for CN- in water. (b) Calculate Kb for CN-, showing your work. (c) Calculate the pH of the 0.100 M NaCN solution, showing your work and stating any approximation used.",
    [("hydrolysis_reaction", "Correctly writes CN-(aq) + H2O(l) <=> HCN(aq) + OH-(aq)", 1),
     ("kb_calc", "Correctly calculates Kb = Kw/Ka = 1.6 x 10^-5", 1),
     ("ph_calc", "Correctly sets up x^2/0.100=1.6e-5, solves for [OH-], and calculates the resulting basic pH (approximately 11.10)", 1)],
    "(a) CN-(aq) + H2O(l) <=> HCN(aq) + OH-(aq). (b) Kb = Kw/Ka = 1.0 x 10^-14 / 6.2 x 10^-10 = 1.6 x 10^-5. (c) Using the small-x approximation: x^2 = Kb x [CN-]0 = (1.6e-5)(0.100) = 1.6e-6. x = sqrt(1.6e-6) = 1.26e-3 M = [OH-]. (Checking: 1.26e-3/0.100 = 1.26%, valid.) pOH = -log(1.26e-3) = 2.90. pH = 14.00 - 2.90 = 11.10.",
    ["Salt hydrolysis: quantitative pH calculation"])

# ===== MODULE 9: Applications of Thermodynamics and Electrochemistry =====

add(9, "Easy", "short", True,
    "For the reaction Mg(s) + 2 AgNO3(aq) -> Mg(NO3)2(aq) + 2 Ag(s), identify which species is oxidized and which is reduced, showing the change in oxidation state for each.",
    [("redox_identification", "Correctly identifies Mg (0 to +2, oxidized) and Ag+ (+1 to 0, reduced)", 1)],
    "Mg is oxidized: its oxidation state changes from 0 (elemental Mg) to +2 (in Mg(NO3)2), losing 2 electrons. Ag+ is reduced: its oxidation state changes from +1 (in AgNO3) to 0 (elemental Ag), gaining 1 electron (each of the two Ag+ ions gains one electron).",
    ["Oxidation states and redox identification"])

add(9, "Easy", "long", True,
    "A galvanic cell is constructed using a Zn/Zn2+ half-cell and a Cu/Cu2+ half-cell, with standard reduction potentials E-standard(Zn2+/Zn) = -0.76 V and E-standard(Cu2+/Cu) = +0.34 V. (a) Determine which half-reaction occurs at the anode and which occurs at the cathode, explaining how you decided. (b) Write the overall balanced cell reaction. (c) Calculate the standard cell potential, E-cell-standard, showing your work.",
    [("electrode_assignment", "Correctly identifies Zn as the anode (oxidation, less positive/more negative reduction potential) and Cu as the cathode (reduction, more positive potential)", 1),
     ("overall_reaction", "Correctly writes Zn(s) + Cu2+(aq) -> Zn2+(aq) + Cu(s)", 1),
     ("cell_potential_calc", "Correctly calculates E-cell-standard = 0.34 - (-0.76) = 1.10 V", 1)],
    "(a) Zn has the more negative (less positive) standard reduction potential, meaning it has a weaker tendency to be reduced and a stronger tendency to be oxidized compared to Cu; therefore Zn is oxidized at the anode, while Cu2+ is reduced at the cathode. (b) Zn(s) + Cu2+(aq) -> Zn2+(aq) + Cu(s). (c) E-cell-standard = E-cathode-standard - E-anode-standard = E-standard(Cu2+/Cu) - E-standard(Zn2+/Zn) = 0.34 - (-0.76) = 1.10 V.",
    ["Galvanic cell setup and standard cell potential"])

add(9, "Medium", "short", True,
    "A galvanic cell has E-cell-standard = +0.80 V and transfers n = 2 mol of electrons per mole of reaction. Calculate delta-G-standard for this reaction, showing your work. (F = 96,485 C/mol)",
    [("calculation", "Correctly applies delta-G = -nFE to find delta-G = -154 kJ", 1)],
    "delta-G-standard = -nFE-cell-standard = -(2)(96,485 C/mol)(0.80 V) = -154,376 J, approximately -154 kJ.",
    ["Gibbs free energy and cell potential"])

add(9, "Medium", "long", True,
    "A voltaic cell is constructed with the following standard reduction potentials: E-standard(Fe3+/Fe2+) = +0.77 V and E-standard(Sn4+/Sn2+) = +0.15 V. (a) Determine which half-reaction serves as the cathode and which serves as the anode for a spontaneous cell, explaining your reasoning. (b) Write the overall balanced cell reaction (balancing electrons transferred). (c) Calculate E-cell-standard for this cell, and confirm that your electrode assignment in part (a) produces a positive (spontaneous) cell potential.",
    [("electrode_assignment", "Correctly identifies Fe3+/Fe2+ as the cathode (higher reduction potential, more favorable to be reduced) and Sn4+/Sn2+ as the anode (oxidized)", 1),
     ("overall_reaction", "Correctly writes 2 Fe3+(aq) + Sn2+(aq) -> 2 Fe2+(aq) + Sn4+(aq), balancing 2 electrons on each side", 1),
     ("cell_potential_and_confirmation", "Correctly calculates E-cell-standard = 0.77-0.15 = 0.62 V and confirms this positive value matches the spontaneous electrode assignment from part (a)", 1)],
    "(a) Fe3+/Fe2+ has the higher (more positive) standard reduction potential, meaning Fe3+ has a stronger tendency to be reduced than Sn4+ does; therefore Fe3+/Fe2+ serves as the cathode (reduction) and Sn4+/Sn2+ serves as the anode (oxidation, running in reverse of its reduction potential). (b) The Fe3+/Fe2+ half-reaction transfers 1 electron, while Sn4+/Sn2+ transfers 2 electrons; to balance electrons, the iron half-reaction must be multiplied by 2: 2 Fe3+(aq) + 2e- -> 2 Fe2+(aq), combined with Sn2+(aq) -> Sn4+(aq) + 2e-, giving overall: 2 Fe3+(aq) + Sn2+(aq) -> 2 Fe2+(aq) + Sn4+(aq). (c) E-cell-standard = E-cathode - E-anode = 0.77 - 0.15 = 0.62 V. This positive value confirms the reaction is spontaneous as written, consistent with assigning Fe3+/Fe2+ as the cathode (the couple with the higher reduction potential) in part (a).",
    ["Standard cell potential with unequal electron transfer"])

add(9, "Hard", "short", True,
    "For the reaction Zn(s) + Cu2+(aq) -> Zn2+(aq) + Cu(s), the concentration of Zn2+ is increased above standard conditions while all else remains standard. Using the Nernst equation, predict and justify whether E-cell will be greater than, less than, or equal to E-cell-standard.",
    [("prediction_and_justification", "Correctly predicts E-cell will be less than E-cell-standard because increasing [Zn2+] (a product) increases Q, and E-cell = E-standard - (RT/nF)ln(Q) decreases as Q increases", 1)],
    "E-cell will be less than E-cell-standard. Increasing [Zn2+], a product of the reaction, increases the reaction quotient Q = [Zn2+]/[Cu2+]. According to the Nernst equation, E-cell = E-cell-standard - (RT/nF)ln(Q); as Q increases above 1, the ln(Q) term becomes more positive, so a larger amount is subtracted from E-cell-standard, making E-cell smaller (less than E-cell-standard).",
    ["Nernst equation: qualitative concentration effect"])

add(9, "Hard", "long", True,
    "A concentration cell is built using two Cu/Cu2+ half-cells: one with [Cu2+] = 1.00 M (the standard reference half-cell) and one with [Cu2+] = 1.00 x 10^-4 M. (a) Explain why E-cell-standard for this cell is 0 V, even though the two half-cells contain the same species. (b) Using the Nernst equation (n=2 for Cu2+/Cu), calculate the actual cell potential generated by this concentration difference at 298 K, showing your work. (E = E-standard - (0.0592/n)log(Q) at 298 K) (c) Identify which half-cell serves as the cathode and which serves as the anode, explaining your reasoning in terms of the direction the concentration difference drives spontaneous change.",
    [("standard_potential_explanation", "Explains E-cell-standard is 0 V because both half-cells involve the identical Cu2+/Cu couple, so E-cathode-standard - E-anode-standard = 0 for identical species", 1),
     ("nernst_calculation", "Correctly sets up Q = [dilute]/[concentrated] and calculates E-cell approximately 0.118 V using the Nernst equation", 1),
     ("electrode_identification", "Correctly identifies the concentrated (1.00 M) half-cell as the cathode (reduction, Cu2+ being consumed to lower its concentration) and the dilute half-cell as the anode (oxidation, Cu2+ being produced to raise its concentration), driving the system toward equalized concentrations", 1)],
    "(a) E-cell-standard is 0 V because both half-cells involve the exact same redox couple (Cu2+/Cu) with the exact same standard reduction potential; E-cell-standard = E-cathode-standard - E-anode-standard = E-standard(Cu2+/Cu) - E-standard(Cu2+/Cu) = 0. (b) The spontaneous direction is for the concentrated half-cell to have Cu2+ reduced (consumed) and the dilute half-cell to have Cu2+ produced (Cu oxidized), moving the system toward equal concentrations. Treating the concentrated cell as cathode and dilute as anode, Q = [Cu2+]dilute-after/[Cu2+]concentrated-after is approximated using the initial concentrations: Q = [Cu2+]anode/[Cu2+]cathode = (1.00e-4)/(1.00) = 1.00e-4. E-cell = E-standard - (0.0592/n)log(Q) = 0 - (0.0592/2)log(1.00e-4) = 0 - (0.0296)(-4.00) = 0.118 V. (c) The 1.00 M (concentrated) half-cell serves as the cathode, where Cu2+ is reduced to Cu, consuming Cu2+ and lowering its concentration; the 1.00 x 10^-4 M (dilute) half-cell serves as the anode, where Cu is oxidized to Cu2+, producing Cu2+ and raising its concentration. This direction is spontaneous because it drives the system toward equalizing the Cu2+ concentration between the two half-cells, which is the underlying thermodynamic driving force of any concentration cell.",
    ["Concentration cells and the Nernst equation"])

add(9, "Very Hard", "short", True,
    "A galvanic cell has E-cell-standard = +0.46 V and n = 2. Calculate the equilibrium constant K for this reaction at 298 K, showing your work. (Use ln(K) = nFE-standard/RT, with R = 8.314 J/(mol K) and F = 96,485 C/mol)",
    [("calculation", "Correctly calculates ln(K) = 35.8 and K = 3.4 x 10^15 (or equivalent order of magnitude)", 1)],
    "ln(K) = nFE-standard/RT = (2)(96,485)(0.46) / (8.314 x 298) = 88,766 / 2477.6 = 35.8. K = e^35.8, which is approximately 3.4 x 10^15, an extremely large equilibrium constant consistent with a strongly spontaneous, essentially complete reaction.",
    ["Equilibrium constant from standard cell potential"])

add(9, "Very Hard", "long", True,
    "Standard reduction potentials: E-standard(MnO4-/Mn2+, acidic) = +1.51 V, E-standard(Cr2O7^2-/Cr3+, acidic) = +1.33 V, E-standard(Fe3+/Fe2+) = +0.77 V. (a) Rank these three species (MnO4-, Cr2O7^2-, Fe3+) from strongest to weakest oxidizing agent, and justify your ranking. (b) Predict whether MnO4- can spontaneously oxidize Cr3+ to Cr2O7^2- under standard conditions, and justify your prediction using the relevant half-cell potentials. (c) Calculate delta-G-standard for the spontaneous reaction between MnO4- and Fe2+ (5 Fe2+ are oxidized per MnO4- reduced, so n = 5 electrons transferred overall), showing your work. (F = 96,485 C/mol)",
    [("oxidizing_agent_ranking", "Correctly ranks MnO4- > Cr2O7^2- > Fe3+ by decreasing standard reduction potential", 1),
     ("cr_oxidation_prediction", "Correctly predicts MnO4- can oxidize Cr3+ to Cr2O7^2-, since E-cell-standard = 1.51-1.33 = +0.18 V is positive (spontaneous)", 1),
     ("delta_g_calc", "Correctly calculates E-cell-standard = 1.51-0.77 = 0.74 V, then delta-G-standard = -nFE = -(5)(96,485)(0.74) = -357 kJ", 1)],
    "(a) Strongest to weakest oxidizing agent: MnO4- (1.51 V) > Cr2O7^2- (1.33 V) > Fe3+ (0.77 V). A more positive standard reduction potential indicates a stronger tendency to be reduced (to gain electrons), which is the definition of a stronger oxidizing agent; ranking by decreasing reduction potential gives this order. (b) Yes, MnO4- can spontaneously oxidize Cr3+ to Cr2O7^2- under standard conditions. Using MnO4-/Mn2+ as the cathode (reduction, higher potential) and Cr2O7^2-/Cr3+ run in reverse as the anode (oxidation of Cr3+ to Cr2O7^2-): E-cell-standard = E-cathode - E-anode = 1.51 - 1.33 = +0.18 V, a positive value indicating the reaction is spontaneous as proposed. (c) For MnO4- oxidizing Fe2+, using MnO4-/Mn2+ as cathode and Fe3+/Fe2+ run in reverse as anode: E-cell-standard = 1.51 - 0.77 = 0.74 V. With n = 5 electrons transferred overall (5 Fe2+ oxidized per MnO4- reduced, balancing the 5-electron reduction of Mn from +7 to +2): delta-G-standard = -nFE-cell-standard = -(5)(96,485 C/mol)(0.74 V) = -357,000 J, approximately -357 kJ.",
    ["Multi-species oxidizing agent ranking and Gibbs free energy"])

# ---------------------------------------------------------------------------
# HDR refinement: not every FRQ needs shown/drawn work. Items below are pure
# conceptual explanations (no calculation, no equation/structure to write out,
# no diagram to annotate) and are downgraded from the default hdr=True.
# Indices refer to authoring order in ITEMS above (0-based).
# ---------------------------------------------------------------------------
HDR_FALSE_INDICES = {2, 5, 10, 12, 14, 18, 22, 24, 32, 48, 69, 72, 78, 83, 96}
for _idx in HDR_FALSE_INDICES:
    ITEMS[_idx]["hdr"] = False

if __name__ == "__main__":
    from collections import Counter
    print("total items:", len(ITEMS))
    print("hdr true:", sum(1 for i in ITEMS if i["hdr"]))
    print("hdr false:", sum(1 for i in ITEMS if not i["hdr"]))

# ---------------------------------------------------------------------------
# Synthetic response generation
# ---------------------------------------------------------------------------
# Method (disclosed in README): fully_correct responses are hand-authored
# canonical answers. All other variants are DERIVED from the canonical answer
# by truncation at natural (a)/(b)/(c) part boundaries (long) or sentence
# boundaries (short) -- they represent realistic "ran out of time" /
# "incomplete response" failure modes, not independently reasoned wrong
# answers. This avoids ever asserting a fabricated incorrect chemistry claim.

import re

def split_parts(text):
    parts = re.split(r'(?=\([a-f]\)\s)', text)
    parts = [p.strip() for p in parts if p.strip()]
    return parts

def split_sentences(text):
    # naive sentence splitter good enough for these generated paragraphs
    sentences = re.split(r'(?<=[.!?])\s+', text)
    return [s for s in sentences if s.strip()]

def make_short_responses(canonical):
    sentences = split_sentences(canonical)
    if len(sentences) <= 1:
        incorrect = sentences[0].split(",")[0].strip()
        if not incorrect.endswith((".", "!", "?")):
            incorrect += "."
    else:
        keep = max(1, int(len(sentences) * 0.4))
        incorrect = " ".join(sentences[:keep])
    return [
        {"type": "fully_correct", "student_response": canonical},
        {"type": "incorrect", "student_response": incorrect},
    ]

def make_long_responses(canonical):
    parts = split_parts(canonical)
    if len(parts) < 2:
        # no (a)/(b)/(c) structure detected; fall back to sentence split in thirds
        sentences = split_sentences(canonical)
        n = len(sentences)
        thirds = max(1, n // 3)
        parts = [
            " ".join(sentences[:thirds]),
            " ".join(sentences[thirds:2 * thirds]),
            " ".join(sentences[2 * thirds:]),
        ]
        parts = [p for p in parts if p.strip()]
    n = len(parts)
    borderline_n = max(1, n - 1)
    partial_n = max(1, (n + 1) // 2)
    wrong_n = 1
    return [
        {"type": "fully_correct", "student_response": canonical},
        {"type": "borderline", "student_response": " ".join(parts[:borderline_n])},
        {"type": "partially_correct", "student_response": " ".join(parts[:partial_n])},
        {"type": "subtly_wrong", "student_response": " ".join(parts[:wrong_n])},
    ]

# ---------------------------------------------------------------------------
# Content key assignment + full record assembly
# ---------------------------------------------------------------------------
short_counter = 0
long_counter = 0
RECORDS = []
for item in ITEMS:
    if item["form"] == "short":
        short_counter += 1
        content_key = f"APCHEM-FRQ-S-{short_counter:03d}"
        responses = make_short_responses(item["canonical"])
    else:
        long_counter += 1
        content_key = f"APCHEM-FRQ-L-{long_counter:03d}"
        responses = make_long_responses(item["canonical"])

    rubric = [
        {"criterion_key": k, "learner_facing_text": t, "points_possible": p}
        for (k, t, p) in item["rubric"]
    ]

    record = {
        "content_key": content_key,
        "subject": "AP Chemistry",
        "item_type": "frq",
        "modules": [str(item["module"])],
        "subtopics": item["subtopics"],
        "intended_difficulty": item["difficulty"],
        "frq_form": item["form"],
        "hdr": item["hdr"],
        "question_text": item["question_text"],
        "rubric": rubric,
        "codex": {
            "question_type": "frq",
            "frq_form": item["form"],
            "frq_subtype": "standard_response",
            "tags": ["ap_chemistry"] + (["hdr"] if item["hdr"] else []),
        },
        "synthetic_responses": responses,
    }
    if item["hdr"]:
        record["trace_image"] = f"images/{content_key}.png"
    RECORDS.append(record)

print(f"Assembled {len(RECORDS)} records ({short_counter} short, {long_counter} long).")

# ---------------------------------------------------------------------------
# Trace-image generation (SYNTHETIC, stylized -- not real scanned handwriting)
# ---------------------------------------------------------------------------
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm

def wrap_lines(text, width=58):
    return textwrap.wrap(text, width=width) or [""]

def render_trace_image(record, out_path):
    canonical = record["synthetic_responses"][0]["student_response"]
    lines = wrap_lines(canonical, width=56)
    max_lines = 26
    truncated = len(lines) > max_lines
    lines = lines[:max_lines]
    if truncated:
        lines.append("[work continues...]")

    fig_h = max(4.0, 0.34 * len(lines) + 1.6)
    with plt.xkcd(scale=1, length=100, randomness=2):
        fig, ax = plt.subplots(figsize=(6.5, fig_h), dpi=130)
        ax.set_xlim(0, 10)
        ax.set_ylim(0, fig_h * 10 / 6.5)
        ax.axis("off")
        # notebook-paper look: faint horizontal rules + a left margin line
        top = ax.get_ylim()[1]
        for y in [i * 0.5 for i in range(1, int(top / 0.5))]:
            ax.plot([0.3, 9.7], [y, y], color="#b9d3e6", linewidth=0.6, zorder=0)
        ax.plot([1.0, 1.0], [0.2, top - 0.2], color="#e2a1a1", linewidth=0.8, zorder=0)

        ax.text(0.45, top - 0.35, record["content_key"], fontsize=9,
                 family="monospace", color="#444444")
        y = top - 0.9
        for line in lines:
            ax.text(1.15, y, line, fontsize=10.5, family="cursive")
            y -= 0.42
        fig.patch.set_facecolor("#fffdf7")
        ax.set_facecolor("#fffdf7")
        fig.tight_layout(pad=0.4)
        fig.savefig(out_path, facecolor=fig.get_facecolor())
        plt.close(fig)

hdr_records = [r for r in RECORDS if r["hdr"]]
print(f"Rendering {len(hdr_records)} trace images...")
for i, rec in enumerate(hdr_records):
    out_path = os.path.join(IMG_DIR, f"{rec['content_key']}.png")
    render_trace_image(rec, out_path)
    if (i + 1) % 20 == 0:
        print(f"  {i + 1}/{len(hdr_records)} rendered")
print("Done rendering trace images.")

# ---------------------------------------------------------------------------
# Write corpus JSON
# ---------------------------------------------------------------------------
from collections import Counter

metadata = {
    "task_id": "TASK-0014-FRQ-GRADING-EXPERIMENT",
    "dataset_version": "ap_chemistry_frq_v1_2026_07_07",
    "subject": "ap-chemistry",
    "total_count": len(RECORDS),
    "created_date": "2026-07-07",
    "note": "Development test corpus for grading-pipeline experiments; not a governed pilot batch or human gold set.",
    "sourcing": "Authored from general chemistry curriculum knowledge only; no College Board material used as input.",
    "format_distribution": dict(Counter(r["frq_form"] for r in RECORDS)),
    "difficulty_distribution": dict(Counter(r["intended_difficulty"] for r in RECORDS)),
    "module_distribution": dict(Counter(r["modules"][0] for r in RECORDS)),
    "hdr_count": sum(1 for r in RECORDS if r["hdr"]),
    "trace_images_generated": len(hdr_records),
    "trace_image_method": "SYNTHETIC matplotlib xkcd-style stylized rendering, not a real scanned handwritten response.",
    "response_generation_method": "fully_correct responses are hand-authored; all other variants are derived by disclosed truncation at (a)/(b)/(c) part boundaries or sentence boundaries -- see README.",
}

corpus = {"metadata": metadata, "items": RECORDS}

out_json = os.path.join(OUT_DIR, "ap_chemistry_frq_grading_experiment_batch_2026_07_07.json")
with open(out_json, "w") as f:
    json.dump(corpus, f, indent=2)

print(f"Wrote {out_json}")
print(json.dumps(metadata, indent=2))
