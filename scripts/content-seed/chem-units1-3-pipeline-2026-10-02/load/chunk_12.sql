begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-038-v1','apchem-mcq-sv-038-v2','apchem-mcq-sv-038-v3','apchem-mcq-sv-039-v1','apchem-mcq-sv-039-v2','apchem-mcq-sv-039-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-038-v1 (seed apchem-mcq-038)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-038-v1', 'mcq', 'Separating hexane and toluene', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A chemist needs to recover hexane (boiling point 69 °C) from a homogeneous mixture of hexane and toluene (boiling point 111 °C). The two liquids are nonpolar, fully miscible, and do not form an azeotrope. Which technique is most appropriate, and why?', null, md5('apchem-mcq-sv-038-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Distillation, because hexane''s weaker London dispersion forces give it the lower boiling point, so heating vaporizes it first and its condensed vapor is collected separately.', true, 'Correct. Hexane has weaker intermolecular (London dispersion) forces than toluene and so a lower boiling point (a difference of about 42 °C). Gentle heating vaporizes mainly hexane, which is then condensed and collected, leaving the toluene behind.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Recrystallization, because cooling the mixture to room temperature makes the lower-boiling hexane crystallize out of solution.', false, 'Incorrect. Recrystallization purifies solids using temperature-dependent solubility. Hexane and toluene remain liquids at room temperature, so cooling does not solidify either one.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Separation with a separatory funnel, because the less dense hexane floats as its own layer that can be drained apart from the toluene.', false, 'Incorrect. Separatory funnels separate immiscible liquids that form layers. Hexane and toluene are miscible and form a single homogeneous phase, so there are no layers to drain.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Filtration, because the smaller hexane molecules pass through the filter paper while the larger toluene molecules are held back.', false, 'Incorrect. Filtration cannot separate the components of a liquid solution; both liquids are made of particles far smaller than the pores in filter paper and pass through together.' from version_ins
;
-- apchem-mcq-sv-038-v2 (seed apchem-mcq-038)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-038-v2', 'mcq', 'Pigments on chromatography paper', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a paper chromatography experiment, a mixture of two pigments, X and Y, is spotted near the bottom of a strip of polar cellulose paper. The strip is placed in a nonpolar solvent that rises up the paper. After the run, pigment Y has traveled much farther up the paper than pigment X. Which statement best explains why Y traveled farther?', null, md5('apchem-mcq-sv-038-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Y is more polar than X, so it dissolves better in the solvent that rises up the paper and is carried farther.', false, 'Incorrect. The solvent is nonpolar, so a more polar pigment has weaker attractions to the solvent and stronger attractions to the polar paper. It would travel less far, not farther.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Y is less polar than X, so the polar paper holds it less strongly and the nonpolar solvent carries it farther.', true, 'Correct. Chromatography separates components by differential interactions with the stationary phase (polar paper) and the mobile phase (nonpolar solvent). A less polar pigment is attracted less strongly to the polar paper and more to the nonpolar solvent, so it moves farther.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Y has stronger attractions to the paper than X does, and the paper carries it upward along with the rising solvent.', false, 'Incorrect. The paper is the stationary phase; stronger attractions to it hold a component in place, so it would travel less far, not farther.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Y has smaller particles than X, so it passes through the pores of the paper more easily, as in filtration.', false, 'Incorrect. Chromatography separates components by differences in intermolecular attractions to the two phases, not by particle size, and the pores of the paper do not act as a sieve.' from version_ins
;
-- apchem-mcq-sv-038-v3 (seed apchem-mcq-038)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-038-v3', 'mcq', 'Filtering a copper sulfate solution', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student pours a clear blue solution of CuSO₄(aq) through filter paper into a clean flask, hoping to collect the CuSO₄ on the paper. The filtrate in the flask is still blue and the paper holds back nothing. Which statement best explains this result?', null, md5('apchem-mcq-sv-038-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The dissolved Cu²⁺ and SO₄²⁻ ions are individually dispersed among water molecules and are far smaller than the pores in the paper, so they pass through with the water.', true, 'Correct. In a solution the solute particles are individual ions surrounded by water. They are far smaller than filter-paper pores and pass through with the solvent, so filtration cannot separate the components of a liquid solution.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Filtration separates liquids from other liquids according to density, so it cannot affect a solute that is dissolved in the liquid.', false, 'Incorrect. Filtration separates undissolved solids from liquids on the basis of particle size; it does not separate liquids by density. The solute passes through because it is dissolved as tiny particles.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The pores in the filter paper were too large for this solute, and a finer-pore filter would have trapped the Cu²⁺ and SO₄²⁻ ions on the paper.', false, 'Incorrect. Dissolved ions are individual particles far smaller than the pores of any ordinary filter, so a finer filter would not hold them back either. The solute can be separated by other means, such as evaporation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Filtration separates substances by polarity, and the polar water and the ionic CuSO₄ both pass through the polar filter paper together.', false, 'Incorrect. Filtration separates insoluble solids from liquids on the basis of particle size, not polarity. Separation by differing polarity is how chromatography works.' from version_ins
;
-- apchem-mcq-sv-039-v1 (seed apchem-mcq-039)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-039-v1', 'mcq', 'Diluting hydrochloric acid', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A technician transfers 10.0 mL of 6.00 M HCl(aq) into a volumetric flask and adds water until the solution reaches the 250.0 mL mark. What is the molarity of the diluted acid?', null, md5('apchem-mcq-sv-039-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.250 M', false, 'Incorrect. This divides the original 0.0600 mol by only the 240.0 mL (0.2400 L) of water added instead of the 250.0 mL total volume: 0.0600/0.2400 = 0.250 M.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.50 x 10^2 M', false, 'Incorrect. This inverts the dilution ratio, M1 x V2/V1 = (6.00)(250.0)/(10.0) = 150 M, which increases the concentration instead of decreasing it.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.240 M', true, 'Correct. Moles of HCl are unchanged by dilution: M1V1 = M2V2, so M2 = (6.00 M)(10.0 mL)/(250.0 mL) = 0.240 M.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.00 M', false, 'Incorrect. This assumes molarity is unchanged by dilution, ignoring that the same moles of HCl are now in a larger volume.' from version_ins
;
-- apchem-mcq-sv-039-v2 (seed apchem-mcq-039)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-039-v2', 'mcq', 'Stock volume to prepare', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student must prepare 250.0 mL of 0.600 M KNO₃(aq) by diluting a 3.00 M stock solution with water. What volume of the stock solution should be measured out?', null, md5('apchem-mcq-sv-039-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.50 x 10^2 mL', false, 'Incorrect. This multiplies M2 by V2 (0.600 x 250.0 = 150) and does not divide by M1; the product is an amount of solute (mmol), not a volume of stock.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.25 x 10^3 mL', false, 'Incorrect. This inverts the ratio: V1 = M1V2/M2 = (3.00)(250.0)/(0.600) = 1250 mL, which is far more than the final volume.' from version_ins
union all select gen_random_uuid(), id, 'C', '50.0 mL', true, 'Correct. Using M1V1 = M2V2: V1 = M2V2/M1 = (0.600 M)(250.0 mL)/(3.00 M) = 50.0 mL of stock, diluted to a total volume of 250.0 mL.' from version_ins
union all select gen_random_uuid(), id, 'D', '200.0 mL', false, 'Incorrect. This is the volume of water to add (250.0 - 50.0 = 200.0 mL), not the volume of stock to measure out.' from version_ins
;
-- apchem-mcq-sv-039-v3 (seed apchem-mcq-039)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-039-v3', 'mcq', 'Adding water to permanganate', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student adds 85.0 mL of distilled water to 15.0 mL of 0.800 M KMnO₄(aq) and mixes thoroughly, assuming the volumes are additive. What is the molarity of the resulting solution?', null, md5('apchem-mcq-sv-039-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5.33 M', false, 'Incorrect. This inverts the dilution ratio, M1 x V2/V1 = (0.800)(100.0)/(15.0) = 5.33 M, giving a more concentrated solution than the stock.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.400 M', false, 'Incorrect. This averages the stock concentration (0.800 M) and the water (0 M), (0.800 + 0)/2 = 0.400 M, ignoring that the volumes are 15.0 mL and 85.0 mL, not equal.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.120 M', true, 'Correct. The final volume is 15.0 + 85.0 = 100.0 mL. Using M1V1 = M2V2: M2 = (0.800 M)(15.0 mL)/(100.0 mL) = 0.120 M.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.141 M', false, 'Incorrect. This divides the original 0.0120 mol of KMnO₄ by only the 85.0 mL (0.0850 L) of water added: 0.0120/0.0850 = 0.141 M, instead of by the 100.0 mL total.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-038-v1','apchem-mcq-sv-038-v2','apchem-mcq-sv-038-v3','apchem-mcq-sv-039-v1','apchem-mcq-sv-039-v2','apchem-mcq-sv-039-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
