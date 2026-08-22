begin;

-- Repair AP Chemistry Unit 1 (Atomic Structure and Properties) Learn More
-- explainers -- all 8 were template-generated debt (core_idea
-- verbatim-matching their brief's what_it_is, and mini_example_question /
-- weak_answer shared boilerplate duplicated across ~150 other rows
-- corpus-wide, per the 2026-08-21 bulk audit). Confirmed via SQL: all 8
-- rows carried source_note 'generated-from-brief:legacy;
-- grandfathered-2026-08-21', and a direct read of the current rows showed
-- core_idea byte-identical to the paired brief's what_it_is on every row,
-- plus the exact boilerplate weak_answer ("I would do the calculation or
-- name the trend and move on.") and mini_example_question
-- (title-interpolation template) on every row -- so all 8 are genuine
-- debt, none were an outlier that already had hand-authored content. This
-- is the first AP Chemistry batch. Briefs for this unit are genuinely
-- hand-authored and correct; NOT touched here.
--
-- Grounded in docs/product/AP_CHEMISTRY_CED_FACT_PACK.md Unit 1 section
-- (starting line 221) plus the general exam-wide-conventions section
-- (line 198): 1.1's derived fact that molar mass in grams numerically
-- equals one particle's average mass in amu (a consequence of n=m/M
-- distinct from what the brief already states); 1.2's exclusion of
-- multi-element/non-monatomic-ion mass spectra, plus the documented 2025
-- FRQ isotope-mass misconception (mean score 0.55/1.0, mass differences
-- wrongly attributed to electrons/protons instead of neutrons), verified
-- against real isotopic data for Mg-24/25/26 (23.985/24.986/25.983 amu,
-- 78.99%/10.00%/11.01% abundance, weighted average 24.31 amu matching
-- magnesium's periodic-table mass of 24.305); 1.3's molecular-formula
-- scaling step (empirical mass vs. actual molar mass), verified against a
-- glucose-composition example (40.0% C/6.71% H/53.3% O by mass, empirical
-- formula CH2O at 30.03 g/mol, scaling by 180.16/30.03≈6 to C6H12O6); 1.4's
-- derived point that a homogeneous mixture can look as uniform as a
-- compound, so only a constant elemental-composition ratio across samples
-- (not appearance) proves purity, verified against real water composition
-- (11.19% H / 88.81% O by mass); 1.5's Coulomb's-law equation
-- (F∝q1q2/r²) and its explicit exclusion of quantum-number assignment,
-- applied to a real S-vs-Al first-ionization-energy comparison (S:
-- 1s2 2s2 2p6 3s2 3p4, Al: 1s2 2s2 2p6 3s2 3p1; S's real IE1 ~999.6 kJ/mol
-- exceeds Al's ~577.5 kJ/mol, consistent with S's greater nuclear charge
-- at similar shielding/distance); 1.6's E=hv photon-energy link to PES
-- binding energy, applied to a magnesium PES peak-height example (heights
-- 2:2:6:2 summing to 12 electrons = 1s2 2s2 2p6 3s2, Z=12); 1.7's
-- exclusion of aufbau-exception configurations, applied to a real
-- Cl-vs-S first-ionization-energy comparison (Cl's real IE1 ~1251.2
-- kJ/mol exceeds S's ~999.6 kJ/mol, consistent with Cl's greater nuclear
-- charge at similar shielding/distance); and 1.8's charge-balance
-- consequence of the same-column-analogy rule, applied to a real
-- Ca-plus-Cl formula-prediction example (Ca 2+, Cl 1-, balancing to
-- CaCl2, not CaCl). All computed/cited numbers (molar masses, isotope
-- abundances and weighted average, empirical/molecular formula scaling,
-- mass percentages, electron configurations and their electron counts,
-- and the real ionization-energy comparisons) were independently verified
-- during authoring.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Chemistry Unit 1); the
-- pre-repair content is fully recoverable from git history for this
-- table's rows if a rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4
-- ("the same topic-specific answer_move" / "the same or refined
-- common_point_loss") -- the Unit 1 briefs already carry specific,
-- correct, non-templated point-earning language, so no refinement was
-- needed. mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge are original per-row text that was checked corpus-wide
-- before this migration was written and repeats nowhere else in the
-- published corpus (zero collisions found).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('1.1',
   'You cannot count atoms directly in the lab, so n = m/M bridges a measurable mass to moles, and Avogadro''s number (6.022x10^23/mol) bridges moles to particle count. A subtler consequence: a substance''s molar mass in grams numerically equals one particle''s average mass in amu.',
   'Every quantitative topic ahead -- stoichiometry, solution concentration, gas laws -- starts by converting between mass and moles, so a wrong molar mass or a mole/particle mix-up here propagates into every later calculation, not just this topic''s own answer.',
   'Points require correctly applying n = m/M (or its rearrangements) with the right molar mass for the substance actually asked about, and correctly choosing whether Avogadro''s number is needed to reach a particle count, rather than stopping at moles when particles were requested.',
   'Before calculating, write down what you are given (mass, moles, or particle count) and what you need, then choose n = m/M or n times Avogadro''s number to connect them.',
   'A student weighs out 3.42 g of glucose (C6H12O6, molar mass 180.16 g/mol) and needs the number of glucose molecules in that mass before starting a titration calculation.',
   'n = 3.42 g / 6.022x10^23 = 5.68x10^-24 mol, so that''s the number of molecules.',
   'n = m/M = 3.42 g / 180.16 g/mol ~ 0.01898 mol. Multiplying by Avogadro''s number gives the particle count: 0.01898 mol x 6.022x10^23/mol ~ 1.14x10^22 glucose molecules. Molar mass, not Avogadro''s number, converts mass to moles; Avogadro''s number only converts moles to particle count.',
   'Using the wrong molar mass, such as an element''s molar mass in a compound problem, or miscounting atoms when summing a compound''s molar mass from its formula.',
   'Go to practice and, on every moles question, check which conversion you actually need first -- mass-to-moles uses molar mass, moles-to-particles uses Avogadro''s number -- before doing any arithmetic.'),
  ('1.2',
   'A single-element mass spectrum shows one peak per isotope, positioned at that isotope''s mass and sized by its natural relative abundance; average atomic mass is the isotope-weighted average of those peaks. The AP Exam explicitly excludes interpreting spectra from samples containing multiple elements or peaks from anything other than singly charged monatomic ions.',
   'This is how average atomic mass is actually measured, not memorized, and it depends on isotopes of one element sharing the same proton count while differing only in neutron count -- the 2025 FRQ''s isotope-mass-difference point scored a mean of just 0.55/1.0, mostly from students attributing that mass difference to electrons or protons instead of neutrons.',
   'Points require reading each peak''s mass and relative abundance correctly, multiplying isotope mass by fractional abundance and summing across every peak, and -- when asked to explain a mass difference between isotopes -- naming neutron count as the variable quantity, since proton count (and therefore electron count in a neutral atom) is fixed for a given element.',
   'For each peak, multiply the isotope mass by its fractional abundance, then add the products across every peak to get the weighted average atomic mass.',
   'Magnesium''s natural sample shows three mass-spectrum peaks: Mg-24 (mass 23.985 amu, 78.99% abundance), Mg-25 (24.986 amu, 10.00%), and Mg-26 (25.983 amu, 11.01%). Calculate the average atomic mass, then explain what makes Mg-25 one amu heavier than Mg-24.',
   'Average mass ~ 24.3 amu, and Mg-25 is heavier than Mg-24 because it has one more electron.',
   'Weighted average = (23.985x0.7899) + (24.986x0.1000) + (25.983x0.1101) ~ 18.945 + 2.499 + 2.861 ~ 24.31 amu, matching magnesium''s periodic-table mass of 24.305. Mg-24 and Mg-25 both have 12 protons (defining the element) and 12 electrons (neutral atom); the one-amu mass difference comes from Mg-25 having one additional neutron, not an additional proton or electron.',
   'Attributing isotope mass differences to electrons or protons instead of neutrons.',
   'Return to practice and, on every mass-spectrum question, remember the isotope-mass story is always about neutrons -- and that multi-element spectra are outside what the AP Exam will ever ask you to interpret.'),
  ('1.3',
   'The law of definite proportions says the mass ratio of elements in any pure sample of a compound is fixed; the empirical formula is the lowest whole-number atom ratio matching that mass ratio. A molecular formula is always an integer multiple of the empirical formula, found by dividing the compound''s actual molar mass by the empirical formula''s mass.',
   'This connects experimental mass data -- like combustion analysis, which reports masses of CO2 and H2O produced from burning a sample -- to a compound''s formula, and it only works because every sample of a pure compound gives the same element ratio no matter how much of it you burn.',
   'Points require converting given masses or mass percentages to moles of each element, dividing every mole value by the smallest one to get a whole-number ratio (the empirical formula), and then -- when a molecular molar mass is given -- dividing that molar mass by the empirical formula''s mass to find the scaling factor for the molecular formula.',
   'Assume a 100 g sample so mass percent becomes grams, convert each element''s grams to moles, divide every mole value by the smallest mole value, then scale to whole numbers.',
   'A compound is 40.0% C, 6.71% H, and 53.3% O by mass, with a molar mass of about 180 g/mol. Find its molecular formula.',
   'Assuming 100 g: C = 40.0/12.01 = 3.33 mol, H = 6.71/1.008 = 6.66 mol, O = 53.3/16.00 = 3.33 mol. Dividing by the smallest value gives C1H2O1, so the formula is CH2O.',
   'The mole ratio C:H:O = 3.33:6.66:3.33 reduces to 1:2:1, giving empirical formula CH2O with empirical mass 12.01+2(1.008)+16.00 ~ 30.03 g/mol. Since the actual molar mass (180 g/mol) is about 180.16/30.03 ~ 6 times the empirical mass, the molecular formula is (CH2O)x6 = C6H12O6, not CH2O -- the empirical formula alone under-answers a molecular-formula question.',
   'Stopping at the empirical formula when the molecular formula was asked for, by not scaling the empirical formula using the ratio of given molar mass to empirical formula mass.',
   'Head back to practice and, whenever a molar mass is given alongside percent composition, treat that as a signal the question wants the molecular formula, not just the empirical one.'),
  ('1.4',
   'A pure substance contains one particle type in a fixed proportion; a mixture contains two or more particle types whose proportions can vary sample to sample. Because a mixture can be homogeneous and look just as uniform as a compound, appearance can never substitute for checking whether the elemental composition ratio actually stays constant across independently drawn samples.',
   'This fixed-ratio-versus-variable-ratio distinction is what makes empirical-formula reasoning (Topic 1.3) valid at all, and it''s the same evidence -- a constant or inconstant elemental composition ratio -- that Unit 3''s mixture-separation topics build on.',
   'Points require using elemental analysis data from two or more samples to test whether a component''s mass ratio holds constant, and stating a purity conclusion that follows from that comparison rather than from appearance, texture, or a single sample''s data alone.',
   'Compare the calculated mass ratio of components across two or more samples of the same material. A constant ratio supports a pure substance; a changing ratio supports a mixture.',
   'A clear liquid sold under one label gives Sample A: 11.2% H, 88.8% O by mass. A bottle from a different batch of the same product gives Sample B: 9.5% H, 90.5% O by mass. Is this product a pure substance?',
   'Both samples are clear liquids that look identical, so this is a pure substance.',
   'Water (H2O) has a fixed mass ratio of 11.19% H to 88.81% O. Sample A matches that ratio, but Sample B (9.5% H, 90.5% O) does not -- a pure substance''s elemental composition ratio cannot vary between samples. Because the ratio changed between bottles, at least one sample is not the pure substance claimed; appearance (both being clear liquids) provides no evidence either way.',
   'Assuming a sample is a pure substance just because it looks uniform or homogeneous, instead of checking whether its elemental composition ratio stays constant across independent samples.',
   'Go to practice and, on every purity question, compare the actual calculated element ratios across samples first -- never decide purity from how a substance looks.'),
  ('1.5',
   'An atom is a nucleus (protons and neutrons) surrounded by electrons, with Coulomb''s law giving the force between charged particles as F proportional to q1q2/r^2. Electron configuration follows the Aufbau filling order, but the AP Exam explicitly excludes assigning quantum numbers to individual electrons in a subshell -- configuration notation and filling order are what''s tested, not the n/l/ml/ms labels.',
   'Electron configuration is the structural fact behind reactivity, bonding behavior, and every periodic trend for the rest of the course -- and behind the photoelectron spectroscopy evidence in the very next topic -- so a configuration written correctly but explained with a vague label like "periodic trend" doesn''t earn the reasoning point.',
   'Points require writing a correct ground-state configuration using the Aufbau order, and then grounding any related property claim (like ionization energy) in Coulomb''s-law terms -- nuclear charge and electron distance or shielding -- rather than restating the property or trend by name.',
   'Fill subshells in order of increasing energy (1s, 2s, 2p, 3s, 3p, 4s, 3d, and so on), then explain any related property, such as ionization energy, using nuclear charge and electron distance or shielding rather than stopping at the configuration itself.',
   'Write the ground-state electron configuration for sulfur (S, Z=16) and aluminum (Al, Z=13), and use those configurations to explain why sulfur has a higher first ionization energy than aluminum.',
   'S: 1s2 2s2 2p6 3s2 3p4, Al: 1s2 2s2 2p6 3s2 3p1. Sulfur has a higher ionization energy because it is farther to the right on the periodic table.',
   'S: 1s2 2s2 2p6 3s2 3p4, Al: 1s2 2s2 2p6 3s2 3p1. Both atoms have their valence electrons in the same n=3 shell with similar core-electron shielding, but sulfur has three more protons (Z=16 vs. 13), giving it greater nuclear charge. By Coulomb''s law (F proportional to q1q2/r^2), a larger nuclear charge acting over a similar distance produces a stronger attractive force on the valence electrons, so more energy is required to remove one from sulfur.',
   'Writing a correct electron configuration but then explaining a related property, such as ionization energy, with a vague label like periodic trend instead of grounding the explanation in nuclear charge and electron distance or shielding, which is what the Coulomb''s law reasoning actually requires.',
   'Return to practice and, whenever you compare two atoms'' ionization energy or radius, name the specific Coulomb''s-law factor that differs between them -- never stop at restating the trend''s direction.'),
  ('1.6',
   'In a photoelectron spectrum, each peak''s position is the energy needed to remove an electron from a specific subshell, and each peak''s height is approximately proportional to that subshell''s electron count. The photon energy used to eject the electron follows E = hv, the same relationship used for photons throughout the course, and equals the electron''s binding energy plus its ejected kinetic energy.',
   'PES turns the electron-configuration rules from Topic 1.5 into something read directly off real data: core electrons, closer to the nucleus and less shielded, always need more energy to remove than valence electrons, regardless of which subshell the Aufbau principle happened to fill last.',
   'Points require matching a spectrum''s peak positions and relative heights to a specific element''s electron configuration, and explaining binding energy differences using distance from the nucleus and shielding -- not the order subshells were filled in.',
   'Count the number of peaks and compare their relative heights first to identify subshell electron counts, then match that pattern to a specific element''s electron configuration before discussing binding energy.',
   'An unlabeled PES spectrum shows four peaks with relative heights, ordered from highest binding energy to lowest, of 2 : 2 : 6 : 2. Identify the element and justify the identification using the peak heights.',
   'The highest-binding-energy peak must be the 3s peak, since 3s is one of the last subshells filled by the Aufbau principle.',
   'Relative heights 2:2:6:2 correspond to electron counts, so this element has 2+2+6+2 = 12 total electrons distributed as 1s2 2s2 2p6 3s2 -- magnesium (Z=12). The highest-binding-energy peak (height 2) is the 1s peak because 1s electrons sit closest to the nucleus and are least shielded, not because 1s was filled first or last -- binding-energy order and Aufbau filling order are different orderings and shouldn''t be conflated.',
   'Confusing binding energy order with orbital filling order; a subshell with higher binding energy is held more tightly and closer to the nucleus, which is not necessarily the last subshell filled by the Aufbau principle.',
   'Head to practice and, on every PES question, sum the peak heights to get total electron count first, then match that configuration to an element before making any claim about binding energy order.'),
  ('1.7',
   'Periodic table position reflects recurring electron-configuration patterns, and ionization energy, radius, electron affinity, and electronegativity trends are explained qualitatively through Coulomb''s law, shielding, and effective nuclear charge. Writing the electron configuration of an aufbau-exception element, such as chromium or copper, is explicitly excluded from the AP Exam -- the standard filling order applies wherever trends are tested.',
   'Periodic trends let you predict or estimate a property for an unfamiliar element from its position alone, and this reasoning skill is tested throughout the exam, not only in Unit 1 -- the same Coulomb''s-law logic used here reappears whenever a later unit asks you to compare or estimate a property.',
   'Points require explaining a trend using effective nuclear charge and distance from the nucleus or shielding -- never just naming the trend''s direction -- and using that reasoning to make a specific comparison or estimate when exact data isn''t given.',
   'For a trend question, choose whichever Coulombic factor actually differs between the two atoms or ions being compared, effective nuclear charge, distance from the nucleus, or shielding, and use only that factor to justify the direction of the trend.',
   'Explain why the first ionization energy of chlorine (Cl, Z=17) is greater than that of sulfur (S, Z=16), even though chlorine has one more electron in the same 3p subshell.',
   'Chlorine has a higher ionization energy than sulfur because ionization energy increases across a period.',
   'Cl and S are in the same period, so their valence electrons sit at a similar distance from the nucleus with similar shielding from the same core configuration. Chlorine has one more proton (Z=17 vs. 16), giving it greater effective nuclear charge. By Coulomb''s law, a larger nuclear charge acting over a similar radius produces a stronger attractive force on the valence electrons, so removing one from chlorine requires more energy -- the direction of the trend follows from this charge difference, not from the trend''s name alone.',
   'Correctly stating the direction of a trend, such as ionization energy increases across a period, without explaining why through effective nuclear charge and shielding; an unsupported direction claim does not earn the explanation point.',
   'Go to practice and, before stating any periodic-trend direction, name which Coulomb''s-law factor -- nuclear charge, distance, or shielding -- actually differs between the two atoms being compared.'),
  ('1.8',
   'Bond formation is governed by how valence electrons interact with the nucleus; same-column elements form analogous compounds, and typical ionic charge follows from valence electron count and periodic position. Because total charge must balance to zero, an unfamiliar formula can be predicted directly -- knowing NaCl exists predicts KCl (same column as Na), but not CaCl (Ca loses two electrons for a 2+ charge, so CaCl2 balances, CaCl does not).',
   'This sets up bonding and compound formation for Unit 2, and it lets you predict a formula or an analogous compound for an element you haven''t seen before, based only on periodic position and the requirement that total charge balances to zero.',
   'Points require deriving an ion''s typical charge from its group number or valence-electron count, using that charge to build a compound formula whose total positive and negative charge sums to zero, and correctly using same-column analogies without assuming two different-group elements share the same charge.',
   'For common main-group ions, count valence electrons from the group number, determine how many electrons must be gained or lost to reach a noble-gas configuration, and use that number as the ion''s typical charge.',
   'Sodium chloride (NaCl) is a known ionic compound. Predict the formula of the compound formed between calcium and chlorine, using periodic position and valence-electron count.',
   'Calcium is near sodium on the periodic table, so the compound is probably CaCl, like NaCl.',
   'Calcium (group 2) has 2 valence electrons and loses both to reach a noble-gas configuration, giving it a typical charge of 2+. Chlorine (group 17) gains 1 electron to reach a noble-gas configuration, giving it a typical charge of 1-. Balancing total charge to zero requires two Cl- ions for every Ca2+ ion, giving CaCl2 -- the same-column analogy to NaCl breaks down because calcium''s group, and therefore its charge, is different from sodium''s.',
   'Guessing or misremembering an ionic charge instead of deriving it from valence electron count and group position, or proposing a compound formula whose total positive and negative charge does not balance to zero.',
   'Return to practice and, on every ionic-formula question, derive each ion''s charge from group number first, then check that the formula''s total charge actually sums to zero before finalizing it.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 1 section (line 221) and the general exam-wide-conventions section (line 198): the derived molar-mass-equals-average-particle-mass-in-amu fact for 1.1; the multi-element/non-monatomic-ion mass-spectra exclusion and the 2025 CRR-documented isotope-mass-difference misconception (electrons/protons instead of neutrons, mean score 0.55/1.0) for 1.2, verified against real Mg-24/25/26 isotopic data; the molecular-formula empirical-mass-scaling step for 1.3, verified against a glucose-composition example; the homogeneous-mixture-can-look-uniform derived fact for 1.4, verified against real water composition; the Coulomb''s-law equation and quantum-number-assignment exclusion for 1.5, verified against a real S-vs-Al ionization-energy comparison; the E=hv photon-binding-energy link for 1.6, verified against a magnesium PES peak-height example; the aufbau-exception exclusion for 1.7, verified against a real Cl-vs-S ionization-energy comparison; and the charge-balance consequence of the same-column-analogy rule for 1.8, verified against a real Ca+Cl formula example; briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-chemistry-unit1-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_chemistry'
  and e.unit_number = 1
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_chemistry' and unit_number=1 and status='published'
      and source_note like '%unit1-explainer-repair%';
  if v_repaired <> 8 then
    raise exception 'expected 8 repaired AP Chemistry Unit 1 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_chemistry' and b.unit_number=1 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Chemistry Unit 1 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
