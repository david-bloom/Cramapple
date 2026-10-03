begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphy1-mcq-sv-035-v1','apphy1-mcq-sv-035-v2','apphy1-mcq-sv-035-v3','apphy1-mcq-sv-036-v1','apphy1-mcq-sv-036-v2','apphy1-mcq-sv-036-v3','apphy1-mcq-sv-037-v1','apphy1-mcq-sv-037-v2','apphy1-mcq-sv-037-v3','apphy1-mcq-sv-038-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy1-mcq-sv-035-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-035-v1', 'mcq', 'Center of mass of two blocks', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg block sits at x = 1.0 m on a long shelf and a 3.0 kg block sits at x = 6.0 m. The x-coordinate of the center of mass of the two blocks is', null, md5('apphy1-mcq-sv-035-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4.0 m', true, 'x_cm = (2.0×1.0 + 3.0×6.0)/(2.0 + 3.0) = 20/5.0 = 4.0 m, which is closer to the heavier block.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.0 m', false, 'Swaps the masses in the weighting: (3.0×1.0 + 2.0×6.0)/5.0 = 15/5.0 = 3.0 m, which wrongly puts the center nearer the lighter block.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.5 m', false, 'The unweighted midpoint (1.0 + 6.0)/2 = 3.5 m. It ignores that the masses are unequal.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.0 m', false, 'Places the center on the heavier block. The center of mass lies between the two blocks, and here it is 4.0 m.' from version_ins;
-- apphy1-mcq-sv-035-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-035-v2', 'mcq', 'Center of mass with a negative coordinate', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On a straight air track with the origin at its middle, a 4.0 kg cart is at x = −2.0 m and a 1.0 kg cart is at x = +3.0 m. The x-coordinate of the carts'' center of mass is', null, md5('apphy1-mcq-sv-035-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.2 m', false, 'Drops the negative sign of the first position: (4.0×2.0 + 1.0×3.0)/5.0 = 11/5.0 = 2.2 m. The cart at x = −2.0 m contributes −8.0 kg·m, not +8.0 kg·m.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.0 m', false, 'Swaps the masses: (1.0×(−2.0) + 4.0×3.0)/5.0 = 10/5.0 = 2.0 m, which wrongly puts the center nearer the lighter cart.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1.0 m', true, 'x_cm = (4.0×(−2.0) + 1.0×3.0)/(4.0 + 1.0) = (−8.0 + 3.0)/5.0 = −1.0 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.5 m', false, 'The unweighted midpoint (−2.0 + 3.0)/2 = 0.5 m, which ignores the 4:1 ratio of the masses.' from version_ins;
-- apphy1-mcq-sv-035-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-035-v3', 'mcq', 'Center of mass of three objects', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three beads are fixed on a thin horizontal rod, with positions measured from the rod''s left end: a 3.0 kg bead at 0, a 1.0 kg bead at 2.0 m, and a 2.0 kg bead at 5.0 m. Measured from the left end, the center of mass of the three beads lies at', null, md5('apphy1-mcq-sv-035-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.5 m', false, 'The midpoint of the two end objects, (0 + 5.0)/2 = 2.5 m, which ignores the masses and the middle object.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.3 m', false, 'The unweighted mean of the positions, (0 + 2.0 + 5.0)/3 = 2.33 m, which ignores the masses.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.0 m', true, 'x_cm = (3.0×0 + 1.0×2.0 + 2.0×5.0)/(3.0 + 1.0 + 2.0) = 12/6.0 = 2.0 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '4.0 m', false, 'Divides the weighted sum by the number of objects instead of the total mass: 12/3 = 4.0 m. The denominator must be the total mass, 6.0 kg.' from version_ins;
-- apphy1-mcq-sv-036-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-036-v1', 'mcq', 'Kinetic energy after a speed increase', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A freight train''s speed increases from 20 m/s to 50 m/s while its mass stays the same. Its translational kinetic energy becomes', null, md5('apphy1-mcq-sv-036-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.125 times as large', false, 'Takes the correct factor 2.5² = 6.25 and then also divides by 2 for the ½ in K = ½mv², but the ½ cancels in a ratio of two kinetic energies: 6.25/2 = 3.125.' from version_ins
union all select gen_random_uuid(), id, 'B', '5.0 times as large', false, 'Multiplies the speed ratio by 2 instead of squaring it: 2 × 2.5 = 5.0.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.5 times as large', false, 'Treats K as directly proportional to speed, so K scales by the speed ratio 50/20 = 2.5 and the square is missed.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.25 times as large', true, 'K is proportional to v². The speed ratio is 50/20 = 2.5, so K increases by 2.5² = 6.25.' from version_ins;
-- apphy1-mcq-sv-036-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-036-v2', 'mcq', 'Kinetic energy with mass and speed both changing', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A shopping cart is loaded so that its mass doubles, and it is then pushed at half its original speed. Compared with its original translational kinetic energy, its new kinetic energy is', null, md5('apphy1-mcq-sv-036-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'one-half as large', true, 'K = ½mv². With 2m and v/2: K'' = ½(2m)(v/2)² = ½mv²·(2/4) = ½K.' from version_ins
union all select gen_random_uuid(), id, 'B', 'one-fourth as large', false, 'Applies the square to the speed (½)² = ¼ but ignores the doubled mass. Doubling m multiplies K by 2, giving ¼ × 2 = ½.' from version_ins
union all select gen_random_uuid(), id, 'C', 'unchanged', false, 'Treats K as proportional to mv, so the factor 2 for mass cancels the factor ½ for speed (2 × ½ = 1). Speed enters K squared, giving 2 × ¼ = ½.' from version_ins
union all select gen_random_uuid(), id, 'D', 'twice as large', false, 'Accounts for the doubled mass but ignores the change in speed entirely. Halving the speed multiplies K by ¼, so the net factor is 2 × ¼ = ½.' from version_ins;
-- apphy1-mcq-sv-036-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-036-v3', 'mcq', 'Increase in kinetic energy of a ball', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.50 kg ball is thrown so that its speed increases from 4.0 m/s to 12 m/s while it is in the thrower''s hand. The increase in the ball''s translational kinetic energy is', null, md5('apphy1-mcq-sv-036-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8.0 J', false, 'Treats K as proportional to speed: the speed triples, so K goes from 4.0 J to 12 J and the increase is 8.0 J. K is proportional to v², so K increases ninefold.' from version_ins
union all select gen_random_uuid(), id, 'B', '32 J', true, 'ΔK = ½(0.50)(12)² − ½(0.50)(4.0)² = 36 J − 4.0 J = 32 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '36 J', false, 'Reports the final kinetic energy, ½(0.50)(12)² = 36 J, instead of the change; the initial 4.0 J must be subtracted.' from version_ins
union all select gen_random_uuid(), id, 'D', '16 J', false, 'Uses ½m(Δv)² with Δv = 8.0 m/s: ½(0.50)(8.0)² = 16 J. The change in K is ½m(v² − v₀²), not ½m(v − v₀)².' from version_ins;
-- apphy1-mcq-sv-037-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-037-v1', 'mcq', 'Work by an angled rope on a sled', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rope pulls a sled 5.0 m across level snow with a constant 40 N force directed 53° above the horizontal displacement. (Use sin 53° = 0.80 and cos 53° = 0.60.) The work done by the rope on the sled is', null, md5('apphy1-mcq-sv-037-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '160 J', false, 'Uses sin 53° instead of cos 53°: (40)(5.0)(0.80) = 160 J. The component along the displacement uses cosine.' from version_ins
union all select gen_random_uuid(), id, 'B', '120 J', true, 'W = Fd cos θ = (40 N)(5.0 m)(0.60) = 120 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '200 J', false, 'Ignores the angle: Fd = (40)(5.0) = 200 J. Only the component of the force along the displacement does work.' from version_ins
union all select gen_random_uuid(), id, 'D', '333 J', false, 'Divides by cos 53° instead of multiplying: (40)(5.0)/0.60 = 333 J. The parallel component is smaller than the full force, so the work must be less than 200 J.' from version_ins;
-- apphy1-mcq-sv-037-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-037-v2', 'mcq', 'Work by a push on a lawn mower handle', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A person pushes a lawn mower 12 m across level grass, applying a constant 90 N force along the handle, which makes a 60° angle below the horizontal. (Use cos 60° = 0.50 and sin 60° = 0.87.) The work done by the person''s force on the mower is', null, md5('apphy1-mcq-sv-037-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−540 J', false, 'Gets the magnitude right but the sign wrong, reasoning that a downward-pointing force does negative work. The horizontal component of the force points in the direction of the motion, so the work is positive.' from version_ins
union all select gen_random_uuid(), id, 'B', '940 J', false, 'Uses sin 60° instead of cos 60°: (90)(12)(0.87) = 940 J (939.6 J before rounding). The component along the motion uses cosine of the angle to the displacement.' from version_ins
union all select gen_random_uuid(), id, 'C', '1080 J', false, 'Ignores the angle: Fd = (90)(12) = 1080 J, as if the entire force acted along the displacement.' from version_ins
union all select gen_random_uuid(), id, 'D', '540 J', true, 'The force component along the horizontal displacement is 90 cos 60° = 45 N, so W = (45 N)(12 m) = 540 J.' from version_ins;
-- apphy1-mcq-sv-037-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-037-v3', 'mcq', 'Work by a tow rope on a trailer', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A tow rope exerts a constant 200 N force on a trailer while the trailer moves 15 m along a level road. The rope makes a 30° angle above the horizontal. (Use cos 30° = 0.87 and sin 30° = 0.50.) The work done by the rope on the trailer is', null, md5('apphy1-mcq-sv-037-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2271 J', false, 'Applies cos 30° twice, once to find the force component and again to the displacement: (200)(15)(0.87)(0.87) = 2270.7 J ≈ 2271 J. The displacement is already along the road, so the cosine appears once.' from version_ins
union all select gen_random_uuid(), id, 'B', '3000 J', false, 'Ignores the angle: Fd = (200)(15) = 3000 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '2610 J', true, 'W = Fd cos θ = (200)(15)(0.87) = 2610 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '1500 J', false, 'Uses sin 30° instead of cos 30°: (200)(15)(0.50) = 1500 J.' from version_ins;
-- apphy1-mcq-sv-038-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-038-v1', 'mcq', 'Potential energy and a force in the −x direction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In one dimension, a conservative force on a particle points in the −x direction at every point in a region. As the particle moves toward larger x in that region, the potential energy associated with the force', null, md5('apphy1-mcq-sv-038-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'increases', true, 'Moving in +x is moving against the force, so the force does negative work, W = −ΔU is negative, and ΔU is positive: U increases.' from version_ins
union all select gen_random_uuid(), id, 'B', 'decreases', false, 'Assumes that a particle moving toward larger x must be moving toward lower potential energy, as if the force pointed in +x. Potential energy decreases in the direction the conservative force points, here −x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'cannot be determined without choosing a zero of potential energy', false, 'Choosing a zero of U adds the same constant everywhere and does not change ΔU between two points, so the direction of the change is fixed by the force direction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'stays constant', false, 'A constant U would mean the force is zero (the force is the negative slope of U), which contradicts the nonzero −x force.' from version_ins;
commit;
