begin;

-- Repair AP Physics 2 Unit 11 (Electric Circuits) Learn More explainers
-- -- all 8 were template-generated debt (core_idea byte-identical to their
-- paired brief's what_it_is) per the 2026-08-21 bulk audit. Confirmed via
-- SQL before authoring: all 8 rows carried source_note
-- 'generated-from-brief:legacy; grandfathered-2026-08-21' with no "repaired"
-- marker, and a direct read of the current rows showed core_idea
-- byte-identical to the paired brief's what_it_is on every row -- so all 8
-- are genuine debt; none were an outlier that already had hand-authored
-- content. AP Physics 2 has no Unit 10 in its taxonomy; Unit 11 is the
-- subject's second-lowest unit and follows the Unit 9 repair. Briefs for
-- this unit are NOT touched here -- only app.topic_explainers is repaired.
--
-- Grounded in docs/product/AP_PHYSICS_2_CED_FACT_PACK.md Unit 11 section
-- (starting line 145, "Unit 11 -- Electric Circuits"): 11.1's fact that a
-- zero-current wire section still has moving charge carriers, just zero net
-- drift, plus the definition of conventional current direction vs. actual
-- electron motion, applied to a charge/time worked example that forces a
-- minutes-to-seconds unit conversion; 11.2's open/closed/short circuit
-- definitions plus the verbatim boundary statement that schematics use
-- conventional current unless otherwise specified, applied to a
-- switch-opens-mid-loop worked example; 11.3's R = rho*ell/A relation and the
-- ohmic-material idealization (resistivity held temperature-independent even
-- though real resistivity generally rises with temperature), applied to a
-- resistivity-to-resistance-to-current worked example; 11.4's three
-- algebraically equivalent power forms (P = IdeltaV = I^2R = (deltaV)^2/R)
-- and the fact that brightness tracks power specifically, applied to a
-- same-resistance-different-configuration worked example that shows equal
-- resistance does not mean equal brightness; 11.5's ideal-battery/nonideal-
-- battery distinction (deltaV_terminal = emf - Ir) and ideal
-- ammeter/voltmeter placement rules, applied to an internal-resistance
-- worked example; 11.6's loop rule as a consequence of energy conservation
-- (deltaU_E = qdeltaV), applied to a two-resistor series-loop worked example
-- isolating consistent sign convention; 11.7's junction rule as a
-- consequence of charge conservation, applied to a three-branch junction
-- worked example; and 11.8's time-constant relation tau = R_eqC_eq with the
-- 63%/37% charging/discharging definitions plus the verbatim boundary
-- statement restricting RC circuits to qualitative/initial-final-state math
-- only, applied to a series RC worked example. All circuits algebra and
-- computed numbers were independently verified during authoring (e.g.
-- 11.1's 600 C charge-transfer value; 11.3's 0.085 ohm resistance and ~71 A
-- current; 11.4's 36 W vs. 9.0 W brightness comparison; 11.5's 1.8 A current
-- and 8.1 V terminal voltage; 11.6's 2.0 A loop current; 11.7's 2.0 A
-- junction current; 11.8's 1.0x10^-5 s time constant); no physics facts or
-- computed numbers required correction after this independent check, and no
-- derivative/integral notation appears anywhere (this is an algebra-based
-- course; 11.8's time constant is presented in the fact pack as a given
-- relation, tau = R_eqC_eq, not something the student derives, matching the
-- CED's explicit restriction to qualitative/initial-final treatment only).
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Physics 2 Unit 11); the pre-repair
-- content is fully recoverable from git history for this table's rows if a
-- rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4 --
-- the Unit 11 briefs already carry specific, correct, non-templated
-- point-earning language, so no refinement was needed.
-- mini_example_question/weak_answer/point_attaining_answer/practice_bridge
-- are original per-row text that was checked corpus-wide before this
-- migration was written and repeats nowhere else in the published corpus
-- (zero collisions found against every published row's matching field).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('11.1',
   'Current is I = deltaq/deltat, the rate charge crosses a wire''s cross-section. Though not a vector, current has an associated direction: conventional current follows the direction positive charge would move, even though in real wires it is actually electrons (negative carriers) moving the opposite way.',
   'Current having zero value in a wire section means the net charge-carrier motion there is zero -- not that individual charge carriers have stopped moving; carriers keep moving thermally, they just have no net drift when I = 0.',
   'Points come from correctly computing charge or current using I = deltaq/deltat with consistent time units, stating conventional current''s direction as the direction positive charge would move, and never adding or subtracting current values as if they had vector components.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then relate current to charge flow per time and describe conventional current direction without treating current as a vector before doing arithmetic or writing the final sentence.',
   'A wire carries a current of 2.5 A. How much charge passes a cross-section of the wire in 4.0 minutes, and does that charge physically consist of positive charges moving forward or electrons moving backward?',
   'Q = It = (2.5)(4.0) = 10 C, carried by positive charges flowing through the wire in the direction of the current.',
   'deltat must be in seconds: 4.0 min = 240 s, so Q = Ideltat = (2.5 A)(240 s) = 600 C. This charge corresponds to the conventional (positive) current direction, but physically it is carried by electrons drifting in the opposite direction -- current direction is defined by how positive charge would move, not by the actual motion of the negative charge carriers.',
   'Adding currents like vector components rather than as scalar flow rates through circuit branches',
   'Back to practice: whenever a current value is given, convert any time units to seconds before using I = deltaq/deltat, and keep straight that conventional current direction is a labeling convention, not the literal direction electrons move.'),
  ('11.2',
   'A circuit is one or more closed loops of wires, batteries, resistors, and other elements. Closed circuits allow charge flow, open circuits block it, and a short circuit lets charge flow with no potential-difference change across that path. Per the CED, unless stated otherwise every schematic uses conventional current.',
   'A single circuit element can belong to more than one loop at once in a multi-loop circuit -- ''the loop'' is not always the whole circuit, and later topics (11.6-11.7) depend on being able to isolate one loop at a time from a larger network.',
   'Points come from correctly classifying a circuit as open, closed, or short based on whether and how charge can flow, translating between a physical circuit and its schematic using standard symbols, and applying the conventional-current assumption to any schematic that does not explicitly state otherwise.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then translate between physical circuits and schematics using conventional-current assumptions before doing arithmetic or writing the final sentence.',
   'A single loop contains a battery, a resistor, and a switch in series. If the switch is opened partway through, what happens to the current everywhere else in the loop, and is the resulting configuration an open, closed, or short circuit?',
   'Opening the switch only stops current in that branch of the loop; current in the rest of the loop keeps flowing normally.',
   'Because this is a single loop with no other paths, every element shares the same current. Opening the switch breaks the only charge-flow path, making this an open circuit -- current drops to zero everywhere in the loop, not just at the switch, since there is no alternate path for charge to complete the loop.',
   'Calling an open switch a closed current path',
   'Return to practice and, before analyzing any circuit, trace the actual charge path first -- an open switch means zero current everywhere in that loop, not just at the switch itself.'),
  ('11.3',
   'Resistance depends on both geometry and material: R = rho*ell/A, where rho (resistivity) is an intrinsic property that generally increases with temperature -- though an ideal ohmic resistor''s resistivity is treated as temperature-independent. Ohm''s law, I = deltaV/R, then lets you read resistance directly from the slope of a current-vs-potential-difference graph.',
   'An ohmic material''s resistance is constant across different currents/voltages by definition -- resistivity in general can rise with temperature, but the ohmic idealization used throughout this course holds it fixed, and a resistor''s own temperature can still rise from the energy it dissipates.',
   'Points come from correctly applying R = rho*ell/A with matching units, using Ohm''s law I = deltaV/R to solve for an unknown quantity, and reading resistance off the slope (or its reciprocal) of a current-vs-potential-difference graph.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then use R equals rho ell over A, Ohm''s law, and graph slopes to connect material, geometry, current, and potential difference before doing arithmetic or writing the final sentence.',
   'A wire of resistivity 1.7x10^-8 ohm*m has length 2.0 m and cross-sectional area 4.0x10^-7 m^2. Find its resistance, and if a potential difference of 6.0 V is applied across it, find the resulting current.',
   'R = rho*A/ell = (1.7x10^-8)(4.0x10^-7)/2.0 ~ 3.4x10^-15 ohms, so I = deltaV/R comes out to an enormous, unreasonable current.',
   'R = rho*ell/A = (1.7x10^-8 ohm*m)(2.0 m)/(4.0x10^-7 m^2) = 0.085 ohms -- resistivity multiplies length and divides by area, not the reverse. Then I = deltaV/R = 6.0 V/0.085 ohms ~ 71 A.',
   'Treating resistivity and resistance as the same quantity',
   'Head to practice and keep rho (a material property) and R (a property of a specific object''s shape) separate -- resistivity multiplies length and divides by area to give resistance, never the reverse.'),
  ('11.4',
   'Rate of energy transfer is P = IdeltaV, with two algebraically equivalent forms, P = I^2R and P = (deltaV)^2/R, useful depending on which quantities are held fixed. Because bulb brightness tracks power (not current or potential difference alone), comparing brightness requires computing power, not just reading off the larger current or voltage.',
   'Because P = I^2R = (deltaV)^2/R are algebraically equivalent to P = IdeltaV, which form is fastest depends on which two quantities a problem already gives you -- defaulting to the same formula every time often means extra unnecessary algebra.',
   'Points come from computing power with whichever form of P = IdeltaV, I^2R, or (deltaV)^2/R fits the given quantities, and correctly comparing relative brightness by power rather than by current or potential difference alone.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then compare energy-transfer rates with P equals I Delta V and derived resistor power forms before doing arithmetic or writing the final sentence.',
   'Two identical 4.0 ohm resistors are connected: bulb A alone across a 12 V battery, and bulb B in series with an identical resistor across the same 12 V battery. Which bulb is brighter?',
   'Both resistors are 4.0 ohms, so they must dissipate the same power and be equally bright.',
   'Bulb A alone carries I = deltaV/R = 12 V/4.0 ohms = 3.0 A, so P = I^2R = (3.0 A)^2(4.0 ohms) = 36 W. Bulb B is in series with an identical resistor, so the pair''s total resistance is 8.0 ohms, giving I = 12 V/8.0 ohms = 1.5 A and a potential difference across bulb B alone of (1.5 A)(4.0 ohms) = 6.0 V, so P = IdeltaV = (1.5 A)(6.0 V) = 9.0 W. Bulb A is brighter -- the same resistance does not mean the same power once the circuit configuration changes the current and voltage each resistor actually sees.',
   'Assuming the bulb with the greatest current is brightest without checking potential difference or power',
   'Back to practice: before calling one branch ''brighter,'' compute power directly -- do not assume equal resistance or equal current means equal brightness.'),
  ('11.5',
   'Beyond reducing series (R_eq = sum of Ri) and parallel (1/R_eq = sum of 1/Ri) networks, a real (nonideal) battery''s terminal potential difference falls below its emf as current flows: deltaV_terminal = emf - Ir, where r is the battery''s internal resistance. Ideal ammeters (zero resistance, wired in series) and ideal voltmeters (infinite resistance, wired in parallel) are assumed unless a problem specifically says otherwise.',
   'Ideal ammeters (zero resistance) and ideal voltmeters (infinite resistance) are the default assumption unless a problem says otherwise -- a nonideal meter of either kind changes the very circuit it is trying to measure, which is why meter placement (series vs. parallel) matters.',
   'Points come from correctly reducing series and parallel resistor combinations to an equivalent resistance, applying deltaV_terminal = emf - Ir when a battery''s internal resistance is given, and placing ammeters in series and voltmeters in parallel with the element being measured.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then reduce series and parallel resistor networks and reason about ideal meters, wires, and battery terminal voltage before doing arithmetic or writing the final sentence.',
   'A battery with emf 9.0 V and internal resistance 0.50 ohms is connected to an external resistor of 4.5 ohms. Find the current in the circuit and the battery''s terminal potential difference.',
   'I = emf/R = 9.0/4.5 = 2.0 A, and since the battery supplies its rated voltage, the terminal voltage equals the emf, so deltaV_terminal = 9.0 V.',
   'The internal resistance is part of the total circuit resistance: I = emf/(R_ext + r) = 9.0 V/(4.5 ohms + 0.50 ohms) = 1.8 A. Terminal potential difference is then deltaV_terminal = emf - Ir = 9.0 V - (1.8 A)(0.50 ohms) = 8.1 V -- less than the 9.0 V emf, because some potential difference is used driving current through the battery''s own internal resistance.',
   'Treating parallel resistors as if the same current must pass through each branch',
   'Return to practice and remember a battery''s internal resistance reduces its own terminal voltage the moment current flows -- only a truly ideal battery keeps deltaV_terminal equal to the emf.'),
  ('11.6',
   'Kirchhoff''s loop rule, sum of deltaV = 0 around any closed loop, is a direct consequence of energy conservation (deltaU_E = q*deltaV for charge moving through a potential difference) -- if the sum were not zero, a charge completing the loop would gain or lose energy for free. Because potential is path-independent, you can also plot electric potential as a function of position while walking around a loop.',
   'The loop rule holds around any closed path, but the direction you choose to walk the loop is your choice -- what has to stay fixed once you pick it is treating every element''s contribution (rise or drop) consistently relative to that chosen direction.',
   'Points come from writing a loop equation that sums to zero with consistent sign conventions for potential rises and drops, and correctly solving that equation for an unknown current, resistance, or emf.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then write potential-difference changes around a closed loop that sum to zero before doing arithmetic or writing the final sentence.',
   'A single loop contains a 12 V battery and two resistors in series, 2.0 ohms and 4.0 ohms. Use Kirchhoff''s loop rule to find the current.',
   'Going around the loop: 12 - I(2.0) - I(4.0) = 0, but treating the resistor drops as potential increases gives 12 + 6.0I = 0, so I comes out negative.',
   'Walking the loop in the direction of assumed current: the battery is a potential rise (+12 V), and each resistor is a potential drop in the direction of current flow (-IR each). Summing to zero: 12 - I(2.0) - I(4.0) = 0, so 12 = 6.0I, giving I = 2.0 A. Keeping the sign of each element consistent with the walking direction -- rises positive, drops negative -- is what makes the loop sum actually equal zero.',
   'Losing sign consistency when moving across batteries and resistors in a loop equation',
   'Head to practice and, before writing a loop equation, pick a walking direction and assign every rise and drop a consistent sign relative to it -- mixed-up signs are the single most common way to lose this point.'),
  ('11.7',
   'Kirchhoff''s junction rule, sum of I_in = sum of I_out, follows from conservation of electric charge: charge cannot accumulate or vanish at a junction where wires meet, so every unit of charge entering per second must be matched by charge leaving per second, however many branches split off.',
   'The junction rule is really just conservation of charge applied to a single point -- current is not a substance that some circuit elements ''use up'' before it reaches a junction; whatever charge per second enters a junction must leave it.',
   'Points come from correctly summing currents entering and leaving a junction and setting them equal, and using that relationship to solve for an unknown branch current in a multi-branch circuit.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then apply charge conservation so current entering a junction equals current leaving before doing arithmetic or writing the final sentence.',
   'At a junction, one wire carries 5.0 A into the junction and splits into two outgoing wires. If one outgoing wire carries 3.0 A, find the current in the other.',
   'Since current is used up as it splits through the junction, the two outgoing branches might carry less than 5.0 A combined -- for instance, 3.0 A and 1.0 A.',
   'Charge conservation requires total current in to equal total current out: 5.0 A = 3.0 A + I2, so I2 = 2.0 A. Current is not consumed at a junction the way energy might be dissipated by a resistor -- every charge that enters a junction must leave it, so the two outgoing currents must sum to exactly the 5.0 A that entered.',
   'Assuming current is used up by circuit elements before reaching a junction',
   'Back to practice: at every junction, add up the incoming currents and the outgoing currents separately, then set them equal -- current is conserved, not consumed.'),
  ('11.8',
   'An RC circuit''s time constant, tau = R_eq*C_eq, sets the pace of charging/discharging: while charging, tau is the time to reach about 63% of final charge; while discharging, tau is the time to fall to about 37% of the initial charge. The CED limits you to qualitative charging/discharging descriptions plus initial- and final-state math -- not modeling charge or current as an explicit function of time.',
   'This course expects only qualitative charging/discharging descriptions plus initial- and final-state math -- you are never expected to write charge, current, or potential difference as an explicit function of time for an RC circuit.',
   'Points come from correctly computing tau = R_eq*C_eq, describing an uncharged capacitor as acting like a wire immediately upon charging and like an open switch after a long time, and never using q = I*deltat with a single instantaneous current reading to find charge.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then describe initial, final, charging, and discharging states qualitatively using the time constant before doing arithmetic or writing the final sentence.',
   'A 2.0 ohm resistor is in series with a 5.0 microfarad capacitor, charging from an ideal battery. What is the circuit''s time constant, and what does the circuit look like (in terms of current and capacitor behavior) immediately after the switch closes, versus after a very long time?',
   'tau = R/C = 2.0/(5.0x10^-6) = 4.0x10^5 s. Immediately after closing the switch, no current flows because the capacitor blocks it; after a long time, current flows freely as if the capacitor were not there.',
   'tau = R_eq*C_eq = (2.0 ohms)(5.0x10^-6 F) = 1.0x10^-5 s -- resistance times capacitance, not resistance divided by capacitance. Immediately after the switch closes, the uncharged capacitor acts like a plain wire, so current is at its maximum value set by the resistor alone. After a long time (many tau), the capacitor reaches its maximum charge and potential difference, and branch current drops to zero -- the capacitor now behaves like an open switch, not a wire.',
   'Multiplying one instantaneous current reading by elapsed time to get capacitor charge during charging',
   'Return to practice and remember tau = RC (not R/C), and that this course only asks you to describe initial and final RC states qualitatively, not model charge as a function of time.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 11 section (line 145): the fact that a zero-current wire section still has moving charge carriers with zero net drift, plus conventional current direction vs. actual electron motion, for 11.1, applied to a charge/time worked example forcing a minutes-to-seconds conversion; open/closed/short circuit definitions plus the verbatim boundary statement that schematics use conventional current unless otherwise specified, for 11.2, applied to a switch-opens-mid-loop worked example; the R = rho*ell/A relation and the ohmic-material temperature-independence idealization, for 11.3, applied to a resistivity-to-resistance-to-current worked example; the three algebraically equivalent power forms and the fact that brightness tracks power specifically, for 11.4, applied to a same-resistance-different-configuration worked example; the ideal-vs-nonideal battery distinction deltaV_terminal = emf - Ir and ideal meter placement rules, for 11.5, applied to an internal-resistance worked example; the loop rule as a consequence of energy conservation, for 11.6, applied to a two-resistor series-loop worked example isolating sign convention; the junction rule as a consequence of charge conservation, for 11.7, applied to a three-branch junction worked example; and the time-constant relation tau = R_eqC_eq with 63%/37% charging/discharging definitions plus the verbatim boundary statement restricting RC circuits to qualitative/initial-final-state treatment, for 11.8, applied to a series RC worked example. All circuits algebra was independently verified during authoring (11.1''s 600 C charge-transfer value; 11.3''s 0.085 ohm resistance and ~71 A current; 11.4''s 36 W vs. 9.0 W brightness comparison; 11.5''s 1.8 A current and 8.1 V terminal voltage; 11.6''s 2.0 A loop current; 11.7''s 2.0 A junction current; 11.8''s 1.0x10^-5 s time constant); no physics facts or computed numbers required correction, and no derivative/integral notation appears anywhere (algebra-based course). briefs for this unit were NOT touched. batch 2026-08-22-ap-physics-2-unit11-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_physics_2'
  and e.unit_number = 11
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_physics_2' and unit_number=11 and status='published'
      and source_note like '%unit11-explainer-repair%';
  if v_repaired <> 8 then
    raise exception 'expected 8 repaired AP Physics 2 Unit 11 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_physics_2' and b.unit_number=11 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 11 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
