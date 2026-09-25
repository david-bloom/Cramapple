-- Remediation batch 2 of the 34 P0 findings from PR #188
-- (docs/content/CODEX_QA_REPORT_CANONICAL_ANSWERS_CALC_AB_THROUGH_PHYSICS_1_2026_09_25.md).
--
-- 1. apcalcab-frq-005: frq_criteria's part-a-criterion-1 said "x²+xy+2y²=14" but the stimulus (and the
--    point (2,2), which satisfies 4+4+8=16) both say "=16". The stimulus is correct; the rubric text
--    was wrong. Corrected the rubric's stated constant to match.
--
-- 2. apchem-frq-l-002 (ozone resonance): canonical never assigned the requested formal charges (rubric
--    part-a explicitly asks for this). Rewrote with the actual FC derivation (+1 central, 0 on the
--    double-bonded terminal O, -1 on the single-bonded terminal O) and strengthened part (d)'s
--    resonance-hybrid explanation.
--
-- 3. apchem-frq-l-003 (nonideal gas): canonical omitted the explicit ideal-gas assumptions (rubric b1-
--    b3) and the requested Z-based experimental test (c1-c2); part (d) never stated an actual boundary
--    case. Rewrote all four parts.
--
-- 4. apchem-frq-l-004 (AgCl gravimetric): canonical omitted the explicit 1:1 stoichiometric
--    justification and complete-precipitation assumption rubric part-b requires. Rewrote part (b).
--
-- 5. apchem-frq-l-005 (rate law): canonical answered only part (a); parts (b)-(d) were entirely absent.
--    Separately, frq_criteria's b2 and d1 were word-for-word duplicate "rate law vs. mechanism"
--    criteria that neither stem part (b) nor part (d) actually asks about -- removed as spurious rather
--    than inventing unasked-for stem content to match them. Wrote parts (b)-(d).
--
-- 6. apchem-frq-l-006 (specific heat): canonical answered only part (a); parts (b)-(d) were entirely
--    absent. Wrote parts (b)-(d).
--
-- These five Chemistry items have no canonical_answer_spans (pre-existing segmentation debt, tracked
-- separately per docs/product/SUBJECT_SERVABILITY_CRITERIA.md and the QA report's Part B), so only
-- canonical_answer_1 needed updating -- no span concatenation/coverage check applies here.

begin;

update app.frq_criteria
set learner_facing_text = 'Differentiates each term of x²+xy+2y²=16 implicitly.'
where content_item_version_id = '4069df3a-e60c-4608-9e65-24a920e64b27' and criterion_key = 'part-a-criterion-1';

update app.content_item_versions
set canonical_answer_1 = '(a) In each Lewis structure, the central oxygen is bonded to one terminal oxygen by a double bond and to the other terminal oxygen by a single bond, with one lone pair on the central atom. Using FC = valence electrons − nonbonding electrons − (bonding electrons)/2: the central oxygen has 6 valence electrons, 2 nonbonding electrons (one lone pair), and 6 bonding electrons (one double bond + one single bond), giving FC = 6−2−3 = +1. The doubly-bonded terminal oxygen has 4 nonbonding electrons (two lone pairs) and 4 bonding electrons, giving FC = 6−4−2 = 0. The singly-bonded terminal oxygen has 6 nonbonding electrons (three lone pairs) and 2 bonding electrons, giving FC = 6−6−1 = −1. These three formal charges (+1, 0, −1) sum to 0, matching neutral O3, and this exact pattern is identical in both structures I and II -- only which terminal oxygen carries the double bond (and therefore the 0 versus the −1) swaps between them. Because both structures produce the same formal-charge distribution and differ only in that swap, they are equivalent resonance contributors rather than competing structures where one is preferred.

(b) The central oxygen has three electron domains (one double bond, one single bond, one lone pair), giving bent molecular geometry. Resonance delocalization makes the two O−O bonds equivalent, each with average bond order 1.5 (the average of one single bond and one double bond).

(c) A bond-length measurement (e.g., via microwave or electron-diffraction spectroscopy) should find both O−O bonds in ozone equal in length, at a value intermediate between a typical O−O single-bond length and a typical O=O double-bond length -- consistent with the 1.5 average bond order rather than one distinctly shorter and one distinctly longer bond.

(d) The true ozone molecule is not a molecule that flips back and forth between structure I and structure II, nor is it a mixture of separate molecules, some looking like structure I and some like structure II. It is a single resonance hybrid: one real structure that is the weighted blend of both contributors, in which both O−O bonds are identical (equal length, bond order 1.5). Any single Lewis structure can only represent integer bond orders (single or double), so drawing one contributor with one single bond and one double bond is a limitation of that structure''s notation, not evidence that the real molecule contains one permanently shorter, double-bonded O−O bond and one permanently longer, single-bonded one.'
where id = '5ef4086a-7799-4567-8af9-bd54e39aa6ca';

update app.content_item_versions
set canonical_answer_1 = '(a) n = PV/RT = (0.950 atm)(1.80 L) / [(0.08206 L·atm·mol⁻¹·K⁻¹)(298 K)] ≈ 0.0699 mol. At sufficiently high pressure, the gas''s own finite molecular volume and intermolecular repulsion become significant relative to the container volume, which typically gives Z = PV/(nRT) > 1; since n_ideal = PV/RT while n_true = n_ideal/Z, a Z > 1 means the ideal-gas calculation overestimates the true number of moles present. (The gas''s identity is not given, so the exact magnitude of any deviation at this specific pressure cannot be predicted, only the qualitative direction of the error in each regime.)

(b) The ideal gas law PV = nRT assumes both that intermolecular attractive forces are negligible and that the volume occupied by the gas molecules themselves is negligible compared with the container''s volume. At 298 K and 0.950 atm -- conditions reasonably close to standard ambient conditions, well below the high-pressure regime where molecular volume matters and well above the very-low-temperature regime where attractive forces dominate -- both approximations are reasonable, so it is a valid assumption that the gas behaves ideally under these specific conditions.

(c) To test for nonideal behavior, hold temperature and the total amount of gas constant, and measure pressure and volume at several different pressures. At each pressure, calculate Z = PV/(nRT), where n is the gas''s true amount, determined independently just once (for example, from a measured mass and known molar mass) rather than recalculated from PV/RT at each point -- otherwise Z would trivially equal 1 by construction. If Z stays at 1 across the pressure range, the gas is behaving ideally; systematic deviation of Z away from 1 indicates nonideal behavior.

(d) As a boundary case, consider a low-temperature, moderate-pressure regime where intermolecular attractive forces dominate over molecular-volume effects: here Z = PV/(nRT) < 1. Since n_ideal = PV/RT = Z·n_true, a Z < 1 means n_ideal is smaller than the true amount of gas present -- so in this attraction-dominated boundary case, the moles calculated from the ideal gas law would be too low compared with the true value.'
where id = '87e42a1b-1af0-4214-924c-98a6a4d511c1';

update app.content_item_versions
set canonical_answer_1 = '(a) Moles of AgNO3 = moles Ag+ = (0.0250 L)(0.120 mol/L) = 0.00300 mol. Net ionic equation: Ag+(aq) + Cl-(aq) → AgCl(s).

(b) Because the net ionic equation shows Ag+ and Cl- combining in a 1:1 mole ratio, and Cl- is present in excess (so essentially all of the limiting reagent, Ag+, is consumed), the moles of AgCl formed equal the moles of Ag+ originally present -- the 0.00300 mol calculated in part (a) -- provided precipitation is assumed to go to completion, which is reasonable here specifically because Cl- is in excess and AgCl is highly insoluble.

(c) To verify this yield gravimetrically: filter the precipitate, wash it to remove soluble ions (such as excess NO3- or Cl-) adhering to the solid without dissolving the AgCl itself, dry it to constant mass (reweighing after repeated heating/cooling cycles until the mass no longer changes, confirming all moisture is removed), cool it in a desiccator, weigh the dried AgCl, and divide the measured mass by AgCl''s molar mass to obtain the experimental moles of AgCl.

(d) Incomplete drying leaves residual moisture in the precipitate, inflating its measured mass and therefore giving a calculated yield that is too high. Precipitate loss (for example, during filtering or washing) removes solid AgCl before it is weighed, giving a calculated yield that is too low.'
where id = 'cc99d8f6-5107-4717-84a6-3cb5ed10f6e1';

delete from app.frq_criteria
where content_item_version_id = '8c1286d2-9402-427c-a8f5-d75ff31cfdb7' and criterion_key in ('b2','d1');

update app.content_item_versions
set canonical_answer_1 = '(a) Doubling [A] at constant [B] doubles the rate, so the reaction is first order in A. Doubling [B] at constant [A] quadruples the rate (2²=4), so the reaction is second order in B. The complete rate law is rate = k[A][B]², and the overall reaction order is 1+2 = 3 (third order).

(b) Varying one reactant''s concentration while holding the other (and temperature) constant isolates that reactant''s exponent in the rate law: any change in the measured initial rate can then be attributed only to the concentration that was changed, so comparing the ratio of rates to the ratio of concentrations directly reveals that reactant''s order.

(c) A valid set of trials varies [A] while holding [B] (and temperature) fixed across at least two runs, and separately varies [B] while holding [A] (and temperature) fixed across at least two runs -- for example, doubling [A] alone in one pair of trials, then doubling [B] alone in another pair. The measured (dependent) variable in each trial is the initial reaction rate. The controlled variables are temperature, any catalyst present, total solution volume, the mixing procedure, and -- in each half of the design -- the concentration of the reactant not being varied.

(d) The rate law rate = k[A][B]² describes the gross forward reaction rate. Once products have accumulated enough for the reverse reaction to become significant, the measured net rate (forward rate minus reverse rate) will be lower than the value k[A][B]² predicts, because that expression only accounts for the forward direction and does not subtract the now-significant reverse reaction.'
where id = '8c1286d2-9402-427c-a8f5-d75ff31cfdb7';

update app.content_item_versions
set canonical_answer_1 = '(a) c = q/(mΔT) = 3140 J / [(75.0 g)(10.0°C)] = 4.19 J·g⁻¹·K⁻¹. Since the solution absorbed heat (its temperature rose), q is positive.

(b) The relation q=mcΔT is an application of conservation of energy: the heat added to the solution equals its mass times its specific heat times its temperature change. Rearranging for c, as used in part (a), assumes that no heat was lost to the surroundings during warming -- i.e., that the full 3.14 kJ went into raising the solution''s temperature rather than partly escaping to the container or the air.

(c) To verify this specific heat value, hold the solution''s mass constant at 75.0 g and measure the temperature change (ΔT) that results from supplying a known, fixed amount of heat; ΔT is the measured (dependent) variable in this check.

(d) One systematic error: heat lost to an uninsulated container. If some of the supplied heat escapes to the surroundings instead of being fully absorbed by the solution, the measured ΔT will be smaller than the solution''s true temperature rise under ideal, fully insulated conditions. Since c = q/(mΔT), a smaller measured ΔT in the denominator (with q treated as the known, fixed quantity of heat supplied) makes the calculated specific heat too high.'
where id = '4a3a6222-6c26-4828-b4e0-8c169cc959fe';

commit;
