begin;

-- Repair AP Physics C: Electricity and Magnetism Unit 10 (Conductors and
-- Capacitors) Learn More explainers -- all 4 were template-generated debt
-- (core_idea byte-identical to their paired brief's what_it_is, and
-- mini_example_question/weak_answer sharing the exact boilerplate: "A
-- physics prompt gives a scenario involving <Title>. What should your
-- response show to earn credit?" and "I would plug into a formula without
-- defining the quantities or direction." respectively) per the 2026-08-21
-- bulk audit. Confirmed via SQL before authoring: all 4 rows carried
-- source_note 'generated-from-brief:legacy; grandfathered-2026-08-21' with
-- no "repaired" marker, and a direct read of the current rows showed
-- core_idea byte-identical to the paired brief's what_it_is on every row,
-- plus the exact boilerplate mini_example_question and weak_answer on every
-- row -- so all 4 are genuine debt; none were an outlier that already had
-- hand-authored content. Briefs for this unit are already hand-authored and
-- correct (title, why_it_matters, how_points_are_earned, answer_move,
-- common_point_loss all topic-specific and non-templated, already
-- reflecting the allowed-geometry and charge-redistribution nuances
-- documented in the fact pack); NOT touched here. AP Physics C: E&M Unit 8
-- was already repaired in a prior batch; this is Unit 10. Unit 9 (Electric
-- Potential) rows, whether or not they exist and whether or not they are
-- debt, are out of scope for this batch and were not touched.
--
-- Grounded in docs/product/AP_PHYSICS_C_EM_CED_FACT_PACK.md Unit 10 section
-- (starting line 85, "Unit 10 -- Conductors and Capacitors"): 10.1's
-- confirmed qualitative/no-equation conductor-electrostatics facts (excess
-- charge resides entirely on the surface, field inside a conductor in
-- equilibrium is zero, field is perpendicular to the surface, the whole
-- conductor is an equipotential surface, and charge density is higher at
-- points/edges than planar areas -- the mechanism behind electrostatic
-- shielding), applied to an irregularly shaped conductor (a sphere with a
-- sharp conical spike) comparing surface charge density at the sharp tip to
-- the smooth shoulder; 10.2's charge-conservation-plus-equal-final-potential
-- model for connected conductors, applied to two isolated conducting
-- spheres of different radii connected by a wire, reusing the Unit 9
-- point-charge-equivalent potential V=kQ/R (not a new capacitance formula)
-- to show final charge distributes in proportion to radius, not equally;
-- 10.3's verbatim boxed exclusion limiting quantitative capacitor analysis
-- to parallel-plate, concentric-spherical, and coaxial-cylindrical
-- geometries, applied directly using the single highest-value documented
-- error pattern in the entire Units 8-10 fact pack (2025 Q1 Part B,
-- coaxial cylindrical capacitor with a dielectric, the lowest-scoring part
-- of the whole exam at means B1=0.26/B2=0.21/B3=0.19) -- the weak answer
-- reproduces the Chief Reader Report's verbatim-documented wrong
-- substitution of forcing cylindrical dimensions into the parallel-plate
-- formula C=kappa*epsilon0*A/d, and the point-attaining answer re-derives
-- C=Q/deltaV from the coaxial cylinder's actual geometry,
-- C=2*pi*epsilon0*kappa*L/ln(R2/R1); and 10.4's three in-scope relational
-- equations (kappa=epsilon/epsilon0, kappa=E0/E, C=kappa*C0) plus the
-- qualitative polarization mechanism (no molecular-dipole derivation, which
-- is out of scope), applied to a parallel-plate capacitor charged then
-- disconnected from its battery before a dielectric is inserted, showing
-- that stored energy decreases at fixed charge even though capacitance
-- increases -- the opposite of the fixed-voltage case, and a genuinely
-- distinct trap from the brief's own "dielectric adds free charge"
-- common_point_loss.
--
-- No series/parallel capacitor-combination content was authored anywhere in
-- this batch, consistent with the fact pack's confirmation that this
-- content belongs to Unit 11 (Electric Circuits), not Unit 10. No
-- capacitance analysis was authored for any geometry outside the three the
-- exclusion permits (10.2's example deliberately reuses the Unit 9
-- point-charge-equivalent potential formula for an isolated sphere rather
-- than introducing sphere capacitance as a fourth geometry).
--
-- All formulas and numeric results were independently verified during
-- authoring and recomputed a second time before finalizing: 10.2's final
-- charges recomputed from kQ_A/R_A = kQ_B/R_B with Q_A+Q_B=6nC, giving
-- Q_A=1.5 nC and Q_B=4.5 nC (ratio 1:3 matching the 1:3 radius ratio);
-- 10.3's weak (parallel-plate force-fit) capacitance recomputed as
-- kappa*epsilon0*(2*pi*R2*L-2*pi*R1*L)/(R2-R1) = 4.17x10^-11 F (41.7 pF)
-- and the correct coaxial-cylinder capacitance recomputed as
-- 2*pi*epsilon0*kappa*L/ln(R2/R1) = 3.01x10^-11 F (30.1 pF), confirmed
-- distinct; 10.4's post-dielectric voltage recomputed both as
-- deltaV=Q/C=4nC/2nF=2V and independently as deltaV=deltaV0/kappa=8V/4=2V
-- (self-consistent), and energy recomputed both before (16 nJ, at 8V) and
-- after (4 nJ, at 2V) dielectric insertion, confirming the fourfold
-- decrease. No physics or calculus errors required correction after this
-- independent check.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Physics C: E&M Unit 10); the
-- pre-repair content is fully recoverable from git history for this
-- table's rows if a rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4 ("the
-- same topic-specific answer_move" / "the same or refined
-- common_point_loss") -- the Unit 10 briefs already carry specific,
-- correct, calculus-appropriate, non-templated point-earning language, so
-- no refinement was needed.
-- mini_example_question/weak_answer/point_attaining_answer/practice_bridge
-- are original per-row text that was checked corpus-wide before this
-- migration was written and repeats nowhere else in the published corpus.

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('10.1',
   'This topic is tested with no equations at all: a conductor in electrostatic equilibrium keeps excess charge entirely on its outer surface, has zero field throughout its interior, is a single equipotential surface, and has a field just outside that is perpendicular to the surface -- but surface charge density is not uniform on an irregular shape. Charge density concentrates most heavily where the surface curves most sharply (points and edges), which is the same mechanism that lets a closed conductor shield its interior from external fields (a Faraday cage).',
   'Every fact in this topic is qualitative, so credit depends on correctly connecting shape to outcome -- naming which surface region has higher curvature and stating that charge density (and therefore the field just outside) is higher there, rather than treating the conductor''s surface as if charge spread uniformly regardless of geometry.',
   'Credit requires stating that excess charge resides only on the surface, that the field is zero throughout the conductor''s interior and perpendicular to the surface just outside it, and that surface charge density -- and the field immediately outside -- is higher at sharply curved regions (points, edges) than at gently curved or flat regions, without ever introducing a formula.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then use conductor electrostatic-equilibrium facts: zero internal field, equipotential conductor, perpendicular surface field, and surface charge before doing arithmetic or writing the final sentence.',
   'A solid conductor is shaped like a sphere of radius 0.1 m with a sharp, needle-like conical spike attached to one side. The conductor carries a net excess charge of +8 nC and sits alone in electrostatic equilibrium, far from any other object. Compare the surface charge density at the spike''s sharp tip to the surface charge density on the smooth, gently curved region of the sphere, and describe the field just inside the conductor''s surface versus just outside it near the tip.',
   'Since it is a single connected conductor with one total charge of +8 nC, the charge should spread out evenly over the whole surface, so the charge density and the field just outside should be about the same everywhere, including at the tip.',
   'Excess charge on a conductor in equilibrium is not uniform across an irregular surface -- it concentrates where curvature is sharpest, so the needle-like tip carries a much higher surface charge density than the smoothly curved spherical region. The field just inside the conductor is zero everywhere, including near the tip, because the conductor is in electrostatic equilibrium throughout its volume; the field just outside the surface is perpendicular to the surface everywhere but is noticeably stronger near the tip than near the smooth shoulder, tracking the higher local charge density -- the same effect a lightning rod and a Faraday cage both rely on.',
   'Putting excess charge throughout the conductor''s volume instead of on its surface',
   'Return to practice and, whenever a conductor''s shape is irregular, identify the most sharply curved regions first -- charge density and the field just outside are always highest there, never uniform across the whole surface just because the conductor is a single connected piece.'),
  ('10.2',
   'When two isolated conductors are connected by a wire, two conditions hold at the new equilibrium: total charge is conserved (Q_A_final + Q_B_final = Q_A_initial + Q_B_initial), and both conductors reach the same potential, because a conductor''s surface is an equipotential and the connecting wire is itself a conductor. For two spheres far enough apart to treat independently, that shared potential can be written using each sphere''s own potential formula, V = kQ/R -- so equal final potential does not mean equal final charge unless the spheres also have equal radius.',
   'The two equilibrium conditions -- conserved total charge and equal final potential -- must both be applied together; using only charge conservation without the equal-potential condition leaves the split between the two conductors undetermined, and assuming an equal split without checking the potential condition is the most common way this topic loses points.',
   'Credit requires writing both equilibrium conditions explicitly -- conserved total charge, and equal final potential expressed with each conductor''s own potential formula and its own radius -- then solving the resulting system for each conductor''s final charge, rather than assuming any split without deriving it.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then apply charge conservation and equal final potential when connected conductors share charge before doing arithmetic or writing the final sentence.',
   'Isolated conducting sphere A (radius 0.05 m) carries an initial charge of +6 nC. Isolated conducting sphere B (radius 0.15 m) is initially uncharged. The two spheres are far apart (so each can be treated as if alone) and are connected by a long, thin conducting wire until equilibrium is reached. Find the final charge on each sphere.',
   'The wire connects the two spheres and shares the total charge between them, so each sphere should end up with half of the original +6 nC: 3 nC on sphere A and 3 nC on sphere B.',
   'Total charge is conserved: Q_A + Q_B = 6 nC. At equilibrium the spheres share one potential, kQ_A/R_A = kQ_B/R_B, so Q_A/Q_B = R_A/R_B = 0.05/0.15 = 1/3, meaning Q_B = 3*Q_A. Substituting: Q_A + 3*Q_A = 6 nC, so Q_A = 1.5 nC and Q_B = 4.5 nC -- the larger sphere ends up with three times the charge of the smaller one, not an equal split, because it takes more charge on the larger sphere to reach the same potential.',
   'Assuming identical final charges when the conductors have different capacitances or radii',
   'Back to practice: whenever conductors are connected by a wire, write both the charge-conservation equation and the equal-potential equation using each conductor''s own radius before solving -- never assume an equal split just because a wire joins them.'),
  ('10.3',
   'This exam only expects quantitative capacitance analysis for three geometries: parallel-plate, concentric spherical, and coaxial cylindrical capacitors -- no others. The single most costly documented error in this content comes from skipping that boundary: reaching for the parallel-plate formula C = kappa*epsilon0*A/d for a non-parallel-plate geometry instead of re-deriving C = Q/deltaV from that geometry''s own actual charge and potential-difference expressions.',
   'The parallel-plate formula is provided on the reference sheet and is tempting to reach for by default, but it only applies to flat, uniformly separated plates -- for a cylindrical or spherical capacitor, deltaV must first be found from that geometry''s own field integral (reusing the Unit 9 cylindrical or spherical potential-difference derivation) before C = Q/deltaV can be computed correctly.',
   'Credit requires recognizing which of the three permitted geometries is in play, writing that geometry''s own deltaV expression (not the parallel-plate one), and only then computing C = Q/deltaV -- substituting the geometry''s dimensions into the parallel-plate formula earns no credit even if the arithmetic that follows is clean.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then derive capacitance from C equals Q over Delta V for the allowed geometry instead of defaulting to parallel plates before doing arithmetic or writing the final sentence.',
   'A coaxial cylindrical capacitor has an inner conductor of radius R1 = 0.005 m, an outer conductor of radius R2 = 0.02 m, and length L = 0.3 m, with the gap completely filled by a dielectric of constant kappa = 2.5. Find the capacitance.',
   'Treat the two cylindrical conductors like a pair of unrolled parallel plates: use the outer cylinder''s curved surface area for A and the gap R2-R1 for d, giving C = kappa*epsilon0*(2*pi*R2*L - 2*pi*R1*L)/(R2-R1) = (2.5)(8.85x10^-12)(2*pi*0.02*0.3 - 2*pi*0.005*0.3)/(0.015) = 4.17x10^-11 F, about 41.7 pF.',
   'A coaxial cylinder is not a pair of flat plates, so C = kappa*epsilon0*A/d does not apply. Re-derive from the actual geometry: for a line charge lambda = Q/L enclosed by the inner conductor, the potential difference is deltaV = (lambda/(2*pi*epsilon0*kappa))*ln(R2/R1), so C = Q/deltaV = (2*pi*epsilon0*kappa*L)/ln(R2/R1) = (2*pi)(8.85x10^-12)(2.5)(0.3)/ln(0.02/0.005) = 4.17x10^-11/1.386 = 3.01x10^-11 F, about 30.1 pF -- noticeably less than the weak answer''s 41.7 pF, because the parallel-plate formula overestimates capacitance for this converging-field geometry.',
   'Force-fitting a cylindrical or spherical capacitor into C equals kappa epsilon0 A over d',
   'Head back to practice and, before computing any capacitance, name which of the three permitted geometries the problem describes and write that geometry''s own deltaV expression first -- never substitute cylindrical or spherical dimensions directly into the parallel-plate formula.'),
  ('10.4',
   'A dielectric reduces the field inside a capacitor because the external field polarizes the material, aligning induced dipoles so their own field opposes the applied one -- no molecular-dipole derivation is required, only three relational equations: kappa = epsilon/epsilon0, kappa = E0/E (field reduction), and C = kappa*C0 (capacitance increase). Whether energy stored goes up or down when a dielectric is inserted depends entirely on whether charge or voltage is held fixed while it happens -- the two cases give opposite answers.',
   'This topic is tested through the three relational equations applied correctly together, and through recognizing that a capacitor disconnected from its battery keeps its charge fixed (so voltage must drop as capacitance rises), while a capacitor still connected to a battery keeps its voltage fixed (so charge must rise instead) -- confusing which quantity stays fixed changes every downstream number.',
   'Credit requires identifying whether the capacitor is isolated (charge fixed) or still connected to a source (voltage fixed) before applying kappa = E0/E or C = kappa*C0, then computing the resulting stored energy from that same fixed quantity -- not from whichever value happens to be easiest to reuse.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then explain dielectric polarization and use kappa relationships for field reduction, capacitance increase, and stored energy changes before doing arithmetic or writing the final sentence.',
   'A parallel-plate capacitor is charged by an 8 V battery to a charge of 4 nC, then disconnected from the battery so its charge is fixed. A dielectric slab with kappa = 4 is then inserted to completely fill the gap. Find the new voltage across the capacitor and the new stored energy, and compare the new energy to the energy stored before the dielectric was inserted.',
   'Since inserting a dielectric always increases capacitance, and stored energy is found from U = (1/2)*C*deltaV^2 using the original 8 V, the new capacitance C = kappa*C0 = 4*(4nC/8V) = 2 nF gives U = (1/2)(2x10^-9)(8)^2 = 6.4x10^-8 J, so the energy increases after the dielectric is inserted.',
   'The capacitor is disconnected, so charge stays fixed at 4 nC -- the voltage is not still 8 V once the dielectric is in. With C0 = Q/deltaV0 = 4nC/8V = 0.5 nF and C = kappa*C0 = 2 nF, the new voltage is deltaV = Q/C = 4nC/2nF = 2 V (matching kappa = deltaV0/deltaV = 8/2 = 4, as expected). Stored energy uses the fixed charge: U = (1/2)*Q*deltaV = (1/2)(4x10^-9)(2) = 4x10^-9 J, compared to the original U0 = (1/2)(4x10^-9)(8) = 1.6x10^-8 J -- the energy actually drops to a quarter of its original value, the opposite of the weak answer, because at fixed charge a rising capacitance means a falling voltage and a falling U = Q^2/(2C).',
   'Treating a dielectric as if it adds free charge to the capacitor plates',
   'Return to practice and, before finding a post-dielectric voltage or energy, decide first whether the capacitor is isolated (charge fixed) or still connected to a source (voltage fixed) -- reusing the pre-dielectric voltage after the capacitor has been disconnected is the fastest way to get the direction of the energy change backwards.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific, calculus-based content grounded in AP_PHYSICS_C_EM_CED_FACT_PACK.md Unit 10 section (line 85): the qualitative conductor-electrostatics facts (surface-only charge, zero internal field, equipotential surface, curvature-dependent charge density, Faraday-cage shielding) for 10.1, applied to a spiked-sphere conductor comparing tip vs. shoulder charge density; the charge-conservation-plus-equal-final-potential model for 10.2, applied to two differently sized isolated spheres connected by a wire, reusing the Unit 9 point-charge-equivalent potential V=kQ/R rather than introducing a fourth capacitor geometry, showing the 1.5 nC / 4.5 nC split follows the 1:3 radius ratio, not an equal split; the verbatim boxed exclusion limiting quantitative capacitance analysis to parallel-plate, concentric-spherical, and coaxial-cylindrical geometries for 10.3, applied directly using the real, documented 2025 Q1 Part B coaxial-cylindrical-capacitor-with-dielectric error pattern (the single lowest-scoring part of the whole exam, means B1=0.26/B2=0.21/B3=0.19) -- the weak answer reproduces the Chief Reader Report''s verbatim-documented wrong substitution of cylindrical dimensions into C=kappa*epsilon0*A/d (41.7 pF), and the point-attaining answer re-derives C=Q/deltaV from the coaxial cylinder''s own geometry, C=2*pi*epsilon0*kappa*L/ln(R2/R1) (30.1 pF); and the three in-scope relational equations (kappa=epsilon/epsilon0, kappa=E0/E, C=kappa*C0) plus the qualitative (no molecular-dipole) polarization mechanism for 10.4, applied to a parallel-plate capacitor disconnected from its battery before dielectric insertion, showing stored energy falls to a quarter of its original value at fixed charge -- the opposite of the fixed-voltage case, and distinct from the brief''s own dielectric-adds-free-charge point-loss. All formulas and numeric results were independently verified and recomputed a second time during authoring; no physics or calculus errors required correction. No exclusion boundary was crossed: 10.2''s example reuses the Unit 9 sphere potential formula rather than introducing sphere capacitance as a fourth geometry, 10.3''s example uses only the coaxial-cylindrical geometry, one of the three permitted, and no series/parallel capacitor-combination content was authored anywhere in this batch (that content belongs to Unit 11, confirmed out of scope by the fact pack). Briefs for this unit are genuinely hand-authored, already calculus-appropriate, and were NOT touched. mini-examples are independently authored and repeat nowhere else in the published corpus. batch 2026-08-22-ap-physics-c-em-unit10-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_physics_c_em'
  and e.unit_number = 10
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_physics_c_em' and unit_number=10 and status='published'
      and source_note like '%unit10-explainer-repair%';
  if v_repaired <> 4 then
    raise exception 'expected 4 repaired AP Physics C: E&M Unit 10 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_physics_c_em' and b.unit_number=10 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C: E&M Unit 10 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
