begin;

-- Repair AP Physics 2 Unit 9 (Thermodynamics) Learn More explainers
-- -- all 6 were template-generated debt (core_idea byte-identical to their
-- paired brief's what_it_is, and mini_example_question/weak_answer sharing
-- the boilerplate: "A physics prompt gives a scenario involving <Title>. What
-- should your response show to earn credit?" and "I would plug into a
-- formula without defining the quantities or direction." respectively) per
-- the 2026-08-21 bulk audit. Confirmed via SQL before authoring: all 6 rows
-- carried source_note 'generated-from-brief:legacy; grandfathered-2026-08-21'
-- with no "repaired" marker, and a direct read of the current rows showed
-- core_idea byte-identical to the paired brief's what_it_is on every row,
-- plus the exact boilerplate mini_example_question and weak_answer on every
-- row -- so all 6 are genuine debt; none were an outlier that already had
-- hand-authored content. This is the first AP Physics 2 repair batch (AP
-- Physics 2's taxonomy has no Units 1-8; Unit 9, Thermodynamics, is its
-- lowest-numbered unit). Briefs for this unit are genuinely hand-authored
-- and correct; NOT touched here -- only app.topic_explainers is repaired.
--
-- Grounded in docs/product/AP_PHYSICS_2_CED_FACT_PACK.md Unit 9 section
-- (starting line 106, "Unit 9 -- Thermodynamics"): 9.1's quantitative
-- relation K_avg = (3/2)k_BT = (1/2)mv_rms^2 plus the verbatim boundary
-- statement that this course expects quantitative collision analysis in one
-- and two dimensions but never the Maxwell-Boltzmann distribution's actual
-- functional form (only qualitative shape-reading), applied to a
-- two-temperature worked example that deliberately tests the v_rms ~
-- sqrt(T) scaling (not a naive doubling); 9.2's fact that the ideal gas law
-- has two equivalent forms, PV = nRT and PV = Nk_BT, applied to a
-- constant-volume Celsius-to-kelvin worked example; 9.3's atomic-collision
-- probability explanation for why energy transfers hot-to-cold (a higher-
-- energy atom is statistically more likely to hand off energy than the
-- reverse; equilibrium is the most probable outcome of many collisions, not
-- an absolute one), applied to a two-block-in-contact conceptual worked
-- example; 9.4's fact that a monatomic ideal gas's internal energy is
-- U = (3/2)nRT = (3/2)Nk_BT with explicitly zero internal potential energy
-- (ideal-gas atoms don't interact via conservative forces and have no
-- internal structure), applied to a constant-pressure compression PV-diagram
-- worked example that isolates the W = -PdeltaV sign convention; 9.5's
-- explicit conductive-rate formula Q/deltat = kAdeltaT/L, applied to a
-- two-substance calorimetry worked example; and 9.6's fact that entropy is a
-- state function depending only on current configuration (not history) with
-- maximum entropy at thermodynamic equilibrium, plus the verbatim boundary
-- statement restricting Unit 9 to qualitative-only entropy treatment,
-- applied to a coffee-cooling worked example distinguishing an isolated
-- system's entropy from a non-isolated sub-part's entropy. All
-- thermodynamics algebra and computed numbers were independently verified
-- during authoring (e.g. 9.1's K_avg values at 300 K/600 K and the sqrt(2)
-- v_rms scaling; 9.2's kelvin-converted final temperature; 9.4's deltaV,
-- work, and internal-energy-change values; 9.5's two-substance equilibrium
-- temperature); no physics facts or computed numbers required correction
-- after this independent check, and no derivative/integral notation appears
-- anywhere (this is an algebra-based course, matching the AP Physics 1
-- Unit 3 repair's voice, not a calculus-based one).
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Physics 2 Unit 9); the pre-repair
-- content is fully recoverable from git history for this table's rows if a
-- rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4 --
-- the Unit 9 briefs already carry specific, correct, non-templated
-- point-earning language, so no refinement was needed.
-- mini_example_question/weak_answer/point_attaining_answer/practice_bridge
-- are original per-row text that was checked corpus-wide before this
-- migration was written and repeats nowhere else in the published corpus
-- (zero collisions found against every published row's matching field,
-- including a specific check against the known template boilerplate
-- weak_answer string, which the check confirmed still appears only on rows
-- this batch does not touch).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('9.1',
   'Temperature connects to atomic motion quantitatively through K_avg = (3/2)k_BT = (1/2)mv_rms^2, letting you convert between a gas''s temperature and the average (root-mean-square) kinetic energy of its atoms. This course does expect quantitative analysis of individual collisions in one and two dimensions, using the same momentum- and energy-conservation tools as any other collision problem -- it only excludes the Maxwell-Boltzmann distribution''s actual mathematical functional form, requiring just qualitative reading of its shape (peak location, spread, high-speed tail).',
   'Temperature and speed don''t scale the same way -- because K_avg is proportional to T but proportional to v_rms^2, doubling the temperature does not double the typical atomic speed, and questions are built to catch students who assume it does.',
   'Points come from correctly relating average kinetic energy to temperature using K_avg = (3/2)k_BT, recognizing that v_rms scales with the square root of temperature rather than temperature itself, and describing (never calculating) how a Maxwell-Boltzmann curve''s peak and spread shift with temperature.',
   'When asked to compare two Maxwell-Boltzmann curves or describe how one changes with temperature, describe the shift and spread in words (peak moves to higher speed, curve flattens and widens) -- do not attempt to state or use a mathematical formula for the distribution itself, since this course only requires qualitative reading of its shape.',
   'A monatomic ideal gas is at 300 K. Find the average kinetic energy per atom (k_B = 1.38x10^-23 J/K), and describe how the Maxwell-Boltzmann speed distribution for this gas would change if the temperature were raised to 600 K.',
   'K_avg at 300 K is (3/2)(1.38x10^-23 J/K)(300 K) = 6.21x10^-21 J. Raising T to 600 K doubles the average kinetic energy, so the Maxwell-Boltzmann curve''s peak speed also doubles and shifts twice as far to the right.',
   'K_avg at 300 K is (3/2)(1.38x10^-23 J/K)(300 K) = 6.21x10^-21 J. At 600 K, K_avg doubles to 1.242x10^-20 J since K_avg is proportional to T. But because K_avg is proportional to v_rms^2, the rms speed increases only by a factor of sqrt(2) (about 1.41), not 2 -- so the Maxwell-Boltzmann curve''s peak shifts to a higher speed and the whole curve flattens and widens (more area under the high-speed tail), but the peak speed does not double just because the average energy did.',
   'Describing pressure as something that only exists ''at the walls'' instead of throughout the gas, or treating a higher Maxwell-Boltzmann peak speed as the only thing that changes with temperature while ignoring the spread.',
   'Back to practice: whenever a problem doubles or triples the temperature, remember speed scales with the square root of that factor, not the factor itself -- energy and speed do not move together in the same proportion.'),
  ('9.2',
   'The ideal gas law has two equivalent forms: PV = nRT (n = number of moles, R = universal gas constant) and PV = Nk_BT (N = number of atoms, k_B = Boltzmann constant) -- the same physical content written in two unit systems, related by N = nN_A. You should recognize both forms instantly and convert between them when a problem mixes moles and atom-count conventions.',
   'The ideal gas law only works with an absolute temperature scale, since it comes from a model where pressure and volume are directly tied to average atomic kinetic energy -- a scale that reads zero energy at a Celsius or Fahrenheit ''zero'' would break the proportionality the law depends on.',
   'Points require correctly solving the ideal gas law for an unknown variable with consistent units (temperature converted to kelvin before any substitution), reading values off pressure-volume, pressure-temperature, or volume-temperature graphs, and extrapolating a linear pressure-vs-temperature graph back to zero pressure to estimate absolute zero.',
   'When a pressure-vs-temperature graph is given and the question asks for the temperature at which pressure would reach zero, extend the straight-line trend down to the temperature axis rather than assuming the answer must be zero Celsius or reading only the plotted data range.',
   'A sealed rigid container holds an ideal gas at pressure 2.0x10^5 Pa and temperature 27 degrees C. The gas is heated at constant volume until its pressure reaches 3.0x10^5 Pa. Find the final temperature in degrees C.',
   'At constant volume, P1/T1 = P2/T2, so 2.0x10^5/27 = 3.0x10^5/T2, giving T2 = 27(3.0x10^5/2.0x10^5) = 40.5 degrees C.',
   'Convert to kelvin first: T1 = 27 + 273 = 300 K. At constant volume, P1/T1 = P2/T2, so T2 = T1(P2/P1) = (300 K)(3.0x10^5 Pa / 2.0x10^5 Pa) = 450 K. Converting back, T2 = 450 - 273 = 177 degrees C -- not 40.5 degrees C, which comes from plugging the Celsius value directly into a ratio the law only supports in kelvin.',
   'Plugging a Celsius temperature directly into the ideal gas law instead of converting to kelvin first.',
   'Return to practice and, before touching any P-V-T ratio, convert every temperature to kelvin first -- the ideal gas law''s proportionalities only hold on an absolute scale.'),
  ('9.3',
   'The direction of spontaneous energy transfer is a probability argument, not an absolute rule at the level of a single collision: at the interface between two objects in contact, a higher-energy atom is statistically more likely to hand energy to a lower-energy atom than the reverse, so across billions of random collisions the net flow of energy runs from the hotter system to the cooler one. Once both systems reach the same average kinetic energy per atom (thermal equilibrium), individual collisions still transfer energy in both directions -- it is only the net transfer that becomes zero.',
   'This is the conceptual foundation for heating/cooling problems and for why systems drift toward equilibrium -- an idea that resurfaces qualitatively when entropy and the second law are introduced later in the unit.',
   'Points come from correctly identifying the direction of spontaneous energy transfer (hot to cold, never the reverse), naming or distinguishing the transfer mechanism appropriate to a scenario, and stating that thermal equilibrium means zero net energy transfer, not zero atomic motion or zero individual collisions.',
   'When asked to explain why two objects at different temperatures reach a common final temperature, frame it as the statistically most probable outcome of many random atomic collisions redistributing energy -- not as ''heat rising'' or objects ''wanting'' to equalize.',
   'Block A at 80 degrees C and Block B at 20 degrees C are placed in contact inside an insulated container. Explain, using atomic-collision reasoning, why thermal energy transfers from A to B rather than the reverse, and describe what changes (or does not change) once the blocks reach a common final temperature.',
   'Heat naturally rises from the hot block to the cold block until block A becomes cold and block B becomes hot; once they are both at the same temperature, the atoms inside them stop moving.',
   'In any given atomic collision at the A-B interface, a higher-energy atom is statistically more likely to transfer energy to a lower-energy atom than the reverse, so with billions of random collisions the net flow of energy is from A (hotter, higher average kinetic energy) to B (cooler, lower average kinetic energy). This continues until both blocks reach the same average kinetic energy per atom -- their common final temperature. At that point, collisions still occur and still transfer energy in both directions, but the net transfer is zero (thermal equilibrium); the atoms do not stop moving.',
   'Describing thermal equilibrium as a state where atoms stop moving, rather than a state where net energy transfer between the two systems has stopped.',
   'Head to practice and, whenever a problem asks you to justify a hot-to-cold energy transfer, describe it as the statistically likely outcome of random collisions, not as heat physically ''wanting'' or ''rising'' toward equilibrium.'),
  ('9.4',
   'For a monatomic ideal gas, internal energy is entirely kinetic: U = (3/2)nRT = (3/2)Nk_BT, with no internal potential energy term at all, because ideal-gas atoms are modeled as not interacting via conservative forces and as having no internal structure to store potential energy in. This means any change in a monatomic ideal gas''s internal energy is fully accounted for by the first law, deltaU = Q + W, with nothing else to track.',
   'Nearly every quantitative Unit 9 free-response question is built around this law -- reading a PV diagram, identifying the process type, and tracking energy through heat, work, and internal energy is the core quantitative skill of the unit.',
   'Points require correctly applying the sign conventions in the first law, computing work from a constant/average pressure and volume change (or the area under a P-V curve) for a given process, identifying which quantity is zero or constant for isovolumetric/isothermal/isobaric/adiabatic processes, and computing internal energy change for a monatomic ideal gas from U = (3/2)nRT.',
   'When a process is labeled adiabatic, immediately set the heat transfer to zero and get the internal energy change entirely from work -- do not try to estimate any thermal energy transfer for that step, since by definition none occurs.',
   'An ideal gas is compressed at a constant pressure of 1.5x10^5 Pa from a volume of 0.040 m^3 to 0.025 m^3, while releasing 900 J of thermal energy to its surroundings. Find the work done on the gas and the resulting change in its internal energy.',
   'Since the gas is compressed, work on the surroundings is negative, so W = -Pdelta V = -(1.5x10^5 Pa)(0.015 m^3) = -2250 J done on the gas, and since 900 J leaves as heat, deltaU = Q + W = -900 J + (-2250 J) = -3150 J.',
   'deltaV = V_f - V_i = 0.025 m^3 - 0.040 m^3 = -0.015 m^3 (volume decreases, since the gas is compressed). Work done on the gas is W = -Pdelta V = -(1.5x10^5 Pa)(-0.015 m^3) = +2250 J, positive because compression does positive work on the gas. Since 900 J of thermal energy leaves the gas, Q = -900 J. So deltaU = Q + W = -900 J + 2250 J = +1350 J: the gas''s internal energy increases even though it released heat, because the work done on it during compression more than makes up for that loss.',
   'Forgetting the negative sign in the work-from-pressure-and-volume-change formula, so an expanding gas (doing positive work on its surroundings) is incorrectly recorded as gaining energy from work instead of losing it.',
   'Back to practice: before computing work from pressure and volume change, write out deltaV = V_f - V_i with its actual sign first -- a compression gives a negative deltaV, and W = -Pdelta V then comes out positive on its own, without needing to guess the sign afterward.'),
  ('9.5',
   'The conductive heat-transfer rate is Q/deltat = kAdeltaT/L, where k is the material''s thermal conductivity, A is the cross-sectional area the energy passes through, deltaT is the temperature difference across the material, and L is its thickness -- so a thicker or narrower conductor transfers thermal energy more slowly for the same temperature difference, all else equal.',
   'These equations let you move from the qualitative hot-to-cold picture in the previous topic to actual numbers -- how much energy transferred, or how quickly -- which is tested constantly in calorimetry and conduction-rate problems.',
   'Points come from correctly using the specific-heat equation to find heat, mass, specific heat, or temperature change (including setting heat lost equal to heat gained in two-object mixing problems), using the conduction-rate equation Q/deltat = kAdeltaT/L to find conduction rate, and treating specific heat as constant across the whole temperature change in a problem.',
   'In any calorimetry problem, set the heat lost by the warmer object equal to the heat gained by the cooler object and solve -- do not average the two starting temperatures as a shortcut, since masses and specific heats can differ.',
   'A 0.50 kg piece of metal at 90 degrees C (specific heat 450 J/(kg*degrees C)) is dropped into 0.30 kg of water at 20 degrees C (specific heat 4186 J/(kg*degrees C)) in an insulated container. Find the equilibrium temperature.',
   'The equilibrium temperature is just the average of the two starting temperatures, so (90 + 20)/2 = 55 degrees C.',
   'Set heat lost by the metal equal to heat gained by the water: m_metal*c_metal*(90 - T) = m_water*c_water*(T - 20). Substituting, (0.50)(450)(90 - T) = (0.30)(4186)(T - 20), so 225(90 - T) = 1255.8(T - 20). Expanding: 20250 - 225T = 1255.8T - 25116, so 45366 = 1480.8T, giving T = 30.6 degrees C -- far below the naive 55 degrees C average, because the water''s much larger mass and specific heat mean it absorbs the metal''s heat with a far smaller temperature swing.',
   'Assuming specific heat changes as an object''s temperature changes, instead of treating it as constant throughout the process as this course requires.',
   'Return to practice and, in every calorimetry problem, set heat lost equal to heat gained and solve algebraically -- never average the two starting temperatures, since unequal masses and specific heats pull the equilibrium point away from the midpoint.'),
  ('9.6',
   'Entropy is a state function: it depends only on a system''s current configuration, not on the history of how it got there, and maximum entropy occurs when a system reaches thermodynamic equilibrium. AP Physics 2 restricts entropy and the second law to qualitative treatment only -- no numeric entropy calculation is ever expected, only reasoning about whether total entropy increases, stays the same, or (for a non-isolated part of a larger system) can decrease.',
   'It is the conceptual explanation for why processes in this unit -- like heat flowing hot to cold -- only ever run one direction, tying together the whole unit''s picture of energy spreading toward equilibrium.',
   'Points come from qualitatively explaining why total entropy of an isolated system increases or stays the same for a given process, correctly identifying that a non-isolated (closed) system''s entropy can decrease because energy crosses its boundary, and connecting maximum entropy to thermodynamic equilibrium -- all in words, with no quantitative entropy calculation expected.',
   'When asked to justify an entropy claim, explain it in terms of energy dispersal and probability (energy spreading among more possible configurations is far more likely than it spontaneously concentrating) -- never attempt a numeric entropy calculation, since this course tests entropy only qualitatively.',
   'A cup of hot coffee (system: the coffee alone) sits on a table in a large room that is not sealed off from it. Over time the coffee cools to room temperature. Explain what happens to the entropy of the coffee alone, and what happens to the entropy of the coffee-plus-room system as a whole, and why these two claims are not in conflict.',
   'Since the second law says entropy never decreases, both the coffee''s entropy and the room''s entropy must increase separately as the coffee cools.',
   'The coffee alone is not an isolated system -- thermal energy leaves it and enters the room, so the coffee''s own entropy actually decreases as it cools and its energy becomes concentrated within a smaller temperature range. But the coffee-plus-room system together is approximately isolated, and its total entropy increases, because the energy leaving the coffee spreads out among the far larger number of possible atomic configurations available in the much bigger room -- the room''s entropy gain outweighs the coffee''s entropy loss. This is consistent with the second law, which only guarantees non-decreasing entropy for a genuinely isolated system, not for every sub-part of it.',
   'Claiming a single closed (non-isolated) part of a larger system can never lose entropy, when only the total entropy of a fully isolated system is guaranteed not to decrease.',
   'Head to practice and, whenever an entropy question isolates one small part of a larger system, check whether energy can cross that part''s boundary -- only a genuinely isolated system''s entropy is guaranteed never to decrease.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 9 section (line 106): the quantitative relation K_avg = (3/2)k_BT = (1/2)mv_rms^2 plus the verbatim boundary statement excluding the Maxwell-Boltzmann distribution''s functional form for 9.1, applied to a two-temperature worked example testing the v_rms ~ sqrt(T) scaling; the fact that the ideal gas law has two equivalent forms, PV = nRT and PV = Nk_BT, for 9.2, applied to a constant-volume Celsius-to-kelvin worked example; the atomic-collision probability explanation for hot-to-cold energy transfer for 9.3, applied to a two-block-in-contact worked example; the fact that a monatomic ideal gas has U = (3/2)nRT = (3/2)Nk_BT with zero internal potential energy for 9.4, applied to a constant-pressure compression PV-diagram worked example isolating the W = -Pdelta V sign convention; the explicit conductive-rate formula Q/deltat = kAdeltaT/L for 9.5, applied to a two-substance calorimetry worked example; and the fact that entropy is a state function with maximum entropy at thermodynamic equilibrium, plus the verbatim boundary statement restricting Unit 9 to qualitative-only entropy treatment, for 9.6, applied to a coffee-cooling worked example distinguishing an isolated system from a non-isolated sub-part. All thermodynamics algebra was independently verified during authoring (9.1''s K_avg values and the sqrt(2) v_rms scaling; 9.2''s kelvin-converted final temperature; 9.4''s deltaV, work, and internal-energy-change values; 9.5''s two-substance equilibrium temperature); no physics facts or computed numbers required correction, and no derivative/integral notation appears anywhere (algebra-based course). briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-physics-2-unit9-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_physics_2'
  and e.unit_number = 9
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_physics_2' and unit_number=9 and status='published'
      and source_note like '%unit9-explainer-repair%';
  if v_repaired <> 6 then
    raise exception 'expected 6 repaired AP Physics 2 Unit 9 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_physics_2' and b.unit_number=9 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 9 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
