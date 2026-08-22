begin;

-- Repair AP Chemistry Unit 3 (Properties of Substances and Mixtures) Learn
-- More explainers -- all 11 were template-generated debt (core_idea
-- verbatim-matching their brief's what_it_is, and mini_example_question /
-- weak_answer sharing the same boilerplate duplicated across ~150 other rows
-- corpus-wide, per the 2026-08-21 bulk audit). Confirmed via SQL before
-- authoring (Step 0): all 11 rows (3.1-3.11) carried source_note
-- 'generated-from-brief:legacy; grandfathered-2026-08-21', and a direct read
-- of the current rows showed core_idea byte-identical to the paired brief's
-- what_it_is on every row, plus the exact boilerplate weak_answer ("I would
-- do the calculation or name the trend and move on.") and
-- mini_example_question (title-interpolation template) on every row -- so
-- all 11 are genuine debt; none were an outlier that already had
-- hand-authored content. This is also the largest MCQ domain on the AP
-- Chemistry exam (18-22%), so extra care was taken verifying every
-- chemistry fact and computed number below. Briefs for this unit are
-- genuinely hand-authored and correct; NOT touched here (app.topic_point_briefs
-- was not written to by this migration).
--
-- Grounded in docs/product/AP_CHEMISTRY_CED_FACT_PACK.md Unit 3 section
-- (starting line 358): 3.1's caution that "London dispersion forces" is not
-- synonymous with "van der Waals forces," and the four-force hierarchy
-- (London / dipole-dipole additive to London / ion-dipole / hydrogen
-- bonding to N-O-F), applied to a real CH4/CH3Cl/CH3OH boiling-point
-- comparison (-161.5C/-24.2C/64.7C against molar masses 16/50/32 g/mol);
-- 3.2's vapor-pressure-tracks-IMF-directly-but-melting-point-only-loosely
-- distinction and the documented graphite exception (soft despite being a
-- covalent network, because interlayer bonding is only London dispersion),
-- applied to a diamond-vs-graphite hardness contrast; 3.3's crystalline-
-- vs-amorphous distinction, the solid/liquid-molar-volume-similarity fact,
-- and the verbatim phase-diagram exclusion statement, applied to real
-- water molar-volume data (~18 mL/mol liquid, ~19.6 mL/mol ice, ~22,400
-- mL/mol vapor); 3.4's PV=nRT plus partial-pressure/mole-fraction equations
-- (P_A = P_total x X_A, P_total = sum of P_i), applied to a real two-gas
-- mixture calculation (0.50 mol N2 + 0.20 mol O2, 10.0 L, 300 K) verified
-- independently during authoring; 3.5's KE=1/2mv^2 equation and the
-- Kelvin-proportional-to-average-KE-not-average-speed fact, applied to a
-- He-vs-Xe same-temperature comparison; 3.6's two distinct real-gas
-- deviation mechanisms (attraction at low T, particle volume at high P)
-- and the fact that these conditions cause the *largest* deviation from
-- ideal, not the smallest; 3.7's homogeneous/heterogeneous distinction and
-- M = n_solute/L_solution equation, applied to a real 0.250 mol NaCl / 500
-- mL molarity calculation with an added solvent-vs-solution-volume
-- contrast; 3.8's two verbatim exclusion statements (colligative
-- properties; molality/percent-by-mass/percent-by-volume calculations),
-- applied to a particle-density-normalization worked example (8
-- particles/area A vs 12 particles/area 2A); 3.9's filtration-cannot-
-- separate-dissolved-solute fact and the differential-interaction-strength
-- explanation of chromatography, applied to a two-dye paper-chromatography
-- polarity-inference example; 3.10's like-dissolves-like-via-IMF-matching
-- fact, applied to a real I2-in-water-vs-I2-in-hexane solubility contrast;
-- and 3.11's microwave/infrared/UV-visible-to-rotational/vibrational/
-- electronic transition-type mapping, applied to a carbonyl C=O infrared-
-- stretch example that directly rebuts the electronic-transition
-- misconception. All computed/cited numbers (boiling points, molar masses,
-- molar volumes, gas-law arithmetic, mole fractions and partial pressures,
-- molarity, and particle-density ratios) were independently verified
-- during authoring.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Chemistry Unit 3); the
-- pre-repair content is fully recoverable from git history for this
-- table's rows if a rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4
-- ("the same topic-specific answer_move" / "the same or refined
-- common_point_loss") -- the Unit 3 briefs already carry specific, correct,
-- non-templated point-earning language, so no refinement was needed.
-- mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge are original per-row text that was checked corpus-wide
-- before this migration was written and repeats nowhere else in the
-- published corpus (zero collisions found).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('3.1',
   'The forces rank, roughly weakest to strongest: London dispersion (present in every particle, arising from temporary/fluctuating dipoles, and often the strongest net IMF between very large molecules), dipole-dipole (acts in addition to London forces in polar molecules), ion-dipole (ions with polar molecules), and hydrogen bonding (H covalently bonded to N, O, or F attracted to a nearby N/O/F). The CED explicitly cautions that "London dispersion forces" should not be used synonymously with "van der Waals forces" -- don''t conflate the two terms when naming which force is present.',
   'This ranking reappears as the mechanism behind solid classification in 3.2 and solubility/miscibility prediction in 3.10, and it is where the single lowest-scoring point on the entire 2025 exam (mean 0.11/1.0) originated -- students read "r" in Coulomb''s law as an ion''s own radius instead of the interparticle separation between the ion and a nearby dipole.',
   'Points require naming the strongest relevant force present and justifying it from specific structural evidence -- polarity from electronegativity or molecular geometry, particle size/polarizability, ionic charge, or an actual N-O-F-to-H bonding arrangement -- rather than a generic "intermolecular forces" label.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then identify the strongest relevant interaction and justify it from polarity, size, charge, or hydrogen-bonding requirements before doing arithmetic or writing the final sentence.',
   'Methane (CH4), chloromethane (CH3Cl), and methanol (CH3OH) have boiling points of -161.5C, -24.2C, and 64.7C respectively, despite having similar molar masses (16, 50, 32 g/mol). Rank the strongest intermolecular force present in each and explain the boiling-point trend.',
   'Chloromethane has more mass than methane so it boils higher, and methanol has an OH group so it boils higher too.',
   'Methane is nonpolar (symmetric tetrahedral shape, effectively nonpolar C-H bonds), so London dispersion is its only IMF, giving the lowest boiling point of the three. Chloromethane has a permanent dipole (polar C-Cl bond, asymmetric shape), so dipole-dipole forces act in addition to London dispersion, raising its boiling point above methane''s. Methanol has an O-H bond, so hydrogen bonding -- the strongest of the three force types here -- acts in addition to dipole-dipole and London forces, giving methanol the highest boiling point of the three even though its molar mass (32) is lower than chloromethane''s (50). Molar mass alone does not predict the order here; the strongest IMF type present does.',
   'Using hydrogen bonding for any molecule containing hydrogen, even when H is not bonded to N, O, or F',
   'Back in practice, before ranking any boiling-point or IMF-strength question, name the IMF type first from structure (polarity, H-bonded-to-N/O/F, ion presence) -- never default to molar mass as the deciding factor.'),
  ('3.2',
   'Vapor pressure and boiling point track IMF strength directly, since vaporization requires fully overcoming the IMFs holding particles together -- but melting point tracks IMF strength only loosely, since melting just rearranges particles rather than separating them completely. Covalent network solids are usually rigid and high-melting, but graphite is the documented exception: covalently bonded within each layer, yet soft and slippery because the layers themselves are held together only by weak London dispersion forces and can slide past each other.',
   'This connects the IMF ranking from 3.1 to bulk solid behavior, and the graphite exception specifically tests whether structure-level reasoning is applied rather than a blanket "covalent network equals hard" rule.',
   'Points require classifying the solid type and explaining a specific property (melting point, conductivity, brittleness, or malleability) from particle-level structure, not from the class name alone.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then classify the solid type and explain melting point, conductivity, brittleness, or malleability from its particle-level structure before doing arithmetic or writing the final sentence.',
   'Diamond and graphite are both covalent network solids made entirely of carbon, yet diamond is one of the hardest known materials while graphite is soft enough to leave marks on paper. Explain the difference using particle-level structure.',
   'Both are covalent network solids with covalent bonds throughout, so they should have the same hardness.',
   'Diamond is a fully 3-D covalent network -- every carbon is covalently bonded to four neighbors in a rigid, interconnected lattice, so no layer can move without breaking strong covalent bonds, making it extremely hard. Graphite is a layered covalent network -- each carbon is covalently bonded to only three neighbors within a flat sheet, but the sheets themselves are held together by weak London dispersion forces, not covalent bonds. Those weak interlayer forces let sheets slide past each other easily, which is why graphite is soft despite having strong covalent bonds within each layer. Classifying both as "covalent network" is correct but incomplete -- the property depends on which bonds would have to break to deform the solid.',
   'Calling an ionic solid conductive as a solid, when its ions are fixed in the lattice',
   'Return to practice and, for every covalent network solid, check whether the structure is a fully 3-D lattice or a layered one before predicting hardness -- "covalent network" alone doesn''t guarantee rigidity.'),
  ('3.3',
   'Solids can be crystalline (a regular, repeating 3-D particle arrangement) or amorphous (irregular, no long-range order) -- both are still solids by the spacing/motion criteria that define the phase. Solid and liquid molar volumes are typically similar to each other, because particles are in close contact in both phases; it is the gas phase, where particles are far apart and move independently, that differs sharply in molar volume. The AP Exam explicitly does not assess reading or interpreting phase diagrams.',
   'This sets up the particle-spacing/motion vocabulary reused in 3.2''s solid-structure reasoning and 3.5''s gas-particle-motion reasoning; the phase-diagram exclusion means only structural description, not phase-diagram feature-reading, is testable here.',
   'Points require comparing particle spacing, motion, and order using specific descriptive language for each phase, without invoking phase-diagram features like triple points or critical points.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then compare particle spacing, motion, and order across phases while avoiding phase-diagram interpretation before doing arithmetic or writing the final sentence.',
   'The molar volume of liquid water at 25C is about 18 mL/mol, and the molar volume of ice at 0C is about 19.6 mL/mol -- both far smaller than the molar volume of water vapor at standard conditions, which is about 22,400 mL/mol. Explain this pattern in terms of particle spacing and motion, without referencing a phase diagram.',
   'Water vapor takes up more room because gases are less dense than liquids or solids.',
   'In both the solid and liquid phases, water molecules remain in close contact with their neighbors -- held together by hydrogen bonding and other IMFs -- so their molar volumes stay in the same narrow range (about 18-20 mL/mol) regardless of whether the arrangement is the ordered lattice of ice or the more disordered, still-close-packed liquid. In the gas phase, molecules move independently with large separations between them and no fixed spacing or order, so the same number of moles occupies a volume roughly a thousand times larger. The large volume jump reflects a change in particle spacing and motion between the condensed phases and the gas phase, not a phase-diagram feature like a triple point.',
   'Explaining a phase using only shape and volume instead of particle motion and spacing',
   'Head back to practice and, on every solid/liquid/gas comparison, describe spacing, motion, and order explicitly for each phase -- and never reach for phase-diagram vocabulary, since that''s outside what the exam assesses here.'),
  ('3.4',
   'PV = nRT is the core relationship, but multi-gas mixture problems add two more: partial pressure is proportional to mole fraction (P_A = P_total x X_A, where X_A = mol_A / mol_total), and Dalton''s law says total pressure is the sum of all partial pressures (P_total = P_A + P_B + P_C + ...). Because R''s units (0.08206 L*atm/(mol*K)) fix P in atm, V in L, and T in Kelvin, every quantity must be converted into those units before using the constant -- Celsius or torr silently break the calculation even when the setup is otherwise correct.',
   'This is the algebra/unit-consistency workhorse of Unit 3, and connects to 3.7''s molarity (same solution-total-volume discipline) and 3.5''s KMT (which explains why T must be absolute).',
   'Points require choosing the correct equation (PV=nRT versus Dalton''s/mole-fraction), converting every unit into the set matching R, and connecting partial pressure to mole fraction explicitly rather than guessing a fraction.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then choose PV=nRT or Dalton''s law, convert units consistently, and relate partial pressure to mole fraction before doing arithmetic or writing the final sentence.',
   'A rigid 10.0 L container at 300 K holds 0.50 mol N2 and 0.20 mol O2. Find the total pressure and each gas''s partial pressure.',
   'Total moles are 0.70, so I''ll just plug that into PV=nRT using 300 as the temperature -- wait, actually I''d use 27 (the Celsius value) since that''s what was probably meant.',
   'Total moles = 0.50 + 0.20 = 0.70 mol. Using PV = nRT with T already in Kelvin (300 K, no conversion needed) and R = 0.08206 L*atm/(mol*K): P_total = nRT/V = (0.70)(0.08206)(300)/10.0 = 1.72 atm. Mole fractions: X_N2 = 0.50/0.70 = 0.714, X_O2 = 0.20/0.70 = 0.286. Partial pressures: P_N2 = X_N2 x P_total = 0.714 x 1.72 = 1.23 atm; P_O2 = 0.286 x 1.72 = 0.49 atm. Check: 1.23 + 0.49 = 1.72 atm, matching P_total by Dalton''s law.',
   'Using Celsius in PV=nRT or mixing pressure units with the wrong gas constant',
   'Go back to practice and, before touching PV=nRT on any item, write T in Kelvin and confirm every other unit matches your R value -- do this as its own step, before any arithmetic.'),
  ('3.5',
   'KE = 1/2 m v^2 relates a single particle''s kinetic energy to its mass and speed, and Kelvin temperature is directly proportional to the average kinetic energy of all particles in a sample -- not to their average speed. Because KE depends on both mass and speed, two gases at the same temperature (same average KE) must have different average speeds if their molar masses differ: the lighter gas moves faster on average to reach that same average KE. The Maxwell-Boltzmann distribution shows this as a speed-vs-fraction-of-particles curve that broadens and shifts to higher speeds as temperature rises.',
   'This same-average-KE-different-average-speed distinction is the single most commonly missed idea in this topic, and it directly explains effusion/diffusion rate differences tested elsewhere.',
   'Points require connecting Kelvin temperature specifically to average kinetic energy (never average speed) and using the mass-speed tradeoff to compare distributions between different gases at the same temperature.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then connect Kelvin temperature to average kinetic energy and use Maxwell-Boltzmann curves to compare particle-speed distributions before doing arithmetic or writing the final sentence.',
   'Helium (molar mass 4.00 g/mol) and xenon (molar mass 131.3 g/mol) gas samples are both at 300 K. Compare their average kinetic energy and their average particle speed.',
   'Xenon atoms are much heavier, so they have greater average kinetic energy than helium atoms at the same temperature.',
   'Average kinetic energy depends only on temperature, not on identity or mass -- so at the same 300 K, helium and xenon particles have identical average kinetic energy. Because KE = 1/2 m v^2 and the two gases share the same average KE but have very different masses, their average speeds must differ: helium''s much smaller mass means its particles must move much faster, on average, than xenon''s to reach that same KE. On a Maxwell-Boltzmann speed distribution, helium''s curve would be shifted to substantially higher speeds and be broader than xenon''s, even though both curves represent gas at the same 300 K.',
   'Saying heavier gas particles have greater average kinetic energy at the same temperature',
   'Return to practice and, on every KMT comparison between two gases, state "same temperature, same average KE" as a fixed fact first -- then reason about speed differences from mass second, never the reverse.'),
  ('3.6',
   'Real gases deviate from ideal behavior for two distinct reasons that dominate under different conditions: at low temperature (particles moving slowly, near condensation), interparticle attractions pull particles together enough that measured pressure comes out lower than the ideal gas law predicts; at very high pressure (particles forced close together), the particles'' own volume becomes a significant fraction of the container''s volume, so available free space is less than the ideal law assumes. Both effects mean real-gas behavior deviates most -- not least -- from ideal under low-temperature, high-pressure conditions.',
   'This directly follows from 3.1''s IMF strength and 3.5''s particle motion/KMT, and it tests whether the student can name which of the two mechanisms applies under which condition, rather than treating "high pressure, low temperature" as one vague deviation trigger.',
   'Points require identifying which mechanism (attraction versus particle volume) applies to the given condition, and correctly stating that these conditions cause the largest deviation from ideal, not the smallest.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then explain real-gas deviations from attractions at low temperature or particle volume at high pressure before doing arithmetic or writing the final sentence.',
   'A real gas is compressed to very high pressure at room temperature, and separately a real gas is cooled to near its condensation point at moderate pressure. Explain why each scenario causes real-gas pressure or volume to deviate from what the ideal gas law predicts, and in which direction.',
   'Gases behave most ideally at high pressure and low temperature since those are extreme, controlled conditions.',
   'These are actually the conditions where real gases deviate most from ideal, not least. Near condensation (low temperature), particles move slowly enough that interparticle attractive forces have time to act, pulling particles toward each other and reducing the force of their collisions with the container walls -- so the measured pressure is lower than PV=nRT predicts. At very high pressure, particles are forced close together, and their own finite volume (which the ideal gas law assumes is negligible) becomes a real fraction of the total volume, leaving less free space than the ideal model assumes. These are two separate mechanisms -- one from attraction, one from particle volume -- and both make a gas behave less ideally, not more, under these conditions.',
   'Treating all gases as most ideal at high pressure and low temperature',
   'Head to practice and, on every real-gas-deviation item, name which mechanism applies -- attraction at low T, particle volume at high P -- and state explicitly that the deviation is largest, not smallest, under those conditions.'),
  ('3.7',
   'A solution is a homogeneous mixture -- its macroscopic properties (concentration, color, density) are uniform throughout, no matter where you sample it -- which distinguishes it from a heterogeneous mixture, where properties vary by location. Solutions aren''t limited to liquids: solid solutions (like some alloys) and gas solutions (like air) both qualify, as long as homogeneity holds. Molarity is defined as moles of solute per liter of final solution (M = n_solute / L_solution), not per liter of solvent added before mixing.',
   'Molarity''s solution-volume (not solvent-volume) discipline directly parallels the unit-consistency care needed for 3.4''s gas law, and homogeneous/heterogeneous classification underlies 3.9''s separation-method reasoning.',
   'Points require correctly classifying a mixture as homogeneous or heterogeneous with justification, and computing molarity using the total solution volume, not the volume of solvent added.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then distinguish homogeneous from heterogeneous mixtures and calculate molarity from moles of solute per liter of solution before doing arithmetic or writing the final sentence.',
   'A chemist dissolves 0.250 mol of NaCl in enough water to make 500. mL of final solution. What is the molarity? If a colleague instead measured out exactly 500. mL of water first and then added the NaCl to it, would their calculated molarity be different, and why?',
   'M = 0.250 mol / 0.500 L = 0.500 M either way, since 500 mL of water plus the NaCl is basically 500 mL of solution.',
   'For the correctly made solution, M = n_solute / L_solution = 0.250 mol / 0.500 L = 0.500 M. But if the colleague measured 500. mL of water first and then dissolved NaCl into it, the final solution volume would be slightly more than 500 mL (since the dissolving solid adds volume), making the true solute-per-liter-of-solution ratio slightly lower than 0.500 M. Molarity must always be calculated using the volume of the final solution after mixing, not the volume of solvent measured out beforehand -- treating them as interchangeable introduces a real, if small, error.',
   'Using liters of solvent instead of liters of final solution for molarity',
   'Back to practice and, on every molarity problem, confirm whether the given volume is the solvent volume or the final solution volume before dividing -- they are not the same number.'),
  ('3.8',
   'Particulate diagrams represent solutions by drawing relative numbers and spacing of solute and solvent particles inside a defined boundary, letting you compare relative concentration or interaction type between two solutions -- but only if the boxes represent equal volumes, since a diagram with more particles in a larger box can represent the same or even lower concentration than fewer particles in a smaller box. Two things are explicitly off the AP Exam here: colligative properties (freezing-point depression, boiling-point elevation, etc.) and any molality, percent-by-mass, or percent-by-volume calculation.',
   'This topic tests visual/quantitative reasoning without the calculation tools (molality, colligative properties) that would normally support it, which is exactly why the equal-volume check matters so much.',
   'Points require comparing particle counts only after confirming box areas/volumes are equal (or explicitly normalizing for unequal ones), and never reaching for a molality or colligative-property calculation, since neither is assessable here.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then interpret particulate diagrams for relative concentration and solute-solvent interactions without using excluded colligative-property calculations before doing arithmetic or writing the final sentence.',
   'Diagram A shows 8 solute particles in a small square box. Diagram B shows 12 solute particles in a box with twice the area of Diagram A. Which diagram represents the more concentrated solution?',
   'Diagram B has more particles (12 vs 8), so Diagram B is more concentrated.',
   'Concentration depends on particles per unit volume (or area, in a 2-D representation), not on the raw particle count. Diagram A has 8 particles in area A, a density of 8/A. Diagram B has 12 particles in area 2A, a density of 12/(2A) = 6/A. Since 8/A is greater than 6/A, Diagram A actually represents the more concentrated solution, despite showing fewer total particles -- the raw count is misleading until it is divided by the box''s size.',
   'Counting drawn particles without checking whether the diagram represents equal volumes',
   'Return to practice and, before comparing any two particulate diagrams, check box size first -- normalize particle count by area or volume before calling one diagram more concentrated than the other.'),
  ('3.9',
   'Ordinary filtration only separates a solid from a liquid it is suspended in (a heterogeneous mixture) -- once a solute is truly dissolved, its particles are the same phase as the solvent and pass right through a filter, so filtration cannot separate a homogeneous solution into its components. Chromatography separates based on differential interaction strength instead: each component interacts differently with a stationary phase and a mobile phase, so components that interact more strongly with the mobile phase travel farther/faster, and the resulting chromatogram''s pattern of distances lets you infer each component''s relative polarity.',
   'This connects directly back to 3.1''s IMF vocabulary (chromatography separation is entirely an IMF-strength argument) and to 3.7''s homogeneous/heterogeneous distinction, which determines whether filtration is even a candidate method.',
   'Points require choosing the separation method based on which physical/chemical property actually differs between the components, and explaining chromatography specifically through differential interaction strength with the two phases, not through size or mass.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then choose a separation method by the property that differs, especially filtration versus chromatography by interaction strength, before doing arithmetic or writing the final sentence.',
   'In a paper chromatography experiment separating two dyes, Dye A travels much farther up the paper than Dye B when developed with a nonpolar solvent. The paper (stationary phase) is polar; the solvent (mobile phase) is nonpolar. Explain what this result indicates about Dye A and Dye B''s relative polarity.',
   'Dye A must have a smaller molar mass than Dye B, since it can travel farther and faster.',
   'Distance traveled in chromatography reflects differential interaction strength with the stationary versus mobile phase, not molar mass. Because the solvent (mobile phase) is nonpolar and the paper (stationary phase) is polar, a dye that travels farther is interacting more strongly with the nonpolar mobile phase relative to the polar stationary phase -- meaning Dye A is the less polar (more nonpolar) of the two dyes, since it partitions more into the nonpolar solvent and moves with it. Dye B, traveling less far, is interacting more strongly with the polar stationary paper, indicating it is the more polar dye. Filtration could not have separated these two dyes at all, since both are fully dissolved in the same liquid phase.',
   'Trying to separate dissolved solute from solution by ordinary filtration',
   'Go back to practice and, on every separation-method question, ask what specific property differs between the components first -- then match the method (filtration for phase difference, chromatography for interaction-strength/polarity difference) to that property.'),
  ('3.10',
   '"Like dissolves like" is shorthand for a real mechanism: a solute dissolves well in a solvent when the two have similar dominant intermolecular forces, because that similarity lets solvent particles surround and stabilize solute particles as effectively as the solute''s own particles were interacting with each other -- mismatched IMFs mean the solvent can''t replace the lost solute-solute (or gained solute-solvent) interactions favorably. This is the same IMF vocabulary from 3.1, applied to a mixing/miscibility question instead of a single-substance boiling-point question.',
   'This topic is graded specifically on naming the actual force match or mismatch, so restating the mnemonic without the underlying forces earns nothing.',
   'Points require predicting solubility/miscibility by explicitly naming the dominant IMF type in both solute and solvent and stating whether they match, rather than citing the "like dissolves like" phrase alone.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then predict solubility by comparing the intermolecular forces present in the solute and solvent before doing arithmetic or writing the final sentence.',
   'Iodine (I2, nonpolar) is only slightly soluble in water but dissolves readily in hexane (C6H14, nonpolar). Explain both observations using intermolecular forces.',
   'Like dissolves like, so iodine dissolves better in hexane than in water.',
   'Iodine is a nonpolar diatomic molecule, so its only intermolecular force is London dispersion. Water''s dominant intermolecular force is hydrogen bonding, which is much stronger than the London forces iodine can offer in return -- so mixing barely happens, since water molecules would rather hydrogen-bond with each other than surround a nonpolar I2 molecule, and iodine is only slightly soluble. Hexane, in contrast, is nonpolar and its only IMF is also London dispersion -- the same force type present in iodine -- so hexane molecules can replace iodine''s own London interactions just as effectively as iodine''s molecules interacted with each other, and iodine dissolves readily. The deciding factor is the matched or mismatched force type, not simply invoking "like dissolves like."',
   'Using the phrase like dissolves like without naming the actual force match or mismatch',
   'Return to practice and, on every solubility/miscibility question, name the dominant IMF in both substances explicitly before concluding soluble or insoluble -- the phrase alone earns nothing.'),
  ('3.11',
   'Different regions of the electromagnetic spectrum probe different types of transitions because they carry different amounts of energy: microwave radiation (lowest energy of the three) is absorbed by molecular rotational transitions, infrared radiation is absorbed by molecular vibrational transitions (like bond stretching and bending), and UV/visible radiation (highest energy of the three) is absorbed by electronic transitions, where an electron moves between energy levels. Because these energies are so different, an absorption in one region tells you specifically about that type of motion or transition -- not about the others.',
   'This maps directly onto the common point loss of treating every spectrum as electronic-transition evidence, and connects to 3.13''s Beer-Lambert law, typically applied in the UV/visible region for concentration measurements.',
   'Points require matching the spectral region given in the prompt to its correct transition type, and explicitly avoiding over-interpreting a non-UV/visible spectrum as electronic-structure evidence.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then match microwave, infrared, and UV-visible absorption to rotational, vibrational, and electronic transitions before doing arithmetic or writing the final sentence.',
   'A compound shows a strong absorption band in the infrared region at a wavenumber corresponding to a carbon-oxygen double bond stretch. A classmate claims this IR data proves something about the compound''s electronic energy levels. Evaluate the claim.',
   'The classmate is right -- any absorption band shows the compound is absorbing photons and moving electrons to higher energy levels.',
   'The classmate''s claim is incorrect. Infrared radiation carries enough energy to excite molecular vibrational transitions -- in this case, the stretching of the C=O bond -- but it does not carry enough energy to promote an electron between electronic energy levels; that requires the higher-energy UV/visible region. The IR absorption band tells you specifically about bond vibration (here, evidence of a carbonyl group), not about the compound''s electronic structure. To make a claim about electronic transitions, a UV/visible absorption spectrum would be needed instead.',
   'Treating every absorption spectrum as evidence for electron transitions',
   'Head back to practice and, on every spectroscopy item, match the stated region (microwave/IR/UV-visible) to its one correct transition type first -- never let any absorption band stand in as electronic-transition evidence unless the region given is actually UV/visible.')
)
update app.topic_explainers e
set
  core_idea = u.core_idea,
  what_students_need_to_understand = u.what_students_need_to_understand,
  how_this_becomes_points = u.how_this_becomes_points,
  answer_move = u.answer_move,
  mini_example_question = u.mini_example_question,
  weak_answer = u.weak_answer,
  point_attaining_answer = u.point_attaining_answer,
  common_point_loss = u.common_point_loss,
  practice_bridge = u.practice_bridge,
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 3 section (line 358): the London-dispersion-vs-van-der-Waals caution and four-force hierarchy for 3.1, verified against real CH4/CH3Cl/CH3OH boiling-point and molar-mass data; the vapor-pressure-tracks-IMF/melting-point-tracks-loosely distinction and documented graphite exception for 3.2; the crystalline/amorphous distinction, solid-liquid molar-volume-similarity fact, and verbatim phase-diagram exclusion for 3.3, verified against real water molar-volume data; the PV=nRT plus partial-pressure/mole-fraction equations for 3.4, verified against an independently checked two-gas mixture calculation; the KE=1/2mv^2 equation and Kelvin-proportional-to-average-KE-not-speed fact for 3.5; the two distinct real-gas deviation mechanisms (attraction at low T, particle volume at high P) for 3.6; the homogeneous/heterogeneous distinction and M=n/L equation for 3.7, verified against a real molarity calculation; the two verbatim colligative-property and molality/percent exclusion statements for 3.8, applied to a particle-density-normalization worked example; the filtration-cannot-separate-dissolved-solute fact and differential-interaction-strength explanation of chromatography for 3.9; the like-dissolves-like-via-IMF-matching fact for 3.10, verified against real I2 solubility behavior in water versus hexane; and the microwave/infrared/UV-visible-to-rotational/vibrational/electronic transition-type mapping for 3.11, applied to a carbonyl infrared-stretch example rebutting the electronic-transition misconception; briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-chemistry-unit3-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_chemistry'
  and e.unit_number = 3
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_chemistry' and unit_number=3 and status='published'
      and source_note like '%unit3-explainer-repair%';
  if v_repaired <> 11 then
    raise exception 'expected 11 repaired AP Chemistry Unit 3 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_chemistry' and b.unit_number=3 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 3 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
