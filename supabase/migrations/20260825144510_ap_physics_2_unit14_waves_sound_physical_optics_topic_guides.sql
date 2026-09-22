begin;

-- Add AP Physics 2 Unit 14 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 9 AP Physics 2 Unit 14 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_2_CED_FACT_PACK.md Unit 14 (Waves,
-- Sound, and Physical Optics). The fact pack confirms wave energy transfer,
-- mechanical/EM wave distinctions, periodic-wave quantities, boundary behavior,
-- polarization, EM spectrum ordering, qualitative-only Doppler effect, wave
-- interference, standing waves, diffraction, double-slit interference and
-- diffraction gratings, thin-film interference, normal-incidence quantitative
-- thin-film boundary, and the 2025 double-slit misconception trail.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_physics_2', 14, '14.1', 'Properties of Wave Pulses and Waves', 'very-important', 'very-important',
   'Waves transfer energy without transferring matter. Mechanical waves require a medium; electromagnetic waves do not.',
   'This is the vocabulary foundation for sound, light, and physical optics. Wave type, medium, amplitude, and energy decide which model applies.',
   'You earn points by identifying transverse versus longitudinal motion, medium requirements, amplitude meaning, and how wave speed depends on medium properties.',
   'Name the wave type and medium first; then connect amplitude to energy and speed to the medium rather than to how hard the source shakes.',
   'Saying the medium travels with the wave instead of saying energy travels through the medium.',
   '/learn/ap-physics-2/unit-14/properties-of-wave-pulses-and-waves'),
  ('ap_physics_2', 14, '14.2', 'Periodic Waves', 'very-important', 'very-important',
   'Periodic waves repeat with period T, frequency f, wavelength lambda, and speed v. The core relation is lambda = v/f.',
   'Periodic-wave representations connect graphs, sound pitch, light color, and later interference spacing. Frequency and wavelength must be tracked through the medium.',
   'You earn points by reading amplitude, period, frequency, and wavelength from graphs, using T = 1/f and lambda = v/f, and not tying amplitude to frequency.',
   'Decide whether the graph is displacement-vs-time or displacement-vs-position before reading period or wavelength.',
   'Reading wavelength from a time graph or period from a position graph.',
   '/learn/ap-physics-2/unit-14/periodic-waves'),
  ('ap_physics_2', 14, '14.3', 'Boundary Behavior of Waves and Polarization', 'very-important', 'very-important',
   'At a boundary, waves may reflect, transmit, invert, refract, or become polarized. Frequency stays the same when a wave crosses into a new medium.',
   'Boundary behavior explains why wave speed and wavelength can change while frequency does not. Polarization also separates transverse waves from longitudinal waves.',
   'You earn points by comparing wave speeds across media, deciding whether reflected pulses invert, conserving frequency across boundaries, and applying polarization only to transverse waves.',
   'At a boundary, keep frequency fixed first; then decide how speed and wavelength change in the transmitted medium.',
   'Changing frequency when a wave enters a new medium.',
   '/learn/ap-physics-2/unit-14/boundary-behavior-of-waves-and-polarization'),
  ('ap_physics_2', 14, '14.4', 'Electromagnetic Waves', 'very-important', 'very-important',
   'Electromagnetic waves are transverse oscillating electric and magnetic fields that can travel through vacuum at c and are ordered by wavelength across the EM spectrum.',
   'This topic connects light color, spectrum ordering, and later photon ideas. AP Physics 2 expects spectrum order, not exact wavelength-range memorization.',
   'You earn points by ordering EM categories and visible colors by wavelength or frequency, using c = lambda f in vacuum, and remembering EM waves do not need a medium.',
   'Use wavelength and frequency as inverse rankings: longer wavelength means lower frequency for EM waves in vacuum.',
   'Putting violet at the long-wavelength end of visible light or treating EM waves as requiring a medium.',
   '/learn/ap-physics-2/unit-14/electromagnetic-waves'),
  ('ap_physics_2', 14, '14.5', 'The Doppler Effect', 'somewhat-important', 'somewhat-important',
   'The Doppler effect is a qualitative frequency shift caused by source-observer relative motion: approaching raises observed frequency; receding lowers it.',
   'It links wave observations to motion without requiring a Doppler equation in AP Physics 2. The direction of relative motion is the point-earning feature.',
   'You earn points by comparing observed and source frequency qualitatively and relating larger relative speed to a larger frequency difference.',
   'Ask whether source and observer move toward or away from each other; then state whether observed frequency is higher, lower, or unchanged.',
   'Trying to use a memorized Doppler formula or reversing approaching and receding shifts.',
   '/learn/ap-physics-2/unit-14/the-doppler-effect'),
  ('ap_physics_2', 14, '14.6', 'Wave Interference and Standing Waves', 'very-important', 'very-important',
   'Interference superposes overlapping waves. Standing waves form from opposite-traveling waves in a confined region, producing nodes and antinodes.',
   'This topic connects wave addition, beats, harmonics, strings, and pipes. Boundary conditions decide which standing wavelengths are allowed.',
   'You earn points by adding displacements, distinguishing constructive/destructive interference, identifying nodes/antinodes, and matching harmonics to boundary conditions.',
   'Mark the boundary conditions first; then locate nodes and antinodes before naming the harmonic.',
   'Treating every standing-wave pattern as if all integer harmonics are allowed, including node-antinode systems.',
   '/learn/ap-physics-2/unit-14/wave-interference-and-standing-waves'),
  ('ap_physics_2', 14, '14.7', 'Diffraction', 'very-important', 'very-important',
   'Diffraction is wave spreading around obstacles or through openings, strongest when the opening size is comparable to wavelength.',
   'Diffraction is the wave behavior geometric optics cannot explain. Single-opening diffraction produces minima from path-length differences across the opening.',
   'You earn points by relating spreading to opening size versus wavelength and using a sin(theta) or small-angle relations for minima when quantitative information is required.',
   'Compare opening width to wavelength first; then use the path-difference condition for dark bands in a single-opening pattern.',
   'Saying narrower openings make less diffraction because less light gets through.',
   '/learn/ap-physics-2/unit-14/diffraction'),
  ('ap_physics_2', 14, '14.8', 'Double-Slit Interference and Diffraction Gratings', 'very-important', 'very-important',
   'Double-slit and grating patterns come from path-length differences between coherent light from multiple openings. Bright maxima occur where waves arrive in phase.',
   'This is a released-exam optics target. Fringe spacing depends on wavelength, slit spacing, and screen distance, and real double-slit patterns sit inside a diffraction envelope.',
   'You earn points by using d sin(theta) or d y/L path-difference reasoning, connecting larger wavelength to larger spacing, and not confusing maximum order with adjacent-fringe spacing.',
   'Write the path-length difference first; then connect constructive interference to integer multiples of wavelength.',
   'Using slit spacing as if it were the path-length difference at the screen.',
   '/learn/ap-physics-2/unit-14/double-slit-interference-and-diffraction-gratings'),
  ('ap_physics_2', 14, '14.9', 'Thin-Film Interference', 'very-important', 'somewhat-important',
   'Thin-film interference comes from two reflected rays that may gain phase shifts at boundaries and travel different distances through a film.',
   'It explains soap-bubble colors and antireflection coatings. Phase change depends on whether reflection occurs from a higher-index boundary, and quantitative treatment is normal-incidence only.',
   'You earn points by tracking both reflected rays, identifying 180-degree phase shifts at higher-index reflections, including film-thickness path difference, and staying within normal-incidence quantitative scope.',
   'List the two reflected rays, mark any phase flip at each boundary, then compare their total phase difference.',
   'Ignoring phase changes at reflection and using only the extra distance through the film.',
   '/learn/ap-physics-2/unit-14/thin-film-interference')
),
explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  ('ap_physics_2', 14, '14.1', 'Properties of Wave Pulses and Waves',
   'A wave is an energy-transfer pattern. The disturbance moves through space, but the medium particles mainly oscillate around equilibrium rather than traveling with the wave across the whole distance.',
   'Students need to distinguish mechanical waves from electromagnetic waves. Sound is a longitudinal mechanical wave with compressions and rarefactions, while light is an electromagnetic transverse wave that does not require a medium. Amplitude connects to wave energy and loudness for sound.',
   'Points come from naming the wave type, identifying whether a medium is required, and describing the disturbance direction relative to propagation. For string waves, speed depends on tension and mass per length; for sound, medium properties such as temperature matter.',
   'Name the wave type and medium first; then connect amplitude to energy and speed to the medium rather than to how hard the source shakes.',
   'A pulse travels along a rope from left to right. Does the rope material move all the way to the right with the pulse?',
   'Yes, the rope material travels right because the pulse travels right.',
   'No. The pulse transfers energy to the right, but each bit of rope is displaced from equilibrium and then returns. The medium does not travel across the room with the wave.',
   'Saying the medium travels with the wave instead of saying energy travels through the medium.',
   'Back in practice, separate propagation direction from particle motion direction before classifying the wave.'),
  ('ap_physics_2', 14, '14.2', 'Periodic Waves',
   'Periodic waves are described by repeated spatial and temporal patterns. Period and frequency come from time behavior, wavelength comes from position behavior, and wave speed connects them through lambda = v/f.',
   'Students need to inspect what each graph axis shows. A displacement-time graph at one point gives period and frequency. A displacement-position graph at one instant gives wavelength. Amplitude can be read from either but does not set period or frequency by itself.',
   'Points come from reading the right quantity from the right graph, converting T and f, applying lambda = v/f, and explaining pitch or color changes using frequency rather than amplitude.',
   'Decide whether the graph is displacement-vs-time or displacement-vs-position before reading period or wavelength.',
   'A graph shows displacement versus time for one point on a string. The time between peaks is 0.20 s. What quantity is 0.20 s?',
   'It is the wavelength because it is the distance between peaks.',
   'It is the period, because the horizontal axis is time. The frequency is f = 1/T = 5 Hz. Wavelength would need a displacement-versus-position graph or wave speed information.',
   'Reading wavelength from a time graph or period from a position graph.',
   'In practice, circle the graph axis label before extracting a wave quantity.'),
  ('ap_physics_2', 14, '14.3', 'Boundary Behavior of Waves and Polarization',
   'When a wave crosses a boundary, frequency is set by the source and stays the same, while speed and wavelength may change. Reflection behavior depends on the boundary, and only transverse waves can be polarized.',
   'Students need to reason from speed and boundary conditions. A string pulse reflecting from a boundary can invert depending on the effective change in wave speed. A light wave entering a new material keeps frequency but changes wavelength because its speed changes.',
   'Points come from conserving frequency across the boundary, using v = lambda f to decide wavelength change, identifying inversion or noninversion of reflected pulses, and applying polarization only to transverse waves.',
   'At a boundary, keep frequency fixed first; then decide how speed and wavelength change in the transmitted medium.',
   'Light enters glass from air and slows down. What happens to its frequency and wavelength?',
   'Both frequency and wavelength decrease because the light slows down.',
   'The frequency stays the same because it is set by the source. Since v = lambda f and speed decreases while frequency is unchanged, the wavelength decreases in the glass.',
   'Changing frequency when a wave enters a new medium.',
   'Back in practice, write "same f" at every boundary before using v = lambda f.'),
  ('ap_physics_2', 14, '14.4', 'Electromagnetic Waves',
   'Electromagnetic waves are transverse electric and magnetic field oscillations. In vacuum they travel at c, and spectrum order can be ranked by wavelength or frequency.',
   'Students need to know ordering without memorizing exact wavelength ranges. Radio has longer wavelength and lower frequency than microwave, infrared, visible, ultraviolet, X-ray, and gamma. Within visible light, red has longer wavelength than violet.',
   'Points come from correctly ordering spectrum regions, using c = lambda f, identifying light as electromagnetic radiation, and knowing EM waves do not need a material medium.',
   'Use wavelength and frequency as inverse rankings: longer wavelength means lower frequency for EM waves in vacuum.',
   'Which visible color has the longer wavelength, red or violet?',
   'Violet, because it has more energy and should have a longer wavelength.',
   'Red has the longer wavelength. Violet has higher frequency and higher photon energy, but for light in vacuum c = lambda f, so higher frequency means shorter wavelength.',
   'Putting violet at the long-wavelength end of visible light or treating EM waves as requiring a medium.',
   'In practice, write red-long/low and violet-short/high as an ordering check before comparing colors.'),
  ('ap_physics_2', 14, '14.5', 'The Doppler Effect',
   'The Doppler effect is a qualitative observed-frequency shift caused by relative motion between source and observer. Motion toward each other raises observed frequency; motion away lowers observed frequency.',
   'Students need to avoid treating this as a formula-heavy AP Physics 2 topic. The CED requires qualitative treatment only, so the important move is direction of relative motion and whether the observed frequency is above, below, or equal to the source rest frequency.',
   'Points come from stating the relative motion, comparing observed frequency to source frequency, and noting that larger relative speed makes the shift larger. No Doppler equation is needed.',
   'Ask whether source and observer move toward or away from each other; then state whether observed frequency is higher, lower, or unchanged.',
   'An ambulance siren moves toward a stationary observer. How does the observed pitch compare with the source pitch?',
   'The observed pitch is lower because the sound waves are left behind the ambulance.',
   'The observed pitch is higher. As the source moves toward the observer, wavefronts arrive more frequently, so observed frequency and pitch increase relative to the source rest frequency.',
   'Trying to use a memorized Doppler formula or reversing approaching and receding shifts.',
   'Back in practice, draw one arrow for source motion and one for observer position. Toward means higher observed frequency; away means lower.'),
  ('ap_physics_2', 14, '14.6', 'Wave Interference and Standing Waves',
   'Interference is displacement addition when waves overlap. Standing waves are stable interference patterns from waves traveling in opposite directions within boundaries, with nodes and antinodes fixed in place.',
   'Students need to use boundary conditions. A string fixed at both ends has nodes at both ends; a pipe open at one end and closed at the other has an antinode at the open end and node at the closed end, allowing only odd harmonics.',
   'Points come from adding displacements for interference, identifying constructive/destructive cases, marking nodes and antinodes, and matching possible harmonics to the physical boundary conditions.',
   'Mark the boundary conditions first; then locate nodes and antinodes before naming the harmonic.',
   'A standing wave has a node at one end and an antinode at the other. Are all integer harmonics allowed?',
   'Yes. Every standing wave system can have first, second, third, and all higher harmonics.',
   'No. A node-antinode system supports only odd harmonics. The boundary conditions require one end to remain a node and the other to remain an antinode, which eliminates the even-harmonic patterns.',
   'Treating every standing-wave pattern as if all integer harmonics are allowed, including node-antinode systems.',
   'In practice, label each end N or A before counting loops or naming harmonics.'),
  ('ap_physics_2', 14, '14.7', 'Diffraction',
   'Diffraction is wave spreading through an opening or around an edge. It becomes more noticeable when the opening size is close to the wavelength, and a single opening can produce an interference pattern with dark minima.',
   'Students need to connect geometry to path difference. For a slit of width a, path-length difference across the opening is a sin(theta). With small angles, the position of minima on a distant screen follows a y_min/L approximately equal to m lambda.',
   'Points come from comparing opening size with wavelength, identifying greater spreading for smaller openings or longer wavelengths, and using the single-slit minimum condition when asked quantitatively.',
   'Compare opening width to wavelength first; then use the path-difference condition for dark bands in a single-opening pattern.',
   'A wave passes through a slit whose width is made smaller but still comparable to the wavelength. What happens to spreading?',
   'Spreading decreases because less of the wave fits through the slit.',
   'Spreading increases. Diffraction is most pronounced when the opening is comparable to the wavelength, and making the opening smaller relative to wavelength produces a wider spread.',
   'Saying narrower openings make less diffraction because less light gets through.',
   'Back in practice, compare a to lambda before making any statement about spreading.'),
  ('ap_physics_2', 14, '14.8', 'Double-Slit Interference and Diffraction Gratings',
   'Double-slit interference comes from path-length differences between light from two coherent slits. Constructive interference occurs when the path difference is an integer multiple of wavelength, producing bright fringes.',
   'Students need to distinguish path-length difference from physical slit spacing and from fringe spacing. The 2025 FRQ evidence flags path-length-difference and maximum-order spacing confusions as real AP failure modes.',
   'Points come from writing Delta D = d sin(theta), using the small-angle relation d y/L approximately equals m lambda for maxima, and explaining how wavelength, slit spacing, and screen distance affect fringe spacing.',
   'Write the path-length difference first; then connect constructive interference to integer multiples of wavelength.',
   'In a double-slit setup, a bright fringe occurs at order m. What path-length difference condition should be used?',
   'Use d = m lambda because slit spacing is the path-length difference.',
   'Use Delta D = d sin(theta) = m lambda. The slit spacing d is the distance between slits, not automatically the path-length difference to a point on the screen. The screen position sets theta and therefore Delta D.',
   'Using slit spacing as if it were the path-length difference at the screen.',
   'In practice, write Delta D on its own line before substituting d, y, L, or m.'),
  ('ap_physics_2', 14, '14.9', 'Thin-Film Interference',
   'Thin-film interference depends on two reflected rays, possible 180-degree phase changes at reflections, and the extra path traveled inside a film whose thickness is comparable to wavelength.',
   'Students need to track phase at both boundaries. Reflection from a higher-index medium gives a 180-degree phase change; reflection from a lower-index medium does not. Refraction itself does not change phase. Quantitative AP Physics 2 thin-film analysis is limited to normal incidence.',
   'Points come from identifying the two reflected rays, marking any phase flips, adding path difference through the film, and using film wavelength rather than vacuum wavelength when appropriate.',
   'List the two reflected rays, mark any phase flip at each boundary, then compare their total phase difference.',
   'A ray in air reflects from the top of a thin film with higher refractive index, while another ray reflects from the lower boundary. Why is phase tracking needed?',
   'Only the extra distance through the film matters; reflection never changes phase.',
   'The top reflection from lower index air to higher index film gains a 180-degree phase change. The lower reflection may or may not gain one depending on the next medium index. Thin-film interference depends on both reflection phase changes and path difference through the film.',
   'Ignoring phase changes at reflection and using only the extra distance through the film.',
   'Back in practice, make a two-row table for the two reflected rays: phase change, path length, and wavelength in the film.')
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 2 Unit 14 Waves, Sound, and Physical Optics; grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 14: wave energy transfer without matter transfer, mechanical versus electromagnetic waves, periodic-wave quantities and lambda=v/f, boundary behavior and unchanged frequency, polarization, EM spectrum ordering without exact ranges, qualitative-only Doppler effect, superposition/interference/beats/standing waves, diffraction and single-slit minima, double-slit interference and diffraction gratings, 2025 double-slit path-length-difference misconception evidence, thin-film phase shifts, and normal-incidence quantitative thin-film boundary; batch 2026-08-25-ap-physics-2-unit14-topic-guides; author=reviewer same session, no independent human review yet',
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
  ('ap_physics_2', 14, '14.1', 'Properties of Wave Pulses and Waves',
   'A wave is an energy-transfer pattern. The disturbance moves through space, but the medium particles mainly oscillate around equilibrium rather than traveling with the wave across the whole distance.',
   'Students need to distinguish mechanical waves from electromagnetic waves. Sound is a longitudinal mechanical wave with compressions and rarefactions, while light is an electromagnetic transverse wave that does not require a medium. Amplitude connects to wave energy and loudness for sound.',
   'Points come from naming the wave type, identifying whether a medium is required, and describing the disturbance direction relative to propagation. For string waves, speed depends on tension and mass per length; for sound, medium properties such as temperature matter.',
   'Name the wave type and medium first; then connect amplitude to energy and speed to the medium rather than to how hard the source shakes.',
   'A pulse travels along a rope from left to right. Does the rope material move all the way to the right with the pulse?',
   'Yes, the rope material travels right because the pulse travels right.',
   'No. The pulse transfers energy to the right, but each bit of rope is displaced from equilibrium and then returns. The medium does not travel across the room with the wave.',
   'Saying the medium travels with the wave instead of saying energy travels through the medium.',
   'Back in practice, separate propagation direction from particle motion direction before classifying the wave.'),
  ('ap_physics_2', 14, '14.2', 'Periodic Waves',
   'Periodic waves are described by repeated spatial and temporal patterns. Period and frequency come from time behavior, wavelength comes from position behavior, and wave speed connects them through lambda = v/f.',
   'Students need to inspect what each graph axis shows. A displacement-time graph at one point gives period and frequency. A displacement-position graph at one instant gives wavelength. Amplitude can be read from either but does not set period or frequency by itself.',
   'Points come from reading the right quantity from the right graph, converting T and f, applying lambda = v/f, and explaining pitch or color changes using frequency rather than amplitude.',
   'Decide whether the graph is displacement-vs-time or displacement-vs-position before reading period or wavelength.',
   'A graph shows displacement versus time for one point on a string. The time between peaks is 0.20 s. What quantity is 0.20 s?',
   'It is the wavelength because it is the distance between peaks.',
   'It is the period, because the horizontal axis is time. The frequency is f = 1/T = 5 Hz. Wavelength would need a displacement-versus-position graph or wave speed information.',
   'Reading wavelength from a time graph or period from a position graph.',
   'In practice, circle the graph axis label before extracting a wave quantity.'),
  ('ap_physics_2', 14, '14.3', 'Boundary Behavior of Waves and Polarization',
   'When a wave crosses a boundary, frequency is set by the source and stays the same, while speed and wavelength may change. Reflection behavior depends on the boundary, and only transverse waves can be polarized.',
   'Students need to reason from speed and boundary conditions. A string pulse reflecting from a boundary can invert depending on the effective change in wave speed. A light wave entering a new material keeps frequency but changes wavelength because its speed changes.',
   'Points come from conserving frequency across the boundary, using v = lambda f to decide wavelength change, identifying inversion or noninversion of reflected pulses, and applying polarization only to transverse waves.',
   'At a boundary, keep frequency fixed first; then decide how speed and wavelength change in the transmitted medium.',
   'Light enters glass from air and slows down. What happens to its frequency and wavelength?',
   'Both frequency and wavelength decrease because the light slows down.',
   'The frequency stays the same because it is set by the source. Since v = lambda f and speed decreases while frequency is unchanged, the wavelength decreases in the glass.',
   'Changing frequency when a wave enters a new medium.',
   'Back in practice, write "same f" at every boundary before using v = lambda f.'),
  ('ap_physics_2', 14, '14.4', 'Electromagnetic Waves',
   'Electromagnetic waves are transverse electric and magnetic field oscillations. In vacuum they travel at c, and spectrum order can be ranked by wavelength or frequency.',
   'Students need to know ordering without memorizing exact wavelength ranges. Radio has longer wavelength and lower frequency than microwave, infrared, visible, ultraviolet, X-ray, and gamma. Within visible light, red has longer wavelength than violet.',
   'Points come from correctly ordering spectrum regions, using c = lambda f, identifying light as electromagnetic radiation, and knowing EM waves do not need a material medium.',
   'Use wavelength and frequency as inverse rankings: longer wavelength means lower frequency for EM waves in vacuum.',
   'Which visible color has the longer wavelength, red or violet?',
   'Violet, because it has more energy and should have a longer wavelength.',
   'Red has the longer wavelength. Violet has higher frequency and higher photon energy, but for light in vacuum c = lambda f, so higher frequency means shorter wavelength.',
   'Putting violet at the long-wavelength end of visible light or treating EM waves as requiring a medium.',
   'In practice, write red-long/low and violet-short/high as an ordering check before comparing colors.'),
  ('ap_physics_2', 14, '14.5', 'The Doppler Effect',
   'The Doppler effect is a qualitative observed-frequency shift caused by relative motion between source and observer. Motion toward each other raises observed frequency; motion away lowers observed frequency.',
   'Students need to avoid treating this as a formula-heavy AP Physics 2 topic. The CED requires qualitative treatment only, so the important move is direction of relative motion and whether the observed frequency is above, below, or equal to the source rest frequency.',
   'Points come from stating the relative motion, comparing observed frequency to source frequency, and noting that larger relative speed makes the shift larger. No Doppler equation is needed.',
   'Ask whether source and observer move toward or away from each other; then state whether observed frequency is higher, lower, or unchanged.',
   'An ambulance siren moves toward a stationary observer. How does the observed pitch compare with the source pitch?',
   'The observed pitch is lower because the sound waves are left behind the ambulance.',
   'The observed pitch is higher. As the source moves toward the observer, wavefronts arrive more frequently, so observed frequency and pitch increase relative to the source rest frequency.',
   'Trying to use a memorized Doppler formula or reversing approaching and receding shifts.',
   'Back in practice, draw one arrow for source motion and one for observer position. Toward means higher observed frequency; away means lower.'),
  ('ap_physics_2', 14, '14.6', 'Wave Interference and Standing Waves',
   'Interference is displacement addition when waves overlap. Standing waves are stable interference patterns from waves traveling in opposite directions within boundaries, with nodes and antinodes fixed in place.',
   'Students need to use boundary conditions. A string fixed at both ends has nodes at both ends; a pipe open at one end and closed at the other has an antinode at the open end and node at the closed end, allowing only odd harmonics.',
   'Points come from adding displacements for interference, identifying constructive/destructive cases, marking nodes and antinodes, and matching possible harmonics to the physical boundary conditions.',
   'Mark the boundary conditions first; then locate nodes and antinodes before naming the harmonic.',
   'A standing wave has a node at one end and an antinode at the other. Are all integer harmonics allowed?',
   'Yes. Every standing wave system can have first, second, third, and all higher harmonics.',
   'No. A node-antinode system supports only odd harmonics. The boundary conditions require one end to remain a node and the other to remain an antinode, which eliminates the even-harmonic patterns.',
   'Treating every standing-wave pattern as if all integer harmonics are allowed, including node-antinode systems.',
   'In practice, label each end N or A before counting loops or naming harmonics.'),
  ('ap_physics_2', 14, '14.7', 'Diffraction',
   'Diffraction is wave spreading through an opening or around an edge. It becomes more noticeable when the opening size is close to the wavelength, and a single opening can produce an interference pattern with dark minima.',
   'Students need to connect geometry to path difference. For a slit of width a, path-length difference across the opening is a sin(theta). With small angles, the position of minima on a distant screen follows a y_min/L approximately equal to m lambda.',
   'Points come from comparing opening size with wavelength, identifying greater spreading for smaller openings or longer wavelengths, and using the single-slit minimum condition when asked quantitatively.',
   'Compare opening width to wavelength first; then use the path-difference condition for dark bands in a single-opening pattern.',
   'A wave passes through a slit whose width is made smaller but still comparable to the wavelength. What happens to spreading?',
   'Spreading decreases because less of the wave fits through the slit.',
   'Spreading increases. Diffraction is most pronounced when the opening is comparable to the wavelength, and making the opening smaller relative to wavelength produces a wider spread.',
   'Saying narrower openings make less diffraction because less light gets through.',
   'Back in practice, compare a to lambda before making any statement about spreading.'),
  ('ap_physics_2', 14, '14.8', 'Double-Slit Interference and Diffraction Gratings',
   'Double-slit interference comes from path-length differences between light from two coherent slits. Constructive interference occurs when the path difference is an integer multiple of wavelength, producing bright fringes.',
   'Students need to distinguish path-length difference from physical slit spacing and from fringe spacing. The 2025 FRQ evidence flags path-length-difference and maximum-order spacing confusions as real AP failure modes.',
   'Points come from writing Delta D = d sin(theta), using the small-angle relation d y/L approximately equals m lambda for maxima, and explaining how wavelength, slit spacing, and screen distance affect fringe spacing.',
   'Write the path-length difference first; then connect constructive interference to integer multiples of wavelength.',
   'In a double-slit setup, a bright fringe occurs at order m. What path-length difference condition should be used?',
   'Use d = m lambda because slit spacing is the path-length difference.',
   'Use Delta D = d sin(theta) = m lambda. The slit spacing d is the distance between slits, not automatically the path-length difference to a point on the screen. The screen position sets theta and therefore Delta D.',
   'Using slit spacing as if it were the path-length difference at the screen.',
   'In practice, write Delta D on its own line before substituting d, y, L, or m.'),
  ('ap_physics_2', 14, '14.9', 'Thin-Film Interference',
   'Thin-film interference depends on two reflected rays, possible 180-degree phase changes at reflections, and the extra path traveled inside a film whose thickness is comparable to wavelength.',
   'Students need to track phase at both boundaries. Reflection from a higher-index medium gives a 180-degree phase change; reflection from a lower-index medium does not. Refraction itself does not change phase. Quantitative AP Physics 2 thin-film analysis is limited to normal incidence.',
   'Points come from identifying the two reflected rays, marking any phase flips, adding path difference through the film, and using film wavelength rather than vacuum wavelength when appropriate.',
   'List the two reflected rays, mark any phase flip at each boundary, then compare their total phase difference.',
   'A ray in air reflects from the top of a thin film with higher refractive index, while another ray reflects from the lower boundary. Why is phase tracking needed?',
   'Only the extra distance through the film matters; reflection never changes phase.',
   'The top reflection from lower index air to higher index film gains a 180-degree phase change. The lower reflection may or may not gain one depending on the next medium index. Thin-film interference depends on both reflection phase changes and path difference through the film.',
   'Ignoring phase changes at reflection and using only the extra distance through the film.',
   'Back in practice, make a two-row table for the two reflected rays: phase change, path length, and wavelength in the film.')
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 2 Unit 14 Waves, Sound, and Physical Optics; grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 14: wave energy transfer without matter transfer, mechanical versus electromagnetic waves, periodic-wave quantities and lambda=v/f, boundary behavior and unchanged frequency, polarization, EM spectrum ordering without exact ranges, qualitative-only Doppler effect, superposition/interference/beats/standing waves, diffraction and single-slit minima, double-slit interference and diffraction gratings, 2025 double-slit path-length-difference misconception evidence, thin-film phase shifts, and normal-incidence quantitative thin-film boundary; batch 2026-08-25-ap-physics-2-unit14-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 14
    and topic_code in ('14.1', '14.2', '14.3', '14.4', '14.5', '14.6', '14.7', '14.8', '14.9')
    and status = 'published';

  if v_briefs <> 9 then
    raise exception 'expected 9 published AP Physics 2 Unit 14 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_2'
    and unit_number = 14
    and topic_code in ('14.1', '14.2', '14.3', '14.4', '14.5', '14.6', '14.7', '14.8', '14.9')
    and status = 'published';

  if v_explainers <> 9 then
    raise exception 'expected 9 published AP Physics 2 Unit 14 explainers, got %', v_explainers;
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
      and b.unit_number = 14
      and b.topic_code in ('14.1', '14.2', '14.3', '14.4', '14.5', '14.6', '14.7', '14.8', '14.9')
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
      and e.unit_number = 14
      and e.topic_code in ('14.1', '14.2', '14.3', '14.4', '14.5', '14.6', '14.7', '14.8', '14.9')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 14 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_2'
    and b.topic_code in ('14.1', '14.2', '14.3', '14.4', '14.5', '14.6', '14.7', '14.8', '14.9')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 14 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_2'
    and b.unit_number = 14
    and b.topic_code in ('14.1', '14.2', '14.3', '14.4', '14.5', '14.6', '14.7', '14.8', '14.9')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-2/unit-14/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 14 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_2'
    and b.topic_code in ('14.1', '14.2', '14.3', '14.4', '14.5', '14.6', '14.7', '14.8', '14.9')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 14 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_physics_2'
      and unit_number = 14
      and topic_code in ('14.1', '14.2', '14.3', '14.4', '14.5', '14.6', '14.7', '14.8', '14.9')
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
      and e.unit_number = 14
      and e.topic_code in ('14.1', '14.2', '14.3', '14.4', '14.5', '14.6', '14.7', '14.8', '14.9')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 14 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
