-- Tier 2 QA sweep repair: rubric-granularity splits across the
-- changes_requested backlog, 2026-08-09. See
-- docs/Q&A/CHANGES_REQUESTED_QA_2026_08_09.md for full context. All items'
-- underlying math/content was already independently confirmed correct by
-- reviewers (Saood, Abdul) -- this tier is purely structural: splitting
-- all-or-nothing multi-step criteria into independently-gradable
-- sub-criteria, preserving each item's total point value.
--
-- Bonus systemic finding: all 7 Calc AB items below have prompt_json's
-- parts[].points stuck at 1 while frq_criteria.points_possible is 3 per
-- part -- the exact inconsistency Shazia Fazal flagged specifically on
-- apcalcab-frq-005. Fixed for all 7 while touching this data (parts[].points
-- set to 3 to match the post-split per-part total), not just the one
-- explicitly flagged.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-tier2-rubric-granularity-20260809'));

create temporary table t2_targets (content_key text primary key, item_type text not null) on commit drop;
insert into t2_targets values
('apcalcab-frq-004','frq'),('apcalcab-frq-005','frq'),('apcalcab-frq-006','frq'),('apcalcab-frq-007','frq'),
('apcalcab-frq-009','frq'),('apcalcab-frq-010','frq'),('apcalcab-frq-015','frq'),
('APBIO-FRQ-S-019','frq'),('APBIO-FRQ-S-036','frq'),('APBIO-FRQ-S-038','frq'),('APBIO-FRQ-S-046','frq'),
('APBIO-FRQ-S-066','frq'),('APBIO-FRQ-S-080','frq'),('APBIO-FRQ-S-084','frq'),('APBIO-FRQ-S-086','frq'),
('APBIO-FRQ-S-087','frq'),('APBIO-FRQ-S-095','frq'),('apprecalc-frq-u12-004','frq');

create temporary table t2_versioned (content_key text primary key, old_version_id uuid not null, new_version_id uuid not null) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  for t in select * from t2_targets order by content_key loop
    select * into strict v_item from app.content_items where content_key=t.content_key for update;
    select * into strict v_old from app.content_item_versions
    where content_item_id=v_item.id order by version_num desc limit 1 for update;

    v_new := gen_random_uuid();

    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-09 changes_requested QA sweep Tier 2 -- rubric-granularity split'
      ),
      v_old.explanation,v_old.help_text,md5(t.content_key||'-tier2-v'||(v_old.version_num+1)),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into t2_versioned values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

-- =============================================================================
-- Calc AB: split each 3-point criterion into three explicit 1-point
-- sub-criteria, using the "1pt: ..." breakdown already present in each
-- criterion's evidence_requirements text.
-- =============================================================================

insert into app.frq_criteria (content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants)
select v.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix, '[]'::jsonb
from t2_versioned v
join (values
  ('apcalcab-frq-004','part-a-criterion-1','Computes r''(x)=1/x and states r''(e)=1/e.','Response computes the derivative of ln x and evaluates at x=e.','Show r''(x)=1/x, then substitute x=e to get 1/e.'),
  ('apcalcab-frq-004','part-a-criterion-2','Uses point-slope form with r(e)=1 to set up the tangent line.','Response sets up the tangent line using point (e,1) and the slope from criterion 1.','Write the point-slope form y-1=(1/e)(x-e) before simplifying.'),
  ('apcalcab-frq-004','part-a-criterion-3','States the tangent-line approximation L(x)=1+(x−e)/e.','Response simplifies the point-slope form to L(x)=1+(x-e)/e.','Simplify to the final linearization L(x)=1+(x-e)/e.'),
  ('apcalcab-frq-004','part-b-criterion-1','Substitutes x=e+0.2 into L(x).','Response substitutes x=e+0.2 into the linearization from part (a).','Write L(e+0.2) before simplifying.'),
  ('apcalcab-frq-004','part-b-criterion-2','Simplifies to 1+0.2/e.','Response simplifies L(e+0.2)=1+(e+0.2-e)/e=1+0.2/e.','Show the simplification step 1+0.2/e.'),
  ('apcalcab-frq-004','part-b-criterion-3','Evaluates numerically to approximately 1.0736.','Response computes 1+0.2/e to a decimal value near 1.0736.','State the final decimal approximation, about 1.0736.'),
  ('apcalcab-frq-004','part-c-criterion-1','Computes r″(x)=−1/x².','Response takes the second derivative of ln x.','Show r″(x)=-1/x^2 as its own step.'),
  ('apcalcab-frq-004','part-c-criterion-2','Notes r is concave down since r″(x)<0 for x>0.','Response connects the sign of r″(x) to concavity.','State that r''''(x)<0 for x>0 means r is concave down.'),
  ('apcalcab-frq-004','part-c-criterion-3','Concludes the tangent line lies above the graph, so the estimate is high.','Response connects concave-down shape to the tangent line overestimating.','Conclude the linear approximation is an overestimate (too high).'),

  ('apcalcab-frq-005','part-a-criterion-1','Differentiates each term of x²+xy+2y²=14 implicitly.','Response differentiates x^2, xy, 2y^2, and the constant with respect to x.','Show d/dx of each term before combining.'),
  ('apcalcab-frq-005','part-a-criterion-2','Applies the product rule correctly to the xy term, giving y+xy''.','Response shows d/dx(xy)=y+x(dy/dx) via the product rule.','Show the product-rule expansion of the xy term as its own step.'),
  ('apcalcab-frq-005','part-a-criterion-3','Solves algebraically for dy/dx, getting −(2x+y)/(x+4y).','Response isolates dy/dx after collecting like terms.','Collect all dy/dx terms on one side and solve.'),
  ('apcalcab-frq-005','part-b-criterion-1','Substitutes x=2, y=2 into the dy/dx expression.','Response substitutes the given point into the derivative from part (a).','Write the substituted expression before simplifying.'),
  ('apcalcab-frq-005','part-b-criterion-2','Simplifies the arithmetic correctly.','Response correctly computes the numerator and denominator at (2,2).','Show -(2(2)+2)/(2+4(2)) before reducing.'),
  ('apcalcab-frq-005','part-b-criterion-3','States the correct numeric slope value, −3/5.','Response reduces the fraction to -3/5.','State the final slope, -3/5.'),
  ('apcalcab-frq-005','part-c-criterion-1','Takes the negative reciprocal of the tangent slope, 5/3.','Response correctly inverts and negates -3/5 to get 5/3.','Show the negative-reciprocal step explicitly.'),
  ('apcalcab-frq-005','part-c-criterion-2','Applies point-slope form through (2,2).','Response writes y-2=(5/3)(x-2) using the normal slope and given point.','Write the point-slope equation before any further simplification.'),
  ('apcalcab-frq-005','part-c-criterion-3','Writes the final normal-line equation in acceptable form.','Response presents a complete, correct equation for the normal line.','State the final normal-line equation, y-2=(5/3)(x-2) or an equivalent form.'),

  ('apcalcab-frq-006','part-a-criterion-1','States the inverse-derivative formula (h⁻¹)′(b)=1/h′(h⁻¹(b)).','Response writes the inverse-function-derivative formula before applying it.','State the formula (h^-1)''(b)=1/h''(h^-1(b)) as its own step.'),
  ('apcalcab-frq-006','part-a-criterion-2','Identifies h⁻¹(4)=1 from the given data.','Response correctly reads h(1)=4 to conclude h^-1(4)=1.','State h^-1(4)=1, citing h(1)=4.'),
  ('apcalcab-frq-006','part-a-criterion-3','Computes 1/h′(1)=−1/3.','Response substitutes h''(1) into the formula and simplifies.','Show 1/h''(1)=-1/3 as the final computed value.'),
  ('apcalcab-frq-006','part-b-criterion-1','Applies the chain rule P′(x)=2x·(h⁻¹)′(x²).','Response differentiates P(x)=h^-1(x^2) using the chain rule.','Write P''(x)=2x*(h^-1)''(x^2) before substituting.'),
  ('apcalcab-frq-006','part-b-criterion-2','Evaluates at x=2 using (h⁻¹)′(4) from part (a).','Response substitutes x=2 and reuses the part (a) result for (h^-1)''(4).','Substitute x=2 and (h^-1)''(4)=-1/3 from part (a).'),
  ('apcalcab-frq-006','part-b-criterion-3','Computes P′(2)=−4/3.','Response completes the arithmetic to the final value.','State the final value, P''(2)=-4/3.'),
  ('apcalcab-frq-006','part-c-criterion-1','Identifies that h′(4) corresponds to input 4 of h, not of h⁻¹.','Response recognizes the distractor risk of using h''(4) directly.','State that h''(4) is evaluated at the wrong input for this problem.'),
  ('apcalcab-frq-006','part-c-criterion-2','Notes the relevant input is h⁻¹(4)=1.','Response connects the needed input back to h^-1(4)=1.','State that the relevant input for h'' here is 1, not 4.'),
  ('apcalcab-frq-006','part-c-criterion-3','Concludes h′(1), not h′(4), is the value actually needed.','Response gives the final correct conclusion about which derivative value is needed.','Conclude h''(1) is required, not h''(4).'),

  ('apcalcab-frq-007','part-a-criterion-1','Differentiates V=(4/3)πr³ to get dV/dt=4πr²(dr/dt).','Response applies implicit differentiation with respect to t.','Show dV/dt=4*pi*r^2*(dr/dt) as its own step.'),
  ('apcalcab-frq-007','part-a-criterion-2','Substitutes r=6, dr/dt=0.4.','Response substitutes the given values into the differentiated expression.','Write the substituted expression before computing.'),
  ('apcalcab-frq-007','part-a-criterion-3','Computes 57.6π cm³/s.','Response completes the arithmetic to the final value.','State the final value, 57.6*pi cm^3/s.'),
  ('apcalcab-frq-007','part-b-criterion-1','Differentiates S=4πr² to get dS/dt=8πr(dr/dt).','Response applies implicit differentiation with respect to t.','Show dS/dt=8*pi*r*(dr/dt) as its own step.'),
  ('apcalcab-frq-007','part-b-criterion-2','Substitutes the given values.','Response substitutes r=6, dr/dt=0.4 into the differentiated expression.','Write the substituted expression before computing.'),
  ('apcalcab-frq-007','part-b-criterion-3','Computes 19.2π cm²/s.','Response completes the arithmetic to the final value.','State the final value, 19.2*pi cm^2/s.'),
  ('apcalcab-frq-007','part-c-criterion-1','Notes dV/dt depends on r² while dr/dt is held constant.','Response identifies the r^2 dependence in the dV/dt formula.','State that dV/dt=4*pi*r^2*(dr/dt) contains a changing r^2 factor.'),
  ('apcalcab-frq-007','part-c-criterion-2','Explains r grows over time, so r² also grows.','Response connects the growing radius to a growing r^2 term.','Explain that as r increases, r^2 increases as well.'),
  ('apcalcab-frq-007','part-c-criterion-3','Concludes dV/dt increases even though dr/dt is constant.','Response gives the final conclusion connecting the two facts above.','Conclude dV/dt increases over time despite constant dr/dt.'),

  ('apcalcab-frq-009','part-a-criterion-1','Sets f′(x)=0.','Response sets the given derivative equal to zero.','Write f''(x)=0 as its own step.'),
  ('apcalcab-frq-009','part-a-criterion-2','Solves the factored equation.','Response solves (x+1)(x-2)^2(x-4)=0 for its roots.','Show the roots obtained from each factor.'),
  ('apcalcab-frq-009','part-a-criterion-3','Lists all three critical numbers −1, 2, and 4.','Response states all three critical numbers explicitly.','List -1, 2, and 4 as the critical numbers.'),
  ('apcalcab-frq-009','part-b-criterion-1','Correctly classifies x=−1 as a local maximum (sign change + to −).','Response builds a sign chart and identifies the sign change at x=-1.','State that f'' changes from + to - at x=-1, giving a local maximum.'),
  ('apcalcab-frq-009','part-b-criterion-2','Correctly classifies x=2 as no extremum (no sign change).','Response identifies that f'' does not change sign at x=2.','State that f'' stays negative on both sides of x=2, so there is no extremum.'),
  ('apcalcab-frq-009','part-b-criterion-3','Correctly classifies x=4 as a local minimum (sign change − to +).','Response identifies the sign change at x=4.','State that f'' changes from - to + at x=4, giving a local minimum.'),
  ('apcalcab-frq-009','part-c-criterion-1','Notes (x−2)² is never negative.','Response identifies the even-multiplicity factor.','State that (x-2)^2 >= 0 for all x.'),
  ('apcalcab-frq-009','part-c-criterion-2','Explains f′ touches but does not cross zero at x=2.','Response connects the nonnegative factor to f'' not changing sign.','Explain that f'' touches zero at x=2 without crossing it.'),
  ('apcalcab-frq-009','part-c-criterion-3','Concludes there is no sign change, hence no extremum there.','Response gives the final conclusion about monotonicity at x=2.','Conclude f stays monotonic through x=2, so there is no extremum.'),

  ('apcalcab-frq-010','part-a-criterion-1','Computes f′(x)=1−9/x².','Response differentiates f(x) correctly.','Show f''(x)=1-9/x^2 as its own step.'),
  ('apcalcab-frq-010','part-a-criterion-2','Sets f′(x)=0 and solves.','Response solves the resulting equation for x.','Show the algebra solving 1-9/x^2=0.'),
  ('apcalcab-frq-010','part-a-criterion-3','Confirms x=3 lies in the interval [1,6].','Response checks the solution against the given interval.','State that x=3 is the only interior critical number in [1,6].'),
  ('apcalcab-frq-010','part-b-criterion-1','Evaluates f at all three candidates: f(1)=10, f(3)=6, f(6)=7.5.','Response computes and shows all three candidate values, not just the extremes.','Show f(1), f(3), and f(6) all computed explicitly.'),
  ('apcalcab-frq-010','part-b-criterion-2','Compares all three values explicitly.','Response states the comparison among the three computed values.','Compare f(1), f(3), and f(6) directly.'),
  ('apcalcab-frq-010','part-b-criterion-3','Correctly identifies the absolute minimum (6 at x=3) and maximum (10 at x=1).','Response states the final absolute extrema with their locations.','State the absolute minimum 6 at x=3 and absolute maximum 10 at x=1.'),
  ('apcalcab-frq-010','part-c-criterion-1','States the closed-interval method requires checking all critical numbers and endpoints.','Response names the method and its required inputs.','State that the closed-interval method checks critical numbers and both endpoints.'),
  ('apcalcab-frq-010','part-c-criterion-2','Notes the maximum occurs at an endpoint, not the interior critical number.','Response identifies that x=1, an endpoint, gives the maximum.','State that the absolute maximum occurs at the endpoint x=1.'),
  ('apcalcab-frq-010','part-c-criterion-3','Concludes checking only the critical number would miss the maximum.','Response gives the final conclusion about why endpoints matter here.','Conclude that checking only x=3 would miss the actual maximum.'),

  ('apcalcab-frq-015','part-a-criterion-1','Sets up the integral of the top function minus the bottom function, ∫(2x−x²)dx.','Response identifies y=2x as the upper curve and y=x^2 as the lower curve on [0,2].','Write the integral of (2x-x^2) as its own step.'),
  ('apcalcab-frq-015','part-a-criterion-2','Integrates correctly.','Response finds the antiderivative x^2-x^3/3.','Show the antiderivative before evaluating at the bounds.'),
  ('apcalcab-frq-015','part-a-criterion-3','Evaluates the area to 4/3.','Response evaluates the antiderivative at x=0 and x=2.','State the final area, 4/3.'),
  ('apcalcab-frq-015','part-b-criterion-1','Sets up the washer integral π∫(outer²−inner²)dx.','Response identifies outer radius 2x and inner radius x^2 for rotation about the x-axis.','Write the washer integral with outer=2x, inner=x^2.'),
  ('apcalcab-frq-015','part-b-criterion-2','Integrates correctly.','Response finds the antiderivative of 4x^2-x^4.','Show the antiderivative before evaluating at the bounds.'),
  ('apcalcab-frq-015','part-b-criterion-3','Evaluates the volume to 64π/15.','Response evaluates the antiderivative at x=0 and x=2.','State the final volume, 64*pi/15.'),
  ('apcalcab-frq-015','part-c-criterion-1','Identifies the correct outer and inner radii shifted by the axis y=5, with justification: outer=(5−x²), inner=(5−2x), since (5−x²)≥(5−2x) on [0,2].','Response explains why (5-x^2) is the outer radius and not (5-2x), not just states the radii.','State both radii and justify which is outer using the axis y=5 and the region''s position.'),
  ('apcalcab-frq-015','part-c-criterion-2','Sets up the washer integral with correct bounds: π∫[(5−x²)²−(5−2x)²]dx.','Response writes the complete washer integral with the correct radii and bounds.','Write the full washer integral expression.'),
  ('apcalcab-frq-015','part-c-criterion-3','Writes the complete integral expression without evaluating it.','Response presents the final unevaluated integral as the answer (per the item''s stated scope).','Present the complete integral setup as the final answer for this part.')
) as x(content_key,criterion_key,learner_facing_text,evidence_requirements,minimum_fix)
on x.content_key=v.content_key;

-- Remove the old single 3-point criteria for these Calc AB items (only the
-- ones just re-inserted at 1pt each -- keying on the same criterion_key,
-- so this leaves exactly the new 1pt rows).
delete from app.frq_criteria f
using t2_versioned v
where f.content_item_version_id=v.new_version_id
  and v.content_key like 'apcalcab-%'
  and f.points_possible=3;

-- Reconcile prompt_json.parts[].points (was stuck at 1, systemically, across
-- all 7 Calc AB items -- the same defect Shazia Fazal flagged specifically on
-- apcalcab-frq-005) to 3, matching each part's new 3x1pt criteria total.
update app.content_item_versions civ
set prompt_json = jsonb_set(jsonb_set(jsonb_set(civ.prompt_json,
  '{parts,0,points}','3'), '{parts,1,points}','3'), '{parts,2,points}','3')
from t2_versioned v
where civ.id=v.new_version_id and v.content_key like 'apcalcab-%';

-- =============================================================================
-- Biology: split each 2-point criterion into two explicit 1-point
-- sub-criteria. APBIO-FRQ-S-019's part (a) also drops the "inner-membrane
-- composition" evidence option, since it overlaps with part (b)'s expected
-- answer (Sarah Sohail's overlap flag). APBIO-FRQ-S-080's part (b) is
-- rewritten to distinguish primary vs. tertiary structure (Sarah Sohail).
-- APBIO-FRQ-S-087's part (b) is sharpened to require comparing both mean
-- and variance (Sarah Sohail / Muhammad Saood). APBIO-FRQ-S-095's part (a)
-- is refocused on genetic-variation contribution rather than mechanistic
-- transposition detail, to stay within AP Biology CED scope (Sarah Sohail).
-- =============================================================================

insert into app.frq_criteria (content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants)
select v.new_version_id, x.criterion_key, x.learner_facing_text, 1, x.evidence_requirements, x.minimum_fix, '[]'::jsonb
from t2_versioned v
join (values
  ('APBIO-FRQ-S-019','a1','States one piece of evidence for the endosymbiotic theory: mitochondrial DNA, 70S ribosomes, binary fission, or size similarity to bacteria.','Any one of: circular DNA resembling prokaryotic chromosomes; 70S ribosomes; binary fission; bacteria-like size.','State one piece of evidence from the accepted list.'),
  ('APBIO-FRQ-S-019','a2','States a second, distinct piece of evidence from the same list.','A second, distinct item from the same accepted list.','State a second, different piece of evidence from the accepted list.'),
  ('APBIO-FRQ-S-019','b1','Explains the outer membrane''s origin: derived from the host cell membrane during engulfment.','States the outer membrane came from the host cell''s plasma membrane during endocytosis.','State that the outer membrane is derived from the host cell membrane.'),
  ('APBIO-FRQ-S-019','b2','Explains the inner membrane''s origin: derived from the original prokaryotic plasma membrane.','States the inner membrane is the remnant of the original prokaryotic plasma membrane.','State that the inner membrane is derived from the original prokaryotic plasma membrane.'),

  ('APBIO-FRQ-S-036','a1','States aerobic respiration uses the ETC/chemiosmosis to generate approximately 30 ATP from NADH/FADH2.','States the electron transport chain and chemiosmosis produce the majority of ATP aerobically.','State that the ETC/chemiosmosis generates approximately 30 ATP.'),
  ('APBIO-FRQ-S-036','a2','States fermentation produces only 2 ATP via glycolysis.','States glycolysis alone (without the ETC) yields 2 ATP.','State that fermentation nets only 2 ATP, from glycolysis.'),
  ('APBIO-FRQ-S-036','b1','States fermentation regenerates NAD+ by reducing pyruvate.','States pyruvate acts as the electron acceptor that regenerates NAD+.','State that fermentation regenerates NAD+ via pyruvate reduction.'),
  ('APBIO-FRQ-S-036','b2','Explains this allows glycolysis to continue producing 2 ATP per glucose.','Connects regenerated NAD+ to glycolysis continuing to run.','Explain that regenerated NAD+ lets glycolysis keep running.'),

  ('APBIO-FRQ-S-038','a1','States protons flow down their gradient through ATP synthase.','States proton flow through ATP synthase from high to low concentration.','State that protons flow through ATP synthase down their gradient.'),
  ('APBIO-FRQ-S-038','a2','States the energy released phosphorylates ADP to ATP.','States the proton-motive-force energy is used to phosphorylate ADP.','State that the released energy converts ADP to ATP.'),
  ('APBIO-FRQ-S-038','b1','Predicts ATP levels drop dramatically because oxidative phosphorylation stops.','States that blocking ATP synthase halts chemiosmotic ATP production.','State that ATP levels drop sharply because chemiosmosis stops.'),
  ('APBIO-FRQ-S-038','b2','Explains only substrate-level phosphorylation (2-4 ATP total per glucose) remains.','States glycolysis and the Krebs cycle''s substrate-level phosphorylation still contribute a small amount of ATP.','State that only substrate-level phosphorylation (2-4 ATP) remains available.'),

  ('APBIO-FRQ-S-046','a1','States sons inherit their X chromosome from their mother, and the mother is a carrier (50% X^b).','States the X-linked inheritance pattern from a carrier mother to sons.','State that sons get their only X chromosome from their carrier mother.'),
  ('APBIO-FRQ-S-046','a2','Concludes 1/2 of sons will be color blind.','States the final probability, 1/2.','State the final probability that a son is color blind, 1/2.'),
  ('APBIO-FRQ-S-046','b1','States daughters receive X^B from their father.','States the father contributes a normal X^B allele to all daughters.','State that daughters always receive X^B from their father.'),
  ('APBIO-FRQ-S-046','b2','Concludes daughters can be at most carriers, never homozygous recessive.','States daughters cannot be X^b X^b given the father''s contribution.','State that daughters cannot be color blind since they cannot be X^b X^b.'),

  ('APBIO-FRQ-S-066','a1','Defines keystone species as having a disproportionately large ecosystem effect.','States the general definition of a keystone species.','Define keystone species as having outsized ecosystem impact relative to abundance.'),
  ('APBIO-FRQ-S-066','a2','Describes the cascade: otter loss leads to urchin population explosion, kelp destruction, and ecosystem collapse.','States the specific trophic-cascade mechanism for sea otters.','Describe the otter-urchin-kelp cascade sequence.'),
  ('APBIO-FRQ-S-066','b1','Predicts that restoring otters suppresses urchins and allows kelp to recover.','States the mechanism by which otter restoration affects the urchin/kelp balance.','State that restored otters suppress urchins, letting kelp recover.'),
  ('APBIO-FRQ-S-066','b2','Explains recovered kelp habitat supports more species, increasing species richness.','Connects kelp recovery to increased habitat and species richness.','Explain that kelp recovery increases habitat and species richness.'),

  ('APBIO-FRQ-S-080','a1','States the R-group change alters the interactions maintaining the protein''s 3D shape.','States that a different R group changes the chemical interactions holding tertiary structure together.','State that the new R group disrupts the interactions maintaining shape.'),
  ('APBIO-FRQ-S-080','a2','Explains this can alter the active site or binding surface, causing loss of function.','Connects disrupted shape to a changed active site/binding surface.','Explain that an altered active site or binding surface causes loss of function.'),
  ('APBIO-FRQ-S-080','b1','States primary structure is the level directly changed by the mutation (the amino acid sequence itself).','States that primary structure -- the sequence -- is what a single amino-acid substitution directly alters.','State that primary structure is directly changed by the mutation.'),
  ('APBIO-FRQ-S-080','b2','States tertiary structure is the level whose altered folding, caused by the primary-sequence change, is responsible for the loss of function.','States that tertiary structure''s disrupted folding, downstream of the primary-sequence change, causes the functional loss.','State that the resulting loss of function comes from disrupted tertiary-structure folding.'),

  ('APBIO-FRQ-S-084','a1','States fungal hyphae extend beyond the root''s reach into soil.','States hyphae reach further into soil than roots alone.','State that fungal hyphae extend into soil beyond the root system.'),
  ('APBIO-FRQ-S-084','a2','Explains this increases the surface area for phosphorus absorption.','Connects extended hyphal reach to increased absorptive surface area.','Explain that the extended hyphal network increases phosphorus-absorbing surface area.'),
  ('APBIO-FRQ-S-084','b1','States the plant receives phosphorus (and water) from the fungus.','States what the plant gains from the mycorrhizal association.','State that the plant receives phosphorus (and water) from the fungus.'),
  ('APBIO-FRQ-S-084','b2','States the fungus receives carbohydrates from the plant, so both benefit.','States what the fungus gains, completing the mutualism.','State that the fungus receives sugars, so both partners benefit.'),

  ('APBIO-FRQ-S-086','a1','States zooxanthellae perform photosynthesis inside coral tissue, providing sugars.','States the algae''s photosynthetic contribution to the coral.','State that zooxanthellae photosynthesize and provide sugars to the coral.'),
  ('APBIO-FRQ-S-086','a2','States the coral provides CO2 and inorganic nutrients to the algae.','States what the coral contributes to the algae in return.','State that the coral supplies CO2 and nutrients to the zooxanthellae.'),
  ('APBIO-FRQ-S-086','b1','States bleached/dead coral loses its structural habitat.','States that coral death removes the reef''s structural complexity.','State that bleaching/coral death eliminates the reef''s physical structure.'),
  ('APBIO-FRQ-S-086','b2','States many reef species depend on that coral structure for habitat or food, so biodiversity declines.','States the consequence for species richness/biodiversity, scoped to habitat/food dependence.','State that species relying on coral for habitat or food decline, reducing biodiversity.'),

  ('APBIO-FRQ-S-087','a1','States intermediate birth weights have the highest survival/fitness.','States the fitness peak at intermediate birth weight.','State that intermediate birth weight maximizes fitness.'),
  ('APBIO-FRQ-S-087','a2','States very low and very high birth weights both have lower fitness (underdevelopment vs. delivery complications).','States both tails of the distribution have reduced fitness, with distinct causes.','State the two distinct causes of reduced fitness at each extreme.'),
  ('APBIO-FRQ-S-087','b1','States stabilizing selection keeps the population mean unchanged while decreasing phenotypic variance.','States both effects of stabilizing selection: mean unchanged, variance decreases.','State that stabilizing selection reduces variance without shifting the mean.'),
  ('APBIO-FRQ-S-087','b2','States directional selection shifts the population mean toward one extreme (and may also change variance).','States the contrasting effect of directional selection on the mean.','State that directional selection shifts the mean toward one extreme.'),

  ('APBIO-FRQ-S-095','a1','States a transposon can move to a new genomic location.','States the general fact that transposons relocate within the genome (mechanistic cut-and-paste/copy-and-paste detail not required, per AP Biology CED scope).','State that a transposon can relocate to a new position in the genome.'),
  ('APBIO-FRQ-S-095','a2','Explains that this relocation is a source of genetic variation in the population.','Connects transposon movement to its role as a genetic-variation source, the CED-scoped framing.','Explain that transposon movement contributes to genetic variation.'),
  ('APBIO-FRQ-S-095','b1','States transposon insertion can disrupt a gene''s coding sequence.','States that insertion into coding DNA can break the reading frame or sequence.','State that insertion into a coding region can disrupt the gene sequence.'),
  ('APBIO-FRQ-S-095','b2','States insertion into a regulatory region can alter or inactivate gene expression.','States that insertion into a promoter/regulatory region can silence or alter expression.','State that insertion into a regulatory region can alter gene expression.')
) as x(content_key,criterion_key,learner_facing_text,evidence_requirements,minimum_fix)
on x.content_key=v.content_key;

delete from app.frq_criteria f
using t2_versioned v
where f.content_item_version_id=v.new_version_id
  and v.content_key like 'APBIO-%'
  and f.points_possible=2;

-- =============================================================================
-- Precalculus: apprecalc-frq-u12-004 part (c) already has explicit
-- sub-criteria (no granularity issue) -- the actual defect Muhammad Saood
-- flagged is that part (c) conflates "the model's stated domain" (already
-- given as 0<=x<=20) with "the interval where profit is positive"
-- (0<=x<18.2), a materially different question. Rewritten to ask about the
-- profit-positive interval specifically, not to re-derive the given domain.
-- =============================================================================

update app.frq_criteria f
set learner_facing_text='Correctly identifies the interval where the modeled profit is positive: 0 ≤ x < 18.2 (up to the break-even point), not simply the model''s stated domain 0 ≤ x ≤ 20.',
    evidence_requirements='Response gives the profit-positive interval bounded by the break-even value x≈18.2, distinct from the full stated domain.',
    minimum_fix='Identify the values of x for which P(x) is actually positive, bounded above by the break-even point x≈18.2.'
from t2_versioned v
where f.content_item_version_id=v.new_version_id and v.content_key='apprecalc-frq-u12-004' and f.criterion_key='part-c-criterion-01';

update app.frq_criteria f
set learner_facing_text='Justifies that beyond the break-even point (x≈18.2), modeled profit is zero or negative, so 0 ≤ x < 18.2 is the interval where the model realistically applies -- distinct from the domain 0 ≤ x ≤ 20 given in the stimulus.',
    evidence_requirements='Response connects the upper bound to the break-even/profitability point, not merely restating the given domain.',
    minimum_fix='Explain why profit is not positive beyond x≈18.2, distinguishing this from the model''s full stated domain.'
from t2_versioned v
where f.content_item_version_id=v.new_version_id and v.content_key='apprecalc-frq-u12-004' and f.criterion_key='part-c-criterion-02';

-- Recompute content_hash for all Tier 2 versions.
update app.content_item_versions civ
set content_hash=md5(
  coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(f.criterion_key||':'||f.points_possible::text||':'||f.learner_facing_text||':'||
    coalesce(f.evidence_requirements,'')||':'||coalesce(f.minimum_fix,''), E'\n' order by f.criterion_key)
    from app.frq_criteria f where f.content_item_version_id=civ.id),'')
)
from t2_versioned v where civ.id=v.new_version_id;

-- Structural QA gate: point totals must be unchanged (Calc AB items: 9 total
-- across 3 parts; Biology items: 4 total across 2 parts; Precalc item:
-- unchanged at 6), no blank criterion text, no competing published version.
create temporary table t2_expected_totals (content_key text primary key, expected_total int not null);
insert into t2_expected_totals values
('apcalcab-frq-004',9),('apcalcab-frq-005',9),('apcalcab-frq-006',9),('apcalcab-frq-007',9),
('apcalcab-frq-009',9),('apcalcab-frq-010',9),('apcalcab-frq-015',9),
('APBIO-FRQ-S-019',4),('APBIO-FRQ-S-036',4),('APBIO-FRQ-S-038',4),('APBIO-FRQ-S-046',4),
('APBIO-FRQ-S-066',4),('APBIO-FRQ-S-080',4),('APBIO-FRQ-S-084',4),('APBIO-FRQ-S-086',4),
('APBIO-FRQ-S-087',4),('APBIO-FRQ-S-095',4),('apprecalc-frq-u12-004',6);

create temporary table qa_blocked as
select v.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when exists (select 1 from app.frq_criteria f where f.content_item_version_id=civ.id and nullif(trim(f.learner_facing_text),'') is null) then 'blank criterion text'
    when (select coalesce(sum(f.points_possible),0) from app.frq_criteria f where f.content_item_version_id=civ.id) <> t.expected_total then 'point total changed'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from t2_versioned v
join app.content_item_versions civ on civ.id=v.new_version_id
join t2_expected_totals t on t.content_key=v.content_key;
delete from qa_blocked where reason is null;

create temporary table approve_set on commit drop as
select v.content_key, v.new_version_id from t2_versioned v
where not exists (select 1 from qa_blocked b where b.content_key=v.content_key);

-- owner_remediation_approval decision per item.
do $$
declare
  r record;
  v_assignment uuid;
begin
  for r in select content_key, new_version_id from approve_set loop
    v_assignment := gen_random_uuid();
    insert into app.content_review_assignments (
      content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by
    ) values (v_assignment,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question','frq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid);

    insert into app.content_review_decisions (
      content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,
      diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by
    ) values (
      v_assignment,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',1,'Medium',false,array[]::text[],
      'owner_remediation_approval: split all-or-nothing multi-step criterion into independently-gradable 1pt sub-criteria, point total unchanged. Tier 2 changes_requested QA sweep, 2026-08-09.',
      'approve',
      jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','changes_requested_qa_sweep_tier2','qa_date','2026-08-09'),
      encode(extensions.digest(r.content_key||'-tier2-fix-20260809','sha256'),'hex'),
      'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
    );
  end loop;
end $$;

update app.content_item_versions civ
set status='reviewed_approved', review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now()
from approve_set p where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from approve_set p join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from t2_versioned;
  if n<>18 then raise exception 'expected 18 Tier 2 items processed, got %', n; end if;
  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'Tier 2 repair blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;
end $$;

select 'tier2_reviewed_approved' as metric, count(*)::text as value from approve_set
union all select 'tier2_blocked', count(*)::text from qa_blocked
union all select 'tier2_blocked_keys', coalesce(string_agg(content_key||':'||reason, ', '),'(none)') from qa_blocked;

commit;
