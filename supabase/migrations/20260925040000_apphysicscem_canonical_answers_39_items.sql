-- AP Physics C: E&M servability work (docs/product/SUBJECT_SERVABILITY_CRITERIA.md), criterion 4.
-- Authors canonical_answer_1 + canonical_answer_spans for the 39 published Physics C: E&M FRQ items
-- that had a blank canonical_answer_1 (apphycem-frq-001/004/005/006/010/012/015/016/018/020/021/025/
-- 027/028/031/032/033/034/035/036/037/038/040/042/048/049/050/051/053/056 and
-- apphycem-frq-np1-001/002/003/004/005/006/007/009/010), following the same pattern as
-- supabase/migrations/20260925030000_apphysicscm_canonical_answers_29_items.sql: each answer's text
-- is composed of criterion-exclusive spans (one span per frq_criteria.criterion_key, plus
-- assembly_literal separators), verified to concatenate exactly to canonical_answer_1.
--
-- Content investigation: read every item's stem, stimulus, and frq_criteria directly. All 39 are
-- genuine, complete, production-quality FRQ content spanning electrostatics, Gauss's law,
-- conductors/capacitors, circuits (resistive and RC), magnetic fields and forces, electromagnetic
-- induction, and experimental-design items -- none are placeholder/draft-quality, so all 39 get
-- canonical answers, not an unpublish recommendation.
--
-- Every value in every canonical answer was independently re-derived from first principles (not
-- copied from the rubric's learner_facing_text) -- each item's math and physics were re-worked from
-- scratch and cross-checked against the rubric's stated correct values, confirming the rubric text was
-- itself correct.
--
-- Verification before writing this migration:
-- (1) every one of the 39 items' full criterion_key set was re-fetched fresh from Production
--     immediately before authoring (not from memory/an earlier session state) and matched exactly
--     against the authored spans -- no criterion missing, none extra, none duplicated;
-- (2) span concatenation per item was verified programmatically to equal canonical_answer_1 byte for
--     byte before generating this SQL;
-- (3) all 39 target rows were confirmed to have canonical_answer_1 IS NULL beforehand -- this is a
--     pure addition, nothing is overwritten.
-- A second, live verification (concatenation of the actually-inserted spans vs. the actually-written
-- canonical_answer_1) runs inside each transaction below, and a third, independent check ran via a
-- separate execute_sql call after apply (against Production), confirming total_items=39,
-- has_canonical=39, concat_matches=39, and that the 39 items fully and exclusively cover every one of
-- their frq_criteria rows (items_checked=39, items_fully_covered=39), per this session's standing
-- verification discipline.
--
-- Applied to Production (pcntajvbdfqhbeewmdry) as ten separate migrations
-- (apphysicscem_canonical_answers_batch_1 through _batch_10) on 2026-09-25; this file concatenates
-- those ten self-contained transactions, in the same order, for the repo's migration ledger record.
--
-- Scope note: this is the last of the four AP Physics subjects (Physics 2, Physics C: Mechanics,
-- Physics 1, Physics C: E&M) surveyed for criterion-4 canonical-answer gaps this week. A separate,
-- pre-existing gap remains in canonical_answer_spans coverage for the other 16 FRQ items in this
-- subject that already had canonical_answer_1 set before this session (they have zero rows in
-- canonical_answer_spans) -- consistent with the same pattern already documented for Calc AB and
-- Chemistry earlier this week, where spans coverage was 0 before that week's work and is tracked as a
-- distinct, later-arriving fact from canonical_answer_1 itself. That gap is out of scope for this
-- migration and was not something this session's batches were meant to touch or fix.
--
-- Rollback: set canonical_answer_1 back to null and delete the inserted canonical_answer_spans rows
-- for the 39 content_item_version_ids referenced in the do-blocks below, if ever needed.

begin;

-- apphycem-frq-001 (0dec206d-26dd-46a7-ab6c-fe5d47d8bf54)
update app.content_item_versions set canonical_answer_1 = '(a) The enclosed charge inside radius r is Qenc=integral of rho0(r''/R)*4*pi*r''^2 dr'' from 0 to r = pi*rho0*r^4/R. By Gauss''s law, E*(4*pi*r^2)=Qenc/epsilon0, so E(r)=(pi*rho0*r^4/R)/(4*pi*epsilon0*r^2)=rho0*r^2/(4*epsilon0*R), directed radially outward for r<R (since rho0>0). This expression is valid only inside the sphere, for r<R.

(b) Gauss''s law holds for any closed surface and any charge distribution, but the spherical symmetry of this particular charge distribution is what makes it useful here: it guarantees that E has the same magnitude and points purely radially at every point on a concentric Gaussian sphere. This uniformity is exactly what allows E to be factored out of the flux integral, turning the integral of E dot dA into simply E times the sphere''s area, E*(4*pi*r^2).' where id = '0dec206d-26dd-46a7-ab6c-fe5d47d8bf54';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0dec206d-26dd-46a7-ab6c-fe5d47d8bf54', 'canonical_answer_1', 1, '(a) The enclosed charge inside radius r is Qenc=integral of rho0(r''/R)*4*pi*r''^2 dr'' from 0 to r = pi*rho0*r^4/R. By Gauss''s law, E*(4*pi*r^2)=Qenc/epsilon0, so E(r)=(pi*rho0*r^4/R)/(4*pi*epsilon0*r^2)=rho0*r^2/(4*epsilon0*R), directed radially outward for r<R (since rho0>0). This expression is valid only inside the sphere, for r<R.', ARRAY['part-a'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0dec206d-26dd-46a7-ab6c-fe5d47d8bf54', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0dec206d-26dd-46a7-ab6c-fe5d47d8bf54', 'canonical_answer_1', 3, '(b) Gauss''s law holds for any closed surface and any charge distribution, but the spherical symmetry of this particular charge distribution is what makes it useful here: it guarantees that E has the same magnitude and points purely radially at every point on a concentric Gaussian sphere. This uniformity is exactly what allows E to be factored out of the flux integral, turning the integral of E dot dA into simply E times the sphere''s area, E*(4*pi*r^2).', ARRAY['part-b'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-004 (666efb13-1448-4d6a-97e5-46cd3e0becae)
update app.content_item_versions set canonical_answer_1 = '(a) From Kirchhoff''s voltage law, the governing differential equation is RC*(dV/dt)+V=0. Solving with the initial condition V(0)=V0 gives V(t)=V0*e^(-t/RC). Using I=-C*(dV/dt) with the stated sign convention (I positive during discharge): I(t)=-C*(-V0/RC)*e^(-t/RC)=(V0/R)*e^(-t/RC).

(b) Kirchhoff''s voltage law is the governing principle, and the initial condition V(0)=V0 in an ideal source-free loop -- meaning capacitor leakage current, parasitic resistance, and other non-ideal circuit effects are all neglected -- together yield the exponential decay V(t)=V0*e^(-t/RC): the loop equation fixes the functional form (exponential), and the initial condition fixes the starting value that the exponential decays from.' where id = '666efb13-1448-4d6a-97e5-46cd3e0becae';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('666efb13-1448-4d6a-97e5-46cd3e0becae', 'canonical_answer_1', 1, '(a) From Kirchhoff''s voltage law, the governing differential equation is RC*(dV/dt)+V=0. Solving with the initial condition V(0)=V0 gives V(t)=V0*e^(-t/RC). Using I=-C*(dV/dt) with the stated sign convention (I positive during discharge): I(t)=-C*(-V0/RC)*e^(-t/RC)=(V0/R)*e^(-t/RC).', ARRAY['part-a'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('666efb13-1448-4d6a-97e5-46cd3e0becae', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('666efb13-1448-4d6a-97e5-46cd3e0becae', 'canonical_answer_1', 3, '(b) Kirchhoff''s voltage law is the governing principle, and the initial condition V(0)=V0 in an ideal source-free loop -- meaning capacitor leakage current, parasitic resistance, and other non-ideal circuit effects are all neglected -- together yield the exponential decay V(t)=V0*e^(-t/RC): the loop equation fixes the functional form (exponential), and the initial condition fixes the starting value that the exponential decays from.', ARRAY['part-b'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-005 (c8a5ba00-4c78-41bc-9269-9ca68ee9d45b)
update app.content_item_versions set canonical_answer_1 = '(a) The Amperian loop is a circle of radius r centered on the wire, lying in a plane perpendicular to the wire, with the current I flowing along +z through its center. The magnetic field B is tangent to this loop at every point, with a path element dl also tangent to the loop. Because the current distribution has cylindrical symmetry (it looks the same from every angle around the wire), B must have the same magnitude at every point on the loop and must point tangentially, with its direction given by the right-hand rule (curling in the direction the fingers curl when the thumb points along +z).

(b) Because the cylindrical symmetry established in part (a) guarantees that B has the same constant magnitude at every point on the circular Amperian loop, and is everywhere parallel to the path element dl, the dot product B dot dl equals simply B*dl at every point. This constant B can therefore be pulled outside the line integral in Ampere''s law, giving the closed integral of B dot dl = B times the closed integral of dl = B*(2*pi*r) = mu0*I.' where id = 'c8a5ba00-4c78-41bc-9269-9ca68ee9d45b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c8a5ba00-4c78-41bc-9269-9ca68ee9d45b', 'canonical_answer_1', 1, '(a) The Amperian loop is a circle of radius r centered on the wire, lying in a plane perpendicular to the wire, with the current I flowing along +z through its center. The magnetic field B is tangent to this loop at every point, with a path element dl also tangent to the loop. Because the current distribution has cylindrical symmetry (it looks the same from every angle around the wire), B must have the same magnitude at every point on the loop and must point tangentially, with its direction given by the right-hand rule (curling in the direction the fingers curl when the thumb points along +z).', ARRAY['part-a'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c8a5ba00-4c78-41bc-9269-9ca68ee9d45b', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c8a5ba00-4c78-41bc-9269-9ca68ee9d45b', 'canonical_answer_1', 3, '(b) Because the cylindrical symmetry established in part (a) guarantees that B has the same constant magnitude at every point on the circular Amperian loop, and is everywhere parallel to the path element dl, the dot product B dot dl equals simply B*dl at every point. This constant B can therefore be pulled outside the line integral in Ampere''s law, giving the closed integral of B dot dl = B times the closed integral of dl = B*(2*pi*r) = mu0*I.', ARRAY['part-b'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-006 (e3181785-fb5c-437a-a7c6-cda913c3909c)
update app.content_item_versions set canonical_answer_1 = '(a) The I(t) graph starts at I=0 and rises steeply at first, then gradually levels off, approaching the steady-state current eps/R as t increases. The initial slope of this curve (dI/dt at t=0) represents eps/L, and the asymptote the curve approaches represents the steady-state current eps/R.

(b) Kirchhoff''s voltage law is the governing principle here, and together with the initial condition I(0)=0 and the constant emf eps, it yields the current''s exponential approach to eps/R: the loop equation L*(dI/dt)+I*R=eps, combined with I(0)=0, determines both the functional form (an exponential rise) and the specific curve I(t)=(eps/R)*(1-e^(-Rt/L)) that approaches eps/R as t increases.' where id = 'e3181785-fb5c-437a-a7c6-cda913c3909c';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e3181785-fb5c-437a-a7c6-cda913c3909c', 'canonical_answer_1', 1, '(a) The I(t) graph starts at I=0 and rises steeply at first, then gradually levels off, approaching the steady-state current eps/R as t increases. The initial slope of this curve (dI/dt at t=0) represents eps/L, and the asymptote the curve approaches represents the steady-state current eps/R.', ARRAY['part-a'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e3181785-fb5c-437a-a7c6-cda913c3909c', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e3181785-fb5c-437a-a7c6-cda913c3909c', 'canonical_answer_1', 3, '(b) Kirchhoff''s voltage law is the governing principle here, and together with the initial condition I(0)=0 and the constant emf eps, it yields the current''s exponential approach to eps/R: the loop equation L*(dI/dt)+I*R=eps, combined with I(0)=0, determines both the functional form (an exponential rise) and the specific curve I(t)=(eps/R)*(1-e^(-Rt/L)) that approaches eps/R as t increases.', ARRAY['part-b'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-010 (32ffca56-e4e1-401b-87c1-401c5ba00289)
update app.content_item_versions set canonical_answer_1 = '(a) A valid measurement design: for each of several different resistance values R, record the capacitor''s voltage over time as it discharges, and determine the time constant from each discharge curve (for example, from the slope of a plot of ln(V) versus t, since ln(V)=ln(V0)-t/RC is linear in t with slope -1/RC). The independent variable is the resistance R, the dependent variable is the measured time constant tau, and a control is holding the capacitance, the initial voltage, the measuring equipment, and the overall circuit arrangement fixed across all trials.

(b) Kirchhoff''s voltage law is the governing principle: applying it around the discharge loop gives the differential equation that produces the exponential decay and its time constant RC. The specific initial condition V(0)=V0 only sets where the decay curve starts (its initial height), not how fast it decays -- so it is not essential for isolating the time constant tau, since tau=RC is determined by the loop equation itself, independent of V0. What is required for the measured tau to actually equal RC is that capacitor leakage, voltmeter loading, and any additional circuit resistance beyond the stated R are all negligible.' where id = '32ffca56-e4e1-401b-87c1-401c5ba00289';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('32ffca56-e4e1-401b-87c1-401c5ba00289', 'canonical_answer_1', 1, '(a) A valid measurement design: for each of several different resistance values R, record the capacitor''s voltage over time as it discharges, and determine the time constant from each discharge curve (for example, from the slope of a plot of ln(V) versus t, since ln(V)=ln(V0)-t/RC is linear in t with slope -1/RC). The independent variable is the resistance R, the dependent variable is the measured time constant tau, and a control is holding the capacitance, the initial voltage, the measuring equipment, and the overall circuit arrangement fixed across all trials.', ARRAY['part-a'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('32ffca56-e4e1-401b-87c1-401c5ba00289', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('32ffca56-e4e1-401b-87c1-401c5ba00289', 'canonical_answer_1', 3, '(b) Kirchhoff''s voltage law is the governing principle: applying it around the discharge loop gives the differential equation that produces the exponential decay and its time constant RC. The specific initial condition V(0)=V0 only sets where the decay curve starts (its initial height), not how fast it decays -- so it is not essential for isolating the time constant tau, since tau=RC is determined by the loop equation itself, independent of V0. What is required for the measured tau to actually equal RC is that capacitor leakage, voltmeter loading, and any additional circuit resistance beyond the stated R are all negligible.', ARRAY['part-b'], 'drafted', 'apphysicscem_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('0dec206d-26dd-46a7-ab6c-fe5d47d8bf54'::uuid),('666efb13-1448-4d6a-97e5-46cd3e0becae'::uuid),('c8a5ba00-4c78-41bc-9269-9ca68ee9d45b'::uuid),('e3181785-fb5c-437a-a7c6-cda913c3909c'::uuid),('32ffca56-e4e1-401b-87c1-401c5ba00289'::uuid)) as t(vid)
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

-- apphycem-frq-012 (5ac9b983-6266-4b04-914f-d91cc3edaa6b)
update app.content_item_versions set canonical_answer_1 = '(a) A valid measurement design: for each of several different inductance values L, record the circuit''s current over time as it grows toward its steady value, and fit each growth curve to determine the time constant tau=L/R. The independent variable is the inductance L, the dependent variable is the measured time constant tau, and a control is holding the total circuit resistance (including each inductor''s own internal resistance), the applied emf, and the measurement setup fixed across all trials.

(b) Kirchhoff''s voltage law is the governing principle, giving the loop equation L*(dI/dt)+IR=eps whose solution has the characteristic time constant L/R. While the specific initial condition I(0)=0 produces the particular growth curve I=(eps/R)*(1-e^(-Rt/L)) used in this measurement, the time constant L/R can in general be extracted even starting from a nonzero initial current, using the appropriate general solution to the same differential equation -- so I(0)=0 is a convenient simplifying assumption for this curve shape, not a strict requirement for measuring tau itself.' where id = '5ac9b983-6266-4b04-914f-d91cc3edaa6b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ac9b983-6266-4b04-914f-d91cc3edaa6b', 'canonical_answer_1', 1, '(a) A valid measurement design: for each of several different inductance values L, record the circuit''s current over time as it grows toward its steady value, and fit each growth curve to determine the time constant tau=L/R. The independent variable is the inductance L, the dependent variable is the measured time constant tau, and a control is holding the total circuit resistance (including each inductor''s own internal resistance), the applied emf, and the measurement setup fixed across all trials.', ARRAY['part-a'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ac9b983-6266-4b04-914f-d91cc3edaa6b', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5ac9b983-6266-4b04-914f-d91cc3edaa6b', 'canonical_answer_1', 3, '(b) Kirchhoff''s voltage law is the governing principle, giving the loop equation L*(dI/dt)+IR=eps whose solution has the characteristic time constant L/R. While the specific initial condition I(0)=0 produces the particular growth curve I=(eps/R)*(1-e^(-Rt/L)) used in this measurement, the time constant L/R can in general be extracted even starting from a nonzero initial current, using the appropriate general solution to the same differential equation -- so I(0)=0 is a convenient simplifying assumption for this curve shape, not a strict requirement for measuring tau itself.', ARRAY['part-b'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-015 (185f1287-4084-479c-bfbd-d96ccfa457a2)
update app.content_item_versions set canonical_answer_1 = '(a) With capacitance C held fixed, doubling the charge Q doubles the voltage V=Q/C, and doubles the electric field E=V/d (since d is unchanged). The stored energy U=Q^2/(2C) depends on the square of Q, so it quadruples: with charge 2Q, U_new=(2Q)^2/(2C)=4*Q^2/(2C)=4*U_original.

(b) The governing relationship is the capacitor energy formula U=Q^2/(2C), which shows stored energy scales with the square of charge when capacitance is fixed. The assumption that C remains fixed at epsilon*A/d (unchanged by doubling Q) is what justifies treating C as a constant in this formula, so that the predicted quadrupling of U, doubling of V, and doubling of E all follow directly from Q doubling while every other quantity in these formulas (C, A, d) stays the same.' where id = '185f1287-4084-479c-bfbd-d96ccfa457a2';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('185f1287-4084-479c-bfbd-d96ccfa457a2', 'canonical_answer_1', 1, '(a) With capacitance C held fixed, doubling the charge Q doubles the voltage V=Q/C, and doubles the electric field E=V/d (since d is unchanged). The stored energy U=Q^2/(2C) depends on the square of Q, so it quadruples: with charge 2Q, U_new=(2Q)^2/(2C)=4*Q^2/(2C)=4*U_original.', ARRAY['part-a'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('185f1287-4084-479c-bfbd-d96ccfa457a2', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('185f1287-4084-479c-bfbd-d96ccfa457a2', 'canonical_answer_1', 3, '(b) The governing relationship is the capacitor energy formula U=Q^2/(2C), which shows stored energy scales with the square of charge when capacitance is fixed. The assumption that C remains fixed at epsilon*A/d (unchanged by doubling Q) is what justifies treating C as a constant in this formula, so that the predicted quadrupling of U, doubling of V, and doubling of E all follow directly from Q doubling while every other quantity in these formulas (C, A, d) stays the same.', ARRAY['part-b'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-016 (4881dd2e-607b-49d8-9ede-e3d13c4da94e)
update app.content_item_versions set canonical_answer_1 = '(a) Since tau=RC and C is held fixed, doubling R doubles the time constant tau. The initial current magnitude V0/R is halved, since it is inversely proportional to R. However, at any fixed later time t, the new current is NOT simply half the original value: because the larger tau also slows the rate of exponential decay, the two effects (a smaller starting current but a slower decay) partially offset each other, so both effects must be stated together rather than just the initial-current halving.

(b) Kirchhoff''s voltage law applied to the discharging loop gives the governing differential equation RC*(dV/dt)+V=0, whose solution is the exponential decay V(t)=V0*e^(-t/RC) -- this is the mechanism that produces exponential discharge in the first place, regardless of the specific value of R. The initial condition V(0)=V0 sets the starting voltage (and hence, via I=V/R, the starting current) at t=0, from which the whole subsequent decay curve is determined.' where id = '4881dd2e-607b-49d8-9ede-e3d13c4da94e';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4881dd2e-607b-49d8-9ede-e3d13c4da94e', 'canonical_answer_1', 1, '(a) Since tau=RC and C is held fixed, doubling R doubles the time constant tau. The initial current magnitude V0/R is halved, since it is inversely proportional to R. However, at any fixed later time t, the new current is NOT simply half the original value: because the larger tau also slows the rate of exponential decay, the two effects (a smaller starting current but a slower decay) partially offset each other, so both effects must be stated together rather than just the initial-current halving.', ARRAY['part-a'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4881dd2e-607b-49d8-9ede-e3d13c4da94e', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4881dd2e-607b-49d8-9ede-e3d13c4da94e', 'canonical_answer_1', 3, '(b) Kirchhoff''s voltage law applied to the discharging loop gives the governing differential equation RC*(dV/dt)+V=0, whose solution is the exponential decay V(t)=V0*e^(-t/RC) -- this is the mechanism that produces exponential discharge in the first place, regardless of the specific value of R. The initial condition V(0)=V0 sets the starting voltage (and hence, via I=V/R, the starting current) at t=0, from which the whole subsequent decay curve is determined.', ARRAY['part-b'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-018 (e4ae8556-5d1e-47f7-87c7-299c89725d57)
update app.content_item_versions set canonical_answer_1 = '(a) The Gaussian surface is a pillbox (a short cylinder) straddling the sheet, with its two flat circular faces parallel to the sheet, one on each side. By the symmetry of an infinite uniformly charged sheet, the field points directly away from the sheet (normal to it) on both sides, so both flat faces have field pointing outward through them, while the curved side of the pillbox contributes no flux (since the field there is parallel to that surface).

(b) Applying Gauss''s law to the pillbox: the flux through the two flat faces is 2*E*A (each face has area A and field magnitude E normal to it), and the enclosed charge is sigma*A. So 2*E*A=sigma*A/epsilon0, giving E=sigma/(2*epsilon0) for the nonconducting sheet.

Immediately outside a conductor whose single outer face carries the same charge density sigma, the field is E=sigma/epsilon0 -- twice the nonconducting-sheet value. This is because the conductor''s interior field must be zero (electrostatic equilibrium), so a pillbox straddling the conductor''s surface has flux only through its outer face (the inner face, inside the conductor, contributes zero), giving E*A=sigma*A/epsilon0 directly, with no factor of 2 to divide by, unlike the isolated sheet where both faces of the pillbox contribute flux.' where id = 'e4ae8556-5d1e-47f7-87c7-299c89725d57';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e4ae8556-5d1e-47f7-87c7-299c89725d57', 'canonical_answer_1', 1, '(a) The Gaussian surface is a pillbox (a short cylinder) straddling the sheet, with its two flat circular faces parallel to the sheet, one on each side. By the symmetry of an infinite uniformly charged sheet, the field points directly away from the sheet (normal to it) on both sides, so both flat faces have field pointing outward through them, while the curved side of the pillbox contributes no flux (since the field there is parallel to that surface).', ARRAY['a-diagram'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e4ae8556-5d1e-47f7-87c7-299c89725d57', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e4ae8556-5d1e-47f7-87c7-299c89725d57', 'canonical_answer_1', 3, '(b) Applying Gauss''s law to the pillbox: the flux through the two flat faces is 2*E*A (each face has area A and field magnitude E normal to it), and the enclosed charge is sigma*A. So 2*E*A=sigma*A/epsilon0, giving E=sigma/(2*epsilon0) for the nonconducting sheet.', ARRAY['b-sheet'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e4ae8556-5d1e-47f7-87c7-299c89725d57', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e4ae8556-5d1e-47f7-87c7-299c89725d57', 'canonical_answer_1', 5, 'Immediately outside a conductor whose single outer face carries the same charge density sigma, the field is E=sigma/epsilon0 -- twice the nonconducting-sheet value. This is because the conductor''s interior field must be zero (electrostatic equilibrium), so a pillbox straddling the conductor''s surface has flux only through its outer face (the inner face, inside the conductor, contributes zero), giving E*A=sigma*A/epsilon0 directly, with no factor of 2 to divide by, unlike the isolated sheet where both faces of the pillbox contribute flux.', ARRAY['b-conductor'], 'drafted', 'apphysicscem_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('5ac9b983-6266-4b04-914f-d91cc3edaa6b'::uuid),('185f1287-4084-479c-bfbd-d96ccfa457a2'::uuid),('4881dd2e-607b-49d8-9ede-e3d13c4da94e'::uuid),('e4ae8556-5d1e-47f7-87c7-299c89725d57'::uuid)) as t(vid)
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

-- apphycem-frq-020 (827cc508-251e-4288-8be6-700541d5ee09)
update app.content_item_versions set canonical_answer_1 = '(a) A charge element at position x (0<=x<=L) has charge dq=(lambda0*x/L)*dx, and lies a distance (2L-x) from point P at x=2L; the field this element produces at P points in the +x direction (away from the positive charge, toward P).

The total field is the sum of all such elements: E=(k*lambda0/L)*the integral from 0 to L of x/(2L-x)^2 dx.

Evaluating this integral (for example via the substitution u=2L-x) gives E=(k*lambda0/L)*(1-ln(2)).

(b) The total charge on the rod is Q=the integral from 0 to L of (lambda0*x/L) dx = lambda0*L/2.

A point-charge estimate places this total charge Q at the rod''s geometric center, x=L/2 (distance 1.5*L from P) -- note this is deliberately distinct from the rod''s charge-weighted center at x=(2/3)*L, since the linear density is nonuniform (increasing toward x=L). This point-charge estimate gives k*Q/(1.5*L)^2 = k*(lambda0*L/2)/(2.25*L^2) = (k*lambda0/L)*(1/4.5), approximately 0.222*k*lambda0/L. This is smaller than the exact result (k*lambda0/L)*(1-ln2), approximately 0.307*k*lambda0/L -- about 38% larger than the point-charge estimate -- because more of the rod''s charge is actually concentrated toward x=L (closer to P) than the geometric center at x=L/2 would suggest.

(c) If P is moved to x=D with D much greater than L, the rod looks like a point charge Q from that distance, so E is approximately k*Q/D^2, directed in +x.' where id = '827cc508-251e-4288-8be6-700541d5ee09';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 1, '(a) A charge element at position x (0<=x<=L) has charge dq=(lambda0*x/L)*dx, and lies a distance (2L-x) from point P at x=2L; the field this element produces at P points in the +x direction (away from the positive charge, toward P).', ARRAY['a-element'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 3, 'The total field is the sum of all such elements: E=(k*lambda0/L)*the integral from 0 to L of x/(2L-x)^2 dx.', ARRAY['a-integral'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 5, 'Evaluating this integral (for example via the substitution u=2L-x) gives E=(k*lambda0/L)*(1-ln(2)).', ARRAY['a-result'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 7, '(b) The total charge on the rod is Q=the integral from 0 to L of (lambda0*x/L) dx = lambda0*L/2.', ARRAY['b-charge'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 9, 'A point-charge estimate places this total charge Q at the rod''s geometric center, x=L/2 (distance 1.5*L from P) -- note this is deliberately distinct from the rod''s charge-weighted center at x=(2/3)*L, since the linear density is nonuniform (increasing toward x=L). This point-charge estimate gives k*Q/(1.5*L)^2 = k*(lambda0*L/2)/(2.25*L^2) = (k*lambda0/L)*(1/4.5), approximately 0.222*k*lambda0/L. This is smaller than the exact result (k*lambda0/L)*(1-ln2), approximately 0.307*k*lambda0/L -- about 38% larger than the point-charge estimate -- because more of the rod''s charge is actually concentrated toward x=L (closer to P) than the geometric center at x=L/2 would suggest.', ARRAY['b-compare'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('827cc508-251e-4288-8be6-700541d5ee09', 'canonical_answer_1', 11, '(c) If P is moved to x=D with D much greater than L, the rod looks like a point charge Q from that distance, so E is approximately k*Q/D^2, directed in +x.', ARRAY['c-far'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-021 (80649e35-7e85-49bb-a863-7a53c80699d3)
update app.content_item_versions set canonical_answer_1 = '(a) A thin ring of the disk at radius r (0<=r<=R) has area 2*pi*r*dr and charge dq=sigma*2*pi*r*dr, and every point on this ring lies a distance sqrt(r^2+z^2) from point P on the axis.

The potential at P is the sum of contributions from all such rings: V=the integral from 0 to R of k*sigma*2*pi*r*dr/sqrt(r^2+z^2).

Evaluating this integral gives V=(sigma/(2*epsilon0))*(sqrt(R^2+z^2)-z).

(b) The axial electric field is obtained from E_z=-dV/dz=-(sigma/(2*epsilon0))*(z/sqrt(R^2+z^2)-1)=(sigma/(2*epsilon0))*[1-z/sqrt(R^2+z^2)].

(c) For z much greater than R, expanding sqrt(R^2+z^2) shows z/sqrt(R^2+z^2) approaches 1-R^2/(2*z^2), so E_z approaches (sigma/(2*epsilon0))*(R^2/(2*z^2))=sigma*R^2/(4*epsilon0*z^2), which matches the point-charge far-field limit k*Q/z^2 using the disk''s total charge Q=sigma*pi*R^2.

As z approaches 0 from the positive side, E_z approaches (sigma/(2*epsilon0))*(1-0)=sigma/(2*epsilon0), matching the field of an infinite charged sheet -- which makes sense since very close to the disk, it locally looks like an infinite sheet.

For the potential at large z, V=(sigma/(2*epsilon0))*(sqrt(R^2+z^2)-z) approaches (sigma/(2*epsilon0))*(R^2/(2*z))=sigma*R^2/(4*epsilon0*z), which matches the point-charge potential k*Q/z using Q=sigma*pi*R^2.

As z approaches 0 from the positive side, V approaches (sigma/(2*epsilon0))*(R-0)=sigma*R/(2*epsilon0), a finite value (unlike the field, the potential does not diverge at the disk''s surface).' where id = '80649e35-7e85-49bb-a863-7a53c80699d3';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 1, '(a) A thin ring of the disk at radius r (0<=r<=R) has area 2*pi*r*dr and charge dq=sigma*2*pi*r*dr, and every point on this ring lies a distance sqrt(r^2+z^2) from point P on the axis.', ARRAY['a-ring'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 3, 'The potential at P is the sum of contributions from all such rings: V=the integral from 0 to R of k*sigma*2*pi*r*dr/sqrt(r^2+z^2).', ARRAY['a-integral'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 5, 'Evaluating this integral gives V=(sigma/(2*epsilon0))*(sqrt(R^2+z^2)-z).', ARRAY['a-result'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 7, '(b) The axial electric field is obtained from E_z=-dV/dz=-(sigma/(2*epsilon0))*(z/sqrt(R^2+z^2)-1)=(sigma/(2*epsilon0))*[1-z/sqrt(R^2+z^2)].', ARRAY['b-field'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 9, '(c) For z much greater than R, expanding sqrt(R^2+z^2) shows z/sqrt(R^2+z^2) approaches 1-R^2/(2*z^2), so E_z approaches (sigma/(2*epsilon0))*(R^2/(2*z^2))=sigma*R^2/(4*epsilon0*z^2), which matches the point-charge far-field limit k*Q/z^2 using the disk''s total charge Q=sigma*pi*R^2.', ARRAY['c-field-far'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 11, 'As z approaches 0 from the positive side, E_z approaches (sigma/(2*epsilon0))*(1-0)=sigma/(2*epsilon0), matching the field of an infinite charged sheet -- which makes sense since very close to the disk, it locally looks like an infinite sheet.', ARRAY['c-field-surface'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 13, 'For the potential at large z, V=(sigma/(2*epsilon0))*(sqrt(R^2+z^2)-z) approaches (sigma/(2*epsilon0))*(R^2/(2*z))=sigma*R^2/(4*epsilon0*z), which matches the point-charge potential k*Q/z using Q=sigma*pi*R^2.', ARRAY['c-potential-far'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('80649e35-7e85-49bb-a863-7a53c80699d3', 'canonical_answer_1', 15, 'As z approaches 0 from the positive side, V approaches (sigma/(2*epsilon0))*(R-0)=sigma*R/(2*epsilon0), a finite value (unlike the field, the potential does not diverge at the disk''s surface).', ARRAY['c-potential-near'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-025 (43a19e11-5d0b-437f-9d9b-7098ee87e22e)
update app.content_item_versions set canonical_answer_1 = '(a) With the capacitor empty (no dielectric), measure its initial capacitance C0=Q/V0 using the known charge and measured voltage, along with the known plate geometry.

After fully inserting the dielectric slab (with the capacitor disconnected from any source, so charge Q stays fixed), measure the new voltage V, and compute the dielectric constant as kappa=C/C0=V0/V (since C=Q/V and C0=Q/V0, their ratio is V0/V).

(b) Since C becomes kappa*C0 while Q is held fixed, the voltage V=Q/C becomes 1/kappa of its initial value V0.

The electric field E=V/d (with separation d unchanged) also becomes 1/kappa of its initial value, following directly from the voltage becoming 1/kappa of V0.

The stored energy U=Q^2/(2C), at fixed charge Q, becomes 1/kappa of its initial value, since C increases by a factor of kappa in the denominator.

(c) Keep the plate geometry (area and separation), the initial charge Q, and the way the slab is placed between the plates fixed and consistent across all measurements, and minimize ambient humidity and any leakage paths that could let charge escape.

To check for incomplete filling, vary how far the slab is inserted (or otherwise inspect) to confirm the slab completely fills the gap between the plates rather than leaving an air gap, which would make the effective capacitance differ from the simple kappa*C0 prediction.

To check for charge leakage, compare the measured charge Q before dielectric insertion to the measured charge Q after insertion; if these differ, some charge has leaked away and the fixed-charge assumption underlying the analysis is violated.' where id = '43a19e11-5d0b-437f-9d9b-7098ee87e22e';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 1, '(a) With the capacitor empty (no dielectric), measure its initial capacitance C0=Q/V0 using the known charge and measured voltage, along with the known plate geometry.', ARRAY['a-baseline'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 3, 'After fully inserting the dielectric slab (with the capacitor disconnected from any source, so charge Q stays fixed), measure the new voltage V, and compute the dielectric constant as kappa=C/C0=V0/V (since C=Q/V and C0=Q/V0, their ratio is V0/V).', ARRAY['a-kappa'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 5, '(b) Since C becomes kappa*C0 while Q is held fixed, the voltage V=Q/C becomes 1/kappa of its initial value V0.', ARRAY['b-voltage'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 7, 'The electric field E=V/d (with separation d unchanged) also becomes 1/kappa of its initial value, following directly from the voltage becoming 1/kappa of V0.', ARRAY['b-field'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 9, 'The stored energy U=Q^2/(2C), at fixed charge Q, becomes 1/kappa of its initial value, since C increases by a factor of kappa in the denominator.', ARRAY['b-energy'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 11, '(c) Keep the plate geometry (area and separation), the initial charge Q, and the way the slab is placed between the plates fixed and consistent across all measurements, and minimize ambient humidity and any leakage paths that could let charge escape.', ARRAY['c-controls'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 13, 'To check for incomplete filling, vary how far the slab is inserted (or otherwise inspect) to confirm the slab completely fills the gap between the plates rather than leaving an air gap, which would make the effective capacitance differ from the simple kappa*C0 prediction.', ARRAY['c-fitting'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('43a19e11-5d0b-437f-9d9b-7098ee87e22e', 'canonical_answer_1', 15, 'To check for charge leakage, compare the measured charge Q before dielectric insertion to the measured charge Q after insertion; if these differ, some charge has leaked away and the fixed-charge assumption underlying the analysis is violated.', ARRAY['c-leakage'], 'drafted', 'apphysicscem_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('827cc508-251e-4288-8be6-700541d5ee09'::uuid),('80649e35-7e85-49bb-a863-7a53c80699d3'::uuid),('43a19e11-5d0b-437f-9d9b-7098ee87e22e'::uuid)) as t(vid)
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

-- apphycem-frq-027 (890799b0-985d-42f6-99c3-9dde59e81e68)
update app.content_item_versions set canonical_answer_1 = '(a) The circuit diagram shows two mesh loops sharing resistor R3: the left loop contains emf eps1 and resistor R1, with clockwise mesh current i1 assigned to it; the right loop contains resistor R2 and emf eps2 (oriented so it opposes eps1''s traversal direction around the shared branch), with clockwise mesh current i2 assigned to it; both mesh currents flow through the shared resistor R3, in opposite directions relative to each other there.

Applying Kirchhoff''s voltage law around the left mesh (traversing in the direction of i1): (R1+R3)*i1-R3*i2=eps1.

Applying Kirchhoff''s voltage law around the right mesh, with eps2 oriented to oppose eps1''s traversal direction around the shared branch: -R3*i1+(R2+R3)*i2=-eps2 (or an equivalent fully self-consistent sign convention that matches the polarities shown in the diagram).

(b) These two equations can be written in matrix form using the symmetric resistance matrix: [[R1+R3, -R3],[-R3, R2+R3]] * [i1, i2]^T = [eps1, -eps2]^T.

Solving this system (for example by Cramer''s rule) with determinant D=(R1+R3)(R2+R3)-R3^2=R1*R2+R1*R3+R2*R3 gives algebraically consistent expressions for i1 and i2 in terms of eps1, eps2, R1, R2, and R3.

(c) The current actually flowing through the shared resistor R3 is i1-i2 (since the two mesh currents flow through it in opposite directions), with the sign of this difference indicating the actual direction of current flow -- consistent with charge conservation at the junction where the two meshes meet.

Summing the signed power delivered by each source (eps1*i1 and -eps2*i2, or the appropriate signed combination matching the chosen conventions) and comparing to the total resistor dissipation (i1^2*R1+i2^2*R2+(i1-i2)^2*R3) confirms that total power delivered by the sources equals total power dissipated in the resistors, verifying energy conservation.' where id = '890799b0-985d-42f6-99c3-9dde59e81e68';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 1, '(a) The circuit diagram shows two mesh loops sharing resistor R3: the left loop contains emf eps1 and resistor R1, with clockwise mesh current i1 assigned to it; the right loop contains resistor R2 and emf eps2 (oriented so it opposes eps1''s traversal direction around the shared branch), with clockwise mesh current i2 assigned to it; both mesh currents flow through the shared resistor R3, in opposite directions relative to each other there.', ARRAY['a-diagram'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 3, 'Applying Kirchhoff''s voltage law around the left mesh (traversing in the direction of i1): (R1+R3)*i1-R3*i2=eps1.', ARRAY['a-left'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 5, 'Applying Kirchhoff''s voltage law around the right mesh, with eps2 oriented to oppose eps1''s traversal direction around the shared branch: -R3*i1+(R2+R3)*i2=-eps2 (or an equivalent fully self-consistent sign convention that matches the polarities shown in the diagram).', ARRAY['a-right'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 7, '(b) These two equations can be written in matrix form using the symmetric resistance matrix: [[R1+R3, -R3],[-R3, R2+R3]] * [i1, i2]^T = [eps1, -eps2]^T.', ARRAY['b-matrix'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 9, 'Solving this system (for example by Cramer''s rule) with determinant D=(R1+R3)(R2+R3)-R3^2=R1*R2+R1*R3+R2*R3 gives algebraically consistent expressions for i1 and i2 in terms of eps1, eps2, R1, R2, and R3.', ARRAY['b-solution'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 11, '(c) The current actually flowing through the shared resistor R3 is i1-i2 (since the two mesh currents flow through it in opposite directions), with the sign of this difference indicating the actual direction of current flow -- consistent with charge conservation at the junction where the two meshes meet.', ARRAY['c-junction'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('890799b0-985d-42f6-99c3-9dde59e81e68', 'canonical_answer_1', 13, 'Summing the signed power delivered by each source (eps1*i1 and -eps2*i2, or the appropriate signed combination matching the chosen conventions) and comparing to the total resistor dissipation (i1^2*R1+i2^2*R2+(i1-i2)^2*R3) confirms that total power delivered by the sources equals total power dissipated in the resistors, verifying energy conservation.', ARRAY['c-power'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-028 (c356edae-f9f9-4d65-9f17-22c18498012d)
update app.content_item_versions set canonical_answer_1 = '(a) At each of several stabilized bath temperatures, apply a small current through the wire and measure the resulting voltage, computing resistance as R=V/I at that temperature.

In addition to the other bath temperatures, specifically measure the reference resistance R0=V/I at the stated reference temperature T0, since R0 is needed to construct the graph in part (b).

(b) Plotting (R/R0)-1 on the vertical axis against (T-T0) on the horizontal axis, from the relation rho=rho0*[1+alpha*(T-T0)] (and R proportional to rho for fixed wire geometry), gives a line whose slope is the temperature coefficient alpha.

Keep the wire''s geometry (length and cross-sectional area) and the bath''s other conditions (such as its uniformity) fixed across all temperature measurements, so that only temperature is being varied.

To check for self-heating effects (the measurement current itself heating the wire and skewing the resistance reading), repeat a measurement at a given bath temperature using a smaller current; if R stays the same, the current is small enough that self-heating (extra Joule heating beyond what the bath alone produces) is not significantly affecting the result.' where id = 'c356edae-f9f9-4d65-9f17-22c18498012d';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c356edae-f9f9-4d65-9f17-22c18498012d', 'canonical_answer_1', 1, '(a) At each of several stabilized bath temperatures, apply a small current through the wire and measure the resulting voltage, computing resistance as R=V/I at that temperature.', ARRAY['a-data'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c356edae-f9f9-4d65-9f17-22c18498012d', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c356edae-f9f9-4d65-9f17-22c18498012d', 'canonical_answer_1', 3, 'In addition to the other bath temperatures, specifically measure the reference resistance R0=V/I at the stated reference temperature T0, since R0 is needed to construct the graph in part (b).', ARRAY['a-reference'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c356edae-f9f9-4d65-9f17-22c18498012d', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c356edae-f9f9-4d65-9f17-22c18498012d', 'canonical_answer_1', 5, '(b) Plotting (R/R0)-1 on the vertical axis against (T-T0) on the horizontal axis, from the relation rho=rho0*[1+alpha*(T-T0)] (and R proportional to rho for fixed wire geometry), gives a line whose slope is the temperature coefficient alpha.', ARRAY['b-graph'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c356edae-f9f9-4d65-9f17-22c18498012d', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c356edae-f9f9-4d65-9f17-22c18498012d', 'canonical_answer_1', 7, 'Keep the wire''s geometry (length and cross-sectional area) and the bath''s other conditions (such as its uniformity) fixed across all temperature measurements, so that only temperature is being varied.', ARRAY['b-controls'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c356edae-f9f9-4d65-9f17-22c18498012d', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c356edae-f9f9-4d65-9f17-22c18498012d', 'canonical_answer_1', 9, 'To check for self-heating effects (the measurement current itself heating the wire and skewing the resistance reading), repeat a measurement at a given bath temperature using a smaller current; if R stays the same, the current is small enough that self-heating (extra Joule heating beyond what the bath alone produces) is not significantly affecting the result.', ARRAY['b-diagnostic'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-031 (66830a63-4db7-420b-80e4-388e1d7460d9)
update app.content_item_versions set canonical_answer_1 = '(a) Using a circular Amperian loop of radius r concentric with the toroid''s axis, the cylindrical symmetry of the tightly wound toroidal winding ensures the magnetic field B is tangent to this loop and has the same constant magnitude everywhere on it.

For a<r<b, this Amperian loop encloses all N turns, each carrying current I, so Ampere''s law gives B*(2*pi*r)=mu0*N*I, and solving for B gives B=mu0*N*I/(2*pi*r).

(b) For r<a, an Amperian loop entirely inside the inner radius encloses none of the winding''s current (all N turns pass outside this loop, at radii between a and b), so the ideal field there is B is approximately 0.

For r>b, an Amperian loop outside the toroid encloses each winding turn''s current twice, in opposite directions (once going into the page and once coming out, as the wire wraps around), giving zero net enclosed current, so the ideal field there is also B is approximately 0.

These r<a and r>b results are idealizations: they rely on the windings being tightly and uniformly packed around the toroid, on ideal toroidal (rotational) symmetry, and on neglecting any fringing fields or current leakage between adjacent turns that a real, finite-pitch winding would actually produce.' where id = '66830a63-4db7-420b-80e4-388e1d7460d9';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('66830a63-4db7-420b-80e4-388e1d7460d9', 'canonical_answer_1', 1, '(a) Using a circular Amperian loop of radius r concentric with the toroid''s axis, the cylindrical symmetry of the tightly wound toroidal winding ensures the magnetic field B is tangent to this loop and has the same constant magnitude everywhere on it.', ARRAY['a-loop'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('66830a63-4db7-420b-80e4-388e1d7460d9', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('66830a63-4db7-420b-80e4-388e1d7460d9', 'canonical_answer_1', 3, 'For a<r<b, this Amperian loop encloses all N turns, each carrying current I, so Ampere''s law gives B*(2*pi*r)=mu0*N*I, and solving for B gives B=mu0*N*I/(2*pi*r).', ARRAY['a-result'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('66830a63-4db7-420b-80e4-388e1d7460d9', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('66830a63-4db7-420b-80e4-388e1d7460d9', 'canonical_answer_1', 5, '(b) For r<a, an Amperian loop entirely inside the inner radius encloses none of the winding''s current (all N turns pass outside this loop, at radii between a and b), so the ideal field there is B is approximately 0.', ARRAY['b-inner'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('66830a63-4db7-420b-80e4-388e1d7460d9', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('66830a63-4db7-420b-80e4-388e1d7460d9', 'canonical_answer_1', 7, 'For r>b, an Amperian loop outside the toroid encloses each winding turn''s current twice, in opposite directions (once going into the page and once coming out, as the wire wraps around), giving zero net enclosed current, so the ideal field there is also B is approximately 0.', ARRAY['b-outer'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('66830a63-4db7-420b-80e4-388e1d7460d9', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('66830a63-4db7-420b-80e4-388e1d7460d9', 'canonical_answer_1', 9, 'These r<a and r>b results are idealizations: they rely on the windings being tightly and uniformly packed around the toroid, on ideal toroidal (rotational) symmetry, and on neglecting any fringing fields or current leakage between adjacent turns that a real, finite-pitch winding would actually produce.', ARRAY['b-approximations'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-032 (fd92843b-d129-47da-b324-7873eb78a58d)
update app.content_item_versions set canonical_answer_1 = '(a) With the coil''s turns N, area A, and current I held fixed, measure the torque on the coil at several different angles theta, where theta is correctly defined as the angle between the coil''s magnetic moment (the normal to the coil''s plane) and the magnetic field B.

(b) Hold N, I, and A (the coil''s geometry and its current) fixed while theta is varied as the independent variable across the trials.

Before extracting a slope from the data, subtract off any zero-field or apparatus (torsion-related) torque baseline that would be present even without the magnetic interaction, so that only the magnetic torque contribution is analyzed.

Plotting the (baseline-corrected) torque tau against sin(theta) should give a straight line with slope N*I*A*B, since the predicted relation is tau=N*I*A*B*sin(theta).

From the measured slope of this corrected graph, the unknown field strength can be determined as B=slope/(N*I*A).' where id = 'fd92843b-d129-47da-b324-7873eb78a58d';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('fd92843b-d129-47da-b324-7873eb78a58d', 'canonical_answer_1', 1, '(a) With the coil''s turns N, area A, and current I held fixed, measure the torque on the coil at several different angles theta, where theta is correctly defined as the angle between the coil''s magnetic moment (the normal to the coil''s plane) and the magnetic field B.', ARRAY['a-procedure'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('fd92843b-d129-47da-b324-7873eb78a58d', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('fd92843b-d129-47da-b324-7873eb78a58d', 'canonical_answer_1', 3, '(b) Hold N, I, and A (the coil''s geometry and its current) fixed while theta is varied as the independent variable across the trials.', ARRAY['b-controls'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('fd92843b-d129-47da-b324-7873eb78a58d', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('fd92843b-d129-47da-b324-7873eb78a58d', 'canonical_answer_1', 5, 'Before extracting a slope from the data, subtract off any zero-field or apparatus (torsion-related) torque baseline that would be present even without the magnetic interaction, so that only the magnetic torque contribution is analyzed.', ARRAY['b-zerocorrection'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('fd92843b-d129-47da-b324-7873eb78a58d', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('fd92843b-d129-47da-b324-7873eb78a58d', 'canonical_answer_1', 7, 'Plotting the (baseline-corrected) torque tau against sin(theta) should give a straight line with slope N*I*A*B, since the predicted relation is tau=N*I*A*B*sin(theta).', ARRAY['b-graph'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('fd92843b-d129-47da-b324-7873eb78a58d', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('fd92843b-d129-47da-b324-7873eb78a58d', 'canonical_answer_1', 9, 'From the measured slope of this corrected graph, the unknown field strength can be determined as B=slope/(N*I*A).', ARRAY['b-determineB'], 'drafted', 'apphysicscem_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('890799b0-985d-42f6-99c3-9dde59e81e68'::uuid),('c356edae-f9f9-4d65-9f17-22c18498012d'::uuid),('66830a63-4db7-420b-80e4-388e1d7460d9'::uuid),('fd92843b-d129-47da-b324-7873eb78a58d'::uuid)) as t(vid)
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

-- apphycem-frq-033 (6f6d81dc-1c4e-4db9-8590-843e13d1e954)
update app.content_item_versions set canonical_answer_1 = '(a) As the rod slides right, the enclosed loop area increases, increasing the into-page magnetic flux through the loop; by Faraday''s law (or equivalently by the magnetic force on charge carriers in the moving rod), this induces an emf of magnitude eps=B*l*v.

The resulting induced current is I=eps/R=B*l*v/R.

By Lenz''s law, the induced current opposes the increasing into-page flux, so it must create a magnetic field out of the page inside the loop; by the right-hand rule, this requires the current to flow counterclockwise around the loop (using the loop geometry specified, with the rod as the right-hand side).

(b) The magnetic force on the current-carrying rod has magnitude F=I*l*B=(B*l*v/R)*l*B=B^2*l^2*v/R, and by Lenz''s law this force opposes the rod''s motion, so it points leftward (opposite to v).

(b) To keep the rod moving at constant speed, an external force of equal magnitude B^2*l^2*v/R must be applied to the right, exactly balancing the leftward magnetic braking force so that the net force (and hence acceleration) is zero.

(c) The mechanical power delivered by this external force is F_ext*v=(B^2*l^2*v/R)*v=B^2*l^2*v^2/R. The electrical power dissipated in the resistor is I^2*R=(B*l*v/R)^2*R=B^2*l^2*v^2/R. These are equal, confirming that all the mechanical work done by the external force to maintain constant speed is converted into resistive heating in the circuit.' where id = '6f6d81dc-1c4e-4db9-8590-843e13d1e954';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 1, '(a) As the rod slides right, the enclosed loop area increases, increasing the into-page magnetic flux through the loop; by Faraday''s law (or equivalently by the magnetic force on charge carriers in the moving rod), this induces an emf of magnitude eps=B*l*v.', ARRAY['a-emf'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 3, 'The resulting induced current is I=eps/R=B*l*v/R.', ARRAY['a-current'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 5, 'By Lenz''s law, the induced current opposes the increasing into-page flux, so it must create a magnetic field out of the page inside the loop; by the right-hand rule, this requires the current to flow counterclockwise around the loop (using the loop geometry specified, with the rod as the right-hand side).', ARRAY['a-direction'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 7, '(b) The magnetic force on the current-carrying rod has magnitude F=I*l*B=(B*l*v/R)*l*B=B^2*l^2*v/R, and by Lenz''s law this force opposes the rod''s motion, so it points leftward (opposite to v).', ARRAY['b-force'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 9, '(b) To keep the rod moving at constant speed, an external force of equal magnitude B^2*l^2*v/R must be applied to the right, exactly balancing the leftward magnetic braking force so that the net force (and hence acceleration) is zero.', ARRAY['b-external'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954', 'canonical_answer_1', 11, '(c) The mechanical power delivered by this external force is F_ext*v=(B^2*l^2*v/R)*v=B^2*l^2*v^2/R. The electrical power dissipated in the resistor is I^2*R=(B*l*v/R)^2*R=B^2*l^2*v^2/R. These are equal, confirming that all the mechanical work done by the external force to maintain constant speed is converted into resistive heating in the circuit.', ARRAY['c-power'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-034 (03d8df61-1888-4554-9c09-bc3b7e7de672)
update app.content_item_versions set canonical_answer_1 = '(a) With the source removed, Kirchhoff''s voltage law around the L-R loop gives L*(di/dt)+R*i=0, whose solution with initial current I0 is i(t)=I0*e^(-Rt/L).

Using the polarity reference stated in the problem (positive at the terminal where current entered during steady-state operation), the inductor voltage at t=0+ is v_L(0+)=L*(di/dt)|_(t=0)=L*I0*(-R/L)=-R*I0. This negative sign (relative to the steady-state reference direction) reflects that the inductor now drives current through R -- opposing the decaying current to keep it flowing -- rather than being driven by an external source as it was during the earlier steady state.

(b) The inductor enforces current continuity: the current cannot drop instantaneously to zero at t=0 because an instantaneous change in inductor current would require an infinite voltage across it (since v_L=L*di/dt). Instead, the current decays smoothly and continuously from its initial value I0.

The total heat dissipated in the resistor over the entire decay equals the initial magnetic energy stored in the inductor, (1/2)*L*I0^2, since all of that stored energy is eventually converted to heat as the current decays to zero (energy conservation, with no other energy sink present).' where id = '03d8df61-1888-4554-9c09-bc3b7e7de672';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('03d8df61-1888-4554-9c09-bc3b7e7de672', 'canonical_answer_1', 1, '(a) With the source removed, Kirchhoff''s voltage law around the L-R loop gives L*(di/dt)+R*i=0, whose solution with initial current I0 is i(t)=I0*e^(-Rt/L).', ARRAY['a-current'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('03d8df61-1888-4554-9c09-bc3b7e7de672', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('03d8df61-1888-4554-9c09-bc3b7e7de672', 'canonical_answer_1', 3, 'Using the polarity reference stated in the problem (positive at the terminal where current entered during steady-state operation), the inductor voltage at t=0+ is v_L(0+)=L*(di/dt)|_(t=0)=L*I0*(-R/L)=-R*I0. This negative sign (relative to the steady-state reference direction) reflects that the inductor now drives current through R -- opposing the decaying current to keep it flowing -- rather than being driven by an external source as it was during the earlier steady state.', ARRAY['a-voltage'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('03d8df61-1888-4554-9c09-bc3b7e7de672', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('03d8df61-1888-4554-9c09-bc3b7e7de672', 'canonical_answer_1', 5, '(b) The inductor enforces current continuity: the current cannot drop instantaneously to zero at t=0 because an instantaneous change in inductor current would require an infinite voltage across it (since v_L=L*di/dt). Instead, the current decays smoothly and continuously from its initial value I0.', ARRAY['b-continuity'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('03d8df61-1888-4554-9c09-bc3b7e7de672', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('03d8df61-1888-4554-9c09-bc3b7e7de672', 'canonical_answer_1', 7, 'The total heat dissipated in the resistor over the entire decay equals the initial magnetic energy stored in the inductor, (1/2)*L*I0^2, since all of that stored energy is eventually converted to heat as the current decays to zero (energy conservation, with no other energy sink present).', ARRAY['b-heat'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-035 (8caa38af-5656-4ae4-8840-b3018b308e6b)
update app.content_item_versions set canonical_answer_1 = '(a) A thin spherical shell at radius r'' (with 0<=r''<=R) has charge dq=rho(r'')*4*pi*r''^2*dr''=rho0*(r''/R)*4*pi*r''^2*dr''.

The enclosed charge within radius r (for r<R) is q_enc(r)=the integral from 0 to r of rho0*(r''/R)*4*pi*r''^2 dr'' = (4*pi*rho0/R)*(r^4/4) = pi*rho0*r^4/R.

Applying Gauss''s law inside the sphere: E*(4*pi*r^2)=q_enc(r)/epsilon0.

Solving gives E_inside(r)=(pi*rho0*r^4/R)/(4*pi*epsilon0*r^2)=rho0*r^2/(4*epsilon0*R), directed radially outward.

The total charge on the sphere is Q=q_enc(R)=pi*rho0*R^4/R=pi*rho0*R^3.

Outside the sphere (r>R), all the charge Q is enclosed, so E_outside(r)=k*Q/r^2=Q/(4*pi*epsilon0*r^2)=(pi*rho0*R^3)/(4*pi*epsilon0*r^2)=rho0*R^3/(4*epsilon0*r^2), directed radially outward.

At r=R, both expressions agree: E_inside(R)=rho0*R^2/(4*epsilon0*R)=rho0*R/(4*epsilon0), and E_outside(R)=rho0*R^3/(4*epsilon0*R^2)=rho0*R/(4*epsilon0), confirming the field is continuous at the boundary.

(b) Taking V(infinity)=0, the potential at the center is V(0)=the integral from 0 to infinity of E(r) dr, split into the inside contribution (0 to R) and the outside contribution (R to infinity), using the correct E(r) expression in each region.

The inside contribution is the integral from 0 to R of rho0*r^2/(4*epsilon0*R) dr = rho0/(4*epsilon0*R) * (R^3/3) = rho0*R^2/(12*epsilon0).

The outside contribution is the integral from R to infinity of rho0*R^3/(4*epsilon0*r^2) dr = rho0*R^3/(4*epsilon0) * (1/R) = rho0*R^2/(4*epsilon0). Adding both contributions: V(0)=rho0*R^2/(12*epsilon0)+rho0*R^2/(4*epsilon0)=rho0*R^2/(12*epsilon0)+3*rho0*R^2/(12*epsilon0)=4*rho0*R^2/(12*epsilon0)=rho0*R^2/(3*epsilon0).' where id = '8caa38af-5656-4ae4-8840-b3018b308e6b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 1, '(a) A thin spherical shell at radius r'' (with 0<=r''<=R) has charge dq=rho(r'')*4*pi*r''^2*dr''=rho0*(r''/R)*4*pi*r''^2*dr''.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 3, 'The enclosed charge within radius r (for r<R) is q_enc(r)=the integral from 0 to r of rho0*(r''/R)*4*pi*r''^2 dr'' = (4*pi*rho0/R)*(r^4/4) = pi*rho0*r^4/R.', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 5, 'Applying Gauss''s law inside the sphere: E*(4*pi*r^2)=q_enc(r)/epsilon0.', ARRAY['part-a-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 7, 'Solving gives E_inside(r)=(pi*rho0*r^4/R)/(4*pi*epsilon0*r^2)=rho0*r^2/(4*epsilon0*R), directed radially outward.', ARRAY['part-a-criterion-04'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 9, 'The total charge on the sphere is Q=q_enc(R)=pi*rho0*R^4/R=pi*rho0*R^3.', ARRAY['part-a-criterion-05'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 11, 'Outside the sphere (r>R), all the charge Q is enclosed, so E_outside(r)=k*Q/r^2=Q/(4*pi*epsilon0*r^2)=(pi*rho0*R^3)/(4*pi*epsilon0*r^2)=rho0*R^3/(4*epsilon0*r^2), directed radially outward.', ARRAY['part-a-criterion-06'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 13, 'At r=R, both expressions agree: E_inside(R)=rho0*R^2/(4*epsilon0*R)=rho0*R/(4*epsilon0), and E_outside(R)=rho0*R^3/(4*epsilon0*R^2)=rho0*R/(4*epsilon0), confirming the field is continuous at the boundary.', ARRAY['part-a-criterion-07'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 15, '(b) Taking V(infinity)=0, the potential at the center is V(0)=the integral from 0 to infinity of E(r) dr, split into the inside contribution (0 to R) and the outside contribution (R to infinity), using the correct E(r) expression in each region.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 17, 'The inside contribution is the integral from 0 to R of rho0*r^2/(4*epsilon0*R) dr = rho0/(4*epsilon0*R) * (R^3/3) = rho0*R^2/(12*epsilon0).', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8caa38af-5656-4ae4-8840-b3018b308e6b', 'canonical_answer_1', 19, 'The outside contribution is the integral from R to infinity of rho0*R^3/(4*epsilon0*r^2) dr = rho0*R^3/(4*epsilon0) * (1/R) = rho0*R^2/(4*epsilon0). Adding both contributions: V(0)=rho0*R^2/(12*epsilon0)+rho0*R^2/(4*epsilon0)=rho0*R^2/(12*epsilon0)+3*rho0*R^2/(12*epsilon0)=4*rho0*R^2/(12*epsilon0)=rho0*R^2/(3*epsilon0).', ARRAY['part-b-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('6f6d81dc-1c4e-4db9-8590-843e13d1e954'::uuid),('03d8df61-1888-4554-9c09-bc3b7e7de672'::uuid),('8caa38af-5656-4ae4-8840-b3018b308e6b'::uuid)) as t(vid)
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

-- apphycem-frq-036 (3d699ff6-68b1-4987-9a7e-c1bab1b8694a)
update app.content_item_versions set canonical_answer_1 = '(a) The circuit diagram shows R and 2R connected in parallel with each other, both across the capacitor C, with conventional current flowing out of the initially positive plate through this parallel combination.

The equivalent resistance of R and 2R in parallel is R_eq=(R*2R)/(R+2R)=2*R^2/(3R)=2*R/3.

The discharge equation is dq/dt=-q/(R_eq*C)=-q/((2R/3)*C)=-3*q/(2*R*C).

(b) Integrating this differential equation with initial charge q(0)=C*V0 gives q(t)=C*V0*e^(-3t/(2RC)).

The capacitor voltage is V_C(t)=q(t)/C=V0*e^(-3t/(2RC)).

The current through each resistor is I_R=V_C/R=(V0/R)*e^(-3t/(2RC)), and I_2R=V_C/(2R)=(V0/(2R))*e^(-3t/(2RC)).

The sum of these currents is I_R+I_2R=(V0/R+V0/(2R))*e^(-3t/(2RC))=(3*V0/(2R))*e^(-3t/(2RC)), which matches -dq/dt=3*q/(2RC)=3*C*V0*e^(-3t/(2RC))/(2RC)=(3*V0/(2R))*e^(-3t/(2RC)), confirming charge conservation.

(c) The charge q(t) decreases exponentially from its initial value C*V0, with time constant 2RC/3.

The total current I_R+I_2R decreases exponentially from its initial value 3*V0/(2R), with the same time constant 2RC/3.

The power dissipated in the 2R resistor is P_2R=I_2R^2*(2R)=(V0/(2R))^2*e^(-2*3t/(2RC))*2R=(V0^2/(2R))*e^(-3t/(RC)), which has time constant RC/3 -- half the charge and current time constant of 2RC/3, since power involves the square of the decaying exponential.

(d) Since R and 2R are always in parallel and thus always share the same voltage V_C, their instantaneous powers are in the ratio P_R:P_2R=(V_C^2/R):(V_C^2/(2R))=2:1 at every instant.

Since this 2:1 power ratio holds at every instant throughout the discharge, the same ratio applies to the total energy dissipated in each resistor over the whole process; the smaller resistor R (getting twice the power) receives two-thirds of the total dissipated energy, while resistor 2R receives one third of the initial capacitor energy.' where id = '3d699ff6-68b1-4987-9a7e-c1bab1b8694a';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 1, '(a) The circuit diagram shows R and 2R connected in parallel with each other, both across the capacitor C, with conventional current flowing out of the initially positive plate through this parallel combination.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 3, 'The equivalent resistance of R and 2R in parallel is R_eq=(R*2R)/(R+2R)=2*R^2/(3R)=2*R/3.', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 5, 'The discharge equation is dq/dt=-q/(R_eq*C)=-q/((2R/3)*C)=-3*q/(2*R*C).', ARRAY['part-a-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 7, '(b) Integrating this differential equation with initial charge q(0)=C*V0 gives q(t)=C*V0*e^(-3t/(2RC)).', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 9, 'The capacitor voltage is V_C(t)=q(t)/C=V0*e^(-3t/(2RC)).', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 11, 'The current through each resistor is I_R=V_C/R=(V0/R)*e^(-3t/(2RC)), and I_2R=V_C/(2R)=(V0/(2R))*e^(-3t/(2RC)).', ARRAY['part-b-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 13, 'The sum of these currents is I_R+I_2R=(V0/R+V0/(2R))*e^(-3t/(2RC))=(3*V0/(2R))*e^(-3t/(2RC)), which matches -dq/dt=3*q/(2RC)=3*C*V0*e^(-3t/(2RC))/(2RC)=(3*V0/(2R))*e^(-3t/(2RC)), confirming charge conservation.', ARRAY['part-b-criterion-04'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 15, '(c) The charge q(t) decreases exponentially from its initial value C*V0, with time constant 2RC/3.', ARRAY['part-c-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 17, 'The total current I_R+I_2R decreases exponentially from its initial value 3*V0/(2R), with the same time constant 2RC/3.', ARRAY['part-c-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 19, 'The power dissipated in the 2R resistor is P_2R=I_2R^2*(2R)=(V0/(2R))^2*e^(-2*3t/(2RC))*2R=(V0^2/(2R))*e^(-3t/(RC)), which has time constant RC/3 -- half the charge and current time constant of 2RC/3, since power involves the square of the decaying exponential.', ARRAY['part-c-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 20, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 21, '(d) Since R and 2R are always in parallel and thus always share the same voltage V_C, their instantaneous powers are in the ratio P_R:P_2R=(V_C^2/R):(V_C^2/(2R))=2:1 at every instant.', ARRAY['part-d-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 22, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a', 'canonical_answer_1', 23, 'Since this 2:1 power ratio holds at every instant throughout the discharge, the same ratio applies to the total energy dissipated in each resistor over the whole process; the smaller resistor R (getting twice the power) receives two-thirds of the total dissipated energy, while resistor 2R receives one third of the initial capacitor energy.', ARRAY['part-d-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-037 (67df7e3e-05de-4e71-82a4-e787c40ea10b)
update app.content_item_versions set canonical_answer_1 = '(a) Well inside an ideal long solenoid (far from the ends), the magnetic field magnitude is B=mu0*n*I, where n is the number of turns per unit length.

This predicts that a plot of the axial field B versus current I should be a straight line through the origin with slope mu0*n.

(b) At a fixed central position on the axis, vary the current I over several safe values and record each corresponding measured field B, including a reading taken at zero current.

At one fixed nonzero current, move the probe to several different axial positions -- both near the solenoid''s ends and away from them -- keeping the probe''s orientation fixed, and record B at each position.

(c) Fit the B-versus-I data taken at the central position with a straight line, and calculate n=(fitted slope)/mu0.

Propagate the uncertainty in the fitted slope into the reported n via delta_n=delta_slope/mu0, incorporating the probe''s stated reading uncertainty into the fit or into error bars on each data point.

Use the zero-current reading (the I=0 intercept) to subtract off any constant ambient or probe offset before interpreting the remaining field values as due to the solenoid alone.

Use the axial position map (from part b) together with its uncertainty bars to identify a central interval over which B is statistically consistent with being constant, and exclude the end regions (where the field is known to fall off) from the central-field analysis.

(d) If the ammeter systematically reads currents that are too high (i.e., the recorded current I_read is larger than the true current I_true that actually produced each measured B), the calculated turn density n comes out too small.

This is because the fitted slope is computed as (measured B)/(recorded I). Since each recorded I_read is larger than the true I_true responsible for that B reading, the computed slope B/I_read is smaller than the true ratio B/I_true would be, and since n=slope/mu0, this systematically smaller slope produces an underestimated (too small) value of n.' where id = '67df7e3e-05de-4e71-82a4-e787c40ea10b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 1, '(a) Well inside an ideal long solenoid (far from the ends), the magnetic field magnitude is B=mu0*n*I, where n is the number of turns per unit length.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 3, 'This predicts that a plot of the axial field B versus current I should be a straight line through the origin with slope mu0*n.', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 5, '(b) At a fixed central position on the axis, vary the current I over several safe values and record each corresponding measured field B, including a reading taken at zero current.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 7, 'At one fixed nonzero current, move the probe to several different axial positions -- both near the solenoid''s ends and away from them -- keeping the probe''s orientation fixed, and record B at each position.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 9, '(c) Fit the B-versus-I data taken at the central position with a straight line, and calculate n=(fitted slope)/mu0.', ARRAY['part-c-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 11, 'Propagate the uncertainty in the fitted slope into the reported n via delta_n=delta_slope/mu0, incorporating the probe''s stated reading uncertainty into the fit or into error bars on each data point.', ARRAY['part-c-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 13, 'Use the zero-current reading (the I=0 intercept) to subtract off any constant ambient or probe offset before interpreting the remaining field values as due to the solenoid alone.', ARRAY['part-c-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 15, 'Use the axial position map (from part b) together with its uncertainty bars to identify a central interval over which B is statistically consistent with being constant, and exclude the end regions (where the field is known to fall off) from the central-field analysis.', ARRAY['part-c-criterion-04'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 17, '(d) If the ammeter systematically reads currents that are too high (i.e., the recorded current I_read is larger than the true current I_true that actually produced each measured B), the calculated turn density n comes out too small.', ARRAY['part-d-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67df7e3e-05de-4e71-82a4-e787c40ea10b', 'canonical_answer_1', 19, 'This is because the fitted slope is computed as (measured B)/(recorded I). Since each recorded I_read is larger than the true I_true responsible for that B reading, the computed slope B/I_read is smaller than the true ratio B/I_true would be, and since n=slope/mu0, this systematically smaller slope produces an underestimated (too small) value of n.', ARRAY['part-d-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('3d699ff6-68b1-4987-9a7e-c1bab1b8694a'::uuid),('67df7e3e-05de-4e71-82a4-e787c40ea10b'::uuid)) as t(vid)
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

-- apphycem-frq-038 (b71c78c4-a9e7-442c-a174-8a591ef6bd66)
update app.content_item_versions set canonical_answer_1 = '(a) As the rod slides right through the field B pointing vertically downward, the induced current must oppose the change in flux; working through the loop geometry, the current direction that satisfies Lenz''s law produces a magnetic field pointing upward through the loop''s interior.

Given the specified rail geometry, this corresponds to a definite current direction around the loop (describable unambiguously once the rails'' orientation is fixed, consistent with the upward field just identified via the right-hand rule).

The magnetic force on the current-carrying rod points leftward, opposing the rod''s rightward velocity (as required by Lenz''s law), and this force removes kinetic energy from the rod, which is converted into heat dissipated in the resistor R.

(b) The motional emf is eps=B*l*v, and the resulting current is I=eps/R=B*l*v/R.

The magnetic force on the rod, F=B*I*l=B^2*l^2*v/R, opposes the motion, so Newton''s second law gives m*(dv/dt)=-(B^2*l^2/R)*v.

Solving this differential equation (separating variables and integrating) with initial speed v0 gives v(t)=v0*exp[-B^2*l^2*t/(m*R)].

(c) The speed v(t) decays exponentially from v0 with time constant m*R/(B^2*l^2). The power dissipated, P=I^2*R=(B*l*v/R)^2*R=(B^2*l^2/R)*v^2, involves v squared, so it decays with time constant m*R/(2*B^2*l^2) -- twice as fast as the speed itself, since P=(B^2*l^2/R)*v0^2*exp[-2*B^2*l^2*t/(m*R)].

By energy conservation, all of the rod''s initial kinetic energy is eventually dissipated as heat in the resistor (since there is no other place for the energy to go once the rod''s speed decays to zero), so the total dissipated energy is (1/2)*m*v0^2.' where id = 'b71c78c4-a9e7-442c-a174-8a591ef6bd66';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 1, '(a) As the rod slides right through the field B pointing vertically downward, the induced current must oppose the change in flux; working through the loop geometry, the current direction that satisfies Lenz''s law produces a magnetic field pointing upward through the loop''s interior.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 3, 'Given the specified rail geometry, this corresponds to a definite current direction around the loop (describable unambiguously once the rails'' orientation is fixed, consistent with the upward field just identified via the right-hand rule).', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 5, 'The magnetic force on the current-carrying rod points leftward, opposing the rod''s rightward velocity (as required by Lenz''s law), and this force removes kinetic energy from the rod, which is converted into heat dissipated in the resistor R.', ARRAY['part-a-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 7, '(b) The motional emf is eps=B*l*v, and the resulting current is I=eps/R=B*l*v/R.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 9, 'The magnetic force on the rod, F=B*I*l=B^2*l^2*v/R, opposes the motion, so Newton''s second law gives m*(dv/dt)=-(B^2*l^2/R)*v.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 11, 'Solving this differential equation (separating variables and integrating) with initial speed v0 gives v(t)=v0*exp[-B^2*l^2*t/(m*R)].', ARRAY['part-b-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 13, '(c) The speed v(t) decays exponentially from v0 with time constant m*R/(B^2*l^2). The power dissipated, P=I^2*R=(B*l*v/R)^2*R=(B^2*l^2/R)*v^2, involves v squared, so it decays with time constant m*R/(2*B^2*l^2) -- twice as fast as the speed itself, since P=(B^2*l^2/R)*v0^2*exp[-2*B^2*l^2*t/(m*R)].', ARRAY['part-c-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66', 'canonical_answer_1', 15, 'By energy conservation, all of the rod''s initial kinetic energy is eventually dissipated as heat in the resistor (since there is no other place for the energy to go once the rod''s speed decays to zero), so the total dissipated energy is (1/2)*m*v0^2.', ARRAY['part-c-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-040 (af57088b-e96a-4965-af61-dfefe99d1f29)
update app.content_item_versions set canonical_answer_1 = '(a) By symmetry, each +5.00 nC charge produces a field of equal magnitude at the midpoint (0.300 m from each charge), but the two fields point in opposite directions -- each field points away from its own charge, so at the midpoint one field points in the +x direction (away from the charge at x=0) and the other points in the -x direction (away from the charge at x=0.600 m). These equal-magnitude, opposite-direction contributions add to exactly zero, so the net electric field at the midpoint is zero.

(b) By the superposition principle, the total field at any point is the vector sum of the fields from each individual charge. Since the two charges are identical (same sign and magnitude) and equidistant from the midpoint, their individual field magnitudes there are always equal to each other regardless of what that common magnitude actually is -- and because each field points directly away from its own positive charge, the two contributions point in exactly opposite directions at the midpoint. Equal magnitude and opposite direction means the vector sum is always zero, independent of the specific value of the charge.' where id = 'af57088b-e96a-4965-af61-dfefe99d1f29';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('af57088b-e96a-4965-af61-dfefe99d1f29', 'canonical_answer_1', 1, '(a) By symmetry, each +5.00 nC charge produces a field of equal magnitude at the midpoint (0.300 m from each charge), but the two fields point in opposite directions -- each field points away from its own charge, so at the midpoint one field points in the +x direction (away from the charge at x=0) and the other points in the -x direction (away from the charge at x=0.600 m). These equal-magnitude, opposite-direction contributions add to exactly zero, so the net electric field at the midpoint is zero.', ARRAY['part-a'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('af57088b-e96a-4965-af61-dfefe99d1f29', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('af57088b-e96a-4965-af61-dfefe99d1f29', 'canonical_answer_1', 3, '(b) By the superposition principle, the total field at any point is the vector sum of the fields from each individual charge. Since the two charges are identical (same sign and magnitude) and equidistant from the midpoint, their individual field magnitudes there are always equal to each other regardless of what that common magnitude actually is -- and because each field points directly away from its own positive charge, the two contributions point in exactly opposite directions at the midpoint. Equal magnitude and opposite direction means the vector sum is always zero, independent of the specific value of the charge.', ARRAY['part-b'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-042 (4a7130db-bc4a-4227-abab-e385fe24e9cf)
update app.content_item_versions set canonical_answer_1 = '(a) A charge element at position x (0<=x<=L) has charge dq=lambda*dx, and lies a distance (L+d-x) from point P (which is at position L+d on the axis).

The field at P is E=the integral from 0 to L of k*lambda*dx/(L+d-x)^2. Substituting u=L+d-x (so du=-dx, with u=L+d when x=0 and u=d when x=L): E=k*lambda*the integral from d to L+d of du/u^2 = k*lambda*[1/d - 1/(L+d)] = k*lambda*L/[d*(L+d)].

(b) Substituting lambda=4.00e-9 C/m, L=0.600 m, d=0.200 m, and k=8.99e9 N*m^2/C^2: E=(8.99e9)(4.00e-9)(0.600)/[(0.200)(0.800)]=21.576/0.160≈135 N/C.' where id = '4a7130db-bc4a-4227-abab-e385fe24e9cf';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4a7130db-bc4a-4227-abab-e385fe24e9cf', 'canonical_answer_1', 1, '(a) A charge element at position x (0<=x<=L) has charge dq=lambda*dx, and lies a distance (L+d-x) from point P (which is at position L+d on the axis).', ARRAY['a-setup'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4a7130db-bc4a-4227-abab-e385fe24e9cf', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4a7130db-bc4a-4227-abab-e385fe24e9cf', 'canonical_answer_1', 3, 'The field at P is E=the integral from 0 to L of k*lambda*dx/(L+d-x)^2. Substituting u=L+d-x (so du=-dx, with u=L+d when x=0 and u=d when x=L): E=k*lambda*the integral from d to L+d of du/u^2 = k*lambda*[1/d - 1/(L+d)] = k*lambda*L/[d*(L+d)].', ARRAY['a-integration'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4a7130db-bc4a-4227-abab-e385fe24e9cf', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4a7130db-bc4a-4227-abab-e385fe24e9cf', 'canonical_answer_1', 5, '(b) Substituting lambda=4.00e-9 C/m, L=0.600 m, d=0.200 m, and k=8.99e9 N*m^2/C^2: E=(8.99e9)(4.00e-9)(0.600)/[(0.200)(0.800)]=21.576/0.160≈135 N/C.', ARRAY['b-numeric'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-048 (6e70379e-3033-4164-a855-b6d286c10630)
update app.content_item_versions set canonical_answer_1 = '(a) By Gauss''s law, the total flux through the sphere before the second charge is added equals the enclosed charge divided by epsilon0: Phi=Q_enc/epsilon0=(3.00e-9)/(8.85e-12)≈339 N*m^2/C. After the +7.00 nC charge is placed outside the sphere (at distance 2R from the center, so it is not enclosed), the total flux through the sphere remains unchanged at approximately 339 N*m^2/C.

The total flux through the sphere is unchanged after the external charge is added, since Gauss''s law depends only on the enclosed charge, which has not changed.

(b) Gauss''s law states that total flux through a closed surface depends only on the charge enclosed by that surface, regardless of any charges outside it. The external +7.00 nC charge does change the electric field at individual points on the sphere''s surface (since its field is present everywhere in space), but every field line from this external charge that enters the closed sphere must also exit it somewhere else (since the charge itself is not inside), so its net contribution to the total flux through the closed surface is exactly zero.' where id = '6e70379e-3033-4164-a855-b6d286c10630';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6e70379e-3033-4164-a855-b6d286c10630', 'canonical_answer_1', 1, '(a) By Gauss''s law, the total flux through the sphere before the second charge is added equals the enclosed charge divided by epsilon0: Phi=Q_enc/epsilon0=(3.00e-9)/(8.85e-12)≈339 N*m^2/C. After the +7.00 nC charge is placed outside the sphere (at distance 2R from the center, so it is not enclosed), the total flux through the sphere remains unchanged at approximately 339 N*m^2/C.', ARRAY['a-flux'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6e70379e-3033-4164-a855-b6d286c10630', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6e70379e-3033-4164-a855-b6d286c10630', 'canonical_answer_1', 3, 'The total flux through the sphere is unchanged after the external charge is added, since Gauss''s law depends only on the enclosed charge, which has not changed.', ARRAY['a-prediction'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6e70379e-3033-4164-a855-b6d286c10630', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6e70379e-3033-4164-a855-b6d286c10630', 'canonical_answer_1', 5, '(b) Gauss''s law states that total flux through a closed surface depends only on the charge enclosed by that surface, regardless of any charges outside it. The external +7.00 nC charge does change the electric field at individual points on the sphere''s surface (since its field is present everywhere in space), but every field line from this external charge that enters the closed sphere must also exit it somewhere else (since the charge itself is not inside), so its net contribution to the total flux through the closed surface is exactly zero.', ARRAY['b-explanation'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-049 (36bd0295-f15c-408f-a821-f503a43ff382)
update app.content_item_versions set canonical_answer_1 = '(a) Using a concentric spherical Gaussian surface of radius r<R, Gauss''s law states Phi_E=Q_enc/epsilon0.

The enclosed charge is Q_enc(r)=the integral from 0 to r of rho0*(r''/R)*4*pi*r''^2 dr''.

Evaluating this integral: Q_enc(r)=(4*pi*rho0/R)*(r^4/4)=pi*rho0*r^4/R.

Since Phi_E=E*(4*pi*r^2), solving gives E(r)=(pi*rho0*r^4/R)/(4*pi*epsilon0*r^2)=rho0*r^2/(4*epsilon0*R).

(b) At r=R/2=0.150 m, with rho0=6.00e-6 C/m^3 and R=0.300 m: E=(6.00e-6)*(0.150)^2/(4*(8.85e-12)*(0.300))=(6.00e-6)*(0.0225)/(1.062e-11)=1.35e-7/1.062e-11≈1.27e4 N/C.' where id = '36bd0295-f15c-408f-a821-f503a43ff382';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('36bd0295-f15c-408f-a821-f503a43ff382', 'canonical_answer_1', 1, '(a) Using a concentric spherical Gaussian surface of radius r<R, Gauss''s law states Phi_E=Q_enc/epsilon0.', ARRAY['a-gaussian-surface'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('36bd0295-f15c-408f-a821-f503a43ff382', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('36bd0295-f15c-408f-a821-f503a43ff382', 'canonical_answer_1', 3, 'The enclosed charge is Q_enc(r)=the integral from 0 to r of rho0*(r''/R)*4*pi*r''^2 dr''.', ARRAY['a-enclosed-integral'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('36bd0295-f15c-408f-a821-f503a43ff382', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('36bd0295-f15c-408f-a821-f503a43ff382', 'canonical_answer_1', 5, 'Evaluating this integral: Q_enc(r)=(4*pi*rho0/R)*(r^4/4)=pi*rho0*r^4/R.', ARRAY['a-integral-evaluation'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('36bd0295-f15c-408f-a821-f503a43ff382', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('36bd0295-f15c-408f-a821-f503a43ff382', 'canonical_answer_1', 7, 'Since Phi_E=E*(4*pi*r^2), solving gives E(r)=(pi*rho0*r^4/R)/(4*pi*epsilon0*r^2)=rho0*r^2/(4*epsilon0*R).', ARRAY['a-field-expression'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('36bd0295-f15c-408f-a821-f503a43ff382', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('36bd0295-f15c-408f-a821-f503a43ff382', 'canonical_answer_1', 9, '(b) At r=R/2=0.150 m, with rho0=6.00e-6 C/m^3 and R=0.300 m: E=(6.00e-6)*(0.150)^2/(4*(8.85e-12)*(0.300))=(6.00e-6)*(0.0225)/(1.062e-11)=1.35e-7/1.062e-11≈1.27e4 N/C.', ARRAY['b-numeric'], 'drafted', 'apphysicscem_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('b71c78c4-a9e7-442c-a174-8a591ef6bd66'::uuid),('af57088b-e96a-4965-af61-dfefe99d1f29'::uuid),('4a7130db-bc4a-4227-abab-e385fe24e9cf'::uuid),('6e70379e-3033-4164-a855-b6d286c10630'::uuid),('36bd0295-f15c-408f-a821-f503a43ff382'::uuid)) as t(vid)
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

-- apphycem-frq-050 (46109859-090c-49ad-8426-8e1daf060d19)
update app.content_item_versions set canonical_answer_1 = '(a) A charge element dq on the ring is a distance sqrt(z^2+a^2) from the axial point at height z, and its field contribution has magnitude k*dq/(z^2+a^2). By symmetry, the components of dE perpendicular to the axis cancel around the ring, leaving only the axial component: dE_z=k*dq*z/(z^2+a^2)^(3/2).

Integrating dq around the entire ring (a constant factor, since z and a do not depend on position around the ring) replaces the integral of dq with the total charge Q, giving E(z)=k*Q*z/(z^2+a^2)^(3/2).

At z=0.150 m, a=0.100 m, Q=5.00e-9 C, k=8.99e9: z^2+a^2=0.0225+0.0100=0.0325, and (0.0325)^(3/2)≈0.005863. So E=(8.99e9)(5.00e-9)(0.150)/0.005863=6.7425/0.005863≈1.15e3 N/C.

(b) If the ring''s radius is doubled to 0.200 m (a increases) while z=0.150 m and Q stay fixed, E(z) decreases.

This is because the denominator (z^2+a^2)^(3/2) increases as a increases (a larger a^2 makes the sum larger), while the numerator k*Q*z has no dependence on a and stays exactly the same -- so the overall fraction, and hence E(z), must decrease.' where id = '46109859-090c-49ad-8426-8e1daf060d19';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('46109859-090c-49ad-8426-8e1daf060d19', 'canonical_answer_1', 1, '(a) A charge element dq on the ring is a distance sqrt(z^2+a^2) from the axial point at height z, and its field contribution has magnitude k*dq/(z^2+a^2). By symmetry, the components of dE perpendicular to the axis cancel around the ring, leaving only the axial component: dE_z=k*dq*z/(z^2+a^2)^(3/2).', ARRAY['a-integral-setup'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('46109859-090c-49ad-8426-8e1daf060d19', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('46109859-090c-49ad-8426-8e1daf060d19', 'canonical_answer_1', 3, 'Integrating dq around the entire ring (a constant factor, since z and a do not depend on position around the ring) replaces the integral of dq with the total charge Q, giving E(z)=k*Q*z/(z^2+a^2)^(3/2).', ARRAY['a-derivation'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('46109859-090c-49ad-8426-8e1daf060d19', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('46109859-090c-49ad-8426-8e1daf060d19', 'canonical_answer_1', 5, 'At z=0.150 m, a=0.100 m, Q=5.00e-9 C, k=8.99e9: z^2+a^2=0.0225+0.0100=0.0325, and (0.0325)^(3/2)≈0.005863. So E=(8.99e9)(5.00e-9)(0.150)/0.005863=6.7425/0.005863≈1.15e3 N/C.', ARRAY['a-numeric'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('46109859-090c-49ad-8426-8e1daf060d19', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('46109859-090c-49ad-8426-8e1daf060d19', 'canonical_answer_1', 7, '(b) If the ring''s radius is doubled to 0.200 m (a increases) while z=0.150 m and Q stay fixed, E(z) decreases.', ARRAY['b-prediction'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('46109859-090c-49ad-8426-8e1daf060d19', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('46109859-090c-49ad-8426-8e1daf060d19', 'canonical_answer_1', 9, 'This is because the denominator (z^2+a^2)^(3/2) increases as a increases (a larger a^2 makes the sum larger), while the numerator k*Q*z has no dependence on a and stays exactly the same -- so the overall fraction, and hence E(z), must decrease.', ARRAY['b-justification'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-051 (47ee5fb8-949f-4ae8-aba1-ab5999ab7945)
update app.content_item_versions set canonical_answer_1 = '(a) The linear charge density is lambda=Q/L=(8.00e-9 C)/(0.800 m)=1.00e-8 C/m.

Placing the rod along the x-axis from -L/2 to L/2 with P on the perpendicular bisector at distance y, a charge element dq=lambda*dx at position x is a distance sqrt(x^2+y^2) from P, so dV=k*lambda*dx/sqrt(x^2+y^2), integrated from x=-L/2 to x=L/2.

This integral evaluates using the standard antiderivative involving the inverse hyperbolic sine (equivalently a logarithmic form): the integral of dx/sqrt(x^2+y^2) is sinh^-1(x/y) (or ln(x+sqrt(x^2+y^2))).

By symmetry, combining the limits at +L/2 and -L/2 gives V=2*k*lambda*sinh^-1(L/(2*y)).

(b) With lambda=1.00e-8 C/m, L=0.800 m, y=0.300 m, k=8.99e9: L/(2y)=0.800/0.600=1.333. sinh^-1(1.333)=ln(1.333+sqrt(1.333^2+1))=ln(1.333+1.667)=ln(3.00)=1.0986. So V=2*(8.99e9)*(1.00e-8)*(1.0986)=2*89.9*1.0986≈198 V.' where id = '47ee5fb8-949f-4ae8-aba1-ab5999ab7945';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('47ee5fb8-949f-4ae8-aba1-ab5999ab7945', 'canonical_answer_1', 1, '(a) The linear charge density is lambda=Q/L=(8.00e-9 C)/(0.800 m)=1.00e-8 C/m.', ARRAY['a-lambda'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('47ee5fb8-949f-4ae8-aba1-ab5999ab7945', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('47ee5fb8-949f-4ae8-aba1-ab5999ab7945', 'canonical_answer_1', 3, 'Placing the rod along the x-axis from -L/2 to L/2 with P on the perpendicular bisector at distance y, a charge element dq=lambda*dx at position x is a distance sqrt(x^2+y^2) from P, so dV=k*lambda*dx/sqrt(x^2+y^2), integrated from x=-L/2 to x=L/2.', ARRAY['a-setup'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('47ee5fb8-949f-4ae8-aba1-ab5999ab7945', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('47ee5fb8-949f-4ae8-aba1-ab5999ab7945', 'canonical_answer_1', 5, 'This integral evaluates using the standard antiderivative involving the inverse hyperbolic sine (equivalently a logarithmic form): the integral of dx/sqrt(x^2+y^2) is sinh^-1(x/y) (or ln(x+sqrt(x^2+y^2))).', ARRAY['a-integration'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('47ee5fb8-949f-4ae8-aba1-ab5999ab7945', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('47ee5fb8-949f-4ae8-aba1-ab5999ab7945', 'canonical_answer_1', 7, 'By symmetry, combining the limits at +L/2 and -L/2 gives V=2*k*lambda*sinh^-1(L/(2*y)).', ARRAY['a-final-expression'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('47ee5fb8-949f-4ae8-aba1-ab5999ab7945', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('47ee5fb8-949f-4ae8-aba1-ab5999ab7945', 'canonical_answer_1', 9, '(b) With lambda=1.00e-8 C/m, L=0.800 m, y=0.300 m, k=8.99e9: L/(2y)=0.800/0.600=1.333. sinh^-1(1.333)=ln(1.333+sqrt(1.333^2+1))=ln(1.333+1.667)=ln(3.00)=1.0986. So V=2*(8.99e9)*(1.00e-8)*(1.0986)=2*89.9*1.0986≈198 V.', ARRAY['b-numeric'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-053 (a7c8366f-efe2-4043-acd9-78b00913beb7)
update app.content_item_versions set canonical_answer_1 = '(a) The final charge on the capacitor, once fully charged to the battery''s emf, is Qf=C*(EMF)=(2.00e-6 F)*(9.00 V)=18.0 microC.

The stored energy is found from U=the integral from 0 to Qf of (q/C) dq, since the voltage across the capacitor at charge q is q/C, and dU=(q/C)dq is the incremental work needed to add charge dq against that voltage.

Evaluating this integral: U=[q^2/(2C)] from 0 to Qf = Qf^2/(2C)=(18.0e-6)^2/(2*2.00e-6)=3.24e-10/4.00e-6≈81.0 microJ.

(b) The total energy delivered by the battery during charging is W=EMF*Qf=(9.00 V)*(18.0e-6 C)=162 microJ, since the battery moves the full charge Qf through a constant potential difference equal to its emf.

This total (162 microJ) is not equal to the energy stored on the capacitor (81.0 microJ) because, as the capacitor charges, the resistor is carrying current while there is a voltage drop across it, so the resistor continuously dissipates energy as heat throughout the charging process. The difference between the battery''s total energy output and the capacitor''s final stored energy, approximately 81.0 microJ, is exactly the energy dissipated as heat in the resistor during charging.' where id = 'a7c8366f-efe2-4043-acd9-78b00913beb7';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a7c8366f-efe2-4043-acd9-78b00913beb7', 'canonical_answer_1', 1, '(a) The final charge on the capacitor, once fully charged to the battery''s emf, is Qf=C*(EMF)=(2.00e-6 F)*(9.00 V)=18.0 microC.', ARRAY['a-charge'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a7c8366f-efe2-4043-acd9-78b00913beb7', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a7c8366f-efe2-4043-acd9-78b00913beb7', 'canonical_answer_1', 3, 'The stored energy is found from U=the integral from 0 to Qf of (q/C) dq, since the voltage across the capacitor at charge q is q/C, and dU=(q/C)dq is the incremental work needed to add charge dq against that voltage.', ARRAY['a-integral-setup'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a7c8366f-efe2-4043-acd9-78b00913beb7', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a7c8366f-efe2-4043-acd9-78b00913beb7', 'canonical_answer_1', 5, 'Evaluating this integral: U=[q^2/(2C)] from 0 to Qf = Qf^2/(2C)=(18.0e-6)^2/(2*2.00e-6)=3.24e-10/4.00e-6≈81.0 microJ.', ARRAY['a-integral-evaluation'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a7c8366f-efe2-4043-acd9-78b00913beb7', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a7c8366f-efe2-4043-acd9-78b00913beb7', 'canonical_answer_1', 7, '(b) The total energy delivered by the battery during charging is W=EMF*Qf=(9.00 V)*(18.0e-6 C)=162 microJ, since the battery moves the full charge Qf through a constant potential difference equal to its emf.', ARRAY['b-battery-energy'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a7c8366f-efe2-4043-acd9-78b00913beb7', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a7c8366f-efe2-4043-acd9-78b00913beb7', 'canonical_answer_1', 9, 'This total (162 microJ) is not equal to the energy stored on the capacitor (81.0 microJ) because, as the capacitor charges, the resistor is carrying current while there is a voltage drop across it, so the resistor continuously dissipates energy as heat throughout the charging process. The difference between the battery''s total energy output and the capacitor''s final stored energy, approximately 81.0 microJ, is exactly the energy dissipated as heat in the resistor during charging.', ARRAY['b-explanation'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-056 (4d1c80b6-f54f-4613-a860-5d956e6dfb96)
update app.content_item_versions set canonical_answer_1 = '(a) Using a spherical Gaussian surface of radius r<R, Gauss''s law gives Phi_E=Q_enc(r)/epsilon0.

The enclosed charge is Q_enc(r)=the integral from 0 to r of rho0*(1-r''/R)*4*pi*r''^2 dr'' = 4*pi*rho0*[the integral from 0 to r of (r''^2-r''^3/R) dr''] = 4*pi*rho0*[r^3/3-r^4/(4R)].

Since Phi_E=E*(4*pi*r^2)=Q_enc(r)/epsilon0, solving gives E(r)=(rho0/epsilon0)*(r/3-r^2/(4R)) for r<R.

(b) The total charge on the sphere is Q_total=Q_enc(R)=4*pi*rho0*[R^3/3-R^3/4]=4*pi*rho0*R^3*(1/3-1/4)=4*pi*rho0*R^3*(1/12)=pi*rho0*R^3/3.

For r>R, all the charge Q_total is enclosed, so E(r)=k*Q_total/r^2=Q_total/(4*pi*epsilon0*r^2)=(pi*rho0*R^3/3)/(4*pi*epsilon0*r^2)=rho0*R^3/(12*epsilon0*r^2).

(c) At r=R/2=0.125 m, with rho0=6.00e-6 C/m^3 and R=0.250 m: E=(rho0/epsilon0)*(r/3-r^2/(4R))=(6.00e-6/8.85e-12)*(0.125/3-(0.125)^2/(4*0.250))=6.7797e5*(0.04167-0.015625)=6.7797e5*0.026042≈1.77e4 N/C.

At r=2R=0.500 m: E=rho0*R^3/(12*epsilon0*r^2)=(6.00e-6)*(0.250)^3/(12*(8.85e-12)*(0.500)^2)=(6.00e-6)*(0.015625)/(12*8.85e-12*0.250)=9.375e-8/(2.655e-11)≈3.53e3 N/C.' where id = '4d1c80b6-f54f-4613-a860-5d956e6dfb96';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 1, '(a) Using a spherical Gaussian surface of radius r<R, Gauss''s law gives Phi_E=Q_enc(r)/epsilon0.', ARRAY['a-gaussian-setup'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 3, 'The enclosed charge is Q_enc(r)=the integral from 0 to r of rho0*(1-r''/R)*4*pi*r''^2 dr'' = 4*pi*rho0*[the integral from 0 to r of (r''^2-r''^3/R) dr''] = 4*pi*rho0*[r^3/3-r^4/(4R)].', ARRAY['a-enclosed-integral'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 5, 'Since Phi_E=E*(4*pi*r^2)=Q_enc(r)/epsilon0, solving gives E(r)=(rho0/epsilon0)*(r/3-r^2/(4R)) for r<R.', ARRAY['a-field-expression'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 7, '(b) The total charge on the sphere is Q_total=Q_enc(R)=4*pi*rho0*[R^3/3-R^3/4]=4*pi*rho0*R^3*(1/3-1/4)=4*pi*rho0*R^3*(1/12)=pi*rho0*R^3/3.', ARRAY['b-total-charge'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 9, 'For r>R, all the charge Q_total is enclosed, so E(r)=k*Q_total/r^2=Q_total/(4*pi*epsilon0*r^2)=(pi*rho0*R^3/3)/(4*pi*epsilon0*r^2)=rho0*R^3/(12*epsilon0*r^2).', ARRAY['b-field-expression'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 11, '(c) At r=R/2=0.125 m, with rho0=6.00e-6 C/m^3 and R=0.250 m: E=(rho0/epsilon0)*(r/3-r^2/(4R))=(6.00e-6/8.85e-12)*(0.125/3-(0.125)^2/(4*0.250))=6.7797e5*(0.04167-0.015625)=6.7797e5*0.026042≈1.77e4 N/C.', ARRAY['c-numeric-inside'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4d1c80b6-f54f-4613-a860-5d956e6dfb96', 'canonical_answer_1', 13, 'At r=2R=0.500 m: E=rho0*R^3/(12*epsilon0*r^2)=(6.00e-6)*(0.250)^3/(12*(8.85e-12)*(0.500)^2)=(6.00e-6)*(0.015625)/(12*8.85e-12*0.250)=9.375e-8/(2.655e-11)≈3.53e3 N/C.', ARRAY['c-numeric-outside'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-np1-001 (44478991-915a-4e3e-b521-b2ae3b310558)
update app.content_item_versions set canonical_answer_1 = '(a) Gauss''s law states that the closed-surface integral of E dot dA equals Q_enc/epsilon0.

For a long charged cylinder, the appropriate Gaussian surface is a coaxial cylinder of radius r and length L; by symmetry the field is radial and constant in magnitude on the curved lateral surface, whose area is 2*pi*r*L (the flat end caps contribute no flux since E there is parallel to them, not through them).

For r<R, the enclosed charge is the volume charge density times the enclosed volume: Q_enc=rho*pi*r^2*L, using the Gaussian radius r (not the cylinder''s full radius R, since only the charge within radius r is enclosed).

Applying Gauss''s law: E*(2*pi*r*L)=rho*pi*r^2*L/epsilon0, so E(r)=rho*r/(2*epsilon0) for r<R.

(b) For r>R, the entire cylinder''s charge per unit length is enclosed, so Q_enc=rho*pi*R^2*L, using the cylinder''s full radius R since all the charge is now inside the Gaussian surface.

Applying Gauss''s law: E*(2*pi*r*L)=rho*pi*R^2*L/epsilon0, so E(r)=rho*R^2/(2*epsilon0*r) for r>R.' where id = '44478991-915a-4e3e-b521-b2ae3b310558';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 1, '(a) Gauss''s law states that the closed-surface integral of E dot dA equals Q_enc/epsilon0.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 3, 'For a long charged cylinder, the appropriate Gaussian surface is a coaxial cylinder of radius r and length L; by symmetry the field is radial and constant in magnitude on the curved lateral surface, whose area is 2*pi*r*L (the flat end caps contribute no flux since E there is parallel to them, not through them).', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 5, 'For r<R, the enclosed charge is the volume charge density times the enclosed volume: Q_enc=rho*pi*r^2*L, using the Gaussian radius r (not the cylinder''s full radius R, since only the charge within radius r is enclosed).', ARRAY['part-a-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 7, 'Applying Gauss''s law: E*(2*pi*r*L)=rho*pi*r^2*L/epsilon0, so E(r)=rho*r/(2*epsilon0) for r<R.', ARRAY['part-a-criterion-04'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 9, '(b) For r>R, the entire cylinder''s charge per unit length is enclosed, so Q_enc=rho*pi*R^2*L, using the cylinder''s full radius R since all the charge is now inside the Gaussian surface.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('44478991-915a-4e3e-b521-b2ae3b310558', 'canonical_answer_1', 11, 'Applying Gauss''s law: E*(2*pi*r*L)=rho*pi*R^2*L/epsilon0, so E(r)=rho*R^2/(2*epsilon0*r) for r>R.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('46109859-090c-49ad-8426-8e1daf060d19'::uuid),('47ee5fb8-949f-4ae8-aba1-ab5999ab7945'::uuid),('a7c8366f-efe2-4043-acd9-78b00913beb7'::uuid),('4d1c80b6-f54f-4613-a860-5d956e6dfb96'::uuid),('44478991-915a-4e3e-b521-b2ae3b310558'::uuid)) as t(vid)
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

-- apphycem-frq-np1-002 (e1f73980-bc95-4cea-a735-17044be6c987)
update app.content_item_versions set canonical_answer_1 = '(a) Gauss''s law states that the closed-surface integral of E dot dA equals Q_enc/epsilon0.

For this system of concentric spherical shells, the appropriate Gaussian surface is a concentric sphere of radius r, with surface area 4*pi*r^2; spherical symmetry guarantees the field is purely radial and has the same constant magnitude at every point on this surface, which is what allows E to be pulled out of the flux integral.

For a<r<b, only the inner shell (carrying +Q) is enclosed by the Gaussian surface; the outer shell (carrying -Q, at radius b) is not enclosed since r<b.

Applying Gauss''s law: E*(4*pi*r^2)=Q/epsilon0, so E(r)=Q/(4*pi*epsilon0*r^2), directed radially outward.

(b) The potential difference is found from V(a)-V(b)=the definite integral from a to b of E(r) dr, using the E(r) found in part (a).

Evaluating this integral: V(a)-V(b)=the integral from a to b of [Q/(4*pi*epsilon0*r^2)] dr = [Q/(4*pi*epsilon0)]*[-1/r] from a to b = [Q/(4*pi*epsilon0)]*(1/a-1/b).' where id = 'e1f73980-bc95-4cea-a735-17044be6c987';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 1, '(a) Gauss''s law states that the closed-surface integral of E dot dA equals Q_enc/epsilon0.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 3, 'For this system of concentric spherical shells, the appropriate Gaussian surface is a concentric sphere of radius r, with surface area 4*pi*r^2; spherical symmetry guarantees the field is purely radial and has the same constant magnitude at every point on this surface, which is what allows E to be pulled out of the flux integral.', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 5, 'For a<r<b, only the inner shell (carrying +Q) is enclosed by the Gaussian surface; the outer shell (carrying -Q, at radius b) is not enclosed since r<b.', ARRAY['part-a-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 7, 'Applying Gauss''s law: E*(4*pi*r^2)=Q/epsilon0, so E(r)=Q/(4*pi*epsilon0*r^2), directed radially outward.', ARRAY['part-a-criterion-04'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 9, '(b) The potential difference is found from V(a)-V(b)=the definite integral from a to b of E(r) dr, using the E(r) found in part (a).', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('e1f73980-bc95-4cea-a735-17044be6c987', 'canonical_answer_1', 11, 'Evaluating this integral: V(a)-V(b)=the integral from a to b of [Q/(4*pi*epsilon0*r^2)] dr = [Q/(4*pi*epsilon0)]*[-1/r] from a to b = [Q/(4*pi*epsilon0)]*(1/a-1/b).', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-np1-003 (599dcf66-fca5-4c7d-b46b-eebdaab9316a)
update app.content_item_versions set canonical_answer_1 = '(a) A charge element dq on the ring is a distance sqrt(x^2+R^2) from the axial point at distance x, so its field contribution has magnitude dE=k*dq/(x^2+R^2).

By symmetry, the components of dE perpendicular to the axis cancel around the ring, leaving only the axial component, which is dE times the cosine of the angle between dE and the axis, i.e. times the factor x/sqrt(x^2+R^2): dE_x=k*x*dq/(x^2+R^2)^(3/2).

Integrating dq around the entire ring (a constant factor, since x and R do not depend on position around the ring) replaces the integral of dq with the total charge Q, giving the final result E(x)=k*Q*x/(x^2+R^2)^(3/2).

(b) To find where E(x) is maximum, set dE/dx=0 and solve: differentiating E(x)=k*Q*x*(x^2+R^2)^(-3/2) using the product rule gives dE/dx=k*Q*[(x^2+R^2)^(-3/2) + x*(-3/2)*(x^2+R^2)^(-5/2)*2x] = k*Q*(x^2+R^2)^(-5/2)*[(x^2+R^2)-3*x^2] = k*Q*(x^2+R^2)^(-5/2)*[R^2-2*x^2]. Setting R^2-2*x^2=0 and solving for x (treating x as nonnegative).

This gives x=R/sqrt(2). This is confirmed as a maximum (not a minimum) because E(0)=0, E(x) approaches 0 again as x approaches infinity, and E(x) is positive for all x>0 -- so E must rise from 0, reach a single maximum, and fall back toward 0, and the sign of dE/dx (positive for x<R/sqrt(2), negative for x>R/sqrt(2), from the factor R^2-2*x^2 changing sign there) confirms this critical point is where E transitions from increasing to decreasing, i.e. a maximum.' where id = '599dcf66-fca5-4c7d-b46b-eebdaab9316a';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('599dcf66-fca5-4c7d-b46b-eebdaab9316a', 'canonical_answer_1', 1, '(a) A charge element dq on the ring is a distance sqrt(x^2+R^2) from the axial point at distance x, so its field contribution has magnitude dE=k*dq/(x^2+R^2).', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('599dcf66-fca5-4c7d-b46b-eebdaab9316a', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('599dcf66-fca5-4c7d-b46b-eebdaab9316a', 'canonical_answer_1', 3, 'By symmetry, the components of dE perpendicular to the axis cancel around the ring, leaving only the axial component, which is dE times the cosine of the angle between dE and the axis, i.e. times the factor x/sqrt(x^2+R^2): dE_x=k*x*dq/(x^2+R^2)^(3/2).', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('599dcf66-fca5-4c7d-b46b-eebdaab9316a', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('599dcf66-fca5-4c7d-b46b-eebdaab9316a', 'canonical_answer_1', 5, 'Integrating dq around the entire ring (a constant factor, since x and R do not depend on position around the ring) replaces the integral of dq with the total charge Q, giving the final result E(x)=k*Q*x/(x^2+R^2)^(3/2).', ARRAY['part-a-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('599dcf66-fca5-4c7d-b46b-eebdaab9316a', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('599dcf66-fca5-4c7d-b46b-eebdaab9316a', 'canonical_answer_1', 7, '(b) To find where E(x) is maximum, set dE/dx=0 and solve: differentiating E(x)=k*Q*x*(x^2+R^2)^(-3/2) using the product rule gives dE/dx=k*Q*[(x^2+R^2)^(-3/2) + x*(-3/2)*(x^2+R^2)^(-5/2)*2x] = k*Q*(x^2+R^2)^(-5/2)*[(x^2+R^2)-3*x^2] = k*Q*(x^2+R^2)^(-5/2)*[R^2-2*x^2]. Setting R^2-2*x^2=0 and solving for x (treating x as nonnegative).', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('599dcf66-fca5-4c7d-b46b-eebdaab9316a', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('599dcf66-fca5-4c7d-b46b-eebdaab9316a', 'canonical_answer_1', 9, 'This gives x=R/sqrt(2). This is confirmed as a maximum (not a minimum) because E(0)=0, E(x) approaches 0 again as x approaches infinity, and E(x) is positive for all x>0 -- so E must rise from 0, reach a single maximum, and fall back toward 0, and the sign of dE/dx (positive for x<R/sqrt(2), negative for x>R/sqrt(2), from the factor R^2-2*x^2 changing sign there) confirms this critical point is where E transitions from increasing to decreasing, i.e. a maximum.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-np1-004 (57aeed25-7535-4055-b1a6-45bb9d51b505)
update app.content_item_versions set canonical_answer_1 = '(a) Unlike the field calculation, potential is a scalar, so no direction/component argument is needed: every charge element on the ring is the same distance sqrt(x^2+R^2) from the axial point, so V=k*the integral of dq/sqrt(x^2+R^2), with the distance factor pulled outside the integral since it is the same for every element.

Integrating dq around the entire ring simply gives the total charge Q, so V(x)=k*Q/sqrt(x^2+R^2).

(b) Differentiating V(x)=k*Q*(x^2+R^2)^(-1/2) with respect to x: dV/dx=k*Q*(-1/2)*(x^2+R^2)^(-3/2)*(2x)=-k*Q*x*(x^2+R^2)^(-3/2).

So E_x=-dV/dx=k*Q*x/(x^2+R^2)^(3/2), which exactly matches the expression obtained by the direct field-derivation (integrating dE_x around the ring), confirming both methods agree.

(c) With R=0.2 m and Q=5 nC: V(0)=k*Q/R=(8.99e9)(5e-9)/(0.2)=44.95/0.2=224.750 V.

V(0.3)=k*Q/sqrt((0.3)^2+(0.2)^2)=44.95/sqrt(0.09+0.04)=44.95/sqrt(0.13)=44.95/0.36056=124.680 V.' where id = '57aeed25-7535-4055-b1a6-45bb9d51b505';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 1, '(a) Unlike the field calculation, potential is a scalar, so no direction/component argument is needed: every charge element on the ring is the same distance sqrt(x^2+R^2) from the axial point, so V=k*the integral of dq/sqrt(x^2+R^2), with the distance factor pulled outside the integral since it is the same for every element.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 3, 'Integrating dq around the entire ring simply gives the total charge Q, so V(x)=k*Q/sqrt(x^2+R^2).', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 5, '(b) Differentiating V(x)=k*Q*(x^2+R^2)^(-1/2) with respect to x: dV/dx=k*Q*(-1/2)*(x^2+R^2)^(-3/2)*(2x)=-k*Q*x*(x^2+R^2)^(-3/2).', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 7, 'So E_x=-dV/dx=k*Q*x/(x^2+R^2)^(3/2), which exactly matches the expression obtained by the direct field-derivation (integrating dE_x around the ring), confirming both methods agree.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 9, '(c) With R=0.2 m and Q=5 nC: V(0)=k*Q/R=(8.99e9)(5e-9)/(0.2)=44.95/0.2=224.750 V.', ARRAY['part-c-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('57aeed25-7535-4055-b1a6-45bb9d51b505', 'canonical_answer_1', 11, 'V(0.3)=k*Q/sqrt((0.3)^2+(0.2)^2)=44.95/sqrt(0.09+0.04)=44.95/sqrt(0.13)=44.95/0.36056=124.680 V.', ARRAY['part-c-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-np1-005 (f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51)
update app.content_item_versions set canonical_answer_1 = '(a) Once electrostatic equilibrium is reached, the electric field inside the conducting sphere is exactly zero, as is true for any conductor in electrostatic equilibrium.

(b) The induced charge redistributes non-uniformly on the sphere''s surface: relative to the sphere''s own uniformly distributed net charge +Q, an additional negative surface-charge component is induced on the -x side (facing where the external field points from) and an additional positive component is induced on the +x side (facing where the external field points to), superposed on the sphere''s uniform +Q distribution -- note that the -x side may still carry a net positive charge overall if Q is large enough; only the induced component there is negative.

This redistribution is required because a conductor in electrostatic equilibrium must be an equipotential surface (constant potential everywhere on and inside it) with zero field in its interior. If the surface charge were instead left uniform in the presence of the external field E0, there would be a nonzero field component tangent to the surface, which would push surface charges to keep moving until they redistribute into exactly the configuration that cancels the tangential field and produces a zero interior field -- which is the equilibrium configuration described above.

(c) Once the sphere is connected to the ground by a conducting wire, its electric potential becomes zero, matching the potential of the ground (which acts as an effectively infinite reservoir of charge, conventionally taken to be at zero potential).

To reach this new equilibrium, charge flows between the sphere and the ground (through the wire) until the sphere''s potential drops to zero; this changes the sphere''s net charge away from its original value of +Q, but the final net charge is not uniquely determined without knowing the specific external field configuration and the sphere''s geometry relative to it.' where id = 'f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51', 'canonical_answer_1', 1, '(a) Once electrostatic equilibrium is reached, the electric field inside the conducting sphere is exactly zero, as is true for any conductor in electrostatic equilibrium.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51', 'canonical_answer_1', 3, '(b) The induced charge redistributes non-uniformly on the sphere''s surface: relative to the sphere''s own uniformly distributed net charge +Q, an additional negative surface-charge component is induced on the -x side (facing where the external field points from) and an additional positive component is induced on the +x side (facing where the external field points to), superposed on the sphere''s uniform +Q distribution -- note that the -x side may still carry a net positive charge overall if Q is large enough; only the induced component there is negative.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51', 'canonical_answer_1', 5, 'This redistribution is required because a conductor in electrostatic equilibrium must be an equipotential surface (constant potential everywhere on and inside it) with zero field in its interior. If the surface charge were instead left uniform in the presence of the external field E0, there would be a nonzero field component tangent to the surface, which would push surface charges to keep moving until they redistribute into exactly the configuration that cancels the tangential field and produces a zero interior field -- which is the equilibrium configuration described above.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51', 'canonical_answer_1', 7, '(c) Once the sphere is connected to the ground by a conducting wire, its electric potential becomes zero, matching the potential of the ground (which acts as an effectively infinite reservoir of charge, conventionally taken to be at zero potential).', ARRAY['part-c-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51', 'canonical_answer_1', 9, 'To reach this new equilibrium, charge flows between the sphere and the ground (through the wire) until the sphere''s potential drops to zero; this changes the sphere''s net charge away from its original value of +Q, but the final net charge is not uniquely determined without knowing the specific external field configuration and the sphere''s geometry relative to it.', ARRAY['part-c-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('e1f73980-bc95-4cea-a735-17044be6c987'::uuid),('599dcf66-fca5-4c7d-b46b-eebdaab9316a'::uuid),('57aeed25-7535-4055-b1a6-45bb9d51b505'::uuid),('f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51'::uuid)) as t(vid)
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

-- apphycem-frq-np1-006 (adc049a4-2cdc-4c8b-8304-899b54cca5c8)
update app.content_item_versions set canonical_answer_1 = '(a) The three pairwise distances are: r12 (between q1 at the origin and q2 at (0.3,0)) = 0.3 m; r13 (between q1 and q3 at (0,0.4)) = 0.4 m; and r23 (between q2 and q3), found via the Pythagorean theorem since q2 and q3 form a right angle with the origin, as sqrt(0.3^2+0.4^2)=sqrt(0.09+0.16)=sqrt(0.25)=0.5 m.

The total electric potential energy is the sum of the three pairwise interaction energies: U=k*q1*q2/r12 + k*q1*q3/r13 + k*q2*q3/r23.

Substituting values (q1=2e-6 C, q2=-3e-6 C, q3=4e-6 C, k=8.99e9): U=8.99e9*[(2e-6)(-3e-6)/0.3 + (2e-6)(4e-6)/0.4 + (-3e-6)(4e-6)/0.5] = 8.99e9*[-2.00e-11 + 2.00e-11 - 2.40e-11] = 8.99e9*(-2.40e-11) ≈ -0.216 J.

(b) The potential at the origin due to q2 and q3 is the scalar sum of each charge''s individual contribution: V=k*q2/r12 + k*q3/r13, using the distances from the origin to each charge (0.3 m to q2, 0.4 m to q3).

Substituting values: V=8.99e9*[(-3e-6)/0.3 + (4e-6)/0.4] = 8.99e9*[-1.00e-5 + 1.00e-5] = 8.99e9*0 = 0 V.' where id = 'adc049a4-2cdc-4c8b-8304-899b54cca5c8';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('adc049a4-2cdc-4c8b-8304-899b54cca5c8', 'canonical_answer_1', 1, '(a) The three pairwise distances are: r12 (between q1 at the origin and q2 at (0.3,0)) = 0.3 m; r13 (between q1 and q3 at (0,0.4)) = 0.4 m; and r23 (between q2 and q3), found via the Pythagorean theorem since q2 and q3 form a right angle with the origin, as sqrt(0.3^2+0.4^2)=sqrt(0.09+0.16)=sqrt(0.25)=0.5 m.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('adc049a4-2cdc-4c8b-8304-899b54cca5c8', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('adc049a4-2cdc-4c8b-8304-899b54cca5c8', 'canonical_answer_1', 3, 'The total electric potential energy is the sum of the three pairwise interaction energies: U=k*q1*q2/r12 + k*q1*q3/r13 + k*q2*q3/r23.', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('adc049a4-2cdc-4c8b-8304-899b54cca5c8', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('adc049a4-2cdc-4c8b-8304-899b54cca5c8', 'canonical_answer_1', 5, 'Substituting values (q1=2e-6 C, q2=-3e-6 C, q3=4e-6 C, k=8.99e9): U=8.99e9*[(2e-6)(-3e-6)/0.3 + (2e-6)(4e-6)/0.4 + (-3e-6)(4e-6)/0.5] = 8.99e9*[-2.00e-11 + 2.00e-11 - 2.40e-11] = 8.99e9*(-2.40e-11) ≈ -0.216 J.', ARRAY['part-a-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('adc049a4-2cdc-4c8b-8304-899b54cca5c8', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('adc049a4-2cdc-4c8b-8304-899b54cca5c8', 'canonical_answer_1', 7, '(b) The potential at the origin due to q2 and q3 is the scalar sum of each charge''s individual contribution: V=k*q2/r12 + k*q3/r13, using the distances from the origin to each charge (0.3 m to q2, 0.4 m to q3).', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('adc049a4-2cdc-4c8b-8304-899b54cca5c8', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('adc049a4-2cdc-4c8b-8304-899b54cca5c8', 'canonical_answer_1', 9, 'Substituting values: V=8.99e9*[(-3e-6)/0.3 + (4e-6)/0.4] = 8.99e9*[-1.00e-5 + 1.00e-5] = 8.99e9*0 = 0 V.', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-np1-007 (045ec2b1-e801-4b01-994f-8c4f49d6e65a)
update app.content_item_versions set canonical_answer_1 = '(a) By Gauss''s law, the total flux through any closed surface enclosing charge Q is Q/epsilon0, regardless of the surface''s shape or size -- so the total flux through the cube (which encloses the point charge at its center) is Q/epsilon0.

(b) The flux through one face of the cube is Q/(6*epsilon0).

This follows because the charge sits at the exact center of the cube, so all six faces are geometrically equivalent to each other by symmetry (each is the same distance and orientation relative to the charge, just rotated); since the total flux Q/epsilon0 must be shared identically among six indistinguishable faces, each face receives exactly one sixth of the total: Q/(6*epsilon0).

(c) When the same charge +Q is instead at a shared corner, with eight identical cubes arranged symmetrically around that corner to completely surround the charge, the total flux Q/epsilon0 is now divided evenly among all eight cubes by the same symmetry argument as before (each cube meets the corner identically).

So the flux through the original cube in this new arrangement is Q/(8*epsilon0).' where id = '045ec2b1-e801-4b01-994f-8c4f49d6e65a';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('045ec2b1-e801-4b01-994f-8c4f49d6e65a', 'canonical_answer_1', 1, '(a) By Gauss''s law, the total flux through any closed surface enclosing charge Q is Q/epsilon0, regardless of the surface''s shape or size -- so the total flux through the cube (which encloses the point charge at its center) is Q/epsilon0.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('045ec2b1-e801-4b01-994f-8c4f49d6e65a', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('045ec2b1-e801-4b01-994f-8c4f49d6e65a', 'canonical_answer_1', 3, '(b) The flux through one face of the cube is Q/(6*epsilon0).', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('045ec2b1-e801-4b01-994f-8c4f49d6e65a', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('045ec2b1-e801-4b01-994f-8c4f49d6e65a', 'canonical_answer_1', 5, 'This follows because the charge sits at the exact center of the cube, so all six faces are geometrically equivalent to each other by symmetry (each is the same distance and orientation relative to the charge, just rotated); since the total flux Q/epsilon0 must be shared identically among six indistinguishable faces, each face receives exactly one sixth of the total: Q/(6*epsilon0).', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('045ec2b1-e801-4b01-994f-8c4f49d6e65a', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('045ec2b1-e801-4b01-994f-8c4f49d6e65a', 'canonical_answer_1', 7, '(c) When the same charge +Q is instead at a shared corner, with eight identical cubes arranged symmetrically around that corner to completely surround the charge, the total flux Q/epsilon0 is now divided evenly among all eight cubes by the same symmetry argument as before (each cube meets the corner identically).', ARRAY['part-c-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('045ec2b1-e801-4b01-994f-8c4f49d6e65a', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('045ec2b1-e801-4b01-994f-8c4f49d6e65a', 'canonical_answer_1', 9, 'So the flux through the original cube in this new arrangement is Q/(8*epsilon0).', ARRAY['part-c-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-np1-009 (b61b7a99-36e0-451d-93ce-f99503c2504d)
update app.content_item_versions set canonical_answer_1 = '(a) Without the dielectric, applying Gauss''s law with a coaxial cylindrical Gaussian surface of radius r (a<r<b) and length L gives E0*(2*pi*r*L)=Q/epsilon0, so E0(r)=Q/(2*pi*epsilon0*r*L).

Filling the region between the shells with a dielectric of constant kappa reduces the field by a factor of kappa: E(r)=E0(r)/kappa=Q/(2*pi*epsilon0*kappa*r*L).

(b) The potential difference is V(a)-V(b)=the definite integral from a to b of E(r) dr, using the E(r) found in part (a).

Evaluating this integral: V(a)-V(b)=the integral from a to b of [Q/(2*pi*epsilon0*kappa*r*L)] dr = [Q/(2*pi*epsilon0*kappa*L)]*ln(b/a).

(c) The capacitance is defined as C=Q/[V(a)-V(b)], using the actual charge Q and the voltage expression derived above for this specific cylindrical geometry -- not the parallel-plate formula C=kappa*epsilon0*A/d, which does not apply to concentric cylinders.

Substituting the expression from part (b): C=Q/{[Q/(2*pi*epsilon0*kappa*L)]*ln(b/a)}=(2*pi*epsilon0*kappa*L)/ln(b/a).' where id = 'b61b7a99-36e0-451d-93ce-f99503c2504d';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 1, '(a) Without the dielectric, applying Gauss''s law with a coaxial cylindrical Gaussian surface of radius r (a<r<b) and length L gives E0*(2*pi*r*L)=Q/epsilon0, so E0(r)=Q/(2*pi*epsilon0*r*L).', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 3, 'Filling the region between the shells with a dielectric of constant kappa reduces the field by a factor of kappa: E(r)=E0(r)/kappa=Q/(2*pi*epsilon0*kappa*r*L).', ARRAY['part-a-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 5, '(b) The potential difference is V(a)-V(b)=the definite integral from a to b of E(r) dr, using the E(r) found in part (a).', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 7, 'Evaluating this integral: V(a)-V(b)=the integral from a to b of [Q/(2*pi*epsilon0*kappa*r*L)] dr = [Q/(2*pi*epsilon0*kappa*L)]*ln(b/a).', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 9, '(c) The capacitance is defined as C=Q/[V(a)-V(b)], using the actual charge Q and the voltage expression derived above for this specific cylindrical geometry -- not the parallel-plate formula C=kappa*epsilon0*A/d, which does not apply to concentric cylinders.', ARRAY['part-c-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b61b7a99-36e0-451d-93ce-f99503c2504d', 'canonical_answer_1', 11, 'Substituting the expression from part (b): C=Q/{[Q/(2*pi*epsilon0*kappa*L)]*ln(b/a)}=(2*pi*epsilon0*kappa*L)/ln(b/a).', ARRAY['part-c-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

-- apphycem-frq-np1-010 (609a4d5a-ca55-4385-b3e1-7fe938d4b10d)
update app.content_item_versions set canonical_answer_1 = '(a) Before the dielectric is inserted, the capacitance is C0=epsilon0*A/d, the standard parallel-plate formula.

(b) After the dielectric (constant kappa) completely fills the gap, the new capacitance is C=kappa*C0.

Since the battery is disconnected, the charge Q0 stays fixed (not the voltage). The stored energy before insertion is U0=Q0^2/(2*C0), and after insertion, using the same fixed Q0 but the new capacitance, U=Q0^2/(2*C)=Q0^2/(2*kappa*C0).

Taking the ratio: U/U0=[Q0^2/(2*kappa*C0)]/[Q0^2/(2*C0)]=1/kappa.

(c) Since kappa>1, the ratio U/U0=1/kappa is less than 1, so the stored energy decreases when the dielectric is inserted.

Because the charge is isolated (the battery is disconnected, so it does no work during insertion), total energy must be conserved; the decrease in the capacitor''s stored field energy corresponds to positive work done by the electric field on the dielectric slab as it is pulled into the capacitor by the field''s attraction to the induced polarization charge -- if the slab moves freely under this pull, the field does positive work on it (accelerating it, which would then appear as kinetic energy or be damped away as heat/sound if there is any friction or inelastic collision at the end of its travel). If instead an external agent inserts the slab slowly (quasi-statically, with no leftover kinetic energy), the field still does the same positive work on the slab, but the external agent must then do an equal amount of negative work (removing energy, i.e. holding the slab back) to prevent it from accelerating -- so in the slow-insertion case, the agent''s work exactly cancels part of the field''s work, and it is this bookkeeping difference (not a difference in the underlying physics) that distinguishes the two scenarios.' where id = '609a4d5a-ca55-4385-b3e1-7fe938d4b10d';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 1, '(a) Before the dielectric is inserted, the capacitance is C0=epsilon0*A/d, the standard parallel-plate formula.', ARRAY['part-a-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 3, '(b) After the dielectric (constant kappa) completely fills the gap, the new capacitance is C=kappa*C0.', ARRAY['part-b-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 5, 'Since the battery is disconnected, the charge Q0 stays fixed (not the voltage). The stored energy before insertion is U0=Q0^2/(2*C0), and after insertion, using the same fixed Q0 but the new capacitance, U=Q0^2/(2*C)=Q0^2/(2*kappa*C0).', ARRAY['part-b-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 7, 'Taking the ratio: U/U0=[Q0^2/(2*kappa*C0)]/[Q0^2/(2*C0)]=1/kappa.', ARRAY['part-b-criterion-03'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 9, '(c) Since kappa>1, the ratio U/U0=1/kappa is less than 1, so the stored energy decreases when the dielectric is inserted.', ARRAY['part-c-criterion-01'], 'drafted', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphysicscem_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('609a4d5a-ca55-4385-b3e1-7fe938d4b10d', 'canonical_answer_1', 11, 'Because the charge is isolated (the battery is disconnected, so it does no work during insertion), total energy must be conserved; the decrease in the capacitor''s stored field energy corresponds to positive work done by the electric field on the dielectric slab as it is pulled into the capacitor by the field''s attraction to the induced polarization charge -- if the slab moves freely under this pull, the field does positive work on it (accelerating it, which would then appear as kinetic energy or be damped away as heat/sound if there is any friction or inelastic collision at the end of its travel). If instead an external agent inserts the slab slowly (quasi-statically, with no leftover kinetic energy), the field still does the same positive work on the slab, but the external agent must then do an equal amount of negative work (removing energy, i.e. holding the slab back) to prevent it from accelerating -- so in the slow-insertion case, the agent''s work exactly cancels part of the field''s work, and it is this bookkeeping difference (not a difference in the underlying physics) that distinguishes the two scenarios.', ARRAY['part-c-criterion-02'], 'drafted', 'apphysicscem_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('adc049a4-2cdc-4c8b-8304-899b54cca5c8'::uuid),('045ec2b1-e801-4b01-994f-8c4f49d6e65a'::uuid),('b61b7a99-36e0-451d-93ce-f99503c2504d'::uuid),('609a4d5a-ca55-4385-b3e1-7fe938d4b10d'::uuid)) as t(vid)
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

