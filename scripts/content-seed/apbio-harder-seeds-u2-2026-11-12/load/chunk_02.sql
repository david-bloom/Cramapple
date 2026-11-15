begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.2-a-v1','apbio-mcq-b5-sv-h-2.2-a-v2','apbio-mcq-b5-sv-h-2.2-a-v3','apbio-mcq-b5-h-2.2-b','apbio-mcq-b5-sv-h-2.2-b-v1','apbio-mcq-b5-sv-h-2.2-b-v2','apbio-mcq-b5-sv-h-2.2-b-v3','apbio-mcq-b5-h-2.3-a','apbio-mcq-b5-sv-h-2.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apbio-mcq-b5-sv-h-2.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.2-a-v1', 'mcq', 'use supply proportional to surface area and demand proportional to volume to predict whether a cell of a given size can  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A growing spherical cell is modeled as follows. Nutrient uptake is 2.0 units per square micrometer of surface per minute, and nutrient use is 0.5 units per cubic micrometer of cytoplasm per minute. For a sphere, surface area is 4πr² and volume is (4/3)πr³. For this model, supply divided by demand equals 12 divided by r, with r in micrometers. What is predicted if the cell grows from a radius of 6 micrometers to 15 micrometers?', null, md5('apbio-mcq-b5-sv-h-2.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Supply stays above demand, because supply per square micrometer does not change as the cell grows.', false, 'Uptake per unit area is constant, but total demand grows with volume and outpaces total uptake once r exceeds 12 micrometers.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Supply falls from twice the demand to exactly half of the demand.', false, 'A ratio of one half would occur at r = 24, not at r = 15.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Supply falls from twice the demand to 80% of the demand.', true, 'Correct: At r = 6 the ratio is 12/6 = 2.0; at r = 15 it is 12/15 = 0.80, so supply falls from twice the demand to 80% of it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Supply rises with the larger surface area, so the cell can meet demand at any radius.', false, 'Total surface area does rise, but volume rises faster, so the cell can meet demand only up to r = 12 micrometers.' from version_ins;
-- apbio-mcq-b5-sv-h-2.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.2-a-v2', 'mcq', 'use supply proportional to surface area and demand proportional to volume to predict whether a cell of a given size can  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cube-shaped cell of edge length s absorbs oxygen at 0.8 units per square micrometer per minute and uses it at 0.2 units per cubic micrometer per minute. The cell grows from s = 12 micrometers to s = 48 micrometers. Which statement describes the change in the ratio of oxygen supply to oxygen demand?', null, md5('apbio-mcq-b5-sv-h-2.2-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The ratio decreases by a factor of 2, because the edge length increases fourfold and supply grows with edge length.', false, 'Supply is proportional to the square of the edge length, not the edge length itself, so a factor of 2 understates the change.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The ratio decreases by a factor of 4, because surface area increases by 16 and volume by 64.', true, 'Correct: A fourfold increase in edge length multiplies surface area by 4² = 16 and volume by 4³ = 64, so the ratio of supply to demand changes by 16/64 = 1/4. (Here the ratio goes from 24/12 = 2 to 24/48 = 0.5.).' from version_ins
union all select gen_random_uuid(), id, 'C', 'The ratio stays the same, because both supply and demand increase as the cell grows.', false, 'Both increase, but demand increases four times more than supply, so the ratio does not stay constant.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The ratio increases by a factor of 4, because surface area increases by 16 and volume by 4.', false, 'Volume increases by 4³ = 64, not by 4, so the ratio falls rather than rises.' from version_ins;
-- apbio-mcq-b5-sv-h-2.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.2-a-v3', 'mcq', 'use supply proportional to surface area and demand proportional to volume to predict whether a cell of a given size can  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A spherical bacterium produces a waste product at 0.3 units per cubic micrometer per minute, and waste can leave across its surface at a maximum of 1.5 units per square micrometer per minute. Using surface area 4πr² and volume (4/3)πr³, the waste production equals the maximum removal at one particular radius. Above that radius, waste accumulates. Which is that radius?', null, md5('apbio-mcq-b5-sv-h-2.2-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20 micrometers', false, '20 micrometers results from omitting the factor of 4/3 in the sphere volume, which changes the balance point.' from version_ins
union all select gen_random_uuid(), id, 'B', '5 micrometers', false, '5 micrometers results from dividing 1.5 by 0.3 without including the factor of 3 in the surface-area-to-volume ratio of a sphere, which is 3 over r.' from version_ins
union all select gen_random_uuid(), id, 'C', '30 micrometers', false, '30 micrometers is the diameter of the correct sphere, so this choice confuses diameter with radius.' from version_ins
union all select gen_random_uuid(), id, 'D', '15 micrometers', true, 'Correct: Setting 1.5 × 4πr² = 0.3 × (4/3)πr³ gives 6πr² = 0.4πr³, so r = 15 micrometers.' from version_ins;
-- apbio-mcq-b5-h-2.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.2-b', 'mcq', 'compare the total surface area of one large cell with that of many small cells containing the same total volume.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher compares two hypothetical arrangements of the same total volume of cytoplasm. Arrangement 1 is one cube-shaped cell with an edge of 6 micrometers. Arrangement 2 is 27 cube-shaped cells, each with an edge of 2 micrometers. Which statement correctly compares the total surface area available for exchange with the environment?', null, md5('apbio-mcq-b5-h-2.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The total surface area is the same, because the total volume is the same.', false, 'Equal volume does not mean equal surface area, because surface area depends on how the volume is divided.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The total surface area of Arrangement 2 is three times that of Arrangement 1, because each small cell has a surface-area-to-volume ratio of 3 and the large cell has a ratio of 1.', true, 'Correct: Total volume is 216 for both (6³ and 27 × 2³). Surface area for Arrangement 1 is 6 × 36 = 216; for Arrangement 2 it is 27 × 24 = 648, which is three times as large.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The total surface area of Arrangement 2 is one third that of Arrangement 1, because each small cell has far less surface area than the large cell.', false, 'Each small cell does have less surface area (24 versus 216), but there are 27 of them, so the total is larger, not smaller.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The total surface area of Arrangement 2 is 27 times that of Arrangement 1, because there are 27 cells.', false, 'Multiplying by the number of cells ignores that each small cell has much less surface area than the large cell (24 compared with 216).' from version_ins;
-- apbio-mcq-b5-sv-h-2.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.2-b-v1', 'mcq', 'compare the total surface area of one large cell with that of many small cells containing the same total volume. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'One spherical cell of radius 4 micrometers is compared with 8 spherical cells of radius 2 micrometers each. The total volume is the same in both cases. For a sphere, surface area is 4πr². Which statement is correct?', null, md5('apbio-mcq-b5-sv-h-2.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The total surface area is the same, because eight spheres of half the radius contain the same volume.', false, 'The volumes are equal but the surface areas are not, because splitting volume into smaller pieces exposes more surface.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The total surface area of the 8 small cells is four times that of the large cell, because the radius is halved and the number of cells is multiplied by 8.', false, 'Halving the radius divides each surface area by 4 and eight cells multiply the total by 8, which gives a factor of 2 and not 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The total surface area of the 8 small cells is twice that of the large cell, so more exchange surface is available per unit of volume.', true, 'Correct: Large cell surface area = 4π(16) = 64π; small cells total = 8 × 4π(4) = 128π, which is twice as large. Volumes are equal: (4/3)π(64) versus 8 × (4/3)π(8).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The total surface area of the 8 small cells is half that of the large cell, because each small cell has one quarter of the surface area.', false, 'Each small cell does have one quarter of the area, but eight of them together give twice the area of the large cell.' from version_ins;
-- apbio-mcq-b5-sv-h-2.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.2-b-v2', 'mcq', 'compare the total surface area of one large cell with that of many small cells containing the same total volume. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose a hypothetical 10 micrometer cube-shaped cell could instead be divided into 1000 cube-shaped cells with an edge of 1 micrometer. The total volume is unchanged. How does the total surface area available for exchange change?', null, md5('apbio-mcq-b5-sv-h-2.2-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It increases by a factor of 1000, because there are 1000 cells.', false, 'This counts the number of cells but ignores that each small cell has only one hundredth of the surface area of the large cell.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It increases by a factor of 10, from 600 to 6000 square micrometers.', true, 'Correct: One cube of edge 10 has surface area 6 × 100 = 600; 1000 cubes of edge 1 have 1000 × 6 = 6000 total, a tenfold increase. Volume is 1000 in both cases.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It increases by a factor of 100, because the edge length is reduced by a factor of 10 and then squared.', false, 'Squaring the size reduction gives the factor by which each cell''s area shrinks, not the factor by which the total area grows.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It does not change, because the same cytoplasm is enclosed.', false, 'The same cytoplasm volume is enclosed, but subdividing it creates much more membrane surface.' from version_ins;
-- apbio-mcq-b5-sv-h-2.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.2-b-v3', 'mcq', 'compare the total surface area of one large cell with that of many small cells containing the same total volume. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cube-shaped cell with an edge of 8 micrometers is compared with 64 cube-shaped cells with an edge of 2 micrometers (the same total volume). Oxygen use is proportional to volume, and oxygen uptake is proportional to surface area. How does the ratio of total oxygen supply to total oxygen demand compare for the two arrangements?', null, md5('apbio-mcq-b5-sv-h-2.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The ratio is the same, because oxygen use and uptake both scale with the amount of cytoplasm.', false, 'Uptake scales with surface area, not with volume, so the ratio changes when the surface area changes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The ratio is 4 times lower for the small cells, because they contain more membrane that must be maintained.', false, 'Maintenance of extra membrane is not part of the model, and more surface area increases supply rather than decreasing it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The ratio is 4 times higher for the small cells, because total demand is unchanged while total surface area is 4 times larger.', true, 'Correct: Total volume is 512 in both cases. Surface area is 6 × 64 = 384 for the large cell and 64 × 24 = 1536 for the small cells, a fourfold increase. Demand depends on volume, which is unchanged.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The ratio is 8 times higher for the small cells, because there are 8 times as many cells along each dimension.', false, 'The number of cells along each dimension is 4, not 8, and the surface area ratio is 4, not 8.' from version_ins;
-- apbio-mcq-b5-h-2.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.3-a', 'mcq', 'interpret a cell-fusion or fluorescence experiment as evidence about lateral movement of membrane components.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A mouse cell and a human cell are fused. Before fusion, the mouse cell surface proteins are labeled with a red fluorescent antibody and the human cell surface proteins with a green fluorescent antibody. Immediately after fusion, the red and green labels occupy separate halves of the hybrid cell. After 40 minutes at 37°C the colors are evenly mixed over the whole surface. When the experiment is repeated at 15°C, the halves remain separate after 40 minutes. Which conclusion is best supported?', null, md5('apbio-mcq-b5-h-2.3-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Membrane proteins flip from one side of the bilayer to the other, which mixes the colors.', false, 'Flipping between layers would not mix the colors across the surface, and the labels sit on the outer surface throughout.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Membrane proteins can move laterally in the fluid bilayer, and the rate of movement depends on temperature.', true, 'Correct: Mixing at 37°C shows proteins moving sideways in the membrane, and the failure to mix at 15°C shows that this movement slows when the bilayer is colder and less fluid.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mixing occurs because the hybrid cell synthesizes new proteins that spread over the surface.', false, 'Newly made proteins would not be labeled with the antibodies added before fusion, and the effect depends on temperature rather than synthesis.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Membrane proteins are fixed in position by the cytoskeleton at all temperatures.', false, 'If proteins were permanently anchored, no mixing would occur at 37°C either.' from version_ins;
-- apbio-mcq-b5-sv-h-2.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.3-a-v1', 'mcq', 'interpret a cell-fusion or fluorescence experiment as evidence about lateral movement of membrane components. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a photobleaching experiment, a small spot on the surface of a living cell is bleached with a laser so that fluorescently tagged membrane proteins in that spot no longer glow. Over the next 60 seconds, fluorescence in the spot recovers to 80% of its original level for protein P and to only 5% for protein Q. Both proteins are in the same membrane. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.3-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The membrane is not fluid, because the recovery is incomplete for protein Q.', false, 'The high recovery of P in the same membrane shows that the bilayer is fluid; Q behaves differently for reasons specific to Q.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Protein P moves laterally in the membrane, but movement of protein Q is restricted, for example by attachment to the cytoskeleton.', true, 'Correct: Unbleached P molecules diffuse into the spot, restoring fluorescence, while Q is not mobile on this time scale; in the same membrane this points to anchoring or restriction of Q.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cell destroyed protein Q more quickly than it destroyed protein P.', false, 'Faster breakdown would lower fluorescence everywhere and does not explain why P recovers while Q does not.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both proteins are anchored to the cytoskeleton, and recovery for P is caused by new synthesis.', false, 'If P were anchored, it could not recover quickly, and synthesis of new protein in 60 seconds would not restore the spot selectively.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.2-a-v1','apbio-mcq-b5-sv-h-2.2-a-v2','apbio-mcq-b5-sv-h-2.2-a-v3','apbio-mcq-b5-h-2.2-b','apbio-mcq-b5-sv-h-2.2-b-v1','apbio-mcq-b5-sv-h-2.2-b-v2','apbio-mcq-b5-sv-h-2.2-b-v3','apbio-mcq-b5-h-2.3-a','apbio-mcq-b5-sv-h-2.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-sv-h-2.2-a-v1','apbio-mcq-b5-sv-h-2.2-a-v2','apbio-mcq-b5-sv-h-2.2-a-v3','apbio-mcq-b5-h-2.2-b','apbio-mcq-b5-sv-h-2.2-b-v1','apbio-mcq-b5-sv-h-2.2-b-v2','apbio-mcq-b5-sv-h-2.2-b-v3','apbio-mcq-b5-h-2.3-a','apbio-mcq-b5-sv-h-2.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
