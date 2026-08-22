begin;

-- Repair AP Physics C: Electricity and Magnetism Unit 8 (Electric Charges,
-- Fields, and Gauss's Law) Learn More explainers -- all 6 were
-- template-generated debt (core_idea byte-identical to their paired brief's
-- what_it_is, and mini_example_question/weak_answer sharing the exact
-- boilerplate: "A physics prompt gives a scenario involving <Title>. What
-- should your response show to earn credit?" and "I would plug into a
-- formula without defining the quantities or direction." respectively) per
-- the 2026-08-21 bulk audit. Confirmed via SQL before authoring: all 6 rows
-- carried source_note 'generated-from-brief:legacy; grandfathered-2026-08-21'
-- with no "repaired" marker, and a direct read of the current rows showed
-- core_idea byte-identical to the paired brief's what_it_is on every row,
-- plus the exact boilerplate mini_example_question and weak_answer on every
-- row -- so all 6 are genuine debt; none were an outlier that already had
-- hand-authored content. Briefs for this unit are already hand-authored and
-- correct (title, why_it_matters, how_points_are_earned, answer_move,
-- common_point_loss all topic-specific and non-templated, and already
-- reflect the cylindrical-Gauss's-law nuance documented in the fact pack);
-- NOT touched here. This is the first AP Physics C: E&M repair batch --
-- this subject's taxonomy starts at Unit 8 (the calculus-based sibling of
-- AP Physics C: Mechanics, continuing that course's unit numbering).
--
-- Grounded in docs/product/AP_PHYSICS_C_EM_CED_FACT_PACK.md Unit 8 section
-- (starting line 59, "Unit 8 -- Electric Charges, Fields, and Gauss's
-- Law"): 8.1's verbatim boxed exclusion limiting direct Coulomb's-law
-- summation to four or fewer discrete charges (absent high symmetry),
-- applied to a two-source-charge vector-superposition problem where the two
-- pairwise forces are perpendicular and must be combined by components, not
-- added as magnitudes; 8.2's charge-from-density-integral formulas
-- (Q=integral of rho dV, and by the same logic integral of sigma dA and
-- integral of lambda dl), applied to a uniformly charged annular surface
-- where the weak answer illegitimately invents a thickness to force a
-- surface charge into a volume integral; 8.3's field definition E=F/q as a
-- property of space independent of any test charge, applied to a
-- point-charge field-then-force problem that separates computing E itself
-- from the force a specific test charge would feel; 8.4's verbatim boxed
-- exclusion limiting calculus-based field derivation to five named
-- geometries, applied to the on-axis field of a uniformly charged ring
-- (symmetry-component-cancellation derivation, cross-checked against the
-- point-charge-shortcut error of ignoring both the actual element-to-point
-- distance and the cosine projection); 8.5's flux definitions (uniform
-- Phi_E=E.A and general Phi_E=integral of E.dA), applied to a tilted flat
-- surface where the weak answer measures the angle from the surface's own
-- plane instead of its outward normal (a cosine-vs-sine swap); and 8.6's
-- verbatim boxed exclusion limiting Gauss's law to spherical, cylindrical,
-- or planar symmetry plus the real, documented 2025 Q1 Part A coaxial-
-- cylindrical-shell error pattern (the single lowest-scoring setup in Units
-- 8-10, mean scores 0.40/0.34 vs 0.80) -- applied directly, with the weak
-- answer reproducing the documented error of substituting the Gaussian
-- surface's own variable radius r into the enclosed-charge calculation
-- instead of the charged shell's fixed radius R1 (causing the r*l terms to
-- cancel and wrongly predicting a constant, radius-independent field), and
-- the point-attaining answer showing the correct 1/r falloff that comes
-- from using the shell's actual fixed radius. All formulas, derivatives,
-- integrals, and numeric results were independently verified during
-- authoring (e.g. 8.1's component-resolved vector sum recomputed and
-- cross-checked by magnitude and direction; 8.2's annulus-area integral
-- recomputed; 8.3's point-charge field and subsequent F=qE recomputed;
-- 8.4's ring on-axis integral E=kQx/(x^2+R^2)^(3/2) recomputed term-by-term
-- against the point-charge-shortcut error; 8.5's EA*cos(theta) recomputed
-- for both the normal-referenced and (incorrect) plane-referenced angles;
-- 8.6's cylindrical Gauss's-law algebra recomputed twice, once with the
-- weak answer's r-substitution and once with the correct R1-substitution);
-- no physics or calculus errors required correction after this independent
-- check. No exclusion boundary was crossed: 8.1's example uses only 2
-- discrete charges (well under the 4-charge limit); 8.4's example uses only
-- the ring-on-axis geometry, one of the five permitted; 8.6's example uses
-- only cylindrical symmetry, one of the three permitted.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Physics C: E&M Unit 8); the
-- pre-repair content is fully recoverable from git history for this
-- table's rows if a rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4 ("the
-- same topic-specific answer_move" / "the same or refined
-- common_point_loss") -- the Unit 8 briefs already carry specific, correct,
-- calculus-appropriate, non-templated point-earning language (including,
-- for 8.6, the exact cylindrical-lateral-area / fixed-radius nuance used
-- below), so no refinement was needed.
-- mini_example_question/weak_answer/point_attaining_answer/practice_bridge
-- are original per-row text that was checked corpus-wide before this
-- migration was written and repeats nowhere else in the published corpus.

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('8.1',
   'Coulomb''s law is bounded by an explicit course limit: this exam only expects direct pairwise-summation force calculations for four or fewer interacting point charges (or systems), and analyzing the resulting force from more charges is allowed only in situations of high symmetry. Force is a vector -- k|q1q2|/r^2 gives only magnitude, so each pairwise force must be resolved into components before multiple forces on the same charge are combined.',
   'The four-charges-or-fewer boundary tells you when direct Coulomb''s-law summation is even the right tool, and forgetting that every pairwise force is a vector -- not summing magnitudes -- is the single most common way this topic loses points once more than one source charge is involved.',
   'Credit requires computing each pairwise force with correct magnitude and sign, resolving each into components along a consistent axis system before combining forces from multiple source charges, and stopping at four charges (or invoking symmetry) rather than continuing pairwise summation indefinitely.',
   'For a system of four or fewer point charges, compute each pairwise Coulomb force as a vector, break into components along a chosen axis system, and sum components separately before combining; do not attempt this direct pairwise method for more than four charges or for continuous distributions -- that requires a field or Gauss''s-law approach instead.',
   'A charge q0 = +5 nC sits at the origin. A second charge qA = +2 nC sits 0.03 m to the right of q0 along the x-axis. A third charge qB = -2 nC sits 0.04 m directly above q0 along the y-axis. Find the magnitude of the net electric force on q0.',
   'The force from qA has magnitude k(5nC)(2nC)/(0.03)^2 = 9.99x10^-5 N and the force from qB has magnitude k(5nC)(2nC)/(0.04)^2 = 5.62x10^-5 N, so the net force is just their sum: 9.99x10^-5 + 5.62x10^-5 = 1.56x10^-4 N.',
   'qA repels q0 (both positive) in the -x direction with magnitude 9.99x10^-5 N; qB attracts q0 (opposite signs) in the +y direction with magnitude 5.62x10^-5 N. These are perpendicular components, not magnitudes to add directly: net force = sqrt((9.99x10^-5)^2 + (5.62x10^-5)^2) = 1.15x10^-4 N -- smaller than the weak answer''s incorrect straight sum because the two forces partially work against combining in a single direction.',
   'Adding force magnitudes directly instead of resolving each pairwise force into components before summing.',
   'Return to practice and, whenever more than one source charge acts on the same object, resolve each pairwise force into x- and y-components before combining -- never add force magnitudes directly just because both forces act on the same charge.'),
  ('8.2',
   'Charge conservation guarantees total charge in an isolated system never changes, but total charge from a continuous distribution is never read off directly -- it is recovered by integrating the matching density over the object: Q = integral of rho dV for a volume, and by the same logic Q = integral of sigma dA for a surface and Q = integral of lambda dl for a line, even when that density is uniform.',
   'Every field or Gauss''s-law calculation later in this unit starts from correctly identifying whether the charge lives on a line, surface, or volume and writing the matching integral -- matching the wrong density type to the object''s actual dimensionality breaks every downstream step even if the arithmetic that follows is otherwise correct.',
   'Credit requires naming the correct density type for the object''s actual dimensionality, writing the differential element consistent with that choice (dl, dA, or dV), and integrating only over that dimensionality -- never inventing an extra dimension (like a thickness) that the object does not have.',
   'Before integrating, identify whether the charge lives on a line, surface, or volume, name the matching density type, and write the differential element consistent with that choice -- this sets up correctly every later integral in the unit.',
   'A thin, uniformly charged annular (washer-shaped) surface has inner radius 0.02 m and outer radius 0.05 m, with uniform surface charge density sigma = 5x10^-9 C/m^2. Find the total charge on the annulus.',
   'Since sigma is a density, I would multiply it by a small assumed thickness to turn it into a volume charge: Q = sigma x (thickness) x (area), treating this like a volume charge with rho = sigma / thickness.',
   'The charge lives on a 2D surface with no thickness to integrate over, so use Q = integral of sigma dA with sigma constant: Q = sigma x (pi R2^2 - pi R1^2) = (5x10^-9 C/m^2) x pi x (0.05^2 - 0.02^2 m^2) = (5x10^-9) x pi x (0.0021) = 3.30x10^-11 C, about 0.033 nC -- no thickness or volume ever enters, because a surface charge has no third dimension.',
   'Using the wrong density type for the dimensionality of the object, such as treating a surface charge as if it were a volume charge.',
   'Back to practice: before writing any charge integral, name whether the object is a line, surface, or volume and use only that matching density type and differential element -- never invent a thickness to force a surface charge into a volume integral.'),
  ('8.3',
   'The field is defined strictly as force per unit (positive test) charge, E = F/q -- a property of space at that point, existing whether or not any charge is actually placed there. Because of that definition, the magnitude of whatever test charge you imagine placing at a point never changes E itself; only the force that particular charge would feel scales with its own q.',
   'Field problems test whether you keep the field (a property of space) and the force on a particular charge (which depends on that charge''s own magnitude) conceptually separate -- treating E as if it depends on the test charge used is the single most common way this topic''s definition is misapplied.',
   'Credit requires stating or using E = F/q with the field''s magnitude and direction independent of any test charge''s magnitude, and, when a force is requested, computing it as a separate step (F = qE) only after E itself is already known.',
   'When asked to describe or sketch a field, treat the field as existing at the point itself, independent of any test charge, and use field-line density (not just direction) to communicate relative field strength.',
   'A point charge Q = +4 nC sits at the origin. Find the electric field at a point 0.2 m away. Then find the force that a separate test charge of +2 microC would feel if placed at that point.',
   'The field depends on which test charge you use, so you would need to know the magnitude of a charge actually placed at that point before you could state E; only then could you find E = F/q from the resulting force.',
   'E is a property of the point itself, set only by the source charge and distance: E = kQ/r^2 = (8.99x10^9)(4x10^-9)/(0.2)^2 = 899 N/C, directed radially outward, before any test charge is considered. Only afterward is the force on the +2 microC charge found as a separate step: F = qE = (2x10^-6)(899) = 1.80x10^-3 N -- the field itself never depended on that 2 microC value.',
   'Describing the field as if it only exists when a test charge is physically present at that point, rather than as a property of space itself.',
   'Return to practice and always compute E itself first, as a property of the point in space set entirely by the source charge and distance -- only afterward multiply by whatever test charge''s magnitude the question actually asks about.'),
  ('8.4',
   'This course only expects calculus-based field derivation for five named geometries -- an infinitely long, uniformly charged wire or cylinder at a distance from its axis, a thin ring of charge on its axis, a semicircular arc at its center, and a finite line charge collinear with it or on its perpendicular bisector -- and no other shape. For the ring specifically, symmetry cancels every field component perpendicular to the axis before you integrate, so only the along-axis component of each charge element''s field needs to survive the sum.',
   'Setting up one of these five integrals correctly starts with recognizing which field component survives the distribution''s symmetry before you integrate -- skipping that step and instead treating the whole distribution as if it collapsed to a single point charge at the axial distance produces a field that is wrong even though the arithmetic looks clean.',
   'Credit requires identifying which field component survives the ring''s symmetry, setting up dE for that component alone using the actual element-to-point distance (not the axial distance alone) and its cosine projection, and carrying the integral to the closed-form result -- not substituting total charge into a bare point-charge field formula.',
   'Only attempt direct calculus integration for one of the five specified geometries -- an infinite charged wire/cylinder at a distance from its axis, a ring of charge on its axis, a semicircular arc at its center, or a finite line charge collinear with it or on its perpendicular bisector; for any other shape, this integral is not the intended tool.',
   'A thin ring of radius R = 0.3 m carries a uniformly distributed total charge Q = 6 nC. Find the electric field on the ring''s axis at a distance x = 0.4 m from the ring''s center.',
   'Treat the ring as if all its charge were concentrated at the center and use the point-charge formula at the axial distance: E = kQ/x^2 = (8.99x10^9)(6x10^-9)/(0.4)^2 = 337 N/C.',
   'By symmetry, only the axial component of each charge element''s field survives; every element is actually a distance sqrt(x^2+R^2) = 0.5 m away, and only the cos(theta) = x/sqrt(x^2+R^2) = 0.8 projection of each element''s field points along the axis. Integrating around the ring gives the standard result E = kQx/(x^2+R^2)^(3/2) = (8.99x10^9)(6x10^-9)(0.4)/(0.25)^(1.5) = 172.6 N/C -- noticeably less than the weak answer''s 337 N/C because it wrongly used the axial distance x instead of the true element-to-point distance and skipped the cosine projection entirely.',
   'Trying to integrate a full field vector when symmetry cancels one component, instead of first identifying which component survives and integrating only that one.',
   'Head back to practice and, before integrating any of the five permitted geometries, first identify which field component survives by symmetry -- then use the actual distance from each charge element to the field point (not the axial or perpendicular distance alone), including any cosine projection that geometry requires; never shortcut to the point-charge formula for an extended distribution.'),
  ('8.5',
   'Flux depends on the field component along the surface''s outward normal, not along the surface itself: Phi_E = E.A for a uniform field through a flat surface, or the general surface integral Phi_E = integral of E.dA when the field or surface is not uniform or flat. The angle that belongs in cos(theta) is measured from the normal vector, not from the surface''s own plane -- an angle from the plane and an angle from the normal are complementary, not the same number.',
   'The hardest habit in this topic is correctly identifying the outward normal direction and measuring the angle from that normal, not from the visible edge or plane of the surface, before multiplying field by area -- using the wrong reference direction produces a flux that is off by a cosine-versus-sine swap even when every other number in the problem is correct.',
   'Credit requires identifying the outward normal direction for the surface in question, measuring the angle between the field and that normal (not the surface''s plane), and applying Phi_E = EA cos(theta) with theta measured that way -- or setting up the full surface integral when the field or surface is not uniform or flat.',
   'Identify the direction of the area vector (outward normal) for the surface in question, then use the field component along that normal direction (or the full integral for non-uniform cases) rather than just multiplying field by area without accounting for orientation.',
   'A uniform electric field of magnitude 500 N/C passes through a flat square surface of area 0.2 m^2. The surface is tilted so that its outward normal makes a 60-degree angle with the field direction. Find the electric flux through the surface.',
   'The surface itself is tilted 60 degrees away from being face-on to the field, so I would use the 30-degree angle between the field and the surface''s own plane: Phi_E = EA cos(30 deg) = (500)(0.2)(0.866) = 86.6 N.m^2/C.',
   'Flux uses the angle from the outward normal, which is given directly as 60 degrees: Phi_E = EA cos(theta) = (500 N/C)(0.2 m^2) cos(60 deg) = (500)(0.2)(0.5) = 50 N.m^2/C -- the weak answer''s 86.6 comes from measuring the angle from the surface''s own plane instead of its normal, exactly the complementary (sine-versus-cosine) angle.',
   'Computing flux as field times area without checking whether the field is actually perpendicular to the surface.',
   'Return to practice and, before multiplying field by area, draw the outward normal vector explicitly and confirm the angle you are using is measured from that normal -- never from the surface''s own visible plane or edge.'),
  ('8.6',
   'Gauss''s law, the closed-surface integral of E.dA equal to q_enc/epsilon0, is only tested quantitatively for spherical, cylindrical, or planar symmetry -- and the single lowest-scoring real exam setup in this content (a coaxial cylindrical shell, mean scores 0.40 and 0.34 out of a possible 1 each, against 0.80 for the equation-writing step alone) comes almost entirely from three specific substitution errors after the equation itself is written correctly: using a disk''s or sphere''s area formula (pi*r^2 or 4*pi*r^2) instead of the cylinder''s actual curved lateral area 2*pi*r*l; substituting the Gaussian surface''s own variable radius r into the enclosed-charge calculation instead of the charged shell''s fixed radius; and conflating a surface charge density sigma with a volume charge density rho.',
   'Writing the closed-surface integral of E.dA = q_enc/epsilon0 is the easy point -- the two application points that actually separate strong from weak responses are picking the correct area formula for the Gaussian surface''s shape and computing enclosed charge from the charged object''s own fixed dimensions, never from the Gaussian surface''s variable radius.',
   'Credit requires the correct closed-surface flux setup for the chosen symmetry, the matching area formula (2*pi*r*l for a cylinder, never pi*r^2 or 4*pi*r^2), and enclosed charge computed from the actual charged object''s fixed radius or dimensions -- not the Gaussian surface''s own radius, and not switching between sigma and rho for the wrong dimensionality of charge.',
   'Only use Gauss''s law quantitatively when the charge distribution has spherical, cylindrical, or planar symmetry; for a cylindrical setup specifically, use the curved lateral surface area (never a disk''s or sphere''s area formula), and compute enclosed charge from the charged object''s own fixed radius, not the Gaussian-surface radius.',
   'A long, thin cylindrical shell of radius R1 = 0.01 m carries a uniform surface charge density sigma1 = +4.0x10^-9 C/m^2. Using Gauss''s law, find the magnitude of the electric field at a radial distance r = 0.03 m from the central axis (outside the shell, no other charge present).',
   'Using a Gaussian cylinder of radius r and length l, the enclosed charge is q_enc = sigma1*(2*pi*r*l), since that is the charge "inside" the Gaussian surface at radius r. So E*(2*pi*r*l) = sigma1*(2*pi*r*l)/epsilon0, and the r*l cancels: E = sigma1/epsilon0 = (4.0x10^-9)/(8.85x10^-12) = 452 N/C, the same at every radius outside the shell.',
   'The Gaussian surface (radius r) is a mathematical construct, not the charged object -- the actual charge lives only on the shell at its own fixed radius R1. Enclosed charge is q_enc = sigma1*(2*pi*R1*l), using R1 = 0.01 m, not r. Gauss''s law gives E*(2*pi*r*l) = sigma1*(2*pi*R1*l)/epsilon0, so E = sigma1*R1/(epsilon0*r) = (4.0x10^-9 * 0.01)/(8.85x10^-12 * 0.03) = 150.7 N/C -- correctly falling off as 1/r with distance, unlike the weak answer''s constant, radius-independent field.',
   'For a cylindrical Gaussian surface, using a sphere''s or disk''s area formula instead of the cylinder''s lateral area, or plugging the Gaussian surface''s own radius into the enclosed-charge calculation instead of the charged object''s actual radius.',
   'Head back to practice and, on every cylindrical Gauss''s-law setup, use the curved lateral area 2*pi*r*l (never a disk''s or sphere''s formula) and compute enclosed charge strictly from the charged object''s own fixed radius -- never from the Gaussian surface''s variable radius r, even though r appears on both sides of the equation before it is substituted correctly.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific, calculus-based content grounded in AP_PHYSICS_C_EM_CED_FACT_PACK.md Unit 8 section (line 59): the verbatim boxed exclusion limiting direct Coulomb''s-law summation to four or fewer discrete charges for 8.1, applied to a two-source perpendicular-force vector-superposition problem; the charge-from-density-integral formulas for 8.2, applied to a uniformly charged annular surface where the weak answer illegitimately invents a thickness to force a surface charge into a volume integral; the field definition E=F/q as a property of space independent of any test charge for 8.3, applied to a point-charge field-then-force problem; the verbatim boxed exclusion limiting calculus-based field derivation to five named geometries for 8.4, applied to the on-axis field of a uniformly charged ring, cross-checked against the point-charge-shortcut error of ignoring both the true element-to-point distance and the cosine projection; the flux definitions for 8.5, applied to a tilted flat surface where the weak answer measures the angle from the surface''s own plane instead of its outward normal (a cosine-vs-sine swap); and the verbatim boxed exclusion limiting Gauss''s law to spherical, cylindrical, or planar symmetry plus the real, documented 2025 Q1 Part A coaxial-cylindrical-shell error pattern (the single lowest-scoring setup in Units 8-10, mean scores 0.40/0.34 vs 0.80) for 8.6, with the weak answer reproducing the documented error of substituting the Gaussian surface''s own variable radius r into the enclosed-charge calculation instead of the charged shell''s fixed radius R1, and the point-attaining answer showing the correct 1/r falloff from using the shell''s actual fixed radius. All formulas, derivatives, integrals, and numeric results were independently verified during authoring; no physics or calculus errors required correction. No exclusion boundary was crossed: 8.1 uses only 2 discrete charges, 8.4 uses only the ring-on-axis geometry, and 8.6 uses only cylindrical symmetry. briefs for this unit are genuinely hand-authored, already calculus-appropriate, and were NOT touched. mini-examples are independently authored and repeat nowhere else in the published corpus. batch 2026-08-22-ap-physics-c-em-unit8-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_physics_c_em'
  and e.unit_number = 8
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_physics_c_em' and unit_number=8 and status='published'
      and source_note like '%unit8-explainer-repair%';
  if v_repaired <> 6 then
    raise exception 'expected 6 repaired AP Physics C: E&M Unit 8 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_physics_c_em' and b.unit_number=8 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C: E&M Unit 8 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
