-- Remediation batch 7 (final) of the 34 P0 findings from PR #188
-- (docs/content/CODEX_QA_REPORT_CANONICAL_ANSWERS_CALC_AB_THROUGH_PHYSICS_1_2026_09_25.md).
-- This completes remediation of all 34 findings; see migrations 20260925070000 through this one for
-- the full sequence (7 batches, applied and independently verified one at a time).
--
-- apphycem-frq-008: canonical gave only E_x=-dV/dx; omitted the requested labeled potential graph
-- description and the one-dimensional gradient/principle explanation (part b).
--
-- apphycem-frq-009: stem asks for an experimental test of C=εA/d with variables and a control; canonical
-- supplied the formula plus an unasked energy expression and omitted the experiment entirely. Rewrote
-- with the actual experimental design.
--
-- apphycem-frq-011: experimental design omitted the required background-field correction and did not
-- adequately specify minimizing return-path effects, both explicitly required by the rubric. Added both,
-- plus part (b)'s linear-model description (axes, slope, intercept, justification).
--
-- apphycm-frq-003: canonical omitted part (b) entirely -- the small-oscillation angular frequency
-- ω=2√(b/m), obtained from the effective spring constant k_eff=U''(x_eq)=4b at the stable equilibrium.
-- Wrote part (b) with the full derivation.
--
-- apphycm-frq-008: canonical omitted part (b) entirely -- the average-velocity comparison v_avg=αT²/3
-- vs v(T)=αT², and why they differ. Also added the physical slope/area explanation part (a) requested
-- but the prior canonical skipped.
--
-- APSTATS-HDG-2026-GRAPH-005: the canonical's suggested trend line ran from about (2,41) to (10,72),
-- which is not a reasonable line through data whose actual x-range is 0-5 and y-range is 58-94 -- one
-- endpoint was outside the data's x-range entirely and the other was below every observed score.
-- Replaced with a trend line computed from an actual least-squares fit of the given data
-- (slope ≈5.9, intercept ≈60), described as passing through points within the data's real range.

begin;

update app.content_item_versions
set canonical_answer_1 = '(a) The graph of V(x)=V₀e^{-x/L} starts at V(0)=V₀ (its maximum) and decreases smoothly and exponentially toward 0 as x increases, approaching (but never reaching) the x-axis asymptotically. The slope of this graph, dV/dx, is negative everywhere (since V is monotonically decreasing) and becomes less steep (closer to zero) as x increases. Since Eₓ=-dV/dx, a negative slope gives a positive Eₓ -- so the electric field points in the +x direction everywhere, and its magnitude is largest near x=0 (where the graph is steepest) and shrinks toward zero as x→∞ (where the graph flattens out): Eₓ=-dV/dx=(V₀/L)e^{-x/L}.

(b) The governing principle is E=-dV/dx, relating the electric field to the negative of the slope of the potential function. Because V is given as a function of x alone (a one-dimensional potential), this ordinary derivative -dV/dx fully determines the field along the x-axis, with no need to consider gradients in other directions. Since V(x) is everywhere decreasing (dV/dx<0), -dV/dx is everywhere positive, confirming the field points in the +x direction found in part (a).'
where id = '833ead87-9b27-471e-a8d1-2dbe10b40182';

update app.content_item_versions
set canonical_answer_1 = '(a) Vary the plate separation d as the independent variable (e.g., using a micrometer-adjustable parallel-plate setup), and measure the resulting capacitance C=Q/V as the dependent variable (for example, by charging the capacitor to a known voltage V and measuring the charge Q, or using a capacitance meter directly) at each value of d. Hold the plate area A and the dielectric ε constant throughout (the same plates and the same medium, e.g., air, between them at every trial) as the control, so that any change in measured C can be attributed only to the change in d.

(b) Capacitance is defined by C=εA/d. Holding the plate area A (and dielectric ε) fixed while varying only the plate separation d isolates d as the single tested variable -- this is necessary because if A or ε were also changing between trials, a measured change in C could not be unambiguously attributed to the change in d, and the data would not test the C=εA/d relationship specifically.'
where id = 'e7679a1d-cf6b-4ce8-a42a-c07fb6cb9549';

update app.content_item_versions
set canonical_answer_1 = '(a) Hold the current I fixed and use a calibrated magnetic-field probe to measure the tangential field B at several radii r, positioned near the middle of a long straight section of wire, well away from the wire''s ends and return path (so that end effects and the return path''s field contribution at the probe''s location are negligible). The independent variable is r (distance from the wire''s axis); the dependent variable is the measured tangential field B. Controls: keep the current I, probe orientation, and wire geometry fixed across all measurements, and keep the probe at the same axial position (near the wire''s midpoint) for every radius tested. Correct for Earth''s/ambient background magnetic field by taking a zero-current baseline reading (wire current off) at each probe position and subtracting it from the corresponding with-current reading, or by reversing the current direction and averaging the two readings to cancel any constant background field. To minimize return-path effects, route the return conductor far from the probe, or use a coaxial/twisted-pair return configuration that largely cancels its external field, so that only the straight test section''s field is being measured.

(b) Plot B (vertical axis) versus 1/r (horizontal axis). If B=mu0 I/(2pi r) holds, this plot should be a straight line through the origin (zero intercept) with slope mu0 I/(2pi). This linear model is only approximately valid because Ampere''s law''s B=mu0 I/(2pi r) result strictly assumes an infinitely long straight wire with perfect cylindrical symmetry around it; a real finite wire with a return path only approximates this symmetry near its midpoint, far from the ends and return conductor, which is exactly why the measurements are restricted to that region in part (a).'
where id = '0318f7bf-d715-4e0f-94b8-7f467017484f';

update app.content_item_versions
set canonical_answer_1 = '(a) F=-dU/dx=-4ax³+2bx. Stable equilibria occur where U has minima: setting F=0 gives x(2b-4ax²)=0, so x=0 or x²=b/(2a), i.e., x=±sqrt(b/(2a)). Checking U''''(x)=12ax²-2b: at x=0, U''''(0)=-2b<0 (a local maximum, unstable); at x²=b/(2a), U''''=12a(b/2a)-2b=6b-2b=4b>0 (a local minimum, stable). So the stable equilibria are x=±sqrt(b/(2a)).

(b) At a stable equilibrium x_eq (x_eq²=b/(2a)), the effective "spring constant" for small oscillations is k_eff=U''''(x_eq)=4b (computed in part (a)). By analogy with a mass on a spring, where small-displacement motion is approximately simple harmonic with angular frequency ω=sqrt(k_eff/m), the angular frequency here is ω=sqrt(4b/m)=2·sqrt(b/m).'
where id = 'e7863b1a-5b2b-4d8b-8f66-7ad9e576d9c0';

update app.content_item_versions
set canonical_answer_1 = '(a) The v(t)=αt² graph is a parabola opening upward from the origin, increasing ever more steeply (concave up) as t increases. The slope of this v(t) graph at any point equals the instantaneous acceleration a(t) (since a=dv/dt); differentiating v(t)=αt² gives a(t)=2αt, which increases linearly with time -- consistent with the v(t) graph getting steeper as t increases. The area enclosed under the v(t) graph between 0 and any time t equals the displacement x(t) (since x=∫v dt); integrating v(t)=αt² from 0 to t (with x(0)=0) gives x(t)=αt³/3.

(b) Average velocity over [0,T] is total displacement divided by total time: v_avg = x(T)/T = (αT³/3)/T = αT²/3. The instantaneous velocity at t=T is v(T)=αT². These are NOT equal: v_avg=αT²/3 is exactly one-third of v(T)=αT². This makes sense because v(t) is continuously increasing (not constant) over the interval -- the particle spends more of its early time moving slowly and only reaches its highest speed, v(T), right at the very end, so the time-averaged velocity is pulled down well below the final instantaneous velocity.'
where id = '6700878c-423e-447e-be05-9e11b15b013b';

update app.content_item_versions
set canonical_answer_1 = 'Scatterplot shows a strong, positive, roughly linear association between hours studied and test score. A reasonable least-squares trend line passes through approximately (0, 60) and (5, 90), consistent with a slope of roughly 6 points per additional hour studied -- both endpoints fall within the actual range of the plotted data (x from 0 to 5, y from 58 to 94).'
where id = '51978e67-36b4-4df8-847d-7b8d7f83261d';

commit;
