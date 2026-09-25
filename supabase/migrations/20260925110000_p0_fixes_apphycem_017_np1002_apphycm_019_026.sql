-- Remediation batch 5 of the 34 P0 findings from PR #188.
--
-- apphycem-frq-017: canonical omitted the charge-element relation (dq=(Q/2πR)R dφ) its rubric requires
-- for the integral setup. Added it explicitly to part (a).
--
-- apphycem-frq-np1-002: stem's part (b) says "using cylindrical symmetry" for a system of concentric
-- SPHERICAL shells; the canonical/rubric already correctly used spherical symmetry. Fixed the stem.
--
-- apphycm-frq-019: canonical omitted the requested free-body diagram / explicit force representation
-- (part a). Described it in words.
--
-- apphycm-frq-026: canonical omitted the requested momentum-vector diagram, component equations, and
-- explicit energy-conservation derivation (parts a/b). Wrote all three parts with full algebra.

begin;

update app.content_item_versions
set canonical_answer_1 = '(a) By symmetry, every charge element dq on the ring has a mirror-image element on the opposite side of the ring whose transverse (perpendicular-to-axis) field components exactly cancel, while their axial (along-the-axis) components add. Each charge element is dq = (Q/2πR)·R dφ = (Q/2π) dφ (using arc length R dφ around the ring), and each element lies a distance sqrt(R²+z²) from point P.

(b) The axial field from a single element is dE_z = k dq z/(R²+z²)^{3/2}. Integrating around the full ring: E_z=∫k z dq/(R²+z²)^{3/2} = kQz/(R²+z²)^{3/2} (since ∫dq=Q).

(c) At z=0 (the center of the ring), E_z=kQ(0)/(R²)^{3/2}=0, as expected by symmetry (every element''s field is canceled by the element diametrically opposite it). For z≫R, (R²+z²)^{3/2}≈z³, so E_z≈kQz/z³=kQ/z², matching the field of a point charge Q at that distance -- as expected, since a distant point can no longer resolve the ring''s finite size.'
where id = '3b55e898-70be-47ec-9ebb-a3d0dd5808c0';

update app.content_item_versions
set stem = replace(stem, 'Justify, using cylindrical symmetry,', 'Justify, using spherical symmetry,')
where id = 'e1f73980-bc95-4cea-a735-17044be6c987';

update app.content_item_versions
set canonical_answer_1 = '(a) Free-body diagram: only two forces act on the mass -- the string tension F_T, directed along the string toward the fixed support point (up and inward, at angle theta from vertical), and the weight mg, directed straight down. Resolving into vertical and radial (horizontal, toward the circle''s center) directions: vertically, the mass has zero acceleration (it stays in a horizontal circle at constant height), so the vertical component of tension balances gravity: F_T cos(theta) = mg. Radially, the mass undergoes centripetal acceleration ω²r toward the center, where the circular path''s radius is r=L sin(theta), so the horizontal component of tension provides this: F_T sin(theta) = m ω² (L sin(theta)).

(b) Dividing the radial equation by sin(theta): F_T = m ω² L. Substituting into the vertical equation: (m ω² L) cos(theta) = mg, so ω² = g/(L cos(theta)), giving ω = sqrt(g/(L cos(theta))). The period is P = 2π/ω = 2π sqrt(L cos(theta)/g).'
where id = 'aa3f2f91-39ff-4d42-9af4-9648fdf495ce';

update app.content_item_versions
set canonical_answer_1 = '(a) Before the collision: draw a single momentum vector of magnitude mv pointing along +x (the moving puck); the initially stationary puck has zero momentum. After the collision: draw two momentum vectors, one of magnitude mv₁ at angle θ above +x (the first puck) and one of magnitude mv₂ at angle φ below +x (the second puck). Conservation of momentum in each direction gives: x-component: v=v₁cosθ+v₂cosφ; y-component: 0=v₁sinθ-v₂sinφ (the two y-components must be equal and opposite, since total y-momentum starts at zero).

(b) For an elastic collision between identical masses, kinetic energy is conserved: (1/2)mv² = (1/2)mv₁² + (1/2)mv₂², i.e., v²=v₁²+v₂². Squaring and adding the two momentum-component equations from part (a): v² = (v₁cosθ+v₂cosφ)² + (v₁sinθ-v₂sinφ)² = v₁²+v₂²+2v₁v₂(cosθcosφ-sinθsinφ) = v₁²+v₂²+2v₁v₂cos(θ+φ). Comparing this to the energy equation v²=v₁²+v₂² requires 2v₁v₂cos(θ+φ)=0. Since v₁ and v₂ are generally nonzero, cos(θ+φ)=0, so θ+φ=90° -- the two outgoing velocity vectors are perpendicular (v⃗₁·v⃗₂=0).

(c) With θ=30°, θ+φ=90° gives φ=60°. Since v₁ and v₂ are perpendicular and v is their vector sum, v, v₁, and v₂ form a right triangle with the right angle between v₁ and v₂, and θ=30° is the angle between v and v₁: v₁=v cos30° and v₂=v sin30°.'
where id = '7f809bef-c1f9-46d9-a40b-34053ceb3ca5';

commit;
