begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphy1-mcq-sv-038-v2','apphy1-mcq-sv-038-v3','apphy1-mcq-sv-039-v1','apphy1-mcq-sv-039-v2','apphy1-mcq-sv-039-v3','apphy1-mcq-sv-040-v1','apphy1-mcq-sv-040-v2','apphy1-mcq-sv-040-v3','apphy1-mcq-sv-041-v1','apphy1-mcq-sv-041-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy1-mcq-sv-038-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-038-v2', 'mcq', 'Spring energy as a block moves outward', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A block on a frictionless table is attached to a horizontal ideal spring that is at its natural length when the block is at x = 0. The block is pulled from x = +0.10 m to x = +0.30 m. During this motion, the elastic potential energy stored in the spring', null, md5('apphy1-mcq-sv-038-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'decreases because the spring is pulling the block', false, 'Confuses the direction of the force with the direction of the motion. The spring pulls toward x = 0 while the block moves away from it, so the spring does negative work and U increases.' from version_ins
union all select gen_random_uuid(), id, 'B', 'stays zero because the spring is at x = 0 in equilibrium', false, 'Applies the equilibrium position to the whole motion. U = ½kx² is zero only at x = 0; at x = 0.10 m it is already 0.005k joules and at 0.30 m it is 0.045k joules.' from version_ins
union all select gen_random_uuid(), id, 'C', 'increases to 9 times its initial value', true, 'U = ½kx², so U is proportional to x². Going from 0.10 m to 0.30 m multiplies x by 3, so U is multiplied by 3² = 9. The spring force points back toward x = 0, against the motion, so the spring does negative work.' from version_ins
union all select gen_random_uuid(), id, 'D', 'increases to 3 times its initial value', false, 'Treats U as proportional to the stretch, giving 0.30/0.10 = 3. Since U = ½kx², the factor is 3² = 9.' from version_ins;
-- apphy1-mcq-sv-038-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-038-v3', 'mcq', 'Potential energy when moving along the force', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A conservative force on a particle points in the −x direction at every point between x = 2.0 m and x = 6.0 m. The particle moves from x = 6.0 m to x = 2.0 m. During this motion, the potential energy associated with the force', null, md5('apphy1-mcq-sv-038-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'increases', false, 'Assumes the particle moving to smaller x must be climbing in potential energy, as if the force pointed in +x. Moving along the direction of a conservative force lowers U.' from version_ins
union all select gen_random_uuid(), id, 'B', 'stays constant', false, 'A constant U would mean the force is zero, but a nonzero −x force acts throughout the region.' from version_ins
union all select gen_random_uuid(), id, 'C', 'is zero at x = 2.0 m', false, 'The location where U = 0 is chosen by the observer; the force only fixes how U changes between points, and nothing in the problem makes x = 2.0 m the zero.' from version_ins
union all select gen_random_uuid(), id, 'D', 'decreases', true, 'The particle moves in the direction of the force (−x), so the force does positive work, and ΔU = −W is negative: U decreases.' from version_ins;
-- apphy1-mcq-sv-039-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-039-v1', 'mcq', 'Speed of a block at the bottom of a ramp', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A block is released from rest at a height of 1.8 m above the bottom of a frictionless ramp. Using g = 10 m/s², its speed at the bottom of the ramp is', null, md5('apphy1-mcq-sv-039-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6.0 m/s', true, 'mgh = ½mv² gives v = √(2gh) = √(2×10×1.8) = √36 = 6.0 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.2 m/s', false, 'Leaves out the factor of 2: v = √(gh) = √(18) = 4.2 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '36 m/s', false, 'Finds v² = 2gh = 36 correctly but forgets to take the square root and reports v² as v.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.0 m/s', false, 'Puts the ½ on the wrong side: v = √(gh/2) = √9 = 3.0 m/s.' from version_ins;
-- apphy1-mcq-sv-039-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-039-v2', 'mcq', 'Speed partway down a frictionless slope', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A skier starts from rest at the top of a frictionless slope, at height 4h above the valley floor. She slides down to a point on the slope at height h above the valley floor. Her speed at that point is', null, md5('apphy1-mcq-sv-039-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√(3gh)', false, 'Uses the correct drop 3h but leaves out the factor of 2 from the ½ in kinetic energy: √(g·3h) = √(3gh).' from version_ins
union all select gen_random_uuid(), id, 'B', '√(8gh)', false, 'Uses the full starting height 4h as the drop: mg(4h) = ½mv² gives √(8gh). She has only descended 3h at that point.' from version_ins
union all select gen_random_uuid(), id, 'C', '√(2gh)', false, 'Uses h, the height of the point above the floor, as the drop: mgh = ½mv² gives √(2gh). The drop is 3h.' from version_ins
union all select gen_random_uuid(), id, 'D', '√(6gh)', true, 'She has descended 4h − h = 3h, so mg(3h) = ½mv², giving v = √(6gh).' from version_ins;
-- apphy1-mcq-sv-039-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-039-v3', 'mcq', 'Speed of a pushed sled at the bottom of a hill', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sled is pushed so that it has a speed of 3.0 m/s at the top of a frictionless icy slope, 2.0 m above the bottom. Using g = 10 m/s², its speed at the bottom of the slope is', null, md5('apphy1-mcq-sv-039-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7.0 m/s', true, '½mv² = ½mv₀² + mgh gives v² = v₀² + 2gh = 9.0 + 40 = 49, so v = 7.0 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.3 m/s', false, 'Ignores the initial speed: v = √(2gh) = √40 = 6.3 m/s. The sled already had kinetic energy at the top.' from version_ins
union all select gen_random_uuid(), id, 'C', '5.4 m/s', false, 'Uses v² = v₀² + gh = 9.0 + 20 = 29 and v = 5.4 m/s, which leaves out the factor of 2 on the gravitational term.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.3 m/s', false, 'Adds the speed 3.0 m/s to the speed gained from the drop alone, √(2gh) = 6.3 m/s: 3.0 + 6.3 = 9.3 m/s. Energies add, not speeds.' from version_ins;
-- apphy1-mcq-sv-040-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-040-v1', 'mcq', 'Average power pulling a crate', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A worker pulls a crate 12 m along a level floor in 10 s by exerting a constant 150 N horizontal force along the displacement. The average power delivered by the worker to the crate is', null, md5('apphy1-mcq-sv-040-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '180 W', true, 'W = Fd = (150)(12) = 1800 J, and P_avg = W/Δt = 1800/10 = 180 W.' from version_ins
union all select gen_random_uuid(), id, 'B', '1800 W', false, 'Computes the work, Fd = 1800 J, and reports it as the power without dividing by the 10 s.' from version_ins
union all select gen_random_uuid(), id, 'C', '18000 W', false, 'Multiplies the work by the time instead of dividing: 1800 × 10 = 18000.' from version_ins
union all select gen_random_uuid(), id, 'D', '15 W', false, 'Divides the force by the time without using the distance: 150/10 = 15, so the 12 m displacement is missing.' from version_ins;
-- apphy1-mcq-sv-040-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-040-v2', 'mcq', 'Average power of an elevator motor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An elevator car of mass 800 kg is raised 15 m in 20 s, starting and ending at rest. Using g = 10 m/s², the average power needed to supply the car''s gain in gravitational potential energy is', null, md5('apphy1-mcq-sv-040-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3000 W', false, 'Uses half the height, as in an average height of 7.5 m: (800)(10)(7.5)/20 = 3000 W. The potential energy gained depends on the full 15 m rise.' from version_ins
union all select gen_random_uuid(), id, 'B', '120000 W', false, 'Computes the energy gained, 120000 J, and reports it as the power without dividing by 20 s.' from version_ins
union all select gen_random_uuid(), id, 'C', '600 W', false, 'Leaves out g: (800)(15)/20 = 600, which uses the mass in place of the weight.' from version_ins
union all select gen_random_uuid(), id, 'D', '6000 W', true, 'ΔU = mgΔh = (800)(10)(15) = 120000 J, and P_avg = 120000/20 = 6000 W.' from version_ins;
-- apphy1-mcq-sv-040-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-040-v3', 'mcq', 'Power at constant speed', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cyclist moves along a level road at a constant 8.0 m/s. The forward push of the road on the bike-and-rider system is a constant 40 N, balancing air resistance. The power the cyclist supplies to overcome that resistance is', null, md5('apphy1-mcq-sv-040-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5.0 W', false, 'Divides the force by the speed: 40/8.0 = 5.0, instead of multiplying.' from version_ins
union all select gen_random_uuid(), id, 'B', '2560 W', false, 'Uses Fv² = (40)(8.0)² = 2560. Power is force times speed, not force times speed squared.' from version_ins
union all select gen_random_uuid(), id, 'C', '48 W', false, 'Adds the force and the speed: 40 + 8.0 = 48, instead of multiplying them.' from version_ins
union all select gen_random_uuid(), id, 'D', '320 W', true, 'P = Fv = (40 N)(8.0 m/s) = 320 W.' from version_ins;
-- apphy1-mcq-sv-041-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-041-v1', 'mcq', 'Energy of a skidding car', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A car on a level road locks its brakes and skids to a stop. Most of the car''s initial kinetic energy ends up as', null, md5('apphy1-mcq-sv-041-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'kinetic energy of the car', false, 'The car comes to rest, so its final kinetic energy is zero; kinetic energy cannot be where the initial kinetic energy ends up.' from version_ins
union all select gen_random_uuid(), id, 'B', 'thermal energy', true, 'Kinetic friction between the tires and the road does negative work on the car and dissipates its mechanical energy mostly as thermal energy of the tires and road.' from version_ins
union all select gen_random_uuid(), id, 'C', 'gravitational potential energy', false, 'The road is level, so the car''s height does not change and its gravitational potential energy is the same before and after.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sound energy', false, 'The screech carries away only a small part of the energy; kinetic friction mostly converts it to thermal energy.' from version_ins;
-- apphy1-mcq-sv-041-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-041-v2', 'mcq', 'Energy lost by a child on a slide', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A child slides down a playground slide at a constant speed the whole way. The gravitational potential energy the child loses is primarily converted into', null, md5('apphy1-mcq-sv-041-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'thermal energy', true, 'Friction on the slide does negative work and dissipates the lost gravitational potential energy mostly as thermal energy of the child and the slide, since the speed does not change.' from version_ins
union all select gen_random_uuid(), id, 'B', 'gravitational potential energy at the bottom', false, 'The child''s gravitational potential energy is lower at the bottom, so it is not where the lost energy is stored.' from version_ins
union all select gen_random_uuid(), id, 'C', 'kinetic energy of the child', false, 'The child''s speed is constant, so the kinetic energy is unchanged and cannot account for the potential energy lost.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sound energy', false, 'The sound of sliding carries away only a small portion; the dissipation by kinetic friction is mostly thermal.' from version_ins;
commit;
