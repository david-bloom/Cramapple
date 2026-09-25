-- AP Physics 1 servability work (docs/product/SUBJECT_SERVABILITY_CRITERIA.md), criterion 4.
-- Authors canonical_answer_1 + canonical_answer_spans for the 39 published AP Physics 1 FRQ items
-- that had a blank canonical_answer_1 (apphy1-frq-001/012/018/024/032/033/035/037/038/039/040/041/
-- 042/043/044/045/046/047/048/049/050/052/053/054/055/056/057/058, apphy1-frq-np2-007, and
-- apphy1-frq-np1-001/002/003/004/005/006/007/008/009/010), following the same pattern as
-- supabase/migrations/20260925040000_apphysicscem_canonical_answers_39_items.sql: each answer's
-- text is composed of criterion-exclusive spans (one span per frq_criteria.criterion_key, plus
-- assembly_literal separators), verified to concatenate exactly to canonical_answer_1.
--
-- Content investigation: read every item's stem, stimulus, and frq_criteria directly. All 39 are
-- genuine, complete, production-quality FRQ content spanning kinematics, Newton's laws and friction,
-- work-energy and power, momentum and collisions, circular motion, simple harmonic motion, fluids,
-- and experimental-design items -- none are placeholder/draft-quality, so all 39 get canonical
-- answers, not an unpublish recommendation.
--
-- Every value in every canonical answer was independently re-derived from first principles (not
-- copied from the rubric's learner_facing_text) -- each item's math and physics were re-worked from
-- scratch and cross-checked against the rubric's stated correct values, confirming the rubric text
-- was itself correct.
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
-- has_canonical=39, concat_matches=39.
--
-- One item, apphy1-frq-048, is flagged for extra scrutiny: its content_item_version_id had a
-- transcription typo caught and fixed before this SQL was generated. The post-apply verification
-- query confirmed it updated correctly along with the other 38 items (all three counts equal 39,
-- with no partial/zero-row update for this item specifically).
--
-- Applied to Production (pcntajvbdfqhbeewmdry) as eight separate migrations
-- (apphy1_canonical_answers_batch_1 through _batch_8) on 2026-09-25; this file concatenates those
-- eight self-contained transactions, in the same order, for the repo's migration ledger record.
--
-- Scope note: this closes criterion 4 (canonical answers) for AP Physics 1's 39 previously-blank FRQ
-- items. Two other servability criteria for this subject remain open and are NOT addressed here:
-- criterion 3 (labels), only 7/117 items validated, and criterion 5 (difficulty), 0/117 items
-- validated. These gaps are documented in
-- docs/product/AP_PHYSICS_1_LAUNCH_READINESS_2026_09_24.md (on branch
-- codex/physics1-launch-readiness-2026-09-24) and were independently re-verified in
-- docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md.
--
-- Rollback: set canonical_answer_1 back to null and delete the inserted canonical_answer_spans rows
-- for the 39 content_item_version_ids referenced in the do-blocks below, if ever needed.

begin;

-- apphy1-frq-001 (86e72fa9-ccf0-4496-aba2-ef42f8ec8fe1)
update app.content_item_versions set canonical_answer_1 = '(a) With v0=0, a=1.50 m/s^2, t=4.00 s: v=v0+at=0+(1.50)(4.00)=6.00 m/s. Displacement: Δx=v0t+(1/2)at^2=0+(0.5)(1.50)(4.00)^2=12.0 m.

(b) The constant-acceleration kinematics equations v=v0+at and Δx=v0t+(1/2)at^2 apply here because the acceleration is stated to be uniform (constant) over the 4.00 s interval. By Newton''s second law, F=ma, a constant acceleration requires a constant net force acting on the cart throughout this time -- this is the physical condition that justifies treating a as a fixed constant in the kinematics equations used to compute v and Δx.' where id = '86e72fa9-ccf0-4496-aba2-ef42f8ec8fe1';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('86e72fa9-ccf0-4496-aba2-ef42f8ec8fe1', 'canonical_answer_1', 1, '(a) With v0=0, a=1.50 m/s^2, t=4.00 s: v=v0+at=0+(1.50)(4.00)=6.00 m/s. Displacement: Δx=v0t+(1/2)at^2=0+(0.5)(1.50)(4.00)^2=12.0 m.', ARRAY['part-a'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('86e72fa9-ccf0-4496-aba2-ef42f8ec8fe1', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('86e72fa9-ccf0-4496-aba2-ef42f8ec8fe1', 'canonical_answer_1', 3, '(b) The constant-acceleration kinematics equations v=v0+at and Δx=v0t+(1/2)at^2 apply here because the acceleration is stated to be uniform (constant) over the 4.00 s interval. By Newton''s second law, F=ma, a constant acceleration requires a constant net force acting on the cart throughout this time -- this is the physical condition that justifies treating a as a fixed constant in the kinematics equations used to compute v and Δx.', ARRAY['part-b'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-012 (d5148959-28b2-4e2d-a111-f64926d3d2f4)
update app.content_item_versions set canonical_answer_1 = '(a) A feasible measurement: for several different incoming speeds of the 2.00 kg cart, measure both carts'' velocities immediately before and immediately after the collision (e.g., using motion sensors), and compare the total momentum before the collision to the total momentum after. The independent variable is the incoming cart''s speed, the dependent variable is the final combined velocity of the stuck-together carts, and a control is holding the stationary cart''s mass (1.00 kg) fixed across all trials.

(b) Conservation of momentum is the governing principle: because no external horizontal impulse acts on the two-cart system during the brief collision (the track is horizontal and any friction/gravity acts vertically or is negligible over the short collision time), total momentum immediately before equals total momentum immediately after, which is what allows solving for the final combined velocity. Kinetic energy is NOT conserved in this collision because it is perfectly inelastic (the carts stick together) -- some kinetic energy is converted to other forms (heat, sound, deformation) during the sticking process, which is the defining feature of an inelastic collision.' where id = 'd5148959-28b2-4e2d-a111-f64926d3d2f4';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d5148959-28b2-4e2d-a111-f64926d3d2f4', 'canonical_answer_1', 1, '(a) A feasible measurement: for several different incoming speeds of the 2.00 kg cart, measure both carts'' velocities immediately before and immediately after the collision (e.g., using motion sensors), and compare the total momentum before the collision to the total momentum after. The independent variable is the incoming cart''s speed, the dependent variable is the final combined velocity of the stuck-together carts, and a control is holding the stationary cart''s mass (1.00 kg) fixed across all trials.', ARRAY['part-a'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d5148959-28b2-4e2d-a111-f64926d3d2f4', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('d5148959-28b2-4e2d-a111-f64926d3d2f4', 'canonical_answer_1', 3, '(b) Conservation of momentum is the governing principle: because no external horizontal impulse acts on the two-cart system during the brief collision (the track is horizontal and any friction/gravity acts vertically or is negligible over the short collision time), total momentum immediately before equals total momentum immediately after, which is what allows solving for the final combined velocity. Kinetic energy is NOT conserved in this collision because it is perfectly inelastic (the carts stick together) -- some kinetic energy is converted to other forms (heat, sound, deformation) during the sticking process, which is the defining feature of an inelastic collision.', ARRAY['part-b'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-018 (6bc66fdd-2dfe-43ca-8f24-f5c33694d9ac)
update app.content_item_versions set canonical_answer_1 = '(a) The free-body diagram shows three forces on the block: the buoyant force F_buoyant = ρ_water * g * V acting upward (from Archimedes'' principle), the weight mg = ρ_block * g * V acting downward, and the string tension T. For equilibrium, ΣF=0: F_buoyant - mg - T = 0 if T acts downward (string anchored below), or F_buoyant - mg + T = 0 if T acts upward (string anchored above) -- the correct configuration is determined in part (b).

(b) Since ρ_block < ρ_water, the buoyant force ρ_water*g*V exceeds the block''s weight ρ_block*g*V -- the block would float upward without the string. To hold it in equilibrium, the string''s tension must pull the block DOWN, which requires the anchor point to be BELOW the block (at the tank bottom), not above it. The required tension is T = F_buoyant - mg = (ρ_water - ρ_block)*g*V, a positive (downward) value consistent with an anchor below the block.' where id = '6bc66fdd-2dfe-43ca-8f24-f5c33694d9ac';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6bc66fdd-2dfe-43ca-8f24-f5c33694d9ac', 'canonical_answer_1', 1, '(a) The free-body diagram shows three forces on the block: the buoyant force F_buoyant = ρ_water * g * V acting upward (from Archimedes'' principle), the weight mg = ρ_block * g * V acting downward, and the string tension T. For equilibrium, ΣF=0: F_buoyant - mg - T = 0 if T acts downward (string anchored below), or F_buoyant - mg + T = 0 if T acts upward (string anchored above) -- the correct configuration is determined in part (b).', ARRAY['part-a'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6bc66fdd-2dfe-43ca-8f24-f5c33694d9ac', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('6bc66fdd-2dfe-43ca-8f24-f5c33694d9ac', 'canonical_answer_1', 3, '(b) Since ρ_block < ρ_water, the buoyant force ρ_water*g*V exceeds the block''s weight ρ_block*g*V -- the block would float upward without the string. To hold it in equilibrium, the string''s tension must pull the block DOWN, which requires the anchor point to be BELOW the block (at the tank bottom), not above it. The required tension is T = F_buoyant - mg = (ρ_water - ρ_block)*g*V, a positive (downward) value consistent with an anchor below the block.', ARRAY['part-b'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-024 (5bb16d64-6210-499b-aeb7-fa59823ac11a)
update app.content_item_versions set canonical_answer_1 = '(a) The center-of-mass velocity remains constant (unchanged) during the separation. This is because no external horizontal force acts on the two-cart system -- the spring force pushing the carts apart is entirely internal to the system (it acts equally and oppositely on each cart, per Newton''s third law). Since total momentum is conserved when no external force acts, and center-of-mass velocity is total momentum divided by total mass, the center-of-mass velocity stays constant throughout.

(b) By conservation of momentum (total momentum starts and ends at the same value, since the system started together and any external force is absent), the two carts must receive equal-magnitude, oppositely-directed momentum changes: Δp_1 = -Δp_2.

Since momentum change equals mass times velocity change, and the momentum changes are equal in magnitude, the cart with half the mass (the lighter cart) must have twice the magnitude of velocity change to produce the same magnitude of momentum change as the heavier cart.' where id = '5bb16d64-6210-499b-aeb7-fa59823ac11a';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5bb16d64-6210-499b-aeb7-fa59823ac11a', 'canonical_answer_1', 1, '(a) The center-of-mass velocity remains constant (unchanged) during the separation. This is because no external horizontal force acts on the two-cart system -- the spring force pushing the carts apart is entirely internal to the system (it acts equally and oppositely on each cart, per Newton''s third law). Since total momentum is conserved when no external force acts, and center-of-mass velocity is total momentum divided by total mass, the center-of-mass velocity stays constant throughout.', ARRAY['a-com'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5bb16d64-6210-499b-aeb7-fa59823ac11a', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5bb16d64-6210-499b-aeb7-fa59823ac11a', 'canonical_answer_1', 3, '(b) By conservation of momentum (total momentum starts and ends at the same value, since the system started together and any external force is absent), the two carts must receive equal-magnitude, oppositely-directed momentum changes: Δp_1 = -Δp_2.', ARRAY['b-momentum'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5bb16d64-6210-499b-aeb7-fa59823ac11a', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('5bb16d64-6210-499b-aeb7-fa59823ac11a', 'canonical_answer_1', 5, 'Since momentum change equals mass times velocity change, and the momentum changes are equal in magnitude, the cart with half the mass (the lighter cart) must have twice the magnitude of velocity change to produce the same magnitude of momentum change as the heavier cart.', ARRAY['b-speed'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-032 (b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01)
update app.content_item_versions set canonical_answer_1 = '(a) With the stick resting stationary on the two supports (at the 20 cm and 80 cm marks), measure the force reading at one support using the force sensor, and note the two known support locations.

Using vertical force balance (ΣF=0: the two support forces must sum to the stick''s total weight, mg), infer the other (unmeasured) support force as F_1 = mg - F_2, where F_2 is the measured force.

(b) Choose one of the two supports as the pivot point for a torque calculation -- this makes that support''s own (unknown, or now-inferred) force contribute zero torque about the pivot, since its lever arm is zero, simplifying the torque equation.

Setting the sum of torques about that pivot to zero gives a relation such as F_2*(x_2 - x_1) = mg*(x_cm - x_1), where x_1 and x_2 are the support locations and x_cm is the unknown center-of-mass location -- this can be solved for x_cm using the measured F_2 and known m, x_1, x_2.

(c) As a consistency check, confirm that the computed center-of-mass location falls between the two actual support locations (20 cm and 80 cm) -- not merely somewhere between 0 and 100 cm on the meterstick -- and verify that the computed x_cm reproduces both the original force balance and torque balance equations when substituted back in.

To reduce uncertainty, repeat the measurement with the supports moved to different locations along the stick, and average the resulting (compatible) center-of-mass estimates from each configuration.' where id = 'b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 1, '(a) With the stick resting stationary on the two supports (at the 20 cm and 80 cm marks), measure the force reading at one support using the force sensor, and note the two known support locations.', ARRAY['a-measure'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 3, 'Using vertical force balance (ΣF=0: the two support forces must sum to the stick''s total weight, mg), infer the other (unmeasured) support force as F_1 = mg - F_2, where F_2 is the measured force.', ARRAY['a-infer'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 5, '(b) Choose one of the two supports as the pivot point for a torque calculation -- this makes that support''s own (unknown, or now-inferred) force contribute zero torque about the pivot, since its lever arm is zero, simplifying the torque equation.', ARRAY['b-pivot'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 7, 'Setting the sum of torques about that pivot to zero gives a relation such as F_2*(x_2 - x_1) = mg*(x_cm - x_1), where x_1 and x_2 are the support locations and x_cm is the unknown center-of-mass location -- this can be solved for x_cm using the measured F_2 and known m, x_1, x_2.', ARRAY['b-torque'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 9, '(c) As a consistency check, confirm that the computed center-of-mass location falls between the two actual support locations (20 cm and 80 cm) -- not merely somewhere between 0 and 100 cm on the meterstick -- and verify that the computed x_cm reproduces both the original force balance and torque balance equations when substituted back in.', ARRAY['c-check'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01', 'canonical_answer_1', 11, 'To reduce uncertainty, repeat the measurement with the supports moved to different locations along the stick, and average the resulting (compatible) center-of-mass estimates from each configuration.', ARRAY['c-uncertainty'], 'drafted', 'apphy1_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('86e72fa9-ccf0-4496-aba2-ef42f8ec8fe1'::uuid),('d5148959-28b2-4e2d-a111-f64926d3d2f4'::uuid),('6bc66fdd-2dfe-43ca-8f24-f5c33694d9ac'::uuid),('5bb16d64-6210-499b-aeb7-fa59823ac11a'::uuid),('b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01'::uuid)) as t(vid)
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

-- apphy1-frq-033 (9f159e00-a8d9-4690-945b-c255632a5429)
update app.content_item_versions set canonical_answer_1 = '(a) All three graphs (x, v, a versus t) are sinusoids sharing the same period T. Position x(t) starts at its maximum value +A at t=0 and follows a cosine shape. Velocity v(t) starts at zero and initially goes negative (since the mass is about to move back toward equilibrium from its positive extreme), following a negative-sine shape. Acceleration a(t) starts at its most negative value (since a=-omega^2*x and x starts at its most positive value), following a negative-cosine shape aligned with x''s zero-crossings and extrema; v is offset by a quarter period from both x and a -- v''s extrema occur exactly where x and a cross zero, and v=0 exactly where x and a are at their extremes.

(b) Acceleration is always opposite in sign to position (a=-omega^2*x, the hallmark of simple harmonic motion), while velocity is shifted by one-quarter period (T/4) relative to position -- consistent with v being the time-derivative of a cosine, which produces a sine shifted by a quarter cycle.

Kinetic energy is maximum when speed is maximum, which occurs at the equilibrium crossings (x=0), at t=T/4 and t=3T/4 -- the two points where the velocity graph reaches its extreme (most negative and most positive) values.' where id = '9f159e00-a8d9-4690-945b-c255632a5429';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9f159e00-a8d9-4690-945b-c255632a5429', 'canonical_answer_1', 1, '(a) All three graphs (x, v, a versus t) are sinusoids sharing the same period T. Position x(t) starts at its maximum value +A at t=0 and follows a cosine shape. Velocity v(t) starts at zero and initially goes negative (since the mass is about to move back toward equilibrium from its positive extreme), following a negative-sine shape. Acceleration a(t) starts at its most negative value (since a=-omega^2*x and x starts at its most positive value), following a negative-cosine shape aligned with x''s zero-crossings and extrema; v is offset by a quarter period from both x and a -- v''s extrema occur exactly where x and a cross zero, and v=0 exactly where x and a are at their extremes.', ARRAY['a-graphs'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9f159e00-a8d9-4690-945b-c255632a5429', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9f159e00-a8d9-4690-945b-c255632a5429', 'canonical_answer_1', 3, '(b) Acceleration is always opposite in sign to position (a=-omega^2*x, the hallmark of simple harmonic motion), while velocity is shifted by one-quarter period (T/4) relative to position -- consistent with v being the time-derivative of a cosine, which produces a sine shifted by a quarter cycle.', ARRAY['b-phase'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9f159e00-a8d9-4690-945b-c255632a5429', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9f159e00-a8d9-4690-945b-c255632a5429', 'canonical_answer_1', 5, 'Kinetic energy is maximum when speed is maximum, which occurs at the equilibrium crossings (x=0), at t=T/4 and t=3T/4 -- the two points where the velocity graph reaches its extreme (most negative and most positive) values.', ARRAY['b-energy'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-035 (beacb3d2-fd4c-404d-95b9-e734637d17d8)
update app.content_item_versions set canonical_answer_1 = '(a) Energy conservation with friction as a non-conservative loss: initial spring energy = friction work lost + final gravitational potential energy at maximum height (with zero kinetic energy there).

The initial spring energy is (1/2)kx^2.

The kinetic-friction force magnitude on the horizontal rough region is μmg (normal force mg times the coefficient of kinetic friction, since the surface is horizontal).

The work done by friction over the length L is -μmgL (negative, since friction opposes the motion).

At the maximum height h on the frictionless ramp, all kinetic energy has converted to gravitational potential energy: final energy = mgh, with zero kinetic energy there.

Combining: (1/2)kx^2 - μmgL = mgh. Solving for h: h = (1/2)kx^2/(mg) - μL = kx^2/(2mg) - μL.

For the block to actually reach the ramp (i.e., for h to be a physically meaningful positive value, or even just for the block to cross the rough region at all), the initial spring energy must exceed the friction work: (1/2)kx^2 > μmgL.

(b) Substituting a compression of 2x into the derived height expression: h(2x) = k(2x)^2/(2mg) - μL = 4kx^2/(2mg) - μL = 2kx^2/(mg) - μL.

h(2x) - h(x) = [2kx^2/(mg) - μL] - [kx^2/(2mg) - μL] = 2kx^2/(mg) - kx^2/(2mg) = 3kx^2/(2mg).

This is because the spring''s stored energy is proportional to the square of the compression ((1/2)kx^2), so doubling the compression quadruples the spring energy, while the frictional energy loss (μmgL) depends only on the fixed length L and is completely unchanged -- so the height gain does not simply double, it grows by more than a factor of 4 relative to just the spring-energy term, net of the unchanged friction loss.' where id = 'beacb3d2-fd4c-404d-95b9-e734637d17d8';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 1, '(a) Energy conservation with friction as a non-conservative loss: initial spring energy = friction work lost + final gravitational potential energy at maximum height (with zero kinetic energy there).', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 3, 'The initial spring energy is (1/2)kx^2.', ARRAY['part-a-criterion-02'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 5, 'The kinetic-friction force magnitude on the horizontal rough region is μmg (normal force mg times the coefficient of kinetic friction, since the surface is horizontal).', ARRAY['part-a-criterion-03'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 7, 'The work done by friction over the length L is -μmgL (negative, since friction opposes the motion).', ARRAY['part-a-criterion-04'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 9, 'At the maximum height h on the frictionless ramp, all kinetic energy has converted to gravitational potential energy: final energy = mgh, with zero kinetic energy there.', ARRAY['part-a-criterion-05'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 11, 'Combining: (1/2)kx^2 - μmgL = mgh. Solving for h: h = (1/2)kx^2/(mg) - μL = kx^2/(2mg) - μL.', ARRAY['part-a-criterion-06'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 13, 'For the block to actually reach the ramp (i.e., for h to be a physically meaningful positive value, or even just for the block to cross the rough region at all), the initial spring energy must exceed the friction work: (1/2)kx^2 > μmgL.', ARRAY['part-a-criterion-07'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 15, '(b) Substituting a compression of 2x into the derived height expression: h(2x) = k(2x)^2/(2mg) - μL = 4kx^2/(2mg) - μL = 2kx^2/(mg) - μL.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 17, 'h(2x) - h(x) = [2kx^2/(mg) - μL] - [kx^2/(2mg) - μL] = 2kx^2/(mg) - kx^2/(2mg) = 3kx^2/(2mg).', ARRAY['part-b-criterion-02'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('beacb3d2-fd4c-404d-95b9-e734637d17d8', 'canonical_answer_1', 19, 'This is because the spring''s stored energy is proportional to the square of the compression ((1/2)kx^2), so doubling the compression quadruples the spring energy, while the frictional energy loss (μmgL) depends only on the fixed length L and is completely unchanged -- so the height gain does not simply double, it grows by more than a factor of 4 relative to just the spring-energy term, net of the unchanged friction loss.', ARRAY['part-b-criterion-03'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-037 (96f0cca0-0b23-4d3d-91f1-d5c0bf65832c)
update app.content_item_versions set canonical_answer_1 = '(a) For a liquid at rest, absolute pressure at depth h below the surface is P = P_atm + ρgh.

Plotting P versus h, this relation is linear with slope ρg -- so the slope of a P-vs-h graph directly gives ρg.

(b) Lower the pressure sensor to several different known vertical depths below the liquid''s surface, waiting for each reading to stabilize before recording the pressure.

Keep the liquid at rest (undisturbed) throughout, use the same calibrated sensor orientation for every reading, and avoid letting the sensor touch or disturb the container walls or bottom.

(c) Plot the measured absolute pressure P (vertical axis) against depth h (horizontal axis) and fit a straight line through the data points.

The liquid''s density is calculated from the fitted slope: ρ = slope/g.

Uncertainty in the density is found by propagating the uncertainty in the fitted slope: δρ = δslope/g (or equivalently, using the slopes of the steepest and shallowest lines still consistent with the data to bound ρ).

Comparing the fitted line''s y-intercept (extrapolated to h=0) with the barometer''s independently-measured P_atm can diagnose whether the pressure sensor has a zero-point (calibration) offset -- if the intercept doesn''t match P_atm, the sensor likely has an offset error.

(d) The calculated density is unchanged even if the depth measurements all have a constant offset error (e.g., measuring from the wrong reference point).

This is because a constant offset added to every recorded depth h shifts the P-vs-h graph horizontally, changing only its y-intercept, not its slope -- and since density is calculated purely from the slope (ρ=slope/g), a depth offset does not affect the calculated density.' where id = '96f0cca0-0b23-4d3d-91f1-d5c0bf65832c';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 1, '(a) For a liquid at rest, absolute pressure at depth h below the surface is P = P_atm + ρgh.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 3, 'Plotting P versus h, this relation is linear with slope ρg -- so the slope of a P-vs-h graph directly gives ρg.', ARRAY['part-a-criterion-02'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 5, '(b) Lower the pressure sensor to several different known vertical depths below the liquid''s surface, waiting for each reading to stabilize before recording the pressure.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 7, 'Keep the liquid at rest (undisturbed) throughout, use the same calibrated sensor orientation for every reading, and avoid letting the sensor touch or disturb the container walls or bottom.', ARRAY['part-b-criterion-02'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 9, '(c) Plot the measured absolute pressure P (vertical axis) against depth h (horizontal axis) and fit a straight line through the data points.', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 11, 'The liquid''s density is calculated from the fitted slope: ρ = slope/g.', ARRAY['part-c-criterion-02'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 13, 'Uncertainty in the density is found by propagating the uncertainty in the fitted slope: δρ = δslope/g (or equivalently, using the slopes of the steepest and shallowest lines still consistent with the data to bound ρ).', ARRAY['part-c-criterion-03'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 15, 'Comparing the fitted line''s y-intercept (extrapolated to h=0) with the barometer''s independently-measured P_atm can diagnose whether the pressure sensor has a zero-point (calibration) offset -- if the intercept doesn''t match P_atm, the sensor likely has an offset error.', ARRAY['part-c-criterion-04'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 17, '(d) The calculated density is unchanged even if the depth measurements all have a constant offset error (e.g., measuring from the wrong reference point).', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c', 'canonical_answer_1', 19, 'This is because a constant offset added to every recorded depth h shifts the P-vs-h graph horizontally, changing only its y-intercept, not its slope -- and since density is calculated purely from the slope (ρ=slope/g), a depth offset does not affect the calculated density.', ARRAY['part-d-criterion-02'], 'drafted', 'apphy1_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('9f159e00-a8d9-4690-945b-c255632a5429'::uuid),('beacb3d2-fd4c-404d-95b9-e734637d17d8'::uuid),('96f0cca0-0b23-4d3d-91f1-d5c0bf65832c'::uuid)) as t(vid)
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

-- apphy1-frq-038 (db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a)
update app.content_item_versions set canonical_answer_1 = '(a) At x=A/2, the kinetic energy is greater than the spring potential energy.

Total mechanical energy is E=(1/2)kA^2, and the spring potential energy at x=A/2 is U=(1/2)k(A/2)^2=(1/2)k(A^2/4)=E/4.

So the kinetic energy is K=E-U=E-E/4=3E/4, which is greater than U=E/4 -- confirming K>U at this position.

(b) Using energy conservation for the first cart (amplitude A) at x=A/2: (1/2)kA^2 = (1/2)k(A/2)^2 + (1/2)mv_1^2.

Solving: (1/2)mv_1^2 = (1/2)kA^2 - (1/8)kA^2 = (3/8)kA^2, so v_1^2 = (3/4)(k/m)A^2, giving v_1 = (A/2)*sqrt(3k/m).

For the second system with amplitude 2A, evaluated at x=A (the analogous half-amplitude position, since A = (2A)/2): by the same method, v_2 = A*sqrt(3k/m) = 2*v_1.

(c) The claim that a larger amplitude changes the period is incorrect -- for an ideal simple harmonic oscillator, the period remains T=2*pi*sqrt(m/k) regardless of amplitude.

Although the cart with amplitude 2A travels a greater distance each cycle, its speeds are also proportionally greater at every corresponding phase of the motion (as shown in part b, where v_2=2*v_1) -- the increased distance and increased speed offset each other exactly, so the time to complete one cycle (the period) does not change with amplitude.' where id = 'db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 1, '(a) At x=A/2, the kinetic energy is greater than the spring potential energy.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 3, 'Total mechanical energy is E=(1/2)kA^2, and the spring potential energy at x=A/2 is U=(1/2)k(A/2)^2=(1/2)k(A^2/4)=E/4.', ARRAY['part-a-criterion-02'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 5, 'So the kinetic energy is K=E-U=E-E/4=3E/4, which is greater than U=E/4 -- confirming K>U at this position.', ARRAY['part-a-criterion-03'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 7, '(b) Using energy conservation for the first cart (amplitude A) at x=A/2: (1/2)kA^2 = (1/2)k(A/2)^2 + (1/2)mv_1^2.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 9, 'Solving: (1/2)mv_1^2 = (1/2)kA^2 - (1/8)kA^2 = (3/8)kA^2, so v_1^2 = (3/4)(k/m)A^2, giving v_1 = (A/2)*sqrt(3k/m).', ARRAY['part-b-criterion-02'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 11, 'For the second system with amplitude 2A, evaluated at x=A (the analogous half-amplitude position, since A = (2A)/2): by the same method, v_2 = A*sqrt(3k/m) = 2*v_1.', ARRAY['part-b-criterion-03'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 13, '(c) The claim that a larger amplitude changes the period is incorrect -- for an ideal simple harmonic oscillator, the period remains T=2*pi*sqrt(m/k) regardless of amplitude.', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a', 'canonical_answer_1', 15, 'Although the cart with amplitude 2A travels a greater distance each cycle, its speeds are also proportionally greater at every corresponding phase of the motion (as shown in part b, where v_2=2*v_1) -- the increased distance and increased speed offset each other exactly, so the time to complete one cycle (the period) does not change with amplitude.', ARRAY['part-c-criterion-02'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-039 (bf116285-ed24-4204-abb5-0991b3584a22)
update app.content_item_versions set canonical_answer_1 = '(a) Using Δy=(1/2)gt^2 with Δy=20.0 m and g=9.80 m/s^2: t=sqrt(2*20.0/9.80)=sqrt(4.0816)≈2.02 s.

The impact speed is v=gt=(9.80)(2.02)≈19.8 m/s (equivalently, v=sqrt(2*g*Δy)=sqrt(2*9.80*20.0)=sqrt(392)≈19.8 m/s).

(b) Gravity is the only force acting on the ball during the fall (air resistance is stated to be ignored), so by Newton''s second law, F_net=mg is constant throughout the fall, meaning the acceleration a=F_net/m=g remains constant at 9.80 m/s^2 the entire time.' where id = 'bf116285-ed24-4204-abb5-0991b3584a22';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bf116285-ed24-4204-abb5-0991b3584a22', 'canonical_answer_1', 1, '(a) Using Δy=(1/2)gt^2 with Δy=20.0 m and g=9.80 m/s^2: t=sqrt(2*20.0/9.80)=sqrt(4.0816)≈2.02 s.', ARRAY['part-a-time'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bf116285-ed24-4204-abb5-0991b3584a22', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bf116285-ed24-4204-abb5-0991b3584a22', 'canonical_answer_1', 3, 'The impact speed is v=gt=(9.80)(2.02)≈19.8 m/s (equivalently, v=sqrt(2*g*Δy)=sqrt(2*9.80*20.0)=sqrt(392)≈19.8 m/s).', ARRAY['part-a-speed'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bf116285-ed24-4204-abb5-0991b3584a22', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('bf116285-ed24-4204-abb5-0991b3584a22', 'canonical_answer_1', 5, '(b) Gravity is the only force acting on the ball during the fall (air resistance is stated to be ignored), so by Newton''s second law, F_net=mg is constant throughout the fall, meaning the acceleration a=F_net/m=g remains constant at 9.80 m/s^2 the entire time.', ARRAY['part-b'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-040 (c7a640a0-0475-4276-bc66-1de484a058a6)
update app.content_item_versions set canonical_answer_1 = '(a) The friction force is f=μmg=(0.200)(5.00)(9.80)=9.80 N.

The resulting deceleration is a=f/m=μg=(0.200)(9.80)=1.96 m/s^2.

(b) Doubling the coefficient of kinetic friction to 0.400 doubles the deceleration.

The new deceleration is a=μg=(0.400)(9.80)=3.92 m/s^2.

This direct proportionality follows from a=μg: the friction force is f=μmg, and the resulting deceleration is a=f/m=μmg/m=μg -- the mass m cancels out entirely, leaving deceleration as directly proportional to μ (with g as the constant of proportionality), regardless of the crate''s mass.' where id = 'c7a640a0-0475-4276-bc66-1de484a058a6';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c7a640a0-0475-4276-bc66-1de484a058a6', 'canonical_answer_1', 1, '(a) The friction force is f=μmg=(0.200)(5.00)(9.80)=9.80 N.', ARRAY['part-a-force'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c7a640a0-0475-4276-bc66-1de484a058a6', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c7a640a0-0475-4276-bc66-1de484a058a6', 'canonical_answer_1', 3, 'The resulting deceleration is a=f/m=μg=(0.200)(9.80)=1.96 m/s^2.', ARRAY['part-a-decel'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c7a640a0-0475-4276-bc66-1de484a058a6', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c7a640a0-0475-4276-bc66-1de484a058a6', 'canonical_answer_1', 5, '(b) Doubling the coefficient of kinetic friction to 0.400 doubles the deceleration.', ARRAY['part-b-prediction'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c7a640a0-0475-4276-bc66-1de484a058a6', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c7a640a0-0475-4276-bc66-1de484a058a6', 'canonical_answer_1', 7, 'The new deceleration is a=μg=(0.400)(9.80)=3.92 m/s^2.', ARRAY['part-b-newvalue'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c7a640a0-0475-4276-bc66-1de484a058a6', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c7a640a0-0475-4276-bc66-1de484a058a6', 'canonical_answer_1', 9, 'This direct proportionality follows from a=μg: the friction force is f=μmg, and the resulting deceleration is a=f/m=μmg/m=μg -- the mass m cancels out entirely, leaving deceleration as directly proportional to μ (with g as the constant of proportionality), regardless of the crate''s mass.', ARRAY['part-b-proportionality'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-041 (f43cd467-46ad-4758-b6c9-21e3851a261e)
update app.content_item_versions set canonical_answer_1 = '(a) The independent variable is the time taken to climb the staircase (equivalently, the climbing pace).

The dependent variable is the average mechanical power output, computed as mgh/t.

(b) A control variable that must be held constant is the climber''s mass (or alternatively, the staircase''s fixed height h, which the problem already states is fixed). Holding mass constant is necessary because power is calculated as mgh/t -- if mass varied between trials along with climbing time, any change in the calculated power could be due to the change in mass rather than the change in climbing time, confounding the relationship the experiment is trying to isolate (how power depends on time alone).' where id = 'f43cd467-46ad-4758-b6c9-21e3851a261e';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f43cd467-46ad-4758-b6c9-21e3851a261e', 'canonical_answer_1', 1, '(a) The independent variable is the time taken to climb the staircase (equivalently, the climbing pace).', ARRAY['a-independent'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f43cd467-46ad-4758-b6c9-21e3851a261e', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f43cd467-46ad-4758-b6c9-21e3851a261e', 'canonical_answer_1', 3, 'The dependent variable is the average mechanical power output, computed as mgh/t.', ARRAY['a-dependent'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f43cd467-46ad-4758-b6c9-21e3851a261e', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f43cd467-46ad-4758-b6c9-21e3851a261e', 'canonical_answer_1', 5, '(b) A control variable that must be held constant is the climber''s mass (or alternatively, the staircase''s fixed height h, which the problem already states is fixed). Holding mass constant is necessary because power is calculated as mgh/t -- if mass varied between trials along with climbing time, any change in the calculated power could be due to the change in mass rather than the change in climbing time, confounding the relationship the experiment is trying to isolate (how power depends on time alone).', ARRAY['b-control'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-042 (2a7ee51f-c0d2-490c-bc20-2e749616868b)
update app.content_item_versions set canonical_answer_1 = '(a) v=v0+at=-12.0+(4.00)(6.00)=-12.0+24.0=12.0 m/s.

Δx=v0t+(1/2)at^2=(-12.0)(6.00)+(0.5)(4.00)(6.00)^2=-72.0+72.0=0 m.

(b) The car is momentarily at rest when v=0: 0=v0+at → t=-v0/a=-(-12.0)/4.00=3.00 s.

The negative initial velocity means the car starts out moving in the negative direction along the road. Under the constant positive acceleration, it decelerates, comes to rest momentarily at t=3.00 s, and then reverses direction, moving in the positive direction for the remainder of the 6.00 s interval -- consistent with the net displacement being exactly zero (the car ends up back where it started, having traveled first one way, then the other, over equal-magnitude distances).' where id = '2a7ee51f-c0d2-490c-bc20-2e749616868b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2a7ee51f-c0d2-490c-bc20-2e749616868b', 'canonical_answer_1', 1, '(a) v=v0+at=-12.0+(4.00)(6.00)=-12.0+24.0=12.0 m/s.', ARRAY['a-velocity'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2a7ee51f-c0d2-490c-bc20-2e749616868b', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2a7ee51f-c0d2-490c-bc20-2e749616868b', 'canonical_answer_1', 3, 'Δx=v0t+(1/2)at^2=(-12.0)(6.00)+(0.5)(4.00)(6.00)^2=-72.0+72.0=0 m.', ARRAY['a-displacement'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2a7ee51f-c0d2-490c-bc20-2e749616868b', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2a7ee51f-c0d2-490c-bc20-2e749616868b', 'canonical_answer_1', 5, '(b) The car is momentarily at rest when v=0: 0=v0+at → t=-v0/a=-(-12.0)/4.00=3.00 s.', ARRAY['b-turnaround-time'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2a7ee51f-c0d2-490c-bc20-2e749616868b', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2a7ee51f-c0d2-490c-bc20-2e749616868b', 'canonical_answer_1', 7, 'The negative initial velocity means the car starts out moving in the negative direction along the road. Under the constant positive acceleration, it decelerates, comes to rest momentarily at t=3.00 s, and then reverses direction, moving in the positive direction for the remainder of the 6.00 s interval -- consistent with the net displacement being exactly zero (the car ends up back where it started, having traveled first one way, then the other, over equal-magnitude distances).', ARRAY['b-explanation'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-043 (0927826d-129f-490a-911c-ad68c38eb929)
update app.content_item_versions set canonical_answer_1 = '(a) For a block on a frictionless incline, the acceleration along the incline is a=g*sin(theta)=(9.80)*sin(30.0°)=(9.80)(0.500)=4.90 m/s^2.

The normal force is N=mg*cos(theta)=(4.00)(9.80)*cos(30.0°)=(39.2)(0.8660)≈33.9 N.

(b) Along the incline, Newton''s second law gives mg*sin(theta)=ma, so a=g*sin(theta) -- the mass m appears on both sides of the equation (in the gravitational force component and in the inertia term) and cancels out completely, leaving an acceleration that depends only on g and the incline angle, not on the block''s mass.' where id = '0927826d-129f-490a-911c-ad68c38eb929';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0927826d-129f-490a-911c-ad68c38eb929', 'canonical_answer_1', 1, '(a) For a block on a frictionless incline, the acceleration along the incline is a=g*sin(theta)=(9.80)*sin(30.0°)=(9.80)(0.500)=4.90 m/s^2.', ARRAY['part-a-accel'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0927826d-129f-490a-911c-ad68c38eb929', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0927826d-129f-490a-911c-ad68c38eb929', 'canonical_answer_1', 3, 'The normal force is N=mg*cos(theta)=(4.00)(9.80)*cos(30.0°)=(39.2)(0.8660)≈33.9 N.', ARRAY['part-a-normal'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0927826d-129f-490a-911c-ad68c38eb929', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('0927826d-129f-490a-911c-ad68c38eb929', 'canonical_answer_1', 5, '(b) Along the incline, Newton''s second law gives mg*sin(theta)=ma, so a=g*sin(theta) -- the mass m appears on both sides of the equation (in the gravitational force component and in the inertia term) and cancels out completely, leaving an acceleration that depends only on g and the incline angle, not on the block''s mass.', ARRAY['part-b'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-044 (8a24e2ec-5604-4100-a3f9-565a0ed16d5b)
update app.content_item_versions set canonical_answer_1 = '(a) By energy conservation, mgh=(1/2)mv^2, so v=sqrt(2gh)=sqrt(2*9.80*1.25)=sqrt(24.5)≈4.95 m/s.

(b) Doubling the height to h=2.50 m gives v=sqrt(2*9.80*2.50)=sqrt(49.0)=7.00 m/s.

The speed does not simply double because v is proportional to the square root of h (v=sqrt(2gh)), not to h itself -- this is because kinetic energy depends on v^2, so doubling the available energy (by doubling h) only increases v by a factor of sqrt(2) ≈ 1.41, not by a factor of 2. (Indeed, 4.95 x sqrt(2) ≈ 7.00, confirming this relationship.)' where id = '8a24e2ec-5604-4100-a3f9-565a0ed16d5b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8a24e2ec-5604-4100-a3f9-565a0ed16d5b', 'canonical_answer_1', 1, '(a) By energy conservation, mgh=(1/2)mv^2, so v=sqrt(2gh)=sqrt(2*9.80*1.25)=sqrt(24.5)≈4.95 m/s.', ARRAY['a-original'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8a24e2ec-5604-4100-a3f9-565a0ed16d5b', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8a24e2ec-5604-4100-a3f9-565a0ed16d5b', 'canonical_answer_1', 3, '(b) Doubling the height to h=2.50 m gives v=sqrt(2*9.80*2.50)=sqrt(49.0)=7.00 m/s.', ARRAY['b-new'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8a24e2ec-5604-4100-a3f9-565a0ed16d5b', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('8a24e2ec-5604-4100-a3f9-565a0ed16d5b', 'canonical_answer_1', 5, 'The speed does not simply double because v is proportional to the square root of h (v=sqrt(2gh)), not to h itself -- this is because kinetic energy depends on v^2, so doubling the available energy (by doubling h) only increases v by a factor of sqrt(2) ≈ 1.41, not by a factor of 2. (Indeed, 4.95 x sqrt(2) ≈ 7.00, confirming this relationship.)', ARRAY['b-explanation'], 'drafted', 'apphy1_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a'::uuid),('bf116285-ed24-4204-abb5-0991b3584a22'::uuid),('c7a640a0-0475-4276-bc66-1de484a058a6'::uuid),('f43cd467-46ad-4758-b6c9-21e3851a261e'::uuid),('2a7ee51f-c0d2-490c-bc20-2e749616868b'::uuid),('0927826d-129f-490a-911c-ad68c38eb929'::uuid),('8a24e2ec-5604-4100-a3f9-565a0ed16d5b'::uuid)) as t(vid)
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

-- apphy1-frq-045 (408b1a87-6b9a-438d-93e8-9881ea534971)
update app.content_item_versions set canonical_answer_1 = '(a) The independent variable is the launch angle.

The dependent variable is the horizontal range of the ball.

A control variable to hold constant across trials is the launch speed (other valid controls include launch height, landing height, or the ball''s mass/type).

(b) Holding launch speed constant is necessary because horizontal range depends on both launch speed and launch angle (range = v^2*sin(2*theta)/g, assuming negligible air resistance and equal launch/landing heights) -- if launch speed varied between trials along with angle, any change in observed range could be due to the changing speed rather than the changing angle, confounding the very relationship (angle''s effect on range) the experiment is designed to isolate.' where id = '408b1a87-6b9a-438d-93e8-9881ea534971';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('408b1a87-6b9a-438d-93e8-9881ea534971', 'canonical_answer_1', 1, '(a) The independent variable is the launch angle.', ARRAY['a-independent'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('408b1a87-6b9a-438d-93e8-9881ea534971', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('408b1a87-6b9a-438d-93e8-9881ea534971', 'canonical_answer_1', 3, 'The dependent variable is the horizontal range of the ball.', ARRAY['a-dependent'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('408b1a87-6b9a-438d-93e8-9881ea534971', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('408b1a87-6b9a-438d-93e8-9881ea534971', 'canonical_answer_1', 5, 'A control variable to hold constant across trials is the launch speed (other valid controls include launch height, landing height, or the ball''s mass/type).', ARRAY['a-control'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('408b1a87-6b9a-438d-93e8-9881ea534971', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('408b1a87-6b9a-438d-93e8-9881ea534971', 'canonical_answer_1', 7, '(b) Holding launch speed constant is necessary because horizontal range depends on both launch speed and launch angle (range = v^2*sin(2*theta)/g, assuming negligible air resistance and equal launch/landing heights) -- if launch speed varied between trials along with angle, any change in observed range could be due to the changing speed rather than the changing angle, confounding the very relationship (angle''s effect on range) the experiment is designed to isolate.', ARRAY['b-justification'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-046 (f0613586-dd55-4891-b441-ce9abccc3b28)
update app.content_item_versions set canonical_answer_1 = '(a) The maximum acceleration before slipping occurs when the required friction force on the top block reaches its maximum static value: a_max=μ_s*g=(0.250)(9.80)=2.45 m/s^2.

(b) Once the acceleration required to keep both blocks moving together exceeds a_max=2.45 m/s^2, the static friction force needed to accelerate the top block at that higher rate (via Newton''s second law applied to the top block alone: f=m_top*a) would have to exceed the maximum available static friction force (μ_s*N). Since static friction cannot supply more force than this maximum, the top block can no longer keep pace with the accelerating bottom block -- it begins to slide backward relative to the bottom block (its actual acceleration becomes less than the bottom block''s), and the friction between them transitions to kinetic friction.' where id = 'f0613586-dd55-4891-b441-ce9abccc3b28';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f0613586-dd55-4891-b441-ce9abccc3b28', 'canonical_answer_1', 1, '(a) The maximum acceleration before slipping occurs when the required friction force on the top block reaches its maximum static value: a_max=μ_s*g=(0.250)(9.80)=2.45 m/s^2.', ARRAY['part-a'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f0613586-dd55-4891-b441-ce9abccc3b28', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('f0613586-dd55-4891-b441-ce9abccc3b28', 'canonical_answer_1', 3, '(b) Once the acceleration required to keep both blocks moving together exceeds a_max=2.45 m/s^2, the static friction force needed to accelerate the top block at that higher rate (via Newton''s second law applied to the top block alone: f=m_top*a) would have to exceed the maximum available static friction force (μ_s*N). Since static friction cannot supply more force than this maximum, the top block can no longer keep pace with the accelerating bottom block -- it begins to slide backward relative to the bottom block (its actual acceleration becomes less than the bottom block''s), and the friction between them transitions to kinetic friction.', ARRAY['part-b'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-047 (050bf660-8498-452f-bfad-e521280c3e46)
update app.content_item_versions set canonical_answer_1 = '(a) By the work-energy theorem, the work done equals the change in kinetic energy: W=ΔKE=(1/2)mv^2-0=(0.5)(70.0)(8.00)^2=(0.5)(70.0)(64.0)=2240 J.

The average power is work divided by time: P_avg=W/t=2240/5.00=448 W.

(b) Instantaneous power is P=Fv; with the force roughly constant (constant acceleration means constant net force) but the cyclist''s speed increasing from 0 to 8.00 m/s over the interval, instantaneous power grows over time, starting at 0 and ending at its maximum at t=5.00 s. At t=5.00 s, the acceleration is a=v/t=8.00/5.00=1.60 m/s^2, so F=ma=(70.0)(1.60)=112 N, and instantaneous power P=Fv=(112)(8.00)=896 W -- well above the average power of 448 W, since power increases roughly linearly with time from an initial value of zero, making the average necessarily less than this final, maximum instantaneous value.' where id = '050bf660-8498-452f-bfad-e521280c3e46';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('050bf660-8498-452f-bfad-e521280c3e46', 'canonical_answer_1', 1, '(a) By the work-energy theorem, the work done equals the change in kinetic energy: W=ΔKE=(1/2)mv^2-0=(0.5)(70.0)(8.00)^2=(0.5)(70.0)(64.0)=2240 J.', ARRAY['a-work'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('050bf660-8498-452f-bfad-e521280c3e46', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('050bf660-8498-452f-bfad-e521280c3e46', 'canonical_answer_1', 3, 'The average power is work divided by time: P_avg=W/t=2240/5.00=448 W.', ARRAY['a-power'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('050bf660-8498-452f-bfad-e521280c3e46', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('050bf660-8498-452f-bfad-e521280c3e46', 'canonical_answer_1', 5, '(b) Instantaneous power is P=Fv; with the force roughly constant (constant acceleration means constant net force) but the cyclist''s speed increasing from 0 to 8.00 m/s over the interval, instantaneous power grows over time, starting at 0 and ending at its maximum at t=5.00 s. At t=5.00 s, the acceleration is a=v/t=8.00/5.00=1.60 m/s^2, so F=ma=(70.0)(1.60)=112 N, and instantaneous power P=Fv=(112)(8.00)=896 W -- well above the average power of 448 W, since power increases roughly linearly with time from an initial value of zero, making the average necessarily less than this final, maximum instantaneous value.', ARRAY['b-explanation'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-048 (2a52b9bb-636d-43f7-8ffe-d67a746e0bfb)
update app.content_item_versions set canonical_answer_1 = '(a) Car B closes the 300 m gap at the relative (closing) speed of v_B - v_A = 28.0 - 20.0 = 8.00 m/s. Catch-up time = 300/8.00 = 37.5 s.

(b) Catch-up time is inversely proportional to the closing speed: t = Δx/(v_B - v_A). With car B''s speed increased to 32.0 m/s, the new closing speed is 32.0 - 20.0 = 12.0 m/s, giving a new catch-up time of t = 300/12.0 = 25.0 s -- a faster catch-up, consistent with the inverse relationship between closing speed and catch-up time (a larger closing speed means less time is needed to close the same 300 m gap).' where id = '2a52b9bb-636d-43f7-8ffe-d67a746e0bfb';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2a52b9bb-636d-43f7-8ffe-d67a746e0bfb', 'canonical_answer_1', 1, '(a) Car B closes the 300 m gap at the relative (closing) speed of v_B - v_A = 28.0 - 20.0 = 8.00 m/s. Catch-up time = 300/8.00 = 37.5 s.', ARRAY['a-catchup'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2a52b9bb-636d-43f7-8ffe-d67a746e0bfb', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('2a52b9bb-636d-43f7-8ffe-d67a746e0bfb', 'canonical_answer_1', 3, '(b) Catch-up time is inversely proportional to the closing speed: t = Δx/(v_B - v_A). With car B''s speed increased to 32.0 m/s, the new closing speed is 32.0 - 20.0 = 12.0 m/s, giving a new catch-up time of t = 300/12.0 = 25.0 s -- a faster catch-up, consistent with the inverse relationship between closing speed and catch-up time (a larger closing speed means less time is needed to close the same 300 m gap).', ARRAY['b-combined'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-049 (76d2506f-9aeb-4d39-b20d-804df229efd5)
update app.content_item_versions set canonical_answer_1 = '(a) The independent variable is the hanging mass (or equivalently, the applied weight).

The dependent variable is the resulting spring extension.

One control variable is using the same spring (the same unstretched length and identity) for every trial.

A second control variable is using a consistent measurement method and orientation (for example, always measuring the extension the same way, with the spring hanging vertically, at a consistent temperature) across all trials.

(b) Since F=kx (Hooke''s law), plotting the applied weight F (=mg) on the vertical axis against extension x on the horizontal axis gives a straight line with slope k (or equivalently, plotting extension x versus weight F gives a line with slope 1/k, or plotting mass versus extension gives a line with slope k/g) -- the spring constant k is read directly from the graph''s slope.

This linear method is only valid while the spring remains in its Hookean (elastic) region, since the relationship F=kx (a constant, linear proportionality between force and extension) only holds within that region -- if the spring is stretched beyond its elastic limit, the force-extension relationship becomes nonlinear and the graph would no longer be a straight line, invalidating a single-slope determination of k.' where id = '76d2506f-9aeb-4d39-b20d-804df229efd5';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 1, '(a) The independent variable is the hanging mass (or equivalently, the applied weight).', ARRAY['a-independent'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 3, 'The dependent variable is the resulting spring extension.', ARRAY['a-dependent'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 5, 'One control variable is using the same spring (the same unstretched length and identity) for every trial.', ARRAY['a-control1'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 7, 'A second control variable is using a consistent measurement method and orientation (for example, always measuring the extension the same way, with the spring hanging vertically, at a consistent temperature) across all trials.', ARRAY['a-control2'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 9, '(b) Since F=kx (Hooke''s law), plotting the applied weight F (=mg) on the vertical axis against extension x on the horizontal axis gives a straight line with slope k (or equivalently, plotting extension x versus weight F gives a line with slope 1/k, or plotting mass versus extension gives a line with slope k/g) -- the spring constant k is read directly from the graph''s slope.', ARRAY['b-graph'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('76d2506f-9aeb-4d39-b20d-804df229efd5', 'canonical_answer_1', 11, 'This linear method is only valid while the spring remains in its Hookean (elastic) region, since the relationship F=kx (a constant, linear proportionality between force and extension) only holds within that region -- if the spring is stretched beyond its elastic limit, the force-extension relationship becomes nonlinear and the graph would no longer be a straight line, invalidating a single-slope determination of k.', ARRAY['b-hookean'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-050 (78097e73-05c4-4498-8407-f9fbc9060755)
update app.content_item_versions set canonical_answer_1 = '(a) Initial gravitational potential energy: PE_i = mgh = (400)(9.80)(20.0) = 78,400 J.

Final kinetic energy: KE_f = (1/2)mv^2 = (0.5)(400)(18.0)^2 = 64,800 J.

The nonconservative work equals the change in mechanical energy: W_nc = (KE_f + PE_f) - (KE_i + PE_i) = (64,800 + 0) - (0 + 78,400) = -13,600 J.

(b) The negative sign indicates that nonconservative forces (friction and air resistance) removed energy from the car-track system during the descent, converting mechanical energy into thermal energy (heat) and other non-mechanical forms (such as sound). This means the car''s total mechanical energy decreased over the descent, rather than being conserved as it would be in the absence of these nonconservative forces.' where id = '78097e73-05c4-4498-8407-f9fbc9060755';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('78097e73-05c4-4498-8407-f9fbc9060755', 'canonical_answer_1', 1, '(a) Initial gravitational potential energy: PE_i = mgh = (400)(9.80)(20.0) = 78,400 J.', ARRAY['a-PE'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('78097e73-05c4-4498-8407-f9fbc9060755', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('78097e73-05c4-4498-8407-f9fbc9060755', 'canonical_answer_1', 3, 'Final kinetic energy: KE_f = (1/2)mv^2 = (0.5)(400)(18.0)^2 = 64,800 J.', ARRAY['a-KE'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('78097e73-05c4-4498-8407-f9fbc9060755', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('78097e73-05c4-4498-8407-f9fbc9060755', 'canonical_answer_1', 5, 'The nonconservative work equals the change in mechanical energy: W_nc = (KE_f + PE_f) - (KE_i + PE_i) = (64,800 + 0) - (0 + 78,400) = -13,600 J.', ARRAY['a-Wnc'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('78097e73-05c4-4498-8407-f9fbc9060755', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('78097e73-05c4-4498-8407-f9fbc9060755', 'canonical_answer_1', 7, '(b) The negative sign indicates that nonconservative forces (friction and air resistance) removed energy from the car-track system during the descent, converting mechanical energy into thermal energy (heat) and other non-mechanical forms (such as sound). This means the car''s total mechanical energy decreased over the descent, rather than being conserved as it would be in the absence of these nonconservative forces.', ARRAY['b-explanation'], 'drafted', 'apphy1_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('408b1a87-6b9a-438d-93e8-9881ea534971'::uuid),('f0613586-dd55-4891-b441-ce9abccc3b28'::uuid),('050bf660-8498-452f-bfad-e521280c3e46'::uuid),('2a52b9bb-636d-43f7-8ffe-d67a746e0bfb'::uuid),('76d2506f-9aeb-4d39-b20d-804df229efd5'::uuid),('78097e73-05c4-4498-8407-f9fbc9060755'::uuid)) as t(vid)
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

-- apphy1-frq-052 (a15042a9-45bb-4ea3-95f9-02f3c208a373)
update app.content_item_versions set canonical_answer_1 = '(a) The free-body diagram for each block shows two forces: weight (mg) directed downward, and string tension (T) directed upward -- no other forces act on either block.

Since the string is light (massless) and inextensible, and the pulley is massless and frictionless, the tension is the same throughout the string, and both blocks have the same magnitude of acceleration (one moving up, the other down, connected by the inextensible string).

Newton''s second law for each block: for the descending 5.00 kg block, m2*g - T = m2*a; for the ascending 3.00 kg block, T - m1*g = m1*a. Adding these two equations eliminates T: m2*g - m1*g = (m1+m2)*a, giving a = (m2-m1)*g/(m1+m2).

a = (5.00-3.00)(9.80)/(5.00+3.00) = (2.00)(9.80)/8.00 = 2.45 m/s^2.

Substituting back: T = m1*(g+a) = 3.00*(9.80+2.45) = 3.00*12.25 = 36.8 N.

(b) With m2 increased to 7.00 kg (m1 = 3.00 kg unchanged): a = (7.00-3.00)(9.80)/(7.00+3.00) = (4.00)(9.80)/10.00 = 3.92 m/s^2.

The acceleration increases because the mass imbalance (m2-m1) doubles from 2.00 kg to 4.00 kg (a factor of 2), while the total mass (m1+m2) increases only from 8.00 kg to 10.00 kg (a factor of 1.25). Since a is proportional to (m2-m1)/(m1+m2), the numerator grows faster (relatively) than the denominator, so the overall acceleration increases.

In the limiting case as m2 approaches infinity (with m1 fixed), a = [(m2-m1)/(m2+m1)]*g approaches g, because the m1 terms in both the numerator and denominator become negligible compared to the very large m2, leaving a ≈ (m2/m2)*g = g -- essentially free-fall for the heavier mass, since the lighter mass offers negligible resistance.' where id = 'a15042a9-45bb-4ea3-95f9-02f3c208a373';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 1, '(a) The free-body diagram for each block shows two forces: weight (mg) directed downward, and string tension (T) directed upward -- no other forces act on either block.', ARRAY['a-fbd'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 3, 'Since the string is light (massless) and inextensible, and the pulley is massless and frictionless, the tension is the same throughout the string, and both blocks have the same magnitude of acceleration (one moving up, the other down, connected by the inextensible string).', ARRAY['a-modeling'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 5, 'Newton''s second law for each block: for the descending 5.00 kg block, m2*g - T = m2*a; for the ascending 3.00 kg block, T - m1*g = m1*a. Adding these two equations eliminates T: m2*g - m1*g = (m1+m2)*a, giving a = (m2-m1)*g/(m1+m2).', ARRAY['a-newton'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 7, 'a = (5.00-3.00)(9.80)/(5.00+3.00) = (2.00)(9.80)/8.00 = 2.45 m/s^2.', ARRAY['a-accel'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 9, 'Substituting back: T = m1*(g+a) = 3.00*(9.80+2.45) = 3.00*12.25 = 36.8 N.', ARRAY['a-tension'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 11, '(b) With m2 increased to 7.00 kg (m1 = 3.00 kg unchanged): a = (7.00-3.00)(9.80)/(7.00+3.00) = (4.00)(9.80)/10.00 = 3.92 m/s^2.', ARRAY['b-new'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 13, 'The acceleration increases because the mass imbalance (m2-m1) doubles from 2.00 kg to 4.00 kg (a factor of 2), while the total mass (m1+m2) increases only from 8.00 kg to 10.00 kg (a factor of 1.25). Since a is proportional to (m2-m1)/(m1+m2), the numerator grows faster (relatively) than the denominator, so the overall acceleration increases.', ARRAY['b-explanation'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('a15042a9-45bb-4ea3-95f9-02f3c208a373', 'canonical_answer_1', 15, 'In the limiting case as m2 approaches infinity (with m1 fixed), a = [(m2-m1)/(m2+m1)]*g approaches g, because the m1 terms in both the numerator and denominator become negligible compared to the very large m2, leaving a ≈ (m2/m2)*g = g -- essentially free-fall for the heavier mass, since the lighter mass offers negligible resistance.', ARRAY['b-limit'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-053 (dc25829e-0b21-4dae-9e99-dbd3f5201651)
update app.content_item_versions set canonical_answer_1 = '(a) The independent variable is the block''s initial speed (at the start of the measured sliding interval).

The dependent variable is the stopping distance.

A control variable to hold constant across trials is the surface (the same block, same surface material, and same surface condition/incline level for every trial).

(b) Using the work-energy theorem: the initial kinetic energy is entirely removed by the work done by friction over the stopping distance d: (1/2)m*v0^2 = μ_k*m*g*d. Solving for μ_k: μ_k = v0^2/(2*g*d).

The block''s mass does not need to be known because it appears on both sides of the energy equation -- the kinetic energy (1/2)m*v0^2 and the friction work μ_k*m*g*d are both directly proportional to m, so m cancels out completely when solving for μ_k, leaving an expression involving only v0, g, and d.' where id = 'dc25829e-0b21-4dae-9e99-dbd3f5201651';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc25829e-0b21-4dae-9e99-dbd3f5201651', 'canonical_answer_1', 1, '(a) The independent variable is the block''s initial speed (at the start of the measured sliding interval).', ARRAY['a-independent'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc25829e-0b21-4dae-9e99-dbd3f5201651', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc25829e-0b21-4dae-9e99-dbd3f5201651', 'canonical_answer_1', 3, 'The dependent variable is the stopping distance.', ARRAY['a-dependent'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc25829e-0b21-4dae-9e99-dbd3f5201651', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc25829e-0b21-4dae-9e99-dbd3f5201651', 'canonical_answer_1', 5, 'A control variable to hold constant across trials is the surface (the same block, same surface material, and same surface condition/incline level for every trial).', ARRAY['a-control'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc25829e-0b21-4dae-9e99-dbd3f5201651', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc25829e-0b21-4dae-9e99-dbd3f5201651', 'canonical_answer_1', 7, '(b) Using the work-energy theorem: the initial kinetic energy is entirely removed by the work done by friction over the stopping distance d: (1/2)m*v0^2 = μ_k*m*g*d. Solving for μ_k: μ_k = v0^2/(2*g*d).', ARRAY['b-derivation'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc25829e-0b21-4dae-9e99-dbd3f5201651', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('dc25829e-0b21-4dae-9e99-dbd3f5201651', 'canonical_answer_1', 9, 'The block''s mass does not need to be known because it appears on both sides of the energy equation -- the kinetic energy (1/2)m*v0^2 and the friction work μ_k*m*g*d are both directly proportional to m, so m cancels out completely when solving for μ_k, leaving an expression involving only v0, g, and d.', ARRAY['b-massexplanation'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-054 (4c283652-3ddd-4d93-99f7-186acbed682d)
update app.content_item_versions set canonical_answer_1 = '(a) With v0x = v0*cos(theta) and v0y = v0*sin(theta), and time of flight t = 2*v0y/g (from the vertical motion returning to the launch height), the range is R = v0x*t = v0*cos(theta) * [2*v0*sin(theta)/g] = 2*v0^2*sin(theta)*cos(theta)/g = v0^2*sin(2*theta)/g (using the double-angle identity 2*sin(theta)*cos(theta)=sin(2*theta)).

Numerically: v0y = 25.0*sin(40.0°) = 25.0*0.6428 ≈ 16.07 m/s. Time of flight t = 2*v0y/g = 2*(16.07)/9.80 ≈ 3.28 s.

Maximum height H = v0y^2/(2g) = (16.07)^2/(2*9.80) = 258.2/19.6 ≈ 13.2 m.

Range R = v0^2*sin(2*theta)/g = (25.0)^2*sin(80.0°)/9.80 = 625*0.9848/9.80 ≈ 62.8 m.

(b) For a launch at 50.0° at the same speed 25.0 m/s: R = (25.0)^2*sin(100.0°)/9.80 = 625*0.9848/9.80 ≈ 62.8 m -- the same range as the 40.0° launch in part (a).

This is because range depends on sin(2*theta), and 40° and 50° are complementary angles (they sum to 90°). Doubling each gives 2×40°=80° and 2×50°=100°, which are supplementary angles (they sum to 180°). By the identity sin(180°-x)=sin(x), sin(80°) and sin(100°) are exactly equal, so the two ranges -- both proportional to sin(2*theta) -- come out exactly equal despite the different launch angles.' where id = '4c283652-3ddd-4d93-99f7-186acbed682d';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 1, '(a) With v0x = v0*cos(theta) and v0y = v0*sin(theta), and time of flight t = 2*v0y/g (from the vertical motion returning to the launch height), the range is R = v0x*t = v0*cos(theta) * [2*v0*sin(theta)/g] = 2*v0^2*sin(theta)*cos(theta)/g = v0^2*sin(2*theta)/g (using the double-angle identity 2*sin(theta)*cos(theta)=sin(2*theta)).', ARRAY['a-symbolic-range'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 3, 'Numerically: v0y = 25.0*sin(40.0°) = 25.0*0.6428 ≈ 16.07 m/s. Time of flight t = 2*v0y/g = 2*(16.07)/9.80 ≈ 3.28 s.', ARRAY['a-time'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 5, 'Maximum height H = v0y^2/(2g) = (16.07)^2/(2*9.80) = 258.2/19.6 ≈ 13.2 m.', ARRAY['a-height'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 7, 'Range R = v0^2*sin(2*theta)/g = (25.0)^2*sin(80.0°)/9.80 = 625*0.9848/9.80 ≈ 62.8 m.', ARRAY['a-range'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 9, '(b) For a launch at 50.0° at the same speed 25.0 m/s: R = (25.0)^2*sin(100.0°)/9.80 = 625*0.9848/9.80 ≈ 62.8 m -- the same range as the 40.0° launch in part (a).', ARRAY['b-50deg-range'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c283652-3ddd-4d93-99f7-186acbed682d', 'canonical_answer_1', 11, 'This is because range depends on sin(2*theta), and 40° and 50° are complementary angles (they sum to 90°). Doubling each gives 2×40°=80° and 2×50°=100°, which are supplementary angles (they sum to 180°). By the identity sin(180°-x)=sin(x), sin(80°) and sin(100°) are exactly equal, so the two ranges -- both proportional to sin(2*theta) -- come out exactly equal despite the different launch angles.', ARRAY['b-symmetry-explanation'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-055 (c565c13b-b3b4-41f0-ab4c-206673372e1b)
update app.content_item_versions set canonical_answer_1 = '(a) For this conical pendulum, the radius of the circular path is r = L*sin(theta) = (1.20)*sin(25.0°) = (1.20)(0.4226) ≈ 0.507 m.

From vertical equilibrium (the vertical component of tension balances gravity): T*cos(theta) = mg, so T = mg/cos(theta) = (0.500)(9.80)/cos(25.0°) = 4.90/0.9063 ≈ 5.41 N.

(b) From the horizontal net-force equation (the horizontal component of tension provides the centripetal force): T*sin(theta) = mv^2/r. Solving: v^2 = T*sin(theta)*r/m = (5.41)(0.4226)(0.507)/(0.500) ≈ 2.317, so v ≈ 1.52 m/s.

The period is the circumference divided by the speed: T_p = 2*pi*r/v = 2*pi*(0.507)/(1.52) ≈ 2.09 s.' where id = 'c565c13b-b3b4-41f0-ab4c-206673372e1b';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c565c13b-b3b4-41f0-ab4c-206673372e1b', 'canonical_answer_1', 1, '(a) For this conical pendulum, the radius of the circular path is r = L*sin(theta) = (1.20)*sin(25.0°) = (1.20)(0.4226) ≈ 0.507 m.', ARRAY['a-radius'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c565c13b-b3b4-41f0-ab4c-206673372e1b', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c565c13b-b3b4-41f0-ab4c-206673372e1b', 'canonical_answer_1', 3, 'From vertical equilibrium (the vertical component of tension balances gravity): T*cos(theta) = mg, so T = mg/cos(theta) = (0.500)(9.80)/cos(25.0°) = 4.90/0.9063 ≈ 5.41 N.', ARRAY['a-tension'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c565c13b-b3b4-41f0-ab4c-206673372e1b', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c565c13b-b3b4-41f0-ab4c-206673372e1b', 'canonical_answer_1', 5, '(b) From the horizontal net-force equation (the horizontal component of tension provides the centripetal force): T*sin(theta) = mv^2/r. Solving: v^2 = T*sin(theta)*r/m = (5.41)(0.4226)(0.507)/(0.500) ≈ 2.317, so v ≈ 1.52 m/s.', ARRAY['b-speed'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c565c13b-b3b4-41f0-ab4c-206673372e1b', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('c565c13b-b3b4-41f0-ab4c-206673372e1b', 'canonical_answer_1', 7, 'The period is the circumference divided by the speed: T_p = 2*pi*r/v = 2*pi*(0.507)/(1.52) ≈ 2.09 s.', ARRAY['b-period'], 'drafted', 'apphy1_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('a15042a9-45bb-4ea3-95f9-02f3c208a373'::uuid),('dc25829e-0b21-4dae-9e99-dbd3f5201651'::uuid),('4c283652-3ddd-4d93-99f7-186acbed682d'::uuid),('c565c13b-b3b4-41f0-ab4c-206673372e1b'::uuid)) as t(vid)
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

-- apphy1-frq-056 (9cac395c-05da-4b9e-bb3c-f6d3905238bf)
update app.content_item_versions set canonical_answer_1 = '(a) By energy conservation on the frictionless first incline: v1 = sqrt(2*g*h1) = sqrt(2*9.80*2.00) = sqrt(39.2) ≈ 6.26 m/s.

For the second incline (angle theta=30.0°, friction coefficient μ_k=0.300), setting the kinetic energy at the bottom equal to the gravitational potential energy gained plus the energy lost to friction over the incline distance d=h2/sin(theta): (1/2)*v1^2 = g*h2 + μ_k*g*cos(theta)*[h2/sin(theta)].

Solving for h2: h2 = (1/2)*v1^2*sin(theta) / [g*(sin(theta)+μ_k*cos(theta))] = (19.6)(0.500) / [9.80*(0.500+0.300*0.8660)] = 9.80/[9.80*0.7598] ≈ 1.32 m.

(b) Doubling the friction coefficient to 0.600 decreases the maximum height on the second incline.

With μ_k=0.600: h2 = (19.6)(0.500)/[9.80*(0.500+0.600*0.8660)] = 9.80/[9.80*1.0196] ≈ 0.981 m.

The height depends on μ_k through the term (sin(theta)+μ_k*cos(theta)) in the denominator -- this term is not itself proportional to μ_k, because of the additive sin(theta) term that does not change with friction. So doubling μ_k does not simply halve the height (it went from 1.32 m to 0.981 m, a smaller reduction than a full halving), even though doubling μ_k does increase the frictional energy loss per meter traveled along the incline.' where id = '9cac395c-05da-4b9e-bb3c-f6d3905238bf';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 1, '(a) By energy conservation on the frictionless first incline: v1 = sqrt(2*g*h1) = sqrt(2*9.80*2.00) = sqrt(39.2) ≈ 6.26 m/s.', ARRAY['a-speed'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 3, 'For the second incline (angle theta=30.0°, friction coefficient μ_k=0.300), setting the kinetic energy at the bottom equal to the gravitational potential energy gained plus the energy lost to friction over the incline distance d=h2/sin(theta): (1/2)*v1^2 = g*h2 + μ_k*g*cos(theta)*[h2/sin(theta)].', ARRAY['a-setup'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 5, 'Solving for h2: h2 = (1/2)*v1^2*sin(theta) / [g*(sin(theta)+μ_k*cos(theta))] = (19.6)(0.500) / [9.80*(0.500+0.300*0.8660)] = 9.80/[9.80*0.7598] ≈ 1.32 m.', ARRAY['a-height'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 7, '(b) Doubling the friction coefficient to 0.600 decreases the maximum height on the second incline.', ARRAY['b-prediction'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 9, 'With μ_k=0.600: h2 = (19.6)(0.500)/[9.80*(0.500+0.600*0.8660)] = 9.80/[9.80*1.0196] ≈ 0.981 m.', ARRAY['b-newvalue'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf', 'canonical_answer_1', 11, 'The height depends on μ_k through the term (sin(theta)+μ_k*cos(theta)) in the denominator -- this term is not itself proportional to μ_k, because of the additive sin(theta) term that does not change with friction. So doubling μ_k does not simply halve the height (it went from 1.32 m to 0.981 m, a smaller reduction than a full halving), even though doubling μ_k does increase the frictional energy loss per meter traveled along the incline.', ARRAY['b-explanation'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-057 (105deb51-6c66-415d-8537-28d22a54d095)
update app.content_item_versions set canonical_answer_1 = '(a) The independent variable is the presence (or magnitude) of horizontal launch velocity -- one ball is launched horizontally, the other simply dropped (zero horizontal velocity).

The dependent variable is the time for each ball to hit the ground.

One control variable is the release height (both balls start from the same 0.800 m table height).

A second control variable is releasing both balls simultaneously, and using identical balls (same mass and size) for both trials.

(b) If both balls land at the same time despite one having horizontal velocity and the other having none, this would confirm that the vertical motion (and therefore the fall time) is unaffected by horizontal motion -- i.e., that horizontal and vertical motions are independent.

Negligible air resistance is a necessary assumption for this conclusion to hold, because if air resistance were significant, drag would depend on the ball''s total speed (which is higher for the horizontally-launched ball due to its horizontal component), coupling the horizontal motion to the vertical deceleration -- this would make the landing times differ even if the underlying physics still had independent horizontal/vertical components in the absence of air resistance, breaking the clean experimental confirmation.

(c) Using h=(1/2)g*t^2 with h=0.800 m: t=sqrt(2h/g)=sqrt(2*0.800/9.80)=sqrt(0.16327)≈0.404 s, the same predicted fall time for both balls.

Horizontal launch speed does not appear anywhere in the equation h=(1/2)g*t^2 -- this equation involves only the vertical drop height h, gravitational acceleration g, and time t -- so the calculated fall time is mathematically independent of whatever horizontal speed the ball might have.' where id = '105deb51-6c66-415d-8537-28d22a54d095';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 1, '(a) The independent variable is the presence (or magnitude) of horizontal launch velocity -- one ball is launched horizontally, the other simply dropped (zero horizontal velocity).', ARRAY['a-independent'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 3, 'The dependent variable is the time for each ball to hit the ground.', ARRAY['a-dependent'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 5, 'One control variable is the release height (both balls start from the same 0.800 m table height).', ARRAY['a-control1'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 7, 'A second control variable is releasing both balls simultaneously, and using identical balls (same mass and size) for both trials.', ARRAY['a-control2'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 9, '(b) If both balls land at the same time despite one having horizontal velocity and the other having none, this would confirm that the vertical motion (and therefore the fall time) is unaffected by horizontal motion -- i.e., that horizontal and vertical motions are independent.', ARRAY['b-confirmation'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 11, 'Negligible air resistance is a necessary assumption for this conclusion to hold, because if air resistance were significant, drag would depend on the ball''s total speed (which is higher for the horizontally-launched ball due to its horizontal component), coupling the horizontal motion to the vertical deceleration -- this would make the landing times differ even if the underlying physics still had independent horizontal/vertical components in the absence of air resistance, breaking the clean experimental confirmation.', ARRAY['b-airresistance'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 13, '(c) Using h=(1/2)g*t^2 with h=0.800 m: t=sqrt(2h/g)=sqrt(2*0.800/9.80)=sqrt(0.16327)≈0.404 s, the same predicted fall time for both balls.', ARRAY['c-calculation'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('105deb51-6c66-415d-8537-28d22a54d095', 'canonical_answer_1', 15, 'Horizontal launch speed does not appear anywhere in the equation h=(1/2)g*t^2 -- this equation involves only the vertical drop height h, gravitational acceleration g, and time t -- so the calculated fall time is mathematically independent of whatever horizontal speed the ball might have.', ARRAY['c-mechanism'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-058 (26b34dfd-f85b-4520-97e5-de69f04c4940)
update app.content_item_versions set canonical_answer_1 = '(a) The hanging mass (m2=2.00 kg) has two forces: weight m2*g downward and tension T upward. The incline block (m1=4.00 kg) has four forces: the weight component m1*g*sin(theta) directed down the incline, the weight component m1*g*cos(theta) directed into the incline (perpendicular), the normal force N perpendicular to and away from the incline surface, and the tension T directed up the incline.

Newton''s second law: for the hanging mass (taking downward as positive, per the problem''s sign convention), m2*g - T = m2*a. For the incline block (taking up-the-incline as positive), T - m1*g*sin(theta) = m1*a.

Adding these two equations to eliminate T: m2*g - m1*g*sin(theta) = (m1+m2)*a, so a = g*(m2 - m1*sin(theta))/(m1+m2) = 9.80*(2.00 - 4.00*sin(20.0°))/(6.00) = 9.80*(2.00-1.368)/6.00 = 9.80*0.632/6.00 ≈ 1.03 m/s^2.

Substituting back into the hanging-mass equation: T = m2*(g-a) = 2.00*(9.80-1.03) = 2.00*8.77 ≈ 17.5 N.

(b) The positive value of the calculated acceleration confirms the assumed direction is correct: the hanging mass does descend while the incline block slides up the incline, as the problem''s sign convention defined as positive.

The threshold hanging mass occurs where the net force is exactly zero, i.e. where m2*g = m1*g*sin(theta): m2 = m1*sin(theta) = 4.00*sin(20.0°) = 4.00*0.3420 ≈ 1.37 kg.

If the hanging mass is reduced below this threshold (1.37 kg), the net force reverses direction: the incline block''s weight component down the incline (m1*g*sin(theta)) now exceeds the hanging mass''s weight (m2*g), so the block would instead slide down the incline while pulling the hanging mass upward. Since this system is frictionless, it cannot simply remain at rest once below the threshold -- with no friction available to hold it static against a nonzero net force in the reversed direction, the system must accelerate from rest in that reversed direction.' where id = '26b34dfd-f85b-4520-97e5-de69f04c4940';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 1, '(a) The hanging mass (m2=2.00 kg) has two forces: weight m2*g downward and tension T upward. The incline block (m1=4.00 kg) has four forces: the weight component m1*g*sin(theta) directed down the incline, the weight component m1*g*cos(theta) directed into the incline (perpendicular), the normal force N perpendicular to and away from the incline surface, and the tension T directed up the incline.', ARRAY['a-fbd'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 3, 'Newton''s second law: for the hanging mass (taking downward as positive, per the problem''s sign convention), m2*g - T = m2*a. For the incline block (taking up-the-incline as positive), T - m1*g*sin(theta) = m1*a.', ARRAY['a-setup'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 5, 'Adding these two equations to eliminate T: m2*g - m1*g*sin(theta) = (m1+m2)*a, so a = g*(m2 - m1*sin(theta))/(m1+m2) = 9.80*(2.00 - 4.00*sin(20.0°))/(6.00) = 9.80*(2.00-1.368)/6.00 = 9.80*0.632/6.00 ≈ 1.03 m/s^2.', ARRAY['a-accel'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 7, 'Substituting back into the hanging-mass equation: T = m2*(g-a) = 2.00*(9.80-1.03) = 2.00*8.77 ≈ 17.5 N.', ARRAY['a-tension'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 9, '(b) The positive value of the calculated acceleration confirms the assumed direction is correct: the hanging mass does descend while the incline block slides up the incline, as the problem''s sign convention defined as positive.', ARRAY['b-directionmeaning'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 11, 'The threshold hanging mass occurs where the net force is exactly zero, i.e. where m2*g = m1*g*sin(theta): m2 = m1*sin(theta) = 4.00*sin(20.0°) = 4.00*0.3420 ≈ 1.37 kg.', ARRAY['b-threshold'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('26b34dfd-f85b-4520-97e5-de69f04c4940', 'canonical_answer_1', 13, 'If the hanging mass is reduced below this threshold (1.37 kg), the net force reverses direction: the incline block''s weight component down the incline (m1*g*sin(theta)) now exceeds the hanging mass''s weight (m2*g), so the block would instead slide down the incline while pulling the hanging mass upward. Since this system is frictionless, it cannot simply remain at rest once below the threshold -- with no friction available to hold it static against a nonzero net force in the reversed direction, the system must accelerate from rest in that reversed direction.', ARRAY['b-reduced'], 'drafted', 'apphy1_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('9cac395c-05da-4b9e-bb3c-f6d3905238bf'::uuid),('105deb51-6c66-415d-8537-28d22a54d095'::uuid),('26b34dfd-f85b-4520-97e5-de69f04c4940'::uuid)) as t(vid)
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

-- apphy1-frq-np2-007 (01e51098-a810-4cdf-9be9-e6e98c7be0ea)
update app.content_item_versions set canonical_answer_1 = '(a) The period of a mass-spring oscillator is T=2*pi*sqrt(m/k)=2*pi*sqrt(0.50/200)=2*pi*sqrt(0.0025)=2*pi*(0.0500)≈0.314 s. The frequency is f=1/T=1/0.314≈3.18 Hz.

(b) The total mechanical energy is E=(1/2)kA^2=(0.5)(200)(0.10)^2=(0.5)(200)(0.0100)=1.00 J. The maximum speed occurs at equilibrium, where all energy is kinetic: E=(1/2)mv_max^2, so v_max=sqrt(2E/m)=sqrt(2*1.00/0.50)=sqrt(4.00)=2.00 m/s.

(c) The student''s error is that they measured only a half-cycle, not a full period: going from the release point (maximum displacement on one side) to the corresponding point 0.10 m on the opposite side is only half of one complete oscillation, since a full period requires returning to the SAME position moving in the SAME direction as at the start -- not simply reaching the mirror-image point on the other side. Since the measured 0.157 s corresponds to only half the period, the correct period is twice this value: 2*(0.157)≈0.314 s, matching the calculated value in part (a).

(d) With the block released from 0.20 m instead of 0.10 m: the period remains unchanged at approximately 0.314 s, since the period of an ideal simple harmonic oscillator does not depend on amplitude. The total mechanical energy quadruples to 4.00 J, since E=(1/2)kA^2 is proportional to the square of the amplitude, and doubling A (from 0.10 to 0.20 m) quadruples A^2. The maximum speed doubles to 4.00 m/s, since v_max=sqrt(2E/m) and E has quadrupled, so v_max increases by a factor of sqrt(4)=2 (equivalently, v_max is directly proportional to A, so doubling A directly doubles v_max).' where id = '01e51098-a810-4cdf-9be9-e6e98c7be0ea';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('01e51098-a810-4cdf-9be9-e6e98c7be0ea', 'canonical_answer_1', 1, '(a) The period of a mass-spring oscillator is T=2*pi*sqrt(m/k)=2*pi*sqrt(0.50/200)=2*pi*sqrt(0.0025)=2*pi*(0.0500)≈0.314 s. The frequency is f=1/T=1/0.314≈3.18 Hz.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('01e51098-a810-4cdf-9be9-e6e98c7be0ea', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('01e51098-a810-4cdf-9be9-e6e98c7be0ea', 'canonical_answer_1', 3, '(b) The total mechanical energy is E=(1/2)kA^2=(0.5)(200)(0.10)^2=(0.5)(200)(0.0100)=1.00 J. The maximum speed occurs at equilibrium, where all energy is kinetic: E=(1/2)mv_max^2, so v_max=sqrt(2E/m)=sqrt(2*1.00/0.50)=sqrt(4.00)=2.00 m/s.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('01e51098-a810-4cdf-9be9-e6e98c7be0ea', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('01e51098-a810-4cdf-9be9-e6e98c7be0ea', 'canonical_answer_1', 5, '(c) The student''s error is that they measured only a half-cycle, not a full period: going from the release point (maximum displacement on one side) to the corresponding point 0.10 m on the opposite side is only half of one complete oscillation, since a full period requires returning to the SAME position moving in the SAME direction as at the start -- not simply reaching the mirror-image point on the other side. Since the measured 0.157 s corresponds to only half the period, the correct period is twice this value: 2*(0.157)≈0.314 s, matching the calculated value in part (a).', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('01e51098-a810-4cdf-9be9-e6e98c7be0ea', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('01e51098-a810-4cdf-9be9-e6e98c7be0ea', 'canonical_answer_1', 7, '(d) With the block released from 0.20 m instead of 0.10 m: the period remains unchanged at approximately 0.314 s, since the period of an ideal simple harmonic oscillator does not depend on amplitude. The total mechanical energy quadruples to 4.00 J, since E=(1/2)kA^2 is proportional to the square of the amplitude, and doubling A (from 0.10 to 0.20 m) quadruples A^2. The maximum speed doubles to 4.00 m/s, since v_max=sqrt(2E/m) and E has quadrupled, so v_max increases by a factor of sqrt(4)=2 (equivalently, v_max is directly proportional to A, so doubling A directly doubles v_max).', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-np1-001 (40c3850d-f7e1-4ad7-bde8-0ff27230d22c)
update app.content_item_versions set canonical_answer_1 = '(a) v = v0 + at = 0 + (2)(6) = 12 m/s at t=6 s.

(b) First-phase displacement: x = v0*t + (1/2)a*t^2 = 0 + (0.5)(2)(6)^2 = (0.5)(2)(36) = 36 m.

(c) Second-phase displacement (constant velocity 12 m/s for 4 s): x = v*t = (12)(4) = 48 m.

(d) Total displacement = 36 + 48 = 84 m.' where id = '40c3850d-f7e1-4ad7-bde8-0ff27230d22c';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('40c3850d-f7e1-4ad7-bde8-0ff27230d22c', 'canonical_answer_1', 1, '(a) v = v0 + at = 0 + (2)(6) = 12 m/s at t=6 s.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('40c3850d-f7e1-4ad7-bde8-0ff27230d22c', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('40c3850d-f7e1-4ad7-bde8-0ff27230d22c', 'canonical_answer_1', 3, '(b) First-phase displacement: x = v0*t + (1/2)a*t^2 = 0 + (0.5)(2)(6)^2 = (0.5)(2)(36) = 36 m.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('40c3850d-f7e1-4ad7-bde8-0ff27230d22c', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('40c3850d-f7e1-4ad7-bde8-0ff27230d22c', 'canonical_answer_1', 5, '(c) Second-phase displacement (constant velocity 12 m/s for 4 s): x = v*t = (12)(4) = 48 m.', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('40c3850d-f7e1-4ad7-bde8-0ff27230d22c', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('40c3850d-f7e1-4ad7-bde8-0ff27230d22c', 'canonical_answer_1', 7, '(d) Total displacement = 36 + 48 = 84 m.', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-np1-002 (4c413573-a128-4274-a44c-2bacd6289897)
update app.content_item_versions set canonical_answer_1 = '(a) The acceleration is the slope of the v-t graph over 0-4s: a = (0-4)/(4-0) = -1 m/s^2.

(b) The displacement is the area under the v-t graph (a triangle) for 0-4s: (1/2)(4)(4) = 8 m.

(c) From t=0 to t=4s, the position-time graph is concave down (curving with continuously decreasing slope), since velocity is decreasing over this interval (the slope of x-t equals v, and v is decreasing). From t=4s to t=6s, the position-time graph becomes a horizontal flat line, since velocity is constant at 0 (the object is not moving, so position stays fixed).

(d) a = 0 for 4s ≤ t ≤ 6s, since velocity is constant (zero slope on the v-t graph) over that interval.' where id = '4c413573-a128-4274-a44c-2bacd6289897';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c413573-a128-4274-a44c-2bacd6289897', 'canonical_answer_1', 1, '(a) The acceleration is the slope of the v-t graph over 0-4s: a = (0-4)/(4-0) = -1 m/s^2.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c413573-a128-4274-a44c-2bacd6289897', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c413573-a128-4274-a44c-2bacd6289897', 'canonical_answer_1', 3, '(b) The displacement is the area under the v-t graph (a triangle) for 0-4s: (1/2)(4)(4) = 8 m.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c413573-a128-4274-a44c-2bacd6289897', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c413573-a128-4274-a44c-2bacd6289897', 'canonical_answer_1', 5, '(c) From t=0 to t=4s, the position-time graph is concave down (curving with continuously decreasing slope), since velocity is decreasing over this interval (the slope of x-t equals v, and v is decreasing). From t=4s to t=6s, the position-time graph becomes a horizontal flat line, since velocity is constant at 0 (the object is not moving, so position stays fixed).', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c413573-a128-4274-a44c-2bacd6289897', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('4c413573-a128-4274-a44c-2bacd6289897', 'canonical_answer_1', 7, '(d) a = 0 for 4s ≤ t ≤ 6s, since velocity is constant (zero slope on the v-t graph) over that interval.', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-np1-003 (64f59454-5f26-4483-8407-7202ed6f8142)
update app.content_item_versions set canonical_answer_1 = '(a) Using the vertical kinematic equation with v0y=0 and h=20 m: h=(1/2)g*t^2, so t=sqrt(2h/g)=sqrt(2*20/10)=sqrt(4)=2 s.

(b) Horizontal distance: x=v0x*t=(8)(2)=16 m.

(c) Vertical velocity at landing: vy=g*t=(10)(2)=20 m/s. Taking upward as positive, this is -20 m/s (directed downward).

(d) The horizontal velocity is unchanged throughout the flight because there is no horizontal force (and therefore no horizontal acceleration) acting on the ball once it is launched -- air resistance is negligible, and gravity, the only force acting, is purely vertical, so it has no effect on the horizontal component of velocity.' where id = '64f59454-5f26-4483-8407-7202ed6f8142';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('64f59454-5f26-4483-8407-7202ed6f8142', 'canonical_answer_1', 1, '(a) Using the vertical kinematic equation with v0y=0 and h=20 m: h=(1/2)g*t^2, so t=sqrt(2h/g)=sqrt(2*20/10)=sqrt(4)=2 s.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('64f59454-5f26-4483-8407-7202ed6f8142', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('64f59454-5f26-4483-8407-7202ed6f8142', 'canonical_answer_1', 3, '(b) Horizontal distance: x=v0x*t=(8)(2)=16 m.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('64f59454-5f26-4483-8407-7202ed6f8142', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('64f59454-5f26-4483-8407-7202ed6f8142', 'canonical_answer_1', 5, '(c) Vertical velocity at landing: vy=g*t=(10)(2)=20 m/s. Taking upward as positive, this is -20 m/s (directed downward).', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('64f59454-5f26-4483-8407-7202ed6f8142', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('64f59454-5f26-4483-8407-7202ed6f8142', 'canonical_answer_1', 7, '(d) The horizontal velocity is unchanged throughout the flight because there is no horizontal force (and therefore no horizontal acceleration) acting on the ball once it is launched -- air resistance is negligible, and gravity, the only force acting, is purely vertical, so it has no effect on the horizontal component of velocity.', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-np1-004 (91ea2d10-2353-4956-a83a-6f0be6d6f6fd)
update app.content_item_versions set canonical_answer_1 = '(a) On this horizontal surface with a purely horizontal applied force, the normal force balances gravity: N=mg=(5)(10)=50 N.

(b) Kinetic friction: F_f,k=mu_k*N=(0.2)(50)=10 N.

(c) Net horizontal force: F_net=F_applied-F_f,k=20-10=10 N.

(d) Acceleration: a=F_net/m=10/5=2 m/s^2.' where id = '91ea2d10-2353-4956-a83a-6f0be6d6f6fd';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('91ea2d10-2353-4956-a83a-6f0be6d6f6fd', 'canonical_answer_1', 1, '(a) On this horizontal surface with a purely horizontal applied force, the normal force balances gravity: N=mg=(5)(10)=50 N.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('91ea2d10-2353-4956-a83a-6f0be6d6f6fd', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('91ea2d10-2353-4956-a83a-6f0be6d6f6fd', 'canonical_answer_1', 3, '(b) Kinetic friction: F_f,k=mu_k*N=(0.2)(50)=10 N.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('91ea2d10-2353-4956-a83a-6f0be6d6f6fd', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('91ea2d10-2353-4956-a83a-6f0be6d6f6fd', 'canonical_answer_1', 5, '(c) Net horizontal force: F_net=F_applied-F_f,k=20-10=10 N.', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('91ea2d10-2353-4956-a83a-6f0be6d6f6fd', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('91ea2d10-2353-4956-a83a-6f0be6d6f6fd', 'canonical_answer_1', 7, '(d) Acceleration: a=F_net/m=10/5=2 m/s^2.', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-np1-005 (591e865e-e2ab-410d-9c6b-1ec7e79e2379)
update app.content_item_versions set canonical_answer_1 = '(a) The component of weight parallel to the incline: mg*sin(30°)=(4)(10)(0.5)=20 N.

(b) On this frictionless incline, the normal force equals the perpendicular component of weight: N=mg*cos(30°)=(4)(10)(0.866)≈34.6 N.

(c) Acceleration down the incline: a=g*sin(30°)=(10)(0.5)=5 m/s^2 (equivalently, the parallel force component from part (a) divided by mass: 20/4=5 m/s^2).

(d) The normal force only balances the perpendicular component of gravity (mg*cos(30°)=34.6 N) -- it does not need to balance the full weight, since the incline surface is only oriented to resist the perpendicular component. The parallel component of gravity (mg*sin(30°)=20 N) is left unbalanced and is exactly what produces the block''s acceleration down the incline. Since the normal force only balances part of the weight (the perpendicular component) rather than the whole 40 N weight, it is necessarily less than the full weight.' where id = '591e865e-e2ab-410d-9c6b-1ec7e79e2379';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('591e865e-e2ab-410d-9c6b-1ec7e79e2379', 'canonical_answer_1', 1, '(a) The component of weight parallel to the incline: mg*sin(30°)=(4)(10)(0.5)=20 N.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('591e865e-e2ab-410d-9c6b-1ec7e79e2379', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('591e865e-e2ab-410d-9c6b-1ec7e79e2379', 'canonical_answer_1', 3, '(b) On this frictionless incline, the normal force equals the perpendicular component of weight: N=mg*cos(30°)=(4)(10)(0.866)≈34.6 N.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('591e865e-e2ab-410d-9c6b-1ec7e79e2379', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('591e865e-e2ab-410d-9c6b-1ec7e79e2379', 'canonical_answer_1', 5, '(c) Acceleration down the incline: a=g*sin(30°)=(10)(0.5)=5 m/s^2 (equivalently, the parallel force component from part (a) divided by mass: 20/4=5 m/s^2).', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('591e865e-e2ab-410d-9c6b-1ec7e79e2379', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('591e865e-e2ab-410d-9c6b-1ec7e79e2379', 'canonical_answer_1', 7, '(d) The normal force only balances the perpendicular component of gravity (mg*cos(30°)=34.6 N) -- it does not need to balance the full weight, since the incline surface is only oriented to resist the perpendicular component. The parallel component of gravity (mg*sin(30°)=20 N) is left unbalanced and is exactly what produces the block''s acceleration down the incline. Since the normal force only balances part of the weight (the perpendicular component) rather than the whole 40 N weight, it is necessarily less than the full weight.', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('01e51098-a810-4cdf-9be9-e6e98c7be0ea'::uuid),('40c3850d-f7e1-4ad7-bde8-0ff27230d22c'::uuid),('4c413573-a128-4274-a44c-2bacd6289897'::uuid),('64f59454-5f26-4483-8407-7202ed6f8142'::uuid),('91ea2d10-2353-4956-a83a-6f0be6d6f6fd'::uuid),('591e865e-e2ab-410d-9c6b-1ec7e79e2379'::uuid)) as t(vid)
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

-- apphy1-frq-np1-006 (1200ff17-ed8a-433f-ae65-efd3c136bcd0)
update app.content_item_versions set canonical_answer_1 = '(a) At the minimum speed for maintaining contact at the top, gravity alone provides the required centripetal force (normal force is zero): mg=mv^2/r, so v=sqrt(gr)=sqrt((10)(1.5))=sqrt(15)≈3.87 m/s.

(b) At this minimum speed, the normal force is 0 N, since gravity alone exactly supplies the needed centripetal force, leaving nothing for the track to contribute.

(c) When speed exceeds this minimum, the normal force is directed downward, toward the center of the loop. This is because the track can only push on the ball (not pull), and at the top of a vertical loop, the center of the circular path is below the ball -- so any force the track exerts on the ball at that point must point toward the center, i.e. downward.

(d) The normal force would be greater than the value found in part (b) (i.e., greater than 0 N). At a higher speed, more centripetal force is required to maintain the circular path; since gravity alone only supplies mg (a fixed amount) but the required centripetal force mv^2/r is now larger, the track must supply the additional centripetal force via a nonzero (and larger, as speed increases further) normal force.' where id = '1200ff17-ed8a-433f-ae65-efd3c136bcd0';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1200ff17-ed8a-433f-ae65-efd3c136bcd0', 'canonical_answer_1', 1, '(a) At the minimum speed for maintaining contact at the top, gravity alone provides the required centripetal force (normal force is zero): mg=mv^2/r, so v=sqrt(gr)=sqrt((10)(1.5))=sqrt(15)≈3.87 m/s.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1200ff17-ed8a-433f-ae65-efd3c136bcd0', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1200ff17-ed8a-433f-ae65-efd3c136bcd0', 'canonical_answer_1', 3, '(b) At this minimum speed, the normal force is 0 N, since gravity alone exactly supplies the needed centripetal force, leaving nothing for the track to contribute.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1200ff17-ed8a-433f-ae65-efd3c136bcd0', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1200ff17-ed8a-433f-ae65-efd3c136bcd0', 'canonical_answer_1', 5, '(c) When speed exceeds this minimum, the normal force is directed downward, toward the center of the loop. This is because the track can only push on the ball (not pull), and at the top of a vertical loop, the center of the circular path is below the ball -- so any force the track exerts on the ball at that point must point toward the center, i.e. downward.', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1200ff17-ed8a-433f-ae65-efd3c136bcd0', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('1200ff17-ed8a-433f-ae65-efd3c136bcd0', 'canonical_answer_1', 7, '(d) The normal force would be greater than the value found in part (b) (i.e., greater than 0 N). At a higher speed, more centripetal force is required to maintain the circular path; since gravity alone only supplies mg (a fixed amount) but the required centripetal force mv^2/r is now larger, the track must supply the additional centripetal force via a nonzero (and larger, as speed increases further) normal force.', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-np1-007 (664f7767-66a4-49c6-9959-452e6c5e8666)
update app.content_item_versions set canonical_answer_1 = '(a) Vertical equilibrium: N*cos(theta)=mg. Horizontal (centripetal) direction: N*sin(theta)=mv^2/r. Dividing the second equation by the first: [N*sin(theta)]/[N*cos(theta)] = [mv^2/r]/[mg], which simplifies to tan(theta)=v^2/(rg).

(b) Solving for v^2: v^2=rg*tan(theta)=(50)(10)(0.364)=182 m^2/s^2.

(c) v=sqrt(182)≈13.5 m/s.

(d) Without friction, if the car travels faster than this speed, the normal force (which can only act perpendicular to the banked surface) can no longer supply enough centripetal force to keep the car on its circular path at radius r -- the car tends to slide up and outward along the banked surface, moving toward a larger effective radius, since there is no friction available to supply the extra inward force that would be needed to keep it on the original path.' where id = '664f7767-66a4-49c6-9959-452e6c5e8666';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('664f7767-66a4-49c6-9959-452e6c5e8666', 'canonical_answer_1', 1, '(a) Vertical equilibrium: N*cos(theta)=mg. Horizontal (centripetal) direction: N*sin(theta)=mv^2/r. Dividing the second equation by the first: [N*sin(theta)]/[N*cos(theta)] = [mv^2/r]/[mg], which simplifies to tan(theta)=v^2/(rg).', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('664f7767-66a4-49c6-9959-452e6c5e8666', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('664f7767-66a4-49c6-9959-452e6c5e8666', 'canonical_answer_1', 3, '(b) Solving for v^2: v^2=rg*tan(theta)=(50)(10)(0.364)=182 m^2/s^2.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('664f7767-66a4-49c6-9959-452e6c5e8666', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('664f7767-66a4-49c6-9959-452e6c5e8666', 'canonical_answer_1', 5, '(c) v=sqrt(182)≈13.5 m/s.', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('664f7767-66a4-49c6-9959-452e6c5e8666', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('664f7767-66a4-49c6-9959-452e6c5e8666', 'canonical_answer_1', 7, '(d) Without friction, if the car travels faster than this speed, the normal force (which can only act perpendicular to the banked surface) can no longer supply enough centripetal force to keep the car on its circular path at radius r -- the car tends to slide up and outward along the banked surface, moving toward a larger effective radius, since there is no friction available to supply the extra inward force that would be needed to keep it on the original path.', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-np1-008 (67b35097-72a4-4af6-b621-61cf15188e9f)
update app.content_item_versions set canonical_answer_1 = '(a) Work done by the applied force: W_applied=F*d=(15)(5)=75 J.

(b) Work done by friction: W_friction=-f*d=-(6)(5)=-30 J (negative, since friction opposes the displacement).

(c) Net work: W_net=W_applied+W_friction=75+(-30)=45 J.

(d) By the work-energy theorem, KE_f=KE_i+W_net. Initial kinetic energy: KE_i=(1/2)(3)(4)^2=(0.5)(3)(16)=24 J. So KE_f=24+45=69 J.

(e) Solving KE_f=(1/2)mv_f^2 for v_f: v_f=sqrt(2*KE_f/m)=sqrt(2*69/3)=sqrt(46)≈6.8 m/s.' where id = '67b35097-72a4-4af6-b621-61cf15188e9f';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67b35097-72a4-4af6-b621-61cf15188e9f', 'canonical_answer_1', 1, '(a) Work done by the applied force: W_applied=F*d=(15)(5)=75 J.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67b35097-72a4-4af6-b621-61cf15188e9f', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67b35097-72a4-4af6-b621-61cf15188e9f', 'canonical_answer_1', 3, '(b) Work done by friction: W_friction=-f*d=-(6)(5)=-30 J (negative, since friction opposes the displacement).', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67b35097-72a4-4af6-b621-61cf15188e9f', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67b35097-72a4-4af6-b621-61cf15188e9f', 'canonical_answer_1', 5, '(c) Net work: W_net=W_applied+W_friction=75+(-30)=45 J.', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67b35097-72a4-4af6-b621-61cf15188e9f', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67b35097-72a4-4af6-b621-61cf15188e9f', 'canonical_answer_1', 7, '(d) By the work-energy theorem, KE_f=KE_i+W_net. Initial kinetic energy: KE_i=(1/2)(3)(4)^2=(0.5)(3)(16)=24 J. So KE_f=24+45=69 J.', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67b35097-72a4-4af6-b621-61cf15188e9f', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('67b35097-72a4-4af6-b621-61cf15188e9f', 'canonical_answer_1', 9, '(e) Solving KE_f=(1/2)mv_f^2 for v_f: v_f=sqrt(2*KE_f/m)=sqrt(2*69/3)=sqrt(46)≈6.8 m/s.', ARRAY['part-e-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-np1-009 (85ab476a-ed8d-4e51-a35a-f935260094c3)
update app.content_item_versions set canonical_answer_1 = '(a) Elastic potential energy: U_s=(1/2)k(delta x)^2=(0.5)(200)(0.3)^2=(0.5)(200)(0.09)=9 J.

(b) Setting the spring PE equal to the block''s kinetic energy as it leaves the spring: 9=(1/2)(2)v^2, so v^2=9, v=3 m/s.

(c) Setting the kinetic energy (or equivalently the original spring PE, by energy conservation) equal to gravitational potential energy at maximum height: 9=mgh=(2)(10)h, so h=9/20=0.45 m.

(d) As the block rises from the bottom to its maximum height, its kinetic energy decreases from 9 J to 0 J while its gravitational potential energy increases from 0 J to 9 J -- energy is continuously converted from kinetic to gravitational potential form. Throughout this process, the total mechanical energy remains constant at 9 J, since the track and incline are frictionless everywhere and no nonconservative forces act on the block.' where id = '85ab476a-ed8d-4e51-a35a-f935260094c3';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('85ab476a-ed8d-4e51-a35a-f935260094c3', 'canonical_answer_1', 1, '(a) Elastic potential energy: U_s=(1/2)k(delta x)^2=(0.5)(200)(0.3)^2=(0.5)(200)(0.09)=9 J.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('85ab476a-ed8d-4e51-a35a-f935260094c3', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('85ab476a-ed8d-4e51-a35a-f935260094c3', 'canonical_answer_1', 3, '(b) Setting the spring PE equal to the block''s kinetic energy as it leaves the spring: 9=(1/2)(2)v^2, so v^2=9, v=3 m/s.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('85ab476a-ed8d-4e51-a35a-f935260094c3', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('85ab476a-ed8d-4e51-a35a-f935260094c3', 'canonical_answer_1', 5, '(c) Setting the kinetic energy (or equivalently the original spring PE, by energy conservation) equal to gravitational potential energy at maximum height: 9=mgh=(2)(10)h, so h=9/20=0.45 m.', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('85ab476a-ed8d-4e51-a35a-f935260094c3', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('85ab476a-ed8d-4e51-a35a-f935260094c3', 'canonical_answer_1', 7, '(d) As the block rises from the bottom to its maximum height, its kinetic energy decreases from 9 J to 0 J while its gravitational potential energy increases from 0 J to 9 J -- energy is continuously converted from kinetic to gravitational potential form. Throughout this process, the total mechanical energy remains constant at 9 J, since the track and incline are frictionless everywhere and no nonconservative forces act on the block.', ARRAY['part-d-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

-- apphy1-frq-np1-010 (126217af-dd27-484a-8221-c760e3b21f58)
update app.content_item_versions set canonical_answer_1 = '(a) Required force: F=mg=(1000)(10)=10,000 N. This force must equal the elevator''s weight because constant velocity means zero acceleration; by Newton''s second law (F_net=ma=0), the net force on the elevator must be zero, which requires the applied (motor) force to exactly balance the downward gravitational force.

(b) Mechanical power output: P=Fv=(10,000)(2)=20,000 W.

(c) Electrical power input: since the motor is 80% efficient, the mechanical output is 80% of the electrical input, so electrical input = mechanical output / 0.80 = 20,000/0.80=25,000 W.' where id = '126217af-dd27-484a-8221-c760e3b21f58';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('126217af-dd27-484a-8221-c760e3b21f58', 'canonical_answer_1', 1, '(a) Required force: F=mg=(1000)(10)=10,000 N. This force must equal the elevator''s weight because constant velocity means zero acceleration; by Newton''s second law (F_net=ma=0), the net force on the elevator must be zero, which requires the applied (motor) force to exactly balance the downward gravitational force.', ARRAY['part-a-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('126217af-dd27-484a-8221-c760e3b21f58', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('126217af-dd27-484a-8221-c760e3b21f58', 'canonical_answer_1', 3, '(b) Mechanical power output: P=Fv=(10,000)(2)=20,000 W.', ARRAY['part-b-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('126217af-dd27-484a-8221-c760e3b21f58', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal', 'apphy1_canonical_2026_09_25');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run) values ('126217af-dd27-484a-8221-c760e3b21f58', 'canonical_answer_1', 5, '(c) Electrical power input: since the motor is 80% efficient, the mechanical output is 80% of the electrical input, so electrical input = mechanical output / 0.80 = 20,000/0.80=25,000 W.', ARRAY['part-c-criterion-01'], 'drafted', 'apphy1_canonical_2026_09_25');

do $$
declare
  v_bad text;
begin
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('1200ff17-ed8a-433f-ae65-efd3c136bcd0'::uuid),('664f7767-66a4-49c6-9959-452e6c5e8666'::uuid),('67b35097-72a4-4af6-b621-61cf15188e9f'::uuid),('85ab476a-ed8d-4e51-a35a-f935260094c3'::uuid),('126217af-dd27-484a-8221-c760e3b21f58'::uuid)) as t(vid)
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


-- Post-apply independent re-verification found a genuine defect isolated to two items:
-- apphy1-frq-033 and apphy1-frq-035 had their version_ids swapped in the original data-fetch
-- script that built this migration's source data (the script correctly authored distinct,
-- item-appropriate content for each, but mislabeled which version_id belonged to which
-- content_key). The batches above therefore wrote 033's SHM-graphs content onto 035's real
-- current version_id (9f159e00-a8d9-4690-945b-c255632a5429) and 035's spring/friction content
-- onto 033's real current version_id (beacb3d2-fd4c-404d-95b9-e734637d17d8): span concatenation
-- was internally consistent for each version (masking the defect from the check above), but each
-- version's spans covered the wrong item's frq_criteria set entirely. Corrected below by swapping
-- canonical_answer_1 and the owning canonical_answer_spans rows between the two version_ids.

begin;

update app.content_item_versions t
set canonical_answer_1 = s.canonical_answer_1
from (
  select '9f159e00-a8d9-4690-945b-c255632a5429'::uuid as target_id,
    (select canonical_answer_1 from app.content_item_versions where id = 'beacb3d2-fd4c-404d-95b9-e734637d17d8') as canonical_answer_1
  union all
  select 'beacb3d2-fd4c-404d-95b9-e734637d17d8'::uuid,
    (select canonical_answer_1 from app.content_item_versions where id = '9f159e00-a8d9-4690-945b-c255632a5429')
) s
where t.id = s.target_id;

-- stage swap through a temporary span_ordinal offset to dodge the
-- (content_item_version_id, answer_field, span_ordinal) unique constraint
update app.canonical_answer_spans
set span_ordinal = span_ordinal + 1000
where content_item_version_id = '9f159e00-a8d9-4690-945b-c255632a5429' and answer_field = 'canonical_answer_1';

update app.canonical_answer_spans
set content_item_version_id = '9f159e00-a8d9-4690-945b-c255632a5429'::uuid
where content_item_version_id = 'beacb3d2-fd4c-404d-95b9-e734637d17d8' and answer_field = 'canonical_answer_1';

update app.canonical_answer_spans
set content_item_version_id = 'beacb3d2-fd4c-404d-95b9-e734637d17d8'::uuid, span_ordinal = span_ordinal - 1000
where content_item_version_id = '9f159e00-a8d9-4690-945b-c255632a5429' and answer_field = 'canonical_answer_1' and span_ordinal > 1000;

do $$
declare
  n35 int; n33 int; concat35 text; concat33 text; stored35 text; stored33 text;
begin
  select count(distinct ck) into n35 from app.canonical_answer_spans cas cross join lateral unnest(cas.criterion_keys) as ck where cas.content_item_version_id = '9f159e00-a8d9-4690-945b-c255632a5429' and cas.answer_field='canonical_answer_1';
  select count(distinct ck) into n33 from app.canonical_answer_spans cas cross join lateral unnest(cas.criterion_keys) as ck where cas.content_item_version_id = 'beacb3d2-fd4c-404d-95b9-e734637d17d8' and cas.answer_field='canonical_answer_1';
  select string_agg(span_text,'' order by span_ordinal) into concat35 from app.canonical_answer_spans where content_item_version_id = '9f159e00-a8d9-4690-945b-c255632a5429' and answer_field='canonical_answer_1';
  select string_agg(span_text,'' order by span_ordinal) into concat33 from app.canonical_answer_spans where content_item_version_id = 'beacb3d2-fd4c-404d-95b9-e734637d17d8' and answer_field='canonical_answer_1';
  select canonical_answer_1 into stored35 from app.content_item_versions where id = '9f159e00-a8d9-4690-945b-c255632a5429';
  select canonical_answer_1 into stored33 from app.content_item_versions where id = 'beacb3d2-fd4c-404d-95b9-e734637d17d8';
  if n35 <> 10 then raise exception 'expected 10 criteria for 035 (9f159e00), got %', n35; end if;
  if n33 <> 3 then raise exception 'expected 3 criteria for 033 (beacb3d2), got %', n33; end if;
  if concat35 is distinct from stored35 then raise exception 'concat mismatch for 9f159e00'; end if;
  if concat33 is distinct from stored33 then raise exception 'concat mismatch for beacb3d2'; end if;
end $$;

commit;
