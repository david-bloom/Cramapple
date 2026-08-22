begin;

-- Repair AP Precalculus Unit 3 (Trigonometric and Polar Functions)
-- topic point BRIEFS and Learn More EXPLAINERS -- both were template-
-- generated debt. The briefs followed the filler pattern 'X is the
-- Trigonometric and Polar Functions topic where you turn the concept
-- into an AP-ready action: Y' (the same second, independent debt
-- pattern found in AP Calculus BC's own Unit 3 earlier this session);
-- the explainers were generated-from-brief off those same filler
-- briefs.
--
-- Grounded in docs/product/AP_PRECALCULUS_CED_FACT_PACK.md Unit 3
-- deep-tier detail: the documented real low-scoring frequency-to-b
-- conversion (200 cycles/sec -> b=2*pi*200) for 3.7; the reciprocal-
-- vs-inverse distinction for secant/cosecant/cotangent (3.11); the
-- arctan quadrant-adjustment rule for rectangular-to-polar conversion
-- (3.13); the difference/double-angle identities being derivable from
-- the given sum identities rather than separately given (3.12); and
-- the average-rate-of-change-only, never-derivative scope for polar
-- rates of change (3.15). The existing common_point_loss values on
-- each row were already accurate (not template filler) and were used
-- as confirmation of real misconceptions to ground fresh content
-- around, not copied forward verbatim.
--
-- Before-state captured at docs/research/
-- topic_guide_source_note_grandfather_2026_08_21/
-- ap_precalculus_unit3_before_state.json.
--
-- Every new brief/explainer pair is genuinely topic-specific and
-- mathematically verified: core_idea differs from what_it_is on every
-- row, and no mini_example_question / weak_answer /
-- point_attaining_answer / practice_bridge value repeats within this
-- batch or elsewhere in the corpus (checked programmatically before
-- and after).

with brief_updates (
  topic_code, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss
) as (
  values
  ('3.1',
   'Periodic phenomena repeat the same output pattern at regular input intervals, and that repeat interval, the period, is the reciprocal of frequency, not the same number as frequency.',
   'Period (time or angle per cycle) and frequency (cycles per time or angle) measure the same repeating behavior from opposite directions, so treating them as interchangeable numbers produces a genuinely wrong value, not just an imprecise one.',
   'You earn points by correctly identifying whether a given number is a period or a frequency, and converting between them as reciprocals when the question requires the other one.',
   'Check whether the given number describes time-per-cycle (period) or cycles-per-time (frequency), then take the reciprocal to convert between them if the question asks for the other.',
   'Using a given frequency value directly as if it were the period, or vice versa, without taking the reciprocal.'),
  ('3.2',
   'On the unit circle, cosine of an angle is the x-coordinate and sine is the y-coordinate of the point at that angle, and tangent is sine divided by cosine -- so tangent is undefined exactly where cosine equals zero.',
   'Because tangent is defined as a ratio of sine and cosine, its behavior (period, asymptotes) is genuinely different from either sine or cosine alone, not just a variation on the same pattern.',
   'You earn points by correctly applying the unit-circle definitions (cosine as x-coordinate, sine as y-coordinate) and by identifying tangent''s asymptotes as exactly the angles where cosine equals zero.',
   'Locate the angle on the unit circle, read cosine as the x-coordinate and sine as the y-coordinate, then compute tangent as sine divided by cosine, checking first that cosine isn''t zero.',
   'Assuming tangent shares sine and cosine''s period or has no vertical asymptotes.'),
  ('3.3',
   'Evaluating sine or cosine at any angle uses the reference angle (the acute angle to the x-axis) for the magnitude, then the quadrant''s sign rule to determine whether the value is positive or negative.',
   'Getting the reference angle''s magnitude right but assigning the wrong sign for the quadrant produces a value with the correct size but the wrong sign -- a genuinely different number, not a rounding issue.',
   'You earn points by finding the correct reference angle and then applying the correct quadrant sign rule as two separate, explicit steps, not combining them into a single guess.',
   'Find the reference angle to get the magnitude, identify which quadrant the original angle is in, then apply that quadrant''s sign rule to the magnitude.',
   'Getting the reference angle right but assigning the wrong sign for the quadrant.'),
  ('3.4',
   'A sine or cosine graph''s amplitude is measured as the distance from the midline to the maximum (or minimum), not the vertical shift that moves the midline itself away from the x-axis.',
   'Amplitude and vertical shift are two independent features of a graph -- one describes how far the curve swings from its center, the other describes where that center sits -- and reading one as the other misidentifies a genuinely different graph feature.',
   'You earn points by measuring amplitude as the distance from the midline to a maximum or minimum, and identifying the vertical shift as a separate feature describing the midline''s own position.',
   'Identify the midline first, then measure amplitude as the distance from the midline up to the maximum (or down to the minimum), keeping vertical shift as a separate measurement of the midline''s height.',
   'Calling the vertical shift the amplitude instead of measuring amplitude from midline to maximum.'),
  ('3.5',
   'Choosing between a sine or cosine model for the same periodic data depends on the starting value relative to the midline -- a sine model starts at the midline moving upward, while a cosine model starts at the maximum.',
   'Both function families can model the same periodic data with a phase shift, but choosing the one that matches the starting condition without a shift produces a simpler, more directly justified model than forcing the habitual choice.',
   'You earn points by checking the starting value and direction of the data against sine''s and cosine''s own defining starting behavior, and selecting the model that matches without needing an extra phase-shift justification.',
   'Check whether the data starts at the midline moving upward (sine fits directly) or at the maximum (cosine fits directly), and choose the matching model rather than defaulting to a habitual choice.',
   'Choosing a cosine model by habit when the starting value and direction fit sine more naturally.'),
  ('3.6',
   'In the transformed sinusoidal form a*sin(b(θ+c))+d, the period is 2π divided by the absolute value of b -- the parameter b itself is not the period, even though it''s the number that directly controls it.',
   'Reading b directly as the period, instead of computing 2π/|b|, produces a period that''s wrong by a factor related to 2π, a substantial error, not a rounding one.',
   'You earn points by computing the period as 2π divided by the absolute value of b explicitly, not by reporting b itself as the period.',
   'Identify b from the transformed form, then compute the period as 2π divided by the absolute value of b, rather than reporting b directly.',
   'Using b as the period instead of converting period to 2pi divided by absolute b.'),
  ('3.7',
   'Fitting a sinusoidal model to a real context requires converting a stated frequency (such as cycles per second) into the parameter b using b equals 2π times the frequency -- a real, documented low-scoring conversion step on the actual exam.',
   'This specific frequency-to-b conversion was documented as one of the hardest points on a real administered exam, so treating it as an obvious or skippable step is a genuine risk, not overcaution.',
   'You earn points by converting a stated frequency into b using b equals 2π times the frequency as an explicit step, not by using the frequency value directly as b.',
   'Identify the stated frequency (cycles per unit time), multiply by 2π to get b explicitly, then use that b value in the sinusoidal model.',
   'Reporting a model without connecting the midline, amplitude, or period back to the context.'),
  ('3.8',
   'Tangent''s base period is π, not 2π like sine and cosine, and in the transformed form tan(bθ), the period is π divided by the absolute value of b.',
   'Applying sine and cosine''s 2π-based period formula to tangent produces a period twice as large as the correct value, a substantial error that comes from borrowing the wrong function family''s formula.',
   'You earn points by using π (not 2π) as tangent''s base period and computing its transformed period as π divided by the absolute value of b.',
   'Identify b in the transformed tangent form, then compute the period as π divided by the absolute value of b, using π as the base period, not 2π.',
   'Using 2pi as tangent''s base period instead of pi.'),
  ('3.9',
   'Inverse sine, inverse cosine, and inverse tangent each return a value only within a specific restricted range -- [-π/2,π/2] for inverse sine, [0,π] for inverse cosine, and (-π/2,π/2) for inverse tangent -- never an angle outside that range.',
   'A trig function repeats the same output at many angles, so its inverse must be restricted to one range to be a genuine function -- an angle outside that range isn''t just unconventional, it''s not a valid output.',
   'You earn points by returning inverse trig values strictly within their defined restricted ranges, never an equivalent-looking angle outside that range even if it also satisfies the original equation.',
   'After computing an inverse trig value, check that it falls within the function''s specific restricted range, and if not, find the equivalent angle that does.',
   'Returning an angle outside the principal range for the inverse trig function.'),
  ('3.10',
   'Solving a trigonometric equation over a given interval requires using periodicity to find every solution in that interval, since a single trig equation typically has more than one solution due to repeated values at different angles.',
   'Trig functions repeat the same value at multiple angles within one period (and across periods), so stopping after finding just one solution reports an incomplete answer even when that one solution is entirely correct.',
   'You earn points by finding every solution within the stated interval, using both the reference-angle-and-quadrant pattern and periodicity to generate all of them, not stopping after the first one found.',
   'Find the reference angle, identify every quadrant where the equation''s sign condition holds, then use periodicity to list every solution within the stated interval.',
   'Finding one solution and forgetting the second or repeated solutions in the required interval.'),
  ('3.11',
   'Secant, cosecant, and cotangent are reciprocal functions -- secant is 1/cosine, cosecant is 1/sine, cotangent is 1/tangent -- a completely different relationship from the inverse trig functions (arcsine, arccosine, arctangent).',
   '''Reciprocal'' and ''inverse'' name two entirely different mathematical operations here, and treating secant as if it undoes cosine (the way an inverse function would) rather than as 1/cosine leads to a fundamentally wrong evaluation.',
   'You earn points by evaluating secant, cosecant, and cotangent as reciprocals of cosine, sine, and tangent respectively, never as inverse (arc-) functions.',
   'Evaluate the base function (cosine, sine, or tangent) first, then take its reciprocal to get secant, cosecant, or cotangent -- never confuse this with computing an inverse trig function.',
   'Treating reciprocal trig functions as inverse trig functions.'),
  ('3.12',
   'The Pythagorean identity sin²θ+cos²θ=1 and the sum identities for sine and cosine of (α+β) are the required starting identities -- difference and double-angle identities are derivable from these but are not given as their own separate formulas.',
   'A difference identity like cos(α-β) is still a fully valid, usable rewrite, derived directly from the sum identity by treating -β as the angle -- it just isn''t handed to you as its own separate memorized formula the way the sum identities are.',
   'You earn points by deriving identities like the difference or double-angle forms explicitly from the given sum identities and the Pythagorean identity, not by treating them as separately required formulas.',
   'Start from the Pythagorean identity or the sum identities, then derive any difference or double-angle form needed by substitution, rather than trying to recall it as a separately memorized rule.',
   'Applying an identity in a way that changes the domain or loses a sign condition.'),
  ('3.13',
   'Converting rectangular coordinates to polar requires r=√(x²+y²) always, but θ=arctan(y/x) only directly for x>0 -- for x<0, π must be added to arctan(y/x) to land in the correct quadrant.',
   'Arctan alone only returns angles in a restricted range, so applying it without the quadrant adjustment for negative x-values produces an angle pointing in exactly the opposite direction from the actual point.',
   'You earn points by checking the sign of x before finalizing θ, adding π to arctan(y/x) whenever x is negative, not using the raw arctan output unconditionally.',
   'Compute r as √(x²+y²) always, compute arctan(y/x), then add π to that result if x is negative before finalizing θ.',
   'Using arctangent without adjusting theta for the quadrant.'),
  ('3.14',
   'A negative signed radius at a given angle plots in the opposite direction from that angle, at the same distance from the origin -- not at the same direction as if the radius were positive.',
   'Plotting a negative r as if it were positive places the point in a completely different location, on the opposite side of the origin from where it actually belongs.',
   'You earn points by plotting a negative signed radius in the opposite direction from the stated angle, not at the same angle with a positive-looking distance.',
   'Check the sign of r; if negative, plot the point in the opposite direction from the given angle, at the absolute value of r as the distance.',
   'Plotting negative r as if it were positive at the same angle.'),
  ('3.15',
   'The rate of change of a polar function is computed as the average rate of change of the signed radius r with respect to angle θ over an interval -- this course scopes the topic entirely to that average rate, never a derivative or instantaneous rate.',
   'This course never introduces derivatives, so any polar-rate question here must be answered using the average-rate-of-change formula over a stated angle interval, not instantaneous-rate or derivative language.',
   'You earn points by computing average rate of change of r with respect to θ using [r(θ2)-r(θ1)]/(θ2-θ1), never describing or computing an instantaneous or derivative-based rate.',
   'Identify r at the two given angle values, then divide the difference in r by the difference in θ to get the average rate of change over that interval.',
   'Using derivative or instantaneous-rate language in a Precalculus polar-rate question.')
)
update app.topic_point_briefs b
set
  what_it_is = u.what_it_is,
  why_it_matters = u.why_it_matters,
  how_points_are_earned = u.how_points_are_earned,
  answer_move = u.answer_move,
  common_point_loss = u.common_point_loss,
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated brief and explainer (previously a filler pattern -- ''X is the Trigonometric and Polar Functions topic where you turn the concept into an AP-ready action: Y'' for briefs, generated-from-brief for explainers, both grandfathered) with topic-specific content grounded in AP_PRECALCULUS_CED_FACT_PACK.md Unit 3 deep-tier detail (the documented real low-scoring frequency-to-b conversion for 3.7; the reciprocal-vs-inverse distinction for 3.11; the arctan quadrant-adjustment rule for 3.13; the derivable-but-not-separately-given difference/double-angle identities for 3.12; the average-rate-only, never-derivative scope for 3.15; and the existing common_point_loss hints, which were already accurate, used as confirmation of real misconceptions rather than copied forward verbatim). This is the second independent template-debt pattern found this session (the first was AP Calculus BC''s own Unit 3). batch 2026-08-22-ap-precalculus-unit3-briefs-and-explainers-repair; author=reviewer same session, no independent human review yet'
from brief_updates u
where b.subject_key = 'ap_precalculus'
  and b.unit_number = 3
  and b.topic_code = u.topic_code;

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('3.1',
   'A periodic phenomenon''s period (time or angle per repeat) and its frequency (repeats per time or angle) are reciprocals of each other, not the same quantity -- confusing which one a given number represents produces a value that is off by inversion, not just imprecise.',
   'If a context states a wheel completes one rotation every 4 seconds, that 4 is the period; the frequency is 1/4 rotations per second -- these describe the same repeating motion but are different numbers measuring it from opposite directions.',
   'Full credit requires correctly identifying whether a given number is a period or a frequency based on its units (time-per-cycle versus cycles-per-time), and taking the reciprocal explicitly when the question asks for the other one.',
   'Check the units of the given number to determine period or frequency, then take the reciprocal explicitly if the question requires converting to the other quantity.',
   'A signal repeats 5 times per second. A student is asked for the signal''s period and answers ''5 seconds.''',
   '5 seconds is correct, since that''s the number given in the problem.',
   'The number 5 given here is the frequency (5 cycles per second), not the period; the period is the reciprocal of frequency, so the period is 1/5 = 0.2 seconds per cycle, not 5 seconds -- using the frequency value directly as if it were the period inverts the actual relationship.',
   'Using a given frequency value directly as if it were the period, or vice versa, without taking the reciprocal.',
   'Before answering any period-or-frequency question, check the units of the given number first, and take the reciprocal explicitly if the question asks for the other quantity.'),
  ('3.2',
   'Tangent is defined as sine divided by cosine, so its vertical asymptotes occur exactly where cosine equals zero -- a genuinely different set of features from sine or cosine''s own graphs, not a variation on the same shape.',
   'Since cosine is the x-coordinate and sine is the y-coordinate of the same unit-circle point, tangent (their ratio) is undefined at every angle where that x-coordinate is zero, which happens at π/2 plus any multiple of π.',
   'Full credit requires cosine and sine correctly read as the x- and y-coordinates of the unit-circle point, and tangent''s undefined points identified explicitly as the angles where cosine equals zero.',
   'Read cosine as the x-coordinate and sine as the y-coordinate at the given angle, then compute tangent as their ratio, checking explicitly whether cosine is zero at that angle first.',
   'A student is asked where tan(θ) is undefined and answers ''at the same angles where sin(θ) is undefined,'' assuming tangent behaves like sine.',
   'This is correct, since tangent is a trig function just like sine.',
   'Sine is never undefined -- it''s defined for every real angle; tangent is undefined specifically where cosine equals zero, since tangent = sine/cosine, and division by zero is undefined -- this happens at θ = π/2 + kπ for any integer k, a completely different set of angles from anything related to sine''s own behavior.',
   'Assuming tangent shares sine and cosine''s period or has no vertical asymptotes.',
   'Before analyzing tangent''s behavior, identify where cosine equals zero explicitly, since that is exactly where tangent is undefined, regardless of sine''s own behavior.'),
  ('3.3',
   'Evaluating sine or cosine at a non-standard angle requires two separate steps -- the reference angle gives the correct magnitude, and the quadrant gives the correct sign -- and getting the magnitude right while assigning the wrong sign produces a genuinely different, wrong number.',
   'The reference angle is always the acute angle formed with the x-axis, and it only ever gives a magnitude; the sign (positive or negative) is a completely separate determination based entirely on which quadrant the original angle lies in.',
   'Full credit requires the reference angle identified explicitly for the magnitude, and the quadrant''s sign rule applied as a separate, explicit step, not merged into one guess.',
   'Identify the reference angle to get the magnitude, determine the quadrant of the original angle, then apply that quadrant''s sign to the magnitude as a separate step.',
   'A student evaluates cos(2π/3) by finding the reference angle π/3 (giving magnitude 1/2) and reports cos(2π/3) = 1/2.',
   'This is correct, since the reference angle was found correctly.',
   'The reference angle and magnitude are correct, but the sign is missing -- 2π/3 is in Quadrant II, where cosine is negative, so cos(2π/3) = -1/2, not 1/2; finding the correct reference angle only gives the magnitude, and the quadrant''s sign rule must be applied as its own separate step.',
   'Getting the reference angle right but assigning the wrong sign for the quadrant.',
   'After finding a reference angle''s magnitude, always apply the quadrant''s sign rule as a separate, explicit step before finalizing the value.'),
  ('3.4',
   'Amplitude is the distance from a sinusoidal graph''s midline to its maximum or minimum -- a completely separate measurement from the vertical shift, which instead describes how far the midline itself sits from the x-axis.',
   'A graph can have a large vertical shift and a small amplitude, or the reverse -- these two numbers vary independently, since one measures the curve''s swing size and the other measures where the center of that swing is located.',
   'Full credit requires the midline identified first, amplitude measured explicitly as the distance from midline to maximum, and vertical shift reported as a separate value describing the midline''s position.',
   'Identify the midline''s height first, then measure amplitude as the vertical distance from that midline to the maximum, keeping the two measurements explicitly separate.',
   'For y = 3sin(θ) + 5, a student reports the amplitude as 5, since that''s the number added to the sine term.',
   'This is correct, since 5 is clearly part of the amplitude.',
   '5 is the vertical shift (the midline sits at y=5), not the amplitude; the amplitude is the coefficient in front of sine, 3, which measures the distance from the midline (y=5) up to the maximum (y=8) or down to the minimum (y=2) -- these are two separate numbers describing two separate graph features.',
   'Calling the vertical shift the amplitude instead of measuring amplitude from midline to maximum.',
   'Before reporting a sinusoidal graph''s amplitude, identify the midline first, then measure amplitude as the distance from that midline to the maximum, keeping it separate from the vertical shift.'),
  ('3.5',
   'A sine model naturally starts at the midline moving upward, and a cosine model naturally starts at the maximum -- checking the data''s actual starting value and direction against these two defining behaviors picks the model that needs no extra phase shift to justify.',
   'Either sine or cosine can technically model any given periodic data with the right phase shift added, but starting from the function whose own natural starting behavior already matches the data avoids introducing an unnecessary phase-shift parameter.',
   'Full credit requires the data''s starting value and direction checked explicitly against sine''s (midline, increasing) and cosine''s (maximum) defining behavior before selecting a model.',
   'Check the data''s value and direction at the starting point, then choose sine if it starts at the midline increasing, or cosine if it starts at the maximum, rather than defaulting to one by habit.',
   'Data starts at the midline value and is increasing at the starting point. A student models it with cosine, since ''cosine is usually the default choice.''',
   'Cosine is a fine choice here, since either function can model periodic data with the right adjustments.',
   'Sine fits this data directly without needing any phase shift -- since the data starts at the midline and is increasing, that is exactly sine''s own defining starting behavior; choosing cosine here would require adding a phase shift to match the same starting condition that sine already satisfies on its own, which is an unnecessary complication.',
   'Choosing a cosine model by habit when the starting value and direction fit sine more naturally.',
   'Before choosing a sine or cosine model, check the data''s actual starting value and direction, and select whichever function''s own defining starting behavior already matches it.'),
  ('3.6',
   'In the form a*sin(b(θ+c))+d, the period is 2π divided by the absolute value of b, not b itself -- reporting b directly as the period confuses the parameter that controls the period with the period''s actual computed value.',
   'A larger value of b compresses the graph horizontally, producing a shorter period, which is exactly what dividing 2π by a larger number produces -- b and the period are inversely related through this specific formula, not equal to each other.',
   'Full credit requires the period computed explicitly as 2π divided by the absolute value of b, shown as its own step, not b reported directly as if it were the period.',
   'Identify b from the transformed sinusoidal form, then explicitly compute 2π divided by the absolute value of b to get the period.',
   'For y = sin(4θ), a student reports the period as 4, since that''s the value of b in the transformed form.',
   'This is correct, since b directly gives the period.',
   'b is not the period -- the period is 2π divided by the absolute value of b; here b=4, so the period is 2π/4 = π/2, not 4; a larger b value compresses the graph, producing a shorter period, which is why the period formula divides by b rather than reporting it directly.',
   'Using b as the period instead of converting period to 2pi divided by absolute b.',
   'Whenever identifying a sinusoidal function''s period from its transformed form, always compute 2π divided by the absolute value of b explicitly, rather than reporting b as the period.'),
  ('3.7',
   'Converting a stated frequency into the sinusoidal parameter b requires the formula b equals 2π times the frequency -- a real, documented, unusually low-scoring conversion step on an actual administered exam, not a step that can be skipped or guessed.',
   'Frequency (cycles per unit time) and the parameter b (which controls period as 2π/b) are related but not identical; multiplying frequency by 2π is the specific, required conversion step connecting the two.',
   'Full credit requires the stated frequency multiplied by 2π explicitly to obtain b, shown as its own step, rather than using the frequency value directly as b in the model.',
   'Identify the stated frequency explicitly, multiply it by 2π to obtain b as its own shown step, then use that computed b value in the sinusoidal model.',
   'A signal has a frequency of 200 cycles per second. A student builds the model using b=200 directly.',
   'This is correct, since 200 is the given frequency value.',
   'b is not the frequency itself -- the required conversion is b = 2π times the frequency, so b = 2π(200) = 400π, not 200; this specific conversion step was documented as one of the lowest-scoring points on a real administered exam, so it must be shown explicitly rather than assumed.',
   'Using a stated frequency value directly as b instead of multiplying by 2π to convert it.',
   'Whenever a context states a frequency, explicitly multiply it by 2π to obtain b before building the sinusoidal model, rather than using the frequency value directly.'),
  ('3.8',
   'Tangent''s base period is π, not 2π like sine and cosine, so its transformed period formula is π divided by the absolute value of b -- borrowing sine and cosine''s 2π-based formula for tangent produces a period exactly twice the correct value.',
   'Tangent repeats every π radians because tan(θ+π) = tan(θ) (a fact not shared by sine or cosine, which need a full 2π to repeat), so its period formula must use π as the base, not 2π.',
   'Full credit requires π used explicitly as tangent''s base period, with the transformed period computed as π divided by the absolute value of b, not the sine/cosine 2π-based formula.',
   'Identify b in the transformed tangent function, then compute the period as π divided by the absolute value of b, using π (not 2π) as the base period.',
   'For y = tan(2θ), a student computes the period using the sine/cosine formula, getting 2π/2 = π.',
   'This is correct, since π is a reasonable-looking period value.',
   'The formula used was wrong for tangent -- tangent''s base period is π, not 2π, so the correct period formula is π divided by the absolute value of b; here the correct period is π/2, not π, since using the sine/cosine 2π-based formula on tangent doubles the actual period.',
   'Using 2pi as tangent''s base period instead of pi.',
   'Before computing tangent''s period from a transformed form, use π (not 2π) as the base period, since tangent repeats twice as often as sine or cosine.'),
  ('3.9',
   'Inverse sine, inverse cosine, and inverse tangent are each restricted to their own specific range -- [-π/2,π/2], [0,π], and (-π/2,π/2) respectively -- and returning any other angle that happens to satisfy the original trig equation is not a valid inverse-function output, even if it looks like a reasonable answer.',
   'Since sine, cosine, and tangent each repeat the same output value at multiple angles, their inverses can only be genuine functions by restricting to one specific range per output value -- every inverse trig evaluation must land inside that function''s own defined range.',
   'Full credit requires the inverse trig value checked explicitly against its function''s specific restricted range, with any out-of-range angle replaced by the correct in-range equivalent.',
   'Compute the inverse trig value, then explicitly verify it falls within that specific function''s restricted range before finalizing the answer.',
   'A student evaluates arcsin(√2/2) and reports the answer as 3π/4, since sin(3π/4) does equal √2/2.',
   'This is correct, since sin(3π/4) does indeed equal √2/2.',
   '3π/4 is outside arcsin''s restricted range of [-π/2,π/2] -- even though sin(3π/4)=√2/2 is a true statement, arcsin must return the angle within its own range that satisfies this, which is π/4, since sin(π/4) also equals √2/2 and π/4 does fall within [-π/2,π/2].',
   'Returning an angle outside the principal range for the inverse trig function.',
   'After computing any inverse trig value, always verify it falls within that specific function''s restricted range before finalizing the answer.'),
  ('3.10',
   'A trigonometric equation typically has more than one solution within a given interval, since the same output value repeats at multiple angles -- finding only the first solution reached, even if that solution is entirely correct, reports an incomplete answer.',
   'Within one full period, a sine or cosine equation like sin(θ)=k (for -1<k<1, k≠0) has exactly two solutions, one in each of two quadrants sharing the same reference angle -- finding only one of them misses exactly half the required answer.',
   'Full credit requires every solution within the stated interval found explicitly, using the reference angle and both applicable quadrants (plus periodicity beyond one period if the interval is wider), not just the first solution reached.',
   'Find the reference angle for the equation, identify all quadrants where the sign condition matches, then list every resulting solution within the stated interval using periodicity as needed.',
   'Solve sin(θ) = 1/2 on [0, 2π). A student finds θ = π/6 and reports this as the complete solution set.',
   'π/6 is correct and complete, since it satisfies the equation.',
   'π/6 is correct but incomplete -- sine is also positive in Quadrant II, where the reference angle π/6 gives a second solution, π - π/6 = 5π/6; the complete solution set on [0, 2π) is θ = π/6 and θ = 5π/6, since both angles have the same reference angle and share the same positive sine value in their respective quadrants.',
   'Finding one solution and forgetting the second or repeated solutions in the required interval.',
   'Before finalizing a trigonometric equation''s solution, check every quadrant where the sign condition holds, not just the first solution found.'),
  ('3.11',
   'Secant, cosecant, and cotangent are defined as reciprocals (1/cosine, 1/sine, 1/tangent), a completely different operation from the inverse trig functions -- computing arccos instead of secant, for instance, answers an entirely different question.',
   'A reciprocal function flips the output value (1/x) after evaluating the original function, while an inverse function reverses which value is the input and which is the output -- these two operations produce different results for the same starting angle.',
   'Full credit requires secant, cosecant, and cotangent computed explicitly as reciprocals of their base functions'' evaluated output, never as an inverse (arc-) trig function.',
   'Evaluate the base trig function (cosine, sine, or tangent) at the given angle first, then take the reciprocal of that output to get secant, cosecant, or cotangent.',
   'A student is asked to evaluate sec(π/3) and computes it as arccos(π/3).',
   'This is the correct approach, since secant is related to cosine.',
   'Secant is the reciprocal of cosine, not the inverse cosine function -- the correct evaluation is sec(π/3) = 1/cos(π/3) = 1/(1/2) = 2, not arccos(π/3), which is an entirely different operation (and arccos wouldn''t even accept π/3, roughly 1.047, as a valid input, since arccos only accepts inputs between -1 and 1).',
   'Treating reciprocal trig functions as inverse trig functions.',
   'Before evaluating secant, cosecant, or cotangent, confirm you''re taking the reciprocal of the base function''s output, not computing an inverse (arc-) trig function.'),
  ('3.12',
   'The required identities are the Pythagorean identity and the sum identities for sine and cosine -- difference and double-angle identities are fully valid and usable, but must be derived from these, since they are not given as their own separate formulas.',
   'cos(α-β) is derived from cos(α+β) by substituting -β for β (using that cosine is even and sine is odd), and double-angle identities come from setting β=α in the sum identities -- both are legitimate, derivable rewrites, not missing content.',
   'Full credit requires an identity like a difference or double-angle form derived explicitly from the sum identities or Pythagorean identity when used, rather than assumed as an independently given formula.',
   'Identify whether the needed identity is one of the given starting identities (Pythagorean, sum) or must be derived from them, and show that derivation step explicitly when it''s the latter.',
   'A student needs cos(α-β) and says ''this isn''t given anywhere, so I can''t use it without it being a separate memorized formula.''',
   'Correct -- without a separately given difference identity, this expression can''t be rewritten.',
   'cos(α-β) is fully derivable from the given sum identity cos(α+β)=cos(α)cos(β)-sin(α)sin(β) by substituting -β for β: cos(α+(-β)) = cos(α)cos(-β)-sin(α)sin(-β) = cos(α)cos(β)+sin(α)sin(β), using that cosine is even and sine is odd; not being given as its own separate formula doesn''t mean it''s unusable, only that it must be derived when needed.',
   'Treating a derivable identity (difference, double-angle) as unusable because it isn''t given as its own separate formula.',
   'When a needed trig identity isn''t one of the directly given starting identities, derive it explicitly from the Pythagorean or sum identities rather than treating it as unavailable.'),
  ('3.13',
   'Converting (x,y) to polar coordinates requires r=√(x²+y²) always, but θ=arctan(y/x) directly only when x>0 -- when x<0, π must be added to that arctan result, since arctan''s own range can''t distinguish opposite-direction points with the same ratio y/x.',
   'The points (3,3) and (-3,-3) have the identical ratio y/x=1, so arctan(1)=π/4 for both -- but only the first point is actually at angle π/4; the second is diametrically opposite, at π/4+π, which is exactly why the x<0 adjustment is required.',
   'Full credit requires the sign of x checked explicitly before finalizing θ, with π added to the arctan result whenever x is negative.',
   'Compute r as √(x²+y²), compute arctan(y/x), then check the sign of x explicitly and add π to θ if x is negative before finalizing the answer.',
   'A student converts the point (-3,3) to polar coordinates and reports θ = arctan(3/-3) = arctan(-1) = -π/4.',
   'This is correct, since arctan(-1) does equal -π/4.',
   'Since x=-3 is negative, π must be added to the raw arctan result: θ = -π/4 + π = 3π/4, not -π/4; the point (-3,3) lies in the second quadrant (135°), while -π/4 points into the fourth quadrant -- exactly the opposite direction, confirming the required adjustment for negative x.',
   'Using arctangent without adjusting theta for the quadrant.',
   'When converting to polar coordinates, always check the sign of x before finalizing θ, adding π to the arctan result whenever x is negative.'),
  ('3.14',
   'A polar point with negative r plots at the opposite direction from the stated angle, at a distance equal to the absolute value of r -- treating a negative r as if it simply meant ''this distance, in this direction'' places the point on the wrong side of the origin entirely.',
   'The polar point (-2, 0) is not near the point (2,0) at all -- it''s actually the same point as (2, π), located in the opposite direction from angle 0, since a negative radius reverses direction rather than just describing a smaller or negative-looking distance.',
   'Full credit requires a negative signed radius plotted explicitly in the opposite direction from the stated angle, using the absolute value of r as the distance, not the stated angle with the radius treated as positive.',
   'Check whether r is negative; if so, plot the point in the direction opposite the stated angle, using the absolute value of r as the distance from the origin.',
   'A student is asked to plot the polar point (-2, 0) and places it 2 units from the origin along the angle-0 direction (the positive x-axis).',
   'This is correct, since the point is 2 units from the origin as stated.',
   'The negative sign on r changes the direction, not just the distance -- (-2, 0) plots in the direction opposite angle 0, which is angle π (the negative x-axis), 2 units from the origin; placing it along the positive x-axis treats the negative r as if it were positive, putting the point on the completely wrong side of the origin.',
   'Plotting negative r as if it were positive at the same angle.',
   'Before plotting any polar point, check the sign of r explicitly -- a negative r means plotting in the opposite direction from the stated angle, not the same direction.'),
  ('3.15',
   'A polar function''s rate of change in this course is always the average rate of change of signed r with respect to θ over a stated interval, computed as [r(θ2)-r(θ1)]/(θ2-θ1) -- this topic is explicitly scoped to average rate only, never a derivative or instantaneous rate.',
   'Even though a rate ''at'' a specific angle sounds like it might ask for an instantaneous value, this course has no derivative tools, so any such request is answered with the average rate of change over a small stated interval around that angle instead.',
   'Full credit requires the average rate of change of r with respect to θ computed explicitly as a difference quotient over the stated interval, with no derivative or instantaneous-rate language used anywhere in the response.',
   'Identify r at each of the two given angle values, then compute the difference in r divided by the difference in θ as the average rate of change.',
   'A polar function has r(θ)=3+cos(θ). A student is asked for its average rate of change on [0, π/2] and describes the answer using ''the derivative of r with respect to θ.''',
   'Using derivative language here is fine, since it''s a more precise way to describe rate of change.',
   'Derivative language is not accepted in this course -- this topic is explicitly scoped to average rate of change only; the correct approach computes [r(π/2)-r(0)]/(π/2-0) = [(3+0)-(3+1)]/(π/2) = -1/(π/2) = -2/π, using the average-rate-of-change formula directly, never a derivative.',
   'Using derivative or instantaneous-rate language in a Precalculus polar-rate question.',
   'Whenever asked for a polar function''s rate of change, compute it as the average rate of change of r with respect to θ over the stated interval, and never use derivative or instantaneous-rate language.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated brief and explainer (previously a filler pattern -- ''X is the Trigonometric and Polar Functions topic where you turn the concept into an AP-ready action: Y'' for briefs, generated-from-brief for explainers, both grandfathered) with topic-specific content grounded in AP_PRECALCULUS_CED_FACT_PACK.md Unit 3 deep-tier detail (the documented real low-scoring frequency-to-b conversion for 3.7; the reciprocal-vs-inverse distinction for 3.11; the arctan quadrant-adjustment rule for 3.13; the derivable-but-not-separately-given difference/double-angle identities for 3.12; the average-rate-only, never-derivative scope for 3.15; and the existing common_point_loss hints, which were already accurate, used as confirmation of real misconceptions rather than copied forward verbatim). This is the second independent template-debt pattern found this session (the first was AP Calculus BC''s own Unit 3). batch 2026-08-22-ap-precalculus-unit3-briefs-and-explainers-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_precalculus'
  and e.unit_number = 3
  and e.topic_code = u.topic_code;

do $$
declare
  v_briefs integer;
  v_explainers integer;
  v_core_matches integer;
begin
  select count(*) into v_briefs from app.topic_point_briefs
    where subject_key='ap_precalculus' and unit_number=3 and status='published'
      and source_note like '%unit3-briefs-and-explainers-repair%';
  select count(*) into v_explainers from app.topic_explainers
    where subject_key='ap_precalculus' and unit_number=3 and status='published'
      and source_note like '%unit3-briefs-and-explainers-repair%';
  if v_briefs <> 15 then
    raise exception 'expected 15 repaired AP Precalculus Unit 3 briefs, got %', v_briefs;
  end if;
  if v_explainers <> 15 then
    raise exception 'expected 15 repaired AP Precalculus Unit 3 explainers, got %', v_explainers;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_precalculus' and b.unit_number=3 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Precalculus Unit 3 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
