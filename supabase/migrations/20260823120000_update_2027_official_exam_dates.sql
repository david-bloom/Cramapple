-- Update official_exam_date on every published app.exam_pack_versions row to
-- the College Board's spring 2027 AP exam schedule. The dates in place before
-- this migration are all spring 2026 (already past as of 2026-08-23); this is
-- a plain data correction, not a schema change, and touches no other column.

update app.exam_pack_versions epv
set official_exam_date = v.new_date
from (values
  ('ap_biology', date '2027-05-03'),
  ('ap_calculus_ab', date '2027-05-10'),
  ('ap_calculus_bc', date '2027-05-10'),
  ('ap_precalculus', date '2027-05-11'),
  ('ap_chemistry', date '2027-05-06'),
  ('ap_physics_1', date '2027-05-05'),
  ('ap_physics_2', date '2027-05-06'),
  ('ap_physics_c_em', date '2027-05-05'),
  ('ap_physics_c_mechanics', date '2027-05-03'),
  ('ap_statistics', date '2027-05-11')
) as v(exam_code, new_date)
join app.exam_packs ep on ep.exam_code = v.exam_code
where epv.exam_pack_id = ep.id
  and epv.status = 'published';
