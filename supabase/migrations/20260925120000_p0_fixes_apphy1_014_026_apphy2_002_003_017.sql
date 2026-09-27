-- Remediation batch 6 of the 34 P0 findings from PR #188.
--
-- apphy1-frq-014: canonical gave only v=sqrt(4gh/3); omitted the required sqrt(2) prediction for
-- doubled height (part a) and the dissipative assumptions required for the derivation (part b).
--
-- apphy1-frq-026: canonical (and frq_criteria's b-time) asserted Track A necessarily arrives first.
-- Verified this is false in general: with the same horizontal span and endpoints, a sufficiently steep
-- initial drop (approaching vertical) adds enough extra path length to outweigh its speed advantage,
-- so the comparison genuinely depends on track geometry, not on energy conservation alone. Corrected
-- both the rubric criterion and the canonical to state this properly instead of a false certainty.
--
-- apphy2-frq-002: canonical gave only the qualitative cancellation/addition result; stem explicitly
-- asks to derive and evaluate both field and potential numerically. Added the full numeric derivation
-- (E_net=0, V_net≈1.80×10⁵ V).
--
-- apphy2-frq-003: canonical gave τ and V_C(t) but omitted the required Kirchhoff-loop derivation and
-- initial-condition explanation (part b). Added it.
--
-- apphy2-frq-017: canonical correctly stated the 2x/4x ratios but omitted the required explanation
-- that gas amount does not affect either per-molecule ratio (part b). Added it.

begin;

update app.content_item_versions
set canonical_answer_1 = '(a) Since v=sqrt(4gh/3) is proportional to sqrt(h), doubling the drop height h multiplies the speed by sqrt(2) (not 2): v_new = sqrt(4g(2h)/3) = sqrt(2)·sqrt(4gh/3) = sqrt(2)·v_original ≈ 1.41 v_original.

(b) Starting from conservation of mechanical energy: Mgh = (1/2)Mv² + (1/2)Iω² (the drop in gravitational PE converts entirely into translational and rotational KE). Using I=(1/2)MR² and the rolling condition v=ωR (so ω=v/R): (1/2)Iω² = (1/2)(1/2 MR²)(v/R)² = (1/4)Mv². Substituting: Mgh = (1/2)Mv² + (1/4)Mv² = (3/4)Mv². Solving: v² = 4gh/3, so v = sqrt(4gh/3). This derivation requires two dissipative assumptions: (1) the cylinder rolls without slipping, so static friction acts at the contact point but does no work (the contact point is instantaneously at rest, so no kinetic energy is lost to sliding friction); and (2) there is no air resistance, rolling resistance, or other energy loss, so total mechanical energy is conserved throughout the descent.'
where id = 'ca68fb39-58be-4691-bfe7-c47ecd46f282';

update app.frq_criteria
set learner_facing_text = 'States that at any given height the two sleds have identical speed (energy conservation depends only on height, not path), but that whether Track A''s or Track B''s total travel time is shorter depends on the specific shape of each track: front-loading the descent tends to shorten time by reaching high speed sooner, but an initial section steep enough to add substantially more path length than it saves in time can reverse this. Travel time depends on the full path length and height-versus-distance profile (t=∫ds/v), not on the endpoint speed alone, and is not determined by the qualitative track descriptions given here alone.'
where content_item_version_id = '3860d78d-4c4c-4505-bfc1-8db4ba0bbf45' and criterion_key = 'b-time';

update app.content_item_versions
set canonical_answer_1 = '(a) By energy conservation, v=sqrt(2gΔh) for both sleds (mass cancels), so with equal drop height Δh and no friction, both sleds reach the same final speed regardless of track shape -- this holds because each track is frictionless, both sleds start from rest, and both drop through the same total height Δh.

(b) Energy conservation only fixes speed as a function of height already dropped, not as a function of elapsed time or path length; it cannot by itself settle which sled takes longer, since travel time is t=∫ds/v, which depends on the specific speed-versus-position profile and total arc length along each track, not just the endpoint speed. At any given height already dropped, both sleds have the identical speed sqrt(2g·(height dropped)) -- but Track A reaches a given height (and therefore that speed) earlier in its horizontal travel, since it front-loads its descent, so for much of the trip Track A moves faster than Track B did at the corresponding horizontal position. This tends to shorten Track A''s travel time relative to Track B''s. However, this is NOT guaranteed for every possible track geometry: if the initial steep section is steep enough (approaching a near-vertical drop) relative to the horizontal span, that section''s much longer path length can outweigh the speed benefit, making Track A''s total time longer than Track B''s shorter, more gradual descent. So which sled arrives first genuinely depends on the specific steepness/shape of each track, not on energy conservation alone -- which is exactly why this comparison cannot be settled from the height and endpoints given here.'
where id = '3860d78d-4c4c-4505-bfc1-8db4ba0bbf45';

update app.content_item_versions
set canonical_answer_1 = '(a) Each charge produces a field of magnitude E=kq/r²=(8.99×10⁹)(2.00×10⁻⁶)/(0.200)²≈4.50×10⁵ N/C at the midpoint (r=0.200 m, half the separation). Because the two charges are equal and positive, their field vectors at the midpoint point in opposite directions (each pointing away from its own charge, toward the other), so they cancel: E_net=0.

Each charge also produces a potential of magnitude V=kq/r=(8.99×10⁹)(2.00×10⁻⁶)/(0.200)≈8.99×10⁴ V at the midpoint. Potential is a scalar, and both values are positive, so they add: V_net=2×8.99×10⁴≈1.80×10⁵ V.

(b) Electric field is a vector quantity, so superposition requires adding the two field vectors as vectors; because the two charges are equal in magnitude and equidistant from the midpoint, their individual field vectors have equal magnitude but point in exactly opposite directions, so the vector sum is zero. Electric potential is a scalar quantity, so superposition here means simple algebraic addition of the two potential values; since both charges are positive, both contribute positive potential at the midpoint, and scalar addition of two positive numbers cannot produce cancellation -- so the potentials add rather than cancel, even though the fields from the same charges at the same point do cancel.'
where id = 'd37c7ee1-3df3-4279-a270-6777ce18a8a1';

update app.content_item_versions
set canonical_answer_1 = '(a) τ=RC=(100×10³ Ω)(20.0×10⁻⁶ F)=2.00 s. V_C(t)=12.0(1-e^{-t/2.00}) V (using V_C(t)=ε(1-e^{-t/RC}) with ε=12.0 V).

(b) Applying Kirchhoff''s voltage law around the single RC loop: the battery''s EMF equals the sum of the voltage drops around the loop, ε = iR + q/C. Since i=dq/dt, this is a first-order differential equation, ε = R(dq/dt) + q/C, whose solution is the exponential charging equation q(t)=Cε(1-e^{-t/RC}), i.e., V_C(t)=ε(1-e^{-t/RC}). The initial condition used, V_C(0)=0, is justified by two stated assumptions: the capacitor starts uncharged, so q(0)=0 directly; and the battery is ideal (no internal resistance), so the full EMF ε is available to drive current through R without any voltage drop lost inside the battery itself.'
where id = '9ea55355-b89a-4f52-ac16-9d0ee8de03ff';

update app.content_item_versions
set canonical_answer_1 = '(a) v_rms = sqrt(3kT/m), so v_rms ∝ sqrt(T). Since Container B has 4× the absolute temperature of Container A, its rms speed is sqrt(4)=2× that of Container A.

(b) Average molecular kinetic energy = (3/2)kT, directly proportional to T (not sqrt(T)). Since Container B has 4× the temperature, its average molecular kinetic energy is 4× that of Container A. Both v_rms and average molecular kinetic energy are per-molecule quantities that depend only on temperature and the molecules'' mass -- neither formula contains any dependence on the total number of molecules or moles of gas present. Since both containers hold the same gas (same molecular mass) and differ only in temperature, the amount of gas in each container has no effect on either ratio; only the temperature difference matters.'
where id = 'c8331178-884f-4568-abb9-6918569f26e9';

commit;
