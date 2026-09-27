-- Remediation batch 3 of the 34 P0 findings from PR #188.
--
-- apchem-sfrq-008: canonical omitted the required pure-water/no-common-ion assumption (rubric part-b)
-- and never wrote the Ksp expression or the part-c/d reasoning explicitly. Wrote all four parts.
--
-- apchem-sfrq-009: canonical omitted the explicit Ka=x²/(C−x) setup and <5% assumption (rubric part-b).
-- Wrote all four parts with the full algebra shown.
--
-- apphy1-frq-019: canonical never described the requested vector diagram (part a) explicitly. Wrote
-- all three parts.
--
-- apphy1-frq-022: canonical under-specified the requested experimental procedure, measured quantities,
-- and uncertainty-reduction method (parts a/b). Wrote all three parts.
--
-- apphy1-frq-029: canonical omitted the explicit stage-by-stage statement of which conservation law
-- applies to which stage and why (part c). Wrote all three parts.

begin;

update app.content_item_versions
set canonical_answer_1 = '(a) Ksp = [M+][X-]. In pure water, dissolution of MX is the only source of ions, so [M+]=[X-]=s and Ksp=s². s = sqrt(4.0×10⁻¹²) = 2.0×10⁻⁶ M.

(b) This calculation assumes the pure water initially contains no M+ or X- from any other source (no common ion, no side reactions) -- so the only ions present come from the dissolved MX itself, making [M+]=[X-]=s valid. Without this assumption, the substitution Ksp=s² would not correctly describe the equilibrium.

(c) With 0.010 M X- already present: Ksp = s(0.010+s). Since s is expected to be very small compared with 0.010 M (a common-ion effect suppresses solubility), we approximate 0.010+s ≈ 0.010, giving s ≈ Ksp/0.010 = 4.0×10⁻¹²/0.010 = 4.0×10⁻¹⁰ M -- confirming s ≪ 0.010 M and justifying the approximation.

(d) Adding more X- momentarily raises [X-], making Qsp=[M+][X-] > Ksp. The system responds by shifting toward solid MX (precipitation of additional MX) until Qsp=Ksp is restored again, so the observation is that more solid MX forms, leaving a lower dissolved [M+] -- i.e., a lower solubility than before.'
where id = 'a27211e9-475b-4f75-a9af-b3549bbd9bf0';

update app.content_item_versions
set canonical_answer_1 = '(a) [H+] ≈ sqrt(Ka·C) = sqrt((1.0×10⁻⁵)(0.100)) = sqrt(1.0×10⁻⁶) = 1.0×10⁻³ M. pH = -log(1.0×10⁻³) = 3.00.

(b) The weak-acid equilibrium is Ka = x²/(C−x), where x=[H+] at equilibrium. The small-x approximation assumes x is small enough relative to C that C−x ≈ C, simplifying to Ka ≈ x²/C, i.e., x ≈ sqrt(Ka·C) -- exactly the calculation used in part (a). This approximation is valid only if x turns out to be less than 5% of C, an assumption checked explicitly in part (c); water autoionization is neglected throughout.

(c) Percent ionization = (x/C)×100 = (1.0×10⁻³/0.100)×100 = 1.0%, well under 5%, confirming the small-x approximation used in part (a) was valid.

(d) At C=1.0×10⁻⁴ M, solving the full quadratic x²+Ka·x−Ka·C=0 with Ka=1.0×10⁻⁵: x = [-Ka + sqrt(Ka²+4·Ka·C)]/2 = [-1.0×10⁻⁵ + sqrt((1.0×10⁻⁵)²+4(1.0×10⁻⁵)(1.0×10⁻⁴))]/2 ≈ 2.7×10⁻⁵ M (taking the positive root, since concentration must be positive). Percent ionization = (2.7×10⁻⁵/1.0×10⁻⁴)×100 ≈ 27%, far above 5%. The approximation fails here because, at this much more dilute concentration, x is no longer small enough relative to C for C−x≈C to hold, so the quadratic must be solved exactly.'
where id = 'fcf5a47f-ff2e-470f-987a-160cd9ccd103';

update app.content_item_versions
set canonical_answer_1 = '(a) Place the northward 4.0 m/s vector (v⃗_bw, the boat''s velocity relative to the water) and the eastward 3.0 m/s vector (v⃗_ws, the water''s velocity relative to shore) head-to-tail. The resultant v⃗_bs = v⃗_bw + v⃗_ws is drawn from the tail of the first vector to the head of the second, pointing northeast -- this is the boat''s velocity relative to shore.

(b) The shore-frame velocity is the vector sum of 3.0 m/s east and 4.0 m/s north: magnitude = sqrt(3.0²+4.0²) = sqrt(25) = 5.0 m/s, direction θ = arctan(3.0/4.0) ≈ 37° measured from north toward east, i.e., about 37° east of north.

(c) The current only affects the boat''s eastward (downstream) position -- it does not change the boat''s northward speed relative to the water, which is what determines how long the crossing takes. Crossing time: t = (river width)/(northward speed) = 120 m / 4.0 m/s = 30 s. Downstream displacement during that time: d = (eastward speed)×t = 3.0 m/s × 30 s = 90 m.'
where id = 'ec7eca13-207c-4839-9343-9542578e71f8';

update app.content_item_versions
set canonical_answer_1 = '(a) Place the block on the board at a shallow angle and slowly increase the board''s angle (e.g., by raising one end) while watching the block. Record the angle at which the block just begins to slip -- the critical angle θ_c -- using the protractor. Repeat this measurement for multiple trials, resetting the board to a shallow angle between trials.

(b) The measured quantity is the critical angle θ_c at which slipping just begins, repeated across multiple trials. An important control is keeping the same block and board surfaces (the same contacting materials and surface condition) for every trial, since μ_s depends on the specific pair of surfaces in contact. To reduce uncertainty, average the critical angle across the repeated trials, or bracket the onset angle by approaching it from both above and below and averaging those bracketing values, rather than relying on a single measurement.

(c) At the critical angle, the block is on the verge of slipping: the component of gravity along the incline, mg sinθ_c, exactly equals the maximum available static friction force, μ_s times the normal force N=mg cosθ_c. Setting these equal: mg sinθ_c = μ_s·mg cosθ_c. Dividing both sides by mg cosθ_c gives μ_s = sinθ_c/cosθ_c = tanθ_c.'
where id = '21bff47c-03ba-4d59-8fab-873dcd127469';

update app.content_item_versions
set canonical_answer_1 = '(a) After the collision, mechanical energy is conserved as the combined mass swings upward: (1/2)(m_p+m_b)v_f² = (m_p+m_b)gh, so v_f = sqrt(2gh) = sqrt(2(9.8)(0.45)) = sqrt(8.82) ≈ 2.97 m/s.

(b) During the brief embedding collision, momentum is conserved: m_p·v_p = (m_p+m_b)·v_f. Solving for v_p: v_p = [(m_p+m_b)/m_p]·v_f = (1.000 kg/0.020 kg)(2.97 m/s) = 50 × 2.97 ≈ 149 m/s.

(c) Two different conservation laws apply because the two stages involve fundamentally different physical situations. During the brief embedding collision, only momentum is conserved (no external horizontal force acts during the brief impact); the collision is perfectly inelastic (pellet and block move together afterward), and in a perfectly inelastic collision kinetic energy is NOT conserved -- some of it converts into internal energy (heat, sound, and permanent deformation as the pellet embeds in the block). After the collision, as the combined mass swings upward, only gravity and tension (which does no work) act on it, so mechanical energy IS conserved during this second stage: kinetic energy converts into gravitational potential energy with no loss.'
where id = 'c973ec2c-826d-4dcf-bc00-aed52d250ee9';

commit;
