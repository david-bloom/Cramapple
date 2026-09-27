-- AP Physics C: Mechanics servability work (docs/product/SUBJECT_SERVABILITY_CRITERIA.md), criterion 4.
-- Authors canonical_answer_1 + canonical_answer_spans for the 29 published Physics C: Mechanics FRQ
-- items that had a blank canonical_answer_1 (apphycm-frq-001/004/005/007/009/010/011/012/013/015/
-- 016/017/018/020/024/027/030/031/032/033/034/035/036/037/044/047/049/050/051), following the same
-- pattern as supabase/migrations/20260925010000_apcalcab_canonical_answers_33_items.sql: each answer's
-- text is composed of criterion-exclusive spans (one span per frq_criteria.criterion_key, plus
-- assembly_literal separators), verified to concatenate exactly to canonical_answer_1.
--
-- Content investigation: read every item's stem, stimulus, and frq_criteria directly. All 29 are
-- genuine, complete, production-quality FRQ content spanning kinematics, Newton's second law, drag
-- forces, impulse-momentum, rotational dynamics and moment of inertia, energy methods, oscillations,
-- gravitation/orbits, and experimental-design items -- none are placeholder/draft-quality, so all 29
-- get canonical answers, not an unpublish recommendation.
--
-- Every value in every canonical answer was independently re-derived from first principles (not
-- copied from the rubric's learner_facing_text) -- each item's math and physics were re-worked from
-- scratch and cross-checked against the rubric's stated correct values, confirming the rubric text was
-- itself correct.
--
-- Verification before writing this migration:
-- (1) every one of the 29 items' full criterion_key set was re-fetched fresh from Production
--     immediately before authoring (not from memory/an earlier session state) and matched exactly
--     against the authored spans -- no criterion missing, none extra, none duplicated;
-- (2) span concatenation per item was verified programmatically to equal canonical_answer_1 byte for
--     byte before generating this SQL;
-- (3) all 29 target rows were confirmed to have canonical_answer_1 IS NULL beforehand -- this is a
--     pure addition, nothing is overwritten.
-- A second, live verification (concatenation of the actually-inserted spans vs. the actually-written
-- canonical_answer_1) runs inside each transaction below, and a third, independent check ran via a
-- separate execute_sql call after apply (against Production), confirming total_items=29,
-- has_canonical=29, concat_matches=29, per this session's standing verification discipline.
--
-- Applied to Production (pcntajvbdfqhbeewmdry) as six separate migrations
-- (apphysicscm_canonical_answers_batch_1 through _batch_6) on 2026-09-25; this file concatenates those
-- six self-contained transactions, in the same order, for the repo's migration ledger record.
--
-- Rollback: set canonical_answer_1 back to null and delete the inserted canonical_answer_spans rows
-- for the 29 content_item_version_ids referenced in the do-blocks below, if ever needed.

begin;

-- apphycm-frq-001 (582c18e0-f56a-4813-8751-efb8e0b5a671)
update app.content_item_versions set canonical_answer_1 = '(a) Integrating v(t)=αt² with respect to t and using x(0)=0 to fix the constant: x(t)=αt³/3. Differentiating v(t) with respect to t: a(t)=2αt.

(b) x(t) is obtained by integrating v(t)=αt² over time, with the condition x(0)=0 used to eliminate the constant of integration that would otherwise appear. a(t) is obtained by differentiating v(t) with respect to time, since acceleration is the time derivative of velocity.' where id = '582c18e0-f56a-4813-8751-efb8e0b5a671';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('582c18e0-f56a-4813-8751-efb8e0b5a671', 'canonical_answer_1', 1, '(a) Integrating v(t)=αt² with respect to t and using x(0)=0 to fix the constant: x(t)=αt³/3. Differentiating v(t) with respect to t: a(t)=2αt.', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('582c18e0-f56a-4813-8751-efb8e0b5a671', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('582c18e0-f56a-4813-8751-efb8e0b5a671', 'canonical_answer_1', 3, '(b) x(t) is obtained by integrating v(t)=αt² over time, with the condition x(0)=0 used to eliminate the constant of integration that would otherwise appear. a(t) is obtained by differentiating v(t) with respect to time, since acceleration is the time derivative of velocity.', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-004 (c0cf107a-725e-4242-87f4-943f74e9523b)
update app.content_item_versions set canonical_answer_1 = '(a) The impulse delivered is the integral of F(t) from 0 to T: integral of F0(1-t/T) dt from 0 to T = F0[t-t^2/(2T)] from 0 to T = F0(T-T/2)=F0*T/2. Since the mass starts at rest, its final momentum equals this impulse: p_final=F0*T/2.

(b) The area under the F(t)-vs-t graph is, by definition, the integral of F dt, which equals the impulse delivered. By the impulse-momentum theorem, this impulse equals the change in momentum, Δp. Because the mass starts at rest, its initial momentum is zero, so its final momentum equals the total impulse delivered -- the same F0*T/2 found in part (a).' where id = 'c0cf107a-725e-4242-87f4-943f74e9523b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c0cf107a-725e-4242-87f4-943f74e9523b', 'canonical_answer_1', 1, '(a) The impulse delivered is the integral of F(t) from 0 to T: integral of F0(1-t/T) dt from 0 to T = F0[t-t^2/(2T)] from 0 to T = F0(T-T/2)=F0*T/2. Since the mass starts at rest, its final momentum equals this impulse: p_final=F0*T/2.', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c0cf107a-725e-4242-87f4-943f74e9523b', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c0cf107a-725e-4242-87f4-943f74e9523b', 'canonical_answer_1', 3, '(b) The area under the F(t)-vs-t graph is, by definition, the integral of F dt, which equals the impulse delivered. By the impulse-momentum theorem, this impulse equals the change in momentum, Δp. Because the mass starts at rest, its initial momentum is zero, so its final momentum equals the total impulse delivered -- the same F0*T/2 found in part (a).', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-005 (1563ed28-e535-42a5-8e70-951459b70d01)
update app.content_item_versions set canonical_answer_1 = '(a) The graph of ω(t) starts at ω=0 and rises rapidly at first, then gradually levels off toward a finite maximum value as t increases. The initial slope of this curve is the initial angular acceleration, τ0/I (the torque at t=0 divided by I). The long-time asymptote the curve approaches is the limiting angular velocity, τ0*T/I.

(b) Because the applied torque τ(t)=τ0*e^(-t/T) decreases exponentially with time, the angular acceleration dω/dt=τ(t)/I also decreases as t increases. This causes the slope of the ω(t) curve to become progressively smaller (flatter) as time goes on, which is why the curve levels off toward its asymptote rather than continuing to rise at a constant rate.' where id = '1563ed28-e535-42a5-8e70-951459b70d01';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1563ed28-e535-42a5-8e70-951459b70d01', 'canonical_answer_1', 1, '(a) The graph of ω(t) starts at ω=0 and rises rapidly at first, then gradually levels off toward a finite maximum value as t increases. The initial slope of this curve is the initial angular acceleration, τ0/I (the torque at t=0 divided by I). The long-time asymptote the curve approaches is the limiting angular velocity, τ0*T/I.', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1563ed28-e535-42a5-8e70-951459b70d01', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1563ed28-e535-42a5-8e70-951459b70d01', 'canonical_answer_1', 3, '(b) Because the applied torque τ(t)=τ0*e^(-t/T) decreases exponentially with time, the angular acceleration dω/dt=τ(t)/I also decreases as t increases. This causes the slope of the ω(t) curve to become progressively smaller (flatter) as time goes on, which is why the curve levels off toward its asymptote rather than continuing to rise at a constant rate.', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-007 (bef2c1e6-b959-4106-94fe-4d7e803946c2)
update app.content_item_versions set canonical_answer_1 = '(a) For small angles, the restoring torque is approximately -Mgd*θ, so a graph of torque versus angle θ is a straight line through the origin with slope -Mgd. This linear, Hooke''s-law-like relationship between torque and angular displacement is exactly what produces simple harmonic motion, with the magnitude of the slope (Mgd) playing the role of an effective torsional stiffness, giving the period T=2*pi*sqrt(I/(Mgd)).

(b) The approximation sin(theta)≈theta is a small-angle (Taylor series) approximation whose error grows as theta increases, so it is only accurate for small-amplitude oscillations. As the amplitude grows larger, the true restoring torque -Mgd*sin(theta) increasingly deviates from the linear approximation -Mgd*theta used to derive T=2*pi*sqrt(I/(Mgd)), so the actual period of the pendulum increasingly deviates from this formula''s prediction as amplitude increases.' where id = 'bef2c1e6-b959-4106-94fe-4d7e803946c2';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bef2c1e6-b959-4106-94fe-4d7e803946c2', 'canonical_answer_1', 1, '(a) For small angles, the restoring torque is approximately -Mgd*θ, so a graph of torque versus angle θ is a straight line through the origin with slope -Mgd. This linear, Hooke''s-law-like relationship between torque and angular displacement is exactly what produces simple harmonic motion, with the magnitude of the slope (Mgd) playing the role of an effective torsional stiffness, giving the period T=2*pi*sqrt(I/(Mgd)).', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bef2c1e6-b959-4106-94fe-4d7e803946c2', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bef2c1e6-b959-4106-94fe-4d7e803946c2', 'canonical_answer_1', 3, '(b) The approximation sin(theta)≈theta is a small-angle (Taylor series) approximation whose error grows as theta increases, so it is only accurate for small-amplitude oscillations. As the amplitude grows larger, the true restoring torque -Mgd*sin(theta) increasingly deviates from the linear approximation -Mgd*theta used to derive T=2*pi*sqrt(I/(Mgd)), so the actual period of the pendulum increasingly deviates from this formula''s prediction as amplitude increases.', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-009 (b5b41e26-e424-4e1d-9ce1-7c855a6ed663)
update app.content_item_versions set canonical_answer_1 = '(a) A feasible measurement design: release the mass with its known initial speed v0 through the medium, and measure its speed v at successive times t (for example using a motion sensor). From the change in v over time, determine the acceleration, and use the known mass to compute the net force via F=ma; compare this measured force to the corresponding measured speed to test whether they are proportional, as predicted by F=-bv. The independent variable is elapsed time t, the dependent variable is the measured speed v (from which the drag force is derived), and a control is holding the mass, the medium, the temperature, and the overall experimental setup fixed across all trials.

(b) The linear-drag model m*dv/dt=-bv predicts an exponential decay v(t)=v0*e^(-bt/m) with a single constant time-constant τ=m/b that does not depend on the instantaneous speed. If the measured decay is well-described by a single constant time constant across the tested range of speeds, this supports the assumption that drag remains proportional to v (rather than becoming, for example, proportional to v² due to turbulence) throughout that speed range, which is exactly the assumption the proposed measurement is designed to test.' where id = 'b5b41e26-e424-4e1d-9ce1-7c855a6ed663';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b5b41e26-e424-4e1d-9ce1-7c855a6ed663', 'canonical_answer_1', 1, '(a) A feasible measurement design: release the mass with its known initial speed v0 through the medium, and measure its speed v at successive times t (for example using a motion sensor). From the change in v over time, determine the acceleration, and use the known mass to compute the net force via F=ma; compare this measured force to the corresponding measured speed to test whether they are proportional, as predicted by F=-bv. The independent variable is elapsed time t, the dependent variable is the measured speed v (from which the drag force is derived), and a control is holding the mass, the medium, the temperature, and the overall experimental setup fixed across all trials.', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b5b41e26-e424-4e1d-9ce1-7c855a6ed663', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b5b41e26-e424-4e1d-9ce1-7c855a6ed663', 'canonical_answer_1', 3, '(b) The linear-drag model m*dv/dt=-bv predicts an exponential decay v(t)=v0*e^(-bt/m) with a single constant time-constant τ=m/b that does not depend on the instantaneous speed. If the measured decay is well-described by a single constant time constant across the tested range of speeds, this supports the assumption that drag remains proportional to v (rather than becoming, for example, proportional to v² due to turbulence) throughout that speed range, which is exactly the assumption the proposed measurement is designed to test.', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-010 (167a3e58-bc4b-4857-bd38-d3eac681ec1a)
update app.content_item_versions set canonical_answer_1 = '(a) A feasible measurement design: measure the restoring force F on the particle at a range of displacements x, and use F(x)=-dU/dx=-4ax^3+2bx to locate ALL three equilibrium points where F(x)=0 -- namely x=0 and x=±sqrt(b/(2a)). At each of these three points, examine the direction of the measured force for small displacements on either side of it (not just confirm the force is zero there) to determine whether the equilibrium is stable (force points back toward the equilibrium) or unstable (force points away). The independent variable is displacement x, the dependent variable is the measured force F(x), and a control is keeping the potential''s coefficients a and b (i.e. the same physical apparatus) fixed across all trials.

(b) An equilibrium point is stable when U''''(x)>0 there (a local minimum of the potential), because this is exactly the condition under which the force is restoring for small displacements on either side -- pushing the particle back toward the equilibrium rather than away from it. Identifying which equilibria are stable this way does not require negligible friction: friction affects how quickly the particle settles into (or oscillates around) a stable equilibrium once displaced, but it does not change where the equilibrium points are located or whether the underlying force there is restoring or not.' where id = '167a3e58-bc4b-4857-bd38-d3eac681ec1a';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('167a3e58-bc4b-4857-bd38-d3eac681ec1a', 'canonical_answer_1', 1, '(a) A feasible measurement design: measure the restoring force F on the particle at a range of displacements x, and use F(x)=-dU/dx=-4ax^3+2bx to locate ALL three equilibrium points where F(x)=0 -- namely x=0 and x=±sqrt(b/(2a)). At each of these three points, examine the direction of the measured force for small displacements on either side of it (not just confirm the force is zero there) to determine whether the equilibrium is stable (force points back toward the equilibrium) or unstable (force points away). The independent variable is displacement x, the dependent variable is the measured force F(x), and a control is keeping the potential''s coefficients a and b (i.e. the same physical apparatus) fixed across all trials.', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('167a3e58-bc4b-4857-bd38-d3eac681ec1a', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('167a3e58-bc4b-4857-bd38-d3eac681ec1a', 'canonical_answer_1', 3, '(b) An equilibrium point is stable when U''''(x)>0 there (a local minimum of the potential), because this is exactly the condition under which the force is restoring for small displacements on either side -- pushing the particle back toward the equilibrium rather than away from it. Identifying which equilibria are stable this way does not require negligible friction: friction affects how quickly the particle settles into (or oscillates around) a stable equilibrium once displaced, but it does not change where the equilibrium points are located or whether the underlying force there is restoring or not.', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('582c18e0-f56a-4813-8751-efb8e0b5a671'::uuid),('c0cf107a-725e-4242-87f4-943f74e9523b'::uuid),('1563ed28-e535-42a5-8e70-951459b70d01'::uuid),('bef2c1e6-b959-4106-94fe-4d7e803946c2'::uuid),('b5b41e26-e424-4e1d-9ce1-7c855a6ed663'::uuid),('167a3e58-bc4b-4857-bd38-d3eac681ec1a'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;
begin;

-- apphycm-frq-011 (2b0ed52f-72a3-40ee-a190-4d87099ddd2b)
update app.content_item_versions set canonical_answer_1 = '(a) A feasible measurement design: apply the known force profile F(t) to the mass, measure the object''s final velocity after the pulse ends, and compute the impulse from the area under the recorded F(t) graph; compare this computed impulse to the measured change in momentum (mass times final velocity, since it starts at rest). Vary the peak force F0 as the independent variable, measure the resulting final momentum p as the dependent variable, and hold the pulse duration T, the object''s mass, and the initial-rest condition fixed as controls across trials.

(b) The area under the F(t) graph represents the impulse delivered to the mass, which by the impulse-momentum theorem should equal its change in momentum. The design''s validity rests on the stated assumption that no momentum is lost to other interactions during the measurement -- meaning other external forces (such as friction) and any other impulses besides the applied F(t) are negligible -- since otherwise the measured change in momentum would not equal the impulse computed from F(t) alone.' where id = '2b0ed52f-72a3-40ee-a190-4d87099ddd2b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2b0ed52f-72a3-40ee-a190-4d87099ddd2b', 'canonical_answer_1', 1, '(a) A feasible measurement design: apply the known force profile F(t) to the mass, measure the object''s final velocity after the pulse ends, and compute the impulse from the area under the recorded F(t) graph; compare this computed impulse to the measured change in momentum (mass times final velocity, since it starts at rest). Vary the peak force F0 as the independent variable, measure the resulting final momentum p as the dependent variable, and hold the pulse duration T, the object''s mass, and the initial-rest condition fixed as controls across trials.', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2b0ed52f-72a3-40ee-a190-4d87099ddd2b', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2b0ed52f-72a3-40ee-a190-4d87099ddd2b', 'canonical_answer_1', 3, '(b) The area under the F(t) graph represents the impulse delivered to the mass, which by the impulse-momentum theorem should equal its change in momentum. The design''s validity rests on the stated assumption that no momentum is lost to other interactions during the measurement -- meaning other external forces (such as friction) and any other impulses besides the applied F(t) are negligible -- since otherwise the measured change in momentum would not equal the impulse computed from F(t) alone.', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-012 (877f60ba-7e2d-4e0d-9778-7b04264d58b9)
update app.content_item_versions set canonical_answer_1 = '(a) A feasible measurement design: measure the disk''s angular velocity ω at successive times t, determine the angular acceleration from the change in ω over time, and compare this measured angular acceleration to the known applied torque divided by the moment of inertia, τ(t)/I, to test the rotational form of Newton''s second law, I*dω/dt=τ. The independent variable is elapsed time t, the dependent variable is the measured angular velocity ω (from which angular acceleration is derived), and a control is holding the disk''s moment of inertia I fixed across trials.

(b) Negligible bearing friction ensures that the measured angular acceleration is caused mainly by the applied torque τ(t), rather than being partly masked or altered by an additional, unmodeled frictional torque -- this is essential for the comparison in part (a) to isolate the relationship being tested. As t approaches infinity, the applied torque τ(t)=τ0*e^(-t/T) approaches zero, so dω/dt approaches zero and ω approaches a finite limiting value. Integrating I*dω/dt=τ0*e^(-t/T) from t=0 to infinity gives I*ω_max=integral of τ0*e^(-t/T) dt from 0 to infinity = τ0*T, so ω_max=τ0*T/I.' where id = '877f60ba-7e2d-4e0d-9778-7b04264d58b9';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('877f60ba-7e2d-4e0d-9778-7b04264d58b9', 'canonical_answer_1', 1, '(a) A feasible measurement design: measure the disk''s angular velocity ω at successive times t, determine the angular acceleration from the change in ω over time, and compare this measured angular acceleration to the known applied torque divided by the moment of inertia, τ(t)/I, to test the rotational form of Newton''s second law, I*dω/dt=τ. The independent variable is elapsed time t, the dependent variable is the measured angular velocity ω (from which angular acceleration is derived), and a control is holding the disk''s moment of inertia I fixed across trials.', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('877f60ba-7e2d-4e0d-9778-7b04264d58b9', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('877f60ba-7e2d-4e0d-9778-7b04264d58b9', 'canonical_answer_1', 3, '(b) Negligible bearing friction ensures that the measured angular acceleration is caused mainly by the applied torque τ(t), rather than being partly masked or altered by an additional, unmodeled frictional torque -- this is essential for the comparison in part (a) to isolate the relationship being tested. As t approaches infinity, the applied torque τ(t)=τ0*e^(-t/T) approaches zero, so dω/dt approaches zero and ω approaches a finite limiting value. Integrating I*dω/dt=τ0*e^(-t/T) from t=0 to infinity gives I*ω_max=integral of τ0*e^(-t/T) dt from 0 to infinity = τ0*T, so ω_max=τ0*T/I.', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-013 (d119c3f3-c224-45f6-8f2d-7370c87fddc1)
update app.content_item_versions set canonical_answer_1 = '(a) Since I=M*L²/2 for this rod (with M held fixed), doubling L quadruples the moment of inertia: I_new=M*(2L)²/2=4*(M*L²/2)=4*I_original.

(b) The rod''s mass is distributed continuously according to the length-dependent shape λ(x)=2Mx/L² (weighted toward the far end from the pivot), rather than being concentrated entirely at a single point. This continuous, length-scaled mass distribution is what produces a different numerical prefactor c in the general form I=c*M*L² -- here c=1/2 -- compared to a naive point-mass estimate (which would give c=1, treating all the mass as located at x=L) or a uniform rod (which gives c=1/3). All three cases scale as L² with total mass M held fixed, but the specific value of c depends on exactly how the mass is distributed along the rod''s length, which is the deeper reason the coefficient differs even though the power of L does not.' where id = 'd119c3f3-c224-45f6-8f2d-7370c87fddc1';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d119c3f3-c224-45f6-8f2d-7370c87fddc1', 'canonical_answer_1', 1, '(a) Since I=M*L²/2 for this rod (with M held fixed), doubling L quadruples the moment of inertia: I_new=M*(2L)²/2=4*(M*L²/2)=4*I_original.', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d119c3f3-c224-45f6-8f2d-7370c87fddc1', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d119c3f3-c224-45f6-8f2d-7370c87fddc1', 'canonical_answer_1', 3, '(b) The rod''s mass is distributed continuously according to the length-dependent shape λ(x)=2Mx/L² (weighted toward the far end from the pivot), rather than being concentrated entirely at a single point. This continuous, length-scaled mass distribution is what produces a different numerical prefactor c in the general form I=c*M*L² -- here c=1/2 -- compared to a naive point-mass estimate (which would give c=1, treating all the mass as located at x=L) or a uniform rod (which gives c=1/3). All three cases scale as L² with total mass M held fixed, but the specific value of c depends on exactly how the mass is distributed along the rod''s length, which is the deeper reason the coefficient differs even though the power of L does not.', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-015 (317345d1-4f50-4fdd-964b-85eff3195244)
update app.content_item_versions set canonical_answer_1 = '(a) At any fixed time t, doubling α doubles both x(t)=α*t³/3 and a(t)=2*α*t, since both expressions are directly (linearly) proportional to α.

(b) Integration and differentiation are both linear operations: if a quantity like v(t)=α*t² is directly proportional to α, then any quantity obtained from it by integrating over time (such as position) or differentiating with respect to time (such as acceleration) must also be directly proportional to α. This is because scaling v(t) by any constant factor scales its integral and its derivative by that same factor -- so doubling α doubles both x(t) and a(t), regardless of the specific form of v(t) beyond its being proportional to α.' where id = '317345d1-4f50-4fdd-964b-85eff3195244';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('317345d1-4f50-4fdd-964b-85eff3195244', 'canonical_answer_1', 1, '(a) At any fixed time t, doubling α doubles both x(t)=α*t³/3 and a(t)=2*α*t, since both expressions are directly (linearly) proportional to α.', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('317345d1-4f50-4fdd-964b-85eff3195244', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('317345d1-4f50-4fdd-964b-85eff3195244', 'canonical_answer_1', 3, '(b) Integration and differentiation are both linear operations: if a quantity like v(t)=α*t² is directly proportional to α, then any quantity obtained from it by integrating over time (such as position) or differentiating with respect to time (such as acceleration) must also be directly proportional to α. This is because scaling v(t) by any constant factor scales its integral and its derivative by that same factor -- so doubling α doubles both x(t) and a(t), regardless of the specific form of v(t) beyond its being proportional to α.', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-016 (09aa37fc-4cb2-4718-82f1-3a19ee1bd15f)
update app.content_item_versions set canonical_answer_1 = '(a) Doubling the drag coefficient b halves the time constant τ=m/b, so the velocity v(t)=v0*e^(-2bt/m) decays twice as fast as before. The total stopping distance x(infinity)=m*v0/b is also halved, since it is inversely proportional to b.

(b) Both quantities are inversely proportional to b for a general reason, not specific to any particular numbers: the time constant τ=m/b comes directly from solving the equation of motion m*dv/dt=-b*v, so it is inherently proportional to 1/b. The total stopping distance is the time-integral of v(t), x(infinity)=integral of v(t) dt from 0 to infinity=v0*τ, which inherits its 1/b dependence directly from τ. So both the time constant and the stopping distance scale as 1/b simply because both are built from the same underlying τ=m/b.' where id = '09aa37fc-4cb2-4718-82f1-3a19ee1bd15f';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09aa37fc-4cb2-4718-82f1-3a19ee1bd15f', 'canonical_answer_1', 1, '(a) Doubling the drag coefficient b halves the time constant τ=m/b, so the velocity v(t)=v0*e^(-2bt/m) decays twice as fast as before. The total stopping distance x(infinity)=m*v0/b is also halved, since it is inversely proportional to b.', ARRAY['part-a'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09aa37fc-4cb2-4718-82f1-3a19ee1bd15f', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('09aa37fc-4cb2-4718-82f1-3a19ee1bd15f', 'canonical_answer_1', 3, '(b) Both quantities are inversely proportional to b for a general reason, not specific to any particular numbers: the time constant τ=m/b comes directly from solving the equation of motion m*dv/dt=-b*v, so it is inherently proportional to 1/b. The total stopping distance is the time-integral of v(t), x(infinity)=integral of v(t) dt from 0 to infinity=v0*τ, which inherits its 1/b dependence directly from τ. So both the time constant and the stopping distance scale as 1/b simply because both are built from the same underlying τ=m/b.', ARRAY['part-b'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-017 (57c6fbdf-72dc-4205-9d04-8dc339144511)
update app.content_item_versions set canonical_answer_1 = '(a) The position vector is r(t) = (v0*cos(theta)*t) i + (v0*sin(theta)*t - (1/2)*g*t²) j.

The velocity vector is v(t) = (v0*cos(theta)) i + (v0*sin(theta) - g*t) j.

Relating the components to motion graphs: the horizontal position increases linearly with time (constant slope), the horizontal velocity is constant (a flat horizontal line), the vertical position traces a concave-down parabola (rising then falling), and the vertical velocity decreases linearly with time (a straight line with negative slope -g).

(b) Setting the vertical position to zero, v0*sin(theta)*t-(1/2)*g*t²=0, gives t=0 or t=2*v0*sin(theta)/g; the nonzero return time is t_f=2*v0*sin(theta)/g.

The horizontal range is R=x(t_f)=v0*cos(theta)*t_f=v0*cos(theta)*(2*v0*sin(theta)/g)=2*v0²*sin(theta)*cos(theta)/g=v0²*sin(2*theta)/g.

(c) At the top of the trajectory, the vertical velocity is zero, so the velocity is entirely horizontal with speed v0*cos(theta); since gravity there is entirely perpendicular to the velocity, the normal acceleration at that point equals g, the full acceleration due to gravity.

The radius of curvature is rho=v²/a_n=(v0*cos(theta))²/g=v0²*cos²(theta)/g.' where id = '57c6fbdf-72dc-4205-9d04-8dc339144511';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 1, '(a) The position vector is r(t) = (v0*cos(theta)*t) i + (v0*sin(theta)*t - (1/2)*g*t²) j.', ARRAY['a-position'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 3, 'The velocity vector is v(t) = (v0*cos(theta)) i + (v0*sin(theta) - g*t) j.', ARRAY['a-velocity'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 5, 'Relating the components to motion graphs: the horizontal position increases linearly with time (constant slope), the horizontal velocity is constant (a flat horizontal line), the vertical position traces a concave-down parabola (rising then falling), and the vertical velocity decreases linearly with time (a straight line with negative slope -g).', ARRAY['a-graphs'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 7, '(b) Setting the vertical position to zero, v0*sin(theta)*t-(1/2)*g*t²=0, gives t=0 or t=2*v0*sin(theta)/g; the nonzero return time is t_f=2*v0*sin(theta)/g.', ARRAY['b-time'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 9, 'The horizontal range is R=x(t_f)=v0*cos(theta)*t_f=v0*cos(theta)*(2*v0*sin(theta)/g)=2*v0²*sin(theta)*cos(theta)/g=v0²*sin(2*theta)/g.', ARRAY['b-range'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 11, '(c) At the top of the trajectory, the vertical velocity is zero, so the velocity is entirely horizontal with speed v0*cos(theta); since gravity there is entirely perpendicular to the velocity, the normal acceleration at that point equals g, the full acceleration due to gravity.', ARRAY['c-normal'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57c6fbdf-72dc-4205-9d04-8dc339144511', 'canonical_answer_1', 13, 'The radius of curvature is rho=v²/a_n=(v0*cos(theta))²/g=v0²*cos²(theta)/g.', ARRAY['c-radius'], 'drafted', 'apphysicscm_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('2b0ed52f-72a3-40ee-a190-4d87099ddd2b'::uuid),('877f60ba-7e2d-4e0d-9778-7b04264d58b9'::uuid),('d119c3f3-c224-45f6-8f2d-7370c87fddc1'::uuid),('317345d1-4f50-4fdd-964b-85eff3195244'::uuid),('09aa37fc-4cb2-4718-82f1-3a19ee1bd15f'::uuid),('57c6fbdf-72dc-4205-9d04-8dc339144511'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;
begin;

-- apphycm-frq-018 (086cbead-f233-42d0-ada2-a1f48dfa51ec)
update app.content_item_versions set canonical_answer_1 = '(a) Applying Newton''s second law with gravity mg downward (positive) and drag c*v² upward (opposing the downward motion): m*dv/dt=mg-c*v².

At terminal speed, dv/dt=0, so mg=c*v_t², giving v_t=sqrt(mg/c).

(b) Rewriting the equation of motion using v_t²=mg/c: dv/dt=g-(c/m)*v²=g*(1-v²/v_t²), which separates as dv/[g*(1-v²/v_t²)]=dt.

Integrating this separated equation (a standard integral of the form leading to the inverse hyperbolic tangent) with the initial condition v(0)=0 gives v(t)=v_t*tanh(g*t/v_t).

(c) The acceleration a(t)=dv/dt=g*(1-tanh²(g*t/v_t))=g*sech²(g*t/v_t) starts at g when t=0 and decreases monotonically toward 0 as t increases, since tanh(g*t/v_t) approaches 1.

The speed v(t)=v_t*tanh(g*t/v_t) increases monotonically from 0, approaching the terminal speed v_t asymptotically, with its rate of increase (the slope of the v-t graph, which is the acceleration) continually decreasing as it approaches v_t -- consistent with the decreasing acceleration described above.' where id = '086cbead-f233-42d0-ada2-a1f48dfa51ec';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 1, '(a) Applying Newton''s second law with gravity mg downward (positive) and drag c*v² upward (opposing the downward motion): m*dv/dt=mg-c*v².', ARRAY['a-equation'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 3, 'At terminal speed, dv/dt=0, so mg=c*v_t², giving v_t=sqrt(mg/c).', ARRAY['a-terminal'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 5, '(b) Rewriting the equation of motion using v_t²=mg/c: dv/dt=g-(c/m)*v²=g*(1-v²/v_t²), which separates as dv/[g*(1-v²/v_t²)]=dt.', ARRAY['b-separate'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 7, 'Integrating this separated equation (a standard integral of the form leading to the inverse hyperbolic tangent) with the initial condition v(0)=0 gives v(t)=v_t*tanh(g*t/v_t).', ARRAY['b-solution'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 9, '(c) The acceleration a(t)=dv/dt=g*(1-tanh²(g*t/v_t))=g*sech²(g*t/v_t) starts at g when t=0 and decreases monotonically toward 0 as t increases, since tanh(g*t/v_t) approaches 1.', ARRAY['c-accel'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('086cbead-f233-42d0-ada2-a1f48dfa51ec', 'canonical_answer_1', 11, 'The speed v(t)=v_t*tanh(g*t/v_t) increases monotonically from 0, approaching the terminal speed v_t asymptotically, with its rate of increase (the slope of the v-t graph, which is the acceleration) continually decreasing as it approaches v_t -- consistent with the decreasing acceleration described above.', ARRAY['c-speed'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-020 (3b89db83-f0dc-42d8-aaab-0bd815f2cbba)
update app.content_item_versions set canonical_answer_1 = '(a) Measure the mock-up''s radial acceleration at several different separations r from the fixed source, while keeping both the mock-up''s mass and the source''s mass unchanged across all trials.

Transform the measured data according to the inverse-square prediction by plotting acceleration versus 1/r² (rather than versus r directly), and evaluate whether the resulting points form a straight line through (or near) the origin -- this test works without needing to know the force constant K in advance, since K only determines the slope of that line, not whether the relationship is linear.

(b) The inverse-square model predicts that a plot of acceleration versus 1/r² should be a straight line passing through the origin (zero acceleration at 1/r²=0).

To distinguish this from a simple 1/r force, compare the quality of a linear fit to acceleration-versus-1/r² against a linear fit to acceleration-versus-1/r: the model whose plot is more linear, has an intercept closer to zero, and shows residuals that are randomly (rather than systematically) scattered around the fit line is the better-supported model.' where id = '3b89db83-f0dc-42d8-aaab-0bd815f2cbba';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3b89db83-f0dc-42d8-aaab-0bd815f2cbba', 'canonical_answer_1', 1, '(a) Measure the mock-up''s radial acceleration at several different separations r from the fixed source, while keeping both the mock-up''s mass and the source''s mass unchanged across all trials.', ARRAY['a-data'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3b89db83-f0dc-42d8-aaab-0bd815f2cbba', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3b89db83-f0dc-42d8-aaab-0bd815f2cbba', 'canonical_answer_1', 3, 'Transform the measured data according to the inverse-square prediction by plotting acceleration versus 1/r² (rather than versus r directly), and evaluate whether the resulting points form a straight line through (or near) the origin -- this test works without needing to know the force constant K in advance, since K only determines the slope of that line, not whether the relationship is linear.', ARRAY['a-transform'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3b89db83-f0dc-42d8-aaab-0bd815f2cbba', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3b89db83-f0dc-42d8-aaab-0bd815f2cbba', 'canonical_answer_1', 5, '(b) The inverse-square model predicts that a plot of acceleration versus 1/r² should be a straight line passing through the origin (zero acceleration at 1/r²=0).', ARRAY['b-graph'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3b89db83-f0dc-42d8-aaab-0bd815f2cbba', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3b89db83-f0dc-42d8-aaab-0bd815f2cbba', 'canonical_answer_1', 7, 'To distinguish this from a simple 1/r force, compare the quality of a linear fit to acceleration-versus-1/r² against a linear fit to acceleration-versus-1/r: the model whose plot is more linear, has an intercept closer to zero, and shows residuals that are randomly (rather than systematically) scattered around the fit line is the better-supported model.', ARRAY['b-distinguish'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-024 (5fcb4563-b353-4692-98aa-af5b356af902)
update app.content_item_versions set canonical_answer_1 = '(a) Measure the restoring force at several nearby positions and locate x0 as the point where the measured restoring force is zero, with the force pointing back toward x0 (restoring) on both sides of it.

Fit the measured restoring force F versus displacement x near x0 with a straight line over a small range, and take the effective spring constant as k_eff=-dF/dx evaluated at x0 (the negative of the local slope).

(b) The predicted small-oscillation period is T=2*pi*sqrt(m/k_eff), using the effective spring constant found in part (a).

Test this prediction by measuring the actual oscillation period from repeated position-versus-time cycles at several different small amplitudes.

Explicitly compare each measured small-amplitude period to the value predicted by T=2*pi*sqrt(m/k_eff) from part (a), to determine how well the harmonic approximation holds.

(c) In the range where the harmonic approximation is valid, the measured period should be approximately independent of amplitude, closely matching the predicted T.

The range where the harmonic approximation fails is revealed by a systematic dependence of the measured period on amplitude (period changing as amplitude increases) and/or by systematic (non-random) residuals when fitting F versus x with a straight line, both of which indicate the true potential is no longer well-approximated by a simple harmonic (linear-restoring-force) model.' where id = '5fcb4563-b353-4692-98aa-af5b356af902';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 1, '(a) Measure the restoring force at several nearby positions and locate x0 as the point where the measured restoring force is zero, with the force pointing back toward x0 (restoring) on both sides of it.', ARRAY['a-equilibrium'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 3, 'Fit the measured restoring force F versus displacement x near x0 with a straight line over a small range, and take the effective spring constant as k_eff=-dF/dx evaluated at x0 (the negative of the local slope).', ARRAY['a-slope'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 5, '(b) The predicted small-oscillation period is T=2*pi*sqrt(m/k_eff), using the effective spring constant found in part (a).', ARRAY['b-period'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 7, 'Test this prediction by measuring the actual oscillation period from repeated position-versus-time cycles at several different small amplitudes.', ARRAY['b-test'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 9, 'Explicitly compare each measured small-amplitude period to the value predicted by T=2*pi*sqrt(m/k_eff) from part (a), to determine how well the harmonic approximation holds.', ARRAY['b-compare'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 11, '(c) In the range where the harmonic approximation is valid, the measured period should be approximately independent of amplitude, closely matching the predicted T.', ARRAY['c-harmonic'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5fcb4563-b353-4692-98aa-af5b356af902', 'canonical_answer_1', 13, 'The range where the harmonic approximation fails is revealed by a systematic dependence of the measured period on amplitude (period changing as amplitude increases) and/or by systematic (non-random) residuals when fitting F versus x with a straight line, both of which indicate the true potential is no longer well-approximated by a simple harmonic (linear-restoring-force) model.', ARRAY['c-failure'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-027 (4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c)
update app.content_item_versions set canonical_answer_1 = '(a) Using the motion sensors'' recorded velocities (with sign to indicate direction) and the known cart masses, calculate the total momentum of the two-cart system immediately before the collision and immediately after the collision.

Separately, calculate the total kinetic energy of the system immediately before and immediately after the collision, using the same masses and (unsigned) speeds.

(b) Propagate the measurement uncertainties in the masses and velocities into both calculated quantities independently: into the total momentum before and after, and into the total kinetic energy before and after -- not merely into a single generic "difference" value, since momentum conservation and the elastic/inelastic classification are separate questions each requiring their own propagated uncertainty.

The collision is classified as elastic if the calculated decrease in total kinetic energy is consistent with zero within its propagated uncertainty, and as inelastic if the decrease in kinetic energy exceeds that propagated uncertainty (i.e., is a real, statistically significant loss rather than measurement noise).' where id = '4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c', 'canonical_answer_1', 1, '(a) Using the motion sensors'' recorded velocities (with sign to indicate direction) and the known cart masses, calculate the total momentum of the two-cart system immediately before the collision and immediately after the collision.', ARRAY['a-momentum'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c', 'canonical_answer_1', 3, 'Separately, calculate the total kinetic energy of the system immediately before and immediately after the collision, using the same masses and (unsigned) speeds.', ARRAY['a-energy'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c', 'canonical_answer_1', 5, '(b) Propagate the measurement uncertainties in the masses and velocities into both calculated quantities independently: into the total momentum before and after, and into the total kinetic energy before and after -- not merely into a single generic "difference" value, since momentum conservation and the elastic/inelastic classification are separate questions each requiring their own propagated uncertainty.', ARRAY['b-propagation'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c', 'canonical_answer_1', 7, 'The collision is classified as elastic if the calculated decrease in total kinetic energy is consistent with zero within its propagated uncertainty, and as inelastic if the decrease in kinetic energy exceeds that propagated uncertainty (i.e., is a real, statistically significant loss rather than measurement noise).', ARRAY['b-classification'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-030 (f801426f-6426-4bc7-8182-3d41ac0d85d1)
update app.content_item_versions set canonical_answer_1 = '(a) Gravity supplies the centripetal force for the circular orbit: GMm/r²=mv²/r, so v=sqrt(GM/r).

The kinetic energy is K=(1/2)mv²=(1/2)m(GM/r)=GMm/(2r).

The gravitational potential energy is U=-GMm/r.

The total energy is E=K+U=GMm/(2r)-GMm/r=-GMm/(2r).

(b) To escape, the satellite needs total energy E=0 (marginally unbound). Since its current total energy is -GMm/(2r), the minimum additional energy required is GMm/(2r), the amount needed to bring E from -GMm/(2r) up to 0.

(c) If the orbital radius doubles to 2r, the new speed is v''=sqrt(GM/(2r))=v/sqrt(2), so the speed is reduced by a factor of sqrt(2).

The orbital period is T=2*pi*r/v; at radius 2r with speed v/sqrt(2), the new period is T''=2*pi*(2r)/(v/sqrt(2))=2*sqrt(2)*(2*pi*r/v)=2*sqrt(2)*T, so the period is multiplied by a factor of 2*sqrt(2).

The new total energy is E''=-GMm/(2*(2r))=-GMm/(4r)=E/2, so the total energy is half as negative as before.' where id = 'f801426f-6426-4bc7-8182-3d41ac0d85d1';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 1, '(a) Gravity supplies the centripetal force for the circular orbit: GMm/r²=mv²/r, so v=sqrt(GM/r).', ARRAY['a-speed'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 3, 'The kinetic energy is K=(1/2)mv²=(1/2)m(GM/r)=GMm/(2r).', ARRAY['a-kinetic'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 5, 'The gravitational potential energy is U=-GMm/r.', ARRAY['a-potential'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 7, 'The total energy is E=K+U=GMm/(2r)-GMm/r=-GMm/(2r).', ARRAY['a-total'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 9, '(b) To escape, the satellite needs total energy E=0 (marginally unbound). Since its current total energy is -GMm/(2r), the minimum additional energy required is GMm/(2r), the amount needed to bring E from -GMm/(2r) up to 0.', ARRAY['b-escape'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 11, '(c) If the orbital radius doubles to 2r, the new speed is v''=sqrt(GM/(2r))=v/sqrt(2), so the speed is reduced by a factor of sqrt(2).', ARRAY['c-speed'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 13, 'The orbital period is T=2*pi*r/v; at radius 2r with speed v/sqrt(2), the new period is T''=2*pi*(2r)/(v/sqrt(2))=2*sqrt(2)*(2*pi*r/v)=2*sqrt(2)*T, so the period is multiplied by a factor of 2*sqrt(2).', ARRAY['c-period'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f801426f-6426-4bc7-8182-3d41ac0d85d1', 'canonical_answer_1', 15, 'The new total energy is E''=-GMm/(2*(2r))=-GMm/(4r)=E/2, so the total energy is half as negative as before.', ARRAY['c-energy'], 'drafted', 'apphysicscm_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('086cbead-f233-42d0-ada2-a1f48dfa51ec'::uuid),('3b89db83-f0dc-42d8-aaab-0bd815f2cbba'::uuid),('5fcb4563-b353-4692-98aa-af5b356af902'::uuid),('4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c'::uuid),('f801426f-6426-4bc7-8182-3d41ac0d85d1'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;
begin;

-- apphycm-frq-031 (15739e64-449f-48f1-9daa-97fecf8f1122)
update app.content_item_versions set canonical_answer_1 = '(a) By conservation of energy, the loss in gravitational potential energy equals the gain in translational plus rotational kinetic energy: Mgh=(1/2)Mv²+(1/2)Iω², and since the body rolls without slipping, v=omega*R.

Substituting I=kappa*M*R² and omega=v/R: Mgh=(1/2)Mv²+(1/2)*kappa*M*R²*(v/R)²=(1/2)Mv²*(1+kappa), which solves to v=sqrt(2*g*h/(1+kappa)).

(b) A larger value of kappa means a larger moment of inertia for a given mass and radius, so more of the released gravitational potential energy goes into rotational kinetic energy and less into translational kinetic energy -- this results in a smaller final translational speed v, consistent with v=sqrt(2gh/(1+kappa)) decreasing as kappa increases.

Under the ideal rolling-without-slipping assumption, the point of the body in contact with the surface is instantaneously at rest relative to the surface, so the static friction force acting there does zero mechanical work (work requires displacement of the point of application, and that point does not move during the instant the friction acts). This is different from kinetic (sliding) friction, which would act on a surface point that is actually moving and would therefore do (negative) work and dissipate energy.' where id = '15739e64-449f-48f1-9daa-97fecf8f1122';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('15739e64-449f-48f1-9daa-97fecf8f1122', 'canonical_answer_1', 1, '(a) By conservation of energy, the loss in gravitational potential energy equals the gain in translational plus rotational kinetic energy: Mgh=(1/2)Mv²+(1/2)Iω², and since the body rolls without slipping, v=omega*R.', ARRAY['a-energy'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('15739e64-449f-48f1-9daa-97fecf8f1122', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('15739e64-449f-48f1-9daa-97fecf8f1122', 'canonical_answer_1', 3, 'Substituting I=kappa*M*R² and omega=v/R: Mgh=(1/2)Mv²+(1/2)*kappa*M*R²*(v/R)²=(1/2)Mv²*(1+kappa), which solves to v=sqrt(2*g*h/(1+kappa)).', ARRAY['a-speed'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('15739e64-449f-48f1-9daa-97fecf8f1122', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('15739e64-449f-48f1-9daa-97fecf8f1122', 'canonical_answer_1', 5, '(b) A larger value of kappa means a larger moment of inertia for a given mass and radius, so more of the released gravitational potential energy goes into rotational kinetic energy and less into translational kinetic energy -- this results in a smaller final translational speed v, consistent with v=sqrt(2gh/(1+kappa)) decreasing as kappa increases.', ARRAY['b-kappa'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('15739e64-449f-48f1-9daa-97fecf8f1122', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('15739e64-449f-48f1-9daa-97fecf8f1122', 'canonical_answer_1', 7, 'Under the ideal rolling-without-slipping assumption, the point of the body in contact with the surface is instantaneously at rest relative to the surface, so the static friction force acting there does zero mechanical work (work requires displacement of the point of application, and that point does not move during the instant the friction acts). This is different from kinetic (sliding) friction, which would act on a surface point that is actually moving and would therefore do (negative) work and dissipate energy.', ARRAY['b-friction'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-032 (b0eebeb1-707b-4e43-b67a-36a30b2a05e2)
update app.content_item_versions set canonical_answer_1 = '(a) The torque τ(t)=τ_max*sin(pi*t/T) traces a single positive half-sine arch over the interval: it starts at zero when t=0, rises to its maximum value τ_max at t=T/2, and returns to zero at t=T.

The angular impulse is the integral of τ(t) from 0 to T: integral of τ_max*sin(pi*t/T) dt from 0 to T = τ_max*[-(T/pi)*cos(pi*t/T)] from 0 to T = τ_max*(-T/pi)*(cos(pi)-cos(0)) = τ_max*(-T/pi)*(-1-1) = 2*τ_max*T/pi.

(b) The wheel starts with angular velocity -omega0 (given). By the angular impulse-momentum theorem, I*(omega_f-(-omega0))=2*τ_max*T/pi, so I*(omega_f+omega0)=2*τ_max*T/pi, giving omega_f=-omega0+2*τ_max*T/(pi*I).

The wheel''s angular velocity reverses into the positive direction when omega_f>0, i.e. when -omega0+2*τ_max*T/(pi*I)>0, which occurs when 2*τ_max*T/(pi*I)>omega0.' where id = 'b0eebeb1-707b-4e43-b67a-36a30b2a05e2';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0eebeb1-707b-4e43-b67a-36a30b2a05e2', 'canonical_answer_1', 1, '(a) The torque τ(t)=τ_max*sin(pi*t/T) traces a single positive half-sine arch over the interval: it starts at zero when t=0, rises to its maximum value τ_max at t=T/2, and returns to zero at t=T.', ARRAY['a-sketch'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0eebeb1-707b-4e43-b67a-36a30b2a05e2', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0eebeb1-707b-4e43-b67a-36a30b2a05e2', 'canonical_answer_1', 3, 'The angular impulse is the integral of τ(t) from 0 to T: integral of τ_max*sin(pi*t/T) dt from 0 to T = τ_max*[-(T/pi)*cos(pi*t/T)] from 0 to T = τ_max*(-T/pi)*(cos(pi)-cos(0)) = τ_max*(-T/pi)*(-1-1) = 2*τ_max*T/pi.', ARRAY['a-impulse'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0eebeb1-707b-4e43-b67a-36a30b2a05e2', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0eebeb1-707b-4e43-b67a-36a30b2a05e2', 'canonical_answer_1', 5, '(b) The wheel starts with angular velocity -omega0 (given). By the angular impulse-momentum theorem, I*(omega_f-(-omega0))=2*τ_max*T/pi, so I*(omega_f+omega0)=2*τ_max*T/pi, giving omega_f=-omega0+2*τ_max*T/(pi*I).', ARRAY['b-final'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0eebeb1-707b-4e43-b67a-36a30b2a05e2', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b0eebeb1-707b-4e43-b67a-36a30b2a05e2', 'canonical_answer_1', 7, 'The wheel''s angular velocity reverses into the positive direction when omega_f>0, i.e. when -omega0+2*τ_max*T/(pi*I)>0, which occurs when 2*τ_max*T/(pi*I)>omega0.', ARRAY['b-reverse'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-033 (33adf1cf-de11-4b37-aeee-ee323bf6e761)
update app.content_item_versions set canonical_answer_1 = '(a) The work done by the motor over an angular interval is computed from the measured torque as a function of angle: W=integral of tau(theta) d(theta), evaluated (numerically, e.g. by summing tau*delta-theta over small angle steps, or by finding the area under the recorded tau-vs-theta graph) over the interval of interest.

The corresponding change in rotational kinetic energy over that same interval is delta-K_rot=(1/2)*I*(omega_f^2-omega_i^2), using the flywheel''s known moment of inertia I and the measured initial and final angular speeds.

(b) Plotting the cumulative motor work (from part a) against the corresponding rotational kinetic-energy change, for several different intervals, should give a straight line through the origin with slope 1, since the work-energy theorem predicts these two quantities are equal.

As a distinct, separate check from the graphical comparison, numerically compare the calculated motor work to the measured kinetic-energy change for at least one interval -- for example by computing their difference or the percent discrepancy between them.

As a further, independent dynamic check (not optional), compare the instantaneous motor power tau*omega (using the measured torque and angular speed at a given instant) to the measured rate of change of kinetic energy at that same instant, since the work-energy theorem also holds instantaneously, not just over finite intervals.

(c) Hold the flywheel''s physical configuration (and hence its moment of inertia I) fixed, and keep the motor''s torque calibration fixed, across all trials and intervals used in the analysis.

A systematic shortfall of the measured kinetic-energy change relative to the calculated motor work -- one that grows larger as the angle (or the duration of motor operation) increases -- is evidence of an unmodeled frictional torque draining away some of the motor''s work as heat rather than converting all of it into rotational kinetic energy.' where id = '33adf1cf-de11-4b37-aeee-ee323bf6e761';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 1, '(a) The work done by the motor over an angular interval is computed from the measured torque as a function of angle: W=integral of tau(theta) d(theta), evaluated (numerically, e.g. by summing tau*delta-theta over small angle steps, or by finding the area under the recorded tau-vs-theta graph) over the interval of interest.', ARRAY['a-work'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 3, 'The corresponding change in rotational kinetic energy over that same interval is delta-K_rot=(1/2)*I*(omega_f^2-omega_i^2), using the flywheel''s known moment of inertia I and the measured initial and final angular speeds.', ARRAY['a-energy'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 5, '(b) Plotting the cumulative motor work (from part a) against the corresponding rotational kinetic-energy change, for several different intervals, should give a straight line through the origin with slope 1, since the work-energy theorem predicts these two quantities are equal.', ARRAY['b-graph'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 7, 'As a distinct, separate check from the graphical comparison, numerically compare the calculated motor work to the measured kinetic-energy change for at least one interval -- for example by computing their difference or the percent discrepancy between them.', ARRAY['b-numeric'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 9, 'As a further, independent dynamic check (not optional), compare the instantaneous motor power tau*omega (using the measured torque and angular speed at a given instant) to the measured rate of change of kinetic energy at that same instant, since the work-energy theorem also holds instantaneously, not just over finite intervals.', ARRAY['b-power'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 11, '(c) Hold the flywheel''s physical configuration (and hence its moment of inertia I) fixed, and keep the motor''s torque calibration fixed, across all trials and intervals used in the analysis.', ARRAY['c-controls'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('33adf1cf-de11-4b37-aeee-ee323bf6e761', 'canonical_answer_1', 13, 'A systematic shortfall of the measured kinetic-energy change relative to the calculated motor work -- one that grows larger as the angle (or the duration of motor operation) increases -- is evidence of an unmodeled frictional torque draining away some of the motor''s work as heat rather than converting all of it into rotational kinetic energy.', ARRAY['c-friction'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-034 (2ef5f8b1-d238-44e8-b81d-c25f21910ecf)
update app.content_item_versions set canonical_answer_1 = '(a) Energy conservation for this oscillator equates the total energy (evaluated at the amplitude, where all energy is potential) to the sum of kinetic and spring potential energy at any point: (1/2)*m*omega²*A²=(1/2)*m*v²+(1/2)*m*omega²*x².

Dividing through by (1/2)*m and rearranging gives v²+omega²*x²=omega²*A².

(b) This relation, v²+omega²*x²=omega²*A², describes an ellipse in the v-versus-x plane, with x-intercepts at x=±A (where v=0) and v-intercepts at v=±omega*A (where x=0).

(b) Starting at x(0)=A, v(0)=0 (the rightmost point of the ellipse, on the horizontal axis), the mass then moves back toward x=0 with increasingly negative velocity, tracing the ellipse in the clockwise direction from (A,0) toward negative v.' where id = '2ef5f8b1-d238-44e8-b81d-c25f21910ecf';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2ef5f8b1-d238-44e8-b81d-c25f21910ecf', 'canonical_answer_1', 1, '(a) Energy conservation for this oscillator equates the total energy (evaluated at the amplitude, where all energy is potential) to the sum of kinetic and spring potential energy at any point: (1/2)*m*omega²*A²=(1/2)*m*v²+(1/2)*m*omega²*x².', ARRAY['a-setup'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2ef5f8b1-d238-44e8-b81d-c25f21910ecf', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2ef5f8b1-d238-44e8-b81d-c25f21910ecf', 'canonical_answer_1', 3, 'Dividing through by (1/2)*m and rearranging gives v²+omega²*x²=omega²*A².', ARRAY['a-relation'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2ef5f8b1-d238-44e8-b81d-c25f21910ecf', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2ef5f8b1-d238-44e8-b81d-c25f21910ecf', 'canonical_answer_1', 5, '(b) This relation, v²+omega²*x²=omega²*A², describes an ellipse in the v-versus-x plane, with x-intercepts at x=±A (where v=0) and v-intercepts at v=±omega*A (where x=0).', ARRAY['b-shape'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2ef5f8b1-d238-44e8-b81d-c25f21910ecf', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2ef5f8b1-d238-44e8-b81d-c25f21910ecf', 'canonical_answer_1', 7, '(b) Starting at x(0)=A, v(0)=0 (the rightmost point of the ellipse, on the horizontal axis), the mass then moves back toward x=0 with increasingly negative velocity, tracing the ellipse in the clockwise direction from (A,0) toward negative v.', ARRAY['b-direction'], 'drafted', 'apphysicscm_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('15739e64-449f-48f1-9daa-97fecf8f1122'::uuid),('b0eebeb1-707b-4e43-b67a-36a30b2a05e2'::uuid),('33adf1cf-de11-4b37-aeee-ee323bf6e761'::uuid),('2ef5f8b1-d238-44e8-b81d-c25f21910ecf'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;
begin;

-- apphycm-frq-035 (371c2cda-06e0-440e-bb60-2b544e7799ae)
update app.content_item_versions set canonical_answer_1 = '(a) The force is F(x)=-dU/dx=-(alpha*x^3-beta*x)=beta*x-alpha*x^3.

Setting F(x)=0: beta*x-alpha*x^3=0, so x*(beta-alpha*x^2)=0, giving x=0 or x=±sqrt(beta/alpha).

Since F=-dU/dx, dU/dx=alpha*x^3-beta*x, so d^2U/dx^2=3*alpha*x^2-beta. At x=0, this equals -beta, which is negative (since beta>0), so x=0 is a local maximum of U -- an unstable equilibrium.

At x=±sqrt(beta/alpha), d^2U/dx^2=3*alpha*(beta/alpha)-beta=3*beta-beta=2*beta, which is positive, so these are local minima of U -- stable equilibria.

Since the particle is released from rest at x=A, conservation of energy gives (1/2)*m*v^2+U(x)=U(A) at every subsequent position x.

Solving for v: v(x)=sqrt{(2/m)*[U(A)-U(x)]}.

The particle''s speed is maximum where U(x) is minimum, i.e. at x=±sqrt(beta/alpha), where U=alpha*(beta/alpha)^2/4-beta*(beta/alpha)/2=beta^2/(4*alpha)-beta^2/(2*alpha)=-beta^2/(4*alpha). So the maximum speed is v_max=sqrt{(2/m)*[U(A)-(-beta^2/(4*alpha))]}=sqrt{(2/m)*[U(A)+beta^2/(4*alpha)]}.

(b) U(0)=alpha*(0)^4/4-beta*(0)^2/2=0. U(A)=alpha*A^4/4-beta*A^2/2.

Given A>sqrt(2*beta/alpha), squaring gives A^2>2*beta/alpha, so alpha*A^2>2*beta, so alpha*A^2/2>beta. Multiplying both sides by A^2/2 (positive) gives alpha*A^4/4>beta*A^2/2, which means U(A)=alpha*A^4/4-beta*A^2/2>0. Since the particle''s total energy equals U(A)>0=U(0), it has enough energy to reach and cross x=0.

Using v(x)=sqrt{(2/m)*[U(A)-U(x)]} at x=0, where U(0)=0: v(0)=sqrt{(2/m)*U(A)}=sqrt{(2/m)*(alpha*A^4/4-beta*A^2/2)}=sqrt{(alpha*A^4/2-beta*A^2)/m}.' where id = '371c2cda-06e0-440e-bb60-2b544e7799ae';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 1, '(a) The force is F(x)=-dU/dx=-(alpha*x^3-beta*x)=beta*x-alpha*x^3.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 3, 'Setting F(x)=0: beta*x-alpha*x^3=0, so x*(beta-alpha*x^2)=0, giving x=0 or x=±sqrt(beta/alpha).', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 5, 'Since F=-dU/dx, dU/dx=alpha*x^3-beta*x, so d^2U/dx^2=3*alpha*x^2-beta. At x=0, this equals -beta, which is negative (since beta>0), so x=0 is a local maximum of U -- an unstable equilibrium.', ARRAY['part-a-criterion-03'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 7, 'At x=±sqrt(beta/alpha), d^2U/dx^2=3*alpha*(beta/alpha)-beta=3*beta-beta=2*beta, which is positive, so these are local minima of U -- stable equilibria.', ARRAY['part-a-criterion-04'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 9, 'Since the particle is released from rest at x=A, conservation of energy gives (1/2)*m*v^2+U(x)=U(A) at every subsequent position x.', ARRAY['part-a-criterion-05'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 11, 'Solving for v: v(x)=sqrt{(2/m)*[U(A)-U(x)]}.', ARRAY['part-a-criterion-06'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 13, 'The particle''s speed is maximum where U(x) is minimum, i.e. at x=±sqrt(beta/alpha), where U=alpha*(beta/alpha)^2/4-beta*(beta/alpha)/2=beta^2/(4*alpha)-beta^2/(2*alpha)=-beta^2/(4*alpha). So the maximum speed is v_max=sqrt{(2/m)*[U(A)-(-beta^2/(4*alpha))]}=sqrt{(2/m)*[U(A)+beta^2/(4*alpha)]}.', ARRAY['part-a-criterion-07'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 15, '(b) U(0)=alpha*(0)^4/4-beta*(0)^2/2=0. U(A)=alpha*A^4/4-beta*A^2/2.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 17, 'Given A>sqrt(2*beta/alpha), squaring gives A^2>2*beta/alpha, so alpha*A^2>2*beta, so alpha*A^2/2>beta. Multiplying both sides by A^2/2 (positive) gives alpha*A^4/4>beta*A^2/2, which means U(A)=alpha*A^4/4-beta*A^2/2>0. Since the particle''s total energy equals U(A)>0=U(0), it has enough energy to reach and cross x=0.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('371c2cda-06e0-440e-bb60-2b544e7799ae', 'canonical_answer_1', 19, 'Using v(x)=sqrt{(2/m)*[U(A)-U(x)]} at x=0, where U(0)=0: v(0)=sqrt{(2/m)*U(A)}=sqrt{(2/m)*(alpha*A^4/4-beta*A^2/2)}=sqrt{(alpha*A^4/2-beta*A^2)/m}.', ARRAY['part-b-criterion-03'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-036 (d46347bb-0063-4627-b1a5-0b099ca01a71)
update app.content_item_versions set canonical_answer_1 = '(a) A free-body diagram of the falling object shows the weight mg acting downward and the drag force bv acting upward, opposing the downward motion.

With downward taken as positive, Newton''s second law gives m*dv/dt=mg-b*v.

At terminal speed, dv/dt=0, so mg=b*v_T, giving v_T=mg/b.

(b) Rewriting the equation of motion as dv/dt+(b/m)*v=g, this is a first-order linear differential equation; separating variables gives dv/(g-(b/m)*v)=dt.

Integrating both sides gives -(m/b)*ln(g-(b/m)*v)=t+constant, or equivalently an exponential relation of the form g-(b/m)*v=(constant)*e^(-bt/m).

Applying the initial condition v(0)=0 to fix the constant and solving for v gives v(t)=(mg/b)*(1-e^(-bt/m))=v_T*(1-e^(-bt/m)).

Differentiating v(t) with respect to t: a(t)=dv/dt=(mg/b)*(b/m)*e^(-bt/m)=g*e^(-bt/m).

(c) The velocity-time graph starts at v=0, increases while concave down (its slope, the acceleration, steadily decreases), and approaches the terminal speed v_T asymptotically without ever quite reaching it.

The acceleration-time graph starts at a=g when t=0, decreases while concave up, and approaches zero asymptotically as t increases.

The characteristic time scale of this decay is m/b; at t=m/b, the acceleration has fallen to g/e and the velocity has risen to about 63% of v_T, marking the natural timescale to label on both graphs.

(d) A second object with a larger b (all else equal) has a smaller terminal speed, since v_T=mg/b is inversely proportional to b.

The initial slope of the velocity-time graph (the initial acceleration) remains g regardless of b, since at the instant of release v=0, so the drag force b*v is zero and the only force acting is gravity.' where id = 'd46347bb-0063-4627-b1a5-0b099ca01a71';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 1, '(a) A free-body diagram of the falling object shows the weight mg acting downward and the drag force bv acting upward, opposing the downward motion.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 3, 'With downward taken as positive, Newton''s second law gives m*dv/dt=mg-b*v.', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 5, 'At terminal speed, dv/dt=0, so mg=b*v_T, giving v_T=mg/b.', ARRAY['part-a-criterion-03'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 7, '(b) Rewriting the equation of motion as dv/dt+(b/m)*v=g, this is a first-order linear differential equation; separating variables gives dv/(g-(b/m)*v)=dt.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 9, 'Integrating both sides gives -(m/b)*ln(g-(b/m)*v)=t+constant, or equivalently an exponential relation of the form g-(b/m)*v=(constant)*e^(-bt/m).', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 11, 'Applying the initial condition v(0)=0 to fix the constant and solving for v gives v(t)=(mg/b)*(1-e^(-bt/m))=v_T*(1-e^(-bt/m)).', ARRAY['part-b-criterion-03'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 13, 'Differentiating v(t) with respect to t: a(t)=dv/dt=(mg/b)*(b/m)*e^(-bt/m)=g*e^(-bt/m).', ARRAY['part-b-criterion-04'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 15, '(c) The velocity-time graph starts at v=0, increases while concave down (its slope, the acceleration, steadily decreases), and approaches the terminal speed v_T asymptotically without ever quite reaching it.', ARRAY['part-c-criterion-01'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 17, 'The acceleration-time graph starts at a=g when t=0, decreases while concave up, and approaches zero asymptotically as t increases.', ARRAY['part-c-criterion-02'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 19, 'The characteristic time scale of this decay is m/b; at t=m/b, the acceleration has fallen to g/e and the velocity has risen to about 63% of v_T, marking the natural timescale to label on both graphs.', ARRAY['part-c-criterion-03'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 20, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 21, '(d) A second object with a larger b (all else equal) has a smaller terminal speed, since v_T=mg/b is inversely proportional to b.', ARRAY['part-d-criterion-01'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 22, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d46347bb-0063-4627-b1a5-0b099ca01a71', 'canonical_answer_1', 23, 'The initial slope of the velocity-time graph (the initial acceleration) remains g regardless of b, since at the instant of release v=0, so the drag force b*v is zero and the only force acting is gravity.', ARRAY['part-d-criterion-02'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-037 (c46146ec-f28e-4db7-bce8-b8bbf44688d7)
update app.content_item_versions set canonical_answer_1 = '(a) For the hanging mass: mg-T=ma (Newton''s second law). For the rotor: T*r=I*alpha (torque from the string tension about the axle). Since the string does not slip, alpha=a/r.

Substituting T=I*alpha/r=I*a/r² into mg-T=ma gives mg-I*a/r²=ma, so mg=a*(m+I/r²), and solving for a: a=mg/(m+I/r²).

(b) Using several different known hanging masses m, release the system from rest without giving it a push, and for each mass determine the linear acceleration a either from the slope of a velocity-versus-time graph (from the motion sensor) or from a quadratic fit to position-versus-time data.

Keep the hub radius r and the drop distance fixed across all trials, ensure the string does not slip on the hub, and repeat each trial multiple times to average out random variation in the measured acceleration.

(c) Starting from a=mg/(m+I/r²), taking the reciprocal gives 1/a=(m+I/r²)/(mg)=1/g+(I/(g*r²))*(1/m), a linear relationship between 1/a and 1/m.

Plotting 1/a on the vertical axis against 1/m on the horizontal axis for the several trials gives a line whose slope is S=I/(g*r²).

The rotational inertia is then I=S*g*r², with its uncertainty propagated from the uncertainty in the fitted slope S and in the measured radius r (or bounded using the slopes of the steepest and shallowest lines still consistent with the data).

If the fitted line''s vertical intercept is inconsistent with the predicted value of 1/g, or if the residuals from the linear fit show a systematic (non-random) pattern rather than random scatter, this is evidence of an unmodeled effect such as bearing friction that the idealized model did not account for.

(d) If the hub radius r used in the calculation is actually smaller than the true radius, the reported moment of inertia I is too small.

This is because the slope S=I/(g*r²) is determined directly from the data (independent of what value of r is assumed), so I=S*g*r² is computed by multiplying that data-determined slope by r²; using an underestimated r² in this multiplication produces an underestimated I.' where id = 'c46146ec-f28e-4db7-bce8-b8bbf44688d7';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 1, '(a) For the hanging mass: mg-T=ma (Newton''s second law). For the rotor: T*r=I*alpha (torque from the string tension about the axle). Since the string does not slip, alpha=a/r.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 3, 'Substituting T=I*alpha/r=I*a/r² into mg-T=ma gives mg-I*a/r²=ma, so mg=a*(m+I/r²), and solving for a: a=mg/(m+I/r²).', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 5, '(b) Using several different known hanging masses m, release the system from rest without giving it a push, and for each mass determine the linear acceleration a either from the slope of a velocity-versus-time graph (from the motion sensor) or from a quadratic fit to position-versus-time data.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 7, 'Keep the hub radius r and the drop distance fixed across all trials, ensure the string does not slip on the hub, and repeat each trial multiple times to average out random variation in the measured acceleration.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 9, '(c) Starting from a=mg/(m+I/r²), taking the reciprocal gives 1/a=(m+I/r²)/(mg)=1/g+(I/(g*r²))*(1/m), a linear relationship between 1/a and 1/m.', ARRAY['part-c-criterion-01'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 11, 'Plotting 1/a on the vertical axis against 1/m on the horizontal axis for the several trials gives a line whose slope is S=I/(g*r²).', ARRAY['part-c-criterion-02'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 13, 'The rotational inertia is then I=S*g*r², with its uncertainty propagated from the uncertainty in the fitted slope S and in the measured radius r (or bounded using the slopes of the steepest and shallowest lines still consistent with the data).', ARRAY['part-c-criterion-03'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 15, 'If the fitted line''s vertical intercept is inconsistent with the predicted value of 1/g, or if the residuals from the linear fit show a systematic (non-random) pattern rather than random scatter, this is evidence of an unmodeled effect such as bearing friction that the idealized model did not account for.', ARRAY['part-c-criterion-04'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 17, '(d) If the hub radius r used in the calculation is actually smaller than the true radius, the reported moment of inertia I is too small.', ARRAY['part-d-criterion-01'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c46146ec-f28e-4db7-bce8-b8bbf44688d7', 'canonical_answer_1', 19, 'This is because the slope S=I/(g*r²) is determined directly from the data (independent of what value of r is assumed), so I=S*g*r² is computed by multiplying that data-determined slope by r²; using an underestimated r² in this multiplication produces an underestimated I.', ARRAY['part-d-criterion-02'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-044 (e94aab5e-bc64-4397-bbe4-6044cdfe66cc)
update app.content_item_versions set canonical_answer_1 = '(a) The spring''s potential energy is PE=(1/2)*k*x²=(1/2)*(200 N/m)*(0.100 m)²=1.00 J. By energy conservation on the frictionless surface, this converts entirely to kinetic energy at the equilibrium position: (1/2)*m*v²=1.00 J, so v=sqrt(2*1.00/0.500)=2.00 m/s.

(b) Doubling the compression to 0.200 m doubles the maximum speed, predicting v=4.00 m/s.

Since PE is proportional to x² (PE=(1/2)k*x²) and this PE converts entirely into KE=(1/2)mv², we have v² proportional to x², so v is proportional to x. Doubling the compression x therefore doubles the resulting speed v.' where id = 'e94aab5e-bc64-4397-bbe4-6044cdfe66cc';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e94aab5e-bc64-4397-bbe4-6044cdfe66cc', 'canonical_answer_1', 1, '(a) The spring''s potential energy is PE=(1/2)*k*x²=(1/2)*(200 N/m)*(0.100 m)²=1.00 J. By energy conservation on the frictionless surface, this converts entirely to kinetic energy at the equilibrium position: (1/2)*m*v²=1.00 J, so v=sqrt(2*1.00/0.500)=2.00 m/s.', ARRAY['a-speed'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e94aab5e-bc64-4397-bbe4-6044cdfe66cc', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e94aab5e-bc64-4397-bbe4-6044cdfe66cc', 'canonical_answer_1', 3, '(b) Doubling the compression to 0.200 m doubles the maximum speed, predicting v=4.00 m/s.', ARRAY['b-factor'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e94aab5e-bc64-4397-bbe4-6044cdfe66cc', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e94aab5e-bc64-4397-bbe4-6044cdfe66cc', 'canonical_answer_1', 5, 'Since PE is proportional to x² (PE=(1/2)k*x²) and this PE converts entirely into KE=(1/2)mv², we have v² proportional to x², so v is proportional to x. Doubling the compression x therefore doubles the resulting speed v.', ARRAY['b-justification'], 'drafted', 'apphysicscm_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('371c2cda-06e0-440e-bb60-2b544e7799ae'::uuid),('d46347bb-0063-4627-b1a5-0b099ca01a71'::uuid),('c46146ec-f28e-4db7-bce8-b8bbf44688d7'::uuid),('e94aab5e-bc64-4397-bbe4-6044cdfe66cc'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;
begin;

-- apphycm-frq-047 (bc2f6a20-bd16-4ac0-a975-7619f80212b2)
update app.content_item_versions set canonical_answer_1 = '(a) Integrating v(t)=3.00t²-2.00t with respect to t, and using x(0)=1.00 m to fix the constant of integration: x(t)=1.00+t³-t².

Evaluating at t=2.00 s: x(2.00)=1.00+(2.00)³-(2.00)²=1.00+8.00-4.00=5.00 m.

(b) Differentiating v(t)=3.00t²-2.00t with respect to t: a(t)=6.00t-2.00.

Evaluating at t=2.00 s: a(2.00)=6.00(2.00)-2.00=12.00-2.00=10.0 m/s².' where id = 'bc2f6a20-bd16-4ac0-a975-7619f80212b2';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bc2f6a20-bd16-4ac0-a975-7619f80212b2', 'canonical_answer_1', 1, '(a) Integrating v(t)=3.00t²-2.00t with respect to t, and using x(0)=1.00 m to fix the constant of integration: x(t)=1.00+t³-t².', ARRAY['a-integral'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bc2f6a20-bd16-4ac0-a975-7619f80212b2', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bc2f6a20-bd16-4ac0-a975-7619f80212b2', 'canonical_answer_1', 3, 'Evaluating at t=2.00 s: x(2.00)=1.00+(2.00)³-(2.00)²=1.00+8.00-4.00=5.00 m.', ARRAY['a-evaluate'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bc2f6a20-bd16-4ac0-a975-7619f80212b2', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bc2f6a20-bd16-4ac0-a975-7619f80212b2', 'canonical_answer_1', 5, '(b) Differentiating v(t)=3.00t²-2.00t with respect to t: a(t)=6.00t-2.00.', ARRAY['b-derivative'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bc2f6a20-bd16-4ac0-a975-7619f80212b2', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bc2f6a20-bd16-4ac0-a975-7619f80212b2', 'canonical_answer_1', 7, 'Evaluating at t=2.00 s: a(2.00)=6.00(2.00)-2.00=12.00-2.00=10.0 m/s².', ARRAY['b-evaluate'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-049 (abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f)
update app.content_item_versions set canonical_answer_1 = '(a) The work done as the particle moves from x=0 to a general position x is W(x)=integral from 0 to x of F(x'') dx'' = integral from 0 to x of (-4.00x''+10.0) dx''.

Evaluating the integral: W(x)=-2.00x²+10.0x. At x=2.00 m: W(0 to 2.00)=-2.00(2.00)²+10.0(2.00)=-8.00+20.0=12.0 J.

(b) By the work-energy theorem, KE(x)=KE0+W(x), where KE0=(1/2)(2.00 kg)(1.00 m/s)²=1.00 J. So (1/2)(2.00)v(x)²=1.00+(-2.00x²+10.0x), giving v(x)²=1.00-2.00x²+10.0x, so v(x)=sqrt(1.00-2.00x²+10.0x).

Evaluating at x=2.00 m: v(2.00)=sqrt(1.00-2.00(4.00)+10.0(2.00))=sqrt(1.00-8.00+20.0)=sqrt(13.0)≈3.61 m/s.

(c) The kinetic energy is maximum where the net force changes from positive to negative, i.e. where F(x)=0: -4.00x+10.0=0, giving x=2.50 m. This is the point where the particle stops speeding up (force still positive just before) and starts slowing down (force negative just after), so kinetic energy is at its maximum there.' where id = 'abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f', 'canonical_answer_1', 1, '(a) The work done as the particle moves from x=0 to a general position x is W(x)=integral from 0 to x of F(x'') dx'' = integral from 0 to x of (-4.00x''+10.0) dx''.', ARRAY['a-integral-setup'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f', 'canonical_answer_1', 3, 'Evaluating the integral: W(x)=-2.00x²+10.0x. At x=2.00 m: W(0 to 2.00)=-2.00(2.00)²+10.0(2.00)=-8.00+20.0=12.0 J.', ARRAY['a-evaluate'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f', 'canonical_answer_1', 5, '(b) By the work-energy theorem, KE(x)=KE0+W(x), where KE0=(1/2)(2.00 kg)(1.00 m/s)²=1.00 J. So (1/2)(2.00)v(x)²=1.00+(-2.00x²+10.0x), giving v(x)²=1.00-2.00x²+10.0x, so v(x)=sqrt(1.00-2.00x²+10.0x).', ARRAY['b-express-vx'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f', 'canonical_answer_1', 7, 'Evaluating at x=2.00 m: v(2.00)=sqrt(1.00-2.00(4.00)+10.0(2.00))=sqrt(1.00-8.00+20.0)=sqrt(13.0)≈3.61 m/s.', ARRAY['b-evaluate'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f', 'canonical_answer_1', 9, '(c) The kinetic energy is maximum where the net force changes from positive to negative, i.e. where F(x)=0: -4.00x+10.0=0, giving x=2.50 m. This is the point where the particle stops speeding up (force still positive just before) and starts slowing down (force negative just after), so kinetic energy is at its maximum there.', ARRAY['c-identify-justify'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-050 (8e3d19be-4792-4fc0-a1d4-32d4a3c889d3)
update app.content_item_versions set canonical_answer_1 = '(a) At the top of the circle, both gravity and tension point toward the center (downward), so their sum supplies the centripetal force: T+mg=m*v²/r, giving T=m*v²/r-mg=(0.400)(3.00)²/(0.800)-(0.400)(9.8)=4.50-3.92≈0.58 N.

The minimum speed at the top occurs when T=0, so mg=m*v_min²/r, giving v_min=sqrt(g*r)=sqrt((9.8)(0.800))=sqrt(7.84)≈2.80 m/s.

(b) By Newton''s second law applied at the top, T+mg=m*v²/r, so gravity itself supplies part of the required centripetal force there, meaning less tension is needed to make up the rest. At other points along the circle (for example the bottom), gravity does not point toward the center, or points away from it, so tension alone (or tension working against gravity) must supply more of the centripetal force -- making tension smallest at the top.

(c) By energy conservation between the top and bottom (a height difference of 2r): v_bottom²=v_top²+2*g*(2r)=v_top²+4*g*r=(3.00)²+4(9.8)(0.800)=9.00+31.36=40.36, so v_bottom=sqrt(40.36)≈6.35 m/s.

At the bottom, tension points toward the center (upward) while gravity points away from the center (downward), so T-mg=m*v_bottom²/r, giving T=mg+m*v_bottom²/r=(0.400)(9.8)+(0.400)(40.36)/(0.800)=3.92+20.18≈24.1 N.' where id = '8e3d19be-4792-4fc0-a1d4-32d4a3c889d3';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8e3d19be-4792-4fc0-a1d4-32d4a3c889d3', 'canonical_answer_1', 1, '(a) At the top of the circle, both gravity and tension point toward the center (downward), so their sum supplies the centripetal force: T+mg=m*v²/r, giving T=m*v²/r-mg=(0.400)(3.00)²/(0.800)-(0.400)(9.8)=4.50-3.92≈0.58 N.', ARRAY['a-tension-top'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8e3d19be-4792-4fc0-a1d4-32d4a3c889d3', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8e3d19be-4792-4fc0-a1d4-32d4a3c889d3', 'canonical_answer_1', 3, 'The minimum speed at the top occurs when T=0, so mg=m*v_min²/r, giving v_min=sqrt(g*r)=sqrt((9.8)(0.800))=sqrt(7.84)≈2.80 m/s.', ARRAY['a-vmin'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8e3d19be-4792-4fc0-a1d4-32d4a3c889d3', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8e3d19be-4792-4fc0-a1d4-32d4a3c889d3', 'canonical_answer_1', 5, '(b) By Newton''s second law applied at the top, T+mg=m*v²/r, so gravity itself supplies part of the required centripetal force there, meaning less tension is needed to make up the rest. At other points along the circle (for example the bottom), gravity does not point toward the center, or points away from it, so tension alone (or tension working against gravity) must supply more of the centripetal force -- making tension smallest at the top.', ARRAY['b-explanation'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8e3d19be-4792-4fc0-a1d4-32d4a3c889d3', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8e3d19be-4792-4fc0-a1d4-32d4a3c889d3', 'canonical_answer_1', 7, '(c) By energy conservation between the top and bottom (a height difference of 2r): v_bottom²=v_top²+2*g*(2r)=v_top²+4*g*r=(3.00)²+4(9.8)(0.800)=9.00+31.36=40.36, so v_bottom=sqrt(40.36)≈6.35 m/s.', ARRAY['c-vbottom'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8e3d19be-4792-4fc0-a1d4-32d4a3c889d3', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8e3d19be-4792-4fc0-a1d4-32d4a3c889d3', 'canonical_answer_1', 9, 'At the bottom, tension points toward the center (upward) while gravity points away from the center (downward), so T-mg=m*v_bottom²/r, giving T=mg+m*v_bottom²/r=(0.400)(9.8)+(0.400)(40.36)/(0.800)=3.92+20.18≈24.1 N.', ARRAY['c-tension-bottom'], 'drafted', 'apphysicscm_canonical_2026_09_25');

-- apphycm-frq-051 (e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9)
update app.content_item_versions set canonical_answer_1 = '(a) The spring''s initial potential energy is PE=(1/2)*k*x²=(1/2)(300 N/m)(0.200 m)²=6.00 J.

The magnitude of the work done by friction over the 0.200 m contact distance is |W_friction|=mu*m*g*d=(0.250)(1.50)(9.8)(0.200)≈0.735 J.

By energy conservation with friction as a non-conservative force, the block''s kinetic energy as it leaves the spring is KE_final=PE-|W_friction|=6.00-0.735=5.265 J, so v=sqrt(2*5.265/1.50)≈2.65 m/s.

(b) Friction is a non-conservative force that removes mechanical energy from the block-spring system as the block travels through the region of contact, converting that energy into thermal energy (heat) in the block and spring/surface rather than leaving it available as kinetic energy. This is why the block''s final kinetic energy (5.265 J) is less than the spring''s initial potential energy (6.00 J) -- the missing 0.735 J was dissipated as heat rather than converted to kinetic energy.' where id = 'e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9', 'canonical_answer_1', 1, '(a) The spring''s initial potential energy is PE=(1/2)*k*x²=(1/2)(300 N/m)(0.200 m)²=6.00 J.', ARRAY['a-pe'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9', 'canonical_answer_1', 3, 'The magnitude of the work done by friction over the 0.200 m contact distance is |W_friction|=mu*m*g*d=(0.250)(1.50)(9.8)(0.200)≈0.735 J.', ARRAY['a-friction-work'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9', 'canonical_answer_1', 5, 'By energy conservation with friction as a non-conservative force, the block''s kinetic energy as it leaves the spring is KE_final=PE-|W_friction|=6.00-0.735=5.265 J, so v=sqrt(2*5.265/1.50)≈2.65 m/s.', ARRAY['a-speed'], 'drafted', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscm_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9', 'canonical_answer_1', 7, '(b) Friction is a non-conservative force that removes mechanical energy from the block-spring system as the block travels through the region of contact, converting that energy into thermal energy (heat) in the block and spring/surface rather than leaving it available as kinetic energy. This is why the block''s final kinetic energy (5.265 J) is less than the spring''s initial potential energy (6.00 J) -- the missing 0.735 J was dissipated as heat rather than converted to kinetic energy.', ARRAY['b-explanation'], 'drafted', 'apphysicscm_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('bc2f6a20-bd16-4ac0-a975-7619f80212b2'::uuid),('abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f'::uuid),('8e3d19be-4792-4fc0-a1d4-32d4a3c889d3'::uuid),('e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;
