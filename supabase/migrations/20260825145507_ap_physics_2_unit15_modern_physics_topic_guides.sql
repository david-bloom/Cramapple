begin;

-- Add AP Physics 2 Unit 15 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 8 AP Physics 2 Unit 15 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_2_CED_FACT_PACK.md Unit 15 (Modern
-- Physics). The fact pack confirms photon energy, de Broglie wavelength,
-- discrete bound states, Bohr standing-wave states and single-electron energy
-- diagrams, emission/absorption spectra, blackbody quantization, photoelectric
-- threshold and stopping-potential reasoning, Compton wavelength shift and 2-D
-- momentum expectations, fission/fusion/nuclear decay conservation, half-life
-- equations, and radioactive-decay type boundaries including the Fall-2026
-- gamma clarification.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_physics_2', 15, '15.1', 'Quantum Theory and Wave-Particle Duality', 'very-important', 'very-important',
   'Light energy comes in photons with E = hf, and matter can show wave behavior through the de Broglie relation lambda = h/p.',
   'This topic connects wave optics to modern physics. Students must move between frequency, wavelength, photon energy, momentum, and discrete bound states.',
   'You earn points by using E = hf and lambda = c/f for photons, using lambda = h/p for matter waves, and recognizing that bound systems have allowed energies rather than any arbitrary energy.',
   'Decide whether the object is a photon or a massive particle first; then choose the matching energy, wavelength, and momentum relations.',
   'Using lambda = h/p for a photon while also ignoring E = hf, or treating quantization as just a measurement limitation.',
   '/learn/ap-physics-2/unit-15/quantum-theory-and-wave-particle-duality'),
  ('ap_physics_2', 15, '15.2', 'The Bohr Model of Atomic Structure', 'very-important', 'somewhat-important',
   'The Bohr model treats allowed electron states in a single-electron atom as standing-wave circular orbits with discrete energies.',
   'AP Physics 2 uses the Bohr model to explain quantized energy levels without asking for orbital shapes or probability functions.',
   'You earn points by using nuclear notation, identifying isotopes, connecting allowed Bohr states to standing-wave conditions, and keeping the discussion to single-electron energy-level diagrams.',
   'State the allowed-state idea first, then connect transitions between allowed levels to photon absorption or emission.',
   'Describing modern orbitals or probability clouds when the question is asking for the Bohr-model energy-level picture.',
   '/learn/ap-physics-2/unit-15/the-bohr-model-of-atomic-structure'),
  ('ap_physics_2', 15, '15.3', 'Emission and Absorption Spectra', 'very-important', 'very-important',
   'Atoms emit or absorb photons only when the photon energy exactly matches the difference between two allowed energy levels.',
   'Spectra are evidence for quantized atomic energy and can identify elements. The AP scope focuses on single-electron energy-level diagrams and binding or ionization energy.',
   'You earn points by matching photon energy to Delta E, deciding whether a transition emits or absorbs light, and connecting larger energy gaps to higher-frequency photons.',
   'Write Delta E between the two levels, then set it equal to hf before deciding frequency, wavelength, or direction of transition.',
   'Saying an electron can absorb any photon with enough energy for every bound-to-bound transition.',
   '/learn/ap-physics-2/unit-15/emission-and-absorption-spectra'),
  ('ap_physics_2', 15, '15.4', 'Blackbody Radiation', 'somewhat-important', 'somewhat-important',
   'A blackbody is an ideal absorber and emitter whose continuous spectrum depends on temperature and whose energy exchange is explained by quantization.',
   'This topic shows why classical wave ideas failed at small scales. Temperature controls peak wavelength and total emitted power.',
   'You earn points by using Wien law lambda_max = b/T, Stefan-Boltzmann reasoning P = A sigma T^4, and explaining that Planck quantization resolves the spectrum shape.',
   'Start with the temperature change; then decide how peak wavelength and total emitted power change.',
   'Thinking a hotter blackbody emits only one wavelength instead of a continuous spectrum with a shifted peak.',
   '/learn/ap-physics-2/unit-15/blackbody-radiation'),
  ('ap_physics_2', 15, '15.5', 'The Photoelectric Effect', 'very-important', 'very-important',
   'Photoelectrons are emitted only when photon energy exceeds the work function, with maximum kinetic energy K_max = hf - phi.',
   'This is a central evidence point for photons. Frequency controls whether electrons are emitted and their maximum kinetic energy; intensity controls the number rate once frequency is high enough.',
   'You earn points by checking threshold frequency, using K_max = hf - phi, relating stopping potential to K_max, and treating provided work functions as data rather than memorized constants.',
   'Check the threshold first; if emission occurs, use photon energy minus work function to find maximum kinetic energy.',
   'Saying brighter low-frequency light eventually ejects electrons if the intensity is large enough.',
   '/learn/ap-physics-2/unit-15/the-photoelectric-effect'),
  ('ap_physics_2', 15, '15.6', 'Compton Scattering', 'somewhat-important', 'somewhat-important',
   'Compton scattering shows a photon colliding with an electron and leaving with lower energy, lower frequency, and longer wavelength.',
   'It is direct evidence that photons carry momentum. AP Physics 2 can ask for qualitative and quantitative 2-D momentum reasoning along with the wavelength-shift equation.',
   'You earn points by conserving energy and momentum, using Delta lambda = h/(m_e c)(1 - cos theta), and describing the scattered photon as longer wavelength after giving energy to the electron.',
   'Draw before-and-after momentum vectors; then connect the photon wavelength increase to energy transferred to the electron.',
   'Treating the photon as slowing down in vacuum rather than changing frequency and wavelength while still traveling at c.',
   '/learn/ap-physics-2/unit-15/compton-scattering'),
  ('ap_physics_2', 15, '15.7', 'Fission, Fusion, and Nuclear Decay', 'very-important', 'very-important',
   'Nuclear reactions and decays conserve charge, nucleon number, energy, and momentum, while mass-energy changes are related by E = mc^2.',
   'This topic connects nuclear binding, strong-force scale, energy release, and radioactive decay models. Half-life and decay constants turn nuclear change into measurable exponential behavior.',
   'You earn points by balancing nuclear equations, using conservation laws, relating mass difference to energy, and applying lambda = ln2/t_1/2 or N = N0e^(-lambda t) when decay is modeled quantitatively.',
   'Balance nucleon number and charge first; then use mass-energy or exponential decay only after the reaction bookkeeping is consistent.',
   'Balancing only electric charge and forgetting nucleon number or emitted particles.',
   '/learn/ap-physics-2/unit-15/fission-fusion-and-nuclear-decay'),
  ('ap_physics_2', 15, '15.8', 'Types of Radioactive Decay', 'very-important', 'very-important',
   'Alpha, beta-minus, beta-plus, and gamma decay change nuclei in distinct ways while conserving charge, nucleon number, lepton number, energy, and momentum.',
   'Students need the allowed decay bookkeeping, not memorized isotope-specific decay paths. Gamma decay is a transition to a lower energy level of the same nucleus.',
   'You earn points by identifying the emitted particle, updating mass number and atomic number correctly, and staying inside AP scope: no neutron emission, electron capture, neutrino-type details, or weak-force mechanism explanation.',
   'Write the emitted particle symbol first; then balance mass number, atomic number, and lepton number.',
   'Treating gamma decay as changing the element or mass number instead of lowering nuclear energy only.',
   '/learn/ap-physics-2/unit-15/types-of-radioactive-decay')
),
explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  ('ap_physics_2', 15, '15.1', 'Quantum Theory and Wave-Particle Duality',
   'Quantum theory treats energy and matter as having both particle-like and wave-like features. A photon has energy set by frequency, while a massive particle has a wavelength related to momentum.',
   'Students need to sort the model before selecting equations. For light in vacuum, c = lambda f and E = hf connect wavelength, frequency, and photon energy. For electrons or other matter particles, lambda = h/p gives the de Broglie wavelength. Bound systems have discrete allowed states rather than a continuous spread of possible energies.',
   'Points come from choosing the correct relation for the object, ranking energy by frequency, ranking wavelength inversely with momentum for matter waves, and explaining quantization as allowed states in a bound system.',
   'Decide whether the object is a photon or a massive particle first; then choose the matching energy, wavelength, and momentum relations.',
   'An electron and a proton have the same speed. Which has the shorter de Broglie wavelength?',
   'They have the same wavelength because they move at the same speed.',
   'The proton has the shorter wavelength. At the same speed it has the larger momentum, and lambda = h/p means larger momentum gives a smaller de Broglie wavelength.',
   'Using lambda = h/p for a photon while also ignoring E = hf, or treating quantization as just a measurement limitation.',
   'Back in practice, label each object as photon or matter before writing an equation.'),
  ('ap_physics_2', 15, '15.2', 'The Bohr Model of Atomic Structure',
   'The Bohr model explains discrete atomic energies by allowing only electron orbits that fit a standing-wave condition around a single-electron atom.',
   'Students need to stay within the model boundary. The Bohr picture can connect radius, standing waves, allowed energies, photons, isotopes, and nuclear notation, but AP Physics 2 does not require orbital shapes, probability functions, or multi-electron orbital detail here.',
   'Points come from stating that only certain states are allowed, connecting transitions to energy differences, and using single-electron energy-level diagrams appropriately.',
   'State the allowed-state idea first, then connect transitions between allowed levels to photon absorption or emission.',
   'Why does the Bohr model allow only certain electron energies in a hydrogen atom?',
   'Because the electron can choose only the path with the strongest electric force.',
   'Only orbits that fit the standing-wave condition are allowed, so the electron has discrete energy states. Transitions between those states involve photons with energies equal to level differences.',
   'Describing modern orbitals or probability clouds when the question is asking for the Bohr-model energy-level picture.',
   'In practice, keep Bohr-model answers tied to allowed states, standing waves, and single-electron level diagrams.'),
  ('ap_physics_2', 15, '15.3', 'Emission and Absorption Spectra',
   'Emission and absorption spectra occur because atomic electrons move between discrete energy levels by emitting or absorbing photons whose energies exactly match level differences.',
   'Students need to distinguish bound-to-bound transitions from ionization. A downward transition emits a photon; an upward transition absorbs one. Larger Delta E means larger photon frequency and shorter wavelength. Element-specific level spacings produce element-specific spectral lines.',
   'Points come from calculating or comparing Delta E, setting Delta E = hf, using c = lambda f when wavelength is needed, and identifying whether the photon is emitted or absorbed.',
   'Write Delta E between the two levels, then set it equal to hf before deciding frequency, wavelength, or direction of transition.',
   'An atom drops from -1.5 eV to -3.4 eV. Is light absorbed or emitted?',
   'It absorbs light because the final energy number is more negative.',
   'It emits light. The atom moves to a lower energy state, so the energy difference leaves as a photon with energy 1.9 eV.',
   'Saying an electron can absorb any photon with enough energy for every bound-to-bound transition.',
   'Back in practice, mark whether the final level is higher or lower before choosing absorption or emission.'),
  ('ap_physics_2', 15, '15.4', 'Blackbody Radiation',
   'A blackbody emits a continuous spectrum whose peak wavelength and total power depend strongly on temperature, and Planck quantization explains the observed spectrum.',
   'Students need to connect formulas to physical trends. Wien law says hotter objects have smaller peak wavelength. Stefan-Boltzmann reasoning says total radiated power increases with the fourth power of absolute temperature for a fixed area and emissivity. The spectrum remains continuous, not a single photon energy.',
   'Points come from predicting shifts in peak wavelength, comparing radiated power using absolute temperature, and explaining why energy quantization was needed to match the radiation curve.',
   'Start with the temperature change; then decide how peak wavelength and total emitted power change.',
   'A metal object is heated from 500 K to 1000 K. What happens to the peak wavelength of its thermal spectrum?',
   'The peak wavelength doubles because the temperature doubles.',
   'The peak wavelength is cut in half. Wien law gives lambda_max proportional to 1/T, so doubling absolute temperature halves the peak wavelength.',
   'Thinking a hotter blackbody emits only one wavelength instead of a continuous spectrum with a shifted peak.',
   'In practice, write hotter means shorter peak wavelength and much larger power before calculating.'),
  ('ap_physics_2', 15, '15.5', 'The Photoelectric Effect',
   'The photoelectric effect supports the photon model because electron emission depends on photon frequency exceeding a threshold, not on total light intensity alone.',
   'Students need to separate frequency effects from intensity effects. Below threshold, no electrons are emitted. Above threshold, higher frequency increases maximum kinetic energy, while greater intensity increases the number of emitted electrons per time. Stopping potential measures maximum kinetic energy per charge.',
   'Points come from checking hf against the work function, applying K_max = hf - phi, connecting stopping potential to energy, and using provided work-function data correctly.',
   'Check the threshold first; if emission occurs, use photon energy minus work function to find maximum kinetic energy.',
   'Light below the threshold frequency shines on a metal for a long time. What happens if the intensity is increased?',
   'Electrons eventually come out because more total energy reaches the metal.',
   'No photoelectrons are emitted if each photon is below the threshold energy. Increasing intensity adds more low-energy photons, but no individual photon has enough energy to overcome the work function.',
   'Saying brighter low-frequency light eventually ejects electrons if the intensity is large enough.',
   'Back in practice, compare hf with phi before discussing brightness or current.'),
  ('ap_physics_2', 15, '15.6', 'Compton Scattering',
   'Compton scattering is a photon-electron collision in which the scattered photon has a longer wavelength because it transfers energy and momentum to the electron.',
   'Students need to keep both energy and momentum in view. The photon still travels at c after scattering, so lower energy means lower frequency and longer wavelength, not lower speed. AP Physics 2 includes qualitative and quantitative 2-D momentum reasoning and the Compton shift formula.',
   'Points come from using vector momentum conservation, recognizing the wavelength shift depends on scattering angle, and linking larger wavelength to lower photon energy after the collision.',
   'Draw before-and-after momentum vectors; then connect the photon wavelength increase to energy transferred to the electron.',
   'After a photon scatters from an electron, its wavelength is larger. What happened to the photon energy?',
   'The energy stayed the same because photons always move at the same speed.',
   'The photon energy decreased. Since E = hf and c = lambda f, a larger wavelength means lower frequency and lower photon energy; the electron received energy and momentum.',
   'Treating the photon as slowing down in vacuum rather than changing frequency and wavelength while still traveling at c.',
   'In practice, write photon speed still c, then compare wavelength, frequency, and energy.'),
  ('ap_physics_2', 15, '15.7', 'Fission, Fusion, and Nuclear Decay',
   'Nuclear processes are constrained by conservation laws, and the energy released or absorbed comes from mass-energy differences in nuclear binding.',
   'Students need to balance nuclear bookkeeping before energy reasoning. Fission splits a heavy nucleus, fusion combines light nuclei, and radioactive decay transforms a nucleus toward a lower-energy state. Half-life models describe how many unstable nuclei remain after time passes.',
   'Points come from conserving charge and nucleon number in reaction equations, using E = mc^2 for mass defect or released energy, and applying exponential decay or half-life relations when given decay data.',
   'Balance nucleon number and charge first; then use mass-energy or exponential decay only after the reaction bookkeeping is consistent.',
   'A sample has a half-life of 6 days. What fraction remains after 18 days?',
   'One third remains because 18 days is three times the half-life.',
   'One eighth remains. Eighteen days is three half-lives, so the remaining fraction is (1/2)^3.',
   'Balancing only electric charge and forgetting nucleon number or emitted particles.',
   'Back in practice, count half-lives or use N = N0e^(-lambda t) only after identifying the decay setup.'),
  ('ap_physics_2', 15, '15.8', 'Types of Radioactive Decay',
   'Different radioactive decay modes have different nuclear bookkeeping: alpha emits a helium-4 nucleus, beta modes change a neutron-proton count with leptons, and gamma changes nuclear energy without changing identity.',
   'Students need to know the included AP decay types and boundaries. Alpha, beta-minus, beta-plus, and gamma are in scope. Neutron emission and electron capture are excluded, and questions do not require memorized isotope-specific decay paths, neutrino-type distinctions, or weak-force mechanism explanations.',
   'Points come from balancing mass number, atomic number, charge, and lepton number while identifying which emitted particle matches the decay mode.',
   'Write the emitted particle symbol first; then balance mass number, atomic number, and lepton number.',
   'A nucleus emits gamma radiation. What happens to its mass number and atomic number?',
   'Both decrease because energy leaves the nucleus.',
   'Neither mass number nor atomic number changes. Gamma decay lowers the energy of the same nucleus without changing the number of protons or nucleons.',
   'Treating gamma decay as changing the element or mass number instead of lowering nuclear energy only.',
   'In practice, make a small balance table for A, Z, charge, and lepton number before naming the daughter nucleus.')
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance,
  exam_importance, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss, learn_more_path, practice_subject_key,
  practice_unit_number, practice_topic_code, status, source_note, published_at
)
select
  subject_key, unit_number, topic_code, title, class_importance,
  exam_importance, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss, learn_more_path, subject_key,
  unit_number, topic_code, 'published',
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 2 Unit 15 Modern Physics; grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 15: photons with E=hf, lambda=c/f, de Broglie lambda=h/p, wave-particle duality, discrete bound states, Bohr standing-wave states and single-electron energy-level diagrams only, emission and absorption spectra with photon energies matching level differences, blackbody Wien and Stefan-Boltzmann reasoning, photoelectric threshold and K_max=hf-phi with provided work functions, Compton scattering wavelength shift and 2-D momentum reasoning, nuclear conservation laws, E=mc^2, half-life equations, and radioactive decay boundaries including Fall-2026 gamma clarification and exclusions for neutron emission, electron capture, neutrino-type distinctions, weak-force mechanisms, and isotope-specific memorization; batch 2026-08-25-ap-physics-2-unit15-topic-guides; author=reviewer same session, no independent human review yet',
  now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
  title = excluded.title,
  class_importance = excluded.class_importance,
  exam_importance = excluded.exam_importance,
  what_it_is = excluded.what_it_is,
  why_it_matters = excluded.why_it_matters,
  how_points_are_earned = excluded.how_points_are_earned,
  answer_move = excluded.answer_move,
  common_point_loss = excluded.common_point_loss,
  learn_more_path = excluded.learn_more_path,
  practice_subject_key = excluded.practice_subject_key,
  practice_unit_number = excluded.practice_unit_number,
  practice_topic_code = excluded.practice_topic_code,
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_point_briefs.published_at, excluded.published_at);

with explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  ('ap_physics_2', 15, '15.1', 'Quantum Theory and Wave-Particle Duality',
   'Quantum theory treats energy and matter as having both particle-like and wave-like features. A photon has energy set by frequency, while a massive particle has a wavelength related to momentum.',
   'Students need to sort the model before selecting equations. For light in vacuum, c = lambda f and E = hf connect wavelength, frequency, and photon energy. For electrons or other matter particles, lambda = h/p gives the de Broglie wavelength. Bound systems have discrete allowed states rather than a continuous spread of possible energies.',
   'Points come from choosing the correct relation for the object, ranking energy by frequency, ranking wavelength inversely with momentum for matter waves, and explaining quantization as allowed states in a bound system.',
   'Decide whether the object is a photon or a massive particle first; then choose the matching energy, wavelength, and momentum relations.',
   'An electron and a proton have the same speed. Which has the shorter de Broglie wavelength?',
   'They have the same wavelength because they move at the same speed.',
   'The proton has the shorter wavelength. At the same speed it has the larger momentum, and lambda = h/p means larger momentum gives a smaller de Broglie wavelength.',
   'Using lambda = h/p for a photon while also ignoring E = hf, or treating quantization as just a measurement limitation.',
   'Back in practice, label each object as photon or matter before writing an equation.'),
  ('ap_physics_2', 15, '15.2', 'The Bohr Model of Atomic Structure',
   'The Bohr model explains discrete atomic energies by allowing only electron orbits that fit a standing-wave condition around a single-electron atom.',
   'Students need to stay within the model boundary. The Bohr picture can connect radius, standing waves, allowed energies, photons, isotopes, and nuclear notation, but AP Physics 2 does not require orbital shapes, probability functions, or multi-electron orbital detail here.',
   'Points come from stating that only certain states are allowed, connecting transitions to energy differences, and using single-electron energy-level diagrams appropriately.',
   'State the allowed-state idea first, then connect transitions between allowed levels to photon absorption or emission.',
   'Why does the Bohr model allow only certain electron energies in a hydrogen atom?',
   'Because the electron can choose only the path with the strongest electric force.',
   'Only orbits that fit the standing-wave condition are allowed, so the electron has discrete energy states. Transitions between those states involve photons with energies equal to level differences.',
   'Describing modern orbitals or probability clouds when the question is asking for the Bohr-model energy-level picture.',
   'In practice, keep Bohr-model answers tied to allowed states, standing waves, and single-electron level diagrams.'),
  ('ap_physics_2', 15, '15.3', 'Emission and Absorption Spectra',
   'Emission and absorption spectra occur because atomic electrons move between discrete energy levels by emitting or absorbing photons whose energies exactly match level differences.',
   'Students need to distinguish bound-to-bound transitions from ionization. A downward transition emits a photon; an upward transition absorbs one. Larger Delta E means larger photon frequency and shorter wavelength. Element-specific level spacings produce element-specific spectral lines.',
   'Points come from calculating or comparing Delta E, setting Delta E = hf, using c = lambda f when wavelength is needed, and identifying whether the photon is emitted or absorbed.',
   'Write Delta E between the two levels, then set it equal to hf before deciding frequency, wavelength, or direction of transition.',
   'An atom drops from -1.5 eV to -3.4 eV. Is light absorbed or emitted?',
   'It absorbs light because the final energy number is more negative.',
   'It emits light. The atom moves to a lower energy state, so the energy difference leaves as a photon with energy 1.9 eV.',
   'Saying an electron can absorb any photon with enough energy for every bound-to-bound transition.',
   'Back in practice, mark whether the final level is higher or lower before choosing absorption or emission.'),
  ('ap_physics_2', 15, '15.4', 'Blackbody Radiation',
   'A blackbody emits a continuous spectrum whose peak wavelength and total power depend strongly on temperature, and Planck quantization explains the observed spectrum.',
   'Students need to connect formulas to physical trends. Wien law says hotter objects have smaller peak wavelength. Stefan-Boltzmann reasoning says total radiated power increases with the fourth power of absolute temperature for a fixed area and emissivity. The spectrum remains continuous, not a single photon energy.',
   'Points come from predicting shifts in peak wavelength, comparing radiated power using absolute temperature, and explaining why energy quantization was needed to match the radiation curve.',
   'Start with the temperature change; then decide how peak wavelength and total emitted power change.',
   'A metal object is heated from 500 K to 1000 K. What happens to the peak wavelength of its thermal spectrum?',
   'The peak wavelength doubles because the temperature doubles.',
   'The peak wavelength is cut in half. Wien law gives lambda_max proportional to 1/T, so doubling absolute temperature halves the peak wavelength.',
   'Thinking a hotter blackbody emits only one wavelength instead of a continuous spectrum with a shifted peak.',
   'In practice, write hotter means shorter peak wavelength and much larger power before calculating.'),
  ('ap_physics_2', 15, '15.5', 'The Photoelectric Effect',
   'The photoelectric effect supports the photon model because electron emission depends on photon frequency exceeding a threshold, not on total light intensity alone.',
   'Students need to separate frequency effects from intensity effects. Below threshold, no electrons are emitted. Above threshold, higher frequency increases maximum kinetic energy, while greater intensity increases the number of emitted electrons per time. Stopping potential measures maximum kinetic energy per charge.',
   'Points come from checking hf against the work function, applying K_max = hf - phi, connecting stopping potential to energy, and using provided work-function data correctly.',
   'Check the threshold first; if emission occurs, use photon energy minus work function to find maximum kinetic energy.',
   'Light below the threshold frequency shines on a metal for a long time. What happens if the intensity is increased?',
   'Electrons eventually come out because more total energy reaches the metal.',
   'No photoelectrons are emitted if each photon is below the threshold energy. Increasing intensity adds more low-energy photons, but no individual photon has enough energy to overcome the work function.',
   'Saying brighter low-frequency light eventually ejects electrons if the intensity is large enough.',
   'Back in practice, compare hf with phi before discussing brightness or current.'),
  ('ap_physics_2', 15, '15.6', 'Compton Scattering',
   'Compton scattering is a photon-electron collision in which the scattered photon has a longer wavelength because it transfers energy and momentum to the electron.',
   'Students need to keep both energy and momentum in view. The photon still travels at c after scattering, so lower energy means lower frequency and longer wavelength, not lower speed. AP Physics 2 includes qualitative and quantitative 2-D momentum reasoning and the Compton shift formula.',
   'Points come from using vector momentum conservation, recognizing the wavelength shift depends on scattering angle, and linking larger wavelength to lower photon energy after the collision.',
   'Draw before-and-after momentum vectors; then connect the photon wavelength increase to energy transferred to the electron.',
   'After a photon scatters from an electron, its wavelength is larger. What happened to the photon energy?',
   'The energy stayed the same because photons always move at the same speed.',
   'The photon energy decreased. Since E = hf and c = lambda f, a larger wavelength means lower frequency and lower photon energy; the electron received energy and momentum.',
   'Treating the photon as slowing down in vacuum rather than changing frequency and wavelength while still traveling at c.',
   'In practice, write photon speed still c, then compare wavelength, frequency, and energy.'),
  ('ap_physics_2', 15, '15.7', 'Fission, Fusion, and Nuclear Decay',
   'Nuclear processes are constrained by conservation laws, and the energy released or absorbed comes from mass-energy differences in nuclear binding.',
   'Students need to balance nuclear bookkeeping before energy reasoning. Fission splits a heavy nucleus, fusion combines light nuclei, and radioactive decay transforms a nucleus toward a lower-energy state. Half-life models describe how many unstable nuclei remain after time passes.',
   'Points come from conserving charge and nucleon number in reaction equations, using E = mc^2 for mass defect or released energy, and applying exponential decay or half-life relations when given decay data.',
   'Balance nucleon number and charge first; then use mass-energy or exponential decay only after the reaction bookkeeping is consistent.',
   'A sample has a half-life of 6 days. What fraction remains after 18 days?',
   'One third remains because 18 days is three times the half-life.',
   'One eighth remains. Eighteen days is three half-lives, so the remaining fraction is (1/2)^3.',
   'Balancing only electric charge and forgetting nucleon number or emitted particles.',
   'Back in practice, count half-lives or use N = N0e^(-lambda t) only after identifying the decay setup.'),
  ('ap_physics_2', 15, '15.8', 'Types of Radioactive Decay',
   'Different radioactive decay modes have different nuclear bookkeeping: alpha emits a helium-4 nucleus, beta modes change a neutron-proton count with leptons, and gamma changes nuclear energy without changing identity.',
   'Students need to know the included AP decay types and boundaries. Alpha, beta-minus, beta-plus, and gamma are in scope. Neutron emission and electron capture are excluded, and questions do not require memorized isotope-specific decay paths, neutrino-type distinctions, or weak-force mechanism explanations.',
   'Points come from balancing mass number, atomic number, charge, and lepton number while identifying which emitted particle matches the decay mode.',
   'Write the emitted particle symbol first; then balance mass number, atomic number, and lepton number.',
   'A nucleus emits gamma radiation. What happens to its mass number and atomic number?',
   'Both decrease because energy leaves the nucleus.',
   'Neither mass number nor atomic number changes. Gamma decay lowers the energy of the same nucleus without changing the number of protons or nucleons.',
   'Treating gamma decay as changing the element or mass number instead of lowering nuclear energy only.',
   'In practice, make a small balance table for A, Z, charge, and lepton number before naming the daughter nucleus.')
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, status, source_note, published_at
)
select
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, 'published',
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 2 Unit 15 Modern Physics; grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 15: photons with E=hf, lambda=c/f, de Broglie lambda=h/p, wave-particle duality, discrete bound states, Bohr standing-wave states and single-electron energy-level diagrams only, emission and absorption spectra with photon energies matching level differences, blackbody Wien and Stefan-Boltzmann reasoning, photoelectric threshold and K_max=hf-phi with provided work functions, Compton scattering wavelength shift and 2-D momentum reasoning, nuclear conservation laws, E=mc^2, half-life equations, and radioactive decay boundaries including Fall-2026 gamma clarification and exclusions for neutron emission, electron capture, neutrino-type distinctions, weak-force mechanisms, and isotope-specific memorization; batch 2026-08-25-ap-physics-2-unit15-topic-guides; author=reviewer same session, no independent human review yet',
  now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
  title = excluded.title,
  core_idea = excluded.core_idea,
  what_students_need_to_understand = excluded.what_students_need_to_understand,
  how_this_becomes_points = excluded.how_this_becomes_points,
  answer_move = excluded.answer_move,
  mini_example_question = excluded.mini_example_question,
  weak_answer = excluded.weak_answer,
  point_attaining_answer = excluded.point_attaining_answer,
  common_point_loss = excluded.common_point_loss,
  practice_bridge = excluded.practice_bridge,
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_explainers.published_at, excluded.published_at);

do $$
declare
  v_briefs integer;
  v_explainers integer;
  v_pairing_orphans integer;
  v_unit_mismatches integer;
  v_route_mismatches integer;
  v_core_matches integer;
  v_duplicate_explainer_fields integer;
begin
  select count(*) into v_briefs
  from app.topic_point_briefs
  where subject_key = 'ap_physics_2'
    and unit_number = 15
    and topic_code in ('15.1', '15.2', '15.3', '15.4', '15.5', '15.6', '15.7', '15.8')
    and status = 'published';

  if v_briefs <> 8 then
    raise exception 'expected 8 published AP Physics 2 Unit 15 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_2'
    and unit_number = 15
    and topic_code in ('15.1', '15.2', '15.3', '15.4', '15.5', '15.6', '15.7', '15.8')
    and status = 'published';

  if v_explainers <> 8 then
    raise exception 'expected 8 published AP Physics 2 Unit 15 explainers, got %', v_explainers;
  end if;

  select count(*) into v_pairing_orphans
  from (
    select b.subject_key, b.topic_code
    from app.topic_point_briefs b
    left join app.topic_explainers e
      on e.subject_key = b.subject_key
     and e.topic_code = b.topic_code
     and e.status = 'published'
    where b.subject_key = 'ap_physics_2'
      and b.unit_number = 15
      and b.topic_code in ('15.1', '15.2', '15.3', '15.4', '15.5', '15.6', '15.7', '15.8')
      and b.status = 'published'
      and e.topic_code is null
    union all
    select e.subject_key, e.topic_code
    from app.topic_explainers e
    left join app.topic_point_briefs b
      on b.subject_key = e.subject_key
     and b.topic_code = e.topic_code
     and b.status = 'published'
    where e.subject_key = 'ap_physics_2'
      and e.unit_number = 15
      and e.topic_code in ('15.1', '15.2', '15.3', '15.4', '15.5', '15.6', '15.7', '15.8')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 15 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_2'
    and b.topic_code in ('15.1', '15.2', '15.3', '15.4', '15.5', '15.6', '15.7', '15.8')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 15 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_2'
    and b.unit_number = 15
    and b.topic_code in ('15.1', '15.2', '15.3', '15.4', '15.5', '15.6', '15.7', '15.8')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-2/unit-15/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 15 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_2'
    and b.topic_code in ('15.1', '15.2', '15.3', '15.4', '15.5', '15.6', '15.7', '15.8')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 15 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_physics_2'
      and unit_number = 15
      and topic_code in ('15.1', '15.2', '15.3', '15.4', '15.5', '15.6', '15.7', '15.8')
      and status = 'published'
  ),
  field_values as (
    select 'mini_example_question' as field_name, mini_example_question as value from new_explainers
    union all
    select 'weak_answer', weak_answer from new_explainers
    union all
    select 'point_attaining_answer', point_attaining_answer from new_explainers
    union all
    select 'practice_bridge', practice_bridge from new_explainers
  )
  select count(*) into v_duplicate_explainer_fields
  from field_values fv
  join app.topic_explainers e
    on (
      e.mini_example_question = fv.value
      or e.weak_answer = fv.value
      or e.point_attaining_answer = fv.value
      or e.practice_bridge = fv.value
    )
  where e.status = 'published'
    and not (
      e.subject_key = 'ap_physics_2'
      and e.unit_number = 15
      and e.topic_code in ('15.1', '15.2', '15.3', '15.4', '15.5', '15.6', '15.7', '15.8')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 15 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
